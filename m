Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A29C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696016B0092; Tue,  8 Sep 2026 12:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646F76B0096; Tue,  8 Sep 2026 12:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D186B0098; Tue,  8 Sep 2026 12:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 396D96B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:27:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB3D11A06F8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:27:36 +0000 (UTC)
X-FDA: 85191125712.24.C147365
Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1290100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:27:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uY6g9PS7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.41 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788884855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4HXhxPoHHmCIta/BW8HcilFf96bR7ewwCBzZ6D5Jcss=;
	b=tKUeeJNAKdNPgDGU4OVVuX7RdSYBgQ38t2IXuBDLgp+CuE0SWWFH8LvxNJ7vZfaNJ/Ksea
	wmopjx/NzqWkFavXnRx3bhNy23oAhtwd0yHOjNjnQ+sFCKvVLcRuiL3/8Tccfk3ZvdfuCf
	xZeXokBvaijsE9FLsPh3x9oFWukWzEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788884855;
	b=QPyunfejC/MDPAeLcEAXaupY19SgV1IpCiobzIHFfV1iFrZH+5G6ErS/S0rDVjJcT9f2XG
	kffgV61ArvZz2OnzcV/XN5m3HhQcJ0EiaL5uGeyCUiIru0RSsH4/Qo6aQJ49VEpeHDlM7j
	/dNQ2ZnmsoV7Yxg2bdgGRY/PEjhZyP8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uY6g9PS7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.41 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P9rcx9cRYKzp1j2igJPf6N36DH81nBcUWy49yeFgq6s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788884850; v=1; x=1789489650;
 b=uY6g9PS7jFL3fQgacYlFZadH5klyrWZHPkaqhsknw1WBCFuEKKBiUpQBjC1/WQZjyF1aWjue
 ZTZErUWstlgmViILyrBOD1mCDCg6bK68aUqOXswZGALVbLKRIsA4XhmvNeTogpXWD4okYlbwHvJ
 0hu8JiZO7eTUA/H4IPlZMkm0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 24572b4011ab19ae;
	Tue, 08 Sep 2026 16:27:30 +0000
X-Mizu-Trace-ID: 24572b4011ab19ae
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	shuah@kernel.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/damon: ignore test-generated damon_dump_output
Date: Wed,  9 Sep 2026 00:27:16 +0800
Message-ID: <20260908162716.85648-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C1290100002
X-Stat-Signature: 4tu5s8kws85kxndkw1c19artfsgjnc3d
X-HE-Tag: 1788884854-619535
X-HE-Meta: U2FsdGVkX1+dKUQGqIzkQJID3RWkMe3SSUkMR8z7enssn4fn7MbgWxQTN2xpnrOy5zOZxe3xcRtEVZ6NNW134Qv0/O22+oETUGFpHcgfJ94gm1lNEympFl66P+6ZpNRtMicuHuJPNJsan2GxllNvGmjcKUlq+e6mjFRB+nvpm+faBAS875OKkBVUqVBml4uyviX30wluORMLz5W5KUw5PNArDuMZFxWraOFBZhqyOMlKsh6SIhBqzQrISR4jMESCI/WXcLq9TbZtUrRThFFxESJgUUtWgDWR6n3vGi3MJw4F6MB0uBxUx8YPel3UqddUqSC+2t0ZgB8cWS6JdtdUwlswnhbUUaLETNQ5UhIr7sw5s+OG9dcTwmiwcJPQwh8WEwCXh5jycormBLpMKBsSWGQ1O6k0X0M8Hyi8fcURtzwzQhZg78wMqfPwEsWJsncGJK2L5Q1LLPyMxVRQOaTO+z0z6eEh95pK+zbFXAfu6pVk3p/Iifnn1n3PriKVS+qt8nAuKuWiyW7Du1aNlE8LI23pCXqng2QIg0UCWun//kT4XBH7/5rjNXd02znzte07VX7FpH2ATnSRpCRNxgto3JsBNGKtPxeLe42ZyoCtOXSgCDAqCqYkp6yvSakfa/xg1dXn7TM/hNVK2luOT9SMol7mWBgqrLrMxXR6UVXLSLRn7bUcw66Wo3YQCWRiL9hHr3PRc1p8Hl+J4AzG4HvGzpaRSaUNW7CuKZrZmg72N0PQ/CBJalNVXJXdg5FtwT+Rfgemvm4hHn931qe6v5KL2U61fkBGWRcj2YOiL4e2BmupSOYX1AGYRP3ugnp85d29eSBr/yIhVMCCbGrvFGHgi3L3NbYT+t92xSuPQlRGezBP4hQoH0vxKwyF7D+0knBcgxk7kgjjFluvqTYpFh8NmNstZZM3SoJsw92akMEh2WNcFNOwIg0+PkOh5Pb5/GkTW4j9wACPB2TKXrdvTVR
 d+cVJPjP
 eQtpjNvs+MG2cXCCCeomx1waqtCDrwo9ybZK7eGLTPtk3FyKqGkcu/njNLkQVG0MSzwR7dEXXBVoSxAFDFah+l5qC8YXq9jE/iFAZKFDNdAydX21NDld0aq12JUx/b4ejHIrSmKRuHk61tNzAua2+VO1QJBW1kMwAjvo2UeMn/U+et9MnVJxRQ4QhvNZ44PmDcfdkJkpiiwGhovZM5dcoUPaV8/WBw57FF55qv+ZWyAeL5WGlTKwVeaBniJ4i1/2hDoC4Z8BX3aieAmtADRPV74xpqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

sysfs.py and sysfs_no_op_commit_break.py dump the DAMON status collected
via drgn_dump_damon_status.py into a damon_dump_output file in the working
directory.  Ignore it so that running the tests in-tree does not pollute
git status.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/damon/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/.gitignore b/tools/testing/selftests/damon/.gitignore
index 2f0297657c81..226bd7c4e072 100644
--- a/tools/testing/selftests/damon/.gitignore
+++ b/tools/testing/selftests/damon/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 access_memory
 access_memory_even
+damon_dump_output
-- 
2.53.0


