Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B59CFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 00:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E466B0023; Fri, 21 Nov 2025 19:30:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3EC16B0026; Fri, 21 Nov 2025 19:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D506B002A; Fri, 21 Nov 2025 19:30:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDBF6B0023
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:30:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EF1E89819
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:30:46 +0000 (UTC)
X-FDA: 84136362492.04.71F1FA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC715120008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:30:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RXNhbq0i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763771444; a=rsa-sha256;
	cv=none;
	b=nQST7haCz6nDDilUy3wE4Ou1SK+m3veetp/GfHP8471li+NRz1SjSMTTvUdMerEPmi6awX
	PxtlbclIaNMQIQDxqRZoFBxZUaQFkfvLiuJq0JLhxulTrm4FBzaRrhkXdVRlz0MKKfHrlX
	GQVseALPyLJXpEI1NZ4lPU9OiY+1+LI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RXNhbq0i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763771444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caPpzwgFJCpIRNcWVPdH/CQvo8SKA+31Tzw9iIc6zug=;
	b=akVzirYaQjr+jRUS8uqV+CyYR8OICsKE8t8bqX4NCeLcavYdiYhueHsiATqPB8FMiKbCVA
	5VKOr/dRvSVjWP+5PxOxl/2Ru1cVmQnUzaLfkyuRFffT/sPklJs3iE4HPs/pmGNi4iP9gS
	tTB+RzXwQXPr3HWcmhaxmQopQ4uocRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 490B560172;
	Sat, 22 Nov 2025 00:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BC8C4CEF1;
	Sat, 22 Nov 2025 00:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763771443;
	bh=HrtqBDzf+I3rKg+UOEYgJj3ACzu3sah0DecsWx8zL74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RXNhbq0iFJqvm+8e+PfetKLRUs0dvxWyh4wKv1MUYoYDttoC19RFCdiculI5ThaBF
	 wY+KhdoV1023JPv5UQPO8/Jb7HJmkkgB+PI0fhqxOm1yKcXQBI/vBE0KVCu2yru5gR
	 x0wqamHVgXXGR9VZNOiO+xAigOLeYN7WkLZmlSiuaRdO23ovq/h4waRwZRwuHqch7v
	 RaAmQ+anT2MyJ53JD5y/DZlMlAsuOBKE53ahGW5iYhq6bGBdh8m/qvndDiGFN4lICe
	 6FOf7Vqrd5CVI0Dts/dPCadwR34Ag6tqIJfAnX8qv9vPz6KTwaOz8IM/pMd+El12Ph
	 dmf1eGGDJFVSw==
Date: Fri, 21 Nov 2025 16:30:43 -0800
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Uros Bizjak <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with
 __counted_by_ptr
Message-ID: <202511211525.05CB7E1AEC@keescook>
References: <20251121193957.1655580-1-morbo@google.com>
 <20251121193957.1655580-3-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121193957.1655580-3-morbo@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC715120008
X-Stat-Signature: f73zy6wq451t347j6nbxk3rqtcszamig
X-HE-Tag: 1763771444-598188
X-HE-Meta: U2FsdGVkX18kSsRYneSVHKwctL0lYySGMCiwBx+ayK8XLizcGsLbJCBiI+dtRN9nS8jXLgf5nMqNeAgeYmHVbTIAMYXW42KnuPy5mEVHJBdCE88qCpp3UUvwNfiXke/C/joG8YhBzTF7UlDZhFX+Ko0tsO/OAmGFDL5p6WNv4+/z1CWA8aRIw3QZ7wBqM9onNG9vhXmZjy6I4qYXtHGrcFfrIgDNgm9YJqjZnESfHvLukywM+R8YrbMoVF3qZgmHt+H0YuDzLCVO7nYFJkwgSMuPKO0XN1MhUZViDFZ4GtG+haJryxZb/1bDMUf0F3wKKcNyNNU6ABEPlvJBmU3tpCddYyG9GEXfObytwPQYS4nFIKpxvdr4XS//8hos5XzlQLhbMbGhbnZzJlic/+dMab3th6CXffTJcC1ItKkTErU6IY1e8Bihuu0Z6JYz3hb58ekpRz64k0ikDFwNeMZvs7dYAS9t6nZNU0w91RuksKlx+lE0YEisv3H6DQWplcZ9juTP7bgyiN75k8hmXC8t5p9rgAy35RiDiTAp8lK0gjmSuYkv1P5O2G1XZnTG+xD+sdQtvcvnZAZDuVrZrCEQadEm4kxHezK3UWfj36qAHv6gqd7xX4FLKDp5kcHFpJAA76vpsbnXZoJsbghDhW+2jNyWfR5N/qPLCWYSe7i1MtsQiJ+wEOg4maw+s4NduGdg+MOFy+2xxUOrYYktexrWLikmW48fA+WO6yWTbEdT+SI09kRokDgi58byJuDpEjHqv3w7mEnKCO0yHpEsAUu5puJdI/lyEHpiM9W3BZhKLcYklAeI5JoLBWkbLXIihP0NsQTnkUG0Bt84qcodUpaxrsBEbNmJMMoirVJv2xCfr923aT1r+HelWufbopinhFa1EJ4yUr5HXFV7a/TFLDOp7ldeetLO41zNwR023MKv0WS2DUgH9wUy4Y9mOyfFM0qv0HUAumAODPl/m0QQAm+
 uqCfVjXn
 EvUuCM2krCCBeatiMgoVWr8Lo+GsGk8b+3wgIZAg8CtlDNEvg0A4mxaFmCSDSHRjTEvr07EpiS1G3AxUobCWp/22qfkXkvW0X6bA20XLzVRSRhTSrjplz23w88oQzg6qXlmOY2JNSSTwISbg+BbxksZPiRmKb8lKtz9JBQxoo5d/V06uGRkJ8EmFj03tuektMjQm3TjRlNGEpg/as2+kHFcAPH2Jjeb+dIvh8//hRcScdf3YpktE7nTh6SmSb2tnrt/slI0ZxaIYsJ6sjsRIWz+02TEN1YfhkqZdHNeFnWiW+WWfO4AhgD298ZPRcd1Flxu1U9A9wMOq2NsjiJxdLl3qwfzNIS/tjaLlnfd7ZPJjpJJc1bb3rE0s0GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> Add the '__counted_by_ptr' attribute to the 'regions' field of 'struct
> memblock_type'. The 'regions' field is an array of 'struct
> memblock_region' and its size is tracked by the 'max' field, which
> represents the total number of allocated regions.

As part of any counted_by annotation patch, there needs to be discussion
in the commit log about how it's been shown to be a safe annotation
to make. e.g. in this case, if all allocations of "regions" have a
corresponding "max" assignment, etc. If just "git grep" can't find them
all, using something like Coccinelle or CodeQL to search for struct
memblock_type::regions assignments can work.

Here's what I used in the past for flexible arrays, but it was slow
due to Coccinelle needing --recursive-includes to see the structs,
but should be adaptable for counted_by on pointers:

@flex_match@
identifier STRUCT, COUNTED, ARRAY;
type COUNTED_TYPE, ARRAY_TYPE;
attribute name __counted_by;
@@

        struct STRUCT {
                ...
                COUNTED_TYPE COUNTED;
                ...
                ARRAY_TYPE ARRAY[] __counted_by(COUNTED);
        };

@missed_counted_assignment@
identifier flex_match.STRUCT;
struct STRUCT *P;
identifier flex_match.COUNTED;
identifier flex_match.ARRAY;
identifier ALLOC =~ ".*alloc.*";
@@

        P = ALLOC(...);
        ... when != P->COUNTED
*       P->ARRAY


> This annotation allows the Kernel Address Sanitizer (KASAN) to detect
> out-of-bounds accesses to the 'regions' array.

I think you mean UBSan here (and CONFIG_FORTIFY_SOURCE)?

> ---
>  include/linux/memblock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 221118b5a16e..ba7f7c999a45 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -91,7 +91,7 @@ struct memblock_type {
>  	unsigned long cnt;
>  	unsigned long max;
>  	phys_addr_t total_size;
> -	struct memblock_region *regions;
> +	struct memblock_region *regions __counted_by_ptr(max);
>  	char *name;
>  };

For the handful of places I spot checked, yeah, it looks like a nice
annotation.

-Kees

-- 
Kees Cook

