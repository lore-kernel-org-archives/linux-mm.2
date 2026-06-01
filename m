Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA97CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4100D6B01FE; Sun, 31 May 2026 23:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C14F6B01FF; Sun, 31 May 2026 23:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D66E6B0200; Sun, 31 May 2026 23:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5726B01FE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:08:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCD101C08E0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:08:17 +0000 (UTC)
X-FDA: 84829860234.21.E891705
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id B61A040012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:08:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=iOYhuolm;
	spf=pass (imf01.hostedemail.com: domain of hushijia1@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=hushijia1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780283295; a=rsa-sha256;
	cv=none;
	b=etmLVms1ERgqmFv85rE/rEY1YPZjlT83tRBnJ2JHVpN97K1uXX0TQCNuA27Ew1zScsdT25
	HZReQWZzOPWADRryqo2NssbNyejtqKpETO8hpBdzH3dcr9HOtqzWoOIYV8gSh8f1Q7ZYzH
	i+PRgjiTYCAD8eMGKvCwOtt96zKJDkg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=iOYhuolm;
	spf=pass (imf01.hostedemail.com: domain of hushijia1@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=hushijia1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780283295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QO1KFyPL1+J1GrBWkpwiZMrb/LxQzYLbjd8amO7TedE=;
	b=nJhwmPTE/W84ZMTEuAYALwcWoWPLNCSzXlchg/MjjtqVpnwJzNC1Co7B+qTtbkfj0xDT0l
	kJ/+wlq36PJRWWQ5gWSIt9bSg+Zsw3Jwi0TT1WRuxNydWj38orM/5D+VLuz0UhsAloADMK
	HqCGFHswKnl/xkl0isjfqxhCaR542Cg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780283257;
	bh=QO1KFyPL1+J1GrBWkpwiZMrb/LxQzYLbjd8amO7TedE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=iOYhuolmDrpDMi8DESaZSPILqmUGv4xlmzuhj3fAKEihvM5S3pr4RlMZR2G9YIw80
	 0Lqbk46CgfI7I0s3nIGWiHg/9VMR2WTnjUBg4aKmm9cX1TBITOKWrCWOudOJuz59FI
	 zMdFQEqFy6cTdjhZBOcnkFT0WksaPi24GUIYiidU=
X-QQ-mid: zesmtpgz3t1780283242t05aa13f7
X-QQ-Originating-IP: YRCbA7bqRKH6wAc7eU+oyoXj0OqwQdNppr3PyW5KP6M=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 11:07:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17389882740423473155
EX-QQ-RecipientCnt: 17
From: Shijia Hu <hushijia1@uniontech.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	kees@kernel.org
Cc: paul@paul-moore.com,
	ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org,
	kernel@uniontech.com,
	Shijia Hu <hushijia1@uniontech.com>,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>
Subject: [PATCH] fork: Ensure copy_process() returns a valid error pointer on failure
Date: Mon,  1 Jun 2026 11:06:49 +0800
Message-Id: <20260601030649.2513937-1-hushijia1@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-1
X-QQ-XMAILINFO: Mutteg8H72qDCQX/Hl1ykzF6t2LTCtRZBPGXwJEdobHtvkNqUgyOXt0g
	wEAO/c5hG5SAZgq49k+ndUo58+480+tGkFT5WLwqpVjwD1JichFtSmknyGsJU18T9FQjKSX
	HOHTfCwln3+kJEIff1KUiMuVXeBW7Ksg66Uo7Kle9OC3OV3WmrEROPL5JKEEwVGeiCw7naD
	kkiPoBZ+Lpsgbi1BjXrtVkba1Mrf8OQ9ASK6dgNltj8qST/IFpGfyVWOyd5/BmBRxk72XtF
	r0OhshlLB6eZca7sIpqNqWR7LqSjDMcWNr7jhC9p8T56vfAltOwmg0cAYCXNgZTljbY04d0
	yMTUNFf20YQJ9LGKN//k0z3qlDxNgTdu+EG0QemaU4sGyRbrYmCY0rYJ+8bEQXDo7TI0mi1
	eqcDro50Z5Qs/1vn6ifd1AecLj2MIMBRGKbiZjgARYn3aOX2lKjkhbQMqG039dTti7ZN0Cf
	Oz8B68NTJB1Ts4iUItuQzaggtyBeeNpku9rYPDWL2VHJrQyxjewYDBQb7IOMwUT86aGyG7B
	lFNDT4esYr2BbvD1LcUg3kHW9hmg2gtbKIiYWHew6jus+57cjq+9i8tIb8LM4ItPzdNiTNL
	PHmpO3FRt+onVEgfrS/ifL1F0Fbq9R/aU7MSQ7Ql//vAFFclei+Xjp8bcJmMvAYi/hFujrx
	WhO1N6lXca4C2QgkcukJwHO/WEYPN3Xq/BmzyulhVkJIwhfOIpA89+j8loxmBjE8APdPOOu
	0YjaH5A/mxg3gcMaK90m8sL9iEfr93uu6jz3CWer/b57dNSzJ6v7VAcj99fAoCweLCO55Um
	QZZDBaLd+9W52k4smQ2+wt2vxvPDFthkg3b13A4wwbbI3Vh0ULDHUorDK2BU2ehiS38eTIN
	V1Jz/gDy0PnBUAosjW5MLw3wEaE5D/emUu7XkYNEB9SmwlI6cV0acXmAQ7iV3fAjGRGQK5b
	K06hyctPExH/qfdtladvZ/AF9TM383GP8EgV9eRftIf8iIunb9n5XQFvkmoAVEz9p3Tt8hk
	m3F/71sGCjLCtVzZJh
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B61A040012
X-Stat-Signature: r58jhyren9xspm7735sr81ekijewp3iz
X-HE-Tag: 1780283293-244384
X-HE-Meta: U2FsdGVkX18ECNjC9Mq9Z7W2RsuodumAPtfwjlllLoOUDGkXnV/brZaQyQbcsjUTLuAp2LemKSrKiHpA855YvyhQovrKauyDb7tLuTaCX2V1I1Ti1yMRiFi4xOFldYX5KGGN8qVl7IkTYOJDrY8hQ343Uzt9+DmQQn5t2awXYWoq1ouMe1cjBf3qmcMdGeaYb6Bq2S6M3YM+zvuFPzjdqwtwIX5gFhhNyWJizjB7kQiKwfAUfc1YeR0I4Iwbp/Xdplss4puipBkqcKg+p9O71O/77QplTmJUd940BMawzCedct4Zr7OVJcEX30hKOvG62K0+dNzhQClsYpgryp94EXH7RO1C7JYrwvDNGO2fgQMTLhtMHPX6ibNM+Pdr4741zXLuicHxLb3eBmjVTV9eIOtRwEB5Ed0vJV/M+FcMFkSiQ/xDZordfXbtcmWCXlmV9B5N4EnzsZnUvCR9hbHdjLo33n37xkgk2X2G8hBoz2ZNNuLkoe/hhM4j70QA+SIM3dyojUDuoAa55SQAAe2q44xsl2jkzHKA4PrB7h8w6i8UEicaGQEaD98ngh5B3sQ2BoaKl97Oon7W3yndmY6GyHbjm7L5hc+gDVuoaZBFxNgaGxz1OsmvhFMoxaQ6ikC7GEUlhyyT3MrDyhhjN+XNkFwfgPJ+sEmsBMRakR9zg3lw9NDtHYo1A8Dej2HIr/mZ9jwHMIVN2dQ5I3u4cV454jGd/XktvvrMXgg1bQ2NtjTRNBH7cR0Nhi4rFQYTrEz4FSwFSoySc2dq7GNisEq4r8NXseo9a5rdIO5KCpLQJGx+2BrJ9EMik0Tux/vFP8LxO45QWQCm9o1xWkmG6S+WLmIO++yollRvp5/KxjjQqdSf71ht7EwEs9KGfIyDjZICMlyT25qK296BYFCBEwo9YRyPQ5KGggA4ifESQ17ABon3PZAWOqyOmZOjvuMCsc+9ZbRebS/T0DTlJG6hjIf
 znxXXFCQ
 /ejSfosQAMh1DKfUUc4gGat+AhbHbcyFUtoZxU1pwjOIRxoDVyBzpZ/qp3utnD+4BTGv/n86KaCGquhOgi+YC7pUtpGpTg1UNgcrTl15irA0f4P8F91cqBfuUHWuJKAZVTwmQvm3sMqYv0qQ0cSFxjmuGShSMa94rvg/5qsFTzkecY4xQx6DI/2HzS85URMqwK7wzBtRe+np0Ex6yLLwx9K69D/NQJIuxuw1wmSTip3mjwnr40hPbpgqohWta7eFkXwVAGP9/2iEdLVW4dYUPeyJpYwTgHjtxaWKl2wyZGLR2vcEbgQCXr3U3IYdcpwdXe3BG+e7IN9ZGk5uqU7rU9t8bQAsyQY90QuqQweghzg/kOLcHs1BAhOlqVdnoWLXjMgxg/I9/t4jKZ3j3qrIq9pTFj0Pt3KcLE7RTw9CtsjcX7bfYh/Ev3ZoasQtA1E/dDA6f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_process() returns ERR_PTR(retval) from its error path, so retval
must be a negative errno in the range [-MAX_ERRNO, -1]. Values outside
that range produce a pointer which is not caught by IS_ERR() in
kernel_clone().

This can be triggered by attaching a BPF_MODIFY_RETURN program to
security_task_alloc() and returning an invalid value. copy_process()
treats the non-zero return as a failure, but ERR_PTR(1) or
ERR_PTR(-MAX_ERRNO - 1) does not produce an error pointer recognized by
IS_ERR(). kernel_clone() may then dereference the returned pointer.

Normalize unexpected values before returning ERR_PTR() from the
copy_process() error path. This keeps the fix local to the fork error
handling contract and does not change BPF_MODIFY_RETURN verifier behavior.

Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Reported-by: Quan Sun <2022090917019@std.uestc.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Closes: https://lore.kernel.org/bpf/973a1b7b-8ee7-407a-890a-11455d9cc5bf@std.uestc.edu.cn/
Link: https://lore.kernel.org/all/20260411163556.8567-1-yangfeng59949@163.com/
Cc: stable@vger.kernel.org
Signed-off-by: Shijia Hu <hushijia1@uniontech.com>
---
 kernel/fork.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8ac38beae360..40bfbdfffbdc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2599,6 +2599,13 @@ __latent_entropy struct task_struct *copy_process(
 	spin_lock_irq(&current->sighand->siglock);
 	hlist_del_init(&delayed.node);
 	spin_unlock_irq(&current->sighand->siglock);
+	/*
+	 * The error path returns ERR_PTR(retval), which requires retval to be a
+	 * negative errno in the range [-MAX_ERRNO, -1]. Normalize unexpected
+	 * values to avoid returning non-error pointers to callers.
+	 */
+	if (unlikely(retval >= 0 || retval < -MAX_ERRNO))
+		retval = -EINVAL;
 	return ERR_PTR(retval);
 }
 
-- 
2.20.1


