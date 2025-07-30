Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADA4C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3D76B0088; Wed, 30 Jul 2025 08:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164466B0089; Wed, 30 Jul 2025 08:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0530F6B008A; Wed, 30 Jul 2025 08:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7CA66B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:20:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC680160421
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:20:23 +0000 (UTC)
X-FDA: 83720838726.13.F0C8B5F
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF6131C0007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:20:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HFocwYGE;
	spf=pass (imf20.hostedemail.com: domain of andre.draszik@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=andre.draszik@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753878021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RCIk5vzFfP8iX+aivLku36+ce7/VFd7gJpq5Z9shY4=;
	b=sf6ycpn6rIBtZPBgVu7GxoaUcxM3iHXybX+gBHnXCD+h2vuwI7RnTrcuF1ZucH+0fp361k
	ej6ULu49UX99g3KGwvP9EHJuPLj4yXWaGexqydvmKPD1PesCOknVyTCHFl5/FnonxOA40h
	jTQQDg40jZVI7b/lA4DqHjdOVzPtPDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753878021; a=rsa-sha256;
	cv=none;
	b=Pbjd+x58kOll2L4qFReq0LBKrDnTl+lGNNWKtqDxeh4sR82LCWzJFsvMq7YpPInmNdNusW
	eQMVScOYRCmBsQkkoY7QC3NS4LQQhO1aYLcEyWI2JU+O9+gCy/nX3emw18aGAfL/gzVbez
	Uk7NLHeMQ6dt6s9kct7W8I0gqkxvY6I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HFocwYGE;
	spf=pass (imf20.hostedemail.com: domain of andre.draszik@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=andre.draszik@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b783ea502eso716459f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753878020; x=1754482820; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6RCIk5vzFfP8iX+aivLku36+ce7/VFd7gJpq5Z9shY4=;
        b=HFocwYGEuDCqv0wANeXmlJA00oFsNQQXFpJLAE1uAh53lwycwyKwz8reKpXPcvWVxa
         qwZ/+ue1aEvVJZjytsl46a8+ieXgUazOlKGpt3K5W/NRAoh2LkVlTmtwb/SIdAstWfh5
         MSbuZWiqJm2zqta2x4DivSzewsDL2UOiid2xtxRWIYJpZQ9ihPmVAkNgyvcLomi9qbpt
         JcefMGhR2cvjOqOn1wxTrEe82g/Byg5U65lp4m8Zau4vY1L1OmvPo1zTImyFqGRne9gg
         o1f9IrKKmCHB5CtGqv/vZycSHZdIvanvpW0pJx49xwxOdX4b8T1bZ1z3YzjZZd/gj3EP
         F2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753878020; x=1754482820;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6RCIk5vzFfP8iX+aivLku36+ce7/VFd7gJpq5Z9shY4=;
        b=YOvnUQpegM/a0MUqANLDaCOIZ6LwWx4LUdA+gVRiO1x+M9hoPzqQ+M41DOB+I+5GeW
         ltDF1dgyqK2RYsHn8p1BRxWgcHaHQgFHCxT9CGY9R+I5qsUvY6bi64k1XWbKHxgy4scn
         oTscqF35YqbwXe1ElkJ9XGAVI15v+zAs4mMTrUSDNNmMV83ZzW9HG0p/JAsuJaT6pFWf
         6uI80t8B1xAOJ/itnZkRKBRRsv5BJoYBGMT7QZHyHqOt9k91GFOLJin5y/7RSgj/l/IY
         ejyYJoYdQrM6cSWPKm6SnG1+KJ50hxby9AS2DzUM//kH87WuB4bSzns0UeJzg1hLW+4N
         EASA==
X-Forwarded-Encrypted: i=1; AJvYcCUNa1x7upZ9yzXm5zulahDU4u2OjPa9k5/m0ye0mDCnRTq4MjBORKi+7Osrp9yLqi9OblhvnA86mA==@kvack.org
X-Gm-Message-State: AOJu0YzUS+Vpiqd4JPyD/szWq7wBgK3hEtIucQzQ1QX0QrHwjFepmrxI
	v+v0EVI6w0SaNBsEBOMHgXNRfHBH2j1JEaBPJ2PL3T9jANPBlV9w9tLJpEEZ12uCjI8=
X-Gm-Gg: ASbGncsvUIiVKme78Tb6cusczUaRbEeWr13bRNep/3g08ec+IF59Kds2KlmCWeRUsY8
	PlPgpAahtaNH/weGCyvwAPrzpeUkU/sc7FRb7E6gZIXNCVfwhALArrbjXlbWujPN3uR5/GBTNQ6
	n6ywWGW/UPTyIiXqVaeqQKp1HRfiG0Y2Jag7bn1NzcryWTMa5bTuS2dmSYOA9m9S7XenTBSaGcP
	mXogGrm1RTIlxqYj3MXDeBI73WtVDDzNFS9xDhW15NPi/bIInDfBB6qwFnNQLYjAjptKE1rqGoM
	2J3xur7EpxXWTJ8Hg48rFlawSPRjuCqxvir7rCzyIwUjickJ7UbVfleriVZChNJ7JfV30v7/t1Z
	BAacajH5cjoFcqjV9zuUfyP7Z9w==
X-Google-Smtp-Source: AGHT+IEf1nLZq2A/9qjF7cMRwVowf6aVMbDmzAl3uBNou1TtuZ9IH3zr/KEDQxg/DBhbKFpXNNTITA==
X-Received: by 2002:a05:6000:2003:b0:3b7:908e:e4ac with SMTP id ffacd0b85a97d-3b7908eef14mr4440299f8f.2.1753878020074;
        Wed, 30 Jul 2025 05:20:20 -0700 (PDT)
Received: from [10.1.1.59] ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b78d45d010sm6980865f8f.8.2025.07.30.05.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 05:20:19 -0700 (PDT)
Message-ID: <0c8cc83bb73abf080faf584f319008b67d0931db.camel@linaro.org>
Subject: Re: [PATCH v2 2/6] futex: Use RCU-based per-CPU reference counting
 instead of rcuref_t
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	linux-kernel@vger.kernel.org
Cc: =?ISO-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>, Darren Hart	
 <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, Ingo Molnar	
 <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra	
 <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Valentin
 Schneider <vschneid@redhat.com>, Waiman Long <longman@redhat.com>, Andrew
 Morton	 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Michal Hocko	 <mhocko@suse.com>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Date: Wed, 30 Jul 2025 13:20:18 +0100
In-Reply-To: <20250710110011.384614-3-bigeasy@linutronix.de>
References: <20250710110011.384614-1-bigeasy@linutronix.de>
	 <20250710110011.384614-3-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+build2 
MIME-Version: 1.0
X-Rspamd-Queue-Id: BF6131C0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: uwrtc9o5qawohdjtpzg6ncg75ida9rej
X-HE-Tag: 1753878021-721298
X-HE-Meta: U2FsdGVkX19B7emK7i0Y9Jts1MP93nwWFl6jFHqL4RJdjmiCwCCrs+elikbSuqKrQjepD8QCy3DZn6XZcirfkAjOQKXKZE3hQTK8SPhx0XKBsUsLDG4QGvzxiD9yivljbsOZCNpGBg4FdxvFWrOq7AzlCP1KUgh4NM2+Ec1apX2oFROzkt7njsGX53ap3K9oXOSPXWSVeotGE9tR4HS70Ir26dqjwroX5UVfZ93j9QiU+rOEBoF/s3Xb11UO9sHj70Lj0TbU30+34KMSfNazL1L9I2b2VRJR5airFTdxPz6+hejfXVL0JbBTRg128P15e1UAAoEq25J6b3M+znn351XgiE2f3+ttXhmFQCY5eeYxxSuzjHjRGlwJlnBTmU0GbPr8Rf4upa0VEryx7PAvdQKCJ1lLNNJe7hPMJPnZn9dGqSSiUD38Q4Jce77M/gFf1A29T+cfHhijNb0BGpGaHHMhqewDayJeZEgRhbktIyQPa3HhQ9dUJnQoQRmgZH30qwUHKgemqkUp+4N+6fIZ3chhIpOJCf6+SZQ6RTgolUMFDKF7pD2eH1bQmZFqWwe4vKc5n4rNGHLlHXCjmCNcdkg1zY6lqjE0bSzRuz20bdbGZl3FcxcsdEA3VXffU0CrKc5zpIlsYF0A02qzqrm+RS1gzN4ToCBo0Z3+kwlhVfVYO7jyOnDaJvJUyZ5pliE70Qj8k2ZT+iIsVdvq8ou+uvaQLlLA12OGq+Sb66Piy8zZ/iQZ2NpDCNYkj3eAyO1/1gBagXnQo76nTmUKiibbb9sPf7v828JvhGGqCm2VPYWVQ311wG5vMXg7OBasP9si+jg3umQO77tk6SeQVsD+4BPv58la1rt+vyMspfRrcbGGpHxIGrCZu7nAPd8jFmxMko9LHdjUkyCQ+/Apq43X0GWkG77et/HRfMtCkBTq9MKfGi5PBvmGevYYK/2z/RZrF4NXC6/Jdt7H0BNDSTU
 CQY8Bg6A
 Nn6rVxnKIjO+Ze7RTPvtWwQTc5nM6k5prqx8F7O/PzWFBtc2QdbiXCjurjz8Bb+m64icZDRVkPFTW1zgD1CprjxDH+K3zxtPx10Dpro3IeDF2oSAKnakjcZcvJRxIxVZr8+l1hbD5bPL8gnsiI2UlWDej5qbl7LWynKqwwFZ/kuiTDd00TU80DtotE0GKPobWJztZP7LBWoqU0m0/mieZ8XUAaK9u6WfR6zDY7AOspfCkjxJmQWWAEMY72NR4y+t1YsDaj1QQSuzEEfXtHRX3YIKA4XAyUV7fpahdehhxCSFgoIjUhGSSuyNuMQ6cFWw352jW4FMCF5xDEZkljxC2ryH5zr9JhiCNgyb5V+x7C0dsOK3c/BGOY88XSc/20V/S81sXDv9DH0dHnpCllXhYxWwOqpG92nRFSzRi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-07-10 at 13:00 +0200, Sebastian Andrzej Siewior wrote:
> From: Peter Zijlstra <peterz@infradead.org>
>=20
> The use of rcuref_t for reference counting introduces a performance bottl=
eneck
> when accessed concurrently by multiple threads during futex operations.
>=20
> Replace rcuref_t with special crafted per-CPU reference counters. The
> lifetime logic remains the same.
>=20
> The newly allocate private hash starts in FR_PERCPU state. In this state,=
 each
> futex operation that requires the private hash uses a per-CPU counter (an
> unsigned int) for incrementing or decrementing the reference count.
>=20
> When the private hash is about to be replaced, the per-CPU counters are
> migrated to a atomic_t counter mm_struct::futex_atomic.
> The migration process:
> - Waiting for one RCU grace period to ensure all users observe the
> =C2=A0 current private hash. This can be skipped if a grace period elapse=
d
> =C2=A0 since the private hash was assigned.
>=20
> - futex_private_hash::state is set to FR_ATOMIC, forcing all users to
> =C2=A0 use mm_struct::futex_atomic for reference counting.
>=20
> - After a RCU grace period, all users are guaranteed to be using the
> =C2=A0 atomic counter. The per-CPU counters can now be summed up and adde=
d to
> =C2=A0 the atomic_t counter. If the resulting count is zero, the hash can=
 be
> =C2=A0 safely replaced. Otherwise, active users still hold a valid refere=
nce.
>=20
> - Once the atomic reference count drops to zero, the next futex
> =C2=A0 operation will switch to the new private hash.
>=20
> call_rcu_hurry() is used to speed up transition which otherwise might be
> delay with RCU_LAZY. There is nothing wrong with using call_rcu(). The
> side effects would be that on auto scaling the new hash is used later
> and the SET_SLOTS prctl() will block longer.
>=20
> [bigeasy: commit description + mm get/ put_async]

kmemleak complains about a new memleak with this commit:

[  680.179004][  T101] kmemleak: 1 new suspected memory leaks (see /sys/ker=
nel/debug/kmemleak)

$ cat /sys/kernel/debug/kmemleak
unreferenced object (percpu) 0xc22ec0eface8 (size 4):
  comm "swapper/0", pid 1, jiffies 4294893115
  hex dump (first 4 bytes on cpu 7):
    01 00 00 00                                      ....
  backtrace (crc b8bc6765):
    kmemleak_alloc_percpu+0x48/0xb8
    pcpu_alloc_noprof+0x6ac/0xb68
    futex_mm_init+0x60/0xe0
    mm_init+0x1e8/0x3c0
    mm_alloc+0x5c/0x78
    init_args+0x74/0x4b0
    debug_vm_pgtable+0x60/0x2d8
    do_one_initcall+0x128/0x3e0
    do_initcall_level+0xb4/0xe8
    do_initcalls+0x60/0xb0
    do_basic_setup+0x28/0x40
    kernel_init_freeable+0x158/0x1f8
    kernel_init+0x2c/0x1e0
    ret_from_fork+0x10/0x20

And futex_mm_init+0x60/0xe0 resolves to
    mm->futex_ref =3D alloc_percpu(unsigned int);
in futex_mm_init().

Reverting this commit (and patches 3 and 4 in this series due to context),
makes kmemleak happy again.

Cheers,
Andre'

