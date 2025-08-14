Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6720CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB2F900088; Thu, 14 Aug 2025 05:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684E4900121; Thu, 14 Aug 2025 05:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5BB900088; Thu, 14 Aug 2025 05:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48E12900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:38:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE8A513843A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:38:36 +0000 (UTC)
X-FDA: 83774863032.25.1A2A8EF
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 130D240002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:38:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jhCJPxwB;
	spf=pass (imf01.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755164315; a=rsa-sha256;
	cv=none;
	b=G8IDS1fy1YcqyG1H5WjduyN5ftasFGWYdOA64wTz78WtpJ7cy6urkhAg1e4tpTtJmXqOlD
	psANUWozUVUbQL84U9ZDqAqt1C/e/J9dqeZROtuAPonoXXAkYLra8VWUSJ6grDtyeF0YBl
	092WpUgwag487deZeN629RJefAm+EyY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jhCJPxwB;
	spf=pass (imf01.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755164315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lxQ609SiF79aF+tUZK9EpOz6Eq30AySkPKB8PMqfPL4=;
	b=HrlN1YwejL4NMoRMTZ1EXkrMNL9jPxmEcgEKvYSWF5lfvc5sg54+yfWgDo9pVGZ8ht6pfP
	pgwF691/hnejlmAw2ZxyhQUeH8FJ1yScgEfPRBNk1Chfnpfl23/g1C8NOKvj9gFz9bF++n
	QQbaBzikDZuTrFOknQebHs6ApvQE3cY=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2e614b83so599055b3a.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755164314; x=1755769114; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lxQ609SiF79aF+tUZK9EpOz6Eq30AySkPKB8PMqfPL4=;
        b=jhCJPxwB0Mf7Xyxq8sPEgSUGN69uvgICxOu6AV7NrjOdXvJlzmA62UV/QVUAavfJsg
         MXRUYCjmQYHokZSaDsNbNO8XcWY4NBfmJwMWZSspkKLDmyfRNlqj13hROEPqVyFoDQko
         0AcYMht142Md+vbiF6GDRp8X5QU/qmVG5v/7jG+pNbh/vB4pmg3p6iDRbILZmq1SUprb
         PoqvJfkNw8pt7XsZoeKQ7db8LbiySHhyAaEfLq3Fjr6wd6QFEIO/4mQ8zUzR1GVdPyZI
         eXaFf5kl+aY0rHUD2fJa0BwhGQPUXXtBE+JFjVC/Bnnsg8merJon3e/Yl+JnPVNxNreH
         mWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755164314; x=1755769114;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lxQ609SiF79aF+tUZK9EpOz6Eq30AySkPKB8PMqfPL4=;
        b=VI6pZ76CJX49crgkY/kUBHkXiXPURS+dKcOj0kaOKp5+odDPOC6jntykMxYb3Kre0z
         ZYKyQrK1l4odZNwyn68CmQeEDKQoWFCFgRo4riQmzo85w8wscs4/kkE+0yXD9wtASmwY
         dL7BOBCCL6j4f0iOq7q0bcGi8JMOar1L6tzkKKfnxB3ojlX+GAzdatBN0dCGmap4L87D
         hTnXnClkaNPP3FS7aKfEk289Xn+R0AbokZSHQN1UxqAd1cn/fvQyCZuUh299aMX1r87w
         Tg+zpCgy+beF3kcN0DOZ4jEGwdgu7rJzvyjDQ9tPPakU4Bsg4kDr/voTdx2/wpcPyjG7
         tvjw==
X-Gm-Message-State: AOJu0Yxu2c+SH+mk75TE5I5vR9mx9Y9nZk0OrAvmMkDF0qNtWZgAZgkN
	XTsiP75jtnobhFXpba0ZN+UtM/hYmgw58uf+nWb2CoQgXawHIuE9a4ye
X-Gm-Gg: ASbGncszdI5IzVVmPiviVh2rTwxeY+OkmAw2zlftlT+BTBaAfOreWNEQ93JjOru1TAM
	Y1hYc0MyaUETxgfSqqXkmiR/d5GyuxtVlK7odkemqJpo2saaxFNN6kgmj0ZPaziNYc5ZU1+su8T
	DpwgpMiZM8BsbwfJSBHSIwOonr9x1E9t3VsRlE/YlyZpOuP5btKIws64U+dgABStL2iZ3gquEzV
	qN9uZunbefFNzmrY+dyLVF3ri6YoDL1IUJOvE16DrhwP9cIlG3oGcqxPUrNv7r0WPfb6AzC1Mli
	7vl3FQfCNuqilDHQDSu5/8O6LP8Z7jwrr/8NgYZWjzwcVBr06HWtmL5KxY1D4CmBEq1Ob1aLRMi
	Y2t+zBo7PpQEkuY+hHu2lxMo6OUCcFxiKHhsp4Y1onsom3zhoiXjZzPK2jp7hjkg=
X-Google-Smtp-Source: AGHT+IGnBBc3PTnIkHOQStT1GfBXOd7Y5JSOH57uU361QnQ+b4clQK59JKzYjcoeMR32zPHfO+e5jQ==
X-Received: by 2002:a05:6a20:6a05:b0:21e:eb3a:dc04 with SMTP id adf61e73a8af0-240bd06a6abmr3929273637.3.1755164313629;
        Thu, 14 Aug 2025 02:38:33 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b42d4b0ed65sm12555730a12.27.2025.08.14.02.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:38:33 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: surenb@google.com,
	kent.overstreet@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] alloc_tag: Use str_on_off() helper
Date: Thu, 14 Aug 2025 17:38:27 +0800
Message-Id: <20250814093827.237980-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 130D240002
X-Stat-Signature: tqxkcje4xuenn3hzi6x7f3wb3ah957ub
X-Rspam-User: 
X-HE-Tag: 1755164314-613369
X-HE-Meta: U2FsdGVkX193URlC9RZBlINqHh2LoIFpxOYx5jdfUJmowwdokHk2GM/ei2CMzKFmYM6KR6lSsuaw8R3g9lN7TPpDjzF8/WPGqLKktOyLkFzi9x/aNBVIeFZuCqcWazYPW1uhyBjIHImIVDtEraaedaY7C2CTFEdA++QLVoT5+9b4B7I4wckLp9O87SPj1dng2rblz6BP0JqDW2mbC4GDYs4opoZ7tiwmr220hX60hfTmiAxH/rO0u3ccDk8Ztt+p0N/ZpxsHDG44teilX2Sbxle00vZ70CvLXutfxoHw7qz6W0lQ2i0aMY0chsJazsn5Cq24IGcvsTp3HWHboEhxLajDfe4i+y7LchkoIXS6hoqoqnS5ME70D0mAySUcAWdGUPvlx51FXd1UPaoENdCwLEEHwZyIeqzLRH7gdmtn0QzI117lkmLYNkecFVySGSH4z4kdC1FVJATsGg1z2N8Sz07uqTS5Rvabf79smXeLTanlK0oBzB6+LGV24kCRUOJj7t1wYS+XxqC85d9ZbOH4UYXc2v8C0GLQBk+r+Ig7gATKFbUGsLys2YoRJZo/wdBrQCRLIx2MGDPyoPh1vvI2pP9EOyhXG4jbsAQcpotHH6ggcXgoqpaV76FgHmex64XC03HhKm35T5wY/MGdfpkraCPAxN2tw2VKccfO5RiNjYV7cfPtJX+gOlMl368P7Pc/zIeSgmS27TKvL84eF2UemzMNG56lCgJ6N2xNkZNGykV4DqyEnqOtsB4MFsqSnOPjJdWXfs0i7GkgNns86Oe6/HBJVY54/SQBrrJApBckRhFbjoKjv5QkmmObcbtsqM7gcqqp2pKcxXWD89uYaMsE7ZdxmjNUTI88FN6Go7dvcQER2tI4xYeLmPgIBRAuRLT/k6vE1eMgZQdI8UD9nWqDNT9+N4lY/dnTh1OMGhhFCJqkTWoHid0Ju+kNHLLJt/vBaFtm/b2/GPg4UOHje/v
 g6aCIFof
 OW/pmYKX/mgxvqGiNF38SKHu6EtnlbBX2yjUv+oP2mQaZUeMmkL94d9c8xGCHmeozZ2tvllkpwW80m7153rsA0Y0fY4e7wgHM6zF5qcoe+kOVWH87S7EcDdOz9Nap03lut4n4ThiZ0moJy12Y4Xl2i5ncQ1ivUOi7+etd7lhjeIY61WrBwiyX5v7ZcIAk26lsdiO0HjgC/8pyIvzk+6el9mCqZrTYvRRn3VgqpxMae0sHz0T/9HYzImmR93Dq3LaWAGr0ukcRZg9+ajNzL2bHtt9AasTRZkMggerZ8qfQPemWzZsGlawI03bSJsTXqNeYgwzDZdcPsnKBOZu+E++prBsfYAU+Ph7kdgUe0uO0wrSshl1+/QbJyO/wPHgtMwUVUMbgVDp/ghxOwtL6LYTdVCrvfh11JBaWBX20Q5BiLSjp4Eu9T1xn9A17gG+NJqRKDJVRx/JCfllmdSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the ternary (enable ? "on" : "off") with the str_on_off()
helper from string_choices.h. This improves readability by replacing
the three-operand ternary with a single function call, ensures
consistent string output, and allows potential string deduplication
by the linker, resulting in a slightly smaller binary.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Compiled test only.

 lib/alloc_tag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index e9b33848700a..d4449205eca2 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -9,6 +9,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
+#include <linux/string_choices.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 
@@ -726,7 +727,7 @@ static int __init setup_early_mem_profiling(char *str)
 		}
 		mem_profiling_support = true;
 		pr_info("Memory allocation profiling is enabled %s compression and is turned %s!\n",
-			compressed ? "with" : "without", enable ? "on" : "off");
+			compressed ? "with" : "without", str_on_off(enable));
 	}
 
 	if (enable != mem_alloc_profiling_enabled()) {
-- 
2.34.1


