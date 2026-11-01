Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC68606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 21:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UkSf1Zmn
Received: by kanga.kvack.org (Postfix)
	id 13C936B00EF; Sun,  1 Nov 2026 16:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE1F6B05B1; Sun,  1 Nov 2026 16:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003386B05B3; Sun,  1 Nov 2026 16:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5A666B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:07:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37D73140A61
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:07:20 +0000 (UTC)
X-FDA: 85387785840.30.3E91091
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4E89D100005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:07:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UkSf1Zmn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793567238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBtK4Uii2Z/syuVxoiWD5aDotjazeSSHixcnfiiNqGs=;
	b=L46b8txEAaKImycq70F/3yjlupPfZt3bTUas38KiPbuWNugnZTAxK0I7m/KhS2V4y5zejC
	c/+0yGLqZ3TGzC3kP5OS9AIDpTab9Zv5m/NZSx9QHAETXwFGQg23/XDgvA4Jn1tBxRRFUC
	A/4ylvy4cVDx/C1UNXvQ0szy5gJdVb8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UkSf1Zmn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793567238;
	b=PM2Vg0Wdi98JVQ4Mhko71J8crH4fPm2Ptdm2M+eRb/FQLVhSgAtgdXG5iM/gBQbARbXZgb
	DkNvcl4yvjFC2qe4a/VcBGiKaCfkS9A1q+3qEcJAHaAiDgv06rcGZoJcb9DBApDZpIFyQy
	Ln97v1agiCk/8+L17NFVJedgk1PUaM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C2B43E83
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6878B1F00A1F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793567237;
	bh=uBtK4Uii2Z/syuVxoiWD5aDotjazeSSHixcnfiiNqGs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UkSf1Zmnp1uyNO50H1VYvb3iB4ZDRd8wGoFOrJrwYZqw00pRSHWM8+PJc4/YovtRU
	 PsmfuCx1bT0MPZ2sQyIh66wgZYOFZK67li56HxijDNOL5r9d/V7Dl0wh2j/OlPZ0WH
	 iOFRwTb3/en71nrtIFF3rJ9fVCCGzCF85hf7NRP+Z7ywgWLGKPdt14/UUJEtGOBeha
	 eSSy1YnuX/HHWDe+G6VeKhj1JTee8ap+6y4CMEwj44pyyBvaqdWvzZZMFdz0x7Rh0c
	 b1k4tz532PgYeCUtCjILwWjHerrGaBcm/0AdUxZUuLeHmAS7c/8cDz4BpdGbP7y4tK
	 EquQO09hI/t9A==
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5366ae57896so29776781cf.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 13:07:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz0ts3QQeiVzq+n0kTXMB0v44/Lmf3RkhzppoKS4qOan7P97p2bNmZSIQyl7eEvsKYI9qyXtA+mkw==@kvack.org
X-Gm-Message-State: AFq9FYLgBoZHJnaRuJECyoVRPhf1AiMmYGTloOjc/Q8C+nBjg98bHGxw
	Z3GZA3KMbDFNHs+avDL+G4AeczyHC/qVB0yL08Wewcz0PUxiwVWlA89qSJsWvtcvCQcPVIvHXMY
	bTGY0x0UP7WepH5BQi4EPGGChPPXYzQ8=
X-Received: by 2002:a05:620a:688e:b0:93e:c12c:4412 with SMTP id
 af79cd13be357-944217f079dmr1343599285a.78.1793567236722; Sun, 01 Nov 2026
 13:07:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-2-max.kellermann@ionos.com> <7037ee68-5dcb-46ed-a73f-ed6ea58915f4@paulmck-laptop>
In-Reply-To: <7037ee68-5dcb-46ed-a73f-ed6ea58915f4@paulmck-laptop>
From: Barry Song <baohua@kernel.org>
Date: Mon, 2 Nov 2026 05:07:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4znEifrb_5vVbkVENmTdVLeGgOyfaYqptNXk15kQ6xr-Q@mail.gmail.com>
X-Gm-Features: AclHuK_GLhoQTQql-sHZc5DrMSM4g6S1w1l6RaNWA69ZyNHwnlgREaXUECvpfuY
Message-ID: <CAGsJ_4znEifrb_5vVbkVENmTdVLeGgOyfaYqptNXk15kQ6xr-Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
To: paulmck@kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4E89D100005
X-Stat-Signature: pxuy3f8u8crgpfgr69n9aeamb74az7df
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793567238-458713
X-HE-Meta: U2FsdGVkX1+x94W3LEpnSzhS/ZJxFmJZheFMqr5yhAMAM671KARjSllJqDyGmhufpM3vieJVNigvuEeWYZ81plH117g2h6A1kWUXoXnpOto2DE8DptlH34cBHVnzpbSHCWfeHhCKr7a9ihupklK/IHsGzAtxPiN8F/aHzioHeLt8YDJZHxtPYVUrjwwNyBJegZKgiB05lx1j3eZMRfmIp5BByOrlMzX1KsxIFg+/pSTmbbY7NIGqqngcv8M6GVeHugQfvm5FZmOEsE3nBMbWs4GZAhkdzzvLMFt0APFrTOu29FNurVFl7DaXQpCEDfjtbpcKgBC9arcR2ml0RtCsf8JT1GmbooSVzUoNEFyYcy8duiHBYgN1NN5oJ+KVoCMPuJNbO0wtpUzfGa2m7j7og+URSoNQIVOHj5mI9ZHu436r6ffiO9tG1i8XSUaTxzK9MZHptjObJGT/6vdCRAwBq8hbq5C4xCWa8ocK9NV2K7ga0QqMxESsoLoPT1WKQ7oTtmKISeOCbD+kFXDVYXCGFp5g33d1GO7ItGHySgphLfFuLPaySIbSl+SYah4wiANn+aRieLyph4RoyB6vDA5fdIVcVrXNRg9dwrqLQnYwNxiKWT+GTcbX+n9wk8M8r0doaoH6B2ZvobNZi5KasRUTu2/+1gpLBiWxofyXdDS9Y3LDBtlMsLGVyBqWnfGSYqJjSDKak86Bxa3MQA49i9470y+BzMvALjvSvXsg4jU+V1Y47dKH0hWTLCVXJeOkhJnaHUKv9EYxXlD0T6NObvBs4olOmY5ZhwCdSjcqYJa3CYV47tkfy8HcaZlGeNaK84RnhgPWffy95RH3G5WlOxksdxmUv1Amdg7ppLpUMGHrr7gVnHI2sozzpdlOP+1PambyqgYdeE9VlYqDT+oBDoTGk3TwOr9i8WCQAa69V2nymGBSJ/xb5zYMLd+ePfJnPmN2q/AhQTpZCGeJhtSBQJD
 GbSgCoCm
 jih1Ik3YxQkHxh5hO7D4daK8nOQaj1koBNQALJO28l2pCk3rGJ1VJ+J9EjG25otnYPj045ZHouz33I9oGvYjzecyupzOEDh61cTddMlQFQbHzmbkDysrQ1E+HIznHA7FPXhIL7GCp1zf/aPzxQ7zhFJ0TLQ67w+ratSnNPHP+d7YRczpa+lxwQ4aTc0adiwT9HijBKDDbcIuBZT97uYbOZAgHAOh3Rfkhg+gO+GDIjFklEuL17DDQSlYtqYbflnZRQM0IxozdgeaPcgcsc8cR3n0YS0MoMQ7CchWkfZeh52sgDvvnksLKROYfrfxwugq5qKYcnoOTjIsyyHE5UxAdPUxz9yAZOb5o2vpE5n0wiyDmmOcQ4GDtHB8r125++SW9Hs2W2Vp7nj512iEjWEYlFxTQr6W8CEpGUxYn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 7:58=E2=80=AFAM Paul E. McKenney <paulmck@kernel.or=
g> wrote:
>
> On Mon, Oct 12, 2026 at 10:54:43PM +0200, Max Kellermann wrote:
> > Move some code from hlist_nulls_add_tail_rcu() to the new function
> > hlist_nulls_add_behind_rcu() for callers that already know the last
> > node of an `hlist_nulls` list, to allow constant-time appends.
> >
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>
> I am assuming that this commit should take the same path as the rest
> of them.  So:

I guess it would still go through Andrew's mm tree.

>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
>

+1
Reviewed-by: Barry Song <baohua@kernel.org>

