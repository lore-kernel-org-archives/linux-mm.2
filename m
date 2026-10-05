Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5207CA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954CA6B0096; Mon,  5 Oct 2026 10:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9052F6B0098; Mon,  5 Oct 2026 10:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B836B0099; Mon,  5 Oct 2026 10:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16A8A6B0096
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:24:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC0EA802B6
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:24:19 +0000 (UTC)
X-FDA: 85288792638.24.75FEE9B
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9FD5640002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:24:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="h6zOtN/q";
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791210258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMpthesKCh920SawTORYa5ywu/5n9CvVnzIRUX0mGF4=;
	b=1O+VwS4Wn2rceggNb7oz4as9NiIoHntppWEJlqkT7okiHqRU3LKkzCH22Ia3Fm3s1OW0Kb
	DaUEx9S7oEsBuVgDn7QtElJyEjOUlze1+mTlReilaK+EzuNCaf18a3+1+0kobCkuan+FfE
	qL5PIDo2qUN34vMokYLrNlgHcWqkrjo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="h6zOtN/q";
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791210258;
	b=x2f1A58tuTqNbbcuiXUXW0r9IhM2eNMkmoF31rUgpV81hwNHSoATy2O4kc2CCDX+kdJCta
	cHPRW53NwchGRqFh5PlBX6v/bhmiRV5GUZOFQSvULNiun0Ahq0GMvwVw9kUNL+qm20PCVo
	umS7+hJQpzOvHRznZQ7ijAt6zwIIX/k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CbENxEWT081LxG9Ca/66oabxXg/6aD0RFXIFh5r/llo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791210255; v=1; x=1791815055;
 b=h6zOtN/qBwuHI80mhLldSlsEthK5OvmsfCxKoEmVv2prrKumZMQj6qMudQmsfYofcg7Jl3EM
 L/j2MfunxfX0R4jcbjOvxnrn6aynQP4GlaV/XAgKD6WmslFoiCAUaIzX7R7qx7D6UigUlZCz6g8
 Ue9KIaQgKfVXdGG8VrRLtjfo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ca78f09690eedc77;
	Mon, 05 Oct 2026 14:24:15 +0000
X-Mizu-Trace-ID: ca78f09690eedc77
X-Migadu-Flow: FLOW_OUT
Message-ID: <b928b8a4-5ec5-4642-ac02-9ecbbbfd6218@linux.dev>
Date: Mon, 5 Oct 2026 22:23:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] riscv/mm: fix soft-dirty migration PMDs being treated
 as present
Content-Language: en-US
To: david@kernel.org
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 akpm@linux-foundation.org, zhangchunyan@iscas.ac.cn, rppt@kernel.org,
 kas@kernel.org, andrew+kernel@donnellan.id.au, rmclure@linux.ibm.com,
 debug@rivosinc.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 wangruikang@iscas.ac.cn, namcao@linutronix.de,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 alexghiti@rivosinc.com, viro@zeniv.linux.org.uk, ajones@ventanamicro.com,
 arnd@arndb.de, axelrasmussen@google.com, brauner@kernel.org,
 conor.dooley@microchip.com, conor@kernel.org, jack@suse.cz,
 liam@infradead.org, ljs@kernel.org, mhocko@suse.com,
 paul.walmsley@sifive.com, peterx@redhat.com, robh@kernel.org,
 surenb@google.com, vbabka@kernel.org, yuanchu@google.com,
 stable@vger.kernel.org, pasha.tatashin@soleen.com, linux-mm@kvack.org,
 me@ziyao.cc
References: <fabd52b6-36a7-442e-9cfb-47a39e4ae3d6@kernel.org>
 <20261005134641.5801-1-lance.yang@linux.dev>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261005134641.5801-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FD5640002
X-Rspam-User: 
X-Stat-Signature: wu9o1es9e7hrknhg94dtumwret6hdygg
X-HE-Tag: 1791210257-6900
X-HE-Meta: U2FsdGVkX18GIC+t2rCJ9cbrAaeYCLQVaHN3QNDXeTUGfXogkqZRtXTA5Z9ACn/jJH3FModhDDUJpkTHCvmqDPsSJisqHjKODNHyEVkHDEt5peUMpYe24BoG7iUOK9tO9FQnmr9CXltq0NonAXbX5J65rmn9TXfSevziN7J17gnQZjOd9TYoVXe6/9bmpF9v064B6xPfd6ONjwdQxnk9aCktugBmZjAKLYL3kbv/YjX2k/QVbJtyouzp0JmDXgm8rrWwhoFh4erRKwE4pd+EWvexPO1Wn1bd5A/JXZBuNxIgyiRG8x1I6PxUfGcjxyIJ0cCFNHGiSg9a2LWC+tlqwXgdnQNoVzZRDzNtS1WmpaMQrpVhmnML+yBTQrSST942Q1Gm6akrC0ukrcShKygNzeWMWFxS48l3r6CfMHjglCFXw5iixUjJaC5+6AkWY5w2E6cB03SvMAKdk6ik0vJGfaqVVSh9vX0QpqCzZ1J+hWUaJM522ga5bu8jQac0YYsYCy+Kv1l6dc7PkRCIjt8yEjq8L0aWlTB2d9g2Bzzuf93u5CkZgdejC1ZQJ7A19bAcHj/7nuzuDTQdW9LGvAfb5a8rlRCUZpCYHGLWlZug9flBfwaFpBqYtg6Rvl3quwMYDsQ3pqz5CNPb8RH05+PqUM7bNxYe4qazTu5MvECXB02fIZo6w2J9Bj7QJFIQtVgNc8DRcsRgwOALRjlMMfLBF/0a41jvB5xLeL+3hG0K/OFkgZOCLNQIzvScazcne01pRp90Zcsh71+r4gdHPf9ZCiJwWePagwCD2HDDLBRVflhV3jP2MmpmXwUNK2FyKWvY1E2sN8vB9R0xNroZNSB9HOPLKHVdJvvMW61Lvpsqkppwvz4O7x0L0/+VcmTKF3oHxGtcr2MChMIIdo5dJlbg2DOIjaYoBYFuxkDaFfVvq1oezcYtaLrdywt/SkjdOqW/yKOdWSIrAJZk8u1NtGu
 ygw3TTH1
 GpYBye+pYa3m/42IPi1gIPpDAdNFiITvFOv8EXCxTrKYTMaJhWSfDknqtrfjPDedbpsjZi9/cKcWCTFAeUQNhsDkvrzxXlKSvkb2Voij4cre3ItuHs0Br4eh8stsEKoyYSVzOnMMfWcNVdthgr9T4nRM5zo3eOVjGtbi2ExmRjoQhUY60JZWT6ewE3Ch41gGanmUALV9h7FtTeUSZYrrjc67loonGBs1mZ6Z1sOvTxKiFDeaMOF+pmMae8rmTHpz26XyU2HPQ0UcMfh/c1Jid0wTKNr7j3H7RLkslyz7/C1Qb+OtQKGDURMJf4wxdrdFMs940RIUbsHp7ioeTvLWm71DLc3WFD+VfXx9ayUopc6GRfb5XrhufnB2hcnhpC/ksDU+ciyRuqZAzaJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 21:46, Lance Yang wrote:
> 
> On Mon, Oct 05, 2026 at 12:37:20PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/4/26 05:03, Lance Yang wrote:
>>> RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
>>> CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
>>> a problem for PMD migration entries, since pmd_present() also checks
>>> _PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
>>> cleared during splitting.
>>
>> I'm curious: why do we have to set leaf indications for non-present things? The
>> HW sure will ignore it, right?
> 
> Yeah, that surprised me too :) Still wrapping my head around the details
> ...
> 
>> Is this a sw problem? Who needs that?
> 
> IIUC, it's for software during a PMD split.
> 
> __split_huge_pmd_locked() invalidates the huge PMD and flushes the TLB
> before installing the PTE table. Software still needs pmd_present() and
> pmd_trans_huge() to recognize the THP in between.

Also, x86 keeps _PAGE_PSE to identify the huge PMD. RISC-V doesn't
have a separate leaf bit, so it keeps the R/W/X bits to identify
the PMD as a leaf entry :)

> 
> RISC-V clears V but keeps the R/W/X bits for that, so the entry is invalid
> to hardware but still identifiable as a THP by software.
> 
> Hopefully I didn't miss something.
> 
>>>
>>> When a soft-dirty THP is migrated, set_pmd_migration_entry() preserves
>>> soft-dirty with pmd_swp_mksoft_dirty(), setting the X bit in the
>>> migration PMD. Even with _PAGE_PRESENT clear, we end up treating a
>>> migration PMD as a present THP! The fault handler skips
>>> pmd_migration_entry_wait(), and a write fault can end up in
>>> do_huge_pmd_wp_page(), where pmd_page() decodes the migration entry
>>> as a mapped PFN.
>>
>> That sounds bad.
> 
> YES, looks a bit off ...
> 
>>>
>>> Move the swap soft-dirty bit to bit 12 and start the swap offset at
>>> bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled. This keeps R/W/X clear
>>> in migration PMDs and lets us keep the existing pmd_present() check
>>> for invalidated THPs. Leave the offset at bit 12 when soft-dirty
>>> tracking is disabled.
>>
>> That reduces the effective swap size (and PFN we can store). Could that be a
>> problem?
> 
> We don't need all 52 bits of the swap offset.
> 
> RV64 PFNs only need 44 bits for migration entries, and actual swap is
> already limited to about 16 TiB per area with 4 KiB pages by
> last_page (__u32) and swap_info_struct.max (unsigned int).
> 
> So there's room to reserve a bit without reducing the supported swap
> size or PFN range.
> 
> CONFIG_MEM_SOFT_DIRTY is only available on RV64, so RV32 keeps its 20-bit
> offset.
> 
> [...]
> 
> Cheers, Lance


