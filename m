Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE3C106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6534B6B00A5; Thu, 12 Mar 2026 15:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634546B00A6; Thu, 12 Mar 2026 15:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534086B00A7; Thu, 12 Mar 2026 15:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4048D6B00A5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:43:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06CB91B77E9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:43:21 +0000 (UTC)
X-FDA: 84538435002.25.205AC74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E4651C000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:43:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sIf3SM/c";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773344599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKk+xT2Xt1KqfWHKAFiwlYlRL4TR5nlSFw8vMkOLeD4=;
	b=Ae6N73ZXKl537Q7r/G1xZtMtle+kqKygdJLg2nkR26tyZ+DGjYKs/xAIa7BJEpUD3dCYig
	6OjW5pS9p4T6GNne7v3wDWd/89BumMgVKFUBE68cixhwxDXOb/rsmtgGFY+5PBSthA2FgQ
	eayLpbb7jIiZdIZ5BkN/BhVVNqSAuPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sIf3SM/c";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773344599; a=rsa-sha256;
	cv=none;
	b=EsOuzvfw9vBhltIEaA++04V9jnO2we96St8f9GgRbXazfaiYMJyr31vTsHHuwmLfAvHlXr
	RMpxMqIdbmG75ozMjj97jGB6pk82WuG4HsIAaqguALp53otVokf2nAPa4+fPavE4R9jW1g
	6b4gCdanPS7CbnAhy12IfJZB+bE422A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1ADB4443F2;
	Thu, 12 Mar 2026 19:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144FAC19425;
	Thu, 12 Mar 2026 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773344598;
	bh=1wNpJYeE1dWpshwdESWmB2GY2hIpas7logaSTVcI+gQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sIf3SM/cSF4Eys53CHFttBllrEsLPwddPTKvDcu9JiLouK0OX0hZ4RkiuQZJLDkL3
	 M54xIf5vSAfgWLRiUZYF0lShQvx7EdsznNcJzOGYJ8eN4EVmZK0JIxPSmeY/llVcxG
	 T2y5h0U83ZqdtAfZ/w9Uj8UwjmYZ8KL+TuREIABbtAOIuGabIPBZlMfpFrDJ7RKXO6
	 lKQsD1faOACUQshUGZ5r1H9tGi9Gbjb9Gkp+e/D2c3Nn8aKh++FK91r4WsrrmyvuBJ
	 /y4VnNqfFDUb7NWvhu9ChkLkZlfFFufi/0uzsRjtQ3mpKjPL9Rocmtx5VZWtsX52xd
	 yLsZfZ4bNaHdg==
Message-ID: <17254a02-8155-4857-92de-51b9724d4f5e@kernel.org>
Date: Thu, 12 Mar 2026 20:43:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH 2/4] selftests/mm: soft-dirty: skip two tests when
 thp is not available
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 Li Wang <liwang@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-3-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312114027.634559-3-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E4651C000C
X-Stat-Signature: j53pr7rtfh7y3tcmrp4s7dr5e36e5385
X-Rspam-User: 
X-HE-Tag: 1773344598-684543
X-HE-Meta: U2FsdGVkX1/nBmQR2QEYPhFWtSAxlUvTHSXePCs5zjMvjM7FpdaBc8ZNa8KetCm8g8NdQIngOe1C9fAo3BswqZC6u0PsQDf5bamUr/hjgLK5P6N1zu1dsjgPk8hMMua+fmLtUdhteQH1GAdewv++K9xWYn5CHKnB4jQIUR9uGc3zD3wDh6M00rPfFRHaSnw5hS6Xvy9FCjvaRanv2i8Q43vLLQ/ShA0+F/gfZlsPMkj7wNwNExkjqykG56usrJy2fh6CUwO3VCp1Iure45djweLftW6Pc+0m13CXpb8qHdjal7f/V3sj2LLKfgchtNswEDjCkSE3Lnbzrql1BLsSwm6oMzviwKpp1dQlKCa3zvT4+sQoJ5LGUfgUKwIETEcBghUFLHtC3KMGbGt7ewW1xyE+BtyJ/ZuRH1R7c0nU6Nv3mywkCtHS6/YwthEYTevBbv1GUettirWA7q99JX6tACi0bAr8MM5lmoKuKlmJ4aoWP0wMnS1G7KxnP0+moWCYJftvvwwMyCQis635amI00y1/jdyhorQHOwaaLxHwt3nk4fjUU0plfF+wWB9MPYjmi7LgWu2D68xpbTxoE37OriLdwOLnINEDsM51HxXi6DO08gslTuBgo8+2kBVPzpNeK+uATnkjGWqGIrn7tLgg833pRoR4eugbO2Xp6dd0v7Lzxgizg70V9dlMNYcJqoN2m+HIhDliNyCY3JP8gcB/bldZYqerQHzyq6ushdWVyf8FP03XPao67EIYiWOEibZFpbeHxQKsgA6QAOaXWlZIyXCOD2LNOWL88wthJlvl9YPMhY2hqc0hSHitpdz0PT6YQdsVIjvh3ZkEjwW2MHQbFApmtktIINcaxePWnNi/e1FFa5Isc2ExlqmOY8mFzmn5n86nGoxrZiMwr4U9T0Tn4AV+bszru+b3R66YzlWWDckxA7TJa+cA8MvG4/kEoHdERpko9XsNAmg7DFmZ14u
 TaPWlmUI
 AxfJkoHXrwcHvrccPxcLkwj+kJRyy6QmhNGkY5Udj8FGci60sFTa0wlWGj4IJkof87AciX/3YBIcifk0UTQiZPJeYtZDobohEpCQ+UeFwCx+jZ3w6OfRjqj7xQiAcuNUMLLMTfUhA6XqECaHCgfNU6ggJdv99e3tBjbDe/lxI1zggoHwE5DAJSr9UxCUQKoMgqkX42RKnVb/436P3R4D2oHJN6kWiAmZmFU2gi5gb0xTLib+m1qp3vDQn9U1J34n2riZ1e8jsi8uJ5lMh1W4FwwS+o50etC+mVnlAAVD+KF9Db/L2nom3/Qb+cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 12:40, Chunyu Hu wrote:
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
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

