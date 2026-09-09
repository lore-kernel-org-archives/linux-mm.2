Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C49EC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB06C6B008A; Wed,  9 Sep 2026 15:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51496B008C; Wed,  9 Sep 2026 15:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D294D6B0092; Wed,  9 Sep 2026 15:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE74A6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:13:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0E67C02E0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:13:53 +0000 (UTC)
X-FDA: 85195173546.11.D48C7ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B50A14000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:13:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sp5QCKRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788981232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJQLOIo2F/8mgbaZ6MM/HOKjSOsdGspfu+Rgpw9gTLU=;
	b=QNwrLSU5piVzDVpd8Z49YAe7T3GYyFDREnIskTsLET/YbFTLDnQufpHCq2ziLaST2TPzEW
	w7G/9iDWnpGWmBuCaPj2Ai+gVwwP53r9op1G0wD56nRHMjEfbKzHeI6HFMAeb7PpQOw0dx
	MyMYeWg/eiZ+aAYA9fIXqbN5n/Hip4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788981232;
	b=LYcMuVuiRs2dfHrwsRyLhId8bSLsb2C2eeExXjpTDSbZ+kSQOH+v68Qgvfqm4sEtMBimDi
	7BaHPxw1bu6t0DUnMdH592SdM/siH80sbECrK90dDDvOJNFE2u/StmkepULRwdcoE9DPqV
	cFrX/WI8yvZKonQDtJ3/cZytDEJX5Nk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sp5QCKRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8F76433BB;
	Wed,  9 Sep 2026 19:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789AF1F000FF;
	Wed,  9 Sep 2026 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788981230;
	bh=GJQLOIo2F/8mgbaZ6MM/HOKjSOsdGspfu+Rgpw9gTLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sp5QCKRGqnjtgftM39OzgG9o3glYhC+pUXsZYdO21iDX/IQKGR305FK8SU+gUUHmH
	 EzvxMEEF5giefLVCAKnxpz42h3RhUGy85cUc9rxoEJGDwAFsQuY++Ir25TD3YrKPvc
	 ZETtroFS/VizLPnltYkazT64Q8hGpCzwF1OilDSrkgqiCSCsUYr+x7I5XvlDFMAXZh
	 uLgF1WfYWu/jodY5tkqEjRYJgQS86BFaUfwYL1GL5+TcF06c4VZP9jTTRJEwxsZ9kW
	 auRlwbJEbnWhhoa4ud0i4CrjYK7SZtm8V25+Txnn0PPSpnBVKn1RswiLii/fnSGGvt
	 p05HydOIsCMDg==
Date: Wed, 9 Sep 2026 09:13:49 -1000
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <aqGv7R4LTmlrW6QI@slm.duckdns.org>
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
 <aqGilhgcEd0qaHjI@slm.duckdns.org>
 <16d13239-8911-4597-bfd6-18aa02135137@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16d13239-8911-4597-bfd6-18aa02135137@paulmck-laptop>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B50A14000A
X-Stat-Signature: umhdo9zkgw49jnef3s7zzx7b7ujryobj
X-HE-Tag: 1788981232-202074
X-HE-Meta: U2FsdGVkX1/TW8RB6q+zRe2HUtghori1X31Z8rTRwoiSv70HPX7z63rI9O+JvEPVm3iKX0PbIKCoo+IaxgvAjQ2we0FNG8sfKq6wGKknjp+OWoemjIJgL2I+Z4nPfaNQnFL6HuqT96PD/3YY8pLuoGRDCuEHZ7f+3VtvYkqYY92Jg3bYsJNWN2h4xCRMemGF95Ehd4iwH25S5WBO8Twgjau9RO6gMsC+jZPG+LN5HpTL3d1o/znIzAW3VyafDJxkVkLYXE1JtZXYatzi04hrrTrgte2juDtzN0IWWPQz/KYAtqLF83ZhvkxnAUu9+1OLoe+j7zK9Dz5MBKcCGYDo4MjfSYXLB3mIeZUNN+J1TvYQILfOLmXaQ8Rvpc+vnrx25xWJ1w2fTCftKtG9iFrblEuh4nXKKja9ky3YNP9qvx9gVlxeV6lIqERI3EEiB9Wk8uWofcVLQRaVTPQFYEZQDLs3unsgYc/wVCih5EXT2V2RTnI2mPdRfGUkjjDAqCyhCpwZUxkQs3ASAuQ4ac05VuwZ9rcUH0rpT9LMSv9dYBTKB2ldjQ7o68GDPHkHL+rVhl+mbQ6E4Orxztlq2g3FxTq5pGlFQ5h7s7/28PBArNtv9l886Fc7Mtqo0+TIrmkYxDItgUDyJ2x06xDBV6s0gCZ/ETJrjwKl22oBIBJaDRLfHDuecGl/9zagyt8R2woM9K+PTrbj0ztXxnwRd1TbWIPyyZqAJpkiaSwGGHzNPZSzrG94MOw1LmfoRYlKdDEI9k5GB49UQBcVTTeN26/6sw6QEicbVvhWBoj0b3iPsnSVlSgcAeiQF9DsR2ua7qoZsBMleVxzqG9Ws2HfyO1c5o340QP/eNgEPAVQoE5W1NyqB6iNdj+CFs8t+EnrIQLgdVkIhuC4emEL6bAM+JZR/1PdzaGx3SY9HCd7wldRFchfLqBW9TnE1lW+1fJ0KqzhBZ+t9Mz9rxrzJ0wEcXn
 XI5HcAtT
 UfTZWBBBzIf7ocPCzBr2CuBWPJSUYJ+kzy/PQChWt47WBTOM6FCrr3eFSKTCC9iDfqlJuve4ionxFbIKSYaC69LdZL7j7COYHtHL8wNphcKJppPcdMG9/49P0DygSiB9p5hLAm14zsCk1ZOIv4/FVnDKPBssa/0tam8mn9Tcy/veWYdyBYUKoUGPp/HgTa3kFf/csJTBkNdGn34KJ+C41I4OdH2mQHklBVCTioCOpYqSBjB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Sep 09, 2026 at 12:03:20PM -0700, Paul E. McKenney wrote:
> > The patch looks fine but this overall seems fragile. cond_resched() was
> > already marking "stuff that can take too long" but we need to use
> > cond_resched_tasks_rcu_qs() if it can take *really* long. There gotta be a
> > way to make this more maintainable. If always doing tasks_rcu_qs from
> > cond_resched() is too expensive, can it be be gated behind something cheaper
> > e.g. some tick based test?
> 
> This is the business end of cond_resched_tasks_rcu_qs() in preemptible
> kernels (in which cond_resched() is nothingness):
> 
> # define rcu_tasks_classic_qs(t, preempt)				\
> 	do {								\
> 		if (!(preempt) && READ_ONCE((t)->rcu_tasks_holdout))	\
> 			WRITE_ONCE((t)->rcu_tasks_holdout, false);	\
> 	} while (0)
> 
> This is pretty lightweight.  Adding a jiffies check would likely make
> it more expensive.
> 
> Or am I missing your point?

I found the following thread for why there is a separate variant for
cond_resched_tasks_rcu_qs():

  https://lkml.kernel.org/r/20180224151240.0d63a059@vmware.local.home

The rationale was that it'd make cond_resched() expensive, so I assumed it
was relatively heavy. If it already comes down to a single test, I'm not
sure having a separate interface makes a lot of sense. There isn't some
semantical difference between the two, right? Anything which takes long
enough needs to do the tasks rcu qs, and that is what we mark with
cond_resched().

Thanks.

-- 
tejun

