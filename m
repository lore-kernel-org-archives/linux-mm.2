Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB091CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E690D8E0034; Tue, 14 Oct 2025 03:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41148E0005; Tue, 14 Oct 2025 03:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F918E0034; Tue, 14 Oct 2025 03:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD3028E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:59:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66A1316075C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:59:31 +0000 (UTC)
X-FDA: 83995970142.12.D5ACBA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5AC21C0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:59:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=grw0YtoQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760428769; a=rsa-sha256;
	cv=none;
	b=8EfE6g09N15+w8Oy3lwhyJmyP3qz408kdJoFK2M0pbDHIkvaeAYtOkiYWmcXtomramF5y4
	PdkKuE3htLfSBzf+mVQ9qxgoF3fl+t/iPftz/maY0yrDSUnQGcDAhJ8tCRBhsjkanHCs8F
	ZOftPDwHKNQTgaN7nA630n2nlwgX3PU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=grw0YtoQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760428769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+evH2w+/SD0aBvnKN9sijIvN4jHoC6G+ugKhqQCEeQ=;
	b=KAJzr61elLgOM9Eoaa1gwfVt91WjSoeQxgg2C3pNU/eSWAvcrF5FekstECBahQLyCdjdLG
	yWHaVwOOBhvwiQJdN2Xpg9m8w5ISN0CS85jODtYYNqCqq5wfrXsv9sWgzUESiLAktPkjVj
	7NrF5eJxHjw053ODeEF9JuDIdtQM2ak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760428768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g+evH2w+/SD0aBvnKN9sijIvN4jHoC6G+ugKhqQCEeQ=;
	b=grw0YtoQED+kwCppBzjzR5ROLVHE8FZUQ10xd0fxOkGnYFBNnJU3uQvvQc4qWPYmbD+Bei
	ei0L4OoF2vRnAKjve9pUot6BOafWuIcapyp4Nfo3shl5pTToOWhkrPnN3oHbJ5aAaywBVl
	8jsp65rXXp3SCK50nvZ5NJ1qi3JbtFI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-BYdxryq5MOi1zh63S6OVNA-1; Tue, 14 Oct 2025 03:59:26 -0400
X-MC-Unique: BYdxryq5MOi1zh63S6OVNA-1
X-Mimecast-MFC-AGG-ID: BYdxryq5MOi1zh63S6OVNA_1760428766
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso4015813f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760428765; x=1761033565;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+evH2w+/SD0aBvnKN9sijIvN4jHoC6G+ugKhqQCEeQ=;
        b=gxkokXYKItROy8skY2vdnHHWWMyp1IxNlv9FBf9zn/c4FST4j6cFbgvQsDlqV9ZKyQ
         NC+BVmVD3w1OECAESp7808YeCHiyKqEFc8H8qq87J40DTMcOzr02Sq5tL564T0EmS3gT
         l81/mOd+AtzVJnor3vG3Xco+j3DItXeCMHWklCiGYrChfIKz43IYVu233bpMGTy1rb/+
         qyNbUKfewJihZPudKiE6GbDzHroV6GUVryuse4nbMASgTiRCHyL53Hsl9sek6rSopF1/
         61ZriedmgYoTfXpBhnfs0XRj7EfUu56Jz+qQizqpjkkXKVZqAxGek0ZYxaUKzSiR4g3+
         cE5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+Qr+qLiyZSkAXS1L3kN00PtKzvQPaFelc/UKp7fcTgWZ8SAslqXvKU+hgsKVUFo+XkuzyLkaSvQ==@kvack.org
X-Gm-Message-State: AOJu0YzMqfe8aovSoWLmtdkRv/MSVAo6efFAMP+zETvVV30qEw9ITc79
	sT94KowSh9b6eh9ZeMX6NRJEHQ8lSbUr2Qdl/mz/2HrQbOVpTwtVDmXf0AIJx0f5x/81MCpgXa9
	pq+ZmSNRCulXV2JD0oGC5gPbNgZb+eGp99KuWLqQM3NYdeHezISlH
X-Gm-Gg: ASbGncvi5o5QSuzlGfRUYeM7R8ocAwo2JpKhYdGy6y4UQKqkKaN26j3+xI+oscof4UJ
	o2ddLPQ46+iRFN+qufCiid2wSsYbhXnnsB7THhI7RtmI8jKrsvu3RRe+YMLhBDZb0R4U6N2eu54
	7KYP3zoHyoDak5QIMB3XEYaBVB2bGJit4GuDjVgMFWYdn3/qHwZIHL7PhbvVGIvvVTnxCsxyOeW
	YTu9N8mxK/DeWYe+O9nek/RFrsfKAOV86sj6A5ufgaYV0zACKTUHdSnAtMjb5Cj/4AjMrWyg3Ia
	1m7AD7rw0ebR30EcL33HLAzwUEpYLXp40CXQGsyOXUu+OlWnOnrESmF5fQ1KJ/8T1B7bb/5+fw=
	=
X-Received: by 2002:a5d:5f54:0:b0:3ee:1586:6c73 with SMTP id ffacd0b85a97d-42667177de1mr15280658f8f.19.1760428765577;
        Tue, 14 Oct 2025 00:59:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE68IeQzBd2dgMq8g6Muhrra3mxHKk25wfQSGnOAJFSGP9NdV805qDrZXher1hu8/MM+LRtlw==
X-Received: by 2002:a5d:5f54:0:b0:3ee:1586:6c73 with SMTP id ffacd0b85a97d-42667177de1mr15280642f8f.19.1760428765181;
        Tue, 14 Oct 2025 00:59:25 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426f2f72e18sm862060f8f.0.2025.10.14.00.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 00:59:24 -0700 (PDT)
Message-ID: <57b73517-9b4a-4203-a39f-3d412ad4c7b9@redhat.com>
Date: Tue, 14 Oct 2025 09:59:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regerssion] [KSM] KSM CPU overhead in 6.16+ kernel compared to
 <=6.15 versions ("folio_walk_start" kernel object overhead)
From: David Hildenbrand <david@redhat.com>
To: craftfever@murena.io
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, regressions@lists.linux.dev, xu.xin16@zte.com.cn
References: <80b153cd-8bba-4bcd-9b56-3b2ad3f295e1@redhat.com>
 <46d26246-5bd5-43f7-b1a4-dc721f717413@airmail.cc>
 <26a8f0aa-8d67-47ba-841c-2daf7010a2aa@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <26a8f0aa-8d67-47ba-841c-2daf7010a2aa@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mliye6pnmWqohdyRI8bgrtArQ-Dp2nar55tqq-NPhng_1760428766
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5AC21C0002
X-Stat-Signature: 8jux83xrqyygd7dqdai4wbfqursdsoc6
X-HE-Tag: 1760428768-443341
X-HE-Meta: U2FsdGVkX18BWXMWQAwRzrj6W12hoYV6TjYb1VjO016/RZLMTalEDxEpFxHuFU47qqsbXJb0C9GPxHdTGBh+j4/DJ8KnHMst7qSzXUFlSPlG1VtTs/xQRpO5rozKxJbx+Qeqppcs309G8OzMnZCGJO3yVgV1fxQa0CttuWjoosu7UtZToOvni5nBd1dtCvTzWphJLFhajnyYNeTF8cGhoSP9O+kJMLWKtc0ObGd8QqdvaXwfFIfUHfUFEkXnBlmxZHzWiZojTNG5XbgM1MyowqPoZmQgK34ok8KtQgiFFgQAf8idp1hvAYQijqSVGcInb/XA+us2AGZBkpWo7J8d0sNhPT4ez0fyYXcTGlqy7ityEDX8LjJu/IzujLCV9HQGyg58a6nvyT1LdxVEeP2U0yFZ59kO603zic+g5QIXpG1I7HCuONTG2bi06WjxTb3PbBTuuuzYZg0XM91bOeIGvPSwrqHN6uqfFEDFWrlL3iI9CHFu5DED35bp0r600kRqGAvrTfgbDNhAVOkaohPxIGu4UjeAzyK2wU9seQYUVwut3ObjdsJGBDKWBsFeEvlA0+EbLK/bS+VaefeY1VwSpgV5lYlKamCVzUmd7ZQZJckxdTwgZI6euaMNvsplZ6FCaO7tJeONaSLyZB71PPWyRXTOGeuFDbkATvjlplPyOr7alAWDGsscbfgilyjYp9L8zNPhqM0ni4+UjJSPPh0svkIqDy+8E4tXxFbAuMSOa444t+7ntqFYlapHNQ5RJ2TzJwVqPIlvK836sK1+tHv8RZFuBYYNHz9dLu0g9d4EUu4fSv3BCNtYJtiJihdLmTrc1GrrlBPJZ6UcW3zrrpKd+1RL2TCHz/vAu9Oq94txvVazbbueEORYL5DMt9maj3gr/xYsgnqGJzgGFvgmIFYi/R4vRUC7FsvGQCy7R1zf5cEtEiSd2519eu7gXXY5aa/fg5PLasxqQFuK8+8nOsE
 FqDprVzE
 M3z5p5x+Z8a+YuwJNuv4GM+dbRlTiZWYgvSmZwYiiza04H2haEvXu8Go2ObeZhdoSiAwmeDfXTIyDubJjA5dlz5kY8ecgtiRyRBGWLbYIVwUW11XjHMALnTdJHa+AEF2NfuEpAKT0tzFltzuS+XjFOKcgdsq6xSNV/4j5ZbItElES5hUpM1myqUAPJs/MS2kfsLeCQINhzSMa75R4JxbBtjvK5pO/r7z8LnT53tYkJHH7xjRlTt2IY+l/lfQdXjsvggFlr5V3mV6uMZxNsULZlI9d8O7v9bpNREpxhYjn+H9flhsIHFYcKyUZzQ+gRk6d0DbiZ/no7OilsogjBldqiSzPycJxPV8+vTBLVwsRZGc/BfxzRXk2SRSvIkrM6u9GigQyt3o8YGhXFwhXGRxJsPKt5XnUlY4f+fy6gH8EXw1Z2VIvKVUmdmhX/1zaQ23XVRnbVsNZMXt2s2A4C9KE+9UHNoj+edlqfrvOLVqqHFXnEULvgjfzi9HhuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 21:58, David Hildenbrand wrote:
> On 13.10.25 21:54, craftfever wrote:
>>
>> Unfortunately, yes I can reproduce it. And I thought that lockups does
>> not happen anymore, but I was wrong, I booted today with 6.17.2 updated
>> and KSM enabled and whole situation is back. But, it only happens, when
>> scanning pages corresponding to a process with huge VM size, like
>> Chromium with 1TB of virtual memory. The rest is alright. It's look
>> like, that the folio_walk_start called with much higher frequency, than
>> in 6.12-6.15 versions. in that version page scanning of huge VM size
>> processes is pretty fast and flawless) Right now, when Chromium is
>> running, I expecting constant 42% folio_walk_start and 15%
>> ksm_scan_thread on 6.17.2 kernel (contrary to 1% folio_walk_start and
>> even less ksm_scan_thread in 6.12-6.15). I must admin that whole system
>> is not freezing, just Chromium with high CPU usage from ksmd and kernel.
> 
> What about 6.16?
> 

What you replied to in private:

Just compared stock kernels (6.16.8 and 6.17.2) and must admit that the
behavior pretty same, same lockup, when just starting Chromium and same
kernel objects and ksmd overhead. No difference. (Approx 20-32% of
"folio_walk_start" and 10% ksm_scan_thread at this time on both kernels)


IIUC, 6.16.8 dos not contain a backport of Lorenzos fix, so we can rule that one out I think.

There is another VMA merging related one in 6.16:

commit 879bca0a2c4f40b08d09a95a2a0c3c6513060b5c
Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date:   Tue Apr 8 10:29:31 2025 +0100

     mm/vma: fix incorrectly disallowed anonymous VMA merges
     
     Patch series "fix incorrectly disallowed anonymous VMA merges", v2.
     
     It appears that we have been incorrectly rejecting merge cases for 15
     years, apparently by mistake.
     
     Imagine a range of anonymous mapped momemory divided into two VMAs like
     this, with incompatible protection bits:
     
Could you try reverting 879bca0a2c4f40b08d09a95a2a0c3c6513060b5c on top of 6.16 and
see if the problem goes away?

Meanwhile I'll try using an ordinary pagewalk that covers a larger area
instead of a foliowalk that walks each address.

-- 
Cheers

David / dhildenb


