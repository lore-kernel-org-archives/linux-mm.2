Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8739EC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803DA6B0093; Thu, 23 Jul 2026 09:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4666B0095; Thu, 23 Jul 2026 09:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F166B0096; Thu, 23 Jul 2026 09:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 269806B0093
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:55:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FF82C0504
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:55:38 +0000 (UTC)
X-FDA: 85020189156.12.234F101
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 744554000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:55:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="cZYy/aLf";
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784814936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdlTjNa72Apcdo/QV8cbG21bSLdkYHzKHF8zUNaq1xI=;
	b=x5xZd12r8CIqK08ay96Ke3jzyomu5WNYCYx+8n6kCGxYeM3uaVvhtlJn41vaLmSvQMdnO6
	Kck2OK1+rn4Te2v7ZZL976D62qLk2n272xvpf8skFCbUH5pPdZXExj3/kWzCc8Dy4S4ofS
	+fuvdKUaLavSTI7SSiN1h7jQTx4KK1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784814936;
	b=D5/9s+hO3TNANzzzNeiNkBw7TWa0akPZik+0fHXwgpcWjK3mjPBBV71kYpCCB6bphNSkSS
	HflJVzV62sas9GeMQI8RHXFoGCr+BuJO10r5WNCDq5dKJs35crsZGvVvNht+cp/79aZBIX
	dDAosunWuWNFsWEXtviSLgNtlRuikc8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="cZYy/aLf";
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-90004d2f7b7so9944366d6.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784814935; x=1785419735; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JdlTjNa72Apcdo/QV8cbG21bSLdkYHzKHF8zUNaq1xI=;
        b=cZYy/aLffgdaP3kU4LabHkjrpnHNpij8z60ayQP+k+vqOcu5gRux5gYOsf74YPkefI
         qLMdhyVTh8yLpUlyWtyPWyHbMEqgiqDGdt0XD28nWMIOoYA6d6MZDvIaHFDR2uWDw8Jy
         0ZfLLvBsL3cWICc2cIdA/1Tlz2yIJ4kZjK41RbwxlYLv2UpaPjljpfSHUk/ndOiuM3I5
         +mf7FIqJuG4SN+Lpo9cIGFSGMbKXQaIqKaoewJgspoTokP5bk/R/wAzCe7T5tdKCpAUH
         eU9J9NBGazOnkxhCklkpvjIRMm6Ib7d/PuOys7t4ZMe23aWWP5FtPEIzqgjZRqsuYymg
         tLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814935; x=1785419735;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JdlTjNa72Apcdo/QV8cbG21bSLdkYHzKHF8zUNaq1xI=;
        b=rYdw2FNqfcVEobGQhGIHzV8E4QzHOQfqa4pvZvMlSAjiaQ+XIMzpW7pB5wp+ksw10O
         +vewZntpNQkSoFi8e0vsx/8xDAJfQixXI8LGGBcSHc07+L2eRiv8i8JXWDOLEpYjJR0w
         oHS0BLT5R1VP2MDWVCV8tUMIJbdBLRj6675xwWH80Sv/PWH6abICFTZiS7/Wl0nZTGUW
         qESpTELS5FcCQcgB+LGst+3jUjPoog5mhOEitrP5p5wmejt5eaqPVXw6sHuj4X9wCFUh
         tjs2KL/50Yp9MiXiQB5JbDdGzV1HeoilE7hosoXf4Ol9WXmOs4RcGfgHn+e/TBtGrXi3
         BM+w==
X-Forwarded-Encrypted: i=1; AHgh+RpUvRaO/6++POHGA6+dG4HxbhfrWdtcbIaV/KXiufI7xMFoJrSyuhomvCGGvfl5f/mK32p3DPBvMw==@kvack.org
X-Gm-Message-State: AOJu0Yxq065Q5gPBYHfFinpSdmbyNxofK+ri/k7MDhlqFq7jPjKasXAj
	St4IVuzZvBUcbgC2hGFs+ULvxwu7hLKqk0covEFfc6Vs5zKVr5XzHzlSxxZ8NiKooxc=
X-Gm-Gg: AR+sD10zkJ90SkeICkEU3ERcVR+XX22P6lwZE08APc1BikFJ644sCQrhkumc53U9l+0
	gZU9owgEbZrNPqQ/NS6exNEhZBLxQFBPOE2XkMyQB5Db5MBpnU12+Aq0ZPdrw+1LnYLmA6862lt
	2BwLBe98tUcWe/EGKZDn/OnfFkYpFbv8DDC0iIUJzN2foP3anuBdPkXbEnGsw1molbRpGSG31ny
	YLBV1YndOshPO9Fon6l3GMLLQ9cKwYNWWqeVbqjBlm87aBnbiB7nMg0V0QUNE5rozKM4mywAZ7G
	QHvBYnSiXvqqMQynHOmKwXs5+DRSxhQb9hhlIbiO/e0cnc+aKCGu8HVfeAQU26WLshtsp/IpBhT
	1yPx1WVXIbxnTcWasJKeRwN8s6H2OSiqCtOeCUqWdLL2EeK9ELOj1lVRHjRjXPUewQnBIfjdQS/
	94
X-Received: by 2002:a05:6214:40d:b0:8ef:e3c9:5336 with SMTP id 6a1803df08f44-907ca356302mr35958626d6.34.1784814935519;
        Thu, 23 Jul 2026 06:55:35 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa27cfcsm45192186d6.44.2026.07.23.06.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 06:55:34 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:55:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org,
	tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
	mkoutny@suse.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <amIdU1lFxqxTI3Gc@cmpxchg.org>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
 <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 744554000C
X-Stat-Signature: 8a4ho1jmrudbrdmajh93bjuiwtoooemj
X-Rspam-User: 
X-HE-Tag: 1784814936-189656
X-HE-Meta: U2FsdGVkX1/24ZIB3yslt8nKtmVsw256sFSc9NlEYEZ4bAK5eJt3VfH86ELUkVhcxr9isecRVvpsMBppUIiHDR4bGlLAH51D/In4eMtz53aWLgNog5TjcOiv0CJS852y75lQ1ODQ6B1d4aXFVU3B0giYNH9Z8Ju47OxYkZzIKsqGxOO7ZX5xRSCgrAsGzIL82PLg3AR4Qk24W6ROGDH9Kj3ZkXQaf1ZVAMNFPAJ5fdp28foXjPPKoSyHR6kOMoHCVzkK2jHFE4jUofzlBlNOv2b8RUSOabs+L+vKTAyoIP902aeqXAdIZpcY1ZBWIO18xII3GCB8KMKwZPhyDX9qGHG1QZhBpPaVMbhX5LxEdqqzptetf4oPxrwdIPgSmgrNG17nQvFc9bd2o6BOUeVrtPKox2AruQv4/stTNc+Zn1J/yg4zEZ2U3BnjpBF89XBmQ8D5h6rC30NvI6yWJC7J0SGNGxDqHyVJntRQWgFElDObfxXIMFAM5/Y5/5NTaAFMIEvLCFGQv/iLHjygZBrpwxtE7krxgM71/ymaCerhsTUze3H0dvRb2sjuhs4POFrsJoiSqxncTgQbGyZFa142NYudC+i35hLkXJYfMEIM1CkZL0Aj5hOiJHi0Y+jLHTx8s9yO5TKSGrNdlMIvTAoLDf00vqrJyWSLECfn3MlyJdQjUsznjPfSPmzbB/fBzghSg+WKKlz1nxd2XyKpiCrYX5fBdkho+Gpxg0JVmWMRvYZb9ZUt68dj1TZZSsQsvtLS491AHQ/qGlhHHT5FhSbMjMO6ia+eUJH2gcw55iUWR5P7SSccC4OwLouUTHnwbUWz5CLJWTyjv4j3d5pxsTkvWAAxj9amH/chyHFH5Kc45lR6aA0FQ6DcrK6BZ7lv/lmGyRKDn3InmzgV2imWNFYn7+yHJjZfOq9stSzbxg4IwjSzLUhcWCA4Xd7U6jhwab3/bx0xbnsotdEBFvr4Q4w
 bykKtMbo
 Vuxkxr/xeMR8he+q+6DW/KpBhOvDBBhPZ+3iGLdnZBBd29sl53fTdbLQ1iapRtPVVsJ8QvG8almhJydnKySk+DOtNsl/UeMVFaJs2Hd57bUpXpnfgN9QUoyzdu6BKT6wIqm3Bcnh6twh89VhRy5yVSgs2HRIV+O1/mCYCRVP4h9UHfAqSSG0gpekSVyeWQ4O13b6K/AgX/cLwmcvKg2Vg6yLIn4xpP/PHJoWyA/WSzLOAVXpTXHMFK4JzA1QlcFojXd59HlfeRqDZCYVSxvme8MWZ7PcaZBDC8iqgtU3O6KsD/LqJIRUJulrJEwhXnayZQXyU22LWOSpIX76nB9vyU7mNrdQjhxwqx8fnEuVq1KRAvKg19WbGF1A0CtkdPTBWyhCa+yKnuNgkOu+H+RBTvWtBuAkjXG5cC503q0XYx8/ATIDiOsRsVz4YZgdiP1iVgUzRRztUbwqbHlXOdhQzU4Ue/LcpeI8Pa3mwnVrLxmg3THx2/8DNMYlaJaOZb4pbR6pw+lhIq+y0YsIcLMDmR/YjH81LwGt9LN/4g4oSzRXALSDXzaJ5D2PdOzXbQNzHTk/W5nxt9JFc6C8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:52:18PM -0700, Yosry Ahmed wrote:
> On Wed, Jul 22, 2026 at 7:27 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> > > @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct *w)
> > >                       goto resched;
> > >               }
> > >
> > > -             ret = shrink_memcg(memcg);
> > > +             ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> > >               /* drop the extra reference */
> > >               mem_cgroup_put(memcg);
> > >
> > > @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
> > >       objcg = get_obj_cgroup_from_folio(folio);
> > >       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > >               memcg = get_mem_cgroup_from_objcg(objcg);
> > > -             if (shrink_memcg(memcg)) {
> > > +             if (shrink_memcg(memcg, 1)) {
> >
> > Why 64 for the global limit but only 1 for the cgroup limit? That
> > seems arbitrary in multiple ways.
> 
> I suggested that we keep the writeback here without batching and do
> that change separately, mainly out of abundance of caution as
> writeback is done synchronously here so the extra latency could be
> problematic. I think we probably want to measure the performance
> impact of that separately.
> 
> That being said, this path is potentially too expensive anyway due to
> the flush, but I would rather we do some basic measurements before
> batching here.
> 
> What do you think?

It's not an unknown, right? We know this works for direct reclaimers,
cgroup limit reclaim e.g., and what the latency implications are.

Because of how reclaim works, we also know it'll call zswap_store() in
batches of SWAP_CLUSTER_MAX. If we don't batch here, they're likely to
each call shrink_memcg() once we're at the limit - while still risking
rejections due to compressibility differences.

My worry is that if we start with an inconsistency, we'll be stuck
with it for a long time.

I'd rather start with the clean, consistent version. Dial it back only
if we have data to justfiy the complication that we can put into a
comment and the changelog that outlines why exactly it's different.

