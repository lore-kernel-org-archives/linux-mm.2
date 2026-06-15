Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83121CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E10E6B0005; Mon, 15 Jun 2026 05:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7914E6B008A; Mon, 15 Jun 2026 05:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEE36B008C; Mon, 15 Jun 2026 05:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8CC6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:14:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E534640982
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:14:18 +0000 (UTC)
X-FDA: 84881585796.09.A81A9F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5DAD240002
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:14:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="azP4Du+/";
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781514856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUJeAFXXt09c94jeT887u1t44BQncrNmZQ1/OxLwVUA=;
	b=QaIIrunZHrmo8M48FQ2X45mN40ayBfibTEAHUDsnWtjmMX0U5wGu0Mr7+h/wEGT3PrW7Tm
	JPMLO470fMG/61TrFsj/56SwtK9eXXwtr6CX1Hi05FxAA0evoDH+He5qj6ibJeKulmB4MQ
	KTa7Na3IcTFslnlk26SJAeuRQhX2ZuA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="azP4Du+/";
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781514856;
	b=FqD+rNL/KC7lptQFgNDpdC+KqF2KakZlQ2dHDtcSXBS9HgFs23MqmPoL4VrcXmO9fpyhwL
	+CnT5pQAhWSlA6L/Va7XmmmvXI9HsrkCJ1ZWC8FhenXlFAl1XjOAWi+gjETzGMsh1LWNAF
	8jW7ChlM8wh14qgzmVGX8SFZEj9wlF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B32D44535
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713A31F00ADF
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781514855;
	bh=uUJeAFXXt09c94jeT887u1t44BQncrNmZQ1/OxLwVUA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=azP4Du+/WiFT2KFEJjOrb5bzQ7OtlZDZoUD3/x/vY1dO97ql6KH1AGH5GnUfgnLYf
	 UzC8zmGIJguNr2TysIs/I5wsGBxtVoY6YtwPCrmanZPmNEckaBzL5S6ebR5xXGifs/
	 7Du7ddXDj1jqRtsEOW99zvWz/qC9gxhj2+8nHvCX2wx7fPiVQDe3ZQki19GfzuMvy/
	 DbRCHas1IeMPV7SOBjp/jOxhXBxwzKObbA1so6xSlyBZRGvdBIiud5+kxoZZEIS7WR
	 eKUtRy6tLlsw66ok534YGQNNARna6sZRB/RnjMhtmMB0m94GlERUsyJJpsbcWQyk7c
	 yIvCenSjn5/5w==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-915aa0a9293so400868085a.1
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:14:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9LeDvWMCtId3WQFtpwSo/Yk0QwYZey5plBtbogMmRU7LMAdcVkNyD5m4EPHoOIKtqZOL7e0BTjCQ==@kvack.org
X-Gm-Message-State: AOJu0YyhsomhXxlqyEnAb9vzUyGRTb6IaSIzTvY5RpjlD66psrKkU1d1
	0o+U7+w4pahvjqSJ+ERYwWDGpadWVSvUK0GgSZ5wFKhw+iDbuBtxSxr5HV7dE2VpsjuARa4croX
	wPV/PuirmBSERjJmwgFoN3l80o8dZeHY=
X-Received: by 2002:a05:620a:171f:b0:915:e8fc:1396 with SMTP id
 af79cd13be357-9161c03e623mr1645007385a.13.1781514854834; Mon, 15 Jun 2026
 02:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
In-Reply-To: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 15 Jun 2026 17:14:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yqy3ZnXirSZD0X_1b5qDnyoMLuuSS4mHRcip+CPpvQdg@mail.gmail.com>
X-Gm-Features: AVVi8Cddn7j6HKvYvm1_sm083n__hkLYQ5ZvaULuaYEU5HZ_XQXMl2mMQbb7DQs
Message-ID: <CAGsJ_4yqy3ZnXirSZD0X_1b5qDnyoMLuuSS4mHRcip+CPpvQdg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Youngjun Park <youngjun.park@lge.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DAD240002
X-Stat-Signature: 1jpyh7nw43n9c1m6311f3r3h9s63usga
X-Rspam-User: 
X-HE-Tag: 1781514856-265553
X-HE-Meta: U2FsdGVkX1+EDCw4g3CCiB/1k6M7JkKs1jthm5YaM/4JbAzCcBI+WP1czodYTAR2K6kCeNQZ7sOUf12WH0tyYqAMHGaidCEBRdGmCW9y7yxk7d+0fP+C63DHNvbcMPdyvLHR06x5q8iAe0kj0BSw1NfsgyIWlh4/Gou7QyzH/JdOzpLKy+VsoNLtaKeIqi/ySIJCtjttwSuvKcChnyoe2AMUeboJne8/W9pm3s1JgU+3uS/jZarpRc3z+9pDrLTi9MsIBA2Id3onFN1FHSEsvOUZNlkeDY0yc31EnHZplZXDKotztWUA95amKIQZUTrb+nLiLBMOj+9XvPkOEw0D/DEzhgexLqme6VNLnadK9D6hrNkLs3RUCQJBswsKreeplXy39jwBxc/3ja9R14RucXh5m/LnVHndhmFHXAry/rA8wgeQzIFYuzq+VCJipx8zbmkZfk/JK1/wdPET9L5vfBhI7p6cWjWdtzXF+vdsma1r5w2C7A+ZNyeLWyWZaCBL1BSZZnR/jQYJ5IBVx4eLt2R7HNKQ8NjXwppr1YMs9XRqluor9a5Cy2IZDR2CGLsXDCTLx9hn5T8dhZ3/xASB+/HprFSzIiXC+iGlTz1++hZaosWx2ocPndTs3mFO3pZdfmbjIFJb2JYsG6wNUIkOf1ZzMX9L20rnLgeKNGjcAu7o4KSb5u6RzPz8roHKA/2CrQ1xX/3Bf9Q7VHImTjGCWK6/gddo8PvNqbjc+140EA2F0k9dWu4ZMAWjuKjL6O2HmZgqvAVGH5CflthOt4Q8gnJ+Yl8fQTKYhCf1kxcZMaOUCy9LaUuEcSyjL4Of2zAzcqV3unrcjX+psfRD3vHv4smrH8gBfqE/OM4O9bYcz3HAHXj057r5ofLPC5lUjAjF/FB3W2vD+c/fmyO98x+5gMrt4ZlbrrGFs42os8oQv0Bm4ledqmjsem9WLlh+MnVCCuY3IWQdf6J7U3V0BBr
 t7frF2at
 i50jaEh1chLmZd73vxoHvKS9Rci235OO6WQCi0upt6AzTssFXU7WkFoKFHkQ8A66S4q6hWYbYWy1A3Jdd3MA2ebHQGvVMvDB6JpNUru3uGhuhDdlBvZyxwY4GGKNZ/bnkqk0xMx4sf55fQv9RI4hn0ZChDHiNXi7xF2Sx9GJW+WRwCZzT1tOmMYyqdALpVOQn9vco89d09eKX6bdJ7P1AMrPqBlGd0dJdH70hljprztQpUieMIJirc+OejKObOikJykJrwfOj9N3vVwHVhBzgDQrW3L5ewp6ZP3Z9n5eZLghEpaVOcPanTgOuDsiBChGMuCstktr1vkShH2l9XTRjHjsolNWC5sPmyqa1J7ktircXko10oaJBQWF4bE+Ny8sOygWi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 11:35=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com=
> wrote:
>
> This series builds on Christoph Hellwig's swap batching rework that
> moves block swap onto struct swap_iocb and per-backend struct
> swap_ops handlers [1].  Christoph's patches unify batching for
> ordinary block devices and swap files.  zram still needs a custom
> path because swap slots map to compressed pages, not disk sectors.
>
> The first patch adds swap_register_block_ops() so a block driver can
> install custom submit_read/submit_write handlers when swapon targets
> its block device.  The default swap_bdev_ops path is unchanged for
> devices that do not register.
>
> The second patch registers zram_swap_ops at module init.  On write,
> the swap core still batches folios into a swap_iocb.  zram maps each
> folio to a slot index and stores it through zram_write_page() instead
> of building one bio per page.  Read handling keeps slot_lock and
> mark_slot_accessed() in one critical section.  Writeback-enabled zram
> falls back to swap_bdev_submit_read() for ZRAM_WB slots.
>
> The third patch moves slot_free_notify into swap_ops next to the
> other zram swap callbacks, and documents the locking contract for
> that hook.
>
> Applied on top of Christoph Hellwig's "better block swap batching and
> a different take on swap_ops" series [1].

Nice. I think it's better to mark it as RFC at this stage.

By the way, besides the architectural refinements, have
you also observed any noticeable performance improvements?

>
> [1] https://lore.kernel.org/linux-mm/?q=3Dbetter+block+swap+batching

Best Regards
Barry

