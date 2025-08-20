Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2B6CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 18:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7EB8E0028; Wed, 20 Aug 2025 14:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A93C8E000B; Wed, 20 Aug 2025 14:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEDF8E0028; Wed, 20 Aug 2025 14:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5948E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:17:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20CED117BF8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:17:47 +0000 (UTC)
X-FDA: 83797944174.10.0C51971
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 694104000F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:17:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GWir05qo;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755713865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5Bk5OxkSMuiaobpiDeJJlqEjFgZoPv4eljrayG064o=;
	b=vdnsTfLhz+oy/RFQyitvh74WEOB0KeLFogTdPqqVirq1XoxUVJvrDvtDWYhM7vzQdmtp+y
	M0Rr66X5UApTV1BWkyuT9XNc3lKDN5aZUfpdEBCQNHEOCfu22aXArxBhpl3qGeAv7ssjBz
	IrlHLZo1EBlgG3495bgF3PhSdXKJOlA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755713865; a=rsa-sha256;
	cv=none;
	b=EJLnKL8EptUAW1W4+dg2bGKFR4XqNuhG8p7rdRICi3Z5OaMHRp7g8ETg3d3ehW8KoSofMG
	7Ja1tZR2qwhnw3LFUfHRr3vPF+MjgZPBosDIsK+S2hxFfYO0wLbxLn2EPsbQJg1ZbJY3lB
	KKvRN5ki2Xe/c8EllUA2S37c4FCk85w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GWir05qo;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-435de8160dbso77552b6e.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755713864; x=1756318664; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5Bk5OxkSMuiaobpiDeJJlqEjFgZoPv4eljrayG064o=;
        b=GWir05qoQyLty3KoUCzUusopAQI/hNfLVWsqvf31a2AhrP6fiuKnGIRhN4dLrOipVr
         +0X66Mq2cM3vKO41LDdjXpoFGp54ntLMLlJmSftL6LtiUeKmMo5vb/qt+nyfj2EVpWOw
         rBwDOjoCvPRBFvwfRES/q9NQbBjHqVCrnYA/3PTBSE5SGYblxoFXaXgDXovIdmp04gOB
         pxP1u8s5L+E+K9PVNcSzCTBjHnmAi4YU166Zp/V5Wm45lQa+NcOHsqONgrSsfLRQgJnZ
         DxVuarTUvHfRKMSXPRr+Gmqb/Wmn8GbRKeZjPr8rzq62SdGiNpfLEBBGcBzWxO05VQoi
         H8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755713864; x=1756318664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5Bk5OxkSMuiaobpiDeJJlqEjFgZoPv4eljrayG064o=;
        b=TJVCnr2bTpq+4/xsG2TPcGCoB14BzerAGsgBk9AnDdqARvAGG7BHCnjs7lG4ViZU2U
         afjN0xFOxbsUSlyjo1FrrpkjolIB4cnydWbhvjb8LlmKz7rZYujsGAqOvJyiBWc0KWm4
         aTTwrJA1OEdQkCLNVZprQVTv/rnqX5eGy63KIbIpRd8QCcZM9IyP/uUo/pv7K2J8zJrN
         c2l6sTCK4085Ed1Ste6X2a5PwSJ8Lx6jN9nZdzhBHcp/Ws9529P2lNNXns75R6m++hAN
         Zs7F7b4ciMxPeGVXLejJ8QXSPyFn8v0RlTDpqvkMKikyhOFdXmp8Kd0Czbqel4JNZZfH
         BXyg==
X-Forwarded-Encrypted: i=1; AJvYcCXcCy6aw3okiVzXg4hN++mCS3I8Zf/J1493J4fuE55NalVXuGhfldwqYJSxg5pRqA2NSgQk4nVqCw==@kvack.org
X-Gm-Message-State: AOJu0Yza4s1OmjMVlPOC0OASWMSYzcMXMXDS0qJyPI5Lc/ACRQIFgAjF
	kF8TDB5a+3q7kbPx3jLVzhMRs2TGX9aK3twnzCDgtBLUDHU1J2U8HlWRf1v1Ros7NfdTUbDNa8z
	vcqp3m8AqJYYfrb95jxoQAmMcDKOv+ug=
X-Gm-Gg: ASbGncu3iVNntKPGQkZkU5kuG5zK2frt3OlrV4mH078QO27/Fdyx0J/XkDb63+QJQsJ
	/D0Xw9B3b8ZIC2aHqjKd/JBgRQ42Ig8SWFIAb8zL8ee4aFlWNDIh9LvaESJ5/dOPyKqzf1tdWmu
	ZmYKsGWmWw9aodg+19YEGd/vkqvMux6ywN5B2ieKF2EfIj0fV5DUqBJ2I/I/n04pYh+rSeRa4C8
	ZFD
X-Google-Smtp-Source: AGHT+IEH/Svh5byZgF0lg0UtvV4QpwF3FhMZi3CbAiWHOFHIihgLFfGRk4aTulk8olNPXy/a7SRMpJ9JzsFf3U1sEoo=
X-Received: by 2002:a05:6808:8019:b0:437:761b:dd0 with SMTP id
 5614622812f47-437761b1229mr662154b6e.47.1755713864303; Wed, 20 Aug 2025
 11:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250820181547.3794167-1-nphamcs@gmail.com>
In-Reply-To: <20250820181547.3794167-1-nphamcs@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 20 Aug 2025 11:17:33 -0700
X-Gm-Features: Ac12FXwSq2-tyJGkbLsieRu6fWZxzHdU51wsdwtJjSvt8fXzTPagLi-PWpP_Nhg
Message-ID: <CAKEwX=Mq=EtxhnKhNQ7ZdK18wU9hPEarLR1NhsgB3hm6G-GRkw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: reduce the size of the compression buffer to a
 single page
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev, 
	herbert@gondor.apana.org.au, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 694104000F
X-Stat-Signature: qj5opc3nnouc8prg7p1gpg6sbnu8t69m
X-Rspam-User: 
X-HE-Tag: 1755713865-149805
X-HE-Meta: U2FsdGVkX19U4gsmDa/cSibZdXkq0xpoYfNU7qWTd+mgpmirfdw+r4/E2OOB4fzzVHfYMs3DFsf/DJBYU0ZeA6iPuLKWieDBaUlqu2g1f0I6bg1jpEQKp58txfNyGYWP5g6xyVoxgVP7Cgb1+/fztkCs1vl2nwB3nvNTNkYZGH1pYPVrMwZI/2bh02AlIeHNVuyA1g86C5WstwKxA6hBNQ3YUntGitzW069wvTT/LPgf4f7LwRAG+3P0KVVwCXEe3xazROPyCJJMd3c3Zii5HGkEGZ5y8cR5tj6HbGcNPPM7U64j+5ui8nzU5uBcKZGjAVQe6+BgHgVEk/6OuQ5uMjG62w/aHk4hpxzKJBheCiNoyDIkJu23dy76tyBY6VRX6qHIk1GeeAhQ19n2tQ6tS22jGYmQ0UYD9QnKFd926H/eF9u28IOgHhPqFWjlJyuFeffMNfKBQhuGQyZLkyAy8JK/2FO8ToqaGNiYWSQnJ947wPawVGfICxUG3Q70ApOjuaLeHUdK/wUbC1nRvXtSSq7eUeS22r1BB+xHURpPU20qcQeJCK0lLnpWzO+Jt5bZkes+JGnuV1GcgXASwbF/NGqjBNGzRudnDmjgbB/un7JM6Saz6wUzPBlm1+tban25rkHQMhixoM4eIhMhCPQhv7K9cXv0W22Em1z3orSIlCvmAMTYaPRUrj6L4urV28QZU343faINWtyxvBkNxKdhMboZ8FA0xiQ6lHa0dAkDXq3hBaMyueiuZWtpasPV2Xyn6to8CnjzMpaftGawlP8en59lQ42PQXuBr6cVFhReUA13N4tcv7NC6uuocYSwumNvH2KS7iomaxQOklyHwGqdbdajXN+OqZMh8zgSJNYkIgtdriP/qtBbDQZFoSnYHXIvXOnMT1QDJ5s/9jwW1jSox0BgptFCQLqzRTJuVaoxvNcJ/9XxlA79YYAUdFKS9CRzWBrLeHieTFLQKlj4mOr
 Bmdf5ZQw
 rCw6fa+BQidMPoLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 11:15=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> Reduce the compression buffer size from 2 * PAGE_SIZE to only one page,
> as the compression output (in the success case) should not exceed the
> length of the input.
>
> In the past, Chengming tried to reduce the compression buffer size, but
> ran into issues with the LZO algorithm (see [2]). Herbert Xu reported
> that the issue has been fixed (see [3]). Now we should have the
> guarantee that compressors' output should not exceed one page in the
> success case, and the algorithm will just report failure otherwise.
>
> With this patch, we save one page per cpu (per compression algorithm).
>
> [1]: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b059=
dd89@bytedance.com/
> [2]: https://lore.kernel.org/lkml/0000000000000b05cd060d6b5511@google.com=
/
> [3]: https://lore.kernel.org/linux-mm/aKUmyl5gUFCdXGn-@gondor.apana.org.a=
u/
>
> Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
> Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>

The syntax changes very slightly, but this is functionally the same
patch as Chengming's. So I'm keeping all of his credit - please let me
know if I miss any proper accreditations. :)

