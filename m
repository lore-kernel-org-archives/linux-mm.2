Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03024EDEC16
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 07:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358646B0089; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3304C6B008A; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266B36B008C; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14D4D6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF938C1D01
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:01:24 +0000 (UTC)
X-FDA: 84507484488.05.5A746A0
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67BAD2000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:01:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=duemrzHH;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772607683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vNYqlqI1PuxFEU+nd+vOm7pceggsvGmOnWy/Uj8/6+s=;
	b=XVoE4iYEscZcvi1mtmC054prumGBpG5nO7UMJIMrzbdVgZLdkVuQJ/w7bqxHyCAGpmVQU9
	yVteKOkCjFM3oPVgTXbE8uFKOqc2QqvqlONmrZbPGgBnYfNZkm7JOKjQqMbr7GWI1ZO7iK
	ntVDUXWaUsPtkC7QUr8YVByZXoM1L88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772607683; a=rsa-sha256;
	cv=none;
	b=6a4M90QvKJL23zKeerdElkHvvQQDPBUdBsGq3Xma5Ld+RIYpPQdOdyiKNU4xdt6noR5cE8
	Ny/fQ0ac2bn+3MZLC6vBO2+43HQowMPXmtu76Im5lMmuHdzknTvFLroYs/ZCunuH4SuZQv
	fBUDuw6oRVq+ryy7pPB0JSJHAOjDH9k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=duemrzHH;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772607677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vNYqlqI1PuxFEU+nd+vOm7pceggsvGmOnWy/Uj8/6+s=;
	b=duemrzHHbB836XiAnLu4M57k46k6UZehO61iTj1UWn+3M6gx6c+jVClvIRvisxJqsLSRq0
	C5H2sPRiGnuBdxm2QpZZ6qwo3wWPRHMOwsoYiIjLZP0yH5XR6PQcn0r02zU8r3Ay/2ePB7
	g0ZhOMv5f9XbFUDAWI3OPcbOP+WFWdA=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable 0/2] mm/mmap: fix crashes in dup_mmap() error path
Date: Wed,  4 Mar 2026 15:00:55 +0800
Message-ID: <cover.1772607155.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67BAD2000B
X-Stat-Signature: rnzckzbfhoezmi5pkrfaraafazi9h8rb
X-HE-Tag: 1772607681-155118
X-HE-Meta: U2FsdGVkX18AhbjnNJVH8t4CeEkuOl/+NgHOOMrk8fAbVO2qG/eiNU92pfgZYGUcUkyHqU8EOsyu1nvpEAsrlmnDXcVWfIGMquAyp/TdvdTiH61F6r2APNSFwh5gB/yaSodtmpdgR6/4pgHFtcSEojcTz/m3AujNXjGiuA1RV0UxgQAFI+NNQFDiC9MfMqFXy1oyGqsoCIXHCGPkyn3ZJQ21ayX+0qLL76F/MIFuzCQXpNXu5K2hOwWWTTWBnRaz6bOykb2NvXT+GiL0XFbsZqFFXBuUfV8/8IQ8HUSekkG6nDnFGpCr3v7EQYHiGFaMC/unfHzFtQJ2TvHbVvXSRNMJ++h0dFhdykl54GhVqs5gYfTprvVWZeBgFZ7WzGHTOJZyTMfw/xr0V9dc9UENm0UocPnDPAwBTw/OJzHyFBIWRVn8q8HEh532MB8ZTGylWjUEcftV/zCc4W5OWZpBsUbpZoVrG02d2LAKV6/BRGAJYnVUYLWnMqup6pHecqW6mdzDyvCqw37PT8FcY78TiNLZoCTYaOB04mAgEnZp5NOGr7G9nk/C3LlyA2UvDKzvcwGPcTd1RAwj7DIxW+4L6bP2+cEo2rCThpC5qfBTnlJEsa/V4mRaV4YA4RgFKfX+KdS/gbVn2pgK4m/qEMYg7nHGMvxyUNhDaahHbSw2Qk7Q7rbcCT0MckzLG76Je4HbwUPXeGweNqL1q+N05JDq//P5Bq+chHEn27lqI0LOZ1iVKPEjy0vp8yURGaFemQGK2O8Nu4GjBpj0tPpPnavTDQbLgIqBMLeUAA9IMvRdbPTZ4dKAIcNI9Rj4dqvTVGLlpPNZYverTH8Ps5ZGhSng6jkOQn7LjZnQQY9Hqiins4CrT/E37mI13+FK/BaSjJpBXTZ7UXCv9QMm/3het8SWQfee0Q75Nwfy1buDDCr+l0FYBflqrhisxdmgpsOplyWjykHFnpgw3t+oFeGcWJu
 HK6BNdMP
 vus9yb2N2AjqMfsJI0gJzUpRtjjRjnrgBXhjJ3qns285cXfmUsYppR68rnvhcXw7ByWKBwaTJvmGojnTuY9CPzhzuWI5yxsfmBmE2XKVIj7w/QULZdEqPwxL3AwrvDmbzyVGnZSR+hfuDmApIaOjnMeF/tQUppr+A1RXC6JXLH6TnFJ2r5wMgNCYEWz1HOq3n1S/arYYxeR3EncU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

This series fixes two potential kernel panics in the dup_mmap() error
path triggered during fork failures:
Fix Use-After-Free: Moves vma_iter_free() to the end of the cleanup
block to ensure the iterator remains valid during rollback.
Fix NULL Dereference: Adds a check for vma_next() results to prevent
crashing when the maple tree is empty.

Hui Zhu (2):
  mm/mmap: fix Use-After-Free of vma_iterator in dup_mmap() error path
  mm/mmap: fix NULL pointer dereference in dup_mmap() error handling

 mm/mmap.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

-- 
2.43.0


