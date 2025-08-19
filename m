Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B436BCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9226B00A0; Tue, 19 Aug 2025 19:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0B16B00A1; Tue, 19 Aug 2025 19:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D66A6B00A3; Tue, 19 Aug 2025 19:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16DE16B00A0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:52:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E4D3B7DE0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:52:04 +0000 (UTC)
X-FDA: 83795157768.21.86A0426
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8A52BA0004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:52:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AQaPyHNe;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755647522;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwii5vDRk2HqFHoEzFvdXjLh8+HDGIvx8Kia2Hy7yd4=;
	b=wLNAFPWsfnGieEi2Y+kBR85GdPS745FOMLOq0EjPVip1NnpGE6TxXnGE09rg347ikqUQkZ
	7s26YuxpGjlmnaY131m9t42OXFCV1YPcIEuwpEvNZUo//SZ5YaHErUxt/d2w/0WNKhAD/z
	kzMzlYDlWd1+5uAgnqzzPCCYSN9f37w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755647522; a=rsa-sha256;
	cv=none;
	b=uGs6MNla8lcdzylDWhnzo8w9S5WEa027Y73EW5LYDZUDQ5flgU4ehuOi5+fm14gJpwIgNw
	hTrImht+DvTSLi8rsCsYVf7DC1R6nikBXxRv16G3oWRcG1c7hpV2+r3SLvnMpFKGn40MLc
	e3rZVgSKy2cuHfb8P6BE4siXU4DDdRI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AQaPyHNe;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b690517so8835674a12.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755647521; x=1756252321; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwii5vDRk2HqFHoEzFvdXjLh8+HDGIvx8Kia2Hy7yd4=;
        b=AQaPyHNeGy0wFv+zoibeuFpL1YeoSzVOVXpayonXim+rSaP5w3jHJBkLZZ6tnkYWNG
         EEeyGSnaGkxGmBBWWMH2eg6oSLg3LTTqaJWqftZgvZu9m5wE9hHcFryf5sQ4orZg79/4
         j/RnNC7Y7awvMvPuixrACOXI5V7rx225+rBPWAbhJXRR4gmnONrGhfI5hZ6T8g6Au21Y
         K9mZgcx23nDYHSs+p0tXTWg/kIJc8ioVCH93EbJnPR7K6Up1MleWuOyvk7wbWzq3ptXp
         VMqSC1G9XXC1q+GZ3jkKiWk20HDnd/rB9GJVvwv4m1Ri/QNRhb2GH0V+d7ZZrndq0zni
         CAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647521; x=1756252321;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hwii5vDRk2HqFHoEzFvdXjLh8+HDGIvx8Kia2Hy7yd4=;
        b=sbUQGx/wPfILKBr3nBULsKZkKuGTGTDxN35FT2Tx+oGLkK3kLw3ScUhw6USkyhi6L9
         j8jtuu1r4ItHwtQpsTWNY7eYQMlp7zTW7eofYAUSxf1iPH1cf+r7NNN5Dcy9atDBLXk+
         rOn9Q9DsDLREyy0OExzxLin9UxHiKewOfL6iVpoqrvfhAlcqt5Kx1qo0C99V9RN+KanN
         Fi/64u8yEUQL9U8riy1SRM1xZlBTAlMc6PHjqYFPNeoGRBPN2aapuDf1CvffYpcOZkCS
         sry/ovZVGzkTaVQdBwtqM8MJYHgJWsaHylV6FJf8PvP1UFN3Ow7cSrXxRTr+HN75ROkC
         Dz/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWGMnf9+oNlVCaNkbYJvmh8M08/x8iK4b1Se8ucAvM2GAi8eb9Wg6mXy6xCQsFii5ENUkuPsO5kZw==@kvack.org
X-Gm-Message-State: AOJu0Ywl4Ls0XDRvy9OUPRb+K9bayY2Lcd7ev0dbE37ZUbYWXD1nPLCg
	tVzo4p2x1PBqtsxRDlKV2/egNsFZ9pL/jmOrvTnR/LyCj5ElsCKPmZ0g
X-Gm-Gg: ASbGncs1xg6yB9M9mFEbEsrvTQVLde9xK/p21cT4eoLqIwtvU+GCsHi4vJ4oJ35u25r
	/4y3lTKmQhjOIucKgjEBJ7cjOV6wldhxAQK59ktE42ArMT2NnF3TKFi797SZj4SxsaVUCULXuVH
	yvZawlWMHI+O5nzSKMccaXPcQxYxAu9ORJ0s2ct5ZcAbfaOjrx5PI2uFX5uvDDxrYmufmrWmu3B
	wNXy8zuok+/solU0a/Jg9Un7zeooUTwXwTGL69P5mOggsTc3Tcn8Stm8+XxXhouTQV4RaJ+V2ZG
	BiXPZum6sppueITHPVSm74BuSxmISx2kjwJzmkeozgPOAIk2JVNzDXnXlrdWVopUi+DU1nDqi8I
	vA/ZcIqsC0SyoDwGzQqDU0Q==
X-Google-Smtp-Source: AGHT+IHTWjAGjinh9nzHsJKsD5xLXBZISMysB5cDMytuX+CmFt7hFCd0FeBDXqTTZwWuSeECM1i6ww==
X-Received: by 2002:a05:6402:51d4:b0:61a:9385:c781 with SMTP id 4fb4d7f45d1cf-61a975e5b9bmr669786a12.38.1755647520722;
        Tue, 19 Aug 2025 16:52:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61a758c062bsm2574102a12.55.2025.08.19.16.51.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 16:51:59 -0700 (PDT)
Date: Tue, 19 Aug 2025 23:51:58 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in
 deferred_grow_zone()
Message-ID: <20250819235158.mgei7l4yraheech4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-2-rppt@kernel.org>
 <20250819095223.ckjdsii4gc6u4nec@master>
 <aKRX9iIe8h9fFi9v@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKRX9iIe8h9fFi9v@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A52BA0004
X-Stat-Signature: 1auidwd83zxu5etery14r7r8br46eh8t
X-Rspam-User: 
X-HE-Tag: 1755647522-546468
X-HE-Meta: U2FsdGVkX18G6kAOPcvYHuPKCboO/EMlVIR0EJrnnogNDMF3AE4P2ZJz2fWzY4cyypBa6KyOVmI28fGomts8ZfrQoAEROp/OxM5CmdlvyBcyMP8wcQipXDZfu60zMHn0DpwTjVnAYR6psvDRNYTx6JIYxL1vjRoTyssrTLNPsi3WNoczvx4qnDGEyMd+BcqFst20V+pEFW6sdMjVcy2W5/oILaLN0PNLnFXQ7rwoR3ND81PK3mm1cbh7X8uwcyrKIAvi/6WM2oNX8B1lk0wUoa9+8f6Apoz+ZBeoR98pRwRjNjTRUGnSJx4R8iwh3XCpoeG+rLmYUUs6adMMFQ5HAQMjVNMoUhnHJf7rxBA5PNocfAwWofDVtdkz29ZvLvUN/yvuSlVyPe4i8B83bZy8q//DACghrxnNh87OyofbsghTFcan96GPYoXQxgS676uaFSf2q994jz9qPU6DV9PqVsejCDv053hAe3o3Sqrjrpv6X2KxonTJQTsidg8/KyENI43V9OLbIh13O+LzICbdCirUzK4rLq/lgHkpl23QFd6DKqlP+UyLSPmZnIuVYUoczZbz4vk+OW/dtzr4JXN28f7wT9GHOqsHKdlBsM/Ds2ApvEBDxY07eCR9v8ksCKvBDnrQNY4fC7yIjE8Tr61msZf/4y311AYwoO5DBHdGN6djKMXtzUBGfLHWbtUvV/pXULuZ0poM+JKU1RCF8uwWoiL/QLUXVHIZhWIYQYwmrFr/tWQeJTdVmQ3xZ38TgAr8PKyRO59QzonYPrSLjV+TCAvd9aOmIcCAAlwomH1xrKoXW4227v6520XHZVKQvkH/BRmYgcHPynWH/5/sGB3lfkBzQjx/Xb0CHWA+ug1L4oBbvAqNRhwG+etPBEwdDjHIJcD8x1f5im92COX6rY8YX+AOWsQlTv5OD8nbcRauFmBWTaF7C7pO56TMCwR+TFsCt3h8obpn2lNPrlaJfvt
 GtPTuWHz
 zLQr5pB6PMDdxPF/mqM/zXHhAiTOJzV57vus1c8bC7J1ViaPybWvIwjXbUZN5ZZH/0+dHNKrNY7r1jb9C2p5Y8kJKTD9sNVUrp2gM1APAQpvyd4ieAT6s1pqIvFLdqcaRBHqMAEBs6emre8jYLQI06t/vpU6+tmiPXtZZ+33EVOOeRMz+fwzdzAkqAZE5hZwFTptEAULCzg/DEgiAjVLqlMmboL3Zny4Q36k4VaY24G+ve39moMzlF1qMPXa4tr+eP46Oh1BQZcu0aGKW7DrsDIv+GrYQzCN5cKPgrbgTi+QP38M4aDW0ehOigd8XS25bR9yoGQfBbmh8kG0MX2UUCC/FXYIv08QfxZeUxdjK2SGCuFJmp3eAGOlczWUSpj9LMjLDP7BO4dWLvoKItrjiK0PRE6tSUp2V/utrf9cnAH4ZO3Ywpv9vIZm+VbGCxlA7+sF7Ef7NMFOJO3elTvELEU6TGBtYHprbiC/cYi9yIUflxrOm/BZ8FaPijQuLZjkJBL07W7BFjRBw5GL6HUUN5aWtZ2KXxMmRpAZBxY3nabXMgp+VbUcne6zNx4PNgq09lKLY7HeCB4xXlkNMaJPW2AIUDS4i9EcWloNhUW9iICV3WD5r2JLZVJwYuesh1FzELVGKJxRY5uLbGDQf38m0vHwj4CC87F1yVq8fd9DtrV3Zm6V1oK8yQTKKE5Ar5ilmbJxC5eg/OM4mkFX/f3CzxSFBSI5XnhZRf9LhQFOBlpFa4idJhqEbnvBKKzOwu1LWJvr/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 01:54:46PM +0300, Mike Rapoport wrote:
>On Tue, Aug 19, 2025 at 09:52:23AM +0000, Wei Yang wrote:
>> Hi, Mike
>> 
>> After going through the code again, I have some trivial thoughts to discuss
>> with you. If not right, please let me know.
>> 
>> On Mon, Aug 18, 2025 at 09:46:12AM +0300, Mike Rapoport wrote:
>> [...]
>> > bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
>> > {
>> >-	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
>> >+	unsigned long nr_pages_needed = SECTION_ALIGN_UP(1 << order);
>> > 	pg_data_t *pgdat = zone->zone_pgdat;
>> > 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
>> > 	unsigned long spfn, epfn, flags;
>> > 	unsigned long nr_pages = 0;
>> >-	u64 i = 0;
>> > 
>> > 	/* Only the last zone may have deferred pages */
>> > 	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
>> >@@ -2262,37 +2272,26 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
>> > 		return true;
>> > 	}
>> 
>> In the file above this line, there is a compare between first_deferred_pfn and
>> its original value after grab pgdat_resize_lock.
>
>Do you mean this one:
>
>	if (first_deferred_pfn != pgdat->first_deferred_pfn) {
>		pgdat_resize_unlock(pgdat, &flags);
>		return true;
>	}
> 

Yes.

I am thinking something like this:

 	if (first_deferred_pfn != pgdat->first_deferred_pfn || 
	    first_deferred_pfn == ULONG_MAX)

This means

  * someone else has grow zone before we grab the lock
  * or the whole zone has already been initialized

>> I am thinking to compare first_deferred_pfn with ULONG_MAX, as it compared in
>> deferred_init_memmap(). This indicate this zone has already been initialized
>> totally.
>
>It may be another CPU ran deferred_grow_zone() and won the race for resize
>lock. Then pgdat->first_deferred_pfn will be larger than
>first_deferred_pfn, but still not entire zone would be initialized.
> 
>> Current code guard this by spfn < zone_end_pfn(zone). Maybe a check ahead
>> would be more clear?
>
>Not sure I follow you here. The check that we don't pass zone_end_pfn is
>inside the loop for every section we initialize.
> 

In case the zone has been initialized totally, first_deferred_pfn = ULONG_MAX.

Then we come to the loop with initial state:

    spfn = ULONG_MAX
    epfn = 0 (which is wrap around)

And loop condition check (spfn < zone_end_pfn(zone)) is false, so the loop is
skipped. This is how we handle a fully initialized zone now.

Would this be a little un-common?

>> > 
>> >-	/* If the zone is empty somebody else may have cleared out the zone */
>> >-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
>> >-						 first_deferred_pfn)) {
>> >-		pgdat->first_deferred_pfn = ULONG_MAX;
>> >-		pgdat_resize_unlock(pgdat, &flags);
>> >-		/* Retry only once. */
>> >-		return first_deferred_pfn != ULONG_MAX;
>> >+	/*
>> >+	 * Initialize at least nr_pages_needed in section chunks.
>> >+	 * If a section has less free memory than nr_pages_needed, the next
>> >+	 * section will be also initalized.

Nit, one typo here. s/initalized/initialized/

>> >+	 * Note, that it still does not guarantee that allocation of order can
>> >+	 * be satisfied if the sections are fragmented because of memblock
>> >+	 * allocations.
>> >+	 */
>> >+	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);

-- 
Wei Yang
Help you, Help me

