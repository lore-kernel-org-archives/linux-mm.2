Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15662CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DBB8E003E; Thu,  9 Oct 2025 14:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE2E8E0002; Thu,  9 Oct 2025 14:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413958E003E; Thu,  9 Oct 2025 14:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 305328E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:57:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAFCA140B07
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:57:29 +0000 (UTC)
X-FDA: 83979484218.25.EB3E693
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6CD2F40008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:57:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d3Q8Hln+;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760036247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iAzp85+07WQisNUePEagQ4q/g20R/GAnT+gB8Cya3Q=;
	b=uT1+qb53Y3O+TmxkkYEbWdtCkJpnx0lt2LrSdS1Hc7vEmAPSadL0v11hrMXmxWY2U6tED4
	bpfMyXLMQ+YYB2IUUsv+cImTh03U1+ukyku5C+PU3n1C0LN8i4IJkMnH+grThjOzxlBYo0
	I/TEFVtvXqgeZz4vrBbc/V5M7Ii+U74=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d3Q8Hln+;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760036247; a=rsa-sha256;
	cv=none;
	b=Ntcq1IHss7wNscCsrGDy3HRTKAxhz4J779P4hKC5uiDP2sP3rbiXI7Ft0tMz+IY2JBW9vQ
	0Gv0/X14XnaFp5JU/xEVQRbNCSs1GXXmVvRwm7JlzkipQa9dp255n4EnMOvANXxnM1EfQQ
	SvMh69SdqAc+ra3s/C39HLk3n9Y7FgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760036246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4iAzp85+07WQisNUePEagQ4q/g20R/GAnT+gB8Cya3Q=;
	b=d3Q8Hln+8cfRzhbBk1f44gDV9fxnc3OQ82VUabbY7IZj1TNgc0V0z48DsK94IQ8jFVSq8c
	LX3rgaVtiUqJMfTSNbN+n3rD/jPodoXJmEckQH/stR79JVo4FaX1vgustu3tAGHVdWrRwV
	NhCEv4atwIMW9R7mUeJ4RdYd9hueaJM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-u77PreJ1MoON0rtGVYHjyw-1; Thu, 09 Oct 2025 14:57:25 -0400
X-MC-Unique: u77PreJ1MoON0rtGVYHjyw-1
X-Mimecast-MFC-AGG-ID: u77PreJ1MoON0rtGVYHjyw_1760036244
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e502a37cdso8743325e9.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 11:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760036244; x=1760641044;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4iAzp85+07WQisNUePEagQ4q/g20R/GAnT+gB8Cya3Q=;
        b=CEFHMuv4gns1Mve21S2AdeedBQbHuk8cjYOzKhMFCsQT/MvCTfKPWDiRUE75mRqLak
         MdRB8ip6z0etb5Tl0DGFjakaDwVeAuZKQQXcGFazQE6WvP7EuWgINI4rT8e6wDCSmL46
         S/xA7pAy0aDlVYzxCgTQCPa2104zZ6gM8ZAkLJ3oUoTsohxMFGwYhHRtMba5SkXnL1d8
         fa05EMuCVOB1Ua7zo6crA8gNhYxj3MOyUvWfmTB+/0bOPI5yYQ32S92840+o3RCyRHm1
         dLDXaN5KAG0RwfyVHW42Xw4NSFScYk6b/T+Bc+qEtXh+HXB+DtYDRwcd/wtRyCmwRzVs
         Bh2A==
X-Forwarded-Encrypted: i=1; AJvYcCXpY0eU6Gj1+mo0285f+6II8rr+SHMFfSRJtfZZjzg9bAhmwUzSmXtl+cN8lF8VRJW28EZJTx6BlQ==@kvack.org
X-Gm-Message-State: AOJu0YwnnmejOD8xY1uPsvE9vUbb3AfvHLa9Bi9c9fSQ9ZSn5uE4IxPp
	RPpave0VJn0Tnc9DNsRVU84hN5lznaBbwkh++ClNO2lvhUGPdJKpF1lw+OE8EY8mBfoVxKFPZaZ
	/ulcER2zg3gkzSZGcxR8N2QXRKSxdrIRG2D8t3/Zs7rL8iWqkCtCCpOHcPrPq
X-Gm-Gg: ASbGncsTQTc0XZ/GYiVIoGl7CxADGTmeES4Vfi+OeJkADdShrYXA+zSM+SKvspmKPdM
	Oqzwr4Xzt24gPLihQyZP0TVpwuUwVm0kN4rGvm/CrlwerMNZ2610bXtDIccAQVa8KeDdcm5Tzdu
	aOLZqmMT27LyJSgKF7XE3Tp+7NV3O7Y+8orNhfZORItqJX0j2WXoWrkewcTnfnVzbDzjnN7JZLC
	onHgSPnV0RQnC42m5LMR0n0pndIIr6qL3VY9w6LtFRrzncz160U01RNGrGfQvgROnjzzhm2vAVM
	fBhB2ucWbQxzg8oJ5+bgnxM8GCyGjAVAl/3cTgIotQUyGY99myopR7+BGEtRbYzWvWNv0b+Ei7s
	1v0pgMXES
X-Received: by 2002:a05:600c:628e:b0:46e:4cd3:7d6e with SMTP id 5b1f17b1804b1-46fa9aa0b49mr56621355e9.9.1760036244338;
        Thu, 09 Oct 2025 11:57:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7mys4/FDaXY2OCEWr6mej6Wrn1zZXPoZ5aHypkrEDlOnaV1ENckumi+N7FGBDiTJ4jMRNYA==
X-Received: by 2002:a05:600c:628e:b0:46e:4cd3:7d6e with SMTP id 5b1f17b1804b1-46fa9aa0b49mr56621255e9.9.1760036243964;
        Thu, 09 Oct 2025 11:57:23 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4982b30sm8459955e9.6.2025.10.09.11.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 11:57:23 -0700 (PDT)
Message-ID: <8c4d8ebe-885e-40f0-a10e-7290067c7b96@redhat.com>
Date: Thu, 9 Oct 2025 20:57:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/1] mm/ksm: Add recovery mechanism for memory
 failures
To: Longlong Xia <xialonglong2025@163.com>, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com
Cc: akpm@linux-foundation.org, wangkefeng.wang@huawei.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20251009070045.2011920-1-xialonglong2025@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009070045.2011920-1-xialonglong2025@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ia2CCvFJm70pv-ySeCSu2v-heSft-1R-1mQPySS6SEo_1760036244
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6CD2F40008
X-Stat-Signature: cfukrtzwpighm4xu71c1ody65s33qqs3
X-Rspam-User: 
X-HE-Tag: 1760036247-684073
X-HE-Meta: U2FsdGVkX18r09X32mq6s4um5cseyhCJ13j96v011Fevd2aqmyqrFpIqfN53IDdYS3ROI4Hm33UroEKNXPivFG4G31B2VkOxHBADEqToW6xgfVJO5nSqKOguTgtgp8bDe5BsI04ob3w+QpDijnBU7ZsNnbZIWQ8SxpbssCiH6Rv5somxpVDL7wsjj81d+Z3LFdaXsoVQflvTN5kolAK1NldnXO4o7as8FUCtiz76C+x8bPosneZ0f0aqSrwVVtDwnhNMRpHJ0QVy6eGOfSgZZBCRZxbB4aHbaamWmJeqs3EJjWMEwXzlBR3lTTYJQBxOfB7ZYaFY7SwKQx69X8SKV6C3CGRPD0U6f/vkyOpxVv+BEbsK99Ynf8DHKN4QaIJOwj+zFw7eelG/oykrwep9AuzAbsNgp+fT358m52NNUHNk7BG/OzT+vxO49nxfXUv3CakDsmmV97WBlw0c/y5GMf8BmGIiQlwYTiOF7SuHyE804KX+aO/nv6kKwAk7luSQPSCtKFwijGa8fx1RWXLlOjvEo0c/kDQX3VatVg9Pigw/PHOIkCSje/zgBlLBcxRECooo0qHYdDJzPvww2ObnaUWAxFLNeZ1a9mY9ZS5aS2ORmkp9/ssUVWjUAVjhOPq4CYqoEQufkuQHf+f+LAzbXaI9866ccFHyMdRDTPo4eXHV4a78PTK6mqZzzVp1CP0YtOE6EGR3gNlOQTelTdqTJfqqhRGBPDYcJn+1OrWbJHe3lbcKt8Lzk2Wrx9JZLbFPsykwUcztzsi/Tp2KM6mrtVqlJKpLM5Iw6TkX5ED+n2+ak9HTHxaxZbIf/YHBJTEsSExt3Up68YRLIXjCS9PSQQLxcYXJ+l1PyrLhZeDwOznlw2AzHncAZGg2YomYXuFHyzTfSRjc1YQkWlu9QJO/Ikh4uw24O+G1/qFduIusFtvxDxM8GJ8NbfMO2qwnqcy8gM1LjqSM2hB2XWZVTq3
 /QmghWAg
 qnsD9UkfGaLHZYlZoHwcDsFsYODK72jWFdiwHKkVzFRmWLlUiexkZ58uKBVt7s6iq11+jF32VLRIrG31eqcmBKj2zmazW/icRio8PPpyQFEDdSlOsJL6KYGYu89uAqwU1phFKVh2dkyvDIFwn1Eu19Fw2fxDdBnXwaocucqKhDYSTuA6byczs75bJRhHxp3ps26lquoivWCx1PGyDr8whgpaZSmMlzuiKlFYn2zBeYejNejyB3mb70OLWetinEvKrWNeKMGfOljYf2Lg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 09:00, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> When a hardware memory error occurs on a KSM page, the current
> behavior is to kill all processes mapping that page. This can
> be overly aggressive when KSM has multiple duplicate pages in
> a chain where other duplicates are still healthy.
> 
> This patch introduces a recovery mechanism that attempts to migrate
> mappings from the failing page to another healthy duplicate within
> the same chain before resorting to killing processes.

An alternative could be to allocate a new page and effectively migrate 
from the old (degraded) page to the new page by copying page content 
from one of the healty duplicates.

That would keep the #mappings per page in the chain balanced.

> 
> The recovery process works as follows:
> 1. When a memory failure is detected on a KSM page, identify if the
> failing node is part of a chain (has duplicates) (maybe add dup_haed
> item to save head_node to struct stable_node?, saving searching
> the whole stable tree, or other way to find head_node)
> 2. Search for another healthy duplicate page within the same chain
> 3. For each process mapping the failing page:
> - Update the PTE to point to the healthy duplicate page ( maybe reuse
> replace_page?, or split repalce_page into smaller function and use the
> common part)
> - Migrate the rmap_item to the new stable node
> 4. If all migrations succeed, remove the failing node from the chain
> 5. Only kill processes if recovery is impossible or fails

Does not sound too crazy.

But how realistic do we consider that in practice? We need quite a bunch 
of processes to dedup the same page to end up getting duplicates in the 
chain IIRC.

So isn't this rather an improvement only for less likely scenarios in 
practice?

-- 
Cheers

David / dhildenb


