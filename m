Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7A0606A334
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD6C6B0169; Tue, 20 Oct 2026 11:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E466B0503; Tue, 20 Oct 2026 11:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D4B6B0504; Tue, 20 Oct 2026 11:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F40E06B0169
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:51:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBB12140202
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:51:50 +0000 (UTC)
X-FDA: 85343445180.04.BED7A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DDCCC0008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:51:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rp2WPSA1/ERI/64JuBOxmZOEGsPjBzedZzE5dNWVpu8=;
	b=lKHJIccH8y4xqew1lBuJ6OBNvNvMJjYgA9er5sLkUuUQP2W/AHyu1TMP6eFJnI//921qMf
	Ic46hRTmyVctv0y8L5pMZgQ7q805Og/vzTrhl11dQc8yA3diJjD9jNPCih1TLd7suH0sxY
	Exrod+QmbYLnVVlgAlI89aqM+mdU+MM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511509;
	b=N07uqAt8e2OUyHP6wOwqtCbyRO2FZqpROpaYpDUFE7tnCinXnB2FyTh+Q/AVJTHid97dVp
	evjYn6cmq3/4hJSGVhCZEiMecwkwzmgZ0bxwmPWTj6hb6kcZi5D+xAUwteJla7bgtN9Dig
	uj6rqLc3iagCPM1k946bnaS77cME01Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BCCC41AE0;
	Tue, 20 Oct 2026 15:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE881F000C4;
	Tue, 20 Oct 2026 15:51:45 +0000 (UTC)
Message-ID: <b61cbf73-b92a-4869-af94-72c30bbe9527@kernel.org>
Date: Tue, 20 Oct 2026 17:51:12 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, shaos
 <shawnq1@163.com>, stable@vger.kernel.org
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2DDCCC0008
X-Stat-Signature: 4reumhjuginkahinpao7s6ftusnzgnma
X-Rspam-User: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792511509-94469
X-HE-Meta: U2FsdGVkX1+FNm6nni9VE0ZaCiURIyohA5KjlztRlzDw+2dwraSlJR5oRQ6za2IUusvUEbo182KjlCiUWO+MikyqBM+/udtM03OYfZEmqUn6IJoOG8Fl2R9Do2WU7c0IqUXS4fVp15WUoVKfqw2Q8r/qkrMxQoJwNmMgZyHfkdkcWjlKAITh7GqEiXmKzoJ7PbUhx0/1LLTjrjCaV5kjTavAM86V0YTOxDQvpFXzRUyWN4dQ+FxvfL6SCRbIX7uPTUWOm/reqdnqJcZFUSq80yV+2KSZYkzndz5vYUeyivRxHVQBhdxRqlwhjzG1J1M4wgDLfFT9Wm7uog9EVBIFvykRIFkKeUvSVYiX8Br7NI6TaPRfzQWir3WCo9GFZZ7jBZKh4WQdoOaipIaa85V2s0RIDU/zgFmNBKV4fiVywL/YYVi7VT+qChYl5+I41llzvCPbA2P6rq+LCJ1IcGP/A8xSXqCKWzWoED9RKcWBveyFkdXxpPT1ltNkLnpC1IenSw16c9uuygRiNfY49oBCSIqFJWnC5fexHdCFHxCbQjvG2i4QJZ0/n39uVqvAUnWGSw7lg9vEP6MCxDFRtSIfC3aDNf+bVQjdYcQR6JgvpvsqnN8JmFTKIp+YM71gQkf9UzM4P62L7oq20mTTRlHhrM0wyB9Q0ViPKOOkoWFnuVM9RFpPHfreYKV96IhQFdkXY9FPRbP+cCwK0LucLBjtzv+wwEoJ0FMWHWKpio2ajpN6awuuuxQTCqnTCrp8UcNIlDklgs3x2pNDxmlOOToph6FFRhcVOm/qw2J20+CTi7pIvUk11EqsKHQy2MmAYb+vdMnb+E8ErNiidgiYRCSZnrlLmukEAV+A1mLm+FIUzs3Dql97oMPl4Q9H4BdWshp6jMcqihmcVy6mw4aMG377bi4/Jjlk3mBQdjVvlbnQ9dSQl1SUAkMd8kdLFYCZ1WdjkvO8YAYO31EebTY8Cc6
 o3RG0wXA
 ypCosHSrg5r6xL+1SlL62NXTnuZmbSOKjF0+XixX5+Mv7QvDihxA/poZm2A3Rfn/nWsvCY2v+GF/XKLHIGyKsGiKNjGs5OzG/ttcoUIedx/i4h99W5jPhmovfh+t4iSoybMBet/OjvDiFHrzY560l9f1AYlv5ZJNKQK+PwGWOkTwrgeOD6oozyZ3q8iI62PZbw/LzJdu41c22Sp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 16:55, Lorenzo Stoakes (ARM) wrote:
> Userfaultfd often causes unexpected interactions within mm, and does so at
> the intersection of uffd, mremap() and VMA merging.
> 
> When an mremap of a VMA occurs, copy_vma_and_data() calls
> mremap_userfaultfd_prep() to notify uffd of this.
> 
> However, mremap_userfaultfd_prep() simply drops the UFFD context for the
> VMA if the user did not register it for remap, i.e. didn't specify the
> UFFD_FEATURE_EVENT_REMAP flag.
> 
> This is OK for the VMA itself, as upon page table move, move_ptes() clears
> UFFD page table flags, using vma_has_uffd_without_event_remap() to
> determine whether to do so.
> 
> However, this doesn't account for merging with adjacent VMAs, whose page
> tables won't have received this treatment, and thus latent UFFD markers
> will be left around.
> 
> Worse, it'll break UFFD for any VMAs it is merged with. This is very
> surprising behaviour for a user, who will then simply not receive UFFD
> events for VMAs they ought to.
> 
> Resolve the issue by explicitly checking for this case via
> vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
> function explicitly designated for mremap() operations.
> 
> Also update the userland VMA tests accordingly.
> 
> Reported-by: shaos <shawnq1@163.com>
> Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
> Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c                          | 5 +++++
>  tools/testing/vma/include/stubs.h | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index de5ebc57e7a5..1be613044b4a 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1211,6 +1211,11 @@ static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vm
>  
>  	vmg->copied_from = vmg->middle;
>  	vmg->middle = NULL;
> +
> +	/* If not registered for remap, uffd context will be cleared. */
> +	if (vma_has_uffd_without_event_remap(vmg->copied_from))
> +		return NULL;
> +
>  	return vma_merge_new_range(vmg);
>  }
>  
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index be8f5161f92a..f786a585caf0 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -386,6 +386,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  	return true;
>  }
>  
> +static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> +{
> +	return false;
> +}
> +
>  static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
>  				    struct anon_vma_name *anon_name2)
>  {
> 

@Kiryl that should solve the issue I was raising the other day with leftover
uffd PTE bits outside of uffd areas? Can you review?

-- 
Cheers,

David

