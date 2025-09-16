Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D498FCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14108E0014; Tue, 16 Sep 2025 05:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBA78E0001; Tue, 16 Sep 2025 05:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D280E8E0014; Tue, 16 Sep 2025 05:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0B308E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:35:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 727F55BC3F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:35:36 +0000 (UTC)
X-FDA: 83894605872.09.1A8F794
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4B1F14000B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:35:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y7fKK+B0;
	spf=pass (imf23.hostedemail.com: domain of glider@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758015334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItFEEUKNnd6JDkvIGqIsrhAmf5lSlmXXN6ieayVKa88=;
	b=HNIsCWcoaH86rFBJWJP5yAVtQbofSpvsSkuOKe1sLUco52oadQ39KZPYGPpk7+VYr1vB+Z
	7LMmPqD8gKNT6wRE8NOTZUGzepkx/+KeCpppdeeY+zyILslbFxIatxVnK53fRL/AEA1mlv
	RAQ0UZg63PovGrqZz8xzYJUhvhSJ6ZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758015334; a=rsa-sha256;
	cv=none;
	b=ebsrdjrV1oRb71+bIZ7WlKrmYVYqhs7GH5ULXd0D/XgpXbMH3d3l7bdcwDJ5j7H3gO22jw
	PKKdrBJWsTnY/K5qQafjVbQjTu7bMPuFedSc7oq06m4avC94N3pnEaJkS+bDvChdEv5tiz
	W/sOT1KEd8xhrlR3sS0iPUOyNpzc680=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y7fKK+B0;
	spf=pass (imf23.hostedemail.com: domain of glider@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b79773a389so24154201cf.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758015334; x=1758620134; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItFEEUKNnd6JDkvIGqIsrhAmf5lSlmXXN6ieayVKa88=;
        b=y7fKK+B0OY5jXCaFjPSIzHTw6Q/99jLz4ghHOxl0whtb/wVDo8qahMtmK8t9XupfM2
         2swNcEQsRzEB39W/JDvmiScZz+e/hzdI62WtG/myFqBHFFcf58j+/X/flV0pYvBmj6Gw
         3PQPJJw/AItt008t1rrgo0sog30FAEp2Xj0LJr9f3w6u8yQgG+xXMb4s5dbdY8W+lQUF
         ZPTjYMPvqX7z8qfUa9Dp8EuPd7QNTRx1BsJT/fxfAZUsjAzRNh397QSiS2aQOeURpBfg
         Tr7ReDrIxm9x1GDnjrKccuF7qG9LZyhU5gCXwLaqU8DmoI+0O9nKqFDGZBT1go2P4X4U
         jVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758015334; x=1758620134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ItFEEUKNnd6JDkvIGqIsrhAmf5lSlmXXN6ieayVKa88=;
        b=nr5u9jDG/2l7tXIY+rT9xWehu7AbSZlYwafPwnNnqLgXZG3Cc6zVm+eieM4EUigHYf
         SnlzH1g/vUXu3cxaHs0p7zHlMSuduwYec1bOqCojDk12Cf9lzklcSGq7bPy0vAzJ6RP3
         IDq7yzQhj4wR8nD1+1nDV5NKPMsy7lphWxr0tMlpHvLrUpQ4W6yPkQFQco95xrDXx07b
         0bKSHuv2ptFm2XD4awx6e6mrJZR1iDV1NM69DqB+9sIMFM/jj/qsQ4AA56EOV+IJLgC2
         aa7p9iIW29ZqSV8BltDOJao28QuxRuP0ZECc18FoQF5fAAcCJZ3G7H/O9vCsoRHLQbq6
         2+6g==
X-Forwarded-Encrypted: i=1; AJvYcCWjO8QEw6pqCZMsdp9BtsQkXWvJEulcYoFLul+pGTYOO41VZT6giUa/KQC02wA3hYenVM9rmJR1WQ==@kvack.org
X-Gm-Message-State: AOJu0YxGlx+c6vyOTsKoP2t6qS03aqXx2jOPFXCUTbhmEZTmt6fF11vB
	Ctpp6cqJMR4BmAye7r9XVbpKsDbPl5HWx7wm6UYY6Izql0nFIwpBC9ANzDxGTHr7NlQXPdw81gF
	NDALbFtGdX1BObp5cLHYGeS8q9zuUDg8c8Kk8J8/L
X-Gm-Gg: ASbGncteHJltrwnojTtmZkVTOLrFSmrLHo4gp50VrbGMPmZ/3PejqYE1K/tiqAtQwJ+
	/D+JdLrElx1KNWNuc/wN+V4KoowD1tGkL5c0Xxo+uNHCClIcX7sdG5cHwHVk8OuVWy9EXCvpe/P
	sw17dacPnLxdyCh8MQF9s4jm0IFnM0cAlhiunRXw0ZcpdsSqtN8SdJJWsRMz+oVBCAmN93CJr97
	UEO1Fz0xSdmVVCi/Lw6gohHHyYR/ATzqgbqrcH6PYKH2otRxKAHbGA=
X-Google-Smtp-Source: AGHT+IEoi69t7mYkGM64faWfanIG3G+aZjIxCT9T7NbXrz1Tm5ebO1fIisC59kXZkBUKvdy4EFZyz1T9cHFhC09CFbA=
X-Received: by 2002:a05:622a:17ce:b0:4b7:9438:c362 with SMTP id
 d75a77b69052e-4b79438e5dcmr151588411cf.33.1758015333543; Tue, 16 Sep 2025
 02:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-2-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 11:34:56 +0200
X-Gm-Features: AS18NWAeZ0I8Ql6T2VXhNmbi0_zOyyX9JImpZH4pIDJbyS4OHq46p0yv6zBf1BI
Message-ID: <CAG_fn=U-SH5u4Lv3CcqKVHnK1ewrF46AF3JU1eiAh-JYxj86sg@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C4B1F14000B
X-Stat-Signature: tufuf9337pmxxf5yxrofauui8sqeq1jx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758015334-236042
X-HE-Meta: U2FsdGVkX19MBL28J2Zm2sdLDr1i7+09Yc1psSuRl+L9WaKeQxp5CFBtuoCGcXwdGYOFrjahMgXQKd0y4or7nifDqy5ATf80uRRLCCU8IggHCjhZfm3VCAZYuHEpX1ry8JgLM9Z9Wjf642FD8voq7UEX8i8C9YhZxa3o/s+Nx8sex8ENVIe3jwTqv0c5n9v7WEMO6wffzv+nPmKCAAtAJtdJ/12/FjWle8VzuPyWYWBq/4vozDC16iyHM2uYokZvcmTf8yMdXGzYju2dgy2Si8ezMHblUwVEbxdAImINMhDKfWGtPOHHctckt2v3AsuzfhOr3Um3SOr0lmUXx9121Ip2OXqrUlfQ2xn81QzV8GedtLVZbLjvOq2yQgCFiEAv74AnltmUTozvAxU/OtWIR+QJSAJzXRzBU0KQPFinVHSrV8PWnjSzP5AuLI0zJDdIm30aUAotO37Az7n1RKVlOSwpwWg86gwCIy9IhrJ4QuWIT4Hk6HfruTy6O1V8JvLb9bOVbzbS65lBIxxaf2TrfwsvIa7WboNwYU1Niw90C+x876WY+ZdAzJJZHHHAli65E6Nd55ymippVn5KMxhCZTzA6K/HvOOyv8X/l8oz4WiKtq54NztCA+fcccOaNKleXwoqQooEr71bWwO4Auwiugw8vzrhN/cch74bJ5ux9JUCY0yczk4ENhpu4Y3iRLsyCWMsF5P87qu8Y+m/gJ5PUlaRa2zN5NmE52BH7rjI7vhXMplsvuaNd2PPWOD5bcMbcbTYQ4XSekpNFu4z2Q0DRSKXOEGdQZmLm2OiVMKS5MyGMflyXOAT0y2voK8wWVvPQ8gpClZpO40+jnRBFZqqu2XRDOUXPAYcZKMEys17YrRFYhGky0jbzjm2HvU1R9SCYgFVJQeysO6vzKCNMspZEDNvEfmHzDkPs1GxLCt8+XGWq4N656oSxzTXhqsd05LS5CzLxD5e7RRIQABHq7Zz
 BcDHv4QF
 x/YZTItv8YybcyRdKfmxQ2ECTNIsjNkbcDFYrYtSiZH7Kg5ekSKkrLLU3UQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Ethan Graham
<ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce a new helper function, kasan_poison_range(), to encapsulate
> the logic for poisoning an arbitrary memory range of a given size, and
> expose it publically in <include/linux/kasan.h>.
>
> This is a preparatory change for the upcoming KFuzzTest patches, which
> requires the ability to poison the inter-region padding in its input
> buffers.
>
> No functional change to any other subsystem is intended by this commit.
>
> ---
> v3:
> - Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
>   kasan_poison_range(), and return -EINVAL when this isn't respected.
> ---
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

