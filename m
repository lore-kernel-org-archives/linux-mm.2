Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E075FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9366B0005; Fri, 24 Apr 2026 14:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A996D6B008A; Fri, 24 Apr 2026 14:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9884E6B008C; Fri, 24 Apr 2026 14:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83DE36B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:25:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A0051B7267
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:25:17 +0000 (UTC)
X-FDA: 84694276674.16.CBB63AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39DE11C0009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:25:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DS+pNH2G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rN6rRsyES5tB0N1C5vrXIlkxoR6VT+UBf8tnWAgxbwQ=;
	b=Ib3quoO1DJGVVL00QbO8LiKqGITfuZ2XxcDvX1McAJDO3BbpkuOUwVXW9h4Qj6gvHx31NW
	PxwhLE1GJRlSHV+Pm7AGsvtaXlepk27xSViCjUrB3RpVtaOlLtxs6Q6ogOW3llodhH29Wq
	UcrwGFsGRmhr5Jmh6wcdppm6OvPwmk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055115; a=rsa-sha256;
	cv=none;
	b=J4ZDmpMjuFLbTCAFhIs/VdctNqI+0Z3nVpFNncXzNla5hmXAzSYBxe4TCKKP1GPn+6yFAD
	DDURWDkUb6efiJcCPTNUg7C3fSGe+5ruOKSaZ7bcpeB+bw5JiJ+R598I2ktgmMGWVrjljb
	gk6IJfDp1+0RVqLJhHNWtVnny0Hz+XI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DS+pNH2G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1706C40678;
	Fri, 24 Apr 2026 18:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE42C19425;
	Fri, 24 Apr 2026 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055113;
	bh=VQ8hc4BwTuKlIp4qUFxYLXF10OdTQNZ5/iYxWI8OxTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DS+pNH2Gna3GmmRZk5v6dwoylCMW+dpIGiyjbNZh1ct9dAV5WF+vIcU/LpL5fbY/2
	 r7R4VRcLKeff6SOcj+UVJiuKYflC+gbRoi67Fo318gJoWdW3Q97/CHixa7+6Msnzc9
	 ORjaJfxjcJseTT//flNRI2mthEf5Eia9fmWoq+DJ7Tu8GhI3VZvxbToeEgggn3IliU
	 eomHmcBeWb5au5TSZqs4NKzuuUnpLUzB+CaHd4k1UKJKV/Ng2c3DicI3Pv3w8k8878
	 QScUER8ln3uXO/b+b/ralZya/ime11G4HNK+DxPhDD0NtJMNsgHtBtqv7AC8IfVkg5
	 FhT9vRuNiOLvA==
Message-ID: <b3176027-a1b0-4aea-8401-18cbdad9bc44@kernel.org>
Date: Fri, 24 Apr 2026 20:25:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
To: Sunny Patel <nueralspacetech@gmail.com>, akpm@linux-foundation.org
Cc: apopple@nvidia.com, byungchul@sk.com, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com
References: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
 <20260424173347.44621-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424173347.44621-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 39DE11C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: 6e3jsdwsinatma196titq8amt4ebdttz
X-HE-Tag: 1777055114-171664
X-HE-Meta: U2FsdGVkX19Zk9/IWRSOB1rfNfwM3x23LefGGal6/XcBsWrxTw4FZGZ4jdjjYs05aR/17W3YpRelDoR/EhArhwWgjJJSt6xLMqye+WUC0gUg33YhBEbg/H1iPJSWBdIlN56Hv3Vv6FIPJI9dPvEor1kxtS1su9riixMr+LGmNeqAxGlzRUxeymvFpXdYvw0HSfaAyC55Ws0F0zxZbfhIZePuDMYhIa6eRjajz0/50iAF+goUHe3D0c6MrgygDC9DDFw509OzPOM8C+L/xESrpXf0Wf5t3/Cavv8lqSR+YMVslteWurk401tzKZglm+X4RXwmnkhz8yxtG2dV9EiJHkReI8FrnZ2OZXV6U7XfZ+gElp5BSlcgymW2q8ZYzj0Wck5n/EBqz82xvPtjb4IDKI5obTSctN+c+BQg/UrqKxReXp9eOP+82gJ3DuODWcb8uuWebBDxFFkEcrm81G6r357AQ4dPUCLtt6wS6RfJmzXR0Rl7jnrGvjIDTSqwrAaFn0M72t491iMrwHIeiAL24f7cvFgi4bJImSQqGtGOt1jy7ZCm9LRRJJWX6ww6zHmlkl1xWXOKZQ7Yp9iGTQAILPjkqtRAqwIX61IE/qCHgLhmxvVMiS4fI3KMHiyv3GO3z8JeU8qhNp56g+UaImPYuW6O3JRSANPukhk+OjgiMNF0J38C0V95UqDOdlGxSFwB81Xj+IxaaEUonIJUhhsChaZaWIfmlIu/zMhTfMS7kbedSO8TvS4SNfXUClVCrLF6UUfPyNkMXOwF/KCfM00WeAtcgAJkfYFGRF50EUZdRLzU5tZ+Tp5JFRX5BrUAoPIX8+IXQi4J0kMOsI+/QM9HwOBQcnQyRVX/JHxB1PPffAXcwxkP2rKOSSM7RXKeizwM+qVJ+2wZOG1IsLFgdmwUSNAxU5vm1hOu/b6FGVWSRQFkUnUgH/0TpbenLHNCkI1RX7gAh4rxSrjh6Sb5PxP
 2F5n3zyC
 E4UIXU4SY4/nUSJq77VcZzehr87dwaT6Dn0mPLZrnI77EOoZ7YAoXuvI5xRUEvDAK1WaQX1GXlS+AT+N+8m0mrZwrVfXdWhVLegD/SOD84bc32Vh5f1fV/hj3r/9Dt+Dalwv9jfGsfBLnYmNVq2GduB3Kev0QwMgemJEVFpvd1m1vvc9+PVVfKv4DCw3MnURkV6jeDR7vaxIrFTQOLHXAb8X70mrRiYy2AFUdgW0e98K9db+3nXF3bxcwA3/A6YdbeIPoWwm7xsONxNcObu79RnHAapJyK4TRbBm4UpeXafcGK04COk4jEFoW4PLjTleMHNZUH6i0UW8NymNx+ENF+FaNwEvEL1GScFZpBdH2XU43EsKc6Hox9dGFWRdwmWzTujexqyyWE2gmWlzJejBq2kLmwqVcoIBHOJPJev9Sg2jiUbibPpSy32yU9Q6wZKxL3BODZkN9erLH2TU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 19:33, Sunny Patel wrote:
> On Sun, 19 Apr 2026 23:17:43 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
> 
>> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
>> with a simpler VM_WARN_ON_ONCE(!folio) check.
>>
>> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
>> !is_huge_zero_pmd(*pmdp)).
>>
>> Refactor the PMD checks, making the control flow
>> clearer and avoiding duplicate condition checks.
> 
> AI review might have found a bug in the surrounding code:
>         https://sashiko.dev/#/patchset/20260419174747.10701-1-nueralspacetech@gmail.com
> 
> NOTE: Ignore the previous message was sent on different 
> Subject Header by mistake.
> 
> After looking into the AI comment found two potential leak.
> 
> 1. The goto should be unlock_abort instead of abort to ensure 
> the spinlock is released.
> 
> 2. The pgtable allocation at the top of the function
> is indeed not freed on the unlock_abort path. Will add a
> pte_free(vma->vm_mm, pgtable). 
> 
> Since this patch is more of Cleanup on PMD checks and
> Warnings Is it ok if I send different patch to address
> this potential leak issues or need it in this revision
> itself?

No, independent issues -> independent patches :)

-- 
Cheers,

David

