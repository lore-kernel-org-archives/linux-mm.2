Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B198D41C20
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 11:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70146B0005; Thu, 11 Dec 2025 06:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21AA6B0007; Thu, 11 Dec 2025 06:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936F16B0008; Thu, 11 Dec 2025 06:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82EC76B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:12:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 380EA8B1CE
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:12:32 +0000 (UTC)
X-FDA: 84206926944.11.14BD1EE
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 09DFC40008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:12:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=CNsbfBls;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=daniel@0x0f.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765451550; a=rsa-sha256;
	cv=none;
	b=qa/NfhhlU9jdW8JIf7F4y0DLrxkB8ZL2gZEKqrWO/nivGEtesB9tQD4mZByU+Yk5aouJTJ
	+zGRp0rNIEkORKEppE3HC2qcmigp0MrePogs0Euw84g2pGEPj+mK5QeirmjJBAay71TgKR
	MsS6sg7mWs9VW/n8lcuCE+AzZtkVI2s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=CNsbfBls;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of daniel@0x0f.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=daniel@0x0f.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765451550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIJ+OwSCxLMLJxW00h7agSUYrvMuxXLK+9uVRG184zI=;
	b=kv4yW7gqI7b6z5q/rkpGp1okWmWEf4BWQVTpe+jJwMuml1mT288/HRxR1xe19vdV+sQWWb
	vw4CyQmziPaqyDQuUF41/K5Q7kVTchPg8n/XrGR85OmcwvvIVk9FBVNQD/pz9AObvFJsyM
	I3UifMKSZ19yQmbIPIZrPCVsL+/kmqo=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-298287a26c3so12319475ad.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1765451549; x=1766056349; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EIJ+OwSCxLMLJxW00h7agSUYrvMuxXLK+9uVRG184zI=;
        b=CNsbfBlstKZLD+BYK4WC6qctMDKRr+a2Ig6jebuL9v9Vif1RGg6wreL4UhYpEpqecM
         A2fF6ptGBnVl4vJk7Zr3rcJNY2pb+Ft9QBdUbHRDweBRoL/+tEUC3o9/YPnef/RnH8Xw
         4NK5zldxMwciGzOCINhhRb2EO7MSm23jbMos4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765451549; x=1766056349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIJ+OwSCxLMLJxW00h7agSUYrvMuxXLK+9uVRG184zI=;
        b=jNz5iIslSt55qMRiHZsKuMbRqj9O6i5SENypWx/0nnbQHVkDHBXDw/2jcozEDZhbpc
         3MiQE3xA2tglCHvS6Ut0X5tp5KPrj3AVEncawx/FPw2VIqif5SV9zKa7r6ZEzRH113CR
         rQgBAJrSgkUeJ9PptfCjZJ7kYDM+bTUgwQe+NWfK2Idg4qOZmlBwlSdYqqd0ihx8AmFk
         pjaAn5LK0MM6hamCXKp1WzpDZwFZNNdNBAf9jwz2GzBNmA6b2DADDAxIn5Dd3uv7VOuQ
         mLGODdKiexxOoCiNHUkwH8JqT8pf468AaOwnxYQwEgzEDzbfqSnopG7B0179f5SC+dYq
         DEDg==
X-Forwarded-Encrypted: i=1; AJvYcCVZEGuDA3L3fkkvdBUmF86sEyTClOBQYL22AT0jyZ0I3RmhUdzp8L0xPq1Tk5r6MSpV6qcv9YnEbg==@kvack.org
X-Gm-Message-State: AOJu0YzqsZRq18SoCDNmwL6p90p6Z1N3XGqUnE5HHkTZl/jh+5dTmBgI
	ctOcu2TfBHcVvedr/8SiHU+Bpg2MceXFK/rgeGaJNOoqVX1N9SJfn1Fv/impXRC+upj5oF8PCEA
	Jm55A3DNwRCl+xzbCpmhY8B4z2rZC5U0wvzAmFmDWRw==
X-Gm-Gg: AY/fxX4VN83ht3K7Sf0OD35zqqRPWXNK/xpv8pVAzAi67VntrdPCUTXvqJR8onNTgzs
	le82mQgMjpmT91/HGMAYqSjbaTK1c8xMSCHkKGkhpEu+MYdf+M6++UiwPM/ikmOnGmcaHZxMfk3
	89gnNt/yJVyBmZmxGoonvllpUVlPKdcOmjxj7aBvWqNWTJav9JJrbvt8Izkx1r3I+3HtjZQl8ek
	BF4ZjwjlJJjhZWhY5sonN0Ts68IhdR9tIZv6caUsq20h0VjRWKmDNyBm/jgyEWGi6dqoKVFIO1N
	ag9GzsM=
X-Google-Smtp-Source: AGHT+IF9aDSc4ktnxrr6wArJcgJeUxtbBvszAXsjS3+/3ZAhVbAH3uoya6PbR7LZki8HenZvafT5vM0u8ov6FfkQLp4=
X-Received: by 2002:a17:903:1a23:b0:29e:a615:f509 with SMTP id
 d9443c01a7336-29ec22f0883mr70242795ad.17.1765451548879; Thu, 11 Dec 2025
 03:12:28 -0800 (PST)
MIME-Version: 1.0
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
In-Reply-To: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
From: Daniel Palmer <daniel@0x0f.com>
Date: Thu, 11 Dec 2025 20:12:18 +0900
X-Gm-Features: AQt7F2pjiWEZyxvl20iOM4iIJeABt_nySwUNutYZyMkhTNqx4SiZjDgYKztpZuI
Message-ID: <CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 09DFC40008
X-Stat-Signature: e5ti6zdi9khyipquj7k1i978nhutiuer
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765451549-764868
X-HE-Meta: U2FsdGVkX1/VaS4ZkKEq4l2qnomFcj9vr+pDtxnfRnu4b1Orvwdg153uriCQrCfT6bktSo3yUzDYUUVQUNKJp9wRxPWVBEkuAF78c/+i7iHZfvvupVilShO2DSH649ElQkZdpp+5FfGLYLGO/OaphcDAdCZwbO31J8AoX0hmAlGcPzvznmTbFjqB8NbOGWEUlRC1rr2Srw0rbkH/uKJ65XpYY8uvWnzXn1mzm4xOIarDl+74yV1Op9IXFtbSRPSkl9XoZdcS5uVyZg5LOczO4zdIFIdLCM9AhfnoT26G5NQVGMVghcND+SmIaWK1MUffPO8ZdaPfFWzRTRtYKBHuRq6i/yDvxMUN9W+LlH9DkSeWgly3f2HdhOCdPeX7oMHfs4P29pnWtyUJl0tIZMkaUY5/US/5F9cpkrLS3SxlOFTb36e16mHjHVGaVR4/0zO/3CSVYDdEgAmem5xqtWSjj4YYlD6RbkU/8Tpj6u39ir8laH60pVSbNNvYAWVuIewr7CHhT7HMrdfqd9XluGA504yYkTjFJBqhXojea9Za8RoWjljAef4Utybvs9JfTcSmhq+zvNB9lSw09F5nlGr8eN8ekkOrakyprWBnGbiQnRSGbwi0VdjmtKpUkKLEn6L+EcGK7xCnq104VhzkEmoFlNz5JE2sOSc8MMZjDDoXMaVFkxcMKL7gRkKAbWWfhR0qW7lXulCEUhqMHwYQ5WZXANu/1mbHmfC0Os2xfLZsr8LzPGxZk4dAS8YpZApj2KmvziSJpxcF4V/hdjOSxZugnFSBTbrTKz39qZ4y1uarE91IOpWMrzez8jUIriFqw6Xj+g1rkysbLXtzaHRZI+JdC3NC4OQCZICPxsy1G7ftX3DRTrM3MxPvZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Thu, 4 Dec 2025 at 14:29, Andrew Morton <akpm@linux-foundation.org> wrote:
>       mm/page_alloc: prevent reporting pcp->batch = 0

I think, maybe, the following part of this patch broke nommu.

-       new_batch = max(1, zone_batchsize(zone));
+       new_batch = zone_batchsize(zone);

Before this change on nommu zone_batchsize() returns 0 but the max()
changes it to 1. Now it'll stay as 0 and anywhere that depends on it
not being 0 won't work?

I'm seeing a deadlock on nommu:

https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/

Thanks,

Daniel

