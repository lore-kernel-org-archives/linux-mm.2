Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1243AC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A7D6B0088; Wed,  5 Aug 2026 02:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D286B00A9; Wed,  5 Aug 2026 02:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C5B6B00AB; Wed,  5 Aug 2026 02:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C01C76B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:36:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57970403E0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:36:30 +0000 (UTC)
X-FDA: 85066256940.07.0A56D1E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id F08FE40009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:36:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ER1RfIgT;
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBveNqSjBa4XhmmE6HkMEs9O9bq9R95ZcqaBlV8+egQ=;
	b=Se4ThTD6BLopu7UDzpTfVkm0/FCMWI5cZWbJann3stx/BWjaVEe0kGnJOJ+mrqUzbPQ08b
	yMaVIAAgfMCyYE/C/Q2SYHZTCpqqPO5E/AuHLPkoQLWjPEtxlz9EkQ/thYrf8PSH9uwQr/
	3wjYmCRjdncZwb1xeXHLwIEQiNWibWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911788;
	b=pjINhk3T+GnTO7npS7KKz0IdLMtP7bhZ4RExp5vjxS1tTvHcCEMPBxNQUdIEwQArEsXnmh
	f4b8FIi7E0YjjOyMpSlmNIvCAirBq3A4wr38Mpe3FKDdZ/3acC69aGHiH1S464pP9eTuWc
	jEz+vjP2bj/edC8RfR6XNRJTNQNvfEs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ER1RfIgT;
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mHMZ3005943;
	Wed, 5 Aug 2026 06:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=YBveNqSjBa4XhmmE6HkMEs9O9bq9R9
	5ZcqaBlV8+egQ=; b=ER1RfIgT9xlB73t9/xQqXyIrY+HqeVaYwCw83gutei0Ehr
	5efYEu+9KhkIY0xCg+E92XaZfWl8iHbH3lsIf2ahgYHDGBI0Az89Pq8mzQ4ryXue
	jzh721p3M21DeSifvxPW7CwMStfacsSplgvs0erSp2h15fCkoE9jFN25g5zV9ckh
	ubGOr74mJpKPylIwjW9ogaiTJc0cPGAvvO5glyFuay8lJdCn7OA6x1oX5AQniof7
	HhWgZ6Z2lcEv7EUcrCFRAt6hqnoGcvwc3H/yae+jOz3bjF0DY39eMVNwu0WDX/kJ
	Lci4BGxsbnzm5xvwSOYWoBysp8BzMnmY8Dl+uB8Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51p4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:36:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QHWI032076;
	Wed, 5 Aug 2026 06:36:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4k5btw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:36:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756a9f935783012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:36:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B10C2004F;
	Wed,  5 Aug 2026 06:36:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB04B20040;
	Wed,  5 Aug 2026 06:36:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Aug 2026 06:36:00 +0000 (GMT)
Date: Wed, 5 Aug 2026 12:05:57 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: Re: [RFC PATCH v3 00/11] Add buffered write-through support to iomap
 & xfs
Message-ID: <anLZzeS8mx0GaPQj@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX6J9sib43SCRS
 dqCrM/w2/y3hz6rJVe6u77B9G8EWVLotZhArYX52k/tnHIdGJrsdWA3BCuxo2Tp18Rsne9ODDYa
 GBmpGuV3R79M9xxEC77vxAosPfgyOA0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXz5val6wkxSI0
 3xwQ1UfV8fBFN54ok/JGOFfkrSVopsw2bLntHw7N5x3+51NHTZlgflVeFgaPpvFUoYLsZSEF1D2
 Rh/o267uAezPAZtcRHfwVa5/PQTokXJe7J756NcrUMCmdc1uvGC67TU5Asxgg6oMv+IyVEQFgBm
 i/6IYYuRD9x1xZ6B+QybIRU3LyVtXW7NebwGR8G0myonLU2dycSgysswyV9XrCfUPmQP0DTKqoU
 1VowHuvfUXzt0vhw7OyNxxlTNguU1SX6h6Ol/nr1BSZMT5YMm9GPwvBZMvu6PTgAz278B5I6G5i
 Kl+tRvlopP18TK3h8yWzDC0WFWEiPOzVu9Z3LN5PZhXxppjOrDGdASl6ws8ZAJc5rXmZcXtN+z2
 V2eKtgQcLj1u6Ik6Xf9vQfCGL8oDtPq1KlKJ8LHBTp9fGOyld7KwwIP8TnOfr2FscppLHzWONDp
 olhrjxj6MNRGQ2vRp9g==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d9dd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=3wHVdK5kWpxBeTODUnoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ohqZjt751CnaL8m0SdDvxbjvJM6oBMhg
X-Proofpoint-GUID: ZPbgVia0mdsgFQm7hXSCBEj6YCAPX372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qyifi1odb5d3js5w786fz1g77gsy7r36
X-Rspamd-Queue-Id: F08FE40009
X-HE-Tag: 1785911787-600263
X-HE-Meta: U2FsdGVkX19CsL1fkWooXaV15pxIZUzDA5oPi4hcpu5qb49oTrjNgNegkDBX9KgRhaSali1IM6e1AO/ryjFgpKzixQ3gwhDOF8853z3CjmCiFDTgXmp5ssmUG7uPvyzVP9M+M6FHVJ48jtg+NGrYPBBzpGdDeNgk4AKQB4kX+DzjCmrlxd+rO0MJFkiYg/AMJWEA6tU7aBl5HSEwM3bmAQ5ufzimZ1AWeVa7SMNTpUQyj86dYopK507nYle6Iscmxc/RZxd94p2IWlPbkc/ZQ0cXphbs7QYRx/A66Lry2LsRkQMFakQU3mdP0mpLpIDaEIey7UgmCKp3nx2mew7SmzpOouZWhiC/xO+Vl5Uw74tDRTESbfrPtAC6M4HgQ9YBJu2OuU5jjDS7IrW3qzgtjZtNBoIL0Xco2Rov59HwTOJSpTHwDIN/0+Ht3xjdDUIcgWbnx5bJIx2Pk74plsNB9x3FgflaxSoIIE/0ma1W+/wPBdHHb/V6iQY6SM7MsRIKNzegyhfmOTqV2NYqvdL1XR4kSvEgZvyba0RKidzXrj2lONDofgRbYLE1y70/C5/3ACswlXl0/M6fxOkOhK+oKr2J+qANGarf37z9K6tw3ybMD6tp/UZNXVGQlqCrDfO2hB9ANx8DPfMSjF5BFG/S8P2Dx7d4uQPnhoq3Qf3YSZTLu45L9W5LHhVM3xP+S/DwH8mNogj5h1bGJpNk6Y1Snp3qoXBUuXeXiG3SX8mtOb/U9v47ADSc2I2prU6qU8QjGIPD2yDO0KKtb0FOC7oy9EnyGzgEmqpitI+Mzm8Qeaj5gextmOAraQ6pmUiTzAp8YAW75ocIDmarjuRtbNBLqRqmYs+IdsFsTqGtdl13rKjtrL2UMmmGa9M03CACFW2qu3VfwNtEdVKjHftd2gK6vOixnpQBsbM4kFiiqkyxOcm0kpAmvcIA+f8s6n1+K28q93Mw5NSZUU1EZnD7VU2
 pznetUO3
 nK8djDmdAEt2UgiPxQT9gfAH6gsBCC9wVlMx9WpP7PfdG2skco6s4kkutv3nCjz7fqUmdEV01msmPjVEd5gGr6ZtQatwU+5W9BlJL0u/I+vc+5jc363QJhnO/0E9+yQ7SnWlW7HcL9OSaueYipUrm95ejOhkWePcJHf9lhAeXjGkvHEUTkbQ5iYcsRPgbT/KoOklLLqqeaz2Y9HT5uYfuyykJ04qCSkZPZmBQWrHY/e7dmF+Es6sbueD06QHyhml/7Mcq0rwrcvYMc2+CR6ZYxbAiod/RESISnGXPxrZSc3V9kxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 11:58:06AM +0530, Ojaswin Mujoo wrote:
> This is the next revision of writethrough series. I'll quote part of the

(+cc Andres)

