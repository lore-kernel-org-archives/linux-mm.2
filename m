Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520D4EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CC66B00A3; Wed,  4 Mar 2026 08:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BDD6B00A7; Wed,  4 Mar 2026 08:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC9F6B00A5; Wed,  4 Mar 2026 08:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 817116B00A4
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:41:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EA221B8420
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:41:56 +0000 (UTC)
X-FDA: 84508493832.27.8AD43DF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 445FE140005;
	Wed,  4 Mar 2026 13:41:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cd5iyByk;
	spf=none (imf23.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0TVsxPotofUHITY70zCKKGc2w7JRgEPcs5hoEtoJ8U=;
	b=XwlZpG90yISDWxf/lki4xZe8kAK4NoLsqkC67mbg5t2Q+3GdmNy++vbXBtJdo2tLJYo7MV
	i/LRLohxgtFRx5y1ueDMkfe7qRYmA2r8NA9NXb55oyOTfwsdqJVUiD4wWI+VFdzyHRcdIJ
	6XAih7uiG18jc+HnkWuRGxt615awrSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631714; a=rsa-sha256;
	cv=none;
	b=Xg12qDHEVv8N3o6JjrSC8zyo1HEVqUdiBF4XAZdrxmoNVyV73xZJFs4vKwbqfa+yoexrR8
	6t+dTOKxrlJYg0fRa4nk3QPTVzZfeJ2iNW3KBh3Hagzu7Pd6xvvs/ORcTEHd33lp4uwzA6
	53mDkGIfnkiyuVZxK6xRk6bowdB5yzI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cd5iyByk;
	spf=none (imf23.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w0TVsxPotofUHITY70zCKKGc2w7JRgEPcs5hoEtoJ8U=; b=cd5iyBykON7MtCkmTuA2fxz6N+
	sRrRQbJGIreUITx+yGXBaJah4d0KTSszKUJqfiarfchCo81YDMCwTJhiEAX2FuG4F5U1LQnG5cX9k
	gN8cAsZbj77p610YmQ/Sbks35bGhsk/JY+AYAPJOud+CDWm2I8AURLTAZcU8naJlgKyTXquYPZWUt
	I+IT6WxxqCrOxUm8nRtEUSHe35ockE/E39cGKS5fXthlkCuZREL7igrsZeD9xH7vTn/HO4yb20XK1
	HNl/Oqai0dWBigM8bROs5iV99RFPzE8rWtNCrOFIppUiYW2WRJu6om1PQIoK81mRyByCsBbLyJqEX
	x+dI0VSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmU1-0000000HGe2-2K0m;
	Wed, 04 Mar 2026 13:41:49 +0000
Date: Wed, 4 Mar 2026 05:41:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev
Subject: Re: [PATCH 19/32] ntfs3: Drop pointless sync_mapping_buffers() call
Message-ID: <aag2nTROMNra7t6l@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-51-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-51-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 445FE140005
X-Stat-Signature: g979oxmydy1kxq5uezgy6yxi9odj9dr8
X-Rspam-User: 
X-HE-Tag: 1772631714-776899
X-HE-Meta: U2FsdGVkX1/p2RAQQLdE6SxBCS3eR0EcwpRcPjlK2uzs3vM5gBjtkVR2nYeF9umh6fF8I4rn+szTcW3drn5reUsO0E4MWorIj7J8fm3XynXuO6eXDWQw1OQ5f4/9EThV9HiHw4LjWEiIRxaK8PffV+lyYn0qcmXVoFwAAgk95GkdIym0JbZnSLDBU7EyisH757m6NC7QJzrMtLp6mCJwm+bxbwip/NnPlNLF9Fm2fK1o/IzvhknrIJZ5m9CkEa8BDqUpFZwJxHZYDC+aH+ltMnkDb2J9+iJFewIwwJShMavOIfyuH1YKy2Sfn5eEYZ4PYbP8yyDArfq72tNRHx3B9R7NstDsO0nfCns7yb/Ou+Jx42HpNL1+GgiqwrCUhBDyfkiIQtfrRTIrjvJffxWVH4Ia1SuIZdZVhRFkxdHjwtZ2vUFxgwD4V6OR5WS8WYWcq7uDwaJ/voHKFDCvsZ2X8Tao1FcAWAvfr9tSWo8W6zmooD+MrUnBgD5gy6abWvvkbVechhRURXcc1lWnuzOSVKKW2/we5wEnTaz4hGNmec8aisrpw1p3/nCjBDHSF42kmEe8ur+XXa8TAjthfYimxufjFKsgQC4Illyob0T+erCm+qADoOxPG4POCbUfEhZMT1k5I5P8un4Z5B3XZg0yc9kuVOycoPUncNLu9WWMkp3xhT61DZ62ljlx/LDfkx4v6Q47cOdfr6b8T64w9n240ctpORQQ6fRze+oKVQqWaMCx9CeD456RJKOowgKKFrnoq4gPSFlRKYw1UcQKr1CB4ARZ5T6il//zMbITg8PPCz1tG51CDEISFkvI1VNf+CQK8gg3GfnjmnbZFtIQ2QGwxuklHDNRoaWgFym+SxqlL0RZ/5KFHjG2E+6cdvB51qMweVgfnrKC/xLo0MCJMyfO7OZ0C/Axw32OVgT9IQ21TiUnvodRLRW9w9blUxxKFh77JI+6HlWfo5vkic07OAE
 P5CEOhms
 rdH04zjJteoNEeUnV6AFDb2ak7pU2sqUkk+H6OWE6pG07VvINgYL0DaYgb/CFDdK7prJ4bK5eteRHojQdMwA6wTmjYeEnyA1GAne1MYfjhBllViG3jStsT1PvhCGn1hL91qO+uZf3w9swrEAy/jGcduD5kfOXiv+PElu7JFwvofOlsbhXXRLPDvjFOKrr5owmfF5moBg9Z8tWpCTo2DykLA34fDefcYgY3VvMJragIYNWhYbXRxWXu5Ha/gxRKlZVJ8A1cFdY/cMx7ePuppzaWQk4UgiTBr6MmR8/nuhYY457HteOLNA39vzmbj6LYyvLq4d8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Can you move the various cleanups that don't really depend on any of
the refactoring to the front of the list?  i.e., drop all the useless
code first before doing real changes?


