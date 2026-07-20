Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5A6C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBAE6B007B; Mon, 20 Jul 2026 14:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475756B008A; Mon, 20 Jul 2026 14:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FA16B008C; Mon, 20 Jul 2026 14:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2066B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:25:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 847D91A026D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:25:57 +0000 (UTC)
X-FDA: 85009983954.10.3F10120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A63A100005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:25:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKk6xpOZ;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784571955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOnFljFhV2dUFdU/uIhu9/nha+9HOsRpmQhNwC+zfoI=;
	b=T6RJsp0WYeMRw91erK+Oo8MMhx4c3qLN8EFZWh/wfrOJqrflRllatdt4eCaHCxiSw+NVKD
	LAytXEoSh9yg6qEruh18RUxDl/KQ/Pw9yrjl/5j/pwbLh6+sTKSFQp4IhNq/ph7ORUpvsM
	lqVIf1aDEwrbwCPPnRW4k/trznehWiY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKk6xpOZ;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784571955;
	b=gYnUEKXu+Nsr7QplkvwAkKQKssxlFK8Tn3kP89tETcrnbd1ILx/ChldH0FSX8E8kavFf9Q
	rpPdD72Cn8EFEpExqq0c2x1cpCBdSb/DX7W3CTWqt7ioJFU84IiDlCUmxvJxC2Dd090lhq
	lVSWs6yrXyTxVX/3+TvvrDM7NTPppnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9DF043E9B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13611F00A3E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784571954;
	bh=LOnFljFhV2dUFdU/uIhu9/nha+9HOsRpmQhNwC+zfoI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JKk6xpOZBt44TFJXkCqPCizf/0tLncTcgvjOLcLA9iuIicp7tl0p26CR7H/RQE1YI
	 N+Lx9m7x1YkxEmOuaw7GICmSNTqcp8nlQ3H/dfiVEHQ9YLnvzXyvVUynA19akdVXou
	 2nAAxaqoJeDYjJNrBOGBhP9qEwX8oLJ8ury3ztS+gdX2WZ/zCE29ZYTSPJoPkGGKuk
	 J3QEXdZX1eMTp4lmHWSEQOzFycu7MHorDsZoIxygf2KSLr3+GuloR0f8CTQNYjBKcL
	 U6AwpzY5F9agCHrakSf3KsJVkQVWvz4C0203l0NJp5erBCdPWsiFcR8DlW5TtA3Cqx
	 DXrzFrJ/T2bcA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-698a9f11776so11740829a12.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:25:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpGd0Rax9KCQcX0/ytywK5LlEwYiu6KDeCvr+ZK5tQLbyuEoYMNN9IXrRU8qrqvKaPHaMSDF+PJlg==@kvack.org
X-Gm-Message-State: AOJu0Yw1vVf0iG4tTN6g77Rek0QCe5URYyU180K3lVxJuvron0t1cJTw
	+ArRHpKroUiKxCHUpI3yDOf1cSrSVMiOb+By3G1E8G/munClJ/l16QuXm7cPPtu8jXer9VXCkxR
	tQBOxmDlDPXQnJyRYdB2CT4f5VcHiJRg=
X-Received: by 2002:a17:906:eec8:b0:c16:2e4f:a372 with SMTP id
 a640c23a62f3a-c16b46cb3damr736150566b.13.1784571953371; Mon, 20 Jul 2026
 11:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr>
In-Reply-To: <20260718093723.153324-1-alex@ghiti.fr>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 20 Jul 2026 11:25:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM9SQR97cAJ2wLuJKjgi4oYatPP=3B6j=-hUhNFiGHDFA@mail.gmail.com>
X-Gm-Features: AUfX_mzJlYTx2MaKF_YFbmqzhrvy6YfFAfp6DJB-04xyhOmv1DJgR7SEquMo2tU
Message-ID: <CAO9r8zM9SQR97cAJ2wLuJKjgi4oYatPP=3B6j=-hUhNFiGHDFA@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm: zswap: free cold writeback folios promptly
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A63A100005
X-Rspam-User: 
X-Stat-Signature: 57dszuzhf8hrfy4wz4iurdjfu4mhamih
X-Rspamd-Server: rspam04
X-HE-Tag: 1784571955-333963
X-HE-Meta: U2FsdGVkX18BCbHIuEEdijdioPg4pW7guHE2ECO5mXl4BkhTlpKYW8Y06mix/dL+XLnpGsdvgAzAF2A43DFUvWPfsyv4nThRocKX8neIBu0DsS0pOzJ6LfKuhIxwoi2XvnJIi/vw0CrioNLd3s/8v/HYVT8zZGIsQIH4bDZQxbQpU/WfolWMRqscEND/0XI4t4VilXVVkY4xjS8UCDxNqFfVWd7BKfLtIGgmE/bedk+xZbpFS3+wgKJeBr/5Z2/WNgd8kpBPDJpQJbohq/lItPECwm2u4WOiTr9GQgN/bzJ+2Q/WgwzDyPgw+UnqETmeC9QwnbzrtBXWLuzoSUKaxHi8DSSUKqATQbEjPi1nJqrKDhuLnrTbfvGIORLnc3igOTcugtVj81xJL2o07cSfjWwZVCUDM8aEm5aB7uatWDaj4xWy/0BfF3ZMyr+x4wp1tM4aS4wqSmk0F9QHZB++5j3HqOrJmlfVefAMAWtrz1bdT0nVlrKsPc31I8yDjigavUWKYkQC9SkSrNm243/oETp3GNsLRTnKX9i8x2HQ3vuvz5QluGNyGzNurrNegx8z1D12MxB8Qr0l8nfp5QhE6ZJKjcu5C5qWCZUq4JMfp8rrsrJJ9Tej60UFXNmnOtOSWdHKdcEdeI83BrFVZirouo+Hb/57VjbaRDqFrIjpo5EMDycSRcfgrvEvL7Hvg2GFHRR1b8L7hx/1ZGUj96yZwXef4BupE3wPuO5QqOnjRUto3zajnvB8zmu6i+c5jabgi+ZmVXiRpNrZvE137y8SHHrrtAJVEACa+qDS49AbMzP2oIsaaK8GPe8asTOKOsOKeN/KNIvDDGUDSXw9eOroLkHr2MPeXt61hOXLJSDv9ZsE82aEbDLmgsAlFqDRuRrX7N4D7ICI0pFhU7t03CA+JV8HxTLLdNwwhwuEiomMAZCWAbjcUTWuqtIVHvDrWS7eOm+DUriQgLXUZu3IQR5
 mVwqi3lN
 UK9EwYYRu6/UnSbGAeOhHfY8tbM3BgRS+doi3h48xqFnPbh+eQic7qmaMw/hyHadofYFdvVvQmK0UjUa/+lPwSeN4peXMoWTaxRi8q1daPwABrg77EeKvtGS/ACtlDH0+bNAjDvbkVRPyYeGboW6HHnpIMKq+M+cQnLVbxsKUlyxZuj69zscLvXB4l8dogdnda9rIPYtRoL2xzfunG07QWS+Bj/KzLOfni1IU0JJk1UJ/L7zW57GGr8g5zbNLomtekzelDBXmOCxeE4X0M4p0wlWwVEK7lGnryTrr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 2:37=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> When zswap writes an entry back, it allocates an order-0 swap cache folio=
,
> decompresses into it, and issues the write. The folio is cold by
> construction, yet today it is left on the LRU for page reclaim to find an=
d
> free later. That wastes a reclaim scan and keeps cold memory resident
> longer than necessary.
>
> Free the folio as soon as writeback completes instead:
>
>   Patch 1 - synchronous-IO devices (zram, brd, pmem, ...) complete writeb=
ack
>             in the calling context, so the folio is freed directly there.
>
>   Patch 2 - asynchronous block devices and filesystem-backed swap complet=
e
>             writeback in IRQ/softirq context, where the folio cannot be
>             freed (that needs the folio and swap cluster locks and may
>             sleep). Allocate the folio off the LRU and defer the free to =
a
>             workqueue, which folio_end_writeback() hands it off to.

I took a quick look through the patches and the implementation seems
too zswap-specific.

I am not super familiar with how the drop-behind mechanism works in
general, but it seems like it's currently intended for file pages and
not swap-backed pages. From a high-level perspective, it seems like we
should add support for swap dropbehind in general first (regardless of
zswap), e.g. by making folio_end_dropbehind() properly handle them,
and then have zswap opt into this?

I guess one of the challenges is that folio_end_dropbehind() only
frees folios in task context while we need to support interrupt
context, but this also doesn't seem like something that should be
handled in zswap.

In theory, there may be a use case for doing dropbehind for swap in
general, right?

