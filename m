Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A383606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lkrMnstY
Received: by kanga.kvack.org (Postfix)
	id 0FFC26B00EF; Sun,  1 Nov 2026 15:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1356B05B1; Sun,  1 Nov 2026 15:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93EC6B05B2; Sun,  1 Nov 2026 15:55:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAB596B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:55:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D0D31C44B7
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:55:48 +0000 (UTC)
X-FDA: 85387756776.03.128A567
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A11F80004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:55:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkrMnstY;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793566546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjloYTGpg1MlBH/CI8BHpeCnn4wPxbKq+lkUhPgvOaU=;
	b=14AaZvEhbCeqixjmrWxgmlVwdXEeL6mjbbtkfrp5fiFGgj0gsOf9uJuqvOZF/l6UqpmXjw
	WQ4LNDDGy0dntp9yB16FeXgUR0bj8nqWuV7/Z+ogDM2ffpYWmtlVo5hWjVdpIgtCtjoaea
	Xtmr2LyyGGcNbx5Hj3NhTHmE/uGXRa4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkrMnstY;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793566546;
	b=jUFb06FekAZvoZ7c3Yc0IURo6NvFzeYwaGP7qDQmbbXF4EELIB7qrO/pGQPe2yzu8TOnSh
	/0/GvdlyRXbUYD0V2Gw9gQix+rk+X3rRAdzQAJ75+hysz3ecia/DdulSg1f/0YndJeNuEC
	c04rJtGinVXy7Mp+jQ8kHt8kje9nq4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B15B6601F9;
	Sun,  1 Nov 2026 20:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9B01F000C1;
	Sun,  1 Nov 2026 20:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793566545;
	bh=pjloYTGpg1MlBH/CI8BHpeCnn4wPxbKq+lkUhPgvOaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkrMnstYZlmnyyCbaxUaGSrraRUFABVDrZ6A+ixK5oTmB/LBZubJGxgl8IssnAIdr
	 fhOUTR+JQbqzpvZEvGl5F1UbH+wkq5xP5y8jUgN0dXlIrPh3iCX6ahO/JRZ98fxWU4
	 UBji/j9x6368vmm8YQwE4wk4XBOFK0VYswCRSs4p12mQwCCAOv6QabX4K9xfl38es+
	 09qtxhTMmQ02/NrOKp1NqIx/u/W7Sm9M6C+FpkoTAKz6PIHusiWSQy7gB/vE0DOOk2
	 /apfFwiw56OZIoSEAZUalxh/09SpG/WvjSEVuPIgoiDayAG/QrMFYmXEVj4zEI52vP
	 Jmcjk2+Dker5w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Byungchul Park <byungchul@sk.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Dave Chinner <david@fromorbit.com>,
	David Rientjes <rientjes@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Gregory Price <gourry@gourry.net>,
	Hao Li <hao.li@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Nick Piggin <npiggin@gmail.com>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Date: Sun,  1 Nov 2026 12:55:35 -0800
Message-ID: <20261101205536.97942-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A11F80004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z4cbr6yrw7srmur3tka4cdge5sacador
X-HE-Tag: 1793566546-500634
X-HE-Meta: U2FsdGVkX1/fMSNM3B0QXv5GsZKzUktJLeuhx21sr9wI+vsnAjYnVVfnQCVMYLfijToe019QDJr7ILngr5w6+1QPlXKZSqenmz3eTTj7zqa+989w426LZt4bx60JKGi6II7TqOgSW4t9tJqiU6FKy671PU4SqMohTXXgJQD6bJP7nzFObLBvjP/ccbp9cBt98hyET55/HQ+iA+5hhBLvBoGaim4QFagEPJeCwTiB77oqDP4UTfDTjSsJKwZoJecXjGm5XrdL3IKYeud9PaUE5ZGsw+AzcqVqj5+ubm75reo1NSJpKzVq/0ov9pWVtVwEEBqiSRddG9f2FAL/wD/i99Jy8yFBdnZHYkXD8Qp6RG+2Vm3WZ+YxYKar4R1H6u7VvoGW1YFbRjJvPfXIA24qG70p8qmyNR00JYjE+xnJ/MokY64u3rWzUjyPRpbwxz5BPIVNcFksZBoE67RGr0fAavNFtifLmxZIRBlgHuJRoy4zhQjPoksnqeyzqCujMEjHo0VjV7tNUCn96Z9Vh+XYPwOlnusAiz/Q8wwzYokyBbjXnrELKMq4ThkYLk3yXWYUVHRYCP/+/m8JrJ7MzjxEKj7gEjEhbcA6nGmv5+93k2Z/TNciz/tC7Yitv2gm+FCuNlWYHqmffQFO0daQJU+jZad22c0LXsdyhg1epL6IDBVt6DaJzrQZYQE9LepUmsOWy+XT2z4y4mi1478QluiHx5Nsc6ZDzXQvj9/4yHQDXaxcCRqjaJQB8jyzjzqUqT6t0Ln89MR6heH55DSQDTdYdjgdSoNRWpJoDk0CvA+BEb71OjRkHJiR2Sn7977yMDGd2AxbvIxB0HGUmLHcQcktN0ZjlLCpGay5uJohWgos+dAoC/GUbjtEzFW9NBoDb1aocSh4ivIsySa5ynCN3zrpJ4ROgcIquV8aRMnwUk0HcT217+AtHqlviqgz7IBUeARRa71vflbdlaUYvnFXNR9
 KuQHlVz0
 WZi2YH2Aq+VBn8sfTsO+iOv9bCoD2+ulRdKgi6mnwy9GxHJh/I/Jgk/s69x0u/g+hrcJ5eK88TMEAPAFJV/x+FN4HxJvhvCog4QzU6iXRchJZrp8c05DfMQM7QqscMWRHcmxGEHF7H+0O3XyVa9K3c/DntPp6OOJJL+Lv06cJmIPkiHfLfqwbuex46+eLntjL75EwtBRi4LKUffWCYmvLvm1pZ/4FYCqx9zpbuli2Ap41q4Il2P4JUv3WQJxAgIiQfyg4SUTBdoZ2/8PuquR9oL0VuORxIktYfsc9dbmzu3pHykWmHhl6hzYlP1W0han1fxrORAM68yMn93DcK+gVKc3VmHwDVVIsWfPnCX2mzTwy0+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 1 Nov 2026 12:30:25 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 1 Nov 2026 14:33:57 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> > On 10/30/26 22:34, David Hildenbrand (Arm) wrote:
> > > Hi,
> > > 
> > > several MM updates:
> > > 
> > 
> > @Andrew, should I pick these or do you want to route them through your tree?
> 
> I'll grab for now, thanks.  As a hotfix.
> 
> Because I'm whacking away at MAINTAINERS at present.  First step is to
> consistently name the components, below.
> 
> This is a two-patch series.  The first renames components so everything
> starts with "^MEMORY MANAGEMENT", leaving MAIINTAINERS incorrectly
> sorted.  The second patch only moves things around, to restore the
> alphasorting.
> 
> So people only need look at the first patch.  Please review that.

Both patches look good to me.  For both,

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

