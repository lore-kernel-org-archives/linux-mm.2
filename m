Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDE7606A684
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wKO1e9JG
Received: by kanga.kvack.org (Postfix)
	id 70BC26B05B6; Mon, 23 Nov 2026 03:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4296B05B7; Mon, 23 Nov 2026 03:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA086B05B8; Mon, 23 Nov 2026 03:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 306286B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:12:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C720D1C423D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:12:55 +0000 (UTC)
X-FDA: 85465667910.09.3F0F757
Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 97AD2C0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:12:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wKO1e9JG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421574;
	b=UAb9Uc0kckNC+B4U/a/Mx/iwy3EqOY4pnlUepbwCzW29HVIszFG/DxqD5pP/oYTQVU35+E
	e43sbOGVoYuYL+P5tNN27F+N6EuQuvxG/j2RAcrFpcxFq9WbyTrqXSmmjtu60n1b+gkl0f
	snCvUS88n4Zr8pmfMdnmoWKNnOPJn6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jeN8jAJwq+1hUMXlRYrpD7AgdkVOgMUP5t8JmxUI2U=;
	b=m/xvL/t3hZvY5NAKhCfQ4wTwjBOecMbc+3U6sp4Uv3itgU4UAKRQAVmOzXJliWtKSj4iwH
	74vMYCTrcbxmbuApfWOhHN1obNaTCMR/oX3rd4efkMYVYRUjrirD0YNES7ip/Rm6VZN6Gn
	lTJhUyPTG3JwGWkVG9WBu2txzNwsqEo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wKO1e9JG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RvrR5l1dNK11b4mH1JIdE/igKyGnL+zkw54T9Nsh9yE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795421572; v=1; x=1796026372;
 b=wKO1e9JGDzqD1t9RdLopQR/RqknqWfCQZH7iLfbq3+9sW/3zLN/1OKhGvNlAldPf9OjKOINd
 AUr53HEskD/RGF9eQ0m+54cwpu5pMapeOWSD25o3PnoBUy91ZqKGJSdRNFZcNPOGKqZctK/bqCW
 wrPkSHtCJRpVb51ZLDpAz1ZM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d0f5c025c2c20c78;
	Mon, 23 Nov 2026 08:12:51 +0000
X-Mizu-Trace-ID: d0f5c025c2c20c78
X-Migadu-Flow: FLOW_OUT
Message-ID: <793d63ff-c48b-431d-8a2a-4044feb45721@linux.dev>
Date: Mon, 23 Nov 2026 16:12:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/11] mm/kmsan: undo the shadow mapping when the
 origin mapping fails
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-3-hao.ge@linux.dev>
 <CAJuCfpHOZS6mp_no3wKmU3-S4HKspnbriUw8Mwtxf3nmw0-pfw@mail.gmail.com>
 <CAJuCfpFv=sCeib+SDWJNW6oqbNnhT+m3YjnfKh8jNkquzuYORg@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFv=sCeib+SDWJNW6oqbNnhT+m3YjnfKh8jNkquzuYORg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: at574k5ea4j1amgd5coec98qjcf85dcp
X-Rspamd-Queue-Id: 97AD2C0003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795421573-463897
X-HE-Meta: U2FsdGVkX19mFmbTWxLskdrJL+lE3QIXIRZwKssUyLH1P86yHKYOZyAoGE49ZO6hENa7R5lW9qSKyUZTwPzaiZ/6+JqbYI9GRtPADRcU8Q4XU8vh18EHhSGf54XW9xGEA/lLnLo3Bmx64i59FbMmIqZqlLdUDp6kI8+I0wNwqusqfxUnDfeOWCahT6qmsIhYH/rNcFbUlSawusYOiqdurEZInci3zW2WGgvO+yDuOnncF+3G/HVcCZvSmfycUkUgNQmiQLYTV/DBTwGs4hRCeXIIfFX1X5cylNiYlNXzcHTL4RldFVfmDTdXecmNP+I75FRmGfvXI6VSy85klG1B7MzdQUsfTvPL3DFvWrfb/llnOZ4L5LKGCBuo7g/Bh+LrLxMwSalomXkQdU7RQyTDOCFdxksWninBEnoBOdWrlDLitcuAbZms2TsPmsXW5t+9Xu2D/kmTLLR3kr65U3AHyKVvWE36K7keXfi9DfnjMcb/osrH924XUpE7vaAr1A4k4pViJ+RoqQOSYuWoi4Y7z2N7w+FAt4bicZ667vjbj724vm5YxMVYlBDxzSmd5HZAyKnCsJW6BfCBKOpenyTEabr5xRdeRTN8o9l8kMSJxadWIfO4tVgctkf/UG0X/U1bVg7sUEiKHUWPc57kavbEWXK7LqoaU47g2unr+xz/3AXWHIiugQoxayXdIXfBmBIf4ytdF9997S/0wStxm7dyCqMdrf/qHlcpa+0aq2/IbCIj89TtdtbWGpLdoSf1q7F5SVE8dbngMQoLjfmRCzST6XQcunmBOJZARhHphhcVtHFfTAOGVyaCkbnjTBxN77WWclCtc1xVvAb7eYqQ4ZFHI5jV3uLAIZfuLFU1/2eV0XjCHEHRb8rzYrN1CQ0B3dUe02YdU6AOEePGIzbX309AWCmOaj4KZY7INZKzc/ZO8wEFtiHunp6e/yVynu0XvrjkYY0JqatMvfUcEWw2x+w
 PHqsj3kJ
 gbv1nmWUycVi4AZVRZWdPtyfAIB4OXOp04U+TY5VaKB8E6xpalFtWdSHa6ixKBBMxPehp44eZEHcqQgx9r9M9VvLJ0HQK0TkIHaigsNLjiAjEp6FiOVFZA/Lywsdn7QTWNlIQmhsSg8BNFP2aGhv2Um9hwQ1B1yuRAjrMnIJZ9aMpjrS4iYlLXdYsrZII4/Ww0PqlO4LKZYlLoF+A4Acqif0pk+Xqp+osMAAdzZ/tGhe7fn5cnSy5STJNuiXrjQ6v8uG4zop099sBdmp1Lgk8+lLEPWukmJ4PCIhnMTE5NO7dFzQDZiw6nm55fEo2Wsru4weLvIpKyE9eZdfZljbAY/gLz1HC0BqUCc6FSwTRuNWjzi3jjVLeBfemj7Eh635cJf4RsFGr+TyVKh0jSj5KorhLWm8/hkDrNQa0Nme5WjYfoYS+IHjiX/p4+dgq+HG+8HIamGOuiixxTQdc8lPGGh55J6pCUP1fexs3/zlzs2ULgqXnSqbsA+l65LzKpanKgWJ/sTc9v3ZcjMKatBIyjXXuMqGWXiPVrmSrQq5o1ieG//6FEZyJoDb3QtG8xwy/lsxtLPWv30trXfh187ltqDHv7fzweaTmUCvWHkbhEQGI7ILPfjOWaxg6CHw1vFLnnwGK+QPXMu8Vt5kPgTsdwtaGhV4VMcwEI4hBUkq7QtPISN7r8YzOJLpfakqSyi3vdFvVTogCL+0W4cZsJlbPcEJO5DtXyjf1oJyAyE9GWaVrijuMAWscxrfCFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

On 2026/11/21 05:49, Suren Baghdasaryan wrote:
> On Fri, Nov 20, 2026 at 9:14 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Mon, Nov 16, 2026 at 7:13 AM Hao Ge <hao.ge@linux.dev> wrote:
>>>
>>> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
>>> the origin pages. If the second mapping fails, the first one is left
>>> mapped, and the callers do not roll it back. The next vmap of the
>>> same metadata range hits the stale PTEs again and fails with a
>>> WARN_ON() and -EBUSY in vmap_pages_pte_range().
>>>
>>> Undo the shadow mapping on that error path, the same way
>>> kmsan_ioremap_page_range() cleans up after a partial failure.
>>> __vunmap_range_noflush() only clears the PTEs; nothing has touched
>>> the shadow mapping, so no TLB flush is needed.
> 
> After a second thought, kmsan_ioremap_page_range() does not skip TLB
> flushing. __vunmap_range_noflush() comment at
> https://elixir.bootlin.com/linux/v7.4-rc1/source/mm/vmalloc.c#L497
> says:
> 
> The caller is responsible for calling flush_cache_vmap() before
> calling this function, and flush_tlb_kernel_range after it has
> returned successfully ...". There are no mentions of guarantees that
> mapped PTEs require explicit access to be cached. Please double-check
> if this is safe.

That's a subtle detail. I've looked up the relevant documentation.
You are right, and my "no TLB flush is needed" was wrong.

The Arm "Learn the architecture" AArch64 memory management guide says it
in "TLBs and Changing translations":

https://support.arm.com/documentation/101811/0106/TLBs-and-Changing-translations

If you change a translation table entry, or the controls that affect how entries
are interpreted, then you need to invalidate the affected entries in the TLB. If
you do not invalidate those entries, then the processor might continue to use the
old translation.

The undo changes the shadow PTEs, so the TLB has to be invalidated.

I also checked the Arm Architecture Reference Manual:
https://support.arm.com/documentation/ddi0487/md/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Architecture/-D8-16-Translation-Lookaside-Buffers
rule R SQBCS:

If a stage of translation is enabled for a translation regime that is not out-of-context,
any translation table entry for that stage that does not cause a Translation fault,
an Address size fault, or an Access flag fault is permitted to be cached in a TLB or
intermediate TLB caching structure as the result of an explicit or speculative access.

So it may already be cached by speculative access even if there was no explicit access.

For the kernel side,  Documentation/core-api/cachetlb.rst
https://elixir.bootlin.com/linux/v7.4-rc1/source/Documentation/core-api/cachetlb.rst
says that The "TLB" is abstracted under Linux as something the cpu uses to cache
virtual-->physical address translations obtained from the software page tables.
Meaning that if the software page tables change, it is possible for stale translations
to exist in this "TLB" cache. Therefore when software page table changes occur, the kernel will
invoke one of the following flush methods _after_ the page table changes occur:

The condition there is the page table change, not whether the range was accessed.

Likewise, I believe flush_cache_vmap() is also required.
The sequence in cachetlb.rst is
flush_cache_range()
change_range_of_page_tables()
flush_tlb_range()
so the cache flush has to happen before the unmap.
This is exactly the contract that the __vunmap_range_noflush() comment you quoted spells out,
the caller is responsible for calling flush_cache_vmap() before the call and flush_tlb_kernel_range()
after it.

The code will do:

--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -258,6 +258,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
                                            o_pages, page_shift);
        kmsan_leave_runtime();
        if (mapped) {
+               /* Undo the shadow mapping set up above. */
+               flush_cache_vmap(shadow_start, shadow_end);
+               kmsan_enter_runtime();
+               __vunmap_range_noflush(shadow_start, shadow_end,
+                                      gfpflags_allow_blocking(gfp_mask));
+               kmsan_leave_runtime();
+               flush_tlb_kernel_range(shadow_start, shadow_end);
                err = mapped;
                goto ret;
        }

Thanks a lot for catching this, I learned quite a bit about the TLB
along the way. 

Thanks
Best Regards
Hao
> 
>>>
>>> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>
>>> ---
>>>  mm/kmsan/shadow.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>>> index 0c88d89bf0d6..212449db34a1 100644
>>> --- a/mm/kmsan/shadow.c
>>> +++ b/mm/kmsan/shadow.c
>>> @@ -258,6 +258,11 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>>                                             o_pages, page_shift);
>>>         kmsan_leave_runtime();
>>>         if (mapped) {
>>> +               /* Undo the shadow mapping set up above. */
>>> +               kmsan_enter_runtime();
>>> +               __vunmap_range_noflush(shadow_start, shadow_end,
>>> +                                      gfpflags_allow_blocking(gfp_mask));
>>> +               kmsan_leave_runtime();
>>>                 err = mapped;
>>>                 goto ret;
>>>         }
>>> --
>>> 2.25.1
>>>

