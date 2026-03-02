Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A075BE9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121066B0089; Mon,  2 Mar 2026 07:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE446B008A; Mon,  2 Mar 2026 07:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D056B008C; Mon,  2 Mar 2026 07:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5CE66B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:15:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85DD51608C9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:15:33 +0000 (UTC)
X-FDA: 84501018546.23.4DE10E5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10F77C0013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:15:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YFu56Hnu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WQ6eI3Re;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772453730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UgbOCKWFCwwgp7hsY2vho+isYSp6dF1DRv9tm05YwA=;
	b=qICip+8BH622rBGBxjMcoJj9e/R5Hqq16Wsg22J9th7k5dLrwUC10DqaqRQmGf38fuWyfD
	eDOxCoSJD2G3DxnL/PfHafDNb6nm+HA2h+sI1QdM066hS17r1dx72+w+xIxfeTPaYI7F1S
	jFSK0vVSUb4f9uW+I52GdMECSb/HH2g=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YFu56Hnu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WQ6eI3Re;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772453730; a=rsa-sha256;
	cv=pass;
	b=8jWbAe0s1JZUiYq3yrF8WnJcXoZtGjqPEITPWtNMFubDDa/T4XmkUp3rp3sxu3eSD16P5r
	KeweVwNDJSQgA0ja5ieoA2S8uAeebLhdaAR6Ff3Z4VCtYtt8rt54ULZgZa4YObcsrGcnOL
	lcq7QQK5CGfCnI4FRSjjUSTnfJ4/mqc=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622B3aCL3252887;
	Mon, 2 Mar 2026 12:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5UgbOCKWFCwwgp7hsY
	2vho+isYSp6dF1DRv9tm05YwA=; b=YFu56HnudvY06uci0iWQ6EhV9anJ77Avq/
	0AtyBE2guDmXdQzROyHwns6VNMR1eZNVpek8HnAgaxH2HUD/wACuplAOG04llXzg
	RW4NjIXnHJLJ8IMCae+v3eqq/PGH801bLUNuqUR/4TGCUdpMbjsQKgYeGXMSlGMB
	Rmnw0bRzWFkzn5sEIhRMGldveWYEPlTBJ3ZQ85ac2DIkKQNpDQWUtVfzpzXh4+Vj
	FjDIM8S09xOpHhkqn1FhUIrFZxPdnt+biiSnr0wCyijvL/V66aR1A9ideAAVKGoG
	cweLCo3eLCkN/TzlcIRTETGW7/1aqJsLR+/55Rupa5ZnXOSSQzSA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn9bc03nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:15:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622B2WGX029841;
	Mon, 2 Mar 2026 12:15:23 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8vagf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:15:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K//3jUpLC7DS3CZJHJcT81R0RPRUvHYWt9WXJxV49rndNHnDCHFjZEsjsSIiJilBLjRI/3GPyAMBwwh59DT3GC8keseZo8r9bAk7twf5I7gDPJPQGBisbsZeiO7d3wt73irtmP2usrJFawFITwp71NFVsxuWsJpHid+HsID/nJg+VV0zVYYMStk+MefLjc3/liqG4Up+c5tB21SF/peqrTmPdyXQVeUGL3N7c2ZnBT8KExNbOeQOMppYQNOOywBgvPA9cSznu2Jof71NcMK5qx8fffAalVe3JyBtsgG9vuq+0teYy4KrBHkKC1bi+xQvJPl4IQRR8VlK+VrqU2iZtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UgbOCKWFCwwgp7hsY2vho+isYSp6dF1DRv9tm05YwA=;
 b=htlwGDDmdPnyscu/kQJSNaYsMw4h0iXpp12fJdGObl6OJ9lxlqdTwM9qVPPTcEjp1zZ9ktWt2VESh6KZPSqxyCajIgxddaCYERINF3PwDxhuBKOss6D8KRDaPt05aHNoHr7yWJ00IgjaNjRew3V53LGsYcG0boR0v3RMCCa4E2Cq4P7B0luPhyxauZE1osmw2TNXFe48yquy5IozKPNSeEukP4kH90gdE1iShprkNHdUVRqpIpHfappQN8lVu0X6X8QPDGaQxBv489f1JhHm6/qRh/WakFGeG4oX+5lokc2hKLKJKNbyLYATcZ2Pver0trvdhVEm0vWb2F3drl6mkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UgbOCKWFCwwgp7hsY2vho+isYSp6dF1DRv9tm05YwA=;
 b=WQ6eI3Res6O67ajDSZMWSjIN25HEWyrH1pCBY4dcyLVY/qfsWKB4KcpFi7kCY22Elx+fKlmV8WHJl5EW3N6b9M0v+fyrT0BnmKG59pT3jcJozXxsOaw4aGHdK/8mMB9IqYqCIg2G8vD5oF8FuQM0pq0OlxVMBPlVFB753P2cw3I=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS3PR10MB997701.namprd10.prod.outlook.com (2603:10b6:8:344::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 12:15:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 12:15:16 +0000
Date: Mon, 2 Mar 2026 12:15:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Benjamin Lee McQueen <mcq@disroot.org>, akpm@linux-foundation.org,
        david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmpressure: scale window size based on machine memory
 and CPU count
Message-ID: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
References: <20260227221555.29969-1-mcq@disroot.org>
 <aaVQxnNFcbxKYRaX@tiehlicka>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaVQxnNFcbxKYRaX@tiehlicka>
X-ClientProxiedBy: AM5PR0101CA0018.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS3PR10MB997701:EE_
X-MS-Office365-Filtering-Correlation-Id: b3786056-4777-4114-fd80-08de78555d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	Srj2f+cudzq8cUo+/PhR5GCUEJLQh8q2H+6IP2nxgi9NtrO4jaxLnDhLzBjqJf/4HD63BUbq+bmCbqkRwCoC/2Q/q+4xFQYi/083zuyypACXGuF0Y5X+MEkgclZjOkjnQyNxvXGwOILKF8y8/mTqLCAq2Hc3x2PxCBbHsIqXx6GGpjavWmCW6o78RHJt56AXKjLjn60GWlGZQqCaqQSNV724m13IDBMuo/QiLhzB6Gjwc/Zr25gNE8RnO+DKYc9QMHo95mJwYjtNH3F6yXcaU9m0S9aUh812p5qxQnymiH4ayecLML2tIe13qHelIxM8JMnxqEKEDey3jKpVEQ4bsacYBNoLEtm/CplBpt/lXsqPdMwSZvZp+R+Pyj4mkGAZBFWroqRdtfqSYof5Ww/xtiyRodNxGUMgI9CH4yYoDtWsyCgFTSjOwo0s/6n6UfEghQF8kVqRg8dRO5rW6sewLn9p+I1g1MgVMBcgK9dx7O/XRiuCpESssl0APTYjEJL+mqADIFTMWnji10P+EonCQJV6LMDAfVC65tx4lOu94TZQi8r+wWXZaqO4zVtowH8C23k+x6cPHGxNIBIhDFdxXrt5Kq8sNUH4OuFjKr1Sa6Jpkn/kMiRd1ob/5zddvJQ3ScCAThFdZV6zGbar6GeCgXUxWaiAWwlXlsA+x3P3rqoZg4YV+St1Gb2NU32PiHu8Vb9lY3S/uzkaPSPuITwYArT1Cw2zEiKXo6WklzEuSPQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7laTS8HI2CT02Txsi3UDfwAgQR/P/2CcB5xFL7Gra/pNrE0RTmIUHKYxuI74?=
 =?us-ascii?Q?PneRM1Hq32hj5SFeQfLiUjclO7fUXuFnRrYDDka14ZnZa+FH6TijBhpZlj9G?=
 =?us-ascii?Q?yZ+ZTYror7afzTQO0JvBm0OR1SzQ5fKzxXpBJiWjL340rvUIlN+RXTGJDl9o?=
 =?us-ascii?Q?L7o+nvdy5v9BwnTLvbqFQtprcZow+d8+rn1YuVUf6npZS+zIMqvU51t9EUOJ?=
 =?us-ascii?Q?yxmo/dMM92n8DqdcVjIV0+L2sGSnhrp7PkFVPrTkgHkS5TFyJ+p8LPQGHSIS?=
 =?us-ascii?Q?x9qXrpBQZTUvn4g2b1YdLjfqdYZUyEmj4OSaFqLlKAlIL1S95vloybAm5q7B?=
 =?us-ascii?Q?i5EDXfAH6E90TUcmLFbffVL3hVCY9gzOwnuEcFvt4T//0UsRbcEUN8EqT4c+?=
 =?us-ascii?Q?9ccKlHOuPkG/qwjMnOb2/A3EC2/JXd4YIMcTxndhC0yqoElinPdcuRMr2/3s?=
 =?us-ascii?Q?MYX+Kw8zs049Uv4eoui1We5aIwO9Y3Nyhmo6udOjt72acRQ5BajBKc1UaB22?=
 =?us-ascii?Q?+kCIm4HqOgyc/Vjd3atgnnmj6oa6B/wKwP3tjzaXRf/YCAfU0+mr/Cow4HG/?=
 =?us-ascii?Q?1+FGN9wDjzKbt09ToJbWYIgfem+5CJic/5f/neVrmFQ96oMUvDEJO73h/csL?=
 =?us-ascii?Q?QKJ7ShcQ4V7VRW9Ev05IqhY+HmMFHyTgFKjY8aIAfVqNJVx+7LdElYnOUQ35?=
 =?us-ascii?Q?mpQ7X2J8KAQc7RNFJozi+ZsSavdhjJ9gfj6USE3TE8caBFQXZCH5zbuywG80?=
 =?us-ascii?Q?iDRFt05OVDowKv6zgXQqXKd7PZM1EZKXIDENq6DQdrthb4p3BCgXuDg2p9ya?=
 =?us-ascii?Q?RFeGgrC7lNB0JL50L4eATaJ9fx1Po+Hd83SvfA5KlIVEZIUGY7B/Td6oZS5Z?=
 =?us-ascii?Q?req8E3Ny9Qrm4duxlywQgWy5lmsDA9bIQXlcPnN/zxc0YI2mBt102LGRnpTG?=
 =?us-ascii?Q?XQb587q1kZ9/Uv1/19XYJsLV2SnQKG8zl4OR5rwXSvH6vNyTFt4miZuQwTJC?=
 =?us-ascii?Q?D+ebQhXa6XMT8K6QchYxi4fi5X2XmSrh5tZdytckO7fcTJq5Qvnbfb6gu8Wt?=
 =?us-ascii?Q?Xak4VuZFDemr9Mpd2fsSM/DQzVx2ThSmX7DzraZE3pzoZHtFTOiLjISRQ/zR?=
 =?us-ascii?Q?E1hXHOTUpkAssR2qPY9BViabHe4Ea1t+K+c5CO2dZmfSGFBtHK3dIfDlUUe5?=
 =?us-ascii?Q?QdUQW8VRRc4zkq76ol3CSQc/GNQXrkDch6vWBe6umX7OTqKnNnNwmhITnJN9?=
 =?us-ascii?Q?TLYuQnOWVpmiNgKNyXVptmN/jjq7bRvQIoGpdvWXjWkCVjL603g0rvuM76J5?=
 =?us-ascii?Q?VboPReNIp6PxH7Ki01OBfkQD78JYLacbZYCarCINwL4taumJtPIhXspdTMLX?=
 =?us-ascii?Q?fCp2/nYCK5HF+xiMzvX5N4zT7b5eTnvHP+24DciHoOeojLfgFMpHQOL03kO+?=
 =?us-ascii?Q?qxMhq6uDCjS384elio/yj79fWukc5WKThLR6S5gz3POJi4mBeUs3OKpMuP72?=
 =?us-ascii?Q?d0AFSuDHv8Zl60yBn0u9r+SAsMSFDHum3MHmtIFRKIBobzAZsQ3mj/6w8knG?=
 =?us-ascii?Q?d/FnUTJ04B29Je0v+C0qnK+tXIB3RwC5O3o4AwG3x2nlj794Wjqz6qafVbTY?=
 =?us-ascii?Q?GT1Cslvm00cuozqJ6YjGI80a/ZlAx0D1F1HVKpUfvOyssiMtYl5xqJQFaUZ0?=
 =?us-ascii?Q?w/LuzVFQSAEJJebQ0/BV5WkTd8ziemUidN5m9N8GBYNXa+xY9MCdjFeBonfG?=
 =?us-ascii?Q?G6S7IMwGbhAc1DVNzrVuXM8mBpiqX5Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v2rXgob9lsq+8SmsvOERZIOMDGJKVQgXIaGaGMVcBpu1Mh/RpiT8rdEFz0QjtRChINN/dAfL1V9tlRXQg2nHlFJZ+r43hm73uLy1mlLVDdwJryvOZXq0JFrw9UfVgAAx47nagXmFuXF7FgO8Xe9N6Bh1sRB6vOi2EjFbZxDTdp5BpRZauk+S7aKdxfe2OuVmihbTH/UWAO8ci/gmxdxIPJwXWAA13qlGG47Ow5BLpvGCv9/jiIitVnx03JHv4bX0yyuyY1YQrvw32rI+r3eaw64UrDPOELN6w5uqWh6RQJm0vtnAe1++d3p0Sl9Fn6YYcnB6h9bL12/Dkl7zq3KNC7vZHzAdQa5UrNXvMsdJFVYvOfO30XoTDdTn1ZZNSEf36yeTbk853x/pra4uJExucYhtOZolxL6qn+KujoD832ndiMQJrsf0EGdxBASp1bf8Lggb7CaPVVIexnA5mMAuKNmXig8bHNbbpLEJ+PMCFEYdAUV+mpDECAjj+b+b556lLFSp6hD7cXc0lq0eb6UNOpmLXwQU64Bs6m3FcxxTyz/EvBnGHyZZszErT7T8/+0FBQ8iO24dVok68q/dlLQo/gU7Z6x8ie1FFctNbqmugS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3786056-4777-4114-fd80-08de78555d67
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:15:16.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQqI3tJRNffb0oOw9wAnj30gXoiGr4mzZRw/pKXsWqTSFL5qRzt3M+98vApeC1vjcm+ir16hlq+MPgNoO1mCxvNb4jZofND7gaDoLpaS6hI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=604
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMiBTYWx0ZWRfX2Xd9i8IjH3Ok
 IMUCmP5z5mcyCsLyEFleY2C3XaXcqsJC3Xo/Ahe/Av4m6kmTu2zEO5wL49m0W4EkHiu3ME+61PT
 tW+NH33JAly1L1pAiL3k+F+ZM+f1+DL9u+H3pP/+5GuBTbkU0helVyybogGfnkYUc8ww/vfo5Wn
 ZheYZ6e1oHKyswippFd6FR0yMXdJ/Q4CPlCf+1iHWaSd6uFaIpgVbqvlwg/rH+H6dXPrdC0+/Jk
 8NzStaNGitCzKXHhFYpPe8HvkBKA6fiKM9ta88LTPjVsCI/h2eS2QzYTePAwBNDtesRjuj1a8cj
 f5yQIfTnqEy6HNAFI5OjOrR60KIdXLlSVxT/Q5OmoelwhRiOOQ/RDf380+I5nRk8ze/w4SiKLcU
 z5ecr0ieFo+g/+FvH0BrDW4tZvZMmX1uqg+gxyRktUZ7RZwyVZ+P3NLPvJRc9JLUaF3XgfaTANA
 amvThVE+zReQk0b/awA==
X-Authority-Analysis: v=2.4 cv=bNQb4f+Z c=1 sm=1 tr=0 ts=69a57f5c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=y-i0-zmkvag2aer2bA4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LMIijyW6dznIwNI4hfSVh7FLYnJ0YymG
X-Proofpoint-ORIG-GUID: LMIijyW6dznIwNI4hfSVh7FLYnJ0YymG
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10F77C0013
X-Stat-Signature: o1t99pkgme1hfs1678u1h9hz6rbrhjqp
X-Rspam-User: 
X-HE-Tag: 1772453729-338615
X-HE-Meta: U2FsdGVkX1/JqMWc6wVJ0PPqAkQu9q3CCReX8Br4948lT4/XrkDoE/VFATVq0+nu9BaNql9OCO/NRCpDMGPhc8XMpRPesVThOCAxccNqR6+Ks6/cIJszxkGM6XD6FWuW3b3cyXuELJLwtewT/g3xZozgi/ytCMI7x3XXdf/OrXarTQrI3KhJPks+UFxp1gGXwDX5KqdXe2bnyh9tjHpQ6cIXsKLT9xmefLbc6YNiBoOEGlQyrdKcvskOJXQ3AB6EIsDMeXt8HGpUFZ302ZwXI3dnopPcnKLtIFn75rwE4xy2wEKRP63REXXuQWRt1XsTvOk8L3rTvjl48DA97DxOzk9VFsms7OJ2JoMUTF+ckd5rT2eh41Gz2k+KyOE2mgcGx8vu90ErJvUN+fy2GyHuQuK0bZXDOcqFdNmqZJW/mz4DrMQNxUk/faQtNDA0+ycQMp9Llrc3UpOvm2SmruMDpaXkbUskGSS+KIF+S0gWhraDSkpHSlqgCGxLMy0NW94x9dcpJ8czL88LRW/H46hDjNW281eghbms7zmBM5w/uuLcbixzenNmJnVflgb2kf7P+FhOxQ3OBpXUomzjJkdJUwBCTiJe8qu4NofLnvirICw+unapxecs3byFBUoSdaMO3gQtGHh6ypYMf8Sp1z9QVBZlbXJ0KTeUs50y4cgCec7PzHSqoVVDq1VuHDpGK/CE+hNyFEnJnPPQ1IEXsPfXkocNjD8u9kuRQ+3TipoYmSofOvfQLTep/KFrj0nel/tcaB1ddpWyjdyZqlE7iN85rRq/4s/M4lIUHXKQ62EoFWdnOxXEr52eHovOIA8C9KE2cKfzAJg3uucwJkzvhCFuUk6BJ3KF/Ld5Mnl2Z+9H6fB5EWJORzOB+hna319lvBMrlp6hmC9cFHz0TKmdlJ1NJ1p6HuRFrOlHSP0uNXmdFgwUwXukHVwj4dliwmmNhaABe7J6PZgVtf1m3ktjk3q
 t2EvBweg
 q2mo9e2QOj204hwp02ZrRzQsj4PZnCCGC9V4bqH3ZOiWhahzPcMVK4AHPEqmx55YA7whn44Wpo/yym5ua04wanYBoe4igvK16hvwEQ9z8hkYd3DC7dwWV6JLqVJwj2ce7H0aezTzf0BeEUs918KdclIlWI7kK+OQThPSc62pjzMW+KLlCiyIUUSSOLKY/9cpx9vLv03pWbKf8bT2QlKG4EzRNSnuey5HXGp/YjWhFUTzBzo4/hGQA9OVLkmYx/sQsIEmzM6HYzedZDLXZEF+xMPBm86baAPfIJsDKkJOO9F9wMAJNLAj9QIJZBGJq+8MaM1D9L9t6ftozu6+u7pqgh8zorCwJmZBaWA02Ym666meQiD2yPKCpkhS2+wX6CoiHptYAlMEOcLkjVZcGxRk1FQuqXa9YFTWO4oFA6U27Etp8ypca4t8nA5fyA0nlQuYjpGCUKF61M7lngbj4b1d8gVUaS3bAIeyytV8JK8HJkZ44+aHGKg4s/N8VAoqU6TglHmg68T8Tae798XQ3DoHH4WTHUx+8dXZTanFjNI2SSxd61GtZQzYf5ILUfk//Q985iYXer6a37u0BO7JgE52qWORC5ud9e/rqSRl1cLWOSI/zbIIRF4YIIB7h/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:56:38AM +0100, Michal Hocko wrote:
> On Fri 27-02-26 16:15:55, Benjamin Lee McQueen wrote:
> > on systems of different sizes, the fixed 512 page window may not
> > be suitable and cause excessive false positive memory pressure
> > notifications.
>
> Please be more specific about the issue you are trying to have fixed.
> The above is way too generic. How much memory the system has, what do
> you consider false positive and why. What is the workload. Etc...
>
> > or should window size be capped to avoid excessive notification
> > delays on very large systems?
> >
> > v2: better commit msg, also tried to fix the whitespace.
>
> Also please refrain from sending new versions in a quick succession
> and wait for more feedback to come.
>
> Last but not lease if this is a more of an idea rather than something
> aimed to be merged make the fact explicit by RFC prefix to PATCH.
>
> There is much more you can read about the process in Documentation/process/
>

Agree on all points here.

I'm also concerned that by simply adding this conjectured approach without a
_lot_ of careful testing and examination of real-world cases you risk causing
issues/breaking real world user's assumptions. This is pretty sensitive code.

Definitely this kind of potentially invasive change should always be submitted
as an RFC to begin with.

> Thanks
> --
> Michal Hocko
> SUSE Labs

Cheers, Lorenzo

