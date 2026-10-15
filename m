Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C784FCC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94366B009E; Thu, 15 Oct 2026 00:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C276B009F; Thu, 15 Oct 2026 00:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C736B00A0; Thu, 15 Oct 2026 00:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF136B009E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:46:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6BC2C08EF
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:46:41 +0000 (UTC)
X-FDA: 85323625002.21.AC75AE9
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6498C0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:46:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbUFTs++;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039600;
	b=p1rxsH3UqDxIRfxGPbbJcYrhnuQeGboKfqGFmtyqQD0c/5/EvpyG/p8VP3rk3IMIiNrBLs
	iQohZBQTdaGz2Oo/elviBY+lyzcCT/E8ZAslOvzXUnOZiWBwRU4qpaig5hqQd+Dam0QazL
	+wanTnaP86Sc+9uaraDFDBm+A5fix4U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbUFTs++;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9CfiudFUkWUTBfc+CpZZ9afI/zwZEasEjnzQEqX9I0=;
	b=zmYXbQDfjgWHC5EGtAPlx4fjYTNmRB5PgEsLppfwEboiTIONiH1mMkW2dBY/fxclfsLsuM
	YASLjZsmK5yeNb8Qgx8xM6ir3+i5WqjUf4SkOnDQerp9pxLKqhbaub4K34N1xtWhnpnJk5
	QjhjMSOpAdRL4ah3UtxFNxkQO3DQx+U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xGmsa/vfdzmgR4inHm+nx01+1+CizJckEWu34ED7NnQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792039598; v=1; x=1792644398;
 b=XbUFTs++ueeUg6Qr4YyvsuNWFU9UoDE/y+8tWuJktBbtSQsMceW7d07DwvG4KHD481EiqNBK
 u3mtSyo3vlnCHsxbuVwfTY1lYbMouffRRfbtUG/ohEldTsNrsCzLlatz1gRV36XZPHjtp1EqVse
 38PcGAIQHdEGwTmjokfBMMiM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0fb9831d6411b311;
	Thu, 15 Oct 2026 04:46:38 +0000
X-Mizu-Trace-ID: 0fb9831d6411b311
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
Subject: Re: [PATCH v5 7/9] mm/collapse: name the per-table scan reset for what it resets
Date: Thu, 15 Oct 2026 12:46:32 +0800
Message-ID: <20261015044632.58880-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-8-kas@kernel.org>
References: <20261014171145.3292736-8-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6498C0003
X-Rspam-User: 
X-Stat-Signature: 6z6cy649di5dbpk1gtp17u3ibdgiredp
X-HE-Tag: 1792039599-543460
X-HE-Meta: U2FsdGVkX1+2Q+8hXKDouQsJR2B1w/6Q/yVZmfOuUBds45Q6NgutNY2LPxq360Ec/qrlFDhjvNfMRCZYumik4AxEOv7EzkBS4TVpAyGfXDuBEzk2TUiL5dWFXQikcJ1eyp+Bdk3Pt7pIjfz8oZTknr6PplQWJyuP5WAHxkpz+Wj1aARCNUaGi1wziVsj+Wcfs9FP/KkZGdb9ARNQk6EaqP0OtiVC7+GqibAi3vCOL98aTccyVXovxJyRTjlTGFTdQcUsEsULC26uLeyT6m6MrfZFeIS25f2/SozADYBFH3hWidVsiWcNBa5X52LmL9nfWIp9ZZHcKWmVEehOWvt+Du9PEk48DKwI5Mp8kxylxDyS39gymDXFtS6Fflj6ubL0yZ4//+K1pVVAId0Z9ElTdRUQNwvwoXZGMwlhWeIwdVd/1Db14W8n0RRarOOVXAw6ki2cAXabf+JSDcIndwi6B8bAsvNxYaMRxJE+RwUFnQZtq6j41S1YEhEmz8imUFo/g6sxQ+HMZun+DeMtdju/rR6Ct+9Vm6ujEzq0lap0Snc436kHPPtn8oAZZS84kaHAj20iOpLkoPP4H9jJawdojrgeHY4bVyXbOKssH1ju0WcoUg84X234hKNHw2QdH+6vuT4zIbpeBXSisP1HnUt2rfIBfFeVN+WfQIjACglqKGvdS83PVmxyJLSl5wGHJUk8GuLXgG5ePYwjKw5OwFxmzZsUr7FFnmeoUKsWCutq6KL1IseSVuJItmyyp1I4z8mz8M1CkRdKKogBg0HB0l7eGtkqU8OusRK7MYw8NwyW9/Sc/DX0NEkYLUIWM5WhgvI5BXcAg6eHHCDLtrXPDeYnAaGnDvybI4QScAbuje1fX0S5Mj6/vmE1f21uYN2ejVd+ukKg/z7kzegvdLhGQrL379ABV8MCmb4ixArmWz1Mw7woI50/fQTlIr/OS4b+qmx2Vaa/qr/KdesVoBuN4Fx
 HUA0cX8U
 5Lkvz13Qze1/DUv0mXDXyCyi1pFrzsPZUyiIkW7DYRKuMTw+SxukU7WRa2ktKO6W5tjB6mzMSqGDad+UsomXHfceuqiJvkSYBM2e5lIf/y11/GVtpHDR41y25Zf5A7xS9pHRmyCfKxE7ZrcTE5MxoL2e5OLVE5z9eDRtH2EmuzGKQsi3VCR/pI51uI9qWdQoRhEj3W9zIA5VO/tHcbsjhz6JMmTRm/Q0LPtyDqRum/d+GDYgdgVhTVtBzkCy5bu8L0M9Mpp3Wb6oyNxnYrVaBP3Ks6XIUFsaDpTdrvJrf6UM/J7cBQopabf6wDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:40PM +0100, Kiryl Shutsemau (Meta) wrote:
>collapse_control_init_scan() resets what one scan accumulates: the node
>load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
>every PTE table a scan is given, not once per control, so its name points
>at the wrong thing.
>
>Call it collapse_scan_reset().
>
>Preparation for giving a control a real init, run once for a whole series
>of scans.  Two names a word apart would then stand for two different jobs.
>
>No functional change.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

