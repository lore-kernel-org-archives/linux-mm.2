Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632F9CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74C86B008A; Tue,  9 Jun 2026 04:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24CA6B0093; Tue,  9 Jun 2026 04:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13EF6B0095; Tue,  9 Jun 2026 04:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBDC6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:12:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C9FA1C26E1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:12:18 +0000 (UTC)
X-FDA: 84859656756.24.20E2118
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5EFB210000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:12:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBNfFi7p;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780992736;
	b=k5EtgqZytUTsURb4J6SgxS3y/ssKs3xNOwqXscSvKYegHzTw0aNoi7HsTwkucmDp+981+s
	1bk2eK/OGiLVnRg6JDH0GmpqnUl9QqpIhDmY6jALqQVlUlDJWhXagX+u8eJXnofntHBz//
	ANvX7XASxXNIqufSJnlYHbCthfzO35s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBNfFi7p;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iy6WqC0AyHBkc7kR6hVPweXwlBpVwgmOI4XY3Av07c=;
	b=bVWjOswyHD9nSqs5Su82HxARafUFFRw/lLsj2IvP1C0fnKLHkTSSSNgFiqlCghrcJ6d8gQ
	43ckXDuRahW3BI8NuTkF0ODh5F4jYaVLWR9dcF0Uhy6YqrLHvuOWt8j8+2xedaRxnrxOVP
	M8Sny75zExPB+vINtnKmuv0tN/BpHEo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5994F42A96;
	Tue,  9 Jun 2026 08:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414941F00893;
	Tue,  9 Jun 2026 08:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780992735;
	bh=6iy6WqC0AyHBkc7kR6hVPweXwlBpVwgmOI4XY3Av07c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mBNfFi7ppl4+IUjL4paapjKUUGOFLBiQiAJsdBQDha5aP4aWh/vLeYKkEYguX4EB8
	 ZBU3SBR96jhLjV1NqLg4LNvs+iSd0iB/5Y2Dd3MlHOIpLsMuIOehzo5Sn5rY7D12en
	 A1bhQYr+0gvzV+z6xEZjwdZMka0w5T8ppl9kn1Rnoq2Dl/XprTERRJTJ+SImEIrg6Q
	 CRLqd/6h4NBJOvnwoCC87TC0tOF6mamlktlGki3+Pt4XlKIrui0MLA+tnn4vUkhYQ7
	 XFbwRGDgXNzeKKthtrWKBPW4b+luJ0ChgndRKis1p9FUreefx9dSGBhJFmU/wEXuSG
	 eAUkN7WiysX/A==
Message-ID: <ab5aef53-5387-43a0-beaa-5cdc10ca111c@kernel.org>
Date: Tue, 9 Jun 2026 10:12:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: New design
To: Matthew Wilcox <willy@infradead.org>, "Michael S. Tsirkin"
 <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <aiePVsiV-w-IZ8A4@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiePVsiV-w-IZ8A4@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5EFB210000C
X-Stat-Signature: 9kkxjgzi8upynspdzfwu4ppgch9ah6hh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780992736-102171
X-HE-Meta: U2FsdGVkX18owl3/LQamIGwqt/0o41aWN8+8fY1yq++FmHVTGZ31uRe234ZnXmTVjXx/80LaPqKmJYc5XiAuxhc0ykzI42HsOUWKhgeHg731ku8YyFsNsE8cstUp9BqQ4h904bBJJXlWjhpQPzBXeEt0W5Fn3Srf3eJ6Eq8tUzZleRbW2EPtEKkJL5X/xm1zPaN+WGo/pHmnxgt7IrLIADlcg9K85cQs4rC/idgmPwQrCUXSWBC3KIO34x12k3ivYJBaI3Z0jE0jIXYhzk+LJaJTOhcRIv5WO6ninpQvR4yBf1OY/nRPCHaRkg7driL4Atnk0U9krW5IpSF+p8YamSH27bDe8q/n+7F1aMvfWUsMwjlHa7y/Fv9ywu2I4V53E/J2BrHYpN9zBGdxDq604w1KSHF2WRxWOkMcjcwpp+0KtIAdtci5tAaiKrfF2yLifTwjN3I9pZiYMn4NqMeAIQsn0lKapOGTqiWDdJIzm4R94DlvWrWOIjblYtuxdlCsPgEPa4/bFud7U1ZWgCyqZtb9SVV2pKI+PsAB1cVl74Qq+2Tle3g0GOMDDhG4QhUjhvdT/b9qKpGvBo1YBjI6ZPzUDF8cY8okCxhOTpQ8iFspdLnGxrcZVDBD/zpI4OW+evGv4mVVslGMc6GHfYwcLhr6IO0q59CMhc3ZdZXqc/nq8nLGcmE1CFgPQ555EC0fQvm7lQxfHe+WorOZ7P7dMuxHpmaw6u7Rah4MIvc2w7mwrI0B7bOJUbGoeX5/AHRazJEifAtIgC0J5nwWy1oEi/DLqw0mbLXKXoTD2R8jCt8e6MQZj0n4+NqW2IamI5nq1lhq7QfCZjZt5BxVEPeGgyWevq4Dj+z2/JQvQIVNVX/Jqph63Upjb1cLLKCDWwKF5iponL2K0reR6nUMpLh5HHl4B0CLcJ6KK0r3yjos/woN+RDKqZco8poJkK9hghXcKBkd53rD2ZiRWeSkedC
 jkQOJRwO
 xu+QauFtMADN1x+c0Zyc8GhZsAPiL037Lpn4ZN0TCOrlfckmpgiZtQvH2LNmCzU12MIA92gEJqRTDN6uNOx9wo4SBzQWwWhNp903Eb06ELcXBI7bSa4ZAYD/nTmoN20j9Bnm2kNxcANorDzy1gTkiDu5tt/mt8IcXF9IedVnRaQpY+GBBD8i+1rVQQYRtC8UuNiUPgDlCyktyLLMA2bLYzxYbzsTVDWCMC+LVcpQWhzt1XKX/JUer2lmF28+V1SRKk+59+QXscKhQPUxp7rxY+VZAWungJxqSPR+YHzxev9uASXB7vjMZGu0Lo+tDrGfjLH5SaTXsNjAPI/Exl0bIVf8mXWoZ5elx+VKIvuu/X36GhL1mzugQZWJpMrBAb9Ds5XAH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 05:58, Matthew Wilcox wrote:
> OK, here's how I'd structure this:
> 
> 1. Introduce PG_zeroed for buddy pages
> 2. Set it if init_on_free is set
> 3. Set it from balloon driver
> 
> https://lore.kernel.org/lkml/c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com/ 
> 
> but add FPI_ZEROED instead of an extra bool parameter.
> 
> 4. Introduce page_is_zeroed like this:
> 
> static inline bool page_is_zeroed(const struct page *page)
> {
>         /*
>          * lru.next has bit 2 set if the page is already zeroed.
>          * Callers may simply overwrite it once they no longer
> 	 * need to preserve that information.
>          */
>         return (unsigned long)page->lru.next & BIT(2);
> }
> 
> (you'll notice this is similar to page_is_pfmemalloc() but it doesn't
> need to be in mm.h)
> 
> This step is going to be a bit fiddly.  We weren't expecting to return
> multiple flags in page->lru.next, so clear_page_pfmemalloc() just sets
> page->lru.next to NULL.  So somewhere we need to make sure that
> page->lru.next is definitely NULL, and then allow both the zeroed and
> pfmemalloc flags to be set in it.
> 
> The important part of this is that it allows the zeroed flag to be
> returned from the page allocator without introducing pghint_t like you
> did in v2.

I previously raised (in v2? not sure) that we could using a pageflag that are
only used for folios, and then simply clear that flag on the folio allocation
path such that we don't get false-postives with the bit set.

> 
> 5. Now you can start skipping various zeroing steps higher in the call
> chain.
> 
> I understand David's disgust with vma_alloc_zeroed_movable_folio()
> but that is surely a separate cleanup and nothing to do with this
> patchset.

Well, in my reality, we're just finding interesting ways to work around the fact
that GFP_ZERO sometimes does what we want, sometimes doesn't.

So we leak information out of the buddy to really only handle one scenario:
fixing up GFP_ZERO currently sometimes not doing what we want.

I'm afraid we couldn't use the above trick to punch zeroed pages back into the
buddy: some random user doing alloc+use+free would be unaware that there is a
bit to clear.

So I assume really only folio allocation would make use of this, to work around
our problematic GFP_ZERO implementation.

-- 
Cheers,

David

