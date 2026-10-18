Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C547FCCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 21:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF236B0096; Sun, 18 Oct 2026 17:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5FA6B00AB; Sun, 18 Oct 2026 17:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519086B00AC; Sun, 18 Oct 2026 17:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCD96B0096
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:24:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89FD6C057E
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:24:57 +0000 (UTC)
X-FDA: 85337027034.29.F060CEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C144C0002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:24:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g41ecgsv;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792358695;
	b=isWPlVJfxQPc0uiT9Bu1BPa5uNwH/TdNYc9S9Pdquhul1wndlFkqsEBrXoEiXT3kNnpZfs
	uDjrDSQFBwbn5IS4G0l8vfVDXMXNw04nGCRFXct8EeLGqDmiOeuTUloPWRojpIrVXZ1sRJ
	gti6c3/5T9Z7sCr06N7ZviC7f5IBtwA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g41ecgsv;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792358695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79eD6+NYwrWfAWT17DyFGFcJ6J+jNYO1RY/y6TIzgMY=;
	b=wKydiQ8Xv9+pttxu/nJO6/jzkLmc2InsDIECZU6aUQ8qs3b/YiCjwapkjzjRCtOFarnvpa
	8kToLYXlHLiO5Y9oLAILz3W7kCjVoi6fgyDVjOPfjIGyYOrBk6OMnd5XcNwsdfHfsb5U2h
	foHtf94udbTmXS3CYlki3t7Xp0VeH3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86B3144506
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EFB1F000C9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792358694;
	bh=79eD6+NYwrWfAWT17DyFGFcJ6J+jNYO1RY/y6TIzgMY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g41ecgsvRnrR3Ul1sVBVPp2VWzhqqffwmuhmcbLEa/aRE2vF9ODuN8ZvYvaIGT1OM
	 DZGwcUA+FbDwxYx72wyOViIdT7Zs/1M56/O0Jf3ZJo6sJYiI+8agDxXHlpEhDef1vc
	 lcbN/tEkzDxwkqNZ7ZaoQqUlHls4wjE05T1nMMzY9zjU6EPOtTZuvqWFG5zhSjgjtP
	 rceHWM1PVosJQ3JTMcNfavbkt83l4z10xIhTbRyiclj0yZWlxJ26pCjsdT3EV+i3Mi
	 MJGW+M864p2kh/AencmcuXZMp38yM14Wpd/kY2vYTdqR6HtU3LBNsvz0Ot5cCBRK/G
	 SfFujcOWvanDQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2493c28bso132438285a.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:24:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzMSyjx5zZK9WnfAx0x9Eb3pnyD/wP2V0kzArg9xOZ9jXLRehg1kP0z6KcINvXCkTcgyo8d8QfQjg==@kvack.org
X-Gm-Message-State: AFq9FYJ8mCQiMk94J2xSLGrvzFNpe0pDu4r1IWY6wsTxsWJeiuJj6NVm
	SfOux5Da4bC2CAKN8Ssg+6CGpwuhssHKrnWVOahPkfY1XSGpisktPdBR8S5MmO5zdLVyypJwiA+
	Ep7cImBgD9KWU0Fa28HWHEtNbYh7zz10=
X-Received: by 2002:a05:620a:7116:b0:93e:c12c:9b77 with SMTP id
 af79cd13be357-93f29e10b82mr1018147285a.82.1792358693733; Sun, 18 Oct 2026
 14:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com> <20261017050928.128582-2-sidchintamaneni@gmail.com>
In-Reply-To: <20261017050928.128582-2-sidchintamaneni@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 19 Oct 2026 05:24:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
X-Gm-Features: AclHuK-zOvmn4Odh7hUiMWoOb31GxvVA2StuKKJONiQv5GYZwSx9IIrjvvI6xTI
Message-ID: <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C144C0002
X-Stat-Signature: 6s5xyor9kzk15hncm3snyj8kq7wwus37
X-HE-Tag: 1792358695-777470
X-HE-Meta: U2FsdGVkX1+MICKYKYR44B/wcLqpUYCVUAawT+MWUlCDrqSKm4RD6RLw4YdG2tIKKD8f7zrtgmPwins9fUR3ZIe1fh1MsGim1kcUP8gEhobIwyRYpuTTMw01GFcf/eMndHvXZz8IxAUhPdd0w+49hRLdjruCkjFdMEDJ6p625VGl/4TYHhWTNIUFyumFeC5cz0xwU2SXawE4l/QHZYt2NXqr8Ay7NwmchhOWY5McFRBg2U6muIHd+eAkWbhv2hUf4z53szbFmhm0Q54IflcijkSY7D9Rnn8XwxSfcZAUVSnnMunc+Yz6iUIg9xkquCTIX7F3XN45qaUpC8dIotQcJcJ+WKJt5OUbd6YOAemO3dPL06WLmxdAydZUu1RqWu+62c9hnb8q1JX41aHUGDNbnvnH6hX0O9m3/s4PZtHfgvZQVijHxB/gy+V5BVT+I5jVwnLVh/3jWSPwwFIFNunjCsDe5pxo4yv66+uHMXpg/ZX4zcHTjN6/F9nNRSzj6Dk75QLA2QYylykyIAHHealRENDlnFBAaPrB5VB/B3m91LUCA2OB7u4LyzXOFMvjlqVXpGNNR0VNIL45aRd5vC8tX/WR+hD8T/hqa1qxSg1gkac1YChjEj7dc++N0X6Nq6aPQlmtBbuLBVjA/oQkjpe+pFG/HfpTaOIFv0B8cWwSV09oDqDpGXTOnloAQPMvC16fP3t1ZcKG5+KJT7QVW7RgLVur9/XScOrM7JnvK6BCCB/BdxbPsbvV2fL+EKtKBlegzfzWqThGjePlxinpnQAXaxWQtfiR2QRfooxeb9lHg9dn4nvFNdymIXuwY3kXsR0dYuymSvvvGGS9b7Tegc9HRHkNpaPyIBHTOaDcRFXvUWNh8SScu7sJgM91qLj6HXvsv9Cw2VgUyCImEsyEcPFakRmci4+bViEHjCo7oRU1CNTM+/8/+UPmhyol/27XyaAShZ3qyLbwVfCpXgl7eez
 OEHdLQf4
 S2AaJZyb0mM5hakyGE4vP9S/ZNB2Oz5iLdU5GTyvVmoETol43g25KyfnxWU8A4C1c2Buj1Uzd4HKN2upRk0ihRWExTRk6iccJyoq3i/Q6x0XZSqICrI199gOh/aIEMtG44N2C6o658iiW3dJFMnPkWMXyhhHzwQiPUguVuvLe+nWK6zJkuqIOOVY0yLG86jx2cikItdZyg0/8smKMZ3/+kmc1cZ4umyrkinZo2lGedk9MTTDJr4nszmV58fU7k95V0vLdGq9r43EB455lWQKr1Do/QgT8GhtugdkZz3qsx2COMOOd7e6HUjhqAAqVHTQcmR/d/adVmT+z0gvMBn+j4BLWzJ4u7caJAevvSIm2LBZr8mJhOtfaalhZFvYgy502Rsig9+FuZ73V7NoK9+53IaxNNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> Andrew Morton reported that get_lruvec() has the same problem as
> lru_gen_shrink_node(): when memcg is disabled on the command line
> (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly and so
> bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> interface calls get_lruvec(), then dereferences the pgdat pointer in
> lru_gen_seq_show() and other paths, so these can hit the same NULL
> dereference.

So userspace must have booted, since otherwise we couldn't read
debugfs. The reachable case is therefore a memory node with no
LRU folios when debugfs is read? So this could happen on a multi-node
system where folios are landed on other nodes but not on this node?

>
> Fixes: ec1c86b25f4b ("mm: multi-gen LRU: groundwork")
> Cc: stable@vger.kernel.org # 6.2+
> Assisted-by: LLM
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---
>  mm/vmscan.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0c57e4f1eb15..99e9f07fa2e1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2745,20 +2745,9 @@ static struct lruvec *get_lruvec(struct mem_cgroup=
 *memcg, int nid)
>  {
>         struct pglist_data *pgdat =3D NODE_DATA(nid);
>
> -#ifdef CONFIG_MEMCG
> -       if (memcg) {
> -               struct lruvec *lruvec =3D &memcg->nodeinfo[nid]->lruvec;
> -
> -               /* see the comment in mem_cgroup_lruvec() */
> -               if (!lruvec->pgdat)
> -                       lruvec->pgdat =3D pgdat;
> -
> -               return lruvec;
> -       }
> -#endif
> -       VM_WARN_ON_ONCE(!mem_cgroup_disabled());
> +       VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
>
> -       return &pgdat->__lruvec;
> +       return mem_cgroup_lruvec(memcg, pgdat);
>  }

I've been struggling to understand why MGLRU needs its own
get_lruvec() when mem_cgroup_lruvec() already exists.
With your patch, it feels like we're one step closer to
getting rid of MGLRU's own variant in the future.

>
>  static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc=
)
> --
> 2.45.4

Best Regards
Barry

