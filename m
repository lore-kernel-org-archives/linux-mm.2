Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776FCCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7A18E000C; Wed,  3 Sep 2025 11:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58C08E0001; Wed,  3 Sep 2025 11:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B200D8E000C; Wed,  3 Sep 2025 11:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 99DF98E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:51:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4282F1A06FC
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:51:26 +0000 (UTC)
X-FDA: 83848378572.05.02AEE16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE53D140006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:51:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WaYTMnN3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756914684; a=rsa-sha256;
	cv=none;
	b=qyclrvzNWswR8n2qLPUF/Rsh7eKeANmmwMtH7t+B0joy3huMO6YtAYlP8U4vGtebkAVnjR
	h5EpIvJdQ3oHFUEHOZTRflTFVvjWoiDK1+GRo4Po9DLs9Fhcu2aCgocRQaMOslh8ThGJIr
	B//kI6OAhfWG0j6356Z2uAtyR8NhLdU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WaYTMnN3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756914683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pPz1Dn3KwcDP1NsdH5IyFFzXwAHxlthoHdtCNvU5f4=;
	b=yP1gKlDe07fSCMQai8kZt0SYwPoI8AgbdOHah7tiLZC1XyeG+Y5u/SxfTtQYRJU92hWXF/
	Cu1WTm5ZcG3YllfcJ4BNG0QWAF0xxBPI1KSzfu79mtmfvCbm/2FBdXHPLn9SA2PPL4KSzp
	YQMqc58Et1bsFhOXofdHCBAfqrmu5BQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756914683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6pPz1Dn3KwcDP1NsdH5IyFFzXwAHxlthoHdtCNvU5f4=;
	b=WaYTMnN31j1wsjZltQK7CO1j96lCiZQL/Qmnz7eSlfMWwMNxoo/BjwCdgGMqRnmFYwtxXo
	ZpyG5BZmULR1ZmmnHoIyVYy4M2CFxPnBu0yyEjDyLxV7NnZMg1mI2IGcESG4ykCbrf8kY6
	Da3kKbXcTqplyN0etB0lpfoOWGhhC7c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-IM2mAw-fORafY-VJseHZlw-1; Wed, 03 Sep 2025 11:51:21 -0400
X-MC-Unique: IM2mAw-fORafY-VJseHZlw-1
X-Mimecast-MFC-AGG-ID: IM2mAw-fORafY-VJseHZlw_1756914680
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cd821eaac8so51844f8f.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 08:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756914680; x=1757519480;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pPz1Dn3KwcDP1NsdH5IyFFzXwAHxlthoHdtCNvU5f4=;
        b=vrOKB6Rq214RKQ4Uw64BW9IojtXn3IryExAhvDPiWHkkAmEBNCxwSq5YC60w/jk93D
         oNQZpiGYcAm/NkoWxUp1jVbvcxZrw7uG+npbnAV1hEHyEFPcKXBqf2e7ZaAhcMzZCyoN
         U8BlFLVFn9AVadpGbOD4AYAHnxf+AcQxLxe+xU1irW0/lOjQhxftTYYbLZgXqP9eWSs4
         EbfHBwT1Gk8GMOpwsedlI8gep3IMdACBuSAm17EXKN37tagFYuRT4cfwvHKEoIJ9KXrk
         qgBXRVGudW2T0z0s+pTTcbVbWhhW4mvMBMmMqdSEKixpRRdv62u2jvpVJz2kP/uGZhns
         oMrw==
X-Forwarded-Encrypted: i=1; AJvYcCWcsPqRAVsfqs83DCJatMEWJvWn5536QDxYrx/H8jVNgz7o2rrZI0zGmaqTC2OQFrgQrm0ioJglpQ==@kvack.org
X-Gm-Message-State: AOJu0YznUQsY73oWPGu7tTNKN7Ake11et7GaM7Sc8xL9OJYEeCMIWnsv
	nIhkWhQmGGwWsT3I7uiX2XTY+rYExipjq0sdNxt6xZv73tpEIipOfSE4C+z+8fD6kZoLHQeuJ96
	hX2V2xqa4UNlRjFWHBtAJReFo6V1aMwTldGLzxCBiZ6xvZs1fKGXF
X-Gm-Gg: ASbGncuz7AwPKykQJhEUuvRGFJ1+64/bUX8S9guBIAW3mHceejCtLd/KMI4DRIoWpbv
	CVBePxmYTpiT4AuKySBe/oLu7F9VxhT9os2YowSTSrQdAB2pd6bhxZVfwoIAyND2x096LQnGn+u
	OdvpSmTPjmvGAzfh+A4nmFlvqNvZthd8VtcxSM2N4/xU3RsZJ/hP49Sc5atmaVxzLew79e+wf+6
	micmcMsidWEqDWsC5bedGx3bXvn49TvbOrNgPe2WIjqjGLsxiiiHwu0JafEfy/XyU9B2+enNIut
	35TbRdn9MbQj722dUqtZ/yoUMOEDass/jALwtK4ziaKXXLd7sMnMF7BmO8ZU1f6GeHo0ij82Nx9
	K4TMZ7HSvkmrbDQE0Y1rj5FIOfcZi46y0CGQsiqp9JJdj/f/WWceMHr/SUsqJyygnXkc=
X-Received: by 2002:a05:6000:25c7:b0:3ce:9872:fd3 with SMTP id ffacd0b85a97d-3d1de5b0cd7mr13182347f8f.34.1756914680128;
        Wed, 03 Sep 2025 08:51:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjvLcrw1GI/BKKHqQpqdWRD2zuwbafhFNRbxschxHG7ifowWJiWnizddECBTDKy8c3BUMZQw==
X-Received: by 2002:a05:6000:25c7:b0:3ce:9872:fd3 with SMTP id ffacd0b85a97d-3d1de5b0cd7mr13182316f8f.34.1756914679719;
        Wed, 03 Sep 2025 08:51:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e92a42asm242463365e9.20.2025.09.03.08.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 08:51:19 -0700 (PDT)
Message-ID: <586a6b30-f4e2-494a-b83e-08c1b01b4197@redhat.com>
Date: Wed, 3 Sep 2025 17:51:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-09-04
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <5d1bf8ef-5f30-4962-bbd3-d698c0e9b7fe@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5d1bf8ef-5f30-4962-bbd3-d698c0e9b7fe@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aI4vdl1Z8SG2dFZZ-2HalS8U2Usm92l1x4oy-6S2jdE_1756914680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DE53D140006
X-Stat-Signature: 76nwtf61yrhj958nifdiwxxsppxuz7xo
X-HE-Tag: 1756914683-302684
X-HE-Meta: U2FsdGVkX1/OtEgnRic0WkDW96bCMGDHHr4RpWDyR9YCi7iOP4Ki00HZTnC1nw2O8gczzms1uNKs8bgQQF8jXndN2byYKh8ktOsWWkq1/3TLjwX76XS8NdVz4wF+NTN9k0GPJlUp65HpyX6o2IWbnImpIk6csFPtlT5ZuxyLDI7UCV7D4n2Y0Op63SmpQZ57cEUbwzVeCSw5Vr4yxrxVEULDnE4UB44aJo1WyKjfUTZHSorK+Rdvv91erR4XWhYy882gOh8C5PspMILYvcK3w3HLBnnDvJS7LYXG6nq6ZRTQXQalbnabVxmak+wKCBFgtdIbNljIFcxP7KSbDvUzknsVtiAa1qyC9k+B6ZfvqqIlpfr+uWGZZTNddnUF36voLHRngrCtsrV+GGKOUtjZZYVMcHV+BtJc24uoUh6UplyWB4IyVvp+jLApWvF3/JkRsxfF+SkPdRVxa9RzlFVke/138N7+I7b2ZiA6VEUxeeOzfAyv8nNXCTH211V0q6sumQK9vDRb0aiAjO50WoSGWZfZztgIbqgAiLniu0DbmNU8ACK+mZRJjuA21taZ3gYRZD5hUAqQuytmDK4UBpEQslmPFlp/7PyihAYjUge06eXZflnqx4h4DAsS+JVKowXWu5qwTac158JuuxuJBsZe7rAWLcgKskFd1f8F+oKPZt9Z6YpMS2in3tAKcDWouyFg/4hYfZ13Tt/Rfila/EIQSUolC1caa7l/xXCTHTBfcS4c8xidDfw8EwsTr2sxAbuT80VsJNsMfYJO4A4i4H3ArpHuw8iLFt8rlZ9ffmSWAPwVYcmPrxuRDm45ivOVyE+Zdtg5H+gF/pyUwkFZMNYtRMWa5qkGoDuxTHQ+Zrf3qm3DwfW40fH6b9soDnrMnQ76H+wOD322rLFpKMpZWmh4O5IrDc39Mwto1MBQcqxdbAVhEQuiDvARmT12D7CE5USxIury5LkNEell6iBA/st
 F0g3abax
 PvF63LnjBe2krRtM5NeweFVVCExHvtQbnA102q7oj+kbvROTBNvthonRxGywtq9MHuszHK5jVfc3tDQEgy+nobBOPJArygEmisUNyYgtNpux0S1cSNkM1fUp88DvppHiffdndJXo6sXg8kdPJdIqAolwmsQBa2elWgx46UYvIJnjgcbb3fW2MGFp0y27F6ECHq57+UGSuqm8tcSuEif5qeLVRgPahv0KC05aYWey59mWqVYOiAElPPPJYXeG8QBEdPcmF+5GmYYFLARnDi8sYqX7XPNsdT2ZE1NBtJfVdB5G1IpA4LPPgSi2lOPs7gg4EGmH391SOTlfTsxtMVcVt9R9kR+QrkEM4im4Tsa3MsQfaqRq5snp6YYEfZEfeDKzJhilC3nZ8jl+0BcCfSfEOyslHNP/jJf4H2K1dVVB9EH7S7e+sEKYlpl/AkGeYCVJYKHTQv41zDpYgpdGw6RMIOWN21VHCAK6tMUkz8aB83X2NRrOuQLUmTmN26eSjkZ0zS6pC1n3irnlaZOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 09:06, David Hildenbrand wrote:
> Hi everybody,
> 
> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
> 2025-09-04 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Change of plans: Fuad reminded me that tomorrow is KVM forum (guess 
who's not going ;) ), so it's probably best to skip this one.

Talk to you in two weeks then!

-- 
Cheers

David / dhildenb


