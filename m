Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2EB7C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25686B00A7; Wed,  5 Aug 2026 22:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6636B00AA; Wed,  5 Aug 2026 22:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7F66B00AC; Wed,  5 Aug 2026 22:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 696656B00A7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:19:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 546A41C11AF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:19:40 +0000 (UTC)
X-FDA: 85069238520.02.19187D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CC78180003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:19:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mDU9LnYK;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785982778;
	b=iinfY0WdUgUOg0R/qpJ5b+KV5dqDwD74LA1nu8osH+QIuTVIQrG9XFWj7PhOrNl8cle/Ew
	j97BUJpkN0QRWrZOynA85UkXioPgM2xnAPKtL0wJUTSGUEILUb5IlDoWhb0rlxVmZ3a4sJ
	TG6VSX4d17utLXXpCVXRlgE5Vs/FDCE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mDU9LnYK;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785982778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mf8WUk05ECYKOMEQQl5fXq4UB+Z0x/Osc+VNAkIZ/vg=;
	b=vVXnSgYY+CLWRqsGoO2vNJnVJO6ZtOoDzkEPEaii+hwJRBP/jQc6GIvbxd/0HF1uJzGMk9
	08PXawfGEyMu1JCbYY8F7pabCclt5YDHvmQd1WJrropNmzXW+xw5Cj+7Y6NANtSMTineJk
	gDL7xhfe7zJasi/ll0KE7ibBhM4EaWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBDE642ABC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B11F00A3A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785982776;
	bh=Mf8WUk05ECYKOMEQQl5fXq4UB+Z0x/Osc+VNAkIZ/vg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mDU9LnYK/1Mnan3BgqR0WMBYeD3fW6Mkmhl/C5pG3oe0rRX/RIoJopszXSaHTPR4S
	 uU47KGkP8fpLjthKSME8VqpbxibXIZzVhoB3P4izCqaSDEngBltS1jn6h++30Iatre
	 rOg7115U3EOinnGYrGpx7oMUJAjU/VRu8wVv78TypmryZ7qfMgRPMuUaNVvfCfK1CD
	 ddYORoZzpAHct1LFcB8qv7aGhXZRyfGxq9mP8kT4J6mGflMXIqm5DOAfLNJiqnqT1Z
	 0FTg+Ul5qMVUgZAH+Ipl3A+nnnkVUJNKkODA3qy4sEE5YeIQflZlZpYbxi65GvtpR2
	 /+TFaElz7NJKA==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e7632b193so118531485a.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 19:19:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoSr5ZXOpNtpWQ5q2AZTj0KTSNRtarWSbid4xxOQG7k3szpWX9To2joYkvdtD8VS0OOtyvsK/X5Bw==@kvack.org
X-Gm-Message-State: AOJu0YzKVzD2IWnWXTBMs5NUHi6npBgIu3uyX3gPtD4D3q4Zigvu1Pxr
	z4g945wAuOG7XMxofBRbQdSrm7r1owH8WHYetMQZt2uYBADulEC4DOIT63IByMbcJrT/mPvR7B8
	buarTlY5f+LwjAzXUaZTSgVrZQ/jPzP0=
X-Received: by 2002:a05:620a:a381:b0:921:83c6:f948 with SMTP id
 af79cd13be357-936490a11a5mr967059985a.6.1785982776074; Wed, 05 Aug 2026
 19:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260805141146.127776-1-youngjun.park@lge.com> <20260805141146.127776-2-youngjun.park@lge.com>
In-Reply-To: <20260805141146.127776-2-youngjun.park@lge.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 6 Aug 2026 10:19:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zO4S0xOOHQ=PP=OnrPbHPqnk0CLotdmcgnGuCZxa31rQ@mail.gmail.com>
X-Gm-Features: AUfX_myyYGYQcFm1ZAyZ0T3hQVcZ5WZ_RBesIImN1He0KOQgYPrwqcFmtW8lCZY
Message-ID: <CAGsJ_4zO4S0xOOHQ=PP=OnrPbHPqnk0CLotdmcgnGuCZxa31rQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/swap: fix stale comment on swap_info_struct::cluster_info
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6CC78180003
X-Stat-Signature: y8ta3cgjks71he8xo98w5fnhs8dozan1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785982778-482478
X-HE-Meta: U2FsdGVkX1/8CoEb1jr93WdOqMsEL/J32+D6wqaQuh0+EZ81sZakwANvsbmefZpvqEt44JygGXkDa9TV1WwILUjW06mDahCTD55MYBEC8Nn858ZhPEcqh4rRzY5piY2lT9DNjAJN4Y3KonGaAUldk6rnkXlQGGNayw13Nb/PpTMHw25q+Vvl5QGtcxmm3bBDSzmnNJW4vAHtuUdc/3ibNJsIWXv/Rr7gNptu5Klk3a6vtzBiT6vIm+XXuNnCkkAU2Iwth14rmlTxtgSmyJP4OGzxND7foNvGHOk9MVmaodlEEJOXSZWQKS2mgshAn+Fdm9fj8W9mNmNTBJuCIGrwImPXCQSY1K6WIhYrHAObhq1+5tqHkVGzMzZ5Nqlp45opU00FeTEOWtgGBU0ejZOneRxeIuLqIDMlY+sKrhHJ0uLrG6J//ggOS5nDtEM+aayDwnHRGohXUBsBc46Fh5bCT5TGFK5oW/fgKaNld6u9zP3nR39O4wdYKQPtWZwvNzcD7Mio2QKRbGCQaMpaFCqXFvUM9KTOrh+o2w31CuhbGutZHwXCyZPUTAKm9f7I/w1VnSktjCTQ03FFo8rpIPYdWwZ24RaNLOGAJSkxy8Gm0IBKt+hOyaNGwtR+wKy/K+1XtVZUtXpmbKNMNAbkm01tPhWHycTtVxsJzPSQNrJI9ubbDQwzSHE3JnzkZywwd1xYoybOkIDmGd/+UZHihnisBBXoL3suVjEhG5uBjqb6RMEVaMzdpFyf6XmCqk9yWbb4wJs0Ui7pg8yXm1cMjAc27qWmDla6efvQ8o6ju3/0YJ5BqSQdvR+K6WvcHYZxk8m9RH4KLmRwKxwj3xD8ATuusApXHJDCDB1aZr+B+u5dwMKna5gzE2h4OPgSC5QxcrJNEKRtFjXJUu0wC+Rs3LqxVUPTxAk3Is1CdinAcG1pmOtDzgzIdw8rsYtb4XMGhuSuEzsi17ieSbQS36mAGS9
 c2D2GkZC
 v3zHRW1xZozzwgN6ov8KV6A08Ci1Omd9jWnzfFUpsg5dscRWPUMT+COReGLk/DjXJTzEBi9Fuyl/u6i72EivOVqIkBoh8NE0elfmyAU0hmFehFVshGjgYebcodwq8Z7G9ufOJ7m91A703AnyvRETVV1bb0lRoFEdBESHv9spg25KzleIvigMNNei6QXIMRMJKo0VF1ukobbH85SzTqR1cJLD8bZMWFALf3DOnm1EnUVor1zmowCp72b09LXNba9vorO1XwM1hOD7wp99kOhLFQ+4MoHB4SE3ukEWrIxzsT4+mDeE8i5v7+0HUZXh/in5NOnFrUrvL3Q6ePSF/B8v30Rnfp66Zk5Vs86Zzioou9767lTJswcCFiIMlqwb+nAEYXw0HaCQwsrVnjU7IQSd/d3eXC/bmX7ChKaokINtQS++EY44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 10:11=E2=80=AFPM Youngjun Park <her0gyugyu@gmail.com=
> wrote:
>
> setup_swap_clusters_info() allocates cluster_info for every swap area,
> not only for SSDs.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Acked-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

