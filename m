Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E318AE748FC
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 00:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D256B0005; Tue, 23 Dec 2025 19:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0916B0088; Tue, 23 Dec 2025 19:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22A46B008A; Tue, 23 Dec 2025 19:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B34306B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:08:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F4C8C0D87
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:08:03 +0000 (UTC)
X-FDA: 84252426846.26.5381236
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 46EBB1C000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:08:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uQBNZcmM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766534881; a=rsa-sha256;
	cv=none;
	b=mim9GzodwOrq6pjRLdrkK6f+5kbK10od9lDiz/D7NaTzvnbbAdSsgwhjXDx3+mWiWz308Z
	OQhfQebO6aS0XtqAmrzxbYfDuXXctRWxt4VDP2pHA3oqPXiLzLXrhyfWZ8+Q3cEYXIQPiw
	227hDaZQWwliBImYJ/Gqf71Ob90hR0g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uQBNZcmM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766534881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmEUPOXFQHUKRBL8saI1yGmqhxI2AKWs0kYr4qwAz/A=;
	b=kGAoDPCrWol7L12fCzILCQ6NC6d4wihaOzvo4P092mX10NEhWpDanTB+VpHk8+N6i0bOkl
	dKRjQFi3iacz/QQ6smthiTlgGgnquTzAGxOLnSdOR0ZL7qrsfiCaTakT/dkFBSPP0Fy47a
	CJ6IZNOtexHkqg0X2DVwc3yEAs5kXYs=
Date: Wed, 24 Dec 2025 00:07:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766534878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lmEUPOXFQHUKRBL8saI1yGmqhxI2AKWs0kYr4qwAz/A=;
	b=uQBNZcmMo3PHK7yjyw6VaeKLm6C05h5U6T+64XaAtkAMhEBOGq0JVHlBrEKmDImocoYTnn
	sYZ216HFcjJMLyD29iEGZed+EDYsnSi7oDtdTl/hXX2RuzG2iIbgEExiOUcasWwoOKNrYg
	uH5cx/12EjF7EoFfPTjgi4W6co2wWxY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 46EBB1C000F
X-Rspamd-Server: rspam10
X-Stat-Signature: iy4t7jgpxow5otimheeb85jexytaa1yy
X-HE-Tag: 1766534881-668646
X-HE-Meta: U2FsdGVkX19hRaPJZPg9ORjzlBzsmOAtNbGRCIAxtDo1g/Jbz7YLLiZDnsJZJJfrvEFNuXXpjWFponKiBFNqXHbQ1ZCyGr4urEjwIU7tQ2+b/8XY1sEX7OvPDPHVVcKzJzj1/WTxVZIFMgISq6vzO3aeHUPW4uxP63GPhkGEUi81YpA1ogaCkWxrB/2LnANrJwAemkjJJI7sMg8VHxSFaGfyciBmRsw9B42rRQtYDzP4mnhKX7Aa274oMXYCWPIcn0LFaTUhYmxD+DizvQqfd1MmqwXAL2ZjeICAA2XBxhOTNXXzjqzpLwGfpQ1BMnw7qEdXBw6Xi2FZ5CJuOCwMpedW4pxxQjooocxhZQAtriq8iE2oHnM20qd33kisWQ90I0D//7S8YX7SyId+JkBAMQhAidU2Zmc6BvoXJ/4I3cAVOtzY5i2pT/nHY8wPYorTnEp/TV7Dr8gwozYlBN59WrfORHsHXlMdgLiwjnAoX+P7Lur5yaeCCRP3STJAhZPP9mAzwjIzCiphkfiyrt9HaaKBLUxj14GnxnMCvnlNIXv33iEW8oP8RV6SFjmXxNjTP8bQH5epda84VwCiXwo0kb1YhAR2gknIAhiu3B25RsAToUwpeTR+dFXdnaFg30aIk7djjEgc8OfBIgj0MXcbq+HFdsoasHo5diRkQcLatHxcHuC9q82XBRdEZBzLjUkdlHgaFmAbSQpIf66iFD6L0sVpfMmPD6ga2hW4UVpmN4Fo2QMDB9ukiMT9LkaQcT+Vy1+UdF4VDebwY7eIe8kYTEXAROt7oTT53pKcxxpNUhVdPfvSSg5JmMCO+4wN3b+S1M7I9oZ3ucd8Ucqoh4gTwqRs+TRKCtRyg89lwx9HM8xrcB0fV4kccsaov9wkAAxAYOB7P56lpxqUmitaz01I34rsQgHpJrjnb9RUU26R2vpIWYWVSXE1lS3XEfBdXQ47hsN3Rr2oJcAxoKkkRIK
 e1Uj87o1
 quxOVkHNxmtvsE3TzpJlN8KFZYgf1Is6rVkfTno3pktvnQerDvbZvHKwoouIGT5oRDchZ9BaiDVyjhYZgsJrR/+ZIyUKk6gzUWylQDtDG6Obn6oCBHuGQtk94g9ujBYUhsfLLgP9QwZTYSlsNCsPs3sr7lSHAPI6Pm8t9vsAJavqIAmOBDcPgaC7KMpvg/hBaEzi8eJjpo372gMvhRVliRyhT2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 03:20:47PM -0800, Shakeel Butt wrote:
> On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
> [...]
> > 
> > I think there might be a problem with non-hierarchical stats on cgroup
> > v1, I brought it up previously [*]. I am not sure if this was addressed
> > but I couldn't immediately find anything.
> 
> Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.
> 
> > 
> > In short, if memory is charged to a dying cgroup 
> 
> Not sure why stats updates for dying cgroup is related. Isn't it simply
> stat increase at the child memcg and then stat decrease at the parent
> memcg would possibly show negative stat_local of the parent.

Hmm not sure I understand what you mean here. Normally an update to the
child memcg should not update state_local of the parent. So outside the
context of dying cgroups and reparenting I don't see how state_local of
the parent can become negative.

> 
> > at the time of
> > reparenting, when the memory gets uncharged the stats updates will occur
> > at the parent. This will update both hierarchical and non-hierarchical
> > stats of the parent, which would corrupt the parent's non-hierarchical
> > stats (because those counters were never incremented when the memory was
> > charged).
> > 
> > I didn't track down which stats are affected by this, but off the top of
> > my head I think all stats tracking anon, file, etc.
> 
> Let's start with what specific stats might be effected. First the stats
> which are monotonically increasing should be fine, like
> WORKINGSET_REFAULT_[ANON|FILE], PGPG[IN|OUT], PG[MAJ]FAULT.
> 
> So, the following ones are the interesting ones:
> 
> NR_FILE_PAGES, NR_ANON_MAPPED, NR_ANON_THPS, NR_SHMEM, NR_FILE_MAPPED,
> NR_FILE_DIRTY, NR_WRITEBACK, MEMCG_SWAP, NR_SWAPCACHE.
> 
> > 
> > The obvious solution is to flush and reparent the stats of a dying memcg
> > during reparenting,
> 
> Again not sure how flushing will help here and what do you mean by
> 'reparent the stats'? Do you mean something like:

Oh I meant we just need to do an rstat flush to aggregate per-CPU
counters before moving the stats from child to parent.

> 
> parent->vmstats->state_local += child->vmstats->state_local;
> 
> Hmm this seems fine and I think it should work.

Something like that, I didn't look too closely if there's anything else
that needs to be reparented.

> 
> > but I don't think this entirely fixes the problem
> > because the dying memcg stats can still be updated after its reparenting
> > (e.g. if a ref to the memcg has been held since before reparenting).
> 
> How can dying memcg stats can still be updated after reparenting? The
> stats which we care about are the anon & file memory and this series is
> reparenting them, so dying memcg will not see stats updates unless there
> is a concurrent update happening and I think it is very easy to avoid
> such situation by putting a grace period between reparenting the
> file/anon folios and reparenting dying chils'd stats_local. Am I missing
> something?

What prevents the code from obtaining a ref to a parent's memcg before
reparenting, and using it to update the stats after reparenting? A grace
period only works if the entire scope of using the memcg is within the
RCU critical section.

For example, __mem_cgroup_try_charge_swap() currently does this when
incrementing MEMCG_SWAP. While this specific example isn't problematic
because the reference won't be dropped until MEMCG_SWAP is decremented
again, the pattern of grabbing a ref to the memcg then updating a stat
could generally cause the problem.

Most stats are updated using lruvec_stat_mod_folio(), which updates the
stats in the same RCU critical section as obtaining the memcg pointer
from the folio, so it can be fixed with a grace period. However, I think
it can be easily missed in the future if other code paths update memcg
stats in a different way. We should try to enforce that stat updates
cannot only happen from the same RCU critical section where the memcg
pointer is acquired.

