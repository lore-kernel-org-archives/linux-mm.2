Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90476C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7717B6B00A1; Thu, 20 Aug 2026 21:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722B76B00A2; Thu, 20 Aug 2026 21:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F466B00A3; Thu, 20 Aug 2026 21:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD786B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:27:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1B79A2E4A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:27:22 +0000 (UTC)
X-FDA: 85123538724.21.4B152A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47BC140006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:27:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6PPtaLk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787275641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YvkqO1Co8rgXsGiEEuyiIzaT5tlySRac/ZA+XW5nAU=;
	b=rVOkRZprZ11WxUcJ761v+4tg8BOk2h2YO3WcTY7HKPpXCbcxnCe2ew8obchaf6UDhiZ8Ow
	sGhYtDbjoHO3Zry4IAjTu8l0AnawVBooqvBi3cOKFeV5PfcKcw4Y4dsmUkywLOVPtnY5cP
	MiBI0TjHqHQ2Cf4RklXUG75HW3jE4W0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6PPtaLk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787275641;
	b=GM++jWvh2sWrfoak9PQG81nwSxHl0XsdSVt5Sa15LrUbX9/BqMRr4tALSfl28a4Hqkt7e5
	J+v4gjh5yAPV5djWyf1pbpmRuWUQSNKFjhrnSo6LfT5ROGl24AKG31NTRRAW4cndsPEaRV
	V0Df7IkrojD9manxWPukbRf5+lxL8BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8D9260A58;
	Fri, 21 Aug 2026 01:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320B91F000E9;
	Fri, 21 Aug 2026 01:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787275639;
	bh=/YvkqO1Co8rgXsGiEEuyiIzaT5tlySRac/ZA+XW5nAU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=G6PPtaLkflZk3MTvspaS+cIYDyds2Bql7vWVSowsj9PNZLKEOHqY20F3VBht+OmDG
	 Lry/15CZ5gFe31X80DSUoQ1tpbI6z83yCLGwfnfZCQxS5pQV68fqYELjtOli9J45nf
	 OxhlIinkSrsqdgmJLwHJ9RWFWygnrGjIaCGfOwZKQdsL2tUJ2dNMcuQDNa95GKg5TY
	 EmxDYSNOpuLe+L7Xk69DS6kjVF9HMLzkTVoMc4emBCGXglXqr8FwnPQFqZQzOezhLs
	 mAnoM4uDW2LgiLudE6yHax2WzwLAAUnuf1Tp/UmZ9veCFtrjI98umQl8YsX3aYF7AE
	 4HcVId5PTEnfA==
Date: Thu, 20 Aug 2026 19:27:16 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Xie Bo <xb@ultrarisc.com>
cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
    linux-riscv@lists.infradead.org, Dennis Zhou <dennis@kernel.org>, 
    Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
    linux-mm@kvack.org, linux-doc@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] riscv: Add native this_cpu_cmpxchg() support
In-Reply-To: <20260730094407.16588-1-xb@ultrarisc.com>
Message-ID: <8b8cbb4a-474d-1de4-eaf2-dd8b4e6ca8ec@kernel.org>
References: <20260730094407.16588-1-xb@ultrarisc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: dadjgszo564xmyan9cbym1p6jk5g8wno
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47BC140006
X-HE-Tag: 1787275641-328710
X-HE-Meta: U2FsdGVkX199ao0eye63Y0gRjmwBOFh4z211zwTKZISRasqqYwSo2uqZ2LxXYcEKcDN92GTxy1ut4vlWTGehXjgS82UF2/tM7c2xKT0ufXQptzajnM3dLhov3tzal0ntBRj5MW/i0THgaLR/iZ6VNSFo58KJwQ0ELTYqbVbDGCe5sws2cBGOxBYLuhaNz2VMBdqzUY8NDUDV8zNfZPxaYsbM6rC6jCtqgUTdBC8HgFkhk6zh/ZC0OeiiSh7ujlL5/64dRlnGdntypXaw6skqpu17MfmpayWLdgdmLSLcGRZAu+rMfZ2zyr2hvFpmqf3E6oPKUj6mE7+TGIqODKEelHCpk9JXQThjaBnoBRtdEw/REzjHq/gyMz3KcouW1D3VeMHEslUegjffTdd1lB0pFCJJE4pDWUyC7VDoWgX2Y7TxVakm4clmxXyYUXSPovjhSAs5yXv8l1t/A6eg3nJTW9ppDb9KNZw2hEioWSk4y7GRV+v9DK5IWpu7re79299rz5iJZy7eBUAT1xuUZhaFC5TNR8NKe2z0vlqof9QpJ1YDWnlGcMrL3TBhbHe1ZuEz2ffVPMX6HQe5+wg2TNqkeV0j0qUEGCbDB0MXYE0vIva/q/3FVorAWVELSH8ZYeXL7kvAqpKMNDQWdPj9tpZ34JelNBKEQa2GHAQzIi5THpNcqJStx7Z7/awbFN24gaxcnSjskNqaw+ivBNXmGBaVPXfd/xuFjI79roLtTTmaoR5bsR6YrysjWmQsM3UpTTZiC1gMVfewRG/S1FO8Aa9kwco7ZutOcTinDU1zh/1TwzMVyPz1WMl1HaTwFM6NVI/YJ2nAimMjCpBeXDhUEZ48/3Bv74hziX3mweHCyUGt0OkM7F9pDwctUrr+w53gdW3S3G/vXuFXZXEJmeRk+6gcgvkqeGUSDQ79gYhJeHjOTXFTUOB6k8hgOM+/RQ5CzKK309hbIr29wvLnpboTtIF
 pXi6EUo3
 2wGnAMMBtWFTxEl0rPoGTgHhmvfXDA0Ua8nfG1S7H1RhRHo7xqfJVhgKtlvrBLspZdFvb7kFNBBmLxOAQeWih/BUaq61rG7GhTNixOej1fzpflgJyRkfqzzp4ynaAGre7dfN6MFVkUO7kaBkf1BNsFqm6r7kV31LHBfhcYHfkqfQl2IrMZCscn7UsaWZvkefOyuiNwsj5r1XBwy7vnJQtjlDfxdHajVDIoke5hnF5CPLLG1UTpTW+ZT94PV1CEYJ1CVWjJGMQRzjlWnH7S3AgV73+4Uk9iF9rnloBdTNweCQzxp1VOMaYN3fVabxsAv5EzkH41vd8+2W/MZOXTja7BnltFv/X5FHRaN96ICGzZa7EXno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, 

On Thu, 30 Jul 2026, Xie Bo wrote:

> RISC-V falls back to the generic this_cpu_cmpxchg() implementation,
> which serializes the operation by disabling local interrupts.
> Consequently, HAVE_CMPXCHG_LOCAL is unset and users such as
> percpu_counter cannot use their cmpxchg-based fast paths.
> 
> Implement the 4-byte this_cpu_cmpxchg() operation with cmpxchg_local(),
> and provide the 8-byte operation on RV64. Pin execution while resolving
> the current CPU pointer so the LR/SC loop operates on one per-CPU
> instance, while allowing interrupt-context updates to race through the
> atomic operation.
> 
> Copy the old and new values to private temporaries before invoking
> cmpxchg_local(). This avoids collisions between local variable names in
> nested statement-expression macros.
> 
> The 1- and 2-byte operations continue to use the generic fallback.
> 
> Select HAVE_CMPXCHG_LOCAL and update the architecture feature matrix.
> 
> A percpu_counter_add() benchmark using the default batch value reduced
> the median time per operation by 77.3% (10 runs of 5,000,000
> operations).
> 
> In three 60-second stress-ng fork runs, median throughput increased by
> 4.6%. A 120-second combined fork and VM stress test completed without
> rss-counter errors or validation failures.
> 
> Signed-off-by: Xie Bo <xb@ultrarisc.com>

This patch seems to be missing 128-bit cmpxchg support.  Care to add it?


thanks,

- Paul

