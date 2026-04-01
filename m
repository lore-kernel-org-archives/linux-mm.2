Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1854B10F931D
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B546B0089; Tue, 31 Mar 2026 23:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BBEE6B008A; Tue, 31 Mar 2026 23:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2840D6B0092; Tue, 31 Mar 2026 23:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14B7B6B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:58:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D19A6C455B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:58:19 +0000 (UTC)
X-FDA: 84608629518.25.5AEC976
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55A7740007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:58:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Js0iVdeT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g+1FpAxN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775015896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0JKkO/bv6E7WacPIom2gzM/2+Y/ncRzIG7uIp5Jspo=;
	b=hr+NXfhYIewMp/dB86cHjJKTne3ZoiMI9qt24UM7TRr3NcpX2ITN2itDX7VurMmgmuIZyq
	eMUqjVdsGe9J8YPrO80T4zoQKfth+jmwELP7BRpapWoMhznXbG4L5EQzm1S0kgMAcy33e+
	LWjPPWsAqNlbBBZ1xVZXOpSN50LLnVE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775015896; a=rsa-sha256;
	cv=pass;
	b=4Gvf0RTASg9ONc+ScL0eETsu6gzn59AEM406UsRa8/owTYjVvpN2Dml7zvXR9viVaLZXAf
	FmkyHGPdW6qq9wUJ0rwFC/CSk4bPjNlxfxp59/fsQZLP0QFHhZd2iZg5o1qiEGaEWK5lGC
	rR3h4gZuENfTo7Phd8w8B6Dea1c/nOA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Js0iVdeT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g+1FpAxN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6311GNSE3249102;
	Wed, 1 Apr 2026 03:58:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=i0JKkO/bv6E7WacPIo
	m2gzM/2+Y/ncRzIG7uIp5Jspo=; b=Js0iVdeTDRJRX7VfWXU1UweibjvohJ9SO5
	/Vkk1XXm7SYEfotZYJ2sMlkD3X/HtWIsOot/bDRemYdHxOR3Dg8VlLxVcW9J7IN+
	HVKDeFAxAVilpOKuAPAsjNQvDbNlhCb/w0dX1EE12Plird/o1fZAXVdkD7QqifZS
	d86lW1v4WbhtugB3nD6qnCiDOaDulKp7jHE562XBpspGGnUbeBXc6OEyqOh0Rk7F
	/+2P170UUFQLZZw4bj+olg+uszwm2moEMBXRfLs0oLW/1GgmYsdWE3YaZkR1Kty2
	FYWMuVnriR4cK22QBWjCcemykA4tbG3g0bcKNPU4jAFh/Je1wNTg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65s0wq1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:58:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63128Uvo032016;
	Wed, 1 Apr 2026 03:58:08 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eass4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:58:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQ1rIZaUAgqJCbOwcpE3D3R+pAxT1LzBPRV1Dpi4FcMs6iRv5ODdCJbvwJJwDW2S+4grcrTmUphaY4FKfAgzVMvZAhe8FhBw1ePZvjMqEhTjCD8r3FPF4whMjrxZVpnsIFI62e4xt7MqiVGUw2GkxNW+4Ei8p4H0s7T15dlAz0vb9ODulF0tmJzhuxugaQCZPlxsI80mt22zr9AgZ+kRy+NBR8NqZ8N9xVZ3fSBC+CtlWY2aITEgjd+fIbyOGpatbIfVOXINXLPE7Mo9faulnBRTJR5KG/V6r+5YZhqUna5ZuGTkuXSbKt3W+QP5P5X254+VJFmUrGgFcBCj1Uu92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0JKkO/bv6E7WacPIom2gzM/2+Y/ncRzIG7uIp5Jspo=;
 b=L0im5NnwM22I173e89ChzEGw1Iz0bm4FSQIStiEDkA56g9o/RFBxjq8AJ2rT8qwgLGHKVtOdwdB3hQh2grEg+2j626Hv9tLcs/lU2Su5K6XU3suBXUT7Q6k73jHB3R85tkJpXv4hdhxWAhzOzs5XSfI550Rs2amVUSsMlzxy62eXUw6nX19WSM7r2TSfLn24rLhQBljZdGbfkMI5DJNPhV40RNK9T2hO0ftfqCW+hqILVU97xV8UjBojmxGuOgoTdSy2MhRbpRbElMqFL7WB1DxDT/EFjpBT3cwqffJ2Xp5sLtySR/Wem58Grc3Zrunp2SwzzfsJ2s00z62fuyQd3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0JKkO/bv6E7WacPIom2gzM/2+Y/ncRzIG7uIp5Jspo=;
 b=g+1FpAxNt4LLxtKtsVQZeeIvZqIFQjIKUXiMcOWc4maCy9vX3XsxTyp0xWALFfrVHhHngzIa6zx5hSHsP1QRmP6UxxALLy+mS3z1vPGRylhpaDSp6hQNKG4ATDCOphZJkQkuTE4YxiOfSjzHfGsbD5n92au9WiJRoXOY82yhorE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB7624.namprd10.prod.outlook.com (2603:10b6:208:491::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 03:58:05 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 03:58:05 +0000
Date: Tue, 31 Mar 2026 23:58:03 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jianzhou Zhao <luckd0g@163.com>
Cc: linux-kernel@vger.kernel.org, aliceryhl@google.com,
        andrewjballance@gmail.com, akpm@linux-foundation.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: maple_tree: KCSAN: data-race in mas_wr_node_store /
 mtree_range_walk
Message-ID: <sszfprixbeowfmqrx7w7ifjmbyg5goelzfnggwcxfkdpcpv7tu@7n7sy227pi55>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Jianzhou Zhao <luckd0g@163.com>, linux-kernel@vger.kernel.org, aliceryhl@google.com, 
	andrewjballance@gmail.com, akpm@linux-foundation.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
References: <480ffa8f.3729.19cdaef38bd.Coremail.luckd0g@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480ffa8f.3729.19cdaef38bd.Coremail.luckd0g@163.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0499.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ce603e1-dd38-4559-0c64-08de8fa2e0e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6fDxyiweDkZ2N+Gdm4tZo6pMJcavoE9ZcztxD9yVTb2e/vSV6hfLfR+p06apY9VVztFpeMXEiZDSP1kSRr0RgAYzHRWc8aKZ2V8LLBRzEYJWn1eSmaL1bnQB68THTswJ+K3cXbrJuwZdDPNKu9ASsC690j/0BN4UHo1fgyqRcKt+0WWkRruGIL7xBRagWTcl4fUmWN+a8GjWl+KXasSiWskDHl7PY9gF4uOKZa0lXpcthcGzqPEF+7JtVQYmM9BwtpCIxb6huVp6lLa4eLEzP9N1FYwTWXFcM5W6VRYC85vSwOfqe9PlWqAbKs1+3FByRtCWt/j+YCCcB7tkHmtRvXQ9kNOhs1L8fr5D03gD6evNj2wrQHQkUnAWfXGsKryh0il5YEQM7Co+v6nHvgceTB5HEIuDu01qnkiWZ17ddnw1MRaCNHv3Oh9BSuBHgvNW73xef1AuFNZyAV3uPJocfln0mM4kkPNO/6XzfVb5l0/F4XFigzP9fBRGgsxUR+M29S1zeJ9rrg2wnU3INN7ophK6UH9aP6QVbTHoHyrzxUmD/Nl9ZxFGRo6Is1Kdbfhqe3BPAY8iKsFYDLZD6IjQVvV/QrnGZ+6U5xwAqgXwjt7gAndvV60UyytYgCrhWEyKz6ekFFKs21EttRCDgu25pp/j3hDzinAJSH7HeYP2ajb+ycbj+6WxFN8gyGff4kkhnYz8GoCBw/lryEdrtPIaRxUz48Fthw1elz3crMxaQXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZBxwB/T6iSxwLzHL1CsfqgS4ryBiz0PHiFYeXrjIaJBKJP45TkVn11YoMTLE?=
 =?us-ascii?Q?SdepUtzUYe8nS2Rn2/gnTk1u4D/dMTdo7UzZdiId/d7qEwwnBbrigAelQAno?=
 =?us-ascii?Q?Zd9Pzn5Q38bXCwLS98RVtNOcHTgzpDHsv8t92CwoVqK9myEWVqnBsjfXTpit?=
 =?us-ascii?Q?cFo5/ephV2DPTX7LIhWiTNDT4EczDl5E6ucHnhi/29yd9z+DuG40Bpv0ITfQ?=
 =?us-ascii?Q?kwlIlEMzTcIHJR1dZ65XDOuWfA0v3ScQEUR2Mvx9RlYeYAhtJRWLb4oAZEfZ?=
 =?us-ascii?Q?EkVjDUgqfSi8H2NUL1cCIS9pFs0Zls5wwcb/os46HgTPgIkJJElUG5PoxM2f?=
 =?us-ascii?Q?59NiON+Q/yrLQMLYT6F9RdvEd77oJiQqojkeXqznD2FtRxmaJGfzp7DPn1zi?=
 =?us-ascii?Q?maLKtdvGj9SdGk7bHSeLnUYBwgHjV0PYxeyoY/K53s6OhuFSvdVaNUlHJoPz?=
 =?us-ascii?Q?FxgK+hwjqhh/OwuazeURdAS7oRd1449ELgHyP7t9nTPcP05amckCRCwo1H8S?=
 =?us-ascii?Q?Om6PWYGM94dao0nzf1W4ch+dxP2H3I+hHClpGjxCOasZJ04U6TfMiRqzpH/s?=
 =?us-ascii?Q?BrEYTVBPN3B7Co8eQvEekS6WcytC3BquxiwFGdQoKsTOXJVNnCgkreCd1poK?=
 =?us-ascii?Q?MUVFDrIQ95K8WNeZ0+A5/v+ZiwF0Zsw6+0IWDE0vxC+pK/6XQddKastsYKR0?=
 =?us-ascii?Q?mEepcSpWjU3yyE7m1GIR4uP3YtbVOjwINSvgUibe0FIuLWrdI9fMhrKIz+sJ?=
 =?us-ascii?Q?nU/J26jF5cxHDsuztfvn/ZAx5ue3s3apLT6dafqfUxU0Fguvk1dpDmlV4RUS?=
 =?us-ascii?Q?LpxOoOtLrMJZ7jeEpayfuvVQM7IQaS0CmCzeSCN+GhB1RaAfGzRb0uKaoHQ2?=
 =?us-ascii?Q?F270qicqCAS9Rw9fpAUUX3W5VvjjF2ZhhneSqtxn0qLUjuSTbgGWWVSo2jGE?=
 =?us-ascii?Q?8XxIGGpFtmazfyYwVJ+FitO+CR/v6pCHQgbC64AvNnzY+NdknJjSuJhS6PuZ?=
 =?us-ascii?Q?epy5EHfr1b3FPbT+NJjQZqt+P62ahv911I9hIspTHE5+UUiPzV9IKn8MTkc5?=
 =?us-ascii?Q?J0JAPN54wd8lv6VTG2pmrg1Z0pxZJuwkoVj9MB4B7jnaG71MxftaevEkvrqA?=
 =?us-ascii?Q?YC5LzeJBh08M/TnbRVblx0I25HoEJig6PLsofLKSCyL0q42wViecBLV8Tgdc?=
 =?us-ascii?Q?zcth9pJp2ImXU7kvgiwJwOMGBJUYMKOK/JbIdg5NJrdCGxuoWErjxmf4Vxzo?=
 =?us-ascii?Q?UwcT+7OMYdque02uObmm8I3o6N9YxZu/Ci2CuB7+SyfXCXuTu+oCi6VKAh72?=
 =?us-ascii?Q?Gjd3Gu0fih7vWaDrlsV4ixTU6xbTEoTJIT/uNVo9jteDfhseMM+pZD7wHMSi?=
 =?us-ascii?Q?ZJ8sS6m17xAwd6IhYEuRmKtb6RWyAOo7lRb4nDsadp8Erj8MzxxaDhNQaChR?=
 =?us-ascii?Q?llyG96O7OjSdBJ46Zc9/XCo21eISkSYZA8tCHd1+C0LarRB5+uk4hyOMigW0?=
 =?us-ascii?Q?yk7bYe5W5ykYItzQy32f0IayezvvwzrygHZr6n2TWL738nZIXM51x8qswd7P?=
 =?us-ascii?Q?4e3vyiTcF9S5mgpkJhgVUeQyIXIbfYPR/axJc0E1gq4yIZYac90SjhaV3Nn1?=
 =?us-ascii?Q?KJrLbZ/WODH6s+7qvuGwNGuHuvv/7ozayfnDw9zhoycQXkC05hlCU7QEhZNN?=
 =?us-ascii?Q?nJMIvjBEDqWpe+Ko9D3CyGBweypJ8wgLH53FUhFUy4aSNP742GGC1W/cuF08?=
 =?us-ascii?Q?hTMO+0S2vg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	o2GaKwIqrtOTbSHXuiEGHKOdJ7LTQm/csKJWPu9cSDpDZPjA3TCf59K3QfJYDy4+x325RLw4eGnH+hSgbHFZRdc3qG7iOYJHU6Cg7+xy4untdH1jj5+dPKks6mHzbX7UncEEdoXZIzJj/23RQDe385Fq7aqWDXlQiQK0xNhuODYyd/8yJxA1eLDFnadG8KthnFlN/rX+NZYyyMVgNfwVAJ/4yErlBDVOOw6/AWNO2taeWOu/vOFyDxynxzxB8HTInRX4IdbD+YhexfwpIRqqhajXEFBkDjA2xuhHY95QKc8Tw+ySbhTh87TppzpGrVPUJxrr47XHTTJBhHguSib4Kw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JoeOvvCEtr72T8htpQuP/f0VHPNs4lipd2FW+kGuicYCNVDoK/ESDu8wXWFeeX2d597wN7jJQw/vY2wVVnPx2cy1Vu9ZjRpaCGKoavQOm3QLnlz6R2aCD/z43EyR87icOC9ijpOROhDvMs7VBBDQkBls+oNKrB36CvDa+pzaYt5p3StRO4rBr51Aayjrh3Gryxs4K7g7I5IS0FguxALL/OpBw6u1QgjHsvFaypPPOXaZXRtPJV7hpAbRAsmz00s47kqZwW7a66x52FoSskba0CAa7bVFBXeIyp7vhDbjazGHO4a89idqLvMlraAI2KM7GvYz7is4ayrl0Xv+rbDiIQCuzfuIhyJna/k83XDvcV+EuKutciSq7e8FXY5a+3OooNHF/JAygd4af4FePKD5iec8jYWF/vRW2cRjEH9RzEk1PKZT4rbrpcatRtx4I0rJEub3mhPbW0Vg/v1lNHyMplbLk2eFVThDzJ5LpBxbbB42ysf6uwuqGyU2vUzlyLe8KYlRV+BTg2eaMk1skAt/rg50GVwsd/II3uLfBos3KZTOhGmczAtCOcfXF0uNw1iLKNtuCeSkdNKasWnLOv38NSkOEm9RHKl4jh4as1DWYSE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce603e1-dd38-4559-0c64-08de8fa2e0e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 03:58:05.5214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Es6g9Z345sRkYubotOHkAgmfjSHDDC4UQYCR3ZqMEz8Y+kyxTc4jE4btTdoJcH9YPFYPZnT7eq4FyI9T8x0EsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_01,2026-03-31_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604010029
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDAyOSBTYWx0ZWRfX47IWwfX27jCp
 d0Jmx173EbX2cO+UH9UJ6C2JX26qQxbLG5dX1cjMLmH7RNIPkb8YCY8QJjlMclqMfqAIdQ/ECks
 L7aLQPhnBfbQdesvQ/L0kD8sbXIr/ZDdnOUHPSumB+0UghaoWWXYCMuV+Epatdksce4uP8nPQmw
 glrITyaD4HNf5kzPjovc0Ejoi1+45U58EuLaeK243y7d6u8lTpSXcKCwXGQ51b3AmNb23i6me49
 e+0jBiaGY9xdqpS0UUOUgueCgPyq68x08bKmdgDGoIOuXYKX/h8n+jxaZm+0Y93eN59bbRZjlyx
 5/39qFI+ofPi90+ufrUl7cw42NmX0PLGRhI7Gdo0/CQ4r+HN8wqJlJ744ajhb4UWShYOxBwcklA
 BcVzgkMOXh9bcySoGWE7cKZAIMEb/v5VA4mS9/Exz4UIGHTtA6ogFLFphZDYJ281Vsoz4Aj0uaO
 giLpiM9n3KI6WmodVTQ==
X-Proofpoint-ORIG-GUID: EHfRmfy5R-OOFkZ-p_oKJKJ7jf8nb0ea
X-Authority-Analysis: v=2.4 cv=BvOQAIX5 c=1 sm=1 tr=0 ts=69cc97d1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=Byx-y9mGAAAA:8
 a=SJfFNOtzFRw1tPChFt0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: EHfRmfy5R-OOFkZ-p_oKJKJ7jf8nb0ea
X-Rspamd-Queue-Id: 55A7740007
X-Stat-Signature: 3t1perzgbhccaq8j8tiq37j86cn6pns3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775015896-891314
X-HE-Meta: U2FsdGVkX1+bpoo/vym/pnkkP+V9ZiVFrP28VL//aWC0zfP1R3jUFHDzZkGTsWe4RMPczlw57ts6xreH4mAfeZX6fSVFsAaGAK+padaaugo/7na0KHC4b0EPqq8QMW2GumgMJu8cbyz0QmFSfLoyLykhpdb246jxJ3fxAmZCDgpSPHY5C3SlS2Mycz7vs9CmH8pO1H/Ozz7diFNN2cA3QJb3eZYJk0QVBn8IMBSyU3hoJDhYiAmHqECVxeDpcmcNi6CkpfusloJdbwPqAlSw5gIvRnTwbZ2cJWL/hLzbM3ZjaFwWNpDdxXoELhuw0qhVRsltr9lY761g+EWQE5wF6aNxKOZTeUzoqunyNpHjeI+3a6WcG3kNl9n1jKD6A3+IJlwt63SSAdUiDMALsODfi4G4rAiQ8VWhZBA3DLq6hR9ZZTdT5DlGYIffNQzEnbCHyDtzQHWo3b7NBq1zZtzRN0hsgcu+l4XKX3NJp79iSWxGkZdYWLplIWP0Ewz15QRQiZ+6LoAKpsgZ9wYp0Ht7Y8/tYfmr6VIBSfNydOtdxMh5grZRE5D31HAh85U2+OUE15xYBa7FpZlFs7KIQl05fh+yw/Q3bvk7zYW+oAz3okCIH21NK9GJpCHjKLpy9EXxEqsBekOGtvltPRaORNLtCOqgcmvFTFZlIrqwgQedRh89byT/89reXzbKTAqoBgZbw5Pb2RQprRphg6ffJi1IcWz/QzMZkIemfacfmL78Eq1ljWIdFpMtU4BSqEezDN00ArEYT/8lb4yGX6qBA4Vt4krDVRbooabuVHoMyqs6HwhLTsrZ+RBgSC0rGHJl6F/rRxK4J+3q+s+SCe9VmSEGEdn3R9nHXrrhifkEf4iLjJPdFSwhmwPyuu4HBIVVTEhZzWAlYNc3fDM521Bkglf8/rxw6KZFPHercc0XMpLlpMt7v73U73/CiZ2ukUgwspRSeOrkK4cULdPHY+bpwpW
 W5yMagjc
 q7OMQCudS3aznHRgWP3ONqHP0xLoKgArCDi1EEkRq4lTqPQwfncblfNOrXZIRR7NfcmRA7uUyRCjoZVkxYb7xooVAEisdiD5CYgV3cRNYQijhOrdAKPPZFgz4vcpPHh6nefW0AgIF9B6CqLXJMN6RdV+f8STdA1LJlKFKHId2Hr7sFLCajGDRMaxcvg+la2h2lAXI9ouElTUTEKLJvE2IDMfQ4TJBDUBm7tfuoMSUhb6b1I1Y+Z0sBt7JG41d1VbryzTGy002jlOp5drdPIlBSGXE+olVN2Xr2yYF0gEcboVk+pv/8iHJG46inxC7htN/QMlmLXeKrptDzhbBKSJKvMzesIC5Zdx38ZgyJuk3W2QqLL19bdVNA12U1prOP0BBKNYB3PDzTCuWj/rCyYoeyND3bCVcC+0FjakOcywmPrf5kr2goyWOf57qQ9qLUJTRpxFAYzp2EpXs+mTOtnPwKqlQ5J9oyVDKdNEvsB0HPligQswPukFfKGrvqi439Wflrnr0cMRHNexH9QHdPDphxAKPw836xXBaIxWpYMXmZvJD0KsoTxxflle453v5eUMphxr5sHwKp2Gu5+Xz05efh/7Tj9flNmC8whCl6+hQfiXpFy4WgqKDZQmbD1ewqz9Z6Jc0GJIFo4j7p8/N+6M3slGXbRryHZLl5/pS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Jianzhou Zhao <luckd0g@163.com> [260310 23:27]:
> Subject: [BUG] maple_tree: KCSAN: data-race in mas_wr_node_store / mtree_range_walk
> 
> Dear Maintainers,
> 
> We are writing to report a KCSAN-detected data-race vulnerability in the Linux kernel. This bug was found by our custom fuzzing tool, RacePilot. The bug occurs in the maple tree component during concurrent node storage manipulation and tree traversal/RCU walk operations. We observed this on the Linux kernel version 6.18.0-08691-g2061f18ad76e-dirty.
> 
> Call Trace & Context
> ==================================================================
> BUG: KCSAN: data-race in mas_wr_node_store / mtree_range_walk
> 
> write to 0xffff888023e00900 of 8 bytes by task 62996 on cpu 0:
>  mte_set_node_dead home/kfuzz/linux/lib/maple_tree.c:335 [inline]
>  mas_put_in_tree home/kfuzz/linux/lib/maple_tree.c:1571 [inline]
>  mas_replace_node home/kfuzz/linux/lib/maple_tree.c:1587 [inline]
>  mas_wr_node_store+0xa5c/0xc10 home/kfuzz/linux/lib/maple_tree.c:3568
>  mas_wr_store_entry+0xabd/0x1120 home/kfuzz/linux/lib/maple_tree.c:3780
>  mas_store_prealloc+0x47c/0xa60 home/kfuzz/linux/lib/maple_tree.c:5191
>  vma_iter_store_overwrite home/kfuzz/linux/mm/vma.h:481 [inline]
>  vma_iter_store_new home/kfuzz/linux/mm/vma.h:488 [inline]
>  __mmap_new_vma home/kfuzz/linux/mm/vma.c:2508 [inline]
>  __mmap_region+0x12d5/0x1ef0 home/kfuzz/linux/mm/vma.c:2681
>  mmap_region+0x15f/0x260 home/kfuzz/linux/mm/vma.c:2751
>  do_mmap+0x754/0xcd0 home/kfuzz/linux/mm/mmap.c:558
>  vm_mmap_pgoff+0x15d/0x2e0 home/kfuzz/linux/mm/util.c:587
>  ksys_mmap_pgoff+0x7d/0x380 home/kfuzz/linux/mm/mmap.c:604
>  __do_sys_mmap home/kfuzz/linux/arch/x86/kernel/sys_x86_64.c:89 [inline]
>  __se_sys_mmap home/kfuzz/linux/arch/x86/kernel/sys_x86_64.c:82 [inline]
>  __x64_sys_mmap+0x71/0xa0 home/kfuzz/linux/arch/x86/kernel/sys_x86_64.c:82
>  x64_sys_call+0x1b42/0x2030 home/kfuzz/linux/arch/x86/include/generated/asm/syscalls_64.h:10
>  do_syscall_x64 home/kfuzz/linux/arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xae/0x2c0 home/kfuzz/linux/arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> read to 0xffff888023e00900 of 8 bytes by task 62997 on cpu 1:
>  ma_dead_node home/kfuzz/linux/lib/maple_tree.c:576 [inline]
>  mtree_range_walk+0x11e/0x630 home/kfuzz/linux/lib/maple_tree.c:2594
>  mas_state_walk home/kfuzz/linux/lib/maple_tree.c:3313 [inline]
>  mas_walk+0x2a4/0x400 home/kfuzz/linux/lib/maple_tree.c:4617
>  lock_vma_under_rcu+0xd3/0x710 home/kfuzz/linux/mm/mmap_lock.c:238
>  do_user_addr_fault home/kfuzz/linux/arch/x86/mm/fault.c:1327 [inline]
>  handle_page_fault home/kfuzz/linux/arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x294/0x10d0 home/kfuzz/linux/arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 home/kfuzz/linux/arch/x86/include/asm/idtentry.h:618
> 
> value changed: 0xffff88800bf0d706 -> 0xffff888023e00900
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 UID: 0 PID: 62997 Comm: syz.8.4355 Not tainted 6.18.0-08691-g2061f18ad76e-dirty #42 PREEMPT(voluntary) 
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> ==================================================================
> 
> Execution Flow & Code Context
> The CPU 0 task is currently modifying the maple tree mapping memory ranges via `__mmap_region`. The tree update routine uses `mas_wr_node_store()`, which calls `mas_replace_node()` to swap the old node with the new one. As part of replacing the node, it calls `mte_set_node_dead()`, performing a plain write to update the `node->parent` pointer to point to itself to indicate the node is dead:
> ```c
> // lib/maple_tree.c
> static inline void mte_set_node_dead(struct maple_enode *mn)
> {
> 	mte_to_node(mn)->parent = ma_parent_ptr(mte_to_node(mn)); // <-- Write
> 	smp_wmb(); /* Needed for RCU */
> }
> ```
> 
> Simultaneously, CPU 1 tries to handle a page fault with lockless concurrent RCU lookup using `lock_vma_under_rcu`. The maple tree traversal routines `mtree_range_walk()` calls `ma_dead_node()` on the nodes it fetches to ensure it hasn't stepped into a dead tree node. `ma_dead_node()` locklessly fetches the `node->parent` using a simple unannotated fetch in C:
> ```c
> // lib/maple_tree.c
> static __always_inline bool ma_dead_node(const struct maple_node *node)
> {
> 	struct maple_node *parent;
> 
> 	/* Do not reorder reads from the node prior to the parent check */
> 	smp_rmb();
> 	parent = (void *)((unsigned long)node->parent & ~MAPLE_NODE_MASK); // <-- Lockless Read
> 	return (parent == node);
> }
> ```
> 
> Root Cause Analysis
> A data race occurs over `node->parent` between the writer updating it to indicate tree modification explicitly (via `mte_set_node_dead()`) and the fast-path page fault traversal logic trying to deduce if the node is live concurrently (`ma_dead_node()`). The lockless reader runs while the writer makes an unsynchronized plain store in C.
> Unfortunately, we were unable to generate a reproducer for this bug.
> 
> Potential Impact
> If `ma_dead_node()` reads a partially torn or out-of-date pointer due to missing compiler annotations (read-tearing/store-tearing architectures or aggressive optimizations like value caching and hoisting), a dead node could be erroneously evaluated as alive (or vice versa). This could lead to a use-after-free, memory corruption, infinite loops inside the `maple_tree` navigation routines, or local Denial of Service (DoS) scenarios under heavy concurrent page-faulting load.
> 

What arch allows tearing across reading/writing of a pointer?

The node is checked if it's dead or not twice:  Once before operating on
the node and once after the information has been read from the node.
With the included smp_wmb() and smp_rmb(), I believe this is sufficient
to ensure we do not use data from a dead node.

Does this explain why you were unable to produce an issue?


> Proposed Fix
> To safely resolve this data race without compromising the performance of the RCU walk path, we suggest adding standard Linux kernel concurrent annotations around the `node->parent` access manually. The writer should use `WRITE_ONCE()` and the reader should fetch the pointer context via `READ_ONCE()`.
> 
> ```diff
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -332,7 +332,7 @@ static inline struct maple_node *mas_mn(const struct ma_state *mas)
>  static inline void mte_set_node_dead(struct maple_enode *mn)
>  {
> -	mte_to_node(mn)->parent = ma_parent_ptr(mte_to_node(mn));
> +	WRITE_ONCE(mte_to_node(mn)->parent, ma_parent_ptr(mte_to_node(mn)));
>  	smp_wmb(); /* Needed for RCU */
>  }
>  
> @@ -576,7 +576,8 @@ static __always_inline bool ma_dead_node(const struct maple_node *node)
>  
>  	/* Do not reorder reads from the node prior to the parent check */
>  	smp_rmb();
> -	parent = (void *)((unsigned long)node->parent & ~MAPLE_NODE_MASK);
> +	parent = (void *)((unsigned long)READ_ONCE(node->parent) &
> +			  ~MAPLE_NODE_MASK);
>  	return (parent == node);
>  }
> ```
> 
> We would be highly honored if this could be of any help.
> 
> Best regards,
> RacePilot Team

