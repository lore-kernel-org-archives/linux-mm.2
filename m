Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C071BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 04:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9976D6B0088; Wed, 14 Oct 2026 00:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948756B008A; Wed, 14 Oct 2026 00:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EEB6B008C; Wed, 14 Oct 2026 00:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 638056B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:46:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63DBF14022C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:46:57 +0000 (UTC)
X-FDA: 85319996874.25.C8CF033
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C5D840004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:46:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ynn2eBTU;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791953215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOBAAntqs+1udpw3fkkHGyAvF+q+wF+2NHy3MJ/XtcE=;
	b=1yEtOlNudsmY//QeHpTSnU7C6Zan+R6YAqRkNqaAG9yWJOSA/fMhKDA6VIrJIMYMMhHm2I
	lGkc0q/FOgR1tC5LpDwDpDe/b2oGXp2uRCEGGuCuI4/qaWsBvU6NqB/gMYCfSOxfQFEWCw
	N1KzTJUEO1YCziQdL/BzLDIGhHJpt5g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ynn2eBTU;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791953215;
	b=gY5LyNvhHatS2RUCKTz4Wce7FaBetSyFDPpXp3CSuFg6E0MH/W58/8jU7zyd1lXtrSh0Xs
	+RjopaMJTAi86EiiN5FyMssgzIF3bMCRRATSEpkxyEuRW/6YYrs68yXrqKkCBRtuh+Tp1z
	Ej7LyNB82zw/5JGcrpodtn4st5PNlnU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4440E4402E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A1B1F008A3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791953214;
	bh=GOBAAntqs+1udpw3fkkHGyAvF+q+wF+2NHy3MJ/XtcE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ynn2eBTUc3w60hIV2e288f6OYMHEdO4qJI26rrf1lVAyKpxPGrnZc9kownP87KKEQ
	 IKXLYw2lhm+Zz71F6eJlpA8jpO3TpRM0TOy2uPC0cbVt5CkQNuCG0p1g+BXPq2y69y
	 n0ODVYMgK27HfizdR5eHGEpwpba/qsVKtsQPhsWVqr/jmjfssBYWqtCKElsXthRTqm
	 /4GKAluI8u73xS2JfxrGL+x/rrHH7zE04N/qRwfxqlMY1Yw3xs6kDMX1MUk8opBGt/
	 qvA7JKnLRpEoQ2BI7MwlYGVwy6Otke0zyYx4dv3UNgctuvPafrPLXnhjmC0VisP06z
	 OXyI54Vx0BOaQ==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93cb9e9405fso192507685a.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:46:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz0F3PE+C0lj8obq5f8lZ4U8Ec/yibHu53Z3OG1sWxUPh6uY+OxHv7INc+o42umFldInay5E9KN0g==@kvack.org
X-Gm-Message-State: AFq9FYJawn1Sd3iXqwVBn0xwqkyU78ObIPBrAGtvHXVxp9mUli2HNtB8
	bCmMxfsNbuSeoEuxFy2WNpFbivgMCH0RRNXlwQGPbgS0Mjg006VjNz1F5TBRyzGZ/N9YxlrbCXE
	OHgEsTf8nIHjpvVeEjt8wG43S7AmGfxU=
X-Received: by 2002:a05:620a:370c:b0:93e:7944:b874 with SMTP id
 af79cd13be357-93ebd244676mr2342724585a.33.1791953213386; Tue, 13 Oct 2026
 21:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-4-max.kellermann@ionos.com> <a64f6a98-de70-4004-aac0-312cb05aaf92@linux.dev>
 <CAKPOu+83bH2CRtiAio+1VTTQrYFF9th5XfG5wL45ujEavPS3Dg@mail.gmail.com>
In-Reply-To: <CAKPOu+83bH2CRtiAio+1VTTQrYFF9th5XfG5wL45ujEavPS3Dg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 14 Oct 2026 12:46:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y_c3TZb5=rNK-sQ5bJWozL42bGo_zgvAtY6hW5eoMcmQ@mail.gmail.com>
X-Gm-Features: AclHuK_pOHHzKZZH_dTCG6g8kkCM2rEF8JtYxcMjCWMOy51d0raKwsKHCVbMgDI
Message-ID: <CAGsJ_4y_c3TZb5=rNK-sQ5bJWozL42bGo_zgvAtY6hW5eoMcmQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C5D840004
X-Stat-Signature: b3grzcm847ihrfd1kxte841dz5qzjzpo
X-HE-Tag: 1791953215-515903
X-HE-Meta: U2FsdGVkX1+6HYcF2nZv5vVVQQsli3tUoNaIP8byi/VhQdfvrGg9q0rP2d5gbMKpIR2QY3mm+2wrqUqWOJm4/gLKZ0pz0aDo0hBZR8dnhoumA15HqBmM3nnt1gYhvB5CyqatyJMkpTsgP80kQVgq08aMkFZsIpikD3LSZLa7ZPkpBlDSEXkp418gh3QKoP4I31gDAWxfaXiiJ8R5lxfzvqd5oE57q5l4E5jpSU2tRGVIQnYWFYc6pBTyf/N6uH9z7DtaaS2deVga9mJFHTHywPu7zvvCp56L/wyK03fy4se1GI+K9h6t6IMRbqGJSosECWgW1k85NazuawDZQNBBTl9rLAW57xtjEZkAu7RWpJssYDVN5ttM2AtyxBlAi7hreBF29/fKquJGNvSqVrIvXB8Qrt/3GT+fOyZx1ioeb0oXdcGmYANcOKOme/PXXARyAbOw9ql6aURym7pvGfty3sj1+48WZ0HCzQIo3z5lzdTfHm1ta7jhF08mvG0Gg+Zr8PTY9JdBuxdUHb6FGQssBzKMCBYM9tA7Ppc2Uhnh7NoRMkRCZxTwSMaL64IC7Nlc9+W4OJAuBHjKWT7h4CvXQCIoGTtwLBDDhf2atNTUTsa5eNQtABbRf332AoLAflSAixAaoecNvXskXPreL7Z4XGtcLEuPEpi6QFfT0Pjyof7dsv62+hYyOwQJpJUc/gMHB+C8tt7WUAuDw6+/wn+Xx5v4AM0F9HWy9cZj4R8TMVJaxbjs5zQwEwyo9s7Ybq56kFd3Qqvvmp/vfEpCt42YfGrPq2E3K/vcwqYLg9r1lhZlWUnrI67dIkOqbeTdLXHu/uyjs/LkruRsy8oxMfeWLRF+IuwUuhSsB2zSZww5xo5UP5V+90FnRXPokVntzNjDYZQtGXWaPCgt1qoQLycgMuhSNzl/jVtocJUMVFQFCNt/KNsm7HdPVPForl8LmukCgxiENRCI24x++q1v/ml
 EGM6rqAj
 cMTxkYkEgmaE67C5Wzes7b57Jg5vnN7G6RxyyCY0fpRSBBmC4mT+kOPr+QBIH4fLJsRlwACGbebI33CNap4RiOMuBbakT0D7PwTxI/NlXXVlo1Gl7hONCtId3z2umaKDzZDtNlL1/fErlrOVuSg3/+mNIrXLeDiHoKpq+GhVzzGo5hG9dtAzqJZqHP7fpFVD41FzHiSLe9REdR2NOZqKpf3LCvd53+yLe7N5Nj+Q9Kk5rta9ZAr1TJMOEP4zGfDUc99LwWvNYP8Bh2Wr5uoL3PivZ4FLL0B6j0SlzlaBTjAYDAc9QufhBdDDXpolV35PouKZyJY55Ogam9C+cmx5MBLSopw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:58=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Oct 14, 2026 at 5:31=E2=80=AFAM Ridong Chen <ridong.chen@linux.de=
v> wrote:
> > I've also submitted an RFC patch that addresses this issue.
>
> Oh, interesting!  I did not know but your patch, but it looks very
> similar to mine (but without the hlist_nulls refactoring so yours
> comes with some code duplicating the hlist_nulls header).
>
> Too bad your RFC went nowhere, that would have saved us from a
> production incident...  Anyway, even if neither gets merged, I'll keep
> my patches on our internal kernel fork, because they do help a lot
> with our workload.

Hi Max, Ridong,

Let me discuss this with you and Ridong, run some tests, and get back
to you. I'd be very interested in getting this optimization upstream.
I'm also happy to discuss it with Ridong privately, as that's easier
for me.

Best Regards
Barry

