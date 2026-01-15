Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A8ED46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B4D6B00E1; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4DB6B00E2; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BBE6B00E3; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 376576B00DD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 018CE140463
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:50 +0000 (UTC)
X-FDA: 84335208342.06.0F3211F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 71C43180013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fEApKMW7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MCFoT7RH;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49KlqTIjKW7nYrCJ/gvPetkdwhTp+AINiY1XW6mSQWw=;
	b=NAqBnIE5Kj6K3m1p41Tc3M6AUxslmteFEwtTQTH97iH8B+cw30BqqBO3O6EqV3LMJv3U8v
	nYOL0TRXnyXKfgf4maX8hfVB4lbKiSgKL0J3Xjd9uvmEPFFJMMweHCAvoUAffV/KSpiNQ2
	BJVxqV7s7sPyeNpPvcnqF186B2wYyvI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fEApKMW7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MCFoT7RH;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505867; a=rsa-sha256;
	cv=pass;
	b=PYGBm2/oeZmbeUOwUlfDxDOWmqxIPBRZCaYWbdTDPMaVd/M3YMzFCcEB7QXsoOVt6K0HcA
	NK2Hno7CFklFfqeF5f12ddEnDvaTA+YetEmQSlZ0bDab8FsJH8rXQvdi+7gwNlr7GJQ2+Z
	Key8qFp75mbfIHeQmWcFwSCNa3oJe8Y=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FDjvLC2418953;
	Thu, 15 Jan 2026 19:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=49KlqTIjKW7nYrCJ/gvPetkdwhTp+AINiY1XW6mSQWw=; b=
	fEApKMW7bhviwqrV5Mc9v560u7E53HgRwK62dv6kmOQ4PgCyMPUPOHNubZ4TbnX8
	qzH+IHUAkyg89liBfrJY+4hMji7YzMrCvGbH0UKuGxt6S/vWemtj0h0aqDxC1heZ
	KnISYLhwKPljqoNw4Kpn5Jegf54doy1yYzR1940N1seX7pJZKG+eobttkphbjIx3
	jqAzmiDxQ5MfwbQW8OcAYu7Ur78eeTwiNvbpb3yfKSXG8fiCD7PB3UerPciELvBn
	WU67ZjWeYjLmZ07BEoS5R0hpymfvQNVz1ZUFuvj6C+yZRt6Q/BnasZROcWq5xJOE
	6kSj/I7Qsh/pvNuaZJOcOQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre40j1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI54uw000547;
	Thu, 15 Jan 2026 19:37:35 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bpurp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJcPswGkV0FzEMb83DmK4zvrb7CvkTwavC3Tcg+a7UsOM4hlWanMIG5TKW7aX9f18EntnX85GI7U1HU9C62Kk+PqHt2jbx0ZT+ra5ONqbz6Xr0gqbdMQ2AsCgr/sC3RxgxCbi+gFZWYFyyV/0N1YIUoJUp23L8dBOiTk6PE+uZ2eTY8EuyJOtJ+y5vL3xSOox0iB6Ccqetdurhjk2Tus40Jg9K5vtNG1+fuldIK7pqLVDm05ALl7IIgbMaf/wPusALmpoW6HgsNxQRO3XrJeCRQ+k6MHVO11XmQVEz6OD3DG3d3H1r4ZfC/G5l0jwIM2HNBejC/5b/u3Bamf/+kW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49KlqTIjKW7nYrCJ/gvPetkdwhTp+AINiY1XW6mSQWw=;
 b=cAYNOGS7Jqgbpw9d+nvs7p1ogMBSlFp37J8+bTBjLcx+/ogLw1PTPLgE++3nwW6Cij5D7/3mhUYKyGpyXm36vQF3t2Zk4+v3XvCT/hlKiE555OJ/k0abAOIwDKPSdsSjw5LN8wpMHsS9NAN9XDO70qrefJVIcTQ2oxivrN3XuSylyHAH9VJfwf72yItq06JWvyhTw/hWt9dma0KZUF9bRDqULbp+YxrLGNqN3CJYNva0WJ3Q+ioHW6MrTmXEPsIT2R73UtUHQZc3BSFWgBlkhb813qEHx33s7zJqUv0oMm2qeP8fHPr/uKBaBv+B8BLEklKPg1JjaV/+G4xXTgdyGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49KlqTIjKW7nYrCJ/gvPetkdwhTp+AINiY1XW6mSQWw=;
 b=MCFoT7RHGmm1XvVw6bw9uRRVmrxkfyPLYHGxphDtuuDUfNUM+ha89sAg/DWM6+wG+JBT9s+yBSQUHA+h65Chv8mhecWAJg1EH+t2ag8wBiPamBMR/Z/tgBuTsNaAWSLWxqgdxhtifVvNTI3Qko7RKCxvd78T32w6Vtjhzf+10mA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:31 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:31 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 15/28] maple_tree: Add gap support, slot and pivot sizes for maple copy
Date: Thu, 15 Jan 2026 14:36:34 -0500
Message-ID: <20260115193647.1695937-16-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0322.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cccbff3-9242-4554-8542-08de546d865f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?la+5BeyYC0VBnh3VWFZvc5TtQPzAjs3kYEulzDXm4LGt5xPWJSokdskdr8aP?=
 =?us-ascii?Q?VwE5CJnsTs024z/AqeP4Dp5utYZo0E4fTbsLM2vnC37KE1S4wXFzLvhXw25q?=
 =?us-ascii?Q?t9CKG1tutkvdGuCZDkLU79IOaTASOlI8Aq1u9Eu2x/aADTAQrrUrNqLnChJs?=
 =?us-ascii?Q?Arys498o3GJDoQ6a7wy07sled4p4m+BtH0DbK2m1NKbmlVVJH3hKbtbIa0SE?=
 =?us-ascii?Q?Z4k/rUGoa48YKoJu27E/bqg9emlp5vIzcTRpu9OGCt/pMSOcr8GumD1gYdwN?=
 =?us-ascii?Q?CIigOX5M060T1zvFX/4nXHvNurVrXXQUcZ181RMckgiSPJlgYvH/JPlaw3b6?=
 =?us-ascii?Q?kpYTpF2nA/rd3X+nsE391IRU+EFJERssHm1JooCVK+RIrNVWPlopHov6/eIe?=
 =?us-ascii?Q?hiN9EQT+T9qJCFAixreHhKZ/vkIvNuKZRKntcIs59W8vc7/EW1HwzaFA7xQ+?=
 =?us-ascii?Q?HRAPcQdJJIxVCljjDH6clNqqGLt1l1pKNqbn0mVxFmiWRmvBWOJQMiENUGCS?=
 =?us-ascii?Q?owt8qr5e2FkYo3OZiTm+ZYtRFGCLbQ33jevuFWxKVO/wpaefABbOBDsPXC3r?=
 =?us-ascii?Q?U1TKACGpIwo+8Kp5QMzum6BkzaMO0mP7ibfKqteNOHTL2FzTxShOjeuD7E/D?=
 =?us-ascii?Q?1PoUuSta8kKFvCjokjdrDMymOG+yypGU19gW8CPyciz00YLCOmEozcvOHM1H?=
 =?us-ascii?Q?3ljqWyWoKiMwy3ZvlO152z8kCiur9bh2L4mpiCEd3I6lmt++vhrddtg2REoY?=
 =?us-ascii?Q?/lyIxuVejWZXnXKAwWgrxiDF3CJ/+gc77ZW3wL1zYrPvhRGQsgykLYGCXaho?=
 =?us-ascii?Q?vzNgzGbRqCx7mXHqVPmjJN+F86KVrbwN5RtHj6fmwZh+m5ioomlETqwP287A?=
 =?us-ascii?Q?kz6fgpVRMU5yx77eB2rOPt2pr/KzDEx4LxhvJ3ndCO66qzqXZ/ATK6avC+Mo?=
 =?us-ascii?Q?vkEvgGqCoi4NLLke1cujiv3n360203aZKedwQxodDrtGq8hbhqHCU/fUC7zU?=
 =?us-ascii?Q?gOehUtKiY81ylJljMLi1H5flfD8UozC5ln0LFIsljTIH/F7yo2E70ZfZjtw9?=
 =?us-ascii?Q?gMVzuGUCMAeSlNTGZqS8zu2kCXprEomSOkl2dNDs4G08c6fXX16aUmDZ/S2C?=
 =?us-ascii?Q?wb2zCDwZKlwhHc7pFlGq9WKNBBTk1FvqBt1vC9EPy5LcPVDQFf9RCs44yBo5?=
 =?us-ascii?Q?q4EqCZwN8CycpK+++krHU76lKw0Sf+/YvV4J2dWZ13nb3eLGgR9TE2Gpo16B?=
 =?us-ascii?Q?DeaqFdC6ObckasB0zywA5+gNUiF++HYmFxfNDAtKm4/5euulByPDGmJPckLt?=
 =?us-ascii?Q?Yxwc2AVvsAZ3BHgIn1+5bA2RBTeOpuMVs8+mh6HGqhIlklJVgO+qGv0hgjhZ?=
 =?us-ascii?Q?UkJzQ9pzk4CSkldxg+B4CISne4iSsMZ1IgKTvaAvnAW2qlSTlwkjS1GptAOh?=
 =?us-ascii?Q?FltgJc30lXLMAaTJOk1KGKItrWorVX7/TTfGx5s6uxPDLuxhcvVYbfRVRjyC?=
 =?us-ascii?Q?5TEpGQcUcwJ64Q7YTAW020RItO9wdMPYTDVliX5RJLHyMn8coTLNZ0wqhEEm?=
 =?us-ascii?Q?Y3lTeG9PDmHJ52yW6Hw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3lkQJex7wc680ekXCbmeBELP+dqsuKJ4RzBsMWCfeV3Xam5EaN5cy3iyJTt+?=
 =?us-ascii?Q?3Us4ah4Af8JN24f4w/8ftPmkbwpPidp55AZC9h7xt0IxTiWbnUPSOYgaVloP?=
 =?us-ascii?Q?jDbybYysAP4mhtzQmJCDJqgMOUYJCOKRZfNHsQR+tkvbNFz/Qp+TBH0+d6OM?=
 =?us-ascii?Q?BVMrKuaEcqKhNnQble5TH0+J01BMYnboGU0piufeN1a8veya7wIZ3hvu2Vvu?=
 =?us-ascii?Q?MiLUg+hfZlcHTVNH+KI2I1BacRDdE9UEvzJsnHm6vXvQEMzEPX1TLAxCq1nK?=
 =?us-ascii?Q?xgoYbJTs5et7ShDu0BZ9d3yqkoGXpeC0t+kFWBGtBH0XZG3tou9QFcX+sG96?=
 =?us-ascii?Q?KX2ahSgePOLpvY6pK0yupcFEKNfJy8K/jsrpKaVprFvGtTdWJuxD0lLBmm/V?=
 =?us-ascii?Q?UlsKSKsaBygouH0kxYT2cY+lbcjmo5iCdr43KR5N5AntF9h7AAiMtcCEzy1B?=
 =?us-ascii?Q?TV7pkVTHYGdSsEseEDQz+pv9+5KyyJ+WnlHQDKSDZupD4gk3CeCiEBXEhR+W?=
 =?us-ascii?Q?uB/2pYU37wl8txH2qIlVhrYSVO/843KinHJam6RVV0vJeIu2hPfRw9m0MXSJ?=
 =?us-ascii?Q?E3PzklVNNR1bXyKoPnlymDOnbkqt0CDKkrJnsU0P0VbUY045SZrl8Dii+O9p?=
 =?us-ascii?Q?OH72Q+H93in3jnrj3FjTVoPbNrod6eHT1Cr4A4W3RBPxjyOs0BzeSkQ3L+Ht?=
 =?us-ascii?Q?sy7JwPpakVOW1GYj6/KtQtF8iJ1rbRzpAoTT8Ur/74y+9d7bd3dS3KXRgCo+?=
 =?us-ascii?Q?TqQEXZNenUwPqTvNzdjoq6cZpVSEJUoeoTUllPiiOSQa9efrasvcu+60Gj7q?=
 =?us-ascii?Q?T0s7GsC0YbkI4+PPPCPIfGCEjzFlIGwVGuPFf7jeHRk1G+tsHqxLyc3R2fim?=
 =?us-ascii?Q?FOqzmuHdZ2BgCvrLXWI7lDsv1LteVBSigpxn5H7ce7yLQz65MJzrLKDujL0K?=
 =?us-ascii?Q?jRpKln56s8+caxU3vqvkOM4qvP9MOIpfGff5+6vSDv5QQKRcDpJwrwxRFWxb?=
 =?us-ascii?Q?bwpSso0rsbtJl7FSFHXO9vn9qW1Xe1yJvhHKbTOVPWt8AYlUrZMDNh0Z6w0B?=
 =?us-ascii?Q?m0U83i53bUVPyXA5zq6ZgDiFz1o+TnvDCLX0Pnc+Gbl+zNVt0/KZinDvKg/E?=
 =?us-ascii?Q?DMur8mJas5MYAc2aKtwKYCOgPzfIsGl+6MWPQLEFP+ngubW1n16eNaI1+gL5?=
 =?us-ascii?Q?uJ5B8XG2Yr+aSAKUNBOq/6iYtoWSNe+9JZj1fUAZrS+CqJlDJKaueKhMICpY?=
 =?us-ascii?Q?Up48dt/lq2xTUOI5gQPyqp1IPL9v0oJV60QbhWJ4BiDorxhFyQQMTU71UJvN?=
 =?us-ascii?Q?jEuU7zxr9WU3Xsbe0A0Ii/MsCfFzhXIUIDl0Wp5E5XZQAWtj6FOhLXWqkRff?=
 =?us-ascii?Q?voFuI53EKmhIIzK0lA4wzOuQcFYMEuewta68SeO4iOCxe4IgNhh3r6Qv+AP4?=
 =?us-ascii?Q?hVUmsnjMGanYAvKLC3VI6Bi951gupi+KgtV6ei6fMyGzUrDnpj8hLrPROFyD?=
 =?us-ascii?Q?9YQVy/fxNcmWb55ZAyWTkYmfhcHf/KtzyZrrd8rbUIluf2A/V4zK0KsoeWxF?=
 =?us-ascii?Q?eW1QgUUNpcpqBxy+D6HDn42HCz4MYwxzkH3KgTvplDbIykkwNqLpEsJoFMkD?=
 =?us-ascii?Q?D8LB+GEiYSUvBHRWhvXT7QnItezXiTDOCT6/ZZnV7p/wGmcPV35ieP7oS73F?=
 =?us-ascii?Q?Y8qL2j+ewJlWG4rJZgQAQn+ZMz3btCDh6QWyzeQM3uPQs4GPMvmdnJU9MFrl?=
 =?us-ascii?Q?XDlR3nYtmQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HkMwJOtcJJb5vYgfr9eWACQmovnBVS9O8TaNGhDtKQde9WTxPWxWqAHq0LGt2IMCJ7gDjdmSsx3z3XhqBS4dHWazRDy9AmDKBh53oBRHmKrBWlpSbcfbN2Mf8H/DqoSYIOqs+aUTAgPJHEgSk+cr8SGXqT1TddrUjR1xqMmobJOIp55jKsna1cs+8/Lj23nd9OvxxztNu+ZnVLptlSZX2YMeSyC84aidZcwEM+pOzJN7RnC25J9OSXWujEXl7gZnK99w5isznxDsVFpxh/XLAz+hMKY5QsUv0a5KuAxtfxUttAY7HMfY8rh7gZDLjNJCmBatm2Q1RpeUGND9oWToXgwu0S1FuYjkiDiBgoEQkRb4tFgSlGHmzhPWXIyzs2XzlfQt9jtYHmCpHfda7A9PcZoak2q2/1d979TZ/obQCfhwb6RAWI5OFllN0DuPPB4HLpaWvdPy3+G1E9eU9fDCs5F/61CY19fjWhVfz2SGcCuF5bDxH5XmsjO9B5fOlRIaP2eMD7Vzb5D+nerOJRoAN666vu6WKr/PVZsUliqTZPE7Ey4umrL4y90m7aksof4fO6uVopts/deuVcaCjqaYvTtUDtpWMB5CxU6FTS/hXJ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cccbff3-9242-4554-8542-08de546d865f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:31.7055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTXUeiPKAiMx3Vt4QlywdOSjWgl4CUkIuBvsuwRwqascYsQfNr4nzwHkmuo6t1C1WkWWBsSSvvr05ExF6SZQRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Proofpoint-ORIG-GUID: pJ7BpyjtFJoDMKr07dMSwf8jVDW8XRJ5
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=69694200 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=WDoy55lLVV0zyn05J78A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX05gUemIe+32D
 OAZRJ8/0ZHtaKZzgLaHfmD0Mo6ldFFL4BsNSBQmJOFG6k89mkvZ/3J0bfsaHsTyFMxtU4fQmMjD
 uVjn7VHX1klZVLbh9Fhlq06/O0kT4CC5ntjVBt74C8kRkXoTXjidLLgYT4x//XUWWIu5anlI5Dt
 hIe2Emdk40JIzjbzW1h1eBUnEUwbEUDCz44Beh9/4Vhs4llwvn8xwr8d5WRHw8+uMHccyFsLPER
 CJHqFlIdNQ/hSn///fS6Q3gbJ4+8qFGmWuf7FUBPg8Cvj3kyY0y6ZmjcWr+99q9yi5xZeLq5q69
 sPkvc7HoISPV5snPM1Ney+cxw/6s6RWGejRKZY2dw299eqLQOC1Ye8znCcjW++0ohNh/veNeeET
 OpOe2omo8TGYGPOyj3p3piT0NF9bAJDYldX5Ck/1Ty2kHZgyIAAH1gY3XZENEAzmE0zCb6hTclJ
 1LaxG50vI8rY/3nleFg==
X-Proofpoint-GUID: pJ7BpyjtFJoDMKr07dMSwf8jVDW8XRJ5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 71C43180013
X-Stat-Signature: tx4fb7jkk1u9r6nehn8tkk5rourwwfau
X-HE-Tag: 1768505867-429894
X-HE-Meta: U2FsdGVkX18r7WvuNGp+7mWF2+PCtS7fhkbPb+QMEa8X/D65jGtS9AyjOe1EnxUbfmU5e6WgZxjjAhunAKJqWiUEjilVI5S2wmWgIrPfxHVMfX9qb1Oghqbj3Rh/NUb53uJlXyd+DCHAhdIDZa1g+9N5TSYlzLMZ3C6D/ylGEUNk/2k0GgEaDVIOu9vjrEh+QwBQbzSbtWTzFWGDadBQcHCDrB2WHiBlk6MZ8EDDbxDtpGWmtokMPpTjLDz3yrPWzP2hZ+A3p9xH7vCkLtZhstZQjVfD7MUb32vjZYYDtAwddO0K+DEDxxovWrdTQOMzUlWF1S4pnyuzpL++zYiiCZTvUx/XKuf6ShCZm2heGcW/0mIgt5fFJRa8kwK3E7q4z8KlqtODk7xuxA2RMc+V9Ls+m6nJm+YOG3P41eQKZL8JamWMV5aYYyeljeaif8UQwCyv5sGj/q4k+D8R7QjoaCkaaDHlIyMudVTdaasWrY/IjOEtc6PHBeDTNZbdrvRoq6NaqIsjI4rPXP5ihIFm9v2GFuUYEkWlnjHNzXyLA4YwlGyZg6J+99wnzAget6FMyfNLDGKNZ2VynvJMoj206BDZakJhRbiVYfbaHecxCYJ33nhsu1/4eepfNQJDe6JWj5hjtSowyCWpDPvDXUyCYzXFaO8xtn7O5QC41NLvB8QeaSscuQVIkGO8bAkm5/UBycaErGxxkBupNXVgU9fleOKAkTJWJF4TxBBb71jn5BIqLV/LtpxbOOvZnslQi/G5qK0UUsv56T68nqovuWy8K7rhDP3Y/4fkO/P/SICOIVnHSU3PHPZZubIUN40vut28+ZEB7OIjPFa52Nyf5Duat/3H2vk0uDaUMnY2L/bRkiA4mWFwMUmtHNXuY7+y5ycS0jl9Wyx0GEhJNwHDin7JyyJXqH74Tla9lVZp4e2e2iE8eOnrH4sK2C9/+T8IMG0F5Kl3Bd8T0w1LuHyMkJ7
 Q6R8tK7x
 eyuz4tqAHoGr0RxacSJdi7wI6SY4pS+6BAFyUuZy4t5dDIcrgCs0EB4TA7mriYpLfYujx3tKVkLv/PblgmhhSevx5bUzCnyjbeY5bzJoaHhLSFWb3gskLxLryGN2Xw8yk9npPkJHWJLOBNl3adOIPWq4ynUyTP+DiULRidycRtOPIajw6h8wk/MtagIfl49J64Ai91oESJJRH5EURh7/XwfooFPT3dxUwwHcWOAJ7qOUB/vnaS5gYG/bQ1f+FcqaEAejLNz5H0d1dts+8qM1sYLY2aupJR0CmQx1LrHa/3vfSGy0Vwzo2waxVJtC1njeaODHftLcfq40YIeUWPUHOTRfHsSrlqImhgptSCl1PVJBSN4P976nwBYOWav8mq9qLmnwO88KWZwa4QdOOcU3Ld018SytWD4wx4zUmCtuR9/fvOfIYL+jhj7fWrfOpBC1S3zecoGZZ0NAv6W8mKOXz4eyWsVVLXMgY1hZtrDP0mIELwxm6NFE0bvlDiyXhnQiK0UuJL+3YMSt27VoGdB2pPCr3/oZ++3ezabcJss31E8yfk7Xuq8xC3gQQk0dzfKs89mSpXxPCgeAoQNM4rQGS36cKktmJO9IGKxwSTiCzS1Gjxi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add plumbing work for using maple copy as a normal node for a source of
copy operations.  This is needed later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h | 1 +
 lib/maple_tree.c           | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e99e16ac1c6da..db6a02788902a 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -165,6 +165,7 @@ struct maple_copy {
 	} src[4];
 	/* Simulated node */
 	void __rcu *slot[3];
+	unsigned long gap[3];
 	unsigned long min;
 	union {
 		unsigned long pivot[3];
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 366202dc22343..a9d4f3ef8e888 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -101,6 +101,7 @@ static const unsigned long mt_max[] = {
 	[maple_leaf_64]		= ULONG_MAX,
 	[maple_range_64]	= ULONG_MAX,
 	[maple_arange_64]	= ULONG_MAX,
+	[maple_copy]		= ULONG_MAX,
 };
 #define mt_node_max(x) mt_max[mte_node_type(x)]
 #endif
@@ -110,6 +111,7 @@ static const unsigned char mt_slots[] = {
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS,
+	[maple_copy]		= 3,
 };
 #define mt_slot_count(x) mt_slots[mte_node_type(x)]
 
@@ -118,6 +120,7 @@ static const unsigned char mt_pivots[] = {
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS - 1,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS - 1,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS - 1,
+	[maple_copy]		= 3,
 };
 #define mt_pivot_count(x) mt_pivots[mte_node_type(x)]
 
@@ -126,6 +129,7 @@ static const unsigned char mt_min_slots[] = {
 	[maple_leaf_64]		= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_range_64]	= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_arange_64]	= (MAPLE_ARANGE64_SLOTS / 2) - 1,
+	[maple_copy]		= 1, /* Should never be used */
 };
 #define mt_min_slot_count(x) mt_min_slots[mte_node_type(x)]
 
@@ -627,6 +631,7 @@ static inline unsigned long *ma_gaps(struct maple_node *node,
 	case maple_arange_64:
 		return node->ma64.gap;
 	case maple_copy:
+		return node->cp.gap;
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
-- 
2.47.3


