Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5741BD24458
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 18:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F506B00AB; Thu,  4 Dec 2025 13:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFF76B00B1; Thu,  4 Dec 2025 13:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE896B00B3; Thu,  4 Dec 2025 13:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4886B00AB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:06:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A1CA1396C3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:06:55 +0000 (UTC)
X-FDA: 84182569590.27.E66EF27
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2BCE140018
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:06:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FdkInuLR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764871613; a=rsa-sha256;
	cv=none;
	b=CmK7O43PQwzOelDXE2TUoa70tY1Vmgw5y0koRsXBIWZxOwy4m+5zdm7T1pq6ixAyFIStl/
	ahU3bpqfH57QhslJvLdmeuw7RVoRESIhAZl9x4Jo2Cj1Veab8+dKW/asBwIW0zMUpS0Vq+
	QFVIv7jyGE3qp2jI25wojxe1liFDIvM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FdkInuLR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764871613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rrdp+Zf9csQrPT16ROUyOy+alatztNf+KHjGfCRhUpY=;
	b=xpqBrGIneilxYysgjkZQi5/lbhZ5SJ8Vlb0RXv0uxkhU3Zm6YAAbE7zs2bmUUZWAW/eIac
	GerPAXXKxF7yViZgV0t2k1MuLFKwnB5w5bUB/F+qqu29HDGlcShmcZUP4olxX6K92uROlR
	QCXyioQYMRw5fSRyh93X3pbXClBG458=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee05b2b1beso11121311cf.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 10:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764871612; x=1765476412; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rrdp+Zf9csQrPT16ROUyOy+alatztNf+KHjGfCRhUpY=;
        b=FdkInuLRFJXx5p/z8YpL/PdwocrKRvu4KxcF2wwtMx2EoaHIJn0tWyGh7xo91AiTIy
         B6mxQPwI4OabGC09WGio5MFXBUEqPhR10IBhGJmAit9tQRdFVSumRd+dwJKODVfpIxsA
         S06D3l8nEImvPfiaKGGwshQ3c43a7XdCIX+ZsfSbfG2Lz57vbnZbn9kDvTqjYgNVF2EU
         2gdl6BC/N2BuTZQxmC1Jsfje7QalSdTGr7cgD0gqOJUn4AvXxUDcsAErKs0jl1E1rlwd
         wsXhPilUE5vdHhTouhaZLEAtfUCAKmHTEcfdg7mjlGXhfkNgQouThdmfDGGhHgkgi+hV
         bw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764871612; x=1765476412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rrdp+Zf9csQrPT16ROUyOy+alatztNf+KHjGfCRhUpY=;
        b=eU5xndCIxB1hRu8WzBmbs3CcZPMmUdJS3BVAsE2X4MixYIcYNfcN0d2OGCeFEtz9Fl
         iOqgvXgH+KWWkkBBO+yMb9wR/e7xSbbZnOnWVC0SikY9nnToDcuRVvfW79cOMd9U1l30
         mytjRD09B0VPYjelOBEHmfML4aNavGju3Abv3PLP+gNCm9n2sh8GcPmioufihnxyDIjY
         A6qQkJMIOCHaGQ++v6fpP1L+u3WaQVwzSWekBxKylPKFWv1iA7KgLuVcUZBnYDw9WIO5
         rz6xeRizZ6p6qc6cVM5ODdy5htPC7ax0b0dTL37ll2ATUjrkujlMp7Mh2+mRpYn3XCCU
         d7xw==
X-Forwarded-Encrypted: i=1; AJvYcCUFe/oKwywLTKp6JQzKEX2CM5beikAX0FAP2NSsTwyyqNawLRkRa9gLctz43Uu5AN5jkaBFp7opVg==@kvack.org
X-Gm-Message-State: AOJu0YwhNmnbZneuCPGpYtR+2pYMyMOebnxs0NwDrAP5ZGEwyt2TVnv0
	a09IV/pzHfY8m8smsmz4KPdJv+1QdbIqN8aEF7RUDM5CuNwgJxxlvHXPo566Gifr42uFRZ7pBVz
	OCNdK3Bl7z6iyMikfL04OBUr++OzBLUw=
X-Gm-Gg: ASbGncuxXuIMCd13Rs75wQ8etgG6srf3NrZtnCH89YVChyEtVXm/UhRmbIeFA2NkuK8
	8UA0EgqQ+kFDG98rEljK6ZHLukA9Fxm6HTdKFYJONE8HRwVzjE3Z16rFhzNDqLaI7ijVoTNY5IH
	Nn/e5yD5DVTZpLVJLtD0xOMAZk91qbcJL/HOgtycpIayT1oWsZ/xS0KFVK39fzxvBPgM5PvJCmh
	QYd5ooc32lTkQWDqlXJRpMZZ1ilV9rdBpYPI90AzGbQXrEcEhqUUQKeKdPA+m5L5Qb9Gg==
X-Google-Smtp-Source: AGHT+IG3fjIllf1M6OCTBTd4dSunSkyg52cMugpNYk6tQ4JIDEp/Anl2MiBIRm+2Hyasb11VlNQQzK6UXmCqQNXT5qw=
X-Received: by 2002:a05:622a:554:b0:4ee:2bfb:1658 with SMTP id
 d75a77b69052e-4f017655416mr83408181cf.45.1764871612155; Thu, 04 Dec 2025
 10:06:52 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com> <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
 <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org> <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
 <504d100d-b8f3-475b-b575-3adfd17627b5@kernel.org> <CAJnrk1a1XsA9u1W-b4GLcyFXvZP41z7kWbJsdnEh7khcoco==A@mail.gmail.com>
 <CAJfpegv7_UyTht-W9pimE-G6tZQ0nKU6fYo1K2hcoNSHYC3tpw@mail.gmail.com>
In-Reply-To: <CAJfpegv7_UyTht-W9pimE-G6tZQ0nKU6fYo1K2hcoNSHYC3tpw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Dec 2025 10:06:40 -0800
X-Gm-Features: AWmQ_bkfmaBxtqNiCodT9gGB1wJnTwkgc9tefeZRB6rVjqiHpy8rJCyBAd9v5hc
Message-ID: <CAJnrk1bUrL5z=K-yKGXRX8W0RtXrnnwiidrCyboLrr+9RFwnww@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	shakeel.butt@linux.dev, athul.krishna.kr@protonmail.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BCE140018
X-Stat-Signature: jxsobqegn94uy6ddp1dcnc7qzwbzttxi
X-Rspam-User: 
X-HE-Tag: 1764871613-870468
X-HE-Meta: U2FsdGVkX19apgsSbqCKhyEuvatkVz9b8ZEUzqIOBvsAeFrnjmtvhFE/lIyB898OpXrC5YAkMVLLj1Oil871z2Vv4jygQx37Lujk2g2bTR20rFfvZfkVEifpiioBkEgf4kp8AkpByPiA+nYvhPWpkIwPMBCTIwXYcZ43F3VHl/bHQYNktWiskDpSKIU81RtgTvEz1ou+LI5AuoBRApG0YUF7jB71th9n5TR82VLFJkhXbVfzYd52kBIdhAktlj+K5Cdz0fU58r46t0JWG9D52r9jL5gnWv/50eB/6JwN2ftGlVkFPREjc3xhFA/uR088hSq4raHcMSRtZJgAUdoJBwNwEn7ntCvt/5eysOP6Ep3QWiOyeqZ1Qvd4o7apkoM0yMImP8Oz+Yu7/VeUlxKgEZOPpQTRkq0Ax+7Ycsm8l6Ug4QT22cmPvdm1O/kLG8Umv0FDJEEM/ABi5D4Ya2HBAsbbgoetWQJrCDfivF6UatFsm/MkwIyWST4mlS0ohgcWsAQ8m/9D3j3EU8JF1gJc5BlDNIU1DFq8YLKSbkm+d/YpIa8MUiKxcVqlASQUm1+15xPS3uSHnBqVawiyyR5oZYBZtWHGx2rVPQ+UySePp4DutQjwo4WLdJv61JUfaJIe+iG7E/tABYW8ERPexG51QOgyXpZLmrCfLvSZzwl+TX6dwYO5RgQDLFs6KzQSK7s4Qyo8JgSCNqg9RFJGWuWGv4/5yNH8qylHJj8e4FeRnvqVqX2vxeZI1+XC8oa0JKMGuZt5AbQ3K+K4B9MyKxOgX6oEO80uQd3uQrHAUYHT+/LEN8Xk32IgaE1yyUrxABt/3wQdtEaRFV2gthb/QtrbtGOWIQmKXcKgVRpvrMuCi+O7u1F1C1o+Z71VmVc+OPGWMBuOKC7trGy7dU9V2SIK0NSG8hTqznQA4XYDSO+Fb6D/CLm416yPIQxwj5M3DNmKeEBKfQBIcaOHxWeuttc
 kkJbNw+H
 Q5poXPKi2fFIUFCpg9EP2mu4Nb+PwSQHpniZOGAlWZz6prqczIdefEJGcCiwnMNusw6XmeglCWyc0Ei60Z4tReeMmJH5XMvoBKh12gdBfQnAUUJq6NmBQHhQYHNdeoPNvYXXCjdkjH38t0/P1FW6GdZWHqY12bk8ROOsSByylSKDbjvPFvoS4S5oQT/44GyruveBe2WC8Z95NLBQNMPmhMqMce+qh1M6jReY78E7z90Lhdpl/rYN1v8kurAFs6y0a9GRVFVZAgfqX+hbzCl11cFueC6cadBO3ftCY5EMHSjnG2w/BV+uQEQ1ms8y9X57YA+nSrXPqQhB+7asr5gB4Hmvrvy+wrvrYlVUOzDHFpD8cTiYGaUlQB7qMJZl483JZ51NKC7gEP8yJWSAmdaAsxvU+PDAPKHG9S+pYWsX+xr/y04t5ZBjz7wHRhRHAW+wHui0b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 1:28=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Wed, 26 Nov 2025 at 18:58, Joanne Koong <joannelkoong@gmail.com> wrote=
:
> >
> > On Wed, Nov 26, 2025 at 2:55=E2=80=AFAM David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
> > > >
> > > >> having a flag that states something like that that
> > > >> "AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC" would probable be what we woul=
d want
> > > >> to add to avoid waiting for writeback with clear semantics why it =
is ok
> > > >> in that specific scenario.
> > > >
> > > > Having a separate AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC mapping flag
> > > > sounds reasonable to me and I agree is more clearer semantically.
> > >
> > > Good. Then it's clear that we are not waiting because writeback is
> > > shaky, but because even if it would be working, because we don't have=
 to
> > > because there are no such guarantees.
> > >
> > > Maybe
> > >
> > > AS_NO_DATA_INTEGRITY
> > >
> > > or similar would be cleaner, I'll have to leave that to you and Miklo=
s
> > > to decide what exactly the semantics are that fuse currently doesn't
> > > provide.
> >
> > After reading Miklos's reply, I must have misunderstood this then - my
> > understanding was that the reason we couldn't guarantee data integrity
> > in fuse was because of the temp pages design where checking the
> > writeback flag on the real folio doesn't reflect writeback state, but
> > that removing the temp pages and using the real folio now does
> > guarantee this. But it seems like it's not as simple as that and
> > there's no data integrity guarantees for other reasons.
> >
> > Changing this to AS_NO_DATA_INTEGRITY sounds good to me, if that
> > sounds good to Miklos as well. Or do you have another preference,
> > Miklos?
>
> Sure, sounds good.
>
> (Sorry about the delay, missed this.)

Is the reason we can't guarantee data integrity because the server
ultimately controls disk persistence whereby it can claim to have
written data even if it didn't? If so, it seems like NFS / the other
network-based filesystems would also have to set that
AS_NO_DATA_INTEGRITY mapping flag too to be consistent? Or is there
some other reason?

Thanks,
Joanne


>
> Thanks,
> Miklos

