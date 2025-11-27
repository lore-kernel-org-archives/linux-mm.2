Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20942CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 16:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21516B0030; Thu, 27 Nov 2025 11:20:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3846B0032; Thu, 27 Nov 2025 11:20:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0D66B0062; Thu, 27 Nov 2025 11:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7EEB6B0030
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:20:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60190C0212
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:20:20 +0000 (UTC)
X-FDA: 84156899400.23.2E73128
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B90941C0018
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:20:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=enT7i+QG;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764260418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb5O61brOXNx5cnFLPLNFtBKkHZFWE66/2wPBrCgz5c=;
	b=v+ydpv1/I6MGLSkfAscuydYt+W5ljrorTRe2HoC6aP68tA5RGe9ZfaSlJtzpKJMg6+XQlM
	nMwELgdr9pl1zR3XxjizY25HJouA6wyS+AbsRUPkar1zUxw9yTtszO70Zm9BIzZJ0H0knJ
	paEVFI5ZVs1VlL4AQnW6AlG2AMen62k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=enT7i+QG;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764260418; a=rsa-sha256;
	cv=none;
	b=AOYvOUF4rcJpx4J+ACxnwnErOOKCO5xCpNjx12pwhcqHLYItwQznqjRzHSZTu/NONxVjPQ
	tFuHnXXCz/YZKtU2oK6TSFGhUyo1zhoEA+vc5b+2FUexx0YDIha7cg1ycJC3ETPTCmb+Wc
	KMEFU3Eh2CR1jiPOYLkvpMdv0NKf0qU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23A3960153;
	Thu, 27 Nov 2025 16:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240AFC4CEF8;
	Thu, 27 Nov 2025 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764260417;
	bh=avZf9Vu6ylIFB1LxLASnCOKBE9sB2MGp7u47/NpKjkk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=enT7i+QGeF5nMmfGvskWHyOmourYf9rryiYO17BNruJNNuOE3iYx0zIYavhZ3/6o8
	 0LeogTw+IqzuEAPVdEnA0B0qsUL6U3wSLD6fXyZCATBp73Z8UbUquCNIHwtlu0S8i1
	 ovyrsz2rMipXJIp3sP1/Ezn9ku7QE6ujpTyCbf5/o1yk/FkgNgEGa2NabB7ypXIMro
	 /5+hOa5C2wFoefcDYmrW1oFyAPJ2HSCWxMyDLVKhy3S4x5G6I9wHGUcOt4y0KlDs5N
	 uN3JYWaveYxh0o+R0dceTbU3iVHXvXP6oMVbvOyn4hVqnB37G8EzogSO5I8YFXZhPH
	 6KsRQiXRcv52g==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  catalin.marinas@arm.com,
  changyuanl@google.com,  graf@amazon.com,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v4] KHO: Fix boot failure due to kmemleak access to
 non-PRESENT pages
In-Reply-To: <20251127122700.103927-1-ranxiaokai627@163.com> (ranxiaokai's
	message of "Thu, 27 Nov 2025 12:27:00 +0000")
References: <20251127122700.103927-1-ranxiaokai627@163.com>
Date: Thu, 27 Nov 2025 17:20:14 +0100
Message-ID: <mafs07bvbwipt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B90941C0018
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6q6q6xgxknpab1cjrsnxy5m8yq35a9r4
X-HE-Tag: 1764260418-621799
X-HE-Meta: U2FsdGVkX18MXu154Qt78I8xr03sn04sH9uCgO4bbRffE16UKITHTJNRn/yoZLDsjxe1lxaWCYdm5deGUETDKuhz8ERm+2iRMVjlKVkXgUvT0OPFd+lnL8AFFCK6rkdBofN8pjsu+/cOvmJN1+p5amKjd961v+w1TwijspwyM2xSm8l7vrkGDHOgO85BNzqtneZYQvnOHv2SZdJrjnAiHUq0O/DvHI3tdW1f245yDx24L+/gPXe0Zk1GV1I53RHHa2i6uAyNCwPpPtqJMDW25lPlduhN6+MKHU4tyKGklAN+4MqYH2GBQE5YYJyRX1t6/l2xzNHNQ8P/u1/iwQX/iYETqleW6z/pL8o75iHv4DgMnfSm6JMk5b5Sc/p6NQpsc0zg3tE0Vuz2/W8lboqIRgALS+s7/ezz+1ixuSITulxKY2Dw3FGIKzshWK4getWL37CWqhYW5fKW6giLtjThmAw3QHBZGOMtojJTJC92v5Se0kDka4NKrGnSRJ21Mtn3Bjl0KKO8lMeb+O8uN/Ycj4RC2ms2AnWfYewjF7IA9O9FAuJKAy7tzVT963Cb7fWD3GjW21xp3xUJLIjbqMlall0hsk5DFICsjixvEgPA+D+c9C2YNNK2Mfgytsfr4IF1PgnsU6uRWjCBj9e1HW+s8vbNDiGinUVrIODwgHXf/8dw8CVFSBRRwJS0pnYMItx4DlsF5qRP9uzxdQCbFAilfom1ckboAbwCNpCrtzT1EYibQ8qqra4Ut1w4MGrDNkq8xJeXhYBVq73ZYznd16bXuRe1o+4aPpiLh9GWczBdvlt9zY/ExBuuO6X0pNu7m0q1wLCrSEtII8bnkMgl8pBjTK9HRSYqzlIf4PQ3CRdeUSAvJXJpqUgCYb5YhSXbaaFn6c0Pbpof2icXulec59yCRWDKZ4/25Wab2L7tKYCHKWislvRnzAsQ1wfIbNZgqRdLoEw4j/pfwuNyR6RCAGm
 kVRQhZJ5
 8ExizKbDG25L7TIqRmyolrKwCu4D1c7LdZrdxyonYZVP2xCavF4OC7xtA0VZxhXjJep1f8D42elV+JujlcSii0bYZorHTYSqKPzvfxP2HDtdUaEZn29j/AuXSCPl7y+OW8/vk8U/pAwpWwCLW5w4ztolidDcpHJuh8sXfSABH/e7l+e8OhFZZjfIYOaRQRgukQJZ5iW19AlDM47+QzUI/KBCBTCju0z1qhk8bjED7fzGGERYB2YWGrhIPCFN3SNJPom4tfbroTNI2i4omFiwZImWQBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27 2025, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> When booting with debug_pagealloc=on while having:
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
> the system fails to boot due to page faults during kmemleak scanning.
>
> This occurs because:
> With debug_pagealloc is enabled, __free_pages() invokes
> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
> freed pages in the kernel page table.
> KHO scratch areas are allocated from memblock and noted by kmemleak. But
> these areas don't remain reserved but released later to the page allocator
> using init_cma_reserved_pageblock(). This causes subsequent kmemleak scans
> access non-PRESENT pages, leading to fatal page faults.
>
> Mark scratch areas with kmemleak_ignore_phys() after they are allocated
> from memblock to exclude them from kmemleak scanning before they are
> released to buddy allocator to fix this.
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks!

[...]

-- 
Regards,
Pratyush Yadav

