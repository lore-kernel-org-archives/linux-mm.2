Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56368606A8BB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NGOjZg1k
Received: by kanga.kvack.org (Postfix)
	id 59AE06B05B7; Wed, 11 Nov 2026 17:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524556B05BC; Wed, 11 Nov 2026 17:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECA26B05C0; Wed, 11 Nov 2026 17:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10A1A6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:49:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 881F8402FB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:49:40 +0000 (UTC)
X-FDA: 85424331720.02.DF9956A
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf13.hostedemail.com (Postfix) with ESMTP id E8F3B20003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:49:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NGOjZg1k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQue7jLFUdSGesUi+3B7mc2JziPrIDnIULtffQJGgvg=;
	b=0DV0NmzxpSRF2ldyQbQnNr44R9nkZ3lrzOEu9KFTYJrKcmVtYOTTTzitf+rq7xOYM+ItPZ
	ZK2EEQRA2p8lEqWKdDXGS7Mcdbxbg8GWfAb7CB5Q3VrALL5OEEMRJi7ewcj2ASkSV3dTGm
	355QB3NAi11zDSBEeA0BYaEVX11sptc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NGOjZg1k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437377;
	b=vOSmUDk9DFb9mEafAZIXWNSMayq8O+yTz+cBPOUgAgt1fFQQDLaMcdKVEHKU6N1P/zM9/c
	eXIqFM1EMDb3m3Bq5tSWsHkax2vtUlRAHYkQ/5baPEO1K2QKbgyQ/aRsuZaWDBjYeHTWLS
	G1C4LtFV5NiDTab18+Tps5VmYKvPVok=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TJQVUzglty5DBhKdqOJX7Uq+2tUl+AilQ8bRBeO+zoU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794437375; v=1; x=1795042175;
 b=NGOjZg1kEgy3pz8LKNVfq9xcU6WU08nFKlG0U3hFRV46SsAguTFXlvwzbAckX2UtQ8gBRTcm
 NMTDlX+JyjqrDjKcEJHtHyM1cfA9R1d8DeBSRuQjVllwxhNvPrnGRHsVvVN6RZZ+md/YzcF2nYp
 uImjB4h8am86aMNefRqQVhlo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7aea4d3fde09893e;
	Wed, 11 Nov 2026 22:49:34 +0000
X-Mizu-Trace-ID: 7aea4d3fde09893e
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa4c71b6-f81d-4544-96fa-ed54e78b0de1@linux.dev>
Date: Wed, 11 Nov 2026 22:49:34 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8F3B20003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: j5m4yxa4tn6e61ui59bs57fnrm4qpr5j
X-HE-Tag: 1794437376-28515
X-HE-Meta: U2FsdGVkX18Pwh5VO2BZAYmq8JbqOoi8Mw31yf9n0kZZw8o6EK9uL3b0bOSpqSfVBSAoYNwKvVRBim7vpyBbo2uY+eYXZEcF9NtYnBeRDKdNJHr1jqMNy/hajp9hXhpq9EB3Mqbg6V9biYpAP6xYk19TvmWUKN/bN0OUytz0yKRPRb22fXTMVe8NQfqvlZWJAGbucXmySEbCcK6/gNQT9pm/RYF8fCR4rHKgimU6ZAd2VNCpj8q/9efkOpyG8t2oDoZ9w0KjiSLapZwomjSia2WVTYUO1jKRZITrIuxuL4uvwnE286yxUf5SaDqVsHUw8ZChu7VScqg56Cxl5Ot31BlUhLVB4VOFjufuTZujRSoD19zo4UdBKxXIeFPPE4zobCrPd8v+xZCqNM6Iw7tfoUeauenhZO45BlBdnwVdXHF1WjbOs2WbRvspZgT0xpJCvZShpQWenq8c0N+2TPgpgwffD23/XYtvHlKY1kM6V9rdOMhS5kBFZ9O0VbR+qyvGxZS80zANoWkBDCloGgvqV0VgQT4E8OA4Sjc3/E5BcDlCZUvSGnm7FRijyp0r31tkUd3SMmESUSqobdhGy4moO9SV8wGRItfObW+YsjPjuaxHi6Y/JKZAMgSOCa9WGA96wDC3KtYukuAyLEH+zCxI70YxkI/nBMrN3XVo5Ge3X3GWFz4/Vgby15/64dYWWf5FaM2MQ4ILYzj+0cksdVng+A4bkIW7Bp+cMkq1FHe23MUWXTFT+3L7oa/Gx0Od5gMFnwGuNvsEzRzDvPgczu3hAic5R4HSRyfZmzwZHqSsJrmXg0w+aGc6lv4eLZJvuQtRa/Z0GqhMNTLh6haaxFyn3uPMKVvaQmaTlBNSzL6TkhRyBSOGzaF/BpWV4+aHj05SnVwCrQUnTl99/6SCR8WZA/adyRoVFQkR19IYpH4QnFBwuitAXXEO8HRge66iq9s8HpoJDQNqqoRXY09IKDI
 I3vH/oha
 fXEAnkF1junhUrir/bWb7wGcJM3xiKuyddXggKmJv5A6y4DBD8mn6bwWI2wePYKfWUIZNyJdBCMLNncrJwGtujO46u3i3qn5uh8NXTyOc5NOvsQ2MN/0sKXxfKIfcdZJh6GrJh8IDmu5QBJUJaeqJyOUDzFPYgLigQ7la8ASVgymzlOT4veqiePmexExnnrKJti9v8h8JJofEILFT+Fpd1TP5qlmnpgEMyU/5yX1jHeEactTjoyufJRjUztAXIcmFcbWzo/BkXCwynZ7cqqvRDvhJ9XcbJgnRr0fFMP/RgYHpYjatKvNL47XvR55YzRwld0CNCHaHMhGoAJB9eeiDFkfv4MIl0OTztzcia9lciiigQ4Mi/RasaB+EkoYYO6zH+VZhLqpGqjycHg0uyzfhr6lwy+nxXAKP5b5VQcsgmRQe6gc3fH5g3DE+LGf8yKaLaw4h0E3pIfS6DnFXvjcodZVLMMX9rafHVx5gqXpV0zeyB1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/2026 18:13, Lorenzo Stoakes (ARM) wrote:
> The OOM killer can quickly trigger again after having selected a
> victim. That victim might not have freed its memory yet, but its mm will
> be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> 
> This can cause the OOM killer to kill an innocent process when the first
> might have freed enough memory to relieve the memory pressure.
> 
> Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> 
> Note that the task which calls mmput() might not be the victim - if it
> took a reference on the mm (e.g. ptrace), it may hold the last reference
> and release it when it calls mmput().
> 
> Therefore we cannot rely on current to tell whether the mm belongs to an
> OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
> unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
> mark_oom_victim() sets on the victim's mm, and check that.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Makes sense, it will free an OOM victim’s pages before setting MMF_OOM_SKIP,
avoiding unnecessary additional kills.

Acked-by: Usama Arif <usama.arif@linux.dev>

>  include/linux/mm_types.h | 2 ++
>  include/linux/oom.h      | 9 +++++++++
>  mm/mmap.c                | 9 ++++++++-
>  mm/oom_kill.c            | 4 +++-
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ed35d258d2e..09e63ff12b04 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -2030,6 +2030,8 @@ enum {
>  #define MMF_TOPDOWN		31	/* mm searches top down by default */
>  #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
>  
> +#define MMF_OOM_VICTIM		32	/* mm is the oom victim */
> +
>  #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
>  				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>  				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 00da05d227e6..a9390cb70541 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -76,6 +76,15 @@ static inline bool tsk_is_oom_victim(struct task_struct * tsk)
>  	return tsk->signal->oom_mm;
>  }
>  
> +/*
> + * Use this helper if tsk->mm != mm and the victim mm needs a special
> + * handling. This is guaranteed to stay true after once set.
> + */
> +static inline bool mm_is_oom_victim(struct mm_struct *mm)
> +{
> +	return mm_flags_test(MMF_OOM_VICTIM, mm);
> +}
> +
>  /*
>   * Checks whether a page fault on the given mm is still reliable.
>   * This is no longer true if the oom reaper started to reap the
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7618e72766a5..4cb18b217048 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
>  	/* update_hiwater_rss(mm) here? but nobody should be looking */
>  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
>  	unmap_vmas(&tlb, &unmap);
> +
> +	/*
> +	 * Free the memory before marking MMF_OOM_SKIP so a re-triggered OOM
> +	 * killer will only skip this mm if it's already freed all it can.
> +	 */
> +	if (mm_is_oom_victim(mm))
> +		tlb_flush_mmu(&tlb);
>  	mmap_read_unlock(mm);
>  
>  	/*
>  	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
> -	 * because the memory has been already freed.
> +	 * because the memory has been already unmapped.
>  	 */
>  	mm_flags_set(MMF_OOM_SKIP, mm);
>  	mmap_write_lock(mm);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5d48bd862c27..9de57a23893c 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -752,8 +752,10 @@ static void mark_oom_victim(struct task_struct *tsk)
>  		return;
>  
>  	/* oom_mm is bound to the signal struct life time. */
> -	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
> +	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm)) {
>  		mmgrab(tsk->signal->oom_mm);
> +		mm_flags_set(MMF_OOM_VICTIM, mm);
> +	}
>  
>  	/*
>  	 * Make sure that the process is woken up from uninterruptible sleep
> 


