Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38087EA811A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6596B0005; Tue, 10 Feb 2026 09:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754B36B0089; Tue, 10 Feb 2026 09:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FE46B008A; Tue, 10 Feb 2026 09:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F04B6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:00:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA759C17AB
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:00:28 +0000 (UTC)
X-FDA: 84428706936.23.E084D89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1DD20C0014
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:00:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PaeJ5Rit;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770732027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4XVuf7fFgdxotUQ4dcsKJCk8Cgp4ZE7n0aGFDw1tvc=;
	b=xdNG3Mx9JQ2RZeSQS02HiGMOhQfAAAC/UraGNlMWEQXELJ4fA6Vr+ieYVce8M2wz8dzX3x
	Dpqv+mrh0YbiVh9R36e+u3I+DAV5xktE9wh83k38sZ1bGxpNyM79F97pRdLCoYB7fo9qbh
	2p2z0SISIj+thVIPVEjJZIcW8ddpS4c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PaeJ5Rit;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770732027; a=rsa-sha256;
	cv=none;
	b=knJcZUcZHkKG+iRWL6bJwNXim5c1lNhwS91iCFsWVA2rT9JHcl1uYl/OhIjMPzIjnUCz4Z
	DfcdZrFYHDptPWeBQ0jvSjBD7yAr9MgmlZ1x6StDCqNESTNaHUmpHhUDQ8pSkzpjUv/PPE
	vTNkrO40DdU8mg93FTdRT4TVsW56/Io=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03D5344285;
	Tue, 10 Feb 2026 14:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2964CC116C6;
	Tue, 10 Feb 2026 14:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770732025;
	bh=Qw/RiTLGCC4XlReL7wouz9nXIOGMjkMZx2I4aimv43c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PaeJ5RittgcFyauGs4iFTI03D8aARwFnljv02mb/OI32cyBI880Z0Ao7pV1jeABQD
	 qPJaD63vKD/fQ30QyRvb9cIgbK+IKhGUOd0OAq1rT4luW3hdj+DJpKIEbOBsLumYug
	 2h/alC4i+oy8qxiZoguwXiJZL82N8Ac2i9ERsPk3wlncH01qZjgWXY2l6Cnuw5hBwH
	 nQbj/jZCWMmiiMt7aw44/RyA60jSugr/IJsjhVnJ5MnVJNDmaJj/AfeN1w86NttJqm
	 FRnKfSt/5eF6xGW5FWxFoyEbnEshogxwgeZKSNjcEE+mTk0pHdYV5PQVpTZyjAHtSv
	 z1qVL+7jaNHQQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike
 Rapoport <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] kho: add support for deferred struct page init
In-Reply-To: <2vxzecmssnxx.fsf@kernel.org> (Pratyush Yadav's message of "Tue,
	10 Feb 2026 14:55:22 +0100")
References: <20260210130418.297153-1-mclapinski@google.com>
	<2vxzecmssnxx.fsf@kernel.org>
Date: Tue, 10 Feb 2026 15:00:22 +0100
Message-ID: <2vxza4xgsnpl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DD20C0014
X-Rspamd-Server: rspam07
X-Stat-Signature: cnb1bqduxmw37y3ch3ajkjiwbbe8phgm
X-HE-Tag: 1770732026-718979
X-HE-Meta: U2FsdGVkX19mjYEFvYC+2x3tXcCoUlZ9c1HsL+vvQvQmplVF4BT91tRW0WH7Uvt1eS79L1r9S6khnvCodlsbzu6/8D9EwJnN+SRvnirxhjKFXkGeT1+dqVyMet6mgicbHoVi2lnXPFOsmeywXsugx5Hu7bE6pHOvIw5heyEV0hAIHIh7VvhMBw6oPscfOa5+a+qygFvS1rxQtl8Km3njqiI5b+2bUgfJVckESAEm+darBZrirroydwAvxhu90UNLDhIUcOGO2MHR5IfZkbb7/Gj3O67OZNzVfgZxfxwSWeZ0cVW+7SyJMCTFxGUemr5zq45BXPzz+uCa6fc6iz/Rv8l25+lYNhz6A1zsffi5+V/YVAlFfZPWmupYQ9mqi3VtbRhegGSPhsDjFo4d3tAZia0vJqXUNvgo5PalUcPqOqM9+vEZpD0epOR20v89SLAx/W+GPEsjoUWQ7xADeOsgYPj9hFAaoE9VlmGCMeFXHtSEnujVsDWd3Yvr6otff67HWuhGuC/zq+sua05DzgcfMlI1jEvi64UpLqhYH3HjZAvnKTiE/Oe4xqiXo29LjvcIlMzmAfCHz/T9h0gIwx7JRiIQtJzlo5y+Ct5QdCDBx9RVfk+ARw1jdMx6y5+nue/j8eSLXyrGCKbP9rN37l9A8OyQQM10MH+StNmDHXS4dZUjozl2NrIs0zIYDaUWK3PJRVz+gy3r1Rr5PSvNZBSLTlGaZM8nZLZx49LfLopsFzyHklQy9Xw2OV7o7uZ0SoA0Qxa6s9G2q1sS998D1qFdPZm2De0r3J502EaCCWBGI8NAC5TdXZO7gS3G/Yv7c77vuwrZcXPXqDFmAxK9bF4aB3bID7ob/w6/7+HWku6Aaf1HpS1Y56El9VufjolooRjxE7uXQQsWKilPDiCYMvaMqamXjmltOaNAlGPTz7gr36lSjmqnr9ZLFxWbASKnw4336u19jwsZrhjN3nVm4Td
 PMJ7TiWF
 SSgh/DudKRXHJ0oMOp8UllAwdY23Gow6lnnv57GFHvzfCSXfMmPLTffEEtmEYwi+nbs6ctubKjQA+nAz26/iZNhD3I0Hs4EJN5Ov73LqXWIyBTiAc69jCVPyJmUm7HplMlvugeJn8dH19vYXwqNPH2u85rPZJl+HEmGHUcddJt2Ohtv4mxIWbIVznD0ic+LYDQXBPSKv7pMEoLV5cUttX/ZDx+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10 2026, Pratyush Yadav wrote:

> On Tue, Feb 10 2026, Michal Clapinski wrote:
>
>> When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
>> initialization is deferred to parallel kthreads that run later
>> in the boot process.
>>
>> During KHO restoration, `deserialize_bitmap()` writes metadata for
>> each preserved memory region. However, if the struct page has not been
>> initialized, this write targets uninitialized memory, potentially
>> leading to errors like:
>> ```
>> BUG: unable to handle page fault for address: ...
>> ```
>>
>> Fix this by introducing `kho_get_preserved_page()`,  which ensures
>> all struct pages in a preserved region are initialized by calling
>> `init_deferred_page()` which is a no-op when deferred init is disabled
>> or when the struct page is already initialized.
>>
>> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Wait. I just noticed that Michal took authorship of the patch. I talked
to him and he said that was by mistake.

Andrew, can you please give the authorship to Evangelos when you queue
the patch?

-- 
Regards,
Pratyush Yadav

