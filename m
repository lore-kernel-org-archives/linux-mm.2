Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA61606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=g6xy8cFz
Received: by kanga.kvack.org (Postfix)
	id CD5C26B0B4F; Wed, 25 Nov 2026 20:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD516B0B51; Wed, 25 Nov 2026 20:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D896B0B52; Wed, 25 Nov 2026 20:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93AB26B0B4F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:59:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F645C0240
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:59:54 +0000 (UTC)
X-FDA: 85475614308.23.CC0481B
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4381280007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:59:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g6xy8cFz;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658392;
	b=8HKHlnZ5vt0kJHgMWi4+hP6W5VQ6ixx9H4nlBLa3pih01qVwv46oMxJ+9+C2WdPds4xxEE
	1Aj6xhOUGYSdTVO2z3Rjlzdry68dQ91vVRPAbYr7TmF+X6X8JzwQBfx/s51YfiWq57x9Ll
	vl1PrBmjkThJaUySHfzOMw3W1GfHfmY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cwYQ9S4xNOhgMpsr/2Fw0/uwY52gpltHLNu3ahogehA=;
	b=4NieK8SBkiFC+WbqheTBkv/jo7A0IQiqUg3s+yAGQvJV5JyCjRjzLDpIaD2oDan9ZZTNh9
	GwEhKFlZ1lGIMYFMzQSXY43l4O3pIn54/ADZVLgapCX8HU4vA2gI4k/ximfHrUNsVJj49o
	2K+fLJCjkXS8CGGLkJWyQhTY1drW7xc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g6xy8cFz;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b155f50c24so5268936a91.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795658391; x=1796263191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwYQ9S4xNOhgMpsr/2Fw0/uwY52gpltHLNu3ahogehA=;
        b=g6xy8cFzW9CiTgbaATwlIvDAlIGVzKg6PijwYNrGNYhJ6kC+52R7inUPz8LHrrVwp/
         3x5672TA+4hVQiB8N4PlebRDI00gNRUs5c2Pb8ZhI2nU2+dlCsZGCvg8rPCEQ8mY+t/E
         Y39OxgaCW7/QlhFiJ9KFQYUG6Kzf5hK03umLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795658391; x=1796263191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cwYQ9S4xNOhgMpsr/2Fw0/uwY52gpltHLNu3ahogehA=;
        b=wVU4ONcnmMzDUJoGZpXjBa/gDnftxEi97W/z2ZpLlWkapXiy10ucCxCbbniP4jlLST
         dBDuv2HxB9BVlqBAU7KJxO4nJh1hGCfAMvsBeeDv34f1X7z+LL3YKJGAqleAcbD1XaJh
         qIKfUm7eUEGC9Izh3cUGsX6EbRAyyXb82EvLaOUpHii4XNinds6174jN8LcQxI3mnTHg
         8FpDToC1hr5aD8fbfNEFVgRSRJYHl6w+XaJxkbe805/Y9WGhC7dn8VuajngtaPWcdOQ5
         BMMjXarPb/j9Ul+DHTcT5RffxzbUI1c1EJ3HC1DlYG5CJKkj8aUhdLCJpcW0KTwoDWUx
         uthA==
X-Forwarded-Encrypted: i=1; AL+hErF7451kXVK4KmDKOALGi84O3uDitWcQKNGqqHu4yKRHXTXY/8yl/d308zwRCaPQFr9LYCISVLgb7A==@kvack.org
X-Gm-Message-State: APuU4Z9YeUyNDC+3LMc8NVVojxq0IjaWL2/bLLiEI4MhNCjsHoRSHhZb
	OukbhosGP8Gm9PXn2FvBrRDm8Qkqc0DzFw4X9ofhDv7GRFNdNr4cZuTEcGhV+R9bTA==
X-Gm-Gg: AZFdTZfj9Zp95pjofF41H/pYcAXaKVv+wddPi7MZfBtRTlm+ZzABarqtKzhsJFj/8OY
	Clm6LS7SYLSSQcUZfuC29qVLH0bnxAmDHGkBaUXEiVGZvuuVjnKE+mDTas3e1P6vtM5+Va0DXTp
	Tm2TyzEjEY+DCE3doahNshBez7DOfeivFB6raNO+pkrQcESaukl9Y6DHtarMwayVCpGwCEeT/UB
	AvnIyJnr7VivvwDAPEylfYRalmcFp0f1b+3hWo7P60xfS8jjAGViWEfmNw2fxkBOSrwihqFBcHy
	TqkCQ/l06pNyhs0pMWT/YVdmsyxaNzZX2TmZ0hoCUNYesY0sRqAMCqHCGxgj7cywb0xwaajHKh3
	DV2jCfv05xkEtGxXixqJVyrpHqDTZYq0xw4LJoUS7auujVw3Xv/b0IbuUDw4qcZu9Y3hqVgoEB0
	LkboC0P1znM6uuHyKorLocM5HaKNua4ElgtXGh1rMNrRoWjte0i1wgqJtxWqTMAjVNoSGt54mbe
	eIceIiBcWwEWdeF0DBO8SsWF+joy31uhoEedmM3OT1JDY/jHxVfFRvssKsQuFvgZrTmdoyFI6Nj
	Qp3OgBeW7NTaBIAK4UTSAS0ZLUr6qVbT/nX3D9L4mQncQZ7sDbois2wFzprvc4GVrzm+cGgxwWs
	639+Nm9Qgcs4NOw==
X-Received: by 2002:a17:90a:ec86:b0:3b4:889:883a with SMTP id 98e67ed59e1d1-3b41c9bacbbmr19770542a91.66.1795658390973;
        Wed, 25 Nov 2026 17:59:50 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:59ac:90a:64:4bd7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4afeaaa84sm14344902a91.10.2026.11.25.17.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 17:59:50 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Alejandro Colomar <alx@kernel.org>
Subject: [PATCH] zram: do not modify cont sysfs store buffers
Date: Thu, 26 Nov 2026 10:45:07 +0900
Message-ID: <20261126014518.1318583-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kzccmhmtcc4c9b1y4ofnbzn9z31ufqg5
X-Rspamd-Queue-Id: 4381280007
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795658392-568415
X-HE-Meta: U2FsdGVkX1824xsQ9MvmWf9yAKvyFG1bJ1XiqJx+fRdbbj3iqameNt9UB51ouWJ6DTnUwwiPbQw9Th5Eu9RcAjiLFgjwLwDOC4mWXXDP0L89aE3tSR0RPtxEHPCj42X/VwMkBBJlVDBY/tXeaxQqrVLn73AB/kZ7cuoHM3nxAvp4FrDEjMVg34YFUsTbsheq2lCcsySFojKYK+2fX0J4HDmMllKNcydZ0j87c93fPdkXqoBzZm0BWvPJZR+WiA4CbyY+AQ1HSOsY6peeUZzC+39BTEwRCFxOgGkpUGJK8VLDcSWHXZ+D2ix22ur43O6DTRWGsc9VPAW5TI6WNKudNlX1/04goH7btuXZ4v5TU4HVgl0o3p12bwS6Cjmsj31Ob/eUFpzA0xKnwmvWSXmuCu5GsJP+9oLxxk+LoiDoE98CMnJ5veTRl3eudeT54ys7N1MRZ49lasmu4GGefVfRKdz+LSm7ql95HKqhg0FQWeZ0f1yOCiP4zHH7VHuS2aYGoCjv4t11sDW/Ss3i6JYuz2MqIrjzEXAtSq70avNC95JLp3n7w5y+aZ2fVlKLoWUPIoXRPwSG/zgCFmkCELbJA5cTbBpxOq7qMfx9q5soViC+6BEgvvhYXK0bDNa6goTjK1dPFtWrXP9qVleslofiePgNv8IwLQRCqbmvzDt0uC/bJQycPi10tlw8rPXQB/S7NTGEyj6PSsej2Q1czzX2MvyCXBkVZTNvJQC2esVjsyDTZgThr7No7GqF2gLESyYk0JjBw2A+PRCnMtIyWpe9mCSwr/x9vkcVU/tIOGv2rs7NhgXtmP8f2bcfMQf0AXv1JTQ0nA0tYdjWzirRvPzS9KjPqmAG9FzrzaNc+gmzEcgxb0DxQnbEVcT7A+ncBmB2scfjZSZkAiS0GfzHG4VmKk1mxKkxKUrmZPeQKMWNWnR6fI2h6tblfILkgttr7kzxRJ9BaYI/f5qZgcT6IUl
 dwnKxMEs
 4CBq7Ziy2xy8+Bz8EGPY+OGoHiad7/4A58X0xl1/TsdikLfUPYYFyvejrPGWV62BEYrNpjJqPRriefk4tdP9llRGSwxSqj+dApoqGSYjNz2a9MNE+QorK6+1mUtt9Tsqi0RB3u/aVlCz3Mqf0PoPcUwUscl/jg9ROH9TF2TpbXzIq0t3On+AqbdIT9jHjrmk0GuUDpJcoUVH4NEKIY0oibiyAJT55oCM4kc7NogE/sime1TjMcgTbY7NDJHcekT02u8GJpyL2kJ2HZW+TR7W1BelvX8JxJYhKOwKg3ZHwtXoVJ0sO/Fqix7oxxVTnfOoB26x8Vvy6Mqc6g6QwfbLgFVCihDBunV87VW86tBf8d0jJtsLJARC9Gru32FFqT84L3D+xmsL1PT0gMmPTzlJ5fC+zzdtvgkze6Gp9lYwWBMQ8y/TSXXYi3WgZZC6r9rV4N3OReesenPK1dhgWZS9VwI0fO3iOT3PnM47zb80iH33AENX0hP3fmIoWpVd10nXfYz2spq3eG1EYjBK88ECRQ1jp9cD3nQ+oRq9gyWjy9uBZeRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram sysfs handlers that accept key=value arguments (e.g.
algorithm_params_store(), etc.) pass their const char *buf
parameter through skip_spaces(), discarding const, and then
mutate it in-place via next_arg().  This is not dangerous
per se because kernfs_fop_write_iter() passes a temp copy
of user string to zram, however it is still probably worth
fixing, just for the sake of correctness.

Allocate a temp non-const buffer for args tokenisation.

Link: https://lore.kernel.org/all/awcpkJD6K1xtx_Pe@devuan/
Reported-by: Alejandro Colomar <alx@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 96b135e3f727..ca12c1918aec 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1279,10 +1279,15 @@ static ssize_t writeback_store(struct device *dev,
 	unsigned long lo = 0, hi;
 	struct zram_pp_ctl *pp_ctl = NULL;
 	struct zram_wb_ctl *wb_ctl = NULL;
+	char *kbuf __free(kfree) = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
 
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
 	guard(rwsem_write)(&zram->dev_lock);
 	if (!init_done(zram))
 		return -EINVAL;
@@ -1303,7 +1308,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto out;
 	}
 
-	args = skip_spaces(buf);
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
@@ -1779,12 +1784,17 @@ static ssize_t algorithm_params_store(struct device *dev,
 	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct deflate_params deflate_params;
 	struct zram *zram = dev_to_zram(dev);
+	char *kbuf __free(kfree) = NULL;
 	bool prio_param = false;
 	int ret;
 
 	deflate_params.winbits = ZCOMP_PARAM_NOT_SET;
 
-	args = skip_spaces(buf);
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
@@ -1899,12 +1909,17 @@ static ssize_t recomp_algorithm_store(struct device *dev,
 				      size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
+	char *kbuf __free(kfree) = NULL;
 	int prio = ZRAM_SECONDARY_COMP;
 	char *args, *param, *val;
 	char *alg = NULL;
 	int ret;
 
-	args = skip_spaces(buf);
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
@@ -2578,6 +2593,7 @@ static ssize_t recompress_store(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
+	char *kbuf __free(kfree) = NULL;
 	struct zram_pp_ctl *ctl = NULL;
 	s32 prio = ZRAM_SECONDARY_COMP;
 	u32 mode = 0, threshold = 0;
@@ -2586,7 +2602,11 @@ static ssize_t recompress_store(struct device *dev,
 	bool prio_param = false;
 	ssize_t ret;
 
-	args = skip_spaces(buf);
+	kbuf = kstrndup(buf, len, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	args = skip_spaces(kbuf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
-- 
2.56.1.839.g22a8290db9-goog


