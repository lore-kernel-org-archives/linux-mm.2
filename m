Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F9DC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D896B00DD; Mon, 17 Aug 2026 10:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ECE6B00E0; Mon, 17 Aug 2026 10:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66D86B00E1; Mon, 17 Aug 2026 10:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C350A6B00DD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:37:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4228A1207A7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:37:34 +0000 (UTC)
X-FDA: 85111014828.16.A74A590
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8588B18000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:37:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vmb+iGgN;
	spf=pass (imf16.hostedemail.com: domain of 3qxyDagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3qxyDagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786977452;
	b=i1x8l4x6P7DL7hC8r7BSfZC8V9SWKpXf3sJg5f4WKhGjay31K5k3hcQVgmfd0i/8teGibH
	vNdCsxWpTIdtqATr7IybC1iWmgKKV6wEGgi8P43lpFi3Z8x1HRLpxtR/zK2ykVMrnene9m
	SRt1KdMUZ8L02Ek8vF+TDN9o0mloX9A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vmb+iGgN;
	spf=pass (imf16.hostedemail.com: domain of 3qxyDagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3qxyDagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786977452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbnAp7y/AgCt9+7CBSjoILDuat4y2Kbyd9OVnJGDiZs=;
	b=JS07ouGAjc+EU5Ju+nDYt0zMxooEphI4AWy85bwlpT67hb6apBBX8a18QH9kKM5S1ivV06
	RNH0y9Anic6Hs8F0LWSAKcAkCSgHLzczxBNLCKMzr76TW5mUJpxhHNIf9fF534uJY5Z+RH
	ekuXwG+ISPF5FZD/iD2FXyZ9WhqMoFU=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cacf17c7e0so52273355ad.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786977451; x=1787582251; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xbnAp7y/AgCt9+7CBSjoILDuat4y2Kbyd9OVnJGDiZs=;
        b=Vmb+iGgNE0GOsDJ7ZD0ECmtWQTxuH89EuAF2q6RQZlXGPSHpnKOgdWoyuFlyg1hTY9
         mcheVwHnRKNJQT3zZf74juWexaD/gu+ZWPAgRe/Nevi1eSxsOJZYOaqU6SiiTesr6AYV
         zCUj7eMdT6NR8Ueu9m1ScypY/fgHV0GTMBE5AEUxA+5FAyi+k9cRkzIb2jZGg4N2WUtz
         MgLnCq154Wv4pSJfDnelugm5EFZXtWM3YFCnaim2ms4F4RQ4YeU+FaFkz1h2fzRIphvy
         z1aTC5h61xWLIPwvpjp4Hjvl0obJqMdy4VcUHwHbdaOBXFvMxsbvNdhiOV1Qtaf/Hy4M
         IaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786977451; x=1787582251;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xbnAp7y/AgCt9+7CBSjoILDuat4y2Kbyd9OVnJGDiZs=;
        b=WzkN7tkRETds4fxDoWuZ0sCrl6v2Ws6cR/D3W72DmbgVv04M26l2mGkOrTQzC6nF2j
         lAxkY1+tP5LiSVpMfvwuiaFesLMW2doiQ+vbaN2CNNVPSxo1rAQTj0aTIgXSrp5iYZhu
         F+8DOAFeV/oEtBL7RUOei6mvJIZTe2wQS3pMQhdpPOTZjoUNygY3Q73Xsky4PSJj6AeU
         30c9BwYmoMLnSgsSERiLQjhp0zioqknQeMZSQ2vZ2Bj10VWeIM+Bsc7V6OtuGmEwBy9j
         5MCRuvEBZb8+tizxA1zXmNaAfXhXRqsK+mqCwNJ/xkgTS5bY8P3nv8NrijrAw+6oWoL3
         J7kw==
X-Forwarded-Encrypted: i=1; AHgh+RoZzD321D+xQTNW+p3FF0rJlBkqFlRXOh63MteoNez5AQ5Im453HeXF80DdZrbCFJ4tONDK5yP6SA==@kvack.org
X-Gm-Message-State: AOJu0YwRrUpy7zd+99DNXMl7CXVSXH5glSrFyzCAzxrPYHq7PUZLvRCZ
	1Mek1JnjJJcsz3j8sWPYOw+l2NOm2LPWa3whPqmpVEs1wC/qmKrLtycrRkpNzhcJpb6cUJ9gpdw
	MptoLRQ==
X-Received: from plbmo3.prod.google.com ([2002:a17:903:a83:b0:2c7:702a:36a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b0b:b0:2cf:9347:f445
 with SMTP id d9443c01a7336-2d3b0c7ae46mr283430775ad.10.1786977451095; Mon, 17
 Aug 2026 07:37:31 -0700 (PDT)
Date: Mon, 17 Aug 2026 07:37:30 -0700
In-Reply-To: <2vxzqzjz1x5f.fsf@kernel.org>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com>
 <2vxzik5f311e.fsf@kernel.org> <anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
Message-ID: <aoMcqp0gr06YXAPU@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 8588B18000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tdbazjkrese4mpjcto8g5hwz9ywmyhch
X-HE-Tag: 1786977452-240628
X-HE-Meta: U2FsdGVkX19HJ/+ZfEPddQjjNtI7FObx4vgGZh/9JLGW+ga2JsPAXOLTMPielER1Gdh4f3Qg29TQzZk1UH4hFkJNwfRw0Vpk1+MAa0L5DBvjmd9ygXpa86BzR72f4IYbWiF/46MXtKKm2FstCOPfMi36PEW1xSuO2EqAylwtBikWN/9CM2aC2ag9ZNA0IhLXImHqvlU2cDSyHPXMMKcvANixWexqKQAqvpkxROhOcNtrvPARkt0T/tE8nAmMw7nXJwgz6bjrSloFHIluqpD8+sPAduyFXFjCBr2cYxZcXIaZopkFSlooljqnCk09lGwvA9gK7Le6gQpmp/7LDEu1vL9atpdNAydyoPBx9ErGTeQ5Fo89+TSg9lxYmXbNYDnAKMZyCj6aj6ZxViJTOmmmdA/re6aglrWZYIXPoJYC+acPiVa++NG6WFj5EISUiy7uL+bpmcQItDCyr+7qf2YMy+5Tiv5TSDkZBVy7zO8SEQWqPI6mT5UCQL9mvGj5bf2PSKsEwZEuLsHTDT5SV9arHTfQf0LF2KvKAiflzaD6V3k8BwrFjscQDYbI7ZzTZ0A/Un3VkF+y9pmSfRvJrCPmafRPQa1v8kITxJDVcGHbYYmCIfqIlraKAolzb+w3kh9WY7jK1Jjpzq4yaWVFImR9ZqloyPbuyc9rDmMz5wecvCpwBzZfrNg4HSOkhJEK7cpV2j3PPZidEq/clmm05B0JtV0zXiY/jennLPRgRrKXvMcWD91le64OARRHJQnf8TZGyArYUOsFKNGHXPBaQ1368k0xN1kUkVYfYZTGSP3Lc4P59zDQCr0hJ8OjNMaOLK+qJDjhp6RcAI48RWWzlEuABsLFmedJ+W5v/5SBwlMYcga4MAOIKN52OdoglQ9YOo2EXSYXMwSTTKRaYXCsKrI6CPkv0M3r8JEgXu95RNiSgmkWTMQ8wzGXVq+L/DSeiqCME/bmPix18U6x3GRpmtp
 LVPo0Qz0
 SVsQQPtZOXU2HBv/N0jzV+06roETi8vH8MF1PICJqKrAGGTP09WOyHQ7/YJYBA3ztktbfn9/v9PO7XMwIe2xJz96amPKUfsciW7dELGsWiViJotRM/UFpv9wZJ11u27mTzfPsDTuMOnd/f1KJ51k7F56diMLsM5Pgv3qRnPY0hxqnyWlNguTV0NP5d7gArTpi4BCZCIp4mCE18zA33Ecxh3GCffEDgdLOPPZPhgvmLSeS6TPVeoeMUn3iahAW/JFFgzMGDye0gJS5GOZGbpbX6rXggS5Cmmv6IOn8oCU3iq2DoJw8q5wMUJQydArZrfYcxgHFeztTXDFKK/7SkyqKQhxq+Fe+QC75wPx+wj0RwSWHh36p6V9DfuUQ87Tg6qeQwM68dKx3EXVZUajf9hjbL4Ne5Zs3opYA0xXH0133GuLr4+vRulyp5XSNP39zt+mKbmbbYp9u/KX4+Q8PgGGhY/zt+ZGCZ+A3I9/07YvJqOpZ0DDSFMdUUpep5jEiuJjJtySO+/nXBh1IAlaVieAPmutTmDEZF8gIeGG3vgwKQFWTE0cKFJtD+q/mEqhWQ1nCxk8dzAI1R4X6i6bYijUBa2OGMjINIvQrQZCqv1Jx9otGTLf4bsp1IuTkLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026, Pratyush Yadav wrote:
> On Wed, Aug 12 2026, Sean Christopherson wrote:
> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
> >> This is ABI between kernels. It needs to be stable-ish so you can move
> >> from one kernel version to another. At the same time, unlike userspace
> >> ABI, it can change.
> >
> > Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
> > existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
> > ABI that needs to be backwards and forwards compatible between different kernels
> > in order to support both upgrade and rollback scenarios via live migration.
> 
> I think there is a slight difference between KVM's save/resture uAPI and
> live update's ABI. With KVM's uAPI, you need to maintain strict
> backwards compatibility because userspace reads what you output. So if
> you change the layout, userspace will interpret it wrong and might
> break.
> 
> With live update, the ABI never gets to userspace. It is used to talk
> between kernels directly. So if you do break that, your userspace keeps
> working fine, you just might not be able to live update to the
> incompatible kernel.
> 
> So with live update, we don't need to keep backwards compatibility in
> the ABI forever. Of course, it is good to minimize changes, but we have
> more freedom to change it.

Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
statement that live update doesn't need to support backwards compatibility.  I
can totally believe that the folks working on live update are ok breaking backwards
compatibility because their use cases are "fine" with such breakage.  And I can
also believe live update as an upstream kernel feature being developed by those
same folks is also ok with breaking backwards compatibility.

But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
to support a world where KVM is allowed to break backwards compatibility, so long
as it's done "carefully" or whatever.  If y'all want to deal with the resulting
complexity, that's fine by me, but you'll be doing it without KVM.

I totally understand that exploratory work and initial development is best done
in private and/or in a small working groups.  But decisions that will significantly
impact multiple subsystems need to be made *with* those subystems.  I mean,
obviously it's possible to make a decision in a small group and then "publish"
the result later, but then as is happening here, the community and subsystem
maintainers like me may refuse to play ball if they disagree.

To be very clear, for any KVM live update support that doesn't guarantee backwards
compatibility (allowing that bugs happen), a very firm:

NAK

