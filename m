Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8444CCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE14D8E000A; Thu,  4 Sep 2025 06:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91A68E0001; Thu,  4 Sep 2025 06:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B594F8E000A; Thu,  4 Sep 2025 06:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFC58E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:11:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40EF6140B07
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:11:21 +0000 (UTC)
X-FDA: 83851150362.24.16B0890
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D9FBE100013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:11:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V3WwGysz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756980679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wer6AdnyPuzKc/3mex250QgaFlSlOoyoixBdkTMFff0=;
	b=xX2aoqtQCArfan281FRFyc54mcBTod7Lc3fK74Jk6QJp/Fvbvqys7fo9YzUDJeWO20FNzo
	FjyDz5sMrTWqf3vv9ZYY883HKQGZJJ8pO2e9E15qUubxuKTtC1f0DZIXEO+6CE2wkTpa/P
	zPrQcK/amihdwxgt28sLoiLoM3PP7YE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V3WwGysz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756980679; a=rsa-sha256;
	cv=none;
	b=AFFtjHSjWNIqwn3PjUIywPgJGze+DYgOvZCM26UNRkdHln3s+gHvRwQIN37PJsN/+weuZ6
	yiYvEi+e/DLauBCs9HLYSXnMVVXSqXSVHzU8hz0LreG0IhTKA7jYMVTUGX718ltQVz0xV+
	03Vqr4nP7lFpo5GFoCATf/OcGF+GxQI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756980678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wer6AdnyPuzKc/3mex250QgaFlSlOoyoixBdkTMFff0=;
	b=V3WwGyszYEJQH3Y8o9SxcrxgkWbgxZYCXHn3eRlVvwU22hc5S/HRxRULG00ZS+tvOWnIOK
	/4RDOcmWtK9y04GFcLOyx7aGv287sUzUPYUuuG4HUChT/PVAzVT/fUP/Dc+qcd8vboxzIp
	4SzkXnIL1RPYK68mchUXu7HzoO58NXI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-q7Q2RqVROPqqwZkEz-14vw-1; Thu, 04 Sep 2025 06:11:17 -0400
X-MC-Unique: q7Q2RqVROPqqwZkEz-14vw-1
X-Mimecast-MFC-AGG-ID: q7Q2RqVROPqqwZkEz-14vw_1756980676
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so6792865e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756980676; x=1757585476;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wer6AdnyPuzKc/3mex250QgaFlSlOoyoixBdkTMFff0=;
        b=YB8Q6VXMgeOLlld0kv7LBlEfa5uDDfst7yoBOWAAV5Lm8qBEnysX4mf3vSex6Jx8LB
         ugFO84rXatUfuHKe4UZVBpO1KC23MR7fpx9Cv+W1V40JBJYYfGan9Th4d05xE/9/DXEZ
         a6CfTYj8s2prLyM2IeRaM8/w9q8cOeP7sWbitFXMTyrMaBY32Ti6DtXtuBwzfFiiaynp
         AVSR2KF3mGbp7C3c7G3N4CY9zXgMPLCQklRJRo+pjTxv4sGaNyMTYcpsNiqE/Nhdn0Dz
         BuqhiLCXoZ7gCfJ4NQNZVU8zwVCUKZf8Jpfq3kHzK0/u2NOj61SDHOdX5tFepPwTL0p7
         BSTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXazhxcnVtbskGVbKBPYeB0GMaYoFEqkSvEtNDBjvvPGe6PThRNlSd0Wa9GmoJuZFr0M6i3EuMxfw==@kvack.org
X-Gm-Message-State: AOJu0YyY3ePmhO2HegOTgcjd/PLwiY/ec3QIX6IimGu5WmubdIkWIn4l
	f25cxMMjMdQu9VJVqAnNwKQdTUzLml41jpg9WyKNEE8b4RSq96oupWZkCdzN0Cl8kv3jlljP2ZC
	Z37kRmsfrTg5vQDaDrBUH4PNWcdD9nPQOgJGK369Rr1Ice83Tgawz
X-Gm-Gg: ASbGnctF9hi4bqPhSF41Kc/rzibNzWfYObbV04T3IAABMA3By/+tPSa3D/7VVnScDN2
	3mj78J+Z86WLfJs1UtYxKNG7T2GhmSq7P+CP5aNL2xx4oRX6oW7liE2FbrLplDzz/t5pTeyqGo5
	pA64R9qKCPB01DQbrnGwhRNusfa3xM3oL5DYQh60AbIF7SZ9KsZqrXTe+8/vC3eBI3MlLvnhiOk
	Gf9yBKCYxepzCIXX+Q4JF1H1bKYpxHFCo51oK4XrR2JkJmkMhzjNiZBBhO2KuQ9ePY5DzezUhS7
	vDViAnU+RthXEpiQjSCC9rNLJE44MQ5Fj3ckheugljpqrrC1fKJV/bQUJFOZFluPEeh2NYGaOmd
	T/1DF4u4JWJ7vw+W+c65MRIjAlprYxBvrnujdRSliyW2SsggGOnedFx6WCYAo1WX2
X-Received: by 2002:a05:600c:c4ac:b0:45b:76c6:cfb8 with SMTP id 5b1f17b1804b1-45b8555c585mr167062575e9.9.1756980675747;
        Thu, 04 Sep 2025 03:11:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzGOJzi2aENDJJt0ZVdjKlhBTp7D5WQuKkO1HkqG0ky4yXo3VOnWS7xXiXzSOprc5hMxrM7w==
X-Received: by 2002:a05:600c:c4ac:b0:45b:76c6:cfb8 with SMTP id 5b1f17b1804b1-45b8555c585mr167062225e9.9.1756980675229;
        Thu, 04 Sep 2025 03:11:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dcfc3e11esm16569715e9.0.2025.09.04.03.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 03:11:14 -0700 (PDT)
Message-ID: <2b681fea-555a-46f2-84b1-9d729cc3b0e2@redhat.com>
Date: Thu, 4 Sep 2025 12:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250904095129.222316-1-kernel@pankajraghav.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250904095129.222316-1-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: okAF_KMWcfuw87iiVvhL9HBqP999c57BqAfqolIjzsY_1756980676
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D9FBE100013
X-Stat-Signature: 76jfik548job9sqaff6bse5ku9re8ueb
X-Rspam-User: 
X-HE-Tag: 1756980678-744670
X-HE-Meta: U2FsdGVkX1/SjdkQKReaNzgMYAEBO16bUCLbJexpRXZHQc9OB0xswLCgh7pjurBvQDgnztSzN7ar+Yj4SaWxbdiI5Xb0mXN8Q/aDwnYm0BoUojcuqDZTH4zeMkmY2IS43tUPEkf8HC8mS/Kq2mfqU8XOtdwBeCmQpMc3v5xfpTKsVy00hkF8uLsCtbadF6bF7rGX790ABwd5/pkbW500L9ckY+kUw0K1xP8UDl23AFHXmbV/ZCWAglf4BjEbZoA9iU1Cw64wXfbyg1OfCowwRGjT3SPzxSuOpqGS9bgtCUk+2pTyD+hlM4Zrzp6Cr8IbhDfrMbcQqH4kmsWEzOLaP45nJMWJ65JD1BxCEe5Rl8lWGukyt2k/VGslZrRYUU1Mo4N04RIXZWPttlbG4ql3NiOG9nlOo3ExAdRBG0qkqA/Jd0gZPJXG6TwG+ooUbPC1RlXPbkTxCze7NrO05+OPenQlWe+g7OSrqTwneyXHzaN3CuzFkFOojEf2ljoC4dLcEko+G3ulhGXGalIBsWaCxSXTrmYbvqNleZ6TdH2lQeJMQZTne3nd9hihOfNqzXdJISrwsVHNYDu/NalgHRJbAfbaTdUdKLgCGMLIMaDsGrNmMc+2nbhG9sXkPBhrj94Eo8wVGSWBAId3veBct75G4Nsp0e4vVvPIpL9L22LH835bF6UtYhpXUNIusCWMExDUOAW5RaJO/CJ/8SF76DmxBsyohTouJ4Wiyh47KDOssH1vHe6E7TKwUrOArcf05czBh83vNsEs6HYWBScxyo19Ofjd4fQ4GqNb2AvNBUvYrrfemnjtueVgdFKsZbJev6Oaz1YID6yvaDcFSzh0Q42PFZETpvD3VoA5f8TK5NWrLiNJ5y6vnIAGYN1x7FrLncTsWNaLt0XhKfN4bzynjGY4VZ2DfnzTVZn1ErjldISjQn5dQ810KlqNXD4/ZkAO7nn1ACggDElDMPIU+ZwmLEp
 B8O+A/6W
 KW877inr9mH9iGLQ4Meqgc1XmLFVPJ6YUf7U9JxRensoJMxU/kSyBPVb7sw65tJf3uTd/8F4tgfcKmXsIRQBUj9FCw1jEfI0SKr4uWd/3zF6DNK46XyG4obST+5DDUI2vjxc1GgljcO7rp7giMp4wmwRxOivb2sI/9F3Pw3UFwYK98E2+g3aOYJaYJhcv7RX8iHHh0GM3iLKbZtcNNliAr54OPYDizreTGansA5RASnsXZZm1qmc7Z5OyKOZZmugvDG3erBS1ugffCcL6+WL9jxe5fAj9thiE9KxSRGgWbxysmZwALWzdvSALQCDPbp5ye7U+3jiKQyUgIzcMLQbt2BJS7QQe26gH6gyxTHD85llctp1OdyYXQE0GV1aza0DIZPKslrLpKr0qh5rTxYJMeHujqyirOrWQWwZFTkvBdrHp5DSiIEDelqAHqj2if25RCD4EKcNVoeJ5UB20uMaGcr65wY07dS4AMoxYKSPljFLb3Mg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 11:51, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> split_huge_page_to_list_[to_order](), split_huge_page() and
> try_folio_split() return 0 on success and error codes on failure.
> 
> When THP is disabled, these functions return 0 indicating success even
> though an error code should be returned as it is not possible to split a
> folio when THP is disabled.
> 
> Make all these functions return -EINVAL to indicate failure instead of
> 0. As large folios depend on CONFIG_THP, issue warning as this function
> should not be called without a large folio.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


