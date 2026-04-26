Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44FE4FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 05:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3386B0088; Sun, 26 Apr 2026 01:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694536B008A; Sun, 26 Apr 2026 01:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8EE6B008C; Sun, 26 Apr 2026 01:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 467506B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:50:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE11CA04D1
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:50:54 +0000 (UTC)
X-FDA: 84699633228.18.EED96D8
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id BE026180002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:50:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IN3MqOO0;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777182653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kb3H3rW7NU0018MqykYuVnLzoeob+L0x69+WsyTVnFM=;
	b=XnfGjo8XyW9gl8ab92W2LehDFWbGTu1RqxkKwrlsLVEU/4XuWOgTc6W1m9YNd0xL51OQmS
	NNRAXigzVTXK/YMltZKF9LfAfAcfeOHFr9hmIMFB/mo9fxJPdKqwccrG3tnCNsEdxrlo3C
	tKfX/2pw09JuON/6kRFZIDf067eH/Mc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IN3MqOO0;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777182653; a=rsa-sha256;
	cv=none;
	b=pSLIOxWoQjerzdfKZadG0SxGT82Zso//aAULEJz4VJosKGOp3RDaCnAe6+KZxznWTf9LnJ
	tN+ozCX3OA8woUo3GrPhJkSLsZ6Ux0b/85D7NrkKNxTej7k8f3fX7Fe8g4c+3SOuQFyNF9
	dwxNoGyDNc9kaTshPCrgjt4aP+cUPkU=
Message-ID: <afcbb502-b91e-47d7-8fb7-2e4e237928c5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777182650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kb3H3rW7NU0018MqykYuVnLzoeob+L0x69+WsyTVnFM=;
	b=IN3MqOO0OIu0sinrtIqVJ/fapkg2iQtX4L3/rRf1a6f7UyNvfE0ng4j1Z8h7CnbiXQjW8X
	8+XO4kBSapxKPwrhWuzA23e3hj3pRXYqBt8/Px6APNy/MlTySOKvzwtm6RQYbCF72pzE6A
	iW83IMo8dGYan6p2m/TbubarYmY62C0=
Date: Sun, 26 Apr 2026 13:50:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx
 PRNG
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260425155953.89674-1-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260425155953.89674-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: o3gum1eceh5a4wbb5cbir34fxieawc4u
X-Rspamd-Queue-Id: BE026180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777182652-574250
X-HE-Meta: U2FsdGVkX1/r49IXzitHLAouJRIVRkIeQV8p6kFONveE1JO28px9rd2TthI2sMlO5yl6k6NaakshvtFdWusHGNtZGRIAWkMFH+QSm0emfsQvSyBPyIi/ZLe+ZeYzWpovK1y8/rjVeDD4bRoA9h0a9UNUofdNLgDWL7dFHXcGohpzP+hbKvS9CGBzOqt4gD9QPYHdLM9Psujv8N1EZewINXtFc/14msiHglOPMBUjqEkZeofa/4pimXnLHRurIhGR3lms31hx+WwSrfgdfP1lt3c3MlYIWAUJs3JTW1wvbwD/xB+chg2fbuMDDQbdBfH40EUle+Pdt6nv77wCXcCH6rngiKRmBgni24TslTkf4HrK1oUMTrMpouxCWS6LY4n43/B8jEmm7vOlRNEmgAtGQCagrmRwYwho417UPq0ZTOHY7m03+4rpzAhVWAna0jUBOGjqwlQIv3JSRTbAXlBIhkOnrC8+Wu5xE8U27qqhiRf0u2PTzM7qIVjVoCztMFs0QaWbUL9qXcUVsS/vTwFVh+LtrER9wJcdBkk25ecN/H+J2Ovh3TrSW15c4P+iKLWPqZtYkMJX1y3KmJLYaXKum4wubgx41B2XSZ8DN/Xez3au+BA2Ye1ODMmvqW+VLDDciaithji89klQvvCt5y4rdk57CN/wnG99PnYDe3XCjO/Pa3SrHFOe47BVJ+aoGhoHkFXynBUISg3ttzSp6u2gnR7YvJ3X9x/Hja69aiZCP6aQCHrU4+xL6rSW8Odi8NQTiF9WHfedOYX0oRIU6gaRsPgr79O0LbRmOw9csCrWB9WzCRIZ6frBJecTLURSBzymIw8MEfO5Qn0tUgNA2yGfcGK63mSrnodxKQie2tJ7PZyge3ES3j5FhP9BBehLq/z4ggxgs36TIsimvFJX4wFCITqCYc1zGTAFeXQwAjwRf3rHnyOs8mxjHmcvEmFYcALenk+TLTxNU+qybrU1Z9i
 /OHQoJDn
 idW4LZ2nLXHyt5wl3qgQ8z5F4lOwlbdYN1NuUMrfGCCNOS+II1XqSM20m7Y8y2cVdHXdxo3ZW5fzn+m3v81Xkhxfjq6vOtDIG66sffm6WaEl6bW8F1BEijRMmi3Dv9pj7RJBT/DpMqvG53byhV2kq+p1UNqDGS7CIWMjkEkM9esWfEXEeBn4OyRnp+ZJcPf+IEA19GQ2R5vcvCMpIke0yzkG1uFu4BkOkgvy+YhRZL35BjNyHW7upekp9H8AjQ2o3/H9dU6ooCTwVDY88ViQr3O5zSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello SJ

Thanks.

On 4/25/26 11:59 PM, SeongJae Park wrote:
> On Sat, 25 Apr 2026 11:36:02 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> On 4/24/26 11:11 PM, SeongJae Park wrote:
[...]
>> With ~2 GiB
>> default regions on a 2 TiB host, a small pod's pages are averaged
>> with thousands of non-pod pages in the same region, and the
>> region never reaches nr_accesses=0 even when the pod is genuinely
>> idle.
> But, the adaptive regions adjustment mechanism dynamically change size of
> regions, down to 4 KiB.  If the small pod's page is really cold while its
> surrounding pages are not, DAMON should down-size the region to capture only
> the page and show you nr_accesses=0.
>

Looking at kdamond_split_regions() / kdamond_merge_regions():
the per-region floor is 4 KiB, but the *total* count is
hard-capped at max_nr_regions, and split itself is blind --
it picks the cut position via damon_rand(1, 10) without looking
at access patterns.  What keeps a split in place is the next
merge cycle finding the two halves have visibly different
nr_accesses; if a small cgroup's signal is averaged with
surrounding host pages on both sides of the random cut, the
halves look identical and merge folds them back.  For a 1%
cgroup on a 2 TiB host with max_nr_regions=1000, the
split-merge loop never converges to cgroup-aligned regions --
random cuts almost always land in "99% host + 1% cgroup"
mixtures.  Raising the cap gives the random splitter enough
attempts that some cuts happen to land on physically-clustered
cgroup pages (THP, NUMA-local allocations) and stick.  That's
why the cap matters in practice, not the 4 KiB floor.

>> The cold signal is gone before any cgroup attribution
>> happens.  Cgroup attribution itself is done at sample granularity
>> (folio_memcg per sampled page), not at region granularity -- the
>> regions just need to be fine enough that there *is* a cold signal
>> to attribute.
> Could you please share more details about what is the cgroup attribution, and
> how it is done?  I guess that is the way to map DAMON's monitoring regions to
> each cgroup to determine if each cgroup is hot or cold.  I'm unsure how it is
> really be done.


We sample physical pages within DAMON regions, look up
folio_memcg() per sampled page to find the owning memcg, and
accumulate cold bytes per memcg.  Userspace reads the per-cgroup
result and sizes memory.reclaim per pod.  Conceptually similar
to the page-level monitoring you pointed me at -- we'll evaluate
whether [1] / [2] can replace this path.

>>>> With the default max_nr_regions=1000, each region covers ~2 GiB on
>>>> average, which is often larger than the entire target cgroup.
>>>> Adaptive split cannot carve out cgroup-homogeneous regions in that
>>>> regime: each region's nr_accesses averages the (small) cgroup
>>>> fraction with the surrounding non-cgroup pages, and the cgroup's
>>>> access signal gets washed out.
>>> But, pages of cgroups would be scattered around on the physical address space.
>>> So even if DAMON finds a hot or cold region on physical address space that
>>> having a size smaller than a cgroup's memory, it is hard to say if it is for a
>>> specific cgroup.  How do you know if the region is for which cgroup?  Do you
>>> have a way to make sure pages of same cgroup are gathered on the physical
>>> address space?  If not, I'm not sure how ensuring size of region to be equal or
>>> smaller than each cgroup size helps you.
>>>
>>> We are supporting page level monitoring [1] for such cgroup-aware use case.
>>> Are you using it?  But again, if you use it, I'm not sure why you need to
>>> ensure DAMON region size smaller than the cgroup size.
>> This is also why DAMOS memcg filters do not bypass the
>> nr_regions constraint -- the scheme's access-pattern matcher
>> operates on the already-averaged region, so by the time any
>> filter sees pages the signal is already lost.  Whatever
>> attribution mechanism we use afterwards (custom callback, memcg
>> filter, page-level reporting), the region count needs to be high
>> enough first.
> But, I'm not understanding why the regions adjustment mechanism cannot work
> here.  Your answer to my above question will be helpful.
>
>>> Fyi, I'm also working [2] on making the cgroup-aware monitoring much more
>>> lightweight.
>>
>> Looking forward to it -- hopefully it'll cover our case. 😁
> I hope so, too! :)
>
>>
>>>> Raising max_nr_regions to 10k-20k gives the adaptive split enough
>>>> spatial resolution that cgroup-majority regions can form at cgroup
>>>> boundaries (allocations have enough physical locality in practice for
>>>> this to work -- THP, per-node allocation, etc.).  At that region
>>>> count, damon_rand() starts showing up at the top of kdamond profiles,
>>>> which is what motivated this patch.
>>> Thank you for sharing how this patch has developed.  I'm still curious if there
>>> is yet more ways to make DAMON better for your use case.  But this patch makes
>>> sense in general to me.
>>>
>>>>> I know some people worry if the limit is too low and it could result in poor
>>>>> monitoring accuracy.  Therefore we developed [1] monitoring intervals
>>>>> auto-tuning.  From multiple tests on real environment it showed somewhat
>>>>> convincing results, and therefore I nowadays suggest DAMON users to try that if
>>>>> they didn't try.
>>>>>
>>>>> I'm bit concerned if this is over-engineering.  It would be helpful to know if
>>>>> it is, if you could share the more detailed use case.
>>>> Thanks for pointing to intervals auto-tuning - we do use it.  But it
>>>>
>>>> trades sampling frequency against monitoring overhead; it cannot
>>>> change the spatial resolution.  With N=1000 regions on a 2 TiB host,
>>>> a 20 GiB cgroup cannot be resolved no matter how we tune sample_us /
>>>> aggr_us, because the region boundary itself averages cgroup and
>>>>
>>>> non-cgroup pages together.
>>>>
>>>> So raising max_nr_regions and making the per-region overhead cheap
>>>> are complementary to interval auto-tuning, not redundant with it.
>>> Makes sense.  I'm still not sure how it helps for cgroup.  But, if you do want
>>> it and if it helps you, you are of course ok to use it in your way, and I will
>>> help you. :)
>>>
>> [...]
>>>> Sashiko is correct that (u32)(r - l) truncates spans greater than 4 GiB.
>>>>
>>>> This is a pre-existing limitation of damon_rand() itself, which
>>>> passes r - l to get_random_u32_below() (a u32 parameter) and
>>>> truncates the same way.  My patch makes that truncation
>>>> explicit but does not introduce a new bug.
>>> You are 100% correct and I agree.  Thank you for making this clear.  I should
>>> also mentioned and underlined this in my previous reply, but I forgot it.
>>>
>>> So I think this patch is ok to be merged as is (after addressing my nit trivial
>>> comments about coding styles), but we may still want to fix it in future.  So I
>> damon_rand() is now only called by damon_split_regions_of() with
>> the constant range (1, 10).  may by we can rename it to
>> damon_rand_u32() to make the u32 constraint explicit in the API
>> name; that closes out the truncation concern at the legacy helper
>> without needing a separate series.
> Good point.  I'm wondering if we have a reason to keep using damon_rand() at
> all.  I find no such reason.  If you also find no real reason, how about simply
> removing existing damon_rand() and renaming damon_rand_fast() to damon_rand()?
>

Good idea.  v2 will remove the legacy helper, rename
damon_rand_fast() to damon_rand(), and plumb ctx into
damon_split_regions_of() for the new signature.

>>> was wondering if such future fix for this new, shiny and efficient function is
>>> easy.
>>
[...]


Thanks!



