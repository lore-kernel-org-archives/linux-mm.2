Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79343CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 03:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539A48E001A; Sun,  2 Nov 2025 22:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EABB8E0015; Sun,  2 Nov 2025 22:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38ACA8E001A; Sun,  2 Nov 2025 22:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8E38E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 22:18:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C215D160911
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:18:40 +0000 (UTC)
X-FDA: 84067838400.07.D396497
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46B971C0004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:18:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XPXWEIib;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Pxnz0lN6;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762139917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRWdXbzAfA2tGfUUDC2BaxyIXl+NK1Brz1xL/g3lIkc=;
	b=jM60dFZxWQiDVPOePQJrxphSHH4FUS07qroO5yLpGKR7pD2vosGCjhiofsyz4yKbL0RC6z
	C6PT2JHEi/et5QyZqIqiRZUFw8GBOxPvCNJQzmql9XkJxZ5JdzT+LtVMCbleWjGju6/M8v
	1xEVvvRg0oVb1bPd6oymwSmmD7RYBDc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XPXWEIib;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Pxnz0lN6;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762139917; a=rsa-sha256;
	cv=pass;
	b=OCos3JCIsaFwjAJc75az6PFNWTM7dNAI9sNmiEl/ZGWmvM8nm3vTmgXtziZbZOX2zqzsQN
	PPd5DVdsIOK5WlSLhOyhXGeRlNdlJDD5kjA5DWYTd1XhnxMtzpZwTad9StA5xdnzSppnOW
	rCgX5Tx+0TqpoPia+kqu9fGCYAYITuU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A33EGdd019903;
	Mon, 3 Nov 2025 03:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DRWdXbzAfA2tGfUUDC
	2BaxyIXl+NK1Brz1xL/g3lIkc=; b=XPXWEIibekMohMCSxeU52JcB+zkGdu/kf1
	z3BRfDnC5iZO52iw17QtS8ATuLRJyNBYTb5+JVjL3ZQZooU+hlnpQpLyohENWlwW
	tCsLp9xscITl8QkmpJEwxqYSII+8W0yi48cgKwVML81c7JDezyFSIckUhmkfGu0w
	8MLxDfNkzNwptk5ALsXX7zhY0yltQ8fEXQFMi2KmlFKMwPixN1CyR0dOY1yudxS8
	DFOZTgMzGrnmOZnbPIzlJhwduhSb1m7KCEP+2npogSTqzF/tSyiY9jv5OCN/1EI/
	7iZeWpqU35O0feao641x7NstoI2G865f9oZK2IAsMRQGR46Zuvrw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6mah806f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 03:18:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A30AJPU016019;
	Mon, 3 Nov 2025 03:18:27 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012043.outbound.protection.outlook.com [52.101.53.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n7b03e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 03:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vdQTfvq/aeWCJIz7xGHopuUbPNjpl2AWtikFkygoEudFHybNgnBod/RSQtnt3U61dGxpMs80QPPes88WDlcimO49LbZCEC0vCpiRH0oysZwgTqJUW/t1jTcioZLLU4v2FxA3S+A1VT/yIe+6oicFGv2lTeCTeqp/99JEOy0H80WhmzuqyNh52GWO18lMVDhMk4E2ieodUGUf/VMZ6/kOCc9c0d+TtgiG1l2Q70sQ3fSrMTGziFPtvOqzgyCX/hb7ln8+DtyWSwBvPnDQzybcjNBpT6zP706G/yc2p5+x6IL3kieb6ItDYUJSp+R3PPfro163/ewH00gyoZVVFvYNHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRWdXbzAfA2tGfUUDC2BaxyIXl+NK1Brz1xL/g3lIkc=;
 b=WAMbeX1biAZMbpXHqriN/xpYCjPfVhL59Lpkx0/ksF+FAKzUtgb3s9tgIR15/6ztCOvF/0mZWNvOTIycRZAKxEctbNJtKQMXnGoLCec1RynV2lG0wi+H2ANh1I07HoNHnyt//M55dl9oalwxnMl+uyoVB1eDTA8OI23heWF6mI+pPJKnZzSERE09362pAEEojwttcrzvAC6sqTrJuw4dixMTpJiqHpl33Nx0U2xpgDx8LdtZ1bW+OkxupAVx1u7ZyBapoKxRVvkASe0drsgwhbd5bId/5F5jctpNpd9NS6NqvTn6b/cPgC4/sbyZSZuGFrjeAxjKYzIJdDfZMBCypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRWdXbzAfA2tGfUUDC2BaxyIXl+NK1Brz1xL/g3lIkc=;
 b=Pxnz0lN6k3ZCrX0w49niph9jdo9ntgIwvQH7tPcOuGMqXuSUtbif67Lm+yFS3garFwM2N4/90naF6GtK8pctGVyy4uPrVFBcwil1ucgr+NQZUMh5CecU1ML73rIoX34mx6PS89BpVuQAnvq5BzVwORzavefa3uEcp8+25jwaoDQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6907.namprd10.prod.outlook.com (2603:10b6:930:86::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Mon, 3 Nov
 2025 03:18:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 03:17:59 +0000
Date: Mon, 3 Nov 2025 12:17:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Aaron Tomlin <atomlin@atomlin.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aQge2rmgRvd1JKxc@harry>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
X-ClientProxiedBy: SL2P216CA0194.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc61d76-afc1-457e-6322-08de1a8796f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Oz+gixBRSujsMaggMk/YjdAL2+9aiRgqS7lNgD4ZwqI3FMmVGjsH3up2i82x?=
 =?us-ascii?Q?LrXGbZuN4ye0Gyw7A0KIGjyz+4ZC+X1dHQsdTXiQLubtAncy9NPY0GxUMDxA?=
 =?us-ascii?Q?Q/EwS/wYBQBUZcUDM5GekvG4snpXyEXtxkrSRy2x9TTpJSpOg9uHGoIat3l6?=
 =?us-ascii?Q?jYsir+tiOyiWz5N2pFu46OjS8KS38WSNPN/Wqxxt3zu5bf5P5VfndfhPqXEw?=
 =?us-ascii?Q?4rgF3UWPoCNYL3M4OvrotpMX9ik0b2TQWuPxtEaS6MCetr3PXaewG7scVL7J?=
 =?us-ascii?Q?w0TJ4WasshYfazRK+HjG1e1qNvPghzKkEDUDr9fRCEtUP/q4sDdR4zP9wlLf?=
 =?us-ascii?Q?C8h9D/ONQwrHW9vkvf+i+P9cDHCtlTZKRqwHnqmVsT3mKHxC01DmlPTat9hl?=
 =?us-ascii?Q?92gQXh5I5ZSxbqU02J19JwdfBJ3cTx7APgQzyNEZ3Ocm9m25BYytPxrpZy2Q?=
 =?us-ascii?Q?h2fehQzXPYk3Yhn7yvSDTieblPO7g/mCPbV/cshHNy0sM0MrEP+07hBLsZHv?=
 =?us-ascii?Q?MQpqLYRp4Ei9klRGF9c+0bg/rhLqIqk8vtY71WL63WegYPEzT7ZX7kxyskry?=
 =?us-ascii?Q?vjc/1DwEuz7IZCz6Wuw54wuio3N1UpflgXyT2DYeWs9/Sy9dFQFraUYZhNj3?=
 =?us-ascii?Q?DvGFvoHJZR4Ue7Ec3VM+0ZufhNUydJeF5rSloZdDkDI972/DpciUET5J9ksu?=
 =?us-ascii?Q?4np2/PKBVdYpQfSOyXnR/iCwBkVKaXrDTWlOaOhBBqnHY7guwHnfXiQs/8qu?=
 =?us-ascii?Q?5qefxyOLgAUdW+U2dYvUN2eYQxUJ0zis9vTgxs3kAVMOV7vjNg9mpbUy90Fb?=
 =?us-ascii?Q?zRo0UA9H/qavkxTVyIniakJbPl4D9ZSmM46nBOt/u4E3yz3zW88M1WO3tF53?=
 =?us-ascii?Q?fsu/QElqNOfxft9uSR4udF/c84mZdBc6Nc9yJpzj8rELElcksLYeg3lU0h6D?=
 =?us-ascii?Q?XmXO9t2gcpgI8LqcjkxRg5mgjqIDVjx4eh0v0VwFl+zCd9b4apLOSHc6saFN?=
 =?us-ascii?Q?AKV37j87SInUdorj8TybWcrvcXTJyRRkqTS9NfPgoLYsJBFYXLw3FLCrv4Da?=
 =?us-ascii?Q?oZjn394dSHv/7KGHeu9BkUVLi6VVZHr2VLAep+4PJVlLUzcWxgNO79vp/qyO?=
 =?us-ascii?Q?oSUkFHJMo3uJMXafD6SeSjGhbTI7AgVYcRa7pbOjJD5VbHYarD3moEObXkZE?=
 =?us-ascii?Q?zC5isqn/JKWq4quEyHKkoVzBUsBnxP1Fv1EDucebz1LHVMo/hFIiMWl/grBF?=
 =?us-ascii?Q?jfEbxJCmX6XDkIP6vMAtx2A9zXM54gQ46S6ieJ8K1MZKNUykeuxYbid+BAto?=
 =?us-ascii?Q?dVQ+TkFlWwT9bEu9+cFqr5GuHEN8AxzRc8tlidxIUzMZVCuKNcOqpNy/A7bE?=
 =?us-ascii?Q?hy8TIUp9T8CwUTQusreZfSGwqamlYzIoPTgENEVRhfesUofTv10XcneYwD/F?=
 =?us-ascii?Q?leuFkleegLS439j81RecCbpwQmvDmj2Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dgXvDwDjbUWFQd5+tysDTE4l/l9BNVmDdWS8ErKAPD0GEEWtEqZJ3je93dMs?=
 =?us-ascii?Q?QQES+DLlqHEW3odlJyq6N4nLbiYRGmgfTrhuduYT1evQyjZKZHxtYwbx0gWn?=
 =?us-ascii?Q?EdiYdISUeCICP/r1IHlRP4PZGXhrmdPwPIQujfXyUJtwFW1SKwVU1VYy3Zoz?=
 =?us-ascii?Q?SYqDxGBqwSUNjF7PCZ9QZj4p/3yQqKYYRdfJE5xyHvfFb3+rHui6sO/Y7SvY?=
 =?us-ascii?Q?Ycada7ICvpKt3M+SRUKOBj7dYLsDPgX5gu4pwkkjTMoOLmnegcDyvqrNPak7?=
 =?us-ascii?Q?nr6aufZFdYPlN/Aajxtk5ZQVJquwBxceoIooXtmKFGaOPgGArKp/Ot9owu1r?=
 =?us-ascii?Q?Njqp8HL/ieP5RHkeCZiGKUfNJ+zoMa8I/b0QMDqXFo+RGhcPXx2tg4FWpRFy?=
 =?us-ascii?Q?Duo03E+dCAfpUCDb/Nap2s9umqtPaCKWZ7fJl4S4cW53I1mSe8kfeLaIawCf?=
 =?us-ascii?Q?4L8irOU2Jj+mJA/G9Lg6yhzTA4wc+DqRxzU5ya79cBvQiFJqiYIFQctz6nI4?=
 =?us-ascii?Q?DwWvKv3jYtUIBBv4ylbS1o4uBSNmaeE96VvqR07W4dlxMgdwHwxrw4hgfOmG?=
 =?us-ascii?Q?UMkHeOk8A3kcsI+TFoEDR0rJttSnaobtX26J5AZMP+xpJ12jJcnVT+E81+B4?=
 =?us-ascii?Q?oYG+d3aH2D8bpMFraV6NBxJXldrg2AZ7tjjCsI/kYDL8CcMPPMV1qswkeFzT?=
 =?us-ascii?Q?Wz9ZGcSoxW0MzSogQSKcE5x73C4pccmyGCDCN83ms+0m1nja2qwZdHl9QgYY?=
 =?us-ascii?Q?LliZZdXPCH+76k4ysLTD4wTuuCsVO+d22q+YtyKPymjsJNEOla0KMGeY6r+4?=
 =?us-ascii?Q?866JOjdG/3gBlPFMVKubvPmhZ9V3OTL7chv3LGPvUKjMm0VK/L48QGCZLnbW?=
 =?us-ascii?Q?3idlehi+M3YPV2f78LgR5Nr3PiU4CVLnF3KZ0wLbUofmAcBnOQNogOzOp6mC?=
 =?us-ascii?Q?zgKhmk3xgTqiuXnHn3LxHyRLkGnf0XlsK8ICypzuRbD4jcm7hWN7vv8Ocsur?=
 =?us-ascii?Q?zXIvSiYRCp/xh7QARStsgZoron0Bt5AwUN26UJHJGxZqhNqomXQ+vsJ28Pc8?=
 =?us-ascii?Q?oge9GDTNqzhp7oKyhFnWKDcJ/1rXfUCAjyXp2ltUKGipnQugmcYmkBXiZQq6?=
 =?us-ascii?Q?sTOtZ8O27SDkVdkr6F5x6pbz8j16XqQDWr1dMiogDrFNYmCweaCpvDisGEI+?=
 =?us-ascii?Q?rl3SWCMVv0i3d3UyDLcHk4qSn4YxnBy2SKiBiFyknMf0iklDh6oAk/g94qw9?=
 =?us-ascii?Q?nsKlnxwBFpePMfla/UihiUZajSjrrvxjFZUExSvhIZc/Bz3mRMV4OgbTgsM+?=
 =?us-ascii?Q?gFCIM6f5tAUIuhHBis7qDOldmRCRqya08Qo5mS2v9o7cpRBRUSMRhd2ftJpr?=
 =?us-ascii?Q?a/ttaOcdU3Q4d+x1TYkydUtcNWchEg4ATkgnLFFqLxmoHSb/X3QHWeuIgAXi?=
 =?us-ascii?Q?3gNCoUNBCXwaEGcnozvppgz0WdjWpIck7A76dLquHiYeAFMGq2yyWl93eQfW?=
 =?us-ascii?Q?RIr6353NDLulRkmKcclASUGIFBbbofMexkRSD36LjS8zNT6L0fDEj5RxFGh8?=
 =?us-ascii?Q?/zlC5nO2nWQoNpsKL/F20Jw+REVU88dwpGZvMTX1cD4lCcwNT6/lggNCTzsI?=
 =?us-ascii?Q?JzSLsZBmGq9RcU/5SPPJUQaskw/KveCYgt06x9x7O9/b?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n3OWrt5aji/flKkt8XKeqZyXwjbyF+30AqzgUvVD1Gz+FiUMS6s5+E5lcup4Ckn3D2Aa4baOIm/JB6DGITy5EJXNp7ouSxKnDu2RbzsRlLwWFHBmn1bXi0BF3JS66PLfKfTx7SbdDKDiDhjAtVt1blasmUkFmIzjRIhQlWJESQfDxjbQWvXUUSNahq235X1aWbG1GpItfUPp7hN1dGsQpPHIMewYhJFlSdID450E2v96aVI28P+0k+aQOj5Px13t9VaSVJz2/ySgfts2pzhEYFOtuHSMW6FdryIyeUL7CYqTb0WfuuFQ+qWZb+nY1/vVcWGlWsaGeNHzA5ujgTt43WijzZU7212ipsTQb9Mmk6OyX8DUDYR6tUxYis9zznpGpHaH+mQNQV90zdjqvJL4oYhFBJELx27yq/ENxvthnDaB4Hf6jKE0f4DzzBiC8Cq6SY7Cwp8V66VezACNCt6/JXZAmF8FJOfLD8NCc+ZuKLWRi8gYx4fQU8WYbMQ0uIkL4PsFldU5Lu0bSPA2VLvZugIV8jo8A9/hXCVSJP9KY6brkUiNY250ulD6xRwdPofu9TEQI+NgpHUuCnpjLyTqR2EAx53z1CF5K12VxypYOWY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc61d76-afc1-457e-6322-08de1a8796f3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 03:17:59.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0r4UOk2GOSumH7JVTRTOTQuibFAKxCsw394yjjXuxOHNql48FTv7Z0JBKp1gXuDzeb4UIgxrzXsHvRk/374qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030028
X-Authority-Analysis: v=2.4 cv=UJfQ3Sfy c=1 sm=1 tr=0 ts=69081f03 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=auTrCeKoL-_gxoL8Z8sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyOCBTYWx0ZWRfX4aXkffui2sNA
 tp6ZrxEjAk1+txcO3KcMPsngmi9gFjoi0Y359UYhOrtPs9DQoahqkvT/ZcePcoyKwgoEkMopTdd
 oGwGlDGUWks6RP748Wi++rpK7KZs5aowwDhzpVGi1vpN9Y3D2tN0+2Pdr0UbEni3H/JKk5ssEq8
 DLZZ14EA5GMxk7igKFf6N/5SHvIH4CQab0AHIQ6uQXzIpLNg91zwCUgd1Em5ukMfQWaijjNmpJL
 5eko23U3fKTnRalXt3vIULpbqKx/6CsE80XDIXvckmFREDfiBrDZf2cFJ7ygusPuYGpCc7Lx4Sc
 KdMEzFdYS5Z87BxmwZCqI8iyycuEfOq0zArxMgwYcdw6jlBUFtQJYWU4TDtk2QjqA2AiwV6thuF
 B8JIFyWIeY/5BvXryHyV5IRz8geBaA==
X-Proofpoint-ORIG-GUID: DbeBeOXKNV8aPmQl_4wPw6CCBvccSXJU
X-Proofpoint-GUID: DbeBeOXKNV8aPmQl_4wPw6CCBvccSXJU
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46B971C0004
X-Stat-Signature: 8hcid3jbdirhaox3ao57jnc6b3mqi7yy
X-Rspam-User: 
X-HE-Tag: 1762139917-805816
X-HE-Meta: U2FsdGVkX1/mfUyuT0smm3Z8JbK0syiclNff8A3tj+UCtI6pF9yWxHxI/Y25jwTpbH7t6Kjn8m2JBfnh/aXdM1ttN3U4Q7Mynar4l3xIDv6a8q/V7rdNHnAgp0AFzEBgGbIhSH2UbWU69mJAqy1/wUCAzZVvbCLyitXji06MMWHA2gM0e4nGF/tmXjxmsCzCZ+LTsxAG+en37LiWvZjn3m1/WqRGmgjtuWYz8gE+prgbb00j3xfQOxIhcO9VnFT4rGGZ79rcDVUymX4XWuwlukzc11M3Xbtv6yTfJcCPMx/zYyJ9/hmELyrFqq1YMBtu0tkSoax28rK3wXBkcX8RLV8zP9f6CT35V/yHC3SHRnNByvjIAgp/0KQ1SRg88Ym/jmbjVprPceHOccD8ce6C5iR/qKFSfcD49NtovtJWIKCQACuPUQVtNGPi1Ndqyje3f04D3n5NiA5GDKwf/eqPekr1wNhu+jTfrFRQrp3B3jClPGgLrnBwCa1krLXNMFxnclYFpYSBnEzm1du5gNKdDTugCPwPteO0WSGNINImptkNBSjkMkmiuuk2ewgN9lgM6OJcqLz+SeY393Sw1kNUxel35VImL43/r25CLHtpJqW4EvLqV85yVy2HJMpUO59btv+eCP6It3t4s6I47vOv7EApTp4fBlpwUIAvasS+l4CUXsFuBgWsp9x0uGERL/ZObyKNILDXqIrkWYvvYs3nuBSGd6cxTZ0V+nt74AUmWrqQ6RSwsVm/UIUKX03g2lofdz3ti/0q3qeEOy974LJf4UlMWnRT6vBceaEmvp7Kxk/amSY1SE0PX5CxZB4GdUmx6XUGMcWOLboGCuPILnwlqFmdzg7XNuzyQ7KFhm84QpV8A6tEbVKZEjO3dct/X82YMMWHwE6aTLzUjePcGw43rfVarfvfqliNabpgUlD0HFRklddNOXk9szcDdj5nz4nkye6fBOtef6FsUByhfYd
 xQIIw98Z
 ZVvnYw/ZEXzdCMlf+cP2Mh2acur0pLV8DiggqSl58SpJBAjKGEc7Du2sQMS/TCBCAGPlqZmWRPpVDg+ArYzx0Q8YCcoHqeHEfEd7aGFesQOK+eceKYuGUb89xLMntq3qRO0pjuGOdG4yqsJNXI6OWUhMYiFefznPQC4aCaphQnEXl28medJFP4YVZtZ32kIJugkikFa7TrKKW3zpkv8W+gdfBdJPQGMn3Jlby8JV0UrXwWbJQ0JLUknX6lI3fJdsULojzuyec4hpXjz44sOdu97lZJJCKRrbxx8FIiiYO2upfLA/VBgbd/8NtiUkOKE5pfBofQvYk0M0gxOTdwSRgW++f0maWs+HSx0Cx/b45xuSi8Nd8CkGwUn3tzNw4zdlR6SxUW+6GG38dOer9rcr2gzV9M5H3rHBSo0sMr5S2PWZBonAsWifXw3mQ6zs3JNwhhgH/PoOpRrhEBF0W8SjeyyVFMjgqkyklLXk3c+oQQKoroxgPE5tizy4YM1GlR1T4GEK0ux3V3JOfW+Fe+W/uaImI2MfeEhXXm9oDEEPBVlZaVkuWzPaBxKozpYVTi+JAJX69BOyxYbLwI8mWxF8+F6F4FMSuiyjrX3JMXxSvA/T/lTZ2VTEiySgWloKHQrdknnLTBxT1SFpuyEJXsmjkq9/uXlfhkL+6MkjJyBY4QuF+fxNgzYi+cR/wflokFHOQV4urmcpOSG5xfAc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:32:54PM +0100, Daniel Gomez wrote:
> 
> 
> On 10/09/2025 10.01, Vlastimil Babka wrote:
> > Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> > For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> > addition to main and spare sheaves.
> > 
> > kfree_rcu() operations will try to put objects on this sheaf. Once full,
> > the sheaf is detached and submitted to call_rcu() with a handler that
> > will try to put it in the barn, or flush to slab pages using bulk free,
> > when the barn is full. Then a new empty sheaf must be obtained to put
> > more objects there.
> > 
> > It's possible that no free sheaves are available to use for a new
> > rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> > GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> > kfree_rcu() implementation.
> > 
> > Expected advantages:
> > - batching the kfree_rcu() operations, that could eventually replace the
> >   existing batching
> > - sheaves can be reused for allocations via barn instead of being
> >   flushed to slabs, which is more efficient
> >   - this includes cases where only some cpus are allowed to process rcu
> >     callbacks (Android)
> > 
> > Possible disadvantage:
> > - objects might be waiting for more than their grace period (it is
> >   determined by the last object freed into the sheaf), increasing memory
> >   usage - but the existing batching does that too.
> > 
> > Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> > implementation favors smaller memory footprint over performance.
> > 
> > Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
> > contexts where kfree_rcu() is called might not be compatible with taking
> > a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> > spinlock - the current kfree_rcu() implementation avoids doing that.
> > 
> > Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
> > that have them. This is not a cheap operation, but the barrier usage is
> > rare - currently kmem_cache_destroy() or on module unload.
> > 
> > Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> > count how many kfree_rcu() used the rcu_free sheaf successfully and how
> > many had to fall back to the existing implementation.
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Hi Vlastimil,
> 
> This patch increases kmod selftest (stress module loader) runtime by about
> ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
> CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
> causing this, or how to address it?

This is likely due to increased kvfree_rcu_barrier() during module unload.

It currently iterates over all CPUs x slab caches (that enabled sheaves,
there should be only a few now) pair to make sure rcu sheaf is flushed
by the time kvfree_rcu_barrier() returns.

Just being curious, do you have any serious workload that depends on
the performance of module unload?

-- 
Cheers,
Harry / Hyeonggon

