Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D70CCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6548E01C1; Wed, 13 Aug 2025 02:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7408E01B6; Wed, 13 Aug 2025 02:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4368E01C1; Wed, 13 Aug 2025 02:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0FE8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:13:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 195351A027C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:13:19 +0000 (UTC)
X-FDA: 83770716918.05.C068362
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 225C418000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:13:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HaGErLvG;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755065597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5Vfudbw3qeEII0c9j4i52O1FO47zCV2DiZIss0JO4o=;
	b=aEPnSf5r2i12UZ11jM4zzyG4B4I/51jEwox29zCnSn39mGQJCfW2QTWt8AiJoGQH/v2ro8
	CPnJY98Dcar7kr1TBAPxGcrNTX1P18K2R7J1ctWBsJDewvfQ7tGnUz9u7mqRp0ID7Cwf4w
	ChVMw+CSOkJkNVpL2qBlPXLzmZ8cJy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755065597; a=rsa-sha256;
	cv=none;
	b=3aKaeG3rA4HRXs0Gbou95paK48WWBz5El5Q5D+EeG6fMKiNKkm+7KSgoJEg/uedXxEW6ey
	9DOeHk+EP8mqaFEI0iRcnBtDQNF+TBH5pK5vphwmsPQMDJqsHwFSY/U8aEuXHmYJPfcnL7
	HkDxBI9kMSRelqGfgYnoUdOtMwz+umM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HaGErLvG;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AED6745BA8
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9037EC4CEF8
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755065595;
	bh=W5Vfudbw3qeEII0c9j4i52O1FO47zCV2DiZIss0JO4o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HaGErLvGaAU8iPq51GvZbOSF8bgVJTdYgNNjhQONjDVHpp6iQN/Xd/wUTuqRvdWwG
	 C5V81/RyUZ0veu6c1t4lLHx3JQgOFa6JsEAQRoSlGtJbPfD49eubq/ffu8hefxwMBO
	 Cg25lrQyWZUQ98P6ecd9UUZuyRU9rjWGGoJ8RvKHZruQGjub9xv9Fg/l3ZkEIGV/vb
	 h1NNKHmExWIpR64z4XAIku1hW23VUHHBnaNBnlq8kNLPNdZQPD8R+72C0Qx1FyjsZX
	 8B+AvtX782m9eaF/Yf3k3srQzSKX+tNjK+2yZO5YOyeeEmhtroJCJ0jA3dmxCvextQ
	 RL6PWXN+UNEWg==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-718409593b9so65171777b3.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:13:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWMGOf5DmIsH1XRWrxFtzFxxGK607PRQNJK5RvrdPmfP+6G8b3Tgx/O8tk2bYCTxAs8pVWDpTEkw==@kvack.org
X-Gm-Message-State: AOJu0Yze0kef2tBzaWTQl1p+R55+Q9o9dMD7RlGlZT7MnvP7Pv0dmsNf
	15SKl3MaMIO27jqyi3J13zIBsDLXl+Av3cO9jlYrq4OWWOpn4ynp/p4qNbgLcs7yU5oHnkeyoCN
	DUZxw+6mb46LtetzvbwFJ6Lfbt9sCPEW3IwUBZtIXvA==
X-Google-Smtp-Source: AGHT+IHMJ5hrM6BYKWddcKV/9mOqGWSx0UjeiK7PsjXv12HL+iSu6pnGr7etupATkzLG1i+MPBDUdWzLk+/7HkvRlqo=
X-Received: by 2002:a05:690c:d:b0:71a:4550:8ac3 with SMTP id
 00721157ae682-71d4e54bf5amr25032997b3.22.1755065594874; Tue, 12 Aug 2025
 23:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org>
 <20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org> <CAMgjq7CL1pUr25efhu+bT1PRdqw+TkAaCCsBi-1DRBfd28N4OQ@mail.gmail.com>
In-Reply-To: <CAMgjq7CL1pUr25efhu+bT1PRdqw+TkAaCCsBi-1DRBfd28N4OQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 12 Aug 2025 23:13:04 -0700
X-Gmail-Original-Message-ID: <CACePvbXQ18XYSRu4nGCokvZsh21j=oBk0_h9S+A7Zw_4Dv+S7g@mail.gmail.com>
X-Gm-Features: Ac12FXyExJGsUwe-uc3d8vHsYw8Bq_bDHUwNl1cib-OweHDW8DGc-AcFLU7hpcM
Message-ID: <CACePvbXQ18XYSRu4nGCokvZsh21j=oBk0_h9S+A7Zw_4Dv+S7g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 225C418000A
X-Stat-Signature: aqebtg8qu6frk8xt4btfpbskkt813rfa
X-HE-Tag: 1755065596-582556
X-HE-Meta: U2FsdGVkX195oorxvqJyENCQZ+f+HUFZsELlIpocoh0853r/bKQbFDXnwcrOgYa6wLmoPa5J+MSlVXSQsSg4zCsNIbCgZVKwn6oisHp3nnoOc9Xn98V6qc7u18KTlqSMGUMm7b6xidPbmu6jWtT71TadNHSirLaGWPmUNXg6qCI9NCjouqwUciwkGuwUsekJOZzbMltwrvxkO2s2mqd8us6GWu5xanM8jXpjM62FGGl+jnSSuT/0qdYHetvPyGogycMwTukYosuwzfqFack52QAKjTACQZNVZCf7loxNNzJWXA2nkB/UCh9IlvTLTZhxJhJ5H8Dw05ExvRu6WWbrNDZCa1CodpzDe8w7DQ1ZzHTI2sHeXYmU1scf6+xT+Pd0Ke6l4URv+T5BS7kozE2ynT3TP5QS2FRRcULUgVw8I+BP5k7bO92ZvsdjLA+KNDzFYj2U0vyeeODwKvVI+8GnGsCiSPiaOa4SOfGeXlihXcp2HEXjKPLrVJdNLapSbygM2q/VIn9mA+nlDFX0ucYdpabhx8lyJkFRnd+Wkc9iPHq8EXbgVRAQ/5Y0LVKjErgE1KTNJy1/oFxjuJNDp58CG/VFztwo+P6yidm3nSyPCQkqGI5Ae5vcAZ81rkpzmT6TXhf7MswPVt+AkInX0yJGqRP1dK2Q5OF9nJY2kF4UXGzmcRA7dUofWZ4vRONNAAwgTEY2iqF/xaYZqKvzYXe4rujyYrwrRgtKDxFlOHkqxLMbbzXmZ9bGKpWxENx/0T3h0hfqh4VTiRw3IftiTKcb5Wc8JOULEWgNckKnhGOI38nuiO9Alwv418yRKHtbc5RXe73zeHcOAQHa3LjTO1lzxfjjIEaJeAy6MxSqbUb2h2qqeYRmeDZWgoA6vTWHKJHktWOO/11XXz2Nv9ijiA2PaywB3abfMz6AEELdFmRN9Sw3TYB8tcOUjRg6yqiR3CneT1yXZuCCrKM3pfcUM1E
 lNm6CWyD
 3vilxlIEdEFhk0W2MBRlnvTU+li8fSEYVLr6Wt+015tpLyFMNTAxNDCMvF6pYqhQmyNYWL5Cmv+YPBhu0h8IMMViqsfnm+fnkNlAcfS4erDXlAKiwQfiIhCaI6gC+PU2VJAiiWBjuSoQmQ/X99f5YYKH5ADaVdEeLY1q1CfyRiHlZJpoiXeTDceJgYPdefvpzjc93rm9ueem+owyw2cw26AaGtM7Cwdhpv4BccG+/Lx8e3g9OOmSuXrhRqQfm0E11XGL4efrXbLvZAGEPJYLrntPK7Ezx6sTRN9FTYJbzu+9Zd9r0kiJpgTe6d4aF1fdAMTEPU0bUnkOJje+YBxdUDlnv+h4Pg0AeyqhP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 9:57=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> I've been testing on top of a locally updated version of V2 for about
> two days, and it's identical to this one. This looks great, thanks!

Thanks for the review.

I have been running the swap stress tests on kernel compile as well.
No issue so far.

Chris

