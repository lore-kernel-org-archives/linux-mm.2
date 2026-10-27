Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFAD606A332
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NmV3J9Ir
Received: by kanga.kvack.org (Postfix)
	id 510986B0667; Tue, 27 Oct 2026 05:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7C16B0669; Tue, 27 Oct 2026 05:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDE76B066A; Tue, 27 Oct 2026 05:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21D676B0667
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:41:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6C858095D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:41:02 +0000 (UTC)
X-FDA: 85367912364.16.3AE4C1D
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7A4F7160002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:41:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NmV3J9Ir;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVBSyNaPKEtFoMBnmXCIBXxl7RDB3mGMHMJZz01NkVk=;
	b=U6wRYwYbQTMl4hDfpZ7iqP5REdnj7aYELtCic6P5TtHJpcwpjo1xPY/AKTkOjEvhfiDQhg
	OS3tFg05g+yTcrU9+5BaeBCR/J6oz4mULYznXqxqvPVM9gEae7/eO7iaI+TUYWjKsj+lY0
	8s9WiAcxiGKIy09Z30mF9cDilRAI2s8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NmV3J9Ir;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094060;
	b=65aKJZCU98nLFRiuK5A8Kvkf1ysvc25l54E6NwkkoU9+xUl55SDlyx495y2gNnnS5650lb
	ckPadc5guXozbBf/kmCuDninC06pow3VtNs6ZpN2eP/X+dpThHhtQvJD9NXoRggdJcQoqz
	WOCXemzy+l0fk80x5BHC1xox8qtKCVg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso3545727f8f.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793094059; x=1793698859; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JVBSyNaPKEtFoMBnmXCIBXxl7RDB3mGMHMJZz01NkVk=;
        b=NmV3J9IrAJ2AQu5FLYy/7uaGCv+sogpMV90asd2wxIFjR0SGjIGffMe3IB+TPOV/nR
         VN3D2cJ5d8sHxDNdYWPxKzA1bnS4y0iYPUTLyGN/jabKgaZ/NB/t7PvhtbXvka7yX+kv
         3TsR0hIoUO7Hc/Suo7RWBzjqK0mgWxfPpx/rmsSCkDVit5HEl5ZUSHrPV9oMoczlajeK
         rZ1qLQdO/6T8y6pnv9Iv8XnG/WpAF7yyCc2bJyT1aiTB556HXagmOaDks68NhvLiOUKw
         0YEhDfb7M0iy2NJ8yyHruIsJArxA3zktiIaWtt7ctEf++hLhPQVaL1GPRhpkrwg2Nco1
         tLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793094059; x=1793698859;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JVBSyNaPKEtFoMBnmXCIBXxl7RDB3mGMHMJZz01NkVk=;
        b=QLSkn+8RnLaq0rvAz26CmOaRhfvpbWCWGdh+ZgAorNGx9pRNt5sfYCc2Z+yrojL7vC
         yjsADESIFiOh/9959lWrTNDN593D07oFaq/gdrcHp9/7MtbamG5EAn3XXhQY/2STIH4L
         RzFPkku9+Xo7MMaLZD9qGxUlZzciyZRpMKphU3yDPPrlu21wb/ivRUuXZzZQ3JMpKUkW
         tssHyi6mSno33UlfrbpZuemwv1bIZwV/kNRwqENIdP3A4cioX4ykZXOXE4NQbUWrdQOe
         W4ANM6l6/28xpUFRrpX82unJhy50z2NE9ljjGNIWKOmv7xz8MQe5DuD0xP3dD6Bv3RHU
         N4iw==
X-Forwarded-Encrypted: i=1; AKwUvBx+UAHsovZow5JRtyiBiXY0erzryU+G0X2GKH4kXy+9kDnQPVcwZu14/STKQyGHyc8wuRrOwrbXTg==@kvack.org
X-Gm-Message-State: AFq9FYJO49qdJxj+/HIsA1ejZtO77UDMVYk1uKDmAGlx3OyfJpBSWTf4
	1SAwRQvBhxOuSQq4EtHDcQMDuiyx+AyYzWrRlP0lYfJDEB71cFm2CE9xgokApn58JJo=
X-Gm-Gg: AYBFou3yMWRNLTpYBxY1h3Td/G3NOtOAfJcQMPP0B13Yluu0icBBAFzIeKvC3nJT2wY
	cdtbY3vkMa7ClndjpkHHJOExjIgWW2Sq+N/Bw1dChgaaNEtmdxcLncIK8mG4IWMRyAjn4GnrjgE
	C7JhSZ3/Rjdq9Qnv2No2+SDiayXqCugOTzwrFBHvWmjVyMjr32S7ZE19kgwQvamVy7nfprFqKZ1
	H0eliqq10zPVhgz7NwSOkA9pvcSh8ieLImHcakDlQ1y0fw/4qPYvZLfoE8Cj+m7EeWOfUbp5SbQ
	/AgmsvW1FXz3U3cmc+uW1/fPj7tvvANop8iL+EnF+GNEw8dQuFwmcBd4rqBCJML2aK+m78AStLE
	5WgXlouChwC9UW8Zt3tWZgB9u14Iox0fg7jjKCoCGMbgWqwoi3qVlJS5nh+YcjEuTUuhC6OVJGT
	16T4Sjkq+UfH6nF+Z2NqHNiZAvEO3SiZhnPoiK8FoY8joMK7uZIDz707pOhzAugtRwJteWzAk82
	nNlKRUxL40L25Hw7zENTvDoB6rlVggcarsL9z1w5JKlK8iFOckA+wkfHwEX9ul28r8nmQ==
X-Received: by 2002:a05:6000:2989:10b0:48d:fbdd:4132 with SMTP id ffacd0b85a97d-48e3eb78141mr13538157f8f.18.1793094058994;
        Tue, 27 Oct 2026 02:40:58 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4bc5sm21909641f8f.34.2026.10.27.02.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:40:58 -0700 (PDT)
Date: Tue, 27 Oct 2026 10:40:57 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
Message-ID: <auBxqU34FQYauoQr@tiehlicka>
References: <20261023222313.3979455-1-tjmercier@google.com>
 <at9U2HvyUP-iYOCt@tiehlicka>
 <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
X-Rspamd-Queue-Id: 7A4F7160002
X-Rspam-User: 
X-Stat-Signature: t9a9shgaf9e93aii14p6iskgk8a43d1x
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793094060-545087
X-HE-Meta: U2FsdGVkX1+v6C0je683RhYBd6unIXZrBCyxLU1pQioVzEiKv2wj99SrhE5mItOizIO6BP3gwOqcD4jAnipPxU1YbhtRxplKBPfqIr4CVtmM55dvNYLevDqhWct4sSlEc0yfzfcGPivjiR5R43/ZXEZxcq5ceSYjfwvCffHp7Lg/V54wclyscSGHpnUEdX/ELuJ7C0p1qn/E7IYsLLZMrvnmlZde3lFtnjl58gussUUOwWKMKmipMy50LLA8RfxAdKJLz/QntdNNt1BWYGyDOrPlvyXM0a9BlEme/9Ue/UBf3y/b9JdP0Gi45apBKsY57sKzeB+f4NCiXT7MJDJ0GgdxQzn9aouyIbWB5fc5uWuQl0SCsDH12aN8G05Teecu9i82UEzRwARfnQCKXyC8jcTFVrn0x1pxIy7sWH92uITxDGqeGT9ySG3zqgTy1AlrpqxVDeOFN8AMECCJTDNUCy89qpMz9fj4Qz+CkPYcQoRX04oRO9vgjWY3rlh2u7Z88RU09jn53qxDMWgfpudxl60xT0Ql12ATRry3y5nOgIPG7PmJwb6UVpo2gRX5CDkShSyLKZMr4MYpamc4yKXtIpvfaSA0SXa5XVT6Zx/lUumAO3m9uX5M9d7jR2wGG0YXHcadIONBFQrTRm4JPUyVd9eqP7w1rI08JKa5HalZgCyS+nwWEbJPd2Wwsm9DYhyiK1GFGfZ3fAqOAvQRwaqERysLKz8axKLci34Cnt/C6oryx/jENHjA5yMQ3w69EXdsGP7XPM6BbmuXm8SNC6qpTwKla/iIqmoTSXQtkx7ui7BFTagSw8vsnu22upXTlE8XGGwBW8s/PNs3ULK+y5KxKXAX0UQWpdMSrWeUrZ63ttY1uTj/MKaMROb5O+pNrPfDmkPyRDbSup4gKoPAcXtuF9lnlVQSt9NmJRMbiERd5zeO7E7Z3+5l1W2zow+H/XJ8yYm68GOCEPWd1yip5RV
 2yLLG0EG
 QxC5AZQXLhPYI9M24YTe9SN+WFtiABg5CeyKmI8C1WWrPKSVcKzbf+HeWZb8Fze3bIxj7tdq20KlO9Q2Vq4KjluZZjbtWbju+sWhlwaeRn6y289i13pM0hnJs5INgx5dnwtVpC8uIx1582NarB9neHqNe0PAdYIiNkNERV+phYfW6C0dG8+huW8Q1FnJjLfrM4NYdnAMnCS7uGqRxrdbQcgMDYBetNtPC76afEYyH5YjKUCF74rhMlWx+rgz06v/FyuNpDRTB2S+R3w24qxfoRT4Pwptt01jPqx6LVBnBXsLBjQLMA6gUZRQhYvnUmwFKxCOVsKn4s8pdFuO+ABynPByMPltHgrqcx1YazMXKunLSpWtrRO2/JDIiSqnE+D5aY1cXPra7r5LaWlUEu1wNP2nbda2lnXugS107mJySGho5Mfs2luZrfhPvBMHbfImQL329G42haCLiL21TX1NPuF+rH+nhP8HruH0Pr67jDvX+9yPcM5h3Qcjm6mr74Y1uiKib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 11:01:51, T.J. Mercier wrote:
> On Mon, Oct 26, 2026 at 6:25 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
> > [...]
> > > ---
> > >  mm/memcontrol.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index a05d9a8baa1b..84f4a8fd4d16 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
> > >       struct mem_cgroup *memcg;
> > >
> > >       memcg = container_of(work, struct mem_cgroup, high_work);
> > > +     if (!css_tryget_online(&memcg->css))
> > > +             return;
> > >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> > > +     css_put(&memcg->css);
> > >  }
> >
> > OK.
> >
> > >  static void high_irq_work_func(struct irq_work *work)
> > > @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
> > >
> > >       page_counter_set_min(&memcg->memory, 0);
> > >       page_counter_set_low(&memcg->memory, 0);
> > > +     page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> > > +     page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
> > >
> > >       zswap_memcg_offline_cleanup(memcg);
> >
> > Should we simply disable_work_sync when the memcg is going to be
> > released instead (mem_cgroup_css_released)? That should both prevent
> > the run reclaim_high during the memcg shut down and and also avoid
> > plaing with limits to work around.
> 
> Hi Michal,
> 
> Unfortunately that won't work for shrink_many() ->
> !mem_cgroup_tryget() -> lru_gen_release_memcg() which can occur before
> mem_cgroup_css_released() runs. (mem_cgroup_css_released() happens
> through the cgroup_release_wq.)

I do not follow. Could you explain why please?

> The high limit reset is also needed for targeting live ancestors above
> the offlined child in try_charge_memcg(). Without the resets,
> high_work is never attempted on them since it gets dropped when
> attempted on the offlined child due to the first hunk, and
> try_charge_memcg() breaks out of the loop.

I must be missing something really obvious here because I really do not
follow you here too. So we are offlining a memcg. We need to coordinate
memory reclaim with the memcg tear down, right? For the high reclaim we
can achieve this synchronization through disable_work_sync in
mem_cgroup_css_offline. For a synchronous high memory reclaim we do not
have such means but we are keeping a memcg reference which makes the
lifetime well defined. If you reset counter you might help to bail out
early(ier) but that shouldn't be necessary from a correctness POV as it
doesn't provide any explicit synchronization.

> Shakeel's remote charging patch
> (https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linux.dev/)
> sends remote charges through high_work too, so without the resets
> those would lose ancestor reclaim the same way. Before that patch not
> performing the resets means reclaim_high() runs unnecesarily against
> current's memcg (not the remote memcg above memory.high).

-- 
Michal Hocko
SUSE Labs

