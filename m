Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206D5C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191D76B013F; Thu, 23 Jul 2026 04:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC8B6B0141; Thu, 23 Jul 2026 04:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E888B6B0142; Thu, 23 Jul 2026 04:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B35636B013F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:18:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 386BB803FC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:47 +0000 (UTC)
X-FDA: 85019340294.27.2F200F0
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BBF610000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZXWUAVTM;
	spf=pass (imf05.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e6BVBwF2oSnNk0Jyon9PloP7eEkl7Bfr8eX/NbegyP0=;
	b=6mspR/aicqRW5pFWtROMg8Veuttq3JvKOerDKJsdbCr7mxaCafFxro/U2sne5xgl4RR+po
	U9fogVeUGIs+QdgDiFzcHKzMOgHHwYBcEVtIohinw2p7WrZsI6PiVYrL5jfr7qVBxrwp3Z
	7rD6JDmIS5vnDUBrWSmetqUbCldSADo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZXWUAVTM;
	spf=pass (imf05.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794723;
	b=MA+YCjynkc0UW0V/6lSknPtDTaWIMIn7RSGTcs5KISKYMnQ+VdKJ2QNb5Lo/AdxH7v1Fpr
	Mk2MW9U3t/dJvXbQw9qj13ckoLr7WSwp8sNBqBE6BmRUwLiGOWmla5B9Ql9vSaX1g0PlAr
	Nq6tkhvNAlX9KmlcfB0RawsMVvlq2D4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794718;
	bh=e6BVBwF2oSnNk0Jyon9PloP7eEkl7Bfr8eX/NbegyP0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ZXWUAVTMO1MKIqbhKCnZFme50uRJzfG+MkV6R+SL/xtfzQyLvx0gvup6oa74tfe+o
	 AWzc1M1vam8oOuz/zBUJ0jah2DAyXbrtsJE367UcFUWMrGSyDJYXDfbWx+AQxn4PLY
	 zBVNTMNOGiQLYGIR8lgAWVnN2QBIb3fKiFYZ2DXQ=
X-QQ-mid: zesmtpip2t1784794697t42615382
X-QQ-Originating-IP: NWrmr4ibVq33NqKXMPStiRl7JDz4LdgCYIBewkjnVFM=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:14 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6575503778562141203
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
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 0/4] remove dead NULL checks after GFP_NOFAIL allocations
Date: Thu, 23 Jul 2026 16:18:09 +0800
Message-Id: <20260723081813.176792-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: Obfty5iaetlmvY33cttyl0d0Yruw7Wq0PkQEeaFeTg1unldV3iEQL5jW
	eZvDe8YQ0H33ZgjObbWRzWs/fqSgUCMZUYqG9hcnRNrqLnZfEOqUuzjjd9oDIUdu2b01BNS
	SvQ3lIgfzlPrSxY1inS+uaQggt8GK2k0GAtgRguG1hj5ZvYuRwfvDjo24an73tnK5tnVe5w
	jabGxbvzfFkudDMY8ohrGhG5c5IV37paMBqtx8uumw7qauYnmbTaEa4SHJQC5d8O7uPbG5G
	eIz17dZD/+Zsd1VPP9TuKSRiqEf0cqrPPk1bKI8n+vML49zY8QAPqSSW3voz8PjPMpArrza
	ziEdvhiomdY0EMlLsvuDf0XzHwIYToADv+Bm42gmA0It2IPmu4743W71umio0FgkaT9d1Wk
	m6llZ7sx7BqQdzSZXwuZc0HaLUoGkEG8ef6e8EU1v0LD1VUgTCo5WFrqvWM98TkM+ma6FRA
	xoHK6RrVWVvmao8px8zC8C7A3DFMk0eHEWAFMZ91o+IOhYk+4nEW5AzvjCjuy1/NAP1qXqV
	cWssJbfmgw83P/CbRZ7ruF8yQqohTuQtDdrRn8oMU4k06szg0ryhvppTzlgnnXptevIsEpv
	pYSvjn1yyQEfQcvpDkfy+zgXIG4+TiB/rBxQ90XWDS0pWgun8DuPhbXupEzib1ZK0dbbknU
	MPAOIaZdEDYrfsP3vLLhIN/iNQfi47EAnXRCZPYEPuNtw9TbZetqV6xz4pyt0gKQJmx/aSE
	WLepdeZ1RnJtXDE9zIuTKBqvXnYDsU8Ew+hFJy6CKulA4Bt7xWlXnzHY4PUQe0sAFW87qsr
	azb7bP6vbOCpYUv79bXX8I1FAM0xjoJxXyFdc3nHOPSucWnCHCGXvEFKHaU9a0M7lxs0QxC
	TNlvEF5hYDPt8dDnHkBVezlQ5CKTpTAS1tDpHHCDbIFh55rVeehdr6PZjRdNUI12nXmLxMJ
	D+SgZ43v6/1C7D3LDkfcx+IQTXesFAwpj/5+f/KWMbIi3APaoFQrtLz35CjLeimc13v1Gb8
	J8bpyMcC1DvxXn03XM
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3BBF610000A
X-Stat-Signature: 1e9yed59txpbxio4sn36s1fgegdfnzdd
X-HE-Tag: 1784794721-579923
X-HE-Meta: U2FsdGVkX18mMrkEsxr/s5xkN+jet5NoO37HYj2dY9ZJUN+R34iezkYIFfSKhqLScgNtrqXCcY4BrDutV89wbMM5H4DVhSpfU1geVXIgbfhBPwoSd+i2WXhyN5GYTLpi0w1UX/I1VPnuksRuxeE+f4ZEo0rL8U7A8JywhKubIp9XfZ22i5NafA/pWYJfHb3pLMEZn11jVdktkLfXqa+uOS19pwTlXgVPWaaa2eDwL0HVBQ3Kr/i/F+eBuGHeWVPEm8LDEPfvM1Wy7Zn153Fijnim030tXuC+cqQYC8wzH/uv2vubxB5ODFwZQu8FuOSw/By5iJQ0JUy6KBaBLrcYto71/Y5KFF2DbKGxocRSmiAPTpilxG6k6zwng8zg94gBTeHgGbrcAXKzDdkHyoFEJVP5+2JQ8nnrMACEdV1Icno8Ot4WkGV1f8g9/M5LQX3cPAiawNDaOoAMNGCSYVJpLIfkaLSCSdh6+a8RyxyTxmXlNS3xyxqPrSfxOXihhL1rt9Ol6U7OX/mk7fFB/Bgc+bjsloljf3hvheFyeNsO3RuTpG4kdtgRJHBaQc5PQwjdcsGqeiiiPqoDEzGPkB+j0kKRX37ccyXWau6JPV4Q8kYzGvxwdkkK4IHlLP3YoJS9xgkwrZQcXZyudwycb79iE8ev7NLrd2iZXkO1qYeTtMyNBg5HrtbAyh4Qq73nOM/XKfdilESSS46k+WZ6+mJ5JZCxRTVMxOVC5RGZzovD+ltp0WNQin0QCxJmgBkRqcI67iNOrm+4wd4cCAqUPnFKVJRaJYqDCzlvyHvwBkduqKTuVjsuVwIa3MkApfxcd2z9D4aIVzyZWEfhuc5ZufMo5c9tPuXTjzSg7XFkpnpLyPdSC3Tk9wQyKxGuPuVKO233g0AcBLOdJqj1jMTUcYBZg4vC7P19+SHjcE7w/jMnIoNiGiIZjCZlIrBVLKwdIgGRyE4ve437hZI5xvAJqLa
 U1XQTt38
 7aBinSQ7QUPKqwttxVtVXBGmtIan+oooVycY1TIp1I7uP1CFYw9ap00kDkYrMmzJHzHoyVSNDedzfEdjgBBTXcu9Y6oeCSLh+4DxRvL1D9qii7a0lFU0qXgcldnIuFZ0E/uFuEyAjaoihEEh+3e/ehwJIvz2KnWG9Acb45I3lRDtGpWV0Fj4ySjkFzuVu/fHjUL2HJITWxb0ihNleFCALlsbM7uKnN6i+h/3WNt76RNTPVj+CxW8is9RhlqHg/EquIhkgOeaarW3zSHb9pIYA4JvE2RNw06b6auKzS2e3tlGxa54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a code cleanup series that removes unreachable
NULL checks (and associated error handling) that follow allocations
using __GFP_NOFAIL, which guarantees non-NULL return.

Gou Hao (4):
  powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
  drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
  lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
  RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

 arch/powerpc/sysdev/xive/common.c  |  3 ---
 drivers/gpu/drm/drm_modeset_lock.c |  4 ----
 drivers/infiniband/hw/cxgb4/mem.c  | 10 ++--------
 lib/test_hmm.c                     |  6 ------
 4 files changed, 2 insertions(+), 21 deletions(-)

-- 
2.20.1


