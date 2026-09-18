Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7A3C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 23:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D033D6B0088; Fri, 18 Sep 2026 19:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CF56B008A; Fri, 18 Sep 2026 19:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56266B008C; Fri, 18 Sep 2026 19:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 919AD6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:29:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7F984011B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:29:06 +0000 (UTC)
X-FDA: 85228475892.25.71E33BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 24BE3180006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:29:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksA2eEmC;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789774145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=188T93z4qV5uNJh8FeTOQrPGMOwnqFGa0qLgHhQ2j6I=;
	b=JtuZEZNZxvTkYo1j+an4y7l76P6ylv7e1+0iYJ7yyZmRHm9NfcwPlxawPN1QzdXGIpHPVP
	XsXGU712Mxbq+a+MjDtYiqOExwO1TX9OeUDxbLWpsJraefwhh4Fu116t/LZ+W2tNh5Sikh
	147Gq4Bh73nl9Y3j7hyXd9Fdg+xkR5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789774145;
	b=vujeg3N6ENjrcwUyO5dEz4y4smVdAMJzoHqolkTamJL3FcOIX+42emYMY1noz4VAe3mSrj
	rtAyH/IqlU/srXNMrS5b+IimCG3jYEqBxvkjX8PbjG01HfNE65BpgzsKXbHK/aFh6VbkL+
	hFWS78d8e0g8ywXL1Q95eqOeFf/UZV4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksA2eEmC;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62C1560A62
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D0B1F008BC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789774144;
	bh=188T93z4qV5uNJh8FeTOQrPGMOwnqFGa0qLgHhQ2j6I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ksA2eEmC1Z8I9QuBoV4PpCqjawt/7RnMRB0K0iTbetkXqabi8N1I7QSNQIMQIG0+7
	 jBEP6xICM5ASv2y/jKAUrL/wJ8WcA6pbJpeAxLJHIkt6N5keCZxvRTruItp6NkfjC0
	 AoQ9Cr/TU2XApmAdHMbx94EM0Xk/7sRlyfiiuRm9i5jAcmdG61zVSN8ztauw/v0mt5
	 /YNYpngulgkqa89d6ASQMpndUyT5s7eWS7sgtnl4t7ztx5o29MgZLkETYb586dPsAW
	 zV9vvg8o35phs+eS0q+H9Ecrmv8xG1H3MAkbEWKicK8SaTf5riHdwkqPdlM99A90Gv
	 eKDJbSLd4nVlg==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910537b51a0so11319446d6.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:29:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxsurs9KcHvk6cTe3ByC+8wxc3wJcBrDfdZ9tj4Kd4TJlY7baM8KqJQNJEjy6V6lgp2/VJ6fQZi7w==@kvack.org
X-Gm-Message-State: AFuF++m6g1IzND2I9BHXc8hdH8tY3rb1LLYhuDd7b2Z5V94gfi/Y4+vo
	8zZcxWXeha5XZkMrCOe91nlN9uZ6Y7dADpbRRiKM1+8bMchrxokf5/aHovmZLkS3pzZZ1XzYE6+
	R9Xb6A5Zo7AucRXJ3q5p9WTe1vQL6NUs=
X-Received: by 2002:a05:620a:2258:10b0:93b:e578:583d with SMTP id
 af79cd13be357-93be5785985mr347910985a.21.1789774143217; Fri, 18 Sep 2026
 16:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260911121341.178028-1-alex@ghiti.fr> <20260911121341.178028-3-alex@ghiti.fr>
In-Reply-To: <20260911121341.178028-3-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Sat, 19 Sep 2026 07:28:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xPvb+t752-7cgBD+A_rnC0RsBr5xzqLH7WxfMDyUZOgQ@mail.gmail.com>
X-Gm-Features: AcwNN1V3GmEDwNyGC-51iWFm0sj4MaQx5oLhHhe_bGWgP4pIfVXISsARrLm7dQk
Message-ID: <CAGsJ_4xPvb+t752-7cgBD+A_rnC0RsBr5xzqLH7WxfMDyUZOgQ@mail.gmail.com>
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: diziusi5fcssor9est7ez1q3qhct6bqi
X-Rspamd-Queue-Id: 24BE3180006
X-HE-Tag: 1789774145-181467
X-HE-Meta: U2FsdGVkX19ktYS4oWg3W8AyHY6elxS8jzDQk1OpKzhJRK+VIxB2mjR7r3tqewcmz1ZR40wIERQZF9x2FtOZ6o4gO0OQlhTkcgxlyxUW7Y6oEflPcZ061MLw+vnN93Nr44w/Evpys4qtT0MkGKLKndCZQYlnIfYKPMfPmkBahTxqOB10Qde/8Y58ODXFps2pYNuRLTrIzsb/R2X49tA366csgFxN3Ca0Tqc7yhtuTXVz7blFXzoUP6ZEM7GpP5LDmXO3T7qROSD1USOdnaFEyjSldIaowUNrnuCT7d8x0DMPN8C22L6qK1ahGT2sucCoQmVqWSSM0Uu7zFqv0Pa/M1IdRdj74YMvzDKw6REZPQA8v22dvVjCJFqZyiHScnkJ08DL0FKgQ8r7TebvpADj44I/RSmQwTntgO+oW/7dr6+pgx0nB2RLj89tqztfdYFyh1YRIE1AEAPilYVF3Ex5UkrqHAkGTO7a+n5PJ8i1oycNms8lpDh9TYJUWsp4DBrNH/6S+ckn0Jwb8atLhBYWqsQwAacvxbfEf277TlyWzr4otaLdjbdMay8cIwxA8ZwvdpFaCRzff2MVdVcHdFnQxoEYH5tJJI8t7xZxL2322tG+oHXPAwlY3xfA/VbjaM8ReN7trVc2PgevqYv9mkZi2zcq1syasxAlpEiTh/+KdehzLv0PoCar6Q6CGqgFKUE4XdIE3YAXyngYK28uLr6eDOhfZ/jSgkUDq2nHodNXYxcXHMmmmODdU5t02+O6XgqAiKAVe7hbgniPysKosuQJaI4/8vxK2/ce+Enef2o6ag1igW/YpcefozQOyTnQCntQGO6qG4fnW9uJsFT5zTHqhT2wyujYF0ynR2H6YCgVziaBrLif+Z+csvGX1EUho/TneSoaYOOazAqqXJyj+Eh8MKFRzz7dh+NT/fDaLsN25N6nokDS/Y7rwcv5hPl2OKGieV/+fp8ICiNJg/ssPvJ
 HJMfW6Z+
 prBmq0Mzs/rxeq0jbQWC1pUv5vxIewkeDngIeve/Aly3jj97v28a1RNzXMIrpNM4lMhn10U8eXdDWrFugjE+O6DPs7Cua14hGzVn4bibtF6iHMvNDs3buW+wC2fFL49yp6HXE3sVkzx/FwfdLYCp1OLfkftOZPlEw9tCSjIbQ3f0iUBcpvPT5Ut/tHMKQ1g2UsOeChgBe/jop8y9laJGYfbhfglxAl54WxxxxJuRVFvO2dJKKRduEacfPAK3QfJG3WOH6nlJW5pkc5gD9jd4qmWE6Hllx5In9Okv5FazoEvc3iqZBkx+4fouETspTijPKXmc0gbrIYpaXhRImkmiX0zMaY3vgVtZU1iIrXLg2wr5J+RrMKNzt2NZg00/NwOlDY+n/lz99s/eX8oXm32k7EKYY1ZlyMlLGQOu3tDP9uxAVHeCl7pbw32mP3vdEnxXXxuMmBHE3i+NTrbcD/1hejrjUjQ==
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

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

