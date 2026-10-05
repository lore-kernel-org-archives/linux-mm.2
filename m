Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009AACA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 13:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0326B0088; Mon,  5 Oct 2026 09:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90F36B008C; Mon,  5 Oct 2026 09:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7036B0092; Mon,  5 Oct 2026 09:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9996C6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:46:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D04C14027A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 13:46:53 +0000 (UTC)
X-FDA: 85288698306.09.FF811CD
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id D09371C000B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 13:46:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tx0L2iTv;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791208011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+VIsiqdBfhERbl/ljmwWMiBNflFUbgtYvnly6hHD14=;
	b=OJ5YVteghK6386VF1p0HLvRxLC9MtHb70zyzEyRBKzo74pspaPekUbOV+HVqFISa/w15Np
	pwSs/Y6wLlM7LOb89gpwVVaRQ892HfY96YU1mOw5U9CrWy1xaSWiW58MzT29CriCzaooMr
	pjR6Ubs/2lUtnddQse9jXflxYRkdTCg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tx0L2iTv;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791208011;
	b=be5Xj6CpIR2+ZbzzEIW2ys1U+GyFIheJpD/JJb1oM5KL7VjTzsA++T9EGsHD/0UTIG47qQ
	uFCnGjr463OdCuwKst4vfTYi2TWeJzBpERv9c0LFyWVX7cDqMGU48M4j0bLKwA6mix566T
	yRlCxWW61Gw2Fpjn20+8VMVJGTVXdMo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UPW5rxLXXCUQyxl4itU7Omf05ILDh+oFB7ALgw7XWYk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791208009; v=1; x=1791812809;
 b=tx0L2iTvL1t4Gc/ZauTkCdpHFTdtsUKl8VPxSamBBRMTVwXZ5qqXopDuGeJG4ImvGBpQ9j5S
 +vGxW1iw07Lnb0rcg90dbiqvRzPH+Dp/22EmpQXX0xvY4VM4aGH8mpzWGd6EZYzx/hk5JlnatTg
 yJtBUGrVEm2BY2B+LAGWpIto=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2868cb32e0b71532;
	Mon, 05 Oct 2026 13:46:48 +0000
X-Mizu-Trace-ID: 2868cb32e0b71532
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
Date: Mon,  5 Oct 2026 21:46:41 +0800
Message-ID: <20261005134641.5801-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <fabd52b6-36a7-442e-9cfb-47a39e4ae3d6@kernel.org>
References: <fabd52b6-36a7-442e-9cfb-47a39e4ae3d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D09371C000B
X-Rspam-User: 
X-Stat-Signature: 37ydzqduyfp3to9nco5btkauqmm8h8qx
X-HE-Tag: 1791208010-41215
X-HE-Meta: U2FsdGVkX18+vCFbwY+7M+4TtmKYw9BhDWqIOghw64TGjhpuyPtseXAy1H7BZx8O1RZ556oIZRs0VQDTmAAgu04eNYwrnJRq7DlNRiiQ0YLgr/EXoJZB+1S/HOucTLsIxpxdxTqaNgCcOcNZWBvJqBkHxbIB+NRMMyyEPi7tpK78RkIlWg35nd6qD4tiQ/6WZSUXJMTyLXq+kk2Qm7YbLvnrx0miqCZA8h4GjiyzdqDIVP1+0txNgD9NzCnMVfQ+zYFhHdLn4unMQhW6TfeHuHNpAJJyqsImc6rw5LZgkafsw0JzLDTG6tcq6lJT8kx/BRRfYGEMhzb4gyWQalFkob4Un9uUE0q8vACTlwOkTw8dX0xSqpigHQLGTp/lTya6Y8vlk2LPJJUma0G+XwtcgsO9pIMrS238A0yDIA96KW4Pd2lhQC1Hm18wJSY1isJnyMqlQvoMyqC6ntRS6iowJZIxmZlcaAjUPe1rJRBTNjP02s+l5/qa0A0uo96hmXq87YjjGTNAdirHLIXE5GkjAzQzcq2ilww5aj8Mo2H4nuRZt7GUIkoWmaIjh1UWehSzMQYEEM2PbNiitpBnqgkYQk+ytAf+kBnffdnzFvI9ukKkbL0Y2tsFvi6VVQzTseL0WHOBy7WQosEQ7eL+1kc+/02yPrHwGATO0OF+3YO5yTyP1RsbS8PId2nkjw1uZ51vOSP0h1yCj2A58BK3JDeutsJ2dlx5tusNTcfQypO2GkU6EdIz0gCa8xkYls6cJFr1x1i/OPX+aaPU/JsrJsv6xyt2s/RJwECjDELYiRlKGrPalpN5GDTTS3lZ+r49V+LM3djwmc9tZ6af74H9N1p+QrDl3BJd9A27jzEwP6eEZb7C38LSUJRIBypJ7GfUoBoGj55zUFgJlxMM2kWnuThxWquHobuMdFgcAJVUlOfy6Oie9IaPNH9BIARhw4mSwOYC4Y7fso4tX+KFxJIdyTH
 5xeQBjJH
 tyZFyckEBGWG7p+AElZDSITP4EotOGFjVZg0Ki1+J9DlQCgICPmLNPc0DQbpKmNVxWD0seve6jav2wVQK922dIAG4StmJAGCb1yIkgUxq9lMh81aOmLMTUcMeG1TrfGi7DBsX/xP0am4ks89+EiGFNzFFB+L2Ookt/mVnuA3Cn3sNRqkLN4yKxn3wD2tgsxQ7OLEz7gQiqb+i4OvDvZWweUeOSjAjEaEn8xPUnLAuBN2MvV5Are4E5XVv1Kc8im99xxC9tk0d/0b6z8XZhtk68rJzG8PvI0bEdtJrjVmUuiUEBcm9R5X1Qw7HiMPW/NJgzGrWpDCytfEJKEnWb3JWksYL1/BTJP2ZRf4W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Oct 05, 2026 at 12:37:20PM +0200, David Hildenbrand (Arm) wrote:
>On 10/4/26 05:03, Lance Yang wrote:
>> RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
>> CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
>> a problem for PMD migration entries, since pmd_present() also checks
>> _PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
>> cleared during splitting.
>
>I'm curious: why do we have to set leaf indications for non-present things? The
>HW sure will ignore it, right?

Yeah, that surprised me too :) Still wrapping my head around the details
...

>Is this a sw problem? Who needs that?

IIUC, it's for software during a PMD split.

__split_huge_pmd_locked() invalidates the huge PMD and flushes the TLB
before installing the PTE table. Software still needs pmd_present() and
pmd_trans_huge() to recognize the THP in between.

RISC-V clears V but keeps the R/W/X bits for that, so the entry is invalid
to hardware but still identifiable as a THP by software.

Hopefully I didn't miss something.

>> 
>> When a soft-dirty THP is migrated, set_pmd_migration_entry() preserves
>> soft-dirty with pmd_swp_mksoft_dirty(), setting the X bit in the
>> migration PMD. Even with _PAGE_PRESENT clear, we end up treating a
>> migration PMD as a present THP! The fault handler skips
>> pmd_migration_entry_wait(), and a write fault can end up in
>> do_huge_pmd_wp_page(), where pmd_page() decodes the migration entry
>> as a mapped PFN.
>
>That sounds bad.

YES, looks a bit off ...

>> 
>> Move the swap soft-dirty bit to bit 12 and start the swap offset at
>> bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled. This keeps R/W/X clear
>> in migration PMDs and lets us keep the existing pmd_present() check
>> for invalidated THPs. Leave the offset at bit 12 when soft-dirty
>> tracking is disabled.
>
>That reduces the effective swap size (and PFN we can store). Could that be a
>problem?

We don't need all 52 bits of the swap offset.

RV64 PFNs only need 44 bits for migration entries, and actual swap is
already limited to about 16 TiB per area with 4 KiB pages by
last_page (__u32) and swap_info_struct.max (unsigned int).

So there's room to reserve a bit without reducing the supported swap
size or PFN range.

CONFIG_MEM_SOFT_DIRTY is only available on RV64, so RV32 keeps its 20-bit
offset.

[...]

Cheers, Lance

