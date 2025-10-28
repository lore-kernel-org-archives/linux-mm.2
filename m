Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A46CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C968E000C; Tue, 28 Oct 2025 17:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804D58E0005; Tue, 28 Oct 2025 17:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A5D8E000C; Tue, 28 Oct 2025 17:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7C28E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:14:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AF08BA33A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:14:52 +0000 (UTC)
X-FDA: 84048777624.21.12AF0B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id C946B180002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:14:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DrP7iokd;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761686090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HrvyEcRFoneqk86qrnzAoo3f6d+zdXeHYtZ1JCa9Ps=;
	b=hwKbVwBzTiCIvH9j7UJUnHRp4I8oBAO9N5S6xY1l5X7kxwy97uQQKLEnkgMGRi0smj4DG2
	YdZRWd/2xGRkZeIVryNx76YEtZLJ4I0+VIJqO2NxZv2nYzNoesZfDIKBDIOvY7F8Rt7FQB
	e3xumdzZtm7m6sm0MyTv37emQ4cFIV4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DrP7iokd;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761686090; a=rsa-sha256;
	cv=none;
	b=e5BRs1rZhRkU8ikwn3KkiJcPdEbB2wJ+rtiQdnBC/y681ibLw8JWD8mqokPxIOJEhdvqUi
	dFveOCBDy/iyp8WAb4al57itPkbVdGyaG6j8bDEvTp6Q6NNHuAFzVz58WCaGSnBU1MgVoG
	jLlcRD4kjydjH+JNCZUtUau2/xXGsbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761686089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HrvyEcRFoneqk86qrnzAoo3f6d+zdXeHYtZ1JCa9Ps=;
	b=DrP7iokdscZHCVhRXbjQ+4XSO3Pkl7bjW0wPc/2xUNJqfaq6Nausw8CX7RFcp3LAe85Oy3
	okQxmPel2+5NWTgzgq7I3M+PEcDkaxoBHqxNDzy0//yZkoaV9WSJmKjjmLP9y5DD8qP1Sm
	lCrJQwITRkIfEe2Fc3+0xPh4zNZMUK8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-52AXL2fjP62zSZqBhITZ3Q-1; Tue, 28 Oct 2025 17:14:47 -0400
X-MC-Unique: 52AXL2fjP62zSZqBhITZ3Q-1
X-Mimecast-MFC-AGG-ID: 52AXL2fjP62zSZqBhITZ3Q_1761686087
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8a27ed89773so899257685a.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:14:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686087; x=1762290887;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4HrvyEcRFoneqk86qrnzAoo3f6d+zdXeHYtZ1JCa9Ps=;
        b=HvtwoYlFviI9kY6vY9OyA4xrNyfaK205EUXkmj8nX+dqdbq5SRPd/wYd9Y8HA5z5Au
         h+aJhvTct90RU4qDl2PSRv6fMUARyBgTWgTJx2sd/KQDYUrXHNfAjtHq1jcv/ZrRlA22
         DDtgWL8IOA2JDaqpfrJXrBzfEOBiCtxfAq77XIcFnw9t5ng8X73oPTj1NGmJwMthIIrS
         lukdqdOhHOf+EJxaOSg9BRuvY47HHPUim2bm2BpFIJBbyplO92tJNwHpRD1BPDGeLxmJ
         7InZn51cjoXOQyT2DgAK82VW1OozswnZWSxIKETYJHbSilvQ5dbALFf1JxPSpZ7+Dota
         IX5A==
X-Forwarded-Encrypted: i=1; AJvYcCWroxNmVAlzGguz/XlP6dJwI1qlax/jeySOh+RO32vwtAgF+dx0se0vrZOd7TDaBkJAcEM1ASu2eQ==@kvack.org
X-Gm-Message-State: AOJu0Yx2m38D9B0BvHvxHNpHy8mUQ36X/9Pjvcra/Zs28IZwtP8rQQlW
	CksC2EwU8k6XEOn+IjRKVs+TDuE+GcQenwhHqsXm3jVj4OZ5aMb8Smi2+o+DzATYVqvWhv2EfT2
	hBsscQsFvKhcC9wsawk6hV3WGLws1/f0FfWdg3MqOjBjWh+WGUZ0s
X-Gm-Gg: ASbGncstjC2RamvzPY0YNnklvFakyDIiphnyFYRUXiGcGbzpLrAN5qq+OS9OxBKu1fv
	O+XaCUQu7CbFXZrVer2FObyMwpqsPbVI1A6cwhz7SHssmWz+u1eKn8hP10LcYEI6z2dn/9Y86B4
	d6W9tm4r37OmUXtEpcEleqtxv6nAHKuOSDoamEi/r0l0eFbnSigEmW9ZWMmfwwOr8OXdaHfl/pR
	pKpFFE1n67qjlh3Jr5rS0N0Uk+trk2Pvivo6T7sUot8lHLhZv27LA8CSto1AQ4Sb0KdrgkwQE/E
	TWkshPa8+kMRlcG0I8yDRF7hQpAOkDwFzTf9fLq2+0B8Z2UEwLr+xHamjW4t/kTSTf/LutVwFZm
	a2Q==
X-Received: by 2002:a05:620a:192a:b0:7f7:8271:1a77 with SMTP id af79cd13be357-8a8e426cda9mr126340785a.13.1761686087105;
        Tue, 28 Oct 2025 14:14:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8D9LTgZgrHHdWeOYc+DL8B2sdCN5Uw6C+NWfSsJhoUGyXAHdeOuejLijrW6CXCNixE1Fy2g==
X-Received: by 2002:a05:620a:192a:b0:7f7:8271:1a77 with SMTP id af79cd13be357-8a8e426cda9mr126337685a.13.1761686086724;
        Tue, 28 Oct 2025 14:14:46 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.125.126])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f254a297dsm929505785a.28.2025.10.28.14.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 14:14:46 -0700 (PDT)
Message-ID: <5cc06269-5a6e-4874-bf68-fa4790f22bc2@redhat.com>
Date: Tue, 28 Oct 2025 17:14:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: fix HVO crash on s390
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, osalvador@suse.de,
 akpm@linux-foundation.org, david@redhat.com, aneesh.kumar@kernel.org,
 borntraeger@linux.ibm.com, mike.kravetz@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20251028153930.37107-1-luizcap@redhat.com>
 <50d815a1-8384-4eaa-8515-19d6c92425b3@oracle.com>
 <20251028161426.35377Af6-hca@linux.ibm.com>
 <5c72e064-9298-490e-b05a-16be6b5590b7@oracle.com>
 <20251028170251.11688Aa3-hca@linux.ibm.com>
 <4f522b65-1ab8-4725-8da7-3f071e7919c1@redhat.com>
 <20251028193708.7213A7e-hca@linux.ibm.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251028193708.7213A7e-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oe2Rx7rKp5jadQiaeGMuPuH4LggjRUfpkF7EwRaLPhI_1761686087
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: swukdc4obrjpzht43z5b1abbbg75eojn
X-Rspamd-Queue-Id: C946B180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761686089-446
X-HE-Meta: U2FsdGVkX19eZd6mxW0GKePlfObOjE2x+dtkACGbWbXyW3qyk1QBL6oCdVN7Vz0kKinb5dEJfFUNi5B8IRZHlH7cTH1B3BpRIJKUEtiTuUr05ybc9uzP1uSNpvfedCIFcA1fPZy7ZaQR+I6Zw/aM5sYydSonpyP/RqltKKqKO0XbGh9H8JC8W8BWOm5jHjUnQDn5VnywgZAX3xtds8ACAAr2T/4Ggxkgg6PJVMHDtxFsFCoPQj8R6DKV7J+P74fkwvvQ031pnw/sv4LoZUfxO5BftFXlpWBTejXq7IC//kULsssHLAM8nEHXQrTDDU/Z5KOF5d3MDWhUJ1VsOyObh/JnbY8bLKM/gKKnz3XG+iesPIvZjkQMJWDAD4TmUMLiOPxRunwIh/aKwy6ylNQAPLb8J+atFnzZ4ttb9F2UYmp7ech8AV5UBF/PnMr2YC+DmY2Oq4NobgoWFu2hw37x2blCD/sqo/LqmB0VChv3zpFq2on9jQEYWjY5kDVtAob5EG85rJAWlrUL8aZLgYoMEIACCfbI6Tv4taAyfWEWKLK57D2XfhBhJdjGB8zAef63z3Z9Nj8AkrHEFOyJ+yFkp9Zg+rhsiFhbbtpeyEcTTZwk/4rl6LsNOZjb+E8uUhOQFQfp+IB3bh/wVfO6O9PGgca5kVxU8zWEoKKC0kiQ4zUkswVhu+0uEsD/EcAji0RFpitTd1n3l4cLqgEi4YC4mnGsSZXNw6Ej3C12K4HzayE3LElynwW1RxOJBUtheUnt8AWLKNG5AS1gEpStr5k3GPJ+brJraX9EjN9fwPibuXVnan5MWnlNYL8JRTw/3ENFgd9QIRjIKF6wVY6QKIBpAkUZWwekr1O+CDQK4VOziZpmbarjqV4wrqRaYUeJCMw1FZ7ivjJ4jCsTO49czmmcYOo9xvu/j4522QsNS2AdutQP/GZohs+hFoE6lzefeLnYqPyVI/+PsslYGxM6I8Y
 5RPnmezJ
 yHDXpmvDekhYhcZ6rksBHY5fvEiozfTtU+H+P1gIoy0KIm0VkUWbN9b6ISN3kkzO3na943/VjUMVfdsxjzEPe18ly3D7vjswNz2xcjvApWWQz+K3pW6tMBms2SKaL0h54BucfINxY4RWlJfg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-28 15:37, Heiko Carstens wrote:
> On Tue, Oct 28, 2025 at 01:15:57PM -0400, Luiz Capitulino wrote:
>>>> flush_tlb_all() however is the *closest* equivalent to this that's behind an
>>>> arch generic API i.e. flushing kernel address space on all CPUs TLBs. IIUC, x86
>>>> when doing flush_tlb_kernel_range with enough pages it switches to flush_tlb_all
>>>> (these days on modern AMDs it's even one instruction solely in the calling CPU).
>>>
>>> Considering that flush_tlb_all() should be mapped to __tlb_flush_global()
>>> and not __tlb_flush_kernel() on s390.
>>
>> You're right.
>>
>>> However if there is only a need to flush tlb entries for the complete(?)
>>> kernel address space, then I'd rather propose a new tlb_flush_kernel()
>>> instead of a big hammer. If I'm not mistaken flush_tlb_kernel_range()
>>> exists for just avoiding that. And if architectures can avoid a global
>>> flush of _all_ tlb entries then that should be made possible.
>>
>> Should we take a v2 doing your suggestion above for now and work on
>> the tlb_flush_kernel() idea as a follow up improvement? At least we
>> go from crashing to flushing more than we should...
> 
> That's of course fine. I guess for stable backports a small fix is the
> best way forward anyway.

Exactly. I'll also see if I can find time to explore your API
improvement suggestion. I'll send v2 shortly.


