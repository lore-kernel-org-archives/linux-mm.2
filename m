Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C83DCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471E36B009E; Thu, 25 Jun 2026 01:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449E06B009F; Thu, 25 Jun 2026 01:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FD16B00A0; Thu, 25 Jun 2026 01:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E73C6B009E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:50:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 972C21C33B7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:50:02 +0000 (UTC)
X-FDA: 84917359044.17.5F9ED46
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8C7AB20006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:49:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782366600;
	b=m0xx7l47NF4BQuiZfcQDue73YmFPuuioqF4Cvos7Eo9A1Css9TERs69fdPKEAflwJu6oL6
	O5Jk9PNw/AzyrOm2JO7XGLyuEadQCxaofTzyizzAPU2HWJ7WRtZLCst+wTynACjXmvxqbx
	OCJZxPB6Xu72iVJP05c2fJAwpMb4yjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782366600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=QWnSTOsJzyf0dbaV0aPM4Q+SeImZDpbu570V/Cu9nN0=;
	b=g2hbfajFRAyJJLEYfwl1pG1ar+RKeiXWWn+x3jpP+ZeMu/l6ea32j4ilu/o1fb9OkiXCZ0
	uVo8cU5bT2rxjMTLQYr7SXamBsfattbp3uWfNGuvj9HN68QKUiMj6tGLZIcbq1GS5V37I/
	JYaYpmfCVgW63mmgHc0oWgEAELKy/Ko=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: ae7cf162705911f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4a1fc58d-7937-40a2-899c-edc312cdc844,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:4a1fc58d-7937-40a2-899c-edc312cdc844,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:f653971d38e0eb93971b013d818d392f,BulkI
	D:260625134951C85J5I9S,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,
	Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ae7cf162705911f1aa26b74ffac11d73-20260625
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1580749568; Thu, 25 Jun 2026 13:49:50 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	pratyush@kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v1 0/2] luo support for preserving eventfd
Date: Thu, 25 Jun 2026 13:49:44 +0800
Message-Id: <20260625054946.73445-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C7AB20006
X-Stat-Signature: qb1fbksy5x7fiueqbedbuigfsbcr5jac
X-HE-Tag: 1782366599-984866
X-HE-Meta: U2FsdGVkX19RYcJZPzUlwlXosJ0ejviUTKQDc3Z9hPD7bGP8cZ/jzVJTXexXgArlPts/NAeSFx5o2f0gGXBwVJ2DV1Z3a9Qtl4Wz+1/T6aFC1n5MwF3vvb45wFxJF3sBtFRn0uS1M3CYxyd27AJZ8VH/+NY+RS6bncuT2cyW6rSL0Y7a1cLjyw7xI+yPajHGXttzWYIMxZs2krWC7mz3KqMdcvMxiShqROed/u6W6uu0w04Xxfa8VWy0+LcMK4BWv3wr7sSeEZhBY4ijB7w1jDLARUATep7bRHJeVIHRyjZEORTgDaeydni1KCqHzGEd3zXeMvj6XT2RRiUbpykD5X408hrtJrv2hValSeg+i5aVICfGpn1ildFfnkEyIiIGEiH1ejvVaqI9dfQ9sdNw5ApiLUH5BjSqvYZBlupGcPaytleVx3dNBHMCcL6I3gzDs6Nb/kf1KfijgQPUnzqT7sXKJTpB7ay2InWbekoOaZ/gp6wRErXvL3Y5cet3wWxTC+fB6Feguq2t4KihNbJufaluZvFoCnFKtqDoMuOzfXA9699YQJK2hPUNpbuoMgoudp0W43fadKYcC94Jjh0kqJuKUvBbZCgUkF9feo8YjMqZ57736LU5AjAUZ/HKmdSvX+ciw5xAHjCLAFdj5odN8f3eJFz+UXmlgic+m9ZXYOcv0hluNrEm2Wo0SVjr72unZIdMalQFZ03pUGEnc8UYVt1KSVIwe2bAy2dq2eoNB+SNeny/ztE6CmuAgByATJ2ShKZEzFJ3fhPtytaEitJLzT3NykeFkMpJxXOiIF5LLi0Q1VeIOLDDsgwgMZdVE5sN/BNnWhHxCIGPXbFkBHugKC/IO8BFRdnooFPHbmnFXQgiATjPPOlcXtRkH7BrPilBBtZqudWgObB81iH7UMjILksAK/wAX6lq/pZTRc6iBe5P7gCCmIR4FnEDnQNJmKQPFQ/HUwGcHXKxQsYChU6
 mT8RjtrV
 WN6JC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is my great honor to participate in the development of LiveUpdate.
The current patch implements logic to preserve and retrieve eventfd
states, which I developed by referencing memfd_luo while learning the
LiveUpdate framework.

eventfd serves as a critical notification mechanism between Guest and
Host. During host kernel upgrades, we can preserve the corresponding
eventfd states and restore them after the kernel update completes.

Patch 0001 implements eventfd_luo, while Patch 0002 contains selftest code.
Test procedures:
    1. ./luo_test_eventfd --stage 1
    2. kexec reboot
    3. ./luo_test_eventfd --stage 2

Chenghao Duan (2):
  eventfd: luo: luo support for preserving eventfd
  selftests: liveupdate: Add selftest for eventfd LUO

 fs/Makefile                                   |   1 +
 fs/eventfd.c                                  |  40 ++
 fs/eventfd_luo.c                              | 250 ++++++++++++
 include/linux/eventfd.h                       |   2 +
 include/linux/kho/abi/eventfd.h               |  39 ++
 kernel/liveupdate/Kconfig                     |  16 +
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 tools/testing/selftests/liveupdate/config     |   2 +
 .../selftests/liveupdate/luo_test_eventfd.c   | 376 ++++++++++++++++++
 9 files changed, 727 insertions(+)
 create mode 100644 fs/eventfd_luo.c
 create mode 100644 include/linux/kho/abi/eventfd.h
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_eventfd.c

-- 
2.25.1


