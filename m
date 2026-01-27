Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71678D25959
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D876B0089; Tue, 27 Jan 2026 02:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E4B6B008A; Tue, 27 Jan 2026 02:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82216B008C; Tue, 27 Jan 2026 02:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B76076B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:32:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6138E8BC19
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:32:59 +0000 (UTC)
X-FDA: 84376927278.22.0012A63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B61E6180004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:32:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hWkAIVI6;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769499177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1IAoLAKw2Vg0PzPanaLKZXBk7NDv+OxvP+pKfiIL5A=;
	b=gWOq8J66AhNpxrDzzQVf5FyHhZvctUuzQdZeRtDQ9ZOl77p83h+A1MthPmG2qsjQd1XCj3
	jC+zLiq+z8R3kftq7M4W7VTBfZli0Yi1DB3CZSR6CuikHgLp4dfehHyM1z383D7Pn1e+sl
	McYVCDWMLUyaWD+KZ0dt4VzxiHcndjA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hWkAIVI6;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769499177; a=rsa-sha256;
	cv=none;
	b=rM/JYVTq045WNefi8p25FZJod/AeuBIZEEus78RP6/GctsMn5avgnvXBpQRXjvzNHOVrok
	aLPCiQGCDlo/IX/Ao7fQDqJXfBZ0lZen73FcIbSLi+TG/Xq0h7DMhBxxiTcPvmd81vsCWv
	M7PWecq+5wZ/sqDsmHgRVaa+fEw5waM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B029241976;
	Tue, 27 Jan 2026 07:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938F7C116C6;
	Tue, 27 Jan 2026 07:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769499176;
	bh=mcYw49oBRDHwBRsps1hLbRA9pNvVL7ckmnD/EZWaycg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hWkAIVI6JJWgtjMbliTTZz7rAATFbBOFtk2u9m62j90Alz0nkLkJ/kF5uCEnurD1B
	 71YoP9EcyxM0LL0aKZykj6W+rkSAU2mwAg9ZAdb6TWZpTwL/tX3L9iUcrmUsK2rSoq
	 jATETtGfv+CbT368L+hBw9M7bByOThCQtxZLXV+O1qYzVNrsdVKRcgTsSKyLmPaYTy
	 Kc/VG8gWLWdUH+/WzkNnkYSUdE3QcGpFoizlS2cJ+gCC1RXOsnKwmuhw8aPXJWdmpD
	 5M7xTWGttZ/l3rb0Kcg557rRf/UWWMacrdpmTv3mZa4SZvn5Dg/bufstnzNx1NITjh
	 KhAKErT+Ag2tg==
Date: Tue, 27 Jan 2026 09:32:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v5 4/4] kho: document kexec-metadata tracking feature
Message-ID: <aXhqIDAPKdoXYme4@kernel.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
 <20260126-kho-v5-4-7cd0f69ab204@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-kho-v5-4-7cd0f69ab204@debian.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B61E6180004
X-Stat-Signature: rqhjsgctdcai8ug7ae76i31bi7dsqono
X-Rspam-User: 
X-HE-Tag: 1769499177-988872
X-HE-Meta: U2FsdGVkX1+WK4G2AXrCMKuEHqGnM7lbWwmesDIvl5s3ZYLwNbxE3s9I7Ab8V0qPKzU/VxQRysLGFLg5ukuqsKXDwyblThKc6k8tJIQi2qTOzQLBAfyhu6/tHhSQlWqn/hvvX75a0fZkEcm0XxJFTwMb8bFRCnhCnqrJGeS1o0oNJIaa+saAWSbFy4KjC6z8KKMFwwpGnv9wcDeFqEpWTb3l4+C+NfeF+1D8tZuXXiL7/gl1beifoWBSKgytscJlnKtVem/UcDzvU+IZd9DfCQD2OeXPpJ21A2DGYf2sdUM4VbgRNqPJGRDXnjYXUH72s188aJ6Qg5Id9ygT3Jp9vl8oAIVVVc5MRnNIiX+qMZ+AYm0xnbcHgCLQAOMdlZryibR8YCzzxdezZUytnRaPUc5Hy5HfZFQXsHhBly01E6hvh9l17HX0lEIqmN7JdTqiNlI05lylhD9B7/0G6aQW4nxqHNZ5X0s0vMwUAqoo+MO1Nwa+Wv2yPDp0ETRQ9kGQOmyr5Y9voA1THEeXJSWbcacrG01O0lwzkLYyDvueEMU1JZ34xMv53nuB+aBJJ5MqZ9K8uDtOfRBqimznAslyN1OwHiXMZPsdLdl/aMG7iILhLFtvmAj6bxeozOpi0RH+5DTGDzjhPJKi0DnRTGeEI2fx2juXRB3RxfCMrR9YK3wkQlzqSxdJXpka1mWNojzcH/wKkFAd0kp9Et7RNWZhNChrMkkd8aSrveTYRFlkjKcKLN8NJ0lrPW1M4A/L/mxKxgwP53nTAHkL/08pquita+XAqb4sRQqiy7Pj2kJ4WF07dKX7MT4TpM8sy38KBVDwKRMRVI48BURkgSs26XtCNi1jJWCJqBDyvV0N/g5K6e3V/xIYHvkKHpaNL5cEdtQw/j3clRlEck4AJU9Q2HVEQKql0gVSxM1ry3uuBk6gzyIIADXXCPzhkK56x0pDzdCVPAnxx8LGLCGfcpDcIKO
 5uomN/iH
 WiMYMMFZoJzi0w92XITSeRdx/wuNvi/7r32KOOLpYjamnBj1vj4ZcpRJBUtI1ffhafVIbizPy471CqpAl0NG+Qdz61G7IwHuWsvWRJ147PA5/dW3chwtTY7dxKwX7F7fO/U8noIqBy6rvtKqlhxxB4w/egMt07MAEV7ItbisxduUSqxuXoM8OfROVHfpiFIpD7yOqdgeha2wukxP0bt0pAQRRxArRecS3XejlIxRW3HY/KGeG03noWVmgzo+wsgiPq8gp7LK98YjOwK5u4S8VFvkMYkDhw+8mp1iNXBjRK+MoksM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 08:07:26AM -0800, Breno Leitao wrote:
> Add documentation for the kexec-metadata feature that tracks the
> previous kernel version and kexec boot count across kexec reboots.
> This helps diagnose bugs that only reproduce when kexecing from
> specific kernel versions.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

