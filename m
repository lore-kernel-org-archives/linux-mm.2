Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1762C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 19:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A246B0088; Fri, 18 Sep 2026 15:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3A46B008A; Fri, 18 Sep 2026 15:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AAF26B008C; Fri, 18 Sep 2026 15:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E92D6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:14:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E24A2807C7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:14:17 +0000 (UTC)
X-FDA: 85227833754.05.F83CC43
Received: from outbound.ms.icloud.com (ms-2001c-snip4-7.eps.apple.com [57.103.73.158])
	by imf02.hostedemail.com (Postfix) with ESMTP id DD89180003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:14:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Js38DULw;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf02.hostedemail.com: domain of bfguo@icloud.com designates 57.103.73.158 as permitted sender) smtp.mailfrom=bfguo@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789758855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWqcj/x6eWYWbBAL8kl/ymZLuNhjh0BA6RJ6N290BcI=;
	b=Idgecq80bs70auU7ic2GPs5uIMrth7aVYJwMm0Z8A+hNIoFF/m3RSG8v7K6s+8B4htJ/xR
	47+xeiAVkSt8N8JxtEcJQEuvNxibngGVCDohG73OJUX9F9skO1Liju2WYm6PQsdOlmcMne
	PtHTQKiu+8bXEqs3rxbq0glORDVFcE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789758855;
	b=IE9/rZSK4QpGywZGaN5WDg3fIn2Mhi4Cr2VnwSdLX/jHFxJJn3ZGVGCRrYyuaLv8Uu0Pgz
	iLXlOaZKkabwQKfkHBWAVj2VQW5OoVoem5SsWskGSipUd2+F0JpvTBl42g6O5RCPWi1riT
	YT2noayFpc6HS70jWhNQiqQ8rwuomnQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Js38DULw;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf02.hostedemail.com: domain of bfguo@icloud.com designates 57.103.73.158 as permitted sender) smtp.mailfrom=bfguo@icloud.com
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-2 (Postfix) with ESMTPS id C4116180014C;
	Fri, 18 Sep 2026 19:14:10 +0000 (UTC)
X-ICL-RepId: 01a0b5f0-c68c-78d1-94b1-522a552173d3
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhOAEMGWQdeCEwCQwZYClBcHA4PUQxHH3kRUAFYHlZeWhdeTVEPDxlaFFwYU0VRH1RYQQ4KWgtQUR1fAgoERwRbF0YDU0VfAxcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOEUhKeQlALUc7ai18XwMIbTB7MX0qcSp8N34tfEB6KAJOGQxKHVJWWxNVF0YJ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789758854; x=1792350854; bh=zWqcj/x6eWYWbBAL8kl/ymZLuNhjh0BA6RJ6N290BcI=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=Js38DULwrukcCRSoJMjJBXBKxGgeLw2rwtAxJYs0TLF9Na00R3xPywULitqV1dAH6hG73N0k72FAgaJYgFGsncbGSuI+RvhOpYRwQkXiAVgMMOpHOdQlVOztqBTerafBroDU8kvXsEmNphsptgJ+pzkNyabexOnwe+ZD6e7L4YLz5fgqY/IdYhHXb9/WRAvXdij3RUOxy2/y+rxW4YZI7eKLrKr9d1DWPx6Jov63+R8hxYJlKjDaYrtiWuq8lEcBXxoDywAtPAQmDVWE7TD2R2E67wRd+Vv7bdt6o/X1RDOo0Sh59RxkNOeAeFyJZdoEPdOwH9KEu0ELDRD4CB98yA==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-2 (Postfix) with ESMTPSA id A4764180017D;
	Fri, 18 Sep 2026 19:14:04 +0000 (UTC)
Date: Sat, 19 Sep 2026 03:14:00 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
Message-ID: <aq2JdwFuKSUO24c_@BINGFANGGUO-MC0>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
 <aq2AUmRISe3Nmfft@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq2AUmRISe3Nmfft@linux.dev>
X-Proofpoint-GUID: lM56lfooGkGx8VqIDgjmfZIh95NUhIJw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI3NyBTYWx0ZWRfXw7vRgnkvLACs
 zCN9QZxssgzuh/otDe5TsLrV1j+RR+aXz5C/AlQGc+eBg5RVjrPSMWEOK8+Ktae5tgqd4ywDH37
 W1YHLn5DonaEl1PJUiwPi0qyCXkvDnZBYCS7vPCPlKvGbix4+EL4Jy9tmR/AkkEpRwu71GJj1uJ
 GySFC9LJT1u4Bd2pSs1l2WE/B7et7oFkkyQBwB9v3kS0GyGtneOtuXFFQPZZFzoF1g0bwnMAaf9
 vu1v03YJQgLBtqgV1yfI0DjFTFwYIkMfv3lDparQW2tyimjwCquGrccSIgdRocjpmjLCUKAQ7vf
 cc6ZTS3g8VVJ+HZwtNNYKNSPCZhYsX4kQXnGggh/c1bjHrS58b5VvyUcW2hUaY=
X-Proofpoint-ORIG-GUID: lM56lfooGkGx8VqIDgjmfZIh95NUhIJw
X-Authority-Info-Out: v=2.4 cv=fPA0HJae c=1 sm=1 tr=0 ts=6aad8d85
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=N-mGDGxclJDxHLb_ER0A:9 a=CjuIK1q_8ugA:10
X-JNJ: AAAAAAAB9jBc8wj8EuzGQJhAEc7+fSE+eTWbzq4/kImKkp555YMA7pXJyMEHsIEiaBAwrrL+zdncb89SvcQeTok9aX6ho0IGdn+BHJZ1jnZht8gj8eoiOGEkjJbIelVreiusVq8TGn9y4rZfSTg5bzCJ/zbUxDY/ssVTTCdhqho3xGGq0tb0ff1cOyDyPcWk3WdbFGa99CdjxY0XYmSGBn6oMh7C+BxOgXGIah0DhmTy8DYkt2ZKOAfTKG9Ua9VnXs2aH1gcT0qtD9NKMl7Ow8yBfxQWOdz4G4ofFlxJ5v04EkV82npleTwRn0pws8OYxNqDFUNoENuCjnwRTClH5nPHmRwlaCwSX3OGKY6in60vYO/A5bY1ds7z2Y8Zl55Gr6coQ+qaDw/00G6DMvp/Y4/r/GdplsjtHf6Wu93dVBs5ig758oOwgdq4UMnQDuVcvxRvQYfcu5DsEJK9WOxQtqn97pORomY38HCambcTn6xPcr54CnodGRrtCVWfKPZJjS2dJMLUPbqo2JHcB1feHWE34JftOkDsJ7dpZy00tXanoSyjrHl61wUw5OucAJzA65n6xv2/LnMObSP02FmEFXViXx+Owxe2J4B0zugC1Uw8RRcnaunfjIs0udGXt+DjtlUN45Oq3xr3LnO7GjsKxLpctoRnlzI1xf3vqpee2G1MCa+mJApmEhDLscvv1GopeqiTwN5UyIeeAxNDhYVcfXoFaasn/tgtUZrhLhv/bVVUTzmu5e5QG/q1hwGNXtAPPoxY/1NnUKuRJ3sCPgwSyF2Kq0aBpSz+TfXbCBqKBzoagZTxYlI++3iIu4H8MZshwBlydK+aw2/ixHJgJj6aY1neadshe+JaLBzjmELoLC7V8ie8HXo7ZizDNrymDRSgaog4qcgkz+aRnssRTEd4/gsxeHoyrJjTI3Ot6k6WBYXpI7Ieef01WnCiSDxFnvl6RbIwSVA8RT0U5WvQYlKStse
 wlv2TAXE
 zOCZHjy9lcQkkQdAzKTFad0qOh39Wr8GtgaAtvcOFupjc7jAI2LzMrd0pMLyIMJCK+3sLoI7hkCuTReukfp9OZl0AMPtjEs9LQvg4kDhc9m3PBI8HLJQASYVv9KCTr3OYbG9ispm4a2t9mXvhLWk3v6FhlwOx/scAXsFu3+AGgKrdprn8VEldZmmbFkCbCJHN1wddOO62TUV7gjKjKtnEhNxEzRnIzw39eP5pAIIKG2ytEl64aNp65RJnSy4fCtLoHes8E/e5gObzX+TxdBU2Z5ynVpyQ7xyCBauoDZpwf+lmO+aSetFqx8emV/YqkZWq10gacwOX386B8M4eyVeZ3r5srv+aVpz8z/+ZzTdcQ2fMsGqI704PjO9fB1IGPtcxGuKYgLeWHTaLX5bSsKrCClS9EOEAwCmX46lHUSZcElhVgEJFioQDPGWd1K3n207FZ/mci6eeYrzWsfD9YA==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD89180003
X-Stat-Signature: xgrbjppkjgc5m6mr6h59yb6wm7p78zei
X-HE-Tag: 1789758855-857428
X-HE-Meta: U2FsdGVkX1+nE5C+AmMbsufSFiPRWCRODuxO1GZymVPo9iMj+6/2DoziNk/DoXGIF7WvTlw8Is8aIFl7qZLO5erJ7X3pSweoXVVEDVDOuSnZffDI7vTP7FnAzFwashZ7pfTx5oyr/fd7D/DGl9j7mL0IA9OVNzx9NEleE8hDTYmQl+vpVbfy2xa7P5XfFy35AK+7UvEcOeB7Wb+j41XD3KUI2Ew630HgTlRXOHx3AMPQf22DNeXNvXeoFrgJHW7OaqmQWspWcNJBTxBnuz2QqMgDrJAbDRHj3Cq+shVJXlWqdK9MpmPULay5DOf/qFlr+Q/sYW+eachRxlbZQl60zKmhjqF8+A1QX2EYwkQ6ekJF5ge2BYKyN1uFTl2BaEWqx+vrhAmQPJOoTqBzfKKlUZxZ8qzawQKs2MSvji8iUX1LI4yeJmj9l4vAbOThEToYTQwZRLvgflJC3vU1rn2eyFRukQC0z4fNAL5nD8kS1Ukhx8Mks+f3r5PUpgp0a0sgEN66DPLPqFEEdFqQPocgUwkpDG2AUXElSpxi/CzFobWVv/gF/KzBIVvKWwb1Jikt4+L0/e9gK4/X+jhzxOzPu6PNjQX8WDl/f4Iz+t6J4J8rw//2CTb8t6ezF0/37ZR0aJAjrOBDxzRvE/gsDDtjsCNhH8C4bBZ/6xV+VDSrCHePv44cZNvWO09ivxkLTfL81nheS0Y66l346i41RjT/uvWt1Oc768WdejbwWx3MQ6xFR/sY2/aMhP/km/Hb3Du9fLfDuF6Vh2vKpx2sx+EUtRX8P+d4K+P6jpCCZKAYmGDrdHoxQgcYWi0neuaaZJJ1DiHPM1J5cR99GFf3KXBohAm/i4okU9RTKxpDPq39NuWuXR9pH/JoqLzrOc31298oaPRRx398PdfqEzufNaUXIOO4BuaJviwrBGZjIFFICD+SV3t1/nQoZLVbBrNXjrFavUzLJMClwRTWo4yUA7+
 d99GVQv2
 IIrwcwDFtBUXgCQodXhGqAQQl/CQfAwInkeUp95t+xtlLksDuRvlSFUJ3rIC3brgEkvk8yx5AF7GI15VBOTruV6QJmWGkcMUN9wyECly9zOrhHm0EOp6DrrhG1UR6XNCqUAK6tUyvSdoFXzAtQfM9wuvpYp3nMC51cAk/ffYj/O5L0zb7p5k1KdE9V9oMWTMyUUuBF27UmbOVvGutwDMNlh+Diz0D2Pj8Eoj2QSMeDeFTDaVlqghkMqzf34eQPjBQ7XsZrT9WoChfXYm3V+0IUaPJyBgVss6ieTmezBYcCy/Vf8GOhTplX6Db2L9zDriKw9Chch+fqEQxoLjwk3eTzmHTRAMXiydrap56IZW6zeUykyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:19:08AM +0800, Shakeel Butt wrote:
> On Fri, Sep 18, 2026 at 05:18:43PM +0800, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > diff --git a/mm/workingset.c b/mm/workingset.c
> > index 8412f4840ae35..7e4fbc5a786d6 100644
> > --- a/mm/workingset.c
> > +++ b/mm/workingset.c
> > @@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
> >  	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
> >  
> >  	memcg = mem_cgroup_from_private_id(memcg_id);
> > +	if (!memcg)
> > +		return false;
> 
> You can not return here without initializing *lruvec as it might be used in the
> caller. Also mem_cgroup_lruvec() can handle null memcg and will substitute with
> root_mem_cgroup.
> 

Oops. Thanks! Nice catch!

I made a mistake here and it managed to work so I didn't notice
it...

In the previous patch I left here unchanged and used the root.
But then it struck me that maybe it is more consistent to make
the classical LRU and MGLRU behave similarly by skipping the
recency check for both of them.

I'd like to hear about your suggestions:  Whether to simply
remove the if statement and use the root only for MGLRU? Or to
use the root and keep the test speculative for both the two?

Thanks
Bingfang

> > +
> >  	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
> >  
> >  	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
> > @@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
> >  	 * configurations instead.
> >  	 */
> >  	eviction_memcg = mem_cgroup_from_private_id(memcgid);
> > -	if (!mem_cgroup_tryget(eviction_memcg))
> > +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
> >  		eviction_memcg = NULL;
> >  	rcu_read_unlock();
> >  
> > 
> > -- 
> > 2.43.7
> > 
> > 

