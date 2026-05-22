Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947E1CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE906B0093; Fri, 22 May 2026 04:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978486B0095; Fri, 22 May 2026 04:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875AD6B0096; Fri, 22 May 2026 04:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79FD06B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:39:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2881FC2FDB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:39:44 +0000 (UTC)
X-FDA: 84794407488.23.C27096B
Received: from mail-m82140.xmail.ntesmail.com (mail-m82140.xmail.ntesmail.com [156.224.82.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4676118000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:39:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.140 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779439182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2SP9f5dNFGv3RLTKhBjhzs8tmhgtBGwu92NKZearkl4=;
	b=tn7yNZhANJpeusgee0dASXt9YyNsHozTR1+h2Tl3Cjvz28GzUOh/2SFJZLtSiYdH7HzXU1
	ebPI8Czmg/VnJcqdvL+y3z56wC6vIGrF6pAx/gjBowUHNd02lanP1rSQ6wuByfWekarmlu
	v7nG21n/au0sTzft2NaQ2GM+7mPC0Vs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.140 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779439182; a=rsa-sha256;
	cv=none;
	b=R0UOgAkCLl5qEfme38hF+07ER/oHZ4KA8a/fkODpzWAlWgbag481IlHg/baVdKSq2///hg
	veDmBVF7ELTREaK7HeODbIucNW2LYrTRH9hNlfXYPdZa+skquoJD6qg1AhG2XhLsHtHlKK
	AECQXmBIWnrU7ZEaxUWqAzGiRoEOzk4=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a770b647;
	Fri, 22 May 2026 16:39:35 +0800 (GMT+08:00)
Message-ID: <4cc3db44-66da-47f0-815a-4322d0d3df96@easystack.cn>
Date: Fri, 22 May 2026 16:39:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
 <20260521172057.84537783b60ff9cd0abadf76@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260521172057.84537783b60ff9cd0abadf76@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e4ed705d40229kunm49935f069de1d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTEpCVkMdHRkfTk1JT0xMS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4676118000B
X-Stat-Signature: fwnkrgj7rkapcoxmrd8j74g6f7dwjub1
X-Rspam-User: 
X-HE-Tag: 1779439180-437641
X-HE-Meta: U2FsdGVkX18+Xk0bsOtvum93z1BapkBKUESoXWp0m0g2SGhNU2aGioVppY0IBnjQaJyXfjnppvVEOuho7dWjGZSNKX6GnxHwMrm6KifzIT+5oIRa41FbAsenxitDJyoft0iLg37TISs7nuDkPPxFJmmz8CQAAX9EKujywxil4FnZ2I4Y4pF+ahOhbGhxsmcqcPymVaU65jbsg/cNlTAdSzpWFSHWgx+/4ehy83vXstxxzstaQiIkYp2H+hxrlPz8WDzOn1V6twbyhiRs5z9HADAZOu+OV36ZTpeKbEgEiy6AHfWEjnRMoOcwnC49WyffKtd6FQH4BZL+A2kt89rFeSpx8MmXBcFbA8/Xq/+vZgcWlCZUJSWBvID7s9kLKP5OA7f5Ya4ZBCeQRKh4reNZdGxjH/Zk/+kz6rvsUrq4oT1XNcuLPJSqtqhcT3Bsmablf2wT7uUodURUiMhK4sWijKzTA7pvxqJoo42wr921fM7IBtu0z6++vUNFAV0ZgBke2Th2MEuGV57x2p6EicP0xwAIMAZ8vBusX0cNMrnwdPLi/i3Hsa7YKTBw6bgpch3sA5BcNVwisTBjJ2/B4WwQG4MAkj5NwXbBGY9WTG7pniQJzp9aMzmVTNEWDTU9bSIUJUVzZyDGo1AzKq6jXcJDKo2UQtXAvCKVRspQR0ojqQlRk/+/2aGweEHnrARE4upTK+S7o9XJbLokAGTZD3eFGBq/TWi46eMnbLdzzgqQ7vpioj9JF+eYm1ZYp3oGojdNAO/BdA/MGS9aEcVUKMAEwtsyAH/oljksMUGAsPC1KS21maGUGmgxY3cXEJ/qTY3vDxEZawkFIj0/RScNMcrYL54uFcaeUya7opI6UFa6NfEVHi33rrfjM+APLTif8sLdJeIIiNcBEcn98SaVKJEyvx1sy/4YwMjBi7Q3FOM18Vr6McPWwwNwYbHjUgtB7Bart5evfLsTTOsDktCtPtd
 wOl1kzIg
 bbdzdnuydqUcXBMlRjtCNOcBGLfF2TGTEPRBpqI9CBqsoW6PiBblColtCjiyvzTi90SU+p6ggNNlicJaMZ1As/scDNB/HfPfATpE9f2Bi47Tz1ihdpkvfQhF/BbNmKZUXoqySx91emhT/ALg/2nOcYHPNeG4KE00qq7DdQNWh8h99HFOwpGWuKV2cia4ZYx28OkK3o89YDt91ibxFbhlYbUywBZ3T5ZCjTlK8RFuslMJl3fmaryD3EVLxFnNAV3hLlmg1mypp+6cBBAnK4jhofhZU0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/22 08:20, Andrew Morton 写道:
> On Wed, 20 May 2026 15:56:37 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> This patch series introduces per-file-descriptor filtering capabilities to the
>> page_owner feature.
> 
> Thanks.  AI review appears to have found a bunch of new things to
> complain about.  Can you please check?
> 
> 	https://sashiko.dev/#/patchset/20260515091942.1535677-1-zhen.ni@easystack.cn
> 
> I'm interested in learning how much of this is accurate, and how useful
> you're finding that review to be?
> 
> 
> 

Thanks. This is a response to review feedback on patch 1/4
(mm/page_owner: add print_mode filter).

There's a race condition between
page_owner_write() and print_page_owner() when sharing the same
file descriptor. The sequential reads of state->print_mode can
indeed lead to inconsistent behavior if a concurrent write
changes the mode between the two checks.

Proposed solution: Add spinlock for proper protection

I'll add a spinlock to page_owner_filter_state to properly serialize
concurrent access:

struct page_owner_filter_state {
     enum page_owner_print_mode print_mode;
     nodemask_t nid_filter;
     bool nid_filter_enabled;
     spinlock_t lock;  /* Protect concurrent access */
};

Write operation - atomic update:

static ssize_t page_owner_write(struct file *file,
                      const char __user *buf,
                      size_t count, loff_t *ppos)
{
     struct page_owner_filter_state *state = file->private_data;
     unsigned long flags;

     // Parse input (without lock)
     // ...

     // Atomic commit
     spin_lock_irqsave(&state->lock, flags);
     state->print_mode = new_print_mode;
     state->nid_filter = new_nid_filter;
     state->nid_filter_enabled = new_nid_filter_enabled;
     spin_unlock_irqrestore(&state->lock, flags);

     return count;
}

Read operation - consistent snapshot:

print_page_owner(...) {
     struct page_owner_filter_state *state = file->private_data;
     enum page_owner_print_mode print_mode;
     nodemask_t nid_filter;
     bool nid_enabled;
     unsigned long flags;

     // Get consistent snapshot (cached once)
     spin_lock_irqsave(&state->lock, flags);
     print_mode = state->print_mode;
     nid_filter = state->nid_filter;
     nid_enabled = state->nid_filter_enabled;
     spin_unlock_irqrestore(&state->lock, flags);

     // Use snapshot for all checks
     if (print_mode != PAGE_OWNER_PRINT_HANDLE) {
         // Print stack
     }

     if (print_mode != PAGE_OWNER_PRINT_STACK) {
         // Print handle
     }
}

Why READ_ONCE/WRITE_ONCE is not sufficient:

While READ_ONCE/WRITE_ONCE can prevent data tears on individual
fields, they cannot guarantee atomic updates across multiple
fields.

I'll prepare a follow-up patch to add the spinlock protection.


-------------------------------------------------------------


This is a response to review feedback on patch 2/4
(mm/page_owner: add NUMA node filter).

Issue 1: page_to_nid() may trigger page poison check

Why page poison check can be triggered:
The root cause is the lockless page iteration. As noted in the comment 
at line 741-746:
/*
  * Some pages could be missed by concurrent allocation or free,
  * because we don't hold the zone lock.
  */
Without holding the zone lock, there's a race window where a page may be 
in an inconsistent state during concurrent allocation or free.

When page_to_nid(page) is called:
#define page_to_nid(page) memdesc_nid(PF_POISONED_CHECK(page)->flags)

PF_POISONED_CHECK checks if page->flags is in an inconsistent state 
during this race window. If detected, it triggers VM_BUG_ON_PGFLAGS(), 
causing a kernel crash.

Current problematic code (mm/page_owner.c:772-777):
if (state->nid_filter_enabled) {
     int page_nid = page_to_nid(page);  // May trigger VM_BUG_ON_PGFLAGS

     if (!node_isset(page_nid, state->nid_filter))
         goto ext_put_continue;
}

Fix: Use memdesc_nid(page->flags) to extract nid directly from flags, 
bypassing PF_POISONED_CHECK:
if (state->nid_filter_enabled) {
     int page_nid = memdesc_nid(page->flags);  // Direct access, no check

     if (!node_isset(page_nid, state->nid_filter))
         goto ext_put_continue;
}

Why the suggested pfn_to_nid() doesn't work:
I checked the implementation in include/linux/mmzone.h:2377-2381:
#ifdef CONFIG_NUMA
#define pfn_to_nid(pfn)                         \
({                                           \
     unsigned long __pfn_to_nid_pfn = (pfn);   \
     page_to_nid(pfn_to_page(__pfn_to_nid_pfn)); \
})
#endif
On NUMA systems, pfn_to_nid() internally calls page_to_nid(), which 
still triggers PF_POISONED_CHECK. Therefore it doesn't solve the problem.

Issue 2: Concurrent access protection

This issue is already addressed in patch 1/4.

-------------------------------------------------------------

This is a response to review feedback on patch 3/4

Issue 1: isdigit() with potentially negative signed char Accepted.

I'll fix this by casting to unsigned char:
if (!isdigit((unsigned char)*p)) {
     fprintf(stderr, "Error: Invalid character '%c' in nid_list\n",
         *p);
     return -1;
}
This ensures the value is in the valid range for ctype functions and 
avoids undefined behavior with non-ASCII input.

Issue 2: NID validation allows values > 65535

No change planned. The kernel already validates NID values. If an 
invalid NID is sent, the kernel will reject it with EINVAL.

Issue 3: Manual -h handling interferes with getopt

No change planned. This is intentional. The manual -h check at line 
155-162 allows the usage message to be displayed even on older kernels 
without page_owner support or per-fd filtering. This helps users 
understand the tool's functionality without needing to consult separate 
documentation, even when running on kernels that don't support these 
features. The edge case of -o -h is extremely rare in practice (user 
wanting to write to a file named "-h"), and the benefit of 
always-showable help documentation outweighs this theoretical issue.

Issue 4: Error message doesn't distinguish permissions from kernel support

No change planned. Harmless.

Issue 5: Performance of fflush() and fprintf() in read loop

I'll change to use fwrite() instead of fprintf() and move the flush to 
after the loop:

Current code:
while ((ret = read(fd, buf, sizeof(buf) - 1)) > 0) {
     buf[ret] = '\0';
     fprintf(output, "%s", buf);
     fflush(output);
}
Changed to:
while ((ret = read(fd, buf, sizeof(buf))) > 0) {
     fwrite(buf, 1, ret, output);
}
fflush(output);

This avoids the redundant strlen() scan from fprintf() and frequent 
flush calls, while still ensuring all data is written before the program 
continues.


Best regards,
Zhen Ni

