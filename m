Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B257C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 21:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDB26B008A; Tue, 18 Aug 2026 17:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F806B008C; Tue, 18 Aug 2026 17:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3FF6B0092; Tue, 18 Aug 2026 17:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9399E6B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:34:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E35EA2D42
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:11 +0000 (UTC)
X-FDA: 85115693502.27.D13C95A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB0ED40007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HS3EqYVa;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787088849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcmXbQ44pBlkiZJRhmPVxbryZ213cO3dtfmflOxbDrI=;
	b=MCnj862RPjs1fgqC6ixPWyI06V47YjF4lyKm8Pqt/zgXjFoEyDCpGKVgiJWGcZ59phRJ/F
	ZqNsSxT6Dc8lRr4RqgQeXJDXWtWkmU6InajVqyBIsD7JY0Nb+zwP9kNbtc5slPjKVeha7U
	pVkS3cdrHbP3usrvYcK4q5bNFxYNCUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787088849;
	b=0Brtagv4ZWLFajyP1pBR9UWTGXMhBlQDC1/yUDlC4SMj+eLyy4RT0qgII/njC/XdltwlwG
	z6y+VS62ohLGQ9SEa5qHr7p4gNVXzSI03/UGwCOz+yO+w9sZmbEmP1FgOd5G8uTdNBrpUB
	Pp4t842CfA0tajEJd9d1EFWaJzPMbTU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HS3EqYVa;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EBC943F40
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868741F00ACF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787088848;
	bh=wcmXbQ44pBlkiZJRhmPVxbryZ213cO3dtfmflOxbDrI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HS3EqYVauK5W4pZp9Mwpz4vyqPPv5+DQXmxAn3sXzmqEH/RMFXQy2/nmkniBxKlZt
	 gSx67j2kX+KzfC9liuclGkHtzrBlmoDP1nincewR+FYZD16EfVwIsBhEo9N6UOnsQE
	 CDBkgE+0sdsTNl4lMGPTN/6+4efSvTSe5j7QDjP2vOwJN9VQPvwEuPI5oPPF4NHi7b
	 ULd237E3yeBjTIi5iHoyJuDLBttA+WZZpkfTmglYb6HeEkF+rSPPwMu3rTm/IpFzFr
	 z+w6kskEdoUi0oPQx+DaUktkV62AqH4Cgpn2B2TRbltkAgw4BeoJ+mFPo00m+EuDMh
	 8GFmWpoIDkb/Q==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51bfad59921so1976731cf.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:34:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr26BumDMT6fG5HZXn6eFe8vihXsugJy59tqEIM4Ka6SYv81Mcf8W2gdMYLDqGa8VQf24u9q63EBA==@kvack.org
X-Gm-Message-State: AOJu0Yzmjd0qOjHka2stFXcUW2UylOTJBCpmj232e2OcZovNAtSFSF5Z
	8nKk7A2Q0DmYypyuZf4fTf99DNLVPQKtYr6oCx7lFPZthwEwzv+uUv1IOw+8qYsPXc4qavyczM0
	G5TzHr6rAvVZeTXOhCvyWuaGIJjQd/UI=
X-Received: by 2002:a05:622a:309:b0:528:320b:305e with SMTP id
 d75a77b69052e-52dd5c78e00mr1367741cf.35.1787088847765; Tue, 18 Aug 2026
 14:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1787056208.git.zhuhui@kylinos.cn> <8488e685f584e23c164e00a761c00c1104474815.1787056208.git.zhuhui@kylinos.cn>
In-Reply-To: <8488e685f584e23c164e00a761c00c1104474815.1787056208.git.zhuhui@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Wed, 19 Aug 2026 05:33:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w4HcqBL7X9whgTXqHdkDkwg0u6SSaiaOVhn7wfJx+2Bw@mail.gmail.com>
X-Gm-Features: AcwNN1Vl7E3PGPC2y1WEWM7PpPNZHP_FdRLQ5B0jNzIrBDYEwz_iFvoInjTES8o
Message-ID: <CAGsJ_4w4HcqBL7X9whgTXqHdkDkwg0u6SSaiaOVhn7wfJx+2Bw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v3 1/2] mm/vmscan: fix missing NR_ISOLATED
 counter update in MGLRU reclaim path
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kqkbe55yd34fonnbimunbhim7wgb4ena
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AB0ED40007
X-HE-Tag: 1787088849-858577
X-HE-Meta: U2FsdGVkX183xd/jMnMUjg90YoFfwvKdxHKLhq+z+aVEVVsRB9PHCZ9R2kl5Jw8yGHRTDSr0NU3CpXykW+4/4pp0GOJE8rSNRFWxXbnBddOA7bzTrsvLPhu9ZaSuGfKxBdfNJjUz3qu15LTholuXyN2mUmSq3CoO37nIPxB7B7ihFn9NIR5UZHrOg+W3WP9GVOZQJ0TKhtjw3FSHumIig9z9eYa6pSBcn/5PuRjCF6RDud6VULT9o6A6dcCw9bkN4D7Rjb4rLLVQCz2IHL/X8hlXUuPa3Bx9CL44yE5X4uwSn+Do6GQE8Hdgjw71g8hxLE8+OkQkaWLQS+9naGfBdZWb86R74rGhlgLTAyMNw76Wn6NcC6eGtmBgMdeZywWezQSW7zZKbHtNs0nGDAoHlh0sT61oOzf5dw8JwweLxOlZNjuJi5ctDtunjXnPxTUse3vfrfqjKpqnfMSmznD9cF9j0gWj8W0a0YE/WLVFyL5G8r8CyWOxgldzMoKQ0hDYmIsxHoRMDTFHeA3ykFB0npEXBQYxwzm5911s+bOQWcvFl+LecWbIT6l1LgIhh3jzY0Hwmpf3o1PtOn76AZbZV/r+m6d++buQUlhbcrVHe7+EQhCYBlpgbdbodOI8cQ9b25/B+CStdtb+8zaVl+QYLX1LKCH0kI4J1uGCM6M6pouBc6pJGH07KdeKRAP29G35CTtWHxMVWgzQKaDV8vm5LM87CFHAE/P+mh0l3xMdeodbmJ9RvsrAjDPRzeDBwPFBYdvVgZOoThaEsko8Z0pFU8JX4BQ6XHt+W8B7b7oVqSPVYpnIw1O6BAZJAojkGJLOpr8RacDS5boLnMu9AFYn+jKFYx1/4yta06D5b4KSFqC+fUFW11yitCLwYkFjO5qRqfN5r0gNR7qOigFZnXMzG8LTSXuCfsLH5KQqwClz6Vxk9K/fzvXXqS8lAgvZ3tEDUFdLd8+U3n/GnB+RhJw
 DbggkZax
 He2lcB6/IodPCtpx9ZE9fncF+2q7lrNlguESnKd0DDVDyoYL5gglRddp8zuMPzTwwq5Bx1A6uVp30gcZoKO9X9xY8YOnO2axXflyUkrX/BdeTXjrsLnSh48FkI2lKK5UQiy8shcwcN5caVeF6Jb3l/Jd3nt8W/PTGkEIbp3QWKnbHD1RwxFZYt/qr8hKlDcxUX+Ohlv91cwiAaD85HMeanrVgfJr/aomg5U1HQ7TtKDzTw63Tq6j+EVE4UhKge8sL5ihJI9XY8281hKxJnpp/PdIxuLf1ukFmXPtRMBDgmOJsHooEWaov5gZ1fJC8TIC9d/2VkgtVv1qLgtBFzpYHP60iT8+L3GnDu46s6+uKCQYktfke5/zMZAtE3jaSDzY46i7u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 8:49=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> MGLRU evict_folios() isolates folios from the LRU without updating
> the NR_ISOLATED_ANON/FILE counters, unlike the legacy
> shrink_inactive_list() path. This causes compaction's
> too_many_isolated() check to under-count isolated pages when MGLRU
> reclaim is active.
>
> Add NR_ISOLATED counter updates in evict_folios(): increment after
> isolate_folios() and decrement after all retry passes complete, using
> the existing nr_isolated which holds the original isolated count.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

