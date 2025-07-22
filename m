Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5FFC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783458E0003; Tue, 22 Jul 2025 07:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733D98E0001; Tue, 22 Jul 2025 07:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6233A8E0003; Tue, 22 Jul 2025 07:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3DB8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:59:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B8F3111DFE
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:59:13 +0000 (UTC)
X-FDA: 83691754986.02.066AA10
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6CF78A0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:59:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qcXUYXMn;
	spf=pass (imf25.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753185550; a=rsa-sha256;
	cv=none;
	b=fDJWpMhisV/nMpGpj/TJ/oriYosjYtLEoGWtjUfjOxxZNoyvJqODb1gYM6AdJwQ1MWJSXE
	q+sa642/WsXN2/tma1eeNUYmN9pNCqQ7TdzgN7UmX8MAYu7I7DfM0h9AbUAuX63Z7UGpNG
	2WtHh+K3JELpeBJDyU8F1HttezUMgd8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qcXUYXMn;
	spf=pass (imf25.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753185550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07sal+LSUKC53pofptuH5OfIwrIxqEu7QpiNeAF+TpI=;
	b=GzwWA4n5NLQ97twreoz2V8+iL/YCCt5o1QYkxT5zBxmEXitB3Rp82L2wCj8eCKqzPhCTyC
	ULHXaKFI4WP5lhQjA4VGyrd+N3TvEIkbMbzLopzzY4d2aOUj1HfTCuqXdeW8upGiSiawiF
	1+qqPrV3wabbE4tiEmmk1QIsmUZLr9s=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M9XabX004841
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=07sal+
	LSUKC53pofptuH5OfIwrIxqEu7QpiNeAF+TpI=; b=qcXUYXMneqguDNIB3rddLm
	55Ib2kmGQfpp4i6b9c7d9ShJyC+S6RA2i1MhS7r16X9xhi/y1jMyBHfoi9MqtkPA
	3PcARI2PtM+e59oMssfJ9TS2kWkcLH+Hzd64KyyylJZlwJsVTtOqdjeUdxqyMXHu
	VzDW97EWbRrj6ARVewxxxY2JdlkM6Fif2ZOQZM0YdSAndJkJMXNdrCtNKtgnxFb5
	7DBulfxzZ+va1V6Bm6C57VgOVbLfd/mrXIwGSaPQDjPRFr84Dn7urrCMS+jzrcTg
	xk89ZQW4w9x86CNjGAtGGSNotaOfYCK5HGQ3nEQ/TpuKjsJjRcKAWprs9d1P6Y+g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 481v6x3f40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:59:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56M82iIp024704
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:59:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 480rd2ad7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:59:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56MBx4uC20250882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 11:59:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29F4820049;
	Tue, 22 Jul 2025 11:59:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09A2920040;
	Tue, 22 Jul 2025 11:59:04 +0000 (GMT)
Received: from li-276bd24c-2dcc-11b2-a85c-945b6f05615c.boeblingen.de.ibm.com (unknown [9.155.201.149])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Jul 2025 11:59:03 +0000 (GMT)
From: Jan Polensky <japo@linux.ibm.com>
To: japo@linux.ibm.com
Cc: linux-mm@kvack.org
Subject: [REGRESSION] mremap() returns EFAULT instead of EPERM in LTP mseal01
Date: Tue, 22 Jul 2025 13:58:45 +0200
Message-ID: <20250722115856.47821-1-japo@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aHjjhXSAyFN_bkuY@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
References: <aHjjhXSAyFN_bkuY@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1UA-t_iu79ZJEVVVdJx9HnImeQxmm2uH
X-Proofpoint-GUID: 1UA-t_iu79ZJEVVVdJx9HnImeQxmm2uH
X-Authority-Analysis: v=2.4 cv=MK1gmNZl c=1 sm=1 tr=0 ts=687f7d0d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=5tHPDUVrD0ePMM0Tgt0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=RUiq-r-Y-5EA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA5NSBTYWx0ZWRfX3u5ZkH/L4Jce
 tcaP12aDUiNoGE0E2uedLOb9laAK48SwxKbc2c205bDQ5ASzuu6hziFlF8OMjHMj4kp6cd6uBdf
 D7896g+xlCMpUe0uqtYsbApzpxceThRZiVs0Shskz+sZiPeJEejR0tCDG6hI4DaOTrjVro3sY/W
 3jue7bQmwvlMjyzrMPt/ZQYKoX0X6/dEL4iAzGDWSjla9tjpVqsTMvFvTqXeAu0Ga3TzTVXGqSu
 On9ANIzC15jNtLMoI2Tom5I2/HRuixNM76G4ftTzA7GjQnU6skVN93DBishfu9FUH2cbkSjbHLS
 LZzc4J6eboDbZEIJJwfYgTqXLjpFmRLJDGPMosCQDCoj07wqvO5K3Lhix+gwl+Ym785s+xpd9cL
 1AQGAv5XBolQqxqPSGUXYRvRQqswMBz4qKdHuyabetMfsnp+QUxoEnDvxnfPdqpQZzXJ+nOQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1
 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 mlxscore=1 suspectscore=0 phishscore=0 impostorscore=0
 spamscore=1 mlxlogscore=184 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220095
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CF78A0006
X-Stat-Signature: xw7f3ukfnui5du9qnjgjyorhjow1dzc1
X-HE-Tag: 1753185550-96524
X-HE-Meta: U2FsdGVkX1+eJzMZl7w2Ka3uloEbxG4ERNDZkb6jCntT810l11829KzolsQxKRowQChPqp/7PcdHHmAe7Hn/avCg6pL7fFrki+u4DEXA9hrpAQW1OZ8Sbnj5Pmq07OH5jCvo70MqGjsri20i0TOgqqkevst5ocJUjfN1vymzDaI+2Xsw078MlwwbeDkgP5ElnkzgnD6++X4WPZITjrV8e3Buil0toV1/EJSzjeGsceGqLZcjiYGq99tZt9LDnw4i6l9lYN23MWnBWHNzgoQUf/tVAe9rg+GvA4c17Yaxjdai5z8fdtjOYW+yc07Cw5LfEPW2+uz936QctIxPZF+uXpqXKGsZK1xLMoHBu6BCI+zdJ9oxe0sV6xJls1LmhX5tTOKAptlGAjwWcDgaFajRLyBAamCWKAoQje2cci1sBjJUTIKkQydtN0/1x/hRjEIEo3i0pCoMx01aO61kmrV3jcTV9TBaceQBRWbcwdQaP+u7dskgDCog6xQSzxa+veHTgvah4IaBf8JyE5QpSLYte+6z9XyvJ11LHXLUySgn3SM/dddziP0H0O9mTSw9K1Z6dwQN7LLTERhZ0Dyq/KRV0G+xXNP9PyB6t3VyAi+Qyp8OYkwLApxtps4GNO2NszhYiNC5E+rGYmTLShvaFVgSOloVvYTbsCKNv+WxH8Es0tKik0N+Ym++bOQ6rv7Qq+LtTbK4Ie1UrhlvOi2VtWml41wecjfd5bRMgTYv93rmw8HOmyA0C1DWMCtshhiy5dsXQHZQpeQ20Rq1BnABZK6ZGiT3Z7P2cUJw9EvLg1g5JeNR2NZNrxDkkX+pt6ncqEltcMpYslBooYA8cIM3X68LkxCmf9vIgXVNGgwEZ5pPPp139qyKwxrigABvCWb2bun4WglzmpdBZQTkX9actvWRAQkmlCFryVDsQcqh/JyZc0bQIy8ch8p1n+LwMWSG2um07JIbdRJYZiByipGICPG
 iW9pV12M
 Vkdq3tVlScCqgfQXFLQ4XXWvwVn8n0hZQ3J/lH0L8wboh5bjj+4ZCyCLTxV05D96TOIf8dWnA/MxpeYcBaY5ZiY2CtHYrTYX6aDj+Kzv2wG/SfK3Cknx2wcd6m5MMNQomiql5u/q3GtNMSQpgAQcghMeZfuolEKwy6QmIq0UzhuXOK0sRYYFmn8pcatr8umEtWBA8us2ljJ2Vl3BMYBI93oEfpZghN5bucNH9oChJ8zq++j+3KO0BaQ7IyDI9i96noeI7pawgBSUiPOe4IRyZzwu4ezuLVoRiVxMzzgPjEkGUshgir2TwiFWR1lmLl/JkuAgWPPXYeRfEt+E+S+zjzXOB4wqj67o1fGIuimNgOyvX8mkykOXaphDBMLikvhHHTDdKCFMrOKb8X75HCeBHc8WUZPT5Y/o4+3t9wfZIEjmLElY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Message:
It seems this issue has already been analyzed and addressed independently in the following thread:
https://lore.kernel.org/oe-lkp/202507201002.69144b74-lkp@intel.com/
To avoid duplication, I’ll defer to that discussion. Thanks to everyone involved!

