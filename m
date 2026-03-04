Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94547EF8FEA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032D56B00B2; Wed,  4 Mar 2026 08:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21A96B00B3; Wed,  4 Mar 2026 08:57:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F126B00B4; Wed,  4 Mar 2026 08:57:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6DFF6B00B2
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:57:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88BC9140592
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:57:46 +0000 (UTC)
X-FDA: 84508533732.20.21DD4ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id F32DDC0006
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:57:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eI7kGLW6;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772632665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5qJCB4VyXeyob1oULRNZCgnTSXzNHcfKFP3+rKga8k=;
	b=CntUHg83d21pqm3YxuUXwisdwTty1E9FgIzcMDYIqOujTHBHB1ZuMi9Ydc5yh3ocBrhgFU
	o/upV3+SdA6EqrqRjtivNVgp9vT33mNtq+mf30PMtpo3SmkXXFUyfZ0qPmupH9rQdgp3dR
	OW10yqmNsI3Uw6K3VpGf+1dJ0dmDWns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772632665; a=rsa-sha256;
	cv=none;
	b=5GaPaEzljXqar9Qe2PFmgWxq8ESdceQZgVzwQCK5870NjXzIki6R3ZB+gWpofYJLSmmOlV
	LfSSapjJX6XH0bdWU7MOB61y7YGAyIZtarshT8BP+FhwxCDu8dMidRxVjvuVOAf0L+tXeV
	N0RhAaxNfVeyUWAXIPk5r3m6t0NXnps=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eI7kGLW6;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A14A6013C;
	Wed,  4 Mar 2026 13:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB621C2BC87;
	Wed,  4 Mar 2026 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772632664;
	bh=tZZuIEusYI76qWLnqmMDQyqADb7WG9IIxpS6xVk0MYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eI7kGLW6p2qz7YeQq9jRS6ux5dX6FDMxNBlt+HCSugVKAMTcB4CZ2soKv9SXFrHpC
	 EzgvgvgACH1JTm8mZ5hOXRtdfExzbNQt7yG1djSmjlzNfB2troiv54PANRTbCkpIdx
	 GAUaa//rOSI1tLobgOYu+a+9GQsPBdo+V4h7Ebs/wtJuQ4o9VD9kG0JbRHbwaY0Wzo
	 fzj7T/hMkxgD4+JC8vrk3Aef7WU2ZzsWYa/QL3q3mZCw+NtssDKwqEJZdY6GS3o7M+
	 YGZv13EGK0AITi57Itei8kiZRUurRuy/G76ecfRq91stnmbUOnxZ6NVCgkeuwTBX4w
	 ZC0/ZUgSFNkhw==
Date: Wed, 4 Mar 2026 13:57:41 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <vfmyb3pp2gatdrqa2uimw44pxioreo7zc373zn7buvdfzhejew@ndhaa4yl3bvh>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
 <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
 <46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
 <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 9nbcubp8zrpjn47dnhs5q4uhkuc7iw3z
X-Rspamd-Queue-Id: F32DDC0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772632664-527345
X-HE-Meta: U2FsdGVkX1/lPCZz6FyhxXkejA843GGELwyqY+02L/YMQew6GBUPaglJVlY60x8J5A+d8ydq/VOwIlEuXBV/MUhjHZM/GhFWE7hxnU3CbTdzQWE3JGh0+bCvyuDfIgcrMUy+KPNXYGRRNktIa4QtBsVXUnAzRpK3/AOh44/zh03HJsbMUBSHyoh1bBQFKb5xPUWPy7aSBsj/A2IH56LxxobBzCEQWqyVQQ7eGPQ+2PTPelC1UNT4zjaH+vhaF9CiUowqFBNFtJJhdmd2/OtT6VgbXYUEDVdTNRcTtFqRHXZo6UQnMY8HQSpmaaDcxRfFkBMdaeJPZw75y+GFj48waVuOCWgyUhVN1Awbtibjtlb6IgBeL5A3+q5b6ct66PSGZshg8ZGn0s5EHscCz6665lbdfYnexqEL6n0OZQb6DLlIGx97ZoTV930NzdUGbnNlEHVD7iNqS7iBNU+YKWKD2yR6i10JBTYzAdILHELZKky1HevC45s3QrPpUKSWUw08aDwB+BtRTwKo4tuWKh07IIYq1W5DmdiUGbw8d/TrXPJEwu0VyEWOv/Ahg9Iwabmjwut90Xnng88Zi8MnMMXimZelk8Z5YJRVdoHXFEvur3/q9eeyzojkQtZbr51DsYz55N2/xtm4PezoHNnBinOnp2MgqG4qDG6hXTxDoyag4HZuNLOWeJx6ACM8tiua49EGuTnlR0g/acyzzIkSW2YVDM6qoxItyFuoXAbicTtbt9fZX3QmiFuZG5dtVxu5p+AkW8SCQhootoom9hjOjKQxMqTC29oq78U8uWvW3BLWT9JoJp75rs+HfUAJPQcpsINxbB1flG51g8Q/8mq1Jnq0m88KrYcfnXw3ipkzb5Qw0oUGn2ovLJhCZeb1DF/jdAScNnUlJIpQt7lBXu56vMCiKvP2JOP1bco385PHZbx1au12XkxzUm32VAmlOUBisu6AhmcdO5S8kAXAj6DaEJM
 Fh3noRQu
 vSE3R71gYeW9ce5BRO8MTIIjNnfjzVwmBWH/mMqiEXBHG99pUwyQKJfumwDJYR+cGZz7UQbMLLMif+/G5syHXziX3fan8KOSBf/J03fDhxUZ4OQdWsBB93iGia0x4bwmfp4MozOJ1a/Y5n8KGBJzlLbf1rYo57z1PUF/PeIv2Eu7Bv7wyytoNP0Lx81eYdbgRP+8ksYxBjz+y+KH557zuTUv0Sn4uVCFCk0i+VcWc+utylBWNvtpiVGV9vC+S9T1InJ30
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 03:56:42PM +0800, Qi Zheng wrote:
> 
> 
> On 3/3/26 10:56 PM, Yosry Ahmed wrote:
> > On Tue, Mar 03, 2026 at 11:08:56AM +0800, Qi Zheng wrote:
> > > Hi Yosry,
> > [..]
> > > > 
> > > > I don't think we should end up with two copies of
> > > > __mod_memcg_state/mod_memcg_state() and
> > > > __mod_memcg_lruvec_state/mod_memcg_lruvec_state(). I meant to refactor
> > > > mod_memcg_state() to call __mod_memcg_state(), where the latter does
> > > > not call get_non_dying_memcg_{start/end}(). Same for
> > > > mod_memcg_lruvec_state().
> > > 
> > > Okay, like the following? But this would require modifications to
> > > [PATCH v5 31/32]. If there are no problems, I will send the updated
> > > patch to [PATCH v5 29/32] and [PATCH v5 31/32].
> > 
> > I cannot apply the diff, seems a bit corrupted.
> > 
> > But ideally, instead of a @reparent argument, we just have
> > __mod_memcg_lruvec_state() and __mod_memcg_state() do the work without
> > getting parent of dead memcgs, and then mod_memcg_lruvec_state() and
> > mod_memcg_state() just call them after get_non_dying_memcg_start().
> > 
> > What about this (untested), it should apply on top of 'mm: memcontrol:
> > eliminate the problem of dying memory cgroup for LRU folios' in mm-new,
> > so maybe it needs to be broken down across different patches:
> > 
> 
> I applied  and tested it, so the final updated patches is as follows,
> If there are no problems, I will send out the official patches.

If I am not mistaken, Andrew prefers fixups to what he already has in
mm-new (Andrew, please correct me if I am wrong).

