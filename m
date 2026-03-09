Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7580EF36E4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 06:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5436B0088; Mon,  9 Mar 2026 02:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53856B0089; Mon,  9 Mar 2026 02:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD446B008A; Mon,  9 Mar 2026 02:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCD976B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:28:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 473C1140D5B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:28:27 +0000 (UTC)
X-FDA: 84525545454.17.ED60A48
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id D576FC0003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:28:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ZuDy/TFd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mEVJeefX;
	spf=pass (imf22.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773037704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLHMSTdT3a8mQ18YaMJMcg+NMAhusnXL8MLJlMl4RDA=;
	b=R1RYu8/8m1GuoR4yfYBLouYRV/HyzvO18Lx9PSteSw+9i4OZhvOF5bVNXA4gZer17n9R/1
	+xyRI4Vi4ZwGwfmitsgEmpEa4AmQ9lI8Rsi02tj+/Msr3R/Xtj/z3WmIXFRjAZ3McB4tej
	MViRDQS0Q1/yy5byRnHS9EuRx0/yuOk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ZuDy/TFd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mEVJeefX;
	spf=pass (imf22.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773037704; a=rsa-sha256;
	cv=pass;
	b=OwHlTPsEalNjjkFlWDYEnYQWqwWfhnRAQMEcitQYRekPAZ3lajEK1c8ncYLtCMJR1ZN23p
	HTkdVyuJbGQP4ir+GxrTAAJMzrjpBHy9EpBSXXAJA0v5NW9aNYvfmjSvDkicF6DSKph4h4
	8esidqbIblZPazPz4LT6+ySzLqwBlAY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6290nKuL4146046;
	Mon, 9 Mar 2026 06:28:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HLHMSTdT3a8mQ18YaMJMcg+NMAhusnXL8MLJlMl4RDA=; b=
	ZuDy/TFdxWe5a0Y2Wmu1GaFM/CHKBdR6JvKmA0jgZ1RpSrFgDmopOvVp/WV/fdMe
	NaYmFhqB2FGREFojx7cqy05w2cxsieap10PyH2+FCmxqVRjQ+E31cb9zW5UNHsAm
	nb5p4x5NLeeBk16xduIubM/oEYSj0UuXR1WhMc5CJ766hwBGPOBLX1v3mJ3DyY6U
	yxISaNo3FDT6hKM2st0ulBa7GsAzx3FtYRckzRSx3IArpsf/UWWYFdQ0CTaPii7v
	Xq23rvGbLARTQupVXJL4ufYYVPNzu0co+JwErVcBtH+Ko/VECnYsGUYWFh6XBgQV
	3NJRfdIGxCqAwkrh2vg1Xg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskyp07eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 06:28:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62954EKC022704;
	Mon, 9 Mar 2026 06:28:19 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013033.outbound.protection.outlook.com [40.93.196.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf88vw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 06:28:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nwrs0Lp3K+L9sUNo6GEbSFZCY/ei+yWOiPv7DMEc+TIcVT7nqSLTQOv2t4ZpsVfQkqiz1o0SbHAui1frUu2jHLBtH3x4vL/VwHTGltV7zg6qjANUSYiV/UV72EDmP12GpacubMW21iL7M2yWMHsDl7kXSVftcPcjDYSlBt7PCry3CQYiqKPxtBU8csRR/W4GQOeXylYj1v/sThi79QUYRK4oZToFdmsmfw6LFfjbcrTWlwByEJIyyWPl4AcPOWm1DQ3z6rXGCGheI1PNPOiYrJ/k+JgXo3iXjowB14YgAlQHcpIwjArr5aNK6dOxXuWdefz1X63/0SgceRC6RiU7kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLHMSTdT3a8mQ18YaMJMcg+NMAhusnXL8MLJlMl4RDA=;
 b=xSZK3eUBAGozwrnSi1wTjyInvX25B7so63S4orGgZa5aawMBCAKb+z2V3gwO0d2QObFtGfzxWpA/IwS9k33GR1tpm0j6JTTW7sGclMvJggx2wrfxf3BNiVyQl81YT029CbWLj6WgqGV0Q5TB9pampPE8aGZr8VqVNnopQdb2fedW6n4re3quoKl0qQ6GyiAhG0AAMFBSrFoSRBsPL/de93BEVVGNXojpS3gxFn/pcuLL5Teeu1zmL4GEe1Ppvy2wx7jHGwSAUa02IzwO/yAgNScanPpYT0MDgncNgNWOuwBy3w7WfxcQ1jxd319zlQRq0V136OnKlcw+ABmvQfJCCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLHMSTdT3a8mQ18YaMJMcg+NMAhusnXL8MLJlMl4RDA=;
 b=mEVJeefXzaOw4yIPQaLZlpdD/h545GXrLAQdMW15kaSyp/qsUqO6LSdVvnBYYVDRZBGWXjbr4F35Eubre2cVKbxZbkYMO5HOLS6aXCUMFEw34Uf2FRuyw/GPz/Co5RueGAojP25rsZOvwSP78mIvNMnYzLOUF1vjDffRL3ZYYOA=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by SJ2PR10MB7558.namprd10.prod.outlook.com (2603:10b6:a03:549::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Mon, 9 Mar
 2026 06:27:55 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 06:27:54 +0000
Message-ID: <05aed962-588f-405b-bb93-af36b28874d8@oracle.com>
Date: Sun, 8 Mar 2026 23:27:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 286/330] include/dup.h:354:25: error: stray
 '\302' in program
To: Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
References: <aa4QKbYOvGmDEqVG@rli9-mobl>
 <20260308223152.7c99aaa3c73f819b7844fa07@linux-foundation.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <20260308223152.7c99aaa3c73f819b7844fa07@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::22) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|SJ2PR10MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae4f35b-b585-45b6-1bb8-08de7da4ff6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	FOLo+kB9cIA8Cc4rQzuUbrt7qOl+Jc/M1WbbIpoY8jevOjHkohg1Ux8WkLpnhxOLCTruqVNggdYCeRXpvSKNFP8vav+Q/9dv6W6Bls1hokJ3MZ0cWZv0CQCUfQyqi8iz1M/ykXc6Nm5Y8eLB8Om1R69gOCd1Vprok0g6nGFtp+gMzlk+AOznLpMdMmmcUkqiSGbkPJMsboFPsxe4tsASoWUsdv4ocWWxRSi9W/Yr9YQfQKleQLwxMI5/bMjeURoN0KO9XtuBpF1hXSTSuX5F8eUriXg7QgBwItMA+pNS9Ysy1OK29h4E058S4bcMgZAqQTO+t/3uMqs5PWj/s/XetjtW4jbNdhEd3qNTVrvyLnd8b1Li95YRoepiTxsfT+zlVfUrq4N8/tvutSYBpH0iQyMd5rx8VToBQ1bW1DgYgdSXZ7XmnOXLdjLTTbK3HhzULBg+TUP2Hu+WpnGNvu2GaZS2KCmKWTFj9s4legHzWJNRGxuIqG20hnGKwX6zUYehJqJDFmtP2rZ1O6IyhkuGBZFQDp9kYa++azGLqErWxKKYfPbn/F1uCIM7KFaPQOpvvc6SWHAnkM+cz8e/Bp1b9Mr/VtxBHtdGeMW/o4KXWzkYCLspxQHF2/1I1kc1K12SaYnQ+RS/MdEz0vtMwZBcgR806ICyTs6blD+CqBoF8bLkn7jKkCv9yVgV3sWoJfYoYcyzpC+r2opRJMHGZt0VPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0s3NDZ6VmsvL0JmRXE3SHlmSHpCL2VFYnUrYnloZmJudmFhaHBzcTNkMVdW?=
 =?utf-8?B?UmFjYlIyc0dsTDJ0Ty9VNmJ0S2xMSzhOSHE2ZklGenRmbXl3b1hzUDBqVml5?=
 =?utf-8?B?M1c3M0FjSkh4NWoyWGhjQXV1T3JaeVVXaEFpNHhhMm5Nb0VjQ0tuNVp2ZHEv?=
 =?utf-8?B?SGZZSm0vd0RidWloa1hBZ1Y2c2tYc2ZPZ2poY01KOU9keFUxdE03cWJvN3BE?=
 =?utf-8?B?Ykl1bmlPZysrd1BoZ1hGRnRlYXFUSU5oazFnVm4zSm1HU253Kytqa1BVcDlw?=
 =?utf-8?B?VFNGMmc2YWcvMVkxVTB2aCt4Rm5OWENRd283RWtrcG1JQWFqK3I4cXE3UkFu?=
 =?utf-8?B?cHdlc2pnMDVzUnhmcmNiMkZkbkppUGprZ2hJclhENVZqckZsZGdNbjlRMFpj?=
 =?utf-8?B?eUEyU1dzc2xjdGdMNWJlemwxRVpuMGpxVFp1QUtNZGE4UmtTZkRWdS9Ya01P?=
 =?utf-8?B?L21IZ1pQbEdzbE5kNWk2ZmJqTitqWlJIYXA0UlNGdzd4ejJzTUs3a20vcW1x?=
 =?utf-8?B?SnZRM2xJRVppems5N2RDV2Z4Y3V1SVl2OU13aHZNc21MdEJmMGVKNGRqZGZy?=
 =?utf-8?B?SEMyOGJ1UExoMlVMUVNzOEFOWXRXaUIrV1hsYjZaNlVERC91a3FWMDBJTmlT?=
 =?utf-8?B?RTA0RDRJd1kxRGhIdFFlUXVKYWxGSWV0akw1MmRibzN4dDFnTVdMS29xOTVs?=
 =?utf-8?B?WDF1eWt3dFZlc1V2d1JrbFBuUUpTd1pyWGlSajgzOTduV0ZPV2ZNcGxUc2JX?=
 =?utf-8?B?K1ByQWxwTVNqOFVkNGFLVURFT2xFcUV6eWI0Sjl1TWhGVGtXRmhZVFhOQkN0?=
 =?utf-8?B?eFdrTUdEMEdyOVYxb1piNTA4cHRGQ0F5amJSdXE3bTBxd2ZDT2VVOGt0bmVS?=
 =?utf-8?B?cmtwelhLWS92QUdZQWdjMFppK0c4bVVaVWtPNmRXOGltMFp6T2MxeE1ydk9Q?=
 =?utf-8?B?WnlHR29PWFVBdVpPdkpzNGxBVzZ2TTNzNUcvbE5VZGJNVjZhUVlPbk1EQS9F?=
 =?utf-8?B?aENpYmNLb3hKdFNiZHBYNTc2djdXOUljUE41ZWxtYlEzckxhaS8xdTJSSUxq?=
 =?utf-8?B?OC9RSFN3TmNaUlBJeHBSMFZKaTcvQzgvejZSUTk2SkplMndLbVBzOUk1NWFs?=
 =?utf-8?B?Q3BUTkdLNENzeGFrd2RiWDRjampzSCtML2tIOGVhZFhWOGk3a084UHg1OHc2?=
 =?utf-8?B?cFBDWUZKeEo2djJCaEpVUFZ5em0zbG4xbkNOOUkzL0NSbzhNZ2ppd2FtWVJH?=
 =?utf-8?B?V3MxNWRkOEkyNmNpM1lxd0RKM1AvNkUrQnJEb0d2MStVOFN0clV6ekxJNks4?=
 =?utf-8?B?Y0xwOEtUNi93NStoeTVPQWRVSGpBR1Z3Y093OTJOeFpFdFlPL2hnajBFK0dQ?=
 =?utf-8?B?dUtoVW44OUFYT05xMVRXVi9pZzNLa3QveklGZmszc0Y0b3N0L1ZPUTQ3MzFp?=
 =?utf-8?B?bThWbEJTcXFKSUd6MG8vSjhCUjJuY0laM1k5eTB5WnVoMkdQTkNPNWZLaVdx?=
 =?utf-8?B?dEZvN0U5WTlMUXhjLzhDOFFGOXZYSDNmL0F6UU9ic1d2VzdBbFd3aUVpVnhD?=
 =?utf-8?B?TnNBc3M1VEVMeXljMlRtUy9qZnJRQXVsZS9GR1AzazFtZE9ZK3ZIczZQTVAr?=
 =?utf-8?B?cHNOdFhSQlBhbm1nUlpoekpKN25KNXpQYjdDczNYK3hLWE9TTVlLTEdIR2ZJ?=
 =?utf-8?B?RjFmWUllVXhNL0p0MWtRUTdra2twR3MvT244NE9sMmNnbGlHYlRTY3F4anND?=
 =?utf-8?B?Z3Iyb1BnL3FVZkZxVm5yd2orRnB3V1VOckFpVGVlaU5INURQWUZ5MGNKcFdj?=
 =?utf-8?B?VGE1OU1iSmlRa1IzQWozWVdGT0E1UjA5NTR4RXNSd0FSek8yZUtQajFNQjMr?=
 =?utf-8?B?YkpyTFZOb0dSRU81U2gxRVJzYk9ST3NITXBTVjJzTmlqeTU4Tlh3aXErcyt5?=
 =?utf-8?B?Tnh2cHZLMTByMVAzdFk4Q21QbTROZDFWMUE1akFORDF5cS9VK3Z5NERSaCtF?=
 =?utf-8?B?V29Hb1dML3ZkaUpZZkZKNkw5VXlpWlpkcDZEd2FtWGNSTklldmpsNFdFUjlo?=
 =?utf-8?B?dzYrTU8rd3hpZ2lVNzNSV281WDdyT0tJNjdENTNTQ0g2SGM3ZWpvanlRdGVa?=
 =?utf-8?B?QVYxU0E1djh6ZXJ3QVFYazBSa0IrclQyZVc3bEVrR29zSTRwc1MvVXRZazh3?=
 =?utf-8?B?L2hpVTB3amQ3b3lxclRYTFkvcGQrc05FZkJJNUx4eG41bTZoV3ZTaCtnUERq?=
 =?utf-8?B?eVhuZ0RCZUJJcWoxQ1pjK2ZMcXhyRlZOQ2lBSHRJanUxcXFiUzhxSTJPaDVQ?=
 =?utf-8?B?WTJtaWZacmtHQVk3S1V3ZzZkWVJuUkErbUFsd3BPcmdQYjhVN2g4WllwQTR3?=
 =?utf-8?Q?yW4GJij8d6OPACS7C3RDexi9sU0e36WwfbwsItXm1PxeA?=
X-MS-Exchange-AntiSpam-MessageData-1: kdztOPfVERhP2yq+N5eudbnfN9MQnK+wkk8=
X-Exchange-RoutingPolicyChecked:
	GicUG/ET8UXIawuRdkh8h+kTp1mXZB4v3X1paawwekXL+oTePpd+Q/JgnAUwioozWkpUttEJ5o0ug/nTBzv0/2casT/W3tXdjc1wqrg5i2rNk3tYCav1asps8BwLuqFi6EZQRJbZOiu7L30xzLtaO803bw7sFvZXNmSAtpL+xUbPwf41o5Zzoym3f1xLNispXtKa92oM2Xl9MhQVS8FytFNAwUSne+MST+j5A6po0QeXkhIyGSpjUcXDM4tOKQwLnJGNKLoUV0Ixtadmxx+oSW0H8KXmuAciyWNo2RGK4h1MmL+27UpMjRAU3YBftUpdJHO6u6SYN2UNuE6Qy0DywA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bJMjggHcIEPFPcfo5jFYHu0D/u4Zzp3K3k6v+qF9Wusao+uzwbOSe08w7+aBlrffxySVA5NbdLp7TVKWR69a17OhZK8fSOB4lS3v42NvmQsnkgI6p+go8gOjoWck0eD//ciYkPAhnWuoxHEmxCZDI1TZ2Nbc8pZVl9KptlnLx4covy6Im//AHNB/GHdsPK7lVl0Ubu/MbVwYnzbrq99UkzIWXyh45Fa3s1FOq3FebLsqB7Avz9lo9igd3p1jFUvVPoMgVCpmr4WXuxpgdb3PfR49BSpkW1V37HmJ6B2+vhDLyGKf/SvHGRWjVgkuRtFeo97UFVO5h+fk2/96zAZTzKCjLZGE91qqCU6wIHtiWxW1HBV+W7KG2r6PRHW/y4lQD0uj0/bs3igT/j33/BrBJNWRNBuXskRPZH7wZyQm1d0l5si+zDVjYax4l8WLWYxaUqWISW1QzuJnXZV4DycTSDBKHjhIY08IU1b0HfCit1+1FMbWS6W/NAKsSyeg8pE97YrgvGr3PU8cJ137tZpbp6vX/uGpFcUrPbeNTeYZwl3eGUJX9oriJH6fCwyAa+VKYCq7maJ3s1NN0Nuw88CNsJT/7DtY2OtWMIYrM9CdBfk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae4f35b-b585-45b6-1bb8-08de7da4ff6d
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 06:27:54.8344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hm6m3Kv+//sOZ98Otm5TBAwJ1AkwwcTVXi2Q/Ynuu3QJAeP4oHHULJJD5960bVvDYHJF6eE+FFrwKI9VC/hvF4qMFYbF+iKmARchG7K7IwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_02,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603090058
X-Proofpoint-GUID: VLFw5tVjGyPYZbb_sgHGXfDiXWZcIn3s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA1OCBTYWx0ZWRfXxVjVX98RnhjX
 wgD8HJr2PQlHRHYV5u+MyGFBYr1HlU7lza5NFKTcev1WZpg2F9t+hfnOlPtkqhsb4Rq9rnqvRCh
 A606gU/u6qusAgwkdRaG0JwRygpFw3EghVmlfuP90f5rIbwP0dla4HMp6u9SNINs5+JefKzGEWG
 MNi7OG/s2cXIZTwC8HmdP9Azz7DBXRmwHoLktPs0pWW4nmBm0Zv2+Fd3ISl9xjQXMm77zBeHj3N
 X9XsSoW+gEf8Co7W6//dJhjiIbtquQCk4khFY28ha0HTtJKLwPomQ3Vxum6JoJIh6HDBI4Fw6Wf
 GyIhXtTjF/cg4ho1orv1FxwUo3dGnDr7fgFuZSHJruup2HAxdiu2g6TWoyWKgstRkch9dYFM3iC
 bH+4zRPsUPERfCz2g68NFvujqHMXygu+WOidLpZJOfScLAPOmjQjBomBg4ueytRVimRKN84TQhE
 2g+qMx+OBUOGRIbSGAQ==
X-Proofpoint-ORIG-GUID: VLFw5tVjGyPYZbb_sgHGXfDiXWZcIn3s
X-Authority-Analysis: v=2.4 cv=XP89iAhE c=1 sm=1 tr=0 ts=69ae6884 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=-f5tU-Vy1jsoJYcoRSAA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Stat-Signature: u5pyphndbfp11yxn5fsxwnc71c3bxz3y
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D576FC0003
X-HE-Tag: 1773037703-106405
X-HE-Meta: U2FsdGVkX1/9/806THRAGsoufyevdnExZi+PIGgOqvpltNOzekt97vxviyNDjSW5zF0i1ER3mCL74MfWilVcMfqpoi3T+YfL6/Hn6S+UG5Pj6zMuyoDotrv1/rhi4eQe4XxhqPg2xSjjBfNSDDipHEVZIAHmJHuyd3B2F30Bw2anhcY12uaGo9Ik7DTYBQ5ZSDzcnp8mgNQ27Hb9r8tx6dVsce3rj3XYTnrDV/uA57FcMfcU9GxhmhKjU+ZRXyZPLf28QDfsV+AOKiHZn9Ej/DTLSUprmRTm4HwwPbLpcrsiJtdtE9/km9p7kMu8U7/v/7gXCgTgTMKQT9kw73xKOnJfpBsnKNs8qEjFxqM2Iit9Cgv/cEwZKjbmC4qkWNyAqbTpdo6xFFLEdCKkKLV3geqteq9xFPMaiuzLOr/Yhqk/QaGB5vIFBkiVpeg1afc3B/1nHZDaIFVSGhKrAktTMmVbIwBg8ilS47WqQb08ZsrXlP3C2ZPHWALn67zuymPQnTiD8rJxh6vQscFSFQMm/Ay0sgqaBUA2wd4GuUu0ThSpKQSLuL3A7sZucl3LteCiNYzj8XZwIS5foV0K0qQzvcekTJ/vHG0p6IuY/2zM1vaEx/ZSaisI7zaBl9fjmKr7uXHQLUrfxFvQ9MuNyGBix7iNH38d1gzy893PRFbvSoe6JYoWOv1f33+/um1FyXCE/dNqZuJb50zo3V8nLCtxmuXj5lTuOqDGFWaDFoEraGzTuBsUSFj1zM2zawsa/SeZno29W0iaEThXG+H3t48pkkvmJ9obdEWU920OauJ8Ab+IPODLfJWbMMGs1mkFl162VCkroG5Icw6crYXWCwbFlgkaFcx5dtFPGTv/Oundoa2lbz5kyTpLh8632wUNXkjRNusb7jhI0nJhPtNSAKf8F4pQJaKHYHpkhbwtgy5Ul4x2wlOTy+x+AdPh0mL9RhmropIXwsHp2SSb83ir8bB
 YApJQQew
 Gssn1xJuy4vVfFaAGbrqyDTMXy4CPLMd7NP3h6PQVC16iT23IUAAkt8NLQfB6C8pKvbziYFOkSpek5DGOVoDo3foFMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/8/26 10:31 PM, Andrew Morton wrote:
> On Mon, 9 Mar 2026 08:11:21 +0800 kernel test robot <lkp@intel.com> wrote:
>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>> head:   167400fd4c51f9e5ea8fc9d33c89c938799be4be
>> commit: 84cd8de2b92a1ccf493c43da8b31bb983d320ca7 [286/330] mm-prevent-droppable-mappings-from-being-locked-fix
>> config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260309/202603090023.npem8cfw-lkp@intel.com/config)
>> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603090023.npem8cfw-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/r/202603090023.npem8cfw-lkp@intel.com/
>>
>> All error/warnings (new ones prefixed by >>):
>>
>>     In file included from vma_internal.h:55,
>>                      from shared.h:11,
>>                      from main.c:3:
>>>> include/dup.h:354:9: warning: ISO C99 requires whitespace after the macro name
>>       354 | #define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
>>           |         ^~~~~~~~~~~~~~~~
> bah, OK, my attempt to turn the incoming email into something usable
> didn't work out,  Let me attempt to repair that.
>
> Anthony, text/plain changelogged, signed-off patches are very much
> preferred, thanks.
>
Noted. Thank you, Andrew.

Anthony


