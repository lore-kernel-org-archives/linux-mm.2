Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB93C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3AC8E0088; Thu, 24 Jul 2025 10:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553E38E007C; Thu, 24 Jul 2025 10:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B438E0088; Thu, 24 Jul 2025 10:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27D5E8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:13:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC2131DA790
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:13:37 +0000 (UTC)
X-FDA: 83699351274.18.2831D26
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf29.hostedemail.com (Postfix) with ESMTP id F206F120002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:13:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=pwq5tdM2;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf29.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753366416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDYBYXhi2fpIXmidMih0lla5P8/HwKyQKaeA3qjglN4=;
	b=I40TJ1zHNCMUWDBdxTo2e2gcD1UHWDAFnEvfvSp8cH46FFHWWtQKmw1erd2EyuqAK3R2he
	AQ2HzaDJ31edipExp1C5lQQv2c9bo2I1ekp346gyw8RlHRYwYzYsEsKokHanLfWN7Ce1kv
	lVA9TusUxaTM8+rSilxnRJowNWhWpzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753366416; a=rsa-sha256;
	cv=none;
	b=7o338lHQFCxsjrZySVwnSoy8atgHh70w+V7syegrk9kUN0ZScNHaPpu8s7HfB81p4lbiiJ
	vYzGcd5l3X1LFuR/GAT4xY1zWCQuJE0jmSrCFoi6LRj3IW1lLoZZONR/oUOqBXPBInDwnr
	DZ9W5hIdOv07OOVU9FdaOMmsUzUTdcw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=pwq5tdM2;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf29.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3A3B040AD2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1753366414; bh=FDYBYXhi2fpIXmidMih0lla5P8/HwKyQKaeA3qjglN4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pwq5tdM2vDY6APoBJuNEplILNdsyaU8ylKRxeCbXe8XwZITdA49KYYVSYTry8HpKV
	 11JU1pkrDwmKYTn4Fl/PSS7PRD9lEUq9GYeo/HlJaKcFNthhWNgGaSbErWZpRksXU/
	 2vcUlKH47OM35KhDFiJKYjv9eHZYQfJhlwveoisq76XE1Ph/wNujQEY4mwi+2EPI03
	 C6Ge6wReBlahOFy06igmvLpUfGmMHNmMAtE5bIWSddnTvAo8pP5gNfRizJLIkJVMoq
	 n+gO3mVS2lc+fqlOMygB0N/vI5gck9MYQxuB1GcL+iBGKHLpcflufHKZM8r4X1ng6W
	 uqNwh/ttjzzkw==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3A3B040AD2;
	Thu, 24 Jul 2025 14:13:34 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 eugen.hristev@linaro.org, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
Subject: Re: [RFC][PATCH v2 02/29] Documentation: add kmemdump
In-Reply-To: <20250724135512.518487-3-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-3-eugen.hristev@linaro.org>
Date: Thu, 24 Jul 2025 08:13:33 -0600
Message-ID: <87zfctad82.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: F206F120002
X-Stat-Signature: rhyhzg1rn7ucnfz4f4uqgreboh6erg6y
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753366415-914138
X-HE-Meta: U2FsdGVkX18FSv8oD38etj5tSaGFdQCbXnrlWW9igAeMzHZGuc7g51hQYHfhYo/J+NkMAnmP/idK+FRM3ccRiJW0+mHuZOL1pcdve0QTwmNRBK7PGkN03erBBO6uCeBoGcXATPwTugussmyoQD0j/QAXDqKANG2ZC236XOnwRr4Q0Bop5oPFCPPPu1olXbsmIum53WI8TbxDeU9j8u+H1etB9J0CnzyLAga1S+09aE4MWeGjhFlBfCo7vtbInH8mDIpaWzUQw0AFWess+OqUlulX1r+NVNEilqB78WkGQlRpPdGdU7+1acNNH/bcRzR2CbaNhIB1/cJ01hF/pZrqsLWyUgX0HQpesfTM/rlQz7lRo3/1LN6UdTJ0xTpx/52tYNNySstA4iMr5cfvCTEb0pR5Bye+0tUVX5+a51mViIRZl5FNFtb7NdUWfMoviMC2UL5MtjCxLJwrO5Pk2Q0227weE+/LOAvSQiV8rewLO+C8XQzvphMSoRueuGVAEr4t2wjzAzMA/LE4werJ4lCLqnO3uYyWz7PKECd+LXLvmv9LIuQmEqROc+SpNhW8V+t/oL35jfA33w+ldiRao0pYW4tN2UsBh+rbwrZ5cXvqd6baR6aioWLBXqQAtUISWuhnJnTs0Oj1vI4xWSZ6D0VMZH3kOHOukYcUPBlqYBx1DJWqWmg1u9giD0w9rLjf1OH+vFpGKUNHBFGbG5TpTdoQThvNbjIL8y3bioEIlBzMw3wuc71gFlM54xyEvbQb2WqVD6annH3bhI6gbyvRjdnkG29LuR78/+HKku1Qks6XBIU6S5585UPcBuKxXK8pQdOS35uYEJC2zR/TO+DAUZ1TQIandXtvVaA7X3AHf5BF7LZk2ZEEm6i7joc1PT+QivlsVwF259UPNY+XEqv62cqIKg2mopzYAlXXTZyyJeaWHS6zYSlowy06Mhc6Gb4hQU1vNlXd3j3oDIluT3LM1fV
 rVgzRo7t
 H62A57U9QVjRriiDkNMZV5mM9pqJFai4Mz9b+sNuNexk8NKyN+K86B4CCzsbwrYVvk8p4QP11jfoiRwLBL97u6bgdET1UIWmORsoFkth6uXbCdcLwD7K31cRSApPm6W0R7AU81DmnvGtvS/+svRRg9dpwQNE48IGxlAW3vrssmJdCiQKfATRRy5OFtUrxgvyR8JXe3IqiHojQLfgmYHK5ssyEsA92vAyHh3vDgTeE0zL9kWyWWAxW6sZdKOqpJIEdq3Sp3X01ix4fic9zVocn0Ql2aXKr1u/kdGxxbWBngd3i8K//HiF48SbWNN06L9gemRI0qDRY9gPELkZECcFrGHJGttcvcLdRlkI+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eugen Hristev <eugen.hristev@linaro.org> writes:

> Document the new kmemdump kernel feature.

Thanks for including documentation!

> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  Documentation/debug/index.rst    | 17 ++++++
>  Documentation/debug/kmemdump.rst | 98 ++++++++++++++++++++++++++++++++
>  MAINTAINERS                      |  1 +
>  3 files changed, 116 insertions(+)
>  create mode 100644 Documentation/debug/index.rst
>  create mode 100644 Documentation/debug/kmemdump.rst
>
> diff --git a/Documentation/debug/index.rst b/Documentation/debug/index.rst
> new file mode 100644
> index 000000000000..9a9365c62f02
> --- /dev/null
> +++ b/Documentation/debug/index.rst
> @@ -0,0 +1,17 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===
> +kmemdump
> +===
> +
> +.. toctree::
> +   :maxdepth: 1
> +
> +   kmemdump
> +
> +.. only::  subproject and html
> +
> +   Indices
> +   =======
> +
> +   * :ref:`genindex`

Please don't create a new top-level directory for just this tool - I've
been working for years to get Documentation/ under control.  This seems
best placed under Documentation/dev-tools/ ?


> diff --git a/Documentation/debug/kmemdump.rst b/Documentation/debug/kmemdump.rst
> new file mode 100644
> index 000000000000..3301abcaed7e
> --- /dev/null
> +++ b/Documentation/debug/kmemdump.rst
> @@ -0,0 +1,98 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==========================
> +kmemdump
> +==========================

A nit, but it's nicer to match the markup line lengths with the enclosed
text. 

> +This document provides information about the kmemdump feature.
> +
> +Overview
> +========
> +
> +kmemdump is a mechanism that allows any driver or producer to register a
> +chunk of memory into kmemdump, to be used at a later time for a specific
> +purpose like debugging or memory dumping.
> +
> +kmemdump allows a backend to be connected, this backend interfaces a
> +specific hardware that can debug or dump the memory registered into
> +kmemdump.
> +
> +kmemdump Internals
> +=============
> +
> +API
> +----
> +
> +A memory region is being registered with a call to `kmemdump_register` which

Please just say kmemdump_register() - that will let our carefully
written automatic markup machinery do its thing.  Among other things, it
will create a cross-reference link to the kerneldoc documentation for
this function (if any).  All function references should be written that
way. 

> +takes as parameters the ID of the region, a pointer to the virtual memory
> +start address and the size. If successful, this call returns an unique ID for
> +the allocated zone (either the requested ID or an allocated ID).
> +IDs are predefined in the kmemdump header. A second registration with the
> +same ID is not allowed, the caller needs to deregister first.
> +A dedicated NO_ID is defined, which has kmemdump allocate a new unique ID
> +for the request and return it. This case is useful with multiple dynamic
> +loop allocations where ID is not significant.
> +
> +The region would be registered with a call to `kmemdump_unregister` which
> +takes the id as a parameter.
> +
> +For dynamically allocated memory, kmemdump defines a variety of wrappers
> +on top of allocation functions which are given as parameters.
> +This makes the dynamic allocation easy to use without additional calls
> +to registration functions. However kmemdump still exposes the register API
> +for cases where it may be needed (e.g. size is not exactly known at allocation
> +time).
> +
> +For static variables, a variety of annotation macros are provided. These
> +macros will create an annotation struct inside a separate section.
> +
> +
> +Backend
> +-------
> +
> +Backend is represented by a `struct kmemdump_backend` which has to be filled

Structures, too, can be mentioned without explicit markup.

> +in by the backend driver. Further, this struct is being passed to kmemdump
> +with a `backend_register` call. `backend_unregister` will remove the backend
> +from kmemdump.
> +
> +Once a backend is being registered, all previously registered regions are
> +being sent to the backend for registration.
> +
> +When the backend is being removed, all regions are being first deregistered
> +from the backend.
> +
> +kmemdump will request the backend to register a region with `register_region`
> +call, and deregister a region with `unregister_region` call. These two
> +functions are mandatory to be provided by a backend at registration time.
> +
> +Data structures
> +---------------
> +
> +`struct kmemdump_backend` represents the kmemdump backend and it has two
> +function pointers, one called `register_region` and the other
> +`unregister_region`.
> +There is a default backend that does a no-op that is initially registered
> +and is registered back if the current working backend is being removed.

Rather than this sort of handwavy description, why not just use the
kerneldoc comments you have written for this structure?

> +The regions are being stored in a simple fixed size array. It avoids
> +memory allocation overhead. This is not performance critical nor does
> +allocating a few hundred entries create a memory consumption problem.
> +
> +The static variables registered into kmemdump are being annotated into
> +a dedicated `.kemdump` memory section. This is then walked by kmemdump
> +at a later time and each variable is registered.
> +
> +kmemdump Initialization
> +------------------
> +
> +After system boots, kmemdump will be ready to accept region registration
> +from producer drivers. Even if the backend may not be registered yet,
> +there is a default no-op backend that is registered. At any time the backend
> +can be changed with a real backend in which case all regions are being
> +registered to the new backend.
> +
> +backend functionality
> +-----------------
> +
> +kmemdump backend can keep it's own list of regions and use the specific
> +hardware available to dump the memory regions or use them for debugging.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e8da575025c..ef0ffdfaf3de 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13620,6 +13620,7 @@ F:	drivers/iio/accel/kionix-kx022a*
>  KMEMDUMP
>  M:	Eugen Hristev <eugen.hristev@linaro.org>
>  S:	Maintained
> +F:	Documentation/debug/kmemdump.rst
>  F:	drivers/debug/kmemdump.c
>  F:	include/linux/kmemdump.h

Thanks,

jon

