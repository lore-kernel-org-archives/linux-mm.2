Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AFAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072DD6B008A; Tue, 14 Jul 2026 05:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023E06B0092; Tue, 14 Jul 2026 05:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C406B0093; Tue, 14 Jul 2026 05:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C04196B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:44:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3025E1A032D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:44:49 +0000 (UTC)
X-FDA: 84986897898.30.2FD5213
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1F60920004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:44:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ICKinEcM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022287;
	b=Vc0E9FiK103QqBYjwtBzZFMUbvWEAKIuaaN8ldbl4HTEuR48SbRR6joOAO68JJ9BDBCDik
	8idHbeFFlBZ9G1HU0KbQS4IAzdjabAH6o481XNaiXT5ZKF3w3v/fduOtGomYxWDPYCAJ78
	mks7Fh68wqpeFAyZDuL+apYIqbIJxPk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ICKinEcM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+lTFxB6Ymr9p1MfVTAwXm+z+pPU7EViP2K/jOfRQ/U=;
	b=IpoagrE7A/ukJ29zW7is/E1adtPF0bRPBb61fhzDKOjNZz4wLsOaKuVjq/EUO5QO7ya3R3
	SOzTByjPu4UmGhXg98cGx2ZMkWCeR9arV99zRV4JGTM9K9B4iPdozwsYB2i4yQ0QrjKZjh
	yjLVCO2O0sP7Yo5tJACbJBzQjdXrKVU=
Message-ID: <e3ca51d9-e484-453e-abfa-2cb4840ab141@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784022284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e+lTFxB6Ymr9p1MfVTAwXm+z+pPU7EViP2K/jOfRQ/U=;
	b=ICKinEcMvOthTfP0SGWhA/nWOfw/eUzMJ5vF/CD1CZ4In9N/gTDxYaFvhR4HjSbq7MTyjO
	xIUnhi048VZKwJvQhhZDcSml8hRKNR8lrJZuMoP1vOAzRKpD5FdK/4dkOpJXGeo0BJKNVT
	8qnRq8iiR7hc1/445km7Kaeiz/O6LTw=
Date: Tue, 14 Jul 2026 17:44:25 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/2] mm/mm_slot.h: add comments for
 mm_slot_lookup/insert
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 chengming.zhou@linux.dev, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, wang.yaxin@zte.com.cn
References: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1F60920004
X-Rspam-User: 
X-Stat-Signature: 8djsnjmyfc44jubissjifptoyrrts4k8
X-Rspamd-Server: rspam03
X-HE-Tag: 1784022286-619531
X-HE-Meta: U2FsdGVkX1+ogaEEyOm4Oy6XtKD1kEFiF+HZKBEmeY91+mO/lXHmxODrgm0I1HRGrO3pdhWvDeI3AhdAgDoaQbb8QvTXF8TuZ2Emjy3Bf5sOqYDT6lo70pOLFONLBWfm8l4sVIgHqQvDJbUkR/iR1rMEXJmYAVEnjJxaOJFto2/ma1oEbo6jdJ364SDGCQQIW8jHJNYCcvglf5vcxcoyz1raZe83a/3SRPsKhFEdo+QUhTg4fnsgwnYOGvR1YKrsBsCRRIOZh9wYDdw4955FQk0r6uV8nIkuZ+RkfZTNMyuwYJJeiyCJf5q7f9PfaNmbwJ6U1owAYzqthffWvgK+NFbw6CFsnXhB+vnZj8YsBpJx7dPlMYdajgqi3tsZ13N0e2y4jDU5qboAhpVmWSMw1zgJt3/2V3gY5NbthJ2sFtO5N3q3+iuVysRmEhNvBfkxaztyUebGMoYGf1y+7cSSbrDwt4T5Lby6w1lJzzM/dfKZLFNqa47JWqBHgLJwXUyp3QtzBswryNUSnfu5qMVRFZFOQZ8yk2hTXtljmGjFlKSYe2A+rn1CYYSsrQxUzymvXbHhgYoAv16GZvjQ4MksfPTAdCTlf+bD/dyb6xfSzZZwyBTQyWHPARyeAkE2z6KXCYT94DrsOSCnPSD7e8bqA+ZxvxmJjKO6PXevd+nC+x/JgVI9UDDTxjMu9ERpZai4KAAogdq3f1TYC0lAhWcBWEEbCDdg9KJOYjQwyBHhrUslIDzwipw7yKL2sGzfXHSV7lTfEhKBBgPQgFmjS7IrWzIfiCKwZRMbt0t5wvd7CSKyWeU1Ho0/Q1qB0NsdJIb9e27JU9C652Gy6A/ZHI4fsrvjkDADF3ilK6rPu4HxOs468/w+n65Gp+pvB97NVWpCxtYGB6JN4iMKT0K8XkZ6wrrr1hK/6WILyP5k1e7XOsRUiWmbQAjAZVQ20YFJ724/CgpLXqQ7CvedBmRFFvr
 qduoIQWJ
 wIBU8kUoTTQCk3QnI5vqbum/xpzhJtMLL2Q8DQ0GE3tkDjTePxkYA2GB0os0J3e+0ryRHVvcjhIvHZk4zTAiZFua6zNpPCci/4qPSivxQ74Mq4okjqOcq/8zPUPji58AdXbKP4rGUVTypdw8HVbeX21AKvFPeQdLEzuHEfS0t1Hk7Cy4FhlQ6aFLwjwhlk4CZXgn26HWodq/d5B+FELha0dnUqf2IQCLSexQRBwaHOSPFoqOxzzol0B7wjwdNY+dDamOpqWUJmLyvsiln6kNMhS4nJ1c7inW9e/C0DDL/yvO+9ZsJaLM2qa5eZzZg2fExPyIg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/26 9:28 AM, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> mm_slot_lookup() and mm_slot_insert() are the only helpers in
> this header that are implemented as macros rather than static inline
> functions. This may look inconsistent without explanation.
> 
> Explain they must be macros because hash_for_each_possible()
> needs the table as an array (for sizeof), not a pointer.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>   mm/mm_slot.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> index 5de3e91d86b4..9b09b68e5742 100644
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -33,6 +33,12 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>   	kmem_cache_free(cache, objp);
>   }
> 
> +/*
> + * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
> + * functions because the hash helpers (hash_for_each_possible and hash_add) rely
> + * on the actual array argument 'hashtable' for sizeof() instead of pointers.
> + */

Right, that's why I wrote them as macros to begin with.

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> +
>   #define mm_slot_lookup(_hashtable, _mm) 				       \
>   ({									       \
>   	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \


