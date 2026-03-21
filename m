Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749A01094474
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 13:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509396B00B2; Sat, 21 Mar 2026 09:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4932F6B00B3; Sat, 21 Mar 2026 09:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35ABE6B00B4; Sat, 21 Mar 2026 09:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21C186B00B2
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 09:02:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDECB1B81CC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:02:27 +0000 (UTC)
X-FDA: 84570083934.19.AD78067
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94AC2A0017
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:02:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UmVHNct5;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774098146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJPULCri2DdVUmJbTlU4Rxn6JWleCj28Q+e1h/YTmMM=;
	b=hjd3qSSmUyd4o+AYYbrcEw+YCcThxi7zCDhq9QWBqc5ptcVrfj4R4mmMDX9jjhoAJmb9Ui
	SD/U5Sxr66Isd+FsK0rAbz/JDABhR0PWJ/BxCyniPuOZqmSL2taf1rkEhPTO7KVQjwxCe2
	7wfqcbS8uJfaGW2VlWDdkewDCkpR7zA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UmVHNct5;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774098146; a=rsa-sha256;
	cv=none;
	b=d8J0VpFT1BRW7xgmHhBaK/sRquV8yeINkwNPdQDQE9uHuNhytEq46poNVHFdPxgNfdvuFh
	5ZfbouiLPf40Gf74dfx5YtBaZc89MYnTTtnfW5zyLiJQteSTE4ORKDfr1EJPWcmT7Z4ixK
	yC/g9FhfJO/By5kXdgQfUmpNTOGsLDc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774098138; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NJPULCri2DdVUmJbTlU4Rxn6JWleCj28Q+e1h/YTmMM=;
	b=UmVHNct5cOhiSHITDMIXaJJkmaIHU6daykWM8FmRQAgEim0nj6G4CkltqCdO0Q4L1K+SF7Nv2Rjs3XWeWzvxSwhqIQydbDlerizI5e6oALVDpI0gI53Fzus8f2ON0vJ4VIWEIJWwZ79OF0GGapXIcsK7L3PQZqePvDjyjHFXfqE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.Ombip_1774098136;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.Ombip_1774098136 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 21:02:17 +0800
Message-ID: <bf36511a-92de-4668-b83e-08cf6f2a6ace@linux.alibaba.com>
Date: Sat, 21 Mar 2026 21:02:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] change young flag check functions to return bool
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <bjghychf.ritesh.list@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <bjghychf.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8998qsaegzsq6nyg7utnzweqwkxzj9rn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 94AC2A0017
X-HE-Tag: 1774098145-913585
X-HE-Meta: U2FsdGVkX1+oFUvlKo0/c9UIKTQzYZld5zdLm+9JpiOn41hGG9a+OSDtL9cfa07t/bZu5AlkBlv80BtZt/kfMDK400sC60jKvHPP8LSCRZDBwbGqLAkNbR/Vi2zDl9VRAHQa4tretmvgVTxSLD4gtKCsQsXiEX14qO93CKacujFqVHZNgp7Wcygmp/65SN1GCERIS36DlPy+zylPAIPBKz5E7WqmpIo1zhN4CvBEJJm40yQSUg4AAAMH3cgF+NQvsD/yfk6lVNccZXMTSXEPxeLoA4YrS6eNu4RT4S74JNKC7mTJ4QvPRZxwOsmQ49PAT8hrzcdfpakKx5UjBqDxPooaif46oS+2nnqiLBcjDQsZmx7IpxkpTl0tvq3ogHjFiBtZ1U6+5P0etDq2q3k744LfGa7Tk3v7v7KTjw06cirKCi0lfNl2RNDT9FIkznXIOC7FrHca7eAgpPOTL2shcKeS5cOaglWF65E1wfnqoeC9tU4EiIXduti0az9WNPsuTon86NxfdW/qenmjQO0OAVDE+CM1o5X6/1GGkUpsMxl1olteQ46cqg+oh0wGPFPbm69Yoyz4qhjGrR5HyqreRQe2I9K7CukpJtT5WHaiq9AwFEiRBUP9MFbQyG7eFuWXZP6ICVcKWUOOyDeU6nXzT0y3gyi1+5fApzpd6eD2XEORebe7IvtlhgIeg5Gh0Mxju1Y+XohJjvkyEFspyuTplTKIRTz/jKY4DQ6Er1FgWyejhkWDPDpT5MaxLhYWO0QauwR4Hme3zrdes1fT92p8bBTh7+QrQFAjCj6+Oa9fpJQcka2dtw9pEH5xNFraJxty5DOHZRYAEpgu0YukTYjvAbOj1RBepIMPGgJ4vR7bjP/fWP8N7lkU9a2b21NKWBFOQFR2xgEflzfjW87Hl4GkPoloxjI4xdbSZIfohWh/XHqQ9eOsAPY86OjdaYIlNZo3qs8CsCkCqL4lMCqZJHm
 AYZ96O7d
 3yDisXHGFsTqD2oWlzzd2udMKdgeY0KA7uRtNexJJLFGHEpw7/eQ8sCkyhYnmAxbCQVbRgB/NynyXpp7R6eCH+2PWp02eN8GDyzx+QMKz16Qvy4MMKQiNW+MbUYcbVRCYR/IC5wXeyijkc0lHUWMZAgGOIwgF0ZrHJjO++PhoI/t73wvKh67ztPmG1OO+/H8YiCwlZ1JaWZVvrTOT8GwjYo3bIfqVjznVV3I8KnXzo0tqWztRkQz14kWC1YAN+mrXBfJd2Pdbuy83gztNIOlnMBFc82wCTSxEZCzLwb90Xo4tyJLvCTfYEWsMHazdU6zNPscQQFMYiZhamHpeW/gsboYonfcG5fSVTHOU1NVW6fX4eSeRO53IBFiEh/ra8FIdJAg99Q1NCfy5+Ixkme+DYBIK1UgkrrSFS4aERCf4UvbETuxC7GcedNoNLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/21/26 1:31 PM, Ritesh Harjani (IBM) wrote:
> Baolin Wang <baolin.wang@linux.alibaba.com> writes:
> 
>> This is a cleanup patchset to change all young flag check functions to
>> return bool, as discussed with David in the previous thread[1]. Since
>> callers only care about whether the young flag was set, returning bool
>> makes the intention clearer. No functional changes intended.
>>
>> Ran mm selftests on Arm64 and x86 machines, and no issues were found.
>>
>> Note that I only CC'd the arch mailing lists to avoid disturbing too
>> many people.
>>
>> [1] https://lore.kernel.org/all/d172d6bf-c60c-4cf5-9da9-f30de38cdfed@kernel.org/
>>
>> Baolin Wang (6):
>>    mm: change to return bool for ptep_test_and_clear_young()
>>    mm: change to return bool for
>>      ptep_clear_flush_young()/clear_flush_young_ptes()
>>    mm: change to return bool for pmdp_test_and_clear_young()
>>    mm: change to return bool for pmdp_clear_flush_young()
>>    mm: change to return bool for pudp_test_and_clear_young()
>>    mm: change to return bool for the MMU notifier's young flag check
>>
>>   arch/arm64/include/asm/pgtable.h             | 29 ++++----
>>   arch/arm64/mm/contpte.c                      |  8 +--
>>   arch/microblaze/include/asm/pgtable.h        |  2 +-
>>   arch/parisc/include/asm/pgtable.h            |  8 +--
>>   arch/parisc/kernel/cache.c                   |  8 +--
>>   arch/powerpc/include/asm/book3s/32/pgtable.h |  4 +-
>>   arch/powerpc/include/asm/book3s/64/pgtable.h | 26 +++----
>>   arch/powerpc/include/asm/nohash/64/pgtable.h |  2 +-
>>   arch/powerpc/include/asm/nohash/pgtable.h    |  4 +-
>>   arch/powerpc/mm/book3s64/pgtable.c           |  8 +--
> 
> I did compile and boot test on powerpc with various configs and overall
> it looks good.

Really appreciate your help with testing!

