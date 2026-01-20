Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69764D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D117D6B0420; Tue, 20 Jan 2026 09:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBFBA6B0422; Tue, 20 Jan 2026 09:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1696B0423; Tue, 20 Jan 2026 09:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A83C56B0420
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:13:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F0E9B9873
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:13:35 +0000 (UTC)
X-FDA: 84352535190.04.7658440
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 83F6E140004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:13:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s1qYRenc;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768918413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
	b=7HYNpMUzClb+qbBsrefo0EvF6dwgACBprfJkc1BW0VkwHnZYsY6qi4IvPluggoKqU+KYKF
	id2AtarR0/d/ZRH48S7C7bLssR0jxIw769etoH5sXdpygHO4y/P70w/PS+zSHs5YD49H0v
	b4RX1n15P4vkgq7gISHGSkwJ+lW4AaM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s1qYRenc;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768918413; a=rsa-sha256;
	cv=pass;
	b=7LzJ+3FfW5AVcbmCpO0AZKPYgpDsWQ9XZEHCo5Zo359BPG3fFjB2gWupYqc3AvUZqR6YS7
	6UtSs4it8THlMDTHi9fs8feEzpHFNHyObXwDcJrkJU+eOtCOl2bhozWJ+d7h/Rup0791St
	yg32KSLFQopnJRh7WS8VKLW6GnwbQcA=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c52f15c5b3so620376485a.3
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:13:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768918412; cv=none;
        d=google.com; s=arc-20240605;
        b=h2GstcJ1pr/56BSRJKoJfZKV6KGzvw6AtggIYF2I9bfrGbL3xE/HmiahgBxJqeFRHu
         TngP5dvGdYj97Rnfe+Bw6rQchWW01p9gaKbSCtXCHk6meFTxAkGekLM3H1RFEmB40lcI
         dimHOVVnavLxXl9ake/b9fsIcNhxGUJJ5RVwO0qAykczw3PhWwF+IsdfRm9ArHQW4kzw
         BJ13FXFxWcjZEUI/9S5gffwc4K8QHT2FJPYU5hT3erfTTM2LSbDE16sCh38affK5iuNN
         Z2Fp0GUVe6EydwXT21mstoUwNDvbdpIhU9Jh9ersoTiMLkgPjsmr9+d1GAFmPO5GvRn7
         kEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
        fh=Gve6WwZdNdapiioDML+B54kEifmJ1z/36zcCYw0top0=;
        b=CGIKkFd1qo52Hh7dEEbaJRKqD8+QlShhwGcJY+wOjp4PDYt/WlfP/4oUIaVeb+A3AE
         7jXftLv5MfZf6e7YrqZVrhvsVFNzp70D49W9SxUdaznN9qcuCf2D5tWH49WgHZpPkDXL
         NLTALmf9NgAOMuax0wNiyzuNj+baeg7zxDJJ+jgnUYyS1+H8l3wJR+iLFTY6wLqR9Ysp
         enDCbD2gwyWw6kFdA0RnZ68A9uOpJTdyZclW49gxsBy1QcwLrNWyYEr4xENwV0drbNw7
         AGZwSqipl4M2l/zoIXCFIrtheGCMtrjGnTeFkce8oZ8ZNqLZpb77AuIAvZELPjdf4Vx3
         FN1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768918412; x=1769523212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
        b=s1qYRenc7iP1nKRsCHeHTU16uZECLq3kwu3ue7hYtR2rtALMWI42QxPXbjlhBTLfFw
         3IvMITJ9NZEvv6Gk739MGcTqoiKuC8qor4hS1f7oB3n19JILVytmHn+HdeMnpwHZnjPZ
         b4kJReza41GwRsxKEGj9pFiHTF0Ku9sSrmq+jzpP4TWofcyIcOf0ldVug7OSGLIJ51nF
         x8GrqJxqVsZtH5c9k4FT1DO5XA9XVsGxE9PcGHq5ihAL6QFVoym+tO5MTpkWWo+OXyK2
         Sjqa079a8pLFPQzlR/J/F0+cQhuZmHqsHBccBmH+sACkC2tGYh/sMqoVh3MovUptFi06
         TtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768918412; x=1769523212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IdYE5jdvNdfk3sHI8GmEWBpt99cM9oMrMqemVzHltu4=;
        b=K4Hbdeou4qgEvDHvIry3rcEQ+ymP06MNx8KgWSuTDH6oapiGjIf8+sbQ3mO/G7nTEU
         NqhreWdlkVDo0BEiSpNh9EdrxrOnWIBx4JxoR/r05bru6e6ahIbzSb2kTdij/R6VPJd9
         +n+npmR2NnZekPMMgmau5/4kyyzhkb7sTbpj/l+ihXftSKHWkT4N11WGoDXjg1DcMD+O
         uuKNob/x6mvXvVug0xmt4r1VSJ0zwVnR8f9FJs4TB2NzU5GLFXjDFXxvG4sulh21bsqV
         gYyIPJdzi7dk3zZ4aMmpdhWkguY9L2BplTM/pvmxyU5UVImTxTx0vL4Aac0elBtUmpEW
         aMaA==
X-Forwarded-Encrypted: i=1; AJvYcCVYBCaaCBv31c2X0iMbRdWw5ebjexR9Spm/YZIax4WGSwSapr4ak0xTIPpCXNijZq8jNu05Q4+LAw==@kvack.org
X-Gm-Message-State: AOJu0Yw46NSAg2IH9SrkOMAAV2qsnmi6ES53uUIiNS6dZYylnMV4NdVK
	94Eg1tfJ/DGo8Kz3YIdcHRB/9Q0ZuMjZT5nkSnfqcbn2mrcowQRVdDISwGsWmxb/7i4X3dPYsa4
	b3HtC+pJwTxQyg+lZuN4hs1ycvfR29QWAbX2KZ4f9
X-Gm-Gg: AZuq6aKMOJIqnj/O/7jgO5ktD6J6UNmyTt7WISHTqbPdvqn0iv3LOhb46JilFdm1bLt
	A18uzBsHiyKAt6+czEfsxLTE2birAXKL3zwLR8BAXQw4Jl0XnG//gLQzE5BhqNJxsT1ZgZ385Gr
	jQqmdHhWKRss5LOpun4uvrokSb1ZbeK/DmwW84d2fLE/uIPTw1lbgdPGylvZGpXFYPswWmSwmNT
	ehuhMdZFGrdbMkBLp6u79aUMcJp8p0YgK2rsdmNdpSLuhiyKe2ZgfOncDivihNNbKgC5Jdir6xR
	U1bX7OxVRs71LvmyN1XraWtkdS4pIhlHN0A=
X-Received: by 2002:a05:6214:202b:b0:894:68cf:49fc with SMTP id
 6a1803df08f44-89468cf5432mr19791426d6.23.1768918411939; Tue, 20 Jan 2026
 06:13:31 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-7-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-7-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 15:12:55 +0100
X-Gm-Features: AZwV_QhSRG2StFyNZkwjvq48dDIr-HhWGfUMqppHNhj04WZytkphQv9nwByXueo
Message-ID: <CAG_fn=VdRkSjvhO7wz7_PEznBOFgLjHCr2hSXwrKoO-hpMqTzg@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] MAINTAINERS: add maintainer information for KFuzzTest
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 83F6E140004
X-Stat-Signature: yhuda1u3btzkaq97afq89nhhpw8qi5m1
X-HE-Tag: 1768918413-588348
X-HE-Meta: U2FsdGVkX18WfCXV24RAblBZqBQyarxitOxrsXhbsUDA3K2DrA8MCDt/BMbWXIS6mq3GOfGwfCEtKWGRZmmFNfnjqJl1cmJaeba7bUchUO9XlQDckBOawwiLkdmoyfB+qkntfil7+LmN0SvCSwE9bhencPY0NLVY/nlsCqyQp/8SZIb80e6jvfHajj6EwVlPg2sh9LetnKU6m3DkHwxtxH6gYuI4ULpYorgo8vVyq9h7nYq/BNTEH3hGNPlsD1xztmRqAp8JTM5HGA/5FCDEcLImOI/GM8Y5OR6VXLbrvdSjv+2hvwAzvug6Q/bNrXL4bmrza2MzumQYq4RD74/Bu6zlYbdqppR3GMKl6oVlHDv+vUfT7meTwZK/kVw8RX7H+WJp7/F3GpxTOuTrZ9zi/QhoW6Lh0BV2QLHwvYVcJDQy2GR1xj2IDW3CrplPVXM6SYyJAlZ48Ld2LNlcC7eVj0T76SwyrCWM3yh0PxVf+KoMb79K6vQEmPD4D/d1pC22LWRL9QCrYUYn3y2HhnRPzhfFYZyR9k1dt1yce7Kip4NJIwxwr1cVw8swl6mtK8PHNVTb7k0h8wN3pyRU2gfT9GnyMl8YdD5zeFKWr9RNXnQaWLqhEtVY47HHhAwcnUNjeigYTZcwRyYA9DkC02Ct6pKwRsGXSS3L9tT6QHLfmxOFFuLHuFPZLF9y0RsPUsAlj3T3mdR3jT++7k0jHAuaQtjhfXnNwJxiVkpchfhSPYRhdOFLCDhaMUn0u4YZNZ/hIVcyF6ut2r/7Cq7CP7gaUoIu68FW3zBTShYTtc1uDDFArvph788Mu0zXwQeuafLh6bufymZOikSQOJBrGm5atVhCvtYnVbJFKo5TPSuavffPpURmXUkC5mVh9O3CVBRDTqdOordRtkV7RRGm5cWQwkoA2cRDwY1PbUhVlYtk0faxoVFIzchtO5P2Oq19kDJR128ybjsDKz4r9ZUZFPz
 egFV7kH8
 vqUeyddCGpdQfiT81brFa4QCmWcQyoSh0HdNWsjWoY7/nfnKdWiTej0ZabGDUA8h0+VLOqMTY+5fKXo6Dtl5CkR9ttet9BOOUfhDyjpuhO3NyNmbCj0SU1iCtgPudkXA2EfvT6VlYCtiOl+LeFGWxXrHze07UEguuPQ0uM9DOnC82LvyestfnDHszsnNpC5RzbkmIj9QxLLvOUR5vwvLLpn7H0Zol40+6Brth0+wN0WuU8oHsz7GrSJUsZ+7yQ6JlAaLcG/wMepLUzpr/gKwYXUCAFVlk2tvz92xz36Z/Nn/mU91pFO/jujySJTLiEBN6zwneJOwxiUJ6TQVVvmfw9mMticzAU/GautZqCc1RFF7SAJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> Add myself as maintainer and Alexander Potapenko as reviewer for
> KFuzzTest.
>
> Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> Acked-by: Alexander Potapenko <glider@google.com>
>
> ---
> PR v4:
> - Remove reference to the kfuzztest-bridge tool that has been removed
> PR v3:
> - Update MAINTAINERS to reflect the correct location of kfuzztest-bridge
>   under tools/testing as pointed out by SeongJae Park.
> ---
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..0119816d038d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13641,6 +13641,13 @@ F:     include/linux/kfifo.h
>  F:     lib/kfifo.c
>  F:     samples/kfifo/
>
> +KFUZZTEST
> +M:  Ethan Graham <ethan.w.s.graham@gmail.com>
> +R:  Alexander Potapenko <glider@google.com>
> +F:  include/linux/kfuzztest.h
> +F:  lib/kfuzztest/
> +F:  Documentation/dev-tools/kfuzztest.rst

Please also add samples/kfuzztest here.

