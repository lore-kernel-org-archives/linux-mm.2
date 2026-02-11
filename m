Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF2DEB5969
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 06:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5DC6B0005; Wed, 11 Feb 2026 01:44:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C738F6B0089; Wed, 11 Feb 2026 01:44:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55296B008A; Wed, 11 Feb 2026 01:44:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31826B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:44:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEC251A01AD
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:44:33 +0000 (UTC)
X-FDA: 84431237226.01.D345B10
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED88E140003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:44:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of nichen@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=nichen@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770792272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=YgWHrWTeAfcvdG+D40gjhjuv/bFWf1pV+4cS+6LF8Cc=;
	b=FhFiarSb65AbnA3a9Kt8zoPJgYjDVsVICAfGebvtDVglRin6DAkv45p+SlpLPkZ8jgpVs5
	Unv9Uo+lgf7MQk4NnMLLwbC6g/zX1NVf4+Q8su7bXJqK/UBQPMalFqTfVRu771A3SrcFpN
	6ESblH6Z7EXQKbYcOfqBr9em7VGfcsc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of nichen@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=nichen@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770792272; a=rsa-sha256;
	cv=none;
	b=jQDKrUf2G+In3aHLr8ARRJnRGDIVAl/RNCRGMN7gd1neoWRXI/vk8ol4DNW30gwRmfw3js
	Nq2rBCC6yBuReDcv/OSnXvE3LD27YaTQ5c3I2OrfghvPmptkvCvP5s+Swbt2CL68QAMtfn
	mAvoLAoo8yJ0SsFKRWYO0viquETG+c0=
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAAntwpEJYxpyf0KCA--.7450S2;
	Wed, 11 Feb 2026 14:44:20 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: akpm@linux-foundation.org,
	shuah@kernel.org
Cc: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] selftests/mm: Remove duplicate include of unistd.h
Date: Wed, 11 Feb 2026 14:43:11 +0800
Message-Id: <20260211064311.2981726-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAntwpEJYxpyf0KCA--.7450S2
X-Coremail-Antispam: 1UD129KBjvdXoWruw17Cw4xAFWDWFWUGrWxJFb_yoWxuFc_Aw
	42yrWkXasYyFyvyr4fX3Z8Jw4v9w48WFs3XF1Svw13tF4qqa1UGrs2y3W7Jw4Fg398u34a
	9FW0y3yfKr1UGjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_GF1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUnwZcUUUUU
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED88E140003
X-Stat-Signature: rfrd4qff4t7dfxnbmfyxt4np74ypkdap
X-Rspam-User: 
X-HE-Tag: 1770792269-620454
X-HE-Meta: U2FsdGVkX19crufybeUeT9KobXjuYXbO7NlrIsWnFTVdJgm3ajCYrNrwErxxccjauTmOk2/olm0yz6P265ve2mAzNm1re+F3fmm+L75lFJZkhWd6dGxgsXG2kN79VU3dcNdkswhkA960nu5Qv2iraFc9Dpi4pO22/9eB/df5JVSXt/lfClEDZjtP3UFdCw31FztK9ipnSJhGIOQCNtshpfQt/jm6PKgGKMU155ad6kyHjbFhddV66PHfXdYL/e8bW5j12sOT75yOZ9mn2YBg7bidfVC0W0dOB9001/4fykRmvxuVEED7GFYE/okUG85sj/nTQrPgeSM/RKq/xEglMjvQb12rJRt3+AOjBIJhM0EPtpHZLyKgI/GXoT5PdERbWbTm+E2+ov1OibuFVPVh5t9OMtgIbPd6rjzgYc+eJSwDHTg2liKY+wK9qyM93isZ8aPGE+RUutBbu87EDMCvwADFYkn9/P1G2vyG17bJPCoqWUijyYO5nJb4K0/sA6A7RkbO/X6FSEzh1wxjHCOERrID3AMvSaMM0gb4/eKnHhfui1lIQdjBVdULv9E9rlMzMXrOJTevQXSY69p6aXs5dsg85Aj3z/+sJmSFiEIwOEI/kWowX5jwSH/zOr63yI5dPMcY67X97QNNeHDRqUbs7ghaYF1sUU5aBwry5C7lDawSgowfeZ2u70bi7MMjJTlRSe20OnG79bIxOIMOt6KDlU1SxPOQoSTbhr0ZE6BduL5D2jDBCNx3P/mz76Ei4qNFmH22BOsxAwx42WSesAtY12RYgwzY/fhBR8XIqqe5ABr7HzhskkJFl/c/r6s3imLw2xyRzFW57N/IdhbmYmpUFA5ji+4cnsHl1yP4BDdiCBzQhbel6c2ZNnNWwDY6mEIsyJhM1hvxPNR3Rd43YZq0CWzf20xZ4ZcMyYmerlO5bo6byMD5CTVGroLowEI9Jb7eIdyiLcG5jqyXA6v9i3d
 1S1u90Yu
 siHAJkNDkVsHVD8p2BzEFyb8sW8b17+uPara8FXGo+3TDFi8HY9Xg+AN1+23Y7bOLG/OGnOlZ8pN/Ek3g0+KSeFsZ1JoaMUik5qfYaLE/0k42TSB5qeiafHHqHK1H7h6kKzXnVjGNqeen1nbr8UFfCHyS7zg/lUsZG1+0SYnePkcHiWuWeWv4rPUilv3U2sSNB0Q54NuHrYxZROhgp6usbcp6bs/gj8VwHN+fhxqJrxHeJ7BWeMmaXVJaHbi1OvjOad4+btr+AmG46S3BVWI6FinXmtOdTQ/r2FZ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
redundant code.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 tools/testing/selftests/mm/memory-failure.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 3d9e0b9ffb41..032ed952057c 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -13,7 +13,6 @@
 #include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
-#include <unistd.h>
 #include <fcntl.h>
 #include <sys/vfs.h>
 #include <linux/magic.h>
-- 
2.25.1


