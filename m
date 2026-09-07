Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBC2C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E18A6B009B; Sun,  6 Sep 2026 21:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491C86B009D; Sun,  6 Sep 2026 21:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3810D6B009E; Sun,  6 Sep 2026 21:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0E1B6B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:44:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AB1FA4AF9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:44:54 +0000 (UTC)
X-FDA: 85185272508.19.45F044D
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2D5091C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:44:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZCwUwJdn;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788745492;
	b=MNKT68K+MFbMZoXUu4Qsbw2Mt9znY0dcjv1yu22MDZSH32bhAoLVIY7ciyiRui8r8Zm5x8
	LYgSI0VidnQSM1Bh+FQ/pG3io3ulYF7TXQvYrdkOX5bWEu+YeflFPnIlgYwpgTHdOYDAIX
	jM50G4Eo6QrIGrHdMApy1ifnV/9NfDc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZCwUwJdn;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788745492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaBC8boHKgf9GrNtk6/5x8L2pCqXd5S9ucBUpnHSZlU=;
	b=v+qijVSC7jgJai8s7eLUMQ9BZjCUzOberD09p3JLb3CExzlUrtLXtEGXeTzvKoUl8l8SLt
	BM9PJ8VjmSi443aAl3vPbcx+bfEOBx68F1rf/7LZ7fwF+ABQW+pH4CTZvmqrNgfUZ/qVko
	WUGt8Uhz36N7KXPn9oixvP8T/yWOPK0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XMR5YJjRPObLoKxi0OzfqaRkyg3NKVdX/m6x9mGp2oc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788745490; v=1; x=1789350290;
 b=ZCwUwJdnQWZStcaR1trmencBxswFTSJP9SSHtDQ85LnJZyNu/A4+4jTNLdmgUIHqbaDDb+JB
 LQudeadFJtMDgfTF6V0UwmXbodmzrtZ94bHIiO7J/kDN+fKED7jno1P5IJE9rmIMHXiHQdMxRy3
 k3qmsR2+SEnDwKHBqxMKh+Q8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8afd76475cebebba;
	Mon, 07 Sep 2026 01:44:40 +0000
X-Mizu-Trace-ID: 8afd76475cebebba
X-Migadu-Flow: FLOW_OUT
Message-ID: <33a37382-28d0-420c-9254-431e1b7e6d6b@linux.dev>
Date: Mon, 7 Sep 2026 09:44:35 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v3 2/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
References: <cover.1788514750.git.zhuhui@kylinos.cn>
 <2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
 <20260905184229.8f7f30cf10638e7dc8224467@linux-foundation.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260905184229.8f7f30cf10638e7dc8224467@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D5091C0006
X-Stat-Signature: eqywiezz7hcpxbetkohk74gds6g3jng4
X-Rspam-User: 
X-HE-Tag: 1788745491-706362
X-HE-Meta: U2FsdGVkX1/LFZps8GYC4bCSYhYzoWPxm7uUASPzBUvvlcy0eF4trIsNiK8zgeSxC18LYqF8ng41rURnz7GmNOmw0/+TqcsgCeaMmoKfkholT/s1keM4nHbw/i0PYljPFDg4Buk2ih1TkI7o6+oZAO55/zw/XSVDdgCqwwDDU/0Z5MCSzGm7heobwr26eHftju2JIDmt1mL5AaooM3I94lXGD2SCjgWbr2Bh671iz6RGGO5YYEyq6WjIjMP4anAU6j73Ym0Eo6CnCuPGP8y1362xZnRUHUDdn+xqXAJcgXdaFP0dN6suOW+je28DHvMNSixmcgtu+NQMno2fqQrp5QscFrMaVtBIPmeSnvIXGe/CKV9SpfzIT7kq088J0okkyynK0DjQ2yvm3bSo9k9KVU+utTyM1fVvb44NEj0sk7PmbJ641s0pc083uQos90kRHZHBD3ROS7Kq93Q7A8UkEEn/IYG7DOYLsgaG0EbmUIJxeG+gJST79Zfk+izKItGWCohpg4y2Pa7l2G952PYix5Cop8bkhFsDS5521+diaMkb+gyDHCUYoXDp/lxMCUhfbGQmdeZL/pxE5F96irUxk8fH0HzTbUCyUd4lFvXun9hL7TBM1XEWyFvg/gFe9ce9bPo9BBsZjfsiXFU2HNmW2xXvdB3BUsKbzz1UGVp1AwK71u97rVkB8XhabIG5URxr+Ina4h5vstKURd9sEA7C8pmyecbPROi8bd5b0xTH5VfqK0sCfCWHwXty0saax8K/Y34TDnqT9sWRSYTxPNtajIxMEmsWMzUeYKFbqN0auSFVatrebDgDTYVzh0UJqOAuBt6aUG2G5Dqe5QUPeoL2hd/H2w20ZXZfZNzmvmaQip1Dq4ax2cPX28Jad1D7its2kegPgkFWSTH9iMjtv02igXG39kb3mQu1zQpUXkZ5rRxYxx6w129MYFPTBwR+kekENE/y6P5pC0mP4E6TojB
 L6XCzoDY
 pXFGes4hwHuF/ganpAdISu/NfnGLRMg89r5L7pBIgJ+AfChSaLAQTNTmvB8uEmq8MbFTgUGvQsEHxTD/tSijqta9XoMVIKSJqc5hftZ6PWruIJFFjuKp97r3OF6Qap4SqREkMTD6ZZRU49chzElvVZwHEa4cP+U8XKXEtOqifVZAOuRFtueL8ToWpN7I50R+rLSaKzxo+hsE9VIwJS1zB4ZYhFN9cdLLAuq/C+piAP/VvJzuX1xQ7zuTwy/mspaAOzyVGf+8/o0AEkxXwU8/IagvL9tMAUKUkQMhno0iMMX/MNtwo4g+R/RTG7ZOh7x//h9T0coScBjOmmJyXk9yXLT2x1rniSVDE5BMU57QQOu4konG0q72dxMCWCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Fri,  4 Sep 2026 17:45:55 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
>
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
>> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
>> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
>> which only the classic LRU paths maintain.  MGLRU accounts its pages
>> through __update_lru_size(), which skips that array, so with MGLRU on the
>> four evictable LRU lists are always seen as empty.  The shadow node budget
>> (pages >> 3) then collapses to slab plus unevictable pages, and the
>> workingset shadow shrinker reclaims eviction tokens almost as fast as they
>> are created, losing thrashing protection.
>>
>> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
>> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
>> race this re-exposes on cgroup v2 is closed by the follow-up patch that
>> redirects dying-memcg stat updates for all hierarchies.
> The follow-up patch is "mm: memcg: skip the RCU lock when the memcg is
> not dying"?  But that's an optimization so I'm confused.

Sorry for the confusion - the commit message still says "follow-up
patch" because that was the position in v2.  In v3 the series was
reordered as requested, so the patch that closes the race, "mm: memcg:
redirect stats updates of dying memcgs for all hierarchies", is now
patch 1 and comes before this one.  Patch 3 is indeed only an
optimization.  v4 will reword this sentence to:

The reparenting race this re-exposes on cgroup v2 is closed by the
preceding patch that redirects dying-memcg stat updates for all
hierarchies.

> If we're re-exposing a race, the fix for that race should have the same
> Fixes: and cc:stable as the commit which did the reexposure?

Yes, and it does.  Patch 1 carries exactly the same tags as this
patch:
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the 
number of lru pages")
Cc: stable@vger.kernel.org
Patch 3 has no tags because it only recovers the fast-path overhead
that patch 1 adds; it fixes no bug by itself.

> It isn't clear why any of these patches is cc:stable.  The overall
> effect is a tiny performance improvement?  Very clear descriptions of
> end-user effects are always helpful.
The performance table in the cover letter measures the overhead that
the patches themselves add to the stat update fast path, not the
impact of the bug - sorry if that was misleading.

The end-user effect of the bug is the loss of thrashing protection.
Since 7404bd37cfbe, with MGLRU enabled count_shadow_nodes() sees the
four evictable LRU lists as always empty, so the workingset shadow
node budget collapses to slab plus unevictable pages: for a memcg
holding 1 GiB of page cache and 64 MiB of slab the budget drops from
~35k nodes to ~2k.  The shadow shrinker then reclaims eviction tokens
almost as fast as they are created, so a refault finds a live page
instead of a shadow entry and lru_gen_refault() cannot restore the
workingset state of the refaulting page.  Hot file pages that should
be protected are evicted again and re-read from disk.  In other words,
workloads that refault page cache under memory pressure thrash, with
visibly increased IO and latency.  This hits every memcg reclaim and,
since the root memcg is iterated as well, global reclaim too.
> So at this time I'll schedule the whole series for 7.4-rc1.  If there's
> some reason why some/all of these should be backported then please lmk.
>
I would suggest backporting all three patches together to the trees
that contain 7404bd37cfbe: it went into v7.1, so 7.1.y and 7.2.y
carry the regression.  Taking patch 3 along with patches 1 and 2
avoids leaving the ~0.6% fast-path overhead of patch 1 in the stable
trees.

So v4 will reword the reference in this patch's commit message ("the
preceding patch" instead of "the follow-up patch").  No code changes.

One question: should patch 3 ("mm: memcg: skip the RCU lock when the
memcg is not dying") also carry the same

   Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get 
the number of lru pages")
   Cc: stable@vger.kernel.org

tags?  That would make the stable trees pick up the whole series
together, but since patch 3 only recovers the overhead of patch 1 and
fixes no bug by itself, a Fixes: tag on it may look odd.  Please let
me know your preference.

Best,
Hui



