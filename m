Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8B3CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7B3900002; Fri, 19 Sep 2025 11:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F608E0019; Fri, 19 Sep 2025 11:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC61900002; Fri, 19 Sep 2025 11:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFEC8E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:05:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56D44160716
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:05:53 +0000 (UTC)
X-FDA: 83906324586.30.A979DEF
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7072110000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:05:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yLKDhlRL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294351; a=rsa-sha256;
	cv=none;
	b=tzgNixZcUYZ6gRy0xyx7fW6Akwn9lJ7geRaBZnc1wWYqtpqohb4M4/yel63hx0B3t7JpN/
	NZc/pp4bc29Zh9ShKE99lDtOQUxNAiKZUt+cSwrnitgTpJSF7KMIgw4VidkyrYhYfac65a
	dTpPD3L//wmDjF+0RJWfZcGE53mDUzM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yLKDhlRL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALVFhndHULwyH6PXNjxWdCUnJjL9si5BK+FmNKNwS8Y=;
	b=6kg8A5uwScnCmPtKOrFs3+cGIhl1bVM/nG0yAjxIfE0FZuHJ+acvItLMsfqbqx3K7CvKS4
	nBwdELwstIojTr2GL2+VRS47AZYDUxL9aaRJEDyKXJyJQeXnE7fU3356DsWv8KCVrViFrQ
	ZYjcMmjeA/igs7HiLcc9+aTxCxquKrs=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-77dd76f6964so32026806d6.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294350; x=1758899150; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALVFhndHULwyH6PXNjxWdCUnJjL9si5BK+FmNKNwS8Y=;
        b=yLKDhlRLbAMP3yxF8dL9pRF2VAJKC5QrEyd7rZFnFNRPPVB0eF8gfTsNa7inxRx+Ul
         0u7UsoZTcscHQ3Eoh0IE+yJm0Ub0tnSr2y/e7CXqrXNiP/1BsDKbMsotcLWR9NRQgJCj
         IxKGYmq//0eXDvQDBLj6NJLDoNB+WsIoCeb4+qQ86QURH6nzQj87lXy5z1Y/nBhHlst+
         rZxpS1HCTIjlIjP3aQ8iFa7n1Vb3/tQHyhPUWeOl1vzr5eNfMLH47n/1flfcWVNljY/1
         jK2mTCUX6CA6+xzE7baY/fXnD0dhjnTZIzquel+Z9xk1K/MGcILedGn37rT6gJ9OPc33
         sbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294350; x=1758899150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALVFhndHULwyH6PXNjxWdCUnJjL9si5BK+FmNKNwS8Y=;
        b=wGgKqKfXW4Pz+T8FiuxxIP22LR3BaOs7OrxbCikCuDhwuY3SmrsAbrn6hlg/rTSpRg
         QB75AY7V9jhWLfGYMLsfs5Bz2UrQkWp0necA8csP97zLOfmkNuGFXowTTnrizA03pX70
         l8I+bgls5ZWfNdy2aBju2Ptix+nSqS4BmdQc0CbHuUQU/rWIuhQRMCj5fzjIsXY7XKr0
         HpeyYGoD5iPFKeH8bmgxkL+DJs2kC0w2ohs24tgo3oxb6ueKqRT5EOzl8sWmuITo3hzJ
         KnqHbqtodBmwe7ePY0LfcngNxMZU89oLqJLH7ZrFMzovf0WobbVFyQCJzS+5wTzGhwE5
         32nA==
X-Forwarded-Encrypted: i=1; AJvYcCVckfqp5FlNV53jff9MvWh1NjxXKSYz82lXOX15vqTpgWSbDr3bq8/e3gi2GCzqf2gUDZ5xmYJJdQ==@kvack.org
X-Gm-Message-State: AOJu0YzA1bYExe/d2jH6UJU0mUgbJq3NTvvx/fRfWycVEvk/4Wtz4pz3
	384KfYAmL2NNO1A6z6sz70J2gNKjcJs+RGwnQ3rKu8UgACptUTEr7HbKB6njFRDPullpJ8Jt2hq
	7PYOzGmxnjJpWy2iPkwRHfnMo1AFzMP2gxzLhiDLj
X-Gm-Gg: ASbGncvVlvJnkpfiHv8T2zYNXp6p+8gb4iQQ70qgxIL8SVkT63z8W5nP9DYFQLDn3yU
	dxU/+YwpIlSxLqiLQc67izplfISinDP1dPQvkRA/FuPtZKj1nI6htDZLVNqatnAwvhX3jCZ4+XV
	htFI1wXnkXePcfdDECL1K0JPJqtJaWBklzByiFMWKs0I7GM9YUSEYuS+dDKu0Q7SZCXc8AEWT2j
	nFMbaMujk1jXzn9UVcNhc85Qz/pMQF32reCUA==
X-Google-Smtp-Source: AGHT+IEVqq7kGd48eq4ZHSpETd+85Yxiw1HuwZsyw3lMLRQhSxxE8PumVmG7OCruoad9bvUz5MihV7lV49oxp9BNi0o=
X-Received: by 2002:ad4:4f4d:0:b0:799:59d0:4e54 with SMTP id
 6a1803df08f44-79959d04f7dmr32751596d6.31.1758294349954; Fri, 19 Sep 2025
 08:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:05:13 +0200
X-Gm-Features: AS18NWD-UemVXeXjYD7iHT8a4re1Qj02r-S9mCoMAicLgtJfaZDLOjotbdftD6k
Message-ID: <CAG_fn=ULHR_n+w=apc_g8Pe+MxXwNnQiRjOTRukzEiSAFK7hOQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7072110000F
X-Stat-Signature: ockyqfxp6nsz97stigrusbqf7fpsm36b
X-Rspam-User: 
X-HE-Tag: 1758294351-744767
X-HE-Meta: U2FsdGVkX1/oBKkLMXI/z5n8kN5w3yszPV52M40XF7dhIbdI1nJVUv66Os1YqUdbjk/7Xh7DIn0fOkQ1vWlJmFhxVLogwCGakup5DnwVsL1hlRN25zvmLz0UDWCFo8dEo/J78kH9TMkrkfZqudPHEyPKD81KDGdC2WH18TXNCloKY1fvSZFisBMMEt2zL2BYtlBJi6Zn9wGuB2XxJhLTTbQq3BDtN5pVvbVT7ngYZt2etwP7hSeD6FVR+8HAvNxCJovelFCyEhT+hTqu3feQHQiRhfqLbVSfpdhFYOVufN64JiETlL3TMo3t1529g+NlYhgM9TsmX3qDJT6pN4I2eqJfzNnLoUOIDKm7VZXEUUqvk1XJ8ACcupbmg92UtLnf9qzfRPb8UUrF1MzZKxvZFuIdrQWj+v46qfOFLr5grRjYk7MqhM+IK5uJ0UlTHaaDVwUc+fc+wU0ZjaanzEyd2gG7oNJ4johpHTuaxaanmc2SFyrOLwU2hl22RsBnPMfeaupJ4TZldAp0hf5pIxm5JFVECWCoNgRZI0v+qSYysliYi3RuKvQTKXz97FCoeAXCAOnx4EdgqM9xeROJb01VHxVQHFY6yYwZ0uI0LwCud/gYM++fPuv+ZQx2cKiPtQNUME/IUUoajZ28/4sSUN+xSbRRiFoXG/KRVitJnZmrJhNalFZ5DcA0FzoqLAAJpGg44K/SxnetRNCF3LkgalJ+d1AAVmh6CZn6uIGjTjfe/Ym0pHbfZJPEnrACDmNUVsKGagmtTU7ljWhUSFT4K+OB57hkR83VoyA2+YkIFEfFlyC73SDADvt516Jlsq7JwbNkaMr55Ad3wUNvU8kvn3+DbwUpgFKwM68kZqmOoUAR9g+bpuD5xUDnUrWamgch8hkfhAfZ7AIAOYHf1llVB+B2Uq8AJEQeYVW94q+4F7khhIw3lDCBQuMeMeWU2qRr4fE1YdQmmrAH1Du7mDJLbvV
 TQAfhy9L
 ErbnrjKldwfd1vTHnu8j6s/jyFX1ZWpKOk55sfKQbmPMVP6cW5FO/avOnrSBqTEPuCYdu+GHEJUll1QVj9Pmj6F7qgwZc72Pa7JuN+7bsra3Wdn/o+br1x1T64lhzumU08qIYK8aLwI8HBm+0n7cd0l3NybeRQMdHwZcl1xhVhA2pm+bnDw1F+rXWvdR1lHhf7yTVL5aq4BTs3YxOTydA1fsJOkgijL+h3yWNbZvZy21dL6ZWrlFrJ0yOkso9hjjcpDAgW/m4wJ7PNoth6kKnB+BnrYMt/hVRllkzJRwfjEsQ0mKh3g3bSwB5oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add the foundational user-facing components for the KFuzzTest framework.
> This includes the main API header <linux/kfuzztest.h>, the Kconfig
> option to enable the feature, and the required linker script changes
> which introduce three new ELF sections in vmlinux.
>
> Note that KFuzzTest is intended strictly for debug builds only, and
> should never be enabled in a production build. The fact that it exposes
> internal kernel functions and state directly to userspace may constitute
> a serious security vulnerability if used for any reason other than
> testing.
>
> The header defines:
> - The FUZZ_TEST() macro for creating test targets.
> - The data structures required for the binary serialization format,
>   which allows passing complex inputs from userspace.
> - The metadata structures for test targets, constraints and annotations,
>   which are placed in dedicated ELF sections (.kfuzztest_*) for
>   discovery.
>
> This patch only adds the public interface and build integration; no
> runtime logic is included.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

