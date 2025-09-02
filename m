Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C56CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBCE8E0008; Tue,  2 Sep 2025 15:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD088E0001; Tue,  2 Sep 2025 15:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B748C8E0008; Tue,  2 Sep 2025 15:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A20C48E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:04:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B2CFC036D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:04:33 +0000 (UTC)
X-FDA: 83845236426.23.D4724F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD57D180006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:04:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WCC7UbjV;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756839871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTRbTb03LTpsY+kMi3vTzUOF7OI46/nmbSDtqXQsQaA=;
	b=d6hgy58avOKfSmpypZ1jSX24h/yQBVpNE1bvKPZc4SHuRNP7Iuczcle65TXl90jwdKQv3b
	kSZOjDMo+OduXpaNn3mT8kJxOfgLHL9y/zoOLcuH6wfF5OHx8KdQSbieOjugUpQkduqh5X
	+4DqJ+jtL1T2/NskWe6XriYevnIylCY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WCC7UbjV;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756839871; a=rsa-sha256;
	cv=none;
	b=5yn7StYam2ltKjFqf7mZKU2zN4/qKjDoxeUjO3zb2McEcJwp3Hdl7KPFckbUyNQpUhyf8B
	8+5tDPqk+gXda9FGfcmTVqmP8+ch9JjgyXxkiKYOAnwx/x7ljNCDRvlBc7x3il25M77JmT
	F08ZEa7zmWnznUjS21wciGRS7VAac7U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756839870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KTRbTb03LTpsY+kMi3vTzUOF7OI46/nmbSDtqXQsQaA=;
	b=WCC7UbjVULVsnbQ8fpcroUecyMlCO1tn48mpzkF+zz4IYKltiKIuqzg/5kDwB6CrdDtkVA
	HC0kJqerzbW3+H2usrJ+01i+oxGAOQmlG5zWjx2XWFZwj0W1vPG2vvJ7ls1EBM1CLvFFDL
	WbasZWoqj0NhwmTmvbO+nGQIveV7W9E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-AZGAKK2TPASRFiMVoBXMxA-1; Tue, 02 Sep 2025 15:04:29 -0400
X-MC-Unique: AZGAKK2TPASRFiMVoBXMxA-1
X-Mimecast-MFC-AGG-ID: AZGAKK2TPASRFiMVoBXMxA_1756839867
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so45944255e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 12:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756839867; x=1757444667;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KTRbTb03LTpsY+kMi3vTzUOF7OI46/nmbSDtqXQsQaA=;
        b=GMFy//0V3Fw0SOB/x0uoB7iWVMTA6+fJCsIJzl8ZbKWzIJnhxdwNzz4RRhhWSJGQjz
         hM1sK1WXMaaKWNzxjwQKdV2rujFOeWg4RlkVybcuj/l0EmuWmPyyv6r+IrwCA02JqTlS
         x7SZOZRUTWcWOR0qMHZy2FuT9qf+saVfBCwlKAAVrqRDMkIgjoIuexhMYD6Imdirmmy8
         55wgWiyKnCF5xqN6b7VeCB5gUFa3qnkopPAHfZtYnDjf/UhFR7eywZpISxbCN8jWQ0UY
         kCDc60VQABXoLpabb4lzUTDM+RKXhk+ez8Gpy8vBr18AaAVMLqr+mgry9YO/+cjX+jQp
         XkZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPgtkQDzifwGmWGToI4uiQJdTKRQC23eEFofzmM4we5Gukc/oPxJHrPGCyQqwsoMIG5mMPcVdN8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx3t+u4ioKZxBeJMwwe+MM8vQ/tHyfdQeru+t+L+L89LIGzUdBK
	BCzqxCtDQ/1NeCT0guMWmNBmDK1oBd65+y3rY7509OVPYDeeRhOn8A4qRIASEqdORbCUJYGaQKx
	Gu3FSbtK26TwOYgs9EGsBRFoSUi4XlXSswdmhFJPxWeI4vbSyKHDm
X-Gm-Gg: ASbGncsDLL2biD0mOEfAcU9l6+lrLnAkZnTQ/yJyPrG9pE2SM0gfFs8MgWd6JLGv4fN
	Z+fD27CWIQUvk8+6PkCy/zRDF+v/4/4ZnvIh1CghbnpTvZPskllbLO6a1zs7o8Q1SC+x24FiKNZ
	N8yJfRl1/VadUZelZv27cgEzaKBXNTgBXjZkg7kRfSfrfYL3WQGfYVpLbtSoelX9/WfPaoigHFO
	+1xe2MApNmR+7RIJO4jVXX1AmQevWPLNdtxwLH8/V7FtPxnFCGBjy+S5CAlbh4Pteq9JjLKJ4Fv
	KSf8wz2g6vpTvew1FxsFPkDMnOlGks7Xzw5a/TeWRI2PI6GUmfzBGuaIHn35PyBMc1WBMf7ZhMk
	n7lKDQoQK3hSlpqfKWN4pIHcX+loW4BZlkoBohAoXgFxOPohD2Fnko0FTeR9kJTtKX1s=
X-Received: by 2002:a05:600c:3543:b0:45b:8822:d683 with SMTP id 5b1f17b1804b1-45b88321c6dmr85814295e9.4.1756839866912;
        Tue, 02 Sep 2025 12:04:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4ZcW8yeA944p6sSftrTNNVzyMJNCGA2g5/WkaSIdV2mLjEgNupS0gXkk9kO1eEWTw0bxfSw==
X-Received: by 2002:a05:600c:3543:b0:45b:8822:d683 with SMTP id 5b1f17b1804b1-45b88321c6dmr85814075e9.4.1756839866506;
        Tue, 02 Sep 2025 12:04:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e886619sm205500415e9.15.2025.09.02.12.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 12:04:25 -0700 (PDT)
Message-ID: <e513c127-d4f4-4e93-8d4b-23d1e4fdceb5@redhat.com>
Date: Tue, 2 Sep 2025 21:04:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
To: Frank van der Linden <fvdl@google.com>,
 Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-4-thierry.reding@gmail.com>
 <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UDrxSmaFGDyzV-k9ayamqO1S_HovQl00ow_Nj_XMnSA_1756839867
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y4kd3gbjtw8ge688qmm3pdqpyu93nkyg
X-Rspam-User: 
X-Rspamd-Queue-Id: DD57D180006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756839870-832009
X-HE-Meta: U2FsdGVkX19+m13pBuNDQPjH3jJFcH8bUkWaf4PK2jHg3dFQEMLZK1iOkqalaKZI305usUpDCIbzqdDIHv50woLKTlfwuScqfuIxFUAC6ch5xIWHqGWL2c0XzpF+HPKO2qeVeEO/kYWePg7M3+FIvpdYlRecjzTvcEPcBN8zutgavEr6cyApBn617PL4kbJ+q/qDI8zXQG7nibq3BYuaDgygQUYcj7DEto0gsbx3h/sYmDjbAXeLpW9HvoEnlgSUFH9UWq7FROk4RB75VOF47jY3DAxGknTzZ63PDOIdSqgCHWHfEId2pSVyeh8XcbdM1ZuO8IovdrI8nqPOgGQhjsQrMutv1cR7eVUQJbYQquvawJzjdfZBA4HGmLMqh6fpJHR8Kz0GEodl2k0up8q9GsVvBTEBJX1nAKQjVg2YtEaKtVBdHECWcqDA5bximr0DRPxRJfdL3FgRKUgxZ0tZ7+fnO6XEaCgexPj8hsIMwhJ3aAAiuDhLfGkEaUQUd2FTcpaN55xIWPnb6XnUlQXeB8sITV6uO6DKycOrfDprHceY/cghGIlIfu52/3nvIsXVnWPrBb3xaf3uIMg8JpkYXSoe28HF8kXRexktsQDEYvnCMHMNR79j4uWXPp1WYoTfRe9cGlpbGfFOpAKliWSZd14TaaTATa1F/PgpTdMqJDVl8OYHZj0GTrvcCxS/eeNVPUwux2qVEEUvT4ftqU29J4kjpszAhStN4iNatMwWN31nSH9m6H7yl5a3phik0s1oGyxE97ZKOI3lAX2IhidTzGXZdZgnNqL3XGPC6LXg9oZfvsQlUHycZKJRbPJMRc7BTbNdQxMlqxGc+iBwfL+EVtzuOULBwiupZ7xxVR9MoFgc61952vaBfPi39dSWwSqiz0Nv3YPOY7mt2e5uFOEjBp60myIo5aN+vXLmazkAdMQ4XApNbxbNuZT5qrIIUKitlXpap5CMGTZGOVbdFb0
 t1eGlq4M
 X9svKqDRdDNleh4X1QOv4JhS53YzvMJS5LTo29J3W0QCP6H5C7pO87Gctotfty5g/zWsahxWYqGLHdc8neXrvt+VISZwPtBAA0j9wN67dooOFyeXsTJ6N7TDmgrJ1ydRS2lPIMsex8eAsh/Q/UPsnXXPusQprnI3Nyjf7fVG1ftVYE/6IJZHJwEhkX4wj8Z6UO3RQLY090hvUUyjQsMgQC+P85o8lQXmWcrKKWkl36jt15Tj/uTNvLg2WQTuKeIjsWpeljKe+wHU2BTAjjgcOBFr7uP9AuxL8jpq83EwVKKr4CbNQhzdBTKO1yJj+CvUm9mhVA5rK+o5H8m+5/wNiAUIXlkKSuya5MP84g6cAxLCIbg5nRa0ZYKqMMzN6l4g4ao01wMslUECCaDufDnwHSd0Un/OEcM5rtUbP6Rzns1+vRxERk1gJujkfY3vV7YopTt6Uviglnt3yQS2Fawk4SXcihW7gqODuJNwFShbabBvF5aLZ6yZRqYCVS2Vxb5aZ/FES
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> +>> +struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
>> +                             unsigned int order_per_bit, const char *name)
>> +{
>> +       struct cma *cma;
>> +       int ret;
>> +
>> +       ret = cma_check_memory(base, size);
>> +       if (ret < 0)
>> +               return ERR_PTR(ret);
>> +
>> +       cma = kzalloc(sizeof(*cma), GFP_KERNEL);
>> +       if (!cma)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       cma_init_area(cma, name, size, order_per_bit);
>> +       cma->ranges[0].base_pfn = PFN_DOWN(base);
>> +       cma->ranges[0].early_pfn = PFN_DOWN(base);
>> +       cma->ranges[0].count = cma->count;
>> +       cma->nranges = 1;
>> +
>> +       cma_activate_area(cma);
>> +
>> +       return cma;
>> +}
>> +
>> +void cma_free(struct cma *cma)
>> +{
>> +       kfree(cma);
>> +}
>> --
>> 2.50.0
> 
> 
> I agree that supporting dynamic CMA areas would be good. However, by
> doing it like this, these CMA areas are invisible to the rest of the
> system. E.g. cma_for_each_area() does not know about them. It seems a
> bit inconsistent that there will now be some areas that are globally
> known, and some that are not.

Yeah, I'm not a fan of that.

What is the big problem we are trying to solve here? Why do they have to 
be dynamic, why do they even have to support freeing?

-- 
Cheers

David / dhildenb


