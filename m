Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EBEC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1303E6B008C; Fri, 18 Sep 2026 05:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1906B0092; Fri, 18 Sep 2026 05:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F124F6B0093; Fri, 18 Sep 2026 05:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB256B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:41:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AD7E1605B1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:41:14 +0000 (UTC)
X-FDA: 85226389668.14.E1516A2
Received: from mail-ej2-f21.google.com (mail-ej2-f21.google.com [74.125.228.149])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C2151C0007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:41:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Sps41imh;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.149 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789724472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bvlc7PQn5Y10Z6hN+pRJdEeRFAR13rFud0pX61FSVmw=;
	b=j4RPgtCaYrfwXIcE/yKAvpQOb7KYYOZuvlpHAvyweYvTGfj61mOumTTnSK4Bk5cBy0IKcI
	B8oEJq/GCIgvCZOsb3LcBoq3nktsDSFMSLUQmbbf396+SMlH/pxzGWvpX/xifKaciOHUER
	WWZG7EMJEwv5L8jliDBkkxdHHlAYPJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789724472;
	b=W32c7Y5DcU0YLgS12KeBkk5eouOv0JvLOzvDaJHpMIauX6qcRecRIyCgi6F6Y65JR/F1ic
	PbDi97wC1aB5zlbV41hQndxskvKC8pRWlKGMXTXyTXhu0VCuU24IB7kQJF7puHnnmGXwiP
	PR7h94qCwiChx+if0vL/NvtPkttBa44=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Sps41imh;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.149 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej2-f21.google.com with SMTP id a640c23a62f3a-c2a1f611461so18556666b.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789724470; x=1790329270; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bvlc7PQn5Y10Z6hN+pRJdEeRFAR13rFud0pX61FSVmw=;
        b=Sps41imh3avBTfKDHwIZ45HJPe6YSWanlOEUBCV0SheGPUTBXQ7RYZrNipd2pmq8tH
         xFegYk3+k/MYp/S/uVbYNR3lSFPxGtrn8pkkj4WZJMf5IRV7VoYPeHOQ/bMd9F0E53hh
         wLW11RRiMFryM+oUFJgy3O5HmPGCotncrZwBxkrHukHvMXb+fRTltWGpXSZlam3fq9hh
         qD2dO/R8iDB5A0dS+HeI997QsFUAmVe86S5L+iWElmETvNcH9+IIH6p/gCnRthlK0p9z
         qOO8t0jQkFqNH5CHROqndh21SDciwBg667rH18Sr85AvoZUM1HKM8ZSeKUANDEOLlKdK
         qptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789724470; x=1790329270;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bvlc7PQn5Y10Z6hN+pRJdEeRFAR13rFud0pX61FSVmw=;
        b=QkHAOmbCOgGJHFxziCcdPjf0w1BcWw1uDcwfBs/2GsAn7zOCZ1c0NYOBdxuRFRymk+
         2FEsl+XbjaPtOee2ccI4PaMQnOxiyEUojEIihZ+jNVrKLREqoUjzg6RGhnLqBw9M7aXC
         O9hzMHjEG3ThzqTeBQZ1lMnm/3p6yzLq3fBvZXckgNnw3prYX7gqPYsWkwE1Vu4DLhAg
         m+H9PICy0x9j6nYwlTTIIkvSEy+FpcT1vc3k2qKhlBFWnu781XwLC34Y6k3GGZOSC56q
         Y8KkuDJgnLX7uQJ3eD5EQAr20DRcgPbgBH0ls+UiF09Yv09yD2K2c/kZMYp2izM7XGe2
         5TjQ==
X-Forwarded-Encrypted: i=1; AKwUvBxuu9c3RLPEqQAsSGMzn05+ea9u9kqMsoEw7k8FeLX0Jup5a/PDX0W+lrcwffZB3Da7gLIiNYrQtA==@kvack.org
X-Gm-Message-State: AFuF++n7sLFRuH6FpXolE1Nea2MI/5aYKsiQKvWDOM3T7qcQuTxyqZf1
	GZGyvrNB3Q06E7b1YEfCszVGHff1sx+V3LAv6mpcf6pH3842edwAZdIGMPyi2jivHJ4=
X-Gm-Gg: AYBFou34QorPKf5WmECzBsmFgdrZdw982qOy+RLFUGzpetDce4m3/hU/wO5CcVyFdEo
	FKSeRBEXf/2IQ+agwOq5c6zaEcz7GBfmcsy6+Rh8W5GXB9ArIZi6B5uuPG9+E64kdS8ohI5pL+f
	xPzkBfON/RiuR3kUTXD5pG+4c7WWrx82GrVZjinI26n9L66VfJrk3w0ADOzyPTAUoMa5PdAnVeT
	qVzndmmyHqyCXvFk7gkotpQRmb4weZLNcfDSZT25puwdDomfxog3yO3rgG4PEYfU28P8NUAGgpO
	2L457pqmZh/c5D+THmR3JKCOzTTnjp0KepspZ2UrlEON15vMBJa5hBAAXwU/s1Bq9Y4dyyPjUdf
	VWVvwu9AdBadGwp/KwBQ2/vQo01xooXSD46g9ZeZ6sylCOWv0Em2styEUjyUteXQmbUBaJBGwkA
	YlMPM26EeJM9iMkfk3PC0lLrhJJLsQB+IiLePbCtk6DRf5ISUFqF9VlZReeHk=
X-Received: by 2002:a17:906:6a13:b0:c29:97e6:284e with SMTP id a640c23a62f3a-c2a165561damr161932166b.13.1789724470414;
        Fri, 18 Sep 2026 02:41:10 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a1bbc683csm37937066b.58.2026.09.18.02.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:41:10 -0700 (PDT)
Date: Fri, 18 Sep 2026 11:41:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aq0HNe5s3zvOnM_I@tiehlicka>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqxMk6yaiFHeeAAg@linux.dev>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ssbqfs3m51j1upy4b4i7ti1bhy7gfjtp
X-Rspamd-Queue-Id: 0C2151C0007
X-HE-Tag: 1789724471-22652
X-HE-Meta: U2FsdGVkX1+paCwCZP3JLvD6XgPkGHnUbs3YRnZMvkZXqFogYLv8yPCdRcJ950LQbVc7mEeiXGyEGrJSRPWMFDQeu9RblV1JP/ZK34XANrnnQV5xYoPf/l+aUXDSNnHiR9WvydYCUm26tp6KYu9w4I3uNrCSmnvAbSd5tMPMVQnckYigtNEbRMAL/2sbSybVJGZ+npt0khojpXuyyd+aH79Etvu/OEtSWH+AFwsE2MRWZIhdZjJUU5a7f2h+kqZExZ/jyO+dotRNzuFnOre8flWGIknexhjDiEi+n6KmuJnUx9ACu+6k2xkQg1COfBk9wl+OE+hRKLr682isQ2bUXYBgp42Q8oVKr2GYlk7VWuMNGULkgDGVZZ5lRfF7koOEU9Z3tQlEC8TiSrI5R7/hCU3ZNr13uQN3Ew7HDHYlCoyaoxJCYsA/kZ1c9eCxai8awRqgo5yA/YQf4BSYjyr+2/cLpfyrjlCtac8MI/VDcYNoOd0zKEmk6V4S2jzLoFsljGPMXhN0jvELB3oB1JXEZhtFoHvc3723458l7cC83bCICuoxpUoifXMUO5+yxBKCEVNtaiyQEGQeFisakAmLNEImezQWPxU6+aofpLGsdTFfRNd7g7nCEE5x+xZZ0W40GX73GfY4XWd2X/s37JSgRIW6+kvQRoeujiSS7MXLuxP8yTjXnKk8N8BXoGTTrDrexyLHN+BFwkW8ReWFVCk8qD6fkW7jDEyyYAURBPgVDleLhVdyg3MHILNKH9KSVKr3NzFvZJPgWmy7oRoTfqyAespaifVToscUjWBUxFx1Q22dCysOpBZosqfoM36DakWvJvOFG4Mxm1R0BVl1GjO30bvYN+duLDT8fOmczvBDUj/rd/VEaJq+zI/6fQOlitHfSIiubYScbE/nBKPe7RidouWOXaBl3649sU58VLNGVWcjtYpqAN/ScW67bDk1pytgrqiQ+H6AVzpVyUtq+Be
 RDKCOb5w
 o7HZC+60gYkI0l1P4Y3BlZlFCn6+WnDqZIGQ6SWwOpApBI/fAQEjLKJBV8yBfKOx2A0C98l7auuySth5uu7DEIM4veY5eYtADpO9szzHYxdWcIF4k19z/ZKnnWzRD0ocCh7E1HaOUraq8QHW3fCPGRKYtkyQFqnaG+mv2gpxFSXls/eVEFohlBVyjcV+hrx5At04rVhd4TTjXGkNKoHJRzyN7F2ECd4pWcfHetygd1s4VTOVXqnmAAmY44pKnl2c8EHGkhJLmON/7KAPkk1Qmz6lBAsE9P7EAUEEXpZRIxm3Ji3YI1Nzk4i9wEVJlpZV5VvXMIE6HXuxjXp22Hh9GJxV5AW41tCcUpLRzqGDS6gCk2PDhjRxTLtLT+lQER+Blr0WmcZMsR2TNAIpEptgxWuOp6Vt5VuYWG5iOOm7xG+rKyBRdwwZjPb0VjQoucOsKVb2F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > The legacy cgroup v1 memory controller has already been moved out of
> > the shared implementation at the file level (mm/memcontrol-v1.c) and at
> > the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
> > per-cgroup state, however, still sits as individual members inside
> > struct mem_cgroup, guarded by #ifdefs.
> > 
> > This series isolates the deprecated implementation from the shared hot
> > structure: all v1-only members are grouped into a dedicated
> > struct mem_cgroup_v1, and every access goes through memcg->v1.X.
> > 
> > With this in place the v1 implementation is self-contained: its
> > interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
> > its eventual removal becomes a localized deletion of this struct
> > together with mm/memcontrol-v1.c, instead of unwinding
> > ifdef-scattered members across the shared header.
> 
> Sorry I don't see any benefit of this code churn. The code is already behind
> config. What exactly this code churn is giving us?

The only arguable upside is that this would make it ever so slightly
easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
I am not convinced this is sufficient to justify the churn either.
-- 
Michal Hocko
SUSE Labs

