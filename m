Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D18FCC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 21:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484D16B0088; Tue, 13 Oct 2026 17:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435C16B008A; Tue, 13 Oct 2026 17:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDA86B008C; Tue, 13 Oct 2026 17:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0204A6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:27:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60924120259
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:26:58 +0000 (UTC)
X-FDA: 85318888116.29.A88CC40
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3294114000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:26:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FnlBCrSy;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791926816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GzEeHLHpLUAjss0Bc0f6712VJU1Ix+vhwimhrdH+AU=;
	b=fTRddY31YgOzsGacWfsunjRyKy2qFF3ulSW/9hvbmA1zjf8otc/4xiuOpUNRIOgxU9ZY+n
	FGcvcBjsQPyRG1Ius5JB/fr1Xxg0bC8uMe+afdiZjNvbodhOXgnzXBAwiSfBdGbvPOuFiK
	t7UGlaRctWOxbFUvzQL7X5TVm5agX+s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FnlBCrSy;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791926816;
	b=ByFO7QRpyleZsZxVC6fC8T3kk9Xbpr6KId3jWd8m/xAQISqWGf/T4pd2ldt23VbgjPdRNM
	2tbPXDYYXPg6njJUjlKfR6smHFVYXYSoJFzv+28tqeJSZLOK5ZvNYArXG8o+SvDAyfVf1w
	ahJKkgRkZeQA+ekqvHZSmzkx0fIQk98=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2e5d08214dso52690566b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791926815; x=1792531615; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8GzEeHLHpLUAjss0Bc0f6712VJU1Ix+vhwimhrdH+AU=;
        b=FnlBCrSy40OwzFB2W+iutnvFZN8SpmOBpOdwIo0MHlpJkT/Fgo+ti+NEDFn2HdOb0t
         4/Ca8Kc5LezlQavMXNJcEE+12MSxdJjehgFVLy7400Qyd9vxuqTtBI5Nl6j1/8ol2gHt
         Eb1nF1MsTLlH/KGivRkTxYpThJCrFbUgNPxAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791926815; x=1792531615;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8GzEeHLHpLUAjss0Bc0f6712VJU1Ix+vhwimhrdH+AU=;
        b=XV1N9rEl7VIADIUfkMk1TxJrGmLHU38FufOqXt7stC7qG5rf1Q78vZ4PsOUQR8hHPr
         1Y1BAtZHQ9tlfkOO1Rw8WT9Y8LISoEJe+G1njR02/XKxAAAerFIqrxVSuHQyucv1TQgM
         eVG66S1V8aCAWSISxSAoCSLHtje9NnP2s/jW41QQa9jCD5CsZrsQ/Tz3lnMunGclD8r8
         MhedNsXWbkIYwQlMn/rkjqYZpBzjH391tmR7BZ6CYll6Pj0Qm76RtVltOjO4BiJBYGVI
         dDnLk57k2RLnRLdHW53xnPtKjP0SLg7lBVJxnGzD8FyjYQtgeqHIrIThbO5bim0I88xW
         i/8g==
X-Forwarded-Encrypted: i=1; AKwUvBy4eDd1tE04tew7wOO3+tjhEcPFFTrdLNq7lsMJifBAqdBjTcy04JtqTrKVd+VUvhck57qxB8krpQ==@kvack.org
X-Gm-Message-State: AFq9FYJDhE50ugEos0JXfBGrKSgKc8USgHxTxJE2COyQNUC3C1+YTUJH
	+A1XeExTyfbbnVAwn17A90njD6ywNjvnzVzs/+TusFGlT7H3BIRtOoN/eBhwl/riqwXh3M5zu0L
	P2XuIprE=
X-Gm-Gg: AYBFou30iczT01iBQSjn8ms1CBTxygaiGpryOCu50eWcR+qDvK0LpT2skz3Sua2kucq
	pAIfsZTTLhDawQNYfKEZfu0+VPjGVc2GXJWizxI/D6+Fuv0svqXDsWX9TyLt+kYuxD50vdlIcNu
	OREVud4srx+xP/kKz5Bq77AdUiMYezt5J4Bvvpia6WlhV+sMpweYu2GHjuOVnoQymEK/CkfODP9
	znkhOCmCEOUu8YHhdL4hidavSmyq9lmh9KhTy+2uZmYvDET4EQy8UXHQeWdwmGovfRkmKUTECFU
	OGnXP304UVdAKsaUxNxP132bv3cc4j/E5lmoOkgH4X/MmQHQ3nbbU+crqXCWzAU+Ry8KUVd0p88
	YId1ic/dr8NyIS9Yf7tmmulP6NEIALrvOQJzIqVzLWb4zKVAWFVdAqVzSz0aiFY8ICAhs7MW0jz
	rcQI/U9zFdA4tpeAXo9Ud2rLKG3vfUIdaaBv7R5dLn5Dhj7woP2IOxyj4vdjOQ7d1OnU+jevN6c
	4Pkoo/QcqmEUlCJZmLmIzLaZLfsqntl4oInpFegJGZTDjS4
X-Received: by 2002:a17:907:3f25:b0:c31:82aa:dd4c with SMTP id a640c23a62f3a-c31a9d15f06mr1301717366b.24.1791926814478;
        Tue, 13 Oct 2026 14:26:54 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c38ac26d05bsm52087566b.12.2026.10.13.14.26.53
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 14:26:53 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e5d08214dso52686466b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:26:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxunR2cil0wEX0jUXkM1SucKwdn6H1eMflwLUsS7UT2EbiSC6TDSsbqqj5eg7y0ZkhlL1PAQ05pcQ==@kvack.org
X-Received: by 2002:a17:907:6d17:b0:c2e:4627:285c with SMTP id
 a640c23a62f3a-c31a9d14aadmr1321776166b.21.1791926813105; Tue, 13 Oct 2026
 14:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as6ckC9NJVB8JBuV@casper.infradead.org>
In-Reply-To: <as6ckC9NJVB8JBuV@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Oct 2026 14:26:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiHMFdA9CE4qu7W9vUh=CBrH5w9RMjf2kx=U5BJobrrZA@mail.gmail.com>
X-Gm-Features: AclHuK8M1AfgFef6tEhvDZuFcuNwYe9MGQmI8EMTOiu9NNmYmP3zZYe2xiwpZO4
Message-ID: <CAHk-=wiHMFdA9CE4qu7W9vUh=CBrH5w9RMjf2kx=U5BJobrrZA@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3294114000A
X-Rspam-User: 
X-Stat-Signature: g7h9ztj8iebimn3sdqeeos6w9pcpke1e
X-HE-Tag: 1791926816-22609
X-HE-Meta: U2FsdGVkX1/kkkXwYwQOQpJnjekXWnA+Tzqiwg3R7gR0gUsKIsI+JdluJc4AN01oAVthBZeCQYCxTJUddNmiXGD3dg7iTOPJi8AaoQhK/udst115IE+W6rwD3xvZeOfBbIgJMw683rgA9utkom7pT6fVJ8pfz+4YqPdB/VdbSgIYjRZ3wuz1Q9RKOJU1zIL3nXT5Nt5oOqbZw3jKTY/THccSyurII+32tiTldDaEqMcMLymhMN7shtPjom7aPd/xJpUibYtToZuRTOCOE4gxwg8myj7hcz3lwDerGlLouYvyZcAWqNeyK/pJwCzRMwfEPX9yJ0eFpchvW65w2ZXX06K4I1V4c4L6zTY+G29pdUiSsX8zXgBFY0ZUtz0GLGNoM2X0CiuVPO5/BzqtBeyHYQNG4nZQahdn+5/5aZQMsl0KZteO/fkxXFBistj8YRA+jTdgRaFivagIwQKTvK+YlpDZDK0AWXlH1Eiju5OaXHRBfgqWCOTeLdfVYLTeSic8Br0lBEjjo5JyVw2Sv4EY0JngSprAhWDm5RTpVPu0TxtNgc6NT/GOleaONxZxXJKsGnVwmtl32r/njW7aepXa32ZiKMuNuF4SslmYDR5oAhfFY2gvHnznISJMyKvoH0esqQP7nifuf+mn7n+zVYRRczaM+hnhTAYA86OfYC+PIrgQ5hf8U1jVfH3lEG8SUxqVf7ZqXaDLjSyCSjFHpsI+gMLAelBcS8A27dBtDa/eIo0HXMcwVlGYyHGMX6B7GGcYny48akTP2yggxqCkidTW6MoVx7CHV4ujMtRPJcPC9VF1wyGR4d0dMV2UR9H0rRf6nlbMN6Pyv+5JGlnOJ8SLE3anpwJ7eUvsij++57ujM4dUXRiggYlttscRqmQag2Ti9s5DMM/QdIIq8SIgSbebIoFJbNGMl+gRwH+JDaz0CphcR6cztA4J9h0pCTWmitDUFzmMfqd6lo8HvABYyh6
 EFc0dBVs
 pK+NlKBAdf7Cr0qcpKNs0L3lUaG61gfMtyHUpow/HYy/GsDeMi2hIYLYGRR59z63IboKnpt+IVjghlLh/SdSmGO2Nj98BV9Uc0njd2jaVD/vwAbiJojk2REWQJIvMwbAXJGd6N1PZ8hKZ8ZzkA/EuZYhgLkcrUneI1f+xx+bp5ZVVMjvFzgIUcQXqQT4ygboYAByarfEVp0mLZWOwtfuTMngq1xRVqsamCRY8ktQ6SYxVqynW7T6BuaYVvmxdud0GmfVRZaHbiphafknhJErpoQDTyeNosYncYGFb4bilzu2RhxuhHh2ZqrNwNi68FNu97FKZ9S+cp4p/8Q10cUqcvwSEERkmuU0YRpbwuaF4O01eP5Ey7CF8HIJstDcQnSobMsppofDZiGxj9J8X5kAtfmxk95vHbfY1T1w1sIZuuCE0VZwntiLFU2LaVmKgUhBkmqZcAFpBkzarpRRydyrIFhzB1eWW5p8lYJeMSGpEC8sxAp2m4iOm3ejfhp0Bup3wOWhaHgah7VtvqtB/Fd2g/3wpldslmcu6dVdV9xavhq7WGItRK1kFUH4YHwXeJB2GkklZRGuJVEZgB3TKILsMVdTVA7324n6Zgvj/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 at 14:03, Matthew Wilcox <willy@infradead.org> wrote:
>
> I don't like the PG_rcu_free flag.  I hope we're guaranteed that folios
> in the process of being freed by RCU will not be mapped into userspace.
> That means we can use PGTY_rcu instead, where there is no shortage of
> available types.

I don't see how we could ever map a page into user space *while* it's
in the process of being free'd by RCU.

But no, I don't think we can use the PGTY_xyz flags, because while
they won't be mapped into user space during the actual RCU freeing
period, they *would* be marked for being free'd long before that.
Including, very much, while being mmap'ed into user space.

IOW, the trivial way to do it is to mmap a file, and then doin regular
enough regular 'read()' calls on the pages that they get marked as
hot. End result: folio marked as PG_rcu_free while still being mapped.
The RCU freeing itself obviously won't *happen* until after the page
has been unmapped, but the flag needs to be there before.

> The workload that Kiryl identified (truncating/holepunching folios
> from files) is not the normal way we free folios from the page cache
> so while we need to accommodate it, it's not what we shuld optimise for.

I wouldn't cal;l the current case optimized for that. It was the
simplest test-case for quickly removing a lot of pages from the page
cache, and as such it's the *worst* case in many ways.

> Most page cache folios get freed through reclaim.  I started sketching
> out a new state (I was going to call them "ghost folios") when I realised
> I was basically reinventing the inactive list.  So maybe we should make
> folios on the inactive list immediately freeable as long as one RCU
> generation has passed?

Honestly, I don't think it works. Or rather, you can *force* it to
work, but it won't ever be a good solution. For the simple reason that
you still need to handle this whole "immediate free" case by hole
punching etc.

Hole punching itself may not be the common case - but 'truncate()'
actually *will* be the common case in some situations. It's very easy
to trigger.

So you try to make the different cases (truncate vs reclaim) have
different rules, but I think you will only be making up special cases
and hurting yourself in the process.

End result: I'd put that solidly in the "Doctor, doctor, it hurts when
I punch myself in the face" problem space. The solution is "Don't do
that then", not to try to look for other solutions.

Also, honestly, by now it's been two and a half years of this.

So by now I'd also go: I have a patch series. It's clean. It's ten
patches, each of them cleanly separated, half of them *tiny*, and none
of them more than 150 lines of code. It works.

If you have alternative approaches, I think it's "Show me the
money^Hcode" time, not handwavy "maybe we could do xyz" time.

                Linus

