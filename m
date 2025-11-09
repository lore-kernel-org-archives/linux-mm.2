Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4847DCCFA18
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 00:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF858E000C; Sat,  8 Nov 2025 19:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970B08E0003; Sat,  8 Nov 2025 19:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADB58E000C; Sat,  8 Nov 2025 19:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0CB8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 19:42:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0D2C16085D
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 00:42:22 +0000 (UTC)
X-FDA: 84089217324.04.DCF5FD9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id B6EA41A0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 00:42:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Rx5Gf1LF;
	spf=pass (imf19.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762648940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFNsIex1fh6kZSaHLL9twDxgk4m3gMntkS9npVxY98Y=;
	b=K3HW89RWWfOWzssuJEUc4KnHETK7fewqFb5JMHL7omRlgMQeTFtyfKXDIByLvbnwD4fiGK
	8He0mo/h2XjqKfPDJpC5a3549IdDN3UGmvEVObnEBOZ2AfDWmDGKs5W0hD4f822KUNEh2V
	Jup0FJQEkBdI61MwtKXDZsF32+Jv41U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762648940; a=rsa-sha256;
	cv=none;
	b=igIc6gaPhu7S0KubaHay5PhdgC1qdBBJ6L9OrKp+VJ9mZ2ASCNDSUIQYeymeudVSxgk3fd
	LMGVx6yE2ZmOsIJZE03HxpSQbgSfpYZtr207q/qQL/rhn9QDMsz6+nWU0qHodaSOkpBFyj
	Ftl/DDpFvS7C6i4F8jwFB4NZhx4+k4A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Rx5Gf1LF;
	spf=pass (imf19.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8LQFXl026160;
	Sun, 9 Nov 2025 00:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HFNsIex1fh6kZSaHL
	L9twDxgk4m3gMntkS9npVxY98Y=; b=Rx5Gf1LFqD5kBh6sFDpa3fmaPrNNEPTtc
	TlGlwvdMRE51/J0/1Yp+oG6zDTvVQYFonFjzWFMf+H+5KmzbSat76GngADRbPhXL
	LpjtuWDJsgvzQht8f0SMcPWZnv//ORD6L8/OPpTPHMmBl/nAErCo7Vkchq4OP4wg
	5HFkEvKj7Q9HAcBWDNyazHwRz5lmSrLbVOvue/ioV9r1nW3THkqtlExFW8jI52tH
	2i/ZUjTe55uaEu4VlSpCsb0VaTE5cIkM+/ABUSzfMcvbq2XMp2OUAtidqrtxJd88
	O75qx3wH/OhBvnx95raMoO+oGc5/QmLXgDPOAzJfQ+dz0Xyzllt0g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5chsqwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 00:42:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A90PvqO021463;
	Sun, 9 Nov 2025 00:42:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrk8rak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 00:42:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A90gCfG43516394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 9 Nov 2025 00:42:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61F8E20043;
	Sun,  9 Nov 2025 00:42:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 377B820040;
	Sun,  9 Nov 2025 00:42:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  9 Nov 2025 00:42:12 +0000 (GMT)
From: Jan Polensky <japo@linux.ibm.com>
To: japo@linux.ibm.com
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, david@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        will@kernel.org
Subject: [PATCH] Clarification: please ignore earlier submission
Date: Sun,  9 Nov 2025 01:42:06 +0100
Message-ID: <20251109004206.2512906-1-japo@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251108191948.684586-1-japo@linux.ibm.com>
References: <20251108191948.684586-1-japo@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=690fe367 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=lbAZmC-vrXcGRvqt0UMA:9 a=UzISIztuOb4A:10 a=Qzt0FRFQUfIA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX+dU+fNcX3JOy
 FlOcXdOf3X+m7jaMaQ+6JErw5I9SoecVoJqcBfrN5d+gHNQuyoF9V0z/oxHTq/1ui+SLBbfNsyq
 dE6duGmDs5/OhoFMnXUcejbba7++1wZPOUlVBHqHEvd3UT641A1bXJ3mdA3m0iOnrp5WIANakql
 48hdMqSN7wgd8VWasuGukxwluFOYRmvxcKRALlwRXfoMEunVEAFOo9Ik7+Cmr+W/BViUarBspLj
 dQmSgw1yVu1o0Ra/zK7gKfX5W54y7bbeyuT2RAwqlA0zUhkMIKmhpr9sCfFaloeadwehc9eJ5wP
 GXY8sp+WCe5UMF1JKEQY++r5yLrLobrsfPfrgm8FGd6R56oePehMm0I88Uj/WA9Hx2WeZc7SFpg
 cwDdcsZMIQh7rbryuImM5UJpYi2l5g==
X-Proofpoint-GUID: 7xameQgooeoHv2wocrW2MeVNFc86s5eu
X-Proofpoint-ORIG-GUID: 7xameQgooeoHv2wocrW2MeVNFc86s5eu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_07,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B6EA41A0003
X-Stat-Signature: 3aq6zcyqqa5n69rrgu3ntq7uszotm6g9
X-HE-Tag: 1762648940-114019
X-HE-Meta: U2FsdGVkX1+jvCVHVJOdN5uAARqPrJVQkGs4UDQrQbSVxVQSw2ac0kYi81k0lmcuFNJKOfA8m/agWWDKAqHX4zlZ7rgaeYjod05Pe8Kfc8uWBedm25ahI3cik2FxgnQn/zwX8DgHqehzxo5OTnxKAnZkbhVRZkFtLmFDoa/aaWDTBHZZSynryoprnhmBo2FnMwFavp1po5fgF/OLhmkdAP7EmBMV6xjSme6IxGvLF7omLZToTkkyCdNP+F+3bSFEOMfjielhaME+8ttwm3BbO/dxIIQw4141l9lqIXjwZFVMCLPOovWrXA87D5Wvx20wel9XUGwbQl7RIm3PcnRtdnbzY2yRnWpVe1QcUr4U6dy+n83kfjhsepua9pwAUHRpTewljKhBdJ623o4mUnu4EaZsvPMENgcd4aA/AvKau3S/170bv6Nex9/OCDo+OOyeGzuerUsgaUJHjTg+HhbShJ0HW4HpLy+V4bl0lpaGn+yKbWdWwG5kmHh/myKBOWOk7dWENDFudWkZrbpQQV2uzP9ZJjtz6u2AoCuQ+MOiVK1QkYJU7xa8q1bsWbTdev/U3lWPX9PC0lXiZ2jn4CX+c8AfiFbX4K1yhIVv2sRthstZS3QUo3xpj2dIs8uI58vQtR+Oa+Es66T0vuBZbeesMWHZtkn9z/d4IST8B04O3Z+XyLVLiMAybtf+z7kBoC6MFGB2v+J5gX5li/Z7nEVq9DoG//I/PGyxlffXpAmaCp2Q6ub6mUR5kY5aSuK37Vdoci6EGlOgv71SUjEDFzyu9XFmCcN0LYCm+9YfHrzqDxBEhMbjL/uE2luJ78DIepmjAwzgkVx7MFrjfMEboI5IAjflOHiomc6YMSiyze0T5yokKtLnttf8M1CxWo3L8+Uelq/2tzNBxEvjNyKAvfJEkfM/0jO8adnPMLnvDfzz9Oyh7Ag14zxtrhTA9fBDrixFeFD6vauhrBs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Apologies for the confusion, the patch titled
"[PATCH] mm/huge_memory: initialise the tags of the huge zero folio"
was accidentally sent.

The correct version is:
https://lore.kernel.org/all/20251109003613.1461433-1-japo@linux.ibm.com/

Thanks,
Jan

