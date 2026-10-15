Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270F2CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 05:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E3F6B0088; Thu, 15 Oct 2026 01:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EC56B008A; Thu, 15 Oct 2026 01:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44B46B008C; Thu, 15 Oct 2026 01:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4336B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:39:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00B451408BD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:39:33 +0000 (UTC)
X-FDA: 85323758268.27.B2AAA0E
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf11.hostedemail.com (Postfix) with ESMTP id C911140005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:39:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=plnongdN;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792042772;
	b=zRP0KfR984A4c2UwjQIwyvbOo0TDYudBlSoAb+g8qI/926n2gGMpTzAqAUc7eVb6KTOMfQ
	0oSM5fsNVmrLYjWsq6fu/cCWgX0SFHOhirFKtPOG2lRM3D8sQRUIEKITFLoVir6j9X/ezc
	PNFx5vjO1VXfb/jG8AEVQ6eumreTtIo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=plnongdN;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792042772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiEpH24FbFqexA4eOSCbXbTMRlIRrqeyfIEf1kRH3s8=;
	b=TLkN0wk42MPCflbHyYV2kgCNxrLzsq4N4g1QHOMTSGyv1+7sUFeaEl+vJuKh2NZoCeBoBt
	8TJKT3m9sGiqq9KEARxP6SrCmxAHDv36kslGGqJeXxxkrIXGegYBrdc0ti7wLsvDo18vTb
	PaTAfrzXv3fcXie3envTPMXbZDzskqo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7FbM2+eg5UOfZmuq9hM1PptzWVaYqJbij9uFNK5DEfE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792042769; v=1; x=1792647569;
 b=plnongdNlx/ABXxa3ODTNMeAa9/Ne7seuCIHHmuMvF8xSjU91QiUZkvIHCR28Ei+7C3ETtMH
 f7YCkRrt4N3aXa/cmMYrJ/qVmdwgvBKTwLllIxv6/V25nxQCXh/Q7VlF4+z4t30UsN8qU2Uy2q5
 ZXEmzh00Kbkh/ClF0/f6FY5Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d9d6b683631b8ce6;
	Thu, 15 Oct 2026 05:39:29 +0000
X-Mizu-Trace-ID: d9d6b683631b8ce6
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 8/9] mm/collapse: call collapse_file() from collapse_single_pmd()
Date: Thu, 15 Oct 2026 13:39:20 +0800
Message-ID: <20261015053920.64675-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-9-kas@kernel.org>
References: <20261014171145.3292736-9-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C911140005
X-Stat-Signature: tt6dxnz77s6dgqaucqzaed9k4k68pkmn
X-HE-Tag: 1792042771-869895
X-HE-Meta: U2FsdGVkX1+iChXAzURvMiuSrr3iP7oyTMnjjf3O73kToLE5yjmOudreV1ozhARO1nWpxPiwRmP5++9Sz654gf9dmEv3wp1iVo4pd6h91m4OIBa2KsZaeboMZFyrrUVc5zoVfnUaY3iimEpaxHM9EGELWpdv6ugSeZzRAnXbsWSsITKzjibu6ZPzPptOW1eftAWwrFXAbEqtsW05sslcG4rsVuKSOcQ3owmKpt8QX/obh5HxOhau7FwRMR7h/dhVse7POsVKZ4V1C/Gxj274BPwE/z68tYkN81vaFBVJsU7Y5//maCSSlHxjBGXT9Uzqhw2k4Q0MEYYAG8m+MXttZIz8+7zO7FPbsxmiCXBe3zd7iDPZ9/iiCtu/7i6nXmGwe04p9vKEOpWnbqvXCjE9ASKAJTo8cmoe9P6WC/Hkznhnw7SvpBWDsL9u7URqNRjcOixq5mLgqdI70n77vDaWxBTk1pUINi+jhwqCx6tEfU5aGqFgwOoi5NBSQUvIWhXBKTIb2VSV3of305VhwOG5cBOWpOulagOxceb7+0hxt7Ogv39nli+fe7GSK3jdQ4ju9fNn+c8kiV5G4aKQxt3ZpR2p80CuV2tJw2+zlQOpqHz5CQrnuDKs/J7JRD73/htMmB6hemMh67SHUfRf9+tWBs85A87ZtlVbPSCedlM9+TOWbIcDp6U1eW31j8P5SV9Ju+0ZGSjfnU5YOHJDzA6zeUG6tqbX0i41SckbLMwi2A8R/IrIeZxyMuIVy1obezoEeLn8PJ1UtIJ+DGWTwLnu+8e2HubtyKo/Kg2HWoeHzYCMSHtwEo2s/nmB8MlekHCPrGoLfke53Glm5996D56n3WCRgE2WKX5n+0u6laHWkxmf8P3G+VeF9cG2HRq3J8Sfi5Kc8gRfP90LTpDw+D/wB6Qngz1asKhLrC9zAu1E6oUOl25LPPykdVjiGmoR4l/Y4vZ3n956vwXXwkSat1N
 tgvPZnDD
 0A4gi08GMNIKD6RiHJmHYIvZxJplxszYvpUn58wDMmMqt+MLw1z6jZqW3xIKSjVIL2Dy0TW1UJkRFVegpZvlEoCezP0xo/4se52+Jy8amp0QfjsleKAzqIDC58Xg1/aSqffQmBMRjL2fuHfXZqPyWB2lDBo05AccfyDNHDLgDvKES5mddSqqlYWiBvOk/jMBaPD4knEM/NdjoVwqT4KwR0QG0zJiuhTX5yIEkZwv05z8mzeOtMC/5LtVVj64CyIUBA13yFBK6l+OscY6hZiDWCSqRzGBy90EZ82b6EIrzPdpCLHyklvcF+gxim3UKPdsalWg51hnJbs1jJCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:41PM +0100, Kiryl Shutsemau (Meta) wrote:
>collapse_scan_file() reads the page cache to decide whether a table is
>worth collapsing and, when it is, calls collapse_file() itself.  The
>caller cannot get between the decision and the collapse.
>
>Move the collapse_file() call up into collapse_single_pmd(), so the scan
>stops at the decision.
>
>Two things change with it.  The writeback retry re-runs collapse_file()
>alone instead of rescanning first; collapse_file() repeats the scan's
>checks under the page cache lock anyway.  And mm_khugepaged_scan_file
>fires before the collapse, so for an accepted table its status reads
>SCAN_SUCCEED; what the collapse made of the table is for
>mm_khugepaged_collapse_file to report.
>
>Preparation for splitting a collapse into a scan under mmap_lock and a
>run without it.  The file scan has to stop where the anonymous one will.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

