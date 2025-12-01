Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3F0D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20616B0089; Mon,  1 Dec 2025 05:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF76B6B008A; Mon,  1 Dec 2025 05:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DC36B0092; Mon,  1 Dec 2025 05:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8696B0089
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:19:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEF2CC010D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:19:15 +0000 (UTC)
X-FDA: 84170504670.09.73246D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0544580010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:19:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHM8+8tL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764584354; a=rsa-sha256;
	cv=none;
	b=SW4/qc40xySNxCtCdkGWj3JFZ+NjggT8Epdj35+TNAo5j+39JIEOrkE5GqDVEavvkoCLVw
	zZTa3qBjVN7VccLAJuS0fMCpkekyIWgk8gjwBGKOpLeE4Zex5QMG7Q02YeucDAMRxzr7nt
	TingNDcxpRDFjA98ACsxSFth5sa6i/I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JHM8+8tL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764584354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNv35ngsb/er28vpMrNSSSArBUZm3Zm3RODEdr02orY=;
	b=ixc2gI6gpR3D7KzNMtYlYMzqyo/kl+bpF7W0Zb4LWgw86aS7ppsMInDG8nXlAbmjZsRpqW
	JN5uVDH7mF6qYHvRaWoxrGO+6Mht7DHfXSpyUEyIJR1Rs3r5RAhy1nUD66bHF1ZoGqOK68
	ks5FblPgtmY8V/3UtpNo7o7V1MxOtbY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3629F6014C;
	Mon,  1 Dec 2025 10:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D851DC4CEF1;
	Mon,  1 Dec 2025 10:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764584352;
	bh=xNjLM4V4MqHGMgpf2NW2wWz3QXuoLL9CSJchibOclpk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JHM8+8tLHacbP4wV+snjkXpnDRU77Jmqv1LFHFUyjgRG9uB+wXh6Gnll2/rBDcKxL
	 d4x3bFQnQ3cWyPwKm/pNUxGPJIDgcfw2M+ZxQSrq8P4heDa/bcYZD5A+fMXn17dFVu
	 zH81sh/2V3oBKgJqdpGuvbAY4ySCem8W1/95GoSC3+k14OdQxu+u0ceHs6RhM1WLCY
	 3D51fV9eZXfhPFfuDETwaZaGFCDXX1M7qNfI62GV0q1EEvylDvzscXErDzibr+YPd9
	 rcU3XotlAls8cEA9ogmi9ERzZ96+voTu1NXyezO86S9nE74cg1VJ1aZiJeynF9KyzB
	 MqYiibqWJV80Q==
Message-ID: <f4e43699-b0de-4923-a798-89522857bd1f@kernel.org>
Date: Mon, 1 Dec 2025 11:19:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] mm: Split a slow path for updating mm counters
To: Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
 Mateusz Guzik <mjguzik@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
References: <20251127233635.4170047-1-krisman@suse.de>
 <20251127233635.4170047-5-krisman@suse.de>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251127233635.4170047-5-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0544580010
X-Stat-Signature: ibgikhjwtun6f1ofjns931szd7ef1o83
X-Rspam-User: 
X-HE-Tag: 1764584353-950522
X-HE-Meta: U2FsdGVkX1/LLRr1qO+lLy+GvZZhI9DV8FAVEOCOPlZLturXpmI5bIozp4iZ75z3GntfdGTa/0umNprSu3mecBCUOP/oJuQfL3ugMCqyWOc9jUXuU7zROibwMCWs2XNP+A8BrMb8l69TPpORS8IGbXhCgXZlTf7nnucefbxTutRySoHuUWxEiBEuyI+5J6SEoSg70HSPKaT02+YZi5gEdWc3lyrYU0ofpUP8QJFYRIzkUj1yfjwqN9Kn3BZo2Z+rzwMtFN93mwPMX5eK9Hu+Dp3Bc4h00UwYGLgGUwn0Rn2Nq4iR6RFy84stDbD4/CLGyZw1CY4g074+r08prQfS/rtodbRLNiXCyXXFTtWZorZHZjidWwQs6xH/E/MU6cS7ZDa8r7HcGjsJNOxVum9KMQwNmUArgkSfQINdAwZljFKLY9F/NzobIh9mq4AwmHDhhSI9vGwrEfU9H20lTmnbkudT0NFqid7nzvY2t/DelcX3MopyOgBJMXnUHCnGU3vVowhRv6Z5C9Juf9ON7In6OwefKviz4YE21P8vI0mWOsETww0Qsxqx6dbjMCAMfjzU5Vl1Mbq9XEEUPzUVBXOCLxP5Ylsi3dYbY3AJIjToayan/hR6MuBOhBnu+pEjq0FH2svHORh82zKpSAo5ECtTYS5ZDHZey+4qysiTz15zQcYhOlg4I3CDcb7ea24V1+61AYXcMy9YdYBn/z3ykFAJAXv6STJTW/+sg1lrsG2+Rku0/KrU4mvWWRCZ90t5yUh6fuvU8fjLsU3mdP7JvhWkMQqfGmX2Rnxs3tAJGHBMYQCq1yfoKqPtxEDFBGIM2qeFCkXBdiwg4bC/FczjLmLMNO5wCao5IrOycYFhZuKdb7PzbCbu+XTwgxgwaGjtZ+jcqm5Zh0v6HFzyeRAWH4L3ClVPIahCORH4dB6WZci+7DXAAYiV3tWfxcsdNTH0+ZerPnJ08Zu4NWz7ucnWcSx
 x+TBDMHP
 iINnTQAMD8Q3p534n/wAepLF2sqq0yuqYXn9mUvm3UY94CC5eXpZP2WzW+ofH+mwGvG7MhWvsmJ1vbaUTzfAJn7bZTmlsDNkbbIDH61L0V1IO6EhgKn8V4PZJu278vUhvRq4a/3hhhc5ewHqqSX8wXyWK8/WS9o2l8V0ticN9qwuWnbk+lQOMvAR37PlsGpJLDTgMT3O8/NTgs4Rpr5MD0exfXUEamlj6v406bABZ6HuPmbEMBmB+yz/uM47IreQzqs5ebg1bHJo2uw+Yaul0YNbC53eSDc7YE0np
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 00:36, Gabriel Krisman Bertazi wrote:
> For cases where we know we are not coming from local context, there is
> no point in touching current when incrementing/decrementing the
> counters.  Split this path into another helper to avoid this cost.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>   arch/s390/mm/gmap_helpers.c |  4 ++--
>   arch/s390/mm/pgtable.c      |  4 ++--
>   fs/exec.c                   |  2 +-
>   include/linux/mm.h          | 14 +++++++++++---
>   kernel/events/uprobes.c     |  2 +-
>   mm/filemap.c                |  2 +-
>   mm/huge_memory.c            | 22 +++++++++++-----------
>   mm/khugepaged.c             |  6 +++---
>   mm/ksm.c                    |  2 +-
>   mm/madvise.c                |  2 +-
>   mm/memory.c                 | 20 ++++++++++----------
>   mm/migrate.c                |  2 +-
>   mm/migrate_device.c         |  2 +-
>   mm/rmap.c                   | 16 ++++++++--------
>   mm/swapfile.c               |  6 +++---
>   mm/userfaultfd.c            |  2 +-
>   16 files changed, 58 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index d4c3c36855e2..6d8498c56d08 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -29,9 +29,9 @@
>   static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
>   {
>   	if (!non_swap_entry(entry))
> -		dec_mm_counter(mm, MM_SWAPENTS);
> +		dec_mm_counter_other(mm, MM_SWAPENTS);
>   	else if (is_migration_entry(entry))
> -		dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
> +		dec_mm_counter_other(mm, mm_counter(pfn_swap_entry_folio(entry)));
>   	free_swap_and_cache(entry);
>   }
>   
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 0fde20bbc50b..021a04f958e5 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -686,11 +686,11 @@ void ptep_unshadow_pte(struct mm_struct *mm, unsigned long saddr, pte_t *ptep)
>   static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
>   {
>   	if (!non_swap_entry(entry))
> -		dec_mm_counter(mm, MM_SWAPENTS);
> +		dec_mm_counter_other(mm, MM_SWAPENTS);
>   	else if (is_migration_entry(entry)) {
>   		struct folio *folio = pfn_swap_entry_folio(entry);
>   
> -		dec_mm_counter(mm, mm_counter(folio));
> +		dec_mm_counter_other(mm, mm_counter(folio));
>   	}
>   	free_swap_and_cache(entry);
>   }
> diff --git a/fs/exec.c b/fs/exec.c
> index 4298e7e08d5d..33d0eb00d315 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -137,7 +137,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
>   		return;
>   
>   	bprm->vma_pages = pages;
> -	add_mm_counter(mm, MM_ANONPAGES, diff);
> +	add_mm_counter_local(mm, MM_ANONPAGES, diff);
>   }
>   
>   static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 29de4c60ac6c..2db12280e938 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2689,7 +2689,7 @@ static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
>   
>   void mm_trace_rss_stat(struct mm_struct *mm, int member);
>   
> -static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
> +static inline void add_mm_counter_local(struct mm_struct *mm, int member, long value)
>   {
>   	if (READ_ONCE(current->mm) == mm)
>   		lazy_percpu_counter_add_fast(&mm->rss_stat[member], value);
> @@ -2698,9 +2698,17 @@ static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
>   
>   	mm_trace_rss_stat(mm, member);
>   }
> +static inline void add_mm_counter_other(struct mm_struct *mm, int member, long value)
> +{
> +	lazy_percpu_counter_add_atomic(&mm->rss_stat[member], value);
> +
> +	mm_trace_rss_stat(mm, member);
> +}
>   
> -#define inc_mm_counter(mm, member) add_mm_counter(mm, member, 1)
> -#define dec_mm_counter(mm, member) add_mm_counter(mm, member, -1)
> +#define inc_mm_counter_local(mm, member) add_mm_counter_local(mm, member, 1)
> +#define dec_mm_counter_local(mm, member) add_mm_counter_local(mm, member, -1)
> +#define inc_mm_counter_other(mm, member) add_mm_counter_other(mm, member, 1)
> +#define dec_mm_counter_other(mm, member) add_mm_counter_other(mm, member, -1)

I'd have thought that there is a local and !local version, whereby the 
latter one would simply maintain the old name. The "_other()" sticks out 
a bit.

E.g., cmpxch() vs. cmpxchg_local().

Or would "_remote()" better describe what "_other()" intends to do?

-- 
Cheers

David

