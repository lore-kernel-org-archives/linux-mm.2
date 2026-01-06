Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA63CE9D7D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD2D6B0095; Tue,  6 Jan 2026 11:52:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5A56B0096; Tue,  6 Jan 2026 11:52:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D686B0098; Tue,  6 Jan 2026 11:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855B06B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD92C8BFA9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:52:08 +0000 (UTC)
X-FDA: 84302131536.18.79E9907
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id 188E8120008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:52:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qSC/XXQz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767718327; a=rsa-sha256;
	cv=none;
	b=t0WCnHs33LGJNJN1yiIZq5W9GQvjgzQfKQNDFcAXm4mjK6g8xJGCV7PO10nsbHA7fdNl0p
	Asa+nWP/KuqZz22heOEG/ECiriXp2/iuAF6GOvXDWwuP78oEZ2tNvl2yJ9ddA8jBHl89a6
	NYxyMdqzXcQ6uymnctbymc9Ccli3E2M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qSC/XXQz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767718327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UD2crwKJYyiE4FPL7vLzqYvJnd70fea19UnIDBPEH4=;
	b=OSjCy32FcQT80yycZmEkZ/F5FIN1G4RjUrv1v0h0oPCb8Gdq4SinFjMIViym+fEBwOK2v2
	lylDOkBPnIxTbVDTUhKFOHRXP4tePzrBF01wU0/qUy4rEO+EpQ3fFPyFXRcccfNPQJ7LdK
	vTBjMyqFFpkXh4Pd09Nco1At/Z4Ah8I=
Date: Tue, 6 Jan 2026 16:51:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767718325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6UD2crwKJYyiE4FPL7vLzqYvJnd70fea19UnIDBPEH4=;
	b=qSC/XXQzEPYB8mYYbl5kz8Iup6+I0c+PuosEUAn+P0l9OnYITWEyFnsWS3YHzC7RxSIjKX
	/ECPfpMCnkTAj2RVpOrTblRbAci0VykKCsjWwTcG7ZfT9X5zQX7BnNVm/9gc0O2TW7HiWI
	dUS79Urxyls4YO/zMZdZWzyz/HWMOAI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, hannes@cmpxchg.org, 
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <rga5pjrjnrzzminflnwfd2lckedg4pdzaypwsa4ad2ovyjkavt@kegiy7cthefu>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
 <prqhodx7wc3cbrlh7tqf632b3gpcciwmn5n22qqv7c7rbtsoy3@lsnd7rtdhfmh>
 <hrxsjzcyj2uvxi5h5edtkoc3br4ljvz7m36nczoctyyoinrz56@27gcuui7wfpw>
 <d016b76d-581a-4582-920d-21f64318090a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d016b76d-581a-4582-920d-21f64318090a@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 188E8120008
X-Stat-Signature: 1eeuofrksrs9eystjzqdpfdips4ydo5w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767718326-113043
X-HE-Meta: U2FsdGVkX18nSP0aDqh1BSrrZgDb0JzpJWaUnWYgnMplXqPP3CSx1kWK4zb4UD2J5kXwFfU6O3vMwn7zPXU9JLyfbHGDhr7vQVIZJ5CBfuBm9NKvGAPZc27KwZWVrtZL7yw93xfpcL2h/xA6FxyoxMBMG+0AdprTj/Lcko6KyXgvFQpEAc2jfg8QAC116ydA6a2hm/uK2alaKD0NgbmpqfrjDOWczAllblXaO2GzQleWfqgtNgbBQce3PAWE3ypEHv5+n6TTCPlgiEaUTmee6NfePcMaJtiGrE2NLzKLkwCNbSeUZtqji7q2yVzvPFuYS+l4bJTrvyRle3MJ4vn9gLlofM5OE9ciNjbga8l11eID6DopVbcXH8Phl6O5Ij7ClB/rvuob2khMfUOAKIAlXEWa+eLqWktO/vrI3qeHsxQ3EzxKWMB0foABEW+060RUDfUa5JIueKXkzybv2GZW2psNWsKoAK1I40L1ZcQfvmzXz0dHRx5UDZGi5l4rvBxYaZVEL9O/UoU4fMfr52Ciq09gK2mCUEMys2M9iDyRaKSCCr4gK+LDe8AyMMurHtMqvGPVpy9zmeqEBN1zUsuwX6bfdUPpMm0P63WC36Ei3Tp4ttvWFq+WauVGzR72RuRlTWdedXJFONME7SXViayF1EWil/MeB9AfeA+HOrD5u5nx9BinwfQwct7xcaLWHmrCGr3QI6ZqnnvsV7cLwXoO87PO5UulORDpNbYrtyQY3lgXCc4HmparmF7Ff+GjeRtEQC2l7WB4mWh/kESqEXNMPJt83bIKQwNWeYdWRpUpxXcsrno0OcMtAzys1fduGTB5Ap90rWFdH6YThmE8OQ1GWsLebOdErEhxsUx4rkZhUMNf3j/SNe5ISA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 03:08:57PM +0800, Qi Zheng wrote:
> 
> 
> On 1/6/26 12:14 AM, Yosry Ahmed wrote:
> > On Mon, Jan 05, 2026 at 11:41:46AM +0100, Michal Koutný wrote:
> > > Hi Qi.
> > > 
> > > On Wed, Dec 17, 2025 at 03:27:51PM +0800, Qi Zheng <qi.zheng@linux.dev> wrote:
> > > 
> > > > @@ -5200,22 +5238,27 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> > > >   	unsigned int nr_pages = folio_nr_pages(folio);
> > > >   	struct page_counter *counter;
> > > >   	struct mem_cgroup *memcg;
> > > > +	struct obj_cgroup *objcg;
> > > >   	if (do_memsw_account())
> > > >   		return 0;
> > > > -	memcg = folio_memcg(folio);
> > > > -
> > > > -	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
> > > > -	if (!memcg)
> > > > +	objcg = folio_objcg(folio);
> > > > +	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
> > > > +	if (!objcg)
> > > >   		return 0;
> > > > +	rcu_read_lock();
> > > > +	memcg = obj_cgroup_memcg(objcg);
> > > >   	if (!entry.val) {
> > > >   		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> > > > +		rcu_read_unlock();
> > > >   		return 0;
> > > >   	}
> > > >   	memcg = mem_cgroup_id_get_online(memcg);
> > > > +	/* memcg is pined by memcg ID. */
> > > > +	rcu_read_unlock();
> > > >   	if (!mem_cgroup_is_root(memcg) &&
> > > >   	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> > > 
> > > Later there is:
> > > 	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
> > > 
> > > As per the comment memcg remains pinned by the ID which is associated
> > > with a swap slot, i.e. theoretically time unbound (shmem).
> > > (This was actually brought up by Yosry in stats subthread [1])
> > > 
> > > I think that should be tackled too to eliminate the problem completely.
> > 
> > FWIW, I am not sure if swap entries is the last cause of pinning memcgs,
> > I am pretty sure there will be others that we haven't found yet. This is
> 
> Agree.
> 
> > why I think we shouldn't assume that the time between offlining and
> > releasing a memcg is short or bounded when fixing the stats problem.
> 
> If I have not misunderstood your suggestion in the other thread, I plan
> to do the following in v3:
> 
> 1. define a memcgv1-only function:
> 
> void memcg1_reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup
> *parent)
> {
> 	int i;
> 
> 	synchronize_rcu();
> 
> 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
> 		int idx = memcg1_stats[i];
> 		unsigned long value = memcg_page_state_local(memcg, idx);
> 
> 		mod_memcg_page_state_local(parent, idx, value);
> 	}
> }
> 
> 2. call it after reparent_unlocks():
> 
> memcg_reparent_objcgs
> --> objcg = __memcg_reparent_objcgs(memcg, parent);
>     reparent_unlocks(memcg, parent);
>     reparent_state_local(memcg, parent);
>     --> memcg1_reparent_state_local()

Something like that, yeah. I think we can avoid introducing
mod_memcg_page_state_local() if we just use mod_memcg_state() to
subtract the stat from the child then add it to the parent.

We should probably also flush the stats before reading them to
aggregate all per-CPU counters.

I think we also need to ensure that all stat updates happen within the
same RCU read section where we read the memcg pointer from the page,
ideally with safeguards to prevent misuse.

> 
> > 
> > > 
> > > As I look at the code, these memcg IDs (private [2]) could be converted
> > > to objcg IDs so that reparenting applies also to folios that are
> > > currently swapped out. (Or convert to swap_cgroup_ctrl from the vector
> > > of IDs to a vector of objcg pointers, depending on space.)
> > 
> > I think we can do objcg IDs, but be careful to keep the same behavior as
> > today and avoid overexhausting the 16 bit ID space. So we need to also
> > drop the ref to the objcg ID when the memcg is offlined and the objcg is
> > reparented, such that the objcg ID is deleted unless there are swapped
> > out entries.
> > 
> > I think this can be done on top of this series, not necessarily as part
> > of it.
> 
> Agree, I prefer to address this issue in a separate patchset.
> 
> Thanks,
> Qi
> 
> > 
> > > 
> > > Thanks,
> > > Michal
> > > 
> > > [1] https://lore.kernel.org/r/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn
> > > [2] https://lore.kernel.org/r/20251225232116.294540-1-shakeel.butt@linux.dev
> > 
> > 
> 

