Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C21FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BA16B0088; Tue, 28 Apr 2026 02:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343586B008A; Tue, 28 Apr 2026 02:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2592E6B0093; Tue, 28 Apr 2026 02:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 101966B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:58:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F4B6140440
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:58:48 +0000 (UTC)
X-FDA: 84707061936.23.B4FB51E
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 82365180008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:58:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1PF3j+sY6VDn/b3XG1Y7Z+9M+AzE58WOK8UHU23nNvI=;
	b=PURQp742FM6tp46t2Oq7mRNOzROUSJRvwIhPUh/CAHs42DQSh+B8bVqb8x+G8RwMyftu9Q
	+MURrqtZbuu3ZNMJyY8OelZ37+i+5vKVzMtvyuDiuR2wJJduhu1EWVrPLEaeuqotct/AdX
	80xgRMgh2N9hQkVqyAWww1i/SiaEBRY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359526; a=rsa-sha256;
	cv=none;
	b=fg+dHRvyobuh34c85kdtdfqOfILmfwEBQUgKjvyYDlNyHy4DkKwiWTRzwNkhbKmVE9wYF8
	2+cBUp3VNh1zpYbDILcuCCvH5hfeAR7JNBwKYmgRf25CURELYnCeKe2BWlXYDncHkmDWo1
	PYQo8+3/t/Aqsu/V93tHTx6yxdNXQOo=
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-94de68feaf4so5529426241.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777359525; x=1777964325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PF3j+sY6VDn/b3XG1Y7Z+9M+AzE58WOK8UHU23nNvI=;
        b=bWgUleIWMK75MVlvBlatFXBdJLkZdmFSFv+JHI1Wpamp4dosc14MNVTF5WrBCWKFLR
         oIs7N/0xViifsDHuDeqMJYMdReBKFS5nj0C1irxs2rqFRkCzOO+bqlL+3pRGXBz8poOL
         5RWPjQcTqFeghov+RVHBvgf5H/Q6PCNRiV+JE+hb4O9wwPzufa+ZeDO3Xx7tMfUww8Rv
         2zWFqMmG9lWaU7drDULe+9af/NNzGfh5kdXCDhyfT/83Wg1tXfaq4BVzAAPFzzNOeAvR
         5/Vhq3F2iJPuzFrI9ZylP19QccFLJjvbuA00++5G3RNPzEkvHZ5gg41Fi095tDszZ3KW
         CD2Q==
X-Forwarded-Encrypted: i=1; AFNElJ8n3pdyqf16DGuRIcIT9rZu0GpAGcfzqg2hTL09Fg6CTITsipQM4hLoFk3iIOCinvFNw6TF4OsDLA==@kvack.org
X-Gm-Message-State: AOJu0Ywf3Qv6gz5rToTIYd1eAMDYP2CdHnH2dwtkyiIkvLYlZ525VfGy
	NN/CBJ1S3P+o98qzaIH8gKtrVBcRHnq21kgvNgTBAt91sIjdEkW5zGA9IsFfqBkWwfU=
X-Gm-Gg: AeBDieshxnGHCNT+iNS3rI9mudBb5Fw4VPvC8B3U7WsEn9HkjUSGIK7v5ckyZZ4i89O
	dtW5cxwD5/xsXIILNdFAUSDCxouQUN8IkOsP5H4IRV4gIQ+Lji/H1esCj/5vqDnf/WzkAE6O3a0
	d2Ncsjz0wkPwTxuswfwGosyUOo9tZjkgOkMs5yqlBySwKEK79mP621hak8YtA9C7U1J7a7sQcaT
	KqOkJYo8jrRHOuutWtt1tLTFFB7INzjcyOs3bONpl+xEWLgMcgiCT2fnwtbz4SKnucopyLzGHut
	vij0O8BYAksoUUkmGjEC8TivEfjml872yxJJ1ECBtv15mq8GhDRSwh3JvQUv2LwEG73yEDjI04h
	oV4ChTI7BNXqqv/zBBOT53g/EoZbRA331Y93WzsxRUtttQsZaGcTXRxOcKKUoENI0sxrbn7z3hH
	g2Zsn9V/y8R3p1W0/jtuRQKxpDPtkr9HC3pqvOU0SisxyztStjODWvRqSYlTQq1WMbJXkCrUI=
X-Received: by 2002:a05:6102:3f05:b0:605:17b8:16dc with SMTP id ada2fe7eead31-6280afc8fa9mr575269137.20.1777359525469;
        Mon, 27 Apr 2026 23:58:45 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-627f802dd30sm812100137.11.2026.04.27.23.58.45
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 23:58:45 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-628086439b6so342231137.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:58:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/yP3HTp3xKV6kHcxLlfdqtPkkb3e3wKO9U1bpRyR7TlLkJErmMD+QAZk8cZb7a82Di/FQ25iTexw==@kvack.org
X-Received: by 2002:a05:6102:950:b0:607:7991:8edd with SMTP id
 ada2fe7eead31-6280a8c5705mr640942137.19.1777359524824; Mon, 27 Apr 2026
 23:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260427105810.23761-1-pbonzini@redhat.com>
In-Reply-To: <20260427105810.23761-1-pbonzini@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 08:58:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUvehWeTwdN1czjvv7OjGsu_XaaYS1R6Tg557mDqP+fSg@mail.gmail.com>
X-Gm-Features: AVHnY4IUbWltZt4Nuljx-hPEgpXnbRcqSixeYk6RCQC_1EScDCPPRIuQFIAQkWQ
Message-ID: <CAMuHMdUvehWeTwdN1czjvv7OjGsu_XaaYS1R6Tg557mDqP+fSg@mail.gmail.com>
Subject: Re: [PATCH] mm_types: remove references to s390 gmap
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-m68k@lists.linux-m68k.org, "David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 82365180008
X-Stat-Signature: w9ndfuzqgapiofdrsi4ft5471tqasg7n
X-HE-Tag: 1777359526-948599
X-HE-Meta: U2FsdGVkX1/v0FrgW+WFuBKKvy9xMJrmhac3ZV4kBFxi05w+gIixAvsxixL+NnQt2KAYyj5x1fSENfl0JWaIH5+1R9TdYVpUtzTL77sCmZQhvs6/fBPJ4kDyfalx0mlSvxBC2lESFWMqQqVy1mrnhhGt/rqpOImLZBOeSm18W/yDEIru3F/gqpBVOx+LhGPgLnZHpDOuS5+4sLjb4h+kdcejLQOiFboTHIun8ORAwtwVHTPx+4aa1CVNARLlM71Mizg2/u3EeY64TgKwZl81+nlc1SKTtbjmRxCXtszI+r/lnmNCiLkTM5Xh5upwHE1TS8AWGiEYbYQid0ntdUo44t51JyUWkxePpAREEiTEvAmfhzggAr4N2/2gr1RPsH+gmS3Gdr2DeKxm68uOSAiRKDXC/kZHpYamQktsGCtynTiePM/VaN5NkFJGyqwJtLRwQoVtdBmK4E32ZtujS2WSACj5SYpN8EICz+uQEvyHAreOvqxO7GuRpLwaCB+H9Kos1Pd7vQjawvrQL9tijYepSMP0vxpdUR8q8eU4qWd+W/kZbvjAcbrO2gBkfbMWo/yyTrKuZ6QM6zEIkYFDm/30OaiX84j/CwMhKmRQKs+gvXn4lT3zAY106SbUP+Z0kq1QhX6tLWyEhdt2XDIursnULbG/kxsp8h1SSX0IdEhBVHOzWfk23YKvX9drfKCusTFLrua0S83Mg7VoBOkPLOCsB3rrVF/1E33OoOPP+NM9/JT01I/VzqoJMszYVjWB3L4ZN23J65M1lO/dvyRk9cqJv3YgXHERB3abkWSSaRif0DDxFxBPQmwECZFIK3z1doJrBFmlMhbFawTSyoP9hlrkp/6p9QgP2J1qd2fub4KBexnWG7HcheP4QoS02afrj0fmu7jqnUYWZVfNRuiaisevqa+psacl+Ztpy3QqJ3rghFWDfYWC8fKovn8GmeTScLK2L3jow7TEkn5TEn7etwX
 Bner55zR
 d0jmgLgN3hBN6Y8vSQzVRFcPdlttAu/vwKXAOd5d3NTo8iAFlCPGc7nHE7t84XFYR6qz+M/AuXgzSB+638UzOeNRCEFLJilNGs6fWhqaL+21eOHFOXkNsWmbQOzlTAgpKvOfbk344XEUmEWrVppq+IKNJXq+NtLmyjt11Xy/DWJHQAIOBv8aojYkReQB/J7C/I+nPBa6hU71YyrSd7FZhrQafAw3JUXYGFjLGAPnYENq6HMazx+mT+pnog7UsUyfCEsCmq80hXSGfvc6+Jog3msKeGbiPFXSGFUIqlQrttBM4v8b7XGwS2RsdLnS3bIfzxd/91B2WwfMC5YM/Ih17Z8fSiwsS3+c3AIpqHkJKNCPMS6ToI3lW0EDWL5xKOLqkfT2o8W7BOr8E2MV4S0IrgPtX2cRTLq+50mP1CrF1TmXCvjTYl0opduApafM/HvaqqD3SHQ+cAnb5xe86+1SjVCLBGLtOnmYmBihoaU1DiXid71rZKZx9gkSj6kHd95jugkHZQIr6a0pRZnNG7N7ts8VwMCEr3hFq0kSRdnrXf94oe34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 at 12:58, Paolo Bonzini <pbonzini@redhat.com> wrote:
> s390 does not anymore use special struct page for its shadow page tables.
> The honor of giving a special meaning to pt_index is now m68k's, so
> rename the fields and adjust them for the desired type.
>
> Cc: linux-mm@kvack.org
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

>  arch/m68k/mm/motorola.c  |  2 +-

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

