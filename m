Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44BEC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95B16B00A2; Thu, 30 Jul 2026 05:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46026B00A3; Thu, 30 Jul 2026 05:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35686B00A7; Thu, 30 Jul 2026 05:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B19966B00A2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:31:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42B5A160867
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:31:05 +0000 (UTC)
X-FDA: 85044924090.07.96BC815
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 637AF100002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:31:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3Pv2QV2;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785403863;
	b=VvIF9B95xCvLZO6VYk/bEg1rj3Ija2sOCOtDxcpruZ2HyU3EKY5o7B7rtL6dX/sdP8YGY+
	NWPTAdWkuIMt9kiWsi287i4uO2w2fVGHZMlWmB8nHpRU94pzuGkIofzGTVPl/cOEmawRue
	gwMwiYXD+pthuAsTsR3Xv0MuTPidtWI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3Pv2QV2;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785403863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n1rMM6UcEp7lUcJboLj/tsE78CgiiG/wYd46p4oCM0=;
	b=HX78QdYpBx78IqkNKRaXwLEhAohwCChET+W6xnyY+kxXMRE+15+0GAvFHEDd40pt2qUJSK
	OSryAttkp5PXYbqtfjFspa3q982evOmgdoD/I9W7I3NM86gJy6qPy3WCFGfM21tSFIBX07
	SVmt8SCLuEdemy47Dx3F03AQm5SDJZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8978F43D58
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DB71F0155A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785403862;
	bh=/n1rMM6UcEp7lUcJboLj/tsE78CgiiG/wYd46p4oCM0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=V3Pv2QV2+O6/iq11SVVAxHHV2/WzjKKS58T/8G6RQdUWFolvP0ss4G9J0/PmQP0R7
	 N9pS1B5KUn+6Jx43+ayvn2tFJrLkdZuu+CM0D8JblvuPXSGba43eH6F3kf6CbzspU/
	 M7mZwX+S2QmqOGl67aV6pDKQbyBzeTthEkS9sgBzdWOS8HHRX4smQAjfcMSa2zw97g
	 KiTzolRTkmBHnl04IvGzDDmq9gN8+3caGeXiHJZ3evAzc5tDs9BIrC0ms2UNoM2bme
	 /+yclclCpeCudaYk5CFcRs0On8jT74Qw0vowYeYQHkhxMrCz7xAb/gjHRNGD5Y6Kb2
	 lTy9GJTr4ROEQ==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c149c5722so4576581cf.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:31:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoWXfRkNOzW2KtPL/AhiH9/qvrDnjK7PcJpy0rj9rB0QRrV4ozSKJ2riJ/JhBBrPgD0OJyUWDiCjw==@kvack.org
X-Gm-Message-State: AOJu0YxO5a7Qo+H7N5fP8traNqaHXG7igpPaA853E7wfWOozGgGvZ6Yl
	uFzMRJWNTOCSMQZKAzPg7S/IBHyCoaUnvM2YrqytV+LYDFeicVT06iK+38wXNPd59ooMLe4XAYk
	LBzc8d4KoGTvdIiOHiozPQ6ZLS3qfVp0=
X-Received: by 2002:ac8:7f92:0:b0:51c:86b:3487 with SMTP id
 d75a77b69052e-52b3a786c86mr11916551cf.33.1785403861647; Thu, 30 Jul 2026
 02:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com> <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
In-Reply-To: <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Jul 2026 17:30:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com>
X-Gm-Features: AUfX_mwq7H0AxlP3E-5oDWbYVsZ0q6R9dFk7_C7xkp5tSzno4OBCXR2nO3NBKaw
Message-ID: <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 637AF100002
X-Stat-Signature: c1k46qf1f89nq5pccrof9cd6gaymcnhg
X-Rspam-User: 
X-HE-Tag: 1785403863-936446
X-HE-Meta: U2FsdGVkX1/MSNRevjvTp/epqviKKcIRGviqgVGkobiVzx5Fg/n8GEi4dhDrfVFV48gZF0VkuyVhBEhcpbNO9KQDffXrIWvKpvDQ+CIug7MAin3N6D21P4rZ+a/ljgbMVfBnk/KP33/J7gzeKcE4EIpSO5XS40Oxigghk+3jcSMc5CH2hQ7jIkdBs+t5VYlHCMxIORORpqE+xSy9bX7ZHRJKxWUlAcMqqyVkpehc3h2+TClYWBS+Kk7K8PE13I7byhNOa1eMfEVfLGEK2vyL+IDv0R6Gqed2Knc/MdzRM55S1+cp7Lwx2m1FGP336vYBh2I+QY2AvhYoruSdjrN0le5zad7UJiz0eN/p+jFSwfhA1+Gg916O6s7lzcWUQhtCrSUWP4LdVTrHmbSV1QS7vI0ycYH3HNzR+If5UcTL8e/4PlsLJM4WMKecnotLVih8cJs9YJ9XkFOnVF2NrQqXBFrJ2qoVCN+dum9/kSH7K/utlE/3O0zrsGv3062/liEGNOATbdC1Dnxv9pGypVzr9iIQtN7R3Kx2v490fTGmQVXfllQmWMx0kL/r1w7xFLDrzPXvtQnhAM5vN2Y/6zvYSgCDwjkO4QdxrzG6AIbYlxPg18wdGtoIuQhse5u0HID5lAN3rqPcBgLJV0kHBk3yZ29KMiR1pNS+az6h0ZhFClbIaIq3oGJifsYNmGcfaRCAa30qixDr0vfqEJJvkkrxdUG5r+s+hcr6vsm7KZ5umNv1zeOiduQwFqLGRzWIesg28BUwrG6nyhOG94nltmeaFNv7SW2RVg81pnhRgB7LFgZ4zJoaEqILyic6QePshEOjaDDM4inUSQqcqWB6QKwrM5dc47DuO9Gzr89fg3gwUiVM/M6GAhVxml+wvfnhGRM4xIXCnnGHy4Slzr88gBPvybYhXpXNMie4/CvxDGwykH06LezM3bQf/TS1Da8+VmofF3tepnORGTpaoVkmppQ
 NT1uHK48
 F5CKy5hBk1KQAjv5k7nrAgSOsuT3LQzK5aDP7oBRI5tj2EhALuGc3dsvJZjS8WBA38TTJUoHTwcMaOuMoj6VpnUtmBq62Y5dy5aV6TTFNnawtSjmNBI8mIQHix2lVyJR8ZpfJHqcXKqDkY5EGCxsMCa3N3ovcUeWnx7tCKD995DUHNSgUGz6qURidkcU5LfBTv/dLQzSWd+TAlnQ1svbA+W1XiaLqKoPtY9DKehsJjKS5iBGGN+ag5LTk+oYXXo2aEsUVzM7aImVCNhZEFeyTvE5HGVjS7xwpQ/FNj5V12yapndmigF6DL8cc0GG56cj5Pt3z3KBBqzjJQDZVZgKxP2R9XORPBdrKP1n8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:20=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
[...]
> >
> > This is very weird. This seems like using a sledgehammer to kill a fly =
:-)
> >
> > Do you mean that isolate_folio() fails, the folio is put back
> > into the oldest generation, and the next time it is scanned, it
> > still fails to be isolated? As a result, scan_folios() makes
> > no progress at all?
> > And is it because the oldest generation contains only this
> > folio, leaving no other folios for scan_folios() to scan?
> >
> > Why can't you simply promote the folio?
> > Do you know why isolate_folio() keeps failing? I suspect it's
> > because folio_try_get(folio) fails repeatedly?
> Yes. As described in commit message, the orphan folio is an abnormal
> one as it is on page cache but has folio->refcount=3D0 which makes it
> isolated and putback to lru forever and finally be the only one in
> min_seq. IMO, MGLRU should keep make progress with bringing this
> orphan folio together with.
> >

Why is a folio with folio->refcount =3D=3D 0 still in the page
cache? Can this be fixed at the source instead?

