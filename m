Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A043C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2376B0361; Sun, 16 Aug 2026 18:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063486B0363; Sun, 16 Aug 2026 18:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB5F6B0364; Sun, 16 Aug 2026 18:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3EBB6B0361
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:02:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B35F40631
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:02:52 +0000 (UTC)
X-FDA: 85108508184.23.D079F21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64B86100009
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:02:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+w8P5tV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786917770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0/TSCZ60Ev/GG1UGjLIM2EhRh30NWyXNDJWJ/3A4Ms=;
	b=BVVFNmSMk95y+4Hv15P7FPsLpQ0ptbochMgCqtFy1xTDGfkxJs66JGoYwx1zD47RE6diO2
	UBEr4OmNsIPDh3EaBKaLOvb53cR0itXcoNUicZsijjHxXjn4mtLGh1nSHDYlXPmZ4fDVJA
	eBJ6udcnZP9HrzDxxGdDvc4RDHOFvjw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+w8P5tV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786917770;
	b=7mlSDVqOJEv7fSFpPBNU6JNsCq4iS5+i5ufOMxI2Hn7kc9NVQQio3JLOydSKX65Kff/2t9
	i4jbpojIwzHxsxZMr/1kuAzNPEGL0SWAuckmHhM3PfHSZt2Wp2NzM6n7m0LVCbhFZ42802
	EY/rS4WvQA6ITfTJDX7r0bFDUXh3hAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1734F42E3B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C201F00A3E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786917768;
	bh=L0/TSCZ60Ev/GG1UGjLIM2EhRh30NWyXNDJWJ/3A4Ms=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X+w8P5tVI/cJUv+YnpRs169/ZzzBOfg0HfulCSh6EAmjw7X5fOWQEOVvXS0uzhDAC
	 g8f/4SyeeLC9SxEom/wecw5es+G40DHpivGzG4ClPRFRnSLKanwBf9i+A4y/hduAvP
	 uglgeDv0Kp51dx2iJ9HgK3Jtzly/gG/mV6CAJ5UcMlG6U3oP1yvrn/zEmD80REusTy
	 AXqh1s8Vtpsp0jeMYslgTMTWxN4ojCNlVpMec91jYbFrp9X+qh1LNrfQGVFzydCOMi
	 07dhSkfZjIy0UpwFgGuUgzB4HxMg49eMyzgjDEzebwVZEMsqujnOCWOfzaF5+hKpce
	 sNFPoZbOEN22A==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so28340116d6.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:02:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrR1TRQ9JGggqPSLUnXxeWTGV93RKB4JZnVMle19XwyB6YwzeIerwO6duBW7qgsWMoPJdkQobV0Og==@kvack.org
X-Gm-Message-State: AOJu0YwSYa9OFbAYQLzzPr0OPqvrtTj3Bg1Q/2yxtLubUtLjdUw2nuVQ
	ToVJghzwYLrCtwI45N2f0bIZCFAHIiF/xERgBe59eRjcku9f6b1IDM2aENUANSAhmkF5NouJiOD
	e+Gqqa0iuGSN/qi2RusoxkDhLTELpb4Q=
X-Received: by 2002:a05:6214:5085:b0:908:93ff:daa8 with SMTP id
 6a1803df08f44-90a91cdc495mr238638176d6.3.1786917768072; Sun, 16 Aug 2026
 15:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
 <CAGsJ_4wNPeSYHe_-UZnNRF1i1yWOxdbOiqsuVXVtLU7BDOBbJg@mail.gmail.com> <OS7PR01MB13914906DFF1C9AF471A5B46996D82@OS7PR01MB13914.jpnprd01.prod.outlook.com>
In-Reply-To: <OS7PR01MB13914906DFF1C9AF471A5B46996D82@OS7PR01MB13914.jpnprd01.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 06:02:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xtF3awozoxJTHPu7nREiiJ09Gg1W8tY3B=8Zg_io2wOg@mail.gmail.com>
X-Gm-Features: AcwNN1Vl_oDHrABx9k9sD8AEeCwoJ8NrmVQSnAhTrbP7mjbtBevf5TdXX27h16o
Message-ID: <CAGsJ_4xtF3awozoxJTHPu7nREiiJ09Gg1W8tY3B=8Zg_io2wOg@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: synchronize lock and unlock target in anon_vma_clone
To: Seohyun Kim <seohyun.kim@outlook.kr>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 64B86100009
X-Stat-Signature: 39h93hiyd77oxrdhpkb7kasr3goq3kfp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786917770-948629
X-HE-Meta: U2FsdGVkX19vZ8q79xyzLWXsMXCJWAH0kF6egNV3cAIp1HLY3NwGXVuBS+UOADs+oX7uu8eEnStl+JyI3ffojV0Y6vckGcXi0aAE0ri1McPdCdB7Thw5XFBkO+XF8TGmFuEQ0RzJH2w4ulrdqYrQR4kvzgatFIKsNpXtOI101u71Dxkdhvwrhlhmx44YLisYSYt6okHq7ZpdKG0H/STI4zVQAEtgXSGl9ATdOje0XCRSENoDjsdHyCbMtWrl2fauSyz5EUtSJxaKJW2PMVUub2zOkZWOy8gDBnoCaw0la7AN5xtcvrWrToPSRxh/Bpsha/CLpZ9JndQI0IZk842xeyM0Mx5b1NLCteOJf2vUIHyoqFtT275ER9BDmt51IWPRSqg42UZlGgmE1ypPXxQdz10ZvdBzqKRLyygrLD5l7M6vQX/NX+RReRQMna5hPvSnxBB3JX06HG78upm1cD4VaaZ4e/sG1zwIdvjDERoEvFp+2jFKtj0EDz1rUgLPbd93zvRHj0flAexBY4PYm50ohW8vSKBinOlasCHy526hBImpq8A0O20SoIXzQZTFqqeQ31w1jSCVu/7l5fLq5Xhz0eoEk4hHe+KQS87GEEZ1b8kHm+/d2JQfzRI7E9mJFKkv0DQBgdj7u8tD31GXHCr4CfkA+g+pYgS8d+yYGw60Cw/4C6K4w6JJCQNxsngi96gUN2UXtnN5J2bGu7TeqMmpRdaaqEPh9vdqBKuCgCRBxPORCLh8CBqaQRaxuj/tZ/R2u790wzJiay/gjoNO280eZvvdpEiEKKdpJkF5VnZggJ7osZklsjgvdZpM+jmrJ8JajNFfhCQNdXDs3vo8Gf8WvrHoCr37FB0T25u6BSfaQDc5+z29hoPfmHsGM079jzZGHmKc1TJ6qvmLpnxLCII2ZZBG/ofHq6W+q+hTbu4jdBA4Wm+bzji63HkG3ql9YHkUhJ293J4NqDGfjZW2CLf
 Z8mc7Boi
 KmpFHC1m7kpg3vWev50M2qPRnxcASFT03Hag3XQACm2aYpwEc7NAlbUpKVW9I7+VB9BDocdqJOFwVvf+r2pX73k7PKYgvQ8f2q1OOR+AVG3xBuMjR5DlINsR1iCCUAcz3N83cpQ3H24LYuXiz/EsboiKlK1SNgjO0j36W8bqV1juifaaRXvid25x41MqwmCvJGXzDKLIPcUMrKc1Czen0taKguWhcT2MAuh8zMLzgjo4nJ8gKJuOFUCOg4hHU+cQ0RsQx0yG8RBaYzU4hXTKhKROT6k9Md371kLzO4op5oblfGKAnzSDGpg951GyNZf3I13k1Ytx7yA01KHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 7:51=E2=80=AFPM Seohyun Kim <seohyun.kim@outlook.kr=
> wrote:
>
> On 8/15/26 14:21, Barry Song wrote:
>
> > On Fri, Aug 14, 2026 at 2:33=E2=80=AFPM Eric Kim <seohyun.kim@outlook.k=
r> wrote:
[...]

> You're right. My original commit message does come as confusing
> because it sounds like there's an actual lock/unlock target mismatch.
> (I'm not a native speaker too) My intent was to match the variable
> name for locking and unlocking, and since active_anon_vma is the
> implemented alias for src->anon_vma, anon_vma_clone() should
> consistently use active_anon_vma. Should I send a v2 to clarify the commi=
t
> message?

Yes, please, if possible. :-)

Best Regards
Barry

