Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93414F532E8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DC36B0005; Tue, 24 Mar 2026 03:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E166B0088; Tue, 24 Mar 2026 03:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B2F6B008A; Tue, 24 Mar 2026 03:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90CE96B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:33:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 290A4CDDE3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:33:35 +0000 (UTC)
X-FDA: 84580141590.29.E12B292
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5F76918000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:33:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h7MeUX3E;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774337613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVrFluY8tTGhLzbS76pD05JXu+rxVgxOo89icmTPv7c=;
	b=3L1lgNoHI0IJXOh3/QdfXYfN5WCHFp7N8TytuegCRqhqcyi6rlSg+hJClWMIW7Ams0LvaJ
	zngag9IstnNNWX2yRNS3RM7svrUK6T48Trr7uw2AwIpXDkcbY6wloYnSB+r8PqcjYgM5fz
	7+FdOCiKSwdatAEyWLMgBjv6GfJQxmw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h7MeUX3E;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774337613; a=rsa-sha256;
	cv=none;
	b=e9ImorGv5Tpf82fJ7p5vmozXwW0JtvR7wFUCVLxxvKCazmN4XxBnbxq1UTJzgMVNi7PFhB
	gzPJNYzkq1xJiea105jIaro7C0V6sc4F/OJlx01CjtEKAbAJBo9jaLWExVwsFLJItw8zZ8
	k3F7neY5E3xXX4ZGNBizfJsv3DTflMc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F618439E9;
	Tue, 24 Mar 2026 07:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A8AC19424;
	Tue, 24 Mar 2026 07:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774337612;
	bh=WiAQ+4I4qCQUiHm0p1DT3+91TOXNEvDqdWg8BriPpVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h7MeUX3E5ObxKZv/m6SMsQ6+Qn/Q+4droqSYSjtzmAjVRLZMHdkcC1Fmlqj6wdwRc
	 tWRh6IylSjCQCw8boOax0c+RR+4NNPjyfe3+/TQdEdV6vG3pM51qbkBaVG9Nbc7hFB
	 gbVUpdHEYNWaivvAhpsaWyaRH7XlNgeP0tg4MH9kiqITI99O0PDmQcPPwqpQ5wYNdf
	 MneSYJCmjPciXB/9rfk+wBCOU2cPRCsepDgmJGTfDBXLlIuj4T5xxtj6pvNcuHiI5I
	 VvMrzaFJipLsfN+ttu87HcVJc4felWR4T97eM5Q5KhxiltgiTW/Nod0tWormPCNo0h
	 0cpQSQNVeaRfw==
Message-ID: <47346263-ee56-4a78-b55d-7f28c617c673@kernel.org>
Date: Tue, 24 Mar 2026 08:33:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Alex Williamson <alex@shazbot.org>, Max Boone <mboone@akamai.com>,
 stable@vger.kernel.org
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F76918000C
X-Stat-Signature: 39rxbw7acpbyhrp1hpsptfooynh9g3u7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774337613-16547
X-HE-Meta: U2FsdGVkX18Nn5/7OT+U0K5/SWZpbCLYz/PdOjv+ZlMhRBVXYodqFT9yneluaiKzyBQD+2u7QKYxtwzxvCTAB4Aj0F+BDHugBqFjWl/FokXs+SS+tF3W6Ps0LbJrEfbytY5w9ut8wYD8zN8j4UoUfQ/MMK6BhMi0S7+x+H0pFnSOEt5SnduMGavP0op0IU/w3CiwcessIo9n8BlaotbXA+6cQVNMX2F0fMkTT+F/mEhWir2+CLSVT7vcCz9eN+BmuzleieFtNeSdL4UZT1HALFVItHH5TEta8FQD011ON1ayvhV6pG9rS0E+9REkhkOdeGrEfReRijd4ETPrLgRDgiYSerP8v+Cy/XUWvF8VIReydQgaKEcto5VhtVAw07n8LUYrvJx5klArSECbwj2DruXcaG2Z+4MdcUlI+N1gDZ8nMmG7jt08seX0VINxgq+9l9u/zQoTmjBh3aXz02UKf9dXhxWJOXFhwIOK/Q3lyIWL/8dw+vYjuCb0U656d+Wnk/rrVpW0q55/gCKFbd4NuZPlMiblBD6qSDcKOxG2fO0SWuzv43gvzFHoSCYcJLNEqvl8V7UFwgZlR2pgTWb67BGFiixF85hAG/af1Z5a7IJ4fQQFpOr6q4KkjTke5Bz3mpQ6GXHXG8L8c4QfYj6AYDNyew9lVE7AtqAFPOBgywZ+Hl4YjaRHm6PXVZilvizaz3qRT3Z9cXFMhW4OZiHC3n7cf9DT0AAi3qe4+uCeNMSzOF8FBXZIm+Vt+g+jN1PbC9AwWx9cq8GUVlfY7xquGD81YbWPx4XH47HIr1AqMk2W9voXwgMQgy/gpwpNAwT7Kv1mboG0rb8cScrs5nZgVut/9TOZCJG28nr0WJE/deDZOmpaGJpgFESP6nOvXS3uy9jyY5yp9HaU6equ3WvQ1Q5LU3qyC/zjBWMh53unohCp+39sk53yCF1UkmKY4WxPKPIUTW0AzVKKHCUzGcz
 kcxxTwTX
 7A7BcTr41iJQSjW/dvKXTokoeVPw26qeJ8n+3fLDhT1YZJ+kwkiokB5+OEcLyl9xxP8FdOHpIKtDIjTU00vTkkina6OFWpaaYVYiSDU00ZaZjzXsvANOlIE1Tb7xcXgdjEpeJR8gdqk8Wlt0O1vbGdYtMOcK5c6/1cQH4RQT0R2wSjZD84TD6deY89+Zvs5KI5gvfGJOVN8AGswHbBdarpM3w9JfOd6zLxlYVjQlHFph9UkPP0BsxsWEkGJFRKOmdQlZvuzoLigJ84zYkyPdf/Apj6OFhQXthtzkcI4FTVsQ3c5mo81Ah1cxhsGeFVNVb9YUGrW5+XsVokT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 21:20, David Hildenbrand (Arm) wrote:
> follow_pfnmap_start() suffers from two problems:
> 
> (1) We are not re-fetching the pmd/pud after taking the PTL
> 
> Therefore, we are not properly stabilizing what the lock lock actually
> protects. If there is concurrent zapping, we would indicate to the
> caller that we found an entry, however, that entry might already have
> been invalidated, or contain a different PFN after taking the lock.
> 
> Properly use pmdp_get() / pudp_get() after taking the lock.
> 
> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
> 
> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
> 
> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
> reasonable on non-present entries. Most architectures indeed either
> perform a present check or make it work by smart use of flags.
> 
> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
> do that.
> 
> Let's check pmd_present()/pud_present() before assuming "the is a
> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
> table handling code that traverses user page tables does.
> 
> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
> (1) is likely more relevant than (2). It is questionable how often (1)
> would actually trigger, but let's CC stable to be sure.
> 
> This was found by code inspection.
> 
> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Should we also convert pgd_none() and p4d_none() checks to X_present() checks?

