Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FAE4C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D136B0088; Fri,  7 Aug 2026 15:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F386B008A; Fri,  7 Aug 2026 15:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454856B008C; Fri,  7 Aug 2026 15:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12A246B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:10:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A1171C0202
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:10:48 +0000 (UTC)
X-FDA: 85075415376.29.653206E
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C3D62000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:10:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lub/0oAM";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786129846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCEptNRU1/sT4EeCLaaq6ras0jXi+prulPBFZsJWzg8=;
	b=GApb8KR8aa2qIXZ5JoNHyVB/u+2JrB7RAW8JwaNUo20yatHKSXnZz6xOZk/d6rVge+3rRy
	fDFOa/i4qbgrL0SYHyUajcaE+IKjd6t7mdo6HCKug0rGbfALkU6xvF6DTjVOHABSi+YoLU
	6djD7KkdDMToSbUFss7DHSaHYdmMD/Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lub/0oAM";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786129846;
	b=H0hDI/sO6+RTxvmIyD0rFpM9f7ATk87c4ZZ8WI4769oyjyH4HkpM9pOWKf2Yqw4AKDwfnE
	JFguOwLOOoSKX4gMLMgCJsp3xZniWTOxFvsQfLFzSReuHYpiUGhZjEBdG4scRaiuhvDe+u
	wSeDL04O11H/DDVv08QWiGgfYVeSxRM=
Date: Fri, 7 Aug 2026 12:10:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786129844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PCEptNRU1/sT4EeCLaaq6ras0jXi+prulPBFZsJWzg8=;
	b=lub/0oAMZ/BfA/OhRan10l0mip92hxY0WzguPVfbO1Cdn7f7keLyKEEB5V1n9D33SLhKlC
	mdhx3EDFS736L4fM6ijybNLHtLOubSwUc5/1laOYT8p9QX2Bzs7Zr9K3P8PGx3pp3yX4od
	RvFOscDgbmV+WQ3PgWzqn44CV+KE0Wk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Audra Mitchell <audra@redhat.com>, david@kernel.org, 
	jocolema@redhat.com, raquini@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYr6UIi1nevGJkA@linux.dev>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
 <anYoLs1B0MwUNR2n@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYoLs1B0MwUNR2n@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C3D62000E
X-Stat-Signature: k9z77ksxp4dgye53r3tc9w4hiyddtsrk
X-Rspam-User: 
X-HE-Tag: 1786129846-993691
X-HE-Meta: U2FsdGVkX18j1ZgBDo0U2c2OQOUygikBkBYaetETpOAwEijY2AeXTgxtrfzCsjOqYf/mtP8NQ/f6tjSc0PKmeC5hIvAsCoOtAWB3cfhB9zxHL/2QjqrHK3QoG6Dhh7DHJ4kHO8BMsfWTBNXbaUHXQgfIg0AO3yEJGL9RBoZL2wf695WoWqBiS5ati9NMYbLrvW4E/duV9lULc3daz25I7OAjM0m7a8tYI7d34qSBxriwY/IWNRQFfHxRCamr9GADxMnHg+Rz8fXoETS7X+eiYBAwJMcuTcOTaRxKTT9KPKaY7Gc1fCsQq2zggM3RGbA6rC1uap7jITndiYcvr60/whnvoPHzY7idfaliq+UhRPcHpvPfQ/1QvZaq8DhPeFgBVxmS9a8mG0xOwu7AUSmuMSPYtQDVH1GCKrG8ea8BxKLPU4H0WiS/90kFwBtyUV9t94v9yaAEyLdjHQtyob6CCkRJG5ZwLkrSJLZwNgyHIsr0B4/uNeLSGH6eNNNFuHY7yI7zOKDy0l8jFJoVYoHrlFoAzPO/B5ayhh3azwsFh1cG44y2dxIm8QGqFWmn1IQbbAc+0IH8mLHx29Nqh3PYgiuz+UADIwS0jzK7nHxXgLsY33a/2CwET6QpB1W2ZTnFEoUyD3zWdJ/ZFGE8+ND330S/o4Qwmy9oeOBVvNv60hX7HKGYRu6M7WqpHCOMzNG/XgYD/f2+k4omre0az07N6tooJy4NHH/qn4zdaNmgp0AyN3xeUl/m/h/BOkfUaKv065n8UqyMQsc7b2j5g8hHqp/hQPN+PXUIkG2q6EqB35mB4iQgdM0WUV8sx/h4R22JB8bOqM0xzeRWB0L0PhGUKqSEc8szShJ3ETTtLYeGRW5EeJxYJa7I5K7zNqwkNHl68KWBM5EOmGN7YmUgriEyIlw/bNmhTZeD9fbrYBRvzZ31uqwlDseXPX9y5+RVGN37biupBx0TgOBRdjDTtOF
 n7Kqk3lO
 wyG2U51i6iCF5tpl2dVJuW3vHcW1XXbt9nncRiUQ0Y2MdAXyJTAzNlw34vsNhyqn99Kuea2w6VTqoy5RkUtHXBWAxf8S7Yl7XmU3i9WfEuDQPk+yyC2513/EyyNb0MKnFmVEtG+Q5xoP+TGhjXsCFRKKaImcPo3RTFaBjmD5YUfHANRlyYECMvW6A7VjDVqaEVRATaoZ7FTmBpYiJQUj8KbA2OGGQ3jSiqACDD0tp/uw1uiqBZkRwjziDICxtMAhJZMoi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 08:47:10PM +0200, Michal Hocko wrote:
> On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> > On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > > > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > > > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > > > a retry. The purpose of nr_retries counter changed with the introduction of
> > > > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > > > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > > > to retry within the desired nr_retries threshold. Later d977aa939fca
> > > > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > > > nr_retries counter from 5 to 16.
> > > > 
> > > > As the function has evolved we now have multiple paths that have a goto retry
> > > > path and we have lost the original purpose of the nr_retries counter, allowing
> > > > us to take a goto retry path an unbounded number of times.
> > > > 
> > > > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > > > nr_retries counter correctly.
> > > 
> > > Are you trying to fix a theoretical problem spotted by the code review
> > > or is there any actual problem that you are trying to fix?
> > 
> > We have had some customer complaints that performance has slowed to a crawl when
> > the cgroup memory limit has come close to the maximum limit. In those cases, we
> > have noticed that each process is spending a large amount of time in the direct
> > reclaim path acquiring just enough memory for their specific allocation, thus
> > by-passing the oom condition yet degrading the system's overall performance.
> 
> Yes, this is entirely possible scenario.
> 
> > In the global case, direct reclaim is bounded by DEF_PRIORITY,
> 
> Well, both global and memcg reclaim share the reclaim logic. Both of
> them try to exercise all reclaim priorities (i.e. check whole eligible
> LRU lists) and they fall back to OOM killer only if there is no other
> option left. For the global case should_reclaim_retry is the gate keeper
> around direct reclaim retries while for the memcg we have more or less
> fixed number of retries.
> 
> > however, a cgroup
> > will go through the try_charge_memcg path which will call
> > try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
> > times).
> 
> > If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
> > attempting to reclaim. This patch is meant to address the unbound case, limiting
> > the loops to 16 attempts at following the direct reclaim path. An argument could
> > be made to reduce nr_retries as well, but given that the nr_retries has been set
> > to 16 for sometime, it seemed unlikely such a change would be considered.
> 
> As Shakeel said in other reply, this is a deliberate implementation
> decision. The OOM killer is the very last resort and we are giving
> chance to userspace to handle close to OOM situation much more
> gracefully and also workload aware. Keep in mind that what might be seen
> as a slow progress for one workload might be acceptable for others where
> OOM killer could mean a lot of work being lost.
> 
> From what you are describing above those users might be hitting reclaim trashing.
> I.e. last small portion of a reclaimable memory is bounced back and
> forth for the workload to make tiny but steady forward progress. While
> OOM killer might help to stop the suffering and restart the workload
> sooner I would generally recommend revisiting limits set for the
> particular workload.

+1 to this. Beside memory.pressure, we also have refault and reclaim metrics
in memory.stat which can further help in debugging if the workload is thrashing
due to workingset larger than the limits.

> Especially if restarting it might lead to the same
> state sooner or later. Watching PSI metric would be a good start to see
> how the workload behaves wrt memory stalling. User space oom handlers
> might be a proper measure as well but that will always be safeguard
> rather than a solution.
> -- 
> Michal Hocko
> SUSE Labs

