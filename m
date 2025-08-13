Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBFCC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417FB90008F; Wed, 13 Aug 2025 10:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFF1900088; Wed, 13 Aug 2025 10:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B77990008F; Wed, 13 Aug 2025 10:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 195E1900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:00:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFBEF82B8C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:00:32 +0000 (UTC)
X-FDA: 83771894304.02.12A37F3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D7382001B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:00:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jFJfAwMr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FKESWBqt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755093629; a=rsa-sha256;
	cv=pass;
	b=q/iDoLzATDgW/07ce7aw6hNYdlds3v5gZhfb7cQonOhKixm2VmaBCr4idQhfRlEggFPj8q
	9kkuF6jh27WIbIS8/IpSLkXbkLr31OR23WiwLfJuFk4Qgr1B2marE3YPdmrU7mKJDeVuD5
	AV4o6FgctJcUuQ0jLOONc/RWGwwragQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jFJfAwMr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FKESWBqt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2jD7QUzo36Ka9bybXaQSO/mlCkqz+BCpL6JmVl1EOE=;
	b=4o2IfnHlcUJW/VY9tfH7OEm6sYRGDd8/ewk7oKbOHvFgNaKF3erIYvQPLWdaRbZr8M3r6s
	R0lSYiGW4LuNF3kIn/7r+7D5eC5a0Val3lv4S5fZ2fDiKJ+6cjh1+PB6Gjm568ix6fErWV
	UOQlGwMl3/WxVCE/2EB236xlCDryJmg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDNELe027131;
	Wed, 13 Aug 2025 14:00:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Q2jD7QUzo36Ka9bybX
	aQSO/mlCkqz+BCpL6JmVl1EOE=; b=jFJfAwMrm+ZkGqIYVOWE/iPz8Uq6a1XENz
	8hnVbbgjddyAGL91DN4IV9WDK+ISc+LYUzqNwzipP0puoiTaYy/1EsNXmSl+rgPu
	xcxGnKEei2mRjRd7reyEOtcG0oHhThWphJR+lD4rRHJRCQf8ZrzNy9GhLqIj/dph
	ZPYtiajNTKZydkTiTw5iCXHTBojv+hno1yCVSA4TJXbv2vP/UV3f5mSsUUb/gSzg
	cMvALrQPj7y9BuQKkKsXOFjWV1A61xHVi3VUghadrU++Cc4TIGDkovDL0YXiPMKq
	8iyEK6TadqsVvi7CvWSdoSaAgzt++mJbfzrSyKfuVZeEn7KhcKHA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf7px5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 14:00:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DCpele009706;
	Wed, 13 Aug 2025 14:00:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvshrm80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 14:00:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FaLkOyqCG+ntgjCrMGZSZ5G8zt6X3TCZY/0C7dbS8WSVgWz8CX43AAbFE4ePrJcFshbq/FnxpMspG39BgMTAs6DtMqEBdTRYr4RyrbBmYXgPagLVEgCBCftwrjmMHnJFnZK3m3igO438rCiD2uQIurb00BoPDL/qIuXf6J8RE9hj6/UqBMEpsqq10dhmzDZg6UOqYTl3J2a7TS+wCoKAqUZtq/qf7VaVSQRVWoZxHVJ/uRjowW9STx7PRiyDzzWVFIkyDc0Lm1QevcNDxVkCBWLtj3Bfw0mnnqkf1j1+Ax8rIFh9I0m06CiwmkWKf2e1dxMcEjT+1MFcl8iCgptKDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2jD7QUzo36Ka9bybXaQSO/mlCkqz+BCpL6JmVl1EOE=;
 b=q9Fz2AXOda8NfL7RWfY3GTOLoavuUdFVy5SSWWDUqNIS2HGIncVpDXb3wCa70bDrHbwlisgHFoFXmV4IP6U0hspUtnqWSV7EHkb9k8Xx8M5C+SJowU5+foC/9I1J5XzxiAv+D4Igtf7Pzpj8lig+1Y2Omfs/AZmvGlDs9mLU0K3cLvlNLuU4IPXGTjV/OJ+ywdNAVAuxvFRM5o1+qrOaYPeQsiQZPwTFrZoQ/a/8a61FfxR38Im610KnKFF/S/QxwtDi3e7aKM/YLiB/oQIghWK3XFyOH5swcpZLis7sEIuAbgrDuIrapA1koQlNKBIdaBInK2+2hZrJOHQUvOctIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2jD7QUzo36Ka9bybXaQSO/mlCkqz+BCpL6JmVl1EOE=;
 b=FKESWBqtMvL8FCEsAZR21h9zN506OZiXIchL5EBfi43M8vtXBTLHM9aJVBqth3Z8EJQXg5pVtSqVZq+bT/GwjdEKPEl/li6jlgBxITNaa76snBpkjMVucrtSas/qi6z261burZg0Uv5+3irwS8nUtBUa0uAL0QgTGXHPWtrVwkY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4131.namprd10.prod.outlook.com (2603:10b6:a03:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Wed, 13 Aug
 2025 14:00:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 14:00:21 +0000
Date: Wed, 13 Aug 2025 15:00:19 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [akpm-mm:mm-new 123/137] arch/s390/mm/mmap.c:188:3: error: call
 to undeclared function 'mm_flag_set'; ISO C99 and later do not support
 implicit function declarations
Message-ID: <3e1444f2-be07-4fc6-b7de-d4cb3b788084@lucifer.local>
References: <202508132154.feFNDPyq-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508132154.feFNDPyq-lkp@intel.com>
X-ClientProxiedBy: LO2P265CA0199.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4131:EE_
X-MS-Office365-Filtering-Correlation-Id: 09bdaa0b-2066-4704-e687-08ddda71be6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5OUA6DUYQTNPVQslsslGgCziHNfI+Dds3dxd+xJ2OFbxmia2BG7GVBvf2BQR?=
 =?us-ascii?Q?8iYXB+ec6mDjXcuR/0A5ZJJwj6Ds8N4wl4G7CINWscKbhBphLiHJSTg+JfhN?=
 =?us-ascii?Q?HU79KwdGtk6BGLNV0Ry3OD+pUJlIFrryI+bdRZBzfuYyTpC1w+SipW1n7jKd?=
 =?us-ascii?Q?ezqdWmOAGJ9G4MUv4/6//QcKSXqL5/6L6kVfoNxwAdrXo99vsY3IIilw0E7u?=
 =?us-ascii?Q?PMJ2BVpuiSHI5OKLkZ+EuBuiu8D9LWt+PHFTdx7dwVnbpo3IU1De2tB8lPq1?=
 =?us-ascii?Q?8x/o57X9Aw4DNL5bEyaJqoN+oVyz1jHdroLjVoAMlpPgXcg2qz6xwXaS7WtM?=
 =?us-ascii?Q?xyMYPc293179PZ8G6vNKJcUYxR1QwpJSYIVnyZyjwk6Ia/ttVSKa5tEiCS10?=
 =?us-ascii?Q?sqPCFVknWysI9lAzI7fKhfey/06BZKxHTCHM+ZvyuqweHm2F9R3KE/XAEdPN?=
 =?us-ascii?Q?PE12o5Z4NkKv+v+V//EjTL4g7VYD6ya7pSY6GidZPGkyAy55d8fTKb5v/dLv?=
 =?us-ascii?Q?wYrBx554oBIECavFjUvzp50m+Y19OXp2L6etAFPCq267k2kj55aP3sSQALjF?=
 =?us-ascii?Q?wEqYDmBipxXZDO9NZExwmzui3fzZD8GzvFUjLlS+Tsc2kbh39M6AOAoW5RmA?=
 =?us-ascii?Q?vIGLz9Nl0OgRlTT25RKevl6+8P1ykXhVRf/M0KOOy659KttChBsDTYR2n3iF?=
 =?us-ascii?Q?EkugIL/KlsYx0Q+KZCggYz58I2pANeuQqwWgGO3du5qtjS/BuBa75s7YOaE2?=
 =?us-ascii?Q?boxpciGn6tLAdRmC8qH+xb5bu8WWynKUspvjSPPU6XFl9IUsIa73YHN4zRXn?=
 =?us-ascii?Q?82umT9ChXa+P8YMH3zHun5HIt4jCb1OV8iOwHn4bQXj3Nvt6MqLZGZc+CyMM?=
 =?us-ascii?Q?Je0IaXZkOziLX96paD0/DbKlsdg97b13DSesmDMpaM+Zl1CbgKeOYATJohzu?=
 =?us-ascii?Q?9V2jf89g8TZomgaSJRw5H/jiV6ln8BSucFqLYsa3Auj4QAibDshgthcJ7m/O?=
 =?us-ascii?Q?tnpz+h3UHeMbVoDQF9XoEJEBYf38VxMKgnK7cgCJcqwrmGscevKsR2jcSyJI?=
 =?us-ascii?Q?4hrtfK6tJWPN+byAGWb/3IlU/1CTSswDJlUgs5tL89C1bfbAMul/wQkYkXHO?=
 =?us-ascii?Q?VPOddj9HF9fu8tDrVc+Auv2/ZcnSJUyJQWxbdc4mFM42npsbIdKhrsK7DMAl?=
 =?us-ascii?Q?tW9YyjO/syX/Lr4Shh+EDtHLrPzNdsJjHjFxt2gM6B8diqY+9oIkkEKiE5ed?=
 =?us-ascii?Q?b2NK/cscP9GEPmf/rFWgIIaGSpkrkYa12a239Swrf4vVjr3wtGXy1/GRsgyU?=
 =?us-ascii?Q?M9P/QdiEos6gHVyOr8KRAUuBw1Pl5Yylqcs3LLR3U4NuG/NzrjTvsUzL6THK?=
 =?us-ascii?Q?NGh/y4OY2VGvnJsAZpzrfOkVzwCZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L15itQRZqu/4Xhf25RR1Ui2vG8AxI1RWMLb2CLZpJLiHnU4rqIlyJWPYGVJ+?=
 =?us-ascii?Q?epO8urhVPHUViDcL9McVMSZSBx7NQh3jCvvmFUofUWs3ufoe5i4naJdztFXH?=
 =?us-ascii?Q?6bi7l1ADZ+5AAynRcQP8gmWk05ZyYbJz4bIEF8jvQuD+piZoSuiJl0wLVYdR?=
 =?us-ascii?Q?Xz7imm4anOTbwEjNEbOpMGRNKV2BtAKD22P+c27znSb8NdolVLgN+U879f96?=
 =?us-ascii?Q?4hGzftaeo2I9fldIsGWB6QRcZ82RjGQ/xcTcbY4yZr3WC/PUGkf3NKF8we1M?=
 =?us-ascii?Q?0pML0WelP/i6lnuAqQe7cB+nvji88LwRbog6IFdREUG7rrZOViUfnX93dHmJ?=
 =?us-ascii?Q?5Vgm11CfMC0zsOaNVgphNia3e+7dlip92AgOKNNu2Wk6IwxX/gtYGW5AQjHO?=
 =?us-ascii?Q?qpRoTOMC+6y4n9LtGaJ+JVOKms7P7+f4rIuY+m9ggWrO/xA/2Lg8QPVNfXss?=
 =?us-ascii?Q?NbOrX/0vx3+cY1Fkomso9/RkjjMFOavQlFEBninx1Yop8yt+vXJU5lBRh/31?=
 =?us-ascii?Q?W8Ls0mDY6T5d1eUcArDUydftqwnVkKRmbC8xxFtb5aDKxxoS5kKAVd+ip+A8?=
 =?us-ascii?Q?JfOuk7yjMhmqTQORjTtoR+HiViQXfb8P0MNhxQkHLBV2NEKIpltKN0yXCj25?=
 =?us-ascii?Q?asgX+W5BSIU/P2JTeSTwlzB8JMPTQffqrT+QRMQo/JA/qE8Iz7V8Wa8Sfz+z?=
 =?us-ascii?Q?FJ4N30LdilmlTfDzlCvjBPGjzjW3uJpBh5Cv9sP2mxOgmmZ2UkQFp8jjTVE/?=
 =?us-ascii?Q?/jkr69L7UxfM1k/kte7TA3VBPoOVvTHW/BJp6F/DJnAeGqHhu1JeC5VfhjzI?=
 =?us-ascii?Q?muZeV9R1qActsPai6oVqk28iuqdwTWJGT6iYlti78K11prrKNLn55HzLPYN0?=
 =?us-ascii?Q?PoIDysxdX7o/thbPmbthQT+5IS1tfQOlYAc2/lIW6GjVM7s9eOqBp+Of5nyR?=
 =?us-ascii?Q?HPEtz+yxozVigjFhXMPXaV7Q9eyjCvwDJDr3BE/hXu7UAnLYXEhKhahokno1?=
 =?us-ascii?Q?Nj8gRbwoxTzqnJzAg/rWxZQJDnQSL141TIPflx2CoAeVOwvnQe1KoMIK1mCp?=
 =?us-ascii?Q?ylXSFu5wkPSY4Zr1hYGTXKxSYYR6xyTwBQzKEglRMMtqcKfvyj2wOqDRnrH+?=
 =?us-ascii?Q?VaOWG8oU4rPcdJO850Cv8s9R4/IqCXJmkz2gck/6rfJs8HuJGzW3aGrMUtm5?=
 =?us-ascii?Q?BRnp++HRUuUKHIcMo+Vq+f9TEh4COQ8gyUmtCCh3MCJcbOr2ksWkt/OpaXqy?=
 =?us-ascii?Q?yPUvyDYUUF3Na3hYPKXYpcMY3kb6dGsB/2pgmtsIdbUQT5/0eciuL2JLYpSz?=
 =?us-ascii?Q?jYzo4oTFqqsW+wnpHhAwcWMBsVRUNdg3h3uiz8wQUdIKw09Md28E0wuBxzDZ?=
 =?us-ascii?Q?pWiw+/fqksMRtXKW26cc4F2xGd26YjwJSE0t81b1MISKSp1nbpqdGechijCB?=
 =?us-ascii?Q?UEEs++678XoxRIP6APtyQOUwdECwNMi8mhi2QiQdMlJDzAXnj3zNB4/dX7ue?=
 =?us-ascii?Q?w2viVEHwAlIfpeylIjf9xz8pFYVevA34CaEm3plcefMEz+RJOazwlpxKwi1o?=
 =?us-ascii?Q?LFcDLRhDezFXmw5TkN2nYSp+wB1TosiGGlSLqiR9EC4wEFSJtNH9PeRRMTnL?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O+HBRdUX6K8qB9Z236ZYG13wycIceNsFnvMnMU37UObStzdcuYZLCDwpXU6UDOTmjfhwyqYvoAF0/B7FBxWUxj9SrX7fV8WT3zCRhvGJaeG1JcwwsK6U2/76DYR2h+0XSl7N739sFQ2ClRso6KLB8sxP3ltkHZSEjd55dKmO+fAJvJIrHRHYGfU1f8TZRIJeAhQBXxhdF3DDYE4jI12QnjvZviFJoHwyeuYb4WKdoNl8j142NOn/MJee/APyB66u5w9iU2dpBfbRoXcfUAc03Z12ZzTNkxk320F3vdZ/iCj7fwHnaFdeOlorCuOx1xlgr8nxHB7iPK5PjqCxI76eBFKi7Yp8LwJf30WJuuF3uBXuFWpozftDJSJhBO9ErN1C/rD+zm3yYdwj/r4xjyVUo7WkxtOWgDhU9BXazx2gfU63tKpKV07rweLjIagl8rPuvCaIrc4wHFdz93OlJI8kJLetF7NbLnDA9bbqfOBkMiv1x16PBpqcpsT+r3nKWaN4nIIPCOFq8QzCgw7J6IvohM9PZ8zdtmuc4BSBS7y3Y01xgnSi/N4zFlFmqv7iQD/r7Hckz9oME3fB2sjs1B3K7+hlwxmRLW1cNfuwfX4ydfU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09bdaa0b-2066-4704-e687-08ddda71be6b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 14:00:21.7977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4Dmqj9mPT5CjmGayKNXLMQDVZV+NuoboMqNY7HHObLOjzmzBvh/pKZJbkH844T0IzHHW10S+tMeE5yK5IeAuRY+ynOuiFM85b0aMAWPYGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130132
X-Proofpoint-GUID: L6Gnpy4VBWRMVAPTT02mD0c0K4eExVId
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDEzMSBTYWx0ZWRfX3JKISeEfIxCb
 yB5iZSDLI36wxs91ukYR3CQ/yo+7oOJcG2KyPL5VHqybKCrVfInbBSoDW4658LZfrMf7cX8chlD
 bL5mg13/CZf/W7VuyoB2N2Umc/YBrlZiFmPexhdQsm6sZiFM1uni07bUI/0c2zaK7tmd6sfFmkz
 NumBwVYxM5UTGgYQVtL11Exn5074XgZA/wyIuo/gqDBLUP4eVA0PhYeuTqNZYas1lvRSESmg1PL
 eF88UH/XwgnS/3pOUhQ5dygVpMZVeRDa8Os5eg5fZk51GxqYFo2n5W4yVuwSKoCZhxOjD4HcgeY
 bOj/DuGdS/Rtf16y6lqKtrlQQPDdfdSlL0JgLbYzbq8Tb0qXjmtuHvn31rYoJLfkYQIQ+YDidl2
 BGy9crBroncWqf7tdQdHN4eVCcGnRlaMmIgiv4z8V/WXot1RRrYOjDaNDqf+LHayIZ9H7Wvy
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689c9a7a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=1mNXoun0ax-czNz1:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8 a=5Xlk9eiMw62nG6GRLoMA:9
 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: L6Gnpy4VBWRMVAPTT02mD0c0K4eExVId
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D7382001B
X-Stat-Signature: u9axq49ossx13pmfsq98s39p718awi5g
X-HE-Tag: 1755093628-980634
X-HE-Meta: U2FsdGVkX18UZdcY1FElvAhre9HCawKR+gRlFz1cq3TlU6j6uo5i18F/7enOwJdRm+7vRVbPc9G6JiY5WismRJ0HgHI59qy/LuhT67eB3DABV6BwPdTzNColNTVc9TQz+7PEXGIpaSIETPk7sugD+I11u83Rl+Nx6xxdCw+cGn5FmRihPW8zLMDrTqRjEWgf5qBGmJJSv0Wh/U/3aqhofArW8sCCDU0/utClfQCPOQVI/BDFZDrfpuikLE69av9NBc4mKiG8i0aHsq9Xp64NOzIENxR9U25O7eHW0PaaNJk7L4h6aBryq21ywwR1psc2juFb/iJejEdU5q9bW0eFpyOuWxDE9VYNryELqWKGaETL40wxU74M5S/d3k2alINJlHlqdQsFOKSJStRPh4RdQ/vawjNsS/3UWNhf0Eel0SDhYRzJfySijwnneFAv6FhZ/+6AXgHT8Te7jlQ1WyY7X4TUr3STAQ4n7jX+qzi+NwHsdvrcC/MLviiaQK/PCAp8TCw1/u0fUXQ0KNYncF4J+F4nJDxYYh0US7nGdyZQpOtxuY6nELRDrpFrlFTTUOv9cIN3q7zlnejd1aYprYerMqkI6E/lFAE45nZylU6dp6vGKQ222IH3GtDSHLUnqHsu4+ujMqbOhoYQ+kplWl/JAly7HgQlwnjxnUQCWsHflge9j7spJtVz8/X4zZ0c5zO4B7R7zrJxf4nnWSHc6MlZ8zIMzxDiajhhOnN3+eCw/z6oLEaiKmKZzutGMrsU0kYXI30OXNxFgxU6Ke2KwLvyU31RShfSJ6lfvR5eIMtRMASPeltz5gsAkCoiyR+dcZ56hqGXr88HlyW/Ve+SIfzIduYpcy4NoQroZ/3QhElvO3SG+S4I/gk+0BgJMwf+NsWzwzYxz0gzrES3JOhOBFCYD5JnhXu5hVEYku+FTtDOfidges34te8SF2n2W0DgKgS5M9GVOwv1YEBp00xk8kX
 HGyVqOD2
 /xcyYiZ+dQIutAn0rVWvFycctqQdZHqCq7GsOlInxqp9j10JbElol7gL3QFyQInDh/4nv6CKpkuobklOvX0upPdFuqOOd0gsNTZfQiS8qZ29IfrY0FmdOO/qQyIpCiKuZ1SC2x2hEgQRBgS+dAkNyXVz0cplJGNj3VHSTHDpE/IrQ/GpAV2S0m8w9iuRDhc3PvZdwETJfbnpZaOmpRW4xMbLkVkUTlLjDIkO72pY7dn8Kzpw80Spvn9qGWgc2dNXMG/Oy8VLpbbmPZ7cvJxSqAwBMoIXufi65NgLYjfpxMbOMXbzXKIvfbHF2yfrWDFnxaX2biRYMmcDoQOj9lKEMk6D7vShlxSAKP28/2/YgpsRN6TA3deFFZfK1u0eAIgK8IY49PYtiCsFDd3yFsYVD9YEe+1LbfjbvL1pj7yx8VFgbPXiJgNl8BsiMM/G+Au3wr5TcrRAaVhs7lZEzZMiXcb2YwR9lmIPhl+HlpI6JpiRXakYzWo8W0N51GSgFQNucHsog+BCQcXm3afupS20jzuihn+txBKITW/3czkRXo6vyPl5AVIzHaxnkD7ME1rNq9YP1DTOxZ3fs311+HxSsKKCD3M/b3UBC+NOeu/RByBNjBHbIsJW3i/elp+C2ecqUeI/HMaSMw2CU30DQ926hu11iV4uxECWZ1YKOG/JuLcce3APQCAQ7iWLBO6fu40XQPC016RG0LXNDrIgttzp3W3n8c741cZly2TOs1WmugRUR1KWLvRr2MDsCrtFsqG0pjcrdBXYC60wYf0zF+zlAWN14zxKgevIU7QtRFJ/dtUtOqRIR57vkPWmU+np97aRBrpeAxoiDi4N0Wac4iTk7SDgx6o4+WNaucN5SfsLhZp7zDxl1mU4OoV31n3ifLZ/r6BI8JpCU6vI6FoJtZss98syDs+DfCdX4inb09wrwEjOnrbkynOX8R58J2NLIIhSPxYrIsfYIh4bSxmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 09:34:15PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   694c8e78f486b09137ee3efadae044d01aba971b
> commit: 70fd92efa9e96967353bb39665bac8f5276aaaae [123/137] mm: convert arch-specific code to mm_flags_*() accessors
> config: s390-allnoconfig (https://download.01.org/0day-ci/archive/20250813/202508132154.feFNDPyq-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 3769ce013be2879bf0b329c14a16f5cb766f26ce)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250813/202508132154.feFNDPyq-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508132154.feFNDPyq-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> arch/s390/mm/mmap.c:188:3: error: call to undeclared function 'mm_flag_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      188 |                 mm_flag_set(MMF_TOPDOWN, mm);

Oops I typo'd this! Apologies. should be mm_flags_set().

Will send a fixpatch.

