Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D22D37E42
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6966B008C; Wed, 14 Jan 2026 10:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FEA6B0092; Wed, 14 Jan 2026 10:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C66B6B0093; Wed, 14 Jan 2026 10:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3CF6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:21:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EACA5917E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:21:38 +0000 (UTC)
X-FDA: 84330933876.04.691E3ED
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 545C7140002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:21:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.170 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768404096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dI9Phsj/nSMNdFp89o7zHIAUGa2rQCyWo79deKjR47o=;
	b=7U1nHP166JiTekpMxZ6ai6QSfqES0lQm9R39pzYH39GdagazAt6/wfQOR08pFZzlv1lYIn
	zCLYCNc3exYwWYcKbxXDhUIRqRaHRY8stp1QsDQx+X2OjSPjZUXNFop+aV22AuFnjl2IwR
	okC+IhTK1hdWXz7ehhMh2pWAHN4rioc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.170 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768404096; a=rsa-sha256;
	cv=none;
	b=St+k9kcbT0eYJQ6+DQTe1s4BzaKm4SZjUI/iVuhQDSapF+tclVJZeZo5gdrdnqZZDJBMm0
	94skRfd12TJ5ICiEEfeinwGRLiEl64FbDj7kR8uXPfng/AHpvko39QsnQzzDKPO8/Pdn7t
	xp9AgpKJ2BuxUY10th+ohTjiglJcVm4=
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-45c7400259bso281519b6e.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768404095; x=1769008895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dI9Phsj/nSMNdFp89o7zHIAUGa2rQCyWo79deKjR47o=;
        b=nrB04uKUlP+hVBxR/KJlqx5Ul1H47/N/YFQZ0ldxYOGbVtwr2jAxotpJ6HDp1ifBDK
         43LvQlLAe8reJh5P+YMl/p4qMltn7IrXNv/dznRZWqfq/Df3yAT9TEpun5CrXO7ADlJs
         QO+Osanqn2KLAkWND9+bhrwD9mlva6tSJQUAf6BUEUNLWupr5auTShRHI3cE9/WPyNbe
         eGpYAeyUDgmOXVK2RQNe9AmdnLQ4DYEeYuBsyii+I/IYUtDoqGOAcA54zG1F0JUhScx5
         u98ThixXWlBHiPJnEIYZ8Nr3J66gxa5FW3i/puEjw8UsGga5P4MfPfWlr4cEaEbJTfQ7
         FZkw==
X-Forwarded-Encrypted: i=1; AJvYcCUgOxQ3w2ThBulJZStHFg8pQkMClFT/KdGAeJ4kK2YIjNa2DwP7/c4yi0w1H5Vl/70481RmDGI+4g==@kvack.org
X-Gm-Message-State: AOJu0YzIPokFJmBxB/PCLhiQEMBK4kMCo9tITi926zDmFDBTgHUFzHpM
	5A8epUHyYjfyCm4C3JHvT6KNevk62E5xzbw61pq8PQ6zwrWwHSXnC0jv
X-Gm-Gg: AY/fxX5oj75hqBY9NwEWPgSlSoLMcRzefJfP2M9fFi6OJ9Au8lZsJtfuKpwayzCzagS
	bldYzYdWuPwCs6FEuGGK7QaVAyd4tT4uXcvrg66ux/AxZ5FuuMLrsvFN6STJ8STvDMVD3JySohy
	CrEJxGEt/RQ6jEFH2GFwa7cJYErRLKCABP6GSOj/oB3vhdNjpl4pIOCtOu5thVRzC+Ll+Z/Qnet
	vfhzwQoJGGX8mNSIpDiEPCX24HBUnmkmFUjzN5iVVDZ6k2zrYGQ90EKuVTuGhvQvFi3kG6gcCMB
	bin1vqn5Aqv2gDoJl7EWFYPJKCaAwB01WcwTxGI3icVqKCWfA8AwFLX1jSdwuemCBoKv7D45c45
	KYy/6dXBmxc3fedC4HnXM3i73oeog1/XNOQyg+IGLqZQwvPiMNDJPv5uy1bk3HaqzIwsDi5wNEM
	hfsUjgSrEjZ2iw
X-Received: by 2002:a05:6808:528e:b0:45a:5584:9bf5 with SMTP id 5614622812f47-45c714331e3mr1702212b6e.4.1768404095351;
        Wed, 14 Jan 2026 07:21:35 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288bc7sm11600518b6e.12.2026.01.14.07.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 07:21:34 -0800 (PST)
Date: Wed, 14 Jan 2026 07:21:33 -0800
From: Breno Leitao <leitao@debian.org>
To: Chris Mason <clm@meta.com>
Cc: Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kfence: add reboot notifier to disable KFENCE on
 shutdown
Message-ID: <p7gi44yt26bpjbjkvuhd54tqp3vn7z6wq346gmvazg5t3kir4p@gdf64eax44rm>
References: <20251127-kfence-v2-1-daeccb5ef9aa@debian.org>
 <20260113140234.677117-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113140234.677117-1-clm@meta.com>
X-Stat-Signature: e4gq117fnascmmfxayfmchzrfgwnfu1i
X-Rspam-User: 
X-Rspamd-Queue-Id: 545C7140002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768404096-695989
X-HE-Meta: U2FsdGVkX19jQWTjb48qBG+V1YrVicXhSkJy6MUQpsW6Ep++lJdzJxm9L/8iDl6QK5ysUKJO5g3yyzL8+Zbur5ePaSvfVBMxsPlBHBzGw1I9q6EzmCKk0mUbcTXYPkx4jnLIJ7uRAZxY5FlTenqITLMa8BM8Kvk3JSLWyzaLTEIIOlLc8EaugHoSDhWLiMdQjHHR4PPAcSFLfyzOdLf4YCgNB7pTvxWYu5UdMhnq56Ey0urTsmB8c7iJi3DucSuy/xVwkfc+WVsqOxtkbyzP9AxnjJs2Dap3FZplEyXcm04o5ildRwNIS/5vXdXRzpy8RMwaAwHKc5auzg61zFFCQuH3WNjp4xy+E6iiUSRxgx6Fv+5IVxjTMi8f8HRB3IK2g6nEniMqg/N9c+GNDrlHFz01aiYwEi8QrA+UmnjQFKUVW1cD7G5HD3ZD+VSp7WWaltnp2YBrThEvkJD7EDogxfAtMee6/wd//VrdTEoGsXMSQ09TWi8mC5ucARlp2QHJ18fkcLEPGXWUaFJmOr3gpTaJRUbiyD56hJr03Jfr+6RnBVFb5bzgYe4M6nrNDCCoHUoENk0NkUngrWQlP2NluEcJ6nSHOlvoaupYfShAJ3CPh275AZ7x8eZa8nwQvZI9ydJmJDYxsKLjF4k5+SSQa5owNB1hHbYYOcbTZArkb1tW6CmHMVcPg07S5vE3J7l+dU1/oCx5L4mMhEVdNrNADlfPrO7zlQvuewlFVf2//okyyYjMy4J2rNwKV2geydpv9hDwUsX48AtExAvpc0Xkn7fL0OXSWSvITGDKtjAnezgKetkEdUFhONSYTOseoJDtTO1N60pIb/rHZqgI8p2jmmezP0yblM5GDupDgr1jcAInf8doC/Eh4XqZT8u6tm2iycK0LHPq8MtGW/6rdfz1mgdqyOkGG3pOi+zSNUchZ2v+s8z5WSdAWY7pY8OEqv6c/hyqWt0iECy7Em30tPt
 dROoIcuI
 E6I24I5SkpgbOcd5Sj874uLfl28aPs7INjoXpAFV9AHIBLkrPb/B8NgT5/Sdb/IzB1kcI89YGaYOJMzjgSxnZ5u60cRpWkNi1wiD744f0PtvYNJ/BmSeKpLBM958WPH8qE5U5lxgw7QzomDN/bevRvgLSckrMaF6OG0fEDTU8FCOcq7hNoGjr2NL5Pisq2ztYhBtBy1tNNVykRZQRcCYibBUoLpszPb8ZNUk8Zn/yafvix79krAQFbc+uy8NK5XTZZPWLppocJMyWQr06STjy2vYoUU8yn8lmFx5oUh6uGVXxK2jwGMYyVSa4GpIXHhiN8ENL7la3XiAfzFdwnltT5GrBBRcAfnhovntCDcmVvJaa4Ixhwb+ZG3HmBAQogrKWE62GSvzpIbcXu6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Chris,

On Tue, Jan 13, 2026 at 06:02:27AM -0800, Chris Mason wrote:
> On Thu, 27 Nov 2025 06:51:54 -0800 Breno Leitao <leitao@debian.org> wrote:
> > @@ -820,6 +821,25 @@ static struct notifier_block kfence_check_canary_notifier = {
> >  static struct delayed_work kfence_timer;
> >
> >  #ifdef CONFIG_KFENCE_STATIC_KEYS
> > +static int kfence_reboot_callback(struct notifier_block *nb,
> > +				  unsigned long action, void *data)
> > +{
> > +	/*
> > +	 * Disable kfence to avoid static keys IPI synchronization during
> > +	 * late shutdown/kexec
> > +	 */
> > +	WRITE_ONCE(kfence_enabled, false);
> > +	/* Cancel any pending timer work */
> > +	cancel_delayed_work_sync(&kfence_timer);
>                    ^^^^^^^^^^^^^^^
> 
> Can cancel_delayed_work_sync() deadlock here?
> 
> If toggle_allocation_gate() is currently executing and blocked inside
> wait_event_idle() (waiting for kfence_allocation_gate > 0), then
> cancel_delayed_work_sync() will block forever waiting for the work to
> complete.
> 
> The wait_event_idle() condition depends only on allocations occurring
> to increment kfence_allocation_gate - setting kfence_enabled to false
> does not wake up this wait. During shutdown when allocations may have
> stopped, the work item could remain blocked indefinitely, causing the
> reboot notifier to hang.
> 
> The call chain is:
>   kfence_reboot_callback()
>     -> cancel_delayed_work_sync(&kfence_timer)
>        -> __flush_work()
>           -> wait_for_completion(&barr.done)
>              // waits forever because...
> 
>   toggle_allocation_gate() [currently running]
>     -> wait_event_idle(allocation_wait, kfence_allocation_gate > 0)
>        // never wakes up if no allocations happen

This is spot on, I think this is a real case if the following happen:


1) toggle_allocation_gate() passed beyond kfence_enabled and is waiting
   for kfence_allocation_gate to be > 0.
   a) kfence_allocation_gate is increased on allocation time

2) There is no more kernel allocation, thus, kfence_allocation_gate is
   not incremented

3) cancel_delayed_work_sync() is for kfence_allocation_gate > 0, but
   given there is no more allocation, this will never happen.

> Would it be safer to use cancel_delayed_work() (non-sync) here.

In this case toggle_allocation_gate() task will continue to be idle,
waiting for to be kfence_allocation_gate > 0 forever, but it will not
block the notifiers, unless we wake them up.

Is this a problem?

Maybe a more robust solution would include:

1) s/cancel_delayed_work_sync()/cancel_delayed_work().
  - This would unblock the notifier

or/and some of the followings

2) Return from wait_event_idle() if kfence_enabled got disabled.
  - Remove the waiters once kfence got disabled
  - Cons: kfence_allocation_gate will continue to be negative

3) Wake up everyone in the allocation_wait() list
  - This might not be necessary if we got 2, since they will wake
    themselves once kfence_enabled got to 0
  - Cons: kfence_allocation_gate will continue to be negative

4) bump kfence_allocation_gate > 1 on the notifier
  - Avoid kfence allocation completely after it got disabled.
  - Cons: it is unclear if we I cant set kfence_allocation_gate = 1 from
    the notifier.


Thanks for the report, 
--breno

