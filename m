Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A81ACFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D46A6B0026; Mon, 24 Nov 2025 01:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC5E6B0027; Mon, 24 Nov 2025 01:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110C06B0029; Mon, 24 Nov 2025 01:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 025286B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:14:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 315A012FA63
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:14:25 +0000 (UTC)
X-FDA: 84144486090.27.6F43759
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id 42B024000E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:14:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763964863; a=rsa-sha256;
	cv=none;
	b=Ki5Rk0vppOTJqErjuxuIz5RsgbLWd59erf44smpsHu6K/QkOg2iAVBxtYuALYjWVZ7gL26
	ZCNj6js9qq/vzfzSDezMHQSgLPOAIYP93MlxxJ2tuns3EJegHO5tvSPq8arx1u5RdlrwSi
	p8eYjBYdJKGU7vl+r/LVTj0sZPqhwpo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763964863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xfSBdCnm0K5aZ79phhQwQq22U9WIoQw5fuh0VLlquj8=;
	b=YAthSWlrgttBP1a2MtaRFR28hnmyhVlBy3ngI9It8rmRUQrJ//pjcOW+emNz8RBYjrsLe/
	QMWgiISIRYhlbi2WaNjTecEquxZFTPCyy94pbPrMDizrOV9RMAagS/FwXqS3jN+cE3fcKG
	8jw6SiSHw0vGip9AFX6vAVG+uUdPTV8=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C60A68B05; Mon, 24 Nov 2025 07:14:17 +0100 (CET)
Date: Mon, 24 Nov 2025 07:14:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
Message-ID: <20251124061416.GA16260@lst.de>
References: <20251113084022.1255121-1-hch@lst.de> <20251113084022.1255121-7-hch@lst.de> <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 42B024000E
X-Rspamd-Server: rspam07
X-Stat-Signature: wp7ntdtaosee6putyzpiswmekw6yuj7a
X-Rspam-User: 
X-HE-Tag: 1763964863-486202
X-HE-Meta: U2FsdGVkX18H6yx9mLSpdE62gzuKVmg1xLIQMO8/BWy4j+bI5cb3c5lRgBnwtKKBF8NZj2Hlv4Xb/4t7dmRe1MBTP4XuNl+Cg54Av8Ir7JGe98o5L87ZO9KNN/ZzSAFUDrtQPGX06bJ7e6OOiBuAkeoPYOVCfNquaK2f1cNvvF5xcby2dV3APeLMKSCi/BRACDpcqxN/wzR2U+2QPUCf5eOLiBuv9KstUNALybDfOa/pcsr8sO6y+hpGUT5RAlwmEp5ccNHHRn9ftx/ng66dd7kbt0wZ1Su3xdES9DRXnVqKPwyTuYIl65OyH38AmuWpCEwzbKtfAfMUlxMUbp+pJmOTi3vvVh1cT6bYT4560bjYMRxas+VBXQa2YA2ky7SquSRkzcjM0jOX8/6C7XiD9lQi7Mh4j+OYSfjoqc4LNPzpTiKyukznFJ/M/nf7p8XTgZZL0zVnciMj5bBOvp+VdS0MBfCRAuZZKxPBCjaf+yORBpYhppk6V+AAgS931xfwzX0cbzCis/WpRmkWvaSMWdS6i4LZy5FJ/Lz+odfXPmLWySvy3yPxbgmrIxBzySGt/ktfGI3u14rN5eGspBNAE+Ya17RlhKjPEh72DICsh1NFrV4BEFgt96OXfFkJWqTlf792d0eeimGYuffFfe7za5r2egcEPjxmwbk6QUMjkLEOfMf+esW5XRZIKtwajUdVzgvbY1O8DWnl3KqpqWF5KpmSVKr/Ac0Hvl4JH741wI78F3rm52zWKaVlAalXDKMBEzGffkP4fvoctUGBmYB+KWQyYexo2KhhJkQZFXclGyFgZKzkqpUIkDTrXNWpGSzYskirwBTUj9BLWl5oe1Z/FVLXmSgAkbpN78CSwKOWLS98mz+hmZWIj0j8gi471K6rzeofoneyGZ6/heV77kzygyhRZC4EakFE9TkLRahYbMOsjHfuYAumIVi7yBxouZA5xCWYk1ogtHDc+InZJsW
 xCKmGD9v
 fhUK4GyU/hVNjg35LU/HibMo7t4JwLkysMsK3Yj6z2fxlcJwf4/XifaMkAuwgO7utLQXrZla8m4yJ+Q+/O6d4FpzUsUiW1jBX1aBKHuabyEuJM1TcbuJvdAfBNM24tH6NPLpa1VFMhrRYupdn77LtBF5Zokt1D1af23YZLNKTm3MkclKkCLicGoV69Eju12FCQkuorcC1gfgZd1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This looks good, thanks:

Reviewed-by: Christoph Hellwig <hch@lst.de>


