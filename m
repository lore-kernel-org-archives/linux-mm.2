Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C04F45A12
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 04:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA416B0089; Sat, 11 Apr 2026 00:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17ACC6B008A; Sat, 11 Apr 2026 00:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090C56B0092; Sat, 11 Apr 2026 00:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB19F6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:28:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B3B2B94FC
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:28:03 +0000 (UTC)
X-FDA: 84644992446.15.F99B592
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 550F41A0005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:28:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YE6ctGjk;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775881681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqAmLsVFwoO5aaDcC6VlHof++kpfICsT5n0C6N43ypk=;
	b=ijlrxuyLLPHb1BimVFh4Z65+wf5pOtLlv4ScdlkbR6bGE0qz3AsZIDNCrETmppM5Zk/bJs
	u2OlxOjmZ/Uh4gIQXjMsyXYyQNSA/clUucx7cDIcU5/fVDDoEIVO4+/GKb8WAyImKpgWo4
	jSLlchEORDfYJqcDh8rWPg0Wz+yO/0Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YE6ctGjk;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775881681; a=rsa-sha256;
	cv=none;
	b=HbxE9y9ggDPjoxdmJwVx3a1vdQRsxD3iMWQiZ3A+dA2OmPtwhkhoxWcldXvDR4pmmUIFyC
	SZ7lEmFjwmqetdqzKs/Ht3k1BpPzytbxASfHkcUnPBb/s2/pCUsAYy1ESlPK+G+2b+SbuA
	KTXOUelcfBlsODb7KQXXWcjoNFOtYdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1ED74457F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC259C2BCFA
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775881679;
	bh=GqAmLsVFwoO5aaDcC6VlHof++kpfICsT5n0C6N43ypk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YE6ctGjk60A16nqMj4ZQTpZCv3rxMI9gcWW2ZFS+SI23HDp4cwUIee8O4ssFAd56C
	 dkXGJAu7OtbjCzjeO3a72WySCr2mQ8jK1n7tm0iXUHHs4rRYocFe1cYJV9y1+z8LEK
	 I+fBAFxLC5ooKmLgns6NYhi/bElLIkMv/SmwSt3R13VJoH/0ED367vK8Wi2O7C/Hh2
	 WJd7CLAY6xd3N/UKvYQDoYWCuOxZ08ZEQeJmMFBSksxlZR/GlyUm4LV9RjmM7DWWNS
	 butYXIzFo9kgsU9eLgotKptkn5Mx6OE0D0PVY3vVoTkqjNeDwhhpwVZKIVru6sfZyR
	 423NRwzmXnaHA==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89f68634786so29644576d6.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:27:59 -0700 (PDT)
X-Gm-Message-State: AOJu0YyRMspBbEU/UX+p+v/wkckfu7Yo/ejDykl99VydMeFZW6/i+uCg
	KoWbbjhq8tfPIZrWLS6RgNuxpWR2fCeIgsvl8nupYRe412ZO74pf+mAf/O4CU62ii0FnAG5ntq4
	JFlw5xBG2ojCQumbeb3CLuBlxoTBZk+w=
X-Received: by 2002:a05:6214:8094:b0:89c:c3ac:e5b5 with SMTP id
 6a1803df08f44-8ac86117d50mr83071306d6.23.1775881678974; Fri, 10 Apr 2026
 21:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com> <20260407-mglru-reclaim-v4-6-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-6-98cf3dc69519@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 12:27:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xnqJdL+D8-nWtr5xadNO=fJWaJirvnTcq+8dpeXqWbSQ@mail.gmail.com>
X-Gm-Features: AQROBzCbyUMQ_wk1cLbKsMRH_Ouly_Mk_U9woSOGUbEbbH4l4y_r6rO_ttqDBQc
Message-ID: <CAGsJ_4xnqJdL+D8-nWtr5xadNO=fJWaJirvnTcq+8dpeXqWbSQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/14] mm/mglru: use a smaller batch for reclaim
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 550F41A0005
X-Stat-Signature: km6z1a4qiuxszojyh1a1rm4nktpg71hy
X-Rspam-User: 
X-HE-Tag: 1775881681-856338
X-HE-Meta: U2FsdGVkX19cNm/3IwuEhqwdn6CpZ3g2PQzjHAc9/vpd7Tv7zBKtBFqfMTqVYJuCPyHS+yxBs/n1qc6U/pcMbVAhnTosSQbwgcHk4FQRC/ka5L79vwG64r1cTPsIHvy/gKZOEUl19zyQqglw8M/7T2GWcDnPHCr86TSeBGgxc9dCQe+coJRTY/wGrTryMG/fcmh7Agvzodl1TCAfIWJwqmNDf5ekYDv+ynz0dpk40W6hAhRY+ut8o3ejgTRb4+IPOwa92Ld48lcM5o38S4ooTFvlA5ZKLVrvAdOYs0ulIqw9OMGt2RlO3oZKaEu6ipOuDprCWSjqU08Yt/XfMi2sqhjeFfoJKBmWww7HSwpaU6lW6o+a79aJPVJgFCP3ytBh2zRoPE7l+GSiZTuX2+X5L45jPBQR1LSAMYKHKhkVsSs2leEANnKdauS8MgOo7L5BDevCGdxXfk8vq982yPfeSpfD6ZxqUR3D69pq5BsCy7e10S5BuZsOUWQVbQeTrfCsnVNRtc5alt/7DavktvrEZ7LW5X38cLGeoSBq+YAcZNHzdgaMriH5LZ75HTc7oM0BxzS7f6yRA6WgG3VD4TSfzkM4GLzIjigtIVKT8JZxbBtjfFPsVHNtQSg/ZAeaaf+wrf3s1fftRpqML1wOTIdH9afw5hLhMzrpymfMkN96C9TyrLeQRc3jESbm8RhvWu8CYlgwFmgOCh19OJTPNu/vpT5dgLv2fEPPM563kUcUTd0tCADc0Io8/pBHJwSG2Dh4gEUSHqjqvurpS8QyFyHQD2vboGAVP/+sCf9Ls2M+lLbdgtugd+ovENc1LP9G1OQZU55Lsb5iPnLvkt8fWFC96NlYbVbw+Fg7dPxDtCB8BWwZ1N9b7nKtvVp8IlBLRdwmyxtDl7pW5jmpj8m/9cJEpzvRe2el4X7+KQGDQyAbU0d7xLCBiKKgRAXWiuberWLfy7HTvFwXtjlhgmIEPsr
 j7eoNkzf
 VLGRI6DJzuJwQLAHKYJobvkDCtulZR4fMACxsX+tDelo5KQs/yzSbXeLvfoAAdL3hFItPia7jdh+A6kBfUkWpOGIY54V8KBTcQeZi3tz+9rVUIMVmC+4vQzcqwOeQJy2AkFEJD8wWg21NS0Rs2tWc8ZpY0/RjNtR3ddi/UDp8x2p4R7jl4zMAz7v225WP7mieWMEMdr0XBYUJZlc/KJOmBmMsViol5MOmlnwWDa46Mu3y9Hz6E3m9hJ4MEmDrPz4+O7zF8o7Egc0LrpIEMLZtpH4n6OVzCbnYT1DlTy0pdesDYlkZRNtipDwFRJa65U/hgt/ylcnbl7hUD+L/PTLy+Pmw5HcG1KYRpZ4cmsX2EmNDE84KTtaPP825GUH4BekeVftj0XLtlCxy+VT8mM/6isig/iKZVXJXuYaJRzy/t4dDBWoScSQJbPBxJYYwza7GJgBj1p6vwsYXbIMGnGHuldAB75BMEjcevMfhtwUZeJX6Oo4rC/5JzHceoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 8:05=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> With a fixed number to reclaim calculated at the beginning, making each
> following step smaller should reduce the lock contention and avoid
> over-aggressive reclaim of folios, as it will abort earlier when the
> number of folios to be reclaimed is reached.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

