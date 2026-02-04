Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C62E8B393
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 03:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9DF6B0088; Tue,  3 Feb 2026 22:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874406B0089; Tue,  3 Feb 2026 22:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0A16B008A; Tue,  3 Feb 2026 22:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1A66B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:12:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03E95140663
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:12:20 +0000 (UTC)
X-FDA: 84405300882.23.F9733A4
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9C22140008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:12:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AIRLMWUu;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770174739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9Ml/Qa1uGTXylqlpdcLLmiqL24y9FMnNekGf9gASGs=;
	b=P1P3LOMTLSKwVgtMvvDHCsIqzrb8lokOBN+BR1q6mK0doFV8/AgrZ2rc+wHLju8+FSt8ab
	mBjp124MWM5kH8ABO8pTfM9CGDs0JuAGs+8hwRONpvL7VYEaCA01dcLfFLhA26m1PKRtFm
	rnTOa5c9/5Z3z4JaZi2Oei3DbQHGhI4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AIRLMWUu;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770174739; a=rsa-sha256;
	cv=none;
	b=g9bw6mOUxltPOyORg1MOpKkGcXUvo9+hz6pnM52INIhZOB9+kRMgiQONaoXXeIuL/UQwX0
	DQg0HbaLlF0kb8dFiBQtgrOIMnXjcBihYFCuIrJJIFlYR3IDRBlNMPJj+Hz1BXlLBdX+c2
	QdPzEOnBlZROBRVuLvZ+EGMWAmD/4hA=
Message-ID: <2d4ea6ad-783a-4b0f-9cba-4f04fbefed45@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770174736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9Ml/Qa1uGTXylqlpdcLLmiqL24y9FMnNekGf9gASGs=;
	b=AIRLMWUu7nO5IgXUHojK/xI1o7u1JdCcpt2yLPOD1aPS5q9bkd1Np4eUQRO7dXeSAbi4jw
	FaAAfSG1SGBdJegCvAxk4BNCJ1OV2WBvZtZuPDAkTsFS2Ip4Q2jS63ZKWNC3x7+QEb6mpv
	L5ze2A3NCxYmVw9ymJtbUnE/eQI07lw=
Date: Wed, 4 Feb 2026 11:12:04 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, ziy@nvidia.com, riel@surriel.com,
 lorenzo.stoakes@oracle.com, david@kernel.org, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, gavinguo@igalia.com, vbabka@suse.cz,
 jannh@google.com, stable@vger.kernel.org, harry.yoo@oracle.com,
 Liam.Howlett@oracle.com
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260204004219.6524-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: akrby6fd153se7mrii3ssff913c73oqu
X-Rspamd-Queue-Id: C9C22140008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770174738-258962
X-HE-Meta: U2FsdGVkX18fHXE8NlvHCAapozxTB+AHeoW2DiOzgSoNjPn1tbXyEFrn5tR1wCzH9RQ6b/BF7RQmTjWvVjsIWlT4FFZNKQi4RXztcU7hCRAXzHDA3ycfH27Hq/Cb/cwUXpMNcmVjKOwe9sUfJrbrQDAu3VFaTby/uNcpOBpqWUx8fO9LssXWfx0TVHVRD+sxwPQLp1ZdVoSekyQxXMKeYbl63BaEb3T3kM+HvBYxJZ6K8c1Vu+++Ridpynz4heGpnl7kqcC+GLyJ0wPgWWgxY57tlO0v6qXImrYa1uyYaYF2t+0u16H77j9zPbfcK4Qr/d3JLW2OrL+iUwxOZwhwP+WRgkLOC0yv5PQn04bZ8R6DjrA9UoIrVFQ4SVhgpXzZL7offVsc22nRPSIzyWEw6jBXzlzQF06mgY+z+uBG80CrEK5HpV0aYgCGSEd7ZlPmLRfrcKgre7dRiZiRfkagI0zUiGEktNHfs2IScndQ8bMlCauYmQFC6jfmurSAPIQp7tFGUFXLA1KDb/cQeISMHtoD/SoconrIAQTGTwQvdIihzKlwc9bpNxMAKHFLU9TIjx4kAq90IlVTTvXK6/YqyXoE6VrSEwvJHBVUoL4food03T9E2ZQsfRwtpvrQT+xYJeCCA9BrxM4z5LZr1C9e1UDpfIO9IGOf+2LycGmMK9A568N101GvtKxKSA/8sLG6XaS4EV2olanvJfXcO9cWb5HOPpi7Ga/Kk5N7ONC07aI8lESeL3y9NOCVMOEE37CwheZ/UyW2189SpAcRGL6EQQ3Un3AvI63SREVXME+V6F9yNyBQjWKL3NHVR3FQNbBJyCHl3/lEfFBLPcowmn9ChH1pNQiS5hnyZR0NqLMfXCDdTAJ0XC6yfiaUcVBAoQIBwmZn+A0/TTbbMgcjrwcESQ/jS5qAd61cxqeskkajGL50h4E74j0MawV6PtZadvUAngBr8wD8gvkrjsEtGkA
 97tHioVn
 50izH4cFpNwBQ/+vIFF+kqh8Xw4xpUaOVshzYF4kWMFLsowARJn3jBHXICzoatIdHz8qe/o4VMnZhPPhvgi1L5RP1ILNelNxly6Vs4sUKAX4ta7z7gDB53hg6NHixi/OL4w1ZMvCnq3GWa4zL2TYk6cp9D3Sy3yLnHKcULexM1v4rgu3nRxHdIWQkiC+B/4CjlFRy5+PqH3ZtvAPMD34rl14UYmB+iN6/UqNFHa8iiRHKCwKJl3aZsocidka0KVBXSgfxDcyQqiL9I1Z+GAZt41o8qkDSAvE0PygWrsUrrojslCjy6wHGq19tjkcWPextOAOFe4ZdORkVQV2sgatpIdGSyDdh3x44+teoDRs8GVoKGtjbOERtsRFj97zS7NZnk4aIZfq9OIlR6Iw88GgfU77H/f78S/7vWjfL5YvzS/xlapOzsOke76guOPZxBrUwdQGQ40qyZu0ZLxQHCVrw5dmINj/nZI5YDPqk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/4 08:42, Wei Yang wrote:
> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
> split_huge_pmd_locked()") return false unconditionally after
> split_huge_pmd_locked() which may fail early during try_to_migrate() for
> shared thp. This will lead to unexpected folio split failure.
> 
> One way to reproduce:
> 
>      Create an anonymous thp range and fork 512 children, so we have a
>      thp shared mapped in 513 processes. Then trigger folio split with
>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>      order 0.
> 
> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
> 
> The reason is the above commit return false after split pmd
> unconditionally in the first process and break try_to_migrate().
> 
> The tricky thing in above reproduce method is current debugfs interface
> leverage function split_huge_pages_pid(), which will iterate the whole
> pmd range and do folio split on each base page address. This means it
> will try 512 times, and each time split one pmd from pmd mapped to pte
> mapped thp. If there are less than 512 shared mapped process,
> the folio is still split successfully at last. But in real world, we
> usually try it for once.
> 
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
> (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
> just split instead of split to migration entry. Restart
> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
> again and fail try_to_migrate() early if it fails.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
> 
> ---

Confirmed that the splitting is working now as expected with the
reproducer above.

Tested-by: Lance Yang <lance.yang@linux.dev>

Also, looks good to me:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

