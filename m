Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 390E9CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CE48E0007; Fri,  7 Nov 2025 05:25:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B64D8E0002; Fri,  7 Nov 2025 05:25:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC3D8E0007; Fri,  7 Nov 2025 05:25:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1788B8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:25:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3ED6C0402
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:25:00 +0000 (UTC)
X-FDA: 84083427960.03.9B5CC3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 152851C0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:24:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IHKAUit7;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762511099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuxhyfXWEEy9fDnOrA01HxHWTqNiuqIz80pv0iDUPpM=;
	b=Ake6+V5EL6vNpc2VovUGmIolW4waCqUpaSr5KEwrXi3vxVNYnv+MckCMPgcwnIrddvZOo9
	7RHjdgiDAiKYGg9zBzpjQ/KDbD04X5WZxlsoWx6xjNCpups8I+5kwWFrDmSuZXyI26OMyW
	+jMi3Nwr/VZCjTXnWK6MGsyb7H2ZhuE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IHKAUit7;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762511099; a=rsa-sha256;
	cv=none;
	b=QOtQPwzThDYxFHSS1/JYerYWkzTMkI9pRFzvy+LgU1nTNcJM3JTGpl7s6sFPIG3TyAL5P1
	kjhzK4DyHVli+vyZRXfbeM9s/N4pjHvA+E5FembSnarStCkg/MrAKItV2szYtQ6N14lpdh
	eRKVXz8H0LxG4oW5iqLMKL43TJwPSzI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C0AB601BD;
	Fri,  7 Nov 2025 10:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C1FC4CEF8;
	Fri,  7 Nov 2025 10:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762511098;
	bh=N/bCvCGjWmD/PbOgspBiiy0+tZE0wHLdpwBlXhL6rTk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IHKAUit76/jqpfWIZXIuB2XUYGmzC5SCrm9uOv0Qw6KGUeJprlHvRSbAOmOuVeWUv
	 aI/BynQlBvBYWaxjnW5HY91zQ+FTYeMV3sFGnX5E/cn/1OI5xzKsnD87qEBWLzOurS
	 iiCQtJbFeEP1oS5yL4oq+LCgMxyzbc3FE2n/e6YXfFnE9UqVoF+HWQKtDHWDSFI1dt
	 tcHiAT3JjYGnh3VA3X84DE055IT7DvftFcyiif6y0GOLembjnxT+/YsHcjOf/raSSp
	 EaVasd/ZmAbYr+CudIZJA9b0w8SWrNDQaHTeJCzM1+Nio1ZVKQOKc8lgsZE4ccGjKy
	 4wuPpf/VsGELA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  rppt@kernel.org,  graf@amazon.com,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  pratyush@kernel.org
Subject: Re: [PATCH] lib/test_kho: Check if KHO is enabled
In-Reply-To: <20251106220635.2608494-1-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Thu, 6 Nov 2025 17:06:35 -0500")
References: <20251106220635.2608494-1-pasha.tatashin@soleen.com>
Date: Fri, 07 Nov 2025 11:24:55 +0100
Message-ID: <mafs0cy5ub0nc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 152851C0006
X-Stat-Signature: qt5rtyd5qbus1kpyqf5fthsanob41zpd
X-Rspam-User: 
X-HE-Tag: 1762511098-280559
X-HE-Meta: U2FsdGVkX1/QByT/vYNbZalhgqqkBpoICaJT97usOSa4LqPrgmMhfd8IKYKT3kZuxCuKvE1r9xZ08h6uCSqn1VtYDh90nKBb0JxNWsPY1OI9fcwVsa3DjgWpOOIiStrauy6WvkVvvQJkBZsGG1JsAJKjkdkxKMFHhv19KXRQTFSqnz+RQTG0A7Y8HPQBMYXZQGBfJTwOcV5EXZe9a8H2Yd5jgk81MRvQGg2NtLeM54Yi+kUIfj3CZLp6/RE84AQM+aFIXbxtzs1cpNcFAMHkf8oUT6Fs8GWxn96yUFEteuz+QoEOEUm+ow/o1NHVhfIXkxh6e7U1b7/6wrYyxXAyO8Z4y+saOZbrKM4GDZEOqPzx5IMK0LFtA6PHsi8wBnJyTzIvzL6/tCIyZVvPLLUTSDjQ/1rR0yUFiN/NWuOj8ixGQQiFKL1hE+gsH8skllO+sbPBk2mwGbZvzjZtroYOzleLOkLWTOte3qbnf8oVqoVnvQKuUQGkt+IxkYTKanAHwqSKHZ58B+FVT05O7f/ZV8ScGNdl90O4/d8nMbNBNcYWYu55A3SJw0bfQpZH/OJHSbOk0VV0uhioBAqZFM424usHBTWu+j9i9sbI1EWZ1fF87bjxM1QttCY6iYiI+xQO5zm1Ak++wp6fn579DytFOPjt39VIkfAxFwUy1mQcGcLG73vrXbSA13xuc3aZu1XrCa+1JF8Ho2zEfkZoK4vYC3YVSb9ynNOAjRdywL9GQ0BwL5V/0JEyrXBmI9Gy+NGUSXijCjIntx8Nr1Ivf4ha4Nrk9W+vkK6u+DNmti55zqeel8halfUbUybdRCfEZSaEkWwXFzQORrlc9whT0RQtu0SZkuB37DjsNEKdJUBu2a8d2/W6kvRzcIVQmvz1mB7stPZi83jzNt7Huu923nE5iQNRouNkeZJNNSpuHW+fURLP4yYYIr1F8pwAu19rPC29P8/SzAs7mL5ZtfYqLF1
 A3nuLEL8
 VAvzCKyeA5JKPPdVkq5ll49S/POPa6BYWsF90FDBf0Wm85yrXmK4hYfk3i/M7975QCjGM6DPKbGKPek0/7ZliNku4WTVxptj5dyKPm4j2E4nOr5SX4QmGeInizM6orHOFDgz1XKm3Uh+6XAu1J3VL19IQvhPY17CyKL/kDaWKoEDUc4qyRBql8Oc1PDgA0Uv9ytXg0E86wiWdj42wzPdKzs4sJwKf2L5a/afHi6wsg2kdfG+J5JTyC1yhHqIyKn07a7rSz/y9X4a3gzyNhMKMR9Q4HNmM4zFJQxpqrIyAprQZQZcN7aMBBphtgwNWWLHT2DID
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06 2025, Pasha Tatashin wrote:

> We must check whether KHO is enabled prior to issuing KHO commands,
> otherwise KHO internal data structures are not initialized.

Should we have this check in the KHO APIs instead? This check is easy
enough to miss.

>
> Fixes: b753522bed0b ("kho: add test for kexec handover")
>

Nit: these blank lines would probably mess up trailer parsing for
tooling.

> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.com
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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

-- 
Regards,
Pratyush Yadav

