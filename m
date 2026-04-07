Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AEFFF5136
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 20:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432F46B0088; Tue,  7 Apr 2026 16:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4876B0089; Tue,  7 Apr 2026 16:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB9A6B008A; Tue,  7 Apr 2026 16:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 189C56B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:09:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 517D65B9C4
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:09:38 +0000 (UTC)
X-FDA: 84632850036.25.6F61B74
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8745180006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:09:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="lOcZCTV/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="SUAA5a/C";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of joseph.salisbury@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=joseph.salisbury@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775592574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Nr59LrE8x3EgL6B7A9E+zTsBrMUaqhqUWIbktxE14yQ=;
	b=G/Wzbbz1XlTrq3BmxtIo3fM7o0FIUAeqyZSFMrIX2Pg0XJExtGBzcxrGxdRFcpFIKse24+
	Qnd2QG5HG0gX6vAjFW5kFzx50u6R3UTcfFBHIqfqQWe+zjgD4Bh/QrhA0WZ+uwEW0YotI2
	5yD827VuQazhDUhGkggqC8hfeFIUpdo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775592574; a=rsa-sha256;
	cv=pass;
	b=gzXd55IZDNeEB4aqt45JnQptjYyPAJNDOu7zllpyzRvNjBdGAx/8Uhf2gEefeHdFqBn+Bk
	+6Tx2Af0ycc40KBFofQrZv/yuMEq5aEgm+Pl2XLmrREbI7zqPGM7LcgTLdGBK0rQB71nK5
	K8DCdvH9zSX3EusibvADHu2Zb7J8b80=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="lOcZCTV/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="SUAA5a/C";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of joseph.salisbury@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=joseph.salisbury@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637FL9ek987852;
	Tue, 7 Apr 2026 20:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Nr59LrE8x3EgL6B7
	A9E+zTsBrMUaqhqUWIbktxE14yQ=; b=lOcZCTV/VqPQYsQfqb6l67jCbIhjGDsD
	D7aKq08niE9W+TW2QxIwxjniUeIvfqJjf6IkpTVQXqqY5iQVJNzt2J6F1Y6zwxZ9
	BWYgrJm3EmTVoqNHbad4WNlQb5wZmXyZoTLLgH7U0vFYMUnCJ1aKQpMSoPal946f
	yxDo91eXTddCTPSFhnqwrDUNQ3yfXlRb5wmrfzFlcl5kiCEAwnZd8clceUrw1u9/
	Q+LoR3ylRAIwj9+NV7TLVZfqNPwuPmq2ewC0HVOKpodDCqs40ctUN5CsG+5pVJRh
	D6Hm1g9qk80MsdnYDDEBjqASN9On6p81eR4RFF4jR14C+E/mibvvpg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqea5dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Apr 2026 20:09:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 637JAJcV029159;
	Tue, 7 Apr 2026 20:09:25 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012005.outbound.protection.outlook.com [40.93.195.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmq4b8tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Apr 2026 20:09:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FgDqFpI3i0plqPBlJgkp/lb24LlbGWYGwmYzJq05jLt4AL0xNYJ/ZafB/CBoeS99UgfizoDQrUN5YsOBJXQRfS3R1rD9F5ipdOWZIzEwaVEGBla9gh86Vu2xinXVzTIFOVW0k2JM25c2h+cmZ27c9hvpQ/QV4WowUln+GlDHdJ9Zuzh4sPanCAfnx4FVEoGS2RWiFCsyt09wSzqcVQsWBuxstORwug0na6zxqufnQaXHvX5y+qL77U4/4kHBTTyNCQ4aidMO2Y61Zt06G86E8GSLwh7UDmTU+6Jv1XGXidcS+wYHKQ+ca4OckKbhLD9ghptU3rZQ0rV8PfVuzDcBcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nr59LrE8x3EgL6B7A9E+zTsBrMUaqhqUWIbktxE14yQ=;
 b=amtx4GN7AAnJuXFnySewLcjlV9jTabRHZ+YJcq3vBLIOttQYmGDv1Nr/3rytYlZJTO69b3BBC8NEIk8tthyfEJI7UuSx/PDvLUkZ2HMfETkclH5gL/pot3W+eimn3CeCs/FTRmewLRlC5T8Z1JebvJdjMoSgN7+DTeSAnXOHV7uss5sZO3gP/VtObWGWburYigEivkRfhRRG7wLzarGcScHTUu4GUOBSUZ5g9IloZUXDiXoDzDDiNis/cqXVKmEySAAQNhXJTwKvaSCR938WSMVp0qdHuSCDu3VuYlmtV2IHOmFlctYeMWgdip48dsXcFDhYxN8wqTEz7Nq0U5xBXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nr59LrE8x3EgL6B7A9E+zTsBrMUaqhqUWIbktxE14yQ=;
 b=SUAA5a/CJLPoUaJHLZsfN5KpY5+0ggj5wFrlC7x4VjW9DVtyIAcfWdeAkF115gtW2aivJoFB/G8HbJcM8D3AHrbq/rtipzDTDT9cH/kELDPX+83lyIQSE++6oHhX1Gs/bcC7N35uEwgSA72GmeVr73kVb89M/8a3v/zbIGHEtPY=
Received: from CH0PR10MB5131.namprd10.prod.outlook.com (2603:10b6:610:c6::24)
 by MN6PR10MB8022.namprd10.prod.outlook.com (2603:10b6:208:4f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.38; Tue, 7 Apr
 2026 20:09:22 +0000
Received: from CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307]) by CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307%6]) with mapi id 15.20.9769.014; Tue, 7 Apr 2026
 20:09:22 +0000
Message-ID: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
Date: Tue, 7 Apr 2026 16:09:20 -0400
User-Agent: Mozilla Thunderbird
Content-Language: en-US, en-AG
From: Joseph Salisbury <joseph.salisbury@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
        Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] mm: stress-ng --mremap triggers severe lruvec lock contention
 in populate/unmap paths
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0050.namprd18.prod.outlook.com
 (2603:10b6:610:55::30) To CH0PR10MB5131.namprd10.prod.outlook.com
 (2603:10b6:610:c6::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5131:EE_|MN6PR10MB8022:EE_
X-MS-Office365-Filtering-Correlation-Id: cf5f41aa-194b-45aa-857e-08de94e18eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RHac6dRYdQskM9lIOpyIyIMw4QA9pcpsWtRcciil2LZOEfktS90UEipUIrpx3FrskNOuRYKRVf0txXkShZZxu+nvO427RbjKBEl29oiHefKUOi9uVN2QydoQnUu5jjCcv9Mu6oOzjVR+RnBLi6rikgJykNcCen3Nvd1P+NO/guIsMVFqKst9xHPMyUFEZo9GZTflyaoGWAFSotpLLLB1mKuBaN+C20HdPRVLX0W2TSFeNNhDtVQ+jFG6Wi3BdFyQOrzVxqcraFM/sJmpuy2f8Z5DZhoWzaANh39NdiWVX4NP6Y5oIUC6W0YKwAi+US+ecB7C6Q2PZYPF2lGPvEy1Cxa9wTh7I2mH34BGUsD8hc/TSo6fEwsohU/IOP3mcnHfCf3SIH29lY7ELHQZJW6EHjpphKU1XWNUFA5IOJnQnsFuqRSmYiI82eDUcs2c8bEfza67oYG0GUr6yKOX9LjZFM0EJT4M1fko3rIIiYKLEHL6pZb7EjU8dxwzs2GdW7z/0MKNygAlQjuzIN1rv2EcFBjjFg1jg95NL8CLfHkK3HQPhtiIKv+JiWWHWjaovNpDzcxw3X6003gSfGY6qswUnOw1JEDqkITDSxZb9aTFk1x4RkwYm7po1AOqTIyxWOAA0Kc41X8jJrQmIwXuJYOPVExPK4H0wvcF5iu5NcVR50Xsr9swb0SGXc2L19qWpOIG61sVPdpt1rVJtB31jpW99B6wCY5ISlZgZ9+A/exdoZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5131.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2tidndQUDZNY0dVRGRSVllrNTRPKzl4NWJwS1ppMUU2bGRYaE9vSGdvNERB?=
 =?utf-8?B?ZTNmaHRMb2tscTVoUTlDYmZkR01HS0lIb3BWa0thb1RjNVEwQm5oOXI3YVli?=
 =?utf-8?B?QU9oYUhCOXVkMEh0bjJsNTVoUHNpd2RKQnBUTk5qRERZaG5hR3h1ZE1KQjZD?=
 =?utf-8?B?NkVaakZxT2pHSFdBckt2Tkljc01yMlh3bjlnOWJXQWtXdE51Rkh2NE55dXA5?=
 =?utf-8?B?VW1aU09yM1IrMDI2dHNoU0RkcVRIUTY5OEtSTFlYRnZPTEtUbVYwNUgyblpX?=
 =?utf-8?B?dDdsbmhJU25lc3dLaU85S2pkWW03cSt3OWVOY3FkbkRJa2pFOHg0VFQrMEFD?=
 =?utf-8?B?ZmE4MGFGbTUzU2J5dzhES1p4ZVpDKzkvM3JTdkE3R2hOU1VoQ0l2cTFlRjZB?=
 =?utf-8?B?ZDZwK1Q3c1FFMmd5YmJmcGZCcWhWNXZBd25VS2l5T0RIS0cycXRBQU10TTVE?=
 =?utf-8?B?OUs4RDVxeU92NmRueFFlNkdtb3lwK0V4M2tJRGpCbXlVRDgwQjA4eHI1Y0JC?=
 =?utf-8?B?QlYycldXRHdMWWFKdS9lNnhQUThUWFVhV3MzTXN1a3Z1dE13Q2RQM0FnL0pN?=
 =?utf-8?B?RjdNb1IzMUpBYUJPbTBVZlllRzFtTU1US21IVUg0UjhWU0tkaWlITXNEMjZk?=
 =?utf-8?B?cUF1M0hmYkhCSDEvK1NOait6dDhIRjQyM09uaVpyTzhOSjBjdXJIZis3Z1JT?=
 =?utf-8?B?dTJrWHgyNzZ0NlUrVFdLZXRJRE1laUVXUkRGUGhoT3dnU3BONFBFTW81aThQ?=
 =?utf-8?B?aVRDL1YwNThSMDhiTUxUck1SLy9uay9jVUZRZmpKUmNZaWJSa1Qzclo5eXRm?=
 =?utf-8?B?cEhuNThoSmdqQ0p5bHowZC9UOWxkdGt0T0dHcHE1M1cxdS84alhsbGhkaXA2?=
 =?utf-8?B?M0kxaWhJTjZheldWV3VGNTRXSlNBdGw1alBtZW00SUFGRzZieWhrWE9ia2U0?=
 =?utf-8?B?S2ZWMGd1WGxpTEZGZk0zdXdCRHpuSUEwcVpKSkpycFc1YXdWbkR4M3krWlNH?=
 =?utf-8?B?VmRRbFNVTXVuUWw5dCtxSHI3QXpCdVNjM2k4b2UzaFo4cWdwYnhhc2lKbEE2?=
 =?utf-8?B?a3JOSEpQOVlhSHcxZ3N0b2JSeXdJdlZYT3NHQmdkVjB5aXlybFJ3ZFNEeVJu?=
 =?utf-8?B?bWlGdUMxNG41d0hONTNJRllvMit1N0FoSWZwdWxlcHZBVXBGTE50bG9GMU8z?=
 =?utf-8?B?OFIrU2g0MHg5Rlk2U0FBWXo4bE85cUJoNWtrVVFQSGpMVlYrUVRBZXpxTGQ3?=
 =?utf-8?B?RUQ2MEU4YXZIY0M3RktSQVRjTW80c2JnT3NnOEE2M25XTndYalhJRTIvTHA5?=
 =?utf-8?B?UHdrV1hrWldBQXJCSGtHYU1vOTQybTYyRUhxSWNEOHVsbzRFSmU5Q2RycTVw?=
 =?utf-8?B?NWtiOU5VVWp1QmpEVWIzeVpzWmRBRlI5Ylo1ZG1qa09yUHJtb01YRHZTNmJ1?=
 =?utf-8?B?OE8yMVduRklzbTZHR045YlJrTmV2QWFPOEt0MnJrNmh4L2ZXbW5QMDRyYjk4?=
 =?utf-8?B?T1ZFb1o2cmZrQmNLS01zUWo2NWNXb2pQU29MdU9Va2xJRFlZY0IvUzZZK25M?=
 =?utf-8?B?dFRkdHBPNkNNVm5wenVjalB1MnJRajdiNTBMQXRodlRaL0N1RG14YjFndnZn?=
 =?utf-8?B?NTBIbHFXdlJta0UveFR1S3ZINmk4YThkRVVzWjdxNmNPZmFLVDE2UWlvQU0y?=
 =?utf-8?B?UWY2UHlaY1MxSXFrUnF2eTlzZTBuay92QVVxYlZ4aUswZHY3NStYSGxZbVdT?=
 =?utf-8?B?ZGlyM1g4dGYzcWtDTW5VcDczMitxQ3k1aDFYQjJHeG1aMWlnMDZ4elRqZVU4?=
 =?utf-8?B?VTNhWnhsTmFEY1ZHSWdJSndHajhUMkk1OWhRNlNjcWJLV2E4MXpuZ0I1OVNl?=
 =?utf-8?B?TlRER3dHalVWZStYbWlzVG5SUHN4RlRNNTMxQnQzV0xSb2NzZ1RwbEdnazJa?=
 =?utf-8?B?NnAzazgwbXo3dWx5d0x6U0hzR1ppUGZlbTZoWk5uUHM3Um93c1drcEtFbGMw?=
 =?utf-8?B?S01FclRoS1AvTXNrV0loMC83Ui9vWkQ3c1RLTmQwTUNlZUhwKzhHcmdvSmhQ?=
 =?utf-8?B?eXBOaEJsdVZNOUZWMURkQUxvK2VCdU5sTkc1bXpHdUpZMjZucjA3SFJTdTVt?=
 =?utf-8?B?NmExNHdJb2k4cnlwWnFGTVNobE5mdHlTclIrcmFjaVEzRkNGZUQ5VDU3QkUz?=
 =?utf-8?B?OElKZkNqbnZwRS9FcGxwU2M3c0hZalorOGdnb2t6NEFFalZRSkpxMWtUOStu?=
 =?utf-8?B?WE10V3Z3SzJpZmUxK2lTZVMyUjNXOE05S0l6cHhQU1BRVXFuQ0JGVE9RTTI0?=
 =?utf-8?B?eTVveHllazRyTzAydlBmSWdYcnNYK0xUK3gwV2NaUFp4NkRycGN5cXpaK1c2?=
 =?utf-8?Q?DIOuyCgi0sOE0Gnk=3D?=
X-Exchange-RoutingPolicyChecked:
	Hq6yRYb5pZlreCaP14aU/LxKn+0gpe4FM78m+e2WC9hEpMO1v1giSPVKVe8+CtB9d+3VDAil14TOfGhc3vmYawijKnHg/86Gjoiz98BFn0NnPjqS4/X1cWpIfU7QFN1zjqOx5rFz3Js6j5eosF8AKBG35/wMrn/Jv20iJ9+nQ5h2SrLw51z/UQGIVh69wBDi4IhWZUOoPJtwaOYRvPb4BwjwV6Pquiw2P9DIEk+uPPNuHbEiVyIc99pSF7W7SwvBOK3ZojkctpgQP7/en/NAHav+SWXTMykltTF3LmRqjqpHiCpPonZu/4KrLGn2HJ3B6wIotcWT610izLCTba7+ig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nwYzR5Ylt66shaEztL6iRt65Lgi5gFDuQ81aYRJejUtFxq0zcwk3HUkK/5fR9HjxxqWcOcif53s7BOi5TiaFxjlGGeT7brsm564s9GxO7kJ7jQODJ4gOZt+SRCVL/NcjFdt6wTyEkIpWorpjZ+0lgAgOxXv1wxjT8bR7SAs9hEmCK5ZYHX9z8FI3LCeHv7TybxZ2Gv7w/0sK0UpjVr7uXNI1l19MLkD7DmK+R3sotoGljbOjx40+ZB5vIQ5UyBcu1EFy2sFMaeBRZAo7SV/cviFqz2PjsG4xZJ3X3lGnPKeB5QWXm2qEhL8c9dzvSCnfneZ4xCdmMeML8fsblI9JDC841m4+UcwuRKwYU2h7STDvqb40+UcuMfbzDDQw964uv9ANA5scI4LfmH+iLxlFNKJ+ga3iKAczicDnFmuan2GkpvPQJedNY0VXzH8NIJqecuci++AxktfEKkz69zW7UFjJvPJ7Ckv8Ps0AKW7YunAinWU5nrxoZG5hBJWkHJxno5Tu2hUK2MVm/oZSL4Z31jQ6A8FIPX5YKrbN9HgN3iZYWvIAWILsdBR2mikL0K7pZgJeykGtZfh8b+fpHULstlfq7v7uiddj1t/FVerSjxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5f41aa-194b-45aa-857e-08de94e18eeb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5131.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 20:09:22.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ESnFpU83f6a/77blqWgief9yFS7Z/VTwoQMHQty6YUBTNsaM7dmxASSJGB+BYP7zRuzLTxQIMcTakAFx8tM59ViFZ5P5ZSXjOl5GvW0eVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8022
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_04,2026-04-07_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604070183
X-Authority-Analysis: v=2.4 cv=MtJiLWae c=1 sm=1 tr=0 ts=69d56476 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=sdOadaoQDBHrcnOU6LUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: L-RNzz9yGofeXp71FrfUYyvJh0hQRDUQ
X-Proofpoint-ORIG-GUID: L-RNzz9yGofeXp71FrfUYyvJh0hQRDUQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDE4MyBTYWx0ZWRfX5gYAplyXjqMm
 YQNKYq9iegeBsLYLq/3kUjBi153TKj/RH4EBpJPkJDc4TPJC6CeTH7RHn8LmaRITfG8PRXpyA1U
 qreQcJMCcyQU95zQeRP4J0aovNjBsc+hfpjr9v1WzA8v9H5cOIUDMI/v1pMzWPa8cM8XQMo6Xqu
 ur/Y130SXjJElEnDlccQ5IudvOFfBY1osFrimZCPn/TKGfSBc4TjB7S5aDImSHb/eJrtDiDlU+u
 O+Qw45RlJoSY2YcOYucEvnOaPoFA0T6iB/dCR+zZ3cfNBMSu04qhiGioYd4wbQ20pv39etsMb6F
 bChT8M7RP8XmsBuvPSuwSQJnye2BYin7ej2+Gt126UnuIyYlBW8LKPlKBcCtV7YSLfyAtaPDenY
 OiVuACSNaMkankRlfseoGVxg0aGOWmgfnlymqWgukYYP+F4hax8X0H90TBl+zLqrFKfIcFZGscQ
 etcJlSPJc1S4ceGb7cw==
X-Rspamd-Queue-Id: B8745180006
X-Stat-Signature: 6h3szktndioaqy8ee9czrs7b3kffr8nr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775592574-113377
X-HE-Meta: U2FsdGVkX191NQYjYUS8YwkjzllVi2s0/XMd5V8ykbc1TLwPUp/V+kF6eFiKOhBUKGjhkEEZiP6stF074yaYfd2j4Dv60GBvZdcPry2sgg0eKVWxMxQSOF0OqenoO0GueVWHPrl8vmXf0sMvUqb3zsDZYUUvN+jtQI/t29OgflEBOxD/K22wkOzW/y0PNmQ2xV/dtRa9NRCTmW04K9XET52pBiyJrSr+Gas5BSf2RQbpDQaBudOkIR/j0yjb95U21mgv3yBWv2FB/WZDW6Fh5y2eidvPCZBXc3bqxbVoOCYNrACpYNybToCM7Fb+2T1o+jDqFcvJ33NKxJePJEE5ssDsijAwsfQ7XenQU94/byo1apuZ3H+RJUr29wH60BmFLV9cdVLCtQypdh0dRZjdVjkeRX9whukO3U9oVtwnr+MRuZ5nHhoaXUNAcN9lH1sHLiI9+2R6InvrNdspIpaFts4A50BvP38aHcl0a5eeG03JAjSGUbJps/xi+A/9TDNTWEiZ8m67hLwrB0WmI8Ilc7x/dIO1yfd458lJky5GUDqcEjwsMLzL4kaRVKiM5KLYFnPpCFbiVI1AWQkbUS3Worw2xVf9DXLRT+1/7VH053ZvZ51jZpDQD+Liyb0fNOcAVRL9RDqblhpDocL5c6ptNtAyCyTz+zRMiEMkZjteoBGSFiSLfv3kwtCmWZFj8BnaXnMLP8QkTUcFFhFoFYZOhjO+te2UL/Va6hZORo1aqE5PbmfxmqCEiBax8bPn0WGF4CaemrzeGhrhSCNuNaZ1UtF0TupXPi8K3FaEw3QPD1CJoHMadI2tKaQPyGt9loUSJHRd/7JjQc5WhQUAW1aSF2fnJQcTcsOccQSfIcpJFPU+ZrfMJHXxaEkzKoNd4Z5bnfXHA7lN0EtET4YKbtTuBAGgCl2bpDh9M4MMcwfa5sWqwkaYfezobx/BZ1x6pXTClPunaZ+JzMbLQDYA8Vr
 o5KxxsLe
 JEEOwZN71gnPFpW3KLjMhmU9Y74u6oPHyUECOGtdFtT8rcJJ7t8wL+sMPBbKFUdTd6JMcIgvzN6BALXbdKsJmi6uXRJTcPDWQFPLuiuFJPmqCYHqclkVmrHa9x2KgBli8Zhrg0/ulxBlOx52/yInkoByjTFT8GyetEQaqtLj0JS6sN956UdthgLQw/lKrniDP9D485ORV95STB6s/9DCpBeaDoYT50887qyshJORBTGqC6uCVjBog3+E1wpkQ2rIGut0xLoOIRtD2Gz47IfFzr2/kHvOZmMqWym2EZc1iSn64E+WWkww70VnIYbgFu8igXI5D9XWnFu2Yh+IVUaQ6SmjAheKeSxSMeE1GDDp00QWEeW7zf2H1rlpaO4p2mS/eqKzEmKN5lDy1ykA1lFT37sSyZGhNRFToH9ZRYPc9p8m4FnInF5rPKbE8v8R/ffGMcwq88w73xNmDG4PG3kY14J3sUZiL7tnZnWOnTjZrr1RHQu+soghNWpsNBoOKeB8VL9r6wMvlLpc/klKk+K7GQ0J7gBc5yXwQ9spmeKDCGy31uObVodMxW+43SwsURF/odR4BUHIV3jX00z8UOyu1bTUPx1wCk/H+7a10bkFjXLV+PsmKZuzfypRqrJNN5FCrNHgvWtkhiPmnS+0sxONBTVx/wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I would like to ask for feedback on an MM performance issue triggered by 
stress-ng's mremap stressor:

stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief

This was first investigated as a possible regression from 0ca0c24e3211 
("mm: store zero pages to be swapped out in a bitmap"), but the current 
evidence suggests that commit is mostly exposing an older problem for 
this workload rather than directly causing it.


Observed behavior:

The metrics below are in this format:
     stressor       bogo ops real time  usr time  sys time   bogo ops/s  
    bogo ops/s
                              (secs)    (secs)    (secs)   (real time) 
(usr+sys time)

On a 5.15-based kernel, the workload behaves much worse when swapping is 
disabled:

     swap enabled:
       mremap 1660980 31.08 64.78 84.63 53437.09 11116.73

     swap disabled:
       mremap 40786258 27.94 15.41 15354.79 1459749.43 2653.59

On a 6.12-based kernel with swap enabled, the same high-system-time 
behavior is also observed:

     mremap 77087729 21.50 29.95 30558.08 3584738.22 2520.19

A recent 7.0-rc5-based mainline build still behaves similarly:

     mremap 39208813 28.12 12.34 15318.39 1394408.50 2557.53

So this does not appear to be already fixed upstream.



The current theory is that 0ca0c24e3211 exposes this specific 
zero-page-heavy workload.  Before that change, swap-enabled runs 
actually swapped pages.  After that change, zero pages are stored in the 
swap bitmap instead, so the workload behaves much more like the 
swap-disabled case.

Perf data supports the idea that the expensive behavior is global LRU 
lock contention caused by short-lived populate/unmap churn.

The dominant stacks on the bad cases include:

     vm_mmap_pgoff
       __mm_populate
         populate_vma_page_range
           lru_add_drain
             folio_batch_move_lru
               folio_lruvec_lock_irqsave
                 native_queued_spin_lock_slowpath

and:

     __x64_sys_munmap
       __vm_munmap
         ...
           release_pages
             folios_put_refs
               __page_cache_release
                 folio_lruvec_relock_irqsave
                   native_queued_spin_lock_slowpath



It was also found that adding '--mremap-numa' changes the behavior 
substantially:

stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa 
--metrics-brief

mremap 2570798 29.39 8.06 106.23 87466.50 22494.74

So it's possible that either actual swapping, or the mbind(..., 
MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the 
excessive system time.

Does this look like a known MM scalability issue around short-lived 
MAP_POPULATE / munmap churn?




REPRODUCER:
The issue is reproducible with stress-ng's mremap stressor:

stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief

On older kernels, the bad behavior is easiest to expose by disabling 
swap first:

swapoff -a
stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief

On kernels with 0ca0c24e3211 ("mm: store zero pages to be swapped out in 
a bitmap") or newer, the same bad behavior can be seen even with swap 
enabled, because this zero-page-heavy workload no longer actually swaps 
pages and behaves much like the swap-disabled case.

Typical bad-case behaviour:
  - Very large aggregate sys time during a 30s run (for example, ~15000s 
or higher)
  - Poor bogo ops/s measured against usr+sys time (~2500 range in our tests)
  - Perf shows time dominated by:
       vm_mmap_pgoff -> __mm_populate -> populate_vma_page_range -> 
lru_add_drain
     and
       munmap -> release_pages -> __page_cache_release
    with heavy time in 
folio_lruvec_lock_irqsave/native_queued_spin_lock_slowpath

Diagnostic variant:
stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa 
--metrics-brief

That variant greatly reduces the excessive system time, which is one of 
the clues that the excessive system-time overhead depends on which MM 
path the workload takes.


Thanks in advance!

Joe




