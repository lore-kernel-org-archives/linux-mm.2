Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DABBCA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 23:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EE18E010E; Tue, 26 Aug 2025 19:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF708E0105; Tue, 26 Aug 2025 19:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EDF38E010E; Tue, 26 Aug 2025 19:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7876D8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:23:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 226DA589D8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:23:28 +0000 (UTC)
X-FDA: 83820487296.26.2985B08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7D7D780009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:23:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYkNLHdW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756250605; a=rsa-sha256;
	cv=none;
	b=b8UOvyZ6t88yRmkx2cI6e3Tpj6gah8Tw1F3jrQ7iyVGoRcFazCYK2mt/UrHVA34cU7aIMJ
	ZfRaNrixt0ZcL7ZjGYYP+zKJGbAmE/MFZ57gjpKmlFhPWVywrpytYq1fa8fITsEhk+DRvP
	VWSlrEThvV4z4HS60hnb49EjOfFV+TA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYkNLHdW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756250605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfV453EylzFjDMotqL0A6T4TqEkZwnGf9pcGEH+odnM=;
	b=B4bSBuwTMhvWFbDu86fGNlu8bFk/Io4FE2Ds8OH5XQYdrWbYAECi4CkrBSPNF5ScrTpzgG
	VeMsXmVG5HeHxdeumIMht6rsMusaUmiBccJ6l3YtRjnQkb9ZbTrK+Dyv9r0Z/AMZcciBIM
	/pl6Y4T7ZORC0U+XeVFrIIFRYiA7kyo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756250604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PfV453EylzFjDMotqL0A6T4TqEkZwnGf9pcGEH+odnM=;
	b=XYkNLHdWI+0FxmBQbTFRT+3ltN7g6Fae9LBIdXm+HQjB/yK8Ia3uXaxBKDMeGjwi88aIqC
	xDaVjPabHmp5yxa7xZ88Xri8ObEDVfp5A3Oe/jZ8Qmpj8fmL1SlabmwXcO+U4NQAcfnjg+
	7gmJnrWa70K54m4Xp2go7tMcXt8aCa4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-DMelG4rJNeOeh8k8BHGdBw-1; Tue, 26 Aug 2025 19:23:23 -0400
X-MC-Unique: DMelG4rJNeOeh8k8BHGdBw-1
X-Mimecast-MFC-AGG-ID: DMelG4rJNeOeh8k8BHGdBw_1756250603
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-70a9f55eb56so120776136d6.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756250603; x=1756855403;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfV453EylzFjDMotqL0A6T4TqEkZwnGf9pcGEH+odnM=;
        b=hUPURCFfvN9DbE08TW5MKdh40b+pzSUTZGNMz9Jzd6CMwZ2KvdmTfcKHKqr8fJ+/4V
         cBkEw4qdwlgyZ8m5qsgpSTEJ1e4a3FQpQElvwwYp0/TcBMVWjS84g/7LcYVgFYtdoUJG
         jmpjEop5wMddg4Ll2+t04yt2ru5FbYpFH/sUs5wzk0rFPd9ikpxw+t2nRPRWV6WPbyCP
         GBsoyU3+6a+zVWTO0bjBgAY/7WTNdxFCOSJMFxCEhD1R7+GHzV0Vo8Q3dwtDvmHW3yFM
         rSObey6JQ89Vgv3M1BTMumyNESYSDQIU8Y/8o28y3phtKysnx7vtKKfS8kJegog2zKOo
         n1NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxS8nXzjDmTsBVNrC0Y5V5sY6ZKd+aqayI5kCNQMsAv1wUz0JuRzVTJkbBoqDdFkZyIibi2xsJEg==@kvack.org
X-Gm-Message-State: AOJu0YxJbr1iXZ9eX/sFcSDWzOEfiSElnxdJp6FqXYtrb8sY4XNyjhx3
	diJB89NsxUrBMT2MnSQv88xYYvLpOFtiK+lLT6JFoUPDSAVTbuxuOM1OCsjUfjyWRS/c+o9eeek
	Nc4TRC1eeGI6B6csFqiYxIVUT/d3v6bicVjqp05ZqdzJM+iyVyigK
X-Gm-Gg: ASbGncswHU/s8h3sE2lCBv07Ks5gFDjWRTkfaocrRBKvt8AzgCYpmZHFOubEGYJ/S9s
	GaO40tvBbQ7zoGBlHhXSRe7E2AOPN+7HWulVPtImxPDhb+Ya7fd/dJGYEK2s67mM51tkZf/wZQ2
	5XxB7p/b7eR4Atar1YunfhFcWTeZsdxq3Zv/Wi2hIU911M0FFdtwa7TFMDTtOGM6X2KvPXsVr2O
	nhnHw5p8/iW/4x/7/jPDE8ortdhPPHrqzCmh6mtYeikYal5sxOYeUlV57Qn8wok2WaS0vyeI8Ee
	mRU4E2kh6hKME6x1UmytCLRr8ATiNuavYGW4VdX3tlq32PkmhuuMUDe6s4uNYYxJeiXIen4K/Xx
	H6gyHvJpCOw==
X-Received: by 2002:a05:6214:262c:b0:707:6665:eb67 with SMTP id 6a1803df08f44-70d970d80acmr196728796d6.27.1756250602656;
        Tue, 26 Aug 2025 16:23:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEagzZGepQvPjAZ7woLBtEEbKkKtRRVScJpVsy+SdVoofoUKsJC2jnzOZHnQCCSJR5pLARGzw==
X-Received: by 2002:a05:6214:262c:b0:707:6665:eb67 with SMTP id 6a1803df08f44-70d970d80acmr196728556d6.27.1756250602132;
        Tue, 26 Aug 2025 16:23:22 -0700 (PDT)
Received: from ?IPV6:2601:188:c180:4250:ecbe:130d:668d:951d? ([2601:188:c180:4250:ecbe:130d:668d:951d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72aff6esm72585926d6.53.2025.08.26.16.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 16:23:21 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <ccb63d79-8c7f-4d0f-b92c-3ecb94471cd7@redhat.com>
Date: Tue, 26 Aug 2025 19:23:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
To: Gu Bowen <gubowen5@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Waiman Long <llong@redhat.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>, John Ogness <john.ogness@linutronix.de>,
 Lu Jialin <lujialin4@huawei.com>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
In-Reply-To: <20250822073541.1886469-1-gubowen5@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L29fbYWkJ7j5Xuws-3o83iBfRcuJgs4vZd__CkFp7Eo_1756250603
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D7D780009
X-Stat-Signature: cmb3xhwru76q843gpe5wifgynpxx1neu
X-HE-Tag: 1756250605-221407
X-HE-Meta: U2FsdGVkX19aN5UbfWPRxHf89RxX9isZZ8jx2Cw3FUF4DWviaeYFa+QeEDaf/gfsWIm8MsHGHyi3rncYEF0uKpugPTKcPAHkIVHRPTvB/zhytlabRdKQ4glxgx7QGAtoVbsDQomXwkh1ArTzB/kRYbBojBJj2Z2E+GZVBrWGnGfd9Jjvr0qpWpzxbbFZov+l7e7i/Prq73QZ8SMZTPvZChy1fNtuzHpgBoDU/k5uzg8rpJ3q5IpPefsriKcEKae+sgMO5V+v+uVie2kox9TNgRfLAgVHSGr3EtIGt5tJhXjP5oobJjLSYGLtd6yoT9lfFNmPC+L352Non2vClCBwhuukYPm7jk/ofcEU2CLfAcf15y1LTCg8FkiLqtKmz4vIjoTyGFwQ0gwr8GskiMdeECById7wAMy+VKTOKANC5D4bHXzXbW515L0sSP1RGRamy4FOPeuIOGGBhH+lg6xCsce+E1D2L9xscP1ObP6yCexr0r6jff901Tjiuhh+eB441+ZwXl7PhCufdjf15Q2PfT2lFjrowF9tPDfwCLRGhOeDKEfBojDsHifWp5zsWTbfJgQYi8USw3vEzt62Owix+sdgTF7aMrU26t5cmzPBGpCjafMoFaa5/4JmHeMuMpbIhCbLzNdbnCxGEk+NAowU2Or524suydkn0n0g0LMSPdnOnfH2RFksYaEoRI0NPWb/6at7kGNbOL3a2NjvM2+biFrq7w0dRqZVfKnQPe2RJsgAx5uW0zCyt/trzFvi2JAoadfqnzRzNQ01+sApl7pE21Q+ThqNGl2H7eDJ6QxQCGwugAUE4YsUv41TmkU9LCEF60diGRsp+HeS2Ori+wvx0IulD7L38AN+cuDAR8IiYLRbB9IpP9vmgs1o6AqoVN5j3h522nowQsCyG/3SbuFbhRN4KplJwIHadiHLnQ9RQj/ri8yt/nyR8MAhOHiync6xhUIzeW1sk5jwKTKEOIL
 9COov/oi
 yBDDp7ZKTW5mwjK/pOilCAYac/OjMzlsxvSCisrocqgfku/YagT+Q7zEyUdUBxTRDEHx7kx/gV61iR591cPo9DDh3IwxCLBnwN+uiaRUGN7SyI1MBZCWPPa/NahAoJj5jYwvCl/dNqHvneiZ4owuLi0qLOVFYKjVcvkmP3/cSn7l3ZzhRNSPmqyc01CDBzXeoRSYwC+RuWJCH9PTf07nKuEVXnkG4oEGk3aiMkVSaBE4lolxkRG8zgc+HfHI71mTnSsaeBEYs14HgOd/Tdy45qQL60cakd1q4XV0xn9EPHp4Qsf/AzZfucaNmAkp8oOH6h95HIoogsKenvc7XqAfF4+CvKgCiPhmR0vyGRUy5vbV/ruZEt+M+VwHPpQ4kzclWFI7AKeEqBVHT8Q8DG5li8IKweurF148l6Rk+lpmDgdVDrnlWZ7SKxU3mB9CxKm/+lK/7NuVJ4jVbDlH8Wt/0eK97PD9963G8HMjlmqNPkuX60OV52Lt2WEzWE3LmuHXBmlGuCWlkEBdqk+C/kiFrCQ/Kv0dx2TFGHFaRJGrYYhowMSo6chtVK+T8EAx2mxSNJxis
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 3:35 AM, Gu Bowen wrote:
> There are some AA deadlock issues in kmemleak, similar to the situation
> reported by Breno [1]. The deadlock path is as follows:
>
> mem_pool_alloc()
>    -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
>        -> pr_warn()
>            -> netconsole subsystem
> 	     -> netpoll
> 	         -> __alloc_skb
> 		   -> __create_object
> 		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
>
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() [2]. Another way is to
> place the warn print after kmemleak is released.
>
> [1]
> https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
> [2]
> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
> ====================
>
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> ---
>   mm/kmemleak.c | 27 ++++++++++++++++++++-------
>   1 file changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 84265983f239..1ac56ceb29b6 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -437,9 +437,15 @@ static struct kmemleak_object *__lookup_object(unsigned long ptr, int alias,
>   		else if (untagged_objp == untagged_ptr || alias)
>   			return object;
>   		else {
> +			/*
> +			 * Printk deferring due to the kmemleak_lock held.
> +			 * This is done to avoid deadlock.
> +			 */
> +			printk_deferred_enter();
>   			kmemleak_warn("Found object by alias at 0x%08lx\n",
>   				      ptr);
>   			dump_object_info(object);
> +			printk_deferred_exit();
>   			break;
>   		}
>   	}
> @@ -736,6 +742,11 @@ static int __link_object(struct kmemleak_object *object, unsigned long ptr,
>   		else if (untagged_objp + parent->size <= untagged_ptr)
>   			link = &parent->rb_node.rb_right;
>   		else {
> +			/*
> +			 * Printk deferring due to the kmemleak_lock held.
> +			 * This is done to avoid deadlock.
> +			 */
> +			printk_deferred_enter();
>   			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
>   				      ptr);
>   			/*
> @@ -743,6 +754,7 @@ static int __link_object(struct kmemleak_object *object, unsigned long ptr,
>   			 * be freed while the kmemleak_lock is held.
>   			 */
>   			dump_object_info(parent);
> +			printk_deferred_exit();
>   			return -EEXIST;
>   		}
>   	}
> @@ -856,13 +868,8 @@ static void delete_object_part(unsigned long ptr, size_t size,
>   
>   	raw_spin_lock_irqsave(&kmemleak_lock, flags);
>   	object = __find_and_remove_object(ptr, 1, objflags);
> -	if (!object) {
> -#ifdef DEBUG
> -		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
> -			      ptr, size);
> -#endif
> +	if (!object)
>   		goto unlock;
> -	}
>   
>   	/*
>   	 * Create one or two objects that may result from the memory block
> @@ -882,8 +889,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
>   
>   unlock:
>   	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
> -	if (object)
> +	if (object) {
>   		__delete_object(object);
> +	} else {
> +#ifdef DEBUG
> +		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
> +			      ptr, size);
> +#endif
> +	}
>   
>   out:
>   	if (object_l)
Reviewed-by: Waiman Long <longman@redhat.com>


