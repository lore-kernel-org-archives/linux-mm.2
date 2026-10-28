Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984AF60A3822
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7D96B05C3; Wed, 28 Oct 2026 11:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88606B05C4; Wed, 28 Oct 2026 11:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977D96B05C5; Wed, 28 Oct 2026 11:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71CC96B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:45:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5367C014B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:45:05 +0000 (UTC)
X-FDA: 85372458570.28.6C09BD3
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id E55AB14000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:45:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kAyiW+KFQKAgCRpnXIGSIMyble+GIVr5acqZvdm8duI=;
	b=LzKznsB/5Xk2rM+gnhe/yJo4alMZfW7+lEmzl8EP2YGNtKMS/wfWraf6cyTW2UPMahDURn
	2ksPOA9hAjU/CTrOnQ8KoBXWmbJ0VMsZZqF8rOs/Ap6jExpubqleiHi/q4dvaREcmpGkrl
	JrchnGUBytFq4geWooJdDIHtJPI5lNA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202304;
	b=mSfE5opWRL373m+xkK3VVL4WopRNblqSVQJOXoMpzaFsaHqNodgVRapFWEs+Vyb6JY2TLP
	4b42ZQ4V9I6PN+CMNKZmY8XbOfu5ts180fTurNmhAx1siYjAV+BYR9Z1bJSonv/BDjW7Gw
	EZzQK79/UDYXToAKwgmkQtJOnj4dLTQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B31C68AFE; Wed, 28 Oct 2026 16:44:57 +0100 (CET)
Date: Wed, 28 Oct 2026 16:44:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Harry Yoo <harry@kernel.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Vitaly Vul <vitaly.vul@partner.samsung.com>
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <20261028154456.GA19025@lst.de>
References: <20261016132510.789715-1-nickolai@csail.mit.edu> <atJBK6hWYh2AqXwK@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atJBK6hWYh2AqXwK@thinkstation>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: E55AB14000C
X-Stat-Signature: g5g6ypnfsconodtx1nucynrb8q4n8i3t
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202303-87145
X-HE-Meta: U2FsdGVkX19EtgpK/ndY1IcbXcIZmYlFyJHLgvA8tzs/tPyVev7O7jZaxP8ev7CidEg6/zV/ElMKTEdLMK0dfiQowDdMez37V3N/AN0//CvkQh8EuGQOJBQYIHx6KuGl+R23iil63AuQvDqVt556FnG1zL6uHCGETAIg2NSqkqEtNrt5KR+FH2M1qtg9HN4vFNTyvLl0224eNzIsE8h6sMnX/DlvL/eWNntqeVjVlxBalAEdat1cbOB3ZoLPIyFEW4i3LUzvkDz25q1Bi0ud9sIub8lXyAoW68xdrZOnUbENpRvQX2gt+XTS0lopiA70dxLoj3Oa8aBOQ0NIhPPPkF5rqxFR8I5PzP/yonypHbhkQaOnHcEdWCuewNT/BpfQfvr5QPGgyhyu7Oo7Xxr1vBP5j+/QLjZY/lMisGvB5IaCsK1lmSzXKrq5+Af93bc4ELBsVDy8wDMCEoSNYGl6RMAKcIqfIpDlcfx0HSqFoqKLFzi5/F7mjuwr0duoMCV0WvQt8VohNRl8InuCajZDoXTi5Pf6hVlagB+g7oV9nBpD0ksJGXz+vR0+DprotVlT3u5obhqmm7OImAgBL40h5ua3mmsqHguK7WEvyPfLN/YHWCWbU5a9KkSUCyDKWpoi+TFQWvxVRy+V5+/DKLUrbHyo8ngUQT+9NKspCCXWCSHYLWGIpVZOrUC5feRUV5P503HkPh8UpKrIxS/YB6IMA9aajsmYMRyPCe8o2VC3Ywsdkli2IPPUtCWBDCVYfwte85fiBO5NUCGVGIKJ5Ojk+IKd3yjXk/SwRBhqRDsRtl+OK+3OgOLaaFTX9H2Y1gaLo/kiOFbP3zVMtfj5+sWVSIPZ3diBXXXLyTwAzwXR9bzz1n3J+NeNQzIA12bigGwqiasx1pGrW0aRK1VsrJHZLZiy6i3X1eJmR9I2TcWxrrChaOiOniUgQCP2H08Ym053LSqBv//51v61fV9vGka
 kyxC8Tfy
 4e4143dA1V7KboI7M+EzD4suJeYDBimDG41BcltjXoglrYfS2ZR7FaNWbfLrmGdsaEO6MJDx1bM+dA88QDHwXbcQ801qNz5Tx6Jr/nuUdRmvH8XpDj0L+Fo4COhlkXDANM4qHbpxEBWtLeiyYCUXjuZRq2vPTKUTntrQADQmR1ltuija5i2ENGVdpBjoWV1+oCsn06cGJyqMOgug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

and I'm a bit surprised that someone folks later in the thread still
don't get the basic idea of separating fixes from random "improvements".

