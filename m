Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC41ED68BE3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDEB6B008A; Thu, 18 Dec 2025 01:57:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EC16B008C; Thu, 18 Dec 2025 01:57:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0971E6B0092; Thu, 18 Dec 2025 01:57:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9C276B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:57:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AF285D373
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:57:25 +0000 (UTC)
X-FDA: 84231685650.12.B4C0A63
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F8BD1C000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:57:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TWv4oTjP;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766041044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7LHGOObDxQ6+ffkFn25DV4aolNfjtd27M0DUDjwyfQ=;
	b=xOia0TQQ487F4dRWD9HvX6j8RjVSI0RnFSOIarVnLiUvYi5hGAh4jKbntECcimzrMzqkFN
	rYt+m0fEXgGK5DlfJWphehThCl6Vz9NrB88s2BRE9DPK38UEBK5KGQixXYxJ8zfcNcuknB
	0nj8IPqQKN2M4y4i6Lp/wkBUvrufQ7w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TWv4oTjP;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766041044; a=rsa-sha256;
	cv=none;
	b=a9NsPJTXqMJwRfMzHHOgBOlUIKX9Q+ROGHJrjs2NXGMEC2Mun0OCjZDk/78nZaxabNiS+C
	RYeDuvlSgjNMHMPHpGx6KTDow2fBye871Y1C2hCtIAe8r9Rph5or7F+ZmvrQTCdUMUK9V/
	OBIc4PuD4w8ZeYit45a9tiw50vuM+9Y=
Message-ID: <70b14272-10b8-4dbb-9f49-40ea9f9103bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766041033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O7LHGOObDxQ6+ffkFn25DV4aolNfjtd27M0DUDjwyfQ=;
	b=TWv4oTjPJDFW3GWSWAE2CTFAB2w7bMvVrBZAKAQd0wNkVnhQNYV0ELz5ER2fk9sg1Dh7tm
	qubtcgDe6rvX5iIfmFoMBdKWfK2+Gcfp1DKI4G2yrr3RvSZneSn95MulWswjF3LGRuuzEi
	+LVxv2CRm5qdggtALoWWN/ToKjTP/Zo=
Date: Thu, 18 Dec 2025 14:57:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 19/28] mm: workingset: prevent lruvec release in
 workingset_refault()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1b6ad26b5199b8134de37506b669ad4e3c0b6356.1765956026.git.zhengqi.arch@bytedance.com>
 <aUMvIDRJegSVSicB@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUMvIDRJegSVSicB@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wnz8z3pqno33b7hpjej39jmf8pmdsaqc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F8BD1C000F
X-HE-Tag: 1766041042-713377
X-HE-Meta: U2FsdGVkX18CsaxHfuynLYR7E5LQeocTCfgvma9ubhiBhpwxungqmiO3GGdCZh7DdRSgn7sQpp+InJIY7ZIg0ZaL54o6NneXh7n1Ya57ZPWyuVmZsRKkh3yfdiOft2F2Htso04DW6l3uAtqabKO5rp+Uc783CT1jTPEVIGdA7thYytMfhdG49vGRYDqyaIzvoLAPYMIRo3cIV2WSnBVvOnlsH+reUAMEA4pcRUswWu5VgFSMXqn5S0PB/TO6LXFMwdqoR6dQZ8+Z6ttIMeljNgPWU4XDKGkKOvuXKenIjwSPUVAmQFoF7UJh9Oqecn8Xin8Yf2jBBjwTcbqA4q7xQwceGGyzIitMpFSpq8AhRB2vnuVKl4y2FC8xisV9kYFYXxKa/VPe5fHsDhbiyvAILj65QHAOz2MZPn3PjIuzgSoJ+COzAQVwAvQM47sTAKi/9lMas6RRWpbixK4aAH3+GMuuPKT6HpZZMmrrsirWfzStC2ifmQQNztxmuWaHeUnJT17GKd9fMLWRr4xs3XkddyITwpf+D/mSQAYEiAm/QftrgNj+Tv62R1dZ/IMCwIo/l97XDpm9WnbBGGggO94QjN5X9KC0yAQ6xvfk9lmyyFG8KLWkmQNgG+9z5dLDmO/RZIyqZahcjNfUCK8Fypesz5gXtoh8FV+2r4BY4z3k9Gny8Xui68aJ6UToqFPUQqriBLqJQt8pcQXFGbe5X13kOlnM+240wI7hok5Tq6KZwkdLUu9HXzLdTb+xhIwKae0wdhpbyi5JIyvr0r36bdAmgAWOzWy5XmIxAci+ZKHPYIsRNA68oKvSAVM+xrZefu70C3mxkxJjS2f1HfJOIeG/aNEDcE0hY7scYrE2LodzL/vBpavheKaC4EV4IF/1wtrEnRim8F2elDdWAZ+5nPBgIlmVjkaq17m6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 6:30 AM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:43PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. So an lruvec returned by folio_lruvec() could be
>> released without the rcu read lock or a reference to its memory
>> cgroup.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the lruvec in workingset_refault().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>   mm/workingset.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/workingset.c b/mm/workingset.c
>> index 445fc634196d8..427ca1a5625e8 100644
>> --- a/mm/workingset.c
>> +++ b/mm/workingset.c
>> @@ -560,11 +560,12 @@ void workingset_refault(struct folio *folio, void *shadow)
>>   	 * locked to guarantee folio_memcg() stability throughout.
>>   	 */
>>   	nr = folio_nr_pages(folio);
>> +	rcu_read_lock();
>>   	lruvec = folio_lruvec(folio);
>>   	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
>>   
>>   	if (!workingset_test_recent(shadow, file, &workingset, true))
> 
> This might sleep. You have to get a reference here and unlock RCU.

Indeed, this may sleep in css_rstat_flush().

Will do the following:

get_mem_cgroup_from_folio(folio);
lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));

/* xxx */

mem_cgroup_put(memcg);




