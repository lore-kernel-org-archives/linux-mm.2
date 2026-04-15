Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF24FA0C5B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70ACB6B0092; Wed, 15 Apr 2026 04:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC536B0093; Wed, 15 Apr 2026 04:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1686B0095; Wed, 15 Apr 2026 04:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 486C86B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:57:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01E03B9B6E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:14 +0000 (UTC)
X-FDA: 84660186030.08.67A0A3D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E066180004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oQ5VvWuO;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776243433; a=rsa-sha256;
	cv=none;
	b=g+Xs9H7LpwZ+NUocBa9PPxg26tjWLzGozL2FajXnbh5kdyCxcP3ucVE8ctzcxFHnBn673w
	+nll7VkrpgTtbrqdOfrbMoqbBDu2ipdHto9CZoQzwlK/AkMFHjfylUgza5hYMKkXR6T/PD
	JRMk911HV8rfW+eKiSI5fRJewq2pmko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776243433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SARNLYh/4VaMpBdEPrbyHF3ETDUGjutQH6cCi+ILlfI=;
	b=Mwmg8EB3MjcXbLXX6oLzceX5WAd+/uQ3qhIDPWt76uuFWMM4YRNPQrbsveQJgQDC34LUp8
	KiSIq/GCkeTIhPcsVcp1+L+C/xGlhzpGbSN3sRirAhBLgxkyMV69BkASQybEJWfoAUrw3Q
	ogfytUmJDuniXNN8xt3ky+LxDHUdy0s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oQ5VvWuO;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776243427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SARNLYh/4VaMpBdEPrbyHF3ETDUGjutQH6cCi+ILlfI=;
	b=oQ5VvWuOUNL8C4gmVJ0sswWxoWO1DQP9Z+me2JFcx+FPTuHQGgOLV3doPN3ik9mE7QkdEg
	uK7DkHui+7pb1cILWFlKP8ZCHgv+JobQJMy0eoOfRlFB02fWSO6b+SWB+3KzNvGibC3fRz
	iCphTLVkcyWYOV1dNGV/P5XzqSk+FRU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 0/3] mm/swap: use swap_ops to register swap device's methods
Date: Wed, 15 Apr 2026 16:56:55 +0800
Message-ID: <20260415085658.993859-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E066180004
X-Stat-Signature: t8ehbuu7oe7do8ax9zi5yjus3psdsj5p
X-HE-Tag: 1776243431-41163
X-HE-Meta: U2FsdGVkX186vf79GKEbLekeeOotvdgIJkw/IEQydDXyv5nK7VkTRjJvT9riZzAGaObtOBdGRvKetRD/RwmDc4Jet8C6DqKjRLLwHZPAT4mlCsivzP5OmYjzSmvBLIlB+VMDZZUR0Rlrxy8TVEx2pKLsDJ1M96hrpVs13Uhnw6zonVQn0v/WPxseF12Wb4eAbGVOxt/Xam35fpe1IH9yqhgYBrTl+w+77aCWSWeXkevhhn9bmatCmVR3MKgV8OQobOH2wHCrkach+p61a53uAUG8Yqv9ARONeR+oodxTalK3jOhRDNPIerfws7y7ixATkkDyHe64exlBChc0OdYMnJ9E5Sscw+kgHY2FMy/auGQPztPw3i9gcXHoNCyBIb7jKCpyfL+lzqnLGlXXkz4fZ55PeA2I++i2odBnPe6BaET6WpRPSSYnC36X0Hw1xFYBkT4GIR/maExl0lgigtAh8N5CQMSURfhP+JZh28x0pcK4ZZCHxUcx3JkvQuRPt5pcrnGik2y1COJm7i0HaFP4uG5prLNocsyrqsdYny0CvHwUm0lG/tAi5KNkwWqaS9I/xeMMmtCWg9r4laodKknWJfcqRuQdHScdN67zDLCsVf1xfvYFkNsgP9iGICpKpuegCvBKH4/Onk181UAxciqNprLtu97T07ocACGAnapud/Mt0jNHEaGICDkckeRbF5ZaEZdxkEAOQU5njfmrmYEMdq/8OSbON2El/tRBIeJAclpeujAAo7PCmuqijHRyEN6ZAyM2ZcV9gsa2aeNmbcMbZKYm2yIY70DuYnNdAP4mgr/KRedWkScYKXK196QRdFIVN14LU9UL9Q637XUkV0m44QjZc7HIk0rD7+gnYUzqmbYEPqT36VNQ5TbUKHPHslDIEc+/sA+mp0XYk4zG/T3ZGr70qkx0HzNJlPnxkYSp/+KO6l6kSQ9YyQLXLvgTq6k8il/Awvag47fwRY8uVu3
 hoS7GK2z
 p1gZOn9wvUtv9qc39lgoZ1BVFsulerXJ/Jv65Pw974o9x8V+cwT2mbifI+kN4JPoNyIgpOfPwhlBPG2SH+4C0NLpBJPu6m8M0zynwIAuH4DD/ytg1LHHH/flIWvzvYyAcu2RccD7b/PCIs04ETxSuILWuQEgeEqz8/cjy6u2JdeCmvw1jOXmlDt7cerWkK4xeDM7SuPdT9UYZohqrqJG64xnh4qLH7hDhjMkKVoA1fjFD51fs0w5S4jiV7J9im4igymJ/jO+rHfcXJ84d6AOD6MPz45pvdLP4pt/m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This can simplify the code logic and benefit any new type of swap device
added later.

And also do renaming in this patchset:
-------
   file renaming:
   ---
   mm/page_io.c to mm/swap_io.c

   function renaming:
   ---
   swap_writepage_* to swap_write_folio_* in file mm/swap_io.c

Changlog:
===
-v3:
 * Rename setup_swap_ops() to init_swap_ops() which reflect the function
   behaviour a little better
 * Check if sis->ops, sis->ops->read_folio and sis->ops->write_folio is
   NULL in init_swap_ops(), but not spread them where they are called.
   And once the checking failed, fail swapon immediately. This is
   suggested by Chris.
 * Call init_swap_ops() before setup_swap_extents() invocation. This
   doesn't harm anything and can benefit later adding sis->ops->swap_activate
   method.

-v2:
 * lots of cleanup for patch 2/3: renaming, moving data
   structures, and using const properly
 * collected tags from Kairui, Nhat and Barry

-v1:
 https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/

Baoquan He (3):
  mm/swap: rename mm/page_io.c to mm/swap_io.c
  mm/swap: use swap_ops to register swap device's methods
  mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*

 MAINTAINERS                 |   2 +-
 include/linux/swap.h        |   2 +
 mm/Makefile                 |   2 +-
 mm/swap.h                   |  12 ++++-
 mm/{page_io.c => swap_io.c} | 104 ++++++++++++++++++++----------------
 mm/swapfile.c               |   5 ++
 mm/zswap.c                  |   2 +-
 7 files changed, 79 insertions(+), 50 deletions(-)
 rename mm/{page_io.c => swap_io.c} (90%)

-- 
2.52.0


