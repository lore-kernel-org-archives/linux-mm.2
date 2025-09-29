Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26307CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 09:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31AEB8E0014; Mon, 29 Sep 2025 05:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2C18E0002; Mon, 29 Sep 2025 05:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAB38E0014; Mon, 29 Sep 2025 05:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 043A78E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 05:27:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84920B6910
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:27:34 +0000 (UTC)
X-FDA: 83941760028.17.6871091
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3DD4F1A0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:27:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkgRotVV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C7v1FoqY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkgRotVV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C7v1FoqY;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759138052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THAGxl1trzNBHfjS0/K74QzBCVdosk64YkSPhfoLeBg=;
	b=iNjmsfkOPapAeyEhrMBN4Tsob8132WixRrYyUAJsJKGpjoLypVuBgGDZ/VnOx5Jbv1hsHh
	CkiSvIOftyOGzP4tiUZog20NVpQzaPliAdBV/9DOXFC7OGCJdO8fFkxKZEypHT4t8rG9Gd
	2PbMAEsY6vRiwpLcP9HZzdukwUDvrtk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759138052; a=rsa-sha256;
	cv=none;
	b=qx8Cr6WfG3KWoWXL42w1iB8QbsQCrOkNr0jycGVpoHIqThvLc94vEt5cJ8TN/6IUulo+Kb
	3ay+g65dw0ExZqURv4R7Oo5fVjUQeJkhQvrakU60rATJYAUqGwSuJOETumt5YSoCmQK2H+
	0XSd7cwGT0mmpcbCEq/doO6bHHTYscM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkgRotVV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C7v1FoqY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkgRotVV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C7v1FoqY;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3922E2099A;
	Mon, 29 Sep 2025 09:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759138050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THAGxl1trzNBHfjS0/K74QzBCVdosk64YkSPhfoLeBg=;
	b=bkgRotVVMBWn6oomD82XK13KXxaLnMiyRpu5U+STT7FwHdQh4yaUREvUo2XPmYR8P61Y86
	KoQK5dMP0GG8bz5e22YjbeaEdAgtQeeLoBm8eXBZ4wtmtadXc7sGeXoOnyRqFUyTR/U4m5
	mPqvjlrFbxc2jo9sRzoPEAmjA7s7NnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759138050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THAGxl1trzNBHfjS0/K74QzBCVdosk64YkSPhfoLeBg=;
	b=C7v1FoqYE59RN5ryAIF6wzn0ovidI+j/mVDXSdP8PTXrizDKGI9wi07tXmoTggbv8abPHV
	TlYrovP5EuUOUkCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759138050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THAGxl1trzNBHfjS0/K74QzBCVdosk64YkSPhfoLeBg=;
	b=bkgRotVVMBWn6oomD82XK13KXxaLnMiyRpu5U+STT7FwHdQh4yaUREvUo2XPmYR8P61Y86
	KoQK5dMP0GG8bz5e22YjbeaEdAgtQeeLoBm8eXBZ4wtmtadXc7sGeXoOnyRqFUyTR/U4m5
	mPqvjlrFbxc2jo9sRzoPEAmjA7s7NnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759138050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THAGxl1trzNBHfjS0/K74QzBCVdosk64YkSPhfoLeBg=;
	b=C7v1FoqYE59RN5ryAIF6wzn0ovidI+j/mVDXSdP8PTXrizDKGI9wi07tXmoTggbv8abPHV
	TlYrovP5EuUOUkCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F0BC13782;
	Mon, 29 Sep 2025 09:27:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yposIAFR2mh0SAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 29 Sep 2025 09:27:29 +0000
Date: Mon, 29 Sep 2025 11:27:27 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
	catalin.marinas@arm.com, will@kernel.org,
	carl@os.amperecomputing.com, cl@gentwo.org, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with
 PROT_MTE
Message-ID: <aNpQ_-uwp7gQDH__@localhost.localdomain>
References: <20250926162034.1785899-1-yang@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250926162034.1785899-1-yang@os.amperecomputing.com>
X-Rspamd-Action: no action
X-Stat-Signature: 76pfsykn15q4dwybwwwsat11rss6ty4o
X-Rspamd-Queue-Id: 3DD4F1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759138051-337882
X-HE-Meta: U2FsdGVkX1+TS9ycGmAlzRjGGoKW2tlw9eWLwdzHWutFKY4zKXfa5h2Ragt2I3HnGAzrWdZa0QGPjOyOssgtfYlkN+Nzqjzl9f/ZIe0Fy5nltDFMVFmyG5nCvWJbaETrb/0S3mZS9WVGb1PZ0TIVv+7/JCUhLCcalhK7TjxzJnqowChb5qmomsgZWnysRxw6PZQmaHaHyiA+SOCOTiIKg5EAEjU1r21h9gEaj/fq5AoPdQxGFH8SgjMjSweQwIqP/4cjWcpq0nfs39VwMOLrOFi8wrHoKp2HhRpX2XH6v/gljP2rEen/1NAR9nVqWRyW6bbz089Bw0g76t/RtfwgXMKSpgPj6AYtcc6heTLXf+FOFhs1eLyPepG0jZZHPDAcz12j1PbZS5lfOPQu2sR74ux4r+p3c3D2y5De7oKOLxM8PPetqPLtALpw7pZG/U/jeHj21ILSXaZ9lazFMLukcrjTPEhiMYwV0t8GksO0v2Tv6aYezNBtR3oJCmPER3zZNorNk2oCOC4genpdhWjRTlP2Px4SzWsxfn0a7DJs8k27SKMNC/QkcKqtWgzVtnUOUW4zGRRupt1KY+yjctDHeeIKGMlyJC+2F+vUshM2gPE0Imta0KToV3aQFnqCY3kNzARJWhU36XxWbGBACZCMeyEvDhxzSCOx52RvaVVCdofr9u/yh7MmyFal/tXgxX5iKhzLG89bATr8OaXp6a3fJjFT70zZOBixrd+TaTjXl09eTqt+jHSEl6mTce9/mxnwoLu/WhLzPBo3gRChB6TyVl+TtldzI3kuBfHA8qW5Kf788rjslY3u5UELxVV8HiKIwHmQuABXamBMVH2l4z0PL/J18gv47dIGp8436CoB0q5LHR+j1d7NPHfBgv0zpI3kpdf2NwyFIScuKEi3P9whvruJl7YtxKaXPvixMowJE8jOJygXq1xWiV4rBdQ+Re/cxBU4XBn92x3CCWp5OYU
 kVbX5TQg
 MDZ6OYbGH8yD25Ib2Xh8GzT2SpcN5/C4iRQLmFTUzEXNs38F+Fg74X6W5GqS3SlH3rre1dj+9l7/KT+miJeFWJ/PBr2Jbryj0yg5yCg1lvgAPSKXLZUHvRa/+WJRchfESU/Am1JUVIJvJjXzlpHaXFtPFsl4cbKXQrx6wGPoYk4TdA443cXQk0eGYrQQzFd5x8hJo3XHtomw05Qifyd5yfGjKn9aSgp9o9PnQPnfMoB7AnXloISpp/JT5I6H2+CSuSiZqpCafOLsz4GveF10D/7ncrffoNJ4zi6VMTUV8y98gP2h5ri8gF9akkpQC5Xd+lp6Xh67SSx4W3JqLDFmAFNpXONF3QyhG3U62xRCoFS/etIpI+jl/wb/JusPJMAiYiaLxe5yMeZaasXMFE61VuRxw7sQx/GtfKSdU34N2lZBYXclt638gd5Qk7aKvHMrmYB1Q1hRDqKobD9ey59fGR7WEcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 09:20:34AM -0700, Yang Shi wrote:
> When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
> for every single page in the affected area. Soft lockup was observed
> when doing this for large HugeTLB memory area in our customer's workload
> (~300GB memory):
> 
> watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]
> 
> CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 6.17-rc7
> Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 5.4.4.1 07/15/2025
> pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : mte_clear_page_tags+0x14/0x24
> lr : mte_sync_tags+0x1c0/0x240
> sp : ffff80003150bb80
> x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
> x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
> x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
> x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
> x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000
> 
> Call trace:
>   mte_clear_page_tags+0x14/0x24
>   set_huge_pte_at+0x25c/0x280
>   hugetlb_change_protection+0x220/0x430
>   change_protection+0x5c/0x8c
>   mprotect_fixup+0x10c/0x294
>   do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>   __arm64_sys_mprotect+0x24/0x44
>   invoke_syscall+0x50/0x160
>   el0_svc_common+0x48/0x144
>   do_el0_svc+0x30/0xe0
>   el0_svc+0x30/0xf0
>   el0t_64_sync_handler+0xc4/0x148
>   el0t_64_sync+0x1a4/0x1a8
> 
> Soft lockup is not triggered with THP or base page because there is
> cond_resched() called for each PMD size.
> 
> So add cond_resched() for hugetlb to avoid soft lockup.
> 
> Fixes: 25c17c4b55de ("hugetlb: arm64: add mte support")
> Tested-by: Carl Worth <carl@os.amperecomputing.com>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
>  mm/hugetlb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb5c4e79e0b8..fe6606d91b31 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>  						psize);
>  		}
>  		spin_unlock(ptl);
> +
> +		cond_resched();
>  	}
>  	/*
>  	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
> -- 
> 2.47.0
> 

-- 
Oscar Salvador
SUSE Labs

