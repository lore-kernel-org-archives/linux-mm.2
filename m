Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D9B0D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D106B0433; Tue, 20 Jan 2026 10:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A666B0434; Tue, 20 Jan 2026 10:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950D06B0435; Tue, 20 Jan 2026 10:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8646F6B0433
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:10:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B8A11AF548
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:10:12 +0000 (UTC)
X-FDA: 84352677864.26.1D9C7E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 773431C0011
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:10:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfGHLI45;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768921810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqjEZVVpEWVpvNsRDimy5H0O4JUtkAM1U7A7eHcD2eI=;
	b=4zLJ3JpCL7nDbqb+zEiFm8pf7q9UG36WXgtZNomJ3g55QsU3e4To96oj1xvwkHvHXDCInD
	isKFkg4z44F7t1dtTE7ey2S+l/xDqjjTiJ2vs21cCJqmi4kHMBeQ55GCTQ3ynf8R+XVKJd
	wI8Nc9osmzZ1Mrwy9TsGjz2peEYUKek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768921810; a=rsa-sha256;
	cv=none;
	b=yO7TXd3A1SBJFookDPX15bj91avT0vzGg9MtPET5Og+rpMsmQ5TAiPyRB3+GZYXxAeF2oQ
	egEP3vJEy2LNMRw5qg+8F3xYmHlQdZZcPF2NFWKsMdGcGzxesnpZNC7wOqWQYuepbGsQWQ
	eM3qlIQ/YSO5UQayUYFX15qpff9TDp0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfGHLI45;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AD4160018;
	Tue, 20 Jan 2026 15:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66953C16AAE;
	Tue, 20 Jan 2026 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768921809;
	bh=oZZE0N+eBzoJVtvYCEh6PCsNcP68xQvWg7NAAt/aY4A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NfGHLI45keW1oS6vBkgEIO9GCPODJHiejXbFWjBkYXTa7lCQEhDMG+rFsNRnDa1c5
	 WlQuGK9Juf4eWvh7ID25y0EiEKtjfISl/eF3p3aWTDO1OkyptIRm6CAV3QFQCzqhvs
	 6Qj9ZTw4gVI7jh7FaInMwjIaqYxzUJAH0nSd9JZ06g0UveLNxRInRXwhmGvJix+djJ
	 ocjjG/YHQxDUC55tVn4EAM+YV4dp+unGxRBiKqYSxA9x2UuWXP+n2PMMA1W9uJXeB9
	 pvSSISbUERSf8ie+ZxEaSwlgAVQp4hvZzmsEr8kvRcyYW1keLvA3lhtU2isgrICOPP
	 mrhGRknlXuaWQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,  rppt@kernel.org,
  graf@amazon.com,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  ricardo.neri-calderon@linux.intel.com,  kernel-team@meta.com
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
In-Reply-To: <z2lraqiivexvfvokff4gmqyvbpswmfwhbkhv4u7lo3nnnyz346@mibnt7dkrvey>
	(Breno Leitao's message of "Mon, 19 Jan 2026 10:54:09 -0800")
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
	<jixxiqeajngwox3nh2u3pwf2rivhmqxxmpyttqxu32pixshyde@4jdn5jvg5hvk>
	<2vxzo6mt7cl3.fsf@kernel.org>
	<z2lraqiivexvfvokff4gmqyvbpswmfwhbkhv4u7lo3nnnyz346@mibnt7dkrvey>
Date: Tue, 20 Jan 2026 15:10:05 +0000
Message-ID: <2vxzzf68e2wi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 773431C0011
X-Rspam-User: 
X-Stat-Signature: ez3csx1yp1yd7erfp8js3ug1tajk68id
X-HE-Tag: 1768921810-233391
X-HE-Meta: U2FsdGVkX1+kd9r7x4znpe5fPKug1y6bgq9G9KcYNjodXetqlyB3ykCcTrKWQqu22YP7zRqxbnMTpL3FQhog763JG/vH8WNRBFxVw9q8fX/zpWPJvDmFtxtb6ztP3ArPoy99tUAxa25YBaPvRqjYIVwUFKqNVJvieAxKmRIhd/xzHRGW0SQMCN0aHWOVv6wt5+WeL742PsD+4QfZ6l406rt2/eUVZws79A76LE3gOF4UUE+b++JLesgVtLaAgro3YxS172VjO+YFgngjG2+X40Wwy/jJ1F218yXWEzhOv2R8qJM1Mv03u5luHSKhRc5THw4bQWhFD+Q7zEopQTVMMAOrEL3Yv7+iZDHUgvcBKhW/RkyUM1FVHOl93CxgnII+NTl2sm1EqOycTbtR/6xCF9de9mq+tQpIxbnADKt/iTXlsYGdLJ2lLvvoYxGBntYe1Ap+nMCrtLQyZewZ8/uxY1/DEWLQhElCmumVjWFDBfnfXYcjzYba4T/FGuJ8t9RKtcgpqQEGnDL/CEIbfgAobtGA/HSyV6YyFoLyXxIFzseL1jrB4hzv/55eSQUUCNLVXoZh3LhbMarb71qEhdPDPYC+Fx08aQdDk6InWlQP1xLzDXy1p5c2fabzj4Qyey2+qKAl0jLUk9/MYRt9O+Gbr0p9Y0+l3z/xfN6M8B7XbBgJRZflBrNPM+kLwUPKfXD09Oxwbr5St1ke2LM9T3oRIUE98GheSQUkXK/qHnNEF+ycXrQr2AZljFIR7R8FqDIsIXT297QgTV6a4uOj3b9HIkciDBZPe3w880VAt/CbHT9CcV971FZJgDhqdSiQXSJHs/+GhiFggXAr5S18J/m/34TmOKNsdjO3TvF1FeyiW7IrLRzjONHo3yczKWJ5p2JW+0wk6bCFrNsMISzwuz3Ywk7VkQITTwzT7n+EWKhvY9ZvjkcnWq5SAJiIwCRAiLxEPAJj44quQjysBpxOZYd
 zsnoR6Jj
 tmoNmywyk0+OMwa7gjaR6cOpSMsf6RJoClb4j5WyuhMPKwC3Olc4K630RCxussPSL71Wx6nuPWIdl7ztMZM+fLJqHVWb8dWZBVuP8KA1Ifb3iQb0amrrXTtfnsJu3O4LKIzhX8JFIRBy7PO1MYg1IaItuwZ/vYZAGP7TJYcGjclIURz6HEhnXUE8CEl70qy7qzI7MqPpQXJW6z67mjbnxFFkgLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19 2026, Breno Leitao wrote:

> On Fri, Jan 16, 2026 at 04:21:28PM +0000, Pratyush Yadav wrote:
>> > On Tue, Dec 23, 2025 at 09:01:40AM -0500, Pasha Tatashin wrote:
>> >> If the previous kernel enabled KHO but did not call kho_finalize()
>> >> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
>> >> the 'preserved-memory-map' property in the FDT remains empty/zero.
>> >> 
>> >> Previously, kho_populate() would succeed regardless of the memory map's
>> >> state, reserving the incoming scratch regions in memblock. However,
>> >> kho_memory_init() would later fail to deserialize the empty map. By that
>> >> time, the scratch regions were already registered, leading to partial
>> >> initialization and subsequent list corruption (freeing scratch area
>> >> twice) during kho_init().
>> >
>> > While trying my new patchset [0] on top of this patch, I got the
>> > following issue:
>> >
>> > 	[    0.000000] KHO: disabling KHO revival: -2
>> >
>> > Trying to solve it, I come up with a change in kho_get_mem_map_phys() to
>> > distinguish no memory and error, see the patch attached later.
>> >
>> > This is what I used to test [0] on top of linux-next. Is this useful?
>> >
>> > Link: https://lore.kernel.org/all/20260108-kho-v3-1-b1d6b7a89342@debian.org/ [0]
>> >
>> > thanks
>> > --breno
>> >
>> > commit 5d7855fede8110d74942e1b67056ba589a1cb54a
>> > Author: Breno Leitao <leitao@debian.org>
>> > Date:   Thu Jan 8 07:44:08 2026 -0800
>> >
>> >     kho: allow KHO to work when no memory is preserved
>> >     
>> >     Fix KHO initialization failing when no memory pages were preserved by
>> >     the previous kernel.
>> >     
>> >     Commit eda79a683a0a ("kho: validate preserved memory map during
>> >     population") introduced kho_get_mem_map_phys() which returns the physical
>> >     address of the preserved memory map directly as its return value. The
>> >     caller then validates it with:
>> >     
>> >         mem_map_phys = kho_get_mem_map_phys(fdt);
>> >         if (!mem_map_phys) {
>> >             err = -ENOENT;
>> >             goto out;
>> >         }
>> >     
>> >     This creates an ambiguity: physical address 0 is used both as an error
>> >     indicator (property missing/malformed) and as a valid value (property
>> >     exists with value 0, meaning no memory was preserved).
>> >     
>> >     "No memory preserved" is a legitimate state. KHO provides features beyond
>> >     memory page preservation, such as previous kernel version tracking and
>> >     kexec count tracking. When the previous kernel enables KHO but doesn't
>> >     preserve any memory pages, it sets 'preserved-memory-map' to 0. This is
>> >     semantically different from "KHO not initialized" - it means "KHO is
>> >     active, there's just nothing in the memory map."
>> 
>> This isn't true. If you hand over _any_ state, you will at least need
>> the KHO FDT. And the KHO FDT is preserved memory (see the
>> kho_alloc_preserve() call in kho_init()). So I don't see how you can
>> ever have valid KHO with no memory.
>> 
>> mem_map_phys _can_ be 0, but only when KHO was enabled but not used. And
>> that is of course also a valid use case.
>
> Oh, I was not finalizing KHO, and in commit e1c3bfd091f363c1
> ("kho: validate preserved memory map during population") started to fail this
> on purpose.
>
> So, I understand we want to fail if mem_map_phys = 0, but thn FDT was properly
> passed (how is it possible)? I know I can read
> KHO_PROP_PREVIOUS_RELEASE/KHO_PROP_PREVIOUS_RELEASE from the fdt, even when
> mem_map_phys is 0.

See commit d7255959b69a ("kho: allow kexec load before KHO
finalization") for more of an explanation of why this is done.

The FDT is always handed over because when the KHO image is set up, we
don't know if KHO will actually be used. On the next boot, it is
discarded if KHO was not finalized (that is, mem_map_phys == 0) since it
won't contain any memory to hand over.

Since you had the previous release in the FDT itself, you were able to
read it. If you move to subtrees as I suggested, then it would stop
working.

The KHO FDT is special in a way. We access it _before_ going into
scratch-only mode, and until then we just have to hope nobody
over-writes that (which is unlikely in early boot anyway). So it is safe
to use the contents of the FDT itself to signal if we have any useful
KHO state to hand over.

-- 
Regards,
Pratyush Yadav

