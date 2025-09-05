Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBD6CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 20:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B13F8E000D; Fri,  5 Sep 2025 16:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188768E0006; Fri,  5 Sep 2025 16:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5D48E000D; Fri,  5 Sep 2025 16:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE31B8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:32:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8346485AB6
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:32:48 +0000 (UTC)
X-FDA: 83856345216.12.E34BE44
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id ADC45C000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:32:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GwuKnZ1Q;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757104366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AyfEn8B+c0G43yV3f15K2IB4WQxXM7vj7uTX34Cb+1g=;
	b=wz1DJ+oi1kPBidAbONa+2w3myN7/miIsqFz9zvA+Fs5Z508DDD+R7++ME8p0e4MYnFxHQJ
	VTnOFrgSnii/32Dn+RfcB7ukqHhz2chofoXhx1yNYoWGDzTjoCWV556WwIGTIpxbyfvk4j
	5cMI+Pfy0IDkXtNgXq+nZRmAofT3/Jg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GwuKnZ1Q;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757104366; a=rsa-sha256;
	cv=none;
	b=7n1VZQ5m66903MBZ3IRHyMMH2srfj7ELflP6IutG05nz7SIv+3JKkioAb0o4sXbaNTCjRH
	zuI58D9Lovm3SwZawEWHK4sgfR9j3jcM7xLZnA0G9GHZlahixVOAD328ojRYGhS3cT0rJW
	tRyPHbMnc0kIj217T+OtG5i0E3OvLvo=
Date: Fri, 5 Sep 2025 13:32:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757104364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AyfEn8B+c0G43yV3f15K2IB4WQxXM7vj7uTX34Cb+1g=;
	b=GwuKnZ1QSCPTMJoMoIiY7p23MG0pZ33rT0JAp3AsQt8zRfdUdyaEzZtwz1eHBeC+um7ySV
	XOsxLQxP8FYjFNTZAX19Nfljswk51y5K2V9ZrOXnl/jcjR4sFhJl0u2CgHHZukammG7N8Z
	Ictuh1klL4pPWTS9PyRS07vIU94be+c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peilin Ye <yepeilin@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Skip memcg accounting in
 __bpf_async_init()
Message-ID: <xx5wmuwyg7a4ck744hbgr74m5lpuuwjeh2l66gat5322huvtbm@zy5wexffh4r3>
References: <20250905061919.439648-1-yepeilin@google.com>
 <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
 <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
 <aLs2sV72B98i3i1Q@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLs2sV72B98i3i1Q@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: n8wia1x16icxyaxb3fjnx8iuzu7e8dad
X-Rspam-User: 
X-Rspamd-Queue-Id: ADC45C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757104366-455289
X-HE-Meta: U2FsdGVkX19PXiUXU6mj6yaS32pulc/P6M+Mk8nn/YsAelI9lC88rokbhH1z0lUPNwHJzdNdLA7jKf12FiNtmrYttY0GddZJRsl1SRmbOGyC+B+r3m+2QdpBnovyExvcxFZjcDq9Y6ojNFJpwii8GHFkwSUQN9MeAvpPSEpja5ZniyOrQ8nkHP/tm73hXQyamoEyHumqrwGrbJEFYJd8txDPOayaVLc/i+SZ2aWk1H0NA1VH7q12X8WW9wyz4tTkv6NgzVJUAgVafEySoakZg+hDr6GujMDEDdHBpSY+mVLVMt0J4fCEpzqH20SWuJrWaY0Cu6rEi6G6wdX6LoJcVNngLhRYc+8wydC+SDC6Go96k6K4D7QGYflKFiasdqknCtq14UPon+h/3qiYGPVa5CXSIqy4mV2I3biJaHcM5tbaphj6gfyYvlZVdIazwmKBxL9gNoafHQJvkm6tN6XuLoH/+O3OVpvFmzdfHUWGyuM9MoZpDUspdfQmfs4uPMoE5ZVZn7kjaQYNuu9acdHC3srvnu7A7zrGR3kvj3IKOLZXjkoOdCfxH2rm5OHHLOoumPRIehabnVy/m+hk83yT3MML6z42QofbYJ5POXGd9MD+N/EAI7vOElXc7vGWRETZbFc/I7rq0fpsGzMyPBruGSL634rqQqrk0zFyC8lq2MGg4VIDsYBRbegLc1ivWOlhoVh+nC3QSsGmMzzVD/2bHG8llnKPI3bFrShJwZh/WN4AZdTo+zSyQun9pjefuWvrbyhqW8YZQU6vabmy9LKdUOZuHZls4iRFSUiuFhctQ5yar1/gVNEGRYdXt6/Bw4VPiyvHO52z7soUHhRWOO9C5HMo6tAhzqUAb94yezGvwXk+kp3JDgR7FnihqAtcqS3I33R/kbHZglIXBAMuV02SdQSk9fANzbNjx5NPM3mwa1UxOi9Iw9mDVGa712Wzjpa73DwpbmX90BizTeSEGLT
 udZWGohT
 pvY0Ac5u00I0zK0caeZzfKOwdDuYPIixx6dwMqDSI2p6ztxwbkorS+AMO94yQ1eqQcNtNLHrLTpP+SoZv9Ey5ApBx3IhDVEoWYam3djp99XA3be8Gn2GQD23aUJt/kTM5kKcrKx746HW6aQBt36Wy/loj/MNpZY2Goh3dPCLKqkATAXUJ9XZV5ygYqTUC6gpmKGTz/UP5wCVUuffQTMgJ4MBQFlhvs+D1DsETQKG3VrLj06JffKdJTMzvwWytpu10Fi68W2Nz/JJUOjwvPzjqR6gnzuUmuABzYnyNvndQxMWm33u/ymvVDdEaMx8fH6/aWkQoJBKamXFB4ZUMzUd3L5FgjAIXDUcWYrHhlrrIMNiS+6v040hKinRu32zLr28M/F3i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 07:14:57PM +0000, Peilin Ye wrote:
> On Fri, Sep 05, 2025 at 10:31:07AM -0700, Shakeel Butt wrote:
> > On Fri, Sep 05, 2025 at 08:18:25AM -0700, Alexei Starovoitov wrote:
> > > On Thu, Sep 4, 2025 at 11:20 PM Peilin Ye <yepeilin@google.com> wrote:
> > > > As pointed out by Kumar, we can use bpf_mem_alloc() and friends for
> > > > bpf_hrtimer and bpf_work, to skip memcg accounting.
> > > 
> > > This is a short term workaround that we shouldn't take.
> > > Long term bpf_mem_alloc() will use kmalloc_nolock() and
> > > memcg accounting that was already made to work from any context
> > > except that the path of memcg_memory_event() wasn't converted.
> > > 
> > > Shakeel,
> > > 
> > > Any suggestions how memcg_memory_event()->cgroup_file_notify()
> > > can be fixed?
> > > Can we just trylock and skip the event?
> > 
> > Will !gfpflags_allow_spinning(gfp_mask) be able to detect such call
> > chains? If yes, then we can change memcg_memory_event() to skip calls to
> > cgroup_file_notify() if spinning is not allowed.
> 
> I tried the below diff, but unfortunately __bpf_async_init() calls
> bpf_map_kmalloc_node() with GFP_ATOMIC, so gfpflags_allow_spinning()
> would return true.  I'll try the trylock-and-skip approach.

Trylock approach will not work as there are multiple locks in this
codepath. Better to use __GFP_HIGH instead of GFP_ATOMIC in
__bpf_async_init().


