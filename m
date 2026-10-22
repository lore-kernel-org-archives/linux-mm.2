Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2162F606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1F26B0921; Thu, 22 Oct 2026 08:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2827C6B0922; Thu, 22 Oct 2026 08:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14AE96B0923; Thu, 22 Oct 2026 08:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE1336B0921
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:01:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD33D160394
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:01:06 +0000 (UTC)
X-FDA: 85350121332.27.95B3CB5
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C7404000F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:01:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792670465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s4DjmkflJ85sDaL3EcGa6JYsCik1zYKmblb+K5Ua+5E=;
	b=ruPQDcnCoVC38DY+nawQDsAh6YZocpoW+6OG2VP5NmWQYSo6tK8YWO0Q1NgvU7lEC9q30p
	plKZjDoWfQ4pvqp0a84b0iEufcvozFmo21Wcsryg/srQY0LEEcjvGIcr+5gsODyIDfITdl
	Yyg2oZhEudeLQp4KdmLPMdg0XMo7bFA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792670465;
	b=Fgu5UVcHcWIYit1M1+vNByepD2jy+dTVgmnyIS2bJjJlXida67XhshXRW4BqYPFTZlTLEJ
	UbHXUdwX8u76pWjt6ShYmcCxhSgH3lJVbLzk232adnlnzDmupP/45Nt6/Hfysqh2aj6SDY
	e6IRH8hPnGnCSjR1rGwwjeCJh9/y0lA=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.52 with ESMTP; 22 Oct 2026 21:00:58 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 22 Oct 2026 21:00:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 22 Oct 2026 21:00:58 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <atn6+gEwHUxUKhLB@yjaykim-PowerEdge-T330>
References: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
 <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Rspamd-Queue-Id: 8C7404000F
X-Rspam-User: 
X-Stat-Signature: 1jg1hjg4wgjubbe3pdcyn4tbd5kabioa
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792670463-338634
X-HE-Meta: U2FsdGVkX19KdqUIBhzGhM3gSXbPsSlcBnsWxO7RkP/p027ShhXuAR9K1O7ZF9zov2wR8JGPPULtTlhnjkdfb8DBTfC5leIbuPx4M4ELhP0fK8ghOYMFwqTOmvZJq+e6iEqSxYuOwrh2Su9Fz1ahZg6uFVQ2XhEUYKWbbyfxkII3RQlapw8U9Ojg4hStP3w0vMcIcnhU+OiRoCxI51L1l6TEila1lyAcqNxkW8qZCj/F/pC4E04pESS6m5FAHPUhV484spCsDaIjatTj8QmA8vxgk7Ag+67IwxhPVEEhjfHcLHlHIBDVR6g4Y1sk7sZqtNxmZGUNoGHvV5Jed1QX5FkUUs3ZUr0jg5obyrJVaE2ju1+KMc1yWEBxuGrDLl6f3Z+QtEm8WNgI0651XV0PhTuwQgZ8Fjbou6rdIawuwR2e9MGvKgB+XU7LbzwauTUm0okLz8NaBd9cI+lvaMgmxY2WSfN6BYISuoJkO15NDsiQOMNaIDB3TRIyIdY66ZV9x4as77p3udn04oUA+JyaRmw+hk0cO4RpY0RKA7wvGoA25fNN0gXP2n4yBjbpXe4xXurCf+wQeM5nKgFJZL9NikuLYKLO84Hri5wS3LRvAkrkobt9Wt2/Ocu2joMF6tJorkzMJjQGrSD0ys/kCxJD8RD+ulO3Fh2Jv+NqhReuN5N2MsH97TW81iYC35NaZBwWJZdOh7c96hGgXrAScdNaN/jRsE7H23g1NBUES5zM8OI8uksYGaF9kLhR3LDg36Dixrqf7l3lLB/rlttrDyD9LPQx6XXcFEAfIF9hFf+uco/3NEoTFuv8GFC8xtqwes7ev31CS3f7fvIPYd8+hFDc44DsS0m0McrLjOFFgyU4us+xqqIq8t9mPKgAZbgDGn1DXiRdiqG3XRu0lepvV9676uxNUXMaWsXhnLcTiZUqWAH/mVIjVHSL4rMb4hZUCzxUxPn9FLUpbp0MTX68wkx
 CZ/khUG7
 lNpkekkS8CPO3ZyKWrz5DVdnTBL8o8XktQZ/+zPOVXf+BKE2HG2Zm42IiQbbvJiRrRT/N6VpaLEzXC62VKNFKOLWQQfUp3yiVOzcdEy847bN7X5aOvZ01TrcIF1WjhNePykzyxsOe8e2IlPTDnMD5VION/4uZhdMuG2spbtvuR+WCOTm1U4UsGo0HoE4Jlf4uTDEjAzo7sS6STFGyc/s2fUs/a7YhjyUMdQZAKyzFIfPOxkl/zjQIhQuhxivMn8E89TEAoWr97vS81tDQ0tHYzGGvfuRBQiC0PRuYA8qfQYahBNjlizo8AZp8waFmI1ESRJS03V7zmAUMLXXSZvDtKQo19PB34CQoetvL9wACHMqEi5oecwb8ZREKQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:18:35AM +0200, David Hildenbrand (Arm) wrote:
> On 10/21/26 09:41, Chris Li wrote:
> > On Mon, Oct 19, 2026 at 5:35 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >>
> >> On Mon, Oct 19, 2026 at 5:28 AM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> I'm traveling this week, so it's a bit tricky. I cannot make Thursday morning.
> >>>
> >>> On Thursday I'll be traveling back from Cambridge. But hang on.
> >>>
> >>> My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30am - 2am.
> >>>
> >>> I could just naturally join that day.
> >>>
> >>> So one day later would work for me.
> >>
> >> Would that be too rushed for you? :)
> >>
> >> For everyone's convenience, this would be the time slot:
> >>
> >> PDT: Thu Oct 22, 5:00 PM
> > 
> > Works for me :-)
> > 
> >> EDT: Thu Oct 22, 8:00 PM
> >> Europe: Fri Oct 23, 2:00 AM
> > 
> > Ouch, David. If you commit to that, I understand it is very
> > challenging. Thank you for taking one for the team.
> > 
> >> China: Fri Oct 23, 8:00 AM
> > 
> > Other swap developers: Kairui, Baoquan, YoungJun and Barry, when you
> > have time, please comment on whether you can make the meeting as well.
> 
> I took the liberty to schedule the meeting and send out google calendar
> invitations to everyone on the CC list (to keep it simple on my end ;) ).
> 
> If anybody did not receive an invite but wants to join, please let me know.
> 
> If anybody received an invite and does not want to join, just ignore :)
> 
> -- 
> Cheers,
> 
> David

Thanks, David and Chris!

I'd like to participate in the meeting (This is 9:00 AM KST.)

However, I have a company meeting and issue around that time.
If everything is fine, I’ll join and participate in the discussion. 
And If an issue comes up, I may need to leave early.

Youngjun

