Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 780BACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F1D6B0095; Wed, 14 Oct 2026 03:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5578A6B0096; Wed, 14 Oct 2026 03:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F036B0098; Wed, 14 Oct 2026 03:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10E7F6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:56:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0B314044D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:56:25 +0000 (UTC)
X-FDA: 85320474330.09.9D487E1
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4B9BA0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:56:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KgfDKtGl;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791964584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3+Wge0kwS7IwF5RKEI33wHVeSTwsUI9t9OYcmQ3Cl0=;
	b=5CmYaA2NYnxBrlxQZhotKW5ZI1WuQ+YFCW99ByqL3Gs/0mdsxJBa6tJK5Cy6ne8pXZqoKq
	Yu6dWBq0GRkmfsq5lRmKZttol4+9FpBxz3TxKmrZ0iE/Y1W2hM+nzmaJu0VtGv6k8cWeWV
	/hW8FKBBQ0YBM6tcvuw8voJYD9ofZxA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KgfDKtGl;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791964584;
	b=Sk1vfJcnC+K2Urb9QskgiMgpkjIW4T9haOxdHgUOyCzW/kVVA4zxfKAKGitZeYge2hDD9s
	Mue5gRjmX08ssKx3WgcQdwOZtA+0Y7LqPia3StD/cEIXjqkmH/P8vSepAUNpAUZIj2jNvn
	Ie/3Rq85axxE/7eH7dZ7SLPKzK1clrA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3NakkYm+exfqHeo87l+Jy3RJZBZS8mbhTiQS6F5ENvk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791964582; v=1; x=1792569382;
 b=KgfDKtGlnya+w0y+13eDfqGYwadeUvStcnSjdRAXRZPy/w4ajj0Yu1rBDQ1hqaulwiQkV10G
 TBiORH9tEtm52K4jwFva0QEuVVFkuvUSmTzHiLNz9qiE/zk15Gsg+ZFlKVkSI9pJdKeHfueUC/x
 68XbzPnENWRiOxSmlLisNpgE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 38737ea13a66a289;
	Wed, 14 Oct 2026 07:56:22 +0000
X-Mizu-Trace-ID: 38737ea13a66a289
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: pjw@kernel.org,
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
Date: Wed, 14 Oct 2026 15:56:16 +0800
Message-ID: <20261014075616.76429-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261007113345.32755-1-lance.yang@linux.dev>
References: <20261007113345.32755-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4B9BA0004
X-Rspam-User: 
X-Stat-Signature: 5r8fro7y5twwak5taassx6oiwj6rm3xw
X-HE-Tag: 1791964583-326267
X-HE-Meta: U2FsdGVkX1+bW8+/vGPwZDE6uh40YXBCsA9I3+pxDvBSnJTBmw7WOS0lSGkNcW6soQx0GVCRz5Yej5fPRUZIkDeFIgPFh6bvRjJ1YiBGtG9p9NrChDCb8QHACV6DBjVLKm5R/+N9r+Rsj0LrVSZs98gaemdMQ2PFXw+J9ZFBY0xYJNa/sITdi4MDPd+/DaDdJ8SWigskTHfhxl60E9eRKDLs1Z7PIsQ+AlKHJEy3Bwk6ZiztKkVeIlCq9PfEKYKNN4tjr7RXttLwVoTp7LoN1ZalvsGa5Syu0sUdOtyAMWzZDg6y033z12v9KddWpFrwFFpXtCgQrRLcvl98hd3EsslZuPMa4/NTuOmqs4n4S5u4Nbly6JHnnAnFR4sAtxR8PuEOsjO3iwjbnk/JxiDM/VF9FDJCxHjTc3lw9x5xh4sr1H4BrD8KK+Gwsfngsmyx8UapuonVmUq08syejGWbb6HwgEOtXTllvfEBbhevp7FzOV5+rwPo5pV1axQ9TF6zkZewa5gA2J/DcrLZCzUUx4GxsAxweTIKPzZT2PnpnZy4Den2T2jvOigHl7/32U82tQ4/wCDslUGpePiEzzZgoYwcCU03kmH/1JoLj7dch9hE0KZUjJvXSvP0RmjxpWEfBZerneDMk7kI5EGope6d2dxwMq3P2Xv6dFpmROCpRDWcuzC0Ly009wqyf4SwnFynR17CQHBJtskHQNGwMPCjW69C1+ffEYwCwnwUhJedLp2xP1pcJn+5qRqqbZ+DAzveg+0rEen5nEbjEvaFlNfh81yyl0XqJfXXnLF/SNMduuhpm/GjGz4EpySUawqaSWzz+rN3zVbNHtD9N8jRMJgzm19gs22SFPrvi4pP94scLkpN412kPfa/V76EI3UNUomejjHa++j8tB9EigCw6halMt0L8Lpb4ce7ElWOXUkadYzw2+9HT5ScNdZp3QyH2etDPjGZeZS25Ct79W18yyQ
 HwFiXfTE
 jgl1D8/kckMCwyX2SUBDDmW8W1XiCYuIudYoFaYtbB0MzcyZG+A62PX3WAYywCyn/tU/T8WBuoIu5XihvU7Q8T6BYq6N1Qehbhx+MzdrvF9XCzacl89d1ggaIuWd6xhlC6nFOeBgahqqt3KBCg9aAQeDJhge836aNIJWIOFxg7EFaJVka8jfvhXwfKiMdQXN3RbJx7R/Pscxtz4w0S/z3IVTj06z/lb2zWr6U5qp1QLM1q43+x32KsN+C/hTQ1v5r1aDPJc127RV1i/CumCFnl77w8KtdN6vCWam8qeEZ0UOmJJVMSFaRW4ExbKRuTW0jYQOM2pZT9vifaqk/lGtOHhNXM5TazW0jBr0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 07, 2026 at 07:33:45PM +0800, Lance Yang wrote:
>
>On Wed, Oct 07, 2026 at 01:01:14PM +0200, David Hildenbrand (Arm) wrote:
>>On 10/5/26 15:46, Lance Yang wrote:
>>> 
>>> On Mon, Oct 05, 2026 at 12:37:20PM +0200, David Hildenbrand (Arm) wrote:
>>>> On 10/4/26 05:03, Lance Yang wrote:
>>>>> RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
>>>>> CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
>>>>> a problem for PMD migration entries, since pmd_present() also checks
>>>>> _PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
>>>>> cleared during splitting.
>>>>
>>>> I'm curious: why do we have to set leaf indications for non-present things? The
>>>> HW sure will ignore it, right?
>>> 
>>> Yeah, that surprised me too :) Still wrapping my head around the details
>>> ...
>>> 
>>>> Is this a sw problem? Who needs that?
>>> 
>>> IIUC, it's for software during a PMD split.
>>> 
>>> __split_huge_pmd_locked() invalidates the huge PMD and flushes the TLB
>>> before installing the PTE table. Software still needs pmd_present() and
>>> pmd_trans_huge() to recognize the THP in between.
>>> 
>>> RISC-V clears V but keeps the R/W/X bits for that, so the entry is invalid
>>> to hardware but still identifiable as a THP by software.
>>> 
>>> Hopefully I didn't miss something.
>>
>>I thought some change we performed to GUP-fast wouldn't require that anymore.
>>But my memory is a bit vague ... :)
>
>Yeah, I'll have another look at that :)

Emm ... I'm back. Do you mean 4b471e8898c3, which removed the GUP-fast
pmd_trans_splitting() check after the THP refcounting rework? That check
made GUP-fast bail out during the old THP split. The refcounting rework
made extra GUP references prevent the physical split :)

RISC-V gained THP support in 2021 (e88b333142e4), after
pmd_trans_splitting() had been removed. It never implemented that helper.

Keeping R/W/X in an invalidated RISC-V PMD preserves its leaf identity for
software page-table walks. That requirement is separate from the old
GUP-fast splitting check.

For RISC-V, pmd_mkinvalid() clears V and PROT_NONE but keeps R/W/X, so
pmd_present() and pmd_trans_huge() still return true:

#define _PAGE_LEAF (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC)

static inline pmd_t pmd_mkinvalid(pmd_t pmd)
{
	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
}

static inline int pmd_present(pmd_t pmd)
{
	/*
	 * Checking for _PAGE_LEAF is needed too because:
	 * When splitting a THP, split_huge_page() will temporarily clear
	 * the present bit, in this situation, pmd_present() and
	 * pmd_trans_huge() still needs to return true.
	 */
	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE | _PAGE_LEAF));
}

static inline bool pmd_leaf(pmd_t pmd)
{
	return pmd_present(pmd) && (pmd_val(pmd) & _PAGE_LEAF);
}

static inline int pmd_trans_huge(pmd_t pmd)
{
	return pmd_leaf(pmd);
}

And the rmap walk also needs that leaf indication. page_vma_mapped_walk()
checks pmd_trans_huge() before taking the PMD lock, then rereads the entry
under the lock. Keeping R/W/X lets it recognize the invalidated THP and
wait for the split to finish :)

Anyway, R/W/X still have a job there (RISC-V doesn't have a separate leaf
bit), and I don't think we can just drop them yet :D

Cheers, Lance

[...]

