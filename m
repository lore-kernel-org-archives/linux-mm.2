Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA57CCD98F8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 02:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952626B0005; Fri, 19 Jun 2026 22:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9025B6B008A; Fri, 19 Jun 2026 22:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1DA6B008C; Fri, 19 Jun 2026 22:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4935C6B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:14:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7A334060A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:13:59 +0000 (UTC)
X-FDA: 84898670598.18.6F90A12
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id BA3EA80007
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:13:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KoKsBETL;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781921637;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzIFxEJgw7O2jE+Y6+ZWgYeDKhaH241gll1Dl1i0MD0=;
	b=u0I12Vx0LSghYaZe0uRT6XPCcOaEn7769dbANU9a2+b7HQ8q5Vqm7L8872HtEJMNDr3zo+
	H2CMK+tBNk1A5nSJofgLDWS/L4T0AWP928KWOv1HPnu0iixB4CkDS1dXEd6CyvX9/vvqKx
	8S04giEOKXryoZPZEBX7BMjOcRRJGMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781921637;
	b=OhvoU1S7/Xp13NMNGDUtSPrEvgUmwUosGbAzmtAvZc+sZz6uro8a9GzILSTjpb38kaBECH
	UO396Di1VhLpqwFMcEP99MRNzlhywGynCqcaIpgGxtFfM2WpB7coTgC1JA+mAvaoD/iar4
	aSM2mMfkKkHu0fpZiktvPDv17tEjes4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KoKsBETL;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c0868ca8738so262106766b.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781921636; x=1782526436; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzIFxEJgw7O2jE+Y6+ZWgYeDKhaH241gll1Dl1i0MD0=;
        b=KoKsBETL8bskRQY+Yt9s9BeMO85eYnmLSVEavbdThD1ATidj+q7dMSGaqOIMIYEE0R
         +0M8TFW1+oC0xsTwhtP9Kvfy1g3YL8MmZc120THnWuAuCP/O41HwyQdduu7GGlRgbzjF
         tXGED4mZhbOIlyEDNePrkRETV0qsr7CL2U4xv77C4Qjc9sKNgl9kUbM+pdc8lGX4dtWI
         QKyh6KcIObu1uqaW7+7n8IMlSBw2O9vMOdceBvXem0mCX/ADGWTWz+K5ANjIo+qJ27Cr
         FnlQAI0pEsZVUNTA3uBIivtcHO9TECId850bxf8Cj7d4lNq9OlyLGVvCzWfxUxm1f+0e
         12uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781921636; x=1782526436;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzIFxEJgw7O2jE+Y6+ZWgYeDKhaH241gll1Dl1i0MD0=;
        b=ZO2o6s5kF/roP2c6akjLCW1YTvjNzUr2zGWbZGluskkzHAP9YxVlpaSU8M2MU4wTBA
         oalJU6wyNwaDI050lSfUwFvgK/BbLNE/Q6nM15jv2G5CF5fgIekNGfa41pwcWlwtwOUB
         iiBEY96od9DTRLGsFvv4LWEgLwvdkQdjddP4RN+4Ju5b7pKTDnZenPofCrfeo4APpETJ
         yd12FKMf1lTkYsqCI5ILvHeAaC4xG+yO8QALEVCDGhq22x/kHYuvfevb9eQHXJ5Utc+w
         t1M9tQY2UJ/WSb/0qTzrCTZZL9GRER+cSUnXxiIooduVJiehafR9EvlBeZneZyaWB58J
         +8Fw==
X-Forwarded-Encrypted: i=1; AFNElJ9H4+6xhZ/kjgd0N0aU0X3wS43gjtEVq81sJzvZPd3ZKShJH/VEKAVndwcJM/G9bVCI8j9MRIcTfQ==@kvack.org
X-Gm-Message-State: AOJu0YxtWxU14zXp0HtqySrg7aXPSNMgn0/YH9Isdp8T2Lvh8xZLF0gG
	CMpiHw5nuW2a7OdvFIc7i44jT4viv5ykXqdN0DORXe2kMmtnB/bge0aW
X-Gm-Gg: AfdE7ck/Rc+ZkoCZ6xCabWIznPAMszwxU04gcQjNVzfIaNQCnmu95fUHM88tVCTmcYC
	Bizbct06xjmZQAVaeaZFdzqz8vML1Fyx5/IfyHzo3jDT1N1Mscg0/cFAaEab5tbg/sBm3HWNBUz
	oGUf8TV4tF7wZvf5Dvkd/CwkDxZ7ve2WtDntYwPiOZEv6uRIs2tnJfaEoe9YYPMzLOVf1WNr0Cv
	M7NLUIXzKdj4GbyybAHMneQvuko6qTglObBYaleGtpX2ITYubKolv//RE/mfFbWiHRSNLgURs7n
	k9ezfp4kL8R+jIi/QEO2tPXMQFi5Ny2Qim7yWQM2a8j+wewjVPfWpg5o+RqTT+OhtjZPiO7aFBs
	rD8pGIW1EQ2WutlJEsK3T/DexXRb6vkfmUdp2P2G6PnV6a+jEpOWPaoLBJxj7O4p/lIA45wprWg
	1kYpFsvSOkgAs=
X-Received: by 2002:a17:907:9411:b0:bef:89d9:9f08 with SMTP id a640c23a62f3a-c097ae38023mr306303966b.19.1781921635995;
        Fri, 19 Jun 2026 19:13:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e49aa07sm47766966b.10.2026.06.19.19.13.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2026 19:13:54 -0700 (PDT)
Date: Sat, 20 Jun 2026 02:13:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260620021353.nn7xp2ldqachq7gp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <ajUXNjRMraKb6k2n@lucifer>
 <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA3EA80007
X-Stat-Signature: kz88huxukcwmtzmbytxzi31yo6rd5ad9
X-HE-Tag: 1781921637-990493
X-HE-Meta: U2FsdGVkX190Vr4U7T9hlBGMpwAso/+5Eu27X42+/VFhUTk6e2SokKXWCymf77lQEjXVL5NFk/lLsb+3UucOF6qQFHDWICijN6ih9oE3x0gN8IjjfltejD1Qqv1nKabJc5V82a9B5o+vHNA3S9EeOtE3j4pnelc6Vjb4dWIgKq0/bUbqQ9DuN/hmxKK3+YE+83xaR6gbDh8Av4vyglq6f5VstpXnJGtASqRpakcZLmXQCS0LTxG67am2qYKVQ2zsNj0CLRXKDLBxGLL/DiA4oY300PI5R1B1TDCbds8dEWY7Et8wSc0B2E3DD+1cTL6ojwl8eLi/JPUYddfeDcdMLKjR6OepzJusbEkCuFCnxUoRVaooHbqBqCXEq6JsRY+4O6B4iZsXNlMBpm09wOIHSlU0kZM48t7BTifDZ2oqg9DGhURTLrNfuVnf2B8foyl4CBODRe7ccn6vlBDIn2H1suwrCwTGqojDnou1yJRg5aZSRUKVU4/yGGZzGlCSpGZGiVkj+/as+rjU20wKviXLx2CQKg6Fw+xZsrQmAe1MhdJlAoyqbTU+VMtWGaGSDPme1itCs8Jma6Mgj6kAIXKlz7LtBPSeC/uWSjAW79cclCEzAuU4gA1NXw6Zu1pHos5228/8od6zm9H7L51TZ2uByhf6xyvQMozzpqo9xEalqLGHOQH+udgsWYqdWyQ1EFgZvqYDhXqm/N7tvsQIplwEDDz3ES96H0DwM4ppb7xIAFxLbCSN7yTbD4zkxxQi6AG0fdl1EnraZZlrMQ0W/yZij8idRPVEYkNLNlr6hkMtpb4YGwgGMUZojFYdOlccz8dlPgD44TxxMk8yM2VgoCn6vk4NjhNNmwHyz0Au64fLIchhjOjWsr5xyNPquqXTFHWXCJLmdArpqg4QoFIudy/dHHrQAFWLNhFgeLTzKaQ8kegNfx11m70svz44DAsMyAHjA7+duX/r4WcRJk82qpI
 PVgPOgIo
 UdvOU0x/2A1PLBY8q6CQ11cnjL+TcKqTZJjbaIrzBiCo1/P5omRPHQtfQS+gZEjL/tQkSDysaK48CWG0V25lxerAk2msrW4kqtiQ7KXflq/9BsAhXN9Zwvpul/+WYLj1IEq7XbFGntjAmvJEJXkmJpXGVWVGkRGYVBuWvsV1qMiwESBJ5gscwcCRIB8Psy0hX+pZnDMP7CU7IA2CUwnKOsZf0/WCQafrweWLOtt++5WVXNWCRR3X8MgJc/vXFG2CGyVYFt6di0GXbIFY88XdDxEIsb+3DjCVsPTQg6mR03snDAhqX//HOoby5YDTDQWPcVsIU42xjhhC/tU8j9WSMmb1Q3zV/wBWB9vxShFYsxBKaOD1DD+XgLjr/8V6xgqakEELoJAdcxOmY3FIBwdF/h7jjJhoKgGWcWCeELyxhdD38bTP9J9MVH30UTLakzC4Ur573171QXxfdPNx317c8HIsscunjeXohTj1xP3dkExJ5bpLKpCnHq89gGBPFyYsA//NYpeDbx9gBb2v58lwC+UvZV6+auM1Bp8Qcwo2TtKD7vPL9oaNILbV7czs/UlOQyYIptOg4W+MYXQnGDFZ3tS8VMdvPDI0NCh5u0wjC0juxqPetmJoNVti7wiXt8Nu7GAPLG+K00Nig4yxqREv0aVHXHfTk8gGfuA+mGjn/vYYxE9X8utnpyfV2x/1Z4IOBzoqq85jRCA3dIHk/IAzGm7iLVR3wb25Fll8HSgl6IKpJ51kuehZgeLO6Q1vcq921/4RU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:48:26PM +0200, David Hildenbrand (Arm) wrote:
>On 6/19/26 12:44, Lorenzo Stoakes wrote:
>> -cc wrong email
>> 
>> On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>>> before return the pmd entry:
>>>
>>>   * re-validate pmd entry after PTL
>>>   * check PVMW_MIGRATION
>>>   * check_pmd()
>>>   * handle on pte level if split under us
>>>
>>> But for device-private pmd, we just return after pmd_lock().
>>>
>>> This may return improper entry, e.g. if we are looking for a migration
>>> entry, device-private entry could still be returned, which leads to data
>>> corruption.
>> 
>> I don't thik this is quite clear?
>> 
>> How about:
>> 
>> 	If a softleaf entry is present, the existing code simply acquires the
>> 	PMD lock and returns success even if PVMW_MIGRATION is set (indicating a
>> 	migration entry is sought), meaning that the caller can incorrectly
>> 	interpret the entry as something it is not, causing data corruption.
>> 
>>>
>>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>>> support device-private entries") by following the same pattern as
>>> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.
>>>
>>> While at it, it cleanups the pmd entry handling in page_vma_mapped_walk().
>>>
>>>   * Instead of handling trans huge/migration entry/device private entry
>>>     in a mixed manner, we put each case into its own if condition and
>>>     handle with the same pattern.
>>>   * Also we grab PTL and make sure pmd is not changed under us after
>>>     above check instead of do the check with PTL hold.
>>>   * restart the process if pmd is changed under us
>> 
>> You're doing quite a bit for a fix and you're putting it all in one place.
>> 
>> How about do the fix as 1 patch, and then cleanups as other ones? It helps with
>> review too :)
>> 
>> It's a general rule of thumb that if you do more than one of moving, refactoring
>> or changing code, to do them as separate patches so a reviewer/somebody
>> bisecting can clearly separate each.
>> 
>> Also PLEASE do not add new functionality (this lock recheck) in a fixes
>> patch. We'll end up backporting new logic that way.
>> 
>> Make the fixes bit _minimal_.
>
>To be fair, I asked for this
>
>https://lore.kernel.org/all/2d48ef0d-1110-4a9d-adcb-f701a1ce2cfa@kernel.org/
>
>But given that Wei mostly used my quick draft without properly checking the
>implications, yeah, let's fix it first separately.

Sorry, if I misunderstand your point.

>
>I can then follow up with a proper cleanup.
>

I would like to do a followup cleanup for this, may I have this chance?

-- 
Wei Yang
Help you, Help me

