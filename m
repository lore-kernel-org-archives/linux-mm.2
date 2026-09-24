Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF0DC9831A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831C56B0098; Thu, 24 Sep 2026 07:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3176B0099; Thu, 24 Sep 2026 07:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1E56B009B; Thu, 24 Sep 2026 07:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 441996B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:27:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 817DEA0145
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:27:56 +0000 (UTC)
X-FDA: 85248431352.23.837DF1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 815D4120005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:27:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cKphEnv7;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790249274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lq8RP+ZiPKQYeDKKN+eGZA0tMf6NU2q7olqQBx5raOs=;
	b=73M3pxJdbU0gZwKBu6YOHzkkN7EdUUO7qzVQ/Zk7IaHWNudloJsDHj8pYuCGauhEsH7ZRu
	jn9zR4gOrYCGQE3qPTJcI+zdxU4sgcDK18jZ6IMqRaTN/u8w2XX8gxJOjNJXJAlaN/oyOU
	5W5gopt+3/bRubiUjOV86sUvfduemoo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cKphEnv7;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790249274;
	b=WY8JqqV3VPPUrnJjDZVV+WXkVegNp+elmoKH9NqVGQvl/G7uhEayN03Gk8zUirAqRRFzu/
	Arpdp9C/UhwWehIdAHCZ7aRaBfL8HWyZC4NSPQbU4RYZiaeyxrogmnu29t2zrlrtUFuA0f
	3s89Sf3R2+rr/sZWbC0KyIQIaXosNU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6D8543B5B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AEC1F008A0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249273;
	bh=Lq8RP+ZiPKQYeDKKN+eGZA0tMf6NU2q7olqQBx5raOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cKphEnv7gLnjtnE9ZZoSpyqOTowuPK6l8IJ7TaHRqq0UpXO6CSrpeXAnEJIbFYocy
	 5xqgVNB8AOaGwIXTqNqr9nv91gWdTk1rTg1yswAzFxINOrkprrO/JC06glkNDTpz7d
	 Ary/a8VLiBXZT/cMF3JbBEhSpH8iOfKKEvHjRi+gZuIt3JBAX+smfzgb+astXCUzva
	 2VaX1nZkoLc1Dz+LANQZCmT9wo2wDe7yE4IrqOTWy10jpf9ZExTZSRli3sZ41fAk1K
	 xZ2A701TKcDhvAsSTx0NIgSfBGq0yPa++CReLfV+TvORg6SCm2Z2DHaDtf0Vw/YIP8
	 oCTQjENl0fZVg==
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-6737f134de1so119680d50.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:27:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBylcQGmxhUtl7+pSfjxMJZEX4a0SsdK2JMvEY1Hw+WMqs/wgvvT4OpvyZDnXnfbtyC/GcKoIqVBBg==@kvack.org
X-Gm-Message-State: AFuF++lrK9DrzMa/zGylFdQdPx3qggztuMr8+49ULhXTshAVloeXiq+3
	sNxLSVSqFdIFx/m7PqappvixFUAWYkyatIuJ53sSbpULE07T4hLoY2b4iBQznbX8nkMTsTL0+Az
	325jQ3E+nzEdSwkToR5D2XUOdzdAqKMipuwgy03Gr3A==
X-Received: by 2002:a05:690e:bc9:b0:66f:c1be:315c with SMTP id
 956f58d0204a3-672ed3b658cmr873163d50.51.1790249272919; Thu, 24 Sep 2026
 04:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora> <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com> <arP8vXdJAL6ZJ1Os@linux.dev>
In-Reply-To: <arP8vXdJAL6ZJ1Os@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 01:27:41 -1000
X-Gmail-Original-Message-ID: <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
X-Gm-Features: AclHuK9Zwq15Jwnk2fvcbfDpfS5y4r-YUwb8vz6DhJu53fLXl4OUnGVnT2WT3Ug
Message-ID: <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 815D4120005
X-Stat-Signature: iidert6nwpf7yik91o6h9ha8u8rnsyu4
X-HE-Tag: 1790249274-181635
X-HE-Meta: U2FsdGVkX18O6V5AUgt3i3r7u+erKCkaC9E6ed2eYWGwAOf6h8Sm8DoUlEZg601nh6lVrAih9ADoWcy8p9BGy+uzJQG31ppGci1oscVql1pDbTnfHR9id/IF01GDtFs79k1gT/w7d76+57Y+oKq5gXzsGlUZNIOX+SIQnJP20C/7NnUm07Rl3Rs0RzYV680h/O14vfsR+UStuBcXN+oSOPYPNwi9gFdySm3/r94Qz1nBtJzsP/tXrsoJo/PIVEC9rFFtI9yKeQvVx6GC2qgeD2ObLyR+PW01WfgEk3EpxKWNMt7pNFaSkJNUMXGOLg0S4r39ehVK3mKF26p3heXF2DBrU5JBErBMFWuOjMp/sBrGJ3vzaWFbA3lBHdjPT3O67M+u1KSLaGPhKsy9f5XOZW5Ja9RA0Ngm1DwmteHpHJj93cS6GBFeh2bUFLUVGAGJvCs0XXfHCc6FPTnHy2goIhAMHzFR0C3xOeqYsVBmJx7Czn07hB/G4xY5OiegCI2myMyZeErk97wzs+kjaAVPp+72oP9mx+p9qRFijpJZd9kvZYX825jkvKsyxmoyWjld78p541YHHzOoX1t7kzd04ck8hyg85MgxeB86KytzAS+JkqpNgg2O+uZAcuAKDbMikxt9X8qnk4CxaR2kvZ2Wrl/v5/DfERk1e+lRvq3bH2pkmjbqUaCIDP2DecK0Wa6PuwTYxB3snq/x8FY+1iyPtQ7EHuGE6xxlUfOYrnSR2rmSpt7fKZQix9ixGcNCOz3JXSIm3PqqsKW/clIoz1/Fn2c6zE6CktnccGZeINe1IJtZTD4TJNSRnjdou4r9FBvKYEZ5PBWZTtSNEmQQkDbuZ5WnRvdLgkWwRL2Fhzxq3Dzj+Fi4G7mmaTm2jpenAGkoa2xYXLHF+V4oK8+HUtE0Lfp5gKFowQNU3vJ7uATux8rqwMGfxQ2t313hxepjGQQFIiK+FZTfEXGupGwhXMa
 j9j9AnIx
 rviQMQxE80jRTMlSv/GryqfnDt7WOYoYBqc4jg6+WQjkOiX3AT5qS6mGzwrtdtcRYDpZIegv6fL/NiAHnbDG2H2VeEMTvTnAEKGJ2fq7B20EuVKW/ju5a1ni6uA6ZV57KpGKSDd+q3Jmxw6DeiwSswEoBKRK6vXLYHGF7Qsru68w6YBHFulC167gC+WMgPWMQMANYiWjarfQW92Lk8ccFCyKBP2PbtVWpG00KO6dSqw7U0mUsC9FymhSaAy5Jp+gvELIsErXW+gj1cYJLqKNNsvkU2bTu+gxMO07h3MbHzy2EuIHXWfMTjQTqAF071cvEIrurJlmktRihfiFNqGc3n+8/EasswNDADB2uD6098MY7n//MsqF7ajVcCk3XSyFwO+Vb00tJxtbbt9OkG8l5395zWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 6:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>

> > BTW, I already shared that changing swap counter charging will break
> > our and others' existing deployments.
>
> What do you mean here by "break our deployment"? We are talking about
> memory.swap usage and limits here. Google is still on v1 and using memsw
> usage and limit and I don't see how vswap is breaking memsw?

Your information is no longer accurate. I got this from our internal
AI: "While Google's internal production fleet has historically relied
on cgroup v1, there is an active migration to cgroup v2 to align with
the upstream Linux community. Meanwhile, in Google Cloud (especially
Google Kubernetes Engine - GKE), cgroup v2 is already widely deployed
and is the default for newer node pools."

About the V1 to V2 migration, it uses the memory.current and
memory.swap.* counter to simulate the memsw counter for providing the
metrics singal.

> Are you making these false claims just to derail the conversation?

You should apologize for your accusation.

Chris

