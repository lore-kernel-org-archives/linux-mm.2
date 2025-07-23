Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F6BC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6835F8E002C; Wed, 23 Jul 2025 10:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AC28E0002; Wed, 23 Jul 2025 10:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBF08E002C; Wed, 23 Jul 2025 10:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEE28E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:52:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA61AC0728
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:52:21 +0000 (UTC)
X-FDA: 83695820082.13.5249CDD
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id B73DC1A000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:52:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JHKhT5v4;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of BMT@zurich.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=BMT@zurich.ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCT7oXNSNXYl5Gus+azvA+q0M/sXIUhAxjL8h6KTPGo=;
	b=TP2G4u9Qfubz9m6NICZqubHmEJOGOx1pJHNvaUvQxAS5EwM/VwezpCVYXmkiWdu2F0EhzX
	j42mBey2py1oo8pS6WklsNouns2bIbAMG+9/urelVEXVO4UlztOxyL4Wev4fYXitCQ45yg
	dioEZBrk/dft1lc3iRn+kHnJ61iMzEg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753282338; a=rsa-sha256;
	cv=fail;
	b=HPASh4BvB25235A+wQQ1BZaE9m0G9hzNpqa9fSaGCUzWsOu7hyEhi/0Edf9nH7wEi7JqPE
	HwtKJjSuxg4JHrKgPKNxpasrNss1ilAsnqeznDMG2lU7YLu0uFPY2VOoIjc9OnmZPtHoFc
	8f22VtC0iukfNtav6FQYeEFPWpg6nxE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JHKhT5v4;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of BMT@zurich.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=BMT@zurich.ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ND7Jh9016142
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:52:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gCT7oX
	NSNXYl5Gus+azvA+q0M/sXIUhAxjL8h6KTPGo=; b=JHKhT5v4yT+6zWmGK084KQ
	DJy7ALbENccwoRCSJIwm/PYdc8Ld60zjyC2D6/jnYkbd1oa0qP1l/779DnNIS+73
	OJdcr2F6TJiDmcK/E25RuEX8QCugjpY2RqLCjrnCuCnLGFzfJJLVq1h3lGOfVJaC
	HvwN4j6F6Ennj0t/yFIz3nG6jLYf3X+GpShGg+babEln78zymw8L8t/grA8Hr7Fl
	ZKJnUvKAYMzg8Cc76OmDM1Nei9PU6phnlO9p9tD8f4b3lw/YqpNXzQ7Fy3FBVzV3
	MWlLrqV8nGESmudDho/njiZRYfWN1f9MtuXHzmuR6f5OuR8S0zE2+FpWuyCwW2JQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 482ff65drq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:52:15 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56NEqFYW031242
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:52:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 482ff65drj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 14:52:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rt1l5fKwVEqsxKxdu5lEEbKqPoQ2/sZ55J9ioVGUuIoy1pLkPO1yXS9R6KmV9scnK21ppdaycJ0F0UpF6JD47DXQVd6e3gTO6qDmaB7qAbUe8NprhtLiuT2Hdd0Mzc4qKciXKFT+LZoR0ypXSuVCg/rVKH02WX82uinzzOOEvRFZXTJ2hzIDF4x1NKSqwB4ZD3ChgM5v3jPbBbMMdXnY/zfE4Zul8go0tbTMozcsBHxz+B8QySF1Ua7TnE9jzuVJ1Mt8qyX0wDuLWMfzChBZ+7KuZir0YXru9hN5sezLDc25Z5SVe98ra7/ZJ1vtup81Nu5i1rsZ+RhDWzlsB9IC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2c6Xwsdfp+RqrMioiB0DkOpWIdcib3u2xFMsy5gIufg=;
 b=pUI0Y/kSXO//jemuYclC2HYe2LKKq2KqHlKv6OxavRZv/CSyLUg2utacyXOFfX1r49zc0wR7ivyJPjVPj6n4D9qLcK2U0Mkf/Zwh+5GYFb01UUpgpAl/NLqUDP2X5aajE56Ml2Wxz8kZABgmReWaGYt7GVkZGpfG8bw4A9o27KLlMVjga3eTmJhYXbHNNtBhuH8XkD3a8+JYJ+r+S9/ShGybOYy1Fj+Er76SXZ+9rQoKCPcy+OAe4zRNPpiU/q2E2SQUaA8+MFC2n0CPIvPiYx53lVLIx8QLW/jpK6ShD7C9muHLgwGheOdeDAmoSxkb1w9MWBbh/4QFQEYlj/3tVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from DS0SPRMB0067.namprd15.prod.outlook.com (2603:10b6:8:fa::6) by
 SA0PR15MB4045.namprd15.prod.outlook.com (2603:10b6:806:89::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Wed, 23 Jul 2025 14:52:12 +0000
Received: from DS0SPRMB0067.namprd15.prod.outlook.com
 ([fe80::dbc1:cd0e:bdf2:dabc]) by DS0SPRMB0067.namprd15.prod.outlook.com
 ([fe80::dbc1:cd0e:bdf2:dabc%6]) with mapi id 15.20.8943.028; Wed, 23 Jul 2025
 14:52:12 +0000
From: Bernard Metzler <BMT@zurich.ibm.com>
To: Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon
 Romanovsky <leon@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
CC: Jakub Kicinski <kuba@kernel.org>, David Howells <dhowells@redhat.com>,
        Tom
 Talpey <tom@talpey.com>,
        "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel test robot
	<oliver.sang@intel.com>
Thread-Topic: [EXTERNAL] [PATCH] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
Thread-Index: AQHb+75lt8vGIRAM7ESENOpUEHV4oLQ/xxnw
Date: Wed, 23 Jul 2025 14:52:12 +0000
Message-ID:
 <DS0SPRMB00679C99808A4D85BAB6DADF995FA@DS0SPRMB0067.namprd15.prod.outlook.com>
References: <20250723104123.190518-1-pfalcato@suse.de>
In-Reply-To: <20250723104123.190518-1-pfalcato@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0SPRMB0067:EE_|SA0PR15MB4045:EE_
x-ms-office365-filtering-correlation-id: 302393a8-47a7-4177-338a-08ddc9f881a5
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L0hvWlFVTCtseTEydks5Z0hSQ1llSXhSb0MvVktuNkxoUlJlMEF0amZBR1BC?=
 =?utf-8?B?TzNvb0RXQ0YzOHNYSXM5aHFFZUE3WkhDdUpKN2RvS1U5bEJoSTF4Y0gyRkdw?=
 =?utf-8?B?cjNrV3VpVDZiTkl6UkwySnBERmh4emhkNVpOajFucCt5RzdXdzJRZmpCSkhx?=
 =?utf-8?B?SElJMndNMTVrM05XYzcwT0pUL2FHLzkvOG1TN2o5ajgvZlhSS1J6SmtJR0g4?=
 =?utf-8?B?dXBWQ2Fiakd6cnhOOVdoMHA1d1NZVVRJRUlhOGtBYjhwTHROdm9qUzFrakZG?=
 =?utf-8?B?NGVtSFM1VjV1RWpKanc4VXR2UVBKWjFXR2x4b21Oa2drYlhDTURhRzdjMnlj?=
 =?utf-8?B?ekN5cXNaVkxPMHBTT2FoN2NaSTdabElSUml4Y1BvQ2tSYURKWWpuQVJURnZJ?=
 =?utf-8?B?UnBNQ29VZ2NFTHJzMXl4OG9ZRUhqakJEL25xdmx0a1VwRU00MXNtUGduaTRF?=
 =?utf-8?B?OGM1VFJLazBjNGVvaW1ZUDdrbmtEVDVZRUR0eTZwRWwyQy9NNVlMS05ja0ln?=
 =?utf-8?B?UERZS0FaT0MrTWJDYWNmK3dURlJwRlRLOWlldUllRjJKUlVMQkZ2NG42YlhZ?=
 =?utf-8?B?UHI5dVZIbUQ0WXNOYTJYTHdVaThRb21CME9JWEtVTjAzeVRISG42cDhCSC9a?=
 =?utf-8?B?QStORXhDa21UQlRkWVl5K1Zjai84Mjh3dVVaSWRBNitEVjhmTFp5cUJQNkhP?=
 =?utf-8?B?b092L3pRUktZb0hYblVFTjczTFprQTQyM2RyUWdQK0RRMW1Ubi9nR0EwaTh6?=
 =?utf-8?B?VmlRczZTTGJTbG9IdHJzTnFsNk4wbStRUyswM1YwaDRZRDUwQkFMNVRUb0FQ?=
 =?utf-8?B?L2dkaTBPQzBBL0dmUmdzRFprcnpDRHVrVXo2MkJmdUtTUFRUSWhSV2crSm1U?=
 =?utf-8?B?MFlFT2w4VjBMOEc3VCtxMjBacDVnNVp3djdxT2g0M3hGaVBTVG54N2t6bUpZ?=
 =?utf-8?B?cDRJOXNqTmNkTFRRKzljYUxrdHo2Vkh6a0hlc2djczJMS2ljRTFJTExUb0k3?=
 =?utf-8?B?R0UwWmdCSGNJRlVTVHltK0RJY0lTYjI4SE5SeHlRL1plUTFZRzVtVjU3Ukdj?=
 =?utf-8?B?Z2VNOHNmNEE3OU81dnZQZjRKbk9OemlsNU8vV3hNTjZISHBheDFhYXlzRzRH?=
 =?utf-8?B?eDRabkRzSVYzbnlZVUtFK2VsSURxcERHQTJ3Y3ZsKzBjdkZvNHc3dHRoSmFB?=
 =?utf-8?B?amZncFd5VkFoVno1Yk8zWEplMXhuOFhYK1NMVXJJeG5tSGR4WkxvbVoxbEp1?=
 =?utf-8?B?aUxGY1BKTVZ4WjRaV1dBNzRyOW1wNjNUQnczanZHenhuN3JBT0NWcmRjSnNx?=
 =?utf-8?B?NkdPc3h4cGZKOXJhWW5JZEZlakdVMEVTRlFPUlM5dkRxWW94YVI4ZnhlamRi?=
 =?utf-8?B?eVhIN1IzYnRLSzZwcWk4M2VEOUNpWFRpVklVUGg1NGdCRTA1TTlLZGg2US8y?=
 =?utf-8?B?SkxFdnFQOFRTYXBMcFIzTFNtRlNicmhDUWJCTFEyaU1kYjR4MEFpNWM2TWxp?=
 =?utf-8?B?akoydGJWOFQ4MFFxSTFsS0lOSnNURXpBaVBjYVpIVWJ3UWVuQ2RxQmJpN21G?=
 =?utf-8?B?RXhoNDd5aXJtbFRLZ096OUc1ZC90aHdHOUNkcUpqUERBTzFnVk9TZERQMlp6?=
 =?utf-8?B?OUloRjJJQUtORS8vOGxVTFRCZHRhSDlGdWQyT0JhdTZBWnBITTl4VWdqQy9n?=
 =?utf-8?B?R3lPVUQrUC9na1FqbE5JREtocjBZVkZvemRJOHFqVlJ3cmdlN3pYL201Uy9Z?=
 =?utf-8?B?bnJNOWpBQ2NxYkxYQ2twMjJmdXBKUUVsY3JIWWFZa01CMzNtMG9Ga1RNVjNC?=
 =?utf-8?B?cElEOXA5ajdqeW90cXA5VDNic0lIMTNCVFFUK011TmlEY3AzZmczRTQ1QkRa?=
 =?utf-8?B?aG1YTkVuQi8xMDhldkwxQ3JVbXh1bTc4VWN0SEVKQXAzTXdkcGJZbEErclN0?=
 =?utf-8?Q?B7N3HKEiTWg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0SPRMB0067.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZnpFZ2o4STVzWm1UUWgyTU82TUZHaW5UbEpDRDc0emVpYU01b0pYcHlIR0pP?=
 =?utf-8?B?RmVxeDZJWFlVQUltc0MxcDgxQ0U3QmRIY2pZenpVQzR0TUZWYzNVbTlyaU84?=
 =?utf-8?B?WTBSN1F4UVBWbWZuV2h4dHR3RGNtSnhLVUJVUzBjYklaZjdOUktDSExJQnRL?=
 =?utf-8?B?emYvTDFZNVdNNUdiVjEwaFJTbHJFVmpPS2wvUTg2dzE2aEZ0eTNVR2x3d0xS?=
 =?utf-8?B?VlNoaVorc2hIKzN2QlR1Wng4VzI4dzdGWVU3QUN4Uzdxb20zc2d4RHNRUGdJ?=
 =?utf-8?B?RGZNaEE3SitSSTJFM29GTGtCNk1SQ3JtTk0ranlpL3VBZ1NHQUduMzQ5OEhQ?=
 =?utf-8?B?QUg3a0IvRDlpSkJna3NxRXJFeEJ0R1p6MG9vcXhrUS9pRXlRSExwaE1iTHox?=
 =?utf-8?B?V2pqSUFwbVVJbW5KT3AvUThvbkg5RnY1OWdaWGJwQkhOeTVUOUlVU2VzYm9v?=
 =?utf-8?B?YndJajd3TGw2Wjk0ZExDTEo1Q01lcmd6MWFWUkY4aFRJNmFEQkJMZ2pQQnVR?=
 =?utf-8?B?ajNiSEhOODJrTDhYcWJSZ2Z1R1cxMEhObmhSWmhMNDE5MkR0akhvOGI1b0RT?=
 =?utf-8?B?bWgrNysrMHFIVG9jVGEyVlZlM1B5NW1EOXA0WWpHVmZ0Q2o0ZUNmZHVwQkJE?=
 =?utf-8?B?V0hpakJndFpqblBCeHRpS2d4azcrRUQwUE5EM2hXVXFmdFREYUx1RUk2WHhH?=
 =?utf-8?B?eUxGbitYNExvaHdTYWhjbTZGVlMzamVjWFNaQnlRRXRrVFh0SHE5TTlIMEJC?=
 =?utf-8?B?Zkh2MkR1OVZERzE3L2ZGcXJTZERLamV0VFQ3VW1VeWhLQkVFdlBCd29wV2tX?=
 =?utf-8?B?bTBuRW9ESllNcERSQnpIWjI3UUxsMStwS0VEajBZS2tldmNCYjJZRkFEN0JV?=
 =?utf-8?B?SkRYMldWc09BZWFrMThhSEM5eHh1N29aZXBmcGRQNVh1dDh1Wko3RUNEM0lp?=
 =?utf-8?B?d1p0dnc3dmRDZ1BXUms2NWpBR2E1MG8vTjA2VldRZTNnUkdWTHlHMk9ETlpN?=
 =?utf-8?B?ZkVQWlFSdDNRK3J5NWZTRUdKdXBFV3hnSVByOW55YlRHY3hrM1F2dW5xWHc2?=
 =?utf-8?B?OFVVZ3M5eDBRTkFXbDB2aGw2c3NqaVZMbHZSZkRjQVRteDh3Q3NnSFl4em84?=
 =?utf-8?B?TG5UYTZWcmxQRlBwemJtTHcrSCtubElNRFNXQ3RlU1R3dVVHblh0akUxZU5J?=
 =?utf-8?B?SVNvVVQ3YzZoN29mVnFOc3BzOVIwWmlwUTYwd0FmUFhreHFiOW5yWUd4ek11?=
 =?utf-8?B?Z1F3K3Q3dit0R2FQejhWNkZiczBJN1F6S09JV2doL3NxQnlRMmY5cURNTkNv?=
 =?utf-8?B?NWI4Y2QzeWdXb1hIamtiSWRWNUFleE5SQytYNTEzaUdmMkppTGpqTkQ5UW0r?=
 =?utf-8?B?T3lKN285dkJZRFR0eGJ6em40U2VmMXA0MUU2MlI2eis4d1dNbWhVSUVsNEVD?=
 =?utf-8?B?MXNzb2JTZWo4d1FjN0xGS0wxcHpYdFMwaEVSUlRXN2VOQ3F6MEJKcFBNeDBi?=
 =?utf-8?B?MHZrZ3hpb3VOczZjb3prUVZuNzV6MXlNczJZN096QmZrTkh6TWRlU3l0bFNx?=
 =?utf-8?B?YXRjU1Q0cmI4WjRHSzFHYWcxOEJyZE54UUdBbkFjcm11RStnYzdMQi9FOSs0?=
 =?utf-8?B?RjI4R2ZYcDMzdFdGc2lXbkdiNU13OWRmRVUwSjV3T0pyazhKN0g2bXd3T1Zq?=
 =?utf-8?B?R0x6L1lZVHJ4SkZCRWQzcTJKV3N4a0xrN0tSM21VcGJ2NjI2QUJWUVVBOE1a?=
 =?utf-8?B?dDJTWERaVThiSmEvY0dtVDFWOHJhY2txcFYxNkZhSXRUNHE2bm1YMGgrcHNO?=
 =?utf-8?B?Wm5Bd3pyNXpCT2pQbVpqMERnallkakJ4NHZKSDBIVUl0d01YVUVkUzlrbWhH?=
 =?utf-8?B?MXQwUjdpZVVUcUZ3NWozd2ROU0NDQmRhVGlDdW8zaWhTU3RuN2lHVmkxbDVJ?=
 =?utf-8?B?dC93RmZuYURXaEdvSHZDNzJYdTBUT0lPcDRIU0d2Lzc5Wno5QjVWK0pmZDlW?=
 =?utf-8?B?cmNGc3U3T3hMRFJkcEs3MmRkT09RVEh4NHJ1bUxQNWpYcG9KNklWME9qVzRj?=
 =?utf-8?B?YkFibjdUV2wvU1N6NE45UXdHUFZJMW52dHFLZ1RweGQzbXAyR1Vtc0tOeG90?=
 =?utf-8?B?alJhVkRSZVdlRkdpQm5qakE4VEdHelhNais2SGF1bjdFWjNSOE41MFhSY01M?=
 =?utf-8?Q?iYlAv3K2kGDE12v8lEvt0kc=3D?=
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0SPRMB0067.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 302393a8-47a7-4177-338a-08ddc9f881a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 14:52:12.0408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AuOGim5QZEBJUDhFEvj/KuHR7oA670k6cDNM1yM5/JVprltTfqN7R1BfZGM8anMd3J/eD9BWlkNLvfVnKIdtWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4045
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDEyNiBTYWx0ZWRfX3yRvl4Muwzm7
 SDXBbIWXoOn65wDhB0/e8sM9vgLA/GQdp77ANjG7XHtaeVgawhUxu2yT4a71WXYb6uE3CIGGpCO
 COmpzOsxTEP68uGch3cibFrbJa4L+OwSLVaSjgM7qNdZulE1y+vHdOALkWtQvUPawfE7sIrASko
 33MfzbrwFa6+WroLMlVgSQQSZ3fv6hyn+AkDYatMNnSI6UOJFd04KMXD1kpC/P62DzoyLC9QPx5
 j3AdRQfF461FO4DDrgz8MlueRkYBwD8c5OJvhVBmJlMN1OENoVFNk5lqPdVdsybtUq6d8yyf/j+
 W9KzYJjLkVtOSne2gdVKKMJ8j2xZtcaMd9Rb98Sp0ujgdCDUBXItp/Sg512O/Ott4FsiDycun0d
 3HDCftzec7uIYlorye2LruJU7J8bGDX07heEgdPb+y80wR61X4JNh/H1Z9Pm5gGX8SnogisG
X-Proofpoint-ORIG-GUID: vTFvG7HJHkhmdf7nHWMvAJu7xwL3X7GE
X-Proofpoint-GUID: vTFvG7HJHkhmdf7nHWMvAJu7xwL3X7GE
X-Authority-Analysis: v=2.4 cv=TtbmhCXh c=1 sm=1 tr=0 ts=6880f71f cx=c_pps
 a=UKvgJB4ZXemRNA6BSV974A==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=VarWvt3nGuvZ4FJz:21 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10
 a=RpNjiQI2AAAA:8 a=9jRdOu3wAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=SEc3moZ4AAAA:8 a=37rDS-QxAAAA:8 a=QyXUC8HyAAAA:8
 a=x0ISKeatAAAA:8 a=xRsFOnqEV2pLTH5UVA8A:9 a=QEXdDO2ut3YA:10
 a=ZE6KLimJVUuLrTuGpvhn:22 a=5oRCH6oROnRZc2VpWJZ3:22 a=k1Nq6YrhK2t884LQW06G:22
 a=4j1IgUSwLGJQIMof3IM5:22
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE:  [PATCH] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=2
 engine=8.19.0-2505280000 definitions=main-2507230126
X-Rspamd-Queue-Id: B73DC1A000F
X-Stat-Signature: 4r914mgprybpxgyk4t3yqrhz8jjqjedp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753282336-405760
X-HE-Meta: U2FsdGVkX1/jCXx/KLH/0zGHpQmTWtrClktZ3nUpoozKR6YeJEFxzgfGHQ4v7WODZTbfZXSx20Mh24cIV30k1FCDoXWmA2XbY6S0oZnWGX+F6W6lZhRcDSg1+ONU0AuqGWvzStORe0L7U6AXpIyDM1a2WS79YYsvC+Z+xaG0ke/hpXyPpYzEnBhq2uIkZ7uewYtxvLcS8WiX9iqjANoGXrvCS1X0/9ID2ORmZIKSZsPLlqAf8VyZLbdUtWHgP73bVj4rarBL5+ku1jkf1PVeDpL4HZTeWmNVs+JE8vAkyUUM281eYZqelrbi6oHxNmyhGrNNa/Qf8JLlaB2I16feURJKPPgINbgccBLpp1rmdtLXl1wsDCjnkH26qH93gHRm97SyoVbGtD5Wlhpzrrw8shwEeJMssyrHgGns1xTbWbiki3+Fhy4TVjpkrhyeo4hGEKd0F+Q+ItXWNO4lE/wI16VDfdVkS1hmvTSfrk2YuRJAnkPQ1DxAkkLBhD5kiptenPRzzRPzUx+NbxTfUc8t3gbSgJtl5ywyrmpH0CdAoOKMCFERfSN5hlxXkRuaunCogx9OQ9AEJk+q9t+hGeyn3fRO0rhKDz9sTj7JIDjlOwmU/YEyEE5FvAkVKAV1qFwptUUV9Dhjgkd+Be64F+fMvpTa0R0CiAO5VbJMT8CS5YWpyorFDnJBBIu8G3dtL7ePmYJ3BopDPrA0RjEVESTjJMJPjArtE5KbLgWJkM9A4x/k6j9WhhaV21AOQa9UeB9NjUht50kWOfdgyxyJZzECo7xMumuYSFuLXfjxbXMGgYDUe7YBL+Sfaju3hxcT2c4NhWgKe7XnbPtvmqHHyFCqa5kABUtZKue7cyRY3WvcKfRIhmOVY07X6lL9Tq9bBUC18FJqNsrKyvVFoxaPh2588bF7TxfUzOfn2Onzfd2b5eQWWPpPY8S9b9VwXqoPWSu3UF/NPJrN5r93rOd8o52
 84wVOlMe
 9Vk+WB11xDcyGSJ7fMn9hqcFkgSbfSb+xL1Wb91lMDzLN6F8KMCCr48JieLrrWe8tQgHlTqfFM3V4ULZH5c+kkk0cB/kgq8d08he6opMn9g2l+B9VMLa1FHXTW7zJR+bsEzLSmb63f6R6g2ddXvAJbq9CMqp1ldUkYxA02pLLCv1gL3XavT+e5BQnlTSpdWdD4Le9thC/yKGVUy7VH6FYXqJ8ykpowzg1k3/aWj6xlw4A0oHhW2i5n4LaAEe4jmKWpQpA+hoXIMsB5LkHyKXp67u2wY4aDqkTzXuUUiisHi1Xt1YK5WCDddJjQnXC5mv47g8g4LLw6HhshJt39+GlnVm80ylDexIGcjkMTdTiH/v0G//0U3lzYRX9nI7mAAocZ1RaNPSak8TFO3LiP4whuEMvNvIEcqnqPmR39L02733UCOQE7LDcqBJetMsd7CEHicKByubXmAeMMzXRrean4juKC3fi2LyTiS9YD5gZGHo5vfaDUgttYbUDZXdXSUy2FTTj5t4Xyu5irh85zW8y2nMMKzq6YsJLxhSqBKf/q9NSKweMsdtbb2HEVkYVrU2qkqySe1GJewzjRNpI8bphq0aPgKVLQYmATMNIuCcKkTTApTBp7Tci1ztaYFDjfwRvVkJ75HIvGOYfYZnfZ2wKAbPutRlUrRIEKhI9SoGuBFcyn9zeqQF+bmVmzWOzljlrDttGQJ+1zhXEe5FwF0oYs1DAFz7J8WSPsGl7KZaiqf3N6NqUkprY0/hVco+PhB56wq1ZdmxGmDnFi7TibAFL4uSK67FuCbAgk7DrzZtOPBK9mglPrB06CQLk8ku3k+BwXej5N4n+fIbuqMynaBg/ZXG1iIzQeh5hb4Wdbvpwkk3ZmOXcZSywuSd3dakm2uoXGwxrmKX8m2987fCyp9pAjV1U321IOzmCc5Mv+wbpCqu6wa4dF1WH85SgGxJqPhUkg1IuEuWISpuMRxRQDHX+eOBh5KQT
 cebwZ25n
 CrF8qxP0QPvS+ddrdT/UrARlXhGKX1QLhF7Je5cyUjrXoD6FFRLIUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Pedro Falcato <pfalcato@suse.de>
> Sent: Wednesday, 23 July 2025 12:41
> To: Jason Gunthorpe <jgg@ziepe.ca>; Bernard Metzler <BMT@zurich.ibm.com>;
> Leon Romanovsky <leon@kernel.org>; Vlastimil Babka <vbabka@suse.cz>
> Cc: Jakub Kicinski <kuba@kernel.org>; David Howells <dhowells@redhat.com>;
> Tom Talpey <tom@talpey.com>; linux-rdma@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-mm@kvack.org; Pedro Falcato
> <pfalcato@suse.de>; stable@vger.kernel.org; kernel test robot
> <oliver.sang@intel.com>
> Subject: [EXTERNAL] [PATCH] RDMA/siw: Fix the sendmsg byte count in
> siw_tcp_sendpages
>=20
> Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
> we have been doing this:
>=20
> static int siw_tcp_sendpages(struct socket *s, struct page **page, int
> offset,
>                              size_t size)
> [...]
>         /* Calculate the number of bytes we need to push, for this page
>          * specifically */
>         size_t bytes =3D min_t(size_t, PAGE_SIZE - offset, size);
>         /* If we can't splice it, then copy it in, as normal */
>         if (!sendpage_ok(page[i]))
>                 msg.msg_flags &=3D ~MSG_SPLICE_PAGES;
>         /* Set the bvec pointing to the page, with len $bytes */
>         bvec_set_page(&bvec, page[i], bytes, offset);
>         /* Set the iter to $size, aka the size of the whole sendpages (!!=
!)
> */
>         iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> try_page_again:
>         lock_sock(sk);
>         /* Sendmsg with $size size (!!!) */
>         rv =3D tcp_sendmsg_locked(sk, &msg, size);
>=20
> This means we've been sending oversized iov_iters and tcp_sendmsg calls
> for a while. This has a been a benign bug because sendpage_ok() always
> returned true. With the recent slab allocator changes being slowly
> introduced into next (that disallow sendpage on large kmalloc
> allocations), we have recently hit out-of-bounds crashes, due to slight
> differences in iov_iter behavior between the MSG_SPLICE_PAGES and
> "regular" copy paths:
>=20
> (MSG_SPLICE_PAGES)
> skb_splice_from_iter
>   iov_iter_extract_pages
>     iov_iter_extract_bvec_pages
>       uses i->nr_segs to correctly stop in its tracks before OoB'ing
> everywhere
>   skb_splice_from_iter gets a "short" read
>=20
> (!MSG_SPLICE_PAGES)
> skb_copy_to_page_nocache copy=3Diov_iter_count
>  [...]
>    copy_from_iter
>         /* this doesn't help */
>         if (unlikely(iter->count < len))
>                 len =3D iter->count;
>           iterate_bvec
>             ... and we run off the bvecs
>=20
> Fix this by properly setting the iov_iter's byte count, plus sending the
> correct byte count to tcp_sendmsg_locked.
>=20
> Cc: stable@vger.kernel.org
> Fixes: c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https%=20
> 3A__lore.kernel.org_oe-2Dlkp_202507220801.50a7210-2Dlkp-
> 40intel.com&d=3DDwIDAg&c=3DBSDicqBQBDjDI9RkVyTcHQ&r=3D4ynb4Sj_4MUcZXbhvov=
E4tYSbqx
> yOwdSiLedP4yO55g&m=3D8FIDji_gvHEZEUL08IM8h6Slg9f_hp4n8OxkdR_OWLnZ9CkPknHC=
zHVC
> BYkCKt_q&s=3DIP0c71OgDL-cEe5hFduy0qNhy5WICEkTBTQLrVicotc&e=3D
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  drivers/infiniband/sw/siw/siw_qp_tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c
> b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index 3a08f57d2211..9576a2b766c4 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -340,11 +340,11 @@ static int siw_tcp_sendpages(struct socket *s, stru=
ct
> page **page, int offset,
>  		if (!sendpage_ok(page[i]))
>  			msg.msg_flags &=3D ~MSG_SPLICE_PAGES;
>  		bvec_set_page(&bvec, page[i], bytes, offset);
> -		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
>=20
>  try_page_again:
>  		lock_sock(sk);
> -		rv =3D tcp_sendmsg_locked(sk, &msg, size);
> +		rv =3D tcp_sendmsg_locked(sk, &msg, bytes);
>  		release_sock(sk);
>=20

Pedro, many thanks for catching this! I completely
missed it during my too sloppy review of that patch.
It's a serious bug which must be fixed asap.
BUT, looking closer, I do not see the offset being taken
into account when retrying a current segment. So,
resend attempts seem to send old data which are already
out. Shouldn't the try_page_again: label be above
bvec_set_page()??

Thanks!
Bernard.



>  		if (rv > 0) {
> --
> 2.50.1


