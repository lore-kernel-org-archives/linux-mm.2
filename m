Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B206606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgjQ7b6Z
Received: by kanga.kvack.org (Postfix)
	id 85F636B05D8; Tue, 10 Nov 2026 11:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8696B05D9; Tue, 10 Nov 2026 11:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D79B6B05DA; Tue, 10 Nov 2026 11:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5B86B05D8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:16:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4F66C0933
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:16:43 +0000 (UTC)
X-FDA: 85419712686.06.0193F33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EC0E5160007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:16:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgjQ7b6Z;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/2MuWYVBhNCrWHxBkQfWYvbU9j9ZMayABUoxRH/r90=;
	b=wFgH4yK2byO43rYKfAcabdjTCm4nJv+GyFDiFzCQKpQKWR1/T++zumVq3AkgEmoNDPfYcJ
	5DnGvB1w+kTNBC6HDd+EEKtsNozwl0IUa4w1Y8rBF5h98E5gmbyidA8jCKxf5Q2nPupWN1
	lgBptwaAWoyWqVGpaeCj8dS0Ddl5hd4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794327402;
	b=5x7mfCFpTUBpS8P5BF2TCPTzhiZyThORXzq0WwpFX24p/+IUtkixEJ4VG/uM9Q8v4NdQYv
	6bXI87EvSNAqZnyEgzRQgOREMJAVnGpQreX53LniZzjwc3lUTZZQVUVf0G6EA0sq2jxhg7
	73lLdqtiEawqL+amzS0NL9psLATxeJg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgjQ7b6Z;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C3BC447B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41FF1F008A3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794327401;
	bh=t/2MuWYVBhNCrWHxBkQfWYvbU9j9ZMayABUoxRH/r90=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GgjQ7b6Z84JEROSbvsW1NEndXwpDWmRJ5mdiK0eU50fDHy4S2q/4x1fnZM9peLwEn
	 ZmB7VeDTwD7CNnPWJkKtIX6OPYrwC/4nwt4t0B5K/Gyapwig1ADFvptXyr8zatX4kR
	 xk7Qz/a4olH9pCPm6U+Ws3I4BDq3fyyoDwTUwKLQny70Mpy316Co5KZZ3wvKrJ3wTi
	 akioaTVIzkGHEOo0dJcUu7a4EvYFXqk0VX1JszXvYsLZnReYIz88ULmV5AOnuHcj23
	 xh2qcM6D+FuL63WiuCnwJ8Lo/IvIP/nHiexKLWz4uZsaPpHIgfJBJzp13LGoWWrosU
	 hhnMljyw0UiwA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-943e8d35f74so188631885a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:16:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEGL93xAcdkYcH9EVMpZLdop1f+H6jCMcMzxpifGzFmoFyA1HPArY/bdQ/unIInda8GyGAz9cdQMA==@kvack.org
X-Gm-Message-State: APuU4Z/S6ghFSMyPL3xSfSb0p9t0yA33vJyWs6zrQh1qARsAUg6QYSXg
	uo3oOrszW4r2WC5vBD+M3Nh5IX3ORJcQksb2O86NJhWEPbc3Kjx2OIBpxYiYHUF+FX7gICVy7qI
	V+7V11k0NKNiw/mVQN3esPBW15P1VQJ4=
X-Received: by 2002:a05:620a:414c:b0:93f:353c:6bee with SMTP id
 af79cd13be357-9479f2e6ba0mr519311385a.41.1794327400308; Tue, 10 Nov 2026
 08:16:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 10 Nov 2026 08:16:25 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMW4T+0-UFtPUi5EDdvP1b53=0Tpasx7kc5ZkdbqHW0Og@mail.gmail.com>
X-Gm-Features: AclHuK-dt6QyaQbEWS9LvYKZc0TVuyB5CsV5lfGXmiKwVChcOCfSsn2FOyFBdvY
Message-ID: <CAO9r8zMW4T+0-UFtPUi5EDdvP1b53=0Tpasx7kc5ZkdbqHW0Og@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] zsmalloc: redesign object alloc API
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC0E5160007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: tksrop5xm8effeoi43zac71jao4kdupw
X-Rspam-User: 
X-HE-Tag: 1794327401-897867
X-HE-Meta: U2FsdGVkX19cW5qEfaRUQ7ZQi3/LiSh33489NOfOjvO4IKYEhd3jXPFn1Ot37j9z2THvT+/vyyKU+MnAunneZ0F0zjWLrSazVyt/MaPHk9EKfNJUupkcm2xlZB/88dJlJ2ydzNPzLcYLfgNTlvdm3VzgP2zgec0uM5b1KrX1AYb+eXc8SdUHHJplTG1R7++JY+YktXq+umEp5Ql4EULzVacg2+8SFvlcYKoCyu5J+NV8Wx42EATFpl++xVZpJeuZ64lTKke30UjeK1H3fr1DeJv3Dh++8nt+AFLt0BrqUxWpIppL+o9s3rwagXJTvcmEA1UBZoIrDzr9R7+WT6QpV2EMlbQOvg8tBWPv0KaALZ/JOx9TeknHiAjIObsRUlZImMu3SvZroyPKAnTLiY+jDC85W/AK0/v1kZPy6Y5+PTCzobEyzEQO2XVYjfAE3zotBW1yipPykQwTZatdXDmOt3CgHsYqzOv9OcuOl5aqe91sY2xwk16W6qXdZm8ZssNkKywEikVu1JZA9YxFTVkTuH/bltLtYIK77UVvaWWfcBU4p2Na/Gdzw7gtdDPhv9aXgqnYT9CrVUhBVHP0lcJDDI7A5KPP6zzh44MSkJwjtgTqlw1a4ypqRocgIzjcznMS3L2yLtpDcbQA+kDSoeWbiZVdPOAcqAVu7FGc+fUshO2A8mfRyitAkK8HWyRSLpUS/dxAJ78j8oDeQWYewrfB6nc0rNxJdTpVt+w3j1LjkQ9YTjYYWrR69tZ/FKJ0U536kFA3S7F3NM3erT5HgI7L4iCFmXKqj7Y2q/2d8IGNlnHUQPH8fDQDr8xEEumsGRthcv5nn5k+agQzSSB3PoNZe8Dxw432bAChOD87T+qLbKl6SgUiYa7ydZhMCaVEuHkVInTUN9qkM9k1j49GHuxXz+RjH2xX5Mx6M5vT3MXBmtww3uIxg3FK13v+JeqovYv9nlOhTPgyCHimOWzO/xl
 g/1ZR/kE
 nIp0qBuyqTffhiiG46k45HRVPVVInV9GhG1u/9v5n1RRUQUSRhPJIbo0MVT9o+CnVJ5IyJWC5RER1bpHnXvVfXvMZ0e7qdGwfBKXxKryLnu/4wfOaZ5ZGCrvnB4NRfUbGode1Ym06FELtfAkM4W27YnUNUMM0hX9bSO5qyeDHL//cHwyWsFAnOHwZIHW6b4BbEyDbGPPLtlhv0K5UDrHPjIznq5fpkPLOObOUeIPHl8lIPc0dYLgKN5tDqtNvalr4K9/8ItlW1auM2xPYPYqRvyiN8AtYDQW9qmrr2CTOl8e/s31McFJmEpB6fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 9:48=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Both zram and zswap already have per-entry structures that store zsmalloc
> handles, so allocating a separate handle_cachep object per stored page is
> redundant.  This series embeds struct zs_handle directly into zram and
> zswap entries and drops handle_cachep, saving 8 bytes and a slab
> alloc/free per stored object (2MB per 1GB of swapped out 4K pages).
>
> It also folds zs_malloc() and zs_obj_write() into zs_store() so we don't
> take pool->lock and look up object location again right after allocation.
>
> A simple zram test on a 24-vCPU VM
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 165 fewer kernel instructions and 0.7-1.8% fewer kernel cycles per write;
> lz4 single writer +2.3% IOPS / -2.6% average latency;
> 24 writers +0.9-+1.0% IOPS; no regressions.
> Memory: 8 bytes less per stored page.
>
> v1 -> v2:
> -- addressed Yosry's v1 feedback (too lengthy to mention here, Yosry
>    posted over a million comments, or something very close to that):
>    split-ed some patches, squashed the other ones, added handle
>    alignment run-time check, added 0 PFN defense, etc.

I will take this as a good thing :p

