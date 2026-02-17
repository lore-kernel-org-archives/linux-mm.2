Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A23E9A047
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3986B008A; Tue, 17 Feb 2026 15:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB0B6B0099; Tue, 17 Feb 2026 15:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7166B009D; Tue, 17 Feb 2026 15:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 499BD6B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:10:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AD3F140336
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:10:54 +0000 (UTC)
X-FDA: 84455042028.23.FD8940E
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECB53A000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:10:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RjZQsJvt;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8wZwHmNQIZLlHJEiaGYdTU4Y6mb3G8vQGhckq2Z10k=;
	b=LShlpPLg1ILNts6HRkA2FTrTbdvFqw7WDahlJ2l9PN3WT4tE0dSjTLAgbFS/Q3t14yV2EQ
	C2TeJwmKPz2AL0Q/4lRxLWRl32MsT5yyPPT+0GsV+zr5tndgDWCtAJChKyPYEo9LqhvNer
	p+ZnCm5sbb5dCLvZ9O+uKTHjHuokGdo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RjZQsJvt;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359052; a=rsa-sha256;
	cv=pass;
	b=MypnbnJu5T0y7P910XY65o1V79twE6kssrt+qUJ18s7cjWiSyecAZXbGIAOa7UWUrRS53Z
	uHbXuxTZ1brY7xWsjnL4Qa46WMNr/XijxocgmjIJURA5H39Vsqi5EBXu8b+lCWLYBKCGSW
	fY7A1ZqxEhNCI3xYfuWfI/8nL0e1sK0=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so771999166b.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:10:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359050; cv=none;
        d=google.com; s=arc-20240605;
        b=Rh5KA7dUzGEms7q3L1Yw4EsYx5hMdid8n7A03WtwQj42NTFNl17GXUYghWy8k4K6MR
         0F9NfVM8csRxI8gDn2jhioo8p94MzD01M1cJdwZ3q88VI6BlhSAy93VmnCejnAB1VQKa
         L34cgLAAqUXnDN4Tf9NPhCooF7ns2Rsr+pxT7WszX6GMK1Dh18zXnuNxoq90zwvQDR6q
         KKQgTkXHwQNZke6Nkn8yYmq8Ffqr+UYEm5HInqizzeNSnD+kOPFBmVvGX5MwdWNI7q6E
         /EzW75AkuKeTMSVCiPGsJwgOz8z31Q7A/LPieoT91NEWXXVpd8yhzKGRvo7eDv/1UlOl
         883A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+8wZwHmNQIZLlHJEiaGYdTU4Y6mb3G8vQGhckq2Z10k=;
        fh=8ByMU6S8ziE9bMGA2Lcl+HnOSKkN+zIbYXN5GD8lq2I=;
        b=eIYEb8vL4UmR/n0FwA6TqIGzFDiaRv0JAGHBJo//c33I+RbbizH7MOcsTYntiKus2+
         eRQAmmTArBfV5wp7IcX6XTbO8/3YIy3NQODMlY0+5pDyRwci2Db6kIlWDoOgL8woXD1Q
         ANzIia0WNDVqej3pLAPCjU0hTNFaoMvbXR8YES/DivrOUhF+nkHr9MXYNGPGpF2363kD
         Gfd0m8J1La44IC6MpNX53CKwka3yTQNu+gnUgp17N0Xj56oCl2djNigNLrRYB6ui/7lJ
         0ZeKw2YzZ83UFmR4Uk7pxqtfvZImmeHANAMJZKwY7n/KKVVLT8jkk6vMWVcx5nGCZWmj
         GONg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771359050; x=1771963850; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+8wZwHmNQIZLlHJEiaGYdTU4Y6mb3G8vQGhckq2Z10k=;
        b=RjZQsJvtf9PjBiq/VX9Tz5MMZkjUAb+N0U5T/NELNXS+f2iLwvSIaZFuL3vRhngx92
         TSTO8wlvJrUmmqq+aXxKNQ0miIU/KmKkgfXbctNDTN8q7U13OFQkxfbA/UDKgX6xb4wk
         eMGce/l+Mi0NR6NRD4uDbKjxVdiyQ3JaSeAQI5eDEPhSnMw7Rjdlc2LRuLyXLxKtbqzC
         jaAQ8jyQ2+sCg24mtcTpObxSfSirs1m9uCuUzuaXdURRyaaCZm38rLz/bbx+I2tSlrFM
         7BVGUUxCpprUTFqSAshAItn9L+y3AGkQHdrwcTopIWqSgc2SQp5BJu8qesunE9/1ysjs
         JdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359050; x=1771963850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+8wZwHmNQIZLlHJEiaGYdTU4Y6mb3G8vQGhckq2Z10k=;
        b=UEww4TFqG/3SX410PBYfxzkE/HVBQp7vDq18re4wcNOW8LuAxTvWQUb8a4yNd2xqLH
         BFz3wPRNHq1APngtCerkheIAoDFpTZgT6UX7Qk8Y4FQd048e/pqhkUFwJQkw9n3roRla
         KXzCiBpqV2DsWjPeTYsBVOjKQDliKOsfaGxk7WrXc+gi7GaUZ5ZIF3K0NYZK4Gg4bUUs
         BWzcykxQ8XB78ToQ7cUrOMXWnC8Kq+4vrJHXguM1j8yIxxzUxbI4xR+uL2AxpwyiQZh9
         2XcmsWz0Bggpk0Jbp+t9zcwbRAOCOSBR9BslEfESyFsCQ4p2u/2oi2N2Xk4gL9v/L98z
         aGGg==
X-Gm-Message-State: AOJu0Yxy3VuMcXm6O/Wr/KwFlvJ5f+mUtH+pBHBhrYP+MIrJp1/dK13l
	SVQlwzYMfFmH5yxxgGi6G7/9sKiuw330BMHjEvU4SGefIcWxWnUjDIAEarkCmh5wfIyVc0LdFI1
	94K27JaSn3ZWd/ApM77qkYRxWy6lhbSc=
X-Gm-Gg: AZuq6aIr8brWAjhZgFDYL4GZIYvfz39AJnLaF1GGrjdcPqwkQ8kS0b8KEjgcrAkdnTN
	XfPC+vP1wfr0mC1i7/4N8rvBqaF8ygxmQpmaXBxaI+BHY8xNDfXVz1OlcEOLyE07lRubwYeRjQm
	bjZxzMNX4tIT05x5UMin3uXBY6ui2lPQIesjoXQWhrE3E2m+hN1SmVOQrzvVrcAzkgdpBLOia6y
	GY3X8LqRNP23ASIsAmhgfSjUAOW29whwpSGSLIB6zjUwaRJIzlR/LTAzxm3bGP5DUxSp8yi9giZ
	OlT8IS/xcBVOVmwLOhilW4qCHVmcS+aYZaNsZwRP
X-Received: by 2002:a17:907:e107:b0:b87:2fc3:3c72 with SMTP id
 a640c23a62f3a-b8fb44631e2mr605997866b.39.1771359049884; Tue, 17 Feb 2026
 12:10:49 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Feb 2026 04:10:13 +0800
X-Gm-Features: AaiRm52bpUdPaYkKbkJF5CuGdVtlehcDQNGYEBKKTMz2_-qo37WFAwZeVrhUxgE
Message-ID: <CAMgjq7DGte_-wBsvcCF6rjrbBMW69uzKT9qShKhswd7ZhAKUBA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm, swap: swap table phase III: remove swap_map
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ECB53A000C
X-Stat-Signature: 7hk83khwh8ss85enzg79m37bjmntqsna
X-HE-Tag: 1771359051-976127
X-HE-Meta: U2FsdGVkX1/IZERuMQKuREL9TzrZQf4QU2Xwksz1oxejUtmz9Sqo0rjBKr5DNMKMZgLjKUcxk7Y4HEXFskQvVGmr67Tw1ixl2mXmrtftyE0R58ojNefvBCYpFtRgXI7ghiciebCdFbipVOreapeVRHzvgipi5H/Dnu4Rq6gIpC5sXi0T9yjO6QBDtFZYCU5lImF75evnIezsu2yyOVSX2C2QqPa0HsONBNuhsrGmcQh5WKOTXrkEphAyNP6dy+mM0XNJqWVnRGH1aUNubGGgVlLZKt7ZaQvOwSR6mUILBPyDOlpzaRYm4VOcAxCT9YHLdkw5imwkO/dvFKPdygY4PI4MaPDujVyuk/NjokWVWz3FehL87tw+YjGIMR5wrQ8V1GKDRQYDQ9mVU6xq78LVbRdSoWeJzkEFX5Lf1mZK6ttofKqwbfxgc60o+wpX/dLXX96IstEo/Qz9Ao1W3FE0+vL17XnD7Wga3A2fZ0PfIG8noXXDGVyUHrPOCT6ufZMQyE7+3762uvfHZGEWB4IJK/XEhSb4QtVM5812edcw6uSEYBTuvejO5tBcHQQbWNFdzXyxesWn4MyFr0xeYMmP5x1Yii2rzG7snKFeqONvLGdcymMx8ckIP68MKmKk/eB9iYSdyf8/RSyB0TCx04xGJRxonBz1M678LvmWRXVAPmnwrJbHlvxkP0fFRxgc3C6/byWTsl7Ocl1VRs9GEAAixhl4oZFLs7JUSO07zowgKPCKutUB8Y9oFuyOPdDgwT5k0KCFW1frBv13DnMBD0DLiwnArv85lm61Elx14oenSTjenS7zSwU1o9yuPHJ0yBfDa9h9QwRKhYGVUFar1uAtVCNGESZTRqOchkfUqvRVQLG/tGAG8Cgf/WZcEFC+p8+rGw78jGD14AOKBrP6UKu3fFWE4gXfvKdekR51qHFakn9Jv0/q+POJAXOz93X4XvV5B6O8d0EIkGndF0/sC9G
 M8/VyIZ6
 e/PdWX+h+kYjvT/MRxuEJusjc6b2Zw3g+zZAuW+7vHAclFqMayz1DcLFpCtkFd5ATNkafvJJmZzyqfNCpy0IEdlvqfrzSEXjQImfoaTi8ez/3b2lgaY3p1rC4phYlPDD+9UCdcrqKC4IZRH03rm9kbvam/Pz/P6QjPv4B0mDVoYgicz4nV7N2Fay5MIHN6jCCdUVxBX45m4uM54CJjkhvptVJIOWoWsJAcKLSjQ9NdGjebQYRRQlc/VrnxztLLqc1T4vdtoz4Lq2Ug3jqatvpDAwR97sIV5KrELSGLMmbgi1eCALdhIxTKWmwBKEYGG2qRSbiQayQcOUwJziGM7PiKPZ9NBZTCQhuB0e8TsbaTJsjUnvy0MrsRqhM3rS4JgXOoZl0U226DN+gU2KyhWMLuMkWvHp+yTEFeiR175kQE9S5rAR4g7+2pQkiqPD3rYaGCO4h8ZPVCEs2YSagdX3/nNz7j4t7jVu36UfJoTW6UWhdCdTD4GKZzJBToQEqbLl7A9fqWnsunJ1kE+65z79mb3IxhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000053, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 4:07=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> This series is based on phase II which is still in mm-unstable.

Correction: It's based on mm-unstable, but phase II is already in
mm-stable. Sorry for the confusion.

It's also mergeable for mm-new, tested with no conflict.

