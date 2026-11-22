Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F8A606A33A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pn/wMeXI
Received: by kanga.kvack.org (Postfix)
	id 8EA5B6B05B3; Sun, 22 Nov 2026 10:33:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AAA6B05B4; Sun, 22 Nov 2026 10:33:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7643F6B05B5; Sun, 22 Nov 2026 10:33:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 476D86B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:33:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C794CA0700
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:33:23 +0000 (UTC)
X-FDA: 85463149086.27.E89452A
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id D5ABF1A0003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:33:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="pn/wMeXI";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795361602;
	b=NYDJC1e+Mlqc8/7jQUxZEvzn8dMz513zkntK+Hwt9K8rnzkcHi65nb6OunkFA/PKg9bzo8
	QvKfOcLTNu3ZqUFP2SnkX5eyZtsv/jGrk1TKipkZIRwG8JzHDU0X1Px/6MYFt6iAWZkdMu
	7C3cx8Pw38V8zlIU4qgodAeSFx/1lQ4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795361602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3PNVyFxIacZxXwvCauYesumPiWXN0gbWEJ3UEmd/S0=;
	b=Uh1s7kmIj2aLIWz9RNYV1ngg+U4KeAitjSBkVBrCVg6JulPSz0DgtpRu1W/2umS+v0HVhO
	RMdcI4nd3Zs4n1V8DlnFE3whUzP1KPtAtqrFqLemHIqh1gqmqkvGd/A3UZDK02/jLkCE6Y
	4Iq4UvyF6wDwp3GqvoHCatdfpK3JPfI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="pn/wMeXI";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so3594513a12.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:33:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795361600; cv=none;
        d=google.com; s=arc-20260327;
        b=e/9YHlrMVXQvHRKMv70llpKmNCMGL+V2oda8+TRPHfzd4f7XwTTrHtjkvJjYrSCc7C
         Tt8eeJ+7e6kj9j/Pc7bdi092qtFOZvdTPce2zYisdxvwd2G+MhncMb1nvkpWMYZFurPb
         E4fJlv3KnbcNNRRYpx0ZtrLcDrk/ccbcXWicFVtx9rnLEpoEOAxbLTCJSfalAErtIsk/
         3mHbOBsBLiMipwqcWaO6CH5h0FaPM61vT3deTqlEvhBwzWSaxbVSNbWf8nEWaLC6KXGa
         6hN41X+tlZ8k/b+6fnw4TfRgx5S3vB0RPNQH0oToexkcrjCMitXjm/XINdBthKvCf1SA
         yGpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J3PNVyFxIacZxXwvCauYesumPiWXN0gbWEJ3UEmd/S0=;
        fh=T8CZMS7v8hqzytLXYnmzITZSwL7GsHFkUt82dnSnzkQ=;
        b=hdEtolqZ4E0Y817hzQmfD/t9hetpkrJHZOLJZgdQnhBF8uxdu+10GOeo1iem420eWp
         BxHdHEKZPPgwWevUDSg2OcBsonhHe2zyqpKHOELyF9/jrsa0lmbQVgTLwA9TcT1At6XW
         oUIrUDvqiHZZVwKhurGF4gttvkuAX0wkr/S1dFILeTczE2h+aKxEujLV28r3OjcMaxK2
         JCuJB+hriTciijxKw9cZ3wE9tabWjpYZA9nnROL8z/NJM8dqQ04HNBEqhfYN5J4RIxnZ
         sh0BSF+P8Gf7lQNABRP9XP0RMQhBSXM9sYHyar2pNPCgD7lIAFocGilvC7ovyEswr7Eu
         veNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795361600; x=1795966400; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J3PNVyFxIacZxXwvCauYesumPiWXN0gbWEJ3UEmd/S0=;
        b=pn/wMeXILlJh054rbc9Xzt7Nf5hb8UAwW/nrFRnJf4idQ7xG3SLJaiQcz+7UIK9jUm
         1RiYie8TXwCsxsB4ksiSMCM1O2vPUvLuIm1FLoIXE7VJBmWwybVjcyFybXJnhVLkCJoh
         9I62v2d2r9pH1HvLdfRjAwuPn0w4sHNLZZ9TeAsrdElPSJD3CBVS1ThhmrsSEZpb2uha
         sUV/KsK+XY/58qRH5BXZlzP00XlvhmN/RWlqaOUyvr9o2Wt4uNUO80i1oRYig88xQB3W
         VC7MAM63vAle4+GFmL/m5b6NdzFW8LT7Mx+M5Sx2VS6cLNg7P5vpksygPZNmT8NUpku/
         3nNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795361600; x=1795966400;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J3PNVyFxIacZxXwvCauYesumPiWXN0gbWEJ3UEmd/S0=;
        b=HjOtDWhEzG8lMkm1gfcHPk9FodnT0e6nOOO3BiyFvoddA4kTZRQbfkEiw9aItwlqV9
         Jg+mKmShTBNW8/BxXwRaSpRdZAB/M90MDqklu7oKDrnRBqlnsGAQEDlSNg7xCrEL7lH8
         LYCCdY0+TAEWC5LumrvF1UuHcy/7dGGbfV+H3h9UpwVProj92Rn7IcjZoi87JltMLAv2
         ti1nY8gHQXiECPgd/li4pWEuecoNpI1BpJs6RiKZ7MNa+AmXWC2IF3p0ukz1BSfQWLuo
         m/lzb5adPEnL2NV817K/VAMtROwRLYarYj+ET3/rcMvinL2wuB8AXG1w2Ag+bo9IaLPW
         3LHQ==
X-Gm-Message-State: APuU4Z/9fbLcbFnYlCbxpcBLucYoKU1ClxKg8bCOeHDAJxhfEuCSxZG4
	Knd+GMzj+86CVlo7BoPDNLSH4C3Bjj/jPx+GcVWkM5vamHQWffceHnaEMNxfOgUsKj9qgNO0rZ3
	YxxHl0k2qtRYt9+hP/KhNfzbkC3UCRDI=
X-Gm-Gg: AZFdTZdmSFCF8UeVZZ4k4H8e6ooZYXCk870OHhl/D/uxgKzrhf2+1Q2uziw6J11PDgo
	eLag4r56I6D9UMO6GQkcG0z6oFtZFLHiAf71iVmm1eN1hvI/DPFLQXgbTUDLMWD9pk3VkFVpc/K
	f1p/D/E1mHy6mavBnyDXHbY5yDWyNoasSmjyrQtfBGxbhVua70Lc1OfkFRIHGv51ClBbYxZeiMV
	mIW9XXv/KwHEdhvataRrHOXlwaigfWa1i/dr2uDrO2nXVUazwxNlGH26t1WRfaiC2qkEXaYR4Ln
	WQ4+AGSLL+nC1jEBe0+qPwYSifSSs1iuMqVL5YtrrzI5xnd26eHzppFV1rYRN2QNi8TubqjCNEP
	8aN9LuwLriFS7g2/DN/n6Z431mrw1yEjkjmPYWMc4+SKpJ++R574UhlMErzIQSjGyU8FeQgs=
X-Received: by 2002:a05:6402:1941:b0:6ba:7b46:78c3 with SMTP id
 4fb4d7f45d1cf-6ba7b46833cmr2556438a12.22.1795361600177; Sun, 22 Nov 2026
 07:33:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com> <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
In-Reply-To: <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 22 Nov 2026 23:32:43 +0800
X-Gm-Features: Aa3M54pHOiCztVzRTyhXWZzF_Dp5eaWz0CfbXn8E3WzEubwRH9E6XJ8yTzGAkf8
Message-ID: <CAMgjq7CEdWvv8m9GtWMG=8OFy+1Sehx3HBJt2D=9hntwvfbf6w@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rmce8t6irdrgg1xrcw8jkqn31j5iqk4j
X-Rspamd-Queue-Id: D5ABF1A0003
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795361601-279151
X-HE-Meta: U2FsdGVkX197uEkpjl+CWexe3dIRxe5wSYpT1CFfSDihgo6jbMaCEm0WdFJCYn6WMafbLaO4gVHP5I/4TtLWD5HCXNrmaC1dUolrKu3sD/CmRyX/MMWVqwx4GNYT0XGppj/c+wTxqmsJME08A1vElXEnIT80mYvhrKPY+unctTPLUMs+Z8M4xfOQveeWSGEbs5VOFGfgOO+hbOfDDU5lUNBn2o9lxXLqJH+wiQ4sVWJAZpUpExonZxG2IHHkhvUrmd2fXXa7GYVeTv4vN4slHAjxWMi10Y1Ba/wslRJP0yhnHaSSpT090NHMymU5pRGQCQkdpUtUsMsfOeOm0RtnRCzKHHsBOXkDNSynNrxfM6REM+U2tttHT6Yb8JXBgClPe2SL+2qfocwLtko5W3jmxfRelRQCfCoSzw592uNa1sCDnd00v80pDOB2zS92cV+jhpTtFNT9fUXcz+PRNtKyOXcfqLby7Inr+5mCUHnGzi0RdttvvGaaP+ANXEzw2uF04cwrIagGtANea7CoZgNNAAbpUtCcqCn7BM7l28hHWooIriVbwGG1eFo7XQcAIizM5Cp4GwwvStz8pYTa3xnu68GqAKWczhQ1DHC2NrfFe9HwjY/uB3Y1gbXvM9m2ZIBobZZ7x1RfE15iSJbFq+tIxBe24/G5lHaIMj+nzaoczHvaNTtO4r+A021OiPDsSYMJ7Y57JYGHsU/KCMEL0uAyck/9FI1ahyqqsbXGl66EEZasKBDw3+5U98bq6kQkYlr25mKndU3nbAYhl2vh+liofCP4eFaB0t2NU1KjzTj9mW/M6ZkFCvvxP3YDaBzfcuHsdkjtIj4MJWSyIJ/gsErSgxGvZBG0a9MXRAwOji+L/YKJoTwA9o47BxqJUnA+p1q26jPoHxR4T2oWxYOOqjy874fxEyyi4A5HuRLeHzB3Lv1YD+YFpD5DCu/w326+QEzeBzYjFInJamqQqZUOPvm
 XYTFkCXF
 G8l1hq1zrvp3gLwYb+TitlSBfpOVpTMn8/dCuD4mXgtJCS+aqvoKwkoPdhjkuwkKQZGGhhAUDtRaodB3ND5mBvm3E6Rvq1aW/27DqdmSO8c93ZTm67lp++iCF0/A8tC6xK73Mdm4ky40CaJwqvxKhtXS8StVzko3xly1H2e3Fxq12M/t8v+FoitGT6AO2Ljzgy7pvRFHomHXCIPdplfXoISMHryJC8b1K1Nl0+VD/8H1UfiA1vucS18FJDhgQy6RGm+PPV6+FvmIzRusDKWQDfQrimuonpRtXMufP+PIYV91FqVGnQpLQNMZpO58WSSwXy/PnkUk6O91DHD7JLvwelSNGl9HtF+Zd2z97ym8wBG4D7veWh6a+dop1U8WJ6ykEdJ6LuVA41pN34HDelqcoOWInPXTRshe4VjT7G6Pqt2/V5b2EFNkquHCJf11l0/tfese/wzWelJ5t9bY9cD1xKdmsML/MlmtD4Q3JERFn6dWxVNAiuvpzRVEWMbn3Jpx7seaDXb4X78av6DxBu3eDyNYU2TvzkDzo12a8AqBgwzLB93Yni67TGuItRjuIsXn3VyXS8j31YH4GMyL6O3Sl3RU9W/5H61rE1LjBlc0bUxJ5SEE3XNcwOs6OqlQOGObuAxFii87rSxA2p98ouod6t/T5rw1oFb7DsKXYOvOatA4g3vEoAWa/dQF7f+x3uRcm06huqQxwKWm4MIA3HyamIDb8DPCQY328vGcDrQgxrXuDM+ntHhUqvRrncOFsvuQmyg1N9QujvL4wpN9XR2Kvjgn9glpI64kCMUMbaXNCM/gEtgLUEzFSqW6T7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 5:42=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
>
> On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > concurrent aging from corrupting the size counters.  This is no
> > longer needed: the per-generation counters are atomic, and the
> > active/inactive ABI counters are updated per folio and linearized by
> > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > them.  The same argument is what lets folio_reset_lru_refs() update
> > the counters without the lruvec lock.
> >
> > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > read lock around the lruvec lookup, and drop the spinlock entirely.
> >
> > Without the lock, aging can advance max_seq while a promotion is in
> > flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> > flags can return to the value read earlier and the cmpxchg succeeds
> > with a target gen computed from a stale max_seq.  Recheck max_seq after
> > a gen-changing cmpxchg: if it moved, account the committed update and
> > retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> > The retry may count the access twice, which is acceptable and avoids
> > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> > orders the flags read, including the one returned by a failed
> > cmpxchg(), before the max_seq read.
> >
> > Also simplify the post-CAS accounting guards: gen is only assigned
> > non-negative values after the old_gen < 0 early exit, so gen !=3D old_g=
en
> > implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard.
> > The active/inactive ABI update keeps its gen >=3D 0 check because an
> > off-LRU folio has no lruvec to update.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 10 +++++-----
> >  include/linux/mmzone.h    |  3 ++-
> >  mm/vmscan.c               | 51 +++++++++++++++++++++++++++++----------=
--------
> >  3 files changed, 39 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 77f514143266..2c6cbd0df686 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lruvec *l=
ruvec, int type, int gen)
> >                gen =3D=3D lru_gen_from_seq(min_seq + 1);
> >  }
> >
> > -static inline void lru_gen_update_size(struct lruvec *lruvec, struct f=
olio *folio,
> > -                                      int old_gen, int new_gen)
> > +static inline void lru_gen_update_size(struct lruvec *lruvec, int type=
,
> > +                                      struct folio *folio, int old_gen=
, int new_gen)
> >  {
> > -       int type =3D folio_is_file_lru(folio);
> >         int zone =3D folio_zonenum(folio);
> >         int delta =3D folio_nr_pages(folio);
> >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > @@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *foli
> >         /* use the refs from the atomic snapshot to avoid raced update =
*/
> >         refs =3D lru_get_refs_flags(flags);
> >
> > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> >         if (lru_refs_is_active(refs))
> >                 lru +=3D LRU_ACTIVE;
> >         __update_lru_size(lruvec, lru, zone, delta);
> > @@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct lruvec =
*lruvec, struct folio *folio,
> >         unsigned long flags;
> >         unsigned int refs;
> >         int gen;
> > +       int type =3D folio_is_file_lru(folio);
> >         int zone =3D folio_zonenum(folio);
> >         int delta =3D folio_nr_pages(folio);
> >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_F=
ILE;
> > @@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct lruvec =
*lruvec, struct folio *folio,
> >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GEN=
S)
> >                 folio_set_active(folio);
> >
> > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> >         if (lru_refs_is_active(refs))
> >                 lru +=3D LRU_ACTIVE;
> >         __update_lru_size(lruvec, lru, zone, -delta);
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 2680e15b6de9..235fb04f8d78 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -540,9 +540,10 @@ enum lruvec_flags {
> >  #define LRU_TIER_MIN           0U
> >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> >
> > -/* Access source flags for folio_inc_lru_refs() */
> > +/* Flags for folio_inc_lru_refs() */
> >  #define LRU_REF_MAPPED         0x1U
> >  #define LRU_REF_EXEC           0x2U
> > +#define LRU_REF_FORCE          0x4U
> >
> >  #define LRU_REFS_REFERENCED    0x1
> >  #define LRU_REFS_WORKINGSET    0x2
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 78a1b4de7076..4576a7a369e3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio, unsi=
gned int flags)
> >         long nr_pages =3D folio_nr_pages(folio);
> >         struct lru_gen_folio *lrugen;
> >         struct lruvec *lruvec =3D NULL;
> > +       bool aged =3D false;
> >
> > +retry:
> >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> >         do {
> >                 new_flags =3D old_flags;
> >                 old_gen =3D lru_get_gen_flags(old_flags);
> >                 old_refs =3D lru_get_refs_flags(old_flags);
> > -               file =3D folio_flags_is_file_lru(&old_flags);
> >                 refs =3D old_refs + 1;
> >                 gen =3D old_gen;
> > +               file =3D folio_flags_is_file_lru(&old_flags);
> >                 if (old_gen < 0)
> >                         goto out;
> > -               /*
> > -                * Lock the lruvec if the folio is on-list. We are alre=
ady
> > -                * doing lazy promotion so in theory we don't need this=
,
> > -                * but for now, concurrent aging would still corrupt th=
e
> > -                * size counters.  This is a temporary limitation and
> > -                * will be lifted very soon, so the lock here is not a
> > -                * performance concern.
> > -                */
> >                 if (!lruvec) {
> > -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(fo=
lio));
> > +                       lruvec =3D folio_lruvec_live_get(folio);
> >                         lrugen =3D &lruvec->lrugen;
> >                 }
> > +               /*
> > +                * Read the flags before max_seq, paired with the store=
 of a
> > +                * gen, which samples max_seq first.
> > +                */
> > +               smp_rmb();
> >                 max_seq =3D READ_ONCE(lrugen->max_seq);
> >                 max_gen =3D lru_gen_from_seq(max_seq);
> >                 if (old_gen =3D=3D max_gen)
> >                         goto out;
> > -
> > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > -                       /* Promote second page table access or executab=
le */
> > -                       if (refs > LRU_REFS_REFERENCED || flags & LRU_R=
EF_EXEC)
> > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FO=
RCE)) {
> > +                       if (lru_refs_is_workingset(refs) ||
> > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
> >                                 gen =3D max_gen;
> >                         /* First access only defers eviction of an old =
generation */
> >                         else if (lru_gen_is_old(lruvec, file, old_gen))
> > @@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
> >                         break;
> >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_fl=
ags));
> >
> > -       if (gen !=3D old_gen)
> > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) =
&& old_gen >=3D 0) {
> > +       if (gen !=3D old_gen) {
> > +               /*
> > +                * Gen-index reuse can fool cmpxchg(). Retry locklessly=
, accepting
> > +                * an extra reference to avoid folio_activate() latency=
.
> > +                */
> > +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)) =
{
> > +                       flags =3D LRU_REF_FORCE;
> > +                       aged =3D true;
> > +               }
> > +               lru_gen_update_size(lruvec, file, folio, old_gen, gen);
> > +       }
> > +
> > +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) =
&& gen >=3D 0) {
> >                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
> >
> >                 __update_lru_size(lruvec, lru + lru_refs_is_active(old_=
refs),
> > @@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
> >                 __update_lru_size(lruvec, lru + lru_refs_is_active(refs=
),
> >                                   folio_zonenum(folio), nr_pages);
>
> Could this leave the parent's local active count too high?
> Isolation can debit the child's active count after the refs
> 2 -> 3 CAS. If CSS_DYING is set before the stats update, the credit
> can go to the parent. On SMP, reparenting can clamp the child's
> negative local count to zero.

Thanks again for the careful review.

But hmm, I'm not sure what you mean by "too high". Maybe there is a
temporary skew of counter due to various races, but we are fine with
that, it will be consistent soon.

The key here is update is gated on gen >=3D 0, and the gen is part of
the CAS: only a folio that is actually on an MGLRU list has its
refs-based active/inactive credit already accounted will be recredit
the counter update here. An isolated folio has no lruvec to attribute
it to, so nothing will be changed.

And for reparenting, we are also following the ordering in the
document: the updater holds rcu_read_lock() over the lruvec lookup and
the counter update, and reparenting waits for a grace period, so
either the memcg is already dying and we credit the parent, or the
update lands on the child and is part of what reparenting moves
afterwards.

So the credit and the reparent move always cover the same folios and
land on the same side: there is no path where the parent is credited
for a folio it does not end up owning, and no debit that lands where
the credit did not. I don't see anything to fix here.

