Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E321CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3EA8E000E; Thu,  2 Oct 2025 03:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394178E0002; Thu,  2 Oct 2025 03:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C278E000E; Thu,  2 Oct 2025 03:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 121F38E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:55:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3CDC160316
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:55:01 +0000 (UTC)
X-FDA: 83952413202.27.C3FC6F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5BFAAC0006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:54:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/r4OwOe";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759391699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vikbvMujRxH5+j8MHPapMlTJNADuVwLSxX8Ctdq/Fn4=;
	b=s2TCjulnnzgc/DElcpacaAJCqulvwUZDNVyUVMwUJuYcM3fcKKadJVzwADWKRh2pJPJpAR
	/Vkfj1GGFC2behpSjQxt/NLDExrvvUHVExuWJ9oNY1beVJW/QrDMcWG8ji6cdjb7hdXMYW
	FdIcwJddWCKnWnul5fQbBYi0NInMj30=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/r4OwOe";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759391699; a=rsa-sha256;
	cv=none;
	b=IBkcM1Lr9GjxY8zCqazydzFh/Ewo2//Nx6WOLMAKHvSCnLPyu3tnjOsw/fn2nc3zi2hmfH
	ykPBHBWkEmTIdqlmh4yAytkA9BUF8qZbcmHXOQMtlAyctwUStzDneITIaN1EIJsPaRXGql
	vQCiP09m2dVBgBCGKr96h7ZiZh7yWJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759391698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vikbvMujRxH5+j8MHPapMlTJNADuVwLSxX8Ctdq/Fn4=;
	b=Z/r4OwOess7EcSQJql7uoMPLtlo+QbxeRHfhws+qgdu/kIvmHJg6cFUR4Rb91WgpojeuSE
	FTxf67wBFXfdEI2KwEvYtZM8DbMs9/sAq4VjQfbJ5hRt79RBGbSVdSCv9Fs91D9ONNJ8k5
	kXxkyLHmxOdhDHDKrKYZLC63HzT6bfE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-jcC3K2BDPbKODkpdG-p_4A-1; Thu, 02 Oct 2025 03:54:57 -0400
X-MC-Unique: jcC3K2BDPbKODkpdG-p_4A-1
X-Mimecast-MFC-AGG-ID: jcC3K2BDPbKODkpdG-p_4A_1759391696
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so269210f8f.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759391696; x=1759996496;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vikbvMujRxH5+j8MHPapMlTJNADuVwLSxX8Ctdq/Fn4=;
        b=xMotwkEclAPPbSOx6OSKcVj/PG3aTEP11I8R67C4dMyq9UnW+ZJFWC5hxOao+ZyVpE
         HEemo7hlpjdfpWA5WwusyCHDC0b1wMhsh6eXzBi9abhqWjSVoFkwN/jVLzmENg+H81KK
         T93d7pL4Ur6DAV3DV3wIXssQbzEgieHu7j9dGo7hH6h7gt2Vj4Wdr1RL6QkSKR0/9A6J
         Ma94S5uMDYtSNiiu2fa996pHxcilJWiO/0FFoTkqSY/sfYwgztnBYuHYnpi6FEYk8Q1H
         /sPt/nJG2rukSoacrkGvD7lP3G4IqyRKlinPQcN8NETs1w9GNQHuoA/lgXh3Ebeykm6K
         YB1A==
X-Forwarded-Encrypted: i=1; AJvYcCW23FR5k10Poj7tSP4hlov11ZM8Rq4d4Pl7uTVEyqHFCwTifVUHsN2RiPoDepfALTe2riQexqJmyw==@kvack.org
X-Gm-Message-State: AOJu0YzrGGKrGlYOPxvmdcYk3m5JLYjp4DqG/c0NsnynKcLkjMFGJ8Dn
	WyrR6UsntJ+J0vcSP+GFbYS6L+cVCcjzNA5OYB2dkJHf4dXq2hzWknk+nPzsAt8Mx+TPxssK1mU
	x/EGhhF5gCI/OJXyQzvUW+mBasO3W6N14xnpOic8TnLQ0wwBbezQC
X-Gm-Gg: ASbGncsegm1RpIobUpSo79cvLLArUQ/VzFQhICLvDadYQ7GrEsYkI57WJSh1YrGdHxc
	9/DQAGBtRhFcpdaZ9LbGFiwiN1fZgbfd4y93KRojZURz8Z6SqiQVQ7RL/vip5xXg1B+LgIlvOZ4
	e5+VRDzkvF++JV/DnmfqLguMu1ubq6BHEBjvQpG6/IGRFXHGzHiIVgS2ARL+PLEOQfz4ONCej3p
	NaRD6CvWSf5OeS+fSi/VpgLGmtIs6+3gQWFdiPI8d3pbLyq3p+KPJLltemysstk6Y+J6Au66qag
	GzIY+Zcq2PxJpAXUrhUrtj4RaYV5wnRgdq5cSxtc1GHaRuQHjOIXqa52JXUI3Ysidk/fUNTsq5N
	rmr9sMg1B
X-Received: by 2002:a05:6000:420a:b0:3e7:471c:1de3 with SMTP id ffacd0b85a97d-425577f1b33mr4696232f8f.14.1759391696275;
        Thu, 02 Oct 2025 00:54:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4ucs9qEAt4KkjYeplUmqpl78kNlA5Io8C5XuP/RQbkK+tZkwKR1bmiFsNk+oZQa0IXEyYPA==
X-Received: by 2002:a05:6000:420a:b0:3e7:471c:1de3 with SMTP id ffacd0b85a97d-425577f1b33mr4696203f8f.14.1759391695720;
        Thu, 02 Oct 2025 00:54:55 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4b71sm2383313f8f.57.2025.10.02.00.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:54:55 -0700 (PDT)
Message-ID: <7b7028f7-8225-475f-bf74-a0e6d3fa90e7@redhat.com>
Date: Thu, 2 Oct 2025 09:54:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: redefine VM_* flag constants with BIT()
To: Jakub Acs <acsjakub@amazon.de>, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Peter Xu <peterx@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251002075202.11306-1-acsjakub@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251002075202.11306-1-acsjakub@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x2oFyEMZe_BnYU7Ihxe7ZsWSH4R7OG52-hnz5TRlYy8_1759391696
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5BFAAC0006
X-Stat-Signature: br8uji3gryn951mp8ye3xct4p6id5mn4
X-HE-Tag: 1759391699-202982
X-HE-Meta: U2FsdGVkX1/bnZ9DL2wDD7I9obmsySUpGNEcDi842YvyzttkEDGxd5dl6pPSDA8rwUSJXVXG3cunRSSXhoFg0QJWeC50YkX85zF5fbMBrYRuzLxwbc1KqBj1sf8aiIk4iOPcfb4LEKaVRYXvyqUJT70tFbO4wDo+7eGiP+WCAji6evYCBadbB70QF3eVHURYkrZvJ47Fr4nmxMfDM031GnKOCaSC+1KzqJLpz7qniERqamZqoRL/R8L2RXf6Gc+pwa90dNTXyJbg7oerk8CukAVBFJP5qlGH9YFArO2ybmbHp59a4r0zblaadfiOBFXnClwMhLe8CeN1UrNosFdCLBSgNfrOtUFqp+UVzmBg92qQ4eEOfkco37LgQmHyYqVRHgitt/3jOBZ9I3FrRlQhE+6dRblHkFWEw/mTtByPi2Ws4GMyPQ0bZvaQN/skY8+8wisZhPq1eOnJYLrAZJXzECyIDrkzro1L15z2XlaSCoBSRTsct3kO62CkhRDjVEwj6qeFd1ECpLFTxc9wMriroQ4VaL3KqjLubmskpgFaKGFKdo2IOZQUA2d3jntPeKkMRrEsGcMpsm3vp+t04cZ/9+Ca9LgAJoMkBkK6AfaqQ03HvrIUF1MhIiVMsrs8BAujXDNlKOsqPbOLE8kRQghxCjXylwsAEIsMl7HwbhFslSlrBcPKV+5767uPzsbe4FrJNsXFsI0HXILnUBnpzHXXo6vGfmj5qcjFwuL0Le/R0WCYUm5Uow7CRjbch5m+9lzFmYaI5hcpATcNH+TJreII5poXYHjr67nQLIlJNcogUQjMYzf3y+NhU3cZrypDA5yep3JCnzElMPyOgfyrSwl4teINuroOhqdMh7CdII7BGDr3X7L/F4rLi5dLWTr9KMawHQI90+5KxOXUc+aUOGsE1JRxj94bxru0zGKThn4QDQsnHcia3H2D6/Cw8ZL9FupFsJuxcdV/Rj7A/nPa+49
 yM3Arn8i
 4K/dESh3jyEtICYMRE2StfUlYzspscL4cg1NbmqxdzEkUAz5IGSweSxP2WI2hfBAn3y1olrc1+9Ni2yv42cHX3yeIY9oekjb1WRP1VbcvIVzyFUjpDg3d+YSHOuYj51VefALLpj8qeiwdMu7QTdzufVMzFr0RcpPau98NBWGuvQ6Wdn4RGwTK4aXOQAqXskppGxs0MFqgxNC+hz1MHR2aZqrFgdgUfzfYJAhHSJE3YsYTVteFchD4lwXOxJqc4Wm6O0LOAhXvohntC3CDw+uqvI7am5BilRVI/Wnqn3yrtPpGczGxSTz8XtNbpKwn83etYCpzK6hj6g/1N4pok6dYrMCK3UvxDiQm7je9Y+UBtrgrk+mnXLszFBhyJkYh0wwKJTj8qtFaslcp4Ep8Ega52vvK9AeJc11RST0Vi+0BpCvTPSXDE4Tp4MrBwVxl02fHYKR6IPoCAUpD8Q/vTkw1iJQ25V9V8ieKczL5FahdcARo6pO7RjCLibiOPw0+GavgP7h2DwC2/nHQXeEZhuPIo+Z7qckJAV0zvrFbdq7tL0x0+kgUSy14+khzJjfcdv4L5GnPwhdPYTbX1n7GJjHUlhjtX5RamV/1MXXhkLa0Pfqm2mZXCVEJV2dwn/cfb2yymSClCTVrJJKpN06Sl3G5V+OcJoE/TbBVjL41QmqlwQ/80fA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 09:52, Jakub Acs wrote:
> Make VM_* flag constant definitions consistent - unify all to use BIT()
> macro.
> 
> We have previously changed VM_MERGEABLE in a separate bugfix. This is a
> follow-up to make all the VM_* flag constant definitions consistent, as
> suggested by David in [1].
> 
> [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
> 
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---

LGTM now, thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


