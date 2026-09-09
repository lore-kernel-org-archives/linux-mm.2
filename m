Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3313C79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B776B008A; Wed,  9 Sep 2026 10:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECC66B0098; Wed,  9 Sep 2026 10:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB226B0099; Wed,  9 Sep 2026 10:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B422D6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:43:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDA30120252
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:33:48 +0000 (UTC)
X-FDA: 85194467736.04.37FB1A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5913BC0009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:33:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SIxFg2GJ;
	spf=temperror (imf10.hostedemail.com: error in processing during lookup of sj@kernel.org: DNS error) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788964424;
	b=KB/S3iPJb9VdXEHlFxqwzVYnCLaje+dbQ+l6O4KU1m9R5EsD4eSXhNbVtTN0irWmhxcTsu
	kveRcQPaz7q4GJZw+FvAD5cR4Y9RSN1c0xQB4AwzwZERFW3rC7wAofc7hWo6scWMhmazCs
	TanxJZ9hT6zwVZdjCITSh8/ZuWNoM0M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SIxFg2GJ;
	spf=temperror (imf10.hostedemail.com: error in processing during lookup of sj@kernel.org: DNS error) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTRdU091dpy9ie1NZayq6OITJdUQdHMACGQ395O9E7Y=;
	b=7s1TqTsMpzPmh98H0KgB9sBIYwgsjQVrfZq0Lc9zbU2L2/E6PybtNpyCGm47QO7X96uFUW
	bwDoEwf1UdlbHXexs3R8AVaNDiEzj9FrXGc+VLHvXEaK8yZPSmDWCwYuLGuNCJGv43wb7S
	mHmA639pI5a3vWjlBq0Bf3VE6JsJjh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB5FE60211;
	Wed,  9 Sep 2026 14:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0851F00A3A;
	Wed,  9 Sep 2026 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788964412;
	bh=uTRdU091dpy9ie1NZayq6OITJdUQdHMACGQ395O9E7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIxFg2GJ8mdvlSqplV1intOkApf2axIOQmnD5RnflT3gBSrfRJjoEAhQdG8sORshJ
	 dFRxU+gt90nyJOWk8GbNkrNov1IrzR4nPBvUTdNG16hAPstoLI9+lWyDViRry9ionD
	 9c3xgBntebDbwQ6hKpSPLSccz+Jg2kyusKkw1TLlzgYYumtQ7m4evbpYzp8Lv8sVVK
	 UO83RB7cfHJXWJiQ9VedVokOOMVqe3HWibP9e/W3j3L+S0aNkgGGD1Jl3VJItqXNt0
	 O0Z6RR0sOD+yW83uGsCc9HA9kdTCa5rDEbFF1m80WQd0F2Ir9c6RSp3sjx5v6F7l3+
	 v0XkLE9Qp1ERQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Wed,  9 Sep 2026 07:33:24 -0700
Message-ID: <20260909143325.106813-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5913BC0009
X-Rspam-User: 
X-Stat-Signature: yzkphnp6z63nuuft6134epswgbdaxd3n
X-HE-Tag: 1788964419-161013
X-HE-Meta: U2FsdGVkX19XAcvkLSbToOog0ABooKjuSNCdpWc1EcE9+nvPtV0X0az/lxqJR1FA51t04UA4b74qButf8kYFJaTsYM9e7Nq2N53LEGbi2nY5FLhilWvyCJVANI7R4zAGj7h9eg0KX4D6mRS4HNkZwULOtOSJBsOkQVKHvkTVNoKRMRZcuTVdbvrrggycCEVyiJyMZ0+p7vriHLJ/iunGFHv2LZbOBGwlbZg+i8u6eJ3jtsfLbI5btQDwY6z3vUEFr/EBcA7opUpKf3BdcPYgMenhqp5XsA7cFRv1R/00oPmERk+ntMnc2j/JFREFRkhHBuf7V3j8GgoLQm4GSBRmXRBQmZrAIilpgmDf1Y2NNrGd/cbJZuYvukqM46j3KQwEy1ksWQlmVFn7JFk9/MSKIbf0ibLGS1lQPyEXxK4f7l1Jp0VM6fJJdUWe34IgaCUsH+iXCd09IOqXMxUBahIPZgvK1dq/1aaPvB7KpPZM2tuoe/qs4052pDEj9WNz0xo5ZbNhJiI6xgR2wl/Qs7Lj3xYnkkWuHt7aWzvHZWlUwNJvks1slrqEMV3J9rIoBuiNRfZYjdAB4FnwhhALJcKAwgpVuXpgubxeApZfjNhWbd1PRmgsZdskmkEHnLQ/g+HKcIh3/oYNgC2/3vtzWz9gu95dCMX8nUyhmcjqcpCn2OJ4F2ARxBmjCQIDpo+dVMU6WrhdSwooSEGnMZNjo3LqaZlFmyV7Zj45ORex2zky2s+U4I55miR2wZm4symWZwq/Ch26isxTqdPhK0ZethWje8dx5Hb5M/CRnEgTy5LMd6DfThwXbd/pwjyYt3idKk5vkgr+Acd8btzqt2ZA1xDh43d1WhcBOLU8/jd9DZUMlhRwyUFRzV4bVagNAUH56fprN8QRVDCPOfBVYJUcCnCLHv/5XDmX2XaWrfe4iVQppZFY4QO3bfYzZj3zDRu4gqDJ/ByIdoA+w/TjgWj/OTs
 bhMHd6B4
 q9s4DK5cFFwrS6F1mjvsV9ctx3BWUKmJXa1NrviAktGdsUQ+ZzJ7RMUNVejLuAljs2Gpvb6O2+lYDpBfnJb4VpxtWf9zsjcyf7KhxlSrHd7qNu90sz/FpIGs6L728Q9jyX5jC0tbH0s2FfB5B4dV/qR2Ht27H4zj1Wb5FzhB2WJaxz6bOrWPLEQrdQ+AvE8Y6KBsCUX3yIiZOmnwtUxIONhmFVY9/P+lSdYjskdpg2pSLaNr665A4UNCIVwj3vykuUjscfV7wBpA1qS64XcQ30ysAjQq56U9HTKm0Q/NQt2PtavAbnGMfciaEdVuvUVocH31v2XZbnYyFPQRNtTx+K3ogrubH7+ZxpvMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 07:04:02 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON supports data attributes monitoring.  However, only the physical
> address space operation set (paddr) is supporting it.  Add the support
> to the virtual address space operation set (vaddr).

Sashiko found no blocker for this series.  Sashiko send its findings to damon@
mailing list [1], and I reply those if anything needs to be clarified.  Please
refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

