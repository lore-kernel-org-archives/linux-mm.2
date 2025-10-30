Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D82CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 20:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515EA8E00AD; Thu, 30 Oct 2025 16:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE378E009F; Thu, 30 Oct 2025 16:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EA18E00AD; Thu, 30 Oct 2025 16:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE158E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:23:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95130C027E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:23:21 +0000 (UTC)
X-FDA: 84055905402.13.EE17F48
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6B6578000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:23:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mF5Bdlpu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=en33Og9A;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761855797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rRXXtnSqUVAPr6R4Y3+rB/FQtcNzs3n2QtOpBqcDe0=;
	b=3mbYMLXdP3hb22weof7Tqr0JIzbdq5pUy+aqnj7Qf3Hy+mPZ1Mvp53AN4PVrMIbVforw4X
	I/nafT9yZ02aFcr0phanO5sytu5Kwj84REdxnM6CCCfAEQotIvynHxlpd6TaIKUqpQaMKo
	GpDzz0DFmsqN5axoXvaTZYd+lxXebcA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mF5Bdlpu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=en33Og9A;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761855797; a=rsa-sha256;
	cv=pass;
	b=mk/RpkrasfhfBwup2VGt5EvTu9HRADwSvWRTMpnzTffimhBJTJO9mQRvmBjqUnjgXOrP08
	nhEpPeyjW5FVbjDRzhQKR6gflfWqD0/x5d1BR80wRUzoyNbSpHeV+s1tYho+sBC+2Ys/SE
	dUDUNHEJUUu0RJCXvqwnZaGuTCCQSZ4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UKNABn027622;
	Thu, 30 Oct 2025 20:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6rRXXtnSqUVAPr6R4Y
	3+rB/FQtcNzs3n2QtOpBqcDe0=; b=mF5BdlpuCBdIhdJuLrVWvIk9z1ic1AvpeI
	SrFrg/JMnQo6dGMdjkpNzL+oHzDJMaV2QuedRAAiWV4VGXbkfOeCpuiSytFnwP6k
	Oq3Qrj2hA2ib+AM3zwVPybsO9NRcsrwvW3yoLkcRB5o3oHVFjxpJakQfm3ausF0y
	/jJNud+bTe092OEE/k5bO7aLQgb1aLqe6tdaiUbpDFMVAhgEFNluZEPqrVt4MLR/
	PD47XblY8BobQYHF+ZHhYouN1nvhATLYQmJz79UeJ21eUCzRFFsT5GUayiDaZxmt
	4PFcTMBbruuxDXyfu/nQiA70+I0MqPigyy7tWisK0NMJJDHwTndA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4eky81ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 20:23:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UJq7wh017308;
	Thu, 30 Oct 2025 20:23:09 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010038.outbound.protection.outlook.com [40.93.198.38])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33y15869-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 20:23:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHVUSRlxivDMtkgHA4zON4dw3clVTMb1ca0nF6hlnhl8WJpIqlJllkOb0WKZ4ES3ADyGXGNpsbTC5RGM4W+vnGoz53Rs+PfSCxke6Otw7oaUO7yqMrwN93OADanXgerfaL303nL9yM8wT5os/uWy4N9xNwiyRI91uNayMZJRyRjd/W4c/jiHOPzjpapd/BwushtxRCTouLZ48Qu3etY/w2CBnSxmK1ylsF+Cebh54jPUYYTvZVPdJSRNw6fjSkornqCJDgFwq7OL41s7RAh4aMeLYS+sbry+lZYtAcUIwHDBfmGxCn9PAVf9eV1w34Yyg87/daIBRgjvxs1lxM+dTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rRXXtnSqUVAPr6R4Y3+rB/FQtcNzs3n2QtOpBqcDe0=;
 b=fchP2ANFY6/KsrPCcV/6Ed7MrVjgu2kh3Rjdn9D5Kj3atsgNF+EKXkuAbKQ0u+HP6MBPYfE9gmsajiT0yYTzV46/I7ZerM544spxjpfAYN2s4WgVwGPxG4h/e1nznc3sjqOQErM140wJs46JXpA9jn1hFswwwP/8rim4dIRSL1nPKBNcQq8ubqq1KkrmXWPYZa8VIPkfdJee/j6gycscnHX+HHFyWByXusfvyhpqiWptiFxK95kY0siUNTuFtnHEr8mRfKs3N2HnRVr3q5yhP1e94CvXpOXn2vhmL3sk6gWHtmAHYv/79jav2qY6cV8Ry7rH98V5DcwsH0lROenOmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rRXXtnSqUVAPr6R4Y3+rB/FQtcNzs3n2QtOpBqcDe0=;
 b=en33Og9Aa+1RFfuIfDm9jfPi1ps/6i5f0Mwhf1oqC9LmWuFOU1crgihgf57Bxv7EfSEBLAN58Vvwl9s6dWj4quCIXMpdJ0JZltb81ERk+GU1LEn852XiC4sZM4owfrpjiWpeMenzIqHtqEnwaVhw/lrMxQ1O57TEwJ+qTC0fSBA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8057.namprd10.prod.outlook.com (2603:10b6:408:291::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 20:23:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 20:23:05 +0000
Date: Thu, 30 Oct 2025 20:23:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQPCwFZqNd_ZlZ0S@x1.local>
X-ClientProxiedBy: LO2P265CA0396.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8057:EE_
X-MS-Office365-Filtering-Correlation-Id: 67759dc9-7c9c-482d-53b9-08de17f221f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v+nAY2/TagJCqD/ch6f+VwGs2u1UporM+EIV/lbNt5pyQj1dVJ3dbs2ofkrS?=
 =?us-ascii?Q?QGQKAjCDqaBHg0TKUBa4sdK9xx7OLG/JelRMYDtiGvdtsp/YCAi3wuLyZex6?=
 =?us-ascii?Q?QZRkBebbYXmtjq6pVQNR2KNzOWFuNoccBguYjY7ulpKIdBjpwhAUiySIYYiG?=
 =?us-ascii?Q?FTCdDJA7D/AGyq2AWZJlo8ftdpmd5MQmu2gGcsOzPB8aeJn0YkRVnW0x9sb+?=
 =?us-ascii?Q?llK4+unbcPM+xfMrz0hKoN+0Yn5spDrJLDB055xsZZNuVbLFKEzo1Ukd8n2A?=
 =?us-ascii?Q?sicJBl0QHsr/8dDFngdYUZWzDWSwMVNFX62/g4UheObqYHisHigT/kB8BTjt?=
 =?us-ascii?Q?cHNlCfZQGRfBFnsKHE2Y1H/cksCDUWAsscfzQcIU1/Tf2xJxb4AqkjWPAnoe?=
 =?us-ascii?Q?Zde/ZI9ajHLeKaFaYxGHl/+QxSA103rsGiwZuMZiyO4UHcD37MIpvw92ETx6?=
 =?us-ascii?Q?l25jRSJ34r+smGNkp1jc9eXRe8QIyPzSeahyufFGoBtc0kRGCgtGXljzlVNY?=
 =?us-ascii?Q?1ry2Ow2RUQ23FIVzg8Frm0aSpSo7X8CBkPJQ2GGZZ37ROM6HsNMG4eCqZOKj?=
 =?us-ascii?Q?xFw4bvYxx59kUXEpEG1Qwj4o48afIwCMylg1LiMfBXoupiZxKaWL99tzgc5y?=
 =?us-ascii?Q?bcWM3vRTW4kLjEcsSYipmgZhKi81rSQdWDCJkwnIBeUruHUl2DP+VZZ2wtTI?=
 =?us-ascii?Q?rE4yjFECUSYE2lJ0h4Y4fjdKi2etscEBmIBxKtg/JS+ca9WNBk06rIKa7EQr?=
 =?us-ascii?Q?e1kAe7ipRR5e3d9BBTqLE/XTW4dwWnpggIQ/UYoWTj3MeNbBLIpDTZFzEVAk?=
 =?us-ascii?Q?2PjrEUjljanB2XcjQHV7saIJQtU8yh26nOwm4WIyYS+RRfd5+7lyRik/n9f+?=
 =?us-ascii?Q?jiE33ppm6MsXzFZDKNR3C/1WNPhaqtmDQGEuLHJSfHvN8dEKuTxlXkR/ajY7?=
 =?us-ascii?Q?/dFUQjcgSAAh/GDmpgy7jIUf0XwB8WgoYYYzw/dd7SPkjer/bG9wUa/GBjWU?=
 =?us-ascii?Q?P2OgudezMYyYwVyiTl5QQKyiFURX178OYnPGGCHZtBDDJUr0xhdMprbSqWEZ?=
 =?us-ascii?Q?ZvAqir8TcuNJARsLcdMedfXsircjzu24HBhWuXaQUzZKWnggkrQfUi6ReCeC?=
 =?us-ascii?Q?L1tinQgz5PClQwuaW6YOpWkmr9dR1Ah3xRMPCLmAC9eGw4F0npm1i4+aiD1t?=
 =?us-ascii?Q?+pI2RrS1BRmmusH81BxKkDQFgcKLc3fLLm3a29i+rxIVfdSfsvdOa9ltzvj7?=
 =?us-ascii?Q?hZ98o5DBcOtn5kB1bFVBaQU7Eicn/pex+Fu2UDU1T6aEo6/U/iQLiLQ8XQ+7?=
 =?us-ascii?Q?iWR4jfmjyE7CEB3wQ2yyETGwZ+BCevL6/QiRmM69YWNmE20DxnpDy4ZmOwBd?=
 =?us-ascii?Q?HXmP70uBqWaZnI2//PxcrrbahGiCdNm99Hjvj1unMcM39WLyLw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qaAcOPvrzvpe6vs9MqnyazONmeNAzIW0Q4l7ffoR4nsmvB5NXhLYBtDUySOp?=
 =?us-ascii?Q?lQx+Ye/EomBC9SOL1xje8b+rU/kL8VlTNw3gDFJJIdU/Pyl0/En/cpHb6s/5?=
 =?us-ascii?Q?k7yhjQrW1NmzmogwXJUDAW7M+vxlfveUfLgP5IWYdJmCedfrG2mG9c7ZvYYA?=
 =?us-ascii?Q?xDlXDIiYAY+y6EPU17xg2Axasdl3u0caCOV3aJ1kHN2bqa2GJiHAV6Iwz11X?=
 =?us-ascii?Q?SZdxGJE+JIu0pnMvJwx0xy/bqL2bCE0IeAJQHwuyLfXmM3W3MyOdbe2Ce1Gn?=
 =?us-ascii?Q?lcmMI5HOTAayidt2eMRzY4VW+nwHUQzu6btxYQ1yTtjyIsH8ZOtP6V092NcY?=
 =?us-ascii?Q?NQqmjlRVYLc4TAj9xZZN7XBTepHbEnWuVdrfJLCqkDS0ks3O2xxVmoCS30Ds?=
 =?us-ascii?Q?8kclgC58RMH3R33ir2zMWamWMCBanZoP1BhSh496NHMFAW3JBz7Iul4m3VMC?=
 =?us-ascii?Q?GWevt1U58f2jqI89fSJo5KEJVwYNE5wGJyCa1fa3xaX1/RVCLZRcz2Flh0ZP?=
 =?us-ascii?Q?Sg5umBbJAX0YRt1yMcCUKaNl1aUxNF7Zw0IyU+AGZENu3+tsavVovxggUPXa?=
 =?us-ascii?Q?j1Xba0DQPOA0JqL6UxcSECqMe0gSvDlRaS4G3kPlwe+SBm26dQXiycXUianH?=
 =?us-ascii?Q?3vffznastXqL1yziVFW+59K0gOxP+SOWjjZBwosHKDaQIQVdwhx6KGiwGNUm?=
 =?us-ascii?Q?mDuDhnnvVV4Pth9AycstYpEjejvVfGwICZoprwwR3DzqGNZKtwdV8Iviuubx?=
 =?us-ascii?Q?ycn7ll1c5bgaTW1W7gO8BXlopysn3YZm4gb8tLGOb1ktLGDBTf24x5G0a1I1?=
 =?us-ascii?Q?AOHv6Tb3RQLtxVkMVR5wgm3sI3DFnJSD4Wmq+OTvWssecJFmjd3G+TiPJEnS?=
 =?us-ascii?Q?VI82dvGG78lDhVPEyo5hKvxalV4e1ZvaLc+M6kKLCe7sQIQl7G/nnIrp4blx?=
 =?us-ascii?Q?YqyGItsYl516dtsqtVG/+pb1bIlLyJr01K0kUPS/T5G3qruVoxp/i2632uA6?=
 =?us-ascii?Q?FZdfVXy5cWJH7fcqSi50lEsyAhjW4zTYSU2Epzu8jzKkJXK7t7bApVbo5QSS?=
 =?us-ascii?Q?KLewBNoNcwc27bDYmI+NJq09XAjZqFCsXoe5quYYgivqF1G2zoEOp7FS8pnS?=
 =?us-ascii?Q?9BI08j/ATS5Kp+d6lZLRY/tFTiHBdMcwPtJ71gH2ARJYW8lS/Lms1lJn0vkx?=
 =?us-ascii?Q?GchCutD1EBBZwWzrTBGMmPZZoI1zwDaunGHOJta7gdT9AINJSyhicPwsTYID?=
 =?us-ascii?Q?3hje9jvmBY1GmgsZuhDoj+CBXAXiUqMnxQ7hZdtv+7TM89sQCPXo3hZgfP1H?=
 =?us-ascii?Q?SXOE9LNctmFzNszen4XJoVYwRQfl2pe5Ho4ZJT/XTHCUuYEntcXh6bnaCuCm?=
 =?us-ascii?Q?Ik7YgUZdNJaoIZIPeYYvdBjpiR/RH1d+7wgaiCNGq6YR96ORr2oROwQktyTd?=
 =?us-ascii?Q?MTDZNDFDiKQ51joMsJPE8AtDsbOzH9WY6NjqGtUTk142EiuYRepRMlvurV9d?=
 =?us-ascii?Q?P8Oj/eTmrXGD5WEksH0lM0uUTbBdC4EmKSKeY04GAy1h4HP4CBb+dqOGE5Bc?=
 =?us-ascii?Q?MNi9drNaPL43oOKfLq67UWY6dDEYeqVGvV+n0/6OPeUizqEaJvKDKHiYxxEn?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o15UnFWwxgkaaGZKnxz1AXIiw4H2Y0D0EVxKt13oXtYef9qoYFo0JQ7Uid+CpJ4kO2+gyygwZquEq3683RQJds9C3zu1k9ESdMQ+tp/A7WgDF1OKemneZstgeSsmqJfxUuH+Z8dudzYYveHT4XHppX3sx/17n/TmIOzjY1uafDZ951IpUXM7azX3h5lOeALFuJ4xufqd6+4gKAZe81Um/7iD6F/nDW4pYIa4Z0G5TsNOSkGna6bmYobXsfFdnW4PIaPMbpm+IbDzyrihxCFvLTqhBk0f4EPiUDLwvtBF6DenRaY0xfALd5sS8x/FEbOq1a2+/f8BAQB/18NWgLmo92qCY04M/vuOw6+AsMguq3+Mq5gTpIvj5QG/MPChCqXcUm9SCTamkn0Txw9/EGhy0JfyGC8hYdZAVRlZhyd2l2Bswjt5uD8QnsI0nWE5Awg5xhXhVtMXWXRftqyWFS0iIbHH5MjGZKARTd4QpkCNDrWbVZT5MJchtSOQt54LCM0Pu3vS0LNcJL0umIePuJSWVlYH+HvepNR8D4ljvvIA7WSlmkTKW3BDqBOi+ms5PPTw/u9F1YG1knWx1piDH0Y4UyQDzzWEVc/N/eTNWdrBDS8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67759dc9-7c9c-482d-53b9-08de17f221f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 20:23:05.4257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 254gw56p2bW43k0O+LinbHrdKSy//iLjLNWyZ9njEnrQuP7T1PINocDV9L32goiV8P2aHXUGvMGrE1jjxYe8fwmP7+Gg2SbjZYsCyK6Nqzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8057
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300171
X-Proofpoint-ORIG-GUID: LPkmgVt6dsodj9baqPUkuA8RMCDt4m30
X-Authority-Analysis: v=2.4 cv=V7BwEOni c=1 sm=1 tr=0 ts=6903c92e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=HFWw1nN4LE1eSrYITmkA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: LPkmgVt6dsodj9baqPUkuA8RMCDt4m30
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDE2NiBTYWx0ZWRfXzvkqKDVJoQde
 Y/2eRkSK4tiyjN6IeTWaBbaptyYkKcFaJHdSp1MeFL4g4hmRgiQOe37P7OvzFP19IeHXT/p6CI1
 M2klzexoJ+ifysFcb5O1EUnhUCJUtMoT5tuKNbPZ1xIrAaUnCqtLtMcJgR9Wq+4ygRax2pVI9KL
 PO7Vda3GpoDTK0IhQqDTunkgH07eZNOSLRAP8XHxsaDQgijhZ11vU15HVMRcFqdIIeQmeavmrdr
 cQejlqu5uoSm/TMHbVW+QTLFCow+Qhs6hqMik/fmHMluDbQxaunVxCg4Bz/C1IEjTRCygNhqJeO
 dFpY8zxNZhGgYERlq1Aae/NIB1BvIn1vCzPVY2ydbFWnPQr20eU9QLPLR7O99E0zDvh92KYZoBE
 EcAIqfu8956UqNuH9EZqDyTCt52bUg==
X-Rspamd-Queue-Id: 6B6578000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r9pon47pimgt1nxjetmpkrnyfwbujiio
X-HE-Tag: 1761855797-229202
X-HE-Meta: U2FsdGVkX19kZPjsF2JbWo1jpaHwQWrkjqQv5aD2wG3+xxO1UFT4g/gElcM/xkX/Pt150zclkDSyS7UT/ZBWDi1s1XbO/HXur/XtpuGbgzkOPtIAh2a30iLWX3EzRPZPX4yQprCnFqsIvGd9qfT8HrGbvLtBjb1aTse6wj007NjrUgajBLfl8uZnUtvl7phGDr8NXj5dT8AsfW4gToa0soOQ7EDEZXlbUfp8iZNriC7u58bzgRncwRuekokDAYiilD51fkBXvLTZemVcQZnztwyM/sdUS0FIx/Htqg+Hn/e6XX72VLELWz0+CN3jX2b4yPpbQTffUUcGXP5X48y3rfM/2qQcHWZvmZ2FRmls+ngYaTh6z7FaMfwSZKULtrBygA41amQRmsUa6UhP6ln16unC5kSGBJ0aboONbHTYhX8YsDt1yTOs+t0F3iAqAkfjpx7U04k99+aZb5T0lkFm7frj8grTxEpjyWFMHEQqTlnkvBgyWTpFaiN0ivQ1wtNPJNT6FDJGfVT7HmXR0mOqjQXFX+sYgjV4QZ24WrI8Bru7o2iHb5zmyaXa334gwqkFKv+0nI4BKlQvRhLQa4NK2gADrs9Qjyehg22U4hqae2HczgUQpnALV4FkmXPlTJCUz5n0yy8nwgq8cSdtRvqha0ecWpkWmw+sv5GSCX0jDUn0Iq4leSUmyntcGggaDWtwI/FC8ZTJiT+VFeXYhp7b7hmZocn9cXRBuzZ4abc+fSCgpHac350uTzG4XdHFM6oa+J5K/58EZTK5Smru8Hq96EdM36T6A67WMPHi+O32dtmDARjPHKrR/Tda4YJJeoOKZe+c9GYzP115Hbw21JraoQ0ZRxs+RakbLSzIiS5OQ2l9Si8BRwovgwe4dsAohZ15vaO6Xy6HrHIxPXl8BKhLU4dj0NIm4BEJxmcQHfAYrdpMrTvBdA5mQ7sJgyAK8d2lddzd6K3d94k8W9KtBqj
 JSS5xQye
 uikivOYlQoMUJ8AgseVFA3Ye4GTqrd6AYAhDn+E2RJMpEWFQRrtwHlfPJkhMFdn2nQhFL9QTWLMnZsCUL2ahw7nQX01kS31POV92eGPRvUEXFmEAV9k4IfguXjb2L09bpMO4i8+YLvoUQSQCFyKP8tXxoNd6DvHMgQEaR0bieSh20GXUx55Pezvp1QG/qd5OeI3izH/Us0ETtFixKjnnTqMieulB7AvHPQIN42vUQykKuxKEs56kSs+ZQ7xc0jsVJHzXJBvMCqIqtXnLURH8/hTbK4QCRuLtXZ+ctDxw19/d/VoDYEtCxi3jSribR6V6+D5nDNm5jFpCWkdAkTajaRRVg6iUpClXtgtAk9U3iuM6kxmRMMfCz5JTAKejDpuQf5KC9BiI/Wzgh2gLk4iY0EJNifPgLZwD0qz3Mq87nAsmf190omS8ube1Qn5qvB+Q2WzKWyyE8wIrMoe8h/NLcgCMoQUVLlbolJHWpIu+VF1752ltEk/zEysarkkZfNo46pbD8t+O/3EsNiqCtLhEYD4e7WvxwLXZnGV9Vl36x14t5bMoDlNM3jXpqh5E5DCiS17JQ3F5KWD+fVjFrslHHsb+c80SjInbrysN3w6UlweUCNcKGnbnEFQPR4taFfEvuvQrvCpb1l/zhaw0ou5vtan6H5Igj7qu9kB+SE2lQ8BVRCVKBhuPnJBNVqcaj4N0ZVCS9th/F5U9pe8HkYU4Uu/62pQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc CoC

Peter,

I'm sorry but your reply here is completely out of line.

I know tensions can run high sometimes, but this is a _good faith_ effort to try
to find a way forward.

Please take a step back and show some respect for the fact that Liam has put
VERY significant effort in preparing this after you _repeatedly_ asked him to
show him code.

I am starting to worry that your approach here is to bat off criticism by trying
to wear reviewers down and that's really not a good thing.

Again, this is _good faith_. Nobody is trying to unreasonably push back on these
changes, we are just trying to find the best solution possible.

Comments like:

'Your code allows to operate on pmd* in a module??? That's too risky and mm can
explode!  Isn't it?'

and 'that's the wrong way to go. I explained to you multiple times.'

and 'I'm pretty sure my code introduce zero or very little bug, if there's one, I'll
fix it, but really, likely not, because the changes are straightforward.'

vs. 'Your changes are huge.  I would not be surprised you break things here and
there.  I hope at least you will be around fixing them when it happens, even if
we're not sure the benefits of most of the changes.'

are just _entirely_ unhelpful and really unacceptable.

I have an extremely heavy workload at the moment anyway, but honestly
interactions like this have seriously put me off being involved in this review
personally.

Do we really want this to be how review in mm or the kernel is?

Is that really the culture we want to have here?

Thanks, Lorenzo


On Thu, Oct 30, 2025 at 03:55:44PM -0400, Peter Xu wrote:
> On Thu, Oct 30, 2025 at 03:07:18PM -0400, Peter Xu wrote:
> > > Patches are here:
> > >
> > > https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> >
> > Great!  Finally we have something solid to discuss on top.
> >
> > Yes, I'm extremely happy to see whatever code there is, I'm happy to review
> > it.  I'm happy to see it rolling.  If it is better, we can adopt it.
>
> So here is a summary of why I think my proposal is better:
>
> - Much less code
>
>   I think this is crystal clear..  I'm pasting once more in this summary
>   email on what your proposal touches:
>
>  fs/userfaultfd.c              |  14 +--
>  include/linux/hugetlb.h       |  21 ----
>  include/linux/mm.h            |  11 ++
>  include/linux/shmem_fs.h      |  14 ---
>  include/linux/userfaultfd_k.h | 108 ++++++++++------
>  mm/hugetlb.c                  | 359 +++++++++++++++++++++++++++++++++++++++++++++--------
>  mm/shmem.c                    | 245 ++++++++++++++++++++++++------------
>  mm/userfaultfd.c              | 869 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
>  8 files changed, 962 insertions(+), 679 deletions(-)
>
> - Much less future code
>
>   The new proposal needs at least 6 APIs to implement even minor fault..
>   One of the API needs to be implemented with uffd_info* which further
>   includes 10+ fields to process.  It means we'll have a bunch of
>   duplicated code in the future if new things pop up, so it's not only
>   about what we merge.
>
> - Much less exported functions to modules
>
>   My solution, after exposing vm_uffd_ops, doesn't need to export any
>   function.
>
>   Your solution needs to export a lot of new functions to modules.  I
>   didn't pay a lot of attention but the list should at least include these
>   10 functions:
>
>         void uffd_complete_register(struct vm_area_struct *vma);
>         unsigned int uffd_page_shift(struct vm_area_struct *vma);
>         int uffd_writeprotect(struct uffd_info *info);
>         ssize_t uffd_failed_do_unlock(struct uffd_info *info);
>         int uffd_atomic_pte_copy(struct folio *folio, unsigned long src_addr);
>         unsigned long mfill_size(struct vm_area_struct *vma)
>         int mfill_atomic_pte_poison(struct uffd_info *info);
>         int mfill_atomic_pte_copy(struct uffd_info *info);
>         int mfill_atomic_pte_zeropage(struct uffd_info *info);
>         ssize_t uffd_get_dst_pmd(struct vm_area_struct *dst_vma, unsigned long dst_addr,pmd_t **dst_pmd);
>
>   It's simply unnecessary.
>
> - Less error prone
>
>   At least to support minor fault, my solution only needs one hook fetching
>   page cache, then set the CONTINUE ioctl in the supported_ioctls.
>
> - Safer
>
>   Your code allows to operate on pmd* in a module??? That's too risky and
>   mm can explode!  Isn't it?
>
> - Do not build new codes on top of hugetlbfs
>
>   AFAICT, more than half of your solution's API is trying to service
>   hugetlbfs.  IMHO that's the wrong way to go.  I explained to you multiple
>   times.  We should either keep hugetlbfs alone, or having hugetlbfs adopt
>   mm APIs instead.  We shouldn't build any new code only trying to service
>   hugetlbfsv1 but nobody else.  We shouldn't introduce new mm API only to
>   service hugetlbfs.
>
> - Much less risk of breaking things
>
>   I'm pretty sure my code introduce zero or very little bug, if there's
>   one, I'll fix it, but really, likely not, because the changes are
>   straightforward.
>
>   Your changes are huge.  I would not be surprised you break things here
>   and there.  I hope at least you will be around fixing them when it
>   happens, even if we're not sure the benefits of most of the changes.
>
> --
> Peter Xu
>

