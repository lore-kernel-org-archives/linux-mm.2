Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B29DCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5BE8E0009; Mon,  8 Sep 2025 00:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADA68E0001; Mon,  8 Sep 2025 00:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600388E0009; Mon,  8 Sep 2025 00:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47D478E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:30:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D11BD86F39
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:30:07 +0000 (UTC)
X-FDA: 83864805654.17.DE64747
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 65D3540009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:30:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MDQkmCBG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="v+ql/LEN";
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757305804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=me6ut3ItYqIjTLo7Yo36Od+8WBdFtnVubvvZRe0q4eU=;
	b=eM6PxcWTiWWnvvLKPkEhO3pBqCzTpvxHvL5cKZTjaWOtkfvicOTuKrfQWTxxxced/uVrri
	D5jWtjBP6cisOtMUGZVZveSA9JoLh6gYTCKySimiDiz1iVbAKa/LLf5rfSA47QOSemfgBy
	5Xg0lpHVkawDRZmU47OxaEgetWxp43o=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MDQkmCBG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="v+ql/LEN";
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757305804; a=rsa-sha256;
	cv=pass;
	b=r7Jl0rS5+V5/8+8hkA5Jpuueje1PBAqu10AIMI5Alekhb/CwdAKUIrHV7SU2DR/H+d3Lpd
	1dkCX8Wx/FICU8TM5jQwRUUe3pzATJonzJnYd63JC9El14dgBBJgi6SdGKlKpNfJQ3aZa6
	SAuz8HQjwg8MvH7mMc9Jy7huHTMcbRc=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5884PoLZ022387;
	Mon, 8 Sep 2025 04:30:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=me6ut3ItYqIjTLo7Yo36Od+8WBdFtnVubvvZRe0q4eU=; b=
	MDQkmCBGnNIamUB6EOep+oMuSkRlMZ3+O/khI+SYsDwapDPtgluRGWXpyhKI/NTP
	xOYqzlF4emCvEYlT4Sbx8JWPfbWS9uhfZvbnvbaB4CjU+OlwBP2tRMi3lJFiAECj
	AS76ZHKogl/Q29O2KK7RapRaxadNYzyg011e2FCzqMbLrZ/4dI0geMOjnlbRFm0v
	otiRJqRZQThgUMhJfCXWMBVhR/TkLXpJxaFi3IovetE60kDmVdSXe+9ihK+vW+ds
	UXf0hErTEWLSvcHjgCra/CJxBprjW4zYJKZcsqVSpLeujtNUNSF/VpItEJjpCwKl
	R/Ms4MjNajmrrsK7NVDJPw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491r3b006s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 04:30:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5881Ljw4038858;
	Mon, 8 Sep 2025 04:30:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd7nma6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 04:30:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yS0Ri4qGAGCS+vjuwX1N6FSfj9xAW7vfoTDyTfhp+fPglu6N6tXbNCsw2TvhlOfDkRWNOiN2vjFgCiZDgGB7+T7A4oAr7AOwD1HgyuBLkpiAJakHUWyvIqFJ6eeM7mZAfHvqkrzEGP1X2CXvob6IE3BYyShAY7l1Z3NS1R/wL1LGz9jq6ag5o8NQIQLP0pkPZe4hQGAL778x4zp8G1qFU8s9s7bxFnsU+8vBiEbznLopTNCwQ3rkUTzUwRmUIJtFIEX1jQCRy4HD92CJml2h4im3L1pDBJlV/cBck8Qb82iEYJtpR5h71+FbB6X+OINRxq9Z/DU0VS8VWj8F7CrUVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=me6ut3ItYqIjTLo7Yo36Od+8WBdFtnVubvvZRe0q4eU=;
 b=alwPLDbyh62X8l5Ac9K1RJeGCHfnt9oYj3gnmSNl6wBZXfkwK0362yKKf1xy/+Fc2OvCWJ0UR7O7NVw4782/aKsssKuvzLoj1vvg5aF/rV5T+Dh0t4ZgKK44TVcfI5MhxoMXT9lCFlNf5HkVzmSVFeWRfjnnnGHcecOoVZsIkhOK0zWPMu3A3viBhhsnrC9y9ilN4J2d1foYP5V4GZVGCA7Qz85SzziWsP4GF4S9nub2P3UMJbyH3BgBXjs+u5QdT9b5PaHsJUwI5Qpqq00t8PiEc3iLVawr76AGxcQE9RCJPjyh3y/QA+DR3U0lOW4H/tEK1yntJIgLA847dM7Nbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=me6ut3ItYqIjTLo7Yo36Od+8WBdFtnVubvvZRe0q4eU=;
 b=v+ql/LENgeae0IAv5uNY0vP6yID8C2vAKubq5slynkbsOJYoFIUhzukPrL/Rdtty9PnMJLVW2pQ6MrH0UgbRMT4To4hLLYdRKkpZz6knFJWoMLa3xlVmVp3izGlg6WHCSwh+YKvAlQpCL3ohlAnYqLYucdlKc/jxyglYGlsfGbc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8010.namprd10.prod.outlook.com (2603:10b6:408:282::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 04:29:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 04:29:55 +0000
Date: Mon, 8 Sep 2025 05:29:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: make num_children and num_active_vmas update in
 internally
Message-ID: <45ecc4be-8a81-48b2-a51e-d5ca1aaf62d2@lucifer.local>
References: <20250905132019.18915-1-yajun.deng@linux.dev>
 <7c0101ac-afac-4601-8be9-24587877a5e3@lucifer.local>
 <71a4ba4d4bdf8cb1803b3907f812821792d86391@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71a4ba4d4bdf8cb1803b3907f812821792d86391@linux.dev>
X-ClientProxiedBy: GV3PEPF00002BA9.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:6:0:e) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: bc02591c-5456-4682-c465-08ddee905c41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmhTQ1BxaFpkbGlxY01MdGd2aElJRWFaT0U1WnoxUmxlcEQ3UEE1RDJXL0xY?=
 =?utf-8?B?RGdrazFRQ2l6ckdialluMEQwN3ZqZXM1ekU5SVQzV0ZLY2dwV2ZCb1lsMnp3?=
 =?utf-8?B?ei9obmFBdmtTYjFmQlZVN2JxaTBxcCtwTDBDeHFpU2IwUEY2TWI5M2Q4czZE?=
 =?utf-8?B?SjdUakV0T0VDaTdyWUtFQVNYRHdnT3NyMnR6R2pVRFNVOSszc2k3SWdmQUxW?=
 =?utf-8?B?N3BYNEo3NzBuTWVhSXE4dkozNFhPNXpra0lnMUFhTExuSS9SRXY2RkkzUXBK?=
 =?utf-8?B?VWR1Tysrc3JGdjFsUFByQ3N1ZFV2eThsdVVzRWp3bWlFR0l3eHNmZDlBOEJD?=
 =?utf-8?B?R2ZCMW1ZTHdYTjJIcm1NZDlENmVPdFhsbEY2dUF3WU5zM2lRbk5DYnJuRHFD?=
 =?utf-8?B?YkxVb2ZtQWdmeFhrTkNKWlIxZCs0VVBuVzZ4UU51aWZaZHQvSndRT3FIL3ls?=
 =?utf-8?B?dFBRYnM1MGJNRzNPZWlpQUQwZ1R5Yk1FNnB6dDZzOVhwZUV3cmJDN0dyR3NC?=
 =?utf-8?B?VWxaQ0oxSlo2TmFJL3pHTUU5dkJ4UkphTnJnanYxdXhrRHJSK1VhSzZwVlVy?=
 =?utf-8?B?UWtuc0FtTVBFemxjY0xMeWhBWVFRWFV3U2Q0MzEwbHpTQlNJblowWUlyNkkv?=
 =?utf-8?B?Vk8rR1I0d29mU3RVNDcrQjlkVTk4dFA5MkovRnFheFF6RmRDQ3JUbDJxbllj?=
 =?utf-8?B?UG1QK084Q3lmbTRhZjZqcy9uMjFtTjZYYlIyUGtHc2hWczVBYVJVMjJUcDN3?=
 =?utf-8?B?YitqdUFVY1Z6QVpRVDh5dWhIeW5TQkd6TWFQNWE4bHRhMG1xMkNBc1JUdTFy?=
 =?utf-8?B?cGUyTzR2MDVDRENNUW1lUG1kQWQycWp5MlVHY1NmN29QRTNMUHhMSkQ3eDF0?=
 =?utf-8?B?ekFud2RvemNaazlYUFJ6UFRMQk9wdFhnejF1eGkrak9DWmhuK1ErUi9RSC9w?=
 =?utf-8?B?WlY4YlhmbEZ2STZTMVo4U093TGtraHhIU1BmQWJVVlR0QWJXbW95bUN2Nnpz?=
 =?utf-8?B?WHp1aWJKQjk1VWVFNVJRdGF6Z1k1UCtIeVFXTGsyYlpKRm1Fd0dEdXoyUnRY?=
 =?utf-8?B?M3UrNGZ5VWx3eHZlVTJtdU5SK2NVcUlKa1dUL1Z3RXNJVnNYbWlPMk5weUtW?=
 =?utf-8?B?ZkRrakxBUlAwOTl4OXlIbVpCRDNYbmhacWhnSTBsbGhBYjhoK3d4bG5CRzFj?=
 =?utf-8?B?K3czaE9SbHQ2ckd1ZEkxTWdQQjlGc3haRFEwNGxpS0Y4Q1AyTFMxN3Q1Snc2?=
 =?utf-8?B?b2F1aVIyeVVQV21KcEs4WkVqeXdPUS9QWDVzZjIxWlVGcVBsUWcyYVU3VkVD?=
 =?utf-8?B?Q2U0U29XeVI3SFgvV2cvak9IOXpmOWVNR2JjcUYweG9kTkUvckFwVVZIVU9S?=
 =?utf-8?B?RjFSQUR3cXllWVEzc1BUYnRkYUdHcWZVYjdzeUprSTBqdnNRTFhDRkV1d3g2?=
 =?utf-8?B?ZExLdGpZUWYxMSs0TnJEK2ZsTGJmcVQxeFNTRThHQVEvTHNpcmhMa3ZTT0Nq?=
 =?utf-8?B?UmtWWXQvQ0hJdGdTQXQ4WkVhelcvbVR6d3BodTh2cWw4aURkTEhRVEVMZ2Ro?=
 =?utf-8?B?dHBxdW1tV0piRXQ3MVdSSlR3eEM2TmRhcUV6Yy92VFMraHBzc3l0bC9OdGFV?=
 =?utf-8?B?STI2cnk4d2ZEZE5vbVZBcVl0eGdvM1RGQUNlYkdjc2gxUzhSSUYzTE1FM1hZ?=
 =?utf-8?B?ajd0eDNGSnVNT0xzZThXRkZTUWdKdEl4UU4yeDV4em14N1lNREM5eDNybHpq?=
 =?utf-8?B?aVdVOUhvb2J3Nk42UVROWVNlMTM5Sy9ISXFvdVYzSWhERXgzaTBSVnhRSXFN?=
 =?utf-8?Q?4cMBRsGATODxttdaa1/nCxVCjEEey+k098N/E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVZVcERwTWM1R05MeGtiL016cERyektnZjZYWGRCZ2poYmgxSUhibkVTWDAx?=
 =?utf-8?B?em1OVzJUTmhkcUthTk40eGFMNUpFMUR4Q0ZpRDB3aXRWMU9nZVhsbXNnVktX?=
 =?utf-8?B?Um9EVXNZcCs4MHVOS2RpTVh5RVFndHdiY1lyUGhnYlhEYnBNM01EWm5POHM1?=
 =?utf-8?B?bEJrbDJwRkhucDVJRzB4NUNraFhocDQzOGNPd0hlL1dWOWhTcTlVN2hHT2Zr?=
 =?utf-8?B?VmI0Q1puNFRKMlpEeHdjdDF1SDBZMWhOa09YRnpLVHZ0RkgvMUErQ1N5SnN3?=
 =?utf-8?B?cGM2eWJiejVMZEV2dUdCSzcreExyMjFHZzRkTi9qRkJ3YnJWWUoxUDVvam5t?=
 =?utf-8?B?eUh1Y0hDMVZhNzEwK1lZUmc5ZFFNRWRHYmIxcGFXN3R1OTRSeThDREg1amJS?=
 =?utf-8?B?dG40WkVWS1ZPaUxaMnJ5MUlMVFRzNW55MUxYWUpITFgwTTF4dVZlWGFWckMx?=
 =?utf-8?B?RC9iT01id1pRL1M1dHRtbU5ONHcwdDhtUUtHRFBVWEMyYUFVY0krbXlGZDNy?=
 =?utf-8?B?QXhpTU5LdC9aMEUvUmluY1lyWkE0OExGb1Z2UVZNWnEwMEVkL0VxMkkwOGxs?=
 =?utf-8?B?STN0R0FDWFpDSytPekdHelYzK0tqME5Rc3huOG5rdTU2MEZPZkxJSG96d2Zj?=
 =?utf-8?B?MHZrRjN5SG0vNGgvTkxWUWczblE1Y0hHaUZUQXN6MUwxTHZlQ1BRS2dTYjhM?=
 =?utf-8?B?SHQ0VUthOVpZczNHV2d0ckJYcm1NVWRKanlwWnZ2NExRVkNQdUQ0WXRkS244?=
 =?utf-8?B?K3hPNHlnM2t4VEMwQ1RRa21jVDBVQTljUUdXQmJQNEVzY0xTRVdwa1FaRXVQ?=
 =?utf-8?B?cjFhS0F5NUlHQUxpMXZnVGFzUHVlS0I1dnlWWFhmSDJ1Rk1CdEFnVFE3K1RX?=
 =?utf-8?B?WGJpMzIzVDlreEUyL2VrZitFRGJObDFHblJmd0lUalV2ZjhqUUpHb21maXhK?=
 =?utf-8?B?QWNjRlRSQ1FNRk02NXZKUEtqT2ltaCtXditVOStxQUp2Uk1yQWxWUStUeDNt?=
 =?utf-8?B?MVBidjRmU2thRWhwQjdORnQ3MTRjckR4NXBuemNtQ20xWng0OE1yMEhSbGlY?=
 =?utf-8?B?U1l6U05rdEhGNW8raWlpN0RFQUp5UEtROVh5ZWF2NzNtYmZ4azhzbXB1ekRR?=
 =?utf-8?B?MmpZSjhNSFJmOS9HN1dMaVFNbUdxSDFiUEUwK2xwMGthSWpGalVvVWt6YnhS?=
 =?utf-8?B?Ym52S2M5R0ViaHdBRnhLK1A4N25kTXJsM0VsUmhoYi91aWpvbGNmWDFwMVdQ?=
 =?utf-8?B?dGFpeGJsUmV4TFRyZE92OWRUS0k2L0VZeTBlRVRpSU9LbVpRRktseU9VRE5V?=
 =?utf-8?B?amMyVEdCUk5FbkhZU2hud1lKbnVzK0VrdkNUSnBpV3B1SmQ1VzhRQlFpUENx?=
 =?utf-8?B?dStSMzhHU2xiUUY5bTgwNlZrbWZNR3BSby9lcHFUai95TjRVSmdiSzBwRzcv?=
 =?utf-8?B?UWFZRjlaS3JBVk9JQk5IMzEyT1NXN0wwOEx0azF2QUtIUHU1bDBoak1ubG40?=
 =?utf-8?B?elZsUkE2aFIyek5wZThBRHVNaWltanB6N2hXbkN1VlZ3bHlwYmplL2p4NUU3?=
 =?utf-8?B?T1gxUTVMYlgrWU4zYXNjWmtOcUxRYUNpT0NubjZ3MTlhUXByMitwTmU0ZmZu?=
 =?utf-8?B?N0Q5ckV2WGFMemprVUZtRlZ3cTZXbjc2cVlQT2lNdjFtWTNSb2xCOTZaUk5B?=
 =?utf-8?B?cnVHeHFERmFxVC84YVZaZS9iSkxUUXFpNjZNNXBuYzQzVU55NE9FTENRTWV4?=
 =?utf-8?B?T3h3dVEvKzhzbDJSMXA5citGbWViUFBvbWk1ai9maGFCMUZTYXUrN0c3U1E5?=
 =?utf-8?B?Nk15SlUrZWhWSS9WRTlhUkMwRGE5V1VhNGlOZ3FVbUZnQWYwc3BEV25NRHJ3?=
 =?utf-8?B?WFJseVpSQmN1emdSWVBFZFJ0aVBDaWNVTkFYeXo5dFVoeExpaWZtQjRRUndF?=
 =?utf-8?B?Kzd5ZTNMRFpDbWNRUUFzSWQ1STR4RXp0ZnVkOVk2bWZhekJFd2xJZ09vcHAv?=
 =?utf-8?B?MSsrYUJIV1RWcFFZOWhtWnQ5cGJmTTBHd0hFUlVHcGl2dHpWeXpmR3dqY3I0?=
 =?utf-8?B?UTNUUHoxM2FXQ1RLMi9hL2h5V0RjcnJUc2lQdGgwTzBXdkhlZHBRY0JnNmpR?=
 =?utf-8?B?RzFBbU9RY0dVcERKMUVHekRVQjlIcTJia1F3MlFsVzYrQzE1ZTRCTndhKzNi?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P6MkFQprGOGAzZNGCClZZY49LCmoyTofJbHzcMIfOXSxQEhRII8QIvuE9FWuanlNX56AQnArPNV+j7Wq8TvR8IDtM+/C4yXYcGC9PEmWoj47lzgP8KICLJWkqjRYWnQuUEgTtqRiKHc16xW6nbu+F/uI9xe6cVYoGPIoblNP1qXdaGwrLgzEx4OvlOdR6i9EXCCC2uQeAkoQo13kdkv6JB3wk64rwlJ10pstQlFP0KTGZidcglNLydZhhnZ+OSZqVTncvWqEYW3jh/XH93NI40Ac9Zl8Z4RfgBlmT5njHsIVaBcMwzPRz0s0Xk8XPRn0JZnfXMBUu57rp/9up/woTSpwtXfCoyZTvkv4VTgcgmYiLXD5Q2f6vvfTj8jAnO1kn42BgAUhTCKNVjfXDu0tMf68mtM+KtmI8oOGGMPqbM6hkjX0UYJBm27/bJgWxf1GEfsc9lXXe0DNx+prvJT+kxUZA5yMlvflAge5shi9EhrDmBOqj5U3zyoKPJJYiLf0AmOGmHi4478fekMUnoUHbmBp2SCbfSLRrqXbmbQHjViCfTWXMDIhn0klmZB8AnC15YczHTMCFDR6JcZVwEEzh89Xd8XBdoraP5TXcR6zxew=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc02591c-5456-4682-c465-08ddee905c41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 04:29:54.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4f6Tx6X+lqrZHduFG8V712/K1WQTpTWjgapJBcTk/AXRFK+H0UBP2r3/i36IBFV2Cc4/c7cFJ6HsIqHL/lOC8G9ZXil/27Z4JkDPsP2+xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8010
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_01,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080042
X-Authority-Analysis: v=2.4 cv=Cs2/cm4D c=1 sm=1 tr=0 ts=68be5bcb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=G2h55u9CbzdNexclX84A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDA0MSBTYWx0ZWRfXxfv66LgbEyPE
 LoYKQ1sL8TZewtkjU6C0R6SCbizARnXgI0Ic5EB/3rcmp907tUBJ4zdUF3b7BP82YSR7nnZMDt0
 Kie+V4M06wAQX5N8jcxsDgNdA6CSbHhHDZBLrIb1MJRz0iBIPQs3O3AqADy75tmt1PXyJhWnbnH
 L3C6dFacqVjdhW/RvDAjboM3qpkzv15EU8G7sRGJdKAs4R8DaloVAeQBDYoUoj5TsXzei6axTgA
 c/cOZYpGRxvK1/cyF8jqKu6KaxYOyr01kaCAwQeNPj/AL0f3UnikMi+T0W2G64ShBWZeEUPZeH9
 vreqfTelMx2KUDUKleSSBw54ioci7HT9d3G/jjWOGjjSnJeYADQxmKKGTuv0Vs0vJN5oEh0x04s
 fCo++R6xSrnn4uMqrH8ZvaSNZEOPwA==
X-Proofpoint-ORIG-GUID: zreY9R7_6zmo8jLzsHjCcQJ91YDQRvYi
X-Proofpoint-GUID: zreY9R7_6zmo8jLzsHjCcQJ91YDQRvYi
X-Rspamd-Queue-Id: 65D3540009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dwktyu4w6bsupej9hx1ogeiefuiddh6g
X-HE-Tag: 1757305804-624840
X-HE-Meta: U2FsdGVkX19p0J0mJK20beZ8kWNsqrti13ARofoKUNkT2zRZXRwtsRNQi7UvtcS4ftU0cVJsnroI7V06yMosdm7M+z3VNa9CmUej07cthWtMbZvlBua/kPoGGupg9nOYc8wTU1HhseoP/fFH5U4QczOIraeX+80VIWZj46De/btj5eMkmv/CP1Ied5f6wi4WaRuw5zgqe8WxHZ3+A9qm9DbCBSBbO22PY7FmCQdNST0GWysGBkLSOzhNkCsvsy4pk98u3l5kRwmYmMfsVE/KjSkT+F+I8K9XA/lD1QLNVsW6VqqoKtXLaqPPX2TxpJK1SlBi18JkMkYgKgtLvM3ql4g+ObqxUXvwMPkEjm2L9vnOsF5DeJ++WYlsX6lmYup3UtQYkT00lUZfLZtVzGG3GawtdER+F87K+lY8soFuX1O8kF6HJ1p34A2fGwDU/Zgz8jCLvfw5QM7Bz5zR99KqGZHLrApGIOZ2u8zRNBpSBU9wp53PEFsjhq+/A4RkK+1igQVrH9uQu2VSdUUipSGOIIXBRo2Bgpa8FPVb6r1tK/gXEy1BZi4WxeOp7yTFgL5+6Au8CYLmOeCjH/ePbmAiMH4s3RKIck7RFE0bbtasEjVcxd4//JR289frxKP2rilVjVhlTGYTxhoTeEdgQxus790EKBa/5VhXk8Wbg1e7RwfNCd1omt0QvnJLv6QRdo4+gUdY8KeRAloXGL9y6Jh1DTi4C1tiFNW2kQC/YUKzkPzcDEuah9j3vdZzmGUIH/HKEp7ARu/MRffEc1eHIe0YLOMz9kZx2PYt23YOSqIdJAIGCZzXNPGNN5BDmrUOlyix5D42MiOGO9iBT0Id0aZJYUqPgEp1c6f8yabPCJQNNBnGxZJ1hbg0cAiIzMjAxYgmfQvVmzAAoQqFQgW738Ux8pDB2x51PVdYLRf3rxu+Oyt0P9G7n0tf+Bmee8XqrUrCKLQSbNCxzKAfMCaN3eV
 5BY3EiJO
 0tI3ktnra8ZQsJqy/vbP9S27p3xxNtviIyzeGXhkoYK2gewe8ljOdoOjRg62VXQ2p1F+YR3DyXyqAVsd2+yBeGPj9LAu6VEglPRsSCiwyEqtpArKcjtqz/o5PHUQQsJmG+7EG0HjwDT4tz8YbV2HlvNzFJJTGEvo7ddRLCfBPH8DmAztG6u/ZJCgih3ZEjg743TG7TpvJg3XXoZQ9TXU4TYvAbr7SQ1K6r0xLvhD9jDmt0TVrPDtVSgGnuxbMtGcZVn2wi97DZHyeZc+qUP1VIHbQI5y6/awB5qrwhsodSj8nlVcEAakM6sSH/l85HPUnpCDuF7yscIQR+KbpS+LtzBHbpVQS35B0yVAu9fn9ZETbLuQKr6ylzhI5BipKKzz5Wr4te2Q0kTTyr+l0LAPaI8+Zdh7zUyXTI0jgbFrRvxSXdA+DaRbW3WTMppBT5kcGzKO4vI4BbkUmuExDlFEGMXtuocSQ1bsFOX+p66QNYoXYOSx3Gh/CWySU859GpiRpol7eQgP76nBFsA9t+pa1MmwkGCHApIRY3VXjtdzyCMfx6i5r6EjXnopvTDJVFNUj2GW+rMwRJRhBVS1GRGBS4LjEp+rhIuZsv94JQb2b8EgKTNB1GvmHa2l15PSwGcWySxRr6r1UzO32MlD/bnKcBUW1PalNwBxPC/9CtIW4rhsCzDtWG9GmcLxqbz76BS/SzPaz1T0+UjxYjYNnA7DhTwTX5JI2+45+90asul3dLgBFs8z6EkyqSAJxsL3EP+H9l6ZlSJxbxdrpjNPysokhRcIoIc/A1GG4b923mwCh6tnZD3MQJO6mzaZiPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I guess I wasn't clear enough. NAK to this whole concept. AFAICT there's
nothing of value here and you're fiddling with enormously sensitive
code.

Your first patch is incredibly broken and you've obviously not done any
testing whatsoever. This is not encouraging for code this sensitive, so If
you _insist_ on sending a respin anyway, send it as an RFC please (as this
patch should have been!)

Thanks.

On Sat, Sep 06, 2025 at 02:50:17PM +0000, Yajun Deng wrote:
> September 5, 2025 at 10:58 PM, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com mailto:lorenzo.stoakes@oracle.com?to=%22Lorenzo%20Stoakes%22%20%3Clorenzo.stoakes%40oracle.com%3E > wrote:
>
>
> >
> > On Fri, Sep 05, 2025 at 01:20:19PM +0000, Yajun Deng wrote:
> >
> > >
> > > If the anon_vma_alloc() is called, the num_children of the parent of
> > >  the anon_vma will be updated. But this operation occurs outside of
> > >  anon_vma_alloc().
> > >
> > I don't like that what is supposed to be an allocation function is now also
> > doing additional work.
> >
> > And there's literally only one place where this matters, since
> > __anon_vma_prepare() doesn't have a parent, it's ltierally only anon_vma_fork().
> >
> > And there are only 2 callers, so I don't see the purpose in doing this?
> >
>
> Yes, it is an allocation function. Some code doing like it.
> alloc_fair_sched_group() and alloc_rt_sched_group() are allocation functions.
> They are also pass the parent parameter to them.
>
> The purpose of this is to unify the code. They are essentially the same.
> One has itself as its parent, while another has a real parent.

To unify code that doesn't need unifying and moving logic specific to parts of
the code to a general place for no reason?

No, please just drop this idea altogether thanks.

>
> > >
> > > The num_active_vmas are also updated outside of anon_vma.
> > >
> > I don't know what 'outside of anon_vma' means?
> >
> It means num_active_vmas should be updated in a function.
>
> > >
> > > Pass the parent of anon_vma to the anon_vma_alloc() and update the
> > >  num_children inside it.
> > >
> > >  Introduce anon_vma_attach() and anon_vma_detach() to update
> > >  num_active_vmas with the anon_vma.
> > >
> > I really dislike this naming - VMA detachment means something entirely
> > different, you're not really 'attaching' or 'detaching' anything you're just
> > changing a single stat of the ones you'd need to change were you truly doing so
> > etc. etc.
> >
> > It's misleading.
> >
>
> I will use vma_attach_anon() and vma_detach_anon().

No. Sigh. The problem with patches like these is you end up
writing-the-code-via-review which is really not time efficient for
maintainers.

I'm really not sure there's any value here, but vma_add_anon_child(),
vma_remove_anon_child() would be _much_ better.

- No confusion vs. VMA attach/detach concept.
- Doesn't pretend to do everything needed to add a new child.

>
> > > Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> > >
> > Did you test this at all? It causes an immediate kernel panic for me when I run
> > it in a VM:
> >
> > In exit_mmap() -> free->pgtables() -> unlink_anon_vmas()
> >
> > I haven't really dug into why but yeah, this is broken.
> >
>
> I will fix it.

Please make sure to at least run your code locally before sending a patch,
thanks.

>
> > >
> > > ---
> > >  mm/rmap.c | 63 ++++++++++++++++++++++++++++---------------------------
> > >  1 file changed, 32 insertions(+), 31 deletions(-)
> > >
> > >  diff --git a/mm/rmap.c b/mm/rmap.c
> > >  index 34333ae3bd80..2a28edfa5734 100644
> > >  --- a/mm/rmap.c
> > >  +++ b/mm/rmap.c
> > >  @@ -86,15 +86,21 @@
> > >  static struct kmem_cache *anon_vma_cachep;
> > >  static struct kmem_cache *anon_vma_chain_cachep;
> > >
> > >  -static inline struct anon_vma *anon_vma_alloc(void)
> > >  +static inline struct anon_vma *anon_vma_alloc(struct anon_vma *parent)
> > >
> > I really dislike this, we only allocate with a parent in the fork case, this is
> > just not a win imo + adds confusion.
> >
>
> I will add a wapper function.

No, just drop this idea altogether thanks.

>
> > >
> > > {
> > >  struct anon_vma *anon_vma;
> > >
> > >  anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> > >  - if (anon_vma) {
> > >  - atomic_set(&anon_vma->refcount, 1);
> > >  - anon_vma->num_children = 0;
> > >  - anon_vma->num_active_vmas = 0;
> > >  + if (!anon_vma)
> > >  + return NULL;
> > >  +
> > >  + atomic_set(&anon_vma->refcount, 1);
> > >  + anon_vma->num_children = 0;
> > >  + anon_vma->num_active_vmas = 0;
> > >  + if (parent) {
> > >  + anon_vma->parent = parent;
> > >  + anon_vma->root = parent->root;
> > >
> > You are accessing parent fields without a lock. This is not good.

Ahem ^

> >
> > >
> > > + } else {
> > >  anon_vma->parent = anon_vma;
> > >  /*
> > >  * Initialise the anon_vma root to point to itself. If called
> > >  @@ -102,6 +108,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
> > >  */
> > >  anon_vma->root = anon_vma;
> > >  }
> > >  + anon_vma->parent->num_children++;
> > >
> > This is even even even more not good, because you're accessing the parent
> > without a lock, which is just completely broken.
> >
> > I note below where you're doing this.
> >
>
> I will add anon_vma_lock_write() and anon_vma_unlock_write().

No, please don't... things are locked by callers at the appropriate time so
you'll just deadlock like this.

Your issue is you're trying to 'unify' code in a way that isn't workable.

> > >
> > > return anon_vma;
> > >  }
> > >  @@ -146,6 +153,19 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
> > >  kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
> > >  }
> > >
> > >  +static inline void anon_vma_attach(struct vm_area_struct *vma,
> > >  + struct anon_vma *anon_vma)
> > >  +{
> > >  + vma->anon_vma = anon_vma;
> > >  + vma->anon_vma->num_active_vmas++;
> > >  +}
> > >
> > Yeah I hate the naming, you should have lock asserts here, I don't love that
> > we're pairing the vma and anon_vma like this, and again I just really question
> > the value of this.
> >
> anon_vma_chain_link() also didn't have lock assert.

I'm not sure what your point is?

Presumably you doing this patch is based on an assumption code needs
improvement, and then you question a suggestion based upon... an assumption
everything is currently perfect?

>
> > >
> > > +
> > >  +static inline void anon_vma_detach(struct vm_area_struct *vma)
> > >  +{
> > >  + vma->anon_vma->num_active_vmas--;
> > >  + vma->anon_vma = NULL;
> > >  +}
> > >  +
> > >  static void anon_vma_chain_link(struct vm_area_struct *vma,
> > >  struct anon_vma_chain *avc,
> > >  struct anon_vma *anon_vma)
> > >  @@ -198,10 +218,9 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> > >  anon_vma = find_mergeable_anon_vma(vma);
> > >  allocated = NULL;
> > >  if (!anon_vma) {
> > >  - anon_vma = anon_vma_alloc();
> > >  + anon_vma = anon_vma_alloc(NULL);
> > >
> > This 'arbitrary parameter which is NULL' is also pretty horrible.
> >
>
> I will add a wapper function.

No, just do not do this at all, thanks.

>
> > >
> > > if (unlikely(!anon_vma))
> > >  goto out_enomem_free_avc;
> > >  - anon_vma->num_children++; /* self-parent link for new root */
> > >  allocated = anon_vma;
> > >  }
> > >
> > >  @@ -209,9 +228,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> > >  /* page_table_lock to protect against threads */
> > >  spin_lock(&mm->page_table_lock);
> > >  if (likely(!vma->anon_vma)) {
> > >  - vma->anon_vma = anon_vma;
> > >  + anon_vma_attach(vma, anon_vma);
> > >  anon_vma_chain_link(vma, avc, anon_vma);
> > >  - anon_vma->num_active_vmas++;
> > >  allocated = NULL;
> > >  avc = NULL;
> > >  }
> > >  @@ -306,10 +324,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > >  if (!dst->anon_vma && src->anon_vma &&
> > >  anon_vma->num_children < 2 &&
> > >  anon_vma->num_active_vmas == 0)
> > >  - dst->anon_vma = anon_vma;
> > >  + anon_vma_attach(dst, anon_vma);
> > >  }
> > >  - if (dst->anon_vma)
> > >  - dst->anon_vma->num_active_vmas++;
> > >
> > You're now losing the cases where we didn't reuse an anon_vma but dst->anon_vma
> > != NULL? This is just broken isn't it?
> >
>
> Yes, it is.

...

> > >
> > > unlock_anon_vma_root(root);
> > >  return 0;
> > >
> > >  @@ -356,31 +372,22 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> > >  return 0;
> > >
> > >  /* Then add our own anon_vma. */
> > >  - anon_vma = anon_vma_alloc();
> > >  + anon_vma = anon_vma_alloc(pvma->anon_vma);
> > >  if (!anon_vma)
> > >  goto out_error;
> > >  - anon_vma->num_active_vmas++;
> > >  avc = anon_vma_chain_alloc(GFP_KERNEL);
> > >  if (!avc)
> > >  goto out_error_free_anon_vma;
> > >
> > >  - /*
> > >  - * The root anon_vma's rwsem is the lock actually used when we
> > >  - * lock any of the anon_vmas in this anon_vma tree.
> > >  - */
> > >
> > Please please PLEASE do not delete comments like this.
> >
>
> Okay.
> > >
> > > - anon_vma->root = pvma->anon_vma->root;
> > >  - anon_vma->parent = pvma->anon_vma;
> > >
> > Yeah this is just not worth it in my opinion. You're putting code specific to
> > forking in anon_vma_alloc(), which means you've made the code harder to
> > understand.
> >
>
> This won't make the code harder to understand，they are essentially the same.
> One has itself as its parent, while another has a real parent.

They're NOT essentially the same. We have specific logic relating to the
parent on fork, and specific logic relating to anon_vma preparation.

It feels like you've looked at it and seen seemingly duplicated code and wanted
to find a way to write a function to share the code, but then done so without
any understanding of what is going on here.

Arbitrarily trying to squeeze logic into one function is _not_ a win.

Please just drop this parent stuff altogether, thanks.

>
> > >
> > > /*
> > >  * With refcounts, an anon_vma can stay around longer than the
> > >  * process it belongs to. The root anon_vma needs to be pinned until
> > >  * this anon_vma is freed, because the lock lives in the root.
> > >  */
> > >  get_anon_vma(anon_vma->root);
> > >  - /* Mark this anon_vma as the one where our new (COWed) pages go. */
> > >
> > Again, please do not remove comments like this.
> >
>
> Okay.
> > >
> > > - vma->anon_vma = anon_vma;
> > >  + anon_vma_attach(vma, anon_vma);
> > >  anon_vma_lock_write(anon_vma);
> > >  anon_vma_chain_link(vma, avc, anon_vma);
> > >  - anon_vma->parent->num_children++;
> > >
> > So now we're updating things not under the lock?... this is extremely broken.
> >
>
> Yes, it's a mistake.
> > >
> > > anon_vma_unlock_write(anon_vma);
> > >
> > >  return 0;
> > >  @@ -419,15 +426,9 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> > >  list_del(&avc->same_vma);
> > >  anon_vma_chain_free(avc);
> > >  }
> > >  - if (vma->anon_vma) {
> > >  - vma->anon_vma->num_active_vmas--;
> > >  + if (vma->anon_vma)
> > >  + anon_vma_detach(vma);
> > >
> > >  - /*
> > >  - * vma would still be needed after unlink, and anon_vma will be prepared
> > >  - * when handle fault.
> > >  - */
> > >
> > You are removing key documentation of behaviour, please do not do that.
> >
>
> Okay.
> > >
> > > - vma->anon_vma = NULL;
> > >  - }
> > >  unlock_anon_vma_root(root);
> > >
> > >  /*
> > >  --
> > >  2.25.1
> > >
> > Overall this patch is really quite broken, but I don't think the general concept
> > _as implemented here_ really gives much value.
> >
> > I _like_ the idea of pairing adjustment of these kinds of anon_vma fields like
> > num_children, num_active_vmas etc. with operations, but I think there's probably
> > too many fiddly cases + a need for hellish lock stuff for there to be really
> > anything too viable here.
> >
>
> Sorry for the V1, I will send V2.

To reiterate -

I don't think there's any value in this patch at all and this code is _so_
sensitive that I'm not really hugely interested in seeing refactoring here
without very careful consideration.

I'm not convinced you're giving it that.

So I'd rather you didn't send a v2. But if you insist on doing that, send it as
an RFC please.

This patch _very clearly_ should have been an RFC as it is broken in multiple
fundamental ways.

Thanks, Lorenzo

