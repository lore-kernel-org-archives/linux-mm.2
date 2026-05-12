Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100DECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506066B0088; Tue, 12 May 2026 07:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7046B008A; Tue, 12 May 2026 07:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383B16B008C; Tue, 12 May 2026 07:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 245336B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:02:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ED6140468
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:01:59 +0000 (UTC)
X-FDA: 84758477958.27.684984E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9C7640007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:01:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mI5bbEqn;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778583717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krsyFSghoZ69xkuY9FLSJ/dUYecWNfv4IVL2RNvEKwg=;
	b=uNbY98aQ8vXF3kDZTpU44KwPYOsr9vUJEzOjMyNhbke/Rmd3LHQJxSHKpiYpoJe+u3713n
	JPPEwkfr2BSKbAOJHtNiM5Z17QLXBSs2d9YRYKJlCO2iEyFbfNgdnqho8jGgEHLzCzhU79
	zRmMJTeawwUzK9KjCLiaxl+89lSr9XM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mI5bbEqn;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778583717; a=rsa-sha256;
	cv=none;
	b=dZbJwhvv5fbtJUvytmO/NbVTxXCXClcvCIcixXvZMKE/rqhu9FTS+96rLWb785dPfjrlje
	t2EBJKPLhUB9uLaZxKIoxicMOLOPkM1NUQ0N2mkhFKG0KmJ3V51KuOYuobNGBgRPiIg0h2
	E+r4sr08JF0olsyWK5t2wY90iUzv4DQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57A0A60055;
	Tue, 12 May 2026 11:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7703C2BCB0;
	Tue, 12 May 2026 11:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778583717;
	bh=1JWxJVnMkU03cSQqThx3O2p1o1XcXgks2U+kqputk6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mI5bbEqnT/Z0QauxHzqSs9elVp6ozT1PvCOA5E3gfT/4PSuXrQt9OaBJwiUgUwVlZ
	 qte3Aksd0InQHcSKUHiAz4rNX53pfin+QutaLFfojlNoY7YLEZAMWnBN9Dv9myt56Y
	 EH/B5QYTGN5CXmqSpXSzBOz8ZKHF6FkWKEVi8fIiHNPM0Oxs9de3H2P8VIeyIa8Ie/
	 oigRH8Owj1wWqDjuEtvDFNJLqFmSx1GTmrYoKQzzQ6Z3Gcwnd3sKpHFqJJjceGJc0m
	 8U1/9JxgbbCtIne+1K/BTZmtzGorPlLsohybn8d5cDhXFaoakjRKs7RgigtI3H4RR1
	 zEnl6b8XWWYvw==
Message-ID: <241fb6c4-c29a-4b61-9c4e-0b8d84715a74@kernel.org>
Date: Tue, 12 May 2026 13:01:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-2-dev.jain@arm.com>
 <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
 <06029485-9e85-4d2d-a324-abba918eecf3@arm.com>
 <771a8ee7-0a7c-4d70-9e7a-cc08abebd4aa@kernel.org>
 <2a749617-d70a-4931-9aa3-c9b680783b82@arm.com>
 <575f7210-b325-489e-9937-afccf29753a3@kernel.org>
 <3a25e7fd-84a7-49a6-92a3-96492fe5d2cc@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3a25e7fd-84a7-49a6-92a3-96492fe5d2cc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tepujnt6gorewg5u1st543ua5dp1ssos
X-Rspamd-Queue-Id: E9C7640007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778583717-876255
X-HE-Meta: U2FsdGVkX18LvWDsk8gdkqnElsoNri8TaS/4TiOKbnoWq+Lpmn4//jf7OA+5U+G7H1NQTWA/zbcYSy08tEHVvw7Y63BSzbbBRhEX6hSbSqmHC2vcn4TgklM2inO9ma/UGdX49JgsvIARllOIWWlpT+KJ70pAbnXZ6pFerZBAJhX0cDNM3asmymUu3+Lenr17qoVEmLgGPoYoYYIWxZaJja91YaSsaitGbo6c62aY1A3dJyTZx52LjL+upPeaPrFtuaoGSxUnS66L96S1/EBFnAoa0e2RjHsMd+v5d5SQJkLZthLVytmucbvoTQCv0HMYknmzpC8AVnMUej7sJjjISodRr1qFyVzZfCDXcp6kV2ueIKFp9VJbrZcYlSkGZGWSJmIzAfRFyuziEymR9LiebRFKtsGzF6xifNTjiEAemcd/2pD1xdjPJ5TXxdvjYyfYBULjGdlXJglZvHJEcHui69sde8k9Vf2qBEw2pn0QECkvQBXSdyEgzpeKbhdQXkZDmOSJRtYu+ZfZD/02+a1pIXzYIVVaXFZ25OyL4InW4xbzQNoWcVWWOPatOgzNDvsLsKq8zVkdT38Df2VxOldY2CfxBksqtijBDRGNNmOf2t36OfCZCmYZ1b8rBVpHjakSG6Vmq5yi1S5h3/4ZKs7X5YWg00/KS+sgHMhctlIQivj6lvQ4ee0FWWadHmdYwBaWHSe+mUWLcLF/RmbjkgSD47YEgeCyuwXJ1Loqnxyo21S1LQ+giYtqQ45QZ+fLzFkBe3u4zs3mZX3uULu8AuxwaYqP+aGUJudwFC4N3LWavZdX4AvW4pCXakO51JFhYpXLvXFlTG5+vEab0aXjc79vi2FC7HsEcI28F7HWKXtnarsfWmSWDso/ZfZKUj0+uAX64KI4Q9YTkpxnXIg66XL8amnCV/hDqgmMiUkbaihLSw9uFqEuzKIcOEtqezKUHY2gsExNIBnmqlZAQUlomcR
 wo3XzmEl
 WuUn8V6g1vnu97C0/z5Qik6DA8ab4vifbVQ9q2mwAqW95AK7AI0nJHvrid0rcyThLO9kcYKxoJZ8HtLFhkn2LP68tqDoXRHiCXusPHCfkgm/4et1dbBpZ7jKDZz5hr4U33s85Yd7wyre5agO8zpzQ6wqIqk7gFJ8oBrlZGlXCHW/tjM4M0iHGF6BKG34U5zsnNQ6tOe87k09vkoRuzJV29YZMXcJ92qMrE/MCXDwoVgs+g6gNBDQipPwXNDz1S1AhhVfJEiXpcPJn8WPT5RBQiGk3ndKQK+tTNFbfKmxSbpdCg+gz6umHPbSbsMGxw1mrDeNoFGPkMCjwANI3nlyqmnBeASgGYHU+ghT0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 12:49, Dev Jain wrote:
> 
> 
> On 12/05/26 1:47 pm, David Hildenbrand (Arm) wrote:
>> On 5/12/26 10:14, Dev Jain wrote:
>>>
>>>
>>>
>>> You are correct.
>>>
>>> I did some changes in hmm-tests.c, to mmap and fault in 64K folios,
>>> MADV_FREE them, then trigger make_device_exclusive() via hmm_dmirror_cmd()
>>> on the last 4K part of the mapping, then trigger reclaim. I get:
>>>
>>>
>>> [   96.896674] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800030000 0x800040000)
>>> [   96.897857] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800020000 0x800030000)
>>> [   96.898181] HMM test module loaded. This is only for testing HMM.
>>> [   97.136132] page: refcount:17 mapcount:1 mapping:0000000000000000 index:0xfffff7bf0 pfn:0xc1a00
>>> [   97.136160] head: order:4 mapcount:16 entire_mapcount:0 nr_pages_mapped:16 pincount:0
>>> [   97.136211] memcg:ffff00019d433040
>>> [   97.136219] anon flags: 0x1ffff000000085d(locked|referenced|uptodate|dirty|owner_2|head|node=0|zone=0|lastcpupid=0x1ffff|kasantag=0x0)
>>> [   97.136264] raw: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
>>> [   97.136391] raw: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
>>> [   97.136587] head: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
>>> [   97.136828] head: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
>>> [   97.137083] head: 01ffff0000000a04 fffffdffc2068001 000000100000000f 00000000ffffffff
>>> [   97.137090] head: ffffffff0000000f 0000000000000021 0000000000000000 0000000000000010
>>> [   97.137096] page dumped because: VM_WARN_ON_FOLIO(!((!!(((pte).pte) & (((pteval_t)(1)) << 0))) || ((((pte).pte) & ((((pteval_t)(1)) << 0) |
>>> ((((pteval_t)(1)) << 11)))) == ((((pteval_t)(1)) << 11)))))
>>> [   97.137122] ------------[ cut here ]------------
>>> [   97.137125] WARNING: mm/internal.h:346 at folio_pte_batch+0x54/0x360, CPU#4: hmm-tests/2283
>>> [   97.137206] Modules linked in: test_hmm
>>> [   97.137234] CPU: 4 UID: 0 PID: 2283 Comm: hmm-tests Not tainted 7.1.0-rc1+ #17 PREEMPT
>>> [   97.137237] Hardware name: linux,dummy-virt (DT)
>>> [   97.137238] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>>> [   97.137247] pc : folio_pte_batch+0x54/0x360
>>> [   97.137253] lr : folio_pte_batch+0x54/0x360
>>> [   97.137254] sp : ffff80008e7a3490
>>> [   97.137263] x29: ffff80008e7a3490 x28: 0000000000000001 x27: 0000fffff7dff000
>>> [   97.137266] x26: ffff0000451ceff0 x25: ffff000040fcaf00 x24: 00000000c1a0f780
>>> [   97.137269] x23: 0000000000001000 x22: fffffdffc2068000 x21: fffffdffc2068000
>>> [   97.137272] x20: ffff0000451ceff8 x19: 0000000000000001 x18: 0000000000000010
>>> [   97.137274] x17: 3030303030303020 x16: 3030303030303030 x15: 5f6c617665747028
>>> [   97.137276] x14: 282828207c202930 x13: 29312829745f6c61 x12: 7665747028282828
>>> [   97.137277] x11: 2929292929313120 x10: ffff8000838feb80 x9 : ffff800080287cb8
>>> [   97.137280] x8 : 3fffffffffffefff x7 : ffff8000838feb80 x6 : 0000000000000000
>>> [   97.137281] x5 : ffff0002fe74a0c8 x4 : 0000000000000000 x3 : 0000000000000000
>>> [   97.137282] x2 : 0000000000000000 x1 : ffff00014e120000 x0 : 00000000000000bb
>>> [   97.137284] Call trace:
>>> [   97.137285]  folio_pte_batch+0x54/0x360 (P)
>>> [   97.137288]  folio_referenced_one+0x398/0x638
>>> [   97.137295]  rmap_walk_anon+0x100/0x250
>>> [   97.137296]  folio_referenced+0x17c/0x248
>>> [   97.137297]  shrink_folio_list+0xf38/0x1968
>>> [   97.137307]  shrink_lruvec+0x610/0xae8
>>> [   97.137311]  shrink_node+0x218/0x888
>>> [   97.137314]  __node_reclaim.constprop.0+0x98/0x328
>>> [   97.137318]  user_proactive_reclaim+0x2b0/0x350
>>> [   97.137320]  reclaim_store+0x3c/0x60
>>> [   97.137321]  dev_attr_store+0x20/0x40
>>> [   97.137338]  sysfs_kf_write+0x84/0xa8
>>> [   97.137351]  kernfs_fop_write_iter+0x130/0x1c8
>>> [   97.137352]  vfs_write+0x2c0/0x370
>>> [   97.137360]  ksys_write+0x74/0x118
>>> [   97.137362]  __arm64_sys_write+0x24/0x38
>>> [   97.137363]  invoke_syscall+0x5c/0x120
>>> [   97.137374]  el0_svc_common.constprop.0+0x48/0xf8
>>> [   97.137376]  do_el0_svc+0x28/0x40
>>> [   97.137377]  el0_svc+0x38/0x168
>>> [   97.137396]  el0t_64_sync_handler+0xa0/0xe8
>>> [   97.137398]  el0t_64_sync+0x1a4/0x1a8
>>> [   97.137400] ---[ end trace 0000000000000000 ]---
>>>
>>> the warning happens in folio_referenced_one -> folio_pte_batch -> !pte_present().
>>> Not sure why it happens in folio_referenced_one instead of try_to_unmap_one.
>>>
>>> I set nr_pages = 1 at the start of the pvmw walk in try_to_unmap_one and this
>>> goes away.
>>>
>>> Will send this as a separate fix patch.
>>
>> Awesome, thanks! (CC stable)
> 
> Okay I think there is another bug. In folio_referenced_one,
> 
> 	if (folio_test_large(folio)) {
> 		unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
> 		unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> 		pte_t pteval = ptep_get(pvmw.pte);
> 
> 		nr = folio_pte_batch(folio, pvmw.pte,
> 				     pteval, max_nr);
> 	}
> 
> There is no pte_present(pteval) check here. We will encounter a non-present
> entry in folio_pte_batch(), giving the trace above.

clear_flush_young_ptes_notify() should also only get called for present PTEs.

See damon_ptep_mkold(), where we trigger mmu notifiers separately to handle
exactly that.

I recall that I looked at that code in context of

	https://lore.kernel.org/all/20250210193801.781278-16-david@redhat.com/T/#mf98677cb5a9419a5d695b2ed5427fdd75ed08dcb

And assumed that it would not be required in folio_referenced_one().

If only I could remember why I thought it would be ok ...

-- 
Cheers,

David

