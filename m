Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB92C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F166B009C; Tue,  5 Aug 2025 08:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FCB6B009D; Tue,  5 Aug 2025 08:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65A16B009E; Tue,  5 Aug 2025 08:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96AEF6B009C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:31:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F8E61353EA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:31:17 +0000 (UTC)
X-FDA: 83742638994.16.31EECFB
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E88D10000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:31:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nVqpAIPR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754397075; a=rsa-sha256;
	cv=none;
	b=X0McbWNSmw16qIkdI1ECSNnOeLxsBoYK76Z8l81atp0XV6cGYou+ArExXZqLlbIdhvpUUx
	3+lfR803QC1tDeAOOBb2DY+OCtoOrYtgF+r1YXxkJVEbgstTOTiXfvEUtAmJJeSTHKs0gG
	BykBIhua5ph5IxN9UjJ4FNpHc/YdLTM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nVqpAIPR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754397075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yc4gvWW52t1NDKhzxwrmBqGipvg9SoHEPfFiqWrZ+tE=;
	b=xj8iT9JEkmZm4t6c8rg/iU0MFpJeN+IGQnNjVrTMxs0g/wIc9lBF2cKNFM+GOEJgQ4LVpO
	m8/rE8lyA/vGdSXAMoaPrNXeFVB80liuTppjtaM0uxDrRSS9hfZPXYjp8B0QGywaNnMaFi
	7xS/HBqKBWNsnvFMS0lUD8O8tQK4WIA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2402bbb4bf3so52660085ad.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754397074; x=1755001874; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yc4gvWW52t1NDKhzxwrmBqGipvg9SoHEPfFiqWrZ+tE=;
        b=nVqpAIPR7ynB9HjShwsPpFeoEzqcDS0JuxyjT3ZMQOUymWkSnbx7YVCu1Yemut4Mn6
         qoWzQ0EORJcBNwB1J04lCt/zGjyV6GKYbJNL12z+as9gSVcKMWqedksForbRXZI4+eRR
         gjT3xl5jDiH0IVynj2Jl9uGQRbEcpgA1wc0XzjvvSGtXzEE48P9Z/nz4K2+c5Oqa6d2Q
         EVRnHe/a9qFdr73YF0MIvkJf8aswcX+PAz5l/EMRcTiZqaGax15z9FyMVElJ4QFXsziP
         FbBZGFDmwJXXU/u3yOm2o6Gy7/6A82GaU/oyDUd42gSD7aml1QASHyVq8QgSx6geEtor
         Olag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397074; x=1755001874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yc4gvWW52t1NDKhzxwrmBqGipvg9SoHEPfFiqWrZ+tE=;
        b=DkY5LC/hkZxvkUB/qMJGPva0glU9uRS3jG83U77XcrYuqcKpiEge1zeZ/m38xBzsbt
         2DWHqbc1NsspRTuHgn/DbNmqUGTHBxQZgVzsFvTYg3Qv5pZzaZ4Fi7jh/C6mTz5gGjm2
         GoFWzS0CF8pYE8JIKpUjR8YJy3f3rjuJjeEwzMJoMbdXbukCcvGJ/jjXbH2sPd/S2zTj
         knGglQqBjIigpQYhHghD3j0UpJGiNzM/Yv2hDXeUBOpRtJvUgqRYibGqsTtV2g5hItrw
         P6H6B7tIESVH6utJCf7h1du2abfTODmVj9kT7CDcNYqU40rLrfLNRWdTsocI7sCzVUIL
         QDlA==
X-Forwarded-Encrypted: i=1; AJvYcCVgOvL59jzlwppTSz7jr45N7YqXpUUVQK3lCnvLdEd4XqbrSyAE/GNXhUQRahVWL7PS6uIpI+W/Yw==@kvack.org
X-Gm-Message-State: AOJu0YyXPimuQ7yTk7cuuHOea3TaUzmCHUisW5ZE0cF0xfB6vagBYstX
	GBR9VnW8fO31SIxwJBB3zfh0Hm/EiKWegBjL78Ghh4zrNWDpQXJqjKIlsMzg5ZdZ12/OCSHff2A
	Op1ubhfw67yC+vZ5uZ92YOqwDBUk9CzThQxhTXRAF
X-Gm-Gg: ASbGncsjstB+KNlpT1LIkvmweEO+2GETrzVZtXjoFODxoWQBs/+/eV1jKRqFs+c5yon
	68kaw7cCW0EQndTyyd7DHY8AoSauDsEQMvPfZQJEg/JmpbSFgqsvnRFA5NsL5uo+0kMcviVUOHt
	DLZKJzz+zNJyK56Q5KfKi5mW/WzcnJhqLpumLTnWmOFI2iLcH8Sh+FCubQyPicY+l02zxUjfaof
	1sGra7lCs+TiTH/Me+jGsMZES/WN/riPHLwhA==
X-Google-Smtp-Source: AGHT+IGPjiYBPWhiiCGGe0rpFKkbh1Rg3FSdLNOsksOA3V1eWAJUxiBJ13PoRIjsobG4RiQygfgDMFJjCSuuK+shj7s=
X-Received: by 2002:a17:903:245:b0:224:23be:c569 with SMTP id
 d9443c01a7336-24246f6b79bmr191772715ad.22.1754397074101; Tue, 05 Aug 2025
 05:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com> <20250804-kasan-via-kcsan-v1-2-823a6d5b5f84@google.com>
In-Reply-To: <20250804-kasan-via-kcsan-v1-2-823a6d5b5f84@google.com>
From: Marco Elver <elver@google.com>
Date: Tue, 5 Aug 2025 14:30:37 +0200
X-Gm-Features: Ac12FXyvqYle1O7urbvJeMSiw9QK6-PDkDpNKV6wtqm4byhvYfbkU7M963dNpMQ
Message-ID: <CANpmjNOJxJ+kM4J7O5J8meSD_V=4uAa6SwFCiG83Vv_8kn56sw@mail.gmail.com>
Subject: Re: [PATCH early RFC 2/4] kbuild: kasan: refactor open coded cflags
 for kasan test
To: Jann Horn <jannh@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kcp1s1zcmixs8qfdjai6e4fupztjnakc
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E88D10000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1754397075-329340
X-HE-Meta: U2FsdGVkX1/7J77cx5iTnnw/oPcdKWWZ1MPEMVM2xc+uP79Wk39AXv9J5JS7Joo+nl9Lri8wsQ4H3LbZtz8YqjjwrGsFsxuAQUTbq13d0cZTe1ao15TrC/SP4nWWk/X3zGJMZoqzlOGEcmNOn7mdlYqNI518BXq9XRzVLDQNBdWPqED3biB11nYGd3QL5phDjMeoqq1xT/U7FQDm5ff634Misx1Bi5kQaK8gV/SsSvHKm8MfwTEj/Ns7Ss4jTNcrlXi30/GpDDieNT+Hdj2B59FbZjgXzKIOJ22MTLFVh/OhWfi/AHdcxeGlu1JfsLpF5L8E0IQ7OzP7MO0H+RJkAdQ2JdLnkdpHr1uhZV9wSQULeIRdWRUqRv3Nd9Rf+FBVsESvLbK/31LHKvBbfpkzX2G0uyl2/N5cLw8cdUgvrm++x7i+2I7lCLKgrwB0kKiI/kWRvAGCdR68zFHhlZSlGGYw34DChjQjQI/4Gmg4CuTBxYnLvL6kUxDiNNODj3fsQ8k/Wp/c43hVbg5KvlS1CoTbH9fEnbERWnOgJnsxGjzYOpVP24hltnjcGzq1OtlwzbJsofzMgWxVu1oB9quJV/lF6MxLgkBOZiawVqp/QsGdlOiDSZUubCIe8CvqRga0rAIbQhFAN0keqLGASUo9xybjiAmDGTnnOR7KSkYnjLkNHiOAjuRg3/2lgrZcznip6CzJ1omSeo53+9rJ9/oD/rqLPOjpWwtFcW5jb92n0OPEDxZXfHIcZis8Vm9qvmjZD6kz1ZNCTEl4U7D2l8qde17LD9FrRdmIScAVbIlzfQwAq7FLqZj2oO4B4yh9RsY2K7kRz2TOrDUTLn1ycybLbJR+k/uoQ4vwhKW8vFc9uMS6erLXl0BZLuCRgTq0FRvLpkkTcyABlu9MFQbKSjjjQVSBiWQxJG77oJ/3YGv2OrheDP9kYNHEzvCmh3gFT76mCnn7qyyEghmOyuoKEg8
 r/EFv8IJ
 Tkff9gktjLfplSArQJO3fw+IVW2V8BCZwvYw19ki+JAfDLZAGwn8UveKUwgheRjNF5xwlWuFKpDonYCoJbLGtKm8j1ej0bNcXMaqwwPHCd9u4bO8yeKHCiVQqmmjKDfrzAEFCSjTnm20qWWvF5VmCFE05JQYuL9wFpQ1yqByn8CNKhPPBA2vqCUKD17xVAcSN6NDALaY/REgCKajqX2OOhq0jGXfxEM0XfgsOiwGaMYZoZ5tlNsB3HI4bSB0T1RnnTb6yplVvNuZBxN9xf3K6h5FxmBO1D2wyShT/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 Aug 2025 at 21:18, Jann Horn <jannh@google.com> wrote:
>
> In the Makefile for mm/kasan/, KASAN is broadly disabled to prevent the
> KASAN runtime from recursing into itself; but the KASAN tests must be
> exempt from that.
>
> This is currently implemented by duplicating the same logic that is also
> in scripts/Makefile.lib. In preparation for changing that logic,
> refactor away the duplicate logic - we already have infrastructure for
> opting in specific files inside directories that are opted out.
>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  mm/kasan/Makefile | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
> index dd93ae8a6beb..922b2e6f6d14 100644
> --- a/mm/kasan/Makefile
> +++ b/mm/kasan/Makefile
> @@ -35,18 +35,10 @@ CFLAGS_shadow.o := $(CC_FLAGS_KASAN_RUNTIME)
>  CFLAGS_hw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
>  CFLAGS_sw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
>
> -CFLAGS_KASAN_TEST := $(CFLAGS_KASAN)
> -ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
> -# If compiler instruments memintrinsics by prefixing them with __asan/__hwasan,
> -# we need to treat them normally (as builtins), otherwise the compiler won't
> -# recognize them as instrumentable. If it doesn't instrument them, we need to
> -# pass -fno-builtin, so the compiler doesn't inline them.
> -CFLAGS_KASAN_TEST += -fno-builtin

Has the -fno-builtin passed to test if
!CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX become redundant?


> -endif
> +KASAN_SANITIZE_kasan_test_c.o := y
> +KASAN_SANITIZE_kasan_test_rust.o := y
>
>  CFLAGS_REMOVE_kasan_test_c.o += $(call cc-option, -Wvla-larger-than=1)
> -CFLAGS_kasan_test_c.o := $(CFLAGS_KASAN_TEST)
> -RUSTFLAGS_kasan_test_rust.o := $(RUSTFLAGS_KASAN)
>
>  obj-y := common.o report.o
>  obj-$(CONFIG_KASAN_GENERIC) += init.o generic.o report_generic.o shadow.o quarantine.o
>
> --
> 2.50.1.565.gc32cd1483b-goog
>

