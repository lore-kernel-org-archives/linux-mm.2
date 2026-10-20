Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9F1606A326
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=P6c8TSbI
Received: by kanga.kvack.org (Postfix)
	id A87C26B055B; Tue, 20 Oct 2026 16:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AA06B055C; Tue, 20 Oct 2026 16:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3436B055D; Tue, 20 Oct 2026 16:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB256B055B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:36:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF3F31C2FD6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:36:01 +0000 (UTC)
X-FDA: 85344161322.13.728D486
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0942D80006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:35:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P6c8TSbI;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792528560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njlJ33l5OqoDckYqSYGuylmOTQxiBjEh77NJyjCPwxM=;
	b=DISE+x0lg23tpl8jUMK3fhHa+IBsR8K9ss02gHR18wsdAav+gGrmFINtNPyCaBLSRuO5N2
	n+UlydR67S2b5qJICbTWuqs9sfxZ6O9qjQ/U1A0cKk7Zdrnk9N1DCbq3aQMsBpndJojpK6
	xK7JgKP/rlQHp4v7FUaaylJp8eDhXvA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792528560;
	b=zC8GXxzUkpd5m6yBIcsG5kEcggaXR4QoJuM4ypNKSafzrtxj/9dl1zTltuF5FSyt6X2cLo
	qSDOKd8WmjlRVRvcsmygaJ6UmW9gcAvI839cBGr5ROgjEDZqweIOmwWuy9WKQ0pn/62Obd
	xFO8HTWnfoUN9VaC4v2ER6wxOp6pQ2A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P6c8TSbI;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48c4649b35bso5534f8f.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792528558; x=1793133358; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=njlJ33l5OqoDckYqSYGuylmOTQxiBjEh77NJyjCPwxM=;
        b=P6c8TSbI/fYja7juZfL9t+nmhBMR/qsK1cRXH2EQfSKLGrCnMt0UzkQMG6HeDRHqyp
         UIkY9+b2y+q6kNFMxTZXAuPcY50R9SxZMJmSME2P6cZ/Xhb5wdHRvGb9kFcT4kHqTl5+
         7WPdKBVPVma1Qfp8YVy/wMTmG4K2tporasPKuXwgESHsM0FyOr/ZzB7RRtRD7SH+MiF9
         w7EyuuSsoxqdy7/XDPJchMb/ixNIzPkLrd7YWFkGQ0OI9xX2wvlLt9slUHVDmJ2HQP6n
         ScSSLBQCwWvdjwSUtRHCDuwPq8FWrE2E+7hq6XCrneoIZ6OdPXOSmckEolgI462ISu0N
         rNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792528558; x=1793133358;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=njlJ33l5OqoDckYqSYGuylmOTQxiBjEh77NJyjCPwxM=;
        b=yC11DEyEBOmPTA3eE8r86yJOk+NwW6LGWz/HbpSoBcIGiSEJPFFB1X7RYFnh+xUsDX
         am6jXGqVh59GeaiIGSoTlPg/Q9qrbSmIMhk9bbnpd2+59CEwpT6wN74DjHVR/OWMr7/K
         r3thG5F0lhkGQj7POFay0Ev2d/xPVR1w5KEGgatQDnf54MpYkz8k/taxRU1m3K8OzqCd
         QSBGKogDaXnWskcbsIGwiDSnOF710mPbEQRMuAaB1gXgj3uZ8FPxtXFySBxaIIPtu+in
         5S8wEx2KVApBhmPZBGuz88s8ov5SRpuzTP1kQr5CAp34wE8nwYq54PLoFxkoNWmtEhUu
         JfsA==
X-Gm-Message-State: AFq9FYIJPBikbChEoQagxMubghYm9DcSPLXzR8CU3ey2pZa1H/55mJgO
	GzZzYJpeK/4Ji3bY+XYA5jB0vw7w0bBzKMLglvS9cg/xXJqH8msYEiqnk/OPIHgVHLA=
X-Gm-Gg: AYBFou2dMBMtIUcK4z7Ev5qKuGNVvg/+m9uP3iZ40qHI4zN30SdzQY6yrRVyos1yt2o
	H/McbmTbQHmy5FIlzBEfqnFlh7XpwzUUPC94vesn4vS9J5ZIXUz7Sg9h0s2wkHyL/8Uf2mrKTgb
	M8YlByYVRrfXqdM+ZVejWY/32f+lUUU734QexCjAVtlwBzZyfluO2bCKu9ELVQka56G8LvH6Ri4
	GxGK6vtE1v5V+j1u201tf/bHCQxN12NDPC2mBJKMQKrdfHIvKe8dKhCkAlM9sZPOxFodWXyRuku
	X/qzQnEDMLfAZujUyVE67MgODA3uFoNBr3i78zbdslEiaWcFCtO9AlFTMecpcb95s/5svL7y0Zp
	0fiLbFJktX+CGDDwbzqUxidG3urqsVN6lLC0w8rp5gSb8WltYGgqoyODA4hA6Qr469+Haj2J0+R
	vlv8e19qi/vqy8gLfDHA21+lVyF+lXNnBzjcNBCPFnYz4db7IY6yYoLNABMBGcl0hkIRfF4iBVR
	CNn35VKU55VgQewZVnRfx8vO3iS3Sr+UZaUH7gryGGmWOfH5HgXtLZ9igVwi6gw1NlOjw==
X-Received: by 2002:a05:6000:4805:b0:48e:10a7:40f with SMTP id ffacd0b85a97d-48e10a70508mr19393904f8f.17.1792528558447;
        Tue, 20 Oct 2026 13:35:58 -0700 (PDT)
Received: from localhost (109-81-30-107.rct.o2.cz. [109.81.30.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828c6dsm788025f8f.24.2026.10.20.13.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:35:57 -0700 (PDT)
Date: Tue, 20 Oct 2026 22:35:56 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org,
	ljs@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atfQrKh8AiKnvTRG@tiehlicka>
References: <20261019185002.3428594-1-gourry@gourry.net>
 <atcc-91WerBlJ_Q5@tiehlicka>
 <179252633386.238494.13826191476140121288.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179252633386.238494.13826191476140121288.b4-reply@b4>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0942D80006
X-Stat-Signature: z6hoikfndrmz6a5tn51abtij1rgn4fz4
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792528559-227470
X-HE-Meta: U2FsdGVkX18rKa/eJsADhqpe6uLt09o71YuzhvyzPV833Tf65Cr561p/ozK0DdnnQWL5IUtcAfdVuMFScWb2DnVe/zei0JY5u1mEKrb7ojd5uYENLGNGNI2SzDTZRPZ/l/MZvw7sZVKSiKJcwWXxlK/gGS3OHXTZ2p6Bu/1wrGOCxkctaajZJCEFmE4R/29g1B4SHrMdt9hxqQ/Kx5PaORGMCkYJfYWogrpXF/cm1l08tvoul28pqsPIii0pZdVBLGOjf5uv8tL796GSAiFF8zivkScXPy8qqgVjAsb0SrqC3mFukA6rhWsuf0NbHLZqS7gDxytKwEJ8P1dD+ASRjObR5R5nOG6/t4emdlL7zX5XhHhfxEajWiFT+TYCvSEeO5lS9Pouzknz6dSaC1Olp554N120GNs6mFc9yR6hJOfPtQp5rfjUHn9c7glvKgpwPdcnLwgWY3YVV5bnQWxbpM9xvxswEuM6JF4wau1mA5SQHFcOKHZB3/hElhEB6aOFoq3iyjOxf6o8D1JIvqi7mxDxB6rKALOdl2obcFz8jdTgTcb0wTr3WjqNioqHljmH1c3AFKxrtbuebXrCEMHUh24/SxxhFvOlMFKfYNSVQmPiIGjWepGsVlSvWwJW0jD4h11ohr2Y+/jDoHWsi5/AWUMRvVETevfdLKVbnxIC/BebHsRZp7Dj6Khx8SfWPlDMFxkpAyIznZFwaNRno4z4Y7mQasJoAP2BS/UTdT3EGOyeHT5syv+IklXg3YWZzPafuhs1AKjFbEh/rxqru7a5dwKTvMUEocqte+a2QAtZ1vl0kvyhIZT2MOheN1c7RAcDgBYwiOza8izE+fctgYMNYmRjXHu3PfDH3wifquNLePZDfJ9Uutl+ygczHZ5Q/nEsvi39y1CoQope1S61wVt7bCt6gZymWh3tO2AmanjwsPMG0nOm3f7HBx01hD1ttvbttC1xwKRDy6Lrxmq7Cxx
 o4gAeihp
 OnLpWWPz7xrgeRLNy8LKdTlLpH9R99NhbZ12ly2x5XPbPCSGpD08YzMBhIihpghAucT/TKTlrrLy4IaPKLauUSp6htKArq0Rx2wGbs4WMmpko5q8ao2zW3FB7WaJ0YGm+YD0uuCH7x+xkCTe9DKKNXj+fD9LxusWixVvZ8+eeeHbQKhz11hZn/XgYKIKdqu5hZoO46317bB5JjG4LmamPyTMNhuywYZziX0/c6yOEeC8vHF5FgSTahn+FnpbigrcoLdoi0EPn0AvJV72VZNXthBlrdY6l0MM2mpIOCgv/7C4oNGitLORapUxK4bW+KwncG1QgjOcUimG0dHJzzF6WfsMKLE0DwK9jDnZAh+qsB7uFpFg6EPNqKSOrcunrKO//5wxo46pF45Pmylbv49Sbt/0eBGoCpTgKGKJP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 20-10-26 15:58:53, Gregory Price (Meta) wrote:
> On 2026-10-20 09:49 +0200, Michal Hocko wrote:
> > 
> > Would it make more sense to 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f11491ee9ed5..e07db9514e59 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7963,7 +7963,7 @@ int user_proactive_reclaim(char *buf,
> >  	int swappiness = -1;
> >  	char *old_buf, *start;
> >  	substring_t args[MAX_OPT_ARGS];
> > -	gfp_t gfp_mask = GFP_KERNEL;
> > +	gfp_t gfp_mask = GFP_HIGHUSER_MOVABLE;
> >  
> >  	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
> >  		return -EINVAL;
> > 
> > That would take care of try_to_free_mem_cgroup_pages too.
> 
> funny enough, try_to_free_mem_cgroup_pages does what my patch does:
> 
> struct scan_control sc = {
> 	.reclaim_idx = MAX_NR_ZONES - 1,
> 
> 
> now, whether the gfp_mask should be GFP_KERNEL, that's a different
> question i think.
> 
> (tl;dr i think my patch is still correct)

Ohh, right, I forgot that memcg reclaim always reclaims all zones.
Tweaking the mask seems more consistent but not something I will insist
on. Up to you which way to go. In any case

Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs

