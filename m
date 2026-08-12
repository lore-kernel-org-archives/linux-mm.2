Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E293C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1BE6B0143; Wed, 12 Aug 2026 12:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53126B0146; Wed, 12 Aug 2026 12:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41DA6B0148; Wed, 12 Aug 2026 12:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA2F76B0143
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:07:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40A39803FB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:07:28 +0000 (UTC)
X-FDA: 85093097376.06.A38180F
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id 76DEE2000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:07:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UO1PGqdR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3PJp8agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3PJp8agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786550846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhGw4WaAvR2D6BZq/c2SGM6eMLuDwIODKQW5IVkvny8=;
	b=NTW/PvPUs0RKlo29vveAyYQIpuwQI5V2uJHwZnv/H9rmZ8AosUubBM4+PyzE3j8Ac6CRX7
	u9U842Y5+QdKSYzvyVZbGlUoRtyYLYD4lPFxNyh/Pz0Bo5yTOjd1TsA/xvqu+BunwzzGJX
	/NXKfRnhXktCPoQ4iCRRga+lNjaDnLA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UO1PGqdR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3PJp8agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3PJp8agYKCL0vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786550846;
	b=10XWDSG5ZbAU53Yj90Jk8JfBkL1jqJSQJCY3w5cSc2gbVh8TEr0dATNuPZ4P1TkVLafW11
	+0oXIlwAnB6xXDgMqYksqfdJK8qSxPYChoD7xQYddwcPLb37nvAmPQmqM71D3nWbwCPpao
	T0cfBS9hdDBwlO0ktlN5TN4dA3JGB/0=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848544a8496so1333377b3a.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786550845; x=1787155645; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qhGw4WaAvR2D6BZq/c2SGM6eMLuDwIODKQW5IVkvny8=;
        b=UO1PGqdRsBFGsFa6pX0tqzgWh41Q6BQAlFMQdFe3l9VwO+k+J889XXTJdgOclNvYf1
         OgnXcQ8ExWiomOF1yO5FS1CefAT5AwrxX31eiKwSC7Md4PgkhqoMkZpAOGHDnvuXhxo2
         0+Ss+VzDAVJ+SwU5zHKIB68pctEJY+WQjVfnmM6+UQWWuuhqeZmqWOkTEH/4/Ga0fHrN
         OaOc/Uuj2f0VWw6hABFTPWRezEzARGqoNInD/jsNuyi57Z4uKqDvhBWcfSaPOoxVO8xV
         uTOmM0JUVU82Pj3W7xu7jQcA8Q1Nzd3M0sXDIsQZormUxhH7kZUr74inx/D4ba5cUFGq
         8VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786550845; x=1787155645;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qhGw4WaAvR2D6BZq/c2SGM6eMLuDwIODKQW5IVkvny8=;
        b=jWcoh6ybQHExDmzKcuX49eF5Li3NqqUehtyr84nFQKhm0femB30H6w4Ba4KBxQVsWK
         DS94bwySG/xz2HRS0KOwtRoQUohIK4P6cmvWraxdjyV5rAB+u6cSWYUSXyoiKL7BTNM9
         N+ILPYxPRqe61yBpfLRSahGp+x6c01GekK0B1kzSWHMTus5lM0cAEIgsQFMt98rvZCxH
         GxHFcUPi6CHpG8pZlwppXa7PUK72r6xRSnCVsQHm7PdZBnpFl+xrIcSPL9kfmWIYaeEx
         QTY6r5FTaG80VjZc50z34gkNtmDEcCxH9nZv+R//JxSNoO7tgSzcCiDXjMM8sgC+5LHs
         e/dA==
X-Forwarded-Encrypted: i=1; AHgh+RrvFUDy3oVt7uiAnJB+FVP44b4wRKI/Ck3cNy8ZoUISx/ieT2lFROLrcvtNrcbxewmjJlnT8u/kNw==@kvack.org
X-Gm-Message-State: AOJu0YxQwMEXhHAaLqYG+JYX4KrqJyFKHwsW4vbOBywhsLhrS4kRUqRk
	JxbGgU8SbhB5Bw8xtfvztgtD2s0MblmN+aY3fY18I4qQ00A3o56DV4gNTqa/u9uvz2o6miN9wl5
	ecFhdJg==
X-Received: from pfiu19.prod.google.com ([2002:a05:6a00:1253:b0:84e:5c66:796c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1311:b0:847:9c3a:b77f
 with SMTP id d2e1a72fcca58-84fb55806bamr5778881b3a.35.1786550844921; Wed, 12
 Aug 2026 09:07:24 -0700 (PDT)
Date: Wed, 12 Aug 2026 09:07:24 -0700
In-Reply-To: <824a27d101d5b2e2a8a53fb81f5e4ecf15140a1f.camel@infradead.org>
Mime-Version: 1.0
References: <20260811162423.GL544626@ziepe.ca> <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
 <20260811172627.GN544626@ziepe.ca> <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
 <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com>
 <27f2326dc66d6341174c0e510aa518a1297b66ae.camel@infradead.org>
 <anuo_OxfvJbQnn71@google.com> <824a27d101d5b2e2a8a53fb81f5e4ecf15140a1f.camel@infradead.org>
Message-ID: <anyaPHoUfkyxzCiG@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com, 
	rostedt@goodmis.org, bigeasy@linutronix.de, simona.vetter@ffwll.ch, 
	jglisse@redhat.com, christian.koenig@amd.com, paulmck@kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 3jhix3w156e6n9wd4msz6zpx458aw1zp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76DEE2000E
X-HE-Tag: 1786550846-495191
X-HE-Meta: U2FsdGVkX18Ys5HFieiCKbt/ScVoMZTB9RYncwklaqh7CGFbCWHh+X7AdhMbNiOn0cDShqp0hnd/gniCoc/wQnwwECrNUoWKxEVYSPRBO6hYh0Kmg6Klrn3s3E4Nohef03L6xuaYO1CG2t9HCgK3ifKl9lLp9Ffyo/h5B5q0Unp8ip7YikZEKDGyJVzJzuoodJVn/TeyuXXu27021Z2+ZXk3f0hHzIn1aHhk6hR1N+k1hzp6aBsNLABhTN8dmRCh30x5Dr/sgkdmCanIvdG1vXNb5EubDSucSj4jILQAmCQxN1g8JO2dYMf9W6SQ2+pBEKPJwqRV9gqPI8mCA8tEAqVJiJtDbHiFMkrJzRw7JKMDGVyLBHqvbGn3FIXcef8Im0+8y417ZACyOXL1PBO0m7VwCYi1nd6s0lrE0bSMZ2Ci5Mdp8iavvue1y7Sa/sSiqsy8uCvg02B2NGaKJGlWfNvRK9DnbSc7N0rCegv0qGChqc+D0HL8qMwhCWFlCc0Xp949ZdgFCqj/oKFW4k981F1gllTzzmcoEbieLJ/Ju2BjkQmdwS9x6KgOLC5nFiK9YIUbwEoKFzhbmP57Om9VigEDMZdT6vvoFmvUu+XeHtdmC23Xyp6AokH6FVITHWfggo3ciVZwFb9T7wGBicB09po3knoCjaXYMoFMs6GiGJaZ+55p6MAcV5amjdxI4byGRTdH1tIWiptjCTkVGHd+b04Fn6DyX6yLnwxWlddOmEaUOdcoy7CYjV00k/YgJtiG5E70Gkr8LCW16n7CYoCyN0rc8hJ92g1RZ4IX0QEw2vyxhIeRdxOIp03t33YcPg1y5P6tmhUtBWsFS/4RG7MpmEsiFKv1rP5GtTHjmLIXICRwxKBaqyS+DF4jajoDV5BqNRIv7NuIRgnQJBqSXy1NhcuxpwZ3PppU9LGB9At/cc0b5iEd6TXfUzorYaY/ZdOmet9A7g6Q/pT9VL3l3i3
 QrLM7roF
 V5IJBCerLcx+yXMoDDNLmIgIq2kAmSUOrqgiERRAerR8LAjT00T77IDhXF+y9GujAiwnpLj1xQ43oE1QgnNOXOHE1v2cY1/48pCRPhidGQKJXyHmNaX+UpTrFp3SPpxD1UdyDiQJ7645zi2qOKlF3TGH6sU3KOpV+vcxMomfcRNv17u+wr5ncr6pSp6kZ+3hu4BgetXIW1bRWUqb7prw5iYAOyctAMHY0fCAlzfTyTeoZpDLP/t2G8jBshzlEaI2HktDds7PDwgeUVvcsF3FzybOCmuRqNMoUEkgNDUB+NToRjnjfAOc0BaJ7fMVpoFVhvkjxOEbPC1ythXycNk3kz7X6ejPb8g5i4mHcV2MJKroXhUnYGTG/wDpHep7Xh/BrbtjZ+zTrqv0/10a7BZyF5/59h20KkNSIfq9FRgwGrJgZHFo4cZY2GfVtNbv0d9Ss+xFUx5ECxKsjnEs3YzXSmQ8iyPlsinyzHiLOF2PuzsOeqRwQ47bEcfnoLV+3R0KU9rvMzpJDRg9/J68esbQ3AnifKOCexzwmYEUCRl49WXbOJWOh8paqEt5vg3q0zcBZuwvMzN2/ngF7V3/7eHA79SUjqYLabnXyxwR1Uboqk4KSjwLeH60cJw4UCO9xjLpfWOgQ26NK30/B1VDIuMHC4NbXYuC8u65Yc22aILORbA2WuhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026, David Woodhouse wrote:
> On Tue, 2026-08-11 at 15:58 -0700, Sean Christopherson wrote:
> > On Tue, Aug 11, 2026, David Woodhouse wrote:
> > > On Tue, 2026-08-11 at 22:21 +0200, Paolo Bonzini wrote:
> > > >=20
> > > > for_each_present_cpu(cpu)
> > > > =C2=A0=C2=A0=C2=A0 if (per_cpu(kvm_gpc_reader, cpu) =3D=3D gpc)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask_set_cpu(cpu, gpc=
_readers);
> > > > __kvm_kick_many_cpus(cpus, wait);
> > >=20
> > >=20
> > > I'm literally sitting here watching you reinvent what SRCU already do=
es.
> >=20
> > The problem, for me at least, is that SRCU does this and a _lot_ more.
> >=20
> > > Which, again, is *fine* given the behaviour of *these* read-side sect=
ions.
> >=20
> > Well, yeah.=C2=A0 Why use a nailgun to put a nail into the wall to hang=
 a picture
> > frame? (other than the indisputable fact that power tools are fun).=C2=
=A0
>=20
> It's not a nailgun, it's a drill. And in this analogy, my observation
> that it works absolutely fine for us with *these* SRCU read-side users
> ... is equivalent to finding the torque setting that lets you put it
> into screwdriver mode.

Yeah, but my concern is that there are KVM users out there that will put th=
e
drill into hammer drill mode, likely unknowingly, and then complain that "w=
e"
put a hole in their wall.

What I want is a strong guarantee that the user can't configure bad torque/=
mode
settings, even unintentionally.

