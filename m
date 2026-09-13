Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C561EC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 23:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978FB6B0088; Sun, 13 Sep 2026 19:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951966B008C; Sun, 13 Sep 2026 19:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8683A6B0092; Sun, 13 Sep 2026 19:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5485A6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:01:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 980F2A0CC0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:01:42 +0000 (UTC)
X-FDA: 85210262844.10.8FEDDA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2A3A4000D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:01:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TM97ARPE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789340500;
	b=qdsRq72uEz4AuaAexSyxATi2VWZm3Vd6wOcqB7X7Ex/tI5U2oghqhUQeU5IYRC0QtAPMvm
	t+PydhkAOMHM2H1cWgIX9Xl9EG7PqKWuFoDdVLgbeybxFAgc0NjxznskHCSgLnM+tFvAgs
	QhJhcPhKwXBU1p/IP9A7i9asFq7hNn0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TM97ARPE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789340500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99tdpBy09GP4NZtz0Xsy9UP2oQosnHb+3YQeokfanhI=;
	b=QbIAL1L189RumIPKwUYFdukP1lAOO5W7LUtYHSZ+EQrGuyZWl1ybrzcu+5KAqh+prT3kom
	TKo324bgeI0wxdMv0rjW7qbNiZjkqy8rzJAaWyrcnqMvF4DyiCrE2o6PRDl+KPc6YIKzgm
	Y7OQXIII3i2ggrNhTZSmRMFBGclCnao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3AFF44A98
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF3B1F00893
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789340499;
	bh=99tdpBy09GP4NZtz0Xsy9UP2oQosnHb+3YQeokfanhI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TM97ARPEPGldOphV61MxaXcJ8Cmz/SeyVMCYqoV2PChipT5EBrAMjpjZuBOcinf4e
	 0yybwGl+Pu9DUtJc5TXlM3ozcaaxByFCXVL4vFpuoRzOGQ6vXt0u+hOmKZYiw2tJzD
	 hQTdan6C0WjJAmpb7uwtuMKvi139ucEos+tilPP5xoOTeGp408O+0bWA6Ygo7pGlf0
	 zymUg47rRdsbv/WQ6h7+izkMVdc5HwXP8/FDFV40TP/+w6ePD5i0YzkU8gPLiwm6I1
	 0im2QAvG3pdG2nWsULgYunv5eOIcRGndeLjeC+3n5JZQvdXpJKQ8iiI9bIFAlj9ZWI
	 FBSZChhNqi9TQ==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109f067fso191757785a.2
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:01:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzOVDrKtFtWWTv1U7Vb887c7Q6Op46YtA538a4zZZce9Hhg4oqcbXT4nexO+i5IcMva/YGUi1zx6Q==@kvack.org
X-Gm-Message-State: AFuF++nMOzAp8+jOHwwokUPZPRlhGUCaVi1aAGs/ya3s1uSUjLT6Dt/I
	KFovlS4jXSfqMLI3YqEhQZdt/uwoYAagZAe92EsX7H22ioHNBwwiRxtQuLDkRHgvUT9fsxs7Alv
	6fALXvLg/LtS7BQg/VfQptDwBzmwe4To=
X-Received: by 2002:a05:620a:8703:20b0:93a:2a59:3377 with SMTP id
 af79cd13be357-93a2a596b4amr5388585a.41.1789340498890; Sun, 13 Sep 2026
 16:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260911121341.178028-1-alex@ghiti.fr> <20260911121341.178028-3-alex@ghiti.fr>
In-Reply-To: <20260911121341.178028-3-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Mon, 14 Sep 2026 07:01:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z3bSfMTKvkXsKAz=+dzhmdGOerSfL33t2RkN0CXZV-hw@mail.gmail.com>
X-Gm-Features: AcwNN1VeUdFTleVj-F2oE0UDk9S9NWy5SYyYKI8DUBOkx_28Wvoxe5F4EMw-zho
Message-ID: <CAGsJ_4z3bSfMTKvkXsKAz=+dzhmdGOerSfL33t2RkN0CXZV-hw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Tal Zussman <tz2294@columbia.edu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2A3A4000D
X-Stat-Signature: jqjiecdto856jcqcis4dxmzimz71oai7
X-HE-Tag: 1789340500-843654
X-HE-Meta: U2FsdGVkX18HTJmazBxSnexS5MncGycUceyddkHKF/kucYmmO5auxbFhVUN7/xpV7RprnM8qcaC6pGLcVj262CEGv+Aft9TTlXQSMcxBQrzD6KGCWVo4TtV4prDR1S1uercsBnCte1yZQM/mXd/EhljThDQrhj8YpQMzlph4RSZHnuTKsKm4tbfH3iwKc84SdbR/otidb7KVoZPwX3tEG6IE+MNs5b8Y/L4qmc8R4KHoFIHKEOjaDnlCRGACCJNN1mq5Ic8hmLufE4zg5cHUVnkLcIXzxlf//BR8mq99rZRfxfzZMckBA9xN5WoPaQnnK+WNaSzgHk5XY6U/1pleNF7xCG+chhLE5dFCxDhKRr0ZnJ6mUJ97Rbz+I2xJLRqr1IgDwBAw+R1SEnTikPXZd7zdYKK1nU+p1ce7UbiuIOorFJcOUpgIxlKxP2vFENY+q7OpNfJTOcxOAKXWFyblsQuEuYB2NVQpTuc6C8PZdRJXIHNPTjydJtOZ9WgfLE/e5sWh+9Ztf8+aajtVx5ZKjbbw49T3pv1/8iS9VQ+im0w0EWGJNumf46yHBK3ByaHf1pXrUZrSVWuTKtC7CQkTKklsxloOYXPUgJ/B2VqwKcK6VEFBIVbXAUuYbumC1K4AQeWQLAas7VuW92LuhoMgWi4DoKEG/l1a2m35AUK4o9kwNNx9r1nEJ43VLS+E0G1WKJpKFlcDaperkJKpy/RHiEesMi33Lh/pL+dVY/Yg/8moP/X0K7La8vRDr8GQ9lGudi3Z+krhKbWiGIs+1yszhq5BUyZokNepn/j+4RniY++eLhkD0jmfOI7ffB9Y5+O+lWnbeIVI0xSnSFu9dUUbj4T4uAhhb86bPKORB090GyyJyp2hpdBWhysm8n/dRCsMXNpOr7zYw+oUL3ESWsBrgBTs1KYn+LgWFwedJRaheZjmpMXPHjZ5e23TwzYcYDpEvBW5TPzjNp11sze7pOz
 ueMDmOND
 Hijv8/7C4xIetTR0BqzFslH6alnZ2Yl1YPmh4QZymeKCMNiw5iacTf6miZgcrjxm1mamtEJV1mUZ4lx3t80bl5LZ0xeOUyYnAE5kvZ5SNeU+JAiwG2OQn/AUBsAeGdJk9T5g/b3F1fwYmk8QZv1+QaHsFqcGbqLIOYV8dXsUjtkizCFZxRZxNyKuO5InluoKT4fjHnzhXGsWHDOr0raWHhJWKNBN/3AsNsT0r+DEsLmsSP04DdgCoBTnRcBRitDf7rORbRmrQJeCEumOJEvzlN4G0B/w7/R0+Rn8vG3aetrTaFGXUDCydJ+OL52kIDp0TWUhAnSrbGbAtmnm2WGsHWDOB0tJb15Zqxyej9pUJinxwqregxCLckeoE+4lxtRPcw56dxC1Rcna3z9mLMoyfM+XNlCZzelQMPsxvgLBeVRY8FRmAyr6O6er3IFiNI/Mh6BrnF3eeW8fuZT5ED/nZGI8v1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 8:16=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> A PG_dropbehind folio is dropped from its cache once writeback completes
> rather than left for reclaim to find later; this is implemented for file
> folios in folio_end_dropbehind(). Extend it to swap cache folios.
>
> The drop takes the folio and swap cluster locks and may sleep, so it
> cannot run in interrupt context. Set BIO_COMPLETE_IN_TASK on the write,
> as the file dropbehind paths do, and drop the folio directly from
> folio_end_writeback().
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
[...]

> diff --git a/mm/page_io.c b/mm/page_io.c
> index 88962571cb93..52eae99de6e3 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -602,6 +602,15 @@ static void swap_bdev_submit_write(struct swap_io_ct=
x *ctx)
>                 submit_bio_wait(bio);
>                 end_swap_bio_write(bio);
>         } else {
> +               int p;
> +
> +               for (p =3D 0; p < sio->nr_bvecs; p++) {
> +                       if (folio_test_dropbehind(bvec_folio(&sio->bvecs[=
p]))) {
> +                               bio_set_flag(bio, BIO_COMPLETE_IN_TASK);

Thanks very much, Alexandre. I find the code is really much,
much better, but I=E2=80=99m still struggling to understand why we need a
sleepable context after Wenjian=E2=80=99s commit:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=3D84=
8d2ce2fce15fbdc083fbf9691bfa72911033c4

With this question:

https://lore.kernel.org/linux-mm/CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-c=
HaDWLkxaQ@mail.gmail.com/T/#u

In short, it still feels a little strange to me that we need a
sleepable context, especially now that we no longer call
`folio_unmap_invalidate()` for unmapped folios.

Best Regards
Barry

