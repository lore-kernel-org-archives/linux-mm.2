Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AEFD6552F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 10:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D136B0005; Wed, 17 Dec 2025 05:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527E06B0089; Wed, 17 Dec 2025 05:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2A86B008A; Wed, 17 Dec 2025 05:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3226B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:19:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2C85140995
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:19:49 +0000 (UTC)
X-FDA: 84228566898.26.3E8D1B7
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB5B540010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:19:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bNW+UFO1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of glider@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765966788; a=rsa-sha256;
	cv=none;
	b=hqA5KT0T5vrkeDqYNTqfDzd/eyV7B5KQ1BQfmMAZF+hoxDluJ119zEOfW/xvs5la5x60NU
	pfO4TfLEzi3DfD9nlLWsNnnYX+jJFD20ud3zr++nRO65PEw/fUeyw3c83vtiF2/+zQx4zQ
	z6zbhS9tsZAZPy45UDKFKk7BfF3f8sY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bNW+UFO1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of glider@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765966788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23gqEg6vrrMOt95UIpPZRnWZYiatBfrUBDzMVbZzD8w=;
	b=zEI666FbJEZRD27hquwKFDrsaVgrQGE2QVjntd7ix5AvCPI1lB09kDCzpAqtsFcjH7E8nK
	OT8Cxr2fZVvn6WtQ5QmcUpjJjIbGJxcl/F3nwNyMxWaukStglI/9Fu7T2NXjJM49m3ZOuq
	7rH6v8KI/DLpH1PCE2f2Dos5DYL9nmM=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so53575381cf.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765966787; x=1766571587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23gqEg6vrrMOt95UIpPZRnWZYiatBfrUBDzMVbZzD8w=;
        b=bNW+UFO1XROix/hvc4t3Sl+8r9d3BvKd1azNv3zdBRhpaghnp9oeds/1Bg7qmK3uIC
         AyKXzYuyLmmSTrgMcBOsnKnLgniyY5KBFE3pDqPQxc1QLLQtbV6rv4J3/n8/U00lPgkl
         LABrbW9t9w//KVbNES6qZBiZkVTRmcFJqT0EA1yi9u4dCjMfH5Qq2Ld29WFUBbw6pblW
         KqnKM/LRzWXydCditgEsglq4eWe2gg/w5JQnYH6nck1zmz4PEPc5hIW8y/5quDju0Wag
         ThpJjlt1c51Psy1NxitQSZHOZgaYEJeU3ZftNITZuiDCXP+HjswvYoB4rsV5tzB8m7w8
         MVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765966787; x=1766571587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=23gqEg6vrrMOt95UIpPZRnWZYiatBfrUBDzMVbZzD8w=;
        b=mZgRCG/IiD3wKg6CqxAKNkO/celaSlkp1rj68DGImEYNaWNvG2ECyYKrpcb8s/gTNp
         8bJRGFRF+rsXNsXTQSUEn4js5ainnG0LIKqahCDE+60Udj1B4iE4XVYKS8xZ64liAfZX
         aeKJ3hPV7JuiT5fgvBEvl9x/9aSZFyGB6WEHXJYQy35pAkoSmqXOJS+bY0J8/ivQY8Bu
         Rtr6Pv7+oNiqyldcKXnZ40aC4737Kim9USHNbCBNFOMmbrxWqGswpXvZlf0HBbrpa100
         PJDUJ/D1ADvoZ6eXAhSS4VW9K/LBFChEvzyI6QnjLZZyksCMGC3s0ZNWYfuagjhQmfgF
         XlRg==
X-Forwarded-Encrypted: i=1; AJvYcCWyG7h2Bh1PlxynBDcq/efLIwOqRz4duY6HebzSgEnEnLMx3pI0RJgQ+EjOI/rPoOFyM5NevPCZmQ==@kvack.org
X-Gm-Message-State: AOJu0YxSK2DVAVkdAykWZ5tMTzwjShdOB/uV/Z+ANrtfuHL2yF92ARk1
	H9UTXp3noZbN0iJqnbJPDleTD4OAoEsW55BWOTCeOWd25jE1jZKwdtERTBGVIFyLgRhsmeHuUXX
	NdXLztR2PaDN2tqPHXOXvXDbg6t6xlZwPqSPp0TXe
X-Gm-Gg: AY/fxX5Yj3cDHdt5+V/uJ0AzHf8vqL9CsQHWT8Y1haNYtJGzgbe7n+cYKWivttCLpDn
	nDtOa8hMd9TkoGsOYyBskW4GI87R+VqzxIQg4IU82qkiHa4TVhhaz2sOAp5UsYrbjtCdf6tCdcU
	JpeUNKBSFY816gkZ/jqlmY6qwZfRsJHIbG7RlvMnvXpjRxZEMQY8Ud+hSf3aEyw+ASW4ysnbghD
	+yo+e/fFQRgX+Xq/c4rHxa8Cr3LH66Vu2I+5RfQBIM2bcHFTcrbav8RBr4VHaqLFoNyMPAjs7iO
	UPj6L2uhTQc7R6q5rw+3NSBX
X-Google-Smtp-Source: AGHT+IGPDd7JF5alyNhEgjcrVW09ThoKJGuLHl1FsoSDP2QjJlJMFmAXfyQUqSR9tS29F3NlT0wkkL8H1bva58+snIg=
X-Received: by 2002:a05:622a:5c94:b0:4ed:a6b0:5c26 with SMTP id
 d75a77b69052e-4f1d05e102emr259116031cf.58.1765966786794; Wed, 17 Dec 2025
 02:19:46 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org> <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
In-Reply-To: <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 17 Dec 2025 11:19:10 +0100
X-Gm-Features: AQt7F2rCVoKiHzMLr5gq2Ln7RdeonRMo17AX2R1_t7knfurC9ARwqPf8_xuG9S0
Message-ID: <CAG_fn=WvdKZgmkqa09kwLLH3P_j6GFYzopeD-PZ-Qt0-1KUaGw@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
To: David Gow <davidgow@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Ethan Graham <ethan.w.s.graham@gmail.com>, 
	andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz, 
	jannh@google.com, johannes@sipsolutions.net, kasan-dev@googlegroups.com, 
	kees@kernel.org, kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB5B540010
X-Stat-Signature: kisc1nibp7kuo1w7qhsen5emzex4ttqy
X-HE-Tag: 1765966787-493179
X-HE-Meta: U2FsdGVkX1/GNE+a8EkLH4XOsUZ3TTNeVae1SbSieRTsw4LR4+3Uu3zYDUNRPTNiCkx7OL3xCAupCAIFhXBmxHhi5+/RDwfJXYHQfFmeQSVOVEj7/djp1ftnMGMOFqwk4czqs8DpVqIeQ1T0mZvfQz0R7OM3C8RISSrsQbkCy1J9MbS9L9/+g/bUNuksYtMOelQgY6bHSZzUMBcWum24yq4gmjTs+RxpjGk3nhvp3YzH3m99iYzXTSYYoi+2pv4OPIUOuwresWxFSW3fyFK89ClebeUAiGhF42MTNsHhcG86AJjhPttN1sqLLHl7ztfM6ntLb9942KXuXQpaDwa/Mgb5YV1F4mpiroOqWKemNqV4ZZvqmYCIG9pV/yNAJN9T4Tjzz+5sZGY4GTjoP1biCmPitF1/VcwMFeE1zp0ryH5aSqVTNeF2LDPUJmFfLiVIuZ/fm9JPv14S8sM4skivdCca0ei4uY916cmt+pDfSYyGe2ZiA9ry+Lzh9SWw3a4BIWcnHhHtxme+Td8AJmw+QABvLp5BDw2pygtmSLRgjv00HOKX0C0jXvrlWnfttQVRMa4uOSMHxCZeWMzOzgTUnBFAtbbo//5Q5yrgzasZW+z8e6QUqA32CrGa6rPUHrpd0r6ag0ZrwkdlyBuGELsyuUoGaRdxofZeYiBfjl8i+G06ifdwMKGmFc/EZXUViwvitM7GdsESdecDHhvprtw/fOJdnE4C7Pijd3IYjCIbCZLOV+dPWDhBb4WsLYW0xHrtaCOol1+VeyF3EsJf3w0XotOVqzsfszv9ycGpf+apOoONOGFoJvv0BepHZmmJG4ZIKUyu6T2s/3RM2Juu2B3evfhjI9g2DwAmGrb6DZeWp0mbXzGm0W5/az5zam6TI9pEmb5LWNFj8El42Xw1G3sKZ6f4boO6BzPNG3+HaS+7R2D5Ype+OccJ0HCuhI+TOYULBoGzwNXyDihy//2/Vtx
 Be3TmwHp
 ck6X85dtuRdCKtSODae7DXLzdPOI1w20CFm1ssnnzvdSi2E60gqQ7fgE2m58KbJDHMpslSdvJttrqZuyG1DeHlQf1weANQddSz1BSlcBDlmMQsZwM9bf0++KnoBv11SU93/OWyBDMKy28Evb9bDdv19SxTfTudRsXYT/7EWjOBWgeKXbSG7y9lMizCZevzfZamY2mOt8ujfwLcYGDrMrkQoHDXnFCuCchBppNBYzBcK2Z04VhQGtVpXPStx1dGTe78VQ7U+OgYbai/8WEaIN4oDfo7XkbCAdkbS5Y4oJl0akXTBCZFmiqaDWnlL2rqVj/xJVa7zAw3rUEPFUju8Itl912460yIOdwfC93
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 10:54=E2=80=AFAM David Gow <davidgow@google.com> wr=
ote:
>
> On Sat, 13 Dec 2025 at 08:07, Shuah Khan <skhan@linuxfoundation.org> wrot=
e:
> >
> > On 12/4/25 07:12, Ethan Graham wrote:
> > > This patch series introduces KFuzzTest, a lightweight framework for
> > > creating in-kernel fuzz targets for internal kernel functions.
> > >
> > > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > > low-level, relatively stateless functions (e.g., data parsers, format
> > > converters) that are difficult to exercise effectively from the sysca=
ll
> > > boundary. It is intended for in-situ fuzzing of kernel code without
> > > requiring that it be built as a separate userspace library or that it=
s
> > > dependencies be stubbed out. Using a simple macro-based API, develope=
rs
> > > can add a new fuzz target with minimal boilerplate code.
> > >
> > > The core design consists of three main parts:
> > > 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
> > >     macros that allow developers to easily define a fuzz test.
> > > 2. A binary input format that allows a userspace fuzzer to serialize
> > >     complex, pointer-rich C structures into a single buffer.
> > > 3. Metadata for test targets, constraints, and annotations, which is
> > >     emitted into dedicated ELF sections to allow for discovery and
> > >     inspection by userspace tools. These are found in
> > >     ".kfuzztest_{targets, constraints, annotations}".
> > >
> > > As of September 2025, syzkaller supports KFuzzTest targets out of the
> > > box, and without requiring any hand-written descriptions - the fuzz
> > > target and its constraints + annotations are the sole source of truth=
.
> > >
> > > To validate the framework's end-to-end effectiveness, we performed an
> > > experiment by manually introducing an off-by-one buffer over-read int=
o
> > > pkcs7_parse_message, like so:
> > >
> > > - ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> > > + ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
> > >
> > > A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> > > introduced in patch 7 successfully triggered the bug inside of
> > > asn1_ber_decoder in under 30 seconds from a cold start. Similar
> > > experiments on the other new fuzz targets (patches 8-9) also
> > > successfully identified injected bugs, proving that KFuzzTest is
> > > effective when paired with a coverage-guided fuzzing engine.
> > >
> >
> > As discussed at LPC, the tight tie between one single external user-spa=
ce
> > tool isn't something I am in favor of. The reason being, if the userspa=
ce
> > app disappears all this kernel code stays with no way to trigger.
> >
> > Ethan and I discussed at LPC and I asked Ethan to come up with a generi=
c way
> > to trigger the fuzz code that doesn't solely depend on a single users-s=
pace
> > application.
> >
>
> FWIW, the included kfuzztest-bridge utility works fine as a separate,
> in-tree way of triggering the fuzz code. It's definitely not totally
> standalone, but can be useful with some ad-hoc descriptions and piping
> through /dev/urandom or similar. (Personally, I think it'd be a really
> nice way of distributing reproducers.)
>
> The only thing really missing would be having the kfuzztest-bridge
> interface descriptions available (or, ideally, autogenerated somehow).
> Maybe a simple wrapper to run it in a loop as a super-basic
> (non-guided) fuzzer, if you wanted to be fancy.
>
> -- David

An alternative Ethan and I discussed was implementing only
FUZZ_TEST_SIMPLE for the initial commit.
It wouldn't even need the bridge tool, because the inputs are
unstructured, and triggering them would involve running `head -c N
/dev/urandom > /sys/kernel/debug/kfuzztest/TEST_NAME/input_simple`
This won't let us pass complex data structures from the userspace, but
we can revisit that when there's an actual demand for it.

