Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01CCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542206B00D8; Mon, 29 Jun 2026 10:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB806B00D9; Mon, 29 Jun 2026 10:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCA46B00DB; Mon, 29 Jun 2026 10:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFE66B00D8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:30:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A78B40173
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:30:27 +0000 (UTC)
X-FDA: 84933185694.15.E803CF7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id E415E40012
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:30:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UVabjljF;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782743425;
	b=8dsXqlEFQale9vNY6/Fj53H6dVD5+6CHdyyD0KFZK+HhHo0gnAS1sCLJ2fYQbmunQcNjoS
	OrssJs+K6j6WT5byispZ2ORlEkNetfdDAPHJDLqKJ0ezS+Pow/XLwxXZ4m0gmiVFkMMfBl
	Dl9QY7VDUJuwaUeQKbpewgHfyOkigPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JVNr00d7n+HWvtx7NARkN4HKnYVbJX5QniF4BpnFAY=;
	b=zleQ9fx6ZQ2plMKq902dwwmnWIsBJbVKenuadtgVxsjg+XNrEgVlZDoHqmuxLxz+4oLp0q
	Sxtd+usbY0fZd9AwN5hafc7AfV9EwgQ4mdhCljNx/cZpyXpFxZ6RQTfg++pcG7gh6esseI
	AFHmvftrJ0SLBZEqLxL9St97MgEv2QA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UVabjljF;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/JVNr00d7n+HWvtx7NARkN4HKnYVbJX5QniF4BpnFAY=; b=UVabjljFoIyvu8YApxsZ0v9cPB
	AKPMfEABiux9W/CHiYecDlyUKM7RttXwjt3197cGe0IOjfpgBWgdy8zRIPtp/l1lG+OAvPvuxKURK
	qCUiW5KcuYHOSY5fuAj3Wni1e1Xsio2cJjGYgaf1qfQ4zCfHdxwhRUyN03BT/oNWW8x8lZJ8zu7Gp
	7K1JVOflVNNB1kNJsUMoUHOiealbbnAMVAQkoxsg1GpTBlxiDUgyPcYFFf3TGZiw+lTl5OWw+Pd7G
	Be9PtjXwbvhhwVbpiFsErkLq4qxzE1nE/xbn2FnEARNTL1fzAy8HJCU6G9uozxiLx6v3Ri/WhlPCu
	5nUH+mbA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weD0A-00000003NEH-2F8o;
	Mon, 29 Jun 2026 14:30:22 +0000
Date: Mon, 29 Jun 2026 15:30:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: A second pagecache maintainer
Message-ID: <akKBfh-e6C-a_ZSi@casper.infradead.org>
References: <20260629135927.2586391-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629135927.2586391-2-jack@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E415E40012
X-Stat-Signature: g56ykgst4ojkxtizqsagnjf5dabt86ac
X-HE-Tag: 1782743424-660004
X-HE-Meta: U2FsdGVkX197EtQ7PrCvS7Jr2mawcuSQ9hJRJg7EmpnzdKc/OsbWNxfb8xNC58T0xzs0sDixiPX7U65c78QvOXf27IhXVWwuzekw3BwulUyexZVw6njSExK7hyAgDSbqf6BqPBszon/kwosLVKPLLzk+EMbNdpmCWCAr81UdqKmEChVWpujri4xiPtheBCgLL8aJAbHJZiWUNLKuZ0zRqk1IZtpXmQRGxD222co/YZK7EvLGq/e8q6sMp7K3b4QtxFxzrrmedvH/0EmNaCmjkJctCQlWuKfdkMsc3t8cNxplxaO2wJEgDoldauKnq4EzyTNej3+BRkovZV74YLVuMCG9wTc7sExQDBixqJJ+PGwNyTvqFR5SkuWPSca3R41GNTDD8Lr1Gd8z5N9B8wtaAXNQxHWeTCzQ9PDCay/12fqgFeOf+fF2o7VQPMt+62uDUhUcvHIhu8DKl9un4UNntRfxSdyI+74qpPm0a+V8HU+IVqLtgrrQj0h1tVf581CW89HrkQQUx/4F3H/we1Yhm8gWP0V/25RFFmAyWvRK2wyW/FAFXblDeWPZVSO7e4t0dAHO8wq0wdO2ENZsuHTaxnk6aR40uXP4F4/wZnobm1Go+f4DlKp3ezlQMeWbE6IQ3ojNS73ok5V+H1sMrZB6T6E6v0++iqrZiurKjamNTkBUsQWZrDxiJofE1T2tRiDdjev0Z9LSXtDJhbDwwhi2OFTeB4BbeNK3zMOPncxZv9te6DHxLpF9dG9JykToz9voixe666dofH1ymemfY7z6/BpfjneqVkjxGriIqCRZik2Qm5nc/Nb+pWdn2OH6WcoRUU/Zj4UVGAbCwBOp5vacRrIXKl1iN+2jco+yYqIERdTreQuP+X0afJF0cs6ODnBAW5IHNsjtm1oO4srecXr9NE837htBgYXWwM23Ki0mxF9heKu8R39W5RvDXVHoMLoaIuCO78VQURGyKStizDa
 Igj0vPpa
 TGIBitxTQuIf8jNdTNfrnFCLegZaLtgO/QTIjQq/JBGWpF77jNAlN0023Icf7RGLMBrKKLjLuf/pza0Z9obfssbtHyfDNw22oVwC7on8AHoOqqqfxdMTzNA5qNAjIknco0AiqAHLaRRoBLTBYelpbzKlDBT68cNIapcbEVvfQiiYqmGLiJUihfr8ofRgY3TNrKaOAl0VEJ9RKoPDMv9AFXk5QcNn+D1YeoEo3FwAxP+O3EmWcSuJL7sY32L+tCtCmyQ4BnkaplbzQk+2b974m4Hk4Lp5DGAjOF113MMnQhJGlbFm8uPHJ3QsMtw6dYM0+wmV2K1jnzoPafitT9JUum4+2bU8mta0PrscQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 03:59:28PM +0200, Jan Kara wrote:
> As MM is slowly transitioning towards a more distributed maintainership
> model, we agreed with Matthew that I will be a co-maintainer in case he
> is not available.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>

