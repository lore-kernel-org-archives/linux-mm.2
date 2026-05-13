Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B96DCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BFD6B0005; Tue, 12 May 2026 23:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5CF6B008A; Tue, 12 May 2026 23:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD716B008C; Tue, 12 May 2026 23:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 832536B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:21:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 135C38DEB4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:21:14 +0000 (UTC)
X-FDA: 84760945668.09.89A167C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id C68FC40005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:21:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IASRPJuG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3SqJmSQf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gzR57fTr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XHY9HfyL;
	spf=pass (imf27.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778642472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2uARObael505esap0DzuRVLIv8YNqaaPaxSLuracHo=;
	b=2cpFmvNyAoE6vRCto5PjetbkQuncGzcaO80aSp+ESKTgOac8f7WdCMeItUTq/Nt1uwuhf0
	jhQSwhlrgkroWCJfqwBKwth9M6FzOEg4EC+tezXWwv+dvE4YJ3qWb1A+8552VtIQQQt3wt
	aq2SXrbNIXkohGU90rmhzK7eJoj3+0s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IASRPJuG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3SqJmSQf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gzR57fTr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XHY9HfyL;
	spf=pass (imf27.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778642472; a=rsa-sha256;
	cv=none;
	b=qkzcLKKuubNYf3txikUurY2vJW52qNdQEuRaUsBHUoKJZFqUu5UytuxevInZaOMFlPXEom
	8mMH4iyIMqK5AKtk4OGu3qjYotL00lPOxFW7zMPs/ldQXsaA3U+Dw1pjFN8WR5cNhPsgtH
	h9pD9utWQsYeLNByygLPCM10mgm6mTI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 845805CC1D;
	Wed, 13 May 2026 03:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778642469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2uARObael505esap0DzuRVLIv8YNqaaPaxSLuracHo=;
	b=IASRPJuGm0PuJBAZ37H/s5Rv9TxceLAN3TLZKV2B7eotlOS5Rz98ngyfdBmxsACH+z/33x
	wR1vbGIGyMrTn0v2OWlLnphXPDjV35XIF8Rm7Exh8wc+QeP8Iefy5nnA9IMarEsI0lwPQl
	oBybGe1RPJMZyttwwwER/9IRcQGXXe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778642469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2uARObael505esap0DzuRVLIv8YNqaaPaxSLuracHo=;
	b=3SqJmSQfFzAZVinVKq0esByAZrSjY3MYfhj3vVDcNI3hBuUjuem1CZwbx5mXr7DH5xKmR2
	jQ91ZTN/7k7UyUCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778642468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2uARObael505esap0DzuRVLIv8YNqaaPaxSLuracHo=;
	b=gzR57fTrH1oo2SMUBFWIn9h6HwDhs/CmOhN6Z6RA5d9+rGRSMvylqL1+ctk+F7n543HUv5
	p24GMWRhAsGtnp0DoPIKIG9VkkeYTsJ6N4765tb1XGRz2UkTbmNmy/jaPRGAta+5xBKRkG
	h7ymPoN1GxCf8u1rrhn6F7OMd/T5voQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778642468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2uARObael505esap0DzuRVLIv8YNqaaPaxSLuracHo=;
	b=XHY9HfyL/pZ8hAVeEE/YVS6aJKcpmxSVdOTC6bahZoQTHhWRcaR79jVkch1Y1V/bQQv7NM
	l0bI7Ssg/LI+UdAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28DDE593A9;
	Wed, 13 May 2026 03:21:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vSDRByTuA2peAgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 13 May 2026 03:21:08 +0000
Date: Wed, 13 May 2026 05:21:06 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare"
Message-ID: <agPuIviEgS-9wWqK@localhost.localdomain>
References: <20260512160643.266960-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512160643.266960-1-ljs@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C68FC40005
X-Rspam-User: 
X-Stat-Signature: qppbadh7sqz7cbx464shn4i1zbccuj6a
X-HE-Tag: 1778642471-184365
X-HE-Meta: U2FsdGVkX1/5JSV1shH/c+pUMG5z0kdzf6lYLo8/BRmJl81vsBEHhCJh9BIdtInpEOknT+2RDdBBb3jIct8ArGLOWwQGPFv3U5QhtLzQDp8RzROx4djM69YkbrOGuQer/mxaklvCUC5i2FJDYUpCbpJKGGFw8onYDURrcuaooP7L6HSte2UMnTTTp0iDo6sPuZ2hG7uFAobeOYVPRNaBb3rSLIy3hkEdTVkGsUwcIhJmstz8zhZwK55ZIH7EQU7jNfJeclNgTlVkyJso3dxfjSiSlj/CDcWsqEmwTqMKv6AAL29QhIsh/t639PsZpMo62wh16It0jbYtq+lip81drgpggb+DTB+iWV5oXPYDyO+28NvgJSqa89hZIZbUTqpbv9d1rfb9gK8bPldyH+KoK5Cz16P6OIwWDdctTi8h+Y2u/wWLqHGSh3AmI4Zbcm38CH5fTSGg+w3RheUpuPoGpfciR9xkhJfD26p22UQ2WiEVsL9DD6vOIgL6ubbTSm7+ZsL1SW9DUJHozUQFrZFrV1WKRAAl2yA7FwErLXlHePU1Q6nvNkO/M06kpnN0IJMJyp/As6PX09/m3KzNI8y3ZQJ3jOHZX5IQ1x1vphvwRzAjGPNrG2pyP2Jak9iOrsx5pOr3iCp3pUWG8fk1adcAXumJIIWpumhmPdME3owIasNPTp9+wfrqv0WHq6IF8nuFCGkXkLtwHdvWamjBGbemGT3Zz6C+BWi/V1qE6Cs6MtL3pctPdwT3PEIY/mTIQ8RcxrKuPd2rDH3wiLQ0RzQH+wh0U9sEYzocYSUTYcIKfO4m7AFzrMo0ZqNyOcyIioStvbckS1AmtZZkQKmoX/AtwYw08JBEcM2PZrH4/hXvDhBe+cylXg9l1mWXiCZ5rczwPYN0TpJSmUjVhlf+Rs/KAohJYXAg+YxoThDZ0naSiOSsvsgdEJfBRdFFVdnDsLETivje+g7K1XuX9/Jv6ny
 NVnLCy39
 8/BufjZNbBeYznCV6WI603lj5TwQ+uMuImKHkXjWW/KFEMVN/TijbVJEjm/oiE0vSYi1rGw8J/Ljnea7vYfwJwH/tnGSTha0w+biMvp8RDvoWN7BAETK7qHra7AkqhiaEPxkBGAeN1y98aqI3osu6zJFupjrvAGQ3mOaKjJKllMj9yzM942Pvo99bxNidiAcsEdeTjcvBuDZWd+s9K8tmPPz7xYk/l8PclwCT61bArWehdrHY8QlvlwpZazuzaCjfXCSXmlpxPM3D4weju5BOpNtCaDAGIMXSU246xgMLG2EZbiRwHOWl5GjZIIbciP5c4Uit8VNZ7ozj1yEsC5yql1rVALVcO5M0n5JpzgJOGFgkzRgW+wxixkAphw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:06:43PM +0100, Lorenzo Stoakes wrote:
> This reverts commit ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use
> mmap_prepare") with conflict resolution to account for changes in commit
> ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare").
> 
> The patch incorrectly handled hugetlb VMA lock allocation at the
> mmap_prepare stage, where a failed allocation occurring after mmap_prepare
> is called might result in the lock leaking.
> 
> There is no risk of a merge causing a similar issues, as VMA_DONTEXPAND_BIT
> is set for hugetlb mappings.
> 
> As a first step in addressing this issue, simply revert the change so we
> can rework how we do this having corrected the underlying issues.
> 
> We maintain the VMA flags changes as best we can, accounting for the fact
> that we were working with a VMA descriptor previously and propagating
> like-for-like changes for this.
> 
> Note that we invoke vma_set_flags() and do not call vma_start_write() as
> vm_flags_set() does. This is OK as it's being done in an .mmap hook where
> the VMA is not yet linked into the tree so nobody else can be accessing it.
> 
> Fixes: ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare")
> Reported-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> Closes: https://lore.kernel.org/linux-mm/20260425070700.562229-1-25181214217@stu.xidian.edu.cn/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

