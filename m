Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D6A606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iG6FyKJe
Received: by kanga.kvack.org (Postfix)
	id 2A3836B05C5; Wed, 28 Oct 2026 17:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A276B05C6; Wed, 28 Oct 2026 17:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169826B05C7; Wed, 28 Oct 2026 17:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E91EC6B05C5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:22:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D07B6A75A1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:22:54 +0000 (UTC)
X-FDA: 85373309868.09.192DAD0
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id DDD311A0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:22:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iG6FyKJe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
	b=jTpEzxz2LsUl6rFzzNa/QoziqCA1bz36h/AH1HvWqM3UA+i62IG+i8Wkt6cKa4AyBzCDru
	UO0BX0kW9DHwqsInMxaYUu3wx0BW/nUZ4Mf9eEOtSb+5rgwGAXUBXaTPMW9jiSF++ih1I7
	233HM7Hk3X4Ud8pad/YXq9Ho+ZHzFnE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iG6FyKJe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793222572;
	b=JildesrRr6A4WozcI8kqJkFtQMOAwZ6J4wsflLMYEyh4XOrPw7UBw5jNDANH3cgvpl8IXI
	7Cjpi/7eWe/pxWIRGR7rYSLdLlUee1QE/E9zx97FY7y6IELBDPSSVZTYowtroWhVGssWTI
	b+cfmICJ/o//x7hdVnN2FbXfdGNVHOo=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20d7a8984so5155e9.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:22:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793222571; cv=none;
        d=google.com; s=arc-20260327;
        b=ax6xWxY69hsY4Pluts19kBoTkoh+yK5uHpl5uX6cjP4bpxfJn5ER0pX/bQ9oR2Qjn4
         tWB1zZ9iOKC8zxlVCnUM50l60JM1aDJl+djRi3DCsP7ERCAFgKku5gsyLAurt3CfdHsc
         7XD+R/HOHTpeiFxF824Gt7GPQj+4rbz2wNmaliB056dXbnfchggtPwq/DyQIIUgmNk/Y
         Dv7/VVHW8FrRnEzkCgfN4JuLVz3Eb2rOSx8ARlbHtlcE48AV1m8JB+OB63cBB/QSY12H
         L6Lf/0OIEuWnGT6N6dx44L1JUKviS8n9WiwThlvFOs++N+MgvN/AKr5i8yO7Q1h6NjvD
         wueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
        fh=yST/C1aYUCp/gGMuWG2Xn9xIfFHhhbzQTtlntHGlUmQ=;
        b=qvZ3k1qKlyzY6fR4h/b4TZbjIxshJhzHaVKO1oCUYupqL47QjTEXhTqQGrBBbYw1Zs
         8IaKTTavey0MG7DYEuRh3GUtISKvQaVo81tLLtvmoYAqyMCDBZuKa034u4AbVrh7pGAj
         N4xGBkwo5lqeqUiVag81NPm9D0V6L8088byhz7gtdWS62hDWRuZTZ2qPVALJEZ530X/F
         kGT0ekUsuZ7MRdCwlkcdYK/uBI68zZ9NSbrz/X7/tx8St+4EkIU1MTCPw96nNvxRGQSH
         /CsqU5rdYEGE95LyymIbJLC4ABPWmSi8HccZcCzwgQSY3xkk0xi1TvK0JfiMp8uZguH3
         pY/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793222571; x=1793827371; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
        b=iG6FyKJetJ2NZBWQ4HwiJ9S4rq5C9ODLfQzjx2o8XX5RESmdoUR2Zj9iiqyVw7H4za
         4WRM6XbaSJSNv1+yzC6d3EXopGQu4zXCD+w+8Fc1SEeZVWtZoA1PmZFCZJEPTlXBtBzS
         +WzKnwzCTwzvHDAT8odzCIrdjQ1CNyfGxM/BgWfoiSiBJcw2eUoCfGknV4EWquqZYWHp
         2mCmEBg0QXBMCf5PXMMIOVVc4ejcME7ElYYL5IZTJizJU2xi4m5RXtGYTKrCmEa4t6id
         6yps3vpLr6Vjp5nOUszsTw1Ns0gmIIHTT80amn8qT6m9JDjP49hW5dYDI8oxF6y5VIfW
         xjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222571; x=1793827371;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9OWahcyc0RtO0+EeUD26bkvPuyjvUzZOmtjTnKMJz4=;
        b=qpmAyQH9B7DCZ5r5Gs28uYaNu2rEQR8JeduWZWEGb38ExgBGZvVOSanzUiZVby+u4E
         aQ8LBFGY7Np6FCXBBDZOHf2ha71V14Uz1wW0bAGSyodxvsJQXw1k0O+QgT6dr8OaQKfS
         sGdHkaA63q1RZIId9PvKW/CyCZQJhF/JDFGBII8CgE7nRLeqeSAcm2OpudU42KsChYsE
         Yrk6r3dDfpRzJ+Li/oLVvaOHsUoo/jvTEOnmCr8lHCsOqkjdslTpnOj7fgQ0lpIcizFw
         xkRlhE8597X/qmXa9x6jrsRpkHmGju3Q3xPVeCYbq/I3NTYurNmJW9bdb5p+QzJxm0Tk
         yuTw==
X-Forwarded-Encrypted: i=1; AKwUvBzdjlmg69OhnOoHOMkvVu8fnTJw4ylN+22ogyd8MIYpXzvPQfd0e1Y1xE+McQnMZ568492Yk08iuw==@kvack.org
X-Gm-Message-State: AFq9FYI3Sj6gZr/CjfZLGRX/PIkFnt2WF/LgYBedKGV3c+3PtR2iQ4Gc
	GXW8av95tCtYKuXDLwR40MVnL64xBWDaIAJzIHV6Yj9NmtINzV2VNtM5QOeo+qu5sp7/8JcKKTe
	QUGDeH+v3fO8IqHqDGPeQrKbzs7NxAe9AguNXJajM
X-Gm-Gg: AYBFou0eeo8pGmoiw1sedUHq/+FN2UdiYVSq94+YqsbLKBEa035VvJhMRVmrffWS/1B
	v+o6/DeyFKZ4QVvsvrGZVNtBudMjdWKe8fAqHjmcg4sZa+UWownjlBtHt2d2SbngSqXbZ0XXzMS
	9g367dZCF3vVhMjn2cOSTyhYBDVqCDWTqiBr0WDwJSBAlVhJ29XNHAO8RgK5Oh4zztmqGtTKMlv
	N4NZMgjO0c9N0kI1PYKwDFltC0i/biv61O5peH8kPkI+2Ma84eBgJ3JkPNRolydix9Mh94w3nk6
	7ZFYAtnfND8j77hAw7ssvdpoWam0YiFMt4OVoG7PGGp3ol6aGYQlFyF/WNciNX64v+4ovPlS7Bh
	IO1dRHueRgeHJm6vP1/s37hw4eSqa1fpQHmrSkAdqhJmRfg6824Z/zE9JvRe2xv7yLy/yNEPlWt
	uck7YVhXo7KtiQRyhzRYalIRE=
X-Received: by 2002:a05:600c:26c8:b0:4a3:5de0:19ec with SMTP id
 5b1f17b1804b1-4aab692b046mr61845e9.9.1793222571076; Wed, 28 Oct 2026 14:22:51
 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4> <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 28 Oct 2026 14:22:38 -0700
X-Gm-Features: AclHuK-BDrgLvfZN_Z6mj4D7H_QyFDZWiVpmhu9KpmL6zRb0X5M1HcHjt7g6ziM
Message-ID: <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDD311A0007
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 4piuruebbej58fqauaqx4r3mm5kkzyqr
X-HE-Tag: 1793222572-306840
X-HE-Meta: U2FsdGVkX1+098FBS0leDys5cKEWN98OJTxysEDGFlGVXZCwiRpWBeKySGBtReADws9L6+riapO933e15ljfxx3kQ6qBq3dRIxqrgiT6yw1muQcKjE5yDO5dqXvEBkiXJHgQlr1OO5Kh0p1YvZ1cXsvr46CK0G1ryInWmg4q9fM5vHy3d/6IdYhstJfudn5nPQEY4FFfRMSnNYJdXohvKxBe2TzzjubEuAyci0JPEQJ6aPK36EJim/lROHqnEHfDQJLAc1srsfUpW0taekJgwsW3X0Ma6GqfC/PWT3SLvf88Rbehhlb2rE5SLpYL757I6SHmmmTFPPkn0wuBw0rJDRT7sBDKSkL0L2+NPnIqWM+OhuYvLah/p4tA+UMoIR4qQxrAnQakt/bc7Ot0GpUrLyXN4G5Pi2uUVhRoPa80H3dTK6zwhPoAe5LsAfHcBwqWi3+uMBF4Fn4Frx2xO8Yj1DFgztYiMPIcpUjnKObjaPg6Emf95tq01d2MacxixMBa6m0ErXHD5P2EUrbMJI2v0O5pabKJswYWXVuMORB9VK6K0J+4s+NuRlFNDW6+Uv9vLsIrRrIA/2ODIfg7uk6+kmuPLDRi8rye+n14+SuXh9Ger+snf47h5Xq4VJqqp28zTVZLtgcvEZJb+ytRSDrHMsQuRV0kp0tn1l3c0b6Vgs61TeLg8KlReBtEaU7b+W/24caB8kEkSVI6KspXUN8sOPLuxkBmoR2Tc9Xjq0KHvuZ9Qxi5H7om8n8yII4NJmj4ptOlYz2hjNalPMJEMYrVhsDn5tU0YylPqbFENxC4lSgjbS96REHO7YTJKF3s07bswDXGOkf33Q7b2XWX3RorfpGFnzW6KVfFZ8cCq/ytpUaJKOR8p+2WplQvd5TvdQ3UqZp8pw5fKc+qeQ8jYQWlxPLdsxgE4G/F+Stucsdq8K9P58mOEZKki1/GVBurvpND3Mb5QWtNMXjEmyY86Hf
 asD6GAgS
 luGLjcgdLZGfb8/ROnQlDCWA8KHgTCDwRfReUPj1qFWSPwAFEt9nLaVuubTwg/THRYEUVmw8pCTiwYw8Dma2cHTUr5vZCSxmO9kXBArRdLFrM+GeEGnpY/mjzQClg8WJBpqP2+GbHzkIF3aRLW/BpS/Gh6twSvQ107lgfmSw5fzPi/9k06Sjg7urrX2xr5Wk98yfEeJN36hmufQu18mqW8aunJjnWEzBQuvb/rUKNlxcYoyMLW5waneydk8Vmz2Dh/VPN3Nzz4P42tEsD70XrHPA7U6Vl3HKoabu7GgovWaRNivnXw09r36hZ8dv615kRHaNdTd2AskbCrYfdh3Z4cLretmNO0vmt/W7m+nl8ARcnats=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 1:57=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Oct 28, 2026 at 6:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Tue, Oct 27, 2026 at 06:06:06PM +0800, T.J. Mercier wrote:
> > > lru_gen_offline_memcg() moves an offlining memcg to the head of the o=
ld
> > > generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> > > visits it first and evicts the folios it left behind.
> > >
> > > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > > dying memory cgroup for LRU folios"), those folios are reparented to =
the
> > > parent before lru_gen_offline_memcg() runs, and nothing can be added
> > > back to the offlined memcg's lruvec afterwards. Putting an empty
> > > offlined memcg at the head of the old generation no longer serves any
> > > purpose and only delays reclaim from the memcgs that still have memor=
y
> > > due to additional shrink_many() iteration.
> > >
> > > Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> > > like any other memcg below the reclaimable size threshold until
> > > lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has=
 no
> > > other user, so remove the op and update the memcg LRU comment as well=
.
> > >
> > > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > > ---
> > >  Documentation/mm/multigen_lru.rst |  4 +---
> > >  include/linux/mmzone.h            | 14 +++-----------
> > >  mm/memcontrol.c                   |  1 -
> > >  mm/vmscan.c                       | 20 +-------------------
> > >  4 files changed, 5 insertions(+), 34 deletions(-)
> > >
> >
> > ...
> >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 636152d8c94d..45a2c1021f4f 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped=
_walk *pvmw, unsigned int nr)
> > >  enum {
> > >       MEMCG_LRU_NOP,
> > >       MEMCG_LRU_TAIL,
> > > -     MEMCG_LRU_OLD,
> > >       MEMCG_LRU_YOUNG,
> > >  };
> >
> > I think there could be other usage of this LRU_OLD macro, but indeed
> > offline is the only user currently, removing it is cleaner.
>
> I'm imagining an Android use case where, after LMKD or similar
> userspace killers implemented by various OEMs kill an application,
> we may want to prioritize reclaiming its memory by making it more
> likely to be scanned and reclaimed, while the killed application's
> memcg still exists - not offlined.

I think it's an idea worth investigating. I had a similar idea which
is proactive instead of depending on reclaim hints. The code is behind
a currently inactive flag - it runs memory.reclaim on an application
cgroup before offlining it (so no zombie or reparenting), but I
haven't had time to properly test it yet.
https://cs.android.com/android/platform/superproject/+/android-latest-relea=
se:system/core/libprocessgroup/include_platform/processgroup/processgroup_p=
latform.h;drc=3D2ed7b05ab42dd67391ad2819b0ee399d89128ead;l=3D33-34

> Similarly, a foreground application might benefit from a lower
> chance of being scanned and reclaimed. This suggests that Android
> background-to-foreground transitions, or LMKD itself, could
> potentially leverage the reordering of memcg LRUs.

We are planning to use memory.low/min for foreground protection.

> But anyway, this is not a reason to keep
> MEMCG_LRU_OLD for now.
>
> >
> > And everything looks good to me, thanks!
> >
> > Reviewed-by: Kairui Song <kasong@tencent.com>
>
> +1
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks!

