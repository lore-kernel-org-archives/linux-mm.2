Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48EECD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 04:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061B36B008A; Thu,  4 Jun 2026 00:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017A56B008C; Thu,  4 Jun 2026 00:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43696B0092; Thu,  4 Jun 2026 00:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF5526B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:01:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91BB7163468
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:01:48 +0000 (UTC)
X-FDA: 84840881496.02.CDE19C2
Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0DD4C140002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:01:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=tKVDVmDC;
	spf=pass (imf09.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.173 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780545707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pkfXfMWEmD1LIAkryX6GUL1GM5bO89J6ScY6PxJ7D58=;
	b=AvL0ebs1yN5ZQoztiD/Ajf7AK7SHgLqjkRNAUHIazepiRA1S+hyAqmHLkPnlLkubGSjd4o
	BpQIgzpJaJgKp+x8BBUcsmW38IGRe0T/821/k8jjf8J+FZD+g6io2TmaCCFbPy0Jp7HrbP
	6am15eknA+uxile1HdwOE8mitCEtQLE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=tKVDVmDC;
	spf=pass (imf09.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.173 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780545707;
	b=PAMvxo3fzNKu9w6s0i/oWVOhoe4RxqXvEysF7jxbOUs4NfH0hSDQbffGZmvlhQWP+bUrnP
	CTB62Hu+x0gIbLhX3w5nzsJmz0szQUmdgaHHm8jFavhkROuQmnOoBt5h8c5ARJjDqMiwqJ
	O6PrBdwWR+Gl/YTrqKS0FKXnHbYbZwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1780545700;
	bh=pkfXfMWEmD1LIAkryX6GUL1GM5bO89J6ScY6PxJ7D58=;
	h=From:To:Cc:Subject:Date;
	b=tKVDVmDCmtjkqVrzGaUPSRoGXBki5OnLtjd79AfujN8bXgxJrJHLPCfam7zOUV/50
	 bvGqhjav8OiYK/6agsjFcwrJiGLsvq3+Y0vsx/fPoQPTwuNGN/iVKSAmYWNpo0oE6b
	 W/VDSdvTCbJAdYVtjP2f3flPsi2C2VuilZGidaqk=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 672E864; Thu, 04 Jun 2026 12:01:39 +0800
X-QQ-mid: xmsmtpt1780545699t85b50v8r
Message-ID: <tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com>
X-QQ-XMAILINFO: NVJ0hJNx7N5SG/ms+CQPzJJFMa+sJr614o11OeECXE+b5prhPdz1C0qcIpSJ0m
	 +0LaFdFTp4eKusf6JtATYvEjpIjefkQmcPtCqVzqD2e0QssVsUcwexcWH0X24eXufwdRoPWNjA/+
	 YIM1BL6RoIcZ6qpfyYalw9XTglZIJlAxoHFNwclg7LIka1Uekn1oeayE3gNTJ3wX60mmCInGWRja
	 /Hp4s4ZNT8Yol/BJ7IVLKr9kPMEjHG134aGbn6rr/4DwFi3ldjhDNo26vahgLKy0nGH7wMMNB6Lm
	 RrvJONFn0ozT73Zfs7Q4YVAWtvwP/vW0T4SMojPAHe0E1O6eunso4L17FwlbDq6iZvKGcnnPFhCm
	 UuyBajcdMvluMuPj8/u06exALm1Gfz0Jr1YbqlpA09XXVST1KERb7VKccxuemwmWbyYu59V2USTq
	 HDoufgf/XDpLQ9pC0gVrwb3UwFVG2LTVd+2C7KlVsFwNE70LwfZX0OcA3oHVBz4iZ33Nrrpws6vh
	 tzQZYthOwp7NHv+jw3BngPmc1msb3ze54GhTELvfjFixEYJWHsuxr2K61HUggK9HrFlHoSF3KUmQ
	 fdw8Gj8/o3uwvSU582WT1PJD9rPEErMN0HkuX/3kOC1TBFJZTeB66t6xN5moY7lFDE64zoId+Frb
	 51F6DhdhgbgioBwDpXsRxQHHK6m9wkk0j/prpA9emy9siT/XfBR9qECXpUpmBr02xMF3emE0Kxb/
	 UxBT2tS5sVazFfj/mL40bBftjVEKDnyFERTYpXDZijmA0AH2qqm4/Vs91SfqHRctCErH7VgjfzSz
	 8WK+abyd6SZwqzUOnrUEY0Hi6Uzdq77aX58dqXhBRHnoVfDeyxIF7kYD+5VHoazYCuOAXXNPwzG3
	 DFdcAb9tnAy3HmG9fUHytKuQF/pWdzgKtXq55diBqbME28G+mYnESkljhgyqlJPKZduYGIXGlNOf
	 dJ5J8RakMH2HZJK5LQgvtIIKD7WMpNV8Jbmepy30G16aE+A+UMWlrAagVMLv+3xzyyK1eCchjdMR
	 DOhJujlw==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org
Subject: [PATCH] mm/page_alloc: only update NUMA min ratios on sysctl write
Date: Thu,  4 Jun 2026 12:01:38 +0800
X-OQ-MSGID: <20260604040138.1378489-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0DD4C140002
X-Stat-Signature: 6q3e78z6bz154xpmrqmk6zxfrou5ogm9
X-Rspam-User: 
X-HE-Tag: 1780545705-771210
X-HE-Meta: U2FsdGVkX1+OvEDlyj+qReSIwfwjbsrmTTEsLcI/eiL/qdd7f8HstwnCpuQgjDitHvf+GDbQbcisbv8nm7tXRrAApNWkuj5pnJJeWvC4cB9Wq3vdHwktwxwZZQh/5QI104QsyEZAlaXX+a/oZDcNdSLvg86JPJZfJHK7baOm6ngrYNPS+LKgzJa7aYJ1u4IU3wTSjaC0iEaz8fiTIeuTeku4aacfKbfepdPHgV0yIpppZlufnE9xNHDjpTkFGgYrArQwm9vAKEvX1c7LPbWS2idOLoE7+HilqH/zJHkGG5x93ZXdGVA1S8pkRdLUa8bDseNcXzZfrLW7gVW9Lb5qFlDQz3KkE+J0Z28dEyfDDxYETWJmNZa7wgPFC7Lu2lnzhd0HE4P6UdgplqRXO2cluZFVjVnw4Gg60Jtajrs30Td/5R36/iBbhEx5y2KQ/sePfIQpiLgTLAWbuUSjIUk95wvhknimxYHSiiL5lVkfttHJaJn3+7o5pzGvaYyYsWejlU55gIES+n/P3s3VAkLJaAGBphRm+BBgs/5QuTZ3EPZJczERd3juv3+1xI0gdSyvdKm938xtX3ct02DbXCKmqkeft8iEcQS/0oUp49KUsEMbZhFR5Tg5HaJaluzDLP4AF4hnebkY/ccqtrNDjRyd8/a/ZqvyIDtNq2XHLSkcK0MaAlpTYrGced20s4+GLKQSjTmNfOrv0YCsht4h8Xx/0/uS2IcTfCLkJlNowXx3584esybjEoEktWFTCzvxUV+cogAbCWi1wuyured0uiEL6tMZX2FCYZWRFy/sKC0mtv7i/jwhxWOLiGpHDQvBRln7AWp5I8QrLEdFaYr75RSXtAdtpXFG8Y71a7FFwUp8sVwPHWyBh4lpJ6FF8QxYiGdC1VUNDtdL5ECp4lyVMfPce19/qo9oePPVwZ8qRDuf+cFe+nODojp/v47bBiko0FCsZiqEZfQWApIdRvkRaq9
 bQKtSUFK
 rl0r15MjHvkwrlQCk2BZ1ZGfMbDuUiND/lxpjPu+uMct04vU3jPIBdVIxS1HrtFk8iU24rybeSpCDso0KB7pPs3VRJliTUxfIk1NFpQj075WfTylZhwxak4iNn/hEqZ6qJLM51KvUs/7fUtj/Jn5hL5rYwCpDY1oJiRacnXilZ9tqmdQy4udtoc9egyar2tdYZn0W/m8v9zxtUDMdFPiq9av0ZBLXxw7gj8YSk1md73tS2P+fmL9afws5JVAaC7jGWLmPRTZwypU8MK8elVbrZVHCeMRTa+DFXdmgayv/9yEcj7gHnIywm624c4NqJcwjx41P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysctl handlers for min_unmapped_ratio and min_slab_ratio
invoke setup_min_unmapped_ratio() and setup_min_slab_ratio()
unconditionally after proc_dointvec_minmax(), even for read operations.

These setup functions first zero all per-NUMA node thresholds
(min_unmapped_pages and min_slab_pages) before recalculating them.
Reading /proc sysctl entries therefore temporarily resets node
reclaim thresholds to zero, which may disturb the behavior of
__node_reclaim() and node_reclaim() during the recomputation.

Fix this by only calling the setup functions when the sysctl
is actually written (write == 1), matching the behavior of
existing sysctl handlers like min_free_kbytes and watermark_scale_factor.

This only affects systems with CONFIG_NUMA.

Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a5..0387d2afd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6636,7 +6636,8 @@ static int sysctl_min_unmapped_ratio_sysctl_handler(const struct ctl_table *tabl
 	if (rc)
 		return rc;
 
-	setup_min_unmapped_ratio();
+	if (write)
+		setup_min_unmapped_ratio();
 
 	return 0;
 }
@@ -6663,7 +6664,8 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 	if (rc)
 		return rc;
 
-	setup_min_slab_ratio();
+	if (write)
+		setup_min_slab_ratio();
 
 	return 0;
 }
-- 
2.43.0


