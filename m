Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C55D5B16C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C66B6B0006; Mon, 15 Dec 2025 09:22:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DDC6B0008; Mon, 15 Dec 2025 09:22:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC756B000A; Mon, 15 Dec 2025 09:22:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7CF6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:22:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E165816024E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:21:59 +0000 (UTC)
X-FDA: 84221919558.21.9F74567
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4485A20003
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:21:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=cZo/IlQR/eIopaHxOBH3k2+4rXUFbGOTg9i1lR6l+HE=;
	b=vnDGBd7fELEirxKkQB9SqijIggWUJD7qLXYnV65KrSHtMtbvj40u5HsefEgCzRuyzebSQG
	mAsIHnJClxHf3s4WMvkZR5OKY+Gp2Ol8JZ/abjFZNCL6lkn+sJ3ySZ93HqbCcGA/9Gw1IR
	x/q4z1ADx2unyThAtslrohgygHw5v84=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808518; a=rsa-sha256;
	cv=none;
	b=xH3EpUbTTqqqfkvYjVJNXqyRlTZ+B78X3VT9itzE++ALl7nsULMY0RTDV1NzyBdPVzy11O
	8txjiHTk/Vzku0jUjiK1w6HiECAWhTElUYU24IC2QXbduzEwppNpY9HZw/jVuHa29d9Kh2
	SP5lGonXRgDvTrlheSLkuot8fEHzOFg=
X-UUID: 64f5d272d9c111f0a38c85956e01ac42-20251215
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f43e1b67-0c3b-4f04-88b6-56baf8ccb14e,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:f43e1b67-0c3b-4f04-88b6-56baf8ccb14e,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:dd1bf524195dcf197d833e47ec69bb52,BulkI
	D:2512152221510JK8K5F8,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 64f5d272d9c111f0a38c85956e01ac42-20251215
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1342721327; Mon, 15 Dec 2025 22:21:49 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Mon, 15 Dec 2025 22:20:55 +0800
Message-ID: <20251215142057.588500-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: da6qt994nwfdmfy7tpt8s3tp16g6fj39
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4485A20003
X-HE-Tag: 1765808516-351117
X-HE-Meta: U2FsdGVkX18Cqo7Rd04ui/eueCUHykE3mbVTYYnilVP5Mrjnw7I9VtQslKiC8kKBs5gtRDnnVqyiebyahnzga6Jq3I93d9mmpflmdB0PHc33LNBirlnjOXHaSryJAJOV8BALnNq2h8xuJUNlNb7D4w+R8xLv9aV9RwfsEBxkwz2o95Eo20P5dkUDpX+O8klZyy7zJ7bDiVWQgAbmzDbeyOrgFHEVm6I3blHHxexPKriHDEXW8YyZebo7SFEjVYU/ttuB6bhP07YyUJzSR5y1bOmy5KO3COGN3xo4iNmbIjT/dVfNxZtBS5coXs4XjBsAnzibcEZd1Aigixcj6kR8r1e3euZWxdDt7x7DmEZKKA/KE038Xkm7GfSbRD40rAfH0piEAeKz0YpRDAdaupGm46jZxzNGvzNfsSOw6Y1x8I1Nyd8ekNy4xRkXOcKzRoY8ez0I6F3jqYtedyP40ZFAq8zDFx8R2aBvVifr5jUmxeQSh7GCkMkTjCI1qRjaMWqBk6hthkEjixJ6HVmHKeVmMs66wR8A08IR5GOSi3fgx6SQUqLs7564risbjPpxjeHzJvCeXk7YtNnHtNVxvae1vrg1ypgOW9pHHOWvTDaXOlqEsSDwNBr973UetB11YEkjCBatqzVnk2yLRknYvzoEAhsopD6EUlGCB4BANj3phn/CGuIC6HtIsQHdyKCG6VWOur8K2P+kK3Q9AHloAOKa+40m5vYRX0+UcSJDphW1Qb4Ig+UdPNgyqhWT7lGNGoQdUJYVn7FC+s/4qJFb4JjYttwrnK+/GY8fJgLOWYN3t8p1qeLrj0MOyiG+1jaNw6b85HEvVhA/ktA9Mz2VwKSiMwcvhFCcNe31pULM8Oo13jI2avQ0o4aUa3hUgwiwWt+BrOLIUao6QN/97UCCzDraenyH3cTFaf8IBM6J9T3QRxYTVspoL14SNsnx0EJj+n89a3kLBSFNhKI5c+nc7ra
 H2H4isG1
 8Eunq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset makes DAMON's advanced memory management accessible to a
broader range of users through two complementary enhancements.  First,
it exports the necessary DAMON core symbols to enable building loadable
kernel modules.  Building on this foundation, it then introduces the
'prdm' module, which extends the concept from the DAMON sample code
(prcl.c) into a production-ready, user-friendly tool.

The key strength of this module is its out-of-the-box simplicity: by
simply specifying the PIDs of target processes and enabling the module,
users can concurrently monitor memory access patterns across multiple
processes and trigger proactive reclamation automatically.  This
significantly lowers the barrier to using DAMON, allowing system
administrators and regular users without deep kernel expertise to easily
apply sophisticated memory optimization.

The goal is to help alleviate system-wide memory pressure and improve
performance for various workloads, advancing DAMON from a
developer-centric tool towards a practical solution for a wider
audience.

To test this 'prdm' module, you can follow these steps,

  # modprobe prdm
  # cd /sys/module/prdm/parameters
  # echo <target1_pid> > damon_prdm.target_pid
  # echo <target2_pid> > damon_prdm.target_pid
  # echo <target3_pid> > damon_prdm.target_pid
  # cat damon_prdm.target_pid
  Tasks: <target1_pid> <target2_pid> <target3_pid>(exited)
  # echo Y > damon_prdm.enabled

To stop the monitoring,

  # echo N > damon_prdm.enabled
  # rmmod prdm

Enze Li (2):
  mm/damon/core: export necessary symbols
  mm/damon/modules: introduce prdm module for DAMON

 mm/damon/Kconfig          |   2 +
 mm/damon/Makefile         |   1 +
 mm/damon/core.c           |  10 ++
 mm/damon/modules/Kconfig  |  18 +++
 mm/damon/modules/Makefile |   3 +
 mm/damon/modules/prdm.c   | 251 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 285 insertions(+)
 create mode 100644 mm/damon/modules/Kconfig
 create mode 100644 mm/damon/modules/Makefile
 create mode 100644 mm/damon/modules/prdm.c


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0


