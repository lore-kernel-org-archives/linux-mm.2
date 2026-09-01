Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98CAFC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD7C6B00B7; Tue,  1 Sep 2026 13:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE376B00B8; Tue,  1 Sep 2026 13:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3B06B00BA; Tue,  1 Sep 2026 13:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA9E6B00B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:29:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02E051404C1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:29:16 +0000 (UTC)
X-FDA: 85165879554.25.D98BB04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B79612000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:29:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sQHF9wmb;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788283755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnzUsYmBzTkG/qduuXF36go4ShLApC/ylajzDtl8Juw=;
	b=Nn+W91W0pxh5KNfd1XKKnXYy7K/esKfHTDq3jbU8txXjV03EJ+n/kKQHuQkClniIOHQFVh
	6l+hrCF5nzgFjc1s0XVbdyk84vz52y1KusXf01GrWFSZam8IdsZPgld1NXbRdgFxjsw60C
	E2ygP5EazgNOSgLg/cSGHD8x/LlxxDI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788283755;
	b=MfVICN/19GGkGct9MNMVFoeGzquGTFbXz/WV2OmL8qyQHdwaqoLVgtfTCd26awHc+T7ZnW
	ENfv3C5OurV2O/Y4aAQPZY3W88E0V/2SurlH8anWVt/d80pKBLZILRr8+DWM3Z3zvFSl+Q
	V8bpdC79+wGB5MCtDiBk2zaFLOPEMfs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sQHF9wmb;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0CD4437B4;
	Tue,  1 Sep 2026 17:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8191F000E9;
	Tue,  1 Sep 2026 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283753;
	bh=tnzUsYmBzTkG/qduuXF36go4ShLApC/ylajzDtl8Juw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sQHF9wmbR7uB2TkEtzgH81EVp6gsoWuhzfGCCboeFIcl1DKbRtUJEiAmdpdSvFuEb
	 0vWSSJF4hE1nqSM6y3rKl84LvWBFB8SJ33xlL3sjoATBlS3DNAz1C+EQ9oGoIL7ns3
	 tIOoZ6CdwNeU+P8gNBFaxhC1X5VZAVV9j8CNFVQc=
Date: Tue, 1 Sep 2026 10:29:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Lance Yang <lance.yang@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
Message-Id: <20260901102913.5c571bf153bc3830905c6770@linux-foundation.org>
In-Reply-To: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B79612000C
X-Stat-Signature: sba8o3j31zms5ka6r41r4rcqwf1jhkep
X-HE-Tag: 1788283754-641455
X-HE-Meta: U2FsdGVkX1/ep4/FQGYVEzqTXHu/Uzh7vpH9eKc8C+GkEelOV7FhVFaJTABSB0FMS7cmwOVWrftWdu8jQoCBmq39AL1qoPXCKU7mi7tcTSi0CqJ1+IR0MKWbMTZeR2YKkRq91bxY0kXp953iiwamoqDDutoaVa4pSRWodCCcXFWXIrz16qNvlNksS0SPrkWdSNw7ev4VAmSdQEZyntVIngtB789tn7h62wgAykSTmEZDnnuIV7viUQyKlfVtxLw67ONvw6+JZoI+qP5FbNAb2GptoX1eyKt1ZyyYl1INS5PH8P5ftXfDvMe6UsZfl/MoC/FQ4sKjvi85wJOghWWcwIUGau3lXM6TDTCKYCNLOmX7QBfB3ybUdVBtcZDjcH2XeLiolFZ5nMnM0ETT3yVks5BC6T9FPeZPwY7DyQDBZtYnSP+t0d5kmchNU/omcWkBTtMaBgvYWMohpTLztiybx3e6L5JXKju5vx389s5plJumYVlGxU3zRTH+bdx3Fu/tPW11ODM4+kMXNNDimHHzSin3ntMkk4VNp5Zfegd4DAdNXGQPX9tTNMcqa14msWYSJnTIjx5n0So77JOa8sOKHcWByZrvaHLhexu66wL4OrMr5khiG8iHhbWM8AlG7qqiplZndamMv/hfJIuvbLgEqEx6pTkvLtQFdCOv5TESVRXvnJSnFb0emzyGYhnl2rTlEGbe0C7Xep9UEYR4KdMnWn1bppFQzGfIyYWSDcGqMQWDhS9h6iiVnScouTMLVu8lDIKytMQlyq27kMMzuafu42Qn/w8QW0VwX1c/WOFy66ZzhvuubIW9fHxs534vPDthjZB1jSrH8wuBjGpiyx1lGkONeGy+AK/fd2F0bP6Tjv0P02QKknbHlMDcrixxdQN3gKPyLSYu3ZqYy+T90eFAzsrmyGmv0G5BZy59WlTrWdqUCSfI8hLjbA2ifCFv6jJF9Rwpzzw9P5BsMy/jun2
 AWythb+k
 uRVuOlP7E90HyWiJRWz+gmF78WxyCgF0y3vK1Puj/OKrNUUOyW149hqpo8N3UhjVVKUI2ZTvwOJcOfaXNZIBAtm+Hf/T1Wk4zvVOzqXBN+IRIirrQ4XOHJHzqLGqb7fuITqOmouIKsg8MkdJBvZuSYpCs3Ivgm0UIAffX+lfxI+PaxiJxMHOOgpkt+JQH6tLteHzF7abu3LGhcowLHIhxQ39TYa9CY7KrPOTFVICGkis5MRael9+gnCcwi5C5IT6gGuLhf+3UuZp9YLc2F/MKQ7QCaLZ2y22jvgvf+jK7dtv/IK7NiRMPUb38Ev3UgtLDc0yv2CwvENXr6QUNaZaYMHqIZKk4q+POAjB0JAUnd+HHUAlP3OUSluCBeOvdfFQRv0jG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 19:51:04 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS
> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
> back to a non-memcg-aware shrinker.  On this fallback path,
> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
> valid id belonging to whichever memcg-aware shrinker registers first.
> 
> __list_lru_init() copies shrinker->id unconditionally, so every
> list_lru backed by such a fallback shrinker (thp-deferred_split,
> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
> up with lru->shrinker_id == 0 instead of -1.
> 
> Under nokmem the list_lru collapses to the shared per-node lists, but
> __list_lru_add() still calls set_shrinker_bit() against the memcg of
> the added object.  Most list_lru users are unaffected because their
> objects resolve to a NULL memcg without kmem accounting, but the THP
> deferred split queue holds user folios, which are charged regardless
> of nokmem.  Since no memcg-aware shrinker can register under nokmem,
> shrinker_nr_max stays 0 and every memcg's shrinker_info has
> map_nr_max == 0, so the first folio added by khugepaged triggers on
> every boot:
> 
>   WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
> 
> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
> and expand the maps, there is no warning; instead bit 0 is set
> spuriously for an unrelated shrinker.
> 
> shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set,
> and all readers inside mm/shrinker.c already check the flag before
> using the id.  Make __list_lru_init() do the same and fall back to -1,
> so set_shrinker_bit() is never reached with a bogus id.  The stale
> shrinker->id itself is left as is; cleaning that up is a separate
> topic.

Thanks.  I'll queue this for test and review.

> Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")

Worth a cc:stable, I assume.

> ---
> 
> Verified on a machine booting with cgroup.memory=nokmem and
> CONFIG_TRANSPARENT_HUGEPAGE=y: the warning fires once per boot from
> khugepaged, disappears when nokmem is removed from the command line,
> and no longer triggers with this fix applied and nokmem set.

That's useful info.  I'll move it into the changelog.


Sashiko thinks there's a problem with cgroup_disable=memory as well:
	https://sashiko.dev/#/patchset/20260901115104.2944996-1-qinyuntan@linux.alibaba.com

