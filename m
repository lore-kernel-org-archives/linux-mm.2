Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942AE606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jintyy2t
Received: by kanga.kvack.org (Postfix)
	id B67BE6B05B7; Mon,  9 Nov 2026 08:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F256B05BD; Mon,  9 Nov 2026 08:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A558D6B05BF; Mon,  9 Nov 2026 08:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81D256B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:07:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 125E416067A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:07:31 +0000 (UTC)
X-FDA: 85415607102.07.48DAE7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4EE881C000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:07:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jintyy2t;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229649;
	b=u73MA/I8CeNoQVo/QBqlivICTQfJpGnWfemGrha4QZFHwJSaYXIK9Rr0v0vcj6RbFMal90
	uoZbg+7cdSJxvAoEWRqZaz8+9ulwXV5gKSTDt6DVEMDnT6xjaN5TU1Z7SxgHB64gWfww+k
	x1wMpg4DSpDYSVpL76V2p0up0O4YxK4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jintyy2t;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1ZkJOx0YMKAetnR53KLSam63/lIe1qshCB1Rhi1SdI=;
	b=y0LAG/G5yiNaPWADZhUFkt7arDtevcmDvcrXbhTKHPo3XDiZWvabjbn7j+h9rPD4fVKiJY
	NHPHDzaUPldG60xF+KIi7dKBsv+ABkI4u1DZ0OUXzFhZfM6hsUAyBRmdaShvOpp4b+mjj0
	tHuv4gK+tyqXDzJqpfpW8L2VA3IXVeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8B0061445;
	Mon,  9 Nov 2026 13:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D971F0089F;
	Mon,  9 Nov 2026 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794229648;
	bh=c1ZkJOx0YMKAetnR53KLSam63/lIe1qshCB1Rhi1SdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jintyy2t6HxmVDZlycaWEo7AAMjqehFKdng6seOXe/g6d/1I3wVVjh6r+arwqxKrf
	 9rta+uA/JzciTqwz9OdfvIElYB0QaZV7n7G7BnuR0/jikIRBtjZS3061egy7tFF2TR
	 RiXUPIBK9jNMyHeliNPmF9+a2o8F4CRrcPAKyBnSgm6erFAFnE+Q/NGX/fvFAQxGc+
	 4VSkrHAWe1c/B+nVwfFA11XFnnIz6DR+dGIUiA3BM8nFUpzwFypaCGmFEPYdxXMHSX
	 TcgpG153T2QupoQ5w4BGPoah40g/xJrux8DCDs9R2cpVLAzMLE/JqyHrMvgNmTeHyp
	 61xdrh3+TGHdA==
Message-ID: <ef12d685-d111-4a6f-b72a-77bbd1369548@kernel.org>
Date: Mon, 9 Nov 2026 14:07:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Alistair Popple <apopple@nvidia.com>,
 Xin Hao <xhao@linux.alibaba.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Yuan Zhong <zhongyuan@hygon.cn>, Shifei Ge <geshifei@hygon.cn>,
 Jianyong Wu <wujianyong@hygon.cn>, Shijie Huang <huangsj@hygon.cn>,
 Yibin Liu <liuyibin@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261107143456.1590658-1-qiuzhiteng@hygon.cn>
 <20261109122915.2150586-1-qiuzhiteng@hygon.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109122915.2150586-1-qiuzhiteng@hygon.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aokjoayrxqrkoy9kfxcjabjempragc4u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EE881C000E
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794229649-296428
X-HE-Meta: U2FsdGVkX1/t9t4QpbnAE1LNRkJ2KZeXFyKWc5TZ0r1koQ+gtaK8j7NEoD3CvJf39dBiNXQB2rEpkhROrzWXUB3+ycKUBReo1OV/ho7diSz8nUC1+Jni+ExqNe2+aVHithC0gPu40bcGMr1EssAeORbiTDDFmsmNPDsiZEqLdMmbUacKiqnpWDt0YJKJjDkSP5F0OVWBrtP8LRAi9HV8CHezUTKGuYepWk8eeK5aeWtq2jlPdwqFjlxVsAtgiG82cYt/rrxeyaYr9PZuyGCrwpLU2BUI6Hn0ZRLYjv9v9cSr4lWxbm0Pmnww/JA1dAtWjSAOx4TPIt+VGBrYtsRahupRiWZiF1Le+JlbusHM5Zt2EfBBHidpUaUHCb63yr+yQRCqMret8w+BqZ0Ze/8hs1GE9EvFs30ZnovOjWoNx8VtUKFIaX2ev9309qbc3eC13E+dIbxzZ7AQEwHGbmcNx06UcFWq5qQyiC2gJ1qI/qaGCnq9u2UO1mtnLQGdPT8wVqVR6INBPAOcaGCRJMzRYTB87TtuvbS8D34/q8InYvy1yJbTUNTwZK8tzvTtl7fWIix4lDWUF3rt8lS0p9pD0VuHdmjzhCy0sa7Ct5TgcS5yThpxNXRfe7AS9jJ6hbuwEMbxoSkuuxNud5UAqQb+GDnxApGDoMPY6e3XrqURCV3snV/J7gJcjaPV3qspNb2ukovnYKovIrKhN3Wa3CcD6OVDj1ShmulBcSrmHuCeOCjcUr3xVC1f7KmZnAc7W+m31Q3d9N9lzrKRgGEkPNmePzqCyyW/J34Pp0NlJJ80aV9FgAh3m9cqLC3LBhQ7b7qe4go4kQZHbkydvezKEg4iaoz7pNSJThwzwigcbr/SIEsqi7QRXuAHiz6sz6cfHGM2QfAQHNyydUaImY2/ndIBYLOORrtzIUBXdNzr98tqqZmLMXfYvC9zKHUm0Bfw81bKTUWeK/9S4kUqjO5uEcw
 ta/E+Z0g
 yqAgcjrfA56hCbBwNqIK/zoyYpFGRxs1cAdK2r6gjPSwpQ1pH+K8QFJa3sJIFXBuF1BNqRKPfLNpSxsC7YK+NqVDpc417xpzhkCT5WVsPQZFd9XI0kQqZySNeyy3dSFpWj6Rgx0xROzrYYVJCTBTWPEL2PzCLuB5AbztvmMrYqa0slfz9M9fYastwa22Rh8aiRtzbhg+svP72RcBOnlnucnZ1LgQdCA25L1cMhiUFIg6EHPD8qmSeGMN1XNtHLcnRlmU7650NxjaeszWdUOopd3oDz6EUrZDZxzobcKsPMxAxSJA+RkEuHlL48PyQlT7tGi8Iu8v/Sb/f+XLRu6JRtYbkmokC/4fJRcUYnMlPRw+tMbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 13:29, Zhiteng Qiu wrote:
> NUMA balancing migrates one folio at a time, but since commit
> 7e12beb8ca2a ("migrate_pages: batch flushing TLB") it still unmaps
> with TTU_BATCH_FLUSH like any other MIGRATE_ASYNC migration.  When the
> batch contains one folio mapped only once, there is nothing to batch,
> and the batched unmap can leave mm->tlb_flush_batched pending, so the
> NUMA scanner's next change_pte_range() can call flush_tlb_mm() before
> changing the PTE table.  With migrations running concurrently, that
> state keeps being refilled and the scanner ends up flushing the whole
> mm for many of the PTE tables it walks.
> 
> That slows each scan pass down a lot, and mm->tlb_flush_pending stays
> raised for the whole pass.  On x86, a migration that unmaps a
> PROT_NONE PTE while mm->tlb_flush_pending is set gets true from
> pte_accessible() and needs a flush too; with batching, the resulting
> arch_tlbbatch_flush() is a full flush.  The two feed each other.  In
> one run, 33% of the migrations overlapped a pass, although passes
> covered only 9% of the time.
> 
> On a 2-socket, 384-CPU x86 machine without INVLPGB, with v7.3, a
> 120 GiB anonymous working set on 4 KiB pages and 384 threads (three
> balancing on/off pairs per kernel):
> 
>                                      v7.3          patched
>   throughput loss from balancing     13.0-16.5%    0.5-6.3%
>   TLB interrupts per migrated page   202-210       12.7-13.6
>   average scanner mmu_gather time    ~90 ms        ~6.7 ms
> 
> The mmu_gather times were measured in separate instrumented runs.
> 
> So only ask for a batched flush when the rmap walk can meet more than
> one PTE, that is, when there is more than one folio in the batch or
> the folio is mapped more than once.  Otherwise try_to_migrate_one()
> uses ptep_clear_flush() on the one PTE.  PMD-mapped THPs are not
> affected, since set_pmd_migration_entry() flushes them regardless of
> TTU_BATCH_FLUSH.
> 
> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
> ---
> Changes in v3:
>  - Use folio_mapcount() for the check, as Ying suggested.  It counts
>    PTEs, so PTE-mapped large folios are still batched when more than
>    one PTE remains mapped.  The only difference from v2 is a large
>    folio with just one PTE still mapped, which is no longer batched
>    either.
>  - Cut the changelog down.
> 
> Changes in v2:
>  - Pass the try_to_migrate() flags directly and use single_folio in
>    the VM_WARN_ON_ONCE(), as suggested by Ying.
>  - Rewrote the changelog after looking into why b99a342d4f11 does not
>    avoid the flush here.
> 
> v2: https://lore.kernel.org/r/20261107143456.1590658-1-qiuzhiteng@hygon.cn
> v1: https://lore.kernel.org/r/20261106041628.1177963-1-qiuzhiteng@hygon.cn
> 
> The table was measured on v7.3 with the check as posted in v2.  v3
> only differs for a large folio with a single PTE left mapped.  On
> mm-new with v3, one balancing on/off pair gave a 3.2% loss and 13.5
> TLB interrupts per migrated page.
> 
> I re-ran the tests on v3: mm/migration selftests 6/6, LTP move_pages
> and migrate_pages 14/14, and 30 minutes with compaction forced every
> 30 s without warnings.  Splitting partially mapped 2 MiB THPs during
> NUMA migration still gets the batched flush (0.11-0.12 TLB
> interrupts per migrated page, same as base), and 64 KiB mTHP and a
> MAP_SHARED mapping shared by two processes behave like base.
> 
> No Fixes: tag, as this is a performance trade-off that has been there
> since v6.3 and nobody has reported it as a regression.  Happy to add
> one if you think it should have one.
> 

For the future, please don't send new revisions in reply to old revisions.

>  mm/migrate.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index cb699ea59d33..011cceadeda9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1222,7 +1222,7 @@ static void migrate_folio_done(struct folio *src,
>  static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
>  		struct folio *src, struct folio **dstp, enum migrate_mode mode,
> -		struct list_head *ret)
> +		bool single_folio, struct list_head *ret)

Is there no way to avoid that boolean?

>  {
>  	struct folio *dst;
>  	int rc = -EAGAIN;
> @@ -1344,7 +1344,19 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		/* Establish migration ptes */
>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>  			       !folio_test_ksm(src) && !anon_vma, src);
> -		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
> +		enum ttu_flags ttu = 0;
> +
> +		/*
> +		 * Batching only helps if the rmap walk can find more than one
> +		 * PTE to clear.  With a single folio mapped once there is
> +		 * nothing to merge, and a batched unmap would only leave
> +		 * mm->tlb_flush_batched pending, making later page table
> +		 * changes in this mm (e.g. NUMA scanning) flush the whole mm.
> +		 */
> +		if (mode == MIGRATE_ASYNC &&
> +		    (!single_folio || folio_mapcount(src) > 1))

This is all information the caller could provide, and the caller could just
provide the TTU flag then instead of passing a new "bool".

Also, likely this check can be put into a separate helper function.

> +			ttu = TTU_BATCH_FLUSH;


I am not quite happy about the folio_mapcount() check, though: as soon as we
optimize try_to_unmap() to batch better for large folios, it would be just plain
wrong.

So this needs a second thought.

-- 
Cheers,

David

