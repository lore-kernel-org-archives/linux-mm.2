Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8E9CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 23:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB118E008F; Mon,  3 Nov 2025 18:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392DB8E0058; Mon,  3 Nov 2025 18:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A97C8E008F; Mon,  3 Nov 2025 18:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1984D8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:37:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFC2613A8F6
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:37:32 +0000 (UTC)
X-FDA: 84070909944.12.A472F6F
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD5FF80010
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:37:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dXSM2tjm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762213050;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9W67M8hvFBDCY467IdskXvUWzUojTWiMC1QIbYnbSqY=;
	b=4m1or0kQVNsLNojdLKtqMnojH6p4LaLcXujb0Eog5UTuVUPK3yO/SOf2icFXhTt/zJtmEB
	Fni/m6wOLK+JYW7cW1xnTC3j8yIoBe0MErXWDIaLyn+3Yn6BfzwcqISzZZIo6bZPwVof0c
	ughh4zKn+US2/IHoCbdGamLZ24o+jl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762213050; a=rsa-sha256;
	cv=none;
	b=AmIAo9/fnknWzCH21WQ5QslqyIQULMVzLnG03yKJcUBllIBzvQEe21qsRWSR1Mtc2/5nb/
	/Ca6Z/t7Jrir0fLDWr43mrwJCVLj5SNngJT3rExBQ/qphISXyUxFjmijvR0tXA8sCe7fSQ
	89PfUdxhSUfmggZdexpNm+lHdF2Dh9I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dXSM2tjm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3c2db014easo1030187666b.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 15:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762213049; x=1762817849; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9W67M8hvFBDCY467IdskXvUWzUojTWiMC1QIbYnbSqY=;
        b=dXSM2tjmS7zeqEOu8h+rVDdYx2BafVODYYOredAn57/Jbqe5zDobf/NY0CFYeTB6lL
         sPM/wmapwKc3UA2N1g/mbTKAYa1cWHK0zfPSVK5lVTbdRH8Tnm5x0YOCB37sPqldVCN0
         01aX5gcSzI1KZ5ovT+U/mMHkiZ3g4ySUZsKuHf27dyg1cWaH560ttUvEHn0h+YfntPFK
         Cw3km3BdRBGEq/tvkVfKAwpNjD6MWXsj1aSAORPbgv3ePMoIAnH0fNdKG9EK9iXzk5+/
         aeFHw9B2K2WadPzSyQX2/R2V9x7fV1fhWLJmRtGERa/2cb/Oh7kmMo1csaSFV0qlR8BT
         WpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213049; x=1762817849;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9W67M8hvFBDCY467IdskXvUWzUojTWiMC1QIbYnbSqY=;
        b=wfnR7I/D72ELRQDMqw7vYn2E6dkGT+QFq9sgq+M/GdmhbSbPB6fFlKlRW+RmfsAAIa
         M89RjhpWowXpVV92fYkisC1pBu4XrGZRKC5Jik5z5WdJ2lCVFQ8mMD1ZbVej0kaWI7fT
         WLmtWnvbTewgq3k6LmPtvSDnH+kL1FF9M6Ve+REKIXptjuPUBuvc+cRRWjh0ontDX1oM
         PDfe47PIq/lRgcWI7bptL0SR8laPB3VnI62NjGvFczb0aKW/jM2ks0Nx18vtecJUvfA6
         vQZBeE23quzmtoY5jeilltsoiuGjTeCjmeMGV0c1j/yiKPknsC9KgozHuBam1+u/Q5do
         IynQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4UeqvHeEIevwHaw+BpC/Scxad7WW3gPsvZ89uv4mkSTutI0PGoF6xCK4EPyg6L/4qHIOsWuTodA==@kvack.org
X-Gm-Message-State: AOJu0YzBrTUPgjK2H0cM+A8GA987JbBW9y0ZPOD+aBYyfO3OmsZnC+1k
	QK8e4PUIHap5RhUB8SBMg+HAPHiBgEoXpYPHPUjOfKGrxbYsfW7p9cz+
X-Gm-Gg: ASbGncvJInV0CnpIC74OIH5rDKk0MWnagnKYyKSedZpfuOqOGf/CSczkkCsogJqQPxq
	lh1cvniNZrQOrbWDxBDf7VzTU4XL4MUwJYA8wuuHpXTK5I101HlyhzhcuZez87TMVGrlZl2dwzw
	0jVIcDH2tQe/Lx9M3KUxBv8uhBVmfk+3a2ZbcjjnKxE1OVtCA/1vy7nmsiq8Nzh7hTbks3acCm0
	qwuymleFXNe2CEMzkokpGe49jSPRsWS2SRcJxiMoEBOfYxGUIlmHtizr1Ly24HsUAOp2nwYynPE
	g5+cJ+TMxjv3Xwb3mM4ce9eznSwmxOZgUnpG3OZv0QuSvpsR9zooGG2mFGsrPXqx68k9mVLIyz5
	Gt3IBYt0mrPrs2jx4KsOy+VUNYCXSrRKHJ76LQ2aZCdnlzFRuO/7kNbhq772LlO+0z/yawJxJy3
	V8FEVYs+Z5jVxliw4vGWxh
X-Google-Smtp-Source: AGHT+IH0qre1NsIZIezv5EsF00eqPLuAD/jVyXdcUf2FHlpoX9eZXQ3xSzlT23/WYywCkJc/KQxk8A==
X-Received: by 2002:a17:907:70e:b0:b3e:8252:cd47 with SMTP id a640c23a62f3a-b70704bc386mr1541505066b.31.1762213048987;
        Mon, 03 Nov 2025 15:37:28 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723fe3b899sm36496766b.66.2025.11.03.15.37.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Nov 2025 15:37:28 -0800 (PST)
Date: Mon, 3 Nov 2025 23:37:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
Message-ID: <20251103233728.b5kmsit3vcqpmr6w@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
 <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: xyp6csn3redm83eb53z8synpcpnp6qtb
X-Rspam-User: 
X-Rspamd-Queue-Id: AD5FF80010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762213050-560858
X-HE-Meta: U2FsdGVkX1+ZTq2QekFfj12QEtb4ILPf+b45lSqdSk/CUYaCYc1woEJk8ppMw+oV+gWuPPouts4lEZgQ0HOANO7VZBGiqtSJGGVFYw4dx4WuEW3njjR7H82jnTTQUSRS6iLtiR7WbthGQEwT4ZI/hC9EP57rRPnKreJnjAPVAPyZZxfxt8JRF0+hErSrgSBfL08mk4vvXGof/o+ui0kzAiQYV10GId+G8Icd/pG4IITuaERosKGQXyJTodxG7gAzvyI5BmasQDGBax151Kq9oQwTZYCrHEFUOi5l8M2/mly/2BWtV7OBItt4kkHsq3W40nsIm/7W8kXGrWELnDteBtzO+72pTvWPa6GBsTS+b0KB54etkb0NUKkvnxtTQHYpwGAVxHpGyUZnPT5Nzeq2YYAzF+Qq1Zc0pyEcLby22geRUzasyvpXzPMsFVuHoBWqeeRCFep+m18bDvO+tVbqLoBbe3izt7RpVAJBCd3RCBOShce/YTrnaGWU0oeYeMSpD1jscr8/caW4JJsFaJhxN9k1xROX0P2+rKBFf5x7curwjOheI58v8xiodOf9YlRTGcsZXjPetBkF6M4x0gObp8xfOgC1XfpUyOzQjVjaa4naWv+uJqi0fcBJTwKWdqAFYVw1snFJEo/41I17sv7o8lExoJGEQ22Pmc3FECwKBAogF+b4VWT4vuiTEKUwjsfHaWICFucOTE/GCQeIV8mZcAxy6DUFJVshJUV1AxWwgcIjOLuE+tSdSCOnS1aJ6XMg61lVg2xxIvthWgfx02i5WDZRHJG5kK3nBk4Niz87MZHWgBCZEu1H4H6JuLE7COXLtApIVXmcA8s1a7dctVbhoHl6Y4o4e/j/UM8WEVWK2v3FoGk7KkKPIVvoOOdXrn+l3SO/i4BsS15ntzh7HlafTu+0gqUxSTFobtnlAHyBki+pWxgQTufcv0P76NI9xixv7y6ev+shEd1bA9jHSy6
 MuhLvTLb
 d37EbsRjJgKJ/CxtgG3g2Pc4m2itbU+W1JAmVbCCliqogUJEwzqSUNQwk09T1dYabVIcXqYievu2igrMJEvhg9Ju0anfTJCyp7mPi94/9qvJuP/SS5gsG+U/EMySKMLriaZEBBMvXFhR2jdW6bBSglT+r4vEiQ6Mvndu5sGOLYhnWravPl+sQgjcif6+tyH7OqIGSUXm4bVcfgMGvQXB3wg365Xdzg+9OWg4t0DxddnA5bWeaWgFGRcs3yWV3oerjOCtCJcQ61WyNrK4BFaPR6R1UYFN9XvBux8ZMs2Kr5Jrw+doNPJ2OV6Ij/L7qZNehShpDfVt9aQfi2dDedWJ8WUCJSgl+GM79iRgttQcI7yDbzV7fatLh8lJYaxIUunjTaUh//oNLLXnnHDAY3zbMlhWqLNyS6+HGRSeFujIyhxBH8aRH9L9fBfz2CZEvWyRzquaNx52MhCeYeHiEYgIUuKr9hJbyw1Gy3FTIyUbT9+le1Pw9PiRAN4mmnck3JXKrUsdS+GW3FZeoy1SgeCaQXcsj/Kk2yKigWK+KKUbJvEWRKEeUR93LliCmBca0sMN5iD45tutZISVgE6ZtNXLkYVsXQoEiXSHvwGAxbPOKYIBd6maXamy9ZJlDN30zR8pCAB9PfJTKO9WocI5CppAVki0FocCrm5LFUHwmYxpU4cP4G/Bfyuj0myt+yjNk9BKEjPJASA7jLOBA8gL7Nk198Q/PLacMXArQ/bmnMZ5kMsZPeUB2YZ1M5WrlWyDSLIuUnYom+Tpa9tGTPBtJyEVv3aI0vstliZGYmxp1199mWRfoVm9wFepP2AQPU6iHWofKVIlh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 05:20:02PM +0100, David Hildenbrand (Red Hat) wrote:
>On 01.11.25 01:29, Wei Yang wrote:
>> The folio splitting process involves several related tasks that are
>> executed together:
>> 
>>      Adjusting memcg (memory control group) accounting.
>>      Updating page owner tracking.
>>      Splitting the folio to the target size (new_order).
>>      Updating necessary folio statistics.
>> 
>> This commit introduces the new helper function,
>> __split_folio_and_update_stats(), to gather all these tasks. This
>> consolidation improves modularity and is a necessary preparation step
>> for further cleanup and simplification of the surrounding folio
>> splitting logic.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/huge_memory.c | 28 +++++++++++++++++-----------
>>   1 file changed, 17 insertions(+), 11 deletions(-)
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index c37fe6ad0c96..abde0f1aa8ff 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>   		ClearPageCompound(&folio->page);
>>   }
>> +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
>> +		int new_order, bool is_anon)
>
>Is there any good reason we want to pass things like "is_anon" instead of
>just querying it in that helper?
>

The reason is during split, folio's attribute will not change. In
__split_unmapped_folio() it is queried and set as const.

Otherwise we need to query it on each split.

>
>> +{
>> +	int nr_new_folios = 1UL << (old_order - new_order);
>
>Could be const.
>

Will add it.

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

