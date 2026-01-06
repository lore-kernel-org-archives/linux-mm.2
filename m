Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A2AC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 07:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF50E6B008A; Tue,  6 Jan 2026 02:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4616B0093; Tue,  6 Jan 2026 02:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC45F6B0095; Tue,  6 Jan 2026 02:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCF796B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:09:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67E478B99A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:09:17 +0000 (UTC)
X-FDA: 84300662754.21.EB345A7
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7771A80003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:09:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SLjjnidY;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767683355; a=rsa-sha256;
	cv=none;
	b=UioQvOWhRgZkVjdKWcfvFY7unkxet4CgOUXBzxS/Ufy95MNnDHcCI7AnT55+n7WAs6eiWj
	k3W2fNCFoHxWacRDGcxB0uqMA/D06Zusxs+o/Rd4y1DV0nRoWBKev19uGioXmEhjE0F1tX
	GZehWqPmRD6khg4kczasz0peBtk/JgI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SLjjnidY;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767683355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyFrXFN6m53klbwE3XorrFPsS5+e/WpEsvDQtjFL8jc=;
	b=VbZhTCmc50tWiaQ4B+PR9LOMrbWRc36rpNG5qLmgqsQvpbD1YCnO08IpP66+UV2+fR7P2d
	tqP1qFnCn4+PNWWYzNwbszHrNflUsPnzsK5E/GVfNaM9QV+DJehnYMJIBtwEVFHyfAFJiB
	xDsrd5HXGn/pubPAKVvDH489KeFoyXM=
Message-ID: <d016b76d-581a-4582-920d-21f64318090a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767683352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dyFrXFN6m53klbwE3XorrFPsS5+e/WpEsvDQtjFL8jc=;
	b=SLjjnidY1VMNj49kUhsnsQ6JX6Smd0ZoabO+uSUu7r8AtpZgXelawl2acD4o71fW+O5kcA
	KgsijQ58TY08ZOku1f4lUZz81Jr4Mu4jRTEREKIt+8R9CpsCisqKjxEZ0krWuqnKgyERxT
	sxn/UJASLhjEHcz873XFe70yKO8ao5s=
Date: Tue, 6 Jan 2026 15:08:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Yosry Ahmed <yosry.ahmed@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
 <prqhodx7wc3cbrlh7tqf632b3gpcciwmn5n22qqv7c7rbtsoy3@lsnd7rtdhfmh>
 <hrxsjzcyj2uvxi5h5edtkoc3br4ljvz7m36nczoctyyoinrz56@27gcuui7wfpw>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <hrxsjzcyj2uvxi5h5edtkoc3br4ljvz7m36nczoctyyoinrz56@27gcuui7wfpw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7771A80003
X-Rspamd-Server: rspam04
X-Stat-Signature: 1f9fexec5phd4ajyehxpafwq6thf6pqf
X-HE-Tag: 1767683355-571751
X-HE-Meta: U2FsdGVkX1+T1U7eXnCqs9TpS+r7SuJWvdQ9MZPvgVndioMaAtqXu7TWQK01IlH0NIakkqdduyQbOwHOkZRIzPI79p2n7Dt3ItCkfSbYPa7ZpZG7cLQqgOuWof5bL8SVd0gYkjoZbnK1Yhj6BsmfYaC4KHnRYeu2DO4OI60/TwAJce9T1u7gy3fC2uGgfoytwFcZCR5fdZFNc2U9UKl/SWX2OrvXB/O6NZHblVA26vQviNwqDQJx++/odcXd7BElC0Soa7MOnTHEP2DH11ig/LG180TUtQJslfNwzgemPN4Gm2KYz0Nb/vEBD3WZ61aUy40xCtCORX3uCo4YVoUFxkDshKZceFh1RNg4Rvw72BU2fc8RLNvJE27/e+dmgr/UjQyl6rU4SxCQQA3E4SniWa/KQPve1NraK9wy+i6DAiBrNQVNugNDfJFygHBbXx4eDbpm2CLtsF8ogyBWc/0ziSljv49uCrADLSYG42AkH7coYIo7RZg/2KltkmO2bE//9X4YbSm+LSpnyObjjOm3kDPF/iFbc/YvXGq1Xz1CIaEbZk9/JtVBlu3F1/pU0JAZFhzQJ2MmIP19TqXZtsFZQXh/WuMWWL7wIT+yq8xZqkgU9MPlui//7qh6VZkjTc29IXz115A97ZLBzXGi2h9KOC9GRkNwBVvi/8BalG7bTuHDsPITO9aqZu91T6AaIOQheVCyKP3NDx7eQhtKjyIhhMCOz4YiHr33e/CwXh1k8Scuy/b2LRMzsE2Mmqnt7u33x/97PgfcgPi9B4dbFYTq8s2FTG8jyP5pvAnmQsT2YRlO3Du65iSVRCQ4uw2UtpcHT4mMavi9lZOwaV+WvnZyeWKFwJ5PyCjeK4fTHeJDe88BbtChQM3Mtw4oXJqoGPoINY2zoHbopDuta3ozklFj3XuyWOYmUSR/YeCJ0M7uQrD/mt54EDoV+R3iC0PdNuuH9hfV9++wEmev1C2rvTD
 ylG9+Nhc
 QomGpvD/E7ytPoYxYV5Pj6mwOzbzwrK09e5ZUfBJuRnkqWRssXiqh/yjNlQ2KeHLfqTYIBKHNl70Bo+j3CbDKdcF90/4KO++BnF2n4RchFzC7E8Zs7qmOoPgieGd2I/URvogGmdj2NptTL3/oTxISlGBMxsP7QRBdp5QJk9UNbdnGE/LFmVFCUtXE6YhdphnGvTp6NE/4/DBTNylHYKB+Uz56Zx3uOJvgAqmIAmNplPlMn78aEubXVg1u2zfYY0Vw1eb8eFDwq9wLXF+yIInG6afrjeMq1doIMAZdYyZER+2DRso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/6/26 12:14 AM, Yosry Ahmed wrote:
> On Mon, Jan 05, 2026 at 11:41:46AM +0100, Michal Koutný wrote:
>> Hi Qi.
>>
>> On Wed, Dec 17, 2025 at 03:27:51PM +0800, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>> @@ -5200,22 +5238,27 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>>>   	unsigned int nr_pages = folio_nr_pages(folio);
>>>   	struct page_counter *counter;
>>>   	struct mem_cgroup *memcg;
>>> +	struct obj_cgroup *objcg;
>>>   
>>>   	if (do_memsw_account())
>>>   		return 0;
>>>   
>>> -	memcg = folio_memcg(folio);
>>> -
>>> -	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
>>> -	if (!memcg)
>>> +	objcg = folio_objcg(folio);
>>> +	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
>>> +	if (!objcg)
>>>   		return 0;
>>>   
>>> +	rcu_read_lock();
>>> +	memcg = obj_cgroup_memcg(objcg);
>>>   	if (!entry.val) {
>>>   		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>>> +		rcu_read_unlock();
>>>   		return 0;
>>>   	}
>>>   
>>>   	memcg = mem_cgroup_id_get_online(memcg);
>>> +	/* memcg is pined by memcg ID. */
>>> +	rcu_read_unlock();
>>>   
>>>   	if (!mem_cgroup_is_root(memcg) &&
>>>   	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>>
>> Later there is:
>> 	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
>>
>> As per the comment memcg remains pinned by the ID which is associated
>> with a swap slot, i.e. theoretically time unbound (shmem).
>> (This was actually brought up by Yosry in stats subthread [1])
>>
>> I think that should be tackled too to eliminate the problem completely.
> 
> FWIW, I am not sure if swap entries is the last cause of pinning memcgs,
> I am pretty sure there will be others that we haven't found yet. This is

Agree.

> why I think we shouldn't assume that the time between offlining and
> releasing a memcg is short or bounded when fixing the stats problem.

If I have not misunderstood your suggestion in the other thread, I plan
to do the following in v3:

1. define a memcgv1-only function:

void memcg1_reparent_state_local(struct mem_cgroup *memcg, struct 
mem_cgroup *parent)
{
	int i;

	synchronize_rcu();

	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
		int idx = memcg1_stats[i];
		unsigned long value = memcg_page_state_local(memcg, idx);

		mod_memcg_page_state_local(parent, idx, value);
	}
}

2. call it after reparent_unlocks():

memcg_reparent_objcgs
--> objcg = __memcg_reparent_objcgs(memcg, parent);
     reparent_unlocks(memcg, parent);
     reparent_state_local(memcg, parent);
     --> memcg1_reparent_state_local()

> 
>>
>> As I look at the code, these memcg IDs (private [2]) could be converted
>> to objcg IDs so that reparenting applies also to folios that are
>> currently swapped out. (Or convert to swap_cgroup_ctrl from the vector
>> of IDs to a vector of objcg pointers, depending on space.)
> 
> I think we can do objcg IDs, but be careful to keep the same behavior as
> today and avoid overexhausting the 16 bit ID space. So we need to also
> drop the ref to the objcg ID when the memcg is offlined and the objcg is
> reparented, such that the objcg ID is deleted unless there are swapped
> out entries.
> 
> I think this can be done on top of this series, not necessarily as part
> of it.

Agree, I prefer to address this issue in a separate patchset.

Thanks,
Qi

> 
>>
>> Thanks,
>> Michal
>>
>> [1] https://lore.kernel.org/r/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn
>> [2] https://lore.kernel.org/r/20251225232116.294540-1-shakeel.butt@linux.dev
> 
> 


