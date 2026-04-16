Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC64FF8D754
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F36B6B008A; Thu, 16 Apr 2026 10:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CABD6B008C; Thu, 16 Apr 2026 10:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0A86B0092; Thu, 16 Apr 2026 10:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8CD6B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:38:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD135E4AB5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:38:04 +0000 (UTC)
X-FDA: 84664673688.22.4D690A7
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD51D40014
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:38:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kLDejRMx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776350282; a=rsa-sha256;
	cv=pass;
	b=R2ifSf+TtSCqJFBzru+xfQ/opBHlUzd09zwv1fWY+mCQBuwHJdgjzDEfsEe818i2fnQJAA
	uWe4vqDqA/8aCKK2XFEufOM1WnIG7S/v3GkRCc1ThgbCxK1w5Wt8cP3TBgUZTcmeD1kAVs
	Wj5bn9PcW1p7ykWgDQKXTXsW7EVxJ0M=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kLDejRMx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776350282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pkKSjP+wJVMcMFvJFoHSHFWn8sH3nk4J1o7IV+VvKA=;
	b=gsd7Phn3BN5EUClDLDEUfezAcjPEghn6G4JEeCx5fJ7uPSzvyOdv72Z/wqz6409SydFKgb
	9nAlpmqYlNTHmx3KAukLT7S37xlpLmd3R9XzoRVBitsYC678YYdFb9LqIMy9BzbcDhTVKK
	Q9+sieKeFkJ7vdrtkDip3XW0oiBxcRM=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48896199cbaso83975825e9.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776350281; cv=none;
        d=google.com; s=arc-20240605;
        b=LM73LH7f3l46ULU1dMuIZRd79/OG8dP6e4OOtB3jSILr+67S73gsCJbNiuRCbd81EL
         itv4kkFKYyuN0gKM90oKaNVtVCfVpWp+ZvUIude80RjLMrSF1zcpW5eZjG7IfHO5kB7E
         FXCfrcm687gNqlEicB/lLGxbTGFx+eQTaVtZGXrJOq7hfm8e7NvoksK7pcKT+rtQ/mu3
         XVlq8CDtQjlDIPLmWre7GgYYWMsQJPSGIDiPZJ2SE20QmcQqDx7W3B8C77CAmOSBdtEj
         mJAJowLZLcQp7RbovY/eNQVOXeIg3SLByGXEncCSLd8awCtMuLo4saN53cehOiR4BQNh
         MQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3pkKSjP+wJVMcMFvJFoHSHFWn8sH3nk4J1o7IV+VvKA=;
        fh=a6gOU5JGLmVyF+b9YTTjrtv2uNCWFonWm0pxG226JlQ=;
        b=gIKPFhr623zPpJLKR8FOkFWtxy6XB+kFCSWhI8Am/Minaa720G6dD2D8MHM7BafWpI
         4BY1zxtyi1j7+SPtZo0RLmOZmbx+hpLFhQ01RHuTnl7PDzYhCPUgN4rOBHBSVvFRGVM0
         Y/MWGMi7ZQazJ+gNLw5ISHRHua+cw4b4Q4KRqkk2WTZmTWizdrxGckmAfbLCaGlZYKFw
         MUQdP5yWOZVoqebQ0i/HfWp4W/E3VeoKLLpZeU9aGzEBirYCXOzYbYYwSs/tYJVuPPOb
         ZUQdDL4o0QvZDnTMLhhaypkVII4T3LxaPvBpI37A2Bbw5d8NuPBsCI7gnrR4KEkczYix
         VImw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776350281; x=1776955081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pkKSjP+wJVMcMFvJFoHSHFWn8sH3nk4J1o7IV+VvKA=;
        b=kLDejRMxiC1T1MJJrLbcjiQ4YWcUaPS/mONfM8z7jDlIhJn/m9C+dbLvbD4GpywuJ0
         HNUnC4ZO0d2YdoaKM5vSk06O5MA8VWnHBE0NpN6NdEiNMk+T2e/rgIMVUBUavXXcDPpf
         5/0d9JX3YEK1f+0gNM4wk6R1lo+u+extsII+vHOAOSlG/RIZxLbiub/drtZAYuvrJmZI
         yMYx85tpD3nNXCb+axBmayaspvddM3w1dM2JbZayzFBtl1decHG6wrr3vWTLRqcjyA42
         lGkQdbSuFx3EXrj3PQZNGO2huwFDXBFdqNm2hIsIE5Z7n/cTrCZfdgf0XHsCSUT28FNt
         DpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776350281; x=1776955081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3pkKSjP+wJVMcMFvJFoHSHFWn8sH3nk4J1o7IV+VvKA=;
        b=PnaWwrKnNm2YjNPUwkfBkRrFO3bL/8G8e4rwpj2kyS+PgKFOCBGXxMILjimAghVPma
         8mfGv22uOmWn0au6CltBpjXYiStaOylODgW89+HW/IJ2GJOVW/HVBgDEs/SwzBhgai2q
         83uZxanH2GGoQfk8Cz4Kuhspxo0IDb6f7X5Uclbzsuc+tHwX2J0SkU0pNgLmwHOMfIOs
         oUHy3no0MQNN6EjADkgX6gVqUqp7JE/pvDdJHE8mPP/WmDX1T8mWomFRlRjK6jqqOkXk
         Q4Fi8tiog3UvGr/oFIsMgQLjJIuLE54zvFIHJAq8Z3bnD8t8VCEeasxDYoh2oIA9e2US
         KSWg==
X-Forwarded-Encrypted: i=1; AFNElJ/2bVWAkRaXdkwLU/Wdc0RAoAJlEyWqudj5qdeXJRkgxO/rCtkcl68gn9sxC2nyA5jizlDpKBXrJQ==@kvack.org
X-Gm-Message-State: AOJu0YxBo4tFLBMAIyKja8RZoPAMnsxedy7i0BzLj2VbM8/Ptww6H7Bj
	/9sL0iht5qBUqGPXKqOiCL5IqcfC6aS0xpAIQ2v8sA/BDn9uIInyLNZ9ZciW7lA0sKwvmtdak0G
	gJVlbBOqDkqs1gG4kQsUzp3j31jY57ew=
X-Gm-Gg: AeBDieu02NwvvXtWzw5vJDoYjklLZyXuy22snaM/P+wkGjcBCaYcCHtzTeLs93wCm88
	dmA1KWfZQ6pwzuXjNSInlO7cyDNKmN4o17MrgeV3AGHdDGJ4Tjm49FfaOdj9ImoTCmYAect+YHI
	JIqno3pKWwXDCBDX9a77gwVnqIaMG59HVDUmx7DsOmiuBfrTKU+laYcqTX3JVU/8utAOBtQ4tBL
	eaLTXB5LiIL2WYXm0WeGPVLFl0jPm3cq9O+G2xM9JROAAhWcVu4dl71NRLoYErLbv0Xc5qD6opy
	rKIfT2hEy1G3Y7osGOS0B5g/6uqzVoExRflCDz2QcYemQ3gckrc0BEdq+iQmyRW8BwsxN1I6Eoz
	t4Z1vpKLuy57+1A5rY5v511K0Y2l8dSBik8DS
X-Received: by 2002:a05:600c:4443:b0:488:8577:d9cc with SMTP id
 5b1f17b1804b1-488d686be7bmr350526455e9.20.1776350280913; Thu, 16 Apr 2026
 07:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz> <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <ad_cqe51pvr1WaDg@hyeyoo> <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
 <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com> <aeDzovGHlFmPFpNt@hyeyoo>
In-Reply-To: <aeDzovGHlFmPFpNt@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 16 Apr 2026 07:37:49 -0700
X-Gm-Features: AQROBzA8Z07FNydMayiplhklWIK_8QazEzSWh8Qzv8kCNrSoFXdHEvBXGKLZU7Y
Message-ID: <CAADnVQLc_6SfF0h+-W+-sa-Qfvn8a02b6sbELJwpQcG7CFNqAA@mail.gmail.com>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <longman@redhat.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Steven Rostedt <rostedt@goodmis.org>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CD51D40014
X-Rspamd-Server: rspam12
X-Stat-Signature: nek7anpzug1e1zfsufthy3rocdd74rg9
X-Rspam-User: 
X-HE-Tag: 1776350282-760490
X-HE-Meta: U2FsdGVkX18l9d9k0a+lpedYkRXw67bvmelrhmy9d1MQlSxqcaqEcEi0Jwq+dnzyhuJrJ+u6LdpbQvakKAb3hn8PU9AYXgWUZgws/FX2h8iuG2hGZI+8RWs7jrIP0ODnuHq9p5r8FmMsP0b6cu9dHha4z/E4uEPFokTbTqDesHkWObyt0sjhhtqMY96Bm0lsMkQa3hLJSTPaHzrOmrPmJSs+uD4/9r2aZefuLbEXfUFQS+JbxeQoY5NsDumrWayX6ito+whrCDiqNr62+5YsJGuMfZ0+8Utgf17j3NLtwJvqQNuSLLRB0K7dHkGU8C7NwjQ9nIwEDzw74ce2NLIYoiv37qNlw6TxkMvmeq58frNU+hQMIjym61LxM+xhI90CakrPeJ5bJ4p28aRG70wd8KL3uZb577Z7+K1PRn2kQgABzalLDVBBeMD7xKhY+xYwosSX9qtchH9dySqGV1SgPDjbP6jsMl3QIsJcafTJKkWnQoW7C5JmJEELBimyq5Dm5+0WIWgD2Jl3d2WOQXr2tnOpG3Qd999/C7kMjkD+xh2dramXUJLhfAGb3erx26S9+ktuSPo3WGM9YLy3416LfZgL5imB10PLCxEDflBMi3P6PsHFnYvseUVgPdbVvUZI5RSAbhs3eVe9guznJVZyejDOjaFf9ZvuCzfoFP3mcv/XiwJ2tULpmV0HYnnLx2H4QYfbRKcZ1gOqgAHIYQ8jcXUNCEf3j8Qd5QJVSI9c2HHuWHXpLJVCMN7gFEM8q4LVCKWjeduxnO3zBp/ix9bR0tJVJsptCA+BaYp8DFFEHbG0suNPDUdGbW0Z29n++0o8GnhYntF5J5Su5aY7zITvlA5CZ27buBxGfYJXqVg/lfHT5279vew3NzfhEAr/El/zyWc5GlFmpa/e24Hz9TGlIvog3uWI3cCnCcEEZ/S+LA2bpN/YUHC+dSATuo20v//OhV7AFBKvRJB67zgzx/T
 BChjDM/P
 FVn5ugG32uEQszWamb91/XGXKzihZh9vZVZy9zpczckqqim+G7V2Q5+89q//0qMg1WoFcS2kbqE85QnVcP5cX7HS1nRF4MOm1ElBw071ZPlAOopOaMVxncydrHwDQJhOCzwUdjK6iYw9h4qVUF3ecJV3lW80djFcSB3pZgLUxBSvVy5HE54dDclJkN0c97TOjDm3SqYEVC84RkxGP6655HHimrS5EbT4ISGZR67/djRkUaQcFAwtO3djQITeHfe0ruutFXoAaLzt9oZtGypF33pxyugfucPVozcRsXiQKrmSOZYWlAp0DOEmY6h/c+E8kYxT1cwDDq8LD7o8xSkm0DNj5WnPEaj/1AIDMA/qMqVTeiUAJJXLYmiHruI4Ieuz7IqN+4OSb3e35oeRGVKXH0sI2hznfYb9VQyNGJuCwenwi894pvqE8pgaphWAxiiCjn7uLPIPkasloEwHdo713BXNdf2jRT23LG9fVuNfC4HrXXwCZlUOLoU1p0sG35rHLRvUPk1mbHzqXwMb1NkWcldfANvskVArIxvUxZTRypIYC9JjmtBLbMe4VbeLMRHe/NWxAEMwViDtFJPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 7:35=E2=80=AFAM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> On Thu, Apr 16, 2026 at 07:26:36AM -0700, Alexei Starovoitov wrote:
> > On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrote:
> > >> I think we need a special spinlock type that wraps something like th=
is
> > >> and use them when spinlocks can be trylock'd in an unknown context:
> > >> pcp lock, zone lock, per-node partial slab list lock,
> > >> per-node barn lock, etc.
> > >
> > > Soudns like a lot of hassle for a niche config (SMP=3Dn) where nobody=
 would
> > > use e.g. bpf tracing anyway. We already have this in kmalloc_nolock()=
:
> > >
> > >         /*
> > >          * See the comment for the same check in
> > >          * alloc_frozen_pages_nolock_noprof()
> > >          */
> > >         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq(=
)))
> > >                 return NULL;
> > >
> > > It would be trivial to extend this to !SMP. However it wouldn't cover=
 the
> > > kprobe context. Any idea Alexei?
>
> I think Vlastimil meant it'd be trivial to do:
>
> if ((IS_ENABLED(CONFIG_PREEMPT_RT) || !IS_ENABLED(CONFIG_SMP))
>                 && (in_nmi() || in_hardirq()))
>         return NULL;

This one.

> But it doesn't cover the case where kprobe hooks an arbitrary function
> (in the middle of kmalloc() or kfree()) and calls kmalloc_nolock()?
>
> > Yeah. Totally fine with that.
>
> So I'm confused exactly what you're fine with. Did you mean this?
>
> if (!IS_ENABLED(CONFIG_SMP) ||
>                 (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq=
())))
>        return NULL;

Doesn't need to be that drastic.

