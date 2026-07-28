Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF84C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 07:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470FB6B007B; Tue, 28 Jul 2026 03:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421496B0088; Tue, 28 Jul 2026 03:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA146B008A; Tue, 28 Jul 2026 03:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7E46B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:18:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7027EA02C4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:18:27 +0000 (UTC)
X-FDA: 85037332254.09.338411A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 69D3F40007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:18:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EMEyEX5A;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785223105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmmSvrlxWx0zbydU4JmOLEEoNStv6+OLm9+6rxzaV9g=;
	b=hxDHBjFIRCrgiqNqnPDFNW+EXLThyZElWourhoAPLk3hR6EmBHDuXvcEMSfuJvIPmEB4ZB
	ZsLa9d7xRQ2Ns8KiUxrC/O0Kva5+AbYbEVt3ad8EMwTt31NMdib1GE3CXtGrlSb4B/Ni0y
	RoTR1knAoou85sh51HO5kgk/Tl19bZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785223105;
	b=aVcxzE2asa3JplpM2li8NusFMnN8pbMCKlZYk8W73oO6Zgz5VgYJWUTVBpVEl9m2fSCzSx
	us20ym7GAtq+TyTDsAu/R6mi/4Tthuawbv5+2GYHOi23lzSFf+0s2pAwKY+vHJKEAZrUB+
	dpioytERlgrmBx8lvOFRizTT8ST5e7E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EMEyEX5A;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so3075625e9.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785223104; x=1785827904; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zmmSvrlxWx0zbydU4JmOLEEoNStv6+OLm9+6rxzaV9g=;
        b=EMEyEX5Ad4RUzkwJ2mcnW/QzpPJkcZCsXsHbvalgECFRUqT1f8kUAi6cWpIRnGdqMI
         0qqoapombkmsk8yRLI5vpXpMspnvtsrTNDbGVmjhQ30UsgHtdoPkZfgFS1s28jZN1K6i
         3yNoUXCgzSPVJJNuY6CrHpQYycPT+RduyPJCPjt4Pzb14nBcGC/z6jKRSLGSe4K4A8VL
         FfsMDNWYzpQFQdo3NSJAfrgdn3+gzjdZyUP68caGsI9skXbY9W3/IWWakSTxNxe6ZtA+
         SFvEa/pS1+j6em3ZUydl7oRvV6/vvEuYUZlPBSoXzU+M6RSVLK7Lv8P70V2yus5ikIA6
         0ReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785223104; x=1785827904;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zmmSvrlxWx0zbydU4JmOLEEoNStv6+OLm9+6rxzaV9g=;
        b=mpcVBUqjg7lUj9EWEzmwmkBV89FI2LADE8Elg26h0ijyqDreT24c1+YIenyIk6nK82
         F3CrTMzChS5Tf0+uFbfClbSidlVo+KXC7+QqhAGetrJODu1onTOpFT18NX//VwnATzJa
         uX7/0fkZgARupDL7dPm8nOGOL+R+6EAW4+mFlZ0Oi1XPlSF8oI4bcEYkfVyvB/C4Nh8u
         d8+OJsFf08bv/1DKAGIBBTvGs6elb+NTaGvDLCt7PD0Pu/cZHYJwTP6BIMG3scrowiiR
         wx1JxeGWnoRM1qS5xsZA7y2t8pA2exgYyeQ5jgi8CCIbqwy4BEgoIISQ48UR3DXW/4bu
         M5Gw==
X-Forwarded-Encrypted: i=1; AHgh+RoGKKE029AcDZ5QZsOV+dQchSkxCCl7yU+EBbYjHQ6ZFmGpedGVhiUNV3GfFJnwyQ0m6F4MEzi4kw==@kvack.org
X-Gm-Message-State: AOJu0YyYqE6JRxAVR03Dbc7USmrLICTVqu+RsDDoIQdb4fhDAuJ18u2T
	AAWIDKAXfXqcukaIllInMeD6za1JWrBF1pkUMqYHHUnC6XM+Ho4RsRRTHeMqDUcWjkY=
X-Gm-Gg: AR+sD11fL1Lgau/EJbHvATGmeBbaXNbXBQpoNFhAKwBkDAlc5VxvWs4pZXYbv4tB9x4
	H5AktAq8ffjN7ocKcj6hCrBOjE5TRJjJ3dOSzsrWhXMKMN4obLZE0kiSXOhz//P4TNbnxqsJBgm
	P1mqK2yd6UZzkBF248VriQfzcFRzQXOkr+YnHx2pB8mCZyxkAO7xHPA6c7SZivNo5yBehKsIWcR
	eUM/WAY0uo4K5YxJTzXtHFjwUBbvgRYYRrBGoam7Vu8Cp0UcoxDESMD2c/coKlFiW+U1gm67cr/
	P1rjyPjcv4OIV1++aVshATKtnFhFZjbi3Bn6cLroS/gkUAwtiutkFFJCnLQ/L4uucAro28Dvulm
	6Pgee895fzp2WKAT9jfaSTwMbaa3sdNkt6IyWw/qz1G5VNRkEdWtoRQPIIN2RyG4tuBbimV5gce
	ygAiTLpG1RTFML+pgyFeXb
X-Received: by 2002:a05:600c:5291:b0:495:6193:c6c0 with SMTP id 5b1f17b1804b1-496c658f6cdmr10777075e9.18.1785223103682;
        Tue, 28 Jul 2026 00:18:23 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bfd1a60sm284262325e9.2.2026.07.28.00.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 00:18:23 -0700 (PDT)
Date: Tue, 28 Jul 2026 09:18:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Barry Song <baohua@kernel.org>
Cc: Ridong <ridong.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
Message-ID: <amhXvAdmDxX71uxd@tiehlicka>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev>
 <amdC_-OvG1ZUjmot@tiehlicka>
 <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 69D3F40007
X-Stat-Signature: auquxq4a5396c6d8yec5amaahzz5m3mz
X-Rspam-User: 
X-HE-Tag: 1785223105-336688
X-HE-Meta: U2FsdGVkX1/2aqxRt5JvgEx4OPPPR6P80tY+ijDfaNg7gOGBSKD4xAZw3Kk4BH83wrC/zgk355FLZYn6+rTS05zUFsELCUGEggj7i6g3RjpYtBCWWNIGlCI4eQd5gXYJV3jkgvO7WU9sJ5cSU61XhIoh2PNsjLpRqdq3KFbf1z0xB7EfaoNDqKmgok+DWKZ+YtTMsdjIkCZrdAM1VTMnNBVDJhs6ZvL0+cKsc44oEsB+VPAFNvzv2QdyiN7QYd9CjUBsBa9/DcqrQBssa64gSEanT5zHOyRWWSLeEFDvp/ksEbHFqh96xLOigl2asNyItoIl95NtQLn/tcArTSkAarLIGhQ+XZHwYLD3BR2kx6/HGyDiYBFG0NPTxpoj3xuGlLYOlPb1Lq2IydBHCEf9YIkwkjHk+Umx1OG5pEFIWLF+GVXV4lGD4PWu487MbDLO/KhDZpHApsdPZdFln0uxmCRcO6b7HgPkvNK93KkbIvrh4psLFnjFC2k2+rzPOPatSXwJSK+rM7THgI2AWAjtXEqDOPEqPBe9KeDUuBqjscJV7FTuwcZv6EftCYlsc/kP3cD1m+H9hEMDTJmbTtkN9f8iNodCKYo1zJMlqzi0jT5TBwlvWCQGxus3x37m61cKfH4+Z6ShQMtEdvkWjLWhP6Ry6/KT8D1tbYWJUIVN8pgErrOw3lcLSdrwDsbypYubw68n0kCBEbbpKp74WdKWOoiCVG2pNbRTM2m2vnO1j2CdDC9aIg2+qjlykgSATLL9VDSM9LPP5OvNvB1iTxP9+GsCzNKvQi1f/GJAQz0GVcrB2YdzDQKM0rGLWnnXtBPFEshuFkOeA9s2lkb4oUY74dLDfAfuXJiOKf5hbRcA42PWbsQd7ExDXrcLaoU5ApEEDw9kpCsV562fVINA44CVM+0aPz4krRgzL2u9ANoWijI1xNCZ1UpVwWmUEQV1G0MIPC0L2ioYJu2iqCotioF
 ertitJxi
 8JMAaRejYUiC0gZTDBBZcotBYS/ayS1vYGs8o1II8cwo6b9t6zjgMVhVnUVobeHYOTfNdOTdUawWZcklE/u5C74s9ASg8JmoXBJcFjVwtL5nYlSYSPe2pu9RzrBamfuSwiY1Eo61KO5vVSgvzGODeGXoyXTuIWqDf+BEfh60elf5R99YJajZ+zQ4WXPUfnr1TmxmZHzJ1JGCZi9f0qw+koxdQH64F882ZWzEnqvslSDmw+we6z2Ci/WmO7rItZ+l2OGn33wSmmDulATPqIka7R0gn4Lr+rvNjOx3kdyCyQpsB41MZGKW703cOEfOFyqbyTf5MtZW3DpqZmzQJH8FSiEI77n2XZDwktw/noqqGU6jVsx5MFz/ZAyXUnKtyZ52CG8QLx+0b0GcE8qyl2fC4GEQHGaNI1fXgXOAZ5/ujUDYm+pI25Ts4tUCp6JI892wWXScYv3bZeoXZC15Ll2rtRMEn3mbmP+/kIVjoaRvwjoaG2Ej83Oqyo7H6BjkjLoCaSIAOwR3bLVlRE0u+DymTu/+Wmgj99hSSFnl7uyfeJbdc9quhEkL6jrdRbbRFGuLini8ZPRQPT7LY2QiBT/Yo0OVFu8WGvVtAOMbk5e999QQsSd0d4MsTa58jh5C+qQfdhhy7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-07-26 06:35:20, Barry Song wrote:
> On Mon, Jul 27, 2026 at 7:37 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 24-07-26 11:34:32, Ridong wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > >
> > > As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
> > > the reclaim logic is expected to reclaim anonymous pages exclusively.
> > > However, due to the current ordering of checks in get_scan_count(),
> > > file pages may still be evicted if can_reclaim_anon_pages() returns
> > > false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
> > >
> > > Reproducer in a cgroup holding 64M of file cache, with no swap configured:
> > >
> > >   Before (file cache is wrongly evicted):
> > >     # cat memory.stat
> > >     anon 196608
> > >     file 67178496
> > >     pgscan_proactive 0
> > >     # echo "64M swappiness=max" > memory.reclaim
> > >     # cat memory.stat
> > >     anon 208896
> > >     file 4096                 <- page cache evicted
> > >     pgsteal_proactive 16400
> > >     pgscan_proactive 16400
> > >
> > >   After (file cache is left intact):
> > >     # cat memory.stat
> > >     anon 200704
> > >     file 67178496
> > >     pgscan_proactive 0
> > >     # echo "64M swappiness=max" > memory.reclaim
> > >     -bash: echo: write error: Resource temporarily unavailable
> > >     # cat memory.stat
> > >     anon 208896
> > >     file 67178496             <- page cache untouched
> > >     pgsteal_proactive 0
> > >     pgscan_proactive 0
> > >
> > > Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
> > > anonymous pages are reclaimable, before falling back to file reclaim.
> > >
> > > [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/
> > >
> > > Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
> > > Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > > Reviewed-by: Muchun Song <muchun.song@linux.dev>
> > > Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > > ---
> > >  mm/vmscan.c | 24 +++++++++++++++++-------
> > >  1 file changed, 17 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 35c3bb15ae96..2c689682b952 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -2501,6 +2501,23 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> > >       enum scan_balance scan_balance;
> > >       enum lru_list lru;
> > >
> > > +     /*
> > > +      * Proactive reclaim initiated by userspace for anonymous memory only.
> > > +      * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
> > > +      * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
> > > +      * no swap), bail out instead of falling back to evicting file pages,
> > > +      * which would violate the anon-only semantics.
> > > +      */
> > > +     if (swappiness == SWAPPINESS_ANON_ONLY) {
> > > +             WARN_ON_ONCE(!sc->proactive);
> > > +             if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> > > +                     memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> > > +                     return;
> > > +             }
> > > +             scan_balance = SCAN_ANON;
> > > +             goto out;
> >
> > Rather than warning the code would be easier to understand
> > (SWAPPINESS_ANON_ONLY implying sc->proactive is very subtle assumption
> > that might change in the future) I would go with and explicit check.
> >
> > Looking at how the code is structured currently doesn't the following
> > express the intention slightly better?
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35c3bb15ae96..4fd38e3f1b05 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2503,6 +2503,10 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> >
> >         /* If we have no swap space, do not bother scanning anon folios. */
> >         if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> > +               if (swappiness == SWAPPINESS_ANON_ONLY && sc->proactive) {
> > +                       memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> > +                       return;
> > +               }
> >                 scan_balance = SCAN_FILE;
> 
> The question is whether we should allow falling back to SCAN_FILE
> when swappiness == SWAPPINESS_ANON_ONLY and !sc->proactive, if 201 is
> ever allowed for non-proactive reclaim in the future. I guess not,
> since SWAPPINESS_ANON_ONLY literally means reclaiming anonymous
> memory only?

If we follow swappiness==0 then yes we should fallback if we are close
to system OOM. Now arguably SWAPPINESS_ANON_ONLY is a wierd global
policy and it is quite possible this will not be ever allowed. My
argument was not to prepare the existing code for that. I just meant to
structure the code in a way that it current assumptions are more
explicit.

-- 
Michal Hocko
SUSE Labs

