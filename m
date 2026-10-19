Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC89CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960DD6B026F; Mon, 19 Oct 2026 10:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937B26B0270; Mon, 19 Oct 2026 10:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D706B0271; Mon, 19 Oct 2026 10:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64E5C6B026F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:14:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6980C06B6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:14:29 +0000 (UTC)
X-FDA: 85339571058.28.D033C65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 430D41C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:14:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mkgx2V7u;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419268;
	b=g/Gy7RUTzcg94H1xDGNbzvnLhNnMBV56jlvYgjrwjCCG5kbh/UbKQjewgPBvt+4hxUdsHb
	e1YOS41YsMwOLYAvYySL55a4XFJ9ZYeCpgL89P68SckBfKabtlUvx0Y5yengD1aXnsIqVN
	F/PerWHHPw7hCeDELA7fg1SOR1UR1d8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mkgx2V7u;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7796Na8Lv8R+oexI0qKXaPmDdfsdOtZrwkjrcnP6R9E=;
	b=k+qW0vq5kDLX8bjSI7Ym0L96riTCnyoB7/xfdwocsKEYnCIgQRY8gS94nZH7PrCuDgy0bc
	hSrCLtqLHIFLARDcJa7c3KYUKvvSssdvB1NXgk936C6fvFl8nTCnSABfU3Nv7tqN2V8KZF
	NmDm/SzKUy1hlz5LvBPtUBSGNUMufzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18C9960213;
	Mon, 19 Oct 2026 14:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE961F000C5;
	Mon, 19 Oct 2026 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792419266;
	bh=7796Na8Lv8R+oexI0qKXaPmDdfsdOtZrwkjrcnP6R9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mkgx2V7ufsKA0GuRgq4ukenZFT+R1sPN2WiOnCwsZ/VP3g3lmzZfDm00z3z2CAUIe
	 bTsfFvc2uuNXx8Vn8tZJie9CLGIPGzCOdZESkWLvl+e9muw7OpPOneBngK77eyLYhh
	 iJW5czRYIGrxsC3vz8IKHLDEW/zhdxem0GA/fbsfloeVeOgdG55um9Cwciq0sFqLzF
	 oeHvQaHqwL3bkMdwFC0FWUFJPwB7NXmAjV3n9cdCvXGe7NRh0XNwytR8/Y98qnyWsT
	 xEhkC6KUJ3LZWsgzN0j+/pK+hjnDgOLp+be77PjVvfihIacChpxEfBApH6ELx+aVCG
	 UbzM5bsEfOTzw==
Date: Mon, 19 Oct 2026 15:14:24 +0100
From: Harry Yoo <harry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <atYgxto1RXZyZtLB@thinkstation>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
 <atEkfmRFgXJCbJuK@thinkstation>
 <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
 <atYdi3O77m6XzaKu@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atYdi3O77m6XzaKu@thinkstation>
X-Stat-Signature: dao4ifx3jmqkrdgbakirsdpusys57rqd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 430D41C0004
X-HE-Tag: 1792419268-98628
X-HE-Meta: U2FsdGVkX1/7GFhHVHObudUInmV43UnGMeLAVFM7WX1JX4Fvq4xU+Ujo92b9G9dpF/2Y0p/bzbylz8FleDISUaXA2aOJumsFVpx0k10QTgezYeKzDMib357W7mbFP0vLkbAOlw9GG4iFPz5D/YXJZd4Ry6M9B2J07Wslth8IfrMKB7ZrS7OH/3S6FGLbzqiECr/KBsZpbRvCDN+oqjYpZV9fNiPWb67zY/oAqN8a/Gqekg/RBKppJfqKVZIoI5vRRE2XRk2dqkMnQLmuE2TF5k+HSCpIx6Yv//vF/OZYoHvDFV5NMuuDeBSffrAclpwulb49/pt10+T0r7G7FSTBrzFZZAQSogbRhatRzR4u7hqav9H5qlG2vo/eR26Iw1MHZh4vnntdsRzRNMurR0Os2a8N60GWcub1PBWf2MrZprM70ANCkFv2a9HeTGThjr+V8VnQCBDG9Q97cxQrcqhFzd4NihX7G4CT3O4pBVK+z3N8E6yEaU6P8wxl3bAfeEEXBJxiqBaz40gvg/hamLNnHjHkN0kiVw7Zsc2GlJ7/ki4HmFsUgD0WgoRR+bhq2RyQWbJ6jVGFvU0Z6lrXZ0fuNhXYqP8pOUjM7xlt8Yd94rInEqTbRIW4NmvAKkSV+E5W0QWU1V4QHOx5EkYrhAQkTSVhctSWi1hdBOxi7X4HLSQWAVFHz6RCwcePLJk1sxjzYDZkFVP1KjaTDCmgKTo6KUglsjJ60RA0qOt4BfXA+/269k0tiVRvq6NkHW3wqyyHOrSkHkuNcySzU8isz5+yETJrl3R2Hb+PaoF9j1aEnrVPNTd+2NcfLfuJmuZ+HJx/Pz/HuuSgkyQMT4dP+mvhgr02t/WI2R1q1bVlZyVbxwCvSPRJ9q9BWmRB2AjEiFKlrrRf/e82UqyP8NjGMAPVBZYZpZlkFhb3uhHkTbE/r5IXedvgfCciMu8y0Jl02V9HLL0+DYrVQMTxkqGMhpq
 pCh1EjZK
 jSDUYUE3x76KzvZNIKHlmqmIPfXOyq8SDhy+Aw6epl5kJSMwHnRSPFeyqHUeqqSvHNYnWbX+7TmPqzhs1tywgHfZrlxnBhTUjbenyS0DfK7JemnviWjDTsCC16IA3BjnIoYAc/oX1JG3oU+xcQCAyYWvq7BhZV5G5eeZHHuVBZEMN6YBhU6AUjiR6jG8t5Cc1dIbtv7zX9KQImkI36sJ9I6UHdgcWNSB3UwyeblQyJ7/y88HyAjui+f/s7vtpP+4tF5lK1KASFoO2hIIKVFD3hzlW9pSe9/mM3wWPpf0BjqV8nt/PbHQncfdgQSYfSbLIzhiVa4Yrq45QYHROy+HhW7ob7VEU7Ft0lLrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 02:46:37PM +0100, Harry Yoo wrote:
> In the function, RCU is the only mechanism that prevents release of
> the memcg

Uh, no. looking at the code again I might have been confused!

The caller is expected to have either 1) acquired RCU read lock,
or 2) have a reference to the cgroup.

I see a bunch of callers that acquires rcu_read_lock() before reading
memcg/lruvec from folio and passing it to mod_lruvec_state() (and then
get_non_dying_memcg_start()/end().

Callers like reclaim e.g.) mem_cgroup_iter() hold a reference to the
cgroup...

-- 
Cheers,
Harry / Hyeonggon

