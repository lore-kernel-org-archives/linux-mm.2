Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1D8CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D582A8E000A; Wed,  3 Sep 2025 15:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D090B8E0001; Wed,  3 Sep 2025 15:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0828E000A; Wed,  3 Sep 2025 15:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A79188E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:13:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FB05140882
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:13:26 +0000 (UTC)
X-FDA: 83848887612.19.106DAF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 020B42000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:13:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GFdUc0n3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756926804; a=rsa-sha256;
	cv=none;
	b=zekG8qIFFdFl06BMbKykgGuWTjTGntSl86oOF/gjW5XPz9508c/zwNoCt/1Kw67YtGh22m
	v1xWYwqnYaOc+5kq12jTJpvihsEUQoUv/arPh/jxmUGVrLrbV3C5n9VfUDgKpcHpOyTkNl
	+VAJAtaxkX7XUnABdz4XrRDD/doo8wE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GFdUc0n3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756926804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9efZduikSFnzjh5/dSeOTEpOmP3UF4mDaQBviml7j8=;
	b=cvGGsuf40np4JG7JfC91ZiTxEol3P2bKPjSfkDjuk4eCtsuwFYbmnh1eN1riW/ad/v7Sdx
	FLfN5sY+SvglXcva8iGE2O6w9Hd5csLEsTDSXNqVX0041rGxoH4jzLMGm8NylPpHjoGEVP
	31vUMz6zkEyux4phKeoPFbDn978hdQ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756926803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P9efZduikSFnzjh5/dSeOTEpOmP3UF4mDaQBviml7j8=;
	b=GFdUc0n3+hx/RgUpFT+azpqkaTIpaAaQRZmnfhZTVEivjHbyknHypQc5gHh4TQjZnGzvgL
	eMYWkb7sLho5j+qmi2SKC2nIkFxnpBF4L0T2ntcvL55391l3NtmMwujWdFSqii9FiqpzMD
	5NPnNFZ3hBMmVy0MqB3D+rjR6sfd2Jg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-2wEmzS-ANI-XpaurSVrtFQ-1; Wed, 03 Sep 2025 15:13:21 -0400
X-MC-Unique: 2wEmzS-ANI-XpaurSVrtFQ-1
X-Mimecast-MFC-AGG-ID: 2wEmzS-ANI-XpaurSVrtFQ_1756926800
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3db89e4f443so153368f8f.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 12:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756926799; x=1757531599;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9efZduikSFnzjh5/dSeOTEpOmP3UF4mDaQBviml7j8=;
        b=N+NPqZYs5w6p+JrKijqA9X5b6vibUGmtP0AP02RmX1H2PtiEzY7dp8VcQO8jWsDWF6
         fT8e8arGizl0qJi4/ohYyTCzl7Zjf8xhPmKUPZMq7leUQqKtvWi8iL6S9w7VuOJ2KEjf
         l9UaazGGM1yCcv/HY/Y5Fc30fhS55bBFd7F4wNZam8ASkWtHrJ8UcrQxATmqsaRnvGpO
         c8mOxMp6fQ+xPdze/8EoEVOnWavbIH8jhqEnUQOuqpjAsVvHVrLL3DERnepdxhfb6O6B
         K5QbkvdJSDAO+ggsL5z/XC17/1WOKu5mGo73GXncvX3xwMVAKKDoDf9kRreTi7Yp87a/
         tecg==
X-Forwarded-Encrypted: i=1; AJvYcCU4zH9XJZL0h2as4zcXv6IlgkzMagBN5ihA0KYXFjYWVwoqTCJIlIVxwTFiitWmfk4rLbbPmlayIQ==@kvack.org
X-Gm-Message-State: AOJu0YyvVU7k3eXwJU4GAd2XKx9Xj1mCnOmdRIZIXXDjDhuChzXgW2C3
	Hh2ryTbuGNRjg9ivPfpMA59PywqGpWWV51lfuGe1EvKBVBHcPQ2HKHjr3lxxkBs9y0QKub93uZm
	aVox/8sgAMJv0uxFXNmigmYQEAkSnDRQ3eWyF1uNMgKDP2SEIudsMO2Kgmpjq
X-Gm-Gg: ASbGncvXI8eC6HVLpFmP3aMNOB1MRIEYCUVsicwmAhq1D+Pryy5qnmVg8QVMyQ9xxDV
	Xo/kPUjnYIFWzYCedUwnP+DIujnPZT7e+c/mUDGyawz4gDIrXePhkRGaDJuWDjur3OXCrKPff/t
	Ig2nHiaRbLnZH/byRaZwGjtNTKKykWNhYNggslQEZJnaLXukSfWBAp4tGQMVsnhFVl04wrV0zwS
	9zjT71ygRWVayQObxPxb2Biyrk5VM18FftKR7HtLfaUUfD4Y3gUgFriA8qxYU1AXhtDEJe18UhD
	yPJn0mVkXi9RpBua4ulm3ylbVlfDgwPesdMbUHAgBraA1PaNe7NJHt/4FH2Cv9x/0mUxgplaOme
	JzWMo6N0qf4uS02mOZHaBoidaEsTeYMpT5XLzPk8POGP5kjwvU/e9DJZoZ9hoBdpIccQ=
X-Received: by 2002:a05:6000:26c4:b0:3d0:e908:a10b with SMTP id ffacd0b85a97d-3d1e0a98afdmr12916665f8f.56.1756926799532;
        Wed, 03 Sep 2025 12:13:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ/vbJZF7Gnq5OOkQLM1RIJN39KlfIKUtJSN0ttlFYZVmCF5jsL7cMmb4EZqATRVjN+d4Mbg==
X-Received: by 2002:a05:6000:26c4:b0:3d0:e908:a10b with SMTP id ffacd0b85a97d-3d1e0a98afdmr12916642f8f.56.1756926799082;
        Wed, 03 Sep 2025 12:13:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d66b013b7dsm13632800f8f.28.2025.09.03.12.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 12:13:18 -0700 (PDT)
Message-ID: <8ac6e37b-15f0-40ee-b60c-8893156f8cbd@redhat.com>
Date: Wed, 3 Sep 2025 21:13:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-8-vishal.moola@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250903185921.1785167-8-vishal.moola@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n1y12FNVK_a_Xrmcx3lySshMqkq99IGQZpJsA2ajrbs_1756926800
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 020B42000E
X-Stat-Signature: dsaq3xo76hydc7noo4fpfziq6sd3ue68
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756926803-175526
X-HE-Meta: U2FsdGVkX1/YnQMcfE8QudeyCJSlXiOG7pvVGOXd17Q2shhYRIQptPWdKF/ZaD91Aq15lYXZJR7n6pKHwH9e5VV7+AeyxJXin3p5p6WaF9Z0UA8gLVpK4TgPi7+EY0Un0PeAT1/xllcTncOFcio1E7PiJWmkb6QQaXJ96q3VERl2R1qS8PCuF7uwRd2bPawt3UeX6Sqlbxp+lvNIL+9et73YqrDIt40ZOxQsShN86TqI7dPqE2wsz0b7u81nvZxCZsr1z8VR335enEvBUurWnkO7Px7PXkvwlivzWqt8BVsoqa0eP1VImEpvowAvFcl9Dzwdl9b7FTCx8VntXOsxqU8CH5wA0N6GFR2VhFsUwwL2R1j2ft994eM0+NhCe0//60IIcZ48xmEUIAdOVi5ABzZgqBT56k79rlf+Bxjw/vwR9mBlf+izBGAoL3o3+JdGya0bfbUaNEekq7QccOhz59N+10NtU4h0ohS9Y5sKO/qdHkMwTMfMBBvu0ZYCwHrtE1WwEOtLEzNHkvYKSlpSLdWDcKyfQOskSOaJN2QYjqJvBK53fIYRe9vei1F6DIjhtTZjckOgZmrJDpDSCRFruW8xCo6s0rzeJb9PSgOgN8EDO/EIQnoH8h0uy8T7f8UjMO+qT4ufJA2666XDO5l+CKIeO1oBIUW8m4MavRedsHMOV6NDSA1GSVdkjLH+e2WWO5wsIO0wmkMEAL2HS2Gag3aqV3225DY9A8g4ms7n+o7n3iXKTrFehp09Ci375OZGIhk6RApDZxFB1q0nzDhipZx7WQN3cX1K0CM7gyXmPqx8+UhngwYnOyLnxlwBwegXBjM5ZH3NrQS9sRMbINo4Hi+C725w9zzdzj/AgQLyo+bMIIJ4XUeWCjXrWqMUcBEjYR3J8QOT/Q84+J6zIy1uViozurgYvSkeW1JVTKwIY4KoQW6ln38E06WF+9HVx4hP/d7rwN+vKArcId5m/m3
 2C/IjtDw
 K2s1DEmDPbgwKw/vuD8cROi/VQbRn4iFMZhH8T86MtjpxAjpDlWtMGxH6S8T3ognbCuPjEi0jDi8CuwffV2eboQilRximmahExQJLhKsAhSUtPRX46qLrMKQiU6hHGSJKM1BN37jm5ou1T2+7Ep26+S9lDbjPK5BZiea92qIE17Vk8+ws6j0d0NyOb3APVvvAEV+mUYcQYX5VdPYeT1q7F8wLqjtsTwn0ChkJVZnSDk12rSaoMPSyoCp/WrXWOozjpMuNeDwHMgX3jJBGSLYw7rva6HMg4EETzrQRIzMQSsqz4ZuRA7F5uMBV6YxwJZWcc/7yNe9Ekg7pik1Ui2SACIbrQ99q8s7lV9Q+9zdwN0omfmCgqJvuXNHuCXwvlOmfHpz6sWyPE4X7/T3XCYo3vcon3MyiAspHu/jxBA8hCAkgFbLlqskK8lK96qPhB1ExWJ6D3NJ1MS7CgOY2bb20ieTi+I5dxvT8JxVV7MnTMuIonP9/OvvQtvUrZ4v1OeUSvRPk2yxP0X6XcSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 20:59, Vishal Moola (Oracle) wrote:
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


