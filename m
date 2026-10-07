Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83224CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9986B0088; Wed,  7 Oct 2026 07:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263A76B008C; Wed,  7 Oct 2026 07:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B1B6B0092; Wed,  7 Oct 2026 07:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3C606B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:34:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E025C1C10DD
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:33:58 +0000 (UTC)
X-FDA: 85295620956.01.0BA07C7
Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	by imf30.hostedemail.com (Postfix) with ESMTP id A7CD48000D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:33:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mzlRK2Wn;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791372837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIewahHF8fIha4hwTi0W8OFo/xh61yrtn2yGGIcG0gI=;
	b=MXbXoGDKklwYKWM93qQuvBnkDSIr6QqfFjM8rjs/N9Ha3H4pnwyps00bh9fdcLhecmbLUK
	Klb/pd8nrmyOe+A65Cju97ZYsRmQJ4aWL6Ad84d9ABovzioAf9G9v5jkV805O3zcYSMa1K
	lowcAFOY3ITiCKgA3CMJlMPoRSXt9zc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791372837;
	b=GzBMhIMCUV0PrhvLYZ6qsrwzr6wisL48CVxfr44qwt40dwiRxdSaoE9ytn4zo7H/1GC4is
	84Ns7Nwj3STpAn6qJz6N9hsJoi3IKE0/KVhz90ETv0tgEsmdHTyk7JPvwTPnHJp+8jX6vh
	utmVIUJyppv2xHgZ1UKyO4ALfeZorMc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mzlRK2Wn;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VQVhQZKIl4zNDQJKB9bVX5VumbsxMCs4+iJKLBdZmkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791372835; v=1; x=1791977635;
 b=mzlRK2Wne3Jl3AjHi5WznBZZZa1mbNjXgzL6EkkByUXq92CM6SFCLthWfd4Fvc3d4z/BTpCP
 WUOD0sX6IUiZTPAu3KFfvDLCfKSD562lRW0t4qbgFRAmak8IECLfDD4mr67y/B1s70m3UOchhLC
 q50oM+2Uex1a/zpy8ZzRwImw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aa4fc3b16c8ec0d3;
	Wed, 07 Oct 2026 11:33:54 +0000
X-Mizu-Trace-ID: aa4fc3b16c8ec0d3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	zhangchunyan@iscas.ac.cn,
	rppt@kernel.org,
	kas@kernel.org,
	andrew+kernel@donnellan.id.au,
	rmclure@linux.ibm.com,
	debug@rivosinc.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	wangruikang@iscas.ac.cn,
	namcao@linutronix.de,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	alexghiti@rivosinc.com,
	viro@zeniv.linux.org.uk,
	ajones@ventanamicro.com,
	arnd@arndb.de,
	axelrasmussen@google.com,
	brauner@kernel.org,
	conor.dooley@microchip.com,
	conor@kernel.org,
	jack@suse.cz,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	paul.walmsley@sifive.com,
	peterx@redhat.com,
	robh@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	yuanchu@google.com,
	stable@vger.kernel.org,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	me@ziyao.cc
Subject: Re: [PATCH 1/1] riscv/mm: fix soft-dirty migration PMDs being treated as present
Date: Wed,  7 Oct 2026 19:33:45 +0800
Message-ID: <20261007113345.32755-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <69c33490-e5a3-4cf2-a5ed-d2bc8ed336d2@kernel.org>
References: <69c33490-e5a3-4cf2-a5ed-d2bc8ed336d2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7CD48000D
X-Stat-Signature: 3adpnaf6e87dnqn3zbeds6eytccyji1o
X-HE-Tag: 1791372836-804733
X-HE-Meta: U2FsdGVkX1/y9dd8yJxGB+APqio+iT9tfvzu9Hsm7RY31Td8snOEMdPIbsb+RL1xFO3+NyKKWIg1sWwdyxUsXe2xwvKjXJgIXvWZsHOns39I28AWlDCm9HUQ/dBDQWxEhM3jIods/v9ujo3QK7ozUF1lGloDKj5UI3OuV3xwbQBdN5fFumUY5VivkFVtU/AYI2KKPYN+uF1+qiIZJo8gFHvsBzGN7HrOCIEh7qEz2Dc+j0ke7vLWj6N22Rxkj6P56BrFZ/MBr1zJUdpmkWcnOdqqkFk13PTOlNdsDK06R6y856n0d/nZoOX0WhlGRRf6XLe57j9MNeiCHEbTdcHc2ByMlo0os8P05Zgc3vA99vngvhOb1uA5ulTYniq2hvx5+sJ9+V8sLLaA1K9W3r4o8yxfiNmSOh6FC1OEnJ6xaoTOcCEA0slHSbGpj1HUxfN+zKpYvzRcbguizIsONtiZ+uZog8zM1MZoVzZA3nEJIcI64kicskad3BvHsXdSRx658nxSQEOfS+px8kVvJSrWzyjy0bXonpbP+pMFkzl6IefU1HVN6pGaBfmCdHQAzvj3fVtFIv92qJ2sEzoy/czOL47eET5apG0udSr3686TO7xFOmEEAkFtdyi1TKh2r5Vk3XAfjsZXu/xzL695tTxOiiIU15OwJIN5iiyfAyALFXQEquWXsqyKSt74JzrllLWbpuOaZtvduuSLV+CqxBhwRI11b7u2dK4NuU+KQ8T7EHHCw5oMAUrbnRglVK2myejt+Rt7+6xUDwCmwKn3cn46mFoAN9Chntj3Nktdffbe21qgkdMUovtnfanoISbx+3yK6XkbHqcrZ4CJ9IHlvgA2zSn9hN7jC7VW83dPRfMLrlDcoXyUw1/I0OtHjSSbwA9nGLQQQYcNycMAPM48U5l3ndAUJZVBrBVl9BL0WzAFrawCh3ywHlTA2zSMNqPbsnKLyVmQBaXvPrfljcCNdln
 mgLYc7dS
 N9Rr6n5U5RKcmAIdDIyDc0ZpKr5S1gFl84EnLAiRnxJwus7CW+h0rXUD/sqYyiMe+VZfE3ZPKnNAEMoGphAOT7NVERDJMCDWuSTJWc2w6Ccc8lXXWgRvXhQCZvgw9LgSUQsEtHar4JhTpiI9Vr3Goo5N676d31GdEbAVVvsggkgi0K5ysHdxFWJpasyQPrpuf+ZLFAxi5KBhbCy3yuNxxwaK0gu0RVgVi3fFrTfAo0WJMv+m5uroya+elfrzxwy8/WrHWf8+7zukXZPXlAnGUmLDZprNkZoWtyD3tL0zJ8LFtOh8cKDACrVRV6zI76ysELu2S4WE9LjAoCiqDaiLgnklE57NxRZUreeDt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 07, 2026 at 01:01:14PM +0200, David Hildenbrand (Arm) wrote:
>On 10/5/26 15:46, Lance Yang wrote:
>> 
>> On Mon, Oct 05, 2026 at 12:37:20PM +0200, David Hildenbrand (Arm) wrote:
>>> On 10/4/26 05:03, Lance Yang wrote:
>>>> RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
>>>> CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
>>>> a problem for PMD migration entries, since pmd_present() also checks
>>>> _PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
>>>> cleared during splitting.
>>>
>>> I'm curious: why do we have to set leaf indications for non-present things? The
>>> HW sure will ignore it, right?
>> 
>> Yeah, that surprised me too :) Still wrapping my head around the details
>> ...
>> 
>>> Is this a sw problem? Who needs that?
>> 
>> IIUC, it's for software during a PMD split.
>> 
>> __split_huge_pmd_locked() invalidates the huge PMD and flushes the TLB
>> before installing the PTE table. Software still needs pmd_present() and
>> pmd_trans_huge() to recognize the THP in between.
>> 
>> RISC-V clears V but keeps the R/W/X bits for that, so the entry is invalid
>> to hardware but still identifiable as a THP by software.
>> 
>> Hopefully I didn't miss something.
>
>I thought some change we performed to GUP-fast wouldn't require that anymore.
>But my memory is a bit vague ... :)

Yeah, I'll have another look at that :)

>> 
>>>>
>>>> When a soft-dirty THP is migrated, set_pmd_migration_entry() preserves
>>>> soft-dirty with pmd_swp_mksoft_dirty(), setting the X bit in the
>>>> migration PMD. Even with _PAGE_PRESENT clear, we end up treating a
>>>> migration PMD as a present THP! The fault handler skips
>>>> pmd_migration_entry_wait(), and a write fault can end up in
>>>> do_huge_pmd_wp_page(), where pmd_page() decodes the migration entry
>>>> as a mapped PFN.
>>>
>>> That sounds bad.
>> 
>
>[...]
>
>> YES, looks a bit off ...
>>> That reduces the effective swap size (and PFN we can store). Could that be a
>>> problem?
>> 
>> We don't need all 52 bits of the swap offset.
>> 
>> RV64 PFNs only need 44 bits for migration entries, and actual swap is
>> already limited to about 16 TiB per area with 4 KiB pages by
>> last_page (__u32) and swap_info_struct.max (unsigned int).
>> 
>> So there's room to reserve a bit without reducing the supported swap
>> size or PFN range.
>> 
>> CONFIG_MEM_SOFT_DIRTY is only available on RV64, so RV32 keeps its 20-bit
>> offset.
>
>Good, can you spell that out in the patch description?

Sure, will add that to the commit message in v2 once I've heard back
from maintainers :)

Cheers, Lance

