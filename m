Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A19DCAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED1C8E000D; Wed, 24 Sep 2025 07:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4B18E0001; Wed, 24 Sep 2025 07:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B37F8E000D; Wed, 24 Sep 2025 07:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57C0C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:38:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EACA55B326
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:38:40 +0000 (UTC)
X-FDA: 83923946400.01.A77C7F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC8B510000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:38:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pl7stuKD;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758713918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nr7Ue+Q8mDfosTulm3J5UwQG5E9B4yAzAZ8LnR/jDs=;
	b=zn/CbWd6oE1m2U0JtoE7xi18BavVjOMgZAJZzI2pXe05Rce+Y4vw5K4kJPOl9wAguk+ny+
	lkVsW4Is9AF2ohh7bUU0MQYo6n47tzgUWPRDGdujQw7snzq7w6xyy5pcsKDHIJH+dm61Ux
	SLPU70Ia/bBg3R43NH+EsakOm2ecu/Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pl7stuKD;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758713918; a=rsa-sha256;
	cv=none;
	b=wtUs1TKOvs04N9fcitYqhzPYBkOuspCgo+OMwX1BIDD1iEeNZAJ/c8guor4W3OcY4RoRmr
	aGFVorsQWry4v/OSWj2kjLrthpAIGeL8oOO0mJmjWflNW1g7yrNXi52JUvoWp4openwbSB
	PHNFyaFO4ZFdo5AGtCCwYwfnoR5UhFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758713918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+nr7Ue+Q8mDfosTulm3J5UwQG5E9B4yAzAZ8LnR/jDs=;
	b=Pl7stuKDQ1QJYa7p82DVVBLGNBT7LJ0C6SNA+EBCtADNAMHrA8+Jm8qq+Hy180pH+JzcHU
	CPnrMmpPF0bZvbF0Ab9cXz/SmvUjJWJHUAq4bGGJX8hsr08NL0lJJUcy819316GvnHlwKL
	F9BgVNzEt3MvgAXk/GQvkihjmHZaTbA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-EO3CE1XTPkaVmOUVyhazxA-1; Wed, 24 Sep 2025 07:38:37 -0400
X-MC-Unique: EO3CE1XTPkaVmOUVyhazxA-1
X-Mimecast-MFC-AGG-ID: EO3CE1XTPkaVmOUVyhazxA_1758713914
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46b15e6f227so13728505e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758713914; x=1759318714;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+nr7Ue+Q8mDfosTulm3J5UwQG5E9B4yAzAZ8LnR/jDs=;
        b=IE0VDSNwtzxwAxVHG6kHrEHnfXBtZE5c6Qae2Dld58QOVvOOs0FoX+lXcy6AVQLFT/
         ep0ArkMFpiA8lr24c3DFI7kh3V1AKG10ndD9oDxV3bjUj+bHTS+HSFuqMGAjyRl2eg7Q
         xLqRPgdmSTasvnrc/rAQx8t9vot2k8Rv3tI9lQMcZ2dgUps/Aw9bYfq5CfUlzq69GGk2
         ww61dhhAyswKGRWLOFYyHntmulxXqVATRUa7bhaRFFMqzmLgo3HwgUczTGHXN+B4qWZh
         P398PN/y5iE0Fp8YSPc88ZB12fwdFnwNG8e+uFaqwOAWaZ9dK6bHYO4emkSOVlfXoikk
         bBKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk4z826Oxzvkb0qk/FysT4TszvedqNE9BiuenC9K2Niws9TdLVkYjHu06bAxU5cnDSS65ban8y8Q==@kvack.org
X-Gm-Message-State: AOJu0Yyl3+yKlja1mwaKE5UNev5ylaotnWraRx9hya5p50Vdx7jRzn64
	70iN+OxkI6u7OJgPvVtC8wVDMreKQAhjT3Iyjik6vIUyf279r3HFgHpLAGoFp5FQZgET2DmVUO2
	VKuYm9J+t+8lYFqoBnj05CoB83k34DhTAtuof2twDne3qaKWyjwe4
X-Gm-Gg: ASbGncu6YOrpWDSN9WirJvpB71jzruqmVrV32qNXJofhIrhlkKmC06qgwDI7EOO3+1e
	nFDgN7KFqjo/8abgvJdwNzuVLYwa5K5ily12tmuUTW/oe8WWekUjq+pXhonTxiWy5DQUGFAAY2n
	VPXozuvw0d43jrIJo20CgMdsQt1X4+VZ5E8wpcJu1sw+afJ+kNQtArTJZYj4rr9xF6tYwFJmkHj
	tHEo/4np/cgc/LtcVa5dwrAPhs/XXYkfheDJpoqEIHNvWN9osMPHq4ySPx3A6m3ZqZ63bxEo4jg
	YD2vRNP3ggKbam30A18Z/cjFRfcsgB0u7xhZfUZFdFf4hv1QsDat7UgDlESK61Jg6wg6j3JdlCA
	SgJo2V7Ier5K4QH8ziHMBh5zJpRZ9JltaQVFX6ifWiU6uQ8ZUIAVpxzX8HhoPPk0FuA==
X-Received: by 2002:a05:600c:1f8e:b0:45b:9a3b:34aa with SMTP id 5b1f17b1804b1-46e1d98dfefmr81427455e9.16.1758713914075;
        Wed, 24 Sep 2025 04:38:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDyoQr1XMCzLogNb5hrirQ5E/He80PBLPI4tToWKtH2OlAXQ+KTAg/KFfVKjMR/pGFLjp+xw==
X-Received: by 2002:a05:600c:1f8e:b0:45b:9a3b:34aa with SMTP id 5b1f17b1804b1-46e1d98dfefmr81427215e9.16.1758713913699;
        Wed, 24 Sep 2025 04:38:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2aadf5c9sm28867015e9.19.2025.09.24.04.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:38:33 -0700 (PDT)
Message-ID: <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
Date: Wed, 24 Sep 2025 13:38:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
To: Stefan Hajnoczi <stefanha@redhat.com>,
 Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>,
 kexec@lists.infradead.org, linux-mm@kvack.org, multikernel@lists.linux.dev
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora>
 <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora>
 <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250923170545.GA509965@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wGzoyLJjcRl9kY1YvpAvMEf8uI4rJ3lqpkNGsrVKciw_1758713914
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wzf8ps68r94d346tms347o9brehn9mdj
X-Rspam-User: 
X-Rspamd-Queue-Id: AC8B510000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758713918-120683
X-HE-Meta: U2FsdGVkX191CYoBbCAZZT+wZYdo4wLW8sSm+YGHsQO+JsAMPKB4frtuRTLPrqAd1OcyUqSW1vqecNTRBe83Mvh3wmN2IcnTWm1spHanlp1ktdmg09JZKdvOTIR4cMeGUaR+4hHQ1GAuoe16zbXXDwvNXSDEiUYZ/seuo7lNRMCsOfIP0OVaf8evgCnIvSZM3Cp9EHrshfvtKkNnGKO86fDurS7Ney/rAvhjiqtNlpywl6XVrgpNaW8Grvhzrh5A2sRqFcxbe2QztAZPxB3gyBrU5f6zkVURPbE8BuhwKNNBUblWHbwLqysPas6TCubkMDNZgJqPqUV+gVHUvGNisWA026ltcPiTw3OB2JHvwK+gZYmOfoz2liB+cHyu99PQLDcM77OQxnpiRp+VaTt44O/6nd4w33JdOZ37i7MGSvrvkfMTF8wzuJx+oCSvM6OmjM624owHow41oaxYZnltk81Iedd4Y6OcrXr5uDoX4w0f8ufGe62eRMiW7V8Lue//d7vrM1TuRqkSEPQpJ8lNWcMCL2H2Pm0GCchqoHlo+XJgKjtros7P4LfeRsqMmq22lnPaiYEH9m3QLk6kbN9dd8WFCqEL3RwG0BFefNpslF41I+YKjST2HSSisoZ6Jnugl0j42gj3eQ83Kk1xnXEEejhkT3K0psvGlhQyXS911CqPqhOkik3yS3D3/SL9lHTbhlOJXY4MbIIRNyr1bK3Jq04xNmLWagRphE7A8qfxJZgoUgEXuI4eZEKtarV72Mv8zorroNPCy+iNZXxOA0k+2Ob+qI8btIEO18p26ib/7myTGkKtYXLhD1bN77QwGT4+76IVGdh3WitguVRPdQicG7NnYeCMzxRDYgU5B2nA+9FfwYSu1rIfYcCx3dG1XtLTWBlRzxT2QVTQV61cJ4UDvnjlX7Cqu5GDFLn1HdXaLl0XQPtEG6Op+tByGw/b63FYiaNFPwtoPczVwcRHe4P
 r+mbWoOz
 fsrRUSwM7DMRFQJq4JN6AtHcaRdhbC9vnOCRFJMA9SSXBsNQyhS+RDZ297GrxrzxTDaV8vFpUZETL2j5Tt2AF4163zliuOZM3w77sBaowsyokivg9Q95hGSWaVJFPE6qDwM73aNXO2pbQovy+xfNNM+2I1XYF2qaKnKwIQqC0n6mJQtQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Two more points:
>>
>> 1) Security lockdown. Security lockdown transforms multikernel from
>> "0-day means total compromise" to "0-day means single workload
>> compromise with rapid recovery." This is still a significant improvement
>> over containers where a single kernel 0-day compromises everything
>> simultaneously.
> 
> I don't follow. My understanding is that multikernel currently does not
> prevent spawned kernels from affecting each other, so a kernel 0-day in
> multikernel still compromises everything?

I would assume that if there is no enforced isolation by the hardware 
(e.g., virtualization, including partitioning hypervisors like 
jailhouse, pkvm etc) nothing would stop a kernel A to access memory 
assigned to kernel B.

And of course, memory is just one of the resources that would not be 
properly isolated.

Not sure if encrypting memory per kernel would really allow to not let 
other kernels still damage such kernels.

Also, what stops a kernel to just reboot the whole machine? Happy to 
learn how that will be handled such that there is proper isolation.

-- 
Cheers

David / dhildenb


