Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D05CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0922A8E0002; Sun, 14 Sep 2025 21:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0416A8E0001; Sun, 14 Sep 2025 21:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98BB8E0002; Sun, 14 Sep 2025 21:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3DCE8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:47:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 078A9B9652
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:47:44 +0000 (UTC)
X-FDA: 83889798048.06.A70B2BE
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id F09E8120004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:47:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dHYM9iM9;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757900862;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQxAXFXvHzbJf8Ay+yszvZmMUoKWGZnWDec6bGDOzf8=;
	b=pMXzOPxbvMV+YTmlWmWzG5vmeHSbMhybRXNTHTgvkuRO+fvx+YchQo8cccc84YUL9sPCgN
	V1tEsw0lwn+xX3OuogJO+5xKRexAWp26LHw2xhdti8ADWpF5TY31jW277T2mGbRIrnVhi+
	+fazjWYyus3mMK7okWgt9lTcjZ0ZHdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757900862; a=rsa-sha256;
	cv=none;
	b=ILFLMNDP4c/khfkZXWkF45u7QqHGA6A4GJLPwCxKCBQgnEkW4jpDGeqkOnMGK/NWP5bpIM
	/aWD8YVlPa5CZ8jo28aVLyrURXPu0tEUPTilRbA36SSe/0k0A1Aecfn0gThJR83j0AyhV2
	eRc9SSnVyi8PvYbeebARWo8RxX4cYSQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dHYM9iM9;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62f1987d44fso1652057a12.0
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 18:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757900860; x=1758505660; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQxAXFXvHzbJf8Ay+yszvZmMUoKWGZnWDec6bGDOzf8=;
        b=dHYM9iM9fuEuh7L31oxCOO1DOns8YhgatKWPPuMyJ2hIUPog76DldqDbQZAdOoBdeu
         NY4cMe8WyRq2AEYmnfPKR2qBlg0qX9QKinzmXkC14/rrGB1OIogUSpdTsSElqIH7TIbW
         OYql6d2yk357K1jgKbm7KXde/XHuFgWie//kpHxM/aXmWWBR1/ITGzBT7V3m4kg7vW46
         3kI4Gczfi9sdapWa8w5jpulX1HlD6LK50kardKgivoH+n6YOkvKWi5ea8FKY/NMs+Zx9
         DNi5pfEPI+e/NIhFJU6Ene0enOVnpuBvnChMvLgqMH9o7R6ObYtzanFBrD32kJ2m7Lpn
         xhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757900860; x=1758505660;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xQxAXFXvHzbJf8Ay+yszvZmMUoKWGZnWDec6bGDOzf8=;
        b=elb8ZZeOn6iNpBWpuIdOJceR4+1IkGJEK8jS3yIytexpRGQqvCg+qNFhrIehanWEzM
         RGPA91o9qkLXHEYclwuGHOb+FYi683IO4A3ARPX3QYLRjOprFW8CRtGdDphopZ+CxkC6
         16G0dF90zlNty6jIUyrPu2V3rBEo49kjJbS1jrl9MMcoxT48wWpVdDwtA/PBloOF9ppF
         f5Pjxn7CDuzebWXFn4jsbhEa4+xX1ppHCa50dJDQqcMmjMi8CPP1W/d5pX1U0WD11tsG
         9fxJX09qx64ZrJ77rKjwaEWfDuXs9LH1jQLRSIXG++wzi52O51ZJQ7CC5rJDhFi8Lctc
         T8ow==
X-Forwarded-Encrypted: i=1; AJvYcCWEZTNoftufjvCKtaXQxZiF8prmmeMYZ9iu1tBvl4Q54CrPa1fiFpD2S6PIR2elAyUpCRg95Gi+eQ==@kvack.org
X-Gm-Message-State: AOJu0Yxb8fz48CmJ7Sd6ZQZRQ9BJhqijaDWnyyfV4dRvmR1P0BOd2nNh
	bzrs41lVhbJFwMlSmH/PWrc3YKcte8Irdzc2ZgPa5P1hg7ezRHDDRt1q
X-Gm-Gg: ASbGncvWwcFr8zepmdZBq7QGPBafeuh3aIJat+YWNKG/naoZ9w0QBdk1j950TTMjAbK
	zl+678sdQYGh26EPEMwyvzz3iJfVzHNW+K6szxxi66AdL7DTws3EQx2/jRV+5RGimostW4/RwVN
	Xdt3CobOE5DuUmUrua7uxktR8GkCvxvRpytEVE+GGb9lZkRs44I9yIGUPfvb2AoExUABOt8eM9B
	8TPYEBZcVKR0OWGDhPcfGmUxnvC/4CCl9UUXnQsuF8/08j6pOMjvnRcqZtApm15IDPnNLDCUBYS
	kuMqNbuu4+PAB+K8ewjkl3beooh8CfP4aMnQz/rFv3mD2dLZ3BX1RW7hpzGOnp4gLALMBGSkH9O
	pWcF+dJ0G/5i01W+9pD9QfB0vJh8Ud4Kk
X-Google-Smtp-Source: AGHT+IGfnZOpM6fv3eUoPc9AKceDiYWqHL7Iysryg7Hh++APbFGpVUpk+aDRF/cb5DeqbxWM7K17XA==
X-Received: by 2002:a05:6402:a0cf:b0:62d:f340:24b0 with SMTP id 4fb4d7f45d1cf-62ed823e6d3mr10487516a12.3.1757900860050;
        Sun, 14 Sep 2025 18:47:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec33ac2efsm7832533a12.12.2025.09.14.18.47.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Sep 2025 18:47:38 -0700 (PDT)
Date: Mon, 15 Sep 2025 01:47:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	chengming.zhou@linux.dev, ryan.roberts@arm.com, baohua@kernel.org,
	xu.xin16@zte.com.cn, dev.jain@arm.com, npache@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, ziy@nvidia.com, david@redhat.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915014738.slkw4nwihb4aavas@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F09E8120004
X-Stat-Signature: e8xtbwnnnewesx816o6ar9khyoiu88ot
X-Rspam-User: 
X-HE-Tag: 1757900861-929087
X-HE-Meta: U2FsdGVkX1/+YC1psIV/bmDYC1wpsfMX+nA22CIQDgyUtYhZTxToUnxWFPBsDUnMpe4cg3No7onZplX+2LvWRzxVdEIIY0fEeySe2BHgv+GnGSB/sVbcb4GeCTtxeQk1MuhA+MI3L6Ai7/riAwfdh5HV/ZpVqotEJeZdxSTGtx29cx+UOvIp6SckDBGqU00MxeOhYZnfk10XYxnWHx/W5mAobmWi1YJCGsjDZvDRxYzpaCHG3Fm9vCvm50VDZ2GRlHPhPvyV/03HxhuuF8P6P/L8eC1noRE63riSI4cymy5le2GkZdOvW0NOcDwA48yNwOuomgs4+UeBQOQOcZHsdKvOFN0GCJF3ZKRq7M8frT7sUnE52fp/tw7j1WIZrOz+nPWUFth7HqafFG0C+39BxvgdQNLV9OUKFlXHaHhO8uSTShTA8XwNVmy8j0EHxB+IdWI/AqtZe/cEkCwsY2rNZU7mF7zP21PJT6VIkzmIBzSZsbeVdrdMmKUACvxzAEGghnKd6vtq8Jw8LhHff3Ub2eKetC5NRBj2f+MSgXe2fLAB3negWqMdzLPjpb0vxiLI6kFPMDpTbT/zQclH83CiYuXSlK0DwaOYhpoUBhZMXQa34Ga1r/GMWHcI9gMhOe694ixfOGDMKqFvYIrtiKST3X1AAYs7Dr+Qd0Zi8KrhHjb2YJ1C8194m3yCpKIE7avBus8nhjLOOfXghK4Z1B7TMqf1WXp0wkeezeFPELU3MWWXAeKbXMrFpU8cyrrFKMqlAhBOk6616dL8CsR/dgt/Om//98oqTEF4mx1uhGfAhn69CxZITVSkaJD7fC2b/Mlzc1jvfUQDDZU/Y0B/wwvKhK9gOe2wpguByFie0ZDXCkCNwaXOgxuzQrgkPooDvBd5wgcLBpUP8zWJbvLg3t3G33yyZ7wYmvWZpQ7Af3/B273wfyliRy0+U5vfHsQGekDth7AA8ca5IA9RgNWmiIW
 sF2cW7xS
 NNkCDvnZbQtBPLsWR+tuGexZ2BfbumCnXUqUSxCgu0Wq9LqGfMoDXSLaiBqxotsdL2wXXt01h/+kEd58oXpxA94hze7sOm0jS04vE8reLfn3NkrU9dUNcaBdnCggxp00fwsj4mw8sS1ZD9+sMkYKr5EtfTwSeR0LV+uAMUVrKBLwNRDeaUIobeH8vYfXuBv1+LL5ys1IsvdHZxC7X0DYaIE44NpikGUfSB/0Nd//yQ2b3GI74HAfBuVSi1ao0JyrgdtAMGI8Azv2EU2LhRtefsrsb9o6cZokrgh06wwqYN6nmm+SoTMCADQxbpabeUscAb8tUA7kBHEzVkrir8B0+Nv4SgBc8cMEsQOImLvhl5nYUOr/6wkQwMH/Q19TstgfJ3INEmn8WV/bjzStEMSuM7R5OHI6dwwr1fFG63Kwyttos4kXhpEi7cK9TFfkkNKrewAInGta3HIngpo83/9avgocWuNqiSzdXwaH6V91SErCNsljJxHNPxCEHD+HUfIV/MbIREMZ2tH7txqH006PPxulcJwrbk/TxuQESI5YCqSXfDa04TLoWgNkGoDg5/prcyrJ3S8b5Ixt7BvVjlOGcSTuBLGip0mPx3kNjbTRWRxspfxfvVElSJup0u3CMz5Y50HROwIMYkTntwnpv/V/kLAi/BLAHIskJPt6VJiaG3KXWnkGiIw7hJc125vMyaTUgmU+ep5k+aTr9/DwceSVtVOqegx5030VC0pIrvFzQaewzrEjBcSA4n6V4bkqs6WcoWeRKe58RuJ/GLNKJiuUTP7GCoYC3D8G31Jbjjyg2mSNWnTPsJnlYgf1f0uHSWWk1mPmDBFC719R9lsq86iUtGibvBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 01:05:48PM +0800, Lance Yang wrote:
>Hi Wei,
>
>On 2025/9/14 08:00, Wei Yang wrote:
>> When using mm_slot in ksm/khugepaged, there is code snip like:
>> 
>> 	slot = mm_slot_lookup(mm_slots_hash, mm);
>> 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> 	if (mm_slot && ..) {
>> 	}
>> 
>> This is only valid when mm_slot is the first element of its wrapper
>> structure, otherwise a NULL slot would converted to a mm_slot with
>> negative value. And current code thinks it is valid and continue.
>> 
>> Current code works since mm_slot is the first element, but make sure it
>> won't be disturbed.
>
>Good catch! That's indeed quite brittle ;)
>
>Just one nit below.
>
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>   mm/khugepaged.c | 5 ++++-
>>   mm/ksm.c        | 5 ++++-
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index af5f5c80fe4e..668e74ad33b7 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -108,7 +108,7 @@ struct collapse_control {
>>    * @slot: hash lookup from mm to mm_slot
>>    */
>>   struct khugepaged_mm_slot {
>> -	struct mm_slot slot;
>> +	struct mm_slot slot;	/* keep it the first element */
>>   };
>>   /**
>> @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   	struct vm_area_struct *vma;
>>   	int progress = 0;
>> +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
>> +			"slot should be the first element");
>> +
>
>I wonder if this BUILD_BUG_ON_MSG() in khugepaged_scan_mm_slot() would
>be better placed in khugepaged_init(), like you did in ksm_init()?

khugepaged_mm_slot is defined in khugepaged.c, maybe we don't want to export
it.

>
>Cheers,
>Lance
>
>>   	VM_BUG_ON(!pages);
>>   	lockdep_assert_held(&khugepaged_mm_lock);
>>   	*result = SCAN_FAIL;
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 2ef29802a49b..0d486dbdf7d3 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -124,7 +124,7 @@ typedef u8 rmap_age_t;
>>    * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
>>    */
>>   struct ksm_mm_slot {
>> -	struct mm_slot slot;
>> +	struct mm_slot slot;	/* keep it the first element */
>>   	struct ksm_rmap_item *rmap_list;
>>   };
>> @@ -3842,6 +3842,9 @@ static int __init ksm_init(void)
>>   	struct task_struct *ksm_thread;
>>   	int err;
>> +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct ksm_mm_slot, slot),
>> +			"slot should be the first element");
>> +
>>   	/* The correct value depends on page size and endianness */
>>   	zero_checksum = calc_checksum(ZERO_PAGE(0));
>>   	/* Default to false for backwards compatibility */

-- 
Wei Yang
Help you, Help me

