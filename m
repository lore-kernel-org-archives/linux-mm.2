Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77881CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 10:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A0A6B019B; Mon, 19 Oct 2026 06:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B556B019C; Mon, 19 Oct 2026 06:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92F96B019D; Mon, 19 Oct 2026 06:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C80C06B019B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:46:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33189C066E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:46:35 +0000 (UTC)
X-FDA: 85339047150.21.221AC48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D2011A000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:46:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lSYA73yM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792406793;
	b=Tix1lIlqJrUqcwZpi56XckPHqjrxYfuVnsPXLUhXnzkayuNjI+iU6HhX5Xzgragf9ZNEL5
	yQzez+82UifST87SagF1IrNJW3CXAdDI2jA70p6YqIQknGJJ/wZyRKDPU53YY4/JNkHtKw
	Usrtyn8CZvKXUaAjoUVG0v3myJM/5JA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lSYA73yM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792406793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXO2/1ZLYjpyHDjT93fi/BujL9M5/NL5FbbRDOzOStI=;
	b=AWa/GQEK2vh7f8k2abvsjTr9QEJ5QObCFInjopMX6jbe/nmtVuPZuN/Lh9GqUGf2bZcTUU
	6iPX0kBLTZexLxrq14EkjprjX8GgMWprm5dNyZoYyw91XPGbbz/a598Ss6gEQcKbwG/LkF
	UEKzW4WTrvg41iJqvfzmD1akoSnw+Bw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01CCC4403B;
	Mon, 19 Oct 2026 10:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFA11F000C4;
	Mon, 19 Oct 2026 10:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792406791;
	bh=sXO2/1ZLYjpyHDjT93fi/BujL9M5/NL5FbbRDOzOStI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=lSYA73yMQyL4lLb4kPx0Zs3lLN5hldyzT3bd2envsgGUGVBvQEPWXtcmMckyJUUWu
	 8cZlXxgiJFs10A9wmhW7ZoJ3+cn5Sj8EAzUajflfgdSJFDA/5EUbftljxJ1W1sBT28
	 Ebr1W9F8TAOa95buU6O0qAHHExPX47+hbcJz6yGdaqvQjBp20HfbqrP+mN1qgsqhen
	 Jkwm4CCcW3ldfORM667zxYEiF5EMmbbgsf+z9ygLXnP8I9+4wEEGfarhlVm2SOemLW
	 Htv/UWXBk98wmVc0EwCUeHXTyQLw+Ja6IA7QaTIt051iJQPq4C3InOk5isPktjkx3Q
	 6kEab0XFecCSA==
From: Pratyush Yadav <pratyush@kernel.org>
To: BernardoGV@proton.me
Cc: rppt@kernel.org,  sourabhjain@linux.ibm.com,  pratyush@kernel.org,
  graf@amazon.com,  akpm@linux-foundation.org,  guodongtai@kylinos.cn,
  pasha.tatashin@soleen.com,  ritesh.list@gmail.com,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
In-Reply-To: <d4c253f3-d36f-0253-f22d-43c9f397f6ad@proton.me>
	(BernardoGV@proton.me's message of "Sat, 17 Oct 2026 16:19:31 +0000")
References: <d4c253f3-d36f-0253-f22d-43c9f397f6ad@proton.me>
Date: Mon, 19 Oct 2026 12:46:28 +0200
Message-ID: <2vxzjynege7v.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 7D2011A000B
X-Stat-Signature: 5ygorhkoq7k5ihtfixwhf18rbfiex4eh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792406793-56765
X-HE-Meta: U2FsdGVkX19qorzAlDA91ml0SfsJKvfA14y92BAZj3vRZpQI71WJh2UQHqWEL8Ao/6DbyBo5fWN9pht7eUWbzdSie5P/PjooCLzvJrzUmdJd0YywTsk8q+2w1auJ5VvLnxZR04xXHrcxBX8UasDkxLTwyN44b8m35xquWunyYN/VZrSEBypDJEBsmgon7UyDX2qxCfQ1YS51qvIv30RttJ07WEvv13EyHj+wNJmfHNgsngtp4Uyc2fB7FtZO4Nf97Hiq+fbCu3x4897RbP4LJ4zswp/VIaFTM29/gaZfhGC+HWZRROnpXAQZjTOZoPmpwkXMVtDfmlIEaq1i+ystGf5L7J7sQwZd3DvT6MXcOaFYUgsR9v6dZw4UWu1Gg2T2oWvax/xDm10Aq+G0IXxC1o1EwN7E3vHwXr0RqHeiK62pDLB3obXPigzlvtBNz1ALMjBUJtoxT4u8bozodH6xGygbBDR5DocqC5z97EbJHeU9z3Xmgn6KIh1GN7eJHUlCjYnXG7xyiX20HJehaA4yYaxviavD4ctfIENfz+rWdsGJxdXqr7mRal5LqGwnwS29XGCjxfBLtWeSg9LvFl0C79och57cbpOGHBLAyTkkrVhtVP5Z9bbQ6zk77lE8mZmFczjLrUVMvsxwv9VkI40sJdfy1PdB7lo8piE9j1ZMwJsmgys5GA1zKhmsiWm0UXTixrspkqyk5JkpBmyxlPf4LWGdFSEJy6/aVj92fxfR8F5WlcI7+ZpjKb2qRP68oUAT6NpJwiGHe4W8EUrWXp3+Qy5NfgBGfkZU5YrmCRwBaed0bKWm8pzz8tI4O86qdW8HvZpNYlrh55isDul4HTGIDE7uKV/KxtGZ4/wMMCVLGfQgE2wWfUGZNw5OPxAPWWBZSlzL68A5VtGnoo56at+Vo3e0aIv4EbQTiYcxOELFZCa0Wi5EBmtyeFTX3glwbGwyChZ+aVmRYt3L7grpSXY
 k8/f36T9
 1VJlRIYsgFQcOQ/YiddvwnkQT1N8NaktOi4tLr+UJZbxINtNm0Rl1Nols34gvA7QfUcHPiLWf+rEZptf8oQ4HMyfZMJ1ZC/u5P5ccEbBEph40KI4Qz8VOJNRf8FLKN0+6AdJBVAnP1KLo59ZIKiK+MgV61jpfIJDJwXnSYdCXU6PjjPV7CdUIZ6asTagdLqyJmJEHLsz1enj0mXiEcOaFCTr/HCg59bFf7Z2snYDdlYPEcqa5P90T6MQ4mwRfJxkgDJPWsGJC/Ugp32IIReCIrTdCBqrqdE8mtMwJoBrkq0bYMeC6sp5+scufsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17 2026, BernardoGV@proton.me wrote:

> On Mon, Oct 12, 2026, Mike Rapoport wrote:
>> I mean more fundamental code refactoring that takes into the account all
>> cases (and I could miss some)
>>
>> - NUMA vs no-NUMA
>> - systems that have global scratch containing lowmem scratch vs those that
>>   don't
>> - and of course fix global scratch over-allocation
>
> One more case for the list: reservations made before KHO sizes scratch
> that are never served from it. HugeTLB is already excluded. crashkernel
> is the other big one. Sourabh mentioned it in the powerpc thread. Here
> are x86 numbers from a machine that never asked for KHO.
>
> Ubuntu 26.04's generic kernel (7.0.0-38-generic) ships
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y, so scratch is reserved on every
> boot. (26.10 has since turned the default off. I've asked for the same
> in 26.04 [1].) The machine is a single-node Ryzen AI Max+ 395 with
> 128 GiB and no hugetlb. kdump is set up the stock Ubuntu way, which gives
> crashkernel 2048M high + 256M low.
>
> Three cold boots of the same kernel, KHO on by default:
>
>   kho/out/scratch_len   crashkernel   no crashkernel   delta
>   lowmem                   760 MiB         248 MiB      -512 = 2 x 256
>   global                 8,510 MiB       4,414 MiB    -4,096 = 2 x 2,048
>   per-node                4,338 MiB       4,338 MiB         0
>   total                 13,608 MiB       9,000 MiB    -4,608 = 2 x 2,304
>
> "Memory: ... reserved" goes from 18,849,832K to 11,771,924K. The
> difference, 6,912 MiB, is exactly the crashkernel plus 2x crashkernel of
> scratch. With kho=off it is 4,915,232K.
>
> Both problems show up here. Without crashkernel, lowmem + global is
> 2 x 2,331 MiB and per-node is 2 x 2,169 MiB, so on a single node about
> 2,169 MiB of reservations get counted twice. That is the over-allocation,
> and the total comes to roughly 4x what was reserved. crashkernel is
> allocated with NUMA_NO_NODE, so it lands only in lowmem/global, at 2x.
> If I read Sourabh's patch right, it would count NUMA_NO_NODE only for
> global. On this machine that leaves crashkernel as nearly all of the
> global scratch (about 2 x (162 + 2,304) MiB).

To remove crashkernel from scratch calculation, you'd have to allocate
it from outside of scratch, like the hugetlb pages. Crashkernel is
usually allocated earlier in boot, so we'd have to call
kho_extend_scratch() before crashkernel allocations, and I am not sure
if something will break if we do so. I suspect we at least need to check
efi_init().

Not saying it can't be done, but it isn't trivial.

>
> The cost is not only boot memory. Scratch ends up MIGRATE_CMA, so
> anything that pins can't use it. Here that is amdgpu GTT on an APU. A
> single process tops out at 107 GiB of a 120 GiB GTT limit with KHO on,
> and at 117 GiB with kho=off.

Well, my pipe dream is to have KHO entirely without scratch. You would
use the same mechanism that kho_extend_scratch() uses, to discover all
usable early boot memory, and not pass over any scratch at all (or, a
very small amount of scratch). The only problem is that it might fall
prey to fragmentation. If preserved regions are spread apart enough, you
might end up with _no_ memory to boot from. I am not sure how to make
this idea reliable yet.

>
> Happy to test patches on this box.
>
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2171297
>
>

-- 
Regards,
Pratyush Yadav

