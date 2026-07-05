Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C72C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 21:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B146B6B00B8; Sun,  5 Jul 2026 17:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC686B00B9; Sun,  5 Jul 2026 17:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A298E6B00BA; Sun,  5 Jul 2026 17:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B82A6B00B8
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:11:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 029818C4CA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:11:07 +0000 (UTC)
X-FDA: 84955968216.01.93F70F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7396518000D
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:11:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8FVIR36;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GebDB3AJgijwXFEI2D6qbtBmvdEtIrR7/9BKZNSnL98=;
	b=HcES56T0sf7YqjD0XveSbOzKhpennz4Rb/t72eEnKMN4WbB9Yh7M7lj8wZdo72ldC5sIuP
	S6NCKYIyDiaC3Epf8zfM/MLmQKViC2FKdb7n5bNlmG1jQqtsWfEBbVkU7oqXA7NjvACJa2
	Ztdjv+LeZj6t3kYo0S2EF8xTgDHAbLI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8FVIR36;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285866;
	b=m7B7QFpQQjCO6PtllCi/wf+XLqe8w3EjG8SWAyOgkcnhovDGI6/lezscD7tI6tFQl8ge2k
	e5j0+ksEHzyMNovD6thDwpCuChMRE3zEyT/7PPWSlY4q8ydDX7Bm9q8jpw34yigxIwsloV
	3vQeC3eX72qH9qEeiUm8OkcvpWkn5do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3F7A60018;
	Sun,  5 Jul 2026 21:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8591F000E9;
	Sun,  5 Jul 2026 21:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285865;
	bh=GebDB3AJgijwXFEI2D6qbtBmvdEtIrR7/9BKZNSnL98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8FVIR36pgDT32drTy3Yhc60ZhdzltCghnVTYfC7vcv+x6l2mRywdYo9oh6MuNSfr
	 rVTfX6xl6blRH7CpG6gqz4+ye+YUcjyr5refou0IVfbAOkT+kI6oSPE3UG3mLglJIS
	 Gb4c7DqJoupGojY5uWc4P2vfVDos+L7U4Q6R5lK1XrQ3zbFGfiz3TyziZe9OYHpAOx
	 PSc7blRkObVZHOGrjbUj14hxSqd8FP4W/XK7Loq1R3rDhVazLQuSFdMT6KwJ6RL4M9
	 4RuaJm2jFicIFEDkaeWZJV+2QjJ5FvJAZUMc57D0/yo1cR6LA53c5KiphYyR9wz14T
	 z5y4ds7Azqd+w==
From: SJ Park <sj@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	"Liam R. Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Date: Sun,  5 Jul 2026 14:10:54 -0700
Message-ID: <20260705211055.99706-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <akjakkURVyM4x1dt@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7396518000D
X-Stat-Signature: pfcxe1y3bszs6rx5deoa6bu51au3nnrr
X-HE-Tag: 1783285866-199230
X-HE-Meta: U2FsdGVkX19dGH/tjqPDcAq/fDfwIo8MwLW1Ac8A+sWjFKXet5wPBEyNxhTveby5PKpXfVduOy274xmND6aV7wdDHxP/J+LdaxFJDEA4zJIrKrQ96HFzVaWmpZFospVPaMQZc9vgykH0M3O4eNA4iNpyvXi6rM4Fe3y+a6Q/692TnmNQ+2g0iNCR+o9KXAJtCDQaHSAKnzNjmCBRm2EsGLeG2iIEMOT//M8lPlVkfIUq6p7hHpzM4BXuIMVoqLUV6jHlv8M020gaCCNDzbXVdIPVKFxMw9BAqhD0vaZUzzH9tHbDKm/fv0rPXkMwgG3Ueey9h7yzDxchUUJuPSpCsRbLgEblvvzpeOR/c8BTK3aE67qbPmGLQ3wqPbhEptbPPWHEIFskQ6vAoo7fhy0QKY1jnBaOYVnGIlhmFn7Fp2eTrvThGwc4+8WieTqwyxx5tCiQpxNY8wahN4meKARXsI0cVcuMzAL7gOFy+q6Aw9FxvfGYmp7oLdu7Ez/2JFgtquSsrRzQyiWTy8zILvgwzi9xPV6CWcxzXDf/7lgbyxFRQYHnvdCmQHzuqbD82p4uWoNPfbT70bNMyDLtgrdmnPFcaZLCxvfeAqcAh5xrTVxvIlafTA+5DftizeApoUQjmZfidMyd0kvJBpMKti33w+wZ9QPq+fg0SwnejqmLOFeUDl15WANlC/A7OQRc4tBTto77qcCl2sjsy7gCs+TnsC6F/R78MUJPHQbBJl4zNpUOeWpcCrNENXH8K1Te/VF+/KnMh0fTsaXwLxdQB5+DaMkqCvHAjPCnXd9v/r0AMzZiL9cNlTDMJSQnkKBjKEHLZ876fH8XeOjfFJnetcd6eXICYSQjH89KFiiuEXCP2MeEj6hn/OPz6TG+SYFCDJELovaaiXUqbMhksAttG+TsSvZcc5orXcb++KIJFsn0lTMYyNVyMKWXg7nDHwDJfKH8519s6YT2c9VoPxZx248
 VSjXgzHj
 gXCv3sKADsN+V6V3ppwdQGlxZMwKkyT8nIt73AA263D4mbueWCuLUnENDDxT/mCuc69xKKa7KNOvxVT80xKVAQMMNB7DeyVigOYZoRiW2iEHIkIINqQ0qIpFtsv2yGd930fjgZ2gX+hItrEg7jMkxs09MuUjfGivKwYpXjw0KNOuuxmq5Lwggd9paLQz5aR2RXTueGvTBIFPUmAaIPaJqBqCYDXJPZ1BXPl91HFFEx1lq9HY4d1FRStkv6X0vGxg78WBZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 4 Jul 2026 13:04:02 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> Hi SJ,
> 
> On Fri, Jul 03, 2026 at 12:45:01PM -0700, SJ Park wrote:
> > On Thu, 2 Jul 2026 16:08:03 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > > 
> > > CI grabs patches from patchwork and tries to apply them to one of the three
> > > bases: mm-unstable, mm-new or the latest Linus' commit merged into mm.git.
> > > 
> > > If patches apply, the other bases are not checked. 
> > > 
> > > This patches applied cleanly to mm-unstable and successfully passed (at
> > > least once :) )
> > > https://github.com/linux-mm/linux-mm/actions/runs/28544575927/
> > 
> > Awesome!
> > 
> > I found the CI script (mm-ci) on the GitHub organization.  Is the repo open to
> > contributions?
> 
> Yes :)
> 
> > If so, between GitHub PR and patches to linux-mm@ what is more
> > preferred?
> 
> The way it works, all testing update should go to mm-ci. There is a bot
> that takes them from there and generates PRs inn linux-mm that include
> patches and the CI files.

Thank you for sharing the detail!

> 
> > Seems it is not running DAMON specific tests, and I want to add
> > DAMON kunit test to the test set as a first step (DAMO selftest is bit flaky on
> > some systems), if people don't mind.
> 
> Patches are welcome :)
> 
> If DAMON selftest is flaky let's keep it out for now please, otherwise it
> would cause too much noise.

Yes, surely agreed.  There is nothing to rush :)

>  
> > I or someone else may also want to add more tests like Cc list checking [1] in
> > future.
> > 
> > [1] https://lore.kernel.org/20260703190421.100480-1-sj@kernel.org
> 
> Yeah, I think it would be helpful. 

Cool, I'll try to take time to understand it more, and make some contributions.


Thanks,
SJ

[...]

