Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2B1C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5A56B00A2; Mon,  7 Sep 2026 06:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78256B00A3; Mon,  7 Sep 2026 06:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65B46B00A4; Mon,  7 Sep 2026 06:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5DB6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:54:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6C17C0111
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:54:28 +0000 (UTC)
X-FDA: 85186657416.22.77D5D54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EEDE40004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:54:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G7/0KQt1";
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOGW6/wWy7KCmoBtQtZTuis7xY50X7nU3u2PLYPpIC8=;
	b=Ar/3T+0ufJ6lpB+3VMvlH9dugO9yMoc/od7Y7pFqdnKVHKRZv/P5PcsQmdym6Uae/fzNUO
	aF4yr9Uee9z6P+addVq7OifHLp05nZwKNC07DIS1PXL1IakxuJQsylMdZZDZ0qHgqG1BRa
	Ej/23Jx/jhlLBRLbo5vK5YBhGc+pkiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778467;
	b=ryqDydecRL3U2xvUZuNB1l2r6XoHqE120v8rIDHJ3yovIyRyy5SiwMpr1o8z2PAH6ZncYO
	qAuAzdsk5mLv2V7X6PZqHELgh87YZSgC7rByFtqhxudPGX8vvPu7tJqEBpdOQHLacjVcYG
	Jw6UypxjQt/DVQwT/Ab9Cm86kcphZe4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G7/0KQt1";
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A95AA42B6E;
	Mon,  7 Sep 2026 10:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EAC1F00AC4;
	Mon,  7 Sep 2026 10:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788778465;
	bh=NOGW6/wWy7KCmoBtQtZTuis7xY50X7nU3u2PLYPpIC8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=G7/0KQt1Skmof7ZpkUnZkQDRlafhOO12XFsIOYKQpAZmnVWs9cA5biIbNGPPuXDzW
	 zsWIjohT+04Z7RKrQ4HzEy5BU3ZOMwvrWuBqgfNP1+E/sppYgegCHuaVVral3FOlD7
	 E+BJ3cZ1lOKjnuBo7hq5B+GmYNIA2vRgOiSdaWPEUUmRfgH9LhJoq/xjGrXd8iQxIp
	 0QLHHyb+1PCWt6wcujYQIYJHuxuOw+/3VdqprBCgXm18Ni37snzH3Dcs9NHuc/UdDL
	 gPqtso0FJZynaI1csR5E/lOdWBfyYv0v+WaIOpjWESgWiFg2UzIYKaqr8ob0R4FU0r
	 J5L9r8Wo6IEgw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC v9 01/25] mm: Introduce kpkeys
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
In-Reply-To: <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
Date: Mon, 07 Sep 2026 13:54:14 +0300
Message-Id: <178877845406.3691569.6930315020588094755.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 9g84y9rqcffkaui8rqwhecjqted167kk
X-Rspamd-Queue-Id: 2EEDE40004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788778467-787327
X-HE-Meta: U2FsdGVkX1/oeJ3Ugy219au01d+NVKqjR28DSTupilsHQ5UHKGNM54O7rtWEFGdGGfo5jzAtCBf9vMJZytdx9+6itLR0JB3/diDII0mFM07jC3BITsA88b5IGPWi3XpstwHyNv05XZX4xrsiDTkdFlfKTPNUEhOjCZ7+fePQcZZ40mbpp7a3J7tZGgNBEyh53bV/jMOHGSsbIKDrix+7eADov7kT0e68U6CeFU5FZnnjmkqVDhhPBFfIqtd8TKVyRt67BX5w4BWbv3/8F5cZSjBc0DiEkvOviIKnWjwCwaRzIOUGjTcon3aUZP3f7BfAXy8Ism+/v/svV/eWZjcvcgO7blZVNkZFzBjVeEpWBxOn3+0pJmOXiyz9zTsZPte4S+Vi+kPqMPNNh+jbNUITkBSKqTUZbZni4yjhJpMN7gQQslSJXjzEfjAqQnYOuM5UT7JRuFbL/dF/tEh83kf55PyRii4DuLzqt0kTuEn2ub/Td6ito6Jvp+Mkz7LEmdbYkzW3vH5QdW8bXA2/lB9imODjEJHPyFtaAf8rWvQ3sG75G6Ie6MqlzlDWAgmcI96SoecildkqFYZGR+R7f9WbuTOdSB2RtFYXGIGBSFk+/Lq1/1+mN7CiihoVJjVGtM5eM29SVOZVGXxPiorb7PRVT7jm3QeD33A+QXW+xz2q1v6UqoBJZHWixxUloGwIvGvpd/bwankQofYW2I/IwBv2zZKvfg8OpTM2cFb3blFZ6ktpGTC+svaEoepIlUuQNSErUh4229ejN5yjRRMJfPxRzh+wSQeoT8IaHEIB8zk5mSIUgKosJffGmtgqAtiP9yB8cl7eEtKH5EsJZgK1dCHgX3m+97DmlfpxugH1uZ6ScXdRkgJzxsxfhPdIlV9n+E/tb8BvNZFn6n4JHgaqQCd9xmN2HCDawdbcdJXGg6qLp4LIdn4yMvS1JmFp22FqyPSWGhLnViFsiwRl5dMnsEL
 2BZV09BP
 QnXfdNd0sj9iCCVgeHDuJgZEac97BwwTyOp1bJ2p2n5YcvoqVCecA3t/MaEWLgSJtKoN2HQVawi3S9xcLyOfc2vvoF0DNKcl0KCEXfSZfL6khjTXK5rKbyo192CZKg3XSNXwLg0ZLR2kObom/MplrphBjj3y0FzYRKz70pBCm+oF7U5FXq3ystGc4y+NdaXzN5VH9es3nkiiNuq0u4yXiE1q+ulYkUh4TSWWYR+pZpAOuGLlkY+VSY/3bjk0vu8T1Q92Xymsb08D2m8Otr7Ud519px6Jo2JczIEi0R0gfcFldLSwhm7LeJcMQs72QDcy8wYfR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

> kpkeys is a simple framework to enable the use of protection keys
> (pkeys) to harden the kernel itself. This patch introduces the basic
> API in <linux/kpkeys.h>: a couple of functions to enter/leave a
> kpkeys context and macros to define guard objects.
> 
> kpkeys introduces a new concept on top of pkeys: the kpkeys context.
> Each context is associated with a set of permissions for the pkeys
> managed by the kpkeys framework. kpkeys_enter_context(ctx) sets
> those permissions according to ctx, and returns the original kpkeys
> state (typically the arch-specific pkeys register) that is later
> restored by calling kpkeys_leave_context(). To start with, only
> KPKEYS_CTX_DEFAULT is available, which is meant to grant RW access
> to KPKEYS_PKEY_DEFAULT (i.e. all memory since this is the only
> available pkey for now).
> 
> The underlying representation of each kpkeys context is entirely
> architecture-specific. Support for kpkeys must be explicitly
> indicated by selecting ARCH_HAS_KPKEYS and defining the following
> functions in <asm/kpkeys.h>:
> 
> * arch_kpkeys_enter_context()
> * arch_kpkeys_leave_context()
> * arch_supports_kpkeys()
> 
> Additionally, <asm/kpkeys_types.h> must define struct arch_kpkeys_state,
> which typically provides storage for the pkeys register.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>
> diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
> new file mode 100644
> index 0000000000000..eac522f552141
> --- /dev/null
> +++ b/include/linux/kpkeys.h
> @@ -0,0 +1,104 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _LINUX_KPKEYS_H
> +#define _LINUX_KPKEYS_H
> +
> +#include <linux/bug.h>
> +#include <linux/cleanup.h>
> +#include <linux/kpkeys_types.h>
> +
> +/**
> + * KPKEYS_GUARD_NOOP() - define a guard type that does nothing

Nit: I'd suggest to drop "define" from all the descriptions, they would
read better without it IMHO.

-- 
Sincerely yours,
Mike.


