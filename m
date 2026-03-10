Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFB9FCC9CB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 06:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC066B0088; Tue, 10 Mar 2026 02:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F186B0089; Tue, 10 Mar 2026 02:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6063E6B008A; Tue, 10 Mar 2026 02:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49D546B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:11:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0FD61C641
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:11:33 +0000 (UTC)
X-FDA: 84529131666.06.6C18410
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 70469A000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:11:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qFHEzSnP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y2Tonhpm;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773123090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yci9O3M0i41fvtWaKyQNyINrmXi8nXmXOfWlJa4pjUI=;
	b=nn+qxgRnN/gBoifpg3LIVyaDFNqfCVPCVBKlzo7avKUIYCh5AW0GYotPTw94IezpuYr64K
	taUkBwlTztGa7JVoZKHUmfynaqXlVxYzIZ/AgmTW4KhRnU0kAWhe41gcmhCLAu8ms7cLQw
	j2CU8jvusrgC7MtyMY2kbPQHqfdclS8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qFHEzSnP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y2Tonhpm;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773123090; a=rsa-sha256;
	cv=pass;
	b=ZUy3ab7PTZMh+yC/YjiksDGHKAGRcA/naVfUf8K51IoJEodBbhMYzEBmMlq9KjPfOkGyf7
	Q7CXE1iebBLcsqPSI5pvC1nDOyZQJmddBKHRH8FoSyfWof2ZB9arHtmDtAUGu5lzxC9d7t
	wQbkehvIdApfXArvzHFJB8qnvqRSJl8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629IMhXh2910641;
	Tue, 10 Mar 2026 06:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yci9O3M0i41fvtWaKy
	QNyINrmXi8nXmXOfWlJa4pjUI=; b=qFHEzSnPPIlbk95nc4X4Q1Vp/DZE5aYzW4
	S/HCuDmJc/jGakTDEv1lkxbfM9hp+AkhFinnDo7vaJt355LXv9tBU2eyvXr/0kqY
	hSXZRaTuTMBVD5snik9m2KPcKulWn8FD7CnD536xLPSQSGeZhcUzb84jz2svgkoB
	QKu1ArcA3k5lXS+xjyYAjoAAeVOfyMuCHyD9KGkDNAlMEdfntWoMc4rYeNPOtvjf
	uAVaiBc82wJxihqt1WkNWls7Dg6FqcBBSKSwIAzQNzpLy+tn7XYGVsnh8t1WgOuZ
	SegtLk4kLuQQuoCPprmQy0p7XmNQbbjvJ46hiLZA9XSYQcsK3O7g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskua293x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 06:11:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62A48lvB022901;
	Tue, 10 Mar 2026 06:11:19 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf9ncs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 06:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kzGt3HMbzNhEYiovpALslRmpswuaSkCkL0pnK12KddbK33tlo+L35obdrFnHGYePnOO39H3RHpdmXTu7O547zr/CR2iiNIaKb3k5Ym+lyrClOMncmykzwzlyFuMD8fzgCzumfloFRMtzeMG2FFv9KFDGOIkwxPiK4CnAgMF1S3cz4xyJuO7wQQLyZHWBFFO/rQIDEeZJD0DTIaKEHH1JWwIVOGNR383Eh/QHA6FGAmqEVM4R6D6iMzb3Jo7fcCLm/Vq6/NachFLfmAvDrVhTgPVm2zenjLybeeETFmF4l8wNoziIpQzliUBX/PSfHP2q7ks0r3TkWtQcq6j0Hy4ZVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yci9O3M0i41fvtWaKyQNyINrmXi8nXmXOfWlJa4pjUI=;
 b=x9boazJK9Jq6JB2R5Rpx8cBOrF2GDJmeLRdcs9w4Yzh9QHQEwrP45DdgxCNqKW1IVsBvGlU0BYn7yoLBHIANU626heE6+0SyAA+5WvXEoOSayq1WQzjjyBavYd8UfBzptYZtMyO78NZ4XNXpY9VnKwWbdW4UdtNaA4uNate653XZFfBImjCKQClOL/yDKxD4wir13KCp8TkJcURI2OrjQ04QLX2WeZg/wtKPhq+a49KZcDi5g2bjUDkU4xnGbGz3PCmOQVlphJ9djK/pdM5WziuhZHqBJMJ0VPDJC82IqOOVoWhNS+Eh1QVjK1tIesFYhd/pjEdj8P36/MU5uA4hkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yci9O3M0i41fvtWaKyQNyINrmXi8nXmXOfWlJa4pjUI=;
 b=y2TonhpmMaMe9kEtSsTKMwvgGNMwk195FwdwL/vOmtuxv5Z8dLpTHtmJq5wiFk0Jc3wHo6gqK8Qwfs95o+lxnBbQTNu+RmCSdWpeXq266/OOYCx4AMxOkjZyawRnyfCRzoJWvWZMAcDj4grImATnIQObZZtuLfq7n9Zgx966Ioc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV0PR10MB997638.namprd10.prod.outlook.com (2603:10b6:408:346::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.24; Tue, 10 Mar
 2026 06:11:16 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 06:11:16 +0000
Date: Tue, 10 Mar 2026 15:11:05 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, chao@kernel.org,
        hao.li@linux.dev, jaegeuk@kernel.org, jannh@google.com,
        liam.howlett@oracle.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@kernel.org, vbabka@suse.cz,
        wangqing7171@gmail.com
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aa-1-Y3v3D1hzPvL@hyeyoo>
References: <aa-SinLe2jrtO1pS@hyeyoo>
 <69af95db.a00a0220.d013.0001.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69af95db.a00a0220.d013.0001.GAE@google.com>
X-ClientProxiedBy: SEWP216CA0002.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV0PR10MB997638:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f43fd89-14cc-43cf-a4aa-08de7e6bd6d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	wv83xMQfrdzobjyko3lnHPP9eIKcy+/7CYrhwgxUhXZ7xvuO2U9mf2ONVeVtPDCv5/a2eerTD4l0UPgG7+F81DobHxJgUxng4003JmGf38bZo2ptQ/4WHODLOIzmmbFIO+kmODdnJVF6wGnDjx5Fe7sTiDVc0flyCluF6TOSRVO9cc2eEt7+ai0eZEURg0zKA42z6UeqH1ONJuF20g0HSTqEtmbT5vch1l5IV2Av42UavegBIqbspl2gFsB8nH0PV96WF/t8LMeYSZwNRjD4W42Ev1+k3Li4AkHNeSGpj+SIzxuPhDUUapJwkDgKlfFvBLiMK0XLx1bAmep6ZFVE84cIHzRBVtXeR6FY4JKOxwPIU14EOQ3vXIut+k00O32ogZptwxMgUw8Dq4b0td77c4YoolsAhz9rbndK9aOJv8DzpQSgaaql9iQoPqICkyIlZ+V/Fib1IaA/uJFwPjnklbuzRy6+b2DPa3koUzmUfy3yz4eEnbetghf7kAC5SmymYZoOKPdEExtCN16Po8R1Tz++jPwhcOfH9Bi4BMejh5oJYiMX5eSSCv3jZ2wxPAxH+EP7CftXKDPusee6dXM6wy1nncAKhtvP2H+WWOlX8P58GriCmsYsqPeRrK8+X1Yn/leokG9kQB5dQNN/1jXUuw5Sxocj3v0lJT9LhVq3u3ZWdh14AzMZyxOfCBwq9NyWod+b9o+0/x8tIQDuQfADSiZP8W/uqHCz5TpQDDoci5I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w9YbY0AagYNlAL/svI92xQn5OIdS4F68YQrmPjjGZRZ8dNfhHWTvCOHwpsVF?=
 =?us-ascii?Q?EJPDoiObn/MoNrAabazLdZN5UmgYoXi9eJooE0PrGfCPQxvvFpRKb8jSbwVf?=
 =?us-ascii?Q?VDuD45RVc50QJFh39ocA+Dww1awNlJubcx8/VPebu57VbY+ZZ1uw7XekZhH7?=
 =?us-ascii?Q?4DR5CmoHqbHm/JLGT7Z9gacWQZhkC+UMNEt2jlj+49DP5PISseQ3UjYOsWO9?=
 =?us-ascii?Q?1TfsqWt9XmqRFWOmTQZWpX3tb4iDQgpPBhf5UZGQmAhA5ONb6H+DCRdRF08b?=
 =?us-ascii?Q?j5drd7mueAw/vaOS+lhGD5hCydpu7hBqUE8V0lAYYIBB2KK2KCos6hcQSo7N?=
 =?us-ascii?Q?SlRv1TZwrHTVILw1cvSmCAffRpOBLujJmL1af1fWL7h1BqM7iYh6ne573jsU?=
 =?us-ascii?Q?o/97FUbGyLPmIcolh2NrqUn5OkK7jjzpnmZWL1rjgOlt+Ncc9Dp2JFmnfjQ0?=
 =?us-ascii?Q?J/MvZMER2Jtt4+zl4mtSsyd6LVjKjt0OyOf82qzIXvl8l3urYfLInUDGyojv?=
 =?us-ascii?Q?pNrNE9b10OldVse71oXH/qSQjVWPLrof+G4b2zup93kY8I4AifjwKagvKHm1?=
 =?us-ascii?Q?Xpk0CLt1AnVY13T9Srcj0ioHXtSOhqyQthHVYWw7O3ckaK3TXMIl1zmgxQ7+?=
 =?us-ascii?Q?yQ3DCLjenrUzvwS2ckFiaxl4x9QGxzBPCRbw1vodhfsqCye3FPzM5L4eDVly?=
 =?us-ascii?Q?B4zGaEJO8/d+Wv1xg+iK4/nOi9jW578dWGWr0jmeS424WmWY7kkeold+9DZh?=
 =?us-ascii?Q?inrhRodz/Z3elNcxkWZjGk25rex4SleCnuOheXOlbyI04MTW4tmO77Q7Jued?=
 =?us-ascii?Q?25qZdh62RlPl+fLPxaGlXrBFuD/XeJxFPDUHWvh9lY2x8vor2wMLudK9uS2X?=
 =?us-ascii?Q?3ctm3GSwYgkXKyEWc03gkdA75rSrw/9d17cJED7BbFNFYWUCA6S6JSjPiFCf?=
 =?us-ascii?Q?2tvhUkeBT1XphiD0qoqoh5r3u0TxYLnzLqypqK0gpCA0Na9OFTiGvX9OWMTR?=
 =?us-ascii?Q?wR6cCMF+igEw4afc4bCuHTpCj9AcRhFfOA9LFF/VP370BfqzNNRsPYtUAuH0?=
 =?us-ascii?Q?kuwtSb340PgqWZQEewQBjkwZxklaqt4FbObMUcPgK+AQhEWlzQTMrXTkcy1H?=
 =?us-ascii?Q?pquFoFeYTTDAQwWLYKZU/H5No1v1JtvbnY/gnbGI8UTaIRV/niPL7EGc3qY1?=
 =?us-ascii?Q?BhQc9mxih6TkmEtAzXZSwDWHcaX/FZ+THbwVBj3awW2QwVIQXByjSZBUFRRN?=
 =?us-ascii?Q?O2aHh+98r/VOmh810E0wrlK5MBhAGclcqhZ+70qAlQu26WmTl5A05+j35WGL?=
 =?us-ascii?Q?36Yu4tH1gYwWh8Hp1tOeBnTRrY7ZY872c4LkMGNhpAZxjV5c10FZUoxA363r?=
 =?us-ascii?Q?CH+tyS57+91w6d/iHSR5FZbZk9dNMKv06fvwctd/hU6Lajj351upnvLInr7/?=
 =?us-ascii?Q?ouDIl7MwEW54J4eGsJbW0VUIlVy5i10ud0Fshz0V3h2IjQdblMdG7sZEwYpt?=
 =?us-ascii?Q?azhpk1lhO9QA+sm46ml76TcThRBGSgMmjN7SRxoSZvPFiYU+YCPZG3eA7v6T?=
 =?us-ascii?Q?asL7ZSoOxzTwOKx8GNh+NKl/t/IHpuDs5OvxTD8LEtZn9IrxI5T1Urc7rL+G?=
 =?us-ascii?Q?t7TjafuZkU9y4bAZBgcrAS9EHW7l9gzIVAkmksrLBbd4q7culzO3pe1pb7vW?=
 =?us-ascii?Q?K3G9VGKiH5xinceKNzwqB2rD0ITZydshOEwrZoIDU/nreBE+Ar/KE5tPu9Cx?=
 =?us-ascii?Q?LjvM0oQxdg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Cj5aV1rz1/3jh1WC9jDph14TuIS7z496dVSBxL4sgoskmItzduUCIOxCZYLIofECJtuto5ZpDF+fi5t+y0E0Z8WkqGMmpPVzEl+YZ/S8QNe+W+EA/8iSRpDVg3PUvqBvT+XhbZSgd6w55+bW3StTvgiyV4CjCPMCablxmKzI7xBNO8GqaVr3pqJPzW8wh6gsWAqgD8nVRfr3nznLfRzgvYA42cyz5oNKq9rskRe3lfWgMI0pWonnJZl/jJLI/as3Vv1/xAEWqf9uuBId0N5Qwo8lBtmWMQRKC3lK0F+AeXybWUtG1owVSiphOCWeD5D9kSFO74KR4djnOgNu0veaNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wDuxjiRuNpdaKszcy+1n8W4+4EMQtWi5gnrVf0Nsd9Dn6CtdjhOrlRjLsf3pW2ZijMXUtIrP9IXRmiwZt/teiuUU+31sbSIDDh/gvlosxmFvWF2iXVVIMBPNLkLSabCbBrBltifw5toWj+/x/77P/+JJU+u0gzKpfDQlVn2WsRYzPK6t8VCLbABhCHePmKv1RUijBQjdJWArxUcWSii9HVckx8MfaIqUS46isiaF/CpV/rY2bez15lku3fGKazhI74R/7Y/4v/xFK6VFyJB4qXtfSQQsFTRACsZ6vg5h1XIqRNuPpt2LVjjiClQBjPkbiSXgtNb3/xHfQwcHWnT/TqpQwaDR3xh7V33UGjqwc2dprYix8jaty+H8a657PQR/gkPsFXIZYZ5TnwBq/gl2n7oj8VTp5Qv8w5tc5rC/hpYIBgoQK2ZFR2vp+dp7kOB48vFQVe1T/eCYdXeLYrvyvsnqnL1iNM0MF7a/Vitbhmu+c0vDPaA9XfShPzQgoPGoI8Xxqe/n3DWKpVTLi2QR+Z3MupVx3d8hkZaPK/zs+Xn/OJBpiOMwaK7HiS7Ycu3pEBTFRI9pKTginxBrHspfplY21yGxSqqIZEl6JTSkFTM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f43fd89-14cc-43cf-a4aa-08de7e6bd6d3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 06:11:16.5435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPsjtnF1RN0wFAtlPqLa6oM8SdWUM13wzxjbj1x/W+g7DNuPF6imrViO2rSueS9HB55if2Hd37Nzh3EWr2NMWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997638
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100049
X-Authority-Analysis: v=2.4 cv=Methep/f c=1 sm=1 tr=0 ts=69afb608 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=08qs2jb053QYS-sdkIcA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA0OSBTYWx0ZWRfX2IgR4YWuV/DG
 nanbqHoMrnmOzi699Sn/jLh1lURnv9i83Yc+9ZIP+rOQLve4FWcq5Ir2SwBT9gfd46ks/W2IjEC
 A1UnYm101bUuT94N50kBXVt1VXm/8QZRvT/EeFqFn38S01Ptu1xrNzShuyY8uolRG7W7m+ILEr6
 wugg69IE82l+dFFZwHoEwUc6YPH1aohUdlCyXjPMb27B63+7uHx6QX3ig7fG7XsS1oU8lHfcGSR
 CCGRKXo8Il5NiIaftGLuMdW+WuSUk2dpLXHRw4XsJug26OsAnIh18nr6vqenxDhoXYeq97WXx2d
 XOaRc0dBPteyVhZwLXa8hKdkukN4UAvWZbPlXQiXNTd/MXZFuU7HDg8qU4iD5pUJKKmaBDz4kyn
 JshHHwS4p+VAxmrsVl7hr+w80RROUL+MGAAq1b6FRjvLOdNWFkoVuY2w4n7peNb/UN5YFKPHRG6
 5SSYnlLv1bI7ytDG2eQ==
X-Proofpoint-ORIG-GUID: 91XXoqZh6DOFNm4s-5D371hw250F_djw
X-Proofpoint-GUID: 91XXoqZh6DOFNm4s-5D371hw250F_djw
X-Stat-Signature: fdqab6yz8roxguwffeijumc31dwe7h5c
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 70469A000D
X-HE-Tag: 1773123090-367787
X-HE-Meta: U2FsdGVkX199r3/E6AaNHD3NXTK3yxFMvLEv1ry3O/akwR99UUd1jnrxe/lycOaDhDTDB2wyvSri+ta1TXvv8ajCkTbudS8p7RxqyB+/+iEv1Id81FsJHuLSAvc1itjkMX7xpocevggMeFzcdRe9Drlc0N5dDOTTW0Z5HnV8sn2J9Kh16t67hAzW7NtLUYVJWQ6NRB289gVtti2jtrU6oWpmkq1JFra14LNTGkBXEcqsHeVWabXEjKoIaQ9Rjs1t/95+34Ju82DeoKD0cUGlFIBXUfYp86NQLN2v8VDEsQyBZZh0cSSgh0Ugtt5C2hFpKiueX5mz21Ex8VTrJ7dk/FMiI/YVLOowmu7Xx7JSWhQKK3owtBeDxHeT4XqBQUSLtfbib3QAay4XTxmM3PeCY5kqhaqnpOwBHdtWlJp5NZgjUSkb/PRtJJr+RIvjQTHN7t88/uEN1d8ZVne9oE5phT7SFOhANGjL4og2dlvboz1afUrRiUuO+/Bb6jpgGt8ryo6QQicN08LGRl+TdJ0BjF4/2sY+lVS0a8l1IPBQALX9ucZeasBLxtN2eOH2rDuC4MuEuLpAZEB6JkYTKDWj4yZ0lKfU1zfdwBsF62wbfVarJVaGi3CUJHH9DLg/9DJMK9rYwFGZ1SJvqp53NUCmgjoZa7vzGAFcjgn8sHena82mE8S8NYeuJu1cBE9r3h6zHNC8aaqTt0Ucg9tcRJGhLQZmgUV2kPr42A4k+Qir9PP8DDV5q4ZprFghwaxvdW5I4tg1QXS0eezyGnTtqqCMShPM7D/bR/+/6aHVPXLlDpb6t4mKMLwtWdc6fxefIlMGbotR0cQjB722B/+JFwfl7SrFmuGKF0NayJGruEIWm0fAZTkH0lxZTfsr7n/LUO5ICCQu9W/IWjSH+4kina5xq0wr6JKvS9y6OMTJUAAcAyiME9pjfoGKIapyXmgM5nkD8s8EoaT3NFWhwEhK/xS
 75iLpZUI
 zzIjJzh4iAJpS+yAsVyWnCkTMTI4QDillJsyQps2CRK9040AF/r+ZZ8oa3Pjon3ijqKATgb4WS3jRhWv58jKi8Y+hwRYRxPBn7lNM1gYzQcZ8GJchHDmQTX9quhYrHLMQC+pqfqxBsjAHmGqYXbLDnj9gijyuOz3FC3+M/fLfip07t1H0YJhMb4MsAXv92aDfWdOTaQ6knnTb3nsGpDhoMlRJhZF+DEUtfIsVWag24I6ZHOaniwtOeZcoc6OoE4EoguNCA3ju7aA8MXrJR75MNcUrJGhUWZlDrQSrqefGSA1/aK8jb5RJxl2p7zLOyRzCIuQ3Zhaz9BqSp+23wirO3EPOfH0nRn/CAmoPVTVoqypmd29ShZF5fRkU48mx5njb6CKf6sQNkKFDHe1eB2m3Jj5q4BD4etiRYwiqTH8+7pLgp0vYhHsNNMaZ8VTwvu0tOX4RxRvMeLeRRs3ynAI/Cvsfte+0wK3cXeRBFDejpMlBxQkSHKmoY2uZUzS+NxMCzIwSrkeHoK7IbiB/WgBOjAdh7VfYkTW9MMAtyvWO3OllVxnFi0IAVopUYkaJ2Ce2jXh0eJUJxMpmoHhdGi5LIyEZyld3QxRc7j7ZbedITn6lfUFyekgTzChayjSuYmufhEij243CxjVbTxYwpeYKHPP80b0tNo6MHH2TT++8jYVY7oVrFtuAyC1Fs1aftTKd3j4gZcKy7GxBBtQK41xkCDdUNcKeoNekG7ugw1HxeUkkUxH0fhJJCetgcQKvAAQ+hn9cbBjRRdCxU81ACl5K3s/nMhIAg5LJ06SrK/Q7IRfhtbmXqFStWZiSdK1Pw6qaznnll1UBq7AVT4ONmTujPatcew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index 7d784e03f3f9..da2c849d4735 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -163,6 +163,7 @@ See the include/linux/kmemleak.h header for the functions prototype.
 - ``kmemleak_not_leak``	 - mark an object as not a leak
 - ``kmemleak_transient_leak``	 - mark an object as a transient leak
 - ``kmemleak_ignore``		 - do not scan or report an object as leak
+- ``kmemleak_unignore``		 - undo a previous kmemleak_ignore()
 - ``kmemleak_scan_area``	 - add scan areas inside a memory block
 - ``kmemleak_no_scan``	 - do not scan a memory block
 - ``kmemleak_erase``		 - erase an old value in a pointer variable
diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index fbd424b2abb1..4eec0560be09 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -28,6 +28,7 @@ extern void kmemleak_update_trace(const void *ptr) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_transient_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
+extern void kmemleak_unignore(const void *ptr, int min_count) __ref;
 extern void kmemleak_ignore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
@@ -104,6 +105,10 @@ static inline void kmemleak_ignore_percpu(const void __percpu *ptr)
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
+
+static inline void kmemleak_unignore(const void *ptr, int min_count)
+{
+}
 static inline void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
 }
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c5100..871e20ba3d7b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -909,6 +909,8 @@ static void __paint_it(struct kmemleak_object *object, int color)
 	object->min_count = color;
 	if (color == KMEMLEAK_BLACK)
 		object->flags |= OBJECT_NO_SCAN;
+	else
+		object->flags &= ~OBJECT_NO_SCAN;
 }

 static void paint_it(struct kmemleak_object *object, int color)
@@ -1292,6 +1294,24 @@ void __ref kmemleak_ignore(const void *ptr)
 }
 EXPORT_SYMBOL(kmemleak_ignore);

+/**
+ * kmemleak_unignore - undo a previous kmemleak_ignore() on an object
+ * @ptr:	pointer to beginning of the object
+ * @min_count:	minimum number of references the object must have to be
+ *		considered a non-leak (see kmemleak_alloc() for details)
+ *
+ * Calling this function undoes a prior kmemleak_ignore() by restoring the
+ * given min_count, making the object visible to kmemleak again.
+ */
+void __ref kmemleak_unignore(const void *ptr, int min_count)
+{
+	pr_debug("%s(0x%px)\n", __func__, ptr);
+
+	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+		paint_ptr((unsigned long)ptr, min_count, 0);
+}
+EXPORT_SYMBOL(kmemleak_unignore);
+
 /**
  * kmemleak_scan_area - limit the range to be scanned in an allocated object
  * @ptr:	pointer to beginning or inside the object. This also
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..73f4668d870d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();

-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
+		/*
+		 * The object is now queued for deferred freeing via an RCU
+		 * sheaf. Tell kmemleak to ignore it.
+		 */
+		kmemleak_ignore(ptr);
 		return;
+	}

 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..3bfe113ae326 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3014,8 +3014,10 @@ static void pcs_flush_all(struct kmem_cache *s)
 		free_empty_sheaf(s, spare);
 	}

-	if (rcu_free)
+	if (rcu_free) {
+		kmemleak_ignore(rcu_free);
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+	}

 	sheaf_flush_main(s);
 }
@@ -3035,6 +3037,7 @@ static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
 	}

 	if (pcs->rcu_free) {
+		kmemleak_ignore(pcs->rcu_free);
 		call_rcu(&pcs->rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 		pcs->rcu_free = NULL;
 	}
@@ -4031,8 +4034,10 @@ static void flush_rcu_sheaf(struct work_struct *w)

 	local_unlock(&s->cpu_sheaves->lock);

-	if (rcu_free)
+	if (rcu_free) {
+		kmemleak_ignore(rcu_free);
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+	}
 }


@@ -5832,6 +5837,7 @@ static void rcu_free_sheaf(struct rcu_head *head)

 	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
 		stat(s, BARN_PUT);
+		kmemleak_unignore(sheaf, 1);
 		barn_put_full_sheaf(barn, sheaf);
 		return;
 	}
@@ -5842,6 +5848,7 @@ static void rcu_free_sheaf(struct rcu_head *head)

 empty:
 	if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
+		kmemleak_unignore(sheaf, 1);
 		barn_put_empty_sheaf(barn, sheaf);
 		return;
 	}
@@ -5948,8 +5955,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	 * we flush before local_unlock to make sure a racing
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
-	if (rcu_sheaf)
+	if (rcu_sheaf) {
+		kmemleak_ignore(rcu_sheaf);
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+	}

 	local_unlock(&s->cpu_sheaves->lock);

@@ -7538,6 +7547,7 @@ static void early_kmem_cache_node_alloc(int node)
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
 	kmem_cache_node->node[node] = n;
+	kmemleak_alloc(n, kmem_cache_node->size, 1, GFP_NOWAIT);
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);


base-commit: c23719abc3308df7ed3ad35650ad211fb2d2003d
--
2.43.0



