Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F12C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 02:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D721C6B0092; Sat, 11 Jul 2026 22:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D231A6B0093; Sat, 11 Jul 2026 22:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14F26B0095; Sat, 11 Jul 2026 22:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87C276B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 22:03:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09B6A1C40EE
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 02:03:16 +0000 (UTC)
X-FDA: 84978477192.05.C27D2F2
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3319CC0007
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 02:03:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YRkwifT1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783821794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AEc8nE6deo8T6dPEpOX1aaF1DO5pjrQkwlE8uC4Jqs=;
	b=u021NATmWvRdi0c2OOBKjTeHkSgrDHSsYlxUTt10VSER7drK1H5/9fak3zVmwtaeRWdUz2
	SfUdrfbFRDUEvKZULXxRhOspmig0WS59QLjK5/sagAGaEqL7glw02lnQt1BWW4pl5DsWlo
	spLwbRRuYfhQjmlfwQsXyrqVLzqWe3E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YRkwifT1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783821794;
	b=Twkl7+pS/4XLfC4jA1FydKzwozML/yIp2hr/5X78N5fBEJ+1OSSqffHjEU9vw/ZewYNmjr
	FAnGaUATchvXVz7JGSgSucgU7CTLa4m/X50fTM+zOtHz9gaHeeu2FKHb3mNwrrc0tMbTHa
	7t53emGo9oUo766jg21rlUehQ1WU7UE=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cc827a68fbso6015165ad.0
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 19:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783821793; x=1784426593; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8AEc8nE6deo8T6dPEpOX1aaF1DO5pjrQkwlE8uC4Jqs=;
        b=YRkwifT10gtDF/shCfGTM2Kw+vdEah7IybCIdORCCTAls3ONKf3QiWc8O9z38vvJGS
         9EO6781E1TQastYjjyVv5uXJokEL4Yn6GnvV4H7idf2/wOcqVKsUqhsHZehxq5mwD5E6
         l0SUOjRMTKyn4uQ23S89nRTT9iFLh5zXu8zzMTs9LKvdGqs5xFFS7z9Yn9RabIJ3tUFs
         mfoyP5IrN9cz1gkheZlfnp54Ga/eSvflbiZqIfWwkZmi/SSQT8G6eB6QGA2ltBHh/WwH
         COgINrDegaqw7LoekdDr7CHiMccJOUWPoMfsA88kfwhyi8IGPfYAozHONjGtXq4O4yOd
         hjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783821793; x=1784426593;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8AEc8nE6deo8T6dPEpOX1aaF1DO5pjrQkwlE8uC4Jqs=;
        b=UbJNArwtWW72tQohkChrmiXxw2/sGYoLoKkPuKR8ETNSjoUpyDFLBz6A23gIimhU6X
         wEcyQOpNDKimw+ODrM8RGqqV0q9LiSRPgfl218/btc/ieamRUNJq4bx8uhstBvIsJBpV
         GLpsl+Afezt9bsBCZsYMcOFFHNol1EJaJzedFoNBQ2iuCb3Bn6l3AFXBGR/74FRoSLMb
         26j94kKOwuSpWifkP2sUTPj8RztN4Rwe17zsOdodiM2Jo1On7dtLE0t9+zBT6VQYkGpl
         qain8uZ4blaY4K9C3ufJwc8ZxeodwoM+73g/D+FYcOk2YJOMWxEU5W8kwVoJaSwdhp9V
         0SnQ==
X-Forwarded-Encrypted: i=1; AHgh+RqVe/vyyil4wQSQpIbutgMAKwNAEEB6OMfJeAaXmHO9S/qL23bFVkqX9b5sKRlrQC9jT5+taOGHfQ==@kvack.org
X-Gm-Message-State: AOJu0Yzxrb4QKtM3nm85NI3rEv3Gwi+r1U+mKap12HdM67JQrYsqdki6
	ae5hF24dHH9OW/FnBEd1Yi1qgdduBFOP1U4lg98o91fdagq63QYm/qBN
X-Gm-Gg: AfdE7cnZ9SwZJVmKrQ1v+w8ekzpqtuFlzGVZ0IFT2vd/tkT5LFYdSHDGbr6kA275KJM
	A4HIuW/bMTqpLw833hMFGawrBV2gyWX7o4YWxXJHuDEkA3u0FQex2lCEODQp+EPZkG1R0N66fZ5
	dK51hBkHm72ZE5CEE0U21kGvQmkrPY0fzAchGgz/M1/4JPESgVMiqnPKc2b3QRUUF9k39VunF1k
	tOE1hqMtcfeOrK2r4vAe+DWWkv80VjjMeat0ABgccIyJLB/4rDMMnybSGTWkqdo1QuZYxMCrW5P
	Su4vtu+13uOtv7uIbOJhOaF3bdAbTIw3uJG4gv//a5S+QvBPNmRqG8RUdPca2xLuk1HlHhF3Der
	chZYnwtzuP9i0lwysOyLHQ4Zfg+uqC899tF7hJtUEFPxMLJfdpK2Fo9qMxg3DSOU6rhExscdjVW
	3CNGX3ZqTHqazU1TZQNIRtMgn3CRQoLpyu+me3ZK81P61SQoLaDKDnc5sVRNl+JgCrG42IOh3W4
	UYB
X-Received: by 2002:a17:902:ebc8:b0:2cc:9d9:b8df with SMTP id d9443c01a7336-2ce9f187200mr35725535ad.5.1783821792749;
        Sat, 11 Jul 2026 19:03:12 -0700 (PDT)
Received: from debian.lan ([60.177.121.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb56fsm80691555ad.15.2026.07.11.19.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 19:03:12 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: baolin.wang@linux.alibaba.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: Re: [RFC PATCH v2 3/3] mm/vmscan: avoid pointless large folio splits without swap
Date: Sun, 12 Jul 2026 10:03:03 +0800
Message-ID: <20260712020303.326384-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7ec7533f-e1dc-4236-99cc-6848d651976e@linux.alibaba.com>
References: <7ec7533f-e1dc-4236-99cc-6848d651976e@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3319CC0007
X-Stat-Signature: y7yz5rsry4z8fohcip1uhjftshfy6tqc
X-Rspam-User: 
X-HE-Tag: 1783821794-898864
X-HE-Meta: U2FsdGVkX1/4dQcnKUKY1zwdpOb7ezrrKJtkIkFNwqgj3e0N9hzNloZOdwZypGNtRijd2V6na2LR2HSuCP3jwFgE1Wz+QtcLy6rxfNFzgYYlZxgYGxeGdCDiNUGTspAy55Xmiuh64lH/NQgTtZNy2ra4HcjO3L7cvzKzxPaRnVOTgUDkG5tgoQzdoMfF1N2SMjQ7UPahm22/UWNhCXkEPdKGk7YDogmDTFG1zXDQQJl8MTK+hGg0k9Y+DHrPTcPUw5TBj+cNUVyO0mcroIKsSGJb5lz3M49TKxiEIjq/41hkODEnxszwHxOnPAUxS2N2K6BjKy8r0lZI2mAbyzDN9MnkIWAvolIezlTNEfX256rEEa2lzJmb7xSC2pvH3iAS+TLJ6o0p/asaaqGyorGdeocZvF3hcc06D5YYuDzMJngmumfy6QePO6TRvvnZjqoPPrXjGsLHCmDUEalX2uitGFxK2Sxe5rtbQzN3H49WCVFlUA1C8T2TSH3rr5NIsajzmAQiqXOWzz5z2y5sl5gyRwRu3Xtvh2PSC2aFjlh+i5HTYp4m8INWf+nbeziPhIM7EO3WVkymdBMfyFKqtpxqUIxi4ygVKBvZxt9p0t1kngkkjhaGK2Cx1NU0tj8cQmf5MvpcWr0b6FVmwPToTaKgtGuXstF1mP7AbjIfSEC5BPZP3vyLfcedzusgMVFJPrYH8IJPu+YgXqQnYP8oHcSiSrPuIorqg3R2/6UkpIXUyxbNvHoRQ5AIMFMUbTTYlpdyVdsOnj9NiYWssGCXdgioXxE8hnavsULBbZlSPZlsC28vWYtzRgVHFRcn3SOO4ol2bfxqTrtEngFwfUIFzLTadYUngv9JMef68OcGac4dtmxdITm6ybjrDyCIpKuEN61suI/tENfYcwtqx1ndUFciQ+wHALvgOceJVpJ3CgTahf66NAMt097TqYRBysR0hLF8C6P4ofKc3dI9BpF+25r
 EPyz+bFw
 lUEbOgVTb3ZJa5Aknw6ZeCLbnS3KyP2e30pHLnz5COcg1Q2mT6ZnZN/oJKfNvPsB5KfBEU64NT7xtLw0WilKNMACDacVeZ0ZEkJsCMUrjm2URq/qNtBfAl8M1ET71JH4s/ibVzgmrhYVG8yZnbce2rElAyHkaCn1yIkBbuK9r7D3QMLVLqRt0++ps/mdO4qW/2GeLp+amxakjRzG9jwhFlnhypWZKbMHsTHy4Awit31MU9pdF8vgqeIs5HUk3KANq9ENM3K3huMBiE8prBsgJgd+PKf4WaPmvvha4iV2RJba0wg3NA3NWJfLXRztKmei8QNwO1zZqCYQXyvRJwC0TgZV3cQZl1n8JFIPbyRd6BYWnzmHCOycqfonnkfAFGsXc9sXR/nfFNykBK1P6l/c+lG7lEe+z7aWyYmb0NuMzdmty/iBnf3uSQtGzRtcLfLYCgLs0SnmCWjWiJu2AvDmHdCotU6nvHnS1tdH7s4FavQ/3lDKRM8o1kIicUT8iCAUrjBs32HIcvjAsqz1WGLoEz4ssbUz14bsVeYLHmRdz6rIWwoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jul 10, 2026 at 03:21:44PM +0800, Baolin Wang wrote:
>
>
>On 7/9/26 10:51 PM, Xueyuan Chen wrote:
>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>> 
>> When swap is disabled, exhausted, or unavailable due to memcg swap
>> limits, splitting a large anonymous folio cannot make swapout progress.
>> The fallback only destroys the large folio and inflates split statistics.
>> 
>> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
>> the folio might allow swapout of smaller pieces. For other allocation
>> failures, keep the existing activation path and avoid the split.
>> 
>> This preserves the split fallback for fragmented or partially available
>> swap, while avoiding it when there is no backing space for any part of the
>> folio.
>> 
>> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>> ---
>>   mm/vmscan.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index bd1b1aa12581..40340a88f78e 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>   		 */
>>   		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>>   				!folio_test_swapcache(folio)) {
>> +			int ret;
>> +
>>   			if (!(sc->gfp_mask & __GFP_IO))
>>   				goto keep_locked;
>>   			if (folio_maybe_dma_pinned(folio))
>> @@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>   				    split_folio_to_list(folio, folio_list))
>>   					goto activate_locked;
>>   			}
>> -			if (folio_alloc_swap(folio)) {
>> +			ret = folio_alloc_swap(folio);
>> +			if (ret) {
>>   				int __maybe_unused order = folio_order(folio);
>>   
>> -				if (!folio_test_large(folio))
>> +				if (!folio_test_large(folio) || ret != -E2BIG)
>>   					goto activate_locked_split;
>
>Like I said in v1 [1], please apply the same change to shmem swap as well.
>
>[1] 
>https://lore.kernel.org/all/6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com/
>

Hi Baolin,

Thanks for pointing this out, and sorry for missing your v1 comment.

I'll apply the same folio_alloc_swap() error handling to the shmem swap
path in the next version.

Thanks,
Xueyuan


