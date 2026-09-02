Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89171C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7D96B00DF; Wed,  2 Sep 2026 12:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859AB6B00E0; Wed,  2 Sep 2026 12:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F176B00E1; Wed,  2 Sep 2026 12:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B966B00DF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:56:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBF06402AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:56:42 +0000 (UTC)
X-FDA: 85169426244.27.2D21517
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23612180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:56:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKqNVbLg;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788368201;
	b=T0NBSMG4m3m64Ei8Lz6krwgMBqqAbtBZyZ/gTOUv8VwaksGk0sY0+gCOaRnebCJ9zbn2iF
	Ib0k+1qajcvl4bxxvOVK0HsIUUifJo2B0yBFEc/wg63o6IyBKPJP839WLkDPxtKl/DemGR
	VK3FtEsuthO9S5EVSQ0dmzvXNChHTO4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKqNVbLg;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6sBaIYAa3U9oX3VIO6revwOec3nxbZ/xfycN1MdD2c=;
	b=lieWaBDdmq7DJ1G2xXtBjKyllVMyc6Rymx40CLFZQSP0CvQ4Sj8OArGVaLJk3M40+dXc5G
	++db4zexs320InX8MIbMMOXnXHhWaVXfypjy7Uh1U0MACr2kB/gqVyRq/T6nFIBJpi6wfA
	12XXZhdLLYkJY2ygVxEiW8tYBX65V3k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DC0D600C8;
	Wed,  2 Sep 2026 16:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EEF1F000E9;
	Wed,  2 Sep 2026 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788368200;
	bh=x6sBaIYAa3U9oX3VIO6revwOec3nxbZ/xfycN1MdD2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MKqNVbLgm9d6fWuLrTOmlaf5WEIUdJuPnmJ/pFNmfrLeKi6NKR4NYFRjDhSiP1rXs
	 trnVnnbfCdO22x5YCoY3TX/jEDuC2O6EMFNqduMg5Tag0DaC0Y5KfKG3h3HBQbp3NO
	 KVnHLHi0P2v50WgNwQAArBmcZtOi1IQ+sR0N0j0HEvMf+dF/IMZFMNPntNgz0w5B27
	 heUuYyt7IMaxt4ca2unBoKsxOVa9BqDPr7WF8HdzlY97/nWaC+e3mejlPjDcppipi3
	 cqZBK9cwWdDlgvLxDWEWmGRiYNzytisrOzi1YQClAkBLuuaMp5MTaSDh81EOimJim7
	 fFhB025RNCwVA==
Date: Wed, 2 Sep 2026 16:56:38 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>, 
	Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, 
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org, quic_pkondeti@quicinc.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Zach O'Keefe <zokeefe@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <aphU_tBPl0TegeHd@google.com>
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aphSYFTd12oia8K2@google.com>
X-Rspam-User: 
X-Stat-Signature: hbo7156wnry6gqbcxahhhxq8hxip75sa
X-Rspamd-Queue-Id: 23612180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788368200-963030
X-HE-Meta: U2FsdGVkX1+213vkbxtprh1arfVk2YshELL1ytJhvAummnYCEFPaSnwn+wnwOpWhWlBgxu175SHv91xeNAjBVK6g1GBeAFRgUunHxL5uTI2x707sf26yMfh1XRlSbL4nlTk4sPQzhnUbx9UtRwxT8ciuUUTt2IWxsotKYfpX3IG0Udtodwa4phKIT8dAKxy/xGFVz/HwlNc2EPQFcv11xuHuVv3PdPsjznTgxYWoEHDj+Af1IsXR9+bZzPyFuJ2Ca/ewstsuxnMGjOocTC2ctGEBwCpjn+LE9iPHXaDxC6qnJdzLTQF/Sv3dEczjZs4xSB/HjwWEl/oV5nKUoH6eAh3MZTBBVoWO40/BODJ3RyqL2qcg6yPNR6FYoLg6byG0rOR+p5EmGvIVoQUQFEQUyLMY4YqS62LA//K9Wywuo6lTeteItzt3hoG9bO+PDHw3sDvYx2AIULC7N8BE7TyGO56gGHVbrbqR47FR/lkJ+RSdVeS2UgiTCD6rLT5uHlwClIwHevBu+Lu4VUC3j3CkCmmOoGH3WpnSE2aaq3Vj8Hzs6D7qUUJu+DG6+PQSd+pV0pjd5tcuKORWG43D5+mpIqdkRxxmvUqYGb6ecg1onQ4mWjZ7v+NQpMEYsZb4mNNLBuhBjiEDS27nGiiYh/xzQ1lks9paE5XuzWCBE+mEqNRC5ud53kqyBPSTEjM1FwdVKkN/5pXfUuiGpDuqlknU7PScULcNPNU/60IFQgQrfrGgkcqtKGYyL5dpib1fUFc6nmc2kizVcT/Usa6GyBsMCv70JgAW2wRSNwJFWlAqmJJorm/u+WC9nw9TqvJvlvriom3O+dbr3AZBjMHUgNnqQRFt+SGkkVj4+3nH/h/g+vrrbOoUDPVVm9LHcYbylBcno+XMPSeMgaYPFaS8A4I2Dxdgwmtz/oO3pjZbplyvArZUAJHnyrXbyp/8ML6MUdVIV0WYLVFECTPgroO8K2g
 4dAmPVqO
 epsx7tv7gQEZ0b5yPFVgzvrN+5xm4fmIWZVCfIKmG9U1EKf2ChhAPpbIksFdqAwbPeO8pz4tyDf8PStnikgrTf3IbG+X9SFEPmLBdI0k9H+LBo3govHBeFZXOUK2o4EzrfMyX+W6TgIA4FrxVsXkgyU7+SAm0hP98fI+m2dkTsI1Ty3KuDUi3JsP3+9ft+nuIIEnFxwqntff29etCUF6U7LgE7iab4ChDWUVfmQiQaOuSrTvm7H5xSQdNdPWlAbVVHxK0SUpBeKdq1UPBIa/4QdzIlcQSyYKxdqm0XsCDSBC/XbN/jqX8RIBnp3/3TKobWmWFAMQ7GzLBdWPmc9Ubaf1ATOQIRh4T8VxVxWpy/4hBXHvgDIyJ0SqF3O17OBHTe6w2Va4hOmLlenQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 04:49:48PM +0000, Yosry Ahmed wrote:
> On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> > pcp lists are drained from __alloc_pages_direct_reclaim(), only if some
> > progress is made in the attempt.
> > 
> > struct page *__alloc_pages_direct_reclaim() {
> >     .....
> >    *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> >    if (unlikely(!(*did_some_progress)))
> >       goto out;
> > retry:
> >     page = get_page_from_freelist();
> >     if (!page && !drained) {
> >         drain_all_pages(NULL);
> >         drained = true;
> >         goto retry;
> >     }
> > out:
> > }
> > 
> > After the above, allocation attempt can fallback to
> > should_reclaim_retry() to decide reclaim retries. If it too return
> > false, allocation request will simply fallback to oom kill path without
> > even attempting the draining of the pcp pages that might help the
> > allocation attempt to succeed.
> > 
> > VM system running with ~50MB of memory shown the below stats during OOM
> > kill:
> > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > 
> > Though in such system state OOM kill is imminent, but the current kill
> > could have been delayed if the pcp is drained as pcp + free is even
> > above the high watermark.
> > 
> > Fix this missing drain of pcp list in should_reclaim_retry() along with
> > unreserving the high atomic page blocks, like it is done in
> > __alloc_pages_direct_reclaim().
> > 
> > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> 
> [Sorry for thread necromancy]
> 
> Hi Charan,

Charan's email bounced, trying another one I found on lore, and adding a
few folks from other replies.

> 
> Are you planning to respin this patch?
> 
> I know that Michal was questioning the need for it. While doing some
> stress testing I came across a couple of OOM kills that had significant
> amount of memory in pcplists. Something that would have been prevented
> by this patch.
> 
> It's not something I can reproduce reliably and it is an artificial
> workload, so not very concerning, but the patch seems like generally a
> good idea and hopefully pretty harmless. It's also consistent with the
> code in __alloc_pages_direct_reclaim().
> 
> For the record, we have been carrying it internally for a while and
> there haven't been any issues AFAICT.
> 
> Michal, WDYT?
> 
> > ---
> >  mm/page_alloc.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b91c99e..8eee292 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3857,8 +3857,10 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
> >  		cond_resched();
> >  out:
> >  	/* Before OOM, exhaust highatomic_reserve */
> > -	if (!ret)
> > -		return unreserve_highatomic_pageblock(ac, true);
> > +	if (!ret) {
> > +		ret =  unreserve_highatomic_pageblock(ac, true);
> > +		drain_all_pages(NULL);
> > +	}
> >  
> >  	return ret;
> >  }
> > -- 
> > 2.7.4
> > 
> > 
> 

