Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC8BCF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F676B0024; Thu, 20 Nov 2025 04:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E767C6B0029; Thu, 20 Nov 2025 04:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43B16B0024; Thu, 20 Nov 2025 04:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCFC96B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:35:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78F4A1A0810
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:35:23 +0000 (UTC)
X-FDA: 84130477326.27.64283C1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0CA7420002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:35:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hX34nl4v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EmkoKdfV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763631320; a=rsa-sha256;
	cv=pass;
	b=l6bFgMGNnMg1sz7IbddfDzyRW3y626GziW6wtj8VHtFX5R2FO5D/Pc/4tFootGgOr4gtEN
	vjUmN+1fMM3SWX2RteFqbR6M/nXseJo3a1WZj4oHvV9HngQZYp1q2XKjPb465e0dYPwnx0
	pWaEd5eDh+7EvdUDDv4SyhYw1FIOTIw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hX34nl4v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EmkoKdfV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763631320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARHQOqiczSvo9hnSbCqSYXTiBt3iyjPlp1EPRNjkqFk=;
	b=MVEC436lOi6w4fksNCfFk00nCZBoGljjJ3kPx/LSwF04xtXNzPIAykLxcF4YIbmXDJyiLI
	IjTAqo8tsfvyhEMpI5Gzp3iYgK4BeXIIfWS7K5rkYtmYHnmRJGRuzef0oqzgao5MMcuCRA
	2xzLxaBYZMT2OKAw6wNSkNW4oYwOb/M=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK8ppA5025019;
	Thu, 20 Nov 2025 09:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ARHQOqiczSvo9hnSbC
	qSYXTiBt3iyjPlp1EPRNjkqFk=; b=hX34nl4vKuH0ln/0tSvxrxeOc/aNyt/sh4
	GNQgGblZ6c0xouDyQigas6/7k4fMKvNJ3SdWLDb7sxIj5FVZY16798apYOu32WQF
	edr34AIQfE0HO7ZEFSFXBX/v+fANMsZa8hdhoPrlPuMhNfQfXMvIEjddlThuJwnv
	lxe03VrRYDIfTU97fvH5tSQtT71jkZNcOvbG69If73Mui/wZX3Oz2YR3oqoToMtg
	ZtUjWxSATuD6+MeuyZx2JbJtwGqK5YmbCt02839hisRc7tfYEGGmp5KKfEmZU95C
	1PIneU03vpQJReiicc3dUWlicXRQ7UV/Ae0WTKB+SlzV2tLFboeQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968qg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:35:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK8uJW6039956;
	Thu, 20 Nov 2025 09:35:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyp45dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:35:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ms6TfZFwbYHssJ1pvACbG2prbLazCfnmP3YwZMv9T8Z4QMDpvjsVjioIBBM9YJOiyPSneCe08Nl8tIq2+e91nfMRwSrdca/Psuvxk3ygPb1wK+xFyC8gFykz08gGF23xKLuKrt+02mp6y3xJcHaBwc5h36bR4MmYG4wY3kjsup+2ypfVdiAD56XBUnDrslLqGkeVAd9muB21dVVm59iz7RZkTvgkuA0X0PIKq9jFJAywqNMl7J2e2nsGagvgaz/kYyoOjVSCkFf7/P4+33ngAA5Z3TbuernOAi1gi4XYjW2OUkyljiMskqlJEmH6dwwMsb6OO82RFZG4G3FhjBTLag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARHQOqiczSvo9hnSbCqSYXTiBt3iyjPlp1EPRNjkqFk=;
 b=j8r40ngJhqDXHTiwtdqXcGPafEHGKv1o2L3MqnHa7EFW+4Fk9JgVR24wGq/x+/TyebSXCUzty+VKO+xAhaDK0VdQ7mAZ7EA72JIu8MMA78PyuQ0j8LS1JEI0LzTr75hSR+aBwUuXWCEbXiQ7nhYpp0NnepXKzl4C1+c1vlpgWmJKelz6SCayAfIpN1J7JY8tk6J3U1reDHFU4sSUanjxXOQUoPz53nJNMggkbUts800OPPFSpYoBrfRaby8ipo5aNEQE+u6td/qEUR/4dPyOpqmSvmk/RHl/9/65pOVC15XGf+zrURGxO7kGoS58+EVndgj8qjQh0I76aMMGjUrW6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARHQOqiczSvo9hnSbCqSYXTiBt3iyjPlp1EPRNjkqFk=;
 b=EmkoKdfVuUzTRrtYsUx2Z1d5MjlNJ7ScduxF2nEcb1ZUQu5IP9l33NdtCFPZvn1g0gyQXFVoN+8FQ6Hix/bYLyOgqkXiv79pcaj+G33XKMIUJ/eOn6mnAtqTlpSrTDKWaYKC3W2xRR3sA4qsAyJGsDV3+KZepaokyUUQ+8Tf5Ms=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 09:35:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:35:10 +0000
Date: Thu, 20 Nov 2025 09:35:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
X-ClientProxiedBy: LO4P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5106:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c516a75-a770-4905-2861-08de2818195c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i2dqtInEJ/Qk4JRCICKqxN1KnDaJoWCi+ZVaPLwqHJK2XBT8s6M/d1Wi7BdR?=
 =?us-ascii?Q?dxTv+d4nfIHVQgJJq8/jlUkqaEIhById+/fLkhwMMj4PI2zmup2cDiXQoIQM?=
 =?us-ascii?Q?Dvy+toFvoRc1YWCsbOgpJq43xShIRK+VyQyFmV9WD1sWbhaHjhUueR/pVOxN?=
 =?us-ascii?Q?LYmgSJmyGpZCrEXSbQ9sSVC0f7AsZVZCHxH7nd36RFmdg7Mr8yrc2B6CVl+Y?=
 =?us-ascii?Q?bYK0Z3txw4H5y+cgWZb3e1Uzr1J2Bnakn1y5d+lvAGK9nlhHTdjlmDnWTS+k?=
 =?us-ascii?Q?bbaWwZJLFQPHMgbZ5RoMkXt09r2fJ8mz8ctjbQsO+xugnxz1cx5x4jJxm0lg?=
 =?us-ascii?Q?5P1VlHFeJdOzpyelgEffb9buGUpDinwuEju9ZCuWNYBXeK1Qn4iiycXJdDNJ?=
 =?us-ascii?Q?+1BO6j8hwQU2PruzwWuFyUF4TkReK7o8l/7zFm6uWO9fGDFpCS7QPB5Q6Cea?=
 =?us-ascii?Q?EtZWZQNLeR7YkoW9QIiGhuBPXZIzXOO5grNBITZJDC6x/PdXOOwsBm+OT0BH?=
 =?us-ascii?Q?i9EAKPcdss5fH89sft8hDV/mmS96zZpFBu5NEh1JxAPG1E9AUVtsDQ4Yfls1?=
 =?us-ascii?Q?wPjOAsotdxxQoOkZDsOTkIepimjjobo6GgEbAPyYhTc8AQ8bJagnceyBsG6s?=
 =?us-ascii?Q?MClNp7Ix/d4DIOppgChf7MN1dxwOHTFahsc1oZFwCzUmV8ACLNIJ2/fjozY2?=
 =?us-ascii?Q?46Y4VNPqyh0qXTHCDNjPWZv6QzDuIIlVBA8BN44iDd3NpOfQjs7+njpyR/Ut?=
 =?us-ascii?Q?AxduvOB5NV02Ao91jRezB/HtV7QYeSyuLc39yCs7xNO64kBtXVJqrgqk6mRd?=
 =?us-ascii?Q?PwRYko6S/u+A94Po5Fw+8ULuGYBlGX/DuF8FGEB7s7h0QjEJKTR3ze0EQwbN?=
 =?us-ascii?Q?HheIps0zAQ0B4h0zhbtcaXHQAWMvnFv88mJcQbmB/M4wz5rEWggVj0wdTOQM?=
 =?us-ascii?Q?liPP2C4tBpKbLfM6M5Lr4i9fUHH8YK5P0ala01OzslF41anSdp/HgnD0mLNC?=
 =?us-ascii?Q?wUI4wVXk6r1p0lnGskhNDm2YjgSg7MLr0Wu9o98NzTdn4g8Z5ehWmssB47Yz?=
 =?us-ascii?Q?VYkvh1vTpi60QKeVOL+jh1KP6ddnh03awTlc5MwtGRr2c+FQYo34GkWegRx+?=
 =?us-ascii?Q?79CDZ5m3BM4z45J1kYy5J07cpsjrP/3fnZKrEZskyZo8DHqjzV7NhhsJHc+l?=
 =?us-ascii?Q?mi3EWwfGj6d1KReklKaUxwIFZRvHIAMxsKDCotTAEd+YuH7IG1k2f36Zm5gp?=
 =?us-ascii?Q?8dVsMV+dqihYl1ZObkim7c6I9mS4z3J3lkxDHBaXLYtqAsAcAv6ddOiij5V0?=
 =?us-ascii?Q?KIW4bevfTe0yEuV9Y2okp++QOs05szOGQJ7FU6CiN05zsuKD0k5zpYSokl4P?=
 =?us-ascii?Q?zRd0MZ7mue4H6sH2TG1C9oxEzcKBfwGcKseZoi9dGaWALWDPl/uKLRkwkBQP?=
 =?us-ascii?Q?yP593hASWhajJ0BR5IMCA2rUPpkBoiHq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z1eZ/PiwUFvxkToFY+Lar0z1CM5KWe2Qh6qMK3WmVd7MvN8jHKg2GYrUtz1E?=
 =?us-ascii?Q?NoHBuY4RwVcAWFjZ3BBTuHy7p4FdvVd6KsG4XQFyxkwW/gmBtB1mh+XlQg9P?=
 =?us-ascii?Q?mydyUtrqywrBGk0LL63Z3aQwhasyzhFvXfcaOHvG78LuW5NbT/AnwcrAnhTF?=
 =?us-ascii?Q?cgEPWTqG0fJ6jHKIcAzqZraMCTDihocHkQ+sypXFFm6w21XsrDreN+ofTAf+?=
 =?us-ascii?Q?UWMUkmPAcKrD3z5gSWHw2HEFTuHvJPAoOAqkov8nH2lsd1VlJZqug9mQYI2a?=
 =?us-ascii?Q?vVNdOGHzZ8MIvoXUfonAJOVQXIPt3OGYcD45imA61FQFghh3F9djF/eGnYaP?=
 =?us-ascii?Q?nwNmuHFC/oEdpYr/r6fg9LpypieDvIQOATJN3aWNqsBYAClIL9MOkyIVfTBT?=
 =?us-ascii?Q?KasDJ4VwV9TGblXU23/448aABvN25xrLAc/kUU9Wi50l/+WjxLC+kSuyAscR?=
 =?us-ascii?Q?q2slg+4pX+q3DkBI5SFsJsgJk+PYB5I6V61AMSkklYqXu3FaIizu1I19jKqK?=
 =?us-ascii?Q?py+v/Ij8k+LmZFthRf69d0VE6oGn5wFO/5IOxiWNuoWxO27a4UKl+XT+hj6G?=
 =?us-ascii?Q?smqH0FUSlsE9k0Q3UyXfSJ2l5/6lC7EmjsLUsl+ec+YbfvyYLqs/wxfuYZqc?=
 =?us-ascii?Q?E/QvFsWd/al0R6HMRvM3zTv1CMV2CmRoDahQid8f9sHEh8ezlAulEifMLr0t?=
 =?us-ascii?Q?XsgxC2dOcSfzDEHZU+i/IgbUktiiEBK82nlFEPXQlYPCG+pkw+yZDAdv0tix?=
 =?us-ascii?Q?SJegb6tEbxLwZ33ZDC6XEgtRR99qoKo+S7EcULIQ2l42PgHASZeN52P91DSB?=
 =?us-ascii?Q?gUehdDLgwQZUsGEo3uilDS4xAptrlVatiJiU3vRzjnDA8SGcL16Rs/kIMa5s?=
 =?us-ascii?Q?n7HIle9xHFxB+cZFANW+JOjn/JB6gOGvHONjoLm8TxF41DdFGeZDfgoM6OcF?=
 =?us-ascii?Q?SINcFL85foJnZbAt16g97h554yriZq0uNk5Y7FJPVUXBl2EfVE0PN56Qg1rm?=
 =?us-ascii?Q?eYF+lba5ybjNaST27yl1dk4POWPCMAVQ08v+e9H/6BINCeP1JjthcDbMy4HS?=
 =?us-ascii?Q?LAAG99LIqNpnIHjuxqCJ6gNynt3iD+cAxB8fYX3lDmIeZiAGjatWsJRln0Cc?=
 =?us-ascii?Q?N9UwcTnfBaFfe4x6d0C1cRuatWTkNcWIaRa5fgjITdF43Mt8yshLmEuLWTB+?=
 =?us-ascii?Q?mLGb2hR7BwIyW//bRG8OIo/CdWWhBORFvjH1u+mHHFGRvdWOlNPx+hPgw5sK?=
 =?us-ascii?Q?mfnSgMfwQOTqBX7/Juo/5FrT+WFtncorTZaLEGtY8G5JiF2m/apkfrTG9IQR?=
 =?us-ascii?Q?qeDmCj54raBbZHjWOtHMfD7wZ4qbvUR2am6zoOXVteOp/1viVILzzQx+C5u1?=
 =?us-ascii?Q?n9kwM++v84RengpGWeEb6svUBmLg61s4x1u/UPjJIH71DKe26OjdC+YPkOFw?=
 =?us-ascii?Q?UU+f20i0kkMgYItisvT9MJywp+fj0Z0BFG0LbG8WjhWFfMsn8sNxqDBYnk9A?=
 =?us-ascii?Q?0mEQ1sm5uOynZQcfssq0av+fThwjk4/CCnGcxTa/wSyYFqRrH9ZbO8oPac4L?=
 =?us-ascii?Q?5iyDVY5ubOcjStEE9YUpMwJ6R93nfDSW2+ysAdsYcKxA4uPrpdoqmR/Xf0vU?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JoVMNYDEkjfJrWuB2bvJ33WjbCbwqs39gIS695coRAtWrRXWSI6GV9y/cAkpRH1Mj/bFMqAAMRSyyCKfi7d2QcDHD38Y0SUKES7BYwZ1sgAqbgC/vetIDJJ/MCnuVPEDBkUa7dMmoAx3JPXhQ253vf2wuUw5qDb9KJwewQ5pUeMWfwXwJCXVo7m4mnkHhlPMHdZL8L0LW6vC6Va8mTKCLWMzO4yfdCJcLZV++HKgWDjtaCzlGtIwcNHR9Qd3XaMVkgV8M7C8fIWrRBBV1tPlgQnTrsw86sTm0UBJgYC/lBslFMNAG5dyyKNVCgWqLcZBYyZFNI9RIVKLnZezamPhZuGZuLF8LTYDbapySPo/rZvHm2DeYQZfVh6ryvIkFvI6O1ebnvmIjSG7IQHZFLih+1IxZCN+qM4FduqGB76G8iLYU8LkNE4V0eynpu/pGxn+wgOLECevvck4zNs95BfoaDf4x2vZzGymVRkhU4nE8L1NzGhFAShWT0BDd8baZjh2KdI/MKnbvCXGBOjytUcQmeGZbqnpw/OKlkVw8vaeyI95wim2P95P5rwx1l7dP9VJT2GhtCq5Xv5xaqWML6caWAlGT5vjSkbd/O1fkZ62+9o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c516a75-a770-4905-2861-08de2818195c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:35:10.3535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCNMJaNcmrbWt8zfagNtZMz1itNQds497McwnYqGaCirBmTTe6Exm1F8Dgdi0ohNuibflAj1DCUoIwFWNHHtI7V2whIW+wkxt3iRGNnzsMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200057
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691ee0d2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=IeMd7XrFkhigNuMyoGwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Proofpoint-GUID: 6MTi_VCK5GJyVJPCj5UV9sFgbOZ5_lhm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXyZZFm9mXX05K
 THkQ7FZaH1LDUtMueNNNu0z7B6jwO0ecZxQn54GAV78Lf/JpFGSgR+d4qf9Wm8JY7h/k3+LsKdQ
 aWseYny8g6YSY6plO/fiLaWqWrk9jGdJRdQqBUYrDYrOXeVDxzUkrFYTe3GJt4tkHmF/xB9V5ES
 ciPkhd8m7LonxCe9tyKMW4uv/YiFLTUQmtdd1hmHaTAqB7xAyYM9XJlHf0YdD27D4pZFrKUJlah
 bpP5F+/zb79eHCZk96eE7XZEpKOccf7r0SrDRyKJfRWF0YAKIfSBRv+uW4YMyJh6Vu/5FTWu/ZB
 th4CLaJ0ggbBeKlVgX6LPV9Fv28UVUbljJ5Kxrqgg+WnB3fuYQb0VvpJyBuNDJ65LoVjd0momof
 ZsTiNviZpGdUu54dZz7IAbBoDsLbB90QfdMit3183qj/zJ1KZA0=
X-Proofpoint-ORIG-GUID: 6MTi_VCK5GJyVJPCj5UV9sFgbOZ5_lhm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CA7420002
X-Stat-Signature: xwptyfa5hsko85f5mw44otafjg1aubg9
X-HE-Tag: 1763631319-47927
X-HE-Meta: U2FsdGVkX18g3gitN7h1ohrDOz07mpLPKODEsO4o/DIIm+pDUftq1Sxpt6+BMawnoh1oyrIHmKGMbL/nlWa/U2iWpksj1TofalZi8mAwlT7MG+DYMYCE68C9uLr97gfz6zs2PmR8Nouag/beR+krbqUGgsGn9OEYZ+QPrfjpY9YSxuYemsHoCmtZr/44Entli2DTp17qvlD6LLqx/l0lRBoHXXA4V7ooihdJRSCdiuRj3yP0g7f0kTUxKgQgyyqOrpdIVk+buGLolT4Zdo0KZslSmGq3xGPqvG12LvbnlX3s+Qn3mBa6vVrmVPguQVPy4pfDCoNWkNIO7X5kZVhHJsWCnUi7a69kvBk2OL3lp34xBacCXonQGswVcqjQPRIL5hJzoyAZ3yYfJ97kH/Yf1zMN4TAajH9oLRoVeWXId3naeINOy6FYFmf4nQbs9eW3whVyfcmmu5MXdNbJkD6do9M76SHBUj/NfVABRdQ+UtE5WQrh4t3Xp+t1vzcZFbmZ1L9ClHrK5ZmwOc0ZUJHucyAC6I0fO6g6XtMnNRzyJV/oS3Xssg3o3kZ7gL5Bv9J8+FdEgtSh5pDIXdSpCEnwtx8YW7jx1RL38yl/u9HqhQybfAFlPVcpbmJsqjxYdnOjEJ5Yh/3R6+GREAPWBh0s+omsYPox2pt7cMZD0vJ4Pu13i5HDUhb00YzY5PrCmXdFF8E5mPJu/rks3O77qd3WNWDrmSMhcAv2eF9m3blufckrvegHVOseTagKTpGy2TVb46PP6zuAIvH5IR7xTH06OxVOS6Q84DbnDQg980igxdIEtWNrLA6b+8bQWA2+o7tRbRKULVgWtFRxQfU0vGGRqB4jLzmkTvDaEpGFZb1mrtv0b0NdJtjcL7gAR/8mJ6sffjVbq7cugRjB/mDG3ur5cm3lClmdYDbbkOBH7f/GKCHecwLhfgBSruQV/02w00p2m1PzDpsPWTV8GSVxHR+
 wZxNbBnp
 PhEjUic2FwMawWkWJ68PSLvHE+k1Kr9X+aVH0iW3i/NEc+Hk0SC28WXczJ4XPXO91HuQAzbwV4+Q6WOKBAxLuKbGMGqHaKv9B5Jpgpr/faXHMZAMM4OVJxpdo60pyOUoFXbm+ha44GaiBr0VOcWIbFNS8FAQf4E5XyaavUNIpCrjW6TwlRQpKYo2huXd1Qnyzs3Qe3r9NP6JEuPr5vzW2VUL1QId8wBUWUV0pOBL7IK80qGWsX8Su/5eJuJsBEQaxKUfBQLZbdOs/D/lVs3eBoSNIO4XV+6a2DhvLzqGFs2hUTLlJqy5JMK35aZOw/A9jEYJy+GcZrdC5bzA3E+OROfD2pxDQVj31lQ2KLsyPTO2M64QgS9sg0zRZ76w9S+I2fboIF2khsRBWlPN9EuCwMy4ZVvkf1A5VRejqcCMPrAPYEpBuL1upKfznT6xRrnePsX8J1LOJ2SSXc3qEMvvyUsUUARgrEcdFzoMjqqNi9KukeAAifsFGRDrCoIgsAGT2ZeZpjki8ilAb3MlUd8TjCm41A/1gmWZCXnide2kgTDcHOjertAvIxiF2EjxdlmiMcEiJakYiQ6p48n5ykp1r0m2aUTKMlVbHZ3TO5DfV3TqcFRCFGn8ubtPos7J1wz8kraOKZ7PrhlqHsFrTH5cVIIDL0l03BehdzZN3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/20/25 10:04, Lorenzo Stoakes wrote:
> > Hi Vivek, thanks for the patch.
> >
> > In general though, let's please not make a fundamental change to mremap()
> > behaviour in late -rc6. Late in cycle/during merge window we're really only
> > interested in existing series, series that are less involved than this.
> >
> > On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> > > When mremap is used to create a new mapping, we should not return
> > > -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
> > > the old VMA would neither be expanded nor shrunk in this case. This
> >
> > I guess you're trying to be succinct here and 'clone' each input VMA using
> > the 0 source size input.
> >
> > However this can't work.
> >
> > This operation is not equivalent to an mmap(). It may seem to be for
> > ordinary mappings but in practice it isn't:
> >
> > (syscall)
> > -> do_mremap()
> > -> mremap_at()
> > -> expand_vma()
> > -> move_vma()
> > -> copy_vma_and_data()
> > -> copy_vma()
> >
> > Essentially copying the properties of the VMA to the new region.
> >
> > But this doesn't work for PFN map.
> >
> > At _no point_ are you invoking the original f_op->mmap or
> > f_op->mmap_prepare handler.
> >
> > And these handles for PFN maps set up page tables, because PFN maps
> > literally do not exist as VMAs which have properties independent of their
> > page tables like this.
>
> vfio-pci is a bit different, though, as it uses
> vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
> insert PFNs, not at mmap time using remap_pfn_range() and friends.
>
> (see vfio_pci_mmap_page_fault() )

It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
bug there:

	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
			VM_DONTEXPAND | VM_DONTDUMP);

Drop the VM_DONTEXPAND then?

But on the other hand... I see a _whole bunch_ of logic in vfio_pci_core_mmap()
that just wouldn't be executed on expansion (and the requested case here is 100%
an expand due to not invoking mmap callbacks...)

So we'd still be in a broken state here surely if we allowed it?

>
> Now, I have to idea if that is the main use case we want to target here and
> how we could handle it, just wanted to point it out :)

Right, the objections all remain, we absolutely cannot take this patch or
anything like it.

I guess VM_DONTEXPAND is really 'we do stuff in the (soon to be) mmap_prepare
callback that is dependent on region size'.

Most notably in this case:

	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
	...
	if (req_start + req_len > phys_len)
		return -EINVAL;

>
> --
> Cheers
>
> David
>

I wouldn't be entirely opposed to a _new system call_ explicitly for cloning an
existing memory region that explicitly invokes an mmap with equivalent
parameters for VM_DONTEXPAND/VM_PFNMAP cases/does a copy for ordinary cases.

But I'm not interested in doing that for mremap(ptr, 0, new_size, ...).

An alternative would be to have a new VMA callback for expansion where the
driver could explicitly do these checks :) but not sure if worth it.

Cheers, Lorenzo

