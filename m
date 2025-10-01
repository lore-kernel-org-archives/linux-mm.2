Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACA8CCD188
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 13:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0614B8E0008; Wed,  1 Oct 2025 09:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DB38E0002; Wed,  1 Oct 2025 09:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF54A8E0008; Wed,  1 Oct 2025 09:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7A2F8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:53:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BD665C225
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:53:09 +0000 (UTC)
X-FDA: 83949686898.20.02DA1FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23D5B100007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:53:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gM2ZPMh4;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759326787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RIqSN5lOS0lx+fxCdvmQnUTqlJNkX5KmnQOAVM36xgU=;
	b=A1oow5nCU40BtuxsJQIRKKiDjmCUKZ6dJp5oJGPkI/euELgPNKGWubbmNUOeL6Pp3MHikW
	//uTmD4GsP59oN15imA2liXG+5BoyjtcEy8x8l4hHzM9QU6ObfVQIrSwBaacAWdRv0FVXF
	pMZ3gXovBHKXbdQP0EnDMsuxnWaA0Ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759326787; a=rsa-sha256;
	cv=none;
	b=TViH/RU/2cYPH9BWdOhKOuthAe4KzhIue6pOxAIXpZSGG53Lvnj4TSbTC4GMNb28tX0zKw
	vOIBjio9c5fL+codSsbotHuiA6u+9fSyi3eaNwnRVKAipF43F0+PssmvOvxRTWKFtxvOk/
	xAFte/LgEzORWsaAkjBUyUVyXzdHhLw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gM2ZPMh4;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759326786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=RIqSN5lOS0lx+fxCdvmQnUTqlJNkX5KmnQOAVM36xgU=;
	b=gM2ZPMh4ldm1fysXQgc7CZ8/6NC6bZ2wP0pxtR0fLhCwPRj5K+CdtnugI+BQ5RMDSoRSbM
	Y/JstauvA4hwTzK2Ik3MjE8Q6qF6Lh6CmchLBN/piu1lKdX5yTvWevmvJBHSTG/WBvrY0D
	IMgIN0k/P2ppgr9fxWDCdzGymp6/gCs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-NZY0jK55OiGbxsgdKGEHhQ-1; Wed, 01 Oct 2025 09:53:05 -0400
X-MC-Unique: NZY0jK55OiGbxsgdKGEHhQ-1
X-Mimecast-MFC-AGG-ID: NZY0jK55OiGbxsgdKGEHhQ_1759326784
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42558f501adso296900f8f.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 06:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759326784; x=1759931584;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RIqSN5lOS0lx+fxCdvmQnUTqlJNkX5KmnQOAVM36xgU=;
        b=jizAPlMSMN5AU27Df0DkE0zGQofp54KPzT3hIDgY9gXlv7udDlM9y5WXejCgi8GZFO
         JsoWXl2bLtWM4c99IM/jMuzKM1D94a3x+WbUC6DGrVwtcI8cQ5XaPuCFZgzP5eqkloUX
         u7zpVp+RPlqNo4hPVx7oxhHI3VBh8TZLSju74rKfljapep4mI+mIsRQ/WGd7EiDcYVJl
         h3izsOpGi5w/xQhO51NSXq0RlT9gX0JAbiKR6U1aF4V8/BLAaiM6lvbF62TtudSdSE54
         FkkXewRFDfUNYU4Hi/KlC0I93JUWgwAwsxN/zzUEinLQcUB3dIUZwaOdogK19kmDJsag
         x8Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUuAyH3RVZo7NjU0RrKe65kQfxOyyvobHUbeTV66aKl9qrFNkHguMWI2vefIKZcc5xFp0rXScFmfQ==@kvack.org
X-Gm-Message-State: AOJu0Yxm7o3elcohTfpypymzDsmP2nPzitS6hJvasskIoVlV7Som/xIK
	eqC+FgX8Bwa4sWyxdbqPA96EYCUrkhzgj10f+T8yW0c7s43fyk6FUvjTlSXDoMThxtV9iCDA9gj
	FvNZzAsJQ2UcSHWnVG4dV52GUUdiBnUuvcxdpUhttQGsr8a+eduDo
X-Gm-Gg: ASbGncuY28RnLc1Ni4qfGmowAFNTvK3xmewR1LXPbb2WJUPo58bKFXQ2KeQHkw7sCWt
	WbacHruY6r3NcF+F8moDgJq1mnm97KLmdmNI9V/gU2vRpMLhrvT4q9Md66mZciq6YaFJiPwVT07
	9bxsU0wfpNweef8SnLBEabvtlPq/fARlEvEdFdY4MxUd+8GWlUuxuGqCa1/s9KIkjQPKXN30Q1X
	CULfkw5IUTeCsAM+OD1LA7HWU2tG5l/8d9fDGumKck4S+SKRy7fg8U6BQUMtQ5jVvQjeNUm8Ed6
	Dyr87/r5iNx03m1EbF5kjvV8ZNm3NsDGW7FocP4l3H7PdblWY4+QMi5DBGNfAG4GjTlZ7lsVN/3
	aYZAZFSF4
X-Received: by 2002:a05:6000:178c:b0:3fe:4fa2:8cdc with SMTP id ffacd0b85a97d-42557821af0mr2950603f8f.60.1759326783849;
        Wed, 01 Oct 2025 06:53:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+osrXX7dLfhabimwbe1Ui3dLBz9xJHd5NVGLhrkEfVO7icb3iXnJtmb1AUet8mnR6yDeTcw==
X-Received: by 2002:a05:6000:178c:b0:3fe:4fa2:8cdc with SMTP id ffacd0b85a97d-42557821af0mr2950550f8f.60.1759326783222;
        Wed, 01 Oct 2025 06:53:03 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b7e37sm40453365e9.1.2025.10.01.06.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 06:53:02 -0700 (PDT)
Message-ID: <ee522bc0-8c99-4065-85b6-c1630cb72a85@redhat.com>
Date: Wed, 1 Oct 2025 15:52:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-10-02
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gu5OSdEhwEgSD7-DKeEXxoFDLaBbW55jBQIa4Q2JxrI_1759326784
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c6cix449e159reo1qb68tsszcfgm7fg9
X-Rspam-User: 
X-Rspamd-Queue-Id: 23D5B100007
X-Rspamd-Server: rspam10
X-HE-Tag: 1759326787-799615
X-HE-Meta: U2FsdGVkX1+XeVHys/ulinqsAKYWx5oMkFWdjuCXBkN6fxPnsbAzi+vh7F0AY0OX4oSYy87UuPImJPRZFeyMBwxEyKmUmPfOXdP5D+ciDu3aZTMKkzvvvep+g6ln9M0LAf37JnZYJ6tqW7WM3G+NALeioEt3mggy1ZfZGOItirEPiRLVLR3hxpGRTq4GLKflgRIbkfYhSKc6KONJY9kjjFkLyWocr28UfII9YToBh8oax0SUWD21ea4MLkL5ONRYgOYVrFb9kIbcpq+hrc/ImuBf4jogxFjj2REazDjdnxf166zGm+BMyenKRbNYGojI3twnhRJrHJawj6mB5MclztU1ibUFGcke574hgSY84PcmvytGct/+Vlb1Mm8Ecu4yG95l70J2IOVfG6X6M24fCeAl5TSdQ4WEB7enX3U9JdlkjhISoeFgg6S/pbFEuRVxA3Lj/IA82JpmFa9n8McvEG+HZlmApZOnnqMJaYV0dB1TdCtYzD/F8TWzcTeMJvXkEARjw0N6ADYxewIT7AOdGmZTQTCvCvn3at6RxqwwYTuDWmBLMoxSj7jxLsNAOe9ZQypKxgxuv0V+By+KztFVhbv8rqrquM3WG8YRe6vdYT1JAeNt9CZK2hoQGd6YsO6MXTXFePOwyoaY1EOswN6rtc/lgoAbSO9c7mb4txJL5+Zs1xmolYq4m1GEhMYBZfNi4/qRCLgE3xVAtWRSW6n7nxFTwB3khyWwsBBgOcoD8Gw0LRlTW7VbGBIbqUZxF63n4Ok4ZI4DKoD3VI5Qcd1j+7mzs+Dnq9xwynTe1ZCe3Th6OnB5TQBEzwLbrT0BUgsJwHDfKWEkAIOjP178a/05exN7Nva5Q4ogzeopAJAoERnvhSFpPAV1Io2xQKpplkA4x4o48ZoNBoPeI99AIE5M8KyKIzSH6L/qMS1yYyHH1FTsAguvdyfjzKafLpxwVWn7C0HS2Jm5hf/K3RvezrT
 HKf6r3fz
 0mOIQJwGuYeRERwjN0CpSE2BYis81rsbRSRd8X2o98rJxGi1r0VO4QiKkh8YG0PKlVhQf88XMMUO4o6MCLQduQED3vmLkwcXmbFv93aKGJNtR9nNdjT30p4y00P8DflAUgFTRf3wm+lGCXfgjFpc1o6IJsYEre/HbEfBjxUxbbF4E0ihImqcK/y23Rq2OyK98JU6XhBGPLQshlE0VZT1gKGANkSZ3chiv4K59sLOo/Y7I8LtcpHGDt6F4AXEHlpIwUWj2LjHId0aSyHQVbPh9Lsbr88aTHxM+ZDMvhzJ55yCDFrDmYJHWzNdrB87AaR2RdUbiKGINLl7O8DQYHmwPjtQyyUwOrXmH5Kx9ZbE6hNldqmdjMHMCGTa7eXp4VTEILER2WFn05jAY5+1y+ebTNYvtPC58zPqrMLLZ04ArctKJ+Grb+afEltjZCdbMRj+CY3Z5pgksnCju4HmAQiEn1gDrAUeQbEwtr/pST4yqjlMUmSHj8SPvGDSOKkx3zdIsPNiKpGhQIRu9ovg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-10-02 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, I suspect that we will talk about

(1) direct-map-removal support

(2) mmap() support refinements

(3) "stage 2" and whatever comes after that

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David


