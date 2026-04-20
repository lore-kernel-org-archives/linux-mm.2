Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D97F5A8B1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1526B0089; Mon, 20 Apr 2026 15:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9676B008A; Mon, 20 Apr 2026 15:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4691E6B008C; Mon, 20 Apr 2026 15:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 333336B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:29:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCCF78CB6E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:29:36 +0000 (UTC)
X-FDA: 84679923552.29.8C3876B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A5BAA0002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:29:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m37zDRcm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PHaCJYra;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776713373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc3fXEiQejQfJ6U5FBC9IrIQ2T+OD9QA8NQG/33MNag=;
	b=UQRQetG23eEM+8bvX0N6pd3tOLmqNgGFyRa2O8hQ0i9vyYs3lT+ijP2yaIf/pI0t2R94qE
	J8j2R0v6GS8Mc28j4yyreaiRwuwTQhI9hHUTbn3/9iAHNaPRS3457WBDRUXGqyYLOcMfhD
	Ve0a/te6wKRobN2mWu6nsWfmBGlGxwA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m37zDRcm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PHaCJYra;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776713373; a=rsa-sha256;
	cv=pass;
	b=CcVuKnufPWOc4o9t9coKXKI4r+savodAl9FYakNc/ZEWzkxvqUJFmN16sF2KHEXIFhTxt1
	qrfNYVRw3YJsvuZHIMX5ZUZzThCrkZJwC/zYd4zNliTxT+sOZxj20mlDR3uW+Gxf6pYIvJ
	GskXm6Ft+t30VwSnDhug75LmZKF606U=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KIMoeD1729809;
	Mon, 20 Apr 2026 19:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Uc3fXEiQejQfJ6U5FB
	C9IrIQ2T+OD9QA8NQG/33MNag=; b=m37zDRcmga2A7W82CevQxOvL9Z4CZQEUui
	zoC+YOesYKmjp5ZO6FeSdRCCA+UlzaanPbKoLUordLglKIHW6awFRyHYVKdZA90N
	/CSGuTbfrt+HWIRDg6r2b6Z5n2dy0VTG7USkZzzwbqlXnCupu2eQiTpvBUXhQijP
	pj8KVT1JDqIu21kVt20TCAupX734iPy3XjpxXqh/AZVJUmTiTKPamRcCbSrYYK/m
	H3S5dbtoAAVBSUFrXV0QAkopeU2Z0Wn2rGEDblfmBUEkVPmBxqYqpgt2T5jp/E0P
	xwYbu/CW/uyKc28GsAe0G1KrC6bXrYsTnZfXDoa5KgZPm6JWt3BQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2a5v10h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 19:29:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63KJQTJ6019956;
	Mon, 20 Apr 2026 19:29:23 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013042.outbound.protection.outlook.com [40.93.201.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1bn3p40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 19:29:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haHOe0o06MLTa+eoKuJHD8kaCZWKZR3hV3jbywlEhJRbRKPRSXiGOzytF/7jcxCLp4J3s78qiPC6wjUfP5H/P25s4fe42fteV9hotBj/sHsMcKLtAage3VN5o7YvsOxnMbW/Zt37azFBAEUZLC2/rhHST35jUW3A2qDGVXzIH9PpRd23fT4ywsQFH/c7pDBf+2PTL1q4AePOTrHBlwmbB9owIpU/CDfKZ7d5A0VQKX26Kt+t6NR7m6j0EaNY3pyaxhgKy3sKdjz7z+4mRuj8sX7O5LP6jXxXx1hBfITJdz3W6Dbaq1qM7RyACcUNKAocmtMZO+qOg5Tv+m8Sa6gJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uc3fXEiQejQfJ6U5FBC9IrIQ2T+OD9QA8NQG/33MNag=;
 b=YfCH8aGx/URrSmgmYWFE4j1QqpUQ6qMv8sqPkZtuRFQihhRNF4N3rNz62sNIgVqPlfIEw2rLEQwX9q+bd1+3Sx20kfBM9zfPmPfOn2ElHDYzP+ilSHJDvIWXflROmqfcNgpi9vT7OAxW1kGjZpcays4tlAFsd3e66CWLoQVbA6qqKSqoAWWFIpJtcJVE6e04foVQD+Jo+8SeT5cZ6UxptXjiUg5xMInhuwb8tS6Z2092nA+Lu540axToXMqvVMXAv+64h8118mMa63jrPOv9IJP/mNJEl+BiEtnDywM+AnfkfFiiK81CGz+OTnLQOVE1IQfCZ50DBI0fxgu920/EGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uc3fXEiQejQfJ6U5FBC9IrIQ2T+OD9QA8NQG/33MNag=;
 b=PHaCJYraEL61738Aa3wqwrdtYYPwhViHNiIKD6s7epRvQ1GL0uTH3minJTrW5fB2yE2zVL+ovD1+sFoJ0rcSJ3xAVCd0+qYGFJ906Fxg12QxM+cAwFA3bGbXpm7xF1VKgNU64Pm/oD5Xjrt1HUYXHu87grUjNzMbbIOZxS2m8so=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8661.namprd10.prod.outlook.com (2603:10b6:208:581::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 19:29:19 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9818.033; Mon, 20 Apr 2026
 19:29:18 +0000
Date: Mon, 20 Apr 2026 15:29:00 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Marco Elver <elver@google.com>
Cc: syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
        pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
Message-ID: <4ub4x275tpkop5jbx3l7p7zqeww32tb2yzhdgqqkvakri7dyih@bdxuedw5utlc>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Marco Elver <elver@google.com>, syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
References: <69e1f975.050a0220.1de265.0009.GAE@google.com>
 <twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
 <CANpmjNOG4mDJr+LSWWWJXru88yYrxG3wFBSiWzqUgn7Lm28bjg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOG4mDJr+LSWWWJXru88yYrxG3wFBSiWzqUgn7Lm28bjg@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0131.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8661:EE_
X-MS-Office365-Filtering-Correlation-Id: 38fba599-4ebb-4a04-5890-08de9f131d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Vtj75PSHTewBiR5O/9O3LQ3EkIpr0qn3iCf6+I49776hfFLKYQWiAwak6/xOUSuSkTKv9rDWP/pC/2Hsxn/JBcKLKe0OwMzcSoc+6v6REagjla7OfbmXje9ADwKZgmH28xnlCAF7b5N2UrGHCZA+9IqUAZfuXceIcD1lKxcvJlgNDVKjlu8dADNfPWTZRgXx9T98O7hRheyVIrL9epfGQ58KymhBt98n+KhjXv+Hxot84n2PQiB5rHIRoTm5dWUyOw6Twd8HoGfqRaAP1/DKjOqlHyPmCjm/gygMbBafNUaB+HdofUzDrnNAGRpFal5bY+mc6D30rmvgbQXxP7qQu15Xzb+6nTYFo7gWVorHUOXppb9BTYfzLBYPPoS5zsGm35kUI6QEzOGCL5gsQuX8Vd4GId7CDAlVy3rHMKtU1ZnFvmXC/BzUhJE9sB7kfnW9AhPcWMNTAQ4sKdgfPIilTe1/GFDLVbTkZpZRpB0kJg1vGI5FVla+GZbPH1EqJUqkbVGtPJXBdfQvtnIMtMgyaGR8HTMnvkKcH8m17PPeggrTnXoU6P0+h+bKh94ladBc731SdDHSuFwgQIZ4JnXWcUiCXdVXF+ZG2mgr2M7r1iQEWsC3S+AIFtK0dQ0Wk/V+KD47AVLQCwOXw7xWWIZeoUxZEwxV3QS4LVpA+bp05tiQY8hOKo7FlhVdI8gsiVn3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WQnw54RrCALtghlu10Rlwv9Wz/Osy9fSRH7qC6Cl9mpdQ3GyavBRb0hPQEbd?=
 =?us-ascii?Q?merxczTI5dqOZV+ciaQiFLgvr4w4SOduSBcRl160P4YiY3eypxfwR4Dh/n4R?=
 =?us-ascii?Q?VwN9vEBh+AJjDLWzpU/ZXe92/5lZRby46IDa+cHG4019oFagCLN8QmCmGbqT?=
 =?us-ascii?Q?OXujYtF74CUYPuOFAH8W1dDRM8CT6F0A94IO45ZjuD304MEGisc9JPddAZHN?=
 =?us-ascii?Q?JWQCwcXgBZ/AKsyWdxOwEsl1k7sSpKMzKYpAaoKps3vDVwgOEthMa//Xd5S6?=
 =?us-ascii?Q?iD3alMT7Ks3Q92xgCsVf+WEfTWoYKL6fmRs0i/PejRphc/UoCVKlMGsk4jh5?=
 =?us-ascii?Q?7YVMLyiAKrIbRpA8yL2vOKPQczijD5fyVQjNf4/jk3ELHwsae6sWBNQW7EjI?=
 =?us-ascii?Q?Arm3FN1ghjW3fhMcc47QPV5z1BZ1vTYVxU6xhV0BmJHZx5uyaVpV33Ft9VZ/?=
 =?us-ascii?Q?BSJgemnm9xHQM1yV27mnowPa9AplwxtadF5UCSDMfTd/kym3fUHJEaSDpZT/?=
 =?us-ascii?Q?c1qbGELVneJz1zfA4g1mjKO2rZf58Z8QxA5zzhTPJzmdEWDcgRIszXtUaxIq?=
 =?us-ascii?Q?sH0TTQmSPSJpRtD3BiN0bF5pDCkl5dXVUmzdUJrJmvogp4ge/K8WKcJUIn5b?=
 =?us-ascii?Q?1lFbWjuVX0RJ8aB1Vqks/Ecozqhehlb9bHmWy0KX9ZwvoXi3QIGJ/CMgeLWg?=
 =?us-ascii?Q?ijL8e7PJ0Wytj+7S+7Fnjh6lP11ahn50sPNycZXfcHxuHJ+FIoIbaA5H8H2q?=
 =?us-ascii?Q?sO8lYYTHuQwKmGg1cgW75CQDoGkseUXxUxVJcVJM/vPn2dKD1j3o/Z7iFeZt?=
 =?us-ascii?Q?TbnqHwzWfhsvYafKvdb0j0e0RiEKSNeew/bvFq8xcACRtJuCdRu7BzzasxEv?=
 =?us-ascii?Q?DoScdQ0a4nCuUdX0eYXYNTm61jHgg8/CrdoXKFFsU2wJKJan6xqYGr0gSD1w?=
 =?us-ascii?Q?+JI0ynLFatM8iRIcCxfn2G8OdcZXblIGJm7m5j6zlJ05c5opfI+Zlk+QEcHG?=
 =?us-ascii?Q?ixP1nUEMdzdxi/vYcFFt/9D3tPh1OPCsfFI3ERKJypBje1GaUx+J3fTpi1cI?=
 =?us-ascii?Q?f+xdhmsJxnMGe07VugSPWbBGjBE7UJEZEsvVTEMglXGwt5UM5voMvNnfptN0?=
 =?us-ascii?Q?C1DCzmEGOywULAoGECy+u5kgFso0MV6QXvDYHtWCWeOOFjuOOHkTR27JXoWU?=
 =?us-ascii?Q?FIyXILJ9gy/aR58Cte4nZohQNZ7Yu/2ZrUE68Otba0PLqEmhqRVedKDjwgA1?=
 =?us-ascii?Q?wvzBgH9zK2PbZhdMC9n5lpxdfb+Zhxd6F4XOOxh++4Xb7syhk3jkZIyRnwEG?=
 =?us-ascii?Q?rGMgwZ7XjcL1CQUyF0ZjxxbpYZ+kOPXHosiwVd4s9ms+MQOdyIKx+RhD+aYQ?=
 =?us-ascii?Q?ekp53JFroD3w/czPUdkkIUY0GwnXEJmmlSFjWNGSR4yDj2a0qWlMWPIVnrdW?=
 =?us-ascii?Q?e9tuTg8rljPdb8XiEPkzdtPQWxFel4O5zk8tZyiODHR/RWurAkWC6fpFymZL?=
 =?us-ascii?Q?LAGK9beWWS3IQvcWsYoNeboUmnXOemVvB5VfwR7s95YxSew4fgmK1gRQcFSo?=
 =?us-ascii?Q?xo5Tsb5A0Tc1eeBY+LJcbTLopQ4fbvtl+VJ/7iY159n/il432XoFmL/QPSfa?=
 =?us-ascii?Q?ESkremAWSr+MS2XfHXM2332ntQBLvLxWyaV3brIvQxvyuAmvnlttbz+6kCcZ?=
 =?us-ascii?Q?7G8zEvV8cKb4w5dwV7GhzBZ1aZojmsgxvsT+EcnK+TJfI0pa/xI+clWclAgD?=
 =?us-ascii?Q?oARVkaqO7Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	M7U+tF1+AseuVfAyAeLVHIz3smuQkvWwsIp9rCyvHUYnUk6dn+ExhVMtXB65RcY4JbL1Ke744v5bzbuTHZmJ+oQWDzSFl+zV4YFrT/B8aCKjE/445du2Bu1XD/+laOL1u4Dfk/i1A1X78Lij298g6Q3O40wnrmibzQKSXXju9Qzh/mv553czKpntAn/Jkxy4AhIw5ppYoRUkW078qZUVGe9mQ+CvYvtCf8WSMJ23HISRHIQhKgGBuCjO8td6StSQ9NTUOjZmLMez7Qn6AvXZWs5K8rm+ABR4+P0GsdUp7QieQnV7y1FsYKqCSzEDhAyKeMz2BNrGCYN2gNb8+ASs7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5z0dCI2A1IQdZjMLLB/xVUV/eMvBMOokc6cdH7/MM4w1iaTDOgKewE1Idtd9gtAB8Owweeg4K5/0jl1dCYs8C6ehLuYtJwqzORvVPIvjDbIU2Rq1v7mUjC190HS8IlpawjnCcZFkiJbiNUBJfWFU1eYKtyT+a30yrBM4ZHZ5HurLogSn/ArhRl9irDTXekSucLFKwD2kPVtPrgv+0oWTOWwI7KlWj/w/yZK5rDAYqxYtiy9a5l8Y1qlqn0VeUT0t4wfFR9iegwgIniLTqfBXY1jQXvT7W7vPNxuG6WVWhwkoyMb+av9OWDSUZ74ndIW+d5RS5KXFyeTtS2INKji3fqTuNufs0RDF5XDITQ35CptZlAzCVHHov67O2+yyNxVyb6NmSrh27BSwxe8frOKlwqKG/9C0+CBCWincjdJyhGTlQ9AvRXXbz5gER1hGrESuvEGS3QMdm6ArEdrvN4nSWRQ7loMp2NGIoQM0eGaJBzxduMGBA8lh09Yjg7iWKHXD76BwVboIrSLRovw6H+xSLRYqs7ZatfMJcgx+r2JtjloYRSifjH5XfNJt+higg/dptF7k6FZtDwovnhmoNvvM5SjmIRwl9/UkAL6xSNdCUUc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38fba599-4ebb-4a04-5890-08de9f131d50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 19:29:17.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dgwM6JH+tg1tjDokSvnZX3GdxsOFUoFaJa4YX7bTHRG15Z/FpCyzKZ9RpLg5WdGwXW4bxLb0c6evxwjDq2LwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_03,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604200189
X-Authority-Analysis: v=2.4 cv=U46iy+ru c=1 sm=1 tr=0 ts=69e67e94 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8
 a=1XWaLZrsAAAA:8 a=4RBUngkUAAAA:8 a=hSkVLCK3AAAA:8 a=NEAV23lmAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=WOBIqZBNVHUdh6dRprUA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=_sbA2Q-Kp09kWB8D3iXc:22
 a=cQPPKAXgyycSBL8etih5:22 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12291
X-Proofpoint-ORIG-GUID: AiioCDtfBnLjCGm_3c2mgFW29_ySYLID
X-Proofpoint-GUID: AiioCDtfBnLjCGm_3c2mgFW29_ySYLID
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDE4OSBTYWx0ZWRfX3EHwTqJZhwkC
 G8XNlX7y8K1VhXaoaeDWWqklg13Q9hYZj8qFbFRRM2BujJlfvoAHrOZhUQVeC0uaikrxlZMZJKG
 JwjeIfcO+OwB8nLjS0e8U1afb6DeMjXABk9LTeMkciLXqdGnwyNAtPXcCV5PhugPE5oE0UHUPcO
 T+HXo5Nq3uGrG9AYT1xVetysmkkAm+0Gufbcq0HpaMvVxmHXX6XImFE0xOM88eolGVIgLWrbd2C
 hmr9tDwI+PtuvHN56o9o3ef40LrL0FMNv1YCbCSpoH3SM1GPkTuCNeq0urq4/0WNyXZmnXMjNl0
 vJFLJjflWChNCYee1SQILXOVAzLs5Kc7xpm2BuuCKq9NgWkL9DaXIlch2SR36VMNd+u4vSdWFw9
 GN0NJhnQvs84CgQdrm7wORrBRguDTrUq+ilLpRBUdnOfT34bBLRwUctGyGX/1HcKXkIU8psAGD0
 MCuFYYFq/QgIBOKmiIjWYF/KZixeDAqWTuxlU6no=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A5BAA0002
X-Stat-Signature: ofunqm5yfo1fehdsrfo33czt5npqc6k5
X-Rspam-User: 
X-HE-Tag: 1776713373-873274
X-HE-Meta: U2FsdGVkX1/Z9veaQ4UPvHDsAYtUtX2SCVL30TnLi+vQc65bWqBC9XF5S0V/1tLJ82mW80ckYn114dlHaZv34Z+2z2jha3IFW9Tt8UWRNmKzJ8htOgbv6CQqNdciOplhVtvjIP1+x6+TuS6Gu4q9UKyot7wyF9fGM5CTpLYplyMXGJFwCUNEpH/ZKaAj4mn7DtYuWM60IZhlt5LHDpyPcbmFvE8GoMyL6dBabHi5vCRgl0bYU4s/O5j0+MVBejuxd/3FGsu+0e74gZDom0hGUzHtzw9hGZ7DdzcHFf4MMrRFPZ6rkoBt76nJZWUYvbZsDZu+KzOdVoH42UvjOXLEI6ZRV02lxwJx2Vxv4lEAOxdrMzkDKI0Ru8AhxT7YOqLT4BsCN4vQPzK9J0HmNk/P67UJ+fgeh4marIeQlRadhCx03tFM3rcosAj2YB0h866acPQsofbYahOrHi6svuIWHkoNBaXJoI0QyevAuz/fOPBAwlt92zeZMbLj7o5svsem3X0aSkZucQZ90TNsIrg4miQajA75ZNIdJxOjh9q86zUfWGnj9WbyrE1WDtxa9JfFFdUwd0cbNRbVwU/M84dzn/krm6PYaay5IvewXlx7LkCojJH//yQHmBzd4uCQmZgEjMNtXmoQ9o9ARz6nb079iH4aEiByd39maAIDcEr8wXS3YWMdI8uQTvdQ4iL44McCFueW8cU2fevZGgpeHpem190aEzLg8MTiL3tK/qOCSSh3k11+T9L+AEgS+S61804XvYiCxovldAODK3//+qYLpkG8RMwoRlitBB+Kd2sI0nH7RhQs53O4HhwvFvL3YgP2loc2WIOahAVCyWiK2dlGA0tNeUwtnArJkInHgEh7xGiVs/aRiDkuXGT90VU2v80HFfMFyXJwzNazSGPZcHKqiNxKXWySJzCZErLgZg7dalQfqBw2/Euhdr6G1lnNqOaUOmM5BifDbzjjaKUbNOv
 KXlGDDW6
 yc/Upqc47PhbzLKsEz58f5GMl3470SeebRj2LkCSeeOy4iUKRgCrkOTPWuqNVSfG/ioyzR0wvOdtkOuwERwmu7Do1DkwvmMF8d82rCEnr43xCOaiwx2p0x/XfJeCpmCeVGkAaa/giqz26MxXo0w0ifAV3wegXeKJkQF6LWECHDsYaBrnLZx4WaOCQK1YrU6DA6J56zlFa4HLjSDd4d7JeSlOnsbOHRakJ23X0Kw6qg0M4VMbyQh6G6OpYl/44z+AnKi/rUU3wYUcgPzvs1yd0Ueah0R+IDsVnuvnWGt7sV9uhMTcayDFaWRutA2Gp0CxsSKV2sMH18uW9xY1weD9BjMh4MtygwO9d84NeOwBCIicVINAEy+Oa/0SOWd+7g3cjGUtVFL2N2GEKMR+ISM4FYvVHsPkfidUc6H5uMEbwSOIJG2X8di3bdHJEJ3CCYAU5y9Y6xT6uvMcbJ24NYh289nLO4LsegmMeTIOksIgUiksa/JEGqJE7CrKM27JQnR3m6YnzIVogn7Iyz3SbgTIekYJFpt9vjgApNGsY9wuJB6S/Z6k5IOlFRAMe0S/zhEzxUJySQmXs+IScJUFb6x/Qt/5a38h7Nsh9DATc6EbjPFRZcZut9/dk9hctauflZpGK5IjRh72J7ZvaHEOSr07gi5esxb1dfCmNi+6UR085CaFIWwzA7ckH+teI/N7H3PoJ+TItM17qL4j115f+D5JBlFtVaOrzcj55b4MByMh3oSDUUXhsyeAq5AZejpfvK+7oGsHAfKAlpacykUhhSRAST8uWQJ/k6IbvMLoXDm4jUkoJ0Q/DxgF6ynSfIMUI3n8rb9gouIqnCTK6CBRImQHdjTE/4bsO7DZcagCbvq/EWGqf+FO1Q2BSA8LNdGVShEmdhDvGtjdX66HEd2Je4GiC4/4TmkLwVHNv5Y9hN56KgLgI1oFcBVOxe6FK3x7mr0P8N//H7SlDQeEbvnUvJLpOeYrGfsey
 6Ni2leXq
 AIJKoTSxltAecFd5YJrKcDKdPTa1tWxgq6Ofu8Oi6Dte/GVjwuhaV+kA87bKED0bfmZ8hLzDM6nAZ1PRniLqXuwdlevhy0ny/fptfvqG8fHPKybL9BGIGp+LcV7jg0cEbdajFX4A4mXfB8Op0A/wUgnNoUIcUxMaZtldgJmrcvCyxlDFCl8m/DIaQ+osQX44lJ7INms7A89RZImauHYmmmkLdqwUNiuydBHdltSpMqTs0iYwkTDoQSpDzzCWjiMHb1EEkEipRu4mv6qvcPitV+ahgCYRb9XMVs1LnJjPGZNiQXTEmScglpQRg9tlfsG7NsU9w6gIHuqcI2T0TWJMCVbytVXAyZwanDApcBpj4W5Qbj0t/13w8s5HhhFrAyOonHdrL0EDAvvtsjeVTb1DMIJT2HVbADW59OHmlrkh6lmOaoWa89s8xeWuC+0W+E1IQO8tK32qn92hCx74GzV80iYKX/P+D7vUYXARHLt+Quxf2f93XcZKPPgHA9gAnKR+14+2MPI8Ef1zTo4TqiUSt4aAk1SS9s6/3LRdBXHgL+gdFE5I43rTAiFNC3VdlEs5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Marco Elver <elver@google.com> [260417 20:26]:
> On Sat, 18 Apr 2026 at 01:51, 'Liam R. Howlett' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > * syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com> [260417 05:12]:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    1d51b370a0f8 Merge tag 'jfs-7.1' of github.com:kleikamp/li..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=117dc4ce580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=7f207c4b1fbf85a3
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=38a879f4a73497f2dfef
> > > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > ... and you won't.  This will work unless we tear aligned unsigned long
> > writes/reads.
> >
> > I'm debating marking these as data_race().  Marking them all as
> > READ_ONCE and this one write as WRITE_ONCE.  It seems overkill for
> > something that won't happen.
> >
> > Alternatively, I can move the slot store fast path to need an
> > allocation, but that's worse.
> 
> The writer:
> 
> >   rcu_assign_pointer(slots[offset + 1], wr_mas->entry);
> >   wr_mas->pivots[offset] = mas->index - 1;  // <-- stores pivots[offset]
> 
> The reader races here:
> 
> >   if (pivots[offset] >= mas->index) {   // <-- load pivots[offset]
> >       max = pivots[offset];  // <-- load pivots[offset] again
> >       break;
> >   }
> 
> The compiler is free to reload them as written. What if there's a
> concurrent update between the first and second load?

Then the benign race has happened.

Looking at [1], we see that care has been taken to limit the slot store
code to only !rcu mode, except for a subset of cases.  Digging through
the information in git will eventually lead you to this note Peng wrote:

commit 64891ba3e51fb841b0af70db029038eb93bd5a43
Author: Peng Zhang <zhangpeng.00@bytedance.com>
Date:   Wed Jun 28 15:36:57 2023 +0800

    maple_tree: add a fast path case in mas_wr_slot_store()
    
    When expanding a range in two directions, only partially overwriting the
    previous and next ranges, the number of entries will not be increased, so
    we can just update the pivots as a fast path. However, it may introduce
    potential risks in RCU mode, because it updates two pivots. We only
    enable it in non-RCU mode.
    
    Link: https://lkml.kernel.org/r/20230628073657.75314-5-zhangpeng.00@bytedance.com
    Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
    Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

So, you can see that the author of the initial code did look at race
conditions.  I wanted to read the link for more information but that
link isn't working right now (403 error).

-----

Or, we can ask an LLM about it:

In mas_wr_store_type(), we only allow wr_slot_store in RCU mode for the narrow
case where wr_mas->offset_end - mas->offset == 1. That condition means the
update touches only one boundary between two adjacent ranges, so the in-place
mutation in mas_wr_slot_store() stays limited to a single slot/pivot boundary
update and is considered safe for lockless readers.

If the span is wider than that, we do not use in-place slot-store under RCU.
The broader in-place path in mas_wr_slot_store() is explicitly guarded with
WARN_ON_ONCE(mt_in_rcu(...)), and the store-type logic instead falls back to
node-replacement paths (wr_node_store/split/rebalance), which preserve RCU
reader safety by publishing a new node rather than mutating too much in place.

In non-RCU mode (!mt_in_rcu()), we allow the wider in-place cases because
readers are expected to be synchronized by locking, so the stricter
lockless-reader constraints do not apply.

-----

I am sorry, but I don't have time to work through the scenarios as this
is not an issue and I no longer have the time budget for mailing lists
as I once did.

If you can come up with a problem (and ideally a reproducer), then
please let me know.

[1]. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/maple_tree.c?id=c1f49dea2b8f335813d3b348fd39117fb8efb428#n3696


> 
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/e08ff8d2b0e5/disk-1d51b370.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/c11d4b098bbf/vmlinux-1d51b370.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/6a4691f32e3d/bzImage-1d51b370.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com
> > >
> > > ==================================================================
> > > BUG: KCSAN: data-race in mas_wr_store_entry / mtree_range_walk
> > >
> > > write to 0xffff888104f71d08 of 8 bytes by task 4757 on cpu 0:
> > >  mas_wr_slot_store lib/maple_tree.c:3232 [inline]
> > >  mas_wr_store_entry+0x3405/0x5ad0 lib/maple_tree.c:3528
> > >  mas_store_prealloc+0x43e/0x690 lib/maple_tree.c:4936
> > >  vma_iter_store_overwrite mm/vma.h:616 [inline]
> > >  commit_merge+0x6a1/0x720 mm/vma.c:766
> > >  vma_expand+0x301/0x460 mm/vma.c:1219
> > >  vma_merge_new_range+0x29c/0x320 mm/vma.c:1112
> > >  __mmap_region mm/vma.c:2766 [inline]
> > >  mmap_region+0x1073/0x2110 mm/vma.c:2856
> > >  do_mmap+0x9b2/0xbd0 mm/mmap.c:560
> > >  vm_mmap_pgoff+0x183/0x2d0 mm/util.c:581
> > >  ksys_mmap_pgoff+0xc1/0x310 mm/mmap.c:606
> > >  x64_sys_call+0x14df/0x3020 arch/x86/include/generated/asm/syscalls_64.h:10
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0x12c/0x3b0 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > read to 0xffff888104f71d08 of 8 bytes by task 4759 on cpu 1:
> > >  mtree_range_walk+0x1a6/0x490 lib/maple_tree.c:2032
> > >  mas_state_walk lib/maple_tree.c:2952 [inline]
> > >  mas_walk+0x1cc/0x370 lib/maple_tree.c:4366
> > >  lock_vma_under_rcu+0xc9/0x210 mm/mmap_lock.c:304
> > >  do_user_addr_fault+0x232/0x1050 arch/x86/mm/fault.c:1325
> > >  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> > >  exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1527
> > >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > >
> > > value changed: 0x00007f68dc2a5fff -> 0x00007f68dc284fff
> > >
> > > Reported by Kernel Concurrency Sanitizer on:
> > > CPU: 1 UID: 0 PID: 4759 Comm: syz.5.348 Not tainted syzkaller #0 PREEMPT(full)
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
> > > ==================================================================
> > > netlink: 64 bytes leftover after parsing attributes in process `syz.5.348'.
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > >
> > > If the report is already addressed, let syzbot know by replying with:
> > > #syz fix: exact-commit-title
> > >
> > > If you want to overwrite report's subsystems, reply with:
> > > #syz set subsystems: new-subsystem
> > > (See the list of subsystem names on the web dashboard)
> > >
> > > If the report is a duplicate of another one, reply with:
> > > #syz dup: exact-subject-of-another-report
> > >
> > > If you want to undo deduplication, reply with:
> > > #syz undup
> 

