Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5CDCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFC38E0050; Mon,  1 Sep 2025 11:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF7D8E0003; Mon,  1 Sep 2025 11:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451118E0050; Mon,  1 Sep 2025 11:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 312158E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:52:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D774011A4AF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:52:58 +0000 (UTC)
X-FDA: 83841124836.23.0AAF635
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 74A15140004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:52:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAINU0Q6;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756741976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbEdJL0isBBnB3JXZr3cyBmB7UVFLdKlgzj7B1K9tQk=;
	b=Nhj0rP3DNdn2uHlioBtCvSBYjsfWST6kQHhtJg7zThU66LD8xjwh2bqMvrNrjK607Ampke
	zZAwTauF9aqkBhYJ3npE33MI4OGjHOnXdqXi4vpgUtTjQTVinxjtaChLFOJ6OOC5XXhRPH
	Vh0Yc7zglYQZc1C7wvyVILhGQYjUXXE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAINU0Q6;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756741976; a=rsa-sha256;
	cv=none;
	b=pBlBvYCmz3U3yttdfcsXFB3E6VyI50uUj5H4eJvIQu8oVnh3+KX/wvtFnJ9yVF9129PoqM
	UZu0anGUD/xN+HUK2stKOivv+XtvlFdH676xxYBcSJPc3v7oOlOTY7iolsZV+gSye1DeaB
	D4aHYMglZrn+2ev9trMhofyCjmzQcXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756741975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mbEdJL0isBBnB3JXZr3cyBmB7UVFLdKlgzj7B1K9tQk=;
	b=RAINU0Q6+TtQB5/R0urUSyiS6xNMMD0VCx/Mo1PhqlTUEXNGEZnGy6VPK/jTmcrQSsDcNK
	bX/24O6HUA1ftHeRB3g38/0xi+5kvNp3GL/xEf3LxFwJMQLShfGg8D0GcbP0PzgWjo0ZNb
	z/cDaNEGKsO66XzdCm1khwOe60LhX+8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-kjOkkLHnP_iWMg8nLtk0ng-1; Mon, 01 Sep 2025 11:52:54 -0400
X-MC-Unique: kjOkkLHnP_iWMg8nLtk0ng-1
X-Mimecast-MFC-AGG-ID: kjOkkLHnP_iWMg8nLtk0ng_1756741973
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3d48b45fad0so989940f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756741973; x=1757346773;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbEdJL0isBBnB3JXZr3cyBmB7UVFLdKlgzj7B1K9tQk=;
        b=WWgismzoNGDsBpObDLYmOi4JkQ958MfkADnw9D9hA9ruik/KK6ys751/43jogZBQ8W
         SnB+TQxytsAa6Byr/x5uxw/APWCfTW9ZJzmXfLV3TkfoKPD1lda6+Q23KwtR+vABymCo
         GqUgtYiBgSqlv8v6iLCafny32BMKqyxj29JLtr9mZLNFgbWzwRwz2b1euf2ZxDwqc7zt
         WjceLMFJX67hzVN/wb7VQAg2yvcFpA/H3d6C52+kkjQTZm50IoHaQhIjsKownGLIdK0h
         Bpj10FVIcyPtWZbEysuy6wuSfEd1oGiCkn6mW1Jfds7O7MfXrivL8ZLzpzzYM14CuU5f
         VLTA==
X-Forwarded-Encrypted: i=1; AJvYcCXqFM7Ia/DiD+7fBPeYWt+mRQAKwdKWMsQTJeoxq0jpW7jWYwpD45E6T0rE4wSItJ7RIvLXZX+I3g==@kvack.org
X-Gm-Message-State: AOJu0Yw34GsIJukeoz4lgFF03sEYaEWKXf/KQnKveUcVcUAkzt+rEmm3
	2+Ia23wuAS/ZUM8D1o72oAEP8+I8vaKOEiJkYMKYDm2qN0ZV7VTm1IXg/FNnecrzDumXi0DwSpY
	cbfVmcLt3+FA8t/H+qaHbE2N7BIBWFyfMRW+3GwfCE+iMOj4MjIcI
X-Gm-Gg: ASbGncuUOlWxwQSSDJoLa6hFsHu2i9b/9LDQzSABga9wyQgrH6d+OtE+GtwFnWRogJ2
	FHWZZNoTrAKv4bw+pfqyfIAyP3itH0Mfv/cS3lSngq2Xev0SqyOgMmEVymDeV7odCWfD3iz1spR
	IqxfJ0N/SvY3FC36zN4fsKN16rkb4EydsCrOz6FkM263cVPNSgE41DbNnDoJCoBNYOuI1yp+Pj/
	xuWsurWO4HMq4cxeTReYFgoS5TD+knaacWa+H5IvUXzmreRIXY7jU2I6Og/c8h9rbtjV1bImE6Q
	I4+7ksRIddJ2PoCCttn/UFq6fLtNieiv+2zMsTvin3zaMzENyvjqHuLGZkEh+QhEsy6NGez4dLE
	cO8XBZY5Zdu8qcIKVnWGebR3ElSMNLHnXIWVs7GJGGzlNDG7pqJ9s0XYPwpRPaBEkcg0=
X-Received: by 2002:adf:a3d5:0:b0:3d3:b30:4cf2 with SMTP id ffacd0b85a97d-3d30b30546dmr3216751f8f.19.1756741973320;
        Mon, 01 Sep 2025 08:52:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWAtKuDlQ702dYFHQ1RXyln2bmyih7xTaCXC/Ysq58gGE3o708RIRxMtCSozokpICZYopN0g==
X-Received: by 2002:adf:a3d5:0:b0:3d3:b30:4cf2 with SMTP id ffacd0b85a97d-3d30b30546dmr3216732f8f.19.1756741972788;
        Mon, 01 Sep 2025 08:52:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9dbfsm15756340f8f.43.2025.09.01.08.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:52:52 -0700 (PDT)
Message-ID: <001833dc-ee02-4bd3-8a37-820d0cd56be0@redhat.com>
Date: Mon, 1 Sep 2025 17:52:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/12] mm: constify pagemap related test functions for
 improved const-correctness
To: Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
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
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-3-max.kellermann@ionos.com>
 <26cb47bb-df98-4bda-a101-3c27298e4452@lucifer.local>
 <CAKPOu+_aj3wA14VaZo8_k+ukw0OafsSz_Bxa120SQbYi4SqR7g@mail.gmail.com>
 <8e3f20bf-eda7-496c-9fb2-60f5f940af22@lucifer.local>
 <925480c3-d0ff-4f24-ada0-966ad9a83080@suse.cz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <925480c3-d0ff-4f24-ada0-966ad9a83080@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _4ALnsCRNXgtdagltBiWGVlgssKOBvTh3qx-Nd8se3g_1756741973
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74A15140004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rysjgdn7e4aatpzkxfa7yoq1c4eg7wm7
X-HE-Tag: 1756741976-62047
X-HE-Meta: U2FsdGVkX1/wqvBpEB2W/7aRfAPmZoEaZXQeM3GP5In4VjL9Bl0M6QoNqUnXVnJxduslpLvjZBICAzG7cffTuDF+fIGSd1xyFUpG3weTrD8PYkGCZFzK67hOjhl20GTIFNKJrxN/d/0H5i2vvPQzfZIp/Fva+ILz5JKDhG2WeeDYxffTufsn4Ei1Dz1Y5PFM0wjedRQfukv2y81fMjU1h2LOrjYy+4LO574q2gvAijaS2hFZjWBYXBfsbCUANblA6p3b8gg7QGXDOsaPS5ll96Fwt01r8d0cUnB9lCxptl8ZtBqgLV7TDSOrCrqE+2nELrFIGPjpioYCGkt5zLYA1E1JvzUvad5yXR4xzBkWXnDuxcEJnAxkZXVihCDI9KSgtfCaTKDFQwZyCdgaYRcI+BQ7QV+2oX9ACsPUG0xnXeueEr70SjUIpXVurUpK5XgNuQkbgCx63GCiKXt6anpn25E/t2fqMDlPoqkLIMkADwqtaO14eYNohw8d6v1tRC+T1IEVJKd1hmr22ObpBMtkuKgYjhP4ClnyB5Ux/GqUHjeeKv6wr99hvbrFPDUHfNFGEt9zKVdtv/FAUxlrDB9c8dJE0W/2d7zOVavguRIETUGW8bZk7d0IIkCcZJMY6cplA45cpuSodFrSMBjXYbGZdup9qKvCkG/rAypiGEZZPVxQD6dIPzbEBPjNvMOO8VNd6nhXm2/3Ep5Bmi46b7aj3yPUAjQo64EkR0qM3/aEpjxjSLA6+nJdpvrqBu+4SQUOmBnpxvW+fnEIZBXixs2hXW8yyKsj0p2+iILEZz+iH5pGVO68IcPFy81cBmt+fdZlolKxW8LvOSYzdSFmsfmTRd049IrYbgUN+luCXSaDQ8dA0tQICFA6H1atB+n4C6KBZm5th/WWJihcygHChp1BPmSLMcwJoXoj8sbFzHK93R+0Nii2x8ULz8fLDlPJPd9YLxUEqgCjuDt5ZXoyISy
 G2UNJZPX
 HxVXtLh6jbKk7N5Y+OtNOQKu3Veq8u4DRLL+sRTizLFE0Md9QLy42SbzN89iqNk2WWo2hIV6cURwk9DLBgNmrThGXamIOWfJ3tY7aCUwf6AQVGGE91yHGzuwMq1z1j7Az5NCynXcu6CyeimOtOYNahjegWBtdaotnO2O6bnxg/QQFQ8mkMk4ldzQRCIlbhCaMPlXv0a53mgL0rivRNmLeLtc9u3SqWCVJGjr53kWd+0EOgPHilrn9xISN9FcCXc0dRcRpEEQveLmNlOjFSTjgO+OavkwWk8LYiApIkALijZSKWa3Nu4+um8dLrRnPNwhiyGTfYUn3daTrGuaS+FAwv4PB5CW8moLI9f/EcFnxI3+NKHji893XMcrLMk1aWPoXEzQDcioS2wMUmDyzlf1at3WbitGsqNtpE7rJz/NtexOrXJGugZWtdh2/N4z4WTcPVOkeyEoJhfZVsu74Mf6iX7CgyJLkLzsBJhUQ2IS0uKOvs63oRCcNmW7OAnltMuj6O/QdT9Eg7dJvuqsU7djcQxUkglpDKRRrZ1WLI4YshqJzGVLW3z17QT6E0TSaq5s7/AFaH8LapaKEj18SpiOFRoioOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:47, Vlastimil Babka wrote:
> On 9/1/25 17:14, Lorenzo Stoakes wrote:
>> On Mon, Sep 01, 2025 at 04:50:50PM +0200, Max Kellermann wrote:
>>> On Mon, Sep 1, 2025 at 4:25 PM Lorenzo Stoakes
>>> <lorenzo.stoakes@oracle.com> wrote:
>>>> 1. (most useful) Const pointer (const <type> *<param>) means that the dereffed
>>>>     value is const, so *<param> = <val> or <param>-><field> = <val> are prohibited.
>>>
>>> Only this was what my initial patch was about.
>>
>> Right agreed then.
>>
>>>
>>>> 2. (less useful) We can't modify the actual pointer value either, so
>>>>     e.g. <param> = <new param> is prohibited.
>>>
>>> This wasn't my idea, it was Andrew Morton's idea, supported by Yuanchu Xie:
>>>   https://lore.kernel.org/lkml/CAJj2-QHVC0QW_4X95LLAnM=1g6apH==-OXZu65SVeBj0tSUcBg@mail.gmail.com/
>>
>> Andrew said:
>>
>> "Not that I'm suggesting that someone go in and make this change."
>>
>> And Yuanchu said:
>>
>> "Longer function readability would benefit from that, but it's IMO infeasible to
>> do so everywhere."
>>
>> (he also mentions it'd be good if gcc could wran on it).
>>
>> So this isn't quite true actually.
> 
> I understood it the same, that it would be nice if gcc treated incoming
> params (i.e. pointers, not pointed-to values) as const and warn otherwise,
> but not suggesting we should start doing that manually.
> 
> I personally agree that adding those extra "const" is of little value and
> makes the function definition lines longer and harder to read and so would
> rather not add those.
> 
> I mean we could first collectively decide (and that's not a review
> half-suggesting we do them) that we want them, and document that, but AFAIK
> that's not the case yet. While there's already an agreement that const
> pointed-to values is a good thing and nobody objects that.

Yeah, and discussed elsewhere in this series, it would also have to be 
clarified how to deal with the *const" (or const values in general) with 
function declaration vs. definition. I don't think we really have 
written-down rule for that yet.

-- 
Cheers

David / dhildenb


