Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED35EFB7E7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65FC6B0092; Mon, 23 Feb 2026 21:12:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47AB6B0098; Mon, 23 Feb 2026 21:12:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFBF6B0099; Mon, 23 Feb 2026 21:12:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB126B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:12:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E83B8B67B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:12:00 +0000 (UTC)
X-FDA: 84477724800.16.F0FE019
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0A62100004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:11:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="D/KcyStV";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ri2IZl4h;
	spf=pass (imf05.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771899117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eFLKxRrJ7UXOHNyXzw6qX1aguFKj9XAN06pICBbEwlM=;
	b=auTMeZnLakQhallBYG5qPuLPnUNRu/t+4Sww3dOCaSQ7/2YzrwM9T6MWMVf60qFcIpJRJo
	Qjwfva/t1uKPeeIdVe0T91hthyxARvALoAada6PtV8BYqoBRHIQsIb617ZlwaHb2qwTk87
	ZFtn0HRmAKjk//G9+qYH08VMpZpSzb0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="D/KcyStV";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ri2IZl4h;
	spf=pass (imf05.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771899117; a=rsa-sha256;
	cv=pass;
	b=lGEHc6RXLsgxTbPnhBjdIFEnaN7j2BnDIweQSRu/iIfXHEGUptjMdlzh9zt5cuWLHVbHsK
	6RwYoac5ZtihPY5YZfh0aBxCKCsdwFAhLJsyyTC36RNctF2l8DKPiVo1qRRZUmsvXHdlD1
	Fb6Ine3tOwcliAf2F+ebWlw9OA9pJyU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMxYTd1962580;
	Tue, 24 Feb 2026 02:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=eFLKxRrJ7UXOHNyX
	zw6qX1aguFKj9XAN06pICBbEwlM=; b=D/KcyStVNApO0yRokwXSdGxVi9+uV9lE
	d+zKi7YaSr6ssEhdFYVjnM/QrOKMSh2pmtDr64LOIAEDGMd2gFCgSPT3OHrsLqGv
	M9MX4voVYNwFvG9rKW3gqxde7+FmHPVtiP2eB9jJN9ag0ymY4GRJng7T7EwF7FxP
	vyhqysBQBOH2oGDGCdl2sis0qh3tjXn8Le2jx9BkEjAI2d8zYMC4IRDvPXv8DDFo
	PgtPIyb+x6i7b/ML+xFhOBiQEPYxS78I5TYGWR3kuW5KGgrfOf0dxt6J3+P+7T8S
	3Yb2sEXNQmMVVgDSOXDHcE13Op0Qy2r/9TxIj4gmkBxEpefE9/+yUQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qbd15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 02:11:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O0kjPp027789;
	Tue, 24 Feb 2026 02:11:54 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012032.outbound.protection.outlook.com [40.107.209.32])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35e4tdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 02:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THYfs7LdUVpEONYACSiTTnVvRQLbqI/38B2XlizIGuCIiHPXKLLsBI7kzi4sLW7T/xU8DeFlVaWEKGdmUmLbdyEG8A9iz0x9gFW259re8R2TUjobcHlXJ+w/Q7qQYYtdKfvfEh2S1ylBS9MvDubKc8w/0Q+DilJGXf5nVLMzU4HVG0e3utKaSM13ejHQfbB5rA0Rg/pb434xIbtzf/6Hikvy+jjTzd5EIMwr06W+SbtEArxt/v6oB+leBYX4xV6vvWOeUsNC4ZBI3ZFg/dhzVEDcprcYdTK3EbXuCVYTo+dekjXf1JelE55zrkrofkAgaWMnle9kvapP0PM+9F+//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFLKxRrJ7UXOHNyXzw6qX1aguFKj9XAN06pICBbEwlM=;
 b=Ic9VIsQbAliYmoE7WVhmDlUywaKu+j0r1PI0I7hVkNGIe3i5DXmAY4z/WXSHsWp0gMu2edUyfPgHrAwGiQfshttkhgJ91LGzuAohedDaVGZV6k4lZTVFfgDypVITyIB5lDyE1DJDYR/kuHntA9yr3CehpnIt3q/lEoaSr8PYVJKu9OlhSN+of6HAoo2EeRiLineFy3bHwKD0s4mGfmXif4sjIkrlyOTfcqp8RJNHqA05/dP2St2Mq2XYRWaya16mXYwNGqFIBlfYg9eSZWMpCITDjcWZuYDbrHqCYFfzH+JZBxgHWXk5aQhCE8qxy7cXMdIaawc2p8BApUMqKfVGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFLKxRrJ7UXOHNyXzw6qX1aguFKj9XAN06pICBbEwlM=;
 b=ri2IZl4hBq5QwKdKF/FgXY84U5QUuaZGrIcr1qt/xB86BgXvXFxllo8xyhSbP4f9FthfO0HC3iO0CZHppkd5BNeq3QUnqd+yzBHQzINO65Gh5TKjG0Av4IK3ncE1Dh4areBugcrQb1m6IKvA/oxDJzZ3COim1YHbGijxuQk1iWw=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by BN0PR10MB5144.namprd10.prod.outlook.com (2603:10b6:408:127::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 02:11:51 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%5]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 02:11:51 +0000
Message-ID: <ea6c914d-44a4-4958-adb6-642e86488045@oracle.com>
Date: Mon, 23 Feb 2026 18:11:49 -0800
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: anthony.yznaga@oracle.com
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org
Subject: [LSF/MM/BPF TOPIC] mshare - sharing page tables across processes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0018.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::31) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|BN0PR10MB5144:EE_
X-MS-Office365-Filtering-Correlation-Id: 805bff43-9dde-44b6-3986-08de734a1270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aCtXa3FMc1FScHR0ODFCQmtUL0JVOWp3cFpOT203andaQXlFTjJLVmxQaVBx?=
 =?utf-8?B?RUNMMVROSldibHkyWlZ1SGFaTXIxSzdzSC9oZDBpRTVhOG5ObTRDaVd6ZG11?=
 =?utf-8?B?blE5eWtwcDB4bEE4WDFhZXZpTEZaTUxyb2lHbXNSd2YxQ1Z6T1J0dUJPYXlW?=
 =?utf-8?B?WGpQWWJBUFhDdjhJWHFtR1B1bGZPZ1pBMmZKeDdxWFpibWhINHFYYTAxUElj?=
 =?utf-8?B?di9OK1dFRkNFb2c5c1ZKVng3T0xmeWVFdGlCNlVQWWt1RlpmQlBLOGRaTWhY?=
 =?utf-8?B?N2pLbG9hNUx3ekF5YlVvRTdDdXpYTUN2UHdEa1FWRDJpNkpGMDRvTWoxeVBY?=
 =?utf-8?B?dHZ0TElrcnJVcCs4WlhEMkNQaWw1VXhsSGNncGRFMWUvK2VaZXA1OGQwZHI0?=
 =?utf-8?B?UzhobnZwZkJ4MmVpU2dnOFVwK1B3czhvU3JjTjBNZ3BNVVRwVEtIUzd4eDRP?=
 =?utf-8?B?RW91Y0Q4ZVVaZEhLRnB0NTlrL1d3MXpxaS9FTW0rQ1pvbVlZZ1BldlRzek5z?=
 =?utf-8?B?SFV6emVaWE1CamE1QUx6a2tjM2hpTDdjbnpvT2U5bkpYWFJKaVZJZXF5ZjFM?=
 =?utf-8?B?SHphdGtuTjlUQlR5YlBwVjhsS1AwVDUrUkh6OVU5UlN6TjFsSURkc3pGTVY5?=
 =?utf-8?B?bkFSNDlOaDRLVDhMbFNMUm81QU5wVFBGbGFiWHlpRTFLTUV5NWhUQXBySmlK?=
 =?utf-8?B?Rm9yTjlrMW8yZ3Y0dEtPdGhsWm1admRxNzVGZHFtYUd5R3dsWVkwZWVNckJx?=
 =?utf-8?B?Z0JBczhUVGgySWY0SS9VSXMwaFZWU2lHc0UvSjljQndKTzdCYzBPYWlrTHU5?=
 =?utf-8?B?US85dDJ3bjhJLytOZTRzdWtBVldyaVJIS3Z3c251d0JPQUVuQnVWWnp5VXQ4?=
 =?utf-8?B?TWxybE1UVkhEOGJGRTZrU3dnb0RuckVqbU1EY2dqYTJsWm5KeTJjRzZ0NzVI?=
 =?utf-8?B?ck53UjRqMEp0L0xnQjVtQ3pheVBwQytlNzMxN1luTWFDanREQ1g2TTEwUXd2?=
 =?utf-8?B?QjFYL3ltc0wwNFN6TlMwaE1kdFh0TzlibVowQ3F5QVJZTlZMU2JCYXZTN3Fa?=
 =?utf-8?B?RlZDV2lseVRwVVIwNmlsN3dGMk1Fc1QwM2EwVHp2ZE5QOHV4Z0gzVERiUGMy?=
 =?utf-8?B?TGdGdlVCYnNwZlQvTlp5MWIxdkwvcCtOTjA1OUk2Wit0WURmVEd1Z2Y4QTU2?=
 =?utf-8?B?Z05LNkhzaUtQVFI5MlhZb1BYbWw3aWdQMWhyNVRxam95bTR3M3BSQzFiN1No?=
 =?utf-8?B?T1M5bldobWhJZnY0cW5sc3QrdGpPQVF2VVhUYkJKdnc4K3U0WlF6VVlya3Er?=
 =?utf-8?B?RUN0ako4REs0WWpuTmtKSjVib0hnQ1Z4aWVzZytMbU1pelpTRG5heGlNa1pr?=
 =?utf-8?B?WDVEWWQyeTJ1aElnclJ1OHFxQWlxdHU1dTUxQXlQYjVnYUx3RlY0Uk1TSHN3?=
 =?utf-8?B?ZDhUSmRHeG1wcWdlcFIvak9DMzRCdTN2UjcxNjVVNW0wemZWbm5scHpjYTkv?=
 =?utf-8?B?OCtBclZBalhQTU5Jc2tKbmxyNHhmQ3QxZlB5RlZtVGk5OTdZblVyd1RnT2ZS?=
 =?utf-8?B?aGVBOTZiVUdNZmdIR2dYcVQ0azhWbE8rMlJRVEc0ZlVzU0xtYlBKUUZ1TWxa?=
 =?utf-8?B?TVdvamRhbXJnSFdpa0ZiK0ZGcWFOVGVlS0xHcnYxN05TQkppa3V1Sm5icDhQ?=
 =?utf-8?B?bDYxNXZxVlhOendrdW9oQndGQTBCRXB6bUZWZ3czM2k1azNRdjlxNnlHZGN4?=
 =?utf-8?B?K0QzUkMwdDhRVG5XTGdDM1hZalJpMThzYXdSS3d6NCsyNHZ5ODFDZjY3M0pW?=
 =?utf-8?B?cnVqWjZ3bVlZQUxjTlNJSGJmN3BRMUwxWjQxWXdMZkRYcTJZK0F5Wmt3YzZ5?=
 =?utf-8?B?cjMrVHRCYWlQNUk3SnppWTlSSHI1bGlyZG53WjN2ald3MVdST3hPSEY4RWtj?=
 =?utf-8?B?MW5IckQyT2VSQldaWmVZKy9YMVJqSm84dmFKR0RyeUhLNnVXUXJiYnRQZUR0?=
 =?utf-8?B?b1VUMGFaVFJubnRobUhVMm5ESTJYZFlGVjR4OERENEhURFBreTBQdW5PNWZH?=
 =?utf-8?B?SHFvZ2R5d2twbkxrRVhnWHVselVvUUFTWTc1RzdWakZQRFJ0R3JsM2hEVkNw?=
 =?utf-8?Q?WmOY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDlnVy8rR3FOblEzYjJtYis1Q05xbEVpODFMeWZvVjBPK2FPblI3S2FQNllY?=
 =?utf-8?B?djNkSE1IMnJ6UWlNTzdSYW56OG9BTGRjNEh0WWJaL2pqM0xDUWNYWGllODU5?=
 =?utf-8?B?S0NIaEtVWC9WNE5rdU1QYmFSb2d4T0VnS25UWHQ2QkxnMzZiemdMRnFkTGlw?=
 =?utf-8?B?bGhseTlSQjRrMCs1N2g0dVpUN3pmQXBFSVBjWEJDQ0t1MHUxQ3psUU8xTVY4?=
 =?utf-8?B?K1RldWFpbXdhekNHdjN1VFRNNk9qaTFrczcxMlcrbEExQy95Z2lma01iSVgw?=
 =?utf-8?B?aEh2MDZrSm5OQzF4LzBzUjFDMjRPSWlXZmllNUZFUFVlZFZXNHNSQXFCV21N?=
 =?utf-8?B?eTRFR3d1QXJyVXREQnNwNk41TjlDeWpxMzFrcWZOcmRnT0ZFVGdJRGh2ZHpL?=
 =?utf-8?B?QlBaNHdhSW4zNnA4UDJHNmZzUW5paCtSWnlYM1dlMGxIZkVyY2NucTJoamFH?=
 =?utf-8?B?UWlqMjFGd3JXMFpJSDF2TTkrMnZtdFQwaGl2eklmTTlscUdaSVBxejM4UVpT?=
 =?utf-8?B?SXBLVEUzZGJsa2YycnVISnBQTjEwYnpuckQvU2dpUFdiZjZJcE5GYlptdmZH?=
 =?utf-8?B?bzB4Q0ovL3NZRXpLa3Ivek9ZMFJxK0VMOVVKaHg4MW9hUkNqek03S2p3Q2d2?=
 =?utf-8?B?Nk5jdVBlMkEwQm81RDVXQTZBbk1ERHErVTRNRDN5ck9CalFCdnlQT3MvZng2?=
 =?utf-8?B?Z1YzZmZveUNFL09WVGV1YThUdFJLZ0NNbWtCV3lYSXRvL3U0bGVKZEJEc0E5?=
 =?utf-8?B?QzdKZ1NwdFU5ZVFhS2FqSW1jUXEvNmgrZnFXdlh2QWgyUXluWmZvRTFaZWlL?=
 =?utf-8?B?WG10RElidGdORjFkbFBURVJTNFpvZlY0aGdwODgwTFlsUGd4WWNvYXNuR2c0?=
 =?utf-8?B?UzRZZUh5QzdSZjRUNjRWOUo5Y1dYcEhuZENadmhrVVNmeTlDcjlWSXVVbmJm?=
 =?utf-8?B?MGNobko2Y2VaN2xBVFBYT1hrNXJheU04eGRBc2FqZFA3OVFncVNzZ0Q0a0Rv?=
 =?utf-8?B?dndCWkZ4SWZJMDBZVGpmS0dPUytWdEdvZXBaazZlU2tKTzM1d2ExZm1qaEFJ?=
 =?utf-8?B?UFVIdkJTei9HYm1zZE91akxuUkFSY1Y4bVpLVVkwSHBrUG5jcTVvZ3ZQUGE5?=
 =?utf-8?B?RHd5a0RSUTBiWEM0dXFTOHltOHhUK2VueWM1ZWRBOTZyMXZ1SXlBSDBVUm5T?=
 =?utf-8?B?QlhmUVJuaEZERVpjQkgzdG1xQW45WUxlc2c0NUt4d3FENXFUQVIyZ21XVGo5?=
 =?utf-8?B?akRuajdsdGo2MFErUkY0cWZvak9nSTFjakpGdVhKWFdrcDViaVJPK3ZHZmRs?=
 =?utf-8?B?Z2M2dW5ickVkM1VVaDZGZUJlMFJGQmxHblBwL2RDQ0NzT3NWTzMrUVFROTQw?=
 =?utf-8?B?QXBlSzZ1cHFDVUJJdFdsYUNGZlhLdi95R0EyZjM3a28vY0hVMVFVRU1yZWI5?=
 =?utf-8?B?SUVHdFJKbFZWK2tWcktMYmJiV2ZCUW16bGZJdUFvTCtzV2VMZkluSHNGN1FX?=
 =?utf-8?B?UU0xdlBrWlBOcmVSbGZXZW80dnFkeldRdnZwR3MvY3YyOHh0cFNzeXRkNFFl?=
 =?utf-8?B?QWViK3JHanI4RUt2dzM5NjB3Qm04RW9vTkUvNkVKVy9EQVZQTVQ4bXc5NnVw?=
 =?utf-8?B?dFVOanJIVXdqUmVIUUIxeGlYTjJoYXZPTkRkWTR2NFptM3ljRWFLR2R6dFJu?=
 =?utf-8?B?S0s3NXFuKzNuRS9VMEFVWFFrWXltOW51L2tlcVpIY1VtcFlpOW9tSEVkdE9l?=
 =?utf-8?B?enNEblJhTFJJV3QzS2NYdE1QazJvby8yTnB4QytOeUYzTk45QVovaHRLOTRE?=
 =?utf-8?B?dTIzTUx4TU55SG0xY1FpTVc1RDdJeW9LQ2VPdisyUFhFSVZwbzNVVGtoRWly?=
 =?utf-8?B?QWdVMHVxQ0E5K254K0JRLzdTTTBURGYvUGU3Z0dQR0hzY3hyK2NxOEhDZ2FV?=
 =?utf-8?B?ak1zaE9YWlZncDBwUUMyMWZJS25kRGJ2VUwvOTVpeVRYMDNuUFZ4NFFicHBt?=
 =?utf-8?B?Z0x3SnEydWo0NTN2dFFlNm80TnBSMUg3N0JiREZ4WWRrK2lObzk0NmpraXBB?=
 =?utf-8?B?cUVUT01zNFBYL0pMcG5OZVp3b0JKRmk0NjR4TTArNGZ0azVJeXorSXRMNWR6?=
 =?utf-8?B?L2RtZWhnaE5ZNC9nZHV0QXgvWThGRFFlZHdXYmVqQlh1VnZmWkhqYmZ6SDdy?=
 =?utf-8?B?YWdpbURPVDdmWVBNSUppV0FsVFIrL0syQnhCNk5hK3RMY1Vvdmh4S1RBeS9i?=
 =?utf-8?B?VzUvZkx2Y0graFJ6V3k2RXhyQ2RaaFl4bko3cndXNkREWXNQcUI1SlhEZmlC?=
 =?utf-8?B?UmdkandZdzJ6NW1QaTBmVnhKNE0yR21zSGc0SlJkbGVVU2paU2lRVW4wUjhK?=
 =?utf-8?Q?w29vqlD/2xUuC7vY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iAM17I6GpFnF4mVQTYCGYtSfMCiU24f8jhAyHNrb/Pp69kCqKUuRkWK1yAA3OM2mxZSdNdAzSnXyFPzVSjhXVCb/4isucDx+0gQdSjgzAsj6B2Le4GAXiiqf1cG8HwpmKVbzWGf8AG4Vwx7uO2DefXM38siECdaU01yl5VWeBCT7orn2FeH07HP5zDBCT2I7LoXw4t5uGlWNNlF92meK6P9lRznPCgr/XjIxYoL1b/t5IycYB5KWYgL/lNC0ZnU/E99dlD1g+kEjq5NCeT7fwhhDFNOgI1ryZNJyhIdwPtH6qyom5i8NcMwd6LIQurrJHRE41TjUSUoNy26LkJqKh/wT/UHf5qEdF1TcTqFigBOlhOZe+GZgM0Fh47NjukyS3Sv2RzvqCgzZaeOI0vwj8CusMTXgE9ujz4j7rC62ALh0oGwpk3C8OSWIznLIoVCYQ64KQSaEs2MUU9dCQ21TJEPqJJjDb5FKhHbRDoz3zrDuCEnjWpnCSd9dBFUTye2QH+Kf2NBYu98FNQWwgBtRfppK0zf7AmQk0E2QSm8AmbYG2BdMvTu/7iD3xKMUBaQCB4+25Dmt7npSRV/nLDePis+s9bi2apj4MychSeh3IOw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 805bff43-9dde-44b6-3986-08de734a1270
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 02:11:51.0281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2WSdhas3emOM3poPsXyIoVs8xOyg6wYTqdGc/phG67QNONb1EgsXn3hEFMIqXUprDuMoQIcsxniSqYhqagKUwLJ0+B566FlL5LDrp+KcuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_06,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=854 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDAxNyBTYWx0ZWRfX8BNYK3HzgZ5T
 dagUF1yAPaFzSErPbl5ic0Rku2DSZ4dbUEQRozQsNcRa1bGbjvBHtKNwnX2STFyITpFgGOzTYhl
 x8jYeuBrTLkLoEtIEjIu3yU4HNjYAYn+NaVWEetOAWYjTqHFnwzD8D8rxaiwqkhYlE2GYwnle0L
 Bot+juRv4DL66fve69Kj/i/E3UB7/k1+Iy6yKZS4bd9uXAk0xC0e2ykb/8szE+qh71UfmcsP4Kj
 HXWVfFC30K4l4JvbXnIwyjFpXwIXcZw8HQnm1m43S+6AO3YqT4wmZnc49QLlf9KPY5Z0y1PWTab
 pKLontQdPoZNxOQE9p8z4QP6yC5qkaB6x3rUiKPiX+Xj84ZfL9ooAQW3racDfQNT7W97EcP7Hm3
 ECpC6MFKtDBIlO6EMSsEYCGMznCiGQJjO1LA6FYxFltt3C37qUGwmhuVxFA0KSY2OhTp3mWZGSo
 qlcBsHmkZGEP2En4cLumLt8cRTxIRuuFiB/Ju80s=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699d08eb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=XtV68_uLod2ZLV-_v64A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: sRlQ38UdXbyN1QxVkIRVeTcheUALlyMs
X-Proofpoint-GUID: sRlQ38UdXbyN1QxVkIRVeTcheUALlyMs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0A62100004
X-Stat-Signature: 5fkydfj69bozxkmcqtsqjuxejmutcpi7
X-HE-Tag: 1771899116-428023
X-HE-Meta: U2FsdGVkX18DAZYc82izs59EX9KPvCKeFA+abLJdFpvCO/yPikxJUPp2Wh2lA1Y85CuheRlG57QKGqJq1b3pmCWni5IJ7xl0NJDs3sKjdgnUa/FgwIP2rsZoo7vJlkf2ZoLHbLTUbR//CBcw+SwIkxOs1G2otewrLbfYMe386CR4+Rg5sStUIHef3IxdRP+17k6ePgnOyQ2T5KbaI16ncSfzYBV0QBADJYpGUsfcyQVaMzGs/saUtzHPtrJTQ3eDLpMLhNm8yHwxAFPT3R6t6sUV+AYeT3bEI9SXJR870UcqpGkrsciUVOm2U4W5nBOfbyErN4wORefGbuRqj/hEjtYkLtgNpiN+LGysqDGjrA8/W28i+u7/Cq8GdSLe7blvtC9sNNnrtGYXDms30hqU9NzacPt8RVsouV0TKwv35DIADRXNEoL08pS7Kk/cfF/+DEs9EP3XZwjDyjtZ0srJEvoxMCLeiyEMwjbKoe2Uf7+0rMw1F+GKUtsb3+Z3+8NiE1u6nPGq6wqOO1RtwnCzDZ9BUxHM8U1yF6ipda1kXbDqVRqA/aNQ94DexSQvi4czNjsM1MrMkzh6csCtfRmopLIPoqhfXydoskY11VvQJGpRsl7JLBYc4l2yqPO+2wtO266APZEIW9zS8wHqoWrp5mgSGmjv21lZupq2kFqqnJhU0RjZGkD8a+25BFqQrxcqHKp9HM2/rQ/wioaNI0H8ZWSTvdHBAxgpvjJSbBiXGKwIDu4Aa3CtGolpXLHfkIqUqq0j3qZzt92Sn2ZMrcolV0N1FMVezYD+4xykQwjQrN7Ec9XBdgueeDARN+6uKmuuxx39ECyHLtUJOQpxpATAB35DfmuaQIiTtjf0PSo9ia5XGGtQFaeCcfljj7TU7V9xwcDboydxNk0agSrPnBGLjBjavsagKkETAbqhUcof9zKN3A7ihbCFX3HubEVFteDYi3jaflQqH4mtn52AHVk
 n1xXyWA5
 NMN9iPF6yP/QKCDHKohjK1UDLCLTRXW6s5yNN658qqHliQWKyKsRJyDYrjyxSSk3XvIGFjGGcPcM0fiCYL0s0MP3TYQw/EWvW2k7Fu3dbeUVGP9adHTkDOzPhiwah8M1ywR7Pr0Sb+9XUYi08cfdAPbUs/WV69Emy+OXEJiXv3QawcY1IkH8JmvHO+RfRfmtUOljQIPkaQ7NLA12cqv0OLnejLi6wr2GRECvI8Kg8kxqLKgHNsT/03JeN79OVfaDa0fpPuwhg6awrwxSd3XMSHnXHFW56r8m3Ci1DCfhzm37h5Ty4/RlPrM08FrXOOeVs4lYn/yw9uaAdlIfsdSC1xWSojHfoZeascViPi0rmaQYu2VdzMkBD9Vh0dhVmbA2krQElknKuaEyEBZ8K4j662BvtL0xfzaWLZc9TKed+fP/jrdwvqv9fQQZBxJz4IbMCo4cH53ozXlNYwEgNQ2RSqOukmjF/4PEa2Iy0OwBBCSPtrHjZgiItZaxoRZgofvrUoAyhtDHoGUzIISe7m3UKKNWzr8Pc3wzgyjDGWz4wT/Sgf5JqbQXMHN5fMXdJa7LxpvenxPoElYfXWArrUfR2H+WvudZJ9VOU35o1ahQUvdcOyGI+zpLRJKzZhGfUrVjF0wzvySHk5BqHEcRleu7TBO/gjQZ66wZwR5N98iuVjZYkwI9ij5ay2OuAbrd1Mr1ufzW4vZlT2C/6eUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mshare is a new form of shared memory that shares resources between 
processes, namely the page tables entries and VMAs of the shared 
objects. Advantages include reduced memory consumption through 
eliminating the need for duplicated PTEs in each process, reduced 
overhead needed to fault shared pages into multiple processes, and the 
ability for updates to the memory such as protection changes to be 
immdediately visible to all sharing processes.

For some time now the proposed API has continued to evolve. With 
feedback from mm maintainers, a new approach using syscalls is being 
taken to create, attach, and deattach mshare regions and to map and 
manipulate the memory objects within a region.

Let's discuss the current state of the API and technical challenges of 
managing and accomodating shared page tables in the kernel.

Anthony


References:

https://lore.kernel.org/linux-mm/20250820010415.699353-1-anthony.yznaga@oracle.com/
https://lore.kernel.org/linux-mm/20250404021902.48863-1-anthony.yznaga@oracle.com/


