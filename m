Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101F8CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C14C8E0006; Thu, 11 Sep 2025 23:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3720D8E0001; Thu, 11 Sep 2025 23:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239A58E0006; Thu, 11 Sep 2025 23:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12AF18E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:29:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA59411A9C0
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:38 +0000 (UTC)
X-FDA: 83879168436.01.6152FA7
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3AE1180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:29:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yotov4GabgTObDdA1/xDUlmGeNcmyalJKQiFvHgqY0=;
	b=jElja8IEnEIJwwND1XKeG4jEMQ8c/2T0VWhwbDaYqVWolYnRGqVoKobCJR5ZoS5Mp96GDn
	0UD1z+j3EHvKmHYbD603aC5pG8xkIqDid3bh7Kh5cx3IkEnbkq+DxvWWA0YHsnrsbuUE2p
	ESOqFcfVlsNQ4DCyMpvMfmhBt6XM/j4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647777; a=rsa-sha256;
	cv=none;
	b=TtR40TnqRp7IaGYqT9aoZdqJ7umtvLLA5n0DgkpGJH+DxXJlwdVv9AH96ODm9OXaNDhiWl
	RxN/FWbcuwNd0HQpw2djRM3w+jDEUWpRcCIH6F41lUmxhEMhJYpJcYtIALNqliCxlwYk0w
	8h+eN/L0sS3WxtZFKzxc9AFfxTnxS1I=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cNKZr466bz2VRnP;
	Fri, 12 Sep 2025 11:26:12 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B60681400DC;
	Fri, 12 Sep 2025 11:29:30 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 11:29:30 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 11:29:29 +0800
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Harry Yoo <harry.yoo@oracle.com>, Lokesh Gidra <lokeshgidra@google.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<kaleshsingh@google.com>, <ngeoffray@google.com>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu
	<peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song
	<baohua@kernel.org>, SeongJae Park <sj@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <aMFOh1NxaIP0GtGE@hyeyoo>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6b6b507b-9e44-762d-197b-ed41acb8b045@huawei.com>
Date: Fri, 12 Sep 2025 11:29:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aMFOh1NxaIP0GtGE@hyeyoo>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D3AE1180003
X-Stat-Signature: tehrdxy4jakui8swy9igtaay93d8mwfa
X-HE-Tag: 1757647775-966943
X-HE-Meta: U2FsdGVkX19n9B7fzAodvLWIRYPMSNLA65X0HQ1/sqAUo7kMVbth9iLdd0uhQTdfNQycPqUAfu/Z08ScA5yyHJg8bE9aGkuI5mPkCjKqiyXMFD8lBpzEzBm5i263MBxwyxYJdShpYGXaCAzHP4MGeNunE2VDLvLk+VgkL1Mp+sq4+MPGTA9qLusEpx4JEacjUoGYK1lDk9d8vGax3e3WH/PtWOBlI3KkIG0/mv16CHZFQu5BNboZCMUn5c76J3JlWy7wnMfjq2Uv5/75mQOX5d23knlsUAXOmjQcL8lFjl8E1db9Lr1qvybvrkRZ1IJLfD3UAs4+aaxmb550tYWdhRCOhrcquyUkg7rxBg3ESuu0aw9JBgcVPK3ZVoDQ+QKP6URxxQdIMwlu9GkycYkKarsCeVa3uQNwPIMLy9gzQr5QqaliAQDBEMkgJ/LNgHiEP55aZCNDVj+9iIIA7kVER3v8YYoTbSfCHS4xIHD8cgS1KMkYHBKmdjfWP8OjMxzlyqFWCJQ9nLFDHmOrc1OMWcQKOdmenc4HHquDytj4uWC3C7+XwCRrXod+Q7nBQ2bPpddRm5St+TDCpM8Ozr/w0hyiB1neaPhBui5YMTQ8/TI6J4TqxJ6LSntlBEPH13kfRV3HwKbgnrNeVVHcDnnScwYt02kM/MfaV9Bwj5CcVHkHP9sme+EG5ybvzs2ZHO9dSWB8Lc1zag/EwJVgqs6dGZkaZXGyqKR54n09iZBZhpnmSk5rhH69b2hHT1pMGMt4PARmwbH/EvH0UHs1bwgm4ORv+vRPAauOJ7YGD83ryFqx8Rm3eGfcvGlaYw4FIxchO4TPcwPdUEtz5gMb5j9ObQob368DhtIrS52D9huGGZWsz6Ft6NCd6Q+jw3ou4iv3szqzDh6FfYqT7Arvx9Uex/oAXVE7fimbK8AHIXokU6xVTPhtrMAzm9KznJTgBW1N76T8ghqdkWoiZVWdPko
 ZvwcceQ/
 uJDsErD/DOoYzcA6Wm2y/JMjaOpxNNIUUtTJ+KC0MxgH7PIA1muSw9ZCp4FL/k9da/gwwe2p0jasbR0B7jucOAqRsRg2M7IMIR44JbBKCyWWtI59AsU2glbUECiuBGQu+kU/8iu+oPylNXs2/MVKJis/CP4mY1JkTjeT0+qNO+xuxcs2+9Q8nQEVXlnAOmgEjw61AKtldEy4L7WzbX1MZdTtZR3jUXWBvR91zEWXpqdXXIni3NbAc9VxMKvZyWBdCVkWzDIs1pC4ZL+1Pg7AbZCUF08fFOnP4KTccLE8yENcWqfNA/to1sSitEC1bDRH1pKZ3uzun2zrVyOh+J6l2G3K3vPClGT7QRXg3isQNJGn1FYZDlM4+ct5OLZCWO8ZkpUCx4b8pl0Va4CVBQKwFN9w54wee09eb7SMG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/10 18:10, Harry Yoo wrote:
> On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
>> Prior discussion about this can be found at [1].
>>
>> rmap_walk() requires all folios, except non-KSM anon, to be locked. This
>> implies that when threads update folio->mapping to an anon_vma with
>> different root (currently only done by UFFDIO MOVE), they have to
>> serialize against rmap_walk() with write-lock on the anon_vma, hurting
>> scalability. Furthermore, this necessitates rechecking anon_vma when
>> pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
>>
>> This can be simplified quite a bit by ensuring that rmap_walk() is
>> always called on locked folios. Among the few callers of rmap_walk() on
>> unlocked anon folios, shrink_active_list()->folio_referenced() is the
>> only performance critical one.
>>
>> shrink_active_list() doesn't act differently depending on what
>> folio_referenced() returns for an anon folio. So returning 1 when it
>> is contended, like in case of other folio types, wouldn't have any
>> negative impact.
>>
>> Furthermore, as David pointed out in the previous discussion [2], this
>> could potentially only affect R/O pages after fork as PG_anon_exclusive
>> is not set. But, such folios are already isolated (prior to calling
>> folio_referenced()) by grabbing a reference and clearing LRU, so
>> do_wp_page()->wp_can_reuse_anon_folio() would not reuse such folios
>> anyways.
>>
>> [1] https://lore.kernel.org/all/CA*EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5*4aDx5jh2DvY6UHg@mail.gmail.com
>> [2] https://lore.kernel.org/all/dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com
>>
>> CC: David Hildenbrand <david@redhat.com>
>> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> CC: Harry Yoo <harry.yoo@oracle.com>
>> CC: Peter Xu <peterx@redhat.com>
>> CC: Suren Baghdasaryan <surenb@google.com>
>> CC: Barry Song <baohua@kernel.org>
>> CC: SeongJae Park <sj@kernel.org>
>> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
>> ---
>>  mm/damon/ops-common.c | 16 ++++------------
>>  mm/page_idle.c        |  8 ++------
>>  mm/rmap.c             | 40 ++++++++++------------------------------
>>  3 files changed, 16 insertions(+), 48 deletions(-)
>>
>> @@ -557,17 +554,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>>  	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
>>  	root_anon_vma = READ_ONCE(anon_vma->root);
>>  	if (down_read_trylock(&root_anon_vma->rwsem)) {
>> -		/*
>> -		 * folio_move_anon_rmap() might have changed the anon_vma as we
>> -		 * might not hold the folio lock here.
>> -		 */
>> -		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
>> -			     anon_mapping)) {
>> -			up_read(&root_anon_vma->rwsem);
>> -			rcu_read_unlock();
>> -			goto retry;
>> -		}
>> -
> 
> folio_lock_anon_vma_read() can be called without folio lock in a path:
> memory_failure() -> kill_procs_now() -> collect_procs() ->
> collect_procs_anon().
> 
> Not sure why collect_procs_{anon,ksm,file,fsdax} do not use rmap_walk()
> functionality :/

Because we need to find all processes having the page mapped and kill them.
But there's no convenient way to get back to mapped processes from the VMAs.
So a brute-force search over all running processes is used here.

> 
> Should we take folio lock before calling kill_procs_now() in
> memory_failure()?

I agree with Lokesh that we should put kill_procs_now() inside folio lock's critical section.

Thanks.
.

