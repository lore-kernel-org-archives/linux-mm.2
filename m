Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086C9CE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD2F8E0018; Fri, 14 Nov 2025 10:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587068E0002; Fri, 14 Nov 2025 10:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E3F8E0018; Fri, 14 Nov 2025 10:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 314138E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D596A1A03EF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:15 +0000 (UTC)
X-FDA: 84109530750.22.811F3A8
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id B642540016
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IKpjiopL;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132593;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOYDk4ou20EqC7hKmauaNNsT/2lLPOblXJ8i+jliwUk=;
	b=e6FEwZrqqWWsLLn0NKgZjUlvHf5KXgwtcCTImMJx1Qv8XeMil7DOhq1pwWhf/yQ0hcFATL
	GdSNihAuQnjXCLGylbXYj/MFAskVnn01e53Whizwcb7M3RHDRMDvFiH3u9na6GC5gDOkoG
	OWZrMGZbCFHebyaK19RFF4st7fpHb1s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IKpjiopL;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132593; a=rsa-sha256;
	cv=none;
	b=xBKJqJJPqsD4zZiZVflR5QbdDyg9PTMZPgHUYhrZ8sEKxRfBbec+uhnr6Pg/3ZTDof+WFI
	qWtyJ82owyceLVJhYzVWwsXAW8Yq52LMYVA8vLc7FeDUUffLj85icEt0gvY8EL1PhMYPms
	/h8l1vVE5Pc0rkI/jCP7Z7gKz5vo+8o=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b725ead5800so259498666b.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763132592; x=1763737392; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOYDk4ou20EqC7hKmauaNNsT/2lLPOblXJ8i+jliwUk=;
        b=IKpjiopLcveQVPd3dO9bsiY5/ibkFD4Jqc/vES+N5tEnXhoORUU+DIlIw3SrJhVvuX
         awNbB49TymRCKpZV0389Wr53XCdWaju+Z5xyTifphv+SPu9Inmgb/wcBioEqmMG7UtBN
         PR3vYzeAwClZiLSZFxD8IukqONZw19OEPVAA6EMYEXBkGYEJJLGMoS3XUo+SPXZhpUWU
         kgKsf94QZz844xZ284yOk8W9uz5bVF/sRjADHDyAlgRUlRS07KFBFchEIlIcTDCkis+d
         tPq/IktyO9N92tT74SHFQ+lB0X4ZlrHRs5bXp0+JhNOdbG36gJo+OW7SK/rnbA0MV2nT
         QDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763132592; x=1763737392;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iOYDk4ou20EqC7hKmauaNNsT/2lLPOblXJ8i+jliwUk=;
        b=EZlqsZ/c3R7Zzb4omZxBQJMbri7Ztnx29WfNxi2xcIfZ5TukmWmPR6XKbPEk+aRx+g
         Q0bmejhhhKel4YwUler+f1mWBt0gC7ql5CL8GBc0w6gDeHyvfbuJ9IVq2eh6uJ12ThBb
         thRt52Txz8qXFZN2/6jxaddNGvLtMzwM1/Iqa+QqgiN5hTNs0S+fcIXtRszpgds04lpW
         ZonHmCIAP5V05dkemAvH+Q+WcBuFpI4KYpm4icSvf4YQCDRDX3zTHY1D4gZRpW+bLerK
         tC2EdmuBqH52fMxzC8uvxUi2/5FvQbf8+u63aanJkL7HZ+91Su0Q12ISwRwuynN0HsJ9
         P1gg==
X-Forwarded-Encrypted: i=1; AJvYcCXDQHinilPrhnPfcQOQhYYTybgoPuMjpf0Bj8cpongDuLM8N7JN/K8C3bGx1jNn5yk5xj9vkhFhYg==@kvack.org
X-Gm-Message-State: AOJu0YzEjn1IID8v0tFPgtgm95cqBf9IPbUXNPDH1zgLI9Z4T1fqDu48
	zbXGJTYMLLYCQzkaGx/4RSp2e9ktc3XFImi7SPWHJsR5gvEbuh3w7wHc
X-Gm-Gg: ASbGnctb3K3NxrpFuqIebiEMuvwx6bunTqyeX9hfsVuI2/wQiHIdLLbmaRBmrNPBe/S
	PZnuWGnoM5l4zD6MGw+ueK5b0iBYjeJAX3S8kd5uStdgFKYU7jJMAeiKu5lU/5V073XcXwRImdI
	F9UA5HxZ4l8Q55ZKiLnyHDj6HoT0NNQSPy8IFHwxsknjxOFwvEJyLRxBHxS+l+cK6UBwXzfxJea
	qRIsSYwQ/gg659lcy4tBYcglauVdfFhNSrSyeiIFB8fzsbDlANjNCWI7EvHEIiYqKwP6Owm4FkD
	p3H6WL9xPC/hpLGBMPQm8KGmt6UdxNOiSvJns30SbPeAXVi8azVesZexwslg+hiAcoVT+s5N33n
	3rnXMjaq++xgUDvybPo9A2gHG8ShSQVIWUPB1TdQHHZ1XVfIL9j1LF0YRhlhqXdIYnWgeizmws7
	ZQqnQoNQgXmQ==
X-Google-Smtp-Source: AGHT+IGH0s9XHBLuAtaFLcMQ3m3V7Wq+tDkgRfw7zp8iVQdntkDjq9dsYOuRcRi5vUPJBoTSJooU+g==
X-Received: by 2002:a17:907:9622:b0:b73:7280:7821 with SMTP id a640c23a62f3a-b7372807e5emr181589666b.60.1763132591939;
        Fri, 14 Nov 2025 07:03:11 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad4635sm405154766b.26.2025.11.14.07.03.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Nov 2025 07:03:11 -0800 (PST)
Date: Fri, 14 Nov 2025 15:03:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, willy@infradead.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251114150310.eua55tcgxl4mgdnp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: B642540016
X-Stat-Signature: gsas43ozyqcpwcn67kgikjbq48brkayb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763132593-190647
X-HE-Meta: U2FsdGVkX1+iOc0R6twI6t84qsisARYf+R91D5+f13Xg5p221ni+aSEO7+rclC1frBB277bpoSCW3fY8R1kM33OS0pq103ibj1iUAD+w1UfYVrS/ZRylXz9qe1XWuJpZkcHPvA8ai2Fvv2Vnk8oGmdz7A8FnnX2c9Lk5uXrHepb49MFT6EYrslvlbJ6W1wN8vWWmocbTyCCPgpZ8so8JO8SG9jzdymYqMdjWIkgQVAY2/KHR/Mu34zMkTW3WknExclGLOLjw8x7bE6iv0OfWTVoCEToEi/ASNgoBVx70VH+14+E5oA5l4bEGNor8DqgcTZ5AI4EAbpcNoJmI9GyKpNdtB5aJlsyR8Dg5bGLnuUya16QjcSQ8w6qxR3bnDbIafgkKKv9ZlD2kpYBPqZ9jEE6RMtgmvy7wMeXn0ITjWOujpYv+STD4Pm0Ba6LiX1GVXNT4YSr8zwysXy3c/5Z/PUXScwRTt4HDlnBtgHIxGiNigFmxpWZXodoX07YQQxyT4nLBFNHUp4OTiUjSa4PxX/gJcRtoVEn/ohWaKfKXYu7iCbbUKjGtwn96pJo3MdOw3J7Ejpj369/hS5NCnNDiAztMGIsyUq37guen8TmCt7pimiLyI6NJigAmYzCo8ObizpddfKJFzXB9IROWG3oxLQRzd3b0r8ywsFwJy1KfAeW9Lpxiy9Fb8g15VrbmL8Z78HiHsb99oZRA+JpQJFjtecX3z25CVm5N9ZZbqzn5ueYAqTNW1yRXtkUil4K+a1n8X3TuABNbXGk7UExmB01XBbKNPZryorI8niMKcZf32kme9ZRNOly+rJMVoUQYdtcIMlyKzYVaFJvtaTuFA+qN4vIxvnRJVCYtNn34VLaEeGrGGcax68p3qBmjtQ5qQcvUCN4kOehw834txUOV0ncBfQJrm0dKWUhKt3qmDX5iTOrH9KUr8JlCAOl4WR4ZheAH/uKjJ3DIgkkKSY8K2WO
 /5Mu7QUh
 cdAxzmMygVk7DCrmf+pplUx4I39AwGPskRhpkUfioT3oqhLS8qjDIBEuLe2VVK4CJys98/lCD65mWJWtqmNPzEFmNerFzDKCJsSVdMBD8eXMMjpbFJzSOdDOMLsdLT3YFaFYn55Yd6QZAdC8AO6HiMzkTZ1dWMnay1RkZwFHBguyWjvl6WTumJn1svdblcfrcleTuSfCLQROoS8ggGt3G8kEzQ4UbS/7Y+D1Url9Kub0n2Bd8+08gJeWs9TRxnSLiD6T8l8TJYqZpnZ915RjBeHPahzqlzMdOa7Wmr9wSSIy4NgUF3uyMmatDnkzTDdsTtc3e9KJfnphm8XvR2JfpmTzOWL35Ni9ZLUClvrNrcHcZVkqbww1j4mjxaV3t6eJBXm2Tepds9fiW20vj2PoKvsIshmrq9yU9aalt6U5vlAwKEz6KZyrlmRbslf2cn6OkmWG3Exczu0LZMCuvsz3Tc53FyaN8lZQxtnT7fYuV7Y8Oz3sWgJg1D9v1ZZBF2UhB9cjjPRCi8CtcqmaTKSFjxoaBqzm2HvW7AAScPiW8MhMpcJ3rdI8zvTN15zd3xK3vxgoz9p1XJTrVePB7VxysxwD2X6UnX9bUQq5oXMaPjMQK6iHNDCnAPQn5zrNAavTAYZFyrhGTa6X7A2oc/af96xq3Q/FSlskadhsaEaH5Dw9WARs+AJMX/jCPM8RQJIZN8H0eFKx58/xmyV2XcbSh2mrB4On0gi1od/OSd71I/GaCQKmBJ4m1F18xZOU+k07fW52ps0jo7jTEqohx8m7eLsJB2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 09:49:34AM +0100, David Hildenbrand (Red Hat) wrote:
>On 14.11.25 08:57, Wei Yang wrote:
>> The primary goal of the folio_split_supported() function is to validate
>> whether a folio is suitable for splitting and to bail out early if it is
>> not.
>> 
>> Currently, some order-related checks are scattered throughout the
>> calling code rather than being centralized in folio_split_supported().
>> 
>> This commit moves all remaining order-related validation logic into
>> folio_split_supported(). This consolidation ensures that the function
>> serves its intended purpose as a single point of failure and improves
>> the clarity and maintainability of the surrounding code.
>
>Combining the EINVAL handling sounds reasonable.
>

You mean:

This commit combines the EINVAL handling logic into folio_split_supported().
This consolidation ... ?

>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>   include/linux/pagemap.h |  6 +++
>>   mm/huge_memory.c        | 88 +++++++++++++++++++++--------------------
>>   2 files changed, 51 insertions(+), 43 deletions(-)
>> 
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 09b581c1d878..d8c8df629b90 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -516,6 +516,12 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>>   	return mapping_max_folio_order(mapping) > 0;
>>   }
>> +static inline bool
>> +mapping_folio_order_supported(const struct address_space *mapping, unsigned int order)
>> +{
>> +	return (order >= mapping_min_folio_order(mapping) && order <= mapping_max_folio_order(mapping));
>> +}
>
>(unnecessary () and unnecessary long line)
>
>Style in the file seems to want:
>
>static inline bool mapping_folio_order_supported(const struct address_space *mapping,
>						 unsigned int order)
>{
>	return order >= mapping_min_folio_order(mapping) &&
>	       order <= mapping_max_folio_order(mapping);
>}
>

Adjusted.

>
>The mapping_max_folio_order() check is new now. What is the default value of that? Is it always initialized properly?
>

Not sure "is new now" means what?

Original check use mapping_large_folio_support() which calls
mapping_max_folio_order(). It looks not new to me.

If my understanding is correct, struct address_mapping is part of struct
inode, which is initialized by inode_init_once() which clears flags. So the
default value is 0.

>> +
>>   /* Return the maximum folio size for this pagecache mapping, in bytes. */
>>   static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>>   {
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0184cd915f44..68faac843527 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3690,34 +3690,58 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>   bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>   		enum split_type split_type, bool warns)
>>   {
>> +	const int old_order = folio_order(folio);
>
>While at it, make it "unsigned int" like new_order.
>

Adjusted.

>> +
>> +	if (new_order >= old_order)
>> +		return -EINVAL;
>> +
>>   	if (folio_test_anon(folio)) {
>>   		/* order-1 is not supported for anonymous THP. */
>>   		VM_WARN_ONCE(warns && new_order == 1,
>>   				"Cannot split to order-1 folio");
>>   		if (new_order == 1)
>>   			return false;
>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -		    !mapping_large_folio_support(folio->mapping)) {
>> -			/*
>> -			 * We can always split a folio down to a single page
>> -			 * (new_order == 0) uniformly.
>> -			 *
>> -			 * For any other scenario
>> -			 *   a) uniform split targeting a large folio
>> -			 *      (new_order > 0)
>> -			 *   b) any non-uniform split
>> -			 * we must confirm that the file system supports large
>> -			 * folios.
>> -			 *
>> -			 * Note that we might still have THPs in such
>> -			 * mappings, which is created from khugepaged when
>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> -			 * case, the mapping does not actually support large
>> -			 * folios properly.
>> -			 */
>> +	} else {
>> +		const struct address_space *mapping = NULL;
>> +
>> +		mapping = folio->mapping;
>
>const struct address_space *mapping = folio->mapping;
>

Adjusted.

>> +
>> +		/* Truncated ? */
>> +		/*
>> +		 * TODO: add support for large shmem folio in swap cache.
>> +		 * When shmem is in swap cache, mapping is NULL and
>> +		 * folio_test_swapcache() is true.
>> +		 */
>> +		if (!mapping)
>> +			return false;
>> +
>> +		/*
>> +		 * We have two types of split:
>> +		 *
>> +		 *   a) uniform split: split folio directly to new_order.
>> +		 *   b) non-uniform split: create after-split folios with
>> +		 *      orders from (old_order - 1) to new_order.
>> +		 *
>> +		 * For file system, we encodes it supported folio order in
>> +		 * mapping->flags, which could be checked by
>> +		 * mapping_folio_order_supported().
>> +		 *
>> +		 * With these knowledge, we can know whether folio support
>> +		 * split to new_order by:
>> +		 *
>> +		 *   1. check new_order is supported first
>> +		 *   2. check (old_order - 1) is supported if
>> +		 *      SPLIT_TYPE_NON_UNIFORM
>> +		 */
>> +		if (!mapping_folio_order_supported(mapping, new_order)) {
>> +			VM_WARN_ONCE(warns,
>> +				"Cannot split file folio to unsupported order: %d", new_order);
>
>Is that really worth a VM_WARN_ONCE? We didn't have that previously IIUC, we would only return
>-EINVAL.

Hmm.. it seems not necessary. Thanks

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

