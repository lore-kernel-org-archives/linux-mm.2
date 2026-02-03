Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2608EE8306B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A92E6B0089; Tue,  3 Feb 2026 04:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AC06B008A; Tue,  3 Feb 2026 04:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B416B0092; Tue,  3 Feb 2026 04:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2D16B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:52:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C28FD4CA9
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:52:57 +0000 (UTC)
X-FDA: 84402681594.09.F763934
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C82320009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:52:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CaxjIZSy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CvtIJbc8;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770112373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUGRwab+gRZRupKl/EwHvHfolVQP7Xw3R/KHeQPWF5Q=;
	b=cOH5UxDqV//cnDAmFj+AhP8mG2noOGK2b1nxGNsaHBW80Y2MRe/NMOGoKyyV6TZE1R8zfU
	DdQ6LTzy7Ih/zvTYaQ0tdJbK2qpmwpLM+P5traBlxRgwWZRYpkaHH2C9DjMFpHe97wonk9
	edgDjgN6rSCGPcmxAwTmHPcB1Uj1qhs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CaxjIZSy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CvtIJbc8;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770112373; a=rsa-sha256;
	cv=pass;
	b=GGFbR3JGjiRzZagFUh6XXFJ+mUw2MH6cUGLySXV/Qj0Hyi1hAlmy0HN8B7IeHYWdrNXEhK
	VHopE+TEtGk496IL5JQytydS/Ye31KlkQCik4uhWdpCXV9wdLQ3ddE9NbyYXetuWc2VSSm
	inQ6YuOg/PJ0m7SfLV1pJSv/JJevby4=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6138vUvk3817654;
	Tue, 3 Feb 2026 09:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lUGRwab+gRZRupKl/EwHvHfolVQP7Xw3R/KHeQPWF5Q=; b=
	CaxjIZSytq1w3shp6R+oopsnTUMiiI7qCg3+0aqFJ9eWdwpHfhpbg0L9LIM/y2Z+
	6sIoVdgHlwlX9i9ehmqc0/OJOOxitxYs/gRnYS2zYDXS2Tk4N2HsNhuHiYyi5rJE
	tZvRqFbZO3ipUjXvFJmA5N083rr5q5OTY5KBqgnE5W+7MxUda99Y24C5KP/6IMkP
	wvx3VUSfGcwpLMqTcJSX3arB8NLlIZ1+E6xAm9BxICVj5bXJDe3Z8LcLP0MM0da0
	4Dz04Xp+ar11EYteGL1MiA9Hx6NztccsC3lCiaeTgQgNCDo7xzrSw/+7YisgkfyU
	GEYdLhsuXHMMiX0h/XPMhg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1au63rfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 09:52:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6138Xrle018676;
	Tue, 3 Feb 2026 09:52:49 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186m54n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 09:52:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eixawdMAwwQFhLxCWOfW0jquoZyOSFYVFgqf4a0Lc6XGg33F6mgb8qC32vFVGNbl7PpSWto26iRWA8s0GLT0MYl43dv10CREMLxulGqyLCOQ/WTJcy8WpCgOyQqOAM1eaYDmrVRc3ung+JMYL3fBI+Sn++IQjux1JZcD9xqXHhLVrOm8WDHelBkwMtHURAHFRSdK80c1IM+0ZvoDlRjOiM98uRmlDzO99CRKUnabPbut5PksmhC8QsB41AWgeMml5isvbMhv5aEd0/lZ7/K/dMDcNf5fmX3BxH2FutvZ1yvCSh/tUofkzCCtUNf9RLWqF1wstBUsLtw58R8q6GvyOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUGRwab+gRZRupKl/EwHvHfolVQP7Xw3R/KHeQPWF5Q=;
 b=JPoBdHxjk2DM3ZKQefLJzD5+k/sAwLeyLZy4yVBstdhrr1Q5Df9rCyk5gUF0hYtOLetjhGeYWClcf3QKBdDY+7KLeafFUPAlC9MbrLtb+7fLiUZ/hlfzojz/GPW4xYqX+DATYB/yUJHw3eZeWlczfUcdlEVGySZADZgRGJXWU9nEyHW3S/g/MEci+9py7yIBx9GzjenrsB6V8Oc3IEirqUJlctJf6oSGGrE+yg3G+CLUnQwExHqvM8shBuQJddOx8zz8ykQsBzmoFiAdv7mTHS41uZXqQn3MbcWthLhmI8ywIpbstnwk3Q9EHCmxqLOnzfRd+ag2cHmWpWgh2zYlug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUGRwab+gRZRupKl/EwHvHfolVQP7Xw3R/KHeQPWF5Q=;
 b=CvtIJbc82ZdBR6puHOkm/JqKr3fiAo1Eomm605ocggv/3eFSLoneandIkK/Pf1vrcPG5C11rezOnoQgzuIQAL++nvvzKO6DkeLuErhBf7Srt433Qssh4bXckvHxPWoFwp2YEN85PlI8884Xb3WrXV5/BLFvjjDbyyXcDlPmXjVU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4224.namprd10.prod.outlook.com (2603:10b6:208:1d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 09:52:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 09:52:45 +0000
Date: Tue, 3 Feb 2026 18:52:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
        syzkaller@googlegroups.com, vbabka@suse.cz, akpm@linux-foundation.org,
        cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <aYHFZ5OxfL4j-_ze@hyeyoo>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
X-ClientProxiedBy: SE2P216CA0204.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: 851a6662-7acf-464c-090f-08de6309fb58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzUyZzVoSkx5b2FlcFI1SXNQWjlTUVU3aENBeXhRc0o3d1M4dEtqQ0JSMFln?=
 =?utf-8?B?VDlCL1FDclQzWDI5T3lFWnZBWHhTM2d1K0gzUVFGeVlxZHRybkJPNlpzK2h3?=
 =?utf-8?B?N0JjRU82S08xWFBLdDR6VXpBdHZXdXJ5bkJ1RFpKZStrNzJPTDZzYzRpMnZF?=
 =?utf-8?B?Ny9GeUhsWmJNd2pXV0JRWUUyVlZPdzM0SWNacXFqUzN4eWNCcTZrVFF5OGNL?=
 =?utf-8?B?aldMWUErVDJFdDdEemZqQlRpOFJZRVF1czVnYmE4MU1aamQ3UG1aSGpqTXVk?=
 =?utf-8?B?TlB3Z3ZaSktGZGV5b1Z0cVQvbktqVENEaFZBQUQyMnJhVkhxRk9saVhad003?=
 =?utf-8?B?MHRpTHNSWDhiVDdPZDBmaC9tZHZlN1g3ZG1GSlVZaTFiYU9xYXRza0cwSTNz?=
 =?utf-8?B?TjV2Vm4zS21MV0x5d2habXRmQXJsYW9FQThENzU2QldzVjlZd3Q4UE1NaFYy?=
 =?utf-8?B?UTIrcUFJQ2hkUFFRNU1RTkJ4cG1IQm9xcXVFUDRGQk04L3lYaEVuWlIrb21w?=
 =?utf-8?B?RDNheFRBUDM1M1dMSHpoVjh0b3pManI3NnJpWGcweEM4dXRBTFRCcnFoSmJi?=
 =?utf-8?B?ZXhrVkN2citoUy94U1NIelhBcXdla053VkRFZHk2ZWNZYWd5MUx0Y2tiSzIw?=
 =?utf-8?B?UFV1aWdnakw0aVl1Z1pqZWM0M1Z4RGZQZVNMZXpma0FEWlg3QzdZY0FlcFQy?=
 =?utf-8?B?bSs0VWUzMDgyUWtzRVZzcnhia1E4YUxObTFnZWpxYUt3MFBXbFAzc3NDZWk3?=
 =?utf-8?B?bDVyVVNUaGVFZDZ6QUdKRTVISTA4Y3YyQU5kNEJLNndLMGhSYWtTQTE4Q0VI?=
 =?utf-8?B?eG5kU2ZVNXIyR0J1UE5XblVQOFIvbHJmQ3c0QkJXRVFtZWFlN24rWjhZSHBt?=
 =?utf-8?B?dytDOEd3bWFwMHUvcjYzMVJicEdhV21qbDBNU2tTZi9iSUhBNnYxN2FCdmJv?=
 =?utf-8?B?aEg1RVdoWS9FeUdWNzRoT1ZZMmkyL0lXOGRWb080Q1hnaG9MZmNUYi9MRlRZ?=
 =?utf-8?B?QWlJZWRRSlVVVEhhcmlVSXc1c3drUGZnWm1Gd0ZLWUJoTTZrenFQOUVkR1ZD?=
 =?utf-8?B?VXd0Z0IrcmlGd1VEenhkbzdueW8rSlcvM2Jta2gzWHdKZUhtT2ZleGhHMnl2?=
 =?utf-8?B?Q2NhRGFDK2lyQlJiY2ZIWGM1TlNmUmxoSUZ5cXZIUitzMUdkdzlIK1I1eWIr?=
 =?utf-8?B?RHZ6aHA5Z29uaEJ5TEg5dHFrRWozRjAvWi9NS29PdG9qREVSL2J0VktSc0dT?=
 =?utf-8?B?cWRISnBTVGNlb0dRUHorSXc4OGlkOE82QkdlZXhkV2ExL2tZWHZpRThhOUFl?=
 =?utf-8?B?NndnSGFOeGhSWUlnNzhGdHlKQjB0Z0V1NVRKeHYrMEZwbC9WMnIxenJteHlh?=
 =?utf-8?B?TkhDOWZKSlluOWIzamRWYW5ZdzVUZTgwWjVMU2NuMlhSR2VqT2g3Q0s0dkRY?=
 =?utf-8?B?Qk9yWXhQcForNWx2ZWVabnZ5TERvRm1TMGJwNExURHpqUDJ4UVF5U0hDejAx?=
 =?utf-8?B?VnFsNnZtY01uODRJT3BMait3V2ZmNEdMa1MrR3hJVjNhZDdmUUV6aWd4Q21M?=
 =?utf-8?B?STJVanFZcFBDelprKzhXRXlOWlFvOFp6RnozR1Y3c0FxVHZ0YzliS2h6a3pY?=
 =?utf-8?B?M1htelNlblJGeEkxUnBGVnBGaWFqTjBOZEU1NEdFcmh3ZWROOFlwd0xkWWZs?=
 =?utf-8?B?dWVGb09RanhuT0ZPNFRvWTVldHJyMXdnUFc3WG1NZkxBOGw5NTRnSDUxSll4?=
 =?utf-8?B?MUxPMXpQMHhoWGRtWkVnVjB1ZWVEeHFkZnJsTDRXY3hmY1l4Tkc3enREajZs?=
 =?utf-8?B?TGNJZkI1VW40U2J1Zndrd2ZISDcxMjRnOXYvaGF3MDZnUVVBY0RoWUJheDlC?=
 =?utf-8?B?YW45TnJNdjZYRmFBeGdIU1FxNmZiTk1iUTdEOXdmeWJmcDlTUVJKOWY5dVhz?=
 =?utf-8?B?d3BzOGx6aFVBZXI1UDFTWTFxWkU1M3RVSUlnMFRQT0pZaDE3OFpiZFVBeGZw?=
 =?utf-8?B?aUloa2dKM1JJcDB4UkV2R1V3QXk4TjYrNE03QTFIZ214c1ZuOGgyTXJYckZW?=
 =?utf-8?B?VWk5elY4TmJPbVJwQ1YrRVI4OXVGUjVpNFZSNGsweEhiUVpJdHErdnlSNTdi?=
 =?utf-8?Q?QNeM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3pmY2l6VENkRmJ1WkVwN1ZybTZOblUwWk5Bc0krc0MvRXpFTW5rQTgySktk?=
 =?utf-8?B?UHR0QjFQb0lZOGwySHdtalFnWUNHa0tvYUxLaFVCc3BxK2VXK3BqaGNidFBU?=
 =?utf-8?B?YVpDR0JzODU5WWdrL24rV2lDUzJSZnNVeUdFamt5d2hJREdTKzRLZTVocTRU?=
 =?utf-8?B?dkxvWlVFSkNNeEp1eVc1QUs5blNDQlNTVVZ5b1pNNCs1UWMvRS90VzB3by9T?=
 =?utf-8?B?eGpFQWdKNVJ0c2dhNHNpK3dOYlBaS2I5U0xGY0lSREJXay90eUNaN2V6WUFa?=
 =?utf-8?B?bE53QmpPQ3p0VzlvcCtKdDd3R2d4Q3EzUHlkVWJUMUllUzJFSGxnOUxoRmFH?=
 =?utf-8?B?ODdqUW5UNDBzTmErUFBZZ3k3T3IrRi8yMkxBNXMwTUdaeFo0ZmVJcVlTNCs0?=
 =?utf-8?B?aDM4WERHZWJCaWtDT3dGcnZUWkxyL3F5T1JyRWluZHRIMDNvdlVkTWhTRjM3?=
 =?utf-8?B?cE1NdC8xRXNLa2RPYjVuQWROUzdkdjZUYU9jMTlSY3FPdjJXdCtYUVIrdVhP?=
 =?utf-8?B?QmdteFQyRXZoSUZrZ2ZyN29oUmFPTUN3YlBhdkJWTWk0ODZlaW1NZnUxRENI?=
 =?utf-8?B?R1E1dS9zaHNUN3IwZkJyZlhsVXc2N2lSSXo1TldROU5zc0pNTW1wdVd5VVJm?=
 =?utf-8?B?Q2hoQ3gvYitHNlM2dzVleWhMOStoVVNnbWV2cjg2NU0zYlJ2bVlZSXRCczNi?=
 =?utf-8?B?bE12MmRZa3NpeFVOajlLSXFjT0hDUC80VFBUOU50VHczcXFpSWppdS9IbThM?=
 =?utf-8?B?N2RiNVVHUDd4YlB1cGFORWZXUzhCNmtwaXRpZkZLM25raHRkS1BCbGo5OUNh?=
 =?utf-8?B?cy9LVFI3djJWR09hVEdzeEtVV0Q1TGVDV1AzUGFWazIwM3RLMGtHcWhZdmtJ?=
 =?utf-8?B?SnJtUHYrUnFYOENBaEpHOGlUQzl4RU53SVAyU0E0em9QUis2U2dWek85VTNh?=
 =?utf-8?B?QzhpcmNhQnBuRWRSK0FtMlRmK3orb1FsNUIxWmlDd3FLeDhzeUd2ZzR6L2RE?=
 =?utf-8?B?ZklXNEtoV3ZpNVpid1BSQklBYnRla1lCWFdvOUNiQ0tpL2wyM25PbTZBODRX?=
 =?utf-8?B?aHZHRGdybEZrcXFGTFR5c0FmdkFSZjFpQndGT0xCSkUxTHAxYlRueUU2MWNR?=
 =?utf-8?B?STNsM3loYVQxdDcremIzaTM2ckV0Sm5IWG5EaGJiM3VMd2dSUVpReXFuTGpo?=
 =?utf-8?B?VTJwQmFjTWRsZlZINGs3cUNPUmFjZWovVjNwVXA1MVRkMnBMTXo5d1o5Nkhx?=
 =?utf-8?B?RmFZSng1YkpwRE01VzE0OTZhaVpFbjJHU0dBdTJoRTRWdW54bmNCdS80VWJH?=
 =?utf-8?B?K2hvRUlXNTRVM0J0Z3o4aTR1d0tCeGZrS1dPbWxvenlGSnpkRWg2QzYvS0tI?=
 =?utf-8?B?RlN0NU5paEdmMmRhMEZ5b2xKVXo3TUc1Q0ZxM3dxRklrVzBzOHF1MXhzYmJm?=
 =?utf-8?B?TlB6NHp0cjJtZzd6U2htaXdwamdENjRvUy9FTzNRa1FEZUdzTnZHZkxOSDdY?=
 =?utf-8?B?TXlmajZMc2E0OUxkeEc5aSt4OEFncWNqOHhHeVZlbm1HaXVVSVBsdVlVYU1a?=
 =?utf-8?B?bEVFOExNalRRSnFiMzU1Nlp2cDFiMGxVUFJ0TEFlQjdSb2dWSFpaaWE0U3hk?=
 =?utf-8?B?aVFGeC9qemJTdEhTQzRZbEVsdlR4VVBXZnJheDJUR2I4QWwrL2dWSHhuT0lq?=
 =?utf-8?B?bmdWM3l1L3R0YTJyVzNWOTdCWkkwbGl2b0pKc2hOc29icmorN1FMclRFU2p5?=
 =?utf-8?B?NDFYeWV1SmtzZmI2WWxoR3E5Ylh0K0F6Vkhib1dhR3lkVWc1NE1ydm91TWJ3?=
 =?utf-8?B?ZEUxdFlVeHV5Z0dpa3h5alhLNGMzeUYzVldHalUvZW43dEtUS3dpaS9sS2xM?=
 =?utf-8?B?aERQN0dmcGZwSmlldER1cWM3UWdyLy9ENmR0NzE4T01yZUFVK05hT3ZhYXZz?=
 =?utf-8?B?VlVSMFNQWlBmb0lnRWdTcEJabVFmMitRYlp5UFpQaU5LSy9xcG45cXBiNlo0?=
 =?utf-8?B?aW1SRHJQRytUTGlna1NFMUZpMldEL0xmTEl3M2RjOHNSc3dZenBKeHB6M0Fl?=
 =?utf-8?B?Y1B4dW5DUUd1WUVtR0FKNzd1Y3N4ZHhKaDE0c3pUZ3UxbWVKdWdSb0Nheklp?=
 =?utf-8?B?YVpiLy8xRWFUczdXMXlUMUZ1T1Fjalc1VDhGaUFQSTZ1bTM4b0dwaHdMTWF3?=
 =?utf-8?B?cm1xRFh0eVNCendqRFN1TnFhWVcrQ21OVWM1YVc5eWhyVUxLYXh3VW5wZ0ZI?=
 =?utf-8?B?YkRaOHpHbjVLa2pwM1R1WW44MG1JME1GTGhoY1c4Z2lFSHZXMjZ0TG9NbFpm?=
 =?utf-8?B?dU15ektEellOdndoWXpGRmZHTjdCWU54UzRwanN1Si9MTGpiL2g3UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E2hLuYAXKnUikzPiKTmpURll1uHwfu1p4K3AJig8wuR5r1P85syqwSODzG6SjtyC67TvgD1QGujRuN94dvMy1zmP74C86QBzuhwYq7GhIc5oHNAjhODSUuee3lhf2JUOuy9G8eVz3+weK26eRwnSOZDl9bsf8F28gInjSbCNWPYJyuMYgJNwAEtHg/kIMmy/JiWJ2TYS+MNwxjaJSaVlGFec0LKrn091mcnHnwD/ycxIJSRw80xijT/jggHkolowzxvhtXbflq0bQLNtLdsEOpuw4KpC/TCT0zTcbjYnqE2Zx4k615xSMwg/Auo8mEM84bnGrSkB3bDNEjoZEdreMJZWBtbqFodc3k4LzzM7yuLzf5iicIfCE15LHgEsLbzwZ6QvlPtgydiuo1MT8yXCasoGgzNVX/jn7TWP8aFzjcT52uK4pXQEdn2B0OJgkxGgixO/gXkAER/95kD56kVYk3PgUEp5DVi5a8TZ7Vzg2RgB6ZZxtph6akvTtXMcO5XHmjraCZVR/s133wIOSwNR5syNK9VZhEEsTN59+6jYzy9gg+QgaacKswIPD99LxejVbSUowslr+smUHXJWNMnfqOCuxQfUqwh0ytE4IE2FtK8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 851a6662-7acf-464c-090f-08de6309fb58
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 09:52:45.7410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ui0/yaOkBfzv5s26IES2KFfTCtoUzso76y3fOhUr2HA86pVMODyICkCxSikMN31g8VQW0t06jiGxaruThr5xoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4224
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_03,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602030077
X-Proofpoint-GUID: Jx-p1XT4j-QIXT7Xr8IMa8rNFDiIhafH
X-Proofpoint-ORIG-GUID: Jx-p1XT4j-QIXT7Xr8IMa8rNFDiIhafH
X-Authority-Analysis: v=2.4 cv=Nf7rFmD4 c=1 sm=1 tr=0 ts=6981c571 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=hYTlAxskGH3ehjGLIwoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDA3OCBTYWx0ZWRfX5aA4M+zcUPOl
 bcbOw+jtud0Fl+ESWTe5fYaMcg1qu7GbD8idQoruwwuINXevRSzBXZuQf4bTvDSQV82+zLZ0UDZ
 Fhmpb9lXZtk45aiuhfhJEm0KZIIvpCJjd0CntIwTsSezg4u3AFnHZwXqrqaUa8ccZtyqLBsCTas
 OxzljC0n4JWdq/agFHkpVa4x6izxX+uag6bqLkLaxK9NGgNKaR7YTJftYyO1obWr26r8sRqzQ1S
 ysz7s/8Wovr+CDxzs4boe6TRnTxxcUjsqi2XzRBFx1F8CzDSqgBVnGNsOwiFlG+yrZMSu99R45C
 l7CP54K4KT/okkPdH7cy1N6pPsy+beL8ot8j5p9t0SZ/Nyojn12eHv0mmNVzJB+6+wypxocqVxb
 34DhDsU97i5/TRynuSOqSfPAlY9DYFJwR+pU0EI3Uqten1nk5/gXNVqnJ3PBHdCxzLhE7z/kQ1h
 VaElE1tfoIuW0A4QdacPnCrbY+nEZ4O4c57aGce8=
X-Stat-Signature: 4zrqqr8xo1hoqdgtfw84fceg6mcsnq1t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C82320009
X-HE-Tag: 1770112373-503530
X-HE-Meta: U2FsdGVkX19TGmmDA7F9KwCNUkhjDZratqw+/UXhomTqJ1KoAjk/Zjf0n15l4684hlLNlGoRWbWH3F1gJ7fgvU3CRynqHEEuLnxT0gMSDs41LtXpKFlMfTsft46ay9GW6DZYA4bCmnmNq5I3truwWwc7HMq4OyqTvP1+dMfNvDwPuww0j2G56sjiOaXRM98VCn2vkrAA4jjD8uZpDgX5PY4k9LJc9ex3VyvI/xLmtFlo0irLZuCZFP/G8mc2goB1dRIMFTZKFV3XFXguzPTKnU8vHSBi2mpTxgdE4h8LqZ5bSwDxNft2b4BDOYKrcVZlcjkSOf2y2aSTjnFavatcfcZRiNVMx3nXhr3q9JupkesUa0DxBdQlrcSrSxKnk6ZVmH+ge6mXBUZ4iyUs03ueAC0oCjXIuRa14j6djgCWYayCN5Or1/SwUcjtbNtv3Pg4JiO0PV1ckI9E8ycvex3UJKlJKb4i2jluC7C/+cBXiraV+7FRVX4d6D7Pi+xhxX2FsKIzarfaFsACed3FLYO6RwK6FR9X6NAPAvOfxJOnM/LY7UCeHoAdSdm21q0dLhzjy+U3wmcBju0Vphew00bK7srPiZT+HrPPB2ti/TJp8bYKF3tbZ70dE36ex7fiatawp6yYVS52DRDdFncm+mzbQ1+m4eAWTvBapE8sz8YSdhVRDaoMG1qSSs0A/d7+AK3JUPXnILm7UMUfMaICQiYuC3SVHcZlAha43fNBmAk5P7mbL2BWP3sGOue1FgLZA5aFoOCHadNVVDYoeFn0tL4vxoL/Kak5IGG7ahCjoc5SdzTqVT1XZPXzMAqLrjE8NsNeTPf17Z4UZvv4Hp2wuPB5AfAREEk8oTJFYWAH+2iDPaizkEk8aDz1M7v8DKYtLKCTLKjD3DurYjJBu3Gp+Mq/R36RuGMDWazCCQ1iO6P3ereUTY0mh8Uic7D3Y9ZGJACW58GSsisRhW8b/yIoiaz
 0aZ9YeCo
 M722FxlrzD6obC5TaW9j+LDH0QluTYARwD5YN4EefWLA6m7kg0vBmnTn5IvYHh6Jx9IixI5p/UnzFmIE/4Ewu1WwdZGMY3MQBX8i7tZvPdMVQnI9lCKJD3e33jS/bejGQNG+7lU2pKP+g+Xizpzbkiy1JgO7os7xdKnKatUZfDkbNeSxmASkysHP0hCnKGCLavPxnggJex5OokDtKfV1Engwm3wpErTA0jcrOJl/jA5uD0LKPEmBJ+u8Zfrvwvk5OgwhsXKa1eWeMrlApiKxs8OFMT3+kQC9fuVc/yhlr79FtYJO7QPO8rN/suXiVzA75kWIyLxIoAahJwl9ijz+6FxwCdjpzWBK6JU7ANzBB7PBL2EpblHZg088R9gfFVWl5PJ86o53UqBp7yIulZ9jQNOsigPn39yDG50mPw6KV2TzUy+pN3O7X2vmhWps3T4TlQASokHvWOgnfiST3M+i5UL3rSgPHUbBjuS9EiD4gbDFDm2MR23xgUptHn3usmNBNhWARA6vtPNARIGmLWTz8jUbMBnQWsKDttxCPFUKWDIK0XJjvuOcraPJkzc3PcbUcW+xkmyMQixIlce0q4rV/66loSg1n0UYBc+2YPrNbrXBy6URLbqikdUwsc7hWZcO8Kfr1GREoFuFukABwF7v2HIPxwH1EhPfMrfGpN1ZpZdbUVyuWNzxh2Znf5CxLgCMk6bVF2myJp0Tvt48uXJwzWTp6xhb5C0P243Cdqlk+ntkK5UqeQOEHGLpExcUxJrP3b1zkddasUO6lhucM404zyii6p1AoIrzkzQeseKtGGXuf56k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:47:46AM +0800, Vernon Yang wrote:
> On 2026-02-02, Harry Yoo wrote:
> > On Mon, Feb 02, 2026 at 02:40:14PM +0800, 李龙兴 wrote:
> > > Dear Linux kernel developers and maintainers,
> > >
> > > We would like to report a new kernel bug found by our tool. WARNING in
> > > mempool_alloc_noprof. Details are as follows.
> > >
> > > Kernel commit: v6.12.11
> > > Kernel config: see attachment
> > > report: see attachment
> > >
> > > We are currently analyzing the root cause and  working on a
> > > reproducible PoC. We will provide further updates in this thread as
> > > soon as we have more information.
> > >
> > > Best regards,
> > > Longxing Li
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
> > > __alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
> > > WARNING: CPU: 1 PID: 362734 at mm/page_alloc.c:4234
> > > __alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
> > > Modules linked in:
> > > CPU: 1 UID: 0 PID: 362734 Comm: syz-executor.5 Not tainted 6.12.11 #1
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > > RIP: 0010:__alloc_pages_slowpath mm/page_alloc.c:4234 [inline]
> > > RIP: 0010:__alloc_pages_noprof+0x2025/0x25a0 mm/page_alloc.c:4766
> >
> > page allocator triggers a warning when __GFP_NOFAIL is set but
> > __GFP_DIRECT_RECLAIM is not set.
> >
> > > Code: 10 00 00 00 44 8b 74 24 48 41 89 c5 0f b6 c0 44 8b a4 24 84 00
> > > 00 00 89 44 24 28 e9 e5 f6 ff ff 90 0f 0b 90 e9 f1 f6 ff ff 90 <0f> 0b
> > > 90 e9 1e fb ff ff e8 2e a4 38 09 e9 5e ed ff ff 4c 89 f7 e8
> > > RSP: 0000:ffffc9003ce9e7d0 EFLAGS: 00010246
> > > RAX: 0000000000008000 RBX: 0000000000000000 RCX: ffffc9003ce9e8fc
> > > RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88813fff99c8
> > > RBP: 0000000000000000 R08: 000000000000028d R09: 0000000000000000
> > > R10: ffff88807fffbc17 R11: 0000000000000000 R12: 000000000009a800
> > > R13: 000000000009a800 R14: 1ffff920079d3d0e R15: 0000000000000001
> > > FS:  00007f1784eff640(0000) GS:ffff888135e00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000055bb25a85a28 CR3: 0000000096938000 CR4: 0000000000752ef0
> > > PKRU: 55555554
> > > Call Trace:
> > >  <TASK>
> > >  alloc_pages_mpol_noprof+0x2c9/0x610 mm/mempolicy.c:2269
> > >  mempool_alloc_noprof+0x176/0x390 mm/mempool.c:402
> >
> > the user of the mempool (f2fs_encrypt_one_page) passed __GFP_DIRECT_RECLAIM,
> > but mempool temporarily cleared it, but not __GFP_NOFAIL:
> >    gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO)
> >
> > Hmm perhaps mempool should clear __GFP_NOFAIL as well when clearing
> > __GFP_DIRECT_RECLAIM?
> 
> LGTM. I wrote a fix pacth, as below.
> 
> ---
> 
> From 9131e1b26b1ec55dd38ab08512ed6da0fa7a21f0 Mon Sep 17 00:00:00 2001
> From: Vernon Yang <yanglincheng@kylinos.cn>
> Date: Tue, 3 Feb 2026 10:51:45 +0800
> Subject: [PATCH] mm: mempool: remove __GFP_NOFAIL gfp_mask when first
>  allocation
> 
> page allocator triggers a warning when __GFP_NOFAIL is set but
> __GFP_DIRECT_RECLAIM is not set.
> 
> The user of the mempool (f2fs_encrypt_one_page) passed
> __GFP_DIRECT_RECLAIM, but mempool temporarily cleared it when
> first allocate memory.
> 
>     gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO)
> 
> Make mempool also clear __GFP_NOFAIL as well when clearing
> __GFP_DIRECT_RECLAIM.
> 
> Closes: https://lore.kernel.org/linux-mm/CAHPqNmwK9TY5THsXWkJuYCdt7x*mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

Maybe the changelog could be rephrased a bit,
but overall LGTM, thanks!

>  mm/mempool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index c290e5261b47..679ab4a2cc5f 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -472,7 +472,7 @@ static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
>  static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
>  {
>  	*gfp_mask |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
> -	return *gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
> +	return *gfp_mask & ~(__GFP_NOFAIL | __GFP_DIRECT_RECLAIM | __GFP_IO);
>  }
> 
>  /**
> --

