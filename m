Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952B4CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 07:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E284C8E0007; Thu, 25 Sep 2025 03:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8918E0001; Thu, 25 Sep 2025 03:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDF78E0007; Thu, 25 Sep 2025 03:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF8B78E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:50:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B5B51A034B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:50:27 +0000 (UTC)
X-FDA: 83927000094.12.C004CB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E923180003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:50:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fz69sU94;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758786625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PS5Egckwip3kpQ3auepdZqUlYFAXDV6RIIbMKmniWX0=;
	b=wbsGPfDpQI65mDhD2FBnJyVdXtICSBqObFsm0ecL/YZpujQZPKfO4AUi6c+s8/HOEChSYb
	YcQr/+PD7LccOIdxQLErIK1c+HYFfKrFoS66hLhXNgl3mRBLkZnn8m0jycaKIh6KIYCHEC
	N2TwOHsK3klelhq6mHjoukGDiGf2sRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758786625; a=rsa-sha256;
	cv=none;
	b=iJc5AKdIXpGGCPZLhjXjJvF7LdhizH69slhamFBTML+x6rGTCXTOC6WDZV4P8F8tOLOKKc
	7ArrDfGN9wkT+5Ww3avzQOg88aJeJOKjob71C2w8CCzflvlt9RkWhagiqfG/zUHQJDZzNc
	vWFshAW/0lsUa70ejN2oqU07t4szzeg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fz69sU94;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758786624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PS5Egckwip3kpQ3auepdZqUlYFAXDV6RIIbMKmniWX0=;
	b=fz69sU94IdTXYXhFhrf6H7w80jHEu5YHNOMhJjyMaZLS9H9sISOVAITnApAT7UGar2WsQH
	NMd1TYsWEkOosuuDUaa38F4ToKP3OjknC+25NE/zBZm139T2hw9uHZCo+Hgf07nkCePBJZ
	ZMkUpNigjjJMkGjybKt9Wba70AMe3dI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-pSPN8KfCMaKigP6GNzeiFg-1; Thu, 25 Sep 2025 03:50:21 -0400
X-MC-Unique: pSPN8KfCMaKigP6GNzeiFg-1
X-Mimecast-MFC-AGG-ID: pSPN8KfCMaKigP6GNzeiFg_1758786620
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46b15e6f227so1349335e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758786620; x=1759391420;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PS5Egckwip3kpQ3auepdZqUlYFAXDV6RIIbMKmniWX0=;
        b=c+m43XMPLdnetB1SiQNGIm6fRmByCzeTusJLibNYW6Coyw+EBpBhdt+GA++kJULoNg
         CNuk+lS8vJD4/qajAdUL1l4Q7B3VXYO+4Mzv4JerRUFEXTRq2ORWcX3YAwElz1yOqSse
         lspAX+F9kiaRJCJz/6Cha6drEjJIs+JT0ENU+rfUenjmyryPXGT4hl7gZT2yDtn4l5gb
         y2iGNSKs9LqRvkAE/MM7XrP2uN492hD+9GGKYK/fU63ZiGTaII7Uklp+AaTk/1iEMJmg
         EHysN9d3PeXK0t0Fb5saoCIUhtuNIpEfx3nbkkY458vHDMlApgss8l5qeJvwMhEXyl8K
         l/oQ==
X-Gm-Message-State: AOJu0Yz9NaL6Jr4YZq/bi/w3y+UpRDmNRdQSvynhoW3Diy+u/wocIKuN
	M2alupsEPz8q0lz8NTssXPQz57rgK7nEyltVbeoRjSYLvjnikA29axC1UErGIlmMR82RqBGR2pY
	95eoBvMO0kcVDQa9zdNAfxCy8GXK9ak0niNV+oA6oJgnaKJ6RxNlR
X-Gm-Gg: ASbGncsGOFFSk9biuRXCgNfc/4og7SIZwGIjvLGZUQPw7i/emu+q2pzBwQM4Hq177op
	oJLoGQLfwoqXDJWAm5MVFBbULPvW+G5WFBpv2yOgMKRzZbLpoC1NYWQM6BMKoLon00vKl7HXQF1
	bHDSwoqbrMfAqJZKuFLD3d4zH6KUwR4sQpb+5TJSCJ2oCSPvOVorUiHiqoGxemn+3Sft+HPc9OQ
	nfvMuys+jL3XikXykZv25IkppAIiog5sZ9jmxEdPoF/szVpOvwVpJGZ6P2naD4ZUswi7gdluiEz
	OUmisme3efcqXG7NdTNQUWdgjBXjNbKvVC7ypZUyVpP28/5gTJkgBPxUztB89Ps35z/k9zS/sp3
	3DX9dQubKDlvjtIj7NB7UCycE8uEW1V7q2N5Bx7EQt7JaFzBqYEWdbjxxROEPqwJAYdpM
X-Received: by 2002:a05:600c:8010:b0:46e:2861:9eb7 with SMTP id 5b1f17b1804b1-46e329a47e3mr23949865e9.5.1758786620314;
        Thu, 25 Sep 2025 00:50:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQPBxj85AmxAty3smB36wxmjDTQBXHlcB5P2ykV/icka50+WwoUgia/33jh3o/rv5KJU1flQ==
X-Received: by 2002:a05:600c:8010:b0:46e:2861:9eb7 with SMTP id 5b1f17b1804b1-46e329a47e3mr23949625e9.5.1758786619856;
        Thu, 25 Sep 2025 00:50:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602df0sm1836031f8f.36.2025.09.25.00.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 00:50:19 -0700 (PDT)
Message-ID: <bf5c64c4-cea2-4132-bdbb-6400f852ab52@redhat.com>
Date: Thu, 25 Sep 2025 09:50:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksm: Fix potential NULL pointer dereference
To: Fushuai Wang <wangfushuai@baidu.com>, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cuigaosheng1@huawei.com
References: <20250925031358.80983-1-wangfushuai@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250925031358.80983-1-wangfushuai@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gHBfCD8TB5A3OsEy17tOtxLJqbrVHqGpGeHaddOgXcE_1758786620
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gto5fqut8isn5t8yfzot43kxjjmk7r4f
X-Rspamd-Queue-Id: 1E923180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758786624-346663
X-HE-Meta: U2FsdGVkX18N7cY5Pnkh3RSLIK5or0NaAoKX1XdPg61D8O4M6Uf0Hoa4ia2AdYnVsysB71+bgu0qd37Fw9JpqoWTIKEa7tdK44uUtVTUKoEqr7i70w8zCeLkRu8v2iRbsrk8Qw5kYXEM+xY69S2ptPiLUUroVRvWUmAjgRyacDTAPY9j6mxvYWVTvtHy0a7ei6P4A/R9u2DKrWduUoFIN8o6NR7q+V0xSRSkTFUQJrp3B0pC6ggGxfqRkrJJ+OnFl4KdK1xqiIo+VQ0h7MmCZR8j36igmQHKWgtOr9un6jsgWbBxjGJ3Lv8dWjSJ/4Aebw9LTUGEG/EEiFKhdHRoxWD5OpwBrGr8JD9OYiHscrRD6QknhwyDJdxAtlA3BqOeTnzhfhPpRrdheZBM9nu3Xw5zSm/wdZ1YSZVoOj3on0lL6BFaKdYwDTFkY+5sjCupoui0ray3bXcaLojP1P8Z4hwfIJ84gMyJ3tS+G2P+5ImWgplfPxNC0frAFiEOhTx6yQ75CEluBijjvpWcaq1al/vj0YUUwNyxpYyul67A1up81aD8lcyjVppB7nvUPpH4GodOMHVVFBcPLxuGntnQRw8qh/p7UOuICs/348Cy0aBvgHUA63NugEMGpfVI6ZZ0zdLpXixEaqhCyx2J2Cik5et+XS4zhv4yUV/OSnREiA78YlvBsKWEE5fNlUCFw4r5eoeJiwOatmtSu/BOpL92eiuBthlg4EB17iNTvOJc+cGaZiyVcXGgESNxKIQf9puBpIf8ez/AzZmyshme//CpgE11DW86R+wpy4taj2Abgaxi8APskQLD0NY83JA2D2bPWu2JPyaA8Bxs7mU0gbJK4UuE6LWP+hwo/7JE0AKjFuvJmpriQ+Nkeah57PV6b0qzWE5FJVaOOk4W32cMu4s4eytuyvPXUAKQO2khEMXwYV6OPJT8x4uQ3/UKn4cic4wMUV0PBhHbINRMT35jtR1
 jLidfYQL
 3otbVAyprqAZSojufemnFqn6PO16w69bIGt6Q3BVu2Uzsau9ZSOy1ETtgOTF7SNVPLI6Y3tOWrM1LlM/u+bQCVGQPPQYZZCj8RgRsFowF5Aesrrmo6Q6RFZhxhgs/Rpu/fYvxnWxxgqlLHq7tTUWMNFIxdlDUqLXVe7D/lqmmCl8Ql1Ade7HnNUi8EhgEYK1jMn2Y7c6WXK2mNs9kLqjRu3wNG7ynu3+lXldbLza21KbGdXNacBZtJrZJrAOELaUwMqdO+JBveqsykSt45m7iWpmtIYxS7JtXVb+0HE+ePOwx7AwlCMdE4xBlcoit8HGSog1qi5HhHj/BEsCL21Fz92sw8mPYv9wqmgxaafG0dz0uFWHHjDyIOX3YkjgwUaRk8KGEpsnehnkD4fa979R+PyJqhq5lA1/OEJQi5a3ukp/6T+RDGzxEmpMmT+q5EoXCP/53WCzPnC6M3G4BVFXmoAH+/KQ4dm88p8wNhJW4LJsWBOoifu2srKwu179x1w2Xd7zYnXb54A279WV2Ks5gqXSz++aQ8bsncQv6tEPmpdRXd7SeuGCkru+DFhCvKQPXykIgo9oYaGIaPkOq3VIOhIMMOl1C9qlY+oDrdh9X0LWjb3h1GNFPWY4LJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 05:13, Fushuai Wang wrote:
> The stable_tree_search() function may return an error pointer
> (NULL or ERR_PTR(...)). The current code does not check for
> these cases before dereferencing the returned value.

We discussed this in [1] where Willy clarified that there is no 
de-referencing happening [2].

So no, this is not required.

Consider "&kfolio->page" currently being a "(struct page *) kfolio", 
which is just a pointer cast and no de-referencing.

[1] 
https://lore.kernel.org/linux-mm/20241024032300.2501949-1-cuigaosheng1@huawei.com/
[2] https://lore.kernel.org/linux-mm/Zzdrnod2zcTeI-Nt@casper.infradead.org/

-- 
Cheers

David / dhildenb


