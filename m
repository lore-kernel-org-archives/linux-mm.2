Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC5F3CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70B08E0009; Thu,  4 Sep 2025 14:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49EA8E0003; Thu,  4 Sep 2025 14:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FA98E0009; Thu,  4 Sep 2025 14:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9DB18E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:41:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5396458A91
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:41:26 +0000 (UTC)
X-FDA: 83852435772.05.EB2C617
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id BFEE918000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:41:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n4cQb9qt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=snFUEPuX;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757011282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL/jEMSiWbm87V3aSGTypFQiyld6PSlaxT+Ls4TN1gg=;
	b=a9ibGfaRRYWmhuzm3HQd7k4MK+iiK+0yCRSqivJrbGz1XmM9kVEqNKxEjtdhnUBwtxLSU+
	4e0h5aYR+P+FicU4W7nErGl1u3kF1F22JMaAn5AIIJ7L2aiKD2F1ImCxk6rNJKDlLvn94d
	rnnKublgfE9GaFFQxo1zvOtuQPXraos=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n4cQb9qt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=snFUEPuX;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757011282; a=rsa-sha256;
	cv=pass;
	b=2X4lviZG599vEslVx+SdXrR0UD5nv5k8cJa9n0UVZtOyI7EDA96LgnMKdZmnR3VNmzVvZw
	JPTGNZpRWhZ6mAHhkwtXRsQ1AuAcCxu1S7ihW9akz7xeqtS77FFAPrB0OEACJnhJIkqCuI
	WZNP4+VpxpFKoT3CvbyKdYWVOfg61dw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584IOhno021398;
	Thu, 4 Sep 2025 18:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sL/jEMSiWbm87V3aSGTypFQiyld6PSlaxT+Ls4TN1gg=; b=
	n4cQb9qt0ZkL0VyQTqxztgn1jK1gzzUYn5OdcZpdfe3Om3fhrBFq0TVJgIDz8Fsl
	RBch0LsgfJ3oekkT2XOke8Oam8LsgrVQW3NTrfiIeJ/8mzcASxfH5UZdA/g7lkTh
	4Q5+t9x/kK3l2XyURj/V+f44+HQMik1jYB2mS1OG5WIwdmOyKMcYtZegREXBt9/b
	GYdkH9fS5dDJQ1g9AX3yJSG0tpMVJdL8WgxCZ6rayg7BBWPBRUeqS6vAo4CcileB
	EEnYuYI4jp/KwUM5bJVuUwdD+nsWsMW29OAV5X9/dZD59IV/I8iV2KX00cvYcFAt
	y/3iHPqhpS+lfK651MW6LQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yg13817b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 18:41:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584IO5Lg036105;
	Thu, 4 Sep 2025 18:41:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbvp38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 18:41:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KCJd581oV+Az6RYw18y4v7bgcP/8hrm4UW3pMYsRAu3PhdvEZJdAHrQ6DSYmAw96LyocbdidknMvB03jDlRWTK74L5ZGoTLaL8W6DH+ldt7lD9nX34KiixEiLiqOuNzqkiZP4JKsMr+FZ25DnesbT+A6h+pMGPu9BDOIm8FkomYJtW2CZcHy4XX1PYvpHOxLgZF9zRhkZnfE6igpTZEOI6VoHbVmDMszENt6FXgMJOnkbncqjjdt/uVfGnMhAivEc29QT/WQLpUVAtWELz9rT7yJqzAIU5oDSOFLPaT3IbDCsw+tAam1tDNI3S73qTHj1XVfWMDiE456+PXszZeCeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sL/jEMSiWbm87V3aSGTypFQiyld6PSlaxT+Ls4TN1gg=;
 b=UBhNoipCdagc0O8S4/W8dLPeaomW4r8bPHqijB7RH/MRTxSYIZ69JG16oLYAZBHRbRsjbJ0ituwlPN1TiVBFJqFqnpZasXmV6qE2wMv6BCiqboykyZ4u8u5eTRK0Fh9z2AwYzcTsPh/SjucjAem9fK1464T5Za8h5e21C9TrQKdA8KgG9EMEJwVmsvAZ8XNcfD3CfpL/H/WjFmTNK4Etd8YevtfUgIdJ90mIXkOPi/GCsYudesdYWEBtQeP2Exih9OpEej9GPyGMB8URRo0OaTd8cY2F6sIp5j4wb5/A4kscoueWvJV/fulbT1Z9w/lHIMmdMMghMScHcYuhbaD+5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sL/jEMSiWbm87V3aSGTypFQiyld6PSlaxT+Ls4TN1gg=;
 b=snFUEPuXaNbjtTRtLfOdSS1YpjxNf+Pa9jwFKaDlKtlz7pt9zUa//NxrnMheNWB7raRTMS0y2T5TRqh7Mz/6REqc8G/jVnAD6BsV0Kxy/lBtqIIqvolIVRK5jEoxBSMP9Sxyf8xrm8trJ3OeHJJ/EcO69jBiedJkMBqAqCKAxmU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7594.namprd10.prod.outlook.com (2603:10b6:806:38b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 18:41:13 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 18:41:13 +0000
Date: Thu, 4 Sep 2025 14:41:09 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
        minchan@kernel.org, kernel-team@android.com, android-mm@google.com,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <5n37yzto6ylq2a5lnxwcr7osygwkvlbv35fkilkhfc5eqhdqca@iji543qzcy2t>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	akpm@linux-foundation.org, minchan@kernel.org, kernel-team@android.com, 
	android-mm@google.com, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
 <CAC_TJvcCW003ef3=RCXTbC7daSS2+tiS24-7JdTLn3QVJX3Bgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAC_TJvcCW003ef3=RCXTbC7daSS2+tiS24-7JdTLn3QVJX3Bgg@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW2PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:907:1::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 26be353e-ecb0-454d-2147-08ddebe29faf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjFCdXRxaHlPY2JMQjVVRVBLbVJITStTVHB3aHZSaWhXTzd4dUtrbm15eUpR?=
 =?utf-8?B?ODJtZXY3Y2ZxdjJRTTNmVlVLU3paR3oyelc4aHl5SUlESGw5QkVSak5QMlhY?=
 =?utf-8?B?OG5nRVdTSE1vZVlUTUxveTRUZHZyNjlLWjFQVnVSSVZvL0ZTYkp6QkxLRS9Q?=
 =?utf-8?B?SytLbWdYdFJ3TlhrTi9EZC8rc2ZSQ2cyUndvMFNWcUVxMFMvMG1udVN1MXd4?=
 =?utf-8?B?aE1GMGhDUmtXNkVKeFVhNUFobDVhb0RreVZkbHVOOWNEY3hKeG5pWFZCZmpT?=
 =?utf-8?B?SWoxLzRTMG5rOENTOFpXYVl1ZE5QTU91QVRPT055TWNOczk0K2JFdnZ3Q0xy?=
 =?utf-8?B?MHBWaEM2a2lVc0dzeUNEMkkwVnVXZjFOYjdmU3A0a0F6WXY0SHhMeFFRamJj?=
 =?utf-8?B?WVNtMmc1Uk5qMjNSSFFHclBzTnpIeUFMTkFkT0h2ZUIxZElPYS9oMFNMZ1hl?=
 =?utf-8?B?bjdwQWZPZ0VGWDNrOFNEVy8rcnRSNXBQcmJFMk1lVThtNlZMNUdaYzJUSHhU?=
 =?utf-8?B?OGp0R2xLNVZjcEl3UEM0MFZ3RTFqeDMwUE42aDhiWkZ4YjBKUXFTYjdjS0pI?=
 =?utf-8?B?a1BCN3hlcGt6T1ZQMkM2a3VMWURkMTRwcE5xd1ZIa3Bpak5wcWFSbG5jZ1Yz?=
 =?utf-8?B?aU9OYTczbENUZ1hqdU1UMEl4NlRxZm5Ec3kwRHhTUzkvcU51UlYxbk80OTNu?=
 =?utf-8?B?RWlsZzh0OC96ZGNQc1E0b3BVQmNTbmkvV1lzdHJ1YWJQZFEyaWplRjErWExZ?=
 =?utf-8?B?S29IeXYzQ2l6YUlEWE1aL0puUlBwOFROUllnY1FvVGxPY3I0Y1MwMUZvT3dK?=
 =?utf-8?B?eFZLVjJHeVR3c0NrRnJZSzZCMSsrSUNFcERUMmNRdWhVTlN5d1ViQ0tBam10?=
 =?utf-8?B?enBzbG9kZEpPV3EzaVM2QU8zRW5uWGFBeEVGdWhaTy9SNHBZWDFhc2s2QUJh?=
 =?utf-8?B?alhYNTZGaWtXNHRPQ0xrdUpWZmpPVmRnaXBralJzL2ZaZ0RhZnMzU0NTMDlO?=
 =?utf-8?B?YTFZZCtmNVpwa2ZqdlFqeUNyejZ3ODEvaFFpL0duUFZGRXJJSlIzZllBVUIr?=
 =?utf-8?B?eTh0TlZneTdXdHFFSCthNDlzNWJBNFRRUEpjVHFERFNacWJzbGVTNGlJaEZM?=
 =?utf-8?B?N2IweEdGc3dvTmJQWnJ6TEtOOE1RMURkSnBTbU03TndOaExTcFhMUk9VNTdE?=
 =?utf-8?B?by9yVWw0eWhKSVJnVmo5TTZjRUduc0dZTjRkN29JUTBnTWlDMGlQQ0Irbmwx?=
 =?utf-8?B?a09zK2paU2ZYQlBkMk9qcWIxM1lFQ3dWeVhXYzdPZDBXYTUzd1NFeTJ6SnFH?=
 =?utf-8?B?dk1XUWhGR1JOeDI5Zk5IeUxFK1FVYlBMV1ZVTU1zcXlMSFMycEZqeURwQUFK?=
 =?utf-8?B?TVBxREROc3p2Wk5EQm5MOWpnT3JxZ1pUNXVWVUNHR2dtTlNOU25iUTNOT0Jh?=
 =?utf-8?B?UTZKYVR1VHdqVC9ZbFdoaWJRcnQ3ZUFvSzZITGNsdXBLQjlLVWFVRUNRbDZZ?=
 =?utf-8?B?ZXd3SFBJMUxVSFA3N3JiTkZnYklNNTdqczR0MjVDV1MySldPc3NhRkI1NmhY?=
 =?utf-8?B?RXo5RnNyQTlTbzl5bzFEUEIvRU9QWENIYmFIdVBaeWZiVmdSUG1COVpMU0Yv?=
 =?utf-8?B?WkhGQWNDWlRLa1JPak1mZnpheWEzRjF5ZU1jVXVPZVlJWnI1Y3JjNEgwMktS?=
 =?utf-8?B?Q2lMeGtSZWtOL1dTaU5OMVRYUll2SXROK3VGYTFLSjBhdzRUcWRtOGxSbTdH?=
 =?utf-8?B?UmlBTE83N2MyRDRLczl1ZSsyVGYwemlNSHNvUkNmMWZkMVpleU1KSEp3b1BB?=
 =?utf-8?B?LzZYUk1aNUJMckNpTmhRTGMrTllPVEFLL2dRMFMrQTQxaDA0b3Bya3hqNllh?=
 =?utf-8?B?YjU4K29VaXE3Q0xVVCtIcEFZZHgyaUNOaFhoL1M2MmU0M3pBOEhmcjRkWUgz?=
 =?utf-8?Q?jlO2caruSxk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3RTZEJUMWZyNWJHNWQ2L2VyLzFWdWpPMXFyU29zMHRtaHZybkhGaE1nUHdv?=
 =?utf-8?B?NllFUHEvNXFPNzhScnA2K29Zc1JaM3pCSnB2YTZsbWNSRWJsbi9KM0xYQjg2?=
 =?utf-8?B?ZHVxUVhwZjFpa0syV0kzZ2lEK09IUXVkUitCOUJUVlJIZFlGdjJQdEExWGNE?=
 =?utf-8?B?cjlPQzEzT1FDZDZVUU1FK0dUbVdsSEdNOGNMUWV3N2FVSWxwYlBaWDc4Q1ZZ?=
 =?utf-8?B?bVRybEh2MWFxUG5mOFJoRFg3a2UrZ2tIUUVxRCszR3hzMXIzWUVNTk12V3Js?=
 =?utf-8?B?QktLMUo4dXNVdEtCVkVKYjFuUkdWRVdicGxjQ3hONjlpNnVCZlN3LzBhbnVq?=
 =?utf-8?B?MHh1U2wrbkU2akd6VWFMdnVkbUhMUmZOam43a0lpRjN0YmRvR0pHUm9LTVg5?=
 =?utf-8?B?K3FiMDNTQmJ2djl1VGJJc1lleURGbDNDVFNmV1BMcnAxWVJqUExObXdHOGZ1?=
 =?utf-8?B?c2RQV0haYWJJUkJ3VUJKTXBWeUxFb2Z4MktIU2lhSjNVcEVzdXRsdXlhTFAx?=
 =?utf-8?B?N3VYamx0K2FuZUdSNHNQYkowMG9DYjRhTjZHVjVOSXRDc0E4a2pLN1pVcVQy?=
 =?utf-8?B?TmJHSE9RWWJhdVRSRWhQMjhIek0xTU1oMGh2aEtCOUc2T3gyam1tc09MUUVi?=
 =?utf-8?B?Qmk2cC8vMlBzTlIvanNKUyt6RU5wbm5id3ZRSE1MdHllMW9LSzNoVm9qUlJS?=
 =?utf-8?B?M2dBV0lOWGRHRzZhMDBRRVFnRHJxWnZIVFNJTEVIbDg3SXR0T1BPV1ZzbVJq?=
 =?utf-8?B?RWxWZWFjV25HWkVJSlJscXAvajFYNjZLT3puYmY5WEs5dlQ3Umd1T0ZtUDNz?=
 =?utf-8?B?ZjN5ZnBEbFloa1hHMmFDWVpNZ3hyOUdnNFAxeHN0ZTBDeXJPSzFRLzYzWDFv?=
 =?utf-8?B?SGFGL1VrbVp3dG1hRkhRMUt4OW80WW1TMkdGcU1ocDJxczBNbXpNaVBwaVBE?=
 =?utf-8?B?NEZsbWk0dm1oRi9FRXVzMUxjb2krZlFZWDBuZWNUd1I5aVFoT05GNW9iM2Iv?=
 =?utf-8?B?Z2hWYUpXQSt5NHRSWXFCQ3B2SW9PVHNWUWVyc0RHdU5VRi9SekRsY0xsZG5r?=
 =?utf-8?B?ZTR0UGozcnMwWFIweisyMGVoc0E3ZFVzdUNnMUtKajF3T0FuTjFTNUtJUUJv?=
 =?utf-8?B?TTIwYU9QSk1IVDJJVVpvOHk2UjVNV2E5MDNIdElHTHBka1dIaGc0MFgweDBm?=
 =?utf-8?B?MkpPcnRTSnprNTdQRFFHY2ZOWnprM2RnNmlBZzJzdXhwUWVZdmtLUWRsOXFy?=
 =?utf-8?B?eFF2eHhNTWRSTFRVdlRzTEtkQU9VQmxiMUJ6QlBQUjNCK0hSVXRlUC91SUpz?=
 =?utf-8?B?R0FreDNuNitZcVJpZit2KzdQRlZaV3VmamljcGtFbFlpNzN2RFE1RnVqRmxI?=
 =?utf-8?B?b1laT2F0eUdOdnhIVWwxdUFuT2Yxc1RNeE1uc2tyeEhiVTg1UlhWSjVQMkli?=
 =?utf-8?B?Q2VXMVZqTE1BdDZmallUV0VleDlQdUJ2RE55dDZ4S21lNnN0ZkFPMjJYdHdy?=
 =?utf-8?B?ZGhLTFpHRHMzT1dQMlFMM2x5QSt2UGFXcVVGZk9QZ05YYUZuUEVuRHJOOTBG?=
 =?utf-8?B?MmJKVS9LczdicHVuM25JYW5RdGRhRE56T0pMdzFEWmwxWnJjUzFXMUdCU09K?=
 =?utf-8?B?VldseG12aUxlY3o0N1JLb2Y4ajVwMHU4N2tmeE9KZFJOOTZaWXhQMnFSMkdp?=
 =?utf-8?B?YTRxTmFodXljUmt5UWhER3AwL25RRDVkeEo4cVpvTEg3d01Jc3ljWlVPK0pn?=
 =?utf-8?B?SGNBdHo3U3VJRWFTNGlKK1VrYTNUOFM1bVFmbndTZGoxZkFReG1QUVZja0Jo?=
 =?utf-8?B?aHIySTZVT2ZrcWhSdkdEMEJhSUNlSTF4R3ErSU5WTzY4T2liT3U4V3RkaHox?=
 =?utf-8?B?K3l2cEN5Nzl5Qm1Ubm52azVablRONW1oVnhhRjFMeUxwaDRqeGFzYXBRSzRX?=
 =?utf-8?B?YW1GY1ZjS2Q2ZlRvQWNPZGxLS2czNFBYVUZ2ckFGelpveG5pVlVQYUF3cG9N?=
 =?utf-8?B?N1ZNRUpLeEhwWmtlMkVYTGVnNzBISTZzTGtBNzdHUlZsMGhOc2FTT0Z1a0FT?=
 =?utf-8?B?VVpYZzZJSEJJMFFmS2VSOGhzNEZQd3JiWW4wYjZVajduR2RBWSs4V1k5UXAr?=
 =?utf-8?Q?F3XPlAblEjUUP7u46otwqYXED?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g3A3V2hybnRrxtBXSN2f0bHmp7EQPO0VLWMe7xD3wvP56Vc5uG79e/rVxxNL1ZxGjOIZyGXpnrcDOuo7J3OBOK6pXEVGidIdful6TegGEDwcKmhjMYVSnRMSv7DVV8LORfA5MnlQtfOPXHgjUYdMsts6MJFTnR5k5P5qXzQaN20An64rOPL2PzDE/Yc9V+T2sCZAhlfldcfGMq/ej097DhIohTpRXmt3TnutkFcGDdbIMprEaiQoyB46Nn8ws9kCmuzG9g086d6Wh7hwERiClQQIEOBhG4s/rKP/T8bqe3UjVHIJ4gsQLVzqVhJSfdOv7rIVywz489WgwezSkALRSXfy+XE7k7xpwJh7OU6K64HbBS4Hpe9hpIvdkX8tFY5wTG/ifrePWloC5yA3ncLB6IS0A8+0cSOHi4H8fTrdc/6BO6os8NEIoWNZoYAhj7NjoUPfqp1Nc+cFydV+dl/b/lAYlISHjsrfpcWIpvfhycsX4B7MRdZmy5hnagcJobERjliqVxzltuzJddjneUndh2D4ALUIFgmAVYb3SSK2wM3zkBCvMyRXRcQYDRHthym/CaW274EIwDX6tnRoTxkQzkwhKsjdxKmDf2aS6D99z0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26be353e-ecb0-454d-2147-08ddebe29faf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 18:41:13.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iMurYk3AWuYuNjTathz7+opgEo6hycC4ujSxCjXxgpjDN2lLU8i2Ui+BOU5n+VNRKU+/gTE4L04H82pWrRYhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040184
X-Proofpoint-ORIG-GUID: uss0jWbi_m6Nbi_9wRcoMKxnUDgZl4co
X-Proofpoint-GUID: uss0jWbi_m6Nbi_9wRcoMKxnUDgZl4co
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE4MiBTYWx0ZWRfX4Hfw+ejPhdCo
 JMFBZOStcCymc8AdFnMsWFoZC3eHrtwWIMVOY7gQ6FE1xA+PwwrruKZgN3wvS5OHaPtSAwQY9zY
 3mKhHsCd6mGAEOX37VRZl+mhuv7SzFbN7nzzIkc+ttWKPbBCJbI8kmCWxKbvSLDoRxFY0GGefDY
 B3gMVA5RvKm0oxg6P+sp3JUfAKevOd4cE5L0KGSOBPMx3PyB231QA7CpwOO/aFGxmFjSmySQ6T8
 Aj2naemSlyABRc90TcBpnxDLNCDlOxao2mdg7wBMCD/TsvWfTt6FXDOuedo3R3zZOpceTuCSLhD
 kzkYpJsL+EbTGFDeZYz6YFF+3loDKsNu0AJhtZTsW6Omzf5OohRnxvhZpMto99e89800G7GhkcU
 EplsUY6b
X-Authority-Analysis: v=2.4 cv=Jp/xrN4C c=1 sm=1 tr=0 ts=68b9dd4d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=u9zL556LCF99emPv-ZkA:9 a=QEXdDO2ut3YA:10
X-Stat-Signature: 7fp3x4octnm5xfcg1mwbfq7n7yisr8it
X-Rspam-User: 
X-Rspamd-Queue-Id: BFEE918000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757011282-558681
X-HE-Meta: U2FsdGVkX1/uKYmYVduoME3hDLAp+6g+rqDPZUMxDmgiE3hR3MoRf6B37DuNUvZz4lPdyZcqentGXAWsJpZSbsO7vxLtBLukTsPHGgiufUMgUVXv/pYYkcFibahpBpDvGpLczHowJb8/2/oGve6zSX056gwdz/HpfsO/6AdKxKBZHVgc/xzciGTC5Jqiv2RlcQdCt8OyU55dLFDXAUCrUoM9LdZHxR9TWo7bpmvcQWnJmax+YWpvKvAOHCPsI+agHU4x/zFpWpfdNa5mfFqSpXXlZvPe/IdjKL57CNaGKhVTVR7MdFT9qSH7sHf8tSmm8WusdJIffUZnIOvB/UzjZawuS3ytj8X920veNCzYhouuTDHmjUKGo8RhyRZlmMcInsfxxuIMNUlYYs8MTS90ehumDsCrF2Qu1Lsi9p33FQoltUXsavG2Q5eML4mmyElXjGLXILJX84vOUjZ31GAxSASmZhwGi07fSeiy0+EZcxe1dug7TsxXy378+jJ61wwh8DcrhJwJWJTQDofG+GRRkP+yXlaaN/9fuc4Jot5TbvYjC1FNNL5l3ARr8rhZqIyP9d2BpjmAvvQ/GYM4tyAe3wMqEnioPnR0YPgwyh6xqJrmM6LqdH7XMY69Ceyfxa7xTcFpHoEp+OA+8N51DnjTLDWB5/K8tiFlkJuce3alvhXSxI5E+CQnTl/qwzrueFIpGH2siZro1J979U7t3b2l3fuPThlftqCRdxVgcp7ZEmI90GvoY/3N+GjdEuPE2Ueh/3cEd6wUOWVvnqcEQPNOpzCkt1PpJ9nuMfJiwPOogv9MWQfLuxVAe2q3iwzBvVGDr5B9uzmwseFrCk6fEuPVpUdtHQuCdWL5tUq1lIeS+OSh9IvcvYbB2mjlPr8UajqjNlB18BftiUWS6jS5CuJ4lfdFCIey3ey5v6b+H5cdolj5KCoosOYj0TR4lI+17a2D24+MZa30d5QSkGeOMwI
 WsbZsGBl
 5ueHBddkUOA5GSQOVIkqOw2JnBJ/eSTFQSPOYM9ZTrbGohEP8CgPA4V28MIuOzPwllGSzZG59pEN8prk3Ye+hw0tuG7QNeIE8X8rfMKrjQ7cpSN/3Ip+pFBBnXhDty+3oHDC1Y4RXgkv/69BvNCjTxpM8nASur0LfYqSMweUJcDiMN6U8y7t8bKezB4RMOGHscKAhjHUCSgtId5G8VvdA671UaCeF1TkLR54BP0smCbMaxrUKkrHVolUpWZZ0dT7cNc+zRMdX0sPzo2klFQyFfWn51PjYFhHyx/ZGaRY8g3s/TBmPXAXfpRM4i8OgUieSexgee/cScmqot5oofs2VFmwBHRCSYYqYB9zAxJhHfH1y/nusTex9fFzxcTfseiMd6nT2FukQkq7lPAXyfYYywXhXBVVqS9Sq00cswEp81UUpACEYdPnF/j65tdPAJKSnPOCNf2slruAkt3B6w3BSZm23Y4hShL8nNPDXGB8B4JbHhZ307FXMVhTGIy+7OP+lGcmtUz0bCtn0FrVyAXEPvo/u1C0cVLrLmj2Hj8BEZJtT9kBgyqzWeFvHwJpA7IqKRD+NyA+o5G6HgDaDDz94lNZyIlW93HmPh3ZiovomC4SvL4WTQX/d0id8roOIgys6s5iPPekSV0Z/obLl421uXnwAZd7ffXeZFXFZZiTeeeusZG9AHcCLxSJa5pLcK5C+/xKUdGg5mC2WNfafWdWLrBCj7kfiCr2AIN8y1EqCLEdRlWqMSp32Bf6D1wg3XKbSt99oxFM09Pk5ZYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Kalesh Singh <kaleshsingh@google.com> [250904 13:44]:
> On Thu, Sep 4, 2025 at 10:33=E2=80=AFAM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> > > > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > > > index e618a706aff5..793fad58302c 100644
> > > > > --- a/mm/mremap.c
> > > > > +++ b/mm/mremap.c
> > > > > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct v=
ma_remap_struct *vrm)
> > > > >    * We'd prefer to avoid failure later on in do_munmap:
> > > > >    * which may split one vma into three before unmapping.
> > > > >    */
> > > > > - if (current->mm->map_count >=3D sysctl_max_map_count - 3)
> > > > > + if (exceeds_max_map_count(current->mm, 4))
> > > > >           return -ENOMEM;
> > > >
> > > > In my version this would be:
> > > >
> > > >     if (map_count_capacity(current->mm) < 4)
> > > >             return -ENOMEM;
> > > >
> > >
> > > Someone could write map_count_capacity(current->mm) <=3D 4 and reintr=
oduce
> > > what this is trying to solve.  And with the way it is written in this
> > > patch, someone could pass in the wrong number.
>=20
> Hi Liam,
>=20
> I still think there is value to this as it's lot less likely to get
> the common case incorrectly:
>=20
> if (!map_count_capacity(mm))
>         return -ENOMEM;
>=20
> It also facilitate us adding the asserts as Pedro suggested (excluding
> the munmap() case.

And munmap() callers case, I guess.

There is still the possibility of us failing to unmap after a split and
having shot ourselves, so just don't assert that in the case of the
failure and recovery path (ie exit_mmap()).

>=20
> >
> > Right, but I think 'capacity' is pretty clear here, if the caller does =
something
> > silly then that's on them...

Turns out it's on us, not them :)

> >
> > >
> > > I'm not sure this is worth doing.  There are places we allow the coun=
t
> > > to go higher.
> >
> > ...But yeah, it's kinda borderline as to how useful this is.
> >
> > I _do_ however like the 'put map count in one place statically' rather =
than
> > having a global, so a minimal version of this could be to just have a h=
elper
> > function that gets the sysctl_max_map_count, e.g.:
> >
> > if (current->mm->mmap_count >=3D max_map_count() - 3)
> >
> > etc. etc.
> >
> > >
> > > Certainly fix the brk < to be <=3D and any other calculations, but th=
e
> > > rest seem okay as-is to me.  The only real way to be sure we don't ca=
use
> > > a bug in the future is to have better testing.
> >
> > Speaking of testing - Kalesh - do make sure to test the VMA tests to ma=
ke sure
> > this doesn't break those - they live in tools/testing/vma and you just =
have to
> > do make && ./vma

Bonus points if you can add some tests for it!

Thanks,
Liam

