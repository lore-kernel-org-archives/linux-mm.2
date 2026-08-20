Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26C6C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05826B009F; Thu, 20 Aug 2026 04:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD596B00A0; Thu, 20 Aug 2026 04:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919E36B00A1; Thu, 20 Aug 2026 04:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD596B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE84F1206D5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:09 +0000 (UTC)
X-FDA: 85121003058.13.3D31EE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2951420002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTdSs32a;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215268;
	b=PISCjxuxXEdFwy+itSxP134c11cgVdrl58r7BaNEtGLWrm9ZAM4q8iD5qewstqKgtZQk1H
	i16sBf8qsAtpvaCSYPrPywUN6PWIkbsvTAUcO3LYJc0eG27rlbPTDuaDF+KvjM5pVXK+aa
	1PN+bTql0SNTaXZ/uEpj+16m34jNseM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTdSs32a;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnOsjCzT8FatZVzeDDeSf/TrI74b+ugTGSwDGeyDOH0=;
	b=BnDdJukln0IUrJJx5f2Dv2jk357flS/dWKXFD/yJQMp2gE1JUKxq7Q9R8vzMe6TgaW8Ypy
	/3CjVFy7yr1ldLYWJf6ZDrLdb4e1rnlp2NhLpDCx/Udk7GLnD3EX1EA2eCD5BJOowFBecN
	7HBq0A2vxwLMeF8+tzvluu7OzCc/aVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8BD6618AE;
	Thu, 20 Aug 2026 08:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333E01F00A3A;
	Thu, 20 Aug 2026 08:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215267;
	bh=UnOsjCzT8FatZVzeDDeSf/TrI74b+ugTGSwDGeyDOH0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VTdSs32a+XsCHLsKQDFAxn1Q4xMFCqPu8wOBV2VOJjmTnpsDcjIdwnma3y8fK98/g
	 b9T4/ZWtWmTAyS37Faaerold6f2+Aa/ANT3Y4v31JfQhkWU5MeFOpfMnW9sFZA4Ak+
	 hCffh1Aijc3IuxQJVANMJMUe6nyep6YvJt4GWy+unT/JgiTsbExUu7KjAxnbGPZWNo
	 S/wpprXP/R9om9YyKCXBd6ZKnjym+BcW++N77Jqgw9PPAP4bLqYNGJCMjtDK6hcHE3
	 mnnHBblnosN3uf4RT4p+bjno0Q6AbRo6XyfquLo1lbWarvw9uMX6SGnk61AIvf1fYm
	 1/1z/KEsF3Xlg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 08/19] selftests/mm: add folio-order check for
 address ranges
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-9-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-9-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.17945598969161889516.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 2951420002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ymh795k14ed9jot5gbzwb45spbfckbna
X-HE-Tag: 1787215267-93991
X-HE-Meta: U2FsdGVkX18IUrn16zwLSZmqBtIRywNjW+eZ9pcxNzf3NzxvaZQ8xoBLHXc5a+xBCoWNLRHl3mTADmK1hzbObc9Rxpub7oEavN7AWjLgmrGLpExG6dBEJ0Zsdvrvygyosx7qeQkpwIA/gTZ7Dx3W2zU7sMSGqoMtX0hJ8mXW+SkGiCqZRx/iVd1SCO0dZ3xflyo1uBAInlSGZv0YdL+6poiZRL9YaOJgObfe+4kpZEzmEJ+H2+heamwTeHoEfljJga25+MeNJ01fm3MR4bDhaygW+YXjQy+Vs5jj0zMJ4NJI0zJmL99U2aO/rRg7IUtvVZRTeLSPveQr40agEQRRs7CEsv/XkZF4uHHr5hFKwkZM1c32r4YFD7bziGo53H+vwQLRfaGiCmVZ7pEXK2euc5A9S23N/DZ9r+y4SU9IMxHpaE2YPrGVVvBhOaQzK/GMpYG/bSc3MTPiqmX0HdXFknYNMCtvZ4VyX1KECNwJnbZqgWh7tiVT1FdwCI2z+6KAmkbq3nLeHEQLQifwQR0s+G9yF5rNyxkamB7N2DCP56L/SOVit3Ai9S2Sjb+/lbAKKE7yxn+xPGsG+A2vNY/xiaEcdTsTjI7A8PgAoZ6fN4A1VnXik9XBneIWkLb6UJ9iorLWtPi80tNQC/TZN6dQK+sPnRy6imnaQADnbpS1fUTDfPNoodlynB/Tnv6F0ZVYhxSv3XhldrjdWcRP+SVsp3abaw7Ga8VPQ5hjnFIssM1nCx35AB9RCiNyVWZEzO5cPOM5xJD3fyFV+xBJrdbc+RGBq3L55qsXOHacl4XS2ivFYv23BjfeP0rrLykOkUNqZ9DbXO74jmO4/7Ti8DsZxVj4E0gBV18iY/iHsy/Wzy3+ZPzjneESaXyN/tS/u3gOmB+5/2FRDUalnTwX3vZKxo9kK2ZO/5Ojff8q5o9D31g/hTuX+tsnV5MQWDrx4ShjbiLyVbt7pbahD08fV6H
 Puwv0GRx
 y0nI7ZqnxJR2Yo6ZRjqcqODudCr7I0w4sRxqvthQpMmuiDE/Xqfz+FHA2UaITfwhrnC4lBQpPIwzeBpxm8JtdF/R3RoU49cyxrKy89K4+wpRkPyNP2yC02hCZ7RKaURdwqcifCCNWzvXU2e6j6QLceeSA3RBQIcNt2XG6LXWzADVSZakRFmr2Aqwxwx0MehewE/W/gbZTPHbw1/F4ZbhIrE1hkOtk4RRDH779jJ1RqmvdkvuTCtqBwlxl9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 15 Aug 2026 02:58:50 +0100, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> An mTHP collapse test needs to know that a range is backed by folios of the
> target order, and that they sit where a collapse would put them.  Nothing
> answers that today: is_backed_by_folio() classifies the folio behind a
> single page, and check_huge_anon() reads smaps AnonHugePages, which only
> accounts PMD mappings.
> 
> Add is_range_backed_by_folio_orders().  For every order-aligned window of
> the range it requires a present head PFN at its natural alignment and a
> contiguous PFN run across the window.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


