Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6691606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HpTsg0vs
Received: by kanga.kvack.org (Postfix)
	id EFD976B05B1; Sun, 22 Nov 2026 02:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4EE6B05B2; Sun, 22 Nov 2026 02:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0BD6B05B3; Sun, 22 Nov 2026 02:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3CA46B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:30:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41A36A067B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:30:42 +0000 (UTC)
X-FDA: 85461932724.09.258BBF6
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf12.hostedemail.com (Postfix) with ESMTP id 10BA740006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:30:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HpTsg0vs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795332640;
	b=hgDBDMqZ3gj0wqxj0UIO29JHusDTPDh7fPIMNY/a4vM0Vn44Fh8+YicMIeLb9SjozEGc8N
	xck1vo2nFzThaVaUos8M/m0xzjf30vdkfejNYGqXAYRch31S4Xx9VsdFPAHTpPPHtq5Kn0
	fjdy98bk+kPOC4SvCLLUpIHp29kSHIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795332640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H02gl3A8lED/orev+VVlUTCHLPwpp1eOdDDA4V8ytIA=;
	b=f7PasNvaIZiWOWrRrqtzbzPOEf+MIA43o1jUGC74CEDIC2jyfkarZMK6vI5d9Lo8EBzG2c
	O5BWYx7qFqUEeriQ07yNEWjxSBSVQxVJfLnKuAVo1Qvoa8wCK67hagWcGoK/oFx801XAFI
	Hrj622knPrQ0mi0HTD3myWvS9Lr13XI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HpTsg0vs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NLC7oANZwCfL7depjHfIzJ4jloTo6BAzdIgGpvntEFI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795332638; v=1; x=1795937438;
 b=HpTsg0vskqQxsfGCwnJb31GRPaj1j07wdTUu0g+P5JpBon6ebxMWHn69SCrjjvvccIAxv6uk
 EPGyaVeJeS1yCOFOubeJhafrGVczqk2jFtsW4Zl5OO6iEaa3zssaHLaixwUuUu0RCAc2OR8iQ0S
 bHHZdsDLF6vDHEwK7gqJFpgw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b98bde626d255cef;
	Sun, 22 Nov 2026 07:30:38 +0000
X-Mizu-Trace-ID: b98bde626d255cef
X-Migadu-Flow: FLOW_OUT
Message-ID: <3af03366-784b-48bb-a807-9ccea92e39ca@linux.dev>
Date: Sun, 22 Nov 2026 15:30:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
 Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10BA740006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: yf1koxw9c88p1o4wxxa3dx53fmzdzut7
X-HE-Tag: 1795332639-442176
X-HE-Meta: U2FsdGVkX1/JyZYW0kqnxfCep/HMCoY1pvKEIgN8PaaM8TJhQw5gTSzZwpzgO9IAbkom56vd3Ff3K19TIZtKs+qSJhFQOe9v3agBiHfSjeycfeA0ngH26qDBjI95dV8+v4A6YT02+EYxcJZjgISrhOqUdM6evt0RA8d51RzBXzKnEc0cEpdCsTDvPndroqVw9pzhdJTkyVLfdWyRDG0ViAbArOZxEZ/XA1Uew/OgTwABplHm59z+97Lp8RoET5eAwgP8uuA5M5kBHlfwg5al4mmToDXfLMQwmHsaezsuPaeYgpebc7XhwO8RnTv+dphkd6LP3cVd0V2LT76CV/Vx7JyhSIIC6PkiUoCzBcHHqN0qtGZ68NcbfCj2dSk2CVtbMWswH7leJ0D7yE2DnSA+s2FOflYKgwXfQh5szFt8AQQRZo83tvPFKIR40Kf+nUX6tElSFM7yroj71mAaw6siHzC2vF5JohSqKVI7BWtih58fWDS0T8RsLR4HEIYSREGoX+UT6nZkVuX0rm+bAc6dtVGZ9Jw0AfZOO+hn8yHXaSTxhPkNYZ4rvIahTsEsuD/2Ks4rf8a0BlxYwt62MxV4c1VI+GYQR0IxIOR3pxirGjnBSSBGyKaaqkbEtRiynuRFxQjt9jbJk5qY1afX9nQL8s9DWdK4MSl9KfIu5iKbIbHt8zUxaHYI2b4bBDUMP2BETQi6vESsUPOgTlcf9RRaXYv1RKb3fQiU2PZtFlxo6fqC84N0PrAbyuaTvOw905M7dVM7XG/BfTifwl1MAmXfvzFzJqwukQwvI0Ssc5s7vz6G+bxC18d1+Foi258iIi1ZTEHhVYSQoD+ICQWzDhWCggA1cdeOGMDXr2eCZEg2OJIp9gqeUtNuVZj+/uRbYv2zy39CrrNyfdmdXxZzNnTLGCH+oQW2D82pg0kJKVYgprIoxjYmpRiZ6dY41Tp73+cCP6ed+lDM1GHOhVK7QPf
 NWWR8FSk
 KAWKUOCu6vc3IRvCXf7hYyIc3s+2Jx7LVIQZGzWOzVqU3JSDyh7PiP0zg5ZMqq8red9YniBJhRRaWAGMij6aBYiC10lA2WQ1Z7bP18OmDIaa3qrKmlfFK04DsrPMmvpMoS2t20XuPjcK1TxORs/un+96BGo3YyX6EIlvvOkqAYxEdytk2dSpCSrOR93t8/eczRxAv9Ajqg1Gca7gSS8bBT1NmgKo+jUCPDg3Q/nzmRbHWiiSGafyCkHqgj3dZJS8vf9kDVynjpcsftayQgy1bVAKC+p7Paqy85hPLTMFawPxEujqa1aWiK3lANmGtgxIHgzseiI6DJ/JXOtKQT0XhbD+j72G0KHbAcqCh4CR3YF4rLLqNaFfC81aVPw5i7lfX9GU3r/2+usnWPyQ6EcNoYOn80zRQ8juOHEKItXvrky1ftVRBQfWTXhphejotd2WDNQVEKyKL4rvJgkhbGhrYsnepXDWXoA3hHbCRoDF46b6T7NdOs6LPpR1wXiLmlF1lF6MFaKnNXTXqIawjRUIAKt0r6cqgVSX9tXIGRTzfiJGlatBZr3Vz9eYX5NJtnUokE6M0UuSQ1oBxu3pxjz5CMrDvAVGDuqj1EE9/PZiJvf/jv0P7BNPUwLotGb5ZJOQduZqWoQVmNkxOICw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/19/26 5:03 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Add a helper that resolves a live lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.  The first user is
> the lockless folio_inc_lru_refs() path later in the series.
> 
> Factor the ancestor walk out of lruvec_live_lock_irq() into
> __lruvec_get_live(), so that both entry points share it, and spell
> out why the walk is enough while only the RCU read lock is held:
> reparenting of a memcg that starts dying waits for a grace period,
> so it cannot race with the caller until the lock is released.

Right, that's the ordering: CSS_DYING is set before the reparenting in
the RCU work, so testing for a dying memcg under `rcu_read_lock()` fully
covers the race.

> 
> Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> predicates, and use it for the walk rather than repeating the open coded
> css_is_dying() test a few definitions away from where it is explained.
> 
> No functional change for existing callers.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
> 

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



