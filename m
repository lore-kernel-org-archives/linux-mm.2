Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A54FC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3AA46B00B5; Tue, 22 Sep 2026 00:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11CD6B00B6; Tue, 22 Sep 2026 00:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B0E6B00B7; Tue, 22 Sep 2026 00:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3CE26B00B5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:21:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7666AA03A3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:20:59 +0000 (UTC)
X-FDA: 85240097838.08.D467A60
Received: from mail-oo2-f39.google.com (mail-oo2-f39.google.com [74.125.231.167])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96AB1140006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:20:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eyvsbbxn;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.167 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vw7F89gHzb0bwYi7GFQ9WYKMfHucMYNinHqo/LXrYrc=;
	b=mwbXkAZoRJrCvUbro0Wx/NFbaLVw+W7jy/sRMAbrOawVoxEqAQI/BMxhVVxb7uAh9C8DYB
	kxd0BhjvMYkehQ40naY8ZOKApwT3se48tXb40A/6DD5G0wxyA+2zFAnYUOGk40HcJTScry
	1cV48jr+l4QA3XUaiABr1IYSRZnD3Oc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eyvsbbxn;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.167 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050857;
	b=Sjob3ElG2UJG+65UVIUyTTEoWg7g9hdHJc7UTxKLdBUwjHnWvdoRocu1jhKhc2+ccs3X0V
	wbs06ttTGdLthwSuq6EeF+jWRcBin6mXMLM5FVqRRoSgF40MBjEBVoqJoIIs5zT9LP/AXE
	+7gUxcOYdK1e7uABjEwgT/ato9ETbmc=
Received: by mail-oo2-f39.google.com with SMTP id 006d021491bc7-6beed321ad9so1988964eaf.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790050856; x=1790655656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vw7F89gHzb0bwYi7GFQ9WYKMfHucMYNinHqo/LXrYrc=;
        b=eyvsbbxnes/3KhfO1K5mleq6uPbwReKesdfjAGY34LObAVc79Pchb2+YJgie21fa2m
         DMKCMaMENoFaxP4kIabVK5JOIyDNY9brNMWl/lZrhqcOf8/6UsnElKHbUMoq/Vrm+Tsg
         mpXPxXYOY/TozkZnbv4Is/0x5a55/BSYTrn6Fk94pGIdIgb9Fq8dUF8Z5fXSIeX2NBfx
         PfMHJB9VmCfSp1kBhLlyMb4V1L/M584aNXOzYBtPg8xx+d9C7TpkfWDkniJX4GRVJGRK
         a3dKkkjLdC5DlBQmQRr3H8ETeaTspGI32hZ0ZdAJpgWvgrN5PkRmzhrAFBulkjSn4AbC
         DLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790050856; x=1790655656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vw7F89gHzb0bwYi7GFQ9WYKMfHucMYNinHqo/LXrYrc=;
        b=G6PImIjdWGSuW3R3JWXzLj5EktiNuE3z5XzM8QE4bHimqzxBf9BbW38CdAeuow87yC
         /KV3kUXX7LqNf8KIkNVQ4Lx+ipRk5m1GiTCjnIVby027kwE4e1tcp+nhRFTWUmcquK2i
         Aa2YiP1mVtQd4OV98v/x0ZZvVpsS0FnkMBrZwG/dQW/zkAJ8vD30t7zA3uJH9aOjm6mW
         z7VuYnU8//dMc962cvv1BfSpXYiCWyxOsD9oGa6md1rf3+oyoUEPFnzRTC+U/hcI4jf9
         gQHkHz2lZCJZ7RumgsUlVvKeg16hjSFtI9AvAEBPGOOfNVQWTTXvtpi4EaTZeDEAGbgF
         Bw2w==
X-Forwarded-Encrypted: i=1; AKwUvBxqx2f3WKFYQ9viDOEMRS5TOXD2JW20L0YznkOZdUdmWa3f2XesAM8u+ucu1hfUeakhJPaew3mbWw==@kvack.org
X-Gm-Message-State: AFuF++m8oBDb9KKbP50Wq4UmWwKQmo24hOM49Ap2SdSazS2Mz12qX0p8
	0jKDUJ3P/RABycyGBqBITDSjEkpsVcSvLm58kM7H56FIDQSqmDJJgSwp
X-Gm-Gg: AYBFou0Ldj2z2Nh8qLb1vfwBBMX7j04X495Cz20f3Ih2JJNem6GYgCbki4ane+FEFeV
	HGWdUkvrZCKFYPDgzJoR0x46e152xerbSForWTu8jFLMrAW3G+mkeeQiwdjRolYJyP34clWPKjj
	Zl4RGx8b0cvtd80botCRCD0AZR9QgwBIxAef1r38VBIwFPV0MGCvsg5/N2sb0yDgh4tk2CoCxeW
	3+W069+JqfdWGRTgqntq+tXReHpk2zICLGJSy0XWXqU7IDzQgmWjEZ/Ey/l7CQqWtl9b/OJdLVm
	/Ynd3HdVzJj66e43nVEcjcu0LWz2RUnHQy5IqPUU+n3P2DtfHeKlpmkr+ieRZqmkgMThSwiBzC5
	ZXzDyMPziTmqHla8wG+KrMZdeLwpjuzpd7ZwQPrFcAEnzldO799DArpy66KzcZFfNaVJ2NBb3Zd
	wVvR8L1kYAznbhc7y9u+YlyYGhrx4s1Jn1HOkTcMS3AJ9b1bSCI6q/kMynW+wpJuLCjy32RnpLx
	KoiF+NGyc1XJSGZGXb0PeZl6i3K4Q==
X-Received: by 2002:a05:6820:4b8e:b0:6bd:bf80:9796 with SMTP id 006d021491bc7-6ca9be50072mr13917974eaf.41.1790050856466;
        Mon, 21 Sep 2026 21:20:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-814e394ac61sm881122a34.1.2026.09.21.21.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 21:20:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Mon, 21 Sep 2026 21:20:53 -0700
Message-ID: <20260922042054.3264663-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arIAyyjYcCKHFmyD@localhost.localdomain>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96AB1140006
X-Stat-Signature: yowf7rxb5zz6o4s4rst675ee9p61z4fh
X-Rspam-User: 
X-HE-Tag: 1790050857-446703
X-HE-Meta: U2FsdGVkX1/pALb4AAO41yOSBQCwwpyOlYQycZGchuBE4QD97E2ag6sOG8ID3MqU/IWLEv3Its+J6lWDLIjavGQ5+kI6sCY9XrIB9CrBWkzVEcAlzwzamFTBnB5vsaCRws8Ewb0npmFy/foRTrOzzH24pRLkrdwbqUPEcjZKpg6Wh4noRJeTtlc0jBdVy9T1Kr2xtIQl9sBEUDsEPH+M4WmhSnaCqEiAWxNLxoVeSreMJK72Tf1I/sosOwv72APXhTWjnsQdpVSGCdHxLbwuwvEVLZlpNvYGo58acPsD8NGfnCPWoua2IPsIxwvL+InBOsakUEchZ32Sf4p6nSOFHQTIqS4cuhX1iuWrxcmDJHqSpcrraJhI/Cq1CnSxpiEG/ZgPmQ+Jf0Xu6UWhiw1CNQDb/L9V94f5wvwo3Jd/IC1ziITAwOHI4/lsskTayrdq/YPENSNjDLYM56sao0fIGMZeVPbQRMr9fi0oF8ZH6/SwM2G2trFWUZGgp3odDPIQ5pO0p/7UN2LG55LD5Ra43hiQuTMj4aBHsSwjmqs80NlcKQxJcxXmcqwFK9jtjz/c8A1Ydul87XhIS4RhY+EFuMfnFFT6/wWPxauOTBimCph44iI809cad/gOz0tgvlg/EJeQS4Y87wa1Onk6TW98u9NZfCb4OOBFz1IXjlHDoHPeFGcVzMiGxszoXIoqA06IWtFuRqRw6mGa8H9Jn3zcXD6mxAA75mg7Pv/tjCVxLd5HatL/y9ekpB43CQ4E9WbfdrfWMxFnzbltAWeWXKiYcEQkyLw0fuec/7o+3ZNNUbbSI9o6v/wYVZzqdz1U9UsFJDJeWoiSAHw9+N4hiJM666nZu0gZcT0e74t6vcY1itooRJxaGuDDHNTHUTwRAcDTmoAZp7xFAyda7xHXyTlnBxyZmyLLzf1vTlLr7s0x8A/wvb63DQncVylDoOnyep2KZpVYGlueqjsiQAKMwUL
 DzKLiup6
 nBU77ctJAPc/U73l8gUXrawS++WZELsVd7bJBrKBfC6+pjpOI/fUv901+lajULYmwwSLLIqs8Z4iwrdgpkTtu5YRJYFsF9tJNTon0ZCBHIyv57EiK57QGVZd8OD4MqB1A8obEdnA55V5WXkomobekfxGmGrfi+TTlj27EzRdMi0ukxtRiw/eAgRAJb7nw1YumePjbFwFTCsl/8XlaQaFKgPBRhIoarnMe3bA/hv4c/wclwtXF6W8jleA+I9WzJLCNPW5w7ZMTwsZBl75jNPH0NJulZhbW2fShWQoLbCffzaCqrq/rTRbsPL4jI+afb7XP6Wx7o9ApoLp5wL5a+cDf2WsCm5u2TAk/47J/+J4VfjwIt7vNLbkFeQTvhNLwqkgTltxLHFngt/w8vGNM7w6vX1auoG6F1FKGu99Lx8/HIX6fyJHCBudzWYpnhrDTkwGj5NQA9fEm4fTmuqULM7w+t8LbSC6b2tSwzlTvX4fNsr25ry9Apn0Ymde9UT7+xMEOS2jBeNjIEBGKguMKWmiGgpF1rYxZ2SGxiZTj0qg/NaRLzRKtDXIs1jnO8atKAWFWBNR6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 06:15:07 +0200 "Oscar Salvador (SUSE)" <osalvador@kernel.org> wrote:

> On Mon, Sep 21, 2026 at 05:12:35PM +0800, Hongfu Li wrote:
> > From: Hongfu Li <lihongfu@kylinos.cn>
> > 
> > memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> > stats. These stats are accounted against folio_nid(): incremented on
> > the folio's node when handed to a user, decremented when the folio is
> > returned to the pool.
> > 
> > During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> > to the new folio and drops the memcg data of the old one, so the free
> > of the old folio right after the migration skips the memcg per-node
> > lruvec decrement. The hugetlb count stays attributed to the old node
> > for the rest of the life of the charge, while the target folio gets no
> > increment on the new node; its later free decrements a counter that
> > was never incremented.
> > 
> > Migrate the per-node lruvec accounting alongside migration. Global
> > memcg totals remain balanced because they track resource consumption,
> > not node placement.
> > 
> > Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> 
> For the fix itself:
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> 
> question below:
> 
> > ---
> >  mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1460cba53588..9c96ebd5436f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
> >  	rcu_read_unlock();
> >  }
> >  
> > +#ifdef CONFIG_HUGETLB_PAGE
> > +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> > +				     struct folio *old, struct folio *new)
> > +{
> > +	long nr_pages = folio_nr_pages(old);
> > +	struct mem_cgroup *memcg;
> > +	int old_nid = folio_nid(old);
> > +	int new_nid = folio_nid(new);
> > +
> > +	if (old_nid == new_nid)
> > +		return;
> > +
> > +	rcu_read_lock();
> > +	memcg = obj_cgroup_memcg(objcg);
> > +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
> > +			       NR_HUGETLB, -nr_pages);
> > +	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
> > +			       NR_HUGETLB, nr_pages);
> > +	rcu_read_unlock();
> 
> Why do we need the whole thing to be embraced by rcu?

Hi Oscar,

I believe it's because now getting the memcg from the objcg requires
an RCU lock to make sure it doesn't get removed while we work on the
memcg. I think this is since Qi Zheng's "Eliminate Dying Memory
Cgroup" series.

Joshua

