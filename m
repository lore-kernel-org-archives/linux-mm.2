Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C68C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44CA6B0005; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5136B008A; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF166B008C; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F43C6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2226EA021D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
X-FDA: 84986116530.24.B949B71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 95B0620003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VQRV77Tb;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003683;
	b=jOXB6UrGvJXMnSaP9leRAjymhPHsQGoLBMjo4Dw/2xEoCagDv41yEmuZeO02n+qhqjjSE/
	0zZeNZ3BEhXu5aAd5nN+8KxRQnvbzhUZcCtBj7bbzuQoKHH5m9Tr/0VcH1/xbUqnmUf17I
	8UYB3La3SD6zb8cVYmt+OZTvyobgALI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VQRV77Tb;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1GFuFV6Qv2wWJnuvFbk/HsH8hWm9YYqEFf3m4C5iW0=;
	b=upZXe19VsxQREiLdCxPpEbTvI9hIujXBFC9UEJtAPNBtXHqSinqYill/GNEch+l+FzY9fN
	c39hgeFCzEnH6Rp6twDftjIT6XEVrFf7Wjh74ZxdzntmLIq6pan4RYYc+RfkQGvIu8tUWV
	RpvZIQR9391oiDr8xFYRLISb1MtkCvI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 353B4601ED
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF35F1F00A3A;
	Tue, 14 Jul 2026 04:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003682;
	bh=O1GFuFV6Qv2wWJnuvFbk/HsH8hWm9YYqEFf3m4C5iW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQRV77TbKCUCH8IIFl5SmwBxcr7DCsc0PHVTjB4QqHoY4fgGMOvJCZa8DI9M7ykYd
	 AGEPwYZeh2oj6uJ+WMGR3dzoJI+taM8N82sUkKnX16BHWrwQ764XFFU89JxM8nrD0n
	 Qa4b2Plfg3QqQbTBj4n1gIxwOqK1Wp563CBJSwNiCnPKFkRS2TCZm/MvncH2lvpb3r
	 lABcSdLR1kWgyT25ZPbRY6oFCHYGBzJs+n/cOcM3hY3LUqfxN7Sbg/YJ0FCOgxYEMU
	 F7dpH1T+W2uEKXxgqOEKK+xMj1wVz+0fP0C6gtbiNKOfGQZVN5yF6aji/nfj9XDyFH
	 DCl2lFWH4fOOA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/10] mm/damon/core: hide private damon_region fields
Date: Mon, 13 Jul 2026 21:34:27 -0700
Message-ID: <20260714043437.95811-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95B0620003
X-Stat-Signature: sirzunprgwssbcupm1zrjkc6rc58bugb
X-HE-Tag: 1784003683-683951
X-HE-Meta: U2FsdGVkX1+buUkWo8qu+UIjv1BYdV5KO3F59+oKykjttCtVwuLylpRgMWs/QZMiwajBJ+pPCqahLlgoGk66h3fRKskx97MPj16u0GxycjA3UXrnCl6NPEtg+a1O1ej9yfFl9HVdn+MzhojaMXKAh/4KJxgcpIPOAFK7T29iyyMBv8nlYWF9lEoui02SLDZubCte2flBQ8DWRMe0/BoCokVsaeZYTE4GfYCYLj7JwsDnG0alj+5Jx4pF3AXXKE4kupUEmJwNdk93HpHDtXXG19KH1RcCozvPw0xa3ovNew0VGqYhr2zRFtKYRz7j5GVyuJSS3BDPlW+AMmjehBcqSWIUCTIigIpmAhYtgKY4CH7wa4V5ATrxp3soi174bdCBQAkUCFLsSyXt16ybw7e6qgrtBHt2ml1ERk+J/heTgjnUUldkeAAWOLbdNq8l90n+VzsbLT+K2yqKXlBo69LVBg8Samrmsx8i4efV7yi/4/G0S6sKcSaBcyHa/ulFu2hxvWyhnfog0a3h/bER8YOlz2w8UvVlOuEvHtbc1PRtaj0StPEV9p2J9nOi8CKo2eFMYRBi6YlEWm+yBEZVSVvRUcDCexr1UmgkuI6LfzxAKlZ9/NvmK2hoHy5u7pRMmxWtXGVTFjGb0VAvZQC/rf8Xq79ijteC3eolHE9upyeYHgJusf+t4VGumDacuUGMCIEl0PhKuM+jBeMy6ygOcFF6zx7js0M06OowCR8e/AEDETMybguXz6VIcJlNiT1X0YeL9FMgEqFnQ32tCtujRlhOMmuzUoPc/uUVD3hLzcozaUu9jVKyLY5stOFs32GlChfIIXlNkwnr9TcEUXX9g5t7pdf7TLfqfLtr+pW7VKz5GljqUdAt5luw1HpFYTUCJIgQuDPXQQg+Ihm0Jo5QR3EI0HjwgOIwMVzy3Zg8VMTzt+pskRpFRzjNbM/bxl2GlFnEnuf8YzvlGnE1A6ntTIR
 VeGZ9QqL
 Mg6JaSGbyp+gCY5jE3z+8GNsUV4/aywrcKfwWn+HhH8ybkDl3A8gKxHDxAIop3sCqFWH/1zrtdLgAox9Gzj9zgv8qGmkGO3CD5sOK/FQZt5Bw8Hx6BykAN3Ma5YtCTIhaOyWb1YWyQZhbQUtNFRAkXkXnNBIcGSRHKEdr5JBd1lE+uJ7byeJ7kY/RQqM1aBqY6Qfd7yDd/ZPTX4mEMNZ58SNFBZ+3GkqXsq7Dy/XI0DIfuYhLGWPaWfNxhSZB1VWiAcQnn2ddYXfjEO2UxEqAykIS3rP+9YNmOuQiLnCUBkssU6vSNNEEEYJTyopt/qNmexN0RqcdRCu15asOzURtWZi5WFpGTR+PKhO9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_region->list is intended to be used by only the DAMON core layer.
But it is mistakenly not marked as private.  Hide it from the callers by
marking it private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f69442a9d4312..d32377e7e535e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -46,7 +46,6 @@ struct damon_size_range {
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
  * @probe_hits:		Number of probe-positive region samples.
- * @list:		List head for siblings.
  * @age:		Age of this region.
  *
  * For any use case, @ar should be non-zero positive size.  damon_set_regions()
@@ -68,9 +67,11 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
-	struct list_head list;
 	unsigned int age;
-/* private: Internal value for age calculation. */
+/* private: internal use only. */
+	/* List head for siblings. */
+	struct list_head list;
+	/* for age calculation. */
 	unsigned int last_nr_accesses;
 	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
-- 
2.47.3

