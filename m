Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B84DC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 23:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523446B00B9; Fri,  7 Aug 2026 19:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3266B00BB; Fri,  7 Aug 2026 19:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5836B00BC; Fri,  7 Aug 2026 19:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F367F6B00B9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:26:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50CC7160203
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:26:49 +0000 (UTC)
X-FDA: 85076060538.23.A2B7074
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C799A000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:26:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPCm+Yt4;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786145207;
	b=gHgLQUyYGg4da6rbay8Doirj9IQHCONqHDU/g7XyhGU88qhY6d77BHUe2xP8D6Mz+KgRPG
	JEJuR9MtB6Gi6/GMDNKvrKC4M9YTt1Op8ZhfPWPW7YSbyEuuI8eJZgiTvlidwR06/LzZYz
	Io3bTx6RAEPSXkXasDFkOYyZaEWmt0s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPCm+Yt4;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786145207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4cxxvp0f8cy854qggvftBeZLtacFW5iIDEQ/J+cwkI=;
	b=Flw8E1nFU2jhJYDEA5nzE2od8lhsb1voZn9TgOXGhunAZQX9cxquJWZhSwAFXr5tAbgWe5
	9EXE4GOz4nxJmLmemsX9KFNmQxnZXrfVM5xLAYYcctWfLPe8dz2sIE9oakm14wKzz2Pasz
	TtchLOvKFaCgrPYWkhmhd9QCYloMazE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D81644003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC401F00ADF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786145206;
	bh=i4cxxvp0f8cy854qggvftBeZLtacFW5iIDEQ/J+cwkI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hPCm+Yt4Vch5BSbQ0ClvEdx2L8AV+Rh6Da8o+gwueR9dldOfuvXngqs4keglQl8OR
	 u7RWoO72wuF7YIYPC6ffVgLfc5FDc3BKaPuUv52oQPKS4ZaJVYVfrI5vjN5jSlD6EL
	 DZi7V34+9toqGMXqvaG7PXsAnRacOOw3ZE9sD0g2n+7qrDQylkaMM3E9ct/OIm50ao
	 aRyTscTK/89ZPH5ZT63xlalYGAD8aOIYK1zRS42B6hx+XqCMw1cCApzjL8uZ+pVPnk
	 P22RkGoBQOJaucsY1oXieEexYBjvdngnk0KR5PdlZgBf+5zkKbtPz6MuEyHJNL82v3
	 9P3Ru7YX73FJw==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e7632b193so5453385a.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 16:26:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqOAlZFEapv18g+BYQfxJSOBjqDVhdeUT9zPa9K4Tbuvc4rn2e8s/pLYSC6ywJeks2YTw85v0Kf5Q==@kvack.org
X-Gm-Message-State: AOJu0YwjcBSGsSdJWidnNyCscA9RInSSRt9NYzgniK/Ozc/XhGluikK9
	ypWBYJbz4+Cg7cb30effx63lwfefWL7jXquxJaBixbg9xeeYnB9NFRiFngJnuCz5OEGLxzkuDUt
	Kfg4+fvF9mJ5Ze3ykmMBPNfjDQ+YW5bw=
X-Received: by 2002:a05:620a:372c:b0:92f:199:b035 with SMTP id
 af79cd13be357-9367973f161mr458105485a.3.1786145205525; Fri, 07 Aug 2026
 16:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com> <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
In-Reply-To: <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:26:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zAWOQXzGv-4SAmCsWqDtpJNuZ=SMcX2e7Xp0QEU2DFBg@mail.gmail.com>
X-Gm-Features: AUfX_mwMd3f5s4Yz6hb8nRTt6VgnEA6ch5mYz8OPOzoAMZHEcwXwwG8U9wt5VXs
Message-ID: <CAGsJ_4zAWOQXzGv-4SAmCsWqDtpJNuZ=SMcX2e7Xp0QEU2DFBg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C799A000B
X-Stat-Signature: 7emhj5h85k3cphgppd9ww5zkuq39epwp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786145207-614586
X-HE-Meta: U2FsdGVkX1+cogBvwdDmQMS3dsc1K3Vp1Ce1GsUviD9TL/gpsnvtQ/l8OMv+b4NROXgDQAJFQXCAqkTbTEmB3Ln6T3X8UR/kyn3bnQNH056MGUIIU+Xc2S6Qlk77mlSRJfJ3Z3GPokXP9pR6qWohVY6AlcWlOdO9zohFip5s3Z8jYXgVJs6FJoZnNkplLn6qbrKi5GFgtXDK1bCft6RvQIB/utiCy4WCu7nVsttfxa4aT4d0+EWHqY4rvTNiLqpBm5x8EwdC80PkkRujkXP2VdDo9WyaKSUDqy7A0AvLyOSOz2qAA4zp+AsqyepXsBRHLc/n+27CL7UPmztW/Mv1XpibX7PFkt65VIxB6QcD/j+rzlD3XTCB6y62CkZNQLldjqywTw1Qsn9jq2i7H8v3CETWkOv9vGANncRcFnTlWT744KonRyxexXmF9Bmf89/6PS0MoIYI48Np2T44PtFhgAmUMsOsd1Xmo9s+YeuwFW2u51Uk1J+udEwzpBfiL/4DBqHSRw3g+axT9SxgRlEgA2w7Gj4G+mOpIHH8HnTn0Z/whcE5W94FZfNdDcjuS4M7yhWmEq/J9useBab4N1Kw8tNC7fJr1gyiYhpWI6jWjZZNSMmlV5HP6ip9OXysujYrIGuxwyQ20pl+fXWUMdg1sBoMyS2UKwpOYi4ILVKJ0m69ZQXzLohv8z677iYvISNOEKRfwdHoe7lLr7QwNgbxewYdIONDOP+1PdkF6k0mqe/wrZgl0k5hAhsA32lxe2nS+IgQzuORHcVi0LCkSw/IMs2DcdnXx/fgvy/plEIPq6211yGeC/G4BFtjqPJwcZDjqG0VKhgsZQRWyewh2tp4PUuTfxoidI9LXFucRUBZ4uoPyFhvnMhPUPsmdTn7FDgRE0MdIHzVJLLV6hh0TCUZR8aITzgcJ5RM+bh7lWPQF7r/fFBwe5pF2lsCoUZF13q7cj/6SLbrnXNIrOxhqSR
 k0jprGaU
 b+8n61tddNLTnl4tpB70ZNfP/t2oTAYw2RyxYwFeYwBBp62MQHSHD0LdJGlGy5Xy3c5GsLgWztt99x6kaKz6/G9JJAYk1q03LCPdZMTOze0gZYMT/GG25P+khjkjAV4SD6rx2sshUnWlM8Y1Ko/EXfSzf4Z8zV/OG+vD0kZjMaZjslCrzVse9VQLJ5JhbBIBaCZOmX1d6PlYveYROykMXMMNMX2DJGt5Lqa1Mxh5Gi1fYaFmRwDGjqu+1AGajCKMV5Nlr44pZfeoF9/zVaMeCfgu8krQxdQXYR1QjkdTl7VIwl+fmkrJdt4hK2Bygg5MO7RewDtrJ6vipYz0f30RYxa3c+MnfmQ+zk483UGYLnm5iM+NIlSz8qJQCpSKrpuOJ5BTtBnRXkpGvRQQwNCB2ppYvQlkrpmxegYCqGxxy4XhtWAhaqcFXH40pxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 8:24=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
>
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

