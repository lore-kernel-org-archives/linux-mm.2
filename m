Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A9FCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410C68E0018; Thu, 28 Aug 2025 03:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3878E0001; Thu, 28 Aug 2025 03:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262398E0018; Thu, 28 Aug 2025 03:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16C6B8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:35:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFC811DED58
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:03 +0000 (UTC)
X-FDA: 83825354886.11.EC89178
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id E862740004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ccyplAdc;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOiu/GBUWD+aWp2OIEycImwBUVzT2dU285cFy6GfNhs=;
	b=XaAzCSBP73kLPHe8QzLXueggZKeTDk9nqCwkT2RHjcwB1fioL7gcc/TZ/fyG5CufhFfHg9
	bcHKhWTDekkiB/LueqDzZJZn/q//NYtC9DXqpoZVmLTBQd+93pqCI3onuyvQkGd2uBjDwh
	oEhPhhvc2mgzaBU1MN8w+rsxxbOmO9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ccyplAdc;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366502; a=rsa-sha256;
	cv=none;
	b=A60Rw0/8hTTPAb/+knoyOswyDFh7gxfjpPPIc9q3S/7EP73t57TSSVR78rlVK/DzQxmNFa
	lfhR53IuOZQmT3rwFO8TKzOyKn00bk0FAsNSo0ZP9czcb2Ap9ckLkdSsWzogC/+zfH7i3r
	erVuGi6C7q1GKvIYSgAj7iABsAcl1IU=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so681481b3a.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366501; x=1756971301; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOiu/GBUWD+aWp2OIEycImwBUVzT2dU285cFy6GfNhs=;
        b=ccyplAdczIOV0dk8qY5mK/Knwl8iI4Pz2wIXeULoWrLNh9m7OX+0ZPRMGeNS92KXyd
         wPJZFZOpx5JBT78e5s8o5WPGy90hFQb+8ArxE9DBjHR5/Nsh1J7nN/pugyCoQUdOQOPz
         1TipmMoOrFNktyK84ZL9gYdl/5PIZowKcgASNVCge5HlzGvhQgt6qupq4QTLIh/axUir
         KWGBjz5gX6PHerOOrfByl6yW7RGUF/Rw8C7FeFr+txxUV7N+At77odx+NPFD+++GmYCh
         dTazlR6SEHJFlLYy5d3gbaPi9dSp5vais37nPDRTpebxo3DbyHbYxXX7XMBptHmvqX1v
         kndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366501; x=1756971301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOiu/GBUWD+aWp2OIEycImwBUVzT2dU285cFy6GfNhs=;
        b=rzd+t0YgG+CV+RK/EjN0bRovvGtROXJSF5m5Bb+ohedUwfHhfhIE/lKxw95CfLDyOa
         p19G1ag40gftz+/8Uk/LsThUQAqaMZmdl5KDMCOD0KLlVewTooE2q6c1sXhffs7wUsPZ
         fmASXkVt+leWOpfAr5K5YIk3KobgWMZlDnmi2suOS6VwkRJ5nyqBB6YPJiECEDTPxp7k
         VZTdKpBFpgzpef5iel8qcmT/iuVqfncxmNN4T/fNU78eFRQ2oa0LtDRQT++/V003CLC1
         6DtPDmF3UNpuCMVVFyTB19ZOhHFWoNqvWCCBAok+YA29IMXQZm205SpWWM7S1Aczk7c5
         K72Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnXQocbpZrwU699Jh24A0LyV5muwAr+W50k8IUQAUnAy5orrNoxoSUkV3dGfPV/eH06qF6VL6Jeg==@kvack.org
X-Gm-Message-State: AOJu0YwVuKwivs7xFXjDJK9ULHOvDiLvsaYNZHsBGUCg39kp3yQjWOIe
	znmUcG1YWOlRSd2kqQN4s8O58aZkBnPvT/FHoOVkEDoqOPGTKaLJ3D9srV1rxyO7lZ8=
X-Gm-Gg: ASbGnct3D6d0o/kciFZpdSIzy+Iz4j/QZyJhaxo7oaW13T7n4hYBwylLwk1MZQC6iTX
	U2+S+6xo30ViWA/JlEGZwapSOuPcYoE15GIqCzsXgyDbAxNjt2GwqglDhRR1eHLzwug6DRcuxSh
	hLw/6P8PP8V5Meuy2+hDOwSyZb1TvcvEU57pxEA5ZKDtUYjCSqlQ0It/ICrZjI769NfUBMPI9gy
	KQA1gIcE9n52HVZxzS3I3mX5ZI3MDIJspD8B5blyYZzu0kC+ZhXIdruZpaeG0KWbhxPJOCJA/d2
	QwCRTtE3qeyj/NahK+uzFCTv052R0LnycD6Q24DPdSGYaQFup6QGbOVa0W4xiipuqoBFdePkrPk
	cqeknW89vfupeqn9l+YuTozhtDzYwvj+avYPz0UJYbB+TwDbwqxfYh5S5B7YL
X-Google-Smtp-Source: AGHT+IFY7Sr3NFmqU4r7l704msEMWDuzdTM26kIlnGaBdOScCFq81peAWPHhGn4VtotCUhBmhFVWWA==
X-Received: by 2002:a05:6a20:2585:b0:240:ed9:dd0a with SMTP id adf61e73a8af0-24340d11bf2mr32380410637.35.1756366500817;
        Thu, 28 Aug 2025 00:35:00 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:35:00 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 15/17] mm/ksw: add recursive corruption test
Date: Thu, 28 Aug 2025 15:32:48 +0800
Message-ID: <20250828073311.1116593-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kmgrkgtcakrqmuqr3uy443hukyx8tcf7
X-Rspam-User: 
X-Rspamd-Queue-Id: E862740004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756366501-653141
X-HE-Meta: U2FsdGVkX1+munmxDATvnPWDOtEMKzm9T6e1c4yBZFgbFhdPWNMbmDwNpDdnKVFIIlAbjuT4vmusDR6F4XdD1XzruihsKkb0tB3iaZfzUCRc80s/cKz9PGso0Ic+xu4St1veJEAiysQn8T+OMa93KZtEfGon+u3wHZW2bjQ8u640CMGp0D0BDNU3Tc6TI0cAYvkCvHKvqUYH6GJFeHmgBQg+xDNcHJdHsTdrs7beKrY4hoqwLetvFM8OKXq5AvJTIm5RJ6gnatvtyXyQz0JU+5XJa7AbmT/765Gvox6MLlqDUcf+aI1c7INirpnoRa76m4koNbJTOjx9TXwNAWVgzbL0UQTTbNqaP4X+BtBDm1rbW0pUIt6F4zwWW1NUTCImWyWH6s7grLoPo7wBGLYEVHz3z+XGZKCIOTgvzAjiuU6stFz/n1+QGJtM7LrlCYQSNUfIWKW348FpzvXS5uthmRn4bc7UOOyEqoO+qyHbbTu2Z1eN7t4QSd31SSQsIdYaCOiivntNNlw4Snvr4k5X6JxrN3yK0wQo4SPH/m6sxByi2h2L7Of/Dwhol4i8V+qECGv2lg02kMVhXclAZdzmAcpyPrhWOO2lopSQPRZm/RHu1KWQ4IRqBLCj6royk6WLf/IEweQTDGqN1qU9vXwPsTEq6/GHklWALW+kzSE3Vi2fhRU6AE4a+BVEfKW/86/n6gdjCj2nXPOpeQgdUKpNtD1TtaMlUtD4tQ4xkv8ye2T3w67OhageMvxaKvzhjUVzV29ufYM7aW6/CavOaENY+GmGKiq5rRgFPU79Xbtijc2hd38kOQoKQMNzxBqWrr4rlGsZ1O4gCjBbBwhpoOWoiEKgbqE+qImVPsMwecxkIAHQs1Yp7sgoxBxJ4J0nags3y4+3a8HD4njGCW7GXWK7cdCBmpNJlG2GOSJMgH8BLTb8vUViG9MAb6NxVgmLBXYpFcmF0CUJotYE4Kyr+zH
 P07aJg69
 113wClQ/y6c9smIHEv7Dv9kt/9pjngqbi4oXh7uFVhlVrGMNRxpd0KesrQ3HPbc+WUJme0Ld0jdHtL5z8UJPOatsePQrqykTRg9JaQ8v26f8Iu9wCKwiCWG9KvcKZ/8KPKObAh7Ec2lbRoMbt2D1eAuUrDZIABmIy9xbCDpEE2985Q5D7tjTa1znn8Wzg4amsH4nYm5mZEqBwkqeUZMDcr+KTvejEYL69lUiF/NrPuxJZxgfMEdqp1ye6AlBsORu9BQCn/IWVfUVe2+0KqCaDBqUozueDDQTOQhpo5bLUFk83mrzzytwx7Vw8DibDcMol1oyywKWgpDiSHUCfETR+VSQZPMwH8jrIRVDB/RovgK9q8lIrTWAfTU7gdRXy4nGIHE3s9xfYY9/V4aIhrn1kL6TifYneck0qxfowZm5mIaR0Cm8BwOawQGJUJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a test case simulating stack corruption across recursive calls.
This scenario writes to a local buffer at every recursion depth up to a
configured maximum, allowing validation that KStackWatch can detect
corruption in nested stack frames.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch_test.c | 32 ++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
index 1f0d616db7c5..cb216b6ee5d7 100644
--- a/mm/kstackwatch/kstackwatch_test.c
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -146,6 +146,30 @@ static void silent_corruption_test(void)
 		silent_corruption_hapless(i);
 }
 
+/*
+ * Test Case 3: Recursive Call Corruption
+ * Check whether KStackWatch can handle corruption in a recursive call
+ * Write the local variable at every depth
+ * Configure /proc/kstackwatch to specify the corruption depth
+ * Verify that the watch is triggered
+ */
+static void recursive_corruption_test(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KSW: test: recursive call at depth %d\n", depth);
+	pr_info("KSW: test: buffer 0x%px\n", buffer);
+	if (depth <= MAX_DEPTH)
+		recursive_corruption_test(depth + 1);
+
+	buffer[0] = depth;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("KSW: test: returning from depth %d\n", depth);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -177,6 +201,11 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("KSW: test: triggering silent corruption test\n");
 			silent_corruption_test();
 			break;
+		case 3:
+			pr_info("KSW: test: triggering recursive corruption test\n");
+			/* depth start with 0 */
+			recursive_corruption_test(0);
+			break;
 		default:
 			pr_err("KSW: test: Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -198,7 +227,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"Usage:\n"
 		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
 		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n"
-		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n";
+		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n"
+		"  echo 'test3' > /proc/kstackwatch_test  - Recursive corruption test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


