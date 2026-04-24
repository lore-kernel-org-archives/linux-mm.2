Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE473FB44C8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 08:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227FC6B0005; Fri, 24 Apr 2026 04:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE206B008A; Fri, 24 Apr 2026 04:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C456B008C; Fri, 24 Apr 2026 04:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 008346B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:13:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D03D1206F2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:13:32 +0000 (UTC)
X-FDA: 84692735064.30.EF80A45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 078314000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:13:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=duXroG99;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777018411; a=rsa-sha256;
	cv=none;
	b=PdMDkNHWgcp1VBD3eC7q7iZ1y1bPl5+CSyd0MzB0tY9DEnyD9ltVUDRxH/rIEIuVQVH9CI
	SsRVn1eK1dzfitxJ8Dbh9UKI7lLNPmAtCgeNk/FkgP+LwY5bvqvHEC8MpjZkOZx6RUGevt
	Jj++MkqwuCrEt/I6IMTRhrbbgQ1nzlM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=duXroG99;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777018411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGjC2L6hANufoA3RSnGeIAyu8hxPE17bPaM1lac2RNo=;
	b=cVml2rPy3yahHnlcUDE9ubpBkSBwVWuAKehk8ts8tQgEn1ITDz5W0dWitXr6Oi9HKvIxEY
	HGkcZDfDQGuOTLC+W+N1FlNiVGueEQWYcQvk9YW6jarNLBqoSnIWeUIdHlBW1jY2Y84qm3
	I25XgCWGWb0U804/brGB+U9PD1a2WRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 752B86001A;
	Fri, 24 Apr 2026 08:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42021C19425;
	Fri, 24 Apr 2026 08:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777018410;
	bh=gPaqGDKTxV+aOLEHrXvFf3KAASbZw1FfH458ke1TYik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=duXroG99KOm/SFGEgJkDqLihKyrlSFgoyX8XwRKfhCTu0IPvAz3cStUxz/OraOAnF
	 TdPpuDRGmx1AMkTFaQOKz/DwKoxFuXaV6LBBd98Dmp9J8i0Ydyp5SO6FmN+6AoxwgA
	 A8J8mKZE/8T3pHRliaJs5NJAjrWX/BkxQfMgMtTkdUxqEOjAtg4jiJDjGxB70whsu8
	 WHIj03wqUin0NFYDpulAzyehTHsjgpYAwgXFPvFAp4gJzjtVmOMijA8+9uG1H7jyvs
	 1MyWSSxvzc1wi2YIN96ANCCy9SpzX3FVoFp7HjBJwFHKDKGo85Bd/KBS1glqfZlulB
	 bFE7JFEzJEJvA==
Date: Fri, 24 Apr 2026 11:13:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 3/3] selftests: kho: test with deferred struct page
 init
Message-ID: <aesmIbOizNLMLvVK@kernel.org>
References: <20260423122538.140993-1-mclapinski@google.com>
 <20260423122538.140993-4-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423122538.140993-4-mclapinski@google.com>
X-Rspamd-Queue-Id: 078314000B
X-Rspamd-Server: rspam12
X-Stat-Signature: adawb5j7usyd55bufef8sn4cahar1ijw
X-Rspam-User: 
X-HE-Tag: 1777018410-817811
X-HE-Meta: U2FsdGVkX192ldvwVpbqLqdCM7NzdnrobHfMV9/F+88TOalGDnd9TO36jEVF13Lb1IDTNOuQRFg5swnaOx8J/Z5IlAT2rQltn3yqB1WurkTJbn+5Q64mP+te/eP9VQM6ll8FHpv1FfOscz5Elxkj1KtQJAynHvibNGSPufiqyHTzQiHQLCMbkys+KL0EVSAOUfu2FDnL3PjkOjQM2lZULUdzHmpfXZgFnnbQopGMcs9TxanY6FiwuoSLj1eNNF2wHkHKEbswWgYL6OX1nAlcpjKrp+Yu2v36FNleh/KZfh5c4GriXsG+2N53XgU+ZZluLMvP4UuANADoIj71hqro2FFR4Kcg4sT/5gME25ZKgdmwcoaOEL6yovjnzd4+8XUINDeYC1T9Eps5UTgWBa6HFVhPiOY8J90dRzGwWgvMZfdTcdL58/QbRph3ocYBOmjHuxUJWo4nLq4dasYb0R1VgYc9+WxmK0HoL8TSY2Ik40TNO4ZOhQVjQU6cfFip0mHajcekH+NW5R9xpSstuZ/nD660ZFlpadKv5Od0Y6eb9gO3ZVnV3COBY8hEa+AFHGNADQOJv1mzZiz/n4e3Ag+PAtBt2cWLI5EcuUDITX3oLV1UoKjnUcz30pujmtdGRmPqv1IgldfnH/qviTBeAjZlh88JkN2khDT1P7Zn+neJP4iy6Rkg0q7vPKOfpUruQG+wQhn/SZdZEJaAKCbY+s0ZBqoDTinFNmSdY2OnjXYujkwwGOCsF4uUXZgn2eoKgoWed6a3A6s/2e5i8t5/KlpMpLV1FL1vrV1kvYdEQJiaM8PomYV8Bv0Idu8l65oPI0QZJxfmPCzcK86Y2BlaioulD0m7vxyg+P226inUbEprrrT3RYl3j0fq5jXwIIJB1CI/EGgrJIf/7gyQUbxg2x0/y3Hb44xjC8pOmcab7JFTyLc9MLlqqDcXq3AY4QeeYtLNvdyZ+GEdRlGIYg9Se9K
 iWJP6gXJ
 FwzkgZWy420F+GeAtpwAPe7x7yi0ehYXeqDvutwrUr1yy+PNZkqIMyE8C9DJUf+ph/d7o1mj30DaHng7JPMXw7pD1GrvI+DLA76OlBmhtxwrxm4s7DCc6lQTgeHoVVNAlJGCcegHAggNuxgrZ8gQHxP0bMjNVAI8LAvsw2QWIOlwmkBJoGgQy/O+hpnxRwXL+dP8zYF8dMF0B8/E2jB2eK8Vfh36TZKvfhWNMhETjxmQ1SQzBLEzmsD9G3jWl5tapkvOUetsHhg/Dq91yYM1Pi1ilIKiJXFOmJ/yCnvoTmVGM/6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 02:25:38PM +0200, Michal Clapinski wrote:
> Enable DEFERRED_STRUCT_PAGE_INIT which depends on SMP.
> Also enable additional debugging options.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/kho/vmtest.sh | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
> index 49fdac8e8b15..0014bd76e88d 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -59,10 +59,14 @@ function build_kernel() {
>  	tee "$kconfig" > "$kho_config" <<EOF
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_KEXEC_HANDOVER=y
> +CONFIG_KEXEC_HANDOVER_DEBUG=y
>  CONFIG_KEXEC_HANDOVER_DEBUGFS=y
>  CONFIG_TEST_KEXEC_HANDOVER=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_VM=y
> +CONFIG_DEBUG_VM_PGFLAGS=y
> +CONFIG_SMP=y
> +CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
>  $arch_kconfig
>  EOF
>  
> -- 
> 2.54.0.rc2.533.g4f5dca5207-goog
> 

-- 
Sincerely yours,
Mike.

