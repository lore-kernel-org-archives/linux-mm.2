Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B91D6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946A76B0088; Thu, 18 Dec 2025 07:29:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4286B0089; Thu, 18 Dec 2025 07:29:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6196B008A; Thu, 18 Dec 2025 07:29:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D41D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:29:42 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 156CF140ECD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:29:42 +0000 (UTC)
X-FDA: 84232523004.18.A78C154
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 345FF1C0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:29:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IzZJFtRz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766060980; a=rsa-sha256;
	cv=none;
	b=FyK/FJvgQ++MIeGcVSVvSwIh2Em8gxL6rtn8xg8iFzoyJrhvVAhgbIadxXKw33rlDMXSij
	BQlLZ73DM9BNHhLu4orIRPwgOI2KtE/CKGztIGheG1YEpLPlUmJalf9866h56rkwLj0Stm
	1SA67oNOrpSTQ5UfAmgu1Y4rsesITrY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IzZJFtRz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766060980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffPTyuiEVHWwTCiNfJpfvcZQat/klsCzHR7/EM+Qf10=;
	b=swYqieN9Ut9WhZHzx04SvretkuWqLFxakRLH6rtdPOaq1BZB+5CeNQ94CiHijAnNo+BXf0
	SpYwqi/pIXymXjjuH3fvuZ2AbTTV9xXIDzkgVtDNaSVYUcc+f/08cslwdIXJOFn3SXTvwY
	HUzZFUvU9uUnoWVZGJqM1hTUNMsRbHc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0bb2f093aso5995925ad.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766060979; x=1766665779; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffPTyuiEVHWwTCiNfJpfvcZQat/klsCzHR7/EM+Qf10=;
        b=IzZJFtRzqWD2A91Mz9VGf7hZaGsHwCchM3nfS7qKSBe1uwJPaA+Ai706Z9j+QxXBet
         rSWLBMSqCO3gb2hmKzrPxvyO3vjlB4iUdZyIu645d2zERff7FnNlbRdIL+Ea36m3GPlG
         QK9nEUhWknYKXoxYRy5yYrWWk8+S9GiSZqp4vmvV1mEDZvkWWm2NeNaC1zjzqQXEEfWx
         Quk6/N4pvYpzHYqeffyqxLDwbbcxTs1RRCas1HU5ITi/b5beP97lHUgsF+8mUD4MNmv7
         p5vIsDkEIs1mOeE3KgwOsXhJCtJoeiBVSCGxT4lfY+gIdT1tfSGJxI9I8HPe0PmTRwaO
         LLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766060979; x=1766665779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ffPTyuiEVHWwTCiNfJpfvcZQat/klsCzHR7/EM+Qf10=;
        b=uTdP/s6fDmD9fm5qqJiwtxl2JA1wP4NCjZSOlnfmj9Fa3//FnlSj1t5jUWq72M/s88
         0cLClctzgUXZHsRN2k8vKmwZqNeqWp50aRkMjK6II6iim9t+PnMB67QEzA8rSZz/YBWw
         xbgTZ75sE2L9q/LqMhRCCJZ7z6LsAXZa/DIeAB9je2kDL//8N16NPnuhGMiOzz57FW1M
         sblvzX3YNhdxImPH/3pYATHDh5f/sA/8qKCvDiB8bpgX5dqBFs6FB7JYuH0EgFd/V37R
         roicTzmFcHdPQEF9/C/SIkMnxxME9c4AyKA6CZlhtBR/dIwU2MQB/6I0wK4P86mde1wh
         XJKw==
X-Forwarded-Encrypted: i=1; AJvYcCWxjhdYgNEkZvvU2hVugTPhzQ+FHAY/RRYYrU4Cj3EInJ2TyV2lvszixCNFQvQZMnMhROKjVbTeLg==@kvack.org
X-Gm-Message-State: AOJu0YycUW1MLBb4IZXb3DLQMOAP8xNn8zeaV5UjjMrqSUE8r1kVHc63
	NVX+5vgk7X6SOGHPuoHzSREtfYC0Y4LfQX8d6eib3cAf70bWSf+aPQlQ4c6C8mEXkd8S6o3M+h3
	R7JD6ZFNMW+bCJSv4OX7mq++9cohS9PU=
X-Gm-Gg: AY/fxX5TxZIKJE/7KboylHLdhzxaDBpqzpmEpH7YTxnu2ZptCi96q9KIIS9g6J93JTI
	bcVzZNogC/hix/wCVAFf4X4lgQN2wQpTSxnDRPZoKlfsVbf0df9jMUKsbTVM1bI3errkZ4+t5Ze
	g8PPF4P+n8qHHDyD9k3q0/fyPBQoSawlZzIrdW7tI1y2U8721U7j2Gc4LvwXGJA/A9UbZtujsAe
	kYk4bW3Ug3FTPkCgrI0MrzpThqt6hv0n1RL84vgzKbdVBDW1KMwq0WUWlzV/pPJGpPjnLuo5HHO
	7RGg
X-Google-Smtp-Source: AGHT+IEttbzL3TgeISd4JSQbWLlcIpr31jHSAc4dl7Ysmfw70BtvwM2g27MIdwEy92Jtor9ZBzlV7nCoDMgSPn0w63c=
X-Received: by 2002:a17:903:1a03:b0:2a0:afeb:fbb6 with SMTP id
 d9443c01a7336-2a0afec014amr148642795ad.8.1766060978829; Thu, 18 Dec 2025
 04:29:38 -0800 (PST)
MIME-Version: 1.0
References: <20251217120858.18713-1-pilgrimtao@gmail.com> <aUPiFbuaglcjqiB1@kernel.org>
 <CAAWJmAaxtKY50BEm3N8V1QTwpyCgQLfLFarrVfPVVpXg9ftmcw@mail.gmail.com> <aUPvecgVj8XXBcw5@kernel.org>
In-Reply-To: <aUPvecgVj8XXBcw5@kernel.org>
From: Tao pilgrim <pilgrimtao@gmail.com>
Date: Thu, 18 Dec 2025 20:29:27 +0800
X-Gm-Features: AQt7F2qe4Pk_SuV9V8zg1gW8M29Sp6bxxmJHkeChyw-ETnoQVSTJAeHwFR1AQTE
Message-ID: <CAAWJmAa44SF=dj+FTiXn0aZwLLGbSTAieb8Cy73RE0sGAkAYLQ@mail.gmail.com>
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: Mike Rapoport <rppt@kernel.org>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 345FF1C0003
X-Stat-Signature: 59ejrrg5ui4i6oh57pib1gifw6xj6ogc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766060980-766258
X-HE-Meta: U2FsdGVkX1/k5Xbcy7Y6/jw08EQtWe1VLmhejvRNnLJCvhY/MqBX6ezC9aRvj0x4nLhUW0DPD2AhZOrg7UF+3oZaxzU0B6MdFSpwscQ2nU4P7UaeGC0KNSyv73X4Yvz77UWu2Su7/6XLIheqLoztB8bA0X7Za3zeXi4iYCDOvloZnlRJPhh8efdtfegqBIgLwgW5+wPQFXUxFlygXssP80LD2DnbyBCgWc9VjSQOwBp0WtXL1kjRx27p5Lwa3cyrtBssHHm4v9C//U64G2w61jOGS3NC+iC9yCGckzOGvE+EnHhc7BwYkbWscjH/cE4f7rCLurhWsyevvFC/eR2/w4dQktzMBuQK73TWvYam7chAONrx8TNX1Xf5wPHp7y19y3pwXYWLJbv4Mi5VfDBqma7LnKSy1aPW08lz98nTlYDeXFBupbvyrJIdOT4gmiH87rCHeHv8XZUqyHCaavpy8Ir7wArpN9qnzH70qOJ+Njq8lACq7kcXiCBsHWuRIetMmK90zhFlw86qE+sdVdBXKe7B7VM5OcLrFXqEbXF/FcfGMaodsG1ovdu5OUVyvYAX/mr2Zu/487F6jklbKLmfSL2l95VZOsUyEtsYy3+nArwepWltglvtvn1vNBIGb+oWyau0eaIznY3IUdNS7tgbo0Q/k0ziyD6VPsS8t3eCNfF1FKgzMBpfdDe85MZ5EXXdUYiKx1Y//hjO4jJVQ5YqBUgYDnkeqwd/nUfrKhu2t0nhh96FldAuDOYG9e3Za3vXnRrDljRe20wJkQ3ifa36xtco8vBbnq+FLq8Ea5ptxWv3+eWK+2rLKFeUer6Xxeh67NAlG0M0JD1womUcR2obvW5ATJ9/wvLTf+8QIuWiBZklGOhVSfynLEw5d5uKYSefkHKU70XlqEaySGxilCwKuDPFZdlVjkc/9u7witJBuCkIhVSoQ9CrQad7X+UO0+OAwqdhXEBIBUeDOdnQoYZ
 NENdqz61
 ALRMQeW5DqxEXgZb0EHwVdJ/SELxK6cdGK5f34hKNI7fQKJ9qWYlh79HI1jBbUc2L/7Nwi/AdvG6Mk1sB7vpBu9U2QkulfrgZUqZwwxe5ci7EvGnKTvoH19+kg2uSlnMcJdBuWx9IqnrPzBFM3r9FnEpFuu8jKboDLjLG4I3HWzgnjJchNmvmChKwQ/j2i8+6IFyRSLvWvl3nR0QsXfJ/Ctp4K8V7V4Psz8Yd+bAxQ/YmcEvMJdn0g5EQnMmSylDiTIqBtuPRBq5FaGg0swksTT4poM+eUYh1W3aXlE9eUErqbRZYN1ECBcekSVWpb0q4cDvNNoTHN7psW8FpTWayQCGGTNRU4OSSu6eiXwLr0OE7m4dAEZRBWW8V062sgRtAN9Wf+cAtn7lIHZRDGsOUoijI4k1YvDMFjSlOT+x9C0XNep97cw9PYGkYqaSlVgFzM1AGkMsijNp5HUWX/DEcxV+VLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 8:11=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Dec 18, 2025 at 07:45:52PM +0800, Tao pilgrim wrote:
> > On Thu, Dec 18, 2025 at 7:14=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Wed, Dec 17, 2025 at 08:08:58PM +0800, chengkaitao wrote:
> > > > From: Chengkaitao <chengkaitao@kylinos.cn>
> > > >
> > > > 1. Added the vmemmap_false_pmd function to accommodate architecture=
s
> > > > that do not support basepages.
> > > > 2. In the SPARC architecture, reimplemented vmemmap_populate using
> > > > vmemmap_populate_hugepages.
> > >
> > > What problem this patch is trying to solve?
> >
> > Following the pattern established by other architectures, vmemmap_popul=
ate
> > is reimplemented using vmemmap_populate_hugepages in the SPARC architec=
ture,
> > which fulfills the intended purpose of vmemmap_populate_hugepages.
>
> But what's wrong with the current sparc::vmemmap_populate()?

The current implementation of sparc::vmemmap_populate() is correct
and functional.

However, I believe that generalizing vmemmap_populate_hugepages()
still results in certain architectures requiring special-case handling
branches, which is contrary to our goal of a unified implementation.

Another benefit is that it allows us to eliminate the external
declarations of vmemmap_p?d_populate functions and convert
them to static functions.

> > The functional logic remains unchanged.
> >
> > > > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > > > ---

--=20
Yours,
Kaitao Cheng

