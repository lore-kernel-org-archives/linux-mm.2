Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BD2107BCD0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 17:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5F96B0088; Fri, 13 Mar 2026 13:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3996B0089; Fri, 13 Mar 2026 13:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E796B008A; Fri, 13 Mar 2026 13:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 279896B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:38:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94FA989DB4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:38:06 +0000 (UTC)
X-FDA: 84541748172.12.06E902C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D5299A0011
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:38:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i0RNL435;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773423485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLfL/vfcscx+x09aaCuggTdPe5+hQiXfYqr9fuiKpG4=;
	b=o1deU+7w7xDVEOq9nGt07pPgSkR3XH3hfNXqn4D3jBBxJdwEaMyyVFbN2pyDf7UzZu2IA9
	qTkucdjAN2/DBmwBaVu+kXeQZ8J3o/4sPKyh2UyD0K5nC+VWLpGH9sQHTdZEFP4f6pz0gs
	C1EOEtKc8ipWyPJIRTia6+XGBTxXDjM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i0RNL435;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773423485; a=rsa-sha256;
	cv=none;
	b=WFkpUfd8kDhO2zl1j71ivI8k10cppBBBQ2vnDePuAUENkpkV68abd2E+FEHhs2XmR1Mw45
	4ZY1Tvp8X6GUvkPkSn+U9NGZe+oo6JEVh4hd33gZIQPIf+H46DtCrenHJDeOfdfcfsM+ut
	er2oVY+U69ITbfeIn4fjdziZu0+kEtU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D72E743D06;
	Fri, 13 Mar 2026 17:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25453C19421;
	Fri, 13 Mar 2026 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773423483;
	bh=TGwRSaWVri5njOX8uLPGY9rlgFfLB03mBYf8HXyvPQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0RNL435ZRqYDOmXtr536PK/UZbU92/ld1tWWsS2/lwmsUnDps1UQtN1kuOehW6/q
	 /BqQhgqTq98H/e9YXy/t/BJ6Cg2u3apj6wqz8RKTQF+v8zV7PcdDluVMIZfiafbknC
	 ck9wMU7FbATLTFI7wu8mF2dHl7b3YB9vGaEb5LF4+zJZyW5TQ+9gmMVM0gKBIw4kij
	 VAnuiYjI7KolgLHDh16SG6rJ7V37qZMkbIXDTXxAR8st9clOnLpgiByqhmCsNOU4NG
	 MYcUnC4SgmHiDcfs3BjNGFrp8oFX6GymoQGTtVUKSEV/BsazGOHEIIzTRcwJwIvLVf
	 aKDsoZGbio9PA==
Date: Fri, 13 Mar 2026 17:37:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 2/4] selftests/mm: soft-dirty: skip two tests when
 thp is not available
Message-ID: <60f5a518-1254-4bd7-8272-128fdd56d6ec@lucifer.local>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-3-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312114027.634559-3-chuhu@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5299A0011
X-Stat-Signature: ouqbf8xbynngxfw4kdj5bfo9axkq6tnr
X-Rspam-User: 
X-HE-Tag: 1773423484-6215
X-HE-Meta: U2FsdGVkX18EETg/2MpyqgjVuIBQUlSFNdQVy44y6swY1Dq1f4NgKJfArEfC7Ddak5yLPRUNHlbQfBoaxWNCZrQWpqEe34HkHMkexN4rmdOFvQJNYTQREFA5olJ6ZC/xGy2nhLsQPfkr+dJVV8Vqoq2xIDAnpUu3vcZuMGYPWemDDoPmlXiswKIJX6pr8RBjotdysdJYVO/3npaX+1RVTDNVy2sB5TJRoYFvOJ9UfX8uUfNMW5RALB3dobAdOn6ADzjZDRBmfAq5QJvf+VGeCutAkzjAFHO9gUhk6QQZq1ji8Y/OvgOWOrb47/woxI+kWiXfnIxstH3dWG6WCp8QDkxWfuUUPRYhtSe65NMGA2AY9WbEA2Z1Lm3RkK+oJrCxaiI/WIIN49yQt8Pudo860YHO5tgB6OuuEUaS/9yEKdmDals6X+FwgA2Mq46d6nRtKyjJcWqIpEzqGI1qS+wIDJ8r6OUTfyUz/J7fYzd4tZoMiwfflHw6Y3Igvo26CEZkz4esh6ZyUsDkaopy2DkI5rWERAi2e8U0F6mX9TbkY+rR5bNFMCW7hMMwgB5W+wIudD35lpsKvKlMayeUnab9QBQJA23AXdy45ocraj3rhSS/zsIw30fEt/y54krvoiPdKWs/A3DHDQy1sY4T5gLKQhwBlP8QTj/vEeE0WH384eUZGFfttU8C3brOQ0rYrW32jcKxp4ZTXmalfmK6jDDx2kYzyjVKvzliH1NYIvYz/8EkhcYJZ5Y5hrPfjPBWdpStMmFvLvzLLQLpQ/GnnTpQhxoQv5ltKRfdcgyr2qPsbDSq+pjhK4mEeL586MmPMdpqSexJTrHhamsYPy3bowVFl6K4ztc95eAaqamS+y4w743slXXwzWyhNxqEaYObnZb81I4OTN/X2mpZEaBvO1hAQkiw79EeImEnPVOaTDS7E4aeIkaa9JeXvPg7nJYXYAt7/E8/ViVIpXheU3AWPfT
 b1PniUVc
 d1mGretYCd8pEd38shB9M2WkQe86sA/0T0p9ryqlj9kHHI1WD9ODqJUprBvbHu0UYVLOphu3d8YLeB6IXvi5egmkHMfAXO3VLAk0jL2gJ7D8vrlTMiP2DbmmaWPQGCnS09GCbuLnxsSPMV/4dOP71PfvNICZJ+SXyn+zyRRyqaVjxHiquCswqN0AqpEGxjizLCp7D9LQDSJBYb0cYQrd1ISKr1jx0Ot5WmN3UrjweLCqOpAc9KXeRirxe9pnFOYICJQ4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:40:25PM +0800, Chunyu Hu wrote:
> The test_hugepage test contain two sub tests. If just reporting one skip
> when thp not available, there will be error in the log because the test
> count don't match the test plan. Change to skip two tests by running the
> ksft_test_result_skip twice in this case.
>
> Without the fix (run test on thp disabled kernel):
>   ./run_vmtests.sh -t soft_dirty
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..19
>   # ok 1 Test test_simple
>   # ok 2 Test test_vma_reuse dirty bit of allocated page
>   # ok 3 Test test_vma_reuse dirty bit of reused address page
>   # ok 4 # SKIP Transparent Hugepages not available
>   # ok 5 Test test_mprotect-anon dirty bit of new written page
>   # ok 6 Test test_mprotect-anon soft-dirty clear after clear_refs
>   # ok 7 Test test_mprotect-anon soft-dirty clear after marking RO
>   # ok 8 Test test_mprotect-anon soft-dirty clear after marking RW
>   # ok 9 Test test_mprotect-anon soft-dirty after rewritten
>   # ok 10 Test test_mprotect-file dirty bit of new written page
>   # ok 11 Test test_mprotect-file soft-dirty clear after clear_refs
>   # ok 12 Test test_mprotect-file soft-dirty clear after marking RO
>   # ok 13 Test test_mprotect-file soft-dirty clear after marking RW
>   # ok 14 Test test_mprotect-file soft-dirty after rewritten
>   # ok 15 Test test_merge-anon soft-dirty after remap merge 1st pg
>   # ok 16 Test test_merge-anon soft-dirty after remap merge 2nd pg
>   # ok 17 Test test_merge-anon soft-dirty after mprotect merge 1st pg
>   # ok 18 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
>   # # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # # Planned tests != run tests (19 != 18)
>   # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:1 error:0
>   # [FAIL]
>   not ok 52 soft-dirty # exit=1
>
> With the fix (run test on thp disabled kernel):
>   ./run_vmtests.sh -t soft_dirty
>   # --------------------
>   # running ./soft-dirty
>   # TAP version 13
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..19
>   # ok 1 Test test_simple
>   # ok 2 Test test_vma_reuse dirty bit of allocated page
>   # ok 3 Test test_vma_reuse dirty bit of reused address page
>   # # Transparent Hugepages not available
>   # ok 4 # SKIP Test test_hugepage huge page allocation
>   # ok 5 # SKIP Test test_hugepage huge page dirty bit
>   # ok 6 Test test_mprotect-anon dirty bit of new written page
>   # ok 7 Test test_mprotect-anon soft-dirty clear after clear_refs
>   # ok 8 Test test_mprotect-anon soft-dirty clear after marking RO
>   # ok 9 Test test_mprotect-anon soft-dirty clear after marking RW
>   # ok 10 Test test_mprotect-anon soft-dirty after rewritten
>   # ok 11 Test test_mprotect-file dirty bit of new written page
>   # ok 12 Test test_mprotect-file soft-dirty clear after clear_refs
>   # ok 13 Test test_mprotect-file soft-dirty clear after marking RO
>   # ok 14 Test test_mprotect-file soft-dirty clear after marking RW
>   # ok 15 Test test_mprotect-file soft-dirty after rewritten
>   # ok 16 Test test_merge-anon soft-dirty after remap merge 1st pg
>   # ok 17 Test test_merge-anon soft-dirty after remap merge 2nd pg
>   # ok 18 Test test_merge-anon soft-dirty after mprotect merge 1st pg
>   # ok 19 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
>   # # 2 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:2 error:0
>   # [PASS]
>   ok 1 soft-dirty
>   hwpoison_inject
>   # SUMMARY: PASS=1 SKIP=0 FAIL=0
>   1..1
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/soft-dirty.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index 59c0dbe99a9b..bcfcac99b436 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -82,7 +82,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>  	int i, ret;
>
>  	if (!thp_is_enabled()) {
> -		ksft_test_result_skip("Transparent Hugepages not available\n");
> +		ksft_print_msg("Transparent Hugepages not available\n");
> +		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
> +		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
>  		return;
>  	}
>
> --
> 2.53.0
>

