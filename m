Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A66AC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD2C6B0099; Mon, 31 Aug 2026 09:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E4F6B009D; Mon, 31 Aug 2026 09:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE096B00A1; Mon, 31 Aug 2026 09:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D149D6B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:04:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61AF2A1F92
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:04:30 +0000 (UTC)
X-FDA: 85161583500.24.DD20B31
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf30.hostedemail.com (Postfix) with ESMTP id 801F48000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:04:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ggqMHMEV;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788181468;
	b=4hY43k+zurky6T7MHhL1yioGNewRqFWm2p6C9RON3+jKi0QmeSTSOvFJGVaeGXSZGmUjo6
	LR/ShnTaBHruTD4mvJogi+SulGfAGp5GaGZGil51kZ8SSYVbGe80XO+h64/TcDUs2HFxvR
	F1flRSTbmKkMjToDLN+oG3ZDSFtdv2E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ggqMHMEV;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788181468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXjjK4cQByHA+0LozWy93yMgZYx3/ZFKSUZa+XbHMGg=;
	b=C/sH8d9+JGiYB2MInRv22ik4TxSzicc/Oa6SA1R2wbBmLRSiqJURTJuoMCgR7RkEuCgS5z
	W2YD22vGPuaJ4IaYtBZOQZ5LQnbDNJD0Rw00HvBFmOtj3KGpx1xS1gMsICDPiPPJFKq13N
	2Q+X54Mhie74Dch1+9F7xJUHDou1tc4=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-396bf83d458so1279702a91.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788181467; x=1788786267; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXjjK4cQByHA+0LozWy93yMgZYx3/ZFKSUZa+XbHMGg=;
        b=ggqMHMEVtcjJ0pWigRsCBM+OI0lzO52wC7IAg6TxdiNrTkuzlPRIEeiIqx+EussVru
         gesUBAklnoqHKVao6cgLa30lnyq8c13uqg9UKTwlBrk4E+SV4GI8ccA8xk1kr8cDVl/A
         19FYAxIzUxCRKPzMFoljyJH9rVF1dPaFOipVGhw9i8vCfOOpi4/+ET6d3S8SNxvb2a10
         +eeHpgmsjFiVGMlojEyZl8n5mK6yOPKhq8MpfpOgNn4qj4HMgy0ENUD65m5nhcSYD6E9
         PR6fdNdeZ3lR5MKYdKCHw08hBBINy4Vo1ndr/rAaO+Gsu8xUoGqheymzNgOhpX9DjX5Y
         bTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788181467; x=1788786267;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VXjjK4cQByHA+0LozWy93yMgZYx3/ZFKSUZa+XbHMGg=;
        b=PeCR40wATgfHdwSEyDE4lIGSY0ToAmhljyQBTpYXBVoClbTK3ihyNLELQgPhdzbtQd
         b/gpg63uW/cU9UtNH80vSuNGe58J6nBcGDChb/IEffL3wFGTRllp2H73vwzFICRtJf++
         xyYcaTbUJk61k68OnHtZGDZfcstlAJiM9bF3bYB6TuEmQ/ifeZwmnpWZ9IwMcFPQTxXa
         zY+7MYUJpWGnfOST1Aq15ij88vdZe7IUiof6Fo17SV4fou+z8n3Guo6xqTWkJTey/8C2
         kLwrmfC3tjxfcDwRk04ERkYKfjXik+rnfJ90aPc9HsCsa3NjwZxA5LI/G/dVErqUcdrS
         1+Wg==
X-Forwarded-Encrypted: i=1; AKwUvBwRVt+ffycg1NMP/OTbkrFTYZAdHyg7JRQT2uxuG7e5msqpPJCuVufPri9tmctI6emzl2Cz2s/w3A==@kvack.org
X-Gm-Message-State: AFuF++l8vJLiED725Q7KH5fTtl6l5yo4c6qM4Y112XzQNIOjobDzCspq
	N55q8dzao1aG8XWmfkQOyVTs7zl2MD7lKZsK71bvpR0qIBj0W8KcgWEN
X-Gm-Gg: AYBFou2Ecb4EQloZC20P/A+OTSn+gW4czceaYViRb74Lwzh2Lmy2u8RkdV9ZNqr02B0
	JGZx6zQihjgeN6K75hkwIY/I+Uc8axa1fkhkPDwZ9WMsgZpwA7uKjPZ0EbVqUlNvqALKCoNxPQj
	o11XN3S9M0fadW0upd07zzBXWcd1ThI9ZG3QmOmJHBgJKVO2udnaW7dhbiAfYJH3LeaSUhcTeRi
	ZMEzRrEIkh+yaYAvdYbbXrQZwlFnyguA0FOLHMiyvwt2ykc26kYnmGZRtjSPo+gDdEfG+1hDTwo
	r8XFC6BTT0/Odjh7ZhdxRT5f7eCeJqM1aFQN6TLZg5y4VtEffUd3ecFefrJ91KKn/v+UzCuqewN
	GmcjUBrqPr2fLwJdSd2ueZ20lKYqMvV/v+I04Ealy8jYcA3AU/uRniRv1vcsDuUSW2mbaCv8CzY
	DL/814xREP8vddYCNX/pQuhKGyfJchC3SqUGsVlPSeSBT3kl7EzPD+Lc/k5S4YmefOti7HRxoIE
	fRJrg==
X-Received: by 2002:a17:90b:2888:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-39907ab0ea1mr1000718a91.4.1788181465569;
        Mon, 31 Aug 2026 06:04:25 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396d6d29de3sm4981354a91.2.2026.08.31.06.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 06:04:24 -0700 (PDT)
Message-ID: <af87036b-0809-4880-b088-545780b4d963@gmail.com>
Date: Mon, 31 Aug 2026 21:04:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] of: reserved_mem: skip init for regions whose
 early reservation failed
To: Marek Szyprowski <m.szyprowski@samsung.com>, robh@kernel.org,
 saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
 <CGME20260818092438eucas1p20115e5d33908e32ef4433cb246da8098@eucas1p2.samsung.com>
 <20260818092420.2859026-2-chenwandun1@gmail.com>
 <72074a49-2963-4f96-b939-79bf95a829cb@samsung.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <72074a49-2963-4f96-b939-79bf95a829cb@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ciy85trggx4nkqxpshrxepahs4oq9n54
X-Rspamd-Queue-Id: 801F48000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1788181468-529548
X-HE-Meta: U2FsdGVkX18Isnh7ITbvGoqCBTCWdvkR25LHxaonAYi+MzDGKLNB1IFWM1td+GwzBomGqHeTM4mq/Ui5u0oa6ITyA6aTUBN/R1QHkCC4wQV6okLec3JR5Mvmg+H9TQ8qMO6XFpREy0DNCWm7bgpj//TKJ2au+HqzMYP7wP3SkfSn7LGUxC28UucR0YMsjj6m8gZUJAt1TChFXQgUTUhCFTv/dRZd3N58vsy+V7ax1d/VVoCFl5bnKT6tyoCH04qiTSdULoiqRxXE0YrI1RLFl6gJ57Bhk018Asa34yzUi1bH/3l3D+KifyaYZT0Wp8Hu2DooDg2KZUFyT3IJlT5Vd88HWC5vJ4JxzdlRXsLh7KoQ91NCLzl+KyvCllJcjy9G47eYpEVCGajq51cGhut6PzddLgix5rm5CmiCKHFPPbF3vKnnwQV6lP5U4vOoZuWrnkqSBMKyX9neOtJ9L1Fb+vDKBgRHBKoeWBjR/eq/2enSvnJX/8yxUxUGccjZ8pg/wGDwXDP58AnlDH3H4h0kmbKeVHA9jgpidJr1Sgmjcq/8VAle0b+2qjF4ES5W1OQxvDypIvzPdfRCO0BjUc/o/SUqbV3T83kuLQu5Cl8gx0WhCMk57Wd71LcjW3+zpxkJ1KmgW0oizAWP60lAbpNI2CbZXMa8PRplAZWVc2lJoCDrDJ4G4aUeUkZlQ5tKU6MXL2KDaE8h2eZSt7oYGXM8wyHXevbF+bd1HIElBSqnkYoxIVrj6pa8BDP74QOkqHCOC7U9vKm/eKOB3DnBi9WNiZrRvcP9r30sNRN0leRrLrHi7wfFP+812V2oCn5qCpOCKjTzqcBPcL7bL5I7zBEoe2+kHdOWFJKE2M+mB24ZpeN9zOWDcCfPWF6IgpIxvfESuEDGWzACs14xbkDzLoUHDTGzKywB3+43rfIDcyzCGusWQ3dbv09eKJwZ3HIB2hqSQbA244zTN7BgBE3zO7O
 KJkVb7yz
 pjMHInhI9sfHqht6Cz8Chn+CvxTrVfl5P7ZyYStsWzbDN+2baUtxuATYwt+0uSuTMk6IjzJtyUNk5o3ZTUypPTeVCOaqVzrQDfzl1xbJLkvbXZnUKuciOXn3yBfImlrkRSk1xsyD41FqJfn/185wHuoO/k7OO+8haBL21N4D+KxciofB+WMzWcJpcs7KqBihtJI/+ndy/O+J7FRBNB/sD3snCBHhRmhpvAI8GKqTa7SEKJZdiABefFCiTvU59Jjm0ok6zv1OZ1+02DeLt5upVcx6wqDQd+iTCDV2HsTEV0XB29KChyD0jdBWQGrWL78vI4O3g/tVgA+rMTkXjHTxDcqMJbDTKeBJI/B5vnV0zjZ/MZgCXX7c3cAvugDZ25T51/807hnFrXRE9eKCcJ2mEUdtBAtXb5XhZmxngru7f446ND/BZofEJo+OUHP/GfTpQEsCNGaGy6Kce/8vhC5LJe7uimdN28oRPKls5kmCvOoq0JhgjDle/F2AZ+k5XbALiK/gmcIEoHexuoESl7ujrvsalJ80echYpYXpYNs9kHImicMcM8MjZgZn5NJfe92dav6wM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/26 21:14, Marek Szyprowski wrote:
> On 18.08.2026 11:24, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> __reserved_mem_reserve_reg() discards the error from
>> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
>> caller counts the node in total_reserved_mem_cnt and the late scan
>> initializes it without checking whether the early reservation actually
>> succeeded. A region whose reservation failed is then handed to a
>> device assuming the memory is protected.
>>
>> Propagate the error so failed reservations are no longer counted, and
>> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>>
>> Recording the failed nodes explicitly is necessary because
>> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
>> tell from memblock whether early reservation succeeded.
>>
>> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
>> of static regions is not bounded by it, so on overflow the extra nodes
>> fall back to being initialized, which is the current behavior.
> 
> I'm not very keen on such partial solution. Indeed we have no place to
> 
> store the result of the early init call, but we can check if the given
> 
> region has been earlier marked in memblock as reserved or no-map in
> 
> fdt_scan_reserved_mem_late(). If those attributes don't match the
> 
> region can be simply skipped then.

Considering the later patches that reject reservations for overlapping
nodes, checking the memblock state in fdt_scan_reserved_mem_late() may
produce false positives.

For example, if region A is reserved first and region B is a subset of
A, reserving B will fail because it overlaps with A (in patch 02/03).
However, during fdt_scan_reserved_mem_late(), B will still appear to
be reserved because its range is already covered by A. As a result,
B would be initialized even though its own reservation failed, which
is contrary to the intended behavior.

Best regards
Wandun

> 
> 
>> Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> ---
>>  drivers/of/of_reserved_mem.c | 65 ++++++++++++++++++++++++++++++------
>>  1 file changed, 54 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
>> index 8c9d6395d6a3..c6e73d710ee1 100644
>> --- a/drivers/of/of_reserved_mem.c
>> +++ b/drivers/of/of_reserved_mem.c
>> @@ -32,6 +32,30 @@ static struct reserved_mem *reserved_mem __refdata = reserved_mem_array;
>>  static int total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
>>  static int reserved_mem_count;
>>  
>> +static int reserve_failed_nodes[MAX_RESERVED_REGIONS] __initdata;
>> +static int reserve_failed_nodes_cnt __initdata;
>> +
>> +static bool __init reserved_mem_node_reserve_failed(int node)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < reserve_failed_nodes_cnt; i++)
>> +		if (reserve_failed_nodes[i] == node)
>> +			return true;
>> +	return false;
>> +}
>> +
>> +static bool __init record_reserve_failed_node(int node, const char *uname)
>> +{
>> +	if (reserve_failed_nodes_cnt == MAX_RESERVED_REGIONS) {
>> +		pr_err("too many failed regions, '%s' reservation failed\n", uname);
>> +		return false;
>> +	}
>> +
>> +	reserve_failed_nodes[reserve_failed_nodes_cnt++] = node;
>> +	return true;
>> +}
>> +
>>  static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
>>  	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
>>  	phys_addr_t *res_base)
>> @@ -141,7 +165,8 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
>>   * first entry in 'reg' property
>>   */
>>  static int __init __reserved_mem_reserve_reg(unsigned long node,
>> -					     const char *uname)
>> +					     const char *uname,
>> +					     bool *should_record_failed_node)
>>  {
>>  	phys_addr_t base, size;
>>  	int len, err;
>> @@ -149,6 +174,8 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>>  	bool nomap;
>>  	u64 b, s;
>>  
>> +	*should_record_failed_node = false;
>> +
>>  	prop = of_flat_dt_get_addr_size_prop(node, "reg", &len);
>>  	if (!prop || !len)
>>  		return -ENOENT;
>> @@ -167,14 +194,20 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
>>  	base = b;
>>  	size = s;
>>  
>> -	if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
>> -		fdt_fixup_reserved_mem_node(node, base, size);
>> -		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
>> -			 uname, &base, (unsigned long)(size / SZ_1M));
>> -	} else {
>> +	if (!size)
>> +		return -EINVAL;
>> +
>> +	err = early_init_dt_reserve_memory(base, size, nomap);
>> +	if (err) {
>> +		*should_record_failed_node = true;
>>  		pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
>>  		       uname, &base, (unsigned long)(size / SZ_1M));
>> +		return err;
>>  	}
>> +
>> +	fdt_fixup_reserved_mem_node(node, base, size);
>> +	pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
>> +		 uname, &base, (unsigned long)(size / SZ_1M));
>>  	return 0;
>>  }
>>  
>> @@ -306,10 +339,14 @@ void __init fdt_scan_reserved_mem_late(void)
>>  		base = b;
>>  		size = s;
>>  
>> -		if (size) {
>> -			uname = fdt_get_name(fdt, child, NULL);
>> -			fdt_init_reserved_mem_node(child, uname, base, size);
>> -		}
>> +		if (!size)
>> +			continue;
>> +
>> +		if (reserved_mem_node_reserve_failed(child))
>> +			continue;
>> +
>> +		uname = fdt_get_name(fdt, child, NULL);
>> +		fdt_init_reserved_mem_node(child, uname, base, size);
>>  	}
>>  
>>  	/* check for overlapping reserved regions */
>> @@ -349,6 +386,7 @@ int __init fdt_scan_reserved_mem(void)
>>  
>>  	fdt_for_each_subnode(child, fdt, node) {
>>  		const char *uname;
>> +		bool should_record_failed_node;
>>  		int err;
>>  
>>  		if (!of_fdt_device_is_available(fdt, child))
>> @@ -356,9 +394,14 @@ int __init fdt_scan_reserved_mem(void)
>>  
>>  		uname = fdt_get_name(fdt, child, NULL);
>>  
>> -		err = __reserved_mem_reserve_reg(child, uname);
>> +		err = __reserved_mem_reserve_reg(child, uname,
>> +						 &should_record_failed_node);
>>  		if (!err)
>>  			count++;
>> +		else if (should_record_failed_node &&
>> +			 !record_reserve_failed_node(child, uname))
>> +			/* Keep a slot for the untracked node's late initialization. */
>> +			count++;
>>  
>>  		/*
>>  		 * Save the nodes for the dynamically-placed regions
> 
> Best regards


