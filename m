Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F7CCCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 21:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9981A8E0011; Mon, 17 Nov 2025 16:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EF98E0005; Mon, 17 Nov 2025 16:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8843F8E0011; Mon, 17 Nov 2025 16:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 78F838E0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:07:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C0874CFA8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:07:20 +0000 (UTC)
X-FDA: 84121334640.26.DF2DA58
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BD85C0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:07:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O4nnZ7ru;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763413638; a=rsa-sha256;
	cv=none;
	b=8rwhYORgok8fN9HC3YqXZpmrMY7nRvA4z8qzH8etm4D9Td3A6NBbe0NQQskaHjiZKjfW/q
	hhaju4lD9J6Ov2XB2dhl+tGLaBmbn6+aN8w6sYQ8RFGDoaOvf6DYtBkxj87tKBk3SEuBah
	jPksPZmEbBIraYDsqyH6QpgdPGA1M70=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O4nnZ7ru;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763413638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+3ZnbBnm9x5rG+AzfKnEqBF2B1DtWvuci9iSsNvxto=;
	b=ImtMX3YWrMovOLptGcqKC+api/RJyIRKY7sZRuD5pamunjagDB8ZMwKA/g1R1peavkhiO3
	TCl/oEDh3ff5bNsSyQQrsfXLxoc5/r5UWtg56Wo1/Rg3k/fv2hctMosLIbX8izFdrpSjvm
	/iL/8RuiKOxMdLYldloIrXZGYC/s6UA=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5957ac0efc2so5233537e87.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763413636; x=1764018436; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+3ZnbBnm9x5rG+AzfKnEqBF2B1DtWvuci9iSsNvxto=;
        b=O4nnZ7ruy7UMxrICFNyWQLn7d3Zbo3mWEoajV4oveO55BfhENDYtvj/JCY5iFyljyC
         Mq2MBS3DmrOvnCCTSJ0ad+aGUvti++B+l+BFOj+xZaLssnGR/F7ffttFM9qbK6YmQeQT
         0CiJ8u3ygke4rlhYdV1U8ah6hTxc88WANUcTWXXLkE6hezTWbW1nGRWh7XUTk9uz/EQ4
         rE6lbQuJ3s7/kZDsoT++fE5+Tcmyf8qEP6anv8b68RDREPwf6oCIKiZMglqz6J7a8sSn
         t+2osGsg0tSvbKVHKa10A2YuDJQRYjQfboNVLvVOadwiVHbpegTEg2ccqzqrZ/paMJ/d
         Tr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763413636; x=1764018436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I+3ZnbBnm9x5rG+AzfKnEqBF2B1DtWvuci9iSsNvxto=;
        b=jqAOMKpkCBAT4Nren4NEJcbRqEaygIXDePecq2stxEYOIbDIYad89GhxMgcNchf5pa
         dzr9154qnUWK6g/UDiNNTcA3ImrQMVhTzKvw+g7W++RuhL0cwqcZx3A02NognXHU/0Pm
         4zne0/g0XaFJ55FgmjymSwoxNiZC32EHUidoW+/A+LEsBccpboig3GjooXTn1Ki3o+sB
         3qxksLpT/Y8bOeXh8FyO9yJri6aVkoFZMhksF4f/SFpqn6wWvWJLfFDMHBiZSnmQOqaU
         czo2cANOcYctUx/tj2c9u/I/XKerIllns2CUa+9QL6fLa1oxCq12YOJ/1hMgcQOlJMv1
         vAHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWo2Z5f5QkXHOotnaQjnaMJfPJLO7seSA/f/LHCDVoexGw8hve+Q6lzrETfjHjs4QjzcI1n749/iw==@kvack.org
X-Gm-Message-State: AOJu0YwK1dZf3HhLr8lka5dTDoOJaXLPkKO6AXCMt2i6fp2bLOOy9Ll6
	0t5+k7M/NLFY7phCvERE0cAM+1+4BMJAgQ1aSvxtKITVL02Q8qxX2Ux+52MwbauF1yVdOHOT09b
	Z98MZHIjfcw4YwZcGt0AFD3kNJfI3G7RiFCEcVSbN
X-Gm-Gg: ASbGncsCFPlqH7UfYZcpMpcj51Sz8Xr0NRuGkS+oCGDqf5/twAz27+QJl+OStchSUa7
	kFJmCei4KGXP3/Nk8NUbsf6NHaXcfLqkuoMbSU81kdb1iiH/nM4H86yZ8ne71c9KerDquOBXeeV
	Qs0f+E/LAAId4/mL6Rql2v50YV8pFOgzBrteNeyeR3XP0VwQCPa9UphYmFBq+pvBnOCms5RuHDs
	OKYaXMuEpmNwinLgpchxeRMjN06BJ7fpJetHJiCUBFRzWuVtAyPISR1EGvA/tJLj4PhRGvFq5X/
	1VCGzQ==
X-Google-Smtp-Source: AGHT+IEyRglFL6CLF2ix5p5nwaJTHq0lTJqTXp+UMeRzhbiWib00PWpc4ebiQNIEHbNxWSgpi8VFmGwgM1LVS1XHG0w=
X-Received: by 2002:a05:6512:2216:b0:594:522b:c6a4 with SMTP id
 2adb3069b0e04-595841c0afemr4885332e87.23.1763413635580; Mon, 17 Nov 2025
 13:07:15 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com> <CALzav=edxTsa7uO7XxiUSx+DZiX169T4WL39vYsn3_WcUuVKrg@mail.gmail.com>
 <CALzav=f+6hQ-UYBpwmAyKHPmtvEq-Q=mOL20_rZmAcTyd87+Vg@mail.gmail.com>
In-Reply-To: <CALzav=f+6hQ-UYBpwmAyKHPmtvEq-Q=mOL20_rZmAcTyd87+Vg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 17 Nov 2025 13:06:47 -0800
X-Gm-Features: AWmQ_blb0RWuMLLJQNAkTQ6osFyJ4ZWbxByNX4sxBWFP3gs7sBB_s2cCPqr0fg8
Message-ID: <CALzav=ekHM8a3yYHHUJNgtYVwLYf1hFhEmrXJjHUXRt=xrSy4A@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1BD85C0008
X-Stat-Signature: neygmwktqzr46mtzfcjtyxpyknt5pqik
X-Rspam-User: 
X-HE-Tag: 1763413637-242167
X-HE-Meta: U2FsdGVkX19PRXr0JUVPr0MDFBp3at8P/rYDgNf/yB0mSu604jydtH7tsUtixoQ8m5/UTBY8OTCIXpB6oCUirzwzCSRoFunWkbqq17Ps+iD7M3E26Zoo2Z48qabp1bCKqwgiNb0k5kVrNCTCZzUl9EOSE+MhnCMsHPaHUng9YNIvXS0m7qA7QgZ2pbc8lhYG/6bDTSbbKjtaiuAzIENYkGXMFi9RIv4A59mpFzZaRoQfjoIawg/Igx28D/H2UKnm6xFgKvrReuycmSsj+Nni0CsNC1c2RK7ONH0gXlLusCkbdj/UXFSxctj8OD4iPZUGQST8ug5vGqnIj41dRqj00EpeDCK0k4sPyjUixqfZQJfCiruI1MbGGwqaLwycUO5ZmTZgoKB1ETCFhlAClRoErl2KovzUyb7wYuqdhO3mGJhe5raHsljjyoO6dHpMsztYsITKuf0TG23IbWyISPxeeIGQUCcZs5OLA1v3CXic8Gfqrn8eMmiedllPHy0Ec5t2lz0tIv810+c4EMp55gvWrNutwaJLHVk2QSGbWV6JStJsxP192MOi664ROJZOtI9yAFykNAnn/CvnfInh3ZrTwG3i5Qdw6qIzxl2GtC7US5V7PRiiBdWEB5c2l5S5Y5xx2xjVzZ6/vYr2GZPKVt+AYmPHrgWv/EzLqC3z+fu4QHclYNFB02bG5Bbwl9C9/y8o2zNgMXZDXMhba5Zof8h+oODuMrz+oFnq7Uuhi92AFKDnA//ezbs1tqkiQqncgg023dRXLEV8ZZpUfB8BQqJaX2vlEVQLnL/LaKgPZsyycYJmmh33bvCFoNqrialjl1sO/yCSrDUm/+Xg+pAwAabWO/Rjz/UHdEmOsPTO1+nHnmmmmQSkfs6n1nAqU3mC2nHpyz5MDq5tgzrVxg2lKj3y5K3oEHy7azG5qENHtqPMFS8b861yhRtO5tDMMHAJRi2Gz3vkor+UniZUP7+xNaU
 RRmyuvPR
 IsFP7QhgjI4nCYELHgKYU928bxwwK5CayFC7Md4uXh23pEabGY316L9spWAN5VcxE+D7AWCxTO36eUVfgD2y0fggHSiChUyBi0T9yxaEsCM0QOIDercfcbLUb8ovPCtI8k7gCfWbPXhtoOFdm5ECZBQ/b10ZmtLFbDdBPN69RvJmaBRZb/LBCPiHz/62MJ6q6MEiU/n1j809SEXd8VQ6VCdxd4Ljifq8dCat+mO+aNu6kRefL0/7tiQmGgrF1W8hgWK4yiBENxfMxL7R0nbj0+ye0cgBXnI5f7+lK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 12:08=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Mon, Nov 17, 2025 at 11:27=E2=80=AFAM David Matlack <dmatlack@google.c=
om> wrote:
>
> > Putting it all together, here is what I'd recommend for this Makefile
> > (drop-in replacement for the current Makefile). This will also make it
> > easier for me to share the library code with VFIO selftests, which
> > I'll need to do in the VFIO series.
> >
> > (Sorry in advance for the line wrap. I had to send this through gmail.)
>
> Oops I dropped the build rule for liveupdate.c. Here it is with that incl=
uded:
>
> # SPDX-License-Identifier: GPL-2.0-only
>
> LIBLIVEUPDATE_C +=3D luo_test_utils.c
>
> TEST_GEN_PROGS +=3D liveupdate
> TEST_GEN_PROGS_EXTENDED +=3D luo_kexec_simple
> TEST_GEN_PROGS_EXTENDED +=3D luo_multi_session
>
> TEST_FILES +=3D do_kexec.sh
>
> include ../lib.mk
>
> CFLAGS +=3D $(KHDR_INCLUDES)
> CFLAGS +=3D -Wall -O2 -Wno-unused-function
> CFLAGS +=3D -MD
> CFLAGS +=3D $(EXTRA_CFLAGS)
>
> LIBLIVEUPDATE_O :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBLIVEUPDATE_C))
> TEST_PROGS :=3D $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED)

Correction: I forgot that TEST_PROGS is reserved for test shell
scripts, so this variable needs a different name.

> TEST_PROGS_O :=3D $(patsubst %, %.o, $(TEST_PROGS))
>
> TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(LIBLIVEUPDATE_O))
> TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(TEST_PROGS_O))
> -include $(TEST_DEP_FILES)
>
> $(LIBLIVEUPDATE_O): $(OUTPUT)/%.o: %.c
>         $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>
> $(TEST_PROGS): %: %.o $(LIBLIVEUPDATE_O)
>         $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $<
> $(LIBLIVEUPDATE_O) $(LDLIBS) -o $@
>
> EXTRA_CLEAN +=3D $(LIBLIVEUPDATE_O)
> EXTRA_CLEAN +=3D $(TEST_PROGS_O)
> EXTRA_CLEAN +=3D $(TEST_DEP_FILES)

