Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7462FC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6276B0093; Tue, 29 Sep 2026 10:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656896B0095; Tue, 29 Sep 2026 10:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544826B0096; Tue, 29 Sep 2026 10:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19CC76B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:47:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 784D9C04BB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:47:22 +0000 (UTC)
X-FDA: 85267077924.07.8523644
Received: from mail-ej2-f31.google.com (mail-ej2-f31.google.com [74.125.228.159])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DC974000F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:47:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Tp1e9g06;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.159 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790693240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IP+IFTLJhHPOzVgLZORkj6YpvpTLDjx8asIrhC/8Liw=;
	b=W5R4L2XtUsMClFU/9OB5VUuZp7P2JrcLJQb2tX/Senh0H84lzkupcS17hSwz+BlHSYsURQ
	NTSCH2ZyraCugcCtjl6stVIvpF0+ARQJw9iNk0rFh/4QbGtB3cAKXwnz5TkjGk/YU2oYWZ
	1g6Pj8rKIAiCBoYoSyT9wHaqUHOms4s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Tp1e9g06;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.228.159 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790693240;
	b=M2p+MLiBhBQruOCsrP2z56YdctO8mTVEwZM8deiDvc71oA/MwECLy/7v+zeTTeyvIbVohe
	TG7G6cX9i4zFJXiar5i8pJJtyAPh7vbusJIqfQk6AMfCWRUuzMCa7Sjptrcu5vZ5zczZ3l
	D26DqsBzuHHqOo+2m0IgSDnKRUdAkAg=
Received: by mail-ej2-f31.google.com with SMTP id a640c23a62f3a-c29703cb796so604013766b.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1790693239; x=1791298039; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IP+IFTLJhHPOzVgLZORkj6YpvpTLDjx8asIrhC/8Liw=;
        b=Tp1e9g06+oJVRJtlpYp+Ewy3Q0WDb2MIPaqTagMPOzm7HUqXLYznPS4ddyBiKM7Oh6
         lnf3RAJaOR2xp/A+S0QOxaBAby5DU/QZp8Jp6lM5iWCf6Vr0uoG+jzLpKC/tC4irouLj
         Px4N3MqS9/TZCqO/dIWZ5fsyNWxUbIiJubHe4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790693239; x=1791298039;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IP+IFTLJhHPOzVgLZORkj6YpvpTLDjx8asIrhC/8Liw=;
        b=Y67oa/gqAFR4o57UzqLpPkySNYm0xDq9JHLa02CaSGp5j0Q7KsZCqkzhX/ECWiG0EQ
         soB6c193NjkEzoCZP4+lWJIw3ZXze8aKmDrXH82V5+Aa6ODQEtTjay3QadkLl2rG2Epr
         dvma/n4n1e8iB+dc4qU2vvljx/p7rXLvu9sjH+2ijG/ZbY+IowyxKYZUPq1eUNJZDr+F
         cUnyoMAcMjURG6MHFRJ0pYsvv8lCM/Cwsme7la0G+piJCPq/GiF9EdrziIh3o92jflGZ
         DCpIbQnfjuBrl3Wy+ylkmZ7xRgGAT9bpzDBU0KGm1HW/3HwDrr6JVEVmMn6vANnXoqGo
         7eNg==
X-Forwarded-Encrypted: i=1; AKwUvByhToun3aTXK+rUrH0yR9dGcIouEFjhxy4Z8nzTxc6EI1pKMARvvStPRA+nZsCveNPPF3vq+4s8jg==@kvack.org
X-Gm-Message-State: AFuF++lJfdOI3ik5YTVGJ4cIuhtNHobtGeMcFbpb9mJm1V/TwPD/ik0h
	duqeCMDhBizRcaz2QkLM01KrAaQd3XwSlPoWuLd/CgjB49YFMJbEG4OrQQtvg5FZZete0gkhb2W
	fQFHSl38=
X-Gm-Gg: AYBFou1y2Z2s9vwkr8XOgJgW/UcU20GeZqlxfD6mY28p2fA3qzv8jb7JB2lKRCUBWtE
	Wf38EQN+b2vQSkbdQjIdr0F6L25cbPQNkd9cbslVF3hpm3puEmcm0lGEcehxOaOnHDr2lgeSGUN
	s7SL2TSxePfzpcH897VJ8wxbvPXiQuEwDJt0axoW8/A4U/ImR8jJvCnqyv28IPM6WH9zFYztila
	sdudeL7et3DDJ9bCOlblxOMVMv1E4CK5OuEblTjg2QWag32FWBagxdnhChEr0WipMif/8UouDRU
	6KqpWVD8acQbJa5JnuhrVB1uIGNqIeWEBudinmntTH27Rq55/ZoUcU5EAlnddRzrVLSoD4B3+i9
	fy3nTjL4o9kBZ9XXNVso4bcQ6aFOFSK9d4S/xlAieCCPpCNXCbAeQiGAF/danhihtWpIXTiippN
	THBLcXDKSir4/sxFvqRFTgyfMc+SbTo8PfFsdhGEIQIBtnrXFruVLD4Gtsv0sQZodc6dAre6uvA
	bnAOSNqKamNkurnHzIcxsI7P8vOTnnVn5zt72GAu8Q8WqIUaA==
X-Received: by 2002:a17:907:6d25:b0:c26:1648:a06a with SMTP id a640c23a62f3a-c2ac25125aemr1331868866b.37.1790693238403;
        Tue, 29 Sep 2026 07:47:18 -0700 (PDT)
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com. [74.125.228.171])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2dbd3bca9dsm456512866b.71.2026.09.29.07.47.17
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 07:47:17 -0700 (PDT)
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af43c5b0cso553575266b.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:47:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwYZcmx0y824K48OdIW6Fj0zhlqPl5NU5Op0x7Vx6BXqOA7tEnLAI1azBGOzTZ8ddeHNaNLzeF9Dg==@kvack.org
X-Received: by 2002:a17:907:c491:b0:c26:1648:a06f with SMTP id
 a640c23a62f3a-c2ac253fd57mr1427153166b.42.1790693237251; Tue, 29 Sep 2026
 07:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260927155134.4740-1-mathieu.desnoyers@efficios.com> <20260927155134.4740-3-mathieu.desnoyers@efficios.com>
In-Reply-To: <20260927155134.4740-3-mathieu.desnoyers@efficios.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Sep 2026 07:47:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgQyCdrWH3ZuSajOxZqiups6jYbPtqY8JR8OeS7yi49Mg@mail.gmail.com>
X-Gm-Features: AclHuK-hIyKMMCYq0m6RbVGEdDaE41y87jUOezwgP_JOLXBYBmnHdH3WXkY-n-A
Message-ID: <CAHk-=wgQyCdrWH3ZuSajOxZqiups6jYbPtqY8JR8OeS7yi49Mg@mail.gmail.com>
Subject: Re: [PATCH hazptr 2/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>, 
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>, 
	Waiman Long <longman@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com, 
	Mateusz Guzik <mjguzik@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org, linux-mm@kvack.org, 
	lkmm@lists.linux.dev, Nikita Popov <github@npopov.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4DC974000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bs5u3mrdnn7z1j1445pz56ecdz94ng7s
X-HE-Tag: 1790693240-142211
X-HE-Meta: U2FsdGVkX18vSr0bQUPEfj5AyjTcvAK8F77wF785gkmG9uXeUMTUCZ4+C1nF8HqryU4rSBDtm7L1uxryZzfoQC7hXGH7a6Auj2fX86wLnsLoeLO8r2GEYz37epszmPIqJqCMOaOBct3aiUjCteSh34iwWe5onyIBdIBRIkXtkspt3z5nFWZ2AiabjTCSXyN5p1xkBGZKdSrWVzSo6H+GeyUAMN0GJvLw3q3FqE/Q4LdHZYl2JEwwncl+bmwPzKf8pioT2Vm2UAV28t/k66iH7ZKZhIOct9AoF31j6SMAtJf+++EqH0ODRHmFKAh5yU9J29s9xZ69S3s6v92RVn8lJ2gue7TlFa87ZS79lVVodp3HzI+CRWfx8/X9VEwX1rJ2n6DMvrg2dtY7oYx2aO+18dwolScNLE4xe6idsEJSuhQML5D7i+3QpCZNEmWFUTPbyFZwumbWpaGIHDPpp0CdFVK6F/KPxm5+thU3lDIPt3qaM/jpeHTg1+2Pq3q3iDvWMc/CWHcIKF7nRoBUbaupNkCAEXK1kImKm3aOgOIjVys6oaF12HTSFTI4I2XB6EnIzqewzXj/PT58KDpnGbdy3+Vq8gtBmG6r6w+Y6vd3kN5wx29omeJnJirpspLrGL27T65BAtdxa0JS6Z02JFu18Vm1cUJHRTUeWMluu0IFKUYmjaDq1h9OdcGW4pO4v+iv/JX7Cbg7Yf6EXAm3gkqzaP9pUPW5Fm2bhuaPmVoCAVp1+2+UQkIX6MmK+Uxxgu12hnJJylZmeNBbpzxuu0jImt6pcOXIELJ0lKowTNxNke9655+9iXj74tcOssdlQo3YXynWV6IXsqOud/tCgv8+Tqrw4f+Kn3IYdqmHHZUETHdiBZk5qdE1WJlIFuUbeljoNOTrT0LMVsD99EPLyvsZ1ev2t31ddhlQSVr3ca6DTj+c9UrwTRoDcBfF1IAQJUPTXs0z/eX2XvHabF+iXnd
 /IGXPtsn
 cVgNiCcv5aFsuOJ+VlRiaMBf4ZHWfDotd4uLv8XErSYcK1jAE0m0QNPG7ZE+oFqqIeSHWH+xEAr6ZmhjgXYn0dscNUcH2SSA0oszT43RdTMke/7jjIybt8YnSeTAYhLr5xwiOCGmfT3DODQzlo2PfIgytT6b2l5jdYjm5PHkLL4HuEkJmVhNHur31uClrovIfArLBXc0Be5Aourei7UbB89f80EjPjEbWlG8mEQU0o6imL4y/qnZZ0NJXJdgH1S9dEcNleWtXAhrumH+TtNbEDKIIZbf7vB7SWYl2WImevkfTG+gPoaUeFtu7e++m2q1wHU5/dKoxc/mgEa45b82YCQWx0E6yn5i9g8Eklu/Q+EKfSMU86HyTNa/vbAHA7WMD/3+MLN8As8W7ZQAx8RcXPqcFCYY56ayUm9apELqNCCBMam2buizBrZttw1cQJAsZR0KD8RZO5SIptt2YoTh0ckaoLBBjBHYybsYxg2bkLgLLj8b4et2Z5HqvomuSWMAB2G/wR2DgyZKH2TZAjqa8blQpLi4isD0/ljKZH/j+xpaM5AcCtUc82251ZJ8+nN4/++zvSs+YiAz/5qXFPrqM98zkaELj9nsgxtn8DrgDaN2oRYmtYFtrgUnT5e8FxDvrHvfejaAmrV4XEQv9RphHW2+7jXlbLt8xwzYIZHX7ieLSmeDGGysJkPXqpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sept 2026 at 08:51, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> +static __always_inline
> +int ptr_eq(const volatile void *a, const volatile void *b)
> +{
> +       OPTIMIZER_HIDE_VAR(a);
> +       OPTIMIZER_HIDE_VAR(b);
> +       return a == b;
> +}

I had to think about why I hate this so much.

It's probably entirely senseless, but this just rubs me the wrong way.
Those OPTIMIZER_HIDE_VAR() statements are hiding the wrong thing. They
are telling the compiler to treat valid information (the pointers) as
if they had changed, so then the compiler will have to just reload
those pointers when they are used later (and "used later" is part of
the whole *point* of this, after all).

But it was never the pointer values that needed hiding from the
compiler. It's always just the comparison. And while the "optimal"
thing would be to just do something like

  static __always_inline bool ptr_eq(const volatile void *a, const
volatile void *b)
  {
        bool ret;
        asm("cmpq %0,%1":"=@ccz" (ret):"r" (a),"r"(b))
        return ret;
  }

that is an architecture-specific thing - and then have that
OPTIMIZER_HIDE_VAR() available as a fallback.

I don't know if it's really worth it, but I really do despise that
"hide the wrong values" thing that generates two new values just to
compare them and throw them away, and adds register pressure for no
good reason.

               Linus

