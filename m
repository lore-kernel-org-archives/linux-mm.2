Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374BBCA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80DA28E000B; Wed, 17 Sep 2025 04:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4EA8E0001; Wed, 17 Sep 2025 04:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4058E000B; Wed, 17 Sep 2025 04:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53F438E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:18:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C85091DB16B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:18:53 +0000 (UTC)
X-FDA: 83898041346.25.0035F27
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 988DA140006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:18:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QKy9gYy1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QQ98NDyL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O9pfrPeR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TWhAn3zE;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758097131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gIuU9BfAksM0VCnmAs6vvgKEo+iRNtzKZCzt55LcHE=;
	b=deP4gDrJmcTRFeRnKhnKm2aO3Xb+lzbfNyqGBniehxseeh8Ldl6KLIo0sqMV4T1gOm9Btw
	FLcycczzs7l+g0BTXGqOpvIpPPGOn339qXSWSYSm6momsYHx8pX2Hr7+xEoopfyLpck/BQ
	m+zkS4+5WVXA2uoyLofAeNqaDLnoL04=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QKy9gYy1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QQ98NDyL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O9pfrPeR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TWhAn3zE;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758097131; a=rsa-sha256;
	cv=none;
	b=Ql7euNTs//BgKYYU2lmdQIRMV3VWmifhy0ESYIVMct0HQCNe7vUdeUcPMcK3v4pIyuTiG8
	CltVOdoSrPvBiBP7RQraEgAU1OAsFzEUrL9zmoAPG+EJrcDB6S+FK/SZ9kAxcjo0GT75JF
	zhZZkwXfIkqlpx83fun/SGIDaPtxyzU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9EF9221A4;
	Wed, 17 Sep 2025 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758097130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0gIuU9BfAksM0VCnmAs6vvgKEo+iRNtzKZCzt55LcHE=;
	b=QKy9gYy1ComwTc+vQCBzK3bAN4dI0pAG2Q3EfLESztOs+tFGBj0U8DAYF1TqSK4Jpw7V+U
	T62o8AE25X3FktxqSp4KPYalsKvs5STJLZK+VvVuSxE4u0uewYMaVIVgWgmJdzrdt+MRT0
	F2Nlk4lHnWqGrzIOchrkGY/UB1CJANk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758097130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0gIuU9BfAksM0VCnmAs6vvgKEo+iRNtzKZCzt55LcHE=;
	b=QQ98NDyL4IE5tPlNNPIwQyIjn4gEX7IDvrZR5d58smXRM3ZBwOfvSQDaafIavRKF4/3i8w
	VVi2GX0dnULrtwBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758097129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0gIuU9BfAksM0VCnmAs6vvgKEo+iRNtzKZCzt55LcHE=;
	b=O9pfrPeRKeta0cqOznkr0QMpC4z2NnMdlI88YFcDhieFTcRoAJ/t+qciFLBxCp7d0L7gHx
	GXOUDFc3yUodTyutNxefB2/W/GRo6ynt9drtotTOIhYOewFOf5zshtGKUCBUlGBvvhhpBZ
	qgvG9DPoTBkvSa6+4EsUb/CFh7oB16U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758097129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0gIuU9BfAksM0VCnmAs6vvgKEo+iRNtzKZCzt55LcHE=;
	b=TWhAn3zEp97BkxWyLCYfe2R+zA/uCSQ9cg8Ale7wGXgldTdEbRYPVq5rAvexdSBOJ5Il1E
	p6I64rVvp3X7APAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 156621368D;
	Wed, 17 Sep 2025 08:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tmJsAeluymhZBAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 17 Sep 2025 08:18:49 +0000
Date: Wed, 17 Sep 2025 10:18:47 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@redhat.com, harry.yoo@oracle.com, liushixin2@huawei.com,
	muchun.song@linux.dev, akpm@linux-foundation.org, jannh@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] mm/hugetlb: fix copy_hugetlb_page_range() to
 use ->pt_share_count
Message-ID: <aMpu58yNnLWszoqX@localhost.localdomain>
References: <20250916191252.1653993-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916191252.1653993-1-jane.chu@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 988DA140006
X-Stat-Signature: 41q5mse6mx415d6gc19xo3gya71153z5
X-HE-Tag: 1758097131-713283
X-HE-Meta: U2FsdGVkX18SWCuM+gZ5VQLq0PkKFeNnHzdm4ETGE+q8Gc3BT2S74Yinbep0E/VkPRWWuwr1yIi0ib6nPejWQl4gymeECRKazzNBlcvJ7Wc5nNr9gAVVILsbrAh67P3HB0ewVvD2toWawZYYwLi4CRlY6KS3cCTpQvT9PfjOmMq9TB8f9ym1EUxHVpF5MdqhZgf3ZAM8DNclCI49dgf4Amad5kmcIgOezFhCbLmZ3kYzbXM62LCpM27kzsUbAQimHIaw4Vj5Z82nve0At/T/iBz8ksTS+27wgaURJaPXXsrwAdQfK7uvaVTe6huxPhhUyOEAoy2tvlScjlnhDzSo1z3O59Zs104FcdZDNV0vc2R5rdqvXOqO1LFk2XrJDUuvi2AUpv6/0RebFteNYAPukBlmtDbigXY3VAoVt8S/idcU5o9mdRWBEqcjfCUwsk623rqnisRTKFKXMtQi+E+1jHHNSTeNoMlBjbWKHKOo0rrSHkPdbI+NzUjI3nuEPd+FwYUzqqOsk9M0PMdKubqIu0S9NeDpyTWMQIjv7HJOas6HfJ2OL9jcAynYau83Ev4NXB5VUfpYEVz4+Z1Sj1dh+qwLP14wv74iyuAKKf3tB3xYZFCR7rGuZzfKTxuYDFPVqrMOjqzEURWK8CVyut/SoRdeHx/SRzEKR+NLNFaQV+3ku1qfJxp5KE2XDwo1hDFPzv58HIZvr0VI7MPy1AByNOwKJjM7fGC2bdm7QD/2rxJF0pyryGFz1bq4lPeFO36IH5bl98ulOgDzWCJU+4MGKRx3D+AQggcU29PB0VYTD1DwEbbQIN0JTcYXH/EEiect5n8uEwNVulr8H3K6JL11zM40+ThWrBMkzCfkXHt1fRc6oBzzjn0VxiNLE2zmta3psO6HqI7jw5R20cbaNAD804fVDj6q518CoAqNiYituMHEHadUvTs1pIeRd5/Cozt4cRUpvXGDSkhnFzByoVk
 TCB+WeQn
 QL4XLEvvI493pkTgXMBibASUi6zlu2MRY893HYNwgL9z9ck+7w1UjPIZTKS6+3zUXX1ifgXCWEzjHtEDF2UDQ6S5apo/6oEo0LsTxMfpoIsV8fDAsy6ZoMRZaS5kqhAuQz3lgGvFaRg2tiZE979r5/747YAgy+nCLY6+bWvmYZcwltqg6Wr+UFWLmw895BImrwJSvTESDVDI2d5duaToUPKvXkf/cvudvkYGwfuxvU/x3W6pUyANT2K3uQ1u4x+4l6LrheJFFTl2cazswzHehgm5tVGd+Hdfvmol5aRDJF5usdLenOBG8P2yNvtUSD+cT9bxLdTAJZeeRJzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 01:12:52PM -0600, Jane Chu wrote:
> commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> introduced ->pt_share_count dedicated to hugetlb PMD share count tracking,
> but omitted fixing copy_hugetlb_page_range(), leaving the function relying on
> page_count() for tracking that no longer works.
> 
> When lazy page table copy for hugetlb is disabled, that is, revert
> commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()")
> fork()'ing with hugetlb PMD sharing quickly lockup -
> 
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> There are two options to resolve the potential latent issue:
>   1. warn against PMD sharing in copy_hugetlb_page_range(),
>   2. fix it.
> This patch opts for the second option.
> While at it, simplify the comment, the details are not actually relevant
> anymore.
> 
> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks


-- 
Oscar Salvador
SUSE Labs

