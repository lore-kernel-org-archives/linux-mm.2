Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7E9CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 16:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBEA8E0012; Mon,  6 Oct 2025 12:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3948E0002; Mon,  6 Oct 2025 12:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9668E0012; Mon,  6 Oct 2025 12:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD488E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:18:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A76DD13B8C6
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:18:36 +0000 (UTC)
X-FDA: 83968197432.25.7E8A20B
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA2B7120002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:18:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kMcMy4Kl;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759767515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrjZ2N3nijkKvhfmQO1vA7QLR5P8LLIRs7v5R7YmxE0=;
	b=MtR/eC8UkejP7iYRXQ7wr/UxZ86hwo7ZUgyuUMxIV3MWzEoIz115p4FG/tSJIGCgLyAkG1
	kxy5Dw3doLGiwXEFJJ1gBxlJLtxCorZjlXGGhbwhRqghdSt/h67AMwo6+AXqquneL4dEdG
	3euZseYVTW53Al4pD6J4Wpx2/DqUTZs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kMcMy4Kl;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759767515; a=rsa-sha256;
	cv=none;
	b=tHfFDwF16iZTZUOfoGFfkDc4GZlf7bucqcKjMbMiO5Ca90PjHSiAnuNBaEHWNM3ERNGqYL
	HdoOXU9hfvaUvRLfPIXqI2VXI/7BrfuvegxnsT497vqCSDm7SXYDyAPELECRPM+cEuvvSQ
	GDJXGxu50izd9L+ZDgxBb1Qy7E1VXrc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4de584653cfso81155031cf.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 09:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759767514; x=1760372314; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrjZ2N3nijkKvhfmQO1vA7QLR5P8LLIRs7v5R7YmxE0=;
        b=kMcMy4Kl5ChRFwh0BPqs9x1TrTx4C8Whnjp+8FG5rVAmQKFHpuETasYaZNfATeU09F
         GrqnXGlHPn7zgQrTIYRX2VIjUGvDgh1xtFRvrrlbzRR4XOOehnhkdQu0qlbUBTF1E4IF
         qysgca+uit6Gc9je+OUJIq4u34q2Yw11A14yNcH9XaUhtTn4+DpIhHNCSo/mHpLf8bKP
         SytBfCVJBrjRtTCcguD8QQuGzSis2t5d9EbppKi3T2/C6Md+m+JyaGrYZr2NmPQ+Wsl0
         DD2X8xZSOKkuYZKLNBGDmRs2zJBISdjUU2Kwq01Nb733Cs5M8MDpKj0S+nGymxNatakH
         fePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759767514; x=1760372314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XrjZ2N3nijkKvhfmQO1vA7QLR5P8LLIRs7v5R7YmxE0=;
        b=M7fNWq9ij/e+tAJCt2ZbEZ2XQMjREOwf0tN0Vp3CRvhpYML564uQOtqpWbPVq14mBs
         csC4SzqUqpDqVeSeed9H1zT2O3WJKdmb7keKha6uGFgEBlWdUBG0dd/OQvFJxsXZgKM9
         ydZoj6t4+R14sB4NEuU3MLrisKmiN0YeK1TN1iDHpbGrnhTZv8NzOdy8zHOKfZndkV5l
         CWu1aZeDCyNGN7bOPtnNz0l7dJRsIAUCxJy+rpp1wNG/c0CJaQ+YyUiQqRPmOuNEcK12
         qIFPUEn+Y4LLNlnyW+N0y8XASUykbkj0FA0gZOZXslOuf+8pPLIyZIqz1eKP1t+KG/DO
         VLtw==
X-Forwarded-Encrypted: i=1; AJvYcCXYhX4wx1KnqVic6H/4HE70qnvd5Sz8lW2AhpliQNx7XiCLkhcbjHeAVbIX9upoXbyZVDmV3qI4lg==@kvack.org
X-Gm-Message-State: AOJu0YyFn6duX6kRFQPqhVWoQlGGY50JILQnVEGw+XH3CnHxnkN10Usx
	H9IG8iBJMAllNNvxrvfz4J0+lc3yF26pMPlgrMzUeb3b0a9vSLGI3xuH2Q+C5lx66/iuuuiDyW+
	nccxq4kVeSSEHOZceRoSAWhiR2740RPGxoEJKmTQnHg==
X-Gm-Gg: ASbGncvpGSssONXSS0MXs14siYQqDRtr0l8toj7Wsb3RfHB2QcK3QxxbdHFyJ7C6TZy
	iyNIkbVwAcLDx5NPmlMR8Rs24Wul/RI8MB2jdIGSHOEUGz+gfI6G+i3NgAdTB+gAQ0X7RjK8se5
	yTdFtOP29AczYmm7WPGFTkwGYHsQiJrJ1B5qWInlUJUO9hC+k2iQmfYA91YO/i2qx9uoamrIB4f
	4yu+OI6+zqX+BMfUtft/OZdnjf1EWh1MOou8wc=
X-Google-Smtp-Source: AGHT+IFwm4V/zCKBkbgm7pfKIp77PJD1NOmB2z+7xVCEcG6LKB3NFoKIKgya5mufGjYCV3AhGt61yn25CRIzX8BM9QU=
X-Received: by 2002:ac8:5fc5:0:b0:4b7:a7b6:eafc with SMTP id
 d75a77b69052e-4e576a5c404mr198174771cf.13.1759767511840; Mon, 06 Oct 2025
 09:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-4-pasha.tatashin@soleen.com> <mafs0bjmkp0gb.fsf@kernel.org>
In-Reply-To: <mafs0bjmkp0gb.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 6 Oct 2025 12:17:53 -0400
X-Gm-Features: AS18NWC8dVdnh9WrIeR8a0qx05q3jEVozl0VBzvOu40iLLzMHk8IAd4vKASusLs
Message-ID: <CA+CK2bBS-v_djpvw3v-xumPizzmOaiPsuPpoxnSUub-LocghjQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/30] kho: drop notifiers
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DA2B7120002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c7zwrjj6dbxo9zjhzigwasthg3rfajx6
X-HE-Tag: 1759767514-728758
X-HE-Meta: U2FsdGVkX195UugZ8Svo8ROzmr76AV1DD2m2Q+a1kiKOZRL5ZLTcwZbT6PmCgc0It4EmMilbPvZLoNP80cNBPApY80tRLPEB6T3I+jQttyQHYhBNAP2wvK3MhX5XgfYj9OaYp8yWIDyZcodv1cYuWadxcy5xfy9PxfNIwThGecZfb59XZWCjsJaOajk31Qr8gxUj7nPlsy9uLFJM6Y3UFX1B2G3Arm9Ad/c6Hs7+XlrakdjW3GlxaaCd+jHL6X3/RQu9B90SQq7bz3vwxxinmbkCPrp2HWFA0H5B05E5ypFYzf4hHzmNkfYoRUnO5mhalonCZ4utDETU6Isj8xWFP+hlu7PAeyEOCSltcRFY0C5dwuEI8If9MSWghpke64yxzYwUd+pekGqvOobAISGT+8CwEv8XckHYG7yIQj432BqJHUwRIgokkKgXi6mPpfifRFpRloxVIifRRI0BrSTgvwWo1ygQRwBmUL/8YFnxNDUeDRXY3++9WLb70TysU0tmH5CrevFRkkPoUNDjIV+gAj7yc66PYPGrvDPKGD20QnwEYlbZpX6iQ2rDAm6deWf9cKHV9f+9kZ2E8zLZWyoX3pEoQtLI3MklVVXR/VEZiZk6YaFXL5c8WdIUoXnMZHlJABdaiFP5DYRDNpJiBTsWj2A75JT1ciOZAMEyd09mhScFzIePzMmNUSts9PcFTw7ETZ+XsEopXObBMizP3acd+RT2Xv/ETvAw2NTp3MpOFkIo1lCS9BZcF/DbFnXsN8JrkHDXoEvM3cdMrhbyHNlJkvzoFduh36DFe74ZeWupzehJFYN256RjO+RmOG6jsdTxUBj57utR7F32vly/eEvAxIKwyTVajGluZxCYazLRNhJzdTU7Cxx8I+Z8M7zVcIcsIBIPIOGHP2WqnPrKNRWFdiMDkp6Ubehu+cin3b3ER5Rn5TTM2uCcrjn04e0Kt3bbSU+CJa5D6yBN71c4mCM
 V6FPGalJ
 OEnfu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 10:30=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > The KHO framework uses a notifier chain as the mechanism for clients to
> > participate in the finalization process. While this works for a single,
> > central state machine, it is too restrictive for kernel-internal
> > components like pstore/reserve_mem or IMA. These components need a
> > simpler, direct way to register their state for preservation (e.g.,
> > during their initcall) without being part of a complex,
> > shutdown-time notifier sequence. The notifier model forces all
> > participants into a single finalization flow and makes direct
> > preservation from an arbitrary context difficult.
> > This patch refactors the client participation model by removing the
> > notifier chain and introducing a direct API for managing FDT subtrees.
> >
> > The core kho_finalize() and kho_abort() state machine remains, but
> > clients now register their data with KHO beforehand.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> This patch breaks build of test_kho.c (under CONFIG_TEST_KEXEC_HANDOVER):
>
>         lib/test_kho.c:49:14: error: =E2=80=98KEXEC_KHO_ABORT=E2=80=99 un=
declared (first use in this function)
>            49 |         case KEXEC_KHO_ABORT:
>               |              ^~~~~~~~~~~~~~~
>         [...]
>         lib/test_kho.c:51:14: error: =E2=80=98KEXEC_KHO_FINALIZE=E2=80=99=
 undeclared (first use in this function)
>            51 |         case KEXEC_KHO_FINALIZE:
>               |              ^~~~~~~~~~~~~~~~~~
>         [...]
>
> I think you need to update it as well to drop notifier usage.

Yes, thank you Pratyush. I missed this change in my patch.

Pasha

