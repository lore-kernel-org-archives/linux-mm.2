Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6262EC624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC216B008A; Mon, 31 Aug 2026 20:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CE66B0099; Mon, 31 Aug 2026 20:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675AE6B009B; Mon, 31 Aug 2026 20:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 433636B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:51:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77D80401C2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:51:02 +0000 (UTC)
X-FDA: 85163363964.11.AE0435D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D9ED81A0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:51:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wr6QVG9q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788223860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaZdL5/4xTpVe94Gdwvz1Rj+GpxfA9H0D9S8roxC2zQ=;
	b=fvI1/Q1Siur7TLwfvnrjLTcWQZHUcz8zaMMZv7QM7Cjckg/VOqLPE9G+9vsJqi6Xiv2BdD
	kSbDWOEFRipPgSOQhMmcLVqgl/pM5m7gE6bQKUmpDZj7AAFFBhLA3Ab/Bxu15HlLxDig+u
	/Vhw57ZVxDMfGIOSZ37BuzAcQ1lBCHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788223860;
	b=bmW+x0nZUtcr40x2AVhnduDJIPGkVHQUrtldEMvL+tjxtTbD91Lcatekh6lvQp8D1h/yDQ
	v4uvTP0WGDwfKv5BUINRjJbKpYcBOaW/PwghknX7I6ZRzH60S909czH27y5F8EG2oGoDdV
	Tr5WyFHptlCu6Tt/fnDGXlxZ+7YkxDk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wr6QVG9q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6226C40739;
	Tue,  1 Sep 2026 00:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C321F000E9;
	Tue,  1 Sep 2026 00:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788223859;
	bh=WaZdL5/4xTpVe94Gdwvz1Rj+GpxfA9H0D9S8roxC2zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr6QVG9q0n0SoHaVG9gXRXl+dVswmtQi2r8zhEbm71rjpGEd2k01TJsrjNoS1P2uE
	 dFpu3CIxYZ+kQ4YNZunSrXG8sUEbFOeAQEsSWaFv5BmCJB4+QhxZBC4iOpYH1Jkt0R
	 +vFc77a+xm0lIqfqEry+vlTUIV1h94t15U0SmLwCw/5mbwlfMUgJWvSlvdZHfVeOKf
	 1RZUSRCHh5ZA0cHfE1PkAFtcUdKdOdl2+pgflVBLxgrajOtqtWUJV2bNCXjt0hb2nF
	 5pLuoJ/bgxKbng8K/9HJTd4bMUMa1elEKBc9A5gaMHF3AN5BymHZEvdAeD0yjiF0SD
	 0ZKkJnyNY2qKA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1.2 0/8] mm/damon: fix DAMOS bugs in core, paddr and vaddr
Date: Mon, 31 Aug 2026 17:50:46 -0700
Message-ID: <20260901005047.90102-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9ED81A0006
X-Stat-Signature: x8kzy1857tcxf84qwr4qa1xihtesgr8i
X-Rspam-User: 
X-HE-Tag: 1788223860-464831
X-HE-Meta: U2FsdGVkX19U5wdne3gt+vOAYZVQaYipbOw2aRc5McMWOEkXXIDt70rESbABknaMv89KG32edWsczM97Z0UQyMB0t3Wo6Npl4wOb+85exqGgGy5GA8hIdrsv9GSuH9TVBR6BZF4K/k120NKlHaAMHj8brM2q1oW5jidr+vGntXOY94wPCLp+752IqA2rBlBYchAQOGbHEOn+aN9h4X24jfGWDYuk8Qt9/kuRG8QcSo8HU+z62ZO+wSwOikjyFMrC2g+WsFVveg1HnGqwrRb4POb6VbbnaTfxqd2j5rR2Va2Qd28K5rSxMndALF4xRDciDOeiYaFL6570CJIaLSU70cIOP7GkydDYoo7DtQ7fRe8PnOW1v2G6j2D95FV6MBo9ONAikDvEEuyqwOSUGySiySdyBpGGpNY6J8MEH6Xg65tnhdv6BzQhcsB/kWx7d06P2cGp04ITeacn44efx1baRLpGQM0QaUYbAuBKvFlUGPxXpVsq01HbHHZmRvOc26fRMgzHBdx2VYkNI/C+aj5glsTT0ERDoVqVvo36WMVjW0BYL+VefCYdDQZNUnlXBs1azGc+Pgi9W0CxG+RHw0cHNl6ZL2RVgT+sfOO40siuLOIJIo3r+EigXt+5tNLjstjtoaWAe4lN/9JKYijjFEmBGJjTpt0eaiMBUpAhRJpjDeLvD/oG3xJ5GtRJMngUvn3CFDO9SzirGb3djdUSv7CBFyELY+j4wjfHcCBouMCwmHWOTWzNs3tGPVTMv4A0fsdeIGq2zTEqv0+SscL6aYxve07e05k8Cd10l+lktk4+0F/QmeDlsbCWB55MbVinPXyXZULMuquON0o0YDIm3GpqGUVk89zI6s6wxwhO1EYpZCYdfVtKY1MtgAva0NiFS6AG77v4sok0Z3CVGUHx4McpsfDfLGMxE6rm5K+ZUYYCsSklAqUY/2U9xtG18wHYJ3VJn6oYu7xL+tMLZVaqrnT
 klfNGJJ7
 saN02geeTeyy0OE5yq6II4YQQCc6W2D0UOmhS8A8/OHhCyJ8DqA4bAjbTCDYPE2N7U+zKQj1I8eP56tQh/HYT9wZrL592/8XCMl5RA9Epefa1APzJ0Fm52a/Qo47MbjfF1OEoto531JyCNSK4JB8t/9H3Q4gKtuQVIhFO17DfyWa1E6rQF9/ZuZBjsUigOUnl/9aeJ6iatA1pJMrvEgcYNoZxUrXcD0EpLoQ+4sQkr3AUQiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 07:02:39 -0700 SJ Park <sj@kernel.org> wrote:

> Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory
> allocator under extreme situation.  Patches 2 and 3 fix wrong folios
> walking in DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in
> DAMON_VADDR.  Patches 6-8 handle extreme and unlikely memory situations
> that can cause divide by zero and underflow.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/



Thanks,
SJ

[...]

