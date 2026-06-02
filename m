Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE7ACD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CCB6B04E4; Mon,  1 Jun 2026 20:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE8E6B04E5; Mon,  1 Jun 2026 20:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1C86B04E6; Mon,  1 Jun 2026 20:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD3266B04E4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:57:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5071A162AA4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:57:03 +0000 (UTC)
X-FDA: 84833158326.12.A93F45F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97B9F40007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:57:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5mnDEdT;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780361821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7bQHGZhX9+sHJpAAQcCgYO66iY6em+ApCTpukgWa3I=;
	b=2jYJL9k8ASuPlpOBowpASrYZurQpFbrwbSEB+ofCaNb4t52+jBLqlkkhDmzirScNcD7UlA
	lZuu/Jak5rRxp9yMGt9rqMLHehNrO0ClkTmiNt0tzzZZJ9Lut82/hGGEsvPIUCex6yxa4c
	2uYCgnpryrOUw7jVpuGSgaVSILmMUpg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X5mnDEdT;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780361821;
	b=D0mlyhF4zkLzZFuIAHeeBX1vJfbTlx9FaPG0ehuiny4zHQAVatYjjZLWv9Uo4+11Xt/FQa
	4O+Z8t4jJC/3v6GgMAixkakJCo0+dlFsfm1IFOMN00OiEeHpYupq2K37BxEuJ62M17pk3a
	KguKrdAmq++wyeq8rxRYr75GBD4Q0D8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D13A4600AA;
	Tue,  2 Jun 2026 00:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9912B1F00893;
	Tue,  2 Jun 2026 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780361820;
	bh=T7bQHGZhX9+sHJpAAQcCgYO66iY6em+ApCTpukgWa3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X5mnDEdTO9Je4v7S3JjNNPmfdm02Dpi0LuieTixZSV4wN86PdhIOr3YP08mWc3tke
	 gKSVsPVhO8HO7tn9+hIKGqBVOAJJikTKoKNDZqf16CSCIIGYm9PRunFT+YZl5gt4+G
	 9tBUr5GTXeG+FTMYbyWYxBtuV4qo59oNuVm50OyNNNf9SGYg6tVwtJ/Uc3pwrU0OWM
	 gotfjaTy6wChz5IKDTFA1kWatUy0HEU16usAuswSyn0gyVWjOda6f5c2+JH2pk2EzN
	 UEVvXzZBOej+B4ZkzbzXcwOJgvgTfsIfPOJO1WZFITnQmSdCsBpaWg8K6K6mWUnC6O
	 93RnkBVsJ98tQ==
Date: Tue, 2 Jun 2026 00:56:57 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [PATCH v6 01/22] mm/swap: decouple swap cache from physical swap
 infrastructure
Message-ID: <ah4qS4uE2CBMOWd1@google.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
 <20260505153854.1612033-2-nphamcs@gmail.com>
 <agJcCZuLqWwU_sSR@google.com>
 <CAKEwX=PZnKqfriUsPV2whZyqxfCRNy67z7gyrHObEvztDF0_zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PZnKqfriUsPV2whZyqxfCRNy67z7gyrHObEvztDF0_zg@mail.gmail.com>
X-Rspamd-Queue-Id: 97B9F40007
X-Stat-Signature: 5puo7zmri4x7tgz1478oadfi9e4bown5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780361821-890564
X-HE-Meta: U2FsdGVkX189sZ9pIqiHzaR0DsgTruH7Cd/y6FTcF0BBWbyDugtXSVeV190CUFkU8j6lfNdXyjec9+XrQeep2rS75zuwJ9/gTZYrIXT9MYAiOZPQRTvnDbXZWIEiiujRjzxik6WntaL7qeY9Q92IuK0hEQF78PoSpc7Ofm8ClFqLTG5j5v8PVPUZ4/rIRkeXzM9AmW7x2tL5J16hQ8Y6eugYiLhpScZ9BNlUSfQxWHS/Va8WKsTjWcfkuVI1rs5Yjw9fPFgrejwIHmpfm/Qh8O2UwAfG4HloC9mqXMZx8tYsOltbLDR4evm26af6VeUu5PW+GGoqtp/oJ63jiLU2PD8YmoXh+Qd+NKjcpMmkltTwsq9KE0WWBaZwGBxONdUA/4ffzLfZgV6Ub3Dw/QMUynny0cks7sUtOeMBxl1ECSQ6vDKSGEbRZ7Q2Nc1lxOOiIzVMxrCTLouF1MM59aMiZqipuA+CqwLotaENIxn6KkwlU+W9QxUeaBVen9ov7SHWTSMhRfjDX8cqRrOSf0FIj+8aJW9kCnSgAgsq+yrcHI0WQLwtLUEIhVwyB0PMnYqvtKhjaTKlcS7+FPe8YsQ+fhnCIojf0yddNLjO0s97ZgNEPiWWDEdSf1eBclv+v+PSlqlWpCm+MtykOfY3PVfesBtqXYLwYbVTPjJfxN05jBZlLJMT1ctSB6bYGt/0FKE9YAHDW404HOhTJtx9QBDAPF1vwge73SC/wOOnPU7/ZAi1tO5Uo1c/hCVPzN3yaGamt8fS/clnDYZ2yV2m1b5VQoGHfoIBapJwixD7hyzNqQGtb1BF7Il6J0VdI5eCT78bY7DC+pCTc6+xtVYPDYotwm8H5hq7EKnbHvxrpY8zcyZsJj4mwQOuzLwq1nGCDWo53YbcIm+lcF2vowO7OfnJjjIL8XH8wJ3D9rUXlL6udOnni2Ca+eFUPcgaGajnbjvinu1F9zxt5DYlHtA5Xat
 +bWX4I78
 6xeMyznnhzZvFMxLkKNp/R+rxxBGWzFPtikTH8EC0kyTAlEqxkJ7qhnMjs8CaV6xXA2u66LzZ//c85WObxIdCg1djJHiwX+rJArHq9jYpr4Vi9KkEyQCoTx4OllZFmIYCnqNsfrt8xKdzqk5mhmZu6jMLrzNOtBoSxllteDsRPv8CqpejqVhAqT/9hREuKRA9BrPrNp/Vu2K6QqBFT2CdcRwsiHt24w6kn3KmiUgmkCSbQY8CN6B+f++ULy3yEgOBJj9CH7ZShFYdoM+DLuxK2Uaoss+hQpULDaZPjPlcCl7Lca4uLyNg6FWpcKHUbI7dKv6ueNsn9xBJgWmv2O3TfTIKe2Jgyi/woD+M3DBEmfMvNsnk0aaKo4PA9SLyH6HqBbS/n/wU+1wLUVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:42:19PM -0700, Nhat Pham wrote:
> On Mon, May 11, 2026 at 3:46 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Tue, May 05, 2026 at 08:38:30AM -0700, Nhat Pham wrote:
> > > When we virtualize the swap space, we will manage swap cache at the
> > > virtual swap layer. To prepare for this, decouple swap cache from
> > > physical swap infrastructure.
> > >
> > > We will also remove all the swap cache related helpers of swap table. We
> > > will keep the rest of the swap table infrastructure, which will be
> > > repurposed to serve as the rmap (physical -> virtual swap mapping)
> > > later.
> >
> > I didn't look through the entire series, but let me ask the same
> > high-level question I asked before. Instead of moving things out of the
> > swap table, why not reuse the swap table as the representation of the
> > virtual swap space? Seems like most/all metadata is already moved there
> > in a nice concise format.
> 
> The honest answer is I wasn't sure it would work, so I was hacking
> quietly a prototype on my own time :)
> 
> I finally got something that survives stress-ng and constant
> memory.reclaim thrown at it though. I figured I should send it out to
> get feedback before digging myself deeper into that hole:
> 
> https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
> 
> There is still a small problem left (the metadata duplication issue
> that Johannes brought up). It is potentially fixable, but I haven't
> actually tried it out yet, so I don't want to overstate here. But take
> a look at it and let me know how you feel about this alternative
> approach!

Thank you! I will take a look!

