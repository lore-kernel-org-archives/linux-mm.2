Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9317E6BF2A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3866B0088; Fri, 30 Jan 2026 11:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794FC6B008C; Fri, 30 Jan 2026 11:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1D96B0092; Fri, 30 Jan 2026 11:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59AFD6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:48:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA2E858EEC
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:48:18 +0000 (UTC)
X-FDA: 84389213076.18.ACD1409
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E020180010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:48:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkIPaO+8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769791697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0bsS3V6tz831x+5BztayPCxzrLGcuyzVdHvWPehnBU=;
	b=qlmgnsHOmKPGHAiIK1FWQZvqiieuwVX3f5dHKvhRA41l8ph14r+XQou5wzDHFl9i5yR/C0
	OYjmkms4gUDagd0d/76VpgiO85Ylvk1BpW+AvkmryBOteZazEHrEmlFn8EIcmBxZYWcJOW
	Zsv0DlhQpsNSbUJG5HjrwwfqdTt/zJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769791697; a=rsa-sha256;
	cv=none;
	b=cGwNJ2N8EOSvmEEkm2EszB8RLM7C+qUQw6FeZeyVm2RREUWHBRE1JcftTgFd0yl81xs2VU
	oXtGgT5nHhw5iulYWM/RnbcXMKSHmFKpgcOWMcLawsD4AB1mGcj8wHw7QWqlCOEldVG0t0
	ZRYqp/Ly1JhtdyAu/JKJF3LQ94VGFVA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkIPaO+8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-352dda4a34eso957627a91.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769791696; x=1770396496; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0bsS3V6tz831x+5BztayPCxzrLGcuyzVdHvWPehnBU=;
        b=XkIPaO+8SiKj0TrqwGIBOGFoKYSmOYJM5kHXYNOVAolf64Vc2oe6mZ67b8CtInIq26
         X46K9MhlwbANl/M2oOkqC7v8Ac8+GuZWqFU9KG1ZK+BYhimpeiT2ov+9eXRK1hGJ9YmP
         LLt0cD6aDbTsAyuSlhuJ2sASRUJJT+xYoxsnsPvO9i5wBfJVMPdtDXd/3nR0hy0uPDAF
         SLOVjth9VvdsGL3XM3ly35bNtCxPrAEiw7CXUVqED0bqEFkLPXRI2pjkqHUJjfpHCLfI
         93djHcCag6BkV1grV4Oc5fzgalE1xTIidELwHhriaJwTFTJAIRj6xtsh+v0qroPA+sie
         EKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769791696; x=1770396496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0bsS3V6tz831x+5BztayPCxzrLGcuyzVdHvWPehnBU=;
        b=VvCX7Xn0czybaYx9CZtnAWXHguyE3HTUALkZdLY7odhyKAFdM77ULfKrsMRPiWxuk4
         MhSYrlyxAGNtKeALbh7nV1Chq3Enl3SaHgrbefHUWJtGsYosctzTFbVDkXcTuZ/NtTXT
         sJ2xe4kfdHE0m5ryEDUOGpj7GCFryI4XploC4+f0+0QEk1wZrCwVcXguMs+y6a8oHAh0
         iIs6YyJ44CtSPMEfGyvXvZSEjkLgRSnTmp5+mGOpGvRMRiyiJgo1D5Fx4JzNJsv6yHI7
         Uo5CpnfzjeEOXkgMZBKGqKkXGTythVYCaoCVCa86KrwCgMGGa2U61x9NQ+aUQQ9fUKrl
         9N3A==
X-Gm-Message-State: AOJu0YxTB5SP7ha3BBl7ow4AH4OlNiUwNj6wH7UD2jVGn+VRF0hJnjIl
	w3ekcfiITeVsgnmWCnY1vv7brySzof9y9R2mmJ7IOXNsgU1FFmaTSMcC
X-Gm-Gg: AZuq6aLfCXnokIt22TPxhsgRK96AsN/aCZWSc869Q9isB0qIDqh+Qbf6iYFzfAc0uxs
	olWeEkhLtlCPbk2vzyluQzrHsHGfetcHKdSauN3o1Uy+fN4Wl3wYtwf/vIL1jyP5HD0Ild+ZU9K
	PTn3Ht366zvXwOZkJOK9IcgQMLrwg7yX1UyXoV6gUdVAU3eq9IFVtXFVlEGIiyPPh3XzqNzdHcU
	Fm/gtU2Z8cmcjolX3/SDl+Cf7TMOkxDgia9B0Pjm5Estwtjzf4V4cOmKIRA9P8AlRRjoWUTMqi/
	Y3I7tDBocWhXrgVHPN4gNbbvo/p4xwrEUIj8dkIyVc4j18D2GjQv8BnQpOBL/L+jg4swxNDTzh9
	fnN6qGp+CRLpdskSBjbcwYnVZkbMmfhNQuRHbz/9ZTfoLmbmyh0lwmiFQTLsoCudot25KkGSy4x
	YCZRA1huUOTQeGM+fHCa5uatFsIq7xMbDBzm5YTukzcQJTR5Y=
X-Received: by 2002:a17:90b:1348:b0:34c:2db6:57f1 with SMTP id 98e67ed59e1d1-3543b3d1227mr3086067a91.30.1769791695949;
        Fri, 30 Jan 2026 08:48:15 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3543c1b0c72sm1048655a91.6.2026.01.30.08.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 08:48:15 -0800 (PST)
Date: Sat, 31 Jan 2026 00:48:07 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, linux-pm@vger.kernel.org, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
Message-ID: <aXxkANcET3l2Xu6J@KASONG-MC4>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
 <20260129200604.2518109-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129200604.2518109-1-clm@meta.com>
X-Rspamd-Queue-Id: 2E020180010
X-Stat-Signature: iiqjuciqymps5ocqs1xa1qwpsu1u8qxr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769791697-195953
X-HE-Meta: U2FsdGVkX18Z8jLbPUXlZBXNCNygd931CLb4mMS7Aw3UgyhyCogr3/QTnbyCSV1wWOTAiWeMIysqjK2mXWmA3lmjc2TYsAAmtcwyaPQXDKUgnAULax2v+7qC4nDYjnLOOuw62kLUIKtvJL8Tmr52h1JwAiFJXiM6oXhiKVC0mvFeQrC1P4b6yrJe55V9iatKY28X93nOeKgMQ8nJXfZhIW91AnSfhATWxtl8HOQQ3oUs4nCetsoXVzihNoFErXYlpW/f04tdxjd5pW0tlsoqNaMchjzVYALyDluND+6Mzn7IA7SuMCj2jQA4MNscJo7KzXyZQRFsYLJqPGQF1gMhxpVpueZuMO+yCCciaS0H1DBFHAei5Pycay1TO5KAqWRq5kH1nz9FSM4ZyG9pbkyC7Q0RtDYroLbnV1xMUMDZncbq5to0cu8T4NdXEmqOdL/+2gUt9g/BnzQFhFtmfaC+9j7MGkKLamS2RnFNgbPMpbd9G6qBR75HA+IkDujaDUbbvoMkDL1Y4+H55LOF91EpR1uUZ/U3Y4C3i32TtmHYcbv7lHFnp+B1fQXxR/Q8AElGiFJtSKrw0G4CdwPRz74r7ZLl5VsHnccshyBBLN785TXyulVo+5QL/Wx5Zrv2Z45Fe3EyboVyQlri6XdXcVQvLkxH0a+nYprsQamBqRGXmgiFVTwfCSjX9MZ5RhO+32ej15YYThQH1AbQDN7svyKCCeV+HBZFuOsplMU6YRfmwMbee6k3pNPI7j1OG8vfEXKtNe1B2ImNngLL4PmfWKn4HyqAAdH+3BRd3mTpZ/fpAd/bg1pms/cV91gmOhogjtowAwGV0XT+Wg5UKdmguiWBIoddjeRRGLGGA2Q5WsZTsMHWNc3FtDPr7jQkrMUyrr4ckMyDphv8tkrJnxL4Njhz5Hoe5iBqwmgaqcU8kFGzxX/FUdX8deQg+kUOPWDIvzhm8p4M/vP9CRiCi4zVUoI
 0uhrxMch
 QJBqSzWmpfwG0T8gXld0IJsNNPTyoDnJaeEo2q9kQCz/uOXHi8wEpt28+WMZX2MPK6eKxsOLkrje2feCwjv0hNA6Temdu2/OscP/PEdy67SG3wof+O/w3hmnm8scMXoQVnSKqRFCw9+/phYQJ14Y4UTjfFMqjsErkj4YSa2iHWlxjg7rkvSPR99YeXd67NEkMOS2w56GvctAO14AaWn1N8ebpcdE40Au3SrgDcfYDMV43psvHk2YdtjTIdUgBp5KkMbRn/aCHOPyGDIQ6KBunWGAnFOx7TzY06O45C7ZLl4IwSbZ60HUCbZjVyN0ahs9aotS8PJrqQcP1U4RcyclFBd3xo3AaW5dor7QDHPIRmlB2+xVctkTOXK692Oqe2Y/tNy7R9SHiKMFuW48hzbqn2SCXT4BZrFl1v29YHf47vHxsXA9cfkH3jT+fqhp8z6zkty14RYtqqI3UaGaTuiBeVfOlf8FoEtL+PtRZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 11:32:38AM +0800, Chris Mason wrote:
> Kairui Song <ryncsn@gmail.com> wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > The current swap entry allocation/freeing workflow has never had a clear
> > definition. This makes it hard to debug or add new optimizations.
> > 
> > This commit introduces a proper definition of how swap entries would be
> > allocated and freed. Now, most operations are folio based, so they will
> > never exceed one swap cluster, and we now have a cleaner border between
> > swap and the rest of mm, making it much easier to follow and debug,
> > especially with new added sanity checks. Also making more optimization
> > possible.
> > 
> > Swap entry will be mostly allocated and free with a folio bound.
> > The folio lock will be useful for resolving many swap ralated races.
> > 
> > Now swap allocation (except hibernation) always starts with a folio in
> > the swap cache, and gets duped/freed protected by the folio lock:
> 
> [ ... ]
> 
> Hi everyone,
> 
> Apologies for looping back around on this one, but I've got some prompt
> changes that break down larger commits into sections and run them
> independently through review.  I reran it on mm-new, and it found something
> new:
> 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 64970ee11fcf7..85bf4f7d9ae7b 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> 
> [ ... ]
> 
> > @@ -2195,7 +2265,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
> >  	/*
> >  	 * Some architectures may have to restore extra metadata to the page
> >  	 * when reading from swap. This metadata may be indexed by swap entry
> > -	 * so this must be called before swap_free().
> > +	 * so this must be called before folio_put_swap().
> >  	 */
> >  	arch_swap_restore(folio_swap(entry, folio), folio);
> >
> > @@ -2236,7 +2306,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
> >  		new_pte = pte_mkuffd_wp(new_pte);
> >  setpte:
> >  	set_pte_at(vma->vm_mm, addr, pte, new_pte);
> > -	swap_free(entry);
> > +	folio_put_swap(folio, page);
> 
> Does this corrupt the swap map when ksm_might_need_to_copy() returns a
> new folio? In that case, folio != swapcache, and the new folio is NOT in
> the swap cache with folio->swap = 0. This would trigger
> VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio) and call
> swap_entries_put_map() with entry.val = 0.
> 
> Compare with do_swap_page() which correctly uses folio_put_swap(swapcache,
> NULL) when folio != swapcache. Should this use the original entry parameter
> or the swapcache folio instead?

Thanks again for running the AI review. And it's really helpful.

This is a valid case, I missed the KSM copy pages for swapoff indeed.

We do need the following change squashed as you suggested.

Hi Andrew, can you help squash add following fix? I just ran more
stress tests with KSM and racing swapoff, and everything is looking
good now.

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8c0f31363c1f..d652486898de 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2305,7 +2305,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		new_pte = pte_mkuffd_wp(new_pte);
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	folio_put_swap(folio, page);
+	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);

