Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C0CCAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEC48E001A; Thu, 25 Sep 2025 04:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6B38E0019; Thu, 25 Sep 2025 04:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD2D8E001A; Thu, 25 Sep 2025 04:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 290188E0019
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:35:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAE8713AC60
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:35:50 +0000 (UTC)
X-FDA: 83927114460.06.FE9B4E1
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id B5B02A0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:35:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FchXrvra;
	spf=pass (imf25.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758789348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDyXKD1mpeXok68wul2g//tY5b9PgvJaaF56RchZKHQ=;
	b=nh8894gC+DlfCtZ+8eBGM4O1RbsIvlGkCFLBf69wIOP85GBefinM/mmFFkoqUTWXoLBNTZ
	PfafKzCKGJcJ+un5iLki0i2Arwu8RTDgqdhu8geXgpc5LQ5eMN++vKfw4aZ6kn9mPtO2em
	4bCfRczXmr9HcBZ4XGneca75LeI+m3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758789348; a=rsa-sha256;
	cv=none;
	b=H/3W148dOr64aw/s3FbfBVPnsnNMOjkD4JsHdqyAkrO9SmFujpPYWZHn2Y03WJW6h4Q02r
	BIzPzhU++w4kWlR4lAzjKYI7/N8XPrU/nh4ioP8UzqQnr7GWgSMdACefrNsRQSU4UKXlhb
	qbyC+QgEDFCexkSiO1m0A8y9/kbA16I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FchXrvra;
	spf=pass (imf25.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24457f581aeso7792055ad.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758789347; x=1759394147; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDyXKD1mpeXok68wul2g//tY5b9PgvJaaF56RchZKHQ=;
        b=FchXrvrar1p61Zz9InVtnMyZjRxejbSSnV922xjP9GKwTSy1eYPUFVyI9Az6koLHHm
         KAQTZ1LWSqB922IQrUVlqbdYUcLoXqLaxfXE9LYuuFxZp9PXvQYJX6Zhg8LNhEUKNken
         /f2lepm6h+aorWLMMLXoyBsxycZp/RRTgGwcNsgAGutJhsk8VwHGkMA/ZZyHtuDOWlGW
         SYlJ2uFY8kYDS3BbnoPlrjbo0ZGeOcDDwOAlNSvg53y9AjkM8TfNwvi7KRvMq05dIaLj
         TvINlt6hBhM4uXtqEVIgd8L4GhzRz/uGsJvXkEFQRGy/xJxT/YRTW41edYt1cp7Po8e8
         H9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758789347; x=1759394147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDyXKD1mpeXok68wul2g//tY5b9PgvJaaF56RchZKHQ=;
        b=HpnLH0Tc1qpECn49dO3e2lRVJ9Q7lJiEjQemz85HOAa67MZxyjdj7jqDwFyQWBnvSi
         kA2pHmItfbCWtIQFywKsebzKwHdDi+WgS7brl4lzfCgbpnQgNF/52FH7vp01t1FvoBT5
         oDP77aYuJ75fI3scaLXeZ2Y+Tv/lgbxbCy0liG19nBCH1Sub12/V+CfwWsyTpEyXLVaz
         ta6P2ABmprGS3yxHiILYmL9yBJtefLD7xLhGnceKWxTBRUPtmZGo50AQgJzCowYpxhc1
         06s4/1M+emjEGbwNk9a0oWAZ+R8CG7TCSPhkUmh5BiNlIImutQsRdU0Kw9pNHld2anvM
         enMA==
X-Forwarded-Encrypted: i=1; AJvYcCUPPj6OGgefNLpbNycYOZjp6BZGyQ4s23sRQHEWxlgSIO7w0GfPTk7Q//YwtUtdNk6aSgnKMdCN4A==@kvack.org
X-Gm-Message-State: AOJu0YwJYJ0mpl3ZJRPXDLuOGl/fOp+xkCXQ0H8kIyMGM0XySOpaC2n/
	m2S3zOtkb3mGW0u0EIQH15MtsrmdJbZUcG10JnZMjn9Inal51DXfYT9XdKdTnulZrha/+E6pavp
	uzxU1OCO9DPwMwLFK2k0zlkC6wHg6wwU=
X-Gm-Gg: ASbGncvGr9nek8XNTAp5POuOzSEBulN2snhofLYSoWI7N5F95cbiweNlow+QdV9gV2M
	9+e//jqGvjKI1I1Uj0kznNsPxbmgSXyoyQpVcffRDjfW+sDYvBSpLK0oxBNX6XW6qh+n0LTVJE2
	Poe+Bn6v6Eihn5pnockEuJyG9xBmcKjRaI1AYPqpo4cgl9GkMiHeGKXY4T7/ZsFUKDcKe69TqnF
	RxLSuOVupNd45jWZKR4psS93wVznIOdHEYzQg==
X-Google-Smtp-Source: AGHT+IFiKBS4LhKCc+e3TZ8akuJUR4dSaETLbnVbbjovQRnE+6jXoJciIAqdsOUJ/nrSn5d9rrftqE7Kz3oPsvH4jUY=
X-Received: by 2002:a17:903:3201:b0:26e:146e:769c with SMTP id
 d9443c01a7336-27ed4ad75c2mr30527635ad.52.1758789347230; Thu, 25 Sep 2025
 01:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
In-Reply-To: <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 25 Sep 2025 10:35:36 +0200
X-Gm-Features: AS18NWBFmYuT702hOj_C5JBwnZByzVghQRTr5ikBT0AN32tqz1vkZcQ1S7Omg5I
Message-ID: <CANgxf6xOJgP6254S8EgSdiivrfE-aJDEQbDdXzWi7K4BCTdrXg@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au, 
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5B02A0004
X-Stat-Signature: ft89k35dmxat4s86qowd5sqicc4mzoot
X-Rspam-User: 
X-HE-Tag: 1758789348-197230
X-HE-Meta: U2FsdGVkX19nOhXRs2pXr75dWLf8DEcHsWgyN/BPL3NXHsJmRFhHBHTQfb9uslJ3xBsRES+meYW3esbgBBBYzYTeFebwgmfQ0Wq2qnbE8EIw7TuCnrXtAqeOufI64KJ+qpfxn/RbMkq25Gkhep6DtQ+guKmI6vtoSKubcXeU1ZLMA2HPxdLrvAVBzOVqZiJzv6UYo0WV7gufgpdJdlBPMmNaPe/M6ugRSxnIB38g9kwgpKLPvoKMOrZhpQWwcGuckBlHdt41cm5sBZ4IkIRjvJn9z0YVP+RgQsqetddwoIGQogVUoMTwAoRCAMrVTVB2F55gLTVtGpT1GE5XWdHmcl57p43TVKM9+HIGtpL6onPaoVhoRFNOyz5G2I/PqiowZazrTagfp1Un2PXWJpymm1cw9ZdVPm6yVb10sL/zrJQLIf7Kjmrvtua15XK9+7CpF8WLq3UesRM1tonSdf+6MXq9QP2pZCL5PSbkc4CsDQ2JnTkSlS7T+j7nUbXeaewWDX2qxXwwaJjBt61DIf4ewpsY4YRpb5nyfCkQmKetPf6q+sZhu7jl+R4TQazl8iUGSnvOdcaD/JQP7ErFBvIoQvvj7eF0Ig4kuDE2RyrPAzkNfyHR3WQSjQYnn4nXf1+IPtNAy9BjGHrWyUdMTaI3k56TOwh9E6dTMbaGuF2cK7RCYVnuWIKDIzQ0UQd4N/JXtHfB0QISk+cu2dIpp652F/85pPK7eD20qBBkDV+ZJyfxuZ0k5ZUgjlApSiPf5QS/AnEzLzOXj7IIaveD5qWstFUKtTett1zWBUYXKWZwCy6Yj+tLe0VWtQlKPcsZZJIUI76B22q47Qhh3uOnfVLo76z6kJE7Ajj9A3X4hr+AgXj7LRFGRT8xCkT1T1ya7jXJrtXFx3qmAZOaIBSw9H2QK1jDWe6TB5wkCgrCwSKspHAnASXbjG2HMX0dKpd7WWbdhMr++dDb3P9EkSvLBKG
 g8seIYUY
 VKNw2U7Y7BknpLURCg6IxMN8UpFLyOPNUP2+LmeAcuqn3nUGyOdHD4pSDlCHSKlLgLSRQAsNSBcSEWcoEagRAT4qLAN7qy3eMnXOOvQyTdhP2DjiXHqCQK0ME9oddN2+g/vKlfaYYncahgUgwmbec1/0ueuFuEExBPILXVr9+nfg5D5na15uJzEBXUL+jcCkBD0cBaNM3EFXvvmDAYZ9CxNhfCfWRn0zClNR6BfDq1EG7IHFMxNC14y7d1H5XTBTa/0nMyYnhP7jzNsqISxDJAXsHbdyb5OrgYX/UPJ5kYG7hn82xMACHGfButzspb4JintGaIuKKk0sUACuw8pCZAhr+j7zbeP53ucLPj8FQD4PPmEtiMoW6/Unb8390t1TaUL7wX14QoZxkdI4rVksKK1dpBvt+2l6+Apq14iwlNV0oH8p/e8DGA3/6QtA8HFY1jzOaZNAF/bdvfvDWX9WriiBxIhsd1rsRMtQr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 2:52=E2=80=AFPM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Fri, 2025-09-19 at 14:57 +0000, Ethan Graham wrote:
> >
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> >
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters) that are difficult to exercise effectively from the syscall
> > boundary. It is intended for in-situ fuzzing of kernel code without
> > requiring that it be built as a separate userspace library or that its
> > dependencies be stubbed out. Using a simple macro-based API, developers
> > can add a new fuzz target with minimal boilerplate code.
>
> So ... I guess I understand the motivation to make this easy for
> developers, but I'm not sure I'm happy to have all of this effectively
> depend on syzkaller.

I would argue that it only depends on syzkaller because it is currently
the only fuzzer that implements support for KFuzzTest. The communication
interface itself is agnostic.

> You spelled out the process to actually declare a fuzz test, but you
> never spelled out the process to actually run fuzzing against it. For

Running the fuzzing is more of a tooling concern, and so instructions
were left out here. For the interested, the syzkaller flow is described
on GitHub: https://github.com/google/syzkaller/blob/master/docs/kfuzztest.m=
d

> the record, and everyone else who might be reading, here's my
> understanding:
>
>  - the FUZZ_TEST() macro declares some magic in the Linux binary,
>    including the name of the struct that describes the necessary input
>
>  - there's a parser in syzkaller (and not really usable standalone) that
>    can parse the vmlinux binary (and doesn't handle modules) and
>    generates descriptions for the input from it
>
>  - I _think_ that the bridge tool uses these descriptions, though the
>    example you have in the documentation just says "use this command for
>    this test" and makes no representation as to how the first argument
>    to the bridge tool is created, it just appears out of thin air

syzkaller doesn't use the bridge tool at all. Since a KFuzzTest target is
invoked when you write encoded data into its debugfs input file, any
fuzzer that is able to do this is able to fuzz it - this is what syzkaller
does. The bridge tool was added to provide an out-of-the-box tool
for fuzzing KFuzzTest targets with arbitrary data that doesn't depend
on syzkaller at all.

In the provided examples, the kfuzztest-bridge descriptions were
hand-written, but it's also feasible to generate them with the ELF
metadata in vmlinux. It would be easy to implement support for
this in syzkaller, but then we would depend on an external tool
for autogenerating these descriptions which we wanted to avoid.

>
>  - the bridge tool will then parse the description and use some random
>    data to create the serialised data that's deserialized in the kernel
>    and then passed to the test

This is exactly right. It's not used by syzkaller, but this is how it's
intended to work when it's used as a standalone tool, or for bridging
between KFuzzTest targets and an arbitrary fuzzer that doesn't
implement the required encoding logic.

>    - side note: did that really have to be a custom serialization
>      format? I don't see any discussion on that, there are different
>      formats that exist already, I'd think?
>
>  - the test runs now, and may or may not crash, as you'd expect

>
> I was really hoping to integrate this with ARCH=3Dum and other fuzzers[1]=
,
> but ... I don't really think it's entirely feasible. I can basically
> only require hard-coding the input description like the bridge tool
> does, but that doesn't scale, or attempt to extract a few thousand lines
> of code from syzkaller to extract the data...

I would argue that integrating with other fuzzers is feasible, but it does
require some if not a lot of work depending on the level of support. syzkal=
ler
already did most of the heavy lifting with smart input generation and mutat=
ion
for kernel functions, so the changes needed for KFuzzTest were mainly:

- Dynamically discovering targets, but you could just as easily write a
  syzkaller description for them.
- Encoding logic for the input format.

Assuming a fuzzer is able to generate C-struct inputs for a kernel function=
,
the only further requirement is being able to encode the input and write
it into the debugfs input file. The ELF data extraction is a nice-to-have
for sure, but it's not a strict requirement.

>
> [1] in particular honggfuzz as I wrote earlier, due to the coverage
>     feedback format issues with afl++, but if I were able to use clang
>     right now I could probably also make afl++ work in a similar way
>     by adding support for --fsanitize-coverage=3Dtrace-pc-guard first.
>
>
> I'm not even saying that you had many choices here, but it's definitely
> annoying, at least to me, that all this infrastructure is effectively
> dependent on syzkaller due to all of this. At the same time, yes, I get
> that parsing dwarf and getting a description out is not an easy feat,
> and without the infrastructure already in syzkaller it'd take more than
> the ~1.1kLOC (and even that is not small) it has now.
>
>
> I guess the biggest question to me is ultimately why all that is
> necessary? Right now, there's only the single example kfuzztest that
> even uses this infrastructure beyond a single linear buffer [2]. Where
> is all that complexity even worth it? It's expressly intended for
> simpler pieces of code that parse something ("data parsers, format
> converters").

You're right that the provided examples don't leverage the feature of
being able to pass more complex nested data into the kernel. Perhaps
for a future iteration, it might be worth adding a target for a function
that takes more complex input. What do you think?

I'm not sure how much of the kernel complexity really could be reduced
if we decided to support only simpler inputs (e.g., linear buffers).
It would certainly simplify the fuzzer implementation, but the kernel
code would likely be similar if not the same.

