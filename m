Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DD8C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5022B6B008C; Thu, 17 Sep 2026 10:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC3D6B009F; Thu, 17 Sep 2026 10:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3FE6B00A5; Thu, 17 Sep 2026 10:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBE26B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:32:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79A881403A7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:32:23 +0000 (UTC)
X-FDA: 85223494566.10.7AEF882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37A40C000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:32:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjpiprcR;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789655541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jl05X/VB2n88uxND/5yjViHDY91tVPj4RXTflzReqQ=;
	b=6QRhgUCInL81HqiuDnwyV/AGZF2LrT26kBPJtCQ4LF8ehVIZln3mdP/V2HPF3SXWmbG7BJ
	r4Q2aOHxiiKnyQHLHHBrqhq34nR5OGgH+D+cqdBa/gIbAg3NLGv1oiLKvCQ3B9wbOFMCZe
	nCof3rWgATtMrprcTx9P0sYz270AzR4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjpiprcR;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789655541;
	b=epq4JULYxtSgYiJFaJNzsRBht1O7S1M4D6Iw7JH/giVauM2MqDM9a2i6ATkNBIQjfH8zJM
	6xTjUjWTXAvdU8FzW2fyqzHB6uIxg0ZX4Mca9p2h5bYLDsbNvZGZjSSkOlDStw1MBu5UY+
	V4jvjewKIYkvzYIcLUQEqNDaMaFDHDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D289439F0;
	Thu, 17 Sep 2026 14:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0111F00898;
	Thu, 17 Sep 2026 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655540;
	bh=5jl05X/VB2n88uxND/5yjViHDY91tVPj4RXTflzReqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QjpiprcRqK3vCH4f4Etr8j638WmWy3VWyLBFZ724HWdTnUmUym27GROQOwWT9FVzF
	 d0qfaPGf99hEXcqjW4QeoCsyxsFMgG4WgVbeN/UPDOXXDXxW4xIGz2U2JKjqBhW7Ui
	 HrTE00kOTY7dl/86w75OHxE/joksE1TT4Iy1ZETiImJR9nRxAdzGd3HGuM1IcxOWNB
	 esxkPNu196OlhF9Akcj6/1sEuvMIB+AH6iof6oZYN0R5cZYn91N5sHxLrg2LC5MLmD
	 3x2gjfrlU36lit6F5EI3oMELGVIbwm/j4FJcM0Go0yRwRiH17NkrzuzXZKdp+iBHgR
	 QIbum1OmeN8EQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id D24E3198005A;
	Thu, 17 Sep 2026 10:32:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 17 Sep 2026 10:32:17 -0400
X-ME-Sender: <xms:7_mrakqOox-1DH90pxvy9rxQZ4HGBwW5qZjVtl9mFXq9p7N0V6lA8g>
    <xme:7_mramIYihn0xemjLPVSce-Sv-zF45ROyjeqCfZAemVagJtygloKr9a0euudsaL-n
    R-0BV6QLnGM2Cqec9p5NLe8cLmbb7ODT9LpOwROCwBt3n_vFAKRMNI>
X-ME-Received: <xmr:7_mravMkvU9BqVVKgyQZH9i99gxe9jAx-4QuRTf82fM5G4o_fwMZtMl0TbQ>
X-ME-Proxy-Cause: dmFkZTFbhvfv6QAxTKLX7KYLpUU6bYLQl9nD8TDfhuzlXvIEAstW1SJyoWTvfI54B/0oCp
    WrISYsacht0e+cZUNFLJhLNg/aQQGP9H4iKU7tXJROYipt8RGAKqklntwqu2rlbUszx//x
    6CXVk0VCsfdLLoCuotdaw+OD6+xHO9iMzDT91daJqo8GKzOp36j0AZIXyXk7+AElXzoGmI
    8Z8cneQVNE4FQh7S/R6PNAioI7nQgGwZxNr3VD2BjfGfcLVc6C2s0ZOW/IXvFeJYeBLS+E
    q3dnZlMQTM0hDyA5GYSvaaCp/mthujNxyjGWuZ4NwjBE1p8jbKJTn8t8RB2DtL+FfcdWi/
    fZbjvuf+15ZSrVTu1N21l1c+DnHqqfIeO/V/x7dLJaCvY9c3xTlZZmvYXoytqWr0Ad7sqZ
    c0SmFKB2hzftKYY9UVOKEbA11CUqe9KjluTeDcltspGgP7Y3mlZK0Oa7CDKiwHf30ILBdY
    deu/+BpjQZuk7885gubB8sH9Tuwx8DuzdYPKIObNUrdCsKyBnXW2FdblRZy/cv0pPYered
    ukGtBxhEo9dkvvXlgOLiewL9VbsDGBIby+HIqxZMZKFWrHV6frGCi8KG6UiiOIv++tRrLL
    dkmctRz4OJO64A2OMJckjLWSsV4AqOm8XVADFf7metkvGzkxxQnGqZ7HndzA
X-ME-Proxy: <xmx:7_mrapriRuN2AvBtTMqFElIZB2NMUC5cCSPp4d2Y6FS8KgOgr9du1g>
    <xmx:7_mrapEdlzmZca9jhprMtb3YVbYaRC5IKyiCHMOOsxgm2kg03CLJCQ>
    <xmx:7_mramKY5GfguctbBD7FsDKjDa-8_vrYJsHIRO2qPMhRJjwbLq6hPg>
    <xmx:7_mramiG2X0Wanrk3goNhv_lrKSuBFlcTwveHu-D0I5mXkGhvJVawA>
    <xmx:7_mrao4CBEeLlGjcS0PXjgic62T4IEGwKeftYYtdE_1UIfBI70BBPdBX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 10:32:14 -0400 (EDT)
Date: Thu, 17 Sep 2026 15:32:13 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the
 huge zero page
Message-ID: <aqv5r6Ar0vyKXa_x@thinkstation>
References: <20260917121010.60966-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917121010.60966-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37A40C000E
X-Stat-Signature: qjbb5bpog1hppws4pf7mnjt8qxg1b7ij
X-Rspam-User: 
X-HE-Tag: 1789655541-923613
X-HE-Meta: U2FsdGVkX1+pOAx8HLEoJJSa2vt+RftHYMwLn3IvuLHu3xXRoMRc+/tvXuzyB6PYZe2u2sEeKZMGLP1oO/2XONYMrWkHC3UqzhEPJUU5u29tgoWCjpIem4yj2jybACfZp0ye0aK9zj1z6Pkt2ugI8gaGVYq0Apt9kshucldJdDvG0VPSiOtStDmI1Dal/yM1PgWo0/kEdVvCdIacB/e8I7Cj4/8uXo8BGM89XtWQszV+SxFF7pm9LYSShooVhho8ANCUeVbitmrVt0NRNJdtYiDtVQi7i8MzzIR92tT1CrM0qEN2aqKfjrxOC8vfH9Kuuofdu2NF3Ugq3QQdBtWugxzZuLCHF6Z48BkKeC7/x+qR2iUfuk7IszgaIVBaVdzgR7k1oOKdDC9Jk4s6jKJC+wtqDR0XOIqIK893PZAVC2ozlu4eJN6Tah+P7MesMeNJjJw33Ma9kvGqi5Cp0QxN9yjW+MfL6r0Wv/Vwz5eRvlJdiq1L4QkdBrriKXxELJ3FAEyVn+4ewAcNiV1nEmNepwagDSwmBolTXzf0QM1DfeAcuZhmTQYXT4hNaFuaK/ydjBEZtwpLSHwGJjTYLIOOZvWrAwMdjpiRURlI/eiNkjEWX5gfcuvqAenwkMQbAgZKXi5U3FabYE7UgR26iqVIBbRirvWf1eiQGBAi0gGvLE3AZZyc6oZF1cg9cnd4wcCkLbdvoYgv4GJBFxWx/BRAqe+ZnA6RZ2CX+DTNM8g6UgUSkqbv5OEhP8e2k7KCi0IcEa0zuKoEoJPdYglviZLSHPcP/SwGHqPSbWY7vppYO6AVlCTsqN5sCasSl0sP67ehNxlOhn/NYSuvYvqHWQI5RFdI0o4Ci2MTxec1gA3mxeCf4Tpvd6q28gpDW4qiNPWW+GF54zZ3WS2yfIswu1n/6Z7qGHrXW53Nlc4iCv1B5/ZoaTXAxirX/Uvcs8GT2OPdlRlCexEDXyZJDN8WQdA
 Fjvx7ttM
 EIHoczGP062iq92qdjiAjbKbwqtiKXneG2RVNheP55KkeszwEInuZN1+pcA0LzLi8Qj6QxT1AMC1S98gYJZk+1Iddhn+Ky8N3ReJ5jT8UW/Uq34zQXlX4hrsoaTr1sDcxoiy6+zjrUOF3j+C4O0uz1vxYBo+KEVtGi3pd6d/gxnsZFusltFZiJ3Ed3jI25jWMutZ0oFcqDCiBYzRCndpgwFdNrHatMuGIJUVoUCtBejh5iZDG7eIPn7hrVjLOHuUkfYzia3VJyq4LKkqeayeELbwGuvUcEbBnnGPNod4skI7F0OkaMTaqwDJ6GAeybonAwZm3K7WgJEMYHc4lweZ5bwHzlEq7UrF+xphN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:10:10PM +0800, Lance Yang wrote:
> vm_mixed_zeropage_allowed() validates zeropage insertion into
> VM_MIXEDMAP VMAs. No in-tree user needs to insert the huge zero page
> through vmf_insert_pfn_pmd().
> 
> Return VM_FAULT_SIGBUS if vmf_insert_pfn_pmd() is asked to map it.
> 
> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

The patch looks fine, but don't we want to cover the same for non-huge
zero page in vmf_insert_pfn_prot()?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

