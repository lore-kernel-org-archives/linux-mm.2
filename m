Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 027E9CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7726B0088; Sat, 17 Oct 2026 12:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99136B008A; Sat, 17 Oct 2026 12:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADE86B008C; Sat, 17 Oct 2026 12:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 937A46B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:19:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0EEDA02CA
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:19:45 +0000 (UTC)
X-FDA: 85332629130.25.5DA6383
Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE68740008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:19:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail2 header.b=ubyZ2Wrq;
	spf=pass (imf01.hostedemail.com: domain of BernardoGV@proton.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=BernardoGV@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792253984;
	b=24g5zAstvNSK7Sup1zxP5YxyqT6XIVwRUfOBY2Ay+MPynnCVdaW+K5IU8LLCh5yG5cLRU1
	zbyFQ+8u9VTbbaeQUryn3X+0aLVWF17I08fgHUnViuyyvtYvcw/xHAVn/THOAo/lJ/prg1
	Ggj8f03qJpL0dNa3KdrexHaEMc8vANw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail2 header.b=ubyZ2Wrq;
	spf=pass (imf01.hostedemail.com: domain of BernardoGV@proton.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=BernardoGV@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792253984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yaDAKbPnX3HpuNTDLAnNxcR/jGoyDFB1q+z6ycJjZa0=;
	b=xgS2IMyiMFl2YxP0CNbjJgW/jQIFVs5p0aUsQIkU1EWATupMmEbLA6jyKhv9eAPkDQgIL5
	6jyotw9WV6b4ojENaGWVGKfs/W/BsN+07MsBeowZsT7w8K+bC6UuAE6xU3LTZSaRWGUsXi
	BP91rEfNhV8CZHyq1RqpFM4ZkS5F/zA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1792253980; x=1792513180;
	bh=yaDAKbPnX3HpuNTDLAnNxcR/jGoyDFB1q+z6ycJjZa0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ubyZ2Wrq4LqZ5/7guNFCrqMzJvxMK8RL1PM5Vyn+aJD/wnUfKHsvu3qY30yjfCtsc
	 ZJgPhlX4eGlz+YCTHrfY9wN4q6M5wegRj6Gj/jS8fRSdTQ+ndNX6BzXKDTsZ8JGH70
	 z1LVnkCD0HzH/Y9r8/Z7GKAfZywq1aSau2iG5Ns2AbDcCkTcYX3EtwZmAu41iCodNS
	 LsnD8wlB/PXH9bzbrYOc34BGNTw+MUMrPvCfbGqERv1q0HIN1vXUDjjX6IA4kJ9UNk
	 Y7cRl8abz+ychT2UCfOeTZa6IyXfSIE12CtGNi76uYO9qBaZNdRyJcmYp/jslqe0Wy
	 NgcP1cXzTvOyA==
Date: Sat, 17 Oct 2026 16:19:31 +0000
To: rppt@kernel.org
From: BernardoGV@proton.me
Cc: sourabhjain@linux.ibm.com, pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, guodongtai@kylinos.cn, pasha.tatashin@soleen.com, ritesh.list@gmail.com, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
Message-ID: <d4c253f3-d36f-0253-f22d-43c9f397f6ad@proton.me>
Feedback-ID: 60703638:user:proton
X-Pm-Message-ID: 38ba154f675276b492e436a3eb2d748b1c610ceb
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AE68740008
X-Stat-Signature: 7j5564qxrhr1k8bdaxr3oik99x4e1hw8
X-HE-Tag: 1792253983-774931
X-HE-Meta: U2FsdGVkX19BI1lSm3MFpq1CY0NQ6CXUeWGcd4CKwCM0KlWrSqWorhjrt6zKuPpTBYINxoImz21SQB9wGCcdOUOK+kO+21D4Ibue3uL5NOPSl7GMnaAI/Fw37DbgnbkzwZzp9ZyQYXVGF/cXofNoTpRz+dntmaB/rHGirWe+nuG7AzXSK+zuZse603hnQjznwX7xM890IfmgJCpH9RS74q1gLMnVDMfTVm0lQe+YMPMYQGthfaElOIZevFdvQockagLUjgEXIHKqqI1ur6tMh2HKU1ETgd+VT/wtzhus3vV0N/fpWcUvM9I+dPSNFb2lHAYB0YzPBkE1kyQJVghKKaFlEzCV11ikXebdQplzE/YucNxv0/JGJfx9epSgYGaSZzGA3KzI2Fv1KtI+yhR9Xn0Pv3FeVoiY8E6zs0V6Z7JnbjZVPVwQSQRU+l27EDxVdAROavYttnJXynVPU31eBqwTJQKNtYPVjGIVKb373r9Sb08udlzYCs4M4bvEkGmC91Xv3bHQL+VUm4O9JdDCsWyLVWT7bfZ9A/uVbVm0pFfJ70VTq3m0GjAL2Zbi7zql8FcMFqbUwke01Onj9KQ33x7wJpwTOYyKdPYTq6y3MC+P5g5mkUoI2scKkUCIHz7JT5sttrq6RN9EA5IOcPDyYZQeu8YuNbl6GRN3t/T/FEkOuqOW6fAcZoPUdht3y63a3F7NlxyyDpToX9PBGFq1qW0Bk8+VAXdUgqDVUdO3hb8EqlGdFEX/1t9oC6vIq3XaiwqLR2QF+drEngLPIJ2WrYtXav5UPjstHwmtF60tDFDnSWAasITDKb2CfwBG+rD3TcUwpNJdS7kNXkJ6NA1on3mplXLaRy8XVNBk3glRjk586feeZ9Sg6mNX3y92uLhUO7+s8QraOZ+NQH/RIRCa+Gnr8OLr+tFikefTWHJJVnHd7wLfuRZu6L363HJAyz2QqJ7T/PHzFBmRVSRl8w3
 UQrrdWCI
 KFFhF9Y+0fw8rlwn54Om0DXyLpxYdy8oHcWDjjGzxXLE2FCrhKyuv+PveqCSrg6Sn30UoFcldnB3HXKOS5C4Hprl/UmHcEjitrMkAOVEAY3teQrqHQTh9V9ZXo9gFynglXqveKzE07Lmx780iEuEUeHWfUwR/bpiRHE0gexDwUKCPzpCoIRRxPVu2oHrnru146EbEldb+hFh5E9YYwhUlRClxmwWyMq5VbcgJSrMV0+rzVhf8wd6SybdOtaBDlaDT07gHygUXZwBj/Dcn13vVhyqHbQwOLs+xP6sXOzyc3VsWEBwNw3cdlHGWGYw6Ng31TMGds4gbH+ZLncMZ3zkZzj/fmbe8/+gZMVOncAlh82LoKqd60ke2FIcVEmDsZstsIDZJanhFrrvOy0gLT5M+mHNM/N2ng64T5tVTk9DHv4myVNmE419P3cow/VHSRkMCNilNUDx3Y2kSkDx7XIK5qnXvFu1NAVnUsINK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026, Mike Rapoport wrote:
> I mean more fundamental code refactoring that takes into the account all
> cases (and I could miss some)
>
> - NUMA vs no-NUMA
> - systems that have global scratch containing lowmem scratch vs those tha=
t
>   don't
> - and of course fix global scratch over-allocation

One more case for the list: reservations made before KHO sizes scratch
that are never served from it. HugeTLB is already excluded. crashkernel
is the other big one. Sourabh mentioned it in the powerpc thread. Here
are x86 numbers from a machine that never asked for KHO.

Ubuntu 26.04's generic kernel (7.0.0-38-generic) ships
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=3Dy, so scratch is reserved on every
boot. (26.10 has since turned the default off. I've asked for the same
in 26.04 [1].) The machine is a single-node Ryzen AI Max+ 395 with
128 GiB and no hugetlb. kdump is set up the stock Ubuntu way, which gives
crashkernel 2048M high + 256M low.

Three cold boots of the same kernel, KHO on by default:

  kho/out/scratch_len   crashkernel   no crashkernel   delta
  lowmem                   760 MiB         248 MiB      -512 =3D 2 x 256
  global                 8,510 MiB       4,414 MiB    -4,096 =3D 2 x 2,048
  per-node                4,338 MiB       4,338 MiB         0
  total                 13,608 MiB       9,000 MiB    -4,608 =3D 2 x 2,304

"Memory: ... reserved" goes from 18,849,832K to 11,771,924K. The
difference, 6,912 MiB, is exactly the crashkernel plus 2x crashkernel of
scratch. With kho=3Doff it is 4,915,232K.

Both problems show up here. Without crashkernel, lowmem + global is
2 x 2,331 MiB and per-node is 2 x 2,169 MiB, so on a single node about
2,169 MiB of reservations get counted twice. That is the over-allocation,
and the total comes to roughly 4x what was reserved. crashkernel is
allocated with NUMA_NO_NODE, so it lands only in lowmem/global, at 2x.
If I read Sourabh's patch right, it would count NUMA_NO_NODE only for
global. On this machine that leaves crashkernel as nearly all of the
global scratch (about 2 x (162 + 2,304) MiB).

The cost is not only boot memory. Scratch ends up MIGRATE_CMA, so
anything that pins can't use it. Here that is amdgpu GTT on an APU. A
single process tops out at 107 GiB of a 120 GiB GTT limit with KHO on,
and at 117 GiB with kho=3Doff.

Happy to test patches on this box.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2171297


