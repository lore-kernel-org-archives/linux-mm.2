Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D69606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQ0oCC+y
Received: by kanga.kvack.org (Postfix)
	id 838E66B05B0; Thu,  5 Nov 2026 08:02:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E92C6B05B1; Thu,  5 Nov 2026 08:02:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF596B05B6; Thu,  5 Nov 2026 08:02:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 470FB6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:02:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B6A11209A8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:02:13 +0000 (UTC)
X-FDA: 85401078546.12.95D584C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2E19F10000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:02:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQ0oCC+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODdbidwungoC4joZGqAWEdUpjvBaTXtHkaXe8rKCFAw=;
	b=z9nnkgnyWt7ArIyIsdrvVDaXKgOwmQ90ejnComaENTn+L0cw05RCum12xWcW2gRBSUmPNU
	xmGIDwXszrDpjInwIERdBkGmANXpuiqlxMx5V7Koa7v2q7Zp0+ni2+ZinHE0EW1cHcVsuu
	VyepE2hD7AUIiUTZ5NRka9y79nZDXeE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQ0oCC+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883731;
	b=e8X5wDUqEciyKJ/wQR4urWrJj+e8n4UEhZqiX/wjbfNQRZviUxYncc8+io5zPaUR0IFu3G
	1UpszYb4EFudPzm7OeshhZyqmVcJN7qdFgk+wNpiZZdv74H+82O6VLu4ZM7/Mg1RsspSEa
	O9oyRgZEmQR9MUikvibE9VEJXFNjOGQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72F9F43D9D;
	Thu,  5 Nov 2026 13:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6121F00A1B;
	Thu,  5 Nov 2026 13:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883730;
	bh=ODdbidwungoC4joZGqAWEdUpjvBaTXtHkaXe8rKCFAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZQ0oCC+y9os0E1ZeMgu9e/N5WmpHjAOIrF4l3liGw27+gQmFuauUAu3QG/q9uDWTl
	 3TKp+AU0H1wWqayQPvKZM57PaRJibPQUloG2nqac2lBeRqb0UEPX1dYD8h01AEjzDz
	 vNGUIdx63ttmmh3zf3eIMHbzwnndB5k9MDBk4e+uow5NCSLEIH1cFyXz74Gi45tgp/
	 Wa26Nd2c++AdKkgxRFXZAi6sa5GBBD2QE3KUoQkbJT7VI9iZhSrWybSuBgYbpQGlB8
	 g3JErI4ZReV8vX8nOC1ZbmltupQcjstxr5TXRSSVm0c83LP1wwssH4qoIu1I1Wfl3J
	 sDALxcReIe8CA==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0F3EE198003A;
	Thu,  5 Nov 2026 08:02:04 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 05 Nov 2026 08:02:07 -0500
X-ME-Sender: <xms:TH7saqG7wrZYgS8Mw0OKSmpa6lUlaIpWmaaxiMhNQ2_I9GE5fGmgsQ>
    <xme:TH7satot4vh9OJnZQntbjnUpxcJanpaSDK0e6g1XrjWSdyQj5KtMNuq8mIsfVbK4R
    O_S9txFhPKaLFT4TTMZb23wg-mNgfFZBeARZFINIWtUQTlSuusRnv8>
X-ME-Received: <xmr:TH7sai2_SpttBsmoGsUTIFVzlHSABshtJuyvUk1T9udcIXUDJtEeThqzxuw>
X-ME-Proxy-Cause: dmFkZTGWioZ5UsUZvGXjaow1BsUGadLs8aZQdTF4UnV/07NAN/af8tN6pM/FfLXYfyZLfb
    xRpT19JopPsgAFGYsm8FzaqvOcRv05DtuUalhGCfVBg5TYHs9JXv+Q47gmOf937P2Gi3S+
    U2sfvRv8HM/m1nYX6eGi2a4miDiVYyQMuuHiidk1Rop6z5ppK7guJf5jvUfTyMXleQeyL+
    YFG9WYCksR8P+f/IoUx4Wo08VB8Mvto3/EHOpPBXbwb98JXOAs0bmRST4eO1cbxBPUkzyb
    YU+NZSxhcSt0KRFVrgpydwZFv0ufeT4P8d+qRyppjSLMzQpNREs19lQwYqTs8BowLu6Nt2
    5Am7l6YekVqjY83nXhyttgWii20fB0sq0/gLxPQHon5CrRkTEqrIGD//hCWFKqOgzqGCvi
    aMcLQ7cAZew8NgHslTKKsAByAnDUby/6o7zf6t2iuxqMb/GVhW/urcyLO2AQ8SZ818X9mS
    KvrqoB35qasVInQXx9O0IC9DWqxqX0BoD/o9yiGn5oqOKYTbGXBdOAIO4z+H9UZl5AQPCz
    X5k1DEL86ay2iE++MFKAY52MrLVWAVVhibUP0tLtOKiw/bidGrXPVW2Da/VrEL1xMbaVji
    gk/Rfm6DtM/to8/mnKjVPcrauVt2Z5IcYYLnNu1hKr6ktYnVJlpVoH4xcT1Q
X-ME-Proxy: <xmx:TH7sahDqPgMnM6imR1rATIc4Ws5YrXF92NPtBNndS3RcrHPbByQR8w>
    <xmx:TH7sat8lZSx0ZfTRSH73tiR_oEt_6GxNUq-DXVFxZ20237HLHQwtJQ>
    <xmx:TH7savMpe0K9HyMh1PrMBNDDIaNN4W1yi749wUvB54Lc8e4xuSX9Tg>
    <xmx:TH7sanFEmmZkFS9J_XtjodG9fU1CrzxAv4fcixThKJt6YmAuCEHgsw>
    <xmx:TH7sauuRyf3FUbrFTX_8ORVoKejL2DOhUuj_v288Q3YNMXl9vOfBxqQs>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 08:02:04 -0500 (EST)
Date: Thu, 5 Nov 2026 13:02:02 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: free unused page table when setting a
 huge PMD fails
Message-ID: <aux9liPvdZgpKCpa@thinkstation>
References: <20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E19F10000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: zk1b3dtspdmiys85wwtu6h7q5mawf33b
X-HE-Tag: 1793883731-910744
X-HE-Meta: U2FsdGVkX181HtBG9zKHMVwKh+eNjdEjobzclse1WRt8u4+TMEF4o9DXkFUvcDuZPc63p9VdEEhI09KOQDElZune8sM0nGCp/hVP8c5uoEjHDifp0r6WfGa9MPf6yKrAtZ4IHJ9Az3cP2OBohpNkz4wUP5IXyfpl/7XSc9ULCFT6g7YCjDGhbmbZiVO9qypg7ZxeItgMwwhSrAiN+fpvX9DuPWMME7t1Gtaz4pDLKNMztp8AO4fGH8n8qR6PYJzm5L4FtEjepwGAu8YU1Qp8h9zMOZaI3rGmvY2W+zzgU5oHc7jKKHHL2V4AeZp0tccESfFhKYsMNFk1ccSIqlNU3xUlXm00zGJWC3k7AL0RUj87lUy20JdQt9rDBNa39ThdpOTJWqnnC/4UDs0xpUMKNjVQtOI9efckDqth9tqjX8p3Rw46pGfQ5LlbSERaTBg7XoWyxSNRnFlkeyVhJ8VU8HXHyD7T94rsjE4rnAVTZXK24vi+oKlZ5Em0hCwLYgi1DVRJYOA0UA3w4b4bmy2gFSkPWauMmzGmQZg/7BQ9WWjYOHcLL4vjLGvKAwZmxvqNRFfpiZvsnY3jO5IYeO0PpzOkbBbOGBFmHik0W2/CzhFE94UvCxl703vD67ZKbYaV4E7eaEI7/hN935yeRbtbaZYHl9zykSaeWY3qn9ko/0LwHw/EdUsYkhMWanlkMsZ/d9WhbLEGnpTRY9wG00QlJpilDXYW7FexX/m6aLjAAqCmrdykxtYxq6il/s6PrapB8eUFjV1SBRP1r0QVsBZ+wWhBWMUzZOwVqjzar3+wsF1IxWlB6dQd1IwYtXE/JraOPeRx/mVenuPlatNP/wr7dpItBxge2LEfKQnNi78++obP/ejhwAm9HqdKMBIoZhFphAtqOZwNQ8XJcs/nCOWo/Y2DRh3TBxJ8mcGXkaZD7kYoR8PmtEol+BJ2A/zbMbcKMrOHKS8HyrQNvtHycV9
 Vih2Z3Pn
 QoC9rDlIgbTv1AHpPXNu7rP7ftJRh0QyUAbNJR1DoTFULdjBV//uZyKtveaKVgZuJiDlvN74PsjR5CEAIp5FzpLISROkm47H/kQpD4fn/c15o9clABr4Y1iwxjROkNjfuTuaBoGO6T47/blSCwaHG5jB5E66ug4pzOEVVMJ+a9Z3qBgm9a+zuLo87yegwEl+YuQBlkINTTx+pLTjGw/De3QCBG+dS92xKhZZj4+/GzlpVJPn2hcCJp4DBh72F6RoKhBeuWEGjSi+prjWxPlsIMqPBSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:16:05PM +0100, David Hildenbrand (Arm) wrote:
> do_set_pmd() can allocate vmf.prealloc_pte on architectures that need a
> deposited page table, such as PowerPC with the hash MMU. If the PMD is
> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
> without consuming that table.
> 
> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
> userfaultfd operation can install a PTE table before taking the folio
> lock. If that races with set_huge_pmd(), the unused preallocated table
> is lost when its local vm_fault goes out of scope.
> 
> Free vmf.prealloc_pte on failure, as do_fault() already does. Successful
> PMD installation consumes the table and clears the pointer.
> 
> Having to do this cleanup outside of do_set_pmd() is rather nasty, but
> other callers depend on it already having been allocated. This needs a
> cleanup at some point.

I hate this being outside of do_set_pmd().

What about making do_set_pmd() freeing ->prealloc_pte if it was
allocated inside? Nothing changes for caller.

        bool allocated = false;
        ...
        if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
                vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
                if (!vmf->prealloc_pte)
                        return VM_FAULT_OOM;
                allocated = true;
        }
        ...
out:
        spin_unlock(vmf->ptl);
        if (ret && allocated) {
                pte_free(vma->vm_mm, vmf->prealloc_pte);
                vmf->prealloc_pte = NULL;
        }
        return ret;

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

