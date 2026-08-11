Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD82C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 22:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613616B0088; Tue, 11 Aug 2026 18:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4AB6B008A; Tue, 11 Aug 2026 18:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2E76B0092; Tue, 11 Aug 2026 18:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 144316B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:58:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98C30A027C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:58:08 +0000 (UTC)
X-FDA: 85090503456.21.6CA76E2
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id E110540002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:58:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eYipRNRy;
	spf=pass (imf12.hostedemail.com: domain of 3_ah7agYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3_ah7agYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786489086;
	b=oSuYLYV+i5XOW/mzpUkxtlOOgaAERXIff48KVmKG50NT2CgZKVX81BJhd/5ongYXrIrDuh
	392GxpSLUE22u+TZmMfjwjnfRaVwsQJpFsW+tb9nfW6gXv4Ux4RRfVqNLpNpCzG4ZSiYFI
	8SILXwSTK2suqL5SaRuCTRIWUymvfZQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eYipRNRy;
	spf=pass (imf12.hostedemail.com: domain of 3_ah7agYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3_ah7agYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786489086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEzv9TziceYkcHbMHh7lHIVizJF1nhviTwKFOEAR9lQ=;
	b=GDwOWGrPDhHiSqtsVjwLrwKp7dTXgEJDfVGMgqnx/jTvPyAFY9F5vazRVcJdKqcVGacGB2
	Z+jDrTLThZ24LKArN6ZbTHJrEljj7zdhBs3oHr6crAKsPpMirRVPWt+5mUq+TQAVpOWh8Z
	Ktohgo/wPdJ4jTNmfqamo1DkBbRuxaM=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e375d9736so177299b3a.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786489085; x=1787093885; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cEzv9TziceYkcHbMHh7lHIVizJF1nhviTwKFOEAR9lQ=;
        b=eYipRNRyhuKA5C4gUj18Ky4AA2LUoK2r40ZQPZFYA7xl054nhZFumSWu7djK6Mt12t
         ELFHGKgIiWm6TTF6I6lkNagJ7091f0vGgvFbczZoDAV0R5E3R1Bm5p1/8gphwTRShLn5
         jmMbpDnDCG20V8dYicotO+RlG+Wdnh/7TGReDB3HSCxUdz1e91Xn3GK883ziZ9rUnb7Q
         2T3+7in76hL5Uwo4mgu52jtMALf4y/XkGkvnYrqVo5ynC9rEIFPIwn4JtJyJnVH/UWos
         n+in6NUyPDGd4/ZZ2WykQUbrz84R4XwZAk4HbJDMnh4Qtno0w9pP5R+v6R3Q/jVCANAM
         ltQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786489085; x=1787093885;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEzv9TziceYkcHbMHh7lHIVizJF1nhviTwKFOEAR9lQ=;
        b=I9C6LQNpoyEt2CCh1KhwFwoiRH6D67s6dvtOMYWHPVI3eCJzQsSC8bIbUSTsS91f1u
         eG4dUhlkoLefgH2ra2VSRZ8wyWl5Kzo6FnIz7yNI5YhlFF9a2bPRO6VnGdIgN17W1JJK
         DXo9lPOqxqKmptN2D2xB7HGqAvZYM6sahjPFhnZbn4hU/PfABia0pnKRI31zKveuNC4q
         VI8oEyG/Ew0i4/XEubp7fkExBdD4WAdYERrqGqafEZ0cVDRH5rTGKqxvaHY3YKiPblZ/
         jsLy5A2I7fOtMu8HTkmUCaoZ5SrWEoYtTm9G513E4/vMZGwsyLttPLttwPZWf8hGB4IR
         GXfA==
X-Forwarded-Encrypted: i=1; AHgh+RqK8LrYNoNb2NxlTYwsPlNl6704lKuGOovdAcHDq+MDa70epcL93V1bZjvpgreifNc2YsBzs6pIRA==@kvack.org
X-Gm-Message-State: AOJu0YwcNSwz3aq6DMTZpyW+ny53g+ICoZ80ZQE+vhzwoNvIWcG5Bv6x
	rji7C9t+Ta6p+Q82hEgmyDzHutsb/C3ASrmhv4shZ89w6/xB9MrpYkluqtyjG/MvK6IXCK1yCB0
	FVPM0FA==
X-Received: from pfbhc13.prod.google.com ([2002:a05:6a00:650d:b0:84f:4ff1:f767])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:985:b0:847:8be6:2177
 with SMTP id d2e1a72fcca58-84fb54f6116mr651351b3a.34.1786489085251; Tue, 11
 Aug 2026 15:58:05 -0700 (PDT)
Date: Tue, 11 Aug 2026 15:58:04 -0700
In-Reply-To: <27f2326dc66d6341174c0e510aa518a1297b66ae.camel@infradead.org>
Mime-Version: 1.0
References: <20260811162423.GL544626@ziepe.ca> <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
 <20260811172627.GN544626@ziepe.ca> <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
 <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com> <27f2326dc66d6341174c0e510aa518a1297b66ae.camel@infradead.org>
Message-ID: <anuo_OxfvJbQnn71@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, akpm@linux-foundation.org, 
	david@kernel.org, mhocko@suse.com, rostedt@goodmis.org, bigeasy@linutronix.de, 
	simona.vetter@ffwll.ch, jglisse@redhat.com, christian.koenig@amd.com, 
	paulmck@kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E110540002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8c43jorxfgi33n5mbf5zcfcbs3sqrn66
X-HE-Tag: 1786489086-564248
X-HE-Meta: U2FsdGVkX18O3ImADNUumfpRl/rwP/nT/3Wr4b5kE9Mn4JZa69l64GdR2nwBAkRomw08u4+pnMl8Rtoybs24XPOeIs1yhULj4FqHCPVqLK3qu90IKS10MPf46Du9oTqYLHFG2tvQOi30Rn1P3QP+zdghy2jfPMf978X1OGHxHFzrZFs4KPATFjAfYRICU5BE23mgi6bqlRXwpaxpDRLk4s/nACipYLQiX6w9JYZ93xRk+BLUAxg9b/w5C6zg1Bcmrid2N91KgJzeSRpVgPGFWXNzO1KQgCOhqr8qAiw6x4UyWYQZMuqtL/fz3ce/l78ne/qMsOX6VAqvKpoUYWNlgC3opmzoU1TkFce/b046MG//D8PzNPwa2ljB0h3sLVig4fJ901L46tABDUdJ69usQqQyjJXsk6RWd4a+1Wk8/OD9tC9dZdopdfBBWGf39n+FIaRKN6++qP67WvPofiFa9fFuRLNm41VSIE8WR6am3uodJT1tvrj+MioKoRJx+ZVUFhBI2eFJbiFeXtM4OjtiG3bf0pu3UIrQv/jr+76L2QiFpnJF/kMfFIfSeWE5jyHZbWzuCeX6VPNRL+JsW8Mr8y8/xwwiH7IOFQ6GwuvMag3l0Z4kMa7c1sF0oaH5CPNOdSlHdb+HXxhuyGLiMNgMJsUdsFqixeUrV4y2W/HNBmJyB4YpVTMnbS0m3zrsfXCeW98tJ/Mq95Rj6NL6VD/O3Yp0JsAwqeJKNsB0gyiUYz5JnPJYYbD702wbMdaoSdFX1NWczV5ukYkd/oY3dHO5OShzkkc69ZiLAtJ1k2AMaj2BESi87Vu6MqqYTWiy5mdkXfmlI/ev9bmdYokJRkm7B4grSiFQ9jMqw8b/ErJzVI9a191ZQO8V+oz3PY8EhOJvAuH5wwZpqYoKUBVDLDOfVDuv0MzkMgzHYgz7mo1bP4En9Okx5iWW6QkIIQnrIfVcuGiC9jO8n9Lgjp3UNH8
 Z4qGpun+
 O3uA89MwM9drMsfm3HUB2i76rWAEwHRpe2DhFtiNcgCnbKsnUi74dr7tVOfPzoUrIT0s35swF5qFJDTWLiKfx9y28s1mdt5IH/iO6QdYND+o4ZcdRN79TAe2pcEqOqkvPpOZeQsGLwYwTQZNgxIZ1LzKBPegaOtQn5BpHIJCT5/sIKhIyAQZQr4WJHcA5V92NkzRS+DWWKU0MpgzWL+HjR5ldOdoK9JVZPqG03t0umyiVZxEy8A2cQT6f+xiT/RDoVKGHZ1ZJ6jBDcmp8RnXA+IkZrGcjGREqNhMrOMvG3GPxDNyJMfphbzOrpUpO93kZU4KCJlGMzjZH1rzRR+P8TupbaPFYJDHHU9CaMwYuK2o6Dvw+T7ngvO50i9HW5n5Oyjytodo1XWZDiKHJRbYvfQR5TYmiSqR1Bl87FgiDp6vQJw2nvmlgnSUaq6hzpCXmWuYkt/R1tIUdow9m52YU4L2MMqwnNIywHRAQozeqXOLT/ACJs0BuW9dWT1xJHgL2wgMpohTblnpSz/Woh+bfZfB+Cq+JHVCnlSmPqVve0tMDRIcUNjzINMDK0+yuXzJ0nAiY8xK3xGR9SW3lX4qIPqIQCNLDFeIEUmiPyfhFwGq/r4F+IzziXk95tfSLPCFG2c6ew8DRaF1B8Rh1Q0JRSqzXRyWWBGPD0wC+niUQpQyh5oDzN2S/t24OSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026, David Woodhouse wrote:
> On Tue, 2026-08-11 at 22:21 +0200, Paolo Bonzini wrote:
> >=20
> > for_each_present_cpu(cpu)
> > =C2=A0=C2=A0=C2=A0 if (per_cpu(kvm_gpc_reader, cpu) =3D=3D gpc)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask_set_cpu(cpu, gpc_rea=
ders);
> > __kvm_kick_many_cpus(cpus, wait);
>=20
>=20
> I'm literally sitting here watching you reinvent what SRCU already does.

The problem, for me at least, is that SRCU does this and a _lot_ more.

> Which, again, is *fine* given the behaviour of *these* read-side sections=
.

Well, yeah.  Why use a nailgun to put a nail into the wall to hang a pictur=
e
frame? (other than the indisputable fact that power tools are fun).  SRCU i=
s
fantastic infrastructure, but I genuinely think it's not the right fit here=
,
especially since we'll likely need a different solution for in-guest reader=
s
anyways.

> I get it. RCU is a versatile tool, and in *some* cases the *Sleepable*
> variant of RCU gets used in ways which would cause grace period latencies
> which are thoroughly unacceptable in an MMU notifier callback.
>=20
> But in the specific case of a dedicated kvm->gpc_srcu whose only
> readers are tiny snippets of code that until today were always run with
> rwlock_irqsave? That is *not* Jason's worst-case bugbear. It's fine.

I agree it's more than likely fine for your use case, I'm not convinced it'=
ll be
fine for use cases that heavily overcommit memory, or do NUMA balancing, or=
 (close
your eyes) enable KSM.

E.g. it doesn't take all that much for even a single expedited sync to gene=
rate
a delay of 20ms.
https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com

