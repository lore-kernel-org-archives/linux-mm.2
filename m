Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA75606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PuBG7HdK
Received: by kanga.kvack.org (Postfix)
	id D591C6B05B0; Sat, 14 Nov 2026 13:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09C26B05B1; Sat, 14 Nov 2026 13:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8E06B05B2; Sat, 14 Nov 2026 13:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2F86B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:58:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D0C9A7FB5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:09 +0000 (UTC)
X-FDA: 85434634698.12.75AF5B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E47781C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuBG7HdK;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682688;
	b=fdtOLMWIzaX0HbzbwWO8s2N0IO8vkDFApsZHhGa1iWQM4PnmK78eJAr4LlDeV4mhGk6fj8
	JgU/ZGl8dzx5gza+gEkYhOofHEEEWG51BIzEXvwoJFagZEErMTgGvZeW9L6ZQOTkSpVGnI
	AFDxACorF50tfjQg1DvqvGrA6UlXSkE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuBG7HdK;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCMrrOGAhmQQGZtD+G6uTS3x2wdtgxcClnp2b9KxvJ8=;
	b=DOewfqp0Ftzmfddi+J37MgwEgCBh1spjCbErlTfE/Qr/hlO4ZBhPccvmUlRZZ+DCYoKz+d
	7HIv4zcJIdUEmfZwikeU4L6VGjAwVh9VpsQoBBNgI5Cba9mjXrN9kMkrPyMe0lBbB6+b+Z
	+S9OcTXrF0iJOsTGNfBJYDBT1tUKR58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 630C260E15;
	Sat, 14 Nov 2026 18:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F80D1F000C4;
	Sat, 14 Nov 2026 18:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682687;
	bh=TCMrrOGAhmQQGZtD+G6uTS3x2wdtgxcClnp2b9KxvJ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PuBG7HdKinIjZRpi1N/v0OEkeMKy+DK9ABxTnStO/11VBC14LI3GcEwLDn50ERad4
	 bu4a+sQujB/FY6xzYimHIVqRU5g4U22f90BBM+3ydoN3ohCbZ+CYyh+Ct7ANXEV5JY
	 3Z80IbjzKFbEkifiDMwLjzoFJcvqJUB78IoQrSzxf4KaafwIgifS5ZXB2fJybN2oyD
	 x5M9zn2qFf1/k1vM8YtEljkO7tpOmN2GitcWEt3vrsZ9vv/7ADmMtyglTQZVa4DZSL
	 yaYHmc4xWHXptue9+LZBj1em3jcMqhyG/DxaIXSZ1PXONUZCSC0bUGW8rKOP43/AqB
	 EQHgvqmWHliZw==
Message-ID: <sashiko-outbox-214929@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/10] stackdepot: add architecture hooks for compact
 frame storage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matt Fleming" <matt@readmodwrite.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Marco
 Elver" <elver@google.com>
Cc: "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Oscar Salvador" <osalvador@suse.de>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Caleb Kan" <ckan@cloudflare.com>, "Caleb Kan" <calebkan1106@gmail.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com, kernel-team@cloudflare.com, "Matt
 Fleming" <mfleming@cloudflare.com>
In-Reply-To: <20261113185702.1332171-9-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
 <20261113185702.1332171-9-matt@readmodwrite.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 18:58:05 +0000
X-Stat-Signature: 65bwpb8jwmz13qzypw7fqfzowcgcqwko
X-Rspamd-Queue-Id: E47781C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794682687-872806
X-HE-Meta: U2FsdGVkX19AzyYaW+ZUJjUulOpTTC0sFs7Cxo+kRUWo623uMrSgD+4+1QW0s6KqBUupvH8/a2QTgkkUhiXgzgRW7tkH3u487fa2F3tFzA12cjmTMRDZKGEGDaQ3/Rvh/bN7CwyXItHIMI94M0Tf7IdjApTRgJIOmMEkaUuNemOO1nvRpAvPZLLgK+KQqlP619GU3ppai/6/2ToWs2E1aX7uCNMQIFaUawWssSCEBrX76uIMEakjB27YcEigNf3NwOYgGbD4XylQxXxl92TbbXmLCzx2d/NmrqnZJPFKqpIc/ReMaQs1GO4ZScrsip0+gIjE+ek6TLJGraqUId6A+5ezp6ryEhARnf27j9kf2UElTCLrfAtqZOUpjBqdqNuuix+I1K+NQrEYzUnL5hfJgrBlXkHzdzs80ZuaxSE/gjaT5I3s2vRKiaf5uIpOPQ+hpG20piaVrCOtUX38OFV9quswCifdGxsuo9pAE++UeLOpPjwlKHNncZjm5vBjlZKikUfi6TZarDSh4Ti/W6YtkTK2tYmzBDAgQz5YZaXOhKs5T34VDJ7zH/MfDB/fcIQH5EDdWellUQVtQHAjIygjeWRmMUabAvapyi1z9rrbBEpzak80PoH5du+XRnLy80UMPg/TSQgdnsF7xYfaFRyD6eoKmDQX5vYhAAfFmV7ZiSxFt/oOvIkRuHdC8CmdCjvJSnD/UrB9co+L2WAciAD0lnoRH8Qn7ZyFJfiG6oCw+ckn8ESXuDSgBibT/VRDakNzOBNp0aHD7B0d0VKbXbc4ZNzLumMv9E+AsXglpkQA3GsvmQLkObgwk0/jd9Cg/PqC7jc0uRwJ+yISAdB1tmV53XpPMDuZgmL31xttmZj1uDG1AgVjnaja3Bbtctepb6+l+puwltB6RnrCPo+r+HzcGRLnrUwYj7TM0JXCrRuMAM7gLVWa/DidETG6E3HOWQP2x5w6N9G07EEuJxZQzbU
 +LlUBokc
 8gP/tgc6Rp3Fyr3pJYabNHo9EvrZaYjpgDpAXTjV0hFPCKMbi+6fuSMFL13dc2M/CD2f1bgRJ4T6ahqkUJj6ZecS2tZEI/V/9Hcnq2Jfj1hFFULPNndcX4gGxVHONzxFQHU8vtzYPowOffeZV4rrRq5GixiVLOTs1hV14TnEsZT5pXFRU2dlYmAjf/e1wfS5fPfo/eUd5jDklRSwmntFX+JMh+w84h290IiLXm1Rt0rnEMc3Y5EynkZhZ7kZDzf0xQHgZ7IThk+wH61LRCafRpBLf1RgIybDKSgA7MK5Wk4EVSO8x3DMT9HVdt0mAJXT3u0NEH3C+qFjWwv9iGbJ+QIfw1VEUmld4m/b6Jrcs9DMJwH/SNCG78E1Bq09HkNNM1dIIDJNYaGXw6dmm/YtKBKE8BKZ6v11fDFQwN4qJEr2kL+g4qMGvNWl5nOxU6ahbYqlOjS4Ini4WwpgyecJcptZ338wLbA+wUglKniR1kakKgaYlnF22MvBbz+VLhJoL+tF8l0nwxGV4t+NyYsxVlAf8X8JxWbuPKFc0MWVReuQz/GTgQQlQft986T4KmbeWWQJ7pxcYDG95QoiwyEafru5nghFKIiso8mK8U6F5HoDJ5SNFS/SNqyCXIa3czLf1ZYJaK9Q5KheqtlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] stackdepot: uninitialized frame in
  arch_stack_depot_frame_decompress()
--

commit 29af5949877efb1954b766cd936a7c6ac5d5fb21
Author: Caleb Kan <ckan@cloudflare.com>

stackdepot: add architecture hooks for compact frame storage

This commit introduces architecture hooks for compressing and decompressing
stack depot frames into 32-bit payloads on arm64 and x86-64, with a generic
no-op fallback for other architectures.

> diff --git a/include/asm-generic/stackdepot.h b/include/asm-generic/stack=
depot.h
> new file mode 100644
> index 0000000000000..846975767bdd4
> --- /dev/null
> +++ b/include/asm-generic/stackdepot.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_GENERIC_STACKDEPOT_H
> +#define __ASM_GENERIC_STACKDEPOT_H
> +
> +#include <linux/types.h>
> +
> +static inline bool
> +arch_stack_depot_frame_try_compress(unsigned long frame, u32 *low)
> +{
> +	return false;
> +}
> +
> +static inline void
> +arch_stack_depot_frame_decompress(u32 low, unsigned long *frame)
> +{
> +	/* Generic code never compresses frames, so this hook is unreachable. */
> +}

[Severity: High]
Does leaving *frame untouched here cause uninitialized-variable warnings
when callers pass an uninitialized local to
arch_stack_depot_frame_decompress()?

When commit "stackdepot: Store compressed frames in stack records" wires
this into depot_stack_entry(), it declares an uninitialized local frame,
calls arch_stack_depot_frame_decompress(..., &frame) when
stack->flags & STACK_RECORD_COMPRESSED is set, and returns frame.  On
architectures using this generic header, the compiler cannot tell that
STACK_RECORD_COMPRESSED is never set at runtime, so inlining the empty body
leaves frame uninitialized and breaks the build under -Wuninitialized /
-Wmaybe-uninitialized.  Setting *frame =3D 0 (or calling unreachable()) wou=
ld
avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185702.1332=
171-1-matt@readmodwrite.com?part=3D8

