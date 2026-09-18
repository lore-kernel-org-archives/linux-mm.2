Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94333C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69186B008C; Fri, 18 Sep 2026 08:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41356B0098; Fri, 18 Sep 2026 08:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955EC6B0099; Fri, 18 Sep 2026 08:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 601D76B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:58:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33C0B40696
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:58:51 +0000 (UTC)
X-FDA: 85226887662.04.1B3F785
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A7E940004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:58:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoaTwcqT;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789736329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXNzm2EBtVrG5YWANXIx1ens6jQokApRm++6DNIyLho=;
	b=7OZ+V1xdX2IJSu4+We5Cg9ZFKssRpzNlHrQY6xSHsnWLoOY/rUysH81QtyEpYdcATnt4wc
	K9VvsznHMXgCs6bd70MCs+e/AN3YtuOjvc+CDeu7O0QQ+hdYy2G3FLAaAwD3mTF1FgELLP
	0Mep8h1IhCGI7pd/XncwtFqU339fO2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789736329;
	b=NIcUo1uNmI+3aDfbwisbI3vPVUxUp+7kxFSAcn/TpQXF3eRf8inAhgm8vaHp3y4FCqRBrt
	BhZfOfErv5OWKiPC9K7dg0bgyT3RUt5wNO8UuoxdBaRdtPyIcrKJMsL3puc7Htf+M7tEdS
	QKZO53dCyjGAfS0kVzEvZ5tFBnjHKLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoaTwcqT;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0871360A55;
	Fri, 18 Sep 2026 12:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D591F00898;
	Fri, 18 Sep 2026 12:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789736328;
	bh=MXNzm2EBtVrG5YWANXIx1ens6jQokApRm++6DNIyLho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XoaTwcqT1v0uZ8DLx8mV+oKIzWxyzzPbESClbMZb+aw/KPnSEpJ31OUP/ozP2WJcb
	 zy7hjqz+floTcOOtyMGBZXw8dB8kjN4u4qsdWyGXiSbPBjlGKRmcJWvIyjOBOodau+
	 CnB/Pxxu5IQ4EiCZma5H/vbZW72d8E0c+NwzdYmCOzi8jZ1GO0WXBgdgEay2C9WQbN
	 ODjpt0llCNaevDSr7yaHa1/slFBNMrNf9PIW87u63O7rzDTnlTqJsmn4RSHKoDhcpB
	 zB1BkiIiJtidvLSRa1D69aXsgD/Uz2tsd3aXV1t8llB8RrXXzjZjmqbHZekC4aHQEC
	 EkAk58QZjwjAw==
Message-ID: <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
Date: Fri, 18 Sep 2026 14:58:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
 hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911001826.2109390-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wks8hh41hdtjmbnce4b43a3d6hgzw5a4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A7E940004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789736329-908083
X-HE-Meta: U2FsdGVkX18CE9rCl+x18SeyAmXlwGAqtq1UiSVhhrK8SHNnM6QHksaOnctiuHZxXjcNylUkeyyzPvgfYhVvVsIBErbF+qE5iIymleuqw/AkWFLKFZOIIeq+GP9vqvN87atN5scqNOZ3kHbmoCEvuxcGAjLiERE1RZu6EUgBZdhroDRGGxIxlTElwUk8x3mhtVA9HsXHSC/oB4xLgrmacfyJwjCGkKrDlmlfUgZgldcMmHv1/Dc9rU7KlYgTuqbai9KHaD5FatyelC7MVJPpCSaGTUboy9wy4R4gIne4kY05BU00Fe2gAoRvlehhNXKewzBys0LgtaF81LpOIyKxGt3CkMdaT3QcH7eiREnp2hN/prR7oOV67efkW7O3Q3MV+qI17oJOXaezEGcgTe5a82CcyRhgWj6GzjArx3lleaFk6uQCbYqKo/O8m/pQEHgkZcBaSN0z7p0ao3pTXmqSCbwaZMgylDwga99gwnonVUsjlhMnYQX8AUbE4r/Bt6Y5D5vHTDE10f4LEy1H7wyXlgH+9jv7o07KU4ktngro5Lz8A3/ChYjXrdsKBuQHsgp8nEKZvoRx/bycgAwGTVJIKg5ctXiMBmWp5g+ucrA4J/UTn79bH1TfYX1Q9RN9OqOhTDMgNKah80/KOhqMkNEZ8u++4CFoRy2Wx2tbqvxTp7KGwIwEh9+8n9i8GUaix4P4XBrMUdX8d3WcGrDCeE7qX6tsYERX1k1MzXZBxzz8UF8JJwlsgRixqJdJM0SWrOxhiLwiMmUv9Qk7ehheDGkxiOIKNACHu3FscO29xyqZT7FCCv3jD0exxjQFEkhgoitjVnrGo60oU7m7QwaQ32Y926xFfn1eBvFFUuEi1lUInYNO7PgW1S5fwSLA967Eu4NY7CcciEuKOTkszn3nIm7ehQZ+a8xmq8OIAOFdr45MXrqqnrSRWBdQxxwS0crV8vxQlNi83KXMxHb1in0QU5T
 YHO+qMKh
 dR6Dt3eTFplcBi7DWIlUOv6l57j8Cj55YRWc91PE0OYEOtA1c/7xCV0yn1vRzT5DZNMnMxy5EBlotnpJih0DEfA7qA9vB91LVt1hUsqQ//b0yF3sg02RdS8yt61D0W8P5fCkiM0nwjpAGP12ImT8henauzXXnDHZtdPSM2NuHc6Mfvpfls6C3OyEsNdegXmlAp9d5YckgjkAefk7pWY1CjVnlAudbTVzl1bqOEIt0C0H9reA03XLidszRth1OijTB+aCjtGcl5dzGymeVKOs3t3mp78juyrXghk5+mR3IBTe5U6o3qiM2/9JWka01ZwxTns/q5ScNxAoPDS6FVh3oqnk6q4wRP3bu8tXQcVsZfPBq3Umd+j3Pvi4cBh1EUFMnXbbMTOuZak66hP9XRLzAiKyQA/81m0JOHcv+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 02:18, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for
> shared libraries") excludes read-only file mappings from NUMA hinting to
> prevent placement bouncing. This also hides hot file folios on slow memory
> from the tiering code.
> 
> Scan these mappings when memory tiering is enabled, but make their scans
> promotion-only. Ordinary NUMA placement retains the existing restriction.
> 
> On a host with 768 GB of DRAM and 256 GB of CXL memory running a roughly
> 430 GB database service, 169 MB of its 185 MB main binary accumulated on
> CXL before this change. Afterwards its tier residency tracked runtime load.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  kernel/sched/fair.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 81359b414947..e636e8de53f1 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4061,6 +4061,16 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
>  	p->numa_faults_locality[local] += pages;
>  }
>  
> +/*
> + * Read-only file-backed mappings are expected to be cache replicated between
> + * accessor nodes, so they are not worth sampling for placement.  They can
> + * still strand on the slow tier like anything else.
> + */
> +static bool vma_is_ro_file(struct vm_area_struct *vma)
> +{
> +	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;


MAP_PRIVATE can easily map a read-only file with write permissions. So the
function name is a bit misleading.

This smells like a helper that should go next to other vma helpers and have
clear semantics.

> +}
> +
>  static void reset_ptenuma_scan(struct task_struct *p)
>  {
>  	/*
> @@ -4220,13 +4230,13 @@ static void task_numa_work(struct callback_head *work)
>  		}
>  
>  		/*
> -		 * Shared library pages mapped by multiple processes are not
> -		 * migrated as it is expected they are cache replicated. Avoid
> -		 * hinting faults in read-only file-backed mappings or the vDSO
> -		 * as migrating the pages will be of marginal benefit.
> +		 * Read-only file-backed folios are poor NUMA placement
> +		 * candidates, but slow-tier folios still need to be scanned for
> +		 * promotion.
>  		 */
>  		if (!vma->vm_mm ||
> -		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
> +		    (vma_is_ro_file(vma) &&
> +		     !(numab_mode & NUMA_BALANCING_MEMORY_TIERING))) {

I'd vote for >80c here and but it into a singe line.

Or just use a magical helper

const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;

or sth like that.

>  			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
>  			continue;
>  		}
> @@ -4306,7 +4316,8 @@ static void task_numa_work(struct callback_head *work)
>  			continue;
>  		}
>  
> -		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
> +		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL) ||
> +			     vma_is_ro_file(vma);

As I said, maybe that flag could be voided.

-- 
Cheers,

David

