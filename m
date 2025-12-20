Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0153E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC526B0088; Fri, 19 Dec 2025 22:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A066B0089; Fri, 19 Dec 2025 22:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B686B008A; Fri, 19 Dec 2025 22:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 144C96B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:36:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B983686864
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:36:31 +0000 (UTC)
X-FDA: 84238436982.15.96A6A23
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id B0883180005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:36:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ASeZvo7A;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766201789;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iT7lqqLMzFAF9vT4MEMeV0IWwAvQblHC8pXyiLsAr08=;
	b=oXJJHMqP96hhnkfgDOuACz9X0O65hJWJP4YMQvFTXtFkAt9srXm/wGvNzXBoPU9ps9Ue4D
	bI6SppefHIHeXCU4lZFk4KAgqqqS8ki2fhjgOWxdeacwOV+Rf8hmE+5cBXol624OJUY5D+
	Icm5jk00tJOnx97nb5QQAJmW5ZgAqhs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ASeZvo7A;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766201789; a=rsa-sha256;
	cv=none;
	b=10BMv2aBr5Ftz4F6QV3fkCuHpy3W5z2KCaedE8Aq0FxNCLsxQHzPGFoZXfvI3PmD0iybay
	KMLiHdfJz0aiea0QQJJgMslu+jiryDS6jie0IXbgSidANiUYtKjZAKpNd/jSCdltA29w+1
	sgbzzLvZUJMfynArsBVrEdU9jjbr5MQ=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so331870266b.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766201788; x=1766806588; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iT7lqqLMzFAF9vT4MEMeV0IWwAvQblHC8pXyiLsAr08=;
        b=ASeZvo7AKzLe2Rs2co6qwmdBNUMZ3dt6F62oMby6hjnffeVbSNOyQIvFXdzCYBeA+T
         6LGvq7fcTNC81PGiLKDoAKXNCA4mubdyxlXGsisCN6KT9Dc4BWIFV7HGnZVt1dQwekol
         vTJ19vpPHD22qp4fAb3xIYYukD8vL8LAe4GHsFb0FVCy4WhslY3j06r9Du7YPE2fCsm3
         6x0J7syZtZ3CSjm0GWStfke0LX1Zcf58hN1X2B3rXCA13JWA1WU+No7T9BZ/Gekjrtqn
         BqTjuWFePd7k9QWJiynp3d96M+PbEOXjkNSsvvE4uZc4gh+G3ub/gMXPTyFEuZmgoD9q
         TqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766201788; x=1766806588;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iT7lqqLMzFAF9vT4MEMeV0IWwAvQblHC8pXyiLsAr08=;
        b=w+hxMybcLYa0ChYfORW/T+W2F3+JsNkVqhmDedqAvN7++ija4mPK1cIPsWnrm762kZ
         LaNilnqmZoi1YiKwp3IMkgxgTi1jJPLmRdbo09wy1kb5mAIyIhEFIMrImlsxcGLGOSem
         ut0jYEiqAr/JfgArXvrK+PGXmTCO4k8cjxKyaBdP+gJOuGiabl7ou1Heh40m8v6PLQPB
         ngsZdxiphv53ybQ6K6EsIE5Y75Pmw3AprdR91nn1La2o+NettISzPZmCeuFKQWHRs1Ci
         bcmetSt+cC4eSQTkldjKtM8VjXrsQrvfrS38nh84AGVFKYykeA52FH645MgGlYW2ZAiD
         B64Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/Aa5LwiPDWj7DWulIeyHUz3DXTJDbiKSTxbGKjnKbakXIWs1jNN3Weis9VmeATbIUfi2MbPG5pw==@kvack.org
X-Gm-Message-State: AOJu0YxIszuVzcHh31E8U5vxjpyZeoTWYbwGSAR3rXSSIHLZzR6xbGBI
	AEHHDVzXl5kDyhfx8SPHEoZsENRRX7SOCp1U4O8qLz1kgaIia8pPYsFD
X-Gm-Gg: AY/fxX6sZgMLrNhMkQt/aCHutC+XPn7K2TnanlBqo1sXnVftVoQiE3k878wysj1uJng
	Hbfy1C2ca+dkJ4vbY3h7j7/knt/t7i6jaoJzaK9xzhmeOhaVm8Fp0K8vegBxglr1YC6xe5ZJUfl
	xOiuPyM5rh0h/5Et94tv282vPw0oY9sY8TGolSuMP1J554O8qyYIKxPw9XpHC6VpX/xvAZtM+4O
	jgEgmyxJi0NRF3aYJ9uu9zl0TtSF/Dgo9UH6dmiW3GmWfwQGhnkxM0RAw47Qy2PvLvQlcw2pE+y
	1ibiyznYDV07X30WlmOpF68XOxFa3SiqyI+2Uzjbp29nz0uVFS7Zh7zCZjxk3/AxLxX7vxQyiPm
	630tROBeEFBdQcH+wL88nEqy73DRBNi4SfGyG5FDShDz648CLrcouOFOEGOGffrrBuRKFrQNJNg
	bFsk8tjyurAA==
X-Google-Smtp-Source: AGHT+IHbPB9Nk7SuIkQHMcWuZbWvSNed/FzGiYTbEQRP5meahza6djjMUdyPWibmisECPg6y6G5PyQ==
X-Received: by 2002:a17:907:6eac:b0:b73:6b24:14a0 with SMTP id a640c23a62f3a-b8036f10e30mr506632766b.18.1766201787940;
        Fri, 19 Dec 2025 19:36:27 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ab7f86sm386061466b.17.2025.12.19.19.36.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Dec 2025 19:36:27 -0800 (PST)
Date: Sat, 20 Dec 2025 03:36:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, hanchuanhua@oppo.com, v-songbaohua@oppo.com
Subject: Re: [PATCH 2/2] mm: avoid unnecessary PTE table lock during initial
 swap folio scan
Message-ID: <20251220033627.xy6yralcx76vucs7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
 <20251216075943.29593-3-richard.weiyang@gmail.com>
 <de04d804-d27b-4029-9b0b-30e863440aac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de04d804-d27b-4029-9b0b-30e863440aac@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0883180005
X-Stat-Signature: 7j4chkr59wtomrggkn4d388wi6zw895w
X-HE-Tag: 1766201789-726480
X-HE-Meta: U2FsdGVkX1/Nkhlwh2BAxYWC7/z3nzF1C6QQs29OX/gXBIEBHypc2e7XUBZMx/2ajrVqKuzZk1MmHg4GAitClrZB12BL0TbUtsW9Pkd7SUkdjZ+URIgZoWV5WlyLHI5x2L9EB4uoDVUw8GroXqTDjUgqIvILywVONRlAKp8rFSK9BLNzVZkor0Bm7T7BpgWJfvFiUNMv51aih6nUx+cp6VAOqgjFlM7W4TtZ2V0yK/TSTkXPy2R9kCOtYcSslkJKUJLlfzpBT4JnA9dusfO4UXJLj99qrn3eD8c4SdLMjIwiU6UCOxVMBvw0lIr7pLRqyrMkrH6eRp95iPOWa8F2LFU/Ffr3BMFYjhAe9Plvf8eVMjmYXN5tR5RQzQDyyq8+/RPjmlICWV1XKmyit6gpYYuaXjPCrmJcq2WXjkoHY6BGlE+w44JoSZeuCyTYoM1+qIHKO7aAH1x2WlMq67v/gCgSRDlE8Ny8bY0JQnN1Y2erBJ4PAb+Iv1rLhLBTpjUtPjllcEz9FoJo+1eQI9owAMjGi9Q2t1cEQb87joUfDHwVJSUcJoStyKuhZVSS8AgIUI+QETBR5Qvm56QYobTZAiF1Ttn+Uc2XbJWJFPWwTx3o5yNWaBCgk286Brzk1Q3zV0arCkDsoiI5uZQUV5itGgJ8il1z4M4WAa+ZHhLaz+FM2QlqTbXNVpz4UOyy5u0s5C6WvxHZTO/PcrmFOYKLVFFD8HrofVhLRGJuRP3BKGa4cJZIKJq9WEDYa3bJgyQxiHslCDWwJVTTDT/0XEP1On6s9m1HnWlQOrVhhqhXE8jHllZZBK9I8sgPnP810bqn8sxNSRM7TwyQSbbtSKt8do27hYszTKxPSf2fL4XdSkQgx9nJEEAKvfiyjcueEPJYJgVJynYMbCfprTrHOzdIsx+Gjy4/1wd0nh9tsLuLvarM4RLGBs+16lNQnHlyVPqSMHkSv+a2d+aonYp2zfZ
 z7CBHyOZ
 6/FyYhHTaUWjyqXUuqMunaljhSdrO2qrvFyunq81QUklyHc/rbkOyvZnw7dS6dcsOyVY0ZON82/GA1hLIxHTUfTfPwnExKj6z4bczawQrZ0EaSNnXAw6b47dx5ld2d8Hyjsixl64uryg4ySLnoVNGVI1zZiBIEIs/8317vrjRl16SNP64Lc+rBoY/tn/w1+BvQJsb+wu61QiTLJrqb6WoIj7euR98rGHDAEUeBzi6lj/fC4ZZ+eP5H51bU0qxrKd7rfIY2+4abmHOBZODi/kw9APTZ/WReXk48aQbad/1HP4FBCe7Fdk2ZzTwbgOGIjTH7AhKZKakYdOuz+wNYW+B+CkW3cVD/+v1li7nf/TCMdsv57/yTwWNdeIfbOSep5MY0d/D3yKCpiIIncSAoyLO2WSSn3kRV6oGCQFlAjYRz9d0TPV7od03jAyqqjlg4z+fX6nyV7/rWjwlawCmq9h3b3LeRgfTozYohpYZkgZMh3S9qPVsJfazSkHx2KKxGzsUVe2VgW2QrVbA4Sdbflv7bywsaDSSJXyjoJNLVn9KSB6Z1jFvznAUWRcoBHSqg9kyZSm18W77WpC8khnAXZNpcprDvmkFHWj4nR2NwoTQVYSPbV7a7yx2Ha+g99Emz3NLuijn1FBpU3wSF1RJuE2socYYQDrPIyR05t3d8LwKCq+7dC9YfwHkm3vyV14BCARgHxb4Ch+m4dCMYxNaZPRRDij7Y07YWblF/ciPEV0WJjAdn3uqgTnpnyJQNG44ilCQ0s49
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 09:47:17AM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/16/25 08:59, Wei Yang wrote:
>> The alloc_swap_folio() function performs an initial scan of the PTE
>> table solely to determine the potential size (order) of the folio
>> content that needs to be swapped in.
>> 
>> Locking the PTE table during this initial read is unnecessary for two
>> reasons:
>> 
>>    * We are not writing to the PTE table at this stage.
>> 
>>    * The code will re-check and lock the table again immediately before
>>      any actual modification is attempted.
>> 
>> This commit refactors the initial scan to map the PTE table without
>> acquiring the lock. This reduces contention and overhead, improving
>> performance of the swap-in path.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Chuanhua Han <hanchuanhua@oppo.com>
>> Cc: Barry Song <v-songbaohua@oppo.com>
>> ---
>>   mm/memory.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 1b8ef4f0ea60..f8d6adfa83d7 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4529,7 +4529,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>   	struct folio *folio;
>>   	unsigned long addr;
>>   	softleaf_t entry;
>> -	spinlock_t *ptl;
>>   	pte_t *pte;
>>   	gfp_t gfp;
>>   	int order;
>> @@ -4563,8 +4562,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>   	if (!orders)
>>   		goto fallback;
>> -	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>> -				  vmf->address & PMD_MASK, &ptl);
>> +	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
>>   	if (unlikely(!pte))
>
>Can can_swapin_thp() deal with concurrent unmap and possible freeing of
>pages+swap?
>
>We have some code that depends on swap entries stabilizing the swap device
>etc; the moment you allow for that concurrently to go away you open a can of
>worns.
>

Sorry I don't follow you.

You mean some swap entry would be unmapped and cleared?

This is the first scan of swap entries, and there is another
swap_entry_batch() before real work with ptl locked to make sure the range is
still valid for swap in.

If someone change the pte at this moment, it will be detected after ptl
locked by swap_entry_batch().

Maybe I misunderstand you. Would you mind giving me more hint?

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

