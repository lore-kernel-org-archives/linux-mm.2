Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7977BC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EDE6B00AA; Tue, 21 Jul 2026 04:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F7A6B00AB; Tue, 21 Jul 2026 04:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255886B00AD; Tue, 21 Jul 2026 04:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F254E6B00AA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:43:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 670B8403C4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:43:52 +0000 (UTC)
X-FDA: 85012145904.20.727B8E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E1AE20005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:43:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USYURl6k;
	spf=pass (imf03.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YnrIcak9MnTuq1PIcIeffGKhfewNQREoFw5G3CgkVE=;
	b=cka0XjLhREdyB9iS6dGNnY6O53trX6FRgZtTEyNP7rqGjd2Oq9EVu6fAsb/PNCSEZnkdyD
	cjhFYSITW7Cbi+Y703IhIz5ElmQ+EJlvDJCTVTr74oCwbFmH2gUZg/e7r5LeT+bNQ68IcI
	DH+ezDigf0+KWPlNn+Nnwwbps/Bpb3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623430;
	b=yzU/QENJS4PIvH/a0vGKG0moP/cc4mc11C+CfQIAwFdLXBx7ctKTIylvQucbXvNm0n5tPJ
	kkkPnL2H3ImdVhkOIFezg5oIfxF+I9vT08LIRf8hrVUr5F3gXzGOkCDnYmx9AqoIcWOBg4
	ol/via0di24bRNBc6R5aRr+ieC/vWJM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USYURl6k;
	spf=pass (imf03.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98E144502C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE361F0155C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623429;
	bh=4YnrIcak9MnTuq1PIcIeffGKhfewNQREoFw5G3CgkVE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=USYURl6kL/GvGuhsLkNzCmOf95k2kPvCE25wF4wem7mnhFXq0MaGrMDyEm6Rm3Oi+
	 i9TjOtrHE8C+3wH6xrI9W0YKGB6RvSS8rh2RT7MckLPo0EFXa1dcZg1Vg5UCbXOZTr
	 8dH4AbH22PxpiMF6VP+IGlGaauP5R3Vi+lTwEYUy2Cy6NTXtvdf6KkEpUmcsgnEB9T
	 Na20C2XIockmKxlojg/uI8BDY9W5LZBqfXw+x/mq6r7pigTIaarkpTHf64/ExxD9GH
	 pXWax0LzEdpuNJUPujmg1wV1QPRmyA59ptfETIuy2YUv4AKtT9aP8UtCGsOQ0ebl43
	 eC9LMg4wEyz8A==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aeb2bc82ccso9519341e87.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:43:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpFvbvA6ViHXX88TSn4w3AYDo+XQ4R7cDIfwvyPkbNzv/KDAhkafkizjJm5m03ErkcJ/Cvxs0AF2g==@kvack.org
X-Gm-Message-State: AOJu0Yy66uYejF9d/Q04F5lvwUIKcCG5IGDaUV2dSpYAIoWzpTHYj0cn
	rQdmBtq6C3FZ5dWpOgNFq+tplgZhocVGnVYT0fpxx+iUsusLrZNBTrdb3eJY0ya2xfzoX0+TFMV
	/a1MlWVsZqo/lLlJJrxb2QvlBsbOOeN8=
X-Received: by 2002:a05:6512:124f:b0:5b0:f9d:f7d9 with SMTP id
 2adb3069b0e04-5b28f9a723emr4081425e87.45.1784623428144; Tue, 21 Jul 2026
 01:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-7-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-7-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:43:35 +0200
X-Gmail-Original-Message-ID: <CAD++jLmHw3ccWQj-AWvgrj7z6iwPk=MC0-UMaUqLeNpsbxW54g@mail.gmail.com>
X-Gm-Features: AUfX_mwlDg8vIJsXHYz3fmkT6fCMHFLIFkEllyMO4HcnVtqsYTlYVhuDg7LEE1c
Message-ID: <CAD++jLmHw3ccWQj-AWvgrj7z6iwPk=MC0-UMaUqLeNpsbxW54g@mail.gmail.com>
Subject: Re: [PATCH v17 06/15] arm64: syscall: Rework the syscall exit path in el0_svc_common()
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, oleg@redhat.com, 
	luto@amacapital.net, wad@chromium.org, thuth@redhat.com, peterz@infradead.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com, 
	yeoreum.yun@arm.com, anshuman.khandual@arm.com, james.morse@arm.com, 
	tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E1AE20005
X-Stat-Signature: f8bet46fsemdyook9h69rbrd4wjomo5t
X-HE-Tag: 1784623430-635079
X-HE-Meta: U2FsdGVkX18B2UJwTgeUlzATpMPpd3VLK5grr8zPdk+Ahxj7/Z+sbdS49PkHtuKuAKZStgrP00juSE9yWYDHgikjnJXGoKyr29WMOLCooT530FqQpkjYzvWzF8ErOxqbjwPewE5YWIq006+mDDVYyWRt/LDeCwj3b52I89WiDzPB+WYX/KtyH0uGPsWmZ4qaJTM01YAueanQL2S9+Leb+Q0gsYAPI2fPmdbBDziTYDhUZeezkIscjmaiNGQRclzcUbqjgtajeHAs6wdxJq6+QiuYHroc3tFSug9CEZwlSQZrllK6PBZXLkJjC2yFwl2qv0ihSqJpsMTyQLaxii4kkK1dwsWmtF4oNjJswjXQgqEUxnJoumi5eXRuwPpMPDHKIzwsfMmuwIqOwcpjlN/PvkwZLB/J2BCfxTPhk1NF+IK6MF8EyZ3RGejErOpsQ2E/F3jV3H26PW0PE23u3AEM5HA8ZHldZWZbNmHna/1c2tvUPS2U/iyznDHBu0aNIcs+vYyubSdQ65mwyGjumEz4RbobWrAdBL+6CWLmhEXX8bBHmVHybQd/RLKLRIYU2VfrBLtJRHAkaKolH/LO7B35kSICKM3t5GOqS4hIsUBdJPVVeljYv3cTa29P7JgmjRt6VW4whGjgzlArZKwJAybUf6UnOnkwURj7xoAWCzMTDNxn2s9WZpvt04dGe++nwx/CwZXiNTaXQomv+kh9iL+rAgnuRYNvufwX//HHh4y8MycsaySm5TbNxzr2PKZKacPEKaK03zrHFaM+Sz5FEdSS9PwyQie2rRThBovGAdpnZkHYt+NAo3VSJApNmoNff6zUX2S//PC/ohFpfcPyPyI4g8sKvGfLOinJSdn+IiEDmOA/KMZvMsZCh9xWKG4tEK586ZX/tZSjJLnAo3muhT6OgvulhXZCEwWSUoaxUBrG4pO6tXPkk/wZ2inTN4oSn6rdZdbWgAK0z3HGt2nZNeZ
 pofBqCZh
 7YLqLC6hEMnFY5D+oa8FJ5id4jpIpPe9MZGXdcYCj9CiWw6GTxxwa2GZY6ryAaQ3Wyji4VtiwqvDEGmGz43LsyJdFUi6JiQ6j084h8sE4Rr/t4yM+90XLlwDbwpcCpp3/aksekJEhJoErPFUWunDkpgsSKeyic5PFBeRxfS5JjptoWNBXUcrpKuWD6iXPmllE+xC1J+0Sbe8t3IT8l9K+IeSSbKSIrDn7Ih6s1CELJUXN2NQPmsojKwCNZldMC5jZLaWJY1Hu9pWiuvOOUAOpgaogvlPHileukiAToPLCX5LmCN7c08728DaQhaLBkgCIJA6me+iWa5He4WLgRc6QP584GmVuVKV0q39U/RDHEn86jkoFZpIt+qqKHH9hhbhHWvBm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:


> In preparation for moving arm64 over to the generic entry,
> invert the nested conditional flags check within el0_svc_common().
>
> No functional changes.
(...)
>         if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
>                 flags =3D read_thread_flags();
> -               if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP=
))
> -                       return;
> +               if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
> +                       syscall_trace_exit(regs);
> +               return;

What about just:

if (...)
  goto trace_exit;

This is easier to follow IMO.

With that:
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

