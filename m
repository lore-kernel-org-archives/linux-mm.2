Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF09DCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA776B00BB; Fri, 15 May 2026 03:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29ABA6B00BC; Fri, 15 May 2026 03:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0D86B00BD; Fri, 15 May 2026 03:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 095836B00BB
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:16:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B07A812089C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:16:09 +0000 (UTC)
X-FDA: 84768795258.09.5223A16
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf22.hostedemail.com (Postfix) with ESMTP id 09123C0011
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:16:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778829367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=heH9V247+iFVOBSmRnmo8z34qv1s9/cj0hnlksLm2qc=;
	b=VDu45/KmxJqwnVtqGe3vgIqWIy1cRAkPTnbl4SJHZT0ugieqULACb2f9mi+pDN+S7Xqeca
	U4Qxy0PWclZlkn+hFGzh3etRkyFuEzLmXNaLJ69G2Ysg2DkLcttbw+quWEi2mNNsdR67jt
	tWu1T8+k4uZMXxWNnue4PW4XaGeLWsE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778829367; a=rsa-sha256;
	cv=none;
	b=azYQd/DRhUv2cAHVihfJNOccZtKiVVR+2VxgmBP+cGKQMNPg6l65FkC2cYgJL+yopnXbA9
	28mQS/49yImjgCNPQzA7436srK0w1kwF1oEhBw/u9UmXQ+6alDDa4KOFJTjZ7dZKFn//Ic
	WH2XTdgvpynu3L0TNNmL/XT/bJG6Xis=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gGz500gRMz8Xs71;
	Fri, 15 May 2026 15:16:04 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 64F7FqkE076365;
	Fri, 15 May 2026 15:15:52 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 15 May 2026 15:15:54 +0800 (CST)
X-Zmail-TransId: 2af96a06c82a503-a22bd
X-Mailer: Zmail v1.0
Message-ID: <20260515151554289o8gXC5_wcaka-TFvl-cb5@zte.com.cn>
In-Reply-To: <0432f2d7-3151-49d1-911c-0e227223df10@kernel.org>
References: 20260503205013850sym7UO0jvKJzyRiTYmO8V@zte.com.cn,0432f2d7-3151-49d1-911c-0e227223df10@kernel.org
Date: Fri, 15 May 2026 15:15:54 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <ljs@kernel.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCA0LzVdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64F7FqkE076365
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 15 May 2026 15:16:04 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A06C834.000/4gGz500gRMz8Xs71
X-Rspam-User: 
X-Rspamd-Queue-Id: 09123C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: 6yr16or93uxpwswbuxebpb5hpmhqn7zs
X-HE-Tag: 1778829366-970019
X-HE-Meta: U2FsdGVkX18tn0Sc7+iIVAxkLatJqATkPJmlhLmwpaX2i7cb8rgCoS0Q2CrjUniN6MTuqxzYfNzrqh11UnaF+7HDadH8NZGUvPfrpjqj0I+6bGlXvv5k0MELVXY23jBQR7ZPLvFMbqLoOIG5j2f791Mhh1KtIotZpEpFMU8rrFKC8TATPJ4oeq6tr/9kX9S+adF6kcIEDaRaPl5rrufiT+gxrEYkJiITp1X37DwLXoCHzWf+x5jwkkYILPejGkRgsZzwCFt1154nnzzglg8EN6XgRdrOofMvxv4haxdo3SNwSYFkdvjR6kgbLV4qAUjOk6K0A5iouPOt7z8lUM05cP+IqcTKiiOOBcQkgEqWCO/2QotkzePWrkhuXv4m3mZaexxoUQtDNUbIlhKdEsq15RS1S+HXx3drSt7NC1xtjCS2iMfD8a1nEIEV0jdja22bmFnWdhaVe/JNLYvLn9tMjD3TGdbRxbBPFNKk4SlUq6oMvQTBN8YEIAwuGAAJnhkBmXUfUOWW4x9WwN6Bq3fgoVes2+9qn7Uxq8JA+J27ewPQZoGImepX0xPeBkMlk0TkzVJcVEDL7QP9O6ud7VWhsBJXmEp7nJ9cuiIgsVL031xN4eHwetUemuef2N3gEzr+71qWsB9kwWYgR7NG6HwGYK6o/Th3NL8IOuxA4VFt6ld8ie9CF/i5OkgKnzuk/AY0oMo7YHuurnd17ydX320yaLi4N9U0NEqaDbogOl/um5KKDX0ZUV3IfTb4wFfYoTrXFRtdVJ/eNNJRpzUUZyo/xXpXakxkj4q279dAS9QjtarAk1k16H5kIK5vU3xL8MSPbZM4EzPRDFcaKVWww/Bt0YLs/vMv64tmDqacnQvYcwBF705pnN1kH5jPZNgUMhkp5bCG4kOjry5QOTpGIzmJqWF2T6VYScoSUI6dPDOMgDqBBU3t1Vaj4sqLwumk05Tq4S6fUfP0lGV4Z0BdOsO
 7WKdYD5g
 s6Ic4YV9y7BVEWOezOhViiY7GJumQCuft/LRLDrzH/5SiFrPG0RDrgx247Er0VRholFxNkaObdx4nKMrA157IOVCLqzTJE7tDjozJhERHNX+3Bol5Efu+Kr0F81Ng0aB7Yljs1zymE7M3pFAY5CYKJy3sdzFNhNhly3BJrZazMSwEZ6B3ovLSdX4K8ikPETamjBM+zQLU5GTPQYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 0299a53ba7c9..a13184d00759 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -3200,6 +3200,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> >  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> >  		/* Ignore the stable/unstable/sqnr flags */
> >  		const unsigned long addr = rmap_item->address & PAGE_MASK;
> > +		const unsigned long vm_pgoff = rmap_item->vm_pgoff;
> >  		struct anon_vma *anon_vma = rmap_item->anon_vma;
> >  		struct anon_vma_chain *vmac;
> >  		struct vm_area_struct *vma;
> > @@ -3213,8 +3214,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> >  			anon_vma_lock_read(anon_vma);
> >  		}
> > 
> > +		/*
> > +		 * Currently KSM folios are order-0 normal pages, so pgoff_end
> > +		 * should be the same as pgoff_start.
> > +		 */
> >  		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> > -					       0, ULONG_MAX) {
> > +					       vm_pgoff, vm_pgoff) {
> 
> But vm_pgoff would just correspond to the start of the VMA, not where the page
> is actually mapped?
> 
> I'd assume you really want the linear page index of the original page?

Right. I've reconsidered and realized that using vm_pgoff is indeed unstable.

My initial idea was: as long as we can find the VMA that maps this page,
it's sufficient for anon_vma_interval_tree_foreach() to check whether 
"vm_pgoff <= pgoff of the original page <= (vm_pgoff + vma_pages(v) - 1)".

However, the flaw here is that the VMA may be split(e.g., due to madvise or mprotect),
causing vma_pages(v) to change, thereby making this condition no longer satisfied.

Indeed, it's better to use the linear page index of the original page.

I'll send v5 to correct this.

> 
> -- 
> Cheers,
> 
> David
>

