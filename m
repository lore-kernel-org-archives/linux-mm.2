Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08463C61DEB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64626B0088; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBFE6B0092; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BDE6B008A; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A55056B0089
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 496C1B9DE0
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
X-FDA: 84469470834.12.B90989C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B4B5E1C0012
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=celEuxFU;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vkRHUhoLFWwRAHTxYDQKAwkdD0giaOBvmCXHtShf7k=;
	b=g48RuOmp97FZL4+9JUQr+ZCDX0DN2ERtSjRdtWx1d4sLNTwt3d3Iqodh3UCIIq8+qNQhbP
	CvW4OsL2poGEIDnpKu+uVEmfKWhbKhW1PDJkiH5ma5MuSANPPswQ6GRkxakORZfWOgjtct
	1ciWeeJ7wsLM9bTMcT19Z3otjBD37Pw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=celEuxFU;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702595; a=rsa-sha256;
	cv=none;
	b=ks59W//eGjTlymGL3Gmipd/F6WI7Lpyh+cPWaTo5uvGLhKqn+Y2xra6h8jqaIMPs4zBo+S
	wEvVNwvUb6YcMnLc+bLHva+PcA8+3cxm2sV5AHxqKN+1CLDJ3yVwO94kSce0l9JAT2eOO5
	1nDmVYS31FozJQ7YJITfLXDI/BtK0vU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34A4360097;
	Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92CEC2BC87;
	Sat, 21 Feb 2026 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702594;
	bh=l038CwXEsRXfQGW1aiTP2FYS/HRgWbBchKOVGaSDEes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=celEuxFUEJPGHRlpjOEuVXuEbu7+3pNdX2nDOFCvfoCvNKM5OJI51+jQbxLSzLPfs
	 tlN7VD99W/tL/MUmtrjJGG59xgAvzUz62Vy6YWPOBVQMZxq5swA3XfsBwhrNqpuvDG
	 pH5T7u3psglNSpdCk+S3mDI73aW3FdpwAR0fvr7wrTZOV6vww35173qbdJ4AFGZMpK
	 AWlpT/wQUeDu+DVw15l7sHpUJgt0lndxke4bG/uSiLYBxGjPQHbPiyYCc3f7ZsoyVI
	 f/tX82f7XvG9/W22w6egNzvnHXXth2le5XTYK/cU8a5/1307TRhUGNJQJ4mXM6m2RH
	 JVpEfl5Z9OMhg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:19 -0800
Message-ID: <20260221193629.19332-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1hwrgosrd39hnxmxaipfbj7ss3a5hfbo
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: B4B5E1C0012
X-HE-Tag: 1771702595-108574
X-HE-Meta: U2FsdGVkX1+NMfxOHqqXcMNXYpSH9iJHVVtulUftH6ExTHHb+uG8daedQlaz79qkTve0hskH7dYXvpY+00m0+oJ/eUVae2uumz0a1dSuLx4ZxJwiQ5yVwnESmDKhkZMRDOh80Xm8DgO9vpr6sdaC+lxDle9otyTcPZw+YKTs/zM8pNiXx1WD8RRVSKStrUmP0JdQh+Ap5Q7NkwbCXQz8HPnXY/O+gVpHKv34GvdWHZc594uDxU3h9XeVxJTYVwLOMqAjDkqYPCtoBOt1xBl+ky1yjab042eKRzuoq/RrWOmZ+TEomHL6BNkuQrbQFC9vcF4hLrqUoBjuENbHRRydzuWNzganNXBD/hW3cbfoZoHkfxUrQZNbwUIyQYRrIK0326qqE1+R/o+E5ks/Kjf3x+nrsuRxGeT/oykzr6r7gTSQiYiT9t7DsREdpdBrmDdclDVOGWGzSFgnN1lY3Iqkfr62nH2Yp22A13Cqsvj0U9bht/I+wBgbCdpThrgRZ+PL8dMuhKKPxDW+I5ZYVqGZwINZpWWip5f1SVW3HJC20yZzu9+l64F9ngVXANo1dGVypIbvWx8noJI5RZATwSOfVroR05YxHSdmA86u4vZ1CUDE/W1KGhz7Qas8XTU2CPukdhxAYpTikbHjwgV4KMUIV+T/SFr4VNa/8xpzJk6XVnUhZDeyjotB2YxOkD+HU+GonXwQumcm2BvfOiYTB7m5sDmEjaVfeHdJyTVyg/gTA0BOzCf5Nuubw8XdCmipJiIxMV8FFvp0fplY/ncqZVbSah7svnyO4g4Uj1iE7f2fwZVR0eUbrnnv/dvGfu8804EW2LjZkXQTvxpDMI6k2m4ylhsLnO42k9JcL3JJLLKC5ZgSILF2NXVvNuRxSK1MU7UfKp4wED0I/cMrYdd8GNNt6ZXVSxMw8KLtJlBD1XaDmAyYlS8LQotsgJbAYOE5c6N28YEh2eQuQgDqiDf2Ann
 lkwBGI/2
 754Kua+sF82RUC3+RZsA7WjqtbD5+GKAXStcy3X9FrDONkvbUoc6Xl0pfclhLyrrFkfmDB+fIPQ2xlpG0bWAZRuGEkgznZpJvR3u71t3PGoGubG58MfnWWnk9nOV5xH5TcoLVt8DJKyfgDGi0in45nDxQ8IE5ZZJ5z4ZvFZGlIz2Re5agIDa8WpcqmtfYdPnRbI7msgxSE5rBOOSbjFjkk1eAk9bGjhnM4MoS8kcpuNTPjOmz/13Zzjqxj+xMzovjyQuvZEoCINshAtYLjgD1xvNjBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_region() is supposed to be called with only valid address
range arguments.  Do the check under DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 602b85ef23597..a7f5748c1fe17 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -109,6 +109,22 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	return err;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+
+	if (start < end)
+		return;
+	pr_err("damon_new_region() s called with start %lu >= end %lu!\n",
+			start, end);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_new_region(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 /*
  * Construct a damon_region struct
  *
@@ -122,6 +138,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	if (!region)
 		return NULL;
 
+	damon_verify_new_region(start, end);
+
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-- 
2.47.3

