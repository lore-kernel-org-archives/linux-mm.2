Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41FC9CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3B08E0003; Tue,  2 Sep 2025 04:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9642B8E0006; Tue,  2 Sep 2025 04:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F7A8E0003; Tue,  2 Sep 2025 04:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67C7C8E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:12:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3431D140B5F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:12:14 +0000 (UTC)
X-FDA: 83843592588.17.478A80E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id DBC968000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:12:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SZRRxapQ;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zb5t8Q6aRCCvAvoxx2JGukWZxS6Bp6/fazEsZZ+kHs=;
	b=y9vBEAwBrc2eMCeXJm5+Xy/1xcdD/73k3gPtZRoR+YWqfQqkKkJv+0eUMnE5z7B2fyQPtX
	34gXOSyxrK7D0yehCvqvj44iJRnbz9whK/WU22V3BTeGT+DJlPmUlAr5BVFHrIkdca57bP
	qTnn0bHmQ62HEJkBmcAO7sLmPavOK1E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SZRRxapQ;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800731; a=rsa-sha256;
	cv=none;
	b=1C0Vm5tjKXFycL3DlD/+K7OIDbMG1MGC3zlJoruoC949nnhIcOpwnCxykorvHmPnnzgjyL
	TY5Qu/olLN28CrmxB/WuUNCEDDlk/BfpK2y9VL7M+KwZYl4I03Fai0CEmlYOD5FnKOfz5t
	U5IIrZEJbafCo7eQVD8moPr4JNs2Pvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2zb5t8Q6aRCCvAvoxx2JGukWZxS6Bp6/fazEsZZ+kHs=;
	b=SZRRxapQACkIhSQ2XEKlSYgxw46ISSxn8IRWNGBuynideaf+2GzesqNrTK8c4dajQXc368
	7QQ3vzMHqnFO/kkz17ul4QTjUR2gPSY8URdJ3r3zLr+jKcI+SQnKJpG/dqnk75LIGfgC+P
	Y6WbmdsZsYW3cMGIx21GwSBbrbvYm9s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-87aaJFV0O5aae6o29qO-fw-1; Tue, 02 Sep 2025 04:12:10 -0400
X-MC-Unique: 87aaJFV0O5aae6o29qO-fw-1
X-Mimecast-MFC-AGG-ID: 87aaJFV0O5aae6o29qO-fw_1756800729
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so2293805e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800729; x=1757405529;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2zb5t8Q6aRCCvAvoxx2JGukWZxS6Bp6/fazEsZZ+kHs=;
        b=cb+LlNOkeWr3nZLJSiKnklKmBcrnrpD44J8OmAisTHMHfvH02LF5f6EfCEtzvFCxEE
         W4kGhDYu3L7jLn6v48SYrqx2T4RiMDO9Q5h5UOhzRsCaD2ANIJW54MXjO8NFDTlUfDmc
         ut7o4Iqm8ThOXtMpROm+/x6/JSXK2/c82Gt2FBEKwaUFrqNGEGk0/UK8g+m4oP+ZnDY4
         ulFtMyr3slour5RIOa/PwgUZBVv6zYep12Z0AicdrkGv7UXuC0xxe8V7zD4CDVCy9YQW
         LQTQSv+SuyKprXGjmm6AOrgeiqMlULx8eKklfvs4Lgbh6VW152a6lMkSJRaTmXGpGFYj
         r0nw==
X-Forwarded-Encrypted: i=1; AJvYcCWef2eqncbTIPfheFaWFdsG9uPlgrCCkmkq/hQBf4wX38vdNjFEs/nz131M/IS2EhC+PvkSY7ZHSg==@kvack.org
X-Gm-Message-State: AOJu0YyFxjciyVW6A/hX1LZedYqpXj14CogUuVGNSTQQcEz0QNNl/Ekf
	/Pi2zbA+xyo0exOVqY8Yl4Dj8HrifS5FzkegyOVL7afv7hFIKheHsfWG5+Km+QYGa0G6IntY+/s
	ELLQPBmTtCnI5Huc1z9OqKwzVcUqKGouElSvFa8Dtio/c/o7ZKIvK
X-Gm-Gg: ASbGncvDvvadf48FaxC8LPGG5ThhP/v/TQVTdMOefTBIJqLLTsts/cx/55AwOhghbE/
	q+Rfr2UbEnYn0G01obKf3KDNC5rWnZPCGJ6HPNl/rMooCdyPrCOualBP62qWegNOsMSjq6i519t
	i2iFy6S10vfktHfSzdyx9nkcprgfBHhA9TqC+YPlCzBSm6USBZn+zKY0xR4+Sf22wr05guaW04v
	G69Z0V4ElxId9dnmMQzcSVUldHGtzHFJdLpQM+xH/XS9KgTyp/mQVkSfcYJtPatqCpdmYueWC3B
	E0R/ySX04quYGAfhe03+SaVpx7c8ITMZXFctyHh/kPk2F/YeSyr4zV20KCtKJ2bGm2HZNpvNJo2
	78nsWy6cSxOt3QtILG2jB5yZ8uHTEakqsehs1t48f3Fd4bzQ6hqQzdztqyxaCwacp6NA=
X-Received: by 2002:a05:600c:3507:b0:45b:8f5e:529a with SMTP id 5b1f17b1804b1-45b925314admr23500745e9.14.1756800728576;
        Tue, 02 Sep 2025 01:12:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMQKde6tuKuB2m2hPFengMNai3NoA7mhyO6qLDI4gze+ZpXVnDBYgp0JqNm1wzjYGnsylb7A==
X-Received: by 2002:a05:600c:3507:b0:45b:8f5e:529a with SMTP id 5b1f17b1804b1-45b925314admr23500275e9.14.1756800727994;
        Tue, 02 Sep 2025 01:12:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0d32a2sm290899325e9.9.2025.09.02.01.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:12:07 -0700 (PDT)
Message-ID: <d418e2ba-a3e7-48bf-9576-90fddde706f3@redhat.com>
Date: Tue, 2 Sep 2025 10:12:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/12] mm: establish const-correctness for pointer
 parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <76ec40af-d234-400a-af0f-faeb001c9182@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <76ec40af-d234-400a-af0f-faeb001c9182@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lVqJKZrPvoUEoB9GHYa5qb3GcsR0GJzy8SyN8v2zuuE_1756800729
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DBC968000F
X-Stat-Signature: emwi6bbr85h4zej1gpfrx714q1xjjhuw
X-Rspam-User: 
X-HE-Tag: 1756800731-597492
X-HE-Meta: U2FsdGVkX1/LvZlmpNHI8pay4hCHH/z2cN0TZFkSlfs1N4ByBAZ9DyIECDhttI/nmKOrgWKupCrLbyPSNA9vpqSlySU/8m6Y8+csXwNtnbW/pUwA8ciLJUHcira3kRzDTzpiB21CvCH+XBjnOJRlnLMPF7xfUzhmHz9+NgFmn6qlV+8FDWQeqhNTyAmehVQ697KoZHDtwe9M+ahOCX74R2CAIdQGND//yc1TnfGzXydZuKPTE5L1bdmaAGL/RoN9Yb1Qj7VXy3/97zc3zzJ/DqbWB/mOg4LvMbo3YG4SclOvyG94Pb/bxgfkJuJDdUbwLlCDBAzYZtH+CZ7+UqqK47X9mVeaF8/I0AenyNI8usd4jzgi4EreFWg3IXnkC+hNsIUcff0t+lMiOU+AKLZ4Q91wdNVTKEoMRrb7a+4d91RLe12jUZsFGnkvpD2nIKUBWBy8ugE/MXuBnkjrqOW3KdcVo6DPtrQpkTZwSd73CpJdWuT99/+kQTsjSfu5ATwwcANTlowm1q0iOxc8NZ2Aa74dQFtm3I6HHclGS7aSeuH9YzSqCMx6fp9Y/ZrEjCUDtdyn0oK7DA8oRB9VURikZTMdd1YQH2nZ7fumonTiT8HKQ0eMvIv+1qNrhfskBZQUTE9P2FffBG14i60qB/8wlYN4/tjXz3BHDrNwiflNLY24c6rPnM8v/a0YnRoMFMYtK9Faxb8w/m8BTS7bMlkjKEhkvOWq2pUCZPLIMpe40xP7v9I37IYZSJpdKpdqImRloeqSGKIkWpt47GBlK4I0AC27NZhodN0/TTKcZ0g3/Z44RhvCbKk7yskUQwdSlAjpOduqvZ56epET816ABwNJKD9r449jab/xn0ioM+ai/D1GUCVSQcckznscJW0ZjcF8ocSwQAjsJISF/rlChe7CsEc4vy4Sc5BYtJN4Nid/983iGFooVLepPb9aH5ou29VRlijm0Gfm6zcBt9lYTVJ
 DSR2DYOd
 rSTY9OyWaNFV2NysP7725tlFs5HFTC8eAPJRMsv1UURQzHr50ijeOlXsN9XZJDmBVvEJJ1LknEluMQyIer8SIvWKhfL1QNAmbg1Y6nBxAUYLUU0kDZS6aEaSRfdI596rEmb47v6k+NHoQKOpe8Iq3fIDUQpwUvXUAcghmDEAu57PzvPekj9og+3W0ymnocAl9cfLWGmE9cqEmf7Asfu7iQpKHCGADqje47JLMz0hwAPGvf8AOr6BIRWkTxviP7bcX6zFe6ZoGy6oOr73fNqXqCrvQvu4ASRticVS0IQCGbXdLtiQEAkZcFX0MQ4DRdBYmvOxG+oTansIrscssRBCks4gya2TtLckAT2014zD+M4DJ48mqLxp+cbqsXGQg9qlplElSRidF5K/45kg5RiClWNh5u6yIQFbfZoNEXWis9nVcv2IVdKNQP/fswxZoKa9FzNv8WRKTAcBBY1BR/VKAMahjH5o1TcM1e1uTbCQDcJonHOksPoLZ3qfn8Kh4ANcvkOghjdmF5dkAJSBXmrdquRQs9uD4+r0rBeFOz10V1AsTAeNJqF7qK+PzYdtlE3q6SZNebB8b5Taei1I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 08:19, Lorenzo Stoakes wrote:
> On Mon, Sep 01, 2025 at 10:50:09PM +0200, Max Kellermann wrote:
>> For improved const-correctness in the low-level memory-management
>> subsystem, which provides a basis for further const-ification further
>> up the call stack (e.g. filesystems).
> 
> Great, this succinctly expresses what you want!
> 
>>
>> This patch series splitted into smaller patches was initially posted
>> as a single large patch:
>>
>>   https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/
>>
>> I started this work when I tried to constify the Ceph filesystem code,
>> but found that to be impossible because many "mm" functions accept
>> non-const pointer, even though they modify nothing.
> 
> And as Vlasta said, this is great context.

Yes, that's valuable information, and the series is looking lovely now.

-- 
Cheers

David / dhildenb


