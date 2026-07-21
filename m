Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E880DC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84A26B007B; Tue, 21 Jul 2026 03:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34FC6B008A; Tue, 21 Jul 2026 03:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4EF36B008C; Tue, 21 Jul 2026 03:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9245D6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:33:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 209CC16043F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:33:14 +0000 (UTC)
X-FDA: 85011967908.17.B74A5BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4126540007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:33:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ozbd6Xb6;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784619192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=El552dXTcofIOup2nIc9hNVX0WZuey7Z/69LFMdE3N8=;
	b=BPBryywmIuOxGeGvXapmYxHQWLTtkJtpGVmmFbDh93skD3iG4gbr3Mm2FU2MolA3AAlltn
	SpHnQIw/juDGPg/TlkUywnMAJyYChfPsX/4RqEMiH2Qlwd6S9z68MerxT3IqYBlq9GaDff
	C89MnCceBXHPpzMJ97eCI86hoZ0gzWw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ozbd6Xb6;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784619192;
	b=pvj5yDd+Sh7aqxVMBKV2hKZUezxZEHDqKTgJUJJh0GbDAEs3XsNcNOjn0StSxxC77/ABRu
	Y0hGZZdeAT69uVKNNhHOs5oAWuKqSo+pVE9bJnGU4pGqHG6r+F4mbvG28RLe4JxSZ5SfnW
	FDG+e2etHP3YS5CZizPofh3x40WH6lo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36D9544034
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B01F00ACF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784619191;
	bh=El552dXTcofIOup2nIc9hNVX0WZuey7Z/69LFMdE3N8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ozbd6Xb6w23XT3xcP23FYGz7SKWV3F2eNYehEqA8dxcv7dr22cmYmk68jqPcNE3GK
	 ieHPdfQpjVWX6DsDq/ooUrp7RvDSs7u3fk3TORmaMjTWj4GwuGtizNNimdHfY6Gzil
	 dpqjpgVSpAn4GYvFNgLBdKGNfAZsfLdgYQOqYg6rvmg3y9BFnICzXGQjbBgn3ORAor
	 OElcHo7uS6xNHBJ4T/VW8yUGdLeuclh6uIg9S1NsWAqU3uxBE10347cHkoulLSJ0pk
	 bI6g6C6sirTyDDe0vW4DFSvxjJwDOiCgOS3Ce1RNmESmf3+3J6NYNiVtdm4khgjfy1
	 aCzuE0XJIs+XA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e50c5d14cso790432885a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:33:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpXMonAZd2LU4JkCHKQ/euhBnaNXFi+uvpGFrNI+OPmuOYS9RZdTcPoC78U0itBJDcG57KF2Tx/rg==@kvack.org
X-Gm-Message-State: AOJu0Yxfy1ciWsS8+x5e+TNiA0HcVS6OqTWG1MqCSJVK+Co6mscC2oYq
	BgMKRdPN51PLx6s4DRsUeRK9FDBd9ig8EITw2/rA8myFGXzCoP2auuSG+1ARgFhib0/yn0ekb8E
	2Yh4B2x2tZXrff+Ibp+gE8H2r+odZdOU=
X-Received: by 2002:a05:620a:7110:b0:92e:c93a:65e2 with SMTP id
 af79cd13be357-930b3f3477dmr1614918285a.39.1784619190274; Tue, 21 Jul 2026
 00:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260718095251.82937-1-ridong.chen@linux.dev> <20260718095251.82937-3-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 15:32:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wMd53M4m4OFwpQ_qiDnStXsQOK62yYm0VC+QLX_AxSmg@mail.gmail.com>
X-Gm-Features: AUfX_myhg_mB09SwZMBCRQMKzZt7LZ0UqHXYISbxuvke1PPJGdNm574D63g-f2k
Message-ID: <CAGsJ_4wMd53M4m4OFwpQ_qiDnStXsQOK62yYm0VC+QLX_AxSmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: vmscan: propagate real error code from
 per-node proactive reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev, 
	dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4126540007
X-Rspamd-Server: rspam01
X-Stat-Signature: ypnto9qidknim68ea8qjy979qcbjhoam
X-HE-Tag: 1784619192-157016
X-HE-Meta: U2FsdGVkX19rFO46Vkm6pUc516UbP09nuqBj6T8Nvxo5JtHjRXPNz2+lBwZ7ylbfPYl5in5gzYNIHZYjV0wZuQl8G8DE9qnRwQz2SiITqT4a/prpLRvyLK+OhlU7dgfbAssO88sx0AbbWNAQNsnt6V8A6gc29zvvHgfEOWQmAgJ30qbzzQxJt5A5pr9NN1qjfwXex3wybQgPLsQP81PvuYW4cbF5zFVbgp+EkHcVuZeGvpQG+DszhwCwBKJ2WP8+MuEIpKrWlP8Blcy9cbZFSFh+R/7kdriVK2zWaw4zzl/nXcrunYhATnnjzGHygNyrdaEauSYSiJmXYKicTqpz2S6VNqui5/u2gh16dvAB6P7cnldV8ggbemM67vFiAQBQ1bSmAdww4jIZQdampC9owkVeV45sLmIIuPt5vsDp6FtADU7aaCGpB7IVHDOw9njZrBiqH20mX9a0AlyWkTI12/H27nMl8lv5JFBSnTqyKirUP0DHw2B5hC3heWG5VwgomAJQjSfn9lfCfWBmvucABKqrEGa3/dvJAhZT+Zyi0KWGuz38RmvxkwE+JAH6Pwu5LjmPtzHJ9UUzZprqi2s2kwznwRd2wl4JAmOXiRAzU2a5a+TNj1TIkW7hGOQLc7ry2YLFwd1k2o8OPiwsa11HqJ8MsTY2b5ctqyRxKBv9HIkD/a9TMLPDSJcvDAQSAZSIf0u2XsmPP7Faq1p7tBmB8aIW7139C9kRV2clONRr5GPz1Fxt1epPM981J6HJ8QytyppSuYMsBopCVv0JyV1g0NkDl3WcDsKxE2Ht8gGmtb9dX8MtjG/o5EM+ZHGd1FudD83hiLeWBIpXhsuMggR6YCuoskhUPAz8Q2z8Vrj36MPuJdpZAy9TUOB5eDvOI9X6gTR05uD/XcLaAsr0cZebADzMoFWnsWForY42LVbqTVTIbjMr7Hqlf/sOBbflv3ZEOLJ2r95EYxeY1P9yO5z
 zieGbZl+
 1HpGYlVa7+VlIQY54ZmhIf2W22pJYjefyPWvh/65c0vIkbVIAe5yTGzN1NkCbIwWw/trnUbFWTV/o8m8Xed+sxm/I2KUaFkKbxAuIOo4WqC3TvbxX6pjIjs8I4Q8fgwL3Or5ChKwLgo8ECulBqjanbXO57oBqKS9jYPDXk1xKWjKpubtGzKrKsWxZfBLMkgqkyJZNhQTS5Nk82+n/LuB+Tgi+bmar1DViARiXkz0TeO6uUuy/JW9MU81qoR8CxutlaVHDO0eP4IxbKlOApkiRqO7kFfNe1bjvTktO5bGrFixg/XtnOOX+7rgjVl3ObuNS/X+nfOBlwfkSFkyS0XT0dmalRwVD5348+ek1vQJucSsWZLyFCNiOXo+25UIDBkk2aLN+sJbwsd9+WPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 5:54=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> It has been observed that per-node proactive reclaim always returns
> -EAGAIN when any error occurs. As discussed in the mailing list [1],
> the interface should distinguish between cases where no reclaimable
> memory is left and where another entity is concurrently using the
> same interface. Propagate the real error code, consistent with how
> memcg proactive reclaim handles errors.
>
> [1] https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/=
T/#m3514718be82a31b05726a49da9b61fbfc69a589e
>
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface"=
)
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

