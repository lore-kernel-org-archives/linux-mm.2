Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8255F606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hkLB5ySA
Received: by kanga.kvack.org (Postfix)
	id 8C3706B00EF; Sun, 15 Nov 2026 12:32:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C576B05B0; Sun, 15 Nov 2026 12:32:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762576B05B1; Sun, 15 Nov 2026 12:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4467D6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:32:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4024A0745
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:32:23 +0000 (UTC)
X-FDA: 85438047366.19.93BE529
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00A091A0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:32:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkLB5ySA;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794763942;
	b=W1sDQ8w/tXu4IULiS/xeOj/fVTWQz6HSeSRwtGYQOWP0lwJ/B1TkqoWuWDhOJbCuIZV6Ac
	geouQIs+J7UolUVZECn37LxMHw521wixxW2PBR3mQ2Cgk3H4jpMS6AaE6ZuIdTsAcEq7X4
	J3UASqZgDqtYxMLdTciJqwLKyJ0dvVk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkLB5ySA;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794763942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqEVXWdaDYy2iAwkzt+easl1YaYbtwylCIe+qCtSDRA=;
	b=bqD3Ovl8DSsZ1bTRSl87UEvS407ncHbxsKs5pS8G+B7U8zx15LmHLZKi97/IOexCkl4r2M
	TWFfiqEbJ4+05c2Du6716TQ7l+SXl9cALRJDmiYXeZ2VL6bNkfC4p9uA4obEzYoe/Jt+sa
	eJOlQ9TWz2XFndUYOib51X0nYbj/Jj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EBC461D59;
	Sun, 15 Nov 2026 17:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E759C1F000C4;
	Sun, 15 Nov 2026 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794763940;
	bh=jqEVXWdaDYy2iAwkzt+easl1YaYbtwylCIe+qCtSDRA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hkLB5ySA63uJy/oKlRFoLkV12uImhhP8T8+p3m8feeKxGPiq3DNfzOzYhilQMBfsh
	 E3W1f4LmGd2CaxEnu5JRsvre2AXq/Fi10BhYw0/5mP/kycAxfvC9E5jCnHFZZgxVQ0
	 DCGeZaw9gEmWG3l00yW7cz7h7Kc0m/9+TbW+D+Ugi2uAggTxs4l+hkD1a67dSyMs93
	 QUVYsUz54GnIJstYxlTV4O62VxXb4DLrM9aSxkYb510V/v4TgmRbfEZyNES8GSeR+k
	 kTfVCsN46ZWbA89WtiV17yXSH6SkQYdQfzOnygoObX+1hntbhhQQY6KxNCPbm4K8Sa
	 k9194hCfkVzPw==
Message-ID: <72dc7b45-ad20-450b-8ec7-3e86be8a41f8@kernel.org>
Date: Sun, 15 Nov 2026 18:32:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/util: fix off-by-one when checking folio index in
 snapshot_page()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org
References: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
 <avibe0HG4ssUUuBX@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <avibe0HG4ssUUuBX@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 00A091A0004
X-Stat-Signature: brjoroqum64kz7hzwrdfrztdhtmqkm5b
X-Rspam-User: 
X-HE-Tag: 1794763941-120888
X-HE-Meta: U2FsdGVkX1+q7tp+iNBX8kw23DLwVeAzVkxOgxNsQeIjYSm8iqFEc890qbXQ830ZW7h5JnXQnEZEs27/49XUTJ19eV7leHilIep7rGRivHzbvf8vrCaxyd/PmA/6M2nbZ7aMiU2QnO40KTOEmA9sMMxnPdmStsKYleCYbQnKiWw1tLQeEq8e2lUftM2knWE0iAqwO4P9d//CUhJ/Ua3lWkIISX09SV45FJPI6CHyK01nXv6TegTQ7Y4kq2SmTGq08pzWSIzEw1dlrZUxFb6kxnrArIreDyjS41WcwKItgfILiTJ8CQA61fmCAHfv99VQTg2SSsHcKeAjEYKB9fgkhtjNassTRKpz0ZpBBfW2UO4Jexwh95HlBKSNOgo8rpQnt9Indm52Qv67ft/osD+cs8mFMMftiuU4g/JiXUlGwy2o/rgWrPo1UCEs9+a6lH7cHgZj9Z02gKMhe+2jxWo5JN2PcdAXn13cp30ayuVRCE+fC0DPVm3aeBFOVATeT6smi4f1R2Hw1s2r+zhbbYrXB+QYjCk+KRtBAdldUOZ4giD0AIsMomCPdiJbJSJReAI5XP03Qqq7RPcxWNPtpfXa60NtRRPsxDluGhfttz8bfgNwC7/4jcXLJ7zk4bMCxAzGNzNrfpruFuEqVNgEv9aa2PG07C57vx/P3C6vRQ2GMFsNCy2tHWmP0Dj39QMqPlkFPR2Mwj4GaGRRtKznPOzhnXTnDBsFXnl4yKI8LimGMXdb1sR9bblo8XCVjKoguSBIe8rvbRGP0r/hoSHWu/vifXuTSrzC9ZKR91pwql5R0X6n77XNHwPdyEWIbspZIptb/LQoJx6YEGbpcc++XfoB/K0z9AwKTPj5OezC3bhJxUHN39CH0u48Z6SB/MXM9YO2QC2tKi63GxIzPFCIbuMrBK5XInHrF0a11+EAGTM44AORf866YO+7YzgPLQI30N8mac5UGR++jkgzRzz4AnF
 DbPmriOA
 FA+qhReg1I0xjc+A5YTdsgJMfys2O/6hAjyhTX2pMhHGg0gqOxFN79gz7/Bh52ixfD1blCx947ClVZGvZ9GvfD78bi70C0FHI/UWGhZmlFITWfxGWdTMWwMtRqCJfQqIP3CXwmdVrKQF0Bl2oGYeEuAwsmALvycaCqCBoBegTBhlv0Hk8jfd3Hz1o/lxYPplq4E0Lp7kg84QBYcxBzYtqXCaZaCWu/RHv3tbbmi7sRS0ok39ew4tcOYlnf9zv2Ddo141f+/YGYBQoAu9TbGFE6zstWlnqRdBjIyJoh4qGrIQvvuaNg0Bd2iO9WuOEULXDaiq7bVXly2lIUnyJ1mhx6N7b03uFoqXTUhtSCK3ZZkPXhOg7RT/lT8aEBd+my3ciVC/CUx6GWwjUgLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 18:33, Lorenzo Stoakes (ARM) wrote:
> On Sun, Nov 15, 2026 at 12:46:57AM +0800, shao.mingyin@zte.com.cn wrote:
>> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>>
>> mm/util: fix off-by-one when checking folio index in snapshot_page()
>>
>> snapshot_page() computes the page index before copying the folio state.
>> If the folio changes between those reads, the index can equal the copied
>> folio's page count. Valid indices are strictly less than that count,
>> but the current check accepts equality and marks the snapshot faithful.
>>
>> Use >= so that this inconsistent snapshot is retried, or falls back to
>> the unfaithful single-page representation. This also avoids reporting an
>> out-of-range folio index without the corresponding dump_page() warning.
>>
>> Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
>> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> 
> NAK.

Let's do the following:. Thoughts?

From c7d1a79926e3b3448bb5e84f901c185234f43b52 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 15 Nov 2026 18:11:08 +0100
Subject: [PATCH] mm/util: fix retry detection and handling in snapshot_page()

snapshot_page() detects races with concurrent folio split+construction by
checking whether the given page still falls into the folio. Unfortunately,
we have an off-by-one error in there, and we should be checking for
"ps->idx >= nr_pages", because idx 0 is valid.

For example, we might currently report a tail page at idx 1 as faithful,
although the snapshotted folio is now a small folio.

However, there is one complication: As we don't hold a folio reference,
folio_nr_pages() can return 0 on races (or when called from page freeing
code). Handle that by just setting it to 1 in that case, so we don't
wrongly report a head page as "page does not match folio".

In addition, we should reset ps->flags when retrying, by just resetting
it to PAGE_SNAPSHOT_FAITHFUL. Otherwise, PAGE_SNAPSHOT_PG_BUDDY and
PAGE_SNAPSHOT_PG_IDLE from a failed attempt could stick around.

These races are fairly rare, so this is not really critical, we simply
report something slightly wrong. No need to CC stable.

Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/util.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 80f6c714844f2..3b10d4c2a4fd9 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1406,9 +1406,9 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 	int loops = 5;
 
 	ps->pfn = page_to_pfn(page);
-	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 
 again:
+	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
 	info = ps->page_snapshot.compound_info;
@@ -1438,13 +1438,16 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
 		nr_pages = folio_nr_pages(&ps->folio_snapshot);
+		/* On races, or when freeing pages, we can read 0. */
+		if (nr_pages == 0)
+			nr_pages = 1;
 		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
 	}
 
-	if (ps->idx > nr_pages) {
+	if (ps->idx >= nr_pages) {
 		if (loops-- > 0)
 			goto again;
 		clear_compound_head(&ps->page_snapshot);
-- 
2.56.1


-- 
Cheers,

David

