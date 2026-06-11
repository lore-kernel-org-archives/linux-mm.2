Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92CDCD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04E66B0005; Wed, 10 Jun 2026 23:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E9D6B0088; Wed, 10 Jun 2026 23:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C562E6B008C; Wed, 10 Jun 2026 23:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B104C6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:15:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E1C1120463
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:15:50 +0000 (UTC)
X-FDA: 84866167260.24.437095B
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 596591A000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:15:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nXnHmwVZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=976JrbpQALIk05gyI3/5emKaKS9j6BQxODoElYmG4Dg=;
	b=GsbZAkcbHubbXuSVIcDxBgygUdtpeXKoVs13Jleh5XkPSgPJra4JoQKY4pu4LtbMY48MKH
	65a3NAAdBmyozAkTIpSpFQf9yF0uLTqt2H1D0QcFjWSRAq3t/Ck0ABF0w8qJ9NhshYGxHj
	ZktJA/76x8Qcfhuhp9evjvu88j515h8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nXnHmwVZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781147748;
	b=wHIGtxUWBECHe85VO8enJKAHhkR6IKuhuB6Fm0i88JA8QfS3ASlv7Wk5KIAZjBeRFDyD7e
	qQZC0r2XwZw7vgCMVrrv6GlT8chAX8AX98igVDvOdSrJVvAivN2ZaYo22L3pTkyaUu6o0K
	2oOQWn5Hamu+3WslyIc6BrZbiXZ11FQ=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7e266714bd3so85835637b3.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:15:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781147747; cv=none;
        d=google.com; s=arc-20240605;
        b=fgdm+RXA1eE/cmaRhvdP7ptytIgQ/yy2x9AXRfSk8f0B8+QEw4FqXCRmFSkCft+Vqe
         EBHosSHcazlfxWw3y45Ws0vidoj3PAqFnbbw87w/hUk0lEz7QgOut9iffn6LyXGo6pPV
         Vw8fuZzc/TfAAYxxFW+Hg15JEvgglV8fnwPRsJDjHWS4dflBW0TuDtxCjzUTddtxWo1N
         nXSYR6gaedzXJ9kqCIscXXRNl+iSmPRm8KoJaDJ8emFShw/k5rtCnxC5jiKZ1SsuYmaR
         tNZTfCQUBI7qfmy486/OnIdevZpSjY8eLiHsdQS0xiXcq7tz86bN4sWi/1evONurBIjL
         bBtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=976JrbpQALIk05gyI3/5emKaKS9j6BQxODoElYmG4Dg=;
        fh=ZD+CpMQoL3EvCbF9RMwKlv/J7fi8tiCh94qimpP1+lg=;
        b=GaBDVhkRVTpJg8L3s3ESSo6OUE8K3O5htj3F2Nw+UCYGWLOvk6SU8fImOJXkSSfyAZ
         BkX9cBnAZn+vG3WbKzVhv+9or1zAAZI9EetJyfSm1eY2VPOBTvRa1kMFF19sCGOvVtPj
         hy/w3e98d+MLuS3M9wmfXLK5NvG5qZD/XJIvmd+RkyzmeoraIPs+azye9SE8aW3SMObZ
         Z/s36b7HxUcf9DemlHX+Vql+fcgbAqEF2b7OiL4a4TCCLhsIbdjkePDrgUbh9nFOCAff
         M177h6vNf0MFCC4kLlfMcTsXokpj8ggNBMwxaBQ59igCcDOhUDQwxmCxn13p2DLtuFWA
         sxyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781147747; x=1781752547; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=976JrbpQALIk05gyI3/5emKaKS9j6BQxODoElYmG4Dg=;
        b=nXnHmwVZNzLVzXxxVXoa0n523nuOv/O48qxjmTD00VBrKZZLbEuFe3iu0SNPw0l0Sq
         lqIkWgvwYyonsCFMxSzm7/fKPccFgm3ICZ+hQhVnPqcdqCBthpqtQVUK0REF7dw4hxlm
         15Z++GU4hAtgN/TTkPXD+8Xv8I4rWptsS46oDu/qcvY5vLsd7xw1RU2DodlHKLMbSDDz
         N0t8hSNjd3RMISJA+sOo/pf+V3WThIrskNuAzikuFc/cx0XsvMiaC9JgfYcIiSi1g84F
         lnXXTnDt4t2SBaeM39d0UOGRsERzKWoc+oyUvlSczvcnox8LZdLHbLzBf4nRuho6xxHa
         KhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781147747; x=1781752547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=976JrbpQALIk05gyI3/5emKaKS9j6BQxODoElYmG4Dg=;
        b=lv2Vk1sUEewlTt2ZhsvgvLsD/5F51Wlz/AKCGFfjoEA353tF31pyPKPTAR3eSmQAck
         F6E0JIwZ8QS4T4YbDAjY5LBkq5qc0w4CYhpuFd/PXSBEJI5DNDx9Xj9j52j6JJKDK1rq
         evp4E3ph5JlOVDqQ8JiIRPXzp/XKf5NGTpfJnIRqVG16UKxx3GnOEMXIawTp1v1LqoJK
         EO4opVHgOD12bJSp8wHE7+q9BXREbqYq7RnMgbOvQuIlR0pOg8vumok0unlHKTWfobwq
         ojS6aOmzymA8uBW5Vsb5mKXB9QDY61wW5K+EqjPc66L1I0KFcR8AWfx94zan/XJpw4RP
         +g9A==
X-Forwarded-Encrypted: i=1; AFNElJ/QIUz3ocDqLOkat7Ze//TYNDWP8Dtss7YRj8v9ZUkY3+IPYhdNGxCkKLNhxsBHiY/tFPIwzcpRRA==@kvack.org
X-Gm-Message-State: AOJu0Yx7tMTIl/omLoxHcuFqKHE2N3yD+AckJqu8nI0ZfQKLvwZTPKq3
	Iw0i6vX+XrVY4qoQUxdcwyWgKHANOwdrTjYv2PN0gSnAAiFpJaVvqTM58IfricMGPm2EXsbQTWB
	pSXCTAsO4o0tNVe01mk8fbtmiSGL82dc=
X-Gm-Gg: Acq92OGggR2pZSrpwhBuHhrglil/04oLYgc53SAxs+maabdG7l95NgzdN3FSUDPvy3q
	VoOGiX3i3GmVhTB+mZUjHak7tmyouOvqPJ1Eq0zwkvTPXGRU49ZznMAY0bUyptiBy26qzhFGXjP
	lVbjjRcxYDOpDKyvJaSYIy59+FGZGUvFWVOgVwEgdC3t4TXkexfoRiOvH16VMb3c7kdzQ/iFOYM
	+vjARBCPDaGoPTr4j7MopcMlV4xinl5A1HA0eGGEnT1MFc4QqYTYaICHZ8QFgPt9c3u1Sakdb+Q
	rAxfRTorc/9bddwlL2CxfAfb6p2bGw==
X-Received: by 2002:a05:690c:4a06:b0:7bd:5c9d:dc6f with SMTP id
 00721157ae682-7f6558e8693mr11476977b3.1.1781147747258; Wed, 10 Jun 2026
 20:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
 <20260609113520.3507783-2-haowenchao22@gmail.com> <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
 <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com> <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 11 Jun 2026 11:15:34 +0800
X-Gm-Features: AVVi8CdSC97ax-MdYlena4tH0Zu1Iyw_xqWRMo6c1DNX6wVWPb5cZ2XM2US3LIw
Message-ID: <CAOptpSPseFH14dyyVQrvfLxqjSXFUyhoVg3GXsQh=7qktJ85Nw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Barry Song <baohua@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 596591A000C
X-Stat-Signature: qzjp4nh1mchkj6hao7ttf3aqpefz6xye
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781147748-247815
X-HE-Meta: U2FsdGVkX1889Ik1vgQDz1I90AtoKxt3WzGziJ167Udo0kQVBYux5u2Nn6/p0ewyWFCf06yD9CkOJ862mfUZ1idNo2r5EbcC+EGQi9yELgx+hhx0pbs3pcPe8mR27IncBUrDnpjcnT4CH24yXwIEDjuCpvGDk7iyWI4+Ln3DY2lchdnaJQlgq7AXJM1Tan5Y4cUaPqbbpOBybfbPaFqxNlSHRsrtRrD73kvaRCE56ErC0AXw36JB+e9k3YzaPLEb2qcO/2t1Ym2zmYWcifxvU8HXkW+egxyGH4DwxapEUUpaVQIrHdXs+jEOrwP4g+RdhRa4zkeO10xbtX1B+u511BOIUhk95o3z9PPFRLBvCf4YALnpVGY+qUTRshFsEa/Th+fT7OtgqZphD/VGn43+9Ap0VdDrCeFnZRhO0FjiHl3fZN1U4W31S/t3Tm1mI4+x9TKEYZ2tZJsX5SqGUKPYXh+gKvSXygAKz4VDj9jcokVZkeKjHTq9nDsMUlfSR1/tskCeQcXTtN0pKEBByYEFXQyWV3TkhuON+mDRCD10/sQdGAqqMDFkk/ObORvXLh4RoDHI3TQjScO9JtjjMhM1zzLaCcP1gkvztyQPZ/+P6bxjefgzwNVtazLP4aC+TtcJ+LAqpuXPIMXD77YCFaCOHceR8gSSrpnS7N6pXprBOsLYQTUADH8Kf+rWbgAyEZWaWtSPh8hvrkP8iW+sdquqXG5sEu3rshMuh5nRAVjG+rvR+2hIRFmIvp8paK+GZonsNkrNKI32haWxbes/rCqbYdWSgN+qkAQhV2z0sDandWnuZKJh5VlOQjT2Gc8SOKLt2+BNzyzbQzJBjsegF+z2SKMhlLmuXXEuHXabiNqUh0gsevzN3XtGg/TBxQ1Ae6YtyTkyhc9/VxIB7gNEqRTKnVBVEJcjMb/l3VaDTIp5C92EBNrIMzbTK+n91DBzhKxZfBjceUfPm22gn3uMEti
 AJuhw6zf
 LKyYdi5/5U7RPj24c5owKcm06OH3sMUS3MxRJn/ITafIqTpJgVYkJJ6Pg/z6Yw1+Te7p1mrW5Omwq7Idt//++hqcuHqEB/CIfVilRK+QGv6MR37XSv7cRj4Is+uelkjmpKLLovzQoTFpaV+7F41BciC8EiJhHN/J9PZ18EBsEXgbQC0J9shUovE1yabnVuO+F/CXp6FI4YC3PJtqiC4F6JsqgRpl/F9BRpzdSfHqGL4mrdDcw7LKDnrVjPizi9TfnqObmlNODqhLa7yhiBqirtJz9fX46gbkgmtSGmiNF3O4PtdOSB4EiNMLcDRJv7C1fj4RfAvd1B8hsRwygABZRnwMg/htEcmLIzs8g6ZW0Dos68T0vvhTByW3pdaHPnjuizH+6C5TF4mNyB2qvdQNkd/2pouFSH2UjcgC6NTYhRMQ956s9SpsWIbFDbJjvA29GQUr03G2EWXKvOOtCjgVTlkjPfpmtM/BCcHvgA5eP1OhAbn4mMJxX0FTww/Jg3Y0463tpwIg8eYEHqKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 5:28=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Jun 10, 2026 at 11:18=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.=
com> wrote:
> [...]
> >
> > The "_LOG2" suffix names the math but hides the intent.  How about
> > renaming them as:
> >
> >   ZS_CHAIN_LOG2            -> ZS_MAX_BITS_PAGES_PER_ZSPAGE
> >   ZS_MAX_OBJ_PER_PAGE_LOG2 -> ZS_MAX_BITS_OBJS_PER_PAGE
> >   ZS_OBJ_IDX_DENSE_BITS    -> ZS_MAX_BITS_OBJS_PER_ZSPAGE
> >
>
> Do we need MAX_ while everybody just uses _BITS? e.g.
>
> #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
> #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
> #elif defined(MAX_PHYSMEM_BITS)
> #define SWAP_CACHE_PFN_BITS (MAX_PHYSMEM_BITS - PAGE_SHIFT)
> #else
> #define SWAP_CACHE_PFN_BITS (BITS_PER_LONG - PAGE_SHIFT)
> #endif
>

Agreed, will follow the convention and drop MAX_:

  ZS_CHAIN_LOG2            -> ZS_PAGES_PER_ZSPAGE_BITS
  ZS_MAX_OBJ_PER_PAGE_LOG2 -> ZS_OBJS_PER_PAGE_BITS
  ZS_OBJ_IDX_DENSE_BITS    -> ZS_OBJS_PER_ZSPAGE_BITS

Nhat -- sorry for the churn; this supersedes the names I proposed
earlier.  Let me know if the new naming still reads well to you.

Wenchao

> Best Regards
> Barry

