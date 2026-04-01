Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405331076368
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 04:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DFF6B008A; Wed,  1 Apr 2026 00:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945AE6B0092; Wed,  1 Apr 2026 00:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B376B0095; Wed,  1 Apr 2026 00:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 707466B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:58:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB94513B464
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:58:02 +0000 (UTC)
X-FDA: 84608780004.09.6C13B82
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id C002D20005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:58:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U1ElDMib;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775019480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aN1DZWPJ0MnS1SDustHqFcyPNSSbBG6QzLrU5nB1OQ=;
	b=wZr1/So8jm/J53B8iOR6rRUa8sNSwiWxuDZ665jQGVuzdSKmITzk4Q8bmoUBfXTpyXD/KT
	vRi0TD/t3SXL95bX4xIrsFBGF8Qd/mg7Sp8cGvS1r/NLKbsBF7/tqE8Kth13f0cWsYtCEm
	+ngflitXb6t2czPbLKEfPGcV0b55lAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775019480; a=rsa-sha256;
	cv=none;
	b=XJJiEUgE865xgr/E4abVl8CtLXTZsR3H7Fq7bdjYkuMgPh1keGZu+4RAlcJfQswqtZxvzT
	ikyhaX1SpwRY/5M81v/qwB4jfOvpcMhw6/RRIN8bhSvZgA3QeVZc1oryZckKhD3G3+1M5B
	GqsHzy6B7WtxEUWSUu4LAdhgLMeKYas=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U1ElDMib;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c70f91776fcso2589959a12.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775019479; x=1775624279; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4aN1DZWPJ0MnS1SDustHqFcyPNSSbBG6QzLrU5nB1OQ=;
        b=U1ElDMib6DuT2XLzWvdw2F5RwqB4lMulv/FRgGY5zasRGw3wQBQjG+cYGIkHyHDCq2
         Ma3to/bgF/YNRLoELPx6NXG8/md/QqTaWRWQ+jKaVKTbPndgnGlU4f66bYa40AAG1J/u
         liTdxY1cjNNLFcT112KnkM5edjF890lJt/lMeCohrfZh0WEH2X0T5kHE+c9zn1+KH8KU
         /ZvENoOSkfYcNrfXGMObd/F6K/1/9tEayAYJISFBxl/uYS4xhZXC6+n9Kuo7UBdAJWdU
         k+qG/KlK9roKSqkBk+kCI1D70CcfIwcfGlFeWf+GuLGsq7fVGNZFGh5ndRJnS4YafhZE
         BMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775019479; x=1775624279;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4aN1DZWPJ0MnS1SDustHqFcyPNSSbBG6QzLrU5nB1OQ=;
        b=Ol4XtFr/f4c6L9xebZj3yg36FZIPmg6tbbp1Nu7uZ/OmF9ZyQzdckqoZlzowDCNYQX
         KibMTXiDoZFTlng1fB3+HxvOsLoThcFKKjBwIxQa7a586SiQf/a6XPtrx96EipgSTwUS
         bObzuC+4pk1vYgEy800MW0yu+QYEdnyxjjLWy4vrAWIu/wgmmOawrlsOrK26QW4UeO6d
         G0sPWH6lbGwFjkuZKQ1AKDJkS7MGCttVo7omNQOCKVff5CLq29nYETqndNtGuVLGg3q5
         vMykRKV1+s3lHCvfZBUAdkR6l82+5l7CcOQn7JLpE5rniRLqK6CTtVh4RqKCVgIta+i9
         CbIA==
X-Forwarded-Encrypted: i=1; AJvYcCUpCOZOCkvvySIHSLOdBaMrTOhVsBD+OSpuLSuTu4zN7naxfiNK88GSctUsmBG4HRUqNDpxyZvnxw==@kvack.org
X-Gm-Message-State: AOJu0YyTWEX2//iI1pQRgj0ZBgrSoo2bC+oEkcjWSpbgQTe7labY9IRq
	PbDcN3XXl5ByvHbc3rMiCzecMSYS5Xcnlitz1gsfQ+5QPBKE+jwLxfs0
X-Gm-Gg: ATEYQzzHY+bMpVwj4UNJqfuvOraYUAqBWHklIqQGOb6+hDvVKbmaYhDwtE1bgXkeJAs
	IhAnEMoQQk4GSnFNi/XIxYLfs7kTryG1WP6vxczKgcEJ734NRO/SWMeG4LyzCJK6EDUqYEwsu18
	splZ0VqeOsfl7qxWoYGFU7UqUOHT+ctpXZ7FmADdppjwMKSqcY4FHWAvYx5cVoBSxG4G5khtSJY
	PdnxD2js9EJmSAlCfc4bMWwSscBoNMlBkaXL6noLQ6xWFaNBvSuJdOdLI8W5R2PZath6jpJbtF7
	4aVBheUfjGKnPd7nUC3xz37Es+cxK+rh5hoR99olJlTfxiA4lbDfQYsZEMDJxi2BTfdSRGCX3yU
	fOHtuI7De7xokn3MhjVORHqh8oN3H1+B0vVqocT20wi9ixS5qojyunVXMcvHqK14KpcrQTsDCXC
	jIOFt/1iY+4/X1daYaCviTXZPXrRToiE2oZm4RdVlbjpzZaChF4KJcFZQakdURnnnBy4yd
X-Received: by 2002:a05:6a20:1588:b0:398:7982:21df with SMTP id adf61e73a8af0-39ef71fa7e6mr2175517637.9.1775019479166;
        Tue, 31 Mar 2026 21:57:59 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76a2914799sm6882583a12.7.2026.03.31.21.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 21:57:58 -0700 (PDT)
Date: Wed, 1 Apr 2026 12:57:51 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
Message-ID: <acyJ2REH1ouj7VGx@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
 <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
 <acuNtuf-mv3KJJdn@KASONG-MC4>
 <703627b8-4c7b-483a-8c5d-379d98400154@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <703627b8-4c7b-483a-8c5d-379d98400154@linux.alibaba.com>
X-Rspamd-Queue-Id: C002D20005
X-Stat-Signature: 8wsrkqwzs799eb81wecoapphktnuyurh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775019480-378439
X-HE-Meta: U2FsdGVkX18Ra94F6MYMF2686bGMz6SnrWH8FijbRXaYUbQ6EE8qm+Arhr1h03vBQ00eLYnI/fv/FN1yXSmEXuoKLEhA2yFi69+hHnyXndbQxQoSncXIfjeNehSrj1oQ4A2FoHemJIVlONwocMRlIBHYWqnnJt5qz3/oQZwmoonoJtwDdVULwwNzwqhYdFIAYPjMzY2klBEd3KLg5YWW3sGe4LVJzVfkg51tOq4V+M+zRYSVS2+D8Hvlg50gD1tqQcSWoE4m7hQd1LFCP4JhUKvYPoGhND74AKVRt2tQ7vQM+6zdYEAwTGGz5m86XrUFSv9rFZqscEdOUx03e6qNJlhK9aSuy9uRgarc4rM3NapxhiUgsJ5Qi/YzffCe0102sBPVfX/LlC3j8IIgT3lJwoU80lR2A1mQvFQbf3GuAeN3cwFQ/XMxCJDj5feQS/ABpdBFpJA7FdV4SPZerfPzRDUqQXEV2rwycWFb68Patmnqe8pBj73MfeU526W6djmtCdpkQMVF4BoKObP54zMHJUA4vqhtlrb1YIvKz4euUWRkBo4ki2ErAEVv8+gj0q9QNj5Ifqwih4zQNQ5h37OMobFqE4tPR+XGly06YsOGfvL0QwgxAsEwuRKe+o7ec+s8PbPHNsB3GTaOvav1BKgj9Nrw/doXEa9mOGvYfljKeyFKUnyTdY9gaaCINmPTKR+7HHGrpGK2uZoBzBgXqoOBb+ejoxdFdu/7JGZqvB4CoFTwPpLJ4yYKqLZnaL3pOQhcYxlm+8Qh5yFXQvdG4vfhIPiz24OdJXtcu5KedjuVFuyZKaNVnIwIgI8CEyRz1E2oO3ow65VKLrddmIfkJl8w+0RW+l5W+lOaxum5usDXO2HR95lVIzdVPp36VIoySyiwok/fnv1Gov7JVb3UcHh0t2QozOtvdVzu68i1mhVjO8GVG4nCKgS/vn17Z+eHSFKW+6DU+BJOb5QriO/VqLv
 PtiT350Y
 hGBNvCVf8peNvIxusb6/eIQ/KxFKZT2McATT1oJOlnKQyeI9AONCLhQ6oOSIkFmQaleolxNUAiPgjTt3q4cLWAhgKM/8rXTwphSwN/PEOnLH/vyL7fhd83ZqbnOlRGzfMkk2HUpfqZ0OCW9smVOZAEgyiQ9ho8oXIMPQCBxXqm6urkpAB3h9wtKDp2a6hKd5LMObrVjxpVxiT2sVmCYlQZRoCo3yQvJ3d5ukX1FxORGTKnJfrdzC7zV/e29yRZ60fLA+PQL1CoMRI7kuTAUfEsI7ZpRDEV6cNs1ZI4QFDtyezfgOoCZFRAzphCDIqKGHg+ayZSckOV4u22uiIZ7iDLQexRJcTGhSpz9h1yi0l2/GHF36Tt3ZoJiNzy8D+Z82tanaLnbXrmAcSMMASt62Ol+HWD96nqjuc7TFVRR5EwvDMXrkjsbYYXUmTSC1gPTh3ieGjhpJVy5M/U/LwGgMfN9LnrOdDy4zacuhw9eFykkxUnK1qY/9TNCirg4boFuiQvIi1xkUJIbEQMv9iFAdsqWH0aRC9GEWXFovc5OR8dkv679zg3+PJa+ZL5qF9yzxmMuOZjahbyM2LjbR8fHCwe00qCmapiC5JuJYUnj3+DH598nfIs/qj0d5NoUxKU/5GihQ+1Vlyd/A+l4BIihrTIDklyXbJEAU+HEX/V5MVtWw5RXYePNSOkXnP2nLi/FGDpJh0p1kY55D/kFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 10:52:54AM +0800, Baolin Wang wrote:
> 
> 
> On 3/31/26 5:18 PM, Kairui Song wrote:
> > On Tue, Mar 31, 2026 at 04:42:59PM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > > 
> > > > The current handling of dirty writeback folios is not working well for
> > > > file page heavy workloads: Dirty folios are protected and move to next
> > > > gen upon isolation of getting throttled or reactivation upon pageout
> > > > (shrink_folio_list).
> > > > 
> > > > This might help to reduce the LRU lock contention slightly, but as a
> > > > result, the ping-pong effect of folios between head and tail of last two
> > > > gens is serious as the shrinker will run into protected dirty writeback
> > > > folios more frequently compared to activation. The dirty flush wakeup
> > > > condition is also much more passive compared to active/inactive LRU.
> > > > Active / inactve LRU wakes the flusher if one batch of folios passed to
> > > > shrink_folio_list is unevictable due to under writeback, but MGLRU
> > > > instead has to check this after the whole reclaim loop is done, and then
> > > > count the isolation protection number compared to the total reclaim
> > > > number.
> > > > 
> > > > And we previously saw OOM problems with it, too, which were fixed but
> > > > still not perfect [1].
> > > > 
> > > > So instead, just drop the special handling for dirty writeback, just
> > > > re-activate it like active / inactive LRU. And also move the dirty flush
> > > > wake up check right after shrink_folio_list. This should improve both
> > > > throttling and performance.
> > > > 
> > > > Test with YCSB workloadb showed a major performance improvement:
> > > > 
> > > > Before this series:
> > > > Throughput(ops/sec): 61642.78008938203
> > > > AverageLatency(us):  507.11127774145166
> > > > pgpgin 158190589
> > > > pgpgout 5880616
> > > > workingset_refault 7262988
> > > > 
> > > > After this commit:
> > > > Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> > > > AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> > > > pgpgin 101871227                        (-35.6%, lower is better)
> > > > pgpgout 5770028
> > > > workingset_refault 3418186              (-52.9%, lower is better)
> > > > 
> > > > The refault rate is ~50% lower, and throughput is ~30% higher, which
> > > > is a huge gain. We also observed significant performance gain for
> > > > other real-world workloads.
> > > > 
> > > > We were concerned that the dirty flush could cause more wear for SSD:
> > > > that should not be the problem here, since the wakeup condition is when
> > > > the dirty folios have been pushed to the tail of LRU, which indicates
> > > > that memory pressure is so high that writeback is blocking the workload
> > > > already.
> > > > 
> > > > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > > > Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >    mm/vmscan.c | 57 ++++++++++++++++-----------------------------------------
> > > >    1 file changed, 16 insertions(+), 41 deletions(-)
> > > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 8de5c8d5849e..17b5318fad39 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
> > > >    		       int tier_idx)
> > > >    {
> > > >    	bool success;
> > > > -	bool dirty, writeback;
> > > >    	int gen = folio_lru_gen(folio);
> > > >    	int type = folio_is_file_lru(folio);
> > > >    	int zone = folio_zonenum(folio);
> > > > @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
> > > >    		return true;
> > > >    	}
> > > > -	dirty = folio_test_dirty(folio);
> > > > -	writeback = folio_test_writeback(folio);
> > > > -	if (type == LRU_GEN_FILE && dirty) {
> > > > -		sc->nr.file_taken += delta;
> > > > -		if (!writeback)
> > > > -			sc->nr.unqueued_dirty += delta;
> > > > -	}
> > > > -
> > > > -	/* waiting for writeback */
> > > > -	if (writeback || (type == LRU_GEN_FILE && dirty)) {
> > > > -		gen = folio_inc_gen(lruvec, folio, true);
> > > > -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> > > > -		return true;
> > > > -	}
> > > 
> > > I'm a bit concerned about the handling of dirty folios.
> > > 
> > > In the original logic, if we encounter a dirty folio, we increment its
> > > generation counter by 1 and move it to the *second oldest generation*.
> > > 
> > > However, with your patch, shrink_folio_list() will activate the dirty folio
> > > by calling folio_set_active(). Then, evict_folios() -> move_folios_to_lru()
> > > will put the dirty folio back into the MGLRU list.
> > > 
> > > But because the folio_test_active() is true for this dirty folio, the dirty
> > > folio will now be placed into the *second youngest generation* (see
> > > lru_gen_folio_seq()).
> > 
> > Yeah, and that's exactly what we want. Or else, these folios will
> > stay at oldest gen, following scan will keep seeing them and hence
> 
> Not the oldest gen, instead, they will be moved into the second oldest gen,
> right?
> 
> if (writeback || (type == LRU_GEN_FILE && dirty)) {
> 	gen = folio_inc_gen(lruvec, folio, true);
> 	list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> 	return true;
> }

Right, it is still similar though, scanner will see these folios
very soon again as the oldest gen is drained.

> > > As a result, during the next eviction, these dirty folios won't be scanned
> > > again (because they are in the second youngest generation). Wouldn't this
> > > lead to a situation where the flusher cannot be woken up in time, making OOM
> > > more likely?
> > 
> > No? Flusher is already waken up by the time they are seen for the
> > first time. If we see these folios again very soon, the LRU is
> > congested, one following patch handles the congested case too by
> > throttling (which was completely missing previously). And now we
> 
> Yes, throttling is what we expect.
> 
> My concern is that if all dirty folios are requeued into the *second
> youngest generation*, it might lead to the throttling mechanism in
> shrink_folio_list() becoming ineffective (because these dirty folios are no
> longer scanned again), resulting in a failure to throttle reclamation and
> leaving no reclaimable folios to scan, potentially causing premature OOM.

They are scanned again just fine when older gens are drained.
MGLRU uses PID and protection so it might seem harder for promoted
folios to get demoted to tail - but we are not activating them to HEAD
either, second youngest gen is not that far away from tail.

Classic LRU will simply move these pages to head of active, so it
takes a whole scan iteration of the whole lruvec before seeing
these folios again, so we don't go throttle unless this is really
no way to progress.

> Specifically, if the reclaimer scan a memcg's MGLRU first time, all dirty
> folios are moved into the *second youngest generation*, the *oldest
> generation* will be empty and will be removed by try_to_inc_min_seq(),
> leaving only 3 generations now.
> 
> Then on the next scan, we cannot find any file folios to scan, and if the
> writeback of the memcg’s dirty folios has not yet completed, this can lead
> to a premature OOM.

Let's walk through this concretely. Assume gen 4 is youngest, gen 1 is
oldest. Dirty folios are activated to gen 3 (second youngest). Then
gen 1 is drained and removed. gen 2 becomes the new oldest, and it
is still evictable .

If we are so unlucky and gen 2 is empty or unevictable, anon reclaim
is still available. And if anon is unevictable (no swap, swap full,
or getting recycled), then file eviction proceeds - MGLRU's force
age is performed as anon gen is drained.

Gen 3's content (demoted) is reached after old gen 2 is dropped, by
which point the flusher could have been running for two full
generation-drain cycles and finished. We are all good.

Overall I think this issues seem trivial considering the chance
and time window of reclaim rotation vs aging, and the worst we
get here is a bit more anon reclaim. The anon / file balance
and swappiness issue when the gen gap >= 2 worth another fix.

> 
> If, as in the original logic, these dirty folios are scanned by
> shrink_folio_list() and moved them into the *second oldest generation*, then
> when the *oldest generation* becomes empty and is removed, reclaimer can
> still continue scanning the dirty folios (the former second oldest
> generation becomes the oldest generation), thereby continuing to trigger
> shrink_folio_list()’s writeback throttling and avoiding a premature OOM.

Moving them to gen 2 (second oldest) blocks reclaim of gen 2 and starts
throttling early, while gen 2 is very likely reclaimable with clean
folios. Classic LRU will scan the whole LRU before starting to
throttle to avoid that.

So I even hesitated about moving these folios to the youngest gen here.
It might be fine as the youngest gen in theory should be hottest, so
skipping it might not be a bad idea.

> 
> Am I overthinking this?

We lived without throttling or proper dirty writeback handling for
years (e.g. the benchmark represents a lot of real workloads).
Things are getting much better, so I think we are fine :)

Have been testing this new design on servers and my Android phone,
so far everything looks good.

> > are actually a bit more proactive about waking up the flusher,
> > since the wakeup hook is moved inside the loop instead of after
> > the whole loop is finished.
> > 
> > These two behavior change above is basically just unifying MGLRU to do
> > what the classical LRU has been doing for years, and result looks
> > really good.
> 
> One difference is that, For classical LRU, if the inactive list is low, we
> will run shrink_active_list() to refill the inactive list.
> 
> But for MGLRU, after your changes, we might not perform aging (e.g.,
> DEF_PRIORITY will skip aging), which could make shrink_folio_list()’s
> throttling less effective than expected, as I mentioned above.

That refill doesn't change the order of folios, it just shifts the
LRU as a whole. So essentially it needs to scan the whole LRU before
throttling. I think we might even be still a bit too aggressive since
gen 4 is not touched before throttling starts, but gen 4 being
protected seems sane, so the whole picture looks alright.

DEF_PRIORITY gets escalated easily if the scan fails to satisfy the
reclaimer's need.

