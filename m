Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B21A5CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19DD56B008A; Fri,  1 May 2026 13:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EEF6B008C; Fri,  1 May 2026 13:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03FE86B0092; Fri,  1 May 2026 13:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E50CE6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:59:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA1B01401D0
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:59:28 +0000 (UTC)
X-FDA: 84719613216.21.228CC5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D55681A0016
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:59:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JbTv8Nf1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777658366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+/e7dJt2MU31Z+SqBYGMwjuUbd0OotWBmXxOfFOWyI=;
	b=F8WeJQf1QtZYcIS3dJySYF1hT+zAMl6FdhAT/1jnoVB7xixsz/smTDgyfQskRMnCt0TIfK
	Bo87r4fRKQgWf8obJVnY1NX5pQj7PH7nOIbJ3WBsXBk70H9ocr6CUPw1b7P/+WHpPM+nq0
	uEp11dixObMlYWqhzljIEmarSOBHvoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777658366; a=rsa-sha256;
	cv=none;
	b=4knAGH7o7wiYphGbcDqYm5CGIUhoh0UQiLIo3E/vvcTTDQiIURx1e47GQuEXVKal5fnJ3d
	n8J25O/RS/Sz7j+wIv3a1GEeVHhblpJbEag/77OHRS/Kuqo5QP7K0DxFg2DzTVZrT3PHNZ
	yXTLlPYD03tcFPio+8QUSgHZMwYTHFQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JbTv8Nf1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A6C860126
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DCEC2BCC4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777658365;
	bh=q/vvVmaTofrvdifxLcOjX8owb4zQpccO2C7Xr55syLA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JbTv8Nf1y3JWuLvIXZgUs1p4s5+B1GUlld0WRZbXF6rHJnF7FXG1rC3Vd4wOH+FWf
	 /lu8+oad1AE755FSug1ZcbNt0IQc1USHsGef5ccGfcxzq95KtuLoC1nLMlrSQKzgi+
	 tTiQMMhrfbld8ymAgyQwEiY7I8BtqZz3pZGkD9sFmJ46nTjfdLk01RnECNuTHbUx0N
	 /o9MUrK9GRGCK4V7AJo9DxsUNN94FU6bSe/lBLB3HEZbgoDtdPCtJ4BLITTZoIcrFs
	 HYAyPtyGq9f56cLDbdFj9zzu20514g+BkK1RgtuqirVOywKHAzhsojpDQjUdjBms4R
	 0K/BQ+D5iTcCQ==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8acb856a674so27617916d6.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:59:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8FnRfWEI95RMZLo2okwxI+zGZHwaLhr709EfN5z4u+Hu9EhPa0I1iQdmj9czoUyQFmZB5TKeyHYw==@kvack.org
X-Gm-Message-State: AOJu0Yzu+FyUia7s57g46SJa9YXeDwcTH8UTtC/VHST/X6GJoRijJhFu
	XzBM0+ETPyTX+hFhG5xduBNZr+j3+AiEkTJ1JtndBpOdIaLcc6P2yNWjMtQda02UMB0rbmOwpOb
	FLTuXBy2vq8egikkqQ4aE7KkmStzEm50=
X-Received: by 2002:a05:6214:3113:b0:89c:7bf8:c564 with SMTP id
 6a1803df08f44-8b4000bc68amr106932516d6.27.1777658364833; Fri, 01 May 2026
 10:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <afTKsSj0i-ZkRZN5@lucifer>
In-Reply-To: <afTKsSj0i-ZkRZN5@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Sat, 2 May 2026 01:59:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w4jyQTzvPSzGtv1r5G35kARHrf4WgDvEiOAw8k5AAABg@mail.gmail.com>
X-Gm-Features: AVHnY4IozGRsOfIFCBuTWYpA9lpafQxUB9l3oBl_1mgfquoOdt6gfYLqIWFbDj8
Message-ID: <CAGsJ_4w4jyQTzvPSzGtv1r5G35kARHrf4WgDvEiOAw8k5AAABg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D55681A0016
X-Stat-Signature: m1dzm46i91oeo5frwfetykp49iny9jxa
X-Rspam-User: 
X-HE-Tag: 1777658366-14375
X-HE-Meta: U2FsdGVkX1/LQWL8r3Ujzr1QjuH5a9LR2wxqX3Cc3twsr44o2cHvPqKFlWJEDVrKpa4byES9po3Xs4QdwD6J/8+vyflxZ+vVlcS/lxOdcZcWRzhqa+eIcz3+qtKY/qR5QTqxdfR0XilxpGRosos1O6ApQ7HBQRw4oWtAu1cFZhKpXig56aeNm+NepEcjTozSHsawXzXxwGCJ3T6adK06j1UGdwt7675xOwmVgtg6dWbrrDig60WgfaBWt/Nb16zOTpzEqH8bmTJnNAXd7ZMSrGjkFkTK5+izIcEdKgWs3ak4Mt3CYCS4ZqZ+r4vVsQSpm7aRmE6WitCAKFdbvwLTMQ/PjQJFw8A2fY0/F1A2RldPGsCRI8kMykYLCCCMyax9qcLF7s3TmmfaxV/8PPOoKiJH7KalAzvDPPEf+JevrkRfdXkoLAMQTCdoCOw4tRQEwacfiYqb6TVBMwxrKNgQAFHwAg95VOZMR6qHYI9zO3QOSqNFEWzRtUZrMVwHoE9IKLcBztsCJGB7k7AJ3bpml+OEL1QpSJwIizYK8tkJr4oqcoRdMdHs1ZbxRC4xaZD4d2t05hNy0iXot3M7fhpDqDU95rLKkbSMHVhoE1a96PKvr/7vxExlnWg4qKFHZdEN28xqD3ZAtMyXY4+yJHLxkorGD9DTviMkue3hb6zSmwcEFUGzZCauUpJZRthfrIGaIUFHWkaMeozt4W0GNz3CdoJ18vS24iUC5nfrGHoqVe7waplZPd7sAJavFpGhFqUrw0SUVcH6CKycRokI9jBlZ9xkIwQvuG9kKIkJJ8bcCkuvRpn0vU3fW5k6Gnxc1I/vVflayVzgMnKNjGuG/Z4csC/NLRqfanko3YWa2SkApOjrek/J9Tg9DExSKd0+XsjfOswu/e1Xdragr+8nkzkpydpeX4kg/Q9QBrCP2JQGowQjGbqMhq2U3U5n+dYT6jYhJ1plCk+j+j4E1cKz5f9
 CSaD+Xvj
 /WmJq+6jXpjysQdCSSoIDJaPqBhqs373byErB8efjQNkTkvcRcXJRk86t3Xv9/K8TgRtyNlOMRBRBAxT5zu+TTvKl9Rq0j2riSOjzbNeQMBfNmoDB+Y7acdqyjNAZqBebSanJA0sga+PyJhSf7Z+3rm39IH6k6jQfaVI+xfiJMj9tNZVWqKLd0SLCVY7OqQzGI68GmexUod78KghIN6JZkb/C+p/XW8oSea2aoeBand9wcGZQGYxcVHhIeOMnxefRCkej8WVC0Dq7/IpwYx4aLlvhWDthO7xU+C1/zs75PVqe9+3I+gJq9x9BICNNTvQj/cECAiClxwp1z/bkPdjP7u6/iBTX6L2qpuG0/oX+ap84wfVF/KsRRM4hXctTpV4csN4N+D7TB+dxBYz/X9ZdM01KuZVx59zBFA9P3lKr1XM+qZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 11:52=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Thu, Apr 30, 2026 at 01:37:14PM +0100, Matthew Wilcox wrote:
> > On Thu, Apr 30, 2026 at 12:04:22PM +0800, Barry Song (Xiaomi) wrote:
> > > (1) If we need to wait for I/O completion, we still drop the per-VMA =
lock, as
> > > current page fault handling already does. Holding it for too long may=
 introduce
> > > various priority inversion issues on mobile devices. After I/O comple=
tes, we
> > > retry the page fault with the per-VMA lock, rather than falling back =
to
> > > mmap_lock.
> >
> > You're going to have to do better than that.  You know I hate the
> > additional complexity you're adding.  You need to explain why my idea o=
f
> > ripping out all the complexity now that we have per-VMA locks doesn't
> > work.
>
> After a brief eyeball I share Matthew's assessment, I really don't like t=
his
> series, it's piling on complexity for what seem like niche cases.

I=E2=80=99d really appreciate it if you could point out the specific parts =
you
dislike, rather than the whole series=E2=80=94I don=E2=80=99t think that=E2=
=80=99s a fair
assessment.

I=E2=80=99m not sure what you mean by =E2=80=9Cniche cases.=E2=80=9D Do you=
 mean avoiding taking
mmap_lock for major page faults, or releasing the per-VMA lock and retrying
the page fault?

Right now, major page faults always fall back to mmap_lock, which is a
significant source of lock contention. I assume we agree that this fallback
should be eliminated. Or is there still no agreement on this point either?

Where we may differ is whether to hold the per-VMA lock and
avoid retrying the page fault, or to rely on retrying the
fault while using the per-VMA lock (with the current
mainline approach using mmap_lock instead) ?

>
> We already have enough weirdness in fault code honestly.
>
> Let's maybe discuss at LSF if you're attending?

Sure :-)

>
> I will try to have a more thorough look through when I get a chance.

Thank you, much appreciated.

Best Regards
Barry

