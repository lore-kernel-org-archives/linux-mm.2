Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA95C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C59E8E0009; Thu, 31 Jul 2025 09:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C798E0001; Thu, 31 Jul 2025 09:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2AD8E0009; Thu, 31 Jul 2025 09:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7868E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:12:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E47F1BB514
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:12:52 +0000 (UTC)
X-FDA: 83724599784.05.531F13B
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 07CA2140007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:12:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaaTqCh6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753967571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqqlX6H3NPp9rTTwA7tpGQOcaxAxM3NcsBHKv6NCffQ=;
	b=rIFyCKRypKrYcPnCG/kfnW365bVd+dbbUkXJpdrSKW351hTzQVC1nBfK9/cjCh7PZlet9T
	2zbZI0HHPCxT0wReYRP1LLaimn2KL/7wmt9iE41PRcQVQfJa4xFL//+BO2eYgTMDDsJynl
	iWDS3qUanvfOv/VHCzDdnFCsCyo5abk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753967571; a=rsa-sha256;
	cv=none;
	b=bxaYjtJrSuQlSIDCm7zJrfdB3LdiwRmsXBIJeiLmM29xRmD6Z9HtA9RLmRC4DSnQBVS6F4
	3t8m2WwLSs/NFTC1E48/E9zWX3rGkSztx4w7j4meb1rYqdkn+I6oQxkJlQQNT09Al1KZLq
	NfYyWySBW0O63nLlFDKM4/PE8N9d9AU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaaTqCh6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b790dbb112so287745f8f.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753967569; x=1754572369; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AqqlX6H3NPp9rTTwA7tpGQOcaxAxM3NcsBHKv6NCffQ=;
        b=eaaTqCh6+vxRDmEurK2J8bB6c0YxPPXuEHSdXOhfUz0c7fQbvb3VJlHN33w6wXv1RQ
         +4KJWZH96ZBf8kzniamCy9hjJaDmeKBcNm21Yc4rrbD3wsBzHK4pu3eI/7mG4GbrYIYT
         UperGQ5lqT67fHBtenw9ORPivqHzp7HzQpRIi0ndCtzCRikoJwMOKM1Ocu/VhE5Nl+Bj
         nP1Moy45J976kS7/MdPYyG3FAID1YZ8b+KeIATGCJBm5Z0ucC1u/V4SV/xN4JZgtzeB3
         eoWTJlnpPWjRhH7Ty2YKT8w15b9W5eb34h89vmWORpksa7Rcp2ImWUPCFd/BzVQfEAkC
         jctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753967569; x=1754572369;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AqqlX6H3NPp9rTTwA7tpGQOcaxAxM3NcsBHKv6NCffQ=;
        b=jEuCtd/HVg+xUpMwFgsYryTFRCNKS1CIrnxVozOYEuSrNhB+s1loEYLKAF9dwJAi/d
         icbRU9DXXq8kJGTx4O3WlEMlAanlZiJG7zQjws5xKpUeGNxNEnzwONz/iNOibLvPmjku
         dE3GgmcKwji7p03CfHHDCvfxv0ThuPpf3wLxWAzIJQtZs7NjQw5vu7qUF16iX3W25Fyb
         d8x1omLjOEabByemGoSmIfJHGs2uS40RFLZcOdXCXb4Prs+vI+60+GIWdfORtfp9f1y6
         hA0HOCcNG8p1PY686GrSInmIKsJK+3zrNdpVj95Uq1vBEm7OxKuS9w3TcAJThlR3hqGN
         iICA==
X-Forwarded-Encrypted: i=1; AJvYcCW+AikkdrZtO9aDkWNHjKkd/xFW8GKBuI+Wu4Ryr1euwph5+icMnZC5IsYQfyMY7NybRvRA4/fmRA==@kvack.org
X-Gm-Message-State: AOJu0Yx4VZFuboALLrSiQ3j14x1tOlUYd6s80bSWdt0ia1Zemqn7IACE
	VoTOl0fXvNZmgZk/C5cgZ2JARRxAvqywXzQYZU4w6grKvspzaXrRfcgh
X-Gm-Gg: ASbGncvAVreXsJ3Fx4fbN0DyBbF17WxUVyeFWt2rLViYEfKKCr4z5cH5JThKzwwnGMC
	7kTLepKl9WYuYLg3luoHKUWOgoY1zGbFGOtYEI1fjzHV3HEgyabS6vCjrgPlfS50aJNycrKD51a
	OJ6T42C4oJghZ6qkDsX5bOBdX5Hf4/oGknXBS2C6mdMtY4gF0UvTB5fwwZD6w1JpqOWKGxVpWg2
	lPBdX00oMHry1wckuuHbALHnNpx+ybeICSy+JiEZZ8z6Fp6HhqJmLP2Pk3uwuhlVsvJ2t0GlggG
	AQC3QzFdRCqaWo57cqg8M3EVQKlL0NMDoWjE4AP14+cDomWPm1CcoHZiYv3fe9Ud7n9upm1b7bI
	DRQYx2HqJ9LNC8Iu+QUK+y15fBbTi1EZa0WYMSn5HPNXLFVyakfZBGlorLKezVhZsZtWNToNn0A
	QoabXSVg==
X-Google-Smtp-Source: AGHT+IGD13KMKtVRmBQPVTq0wp4e/PMVr1M8WgWSZYRxA7tPP99Spg6G2qe4tDRrHVIXUfkLlzE9cA==
X-Received: by 2002:a05:6000:188f:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3b794fbe44emr5778988f8f.7.1753967569066;
        Thu, 31 Jul 2025 06:12:49 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::4:3f35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee621adsm27160265e9.30.2025.07.31.06.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 06:12:48 -0700 (PDT)
Message-ID: <c9896875-fb86-4b6c-8091-27c8152ba6d0@gmail.com>
Date: Thu, 31 Jul 2025 14:12:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Matthew Wilcox <willy@infradead.org>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-2-usamaarif642@gmail.com>
 <dda2e42f-7c20-4530-93f9-d3a73bb1368b@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <dda2e42f-7c20-4530-93f9-d3a73bb1368b@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ijjo64g4rnxyar118zrfrrazfya57e1a
X-Rspamd-Queue-Id: 07CA2140007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753967570-841210
X-HE-Meta: U2FsdGVkX19FuRtnr61fboVxO/czuMFGFTF0fHUMg7J5jqbzO7O+8YgimIjlCE68KK/F5K7ZGuIUSURzvaWHDoANyyY3XbF6CgbH3eWTueBMIed+mxgNbHonZphU+4gjzP98gfZlDTO2RoQZbEshj67eBm+nuwTvPnut/R4LkJ5tHQkUco3uH2jZ0tcG1cu7qxkMvUYCHki2ndd6QNJXneRJ8j2PoMEToUjKVpnzr6HbBVJ4gJNKz7Nz0FP8sP1jRf0+h9vPemCyNC64hMwLpfZM+c0FMuhIO4gmaFpRTdoAKGvLnZCtypM47FUcpq1884rZuZWcG2ZH1ViUi8PENhnDJ7xCD48xptWqw5s+4YbrP2s5MQI3h87soWEyj5DRXNQr/95QTS/F8wsismCW8deQY1HzaQKFAuyJEc1QfYIyoylXSFTRX1KRwLwBH6Te27zroCirIhr03oJeERAzF/KR4DpVG04V3HE0Pm+Bm3wqnvHQxYdU269WamzZMy0WN6l0zwCfEfE14mcTAj/KO1aEff1njwQiSqsLXE8pzsARttHZk/hkth15AhVFNKEt7lAUoZl3Ebqj9TzwCCHMO2aYaZx+SweWV7JB/+AZVSR9dkK8kROt+garqxBES/GfzvtBTXf2hgs/0a9v8iXXokj6d54le8ZPkNJscpF8DxCX+9CqKmOpQtTddaTMVOzpkks6vIv3fN5qZRoV7L7Ltw5DLwaurmH/woaulw+eRocgNQZ3vO/13gf9HwoaKsHVeVbAZ2l9oUjIY3nAF02wdJhSg1nXr2VPFh9+N3GZN00sDwfkdnVm1YecYpsCrorDbFExB4aoGvqglNg7huf3mv20BsU05zJjY+mnelkYShFjRmsAmqD+3ZJBIhsxvrN7kgwKsmXelaU7DbdivqBfh244fL+y83ngAvrhyn3OtwH7tPQVONTqGYBxLHeQW9U370KQYztP+DlMyPLaDYF
 S70O/ym3
 vxsKxbSKYbUU/Pyb87O4do8eNomBI7DK79WfC7HXLt7ZyAu+FZGM+M6qJTe44WghAjyqyKDkO0E6K4xtyrqkEsie2wLcdl+amfsuTjXG1IpJddCTNaSPHVGf1FiSRxzcbvwMbHd6e+mziGs98Pjx8TiqtbfxzkZe5I3Vboj0Qj0Kkb08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/07/2025 13:40, Lorenzo Stoakes wrote:
> On Thu, Jul 31, 2025 at 01:27:18PM +0100, Usama Arif wrote:
> [snip]
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>> Tested-by: Usama Arif <usamaarif642@gmail.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Yafang Shao <laoar.shao@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
> 
> You don't need to include these Cc's, Andrew will add them for you.
> 
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Shouldn't this also be signed off by you? 2/5 and 3/5 has S-o-b for both
> David and yourself?
> 
> This is inconsistent at the very least.
> 

Signed-off-by: Usama Arif <usamaarif642@gmail.com>

The Ccs were added by David, and I didn't want to remove them.

>>
>> ---
>>
> 
> Nothing below the --- will be included in the patch, so we can drop the
> below, it's just noise that people can find easily if needed.
> 
>> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
>> think there might be real use cases where we want to disable any THPs --
>> in particular also around debugging THP-related problems, and
>> "never" not meaning ... "never" anymore ever since we add MADV_COLLAPSE.
>> PR_SET_THP_DISABLE will also block MADV_COLLAPSE, which can be very
>> helpful for debugging purposes. Of course, I thought of having a
>> system-wide config option to modify PR_SET_THP_DISABLE behavior, but
>> I just don't like the semantics.
> 
> [snip]
> 
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> This S-o-b is weird, it's in a comment essentially. Let's drop that too
> please.


Everything below --- was added by David I believe to provide further explanation that
doesn't need to be included in the commit message, and I didn't want to remove it
or his 2nd sign-off, as its discarded anyways. Its useful info that can just be
ignored.

> 
>> ---
>>  Documentation/filesystems/proc.rst |  5 ++-
>>  fs/proc/array.c                    |  2 +-
>>  include/linux/huge_mm.h            | 20 +++++++---
>>  include/linux/mm_types.h           | 13 +++----
>>  include/uapi/linux/prctl.h         | 10 +++++
>>  kernel/sys.c                       | 59 ++++++++++++++++++++++++------
>>  mm/khugepaged.c                    |  2 +-
>>  7 files changed, 82 insertions(+), 29 deletions(-)
>>
> 
> [snip]
> 
>> +static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
>> +				 unsigned long arg4, unsigned long arg5)
>> +{
>> +	unsigned long *mm_flags = &current->mm->flags;
>> +
>> +	if (arg2 || arg3 || arg4 || arg5)
>> +		return -EINVAL;
>> +
>> +	/* If disabled, we return "1 | flags", otherwise 0. */
> 
> Thanks! LGTM.
> 
>> +	if (test_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags))
>> +		return 1;
>> +	else if (test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags))
>> +		return 1 | PR_THP_DISABLE_EXCEPT_ADVISED;
>> +	return 0;
>> +}
>> +
> 
> [snip]


