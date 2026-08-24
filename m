Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A78C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D352A6B008C; Mon, 24 Aug 2026 05:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5DB6B0096; Mon, 24 Aug 2026 05:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3CE6B0099; Mon, 24 Aug 2026 05:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 976396B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:56:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A7551604BD
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:56:48 +0000 (UTC)
X-FDA: 85135708896.21.334F445
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf31.hostedemail.com (Postfix) with ESMTP id CD0D220002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:56:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=P3bC2Jg5;
	spf=pass (imf31.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787565405;
	b=Izs/zjkBc+pLVbnqkAekQHyVLT6gYuj4DpuHfUS3vTqPlRuZUgt1rs0QlyyNpCXApO5ztz
	gXzmmrN4EFsPfgWjByv+r5Zn5w0CLoRoJAuUBzq5facuuGHkG3LnB05GpRPYXOXw+iDndT
	a8HvMei5BQ4YLyQWH/m6QQvFMxmCoCc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=P3bC2Jg5;
	spf=pass (imf31.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787565405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryDdecWHKehuhgCSNE2lDrm72aioKPfPGMsHHjJRGOc=;
	b=I4m2WE6nihG8TKIqUOXPexCNDJ9a3Zsq6NQVdnAPTGTwB5m7807nZQztVyZc070hjJwWrI
	88DZiu+LSvIfJtmBNx7CaGwxRpaPab11xX1Bs8xZyt7YcpXFBb4UWQz0BN9kbD/jvZBVzl
	+sOksRHsqeqHyi17kVFUF0eDMHTh+6M=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O9VlQq1487533;
	Mon, 24 Aug 2026 09:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ryDdecWHKehuhgCSNE2lDrm72aioKP
	fPGMsHHjJRGOc=; b=P3bC2Jg5V7p3T5FzK4oIUr1NphnH8O0ifYPtAHWqxsza0R
	lpoP6PDxx043GDV6VrXbomK4aOEcIZh58Yp7UrEXkG//1mHUw8HrsL8H0+NHjJuR
	jknkQz52+T+8jqzp00lKPWbxN20jcnBPNGUH+9hvjjhzzIDogjZRrmlPrfoW3T3A
	w6U21r4BXZgI19Cuz48p/h3PBm0OhCp6lgiSv9T839uLUw25I4ZvMkjKKAuYoNua
	7nPaBJ4CJrV8Y/+XEmtf40UAqcMSvnwdkoO0OQIDrDAH1+Cd+d9lmJZegIDOS88O
	NofcIZVR4CVe3XapjLppsedqmoQ0xrLQym3hs2mw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g4gem2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 09:56:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67O9fJ7p015669;
	Mon, 24 Aug 2026 09:56:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7pfvw8qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 09:56:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67O9ubkM51904778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Aug 2026 09:56:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C82D2004B;
	Mon, 24 Aug 2026 09:56:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0600F20043;
	Mon, 24 Aug 2026 09:56:37 +0000 (GMT)
Received: from osiris (unknown [9.111.89.201])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 24 Aug 2026 09:56:36 +0000 (GMT)
Date: Mon, 24 Aug 2026 11:56:35 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 3/4] mm/kasan: Introduce helpers for lazy MMU mode
 sanitizer
Message-ID: <20260824095635.11040Be5-hca@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev@linux.ibm.com>
 <CA+fCnZfMkPDVyy0t9W-3d55M2ba9wXoRyzj2EWWYLEW=QO3zWg@mail.gmail.com>
 <20260818120130.1411942A70-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818120130.1411942A70-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 1JgbhTBR0ba6zQHMYebi5vr-RzRcFwky
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA4MyBTYWx0ZWRfXwc212wIRAupV
 PVbJL3dltTgZMqcmb/tXogBsfJ2gxLKRLqp05p33LrmcU7RhmaNyO5Brw+8PwrCduU4dkxY9rrx
 GoJGrzEAQmjZRyw4nhgpzmyX0uevnXg=
X-Proofpoint-GUID: ijQB2z1bnbd_HwBTe79wNdiH4RW0g4ZS
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8c155b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=ZjT8TfMUO59fnRzz4l0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA4MyBTYWx0ZWRfX3dM4LBptTZcr
 xjmPKJIC0Nl93s0MpPNNiGDKxsECC6g6vzQ3z4l7Mq80Zl6TLiMhj6WhCXmkSSVomMIl3O1kaiM
 gy9j3XYywqIoujNd0kirBgpIPGkNs6RDBR6g4211GUaT9sVXkDaQfN2uevo2WyUOM0Fpp2YhLA1
 Ci0BzMDSiDsCORBN/64EWeVm1UKe5p2CaXsW/3qDQsWdlDkoMDqg1g822RDTsTeew5rB8zk8st8
 FbK81r1PpA7CYFyIW4kbs4XbhE8WxhdV1JQwvO1BhTz6vNcktOLsiHWTaGDLaZyo69t7OHAA4Ep
 uxkbrw9fIbz+Tl7su4Nh9fCsJIUi/vFSTYOJS4GI298eN5WXlU0/pHaok74YO2CICOwaaLUFFem
 vI6gQ8Pom/JMVourmkAhfNQ6XYc/ZI82MMf7O9VB/+yP/pP92G6ooBdH7GXFEcF2CvqqvrL4ObO
 /qRESkWr7EnhUO5Kcjg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_03,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240083
X-Rspamd-Queue-Id: CD0D220002
X-Rspam-User: 
X-Stat-Signature: whrjp49znwd9gt6tfabx8uq7uwwjssrh
X-Rspamd-Server: rspam06
X-HE-Tag: 1787565405-977475
X-HE-Meta: U2FsdGVkX1/M9z6HlRpn8Ud7YXTnzFT7Nba1kmSP08eemG3RSHum6aYuJBmEUwRMUuT42yzsqrQU9RC+rJ1GNY17WgTFCIQrCsNuKFL7/m4EJIG+c+m2+smSwi1x45Txd+0Am0jLGXcHC8EIkIshbgPjGjOZsiGKGADtyjUpknlzoNMU3A7jdr74ZOwX9Mq3L09LSHaEtSr6oMpCnX7Kyhp+VvPKcLxjERLJ7JVGrc5e6ozJ6k+RP/suNjrl67wuiDf93W9DecTUEX+NHp8kJa64v50DTatkz6/BIxRk9bDqgaS5WWuiOz53S57HjPLCI7qtmt6NQphLUxRLnVT3u7k4WPwInE1ipdi3YUELNIOmFv/2si40Q5eq1xQs7rwKnQTG8tDkmyKwNzvOywISBChHFIs0utCpKlrpHpQAa2qmgIQrpE4ITlxX64KZXhCdl8cgYHk2ij8LVq+8nBBLvYRsQ81YywmH+qyRiVknx533yhWE/00kMOLGYF60PCw27aU+Wt2k/fdwCHvlVx7IAl3fdnzzAw3FHRw4YwQyQlVRacB/QlPbdAh/JkF3RRxxriD2r1InJJA2eGMsHQPi/Hr+Dqwmy+NmCeTRnjxT1qlpoArMJDwwDiM91dZnx11SGacxSwZ3t+OTgs3CeAI/F2OScloApeJMu09TK4EqbZGr+q66x3F62oY2S6ZUBCSaSjITMRLivPjgymgy+um9/FaXT75oKegUHHUpHf4Q+6cFz2e6VZUPLbCpmLsfjXunGc5I99yuCwSGIsTUs7e/7oUCL10M16w/BAd4VT+XtWTdigiYgqeCmdGJ19R9WWOpqBXXGhtqrp9GXc5RUz5RKGqGlKWsqmDPijkaNHmnXeSVfqIJQOhsm/muWGGZMWUSaFL1Bo4kQnG1Qi2QMNz0/Ls3zIKCrRXvZOmkQ5pcxDGOMB4VDJcKBVEFcmf7uHWsO7GxZs3F4WS22iBNEVN
 aQaQEHRE
 B4OguLuCSZdnu+x//5C6sacPC3SA3XvQgSXkxQ/4wAsTmuzfkwoLUwTjPXpdBlVaBNyxTBscEpGS4iARfNWXLK22AmMhMrLs/LrXYDAbDw6tVGwgDmMzcDTKjbgQnOwmNEWj80xwt3g2roK/y6ux5hfqwE9UIUcQJg4IWp1vUwzugFj6xlrk+Jz7idOGrOnvUi6wVUnafRjEbZSLvfi6oZYPM7qj34f8y/UaMfU0DgXBE07zl9uiTKJR2dP8HPH5ulThC3c8zBASNA/58h9WkgyQuuFrUUqU/AY6UNUteFV8d0Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 02:01:30PM +0200, Alexander Gordeev wrote:
> On Tue, Aug 18, 2026 at 12:11:34AM +0200, Andrey Konovalov wrote:
> ...
> > Hi Alexander,
> > 
> > Should all this be limited to only s390?
> 
> The idea is to allow any architecture to opt-in. Once [1] is accepted
> this may look redundant, but I still see the benefit in having it.

What would be the benefit if [1] is accepted?

