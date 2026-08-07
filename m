Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8ED7C5AC82
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8921E6B0088; Fri,  7 Aug 2026 03:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A276B008A; Fri,  7 Aug 2026 03:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A416B0092; Fri,  7 Aug 2026 03:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA4A6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:51:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D07C3160350
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:51:47 +0000 (UTC)
X-FDA: 85073704254.13.6AC3E70
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59D7EA0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:51:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=FQmjc4mZn8DxVr4olKejZyOdPMT6DHDKgcn+RDpz+no=;
	b=rnTMGtlJprkftaB9egIf2duuO5W3Aa9TZLsfwQuUCiSfwSrT1djOkoFB90HrA2kdITa/8b
	uL/wje2yx044ZSilgtP8TZGA14KToAif9Myn1WLa+vsYkBlMDwZoDlgCM24UqX6hjMHM59
	W3kozVqw42TuPiy253OTC/6G1v4oedo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089105;
	b=1KsS/h920ng639Co0EsXFeBzFyI4pyd1Ma8AxjVmaGcVBh4f1YRQ4fNNRi+4gvbOzLAKst
	LAX4kDRiA7ZLgwdHbPiI6K8dwXP8O5pP+ydi0pKBPnrveBV9Z75fmLweDKnqzI1YwJhNxE
	sAyRFOYXYJRtuYlb3DI2eTROm1kf77U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: ce382268923411f1aa26b74ffac11d73-20260807
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d1a9f10e-3d3f-40c9-b503-d6182cb40323,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:d1a9f10e-3d3f-40c9-b503-d6182cb40323,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:a20aa3c33e80b4ac4e448a4e0596ec27,BulkI
	D:260807155136P7XMI6FN,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ce382268923411f1aa26b74ffac11d73-20260807
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.104.44.99)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1176066525; Fri, 07 Aug 2026 15:51:32 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v1 0/2] Optimize the code in kexec_handover.c
Date: Fri,  7 Aug 2026 15:51:26 +0800
Message-Id: <20260807075128.542806-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 4bwr15s6injbsojkdn87epb1roqjjd36
X-Rspamd-Queue-Id: 59D7EA0003
X-HE-Tag: 1786089103-718137
X-HE-Meta: U2FsdGVkX1/rN6tIJYKlug9+voatOtm8Fh6gf0IU/3/11hPve/utQQfJxyaXsRDnNrUmNdVb8meKhEic3q9dQ+9tgQ4ukLxppbmtRcqkitG6wm6Bsy5tcgLbAlmEn4eOGawddW6RX6UGe3leI4f3OzEdUL7/r4DqUEwOcN4ORSw2/F+aNLFBVOxH+PtQ9tjLtQW1Vn4LdtgvdeADlzlwMT29H6QhHymKhKKzywCd9sfmf3AFza+qOSXl96OcTAGBntCVhzhWHaeK+ozjLgCLlYzxfYhTOujzowcWC72DOOBDOTTzsdm+TT42rF+S4irBN47UTrgk+WMAz8CDkIspTQvMHoP6Bf2fUgpUsBJSDU6kYtBch/GUiQTlUqOdlfvn74KQStJSS4LRmkroee1e3McvoSsAb0JLFEHr7sjgHt0cLCHB+4zev+UdBy6kdt65V0E8us4c4CrKcL8OnYvhr5dOJLPYAt96satxSf8tCFcAUjwOT/yGmteQHi+oOQQLdKy6SzkZHScBTZt9rHyiIfdae+oU/svNu7eix2kOEXzZVY/CMEi1IlnBX6Zh9Kk4TsP3p1Q5MqQGsqdwuzWfGLDo2ahI36/f15Ioie6aYJS6gVacYkbtFVbuFQRl1y7p8ikWshAN1JPRaSSKbhNyYCF2VyxBNWIlAUbqLnpsTkiOIPq9HHysQ4Ui0XwQXg6eBJ3g0t+lUQRrFk35KCb2t0oc0EZrjI6h74u0mqv1I3bQrQwMZdX8+Ih/KACCOEd+POO5S7qWEMDmnYSZjSyBfaBhDkSQ+HK2Gb8tHguhAuyHy6Zc/VfuiMlqKrOJA3oYXwFLUDGRw3ryKJ4Muzc4rm/bK3LhF+8nKsrgjahXqE6Qtf3YmWrf/OYRmoPweYjnWTvvHHU4IwRU6P7A/xr/mxEWOZL7rGz+pWFOKyCITSrxQeiuNGL6euANkuOhVY2QocKGygSLZEiHDOq3BQc
 xzov4GX1
 xea5HOqpebphiZqdO+6EgNJdmsd39kI7fYVr/B97dmJJrG6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1: No functional changes, remove redundant code.
Patch 2: Rework error unwind logic for kho_restore_vmalloc().

Chenghao Duan (2):
  kho: remove useless phys increment in inner loop
  kho: unwind restored pages on kho_restore_vmalloc error

 kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

-- 
2.25.1


