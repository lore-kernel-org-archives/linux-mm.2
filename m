Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83464CCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 04:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DF68E0002; Fri,  3 Oct 2025 00:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E458E0001; Fri,  3 Oct 2025 00:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406238E0002; Fri,  3 Oct 2025 00:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 204948E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:03:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3E8544FB4
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:03:10 +0000 (UTC)
X-FDA: 83955457740.08.3CF2BE6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3896716000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 04:03:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="D6JRu/i+";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OgPG463u;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759464187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IRr6hCVtMTzlneADrTk5mYIKS8asjYO0uODZEhXwJM=;
	b=BW/xUjfqUT1R8tahF/GJm/iHPAkErZ1e3yvfe5ZhrlvIlgNI9G0ogjW9GiWwQfczXUcclH
	p69yIRwrqrPyN0LkUZfJYB+1EJ5jEONXJU2ZIAvTFErHACQA/5cHtomYORDvPHgrqtv8bQ
	6LGgitY00Cvnoq6Rslsc5OBOPBONVeQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="D6JRu/i+";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OgPG463u;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759464187; a=rsa-sha256;
	cv=pass;
	b=y8GAyuQbPUJpQYu1K4pAju214Dk1muCYdo8ZdeT3Vfj0Q6ZvX1T0bT/xAzsaRVnXJBuBBZ
	rY5gjlAgNkbN80vjicU4q0hcMgPRvd5c1XiV59EZ2Ps0pdCk53qY6sSs6/rzQFF3nmgV38
	l9HjUlJQm9TSEgBROzcNaZSYzh54HCY=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592J1nCp025457;
	Fri, 3 Oct 2025 04:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+IRr6hCVtMTzlneADrTk5mYIKS8asjYO0uODZEhXwJM=; b=
	D6JRu/i+yZHcGfelgdvM819uwyd8rtBjHhSz1JiLe5kATUBHp8uh5fffBTZVnHvC
	JZfUFpfMYo+29EB35ZCeJwMQ3tsZEzYGi1Shm41f3BZ1bsnWmthJWLjB+lm4B2Lp
	KvDZl+lBwIrHUTIx/OUAfIYbe5ZlT5+9wzF+ESqdgdEWUASbwnRSWxfN9k3oubb0
	5gn6iZPpK3Wxz3sP4wJPim8JN91tevxvsjnWxC4sIpmw9Xn3qOFoCoxYWt4nxOii
	l6yV0cA1hvA/c91QoPHjAVvpVjeo/GvrBgiFURtXz5OD7F7yTBiOcowPNMLnPA97
	E0PFneV21NJFMIFrgC1zIQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gkxnmfga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Oct 2025 04:02:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5933vAPj018089;
	Fri, 3 Oct 2025 04:02:55 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49hw32j24g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Oct 2025 04:02:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hAzbTaiyuLZ9zDPGdGAG/2AL0joBK63le4e2vmYs/aowsR2Hp/INtZI5uCOiHgkX40QZo190TYV6X7CPo6JE1XL7XG2eDFwGw9D4cJgpE1x/FFVM6oQUcIs6otZe6MQBhNcizAWg4DcGQEYclsIcuwUUeODA7K8m8YaL+NiqVb1Meh8fQYp81eQ4/u2qAm0wnp8v2TFkFrUjwLb+LXII6MJXyELaQFJO/9QbBS9tYnCnnnEwKxqwGjvULAWeN+PxqxtrSPegWAqnu/CCefktP7k++99FFJfX4y4rBrukdEG4ijerf7XA2095RFJPH2Gb84yxe5tVlwheU1/H/hV3hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IRr6hCVtMTzlneADrTk5mYIKS8asjYO0uODZEhXwJM=;
 b=D95vrWm66i3RLpK2oa+A17LQtQ/HUanO65w19zxgyCgkNWYUcOIWBMlTx22qnbRCVI0fR3Y7sWsU267iI2fgedtg2mJi23NONgOYnP5lshBv09I/eubxf9G1VvEorAN/ivXO2n++CQbDWKdujGSgse0EO9JeCDIFyJqzb9TqQ3nm6ev5MR66SbgVttOwG7Z0tEM9NpoXLN6SFqny9VDWvcBHA3kT9rMmWvS1XKOe/D/QbAqmFounENeVdWxj9UBjLJqaWmdLfln2+Qx2j6UWvknNG5jxeQt5oOBmv1s3xyoJcvdlhww0AnTHqH3s5ATiytiPcSj8eVOGfCP4KTgWqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IRr6hCVtMTzlneADrTk5mYIKS8asjYO0uODZEhXwJM=;
 b=OgPG463urX0yVaCjvg8sc/4uedXSHNc8kUAsOdTdX9+uVT1bai3skpfOx0flvLqFYhUPh4sKLxAczEnk3UHAEQ5OBjePOj1C/Ckdj++S/l4x3T3OnZrBCnURoKsUgxaPmwCIzc40uSKJeYzzaPNWnQErnb5nr/COdlNSaiSUuYA=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA0PR10MB7184.namprd10.prod.outlook.com (2603:10b6:208:409::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 04:02:51 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 04:02:51 +0000
Message-ID: <7db593b7-6f95-4346-bffd-041fc89ee3f3@oracle.com>
Date: Thu, 2 Oct 2025 21:02:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Zi Yan <ziy@nvidia.com>
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
        david@redhat.com, kernel@pankajraghav.com, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
        nao.horiguchi@gmail.com
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
 <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
 <CD6D8EBD-F139-41BC-9A59-5033EF5A09BC@nvidia.com>
 <d60770df-a967-498f-9e0e-25a6a145ff55@oracle.com>
 <32A2C338-EFCC-470A-B5ED-E53C38395E51@nvidia.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <32A2C338-EFCC-470A-B5ED-E53C38395E51@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::16) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA0PR10MB7184:EE_
X-MS-Office365-Filtering-Correlation-Id: 5151e9ba-59bd-481a-6ad7-08de0231b880
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkRsdFA1cGhYY2FkOVFPY1RuSE1YRFlPa214Q2RWSkFkcFNXUUNzdzVicnRy?=
 =?utf-8?B?VlJSa3BjUmZndnZrTjVlMEhpRjhsSU1iMTQ4a1VJMTFFb1NMd0FtMzZjYmY2?=
 =?utf-8?B?N0JoMnZUbWs4YzcxTEF5ZGYwSWdrVXZpeDh6bjA0STVTdVZwZ0FCWlRjbTVm?=
 =?utf-8?B?VmhtRFAvalpPYm5PNzlHU3pNYWtNY2YwSkdGZ3kzTTVkVTF0UWFNUGZ2RDhm?=
 =?utf-8?B?ZEZ3WUxZOC9OZmU1N0xaR1BMR1M1RVNiZFJSZjFxc3lYT3NJam4rcUljRXhM?=
 =?utf-8?B?VGxXT3ptZmtDdzBDTEN3aTNSaTVyYnZjV0lITmtpUGtRRUhxU08yOU1rRFo4?=
 =?utf-8?B?TjEvVDJpK1hCWnZxbE14L2FLVFlaNGtKMUpnU1ZMZVpEM3J1THJ2SmZjMXFS?=
 =?utf-8?B?aEFRMXZLRTVRYmd2YzEyQ0gwMmVzTTdBM2dwVlUrMkNaT1diUHJ1ZFNCY3Vo?=
 =?utf-8?B?RDFXNFNrRHRNcDJ6YW5CdXpBelhNMHViZzRRaTQ5cG9FK3lQRXRtclZBSkNU?=
 =?utf-8?B?ZXR2YWoreTBHV1lFcTRDMXV4ZzRUN2RYWklsQTJjVDR2dnp1ckhBTmFZWGhn?=
 =?utf-8?B?dlhMSFNMUjRMTEFXSVp2SHFBYWUza05CeGJtcitSeEs5TGFuaTY3WnZBdktP?=
 =?utf-8?B?cEZNaW4xY2s3RzVZZzJuQndOSlhyeU5Zc1lRclUzNk1sY2MzSXhjL0Zxbkth?=
 =?utf-8?B?MEFXUXpyV250bjhCNmhzZC9UWkd2TDlKTzd4cnJsR2Jrc3JTT1dDWXB5RlAr?=
 =?utf-8?B?Znd4cmYzb3E0Wk5lZENSVDZhZnJEMCtnR01xZkh4UzAxbDFwdGNDOE9DVFUx?=
 =?utf-8?B?aXExSnJuYXJiaXljK2hjeWxlOUF1KzRGZW9POGVnbHNwOCtaZ1NMOTg0ZzN2?=
 =?utf-8?B?cnpFOGp6ZFRONzd2YVZlT1YvYThqYjVjODFsK09TSHhxa3JScWdLS0UwRFhJ?=
 =?utf-8?B?cTdGVHgwdm5oOE1pdjhaMjB2aFZHT3pwNTNFK1N0Y25uZGZLWlRWOG9KbktC?=
 =?utf-8?B?TGkxSXZIQ3BLbi9JazgzTm1sYlNJTzM3MEZmU2EwYldwOGhXR2hhWGR0Y05p?=
 =?utf-8?B?N2xnMVBSTnE1QnhEY3FLOEh0QSttK2NCaEVBSHVzQmRYNjc1UXpWR3l2STZK?=
 =?utf-8?B?KzNKazduVzhaWlJkVmdmcWVtYjNjaVJRQWpPYjF1WW5DK2NNam1nVzQxdnFM?=
 =?utf-8?B?K1lLYTlpelRuYVF5NFMyMnNIRjJZSHNORVlDMVZic09QaEJPczlkRndQZnhD?=
 =?utf-8?B?WkFOZHBwdFhVS0lKZjBLSFhVdXpYY0M3WnJobXNoN2hiNVVKZXlRREhyVzd0?=
 =?utf-8?B?L2cyd0tZVi9Yd0pUMXA3bmkyOGcxaUIveUVqYTF3UHBzbnUzVTZOQzQ0dVM3?=
 =?utf-8?B?ZlBRcE9seFBjaE5MVlQ5ZDZTb2dnajA2cGVUU3UyaWVuY0JtSlhMZGJldHgr?=
 =?utf-8?B?ckhERGxPVWpSYXp6aWxYQjMycHRENjNKbjRlZmpTRXdFSVRpaEs3WlJJT1E5?=
 =?utf-8?B?cWoxU0hGSzJTV1JabjFBY3FSVFpEaGdvb2Zld29BK3FQWWRpN01hTXNUdVhp?=
 =?utf-8?B?ZEtrbzd0UHVEUU1tS3M4azJZZUxvN1pPU3V5WS9pd2wvWVNkbmVVZC9QaUxw?=
 =?utf-8?B?aUpDeERIVDhFNTNxOHFzRVRFZDRWQlNoODF5bjI4Ti9GS0VyR1hxc3VSS1Zr?=
 =?utf-8?B?dzZQc0treWZWN0tmSjBoM2ltTndYcFV2Sk5HQjA2b0ZWbUdEV1VvMWpaTDRa?=
 =?utf-8?B?aXdBSGxZSjhDdjBSTWdvd1NwTWw3YWI1QVM0dmRnamJ6bjFGbndnUitaalN1?=
 =?utf-8?B?QVMyd3RVaXNJV0MrTkZZRy8wY1VxTU9PK2JrRGVWYzhxS1ZvdlV3QTd3ME5T?=
 =?utf-8?B?RVB3L1FXbDEyOGk1Vnh5Rjhud1ZReFQ4ZDkvK2JJbDdZOXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1lBeTN1Yk9CRUJMSGJIQ2x2bWU3dWFqSWFWRHN0RWN6QS9ZYnB4cUEyVkMy?=
 =?utf-8?B?anR6NDg0am1HME51RStCY05VajB6bDl3ZnBDS2pLTXRNakhRM3R1QlFBOUNR?=
 =?utf-8?B?RVVmTEk0RW02aE80RkIrYVZwV29ZZkQxRVVlR3AwV2JKejBHOHh5RmYyTThI?=
 =?utf-8?B?VkFTSHZVRGxQYzRWVmwzMDBmUm1BK1IwdGRHTmxjUVRaaXNEVG9RQVptWTd3?=
 =?utf-8?B?aUFlQy9PTTZiUXJvYyt6cnJvdklzT3JweDlDK3pjMllWKzRTeis3OW1nOWxi?=
 =?utf-8?B?UlhaY1dHd0thcVdldnAzTkh3ZmJ0aDZHKzdNaHRtcmJDTEhvRXFUZkpQTHlv?=
 =?utf-8?B?UStiZjhxWTlyRWxYdEF3cjM1Ujh3eEh6TDNteHpjc3ZVeFRmeWNab2M4Qk9S?=
 =?utf-8?B?T0pkVUNFZktIRWlLMGVVWFBHTE9YWmdzUzdwTk9oQ2xJUUhqSVNRaThjUmFI?=
 =?utf-8?B?RCtFa1BTQVQwM2hlU2gyQTVUZkJnMVhTSnRyTVRpd28zcERhQU9OWDUvMzEv?=
 =?utf-8?B?YkMrdFR4S3B3ZTIvR3Voenl3MCtjNjJ1VTlROTltRWgyZEVJditUS2VEbjZP?=
 =?utf-8?B?L2NnUDVEUyt0emVRWHpWRWRUZENPTDBWTUNNM0lpVHBTZGo4ZEt0b0FTNmM5?=
 =?utf-8?B?UjN2YTYrdnJMSXBqbnpzYkZuNm9RcHNIc0ZScVNDSVRnc3h5RGMvRG1mVWVu?=
 =?utf-8?B?b2h1NlB3SzFkd0REY1lWT3VucXR5MUxpNlppRXFCNGZlMVI4T3BUaU5NS0Vm?=
 =?utf-8?B?OTl6eGhGcEN5ZkFCRmI1NGRDQnBFWFJEdURaYXVNd1dLV3FhQXVpRUlVeE4w?=
 =?utf-8?B?cUpaYlBTQnJzYXduY1NoRWduWEZ0YlZNMHZnNktOQ0RaTThJYnF5ZXlVUVZF?=
 =?utf-8?B?RHB2Y3g0UzVSazFJY2dJMmVXNVh0Z3plRG44UWVITFI5NUJBbDJPNU52TGIr?=
 =?utf-8?B?YWZPR3RDMWdFVG85WXYxVGhHUlkxdmJCYkw5djZxNHRFNmZyKzFnMTM0UExQ?=
 =?utf-8?B?THVqU3ZOMm10ZGZsT1FEcXU0QThDWkFjN2lscVRYd3NraW1nSlJ2SnNuMU5J?=
 =?utf-8?B?UzhYdC9lM2ZNQWs4b0E2eWwyeEVERUMrZnFIaUgxSlczTUlDQWNHcU9vZEZV?=
 =?utf-8?B?MEJqUE1ZbXNDbjdsVHhqZzBXaFpwMUs0RFF1S3R0UStrTmlabkJYNDVyelhI?=
 =?utf-8?B?eEhNZWk0MGdiOHBPNkZQMmlENVdjOWRSa3BjWXdzR0sya1p2RzcwZVdzUzRQ?=
 =?utf-8?B?OVlKaC9wQ0xsTW5NOFMzc0RpSzJMNDVnOXA1WkdLbGdGempYMm5iMHlzYkFL?=
 =?utf-8?B?ZVBwVlhoY01LUy85VFI1N2NDQ3RIbmFkbm83TTg0WTFjSEx5cFJodzI0YmJ2?=
 =?utf-8?B?NzFlS2l3OCtGOXVUUmc0WXVLTE9OQkxXOElhL3dvcVhWMEsrRVgvNG03NXpX?=
 =?utf-8?B?SHkrWTV2TkREUXY4RjdLRzZFRWdzR0NXblNpZFp5UGdaTW1saUNuS2cycUNL?=
 =?utf-8?B?a0pJQjBiaXRRUDh1RkplL3Y5UmFhRS8rYnVXMUZRTFNwc2tRUzJib1lGSGxm?=
 =?utf-8?B?dS9GUElhaEs2MERkZDBYRzZzbHhzYXRiblhrb08xVnlpeWE1UUdyeWhjS3Ji?=
 =?utf-8?B?K0pZVTl0L0Q3VHNNOGJXcGd1d1plOFBsMjdKWDc3T1NHNkVjMCtFcG5VYWNi?=
 =?utf-8?B?TnBrZDMrZjRCZ0J3Z3dIdGRBbVpwWnJMNXRhK2lsV21wajlCQjM2QlcvR1Vi?=
 =?utf-8?B?Y1RjbVZ0VG5RcEFlcHd0V0NVZURLUFlmVTJuK1Zqc2t0RVloV1JJcXg5cEo5?=
 =?utf-8?B?YzgzdTQ5WFVFODVENURXTnZUdVJXM0thVG5SSGNqbDh0L2xXVERHb1g2REpC?=
 =?utf-8?B?UzhVM3czc2MxMmdFcmtYMExwbkp5ZXpsTVFwZUw1YXVwK201WEZ4SmRtTXVT?=
 =?utf-8?B?bHJoMXlSY0U0dEwrTGkyRVJiVm1Rb0IrL0xNUm5XdlhKQUhrMFVMMjVlOHRj?=
 =?utf-8?B?SHlrci9rT1c5MzJQV3c0UTFma1lCeUF4WUVxdmdIR0tDQVV3WnlhVUVJRzRs?=
 =?utf-8?B?UGFPbDRjb2xMTFVFOUJ2KzBYdWRJNGpOVzFCNm8vTE05ODFadVIwVlR3eTRa?=
 =?utf-8?Q?dGJWuFDWtxAdh35nX9UrZNqoS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2omh1pPMtbVvOoypO1s9INqFCZEYAV01IBZkUFRLszVumXTKPJGV954DrX+oSA9KARs3KEu10FY3VWtBxkQgAfMYfydHpW/c7ZfmTmoeefq2z6/Ssatw8cRrHCNVQBz+dYqhsy6EAjRS7H5URI6o/6LRj23VcLGOtV8fmgBe4I/NPqHzDcpBtuU8UOJG7EG6Oi4VmKD329NhA80qXfU8OnwGSaO+Nl0+hDY7eh67RZ9rWtiqhqSR77uh7LCFkepMMl+AWbawJimt0NQZEILlJ964BaMyjxKENm+m5UOGiJbWi1U7p+Qitj48E5VxfcNvyMtZSs74nzf7ejLdPS9XmDbGoBYl1pmTbPPS9W6K3qC3BHJY6nSXsAn1cOT+VZJcEdW2w0NyPLFERYcf/UgDCFMZqaopziS/ayP2ActjF80XsW+t6/MqYE+OFzh+AKjOLuB12i380WdgyF73w/D3dzjDWGY3RixfLnJBdMPOxyrqVKZKL0g9EcGPpqXfiC9jWomJb7LlatL5PV7iqnSke/2eh5Kx5QeUoBUdw0dR24paYcTHnJHBlAg4tLAGcsScH+QCDUX6IJ15TfoIYta6wo1JI4ETB+vd4zdxQ/tJgY0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5151e9ba-59bd-481a-6ad7-08de0231b880
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 04:02:50.7444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzPXAnFLh05z2hobMw4kD+LGHvepQlsg6FCQlauuqO846mKraPfWUvW4skUsNqAgTLNEaJnw3KLbhYHw+mhdoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-03_01,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510030028
X-Proofpoint-GUID: AIkl2aRj2Bplmx5mpxn_xwJRYz_SwOhH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MSBTYWx0ZWRfX8p55T0IxwcOW
 9/qRV0Qy950trN5GuBUG1tESjfxOsTO3q699BTUBVP3Ump5ov5iY+Eb4zPrjFY9MJbiOYwMgq3P
 brSYteqnmupwfJ4nWPObPyGrThnaFB8az3XYoaGDqYL384X5N4ugEKHwDlOEuYcSnrJAp4cLeL1
 CrLnbuiqfAv6g2FivlrTHXGecATqA51b390uyDOGlSQieYciLT2DsjrPWUewOdGm4bFo8CgHGrY
 K/e8gDAhIfHNfV43S8y9ipWSYlnOezC8KL4EdGl70KiXB9pqE6LoeR54ngXe9XlFpPESv6lYMgC
 rGjkWrGNMdQ6Akej7Muxe+yrxMgTfbKpQW3dZ/eSYQQ6f5d5Xr0d741zYWJDiPlOaItlNhOAX9a
 FAmO2KG1tCcisaeFRZ3CHQMT8N/ivrRPSm7i3zZVfNMrV0VAaVE=
X-Authority-Analysis: v=2.4 cv=RLW+3oi+ c=1 sm=1 tr=0 ts=68df4af0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=AA1TR184yu9CaGNASqUA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 cc=ntf awl=host:12089
X-Proofpoint-ORIG-GUID: AIkl2aRj2Bplmx5mpxn_xwJRYz_SwOhH
X-Rspamd-Queue-Id: 3896716000F
X-Stat-Signature: qy9ttchauenzmjg88goe7b6w5rnudben
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759464187-698245
X-HE-Meta: U2FsdGVkX19JjAwZ7SdHgcbgbribu7/vu2ZII3UAV0q7LPKPcYyr9fAoWZu0BiyelYTXbbWrwAYB0yoK39WtKZwAiczuVgoswu5dLQ6tyWAYtpjq4Peo+BlWxFV4VlS6/loaDhYBBVkYwUX1PHQt8LHQ95CKR06Myb0eeLS6V6L2L9t+X/Sw4RPixt2Hzbo0IcfijqCueSAjVV7zpKGNikfZs7Vqs++dYOvVq21cDZ8RO9hNN+AclrQn3REsdL4gxFL2vE9KMf7054UUH9cbqQdOkMS6skrzyzecBJe7lVx9XO1xfYe2ZYl5tBSYRuw3t6k4JDhBqgf7xcXwM1MzEjZjg7D5Iza16v+FcXVhfnfxJkNh+SEUUN8ypOzDN072QQYde4OIZ4EAvpFLQKpNd0XtNGNUZK7Vhbg1gq+onr8nX17UR1BYSdXJ3RQsqSUhUQHaBREOIFvU6+GK6F82lHcyssBD6T3HBxKEFfKIb025Piq6MbE2IKJpsZINIdebKaQl+ezzjBcS890E5at2IrBG/yXEKetACpyoRXXrS1O3YUwdSR5EocvvhSzKycs5pFqRnJyHz7e0eqsAHpjGHG3rdKJr4yeJLV3dhTbwDERuL9n5tYfe5iOdINcJ8IKoz7rjJLylxziuvcgA83OAFdlNXSsKg/WapgKc/Owq03HGbl8ZshPi1DB3np/WPFr5Vl7kx0fjuheEBzA8EBFRe1YiWChpV3G5WOoUMH4wgElt9WFsN1QpkPlZiqWymm/WuB824E7YbQxt6Oh22O/zWpLAyvE0slOzipxnagK07uUPD0BuSAm0PlgGagakKbG2Vtjug9yfRBRcF7mdn7HO89u2fVZZ7aahqh87tlt+vWEc2wwdhYaT4VvmjdgzebtA01d65LbrU8W5ekigvgV9foBmqQUon9Idgg+CFopmNPxA35pgR48Pj9rNex2LnnzoGtmqMarAOIqYYPAkzg+
 GP+Pai+b
 3EE+WVao2aKKCv9LvNOSPrtXaGSs1HhReLyi4UImJM/cBPZofSaDIPcRRsIi2kwr0eT2YmPi4mLX7AOXKgUlHkYvSss63MXtwxzTHtUEg6iLRjGMP6Flabj2MHpc5wOOKx3ThlTzpk55xt5cdPLlQi/u2OROgEZm2z/5x7tWDeUx0JfyvHMg62jP+Pl1XBg0PIi0qrExFxhVxTgQdiuG/2sEk+9qXREaSsH3WysB4YCqV/pfAjM4bqlgMfTn6gmE1NZgfyA1YKpsK+egEfde3UP4z8SpVHfQ9V/wbjw4CWd+k98OhpXJgqtJoelS0NH9TTm0T8q/jx5hN4NCHDa2hHm8Bmy6KFtzHjGOC4UdJKu4EwVBx5RQT4OJfmNz6PHU7qGJUJD8kSMlioma2AKSYri2s/KVxmzVEyUumtXya9Dxt1WJdCX3trgDVt2z3cUiPF8OdIua5hSBc2Q4YvUv2757vbWw8ArjAhmLjHLLv6fCnOkWJa5OzJBYt5w76CITQgb60IITt7xRZW+Acj9yZvCYHjvliEqfKrs9zULQLkoEzMybXRjII9hlKqpZ7E70lFqhMVUYjKXtKcjt3VSv52pTTbEsq5wK0CG4vhigLlrG6oUgAYJ0GMiwiR80yrNs/JL63l6Qxqk9y46dhoKvxYT/+wouALMx/L36R5o0XunwjQiyfyJpigdcDStcDE3NnSF4swld2Fof8c9R3Igl/xwxkwMT+SveMoQvWkX15YKr96NOpfgcbMBGz5lGg2DKMaLs9bMGIBdAUG/jAJxhq5rnF1eGs23NzX9XXQEWICnyBYQ51MmF7hJ4JysoFqQX7J3QzC6EIv+9l9hSIrYSc75monEZ+WcC9I4dn7S7rYbomMu9H3p16yl0yt4lWCMzl9E1IKu0efqs7Ex4j/WUwFdE6kKEuE7echfMUeoZtYh6B3inGMoc8Abl7lf3Np1SK6tCCsIHP5x2mvg5hOKBQitYaeO88
 e+DpDgQF
 TLQ6wvdi5mIIxe8CNhHx1hcV8bpUVk+Vtsu5+ysd5lLkPnvh4IpsoZZuWP4jZtbCuOsfYHBMRrA6pu+QhdnWHQtrVNCNbRQKKflpGBdwd4JiQpgIThwbnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/2/2025 11:45 AM, Zi Yan wrote:
> On 2 Oct 2025, at 13:54, jane.chu@oracle.com wrote:
> 
>> On 10/2/2025 6:54 AM, Zi Yan wrote:
>>> On 2 Oct 2025, at 1:23, jane.chu@oracle.com wrote:
>>>
>>>> On 10/1/2025 7:04 PM, Zi Yan wrote:
>>>>> On 1 Oct 2025, at 20:38, Zi Yan wrote:
>>>>>
>>>>>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>>>>>
>>>>>>> Hi, Zi Yan,
>>>>>>>
>>>>>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>>>>>>>> lost connection to test machine
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Tested on:
>>>>>>>>
>>>>>>>> commit:         d8795075 mm/huge_memory: do not change split_huge_page..
>>>>>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ce96e2580000
>>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
>>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
>>>>>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>>>>> userspace arch: arm64
>>>>>>>>
>>>>>>>> Note: no patches were applied.
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Thank you for looking into this.
>>>>>>
>>>>>>> My hunch is that
>>>>>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>>>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev/nullb0 in
>>>>>> Yes, it only has the first patch, which fails a split if it cannot be
>>>>>> split to the intended order (order-0 in this case).
>>>>>>
>>>>>>
>>>>>>> the test case are probably with min_order > 0, therefore THP split fails, as the console message show:
>>>>>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for unsplit thp: Failed
>>>>>>>
>>>>>>> With lots of poisoned THP pages stuck in the page cache, OOM could trigger too soon.
>>>>>>
>>>>>> That is my understanding too. Thanks for the confirmation.
>>>>>>
>>>>>>>
>>>>>>> I think it's worth to try add the additional changes I suggested earlier -
>>>>>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com/
>>>>>>>
>>>>>>> So that in the madvise HWPOISON cases, large huge pages are splitted to smaller huge pages, and most of them remain usable in the page cache.
>>>>>>
>>>>>> Yep, I am going to incorporate your suggestion as the second patch and make
>>>>>> syzbot check it again.
>>>>>
>>>>>
>>>>> #syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_order_and_opt_memory_failure-for-kernelci
>>>>>
>>>>
>>>> There is a bug here,
>>>>
>>>> 		if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>>> 			res = -EHWPOISON;
>>>> 			kill_procs_now(p, pfn, flags, folio);  <---
>>>>
>>>> If try_to_split_thp_page() succeeded on min_order, 'folio' should be retaken:  folio = page_folio(page) before moving on to kill_procs_now().
>>>
>>> Thank you for pointing it out. Let me fix it and let syzbot test it again.
>>
>> Forgot to ask, even with your current patch, after splitting at min_order, the old 'folio' should be at min_order as well, just not necessarily the one where the raw hwpoisoned sub-page resides, right?
> 
> Yes.
> 
>> If yes, then 1) I am wondering about the value of the min_order?  2) perhaps
> 
> I think min_order depends on the filesystem config. It can be like 2 (16KB) or 4 (64KB). Based on the reproducer[1], it seems that block size is set to 64KB
> (see ioctl$BLKBSZSET arg).
> 
> [1] https://syzkaller.appspot.com/text?tag=ReproC&x=1361627c580000
> 
>> the syzbot test need to reduce the number of fork()'ing,
>> as with each MADV_HWPOISON inject, one page cache page will be lost and stuck in the page cache, the difference is the size of the page cache page and the number of pages.
> 
> Right. the lost page size is amplified by min_order.
> 
> BTW, I do not see fork or loop in the above reproducer, I wonder why the test
> went OOM.

You're right, the test itself doesn't fork.  I saw copy_process() in the 
oom-kill call trace, I spoke too soon.

The tests appear to be running in a tight loop, can't tell the number of 
iterations or duration. The console has logged "5039 pages hwpoisoned",
likely with each MADV_HWPOISON injection, a 64K folio is lost. So either 
that means 5039 * 64K, or just 5039 base pages, it's a lot memory lost 
and become unusable, until zone normal dipped below the min watermark.

I think the test might need to be adjusted.
Option 1, reduce the test runs accordingly, eg, if the blocksize is 4K, 
maybe allow more test runs,
Option 2, add unpoison operation after poison.

Not sure how do we go about that.  What do others think?

thanks,
-jane


> 
> Best Regards,
> Yan, Zi
> 



