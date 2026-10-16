Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04928CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018E06B0088; Fri, 16 Oct 2026 05:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BE46B008A; Fri, 16 Oct 2026 05:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA1D6B008C; Fri, 16 Oct 2026 05:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B851C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:10:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FF901A02E9
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:10:28 +0000 (UTC)
X-FDA: 85327918536.24.352F906
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9E62880005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:10:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PxIXY0NE;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792141826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQnwrUfNm3jsn3MxHgrIQqJPSqdJuL5EGSnnMWNAqXE=;
	b=TF1oVCwjfI4yZe+OWthqscsBXU3Y5ClYyHJY93uz68sWkpQ5MW62hgZ+99f6o39hHIQlGk
	oqVvenHK/dl6tMBof1IiCrxbhaM2CZnYgzMIidXxYGjL2w1JQ6pJMJRVphWXgRfj9VL80/
	mSvNJ7d1+lj1BsOUTxLJtiStIeMOox4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792141826;
	b=cnM/P1a5uGt6nIaTGxiY0zt+JFRcqjK1I+anFhDiyc/eTUS0XtstYZagzMP3+VYEzsHXx+
	gFaqKNJIQlL2O3jxOGsa0bSIvUg2L/CdbRAlKRyBtr5uaQo5eAafO4U7o4c74FhBFEmFng
	AJurndEJwqyR62kinTYWNgE08W/aEjA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PxIXY0NE;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OENjaTjOgQb8XGZqbEf0lEkD3kxNX07o2dz0fysyuho=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792141823; v=1; x=1792746623;
 b=PxIXY0NExfUOvRcUq3uL5hZlC/O5i217b9VZg4VQ21TzGKJot1gABI6sWVZFzy3OyeOV3Zd6
 MP1ROAV6HRHSTy+xiGWJryGMOushw6///dSFlHeRQz0TfB2fWDplrcqCCPIIE9wubsRNkI9q3pI
 7oQD8wBp7McS8wHtNE6CB/Rw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e80c5830b724ad5a;
	Fri, 16 Oct 2026 09:10:20 +0000
X-Mizu-Trace-ID: e80c5830b724ad5a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CAMgjq7D-2HyvuD5U58ohv4YuyuCEbxYAO_wxkx==WxhsNQrXXw@mail.gmail.com>
Date: Fri, 16 Oct 2026 17:09:54 +0800
Cc: linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>,
 SJ Park <sj@kernel.org>,
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
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
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
 David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>,
 Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>,
 Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 damon@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <89B5F552-25E1-4EE7-9B76-8239490125B0@linux.dev>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
 <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
 <CAMgjq7D-2HyvuD5U58ohv4YuyuCEbxYAO_wxkx==WxhsNQrXXw@mail.gmail.com>
To: Kairui Song <ryncsn@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 9E62880005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zhghj3w47a6un7p8euq8wjgy4ur9mfrr
X-HE-Tag: 1792141824-372456
X-HE-Meta: U2FsdGVkX19rXse6LswrWc0v2snUFV0+gPM8npYba8+Fu5JsbChA4jRYU4mEckLgNO2h+maLfM8381JybxXzM+Q1d1X9+jU0OtrSSxbx8XsQQvlAQ0t0JhWCvON3BZ7Z1wZ/ZfK1PauKj9766aInKFOgxzThqf97u4444Stx8HzIwn9Z5iXJAnaE8jrWFF4ZMfE4QT3+TgBrZXwkfRUfsP4NKZP2HjszrlFFEOmpFih/BlvN62z1RP2GzjmlG23NW3R8Lp+Nl01eKpMBd49tO+cIqFZgO1tx3l7I93CuTbgulVwYMje/Lt4yWxPgok+nSXzw5soYm2gdP9aBxFbiKnls26IPsP5CKh0DfxrITA4uc7NGw9w+86MydGXObgUDR1YzT6vxQxBX3t8vJt0wvvvTlX7XVQxmby7ixg42P2B4Ouevm3Y+wdcJCw//Yu31lWFXvKdeKrxo8fyra7LB3gwZEoHTzTWWKl8i2nP6Ye8Za7FmOF/qnEaJ4rmbakuIFv1WuYEPNbI0Kg4GgTdgQBnCKWmLkHia2LwTcpZ/wItMzKzaFeyPVau81EAhztYY1U1U5pWJ+O+4ULmOE4npWu+i9xAP4JupldjppLkz8NWIL6FFFpsONCaaju0IfMUD4WtJ1P+TVqCTVRJSmecIW8p0LQIk94rTQzXIbQ99Fxkgc1keXPvEj4M3wbucCKViXSPCIb7Gety0rebshYeQ5dRJKs6JMHqSqR0hx/OrJSrsp8pgZczZ8MW79BQtZ4tNCzPQBLWho3Pv4SPqYxWBKTbNZvvgyxRA28b514hfkx6TplbRidWnSW1b6yDRlkd19/WVnUEn5eqJk7ftwvzKMdDP2bdYbC0NB+Q6nrMdcXCoYGNT0ZCbATCb0PwVJaHyHVTUsjpP4odbBskqvfQinFxA+NpJwUSwc8To+7xs93gmwz+cElyNuph7k2BuBqCLykwU6chrDN61SIq36Iq
 2B3dROSt
 0O7YNj5G+4SsuREXR7e+5IiNJOuw30wO1M+AFqyrzkhNBR7YLa5lF2dTZ6arNpj90C0nzt0XRj1RMg59Bm8ERWpOTmxtouJkqcJU5wm5a0dFRwONkGv+vx2BIQiSHv87+iOifUiG8wNj7pWlfK8Axs92b+15Uqr0kiu9PCcG2nupz14Yqh86H763ttyDjsXlW4L1PT6/1ridIUdSspfLzEFVshP/rqJABEOiW5W84IEi43HUQtVUNXko05fAxBDFJMqK3xVeGlw3HtVgtD0Ne4HHXtOAKH/ttN8NpuBxXmKtQtyUVrAQuoPabhgjCQoJFeLKSexGZ4sq7L0AFohv4aIXdKr9hs2zKuaX/Z1YShs2EMBx5RnMK9wlnBeDqN7OQF3xBbwAH2tbZO+I/9x9Zmqhf2f+Z/pJouURCC29bdqGLAJdQoGjaERZ+i7QTOCsOys3czpT1JyuWVo+uJ/dp1Dn0bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 15:54, Kairui Song <ryncsn@gmail.com> wrote:
>=20
> On Fri, Oct 16, 2026 at 3:39=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>> On Oct 16, 2026, at 02:15, Kairui Song via B4 Relay =
<devnull+kasong.tencent.com@kernel.org> wrote:
>>>=20
>>> From: Kairui Song <kasong@tencent.com>
>>>=20
>>> Add a helper that resolves a stable lruvec for a folio under RCU
>>> without taking the lruvec lock.  It takes a folio directly so the
>>> lruvec lookup happens inside the RCU read-side critical section,
>>> which a lruvec-based interface cannot guarantee.
>>>=20
>>> No functional change.
>>>=20
>>> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>> include/linux/memcontrol.h | 39 =
+++++++++++++++++++++++++++++++++++++++
>>> 1 file changed, 39 insertions(+)
>>>=20
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 74110a324f9e..829ab776ab44 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct =
lruvec *lruvec)
>>> spin_lock_irq(&lruvec->lru_lock);
>>> }
>>>=20
>>> +/**
>>> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
>>> + * @folio: the folio
>>> + *
>>> + * Computes @folio's lruvec and walks up to the nearest live =
ancestor
>>> + * if the folio's memcg is dying.  Paired with =
folio_lruvec_live_put().
>>> + * The result may be stale: RCU keeps it alive but does not pin =
@folio
>>> + * to it.  That is fine as the counters are fixed up on =
reparenting.
>>> + *
>>> + * Return: the live lruvec, with rcu_read_lock held.
>>> + */
>>> +static inline struct lruvec *folio_lruvec_live_get(struct folio =
*folio)
>>> +{
>>> +#ifdef CONFIG_MEMCG
>>> +     struct lruvec *lruvec;
>>> +     struct pglist_data *pgdat;
>>> +     struct mem_cgroup *memcg;
>>> +
>>> +     rcu_read_lock();
>>> +     lruvec =3D folio_lruvec(folio);
>>> +     pgdat =3D lruvec_pgdat(lruvec);
>>> +     memcg =3D lruvec_memcg(lruvec);
>>> +     while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>> +             memcg =3D parent_mem_cgroup(memcg);
>>> +             lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>>> +     }
>>> +     return lruvec;
>>=20
>> Hi Kairui,
>>=20
>=20
> Hi Muchun, thanks for the review.
>=20
>> Actually, we don't have any means to guarantee that the memcg
>> to which the returned lruvec belongs will not become dying
>> after the return, right?
>=20
> Yeah but Qi once mentioned that RCU prevents reparenting, right? Even
> if the memcg is dead after return, things happended to it
> (non-hieratical counter reparenting, ones in __lru_gen_reparent_memcg)
> will only occurs after RCU unlock so we can apply counter update to it
> without grabbing an ref, just hold the RCU.

Thanks for the info. I checked the code and confirmed that, aside from
keeping the memcg from being freed, RCU also ensures the memcg doesn't =
get
reparented. If your scenario requires mutual exclusion with the =
reparenting
operation, RCU can handle that.

Thanks,
Muchun

>=20
>>> +#else
>>> +     return folio_lruvec(folio);
>>=20
>> Then, I'm wondering why folio_lruvec() doesn't apply to the
>> memcg scenario.
>>=20
>> Internally, folio_lruvec() obtains the memcg through
>> obj_cgroup_memcg(). So when the memcg becomes dying, it should
>> be reparented to the parent memcg within a short time.
>=20
> I wasn't sure if grabbing RCU can ensure an already dead cgroup has
> not been reparented yet. If we apply the counter update to a already
> reparented lruvec, then the counter is leaked. This new helper is just
> a folio version of lruvec_live_lock_irq.
>=20
> I got the idea from commit de4660898b7a, which says:
>=20
> """
> .... check CSS_DYING under RCU before
> flushing the pending batch.  A non-dying memcg keeps the original =
lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the =
deltas
> to the first non-dying ancestor.
> """
>=20
> Applying counter update to a dead but not reparented lruvec is fine =
though.



