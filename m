Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB99CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0ACF8E0060; Thu, 21 Aug 2025 17:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBC68E0056; Thu, 21 Aug 2025 17:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2238E0060; Thu, 21 Aug 2025 17:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C89B8E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:33:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38617160559
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:26:53 +0000 (UTC)
X-FDA: 83802049506.19.5D97F33
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B177140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:26:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nRBfV4DJ;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755811611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E24ReIpbujFlBQVR2Mugo0ODX1BdUsz5lvQufosPcvU=;
	b=2/Nj4BOEuMR1Ez4U3rzAY344b+b6aLQ63c1oFF15Qq8Qz1ruKHWMmo9ouvkjpZQJ8l5mDn
	a9ZHB3m7kTWOCKTzEKl+8VB5SianVZfUJMs6B6KSMMluyD4kPYg3Pn6U927oW23w3MwYKG
	9WKDrLNsCG2kGmmbqAGZzFjPL3yGloQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nRBfV4DJ;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755811611; a=rsa-sha256;
	cv=none;
	b=PXCbeoi5Gkx0ukrbDj7ilOPiQtSME5t9M3uP+WhXdBPKqZEJkktmNr6gTVgAUB23Cz3rWO
	ubyk97stDlHjh9FGs4j02Gzm3hvYCLpRdp7Ma77tcLf6UnwiL5hhOTWrus7/l0B+vKoEKL
	ukCQ6Kcf3ZVQmH73ZolmoQHCMZ56jrU=
Date: Thu, 21 Aug 2025 14:26:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755811609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E24ReIpbujFlBQVR2Mugo0ODX1BdUsz5lvQufosPcvU=;
	b=nRBfV4DJDNoIQxkoYBSQaChCTGmadsYlnewjDld2fzur0xiZxZCR/iIA/nTBsZSlaCUsRD
	o7gv6ZvYoAW2Dd2KVll7GoWVNKIZ/xul1ll5zKJy/6oKf83OZSROddfyGH/4ztARr0P4Ng
	0OI0MZlVkdbGJmflc1julyPOZdZxdaI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <gxildlinmmimk7rd4olsz4rstsiapttbjbtbtzbekrmfxbvuhh@cmio2ckbyzxn>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <CAJuCfpFKNQrjtoctVt0N=r1cABeyPjpwrzP6M=OTpp1Rq_0QaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFKNQrjtoctVt0N=r1cABeyPjpwrzP6M=OTpp1Rq_0QaQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B177140003
X-Stat-Signature: 4uu61zph3u6e9k8xc76sz3x8u1dmb5au
X-Rspam-User: 
X-HE-Tag: 1755811611-441232
X-HE-Meta: U2FsdGVkX19VkBSQ5E343oHZeSNspYbMLlE+jTanMKughELU8qQAXwV4bE3EHZpE3GTqRIvlZ57Emkp2cqAL851m1JUOMVJ6OMvL73iYRjXbw++nkAOZZogX14RZ3Lo4Os0Cunb31iS28RC+pUi7gKJwsDOmAvzjFyOdQVcCyciNDcrOT3qsrcnRYH34ofy4Q+/bxvEE6OpsKF4oBD4+NabklSivzzJiA1tF0xbuTEsjwIOOXOYPftSfLQ1aMC44I3Lig3EEkj47u5rolRKeLDmBw3JcXdAywkvrHGwd9h3zTHm2wmtCDYQa/dfZguarYKY7vLEXNxpTq/cNm0y5iBIcSc9Ig5q82NBwXeNo+6Sz4lkYAzAeSa9ETbimYhuEdqD/j2gQzvJ5g21C13yHvTtDfJgvGUUuJlu5GnVhl9q/fAjpvnBAdE6R3z/01qOmBXsnxql7l5mqwdb73yKPCxfht668C4jiAc2rlRPVIR3BCqYJzdbIXSsG21Nffqon7zOgCv8gyM5uH79qCcBW1p6xYg5j4czXpA73F0VmbpYINR5jnaDp7bdxjYzUq+9LReJvEs7uGqs1B4MJ/y7L9q9AHmaVy/ygnKn8kkHxiP36ew6p8R+z/tfSBUKE6lAkcm7sY8OFPoUGbsOlEmHD+78zQAes8MmueKF30lA7H5C7rG1PP9pnpHhTis86b2SXpaWXeq//CVLctJ8a2PiLpS98uvHFlrxYp4mQkfNurKoishJ0y4pT1qenIPyKOAgc1+W6LGSwQ7Xqrq0LCgtScIx3x7CQKQyMgDEl9fkLTiCAKXo2jMxmpIfT9bOltqf5hVLbcro8V15YpwdxmW2dcgTCxZN+ETwKfzUW6sf1MjtTp7x0+6xn40BdCmVvYOIPG6e6E3bKZ50r4u6WlMbSanMyo3yjbI/9ZEw3JOh2Ac3EL5lxv9o6uuRZvGGdZlOTEVjmGWymoVz05KqZBTT
 Nj/KrT0D
 B0Po/nK6m0eNh7nyxsX5CEWj0Dko13b96kZyo8DqsyFXBBYdlq3nWPVl5oAHIxu7cp1V8WRMUM1oHjCDNC/9w7GGO147q8hX7gbeZaTwWr3qZ4fjA/L+C1yi4C8YiEGOn47yRJy/I/AcaBBmkH9a8k3bcSH3mbYgUFhrpIIVZulDge/36V8kPXtNG2LKqIevGV+0YvUuD0CKjG5+h4VFbUKr0dFGZ6aWvUpte644hzC3Wf90Xe6TejMIR0EtdpR3C01tv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 01:00:36PM -0700, Suren Baghdasaryan wrote:
> On Thu, Aug 21, 2025 at 12:53 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > Right now in the oom_kill_process if the oom is because of the cgroup
> > > > > limit, we won't get memory allocation infomation. In some cases, we
> > > > > can have a large cgroup workload running which dominates the machine.
> > > > > The reason using cgroup is to leave some resource for system. When this
> > > > > cgroup is killed, we would also like to have some memory allocation
> > > > > information for the whole server as well. This is reason behind this
> > > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > > information for people? I am happy with any suggestions!
> > > >
> > > > For a single patch, it is better to have all the context in the patch
> > > > and there is no need for cover letter.
> > >
> > > Thanks for your suggestion Shakeel! I will change this in the next version.
> > >
> > > >
> > > > What exact information you want on the memcg oom that will be helpful
> > > > for the users in general? You mentioned memory allocation information,
> > > > can you please elaborate a bit more.
> > > >
> > >
> > > As in my reply to Suren, I was thinking the system-wide memory usage info
> > > provided by show_free_pages and memory allocation profiling info can help
> > > us debug cgoom by comparing them with historical data. What is your take on
> > > this?
> > >
> >
> > I am not really sure about show_free_areas(). More specifically how the
> > historical data diff will be useful for a memcg oom. If you have a
> > concrete example, please give one. For memory allocation profiling, is
> > it possible to filter for the given memcg? Do we save memcg information
> > in the memory allocation profiling?
> 
> No, memory allocation profiling is not cgroup-aware. It tracks
> allocations and their code locations but no other context.

Thanks for the info. Pan, will having memcg info along with allocation
profile help your use-case? (Though adding that might not be easy or
cheaper)

