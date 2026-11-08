Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7210606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k5HTCQMy
Received: by kanga.kvack.org (Postfix)
	id 872E66B05B0; Sun,  8 Nov 2026 13:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8233F6B05B1; Sun,  8 Nov 2026 13:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738DD6B05B2; Sun,  8 Nov 2026 13:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5612C6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 13:07:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C622EA80F9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 18:07:14 +0000 (UTC)
X-FDA: 85412733588.08.FFF6F9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3129D12000A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 18:07:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5HTCQMy;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794161233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZfft/vBOCrTOsCKT0dA/OkOOQlWI67PZFbELklrrjU=;
	b=JUXv5d1xQyPYmz7hkvW6vICOKnD1cyuHjk8Q5KLWs7LkZQl6trN3fEWtRzJZx/W7zyH+Xx
	Xo25B/6ZroFhLcQaAu4CeW9GJ+A9TsqFkqKWmiT7AS1bU1I127yM/mtq+u98010Dz+V2jd
	hzsSbn28/wSxPvEHg/3hN4V+sI/UXWs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794161233;
	b=IfoOErYY2NOFmWqKsYjltkijwiKAsCh/NWVWxNuN66lAPZBAZ0oGwRTFAXL7nS9Ls1nWZ4
	avcw4C5cK1KEWIB9eQz/PQtjlhaj06DpgynTvH9ZZO5RkrxJzSbCvOTEDH9NV6yhYYDzop
	muX5nTFLVJ+DfzrnOeucUQ4B5Vklj1c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5HTCQMy;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 522724025F;
	Sun,  8 Nov 2026 18:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B221F0089F;
	Sun,  8 Nov 2026 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794161232;
	bh=KZfft/vBOCrTOsCKT0dA/OkOOQlWI67PZFbELklrrjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5HTCQMyBjX1rKiwurPLmKN6EI2Yz0SbzSi+7Cj4goHw24jeNOV6dH6St1I18Ds2g
	 qbqvwX5xj9gahLQ/esDyLQ4BpJrOd07miafD6CSSAlmiB9bYbTJWOf0lDsRVhfB6Fi
	 AxBYCFoUxwS9bIGjXt++QVBuSAHPHW4MNGcTuRZZUh37ZDSbH2sodgAa2j7xsOS2Cf
	 zs8Wlg4N4RpaSDNxMYL15RlGTBQ0RYiZJPabhQaR9WNDIN3QUEIRV//ejHsAX9G8N0
	 2RbtsvBMFZXwDhLoWKp7OeIo0/tFchf54JxbZP00iTDXmH9q0AVpmm6vH7+YWGo0YV
	 9QPA6xnefKq1A==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/paddr: add KUnit tests for addr_unit conversion
Date: Sun,  8 Nov 2026 10:07:04 -0800
Message-ID: <20261108180705.107130-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109-test-damon-paddr-addr-unit-kunit-v1-1-bd10bb87be98@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 4mhx6bd5zo7baiur793qwcwdh1e5gu9e
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3129D12000A
X-Rspam-User: 
X-HE-Tag: 1794161232-343564
X-HE-Meta: U2FsdGVkX19TmSG/QJCdGk/xOhognCpdF234CEjnwNVGx3+P9oH1PNPyPAxfEJPYeEvGN/r6c+roIGkutd1IndhZCJV/4+vP7/ECMB67OuEjc0d9fh2f6+rMhyEFLwP/X2Quirz0MqDIQp4BxsLdnj8ZIsSO1YjcGgUCQ/k+q/cO6qprXx4/mFD2S6I9SimIaiaYi3600HB9C5Z2AYpo0noj2MHZmhMukqXevC6cNq6ClRVMiwaWVxk+D0UQTwVffCtSTTi16+BwkCzKG95+jLzAhpLH2XyiVNjKwscvFFGG9YkaoxdBROlwLPDhzpvnCEBVE60011sPfdowyS/S1wgsG08ww6E1BlthmNx7R8Qcvj6WjAut0B2x9GEBgiu0VS1wvRmkuRfnyz/NWDe14fI3AAW6Kn2eyLcwzS6Kv4qbWDewPq+n7SIa8X9XYso9iHg9GJkoEUTW9K2Zq5LGgh23tpq6naZjw9p1vQhrlHvsAcTxBReb+wiQ7++1UwcHYpXnNfmozj59rLStpjTGhyUJsE+XhsxiffnEyEqepl0hxd+X9QR03N3DERxNj6eM9sNnsptAkgBb8Rq1LJP/KgyH2i7w2kU3nTeFK8FVZL32Ff7CMI77GkevwFPCyId5jLiycOwHdgmVWoYcAjizZZL0tgUe58+uVIbf5xflII7P8NYSBl/36wE8YJNqV6EH+aYLtHwkPUQc6m2eBUHkIcvN3xLg8ugVStPfvg4GJ/ZbTtCkiIQ2UJ2dCURMoWLSGjZwswXks/I50KfhLblgC5xrhBGg8HKsJPrCp0Tq9+UE8gb1woaxymkgkuP5r6TS43+PLJqyV9aCFkYhEbwNsrTy1+c2HepiYF6T7srpRvsBddJk5+whdTzL1XakzkSV1A7VtDEHE8cTziLqlGfRA1zDdgbEMk/HFdoQVcASQDmBE6oBm+0e82/gQFkLZ2PhXzNykqVS1dR+/4/mJtk
 TJvWMiuT
 JvoT863Ve48IwPFyoD9YfjTCAKWHZNvaRFLiXyRcNfiEukddggm8S2QNDRFdcW8EKbhqq0gsjhPsayrN9AZIhV0tBN75vUALFxyPrZFEDJw+/rgi/t9c+ZMmbZdlx20vzPy6vrO3S/TigRF9TVoVMvG/uZC5reZt940vKHnZjBm/Q+TG5WgyoJgFsOiF99F8qnt5PG202scC5Z75VOwT4n2PF2VV0QZZPGEeQwOgfKjMy29mqgMDPU3oQ1XZm2VU1zMKf78k/M5l3KiXsWOLs5CHCmEpuFpopsxaoM0fQLEN6RuOEJNQJSNGkPLXHBAY6c7HAoe8cLtHEkn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,

On Mon, 09 Nov 2026 01:23:46 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> damon_pa_phys_addr() and damon_pa_core_addr() convert between DAMON core
> addresses and physical addresses using addr_unit.  addr_unit lets 32-bit
> kernels with a 64-bit phys_addr_t monitor physical memory above 4 GiB,
> but no test covers the conversions.
> 
> Add a KUnit suite for both helpers, including a case for addresses above
> 4 GiB that is skipped when phys_addr_t is 32-bit.

Thank you for this patch!

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
[...]
> --- a/mm/damon/Kconfig
> +++ b/mm/damon/Kconfig
> @@ -65,6 +65,18 @@ config DAMON_VADDR_KUNIT_TEST
>  
>  	  If unsure, say N.
>  
> +config DAMON_PADDR_KUNIT_TEST
> +	bool "Test for DAMON physical address space operations" if !KUNIT_ALL_TESTS

The above line has more than 80 characters.  What about removing "space" ?

Other than that,

Reviewed-by: SJ Park <sj@kernel.org>

Assuming you accept my above suggestion, I modified this patch and applied to
damon/next [1] tree.  I will repost it soon (~1 week) as an mm.git merge
request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

