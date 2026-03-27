Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2456D10BA437
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB536B00BE; Fri, 27 Mar 2026 04:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2066B00BF; Fri, 27 Mar 2026 04:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B80F6B00C0; Fri, 27 Mar 2026 04:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 699D06B00BE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:07:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D5E7140FBE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:07:36 +0000 (UTC)
X-FDA: 84591113712.10.7E182B7
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 32F451C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:07:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0c9PA0v;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774598854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVfFAtvOjT/QY/G+zbXJh5l3DQTsEAM4O7UyelDmPk8=;
	b=4Dcs3F54Kpct/2fNnxTMcytjCsY3tHY8nYs+pIdFwq8aJfheNv8C5R6L1oic5ZP0CQSvBM
	v+PxrAnm7zyaprZSB3Q9PtpMhq2O05udoo1Up7q9nTi5JfugWh63OpxaXuEk+XQjxILJGg
	mRt2F+6mJgusQpQ66BtITnq80XK0k74=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0c9PA0v;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774598854; a=rsa-sha256;
	cv=pass;
	b=FmyLf1iGv5AUzPNlfINgD2j3jtORHHOmJuB/a91FnWE30/EUE88O0SDGcmMtyCKQ1Jd/DV
	vYwNzTs+jIkupXdzPBAZrE2VtI5RZg4eVkGc2awSdxPnuY5JSJVhm+OySkpQfFp5kI/0v3
	BIGjcIWoIE6SBw6KBsQR3NWLNaNgaUg=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d77b179b52so1667093a34.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774598853; cv=none;
        d=google.com; s=arc-20240605;
        b=GzNyZD1oiVkP2Utlb7N6mGR31bXUQLK+5QxPeQyKlaLh3aOYMhydf1bmbkcQpcdOU4
         NEV+RSf54mP8YQJD8iKIdv0LNgEkdo4OerOrhHwqyfycReDOI/ht5zz9ldJH34XBK4Rx
         KRFjXyWxnV5GBosnbkv+rGlvPIxWGQUN2JUm27LLrjnduSQy2WWRoo3Sya0hRv12UPUt
         GPAcraZ9EYBmd1pxb/u/83rhtVRh7XrQBwk4UmBYREBvpMYygrPS2zDXCTMLfKaTu1SK
         bC44s3A0d9mnV0QUvyrGKI0QrXF5XjXprWMWxZej1BgR/Q2aWs+QExBEL4yH1FV9lP3i
         YZHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KVfFAtvOjT/QY/G+zbXJh5l3DQTsEAM4O7UyelDmPk8=;
        fh=NbvRQ+WeUGi4gFtHxExWwrmPtK2pvP8wXkes7HjNOLA=;
        b=ObcSp7nwKTqWCQ/g0x2V7WV98QZDymsAkmehX4zANTOVB3I32E6GSqS8ib2Lf4tdik
         TtU/PVqLncZG8SUthzJERtEV1iEolq6ch5LXEtPmh2bVdV8PpyO1YzsTtK+uVaJeGFcB
         48Kf7WyF+Jq62B3cUKJb7ZTpY9y5FP/r6N7IqonRWBYewdacTO+Ius9LsjyHol/cjoMz
         lhJGJPwF4CB/7YGleWSaDeHdfO/A/0hk1kJ+0GeMhTI+Z044c9L/cgFkgAtyZqeVldz4
         owJ2BvvsXekCcK74mC/87tAD/xl3v0B9dzdt+KGMNQIlk1x22htmWY0Y5Sdl2tmwZiLM
         5kfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774598853; x=1775203653; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVfFAtvOjT/QY/G+zbXJh5l3DQTsEAM4O7UyelDmPk8=;
        b=b0c9PA0vvt8fzrrDDPFoCHkvqU4mE1zE+9X5bv8seWqaHRo7Qpy0u8AhTZpV2FZIt5
         qIVjcnaogx8eQwOfIW9yF5fiYJaIx5NazCmVIouI18fJkdQzNNfPJbnBmkQnuIhUTGx5
         hBWs+KcLUlRRi8ZCu8Y05T3BHyyhAXKpxmK0pYIcDgyBH840KsQsFsuQ3pnNRSwBCIJx
         KodXQN++olfpUB2SWqrWbMeCUOsLAQjN8EKHQXl7uIFKGZvjUS6cF8xrxqvbZsThIvwX
         ouA2b/c3MGIpxSK42xaUAkIUWH79jX/s18FGcsnjXVmKr9o62oRo7gNfmYVnEuuV9Mry
         W6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774598853; x=1775203653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KVfFAtvOjT/QY/G+zbXJh5l3DQTsEAM4O7UyelDmPk8=;
        b=ZCuyB6c7+rMte8rS6HIwEJTgIliAUBLm41PAm6UlQRjOT9oCw0vB5+oIS9mOWMgq0E
         0X70NKUU8AFx9VH1FFxqUpmpH51y8I+2qUSlBJZknyUNBo2z7QHrdNCwGMSNMfujQV39
         4OKnDFkEG16zVo3xUmoctcWcYQVctfzYkv4MxqHJVCFvakGgP4xvpkNHYeExrf9mqk59
         Xc8ht1R9XX997aGirX1dHbb9xwN6lRyQbatxMp2tKDZepfh313+4a4jThUSHJI16jKMM
         cL1qkllMgElRh448U+EzcVGTm7Tw84xLRRHs32kRmEg1ps9a7/KWJ/K3s0bVHv5YmvEi
         IL+w==
X-Forwarded-Encrypted: i=1; AJvYcCXyWA9RPL/SrDEPladtQMRqcCiYVhwyCmlFxJbGUsjEc9PY6lnYl00qUEevvt+nWWIL25GYctKsPw==@kvack.org
X-Gm-Message-State: AOJu0Yzu0Gu0EFuFQKfdxvcAoq0oh6rX06fJaS0Byy8ROMnxEktxdme3
	7tvwHwPQ6sfT0UnPT6+0i7wKF9TEYm0Wj3eYt1FAe3EFTtNxZsh0YB6JGGXYjLgylxcy/ZR6mM/
	ESl48Y4EiirWQeTzG2ATFXuu7OEnR/Qc=
X-Gm-Gg: ATEYQzxtJODoc3p5wTIpj461WwwT5B6ld+0wHZbQckg6udltlLNwv10trMVWQGQteR3
	x13lXGQcXaqeSRPpiEi1PbcYL8UdWymEEaVaBNoL8LlFM1xi3FjJcs/Dvq44Cu4OmEkPehn+T+r
	dDOGTWAqCffoLJm3Y1EvSqm9XD1OnmqTdCHtljXqgRlMBugGScyxTh9HVVHvzACA5ecB3DznBx6
	/71AheyqdefQRRMYOBToEOzS5b/Uu2sB9iq9OSnGSirfk1W2dJVjECZJCfjJbaR0QhJNUnIspV8
	gTjLfmE=
X-Received: by 2002:a05:6830:67cb:b0:7d7:4e62:58d2 with SMTP id
 46e09a7af769-7d9fad9248bmr731336a34.7.1774598853157; Fri, 27 Mar 2026
 01:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <acYlxRBhSMcwBnja@hyeyoo> <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
 <acY5G-lKZQEsUbRw@hyeyoo>
In-Reply-To: <acY5G-lKZQEsUbRw@hyeyoo>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 27 Mar 2026 13:07:21 +0500
X-Gm-Features: AQROBzCzB3coDtODs6w7gt0-QdNGc5pwWqkx1wDss66ksHdICPpNIJLEWH3TZ30
Message-ID: <CABXGCsPQo=Npum2aHet3QkZWkWEnEVMAw0KQ1AHPrNjMn=9bmA@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	stern@rowland.harvard.edu, linux@roeck-us.net, andy.shevchenko@gmail.com, 
	hch@lst.de, Jeff.kirsher@gmail.com, Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: hju5keo1396m6mk81swm9ye9hydcunjr
X-Rspamd-Queue-Id: 32F451C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774598854-720095
X-HE-Meta: U2FsdGVkX1/4s5rQkjbN0bWo75vvSvPsdTo0EpLLH93VI/PBX5g3VWvw4cQl/FObGV0K+fAzE3AbVFTu6a8y6JDxMMRcosN3+7Q1sDjs276aWrlJOjaQ9eBYk3kBePgtJ3Z2p9xHG76XPJKYQfYJALWSNiO8nHoI3Hx6Rc8XtoN9fhCV/y46d2zP/1KBCM3aMQR2Kw2euFVyiTl+Thy08QcQ+fOydReJMXQjQfK7RdrsuzQD0e6b2VYrCQBlwgkCrhgBq8Q9KmvkYqhQJecTGBCmVt7hiPSqy/9a/zvDoUmAnneg9bszIRmSAkTBf8OEB/e9oQKhuwUwyP8ZodfNNhkuriMg2o5w56UNLLzBVhidzkF6IUMCo9XTYHhxSMAl9nS+nKKu/FqAG/6wE9SRKA6vGjtORUf0pCr3CZxK/3ZZUhUok0fOEUvtwvQfO8tVcY1lyZaCeDGH7io+isoiePpPTW5JO+QPmMRk6oOHuXpJ7D0hNa68ijIJ5NeqktDe6BFE4z2FyTseExwXo5gDq8ZgK7wXeAsU8oc0olJbvEQK1R0jkAcjgY6vhG3yZXKHe5C4CWHvOwxMJo/dh+AJWnabogCXA6/iUaB0HspuxAJrlpYOvThgMtGyi91SjzZT7PJqzqT3gVMdHXPzbVHy/tH67smVGQwDHdw9HY2Y4o1K8rBvxrSZXNaX5H8QI2ZWvY3lb7KH9v958nF+HzrviQNLW3Jw1OM4rsWgmFwokarguaLeiEDfjYWHBzZ8dp6kvMCYJrieqJW27S1x2ZQ5a21O9PWTeFqzkfJD/+zriiICLZXCer2bUKcE6GWxFtaVMFV9nzewWDofDmpMHvueitKcHJpK87oFIjorqP0+7lCQVbnDzyOQQ4SNtGDe2itNNM0JMzT/O1cLnmkmXVX7L/e2RBLcAYzuU+R3jIZjqBk1dmpE9kUY//PKjlNZlvNRJMbKMStefj7A8ifChlS
 6XWv4Tdm
 Wj7ktpI/AMU+su2brV++zyPjNB+WjiBZN3j0k+oZeEID1cYm77kSAAEnYTaDYX59OwzEhHMrKh59OCL6xnUL2mCtfdTQp6EExtKKD8qncZLpOeGN1sj3v+CJIXwwNsdlAbJ2X0Tx0lSmXMp9LRv++IWXb6Aw6he/Tu6eP85M04zB1ZdjNPmEVQIv0M4QSIxK/A31aYauQ7Gf+hJg61LXuReOCLCCe0xAbCVItK405KAIE5jZarMA+EKfI0K0t9JeA460hAFri8mtqHIK7b3enoe8FhIIKmD2xkosusD43EhQiz3FQUe6njquLMwR0sRAofgMbreZUmKyAicMiAaYj/LKBEnCfFhPRPA9sAYbkWzGZoVIBoreBjbq7/CJ2EoRi77/epieiaQoMgeOnKPHHikvJEH8LC3HgmKsjjsvHRJY2f6WBYylxjUZ5JNqaPG6wn5dDQ7P6QTG1SQFThQ94s4UD5ZwyPFrZLIQfdrbQ/tQe4h0J5r6cBIcqQM6ljFjSCYIEtSuEwSv3m78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 1:00=E2=80=AFPM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> But dma_get_cache_alignment() < L1_CACHE_BYTES means the architecture
> actually allows overlapping cachelines, no?

Hi Harry,

On x86_64, dma_get_cache_alignment() returns L1_CACHE_BYTES (both
are 64).  The condition (dma_get_cache_alignment() < L1_CACHE_BYTES)
would be false, so the check wouldn't suppress the warning.

The problem isn't that the architecture allows overlapping -- it's
that kmalloc returns 8-byte aligned buffers that happen to land in
the same 64-byte cacheline.  The DMA debug code correctly identifies
that two DMA mappings share a cacheline, but on coherent platforms
this is harmless.

Adding a dev_is_dma_coherent() check in dma-debug would fix x86 but
would also silence the warning for any coherent device, including
ones behind IOMMUs that might have non-coherent paths.  That's why
Alan's conclusion was that fixing the allocator side is safer --
it doesn't weaken any debug checks, it just ensures the situation
never arises.

--=20
Best Regards,
Mike Gavrilov.

