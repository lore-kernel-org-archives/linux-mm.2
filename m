Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95ED8606A335
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Q+Bt6HT7
Received: by kanga.kvack.org (Postfix)
	id 825926B0483; Tue, 20 Oct 2026 07:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD096B0484; Tue, 20 Oct 2026 07:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739876B0485; Tue, 20 Oct 2026 07:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46C736B0483
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:01:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD487C012C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:01:01 +0000 (UTC)
X-FDA: 85342712322.05.A655C70
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id E12A240009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:00:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q+Bt6HT7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrKJjXfdM0MbsoostKwsM8/MNs73BD60MtEKBomI2y8=;
	b=3d7JUTETTSv2obT5vCTGkvA22GBd/uhqX4lazrWUBOPono2Ev7Lq8EX+/Rx9ZL6FsyvuaX
	bk0bHZimzPcq/sKq9kKIGDgLeZiffQV87aPqJFkYh6FncNGIlkjd5YmP3yUIlcPTWM9v9F
	uJ4tk+F6TrtmuVqlWqIGE8Tdu+N9oBk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q+Bt6HT7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494059;
	b=X6cu+1Xt/uOoucAYyyOGYXGnDX1P5Fbbch83XO+pSBA70EylEbCFkxEbqVvJEXs3S4vrjU
	lOuYewxKXDTRq6mhMWhTaQaBirDOF7kDqN7+YxegQ6UhHnKPg9Lr9G1ehwrUt1n3GvTR8w
	j6KcSiyA1mNDHqgd+tlWSGZ38sxLVAg=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c40447e25e6so355046766b.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792494058; x=1793098858; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SrKJjXfdM0MbsoostKwsM8/MNs73BD60MtEKBomI2y8=;
        b=Q+Bt6HT7ZfDjUm2nQwJR4HbqYD1CuAmjO8w2t7Z8/tVXGaRQXVBCD19lyU72eVODLl
         UnKB4rcV86fhUbTSvlkRaJ/SGriEdqkuzlo7+0izN11ccccGpWl774YHNB68drFiOfjP
         LwCZPVlDSzoyYHZuaLHExRrt1nLqmXiTCMlpo+FxhJWGXFqRSnTAZHHYNlX6wJzvJ8Ti
         sCCw0kZ34/uYee/xmbUTwhYpb9JrweWcWFFEg4q4KYbmae3SCDGHmEiDV7upJQPhWDCd
         2NNwKq5/Wt8ZzQNm1E2KyQD1f+Zn1MZFAmIf7mu5oa42p7OuUMtDSxvqW+N7APNhj5C2
         3gIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792494058; x=1793098858;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SrKJjXfdM0MbsoostKwsM8/MNs73BD60MtEKBomI2y8=;
        b=EMVo5sD3ajQNI+I29Y8L/ZjtnTQ71HTGuoIOqg/3hCzBSBYRa8B2aKV1UHCOhX5Pbu
         uJLUr/aE6soyVg1AWsGlBYtVzNLVGbHMXcc3McaeMzXIPpaJryg+10aGAE5L7EazIbcb
         IVmvyZQdYsBRRuUb0OEOP6QwThb5J2/n1m9NXMOaHnmDdA+cb1GMLsKTvVJgeNkXPway
         1L61JQ86GqMxmpBzC1Bc66+tMhNoBupIzAM7ZSl6Ut88+PaUp/gEKiz7He8qp7Qrs97W
         RkkSxYSpDGKsqZinQNFeOhgXHShx4pMH81+VnCXu4XKwa6A0dPHMMK1+62Vi67KxaoPm
         dBhw==
X-Forwarded-Encrypted: i=1; AKwUvBzxbpP3Kex/UZUOrpF7m2DjcV5/x0EZUgmllczbdsMMARZdpBifvp1ys2jndjvqQV5Yp+eIbdbj0w==@kvack.org
X-Gm-Message-State: AFq9FYJ936D+35ArvYuMW14iex+n7AZq2SlazHt5+z8P+mqNIHkyiDgT
	FqakfzLfpwB+qPRoFXEUykEhx9630oFFqkq5CJFLG3r3LOkW18k2YCVeaDGB1Pr/Hw==
X-Gm-Gg: AYBFou1oo7hKMpFsBEeil5KgkZs3r/aGUBEJI+j1j4aknm48I1rteSnNMNyu1vg3b0C
	IwtUD0p5dt0RxijFL/lhdzLNnAqU4bRcnbSl1HKTz68TOhRuVhk/0FgdVwnEC4sdi+pO93+Mg9x
	cxNs9PA5t7mI8HhAECjTAI/mZWvEmEHHUp79DC5e+hSNIelD0LgHETlz2WVfkU7inO70N0Obuqv
	UYN8xm5aDqt2SCFzueWPCAu//E05qy9A9NnudIFVfvn6xIMECA1mimcEd0oKxlU5brt7RPns0Q4
	1JXLvPHyId6ltMW7uaKxU734OMB+3vNLF+iAE8YMTkhSlCB67eKQe0p4tA20D/dsAcG07ll7Smm
	zsJy6YTlSIE7hxJtV9E+LqfZ8s0YQBR+B/IJEIPQFlJL11eIm69lYTF4qkDoqTV4UK3gSLaev+D
	fcVbIhxJE2p4B15sUIIOc3b24XXkbWjNbWatlcg7Dnkk99hVLX5j8tX7lDinJWKZJrxU4mLoq/M
	DbWCcGoOnMTM/+dp4ual6s6m1Mvi4Il2Jk/jpVZDELzX33B5w==
X-Received: by 2002:a17:906:f5aa:b0:c41:6149:cb43 with SMTP id a640c23a62f3a-c419e53f5d3mr810874066b.18.1792494057892;
        Tue, 20 Oct 2026 04:00:57 -0700 (PDT)
Received: from elver.google.com (11.26.205.35.bc.googleusercontent.com. [35.205.26.11])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40913c6145sm461656966b.41.2026.10.20.04.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:00:56 -0700 (PDT)
Date: Tue, 20 Oct 2026 11:00:52 +0000
From: Marco Elver <elver@google.com>
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 02/11] stackdepot: add caller-owned stack trace
 fetching
Message-ID: <atdJ5AbOVXS9W7Gg@elver.google.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <20260908-stackdepot-trie-v2-2-1996d5cef732@cloudflare.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-2-1996d5cef732@cloudflare.com>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspamd-Queue-Id: E12A240009
X-Rspam-User: 
X-Stat-Signature: wshnez6jib9e8jo6moxtk4jq8izgmc59
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792494059-758352
X-HE-Meta: U2FsdGVkX1/sp+Qg6ovbY34irEIH0KHDDx/UIuk9VlS3dNh+1LAwktAjNMTN01yjRKWjLOUYq7XG9pL6WVARO7gPAze+G2JlZx0OLlTBTLXgGPKxeXVLK8EC8kzvvhsKQIJCNM+kU+wzgWJL0kA2F/OExe+slLPkYGeq77IJiQCl3UoA/FW6LDRhGsgNl8PvLHu0WAFx8oZio1vkCuCVf4hIh06pJOTs00Y5rcYdPTUhUwZ/zYienH1sBerqVbCFdMusH5t3yQjPVkiwCHJyLiCLwwRpq38Vkknub5iVsJb4aDz4Z+95+zLV9uaUSL72o6iAhd1D2Ly6vNYPq2tVXZ3ueska8hPs/i1TsGnHdFfO6aRoT8xP2XIQpA9CIRonUkYROV3/O1PG4xlZ9ITZKvmCP70xp1mrWaCtz3DHu02vhIusAMIeubDe0hMoyjcdnJo9a/jUUt0kCmvxDiDejQo8Clz6YxOWtMtyo/3RGJ9cQ+jHF8kEkiB93vIex9OckA7ToA2KVfOpuu7Oaj7RlPR4PLxX5HrIYmLm+SGkdvHucxmfRtIbnEq7zLjLnErtt4DOl6vRD9T5er0+HgZYbH9FDFr+AOqlemRbzRvFxkS0QjWzva7LyWiXmOwr6etyfLLgpfLAc6Usm1sNuac26qwEpVdo1aLg7JEUf7/v6bJHfzfuNMNJY3kP9YIp61IioENr6Aa1iXhlzfddBmLMkGToLXF+JqN73CUniiYVA1U2vtAnpIjz1VugKaHNOrf1cbtDmiAgXqD8okpa6UMWPnVawnC06S8cMTBa7OYUrWB3TAwqV6Kx8wFyUbSPibxxhpTR0WiLq1zLtAifgLwl33kY/L75mbl+UX27y+0jnB/yADnh39sg22XYw8DMO063uBCRh2IvgEoJPsoQO96ysppcEAjTgziv0v7BadPtKZW/ywbS3xG4zR9yjqrurHA7wzgFazWbb4mHp481xI/
 NP2EWNVe
 gf15Wz97cvmmMCdJt7Oh1H6c6uxDf3HwQvoHCW6oqQHZyfrIUYXfpffNm5Y/w9IA0bIeGSaGFvi9PMKZ9XyT1/HaIZTwR0MWLnWjegndsyKHApenCwG6fVCKidgkcVSLTZcrhlt9uMixlDHUq8ydXzGJ1MDldVOimtyJVICiIyvatmJgeCgwUnUTFGHw7Syqnvh8gxecDGBvrCW4w+6DXnikbZTtSkvA8zxSErGVrXpoWwqyJi37JrUNLjRWSaqnqcEfPvMrREe1VJ3nCfXSKs2kgVMwEZNjOGD8uPdNU4rTqLM1rwHOTfKD6dnqk2firmIe8nioY2gM5F5Ikhe2JCMPwXm/qkYpczZhGr2e0co12D80Us6TNNRhAn5PiHl2jTogk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> From: Caleb Kan <ckan@cloudflare.com>
> 
> stack_depot_fetch() returns a pointer to contiguous storage owned by stack
> depot. That cannot work for a backend whose frames are not contiguous, so
> callers need an interface that copies the trace before they can support
> both backends.
> 
> Add stack_depot_fetch_into() to copy a complete trace into caller-owned
> storage. Leave the destination unchanged when it is too small, keep a zero
> handle as a no-op, and document that callers must keep the handle valid
> while copying it. Warn if a caller passes a NULL buffer or zero capacity
> for a valid handle instead of treating the stack as missing.
> 
> Unpoison the copied entries before returning them because
> lib/stackdepot.c is not instrumented by KMSAN. Add built-in KUnit tests for
> exact and oversized destinations, zero handles, and undersized buffers.
> Later patches add tests for stack depot internals.
> 
> Signed-off-by: Caleb Kan <ckan@cloudflare.com>
> ---
>  include/linux/stackdepot.h   | 36 ++++++++++++++++++
>  lib/Kconfig.debug            | 16 ++++++++
>  lib/stackdepot.c             | 28 ++++++++++++++
>  lib/tests/Makefile           |  1 +
>  lib/tests/stackdepot_kunit.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 170 insertions(+)
> 
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index 2cc21ffcdaf9..734529767c8a 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -199,6 +199,42 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
>  unsigned int stack_depot_fetch(depot_stack_handle_t handle,
>  			       unsigned long **entries);
>  
> +/**
> + * stack_depot_fetch_into - Fetch a stack trace into caller-owned storage
> + *
> + * @handle:	Stack depot handle
> + * @entries:	Caller-owned buffer to copy the stack trace into
> + * @max_entries:	Number of frames that fit in @entries
> + *
> + * Copies the stored frames into caller-owned @entries. If fewer frames are
> + * stored than @max_entries, only the stored frames are written and their count
> + * is returned. If more frames are stored than @max_entries, the copy is skipped
> + * entirely and 0 is returned.
> + *
> + * Passing a NULL @entries buffer or zero @max_entries for a valid @handle is
> + * invalid. Callers must provide storage for @max_entries frames.
> + *
> + * Callers should size @entries to match the save-side stack depth cap (for
> + * example, %CONFIG_STACKDEPOT_MAX_FRAMES or the local stack_trace_save() limit)
> + * when losing diagnostics on an undersized buffer would be surprising.
> + *
> + * A non-zero invalid @handle, including a post-put handle, may WARN. Its return
> + * value and copied contents are undefined because the record may have been
> + * reused for another stack.
> + *
> + * Callers must ensure @handle remains valid for the duration of this call.
> + * Persistent handles saved without %STACK_DEPOT_FLAG_GET require no extra
> + * reference; handles saved with %STACK_DEPOT_FLAG_GET require a held reference.
> + * Callers must not call stack_depot_put() on persistent handles.
> + * Racing this helper with stack_depot_put() on the same handle is invalid.
> + *
> + * Return: Number of frames copied, 0 if @handle is 0, stack depot is disabled,
> + * or @max_entries is less than the number of stored frames.
> + */
> +unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
> +				    unsigned long *entries,
> +				    unsigned int max_entries);
> +
>  /**
>   * stack_depot_print - Print a stack trace from stack depot
>   *
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 134b15a44625..fcd74edfd93a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2785,6 +2785,22 @@ config RESOURCE_KUNIT_TEST
>  
>  	  If unsure, say N.
>  
> +config STACKDEPOT_KUNIT_TEST
> +	bool "KUnit test for stack depot" if !KUNIT_ALL_TESTS
> +	depends on KUNIT=y && STACKDEPOT
> +	depends on STACKDEPOT_MAX_FRAMES >= 3
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Enable this option to test stack depot API behavior at boot.
> +	  This test is built in, so KUNIT must also be built in.
> +
> +	  KUnit tests run during boot and output the results to the debug log
> +	  in TAP format (https://testanything.org/). Only useful for kernel
> +	  developers running the KUnit test harness, and not intended for
> +	  inclusion into a production build.
> +
> +	  If unsure, say N.
> +
>  config SYSCTL_KUNIT_TEST
>  	tristate "KUnit test for sysctl" if !KUNIT_ALL_TESTS
>  	depends on KUNIT
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 90c52f2e0d3f..4da7279d9f83 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -785,6 +785,34 @@ unsigned int stack_depot_fetch(depot_stack_handle_t handle,
>  }
>  EXPORT_SYMBOL_GPL(stack_depot_fetch);
>  
> +unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
> +				    unsigned long *entries,
> +				    unsigned int max_entries)
> +{
> +	struct stack_record *stack;
> +	unsigned int nr_entries;
> +
> +	if (!handle)
> +		return 0;
> +	if (stack_depot_disabled)
> +		return 0;
> +	WARN_ON_ONCE(!entries || !max_entries);

If this triggers (e.g. entries == NULL with non-zero max_entries), it
falls through to memcpy(NULL, ...):

    if (WARN_ON_ONCE(!entries || !max_entries))
        return 0;

