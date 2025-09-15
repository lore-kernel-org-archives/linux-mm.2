Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EF4CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525118E001D; Mon, 15 Sep 2025 12:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCBA8E0008; Mon, 15 Sep 2025 12:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4DB8E001D; Mon, 15 Sep 2025 12:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6068E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:51:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E54F911AB4C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:51:47 +0000 (UTC)
X-FDA: 83892076254.07.9F28162
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A4F0180002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:51:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZIwuC31F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K5IhS5mU;
	spf=pass (imf06.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757955104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRerFLzAJlBo5Jkvx9Pul39VD1OytjERMdwtTbBL7T0=;
	b=ZjER/ZBoTIP+dnH/YlXpiTquQf4zy+xDFh4W8edXJip5wLtkBW/V1pAr7S9tpRHYbRmu87
	ShAoUIt2mdeXeWzBjmyxFPcS2lujPpss7vqExIm8FV9/vLUvJ40QqCPgxCZO9SKAm4JYQC
	wWzyuswE88dP+ZHXDGmiDoB2HhKDRbY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZIwuC31F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K5IhS5mU;
	spf=pass (imf06.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757955104; a=rsa-sha256;
	cv=pass;
	b=Kegk2nUGYcohjCg8xcGhzLT+PUeTRKUWWtBA17A4WZLtyWcYhpOyMLQMr7mJukD3BE2Gku
	WQgWFEhOfLkUBoyV08+TCjmRKvtK75fZVWknhHfr6ujKKzcaBsrJadXeM0RIuiaa57NKAN
	fP0vArc+pxsFhgWXs34CG8Hw19eHdBU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FFSpCr010553;
	Mon, 15 Sep 2025 16:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RRerFLzAJlBo5Jkvx9Pul39VD1OytjERMdwtTbBL7T0=; b=
	ZIwuC31FmUgJi1IVnCXkYZn2lsFmrc8SgBYNudLFxjDDH359VnBNm5L+Tnwl0tQK
	ELafsuxuO29sPafHfK1FT4fsNsxfXAToKgY1g9Oy5KpANDqSYP+Sicpcz9qxx1Rm
	cdoqFWhpIp2z/Ycd8Kjm9Kyy3VmXkKG8kfY9BKoAoSvSAMfgY4SPvcVULNHd11BU
	zL7VzJSVTUf+0eMTV/BsiWp21V2vVMyOX+T7sC4dWd3hPOocGO2Z3Mh8mzHjUhPA
	N3Kduhud7+44FW7uEtN8Aj4kP3Ypg1O2vY20iIJ3P6GDo2wDqpJyZddrXq0aiRod
	5OgXiKNwRUe7EkV7CvNmGA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yd8juwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 16:51:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FGkOVR011168;
	Mon, 15 Sep 2025 16:51:37 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011032.outbound.protection.outlook.com [52.101.52.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b990d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 16:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yb1DuRQPHPgC4QzVtYmqtTH5FV3KDhEfhrxQaSRraO3oRT4Ite3Siw40irfHyJJkWNUwmzLDYqIvuUc8AR7sRIefmbLR1fm/TBZObzUEriOutUbteMl42cYiDdIHpxO5ugjESKvVT0w1YCBICGR5aoUjCKNQXeoAjG1hFqhG2y+k5AeLoTN6EyM1M8ndQzErXQG+fJezPXzJNpwdkg/P9Op9MaDibTZr8ZfC6evGWDYgSHIL82lHW1JgWm7UHQH8b8Rim8HG2zHWPX0DJKPmmNiRY+6b4FC7pwjd72E+tVzBIqXUWJiRzLvjIkV8lEkhGuiVzs3lXCc/UKpM3J3e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRerFLzAJlBo5Jkvx9Pul39VD1OytjERMdwtTbBL7T0=;
 b=Rr4E/GXA1/Jd1VDkn6t9V/9CTY88yQh9TybBFtGk3XzDXgkukfok0aE7PfSDvplcN0m4Ei7zFZQ50WBgyoJtajIadfb6LcmkiVaj+gK7GUb7iq7ctjfsOEDZhEvDok/kilwe8JJlDDCaZdh1S2iMp5AwxQuzZxeRU14y/gPw+aKDy4kLxtsAkbAgBVdVl1OSDv7Pb9xNTUKojG93wcqU/JogmUZNVSjkFa+PFYs9vOnk3SpIbYTjw5ofo2N5pQRmzyj8YRNJMyWCJcK3uhOUrUjScvTHrRDr+9IKjnoFihaxoo8oXQG5nfiTqikvFuHR8lkQzOJ7YHBApCwxikEsTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRerFLzAJlBo5Jkvx9Pul39VD1OytjERMdwtTbBL7T0=;
 b=K5IhS5mU4hGE3jHEsVkTYOY3TtwwR0qbtxdRwuxKG7JZG/I1kC/ZQcot9DHc+yA3FNBN9bAOvQdpZSO0vqW5WiE9qKjtF4kEzXi6rku8Ko0+f/JxD0SW+i6Jfx5K1nIVx3YllgQvtscwphX3pJrsLuAtKvfmhLE7shWVna9stck=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA3PR10MB8298.namprd10.prod.outlook.com (2603:10b6:208:570::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 16:51:35 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 16:51:35 +0000
Message-ID: <3bbfa5ff-cecb-45f8-b1ef-e380cba155a6@oracle.com>
Date: Mon, 15 Sep 2025 09:51:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: David Hildenbrand <david@redhat.com>, harry.yoo@oracle.com,
        osalvador@suse.de, liushixin2@huawei.com, muchun.song@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20250909184357.569259-1-jane.chu@oracle.com>
 <e9b34151-0879-4900-af9f-2ce0dbb678a6@redhat.com>
 <2fa7aa11-6521-40f3-9934-aba275154ca2@oracle.com>
 <eb6e18c0-533f-4e77-a56f-60ab8cacc369@redhat.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <eb6e18c0-533f-4e77-a56f-60ab8cacc369@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0380.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::25) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA3PR10MB8298:EE_
X-MS-Office365-Filtering-Correlation-Id: 6178f230-6fc9-4b05-a6f4-08ddf4782137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SDJJcHFoZjBaY0tNMlZHVWtWS3pFYjFpVU5wTVp0d0JwRkZ2eWxyWGwwdXN3?=
 =?utf-8?B?WndXVGpLZkhGQmRFTUtrcklkWVhBclcxQXA1NUdUclBqb1dvdUFLaExONjl4?=
 =?utf-8?B?dDl2QjRnUWs5Tk1weDMvdzYvZTlHdFJOQ3hlSnJBQjB1bDNpeWNGMnlUdzdM?=
 =?utf-8?B?ckZLVEo1cVNCTHA0bDNlemc4TzZvMkk2MW1sSFNLbWIwblA2VEtKaG9hZUFC?=
 =?utf-8?B?dG1CdnFPaEJiRytwc1VsTElab0YrbTBZRDJoSkhDSW5YZ1hHWHZNOEd2MUIy?=
 =?utf-8?B?MnNDdFV0L09aWDZ2R01NVWljc1JoNVVCQmJ4b1JBSnVjSkYrNm9LS0Fld09L?=
 =?utf-8?B?NEZKTWpGa1hsVDVzUjFoVmQ5ZFY1Y204VUQ5SVhIL0xrUmltVnpJd1VLNVRX?=
 =?utf-8?B?MXpYWU44S1h4bjF1cW5heUNsRnBIWkRQZEc3eUJCeFNoVnhlbXJlVENVMjJj?=
 =?utf-8?B?T0NQSHZrZERmMkZLVWNUQm9tdkpUY2twZ1I5bllJS1ZvZGpwa0dmTW9GTlAv?=
 =?utf-8?B?bVNoamkxUVMxZlRocFNVYTErLzdSSHJSVkFsdlhnWDNiUklIc05iSjBxK0JS?=
 =?utf-8?B?MG5wL3FzdTYzOUxTTU1lVkl3aW1UV3B5YXo2Q3drUTJzYWJRdnZoaDJvbHIy?=
 =?utf-8?B?RnY1R1lEKzltRkc2RlE1ZWlZcFNPLzVpNTg2OVZxbVMwekVlNE83TWhPSzVR?=
 =?utf-8?B?WnRoV2Nud1J2Uk1kYlgxVjBqQit4MFZhUWx5NnBLbzNnU2lubGJEMGFGN3ND?=
 =?utf-8?B?RjNyUUNtM3YvZ3d2WFdLTGZveXNKaitabERDZXJ6S1NaZ1QvdndNd3RzUWNk?=
 =?utf-8?B?V3ViaWNHTnFxUUI3THhBbzlnQkJNRzFGRFhYOXA5QzhuUHM4VHorMzhrN3JD?=
 =?utf-8?B?ZkRrTDJUVVNsYUZla0hHL3VFV3RIZitXOU5DQUJTLzBLWS9uRXlIN0ZiUHRH?=
 =?utf-8?B?S3o1TFdoM2dMamxzTTB1MEt2ckRESWRUM01SbTBuOGZvSXREWDFhQ1JRYm04?=
 =?utf-8?B?S1prRXRvMjNhZ1NKL2tzbGQvYkQrK0x6UXhoVTVTOHFxUlZKbmsxTXR3WFNG?=
 =?utf-8?B?UFZxK0pNb1RpVUtXRC9RMkk1V2pyTFV6WElLdmlsc3pYZ25xNEdnQTR2YUUw?=
 =?utf-8?B?TGZic0Z4TjhVQ0tCMXhSdDVuNU9ZOXE2MU81cGJyNHhLQTlyOFk5aldoWjUw?=
 =?utf-8?B?cUhMRHNkUkRZU1Y2TmFkL3lqL3NaRnIxM0hQM1BmdWg3ZmcvWlR4N2VBU3Mr?=
 =?utf-8?B?ZWFnb3NRQ2MvZjRBWVo0cFBhakNLR3BMOHZvZ3JsbnZKUzFkOWhvQks4NSs2?=
 =?utf-8?B?OFpEMjF6MjJBZ0R3STdJQ2JpUmt1OVpxYTNzLzhHMnNXZFFuVFd5SElpMTRH?=
 =?utf-8?B?ektiTThnK2VGWk9OMVlzTG9CaUIvNTU2aG1LZGpEM1ZMR2VsZUxuRnZlMC9n?=
 =?utf-8?B?Q09JRjBsdjNSdmJuVHA1ZGp2S2c4VktJSmx5MkQ2cVM0M1lXdS9jM2lwZUl5?=
 =?utf-8?B?bVU3NG9sdytDSVpCN2NlTzBjdnM1WG9hbzFqaXFxYmxGNE9ycndUZWpWRGlT?=
 =?utf-8?B?TEVWSTM2Zk90OVc1aFVNSDVEY0w1TUlCYUVMU3RpUGY2MmNKVzdPRXJlaE5B?=
 =?utf-8?B?elVTR2pMelgxUDNMNmo4MGZzc0tUZVMwQm01QzhtVTl5VFBRVkZRTXU1aFV4?=
 =?utf-8?B?cDB5MlBRQy9mS0F4YW9aL0JEUkNaYjdpNXEwZnpYeXlsNWJ0WFBBcy9wckpi?=
 =?utf-8?B?bDNjVjJVc0dCRThnUEg2RXVxSGZsZU94aTd3NTBZdUZMMWI0TzZpdXA3RmFF?=
 =?utf-8?B?d1VpVEZ0NTlQSGYzU0FrcmtDSTF1elM3OEhGWGt4UjdoZmh3R0ZEUldRclZo?=
 =?utf-8?B?K2FWY3Vxelhodmx3TzVvTTg4QjF1UVFpRldUZmNwcXNkZGlFemsvc25Jakpr?=
 =?utf-8?Q?5E9eBIW8nAw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXFXZjZlRE1reC81czVGV3NXWXoxTmxUeVRqdnNYd2o4UnVNRDE5YkREMDFi?=
 =?utf-8?B?VXFOSUVhRG5mYkR2SW9xdEpFaHVGYU04UWNxejI5L1VvR3pKTGZMM0xNVCs5?=
 =?utf-8?B?a1ZSa2VONXNjUUx5VWt4ZDA0WnZVRitpOVdLOFBIRVQ2WkZDNTZUdk9yQVVh?=
 =?utf-8?B?eTB3R1oxREhmZ2l4cDlnTjFkVmFoYXRkN3lJN1NNb0FwcnB6MXp6RTZGb2RH?=
 =?utf-8?B?UTVpWjk2MGxQaFBRd0lsbWNRWTF1LzBlT1Nta2R0ZW9YZm12WEprekFGdEpW?=
 =?utf-8?B?bjZwTEpBdFNKKzdTclhrbnk1cFV4YjU0NUg0clQ5c3p2SFhWT3ZJWk40c0Rk?=
 =?utf-8?B?R2dmL21NZ1JxRE9QNEFMaFZUdkEwSzQyaVJWUlB0N2haMFJ4dGR3RXlUc2FY?=
 =?utf-8?B?aENEYVE5cEhma2E3UFB5UE0wVWkzQTB2TDZ1WjlaT282eEpNRWZlS2dMQ1lH?=
 =?utf-8?B?Q0gxV3JyeVk1SDNNY09OM0ltRkVCK1NDUFZldjhxZk5LcU1QTUF1aVI3dDB3?=
 =?utf-8?B?Q0R4eHZIa3FLT0xrM3JIYTA2emlJK3RTb3p0b0huSGFtZnk0d1dXbEhXenQ4?=
 =?utf-8?B?MEd0eWkxdzh0N28rVlg4d3doSURkSjh1Y1JHMG02VmU1SUswOHNVeFJ5Tm9E?=
 =?utf-8?B?OXZqMTQ4SFJBNVBmSHl5b3RidlI4K0x5STNOVURkMENRRzBuM2g4Z1hlL0hZ?=
 =?utf-8?B?Z0tPSlorbVN5Z1hPdEtOZjdBWFhqWFRtU2I0YStxelFtSzI0OFRjQmNLeW4y?=
 =?utf-8?B?WGh2cUl5Y0NQakZNQVdYMDdzbVlNS01rUDBzUmh1ZnkyN2swNlNnbThka3ls?=
 =?utf-8?B?SnIzKzIrQW85bEVob3JjYmpkUnhKOTlUdjcyT1ZScWNRak5OY3IwWU1MdENP?=
 =?utf-8?B?NzZSY2lPV0htc2o1QVZKZXBwM0Ntd2hVYVNOa3JYaUlCaVQrZWE4Z0tLSHZm?=
 =?utf-8?B?UDZGZGpSYkhhRG9JWEJIaG5kUVdBUnd4UDhqYTU2NUk2N3VYbDluZ2RmbmRI?=
 =?utf-8?B?WU1WWWZ5WXdMVkYzRitDWHRTMjNNRDcxVzc2azlZcWU3S1Jra3RQQ0JVb2kr?=
 =?utf-8?B?WjNNWG9iMS94RjVmQ0FmaUpJUmRCampyQVQxcHlPYkpNYkJPbTdXb3pxdmZx?=
 =?utf-8?B?YVBMaTlGTFlMYkRpZzMyc2k5VG14S0NpWmRGRWdTZzFwWkJMNEQzd3lhclFI?=
 =?utf-8?B?ZG5UVzV0YTRHbGhlRzZ6VTI3L3IwT3hpcktYbCttWnlXVk1jRGR2MkhINU5D?=
 =?utf-8?B?YkdmSE5NRDZ1MjdTNGprak1JUDg5WUJnWmk4bmU1b2hvcXRGeWladThHUGVk?=
 =?utf-8?B?dnNrbWZpS3EvdDhOT0x1NDhpSUlWSVFOZG9TU0xJUllyZG9lMU5IRVg3djhs?=
 =?utf-8?B?aWJ4c3pRbmM2Z2Q3QUhRUERNYUE2UFR3T2xvV3JRYVJocEZZRnN5cjVzY3pQ?=
 =?utf-8?B?NGlST2xxZHZ4RVRYWDV6QUhvb3lEa3BxQ1JzRTluZ01XVjhNcmQrUHh3cjR2?=
 =?utf-8?B?MnRJNG54MnhFeC9NaEt0NXFDb1JhUVlkcmo2OTJuZzRGN05ibVBqZWI2QVVp?=
 =?utf-8?B?TFRickFxazQwc1p4emQ1ZWMydFZYekhvVHUvSUgvb1d0VVhoeURaSEgyYWtZ?=
 =?utf-8?B?amFqaWZsMXVDVkwrOWxrM2doQnRJSXBOaVhiVDZ3QmVUT1NDd3gyR0hrdXlX?=
 =?utf-8?B?Yzh6ZjQ4aVNoN2grUzdPZUl3WUxZRDQ2US9ydENoc2g5MzZMNExLaEJvN2FJ?=
 =?utf-8?B?VUovRHY2RmhMazhMQldQb1lORXlZVVUzaDdDSjFhM2YwWHZHbGhwYzgwRFls?=
 =?utf-8?B?TXFNclUyNHN4dmhXWWNya0EwRFpjdUJZYmtLZkFFYVlaL0hYcnVMVmxhZWVC?=
 =?utf-8?B?MTlVODc2NWRNWHA0V0U2b0p2OXloM3lUTDNKZU9DMUkyQzNKZjlqL3dhbTh6?=
 =?utf-8?B?RDFtc0N5eGVmTUQzRTQ0VFJ2Zk9pazUzWHlvL2ZWaFR1RXd2clhxY2hvNW0x?=
 =?utf-8?B?QzNZK1dLZzFuR0lmYy9zYlNWZDhHMUxrcFUvZnlidVdySDVJRk5KU2xhT0Iw?=
 =?utf-8?B?eHFuTkpxT21Vbm9CejVLdGxQQVllOHhDY21DNGhxellnQmhwaU14TFZxMnFB?=
 =?utf-8?Q?q8H/6lg4EOR0R/fRcNwHdGppq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C/9xj6ns+EXQRaIMAgdR/80xSMOCj4q6IX/oOGvA4ySyWDFOAgOpUPMoltF2/QsruNwg65BVAYiMATpxwo21pDmPFs6HtJACKDldx0HbIIhdLSlXWGUmYxMP78ZFPJwOUzTAPGdXKTA0WaBcn0/US3sphc7ZTFw8YkmcryblgSJZ7m3u2MQMlZFyz09ffk5tB8kSYCt0m+XSeGHIq7wQ0eIiGboKXJFjaBm2qxRpCnsUGl5yu3pk1JvMutmnWfl5P3X/3X3Kf7M1WjFnwRsn+bBq6cRt0XN9w6/eVpMQ42HYhlw7j0Bkqubem+9wfhUNj9V57lOC5VV2kdd+WGPoDtvJpGNPtz16yjbMwvjr8vr2wC7H9Njy7pCyWDXFrfSnoaDJEEXcHFjD/BID4zL2yJS6Rpnx45VFsWf1qix4xzyaEU4oT/QYD2bMEouug+Oh7bdkcCiPB3xg4UGxtKYSIZNEe9g1KHZAzPjJtOKG7FMubJn0tmx/3Xj6VjTe5lhg3ak/iS1npatV3f8QalrYAOAb66HJ0At4iv1s+QaBIVRYHQViLtAMBM6z4bGNaPySkqlj4R33bWxSXkU5QzeY29ouxaMqgny0uKlTEFtZd84=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6178f230-6fc9-4b05-a6f4-08ddf4782137
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 16:51:35.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFU5DExzrMQ+5r6FSwZdzYoBk1ASyzcvO2YY7duxSr/9fP5eeR2JYTGd8aJfsWUl+yVoHFO8X2v/JTvHTnwgcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150160
X-Proofpoint-GUID: OdGyuwyQ30oR_BpsKHZs1jCbeH5KyaeG
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68c8441a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=nNqLvfDb1xnlnp1goGMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: OdGyuwyQ30oR_BpsKHZs1jCbeH5KyaeG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxNiBTYWx0ZWRfX3cf77pJAmiTM
 1nERXyIHKsKyseiG5nXvHAywZVNFeofC17jU4ArTi5lWwdufO2ZZonDvdmH1u1Ca0dqAjw6e6to
 bNy5Rd5D1BVnm0DIFd50rON+NkwoxWSoaPmirZ4cApbFEdoS8T6aygh+iDfFzWKoc956MLR856s
 so/bqdr2xXJHzEr5kxU3BvJ9S1WxfnKoq9fDxCySKFHKZQoklI29mEJFR8iQ4ezFNCRuo5PfGyE
 icTh+n9ahVfhQi8s7x9jBqlZvrn45L4D/KnB+flSbd4DJgvEh0r6nwEAg0BRdR3yWKUmm3OLo3n
 iIhIc9N6f6PJQW+QCbGwhhvyWpfSrQ2LAsAUcLp3O0X6T5VWLgvQksn/jED8lU3Vc7yXr75Fjgp
 8UqkjMZL
X-Rspamd-Queue-Id: 7A4F0180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 661h971khpu7d9y6ucoct8hah51ype55
X-HE-Tag: 1757955104-953712
X-HE-Meta: U2FsdGVkX1+N4UNpipvUa6NQnmk1cp2r3t4wypAPrhahFCoW2Bwrd5nMj9v0XTVSNpjqrWJi/eqwFSrmf13fMDiTqKb9q/DbS/B93MTppJtaUdU0TEPlEbKA8NLfJ2yLufv/UliH0/GP+w/EMbLY1n0dh8lCnznzKsB8RsCqaPwNE/R+0YBIxS4SUKg4x8DpwAX9go14EX60H6F+cKOUE7lxKb/sM+8HiF0YmKqMShAg3qd574I9H/EpqooZNBTh1jChrAAgIGNWRqUn1wUlpDllw0IM46hlDLbpsYEDTINgjpaujUk8Gsjxflcl/pcnmyVqzpa6ZlI7+xDbptoaljN7rBz1sbc04OUdWuXQTzNioLxP0ecP8TwJe6TrWbkOAR8rlTmootcuMsHE8LiKpGbwbeehYfcQTj2kpTLFbbtLzDHQ1ox0iZu4w3vlwXzFaCBBzLlUeFuctaa1gJSt9sW8bSJIHQGYJfZHj15YN0cjdS+CdK18owu+Te8GSzSctsIDmWaDMrcihcVv1pwiLr6WpO0inEyxsc4O3Vnqkg8Al+I2nKtjIj9MEJ/OJBtXpXHjtdIUMq+otJibMZ2Wb18ypFN7d/tw5I7fO4541GM7lRJTcIWwGstVDtfflEqq2yFAoR0qzShKzPt3Alh3RzI4eiXIXk4jL7dnAIw31r46lvJL96Ruxq5cv04SXKttEUFj9TqNM6iqn4Qjf/hPM1uTgDtcyGpAALdbmwwCIh82TzDpYzDU4YomoQmuAhxh5Ljmm2Bvg6bfToD4Dg4hfEYuzll9I4ahrPFSd7gMg3awe9bTHW1yx56GtzlKy+XwlItYsXRY7OhkyfDMUOJD1P3YubixC6VrA8Mlc+fAfe8ZyZBZkCgm3P7+2iOkwYBYtZVUpHNDsI+oJ/PxR2eQ6sh3PeUYhGy9RFAOVidEb8iW67XH8Pn8jLw+Yuftc1a8JS8KNPs+jH3oVpqdcJA
 7CBLw7QW
 n3xf/IOmJJMySloeU5Iqv6zXbR4Vu2tEuJahAOdQc7OW840swgKgfkoLA7RqF+dLI8fEZzEEQ3zCXg07rljgq47fd6veDvWBZFHI2guKL294towzhHp+lfTKd4MrgNJ2Be+/IgLieLp2K+x98aVf84qfhEIdg3GPoHGYUMtMXx0HAxVCQibh0nt2496srbBSNsX8XEiwlcRuu9Kuy2VdKkGriTBkvJPTx+V5equOChCLmhM5CtxnZnzP43YJAakHvG5ynvQNw/0rWb6GE0ZNyScrK+Yxdch+m90qpIgbWUAeiSyDV4xFLNggY4GsyS3fa4oUcz6GvqK/+WePyRK+aS/ZER3229DLd9RtnDaHlzn9A9cJiB0RItjp5RnWPpbGU2YSbohsI1iliAGeD6KqFV2/ZRXvSrnXQ/f+NcrVvWJy41jo7ZrurkEuC9tPgTlqWlsXRxN4R/qR5KkbTcgWG5Z+zw/IFehGclW1ZgN7U7Ma5qVhj0/n9zFWSs9kruhBEhssvH+CIhhuU+jrhNYehqibpf+4jJccdRbNsI+60fqYJa4ImMgCTwQHpSz35lF5ShAId8FpR/uNzawUlWHfmRjKxOW/HMCHMAqzuRoOrFNla7IVVMxmkkyH9kbgCFyZ+DdIYllKcNqnff6IAB9TSPFzSFVMkoabgRPHnqh6C1lgmvD+nxVHEAifxlbD5/vQebP74eyDja1EnTOi7r+asE8t+8EAoiijDYbBi3UBLe5vfr/CRHYpfigKBaR8G/F92bUnrKQQ3nQVYQFOf08U6a5Z+xMARf8XXx03CXwjo8GZZ1wmRdMuqpXBWLYRF4hHzNQb3zWV+zOfXATyvgIAKbtfvKoFUN7kNVrdI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/12/2025 12:31 AM, David Hildenbrand wrote:
> On 11.09.25 21:54, jane.chu@oracle.com wrote:
>>
>> On 9/9/2025 11:45 PM, David Hildenbrand wrote:
>> [..]
>>>> -        /*
>>>> -         * If the pagetables are shared don't copy or take references.
>>>> -         *
>>>> -         * dst_pte == src_pte is the common case of src/dest sharing.
>>>> -         * However, src could have 'unshared' and dst shares with
>>>> -         * another vma. So page_count of ptep page is checked instead
>>>> -         * to reliably determine whether pte is shared.
>>>> -         */
>>>> -        if (page_count(virt_to_page(dst_pte)) > 1) {
>>>> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>>>> +        /* If the pagetables are shared don't copy or take
>>>> references. */
>>>
>>> Why remove so much of the original comment?
>>
>> Because, this part of checking has already advanced from the "dst_pte ==
>> src_pte" to "page_count() > 1" to ->pt_share_count > 0, it seems cleaner
>> to just keep an one liner comment.
>> That said, if you feel the comments should be kept, I'd be happy to
>> restore them with a bit revision.
> 
> Well, the comment explains why checking the pte pointers is insufficient 
> and why there is a corner case where the pointers differ but we still 
> want to unshare. :)
> 
> But yeah, I agree that reading the code it's clear: if dst is already 
> shared, just don't do anything.
> 
> I would probably rephrase the comment to something simpler like
> 
> "/* If the pagetables are shared, there is nothing to do. */
> 
> If you resend, please add a comment to the patch description like "While 
> at it, simplify the comment, the details are not actually relevant 
> anymore".
> 

Will do, thanks!

-jane


