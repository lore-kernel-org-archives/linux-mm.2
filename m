Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C725CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DE58E0021; Tue,  9 Sep 2025 10:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55DF8E0003; Tue,  9 Sep 2025 10:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944EF8E0021; Tue,  9 Sep 2025 10:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8365C8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:46:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EADE1DEA3D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:46:24 +0000 (UTC)
X-FDA: 83869987488.23.FFF90C7
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 324E72001A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:46:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dvTQXDKy;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQ6pjHDMM+suXT8naiE9csEpW818jUZBYVFNTfCYGno=;
	b=ZcIOWkjP8W/fNHmG2/dLUUL88+2zD8AQgMuaZiBy+OANo4eDY7U+4RXO/nO5ISpinERVkO
	Z4FTHis69Kw26CX+d/RveOyAqKRWMkhkWx0iQcnO1guosKEVwM2+QdjZLyAnCsEZQIMwP5
	Alk1xffYfqCosnYcyM+PfLmpVvL5fL0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dvTQXDKy;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429182; a=rsa-sha256;
	cv=none;
	b=SxpesjEfLeplUWW/+kxtXAJwHeNNt3tTg9n/tnw8armLknGUqXs2ipJ08+av5gsbr5GNSG
	MjFWtkrmg6J4tV3woriTxnwe72DvDxHA9vD1Rm2adzr6k4B6Oidx02+K0a1AxEig4xQY6L
	HnqqVtubesyecgTdLx36dmyQXSsIb5c=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3d3ff4a4d6fso3560288f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757429181; x=1758033981; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQ6pjHDMM+suXT8naiE9csEpW818jUZBYVFNTfCYGno=;
        b=dvTQXDKy6sBGtMjW6qzXKaXZJwVHES/U+kG6HYOYJ+2P+LiZEcm35D9wIMU4ZX9DoS
         XFsJtSCZN1C/Ty/CjvQ4VfQTfJ2b5Doz5YdQ8yZD8wwkn86PI68Oc0DFLURjM1JfL5YB
         gGF1PGX8SBtosilhYEp0c/o/R6xd6MxA0kGs9fvga2wJF2hmnuJw1qGhB93ukLxo3nFK
         DJF6EN1u0u1bTONMvc9/wMaS5+lyIhANF4eUUPzajw/dRHJjaDyxVKK2VWwjJlXR0j34
         siNQc/pTACvFncjRVVS4vXgpfv3YROCtbPZ0gucJrMSHAqRE2j1i7K0Et7yxre22j50g
         81yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429181; x=1758033981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQ6pjHDMM+suXT8naiE9csEpW818jUZBYVFNTfCYGno=;
        b=o2Sw3TRuKRHUhZlPrkCPnkah6JcM7jbmRRLpF7CZt7GGbUm3vuJusWpLr4Cx8yuj+D
         9HtEH5RnlSvsQHRF/h/zNc2mf7l8Bf3YgrEB7mS8dd7Z4HIsnAlC1YuFfSvAJPNkMvbs
         JUu6+3ZyoeowSqREb4f1zdxTcMSWKZ5OJeY++U4OHHyygJF2Yw0oRe7h1IuXgWdDNHTq
         kDCVT4flQKtQC6Avdg41vRHQy2qlWebyNLwjXMFoDa6uanZePzzmsxTAt3Ewj1qp7mRI
         FGcBrBuA0jrZdbwbzJMYnywT0dc4OBu0wAXxOl33mmRwJLzxi68Dcdg4LsxKSMOR+icA
         qmAg==
X-Forwarded-Encrypted: i=1; AJvYcCXQQMiuut/TTPItwczmO9spaqy1ZFLvAYdIzJsvBTyAH+/FJX2GORImisZ9pc+Fc62qOTZRYdFheQ==@kvack.org
X-Gm-Message-State: AOJu0YweoiQ9OJ0twXwVSSlVBHnINi0kSJVLxUvcQ2xbKYbOOmGOzmVU
	zPNc84PckKEHk4wxkbKLLZclJzcKlQ3ugaduAZbEJwC5p2aBnP1DLSjzg6hX1Zmg+xKhve4fFvH
	xumrcTrUypPRa7LEhZVQzYXnfuY2uJhQ=
X-Gm-Gg: ASbGncssDsKUSob7AgU8B4MlSwA6rR8iOB3G9A0gpY+Mo/i41/Zq3rGIq/pmCX1J+gm
	AG2fqCdLJCSN0jSPUYvGtjaW/KoeFagxsEKBiBJmhF2uq5rHE6D7/GiF0vUNOXirMw8tI9vx5qm
	JFwM3RjUGolM1ZSSUULrUrkhfsKNR7CGWY/zv6z35aXDP9EtFcTpigBboh3KuwDgHpQYPEgmoFK
	2rV75CIB/C3Bdc596c=
X-Google-Smtp-Source: AGHT+IHb1KmB6lnjW41yclSEzy+oVUecoVoO4XyT9rv1AyycY2cmZP7ch9LbWppf7fa3h/2TrIKAOfOqCRnTeUq53aA=
X-Received: by 2002:a05:6000:401f:b0:3e7:4991:87c4 with SMTP id
 ffacd0b85a97d-3e749918b76mr5400755f8f.61.1757429180544; Tue, 09 Sep 2025
 07:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <2f8115faaca5f79062542f930320cbfc6981863d.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZf1YeWzf38XjkXPjTH3dqSCeZ2_XaK0AGUeG05UuXPAbw@mail.gmail.com>
 <cfz7zprwfird7gf5fl36zdpmv3lmht2ibcfwkeulqocw3kokpl@u6snlpuqcc5k>
 <CA+fCnZe52tKCuGUP0LzbAsxqiukOXyLFT4Zc6_c0K1mFCXJ=dQ@mail.gmail.com>
 <m7sliogcv2ggy2m7inkzy5p6fkpinic7hqtjoo22ewycancs64@dnfcl2khgfur> <CA+fCnZc3ZY43KeQcWSw4kgcCqJpAvNj6gKd+x0AkjhuE2R8Hdw@mail.gmail.com>
In-Reply-To: <CA+fCnZc3ZY43KeQcWSw4kgcCqJpAvNj6gKd+x0AkjhuE2R8Hdw@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 9 Sep 2025 16:46:09 +0200
X-Gm-Features: AS18NWDf03t8X97flQzZHTvir2nukoTD6nPxpyweIbo71u3mhN5KV1t_32mprjc
Message-ID: <CA+fCnZd6qJRcSukbCuvH5n0KcGYxmrLi=_9vRA7HvRpSbYJNmA@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] kasan: x86: Apply multishot to the inline report handler
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 324E72001A
X-Rspamd-Server: rspam05
X-Stat-Signature: x5pfnauktd5a9hbcce7zg79zxjzjuqub
X-Rspam-User: 
X-HE-Tag: 1757429181-610653
X-HE-Meta: U2FsdGVkX19wa+k0myRn4s/ZDSFKdK49RZgZuIom0LCMfhVKVcqt4Oyp4EUQNUMSp9+8h2J63cKJa7GPQx13QZ3yf5BZRlA2aohk2/Gbw145utcrIPtLWFqRoxs/LoI05H2NlwwXVi73P1ofHujHHloqzAVYngCFOo6Pr9jh+bD4ntJmZWpj2JB8ftMFB2RP/1FiX31p2Jk0q1sbkyYbTMSwMFXu/BHkAkKAN7tg/oLJGWv5EFi/ACjlC10oE4B/IUMugwtFWuzF5YsXSJ9oTbt1PPS98dQl4LgAPIOHCfe1x192Jrr0rfEwKVIGL4MHsMp0mvlt/bk1XI4CAQbezS3VZ4O7/Lpa8CgmH+bInt9S6Gru4d5xkCIJI07ccqA1/F/TtWWqttK3vTEAqUobp5gkNfU6TlXFd2gFZznvmKlFdlqiuyoo4diOFHu71fVmjY1i3IglThjOPUH1/hNnSG8NIcVrTbxFw56k5ciqdiHVYGi4sQ7lZFoUZs17VATfSHzjrJlTbhiYHDiWnoXSCGnR0V8HHvkHtUqHENbZXLNpqbKBcBJoB/wNPy6lF+gIyyT2d3FeUop6gmag15BTgs2d32pPtnEOD7SnRRt6D472w3I1k+LZqlo7AENWLw0ZqCUBH9AYhN8mQCTcYSb/e4NDYbL6+d5rtrjuqss7il5d3nCdqwo9j7YeZrTeshQXXb2d2pupvVzuzqBuvqBO3FA0EsL80iO5/czJw5gJl3CxKPVO7i6WErJhd3HFPgrzaus0K53PrE3MrGgR348n2uvaA3z641f19TixFDqwPGGDLORSjDWYm9xcNV6kFhdsdte7W84aMN4XOGVK1KP/wa9mw+ocQxWsHCKPHMM/M9UDI7LRR5BlwkKode6UvekdGtUSG59NK7zAo7Kd81iMAJ9hOOYHJCDMoi8RPELPgtMl4u+O734HVrsJzekNMxoh1FJI4Il611Sjz/B3Z0V
 VO3hZ/Cx
 MgMPDK4rvSMquHCuy/iub03lnbgJ66X9dwhUT5RZlDaVepN7JYQ8d0alm3U1W5xe8pRO1/PljVMjqnAp7vb2voYyFc8+syT80hF7ckHUQqtQz93xQUWoMNnJ2bv5NMQlL/3vrwCqI12GF2N7pbG92bT39Xf90qsmkHlzEWXTiBk2Mh1nXsWjhjqZMNqnP+C0NdkHEHf90pUkk8L7IPkWbtoKsLTOgYM6EW7wKn0Mz+DXPknvUr/XdxKDa3el3tOIRg4p6xUdFjYtjG1bNxFzPkIkN2jWa5TVJ979dXPSlvEomyy46zYzpcRv1dZ6vym2wa9PCMzDJhwLMGYEOq8+jEYQJCPbUYVKG/UoEo6U7il+JqeQlLxUmDAPIJk0USxGktiwm47QcD0iDKD9ctViYAOdQO9dP1HBx2CkDvdaLlSHQUqybgGa0nPXb2huiEYxm8zSnhJyHKE8gl9sFLheonAFdtFQGV05t1K8sxkKMupA/Xi8HWtVGSKhY7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 4:45=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.c=
om> wrote:
>
> On Tue, Sep 9, 2025 at 10:42=E2=80=AFAM Maciej Wieczor-Retman
> <maciej.wieczor-retman@intel.com> wrote:
> >
> > On 2025-09-08 at 22:19:11 +0200, Andrey Konovalov wrote:
> > >On Mon, Sep 8, 2025 at 3:04=E2=80=AFPM Maciej Wieczor-Retman
> > ><maciej.wieczor-retman@intel.com> wrote:
> > >>
> > >> >> +       if (kasan_multi_shot_enabled())
> > >> >> +               return true;
> > >> >
> > >> >It's odd this this is required on x86 but not on arm64, see my comm=
ent
> > >> >on the patch that adds kasan_inline_handler().
> > >> >
> > >>
> > >> I think this is needed if we want to keep the kasan_inline_recover b=
elow.
> > >> Because without this patch, kasan_report() will report a mismatch, a=
n then die()
> > >> will be called. So the multishot gets ignored.
> > >
> > >But die() should be called only when recovery is disabled. And
> > >recovery should always be enabled.
> >
> > Hmm I thought when I was testing inline mode last time, that recovery w=
as always
> > disabled. I'll recheck later.
> >
> > But just looking at llvm code, hwasan-recover has init(false). And the =
kernel
> > doesn't do anything to this value in Makefile.kasan. Perhaps it just ne=
eds to be
> > corrected in the Makefile.kasan?
>
> Recovery should be disabled as the default when

Eh, enabled, not disabled.

> -fsanitize=3Dkernel-hwaddress is used (unless something was
> broken/changed); see this patch:
>
> https://github.com/llvm/llvm-project/commit/1ba9d9c6ca1ffeef7e833261ebca4=
63a92adf82f

