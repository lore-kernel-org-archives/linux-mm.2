Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480C4C5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2419B6B008A; Mon,  3 Aug 2026 12:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1056B0092; Mon,  3 Aug 2026 12:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1077D6B0093; Mon,  3 Aug 2026 12:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D69AE6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:08:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D1F41C085B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:08:23 +0000 (UTC)
X-FDA: 85060440486.27.6D69CBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id ACFA81C0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:08:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsMJWp4M;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785773301;
	b=3UNPmRjOrU7VqYvrP1tvvb0vp2/BFpTFZGyf+xdflXxBqizfn/kSahsCa+8bTq1y4kqx3w
	/a0shJh4fj3sp4R6HH6oZCZ8hqn5FnRxsdE7/Z0XNSEzvHNBODPe7vU6AuTZjelqCFGvUQ
	yg+/rpkFr8oSW+c5TicKpY6S9414FqA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsMJWp4M;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785773301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIOS9gH/ObXju2U1bijIiFnO6dVMlXGYaTa4UALzk90=;
	b=lBBfjLpMLZ6AgIvmAix2EYactqfbnRj9pg282ONRlc7BIoN2NCGxKXJAdJcUR5VsL2Wp8Y
	WRJV8AVITmzq+xAShfSUhJBlRIybPMYzxj9w2KBJArb3YPBuO7nZDkbCweB9jMr9UlEyO3
	bdRxvS5skb3BMBWzUYFthSmBy9FL82o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DBE140A5E;
	Mon,  3 Aug 2026 16:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F591F00A3A;
	Mon,  3 Aug 2026 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785773300;
	bh=fIOS9gH/ObXju2U1bijIiFnO6dVMlXGYaTa4UALzk90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hsMJWp4MQa4KKnkImO2vc3J60puoTWiFPA78upH/01FXTf9FgZ9BjezvmSMIseSHs
	 NgpFTBGpkgo7K0UDrVJIBOA490xwd1m3RUTOq1Y5ybRJYJ+TBtfXlNzha0nK+gdswc
	 sba3GwHf8IK60VLp+Cj4lnGSWeRlT2yNSV2jAvOZxdxsUpeXeVK03erq7UDgNfnNvi
	 G9tBIROKVnplKVUF6L/CiBQbNJ1QASOwJ5mBuH9krhlJ4ymal3J4jWduEJ0NE+kaYN
	 N9knHGhcOp6AL8PSmtBfcNWGRw3LdyAG6APJq+6g0IWr34aK3ElRM0AIGh52bSUezH
	 Vrelgh0NAVcpw==
Date: Mon, 3 Aug 2026 17:08:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
Message-ID: <anC1iE21eonDK06n@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-2-surenb@google.com>
 <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com>
X-Stat-Signature: yumphdpfzo5smm5aqbm5fer6drhwu51w
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ACFA81C0007
X-Rspam-User: 
X-HE-Tag: 1785773301-1421
X-HE-Meta: U2FsdGVkX1++ugBMLLQofeE1hYEbHOgdwm38FH6+140I4l/NS4oBB7zgQRoFdPfJWlWxTE6xYTWoSa9xndpDGX7OeaDJELLIPrFVnhRqpQNCqU77zt7Q1eUaD0zR383AnckZmON12yWFALzHyJnHlHxleiLVEW9vadXg+1xb85lVDNQ1Y0RDvBqSGj3mWsZjm30LvkxYXrdgtrOQTPlsoxB2Fblyk8OTNh16Kh2wrBOifmIwFpna8q2tzUuodEO86Xsqf471bstTgyekPACXEwBkfL9jmW837gIyuvyYOZtSeiS6DjyFfUKV3Ffu5xScgdktNHE2Fpi1Y2DGhlKJIIKtbRML03SRHiC0pfeLqMnY5VDKaBp9SfmSlD9g7TvTRVeV6kk6rHGGzbkBhgcP8OqMOSIwREkJbz2Mrxk8kHOyuiZAk4vK3zOFrwDf2IVXsSYYGfg07hVR1S0tSd+0lhiT2P3suPN1Q2OU50Thj1akzulhSaEpY3jNe3uftNtdGJho6qBh7WlrCN3sUXXur9w6R8FhowJFltp+TLHNrSXwcjNiYvwy4H7voUKLalkyJ4+2i80ofJ5uo3yfS3Jg2Om0rcd0h1VEte96m6/CVLyb4kD9nLJ9W6zKCHp6hYtkaIgJIX0C35yVJFmy7mZo9aX/pIzjNrSdPIVOmel0DkqstBeop0Ph0otKQBY5TTVV/MxuO/lDXb7sp8O4p+Qfx+zND2qJzNLt5BzJmGyeIrWDMWxRR+2E+RnVJYbxYHvAFhNkC50ArHpSbF7ef11Ra3IDiMLINI1GLARpYZ0NEqrGBuP8EY+SKWTmZAMjcWemgGFkFbtBvtvsd4oPBSM5LEoxDHz1TA3Huq2wfN2rIjAj7pwqct+Ipol8FTXoYyILCqxUH1BczJCpg5aD+lNGoTJPy0hikJBtYEWqJdOarrfmdr8iLbsimhGt3VLEJypil9/oVIYh1BV4NIZIr+w
 r1rVgXLC
 +iqpcWe+bc4D5GQPAm36tc5qFOSJzANpaUHoYUreX7+j4tr0kGCNWsliyyCzHrw0mAikhR3kTT0/XiuL1n+Y05lhPUjO7EIlPKRs3LIGqmLKeKYFtZophIAcmLzok4zndx7vvQLmepMjqh85VfjtRYwIiXce9e8uOCLMDWTJzA5HTfxWpUTHfjQs+h2WxULm37+Acn4Zc9Va477+FUgZ4kVyTuRshkITnp0ASzEi9efktMvyizMCtgrSajvNAo+42WrjT7EvmbSW0cjDtmF77IlllblMb2H7I2238oAuKJhrKYVrQ2GcyqZcQQdeV3f9mypGb51lw1eMPtmlukjoVadaB6O2bTdUHHq3wWk6+828Xf+QQC+xBAUVqSDSTl8y8yNjnV0TAnA7WIltKbrQjecnCGr0jHcal7tyCRXYWyAxIvEgT4grJdvSbFRBQBfwrr1ZnnHhq6tUtzHsqyMyGhzB0dtRRSRTY+80mZE0bt+zTFb0tYKJ7z1m/bvHtR0OXI2WsRj2I7KMHqpo9k+UNrfdC/647ffz2xBLn/MJyg5r+/tvqpYEZnf5ufu3aOEdvRGlqV7DCfOihgKDjMPrOOUwgqNUVDp14zNmoR3MILxOE7lgofnLtVS2cEM4CitYXtKubXz4JmWyI0+1pIhM2LAdakcrXcSbdVH29DWUFmhEpOno8w7x7EOvjHPZylI76BJGPAR/ZoExOoWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 08:24:44AM -0700, Suren Baghdasaryan wrote:
> On Sun, Aug 2, 2026 at 2:55 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > The per-VMA locks have been around for several years. They've had some
> > bugs worked out of them and have seen quite wide use. However, they
> > are still only available when architectures explicitly enable them.
> > Remove the conditional compilation around the per-VMA locks, making
> > them available on all architectures and configs.
> >
> > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> > when the architecture started using per-VMA locks in the fault
> > handler. But, contrary to the naming, the Kconfig option does not
> > really indicate whether the architecture supports per-VMA locks or
> > not. It is more of a marker for whether the architecture is likely to
> > benefit from per-VMA locks.
> >
> > To me, the most important thing side-effect of universal availability
> > is letting per-VMA locks be used in SMP=n configs. This lets us use
> > per-VMA locking in all x86 code without fallbacks.
> >
> > Overall, this just generally makes the kernel simpler. Just look at
> > the diffstat. It also opens the door to users that want to use the
> > per-VMA locks in common code. Doing *that* brings additional
> > simplifications.
> >
> > The downside of this is adding some fields to vm_area_struct and
> > mm_struct. There are likely ways to optimize this, especially for
> > things like SMP=n configs. For now, do the simplest thing: use the
> > same implementation everywhere.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hjønnevåg <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---

<snip>

> > -#endif /* CONFIG_PER_VMA_LOCK */
>
> Now that I'm looking closer into this, I think we would break NOMMU
> case because nommu.c does not take VMA write locks at all. So,
> lock_vma_under_rcu() for example would always succeed.

I don't think anything's broken actually.

Per-VMA locks was gated on CONFIG_MMU so nothing there assumes per-VMA flags,
but now you have stuff that happens that didn't before but:

* vm_area_free() -> vma_assert_detached() - fine - it's always detached in nommu.
* vm_area_dup() -> vma_lock_init() - no asserts, just sets refcount to 0 (correct).

AFAICT nothing else.

So seems fine to me?

>
> Extra per_VMA lock-related fields in the vm_area_struct and mm_struct
> would also inflate NOMMU structure sizes without them being used. I'm
> not sure if this is an issue we should consider.

As nommu co-maintainer, no it's not :) I won't have that stuff blocking
important changes for real arches.

Go ahead! :)

--
Cheers, Lorenzo

