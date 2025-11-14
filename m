Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A65CE7AAE
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4C98E0007; Fri, 14 Nov 2025 06:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC798E0002; Fri, 14 Nov 2025 06:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9AB8E0007; Fri, 14 Nov 2025 06:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B80B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:07:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECE41886BD
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:07:06 +0000 (UTC)
X-FDA: 84108935652.08.D2D496C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2A1AC40011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:07:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nfgtP7iO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118425; a=rsa-sha256;
	cv=none;
	b=AQfc5bskdm0uaEGO54HuR1mEpvP0J/7dqB1ujNLJ83J5BiwUeJ1fZIl/v/1q3SPtYyjKIr
	9DHCrIUt2IPC+fbotufjhw6pQk0T+0Ztmyr47tS8XgYqDhsyRN3d8+Os31/dvTQ2aZsoR8
	UJU3LoeQER+dsxrtmIBsinVbo7xomQo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nfgtP7iO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpF7ogK/caVBZEXCOMBpaXj7HQqfP1+Mh24kf2UcGJU=;
	b=ehEv5uWhKKWqyWo7aI3kUvs+mOAFiDOnHzdwR+NcW7s/SRlS8I7BZqnXCgRVglNjGQB2Pv
	QG5hOzvYc7MOQgJ5W0xbpIqNQV8e4dJNlWT082G5yV5b9vf+HVCLPjzAN7wT3HwD/XgU0O
	o3ajwckMmfZ3Cky2dl3csSozUjF+Qic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C2AE438BF;
	Fri, 14 Nov 2025 11:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C34BC4CEF5;
	Fri, 14 Nov 2025 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763118424;
	bh=Ld25Z6bV94GxcOfQ4cSv39KO4Zh49TFp9Q2zSOzNfAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nfgtP7iOLYmEMkJL2Rb/c6ZvDDySgHClSdxhBjinmvfGgWvK26v5Yss6zoUP2dfKV
	 QSYkpYYtCgHkiacxtGvne/V2KdtHk/kmy9cVGrwDyfyIyx1UKP6c3TqrUExIJwV6xa
	 Yg8+J+8m7hzJu94XYaqjBxtMWpPZZXDICBXVCzDRxPLiKmAsB0P3V3E9qhUHIh65RZ
	 7g+zwwLyXMJlt4ZaFdBQCjUWiZiyKR0xdkuqvAcSQI7Vo4PndGOILhzCdZvNnAsFmd
	 DCBmwpTis3enR+FHtxeU8D/cQ2ClcZ6unhbG0xVC2v4uenqNTW9P02+MO7pVxAJvoM
	 0SCXy2/NJmuZg==
Message-ID: <ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org>
Date: Fri, 14 Nov 2025 12:06:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 6.1.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
To: Harry Yoo <harry.yoo@oracle.com>, stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com,
 pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
References: <20251111071101.680906-1-harry.yoo@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251111071101.680906-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A1AC40011
X-Stat-Signature: nwii1wuaj84mc9tyf74dkbyw7g6g446i
X-HE-Tag: 1763118424-714361
X-HE-Meta: U2FsdGVkX1/YaZkh6fyKKeltCHYNJ4f4r8V0Rlh4htzLAFEtl6Bm1uJxCtbfOxwdNaITSTqQo4mLF+k7tHaf1FLvXFyRWeGxivU6nksF+7n2QDWNTiNSfJZdoco16QC7D41wTTpKIArvQY3qFwZ1Euz2gBjmWTd0OLUUY3iqXacFPLyFm9AwRN6sFWuxY7PBs4650SLQn5twtHOksk/bKrr+ZXl5ISbll7OyCBZrX0Rh/9okKos7l1wqbji+aNL5HUGI+nza3xmAnfTEC9im0++UMBrHyq+WWkhG25ufyAzOQ1LE0nubhTJJdA5J8cwvDlit8BpJIFh/p43skcU7B8BK7pnQiMQk2WC6p03XqlnFzku0+B0yaVIKFUHJy6uhNQ8CSuQ3Mr++s5vKjDNC9T4hadBjT3Ui/sI15LHANB5+egHOjuowSr4Bs3BwM8fRc0AxnZi7adMPs1LBvodRd4iBq1ae19Dfo12jpJmSCdjjiG5Eyg76bkx7TaU89FjgObMpvP643t+KBjHzjo+5fdtUx9ntvo/hPNGOBgOj+gSAaRtlBb4fTrpW1fVYnq71pl5cCNSxK+F+LWoNjYChnuVAx1vL4OHaOlUhTFY10DtMieKMXbx6lHoo7Ir57o9OqzM4S1/w0pl0XF9Ee8jSP25zFKQqMdcdulRB8fQrD8GdegS2ZOE5ZWQsmWkZg2KQokOIdyOp/4jWGu3X1Eqrz0ldfvz9we5R6xFdJ3QACkTEch4uRErSNbOGS+HYu+j3v0QCRAI26zv/kB+meO8yAHNJIJZQACVU8QlofVla4MQqFIXRW6DJYBub1mPJWXy+6k9dvHd0vx6CPSxM62rqTaR7oyP3dDNOErYdVlM9GF03bEJWilaYdDSsS0PZ2HbNEKOmlD3KO9ruj3CzZJCUq6VKfBoQWU6FBx5ly/yTLjrpOm0sf6K3LbDbX6mBUxhVanUCdtPX/h1pRlV5tTu
 /KSdc6GX
 WXbRYKhefjt4f7xTGs2DopL4INn1QMslNyCRd8h9FDg9xYpm613iEgFHcXLKEUla3Y7GMkepd/QUxEdYadTsdq4IZ2Vq1EqnnP5aP+4reFW5we1kdQz+enfKvbbIcWnWVKPg1mXqs9ICtPnakIhsLnt8AUcRbBJ6ZftKzQHoYb+5eivhNgNXZo+4ocppSPg/jS4RDATVFehiJBUEIrtky7sqVdmasE7ztwxI+PepJeR6g4FmdMiGhiuX/+Z5Bt0gM2XRN00Irc55vUPz3jraPmPbdsf0k3N6zjHzQY27qnWYZIV29H4PELtpdk+KBj7mD7XacIL2Fd8956bKBtd3fbP8exLMr9m1ewOvF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.11.25 08:10, Harry Yoo wrote:
> # TL;DR
> 
> previous discussion: https://lore.kernel.org/linux-mm/b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com/
> 
> A "bad pmd" error occurs due to race condition between
> change_prot_numa() and THP migration. The mainline kernel does not have
> this bug as commit 670ddd8cdc fixes the race condition. 6.1.y, 5.15.y,
> 5.10.y, 5.4.y are affected by this bug.
> 
> Fixing this in -stable kernels is tricky because pte_map_offset_lock()
> has different semantics in pre-6.5 and post-6.5 kernels. I am trying to
> backport the same mechanism we have in the mainline kernel.
> Since the code looks bit different due to different semantics of
> pte_map_offset_lock(), it'd be best to get this reviewed by MM folks.
> 
> # Testing
> 
> I verified that the bug described below is not reproduced anymore
> (on a downstream kernel) after applying this patch series. It used to
> trigger in few days of intensive numa balancing testing, but it survived
> 2 weeks with this applied.
> 
> # Bug Description
> 
> It was reported that a bad pmd is seen when automatic NUMA
> balancing is marking page table entries as prot_numa:
>      
>    [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
>    [2437548.235022] Call Trace:
>    [2437548.238234]  <TASK>
>    [2437548.241060]  dump_stack_lvl+0x46/0x61
>    [2437548.245689]  panic+0x106/0x2e5
>    [2437548.249497]  pmd_clear_bad+0x3c/0x3c
>    [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
>    [2437548.259537]  change_p4d_range+0x156/0x20e
>    [2437548.264392]  change_protection_range+0x116/0x1a9
>    [2437548.269976]  change_prot_numa+0x15/0x37
>    [2437548.274774]  task_numa_work+0x1b8/0x302
>    [2437548.279512]  task_work_run+0x62/0x95
>    [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
>    [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
>    [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
>    [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
>    [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b
> 
> This is due to a race condition between change_prot_numa() and
> THP migration because the kernel doesn't check is_swap_pmd() and
> pmd_trans_huge() atomically:
> 
> change_prot_numa()                      THP migration
> ======================================================================
> - change_pmd_range()
> -> is_swap_pmd() returns false,
> meaning it's not a PMD migration
> entry.
> 				  - do_huge_pmd_numa_page()
> 				  -> migrate_misplaced_page() sets
> 				     migration entries for the THP.
> - change_pmd_range()
> -> pmd_none_or_clear_bad_unless_trans_huge()
> -> pmd_none() and pmd_trans_huge() returns false
> - pmd_none_or_clear_bad_unless_trans_huge()
> -> pmd_bad() returns true for the migration entry!
> 
> The upstream commit 670ddd8cdcbd ("mm/mprotect: delete
> pmd_none_or_clear_bad_unless_trans_huge()") closes this race condition
> by checking is_swap_pmd() and pmd_trans_huge() atomically.
> 
> # Backporting note
> 
> commit a79390f5d6a7 ("mm/mprotect: use long for page accountings and retval")
> is backported to return an error code (negative value) in
> change_pte_range().
> 
> Unlike the mainline, pte_offset_map_lock() does not check if the pmd
> entry is a migration entry or a hugepage; acquires PTL unconditionally
> instead of returning failure. Therefore, it is necessary to keep the
> !is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() checks in
> change_pmd_range() before acquiring the PTL.
> 
> After acquiring the lock, open-code the semantics of
> pte_offset_map_lock() in the mainline kernel; change_pte_range() fails
> if the pmd value has changed. This requires adding pmd_old parameter
> (pmd_t value that is read before calling the function) to
> change_pte_range().

Looks reasonable to me, so I assume the backporting diff makes sense.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

