Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89566CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4AB6B0099; Tue, 12 May 2026 15:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECDCE6B009B; Tue, 12 May 2026 15:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE336B009F; Tue, 12 May 2026 15:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE3DF6B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:18:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AC094050A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:18:24 +0000 (UTC)
X-FDA: 84759728928.26.80870E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD06C20011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:18:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H1w5otV1;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778613502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OiuA2Jn1DpScabNb2Ll+SpJ29ZAx6+ja9tUZoEsJjI=;
	b=auWaiGosd2nwrynP9m0++AJrHALRwJ6JAvPzOiY1g6TG3NLCH/S6sVvl1sMmC9i67gQeFx
	ruU3gpyxHEvrihZdWTn44o37ZC426EjrENqRwYGSwla2NOkJV6V9OIBrHzp6YOsdXESwCM
	t3KzXp2wHd5Wt8isnj6XUuhOJl7k2e0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H1w5otV1;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778613502; a=rsa-sha256;
	cv=none;
	b=VLqQUXwNzQfqGGwOS0rMmmDhDTS9BNEb/GGHLzMEwhBGEwQab9aNn0qsWZGzjiGi+6bxLv
	n08lmt68rmeNhbfnz7f3fBDQPbIMerOFd//lMnjAjEfgcKyr5/i7n7VtPimG1UYi1OufeG
	EyMAp1gWgkpXUQxnJwzqqoKF0TVooW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14426600CB;
	Tue, 12 May 2026 19:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B672C2BCC7;
	Tue, 12 May 2026 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778613501;
	bh=n9ZB7A2gEdvqANZ8FsDaEPZkfoEgyD4mck1ueTnSuwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H1w5otV1M3DsFdgOglqXsLKFi+B0mybGzQnjOAOajRKElgWSaUOGslfaEWlPfEgpq
	 ZDAWvQmaw87Mp75chPRwYcLw950rhB6j2Xw5yF0U0wxwR3PeixxnNA2cCNQQaotGpw
	 MNk8lFWsg0xuJNECXAxoD+zkqUGzD7Iv6QEOXEEwFoUe4UJTQKy8vbngMcXS/09UYC
	 nEdoofgxND8MTjeEFA81eYUoPotRoKpRqAu4LlcIi/l0DszSE5WCDEMPKdsECDECUT
	 AluWRgSDSCM3sc5ct0JFtPSNn0mfgrgu5JOyvrBLezEfIhOh8a8asMZTiWz3gv23eT
	 qjJn9H6vETxFQ==
Message-ID: <f073a8d7-5761-4f7b-a5e5-c6aeae5fdc72@kernel.org>
Date: Tue, 12 May 2026 21:18:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/hmm: Add hmm_range_fault_unlockable() for mmap
 lock-drop support
To: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, longli@microsoft.com, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, shuah@kernel.org, skhan@linuxfoundation.org,
 surenb@google.com, vbabka@kernel.org, wei.liu@kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <177759840859.221039.13065406062747296947.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <563bb216-c270-4711-adda-b91484af40dc@kernel.org>
 <agNS4llNtAHBkMA2@skinsburskii.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agNS4llNtAHBkMA2@skinsburskii.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD06C20011
X-Stat-Signature: pysog4ds6pu5b8go4eiw97aah3dq346c
X-HE-Tag: 1778613502-638201
X-HE-Meta: U2FsdGVkX18m1sHQ/2j3WJDmApM8SUHjRuivODQC1sFdRvX3UGzpX7HhAKWCvivKz6BPr9Yqqe/TI1sQZNyMLcYSCGCPx2jKR07BStsNZPvYJqcRVlnto02ZxlNgoLIRNBqo4b65cLNASfz9vVZ5ZeVAQXlo2Cf58zJUGAAWIRTpHLKDqXHZ8Q6D+dGswYAdxEfhdclbQBRx92DnhpcNiX0BmHIvWJajvlUoj6YD7Z6k8RzFeXrkhHrKB7TCcqRTclVT4xuMpYYQA3OtmixP/QoD7ExEzJfPkdvC9Am2G2pFftO60B0QBhmkXgK9ZHTzHs63rQq84RX5jZuBp39kUhmcgacHgSx2V6dRKiTQW5SxwezoHrE81MfjwGV9CxApPcnvs7Jnt1vIanaFt8D+cRZZGDN0nmSVf2M2YTfiz8dkJ9h+Xp1s4wvHIedHhSV314p1E7fDvPf6YttTHdbI0qHUUHCcC6NZQWBthO7uGS+NgeZNuZQ7qgfjqKtybI+BP9qcCgbmHkXew+ug7/7m4vK80Xao/dRnZiEi6fRSI9QUPfeJ8zcaSCzLtAF62PZPwPdu/NpzB9NS+T5jK3N721sgOpyjLqj1pX+EEeIphdKDtQ2nzvF24dgZ4lIJnd0faZr86sxFFK4hATjc6qnHYZlc5rx4BLfp+VRvHhg3z4STjNKTHBjLhZKap3eZmDYKd5hj9OBzKmtV4BTiacqBlj9aCvnSW4MNoftxWmj2AURZ0l3RTHAiyPeQ6U9COYw+VgJqFqXAqUd/jarSOTqKwy17RLrDoU8z/kVpnmbQefJ3fFNYsGOJXRCpAPbAerJPgpm9bluy3s07g0DzHxOC0zxe8NQMvBVWf8B4KD5CDduXHWV+GFVo9j9K3QDgkTRBULeLYNaAEKUeqFpHmV6/cOB1gNjT7H7UKWr2nCt5VdMwFQu1NVYuW9BaBd8G4JR+p3DI/HILDoJgxsUdtkK
 RaVT+zb0
 cLemqjIZ0hRnTIbh+gcKdnGaN9qBaYzLHX+XomJr7andB3LRJm5UxS3gg7245dL7Oj10WcWxWioszogOn8Zfmx7zyKNWWWGKxZB966toyv20rifLWruj/LcX21c8g2NWJO4ZDo0Qrux9fctGdsfUFO7CqjyNGWai33Y60nxFXqW35GyqRK/Imjn2IJAGOG7+hGLqUicGo+dnyQW2SqHPcIA/kuVfgSh8fyDFz8hjlbZXw+u92BoHPAX8Rs9S3NdGYu4l/fbkiHx2OIeLjpk5Sg1I457W3kO2Nx+qbOLwSyWQulQd/UJYviIbYF7zBy6IR2hDwU11cnou/htA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 18:18, Stanislav Kinsburskii wrote:
> On Tue, May 12, 2026 at 10:42:14AM +0200, David Hildenbrand (Arm) wrote:
>>
>>> +	for (; addr < end; addr += PAGE_SIZE) {
>>> +		vm_fault_t ret;
>>> +
>>> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>>> +
>>> +		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
>>> +			/*
>>> +			 * The mmap lock has been dropped by the fault handler.
>>> +			 * Record the failing address and signal lock-drop to
>>> +			 * the caller.
>>> +			 */
>>> +			*hmm_vma_walk->locked = 0;
>>> +			hmm_vma_walk->last = addr;
>>> +			return -EAGAIN;
>>
>>
>> Okay, so we'll return straight from hmm_vma_fault() to
>> hmm_vma_handle_pte()/hmm_vma_walk_pmd() -> walk_page_range() machinery.
>>
>> Hopefully we don't refer to the MM/VMA on any path there? It would be nicer if
>> the hmm_vma_fault() could be called by the caller of walk_page_range(), but
>> that's tricky I guess, as hmm_vma_fault() consumes the walk structure and
>> requires the vma in there.
>>
> 
> It looks like a caller can provide a post_vma callback in mm_walk_ops. I
> missed that case here. This callback cannot be supported by this change.
> I will update the patch.
> 
>>
>> Note: am I wrong, or is hmm_vma_fault() really always called with
>> required_fault=true?
>>
> 
> No, hmm_pte_need_fault can return false.

That's not what I mean. Looks like all paths leading to hmm_vma_fault() have
required_fault = true;

IOW, there is always a "if (required_fault)" before it one way or the other.

Ah, and there even is a "WARN_ON_ONCE(!required_fault)" in the function. What an
odd thing to do :)

> 
>>> +		}
>>> +
>>> +		if (ret & VM_FAULT_ERROR)
>>>  			return -EFAULT;
>>> +	}
>>>  	return -EBUSY;
>>>  }
>>>  
>>> @@ -566,6 +585,17 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
>>>  	if (required_fault) {
>>>  		int ret;
>>>  
>>> +		/*
>>> +		 * Faulting hugetlb pages on the unlockable path is not
>>> +		 * supported. The walk framework holds hugetlb_vma_lock_read
>>> +		 * which must be dropped before handle_mm_fault, but if the
>>> +		 * mmap lock is also dropped (VM_FAULT_RETRY), the vma may
>>> +		 * be freed and the walk framework's unconditional unlock
>>> +		 * becomes a use-after-free.
>>> +		 */
>>> +		if (hmm_vma_walk->locked)
>>> +			return -EFAULT;
>>
>> Just because it's unlockable doesn't mean that you must unlock. Can't this be
>> kept working as is, just simulating here as if it would not be unlockable?
>>
> 
> I’m not sure how to implement this. The walk_page_range code expects the
> hugetlb VMA to still be read-locked when we return from
> hmm_vma_walk_hugetlb_entry. How can we guarantee that if the VMA might
> be gone?
> 
> I added a note in the docs. Whoever tackles this will likely need to
> either rework `walk_page_range` to handle the case where the VMA is
> gone, or use a different approach.
> 
> Do you have any other suggestions on how to implement it?

You just want hmm_vma_fault() to not set
"FAULT_FLAG_ALLOW_RETRY·|·FAULT_FLAG_KILLABLE".

The hacky way could be:

diff --git a/mm/hmm.c b/mm/hmm.c
index 5955f2f0c83d..83dba990e10a 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -564,6 +564,7 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned
long hmask,
        required_fault =
                hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, cpu_flags);
        if (required_fault) {
+               int *saved_locked = hmm_vma_walk->locked;
                int ret;

                spin_unlock(ptl);
@@ -576,7 +577,9 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned
long hmask,
                 * use here of either pte or ptl after dropping the vma
                 * lock.
                 */
+               hmm_vma_walk->locked = NULL;
                ret = hmm_vma_fault(addr, end, required_fault, walk);
+               hmm_vma_walk->locked = saved_locked;
                hugetlb_vma_lock_read(vma);
                return ret;
        }

But really, I think we should just try to get uffd support working properly, not
excluding hugetlb.

GUP achieves it properly by performing the fault handling outside of page table
walking context ... essentially what I described in my first comment above:
return the information to the caller and let it just trigger the fault.

The issue here is that we trigger a fault out of walk_hugetlb_range() where we
still hold locks, resulting in this questionable hugetlb_vma_unlock_read +
hugetlb_vma_lock_read pattern.

The fault should just be triggered from a place where we don't have to play with
hugetlb vma locks or be afraid that dropping the mmap lock causes other problems.


-- 
Cheers,

David

