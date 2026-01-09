Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9D6D232E2
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD496B0089; Fri,  9 Jan 2026 01:24:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180B06B008A; Fri,  9 Jan 2026 01:24:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FCB6B008C; Fri,  9 Jan 2026 01:24:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAB1A6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:24:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8629813AAFD
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:24:47 +0000 (UTC)
X-FDA: 84311437014.24.59C68FB
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0FF520004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:24:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="IrR/yjsw";
	spf=pass (imf03.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767939886; a=rsa-sha256;
	cv=none;
	b=lDy1ssg0oeyhVIugLbRQDrQxSTlvCrHWplU08CQJrWbig8d1/WK6cGLh0L81TAlOCswKZK
	blVKk/umT3USU0yEoBpSIe3fQelU7++zMQtCLQem+MpjHBzkCScXAwTDDZy96i+HVQ3frM
	qFWgttYx1yPIxEPDFEbo5ee5BDtRUfw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="IrR/yjsw";
	spf=pass (imf03.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767939885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4q7Sn9RU1aXiM9ptwL6dHdYjXW3fLAagaxXYGEC0XB0=;
	b=E33ClqqdppOh4rEyFxuGvle8SldMH3OfmIETloxlI9LLZpnWqZEY1Esxie4+9dSnBBUi6i
	OoI81BecF1SlG4Xj3xdY3lZqagvJ87+6YhFDC6EdY6JkaGea/fMd8xKi700r/Wi72tzHkB
	mzr3Ehd5X/inKBDUSHPEzTCoBnjfA58=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4q
	7Sn9RU1aXiM9ptwL6dHdYjXW3fLAagaxXYGEC0XB0=; b=IrR/yjswoO1f26247S
	QIpzVz6oir83E7/K9vpIpEO8OAdJzn5NOQJJi0RBG9O0uR9XHg8lllIxoXPXPe+5
	yTpTssHp/ooXp6lOY98r1FfnkZVETUtXDAH6IT6VcfcNJ2Ligeb3dLI3S+hTWjUK
	ArxLltzDMSAqwUyCipdxAVcOo=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3P0wVn2Bpw14kFQ--.6242S2;
	Fri, 09 Jan 2026 14:24:22 +0800 (CST)
From: ranxiaokai627@163.com
To: surenb@google.com,
	vbabka@suse.cz,
	kent.overstreet@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	mhocko@suse.com,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
Date: Fri,  9 Jan 2026 06:24:19 +0000
Message-ID: <20260109062419.157284-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P0wVn2Bpw14kFQ--.6242S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF45Cw1kKrWrurWkXryrJFb_yoW8Cr1DpF
	4UWr1rGa95AryUCrn5J34IgryxWan7Ka17JanF9FW09wn0yF4ktrW8trWSvF1xXrZ7CF45
	Xr4IvFWxXr10ywUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.243.134]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhZfq2lgnxbCJwAA3B
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C0FF520004
X-Stat-Signature: fxcj973zqd8b7px6guxc4dx3844msory
X-Rspam-User: 
X-HE-Tag: 1767939884-152884
X-HE-Meta: U2FsdGVkX1/h/N1t0flAeCNUNOZFABL7XrhHyd4l5i6Os8OBT6yfsNfYFxMw/NWlVtB3q1NYUukEhJgqLBb4ywlbL8vVIYDHe4dTHWPwLORE8kJegB4xJ/2NLKaOHtRtJUADra/ESvihSqANDvChS1n5dpsJqIyQr0VBaEJhMqVpAS/3QCwyJSt0uEb4aS/ulhnttElQhKACPH6oe8xtVLB/TMZoX1oLdHk6nCrh2r+OSih6SP7wHvVoSIKUJqChYqKNkp+sDhdeDoPW5tGzBij5jZAzdln3KkelcJZLhBYbgnlKxyo0iw8jFwUrx815MXe+Pam4zh4x31uAdOamX9d8YtF4dVIl6hL/lASpiAFyMvK6A7s6FLCgrV7TVoR7Qh+2ZLj+HdWCZ9ofjozArcxf7qzJyzhrxsNeHwUr9LgAkCdnbeJzl4lCxcxIMqS5ouPG9xS8k+gFeweLHGpy4dcs/A8WLacuxIR1aqO3bT+Qr9ZngulQiw7ItT9zDxC115i0qQsfAXYbQG7O/tpkc0UIngnsSK4+hYGzWuv9RpVjsGzwwlihw9kK57F3EqF3at6L8GR0J5BnncHlsIG/LxQBo+CMqXncNMV7/ktHuLhFHTtKRNlHVgN91tSabCD5kL/nocsxW2H2D5DgPtjhx0AiEU4hlMbWMx9g+xBn5kLAhQCrXwzrlLu1KfNrGJXy/AR1bZhPdvq0DPbCU+1zyo5VdK3msVHiDbJBV7XeEPzp3Zu4BKd7JYFlgqQgcRpu0Nu+QsX/tPVn1mryjGxsNt13sxyOoPCqQ5IC1hUjCvrrv4Gn3cmz//Z1hI50fb70YEECsagy5qZ599kMcKTBYdBJP07heWqgKXtHEVZSYuQXedn3p6nCigJkguhg2bamr/NubQXg3miQHix6KF+eLvdKqwBYVbCBPUxefoFygtHzJPLYhNYjJslFc0rHiuxaa0s22LvQkV4wMA3H3yH
 PGPw6yP+
 0eqRsXpAEVJW1ejpFXIPpqL410T/q9v5Il6hVPmIEiwGgtK5cIRUHiZAXCG4w+nClxNr2e18LaxMzCXMcu2SAolLxlTIy5RCP6ctSe+9bxf10B/xu9EzGPzAQYfckBzcnpdaUd5FZn/eOpDvMbk/F5ph6dtyg4eZmWXkn8GETGZCynF4QQ3f00DV343zDRyuZLEtyKNzI4YC/ZQTeVd6xA2QwYc+ZMzjklF3SL0M8lq0P0z2gjRvAmLdGxr+4SWllZ3vLwP6/+ZifRdum9hRJb1aPV2wxKz1EdjVAbUbg4Xl6AExpnsoGG7WGOWvgGot2AdB1xpeu1GHA7RaK/pAetjG9jncbkAG1VDDrJ/uHjb8jQYjjQT8isK4I8Q5sKymqr7vKAPHUcss70cu1TBbhb8XBtw2fGoxJMwqy7aHSo36bOla8mzRfwSU3a7CodJlDir9h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Boot parameters prefixed with "sysctl." are processed separately
during the final stage of system initialization via kernel_init()->
do_sysctl_args(). Since mem_profiling support should be parsed
in early boot stage, it is unsuitable for centralized handling
in do_sysctl_args().
Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
the sysctl.vm.mem_profiling entry is not writable and will cause
a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
rename the boot parameter to "mem_profiling".

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 Documentation/mm/allocation-profiling.rst | 2 +-
 lib/alloc_tag.c                           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 316311240e6a..fe341d6da7b9 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -18,7 +18,7 @@ kconfig options:
   missing annotation
 
 Boot parameter:
-  sysctl.vm.mem_profiling={0|1|never}[,compressed]
+  mem_profiling={0|1|never}[,compressed]
 
   When set to "never", memory allocation profiling overhead is minimized and it
   cannot be enabled at runtime (sysctl becomes read-only).
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 846a5b5b44a4..81b248196629 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -747,7 +747,7 @@ static int __init setup_early_mem_profiling(char *str)
 
 	return 0;
 }
-early_param("sysctl.vm.mem_profiling", setup_early_mem_profiling);
+early_param("mem_profiling", setup_early_mem_profiling);
 
 static __init bool need_page_alloc_tagging(void)
 {
-- 
2.25.1



