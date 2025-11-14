Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85A0CE8D7D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7D58E0023; Fri, 14 Nov 2025 14:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0098E0021; Fri, 14 Nov 2025 14:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCCB8E0023; Fri, 14 Nov 2025 14:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF1038E0021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:33:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 672CF593D2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:33:23 +0000 (UTC)
X-FDA: 84110211486.10.74A7590
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC3BB40005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:33:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C127I7ta;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763148801; a=rsa-sha256;
	cv=none;
	b=MVRNcUVskXbWjJCjOdWjWwKKJ5z76bu8k+XRxsZgBfBrI9gaS4RKCeP1k2TatbSXRmmfqW
	yybjPULqIxtpayHcTFU8ixRufBRjSF+CCoPx0AgCqOBnNQm12QGchFdqiSv+bpCVJNik42
	dOdeI52DfqRknj2B39RIz3jsUH3JNnQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C127I7ta;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763148801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhBSgv90wZI0qyBpc29SVmAZf3puLnSIxXA/J5fhwII=;
	b=sMn6eLfKcBUb5sonuLPp4eKmN+Fp+BHhURuTWmbLwE9N2UQ7YOMkWeRTUWoqw+xL3mzrTZ
	VP9joik/KbxG4m4T4dIauCMjyKiZHNfCr5b/pMzZQhzWQdSiqk+1Vslx09vi1NAOUflCe1
	xaKfWmzVtPQzG7fc4NCt99Z+A6+sblg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0611C60192;
	Fri, 14 Nov 2025 19:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E7CC4CEF8;
	Fri, 14 Nov 2025 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763148800;
	bh=gNS0T+ZChKXxoN7znfwaqjXaS9x2GuQGcEUhveCqTRU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C127I7taFpdO7ZJzL+lRCXoW7/gpoQapchCxBZs+vxjMzUV3uXhiLukMQlXHbTfa7
	 lv5eVOUmm9ZKYLVYR2gYR5Pb9RtP1PYHoeHQ/+PoQ61nn+DrYf1QjHTZOHrmr/ZHNH
	 rMqQvqIKKXvV9HYwvWJnRkLwJZQa3y2ijGrTFEXjDCd1Vyex8xGD1En2pHs2Pe6LFY
	 tX5GfMN7hn72lSz6M+u/OzT6ekbYdJjtt+TRbPlqJ/TqPnohjJl2ZwrK3FCzS8NpqX
	 RY9UFzluM0DrFpog79S6vl3OGcz1csYlFoKB+GmQFnk47VVedGrDgvjk4lW6LfCz1r
	 +sHCw3FtodReg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 03/13] kho: Introduce high-level memory allocation API
In-Reply-To: <20251114190002.3311679-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 13:59:52 -0500")
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
	<20251114190002.3311679-4-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 20:33:17 +0100
Message-ID: <mafs0ikfc5s02.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC3BB40005
X-Stat-Signature: n65bg9brybwepbz9irfnbfffeq79jodq
X-HE-Tag: 1763148801-306911
X-HE-Meta: U2FsdGVkX1/ojZbtkn/57SKnE84QZtmjOQiWEfaOnRPNBVwlBj2KxqoPkHKJq4VsG61crpyauLqCWJ7wc+2jvh37rv4TayZaLIStzZKfSeaUjuwnWs9AQrTbCt9Gecq5xBT/PD6bgaEBfIXcSHCSIicGzevHlwVih02hMftimiwVeRlnNaxnhnhVsOU1Sjoz6S28QZRZnZ89UfgviBAvStl3Sux/wUEeWE81r1/A9fO8CzU+2egsVNBIdOzAIzMnyJV3k8h7s8+ys5bhqWM6rGjnQoYKva1vHTla+a81m/6YWWLYgvEuR5ZLHabTKKVHUyFzPQiCrAJQZkDcRyLoYfC6ZI+FTDWoJ6QTX724ejdDsM6qXn1B710NWWNfTUHQVZoPSrQaT/9ALyxYrUS1M9CKi67yrpwE17888IXvIbqCzsDE/b0V2AU4QNi360v7ZXTv9qL4dschDuS2YOYWeUs0quwTxpmCH7jCiQ/M/CudlQe7U0n02iWFZ1+eZsC3P+33N8iK3YROJG+N5AX/R++3y/R3xng5tYaXwGYA05GgJELF+8zRtjG05Mp2PbIsiGdjkkAR6XJTbrpBqktmbSUf/23LlPBrZligWVub/WWrgnUGa+ptl6uOGOKd+6lJFcvSlkxV4AaB5ZnF50Ttr997nifUh4Er9wx9l14TXXOo5BLThk2ld/s3XlDG8kuaOQH2FOFVA5UxVXQ/VyPi0aceGLvy8xZnAKv8iw1ny/ZCxeu/7zjlKVyaCYTJutjXa//LbXTp51Z7ndXt57pYaHChKpuo9t4aQjRe53DL6zgG2+OSTxB6NgoGJubutWmxf5DvgpJDMMEQ0NbfCI2oysZ+BecA6iK1NeqMB5f9HKaWTU3dU1jHTuxgLEYTSgOpj5KIesuUOywawx0ppaZD+dnprSSvKaQqCqkYiGCyR6W97VM5w1hZ7BMpI8+g+GOIeB1pbmwc0979oUORu6+
 AB7Mrv/x
 CJuI4SP2//ka3obby4j2EhJNkOBvgnngqxIHBQD7nsDti9omEdhzhu5sFxneI7qLmND254CDa6lfUMtFuPJGgU3voW0URPQWUm/3EXZfsTH6LwmDw3MPUEkMjfIuCd17+1Gq2AZykifxYfAtHhsu8am43TN6WGi+a+KHFLXCp9yOSuBj0xohfcGaSOKmg2ELBLWAHKei1t44W0+LgZwkt9FEq4739uAhRvGc1z3hZtluPXkUMdwVonL3Xc6jN9dLCt2Q4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, clients of KHO must manually allocate memory (e.g., via
> alloc_pages), calculate the page order, and explicitly call
> kho_preserve_folio(). Similarly, cleanup requires separate calls to
> unpreserve and free the memory.
>
> Introduce a high-level API to streamline this common pattern:
>
> - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
>   memory and immediately marks it for preservation.
> - kho_unpreserve_free(ptr): Unpreserves and frees the memory
>   in the current kernel.
> - kho_restore_free(ptr): Restores the struct page state of
>   preserved memory in the new kernel and immediately frees it to the
>   page allocator.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

