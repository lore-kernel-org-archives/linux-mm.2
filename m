Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23965C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 21:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D846B0088; Thu,  3 Sep 2026 17:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE236B008A; Thu,  3 Sep 2026 17:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD1D6B008C; Thu,  3 Sep 2026 17:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB1C66B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:01:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A60C12061D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:01:09 +0000 (UTC)
X-FDA: 85173671058.04.15FA502
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C97980018
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:01:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DjeDxjmu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of cmllamas@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788469267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8WxM8+POfE1P9m9JpepW1Kq4nxPF3SUoeDA/+jcOrg=;
	b=GYyK8dVIFTjGv1Ches0qVlbqCEPVtDGSiS/dQvxAjSNaPT7Z5L/AU1NiCQ138xx6KUozli
	pQecSmJRveU5nwOIlDSYeAdsTa1rijz6NKHBakJEwGFUrx6eMIijA64Z1pSD8eRzr5PIE7
	LZ6VYRD8kxAiZRFfAn0wkt4MnKlNfHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788469267;
	b=oTWeKS+lWp5rRZS4sK05RdGJwjzX/Y507Sz8dg7xuCMROmzvUiVyrQmwq5oLIlDYugWSk3
	gV2X37+TQ2qSDXwnTf1UfzCjz/+X98fbxdXsXWpXwYs8VBcV2P5BF94oo4LCgyA+FdEZ34
	AhYNrEqzPoWZNb9Jkx6Bwp5/8hqxHoQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DjeDxjmu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of cmllamas@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=cmllamas@google.com
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff3aca06so6605ad.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 14:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788469266; x=1789074066; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F8WxM8+POfE1P9m9JpepW1Kq4nxPF3SUoeDA/+jcOrg=;
        b=DjeDxjmu6I2on6JCyDDmyqHPPFfETVUWS/jfTDd7b56O1Sx/BNUKxZUtPqpr4eqG+r
         xyDc+rruSupeUBupGhRfINO3jWWlBlxjY8oCnAuyIkxy4Eq5779FBRmZCbnAsEG5nO9t
         +NtOtLQvAhMc0Ua/uVUoFI6JTqc01Nzvhkimk+WgdR8Mmkq0qqCl+oR9VSZ13EQ7wx56
         2+RzpL4ZVTSypii2SEyL+yqUGV4EIY864JlnmILy1nLhu8PACqi1hGlbfuqUMpWlA9gv
         /ZYUsrh9v+Ll0I3v4s1dsZyBomxQ0VQlZEPDPPk5/Num8ubo5ChC7KZ8vI4Vx06VDMLP
         pEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788469266; x=1789074066;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F8WxM8+POfE1P9m9JpepW1Kq4nxPF3SUoeDA/+jcOrg=;
        b=spAJViLMwdcbujNfh2HVayW8eUb3RkV+RNM544zAGqkHej4LSxnjaKQxAbpLQ2+5nc
         nDXWCp/yjftVfJYkCMRRnPBOnm8amUSwu55Vm6UGMyWDiMIuletJBTefnkR97Inivmnd
         s9HxPaqQWQuHSt3tv7fg0d6ppeMvxGSCXpmHJnLT0tds+0MK6xmEJZrWR3Dki4dZgRF0
         e3zGRQ4u89a5BgJ7jEhU/CTDDopY0p2Hux5n/hPmudRr1q5rRBozWtcK852rcJ3eXDuO
         J81uLvsJrXnQ46i1xGBjjqkMie0I40LOJTZfxTXkBynKJMcKTWvMmqpekCeqRQ0QKI81
         1b+Q==
X-Forwarded-Encrypted: i=1; AKwUvBz+fkkGPdKUjQUb5UE1K6LbNKqPOWJmbYRKXYusD+aG9MrouZ1aNHNPH6ztKIN8W5QAkEBRKCHydw==@kvack.org
X-Gm-Message-State: AFuF++lB/e7/MBiC6ws1HT/0pAmMm5uOt/tJURgEUGZ5YyFwQKfrusgY
	Zfn9GQAjxGy5WdNmGYuLvF4xZEXrz0tGOtUvfJdnABwGgb3JGi7KkfaCEiA767r4AQ==
X-Gm-Gg: AYBFou2rjQJfClqBzaOOxAVwpjYx7FHEuPnAjH2pQK0goO0dmf/S2/0Yj3yjydCbG6T
	f+D6/Cj3JmM6q2UPxQyHgiHChDP1g7AehLSymEY2I+f16fd2eohXfM6HQIWEZf8cYek1RMXwOnG
	YpKyX3QiwhPk8t9SsCokOqT710wOb732TPqFrF9FoYj7syM67HYxiONedu0scWezhBDc9KuIdk8
	i9f1NuNVDC9JWCeuzv9643VCSrYwhFBAk5q2GyXr0dw6WzN9ilHw8kcmLb8C/s4CHCrjVkELOZM
	ugN9+0g37jvmUTwcBHcaSRH3zp9L1Qpist3Y3T7cWw1O83ZpUvU4wro9ZK252ourwVikRzRghKh
	7JehG6ShIzCxPeI7YHYSCwAMWOtuiQYDSA4t8IbrN8kRnInAyl7Af4ygdpFPIknj42ovRIPLoGT
	KTdCYx21UWb95+Q/FvHGttwdrDPj6+2SGW3AIEGnYPU6TT9rBrfLzwTrTN9xj7kTEMrMStxQaZX
	D1vD+9Ad7MtFeTLCSdKpmaUND1Uc9kMR0QI0e029w16sMW4FMzpnK/DVfaOPhIoD7aG/H3W5KsR
	urhpfpw=
X-Received: by 2002:a17:903:287:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2db155f53d6mr1113975ad.10.1788469265229;
        Thu, 03 Sep 2026 14:01:05 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc454e22cb8sm100218a12.0.2026.09.03.14.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 14:01:04 -0700 (PDT)
Date: Thu, 3 Sep 2026 21:01:00 +0000
From: Carlos Llamas <cmllamas@google.com>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, arve@android.com, christian@brauner.io,
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
Message-ID: <apngDH-dLve0HvgG@google.com>
References: <20260813193433.3318288-1-surenb@google.com>
 <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com>
 <aalhqe37szvcitr46c4fk6xcjtjjzm4zfm7ltrno2spipvq2q5@7svyjfbegb3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aalhqe37szvcitr46c4fk6xcjtjjzm4zfm7ltrno2spipvq2q5@7svyjfbegb3s>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C97980018
X-Stat-Signature: 75799kicqnthzcbu7d7jt6go8u1n3aw4
X-Rspam-User: 
X-HE-Tag: 1788469267-53431
X-HE-Meta: U2FsdGVkX18g7FkFlBEIKqN7ul25VEciUkOtsPcCdyDXi1GmLYIWPkcH1gA9c2tfD/zX9sYOzSUthaLKCuCHia55OwPJ43rQYrSYEEzkK28H4kCuDGhxc85qjQUrI3+gfY4xCs7Ch52kLKPCyqp5w0gUS7XYRYeuQiDOW7Nxb+Q+yIqIOkWSf44GsQI0MCWgw5O+Jv23xo8eTb0mF98bOoTE0XPD7rnPNvuFD1V5VFNC5WicMBHI1kTxusGN1vrcPIq9oKDj1QyQ4gMqUCT+P7X4ZaZ6x3xLW45LnKIJyN0JqLqktmxoti5NDYUFQRacU1hn5RSqkBcIBT4ziHkj2isfSLV803l02P9eTpS6SMX0RQbvCtLU6/X5VhszzDvxodoYu0pZmSrqx6tC5oAfqHfxj9kkEzPEfkmVdWEqmOvwACqhLCgrBLgy0P49LRYzcA+BDoPX2MR6xDE3d7J+lJTY6cIrGMwv+UYNVfIR1lsj4dK7y101N8llPzdq5jPiwXyOPcM2FEyBo4ob76as6T00DoPPNqs1+BnwRkZ/Sb/QMCFaiO/EPpLh5SwOc97LCRYjKEXBgrIQXzoM97gm7nbZnLS4qwaq2ZurHUMXwD+TFvqmijRMbfvoROWvuBU36rLqoKm5AMjWXMvG3aV5tkqxfoS82FYAb3VMApPgZwbjNn6FlaVE5X5qlOBpWP0bfrq6vqdB3rXEq8GiGvZRUwaYUm7cAQqWc+bb9SoOrp61wPyteFImY/Eg37YqUCpZz47G+/slSJqeA7xWcLpRZlijptvQsdWl00jZn2SkvgyTgaz1qWZ0pp4BUm2Ayy5036f0xSO2DoTRj24OJvDQFf/L5BYJQEa7JZxC4HYcsh/Y/0wRQFz7Orli6V05+VYFPqBw1GDsVWVNTj9TL0iu3mvfF2Zo9qXLOry3X690y5Iah20BNK8uIqe/rZEQW4XE5tJi9jORVTfPkMswk4b
 v0c8Y2es
 4XGCzqk59gYt3d81bw97lBs7VuxNjG3yBF9Hb9MO2W2TvhI1wK5+E9t4ZuIb/tlhl0n+RQ/JDmQr28ao0OvQeTyG5FElreDXKmOTpqXz5QmeKQFYFtfuD9DrEqZi7WYrXqXpm8iAPS3kgCotkOVxAdvzUR5XxmSyZX20QEMJ2Z04NNxZDSa9Or44szfME/z8phJ3j/jgDFuUz2cnQ+5IhTO3tHnBtrwSW9bqJe0oCC6vrLrT+ihMT5aFLnGwZLGn6mx+PV8wKEBdlKnaVlt6mAPyFlLw2G6ikevs3Hr+A8muRzofkx2OoMUdePLe+8TvrWvn8pb7UFuU+CHmxuJk8hNVIznlReAqCNB82009wMyqmUrgBNfIzTj3FSEyBOurghQsbf4V+ah+3qyD7IStbB0VvOx2QWkelNw56kfN0F1JUI4I87nMiI0Moc7yrTyWBrayo5/St8/HZoT91Z4+/annunBY2BV/N6DTiuN9ApDb7xqVzAzeJnQFLknSkllxAxYUq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 04:48:31PM -0400, Liam R. Howlett wrote:
> On 26/08/31 11:13AM, Alice Ryhl wrote:
> > On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > > 
> > > > v2 version of this patchset [1] was written by Dave Hansen and per his
> > > > request, I'm taking over this series.
> > > > 
> > > > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > > > of the per-VMA lock users now that they can rely on them being
> > > > always available.
> > > 
> > > It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> > > 
> > > But it applies well enough and is adequately reviewed so I put it in
> > > there for testing, thanks.
> > > 
> > > AI review might have found a couple of pre-existing binder bugs:
> > > 
> > > 	https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@google.com
> > > 
> > > and a small rusty thing which you might wish to attend to.
> > 
> > The binder bug is not actually a bug. When using VM_MIXEDMAP and
> > vm_insert_page(), the vma takes a refcount on the page, so there is no
> > use-after-free even if free_page() is invoked without removing it from
> > the vma.
> > 
> > Adding an INVARIANT: comment to the Rust code SGTM.
> > 
> 
> I think you are correct about no UAF here, but the page isn't exactly
> pinned to the vma - which is what I thought you were saying when I first
> read your reply.  It's sort of misplaced in another vma by an mremap().
> 
> vm_insert_page() will increment the ref count, but if the vma is
> mremap()'ed with the same size vma (ie, not expanding), then move_vma()
> will relocate the pte and the old vma will be closed and set the
> binder's mapped = false without a change to alloc->vm_start.
> 
> Binder now thinks there is no mapping but the mapping has an address so
> it can't map anything new.  You could get around it by replacing the
> vma, but I don't think that leads to anything interesting.
> 
> So we still have a ref count that's okay, but now binder has an
> alloc->vm_start that's stale and a mapped = false which leaves binder in
> a bad state (one might say a bind).

Right, binder should really reject mremap(). And partial munmap() too.
The is no use case for them in binder and it only brings problems such
as the stale alloc->vm_start you mention.

I sent out fixes for these issues here:
https://lore.kernel.org/all/20260901205250.1638304-1-cmllamas@google.com/

I'll Cc you on the next round if needed. Thanks Liam.

--
Carlos Llamas

