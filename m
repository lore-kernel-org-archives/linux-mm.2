Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC329CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E728E000B; Thu, 25 Sep 2025 13:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0F88E0001; Thu, 25 Sep 2025 13:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FE48E0002; Thu, 25 Sep 2025 13:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E88418E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:51:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5942B992F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:51:24 +0000 (UTC)
X-FDA: 83928514488.25.52EF8F2
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD4F140006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:51:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gIwt32te;
	spf=pass (imf11.hostedemail.com: domain of 3GIHVaAgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3GIHVaAgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758822682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpqAAvRRl8ijYNcMuZKa7G4PlR+tOnu+IYSl1u8opK4=;
	b=2iU4KDuXdqpHcfQMs91O0eiOAjLrZJSTTPKD81AC2fLnDpAC/UsMh9DYVGlyaxsx4cWPeE
	z/BMXL7GpVrU5I/HJDYUrfiYZ42F147Zyi1PcSQC4e36tdFCVp1ozc8hbZeP1vOkya6KE2
	xe56+DcLNFEf+9QDFq3Fh3AZfHw/K2U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gIwt32te;
	spf=pass (imf11.hostedemail.com: domain of 3GIHVaAgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3GIHVaAgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758822682; a=rsa-sha256;
	cv=none;
	b=6Qx3bOZXF8iCES/btiq0Zkn+6MuDV7p9Qpv6ik/1Io1vdbQ2XVFMuxsTw0jYl8rkAhoUMo
	BU4fje114yWHfdw1Nm6VEeFGAHiu2NUgY221i2nw0HlprHdXuhfxO8H03sSpm97u31/udG
	bQameASCFlVNkfAa5i/ZcMX94HUqSlw=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-62fce1f3fa8so1058391a12.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758822681; x=1759427481; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jpqAAvRRl8ijYNcMuZKa7G4PlR+tOnu+IYSl1u8opK4=;
        b=gIwt32te30NbvmrMeYbEnhiMrNY+yd/mSozi0o5szrn0K9ej5i7UH1GJpxZOwsvhUA
         zEQy3M4yGEa1c75DByROTGT18ItDxxKFr6M824nl8yLUnyhi/7kkHQWKE/oAnDyFECxF
         A0m63cudT9/Xef4tbPH8s6yUrHoqLr0g5/YqhDZtA4C/tZMYOuVtWBoQKdh8QT8i4lAF
         oFasxNlMThB+JKgAYIaH7cjPC8Fi191n32vlgfhdUEwRBeojoi61suDNDsNW5ncdWvp9
         O/BLKwQQzmKaQQpyE2rE2PO4eSMExkf22N1kEtCHi+wS4OeEK/iZN5EKYnnnmRSQWZqe
         /fLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758822681; x=1759427481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jpqAAvRRl8ijYNcMuZKa7G4PlR+tOnu+IYSl1u8opK4=;
        b=f5D2A0THWYyztzMnaPmjOepIqX4e/lEHfKnkoPCMKS8Ni/Gi7w0n+f+TVG/NmTpeOS
         jzWWh8KoUtO+DSc4K8ODvsPime254dGOO8IJLmlyVzOsiM2ewO4INi+Is+A9hRgtW1Ac
         HVSyWl3gMfHNOYfyLCnL/h/aDHc1tFh5E+mxdqlh4uJrGUhIj3nQ21hX+lHWNymW9yyO
         ae7dz7VdrRLXv6DW+ij0K2dmKfRUOSiikYrdBBO+8TlxXTjOzCxTc2MzUhfrLFenHlQg
         4bKJQMCgOuCFcaPfzTJ61V17ceRFrAYhmuSyp/lwWghrK8i2ga0sbXbtH1t1SCiPto3r
         dYgw==
X-Forwarded-Encrypted: i=1; AJvYcCW+ipgcnYWZVXYUqNMNixVJzxN1kPjQnCxHQvOuLmehzmkafnPGIyjmEsx7rDn0XFPM+Xsp1nUMhQ==@kvack.org
X-Gm-Message-State: AOJu0YzNHOI/T1tC63MnbB2BMabitK4uBgIhdW4NeQM/LhLlzPkag6Pa
	rCNURjnYZGR3CuPZfwIurOoU0qEjcxX+bJlgnE3t+WlYEISfaSVgcRN4f2E5cxXQuYn49auk7xq
	pf4QQXddhwH79bQ==
X-Google-Smtp-Source: AGHT+IEiFUjjNFB9hUrXlVQKck8BwlAQbc3hiE92OqPlhCkF8YWxZQAwFhYvcC8kcCf0XKrNjtXumE3uyphhJw==
X-Received: from edsr23.prod.google.com ([2002:aa7:da17:0:b0:634:4c0d:974a])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:543:b0:62f:4b68:bfae with SMTP id 4fb4d7f45d1cf-6349fa8fcf7mr2697793a12.31.1758822680886;
 Thu, 25 Sep 2025 10:51:20 -0700 (PDT)
Date: Thu, 25 Sep 2025 17:51:19 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: aerc 0.20.1
Message-ID: <DD22LSMJG70E.2N2B3FF1KKPUE@google.com>
Subject: Re: [PATCH 00/21] mm: ASI direct map management
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BD4F140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sgnpssnnzypy1fsm9imwyhwj3fokgyto
X-HE-Tag: 1758822682-517205
X-HE-Meta: U2FsdGVkX19RrqJ8DYc1/eJsAk6swR2Kxx/KwK3FXjAUd13RzCCrAJCwD4EJHXOaadnjTZ8ZytuybWgMaypk4cB4VPRFfqxD3ZOGapJJaLecLS1bqFbsegUnjhE/z2sPQflRFNBHVIVbqrTf1oBOVAapIL4FHumIfKDbSNN2GyCSUhYB78H0WNS2PaMkpg/b5oQEJnPCr937auBRRWOvIHE7e9NWtdBbo7cIKCqkNU/+C4wL1d/DqMBLUwIlW9+c5GLGdlb6GEXr3xLJFoMRO+YiCNfIg5TTemcdTynB8+wxhBwS4fvjHBbj0MWW5m8anNKeAhqk1ywtZ36VnM2MHVa0tGkyMQFeriMeH1hAGAPeCHeM9PsfTjNJs0nrFu7EF6O6ruvLpH8Zp/bCM8FhqU6GBH4WJFBNOVtby/WmJJaaQ5Jr+aTGhGYnNHSvBJo1U4B4sxXoMWoDc3fQFp59qu6+dvp93k9bbOfVw4WCNQH0LQCfV//tTY7mPiUUqaOmr6BC75v0x6LH+bRLgtSsj0KcsuxaH4QamfrchqsoHuCoNAoMTUpHXvqWZjMjMFekFfBt0XAezgfEze7hCn887hlT4ZcRWTizflvbtGBKDXPCthm0fvzVa99Aq4MZZaweYwpAlEQFA1/Kw2g6eOb+6T+RP7/AZctV7sDvlKltU/wE6dOQO2LiZJOGk/vCnq0Y7jT7ijjFxo3nF69BFgPxoRaReSvBRhO7kbDd9c7fu45Z6a/2p+EgjxNX1gOq4q7CbdpnL6iaSKT9+IEjVnS6IjbTRhnM9u8jp4jyBqFeNmmgCBqPzNDisiNkse9Wdmwmq03nkhEL3OlCOy+/jbVcAkN0TO0RgrbZUszrk9Fx1btGqjLWkC70iDop/Q+5P77siIzXim2w3VSOkZwioeQR72LLYzYuMx5klV5ygxGulf+SV4e0pwIybhMYL+QdEuQMTlHsfhQS4+OXn6PFXg+
 U4AY6XSM
 HDzfCiGJTS3cOU0rZjA+GiNhlp3xkIRyjQGdF9p+AcgmAVA1yH4jrOzH77wK4eSjWYQiD50o0awA1xG3YYeM3+r6Qodovm69KdQ6/gSGt0k/YgIzFzrbrg8ovsDpaVNKtBf4Fm4RRdqolecUpQEr71lpX6s8JhrSdLhK2WcKU5qw07u1G1LhFoxqD3ucrHe7qGj0EnY92PVi58wudfnnivvlqkk/fUXx9UBtC00S5A8mgubE0w0TobkdiV9iTDB5x4YxfB6cjxn3r2qM7zwzfOjiiJ52GKn/d2jYwjVcZ7M8GgK5KLzl0YEIk85NeZd4P5nlL+L7/uR43O5uF91ayiNq9ih9RU8evMbZXmndG5rnigGY07mxSt3MzHKAgZ5wS6MJGlcF51guywv1crFLfyf8CJByKUm9ugLFze4I2fkjGLvNwLnNecirsEQmgLXAmhvNRr5PoMR/6in2tmLSv1Tb3yJbNIbylA7hBIYBYvxOzd6a8/5tcyW4w1NQ1B1Zll2MX2V8pE9QM7nGWXxXULxCTdidzknSovyAvrVoXCf6C+pdK8Mn5wXegLqV10ZVjaWKakF8usnuYCrQaLsnCe3U6+oULy5ItE4OdbJ19BxLJq4r01NziMVKMCjjdaDkNe/0x2bfbfCXdYQ/MQv8IkFbNpBZK5ZWYrfccqNnJ3yrH2TaKMOFmdzDz/D3kpOgexBXWGw5XOh0+hBdyrhyu3gNU+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 24, 2025 at 2:59 PM UTC, Brendan Jackman wrote:

> base-commit: bf2602a3cb2381fb1a04bf1c39a290518d2538d1

I forgot to mention that this is based on linux-next from 2025-09-22. I
have pushed this series here:

https://github.com/bjackman/linux/tree/asi/direct-map-v1

And I'll be keeping this branch up-to-date between [PATCH] revisions as
I respond to feedback (I've already pushed fixes for the build failures
identified by the bot):

https://github.com/bjackman/linux/tree/asi/direct-map

Also, someone pointed out that this post doesn't explain what ASI
actually is. This information is all online if you chase my references,
but so people don't have to do that, I will add something to
Documentation/ for v2. 

For the benefit of anyone reading this version who isn't already
familiar with ASI, I'm pasting my draft below. Let me know if I can
clarify anything here.

Cheers,
Brendan

---

=============================
Address Space Isolation (ASI)
=============================

.. Warning::
   ASI is incomplete. It is available to enable for testing but doesn't offer
   security guarantees. See the "Status" section for details.

Introduction
============

ASI is a mechanism to mitigate a broad class of CPU vulnerabilities. While the
precise scope of these vulnerabilities is complex, ASI, when appropriately
configured, mitigates most well-known CPU exploits.

This class of vulnerabilities could be mitigated by the following *blanket
mitigation*:

1. Remove all potentially secret data from the attacker's address space (i.e.
   enable PTI).

2. Disable SMT.

3. Whenever transitioning from an untrusted domain (i.e. a userspace processe or
   a KVM guest) into a potential victim domain (in this case, the kernel), clear
   all state from the branch predictor.

4. Whenever transitionin from the victim domain into an untrusted domain, clear
   all microarchitectural state that might be exploited to leak data from a
   sidechannel (e.g. L1D$, load and store buffers, etc).

The performance overhead of this mitigation is unacceptable for most use-cases. In the
abstract, ASI works by doing these things, but only *selectively*.

What ASI does
=============

Memory is divided into *sensitive* and *nonsensitive* memory. Sensitive memory
refers to memory that might contain data the kernel is obliged to protect from
an attacker. Specifically, this includes any memory that might contain user data
or could be indirectly used to steal user data (such as keys). All other memory
is nonsensitive.

A new address space, called the *restricted address space*, is introduced, where
sensitive memory is not mapped. The "normal" address space where everything is
mapped (equivalent to the address space used by the kernel when ASI is disabled)
is called the *unrestricted address space*. When the CPU enters the
does so in the restricted address space (no sensitive memory mapped).

If the kernel accesses sensitive memory, it triggers a page fault. In this page
fault handler, the kernel transitions from the restricted to the unrestricted
address space. At this point, a security boundary is crossed: just before the
transition, the kernel flushes branch predictor state as it would in point
3 of the blanket mitigation above. Furthermore, SMT is disabled (the sibling
hyperthread is paused).

.. Note::
  Because the restricted -> unrestricted transition is triggered by a page
  fault, it is totally automatic and transparent to the rest of the kernel.
  Kernel code is not generally aware of memory sensitivity.

Before returning to the untrusted domain, the kernel transitions back to the
restricted address space. Immediately afterwards, it flushes any potential
side-channels, like in step 4 of the blanket mitigation above. At this point SMT
is also re-enabled.

Why it works
============

In terms of security, this is equivalent to the blanket mitigation. However,
instead of doing these expensive things on every transition into and out of the
kernel, ASI does them only on transitions between its address spaces. Most
entries to the kernel do not require access to any sensitive data. This means
that a roundtrip can be performed without doing any of the flushes mentioned
above.

This selectivity means that much more aggressive mitigation techniques are
available for a dramatically reduced performance cost. In turn, these more
aggressive techniques tend to be more generic. For example, instead of needing
to develop new microarchitecture-specific techniques to efficiently eliminate
attacker "mistraining", ASI makes it viable to just use generic flush operations
like IBPB.

Status
======

ASI is currently still in active development. None of the features described
above actually work yet.

Prototypes only exist for ASI on x86 and in its initial development it will
remain x86-specific. This is not fundamental to its design, it could eventually
be extended for other architectures too as needed.

Resources
=========

* Presentation at LSF/MM/BPF 2024, introducing ASI: https://www.youtube.com/watch?v=DxaN6X_fdlI

* RFCs on LKML:
  * `Junaid Shahid, 2022 <https://lore.kernel.org/all/20220223052223.1202152-1-junaids@google.com/>`__
  * `Brendan Jackman, 2025 <https://lore.kernel.org/linux-mm/20250110-asi-rfc-v2-v2-0-8419288bc805@google.com>`__


