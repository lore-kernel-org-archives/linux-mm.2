Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1377CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 06:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1C78E0006; Sun,  2 Nov 2025 01:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52688E0002; Sun,  2 Nov 2025 01:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68C88E0006; Sun,  2 Nov 2025 01:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCB228E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 01:59:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B29113BEA6
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 06:59:54 +0000 (UTC)
X-FDA: 84064767108.07.CB7B0A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B4DC310000B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 06:59:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0PownLD;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762066792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Or2j8a2oFpDwYNBj+OHrpTvt3HR49oLPx3Il3uEI3fw=;
	b=pk1SlvlXB/PEnuYPdLgHSgILQA1DFHTrt8pPTMgOU049HZt5cj2sObq1FMit+l9hf4u6vD
	/e2k+Lreg4c7085g1nIAgFFIm4Bnf0kYf2u4KWHuw5gGlYqJzSzuz2cTmouA4hbx4WtB6A
	Go5lrjSZXmuJzwBTvN5ToKTbOgI5maQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0PownLD;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762066792; a=rsa-sha256;
	cv=none;
	b=mxd/vQhLrFzx8YxRbpFv0UYM7WVg8faSI6H6P5HF/fw/ZgdldvMvGTXlFKK879zUli1RE3
	VQ73hu1GyBRrKwBKUweAQnTly7qh7Do8A6A4xiHUfpQ7agvWHLHGQkEh0Ht335mrQqzlWL
	jC9fa4qadxSyftQP+mkBsbboKDP8Tj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D014560191;
	Sun,  2 Nov 2025 06:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D057C4CEF7;
	Sun,  2 Nov 2025 06:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762066791;
	bh=tZauxRiF+oHUfUJ6HFpFdgYgUz1Y0O/xSwPp9Ax33bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p0PownLD6rGjXsR5XIoGxxmKz93L0EcSsB2xkR5xWsoLkpqRqqSOMUHjJ0R+fuLTB
	 ByR08VTC7i9hkxMWFQAlsLtgTlHE4yLMwwar8PzXUswkVkg2T872d4i9jwV+v3D23A
	 AuS4xQA5/uI/akctZZDL4roCf53ggcy71a94AHXnOv/UnkmfFyZp6CPnPY5tejMDI6
	 d36+6lmcxRdHvBU3E3BLj6bN4JV76TVMmGLZa5P8qamMP7A8qDfLIaN5mebYy5KSXi
	 Mm5fq5TAR+yxkz2pGV8R4kJEs1P7rtyy6y9+h5PXgW10BW5OGGMXOCxwKBGeTMGfq3
	 FAsr+Km3p5tQw==
Date: Sun, 2 Nov 2025 08:59:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 9/9] liveupdate: kho: Use %pe format specifier for
 error pointer printing
Message-ID: <aQcBXnYEzMhssa-C@kernel.org>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251101142325.1326536-10-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4DC310000B
X-Stat-Signature: 398deh1ndxbtt8ynxrjie4k995czf5fd
X-Rspam-User: 
X-HE-Tag: 1762066792-964747
X-HE-Meta: U2FsdGVkX19fa7qozaNTIl/F81gLIHrzkIBnFuqe20NqdD8VTABJmFbOI4698eUXkE3n36BLGWoOOFaN6PZsfNWVhTFGURlaRHKr47oE517fM0DKfC2K3gjJz8892Cxi682jylfUYoKtwiFx/QvOylzsRmLBe1icWPyy7PbbXebrO8Skdmouv0WROQ/0X0Me9YlGAFJcp3RPduQWonhZGSvvy9H5Rr6wiFwISFhWEPb0tyipLtAdS3AqZjDJi7NTbcNCzoRkxfXyGY2ZzxBYcaORuwaZ5QdM6ZjZRU4ftA9SAfatQfV8JcRc6ULYEItg2n4bVUeovYhpD2pEqFD1lC+bji7+PYfho/G9vDFcxhArgrPyKseqlqTwjDp/uiiYbmIS4gGVxazpJXa6HS6Z1n16lTamlwCTYyzrede7zG3TY4neNdMHJpt0OXg6vqmJ3wEwOdLDUbBNa023UQfc5xy2IYuAO0+ftbQyecPb8blGobYKn0IBWqQ5Zjo7BFX4iLbl1JDCInAKVBM1Cik6R/EShX0ZNUu0kpCOoOfgkmUgPKQ03GQYBHYkKuVbPGG/+YTeb1WubmuYXtzIEtN16bgz1oPf/58Ivdt1Z/MUKTi7agq92jyP2OYCCS6w+Ob2B2lecvVEAHg3vaki8ySo3/N/xEs3M078O2yhimMIpUDadtFQ9q+M73V7dKx/CTobx1cVfsjlr6qkvbFc222Qncae3dZaYBLC2HrnPqgLs7vKT/wOqFzk2aBDcfgncvdcgVYfERIIEP0wBLfCfKweVIyoxW8VioAzSQIHAk4rZwralqhCwfFFJ1hz0LAf9z9t6idYvkR3BowWJACIoEX3uDhCOQCvt5Rwt2DNHgr3zSmyaclZqR2cYVpfuAKrjpI8K6NdwXOsB2j/kWzhQr9D7A4phoAlZoc2VPOiduefB1rX461BTgyMfVK08rztSVZpQCTpoUvJk+POlKoEpVI
 X0G9NcFC
 aL/mErNTOjos64D/453lJRtfVJUc6eDiH3p+h7wVo34FX1WlnYoCdjNSjhuIqIbxM44Jx8/6eatYTBe3kLxivIVd1vJIvw74MG4CfCX3nG5r6yJ2fgekBI5lF5z/OcrObZNUf4hGae542MuNrNqlZf9QSiLTRH+qcTsFiOCwmEKUnKv0c8s3vsuj397AtHfXUMRdbObfSEPxeEjLQHImEr4fa7M6FhphzEICTxN7JNHhcQ8aW1yCbDUpor6cgeMSbGw4TgAQBZhy4kO0hFvzkd9BvlMDUQK/e7CaaiaoUH4Glhnk/06g+Fga/5Z05uWwjb7s89P+4sbdXLj1EWPIjA5LdDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 10:23:25AM -0400, Pasha Tatashin wrote:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> Make pr_xxx() call to use the %pe format specifier instead of %d.
> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
> -EINVAL) when given an error pointer created with ERR_PTR(err).
> 
> This change enhances the clarity and diagnostic value of the error
> message by showing a descriptive error name rather than a numeric
> error code.
> 
> Note, that some err are still printed by value, as those errors
> might come from libfdt and not regular errnos.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Simon Horman <horms@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover.c         |  4 ++--
>  kernel/liveupdate/kexec_handover_debugfs.c | 10 ++++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.

