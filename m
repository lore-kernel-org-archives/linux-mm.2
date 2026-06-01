Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74467CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EAE06B0293; Mon,  1 Jun 2026 03:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C796B0295; Mon,  1 Jun 2026 03:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763676B0296; Mon,  1 Jun 2026 03:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 629BB6B0293
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:00:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E478612052C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:00:14 +0000 (UTC)
X-FDA: 84830444748.10.00BF4FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1AC3A40009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:00:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhLYx2Wu;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780297213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sG16cqjI7FhoaRWQp7sfIsmBPD55jpILyYPNhzH0HJM=;
	b=33DsegoTtbd4Lw8xuB9iOs5cKwCqSsLY8nktBA1k4DYAFiKcI6wrDqu/0zAThYh34Ngr6g
	gXM8to69K5MnMQ+0Suhep0KDnqaQZKKdwkITWdyuuOF7YeWEm5lsIJJ7L8HjM0mUkSQBvG
	M3xeVs88T42Gq43YeeHUCnWbZ5igenk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhLYx2Wu;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780297213; a=rsa-sha256;
	cv=none;
	b=YRreFcY7aeqUS0IWxSw8AgXsVXqVftDYGFykFxr/tNoyqCRgH0on3ZzAkiSyhyutxsX/Km
	8Gf14K6lmojUXXbcB9C3h/ROhGQlWj+JJXNh1ogb0kjCmKS5Sit4ShznjKdRH95l7AeZzV
	d60qsHSSjsi6xyY1zGQK0XqjMeDJuTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47A3E42B92;
	Mon,  1 Jun 2026 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12161F00893;
	Mon,  1 Jun 2026 07:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780297212;
	bh=sG16cqjI7FhoaRWQp7sfIsmBPD55jpILyYPNhzH0HJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PhLYx2Wu8AgTfIz+jj0OOGnKXyOUYFMO3olfikldAJMNFROAGoFnSULgR+6dK0TU7
	 viL3jQ7WOK2r7TEvDxUsJaz7URycqhGazOzUqppWDH13wwUjO/llcMYRMbXOsRR+mf
	 ZwtYjWfIJWhx4t1ci56omI7yOOP3g39irVqlNA+ZDkrsqdeZQmCnMHVj03vx+eVVBZ
	 lEy/HQoSI2vKDGlObWJaPri3DRUxUTiHZaPykrpML67YpTk7622Dmvloewu9DQIfEI
	 tKqvElZXCO+sU2Xt1dEAGvcoruBnDPNRwhJZR0r2i1t/cUhLtOHLn2pP68JB87oBFs
	 yLl3d/zUPTkCw==
Date: Mon, 1 Jun 2026 10:00:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/3] kho: Add support for kunit mocking KHO restore API
Message-ID: <ah0t9Ss_S-5iOM59@kernel.org>
References: <20260521193202.746810-1-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521193202.746810-1-skhawaja@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AC3A40009
X-Stat-Signature: yerbgqdich84kh5ibs8atx7pacccmnd5
X-HE-Tag: 1780297212-196009
X-HE-Meta: U2FsdGVkX1+ftMawbNOqQXSMKkrR9w5YMPYHIO4y4pshf6Hn6bMSK/NEFu3beLf4KB/ImC+L+0pvPIqCLyArqcd7bTkrfdkj6a7VRWS1J/d/527kSPcQPZwzy8rwZywEk3XjUv4ynm/zVySZ6I9YQ2x/WqPhJZYM2wAoilz1Xk7gTCrqPQmoZy5I4bRnljurRBDLpOhGwK/u25QacOPWpZQQ4sIg2o8wBe5ZgGHlgWwk1zgvo6E/j8DTRpeGVloObtFgPUGQwkeWB9A7akex6nrLjQr382Y803HUQmBqeEnMcPcMzXKy4vpVUK5MBDQsIBFmiDI/579ZCICJdRHbrWnTUhq4Oc1k7mJ/dPZarLs0aSKQckK/mQZz3VNF1n2/7RVPSOLfF7DafYlfvu6x/6V0jxyt+MPpLI/GmAqGL6MZh/ayqF9r/8pd8Pg4XgeNGJXkswhcHcjq3OwnApYGDCpL3g1sb60Zd3Rg6zdmtZBEXVilXbrev0vBYyv0nCzKSRew9BGlg4k8VYi9NFo/T9Tb+0vnp2Jw4xacfzNHERxtTW5Q9JGB+/zWfcAhncf7jqDBn7TK4qCTPMtqGxdHgf4sJ1YNleC48zFK8pjtjzMnjNUM7a07Le+liqiiujlBCoYpp0TDNHHHORXQO1g/FOFVruBNV4Fpo1RnjPRK8flEPh2bkR70tfZNVyEkycH2jFKl5lbu5N95g+dSfEfd5fEmX8BOEYkFr2UqvGjJ11jq6rBVfLVydRcp8p0YJcXMvTpxQo42zsssjGTuY8bkKt4jy5DlCrQu99bH679x27hAUNsZHyQJa1WKRH9z6jXYM86Cz3veFn6qOKj4e9wH/ad1shRqMBeuwRJB+tRs/YgP5ZGYjViOn8xINvB+oeDZcjcyb0N0g4nU7w0NzcND48BC2lMxmXmWI65xfF3NedDOOcwGW2EllNFOlQf3A+I2WN9W8P+HwYDx4zyHB/X
 J3pEGwOX
 0fAcaCbLfNxcV+mzJH0yTSFDKmAj6OtFJ4u8/CI86YjlxkR3o6TbAcpZlr3NcJPC38Rtg6ApQO/uLTAw+Suq4k/VGnzvq3xPXh5EbFHL4WYCMH6BWImy6wBCA/7NvsnFuCYdBdzRwBKoR5COdhEZtBm3uq99M7Z2Q8X+ttNnnHsgciDojSqyD27uRPnstjtJZZYOI7us0h3s7vKII4uUMW3eq6koe+BcopkD0XNdSykE9Hn9npTC7OZu3wmT8KU9/raOD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samiullah,

On Thu, May 21, 2026 at 07:31:59PM +0000, Samiullah Khawaja wrote:
> To write kunit tests for preservation and restoration of liveupdate
> state in various subsystems without triggering the actual kexec, the KHO
> restore API needs to be mocked by the test writer. The mocking is done
> to allow testing of the individual components or functions in isolation.
> 
> The patch series adds the following to support kunit testing when using the KHO
> API:
> 
> - Add static stub hooks to mock the KHO restore API so the restore path
>   can be tested without triggering kexec.
> - Add helper function that can be used by the test writer to check if
>   memory is preserved in KHO tree.
> 
> Finally, it adds a KUnit test for the KHO API that verifies the allocation of
> preserved memory, and the preservation/restoration of pages and folios.

I looked at the tests for preservation and apparently they don't add
coverage beyond the existing KHO selftest. How hard and/or intrusive would
be adding tests for example for error paths?

Do you have an example of a kunit test for another subsystem that would
benefit from mocking of KHO APIs?
 
> KHO Kunit test run:
> 
>  KTAP version 1
>  1..1
>      KTAP version 1
>      # Subtest: kho_test
>      # module: kexec_handover_test
>      1..3
>      ok 1 kho_test_alloc_preserve
>      ok 2 kho_test_preserve_pages
>      ok 3 kho_test_preserve_folio
>  # kho_test: pass:3 fail:0 skip:0 total:3
>  # Totals: pass:3 fail:0 skip:0 total:3
>  ok 1 kho_test
> 
> v2:
>  - Move kunit header includes above linux header includes.
>  - Use the __kho_preserve_pages_order() to get the order of preserved
>    pages instead of open order calculation math.
> 
> Samiullah Khawaja (3):
>   kho: Add kunit static stubs
>   kho: Add helper function to check if pages are preserved
>   kho: Add kunit test to verify preserve/restore pages and folio
> 
>  include/linux/kexec_handover.h          |   5 +
>  kernel/liveupdate/Kconfig               |  10 ++
>  kernel/liveupdate/Makefile              |   1 +
>  kernel/liveupdate/kexec_handover.c      |  63 +++++++++++-
>  kernel/liveupdate/kexec_handover_test.c | 131 ++++++++++++++++++++++++
>  5 files changed, 209 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/liveupdate/kexec_handover_test.c
> 
> 
> base-commit: ec4084bc445027a52f600e30a976928be1ba1950
> -- 
> 2.54.0.746.g67dd491aae-goog
> 

-- 
Sincerely yours,
Mike.

