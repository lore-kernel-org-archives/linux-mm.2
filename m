Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B3FCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517856B0093; Fri, 22 May 2026 09:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7EF6B0095; Fri, 22 May 2026 09:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4149A6B0096; Fri, 22 May 2026 09:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32B986B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:37:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EB3DC30CA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:37:04 +0000 (UTC)
X-FDA: 84795156768.04.7AF88C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 938EB14000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:37:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1Lmx69E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7jCFBMio8K0Or68UFlDneGQgQYEn3dFY8g5R8vlQ3k=;
	b=090VO68k+NhdXmrv+8MJ/AHV5PiTggXsj1YcdRIqRdOn+ogvMEoI3Mb/SxCkHxJfiGk2Qb
	tz82cDX1/GJYLYsc/8i6+bq5boWFyCMJrITEibJA/Tjgex1a/UFgP+WBfnpgRskPjCV65Q
	eFNlAu4OzSgaMI6DI6uFz3P3pdfegBw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1Lmx69E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457022; a=rsa-sha256;
	cv=none;
	b=2BgL/YeyR7c+cb1dFZnS2SzrXpKa0dnrHxxVtXcpdYXt9idLJmSZBEXiMmjRf9XN9kRW3D
	WtjMRCdlULNL5+uZosLLfk908MXJhqKyhkftPzSB0kiPn/UOVbwmzcynFuUcRZ1oz/TswV
	55Q6zcEQT4nxnvEltIHeVpTR64MxiTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEAA743732
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9602B1F0155D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779457021;
	bh=C7jCFBMio8K0Or68UFlDneGQgQYEn3dFY8g5R8vlQ3k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=M1Lmx69EaUGXfKI/c4USdBvuLwGQ+/xDCp4Vp2puVY6ZVXRCDmufSHznXa+ntyhXN
	 R03Kuwv1AprVs4yPERWo4NbQ6lZsPmO6iCC/9GUirAMY0+M+mHVmM67vgiOEeQfZjX
	 qH2DVgBBbWmPXsgRifjPILuXvi3SJLcMXcM0wbWNl8qhQGF1QfErk7I7BNcOxwV9vI
	 u01x6beglrUnWbWd7SFgp6j4isuYGa2aNX+AvmEUhYmNcdfuvnZ1//oQzj2LfcTXcS
	 qARUt+2asSCPw+6P5/HdLjtNTDO/B6LGeXnFuulXp+QDrIVZut92w0VUlrkRn2AB2G
	 8trVtwiDj10mg==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9144163319fso708011585a.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:37:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+24oSlWm3g6UyZZWqDBPOXU/L4Vsa9q2mAg1eSzP9ffuh5VJMghDCXTRASquPub5QYzyELcx1+eA==@kvack.org
X-Gm-Message-State: AOJu0YwzuJFAwVE/Za+dK4C336nasnkSowBZ9FuM/ztJ9JPBCQ4moRU3
	QJFyXOrsrw9rBksdXHlhl1chAfGH3xYVaM/piVErBTlb2KXayu+p+3a5kVLVeJHSR5/jK8Vvm6e
	ddkV/x49YNEQDLTg6H/4MGsoMJBfGAV8=
X-Received: by 2002:a05:620a:6504:b0:8cd:b2e9:b964 with SMTP id
 af79cd13be357-914b46c93e1mr518488285a.10.1779457020872; Fri, 22 May 2026
 06:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <ag4kj84EcKqamdB-@casper.infradead.org> <20260522023305.98223-1-baohua@kernel.org>
 <ahBVh4NM2uoyhPNm@casper.infradead.org>
In-Reply-To: <ahBVh4NM2uoyhPNm@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 22 May 2026 21:36:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zQuJx1reJxgV387Gh0AqWF0KdoFn9KahQ1BNLPRm57TQ@mail.gmail.com>
X-Gm-Features: AVHnY4LaSBeriPtvEQSWcigqMwNrFp0xeuPJ9HmpgpM3WX7gXW9tFi64IFdXgU8
Message-ID: <CAGsJ_4zQuJx1reJxgV387Gh0AqWF0KdoFn9KahQ1BNLPRm57TQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, chentao@kylinos.cn, 
	chrisl@kernel.org, david@kernel.org, jack@suse.cz, kasong@tencent.com, 
	kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	liyangouwen1@oppo.com, ljs@kernel.org, loongarch@lists.linux.dev, 
	mhocko@suse.com, nphamcs@gmail.com, nzzhao@126.com, pfalcato@suse.de, 
	rppt@kernel.org, shikemeng@huaweicloud.com, surenb@google.com, 
	vbabka@kernel.org, wanglian@kylinos.cn, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ij4inkwcu6gdk975o6yog6xmq5qqj3px
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 938EB14000A
X-Rspam-User: 
X-HE-Tag: 1779457022-830513
X-HE-Meta: U2FsdGVkX19MV4uBjhLGtH4xaMlQ1PNZZSB9t20zG7cRDd93mP4N83hcgzREUvdkL+Pozm6DqmAXdnFeH3EhE7XygvbP+a1LeOp0uRdRGXIjRJbY6lZY0SPKVz9W4WgQMp2LluNVWFt9VWvRBktB/WT7mwNTDaxEc8Ca2r3nJPZYAjVzu+1lMfQn0OUd60kjpF0SfatXx8LcYNTD0gAPGNp8FhDtBW1G4g7f2jCTuvuxM0GXcDffTv+b/PfNYCx+DqPD4dBmZQK6BMyspr31hb8BOnexOaN/JnMyWalfQi4/4hGOQus1N++3ADD93UrIQBG4650klAoLpW1l1gjDkQk93YNJqzDqQpjyGCeFm5yH778BmgFr5IzG4OAR9bEcgtDjuo943xwYJDPSWFbW3hXeJ3GNHczbm5U2Y38Y6vPaPQzOdvG4H/og8PCaxxlvjN+NR85NHWBr0AneSHB94OzhzF7HgBHwSb4uHPz6rh0cyrsTckEnpRX4za1ZbOpthplWVrwiee8+8x/kuJalT8JchLLAA1cHVjwUmRh8GA7sbOFDBZWUfAQQyqZreDz7QNtxCwbvqhp91sO+ZPpHNtTMykmLOWJMyJj4LIRX1WYBNKP2C9EfgvyDdoSqiauMlFa1rit9BuVs50xPGCsRauroPYLhf6X+YWI5bMauJjFW19vVA/NQNtqFHTFq5na+px2u298JGMv4VSSKzl1LwwG89MkCUq7Z7LXgdQUGwYWVpDvA8ZXVtsqYjK1B/GseOrDHIXo9WETR5szqZ1YUC1Pn0Z815ju6xZrrXbQ1OHoCFAS6vSkdjBq0le7K0gfTSfOEfSyGafoPNK5ck1f30fclSaYXw8OdwjOl5I8/ueXWm1uQdwL6gRuTLoB0NTOwpNQm1AA+TliR81uFqzqcK+la4RobbX+j1TV26mqhSMW/JcKWDtilHsqS/zkbBsx50Hjg14rTBVni7puVoJL
 rBI80qdd
 YqH4zN2FnOKLiewie+J6UPoIkiiRojfQVLqu7rkrP/ynSEOwDBNIcO+VpeHv4SkKndj6fC+TprkeXsdmGd6DKBjtfryi/WcvrJpqeP+7EckoiKynKFhb6Oo4YwyhYSSZfM/SbngLBub8yCd46zP2XzDBHua/3NPG5RlDyS5wmrEsqlDzOhwx9X+jE8pfc6KTUSFLq0HtqkEL/3zL3NPzic5TjAbZ0jsAZYOtBbb4xl0QKEXc5aVLILVb7iovrVDoKyQVpztkAcEfxivQysrJ3JVCW62ekv8YVJFsrvGKKOPuYgEEtkCy9U56Bv7MDab0jJhZWydPMAsAUYDIyrcgJHj7+hyDiAkJ9MMSregxxGLBnW88VA1tol5IiaK89KjzCWeK/YfJ21hZPARaPC+11i6690wyubQ1T1XGtQ4/KcD1kenf+1T4B1APZBsbz1Tnsfl4X86WhaNOlSVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 9:09=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, May 22, 2026 at 10:33:05AM +0800, Barry Song (Xiaomi) wrote:
> > need to touch `filemap.c` at all (probably because you are already
> > maintaining `filemap.c` perfectly):
>
> I'm going to give you one chance to apologise for that.

Apologies if my wording caused any misunderstanding.
That was not my intention at all.

What I meant is that filemap.c already has a very
solid design.

For memory.c, I had to touch several places for the
blacklist; otherwise, the kernel would hang.

But for filemap.c, I basically didn't need to touch
anything, and preliminary testing shows no issues after
moving it from the whitelist to the blacklist. This is
probably because the current filemap.c design is
already handling some aspects really well.

That is all I meant.

