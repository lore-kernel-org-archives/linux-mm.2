Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFE7FA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 18:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91386B0088; Fri,  2 Jan 2026 13:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E9B6B0089; Fri,  2 Jan 2026 13:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17706B008A; Fri,  2 Jan 2026 13:21:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0F306B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:21:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52CB01A0925
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:21:15 +0000 (UTC)
X-FDA: 84287840910.20.2962168
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf21.hostedemail.com (Postfix) with ESMTP id CC9311C0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:21:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK8VVwTl;
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767378073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HbQAOnXEOXuo4VPboQfFJ1oE7ZW8cXxVzCFf9i5LVE=;
	b=Xs+Z2M7yDp2wZhs2GC5B0Rm+s09AsM0NU5UEOW9xAxGq/3zcZgcYWpbcYigPzSCdMFFS6d
	Iwefq9YxDTBdXpL8yetNRuYHcdQUsnBpzXJE1kDReJHgsnmswHfnysqvNaFjSJBm6+iM2b
	ErlPqMvRjwn3kIlzayni1Z8B02Mkog8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767378073; a=rsa-sha256;
	cv=none;
	b=2/oL0ZwDmnVBX4n11ZdHXprN4dlypjM+nMeh51CfJutlkbESZjpLULMMZ9itW1rDblNnIA
	IQ3SOHQDXFa3ZmTBIj5Zc7o3un0eWta+sRhRg0rJ2cvpEth+a4ovwICxcBa2JBOnTK9yCF
	O/CKVgYc1EmnPWvr0WIJ2yfAKEQt3Y4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK8VVwTl;
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 2 Jan 2026 18:21:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767378069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7HbQAOnXEOXuo4VPboQfFJ1oE7ZW8cXxVzCFf9i5LVE=;
	b=iK8VVwTlkX2pNH6Nkz7FyutiDaJsPCGY+EPeGBfLJ+CW0CWyjitl5drLDamwF4ECWu2FBE
	74mpR8FM67plEauq++o7cM9dfpN89zqnhqPYOtOu4iUjIh82wOm4jN9iL013DAPv86AvEB
	ruC5wnPi88v70fEYDO40hwRpRFDdIOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
 <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
 <llwoiz4k5l44z2dyo6oubcflfarhep654cr5tvcrnkltbw4eni@kxywzukbgyha>
 <wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5>
 <63c958ae-9db2-4da8-935b-a596cc8535d3@linux.dev>
 <xlvmvjieqfltqtf5y6y37elcwstrhs6sp7qco2npgucdd4ggus@icfvpgxrwljl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xlvmvjieqfltqtf5y6y37elcwstrhs6sp7qco2npgucdd4ggus@icfvpgxrwljl>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ihwgai4nw1gdaitrpuz9t633ddagrujz
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC9311C0005
X-Rspam-User: 
X-HE-Tag: 1767378071-120928
X-HE-Meta: U2FsdGVkX19Bv9oZ8Xs63Ar2w0ryPBuqVpRnpQzvn8PwtiRjvrUH1ZvG+baZdT1MccFN5mh3e71PtXvXYSJO6+KqAxCqaZ0yN7d5HeG04HOD/0T0eu8UIO56bowbLvgLaLS/ROhoKSANs04JE2ksHn18If+aG8gUviVjMqFDMEQnzefwCyiNRWEgDP11V3CnJQXdyJKAU+BDbfPNQCRMx2oqAa97khHIzGIbVd2XFY3cvuj0JJXQAhGMwWLmb0YEEpMQIEcy9VK+t0GXNABkvrnAWqc7Ma6XbGwMmNSSWgiXizHSekin1V8UhFgxa72yrFnnkeL+Jczl4fdV6nqKsYPXefNiOwqKS3Mn1tW+wWswiAopc7h7fkaCPVfFWyt09kZq8UkW7gHHTD3kEISnQPRIM8TX2iUCaVxJU1Avjs35bs2356Vvm3xkNv0ZwDqiSkGMJoi7Etm+co5tB/p1jAlsspIUKhVMjpT/VE3GSgnVYY4J4Cz2ZjAA2CqEO5X9D2z1rnocCRG+IVrBbl19TAVGkfjKZRnaPgxtQp9s6WnmHaYp3p5XJpRAxxEn2e66xMyKAq9MBanygh2ORT4yhTVmm/MGREwndxpN8K8FXcn7g25QQ+HreW99il4nnMN4+61OqE4r67ddRAzUZ+0H1XKEHT7yni06mwVO5EArQBfD4YlJf06W+IRWsPwW+51jwKFGkmZv07lCr0XDeKDrjGUVHsqWsuO590MuQcgxcDyUqYdFrYtWS+2ds26aNElz4oLBEJJkoDL8pZLZmW5Yi4aUG7vO8z8nYlUJ9VoQEMOixCfyQFcr9BxWsraqSpBUl1a71gSElNmlCPH8M9Pb9zRP9UoUZVeG8FgjQStDX9B7o5yQXOaSRxdQsPqx+SEE7DciMtGqY7aeHRSF6uH2WVM4GGK5BHGDT1eOvDm8Sk3iIkuda4YP3tLb0FFZcDxA44df4Vbm55Ba7/6KEST
 drwpHDCk
 npMmQqUsg8fbJzOFCOgW49WMGtr/tAeUEoq3gDgs1JJIS3NH9AFjZIJ8KZB+/DBOx+oW/FLGHg6xS07sxJTQhIyKbcZeDG+LXJv/+0HHdBCHDhDsqObY/GKPcQduJLHceQrvz1mGLrL55PAa9gTBSecojTSpu2fk/UxA0JRbfTng9uu+0j7MzVVse41trHuqHEWoOJWuHSZ6AdNobK5nTHt9iVjAwFCWmD/U9yh2Anfxi0ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 11:52:52AM +0100, Michal Koutný wrote:
> On Tue, Dec 23, 2025 at 04:36:18PM -0800, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> ...
> > The core stats update functions are mod_memcg_state() and
> > mod_memcg_lruvec_state(). If for v1 only, we add additional check for
> > CSS_DYING and go to parent if CSS_DYING is set then shouldn't we avoid
> > this issue?
> 
> ...and go to first !CSS_DYING ancestor :-/ (as the whole chain of memcgs
> can be offlined)
> 
> IIUC thanks to the reparenting charging (modifying state) to an offlined
> memcg should be an exception...
> 
> 
> On Mon, Dec 29, 2025 at 05:42:43PM +0800, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> > > We do reparenting in css_offline() callback and cgroup offlining
> > > happen somewhat like this:
> > > 
> > > 1. Set CSS_DYING
> > > 2. Trigger percpu ref kill
> > > 3. Kernel makes sure css ref killed is seen by all CPUs and then trigger
> > >     css_offline callback.
> > 
> > it seems that we can add the following to
> > mem_cgroup_css_free():
> > 
> > parent->vmstats->state_local += child->vmstats->state_local;
> > 
> > Right? I will continue to take a closer look.
> 
> ...and the time between offlining and free'ing a memcg should not be
> arbitrarily long anymore (right?, the crux of the series).
> So only transferring local stats in mem_cgroup_css_free should yield a
> correct result after limited time range (with possible underflows
> between) with no special precaution for CSS_DYING on charging side.

I don't think this works, unfortunately. Even with refs from folios to
memcgs dropped at offlining, there could still be long-living refs (e.g.
from swapped out entries). So we cannot wait until the memcg is released
or freed to do the reparenting of the stats.

I think the right thing to do is, as discussed with Shakeel, move the
stats at the time of offlining after reparenting the LRUs, and forward
further updates to the first non-dying parent.

We'll need to be careful with synchronization. We'll probably need an
RCU sync after reparenting the LRUs before moving the stats to the
parent, and we'll need to make sure stat updaters get the memcg and
update the stats within the same RCU section. Ideally with guards
against breaking this in the future.

> 
> 0.02€,
> Michal



