Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCFACED606
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD416B002B; Tue, 18 Nov 2025 06:28:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E2C6B007B; Tue, 18 Nov 2025 06:28:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D166B008A; Tue, 18 Nov 2025 06:28:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 918A76B002B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:28:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D33C14050C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:28:30 +0000 (UTC)
X-FDA: 84123504780.14.61E70CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E79EA000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:28:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQLu+9rZ;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763465308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQuCt/2AXBUtG8XQE7BO4kuhqJFxjKrERJo49LtlSY4=;
	b=Hcf66FzpXCv9hXQWqC2LDo5y0YIu6gmhZvrUcLDMBgXCNERvRW2FTwKhHCxB3MD6GRfbza
	y4nB3clAmEA3nk5H2CrfpGcKkU8xDe8Fszax2uWZcwtfpc7kuU4jLNsXHeyOGmR7M5OZHT
	WdmsqdRVcj1j/f9sPuAfQ2TGplifba4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763465308; a=rsa-sha256;
	cv=none;
	b=DRiwglmVZORV1SatX9XCjsX0a99Eq6wYQ2dDwIINlIGSJQociNaMahqkz5PVqW4218Y6Mc
	zWJvguzz/qG3KoGn41ZVJzodsgjBfCjG+mtRawDN0V2NNmNV0AYKtvewpJ4IJ2oeK2j7Rv
	beYv0PvoaQ1rw+H4OnPsIF8dUOq8QGA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQLu+9rZ;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 17A7640AFD;
	Tue, 18 Nov 2025 11:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA73C2BCB2;
	Tue, 18 Nov 2025 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763465306;
	bh=B3Ck+ZeJMAqa97fGHBodXk952kfsyzlVaAaz1fhsUjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQLu+9rZRRAXOUo92WAJWcJwMQwCECdt5VEQNNd+yp5MfU6CT/SCqQGSMA1LzumqT
	 NfCkJGz3WVbw4jmetvEnNdBIZtFyXHwH0Uv1STbCTH3FpF6egZEea/8IThMQV2AnE7
	 Xva49r63Ie+VmHsEwIVC3bWqvEFIsND9oBQ2SEDO0+Ttol+YON6Nqe0C0GMP8C0p/x
	 nFs3/rjxgKCHsFSL3CWTeJs90Qo4ldWBUDxa8ow5mCspZWSwIXVih7aEib8XXJ+3jN
	 3u9YDrfXHY0BGetjelUPwh1a9YTF4bmTsULA+0awTrM4pf/hzkdGxtAY8qVHPr80PG
	 yj/Y/ua4PKjzw==
Date: Tue, 18 Nov 2025 13:28:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 08/20] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
Message-ID: <aRxYQKrQeP8BzR_2@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-9-pasha.tatashin@soleen.com>
 <aRrtRfJaaIHw5DZN@kernel.org>
 <CA+CK2bBxVNRkJ-8Qv1AzfHEwpxnc4fSxdzKCL_7ku0TMd6Rjow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBxVNRkJ-8Qv1AzfHEwpxnc4fSxdzKCL_7ku0TMd6Rjow@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E79EA000E
X-Stat-Signature: zo6pb7qt4abfbfx144s66owbo3a17xnm
X-Rspam-User: 
X-HE-Tag: 1763465308-930792
X-HE-Meta: U2FsdGVkX1/R00gCLRAdgyjR32EyVhLr5tpyLmRoIz6POS4ICagv2kESqUSv8TAwzFP9RGxgXQa0eo6b5HEZn/GaArG0KmWzyMP8wqAaWk8jXEXH0kgQIzXSe73a76PoS5P+pi8oG4O1KXfosaHXNnkDuFZNgskxWAeo31KNJBerPZnVRyHbA8aHRx4DODlBjNQJaDJjMnrtanrmj/KohtRyoHLvXQ+YzaoHXEq+Qv2Oh3n1sRoB0hdKwIyb/LsM/ESrXhfdxanSVj5miAKPggsYkB+h3i5Rw3ReByUvV+bbWs+b+dBvjtNm0z3ezs6ErFC4eDeSs9wOjarO5Ogg0rTfAJAXMdwHMpaGM+u21CY6r/VRyisMxgGs26Gupu5TKfXpg9/n1l5bd2OldzWEDPUIpXFAHJpC1vLGpE3TrVEXKk+c2OpSAqhesI+CiKsnymCgBrDZ9yl+BGyCLN6YGkJpeykAO+gPkGE0oKuezDKvP5hOVpu3gf3eytjZK39J+jMqLLy2qOai0yOEmqWuQszoPaLzSKRWYywJxgudsIVnzw+j1OgfqLgnJQV3YkoNpSfzeNAASlW9CQeFShTYcFXQatzeDFNpQDh4ObWvzC/rfbqSLZ402/PCu/eK49v0UK9HmRFQfCgN3YJkLEVKMKnUSZzmxKU+CTcM1I+6ffzN4nEq1WBDCkUsxl65cWYsFb6d9qS66e9VTCE1cxWzHpNMeKDbPqeFS6PiWKbu9wjSqdwqaX69WkoaoKNQR6lvSVoWlV6+WW9qC7L3inTaGKE1DDnXg+gPJRSgOuzNdCJwPCqJi5YetIGcb8dsaNKhUBKNyJoC6A2P9kRN8WcwSajooG8Nc+C5uGT6b6XzvbbldUJ/v8TehYGo5kBacQLe9f3Gz71G/IyKUIUKsINLbpHyshkktzbYo7hKGlOaSDT/9eEvwlXXf7gshbNEbScbjULssDppaEmvFrm8rgW
 77FcFXJc
 ifJk4ATRf0SdCzeoU6lg8+nbxgtp1upLvuOB9z6DzlJZ4r+tl1+kHsJPvaQ2giQNUh4lZ+XTZ6DSoDYfmTJpLwc6acOMPdTnSK/Mhv6NRgaTOqKbDYKpNbf/6p3SZLpfgbAPu8iadVnrz+3DNnKtNMkDf+94O4xl21rnEMRLkr2YZpbKDsbwsXK1jPRmChZeI1Lr6bXXQdsWTBU+lYxXNmLlR1ywsMueYX7DPq7pgLwayWVLVcLCkpnaPJPQXqZY1sw3HajGdYtZWCX/SWHLZbf2R0eMlVYObveT9uS6TWQJCIMUOOxLBq3OrU8/t7OXvxBTmFDHSp98ySOnQOrksKzZYQur3yfnjbxZH4HQr6A0s3Ltf/o5qOnTwxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:54:29PM -0500, Pasha Tatashin wrote:
> >
> > The concept makes sense to me, but it's hard to review the implementation
> > without an actual user.
> 
> There are three users: we will have HugeTLB support that is going to
> be posted as RFC in a few weeks. Also, in two weeks we are going to
> have an updated VFIO and IOMMU series posted both using FLBs. In the
> mean time, this series provides an FLB in-kernel test that verifies
> that multiple FLBs can be attached to File-Handlers, and the basic
> interfaces are working.
 
Which means that essentially there won't be a real kernel user for FLB for
a while.
We usually don't merge dead code because some future patchset depends on
it.

I think it should stay in mm-nonmm-unstable if Andrew does not mind keeping
it there until the first user is going to land and then FLB will move
upstream along with that user.

If keeping FLB in mm tree is an issue we can set up an integration tree for
LUO/KHO.

-- 
Sincerely yours,
Mike.

