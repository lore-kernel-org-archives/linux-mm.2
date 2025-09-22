Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C48CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E558E0012; Mon, 22 Sep 2025 04:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0560F8E0001; Mon, 22 Sep 2025 04:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE3F8E0012; Mon, 22 Sep 2025 04:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D49BA8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:45:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3E7186D99
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:45:34 +0000 (UTC)
X-FDA: 83916252588.25.5A67917
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83A7E1A0002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:45:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ti7f5tS5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=31CK8I0F;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ti7f5tS5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=31CK8I0F;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758530732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLHAegiBJpKwn0b43z4Vx4FeW68uea3XgoC2pxtXxfY=;
	b=YHUBQ/FNEwUwnKt8/1ANyRgHTwVnXkN91U1rRq7JrrZKrMJ5AtHsrMQR1WB5FlKV+zN/KO
	ZrHGlCntpJ+ZvHnfho7EG+H4wXfEwfJDotaXZDhwXhNgiHK/NZ/NalhXcIdepdkl35DyXb
	OL95XKxZCWT5qgxsTI71/R0NSEetSbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758530732; a=rsa-sha256;
	cv=none;
	b=xu3zxhLe1xLfRzablcllvyJrq7RJFN4V3ItfjFCG14M5zrRne44ZnF9KqnOAaP0ItpwfoM
	vdkGI4ZQfg/dIMSzTBdsVoyfeAJrwDgrtT0nVWlfDgg6LADfprSt1ddLmxq46PmFFMBvt0
	XldxCudpQmL1pSk2BXv8dljCBBs65mY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ti7f5tS5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=31CK8I0F;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ti7f5tS5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=31CK8I0F;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 08E4022158;
	Mon, 22 Sep 2025 08:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758530731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLHAegiBJpKwn0b43z4Vx4FeW68uea3XgoC2pxtXxfY=;
	b=Ti7f5tS5D4r6CsJ87p20QxeXhiSNXPFrcI1iBdz6QXLoD/TPd0RVUfy/bFxXpWMUPKHE7r
	xFBV6NOwSLXXs7E168DO2BTB4tWSpEvsi/Yq3CtrNvIeCb+BtQ/kB5y3ydhAmkXiO9bmRS
	c4ki8OMIq8I9pvsP4HFkZMpStXERPe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758530731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLHAegiBJpKwn0b43z4Vx4FeW68uea3XgoC2pxtXxfY=;
	b=31CK8I0FNdLbd/LZq201gieA0eodPpAfH7p0LiGmmNJqQlphuANM3vsovdxKQsm6vPdSBn
	FmkjYn+xHBUuxXDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758530731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLHAegiBJpKwn0b43z4Vx4FeW68uea3XgoC2pxtXxfY=;
	b=Ti7f5tS5D4r6CsJ87p20QxeXhiSNXPFrcI1iBdz6QXLoD/TPd0RVUfy/bFxXpWMUPKHE7r
	xFBV6NOwSLXXs7E168DO2BTB4tWSpEvsi/Yq3CtrNvIeCb+BtQ/kB5y3ydhAmkXiO9bmRS
	c4ki8OMIq8I9pvsP4HFkZMpStXERPe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758530731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLHAegiBJpKwn0b43z4Vx4FeW68uea3XgoC2pxtXxfY=;
	b=31CK8I0FNdLbd/LZq201gieA0eodPpAfH7p0LiGmmNJqQlphuANM3vsovdxKQsm6vPdSBn
	FmkjYn+xHBUuxXDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BB521388C;
	Mon, 22 Sep 2025 08:45:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CSJtOqkM0Wi4GQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 22 Sep 2025 08:45:29 +0000
Date: Mon, 22 Sep 2025 09:45:27 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "wuyifeng (C)" <wuyifeng10@huawei.com>
Cc: david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
Message-ID: <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
X-Rspamd-Queue-Id: 83A7E1A0002
X-Stat-Signature: haun1ppnu5rf8ity46mzkkjc6k5ipsqn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758530732-768276
X-HE-Meta: U2FsdGVkX19ZLfzUoq4e2luvWDtcUK9Ik6uOo6spg6qj4OedvHZhLTIoxNPrfiTZCtgl12VnNcnbrVv/fv3I1Whs9gpyu18Amfgdjxwr0zMt4CTXphY4/WyIGd0RJFFk2q1Ei7DzyEJN3keKzC5S2BFxEx3KdagfWfMxZAswBygns0bv0iacc1rf3TLE2kajFMchvd4vlVIEhQM6rd1LWSokElfimMa1FD78jdT8pSQXVorN2x/OW3iNZWPyGHk3YPIxRZjqYlclJI/JWOSmnrY4TX59jwNU9lQkzr+lVlj9/b+hPTwHJR4cfnYZhebzns8Ri7mVHI9EftFU2t1g9HUIZAqvEYI/qd3nxusih+wTBARDHMzLBctmPqY8BJsLm2lxdugrBa6xHDt4v9a7O0pwjhHX+eASd1IhPPd4B5mtUX3IDWsQgl8x8A1dAZKkb3tgD3nnMLbTHuNw0w/FQmFJP5iXYudWCgWhdLwbKmI/9X+RvdvuwtIIG8RKZRvlABm/+gbUfO2GaFaSaY5fWr9mcqO+yhv9Jw63HAfoF4BH/PDFg4NgHkwtPAEN71B8cGcLeMImxBh/rKrjb6sROFaG3/UQR0EY0AH720lf6+IQiCmJt2InHLeURxPndebij3Uqml13UAhE39nArlaMUENJw/IZUVBhJeIQMz0Ddr+xs+u9lgyOaH5s6xBUtg/dG1Lrqf3X4451LdRJSC/6LQosOdfrkAy3gNCaUCFnkx/pFoKzgwZrOFHiSIpGhbSThLDH+tB85dEnkHK++9XtdHiCM8ZwXoHlpPDgCbHIylVhuO7Z2eO2Gz/F9X8jTvRyIJgNFpVrJ7Sz9H0wDyFmCxVgSWSWJ/8Qtqg3NdvZkxWu/jF2xwRU7TZQ6s2TOy2PbDW/wgb9TO8sw6uYD2j4NDB3nvu6bNNzfPS4iEBbEbXXiNvwXPOOl1VD0S2kLscO/hGjLbNez/+cDW36N6Z
 LsOZb5Ny
 /gkly7R6tjG6Nw7pwoRls5afv/6JVVsn0m1BEd7jXtW64acSbEstfmLdL5Q2vpDRRbSbK1AQdMu+t4Vaigzow+6BgL6iwCN6tSdaisjqy06KfjoTipq8r+G9kE+7FylKqdQV6Hd6yaMyD7ux2m7CvUffNlFaq/vRhtF2BYfCjFxZdT/aboZ63mAw1CCmroXjox+R/xhlpA8fZ9xJJBClPSTfZisldvpnWy3MphgoWZ3Lng3JtnbcIbw2DlDv2otMx1Ykdre3FrKvRITAh0qvtNDVDbh0pF6m3a0JUzXokhUEiSOTJITDPKBHjHwgrkwcj18oakL+4SfyK2n6W8tc9I6eRmpM9DHXO+gwLcKicKCFp3bc1e49GNzn/VQiagBoIFdr0a/+PW9FcbOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 02:19:51PM +0800, wuyifeng (C) wrote:
> Hi all, While reviewing the memory management code, I noticed a
> potential inefficiency related to MAP_POPULATE used on writable
> anonymous mappings.I verified the behavior on the mainline kernel
> and wanted to share it for discussion.
> 
> Test Environment:
> Kernel version: 6.17.0-rc4-00083-gb9a10f876409
> Architecture: aarch64
> 
> Background:
> For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
> is intended to pre-fault pages, so that subsequent accesses do not
> trigger page faults. However,I observed that when MAP_POPULATE is used
> on writable anonymous mappings, all pre-faulted pages are immediately
> marked as dirty, even though the user program has not written to them.
> 
> Minimal Reproduction:
> 
> #define _GNU_SOURCE
> #include <sys/mman.h>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main() {
>     size_t len = 100*1024*1024; // 100MB
>     void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>     if (p == MAP_FAILED) {
>         perror("mmap");
>         return 1;
>     }
>     pause();
>     return 0;
> }
> 
> Observed Output (/proc/<pid>/smaps):
> ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
> Size:             102400 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Rss:              102400 kB
> Pss:              102400 kB
> Pss_Dirty:        102400 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:    102400 kB
> Referenced:       102400 kB
> Anonymous:        102400 kB
> KSM:                   0 kB
> LazyFree:              0 kB
> AnonHugePages:    102400 kB
> ShmemPmdMapped:        0 kB
> FilePmdMapped:         0 kB
> Shared_Hugetlb:        0 kB
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> Locked:                0 kB
> THPeligible:           1
> VmFlags: rd wr mr mw me ac
> 
> Code Path Analysis:
> The behavior can be traced through the following kernel code path:
> populate_vma_page_range() is invoked to pre-fault pages for the VMA.
> Inside it:
> 
> if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
>         gup_flags |= FOLL_WRITE;
> 
> This sets FOLL_WRITE for writable anonymous VMAs.
> 
> Later, in faultin_page():
> 
> if (*flags & FOLL_WRITE)
>         fault_flags |= FAULT_FLAG_WRITE;
> 
> This effectively marks the page fault as a write.
> Finally, in do_anonymous_page():
> 
> if (vma->vm_flags & VM_WRITE)
>         entry = pte_mkwrite(pte_mkdirty(entry), vma);
> 
> Here, the PTE is updated to writable and immediately marked dirty.
> As a result, all pre-faulted pages are marked dirty, even though the
> user program has not performed any writes.
> For large anonymous mappings, this can trigger unnecessary swap-out
> writebacks, generating avoidable I/O.
> 
> Discussion:
> Would it be possible to optimize this behavior: for example, by
> populate pte as writable, but deferring the dirty bit until the user
> actually writes to the page?

How would we know if the user wrote to the page, since we marked it writeable?

-- 
Pedro

