Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FCDCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 03:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32A46B0012; Tue, 19 Aug 2025 23:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A7B6B0023; Tue, 19 Aug 2025 23:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FCD8E0011; Tue, 19 Aug 2025 23:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4A26B0012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:27:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A93D140302
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 03:27:31 +0000 (UTC)
X-FDA: 83795700702.14.D7E284E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A509C40005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 03:27:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJLJI1ZD;
	spf=pass (imf01.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755660448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBtV/gVWBkyOUPr/F57qO1omGrrH3gCVGLkqTBMXbzg=;
	b=VVrVbluSqMxg6b6ANj6fKj0GKOeTsO0tVBsbjMRN9X3zisU/3Y58QQXl4b8ClgJuxzt6fL
	SrEIIP1Ykd7OyGOvIOUQ4EhsOX2Q/NZAZxEX7e0oJ6dEP6ZqGdnK9dcMOepjFDjxJWsKgC
	XUSlT4ildY8O6s0bgtkgXUkz6BAlu0U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJLJI1ZD;
	spf=pass (imf01.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755660448; a=rsa-sha256;
	cv=none;
	b=DztqT2SVB9hlYdG+NkFzNyIhIdNEFaNXN5UsJPcaxXkemLN23AKN8k2LQOYy/qwdl+fsox
	CR0ILybfEylhV6Md6F14V1w5/tllr7+eIXY9lz33QozGDGH3f7ZYzFlmd/m7tGOTtPJPgf
	s1UTAirpdLavViQXZ7GZSd5lkaopWOQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755660448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MBtV/gVWBkyOUPr/F57qO1omGrrH3gCVGLkqTBMXbzg=;
	b=OJLJI1ZD05b7HJF5J286yL1k1hLSrAqTsS24z26ASwiQMYDEoqJBNf7mvRcV3dkNoZojYj
	m6JwBxCvedRyglpUiwRIriBL4oAeBB0xPepaPut3KCIch291lApIV50lger0sLKsKA4jCu
	2bOwd3BAF9G1gaDfepjrNtO2faHfnac=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-5K40QJ8UOOyAiC-xQb-q9Q-1; Tue, 19 Aug 2025 23:27:26 -0400
X-MC-Unique: 5K40QJ8UOOyAiC-xQb-q9Q-1
X-Mimecast-MFC-AGG-ID: 5K40QJ8UOOyAiC-xQb-q9Q_1755660446
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e870646b11so1548603685a.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755660446; x=1756265246;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBtV/gVWBkyOUPr/F57qO1omGrrH3gCVGLkqTBMXbzg=;
        b=IslJuY9nBekZk2I8/9XqWDX0qadEtJjW/ZmU4dNn5hSn6LFV1/uIYNjUy56d7RZNi9
         r8mq4k3ckMngABHOJLOHrb+qt3C1Ce/74DhvJWXTgUBrlFRSpwCMf25ONlnD2DyoouVn
         lSqgjy+S8O5hVEwtbYU3Zuq27nchVV4j0m8gCjHVSZk5XFBXn6te1dHmFiQczr8oTRED
         +HN59oDcwopexyVDSNWzZEt4kQfsqHq1kKKMvCCeugcKqS427Uyi/41XGODeyyQXlcZ2
         ZPH34O7ovTssbGGkvvCdHxP/zUvKYmn8f5ApxEWiHSq5c3SwvfGRN19Fc3fwzNUZ3Nh8
         jPjw==
X-Forwarded-Encrypted: i=1; AJvYcCWtzKvo5PlX0Gh5U/xBfYYPLcMcIOAVh97ENyDWwMNQ1dZfYtPVkqJ9bk+JFWQPpjPuLs9/aRYm4g==@kvack.org
X-Gm-Message-State: AOJu0YwAZGfjRIgXxLCu51bOV3a03Ikamz/RotI2E1AGPCS8XeJLAMeU
	K87bMNuBqSd0YspW+qtGtdnWySpclzDZCcuX2SWcy/2VhLH7lM0iFXMNJ1ViN4kS35XLD3CZAV+
	2rK8eVxeVB843A9S2jFgoPh99aEgKpeyi91+t1wxLVAUUWYaCgvog
X-Gm-Gg: ASbGncs815J1s59+Pf/C9J+OFQDVulzGZySNF38J8GXbEsRBLayzPKDCunNMQHfqctk
	kYtolwKFTv4lcaI7giTNSLM/YYHUe/Tc7DmpnNo02IyyVbdoZrAL1+Ewtte7sBspyS9YYx+ryHq
	mAqT1BsH/FCvRj9cx0eEnbHWlYl6xMKZD2EZPoWUvKApetoymadlrAZqdgXeQMNG0gWO/PLhb50
	/Xz9fhXW93bnqxSzfQC43UH4OjSNCXEGjjo5wxwKLhnwY5CcNTzqRwrLVZmTrZst1X0742jWH7s
	R8htPKSPUb/c6VrBO4NA9Y5GN9mXJEjnpk5pnDms+StTR+EFMmTIxtgLSK6mDxHaM6VzKq9/sRH
	ttTaDgkqD2Q==
X-Received: by 2002:a05:620a:472b:b0:7e8:39da:9735 with SMTP id af79cd13be357-7e9fca75d1dmr182363985a.14.1755660445651;
        Tue, 19 Aug 2025 20:27:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9qFFsOUZW7BdZPaNwh9b+/hjR594POxsy5yqcNk8yrvy8IpcBso8ImATmHus1Hv5gu4ryFA==
X-Received: by 2002:a05:620a:472b:b0:7e8:39da:9735 with SMTP id af79cd13be357-7e9fca75d1dmr182362985a.14.1755660445227;
        Tue, 19 Aug 2025 20:27:25 -0700 (PDT)
Received: from ?IPV6:2601:188:c180:4250:ecbe:130d:668d:951d? ([2601:188:c180:4250:ecbe:130d:668d:951d])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e1c14aesm860958585a.69.2025.08.19.20.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 20:27:24 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <113a8332-b35c-4d00-b8b1-21c07d133f1f@redhat.com>
Date: Tue, 19 Aug 2025 23:27:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
To: Gu Bowen <gubowen5@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, Waiman Long
 <llong@redhat.com>, Breno Leitao <leitao@debian.org>,
 John Ogness <john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
In-Reply-To: <20250818090945.1003644-1-gubowen5@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NDwG1QZt4tq8jTBUpJcVMn0KcPeZMX-bmd6d1PAF9T4_1755660446
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8s67aqbwyhfhm6ddkq5ot9aoowe5hjmh
X-Rspam-User: 
X-Rspamd-Queue-Id: A509C40005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755660448-940448
X-HE-Meta: U2FsdGVkX19LQyX9k3lk6wOlWv0Iu5hdg7Y/QkYnnv8oaMWZYK6eG/Z9YQu/54BjKbJSmS44SMDeOs9sZ4oByJv26jCYQQO2kwvqtRMDHTs/03/rH8H77YpqdTTYh6W3KTHDxXH+bEgSNXoOAbIP4Lu5rkPTwGFWDK8Dl7nSz/A6b8ldwDku3RUiY4mDs7eJLUpHrgRlMy6uf/W+l3mFQ2t5jofZMA55WsOhuARDgwSWXehc/icFdEvUn5wkjyy/jKR0JwxT8He2ZjxLH5dI6ZGGpxU+A2t5uIIzAM3Ob+hztggDm0lbE/QRjgDtj/vuQqO/HnqLo8VEekAt2XnR9x4EZTUZMnGMlidzZd6+TiUIoWVjFw37YTUsAfkKf0cp4bHJPMeg64OUVgIB1mN0yvVDfYNUwPwk13sIl77mJ4Oz2Jp3WU8rmcYFDhoYRNwxQUR7sYbC87+ZgLBPC7WCXb8Y8IuOI9M/gAc/wL0Ms6yfSDuvpCJo5itRhzIxn3V6Xh4XpcOqUiRBS8hKXAY6dIxYz+XAb7OBhVe00tRhUhBquNta4bPjL7ceguv31pim7yUl3x25yVCapZ9ccMkbAh1F1HjGC3HVx4tUTqGH4Mi17zEEUZWsLCrYaEl4MCk7f3Lg6rOxSxX7iRRamrFdGl3Ng0YXbyo0+fny1AkXSiU0fVsyv8DgkBPruBPQh5hxaG6N75FMraJ9pwVHxYN80rJozgeDR8Xui/uSmolWlcMFGbJUApqVXDYJmPjmogFkx0VH/03227pcXrVHDZF97tGVzwK8kJLihimyGKslHofRana3CICgYsuBLna/6h7XI05X7EqEvVLbACF0txVY3IfU+NS27PlFjrz4tleuB//S4e3mDxUpj8JWkF9AaFPEIHYsmEUWa2gvw9EDCW+OKdYQLNZ9VbAgnAPk4ipjfamvUt/y+zIdboEUTCyScQdbknGvUsxRXrxQ7uy46s0
 fIQkFMvZ
 nJK/aQOCk1mXK+zYlw80M5VCVEuf6hhkVp7hhPYKHznb3EVr11GKtBaWgP78W/STgHkxrK/vG0zlUdoqhn7MGC1373oi2Bb5m2rg6iWyY8oN+kYNgsD8V12oM4mC42d+HFxUpUCOgwfxip/WR4cpVF8yR/uBrNUygIJ4ppfZdTE7v8dAmGQpbwRx0q8F2CN4XAaHwJBem9buqIQnO/NRu9Htus1wgO2fUOIFCM13lj47ujwQDAyRpDQlsV1kM+8zZArg55cNrIfSmyi//YdIZNm4PZNHpNuwcklexASJHpo9VfjPHweTOjKBG7ECOFpQhUvc3rlP+v55l1P+o/gWjU841AxcAEx0TzZLEe/ewNnr9CD/2LY8RtlAe6xLPek9dNEY9/Ck9dZiGY951n4TsMKBMqs3YP6SRyJ2NSN4rgaCIK+Q48SWYcE0ckgV6yWeC7MIdWjoIZaH0ixY6MF1lK6Sp6PEocFBNpHv1XXjfpj+DuEuWkTWyUaYsRC26iJ77ahiae9UoQLK24euUIQjzeBmoEgDePvasMheMkxpTN9LSvqreEguLySz7cH9KBNwbs3oTFKCfKR+mJik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/25 5:09 AM, Gu Bowen wrote:
> Our syztester report the lockdep WARNING [1], which was identified in
> stable kernel version 5.10. However, this deadlock path no longer exists
> due to the refactoring of console_lock in v6.2-rc1 [2]. Coincidentally,
> there are two types of deadlocks that we have found here. One is the ABBA
> deadlock, as mentioned above [1], and the other is the AA deadlock was
> reported by Breno [3]. The latter's deadlock issue persists.
>
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() [4].
>
> [1]
> https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
> [2]
> https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/
> [3]
> https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
> [4]
> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
> ====================
>
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> ---
>   mm/kmemleak.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 84265983f239..26113b89d09b 100644
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
> @@ -858,8 +870,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
>   	object = __find_and_remove_object(ptr, 1, objflags);
>   	if (!object) {
>   #ifdef DEBUG
> +		/*
> +		 * Printk deferring due to the kmemleak_lock held.
> +		 * This is done to avoid deadlock.
> +		 */
> +		printk_deferred_enter();
>   		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
>   			      ptr, size);
> +		printk_deferred_exit();
>   #endif

This particular warning message can be moved after unlock by adding a 
warning flag. Locking is done outside of the other two helper functions 
above, so it is easier to use printk_deferred_enter/exit() for those.

Anyway, it is just a nit.

Acked-by: Waiman Long <longman@redhat.com>


