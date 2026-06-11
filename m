Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12403CD98D6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677676B0005; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627976B008C; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53DB66B0092; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 424DE6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2A3E40675
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:52 +0000 (UTC)
X-FDA: 84867644064.12.459FF07
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14CBB10001B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=omEp8GTX;
	spf=pass (imf14.hostedemail.com: domain of 3vLEqagcKCCM9A9QM9RFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abarnas.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3vLEqagcKCCM9A9QM9RFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BD4ZiLw2q2GCJI2/AVfMMRUM2DNcD4XHKmAqREpv/88=;
	b=JERVbU1a52HkN939+FME88Z/wD98moZltDborQ6tgEUzOaOmjhZMY9Xvp+gM6Hs8NceR1V
	Clr0ZHxhJXtueYl5GuA1+1gJWhDsG5+T6X+Ersp3CUco0NR1blfly8kFXLvCITYGagx4UH
	66hVbSxMmLIt6Nt1QnY27fRRG38dXAo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=omEp8GTX;
	spf=pass (imf14.hostedemail.com: domain of 3vLEqagcKCCM9A9QM9RFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abarnas.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3vLEqagcKCCM9A9QM9RFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182911;
	b=vCRHA3GWkNGkV5GPbqU/EmjfdQoDzZVmJZZ9sF8YQLkxcveujQOAt8/dX4hCHL08sz9t3Q
	ploDp1a+GnbdbCFeGaGI9U5aNEtaydbC8lxxrYnG+aEpZvRt9QzePvwqNYh3J+uuORrn5F
	pUvbNyicoiWPH3P5UebVVR6Dj+SKYC0=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68d233bf9easo10481661a12.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182909; x=1781787709; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BD4ZiLw2q2GCJI2/AVfMMRUM2DNcD4XHKmAqREpv/88=;
        b=omEp8GTXXeM24+s9WwcYLkwvKjSzdwLD7S4tcd2kMTiKM/MH+GGC0/6zwkzTjpRx/X
         auJMhVAQB4sZ0gjA7li6frsLIHNbM4j9stoNL/uqQoDzd6gyZqLtVzS0PtA0gRxiS3qt
         65DhOMvR1My8lT61+VTrfDlEzcMDnm8GyB95ktUhQnCPNhPUrwJUScMEhpaU4LLhhvSt
         eE7KLkV1CCGTa/4SH3FXJuzLQ1hxACB2zlm+OcSU2/PekZlcD9B9pRpshGG7pQnS95vg
         iGxyG3UdH0lFYRpH+K81JMMxfnQKfhBowmrLQduZw1+2JrxHhT/Tz+w4IRVxRVo5HS+9
         kF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182909; x=1781787709;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD4ZiLw2q2GCJI2/AVfMMRUM2DNcD4XHKmAqREpv/88=;
        b=HkJGISQoX7Z+FJXpX5VczrWVkmgUK/6Y0I6GMNCtLBGCUHnvdgZRUj/Ob9m6EPyVO4
         pkxbugYuPQ3HSXf2A7cXNihxtmnbKbcX0gKvfpfQSnVjqUwloq5kbIvHbAwLHkdNVlPy
         MceLltG8IpN1/sLZ834ubW7GcrGvmB/A8TI7xISnvqFNanqb2AQdHN51x3L6XjAxHZRG
         TYvhDnUnfHt6O9HbA1DB9bUR1mfw6quHFB/k1PymfU674LLwH7u8LloXHtBmLJbeR9bc
         ChFqwjeMDT88I/yPi2peXreT2RQ0i6wB7fZUpa1qqfEwZi/eAd64mTEvpFc95c2FwuNc
         19+Q==
X-Gm-Message-State: AOJu0YywORXq9f1gvUSLEP0Ig7KiGKH5sSK5yHD8jmzUQvDt6jMigNc/
	o8R78F0audKVaD/HHajfqhDV5/cxzlnDw2jRSX1bbDsqglfO16a7FySh9bWhE5u6D4MFRRy65Pl
	buQvNQOnj1w==
X-Received: from edqo12.prod.google.com ([2002:aa7:c50c:0:b0:680:6e15:ab62])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1ed4:b0:692:4759:ac57
 with SMTP id 4fb4d7f45d1cf-6930e26599dmr1393742a12.2.1781182908431; Thu, 11
 Jun 2026 06:01:48 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:38 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-1-abarnas@google.com>
Subject: [RFC PATCH 0/6] arm64: mm: Introducing ROX CACHE to ARM64 systems
 with bbml2 no abort
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14CBB10001B
X-Stat-Signature: d11rbth6d7sekxn4963rybwoayi7cbzy
X-Rspam-User: 
X-HE-Tag: 1781182910-458336
X-HE-Meta: U2FsdGVkX18lWXz21E5CRQITJwGSC9ZAC869KjExOeCuloIjL/kfZegclKu1vWMGOslfHeFBOxKgJf4x6zP2s6PXoX/XwCMejcfiZpCdbKVkDzTcj/ugpIXejyMYyFmwOEcv+xTvVFbQxhz9tZCIXpMOTGLnPPP4vy4Nu7bBPBioTrly3Y600KnA+JaiztlECvCM6AKDt81AfJhTCn1j8O594Ry7gMTXsCZZZ3Djw0F/0xqdMM9S3m3NR1JycgDOsg/i3l+rbWDc4bBa7ZgAVxNZhr0FTibZeMNo9zDxW/k3ZkKUsWad0oBvIcweDKaNB9IOGkDvQud+pdrutpssOAVfw+5OA3Yhn0oSr35btKLgNwM/oGflZhCXTBKO6QjZ/vFwyFF+a5YmXDq33Z2uUXrAP7Agy1pU5RuI1MjwAW99eHmN/X8mwhpcRLYkv2RaSEfGUF/3XVJ7fmE6v5uRHZ9VheeMo6wX1sGGaPtR4zVAVijZOi+tPLyYa3+9+vnv1aqhuS1RBYljUq8IbDKi/16sTjJkRpqTwfVP/ulR8aUXiJam3pkyLpfz3raBq1CJVmknXrSXnY6ijBkvCWwFju/m5i0m6vjGklBBhrZQgsxmbQRe3ocQAKFbsw8eomkVXPKeEzrVe/LfsG0t1J6Cx2QCDyJdwcoO9BuzOdnPyHXx2sK3ZhsQNCvqBhOEVPLn684lEOC5l3Bu5OGjEajyyVcIRyPRZX5SLQIQ4VXQ2FgiE2VdgZshJGyzzx6ZEtx3wZyLbbis7GlAnwRLweK4+G2qNwwkEZVCAJUEgr3R+Zidjc6wSOJVmZM3wiFquvXf3WXeqvSQQWGHOnPbvYzgRTzicM9uUos+sKIPfJoQCJsxtmf6OnNqP2uL83bNcNI68dX6PLVimzNjzkfLNV05XoSbdFcZvR/cGesB0JfHow5qXm45edNUhYT6Rp3hgw9KZ2UqBPlKTEQTZKeiSEY
 IjjqQK0q
 MCI2qNQ/xz9lvvPC70bCZB6ZFrXblxtnYpnSBw94DJbSoVQJX3OXixGUCeMoOpub08N46iV+yqumeaVVUZJT17KGYBv65O7zW2s9gNAXsQgHJPZ5HnSTfBLcsMs/WSscmrDHBpOxm83c/GcQoZQ3F068PitzXCg8OnN2zf25I4p0RBIhJNUShM6i5bEy97kCdn/Aknt5GAWtpunWOtdM4orEnwoz6wC56sYqWWOkHNUlTgtDo/ym5woN3xtVK3pkjKv9373y1pdm4OHw+6RG7pljMXAGS76eAMwysbpmrSkDOtq0h4v9E4YjKUTBmy0zjQn6YgbvnfYSd95w7TdW5895q6ADniCdFDj1spozH6SnX46mScJo+O+JfnYF6TDPEZvcUEeLaKgaRsoQUPnULu8NqhIvlV0GGGGwRTvvElPw8y+MJmp+B+0+jYxlEoNiKzZ6RYsHl6kVR/HDOOJMVEfH1ktJ3Xt1WfyDBbFJO2xu7F+ur0XcPJbIEoTqf6nXGqzVGV0SmXrrNCoeHrP+I4NrR+uKRPypx5g6tdkahGvocL3d8iG0xeWgMcmpp9KY+c+614TPP+qTfMj2gCeMHgBwAUjLQ9GbT691ItKQ+TCgKf5iWqi2MtXJgkLzVUtA+PGseHPIrbWl/28+GbbOcbltvZzjayXALHPwI23uybsr2paEOD3DNVKGotsIvsP0t8Zlx+ppo4L8fGZhK8k1KveL7N+HQj8/m9Y6Z7PIoxAajL4Lt9tfKrIu5zHiGRqJM8jBj88Jgqir5hMAvvA7tV1dj5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

I would like to propose the introduction of the EXECMEM_ROX_CACHE feature
for ARM64.

When the `rodata=3Don` kernel parameter is set, all executable and read-onl=
y
aliases in the linear map are forced to be read-only. Originally, this
forced PTE-level mappings across the entire linear map, causing a
significant performance regression (greater than 10%) for some workloads
due to increased TLB miss rates and deeper page table walk.

The `feat_bbml2_no_abort` (FEAT_BBML3 in ARMv9.7) feature can be
utilized to mitigate this regression. Because we can split memory
mappings without triggering TLB conflict aborts, kernel memory permission
adjustments become possible after early boot without forcing PTE-level
mappings across the entire linear map.

However, when applying read-only permissions to kernel module section the
linear map can still became fragmented due to the scattered physical layout
of the underlying pages. To address this, EXECMEM_ROX_CACHE, which was
initially enabled on the x86 architecture [1] for this purpose, can be
used on ARM64 as well.

EXECMEM_ROX_CACHE works by preallocating PMD-sized contiguous blocks to
act as a cache for .module.text memory. These blocks are initially
poisoned and made read-only-execute (which simultaneously makes the
linear alias of this region read-only). When loading a .module.text
section into memory, the requested cache region is made RW, the bytes
are copied, and ROX permissions are restored.

To take full advantage of this approach, after restoring RO permissions
on the PMD-sized linear alias block, the PTE mappings are coalesced back
into a single PMD entry.

Testing on an Android device running 6.18 based kernel with rodata=3Don
shows an average 20% reduction of level 3 page table entries for the
linear mapping.

This implementation currently works around some limitations of the
`set_memory_xx` API, which might be relevant when considering the
refactoring proposed here [2]:

* Because the execmem_cache operates outside the linear map, its
  permissions could theoretically remain untouched (poisoned and RO)
  until the cache block is fully emptied and freed. However, we currently
  lack an API to interact exclusively with the vmalloc area (e.g., setting
  it to RW) without simultaneously setting the linear alias to RW.

* Additionally, set_direct_map_valid() has somewhat confusing semantics.
  It is used while "cleaning" a cache block (after confirming it is
  entirely empty). The linear map region should be returned to its default
  state to restore writability, but set_valid might just set the "valid"
  attribute (as is the case for ARM64, which I have temporarily addressed
  here with a workaround).

I would be glad to hear your feedback on these changes.

Best regards,
Adrian

[1]: https://lore.kernel.org/all/20241023162711.2579610-1-rppt@kernel.org/
[2]: https://lore.kernel.org/all/20260219175113.618562-1-jackmanb@google.co=
m/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Brendan Jackman <jackmanb@google.com>

--->8

Adrian Barna=C5=9B (6):
  arm64: mm: explicitly declare module and ftrace execmem regions
  arm64: mm: allow huge vmap permission adjustments with bbml2_no_abort
  arm64: mm: fix restoring linear map permissions on execmem cache clean
  arm64: mm: add helper to fill execmem with trapping instructions
  arm64: execmem: enable EXECMEM_ROX_CACHE on supported CPUs
  arm64: mm: support PMD page coalescing in the linear map

 arch/arm64/Kconfig           |  1 +
 arch/arm64/include/asm/mmu.h |  1 +
 arch/arm64/mm/init.c         | 54 +++++++++++++++++++-
 arch/arm64/mm/mmu.c          | 95 ++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/pageattr.c     | 46 +++++++++++++----
 5 files changed, 186 insertions(+), 11 deletions(-)

--
2.54.0.1136.gdb2ca164c4-goog


