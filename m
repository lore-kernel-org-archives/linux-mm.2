Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D9ED46602
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1716B0089; Thu, 15 Jan 2026 12:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896296B008A; Thu, 15 Jan 2026 12:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3646B008C; Thu, 15 Jan 2026 12:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5916B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:00:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2B3B140405
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:00:23 +0000 (UTC)
X-FDA: 84334811526.05.E02783C
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07289C0022
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:00:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wT445DsQ;
	spf=pass (imf28.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFhntWShXHgOAIorUq2E/j9pvFsqctkiMpQmDw8UuZQ=;
	b=JBN4ILF9tKDwQ7zu0DOBgLYWhGdaGlHCXElyXL9IZk3U7DzRvI7IL8hhrk6sb8oZs/zZB6
	bWv95oGTZrEZfUOQSAmggFaqCnCz05XssSuY4eTds/OnbZe5iNRv5R9WzScB1+WJpv/2B3
	0k6DICriyBOJkr95TQ/6ppEa/xzrKZE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wT445DsQ;
	spf=pass (imf28.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768496422; a=rsa-sha256;
	cv=none;
	b=kLLr/Z4oH5wdgup+l1HbQt22gi3UwoAvmosVk1gmVrjy021mBrBHQuRRyuKb7mTg7nuyDd
	KrIimID8zUdyo/YktOLF32vaHgryWYi916v2oCpBT8BbCmKq9S7KsDri6w8Idx1k/sZ4jS
	IBBSxZhcvNqf7wjAs71LqX3/dDq/pT0=
Date: Thu, 15 Jan 2026 17:00:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768496417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VFhntWShXHgOAIorUq2E/j9pvFsqctkiMpQmDw8UuZQ=;
	b=wT445DsQd4/3Xmj+RvJ2Ntg8GFkTgTIfwuwltdPW2wrMKBYK1L/wQAA7vFELJHski3hyGh
	MmBUfmpJyjXE7E7f69igcg9ZrmSZjp6krqT/hyIEEmg+mPBDUzac1RCa+KgWCgebP2ws3G
	mIFyVcZuKu0Q3CLBz6F5nVMY3RU3Z6Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	corbet@lwn.net, gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com, 
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com, 
	dan.j.williams@intel.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, rientjes@google.com, shakeel.butt@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, bhe@redhat.com, baohua@kernel.org, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	osalvador@suse.de, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <e6eydzdvuiktmalhcmoiwsgzjbw5v7t4532fkbroylwr5cqetx@v6pgjaoxgmyz>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <CAKEwX=MftJXOE8H=m1C=_RVL8cu516efixTwcaQMBB9pdj=K+g@mail.gmail.com>
 <CAKEwX=M8=vDO_pg5EJWiaNnJQpob8=NWvbZzssKKPpzs24wj+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=M8=vDO_pg5EJWiaNnJQpob8=NWvbZzssKKPpzs24wj+A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07289C0022
X-Stat-Signature: a7ugojzn4y7ueiow1zmexzacs88rzitz
X-HE-Tag: 1768496421-769773
X-HE-Meta: U2FsdGVkX1/hhHKEYZNtOOlC3ShVI454uCA9z8hvoHi1RV5CRZoEx8OnHkR3MWNUV/+diR+8aTVua6yLPK4RiDd3fCSvCMM1nNhcjgTP7oGiarASRcZILx4qVd8+bnIGYRe6+f2qN3VfqSooiFYtA15rAfchdK2VURACS+zHl3VyJU5gLKwBuCvRJU9uO1+5o/1luuMAeSYnTJCPZTlxAxLOZyK8OSeykVhOmhhBJkUaN8tE52vJorJfPn6D9lrpAyojfp1KdOwWTa4OD/H4X3/FOp9rJ6o5wadgxj2uJJOfg19Bn2xCBFwyW0Ga82ZNh6jKE5SGhIt+lSCYNj3M39s0NYV/pQsDgbFTfcDNSsVqPnq+VeF5VchzocYCseKXd36M2zLxO3QnhduM2tYtSzIpf8VcWqQByIGD7UM0/jutMSTiWCwo05SmYKnN8cfNgtWb7YIhYyAwDoerBhAuivQ91575q+/6gp/P2R/btoqnnq6lTFGuv3dxk/ATPbVf1BhHrqUddbAM8dDBfiVLlDDdoEZjt6PlCW+DIEM8OOjv9fX5b9fsKMmmFcnDB9FAxlQvxDveIEaYYBvwSjVuer4VHkfiqHWYtAqffpXlD0dVoxx2d2Vdc54f8RJXf995kGKLFo5LBmF5s/t2cgFcw/CRyqrYcMHw0rp31Coe+mgdfdUQF2K3sP69A/UqSFYny8p5Ejvfoi3xgr716cSwQpD+eZDYCRcrkpx8cxLX0jMZFGhs/Qdj+CtS7g7T6q6MmSnQJ0KiovGeMces374u2zbSnKFsEMKDwe6ath4lysW26iELVihZXfy3Xu7itABpqhZ/iwBjFJOZ8YEeE4SJnslzPhR27/lc0IZEukGhRWDnE/bV5JeUiWbcRNJBRvrwI0jj0rICATZwMXM1msno6E4iOdSijgcUX5S+eAQDM4ctL//OiCGJjj5ajlnWx986BE2gCUWnoFOAsNvdydc
 EkW+y9GP
 tk3R5oF4lcxHZ0ENMsJhigOSoa6ZNOSrWsD9o34iODDlin/xXiAmi7CoebeVx0deeE7yJwe1rr86HCbLAlsDfh7xxWgG4kEn5ktWszj8DPhiFiEwG5QAX2xhwYm1/sGk17qcrNkzBoh8cgvbN/FAx/jb5EDSXNFARU7HH3a204pcINqROY799zgJoi4/KADv5cvQZA1SADWQZPZhh4SjwBikKvYv2f05RUPzSa/0fFNoBn8wqxClW+urAkiBSXK3x2CgjTKSMlVo/Xf1GZGiSk552aILpOgTLd92RC3Ie3ZtgTkOomHWCCNNcO7xlNueGfI3aqu7InxVsgM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 04:49:20PM +0900, Nhat Pham wrote:
> On Tue, Jan 13, 2026 at 4:35 PM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > > This part needs more thought. Zswap cannot charge a full page because
> > > then from the memcg perspective reclaim is not making any progress.
> > > OTOH, as you mention, from the system perspective we just consumed a
> > > full page, so not charging that would be inconsistent.
> > >
> > > This is not a zswap-specific thing though, even with cram.c we have to
> > > figure out how to charge memory on the compressed node to the memcg.
> > > It's perhaps not as much of a problem as with zswap because we are not
> > > dealing with reclaim not making progress.
> > >
> > > Maybe the memcg limits need to be "enlightened" about different tiers?
> > > We did have such discussions in the past outside the context of
> > > compressed memory, for memory tiering in general.
> >
> > What if we add a reclaim flag that says "hey, we are hitting actual
> > memory limit and need to make memory reclaim forward progress".
> >
> > Then, we can have zswap skip compressed cxl backend and fall back to
> > real compression.
> >
> > (Maybe also demotion, which only move memory from one node to another,
> > as well as the new cram.c stuff? This will technically also save some
> > wasted work, as in the status quo we will need to do a demotion pass
> > first, before having to reclaiom memory from the bottom tier anyway?
> > But not sure if we want this).
> 
> Some more thoughts - right now demotion is kinda similar, right? We
> move pages from one node (fast tier) to another (slow tier). This
> frees up space in the fast tier, but it actually doesn't change the
> memcg memory usage. So we are not making "forward progress" with this
> either.
> 
> I suppose this is fine-ish, because reclaim subsystem can then proceed
> by reclaiming from the bottom tier, which will now go to disk swap,
> zswap, etc.
> 
> Can we achieve the same effect by making pages in
> zswap-backed-by-compressed-cxl reclaimable:
> 
> 1. Recompression - take them off compressed cxl and store them in
> zswap proper (i.e in-memory compression).

I think the whole point of using compressed cxl with zswap is saving
memory in the top-tier, so this would be counter-productive (probably
even if we use slightly less memory in the top-tier).

> 
> 2. Just enable zswap shrinker and have memory reclaim move these pages
> into disk swap. This will have a much more drastic performance
> implications though :)

I think what you're getting it as that we can still make forward
progress after memory lands in compressed cxl. But moving memory to
compressed cxl is already forward progress that reclaim won't capture if
we charge memory as a full page. I think this is the crux of the issue.

We need to figure out how to make accounting work such that moving
memory to compressed cxl is forward progress, but make sure we don't
break the overall accounting consisteny. If we only charge the actual
compressed size, then from the system perspective there is a page that
is only partially charged and the rest of it is more-or-less leaked.

