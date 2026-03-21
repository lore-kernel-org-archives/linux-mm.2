Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8841093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCBD6B008A; Sat, 21 Mar 2026 01:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DAB6B008C; Sat, 21 Mar 2026 01:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3B06B0092; Sat, 21 Mar 2026 01:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB08A6B008A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:19:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 239E91A04F0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:19:58 +0000 (UTC)
X-FDA: 84568918476.09.53736B3
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C6A8C0006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:19:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nq5oArlW;
	spf=pass (imf10.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774070396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=N5slH90cGMNQaJ/nUAO66vR2HM7xhu3omBUy3YIB1Mo=;
	b=H1cNZBVoIaSN1zIHGWIyZ+wWe0uik69t3jTDbgVxDa1H5toB29MGB85W7d+BxmjmejH0Y6
	d04mjSISlI9aat0Pe9anRBHWsoadXkiur45LWqsn7yI81vhXn3XVEv+elYiSEJL0wxEJpl
	4AT5I4JJjIyK+S2zVxjLwfF61bx5qcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774070396; a=rsa-sha256;
	cv=none;
	b=449bUQXfrufGZ+GCE9DXx+lzZSS1jQnlbgRspedz62wW/+4s/PeJ4ssoBI64soh644NYOO
	MzaKHpuw3i3VLdeiqyIi5+rr1QIdgySc+4ZBVcjAtmnJ1QClFfk1tZ21Eo1E/Ai0ro04lF
	uPNkwv8UTqTLOxoAJspbB7x9Al9PFOI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nq5oArlW;
	spf=pass (imf10.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aae146b604so15715235ad.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774070395; x=1774675195; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N5slH90cGMNQaJ/nUAO66vR2HM7xhu3omBUy3YIB1Mo=;
        b=nq5oArlWTnI2eW5QdkGfZxTD0OfcMk4V/mIdWJl5sYB0+JcnZoSa5pjpOZXd+fQTZo
         1Bl1t+OqsP8YZvOxbMFMwPIT9QhdTvTJLXZkQ8Ko8dTJ87hDVZc68vr28AjrVKL0dQzU
         /vQSBR5d3AXB+eUW9xRIWKFwfDMLyP8OjV3NyJuB00G3bgJwoxl/7rAYjtumQyOPfA5P
         v2j1EYj9cvdJqpLzFBqmFIKXwqg+Rwmc8iwMAApGcPdyZNinwGawj7tWaMJHtkmiw4yW
         WiGywifkJzvKwEzNHf46ox/I5f4fhCZFC4ONXp3OXCswvTQFG9L14vVuKCIxNQYnDOy3
         MzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774070395; x=1774675195;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N5slH90cGMNQaJ/nUAO66vR2HM7xhu3omBUy3YIB1Mo=;
        b=DoanDpvmaNAE0pYeTMPv0AWfreK90JYfmqCzAa4Zps+1PQH15KhomX5rR8heBlYr4w
         TrUuG+iBUSY1Up0WGwqFfFAu4cDht7mDrCkzWsU0MmDzrt4n83dGz3+1FhwP+3c4FxKU
         oFRaLTmbYqQl3hdnZOYM8Y3ylZdwkZNR9bP5C+g+naIBmp8W2LDNFukOIst4diFBXTDC
         GDwI7Vdou72tgahChYjPjuSHXs+XbcKunR6Ls3teimwuUHr6Bz4p9OW8upgBbmX5f/L/
         U3RCSTG3sbbROb+k7EcNHi3YjUq3WJ7mltJVtmM6SdVsT19dd81LxnLRjbbZqr24/rI8
         2opg==
X-Forwarded-Encrypted: i=1; AJvYcCW4W9+r+F0l1XvqN6MKKhB2hcMXZ8jSqe9o9UspTVwhGJubvS9ogssIkbcbp/l5SDmdul52Xq0QeA==@kvack.org
X-Gm-Message-State: AOJu0YxC/owFmk1DJU1ZS/MI8DmfOk1bYuDeS8C+xaxGCAfzKjZYK4Si
	/YQu9WSbOHZZBaxU4KRt5bxDPDGUtvzs8j4oFHPhs3rocSwIJEsM6PVS
X-Gm-Gg: ATEYQzwX8HJYqhySesQMEtwZNp8yyWfjJ3on5lCXEJQ3VlWx3hUFQpezwlhUqmjZa6P
	XqLtRsFjXAGx59Kx+mwInLSxGk0HvrQbkPjrEycae+OtzS7+el7q+XwUqWm+eNr+AT09KPH8/EL
	KUaChLG4FMxOOwGrPjBDm8N+LPT+AhKA+eeA994cGA7TjfMxhI0FiYQokzWCT+RB8uYvaTI+HxK
	IJmQvi/NpCs4MM1KsBMdHUqQOVHG+zFzjmLiGhbp60i9Z3nIv59kdgGXtPeOEv2ugiAPOcgaXkY
	XaVYEkevTtZ9U8Q7DjlAEKlX5jR0v7ZvQFC5e40vEHyg4DFyqnhoCJom4h1RIYq6qpzA5tkH+2I
	8DtqP6wJGIlLY+aE9WNpiBws3du4x3i+akhQiS79PqY8VXjBgRmD7wrUmYlkBu73/A2phd558fv
	gVaOhh6By7rASaLByG8bPtIw==
X-Received: by 2002:a17:903:191:b0:2ae:c984:6d72 with SMTP id d9443c01a7336-2b08271e23fmr57382855ad.22.1774070395090;
        Fri, 20 Mar 2026 22:19:55 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836955dbsm52944385ad.72.2026.03.20.22.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 22:19:54 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: change to return bool for ptep_clear_flush_young()/clear_flush_young_ptes()
In-Reply-To: <5d24b34d8b7860dc2188408b3fa530193bcc5caa.1773890510.git.baolin.wang@linux.alibaba.com>
Date: Sat, 21 Mar 2026 10:48:41 +0530
Message-ID: <fr5tyd3i.ritesh.list@gmail.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com> <5d24b34d8b7860dc2188408b3fa530193bcc5caa.1773890510.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C6A8C0006
X-Stat-Signature: i4oo71t8o1yz17uie4hfi4q1howp1woh
X-HE-Tag: 1774070396-322641
X-HE-Meta: U2FsdGVkX1+aTKwftzeWgY3Xik+wMRlJsSGh2K0mQQea4hYK5RW4OeHvuhpzlfehPWwCvOMyQgSXBoSgSDRfB0Vnu/FnXKftgk47o7Iwb/DHN9Gdsto6Ylh1DSPfK3Ng1trGffc0JrsVW1Y0hyaiNff9J2Fk4WdvI/OGRi4Z8d0jYxWBMR+cbYQbFIfc9dHOf3dXyD+S9uUNDHMknmDD/N0VdUlZycHzGT4l3gKn3YU7vM8/iJczJvvOMLNYWKGGh3s5RuyO06vD4rdEvASZXG3/9bmrilEWznj2Z1Oc+xNZfcOIkiIYQwqMQ3uojMakhMAZWK8bt6UP/RAfpchKmsReqwaaw0XtAjxajpUGe0b/JA0+VvZH6IT3n++SruupvBzRWu8iMEZT1yQbigLKTy0+Qgll28ITZG/RdqVI+t2H7La6E0kNMWCW39O4VEfLgNxL31aFtQLc9tTQTo6QkqBoBYHvZg8luqiU3nyF/OABPo4avzA7swKL6UYmAjXtyCnMGWsmSNv9IjSaOytynVX8umhEDLK6RUyFB38YFM/DExAKHKTpOyHpOqsGD2C2EMDYN1JZhiFT3l2Ttj9SwyzpG0ol2gLKN7SmVkbm03Ses0bdsp1oTFBFFQKmQkGcbc3UvHwPXroCu+bfG3cExBsFvftG3ph69fFEyP1jKUcDjhBotvf1QE/dk7fXNtydRXMWX7mD//WPy2Y+OlWwqaUNlizou4HtulnWPT256j+NBSaPuYX2W6VjrUKCRDKPbNXJ1dWKmhxhgMC/pSgoEs1BCMQe1GeRVt9TQSKsWkeauBvtVNfXLjgpgErAgd/tsuIqfdZGXG0dx7Oey7eVKfkBOCfYPcSAOB1Ar3ldBfQ3fcCFTB1zrAs4mH+AcYFD+UTUnJ+lEgNQUZNGf/xsz4FCswVLM64I1FBWA9j8G2SQdIL2+lCIdO+IlD0PJ6uVGW4sqna++ZkumY55tjg
 T06rsGnb
 4IDwx+oSh0Xm/p1ELfyL31Ui64dG7EGpZkUIxyRwbdsXsJyEce5EzIevzWwOWqf+YdM1r7/mPM5nlUrFazhOlq4gtWY3t34eEKNUiJ63HSXdTKXCa+5u3fXXGgujst4N0wFo6Lb7L3G1QQrEbWGQ7o4FhnBepPrT8meBNz23JNrPZLJ72V4BN3uZQVN6rLBrclsnFMHOukTFmNZ3uJCs6t5fTRPeUdzwfqZve16G/pyI1qK+zimTNotlLO+88fngA0au+QnQmstCud+wxdB3Pw7y+5fFh1CJf83hZPcdJ0tXcf0V3uuSbm2/5iNp3V4KR978tT20Y4upQveRHLmNYUIf8Y4hHk1RYyfvA5ZvaqDhHsAviFhjVsQEhzvHuHjipLELyXX58ADAtJXIsl2vJ9uRW15gtupwzjv4KGl/Nud5n1+eYBscLjWtk8XtHj/awRtaRf/58fDTIEyMhw2T8u7SIbySxAkm/l9F2K7/pYoxcMxaY3QOEghYD1Dvm9tN0whX0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baolin Wang <baolin.wang@linux.alibaba.com> writes:

> The ptep_clear_flush_young() and clear_flush_young_ptes() are used to clear
> the young flag and flush the TLB, returning whether the young flag was set.
> Change the return type to bool to make the intention clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h             | 15 +++++++--------
>  arch/arm64/mm/contpte.c                      |  4 ++--
>  arch/parisc/include/asm/pgtable.h            |  2 +-
>  arch/parisc/kernel/cache.c                   |  8 ++++----
>  arch/powerpc/include/asm/nohash/64/pgtable.h |  2 +-
>  arch/riscv/include/asm/pgtable.h             |  4 ++--
>  arch/s390/include/asm/pgtable.h              |  4 ++--
>  arch/x86/include/asm/pgtable.h               |  4 ++--
>  arch/x86/mm/pgtable.c                        |  4 ++--
>  include/linux/pgtable.h                      |  8 ++++----
>  mm/pgtable-generic.c                         |  7 ++++---
>  11 files changed, 31 insertions(+), 31 deletions(-)

LGTM. Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


