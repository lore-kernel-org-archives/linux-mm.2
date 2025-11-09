Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197FFCCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 07:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C248E000C; Sun,  9 Nov 2025 02:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB148E0003; Sun,  9 Nov 2025 02:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFD18E000C; Sun,  9 Nov 2025 02:31:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26FCB8E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:31:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B048D16089B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:31:43 +0000 (UTC)
X-FDA: 84090248886.05.89F1353
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0A595180004
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:31:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cZontPJP;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762673502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZHZFA3ZUXg5pX0IdCS+JtthjhsvRZNVO/U2SsvdjJg=;
	b=anHBMym62Q0q14dyG8B5mhjzpCRTv05E/lpoUsYLHSlz48ZLhmwG1zXNfhBfEY+vUvRJjU
	lsSn99yULtKfwM0bdllTPLJIzMvTdndKM76KF0/QvbjrVzUTieiVNZEcR8eupO9+OjvK24
	JmXEcBHZH7J2C9fPWCNZ6ShW7dEiUD0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cZontPJP;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762673502; a=rsa-sha256;
	cv=none;
	b=CWflqZ82fkRfb85X1e94I0U0wd/MUr1yEzV+7rj5i//rsv1bFkuu+3cp9O7pza9Pvv30d8
	VAGgu+VRultwZsSjB9MLbuPELMAftPS538fNJrix9Gy/ezlySa8vg2VVaGsyccPJnWZtcU
	Mdp7YGF5aHJg6HiSoLzyDQRLDfizoWg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFA3140805;
	Sun,  9 Nov 2025 07:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EEAC4CEF7;
	Sun,  9 Nov 2025 07:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762673500;
	bh=7DqEHCeqS1xGa8GegeWUZP4LFVgKnIB0Dv0EsIJO1Vc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cZontPJPkPYCIdi+5VQmQhqNqY1ysdg3DrEwbQZUca9ddTzNzaHPKEibsgVNYWgEC
	 4jeHIEeHWqS/GCn/FweRN1R5+rvD7uiD29Vk0HT3oOzLaUNOR2bsAOgoLzHJow78Zo
	 LtSHj3lqLqfL0q9sr9dffxv+BCHr1XcK4xBeKUnIzoSwlIBdc1eF/7xJzbSP4GQ7KU
	 MYLEzCi6PioXg5D8uDGBLLdWVow2lZJJDuDMUlLFMZO51WK/hCS94TpcuctSZQgo6X
	 r+Fa90kkklaBYAkVmH63SE9w3V1O97V8XqjRcGg9Cybzg1RrdHsWfDFOvThpfSKdiS
	 KN1uypl9Xgo0Q==
Date: Sun, 9 Nov 2025 09:31:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, graf@amazon.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, pratyush@kernel.org
Subject: Re: [PATCH] lib/test_kho: Check if KHO is enabled
Message-ID: <aRBDVkQbEDR4KILs@kernel.org>
References: <20251106220635.2608494-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106220635.2608494-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A595180004
X-Stat-Signature: mfipf17xyyzoaoodomgis4aasougkueg
X-Rspam-User: 
X-HE-Tag: 1762673501-254057
X-HE-Meta: U2FsdGVkX19J5XGQYEQhAKZiKEs87pKzIOmVx8LfDV74JRhlMP5Up0WwW3/36/r35H5kN036wC7YpGZdCniHHLQy1ZfJMBEqm/W9kxHUVMMhGQA3EEErF8M5/rbqK94AgDIqp+Kg8JbU+LHrD23jqpC56/WBItiOC9ToZczCVrK35aJATV3cTudDH7ZVvBMG3PdhCmXZvETpz2dh3ioN2puEEv67Scdj5fjhIkmLycpKXPO829NxL1wOUQB7gbOGFcXKs/7Bkf4MwMqazTBwy5TQeBZxVZSpUJkn9oLo755P71F/nJtQV8eNRnHCRDF9gAKUmO0eFwQ8Iv/ZnvkmPwK/Otlc179ia0nILLS5kORoeO4eWkF+OBC8X4BZM7U6Uip5/ZEP7N6gCNPoJoCp5rkhaWF2PWSbeIu2lOfT4NQnGcY/gE1PSgt/+z4L5aErLLm3mtV/HcwDSj95LWn0COZPcIFNtDhYncTAUEVjijwrxOYYWMEJ1nGh9NlBL8K1SGRhloFqBEMH09iepNzZ77NSjB5epta5DZ1XS5DEV+HF+gNP71p9I4EnsHsLQr8OKT6uLHmCgZvSSuhuyPmocCfGKU+q4jQ4lst5a/Td3RUpzM7X04guvR2Lpz45Qpp+irGoDQVWn0uzMo7YwfD9BBz2Zfwpwyukdfb/9NZYs5YEzKQ959EalNLoGiAp3wr8Jvs3wnfUMBWInzj6XddYl9RzaAT8su3QPXyg6I5aiGJBe3BT0wAu/Qs9eJ3MEKdTgDIjZQdc0PKyLjpJuAC8GSL3/FT2ncPsEHegh30++qx1LJpdMaqv6y1OJYZcParfYNHb1gQpuhUT5BwNQBiLVz0WHoliIUWUJvwtJ1vJZ/tRIyvBDN/RoiM6hXwgA3CLoT9XIlhfsFD6q94nTwBEQd/WHMhQAx8EOBRFmCrWJJRTIJxfy99n0PTXBzjSooTCvSbeE+zF//h0ohQVqxE
 NwQRs4bg
 gzrfCOCHs+wcXvWBiBH5qXr1+RhEPmKf6/w1nbx9pqaktr2OCMtyERtO7Lz760pN2FQwpln3i0kJbvMPCcdpopKigFcvoNfngP+7nBlwpNxqAcqD3SFo9l2/OmTvXXSnKAAOT4XZKoXNdYBNuzCEfm5/fDs9MsdVaEYaQhoLN714Rg61R/UzTLwoYAJUvBOvLZ14nDQ3BAxybZ9OafKRtAlDBLFNaIU2JHX4P/kGEXqsrHu3zJ+TdW053zRywlvmZOCpfTxRTnHhIq6s25UKgQJuQPgfiNH0mHIue4fbXxs31IZH/hk4JpzZqjNsaSjbh/igQbHRP/LTpD/VTIqD967+E8V0nFqBdLUQQomBgP+5SJIP4sJUajTHLkOM6SqfkuB22Yuk/7tD8sT15fqfAIWnBVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 05:06:35PM -0500, Pasha Tatashin wrote:
> We must check whether KHO is enabled prior to issuing KHO commands,
> otherwise KHO internal data structures are not initialized.
> 
> Fixes: b753522bed0b ("kho: add test for kexec handover")
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.com
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  lib/test_kho.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/test_kho.c b/lib/test_kho.c
> index 025ea251a186..85b60d87a50a 100644
> --- a/lib/test_kho.c
> +++ b/lib/test_kho.c
> @@ -315,6 +315,9 @@ static int __init kho_test_init(void)
>  	phys_addr_t fdt_phys;
>  	int err;
>  
> +	if (!kho_is_enabled())
> +		return 0;
> +
>  	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
>  	if (!err)
>  		return kho_test_restore(fdt_phys);
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

-- 
Sincerely yours,
Mike.

