Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E13C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04CC6B008A; Mon, 13 Jul 2026 02:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4F76B008C; Mon, 13 Jul 2026 02:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6FA6B0092; Mon, 13 Jul 2026 02:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63F626B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:35:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF35C1C911F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:35:51 +0000 (UTC)
X-FDA: 84982792902.26.7955ACC
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id 682541A0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:35:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783924549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Dy/qWfq+XSzexKHVrGW753jZFixY081zkXBKLmWUP4Y=;
	b=Dz3IJgVSknfVrjwAfb4aTtb12v2iS8My36tCQ5WJnPNUdNduSpGb/IT/+bBmKjY3r/OQ4q
	cqw1evS8Ms8sFAqpKYn+0vKco6aotkwnzKbi2K8q2i/UIKSZ47nqGnGWup2sIjMDU8nDbS
	pACEmhQvT5cQiLRB+T6vPEg7YCCVmUg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783924549;
	b=UI++FAOCEOqNcqgHN7NjgM+BhShmpvlSHEh4nhsy6nDZq+LB9IBIqdgvEjbx3PLw44ZCiF
	eBKtlTS8bnsTiEdsThYXg1UyBT91N8ntPGjhOqwJx+hU1Iax9P9lg+0m7/ziIFZD5DMdgp
	PTsJ4u6JdyltxmYfQRx1meamsJEHRq8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzCPC3JWkz8XrrJ;
	Mon, 13 Jul 2026 14:35:43 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 66D6ZXuZ070014;
	Mon, 13 Jul 2026 14:35:33 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Jul 2026 14:35:34 +0800 (CST)
X-Zmail-TransId: 2afb6a548736e3f-52e47
X-Mailer: Zmail v1.0
Message-ID: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn>
Date: Mon, 13 Jul 2026 14:35:34 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <xu.xin16@zte.com.cn>, <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <baohua@kernel.org>, <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvMl0gVHdvIHNtYWxsIHBhdGNoZXMgdG8gY2xlYW4gdXAgbW0vbW1fc2xvdC5o?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66D6ZXuZ070014
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 13 Jul 2026 14:35:43 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A54873F.000/4gzCPC3JWkz8XrrJ
X-Rspamd-Queue-Id: 682541A0002
X-Stat-Signature: sn3obubxyt4nmyqmtjijuzk6psitizxb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783924549-687741
X-HE-Meta: U2FsdGVkX1832AHmuOfFzxVkFyay5TFa7i40oyODO1g+VYhQElgf7LChJ+PeWxWBTIcm3sXKX9UGRKlauVFcuBF39Of5KJ8WrH8uvVJwwIrv0gKWgU4YSBDkohMDf7ku9L3wio+eL6rjbhDX6Y3x2ipBy3tMJJihSdTBFqCV0qlohvpXrzgyRRP4pwhsciY0hWutgaxMi3RTmdRZUB+p+O4tHMiHMigWbFj91ASEOj0v2iqm3Q2lA2ZQ0Qu/dVJJhYkwchtI6Scbph/m24H5rj68T82YbKF+uzKBiEvLgyxpolwmUk4MHtVfhQFyjhBrVFouTU83GhGQvP3o86wJVXPoSqRlbIvVcX2JeghM3AgKSVV04NWU1jnvOmNVH1cqdsTM3losUUlkBXxGeHUGz+tF4Yp5bgFJqTI/DnBgE9nbPOMZdiyz/JF13PuyUjTXyVrz0R8ps8GaCmj2f620N1wep2CwkKAHD79goMZRRTRIfMhBprQZFYvojtwcgcoHxeV28xUT7Ep3ceA4jUuKhs1DNNpJrDtWlO/MDlegTiV9KSVXpv/yYfuJgqNP0BBUpwV1CvjnyHLO6B4iqch190GkFyZiYnJ/e4Xops3BepSyxuclVjFZDc3mkbpVokHu2t0J4fqms2NItXyAFBLYeffPZWJ2Mk9P6FArjxm8983ZxCXt7f1qe5r/k2Y6+FFDh1e4lceTYJKV8M1/yeWCRvNEMIrRuo1Ga0KPSX7ic5xPv7U3a1Ajbg4YvsCNZlAUaqG8IWQheHyFhQzWIYLpxiLHbqU0aqf21b+0SyMm5zrn2eIwWNXR1qGRCdq51lKQaXw0CEXD+eHTKVMIYQa61NZANbM4LLuh/D3Ux0HYIq9DqBPaANluUH+cFm2AumXucBZ+McP3FRbUJFw8kXi/DygF67qjJ1eoUSQBInLe3UegSf7GHIyOLHD9gtDsI2aWwYMVwf95nHOOYbE7gYQ
 9XDlamHl
 7949qp9ySlbzsYFjxE0KIbkJKmoj4ii785kg7E2JhiLpVCldZNxHSjV6JndRZXXZ2x08XdkfSNp1Nb7XfoXnrFv7OHEt095HyIcaXXIkyniHkPRcvUo28qlT0Iu8dCKCfmfBTta1x1iHquB29bstHz1+8wA49ugqUrmNOy61RmHwihW5WrVYHn+zPGbdbQMJr2htgklqak9ILz3FV8acibXb0Su0c3+r6Nva6K0acOZbAnouJKhp66PK2iI2N12DM15fEWCG1Q+pAd34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

mm_slot.h is mainly used by THP and KSM.

Patch 1 introduces mm_slot_remove() to abstract the common
hash_del() + list_del() sequence used in both khugepaged and KSM.

Patch 2 cleans up the macro parameter names in mm_slot_lookup() and
mm_slot_insert() by removing the leading underscores, and adds a
comment explaining why they cannot be converted to static inline
functions (they rely on sizeof() on the actual array argument).

xu xin (2):
  mm/mm_slot.h: add a helper function mm_slot_remove
  mm/mm_slot.h: clean up macro parameter names in mm_slot_lookup() and
    mm_slot_insert()

 mm/khugepaged.c |  6 ++----
 mm/ksm.c        |  9 +++------
 mm/mm_slot.h    | 22 ++++++++++++++++------
 3 files changed, 21 insertions(+), 16 deletions(-)

-- 
2.25.1

