Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C892F3029D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 03:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522C76B0100; Sun, 15 Mar 2026 23:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0C46B0101; Sun, 15 Mar 2026 23:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1EB6B0102; Sun, 15 Mar 2026 23:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE606B0100
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:26:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA6055CD0A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:26:03 +0000 (UTC)
X-FDA: 84550487406.26.94D2E9F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51B421C000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:26:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HzQQ5ftY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j9Zr09Pn;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773631560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRBvax96Ov3mEIv94QP3ZppUy27Pg88H30pArWhYm2c=;
	b=I/73lIJ92san4j1S6kE7/IgGIAwdtdjZDMSSLoVskbdcpN04opzhOtwwNTkF100QUhUnfg
	vN9ZXh+AZn6mSi3sYuAyDWTsgIpbGY/0iu2QhSJEIf6Yhe2qVUfm7/qdBuFsxwOop8Y60/
	aKJKUInky0DCKjKVj/9ePQWKWpmWlv4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773631560; a=rsa-sha256;
	cv=pass;
	b=3biE1QnklOZ0rlqHHJHipAVpMqjXva0b/JBQrmMRX4sja8U2z1aATZ5uEB0c791bFoBMjc
	uHyXkkKZfY8VWNOZNhxE35Cj/9SKoP0XDYCy92wzsI3OcEdNFo8zR5U6PMHc/px1I21WcN
	iaSYzdWWAdTLU4g3SRlpFBn/Nt7oZOc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HzQQ5ftY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j9Zr09Pn;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMhQ1j073784;
	Mon, 16 Mar 2026 03:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kRBvax96Ov3mEIv94Q
	P3ZppUy27Pg88H30pArWhYm2c=; b=HzQQ5ftY3W0dOOFR64NwUSb497lpH0a2HR
	cBuC8YsNxf67zFEQTMx2wfSsD363dw7JqgteiFME51ID4JxXWPK+vutIIz5VP6xF
	2IERlaFlInu1lldhoAhHV+AfpJUKVDXnoe4BERxZloGWEr3XVHcvqjFZWi0FbF8e
	s/C+4PvzEycClALVbTALi30XLRp40PM2RFJF4eOiEprjTdpjMyp1WBijVgIlv8xe
	HHh83atLjWXsF96sXSOfCuxZFvD0jOituFRsNz1My52I5V2QdZ4qQOGUAMVxtsmb
	aQ8nPEQ9zPOi3SzDRhgGL/FN+rTJdfTVnCVN1DaDJ4Qz7kMw1+YQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx8x1edr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 03:25:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G31PHt002761;
	Mon, 16 Mar 2026 03:25:50 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j9vv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 03:25:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtI+A/KKxUmF2vBuQJPHNHRODtjZuJswk3h9s3EKpC4zR/pMnq2WsexkODK4GYe7WEJQApo07c9AV9Ccx0RtVytjiKVB4MMQ7Tqy550NhfeozwMxXBTg1hhdcvjv/djRuvKWgD2huOBA9jkpgKyqHOmQN4Cn350o1GyK68gh6mZHyeAxQnynQbSYA/xFTOI2z//broLcQThiYEX54S0721oT64OmNtQBVPIPJ4iAoP13q4l6zJVbrGxy9AxIVHX/q5aBIf84Zr6ky/XNlaXiP5RxdKL6SkgZsMVqABsOirxOI8frlmOzxsKOPFx1WryUwYE4yAVY35bVWvKDJ+pxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRBvax96Ov3mEIv94QP3ZppUy27Pg88H30pArWhYm2c=;
 b=y0dk/u2567DBWlt3mWoeighD9ZeR6zUg78wZ0suUtL+Y+s++UbqlB4h2yT0HvgdGgrTaCh59+0KgGmXVsfJyzfTasrHX14XoW3sBnhVApzSXtvCGfZMnX8JM1eDrok9hntEqSgYLOr1Zy0jtgL0RC4Sc9P01qCICmFbIHrCAC4ZlYowvqWV/x26rYsAmSre1YoK+7PHnSKpGysi+JDv7VrxPEasO0QR+2ldFy+prCXrxZ4whIS+OLTb051wz8QhTTXRtdWBw5dXHJMJOX/G+FYOaW5LqDmY9ECaZ/WxJIT96UhAxmtZVXaKFQK2/P6hFeM56tj1GfpTIdjgbP7uW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRBvax96Ov3mEIv94QP3ZppUy27Pg88H30pArWhYm2c=;
 b=j9Zr09PnAjgVNzvmuPVpiSyaHSE5OqhxdZnI63RbJlrj0h7cnNNieyQkt0Ky48LCuvPZDlAozlMJfu05XqjGZ98MY4aHY3ASIZ5+GZszEAufnPPdxqNRWDSva+ALC6VYPWryETGCt4VSCT4Rp6Krtha+HQcNZsck0PW4zlecctw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB6129.namprd10.prod.outlook.com (2603:10b6:510:1f7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Mon, 16 Mar
 2026 03:25:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.021; Mon, 16 Mar 2026
 03:25:47 +0000
Date: Mon, 16 Mar 2026 12:25:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
Message-ID: <abd4MxlLmj1OBnHF@hyeyoo>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
X-ClientProxiedBy: SEWP216CA0062.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c8bd302-23f7-471d-f9c2-08de830bb6c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	lFT0BWcIMQn1J1yv3zi9lDKFOZpVgm/Zpj1LL6rUSpMj/040SVY1h5tXxxNauaMAin6HUQrIEr4u8PcDk7QElXjhEOuuFQJnWWpDTqP8e8rOwJcjEvDnxpESLHPyI9h4sik980v1jS9hIFJtHYp1lsn+PQ/U2xF0rqSTevZpuCYCNUKSVuvBULSvHcgSAy+tNxD/8M957wH9ETK1aMPyn/n13H12hwp8VjSjvS4v+1WMF9OhC31KyiFOUXUTb01WAuSW2qscvQ5/kvLmTCwudy7mjPYutujQJAiTEhSeM6h9wn4lawL0khqrrUQLvMOIJzie99W51uqWylX6DUn8MuocM4VY9kwk5D3aL7Hn6JL0pSMFb70y3Uhrc/ou4WzPqltkMLUg3Qc122L9pxVw4m2p9t5RyqJI7YwpfSkTACWTyD2/IiuQ0/UDiIkivNE5Wz0Aj1UfFOR+XCBEu7j6069PLF2Ms/sJxwCmzDULtpJdlOFMr3+6XByViIqFX322WNuWX6sFErsvWpESz4be1UJrJn18KjMtANAxlrj0qsMI0FZz+9lS98EyRc6aVvTXcf6qWHTdweyoSSzStpuG5sgPrsU/obL4DmzqqbT1zzXp4Dz/oqIgv5UDrJtahSXe+/rIT0ADKYUJVo1moLg+MDhvb1GZURdBQ57hqbn8uwozaXY9ejgwqqLthgIRZEjEwnCAb+9cRHLHYI5qhARNlDTrwTHhovESuAi/ht+WWBPTlINLiTm6Ah2wTcUcFr+Q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xwnw5LVNHZVE+snro9fgr1u1C7M9O2Eih3uWKRHokBcnZWtgk/Mdi84Jhj8D?=
 =?us-ascii?Q?BknqP/EYVsPoH7mMzrmp5IJf/c/TBdI/XSkWf4XK3xohMnn6Yyo2C0oZPdM9?=
 =?us-ascii?Q?WICeieHQWiqtRxwMLqxy630ZnOkQ6xofhcEmTKqUcjq46qrmfigel001t4It?=
 =?us-ascii?Q?GjK8lglmvQRduo1aDbr6wlPxZxhHbq8JI/f/MMWaKpy15gcWOl4B3cUpJXMx?=
 =?us-ascii?Q?biST07b/UTi9REY1xnjuNliMukLm6rEC+yJuUg/TtEMietPKuwrTCcoL4Bsm?=
 =?us-ascii?Q?k4HhCg/qY15ygfd/s9dAT4tw9qOoELGqD7IKDOFJruvvEimdcVNJmxLh3Xjp?=
 =?us-ascii?Q?1xTrj8cXgfznczb51PU4e9MDsj9Wd0Td6miqDjTuCQKBGfZ/eZsPJh837VXB?=
 =?us-ascii?Q?2j4+M4E4hj7TWmcW6z7F7DKMOpktuATN0s42kcEivHs6qqC4q5/On8cdLjKj?=
 =?us-ascii?Q?ShKTg7BOWsHWOzugLH8M3Dx/UbmAPX4599i1JA+pJNtIMU5WHN7fp3IjSWWp?=
 =?us-ascii?Q?a2CNEi8CRuluRKmG9vjUcng7ak+htxY5VXJoqrlEsLyDo2NGEF/b+h53EooX?=
 =?us-ascii?Q?tpazE8MwHNmxjGbf2rSaXS+dYdUiZZc2AHupzXqq3H6auoX/aB7QMr52tR4g?=
 =?us-ascii?Q?/IaTyL9c6Q7tdKWnlW3UnKhqnl4idSUANF2twsYJ0cs2IE4grwovbjZRbtPq?=
 =?us-ascii?Q?B9v4jNCfQuG3+Atb0UHanwEo8O5eXGhEmbYQt5p4OMoiSNI3DdKOXlcVBntW?=
 =?us-ascii?Q?XPNsqvOQj+AdqKoXeGv1u1WzxXchKrZLFHGPvtkhixODEs7gwmSU7zd/oM6X?=
 =?us-ascii?Q?hYoSsycz9CKyJetDKrmf3xT9iUqaiHlnxDL/32BaG3nTJLP3kb29eBMcAXrS?=
 =?us-ascii?Q?q2SpKpNIsynaRPgDoc6CD6diJXqQPwNr/TagGGiz+M/RknIoOQs0bFOihip3?=
 =?us-ascii?Q?6exmP7aW9vRF2kjfhtJH8URW2u5oPQeib8FqTsmQrSGDazc+s0hvwH+I5brt?=
 =?us-ascii?Q?Esk2HdJpSrSdNAPeVajR44qKJe6X7CaaGahGziE2RI/4StRhR249CVRIXMbY?=
 =?us-ascii?Q?SPS+fdVrD6Nmv7+bQjT9201InbABP9fKxdWUj2fgHJ669LAVB7EomZrtcb9V?=
 =?us-ascii?Q?nt/l76g/QJ+u14UqWQHWJVq2amqHUomu3z+IxRbZ1TjfUi+kk+7cnzSTahW9?=
 =?us-ascii?Q?VT+n01zdmQ8VNuAUL1Sr207tVvbpGN4qvkHUTGoten1L+aiK97qSBdJgaDQ3?=
 =?us-ascii?Q?P2+8vayKVbM3rMeCNv39yEm8rU1wiwwI77Oh6C32q+DDZVcXpLSmD1fD2KuK?=
 =?us-ascii?Q?aSOs1B5g9U9tZkHGoQAYNViZJ0+kRUNg/PYUPMgYtAQkxOeO8iTVCuOhaKf1?=
 =?us-ascii?Q?OJBYw/FIG7WC9HpYqod16kTTMJQK803AUmazLbsirn6JTi3HVUnXXsuuQ2FT?=
 =?us-ascii?Q?El96MT7pCjcAVHLZyuMOX04YoKtfmaUW/2nLtT27NCpLwtUc4P3VzfcnZ0UR?=
 =?us-ascii?Q?vkKAVr4KrlBZ8VpFrk0zZCQ2tto1XXaLYA1k0eafubG97X3yMXAGqobxJebE?=
 =?us-ascii?Q?b4bq4nvR2ZAT8niWwgZ2RCw63DCd6BOajcn4LgBhaMjI1C5wWRUQnb6n85Yf?=
 =?us-ascii?Q?oQ2PRvgaCxjnj133hMCKBjYRZUY0emDnze/iAY63oVtX8bmcPZFPXM5ONHqg?=
 =?us-ascii?Q?Fu533dEDpqpFs/yffG5NKNR/ZpzItwwt51J5DCcDQ3cfjw0PLJHijhDuFRra?=
 =?us-ascii?Q?Cr8vTpVVgw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	ldfQLdHaovsSb9Rv0Y0O1echU1JbDGD1LZDqmO6d9xUOohQzX2eem8sg6Qu2TqvpBiEcoSVNxUOZ0L2VryVK6tpwKqDIQEKk4EukvheVCkX+vj6N39H2wbJyt7GTfz4EU73TrtRYOa/woZ/f5ZC+Lz11G8/yiUY178snHE8PMclzJqFyZQsGcmeSmhp+zr0rvUgXHiBNDu9A00tUPAMuXZ4g4m7r70K6eQbfQcdGtKnPItR5pLehZ6Bp8hovUkT7+ZeiNWVXo9DuCcfX+2s5FheCSM8Rwe9HK5CMoWeJ9j5jb9JnAXcaYT7TKJ4+XWDawrPA4Apyby99du1xoC4dIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JQ0Ar6uGUH7NJqr83n43Dz7XgVqZlUwTUY28fgwFhJnNgevya2a3Qa+OfUVhjkLdJhQgnvuEs+nu1QDxUpLVAadqvC5bgORj4X+y1bVcGirFS45iDmuW1u266sUWz8SsPidGuW42ifS+eYEwASEXexYncin60Jmxm0k70F3J/SlQthA3f0nALRTb+M8vbeBjvQOd/8Ve5uoW7JpMyOkyVpzs7pnWXwG7HbKpdGAMGSS7XYaTAHOXcHRJ2NP9mxwyv19x5IKIicgN3p1VK/Gj/hSkK6P09zJ3vS7UlQfZMrnYexhMeueY2Tb+6sx2malQ08uPTstrQX5ZcwG0kVkgatyrlUzxTAZTvvPMZRxJ2vJGfG931AqfvRCxDOU3Tj6/1ZJFiWvqFX7u3OW+5mOR35LdshMgXamlx9GxcZhyde3h4M8zh/bJ6OcaPwV48deOp3JVRNqWd+Ux3taI24gQPweGUc4GPQl/worNRFPxTUaUXhcwwVGEFUW9hKBBN0wyCQgzPdeEjWTg08NIaxuOeM+L8fAL2c9x5YNTnNyGPXKd9M0YBOzwbgxu98znCvxlpsbrR10vEkeaIt3o/sRLusNopc9RPai1unjlN207VbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8bd302-23f7-471d-f9c2-08de830bb6c1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 03:25:47.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKyPXtCZkumEsgtnYkzOWvFHZlLe19os1cimlGmwNsKUtqtVC2upu9o6TiYB8n7+ID/Hau269tmfUY/0oGzU7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=877 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160024
X-Proofpoint-GUID: f4WSi5L5Y9UtoI9FAO6J8i7W97XXvw4X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAyNCBTYWx0ZWRfXysm8BnIox/nr
 O1WJMTBz5vhaHqXRUbfEcrfV3mmdZrZzw483CZUTD1yfpZFvPyfK4ECAeZ7vacKXiOOqorlzGa2
 NVQB9Mx3O4hKbxqRsBFvZbQk9h89rm07L1P1mVVh7ih7s4Bfg/DP297OAIHlhDTtaN+Ul+BSbde
 6KMpG8A5TGCSYGjonA7vGWxDvOAB6W1L/EVsR5J8ru1H3SZrmFVBEjSNr2Syim0HuV2tBCjsAgH
 nzXzxMCK8tkEnFCfPATQyGEJyflMlQehOuKefRfD+2CsUKvqzaRj4dT1VQji2ofp2u+OMt1CCdy
 DLheENMjKsacWvHL8Rtayf0daJnDk/aOn9EuX1cWgNIYaRN8xDGZjLmjoWnSCBLkuImP5fxQLMg
 wzZWrNCDUqpySGaQBmiiI4ulJ6GAjG4FS5MYc7CTFIZRAeIvUrr+ozC6gMZqiLVrCOREJzBagRN
 3XtH1JIBj6fkD7/wyiAyGJgAE2347qeEG1/CYO20=
X-Authority-Analysis: v=2.4 cv=dJmrWeZb c=1 sm=1 tr=0 ts=69b7783f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=n8vI7UGPArJviPnbJcAA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12271
X-Proofpoint-ORIG-GUID: f4WSi5L5Y9UtoI9FAO6J8i7W97XXvw4X
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51B421C000C
X-Stat-Signature: fsqtt9nmfryd4ttuf6bsuf9h9tfcsqwm
X-HE-Tag: 1773631560-859869
X-HE-Meta: U2FsdGVkX1/I/wiQTIfUyeF99s4MGkaGys6Ni6hvdPyp+kxj6OaCMgM9Nzo7xvMGVrvzPz72mUzqTMpFPTPjPUJk1dsJnWF6lfalzYY/XSV/grdQ5Fxv0EMUUhBCUmFfommq3lg+lTwwah2uWAYbk0GZuYhSaLVYkdS+INOnUjTq8b+3i9SIQM5XiEPtmMNGKeFcJLQ3AJcxtMtrgwLx+7ocLIIPjtQcNP8R6Qm9BwcKEpKcueOxerwoOcnwk5B4SqB6qXHuwEFsTvIJsndm72T0lHPwJdz6dblU+AsdRntm7ESwCFd2oclnMmn81rDVAsmBLUHrsBLQ2PVhBfdIhHeSRePi1G4/Svads08/EH4aBBdryleWrjk6Zhxo8xqbQsjK7Cavr8zwUfkQKWdB/Uc7QV3Nv50BIhS6SiK9mmyodtTuvA6eJFb6FHKGtyys5QYrrdAvVfPAiEM+y61h8XwQKfNbhuKuhIWpH8o2AGJFshGetOrtoJv1p7t9q3bX4WQXcaFzAUbX9rrGrTvZg1YUxjF01G+pBaiAlA0I6WUGGne9qZ5Sy0hkBiOOIANxLZCotEPPolQMn+JlFXBZP2LZ7U4ky71eGk6p5N80TB/xmZ6horqIlm5YC8Z29lEvmmeHAcxaKPCV8lqWJts5Wa1rKJ7hQ+DP0TjZhhTE6PCliUpPDPBAzhL3eezZ6OVv7Ryk6avwrPhJQw1BZ1A8fTXmxh0rj9YjpbtaiETHVzsh3kQnqx5zJ5IW4wFpxTFCJelolsIAQFlH4xRz0S9YNrW+JwCW4Pc6kOmhGOUTYwLnl4fpcr2wcwfC/y98iBy33N7T7glRzxoIrfg2BaWP4fNYpU+Chj8SUFHwQ3g/6ajgPqmjL+2Q/TIjPeNgBZ4oI9BtjwqdsH6wvmMPKfNdFvnmf5WesL09rdZ6N2dCJHgGj5Q+g8r5/BlP5ojsN0PFSFWMLYd/Ze+wv/m8CNC
 U4z00QxH
 cpTWBJ5NKYxUraQQrU2aGQcACDDGvPrdtqWuwHTO1NWhYAAX5rJ1dvrqNPAxqNEoU4+Usmt04f2gAbTlbXlp58efp4kQzk8M5Y34Y1tB1gRFssHN3sNZ9TAfyVpyl6QHFhuWyXmHA7bc3akIae6/L98a6F460y6g8v4Vt8kQZr4N49gEgg3Ev/9IJCfX64h2oky4aLUSKg2kNETwMvJybqmRax5iQyqwV8mM3waiNSW/sWqT1/1sJRqqusLcqip37pFVoBePdksx7+NzykG8LjZmEzsyhjHm4UrrJNzllw0CXZ4MD0Z1aWuLaChFNz6D6tRw79r1iXKWCKYesYA+jhqJ13LE0S5NNHWACvY2hBD2aClSPL2YTMuARy4B5iBDwJ1dlbG7DsiewpYhK220vr5pP1TlzaB23Kz0JIw7CTG7xhrVnanBZuvYTdhFauHpKY76N3Wpm+fv+tlxVEonjZx6cKBuhA7quL4AdshYXHRv7a+vn1YD/+za9YVcvYRqBDik6s2VGGm6gTHpN8RlDR7gCoxVZB03ZQxcOzJwg/Oj4vWev3PVHTaCv0buMju3lukt5gcFY/ABA4dJuqzg2tyU6ANvFFyArCK9o4cTpzQLDe2sXSfUkyWFa3vsDxdfwQvPBbOxbT+PVzqX8mPCK0+F58czUMLbUaT09WhhAiI22W2C/Tra1FEBu4xLOHd9d3kiSutIc8pwV7Art/OAmXN0OmjAJ0wmBe8DVAAQ5oSIU9+XfkK6mtOJHhvqoVs6l/JFTxyRJm0mdZxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:25:56AM +0100, Vlastimil Babka (SUSE) wrote:
> Ming Lei has reported [1] a performance regression due to replacing cpu
> (partial) slabs with sheaves. With slub stats enabled, a large amount of
> slowpath allocations were observed. The affected system has 8 online
> NUMA nodes but only 2 have memory.
> 
> For sheaves to work effectively on given cpu, its NUMA node has to have
> struct node_barn allocated. Those are currently only allocated on nodes
> with memory (N_MEMORY) where kmem_cache_node also exist as the goal is
> to cache only node-local objects. But in order to have good performance
> on a memoryless node, we need its barn to exist and use sheaves to cache
> non-local objects (as no local objects can exist anyway).
> 
> Therefore change the implementation to allocate barns on all online
> nodes, tracked in a new nodemask slab_barn_nodes. Also add a cpu hotplug
> callback as that's when a memoryless node can become online.
> 
> Change rcu_sheaf->node assignment to numa_node_id() so it's returned to
> the barn of the local cpu's (potentially memoryless) node, and not to
> the nearest node with memory anymore.
> 
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

