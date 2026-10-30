Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C968D606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 04:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ltkXrYHH
Received: by kanga.kvack.org (Postfix)
	id D45B76B05B3; Fri, 30 Oct 2026 00:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DBF6B05B4; Fri, 30 Oct 2026 00:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE5B6B05B5; Fri, 30 Oct 2026 00:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB136B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:17:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18906804D3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:17:17 +0000 (UTC)
X-FDA: 85377982914.03.5B03BFA
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A54620006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:17:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ltkXrYHH;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793333835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34dnmmkWDdF/oQw4NU5mpC/U4TyeuwFcAYBy77dBteo=;
	b=lxZbSrAx89Img2gAsoEaTECOaaPaxQmjuQrTjbKDqWSVHnrHMF7xVypZ6kk4Y+VdzPmzO9
	gPZt+FJ5ysxrvLcavihoaTaY8C6zOdhojcuU/gUI0g1dtJdeNFpiQh1FNrVAa9zUESq0W+
	ueYrya8IqEDGOcqGgtyelcCLqreKIL8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ltkXrYHH;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793333835;
	b=mZhRGRmOQ4G9Jhy8lwOjCDLlvcD9IoPwpWdOzMzXMnvWZINuA8pIDYMnd/zh1+eN5mPWN2
	W31KnsYxDI+TRzerFs6SR1RSJUA58JP5lHi8PDjII/FrpzJMCwFV1UFuC4PEXrBK2q6aAW
	hDWpiksM/R7saW+Smy7CLvc+9Zd5Tb4=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso716696eec.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793333834; x=1793938634; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=34dnmmkWDdF/oQw4NU5mpC/U4TyeuwFcAYBy77dBteo=;
        b=ltkXrYHHGOs/h0zORAb8iVOpIRsADunSpcStvcTaKDHTKoqHP4qKc9kDOJriJAWCKy
         9IwFG4FEtQvtvvUfBD2iEy0jX/x7VnKt19mwVatrr6QovloWu76At2JYuahNFGT2v4L1
         OQh1DtTeYtprJYq5NsTDlHBGBi6+mauo1iuGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793333834; x=1793938634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=34dnmmkWDdF/oQw4NU5mpC/U4TyeuwFcAYBy77dBteo=;
        b=2FS4DFETE8O5dypMuoBysgeZ16qyRPAFVwgV1GeHKStQUTUEiUSxDa01zUsxoGT07z
         yCBUvB4cc5MKHI5uo9Mg0RQMJnCn1VwnJjzrs3ejsCjYZqTJ8u2ZEKK3x5hThJHsq57f
         RKSGSdhiUAiGLhL0XROc8UeNnIJdFaql/Zf1oBcufVs9iG8Es8z5ibqD6pEqACeHY/GL
         iosdkCIiGYF8l+5c+kofWzujtP6P22a3G+hBWSIJsDxVOH6XcJPD3vYwHYNkgc49LrMT
         8tAfEswdwD7DiaaHVYeAuzbQjFabeuzVYsQ9BOhONNaBqVcq+ja7asDSQdXhNmQEGo+1
         5giA==
X-Forwarded-Encrypted: i=1; AKwUvBx/REUKSEUpeX4wMDYDQCbDSFqFcf6cvb8CLGYZo4YneQXKFHF4XXl9PU3QO9RV30UCIyuOB4ePKw==@kvack.org
X-Gm-Message-State: AFq9FYI03L0r1Ink9EJQLrwLxP3oQX3FXkwvSDkrNBRtLVb2SK6gM4y7
	/obCMokqxwuwbse9JKH0hPJMadnPv9i79VnwhoIOYgv8nY9hvOeyRVSrKolPMpKSLQ==
X-Gm-Gg: AYBFou10fFiHza9dJwjQJGQNG7URkg7A35nkj/kgc0bfht6GdaUVy2Mi6CPQT2PODBN
	fkmn6JDhEPaDwD0h5NwV6R6a1ZhX6WUoeRw+rFIkqyQubflnW+XEyxVKBT5ngeoexknk4ZQ3Csz
	aogFhextBDP+6lVM3Jdk4dSb2KDluGTvU4xfYQOedbuxF+H0qM7m2Y7AVAnxs8/gKrq3k9tWcRG
	g24+RN4vCbBRobGHwPvxvkLx6GrZ9KOGO7/XweHG9ykhXAUWwr8ICkoHWNPoKSIfDoNwYfCaQ9g
	jtyVXpWmMMWB3+COCfhR3Ed/65szQc3I+ZeMitugjSPyYW6gTysme7vZTJcHZvsuSuOSg66a/MJ
	UEwssdZ8cXCL5IJ36mXnIdCjvdlJ6tflEJ2XpIdBe3v1vh+p6S7L/z/PYxeIK/u0FDeW9n4MHKU
	FMrzg9o9b4AIsfLXvX/TO8aZ0BQsTdqNrWsNRah9eoF5Pk0QTCkpSdFnBR01AFi0VhrU2uhogXe
	cmsnNvWmTeglMenQcn4dWuL/YIib7KA3pMufgtr7a9fN2WFk0FzihOQaJ8ZOSWOdj/HniSAmkXo
	ZTg/vqdj8AhXVXu6Sp1Dop/H2Yfd5U/PwNFXjXVWjgrryAXC0vsS7t3atWUZJ+M2a/SMIgr1roy
	RMUquaNQtONo+GzofOA==
X-Received: by 2002:a05:7301:2511:b0:36a:1872:4b35 with SMTP id 5a478bee46e88-36a42203e6fmr1814009eec.2.1793333833628;
        Thu, 29 Oct 2026 21:17:13 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:7476:5b7a:d979:2d91])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429467cdsm3329154eec.19.2026.10.29.21.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:17:13 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Josef Bacik <josef@toxicpanda.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] zram: lz4/lz4hc: accept dictionaries of more than 64 KiB
Date: Fri, 30 Oct 2026 13:16:50 +0900
Message-ID: <f2ac22a731e507e90217a5e9cf29c987ec24e2b0.1793333729.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <20da9e9a5ffefd1e6875e311d3740b9f3c1061f3.1793333729.git.senozhatsky@chromium.org>
References: <20da9e9a5ffefd1e6875e311d3740b9f3c1061f3.1793333729.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A54620006
X-Stat-Signature: ouyjqj1ahy5g46od648kzrm5kcfoys5d
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793333835-926600
X-HE-Meta: U2FsdGVkX1/hcGO5pLXY57NLqI7PdYZ65tA9z0Tu7+kpr+1i8SgYYBg/YSkHkL4LpG7GDGdwmmjJh+EFryCys7vF8f6tA2x9vLvGKQa+kDWtT4cBK5696NyLsiQK9pSrQK4yTRRGIMrYyLeEzqHEZL1nK+mBxFzW6La6IxAEdAUfPFGq200vbOTGp4ZmKo4V1R4KJfqyfF76ui8d2tPNF/ZVQVZ+P/JNFgDGG81VWMs/vgKb5A3UjvDtCQnnAKUxFjfvAEC298HliPzNkycjlN/OGhuMyb6+aT5773GCkfb/jQMpSd1Echr/SDgsjNz+GdH2JEbG2M806cyf30LMjhKicfhdep7BbOyq7hVsF+TQMJcSM74rCaCKlzWcHL+YsWG1uHXqFsxkitPfzpzvt/Vs27d9MFyDM3TKl/ZqGeeVJYbuL0W+fDm74w/XhwZ/8FyG75H0H8srRxmkP7L9VuJE285sKYgYdlOKYdl5qj4AXk3YrjO/HnCtHsV4UYJJAogLXD64Gs2wjqxNmjhxW+3Rmwyr7kKJCI2dBQI3dwep33PTrfq+A/wloB/lC4XKrY8UCUlBTo2O6/GEyFPy87pIbLYPtjduheVH/hxy0KiyIVXFxy0ozdOyikcmdL0+MUB+QzrpMWxynHirG+vFHLcv/Fjm3r1f8LfwMbR8Wsfp7zrHjQSjw/59EL0ZG0l5bG1hbZjs16kKGzCWzdPA42KEFRc26TEYxziCcqpytZh2oTLnwuPBnUxb+YcTcLZV4Ms3qSwKUeEjcI+YY9iLeLKdpi4BFy0kFHu3BrElAtldw552Fvj30Q32u4xuhnFIlTLPkLDQ+lBuazQL2q+iqzhypqy22CXVMkHN8Rki2lSZasJQozmii9gObJNHg1xVjN0FXZ0OrjG2n5/aeM4dIWUaigbH4qHqm1Zz+ziGfGGEsvF2KeWSOOqR3a5oBviJ98PlU+Hcso+PqG9Tvff
 XD1IAksX
 McSojndznUoJ3Ct6Kvd39McW1oi6nYGxX+nC4PEENgjHU8eGhBCZHNHCW/mbQV5kdbTlHG9qWpUs9sHw/8dqxuHAmAXGytSjNNBWCwWmfW6vU1kyeMNJU6MZXfCz01hLZ5vIYvDP45dzLqlFMzRONiNUuqL6n5W+d2Mj6aRwnN99bLQiVhFZwCr0B3xXhZPFxtulbjEUWGAxYSummPG1XNtIxVgRVbzCBEQWWPD/9994O4KKO4f34p/5NuWrKq+9AIf8wfZdItLpGvt5pQ6OlmEJ//F+a+cDakvjf9gCGd6lugRaWcLGPsrORsQKHEhAsf5PJbvyjVe82oqvyBB8vyDfaIemsPAzaCIDq78/M/qQLvEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

From: Josef Bacik <josef@toxicpanda.com>

LZ4_loadDict() and LZ4_loadDictHC() only use the last 64KiB of a
dictionary and return how much they used, which the zram backends
take for an error.  Expect that instead.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/zram/backend_lz4.c   | 4 +++-
 drivers/block/zram/backend_lz4hc.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
index 9767482a2fea..bad648c158da 100644
--- a/drivers/block/zram/backend_lz4.c
+++ b/drivers/block/zram/backend_lz4.c
@@ -4,6 +4,7 @@
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
+#include <linux/sizes.h>
 #include <linux/vmalloc.h>
 
 #include "backend_lz4.h"
@@ -39,7 +40,8 @@ static int lz4_setup_params(struct zcomp_params *params)
 		return -ENOMEM;
 
 	ret = LZ4_loadDict(dict_stream, params->dict, params->dict_sz);
-	if (ret != params->dict_sz) {
+	/* Only the last 64 KiB of a dictionary are of use */
+	if (ret != min_t(size_t, params->dict_sz, SZ_64K)) {
 		vfree(dict_stream);
 		return -EINVAL;
 	}
diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index 2d1364a29b27..5825c8ba78da 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -4,6 +4,7 @@
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
+#include <linux/sizes.h>
 #include <linux/vmalloc.h>
 
 #include "backend_lz4hc.h"
@@ -46,7 +47,8 @@ static int lz4hc_setup_params(struct zcomp_params *params)
 
 	LZ4_resetStreamHC(dict_stream, params->level);
 	ret = LZ4_loadDictHC(dict_stream, params->dict, params->dict_sz);
-	if (ret != params->dict_sz) {
+	/* Only the last 64 KiB of a dictionary are of use */
+	if (ret != min_t(size_t, params->dict_sz, SZ_64K)) {
 		vfree(dict_stream);
 		return -EINVAL;
 	}
-- 
2.56.0.317.g454f8302e1-goog


