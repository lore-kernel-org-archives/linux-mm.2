Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23B0606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=foOOITXi
Received: by kanga.kvack.org (Postfix)
	id E5CC86B0924; Tue, 27 Oct 2026 19:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E256B0925; Tue, 27 Oct 2026 19:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF1C6B0926; Tue, 27 Oct 2026 19:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5BC96B0924
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:57:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D7C51A0B0D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:57:21 +0000 (UTC)
X-FDA: 85370070282.27.8D94CB2
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55726100005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:57:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=foOOITXi;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of charsyam@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793145439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyLuWatZQwuD0wqN6huARvqhfVRglzi7qhQ3+et65cs=;
	b=W+DImqF6CZbJR1TZLQjA3d4pJMPkvGUwoSp+HUBqEAVeiZ44WhUH0K64MGeJun802HZ5K0
	m+GK1sEFWGBb6lEV+sYF02d1CHpOVMBkvIT4KaN6GGzu09Qsf5YC3wdFFnTjnMEFbFbHbH
	aHQX9WYst3Rjk0lmp9TUMjcq3ZGw77Y=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=foOOITXi;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of charsyam@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793145439;
	b=oVdza/zJ57FAFqpsahqUlt1zJNR0LuW555Po+rEym0z5im+7ZHLQhi7rEK4alTXVXXYOrN
	VBDvUVXwrF0SAe5MB8kx1p8elywFucjA3wsLegmng0YwfShOE8BrgwjO/a5PkGpMDnhPYc
	GBJazaqRMj6ycUh+KT2NkRiVZtuW7a0=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8a376759900so642477b3.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:57:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793145438; cv=none;
        d=google.com; s=arc-20260327;
        b=ne+a1D4uhCYMixb46dHjxKn6LiinsQ3TSrZN5gT9Ck/ea3gzqeyngCbBkqJhK7d9rv
         K3mON0f2v9X9qizJYoCFpRBOuvBY1SrKDoNz7cmoD+g+nkJqANB5gwMa7miz5/iMeHLy
         dQ7hgNmOo8FFbxXZz5HsoRn0yr89oOouyIr9Apll1xAtPN1l9mLszTK3HUV+X/MlNce6
         rtSqkerxPVlS4uCloAXjA7QovU5jC3C/ovR6H1IWeEKSxMdob99SquJyXDKkdZVSGP4n
         JcNvekpUxmeBNmlsouvgTyo5N1jw381zYpnibT8vxuSv6+Jc2DAsUvMwvqBMqrZWLl8H
         9zhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tyLuWatZQwuD0wqN6huARvqhfVRglzi7qhQ3+et65cs=;
        fh=yJ/vPN4bkbQHe+A87xjs5LI9+jNkvoyYEDgf1WoYXr8=;
        b=aKtFilTKDhZY5JJMBsiUUSs2wG8g4RU9pqwXYPSgIO4P7xK09VdniJCWCwVrEHLHFd
         uNHDF/vFhLsxgWO5v71dOqHQdHmQh+TKJVNNva3dWLRTbFIGWBfen4IP7NigNPUdzf9s
         r/jyUUYosEOeazb4Nj9xNXqYS6Q3DzkqleinL7M4tRp4EXMtIjwq/hweyFyeklbHp8+I
         ZKNo7sw/GZeS/Tb/JGhxrGVg64WSNkwaLX6pMon/Cyb5wF3XxGSKigLHSfGc0B351oEn
         FkFv/NbISK8BtEa0bVWrIDdzeYwJw/6hmnBFCpwqjTsd1u9eteV9cVntqWF3PenbUo9I
         NVDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793145438; x=1793750238; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tyLuWatZQwuD0wqN6huARvqhfVRglzi7qhQ3+et65cs=;
        b=foOOITXiHfbOkryBKPnwlMqWShiW9UoaJ75svOy3XVYu5caMTYb6MsLLBrLCnDMM2H
         ofqYY5Nt3lKU/kb42FCe0yq9PcofTnm5J0RrVJG6kOHatCIHrCftBEej99LY9M8u2ujC
         uwQkMgl+6BkxCsQuiBYrPA3GusIrvVq29xvBX+VhZLZ17d6BSvrH7NyaC/XqAE2GiSt4
         0MBBqB2W5EvPY1CZzsUhgygttuNhxUxIg4UN0IymDfU2cSPDRa1NUxSCZDip43AQyCkW
         2PX0bg8XWV+Qzrxj0kW+eVsaP4kx1kmegaY+gKVvaCjbRjjkV0rO7rL3rcQCVJV+IM47
         wImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793145438; x=1793750238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tyLuWatZQwuD0wqN6huARvqhfVRglzi7qhQ3+et65cs=;
        b=iarl50eHeOonTGgd68VhQidC7ANDtzg6Gthj14Lf2dtLdOtkuP09g4Denzw330/jTv
         LgDdOqFYhN/BOTthsOGsj80CLlX88cf+klD0xHp10NepApKY6zm63tzCoY/vZB1Vg4z0
         NL94byKbabpCbm1Xa+yoLecwqQsU/U7E8KivgNb9+G4IOimA2W87EBq22TpVxcFaGBuE
         GdetBq20jhaKAsp8uJBR4fnRU9/vC26/lvZlqpcEwv2pExFeE8Bfc5nlCIfUvbyFKegE
         bEHmnxA3q+QhXHlZT9OuG2T/OZ7J/sVHcBx72dUIGt629plYXETxtZu4aMUH3P4RBtly
         1YSQ==
X-Forwarded-Encrypted: i=1; AKwUvBy21vTCNPfBcEfEWWux2hdKBLyX4Tu6IbQISfd2xgfKHsGxugkqXDzQYnJcD16goGD12vRhmU8mIQ==@kvack.org
X-Gm-Message-State: AFq9FYJVvysHL5W/YsEOlfUXrQiqLIQniZYJlaWIC2/4clVUXaliCp9e
	Ij8g8OCcAN2kDxElaBqG3mSArPJMU/yZR5iJz0J3Mqtbd+WbPNPRkDb6a1wi/b7cC890LJQU4Go
	JTWN0krjzymAkwCGFkyWOAvtBgPiYwbeYyduo
X-Gm-Gg: AYBFou0WWt8+varK/RQ0qxYpyKlL19oAm9c4/HRKVtg1q9UucAiBgGeSmS9IkRjfcjV
	FTxyFzRX0pTh1PfUDnDNbrN41ucIHxgW1DROVrTFwxpcgin1xyRXEa/xKzb44IkSxSERgWdMoyq
	HWqzlQVcqfO4w6nwwOhvnOLkfXJPicevLqQDI6+BeLY+hhkNsepOSmrCMSiSjfibVEzHb+dMBq2
	oyvFNUc6VcGHBjJeaqNNYJVQ6C0Mef4U6cqGm2mRj1LQbaqWO0Q9UuDSBzpPlwr4i9soMNpMHxM
	wnUREOFo3rs76D+f+StHyySs1bVpJ+8tNOAeTdOI9V1cc2WJzVFD0Fj2jaN6SeyB+dROBADJDjV
	DP59qUiFsfIn6UbW4YT0b8NOvMhqzzqMsBF3k/yk=
X-Received: by 2002:a05:690c:a1c2:b0:8ab:3696:d86e with SMTP id
 00721157ae682-8b1b5d32b5fmr5371157b3.4.1793145438420; Tue, 27 Oct 2026
 16:57:18 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027035431.1007584-1-charsyam@gmail.com> <20261027135354.149948-1-sj@kernel.org>
In-Reply-To: <20261027135354.149948-1-sj@kernel.org>
From: CharSyam <charsyam@gmail.com>
Date: Wed, 28 Oct 2026 08:57:06 +0900
X-Gm-Features: AclHuK95AvTLehgLpYDxlvAp4vsS4yVkPrgwzegsV_wexP6gryXmq4iIKOugNPQ
Message-ID: <CAMrLSE6ySuzsJJX-KXoeG49pS4ZVbNWZve1dwj1v1avAhHeEdQ@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, akpm@linux-foundation.org, 
	bijantabatab@micron.com, ravis.opensrc@micron.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 55726100005
X-Stat-Signature: zrn36aj5naou7s841duums3t18pm3nmi
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793145439-747812
X-HE-Meta: U2FsdGVkX1/a9kQtaPd7I6TCXl1taknC8vnqdNqzKpYu0RsTr/0EkMPF+vXiI8GSE3MhJ1Leh006+7NrRTkonrAKBAWFsfu7Yq+eOGtjQTp13IauY/uRs2A/gMf2mO+gkm3437aaXu/lz86he0Z6jg862TNrQiyhQLgTMqt7BJDdigmC81RFXFdBxWrhytT93twqWRo/ZhBO1pMXHC36W85AqMNgMEGEa164pgoSXA8y0EXGD0oGINlIqmNKrHrMvkLs+YZWJcB60FvXWDR4Bq5A5uibA3rEndSTcpKJiOWIbe44BYU7jfNvTtk5FJjkEm4u1VOV5VabxNmjRwArGce67qs/bf8IwXzfyt1QMftBSAIASkaB4qoK+BPLHs36SmALIA0jyMORCuZbCpbjpTLEcErgv9oq5whw+Vbum4M2xJXQOVHLvBDiithE2s6LwNYiCo4jDJs5D6N942gabcL/vT9fqu+1vo243nT1OeaEqWD5nUJJsXDyW8IFX5ZPcYBEtb8uv2eus4w6D8T+n1tPIbN/gdbvterrUUAVFa2R9TAkumDaiwu8neqpcGRyQ1NPY4kWxmrVhMvkqWuRUVGN/zZlbiYpmUEyCXIJNTqjrsa16DTvWj6t+us6I39d0kYrPpHUohoYhlqHsTAHXgCBnLYqt0Ozdw4YdrFrE73OxJoEgQZVfOVuYdOp0s0eWNq5PCKC/3HL1bI7UHkIC7m6zQT2MjN0VKf7vJ37G27zet3xMYk+1fPq0v0rIkwD7dS2iksY64yNx7drm0vp7FHsHyPiGIN4GvMlAGhEPbHvDVTxRSZ9JqBwyHz9/GrLe2L7eUtaqZ4pTgF0nYyJKUT5KhunrscD4YW88C+Res6NbL1cu/93NUQ6Mq0TRZBNQmGMjj5AZg20x/jh0Tmy6LhQqrbn/M3ghEiSlwCmiYmHUe8UUfvrrQ+fknzfnCj6DvjWy2pVN2zb6JPvDrg
 6uzeIFBf
 KZErMcXE1k+LiRY1tiBnBexg7BNejzm0lLcerhdxqZNjNACcgXHkN2z5K+NnApKxXE6feFL66UUEZPRvOA65/sg5apghcy55iT2s7esfop6TR8PpmKrR9by8CLJzkzZVhft5+Pr4uOiaHXMKOlnrxp9a4hj7qLkhV9uLqHbw5Y+tDGpVWOsbgc2JvgHfMvwwbcbhRHd91QD6qEwYDwUr0N07B/pWLjaFSW/Fu1Xa9DmtgFlgMfNQcwn8UQ0PjG5dnxwMw9fYJ60yU51mBJCmfqA9w+HwCDneKeKeg3DN1woGHorgTarFgPVLYhA4+HztQzgMaiKuurORatcCSCxz20+L2Mj7hUD4JTYKSafpsD6Ic8jcRFcRegt5OUFFWcN6MtAS4yEFMyeFEbflyCWbmXKEWuDoBZS+lMkfqdLy1UOZRQwgZVw79nbNcShZwrcJeES/+b9c5D/kq3GnlG+/s6onI1x9lWJwNGJvc/xwsozl2RddJCzsb5l4sSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, SJ.

Thanks for your reply.

1. I found this by code inspection, not from a real-world bug report.
I consider it a correctness issue for valid inputs.
2. I would prefer a u64 total over rejecting those inputs, since the
interface does not document a limit on the sum of weights.
3. Given the lack of a reported real-world impact, I do not think Cc:
stable is needed.

Thanks.
Daemyung

2026=EB=85=84 10=EC=9B=94 27=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 10:54,=
 SJ Park <sj@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hello Daemyung,
>
> On Tue, 27 Oct 2026 12:54:31 +0900 Daemyung Kang <charsyam@gmail.com> wro=
te:
>
> > DAMOS migration accepts an unsigned int weight for each destination,
> > but sums the weights into an unsigned int.  If the total wraps to zero,
> > no folio is migrated.  Other wrapped totals select the wrong node.
>
> Thank you for finding the issue.
>
> But, is it realistic to have the weight_total overflow?  Have you found t=
he
> issue on real usage?  Or, theoretical?
>
> >
> > Sum weights into a u64 once per migration walk.  Keep the existing
> > 32-bit divisor path for totals up to UINT_MAX and use a 64-bit remainde=
r
> > for larger totals.  Add KUnit coverage for the actual summing path and
> > for destination selection at the overflow boundary.
>
> Do we really need to support that user inputs?  Unless we have a very rea=
l use
> case that require such huge weight values, I'd prefer not.
>
> How about just clearly notify users those are invalid parameters?  We cou=
ld do
> so by adding weight_total overflow check to the central parameters valida=
tion
> path: damos_commit_dests().
>
> >
> > Fixes: 19c1dc15c859 ("mm/damon/vaddr: use damos->migrate_dests in migra=
te_{hot,cold}")
>
> Should we Cc: stable?
>
>
> Thanks,
> SJ
>
> [...]

