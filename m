Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A088606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UetnZjY6
Received: by kanga.kvack.org (Postfix)
	id 1E43E6B05B7; Mon, 26 Oct 2026 06:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1944A6B05B8; Mon, 26 Oct 2026 06:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083676B05B9; Mon, 26 Oct 2026 06:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D63276B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:47:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 721761A06E4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:47:33 +0000 (UTC)
X-FDA: 85364451186.29.886A3F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B649180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:47:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UetnZjY6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793011651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCm/g3rUcyKZ1+NtoTVxUUIZZdtpcxA7CoFy2Hyn1ag=;
	b=P5TsZkd5xY2GLuGLCCpaB8+h0WztgCjI+CJa4/SJDQnyPEW/aZrQ1PPmXVexDM0PcNHqGq
	8k96n+GGobIrgiBh6sZjDkZfVFKJD7mdxj/fc/HnzBewtN+/ondRxxm5zSh1IQob/SphTX
	jnK9HbkOY2bSOs45qriASrjwXJ69hf8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UetnZjY6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793011651;
	b=FiWlTpnA2vnyHjKgGUWLx+O1hK/f714TjE2FOtqd3ldfUBEERqsMdT5X/9KWKcJUTo/yr1
	5zOmB+yEW2PXte5ncSsF6as5eSu6g/7L2NjIbxlU3G9sr44tm19CWr/nsbVdb0qKS236eF
	rpVx9EzyZu5kXSQcFzsMS9XwhdCgJuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD52840AC2;
	Mon, 26 Oct 2026 10:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8DF1F01825;
	Mon, 26 Oct 2026 10:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011650;
	bh=PCm/g3rUcyKZ1+NtoTVxUUIZZdtpcxA7CoFy2Hyn1ag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UetnZjY6MfvWbi60HZpHtL7Tekegir2yz8Hvdoty2oYPiw/rHr+dQukKtCnGa7hOK
	 5ljeICvZdgY2bxtWFBzEw5EAbtx9lXQQ/A0jQ6FI0aIT9LDsQbN2hdCkpYqmMOT7Y0
	 wh35e//fpN6nmINe6m7AGEn67xiNPOdJf3PJmGwoXIMOKbuyQCPAaRJjetIiAxl3ew
	 /UF7g6huzUt+iwJcYcQ/v4OpK7NHBd3DbbwiHd6hEpvsIPGFol86+9Me9MU2Nb40A6
	 jUdEPVg445d5TTdkZaYaO4q2oXetuHENgTei/3+kW2Vj7ymsGnbsOS/WuaLPL2Nq8E
	 Qv2lI0dXf6rxw==
Message-ID: <190c8e19-d532-4ba2-b493-3510cc785adc@kernel.org>
Date: Mon, 26 Oct 2026 11:47:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: do not unintentionally overwrite atomic VMA flags
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>,
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>,
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-1-8ff4fae1fc85@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261023-fix-vma-atomic-v1-1-8ff4fae1fc85@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B649180003
X-Stat-Signature: fho9tyhs4uxo6rryrzfddgdzdkjsg9ax
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793011651-57263
X-HE-Meta: U2FsdGVkX19H2HK4dfkgVKVN7L/6SHbYaBew+Jq0iDrR81NOWiOqb5QpbPT52DCyJji7QvYtPHFB14nE652XOpELI78CtIHyNtpDaQmVMXOuLnswACFSpk2b3M1ylG3f5RPhlscsf0VRmCHoG4nPzOwnRq2WXthjE6Ea2ZV1UzoZtdYAPWNZtjvwvZlucqk5NLr3OUEK/uYCH42cko4ScWmf8dHivKivtdE9S/wueS63Ty/wyhpRe5TQrVFydimyDo7omGPCPXRX+Z4JPLz4ndgB8ZOikCNvkoMiOSKoWq3JTJLa0XVpj2cPHRpqSfFYXSMTGZ9/CrSRR0tyjZgPYT0YY/VYXxikqSwsDt1FrRIJZkkIfitZ92BGvY3AdzJTK/5puFWsA3x0cj4ZaBX67YYw2JGKpUptr+SvJLhHQtGK70HX0ci0mY1XI5n9A7vahi7fExvyzHImTMSyG14HzV1aWJhXLrPxa7fMZo53oqv7m+mJGjYvqV+KMfkY6G3lzEaaUxd1YuZOe2V8e2QShPkfJNNF67voKamIDqycxqwkNdFujaNxvOgLUswZaxycCn9VhfTVLEmdlIp84L73lJOUVm0D24VJC3LcNBcfdCrhQ/ukqrs8AubrLn0UEmXpRb5OVnUldAWPFKFBhdFvtgIvc5S+krsRnWVIK2S5beUZX477ZCCNEaj7U8DfgBQxlqPCr4TIteoYg6H5yBEvDX60xVP3j55koVWokJ/99sd3vaxpJCQyGzXlm+aHjN6EIY0574BrSI0a8vQDjpAJqBJ1iai2EOZlXlA/dNRbi0UbwN3q+XV5j0bu+rZyyIOC4F/M9eoheBGzaKp1i7f3GrLp50i6SAPzLv+h6AD1kx4OttvsLMZZrvgyzXzUgWueTqeLSExcTNv3OzFYffYPPQbWwyFdkB4fXbcxtTp/DCtcsjjF44/C7cVKzidzPBRGRDeysHPlS9OSXjNj3j4
 h8j9o4C/
 ycNcT8lWFZy0d65ibUW8pA5leUuRwFc3Cvyf3UtNvDXgyMnjNt/qNlhZkqSogh59SV/esqhhOMLiu2jwwiamQj5XAqOj/JFpc2O/xGWR73YDMC7PULibak7cld2szXVw1mJmEHMMnEqQs/vj0m5Nb9njp6Rhnh7YNmpz5qsmimkGhw4Fy+OmUOLs5Fptj1/uPo2sRYYVA9/XvfuhcWwtrtjzf0DkhwSQYHD7QGyI/l+TJty7OFwMOlAQ3zVujhAf8rRtE1/9BWaT3QJt8AqHqUYixpbteDcq5p998IL2d4CJMBEqLpFOE1q08G7fmz6jfJ45m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 15:47, Lorenzo Stoakes (ARM) wrote:
> madvise, mlock and mprotect take a copy of a VMA's flags holding only the
> VMA read lock, later writing it back under the write lock (in
> madvise_update_vma(), mlock_fixup(), mlock_vma_pages_range() and
> mprotect_fixup()).
> 
> This was done on the assumption that VMA flags cannot change with a read
> lock held.
> 
> However this changed in commit 2ab7f1bbafc9 ("mm/madvise: allow guard page
> install/remove under VMA lock"), which allowed VM_ATOMIC_SET_ALLOWED
> flags (currently only VMA_MAYBE_GUARD_BIT) to be written concurrently under
> a VMA read lock.
> 
> The actual write itself is safe as this is done under the VMA write lock
> at which point no further concurrent writes can occur, however at this
> point the stale flags mean that these callers can unintentionally overwrite
> atomic flags incorrectly.
> 
> The consequences of this are significant - a missing VMA_MAYBE_GUARD_BIT
> could result in page tables not being copied on fork (the vma_needs_copy()
> check can return false) or being overwritten on file-backed THP
> collapse (the file_backed_vma_is_retractable() can return true).
> 
> Resolve the issue by always taking care to retain existing atomic flags
> when overwriting VMA flags, replacing the inconsistently named
> vma_flags_reset_once() with vma_overwrite_flags() to do so, and always
> invoking it when flags are overwritten like this.
> 
> Reads are a problem too - madvise, mlock and mprotect all compare VMA flags
> without a VMA write lock held via vma_flags_same_pair().
> 
> This has more serious impact, as concurrent changes to atomic VMA flags can
> cause two sets of VMA flags to be wrongly considered different.
> 
> For mprotect and madvise this causes a useless split, but mlock is impacted
> more seriously as it can result in mm->locked_vm underflow.
> 
> Fix this by updating vma_flags_same_pair() to disregard
> VM_ATOMIC_SET_ALLOWED VMAs - VMA equality is the same as VMA mergeability,
> and atomic VMA flags are disregarded when comparing VMA flags for merge -
> so this is justified semantically.
> 
> Additionally, remove the redundant vma_flags_same_mask() and the unused
> vma_flags_same() as part of the change, and replace VM_ATOMIC_SET_ALLOWED
> with VMA_ATOMIC_SET_ALLOWED, using the new VMA flag API.
> 
> Finally, update userland VMA tests to reflect the changes.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Nothing jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

