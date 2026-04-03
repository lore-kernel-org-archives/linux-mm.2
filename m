Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0257E85379
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 16:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E36E6B0088; Fri,  3 Apr 2026 12:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393976B008A; Fri,  3 Apr 2026 12:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9DC6B008C; Fri,  3 Apr 2026 12:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 167FC6B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:20:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6E071405A0
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:20:54 +0000 (UTC)
X-FDA: 84617758428.16.E9A7AF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1D837100008
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:20:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jBzEjqFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775233253; a=rsa-sha256;
	cv=none;
	b=LGIuLapJMNGRX2+gmK+0CTI6tn7XZfJ3AFI/wDWXl1rhLFDCGfbyGZudu1o4ER585S2an6
	op1yCz5NsfnE8JyCxmRPAhp339uq++8fUgANaxAL6t4onquDjaUyu0SyrVOVhTgVx7T9xn
	jzSaFXIRQ8nfMkXJWXXZHU903RFrBXo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jBzEjqFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775233253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyWwbywyFG2+6tMdPjxz63AeloBrH4vXhuyqAGdaDK0=;
	b=dZu6042GnWSdGMiY9Tr4qHcoYgaGmKIYQYxaoHGvb1Z4mdA1S0e5u5K+TqkHVqbWCaePGy
	aYRUaT2ZnjkOzaL3xmKpN6ABQ+UYMfYSEu8pF1iRg4mEUNQMeCkx+n/dD4YlfLdpw5evHg
	H3t68pC1D/MYTI5sbb5Pn6bQvT6rtCw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EB4E60008;
	Fri,  3 Apr 2026 16:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9875C4CEF7;
	Fri,  3 Apr 2026 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775233252;
	bh=Ds4Y+cyyYXN24nPdjxMnzx1viX9Vnik98lXxpbdexNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBzEjqFJ1M2qH9kDhXArAiBA52bw9oPlUpcxKq2q+U/lWvaDw3J8QC8jOFGh/G/lf
	 KfdobvROy4Jj/QIhPTA1+wq8v2MxUx8UyMZS6zYFcxoLUzvEJrV800sceWdXm1rHxT
	 JrJ1siN49rXwG/EHOhrNymsDa6vV9ExazJceml+wMWRIKeYha4V7yZI61dItQbTA4w
	 rUz5HMe401+QZvGMqjIDijYrgVYdLUVF1q6PY81MiaJlC+DK7wqsz2/PUPLVjxqH3E
	 kpo0I1RnHUnYlVgtOsfaadZJVGoGVS0vlmGy2rNsekQRKmMC4/yLa7U4mMrS/ORDIE
	 T+xNsYlufIonA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 09:20:50 -0700
Message-ID: <20260403162050.65121-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403052837.58063-3-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xiejmgp6fp5fmt54oty57zr5emro7n9h
X-Rspamd-Queue-Id: 1D837100008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775233252-814170
X-HE-Meta: U2FsdGVkX1+Zfx/Qu7UhNtNItCcEV+PI3YJYL04jbg3ElYBLmqQchlmlVGLdSzi7niYNLREUjWE5O5Lm5+oCKZ823DAkh/eCW5ZQ8Td6CcmlI7mwybwEUbPvsUCODKk8G8wSFayZ2Nk0EHtSbyj3b5vtS+MfnJmdvQwg5uZmHeIgbpY2+OmgzMopJOqmU4U56yqXb9HEEp308diozCHoOh1hFuh1iCUr9FS1o7IFGM/aHCPYUyKUD78g5uEtBKCzt6x2n1aNzdngnI5EY6GIqAd1Jf62+EobHybqfRWP8iwtRLOmgAGqPDF9mi4oS0AWImyDCFXcGCLsc9JtdkF9vNEYFsIH0XDIdQ/kwoQ885C3OeX05Z3lCwEWm7SBqWL/EG7gQpUr7BXwBQWmcxlrAktG27xChAYuCbQ9T9Wc7mp/SQcNSEMbEXOG69BaoBcR3CDLDdHBmC7KRf70MXMfC70VpYSZOtq21vGruNzZ+c5caqALX3FGYk9VPQdo2u6nRvaT00DX7j7CHQcoI665Cz//P+hfdqQEtKKNLV4tT3MnhrdkQhIkSDN113oA+EJLWqGEo2TY4sQjh0wiDlHOZGWEYE17sv6wS1gaeqS4rhgljXlrsZRrRxxJUu3zGik1M7h8otpGD6iAs/ewnjU6H/4EAVI+xbp05LgCDWER6mjpolQs6ztRcwJBLXiRKd8SbW66gk5ITeyKLgKtI/nNoXVwmWmwSq/BwLXLaCfolHk8MhpjVbhUvFA/qycPPlmrRcSxkD521XqnsYR8n8bQcBhPepN8fen6Jmr99pi4vajPyKsypUEaqT38uegHz8NsrpTZC1ifxFlAV8E/7sOWYcToDclLIOqnnOoR+xJKHLs5v/MHrhOXKeIs5iFd3CSq2WH6LOf5fC7JhSn8r6UzRo+SFvXdOBbI4RejYpDKCi9ARBGcwSBiOCiaZaTBFYKEUSmsJn9aTT9PEpUXT2w
 H/EoaXue
 xlA0nwIJ/NVWoE4axNar52xJKp/sc5I86H3w9MAC+70asrvUQ4Gng9pbiUe6Y8NjxXAgaZIvz0V6zCTSRaFebf0Df4OsHvaScusp/ipGtPt0hsELcJV/2Q4wvY+aar8i+o/0xQ5yWkAphYlcsXva0Pb6S7UOzUBms2oOyBCr1qj5P4nP/BCTDQ5cXPhDZUuOgmso/ixwKgGEz5F4+01mSOvtiMqfHEwr3loBs8SRoBoLJdp7PZoGlcKh0+otSGSIuoqj6dNxmZg8NPaQpM0rVOZE198P93RXV9zFb7dK1CEdJJ0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 13:23:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> The damon_commit_ctx() checks if 'min_region_sz' is a power-of-2.
> However, if an invalid input is provided via the DAMON_RECLAIM interface,
> the validation failure occurs too late, causing kdamond to terminate
> unexpectedly.
> 
> To reproduce:
> 1. Enable DAMON_RECLAIM.
> 2. Set an invalid 'addr_unit' (e.g., addr_unit=3) so that
>    'min_region_sz = DAMON_MIN_REGION_SZ / addr_unit' becomes
>    non-power-of-2.
> 3. Commit parameters, and observe kdamond termination.
> 
> This patch adds an early check in damon_reclaim_apply_parameters() to
> validate 'min_region_sz' and return -EINVAL immediately if it is not a
> power-of-2, preventing unexpected kdamond termination.
> 
> Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
> Cc: <stable@vger.kernel.org> # 6.18.x

I'm not very sure if this deserves Cc-ing stable@.  I posted more details on my
reply to the first patch of this series.  Let's discuss further on the thread.

I will skip reviewing this patch until the discussion on the thread is done.


Thanks,
SJ

[...]

