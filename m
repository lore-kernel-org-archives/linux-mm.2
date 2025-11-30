Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732E3D116F3
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 15:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45EF46B0005; Sun, 30 Nov 2025 10:03:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4116F6B0007; Sun, 30 Nov 2025 10:03:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3256B6B0008; Sun, 30 Nov 2025 10:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 228306B0005
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 10:03:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB7258AE77
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:03:24 +0000 (UTC)
X-FDA: 84167591928.23.3950F48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15D3D14000F
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:03:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qiog9cdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764515003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONu9umDjbfUbjtGLG358w3IaOJcSkrA16l+DQ9Wuxl8=;
	b=S5wKImtJfuyiiDZoIJC+fCf4CI2S/8koST5NI6q/WWpsUuKwAvfSTfuO0+YXOQ6BpUW6Fe
	E9Pl8blq7a4ZkdiXQsWIhEByrU+gAUI3QGQdCm36ga4lRkiUp3+pqFy8lfrfBzVrfi73/u
	7RXjjlGPouKH7Gxe7z1+4fYt/JrtWE4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qiog9cdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764515003; a=rsa-sha256;
	cv=none;
	b=fazNqC1zhombYTXyvb5IYUFRJpjhcAgmIdrvdURwD9RhX+O1dgHXsTfDmj6DI4UEbT/eum
	S+MPmM8eUM9doesBMM7PJRx0PmomXwBYO6+GnZEZnJxlj0HKFKDvWrzUPzfg8eWA+03LJK
	QmBqRsQtWwIMzF9foc7ufY5UQSb08t0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A538B434DF;
	Sun, 30 Nov 2025 15:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69566C4CEF8;
	Sun, 30 Nov 2025 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764515001;
	bh=TAFCf3q2vPDWAup7NTYassPHAwy/rjIhZi3HHAzQAXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qiog9cdWZvZoObq+tZ3+DPSDK4vw6aDshZ7M6M1PNiSXN2Jwpt9lZcKqChTf3S6Ud
	 qSIuMNQeH9mzwyaM2u6X3+2SI58lWnLxeK+W105FUen4WRDxUK/jEbfFn/zG7n1X0+
	 rtII6a1IMqVJsW8/UuwFdjTj/eHlcus95iKdYRYsh7uDtqnyIVCfFweZdb1NokcCDX
	 Kjv3nfwJSlDwRHCXYgO0XCNLjoKs9tWG0R1gw3Cd1jVd44z5WkbwCm0kU4Xckk9IPc
	 3DEqr8LaUP1gFZ62TjAQUXi/LF3vqPJ4Zv+VKLZBegR6s4BiCuXV3QCYz6PSmxpROf
	 L4lIfRKJR3F9g==
Date: Sun, 30 Nov 2025 17:03:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"open list:MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION" <linux-mm@kvack.org>,
	open list <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH RFC] mm/memblock: Fix reserve_mem allocation overlapping
 KHO scratch regions
Message-ID: <aSxcs-jCnkrm8o0M@kernel.org>
References: <20251130172939.574999-1-swarajgaikwad1925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130172939.574999-1-swarajgaikwad1925@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15D3D14000F
X-Rspamd-Server: rspam11
X-Stat-Signature: kma7h75cew88y1yz9nfoafxkf4hb1gnp
X-HE-Tag: 1764515002-644926
X-HE-Meta: U2FsdGVkX1+rXdCHUiPVzr+MlXgTPZNqGva9Y9dlvWn7+liuw7HvwObzgLEI09yvejIt9Efz2zVc0N2aiKZuzRe4btVZxzOGFAOIJltDrY2ZO7cO9hGDj96w4vA42YHibj2gmF2pomnsKgh6sQb+BlxK5IKNEwdAFXYrudSjmh6Sp5IwIYfdiMmJYfS5lQiiHtZ+/eCgxC6fMSMcLHb9atuFFvZZRXiumLjbMUM+Qs11BRSx9eYSjbftYok/dlFt5LeZvw+OHXnMDPyb+w/2Nhf2WP3sp/MAvYOAl/2SODSihgkaUdnCJpt0L9/mP39IKiWH91ozmMzi539aF9AdHGSxlpZdpaiLq5V358mbnDyMbWMyg6KsX4exEU3NwsbA8EmYrHG+a3BbfIWZfaXx/MSV/HgNYQXzLljF/GLnkoK/T5k2IpczRA4a2gYRz3nmylV9vsYF9uRsTpoKaupovpVt1RVV9+ZjAMsLvru+OSzvuHxZGzBSedGrdIeR+6y7m5nJ2ylYhBvo6nWxjkPw0mRVAaddyf9Xkc60Rg8UKHHo20tgTR9xnppMBOtbyPDSr1mWlrhrGOhcxyif8pkf/s6YrJGpEVOJzZxpy2f1q01yAYvRsnWEh7QSGJxgD5BuuPwF0woWX6IxEfaibeigvQiz2yZlrRDc1yQGWF/fn6EMDoiWxzeJ1R28LWkYXjMclkgyef6AfdOro2yGH13cDAJfoOkacsHL0IIBvZjmg/CPvGgeJPsClvg9LxI2eP2FJX1aLpwNGQeVAHJm7tFbDERMesSDiG7Hl6G1zvd8YRRNRUhqUwPTrN3c6XshlXbYHx8n/ny2bEWcQlZy3QTycro2Jzk1AbneqNv95l1q4gn+MLH8rDCl+pzXQtCYmDEv0GC3bvYRyZNVWoFAZSixstjmJZJryoU53JT1nGckAI8lyTbNBq3NdAnbYiTzCpb0NtTj/5FHEBpGWZ7vSRE
 3lWaw+o5
 YjRkONTe4DjgYOn706LQkkUn9FVtiaUBSL3Rgz0YU5dsVFzYVyUgUyeknHcDthMX9l5ivYdrX5AerkL/W5LyhP2NI5xc7Ka3Vd68Kx5daO8eog0UT/n+QipJm5tfs/EbTVuECxbPVyMN2L/wUgFT3rhOTXuX9Ri63ulxfItvS5GkDh8fou1ipE5dyuRalHJMdXDUkUu54Si5EZCXOJqNTZF/NHruJgKQPQWrcv6fCfl5CmVePLN/PIn/6uOAoxoHEFLZ8GccuPb5VO5J1vuxGaMcWAhpToiucg5r9XIWxKNKD9Uw1k51lrifNEVF8wPOeNlND/z24Vd4Ugi1CuGIVS1KuMn2JxpwPoi3lCy24gQarPzyOyh1j26MZgypzw+PPjh21EnMa3Dz9uxXmi1pQMSxGuL6kONOAK16kkZUxrZtcf4plA6NyrcneLig7fZfPy61d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Nov 30, 2025 at 05:29:39PM +0000, Swaraj Gaikwad wrote:
> Currently, `reserve_mem=` does not check for overlap with these KHO
> scratch areas. As a result, a memblock allocation may land inside a
> KHO-provided scratch region, leading to corruption or loss of the data.
> Noted by the following TODO:
>   /* TODO: Allocation must be outside of scratch region */
> This RFC proposes extending `reserve_mem()` to allocate memory *only* in
> gaps outside the KHO scratch intervals. The logic is:
> 
>   1. Walk through all KHO scratch ranges (kho_scratch[]).
>   2. Attempt allocation in each safe gap:
>         [curr_start_addr, scratch_start)
>   3. If not found, attempt to allocate after the last scratch block.
>   4. If all attempts fail, return -ENOMEM.
> 
> The allocation is done via `memblock_phys_alloc_range()`, which already
> supports constrained range allocation and preserves alignment guarantees.
> 
> This is posted as an RFC because I would like feedback on:
> 
>   - Whether the allocation-gap scanning approach is acceptable.
>   - Whether this logic belongs in reserve_mem() or should be abstracted
>     into a helper for reuse.
>   - I would appreciate guidance on testing this change.

So this is completely untested? 

Kernel documentation asks for submitters to test their code:
https://docs.kernel.org/process/submit-checklist.html#test-your-code

Please study the code you are changing to understand how it should be
tested and don't submit untested patches.
 
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

-- 
Sincerely yours,
Mike.

