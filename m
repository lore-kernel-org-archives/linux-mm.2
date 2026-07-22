Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EA9C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 02:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0F36B00C0; Tue, 21 Jul 2026 22:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E176B00C1; Tue, 21 Jul 2026 22:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C53E6B00C2; Tue, 21 Jul 2026 22:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 505696B00C0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:39:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC7BD160262
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:39:04 +0000 (UTC)
X-FDA: 85014855408.04.ED3A5E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9E2D180004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:39:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chRTL9Es;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784687942;
	b=UiXwUSRoNjuYPh/oIWlMwctKj9t99GYx/eY2kao2L+FbH9AG0AEoWksqAHh4JI0C9vGJyn
	6Z2qXm9MfaqVJY2BsW/9xTyuwdUULzUGlGSUC7dYJP+HJ/S5Erk184SJpRa/HcQHcoqvEE
	qmXGU3o3Zisq1NDOacVj9JTWe49mpNg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chRTL9Es;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784687942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoG0ckj0uBMKx2AZzLaYA1Q3tAn31fS37fVnCHz+w7s=;
	b=V17Ymy9rNjXPPVnn2H9hgdadMueaoV9UA10P4EQCCaFcVT4hbExeu87E+YhOvzsl9d87pZ
	TndT+VXXJskQGzdZT5KrqmfKBAovlBY9ZrV+on+FL4cgdU0GXoOMyqQat5IBe+g4ppxc06
	7kviZwexzts8h6DneJ8Xjs6hx9Unidg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E76160A66
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD39A1F00AC4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784687941;
	bh=BoG0ckj0uBMKx2AZzLaYA1Q3tAn31fS37fVnCHz+w7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=chRTL9EsLf16R4S+Kyel8wXInS+rWxkSz0S2U524Cq48KKpIgJKcIWKay95XyzktS
	 mJYgADItDielMx4fK890aA2n5qW64GJp12BojL2HDIPOGC30lGWQfT9Sk0ZQzJSWrr
	 dD6H5kpK8/cZRB/u5MxYVBk8asVKyo5jfv67BjgJzSdi/WTiQBzK41okePv+cyXD3y
	 bNBkAxYs2UGv2lsoK0pKHaWQB3UrsruIofLCFQcz+utDsb0v2qyPTjtzZZQRmLLaPU
	 TUdURzfzdnQH4r5SBqk0jdurob/k1gTrHnljAJyQpeDchQbq8GFd1BDojlgchE8NF5
	 RvIbdke5ztxVQ==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e50979c71so1355846185a.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:39:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrhrqHAsbuP/B3FBoQ7dlJth1K3x9cdJnLpu1vcFnPS+mRVHG+LMIwm4YYTSMboOaoOqiYRCfB8vg==@kvack.org
X-Gm-Message-State: AOJu0YzppIh7NEeu/2kbzAdvSvkI16mEdSvMm0ohIorPT+Kw3QNriMsZ
	4sCG8GEeD+s2KqPB66g8drlLhPyWt7Cut22k+Y2vbqZXRH0C6QLylSnTCzNn7py9pzu5RVqf1Rg
	NZrAbYYoWVpD6M2AJ2nvw7nhQUKvAaCw=
X-Received: by 2002:a05:620a:199e:b0:92f:e20:8c07 with SMTP id
 af79cd13be357-930b3eaac01mr2131489685a.16.1784687940741; Tue, 21 Jul 2026
 19:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
In-Reply-To: <20260718093723.153324-2-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Wed, 22 Jul 2026 10:38:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yvfGZ_2505PRWFHaqdmUvb3R77GFJSzpQ1vEFChAK+Lw@mail.gmail.com>
X-Gm-Features: AUfX_mzZn8SrKi477dFNexXRzw4N2jgyxaCJqdRLvjk79dxFEMzh2fa2OjDmik4
Message-ID: <CAGsJ_4yvfGZ_2505PRWFHaqdmUvb3R77GFJSzpQ1vEFChAK+Lw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qt7c785qboab7nq7smf4cci14irpqs7a
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C9E2D180004
X-Rspam-User: 
X-HE-Tag: 1784687942-182114
X-HE-Meta: U2FsdGVkX18atOC+kTfbmFEolBSOCFXLiV3/MLHE5ksU6kS0pOkn1MNoU0zcLLkTpSasS5KbujXYPKYvmMChTvA+DcVYy5ynMdEardLDqceiVX1oxuWgmMG3QlnEKTntgvw3uVAci3u3ASJriURD00b8kNKSOzATD8yhX1tg/IaaCFYNV/HWuYgKAdlc5sSEPTvXrjxBzfU1u5554G9Z+B3SE4laHsWw0eLsDNbKTRu+Bfb1yY6c11ze4VD7luDWHD7r/IdeVmc0+ccjx075/UCSftUvV2cW1tCbgimijOGfbS4+STSv3HVOJIjAFO4m5zIzj/8sYtCNIuuPWshGxCDnD+DyBGZyUblcX9kDSG9ZIBh97Km2UVHdSTj5m5hpAgIYbkDovJYDS5iMC63oihVtqfV9whYGJM/C2wFxPwgDvFBbVl/rInKDEdCA4jjlH/3Pp4Ad1VUEN7SsEO5C9oIrPp/ZPvVKcaxCJdplYi/SbTdha2vRPlWu2csWKUyMqMROTqs9u/YXPfRRGw6NbvwvrpspY+GRRePI6pCAgD2D5A4s65/zn96yhy79te982C6nt8QUBHKRVg72UG/cqVFYVjLsTqwpRHKpXLK/jolxKrDJmXfN66s1bPV8rTbhjren0rvB5VL6UobNtx36nwZb8QQV4NPtnAdX3J+s0cLIAauaRV08KJmWpVwgem4uEV60Qf1bkSdOq+nS2+N3C39ZlIky74uSasPXuQZXbktgKsqLzpQX0zVW4MD7kWVTol4u6KmVRtxlnEaZIfxenitI9m/HQVvNKCdd9w5Vu0khG73Hqy66g9WXxM9Vdsgg+1tA6ncjxLo94fVY3kKym6NWH2uu7SxuRR+YVcGQb13a/pHA8izgwazJEoWAbHfp7CZe6jE9myCEOfwUfCg/wBtu6aq+BRr6FLZ1NhB7PiBNwbqCcHGFxg5K9Pt/wKGVG3UWJ8JFA5Z/ydsXVQD
 ciFTB/R3
 GSdpG+iMi9FtAjSsm/4MYu3E3ICG5v06yqg3LodeV++l9fnt1Mu67Etod7gE5Za02pdFEbsc4ifXPHhmyXkXoB52Scog5a7nIMi82u7blH3WS4MQVxrse5QB0zZShdi0yIs4JGiTVf5W6cBPCKRQoS+560DQlpx5nymdNQ8jk+KJeXxLm6SZ9dHODoLZOPKLxTYsQqmlQhpZSAGRUX2y11EyI2knzSjsv2wcIojTaa3usJaHoLnZYeu0ob097+tg060+PRIfEstxPv9/FVnwdMdNqw4q9/ghej5m6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 5:38=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> When zswap writes an entry back, it allocates a swap cache folio,
> decompresses the entry into it and writes it out. That folio is cold by
> construction, but it is currently left on the LRU for page reclaim to fin=
d
> and free later. This wastes a reclaim scan and keeps cold memory resident
> longer than necessary.

With MGLRU, we already have code like the one below that reclaims
folios directly without requiring another reclaim scan, whereas the
active/inactive LRU path doesn't have an equivalent mechanism.

                /* retry folios that may have missed
folio_rotate_reclaimable() */
                if (!skip_retry && !folio_test_active(folio) &&
!folio_mapped(folio) &&
                    !folio_test_dirty(folio) && !folio_test_writeback(folio=
)) {
                        list_move(&folio->lru, &clean);
                        continue;
                }

>
> For synchronous-IO swap devices writeback completes in the calling contex=
t,
> so the folio can be freed right after the write rather than left behind; =
do
> that. Because it is freed directly rather than through reclaim, it is
> allocated off the LRU: dropping the last reference on a folio still on th=
e
> LRU would trip the free-time page-flag checks. A folio that a concurrent
> swapin has meanwhile claimed is left in place and reclaimed as usual.
>
> Asynchronous and filesystem-backed swap complete writeback in interrupt
> context, where the folio cannot be freed; they are handled in a later
> change.

Might be a bit off-topic, but I've been thinking about this problem
for a while.

MADV_PAGEOUT, and reclaim in general, don't actually free memory
when using asynchronous swap devices. Do you think it would make
sense to free the folio directly, at least for anonymous folios,
once it has been written out, instead of waiting for another reclaim
scan?

It seems a bit odd that after MADV_PAGEOUT completes, the memory is
still occupied.

>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Best Regards
Barry

