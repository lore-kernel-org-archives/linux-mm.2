Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5EA710A62D2
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9436B008C; Thu, 26 Mar 2026 09:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A716B0092; Thu, 26 Mar 2026 09:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9786B0093; Thu, 26 Mar 2026 09:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF04B6B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:46:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6408D140D02
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:46:05 +0000 (UTC)
X-FDA: 84588337890.08.40D3443
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F96A10000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:46:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LSj5r7P6;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774532763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHrp3vUnpEwFUn8/yG+N7nNGYyVFfUurBOcMqtrleHE=;
	b=4+vt6wIBrizjrxahvmZyJr5qMK6vmiB9qiEl33Z4DMB/4qUm3fpNvcdTDy+TOw1MOGKiux
	NfJ7A+Y61ym37i1k1jN026P3kAUd2XWL3TzjZiDmdBLik5V1PabQJEoTVFRF79Dohd78eb
	nmg1lHK3m/C87+rMDy/HrmDgWDU+Nl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774532763; a=rsa-sha256;
	cv=none;
	b=aksCnvBVlPJtypacqoP2YJvJDhc7kExXqZcOeE3qI00H3sfDM/2iMVdgrM50Fk29gb4CHB
	Bjw3Ut9O5hJ9kcuESY+GKCDezjqRzit82twhGJuxxZy+N09LUs5YLjWEaGsv/hUj1VywUk
	FeDFWJCMUN5blAeQmol0XECxl9pfrvg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LSj5r7P6;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80C7D60103;
	Thu, 26 Mar 2026 13:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29739C19423;
	Thu, 26 Mar 2026 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774532762;
	bh=RudqkoNqPBUX98fLz0+P5t9+ze0SEqpsNjTsusgfFDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LSj5r7P6tvWg8RDoOKSFcjrp9BYauvtEROZVgJiSzZYIWSHC9NJzKB5elnZv2CQyD
	 w5r7LNhlCSoxpMC8Y3sVod1Gzem24Hk4m1u6j5DeVLY52ME3LPfs0YUEmnxX6flBeE
	 um8x1lyhyriKeZyyXOzLqhz3N2USlUZifloXHQ9ah2BNtaS1AiouYoX+1xPCQOoYmm
	 tG0ifLHmyTSqhizKG/n8f/RdNJu79Gd9WjXG5VqHkTZS3iDJWL+MWYDVxyFZUvQz7r
	 JxWs8pGnjifgIxDJIVYCps553/2g5VXg/h8VCAF2eiEhGbABeUZY0Vuce9P29BjXxS
	 TtMaX7iqRZm9g==
Date: Thu, 26 Mar 2026 13:45:54 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <4eb3bd28-f9d1-46a4-b794-fdeabad92158@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAMgjq7B_twv3xhd5VmMJxngAknf9YaLAiwGYpdi6H2n1cXD3-A@mail.gmail.com>
 <67f1588e-a094-413c-9746-9c28bdf6cc56@lucifer.local>
 <b340e43f-2e08-4a77-8176-e49667387e85@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b340e43f-2e08-4a77-8176-e49667387e85@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: gu7q8xbdt6mr7p7ijq9habb5b9idimgf
X-Rspamd-Queue-Id: 7F96A10000C
X-Rspam-User: 
X-HE-Tag: 1774532763-944927
X-HE-Meta: U2FsdGVkX1/E1CGv9ZbmlEpNnDH5U7xmqiVFyret3Afu+qg+lmf7gQj+TJe4u+gPZ4ttig4d1lRNkfGu7f7M8OKz3t8WVBDqiiLtSCpNe1DrPltpmdR4M6Pl3Nxb2gIi5vtSBJmdhYAaPelHrcav37nW+220Onr1ctz58/hJGAwU4qR/fKQ9VlPnbgHTmolgEG+6zXum1q0gIm5XtspHPqm3L580VWBDo4p1jxldU6AUgWvRhbxmn/Cxvs1YfNdcGU9PXFf3yZHawGyQBwM/i9YTb1N/t1x9bsEGYDfpJqRcZObeEnJ8LhZ2g/EOcwOGrZXwkKb2cElt6B572yhIJvNrymMWvDDnrWUXZqWemfgOhM8+D31r1Pctn21LZzjw5EZXqscTkt7z6V73IUdb2F3NMeG3McelUNXqiTd6qG4H1w8RpbjjUlQsk+d9hSXWZQ095Pp3vKMOkvAgwCzPRDEYp+N6RfWgz75w2GbD+JCRbi8/4OxuQbqCLcGmd4+rN5U+tGBLgWdy0wJX6cQzGGgFweqnlRsbeypWAsssFaz/pLHxVMLRt4fGUcNSK2KvyOFF1lXpKybU2Zd1upMkBWnjDtr7BzSDDnepiZGBv6JDr1DUTIxmqzeykqzYidqKcn8TCeqfYcaP5hGDf9j7FUWO9wxpqWBNCpCIdtlU29YTMnfuWhsoSb6OP8j2Ok1iiOFxtQ7epRXQX6x6sw4KI51Jvty1EFQBBOnU7fqzJn93MjNqWj37W+q0oTN1PTOqvFUuTWyUX67gr6Fih7NJkxurJDyl6/J748B+itSJewQKfvcNd3n9N1mfO6PQR6TPVJKrfJ6VYu2v/h+ZzdF/ERaup2gmCwaHOheqKagOXCNXBaL+VEs0B/8bYsMEWk1qKS34Mk0rtJNTi+M9BIatEmHU/WEDd6ZGl2/ePEz86QDas5qeNtcB6g54MwR3CEQJ6ftfnphZHMdUx1yb7q3
 Xue7a8cN
 jEhguC5kavcU5YOFyWeUF79/zXxWn/pxIo2RIU5OQYOUi55CFYflkE8INFE7W1gSKBseuP5omJxjaDlUHLyQI2M87l05mxFrF/fLSsPQ7+3QAz+kt4PRZiYbY00dKNtIv587AI4BX+yaszjD8i+wAAf7+/Q9gPpGdYYNLiaIy6QMX/yyyeoc6xbykzjXut8xrb/t0BqmJqTHiDCK3dF9zzXy6PJhCpeitstUMtxm0ty43YF9UFd/ne3Ykwb1LouTKK2ukPNPxnKDL8P1X647qO/tMf1/mvTWue8zu7PDTmrCsFEp+p4cHln24Nc2Ei3HR4k9zsVFS9uRM0Ck1PO7O/+CUEamvfuQozMwtIhostdWXfP2lIplZeSck9vY0g/ms+0EZLOODp/MEdZaJfh8RLRJf09Ye7FcM07skQ9cIssxItG5j3XY57hQq5OcROKAgKiPXJwxn7JUj2NsZHEoXMAEzrsWVogaQWZRjud69vKVvuEewXMbOwHFqfDeyTvJh0R0XyAtbb2nOm3UIgyqk4b2CAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 02:42:35PM +0100, David Hildenbrand (Arm) wrote:
> On 3/26/26 14:13, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 26, 2026 at 08:37:06PM +0800, Kairui Song wrote:
> >> On Thu, Mar 26, 2026 at 4:02 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >>>
> >>>
> >>> I'm quite concerned about maintainership, as it seems the MGLRU maintainers have
> >>> not been all that active, and the MGLRU to me at least is currently a black box.
> >>>
> >>> I'm not the only one who's raised this (see [0]).
> >>>
> >>> That'd very much have to be resolved and the community reassured that MGLRU is
> >>> _actively_ maintained before we could even contemplate it replacing the
> >>> 'classic' reclaim approach IMO.
> >>>
> >>> I hope that Kairu, Barry, Zicheng and others who are interested int it resolve
> >>> this, however!
> >>
> >> Hi everyone,
> >>
> >> Right, I think we are starting to make good progress on improving
> >> MGLRU recently. For the last few years we already have some commits
> >> stashed downstream to enable that on our fleet, most of my effort in
> >> upstream is spent on other parts like SWAP, really looking forward to
> >> making MGLRU better upstreamly.
> >>
> >> Yesterday I was still discussing with CachyOS folks about their usage
> >> while working on that series for MGLRU cleanup and dirty flush
> >> optimization, and got some nice feedback later from their chat server
> >> that MGLRU's TTL resolved their thrashing issue very well. With
> >> classic LRU they needed a le9 patch downtreamly.
> >>
> >> For many other typical workloads under stress, MGLRU performs
> >> significantly better too (e.g. database, build kernel could be more
> >> than twice as fast), it would be a huge loss to leave it unmaintained.
> >>
> >> Barry also provided some really helpful ideas about MGLRU like
> >> readahead handling. We are also seeing other vendors and people
> >> contributing to MGLRU like Leno and Baolin recently. Things are
> >> looking promising.
> >
> > Guys, can I please make a plea then for you guys to AT LEAST become
> > reviewers in MAINTAINERS please:
> >
> > MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> > M:	Andrew Morton <akpm@linux-foundation.org>
> >
> > Well Andrew is Andrew :)
> >
> > M:	Axel Rasmussen <axelrasmussen@google.com>
> >
> > git log mm/vmscan.c has 0 results.
> >
> > Axel has however engaged in discussion on
> > https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
> > recently for example, but not much in 2025 afaict.
> >
> > M:	Yuanchu Xie <yuanchu@google.com>
> >
> > git log mm/vmscan.c shows 1 result from August 13th 2024.
> >
> > Yuanchu has engaged in some MGLRU discussion also recently, here and there.
> >
> > R:	Wei Xu <weixugc@google.com>
> >
> > git log mm/vmscan.c shows 2 results from October 2024.
> >
> > Wei doesn't look to have engaged in discussion on MGLRU recently.
> >
> > L:	linux-mm@kvack.org
> > S:	Maintained
> > W:	http://www.linux-mm.org
> > T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > F:	Documentation/admin-guide/mm/multigen_lru.rst
> > F:	Documentation/mm/multigen_lru.rst
> > F:	include/linux/mm_inline.h
> > F:	include/linux/mmzone.h
> > F:	mm/swap.c
> > F:	mm/vmscan.c
> > F:	mm/workingset.c
> >
> > It doesn't really feel like MGLRU is currently maintained at all, quite
> > honestly.
> >
> > So I think we need people to step up here.
>
>
> Ans some serious cleanup of the entry to reflect who is actually
> involved nowadays, if at all.
>
> Master of MAINTAINER updates, I assume you'll take care of that?

Ack of course :)

I mean I can suggest a change and cc the various people and we can do it
that way :)

Obviously will want some Acked-by's from those invovled on that though! :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

