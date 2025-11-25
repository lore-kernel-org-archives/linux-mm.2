Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01082CFD35F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CE26B0024; Mon, 24 Nov 2025 19:04:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED866B0028; Mon, 24 Nov 2025 19:04:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCB86B0029; Mon, 24 Nov 2025 19:04:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD0936B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:04:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50B811A05E7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:04:23 +0000 (UTC)
X-FDA: 84147182406.25.29B30D0
Received: from cvsmtppost36.nm.naver.com (cvsmtppost36.nm.naver.com [114.111.35.243])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0243580005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:04:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=UlwJzoDE;
	spf=pass (imf02.hostedemail.com: domain of s9430939@naver.com designates 114.111.35.243 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764029061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PDv46Swksv6p/TP3lR+V7WaJG7Mrrun76v7Vj0Abryw=;
	b=roXX7RhyLio2l+zLBuK4vAB3AVX7t/UzW3Upep6qwTVXRQcApkWYxxnDIQQXWqTDqqjEEU
	pwYHVRv9eiHR6N0zZySP2dLrLNhi3jNdyI88sPo6VL1kJ+hMLsOHUesULIa2feK8Gpg3d4
	lc/E4Dn090Mi/xQK4DtPjeBM2a3QJZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764029061; a=rsa-sha256;
	cv=none;
	b=awqBnlH3B6RVb0NyWlWpha9m1BHsuz80Olu+ZYGEKlf8NambYUI6bjevub+SuqAsglst2H
	6FgR5B9cHMHcEeA35qWaUGu90+0R63Cik+VQy1WwV15r+RPkZIK32SkfUIzTzH3qNYTawK
	CRrJWlyjyNbZdNyajwImphfAOzuT3dI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=UlwJzoDE;
	spf=pass (imf02.hostedemail.com: domain of s9430939@naver.com designates 114.111.35.243 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
X-Originating-IP: 14.38.141.199
Received: from cvsendbo008.nm ([10.112.24.37])
  by cvsmtppost36.nm.naver.com with ESMTP id pdSkEoFCRq2OGbHPq1YcMQ
  for <linux-mm@kvack.org>;
  Tue, 25 Nov 2025 00:04:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1764029058; bh=dIa2E1CMe2k67XSNWKEosIXOHQ5uREF+wrK39QTrNys=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=UlwJzoDEyE7MTbymyr0jnUcPXlcxF65KglCKFzKaxNaB2AOJd7xZyNEeJdIjVN0ir
	 5G3Qn2+RVCcBTqOFJ4qZgJSKN73g7qtO+sjR70ctIvqsp0dYCADxGQ0xq2mZlsqVy4
	 gYbURdXFjporvMlYUJ8KG7FEg0M8g77n5N32iNG9Fk4N2Ox5DrPkErUr9fF9DjdxLH
	 wexmEPHq+4AilG1CqSZP7gtrfNZ6gT0Mlg7cwvmGYzRNu1TQ32kT69La1tdoQ7k0PA
	 30LJtbrF4okL8blpfLjjxcBVMy1/te8jjtw/Cc1ae6c+d59FxfKlpNmHHE4uz//fjq
	 cPaHlwjpU9mAA==
X-Session-ID: vY6KEOIMSDC-MMbcaVcGFQ
X-Originating-IP: 14.38.141.199
X-Works-Send-Opt: xdYZjAJYjHmZaAKqKBmmKxbwKqpYkEljxBmwjAg=
X-Works-Smtp-Source: A9KlaxKrFqJZ+HmXFxMr+6E=
Received: from localhost.localdomain ([14.38.141.199])
  by cvnsmtp005.nm.naver.com with ESMTP id vY6KEOIMSDC-MMbcaVcGFQ
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 25 Nov 2025 00:04:17 -0000
From: Minu Jin <s9430939@naver.com>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	kees@kernel.org
Cc: dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minu Jin <s9430939@naver.com>
Subject: [PATCH] fork-comment-fix: remove ambiguous question mark in CLONE_CHILD_CLEARTID comment
Date: Tue, 25 Nov 2025 09:04:07 +0900
Message-ID: <20251125000407.24470-1-s9430939@naver.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0243580005
X-Stat-Signature: jwepb374ij9wst15ageq5pkcrxeh6bx1
X-HE-Tag: 1764029060-322965
X-HE-Meta: U2FsdGVkX18gsf89r/cmXYJ/Q7nV34yZgz/Te25TCpM7oA7pFNnWtuU1I7D4Oiszm4COLXhZXS5KIYSzRRjpakwDvg12Ho6qRgF86J72FRMpcKLz70RS1/9c+ELl9Njv5NV3Hz8dMVWI/CKTxjOzCcKvKdOYTKZOUNHXzlR5uaZ55akpnM83M7t9i+LDNZKsRDo1p5+R0eZqeuYfY3j0NvVlEcmLnvBdNUjqoK5iA5gc9DUIGA7bTGdbbg607f1rBs9KjwUvF6e3kky8Gr6bZHNoH+AvixwjtKDqGlTC292Zzk6tyYD5a0jsfaTryRpYzmG1za6Eh2WqaGHN97r1VWgKHunEEWfG1JYR+RO1CNDc8oxHXPu7CtGK8U9I6ZEsXN0VpocJjwTYipq8Z0MbI2EPCmwxphrXiSL8trbfUpgSLW6dR6sv1cOO5XZ8JW6ICLx5iwzuF+OucF7UoIjYX3GjCHkVvoP//tlYApS356Tp0lzaWb5Ww96xf+axr3RZXrJ5pIFOeDKTZOydPDZ87pZj6U5j8j118aCM9EJfVaHp9kQAiPkmUMqhOHIpClQ83hUSfy5NkMh1IKf5u+ZXN4ANq4YOqZjdhZ3lM+56qCsc9gLi7z8hRT/Ov18mqM8oCMLnGbPUldowI/ggtVmI8diiaxhV3Ov6NzKcAt74FJHwQCDSX8ZV/36HWBOuDOuapcnajlfPPcOHaBt70dJzOjUvBwH/+RaoXGl7kR4CGPpSQGFAfQfSW3vt0jmWE2P9PPn2t7hsntOlDBWvOFyO+7CFd/5GlFom4Ss1PSpRKQkMel8s7ofDk2ag6G0ALapgn+RdL6l0oy4gE0IriXbSlJ8+F3loTYpQjlIwRITq41mT+WpeJVke0/hcNgbt+EAoLiOQEhPj7/B22n/qwBOwcdlWRNVfdVMJHIHE66H+akD2HU80BG35ql3LDFSstsFkJrXQ/nIoIGrCi43S0g5
 0Sin7d4x
 jZhkjdRIwtG1zrxO+bJ5/PLfKmfT2U2a15BpdinJ4LoxiIvq35zbc3js11RbudtITEMEbeWFaZc1qDIT2G6TfqWlN2THE2xmw3ZMw0qFtpzcGfyTTuwqwM4gNUgU4YO37Vvp0KV2SY2xDxG7vzYYx8VhEzbRUTKiaFBzcm7gBjd+EGgnAnjnUiSa1hnlxPJ8W7g3aolwuVtCXMhDeQnj2d60E07o9g0hRpa+krfuQZW27IxOuW4SDDxKPMi6h8l510oaIBKxx9PeIWTrfYX/Prk+WrB0aLVgMMFGB1mwF4BVRpb+Uz56zZsfvtu8PPQ1N0PuboBFRIqos72A4yo8LJ7aSDsfG+YxVcWNVtTs1YPk7xZpza6kCdEQHrf9kEVP9mAAa9vvgiRD4hkNSptl1IoYFApujZEb4doJNy9b8oVbSxbvUNBvbU2egH9PsngnU/SecasmsKg8J1lD9ktVo5ipdbbHg48F7Z/zM0cIazNEXkRRB0d2EZMrhW45OaL6s4X9Gio12JB7v/E0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.273540, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current comment "Clear TID on mm_release()?" ends with a question mark,
implying uncertainty about whether the TID is actually cleared in mm_release().

However, the code flow is deterministic.
When a task exits, mm_release() explicitly checks 'tsk->clear_child_tid' and clears.

Since this behavior is unambiguous,
remove the confusing question mark and rephrase the comment to clearly state that TID is cleared in mm_release().

Signed-off-by: Minu Jin <s9430939@naver.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..ed46e12c8060 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2031,7 +2031,7 @@ __latent_entropy struct task_struct *copy_process(
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? args->child_tid : NULL;
 	/*
-	 * Clear TID on mm_release()?
+	 * TID is cleared in mm_release() when the task exits
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->child_tid : NULL;
 
-- 
2.43.0


