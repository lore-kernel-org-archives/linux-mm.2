Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD89C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E706B019A; Wed, 27 Aug 2025 05:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856576B019B; Wed, 27 Aug 2025 05:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E2F6B019C; Wed, 27 Aug 2025 05:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA976B019A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:36:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 332B6118CD6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:36:53 +0000 (UTC)
X-FDA: 83822033106.09.EB4A1F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC2F710000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:36:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qxvm4YgN;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756287410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB58ANfhXIZ53R5kVuf3CfNJ928IdN95VpKDMuZxG4k=;
	b=a2440H8JOQFqYWmo/+HUgl5FZ/jWdxafLVcLK4eXWogz0SU31r7n6xbDm4sSiqDSiwqq14
	n+CrXJT19lnhONJ5yCMREfe8soIJHSk08nKKWgV0k/0tssecuZIpVzITOugb+YCKtPxsDC
	gUz5iQtC/Jz6BSXDCEcGs+5WUPLePuM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qxvm4YgN;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756287410; a=rsa-sha256;
	cv=none;
	b=PX31pDuq3AOqHWcOrjeknNN9h480Wb4WAj1CvqSnkygUHeVM0t2Y/dCzyhdxuN3jcp+hfv
	XD8ugERxM/L30RuCEr1kx28jhCD6DKx3avlrm/f+QMQyVVrpKt+z+Az0xlP1sdyuQmz2ad
	zzEcYyzFC6X+dOnAhZtG2Ds6zgYjloc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756287410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IB58ANfhXIZ53R5kVuf3CfNJ928IdN95VpKDMuZxG4k=;
	b=Qxvm4YgNfVm8ETwXw0bnuaR2AZwnPnDNqjvXJ2QM65g4jstzQE9uluV7bxu2oOYOUl2+Sl
	82xrTOTv8rzXQFYqGM/9Vv8myWCGtiG8WMq0PS7cnerZmCj2wpTxw/gIFvOs3gwkPdJD4g
	aGUHaPF89e4KuBKIcU7SvL0DoFJNd3I=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-O6T9-ag2N7qS562QRjesfw-1; Wed, 27 Aug 2025 05:36:48 -0400
X-MC-Unique: O6T9-ag2N7qS562QRjesfw-1
X-Mimecast-MFC-AGG-ID: O6T9-ag2N7qS562QRjesfw_1756287408
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7e87069063aso2435349985a.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287408; x=1756892208;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IB58ANfhXIZ53R5kVuf3CfNJ928IdN95VpKDMuZxG4k=;
        b=KB6hG7rLSdGcHOjTMWrQ7mszVIBP4ngDCGTx42/1lHdLa/CoLWvQyJtpo8HEqetfBP
         HSQXrgP4UT0+z4Ka5puJr0tDQzfAICI+Py9NWrz4VnMLqgeh/ScFuWWXBOpm69/GE/bb
         0u7ksXzvEAzkPwaK3x/vdocw8NT0DYWndgFx5ZBB9T+Ca5KLs05Snmp3blDKPjNivb7t
         qAmfdspkroCSNaRK531P/x9fOqnXdQ1U6dQ673kd1GY7E90AGfr67nRUrFSe/bQPeeeZ
         DOEAFgdZ9X51OQRsCISbA7SBNAZGZYIeLPTlLeFrYwYYA2MG6llDfCcaO8prBUv9YlU9
         nczQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqGN/WJacxSVYGOuTxaD43B5C7PjpDWwUE9QIig78jQpzV2grhbECus7Ms2SlWBUuWp0mZQ561CA==@kvack.org
X-Gm-Message-State: AOJu0YxNyzpgnKMW54nJoDmwKjYxVhc3Ai8rGVm1+dNt+gqBVx7m6llL
	n6TKxp1VHx2bQwksYEA0bC2duZoBw0IyAeWH7i7KGpKHZKuWrbAbeTCqsE22Hog7yWapyePrS6G
	jmQCbeuFfeTACkzIf4/axXThVf1nkRIu5vUH+/Oi7+jFPDwlAdDAv
X-Gm-Gg: ASbGncu7i4D2rE5Kfc7kxVyT7eIfw/hSzlvPvfnWo6qw0XX89GLWaQ1XJZeb4hSjIfy
	lB6dsXTH9ShvnH6UfykLUrlERjdrlDhUToXgoD4XrbabD4f50PfMFWZZj1WU1CcCYgGlD1Is4op
	KtSXbhrtgYFTz5vIi6OlNuN4kzVn1tbfwPVL9AbLtRqisiLpIAHOsktlzSkYLuRZA3+JPEEH8jQ
	D98YJxsoxXsVsgxGbx5ojXYSKmlKdSLojUdCUWLPA0+oAaNyLKrCBoGxtxoQn/nFEKc1BesTVRa
	rrrRvdigoKLFv7JvFcoUKMJpmWWkaXQrfyu4Bjz4jfuXGWrTfHzD3lWEOotGEA==
X-Received: by 2002:a05:620a:4147:b0:7f7:b238:feb6 with SMTP id af79cd13be357-7f7b2390309mr145611085a.12.1756287407622;
        Wed, 27 Aug 2025 02:36:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF19mdw9HaE9u1hIUSoVrmuZ9hix/ra7ZUDWgNbmFEd8sI9w87p9vY/6qDxfcqewzc9GjVfYw==
X-Received: by 2002:a05:620a:4147:b0:7f7:b238:feb6 with SMTP id af79cd13be357-7f7b2390309mr145607285a.12.1756287407047;
        Wed, 27 Aug 2025 02:36:47 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e1cd7esm89693771cf.39.2025.08.27.02.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:36:46 -0700 (PDT)
Message-ID: <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com>
Date: Wed, 27 Aug 2025 11:36:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return
 false
To: Max Kellermann <max.kellermann@ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
 <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WyNhOg8yjwPmAUP69CHwEfG_ESTCFOm9q_Vvea2lNss_1756287408
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC2F710000C
X-Rspam-User: 
X-Stat-Signature: 8iqtnxr133m6wmdo5d6gpfktohbh6tko
X-Rspamd-Server: rspam09
X-HE-Tag: 1756287410-654658
X-HE-Meta: U2FsdGVkX189We5oUoxI7rErQCHbEr3/1neSeLmyJj64OluhX3CJvtRtFK/Z2yyvrJctG3+FAuuVaUTUaF6E4dVejF0jrg9iZkKcHKi53yz0qFRv91j3oZDKVymtj9NqESnYL70wqXJw1tx70WGn1KZflPhFymWxfdCf2mEeprnbONKJ2pThsFGtkr0Ob5MWDmXQeYjhPoujDPF/DEznvQyqRO/Z4m0iUBHjY/ZerXO9odNaA1on5ReoIZ2+RnSGLT3KfGbc5X7STJoUkN0V89Q8VnvxkC8I3g9LR4d7VUScfUE2aV4ijlVtcRspIqlEZ+gI5JRVH3Uyb3wUmwujppEunOubPiuwLZ5mbn03H1rUesbZLiG8mSr1CW7ZQBItU8J09JFuKtuGIyavqXPHeg9l0UP7wZowK3bAG1pFtzMOWzgpbwHrLXJFNtLitTWXFGA6tluxBSDGnHMqPvTLCJgRS8d1P6zQ7tSn8VrzKlnrj3zW0GUMC9vGAk4IcAsvNfh1YFc3XqbrxrMt6YfHelfpuaiizF6q780Egrm8dYocVeOWRbY7KkD5yaTiX9Kq65PYFYK10r7sEZKcosugFW4qupuDBXOzJdm6h05DVRBMRQw4wBOzN+0M6YfR1FGxuUTZnnCX45/A/YmvUgviwhbVYEyW/Pv5D57Dq1FuxPDmKDLO0AfkR7Uamn994NESRCODmHEssT6mq49WH3J+hm8QExBT1OlV1LhDSt1dkbp/Ili7TspoBts/23FgNzn+TekkUn9CPGE48nc4Hi9fjhcD0Py6lLVJS+pWySuHZnihZOdM5Kjwd+9MLdiDl9sKjpFKFddPmXdStaWGOvCrihbX0YTO2IK4F8Q8i8ea6uv/X6YUv8weFpffAMTnl4Ce4HbQFWhndMvZfKmvYHMpQyXeCYX9G7B5+CbgrPC29Mw/KeOtDQYZkIMUTe/iqLu0p3/ijLBAyjinu9hPz7/
 UFnK6Ni5
 dLE/HXtJsXown5Bskf9Ta+GWznPgNe69NtMjB+1WjjaqteEjXV16xSoqacHiRlmvNMjRIm1deyfpbXEurAJ22TDMUi+nCWQWpJlE/mloh6CsvbztTjV5o256Ny/Jd87xFXipn+czG5t0BQsiN7CEoEswY1B0MqYsOe9s+NWL/uqApFMPc20rMCrsZnH1aJKrzH7M2u7cqFAO7A456M7kbYz1cniW9MPeNSnqnc3sJLkT3e9bHn8flWRFkJ00/Nr98zIdfP/SSuqg3MDjevBFWgahIUzhG7d3691phH0ckS16p2BPbcRby/k/+XbYS38HL/eYkIHjOb0w/xQytMMTlgUd3QvhMolgE4PxtNMoJ05frjhvQ7+iaM+yknHybgDQ70a9g7+yj6g546QQufBRHiBJDWOzqL2fppxRnILlhBrsxTnO7UylN5srwD9MyBpWEgls8Um06m7oP30LVMsNe786SD1k/59Mu2wovfdwpYbjBrg3omLlESSNM0FymnAmvseEQnTkCoopSXOE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 06:39, Max Kellermann wrote:
> On Wed, Aug 27, 2025 at 3:55 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>> Isn't it a bug to call is_huge_zero_folio() before the huge_zero_folio
>> has been created?
> 
> I have no idea, but folios_put_refs() calls it and I don't see why it
> shouldn't be allowed to do that. What else should folios_put_refs()
> do?

Why should it be allowed to pass in garbage (folio == NULL) into a 
function that operates on valid folios?

> 
> (Thanks Zi Yan, I'll send v2 with your suggestions.)

No, use a VM_WARN_ON_ONCE().

-- 
Cheers

David / dhildenb


