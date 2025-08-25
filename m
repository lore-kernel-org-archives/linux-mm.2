Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03C87C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 22:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5ACB8E0085; Mon, 25 Aug 2025 18:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BF98E0038; Mon, 25 Aug 2025 18:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC6F8E0085; Mon, 25 Aug 2025 18:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78BD78E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:37:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92AC98454F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 22:37:31 +0000 (UTC)
X-FDA: 83816742702.30.10A8E2E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05E9818000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 22:37:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fv1gnsMm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3lJUpHM;
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756161448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcUYL95dapiYq08QlUphD/7y64sKEBpWX4h7lvHIcnI=;
	b=J3tyYyJbB4zf4/x3TNmxd4poUeHBBy+pojZORUO+JRC4/7uXknzXTbTSCRYRO6KoI9mAa4
	jqwaVViHdVCgf9QqRUdtFg1cNul8G5bmf2fvU0tKYSZ4vKhH9QjJrHmekhfkeSEvK7lJMO
	oz+Onzjp2UedLd89M4hQHbmL9a/ugcI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756161448; a=rsa-sha256;
	cv=pass;
	b=hwKkVKg0wLJpya2aonnRmFWJKrDuVVHbT3BHF603s9ylm01BKPreWEUpNrzwwZHxZpNw1e
	k8yQQ5pI66tnOPjS/Na9d1jnpegCr6t1ZW/1tT47QMOdDxJFjE9CWLoK2+w63kEWxBVmIg
	/UBP5VFG7zG25f5lrZhjiyivXT9RLGI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fv1gnsMm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3lJUpHM;
	spf=pass (imf16.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PLfo6l018077;
	Mon, 25 Aug 2025 22:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xcUYL95dapiYq08QlUphD/7y64sKEBpWX4h7lvHIcnI=; b=
	fv1gnsMmLLA2cfdvBeW3goQMoDMoYsk7myyyR13JAK9wulbYnld2QLTOROwVCj74
	BepgeOqwAFfyHhgWBiTZuFs60xHhN4WlCrPd0yn8T9/Lz7dc4vltw5nsnK5z8o+0
	VScEHX8/KaLX+Bs9mOP+vQ9wPE1gczhdm9sFIYVAfUPEJYngAXC/grG2/+Iv9ONO
	eK1dZu126OHVMKKWvqrDcxDHKVOZ3qiW+39f0OX+Ay1wtsg2IYsTpQqqUOP1Unpr
	2Ru4Q6StvpfZXRbGXfcF9qU+BGIvobLIuCOjNUYv0cMYU9Tvqf/0ehT2gEmG9Ohw
	dqouX6FHXvDl6SVIlAB5fA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48ekb5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 22:37:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57PKM1CQ005309;
	Mon, 25 Aug 2025 22:37:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj891shj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 22:37:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SmybutaApLvoxR9g1JYsdLrPGAUKS9d87HrNjuP33jvPCTncsq6ujRjyN6Uf7GHt9bEC7Pr9BrmdwJwg3P/Rf0RcuV+0MbLpKDavSSM+1EvoQWLlCXbQqNqdgBfAmyDkvkxBDkKAD3RtL8wHAzGoFLGUVNH6lXPKLf3Qhw76SW9hhy+zb1nXefStmKd/WYRIeC6AQ7YO07I5V05XjOaZpBPg1SKx7+a24IXJ6N5/1XSUjMLMA8vKWgv+eY06P23YgDIj+vUvxLXvRvMXnM3qSvAzs4JY2EMNhWLf3qNOZq11iiw4n1ekfVuJNYFT8lWbD9HfMVeRKreqTCq379VElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcUYL95dapiYq08QlUphD/7y64sKEBpWX4h7lvHIcnI=;
 b=XuugaXkA7b6SyVWZaKooBV3npm9SRSq/TWpHx5bnKGpk+MY0KaiKyxffDQegXjhQsL3BOkswVbZ5+jQb4937vTHyexeoOS1X7YLRflvtXe44E+dApwu71mXmaXGhwrHVVUfGymIEzQpAOlClVtZd2jhY8YshPVJfMmB4A006CSibn7h0vEX0xFC5zT8gLr7PjqAoFYt0CiB3SskhCSlAuph+oozNbhNueve6M6ZMLuktbBASw1sXsi6vQbDvZfxuY03QZdp+IRISgTi2Jrbahk7XCF0BpPmEEtb6MMtbdDdGBM5K0kjj2MpnlgIYCx0xK35ORVzjWv5zGqKExrlQ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcUYL95dapiYq08QlUphD/7y64sKEBpWX4h7lvHIcnI=;
 b=W3lJUpHMwIvrYQJMQPeyxnxYSF7TZD4SZg1GyVWczonPfYgvZC8hZMGBel4wIPiNSbr5pZcXcw/PfFSUPkXZjcxCZXuKk5ougUJJLIiwpSOlYmaaivq6fqWEjUiZ51NB4A5LsRB5TYQBXAg4AmepgxYiibgAdp4ucOOE4YNyFsk=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BL3PR10MB6043.namprd10.prod.outlook.com (2603:10b6:208:3b3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Mon, 25 Aug 2025 22:37:01 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9052.017; Mon, 25 Aug 2025
 22:37:01 +0000
Message-ID: <2bd5c32b-dfc4-4345-8cc8-bbda5acdc596@oracle.com>
Date: Mon, 25 Aug 2025 15:36:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, akpm@linux-foundation.org,
        david@redhat.com, tony.luck@intel.com, bp@alien8.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
        osalvador@suse.de
References: <20250821164445.14467-1-kyle.meyer@hpe.com>
 <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
 <aKd1K3ueTacGTf1W@hpe.com>
 <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
 <14a0dd45-388d-7a32-5ee5-44e60277271a@huawei.com> <aKyKort2opfQYqgA@hpe.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <aKyKort2opfQYqgA@hpe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::24) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BL3PR10MB6043:EE_
X-MS-Office365-Filtering-Correlation-Id: d18d68d5-89a5-4f6d-e460-08dde427e87d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGpab2o2ZllVSW04KzdYM0NzQ1RIRlB2eUZlTmF4d0hLbzVVdmZuOEtJVDR0?=
 =?utf-8?B?VmNSSCs5K244WFdpN0oxUkx1blhCNmZ6b3JFQVpxTzR1eGh5VTVjUW9od0tK?=
 =?utf-8?B?ZU41S0p2U3ViNmdHY2EyY3RnTnZYMUdvRVJkTUN2ZkxWQmlQYWNleFg4OG1w?=
 =?utf-8?B?UW5SWkQ3ZmxGbWdIeUlWcUlPUEdVMkxiM0FsWmtjUWtMRm4xMTlQTFc3U2p2?=
 =?utf-8?B?ZC9mcnl2aG4vc0crK0NGeE5najhIaWhta09XMktQdms2aUpqb2lMN3FIZC9i?=
 =?utf-8?B?Z0tFTXJqWjNEcUVjeFB4VStldTdySDEzWUdJclVUY1V6Z0pwYWtrMk0zcDFy?=
 =?utf-8?B?aVBITGZFd2xReTR1Tk9ibzh5T3JEanB0Unc5VWdmcXVZUkxpRGdjRVczeFBL?=
 =?utf-8?B?cHhmWVJHNk9tOXlQL0t1aGxRL0lGcVgyeXFwVUtDRVRudUpKTkU5ZjdTME1M?=
 =?utf-8?B?WGVYU0RCTDA4dUxTbTVEMldYNXhqTStYUlhYT1h2UElOSmdmS3ROSUxXYVlX?=
 =?utf-8?B?Y1FENnovdEZQVmtMSm04ZC9OWnROMXJNMXcwc3FrS1NEaitDV3p4S1BuL1dx?=
 =?utf-8?B?MmRoSk1tZ0ErS0ZnaG44RldLa0RGRXFONGovVVBRMGNXV1djRHd6MDBLdnlW?=
 =?utf-8?B?aituZld0STBOL04ranZMMFhYSTc0VFFHRGRkZ0VnNVRXZVlwS0hFazV3SnRK?=
 =?utf-8?B?bzJOK3YxRTJVOHFkQ1ZBRjVZUWkxc1FMeW05a0dKY2F2NTJkd1BzY29ySjVz?=
 =?utf-8?B?NXB2ai9OVWVacDNrNGp2QzVVdXFqTTlzclNRblU1SElBYlF1cDQwTTFuTzJO?=
 =?utf-8?B?a0hMaDFpMmoxRThzbkhQVU9JZkxSUWFvR2VDWHZML2xQTERlY0RjR2hLOHR1?=
 =?utf-8?B?eUhWUDRyL2d4TWZLSjVCdzBnZUdDOEx1eGw0bWN1RHVtUitOUEc5YW05N3ZM?=
 =?utf-8?B?TWphS2NSNWZEcldMclpiUFBCQTNjOGRmeEpTb1ZmbUdHN3VEMmh6YnNtVmcy?=
 =?utf-8?B?WTFYOUhaYzJNU1NaenNsUC85amZUNUpRMHB3T3BOWHFlQk1SNHBCYUVFUHhw?=
 =?utf-8?B?ZXVKcThUTzZidW91WVVDbDlJZGpxR2hVeWVwcTMyY1V5Yk95UlBIYTJGQ0NE?=
 =?utf-8?B?enNGZWYzRmN2Y3NIcmJ2K0RsM1FKZkVZRjRrQ21YSTFDOTliTldqVTFrbGVP?=
 =?utf-8?B?cFUxdW52dVh1YkdQeUR1eHdYUmo1N1F3eHJyRUpVOHNVQTMyVkpSc2w2TWZZ?=
 =?utf-8?B?c1AvMmZuaUpVNXdRckY4eXlYd2RxMEN4Q0poRHNZZzE3Nkh1aEVrUGNwaFR0?=
 =?utf-8?B?MG1Ed1lQamNJbVFheHBha0pPUlJXY0E5YTJtSk1wYTRjNitqYlZPL1Vzd25J?=
 =?utf-8?B?YURZZTVIcjJsL0hmZW9kR2dQTURIOFNGcndzaXdlZlUrNE1ZMWtyVFVEbmdB?=
 =?utf-8?B?VWh3aUdNREt4eG5Bd2VxMUxSUXc2YnZidEViY0pLTVJ5eStPdXEyeU4vcnFP?=
 =?utf-8?B?Ylp2Sk9NZitVcjZoY01jbkg2VnpoR2V3M09DdjhYeWhSd3R1T2lNM0lraUl4?=
 =?utf-8?B?alhpQkpKVmc5cFNTRVJNRXlOTi9LMmJNRVd4UWJvTjBTQm5MdEEzaUJhaTlO?=
 =?utf-8?B?YUZINmp2eXdyWnZFQjFiTmo2SHRsaWZJS1h5a0RDUDBIVG5NVm1EOGNxNURa?=
 =?utf-8?B?QU10eVBYVDYyVjhLVHdaMFUvMnZBWEw1M1J1OHJTb3hnVWZ4VXBOUTFwY0xm?=
 =?utf-8?B?RE1MZ25QMFNhZTRGWEMwOGw5YnJXTzFsb2txVnprYWtJUzNIK3RKMFhEbzh2?=
 =?utf-8?B?VFcybVJrNElzMUl2NmtEU0tDQkk4cEVpS0lBQUpjeFJWK242cStVTEVSYVVu?=
 =?utf-8?B?QkZEOTdQVUNGL3ZrTnFCalpmeXdoS1ByZ2VDVW1jNUNTZDhYM2dtMld6K1hP?=
 =?utf-8?Q?hjKXPAQNtUg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDNkbjc4b0JocW9VWlJod0JIaG9EeHBhYUtKSHNEN3JLbXlCNUFLY1Vsd21k?=
 =?utf-8?B?T2hZbmxCZ1c3emlqOTRib3ZaYnpUK2FkTmhDdDRaZ3NEdVJBQ1RoSkVSdXNa?=
 =?utf-8?B?WGY3c0htSFo2aDlWdS85djE5cHduaHdwNTlzUTRSbnk4Z0tCa1cxZVdTK2lh?=
 =?utf-8?B?Z2txdXo3Y2pmSnhIdTJ5V3FzeURQUVJ2bW4vMUNFMWpSdkdXTmxLZ3d5bjJw?=
 =?utf-8?B?OVBPNjMzZGRsMCswazZtNFhaV1hPd2U1U2xYUWxIMitOS3k2bkZhWnRKYThs?=
 =?utf-8?B?ZjFPQlZYSHhKcENjRmJCY1RSb3RuOXNGcStMUzFJL3dScW5TTldUUHIveW5o?=
 =?utf-8?B?bFZJTVJFTVVpbkpmQTNTMWdNdFB0VUZsaXRXZG4vdUdCWTZaRE1HTm81Rk0v?=
 =?utf-8?B?VHJsYjRwNlBNY1RsZUhtL0U3YVVQVFRUbEptcHFwYldCNTdyS0RybURqUlBM?=
 =?utf-8?B?UmltVWpLTlVBdWovbG5UOW1vRnBIbThNMUpNTnFTY0RqanlRUVh5bGRXTUdz?=
 =?utf-8?B?blVxRXdJbDY4UU12cDdlL1pRTHAyN3VrdHhJVDRWSko4THgxUVc0Q3NFaUtj?=
 =?utf-8?B?L0F5eE55NGJZQlBtMnI3THNzcGx1VG1VdURPcXRkdHZTTGtyQytrbmdTQ1Qr?=
 =?utf-8?B?aXNBSkoyR3lPSnpNZ3REOVBQczhBdXZab2pmWnJFL3VPY1JETjZMVkJQdFlE?=
 =?utf-8?B?SXNReElmdit2QjFzajNNa3FXQ2syUmVxVWxTY284eGxoTEJYSmQzNkdjbDFL?=
 =?utf-8?B?OVByUXRET3dJeVZoOTFUbCtqTW5xdnc5QUlERGo5UmZrV3RidUN3QUdYMTBq?=
 =?utf-8?B?Tk05UmZqYXhtRGZHdXVxdGQvL3g3bkdPM0RhdFhjTjNLRFhBMTczeW1hZnU2?=
 =?utf-8?B?Q0V0T2tGRCtFSVhVTVFraVIvNVRpYzNyN3JtQTlRUE5nOXUxZnJtMkszeWdw?=
 =?utf-8?B?NFU5RmtKYTNUNTJKWjZaNVNHSWtqVWNnZHNCRGhRbjNDclhNVkRRcGtNMHV4?=
 =?utf-8?B?WTNPYm1hSnU3RkhZbG0vRitSc3FuWlQvWHErUXl6RU8rSmM0Sjd2dmxhR2U3?=
 =?utf-8?B?R3MrWXJ6eHN5eGJ3RkMySFR5TmQ3SUhMcHhSZzBsRlEzNWlleVljZTBkK3ov?=
 =?utf-8?B?OFNnZ2RTdzJta1pWMmExKzZJZ3dac2NWZkZRLzJBUkhKSzBqMkF1dkdvTUFT?=
 =?utf-8?B?RFVUR2FiV3J3VXUvaDhMZkkwKzZVNWNzVWVUNy9pWjJmMU5KVlhNZWhheENT?=
 =?utf-8?B?Z2xTTG9YR0t3UlduUGU3T3J5a0cyTFBjbXplVnpBeEplaStHOWNqUkpSRzFK?=
 =?utf-8?B?RkVncnZaaUQvd2Jid2RvZVZ4NkJoNFRiUTBLUkpURWRmUzB4eGVORVdqdktj?=
 =?utf-8?B?T2RNQVZtSmVMcXZ4cnNkbW1yOXRNTGh0bXVyNXhIK1BsWkJPbVlkcm1tL1Fr?=
 =?utf-8?B?VERhOWhCbnJ5bnlOYWxUTWV1R3I5OWwra0duUVZRZUw5R2tWVnh3dTlLZnZH?=
 =?utf-8?B?VDF1TDB2ZFA5QmZreEJKQ1ZjdFRwckY3K0pHY3htUE0wNHlWOEx3bm9aVmNW?=
 =?utf-8?B?MlNpMkRSQkpreDBjWUcxNnJtZUFvNmZRcGNFUjU5Ly9hYmpZV2V6UUo0b0FR?=
 =?utf-8?B?Z2xZUjNyUSsrWWdOZ0xuN3lQNVVmS0FlaHlGL3oxYnNBSmtzNEZhbmQwTWlw?=
 =?utf-8?B?ZG04MFh1U0hRMUl0ZmR5Nm5XaTNZaktKRWdvU1ZtSk0wZW81ZVI1bjVGNUdN?=
 =?utf-8?B?a3BRYjRzdWJSUHRuL0xxcVJuS29uQk9aVmJEZXlMY0x0ZmRDRXB2YktZc3B6?=
 =?utf-8?B?bjB2R2k3V1JqY2R5VS8yMDRhMjU1RVFTVXhQZEdkcGlYbllXRGQrT0RBVy9j?=
 =?utf-8?B?bVR0QkYzZWNWVjFxN2YyTnpjZ3RWSHV2d3NOWHh6ZXpnMm92RGpyKzN5Ujd0?=
 =?utf-8?B?UVlia090V0dnUjJpRnlLbzdxSDVaTmN2QTdQc2FpNzVLdTM0WnU0aTJzV1Nr?=
 =?utf-8?B?MEtiVXRHeXVCeUJlb0ZteVNCUzlxa1lHd3hONjlFdXVFaEV4NURZSW5DbXJ1?=
 =?utf-8?B?VFdDOGtiM0RIaUJyL0lkSFdSV3BXOHZtYUZFTzF2UjZyL2ZZdlZPcHVJTjB0?=
 =?utf-8?Q?mmKK5CumHRsbpZIzPk/5Dc/rk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ptfym7E4IbuSt73cmRO3Kn638/2Vb4hGNeByuDqcnDS38nb/H3OH53E5z87hhU12rC3P2oynMNT/DO1ftUtBbsMQHLUV55HoTwKV/jqlmyUgBtvnlEOt+oxnsrJ9ZbxImzHaEjKLPhh32zrDSBRwgbL9lflFuwlGDKF92NFqghJVzWyG4i+COp3FIPJSaVCZv1nLOp1L4JLheT0w733vU+sfbzfzROFyg/Mtr2vmK4lVdrBAet5js96HdBN5g4/L/ffe16TmeDNQRc6EnjmtSfw8bi2RfRhe/G+SttrLDm7l8ewtjUhrGxvg4ISLIRMjwmA7FMbNBo86icn+nna8sJfMjaajp85E0wBa+rz7yMAnjWOmQumv63FYpvjEiWuhv6UW9GIUlTo/M0zw+A/hG6931MdQoAGJ9w+B/bRvF8ZxNn+QNk2aQz4Nb6zV8s74TYhfTaoWoOX2zBr96TptsATRDZL0Tlv5GmmPSaX3bd6zlgqjMJR7HaFVv4au+bHAKrpL+mDQ+jBXJimadpEg8k3/FekrVsrf1it0hYlQF7HLzJI4SKV/7+Vg0x9HROMwaaiiguo3WmICe38ka1RGIESyz5CRLUeHs02z7ZsPvQ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d18d68d5-89a5-4f6d-e460-08dde427e87d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 22:37:01.4162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3SbYLKvDQe8W1ewvGgh4Yhm7hcg7SPH6bSR5eYqL6AR8OUv/hfGdHEICGW3qg7z2zsn3o734gSv2kQrMickgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6043
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_10,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508250204
X-Proofpoint-GUID: d82s99zmzHmBk9NjzynSQdHdgN8LkO3o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfXxB1d62iWlgRw
 sGgwJ1RJgeuOd5t8Ne8pRk7bKGimiM0somLKyc+9ngYQ65kaX1RqjfX0+a4nyola0rYAZiLmIXj
 ZGXNdk1XJRQnwzmnld1TRI9syqiyjEnuPVUQ6LqS198hJHDl9g83KEE67PT/WnZy5P+wXOwK4y5
 V6FJrL3ZuxJayc57oqHHmT1ocEFsgLFHNK6nmL5KPp+pfd5uqBPxN5R0dClhWNVjcjxuM5k80HF
 Rfiw5hJT9oHiWMatLfr5oNE201KGa4gUXkXJPQun86eBHUQWIkFTj9Qx9aHm2YdBvEMMMXlW60V
 n6VfZsYI/wHiLn1YiZdpp+83yHrEEskPEQHZkGlYJry5dKV7+8tsjzGeEMMvpMofQDsup7n1Ij3
 Gwcw3mNxJCDZEEZ8BgVmI85MJPleJA==
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68ace591 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=MvuuwTCpAAAA:8 a=sbvPZ3PzvgV7U0XpqL4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: d82s99zmzHmBk9NjzynSQdHdgN8LkO3o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05E9818000C
X-Stat-Signature: rrw6rtu9ch9rwqanny9uhyd878dzqqhd
X-HE-Tag: 1756161447-52559
X-HE-Meta: U2FsdGVkX1+09iyAImAalwQiroOCkSgvk1qWKjdV0lXzD8pphg59ooEP+H6ywWNJvjtCiDFfZEw2S5AvTN73D1AQUdInqSJplyX5Ztwo6iHBSAfiLEIwmN/u4nh6+v8kt6Jml8qmNINBnaBzvTUuB3VilScCjKQrdORYXMAiqr2r5k0FFOY9WVwsvhvudK4NemfdBuifsbRY7oFAxmXVhdu8h7ZC/lnMCcf+tjWJtjgcNxEs7ylrY1kjKgeaR07iffDljXoT9a+oqsjjQD4XWLER032rHT4sYClqkfj+yMZJ5OXl8AIZLBotLrgkIH66WV0c6g5gd8GgLrj7nr3NYBsN6h9IpAwKVbMB7btNxuBqXOuWqAAWrh3a+GX78oe8eblioplf1j+FZ9aIbk1SfSYRzK5pK3YadDU+mKe+70Hjp20f/U4q1Ttp7NQL8gGDZ/5A/Bl/J1GDBJ4GSccQzwGUSzV9RO+3jPWpcLikU1vNpxONN6qA4xGyfgJVmhQ9FbuFoAk8VsoaDjUgVnJHtN1pnkrZP1ejjoyzSvLhyWTPqI3CyWXm1YGW8SzwE14ixLjn9hAjwYOvziTMUv8XDPK/bMM8UImdjtbg6Gmy8TcT1g3JB7zJHYEC6bD85zYcrSr1dEMO/ZQvoi90TUxrEdcWznYA3cn4phDNAF5JltLWFqrdJSW8hsuzPtU3PEV8FVUHdEuFUR/mw8VCKKC/voba9etFum0pEYeNB81vp2oyhrvP3GmmNYriP5P+4PS3+p8/1z1NFAofwcs/LAvfHLeWqW6r8MURrzjKpbKWFJ/SWxT2d3VYxgaIqHU75KXKZ3uCUafbDZ9ssZ0db2iCHe0b+GmXbZ1FIiXMullMz43+IDl7d969cBmnG7eblXEK5AXWMJ7P1hJkzRb037MpH+rUyA6yNfyCx6ciiYda6Y/v0ur3OXN0MhilNJ5pmzmn23IhjuI9dQ1zA6ZtZO1
 9UTEYOLu
 k5hPQlfdBFCyfO6jBd+NheJTrYaVzRnlVVDRObo0DCXbN/Yr9Y5JeBYJblEDZg+eNJfoS4DV/5kXK8ftmPyf12L2u60mFUjoG3GOqznQLEsPFPNwV+Uq0Dl7vt9VP4l5jqlIbWIkLKZaVPzLVIWrKe1fir8+LP8ZT/bSN/gi9U+mN1/6u/BOws+OauF5ntRLPIs2v6V8RKug5NFNE2FRxVXNUVxlf9vF+TPkO3rFsr9OJzIVIN4PdFvw2rRfqinpxUIp2hhxn9TC5Rb6Uf6Ak0PR8XCigXGnCov0oHwj1RAqeXsCWFGsjxd38gGTTieJV4WMm36jAryod9Vj670DvwGKm0F5UFXTH986RK89t5RSl93ymVzF46Fjaxz7sIw0ouWN+mMxOaUbZ5k1WRo4qiDdJSiG/F2Sf7Z7rRIp9w/T0rtlRWE8vS10KHbgO/D7HtMJ6+8z9XPbHSvMtI3fQYMnk9EEQ+VslHWvd1kUJn+vuT9EwxsHPkHiJh6vunFnN25+OlYs0W7C3SNGFKUzstF3+SiefVCh0NnRcgJc/ZLjcgnGGuy1sF/VCyMMBd298+KREej3OumO2g1qeeBm0gVmtYNRXhzsq+u7i/esoDvuyBpykM5mM9sW8DtK7YpfuM9WiRc2WwZFDB9N76TnDhIy3zo1sG/XiOry7pFA1TGF/lh0yQkFloTGtdTA51VDS1kmPcw+F33ppXY6sNKRihi3WGzbrkbpmre0t5El2un60F4WLte8jXez42cTEsub+wtWyAJAgtSRf05n7iO06HEfIPzYQuT0PtDEUeF55hwT7yMsaGbGkVl/DBMRjLFrmYFBjoZm3AnMve/MOHA7GNRFxKfxH+1ePqUMRiFrLszsbvzo+i95PdHknWA3EmD6L/zFgQQzs9QZSIW4IebinjdhlVCO8Xh21RAoNUBFP605alNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/2025 9:09 AM, Kyle Meyer wrote:
> On Mon, Aug 25, 2025 at 11:04:43AM +0800, Miaohe Lin wrote:
>> On 2025/8/22 8:24, Jiaqi Yan wrote:
>>> On Thu, Aug 21, 2025 at 12:36 PM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>>>>
>>>> On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
>>>>> On Thu, Aug 21, 2025 at 9:46 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>>>>>>
>>>>>> Calling action_result() on already poisoned pages causes issues:
>>>>>>
>>>>>> * The amount of hardware corrupted memory is incorrectly incremented.
>>>>>> * NUMA node memory failure statistics are incorrectly updated.
>>>>>> * Redundant "already poisoned" messages are printed.

Assuming this means that the numbers reported from
   /sys/devices/system/node/node*/memory_failure/*
do not match certain expectation, right?

If so, could you clarify what is the expectation?

>>>>>
>>>>> All agreed.
>>>>>
>>>>>>
>>>>>> Do not call action_result() on already poisoned pages and drop unused
>>>>>> MF_MSG_ALREADY_POISONED.
>>>>>
>>>>> Hi Kyle,
>>>>>
>>>>> Patch looks great to me, just one thought...
>>
>> Thanks both.
>>
>>>>>
>>>>> Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
>>>>> but changing action_result for MF_MSG_ALREADY_POISONED?
>>>>> - don't num_poisoned_pages_inc(pfn)
>>>>> - don't update_per_node_mf_stats(pfn, result)
>>>>> - still pr_err("%#lx: recovery action for %s: %s\n", ...)
>>>>> - meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
>>>>> in memory_failure and try_memory_failure_hugetlb
>>>>
>>>> I did consider that approach but I was concerned about passing
>>>> MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. The message is a
>>>> bit misleading.
>>>
>>> Based on my reading the documentation for MF_* in static const char
>>> *action_name[]...
>>>
>>> Yeah, for file mapped pages, kernel may not have hole-punched or
>>> truncated it from the file mapping (shmem and hugetlbfs for example)
>>> but that still considered as MF_RECOVERED, so touching a page with
>>> HWPoison flag doesn't mean that page was failed to be recovered
>>> previously.
>>>
>>> For pages intended to be taken out of the buddy system, touching a
>>> page with HWPoison flag does imply it isn't isolated and hence
>>> MF_FAILED.
>>
>> There should be other cases that memory_failure failed to isolate the
>> hwpoisoned pages at first time due to various reasons.
>>
>>>
>>> In summary, seeing the HWPoison flag again doesn't necessarily
>>> indicate what the recovery result was previously; it only indicate
>>> kernel won't re-attempt to recover?
>>
>> Yes, kernel won't re-attempt to or just cannot recover.
>>
>>>
>>>>
>>>> How about introducing a new MF action result? Maybe MF_NONE? The message could
>>>> look something like:
>>>
>>> Adding MF_NONE sounds fine to me, as long as we correctly document its
>>> meaning, which can be subtle.
>>
>> Adding a new MF action result sounds good to me. But IMHO MF_NONE might not be that suitable
>> as kill_accessing_process might be called to kill proc in this case, so it's not "NONE".
> 
> OK, would you like a separate MF action result for each case? Maybe
> MF_ALREADY_POISONED and MF_ALREADY_POISONED_KILLED?
> 
> MF_ALREADY_POISONED can be the default and MF_ALREADY_POISONED_KILLED can be
> used when kill_accessing_process() returns -EHWPOISON.
> 
> The log messages could look like...
> 
> Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: None
> 	and
> Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: Process killed

Agreed with Miaohe that "None" won't work.
"Process killed" sounds okay for MF_MSG_ALREADY_POISONED, but
we need to understand why "Failed" doesn't work for your usecase.
"Failed" means process is killed but page is not successfully isolated 
which applies to MF_MSG_ALREADY_POISONED case as well.

thanks!
-jane

> 
> Thanks,
> Kyle Meyer


