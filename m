Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DED8606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OESRhMpe
Received: by kanga.kvack.org (Postfix)
	id 4BEB06B0478; Tue, 20 Oct 2026 06:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FB06B047A; Tue, 20 Oct 2026 06:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E306B047B; Tue, 20 Oct 2026 06:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 135AE6B0478
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:33:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72A96C011B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:33:12 +0000 (UTC)
X-FDA: 85342642224.12.2B26D1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91F6F100004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:33:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OESRhMpe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792492390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FihuiNID/Pk5K/0ONXyOSOSNJje8QjS2ThIwMHmFPbk=;
	b=O4Qp6iNx02z9+73iJ1ZaHKReLo/Kk/RPTO8DRmYW1zVXawn/9n976gB/oPxVTvXzR7f+0O
	8PvvqQYaXqbNKzFrebuIvhPauB0ZaBn7WsdKl6BzcgzydglRDcQI/ZcIviCt19exMlIzJs
	UZy5aMWxbNNCPvpjGzuBg4YI6sziV6k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OESRhMpe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792492390;
	b=E8lAySPyk8OzeN5T72FWxg/ED2ypisK+9qrkdj6gWxzsuj0ZYqQ9yysjZmb8ZJV0GZFk9n
	5VbSD+chrw9aoJ+UpVY0JEc/mn4IzkePQ03Xdb9Q0faefG0+21tQwF4KUgU9QW/Vyp5+vT
	0sOE35qYcIrMJ9q2KEoo5mZc/TDgSAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9575C43B23;
	Tue, 20 Oct 2026 10:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6B91F000C4;
	Tue, 20 Oct 2026 10:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792492389;
	bh=FihuiNID/Pk5K/0ONXyOSOSNJje8QjS2ThIwMHmFPbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OESRhMpeLDUSaKFGrPf+6FmN6yHuBITxtUHklGUlHeJRR6FAaH6Yj3spEbEXpAejG
	 oZO5WDKIm+m7WJLnydupi9P2UsZuT10iJxyqQr+/aG3ByqyQyl7/AtOqrw0QXMLgcu
	 nvfjWrVd1F5fvqAIN0QxmCqMMdo7XwuMbfJDjMbQtuHBlFz4YH+Swf3+vv+YldUTMq
	 qNnhocpZRPCy4vgJmr9QaoPVR4BKXcJSQFg5LDCvz2UuGIZFOREUm6eFO4RnpXopzv
	 zvmTiuyZlMRYaoeRUwM63AFx++PevK7IAQtttP2Q1A1LMFVIH6q0ptEp7QZkOgmH63
	 w0/bi/wRRsSbQ==
Message-ID: <baf5943f-b3fc-4a8d-85cf-bd897bb9a08a@kernel.org>
Date: Tue, 20 Oct 2026 12:33:05 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/3] mm/hugetlb: disable PMD sharing for UFFD missing
 mode
To: Mike Rapoport <rppt@kernel.org>, Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261019113034.97690-1-lizhe.67@bytedance.com>
 <20261019113034.97690-3-lizhe.67@bytedance.com> <atc-PW2PirXZzNZh@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <atc-PW2PirXZzNZh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91F6F100004
X-Stat-Signature: ynf1ff77ehex616ump9h7phk4r4zzsmb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792492390-909844
X-HE-Meta: U2FsdGVkX18HurYKWA9kBetYZqQ5ixCNQXcWHPgjw8G2exbWiXnmbCgFBCWwH5lNSYD6A5rr0Lzq442LpvtMX+mvMmMPaPHx72PT9ProTJM/RW2SfJlqBLNtxpXkKknSfWm+M+yK4Z8qoVTMZqVpJW+V4zUJLMFCEuupic6H5qE/Xl5vbHhs05y02odyjWrQE51SJisIpYQLLGpTxfQHB9KOT9YbYzws1hivbWNPuSI9XC01IPBsaxG1aL0ybZF5nWLxZPzDJO/IVu8TacNSt9x0JkbH9MJhPUQgZ4c/3MfPxtUmwb3BMUpYKiC6V+ObaRmX1wZ6ZJgXAXyc0iaQZkhqbPqRusgsATNYF1hpyLpvK5J2TWZCK/ZmT3QQjpggCOL6DdeRpfqLvvcQiRfT5RiCEFuYKeYkPppsk2sRQdLdZ+z7Qua1wFJhwV/bQ44EvT4ssTSsulksisIa1GaOh/E9IwzFUo4q0ccrgZ7NQPsVWBb1ZVzffV7WNM/hLSN4+N3rL/vQpAqUlS4td3x8T28ong9OTj/bO1EbV2dlfGCUeYX1MTKM97CyNflRM9onxd/nRFgWnx/1AGWgRC5/9CKScROLI8lhtuMMG9P/40n2SZMv9JO12L+HwIBdZFjJC9thmkRjmXp3dctf1/0F06m0oarU5EvVmiYoVWz5zO1a8QXP4uM2w758Q1VkgXhWZiqpKm7hlFSPFgtQpXwaavAMmJkNpDDsXaP11Pc2zlbnhTg1qyKYDb3yIgRYkr0wZxiWNuok1uqv0Hzezip+CuJcq01qotXeHsdMdmHR+9yLeowvw2XNaIEvDDevCK5pqjD+EKO+ROGFeJSbCDpuX7c8oVUnoUCd1MBLXDA4dd5eliE+hqLdwAfYULfuQS4Cer1eLXOsMoGhQFFaBm3sXopxPGfl11uR5cgrJfIgysAeYB7TNY09I4OBVi46N3fdcPODpTbTTe1fQ+rE+nL
 RE9zpOPz
 sZQOihZhOLo8w0zOuZeXdG66rh9ZzmijqZGK5rUi7QxS2RP31k+0+odaeg28JnlMU9ccAP/IYwbuYrvWC9Qg4zEEv32mnO4WAwHmJSjaK46KCGYBojkr3kiCb0A+5p8o5adaXp/M4K3KWHpbjie771P3W5mKxrkgW5lIWbwAGnRtkMYXa1zPTCgiRwzJBRo74JIPcyWGWfYjlBTz+1qMm+Ty60rRImLTRTk5dn19/NMFZ5V5fYl74Yx+CIoWVGV4sd0kg4O66GG4lTOeGH5UocCPgcxG/v3Ra+o+vWwPI2Hr6ktRd0Y8Q7/QY8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 12:11, Mike Rapoport wrote:
> On Mon, Oct 19, 2026 at 07:30:33PM +0800, Li Zhe wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
>> sufficient to have the VMA registered for missing mode.
>>
>> However, UFFD missing mode does currently not block PMD table sharing, so
>> installing the marker will be visible to everyone using the shared PMD
>> table, which is wrong as UFFDIO_POISON must stay local to the process.
>>
>> To fix it, include VM_UFFD_MISSING in uffd_disable_huge_pmd_share(). Add
>> a debug check on the marker installation path.
>>
>> The existing registration path will then unshare PMD tables, and
>> subsequent faults will not share them while the mapping remains
>> registered.
>>
>> The alternative would be to unshare PMD tables selectively when
>> installing poison markers, which results in way more complexity. Or
>> alternatively, simply failing the marker installation, which might break
>> some use cases.
>>
>> This effectively disables PMD sharing for missing-mode registrations
>> that never use UFFDIO_POISON.
>>
>> Suggested-by: Li Zhe <lizhe.67@bytedance.com>
>> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>  include/linux/userfaultfd_k.h | 13 +++++++++----
>>  mm/hugetlb.c                  |  1 +
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
>> index a4351cffc60c..fe78ba14dc68 100644
>> --- a/include/linux/userfaultfd_k.h
>> +++ b/include/linux/userfaultfd_k.h
>> @@ -169,7 +169,10 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>>  }
>>  
>>  /*
>> - * Never enable huge pmd sharing on some uffd registered vmas:
>> + * Never enable huge pmd sharing on the following VMAs:
>> + *
>> + * - VM_UFFD_MISSING VMAs, because UFFDIO_POISON may install markers and we
>> + *   want PMD tables to be unshared when installing these markers already.
>>   *
>>   * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
>>   *   tracking information is per pgtable entry.
>> @@ -182,9 +185,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>>   */
>>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>>  {
>> -	return vma_test_any_mask(vma,
>> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
>> -					VMA_UFFD_MINOR));
>> +	const vma_flags_t uffd_flags =
>> +		mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP,
>> +					VMA_UFFD_RWP, VMA_UFFD_MINOR);
> 
> Since this essentially disable pmd sharing for any uffd mode, maybe replace
> the flags check with the check for non-NULL userfaultfd_ctx?

That would likely even better and we can just simplify the comments as well.

-- 
Cheers,

David

