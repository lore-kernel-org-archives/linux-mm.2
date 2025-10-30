Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0FBCCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE948E01A4; Wed, 29 Oct 2025 20:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847E08E0106; Wed, 29 Oct 2025 20:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711378E01A4; Wed, 29 Oct 2025 20:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF848E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:26:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B61213BEDB
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:26:30 +0000 (UTC)
X-FDA: 84052889340.03.AA22AF6
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41F582000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:26:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RkaOaUCt;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761783988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPUsAbPnavZ4td1AfI8HdK6vuKE/XGdHzWIQ9Lztg84=;
	b=MtYPpg2yqSNEmb4xLgE47Rx/mWy2Q0/oeTxk0yxktPEZswVP0+abaykXZxjG0NfVnI4wUm
	FpKqloJpt2emm65l/5UIImSWPcPmg9ojboeuIguJCijl8NzJxlCnuzQx9u9RGPp2GfCrBr
	XCts0t5wMkqIlCVcARTYhb3QV0Lc2zA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RkaOaUCt;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761783988; a=rsa-sha256;
	cv=none;
	b=5BvQ0U5vABKzgdk1r/Gil4+RFnbX2phaxTlIr64DSKePQpqJFklesBov+fc6MkYHwnIP0K
	ypUBHtMH5txR4Livf+3bfIUsCnWHFQ/OTkn+IX1+yWxJa13aaZ73Q+PkGPStyAkh9Wjs6p
	P4iME5wjzxNZ0ST+ipG9nj7is6qtIkE=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ece1102998so315644f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761783987; x=1762388787; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPUsAbPnavZ4td1AfI8HdK6vuKE/XGdHzWIQ9Lztg84=;
        b=RkaOaUCtqSzRTKD7gpeaJVW20nIW3DfmnTVk0ZkccecHftDwK87J2IimZ3dhafLCqM
         +ePGsCVZS1GZ0kPAcbxpxixUehFECsQQNjybvw6ibOC12lt8bGepvqmB7CELtkVDX2yv
         tfF7Um/tnlhGd7b9b7+eE4aFFBW1Zi6sEh2cBAxFjP36hINb6w8ObD0m6qLSaOIoX3aq
         6dk73hWb4Tih3YzsxUEr9hnCi4yvDlqYOvR4TKqbhqlo8GflLmsufXh1SNiDc0TSD46a
         Lxnx3iUjeOa3CNV230L5FPjwqbg8MXmC2cO2zL6rOtFnTWLpeXwXbUnfxReUTdQB6NkU
         Kh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761783987; x=1762388787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zPUsAbPnavZ4td1AfI8HdK6vuKE/XGdHzWIQ9Lztg84=;
        b=hiLgvfWRZRbOKJiYUd0y+JmX7tiUywq7XCV6bLsztkM88PsfAfiZjNh5SRpf0SeOa9
         2EayJ65f4FCLrHU65ZWY70QKN2UCF6No01W/7SQzhSNxYHZCvSInhz4/c9vEFzTuc3qT
         BdEkMRbYHcUKLqNk1mdjTpuS2k51SfEUoxnPTEM6zeGlyIE+ZoXhKlmY8jdboNdPaJjS
         QHwhMMm/k87cqIJ3Efr6pxMZ1kE5e/5uW874GEWhEBxsOKNSy55vACNz6GnbQh/g8CUT
         Vre0eeV1ZvRT0TJdPvJI1/WuT73stoqSQYQBekgdseyaWTvy1Htb5a+gEmoKP0egCfoa
         zlVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT8ypZ6Pj01FxO0e1GZFFiz6ISqsQw+HIbtkF8BFJ2fmTxrUcy+yl0R4nVNsqhBHF6+ClEpl4FhQ==@kvack.org
X-Gm-Message-State: AOJu0YxUOA9ODehF0ZjkKyWoLESpXHYM5oJgjSF8OVw05dkBpYPm0z6O
	lLyNvYpK6z1600ISbXpo4A9GBnWmBhMGYmDFi5KCbQBvNakW0/uN8jYP78MpvYGmAj0dS2lREIY
	7IWLvFfnrtR2aLJIgaKSpVlimJbmL8WE=
X-Gm-Gg: ASbGncsJANtjJp5kQtn2u15HGeoJEFmGhTltysUfTZF22Ee9EmrVcjRh1eFPeTcaNXf
	IcfFfOtPxq+yp5NCR2DIggOHchT1U9oRrlWkSlah+qxf1GHavyKTziFLnDT9/FslTid43IeQh8i
	jgvnZocEQL11rf+lgKZ62Inox8AjgtuWpdrDjWouZCQynx4Q495C4KsPVrkO3xfSQ6Nx7+WhZkS
	Fr9F7+Nc1+vTXY04fzM59RoUUv7oxQYAQsr51BIZn6OamDX6SAuzlcPXC+9txdsiNKpiGsLB1cB
	I7qNVvTrauHDQ2BdE//W5isSJsxhkCevwXMV28E=
X-Google-Smtp-Source: AGHT+IGkQ/Jwdz0hen+IZZordaBwb0FnIsLHdm9Vab1VmHts7m1t5JFOOcsAaPj7+O5XwKDwKAOewvz8pmWBLAdPVtg=
X-Received: by 2002:a5d:5f90:0:b0:3e8:f67:894a with SMTP id
 ffacd0b85a97d-429aef715f6mr5362079f8f.5.1761783986804; Wed, 29 Oct 2025
 17:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-11-6ffa2c9941c0@suse.cz> <CAADnVQKBPF8g3JgbCrcGFx35Bujmta2vnJGM9pgpcLq1-wqLHg@mail.gmail.com>
 <df8b155e-388d-4c62-8643-289052f2fc5e@suse.cz>
In-Reply-To: <df8b155e-388d-4c62-8643-289052f2fc5e@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 29 Oct 2025 17:26:15 -0700
X-Gm-Features: AWmQ_blIRE7qylf1r00bSF1LUzzYB2Ikdwsc9BuLrth2mRvMZNLO8ddWxSZ_asA
Message-ID: <CAADnVQ+TQZXhOhfG27kKdX8QUmua6AAqX81CnkS2W=4TANPUiA@mail.gmail.com>
Subject: Re: [PATCH RFC 11/19] slab: remove SLUB_CPU_PARTIAL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41F582000D
X-Stat-Signature: zqnm3omei3hxpdchnx1os9ehsfwtfsnn
X-Rspam-User: 
X-HE-Tag: 1761783988-77691
X-HE-Meta: U2FsdGVkX1+mFNLQkJMe46EO+rUfq2wsUVSJYydu6O0DAmlNFEGJy1y6bThtuWFlLdVnOzuMtjLRy2Sad/KCfK55ld0KRo61nZILoQTRubfDDI1W67aUlWqBq7st0F3Oxk3N22TnYHEdXrlcZouJmbA0Mxwoi0540GePr5TeJRG+3FE9qrR8sRil5zjzMAy89zMPHX1eYnVQ3nanwDOrhrmFtTa1C0ksLLndIvIEcu88NI4Wtqq9ZKb0ip7ixx7eW85F5ROj46EFOZgDwOMR+1ovLh448a6EA/4uPKOaKIuVphsP+YnynVyYUbzoumXv8YVcGTsd4uCCrxiPRNyRkNKmKny//ZJCAlsvC0yPaJZUsSPGA05/NqTjD5ZEfGUuqMeRjB3jS3NhkoGtFPTIoGKa7hurGLXirRcmhi3dS77mh/dfc3AkuJsiZSDzRbz5DCIWiukzDjRTok5CLKWgVk1g4nxWYngay8O6N6bjVuBF/8eZp4IFu8cFqi8QW9DMrHlYIp/8uASi40mbjVcLZERI6yWFIZojp95QyAfMQOLyKwMsjVB/cg5Ap5aXMO6e5BG7xV8lp59nE4P65PIr2hxuwF1+DhKXU6wd/HakF1Yyqr+OsmF2sSbk0g6wJw7Ks6Pc4aDOxIDhSuGytnLYpQZt5eR1jHgm9i3oSYfwvaIKWAhuSnoONQqSqqmSVsYagR2ygMeirMDL64aU4nagxuyLj3jyK/z/ZgkOfPv/gPtsRP1kFAe1BevCI53jZzBeP8KY+PBB2skcKqwbLP/jWcl2savsg9J+TpFVtijjcMb+14JK2N6h41Ek0IdTwljA/i5M4PcLindX2eIZAE8NbODkiHrzWvsGtGIjXcO9N6V0QufaYzXdGZKS2s5DZRHs/8rCdvbWRT/3x14Y6SzCF93VVkfluyAurPp+SsHkfaazPbldrui6cmjdWANeRPZjREYvvFdL9gOM5g8yXhD
 vEu1rCux
 GA7+1380yVOuUkOiqpNcdU+PALJZuBGrbHT9TK0IM7GH4lYsk2d41nIsKCCbSLzEowlIGl6noIctY3I0cW4XN9KzWMVWSTwSwWbsWdjcujG4W/u5UrjKNZHPCn55lEx7IY4drW9kJxazDNksk0qd1ZzvUWf0yAX0H0uKgs0NbcreZ0B5G7wGdNPw4n55Tvh8jshf0C1GWFZGw5iANgoXE4WuDS+sohJFErx3MzhqrnTuhQ7Ez1EaxT62Af7z+u+PEHjMQlO1GxPE5nVlm40AJMFaMgwuRtRX+OR+nB1DaCD44p67DlLVsFb4rwxFD7JFKk0smNj5LrUpc5nJ+Rq6fNYO0akw7KCmKJQxeNAyzOOy/2QWrn0+GLZ9VB/dkmf8UZ6OfB1k7g318iwQF1ceY24bI8kUEmBUFgHjTIgkL95Blhnhfjm3PMprW9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 3:31=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> > but... since AI didn't find any bugs here, I must be wrong :)
> It's tricky. I think we could add a "bool was_partial =3D=3D (prior !=3D =
NULL)" or
> something to make it more obvious, that one is rather cryptic.

That would help. prior and !prior are hard to think about.
Your explanation makes sense. Thanks

