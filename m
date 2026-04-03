Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59691D73095
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 04:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCF26B0005; Fri,  3 Apr 2026 00:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DAF6B0089; Fri,  3 Apr 2026 00:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C836B008A; Fri,  3 Apr 2026 00:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106CC6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:34:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99DC21A04AD
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:34:53 +0000 (UTC)
X-FDA: 84615979266.24.E4CF2D6
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2E3A40009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:34:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UShXKNLg;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775190891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLs2A1L5ldKsuvkAuvcT7bLQaCWLBYPhhpzCbHMmRto=;
	b=hxd55F/9kh1tc61CPB6G+aCrjZLZQyVQO6jeyJPQ0L4VvYx+Zy0Du9f/wEOrkewMzhZVg6
	gRvVgNKmRG/VNBEZpBGq8EEYQfzMibDOgk692pCz8IciFvb74dKQijhLu3+E5AIZF9tCDn
	wIXWDH60T1+CogaK9b45PnPOZ9iADHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775190891; a=rsa-sha256;
	cv=none;
	b=wTi3nQWSoBtz6fMw4dumChYAghMytrIzbWMlvCSk/kFOcsy1t1hZD79i46EYZlP08EvHNz
	mZ/JsHlXrJiPFHcgttZJNGzIJBQx4gGabz2bUl5x4XmDVYVoQFpaKZFt3GVgBPn5DPQWB/
	ApuYFxmdvAlp58KjI2PquljqwRjGY3A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UShXKNLg;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so1309623a91.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 21:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775190890; x=1775795690; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLs2A1L5ldKsuvkAuvcT7bLQaCWLBYPhhpzCbHMmRto=;
        b=UShXKNLgR5kYKtSS5i21SQkECC6XZ6vTMbXINcbV8ETT2tNpZXi60Igw9Ytmiwla1i
         sqscm8tcEGtlMCTTPDKMpa+ypK+LlZ2kYiQiBIJEQ8efItgYqhqsHOjlrtwo2NIA/1Tb
         MkI3bh6UioeoBY0ALNUTM9Vw+lcXp66WfC9YYJ96lYLrCJFF41f24g12/XrAL9gJJXkt
         OzpJK4uxksq85sjDM+aIozbRclDOOBT2TJgUKvd/XbdGZh7KZ1MVIjdyd1l2BimO/254
         O3Vmcb4JuoAMJgMtsywFuB0/Kx6Z+I2RsmLnc3D+D1RuPVFXYz1rEe9ySb39Z24qNo1F
         fMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775190890; x=1775795690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tLs2A1L5ldKsuvkAuvcT7bLQaCWLBYPhhpzCbHMmRto=;
        b=B/DEN3TJmmpaCSbL+CV4GHCZGujGHbBWalJIrG41i7lonCWY9ubnswEVy3x9dmW4Q9
         yCUvuqxCXGb+++G6uBmztELKqv6yuKIJxujakve4BDomwoYmtqaTVyM22t83ikZ3m6zc
         i1KgxjU/iWXJVOKO2yMZSon6ZFolPIB8Db9MixwXDwHdm7O2oCdTYevsJA9ex4okzXbL
         pKzwUg4WirnB1yZ8utxd3n6uCO0aAo5gkl6BD0KzFPxQZSGhknoBQv6GPaMHOsX06UCh
         TMLdmXFeOyl2pp4SD7Jh6mRC/aIZ5FA7AU5GHy+04QPyMRy/uDheP1IVZwkmdV9H0Eml
         pfHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIdxKjXLGqbO6bnd6zxsE7xdZDog35OpYE3A1XkNR+XH1UWjEKlccKcuokJTtJK6lzytGYVtEXuw==@kvack.org
X-Gm-Message-State: AOJu0YyVygut5cv4s055g6cXRwexUzAn55eGwjjHoOinNFJz/T0vz8Ha
	0NUgoxJt7zYq6UTa1iZAHW0St4+u4ooqkqOmIDRR4fhF+0QyPgK36Bnm
X-Gm-Gg: AeBDiet/+mToNXawRBCefSyhKmp4+1aKp+DOSpF4U3Dev94hkI0r7yXuXL7YRaZSREK
	ZCOCxN/ulkF/j+Wy/m8DnQYVqYG60Iw998Yj/bwM4tggzRjcf/kOCG2Z+xL0YeAcv4hcJsCkpDr
	QKBhGoChoGjF8yz2FCbIOc7BsIRmxHEkHwCezQwid+5jkzrLTwLlIPmqAArfuNoLH03ysFpmSiA
	RvjN/alj9CRRhFpJFWBO6+VNls6CNX7U27zgVzmUQiyozJZFmO+7Wtr0ZV2cvNnHk7vpB0uOblT
	kP+Io3Tn5KaWcDPnd4rVTbngpf8M4v1u36rqJbS/FEb8iP5b/KdkLFA8zPnBKfUiM2udq49n4OY
	slAMfLswQoIR/BB15qhtu8R8NB4lbgEeth4+cKckVGCmZQO+G2t6rL3zOjQMNweAfQVIJ2AOr8F
	jH2EFrPyOXzXCB57WpC44oxbmWk38=
X-Received: by 2002:a17:90b:3a4f:b0:35c:1c77:fac8 with SMTP id 98e67ed59e1d1-35de6957963mr1434066a91.30.1775190890455;
        Thu, 02 Apr 2026 21:34:50 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de4ff7c91sm396760a91.0.2026.04.02.21.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 21:34:50 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Fri,  3 Apr 2026 12:34:48 +0800
Message-ID: <20260403043448.53045-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402135440.74339-1-sj@kernel.org>
References: <20260402135440.74339-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2E3A40009
X-Stat-Signature: px3umssepub5hbazr4hhewq5wu5fsj8g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775190891-103165
X-HE-Meta: U2FsdGVkX1/e72pU0JfQDreuo1azd7A/xXOT+4671hbonz+HvHkuysQ7hfDqY+TDIS2QseeAKjXBaGC3ENqyfoXFKmnI3wiPocb+zLh711nxJTeOPf2s4HvkJywC0iRovHmSb2xAP31Y3ekus4fYtcOqLEJxmyWvhVX4eGuMXpXiGNQSqxs+6HaAYzWzYTe2liKE02O8kC/ygPJnWvhEF2mqfSQMviR9UONRJiaO1p7ZjgRIi167O3XO9lxFYOLZxpOCpiM8TdKrirgJC8ECE4aWYg3O/8lX3I2CiWV2WDZCZY0SavMJhlFBaXvh7aUCZui8RDRVTa7mLJUBrEi6AOtwHzEyrRLdEP6YTYq80rqszXihVspiaf1BNHz/eTx6hBG/0RqNUtdmZZZr41YANcdmYH3F5mTtaFrRvjJRfmbJgiCks7w//mxojkNtoQvZMMoVU5xcriJAqkmi/nnmZ0gaX/nQW8DDBwlqvFUVrJJODiA/cnONIlj/4m9BhQvygL4PgHg1kHuDjZXPV/AeP4f9Yv1yQd1E9Zc1bkryg20/so9ap9JsJFvJfbq8vVH2TfOgN9GkKCImVMCw5xk3Low0T1hFclsKgXDdQdZd+kgMwH0VUKNH2Q7C5wsOqc1cw6ixtuP3ZZXm72lbozpWvF0WeytKhIULawDdrduMMyksMD6b5zdoGoM2ljskKRDRQYF3TgdvsQzYGDDBXfjzBmvpMzl1kEwUPB04qz5TcO/WzOwqteXBHOcpLMoVFQNgd2Y3hTOFxZTIBj14EeJNMq0KRv+bBP3dnCQ4CrCdGFI+x8/Q64KeXVFHMzmFTCoucnZxgGwoCT+h4oB+rlxCXxU1wOUCYbKWOb1vhAJNu5Atd2E0RBqKwaG3E+iCGlGIWYwUG81BVyQvwZud2yirVaXz3P6AErVOy8ODCiIzkXnyeaQywAL8tSnnxUOIGjY+j9dv4HhMmWoAUivTg9y
 GX2W4LrB
 8tRqKrV6Xr1C7xPHYorjlw8FFQoaKIRoz6K+ZIWDgnYos1PDnbiZ9wTdcIH9gY78DRRXbVK8x0Xa9s99TbADBQe4gQMjJDONPp0VqnPsgkT+7mnB5H063yY3+l0+EHuSQ6csc9l/U5BKvA4aWy8zokAj8Ukyr9Tme+Qb9VaYiGKHXL7vxHk362DFnux48Omaokjhqr2vDt1ljzcF5vNOq5fPfxzMS0gSc7ES/e742mFh82J41rcLp9kKTq+5cwaCYqBiWaU0g0pK8Rkg3UgPMXvIv/8XvJwBA/1VcpKAFAOiSnptD1Na0py68m2AJPqv+DkZCbgk10I8jFwvpmwzo2GRwI4DSfzNTfXABwIY+Y9zCIt8mUxRuc6BXQ00uDlG9m9sP4JiyphUKznc0AYKg2Py/K1tR19SWM/pJ2/UmzUxpW6j4aiPtdG4a6b7+J1NZoDFq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 06:54:39 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu,  2 Apr 2026 13:34:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > [...]
> > My plan is to add the error check directly in apply_parameters(), right
> > after damon_commit_ctx():
> > 
> >     err = damon_commit_ctx(ctx, param_ctx);
> >     if (err) {
> >         enabled = false;
> >         kdamond_pid = -1;
> >     }
> > 
> > This covers the reproducible case (addr_unit=3 + commit_inputs=Y).
> > 
> > For truly unexpected termination (e.g., memory allocation failure inside
> > kdamond), I'm considering a fallback mechanism in enabled_store():
> > 
> > - When the user writes 'N' to 'enabled', if damon_stop() fails but
> >   kdamond is actually terminated, we reset enabled and kdamond_pid.
> 
> Sounds good.
> 
> > 
> > - When the user writes 'Y' to 'enabled', if enabled is already 'Y' but
> >   kdamond is terminated, we treat this as a restart request.
> 
> This sounds bit odd to me.  User shows enabled=Y and kdamond_pid!=-1.  Why they
> would write 'Y' again?  Yes, they would notice kdamond is terminated in real,
> using 'ps' like tool.  But even in the case, I'd imagine users would write N to
> enabled first, and then write Y to enabled.  In other words, this could improve
> the user experience, but seems not really necessary to me, at least as a
> hotfix.  What do you think?

I see your point. I wasn't thinking of this as a hotfix at first, but
you're right - for a bug like this, simple and backportable is the way
to go.

So I will drop the "Write Y to Restart" logic in the next version. I
will only fix the state in the 'N' path and after commit failures.

> 
> > 
> > This way, even if kdamond terminates unexpectedly, the next user
> > interaction will recover the state automatically.
> > 
> > Does this approach sound reasonable?
> 
> Yes, the plan for the next version sounds good to me.

Great! Thank you for helping me scope this properly! :>

Best regards,
Rui Yan

