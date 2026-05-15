Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885D6CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72856B00B9; Fri, 15 May 2026 03:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B230F6B00BA; Fri, 15 May 2026 03:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38E76B00BB; Fri, 15 May 2026 03:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 925CF6B00B9
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:13:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64B7290520
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:13:57 +0000 (UTC)
X-FDA: 84768789714.14.B159D4C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id C19C7A000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:13:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778829235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=W+XjIQ01pscINUZX13EkzHQgcsSgmI1UB6C5UxKKteQ=;
	b=s0kptkWVxl/yT9giwaKZble5wxjZQLOtqdnSwi3kOU1mincOj/g5IsPgd/u5goc5vqxOG7
	iiId9mwUl7CVcgl+zwa2O7i2XxUi6OSdXw8BhJWJseiJ2v1UtfcGAzjrpinJRIglpvYwhs
	GxdJtWHjtWyAwruCD0ePyH3h6T/aq+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778829235; a=rsa-sha256;
	cv=none;
	b=lwM017HZ+LMXH0LHAYCkdrjezyNzXw8qASfYmHE2EERGhmVK1hpLkINDWGOgAmfrCuj+df
	wYXEW4A4txYfdYQBAotnT+bRurSrYBk12d2lGrwh3MIVjAJIMThiaQUurY332cSzTkjYGz
	Eny1NQPdTu+cAvVG4KkRwdiVN4co4Ms=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gGz2R1Ry6z8Xs72;
	Fri, 15 May 2026 15:13:51 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 64F7DgXo072886;
	Fri, 15 May 2026 15:13:42 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 15 May 2026 15:13:44 +0800 (CST)
X-Zmail-TransId: 2afa6a06c7a8b17-b98ba
X-Mailer: Zmail v1.0
Message-ID: <20260515151344118ESEm1fT7x-Gd6kodR8VVq@zte.com.cn>
Date: Fri, 15 May 2026 15:13:44 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <ljs@kernel.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCA0LzVdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64F7DgXo072886
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 15 May 2026 15:13:51 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A06C7AF.000/4gGz2R1Ry6z8Xs72
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C19C7A000A
X-Rspam-User: 
X-Stat-Signature: 6qu4a8dbfg1xm95an6fmhxddxcpqstkk
X-HE-Tag: 1778829234-682937
X-HE-Meta: U2FsdGVkX18psWOGFwg//Ph+qEM818VFfOEit4E0zwSUhky0eExUOJ/n/bmY4Q17n8iVURNp6JWgIaY9LgWyWxrSdzztvhQgzCGrYuY6q8q5rgwfsAQiViQKlC6NVYmz/uiSLUw7vw8tm0LmiVzMgmh0PSXYPaXdpEq5ljeIC2aU7O4Gf16EGPLlBMRXEpfGoJWvdvVeQ0Ee6AGyqqp1x6VYaYqrpkcL467sU/rQmr2kSH02gmKgUCCFH40TJXNgaFW0oZ3fbSMAf0X62xb50nOHfn1+xzHwHbOf+jCqPfQuOJ8g1QmnXoqKhesAHItI32oxno/ByJaih8kXMoFdjkuiCuvbfxK6UTsMK41ziijOUCI675/MPqCih7kuM8KaaarSIC1WZLYoGzrAnbrPsq1qhqUEiMGf1ms4vc+fkzp6c/vWMLwNQLSQ3+w6/eg1LpAgiTe0Io9lNU2LorWsS5J4ff8bIN9H7AJ2CULvKwlXJyZ+oI4iwRGs0Ebe9bQ7BzlMw38Hz06LGH4Yk7woR65AsJNM7dn/aABkGltpWbvJozmtwi0DrmQ6/qu1aQGpuk9BknNjM/yqQaDuXZnCv5x8FDX9eELgWDafCN8+zT9tMkCjFKFnnBtzETLAH3xO9lR6wHtMUxF80ZPdxQWpXuO69r3mZNjuQvZ1r+RSt70Pae3iM/PBLCkqUHG9KSTVWdDdCzlALNw8Xb7XdtsjqsfzaLSvMp5N16S/kfERBcegVd4x+465lbzFzxZD+Z4CN/0bgyFy6QjiTletahg1J78DG1RW+p9A8NDyOJASJBmfs/GJV8zmKCOFO9WEcKxGuMb8SGfB/lybNrfnTh5OoWpdwuow+FEshpyJe4BV0HbU0lJrF6otiC93zK1+B7/vGTZwu2smpifX6ZJWzKNsS1520fbLuT/g8muzfF+QPPpuxobrlamcO6isYPdzTYQlV9nE6qgq6LUSm8juvlw
 Fo1ZHyXr
 lIfAFdtY/kpGOR5WXTfJUDQ/IQpwGJq9VYlZcBt0PeAmeZdvm28RqR7xjEHubr2yGjkXwChAgideIo64yEL+REXli2QlKEgbLUNicz6yyQorPbLQFG449UgV5W0y1sAgqkdlelgY5k7AK7+spmTnTvwgmsvoZHuldCl+nCJ0TFcVXE5CQl7pxErLrbJXZznMlp8Wv8/Pv99tMOi0WsZXv+FBASgDJyvWwc4iZrdoJIF8UY/E=
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
> I&apos;d assume you really want the linear page index of the original page?

Right. I&apos;ve reconsidered and realized that using vm_pgoff is indeed unstable.

My initial idea was: as long as we can find the VMA that maps this page,
it&apos;s sufficient for anon_vma_interval_tree_foreach() to check whether
"vm_pgoff <= pgoff of the original page <= (vm_pgoff + vma_pages(v) - 1)".

However, the flaw here is that the VMA may be split(e.g., due to madvise or mprotect),
causing vma_pages(v) to change, thereby making this condition no longer satisfied.

Indeed, it&apos;s better to use the linear page index of the original page.

I&apos;ll send v5 to correct this.

>
> --
> Cheers,
>
> David
>

