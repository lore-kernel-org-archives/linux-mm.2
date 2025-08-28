Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344B7C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4348E0006; Thu, 28 Aug 2025 04:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BD26B0008; Thu, 28 Aug 2025 04:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6921A8E0006; Thu, 28 Aug 2025 04:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540476B0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:36:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC7FC1DE8D4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:36:56 +0000 (UTC)
X-FDA: 83825510832.07.3348DDC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 695C8120003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:36:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ga/XY1uH";
	spf=pass (imf29.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7lHy2+AALGufH3OMpwunrxRhiVfYkaGy+pWu4FZmlc=;
	b=ISLlXY6lT82Xh8Xtj3MgouJe+yIqzyw4WGMgw5KPSwWSklcUE88/RAm/zqSdt7sym0P5Wx
	QRF0QnbYh8kdy9octXPry1YhlblDBP3AB3d22wKQ1XS4mxIWUaqTek8VQbLX+8JL6V1KkE
	as03DEjctXfmAhK9zl1B7kPujmOLF2c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ga/XY1uH";
	spf=pass (imf29.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370214; a=rsa-sha256;
	cv=none;
	b=LkZPma94izw6jMLMNFBbXOJjFeclXk/BTQa+A8TlONN4WS6F5Ky2dR6kiu9bHByMFotuQv
	1FM/vZKBLCWgB6eI+blbpAsQPOHN8hygLqvde+VSyBZHYp/7H+m4Mmr9+wHd6rx/U805Ne
	INEF+SVAn+3LHtYSa+FkUOBeW/v0HS8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756370213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i7lHy2+AALGufH3OMpwunrxRhiVfYkaGy+pWu4FZmlc=;
	b=ga/XY1uHH1MAiTt7VlsOU0suna9T98yJRqJtSK84SN27xTBr2JFh9gDj7kOKY+RO0z8LnD
	63IZ68X9FOXEZOK6clebdncqrkxp4iHshDFgvkD2xU5fmatwsEJCscfDs3PwBIHbYxkg04
	yNrvtW2Ss18LnWAY8OESZeYTJ0v0pIc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-pTZShz3_NTK4_eH3o_ZIkg-1; Thu, 28 Aug 2025 04:36:50 -0400
X-MC-Unique: pTZShz3_NTK4_eH3o_ZIkg-1
X-Mimecast-MFC-AGG-ID: pTZShz3_NTK4_eH3o_ZIkg_1756370210
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e8704e0264so182364385a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370210; x=1756975010;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSjUmvSnzhT5n7A6inv7FM9jaAvFvhockhlgWAqu+vQ=;
        b=DNH/oyCqzD/HHEWi9uvhoyKGQ3risirfyBt4L6uGhY6JbtCitICWb17YV/A7nE7dWt
         3FDhOSglvWawy3wTrWlr2aSzGLUs9Qiw/RIQr1sEa7AJ8AVFRPUOeLrIRYVQgaMk/PtU
         z7HWUVTFkUyQa9sIBsNWZ4zYlnu33634KTTGxg45UPVqBTFL2DH4gVIm1zI3SEJqcAXr
         mnTC5XgkKCJz0ObArT1xtulEKlj6Yzz31gnBKYvmMxnSt8nE7TXiWz43d+fdZGcTLHlT
         7mLvrQIp0Bn6SPxI+9H/hwF0ucIsKUUpXL32xZnNUepLqcokgvN18OvItZ2XeKPKkmle
         NLzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmMmP7Oljt/OUSt1HDLS7QdedovrCH0kIj0Q4weqUAa5Sq8SxT0ifbZ5Ufh4CXjka7Vn1XLYw6AQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8SyA/g8gmUyLJ6viq/8UXFdSRNCWzkE3ylLvaA3ef15wtIhJ3
	lnE6BUgnNd/ZltHUmdeI2DoGiWzGXPqcC384/lt27rIv+4bdbqDFDuc2ugo2qtgUwfmTylSy6Yj
	MFPLEuAKJTPe4DtMC2yrFEHmsGiLXdODjsZolNKAv5MJ4mJ2QuesP
X-Gm-Gg: ASbGncvq02BiQh8m12Mm8JSgvfYQKh4/+IEe0sDoiUuUJcgvrjMuf0AohUuAiaP3ldU
	yJkC8tgs2IVIUmRBQe3jA81AIpkyoV4kw3Fu876BZvBCfwJzOnWCZAQlKNK8YcAaqdxt2IhO/Yh
	QozOCQwqTWUDpjkV7u8Jils7lRrN5ewc6gnQcDjOyCa20H6j3L0fnCS49WzJhs6GdxAnDNc0DCj
	z1epjrPSVALHsCh5NiSgypDKAEmXa4U7OGY0dqGlrdorv+An+G0UIGwXrBJ1hV+Pva8PVT0FcwR
	hstb7ikC6yTeC7y2u80Bl7XNqayl6P1dDAU/JnGpUhWVHlovhjFUdxzqFPrAb+37ZQ==
X-Received: by 2002:a05:620a:c44:b0:7e8:3f25:d8e2 with SMTP id af79cd13be357-7ea11045e0amr2099481185a.62.1756370210036;
        Thu, 28 Aug 2025 01:36:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsijQwZwhAabiy8jbQFP9pXJIeKs7UWvptIDHD0qC3IcBIpz6vw7YVR9JLPOiDAioox8BZlQ==
X-Received: by 2002:a05:620a:c44:b0:7e8:3f25:d8e2 with SMTP id af79cd13be357-7ea11045e0amr2099479685a.62.1756370209648;
        Thu, 28 Aug 2025 01:36:49 -0700 (PDT)
Received: from gmonaco-thinkpadt14gen3.rmtit.csb ([185.107.56.42])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebed8911aesm1050432385a.19.2025.08.28.01.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:36:49 -0700 (PDT)
Message-ID: <10f2d5094a6c2dae1bcbf7d7f8198c11c6fce4c1.camel@redhat.com>
Subject: Re: [PATCH v2 3/4] sched: Compact RSEQ concurrency IDs in batches
From: Gabriele Monaco <gmonaco@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.org>, linux-kernel@vger.kernel.org, Andrew
 Morton	 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Ingo Molnar	 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 linux-mm@kvack.org,  Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 28 Aug 2025 10:36:45 +0200
In-Reply-To: <7fddf82f-e85e-42c5-90f3-9cfca4d8756a@efficios.com>
References: <20250716160603.138385-6-gmonaco@redhat.com>
	 <20250716160603.138385-9-gmonaco@redhat.com>
	 <7fddf82f-e85e-42c5-90f3-9cfca4d8756a@efficios.com>
Autocrypt: addr=gmonaco@redhat.com; prefer-encrypt=mutual;
 keydata=mDMEZuK5YxYJKwYBBAHaRw8BAQdAmJ3dM9Sz6/Hodu33Qrf8QH2bNeNbOikqYtxWFLVm0
 1a0JEdhYnJpZWxlIE1vbmFjbyA8Z21vbmFjb0ByZWRoYXQuY29tPoiZBBMWCgBBFiEEysoR+AuB3R
 Zwp6j270psSVh4TfIFAmbiuWMCGwMFCQWjmoAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 Q70psSVh4TfJzZgD/TXjnqCyqaZH/Y2w+YVbvm93WX2eqBqiVZ6VEjTuGNs8A/iPrKbzdWC7AicnK
 xyhmqeUWOzFx5P43S1E1dhsrLWgP
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T5lKzQ5VEixyOWl4TkCMuM9Pf9qnp6M6hOW2B2yW1tQ_1756370210
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9nixqc4m6pn5u1rxu8i1eco6mxs7brq1
X-Rspam-User: 
X-Rspamd-Queue-Id: 695C8120003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756370214-630086
X-HE-Meta: U2FsdGVkX183NLncphSP+yKtGg6z/UDmpDNkYzORWFvGOCrhY8WNHVZ1VHufTZ1upZUeUdvayhKM6iFmBCxrOey962T0eWLzUhHRzXl/qqqiYPYBJ0bwVP6goqhO5edJlw/Zycg3C+ENv685TrbF+cgZPy+2Chjj2++lgIR1EufFSq809ZsB+aIcYNBm8dDg6gwhaaYXIpc4yvzQhs3hBJ7jtCl5LiqSKB8QchGxAGdGULZmA8+Y876Q1EwUsFra8btWtH/WXueGBKPe1Xf1HmbVxrMcvdk8IlzFP+wPSPDaU2EKW9fu6BMoGXj7RlFVd4IFppV/0oaTksoqnJI2E37gwTPGc3XmZ4v//SPu6BhTGikeRfRmr4ap+36eg5iZQX8+ZwewP8Lk25R/xGGYGkeg/RnZJukM5lFLNPDyFDx+Mg3SUh1xRrKToUmopYnfut17rt5WlZ59yZI4z8hlnpEqLugfTA/5u/I88k9PhHvKosIckIZw5wnj3LG0AHu7rHpYCU8HMuc/TkXhYOqFzXyXU/6spq7XEGNPhFr8myXhwaOhy4zd6R8jQepYonDHUq8CwbRRv6MT3N9qO034of3JwioK6VMPcTVHdv3lbU9ERq+HpxZv7gre8ZU811RROvlklE3mB+8HlwikqU+HQ/Pu8ld5wRltVvaDHpjUXI/Kt0crvQnBizvjX1y2Wki7sljv5UyTzxi7wYKDYsO7R3+P4jCfik4R9aY/b8l4pqD998U1+PDbMy77N9EDzzTCsvX35wOALA7SGcyW9G1rFf8Gt3AHTstAuB5yZNlHej/lTjpKP8q1UqwlegWcMLd6LfkRxN3teZ3ihPQGkXhMvDtVJpZVb6dKZsrG+q8s8irc2AEV2NljGG6/W01pw/PIbhLSNwG3VwK+WRIlLQnk0c2YZTKNZ4qy90X54cS5OcgMY7vPGTtC8CSVbTZ1PL3cmPGUSd3vSDZ5T9tc1FV
 AqydsknK
 PxJeT3g1Rds5ecu9NjLtF6xjM8b1B9mgX7FZgJHNZFPgb66EUYrrFNOnQ3vseMYaby74BUiGNOElPtAh/k7MCkGCaDW7lLwkU0MLgoRlPLCWFB9dJOe6hhLvsnTNjYttH8XDZPko6umt1qmCc+HENNnNILhScFzNPXoMo+NLqOkknKQk+dsImjf9cDa5f24Xxsbx02UY4kEnJMW47g5gKCrZ9bsVRRT0M73VTbE6FHzTOOb0cRSvrZshCr1+f0NXGsNhH1vXmblZbZp1xPqeW1Q+3NMAgH6L0+FamYWCQWAPNiCZ2wSg+kD23wzhrHIA0+3NIV+rKUAqAmAFgf9lgRklLOMFLpG0r5T+UzxwRDh2/vaZrAMaTP9vMMgUlNwcN5SOU2qXHTulv55CjkkSI9S7utVzFHjQBVTrr7TEvhoZjKKjcnKrNoYd/zQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-26 at 14:10 -0400, Mathieu Desnoyers wrote:
> On 2025-07-16 12:06, Gabriele Monaco wrote:
> > Currently, task_mm_cid_work() is called from
> > resume_user_mode_work().
> > This can delay the execution of the corresponding thread for the
> > entire duration of the function, negatively affecting the response
> > in case of real time tasks.
> > In practice, we observe task_mm_cid_work increasing the latency of
> > 30-35us on a 128 cores system, this order of magnitude is
> > meaningful under PREEMPT_RT.
> >=20
> > Run the task_mm_cid_work in batches of up to
> > CONFIG_RSEQ_CID_SCAN_BATCH CPUs, this reduces the duration of the
> > delay for each scan.
> >=20
> > The task_mm_cid_work contains a mechanism to avoid running more
> > frequently than every 100ms. Keep this pseudo-periodicity only on
> > complete scans.
> > This means each call to task_mm_cid_work returns prematurely if the
> > period did not elapse and a scan is not ongoing (i.e. the next
> > batch to scan is not the first).
> > This way full scans are not excessively delayed while still keeping
> > each run, and introduced latency, short.
>=20
> With your test hardware/workload as reference, do you have an idea of
> how many CPUs would be needed to require more than 100ms to iterate
> on all CPUs with the default scan batch size (8) ?

As you guessed, this is strongly dependent on the workload, where
workloads with less threads are more likely to take longer.
I used cyclictest (threads with 100us period) and hackbench (processes)
on a 128 CPUs machine and measured the time to complete the scan (16
iterations) as well as the time between non-complete scans (not delayed
by 100ms):

cyclictest: delay 0-400 us , complete scan 1.5-2 ms
hackbench: delay 5us - 3ms , complete scan 1.5-15 ms

So to answer your question, in the observed worst case for hackbench,
it would take more than 800 CPUs to reach the 100ms limit.

That said, the problematic latency was observed on a full scan (128
CPUs), so perhaps the default of 8 is a bit too conservative and could
easily be doubled.

Measurements showed these durations for each call to task_mm_cid_scan:

batch size  8:  1-11 us (majority below 10)
batch size 16:  3-16 us (majority below 10)
batch size 32: 10-21 us (majority above 15)

20 us is considered a relevant latency on this machine, so 16 seems a
good tradeoff for a batch size to me.


I'm going to include those numbers in the next iteration of the series.

...
> > +cid_compact:
> > +=09if (!try_cmpxchg(&mm->mm_cid_scan_batch, &this_batch,
> > next_batch))
> > +=09=09return;
> > =C2=A0=C2=A0=09cidmask =3D mm_cidmask(mm);
> > =C2=A0=C2=A0=09/* Clear cids that were not recently used. */
> > -=09for_each_possible_cpu(cpu)
> > +=09idx =3D 0;
> > +=09cpu =3D from_cpu;
> > +=09for_each_cpu_from(cpu, cpu_possible_mask) {
> > +=09=09if (idx =3D=3D CONFIG_RSEQ_CID_SCAN_BATCH)
>=20
> could do "if (idx++ =3D=3D CONFIG_RSEQ_CID_SCAN_BATCH)"
>=20
> > +=09=09=09break;
> > =C2=A0=C2=A0=09=09sched_mm_cid_remote_clear_old(mm, cpu);
> > +=09=09++idx;
>=20
> and remove this ^
>=20
> > +=09}
> > =C2=A0=C2=A0=09weight =3D cpumask_weight(cidmask);
> > =C2=A0=C2=A0=09/*
> > =C2=A0=C2=A0=09 * Clear cids that are greater or equal to the cidmask
> > weight to
> > =C2=A0=C2=A0=09 * recompact it.
> > =C2=A0=C2=A0=09 */
> > -=09for_each_possible_cpu(cpu)
> > +=09idx =3D 0;
> > +=09cpu =3D from_cpu;
> > +=09for_each_cpu_from(cpu, cpu_possible_mask) {
> > +=09=09if (idx =3D=3D CONFIG_RSEQ_CID_SCAN_BATCH)
>=20
> Likewise.
>=20
> > +=09=09=09break;
> > =C2=A0=C2=A0=09=09sched_mm_cid_remote_clear_weight(mm, cpu, weight);
> > +=09=09++idx;
>=20
> Likewise.

Sure, will do.

Thanks,
Gabriele


