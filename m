Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B11C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB906B0095; Mon, 13 Jul 2026 07:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA31A6B0096; Mon, 13 Jul 2026 07:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92DA6B0098; Mon, 13 Jul 2026 07:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2B66B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:40:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4539085538
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:40:19 +0000 (UTC)
X-FDA: 84983560158.03.072435F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D54440011
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:40:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZGRJauI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCUhcyiwWTmu8QeEJQt1vja0HsbAMaRlJMAEe2Y7DeE=;
	b=A5G99qv8nETwNvZG2aQF2bz3NdFNhbqCEOzMyVPfNcaQMtQzA9WHYMsRs+kTKyfemSbLbi
	fn4OhfH5TS90R5H7EUcaDuoKmcynWe1ZC9GeQ14x50MpAoJCAN38j76WAFq77q3/2ardRS
	eN0qS2smv1BJxaPo6N28ufWdVMPfJxM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZGRJauI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942817;
	b=bYLqeGiK2U3x6Tpw7Zssz66dMALxlyCzhnS1vFcjufk+R0aLrt4JCe7Phh/yHkwcT4mdYf
	DvqTy7w49hFmdpzu114IwS5liLRfFYDbWaxZ4drflJvd0P+UP9ztkdPocc1AeuBAWWyfDs
	eJiBkRkIMn+XdbuISpZV9aAnpxSqVaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 942CA433F9;
	Mon, 13 Jul 2026 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9A41F000E9;
	Mon, 13 Jul 2026 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783942816;
	bh=OCUhcyiwWTmu8QeEJQt1vja0HsbAMaRlJMAEe2Y7DeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dZGRJauIXmFXIXVKASyA43gR9V2NS35VztGQ8qQBxwH8LNdZxq9XD4tytbLxkdY0n
	 B8D/j/tVmRYXiqNFMDWprsqF4C8N/3yT0IGtZC0WViv0Hy5j2DtOrzlO3v1SVEqURF
	 aKZlD64LLIeCcBPb97NqITp5YwBE8GPonzWR8Y7HP1uRC8V2ZwNcmgO6zQst2vzSDQ
	 bUw4pXb9RBEtnyNT00GtkuXO5eCdq/PnU4JxH6o+9qa25c+6C4tJXsww2lKsULk5ei
	 hMUFiw2xJMIXnlL/MOUBqO9VvQPb3J30DdctzBG7xOoUEJCM66BlhH5cq7Hi7LCGwd
	 xEpAPa9EOjiJw==
Date: Mon, 13 Jul 2026 12:40:08 +0100
From: Will Deacon <will@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v2 4/4] arm64: remove redundant concurrent
 ptdump UAF mitigation
Message-ID: <alTOmMpGVdRMy7NM@willie-the-truck>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-4-ad134cc3a12a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-series-vmap-race-fix-v2-4-ad134cc3a12a@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9D54440011
X-Stat-Signature: 3oq11q9pnwips5iq8md6ezac8z7wqpjb
X-Rspam-User: 
X-HE-Tag: 1783942817-840746
X-HE-Meta: U2FsdGVkX1+VhoIs15l/IZW3bXrSm4CdhPjNXmJjM5oEgxyP1nI0ZXej+OCfL2GKIK/5oECBnL3Jw4e/iL5/ziC0nO3AX9tE1/pLLQ5BRYWZAnv4rQCmPMsTwmqTcNLzqMqp3X8OYInHsS5tJ3lTnyDo23/nric/Lpn5ZUIECbMUZi6FExgvdX4/QH4nw9mMS1i11YaYo911JaEgG5Eo0tIYXn8GU7fd5T1ea03mpSR7nrXZQL0iniI9eZvivEE/PN6OzcFp+ExzPo0J73HLcWSvV6pOrbfvyKMw7iqsFtpJ9A/WcMPwjzEKBcQe8TocH/Zi61j+L1nNF1E62S9CLBIOzwUExHCodIHnCyhW1v2Tn9JL0VV9fEUfqRUiQHmRQbHlqH62VWIEiAKVt+/JnPXEEZHiE8TP2QveORZMKJVAUw46eBEV/B+sVNYjuArgrnVoGMEyEg6b9f3YfpHS7Qhc9mBvf4oD5m9EKspTEq5USfgZ1CBjhTLtxWTtOIUpmlxTs0NfWIMSt2LdM73sHeBehpMieC9MokfTYrF+R/DuYVNIOBmzeWWB2d3YmLVghxBBP9mnO45B+qphivtJiTQKg0u/am0X4ZdbYMxCCQgt7FD/5S2Xwa30uEiXaKX676MY4gYDk6RpEyQ2kkrKUTbMqlpzVhJ2zkQtL0vReY2O9Yjq8pW3GwyvFmcJnBuDGPyVxthIxk2iZUC+6vBvp1JrKBqOoM9xlO0yTV35+M5MkL3srZf7If97BQBEvxc1JrSQLTguHOlS9sscQmR/9S+YXBFq6OQTdWgWymcRUCP/pfP1LUkYSqQqXm9IqTZLbOdJzjnchuHct9i1GUWiqH3nGd1GkhFMBFjsKlk0ezzsooZGVbNlkTjMo3ApkzZBVhJoGOSKbULoX3chRfRplo2zQkcU5mIotDaatYHQjleXlMTwc6emY5sixeERt+RwjDUFGaNqWbFE1aFqqLl
 r1RG2cE9
 LABJlMffgM4ZMYCncVm2xZSM7mBTev6LaNhmZD7JORrsnWTnBLWH4v06cJXkw8Mo9dRwCWMWubF4tKvPTiEsjU1bnErvlJtbsiYtc6Ytys3aA9mQEafn+4rItYSe8IrlFBQeWcKRtwDobQYUwmFspOQFVS9x4EfzbfbwHEAz+4Aikkl1WsbTmxIvqazdG4lxubwYNeNA1JOOk0NpuA3pa9lBEWWWjrbcP4vEWvIkH5fAxKujNTuOXYxBu1hlFPcnKhwvgc4nDuwRN2Cw8Tg1oGk4mjdysLHW01/sfO5A1rjSpZus93TFjjQrto4eMGDaeALn8fFbqGD92qJnbhEnRKR/7UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 11:42:27AM +0100, Lorenzo Stoakes wrote:
> This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
> with ptdump"), retaining vmalloc-huge support but eliminating the now
> redundant mitigation against a race between huge vmap page table freeing
> and ptdump, as this issue has now been fixed at core.
> 
> We also simultaneously remove the arm64 if-deffery when acquiring the mmap
> read lock upon vmap huge page table promotion as it is no longer required.
> 
> Note that this patch relies on the preceding vmalloc patch, and should not
> be backported alone.
> 
> Fixes: fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> Cc: stable@vger.kernel.org
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  arch/arm64/include/asm/ptdump.h |  2 --
>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>  arch/arm64/mm/ptdump.c          | 11 ++---------
>  mm/vmalloc.c                    | 15 +++-----------
>  4 files changed, 9 insertions(+), 62 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

