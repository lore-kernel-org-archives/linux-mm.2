Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9D7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14F76B011A; Mon, 29 Jun 2026 13:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5456B011D; Mon, 29 Jun 2026 13:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6A86B011F; Mon, 29 Jun 2026 13:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 937026B011A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:21:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16BE91A01EC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:21:37 +0000 (UTC)
X-FDA: 84933617034.15.A192952
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 14FF64000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:21:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=pB0btLtA;
	spf=pass (imf07.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.41 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782753695;
	b=EoX4RY+GmrWpUonFLMbkRSbYTgynNAr1NIYRgBYwO/RMpPfCEQRDfJYPoKMrj98DfIqu+L
	m1UmwepDGrA9Izwyy6Ar0cBjO98l5nBzXO4fQ0PcEKs97tFW27PKWgZw6NmZm08JefBmzE
	KZO7/d07qEe07J9MDMWYw4KpVbCa6Ek=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782753695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXmU7N9KWmAg5ZvphtB/jXefjrQWssfZEA+qOsBjMSA=;
	b=rPOnWkRanEY8XmglWTwZOFNIKzYF+oE6jPXAIRpj9Cf+rcRANgq/8lAHmmXa2qnZMOTc+w
	sut+xkzbFkmaAhmjLYQQet7//DuqkNjK3CnipqIUuUV2V9+23qg63ZyiiMeWg6gvD5QtJm
	cj4o2U6/lCcXII7WRu2Lb+qAqWnMd0I=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=pB0btLtA;
	spf=pass (imf07.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.41 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-37ff798fe89so855198a91.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782753694; cv=none;
        d=google.com; s=arc-20260327;
        b=T0iVRTiFIaNOF68EDuYtPxF6iijNf8hSz4OFDr3Ng/M7EwoL/4Osj+c4cQhg37K0uI
         lEKyGtn7Z1CbZUgq+P+VKB9XgnOesuYdmYiNpmmROidxqYSZVvS2zECq9f7EMhYlxZBv
         in9BoxzHPtHWnrT2+zV0xtHzcaYTfBpvTmqgXbMrlpdKEfXZrc+gujgel32VjyVvNB0v
         ckIh+6rQmLvmFGLTiF5Gbp8XI1SJ/AsWFFqFM2OJMWCITEbwC+3dFqT/YUU6e2F0lgve
         EY3f892k25xaKtcQ3uxuW0gbhfOrYdM5Mqd6HGhiP7tLugTmsJS7BJoEyu5g257s3k99
         uAeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nXmU7N9KWmAg5ZvphtB/jXefjrQWssfZEA+qOsBjMSA=;
        fh=yc9PYn+b2XWKQOXnKEYW1vS/HkPV0yLna5uEvIqw23A=;
        b=hS1tEt4lUPPgh9C+UAgZdZNVI621W/sjrHQb57ziJK3EBsk+wEF2e95TS4LBKKSMMD
         j52cC4AGIMVicg7GEDtft0VYTWFO7lj/0JG2okczeam8bYbgGLpNf0y80ogiTkE0sXtf
         SRmZTpeK/TVeziSubtZksq9uYpWTymIzkSfG9KprSh0YPZ66/ADCTlV0CAYtS+WOtNIz
         Siz2mo+LfOQz8BjAd/7G+KHK8us37amoaNEVQN8sh/2gWU2sSS+xL45OHTCRa/3uN9od
         dqlQTzCdXs4Kuknvtx0+vkP7MlpTtyjYEZ4gqP/ELWY8rYjJH19d/eJaj3oQ8tqgyHRn
         +tkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782753694; x=1783358494; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXmU7N9KWmAg5ZvphtB/jXefjrQWssfZEA+qOsBjMSA=;
        b=pB0btLtA2qTbSwXWQxZvWdW+G7gqm7dtxQnDoGGqNpe3CmsDViV2r2lbS8NrTkCuuA
         GCYZsyBhaDPGGfJzrsOOI68GbET+cwEfzeUaRNOW3skWCLqFU8WleG25SwySIbTpW6iy
         Egxy5wQg1LebrtYHrvR1IxYpT+w/B5OgsHQ8KhZ0MQwseM3VM9wLh8OaiBE5LSb4zPi1
         bTLIDEthWakJYeOm3ilrG2i6QJwo3vSGOLMpy/Z7PM0APpr0hy159ALyIUYjB4iY/bBD
         RsUhfCqsShKhYB4WgBuo/Qw4OKRr8TMFZH+4BULneVRj+bLcRbDXTPo/kXb5JI8957kw
         TRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782753694; x=1783358494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nXmU7N9KWmAg5ZvphtB/jXefjrQWssfZEA+qOsBjMSA=;
        b=kyYzfspDrbP3Fec3HuaPQnRA/9LiMGbAJEkSK5OrVKn9Yo4IEwA2mYBwV5cYDe9qYW
         XYOXDZv5Dexm+1DoZIoHVowqeqotoRgVqT8r1VNFrogUu42RtMSHGuBGe2+bGvj4gjam
         Tc3LsO895HxgUiJksoD7quQqx5eDHSyq9UN86PFT4gcQtPSXglJCR0S/qfa2NB7UB32t
         JxoVX7JvIJKIUqoLpTqjpcWAjQVLXmmHlfze+DkFmyYTWeDUgnfGrRoRpojRdcZTkXvD
         ZZJ0rtJCwGBQz5WrtAq3D4OymN7ov8Rk+ZPa8Zp1q6cNjSQ/w0RvZkIBb7QtMrKVRw2k
         b+/g==
X-Forwarded-Encrypted: i=1; AHgh+RqvVJisFWILJYvfBwvzLXdmORP7rjfqLVxRQbDFpfKGtwuCql6O61qkWoo+Uvyo33MHP9b71BwEPA==@kvack.org
X-Gm-Message-State: AOJu0Yz1KnzTo7157I5h8jOBcLIiXU2Y8GEmpH7zhlXJ41lGyCBU2ZCk
	mlzATE3J+xVuNLABkwC3rNVgzZMgu//EZ02fcjQBBWLhCugafapkN7F8ek7WjCZOCWiOS9EjkhD
	r6GBgOz26iYXoB7srsZMSAvmE/g/LTXjyy8fSaDWn
X-Gm-Gg: AfdE7cnRTPiPLP5/P25aOpjXbtmRuq5COiDWfK14sDZjq3pkOLCf1jNMSll2nagC7FO
	8jEfwUUn30a3fmDj7FY8MSQXSTK0pwEMMiIyoVIOhS2F9EhEPTD1ffhuftOdr1efNQOWImbTrEb
	jbXH3qPkl94DgCBu/+a07P49YSru5fxsg3bmrorTh3VPBUP33QgZHeCgUgR+5Kh4PXL3eDUazUO
	YYdDVBiuD48FTga8Vf7UU3j6/Ft1HXmf6zY0NQ7sArEEKw5AKc+pJp/A14F+pRnGAprpCN4cljE
	qMGeMT4/adI9zH5Vd6ZPtgDdKJZ62J2p5CCtDaY=
X-Received: by 2002:a17:902:d2d0:b0:2ca:26:195d with SMTP id
 d9443c01a7336-2ca2d53dd40mr2407385ad.11.1782753694022; Mon, 29 Jun 2026
 10:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260626173444.2252041-1-xmei5@asu.edu> <aj7UNceukU9zYeGH@pedro-suse.lan>
 <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
 <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com> <akH34ycu5-q2Yc_D@casper.infradead.org>
 <3c4094d8-ae5e-4ffd-b28a-0c10db50296c@zytor.com>
In-Reply-To: <3c4094d8-ae5e-4ffd-b28a-0c10db50296c@zytor.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 29 Jun 2026 10:21:20 -0700
X-Gm-Features: AVVi8CdDH6df1uqA9evZfvzbBY7svtEDKcDmc2IfSbHyvrdoUr7AcMeuMxGI6qE
Message-ID: <CAPpSM+TA6ECyCO4J3c9CrezbApMO66Fm5u8z6djDaFj5Wtagng@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 14FF64000F
X-Stat-Signature: y7pc89t41buxdpjxtse7wfamuohrzmxd
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782753694-954574
X-HE-Meta: U2FsdGVkX18gzYLZ9HTaahVMDEgERfmxGLwwo9lMnqE90CHXmbk0lMcP9wSIr2aNe348Fr4x91WuUqUaMI/EQnf6xi7C0acUjk6oq67GznG3aUG243a9rypny8vxkgGdp3GSAAjaV6bnVFJvuFXBz3nkCbuNZuaYyjA9NMfLuWvvWFAPFlRtJHD0g+ek1p5J0htYDJZ9CgD8uf+sh9uI4XIX9Oh6KEAoVviaaJNtndl9lcUFvvcBu3DS/JIt2JDY1A3T6H2XoFzDbbJXrfZHCOjpjGMg7Nbn6YKxaarqpca8pgrbMg1pLVL8X3N9j4Aw23XTtiCdyOcddWqxe4RXZx5X/YB+slKu0qbya8UACjXH1T5ISu9RjIZgclbyPBZbQrIiK2hbmNM3dUA0JcD4YwUNtiI/YqyKW76JwOc4Mzlih6p/mTdVe9TIajzYzrBSk3SoV+cQJEzmgRqzWxWu/ZVZBf2QPwx2MwFvlVSSYp91eocpvTpO/GmYVe/fOn6HFmroLbVxDSxAexfS6QzF6iSuLSOEv6w3wtJoydX9unpz/8x9vb4zPFXpFh/btMNik4naAKthgNuHdyDdFbYFBUtd2JEEwE0gdp0rG4wYoHwe/GbOIl3P6p3iLBNqz7oCcJa4wy5rAwcz+LBrzr/MP3R46JDzGFNModAOOXPh+gy5l5P+7te8LFyyQ9pP3uBhm68E9UDbvuXo+5CCEnGCrszERhF/elCdUkcGGaX99IlWMuh/lPMYUtpwh3jWExWfuh6Z723DGYfoG+cDK0MVujdzzz2pSQ+PlnkkQAHFjGGbmIwWqfgNzTH+/X1Uo4L98L17USkff/9PjMuiAEOSRAW6dHJaH44/2LHr7kgE2ckt3skgmSlUBeUDJzw738DWyaZ0h/BtYnXAwxyOi6rpT8DHUX3+y2GY47v4QuQEFC/pw+diJASo37wUlkb3RUzFu04WIb1ng9JGVr34zox
 hBfihlHd
 1qHOSMOqTi7H1yuOxKgu7756N4YDdHS4zVTpDJyvkHLgGKKYSq6PSoKhgog7tBnpP6sH9LuR6+HQzSc5PLEUAyGmDMzsKLUsu5u5jGuLdIUd0pX+8pZb4gOT14XXVnG2VDBBOeBfxY9blIebD/XHx8ER+9Xi/LG1s7hhSgNJIHky1vBK7D63vLKFfF1IM83ksrFIcCMPpdpeDFUYjewNnWUiLaJp4Scm2k9xr2NAN2kYoLFpEhVvU4jIzwascAhsbNghOCY6o1iza0NV6f9Ul2tczuMAMMpn7AX6A3o/Wuj6Ahsn6ieYpHTnqCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 5:50=E2=80=AFAM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> On 2026-06-28 21:43, Matthew Wilcox wrote:
> > On Sun, Jun 28, 2026 at 07:09:37PM -0700, H. Peter Anvin wrote:
> >>
> >>> 2) `enter` is not rare since we can take part in the instruction.
> >>
> >> This sentence doesn't parse.
> >
> > They mean that we can jump into the middle of an instruction, and it is
> > not rare to see a 'c8' byte in the instruction stream.
> >
>
> OK, I see the point now. The main difference is that ENTER doesn't requir=
e a
> REX prefix, whereas ADD/SUB/LEA do (otherwise it truncates RSP and everyt=
hing
> immediately dies as a result of SMAP violations [you are welcome].)
>

Yes, Matthew's explanation is correct. (Btw, thanks Matthew!)

Xiang

> This means that an offending bit combination is far less common.
>
>         -hpa
>

