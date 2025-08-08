Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB48C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03D96B008A; Fri,  8 Aug 2025 04:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBB86B008C; Fri,  8 Aug 2025 04:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAA26B0093; Fri,  8 Aug 2025 04:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B75806B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:08:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A95216166A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:08:38 +0000 (UTC)
X-FDA: 83752863516.23.231893B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 14F84140009
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:08:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i8SebLba;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754640516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMpQ0eVp+S8LPFTLWBUQHKOEFtwDO/A3CIOnUSWgxOk=;
	b=3jNP/WoPX1pZ9gK3KUg8InQqPZkxAJenrJvXeudfhOfeNL8GTSN9XYkFS4JgfRYkvTFAb8
	fhiNat+Ry4exsCf2wuzjgxGcyeKK5+qrMI0geKqpSbeoljjBzqv8TKLcDtlBRk8bhoUNFH
	T0PdxvYSWPjwG4tkrB9Gq6tOdU/y2Pg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i8SebLba;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754640516; a=rsa-sha256;
	cv=none;
	b=zRkAlUAFfr7MMvlJzy9NgmMPplgsiCMQpqKx6W4oWUZ2DrqwlD5klFPwwnyPLw2e80UYeM
	oAcl649xsatdMpcr1fjAXpaxUB7/1ZHkGcO/rV17rur4AWIgYwBnAJgzirUfH0AnTPyLHB
	kb+VS4tp1q6OevgC9L2xkvKfI2ds+rY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754640515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XMpQ0eVp+S8LPFTLWBUQHKOEFtwDO/A3CIOnUSWgxOk=;
	b=i8SebLbapedtwoo2ma1qCZDO3XKu4uvjo+FZz/+x6L6fxOCDjkDa3H7cXxVELV6zknfVqZ
	PYfCQdi1UV59Fo4+76mQjBlKRtTnEDadpKCSRPQQtaLVpQv00sPZdJ7lBo5vHx/S9LSLx6
	HfA6myW763nKLRhxJNh0yAgHMiYpP8k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-ox0Q9cfnOCm0G5n4Bdc-6Q-1; Fri, 08 Aug 2025 04:08:33 -0400
X-MC-Unique: ox0Q9cfnOCm0G5n4Bdc-6Q-1
X-Mimecast-MFC-AGG-ID: ox0Q9cfnOCm0G5n4Bdc-6Q_1754640512
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459db47f138so6821765e9.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754640512; x=1755245312;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XMpQ0eVp+S8LPFTLWBUQHKOEFtwDO/A3CIOnUSWgxOk=;
        b=rfdazqJdZ05LAc2aawYYXi/rGkLcMawqo8iMO+B0bRO4hueHC6gDsKeh8KhHySe8El
         fdJ9pOrxK7uaJgAfiNWmw7gKx2Je7Z7CrsVUlNoN5oJwLirjLMb8f2LLI0IBsDFfplm2
         CHdhuNg0hxDllTzhB928q4O+9qEUiXXezQAAOwIJK7yfvzhkkGaTw5s3Hxq3iHCQD99p
         B/XPQSRbYo8mrKu+4UyJPeWfKakSC7bGbmHgDuEn9HqJ9F7/LBf0brEom2LSEnV/Qrxe
         t5AfBIPjULxnSScBE1H+5ztSsCcrMIAG964+D8aFV1cmf71/frlyF21rKsHMafzvI5b5
         eaGw==
X-Forwarded-Encrypted: i=1; AJvYcCULxTwMj2LZFxBRnijQYjNFDQAaqExaEKHwgwahNvVV6s6+4ZWN7PJdLMKWhFbqEhqkYlnZkOOKaw==@kvack.org
X-Gm-Message-State: AOJu0YxBNTF37p9F1VzXZRPikCBvimIjNgzxenYitWXRFhLNIKpWIY/s
	qMo5aRN+M4QbYk9UGaoSa1SmU11NBN+3m5QwH+/O0+UjftLrH6DePGNFhUAeqqlswmzvl7ZfM1p
	R8rwv4/4vtnw5g7+gBeK28YWAfklYbNxqciAXMtqu3R/KlQmd9Rur
X-Gm-Gg: ASbGnct2Yc9Pqni+GwKneQlwuqKLXAXaaZlisHtklGwlvDHcQaH8DA+1AyDuEuWWHff
	B+EgoR83LhDvmdNBcP4qV/58dR0oiCFHVaRPaBknXOxPIDMX3HxFb1h/6wNmbpV258dqtYh7N9n
	jC8/7OiUJ55cqZb0uXocqqpd5G45TRRnimWHjJgs9zyFaJhGGv6njl3nCqI3oXA9KqW/Y0RWs2K
	nBWD0Jdi6zfilV5LhmuSJOVhfBwq+NA0LXBvEhdAeVAb3hwOU9qXXkE5/abkzg/fUnGSafG9SvK
	e5iKdKg9pV4hHMrzasOZh8pyvJk9673zEVQMS4vTgCN+gYnOVh1ffKa/CwloKV+249CItCzZkP7
	shXBc9XkU+qUix2Y+30f5Zyg/AZSL5e/+V/Yk+bv4eikbcVT+qB+L7xjGT0jVIAj8
X-Received: by 2002:a05:600c:3b1f:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-459f4ea0e52mr15793695e9.7.1754640512318;
        Fri, 08 Aug 2025 01:08:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwEh6IhpSkfy2wUoCVrt1y1GxmbyBMHQtAKjtAKY7xsmZcr67ZJRbkvjYxDVru81Gv/d2u9A==
X-Received: by 2002:a05:600c:3b1f:b0:43c:f0ae:da7 with SMTP id 5b1f17b1804b1-459f4ea0e52mr15793305e9.7.1754640511883;
        Fri, 08 Aug 2025 01:08:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5869cccsm139284515e9.17.2025.08.08.01.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 01:08:31 -0700 (PDT)
Message-ID: <c7ebdbcc-aba9-4860-af7e-add209a32879@redhat.com>
Date: Fri, 8 Aug 2025 10:08:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: Jinjiang Tu <tujinjiang@huawei.com>, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org,
 xueshuai@linux.alibaba.com, ziy@nvidia.com, osalvador@suse.de,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250806020520.631203-1-tujinjiang@huawei.com>
 <1a4df59e-e734-4ff5-b1b0-0a754afb6f67@redhat.com>
 <14abf20d-d3d0-46fe-8184-6dbc97a4e5ab@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <14abf20d-d3d0-46fe-8184-6dbc97a4e5ab@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9JAcyQvEqTHaa75VoxMvefH49c__kn7_PvsfHM9_Yw0_1754640512
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: et9mpyx761ottm83rojruesskan4tug3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14F84140009
X-Rspam-User: 
X-HE-Tag: 1754640515-109037
X-HE-Meta: U2FsdGVkX1+objlKZCb+IJKzqAPVBhXdNFxVxXTQVwosh+6jswxskY4HOQYr3cz04ubyAv48loc9hzfnUebebCAoI0sEnwUqWbarlSRTld7FpTY/lBJF4/y1AWmUj2U6ww/J3zT++dykzOYbpb8bVaJGQpp9sgwgfme//dOHb81T+i35axe9fsWaDlr616eTKi39yjdk0bPR8kgIQDN9aziF//7m/cmgT0CjzdFbPC8JDmWtWGV1s4q98QJ2XwTokbnw+EpNBGyBt0iofaaJ4/ZYUlngysHgcydKgjmIYcg2vL0IB+36bGbzmZNs1GBvhgaMmcwWLgrSi1LI9PzzJUkYv+m309kYiM4zbxNDEwJquMXKp3LwDxc8JbmUIgTNTBrJBiFIJMT4Xnea/9hKi+IMB9g26QMJCNEYbzvnR9S3/W0wxSgRfGhAPwcCvw65dcw44Sd6Ci8479KpdEYygGLtRyFbgyBfOFTcJ60EuPPK1Ca9LMTgxOoNDn+BbuGYWA4e56TZNr91eeNeVS9gyrwHLzTtVKAzOGJCL2HuJdrEkvGuJE9qa2ixK6xgyQTTdhQEPBUZMgznDo3ehaheK+7GIB8pj7EEeNxE8V/Djn0/Bfm+H9Dl3kWPqBEX1XM7PyqSRyQki/TQtxtJlc43coya3Dd031bVELLLss2EhHDKdGhTkKvyYnnYBsAHWXObbhMqiZMkjaBVyvLDEozzuboYn3epYLorAcIljMl5MlqNimkJRniSo0YPfJEHx+Pa5wTF1DYOWLV6IpqrmBVcQoBZIyBvP+xrDPVuZ8o95OSlD3fBcsD8GkfamX0cPcpiTwCJRxRa/WNYDbq0aQh4A4PNasXcwC2TewjUfBmWp+4SXZZZLkVw53c+2n5Ez44cWn+bYcWrFOBqcKIkWK5AbQPdiPeaZYzXdmyTMSnKeENO1Ps0NEB4XYpEGv3l9HonA6JfBzHK0CC6QvHsj5D
 0J3CohsA
 uWc1lvbdOgzT9ZOUBg2WRTJoowmKKEk38jIFH1PwMC8lSEdQgsMz2eWTqwq5RZvdK5tv8Parjx2tsmnSX4WmhN40M8qkz1Kxap4HMzxAnmooKbCBlkUkcLo3HitTfrzgH6UhkZ/5csBngXuZSJ5yxiUUflgXy4ByfDT3TY1ZUiWI4e5o1XI6r8i3ueXhq6zjz+7rPveZU+c+HSigRvCfjBCOXE8kOQA3t+96Eh+E5/6gnua/wNdwc3X8DHs6nGvtHPxfsCjP0qigZFLujSGZHALDvuDyt+6H8YnWYtEnnIadSOA4LTdIw3tGU37J1QXq+Fjt5wK55E3xrootpS2OhAZTv+9kjOGCt+EEWfnUWU3M7CRhlFbtAiE2rTrnK9UPVV8C7r6ZEE9A+hZ88GSP/MY2j3FgSC1ELxdRkDEwgvpY6n4WkclwhaP4SVYocFwvofZ+OjreIllie6bLy48MSk1f+h6MJu27jWoV/H7qhkOny56xLNVhAlI4LR7Pj3x9kmdGb+6TyE6XjXdGblEcxCxLO4FnHsDQWm02m/3+ySPrMqOYQZwpzJ4dlrA48VwB5ub2D7LjyVCNL949EH0mRDKd0ZBghMAuAxtno
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 13:06, Jinjiang Tu wrote:
> 
> 在 2025/8/6 20:39, David Hildenbrand 写道:
>> On 06.08.25 04:05, Jinjiang Tu wrote:
>>> When memory_failure() is called for a already hwpoisoned pfn,
>>> kill_accessing_process() will be called to kill current task.
>>> However, if
>>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
>>> the vma in walk_page_test() and return 0.
>>
>> That check is dubious and it's on my todo list to revisit that,
>> because it doesn't make sense for COW VM_PFNMAP mappings.
>>
>> But I am curious, is this about having an anon page in a COW
>> VM_PFNMAP, or on "what kidn of page" do you get the fault?
> The pfn is RAM pfn, which is mapped with remap_pfn_range(). There is no
> COW.
> 

Ah, and that works because in check_hwpoisoned_entry() we are only using 
pte_pfn().

-- 
Cheers,

David / dhildenb


