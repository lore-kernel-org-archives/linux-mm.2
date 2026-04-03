Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380A1E88D6D
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 23:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1231E6B0088; Fri,  3 Apr 2026 19:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5CE6B0089; Fri,  3 Apr 2026 19:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BF76B008A; Fri,  3 Apr 2026 19:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E56A26B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:12:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B4311404D6
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 23:12:18 +0000 (UTC)
X-FDA: 84618795156.04.6B5BD7E
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92FA3100002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 23:12:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bkdY6Jw1;
	spf=pass (imf05.hostedemail.com: domain of 3TknQaQYKCHcnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3TknQaQYKCHcnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775257936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdgYiNCpCVITKt4WdfY63SIPUYiDMIfHM1afvBz0ai8=;
	b=Rd80dWJ36jUyA9/C6dAqBb5HjjjIVpSJJmgrUUWsth0WlpcowO0yLMnT8on/x/eKT+G3aa
	n3LOqgGoLbyQela9yLWakn9QslwQzAd4oyVq6rI5P3CryYOGpieDFYHewDUK+3kRaSsWLR
	VRfDYho4+oSKNBdXn3CN8jY2YqDAvxw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bkdY6Jw1;
	spf=pass (imf05.hostedemail.com: domain of 3TknQaQYKCHcnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3TknQaQYKCHcnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775257936; a=rsa-sha256;
	cv=none;
	b=e3Y5el8rmhabDBlBfWQIbm8VJrCcEPDGNg8XYc/V23oSVHpDqws0i0rib13jorGs0j+ZWp
	QHtd8i4wUxOY04DfhkhFVl1QJsgZOG3GrsygTmL3PWHD7sY9MZB7VxQB+2t6wVUVrGIN5E
	306vUkbKmePaJWxC523foKmUzWdAoQE=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82ca8323edbso3264664b3a.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 16:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775257935; x=1775862735; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qdgYiNCpCVITKt4WdfY63SIPUYiDMIfHM1afvBz0ai8=;
        b=bkdY6Jw1eOtJaMMxI24nEnK94OEtLb2xiMA5fmzgb3fOLnQByxX18QPNhq+PAOnSIj
         614Me6ta0qJGyzSpKcEaShMXoPdpf4xiZpZx/aHV5gnAJxfBv4bQSXrQYHBAwwDgoMVW
         bYyVsffUakidMkrrTeSCryZFPQDGNvjl1W2/5CPvVrQWrRAzoiL7QYnrHOHu66WicBLV
         UO4P38IhMGkC5o7hY9kl5tiHSpQVA5gwfE7UcGziJN+TjF1yGpwi1D62o7rDyzqZU214
         7+IusFp91Of8dqfcvBC7iM7tcpyeXa544bT2V1L5L82Jb+x4RlZey27A2I0bSmCTX9cn
         8GqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775257935; x=1775862735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdgYiNCpCVITKt4WdfY63SIPUYiDMIfHM1afvBz0ai8=;
        b=XyQGMxUYeb0GakqRHOVPiT5RNjjh3UFFtbUU8pCqzofg0AD93fSI8FfSTY+FXKzxux
         HqBPnJIijLw5feCrHXfZIJPkBMo6+gOAjs8pBnoe1Hh5l5XX/1HgAlPXro7vuZty6A6K
         WCUKDxKPhtXrLGFdooTG1/9yC8ItZnpnghW/xfnThNAyaS6fh5vn00JoSEkGaJ7XBJD1
         NRndoqU19UwkhtPhRwxUkj4vbSfy03TllCuvvczZO/V8FoT66h+ji98zfyda8aG4O1S3
         GKOVr10Q4XmjiVqCzlMWOiQ2ZhAMyCedBR/SlewF0TUWGmSWn+h0xWHIfmY8PDQl4t9K
         iQsA==
X-Forwarded-Encrypted: i=1; AJvYcCWxm2ii1s2mjnqRWIZsGQRrta9OQnugUuhEMEWfLO51L+x5AAo8OYR6eh7ZqfncIqBxB1BRxm9P9Q==@kvack.org
X-Gm-Message-State: AOJu0YyKWBe7KcMDjLAv9ufhc21MZA/U11pvVG+7LLsyEsukxqa7XR+T
	AaPUGajDnjmI2Z7EkAlRmmGJLjpXFGjte47yKalTVfuE/aQy2XtmlTW9X0HDLwNXu5+7ifEZnWq
	eTV5m8Q==
X-Received: from pfmu23.prod.google.com ([2002:aa7:8397:0:b0:829:7ce4:7fcc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ac82:b0:82c:daa4:ce2b
 with SMTP id d2e1a72fcca58-82d0dbcfa01mr4616677b3a.49.1775257934902; Fri, 03
 Apr 2026 16:12:14 -0700 (PDT)
Date: Fri, 3 Apr 2026 16:12:13 -0700
In-Reply-To: <66e78b59-f96c-4277-b7d7-473b68ed413f@linux.alibaba.com>
Mime-Version: 1.0
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <545847c132da5d957cfc74ab19e849b16127aa8f.1773890510.git.baolin.wang@linux.alibaba.com>
 <67c670e2-c98f-490b-bbb9-2960f8175b5a@lucifer.local> <66e78b59-f96c-4277-b7d7-473b68ed413f@linux.alibaba.com>
Message-ID: <adBJTXeE6G2vQNKX@google.com>
Subject: Re: [PATCH 6/6] mm: change to return bool for the MMU notifier's
 young flag check
From: Sean Christopherson <seanjc@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: 3ydbbir7zpy6f38twg4qb1y5fzh5fst4
X-Rspamd-Queue-Id: 92FA3100002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775257936-497339
X-HE-Meta: U2FsdGVkX18iQCEB9OFRCmXrIk3bSrrAgKuq8E4ytLiqgrkrIVNkFmH85sU/gW48quZwWru/l1S0FTSAt3CIZzihlaGSSB4Tw3YHEQ39yFEbsN82cKtpTInbi2gMxx4I//2Hs1qmyhT8i6hQhiVcrG9Os0hOiZPq8tgRTt5/9CoiDVUUan6QHRV8HLdJL9Fy3FuMilkndAtVbkdhG8mKg81jT56u26Q8O4zI4nWRVIbr/7PENLdTTqsl2dwxUj+rTcjCDtVaWnt5ja1Qc0mU6frYtkg5LWcHe4ZHd3azREnFiuduyOBAwXEhS3hSiLgCKNF0tlRCdA6UorqTVqLqumTvc7wqbcPDjUnJ5EedzLHRZDq152+94eKeabFvdn6t2wCr+pMBGO4TzSaHao8zCd3HN7+zyKgePsEBag+4GKO22d2LFgG8UzLgaaaPfShi+3T+e7rS38/9zJwucDJ72ciSXrzuvOROaihDVVPjBicQxkrNpBUnoofCm9GLeb+IvBr39v7oWFc5lQ76b70NIPWx0aNFoei4WnX1F4Q85Smeib88P7+QuCg+GRuQ0pz+TY0GgqvoxM4etOMhu1Upv9Z7OLfJ+7fpfIvxmLwpgO0i6/5NUr2vClB96MPyuIFbjwkN0Zlf6R0X4dvqoMGBZE0aECxyCKEr9SNiT4M21F8pDsiGoS+se+1O8DWpUHgPp933/fJbJ3ltSx6D11My/AC5AtTnJThxnggdAPrxqhoBs4q2389RMo32DGaqTwBaFcMdwAt45msT9G8NFEpHMmo6arH2bIgM/TOwPRLOe4wFvJQ6O03yoDUaKFpn3o3a5WShzC+yFk7q7GmfRiKEqH7ucjnj+8wK1hjXMVaaePeZ8EFX1N1mfV8/Xz9w77tlrWOct+7cYc3LxxDPe+cCGNoL9wr2hhZ21MpGz8ZH1incuZMVxBOtMiZcACiHv9X+tes0tvNW8Gz53O9FHbi
 qBzSKuaz
 41Rrbp4OeMb3SkBgd1ALfDTPInwLGPbJO5L9qg2WB2gtMUicC03Hs14evZtJenVqtoSJsSo2bvK8lDrhXEPsm1v2qG6Dnssf7V8ewfKP2/0ZLWMqYmnTJNGT6+n5UUVXKe1SQPgtR6ofgoEINLYX91mUFkyP7RYSh0wjIm4Y+YdmzNk2LDdYHNhGPLb0yZ4Wff/uuJifKTYKuBe+jcbNgDKH+AmTT7QYGkvH39CZtuCoIfr4SPSz/pkX53+yICd7zeuDWWN8D2KLPfb5shBigvSpb/gSEOxV70r2Oszmf6qIzYrcDSraDJh9KiD/R91szsXpNdVyOe9ecAVqXVaBk+8Kg/BWq75TCgwDGlllPGSrNWrF20RglYkFAgAoXtY7hyA82o7UwWr7Yq+YFShQhLT0yWbGcJNQ2QR8JgyNRPYAUaAfb9mdHyqSvXdNxZYLk9OHiHKcdovp2SZWRldVHJx9YI4mRmc2xafcZwoK8aD8Ieif9Mn+4Vpp78T28gUDzUgHv+JCfFe8eBRiKWouamWnLiKi05bN0lnqzu77oKnfMBU/vg1QG53T/k6sgdloGxajP5SVVGew0FRP61N+Zs8/AV3rAVfmHPwlGBtmoeeCBYqUrM57eq62T+sKYo18wRdY3AvO3Gm/VwfyjjfrMb/BznQSrecpzVmeheIgqEX5fXZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026, Baolin Wang wrote:
> > > -static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
> > > -						unsigned long start,
> > > -						unsigned long end,
> > > -						gfn_handler_t handler,
> > > -						bool flush_on_ret)
> > > +static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
> > > +					      unsigned long start,
> > > +					      unsigned long end,
> > > +					      gfn_handler_t handler,
> > > +					      bool flush_on_ret)
> > 
> > Can we please fix this terrrible indentation while we're here :)?
> > 
> > static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
> > 		unsigned long start, unsigned long end, gfn_handler_t handler,
> > 		bool flush_on_ret)
> > 
> > Would be nicer, thanks!

No, please keep this as-is.  KVM's preferred style is exactly this (and I personally
find mm's style much harder to parse).

