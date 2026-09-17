Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 698B8C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FA96B008A; Thu, 17 Sep 2026 19:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3939A6B008C; Thu, 17 Sep 2026 19:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB046B0092; Thu, 17 Sep 2026 19:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 063A86B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:14:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F1CFA0534
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:14:03 +0000 (UTC)
X-FDA: 85224809166.15.1E64378
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7DFB7100003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:14:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qyewUY1B;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789686841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7m4fIbqwauaPPsY8aeZIO/6ssj+ZXat6vWwGibVsmE=;
	b=CckSKbcfGEcfoLtwDCVk7vrpOQzOL+WVZjBXeCn+LaWNmLJYej2vwu2+5+qxTKZlbh0wdS
	qsjl7HHP2jDCOJaAkGqr9FRjfqHUGPOBCftbCH4iV5nFIUF3MovidK5ncOq1mwhvuPlNqr
	7pDkWlU4xdkaOb3LWujGHnjc+/pqApQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789686841;
	b=VZoZHIwCq404oskffJQZi/dHNXt6klTCpZx02qpK55zlbI/6v9y3Pg1aGdvJ74E6wJ0X7y
	Y+bun+J2egou8HbEJsGfoq2kOGzO9cXcgVGANYMVCTEoKS9UtPPWsz9PkNsK6Jo4mhtOVe
	dEnGQQNYXR+Q5KEv1ZKDYMCcmU1V7ak=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qyewUY1B;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A799A432BF;
	Thu, 17 Sep 2026 23:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3901F000FF;
	Thu, 17 Sep 2026 23:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789686840;
	bh=z7m4fIbqwauaPPsY8aeZIO/6ssj+ZXat6vWwGibVsmE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qyewUY1BWDTVEh/eLaYU+YaAnj7+6FrLDS94TFgAec978llcfygL0m44OnWkUHiIc
	 Us/4PEZKjfMShDGMv/6BS3Sgrob/jchWKHFt3wTIupsHnVbh4AZc8UEoproOrioiyI
	 BqUvKibF6GCOX3qcvslKTixmiKNREzhEbdes0y9k=
Date: Thu, 17 Sep 2026 16:13:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit
 detection
Message-Id: <20260917161359.9ba88d2bcab42db8111130e1@linux-foundation.org>
In-Reply-To: <20260917054015.23553-1-lance.yang@linux.dev>
References: <20260917054015.23553-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dxg75dyumcsf1ut8kxtjxs5wwox6rdko
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DFB7100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789686841-228675
X-HE-Meta: U2FsdGVkX18mnjklqvyElN3oprc3h1R9GWOR0Kg32L2dXwWWgrq+/QIVJwdSIUBcaPQtu6JMgXcu5070KlL7sWwgaP3qqomAyJGKsmRK5BmA1VHwfyNtxzJU/kPg9FDtTs6UarUj14pjYoQtrLULFqOmTMkArYI5113YUTw1uh853psDsJ8DckO7LXEHsvUAyvx/OlkmCCeJWusZ+FnG3DFRM+gPt48NvLFEVFcmLGnuSdk4SZdnzLafwQPaS3v+gwCevb+Y5kbqJchQzFn2ZtShTsTx4FfmBQcqhuGaRuBU53VNLFb2fIVxhBMjo7zkeiEw1DE3VGQt/BQxWfZnhFpdFwTb1sQ0fpQS722Qipg8dT9T+ZXW8yz8t0pZNDuPwHQhnw0KAgK2nVYazgOCGnH8BsZXGdwlhYyba/FmHO+EGCOjPIWQBNeDwMDzP/AWOZiNd27aGIyy8UEqyrWv699ZvLhIKYzpUNFwU+m5084lCHnfRlmdTVWF8/HlFhpSJrhC57SQR9CrvBnH2d8WGbIqeILXKYVAOdEVQfPma3X6PFh4D7PgbFL7fO8GFmPGZ2WAYV5e1r3WPZ38uOUKcXJiE2GNcO+u2Uu8gkpy5bz3e3vljhcX+pORtevdaISdEJWLWtJLWOO02DHdAb2nC57J48BOZUO5IRO42B4PjlDNJFfzdcxTMRWStaoMuFlb2MfBUOO+VIyH3+KidHrzain9riUfvvbdGofnurLDrTnjk085V7Z5yVxEX/oMIsLlsq4+MpPDo8DEFiPfmZv7/NDww/eZ0KTEIwq00eRxa91YEjAXLFLNhK9wOgDiOAtGImlmt91gNtlit12wQnPphxEhOziI6MFDPbrU24FZ7hJ8RKE0Cgx8Kx2aIbNthsxuCW3DBLiAQGwahlcEeadjhvIrtziab7OtnvaE8Nm3pQ6RDmowx35Lp0M+LbyEXIpQE3nvMObQfDNrJelo4ZG
 Wv785Pm/
 l4ORluFymRCwXTorSNR1k+eiriPgx7BGyce5TcA4Zx6XFDgQTrLKl3t+bEHDaCZGB6lu3uYika6fp504DaCowelCW+TdMKgiWFhVVRLe3vhF8nTZwFNH4HqT5E9AOBlCte4x6rc02naaZXHklA8iilE+EGWYEAChwcVhptWDgOTb2FKULdQtDC9ki1O5CKLNdsE9omLPsTrl0/YHAaLZWoFCJHGHRIp5nxTDjo+UfTIOGeTDwM6ih6O5UOIOGavFLyE/P0PZQw31hobvppzfHGwJuLuClD6ZdYftw2YW+HifABOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 13:40:15 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> Whether a PMD has a deposited PTE page table only depends on whether the
> architecture requires deposits or the VMA is anonymous.
> 
> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
> to withdraw a page table that was never deposited.

A large part of my life is asking $LLM "what are the userspace-visible
runtime effects of this bug".  Because NOBODY EVER TELLS ME!!!

This time it says "Processes using PMD-sized raw PFN mappings can
trigger a kernel NULL-pointer dereference when the mapping is torn
down", which sounds kinda important if true.

Help me out here?

Also, thanks ;)

