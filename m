Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD79B606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=g6yK4vC5
Received: by kanga.kvack.org (Postfix)
	id 061056B05B1; Mon, 23 Nov 2026 07:32:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037686B05B5; Mon, 23 Nov 2026 07:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F956B05B6; Mon, 23 Nov 2026 07:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C85356B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:32:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C151120866
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:32:45 +0000 (UTC)
X-FDA: 85466322690.28.597D95D
Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0299B40003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:32:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6yK4vC5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795437163;
	b=hjvWQlcv9qXils2z3acQhYryXmtpESMQFBo/OZ1mNad9zqIXFdFzmNY5L03BOq+o+k8vXV
	Nl5rQtUAUe9an7B7r1m5k0oBtLrT12ch7t2VARRtnwScnINU7Aa7xfs1NC6fc2juOZgsTR
	VZDhWvIJaZVGVym7AkSQNiXQAPEvL+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795437163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2RVQ3O8W1C8YW2wJ9aXaBh6gRelyzfxjUCFahQNfPU=;
	b=IHEj5N4noBdY98V9U7hGR6/NOQr9naS0OTqT6aHvJW1Fl0W7f5PXL8vxJieULIvaBF/5b8
	r0gEsn54GPEVpOfSGBSukS5rvHZs5BM7uM9tohodG9h8YVa1e1FNd/iIPTSZBZSB3rcNxZ
	oJ8kjiGPwXptzLTa/VHg3yREo9Cr3SM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g6yK4vC5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IaXfb5Hi/QpRbuwTQppmoutVL2pV2Zxy6b6NwmIDvTU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795437161; v=1; x=1796041961;
 b=g6yK4vC5n37WbsNdGMf0BkpnaNq+7uKBUXX15GD4SctWed5eePPBRCkJyQwRQZ4z/2o4XLKV
 YjmYuMufUFgSZOOqhTlUeP2HjKWGmRdRX2H20UrtpcOKL+huQpOCQUOCQ19bckPFv9Cpco69Ln0
 n04OISklYq56LohQvRYFpXuk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6fa58fd50eb09120;
	Mon, 23 Nov 2026 12:32:41 +0000
X-Mizu-Trace-ID: 6fa58fd50eb09120
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <awMX9W-Ykjw4maRg@KASONG-MC4>
Date: Mon, 23 Nov 2026 20:32:16 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 kasong@tencent.com,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>,
 Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>,
 Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>,
 Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 damon@lists.linux.dev,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <71FD1E6D-6F79-42B7-AED8-FCFACAB541AB@linux.dev>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
 <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
 <awMX9W-Ykjw4maRg@KASONG-MC4>
To: Kairui Song <ryncsn@gmail.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0299B40003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cu6boqhsgxrc5iogr1hns6bg7t7unsa9
X-HE-Tag: 1795437162-581710
X-HE-Meta: U2FsdGVkX197qK9CJAdETzKndl8h1ySwbROeM/6IThrqTvi+fb1ZZGTX5XpcjmDKVYXOFW5Qxr8E7XhteS54gqvqD+idYbYmg+kdNVtAS4G/7zEDX24gvvq+v2NHnCsSYTB8YNZrbh7L9cnx30XnFuB4Jl8PJNHVsbgte44lu1rjFgqLdXXDX6fHPmBHxR0UznB7sp1onUXJbMHZYjF41qvgY+rmCW4eK0C0a1Vd3G+TvlolpabknEpF11VZig75A9MJ6j6BkerhEZcpCVDORhlXuiZSvbckimDqxNdT+EMryYyBHeEtqU/BGyfG46eUn4dkfHMFBHlrb9vN5ihjFKRV585RT55iyYAhJYsL1uQ3oTeXxPQRLFd0T2anaDE3p/y1mZhT8hLU6nb2w6D0kd1rmsmGAkBXfCWO0LdlCAPG9T6d5yz95Ow+Spcuuzzf20Ecpw2kMZYCrlvXB8Y5o35ErTGEqBkE6O01dPWeHRZ1OJ5+p6RMCvhk/8FYJs7kg5jvVzK3/puRuqRakyI1z/MDAVicwfGt/qnaQTt/AFaBJ0E69iFXMrhzbG5Zms7QRZy95W+KpTV+tJHY4v4AI+W8X1EiCv7tmo/r7IuuMiaUxgjF1SaJPPGsHVrJHp51di1GHecLgmSVW2hpR1C0/Bx6oPdxoTTZ9Z12v4WNifpImhIFbuW1Mql4uyQk5vhda8ELY+aOthQUT2NLGrA2X8wvw3Rq930mZJc5pEbSHKzdW1jXDQkZxBxrD5PKznjXtFSE/xRGbh+LwmBs9/LKU7iZZxxuuAzjDzPyhDpzLykbt0+p+7FgnUEMzO/AvM4hIUdeJzwzDdEzRkYc42xbV30bZBZ+E4F+EoUOOblip3vz4cFwYAY9b7OqmS9P4HTF9AP/zPIoTXN7PgtYJchF46kePGNkU5vtwHEDnTZmhVxiqitZhX6e0dEFv1fUm4hPjrUXNM+CpftX+0nqoq2
 8KMGgYy5
 2E+PNGrp4zXkW+DHtVRjTm2A3A/9PzHQDUKh/9juHLwsdRaSW0smY8vgLHFI6/lpz9KtLFfXXaOTVlbS1Lizkjl5fw6Flrsw3HXHU+gdEr9rVFJLume6G1syIjcXFqThlWfyqPsLsrdYs9ny5pOmSxtGhR+uVqH1vWXWe9nDGaKvS4snCNizRhLy8hLgpMOxbrHbbhHCc6Bvd4ZDlmxKsGD7gX4xzBmSMTGkiq+rDuFSIfP3Mg4irQBT9VO1gjeZ3bu9y6wn1GfJ4yqZ6s1asMi2/hrQXrEwZrohK1aEVqskypeanb82CzXR2mJrIJiZas97yW+xtvIuKs/ZEGB0qSiQ+V6pe3vL53NO8r0W0vZluG4u/3qZtr+HgrCekCrIxtS8PEg8eie2CDggWFuEhI/AStvU8K/AVbXzqFg7nnWzXlEx6YfmKyVkXmc3xepNT3x4Zs9SFPuI0VLSmtpv+x6AiY3Bjdcdx4D9yUO4QrYnVNWbM4pR5zDYvKHJcn93U4x5AQ2tdcd++x2TMxeI8JzET1rmvYoAEoHpQ22mcBNsUhoRpiI3zmJ6NZTHIltd7Imjpolt7rSNiBltXwqdPOxtO13yfn3U5frJ9uH9gEWj32k4mftC2CMvkFB0yzWUTqDT7AJcQZ4xVtne0Fsr+5QkPaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 01:03, Kairui Song <ryncsn@gmail.com> wrote:
>=20
> On Sun, Nov 22, 2026 at 03:53:44PM +0800, Muchun Song wrote:
>>=20
>>=20
>> On 2026/11/19 05:03, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>=20
>>> Add a helper that resolves a live lruvec for a folio under RCU
>>> without taking the lruvec lock.  It takes a folio directly so the
>>> lruvec lookup happens inside the RCU read-side critical section,
>>> which a lruvec-based interface cannot guarantee.  The first user is
>>> the lockless folio_inc_lru_refs() path later in the series.
>>>=20
>>> Factor the ancestor walk out of lruvec_live_lock_irq() into
>>> __lruvec_get_live(), so that both entry points share it, and spell
>>> out why the walk is enough while only the RCU read lock is held:
>>> reparenting of a memcg that starts dying waits for a grace period,
>>> so it cannot race with the caller until the lock is released.
>>>=20
>>> Move memcg_is_dying() up in memcontrol.h, next to the other memcg =
state
>>> predicates, and use it for the walk rather than repeating the open =
coded
>>> css_is_dying() test a few definitions away from where it is =
explained.
>>>=20
>>> No functional change for existing callers.
>>>=20
>>> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>=20
>> Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
>>=20
>> Some nits bellow:
>>=20
>>> ---
>>>  include/linux/memcontrol.h | 71 =
++++++++++++++++++++++++++++++++++++----------
>>>  1 file changed, 56 insertions(+), 15 deletions(-)
>>>=20
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 980358bc6f49..441a5d57e723 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>>>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>>>  }
>>> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
>>=20
>> Let's make it const for @memcg along the way.
>=20
> Good idea, but css_is_dying isn't constified, maybe we can do it later =
I think.

Fine.

>=20
>>> @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct =
lruvec *lruvec)
>>>   spin_lock_irq(&lruvec->lru_lock);
>>>  }
>>> -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec =
*lruvec)
>>> +/*
>>> + * Reparenting moves a dying memcg's LRU state to its parent at any =
time,
>>> + * so anything added to that LRU afterwards would be lost.  This =
helper
>>> + * walks up to the nearest live ancestor while the caller must hold =
the
>>> + * RCU read lock: reparenting of a memcg that starts dying waits =
for a
>>> + * grace period, so it cannot race with the caller until the lock =
is
>>> + * released.
>>> + */
>>> +static inline struct lruvec *__lruvec_get_live(struct lruvec =
*lruvec)
>>=20
>> Cound @lruvec be const as well?
>=20
> The argument is fine, but tricky for the return value: when nothing is =
dying it
> hands back @lruvec unchanged, so a const argument means a const return =
(which
> isn't right) or a cast dropping it again.

A cast is not nice. Let's keep things as they are.

Thanks,
Muchun

>=20
>>> @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const =
struct folio *folio,
>>>          lruvec_memcg(lruvec) =3D=3D folio_memcg(folio);
>>>  }
>>> +/**
>>> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
>>> + * @folio: the folio
>>> + *
>>> + * Same as folio_lruvec(), except that a folio whose memcg is dying =
is
>>> + * accounted to the nearest live ancestor, which is where =
reparenting
>>> + * would put it anyway.
>>> + *
>>> + * Return: the live lruvec, with rcu_read_lock() held.  Pair it =
with
>>> + * folio_lruvec_live_put().
>>> + */
>>> +static inline struct lruvec *folio_lruvec_live_get(struct folio =
*folio)
>>=20
>> const folio?
>=20
> This is doable, will do!
>=20
> Thanks for the review!



