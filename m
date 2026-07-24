Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A79C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4DD6B008C; Thu, 23 Jul 2026 22:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355816B0092; Thu, 23 Jul 2026 22:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247846B0095; Thu, 23 Jul 2026 22:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE3176B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:30:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A9FC1C02D1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:07 +0000 (UTC)
X-FDA: 85022090454.24.2A58EBC
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FBB3100008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=a8ZgaGCX;
	spf=pass (imf05.hostedemail.com: domain of gouhao@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=COw6l4tZGKI2EtZCsRNwhO9S4qZRY68UndjXev8R1FQ=;
	b=Z5pubBF+MP/ldzSsjSBSSt+iIf2k3yAllf5Ju+vrsh4LEzChBpc9JqQGALQGbJksvNBKZI
	qtMPf5ECU+WOE+sm+pKeKHtkT/RMm0EWx2LYoquhivoVK5VrShphmXzGWAmstoZrEnyGs6
	bAJaCtMUesdeKCD2ClwCeiM3gDxjJvY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860205;
	b=n+AolpDNHA9iZjUaTUrW+DQ+c6XcrlTL2GJfElA5M9/qM9s/V8s+105xlo/K1OUEX+vtLi
	qL1Kg0lQzRtOmXRpl36s3e50LBX5QvsTffaryAozMNuHb/NN1+qYlbHv8S8fewO0J0/Jme
	mLZaDewuPAB0o3igrqrXb+9KsLonSa8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=a8ZgaGCX;
	spf=pass (imf05.hostedemail.com: domain of gouhao@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860143;
	bh=COw6l4tZGKI2EtZCsRNwhO9S4qZRY68UndjXev8R1FQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=a8ZgaGCX7IP5ahgjzhrcLvGxA79o86aLmAaixDvnoatm0iH/CuHlIahNxBq7/llHi
	 p5l/nAesT3f/p3Pxei/j2qxdXQ+6eS3qwAi6Sn84gZn1tHNwHbqUK2aY7qpPgr9n3h
	 KSgV/tcfu9fPTyhIygu0udE1a21kpVGJhe6Q0pF4=
X-QQ-mid: zesmtpip4t1784860135t56239e5a
X-QQ-Originating-IP: uxNb/JIeTaYaqS/plW1kaXfiKOf+TwmtfXaiPsha900=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:28:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5628155496822218120
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 0/6] remove dead NULL checks after GFP_NOFAIL allocations and fix xive use-after-free
Date: Fri, 24 Jul 2026 10:28:45 +0800
Message-Id: <20260724022851.466017-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: OBHuQudZPNk24HelQf/TE3725PvhhV5BRdb8m73YMV5tfkYMEVFQj/Og
	hebGy3XGQVmk86SSLV3FyIUs7j/wxUS3ym2R0vxBrup6kfWtgbwhqI1i/qO5mV2JLbLRRZM
	+SB90hbXByh3bQCdPTSMG4bHVdHvcAY8QmW1q3DKPrpPwsiLTXQ2nje8inxGCP3u4PHfS1C
	n2nySaTZORxbemAW1YjYakQ2OPSYS41iu9oodH9p8X4ckfnC6jK8gnB1QDpkKssarWDnnRT
	zNm3ObPxp7/PvdG4jUV1Z9rwX9M1Ky1ArFkaLKhm0RudAELpUmd5H7+Pz2haqO6z/JerWox
	1Fspus1vwfNbqwcLj9pNSo0C0jQJX6bFEtAvo1sOT/SIGS1xNuhmMDE95gl/uZF1O0D0Jeg
	u15b9aLqsmE8vcZXlBNsfVJirQbExBr6sBFq7Avx9Ly200zGSCeJNECIChFqO1fudbMUZgQ
	W4TbWCbVjZyFxqIpBs0WtFDQPS6EudCU/GGZqaYxqnCNwxdQX7YfXlN0lDRaQ4kkWcaSGrO
	ktldJ2jharIwHgYkCDXSzpEjjY/AVgSxyFmlknvIYaVRHcjfHgVfqxwcX29SNhpQYYJnwQt
	qzudnwIfJdXLE83YwRTLoTIwlRSJoUfqzl3OFO7kL3ofsDadYNJU9DseFUS980PFx95xgyi
	KAO/EP2Wx5a48uP4M9/g37oAF6vqR1fKztMdZtGHCnqcr8VVkgZPiy6xwqsLWHtfAioPBHH
	IeQbC9G5zOPjce4HmYRHIHcKwMyFSYMPsgyr16kjb+dtfUZ7wSKaD/1M2GH1mZmLntHbyK5
	zTewMX9krPmDzb/7XMdXUs/SOH6al6yaD0HefXFTw2aU+5cdaSok0+DPoa9re5GinQipOXI
	ecFgOa1Orkn++7TWUM37kIiXKUPIKB0f+A/D2M0J3AGXXBwDrkewxEdwMmUv2N0aROLWrXP
	75PlOdEFDwH8U/c81th9Z9Yvg2pCUre/vpLXZJgaZJU1rqv8548nu3ertCKVDgOSkUCMBfD
	o1SyYmQFJG1tP10fKHQqNSrnl08e7276uMpMuC+A==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FBB3100008
X-Stat-Signature: m4sqdectgudicqjqwn5zihzwrax764wu
X-Rspam-User: 
X-HE-Tag: 1784860203-457729
X-HE-Meta: U2FsdGVkX1/+uFW/MqeZzQTL7i4R+kOKAxbyI+/Df7sWRiHCFJEhz+S5Bh1cGM0XRUh3yXQ2lRSO3P5+TJy/o2NHifjU1b9z5Z4FWC3wIX2CT5Yqslb/asIpMTMtgzkZiYstC3H4vwBzUiZBpxyXUYDMPp+Vpj6H3gTyU15AZlur/RmnoQiyDVcWy0BasAKgZnUUSTMHxlR7YEXjcxPq2Eu8NdllKv2muJvjfXZRYMxwml66emlE266vLi+9TciqY+2jnliyDrVhifcHptk5NrMjHy7lvbj0oW715rrgIy7kZCe0LVVg5Kw/vb3q4yA6W1nenAR62cRkYf9t5FJSEROg5Y4BemLK7HvxIxdYO1tYBVymX3B7D4fOWkj3ogsYelB4kLkTJZkqnMFT5fTZe/LYjKkPq9uBDjbH5u6nNKccyjs5adp2mlO/KX/2AbKXtEC1Q0RvlI+jrA74PlDZH8XFJyrA0ekd7ujF0gBMy1z2U13zKDPa0wbcQAxN+qorqxN4wkbziIxB5zhIyLZZpkr4N06/FuxDNQbcla5nMwVmMGh59bLXvQL2zdBf9fMcD+4stCd3DyS6BUdFIWxS4GaWqROxJr443JruEIvabidCiqcsKS9EA6CxWll/D41YY559VqgvKF17nffMHaor77WQlWREzMeQdBBlVwzf0wsjItcblsVXPq6o9/+aBdIoXnROZexTnQxWyOHfDO0H4OVFHIUCYDd9pd18cdIUIHXIDlg8MJKyYN6ZIn4z/SyKBBF6XCDTF9hY+L11eDqhEaL3Fy5JR84te/7rYGNfA1FXIBJ369pOCaPmnFhBh+tz1Kqc9QeB63VSN2ym53wZ7mDYg0r/7BVeILDB+psmJFjENHK3oQ4wRxaJ97Wcnr4nFrzF3sARE6XysjyRg+7myoVWFQxhYHdBoo2U4Itz1iWC07+DkbCFMUbnbL/FPcX1wv/3QpKT7qfrseoUbt6
 AgSOg4s3
 su470oWCy2SXAwbVse4E78crcjRFuyJbk6z4vEA28ftGvxyCl5AuJzQwBk12oJVl1Rp17jlfHaWxLrkmI4OYVeXfYL5AzHanFuLKahFwutbdLQk8oAbhR0ab3Q5OYQGJl6xHPoVNsAiOxBnIo45dLDBML598z+sNVNebis8cJaGjPGXqZfDAxkp/7I66iuDFJQyPdKkolpeOXhWyoHBC8SHcbXsp9robk0e1HiDgbHM4jMq2mKGM7rQ177WlyK70aguJNuNisSkdQM3Y7RCk0JmSlSB98HYexrgT1oeYhGso+Rmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v2:
- Remove the now-unused out_free_domain error label in the xive
  patch after deleting the unreachable NULL check goto.
- Fix a use-after-free of xive_ipis: when xive_init_ipis() fails,
  the error path frees xive_ipis but xive_smp_probe() ignores the
  error and proceeds to dereference it in xive_setup_cpu_ipi().
  Propagate the error return through xive_smp_probe() and check
  it in both pnv_smp_probe() and pSeries_smp_probe().

This is a code cleanup series that removes unreachable
NULL checks (and associated error handling) that follow allocations
using __GFP_NOFAIL, which guarantees non-NULL return.

Gou Hao (6):
  powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
  powerpc/xive: add error return value to xive_smp_probe()
  powerpc/xive: fix use-after-free of xive_ipis
  drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
  lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
  RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

 arch/powerpc/include/asm/xive.h      |  4 ++--
 arch/powerpc/platforms/powernv/smp.c |  8 +++++---
 arch/powerpc/platforms/pseries/smp.c |  8 +++++---
 arch/powerpc/sysdev/xive/common.c    | 15 +++++++++------
 drivers/gpu/drm/drm_modeset_lock.c   |  4 ----
 drivers/infiniband/hw/cxgb4/mem.c    | 10 ++--------
 lib/test_hmm.c                       |  6 ------
 7 files changed, 23 insertions(+), 32 deletions(-)

-- 
2.20.1


