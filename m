Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6DFCA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 00:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960C88E0002; Wed, 27 Aug 2025 20:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E01E8E0001; Wed, 27 Aug 2025 20:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDE98E0009; Wed, 27 Aug 2025 20:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 633018E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:30:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13B75597B9
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:30:56 +0000 (UTC)
X-FDA: 83824286112.17.2EEAD63
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD679A0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:30:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dHOLlTPj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V24Ye3c4;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756341052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=brxeqPZ/znpQhmBBcIaPLh/I07YpGhjjZx2IFb5vbjI=;
	b=NVbAhfOIQ49gA2MVbk1XOdUkbcKOsoBV3X+jRFB5DaNZBAgU0u8ki45UdXgc8J3dCQcHi1
	sEz4xBQHaj6+A9V/L7VoYi8oSrDzpR0caH+vnQgMWFfWfL/SBu3oIiZeF+i/c1o8AKMTdt
	cLM6o9Cz7uR1hjTqJnZE+ggyWM8i+pg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dHOLlTPj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V24Ye3c4;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756341052; a=rsa-sha256;
	cv=pass;
	b=8TLj9yWUFsAFiCdeCrVO9iYpUAUieksZ1o9wdGTlWsgdmqWHKI2xA16Cy9qwbaDx5eL9ES
	6NaSMURhtyyrWzkfi4phQUyfcXkUD3CQAG9WMBmSmlXZ0Ym5Op/UYkAOXSxqH/t0QFBVL/
	B1pKeLMFWxdFL/WhVw3eF2U9j/k7ptQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLH5Zt023266;
	Thu, 28 Aug 2025 00:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=brxeqPZ/znpQhmBB
	cIaPLh/I07YpGhjjZx2IFb5vbjI=; b=dHOLlTPjQsc5qDvFRQKP1KBxV7ua85/v
	qLlx9S71fG5/B0fCNdZKP/sKHqt1wIvHO0jEV02+Mm389ze+6JU7SwuFcZa+l+Km
	HkgnHD34ZHr9SLEoP74oHaq16m7B2XEVt4W1M5+9ybqPYpXn0zWpBpgnUnrTRwuD
	bKYX/lTOZbbE5Jc0+PlNzg4LAhrN/mI+2xbn+PfaIiYNUGh4xmW77/rIGUnXy9qr
	lzMtUm2K+mFkdIX7dGNMgEP4VRikVoH8/c3y7ia+dfn+9Q0WZlmz5gdmC8sY37+i
	BXMYbX+DhqphPk1noyCm0mke2gjkJEU40TIbxczNGyS02U+27yVulw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s7gck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:30:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RMQk73027171;
	Thu, 28 Aug 2025 00:30:49 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43b51hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:30:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqPZZbiAPQS3P4SDdK6F1+n9NbXDeG/L7x3Y49q0+uS45gfUzerYyGh7SPRfP07ClVK9d4EWa+Xsn/4PtFc6bEXN3alg0VYWbVy8HWMh0Xe7DiDID8JiuGN4ZAHj40jUhQyUw8bLv6gZyo+cjCZOL3KrZi9pQPZ6Oqv8yF6GfgRpsUVDhuROLO98+RmyG+pwuzqL67rVkBfalLNDFevBbCzPuwmjVumYZ6Zwi7tyAjpQy1vvnDWVKQgxvx5x1t2ebRkIEZx3JLlto44GkAlKkxXiBiP9YGoaiqy7lmzdPN0ACIsbyumTEQ6H4TwYCZ9WT+BnpKJOW7PsrgQgb2iqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brxeqPZ/znpQhmBBcIaPLh/I07YpGhjjZx2IFb5vbjI=;
 b=evqjFldpjibBcFClTb6RFfrRQ5U9d+EWrGNSkObI3tpdxA0QWzB65Ot4VfRXkjYNWsmuX6BAr9p37xPsfFWWsjkYn1f5ikPQS361YadN/c2b0xzW0UPjJFahnk5HnUXawFTJ3YYH3sChUcRXIHibBQyQ99hDjRL+z+MBfNmvqc1tKnWPjhgdTKrYtLcXOqIyhgMi14jrcpI7xlAADBAzu7vM3oAwX07wTMlNJg0+K9T6KYTYSbY703YtHyZTnNjE9LfnjpfVUoqHgG5w2/qPPnhaP2L35wrkK3iUcKWmfKCvGWM09TdeD/L9+frb2vWbwjuJvqDF6k2KH4mLMeFMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brxeqPZ/znpQhmBBcIaPLh/I07YpGhjjZx2IFb5vbjI=;
 b=V24Ye3c4Q9buod8mKsG8wMrsc64YzhbwkWsNsMR3eWb0vNg/yb57m/cDE7LE+z9pz7Fj6V2zsqoy+gGwrEzA6zC2XJXB8ftvxp216/0RXm//Qs7BCqly95g5GUdyrf0GuQEUsjuCEXs73v+dYdTJ4hsI63ABIaVuxPgyrxCBesM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BL3PR10MB6163.namprd10.prod.outlook.com (2603:10b6:208:3be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 00:30:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:30:46 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, sidhartha.kumar@oracle.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 0/2] maple_tree: Fix testing for 32bit compiles
Date: Wed, 27 Aug 2025 20:30:21 -0400
Message-ID: <20250828003023.418966-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0170.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BL3PR10MB6163:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e190fc-77d8-4b70-d517-08dde5ca217c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8yDk/v8kAPcNgTxBF/BJomBV/3NN3OLd2S5gR6DZcNdihBn06T7WELW76GXt?=
 =?us-ascii?Q?72BkzR54z7Uv2sgiR3U+S+GHJKMS6Hg+/Ufdgz/uojAXSqk1d0R+CfQ3EWOy?=
 =?us-ascii?Q?r8u5nn+Bj+qRtM/D37jDH1QYsZPFg4tvdNQPqMdcUKqCEKYRNXJsQtv6mAOH?=
 =?us-ascii?Q?uIkeSx8/PPomRrUXecFKEdssrrepSQIdaO52g9dkBCbB03yWFUvVUy0xgdB2?=
 =?us-ascii?Q?bxKYnl9fwFKvCf99K7JXJE1KYHaDy03lQ0/lgPcw6bn3NtdgxXfcX5GecIEv?=
 =?us-ascii?Q?3vhUdc0NH6FZzqpARZWDEq3nC8sylAYQo5GbWz9+cdEly1UK5yiiHYksgnBz?=
 =?us-ascii?Q?Fq1IEsWAbCvRC+HvlDYK1ub/KYpJqDpQ2DpgbleLIVl6p1UN777T0G7bvWZH?=
 =?us-ascii?Q?Fb/SvQLA5zI++fY6Aa87uvU38iR7pYoVdOYQ46XC0MDFUzJu5d6UlJS7wyXx?=
 =?us-ascii?Q?Xlc1THzfws0V2Uc0oXelmSiN84dDmiz9kbkbge1uewTIvppcCHmITRTIoeLK?=
 =?us-ascii?Q?blZ04+khwonaH0PiKWjNUnAff+0HKE7ELipDQ3d7AT+0eMUSUKF4ga1AU3gc?=
 =?us-ascii?Q?hXQ4eMzt8Bhht9f911EWRZt4HBck5Iau8biuzJskpjqIciq1HkfWc6dG42l+?=
 =?us-ascii?Q?gzPLpE1QZiA8iMJAnvKnFE4VEZIIG/ue1MQuzhZUtxJ3bbu3HZenBW/C13fj?=
 =?us-ascii?Q?+4z5qaXoUB+rn4lmSn12Ja7dkmyOj7T6v5DB4fY7CH6NIIOFXcrZQe7haDfF?=
 =?us-ascii?Q?Vv/7+H3endG+yXM3EJ+5k8tLexct2OtCKLuCZL8jzBLd3s3j4Bk02eciqw3m?=
 =?us-ascii?Q?yUPLIDTqWeNnnEOKvvvrOSPmkVolTZQEBFkeYhMVO3pmDBaLy/THy8y10eJv?=
 =?us-ascii?Q?FLD74i5GWp+US+xyTG4vibTZWzf+757ZKEhF08Ik556/yio4dsr2IfoK/KJ2?=
 =?us-ascii?Q?9XJvgKZNlq6TqeWwCdruVxPH0J9aCMdZb48QsGICwVLCbJLwRKc6IBAGA05C?=
 =?us-ascii?Q?f/qA5w9prK6kHrJ3FyK7kydyC+9ZUN8028Hq7Gp8/zOtWzdDWZclXWROd1/T?=
 =?us-ascii?Q?fhNbzA3yWCZ5+HHNMlj+19Q+CdVN0/KJuEKbAX5qudGObpzxomWTycQAzpsy?=
 =?us-ascii?Q?jH0beix1PZ80xsVbjR5d0jNk73y79rEUc+BcO3cxCyto9TsviOcZCSt4+Nn3?=
 =?us-ascii?Q?NrW3EQ4e5Z3H9bSvw0CV3yIl9OFcRLxJyq4Z8uxf8pQQ0VW5eqw336Ort+rm?=
 =?us-ascii?Q?z29w44814XhjHty2ch+xe9jsgc20DUtQhhVYBWyQD6iZ/yhRc8Dn84PLv4zL?=
 =?us-ascii?Q?ZkhoGOpvIT58gEkDInn6XfqeXmA3F5GP5IcgoXRAzdcJEOFQXpWzQIXdVnHs?=
 =?us-ascii?Q?A8IUHpdbK+kMkZs9Ce2A0r3W94KPBiaZcCdAZ/MgZcM8bRR8u1vRYBFMcboG?=
 =?us-ascii?Q?i6mTen0Xccs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Uc2h6i39eQZpDxYt+foRZ9lwqAZ8Of+UbhK8Ctf+2zGorMF0kTxp5zthmGXK?=
 =?us-ascii?Q?lxUuQG+r5sWRhCHx/gVV0NvRahZE7odYaGkx1vrmHmA9NVRrqDTmGFuTsGjb?=
 =?us-ascii?Q?uoBsm+ajllEYw375H+j2d7IqMupnOSY/6MJT3+v80+YqUMMiw7wA7fZVmiNO?=
 =?us-ascii?Q?Kk7x4LqcKn59IVmseFnmPPMI2tZ/UCogoNfSrMlhjdsCQiNCdPYY6HnP5axX?=
 =?us-ascii?Q?CwXA4oe78fIcUp01gOZoYMn2Y00nTgbaMxPIMqrWMc+egQZX/yySsR6nlJQI?=
 =?us-ascii?Q?d6RRD+lzJNd2WyewNua97yL3Q2QinBFO2St12dHHr0gft5PGIVhUP5ZeDe9r?=
 =?us-ascii?Q?nAFOHFb8FeqkfbLpVz8yIWpaVZ9ZvGbDYrazrMtEM5E6Do7HfqylBlsLzVre?=
 =?us-ascii?Q?IJBsn8DkiV1fp+XEwd30wJdOweho9p3lsbQ17GWxqTlJKcNzTJGUol3eMHvT?=
 =?us-ascii?Q?LH/fWU+T2vjSNDlxvGZ0X8KMDBaDbvSM+AjXcpEHaoWcufx9yjKCzJOJVokf?=
 =?us-ascii?Q?sKNZ1gxtF/l+FGgr39x1JHmyeEQY4ytir27hb8TTQ8KizBl3vEuFcyy2/ExR?=
 =?us-ascii?Q?DlFrxqJScb71r46reKBfw0QSTWEuUjjsnOcNYlB3CpieJf6OgrJHpFUDoLsA?=
 =?us-ascii?Q?btEGqlLws+/LO7KVnuwqhe4ODqqUvKCyIfMuK3YKT+FMIbppuquk6RJiZ8qN?=
 =?us-ascii?Q?y8KLO8SaIs4n5DEZOIDtbPzRFTW1eVV+zQwSctXXk+HoVfy1QlV9TkjNoJNj?=
 =?us-ascii?Q?xJYDzkQS45UcIm3c9Pr6k8izV9JJHsX/SS6B1HpgXR13CeVyq6RWGcyGLvjh?=
 =?us-ascii?Q?VZ4s5jU3cG0bTCue6QGmP1j7ogpdYybJe7ViYaB6NZcocAn8/Cik/01I3PKC?=
 =?us-ascii?Q?rmLOuBuupzBZuHdrOukzvVWU5xoj+e2PX7x0cvxvsYCFi95O5SfDe1rTCRq3?=
 =?us-ascii?Q?vNu/8qZoA8eUwyeZv4yFt+VhUeG4kN2LOqVU/xYuns+F2MZdLpj6R/ukyY7c?=
 =?us-ascii?Q?Sy3pb9q+TZ7FK9ITjgvoUNlSNcyUozaMWXhOklCptE+TMew53qY4wYcccD8X?=
 =?us-ascii?Q?zYxnZS2ba65RG2vM2TfKRWqypgn4Cy/OScQQ9CssabVwkucfRdUufwTRfC4s?=
 =?us-ascii?Q?CKiwMg0yOPrkhICzBpwyFWwdFeFFGTLgg83N+QgmnK0CPO+pzNyWNfIXeU/1?=
 =?us-ascii?Q?EVdAACzXet/bzck+1nmIpfp5FTGpFuWnvvxMon7dy8RYdWqXh/pk2c7QJBv2?=
 =?us-ascii?Q?TuMGkp1WZTprM6iBaiRln806kvqdHOszimhYoUNtctrMfx8UQFT6pQ/MWqQd?=
 =?us-ascii?Q?W5ySJxpuaIV82ZX5eFCGllB4mM9xeRZfqWmnS8VfTTbsop/ShrMmL09cvO3b?=
 =?us-ascii?Q?pIV6u4fcMskmlJnezHJvbmuQLmC2WHqxdFbzpLzAbTtYdYDfv51wJ7S0UhRS?=
 =?us-ascii?Q?IzgWNJJlg+/8yG5A5/sQmUmJG3tEBiIkqzkfHIjx7EvfO/Mq5XTkuQ1Qm1aZ?=
 =?us-ascii?Q?p/xPbNscoM8oqtnUDxHNxpTkpC6OJiljR1VdhYqnRcIo30jMzOG8JKlUHCS2?=
 =?us-ascii?Q?ALmnXyVCb+/qp6WMJPyyn4Fvnwv6hFJFdwTOfvSO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H9kRx8dveohn4Ph2IJwl7kdVcqA9aB2LcPx7uj99D9qCxCHnsjaOj8iQx6TMMhvNpLzgMWAEATH30uE9vdiphSUsUw+MpOAgPRJHNmIzKu5P1LMdb0MW+EJ/Ipq9dk6Kbcf/zm8Q5B+ZGaByy16SV3vG6KjXSeYnZ+gYSNuHGdMT3ULVi+X548C7oqVHSJ55HnNsmTkYArIz7DITdy0RHqRsDM8SOLAFYa3s8SMw1IYgFMAu7II3i4kSjohB0bGEUIzfgCvUtdcHDemDTiK7e0K7ycT4WZvR2/RZ7iCgUS5s/7ZOYVfGXGrB/tNDtSYAeScy+Yu29NJehES7l2sh+QUQgu3av7LqFNZ+BYmyAlQD1NO07Qaua/zERseaDNBtoB5df1rtaj4LBXfoUh4NIwPvDbfZysqSkTe9a8FRVG4WyatKCiEeG3IvK/imJmy6fv2m0Dl+pUBU9Pp7fWfCf6T5jzySGWe7TJeekLj1nOd0mrERivyBrb58VQmQi7Y2TSJCKaKBAiv1BvQ+RNLvJED/T5ucGvlUPW6zM9l4Wb4ScHxIU9J9/NB2QuzGnoZMYUw3Ma5Vi76TuRrmdPFZ3wgCKuQKEWLS7koczWcs+1c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e190fc-77d8-4b70-d517-08dde5ca217c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:30:46.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBbce3D+LHY9HlOdvEOhP/Dy7sR1irpd+/gegv0i3FB24+MpQFvU4as4P4Sqg8s0HhYOb33YrSYXNF5MTkb7LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280002
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68afa33a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=u4KCIdfxtUfyIN9iKZ0A:9
X-Proofpoint-GUID: M71PRGMV6s7So_N0FbT_RLhzCjj0P_86
X-Proofpoint-ORIG-GUID: M71PRGMV6s7So_N0FbT_RLhzCjj0P_86
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX6QOKTA3djcG0
 HbDB7ohhYdg9nSzE5PpGGx1wfu70MAGXbet2tEC2nFYcUu8bfE+opc8hd+9YbFnomlAZfeexhs6
 HKkn0qU5fqWR8Vu101ssRnxhc+kH39KFSLLf/n8npTlYNQWXYZqfbRtFBuY3KcL6NoGpNCVe+cu
 T3gYCI6+k5H1mDX1A8zxY6L+QJqLccaPjGE1EyU25FlrZEKxuAEgUasG1GEz1a6oLze/qtrO4/9
 wO2en11MWdnYIg2VuezFRWtJO4eWT64dHgV4ns/krSjxdQcQBH77F3QSgzT1gjPsrUUgNg0J8hv
 N8+I2Arly2SyukqN0QpeYQC4qY2iuKaAvxVItHluz3gRWIRFTlPLhNlHr+9IVfolsQBN2uSFVhb
 JUL6OAC4
X-Stat-Signature: phjpyyeu41pqz4ohohedu7fy9rqb3idk
X-Rspam-User: 
X-Rspamd-Queue-Id: AD679A0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756341052-835643
X-HE-Meta: U2FsdGVkX1/hBBfjeF7g4Gla7Qw84PhaXIhz8zcFd1Ala/bP+H7Nv4jSNJeHhFDTJjsO3zLT9kj7vxhodUjShJzGT6hXKqMMX+FNadMkJG7cR6FFOs6yvsMfWsfBVcCrRd8d4swWkYlw+MuYKQj+902nVb8sYAo9l1lOCBJxi3tc7RAL/7WX0rIeiHo6XkC63V8JvzlMl5C3BeqcmrDKsUeHKUEDz0cKYgJxJceMYJNtqBquH+e+1RH/KrMINpejSvSY2Z8LChTaRN6CNR4PP3CukZ7wYuMeWt9pG14OvsITPi4snrz+Or8ukQ9L3bNoF1ryKJBTC7Hv3DFCbeI/GvvijotP7zMyhCEZkp90pnaEqjpJqGntMSEnyiFjVtx2H8T3O7gUtygFTe8WhaGpKJ49j8XvX56XIkKgW0ErsZN8zktLoVP4bYzs8avaI3c8EvBIcEyzXSun5bMf9gWwhz48XOxN9SUDHGjN8sYP9vlEGSp1P0R/z0CTFY7ttE5SLaVB6es1uRn8DeoEUDsqHyEZrSdNtUu+kIx2rPA3ky7/UhbP3AKWnki3a0C7/4qJofN2jiNQFlj7uXXeXIg6wt4bVs4eKWUKGp3xoR3oXzRREqqIW2Hl4oLek2IxHcdngi2j9S8Kjj35EEe/oz3wS/opTJj9+gkznf/MhfR+9+I0sCpldZ1jwC9909NzO2BkbjeRv9ZDMF6YZUc0TZOOYINlRJeBCFcYMIsE4CdOjGHuL8DqA2hnCic29/0HWiYebafwDmyZTFaC9pI7Sjnzy+T21tKyyB4GO1VaPmYrLk5Rw8HOuBdlkKyPdP7C+gYRTNzTx+ixa7kVVMp4x4qzMct8TVuEme+jJM8jmXh7yB/Z3gB1bdyYzS+EY67D1EGgziR138gavZvtxThQxXp3A2taDm+d4SDjfOGnn1XnWDVD90KSEZDKP5dzpaHGFwXCFU+5y/EWUzXCXMc86ef
 30JsQdEz
 EKoHqlSh4T2P9+5If0uSIGhnyVper3fz67Wb3c4MaAaQ7plTjZHxNV4od7xKdMVbVCle+g9Si2mSRpcYab4S+bDTTyQ5wR55rixeBjErawqJyfaQ17L+/5n7W8XCMlNxRtJ1eTaJsPjcRjSAyFHkBnEY0VMEwkDhSl7HNKqdTm0pdEAiGx0UVarGvjfw60cHAjPKSG65IIDqfVr/IuKbzCYqr3T3zErrHlORrQ3HgY6K6fTNbBX0kYsaeQFYva0f+uzz7I5DeILZ4Z5jkrrwRXaaCZFg8IxEUNTxqCBiccY14Tt/98I52J1j90tHDFsdMCNyfzCGACXrjG3JuIO0MgPn+BI2KzoV2vQUlfpxQNpFlsQbC32BYJjsqIbW5PFgx9kCOzVt6qEcc/zoqmMw8Hd1kmP95ZMNzILo/q0YSmHi/I27qLa60SxC7RVfCkheIyhYkVlh7rpnTRZuF3tspCR+Z3eG427SKeaJpNHhqE9iDK5eJwkLRZwsVYLNuHyr3z/I6BCCHFSJ7MI3WFGT2TTHsGfH0deSSpmpKjf0hiq24GC+dSIHUyN+Gvo+QTlyNgTVMNLnc9MR3MgT+9m4mEO+l3XKasbppVTqxXCqGCA6jMGJGeQkb1ivfU2bsnfVc2DWgELbIbnwqcwm4EL1rRnfD4DcL+ght+Zmdz/gAt6xZyBkDja4f1o2ZJ5ENd1WVbKF3hg8x02s0rAgPEmlJbYFuBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The maple tree test suite supports 32bit builds which causes 32bit nodes
and index/last values.  Some tests have too large values and must be
skipped while others depend on certain actions causing the tree to be
altered in another measurable way (such as the height decreasing or
increasing).

Two tests were added that broke 32bit testing, either by compile
warnings or failures.  These fixes restore the tests to a working order.

Building 32bit version can be done on a 32bit platform, or by using
a command like: BUILD=32 make clean maple

Liam R. Howlett (2):
  maple_tree: Fix testing for 32 bit builds
  maple_tree: Testing fix for spanning store on 32b

 tools/testing/radix-tree/maple.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.47.2


