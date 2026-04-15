Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5871CFA0C21
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489BD6B0089; Tue, 14 Apr 2026 23:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439A26B0092; Tue, 14 Apr 2026 23:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F776B0093; Tue, 14 Apr 2026 23:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F52D6B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4B5C8B38D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:59:43 +0000 (UTC)
X-FDA: 84659436246.04.3C03BA3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id D12D9140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:59:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Jq/g5R/Y";
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776225582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deJ1eMufkMgkppgMwS9jJNybBMDiYOzwePdyq36/Yik=;
	b=yd6Z4bwJ7h5Z5/g4O362D+9YC7notI8lD+RDp/G5xohu/YRtDe8RUH1i3LRQ6wy4VhVozf
	rqxYdRRa3ixZ4tTS+LhJrjYpxcFH04brqoWbpRDvLHIxJYG6t8m3bAFx1wP3yLHtiKXJux
	wt+DSVERIQxXLo73CpjmgyuTXWx1u9A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Jq/g5R/Y";
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776225582; a=rsa-sha256;
	cv=none;
	b=uYoyCy2VCSSJwFvl5ormU53d2y9kNA9ZG4VO5O96+lYGhk6fwcMXk993bi1mpKheGSbEJA
	ejMC+Kcvd0qrK05tWlPHbwjnoQuwGD1Ldr/BlhhUvcKvzupw0iTtvoRXffnUuBKuSB6wn/
	CUytfvsMUTzfsGq2r1Dad+sdnas/Oxs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=deJ1eMufkMgkppgMwS9jJNybBMDiYOzwePdyq36/Yik=; b=Jq/g5R/YS1vYZZcY2Hd/i7PEdD
	j2SCdeFyko+PbNjASUS7hy1nUARi4AfcbGRxr3jTu5RW00zPMdHOXtkEK4xUQcLpt83nByzzZcwTz
	RuQCpxNxvlnLuzEOr+NohyQadIYRWAQqDE++xN88qNDaRp2s2zRX2PRBpstik4Vczudwby2/94hco
	aF4W6UHTP/NqZrgswn2KgnTqryLnEYH2Zrntiw4kfClOk/SpwZsTUbFcQFrCWSUlBYpIVRtZ7ux/Y
	A7jMa4j/GWT37wulKyEbsKfI/Bjlv6Pe1FNuNE5xJ018X7CZL/RVvih69sBKnTjcEROI6HnOuuZ52
	ogNDH55Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCrPd-0000000Ggrx-0m37;
	Wed, 15 Apr 2026 03:59:37 +0000
Date: Wed, 15 Apr 2026 04:59:36 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm/vmstat: simplify folio stat APIs
Message-ID: <ad8NKAxUAP0RYP5h@casper.infradead.org>
References: <20260414091527.2970844-1-ye.liu@linux.dev>
 <ad4-kpPTPqOuDF_E@casper.infradead.org>
 <6c0ab55e-a687-4ad1-b18e-b4ca97305a44@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c0ab55e-a687-4ad1-b18e-b4ca97305a44@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: D12D9140002
X-Stat-Signature: inabsr6tqcahgw8b5kx36sqxa3zicuia
X-Rspamd-Server: rspam06
X-HE-Tag: 1776225580-631334
X-HE-Meta: U2FsdGVkX19yZQPJdkz6pvLQQdQas/DLda0ScrLYxO7tJyAVtSbFEGdR/6tIYVNJBm5dBHMm+K0r6lcZvK9K5kUrNqJ1bna1eJ7N0Q904YCF4PqMB/pzbswmyZ1LptUvTo5x2LVf0a8eBG/5W/AZ5z25zMI7iZGWE6U2XbmWG7aX+7WmRXNcXlzG8KT3oOEke5Sni0s38sazuPDMXl/lL0Ir4qGphJBdHCnASufV2lI8CF51Ey+AQIDNbFY9rBhNf8QCp+hhh3WHE5ux3SgCSivf5aITiAvCI0XXXCxJZbuomlsAkqnIgZdX7VSM+8L6tDbY2w0dc+t7GofgAxS4TEdVGGFZiY5YHkPcreONs3Wod6JvhcnbpUq7co3PnOOSAJcUFLH767DnZt0jticLpYfL3zryAUAIBbS/d8AOwldDtkoY1fuBCj+1zn+zawTMFagH0ZdtYvIpwjcEfoRGdmRM0ApYErF53455LKrtHsPkMnQS8UZFgWnlzqPIz881qXxFhgNRpQjfcFsZg90vWLnH4B61Ntbklsn9J4VYE2PI3W/yn9KCQyljQlm4DAmfKUKSNJLaVI+jO5MwaTzOXYSyJEtTGGmUzhV+ZweSqk68wqDzr6LoHjtvRb0ZEK/qthL8MClJn6T7EWuzTEPvHplxnaef3A93zIujQyv9fdhf2K4oBHpn3svqpnNDYWUpMxuoS0HSD5R3J5ME6qD5ocQzyoMwoMi3KezDLGaY12dje3Phj33Ro/w3jX6bAHsVSuBLmTWtTvY78GnYXpnkdhclvqz35nHN4/5mQ7AsiLjLL8DAwS9xWd5oI4VP95puu5/wkB71ha+hbtiad0402JPjRhUtSoLdVAOndlxH/+Bm2FBRxMv96+GMgrd07WyDpR3uDPSeGlh9Sj5VNwqZVu9kY2VY0+7Ez2HMB+N8HzkfbMZQBFFiGLsjy0MoKKcwbTmfIoR/r21Ap4qQsge
 FDfMVZc1
 tr2Ajssoqj2CZBBJwH3kNywkFq5BTKgSRyBX1h5H+k5zK80n8J5X5874wVAHUbuqiN6Gko3lWyoVw1b1XEX84piT7Dc2VdF2HwuGZor7tEjKIgQc5Z9nSLYr3jsdn6PhC+wRCkWOTw8XDM26yZJVYrLVPFkeHpCRAAdhVnMLOa0my4SusOOgUO2FVSaZj7YQnOXBhW01w75Rlsy0R3sDmkW6TQudqB0TPilPMIOejlwPsmcENY1NaJFOcTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 08:47:24AM +0800, Ye Liu wrote:
> Thank you for your feedback, Matthew. I acknowledge that this change may
> introduce additional calls to folio_nr_pages() in some cases where the
> value was previously computed once and reused. However, the new
> add_folio/sub_folio functions provide clearer semantics, explicitly
> indicating that we're accounting for the entire folio rather than
> potentially partial pages. The overhead of recomputing folio_nr_pages()
> is minimal in most scenarios, and the improved readability and reduced
> argument passing outweigh this concern.

I disagree.

