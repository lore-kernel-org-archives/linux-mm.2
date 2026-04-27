Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B89FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B026B008A; Mon, 27 Apr 2026 12:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECE46B0096; Mon, 27 Apr 2026 12:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F746B0098; Mon, 27 Apr 2026 12:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9776D6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:33:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 989CC1A06D5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:29:23 +0000 (UTC)
X-FDA: 84704871006.22.8021DFB
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A1241A000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:29:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RbuUferT;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777307361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSfx7+SmbHArcxIwIbdzwX89/TyvDFQ+ngyr7SD3GvA=;
	b=kRTp9E4N03PjuqqAmnXTnKzeTzMUqzdeofheIlyxswhJnvrl+iGpsJaqm17qunmUJqZcpT
	SlcYkz1+ToUi/LvR9841C9pWt6okegXjxtn62VymXD1WMFmWEhh6gZHgeMZDP0eDubeZi2
	UaIuMjaHIw1gZUO64rBcWmAmaUfbHPU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RbuUferT;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777307361; a=rsa-sha256;
	cv=none;
	b=0QWdmNjWze8dMPE3iuNvY60hDDyhR2m3//ZDKt0nCUWAFkEc5JKs0dfc0L0Jhw++H9m1XV
	YRNzi39s+k6xJwPE4N6xngPi5C1+nfFDaoozZEgRgapQGG47ThX5e0DWgVVTpXPjMCYhZm
	QGaNZP6BEr4l+2GRb/eQdboOWa0vA5w=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38ce0ab821cso89103791fa.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777307359; x=1777912159; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DSfx7+SmbHArcxIwIbdzwX89/TyvDFQ+ngyr7SD3GvA=;
        b=RbuUferTGgf0zs3KsPC6hEkLMPY8NJ8w+QGMmbtnW8ZO02kqMbItiGQwEQ4CtQ4+bZ
         o8TzUK8TF04g6YLkFVLo9SNHQ2m2vklX7aun+iNTU8dsdfLcHcSuKtxkUBT/CwZHzhIe
         Ab12tgus4UVuLKlgJQJcpNStEKKi27EG28K0gmYwNknCXtREKnN8N7GG6WYcRj7gAhW1
         GWHGbEXP1918yi7CmwlehCIFOELoxdEpZGRicfwsEYHBSjFVHfgPTDdm7fXcsif73r4A
         bLZUvknDisqcnYRhNDBp0xeu76XB0H++n6HyeJF0yLjtMWmGFG/+6pzouXq5P8NRgruJ
         8NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777307359; x=1777912159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSfx7+SmbHArcxIwIbdzwX89/TyvDFQ+ngyr7SD3GvA=;
        b=f5rq7c4zCCRpCKb5VHrnIqf1qFodKE8gZutyKtqeZd78XykJnJaExMVw8prJ1CJQNW
         Ad2QzVylq0bGrf6fFMUwoNlUJ3V9ody/JkJZtMjne51iSWjnq2La2eOZTkBSqfVAxtKF
         TvcVGiBLXIM+9KCQv9OjoJO3VyY+P0CU8lfsxLCFHz1D/8u9vqdqK+rVNY3T2Oef1wTB
         /RQOOqvUEt0NDwi1VbepNt+5bUYLH/zr2isUOfMPkmYZCGAKAVFzgEFGR8yn14J3gQZN
         f8ykrbdw6ipii6/h3XK4KrgJmalnHTMh3fvcIVhlifjiGssHaI46APmm9QNG0G08/Vmp
         6zEg==
X-Forwarded-Encrypted: i=1; AFNElJ8MVM42U36KQ/bMHRkOF8QYHBkXWzxZ4rlXNsVjzq/eCC3q5orhAS43GMgoqsVQp5CNKLT00D6TgA==@kvack.org
X-Gm-Message-State: AOJu0YxV/eD/KzXup3sACyPEFKc3bpXIx9GG0zNR2pcYfxMRjwfvhHh7
	Ab1zwH+b02hhpeECGtRYEFdX1jovJR3b3obvHrDM8rZWlNVDRZTOEcAEY+Whsin5
X-Gm-Gg: AeBDietfL0+n+IfGIfBvIbTn6phWBO5tVAK7b0ug32qLlD9LvRgRKc1NxSdLxZbGdGw
	9RpMc+VyRxp7YeNLwMEL4Z7n9tJ6w0jtNf24E7l2OslJuX2by1TFfatcqSbbraYH60I0QaIY28q
	Y0QnM76s7hel2Zw4GxWkR2UEuya2LW8xl9hFQubyH15y3Vq8pONAW4oAKleD+K80gD/O3BbiHyo
	1rtHyrbohGKn+Fd+EkVdwHVD8DEpiwaM1MnoZ/qV0e774WgFkfrvT79yxlPG4lDiAww/9t8+gEz
	z/Z64wfg/325sYZr109IshhKKTOnSzWYMn264e0DhDTaOjYxWmty5bBIbHjfGQEZlX+G8wLSWTl
	scbJSzId2FVzs+NW+OyRPdqR4feqIqW1gqugUgu3FHsE8H/tmaS1mNVikBOXXO/E+faXqazTcdo
	Y=
X-Received: by 2002:a05:6512:1189:b0:5a2:b59a:5e99 with SMTP id 2adb3069b0e04-5a4172e7bdemr14244454e87.22.1777307359417;
        Mon, 27 Apr 2026 09:29:19 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185ad11fsm8240873e87.14.2026.04.27.09.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 09:29:19 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 27 Apr 2026 18:29:17 +0200
To: fujunjie <fujunjie1@qq.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, shivamkalra98@zohomail.in
Subject: Re: [RFC PATCH 0/1] mm/vmalloc: reclaim tail resources on large
 vrealloc() shrink
Message-ID: <ae-O3URyANS-mkoV@milan>
References: <tencent_824873CD3C7F2A76CD237A308C00DF18580A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_824873CD3C7F2A76CD237A308C00DF18580A@qq.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A1241A000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 6u9x17o5khdh1eph7zdbfmf1btqnfgqg
X-HE-Tag: 1777307361-73749
X-HE-Meta: U2FsdGVkX1//GwpWnnm4i0cdx7sAeRdn2BWlKnngW+ThJZSPk3EkP3vcygwFZTnrmp7QlfbhFPoTHtyhMmAS6TEHSLPOTUlOfJQkzbu0jhpKsqAcn2bghIPnoTkkd0f7JHq3pPOMhacVXxY2Qn7qQAlmjU8pQNy/QXPhYX3K7u7crtDeNYc30KtgAHNPZU5z/SWqw/ApzRfbyeYpAXJ0TSo5D/K3S1NpeUzdd9vomZrUUOJ/N55Mb5K4DDvldFqOTleBIEermUrlVYTABfS+UMRoU3Hpig+HzF2QSebWQR9wUhbz5ODklKi9Ryjj0tKfeC2HmgZMWdI9dl7KVjI9e/r8v3b4EgHK641upcepgDMmylhOqoiat0xGrIjnbvWPtP2vTFFWskMrErKTcngFF/oLMKGW3YbOmRmKt7ac1un+gfVHb2Zf1vNPgpNT5M+2cPA6XjrkHoUP1f5Zk4vcW+7sjlAiWrfG/3W+JbJti7HHeBYzf+uxK4lGogUXuNM94xhT2nGly5WbnY6Kgio1jdk7o6j4h/UHvn69TLc02+C229PaUtNYfJnZL/Lze0FFKi3tpA02l3KcLiQMOMXo26iHn9zWEP5mLLoveg8YUsIafgOCHcVoZmCDAWuRiiV+AAskmTiWrPrqAYflUAnqxqMdhJbL2R89nV2AcZXZBpgF1a4OuS8Qq5pI6RyYvIeLrkQckr7TdtFPrExJj4ChEZbyo94kNP5CyGrcpTKtBFTHH5nBQUW5OgTgFdqxwxQS+SBa4OTje1x9o7sIpZYBy402k37TQbdQnH4IhNcOxojDPz+0SvTS7DKlKcuo04g2zQPTkOc1EYzIUxw83qDCjYXUkRky+p/WlefwAkNHjBR6tQrRrzWjwf2nXlffk5CMFkk63e2EUWQ6vfYitJciEslCF1FVai0XThFi8FHyyIeEa/IJceTQuKqowbuWZULpfa+eaZDDDlahlgUv8xY
 FKRrhM1E
 Vau1xs169otKxfZi4fTG1tJYTHqvYxj4ETaPhcM1eNItPcRtFsLN6XIYKI7IwHnAt/UALaVGUX7/V2YLxghc8weLPEKauh/+cE5I1tSuOTJsNk6DvGJifDwfV4NsR5ImyCGYbpihXEsftjMzMbV+DfkDrVMtw81s6qObChfM1zxAAX++URT8Mif9V1CGDEJbpPlz5Mp72yOkUX0+jN6mB8Vi9PtXCVtPlfuXTZSGOYK0jGo5Yc2xJs0gqSiz144aoP39T1ClBVkt2/XIvsMk5KhKsm355nvahmMzuhwQpgCgh0yzX/4BpQ/OXeQY32RMV5OfOrEtuu6N7dLQ43G5tWwRHFxv737ju52ZqQC7+AU0tGqE5sx5k5D3Mt6fYiH1a+DqQAtMPg7lXITFZxtkzfHqlqbjwG/qPIhDCb6l8jQOwujhU6RKZ8rDwjrXA3YE5YCqoxwFnr+zy2ZL6J4PWLSmZVO+GVlFDjBz7ix5snIl0/9/qmldfzg9sM6fKdqwfWqQ+i4T0EdbsfTy76sKVCbhKpvEp5fL+N6RSO+euT9GHve3PM2HeWhavVOZKaWIv+3sw2qqGTXDt+2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 05:28:56AM +0000, fujunjie wrote:
> Hi,
> 
> This RFC explores closing the resource retention gap in the vmalloc-backed
> shrink path of vrealloc().
> 
> Today, when a vmalloc-backed allocation is shrunk, vrealloc() updates the
> requested size but can keep most of the old vmalloc mapping and backing pages
> alive. For sufficiently large shrink operations, this can retain a large amount
> of tail resources even though the logical object became much smaller.
> 
> This first RFC keeps the scope intentionally conservative:
> 
> - only ordinary VM_ALLOC areas
> - only page_order == 0 allocations
> - skip more complex vmalloc object types
> - only reclaim tail resources when the retained waste is at least PMD_SIZE
> 
> The current evidence supports this as a resource reclamation fix rather than a
> workload-tuned performance optimization. Local validation currently covers:
> 
> - synthetic large shrink correctness
> - shrink-then-grow regression
> - threshold boundary correctness for the current heuristic
> - KASAN run-rootfs vmalloc_oob regression coverage
> 
> I would especially appreciate feedback on:
> 
> 1. whether this shrink direction is desirable upstream at all
> 2. whether the initial object-type restrictions are reasonable
> 3. whether a conservative PMD_SIZE threshold is an acceptable first heuristic
> 4. what kind of in-tree regression test would be preferred
> 
Could you please have a look at this work:
https://lore.kernel.org/all/20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in/

Shivam is working on the same feature. Could you please check?

--
Uladzislau Rezki

