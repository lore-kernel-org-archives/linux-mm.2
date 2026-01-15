Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C810D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D606B00BE; Thu, 15 Jan 2026 14:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680266B00BF; Thu, 15 Jan 2026 14:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8AD6B00C0; Thu, 15 Jan 2026 14:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A19D6B00BE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C76781A0447
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:17 +0000 (UTC)
X-FDA: 84335206914.12.BC0488A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F02480005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ofbtQADi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CAc6tQ2v;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzXAA0MEA1ZL+mClB4otrwtRKeL8YMgDPMK6HBkA/Qg=;
	b=HSWEWPrXLV9TzGeVJBEl++ohuEHhgm7Q2cto2rvgiUxTUAQ4+i4fSKYvtbTJrrPZB4k1CD
	1L+ROQG5s2MmRXWql1n15swuGONnUhEsS/KARg4OflwdkPOfKtr84ttHQOVhnC5DTX5Xva
	WrR/qXTDFdFbrOlSZ92+hb0RoAU4Qa4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ofbtQADi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CAc6tQ2v;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505834; a=rsa-sha256;
	cv=pass;
	b=s7Ihv13S0VVMVjSDGc/NaftdbrXWkHCoQ4aXkDKE55oLLpV/cb5veTKay5Q86OrBzyDBuG
	mneK/6+kw0kIWD+XMk1lPASss1xy9CcQX0vAH4bylMUL4ChF7Lsplp9QNx4NFgYltMJD8P
	vFh7wGGACJ3ghjeBEcGBCANaQ8FZJJs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFSXno2753320;
	Thu, 15 Jan 2026 19:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tzXAA0MEA1ZL+mClB4otrwtRKeL8YMgDPMK6HBkA/Qg=; b=
	ofbtQADiKa36UGzFT77iwvb74NjAlH0xbUGq92Wz92cFBaeYbyrVChSCdVU3VRm6
	uCelAgbn7j0e4Ak4A0M1bmbyGsRl64ZYtgPlcOLdFGawMjjRh/Q3jojkhOizW6d1
	6yDjwuhB6KzHYlfvFtWy3GrrNQInLa8hkAKM0BYQ2KchhvCkBX13snScuBq+VNuv
	GKuhcWLtIneDukGP79UEY8IL6ZfSJ1DhOod/OrbfBrHSD/S6XRw2dVV0BRfNuyWO
	vNsvDmFUMZgqQ2e+paOwgNs+NXW7BRHpevfb+7fNVoQWWYwu2aTz3bWv5JGAnmlb
	Iga7AThuTMQHdXtKqWB3HA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrgdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJP288004237;
	Thu, 15 Jan 2026 19:37:04 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011063.outbound.protection.outlook.com [40.107.208.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngtxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zaq6lgVHGkH+WjvUHYBaoU5eGlp61xEmiNv5GcsvP5HjxZJhOOHjmVMm6Ra6aWPG+yx9SFAzIH1PLEsLzOxmWjZ+ls4X2nzqi5+Ye26xeJs/oNAlXHOx3f713wBSyvdgTI472U7IggZmw5dR3CDy3p4wpMropn4qFhe1Ci7+PEj1MMfh5J8pzDvPvrhfn6ZB7FaCQoW4Ndq37grkHFxIgAB3GJytE0VV9Bu/xR7oTdMvCVJOrblabOoqO7443eZbgmxBj4hnZrNPd3gsAUH0G0tPUCjCT59ahkHFibdOv3kcwnYI0KaqcMHO7p7PD9xN91zgUf77+ed455uCeSiSgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzXAA0MEA1ZL+mClB4otrwtRKeL8YMgDPMK6HBkA/Qg=;
 b=BgrPARq4/tHdxSNiVkOzKk1efyPjp9dSH6li1kIanrnZJIaWamPGo8N84Otkg2a7z1c3qheiADGKLYf1h0DPCptBm/Rggxnhyg66VdBO7kKvMqPKGV/ncvQZR86dVAzUIyRgqzdT3SX+MiyfesHREAZKk9aWdoYksbtsey/xo3L2K583yd61qlz4s3d42wD5KBEU9grQlE0/DOB5k69ETVNZg+wYOvo+bNbsaHDCakY35KEFim0jNRIoJiJW8ZqZmm0lQe5cmghVPrU/cRPE1cm6pINZ22E+N9iGc9qU6i6Zp8zoVa6uIIc8gNo70GXEiamCdK1aBwBfmI+aJ+3JNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzXAA0MEA1ZL+mClB4otrwtRKeL8YMgDPMK6HBkA/Qg=;
 b=CAc6tQ2vuwYjwsA0VaH4lz08szfkiF+N/WP48s7gGEu7vLBd2gld7bgOQFPy+7Yxvu4lmgbCXzEaUcOhfmwGK233ooxP5ZmPjZs2FB7tkucmiTh052foEKIOY8C2FqjhjiBJWou1HXX49DQSnfzVJYq1iUyeHlcFp71tmK995DE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:37:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:00 +0000
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
Subject: [PATCH 02/28] maple_tree: Extract use of big node from mas_wr_spanning_store()
Date: Thu, 15 Jan 2026 14:36:21 -0500
Message-ID: <20260115193647.1695937-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0071.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: 5557d114-8bf6-4a3e-fef7-08de546d73fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R4zO+COJlwbkqQON06nahznjwwkrjgPBklA33fIn/VGemGUO2B63qJbb3Sgr?=
 =?us-ascii?Q?kXAeQiM3KziwOTPLo3cI7KFi1kulqAcuVgCqnDyxgoR39C3yPRV2UMBxl2Bp?=
 =?us-ascii?Q?ke0KA3JFYhy5MAKyn9SLBGLYtc8me+uD22kCDUnsKPxQAzsnN1wx55LDpGD4?=
 =?us-ascii?Q?kOoGenBvuRUJQuk7rTJVnbd5LkIkC3PPI/Spi7dUFRsjjGDDefNndeHA4llf?=
 =?us-ascii?Q?h5L00cNC+VWntpckohzLhQAFXtTp2l+WoQ3xgwwxodULotRyLbFkIOb4W6XJ?=
 =?us-ascii?Q?5d2IlQ4xjyjR+2v0Em1blC6Nwhv/apwfyOSdWn3kS0650MmXCo/2tAKboCfB?=
 =?us-ascii?Q?au97LL/R9G9+dv1DNWFzRRdJHcPQ7i6wSKEICpCk0zNLLyqEBzDwTRYIUAJ2?=
 =?us-ascii?Q?QpH8LdXItCbfFcOR0oeZ9SEAg2MQ3brIg1Ld3K7FhU0s12Jpta2+1oNOytjr?=
 =?us-ascii?Q?r5BQBKUkBzO71Uls7vxTarlMl4fpim6WZ34a2AvL5r43coreR9h+6DBxB6GY?=
 =?us-ascii?Q?20hkRXtggpIVforMeHZMI6SbeprToi8UHyNWaFIivQO3oqXAZ5GzalGOp3sM?=
 =?us-ascii?Q?cgZFtJFd3Z6CIlT3LezG4bCc+7nqPKpOgECQUpQsFmHi3R/8FtQTsm2qnxTp?=
 =?us-ascii?Q?GJ0rxxWKhjmc0AUQ3ivivea8R4dw0D1QkRm9kRNBOqI7fFpKcteppNn3YUcj?=
 =?us-ascii?Q?fzldM/lTYfPxPJg8DRMkbGeN2PLeXE0ogNlpeaqZcUbiZ7tnFbDLvVoN2ehi?=
 =?us-ascii?Q?u/d4bgi9+e8OIlfMQT+bK2I5AEbHQQBpYGDpSWUL8CVK7nV1BQthFeC2hpih?=
 =?us-ascii?Q?+GnfVr5pcvzNrKxB4RnKVyKCgZTkBuSixbFS25ly2DhdYe6xSJ4X0F6cA61x?=
 =?us-ascii?Q?oa5fWRduJNQaHJkwcJeXV4VQ+naENBWOZpdaoW6QzZOVX3VvvPaQh0Gj0szg?=
 =?us-ascii?Q?C73SALXtA2+VTfvb0/mifkd31EKQex7C3quSQK/9w+QewXMmpox+GhNhlFhf?=
 =?us-ascii?Q?zGQ3WgkQVf6cEft26eNfHgnwZYhXhi6tIQBCfvTPxiEfvlztMWEGIV7OJ6s4?=
 =?us-ascii?Q?TMFSv7fHvCbE82/ww2eZ6X06LVU+aBE89uOrGXCvJXACzyZyGu0l9wmp0dQf?=
 =?us-ascii?Q?12OwraL6NNPeIvt9efyddOL/YFsZ/OYsTEI7hP5fOe7eTghjLxjYWguczV1v?=
 =?us-ascii?Q?zCR0UvnhvllLLo5jTJ3Ww8zGF/8Qx8cY6SEOHsI4CJt5mxFdXKXkifcL/Ken?=
 =?us-ascii?Q?60/e+iBGLBEnOltxzf0KCif8b3q5H+zRnblfAM5LnK9P8JFj9wwG4NeKyL0j?=
 =?us-ascii?Q?zkhWnrRgQha9g8SfXC6wfYuHqS+Ap6bDUG8q4MFpX2j9jxcGo+Wvt6wAOqh2?=
 =?us-ascii?Q?o087CHFekW8JbIrw53yL4q7pXeawD0Xoy/6YXVOx2tJr2trYonVA905PxcTK?=
 =?us-ascii?Q?TjrdC1lZpFOs2dpv1a00NiPRB8kasNFeZM/gPTu9RAXhcYt5vgsdZyt0MWr9?=
 =?us-ascii?Q?oWcyJ3w3IwqhZXk3KhwcZxTENl4YNJ5v03gdNux6eCsL62B+4ufdvwUYiiRl?=
 =?us-ascii?Q?oMtT4guGYmcGchpZhTc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FXR23liav2prJKQT44FgdvW4hfl9gqjmUaT8qOPtfQ/XtRPIVO3bE+uI6QPF?=
 =?us-ascii?Q?DcVmu+OW58PMJGV0YlF5/3e6I0YYgMdqqiz4BAegDkcjYA3dzFE85NtevC0f?=
 =?us-ascii?Q?OhuqGObRrEtXyuFV2i2nty4lrDh9O3kfmXE7EwGQg+8ZxlWsTZx6bBkKZcmi?=
 =?us-ascii?Q?TA2bp/3yh8bGemQqSQ8T7/t734Ds+nN/q93G2H2vBqb49vxLBdhUrU4ikAGM?=
 =?us-ascii?Q?kDobgXCSd5PdWlZrDlediRsNWGXG/22ohJdNRJntx5FCjlM9+6IVE7ck4lSV?=
 =?us-ascii?Q?9su+QaKfy2AQc9TaMXnZOT7qBOVuK7E/KD4oSjhfFa9SWtg5YSfQPeM0e3SL?=
 =?us-ascii?Q?1pLpnByQx0aw9wtALHZp0jvd8SSIUPB2fJGeh2fYh3rNvGfzV/cG6pkEblkd?=
 =?us-ascii?Q?Wj+m5xspU4UCYwonyL95HfmVXaPH7gweuiRYwosa6MaZaswWl+mWuKAVo5l8?=
 =?us-ascii?Q?qb6b8rKV/p65DNU2xNkUKlaIXZuyLXjDyFnmHEUo7JnlEE0MqCs54XWSuNPo?=
 =?us-ascii?Q?2Kwi8KBgkjU6brZY5EKaGFfbiTAgHoQdOz2i/iLX3CLBIwG3fDDLxV/zYSgq?=
 =?us-ascii?Q?I1tFleO3jzq7MUPBnVhzWqcrb4WlaEx8WzWedsfWpzY/FMfk1a1dBa5f8uXe?=
 =?us-ascii?Q?zSSX9fJVC2h4wM1Cz0FP7LE8vaU9VmkTaK5AcNNRFdJBgGQrUYI34m2LqMbM?=
 =?us-ascii?Q?UA5u2sDuAkmNihnrixkkHg48ec9k78FuBGkGtFdSK0tmju9w1qyBNhRC994S?=
 =?us-ascii?Q?Vdz4plMLwPZOP9vWu9Q/NHzCLLnY77PzexiigJ1YGDeLJY0vITUD1I6dMc4w?=
 =?us-ascii?Q?AoG9UusYriy+iWPoWcJwI4PUnIwiaQkyZovbC6Yuq0fbOacb3Rf1M7N9Dzcn?=
 =?us-ascii?Q?p213v0b2nwTJ9dgcQ7AHoQJqMJgjjMAKi9xX83AsWK4dJ4V8rh7NfIrHicuu?=
 =?us-ascii?Q?49UK5bWVjC+kNOvfbuY5jqX/wqjzZrkJA2V/0YI8ZPd2Rd5rHov8o8LRjWk9?=
 =?us-ascii?Q?nt2OayolVcwdYRTd9JLKnSjfkxka81VSquztSaAYQ/o1bfp/taOALcF1F3GH?=
 =?us-ascii?Q?xWz9uJe4xNejd+znfzdtaB6NdYMA7OpWE8ShxvOhIasrj8W9SaBUEbQUhok1?=
 =?us-ascii?Q?mU7TUHyyc7+LfT8m/+MShDJYsOWwFpRi6jD7inJD8H+XfH8m+WcQCvzJS69E?=
 =?us-ascii?Q?t2aoBFwX5CmhjXpYm2ZCZ1Kskv7VX0I3prg/JxwrxZjN1wRyHdjeH5r/zGyI?=
 =?us-ascii?Q?BFX7c6jk0o0cuC/HLP83lLLuOOQSFTvGHxEUeJIPYG5U8hhhRj6mXZuiE6F8?=
 =?us-ascii?Q?ZOq8uyYbuxMjYtu++RWEL86kapd9mFRmBBBX+c5UQ51A7vDr1w6VR+JLxmAK?=
 =?us-ascii?Q?nRa9m3v2Pw64TuVdSp1zEBeZLVKaWKbBL6V0dTOYK8A5eI540Y43GjWhh6GP?=
 =?us-ascii?Q?pPHxqWmdJBBvqn4VKk88FwBHW4V7kmwK/tazh6Ba1VB0mB6NIfB9UQtiVDgj?=
 =?us-ascii?Q?j8FwtFBRoi9WOkjpOGpvxkw5vZImExeCmRIB4lyeiejgnirjui15v7frYCvN?=
 =?us-ascii?Q?7icPKgtFufOqEO5xYRenimCckcvEjSRCZWskw+/Z/1xLsQYOhnq7WJUhXU07?=
 =?us-ascii?Q?FuM1pIXk0jfv/QKoW0ZSACUzzvJ6AEJIX3/gb08qT7dY14iwt4HE4GpuFDLH?=
 =?us-ascii?Q?QVV7zR9Geos6zMy85zLSvDyB/xYWNJbRAjefph7ZQ7R2CD5unGZQZG1iIlJD?=
 =?us-ascii?Q?g7acUcNV2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y6vzO2UzcufeSicTyUlm1ngmmfiKlK4Nag1ciU1OHwjddnV3Oz1nQzOnYbMD9gnNuQ/7PO5lizNsMBcgOn5kfKTC+hiWv7pKBvSvH05/S+t6rxjdSnMo0FoL+gWkyOg2vc5VLJHvO90VhvFLsgHG0354FySMbi1Yet2zaEG2e5bsVsyRMNBQysZ7PZoCU3QZQPD7mauji+cDNGRrxgPvzIZxCtlAPpoSTLJK8XpYd2CydpPgsnePmHWpr1loJg+LhTrVZD8v99yYRb++X5pbrjCl0Hh9OLbP5bM7pNHwEISpMdXsrQXHK2lsHB/SbYJWpqxlM3GvoQ9bw2RogD7acbj8qmGxCTM5CLKLEUAdUkCydPl8IrO00l7AzqgaEVpO3BB8PcEJdInyrKj+h9u8uIty+Aituzdn5G6djw4PLAfk9HeyVbtXJ64GHCjxV1o8YjdXm+AwRJT7Tr8yIxOjG26vbf1aLI1DecIaH1PmacXy6ZgWtHZjRxnjV6lMp5XaJzEBn+bAbe0EqkIdByaalQqAVEQiM3X+quyg/gJ9vBGH1nREyU6ROrVBn0MBXMcbqNRoNGbf91sYmQw9SG3DD0uSBGadhmlLuxmeQDTPrEk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5557d114-8bf6-4a3e-fef7-08de546d73fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:00.8418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLSLqruRehE1dvtzDfySovriOG9Awn1zOf1KvHs0Be67l+IVggJhr7U2VgMozVUFVXAxhEJ6YRs+WO4I9ae6Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-GUID: MopFpbHXuJ2I6yvZSVTeh2ugajCfyzXH
X-Proofpoint-ORIG-GUID: MopFpbHXuJ2I6yvZSVTeh2ugajCfyzXH
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=696941e1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_QQW3CUrkSdKJg9byCUA:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX0ZAyjW2amwuT
 pYQpr2UIXx/LF4TOUtn2NDNdTlyZVnymqhFeyp2PqvmZcgZvW8WV+3Z7SWfHmHN5YZMFdIBJX7m
 54gvOycLMezM8DBA3kHbKX/mru7djDAaElUuvpVBSHiBdlueGRhLzVJ98u7Eswska4m8AQB2w4V
 sPc9WuNu7URwlwF368pJeM4Xqc8E78mS+RdZNSkPgc49WzSdRWR4g5yRUCug8PkpFPuSf0UwCul
 yYZ/ZXd895q+KYFHp5elV3xObWK6CtynHUEgrdNq8Yl4oSfzMxa5zYXZpfzf1khwmrSr+oh7q8Y
 mRTqmsqrizrncqQbJc2cSoZNQzqQHgmATY8sO+WQkUkAxlFIetyN4gLYm6zH99NCtvlX1dP2ZLn
 7mSGpHFeeMskboyZSVJV6eh4lqmDIkqP1XdWmGwEX86uBUur4wj1RD42mQp0m94KsQtsA/Yg5Y3
 zh1XGDqQNLY3v5Ub0Pj4qTzT9pS/JrGV+1bb+Hqk=
X-Stat-Signature: ptwszd8fjn78y8zcxdbwkajw6j7ezz5x
X-Rspamd-Queue-Id: 7F02480005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768505834-438988
X-HE-Meta: U2FsdGVkX18GPhdGW0XfcbPut+g8yB6HfYirgucOvBsOOhJHht6zDSEnzlimR0x2j/bZ5Y33/LIXtQTTAiqXKOQ0lAEf4fdOIxeDvH1xcRQm4SgFchXAU4AFb/aPCbwahJMUfw4AmTSaqs3ruci31vQe6q88j370aN9Ec9hWLnR6Ukcd6DNBYis75o0kYrm97YvAFCtjGpD22Yz2gdJ4IHVk0M5sAmlgWsFF0A5APZ+hldFOsI3GWkEym2fdJJoiRwOhOYgpaUnIcBqqmXquc27L5j399xHmsCfcBIx0f7I+HhpSBbfIPzJIy9+FP1a7ywUL/lx8s0mfsv8cKq/TSUBziG4M4Sa8+3Qrw80+2Sc3SYubHJtVFcjeAQriqd3+u1HiAASGPBIH2ElYI0zCrQ5coh0N1kbjXfxCba+LWZt0zVvZBf3/2fMi7zt0sRezcoP+aK7bMXlmXP4AKjYOXUvutDBKoK2+CcmMQDIlay7ru7c2FsT1UkgHXFmRwZIO0CMROtBW37MAdhN1WCR0ZNbUnGMzb6xXgM62yNrLeFaz3+ccfStPCOAdJY1fHTFzqndmvf3LeKXlgxMse4fokbzRSVS72+bQXrcVGTaV7R7u6/YZiIqJThO8K304FSq75BACOZJarOufmejke1vAomIVHhu8bSLzVsoMVl4lVPfqTZygGE5m1oPLRx6TIzNattiE5b6syii7OfCvAjIKW6QFCopYjyLEyRhveTQBwa5v7qBw06hydwCAqMkq481MO9jwQVX1AYC5+zHqUu5ckoiJhMkZDEUCvhgaPWUVlQy5sDqkL0FJPWH4QB6pfPQNZ+zP2oaYDdQSN66R3AS4GsAYcVU4l3KZuDN8eD02ws3zby0SYlfEfCCoXlZfpQgW1rrhtudrT7eiO9CuuUadeKaHeqJh+vKVFNkAld4Lr4pyUk4eg2OH0RuKwX2NgT0yx66HV1LI9Yes1vjBXi2
 LopH5Yxn
 VjYlVO9Ee2ifeqrbFU+ks252uVu2ZeuCEh3ODZibVspC6BIQ+At7jxShKQSHSfH4wAdvlsv4vPBnkDNmk1aF9fzauqRRrffAfgdgM68WiWQ1niBzySXIIOOXMFWFsucTGAVSG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Isolate big node to use in its own function.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5c85964b36c58..5cefd85a04766 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2748,6 +2748,30 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+
+static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char height,
+		struct ma_wr_state *l_wr_mas)
+{
+	struct maple_big_node b_node;
+
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	/* Copy l_mas and store the value in b_node. */
+	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	/* Copy r_mas into b_node if there is anything to copy. */
+	if (mast->orig_r->max > mast->orig_r->last)
+		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
+			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	else
+		b_node.b_end++;
+
+	/* Stop spanning searches by searching for just index. */
+	mast->orig_l->index = mast->orig_l->last = mas->index;
+
+	mast->bn = &b_node;
+	/* Combine l_mas and r_mas and split them up evenly again. */
+	return mas_spanning_rebalance(mas, mast, height);
+}
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -3400,10 +3424,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  * span.
  * @wr_mas: The maple write state
  */
-static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
+static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
 	struct ma_state *mas;
 	unsigned char height;
 
@@ -3467,24 +3490,9 @@ static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(&l_wr_mas, &b_node, l_mas.end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (r_mas.max > r_mas.last)
-		mas_mab_cp(&r_mas, r_mas.offset, r_mas.end,
-			   &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
-
-	/* Stop spanning searches by searching for just index. */
-	l_mas.index = l_mas.last = mas->index;
-
-	mast.bn = &b_node;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, &mast, height + 1);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
 }
 
 /*
-- 
2.47.3


