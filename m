Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0F460A2612
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uXfvdinD
Received: by kanga.kvack.org (Postfix)
	id 79D8F6B0493; Tue, 20 Oct 2026 07:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DAF6B0494; Tue, 20 Oct 2026 07:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663686B0495; Tue, 20 Oct 2026 07:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF776B0493
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:11:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C506C1C0A21
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:11:32 +0000 (UTC)
X-FDA: 85342738824.25.65FEC24
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id E34EA20006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:11:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXfvdinD;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggEXMwLsYCLMlRFbTt+v08PermoODsbkyiROOo7B4QE=;
	b=PNmv1ZqzYa6jnfj3FbPgAvpb5yjH2lfcGhAGupV4ZMeKXrBlSArD2dRjlatP++b1VMhd6b
	GzzR0Jys8NNNMPyPV12lyiPCadWUSM7oeRZGYAd4ynVR+72N/muJ53FYwaRuIL1FZ9hMXJ
	sW6rW/LwvYi0Ud0xIXWs19AMOJn5UqM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXfvdinD;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494690;
	b=tr+2HfMeV2xQvoQJemBE/XOc2eSfr93tSfRLlDIIepnCNL8DgJ0dyV+RkBYwc1m9D8OCVd
	Nxn0X9mqDJsIOkMxGeQG8vY/SF1LLSkzKa3Omo8Ki/wH0f0/ALOvZxCyF1rxrGw73zdfPC
	Q4p1tYkjMu+meEcfZcE0NdTcFgB+4YU=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so23950775e9.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792494689; x=1793099489; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ggEXMwLsYCLMlRFbTt+v08PermoODsbkyiROOo7B4QE=;
        b=uXfvdinDoPQKTP9rV4spqE/FYedT23XKuko9H7j8LmUdxsqAnREi+7Ja9mjP2OKYF3
         Vd0h0rpvlLSgLwLXeQZRgmYMRu0JTR7bkBdvALay0iA5INsGuAm7/YqV8XK4qTBSlPiF
         ZAGIc8x7ghAGrAkvh/8pHROf4CxXSuFBYgzx3VhEIApRZ/vfEu2oIzuPtjS32V0IUn/T
         GXM/sHGkbGzHzUp2h0uCZ5SiV3LEUimqTTCUQtTbYJR8KpF+9sCiKC/2s8fzEQ0LVNbJ
         dS+pGoyxsqunWK4ZL/9kLqLzxMZchFFTHzgB7CJuOgJi3d3ujI/NUviskPLWhffo2xGD
         xoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792494689; x=1793099489;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ggEXMwLsYCLMlRFbTt+v08PermoODsbkyiROOo7B4QE=;
        b=fJo2WDJOeV4epbDJCQMekZiMLsv7LsPQSgAffU/rg/Dfb/5LxdZ5YNGI+IReBD/h1x
         MNSLFe0J/y3+Xi8CFuMoGiJjlR8LIwncuDpbfU9voWVP+BIFAV8LXaAhVFcRz+jhdfk6
         oAVDyjFrER9UWr+aSyI2LCH0NQQmbY0zPA3CfyLNjMSBh6gLGuXkPWMBuH8GoGycX8lI
         saZxyHpDeNMIY0/xfyoCPqnqAIB8jXunFlGdTuWypRlQzrSsUde7C964bN54cmEC6bhg
         iCuwXDG8zj94yFUSUkMfkaDgj3zeWVAAakMadUNXDhFwOhR8gSHnSX70h0Su80paJzAB
         S9Dg==
X-Forwarded-Encrypted: i=1; AKwUvBw9NwDb6WcHNCebLso8KiRkloVrg9dLZstjrB6nDdLOl38rsee+52e2OiuVoX7ySyzh2aLm4yw2cw==@kvack.org
X-Gm-Message-State: AFq9FYIH+G8zlj016dbZW4CBll3f47a1WAFDiMmvwtUPZHONaMcCCBS0
	jiwg/bD6QYebW8DXqFXHq/4UJVfxTLuXXdUDVbpcMYV1jn70seKaYKWCH//+cysNsg==
X-Gm-Gg: AYBFou3A9WB2jzTkufuB74q846JyKWZ0ELS93fGWawGExU9g5oMgE47BA/dxhpzg17w
	Ab4xciPgV1N9w6VnP1VH/F0OqqygWPtlsCIGxpWqCvJhqzh1Xcx1zqICDeMvlxzODZwiLAQxuMV
	4UQjufAqDE0ec4M9K6jJQaQyG9+i6/uJvF0WyD74C+VvtTbcZVN7Yv16CjwupWaSTFC9U0V7y4H
	iCvpF8mvoNj/LCezt2GE5+ejRU2UG0Xa4k2EgbLOg/0HffM+pefKLcVRRtFNnlW73LlYvvl/VH/
	DrtY6dRFlY98h90rzstnQ0zF6SNULtwbuGk06Ddy2itebp7B0sUKnAh/R663Ti2fHoPeUJqAhrN
	pKv9It7yavV337c3BNzNdQfB1FkmB9elTwbGgWDGLCRMgI6hDXrVH0H9ggXurpZgC4k5LHW41Bj
	0TDfo91Fv3PnoVQtmpf0unP2ldMGWLuVpo9Ehocdjinh8Iw1o8ewhmRyFemKOFu6OVcLO1U9Z3R
	1cbE9t/n1zMeusFg3r7+zDy8o/4y9iCpgE/xos=
X-Received: by 2002:a05:600c:a112:b0:4a1:96cd:2f73 with SMTP id 5b1f17b1804b1-4a1d75aa9e8mr173055685e9.1.1792494688776;
        Tue, 20 Oct 2026 04:11:28 -0700 (PDT)
Received: from elver.google.com (11.26.205.35.bc.googleusercontent.com. [35.205.26.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d818d61sm5313367f8f.31.2026.10.20.04.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:11:27 -0700 (PDT)
Date: Tue, 20 Oct 2026 11:11:24 +0000
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
Subject: Re: [PATCH RFC v2 03/11] mm/page_owner: preserve accounting with
 countable stack depot records
Message-ID: <atdMXELJWveehYmX@elver.google.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <20260908-stackdepot-trie-v2-3-1996d5cef732@cloudflare.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-3-1996d5cef732@cloudflare.com>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E34EA20006
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6y4xae3pmkihmjuqw6ewnj1fafdqaaft
X-HE-Tag: 1792494690-217794
X-HE-Meta: U2FsdGVkX19RELu94hwEV3OaGbI+weXk8bIG1Ge5JcTkrKy7vwcPvwoh7Zr7hf5IEMrfqHeQmPYj7mG4SF5sPry547EwY6zYnvsKyeAwaZUJclvuFHxyGRK2n5rl3wRjpF+x4N+U65O8Vn7AVpM51VX3srCwBmfogsBFqH1/MzNg1OxmKyCvY5KWLGRsdege0OBcye1xdTeRQy+A/6TlMabYUOMKNCnr/aFJxzlXBY44d11kVRyZM2SXNyMgBxoMDqjwyIaz/frToWiGJNIGuZwz8Ypvc0gZdCGl0p1SkE9v8g+AS//PSBZnpBmRFhdxBl9bG8Rgxss3/Jsuoj43EvDTblsJiOZ8Dggpj/Yebdk1qZ1kjxjusPgwYvcgpov6GGwMJyHVqQF4w2N5QoWZ9lpXgjM7SwUy9mh12ln4gSsHfu90r+tdtG2FChwmacyY2rQNmECbeVgSYYHgqME/cMb3Cet8yDMkOP8CcZ4K9tOUifQMgU0EC3IpcHud4sqEMXs4Y/xb38RfcDJVI3VXEWD600rpcnFrf4CW28psag7ZuwFUwDqoD/c/2Xhe/blFSo3/1GNTI7VuvrvCUg3TqGxo1dNtvM9+RyxAerB/f5tbbuiFOVuSFdSZdKIYFIyR6/2IAyplJs7QKsHROtaXfWhxACV2qp6jApsihfK1GQuxN63a192tnaVJjAC1eilQxIu+uyKxYlyzmX2ZXQsazce9WQpwPGDchPgykujS3xEs52Qkinnj8NUjmgRVeJYuFR5u/JG9JY8+83Ghg/QxPK0Cj9d6HHtS7TVSHJGf2A/3hE0sM4gU6yiYHOPCQ51LK2xVKGwbUWzs5W0P53t8TsA3o2iFRfRUYINUa/d8bkD6w7um+V/ADRuawBFutUDorAYQDoHE7EopBRcSS7Xsto0FGxE6qv9XrmcWd7C5LciD7PZS1R5iI84BkzPadJFLkSOOpqBTjSnKdl+EDqh
 xGZHheub
 lw63XLlC9aKW6cdvFd1wS3c8XtmCmsh8qB0bWSrL4giaDHAk/iV3wMLatsBS5cplH5yi07vnPh0CZK35Kt7RD4wpgvVG7BViz7b6enuItYjq7RwRmKK72XADtdx2u7koJv9UpgiuVj6M/7x+V5ZwYR8b/bIqZMK24ujM9n7YB5r/Tx14LSuc8Kf53aYraHnSPS7rX4nvBpI7XjM166soXoCiNRzlQnlrAD22ds8XbCUGBY1+tpAlsTDub+qrdhS5KtVaNNAcNjhWHb+VQEu+C7ojG3X7Ov8n1T3nlTf4HIYUOGTqMue8HRPWKKd3gteHxCEsEneMW9pMv63tGdPmwTukd6QxOdYP5sC5q85iaJkTtzPk5Avdkgddua4aPa6EMdrwZcKOkA3Pw3xBB6ovtY7Mr9s/G5bMcys1Zeuj/EdF3d6Y=
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
> page_owner keeps stable struct stack_record pointers in its stack list.
> It uses each record's count with a one-count bias to track live base pages
> and reads the stored entries directly. A later patch adds a trie backend,
> which provides neither a flat record layout nor an independent count field.
> 
> Add STACK_DEPOT_FLAG_COUNTABLE to keep these records on the hash backend
> and deduplicate them separately from all non-countable records. Store the
> discriminator in a new u16 flags field and narrow size to u16. This keeps
> the record header size unchanged while covering the configured maximum of
> 256 frames. Do not otherwise split hash-table deduplication: ordinary and
> GET saves can continue to share records. Make COUNTABLE mutually exclusive
> with GET because the two flags assign incompatible meanings to the record
> count. Reject countable records in stack_depot_put() and require COUNTABLE
> in __stack_depot_get_stack_record().
> 
> Mark both page_owner save sites countable so its existing accounting and
> reporting continue to use stable hash records. Extend the KUnit coverage to
> verify direct-record access and isolation between countable and
> non-countable records.
> 
> Signed-off-by: Caleb Kan <ckan@cloudflare.com>
> ---
>  include/linux/stackdepot.h   | 28 +++++++++++++++-------
>  lib/Kconfig.debug            |  3 ++-
>  lib/stackdepot.c             | 20 +++++++++++++++-
>  lib/tests/stackdepot_kunit.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
>  mm/page_owner.c              |  6 +++--
>  5 files changed, 100 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index 734529767c8a..7ff67c70d727 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -53,7 +53,8 @@ union handle_parts {
>  struct stack_record {
>  	struct list_head hash_list;	/* Links in the hash table */
>  	u32 hash;			/* Hash in hash table */
> -	u32 size;			/* Number of stored frames */
> +	u16 size;			/* Number of stored frames */
> +	u16 flags;
>  	union handle_parts handle;	/* Constant after initialization */
>  	refcount_t count;
>  	union {
> @@ -84,8 +85,9 @@ typedef u32 depot_flags_t;
>   */
>  #define STACK_DEPOT_FLAG_CAN_ALLOC	((depot_flags_t)0x0001)
>  #define STACK_DEPOT_FLAG_GET		((depot_flags_t)0x0002)
> +#define STACK_DEPOT_FLAG_COUNTABLE	((depot_flags_t)0x0004)
>  
> -#define STACK_DEPOT_FLAGS_NUM	2
> +#define STACK_DEPOT_FLAGS_NUM	3
>  #define STACK_DEPOT_FLAGS_MASK	((depot_flags_t)((1 << STACK_DEPOT_FLAGS_NUM) - 1))
>  
>  /*
> @@ -144,6 +146,11 @@ static inline int stack_depot_early_init(void)	{ return 0; }
>   * Users of this flag must also call stack_depot_put() when keeping the stack
>   * trace is no longer required to avoid overflowing the refcount.
>   *
> + * If STACK_DEPOT_FLAG_COUNTABLE is set in @depot_flags, stack depot stores the
> + * stack in hash-backed storage for callers that need direct stack_record count
> + * access. This flag does not imply %STACK_DEPOT_FLAG_CAN_ALLOC and is mutually
> + * exclusive with %STACK_DEPOT_FLAG_GET.
> + *
>   * If the provided stack trace comes from the interrupt context, only the part
>   * up to the interrupt entry is saved.
>   *
> @@ -178,11 +185,12 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
>  				      unsigned int nr_entries, gfp_t alloc_flags);
>  
>  /**
> - * __stack_depot_get_stack_record - Get a pointer to a stack_record struct
> + * __stack_depot_get_stack_record - Get a hash-backed stack record
>   *
>   * @handle: Stack depot handle
>   *
> - * This function is only for internal purposes.
> + * This function is only for internal purposes. @handle must have been saved
> + * with %STACK_DEPOT_FLAG_COUNTABLE.
>   *
>   * Return: Returns a pointer to a stack_record struct
>   */
> @@ -260,10 +268,14 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
>   *
>   * @handle:	Stack depot handle returned from stack_depot_save()
>   *
> - * The stack trace is evicted from stack depot once all references to it have
> - * been dropped (once the number of stack_depot_evict() calls matches the
> - * number of stack_depot_save_flags() calls with STACK_DEPOT_FLAG_GET set for
> - * this stack trace).
> + * Drop a reference acquired by stack_depot_save_flags() with
> + * %STACK_DEPOT_FLAG_GET. Calling this for a handle saved without
> + * %STACK_DEPOT_FLAG_GET is invalid; persistent handles are owned by stack depot
> + * for the lifetime of the system.
> + *
> + * The stack trace is evicted once the number of stack_depot_put() calls matches
> + * the number of successful stack_depot_save_flags() calls with
> + * %STACK_DEPOT_FLAG_GET for this stack trace.
>   */
>  void stack_depot_put(depot_stack_handle_t handle);
>  
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index fcd74edfd93a..3a78c67b6b36 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2792,7 +2792,8 @@ config STACKDEPOT_KUNIT_TEST
>  	default KUNIT_ALL_TESTS
>  	help
>  	  Enable this option to test stack depot API behavior at boot.
> -	  This test is built in, so KUNIT must also be built in.
> +	  This test is built in because it exercises internal, non-exported
> +	  stack depot helpers, so KUNIT must also be built in.
>  
>  	  KUnit tests run during boot and output the results to the debug log
>  	  in TAP format (https://testanything.org/). Only useful for kernel
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 4da7279d9f83..66c5e8594566 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -94,6 +94,7 @@ static const char *const counter_names[] = {
>  	[DEPOT_COUNTER_PERSIST_BYTES]	= "persistent_bytes",
>  };
>  static_assert(ARRAY_SIZE(counter_names) == DEPOT_COUNTER_COUNT);
> +static_assert(CONFIG_STACKDEPOT_MAX_FRAMES <= U16_MAX);
>  
>  static int __init disable_stack_depot(char *str)
>  {
> @@ -467,6 +468,7 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
>  	/* Save the stack trace. */
>  	stack->hash = hash;
>  	stack->size = nr_entries;
> +	stack->flags = flags & STACK_DEPOT_FLAG_COUNTABLE;
>  	/* stack->handle is already filled in by depot_pop_free_pool(). */
>  	memcpy(stack->entries, entries, flex_array_size(stack, entries, nr_entries));
>  
> @@ -609,6 +611,9 @@ static inline struct stack_record *find_stack(struct list_head *bucket,
>  	list_for_each_entry_rcu(stack, bucket, hash_list) {
>  		if (stack->hash != hash || stack->size != size)
>  			continue;
> +		/* Page owner countable records have a distinct count lifetime. */
> +		if ((stack->flags ^ flags) & STACK_DEPOT_FLAG_COUNTABLE)
> +			continue;

This splits hash deduplication unconditionally even when
stackdepot.trie_enabled=0 (the default), and even for page_owner's
free_handle traces (__reset_page_owner()), which never touch
stack_record->count. Prior to this patch, persistent hash records had
refcount_set(&stack->count, REFCOUNT_SATURATED) and page_owner safely
overwrote it with its 1-biased page count while still sharing records
with non-GET callers.

The interface looks error-prone to me.

