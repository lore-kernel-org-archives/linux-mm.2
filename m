Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD33C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D3D6B009B; Fri, 18 Sep 2026 16:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214BB6B009D; Fri, 18 Sep 2026 16:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152B96B009E; Fri, 18 Sep 2026 16:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E33C06B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:48:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F85D1A06EC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:48:21 +0000 (UTC)
X-FDA: 85228070802.13.B1FFED1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA86D140009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:48:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhH1EZxi;
	spf=pass (imf09.hostedemail.com: domain of "SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789764499;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3DLy+3kNg2/wHbf2EqxrOXhPJ3Jfo/SncNlpx7Uc1o=;
	b=HHQEyBRKsHMHdVIPJfYTD56phlXt2nzcaVP1CfONgT/hqn5U0dQVoukEanTGzOUBxosahR
	V70BsHorZZ5LdIVefTvnt0NVTmkak1WG5auDntA52QtNI7V8S8MNqxL2erATgmDiTJJsl2
	x2iq+SBbtaBktUj+TylXUIEHpeBUaBo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhH1EZxi;
	spf=pass (imf09.hostedemail.com: domain of "SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789764499;
	b=E2f5ttjldV2UQ42OBBF4zGxVWcq5c4NiF2G50aPOps/uFE7uCWSUuef3XF9pNgmweEH2NI
	jLssgFM6IQhIXULFPOSvDLQX9AGB3511wOrgu4Vh4TorPWcdnEOqYCsd0ac3SMmbxJlfub
	JCEGdjGXsB79VR4vX5QOpv3LJV1g+To=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F55A6053D;
	Fri, 18 Sep 2026 20:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA90D1F000FF;
	Fri, 18 Sep 2026 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789764499;
	bh=F3DLy+3kNg2/wHbf2EqxrOXhPJ3Jfo/SncNlpx7Uc1o=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=XhH1EZxiDYkIZHt9a5/V37pg/Sarp1e3Qe5lMO0l+rbQFqnKHefScnL4wdDDBhxD+
	 1IKmTGM+ZquVGfG6+twDL03GIBz6MYywQDt/asVqrQkDZDOMW515TK21G9TP/djRHE
	 lO30B14/lAhYinNnfOAMgBBYmZzkb1+gk+Xk4Sk42LUyBGxYeN2FGwDn1Al208N+yZ
	 kv/CFzM/vBlqPJwhfQpG6aQKLJx4PRawtNKD51PUgzl+/NGxNDib+NYwqdOFa/YesB
	 G5/9eRJyUXAH2LOBeldllXEe3A9mMn7lxPjLry/5GDH10znpKuID0t8DuufHkHHvGZ
	 Vt3b6oPwrlqwQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C2552CE09DC; Fri, 18 Sep 2026 13:48:18 -0700 (PDT)
Date: Fri, 18 Sep 2026 13:48:18 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: report RCU-tasks quiescent states while
 undoing a range
Message-ID: <bcce9339-92bf-4702-a336-f572e6e1ba7b@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
 <20260918123239.8f25b984ca280fcc11ef6e6a@linux-foundation.org>
 <a67e8b91-ebc2-4d3d-b6ea-d221b297fad0@paulmck-laptop>
 <20260918134342.c50423cfe3b2910e899226f2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918134342.c50423cfe3b2910e899226f2@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA86D140009
X-Stat-Signature: f6yfcbygfujp6qqnu9bgpzqmbd639gxt
X-Rspam-User: 
X-HE-Tag: 1789764499-54587
X-HE-Meta: U2FsdGVkX1/FG1Un3hjPiLNXLEIjwBoWyOzGs4jYT3gHubidXJ3DmKPYN0BTIODojNn3PzjGGOKx06jI/bUUxh/XIAGkFqbFazG/978yHpaSvnW7j0CbvjeuBiZj4vbzva5O6VW8nCVK02UUA96YzxFO01guJiFg6aye5vCDL5yxR+u4UU7z7xjJpq+PU4Ola1nQWg5aAJ0yus6w5o/CZBJQa3CRQ3myZnE1U6xOSUMGhjqZe5plO0CVVGJTDWzKZuGhgcPu4GGiQWhiNsR07kc/fhSjet95gZtSViB8syT0bVmxXcEViprIDwt+KT8LFJy/vTfmnEtNUuk1r4ASZ5floYkWVAlL1gYr/2wtBvHR791Vz6jh+j1iAyG7N+b1ATbFCk6Owpr3q30uIlG6km/trlq5Hgyvq3ngOAIPfPXdKV8LSgAOTAla/AyiM3VNZkRIx06uHwPpSceFCvEKTquYGaBNx5/Ycn7AlCIGSanlQA0ev3AQZhbnT7AL20xvWP3GexpTmHicXJ1kVajtoUF06b3sjXm7aZfDgbSoFxBWDh2U+Jg0h1AgTpl5r9TaVJ4DrRcn/V3AJzIRCBwhdnBMeazHGHiwZWt714uL5cNgGae+9lrutB8mr4R6nm7ldrb8p+CEqGqs8uXkWeD/a1Cp/dnvPWUKFUwkU4oPFF8XoMGVNVuFodqdjCMkqRoO+WmNCzrqb+1OcIh8oXqaPmlCvNulrlAxgUrQYnnDjD9TjwQIXEooXlUBAEFIVvlOfh806MzZAX5wbFumd0aic4C2VWsKcS+ialO8n0wGVSeKiXANE+Z2bYeXUqh7HJp93yrRmOYAGfaWo9q7GU1QjP/RNXct5HhOGVqL/TZ+IYTf3gjo2BWgpZMdHKk91L/hN2CUt5aNUDoPg0jnHae/7S6nMP4dlIWyf4gvXiP+QjimkawZoxDLmBQ25pc0/k2LANWDlw2iU88gEIpSFEz
 9QLAQq2V
 ogM+iX8AgYxX5BNJmLL5cY418XmO8/i9TRBpQm+X4eU6kY35nEOR47voxow1LmFU6GAW2VuK+sRHJZVRphowhQwTOVNr4ALqIGzwjPGGzRD7L7BwrFUcjjFy6btDueF7cpQruFv3ULoWDdjh5irhqIH5JnJLID20oxWYM9kBaimSmBoTTYgGw02TnDsMoCgLhDoTreKP8QKF63orEG+mm837j41p4DYdw96xRF2wsmOA9XmfuAfWFMUBr01vMUVmmNV4EyP7zmPn+UqJjMDvqjcy9vU+5h9KYEifsksQ8Mz7qE0brGmiEdsPRT0xh5NbOPHJuKdhhu8RnxDgQ6+OzO21uAkyXlEf/hQr/OWOMPJupH5g/bKz2WCNpIVx846wyZJy8/MVWL7N/7+Q+FJZhrgQQxp4190fhOZmezk6489oKmEjLjv49BWNKcXa6upFcqtajTITKZ766OOyqE0BMsC/5J8ZrGNjvnWWVAxLAG170zA+f7/21ozEsuUIEVU0tBNpl0d0i/w+68NdbNcfZUo1Dgh8KR5QfhRobnt8pVVT0rmX8ZOdd1vtrT82JsPhqgdOvXrD+973Jq8pDwcl7DyQgUItwlm+0sEQvBZ1tthnM02jsm8BnSB+SlEqN0OPBtfBuiaTST08Q78OBM5K6I+PBT1W4LGFcTt6g1cHyXAEQw2cjMZyDaPXRykW32hP1gpTqrrg7LEH97do=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 01:43:42PM -0700, Andrew Morton wrote:
> On Fri, 18 Sep 2026 13:24:53 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:
> 
> > > 
> > > > --- a/mm/shmem.c
> > > > +++ b/mm/shmem.c
> > > > @@ -1367,7 +1367,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
> > > >  		}
> > > >  		folio_batch_remove_exceptionals(&fbatch);
> > > >  		folio_batch_release(&fbatch);
> > > > -		cond_resched();
> > > > +		cond_resched_tasks_rcu_qs();
> > > 
> > > Won't this change remove the cond_resched() function from old kernels
> > > which really want it?
> > 
> > The cond_resched_tasks_rcu_qs() macro implies cond_resched():
> > 
> > 	#define cond_resched_tasks_rcu_qs() \
> > 	do { \
> > 		rcu_tasks_qs(current, false); \
> > 		cond_resched(); \
> > 	} while (0)
> 
> Oh, should've looked.

No problem, and yes, I do know that feeling.  ;-)

							Thanx, Paul

> And it appears to have been this way forever, so
> s/cond_resched/cond_resched_tasks_rcu_qs/ won't break old kernels.

