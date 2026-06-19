Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D7BCD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E350F6B0088; Fri, 19 Jun 2026 00:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6426B008A; Fri, 19 Jun 2026 00:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC576B008C; Fri, 19 Jun 2026 00:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD92F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:11:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 338A61C497E
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:11:22 +0000 (UTC)
X-FDA: 84895337604.02.AAC9AE8
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8AEB840004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:11:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mCEy7gjk;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781842280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ns7uFMdN8XmD+BmGhPlCgcUtZIHgSZf+bEO3nXaURYw=;
	b=sCbeoG7qkdCysvJCHd/ZuZw50wophZMCJVkWxFr99iz1upIty+3fA2XuyhB73iPoerDJ3p
	96E8uBYKfCLo4u3wbHlfuqytgA9ypzgTq7TEjinmhXdRbO0SP6TieCBrXwTBwBusrOgeN2
	G0Vpe9luVjnm9caSjCigKPzRhjFJMd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781842280;
	b=lAPlteqJ+hjJS0W6xNXmZL1bpO5y18WdttxOaeUbmutqAMr2IxVIrkPjMrIbJBsKakkskM
	7UdFQBpRdPisjhBV64960WTdASfkhjVvkH6a4RtAWDKqfv70UNmfz2/K2JEZBTg87YC5oN
	wSdHMYR+G0+znXYhacvm4g0elx53aZA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mCEy7gjk;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8452a597afcso1002857b3a.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781842279; x=1782447079; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ns7uFMdN8XmD+BmGhPlCgcUtZIHgSZf+bEO3nXaURYw=;
        b=mCEy7gjkrmSe1NiZ/FiyIHU/HmYJ7EUmkNa9MEqGyoDNxSrJDfJVSQFlfbSJDR05ul
         06E5iU91kHsGBjs4NHKCHT2cUWsLsKyPc+BhvkCSQEpfTPORAqSunGJ3qHA2D+cCf+PV
         P/zJjrZjTUqcLyOKtenSf8DK1nKX1rc6oOI6Nfo4Q69yY+nD23rkPexovLHM0KHVwMX6
         0Bl71DAamwYIxJIqq8bC3Sr7FKvY8N0AajgVgn3+7TJNxgJu1MgsVj1CwFTrJkyu4i/O
         SH6TUSmVdYyZW9fO+z/Ywkk7ZEgm1Se9BLA8IdPh6QhwSpeXa800rbRB9mKnMAGeGhtl
         TyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781842279; x=1782447079;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ns7uFMdN8XmD+BmGhPlCgcUtZIHgSZf+bEO3nXaURYw=;
        b=O9LNVAoDwjFXoJLMrTV2Chb3AL8K1rcF4PTbaNUdc+WEFr0FyeGWlmNpXJKox25BsO
         EtopCIyv02dkH2GDbP7w9k2XPpF05ArAZOMTcm5OtlADS9CzfrGwED4PY+OCQmSGqoqv
         YgsCFBezojwU+E6FTV1JgYIYOlzzMIgkMQnWDIoGJdukGlWrHP6PfIEz2ODV6UsH2Y2m
         SYzhBQKrWWjv1vISR5M4mIVj5tIS+1fgN8XwIii1uj1ZVGm8lJyizW94koRnyFAjJBz0
         5mLk7FhPSeRJL9Ju0xKbeNFrhae7PY2Xq9Grk9ozL4G1nFQfIH/YwWhKEzjazMxJOiDd
         SgSQ==
X-Gm-Message-State: AOJu0YyVVpt8iwdJWL/FlBXRzY1vv50f4e+6cC/AlVG5UAx3qU066R+Y
	a8druaSsVVr6hlTW0OKMFtnZgJ4rKyi8dUwZ0cW6n2rBbwV1MGLhHS01
X-Gm-Gg: AfdE7ckZQXyWzy09ozOhT6dCXEam+bhly+XnD2m/jm5vpfJ3jtYY1jJeYDxjx1XPB8H
	BzwI9bpWmGJ86FgJEBSdZiwZ4Se/hQvoUJbOMzJJ/dbMBNfKXbtQoQ4MPL64lr30aCwtSL7QFJD
	jcl7q9FIo3D4jEABdzmsxEC/x92zaJ6MZj+9UBiJ1L/odnd/8n0Wf+1rJrVlX14rXvyVim+8xfO
	3Oh+2mSGDvO8ys8HoLhcLFwmM+dcUDr+IGblV1crXfgGUWwztOjq76bRsYmRIOLVbsmgMP7oNjW
	hXUdmxE4SGs1IuRCYm1KPon3RDKa+chSvWWHv8SwhAlQXUSmkNUPjTGPwimHlJMQ9y0slacyfdp
	6pzgZFfo2KPQhu/9VvIrwQOxq4r10w5FdjQjubHddIaYhbY6U1ER7XTIFx55+9yVoIE2T6iEosq
	hZjyqydCIuWsFxLvs=
X-Received: by 2002:a05:6a00:14d3:b0:835:4291:6975 with SMTP id d2e1a72fcca58-845508cce6amr2119845b3a.39.1781842279197;
        Thu, 18 Jun 2026 21:11:19 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8455382b766sm793864b3a.47.2026.06.18.21.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 21:11:17 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
In-Reply-To: <ajIUVSWaQbFoez5Y@KASONG-MC4>
Date: Fri, 19 Jun 2026 09:36:17 +0530
Message-ID: <5x3fdvie.ritesh.list@gmail.com>
References: <cover.1781287297.git.ritesh.list@gmail.com> <1e8d7e4d0bb1377277ae8b6561d89fa0e048e7de.1781287297.git.ritesh.list@gmail.com> <ajIUVSWaQbFoez5Y@KASONG-MC4>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8AEB840004
X-Stat-Signature: aetegf8q4qkqbtz6nse8jebsqtxi4m4t
X-HE-Tag: 1781842280-181056
X-HE-Meta: U2FsdGVkX18k9uw+yQ8tBiuqVPbhD6rv3WzVcvkJk7auH+4aZsZkUiusNDU7WjlZXgDTKOGvpMjjmM4CWxrQMaT/8FVrUTBoWj3200BMSUiFAm/1H4HV0u3cQf+Rv+1AvVXwgZwQRQw4KPtrcpPDNjF9Sn6Pg94JsVnG8uYjWeeYz5zUXnGD7llqwFVzPGv1dDkQdLdBM0hioDrsrNVjpljvAP1GnuLslxwwl6sOskL6Pu0Tkz6WfTf4Xr2peYF/VnjhO10yMdiQKWia5eYY/ZeqyKxh9LlZBLil/utakTDPwYjb8rKe9p9Rn3rWlzCPluND/ASuUeSc8AWhh4pGFyYdDJ8hEz180BLJPx7KI6q/jX+EmMCS+ANyXO3+fQX0a3mOwp8xFqX6nSe1TVy04AsY6HQgv76mkz8TuTOFdtMfi25KKNxeFOpYcAui69IHzP0x8yvVgivmdfh9IXH3rZuyYKE9M0uKXjYWUyqsRyPFyBcDiGyz4+MsihzShEdtsH6rpML5Ty0CjmbOJR/9ximVpHPSmE2QSmlOM0SjJfxP5mu5A/vW7716W35QWLqAA20Bb8MTmD4BXs1vImEnKD9luOOeTe4CaicPMWbA8kYtjL6epRjN+/OKNCKWvr7ZQDo3n6bKvbhaa/T2LT8h3KCSrcDVK6jtQRDfN14gIw+/Gx0N0j8XCBWTKjL8YVh7x0oyS851k+lo2k9aP6XUbvN5DOAP5Prubfcni2lee/QPn2aNsQ2GScdEkjU9cnsqY1AdpWAeC11r7dqZq0jdUL8IJ0urXqx/2HSsJQQUXz2o+fsCEQ6h46RiqpUMSQt6VdRxvM+3eO+IvDyYe0KzQzZNKrTD7XSVqX7ZCnuZGZ9oUNFI4O1T8V9gHMU3a2akuRqf/jeX94Id8H6WAfnfYh+nnt9O5fdh8xUd726F0gDo0AepuXYnMCYvPAHFlc3mrEF6Old2VbwQM8IZg+r
 7o9XHjM5
 otgkNcfZWFPrJ/R8J9x/2eTfvVT4gJoNrJHONuB7gvrH1w218Xuwpzw34Ha/be1JHqB+JgFaZznKdJ5LLlSc3VpQkiSfGYBRIujJG21Yx5+VydSGNcTp6SPHkg8gOt9g1khDVYYM5HmGHUJ681fubruZeACN/ZnZVl3QWRGG8rZDXDGAoEXTiGshuvfMHIbpBSmCHz7tpcuz1J4ZatSwhWlvjWuPK6mgKQO/Yt4P6N4z+qqPKkQh2j+dUQJ1MgHUImsyNtiizVnYaQYHDdAKK+lzc4TUVqxmdKlX1rVrUa5hlDwtVz3s16ocJkxZ95MIpsljNDHvPB4vTeZC7c4D2xyA5VPFqn+qPKp3AalgGqVblpKh7rnOGkGQYK+SwJmBiuHUfZ7H1Hqqgftwoe3AksvvOz7ScPKC6EO7/38GGM8/Ry1W65g1D6YOo9iGyUS/l5Ur1mVUf0x9mxVErgSgiXERD+05YkAmTH6mu4MG6oh7cIWInoUBvmz3NSVs3J2lcGHRvw3om3sBBO/HkXY5smeXXzEsM8kXFe/k8UdRpvElmPKWXpBdZWw+3SowCJH6PLLoX2Wrfp4rFWUzBI3C+CC+wiEHYAc2twf7twDnDj5+Twlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> writes:

> On Fri, Jun 12, 2026 at 11:39:15PM +0800, Ritesh Harjani (IBM) wrote:
>> On PowerPC Book3S64, MMU is selected at runtime, so macros like
>> PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP
>> swap code uses these macros to size some of its array data structures
>> based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
>> purpose.
>> Hence this patch initializes SWAPFILE_CLUSTER at runtime and also
>> modifies swap_table and swap_memcg_table which were earlier using this
>> macro for defining the number of table entries.
>> 
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>>  mm/swap.h       |  5 +++--
>>  mm/swap_table.h |  6 ++----
>>  mm/swapfile.c   | 27 ++++++++++++++++++++++-----
>>  3 files changed, 27 insertions(+), 11 deletions(-)
>
> Hi Ritesh,
>
> Thanks for the patch.
>

Thanks Kairui for taking a look at this. Sorry about the delayed
response, (was on travel to #OSSMumbai).

>> 
>> diff --git a/mm/swap.h b/mm/swap.h
>> index 77d2d14eda42..956879a69ddd 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -26,11 +26,12 @@ extern int page_cluster;
>>  #define SWAP_TABLE_HAS_ZEROFLAG		((BITS_PER_LONG - SWAP_CACHE_PFN_MARK_BITS - \
>>  					  SWAP_CACHE_PFN_BITS) > SWAP_COUNT_MIN_BITS)
>> 
>> +extern unsigned int swap_slots_in_cluster __read_mostly;
>
> Maybe __ro_after_init is better for this kind of use case?
>

yup. I can change that.

>> +#define SWAPFILE_CLUSTER	swap_slots_in_cluster
>> +
>>  #ifdef CONFIG_THP_SWAP
>> -#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
>
> So on Book3S64, HPAGE_PMD_NR is also a variable right? Then we don't really
> need to change the SWAPFILE_CLUSTER defination here? We just need to adjust
> the users of this macro so the build will pass?
>

Right. Earlier I was playing with different values of this via an
arch_xxx variant. But for book3s64 usecase, the default values are fine.

So, I agree, we need not change SWAPFILE_CLUSTER here. I can update the
patch with the suggested changes in v4. 


-ritesh

