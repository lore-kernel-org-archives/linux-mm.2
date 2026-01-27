Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72697D2FEDE
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 20:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67816B0005; Tue, 27 Jan 2026 15:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F126B0089; Tue, 27 Jan 2026 15:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20E26B008A; Tue, 27 Jan 2026 15:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90D4F6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:24:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37F6B1A036C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:24:43 +0000 (UTC)
X-FDA: 84378872046.15.D0BB47F
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50BD6100006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:24:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BnzKrfkH;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769545480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5LxVPVBoG+UMcNxikNez0XKmCy+fMwCwEoTyhq3Vgg=;
	b=r9ZcpnlJtem4+FWQRkeSkzhOsb30NFK/zMleia/3ozNtaRZ8YLpVt+Vm5rBeVx5yhQX015
	NvUQHRT9hIkNRAmbBJ2ZdZxVL6JtUVeKBhty8mtz24EmZYcuFqFNPkLrzGuTCA0f2y8OrD
	fBtbchiLdg+AfDG4uDCsOh/3j42hYOE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BnzKrfkH;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769545480; a=rsa-sha256;
	cv=none;
	b=Pjfk6x5cefQ5XXa7QkqD/o+CPFGtN8Ywxjjsj/bm7rsc3Oi4NELdICcQmQDRIZIYRiot8g
	ydQQnZuyd08GXb9C6OzZ+y2uP8eheagNtpSvhouu+3yoMPrOjaleD8sYfo3UP+pQQa1F35
	qWj/qTOsZWzB7gOrZyECmAnrFznQluE=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c5386f1c9fso856211085a.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769545479; x=1770150279; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5LxVPVBoG+UMcNxikNez0XKmCy+fMwCwEoTyhq3Vgg=;
        b=BnzKrfkHVL0rl2Nmmw7IrEQ3HzXj4cqc9xUh1Q0EV+YpGf1Pair0vmaTTdzrAqEVyu
         2ftgyL+5c3nbAl6o8a97TrhsmFcAL38qTM4YUnHHS2ad64MZGHx5+EAMDCErEm06yhaj
         qClI4OFmjp1zIpWhqPulp9KEhEUdkEBuOowapdGm3SFAIUkhf+e6tUbEuwnwp+yxAky7
         nx7w8KK+HttJwL/xu0+z8bctM/xbbXnCzv2o5EkijnlYSp5AriGE0NpaBCTGQnKIP0fl
         cXB7MpPMhcCjgO70dB4Q8fnOyd6hR0e1v7QamnZ257D/lcJuVp5hra0FzhZ9Azk/y6Pj
         qZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769545479; x=1770150279;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5LxVPVBoG+UMcNxikNez0XKmCy+fMwCwEoTyhq3Vgg=;
        b=wsYRLwXl5FyZJ3koRJzKpPbiUh2Rd5a18iLhaykMqlY1fQbxQRqyVaxWQm9dS8eMgu
         URFFWw/w2uCyN6LIxM8TPBD6AJBYbTqaL/lLQ0mRmXwWZSkbS8HwUHFsOyLV7sK3fmui
         c6trs5yL8ndOUJ/+80CR0xPHiv10XL/DgnGKDEtXNgGMb/sNDonRCCMNt31DGzzDQcvM
         M9/aYNx/uu3YRDaHbLUasqU+mXJCt7jIUEyxnS1aF2Qqo2/RotInb3n3mIhOeShDjOr7
         GBkb3RIZ6QEurXyFpQ08kMvcbhNFWCX8XJt4GWTiftPo2Q8UalN9gHQdh4EUlgKlsrAK
         FZXA==
X-Forwarded-Encrypted: i=1; AJvYcCUHVtvQSc70veKd1NRA1V6FHFaXfu51vL3/Bzg5+J9iEXHSe73j66EJCbh078in65Vp6/AXyvEQyQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/GnlUzArv+k6PC7UZbBMQUjjuFgl0wXfW/gt5CnIxYM3yl4pe
	ERhVTrNPGKulEaC0rHPQFTR7m/r6QZJF7mUREg5W1zlghA7aHHSNR+tGrQ2mmo2kmFE=
X-Gm-Gg: AZuq6aKHA4KXdAETemuShjIpFIlvGWrgpejxoAmroexaS9/IEu7woG5j670aKpEIkyc
	aeLEBmJnORSEKMUHvFwynJRsikLoCGubO+uw9DGlNt44IfQHcOdrOCqqahAO+8qcxbMhfsn87rb
	Sv3hod5cXhsEgsrYcm/6hndOh0mAPHjx1xXpxSl6xkX/FQTzDZROJNPbGA/vNYcYWxtgLQTepx4
	fZeotgYe0uANPagcf3W+mtW2SSL57NmYotEAvYvW4RDEJTCTJ+6nvTzLCT2VZTUyJKKuC90l/tz
	NYUj1VbS92BtR5spOlF8GmBcLQJAamx8wjPi1hSTKMBX68h3PXnLC7P7xqwYLEHjv84wWu86Phc
	6G+dUQ2SBWGBdpKoRgrmjKeiWlnMuXRTMa4Gfmi4ltZAWc2feDyqr7B3T8eCnKou28n+asqu7YZ
	wyQmfZu5U3AjYdtjuZl8m4fZlVwZbOxDNFOCYPzZtuAgJ3MNfg/xqijghxryn8BwCsboHmrcJIj
	H0vyBTv
X-Received: by 2002:a05:620a:404f:b0:8b2:edc8:13d0 with SMTP id af79cd13be357-8c70b85bc20mr389358885a.17.1769545479306;
        Tue, 27 Jan 2026 12:24:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d29aa2sm41365985a.35.2026.01.27.12.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 12:24:38 -0800 (PST)
Date: Tue, 27 Jan 2026 15:24:36 -0500
From: Gregory Price <gourry@gourry.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, bingjiao@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
 <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 50BD6100006
X-Stat-Signature: hyw4efqhmw7yga4m5nh7yqsmspyoexw8
X-Rspam-User: 
X-HE-Tag: 1769545480-384386
X-HE-Meta: U2FsdGVkX19Z0K4Fnv77hBV4DxjeqJLtg5sPTIdRXSAkr1OJqUf5/HeJeSOMLmDmX92jC7+h9HglSuCV5mG/0bMC/KxrxstcF+HiJF1A6Fm34W4SHRK/GkzZjFDwAd22A1e3sPTRpwd9vLNEhEZVOCktdUEeWyg29SffaP+Tp13QR3r/IFM3gRj6ApMPyP0N17yXq/iorIiQi+8o8qWQupYJ5MbhKfDV25SQmTW42qUIxjhD8Ldag8G9/FYOW9aEpcmDG4/J+SBfBeGMGFrI1PEDrMFqTJ5mHBuRqlMrCjEuEFcubDhcNVz8OX1StBScSm2eZlcWZZ5AvslAglcSS3l7qhFPk+gCZrCWpU5FdH6PgKlKd4wsXXDoLCgsTsliMOxpNzDVRRreoraGnsn7ZtJzU6dzMOmxNSrbOBjkE21WLhl+KcMJfNnMN+SFYY2dxNXnqkRkogwfA2Z2TxoecPbbRXACoXiJDRkKetYADvarhQiiNDVXGTZ9sDb68v3DgGK67/xtlBEjKXSFrtMTsF8FSbHZppDd9s6eUx8kSGr3B0c5T83r9YQp6n64p79UZPObK8TiIleA1WCd2N+gkZ8Thf2rNHqQ+FnlKIsfG6oB4afa4o4YrVz6Kxr1M4Ddi2kmsMjZ5APsBGt56U1JM9mU5LJZPVWs59A9LvUQDYkczlv+XUqiPmYbvVJj0DZAcsjjMJlF5VmmCWaZGeROEO7Djsyu6vnGi00bvrN9CT49CIBUVKa2XpKsZuk5raWunJRjtVCjYKaxx8zyjXf/SMq8ros/pzygSkkTEbhvokJgHgmspx9FtHMCmfPK4/MqsgfSoWCmS3tZunzsZrf2J+xVTOj5vcqXIBYXRWm07f1AShDIaNrtcWkUZqg++G/BwYyabIbmQkzr+2FL01nnCIvkLXYhBgjjV22/tUznuPqqNA95epG0DnGUJsmSPnx7/LRhh7aUUV4VOVWUTw9
 4vgpR8G9
 Yt+yazEwykMBqPdse4chTpw3yJNMeAlkFUQ/4nvMUh2JgPwnsf5hoCkx7yxAB8ocZMRSlDX1pPIADSOfX4wGVxurZYBqrGwQXeIiVCMcRDYg+Nw1WwYZUnxQpUBFOXzoB9QJ5btHhVZhmp+THL7eKdYMAAz8aKjKTdtasQ72gLvDH9OSaElTgJJ1Y/PpLgK68ZXzQtbqx+tmt1X91JuhHS2RU5dJ1O9RliYLXIQ1USC3PEiE5mRSmgjX6VbBIr/xr2G2klah6oZKN65oO+YCUZZ+nrcDmN6ERSo0Qr2zEIvVIobeDiVw5g7byzq8wvS9n5c35/u89RSUyiKbtdKKtQyWvPZ6AF4OizW7ZdMRh0WM5eNlBGl2yKHA62l5W7GnkRFFDnK/zqQH2m3PqipPUkUrbYXIKpv2Cec9A9PobJfg/ON03lYG8SwEedVi2K10XGKdtuWE8sj4iyBJBXpo+gfxYF2rmkTbYC9xIayYWnMPMHGX5ZdUSevY9TH38FUen6dSB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 10:55:02PM +0900, Akinobu Mita wrote:
> 2026年1月10日(土) 1:08 Gregory Price <gourry@gourry.net>:
> >
> > > +     for_each_node_mask(nid, allowed_mask) {
> > > +             int z;
> > > +             struct zone *zone;
> > > +             struct pglist_data *pgdat = NODE_DATA(nid);
> > > +
> > > +             for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
> > > +                     if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
> > > +                                             ZONE_MOVABLE, 0))
> >
> > Why does this only check zone movable?
> 
> Here, zone_watermark_ok() checks the free memory for all zones from 0 to
> MAX_NR_ZONES - 1.
> There is no strong reason to pass ZONE_MOVABLE as the highest_zoneidx
> argument every time zone_watermark_ok() is called; I can change it if an
> appropriate value is found.
> In v1, highest_zoneidx was "sc ? sc->reclaim_idx : MAX_NR_ZONES - 1"
> 
> > Also, would this also limit pressure-signal to invoke reclaim when
> > there is still swap space available?  Should demotion not be a pressure
> > source for triggering harder reclaim?
> 
> Since can_reclaim_anon_pages() checks whether there is free space on the swap
> device before checking with can_demote(), I think the negative impact of this
> change will be small. However, since I have not been able to confirm the
> behavior when a swap device is available, I would like to correctly understand
> the impact.

Something else is going on here

See demote_folio_list and alloc_demote_folio

static unsigned int demote_folio_list(struct list_head *demote_folios,
                                      struct pglist_data *pgdat,
                                      struct mem_cgroup *memcg)
{
        struct migration_target_control mtc = {
                 */
                .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
                        __GFP_NOMEMALLOC | GFP_NOWAIT,
        };
}

static struct folio *alloc_demote_folio(struct folio *src,
                unsigned long private)
{
	/* Only attempt to demote to the preferred node */
        mtc->nmask = NULL;
        mtc->gfp_mask |= __GFP_THISNODE;
        dst = alloc_migration_target(src, (unsigned long)mtc);
        if (dst)
                return dst;

	/* Now attempt to demote to any node in the lower tier */
        mtc->gfp_mask &= ~__GFP_THISNODE;
        mtc->nmask = allowed_mask;
        return alloc_migration_target(src, (unsigned long)mtc);
}


/*
* %__GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd reclaim.
*/


You basically shouldn't be hitting any reclaim behavior at all, and if
the target nodes are actually under various watermarks, you should be
getting allocation failures and quick-outs from the demotion logic.

i.e. you should be seeing OOM happen

When I dug in far enough I found this:

static struct folio *alloc_demote_folio(struct folio *src,
                unsigned long private)
{
...
        dst = alloc_migration_target(src, (unsigned long)mtc);
}

struct folio *alloc_migration_target(struct folio *src, unsigned long private)
{
        
...
        if (folio_test_hugetlb(src)) {
                struct hstate *h = folio_hstate(src);

                gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
                return alloc_hugetlb_folio_nodemask(h, nid, ...)
	}
}

static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
{
        gfp_t modified_mask = htlb_alloc_mask(h);

        /* Some callers might want to enforce node */
        modified_mask |= (gfp_mask & __GFP_THISNODE);

        modified_mask |= (gfp_mask & __GFP_NOWARN);

        return modified_mask;
}

/* Movability of hugepages depends on migration support. */
static inline gfp_t htlb_alloc_mask(struct hstate *h)
{
        gfp_t gfp = __GFP_COMP | __GFP_NOWARN;

        gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;

        return gfp;
}

#define GFP_USER        (__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
#define GFP_HIGHUSER    (GFP_USER | __GFP_HIGHMEM)
#define GFP_HIGHUSER_MOVABLE    (GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)


If we try to move a hugepage, we start including __GFP_RECLAIM again -
regardless of whether HIGHUSER_MOVABLE or HIGHUSER is used.


Any chance you are using hugetlb on this system?  This looks like a
clear bug, but it may not be what you're experiencing.

~Gregory

