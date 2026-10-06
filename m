Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F050CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 00:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC2F6B0088; Tue,  6 Oct 2026 20:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D7F6B008C; Tue,  6 Oct 2026 20:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2CB6B0092; Tue,  6 Oct 2026 20:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC6756B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 20:08:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65B7A1203B4
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 00:08:02 +0000 (UTC)
X-FDA: 85293892404.06.2F28DB1
Received: from mx0a-00617f01.pphosted.com (mx0a-00617f01.pphosted.com [205.220.165.167])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C45840008
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 00:08:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of _us@psmicorp.com designates 205.220.165.167 as permitted sender) smtp.mailfrom=_us@psmicorp.com;
	dmarc=pass (policy=quarantine) header.from=psmicorp.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791331680;
	b=msWVJIknmaLBXx7g0Mcg6ivoQXETcejyO6S2d2cYTFVJdAXttfCbx2uU5wxgLP+3A4zkuv
	Y1KAaSBF7n8XhE0McxxJe2l5L/KrWDCIiJBtVYAyfwng6xsj6q8PT2uCnwiqopmNOjTpxo
	U5ghGqkfVdRPSpZDhwCaWuz0W7lus0E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of _us@psmicorp.com designates 205.220.165.167 as permitted sender) smtp.mailfrom=_us@psmicorp.com;
	dmarc=pass (policy=quarantine) header.from=psmicorp.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791331680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=IaKaTlHwiRgUQ9XoPB1UvEJkQqtQ6HWpAhrCRNtFyqUCtA9d2lyT1CJX5RuScmf1NRlJqe
	ES3/GGJVFcACwgJompf5WVibmgcBEtZOQHXIM3fb7CYcYQ0mWeBYJRso5eShOgqRCy9R6j
	mVkCCaTK6lEipFKEd69mjo4clik8il0=
Received: from pps.filterd (m0247527.ppops.net [127.0.0.1])
	by mx0a-00617f01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697002oH3309987
	for <linux-mm@kvack.org>; Tue, 6 Oct 2026 20:07:58 -0400
Received: from egc-exch2.psmicorp.com (webmail.psmicorp.com [38.142.134.66] (may be forged))
	by mx0a-00617f01.pphosted.com (PPS) with ESMTPS id 4h5b5e00p1-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 06 Oct 2026 20:07:57 -0400 (EDT)
Received: from EGC-EXCH2.psmicorp.com (10.1.1.111) by EGC-EXCH2.psmicorp.com
 (10.1.1.111) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.61; Tue, 6 Oct
 2026 17:55:51 -0400
Received: from psmicorp.com (10.1.1.107) by EGC-EXCH2.psmicorp.com
 (10.1.1.111) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.2507.61 via Frontend
 Transport; Tue, 6 Oct 2026 17:55:50 -0400
Reply-To: <greg@gospelmusicuniversity.com>
From: Evans Thomas <_us@psmicorp.com>
To: <linux-mm@kvack.org>
Subject: fund transfer opportunity,Reply..
Date: Tue, 6 Oct 2026 23:55:47 +0200
Message-ID: <20261006235547.A69ED8C3460BC1CE@psmicorp.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: sq_xR3SL3YJxzkg-dGvUA2I2ttGINAPZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX2nDs4tSG4V1Q
 v3UhwtZmtFCLCHh52rdYpJPAaD/j5pXhKPahe150CSqQ+40glFh3FmciRY+f1dnC9D92FXKuw2c
 UgS+jYkcb5FCNiONvDZ5cu3TEz+Cx62ZrkLoYXgq6QQIqlDogjY8rM9qPxMGl7n88DvVnn5ODi+
 fvTwdDg9AMHb3lob3RDQE8U1C1MTRQqeFmU23ICLB121x+++PI1Mfu0u9ZiSVFQSUqRMoG5CFHA
 zpJJRGTbl/qYebeXxFs7F+084OOacusoSY5e9Yf1qMpUJmERff5MtD5q4w9HZTQsL5DdUovWRFL
 Hs3uhq7xEVCR81Xyz+KA5p7nei5DDuVYUaJTN2OKlmoZGSizvoc6Dq3UWJgDfYz0lZjyxNWb2a0
 dbxOHJgqhHUpYRDgoldLKxp5yWyra4Ptg7V5QBDxSwYqj3Q4/+WFYWNoYedbXaF8hBe+rlQdDzy
 8u4l/t/DOwDZKkQgLFw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX6LErJLmGuGF1
 vx/7gFBqFQw+p1z/wVAjcERVNFnGQtv874MInH2e4tMCUIW8ceQudYIg3PvMr++5XYIfloJmRbL
 B/dQKcLJGfLvmaLnHfWDAHSSTcfyKDH5DyX7wgy0Jy5a53eSKZmh
X-Authority-Analysis: v=2.4 cv=GvTXaU1C c=1 sm=1 tr=0 ts=6ac58d5d cx=c_pps
 a=sNj4pI0fii9qGHoVqNzRVg==:117 a=sNj4pI0fii9qGHoVqNzRVg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=ZHGAjPH774soz-f4Le74:22
 a=GfZueQGhKz3ujf-POmTq:22 a=tclcd6dtLQvEqt9_mmAA:9
X-Proofpoint-ORIG-GUID: sq_xR3SL3YJxzkg-dGvUA2I2ttGINAPZ
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610070000
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C45840008
X-Stat-Signature: 4zmqddmscgjprzr6pf1zuuu6natebafy
X-HE-Tag: 1791331680-155412
X-HE-Meta: U2FsdGVkX1/QNxpxSEfGHZd7kigu9PDgB2i/lhXQA2Rv82IKD6MKI8ZsHZgiooizGyYWfILMEG+/lCjdQmQxqFd5ckRibmltGPVQ8oTEjdbB9fnj0bKYTw6+x8hPdF+CilmKnIV34/AoRAJBauJC/m/ViCLkoJJyGknycFqUrFNx8nTVpyL7ALQSoGOKsuiC8vePYsTzL8G7lcGJvYKnXbPWcWnJtZaB5zNfNxo5ioVwnR07gicDbEyLM14bH3tEbbMm91EGdGBmMRb/xNg18Sl+Arp7kjEJytVmB3UDBvNHgYiipkfRgulB2z9ESULwwTPARPfrGowhpO/mHhNN68N/wojx/9rTvyuIQGLiCxMoyygctDbraNbBDZ/50a0sqFzbZ4r1e/ni7UG3CQwDqJxbtV0JSCS69l/VQWkUAYmlJ1zm6sWkgX9imYeaYFZzPty1NjsFR/qtLUrv7g3+MQMktbMrijniUi2Pgis36Xlwh4r0SOelFxJQrDxj8oE+lbe3Q52FIpvD7jFYjJputYKgFHLxPUUJH6MINIg0QiMWk1rAO2bwEeChuFovYsrvDj83yFfEZ88jDqg2wuzyNRzM1lm+Vt/PrT65l1x7cquDd04csU4BRlJ5r+emFbC32QqdrI3x9cVEjTAqePAy8cFV2EAeGx3aH1ek9+0Oswr2UnWvfaHFqa3kH6Dyfb20FpnLQ0Hc5tm/c7WqpsxU2hXZUFIvA8ERwp95GBIZeGKQ0xy/dC5PRychTTqNj1ZvvUEN7hvsKDiZMf8ftU3EceDSdPwnF76nKXQhHC/f22F8mbiAP5sM66ncuM5PMsk539qJYmLvxU61HEuKIPJMw08P1oPEQd0+Aik02BIQNSSaBdNp7JidSivjiWTxOeJXxYg/L2ILfLEPioW4ETUmMrTEYAZ1/Y6hBajhjtV123zW8gCvz8TE0EOr1OE1/bMAvnb18uZ+bdxrltvGvM6
 vulpG93G
 If5tIyd0/fKGYkd41aQ7pbzIiVixkmRQP8+5Tuc/g4HWxhREeXY+/dx/Jl1mmPBHpfe+r778XXIETFI+0d1w1M17Z6RUiLkWB/0j78ECuD7BQQGTa2rQb3Ix7N5BSxmfCPwgXcXsnOomlbFJTBzlA8JE87OHTFvGtWw+jkKIDsPm1crNTpZAelHB0SQSyijLV4VA8qyl9jYXGnRGx1jXZie2REIIUX741p4yZwYlUE+JFgvJtqSHXI0maOpcKRGUsKblnbJJzLN3X3AbFPH9fXVjHdLYE3/Ut7JkM15pPr/mA3rfNHn73EWQyukcYrLhaze4pHOXSl8nzDl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


