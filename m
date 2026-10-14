Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8112ACC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2DA6B0088; Wed, 14 Oct 2026 15:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB4B6B008A; Wed, 14 Oct 2026 15:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24EB6B0095; Wed, 14 Oct 2026 15:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4146B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:36:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FE978068A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:36:49 +0000 (UTC)
X-FDA: 85322239338.09.5202814
Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	by imf30.hostedemail.com (Postfix) with ESMTP id E25DA80005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:36:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O0FuYSjL;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792006607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUW/SeoKh1LoozjH5WtWW+2Iglz9/K7JlwN/AnkZvIM=;
	b=uLYd28Da4mmGeLI1V7l+25jcbnkm+1vcWIN03KxwSD0RgqIlb8xTYPR91MVooOhGEFNt0T
	NA6Od7GIMmmNLzKf8jhQUeGXRVbOofEwCTaKusK3rKFaBJqUkT7iVJq3+VhuxO084/fuCK
	jKcqKTgRFy/pC1ZU7ziS3jXz3zvCMbs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O0FuYSjL;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792006607;
	b=C72vgajCvnrl9cgdzKFvB4tP37nt8zJnCo8+ZFsf+F616vjOpZo+HeKhh2dKLtxMhLuKde
	ctnD2h2NwalefdH7WhL/67oDDGYXqtwAD7xthzwuJ0SqpbdFojkN9SGILPt43IbcMQzi38
	rCXx7wpcLCD1TfM9rM+ls/2tow64X1U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=083C/YHtNGmiDsCLg6a7weM6tlLUgKGnnJOHmEI8Abo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792006605; v=1; x=1792611405;
 b=O0FuYSjLj/WmJsRWZxJpXbDZ3KrpA8OMFnQe/yrP2TTG/fGzZpG72vj3ZucIPIjzmSM6mVoW
 tzt5z4Z92SmkqdQl0Afm1cdzifmeKaUcde1pYP05WbjLxIClEQzwZ6HugLC9tteQ/JCThlB7zNr
 O8uFTml4zFu7OBv0AS5HQQKc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5208ad6ed7251eda;
	Wed, 14 Oct 2026 19:36:45 +0000
X-Mizu-Trace-ID: 5208ad6ed7251eda
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 12:36:39 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as_ZNUcBwNHnF_jU@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
 <as-08j9_1C2F_N8s@tiehlicka>
 <as_AxtUlV8K2fkNu@linux.dev>
 <as_XvRZzV6vR9dCo@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as_XvRZzV6vR9dCo@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E25DA80005
X-Stat-Signature: pnscrdafkjrbrmix9tiyd3dike5rd5e9
X-HE-Tag: 1792006606-630991
X-HE-Meta: U2FsdGVkX19tihYPVKHfwyAa71uczl1w6U8nRy4A4fcZMNXWctD1GC60+VIXp8ZwCNfv9PDO+uOnUMtVVuIvOmJokJKILpoHpw5HFhe6r05AzujU/TaJNr9gRTG8L8b1uxjINZzzXlHM+4h1vHbm612wGNGGG4QFORL2YFyOpX/+mE8xoDc1cnxjgpDw2ih1y5YweXCP9isICoICUblbCOgWexKU/lT7uf3szkfTUM3XlwSGelMTQe82p4SeywHfG6U64RyFUf+u6BuWdl9Qv4XVQw/oDnWre7pfGXz/Ns3tdCdP4xIFTQhfwOBU2Fj1F8zrAYaH8j4rVd4voO4BZO6Ps0Pccw/egq9FbYc2ePSXibMchQP/7XMX4tGmUSmgc9pfH//jBzLnTComAO7hkFGeAcMMhJArnBGUPmCKpSRX4xqEKuML7BqpcWSnJRbxLoDKvTqhxC/gg5eSHr5WxbSycPUi325+doKbnHBScplLAcVw9cdJ7lUphf6JV8Ul+Gwon/yxCYnUyw3jikN0X3VlpFetJmZE9/ltI+GPRFBnp1t+jYrowed57u7OSeF9rtDaFU3CjCS0piZQ/I1vq3xjiAq0XP7kYhkdjoubmsUe9B9Topit9rXOYGbIs7rTddgJ/+BzEEbqXrQVO6FcpAFsxjg36yRWxfzyOYDRTmTHJH4aa5oyu77Bfu02KDqSVKUWvFlOSIDdLiTQxpVIIi/7Vw+LD6ubCxWMybuxypKw7Xe+I7KbKGBi0u56HB8FINrmzRW97chI0EmZoafF9edQmIyCzqqs6i1FQzKIHZbT+u2/q1yaACaTVLlt2niUaD7CVjq+o641wdivCwixmAexZaYmRK7nwwSIqaRFbLTGBZH1llpF3Cp7KTMFl6OhJP5oCBjZfirdTkP+yl/ptPz+7463jBVNHVEjper0TKfikPQikzHwatgzio9+t2+aDxw3IuhkxXtiFbD9nBQ
 8WOEti3k
 69uxKGbIoRIewRnllimoN1xylLrkEksr/qieRAtI0AzqkkQ8YI0Pr1vcgPlSFj9qWUy6gc4swobiHAtrN0K4TJL9XQgozL1apTgbgjGBx+Y1azeVcmyxJgXbSyI80F4A/ugxvHNO2MDrKiQ024Z19Xp1hzfPceb5T/hv/16o0EiBsA7M2mElMkdduee6yXNRJJnfyar3TlNdGQDYkLGyiSLsdwxrIQv1Xxso046gUtNKYrVgPhBAbcdpypal9gUhNPjDcxXDHN57TrrlqO2voXwxnM/1Zaf7YTgeE6A1ZHdl3yV38glnyB2AVUW0+Ro83hhNU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 09:27:57PM +0200, Michal Hocko wrote:
> On Wed 14-10-26 10:55:21, Shakeel Butt wrote:
> > On Wed, Oct 14, 2026 at 06:59:30PM +0200, Michal Hocko wrote:
> > > On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> > > > On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > > > > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > > > > Kernel threads and remote chargers use high_work when memory.high is
> > > > > > exceeded. Their allocations during reclaim can also charge memory,
> > > > > > for example when zswap stores a page.
> > > > > > 
> > > > > > Without a check, the high_work worker can queue itself from its own
> > > > > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > > > > can queue another run.
> > > > > 
> > > > > What does that mean really? Does this delays the actual run?
> > > > 
> > > > It will not delay the actual charge request. This mainly means that we keep
> > > > enqueing the high reclaim work even from high reclaim context and can
> > > > potentially keep wasting CPU if high reclaim is not very successful.
> > > 
> > > Hmm, so is there any practical problem if we do that? What exactly do you
> > > mean by "keep wasting CPU"?
> > 
> > More specifically if high_work kworker keeps enqueing high_work, most probably
> > the memcg does not have reclaimable memory and keep retrying it wastes CPU.
> 
> Yes but this is not specific to PF_MEMALLOC context, or do I miss
> something?

Yes you are right and you didn't miss anything.

>  
> > > > > > Skip memory.high enforcement for charges from task context with
> > > > > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > > > > threads and remote charges. The memory is still charged. Interrupt
> > > > > > charges keep their current path.
> > > > > > 
> > > > > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > > > > without this check.
> > > > > > 
> > > > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > 
> > > > > The patch itself looks OK. I am wondering whether we can unify the check
> > > > > with the existing one which forces the allocation through in main
> > > > > charging path.
> > > > 
> > > > The force charge (and ENOMEM) paths bypass the memory.high enforcement
> > > > altogether.
> > > 
> > > Exactly. Isn't that exactl what we want to achieve here as well?
> > > 
> > > > Only successful charges (done_restock label) goes through
> > > > memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> > > > will still be a separate check before calling high enforcement function. I think
> > > > this check is very high_work specific and better to be in the high enforcement
> > > > function.
> > > 
> > > I meant something like the following
> > 
> > Oh ok this makes sense. Do you want to send a patch or should I add this in this
> > series replacing the 4th patch?
> 
> Feel free to take it. I haven't even tried to compile this. Just wanted
> to show what I have in mind.

Cool, I will resend the updated series after the merge window.


