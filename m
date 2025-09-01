Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A18CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88A18E0094; Mon,  1 Sep 2025 11:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12048E0010; Mon,  1 Sep 2025 11:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9A08E0094; Mon,  1 Sep 2025 11:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D09C8E0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:23:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23B4C13B2E9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:23:01 +0000 (UTC)
X-FDA: 83841049362.20.AFAB945
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id EAEBF140002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:22:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=aNuyUiPB;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756740179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqYJE8gaVl+wcM64SwwllZC2T3TpIFwcaihrMWL4cIs=;
	b=r61d32aLAiGbmOGlCULk1eiaVdl7bvcOONg0Uv9M8YlfD4xquJpBRZ2aWTwFEINDIDSPnd
	ZtH8yz2ihLniNZWG+dv1InfxayGSK5YdAjBJWMD8YiZExnFcCSiyCBz0GxM5Jtu4yVTYyh
	DvXMdpfKpsPzmKwggufplzndwbL7Uis=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756740179; a=rsa-sha256;
	cv=none;
	b=xw394psVYB7kqHfY0T2T56LFynWfpN5E1Zlk/DpGRYjobvCIq8mtgSbUFdHWhGhylnOqCS
	QKM1qQhsdReIq+cSqqw6yTjQ/8vaMJb15UUUSuJnmaqQJLcqi9InhnB4mQRIxK/uxEVAQs
	t5510my08KWG9h1pdBSMB7SlUIx5MgI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=aNuyUiPB;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so659911966b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756740177; x=1757344977; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqYJE8gaVl+wcM64SwwllZC2T3TpIFwcaihrMWL4cIs=;
        b=aNuyUiPBayCfuZz5NCv0n4/MqJLpbDsABIXfyOqT6X+8y3eY5tii/sZeTpSKlgoytB
         HL8RTpjqlBWdCLietTIhlZGB+SokxixSd/vjEHikvEd4GQkAos3Z4E5z1pfD2e55NWjb
         vo4hFDphzB/7tlranCYCL8sbJkcF2wKUogXL5gSk2xaTADvgtr4lEij1DY6lGMmPVW7t
         +1bFEnKmm4HY68ZdydWF4BE2hFsa9l70eRco3fFCLqEyxbMpZyCXIgSxoqCfV5KtiX8f
         mrsB3+1MwaMAoW12RGElSIykMGYaLK3nO7FbdLF7xAsu/mZSK1AE8UPu4AfEz3wsWYS7
         wVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756740177; x=1757344977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xqYJE8gaVl+wcM64SwwllZC2T3TpIFwcaihrMWL4cIs=;
        b=RLTKXGNVHhxpXJGmCrlJJvN1CkgWmcvOPMNXxbc0jNB8FRg82oOiVxRWb7XJRnxPVX
         79TaosMQCNBqpHEi0f5hdImeKbJam2vTkNtF6DtUJiRl+AfA6lkHW3qPJj0LiL+pnuL7
         santQ3jF3qqqJlX6hV5KNzLkJRyeTkyTYTHgMRjZevqiTm8mP4tR/XNi6/LWE5pu6zS2
         L05KKWB/lN8jBsdKFtjH0vB7dEo5hz/9GV4k0P6GqwXLKmDHpktIvnoUm7scEL6Fvkvp
         hOcq4VpJpZI8O+x1aR4gOjWBN2871NY6ik0QXlFKIc3FIrhsy3HgYRuVwqxHpiHc+Zw0
         HrDA==
X-Forwarded-Encrypted: i=1; AJvYcCVzu64tbgspiK6dk2KgOArPxXSkDpl/UtPRdgEOZL06lKS8LiWicHaiH+F5bQpStmb10pWHNiucaw==@kvack.org
X-Gm-Message-State: AOJu0YzNlh2b3eD6Fxkjp+lzAp6Y2TOSSL92t5J/kIyMUEWo5RTC+Yzk
	4DggIxMzPnJGGrFpiQVxomlHxE8tvHzESXxRMFHN0SjDTLmKM/o3ZDwpiz2sLRnI+IV/dWdhX1W
	hmvoL4JdmcprqcpGoBstYt9b4gQS8/n1PbBfNz/Dq5A==
X-Gm-Gg: ASbGncsa3Bfy5qw7O79UQeEYLRrqPpBs+VMXv0rmC3RMVaRtN94gS4Ykxi6A8ihqrIy
	26DJvfrBVfL4zfcB20EC//YM5JMNCCV0d+w8Z9dL+d62xe62MymSuR71GSt+rM2tbR7Tf41pmXD
	sU8VZYAaQf4xJwU7ri5nWnf8q0J2nC7CKDbAf+hzcJmGFl1VtWG7X/cjelpzL7eIoPE5r4zayES
	Po+ARrVQRxd0XV8bMYYI+Ow9h+VX5qiq/k=
X-Google-Smtp-Source: AGHT+IGyHGBQU5Fmr9N1bQCrhCA+i8zJzAFx27YAdwJf0bpouLhs7aYdtEtaq8rinlUX8phhR2x58GzGpQKldL70zDk=
X-Received: by 2002:a17:907:60cf:b0:afe:a7f0:80e6 with SMTP id
 a640c23a62f3a-b01d9756fb9mr875954466b.33.1756740177075; Mon, 01 Sep 2025
 08:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-7-max.kellermann@ionos.com> <ce720df8-cdf2-492a-9eeb-e7b643bffa91@redhat.com>
 <CAKPOu+-_E6qKmRo8UXg+5wy9fACX5JHwqjV6uou6aueA_Y7iRA@mail.gmail.com> <0bcb2d4d-9fb5-40c0-ab61-e021277a6ba3@redhat.com>
In-Reply-To: <0bcb2d4d-9fb5-40c0-ab61-e021277a6ba3@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 17:22:45 +0200
X-Gm-Features: Ac12FXxiiebv9X2d18G9zaz1-52NeLol_OdOPtBiylMXolSmoqbk-OqNT_yTCiM
Message-ID: <CAKPOu+8SdvDAcNS12TjHWq_QL6pXnw4Pnhrq2_4DgJg8ASc67A@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] mm, s390: constify mapping related test
 functions for improved const-correctness
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EAEBF140002
X-Stat-Signature: nnkdre6sf5t153xgkmcjj5tktzh9tfbt
X-Rspam-User: 
X-HE-Tag: 1756740178-926048
X-HE-Meta: U2FsdGVkX19COEKnOoNTpiQwP5FciyqjbranEfyQ5DVWYo5h4eFCrssVE4Hl25rVnXbGVNDadhNuB9uMF+jjk7nzBPZKI3s55rXvwi8UOURc0jay64sAaRogDJFGgFx+bpShzfq1T/Zl7l5PpztDD3sDqz97W9qtAdCwQUiC3zEaaSM4wZqiLl/BqXG7eEpMh0ZaAk8Ch9r93hrhbL69jK+RLDpgTN3H6kAHmx0QaqCcpu7lUPQ0U3oy9GP3tuEaSZFUi6ex6327gnXz8xy8QlyrK1m0aFBFR4KT9o+li2uQACLTpEAQ20PTiG6kslfv8/fmiwa5qrOW3MKY3NKTUJ/zpZRHlLLPcc502gy1otTvAb3pc+iY7eoIeXziA6QD+NWotPUtkIAYlIETSBOAVSGj18ECiuo5uv54viwA9pPZ68oek0JA0yb7JEngTMaK1+4YWuUqDXjqlpuO1W4vMlIHK66dnIJPawmVB4/n+m0wJuohuvoVdJdqqQdfKLzmeRM0u9Se0rD7VPEZpn/6YAX/FO62WdTbBYANfPWz3aoucmRlAP9tvjSpVoasqhsdXfaapKEgXpxsJQIWBTinu6tlwQSIJV+TY2y+VYTWKU2cPCqIEGJ64P2zY1VL5PF+/M4HpH2Gx3fj4vmeMBu9wcdh7kYwyjYNAsOtHM9IpPU6x8vAbm1XlCYJY8l4LLbQBDCtzjOGeJuXwEORZhHnMQ4cfNFx82hqrZs1mlL0CvPRkni2gWxE0vJJ5hr2Yc3hAYeCS+Pf93+EunMFUJjE9GFt4UXKgIM6gZHCqP0K3kZhT+9O7sB/d+y1X6L/bdC28JzMEW2AY9vactBGHGlDE/z7frYplCgAW3QIKMxd5NAum5VfbUrsZP/e49AjyTmerJNI29TERuNok7MfUkgLUobDX4HpXlhwr2LlPOSnuusMn3MDHS2jDHF5tf9tQDZ+piUi/NqQUdW5/qkUBuN
 vuqsuhfa
 cFjVFJaKBlE6CDj0EA5PMvpTCQiWqKyxARO7w9iQpsFFD2ygiU/ie9ReZBR6pmFYIMTFD2E9PPaPaIHEqt29eX3b6OAVjVFLUjAoo4nYbp0kKyxD1x4q+Rlhv+q8WsjGriHFErTVGNts0+Cj7BqDRBhn1kOWx1PKE2LTi/9ZR2DFhOmbJFbZT0QwwdLjHSozMDV1wpt6q3FaWrdqrnLlqkdgh42Umobva5l2r0HCz9b/JDXhMRvibDHuflvXEuFG68TfXQ7WZ4toIzVExEuJkuCCa3oo330cFtLYb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 5:11=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> >> Should this also be *const ?
> >
> > No. These are function protoypes. A "const" on a parameter value
> > (pointer address, not pointed-to memory) makes no sense on a
> > prototype.
>
> But couldn't you argue the same about variable names? In most (not all
> :) ) we keep declaration + definition in sync. So thus my confusion.

Variable names in the prototypes have no effect either, but they serve
as useful documentation.

Whereas the "const" on a parameter value documents nothing - it's an
implementation detail whether the function would like to modify
parameter values. That implementation detail has no effect for the
caller.

Of course, we could have "const" in the prototype as well. This boils
down to personal taste. It's not my taste (has no use, has no effect,
documents nothing, only adds noise for no gain), so I didn't add it.
If you prefer to have that, I'll leave my taste and home and add it,
but only after you guys make up your minds about whether you want to
have const parameters at all.

