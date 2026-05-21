Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8CF9CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BA36B0095; Thu, 21 May 2026 03:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D626B0096; Thu, 21 May 2026 03:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552796B009F; Thu, 21 May 2026 03:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 422516B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C2CD1A053D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:24 +0000 (UTC)
X-FDA: 84790573728.02.6D3CF60
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BBB640004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=nfCJgFXK;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUiMwLPfpXogrlps4hAMsldk7b0PjeII3oCxeSA5XjU=;
	b=j71gZNQbU2oCixMG3dmOXAb+hdRQu66v744sbfzT93xkexh5Q0UMExqaw5ozfDM4W3+WlB
	VlrCEnuixeHkfBM3hjXbxaaKGP35QzN+o7yf2oQRd5yJEgVG5SzAmZvtL3cMmIYFtfEchu
	kuxf9YD3dwnEtJegWcW4AazRuCmCmEk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=nfCJgFXK;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347902; a=rsa-sha256;
	cv=none;
	b=6N0Sfqkkfd0AJvLlhLdV3MCSTDHYIr7LyJBCieFoMINfXEXFEGHdebZARPpA8U/Bjc4dPN
	zWPRhOzLrOyC8arHcYz0TIUUFSYipNcVh6k/EBJFi6fa4G9vKDAaLp0Qe+YyRhrWsoJELF
	YJH8/5amLYj+cxY8vYHbYplRwt7afMo=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AB5FFD0926;
	Thu, 21 May 2026 07:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347900;
	bh=AUiMwLPfpXogrlps4hAMsldk7b0PjeII3oCxeSA5XjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfCJgFXKThvMlVfobGHCKnep/wprKEp3k0Djg2QHgMi8kJQMDGP9pAQ+kTrjAqEd4
	 R8O927B73xTHAZyykoiViMyRIYkdEDodj5XzUW1cv/zADJSvhBU/EzajYdrrk6lYQf
	 mexHnZt3e1t807eH/ceFSr7vod7GS4ZfH244GmCU=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 1/4] nvdimm: Convert nvdimm_bus guard to class
Date: Thu, 21 May 2026 07:18:01 +0000
Message-ID: <d217365f59560ba0dde4291d655355c357d463c2.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BBB640004
X-Rspam-User: 
X-Stat-Signature: xqstnfgndid4ypzmod7mk8mx164dtcwb
X-HE-Tag: 1779347902-906962
X-HE-Meta: U2FsdGVkX19h96BrUb+IgIgOizskphrbNYYw54x75L2HdCEZxBvwujjD99tzLkq4Ty1/bevYQdDmcH8SpTYIyDzFGEicYqWevejA/X1c2eqCHg72TEVgxgstpCb+DeFlIVwx0dGC/CXSIpR2fMzOt4Fi2v3Lkp9/+KYx+bdMUvKkYWkxH/HMKxjyXLlIpE+FL58Mg8kz+yJLQIJwRH79HQHdQZIy3KK8CcU/m4pn75ShrEVT6CrOIpptYFPwJjWWWZVUzKIyTPyfktQnXwKC5TAApeWtdJ9CeBQTTzCySc+Bzaswn1+aRf9mLJp0bTsOJbXpFsU5lvfwrPDWJJe5J8FzdYfWUnNBLH4O6KsW+77i/YGXHGJdBglE696gQVTSm90R2pVvLyqgn3tHbcGf6MckLO+Bapo0MTwRjMuG0khLI2Hz/2PcyLGNbkZBezPfYIvJVrGk+yiBLhGIcCXNdze/j2fwD/UQoDL4jyXzZifHiWeCHCkTkC8s6yZSa2t24r+7LyINBM3EIZzqne3lqpDjhuS8qBkDy4JBgMSZsyM2MJdaFz20jFRdoO/2W5yX6fcl7CEsO50YWg72BUFlQA9W5ug83Pg82KQvfNpPtRKuvm9lr3LmQYVw+jjG6syl2rAttp0pA0Xzo351aRXyIJh/Gei/iYsWz7XERvIs9JsyCF7efUq3VFPWxEMY+QzwAFO5nnUoqXXYLUZiLLIP2R6daq3+8UX/tR7pmdlySodWmwtJ6R5PQe/dKJMk+Ea3lT6OflwMETYCuwkmgDp2wPN6XsVLZvoS6XRMceyNbSnydrqdbmnAB0Gn7LelsYYSkxz/XBx+FUY2hJHIKn5aGrTGZmHx2pVGzOY1WInAfGoc4ZQAFU8ZaahX6yaw0ah9ORxsNbJNNAJ0540LEfdtvzwwRYYAUvGjk+4JSdJar6yEIh8PHbKNbsxwMZdIPGRHhZpP2s0ihO2piLiXmvI
 Q3/tbxIW
 uQWGXdn1EMTqm50siREEItvbwymiBxhwEKYCm8QUvvbrl+OHfgbOSn1FDoXIA6caDc4GRlzJQujsBis1xVOUyji0m7mOUOeT12N7UhXEdwfZjvEmgqmhc/y4NDI8/Z5TraEULaN6oo6ARVzRISu4zp489TjUvNbwISw1WiYC9NF8Y81y8BrNOpUSrxv8C3wR3TIQFJ0Bt0KrXFo07eqgBYLDUkrbHFxcNNK9t3s1nCwxhjlNRnVLpFqYX2uN59AVrZYEEg977dBpiHvRJsXM5wEwEqbNigxGjWXGaxedW8WOkFxqscaKkzfGW5CLdaDmUpWhY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nvdimm_bus guard accepts NULL and skips locking when NULL is passed.
Convert from DEFINE_GUARD() to DEFINE_CLASS() + DEFINE_CLASS_IS_GUARD().

This is a preparatory change for making DEFINE_GUARD() constructors
__nonnull(). nvdimm_bus legitimately passes NULL, so it must be adjusted
to avoid a compile error.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..18b64559664b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -632,8 +632,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
-DEFINE_GUARD(nvdimm_bus, struct device *,
-	     if (_T) nvdimm_bus_lock(_T), if (_T) nvdimm_bus_unlock(_T));
+DEFINE_CLASS(nvdimm_bus, struct device *,
+	     if (_T) nvdimm_bus_unlock(_T),
+	     ({ if (_T) nvdimm_bus_lock(_T); _T; }),
+	     struct device *_T);
+DEFINE_CLASS_IS_GUARD(nvdimm_bus);
 
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
-- 
2.53.0-Meta


