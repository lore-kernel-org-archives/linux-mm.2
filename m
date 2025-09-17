Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6A4CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3DC8E0043; Wed, 17 Sep 2025 11:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481998E003B; Wed, 17 Sep 2025 11:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5378E0043; Wed, 17 Sep 2025 11:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1258B8E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:25:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D74E2C05B0
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:08 +0000 (UTC)
X-FDA: 83899115496.18.B58359E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 85D9740018
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jcGWdd4M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ig5MHWPS;
	spf=pass (imf11.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXqJX/5KXUH2wfT544pI/c+2QwYLIKIcRXS9l/Mcoog=;
	b=AZ5v/rSoMZUD1b+DuAtvQ1wZCiOZWQxlhPVd6qCYksCVNPgGI5stWaysopK0F6up3IiYal
	b5MLRcyAw0LXEH+NRoM2F7j9HJp2007e3fdm2DokUEdQIm0j6XkzW2v5clSNjsFYECtayk
	11RfREpvdSgcEXiblx84OB42239ue2Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122705; a=rsa-sha256;
	cv=pass;
	b=H5wYoEqsn+D3ffwfJk3LCgMeLJY3OHq/brn/NmwXuvk1ZXa5ooEBsT+a7Xxs69d7hOwVgp
	xell7SIgGyhP90/NvgW8WuMaU/acmEVPMN3vatJEyzFzF/TSC6HI4nokLxpp8VlGgRl6Vz
	B6bSpGLPK1mvTxg5Q/Tfm17yqbiE2as=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jcGWdd4M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ig5MHWPS;
	spf=pass (imf11.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIUPi010040;
	Wed, 17 Sep 2025 15:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kXqJX/5KXUH2wfT544pI/c+2QwYLIKIcRXS9l/Mcoog=; b=
	jcGWdd4MIasIzyfvWtBwQ31P2pcWKCe1VSCevJVCnnj5ZfX4DvuhUUr5Shaf9vC1
	u/4ttEXgIVazpcbGyH51n99io5NfhqKzMzHmXRDY8VxA57fq801bBtXjNfRa3slx
	Yl9wV+GcUFgEFpZNwrrx+SpUcBkybZsjVypOV8xrne5FIszxS3HAfQ/5QWtsg/3B
	AbFO3UbG5ITBs2fCdtD6I4EncsUziZsGGCzJHizzbb82mPD3svmalW//HnwaFUmy
	hCmy3kdsdvtJHW4yl6o9oPH5cGxMt0dYrqWqoXHayN6wCqbzmGVzr4rUX7te9uKW
	bGOCEIluqvvLBf3rlMYupQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6hhd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEm8dJ036930;
	Wed, 17 Sep 2025 15:24:50 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxufg-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qtcl25Goxq1aD/0EBRiVjbngDio1aNu0ovycx3QGtrHQ6mjpePbBDvw/4DRCvJnGoJErulP8UKnaffxdfb4fQbu81z9EkwxIqmXX2ESifHPgy8MpZStyB4HXR1/yC5nEQhWhdZaWq9uyFPFkvv/neslzLiQaB3rYE0wtC51enp8By3PONi3HvDUPmmJBMIoJy53HkwIeGkdtpgnskkzebdbwJQUOZ0a7lGulS+JXe9jhxsvok3Hbia+H3jDscCq4I0qnHPpYdFd/oYqowIhyEBCZD3Mf/Rjuoi6nbP8UilN29G/B4k/M6LPsvA82ueptFG4/gmWBKelqWHxf9PUEkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXqJX/5KXUH2wfT544pI/c+2QwYLIKIcRXS9l/Mcoog=;
 b=scHr7xR+MaOPmQSCrRYziZq3QEzhA+UAVQePfKe/9zTKxbTV0dOqAIhvrSEf3E+v89B0BdPnDilMqj0W3hMGb513Vsdsr5kVxYAC/iADpcOZCxXlKrwpwRZy56iNfA45A5AjyZrYqy4XQeBnDEV+8s5QMkFQU4UdU29MBUPn5Mg+UmiXTLw/A03NcNzCKnFhxCn+LklE8pbQ6pUUH3CAbXQhfcBgeUhgRd0Q1BIvqgwYKJEKkSWITqpgicd704rx7Zr7j2HGP+wzbmNKa7BNO5e0TUaz89MEB8ROJlfWhKrt9oOWKE+fhRukaFNW/nizV/wT9WzElFhXzr/4C7SUrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXqJX/5KXUH2wfT544pI/c+2QwYLIKIcRXS9l/Mcoog=;
 b=ig5MHWPSLwM7PmvfWeMpHSTvCTnOZ6hXvNAWvIZQR88QwpejNlMMooao35NfWSVBWCkkzvOXHdILEboXj7eJCHVNH80OkxuaXMejk0xqKUDhmTfvFPMKevtr5Uu6sPOVtXQyaCvOezzGVWL1UBwtgxNgE10VxZJxIKOyLLPvMaY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 15:24:46 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:46 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 13/16] mm: memory: support clearing page ranges
Date: Wed, 17 Sep 2025 08:24:15 -0700
Message-Id: <20250917152418.4077386-14-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:907:1::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: 52281f0f-96f0-4991-9ee0-08ddf5fe557d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wNYUtJb1ogBtpVg2dGe4ySyCPuglcLwd4aVrVXWpftKSu0DzzqSVRWfde7RP?=
 =?us-ascii?Q?UzwowGmwo2GQY1BAPmOBXZeupAhrXx18Ej5pttjLR1DxopbGBMpeBPLmwVJy?=
 =?us-ascii?Q?od9hbbWxgIMQDdbz2vv9XyZwapYzQrHJuYoYaOkPGfcACaE9HTZUzAwgZhZk?=
 =?us-ascii?Q?M5MvfWPU7gT1coxxgII5VlKYQ2lJaeFUgNPNGbmYscqJmVBzHKVTn4honQ1M?=
 =?us-ascii?Q?XuYYSatKmP2wWIRQjLpoEhI0ynPKapjo7IIu37VvU/pbook93R48Az91RbcQ?=
 =?us-ascii?Q?4F7+uef0XnYMRuSnuJBOUxsiMr3y3LFkB5hhvOdFB23vvyBRVk9vnwp1oPmo?=
 =?us-ascii?Q?HxkS1v06ldjCRkQAOHG3aIQXuzbm8i+PbSjIqx5ICbrztZMqI1kwhAlymERX?=
 =?us-ascii?Q?HJUoit6NwJCxObJYjlCTj/rfKfZoAse2ZjgpQkLOPYjiXumvRQ92mSj4vNWA?=
 =?us-ascii?Q?5QOhOamPSE3AEAvkGsnRFdB8EbxgPWWYcqLOMq2zQY8bIJjaPxhtSALpRFYG?=
 =?us-ascii?Q?2W8LZVbpP0DV3lP5rV93+AkdEVgyzy/W4dIw1tygL0YbWXI1brtRdn0tpC25?=
 =?us-ascii?Q?kxXVeeFTGyHMz6Lt7DaYjZ40H80PgWHDT/oPuUKtKW9k2S+O1i13ilmMe50r?=
 =?us-ascii?Q?JdD8tqgq1EJtsWKdjldGGnGYsMaU1+LiHDFwQ9/I+2ZTtotcd0xjhyGRRyNw?=
 =?us-ascii?Q?VVG1zMukIPOS8w9s56M0Y1fe+xFazrKYMlvS3QlI02KTpDn/ADTSiPAJ651w?=
 =?us-ascii?Q?De9TFeUUb4IzubAOkKsIm+Grn1Akz7XdpMiWTNp4W5indPQI8hJ+1zmw97cw?=
 =?us-ascii?Q?f59yXQlzWfBexmkYjWn+bScWIP38oY3aM8T9BNqpJmFZ4O/GibP+00Rxcg2V?=
 =?us-ascii?Q?uTB1b8SmxLX0RAS8i4r7LXNMFG8GH1LjiBR5REL3ZlK8KzyHw0ST7ajy5VFK?=
 =?us-ascii?Q?ZQ5w8D3ngDZf3cgnvY1HGrCLJ6sysTJfYshI5JEUV2wcmtJwO+UvL2RnPM3X?=
 =?us-ascii?Q?nRP+G0/DSD5Nlv/4/36Pyoontu6sG7+aJhWeQY6yBWI+STWb7T7nCVU5wanl?=
 =?us-ascii?Q?wY0a5sWx1doMSgtkBylmzgUAFx6219UlSfQCQRNo1vHk00wkpdnbe47/AgLb?=
 =?us-ascii?Q?ZeQ9TNgQ2vfZmirvlWWQ9ce0th5SZ+Bctrkjh1xj/LD4ylUO3mwdhRNa3P1H?=
 =?us-ascii?Q?yC4ZCLtuMxo3jmhdAeeSPMzAu0nxDaf+/5hY0hMBA5iItbEn1wviq9zXhai/?=
 =?us-ascii?Q?ecNyZeLZOA6ZX6ecbt4MmHTortkdaiZy0lFrrvHHi0otTDkFWPtVLPi15Rwj?=
 =?us-ascii?Q?Lb9oHtPCQo6/kySE4FhdaLfl1P4K27fqOAyS5xtriVsWHQD1bd1JIFNmug0V?=
 =?us-ascii?Q?z7a/v5fDMEqQrGDrK3nC45nGYEgbAzHobSQGQe878p7LeyhGCdxpbwU/5gi9?=
 =?us-ascii?Q?ODSXuIt3Q+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gkZyMFsGjofsmqQz+/8ET/vOqGRonuhErGG4OnPAlTOBdEHmRQLE3kbZIOlj?=
 =?us-ascii?Q?kc4M60CLBwCXimyR4HVjaf+g47xEC5V/PcNZsDKXRlCJX11z3+ne54qGvEIo?=
 =?us-ascii?Q?QodD0OcbrI4ejCMUEzRO/sUSnHDGyDCvsh5JDwVxR3dyZNLaRbqkRmUx4WvJ?=
 =?us-ascii?Q?m2f1bC+edeZyEWmpfQKyc3BOw2/g4Ihjr8JMKODM6LdYc54WDbJfyJYa+s+x?=
 =?us-ascii?Q?blNNe6nDiheN6YV6PHQXRWD8VZALgqodC+gSa7F7QkbDWk/p6cXmRvFZP+Gc?=
 =?us-ascii?Q?mVQ1d0g3lGOLjFDADKKMWSdTodZ+1Cd03UT9Ott2PlTAXMsC+EFJJ5GB0JhG?=
 =?us-ascii?Q?LSroEJ2qO4hiAdQYdIN7fwwsD1wDF+mI2DzWHWnV+j5JI47hGOxsxboRVXN8?=
 =?us-ascii?Q?82o92gKdbp4joHR5NJYwtCZhHp76H/ird3TqA/b2lP5Bcb/F6LvjZOEqJSwg?=
 =?us-ascii?Q?aqb3nPk3QEaYMTTkVDSfCIzloRKmPKf/07ctuuASWTy10ijfxLq8dq0e0UAe?=
 =?us-ascii?Q?JfmnYyEOcRIMVoWyp8sLOoO/Bdv3e8Vhtt1rnELkwvT44CifnGlaYkE82aqO?=
 =?us-ascii?Q?aFUbsKCX/iuMXLqUXt4HJ1Si3RCfN2DMPbdaZBHpY3pRyYh3CD/hZAn7ECg/?=
 =?us-ascii?Q?UDRqOXKwOUvL7L8hW2bvOBhrmNZE8ss8ZQBy+NJx4+MToReeAToNa3s26yOc?=
 =?us-ascii?Q?458sBy4X788nPp+urZK56ALPCAAiSmK7eAfsTEwkRACt2thugx2Pyu1I7r7s?=
 =?us-ascii?Q?xi/5jmSXtXFuToCPjpnBXKqpXt3N78EU1QW4AIWDJcWv8mD4SCkJg+9r+87+?=
 =?us-ascii?Q?ZbnhyCCN4+lAZHOdz6Ag6WI12FWwo2qEMcUPoEWGRndfZ7Qqbc6cBrDOzNhq?=
 =?us-ascii?Q?B3qFawwiIWkXitjpJicGFZRMI93dFTGgC9mKHWZoZ1s7/9yZX74iv8qTxdBH?=
 =?us-ascii?Q?fUZtCLWsrqIRmS9cuUtS8qs4/9FUJRxa6WcGDYQ8TlUT4XNRoMx7Sv6uAIgh?=
 =?us-ascii?Q?QmTnnAgshpj3/DsA2zxc0C6lmvfF/xnxgp0+HeINbx/6Z5xdY+T9eD9jrHOR?=
 =?us-ascii?Q?m4Wu69LQ44QhgHCipDMro3ptuYNEHEDskI079HrKPtAc79mMcNdLAGwBdIpl?=
 =?us-ascii?Q?jevTq+9MfrNJWFEnKr0D4oaLwhwudhsCE4UQXzimbw8SptXi6e6/74juQaVh?=
 =?us-ascii?Q?ih671x7XSOHTXk6VtY2QeScS4KnzFdoyr8pMtFuxUWcuZVLEXTo7Pm5sJZBd?=
 =?us-ascii?Q?J/OLVd/O3bUlfwXbO5BgSkIgAvE2OnSxY70Wev+uFrnssJInIUAN5Sfn8bLR?=
 =?us-ascii?Q?ZWczSch4IaJFkKweXKMmBYKu4nfbetSZFswj0w3VafBlaJ00A4VLb5RecTvE?=
 =?us-ascii?Q?ufOaMVTmi1MX3462SbTfyUqf56MDXo+ub5FSRVhrMZvC2KQ//8pJK1fS/L9e?=
 =?us-ascii?Q?tKYiHACI3NxtNwTa/rrp1RFP2kJZ4mBxgwC4k0YPRXOOPH6JyoXc32z1lb1G?=
 =?us-ascii?Q?yItwTyomQzVF+4dhgHMxEKUl5kXqOjpxTQpz5cyZ2PNRFHOcB18VfxxAJu0A?=
 =?us-ascii?Q?8pzQZp4bBAUylEXrswsAuP2tpoHbBvIMsqvt9k0mHiMWe3sc68LKR3Ws9nk3?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DufOZiAHeabSI8mkLgt9MKIpuAr5HaOTuzyhxKjO9jKX+s3vTN2Y7Usd0FPc5zu0EoVlqVGNCioM7JT0Vex/xI/uUxp52rOA/dstKYgEw+0wMtdPp42RPZEVuXv/+1hT+zVamR24Y7Z8JU4cf27ZVZlvlI/cWyWD8nC8isfGsvHGs7lILcSCReTE2RN6Ww1zlFTE5htSGbW77wRbBH6wCWDBlDMXHcDF7kGOLldCUPtpgYfOQrJL2L3VyeXnQuU2sVCnpVRG4qkZ//bhN5jcijEu125P/ggTBUG1mmCmxZ9aiMXTqTvIvW7/9SGksgj/HRdT6sxgo6oO5PNMF6RQlheAYEpySZ5fMHcwGOSorHJ5w58bMsu+braDdilorzM1ayVpKgLLdLFQO37VVwXOb18xHTLvS3sVNCrR+YWye3Xw8xoG28UVq2/oF7sismJdO53X5CpaBa7Wkicrq4Mik3bj1/P3BltE5tXXCmMUI2j127Le4j17cMAgrJZ6nbfUPKYRav3eFgkyZwOAxJCkq31YPG3nk0IbwsdkTot+nADAzwkWa3jo9oD9K1X7DWpnrEAne514ilRHQHze4Q9azrKziEvxfTphE3tjaNW4g54=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52281f0f-96f0-4991-9ee0-08ddf5fe557d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:46.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8a18hrzZuTS3dn1+d5cnLjXqms8qfpLhj6xL7274abGjTHV+4RyViLcTksNZSJpSIuGLSLS16TMkoQkZJWvjp2m+tBmpW4k0d8PEmDbqR+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cad2c3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=mX9NMRdxVRmOxHn2ve8A:9 cc=ntf
 awl=host:12084
X-Proofpoint-GUID: hk1hn15YhOHRhh3P11pi7W62jMPiqMlj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXwxNI8o/oFeYq
 m89W+CfqbMyjjGprOeSbg3pFtHqK7S7qwlddMPAFsBsYOPVFlPjP/XbQt2nnk2OHvKPXH2R39RR
 fTi6Ndu0q8WyH9ou0ZAK0IeyURJLqrSAYwZds0OFPcBH7fjN/ZzPeT8xQMLQZEAyMnRqEQuDmsK
 S/PpKuR3mFk0/cIxCbuXu23y58h6+ZgnuTyfMtHwE7UExHbm3EyjWDY2pKSG6cAx1UXXLUYqUyY
 hxR28256fJ8opw62fuTXMEuobVRtz6rQy+391FzycA4oD+miqalTUdFg9m+dVc1NVhGhd1PbOjn
 KLmu/AZ4LTfUP0Kwr2K/mE7w1vd9T6lQ+9FR5MB+e0dMR38JPHT/B/7vKQVq4c/idPbDI5y4lIe
 S+1OPsm4NaA6PE1WjN79a0Dv2j1cdw==
X-Proofpoint-ORIG-GUID: hk1hn15YhOHRhh3P11pi7W62jMPiqMlj
X-Rspamd-Queue-Id: 85D9740018
X-Stat-Signature: 9ephn4nqisw4mxdeh99t385eq6ey1czj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758122705-55754
X-HE-Meta: U2FsdGVkX19Y1Q9XzwQJ6d3uB7J+iBWf9q5e9wF0bdmxkaUiSIAMGwycWwGRY4Ne2A87toGyM5H8UTyPvAkvnQLkXrfJf2QSG76eBs64DHqSknrQRra+h/dOnTXsuJfqaeZeGAbP9BQ8nOD2VYiu3O2uogLxfDXuKdbFAPwok4cAV1UQdmBcaHrbYwFUYgOTlQdizlIbl48vFR09U8uihHQr8TWSwP51vgoIY3owUhOM4rbvLolue1/JGxXwdEyKyi5ZlmOLbNgb3j40+ivwxJCL3P0Kd8LdfI9QlDvmNgdC23VzHC414LxdI8VxuxTeWw5tK1ZtYeS/T5YN0U1JTCEBq+dgl3FiofKqEYRZN8YukFOdss5thVbDMUyLGjZUhxMfZvfTvR91MMCm9GclPHdFb0kX7t/3c33kixiGRoOAi8lkRWoHHWl/u98oaq0d8jQMyDy6BNGIvQRFboyLtL/9Ef1vuoFpWkl6iTKFtF1qGS+npvNuvg51hd5NyJmVOeYJBmuVLvIFLv+pijAF1cKfdepYx4yFnEhY7tjPvtp5YI4ejtvL9d+a3RQWFpvAcopP1Vv5gDv5Rz9VNmx2C4QtZTL68bdKRcRvk55fwOaVMDL/kBlJc1zLiyWhlPSeH7Kt/16XJFAereSj15mC+6XZmcZ7g2s2zHoR2wKq4mgWbd6eE5yFSnhzehjYI3jd/Lz3Z0/cbBRaPhDlrkdwGAyiRYgEmqBHtV8U1hkBGf3mmqN+/wZ9oIIkUghRNnawxvfYzs1oJm32sfGjaxpl/Mca3oIvzD4/lOB45uHgwlhBvE+jLFgudzwxA8BxK/7OYD0YrCYw0JFh+a0zDGxQGKSecR67UqV3G/Zlt1AAd5cQ576ppTnW/SGiqvNTLU4Am+Ux6QNN1R23PQZDbLaqAAx91bNaqM+lWv5qtYG2gPnXbSsqR0sA5jqwKrgJ1P+JHFMl2s9Okt6ytxSQp3l
 uwW5wylR
 pEZmTfiGteoVF6uAaAri/9aMlL6J+Ia8le/+KG0+dFr6amsE77zLRjov/l6UYKIUnYNApuw05gy5K+IXrta4E5oUM5rRG4GAA6YJzTFaikRYRAStMIRU5ImhmJlCwIiuQsZELnAr2tQ7gBagrFgtldjHwziuIijj16QKP6wPoh+EP2UjZEvQv3TBv2p7BUjHsgLsLT5WAmVPUwvLgfEWtbaFSX2YdBv9SOcksF+C9dssDQyj0+bDgTRvvFXX75qX5R/Ged8pjMDsadDHl4jG/Y5xpCtYaMP7m3LJHc3ipxqDd0MNxFenw+m4IUTUYSwoWsslSuqOB6vwx5lKJNHWJJmNkYhY3PPKbSBuSXSj6RqDqTzZVMU9qiFlQfCKRlfo2G7yLQPAxiQ2jQuOr13FAuyQQ7Yuy8AXITj+lelqaCZrbfFRSIZ0QbcfySUN50dL06OKeutw/rK/2LpEucTktyCHY8PLFSO56P75a2yRXD1MPdPy5zOWH34Uakn2rBWcSx/yOvWeOwX1bcZNIl9CxS6DuIuN+qTgUyA3kc9nc1zWeQAyUhJS2yhjFHhpJmX0Kadkjsw8uRfRHqt566u8dA1RDDvot/YclDEW9XIMH6fzou6l8bxBynrGZJTyGyHhNQ2nPOJz5d9EZ1km6hfBAAaPAI/+u/DVIGBm+CRMP8FwliKM1T4qtUR8tciFiJTCr+S7dgJKAL0erJOHHcOnkBYfTn1B4ZYgDgfGFvl+y/TZ9drjKDiWtOLKxNT1C8pQaXcruZfEDdVgPOx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change folio_zero_user() to clear contiguous page ranges instead of
clearing using the current page-at-a-time approach. Exposing the largest
feasible length can be useful in enabling processors to optimize based
on extent.

However, clearing in large chunks can have two problems:

 - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
   (larger folios don't have any expectation of cache locality).

 - preemption latency when clearing large folios.

Handle the first by splitting the clearing in three parts: the
faulting page and its immediate locality, its left and right
regions; with the local neighbourhood cleared last.

The second problem becomes relevant when running under cooperative
preemption models. Limit the worst case preemption latency by clearing
in architecture specified PAGE_CONTIG_NR units, using a default value
of 1 where not specified.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/mm.h |  6 ++++
 mm/memory.c        | 82 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0cde9b01da5e..29b2a8bf7b4f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3768,6 +3768,12 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef ARCH_PAGE_CONTIG_NR
+#define PAGE_CONTIG_NR	1
+#else
+#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
+#endif
+
 #ifndef clear_pages
 /**
  * clear_pages() - clear a page range using a kernel virtual address.
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..0f5b1900b480 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7021,40 +7021,80 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+/*
+ * Clear contiguous pages chunking them up when running under
+ * non-preemptible models.
+ */
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int npages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i, count, unit;
 
-	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
+
+	for (i = 0; i < npages; ) {
+		count = min(unit, npages - i);
+		clear_user_highpages(nth_page(page, i),
+				     addr + i * PAGE_SIZE, count);
+		i += count;
 		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
 }
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
-
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
-}
-
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * Uses architectural support for clear_pages() to zero page extents
+ * instead of clearing page-at-a-time.
+ *
+ * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
+ * pages in the immediate locality of the faulting page, and its left, right
+ * regions; the local neighbourhood cleared last in order to keep cache
+ * lines of the target region hot.
+ *
+ * For larger folios we assume that there is no expectation of cache locality
+ * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int width = 2; /* number of pages cleared last on either side */
+	struct range r[3];
+	int i;
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
+		clear_contig_highpages(folio_page(folio, 0),
+					base_addr, folio_nr_pages(folio));
+		return;
+	}
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * ensure it sticks around in the cache.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+			    pg.end);
+
+	for (i = 0; i <= 2; i++) {
+		unsigned int npages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
+
+		if (npages > 0)
+			clear_contig_highpages(page, addr, npages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.43.5


