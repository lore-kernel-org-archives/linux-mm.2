Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E55606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hqC31KWI
Received: by kanga.kvack.org (Postfix)
	id C0B536B05B4; Mon, 23 Nov 2026 20:52:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC996B05B5; Mon, 23 Nov 2026 20:52:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83396B05B6; Mon, 23 Nov 2026 20:52:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3046B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:52:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1AC8C0AB1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:52:39 +0000 (UTC)
X-FDA: 85468338438.30.26CE897
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id D38CF40006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:52:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hqC31KWI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795485158;
	b=fVn6zUlXIH0GjsKgCU03TUMZCYyzSf/ll9pc7E6gD//MW3NWOHqKdfV2HU79bQ5WkhLzZu
	fmyrw22Hq8A5IG+T9hDgo+HN2WVMnVNHSCJcV7UqpLTMCHAGRDx3PXNujAkPJZfpmcqSiq
	yRU+sm4QH9KjTBvpymIAh2DnZJo9K2U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795485158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYy52i1VlUDrudHoFBdDu5SiNfto95Bn3ifLTlKRy3g=;
	b=0otHsWZV5pt3aXRJ2JZe63ch5OwitXW52CwR+baiSVb6pxqRrT4or9GNwKHPg6KEw0qTMV
	uvU+0FBjRBujBaUTYQuJQtd8ql81tyg+CkCiZnm1JBdmN1kPSPu4I1X1mFJ1YZx17aSxMI
	CR4rqzcoK4I+umHxT+4pciCxs+9N60g=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hqC31KWI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb606491faso21903365e9.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:52:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795485156; cv=none;
        d=google.com; s=arc-20260327;
        b=r139CTVLwAi5hsAX/NQ0G2UX+SANOpD//1QF/7yFt41LcbZtYhrr8tS5UJ/4o1GtPK
         27bfa0S9FMSdkVxO1ejpUCgtdp/mBRUNftKSnv5oVSoybYY5I12NPM44zDejCjruJTrn
         PXkskJ36PdZfy9fsNKP6iGDeY6t+Om/M5/v40HiJ0+C9VZtz5pfBfI6ultIDxn+p/Gsa
         bqIXNYeiE54ONB0Ny6xL8yE4fSAd2JC4zv4h4G0kofNEy6riNlp2DbVdpoX89o2dwfoK
         S6uCzvxW3gVByXf/xNffXe/YQFqMHSywePW4EPLhPc5yNJRf2sO6nYoTMREL1I3qltTx
         mcPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XYy52i1VlUDrudHoFBdDu5SiNfto95Bn3ifLTlKRy3g=;
        fh=BreUFRwPfo8in1YgxdNM3CEmyWeZ42beJhCpvJu1Uhg=;
        b=Ng4+51oXHXc9BNO6OklkEhDjAuU/lPDebKXO0A5XB3V6U0GcBtfMOAKCJtD96BgAYG
         6LUQoqlwBQlpox/4Qyh1f/JT092mit4Hhlbk84Ehxo7FkBHb4PoP1FQyoFVp9PHresOb
         Vr3A3BpFuUgfOMDJgfjvHmX35XCgy82jHoPCSnnOeWX60EJN8uENz/nViZeh0QXQhe02
         stHeHHLU5PrE1xemhO9mDe6OyNGUzQXkPtn2R94ZtRE5hY8HYIPey5b2UofpEaNqW+vc
         NKnGLmkuaW8lrxJElq9C2VPivcQFFyTCFKIqUynnspknD1vxdIlRZ4MbjxrAu22jh6Ad
         RPhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795485156; x=1796089956; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XYy52i1VlUDrudHoFBdDu5SiNfto95Bn3ifLTlKRy3g=;
        b=hqC31KWI7wHj9u05U+HhKO6/SKsel73uMgQ0e2vFPpKQPSpqrzxIEXRS5JCXiHSxkT
         zp/0cgBpKqdAlvMULtJx89Q2P9iGpzsNTAsvA/8HBrK43Xx5JduyivvENoLF8a5tEo7U
         GqQ983LiLLZH8DlHQEUKiJE8ORW6QFp0xe215FeNj9y+qcRa/zE5u2Gsc0ifOPGUA2is
         l8XEmIIFgXwYrAapE7/RIppdJk2bi75+Q+NTjiyLfuHcdhhDivYbaEeGw1fuu66hUkRz
         jKCrndFetHsS6xSUOvI1wiZqKo61XnL4458/mDlgy2KUBmfhEz+7brjT8cr45jvUv5a9
         jSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795485156; x=1796089956;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XYy52i1VlUDrudHoFBdDu5SiNfto95Bn3ifLTlKRy3g=;
        b=2apoORFI5EMHujdVXgg9eJkhcZBkRdn9RwUbHApp/48JtI9sFro6j0mY6kps6WTsZg
         0CQ2vDLpwy9Luczv5jKwd+dDyiWJ01CIZ2V15RqNitSgGJmjSaKBo+SSFRpLZ5csMi/4
         0m0y4JzYVXoxzBh/itPuDs5dhIO4rpKaDU+NDGd/9K2QLBO/YaS86IsfL+C5trzUcSkV
         /QtJPecZJJanAz18SzQFLB4ATM2oC04qIR6QwXGcN8VsxH4JbUUSqcALUnOuTN/qncqV
         x9znx4nY2v25eNdqrwXnim+DpgKgAVkoR4jxYwSg1h2QDVvybJi1zhzfwu2DrTHWXrfY
         +hJA==
X-Gm-Message-State: APuU4Z9ukG0TvKc1QNZCmIBwhw20SSC4EYr/ULjTTADzYP3Wpm14N/uh
	rvoCUjSrq20Q6wwBOAR0QHeXqMUHLVlZ8YIOqrh2Xt+DANcB82I0oPX1BoqMSJKendB0/8MwXsc
	FIyH9su9tL3XtPCwYyJxrXJ9NzftIMIU=
X-Gm-Gg: AZFdTZdGfbrRUH5yGIMgjhbnkuhjFU5fLTWKPHuE99LEtAaiQgXp6/4zF2SQr+AKlzF
	zt535EdeVTWsd16EU7nGq2Bp5y0+uM0hNtfE5TwqOIkOkXE/1xQHUFyhxnlYrbTwjixnirUEu8e
	7GloVVTi5QNHwRITQ74x8PFTBHBl2EaNMgyxKLwFR3H3r/DU5dXgCxPnlZGzhEeL3LNyJlcTXRD
	K7jfQJMwQHFightTKH875qMfP7KlfpX373soBXYnJ74Y6mvNA7iv1Cg8NbbZSbFtMhMXZC+7zI9
	/0+sMNpLXSEvUa+xkSmTx5SQ2d0j2ce1W1qMD7/SOulTO26UnzVCAzOWTB60XsqylgVK32Rygup
	2Jy28XVNPL2khHlAUC9tD3Cocn2H7kjGZHnfJqoKOeOEGLljC2a55ErYtdHy5Rq38/Q51t6fTOn
	wL+E7a1l1umQmo2R6coX2gE68fkCrFR4iItw3N44h1DYmods5OcL+U
X-Received: by 2002:a05:600c:64c8:b0:4bb:68e5:b952 with SMTP id
 5b1f17b1804b1-4bb88819be1mr252564985e9.16.1795485155450; Mon, 23 Nov 2026
 17:52:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com> <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
 <CAMgjq7CEdWvv8m9GtWMG=8OFy+1Sehx3HBJt2D=9hntwvfbf6w@mail.gmail.com>
 <CAN_Opa8L3Ygfu5o7Y8ZD9GTmiEygCXpq2TzAJtwgQChdyb2dSQ@mail.gmail.com> <awQTdkOPG_bKkY1a@KASONG-MC4>
In-Reply-To: <awQTdkOPG_bKkY1a@KASONG-MC4>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 24 Nov 2026 09:52:23 +0800
X-Gm-Features: Aa3M54rNVRedVBKWrSc3NKkfSlK46ArucsaQHzq7jpyNkszROWpY1teS5JMIwgY
Message-ID: <CAN_Opa-TgMWWMjjzuwnVcC3XEBW4FV2eFx2gpiMYvReLhhc=xw@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Kairui Song <ryncsn@gmail.com>
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
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: k5ympg78qff4tbgty43pr5j5bx3aboq3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D38CF40006
X-Rspam-User:
X-HE-Tag: 1795485157-630057
X-HE-Meta: U2FsdGVkX1+Nu9OVJFDLFZ2pgF3vvBKpKQWn8no2tfu64JkHJb6SoQ42ahNOkWwOYHbnJMVW7svFq9hANrVHuUCeyk9kWZOETQRhs/0BrFH5Dxk9x+XZu2zb5AAXzcUAgHu94Oe12gAf1fPtgKSXD+zoy7oQe3NbIQK/IT/96ZmiwJfnbiTkGrccNb63N5vdMtXtb+7hPU1dZXK4jxVOGbacnw/qScM9gNkHXimHKJNY9JPm3I2j8LzDzikqnZRShzq8lO8kzXr5P30LAeG7vUxb/OQhmc3kGxLVLA4Ej4/idDy13u2VzjphgXKijvYUEOIrn1RjTIhlO9gSVca9sDjSqtOrQE1qmzJSm7e4VpPriO6AVctU0NZuyKl4giceJWzUf5fTE1v5b5H55rJMtGGpqFZGP1U/h2dW5ryOYQt0EXRGz8hoLTwpfqqgNr2gY3LvJQkDOSTpREDHb5o76bjsbsjlbCgIQpcbBfROP10MmsvqAqfisUWVu78kG2IZd6CiqFRzUNo3hHn/wHQiyc0Lp1gn/WXKiTSbZ2lPmYrvuH9bmpFORVlA8ztPmnW3r4fLRW7jlYaEVPiD01Kn3xSREsJLtSOl3pTeL2msZRb1UCPaoiPusKNu7AtSGCh231Sb6omE2RmzsHtr0jSV8O7cm7E/0HTg0QJKcbhIsl2454vnluE0Eiw/Ke1Jpsym6K60+OTW9dYUJ7OgDVTbsCtldTXIlw94kDaXmVwI6Nu8MPVrC3shFReoJMaUzL359HMi+biGVgaeUTBVn0qjQwv2xfSf87krKooeNdIkrxvC3N9U69RlABp8yZ7OQeK4Te1/+XPADTsT6mb817k9kZ8+K/Yzx0i4lgGYoxXxlPR1t6RVzwlMJnS52qxFkaQGCHGF1qjV8jSXfFDd3st+OdJoJsDMEgP26cQ3LDOwxiCQ48p2cXAp2OGxWS5gW4TccVMuMcNzpcERIbdsoRZ
 fptnKtwe
 lj7+OWhqBVN9DIyTErpgEUsvSVoKbEWgZDDyv1R9TketT1znOZZReem/zHHcY/KXXfjj9DAnqs6vLZxmd4MO0rXsFrH2ouMqXxupWGc82czh83OZc6PDM/fsc6mUro/5ZLyMCbLquql1jk+xzxzgK6bBA2pk9dIsaJA38PVF5mfBWI/nWof4rlyyFAZi5M9tSiu0C350Zl+UEPeRiSsYoYhkSHhi6FEFK1Cc5U270FQis1r3yldZ12ATojsJkyL9MqnvRh3D6cyFw/PfNxJW6zMY4Quty+IMi9YsPku4R5e395RG1JMI51x/B1wssN5JYDi0Q6GHcE2u0tvztkKZxBLL6CzK3J8ak5pVunJHQs8POeb767TLpWr3eXUHyfvznZUAiKDzfC3RmnzLBlwkycPhIVhoDIjHmX2o15/bCoH2KRDAcfrq0EHfCyeuQqkEMcbEI38MuS/ORruAP09dQCyfD4igcxhsMQfSWaKcA+zbYA0W1e7OZzfAkQtmdEAnVsjW6fN2RyFSxUEog4FlV6Q6Tq6yfx2fifzhVIINKFgkpxRtv3dxQ9o+2h4e+Wg59/bmCExG3Nhivtix2rMffMkQnxkIoFDv20EsbdDPaTdbbeseJLENAIspZONOqkBOCpanwizlbhoedQ7IcA9WuUrVusC49pGmwQsrQvZQgWLbEGlRaQ4zKsJjkneW+6pRf/O8Zu+oOIxvJjxLVh+lp7FF+7MNQPo+Y+RjqKoD58VF/YCCqr372T18YGtaykt1qM34BPsvJbibk/aWUqeCz39uN2sFMRMvxgHUIW83ON2cWp2qQ8a6btzjM1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:49=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Nov 23, 2026 at 09:43:12AM +0800, KunWu Chan wrote:
> > On Sun, Nov 22, 2026 at 11:33=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > On Fri, Nov 20, 2026 at 5:42=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.=
com> wrote:
> > > >
> > > > On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
> > > > <devnull+kasong.tencent.com@kernel.org> wrote:
> > > > >
> > > > > From: Kairui Song <kasong@tencent.com>
> > > > >
> > > > > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > > > > concurrent aging from corrupting the size counters.  This is no
> > > > > longer needed: the per-generation counters are atomic, and the
> > > > > active/inactive ABI counters are updated per folio and linearized=
 by
> > > > > the CAS on the folio flags, so concurrent aging can no longer cor=
rupt
> > > > > them.  The same argument is what lets folio_reset_lru_refs() upda=
te
> > > > > the counters without the lruvec lock.
> > > > >
> > > > > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the R=
CU
> > > > > read lock around the lruvec lookup, and drop the spinlock entirel=
y.
> > > > >
> > > > > Without the lock, aging can advance max_seq while a promotion is =
in
> > > > > flight.  Generations are indexed by seq % MAX_NR_GENS, so the fol=
io
> > > > > flags can return to the value read earlier and the cmpxchg succee=
ds
> > > > > with a target gen computed from a stale max_seq.  Recheck max_seq=
 after
> > > > > a gen-changing cmpxchg: if it moved, account the committed update=
 and
> > > > > retry with LRU_REF_FORCE, which promotes the folio to the newest =
gen.
> > > > > The retry may count the access twice, which is acceptable and avo=
ids
> > > > > folio_activate(), whose LRU lock causes latency jitter.  smp_rmb(=
)
> > > > > orders the flags read, including the one returned by a failed
> > > > > cmpxchg(), before the max_seq read.
> > > > >
> > > > > Also simplify the post-CAS accounting guards: gen is only assigne=
d
> > > > > non-negative values after the old_gen < 0 early exit, so gen !=3D=
 old_gen
> > > > > implies gen >=3D 0, and lru_gen_update_size() needs no explicit g=
uard.
> > > > > The active/inactive ABI update keeps its gen >=3D 0 check because=
 an
> > > > > off-LRU folio has no lruvec to update.
> > > > >
> > > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > > ---
> > > > >  include/linux/mm_inline.h | 10 +++++-----
> > > > >  include/linux/mmzone.h    |  3 ++-
> > > > >  mm/vmscan.c               | 51 +++++++++++++++++++++++++++++----=
--------------
> > > > >  3 files changed, 39 insertions(+), 25 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.=
h
> > > > > index 77f514143266..2c6cbd0df686 100644
> > > > > --- a/include/linux/mm_inline.h
> > > > > +++ b/include/linux/mm_inline.h
> > > > > @@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lru=
vec *lruvec, int type, int gen)
> > > > >                gen =3D=3D lru_gen_from_seq(min_seq + 1);
> > > > >  }
> > > > >
> > > > > -static inline void lru_gen_update_size(struct lruvec *lruvec, st=
ruct folio *folio,
> > > > > -                                      int old_gen, int new_gen)
> > > > > +static inline void lru_gen_update_size(struct lruvec *lruvec, in=
t type,
> > > > > +                                      struct folio *folio, int o=
ld_gen, int new_gen)
> > > > >  {
> > > > > -       int type =3D folio_is_file_lru(folio);
> > > > >         int zone =3D folio_zonenum(folio);
> > > > >         int delta =3D folio_nr_pages(folio);
> > > > >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > > > @@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct=
 lruvec *lruvec, struct folio *foli
> > > > >         /* use the refs from the atomic snapshot to avoid raced u=
pdate */
> > > > >         refs =3D lru_get_refs_flags(flags);
> > > > >
> > > > > -       lru_gen_update_size(lruvec, folio, -1, gen);
> > > > > +       lru_gen_update_size(lruvec, type, folio, -1, gen);
> > > > >         if (lru_refs_is_active(refs))
> > > > >                 lru +=3D LRU_ACTIVE;
> > > > >         __update_lru_size(lruvec, lru, zone, delta);
> > > > > @@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct l=
ruvec *lruvec, struct folio *folio,
> > > > >         unsigned long flags;
> > > > >         unsigned int refs;
> > > > >         int gen;
> > > > > +       int type =3D folio_is_file_lru(folio);
> > > > >         int zone =3D folio_zonenum(folio);
> > > > >         int delta =3D folio_nr_pages(folio);
> > > > >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INAC=
TIVE_FILE;
> > > > > @@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct l=
ruvec *lruvec, struct folio *folio,
> > > > >         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_=
NR_GENS)
> > > > >                 folio_set_active(folio);
> > > > >
> > > > > -       lru_gen_update_size(lruvec, folio, gen, -1);
> > > > > +       lru_gen_update_size(lruvec, type, folio, gen, -1);
> > > > >         if (lru_refs_is_active(refs))
> > > > >                 lru +=3D LRU_ACTIVE;
> > > > >         __update_lru_size(lruvec, lru, zone, -delta);
> > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > index 2680e15b6de9..235fb04f8d78 100644
> > > > > --- a/include/linux/mmzone.h
> > > > > +++ b/include/linux/mmzone.h
> > > > > @@ -540,9 +540,10 @@ enum lruvec_flags {
> > > > >  #define LRU_TIER_MIN           0U
> > > > >  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
> > > > >
> > > > > -/* Access source flags for folio_inc_lru_refs() */
> > > > > +/* Flags for folio_inc_lru_refs() */
> > > > >  #define LRU_REF_MAPPED         0x1U
> > > > >  #define LRU_REF_EXEC           0x2U
> > > > > +#define LRU_REF_FORCE          0x4U
> > > > >
> > > > >  #define LRU_REFS_REFERENCED    0x1
> > > > >  #define LRU_REFS_WORKINGSET    0x2
> > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > index 78a1b4de7076..4576a7a369e3 100644
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > > @@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio=
, unsigned int flags)
> > > > >         long nr_pages =3D folio_nr_pages(folio);
> > > > >         struct lru_gen_folio *lrugen;
> > > > >         struct lruvec *lruvec =3D NULL;
> > > > > +       bool aged =3D false;
> > > > >
> > > > > +retry:
> > > > >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > > > >         do {
> > > > >                 new_flags =3D old_flags;
> > > > >                 old_gen =3D lru_get_gen_flags(old_flags);
> > > > >                 old_refs =3D lru_get_refs_flags(old_flags);
> > > > > -               file =3D folio_flags_is_file_lru(&old_flags);
> > > > >                 refs =3D old_refs + 1;
> > > > >                 gen =3D old_gen;
> > > > > +               file =3D folio_flags_is_file_lru(&old_flags);
> > > > >                 if (old_gen < 0)
> > > > >                         goto out;
> > > > > -               /*
> > > > > -                * Lock the lruvec if the folio is on-list. We ar=
e already
> > > > > -                * doing lazy promotion so in theory we don't nee=
d this,
> > > > > -                * but for now, concurrent aging would still corr=
upt the
> > > > > -                * size counters.  This is a temporary limitation=
 and
> > > > > -                * will be lifted very soon, so the lock here is =
not a
> > > > > -                * performance concern.
> > > > > -                */
> > > > >                 if (!lruvec) {
> > > > > -                       lruvec =3D lruvec_live_lock_irq(folio_lru=
vec(folio));
> > > > > +                       lruvec =3D folio_lruvec_live_get(folio);
> > > > >                         lrugen =3D &lruvec->lrugen;
> > > > >                 }
> > > > > +               /*
> > > > > +                * Read the flags before max_seq, paired with the=
 store of a
> > > > > +                * gen, which samples max_seq first.
> > > > > +                */
> > > > > +               smp_rmb();
> > > > >                 max_seq =3D READ_ONCE(lrugen->max_seq);
> > > > >                 max_gen =3D lru_gen_from_seq(max_seq);
> > > > >                 if (old_gen =3D=3D max_gen)
> > > > >                         goto out;
> > > > > -
> > > > > -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > > > > -                       /* Promote second page table access or ex=
ecutable */
> > > > > -                       if (refs > LRU_REFS_REFERENCED || flags &=
 LRU_REF_EXEC)
> > > > > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_=
REF_FORCE)) {
> > > > > +                       if (lru_refs_is_workingset(refs) ||
> > > > > +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE=
))
> > > > >                                 gen =3D max_gen;
> > > > >                         /* First access only defers eviction of a=
n old generation */
> > > > >                         else if (lru_gen_is_old(lruvec, file, old=
_gen))
> > > > > @@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio,=
 unsigned int flags)
> > > > >                         break;
> > > > >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, =
new_flags));
> > > > >
> > > > > -       if (gen !=3D old_gen)
> > > > > -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> > > > > -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(=
refs) && old_gen >=3D 0) {
> > > > > +       if (gen !=3D old_gen) {
> > > > > +               /*
> > > > > +                * Gen-index reuse can fool cmpxchg(). Retry lock=
lessly, accepting
> > > > > +                * an extra reference to avoid folio_activate() l=
atency.
> > > > > +                */
> > > > > +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_=
seq)) {
> > > > > +                       flags =3D LRU_REF_FORCE;
> > > > > +                       aged =3D true;
> > > > > +               }
> > > > > +               lru_gen_update_size(lruvec, file, folio, old_gen,=
 gen);
> > > > > +       }
> > > > > +
> > > > > +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(=
refs) && gen >=3D 0) {
> > > > >                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
> > > > >
> > > > >                 __update_lru_size(lruvec, lru + lru_refs_is_activ=
e(old_refs),
> > > > > @@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio,=
 unsigned int flags)
> > > > >                 __update_lru_size(lruvec, lru + lru_refs_is_activ=
e(refs),
> > > > >                                   folio_zonenum(folio), nr_pages)=
;
> > > >
> > > > Could this leave the parent's local active count too high?
> > > > Isolation can debit the child's active count after the refs
> > > > 2 -> 3 CAS. If CSS_DYING is set before the stats update, the credit
> > > > can go to the parent. On SMP, reparenting can clamp the child's
> > > > negative local count to zero.
> > >
> > > Thanks again for the careful review.
> > >
> > > But hmm, I'm not sure what you mean by "too high". Maybe there is a
> > > temporary skew of counter due to various races, but we are fine with
> > > that, it will be consistent soon.
> > >
> > > The key here is update is gated on gen >=3D 0, and the gen is part of
> > > the CAS: only a folio that is actually on an MGLRU list has its
> > > refs-based active/inactive credit already accounted will be recredit
> > > the counter update here. An isolated folio has no lruvec to attribute
> > > it to, so nothing will be changed.
> > >
> > > And for reparenting, we are also following the ordering in the
> > > document: the updater holds rcu_read_lock() over the lruvec lookup an=
d
> > > the counter update, and reparenting waits for a grace period, so
> > > either the memcg is already dying and we credit the parent, or the
> > > update lands on the child and is part of what reparenting moves
> > > afterwards.
> > >
> > > So the credit and the reparent move always cover the same folios and
> > > land on the same side: there is no path where the parent is credited
> > > for a folio it does not end up owning, and no debit that lands where
> > > the credit did not. I don't see anything to fix here.
> >
> > Thanks for explaining, Kairui. I had isolation after the CAS in
> > mind, before the stats path rechecks CSS_DYING. I'm happy to leave
> > that for a follow-up.
>
> Hi Kunwu, thanks for review!
>
> I thought again about this, and, there seems to be a corner case I didn't
> notice, sorry I missed that. The reparenting used the clamped value, so
> if the child's counter goes nagative due to temporary race, we will
> indeed lost that part, and this should fix that, I'll include this as
> a stand alone patch with your reported by:
>
> (Usually we won't hit this unless the memcg have only a few folios left
>  and raced with repanrting, and I think using clamped value for
>  reparenting is correct on its own)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..3f551e2e3206 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const str=
uct lruvec *lruvec,
>         return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
>  }
>
> -unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +static long __lruvec_page_state_local(const struct lruvec *lruvec,
>                                       enum node_stat_item idx)
>  {
>         const struct mem_cgroup_per_node *pn;
> -       long x;
>         int i;
>
>         if (mem_cgroup_disabled())
> @@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct l=
ruvec *lruvec,
>                 return 0;
>
>         pn =3D container_of_const(lruvec, struct mem_cgroup_per_node, lru=
vec);
> -       x =3D READ_ONCE(pn->lruvec_stats->state_local[i]);
> +       return READ_ONCE(pn->lruvec_stats->state_local[i]);
> +}
> +
> +unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
> +                                     enum node_stat_item idx)
> +{
> +       long x =3D __lruvec_page_state_local(lruvec, idx);
> +
>  #ifdef CONFIG_SMP
>         if (x < 0)
>                 x =3D 0;
> @@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgr=
oup *memcg,
>
>         for_each_node(nid) {
>                 struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, NODE_D=
ATA(nid));
> -               unsigned long value =3D lruvec_page_state_local(lruvec, i=
dx);
> +               /* Reparent the raw value: the clamp drops the child's de=
bit. */
> +               long value =3D __lruvec_page_state_local(lruvec, idx);
>
>                 __mod_memcg_lruvec_state(memcg, nid, idx, -value);
>                 __mod_memcg_lruvec_state(parent, nid, idx, value);
>
> >
> > Here's my tag for 16/17, also sent in the 15/17 thread.
> >
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
>
> Thanks, will be glad if you can help look at the updated v6 later too :D

Thanks for the fix, Kairui! I've had a look at v6 and will
follow up there.

