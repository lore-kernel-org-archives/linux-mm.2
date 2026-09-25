Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE29C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5816B008C; Fri, 25 Sep 2026 06:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EE36B0092; Fri, 25 Sep 2026 06:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116EB6B0093; Fri, 25 Sep 2026 06:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D94C26B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:55:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 616D180594
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:55:25 +0000 (UTC)
X-FDA: 85251978210.21.06B5FC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFA8680005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:55:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=konjO3sD;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790333723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATppPA08cbrd3rkkrcMCwx3kOQ21INX+r6Ut92RHrGc=;
	b=G6PgAPbzg4oDoClPnFU2mrh2SB4mPFBc5EPQPiZGYyieYmF2PG+hYzxv7rrIPCniwnJBO7
	Riun1CsZ4BgFSzHDL+8JLC8AizRXwYvdmPF2befJxYapjLziCDNm4IhNcseCxNkqUrEom5
	oA46SZAsmAU1Tngzz6fnLfHVqH/dP0I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=konjO3sD;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790333723;
	b=CRYiLGxWBVPYTf+q5Nc6QR/TYZHk4qp9+Tk8U3ecMy1J5wnI27q7WzCIo4aoX3VFAdAAh6
	N/LXRECXbt54+msvSYrw4/ZD89l+9Td5G6ANptfXgJg2Ks2FFDEnpZpt628niVwGcr41j4
	t97x3eYiEHmoSy3Y7P/L+6yMgLt2K1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AA4B60136;
	Fri, 25 Sep 2026 10:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3820D1F000FF;
	Fri, 25 Sep 2026 10:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790333722;
	bh=ATppPA08cbrd3rkkrcMCwx3kOQ21INX+r6Ut92RHrGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=konjO3sD23vveaJBinGM0SJByCg78KytyAQj8Pht9Dv5oz1t2mIBzNIe/XRlEdNJX
	 XnpYp27AgOerWofLyjYuQe4vlt30/DNLVeUbBBdPvonILl3DS1TXLEzSRF4EbYgTFS
	 mauWH0jz4ZCRYic2poGKUz4ee2pfoawHcb/fOhaunODCqLpsf9fbmfGTMa3MG1YlJV
	 Cm5/yDYv/IWyPnQ5MPTBmWji5IYL783VGrNjFn3Hb5FT/BVw0zf0xLxYVsWmKKJOWD
	 U23iyusaUTu7lwNj+0RdCqBlMpkDq370R2ueOlaYwhirmA41+ru+ohVYwOhqf0paF1
	 cWczDrPzDVMjw==
Message-ID: <ad99014e-3714-45a5-ad23-aa7fe72745cb@kernel.org>
Date: Fri, 25 Sep 2026 12:55:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] sched/numa: scan PID-inactive VMAs for promotion
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
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-6-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AFA8680005
X-Rspam-User: 
X-Stat-Signature: aeszetndfxadhgiufddaawd9yjn1k41j
X-HE-Tag: 1790333723-781321
X-HE-Meta: U2FsdGVkX1/+GNBSe4Xi9vDeIocQhrJaOvrsqrew5FBYoDElB4S56glJ7cigYqAUxWKEK4wnzFpoMwJFO4Ac5q5uKAHK03NLN7v/AyuybwIdT0NfT6oV5ogMYBYHJR1xtmH8P7e5rLG5YveG4jrHo7KhhEmdTqbhFNmcqp9OTzsHLAbetSuXzNmHVeFyOZAibJkkNVwxRv7rfoN0pCqhXpKxXEQtG3b2XubC0qfcax3Xe4DqICAPMhP+aUOtIYr9lZr0v9IIgyKmqCJsi+rCR93VuezX49VrCSpDhPvf8Wbg6S1Hgmp6Ja5Mf+2UiANt91rYYmAaXMIF+x5hNHKlVSUndU44XQow+CxcDDDuUvMRhm/wGynS88kPcTr6/KppcCXA/oFoT/qyQC4vlc6lPxQgwrS2UfCOnWmjDY231nZzh3bL55Qk4NHJIPS1U3VZ4qxIBJiia2U/GVRqpQvMZFKcAAP9e7d6oZ8DNCbUg1Ef3Hrp6y72J0adlGTFijUdLY3PH1JbNKkZ3fUkQLA5dnV4uqS1E+ypGhk5bs5qpj/XqJc05QQjnHy6Ie/0JfWit7v/zbPFsbKBFXgI3kF7RFpd/jGDZd92lH6bpxev3BaOF6TWAjACJGHpG9XOriMcd6VeQ9VJYEP5Ob4kRnXdg+QHpfTtRl6e9Q16AFwcZb+g1hW0HoYGZsFCnuuCEdMalUC3weTUFl6BLH1xY5nym88bpyVDGRcwGWvwOji64pyvMAMBi9VOeiTDvnNCUu/5icXFP1g9PnvrzxsgAMse5n83UiqVaMMASh0/wB2pk98VBfYe6hxefuBR13SEHADsDZYSGVTjP8y1wqnh+2ZtweBbTkXlUyd6Xvbjb8M4PpVyW9gEFrni5yylzs76vHAkW7YZemuN81zti3dUUHs7hN4RdcvDJd+cDXQuvbeq6V93HNgz9fnaMveeXjEhh1LdY92edu7Kd+9GlRHVrKS
 dTRCNXz/
 SwkI70l/Z6CMQamkX4zLRgIRWbFoPdheETASKI2vHkEcv52LOaKzdfMWPYbDi2D5TQATHX1CqZ170YPev47XaxFLyXEbUs98ihIfKtCe5cn/kDuzBblJa45BlqjIvYcHKlx+N3p36UuPzt6AiW3uRgrQpZIX7COfPlhvAU9vtaZeKmZiiumHy9CcxvuWy4RjyuuS84NNeZUTFrdEa50kCSBnvnuCqLFAVwZABp5fpH0w8Wov8zr7vxoMiagv8qdQdma4MEQ5C8plXrnnD0pBdgcIO4Zu0/yjU1EQxBBwUFFaE89Wi0X1Z/vGomxCZtYtUSfoG+r3xb4+XC+yBA3iAnb53IWbUfVODVZH5DAa4l492lpNdtQXDH5BsTf7zEREwGmM00u5IpPXhcl/+joX50CfCOsG943O6ZSpr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 20:29, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic") skips
> VMAs without recent PID activity. Since only NUMA hint faults record
> that activity, the filter can suppress the fault needed to promote hot
> slow-tier memory.
> 
> Let memory tiering bypass the PID scan filter. In combined mode, use the
> placement decision to restrict top-tier sampling to VMAs that need it,
> while inactive VMAs still receive promotion-only scans.
> 
> Track the last completed placement scan separately from scans of any
> kind. Promotion-only scans still update prev_scan_seq, but do not
> advance the placement-starvation horizon.
> 
> On a host with 768 GB of DRAM and 256 GB of CXL memory, one large shmem
> VMA consumed most scanning activity, while 2,537 other VMAs covering
> 84 GB were skipped as inactive. One stand-out result: a hot 20 GB hash
> table ended up trapped entirely on CXL and drove CXL bandwidth
> utilization beyond sustainable levels - resulting in a large regression.
> 
> With this series, the hot hash table ends up split evenly between DRAM
> and CXL, tier residency tracked runtime load, and CXL bandwidth
> utilization drops from 45GB/s (maxed) to 5-10GB/s, while DRAM bandwidth
> utilization increases from ~200GB/s to 250GB/s+, resulting in major
> throughput improvements for the database workload.
> 
> Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
> Cc: stable@vger.kernel.org
> Assisted-by: OpenAI:gpt-5
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mm_types.h |  7 +++++++
>  kernel/sched/fair.c      | 26 +++++++++++++++++++++-----
>  2 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index fd35db969bc94..dcca3ead9db59 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -804,6 +804,13 @@ struct vma_numab_state {
>  	 */
>  	int prev_scan_seq;
>  
> +	/*
> +	 * MM scan sequence ID when the VMA was last scanned for placement.
> +	 * The starvation horizon in vma_needs_placement_scan() counts against
> +	 * this, so promotion-only scans cannot postpone placement indefinitely.
> +	 */
> +	int prev_placement_scan_seq;
> +
>  	/* Preserve placement-scan eligibility during an in-progress scan. */
>  	bool placement_scan;
>  };
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index a2849e72c4e26..412c72084a63d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4097,7 +4097,7 @@ static bool vma_needs_placement_scan(struct mm_struct *mm,
>  	 * threads can help scan this vma, force a vma scan.
>  	 */
>  	if (READ_ONCE(mm->numa_scan_seq) >
> -	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
> +	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
>  		return true;
>  
>  	return false;
> @@ -4267,7 +4267,8 @@ static void task_numa_work(struct callback_head *work)
>  			 * to prevent VMAs being skipped prematurely on the
>  			 * first scan:
>  			 */
> -			 vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
> +			vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
> +			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq - 1;
>  		}
>  
>  		/*
> @@ -4300,10 +4301,13 @@ static void task_numa_work(struct callback_head *work)
>  		 * Do not scan the VMA if a task has not accessed it, unless no other
>  		 * VMA candidate exists. If a scan is already in-progress, finish it,
>  		 * but track continuation separately from starting a new one.
> +		 *
> +		 * The PID filter must not gate promotion. Allow PID-inactive VMAs
> +		 * to proceed when memory tiering is enabled.
>  		 */
>  		placement_due = vma_needs_placement_scan(mm, vma);
>  		scan_started = mm->numa_scan_offset > vma->vm_start;
> -		pid_scan_allowed = vma_pids_forced || placement_due;
> +		pid_scan_allowed = tiering || vma_pids_forced || placement_due;
>  
>  		if (!pid_scan_allowed) {
>  			if (scan_started) {
> @@ -4315,10 +4319,16 @@ static void task_numa_work(struct callback_head *work)
>  			}
>  		}
>  
> -		/* Keep scan policy stable while processing a VMA in chunks.*/
> +		/*
> +		 * Keep scan policy stable while processing a VMA in chunks.
> +		 * A fault in one chunk can make a VMA placement-eligible. Keep a
> +		 * promotion-only decision sticky for the rest of a partial scan.
> +		 */
>  		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
>  		if (scan_started)
>  			placement_scan &= vma->numab_state->placement_scan;
> +		else if (tiering)
> +			placement_scan &= placement_due;

Same comment. Apart from that LGTM.

-- 
Cheers,

David

