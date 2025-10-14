Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC5CCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C25F8E00C2; Tue, 14 Oct 2025 03:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A138E0005; Tue, 14 Oct 2025 03:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1C78E00C2; Tue, 14 Oct 2025 03:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE8338E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:16:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FB7411AC67
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:16:40 +0000 (UTC)
X-FDA: 83995862160.22.A324F2F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC6264000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:16:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BLmpW8oG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760426198; a=rsa-sha256;
	cv=none;
	b=SmTxpK0wlU3zdVreG0smIbDzLEQS4cBDNaztxgzKCAFwejXqOZkdIeXISHK4Ods44fvReP
	fFi4rpE4QpVzDqJnxoszVB2HQjiLmQlJeF+YOXPCZDZHjv6k0b9rF1Rk9LKUH5ZkHv++iV
	lgo0GsdebKX/SKuMpl91s1255CmocHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BLmpW8oG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760426198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNzJjkVm6Krfhx5WJymur8UH8L7TxKDiPZmR2XA6IqA=;
	b=qEe1OnFY17naNFhqhnjr4t+0m5qYa5RaEFQi0Kos9L5EPrTgBzr0KaHGPrE35JkyhZJ6yo
	slH4OXOB/zplb/JCp0apaZt6Zh1ltJ23zrvELi+nniSVLTTvy8tujnDF/8j+AjDkkPO2TX
	6l+nWNfzgPYefT17dDEDnvIUURDxEUY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760426197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NNzJjkVm6Krfhx5WJymur8UH8L7TxKDiPZmR2XA6IqA=;
	b=BLmpW8oGKWTwhEomWltXTuAJSrN7gcBM2LeHBBW7UPtlVCt4NN1SoRETM+tYj1q5sejOJ6
	MqX7UEeF6IrRnEHtH08gfwkf0QAnZLXzFpPKa/+FEBMH6b/gW+TuCb133Fz8SgSsOwcmXj
	0s/NNCKLUSiWXDWysd3LBFGhbRX9xAc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-WsL0qlp8NvCRkgXSCqWtbQ-1; Tue, 14 Oct 2025 03:16:35 -0400
X-MC-Unique: WsL0qlp8NvCRkgXSCqWtbQ-1
X-Mimecast-MFC-AGG-ID: WsL0qlp8NvCRkgXSCqWtbQ_1760426194
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f4fbdf144dso3307232f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760426194; x=1761030994;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NNzJjkVm6Krfhx5WJymur8UH8L7TxKDiPZmR2XA6IqA=;
        b=T3R0PBV2xcto/FKo34JuTi18jfoyspfTjdyX/gC6m4CWpwcO2FbxlXym6X5nnzsgsF
         nkBQBSbg73IuxkqKl/D2ojLsLWMglHiOj+kNCos0FFJMlAF7TOqG7Ek4BDcgWaKyi9wy
         KIifTCfQXGLCTIbCZ7pJ/TJ7tQN7hziEq8+DT9/vKhg+yangR+U2J51Wxl+5mIutPG3P
         apXxNjpmgOSF0Bygaa//8X24Un2B1Gu8eug28KQrMQZrs2MjcvWxOhCqC0vonDeIuYOL
         t8by0Jbq+s5y+PS493+RXvbGTe0UwFv/dCO85R3Qv88Dv9cRKtneVlNa81hexsDfWeJj
         EZdA==
X-Forwarded-Encrypted: i=1; AJvYcCUEwDb0dCxest9WCI/PxlWcQOFNkeX5AnFFqORxpDQo32V+oJ1SHUjGGD5lQD6p/Y2Tyawa/EUUxw==@kvack.org
X-Gm-Message-State: AOJu0Yx1SbKwKHHuqjSARrJepAg5ihzfqWDtqn1P3aw6S2K2XIQScr6Q
	fhoiWnvtLhIuv1xQP2ebaXg+Zo1I4SnnE+zsFj/Nlk9J/v7J0MJzW/7HZ+gnkdxFAP4cKCsDLMR
	AEvPZzYM4VAzZvnhXjpBrHQbSwP1Bn5ynIBw0YH8d6Ml4iQ7uUOW6
X-Gm-Gg: ASbGnct7dsoiuNy2YnPSrvB5bW7VIlUN7ZQEaeywBCfQsstXduy//JpPMB1TEOMZJib
	fZXf7K99xwHtgvL2OXiGoWshEKj+pn3kN8cVuixr4kgyf1Sj12K0OHj626kTUoiU3a6XxGnqu5V
	r4bVos5G3oKCjWZQ4pnaEtS3S94zlbrJpraPLJopZSWUrD7m7UAcnxjlGP6SC2CUsy0VJsmyXTA
	JzQJ8nZM3rpcvoFTqBDFzsR3BcLYYMtKgXaeK/K6bbmilFTj/pi/Yr79JSNdgATSigcuCQkc67p
	nYx78qczcASC2fjvV0Kceqff/yJBP7p+jgRJ8ZR/nTVqnAboAJnxxvjBwui5Qn6qA4fMB0dG4Q=
	=
X-Received: by 2002:a05:6000:288c:b0:3dc:eb5:51ea with SMTP id ffacd0b85a97d-4266e8e0995mr15164335f8f.49.1760426194248;
        Tue, 14 Oct 2025 00:16:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuKvWIDmCQxcWqsi8qpqZMZIhinHqPiyFtxwizBhyikphR66KMLSRYExjhqUKKSjrnjSCQkg==
X-Received: by 2002:a05:6000:288c:b0:3dc:eb5:51ea with SMTP id ffacd0b85a97d-4266e8e0995mr15164311f8f.49.1760426193830;
        Tue, 14 Oct 2025 00:16:33 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582b39sm21788264f8f.15.2025.10.14.00.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 00:16:33 -0700 (PDT)
Message-ID: <93736a75-3fc5-47b0-8985-96e1b0b98b8a@redhat.com>
Date: Tue, 14 Oct 2025 09:16:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
 <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
 <4469b9c3-3656-44f5-897d-b024e030587f@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4469b9c3-3656-44f5-897d-b024e030587f@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tlMsAX1FryNXMghOaFbg_hkv3EtyUzWE-wrnDiHpwyw_1760426194
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k3dpg3z3415eqzybbf1q6fbqs91weqzz
X-Rspamd-Queue-Id: BC6264000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760426197-62433
X-HE-Meta: U2FsdGVkX18DSwYQBfjwLawqzaYhFG30Q0T9H7lLAKG9hlEHZSMgpCspyvHH7ue7mWTNtFSXk9eRz2z5SA2WAo921688/S5J0i/9TMnvOsmFLnmPY3DZHhKyMoK6KFjeE1ROtn+TS7brNuP7Xcvb0IxrDLEGz1vwaZTl8xtamoqKbRjYkY9Y8EQbnLrBdgGhsqr2FXRNeTXhsOP6uKDvd01G3W/UDuN8B0uk8saBT1QL+uxsGaZhCl7o481Ruopu8nSq3sXb0pArHfbxD97137pufCElMlYkaXpZNAOftKe3dTD9qOjOo5ne1Wq5owREYsKCDdZGEvzJYge7NmsjdTXcRyNY2pzOfdxqIZALUo2que3si3U7DMWQ+xWaR4mctpnY5E44sGMZQLIQgZbWbdkCNp4zkCmSNdOx/7UNoAMXqQvXbNSUlWmrOPhQCqhyIYBN/yfKdRHaPE8fi16QoIr9ody6x1NEH6CuKZE874d0eu80SY9mYwmzr2dPnHqoiGHOhuLgAax14O0dcTPEF9EMxeoVeQC42dYtxaeEAPAMsOUaX9Shnw5sIkcWpjksWaWtMVuNKNk2rD2aHLh/jnTxa0YwZCRl1dhRii8USRrl92M05kMBUZTy0Pp7MyNgIs1otoZScQkG+v+1Qh0pNqP4g8WNngWOYVJJ4LOsFZU2s6251JgnX0SoWe2Fyzkpt1/BPSEAOnwF/HjMo2II3gCv5W1e0oby+FQZC3tiz6b1iNGdFWOIaXPiBDoGjjC/bLT1D5Il9wf505L38TyKUuWISr4YEgw/t7rNl032qyW6/9mq+TgR8tT8LPblimsMnTMk0zqdEIUdJFSg+lU3i7ZieXB3IsHwVTFb/7MJLPsojJXJKkz7fbZpGBGe9BD4DYLBpzkk/drgsxbravPssS7krZ4g/WFnYDY2U9Yw/kYMyGGdeEaRjemT7jbIA6W04LoynIve2IVP9/ev6mR
 LFBXkRlt
 8flBq1dmG9vMQCs8IeTnHLHNf1J+aZQ6Y3oSRkhRVO0iq924eHoNIQYcmnWuaU5263b3TmoWlumWl2pn0Zy7Sq3nK3umAdzN/+BzKLMTftoAXMvuv9kJxDWfCQW++ceMOrSwnFpz3kFH7ePt6SoemeRrHN67RjowTGGXZV1P+Z45yXpn6Jo14/lCyY3++Gl/4Fr0hTs5yii6m5EBxxEurS1ZjrtuW5jqg3H8L1bcujXf5iADD7zTnj38q3jpCcQt1xTM3wvYyz9p+vR6b4GWDLOAuk89a8oOBtKNLoiMYTgctPY7c4j2Z2i3pMsuOgM+QYvFP/fFSskYm/3JsLbO0lNPE2IqK1VoGsGfUQsdBZBhyL+5q7RAgdOGY/QFhjwro7SK/rjywGEbPSaWUim/Ufg+KZhGNGDAVTKeOPmNL9o+9BoNyXSM94MVCcIpyqMy6tcULvDHpe1whNytJLaz8BHcDVLhmOZvqsr49
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>> +            if (prot_numa && pte_protnone(oldpte))
>>> +                continue;
>>> +
>>>                page = vm_normal_page(vma, addr, oldpte);
>>>                if (page)
>>>                    folio = page_folio(page);
>>
>> I could have sworn we discussed that while fixing the prot_numa_skip()
>> fallout.
> 
> I'm not follow the thread, but we found that vm_normal_page does
> introduce regression for mprotect benchmark(libMicro) with
> this vm_normal_page().
> 

Right, I raised it here:

https://lkml.kernel.org/r/aa496798-5ac6-4cb0-bdc2-91515172e935@redhat.com

I questioned how relevant it would be in practice.

I'm surprised it shows up in a mprotect() benchmark: mprotect() itself 
would never be able to set MM_CP_PROT_NUMA, so the code wold not 
actually be executed.

-- 
Cheers

David / dhildenb


