Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC156CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 10:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338C08E0003; Tue, 16 Sep 2025 06:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310448E0001; Tue, 16 Sep 2025 06:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D058E0003; Tue, 16 Sep 2025 06:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13A818E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:22:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1E7311B0F2
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:22:10 +0000 (UTC)
X-FDA: 83894723220.19.C81B11A
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id D0AC140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:22:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cxT2Iq8b;
	spf=pass (imf01.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758018128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fDdVkJYP6n8rFxsmmwdyCR43GJXYJ4e6lkQY1k5jhI=;
	b=nMJU3no3XlKb3dpw26pn8fCJRxkeDAiJhSeX/uJ/aN1ycEk5X1aAzl+XLJIcj9YOscKUzd
	kCfbTjjIZ6Fy+DX7Lsted0vgv5FVneyNM9BmmDYLjhQ24wHvkvmgi8EGQFL7ihtWCszSwo
	DMVfNGDNZDrwTt6oXpLxlxKGpE/wWUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758018128; a=rsa-sha256;
	cv=none;
	b=PnKPz8iwttwg0Ej21EfSh+45gXiJFNgGBwlBxNakQAed3CA9DnL76Yzzt6cKkkAJhCF6Xs
	dKDJkaksYYN/yo1mEI1fyWtK/CO2pM2RaPgUCKo78MNvv6sjS2L2NV8ALMk7VVPYi6XSmr
	xXLBd1ItZjlZIPjJ0mFwenMVmIbVWTI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cxT2Iq8b;
	spf=pass (imf01.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-77967339d30so28982256d6.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758018128; x=1758622928; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fDdVkJYP6n8rFxsmmwdyCR43GJXYJ4e6lkQY1k5jhI=;
        b=cxT2Iq8bVo3/OlaPQL6PZmsp1iUmPQz6a10dkKwyptsGPn0zvqe9qPVU86RcV0b7pc
         DUYjbDNG3pMsM87C11nBZuCmgjcG82DWN9qc/xHAH4TVpZcrp6cyyyGeObl4yzZkCG+L
         bvpoTWs2odifKqmVljqi9qxRu4eHXhXIKm8yyToEDAR1IJglIgqR7cMwhU2Ljy0ROv4r
         dUGX6ZlYRjdFeNfLiQ0sZTd+lh0M9INtghxRwqL1ZTEEHPtB/ORlbGCUYb4xGpIxG8mK
         6eN0qXTjJ4Pj9at3rxhyuP47/VbQMfCHCCSMQWbW1uQmWwclDycHC81J4py3WKe3zouI
         n5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758018128; x=1758622928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fDdVkJYP6n8rFxsmmwdyCR43GJXYJ4e6lkQY1k5jhI=;
        b=WX4C33U+VMZ8J4uowDxKUjJ08XGm3IqBYGlp4q+NYLJaS8UWwDhG26YiyRG9pAuAyn
         reLJTQiPR93Sxndk1eQFGBzWjgFIDAmzV5p5c7bEeuZsbyTT68hpG0nON8JemdPVJKNN
         3dCzqXho+lf30KLT9WPBNb4yBkOJ/jeYlirSTanw48YfoJ67b+yLPnm6JTBnxuyXUudI
         5xbW3hAovLTZSbOhim9U7Xzo6/u9E2aXuHR3uudbA8hQdHt7oZ4Fy9OUH1t6+a1RBiQT
         4pLFcgV5RN0DqcXiVGOw8E/BfYZiEw5VAenMjeF8ZUygOiIxJAzvaFrQsTdD/x0DZiS5
         6tlA==
X-Forwarded-Encrypted: i=1; AJvYcCVSFYK/V7rJhK64odFB+pXTIvKBgGKNTNAwT/y49edm6G9Zl+g5T92UHx6tZ9FJSGRnMhTdGdxjuA==@kvack.org
X-Gm-Message-State: AOJu0Yw56NuFNOvgnVsWmAQWfAKKrPjB6mBePN6sdCkI0HcfCKb+SHwj
	/GRBCyyjz4TFI0rdVqOkVyx71llXgo3tTvqTW+V+375XEwZ8gVzWxGy7hrjsjkJfDOkwfe8XW9B
	VFv1tU7zbKmHlV7Y5awNg2go9pgIKvqL8ql76CcXL
X-Gm-Gg: ASbGncu1uvmuoXFOtf8cKvVO31YiegkNzXhqm/MRZtnu8snr+wfNamqluPiJ7TYurjz
	dgOshiOzHlp+KV3j6Yx5yEcw/+MkOLsbMonPvMndY6Z7ZWDZp2Mv2bySaf6jA02x1NfIciupiCQ
	G6pePlxqnwKt2td7QQubbavPOLE2/q2wdZ9hr08iwkCB7KxdlYKoKjt8NHDqn/+lBHCW/Hw4eE5
	9FEpwzJMXhpA9sHaimWTdcRHUTUo49L3KviP5qp8fFKHmZfoKCu5PQ=
X-Google-Smtp-Source: AGHT+IHJjKoQJCCYYuGTfxXsKe91BImRKJTHt9tE43tLxxHwyTxwEt6wyB79lNc8nOP5l+AzdDg7yLv4Nd7/rU5xvGE=
X-Received: by 2002:a05:6214:1c4d:b0:781:a369:ef8c with SMTP id
 6a1803df08f44-781a369f19fmr98103496d6.16.1758018127627; Tue, 16 Sep 2025
 03:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 12:21:31 +0200
X-Gm-Features: AS18NWAvlqXEHGPKEvaBnkig3ksosFgvoGuvVmEMsd87qxp-V32sXYdPaxYq0Tg
Message-ID: <CAG_fn=U0dOBumngmQQ1cna=SZvbDXjJ8NrVUZyCHY5dzJV4rVg@mail.gmail.com>
Subject: Re: [PATCH v1 03/10] kfuzztest: implement core module and input processing
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D0AC140007
X-Stat-Signature: 3amjfckbf8frbogaaxdd14nobkpujufq
X-Rspam-User: 
X-HE-Tag: 1758018128-105837
X-HE-Meta: U2FsdGVkX183mltJJuzLEO0ooy0cjuZS96NVQETEYbN7msONcNz9G6GXXeVJEHVklIv87tnDEcCxbQLTf68oz0U8nYIDR9bvyji8Ba/vHG417u0pPcL0T8fyzfWO0CpRkvnj1H8MLULjXasINimbHgCNWNGoxKc/WQUf58SigMft5hT0/WAGzCbgXhZ+EnNw2kyA7QMF4mL7Q/HmL3QdYvOwrLSCsXdGvrtaI5/mdChVSwzyg49g4IH37R02kRRvLIFVsrj0tdk1vJiFD/AxXRyM5y81PqLU2ZfP99cGjoA5m7oByqkcUy0OF1mLtZ2kSS7/iRmn1pbv0QFynRXnLhvaWtX5c4SRvsDyRacvrEkMLc0bLf0WQp1LDiytFBs5mdCColp+b0vHzPuZzlZ0fX9CIVnYvBE7B3qQemXO6LjVIVvF5HUU8xT3kaKo1r6v10QFot4HIecQscvqWLJk2O9LQZ9XndDoOOMbQ7pAjgyPICLUDFc0XsMKM6F3EOfHLS3PbQdLVVfa75WL5Iz7Utm9d6innTXf858N98x5WqEkNb8FPJaBumPd0JO9DCmzgAr7NvGG9G6TOGf/iIcbOLxXgt2mL3ab4uPRinanWm7orgWWbFGe4obyyNker+N1pWW12hQH53/Lq9Tcw8MckPZ0E6Hd1yP/TLgckDdc4bu9lCFHozBqwhB3YRmwDGQVaBfoUFZuwWDvmmSbsWAt1W9lgXaNQ/L7TZJ0oIko17GxPeju5UpQs7kUMQsDnjjtA3wpQwGlPXGBNXLlCTV8BS7ybdxghcmW8IsB6XH9CCxEC0jgXsUGXjimO9RmipjyUqMPgQquuWMoC0VOF+3zPpRO9WcA4AD2ZJrKT/Wsgny09BpbHPxBD1T+ZnXzIK2zo5q2N0VzMY13+p1HhR2dRkUuuI7PRakWO1RIAcX7OfeRJki71BF2WahsNWUS1SZHcFZv0/fhd/Y8Nop/Eci
 C7Q8Yq2p
 YzO5OVg4Nunml4GcJohv4u7op3cFcXHCg4bmQ69TIbQkHT1eeAfkzlEAc6xT8z7xo1mbxkb0CoOzzTGxhNAmGxtoT95We9Dy2OWRnSBaq7Q0A3o10RVaHoQILi0OhZ1p133jlNLOy1XwjHfq27a26SrycR4X0vALYa+JDWY9M/gn7dpvhJXHa21V+9yfMGa8N2tx0e+vCxDQMwzLuZ/7SCuG9tDaCPldCZtLHYneSNFWCVd4CPHeQURaX1xT2tISHO2aq2IlUFUmCpDigkwuHEP5q4cC4qI9T/gEcGSNArnlY1OFqyY96gvQqfA==
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
> Add the core runtime implementation for KFuzzTest. This includes the
> module initialization, and the logic for receiving and processing
> user-provided inputs through debugfs.
>
> On module load, the framework discovers all test targets by iterating
> over the .kfuzztest_target section, creating a corresponding debugfs
> directory with a write-only 'input' file for each of them.
>
> Writing to an 'input' file triggers the main fuzzing sequence:
> 1. The serialized input is copied from userspace into a kernel buffer.
> 2. The buffer is parsed to validate the region array and relocation
>    table.
> 3. Pointers are patched based on the relocation entries, and in KASAN
>    builds the inter-region padding is poisoned.
> 4. The resulting struct is passed to the user-defined test logic.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
>
> ---
> v3:

Nit: these are RFC version numbers, and they will start clashing with
the non-RFC numbers next time you update this series.
I suggest changing them to "RFC v3" and "RFC v2" respectively.

> +
> +/**
> + * kfuzztest_init - initializes the debug filesystem for KFuzzTest
> + *
> + * Each registered target in the ".kfuzztest_targets" section gets its o=
wn
> + * subdirectory under "/sys/kernel/debug/kfuzztest/<test-name>" containi=
ng one
> + * write-only "input" file used for receiving inputs from userspace.
> + * Furthermore, a directory "/sys/kernel/debug/kfuzztest/_config" is cre=
ated,
> + * containing two read-only files "minalign" and "num_targets", that ret=
urn
> + * the minimum required region alignment and number of targets respectiv=
ely.

This comment (and some below) is out of sync with the implementation.
As we've discussed offline, there's probably little value in having
"/sys/kernel/debug/kfuzztest/_config/num_targets", because that number
is equal to the number of files in "/sys/kernel/debug/kfuzztest/"
minus one.
It just came to my mind that "num_invocations" could be moved to some
"kfuzztest/_stat" directory, but it can also stay here as long as you
fix the doc comments.

