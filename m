Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFD2C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6E46B00A3; Mon,  7 Sep 2026 02:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78A76B00A4; Mon,  7 Sep 2026 02:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F2B6B00A5; Mon,  7 Sep 2026 02:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A40E06B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:23:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30B7A40643
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:48 +0000 (UTC)
X-FDA: 85185975336.04.57DF1C4
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2501D180005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gPv2xR5W;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788762226;
	b=qWeQ53NrkFqwepTqJEP3ZCshgKCpATRkreL+IaDK01DYTyzOad0uXltsWwh8sFCKSRisMj
	8YDzoY38LvoUXpjXnWN9TCHDF/0vsp/8MwQtGG1PX2kUAXLnvMdWWgldhjdPbRtjARgQnq
	A8QqhoDZSJqluqWe2ti6DnFPqjX5Ils=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gPv2xR5W;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788762226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1UZWCItS8vywVIXvWtrvTvxyn9vkE4tQyoI5BiDSxI=;
	b=wQ3iFC5DzHkEWldycQRvuE2Vl9JwBqTNAdEK56vgdqUVIY1XOgwThTPA3RjikzGDo9lGn4
	i/O92x1K5qXywY4REgjzK7Ja/8jIRLI4Pt59ReDZYAJyWt8FszUmxflyZaZxxQAF4I7lOA
	VaTKMLd/7WGMJn4ktojpUsvB4xLGdBs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dWk9y7b0drDaUlfFd/9bCLMEQv7pdwsvhjNQU3mPn70=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788762224; v=1; x=1789367024;
 b=gPv2xR5WCmei2BlE4GtflZefmNDXluoiWnU5rajvt4Vt+b8SjL04YH5GEufPNfr4AQ3x4XUL
 GnC/KWy2lHyfNi1h705t1T+61VQl+3W26EPM2Bcvi2mpt42cFoVjiLMjqyOp3xVze1u5RszBVo8
 maAzF46K7inKvMUK+Yy8psUs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bbad7cc037fa0143;
	Mon, 07 Sep 2026 06:23:44 +0000
X-Mizu-Trace-ID: bbad7cc037fa0143
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v8 4/4] alloc_tag: release the reservation when populate fails
Date: Mon,  7 Sep 2026 14:24:13 +0800
Message-Id: <20260907062414.106873-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907062414.106873-1-hao.ge@linux.dev>
References: <20260907062414.106873-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2501D180005
X-Stat-Signature: 5z9g6krw39ez5t9mpocyhpa7zp5r4m79
X-Rspam-User: 
X-HE-Tag: 1788762225-814740
X-HE-Meta: U2FsdGVkX18gBK6qhdzzOJsYhifTHsV5PGC6wxIszTQ5u1X8wgCPAqCleLhHPk4l1jtBbHJDdNPTYUBggmNbsxL7rmFTJ4KYy0tYSdRfywiMCbULXXDlOhGQqf1iNQkH9I8u74/4XIvviv2eQYLA6XN/jhK1vOCtSXydZ47tQSQ/01REd/XOZoKRs+7CAJDIDZWW2Y2ok/eHZLkVcw5qoJ5LFddqhmyFP1dAMu76K+P+EXRBKIC8zdNhtmWegpgg6OEKHVfLD3755mbmDCrs8YHFXyBVIoKKDRFPu+76XRgOVnL/qyo5WyHG55uADhzmn/nT0sqFQq6TWeSfnVdU7Xo0NF7xsJFI5ccc+0lfKxXoIOI2a331oiyDsC+Dq0FcA7OBZh9HMLpelpujoaFqSJkC5/qNEcJuTIWfvnFPgncS+eGr7FBVyT8i2hWfkWfXN4b31OgwZRG6q8Xy9hLa0TaUXdNdgcXfzPtA9wwUj/18G3IuZk2SXeQVHHUicMBZAhCT6W1zUKhMsCs/LuHdiOOxef5R1lLeZ2ZGu7GaQhk/bMDXX65GGXF8NNwccbIYnnRNfDNV/Eytjvcu5UpcrFD5iyLRZfbRbjuEigqBPy0GKI3dujZNIin5+PIlaBfRpjyf5qAxu2ePmiwQOW7/9wGdAm9fht1n4bRr0jAVdgQQrOUirfUzv4h9y4DawimL8xYdJPkN1ZrfhOhdKfgc3c2paPcWR8RbU9OGm9tTLUdlkAO+/4dTlsaelyqOxxvcji5AxswE/kcUBtRijPvFijt5mk1iBvb/cYoIzCS0m8dY//uW94yOxRT/fOGPggDEwz9j/22bDDDLQDFf6CrxKoSkqlPDYn3rk5MNJTNYPNrpgeU+FDHbL518/OnRbP15L5uS4qVapOr7RNziDmzC0SIPps7NYdF2U8dEVbJG/2QrX/wdj3zneBAKd2A5C/2WvJDT+weyM5EoEsaWvKk
 9yG9+RIK
 FzfJloI1EIGRAwAP5avdPCOt+zDgR3WlXJjp2orfNK2UhyAf8N1Kug1Ykza6YdGESinsQuA1pUTGsm92YL2Rwiy37y9zTL3Q8Ki15yKa5ZPUskls/EH/PcJ0W/GtT18p0n2aHGoWF4cpZT37AGl55H3KHes0m3Y9uChbmTEPeczx+zQ7eqGRpc9+NXSltQClcNFAjPCvOXtetFLG0tQdubroB0gD2SKEXJR3+uE7DaJ/Ak56babs4BCbowNHd/RRSO5sMQ4S3hvyEGMhjysA3GiBA7VHfp7/ENXiHBNj/9y/wn44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_module_tags_populate() can fail after the reservation was stored
in the maple tree, and the error return leaks the entry, since a
failed load never unloads the module. Release it.

Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 248496470904..3c25475becbc 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -971,6 +971,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 			shutdown_mem_profiling(true);
 			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
 			       mod->name);
+			release_module_tags(mod, false);
 			return ERR_PTR(grow_res);
 		}
 	}
-- 
2.25.1


