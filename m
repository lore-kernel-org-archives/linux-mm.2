Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDCACC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 21:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8DB46B008C; Tue, 13 Oct 2026 17:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66896B0092; Tue, 13 Oct 2026 17:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3786B0095; Tue, 13 Oct 2026 17:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 976EA6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:00:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EA4680208
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:00:33 +0000 (UTC)
X-FDA: 85318821546.07.538BFD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2AC7C0006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:00:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQ1WC7nM;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791925231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eJZLXSPO2QvZyB5xQJce+abk3qpL0hKOdB+BIHoOX0=;
	b=YwowtEIBke+oLS8MLsuOtFpyKLpFrjs3l3MngY5qe5vCJcYv0Bhyu3h2UgUWpAXrfWK3SW
	vqdnogBRMliv3Y/TGVMqeKutC3EQdIDefvh+//pnAWqgyB976FNZBX5rjhQRNc82JkSype
	RR3m7j35yeU4TLm8DglTxJud3vfKRkE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQ1WC7nM;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791925231;
	b=WzeoEa20m2jeNuaL7pmLPdrvqAcykVdDIpvxSrj6QnroV/nSUSUIv3RyB6Iy2OQbqGLt3o
	WBBrXN41nAHNmTNM3euGcaPoNM70dEAmM/fOzOxM0x2EmRTsxCuh+UdKyIZ6lNWnVYveH3
	gHJKr5fhBkG4A5tYM2v5U/ubrDU8Rgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABAB043E9E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907271F008A0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925230;
	bh=1eJZLXSPO2QvZyB5xQJce+abk3qpL0hKOdB+BIHoOX0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IQ1WC7nM0pZVI6Tj7H6gP/mQFDhPwEKc03cSJODDkpo68c0MSXQHb/kS+cU95I6Ig
	 4EVGxC3D0+B3W44j/9XjpnMM8CsUo8DcfLz3HPhPwKFeWOTHaQ2rEgTa0sZM7SNsBC
	 ZFT/YIF7MYqeHX5aNlYJetDfHNIq/1uVvxQ4UMs2WRtSUzARolyRXlrv5WIK69BS4Z
	 mUeQvIKXspWdHGGNOflGNIseRHzbeNSJgMeXROkkkXtOQWXqOSozot6/oXaD9gSqyV
	 J+YVrKT2E2hNivnWYkz31jsH3Dh6QiLq3P2m2KxHpCbDG0Af0sw5diomqaehr1rwqw
	 DBga817lt3uRw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e7496f947so557193966b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:00:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzJ+nEqbWT8oT/IT8/mWdfNS/05MamZOH1sNVaQqrQv21jdLRi1mXCW+j5tYJUZ42jBA9DMxEFEqw==@kvack.org
X-Gm-Message-State: AFq9FYIcEwONFg1Ein5URdP82QmxsRZf8WrTiv0d7xYg3PIO57x408B+
	sd948eIvHI4B9QXkGE3a3Sz72rfpGgz6+f3r503kXMK8hQD4t3ll8+ObVtXv5DWf8dOY2cNBdh/
	QYujfr7VUHA96e4jrwnWZUXZwgZ0hJVw=
X-Received: by 2002:a17:907:7fab:b0:c26:1691:b368 with SMTP id
 a640c23a62f3a-c31a9f6b728mr1375436066b.33.1791925229423; Tue, 13 Oct 2026
 14:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20261013151007.2093943-1-usama.arif@linux.dev> <20261013151007.2093943-4-usama.arif@linux.dev>
In-Reply-To: <20261013151007.2093943-4-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 14:00:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMVULy2B1YNK7qNzrH6idiZe0RpkW97OV2ux0tQTQWPuA@mail.gmail.com>
X-Gm-Features: AclHuK_LdHV_et7vmuF6kLVqnUbLnv-N7hBpQnpqxarZFOSSyQ0eEVdNmZzRHFE
Message-ID: <CAO9r8zMVULy2B1YNK7qNzrH6idiZe0RpkW97OV2ux0tQTQWPuA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: zswap: use stack requests for synchronous decompression
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B2AC7C0006
X-Rspam-User: 
X-Stat-Signature: ztoes76m7zjrp8hygpj9m5uqjm3oe4ak
X-HE-Tag: 1791925231-235946
X-HE-Meta: U2FsdGVkX18KUWZ2VZzqbbLYOrbb6QQxVq0stEEmYBeNZ3bWSKW7qqXAm6WBjdOPTJ0yJWYSzD3tYOKkOB1Nnn9q/kYbSMF16c5rwGN8QJMoCS71BCcLUNic3j1CdJcLAe8nmte0CyG+wAUH+TfdkXr164aADyzFSiBLb1+2irVz2ibCrxb01rAVQJKTTESE4vN+96T8hLpkKDGAw8ET7R9hADAVnB4nZp7l/3X1p6p9UycCfzH2lz6+/4JojZhTs2HJAAV0hsw31WHGxUtzy3+C1uO/RNak9cqeYqhVkPR4CddVE62LEs1TEE6Sth/v3KtdyZ6bgdxPlLZ/qdXv5jeK9elw9NqbWFRSvP123t+cxSqmiAnfEN6woe/8CvYxoJS2Eheb++wlhAk3wwwVcAXL/fp6nVghgS69q+3EDf76Xl8TEBfG5uqLjFQxbMEmCNssUj9ofViFSdT2Tlt5PChk5X6mg7fVJ9EhvBm8wRyyyPDPfDlsKUDGOk/z4duslwFVa7aaJi2eJ/Gd8MEn0+90PkJY/p0/c6HASTPI8zDXgZ+vCQhF7yyaEgus9FltnyEr2NXV6MG15cQPqi5preP0xidtjc1PzLs+TSf4Q70BXRvhCYFwpyZhYxQew3zCUHBZZmavq4Ams48HFcXv+IvL4kxz9YG0PPpLwteLwTBMKGEEgFKIV9gxkoENtSPrKMOquwBTJwkYzVJbv4lIyMZdqz+vYda3mJfu6cZDf2J14ZWevCRC7NjmsUObvePsZpoO5g7UoaCjoppqxlhmqnmmSJukkXBNA91diyZRIkOi872EiriQ8Ns1G8sbT/vqRVHjAr37X0bAVlH/YupP+bIdWaYUPNRK2fT5YzPveUsT0tV5KkbI35S0fd5ptwcHWaApLhRAN/3F04dd+ahUt+PL129WKd5vfNXnG31c8IlpzRlfLnhOLwJ6lx9BfIFh+bk9i8YXx2YFW+Chv72
 xOHgrUB2
 xTqUMZMerR+3EeJilHlBY0NAbETXb/DoSe8K/PHVfyoQ7GwjD3FD4UbNH6oc2GR8/97lxHMW0MI3vtC/VMO1/90sAZ+iXkoTkUEQjW4L93oMxbszT9kGEu01RbRNn5F15ammDjxXz1vWzcjPQVB9bQ2ZUivUA68YGi9DY7FFvjElWPooWO53W7l61lRwWiPBrnnnMmuhtb7SaCZS7o4/oRxfAvtGPvqwjwuj3U5SiK6dpfCUQq8gSrN1lG8NyYszXota7o4mK+CWschblyuD4S7rmcTfB8d+fFm8y+jNxtNxByIWno2enDIdP8iVb1SmHsPnNCXYYncgJ6nQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 8:11=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> With separate requests for compression and decompression, loads still
> serialize on the per-CPU decompression mutex. A low-priority load that
> is preempted after the codec drops its stream lock keeps holding the mute=
x
> and stalls every other load on that CPU, including higher-priority ones.
>
> Synchronous algorithms can use an on-stack request, so decompress with
> one and take no zswap lock. All in-tree software compressors qualify.
> The Crypto API enforces MAX_SYNC_COMP_REQSIZE during initialization,
> so checking acomp_is_async() is sufficient. Asynchronous algorithms
> keep the per-CPU request and mutex, which is still taken before the
> zsmalloc read lock.
>
> Reading the per-CPU context without the mutex is safe. Since
> commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
> pool"), it is set up before its CPU comes online and is not torn down
> until the pool is destroyed. The codecs keep their own stream locks, and
> crypto_acomp_decompress() rejects on-stack requests only for
> asynchronous transforms, which never take this path.
>
> For software compressors this drops the heap request added for
> decompression. The on-stack request and wait take 216 bytes, which
> makes the load path about 270 bytes deeper on x86-64. Asynchronous
> algorithms pay this too.
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Yosry Ahmed <yosry@kernel.org>

