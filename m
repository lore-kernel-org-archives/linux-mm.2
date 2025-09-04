Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D678CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613AD8E0001; Thu,  4 Sep 2025 05:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EAF76B000D; Thu,  4 Sep 2025 05:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527808E0001; Thu,  4 Sep 2025 05:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 412646B000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:11:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B289413BDB6
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:11:46 +0000 (UTC)
X-FDA: 83851000212.25.B35F6A4
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD9BD180010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:11:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fRiNRT2Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of davidgow@google.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=davidgow@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756977104; a=rsa-sha256;
	cv=none;
	b=qUmPfhrW5D2M3bnbltWklQtYZ/P8/Um56liO20D6wMQJklTxCJIQ+8U/OeSVCqIKiczQnX
	nkf5f4/PVxnQov3avPR550H1td4drGtaYexeAbAya8s3wBcYtS0kq6T6vxtCqu/1D+kRgC
	i8oHFHf92z1x26+AXExbm6DuRn6+rCk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fRiNRT2Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of davidgow@google.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=davidgow@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756977104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiBL4xUOfg7gCGVbKRZ2miCXhQoK6jtoEjlt5pZuFFU=;
	b=OqC6JLbXez7idVJfZIRWaLJyHMoQH4q0SxcGGWlITfnVNF7JLEAtUo92iNyaSCXCq7LEd5
	fOTzE60Y+scrS0oXsXthe8yjiBJv6IuGFDxR7WqqoDt4IXykp1hP+nbe6ChZ9XUDTtpYuv
	kFgn/cxQZo6yFh2cBGMhaQxxtcEFFSg=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-80e33b9e2d3so71037185a.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 02:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756977104; x=1757581904; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OiBL4xUOfg7gCGVbKRZ2miCXhQoK6jtoEjlt5pZuFFU=;
        b=fRiNRT2Y3rUyWIp68oL2VsWxAs7dL80GXKjseegdkTZOBrjU5BvdxyEyPo2VpAyn+1
         pJo1rg/KuS3pxsS8kQgzbo8H2kbRTp3uEFoqc8Lshh+SKccf8HtdkDiFdOn8lI9NnFZR
         TF2dlkAzVXmTZ2kBx+QpLcKrOkjt/r90gfN0yOtCe/FOJsNuRBkN+O5x6GdhjArB6uW7
         Cq8v1vE6/QnZ/yaZ2ba8/G+dcYars5QF3BFNE4sWXcasrQDTabg+b/YfA8EtLKo66fSu
         1znRiAx/arV/xOjDJbgYiAXkE2o8kZpoBAUlEKrF+BJPwFbf01wJmdgK+7TVcDi1McLK
         Hiyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756977104; x=1757581904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OiBL4xUOfg7gCGVbKRZ2miCXhQoK6jtoEjlt5pZuFFU=;
        b=iMmsDoCqLCZHoZYzP3RN8B83HOVL5ZlaZa58HOBskY4zbnwWKSJgp0bi9vq6kq7I42
         Cgn/vBnYA9IcazFKyg5dspJl2dQ2CE1uo8boxifvE35lVXewJHEuR8IqECzlA36G0OvJ
         x86Dws+j45gxRYiczL7j5dO7lXJxphR/R6fW9ekfidM0yWlk4SB+NZNMeRk+gQeK5RKJ
         ehVODRtSvJkwufRc5ixTYtsuFGYXtiGb2gf2e0kc53plJWbNApXYMf5vEEIdsJtcMWxw
         EqBBPyW11ajVxRrB7QfIElC6JmT2Y2aDdmyG6G9dMwKQq9TgLPyNa8EQP89Qqig129Da
         C4fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRWh1TXyw9zmDX6GvNgCAxNyVL0uu48N/HwiPHn8CrEa4NDe6Xm5cQbfkLp3uYDhZrorl0fsjikQ==@kvack.org
X-Gm-Message-State: AOJu0YztExyut48nIL9kxNnSkkKl956h8xUbJ1nBJ59S4klpTWh7OC8j
	+j8OvQI2/uRBbjSjlYS7gPRQRthEO/sO06nrAzVT+ZMAGV2Mf6qe4LzaHRRNYjC9Mm2gYriwbdM
	LpYbhpHO1UgCrBobNbZ1yCTLxpzV/VYB944fJ4HP/
X-Gm-Gg: ASbGncuHMt9dJRlHINfgSHzvbuBD5yHJdh6h5N0aL7uKPADfdVdA4fQyfTpydzqIhyW
	L5vxCwWWn3qiK4Clp7anfPH9XwtqIUIVdbaEwUF21ut4KaNGeI42ZROI5LlwCcC05fvH/+rkxIJ
	p+PgQ7FvEUiU5ugsv/CS4nWlPUsdcVkIo+Kc5t3cNsl5dBNFHGDux18qRF6dCFVMBsXCXUjBX58
	pRO2/0oHk5Edxgf1/tdTNQ=
X-Google-Smtp-Source: AGHT+IFYlGXJ486TQ9EK/95uU3SyFcsBM0z1rBaAV0ho3WsC4leYY3WLao7HT7YaJJ2NIcq6dX8hgE65KVC5TnV8Eb4=
X-Received: by 2002:a05:620a:284c:b0:7e6:572d:abe9 with SMTP id
 af79cd13be357-7ff2869bd22mr2202626385a.37.1756977103394; Thu, 04 Sep 2025
 02:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
From: David Gow <davidgow@google.com>
Date: Thu, 4 Sep 2025 17:11:31 +0800
X-Gm-Features: Ac12FXxFg-YSHUgrBqJ-5TrzXWGp5KCpZbo80fhtQ-VWPd3R1wCW9QCV-W4F-oA
Message-ID: <CABVgOSmZffGSX3f3-+hvberF9VK6_FZYQE_g2jOB7zSMvVuDQw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, dvyukov@google.com, jannh@google.com, 
	elver@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CD9BD180010
X-Stat-Signature: eyzxb3rfujpqc8kbk4ky9reqbnxbxs6q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756977104-630521
X-HE-Meta: U2FsdGVkX1+hfKvmJbEUFDzu2WkYYyMslJwsaYhw3Mi7SSHF5Cepk/N3cwIl4Gw5xJTRW+LKFBYlTgPURM9zW6/db8xjLUMdrtpj9QBt2ww0vNPR+2XUm20Md28EffUy9D36hMNQnDfYQYVTqYNHBlfHkWJbRD5Fu7Aw5EQWBr7JMHqgIEkpElM77M/oKjqNY4dIZ2qXJEqNMO1lsfgZHhsuluMg3lI3aMaJNDw5Uus5YFQn8n2eDRyEgzfNP8BkjsSzF+dFqMndC7b+Zfa1CosPbiUYc5DKbLkU29MnAcSIxjF64nWLrYpOT+RWdjyCIkqz+CKXqzB8c0wfNtzfR7w/cuK5SG14e6p6UMGKvSs/ZfGB/+fsZcAFcT3SkMJl9rbfrmiqev6lKhnXu4eRN/kLqvb+gnyPozQyJjjrilyQdfeXmWNcgeUQ0OgbQKOlwoCxGk4ShA1wypQfKjFuyVJ2wQ+lWuBDGVy9QZc2Or+m1fc3aCz08xjyK0gLqN+ZQCDXKtZYmOh48CQ/rBv08mvoiCMgHkBBCfTMyMk1A7FXb4FWLo3K3jPs94m5p+iQChjzdOAUy8jAu/auzSQZ5dbWeKqN/7oeIFAKrv39zHd7455u0rWjvRVNBMFq1P2PKZCqAMvLoAySnF4rru49tBfYUkPxDJnHFGkaRyJ8Tffquz5XBzbw8xF208GFwrYMkmjaA93rH9LohLq1nCkCLWHEXbUZ9P1/mbSlSzk/eIpd/8a1AmYBfRaVRjA34by0GBhVTcEJ4evmXU+EHjZUVcJiRvHwUiyewP8Mj+AcrVLPMcNYWZFtPEZqrz3Z2oxUOqsfypJoflUwbXwkBfaiGWnE4oMGdcZVfyFr1sYit+dYktcPUgc3vPvF59OR0gwiIaJpOGycgf0Fg1C5g3vhNa0/Lt+ykICFjdApEt8wWvCAR5/SxuDfpMd8BU4cLWRccXWXOOhqPdKlZNmwEGW
 5IWtd9Hz
 CgRvbL95IBXiO1tJWfHX/6drmchsaZouMu70EE53JwMMvVsNPIwdFaLbiAu2euPiqvGCHef2KRpfUVYBErWqVtc4utUlUiQxDEfmP8YNzuaAoRA49FpeQVQftS2yOFNOSkrbuTWSLD/zoe0vI8j79wUjZvO+VAwPNeumNvo7utLDhHZg04eFZn5s37dJ3i2WlExc7vZVpz9U+zYPuYXivlqDZN3X4KUa05rY7Cxykv6kmaisOzalCMTVhEzW0T+wvNebi9DMltCp6MZWHe0rt1eXBmxTnQhFMKSOnY0W/vVCNlAUp0RIJGf4ggTpkRxlJSjGW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Sept 2025 at 00:43, Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.
>
> The core design consists of three main parts:
> 1. A `FUZZ_TEST(name, struct_type)` macro that allows developers to
>    easily define a fuzz test.
> 2. A binary input format that allows a userspace fuzzer to serialize
>    complex, pointer-rich C structures into a single buffer.
> 3. Metadata for test targets, constraints, and annotations, which is
>    emitted into dedicated ELF sections to allow for discovery and
>    inspection by userspace tools. These are found in
>    ".kfuzztest_{targets, constraints, annotations}".
>
> To demonstrate this framework's viability, support for KFuzzTest has been
> prototyped in a development fork of syzkaller, enabling coverage-guided
> fuzzing. To validate its end-to-end effectiveness, we performed an
> experiment by manually introducing an off-by-one buffer over-read into
> pkcs7_parse_message, like so:
>
> -ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> +ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
>
> A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> introduced in patch 7 successfully triggered the bug inside of
> asn1_ber_decoder in under a 30 seconds from a cold start.
>
> This RFC continues to seek feedback on the overall design of KFuzzTest
> and the minor changes made in V2. We are particularly interested in
> comments on:
> - The ergonomics of the API for defining fuzz targets.
> - The overall workflow and usability for a developer adding and running
>   a new in-kernel fuzz target.
> - The high-level architecture.
>
> The patch series is structured as follows:
> - Patch 1 adds and exposes a new KASAN function needed by KFuzzTest.
> - Patch 2 introduces the core KFuzzTest API and data structures.
> - Patch 3 adds the runtime implementation for the framework.
> - Patch 4 adds a tool for sending structured inputs into a fuzz target.
> - Patch 5 adds documentation.
> - Patch 6 provides example fuzz targets.
> - Patch 7 defines fuzz targets for real kernel functions.
>
> Changes in v2:
> - Per feedback from Eric Biggers and Ignat Korchagin, move the /crypto
>   fuzz target samples into a new /crypto/tests directory to separate
>   them from the functional source code.
> - Per feedback from David Gow and Marco Elver, add the kfuzztest-bridge
>   tool to generate structured inputs for fuzz targets. The tool can
>   populate parts of the input structure with data from a file, enabling
>   both simple randomized fuzzing (e.g, using /dev/urandom) and
>   targeted testing with file-based inputs.
>
> We would like to thank David Gow for his detailed feedback regarding the
> potential integration with KUnit. The v1 discussion highlighted three
> potential paths: making KFuzzTests a special case of KUnit tests, sharing
> implementation details in a common library, or keeping the frameworks
> separate while ensuring API familiarity.
>
> Following a productive conversation with David, we are moving forward
> with the third option for now. While tighter integration is an
> attractive long-term goal, we believe the most practical first step is
> to establish KFuzzTest as a valuable, standalone framework. This avoids
> premature abstraction (e.g., creating a shared library with only one
> user) and allows KFuzzTest's design to stabilize based on its specific
> focus: fuzzing with complex, structured inputs.
>

Thanks, Ethan. I've had a bit of a play around with the
kfuzztest-bridge tool, and it seems to work pretty well here. I'm
definitely looking forward to trying out

The only real feature I'd find useful would be to have a
human-readable way of describing the data (as well as the structure),
which could be useful when passing around reproducers, and could make
it possible to hand-craft or adapt cases to work cross-architecture,
if that's a future goal. But I don't think that it's worth holding up
an initial version for.

On the subject of architecture support, I don't see anything
particularly x86_64-specific in here (or at least, nothing that
couldn't be relatively easily fixed). While I don't think you need to
support lots of architectures immediately, it'd be nice to use
architecture-independant things (like the shared
include/asm-generic/vmlinux.lds.h) where possible. And even if you're
focusing on x86_64, supporting UML -- which is still x86
under-the-hood, but has its own linker scripts -- would be a nice
bonus if it's easy. Other things, like supporting 32-bit or big-endian
setups are nice-to-have, but definitely not worth spending too much
time on immediately (though if we start using some of the
formats/features here for KUnit, we'll want to support them).

Finally, while I like the samples and documentation, I think it'd be
nice to include a working example of using kfuzztest-bridge alongside
the samples, even if it's something as simple as including a line
like:
./kfuzztest-bridge "some_buffer { ptr[buf] len[buf, u64]}; buf {
arr[u8, 128] };"  "test_underflow_on_buffer" /dev/urandom

Regardless, this is very neat, and I can't wait (with some
apprehension) to see what it finds!

Cheers,
-- David

