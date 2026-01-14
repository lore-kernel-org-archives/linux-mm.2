Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB307D39003
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7246B0088; Wed, 14 Jan 2026 13:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4E36B008C; Wed, 14 Jan 2026 13:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061416B0092; Wed, 14 Jan 2026 13:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E705D6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:02:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90E48140566
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:02:39 +0000 (UTC)
X-FDA: 84331339638.11.C536616
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB498C001E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:02:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lC4jcmYA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nlF6o6os;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51lGzrBDAI5qqrFaXoVjaWErHz3cH94Xi+iLRi0jArQ=;
	b=PGFeHq0GEFRZJlq8eQa2YnBVoA+yAl6qUOCADbkUD5pO3K4Nj0DfQV3oAV2hLzWeerGBVW
	lDPvdC7EsQmJ7ssNadsBUNF5d+Rhcu+U8JnX+ZkU7hMz++n/guInzMmlfjgJHh5x8lQcdx
	+n/3iL1x+GVJ1jp1PnLQfc1oUVstoCE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lC4jcmYA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nlF6o6os;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768413756; a=rsa-sha256;
	cv=pass;
	b=2UQATucZXkhga4RSWM+aSz4bXDEVNogeW7N62pXP5tMsI57Y+FWmad7IBxl5M2jDJawr9T
	INBUFvjKjnU9ryxs9MbkW/0PsYCNYXs7CuyXDvyZ/cB6jlQk8IBX2olBvXZGPqNrvRaDCn
	4yhglaOZ4NajRwyPid6SGtrgqXap6EQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6MUuU1296941;
	Wed, 14 Jan 2026 18:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=51lGzrBDAI5qqrFaXoVjaWErHz3cH94Xi+iLRi0jArQ=; b=
	lC4jcmYAmXagmjbT3B/JzHEmhG5Qph37Sh+jShv4QPgmAZRMy86jj5ToM2VVgCjt
	H9KXKWHvftK7EVGAUa/X4NLQufeyeRi8gulsw+1YRgQ9FqgLZ2C0AvtHCDZsXGvA
	GjHczt0ylBDYRN3M/8Z4yj6G4zTeCypnrZusgTENeHDvVjiiwvE/xgtCyxrIdsrX
	jJ/CPDwo9xLAsfwJOzlkoAYYLz7efR25PoP/gQXHla39IOGgq0lWFL6W3sa5jzuC
	CNdIOcmAx2mkUSlqNDoLLAsQrQjgVO57KCGcC88k3oiRK374Z0cMhWKiQfVst9bb
	gBhSS18ci5lOl7s3bJUODw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc0ybk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:02:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EH0FKZ003564;
	Wed, 14 Jan 2026 18:02:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ab26v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J52JU2TGfMH3HEvPKP5v3N28J1AsS9fD4YXhEqdQpoiFmhtQZsXr8LX2Jr+j+LylFZLggRge1pmU2zmWlhHJLrYJ1W0GfKgJOWUh37IC98q2b5hu7KPZfHDzbpodqY/mnf1dCljYFf+2eqru6/L6I0RKcigsMek/VCOmNdU+qn3uJUXkIpQSHP1SFx8UGtdMhZCcPRVl9Fd3+34pbUkkBYvSL8zIJv+xShEw4LzPJr3mTgG9nhTlbKvqHOxKytYAaWOHsAb41FluUu1IAH1QVVD0qL3mPSQ4IQ8fRIha731VEmqynwciSUg46pQ3RvguW1AOPK9Ek6TRuzMIg9RJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51lGzrBDAI5qqrFaXoVjaWErHz3cH94Xi+iLRi0jArQ=;
 b=b8+t9VdhlF6mvswBKJU7K6Dq1QbKWvP5jVkHvcNoCsxSQw19bjeh2VKK5KW6OFfGM0GmT19BU1caWfj9oXdnIO9mTGNjv2Cx5Zk1WhYy8u4C00oOwWzMkDqqSRy+1su5W8UunwdA87mu0R3Nd8RPjDXnjMFHavLN7PT+q/jWhP2lQGKyZJMqO1FYR5acSQDLdfEqK77ckKLkR0uIfKvOskSLvddW/mszkm3XXCC+LqbqIaOmEK8XYencrn/8Bh6PPx1SIfLKzu1v4R3j7Ja2o7pHhGcQwooCm9N1JcF/YCub4FoXhkqpzP8Kmgko7SBvEZYFw+Fh+FjLZt424iBzQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51lGzrBDAI5qqrFaXoVjaWErHz3cH94Xi+iLRi0jArQ=;
 b=nlF6o6ospfRwiClZls1RFsg8a1FmuDoIMZ8lTdlP9MhscUI/JXIgTQMcwByLpZ2LmUSQQxHwOxzbda2Y59purFOs02QqXdGYlSDJwNHg9/Ogdxptrye3QMS6qqMoRYitb6LzSnmOUi3QazmEyc/XZ0bN6ze0/XC4o8zkT/N8yU8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6015.namprd10.prod.outlook.com (2603:10b6:8:ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 18:02:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 18:02:17 +0000
Date: Wed, 14 Jan 2026 18:02:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        riel@surriel.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare /
 __vmf_anon_prepare
Message-ID: <96aec792-7d10-4dfa-bf35-cc94300f4d2b@lucifer.local>
References: <6967c517.050a0220.150504.0007.GAE@google.com>
 <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
 <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
 <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
 <CAG48ez3+t-uv88cUhG6=YfMyRVW5REi3-aaW3a_yXSZDK38_ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3+t-uv88cUhG6=YfMyRVW5REi3-aaW3a_yXSZDK38_ow@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0349.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6015:EE_
X-MS-Office365-Filtering-Correlation-Id: 84d5668f-625d-4c45-1d63-08de53970e0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVgrZDVBdDFESHp4UXd2QUxHUjV1MDN0aWNQdzRaNUlrU3dFbkcxcEh0NnhV?=
 =?utf-8?B?dTlTbkxwTUQ0QWlZNStPTlNOZFhlVys2ZHYzb1dYbzlwY2FUTmlSMTdOa2I0?=
 =?utf-8?B?RWJFVDVYVlViSWZEVFdDWURxZzJwVnpRNkpMSUtXdmNLeE55WlR4T1I5OVpw?=
 =?utf-8?B?SWhJZnZkR0o2MGkyRWtHK292QytLTFJrS01tTkpjU0pSUlBpYlgrQkxCamxM?=
 =?utf-8?B?OXBxV2ttZm51a0xldTVZdnM2WGt2bHIzUWNwdWhSeDEvSVRQSE1Gd29LbFgv?=
 =?utf-8?B?dm1Uc3ZYYmdCQi8wMlQwQmN2ZWVLenJvdDF4emJQYU9hMjJ2OTRLNzVObGJu?=
 =?utf-8?B?TndlclNyeG5kM3BWN3l3Y0dRdTRPZUJNa1BlUFRLQWVmcjdPVnRkcU4vSm96?=
 =?utf-8?B?K1diOEtrK2x6dXhPWlpTY0diY2wrS292TzdPbUNPS2pvMGRDR0Foa0FGRzNN?=
 =?utf-8?B?V2RQb2lHTWMrNElBME1hMFlFc3JYYlFPWGdBK1ZoZEJJSnJjQW10Y1hPSmda?=
 =?utf-8?B?T0lsbTNwVnJTMmJxd3dyNVgxY0k0eHl3U1dSNUpjeVp2RzNoRjIyT2sxMnNY?=
 =?utf-8?B?bmwrMTNUWS9pM1FERFpNREIyQzlPL2FyUlpiNGgycEVTcUExUDhzampzZnBm?=
 =?utf-8?B?VGtOTm9zQ1lVRTFIM0lQLzZtSjF1WEtXRUp4R1ZEaThpcy9wZk5lejFTVCtu?=
 =?utf-8?B?UHZkVDRKRkVzMklYMHpTZmNwUkh4YTJxMEtjVVh4L0ZjMTdJY0ZkOHRJNGlv?=
 =?utf-8?B?N1ptbUZVTVIzczJyVkt2N0E4ZXMxTHRTTTFRT0hPYXlkSFpNWGFSNUhJSGwr?=
 =?utf-8?B?SVRCNFdyMnBkV3R6TFlxMlI1Y0NXTWtWeGkrRXl4WnQrS3lPaUxDY2ZzR0do?=
 =?utf-8?B?UHRaaW5meC9TaE5oSTcyLytFbmFVZndhT1ZFRENOaW1ma0E2b0YrU1JWUlBr?=
 =?utf-8?B?R2JnSjQ1NVN6R2FkWlZCeExrTE1xeTFQbVhBZVNjUFI0TUJadGtaZDI1TWg3?=
 =?utf-8?B?cEQxVUM4azMxVzRoZERzUk1BdGJhMFJjYzZpV3k2YXVselNTTHdqRC83aWtL?=
 =?utf-8?B?UnBkRCtlb3Q5Z2ozQjN2MUIxejlZUy9uTlVVUTM3RTVQQWVtRjRnNkhQemtV?=
 =?utf-8?B?Y3YyZE83dE5neDZXLzJMRklMakc5UG1KQmE1Sm1qRUhsSWZsYVEvb1ZWODht?=
 =?utf-8?B?NWV1MGtxQW1vNUpwektlSXpBU1JvOUhiSzhrK2hKd2JQaWZMRnNBY2xBVUVZ?=
 =?utf-8?B?cC93L0dYTXMxcTYzQnZkVHVPSkhic2hGUElSZzI5WC9oc0kvOG91MWxJbEdJ?=
 =?utf-8?B?MW82WXhQbm9OTERCSzFLZG5pRndkdVl4cUhud0J1TGVCUUpnb05hNHNDMXVL?=
 =?utf-8?B?S3VHYWJWbjhydHhlMEFmcUl5V0N4OWtNMWhQNXQ0aUVSY3R1cCt5c0NKTFl0?=
 =?utf-8?B?UjJwdERidlMyZ0ZDbGhTYktqc0FnSXZqcUhOaG4vSHlnYnVIOUNsVWxrVDNv?=
 =?utf-8?B?alo1OGNKQ0FZRDdCSnpELzM4clFERDdmN3YvejFXTWg0b283ZEdUUUdnMHRM?=
 =?utf-8?B?UGpWNVVrZ2piTitBWHhPU3A2d1BEOU9sWWNkbUtHM05pODExS2dlNXdkWjJU?=
 =?utf-8?B?ZXFrcHRFVHo2VWsyc0tKOWdEeDJOMEhEdksyTjhrTHlrZkNxMEJtRHhkWjZE?=
 =?utf-8?B?aDQzbllNeHIwdjdNMlUwUFhneFpuUUp6QTlpS2JheDM5NUdYVG9pOUp0b1NT?=
 =?utf-8?B?VnVaOG1EUWJLYlBoVGh4ZU5FcjliN3R1RHNOUy9aVjNUTngraEx5QjZxK0RF?=
 =?utf-8?B?b1dtQVpyME5DTlcrY1BDVHVSWEdlSUJzWVZwVFVtY3FYRkZRUDdIOUp0UTVz?=
 =?utf-8?B?dmNkV3lUaTlUTmVhY2daOW5GVVNmeUQxanZTaXYveFAvZjlxZUwvaDY3cGd5?=
 =?utf-8?B?bVNVMlZ0ZHZPRkNCTWdKMUpSamdWVHRGcHJvNzZCRkRhdlltMlVRazk5MkV6?=
 =?utf-8?B?K0Y4T1FtWVFlRHhnU2phbkxVbnJ5WlR1Nm1mUGNmTk5zUHJqV2piSlR3V3dD?=
 =?utf-8?Q?RR99lT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djVaMHJpTHNCcmRZek5mclJSc2pVU2pPbm1KdVlsOTlodDd4a3plNUFLai9q?=
 =?utf-8?B?WG8zZVh1dDNQVnFkak1seXAzOHJMOXVpZnk4NGhjNHVSaUkyNGltaURadFph?=
 =?utf-8?B?WXJlZFRocW9TeHlsUFg4UzVyQnplTklyL1lCeXRFYzRzeDh3cCszL1BpQW1q?=
 =?utf-8?B?eGE3WS9hTm1RbjFkTUhyMGo2aFFTOXpPc3hYNXk4eG1wQlEvMGxZcndOQTlM?=
 =?utf-8?B?Ujdkekppb2NtbVlkbzhqaVVpb1FqUithNUYvNjBwSFgxNXpLK0lXOWhhQ1FG?=
 =?utf-8?B?cjVZTjlSTFIrSXNOQ3grL1hMdnIvcUtJSnpkbDNXb0tRNDRHUWpPZlkvNkdL?=
 =?utf-8?B?Y0NvNVljN0I3VzFCZkgzeFFBb1l1VWxiNnd2Z3RNODNVRm1XOHh3T1NNeGZC?=
 =?utf-8?B?WlJPTCtjU0IrWlhyQmV5bzFBL2ZXeDRvRDBiK3VaL2ZBbGxIU1M5QldZSW5z?=
 =?utf-8?B?SWtFUnRTQ3dYanJ0RHdCU25JMU1XL3djdU9uK3BPVVVHOVNBY1ppbFNja2NQ?=
 =?utf-8?B?SXhJeURJRWFYUjdGK2VhWHhua2pVNEVLaXBMb1JjMEtpVkUvT2xkcGxLYjBX?=
 =?utf-8?B?K1VyNGNaMXdsYlViMCs1WUU4Vnk1SE4xemVzd2dkcmhyOVBLYnhnY3hxQ25q?=
 =?utf-8?B?NU8xTVBSMGl3U3BRRStNODJvcXdNWmJXRHBuclhNbW55VTZEQ0I4dDczOUZ1?=
 =?utf-8?B?V3owTDZEUFBoQUM4blFjdjV6NUJYdzF5ckh0MFRCb2d5M1d3Nkc1ckdzTmFW?=
 =?utf-8?B?WWk3eGoyT2lkc0lBTnBkTFZPSjVDZTc0Yi82TU9nMVdYNTJPU29BMDVUdS8z?=
 =?utf-8?B?MlFwZ3o4bDBuem4zOGNEbzFpRjROWGN0OE10MHFDeW1XLzVlQWNGbDVuWi9L?=
 =?utf-8?B?bE1TNDNiaE9hY3lGZ00zQldXbnR3cFFjaFhBODhUWFRsNkVHby9ibWtzV3pa?=
 =?utf-8?B?Mm0ycWVXNExNZHphT0M5YXdISGNPb21iWk83ZXowRnc5d1JpZ05PMFJlc1BV?=
 =?utf-8?B?b2ZmM0dzZVgweUdLOHE3SEFzWnB3L2FpS3NRQzRabVA5L1YzQlFlV3ZPbHlR?=
 =?utf-8?B?cXVzeEg1enY4ODJ1Ym9CVytiSzNoT1hRRnNlV1ZFdHBwSmNZM3ZTNGx6MDZY?=
 =?utf-8?B?Z3pnUHFpYm9oSGlVYUpoUU5meXl1YnltV1JLUnZjeUxZWnZSbWpnUk4zNGFZ?=
 =?utf-8?B?c0hXaTgrUEszd3VPS0Z1TXY3aHBwU1lmbHJTMWY1bTBaVmYweHEzeHM5amFh?=
 =?utf-8?B?WDNrRmhWVkp3dzBsMFA2MUt0aTQzN2VML0RBbW5kU3gyenZrQzhjNC9Nai90?=
 =?utf-8?B?aW50WUFSblRYbVovMTBzM2JKaFhtbG4waGRTeHAzQzN6aThibHRVTVdseUFD?=
 =?utf-8?B?YVlteEV4b3hwaFNnUWZnb2xMZGpnNGEwZWppUnlXVXZjTmJEUmhBUUg5RHNk?=
 =?utf-8?B?cDhCd2FqNEgrL1ZMcDIyUmMwM2Zac283d2ZkOWdUbWJGZ2QyVzlCOEZoU3pp?=
 =?utf-8?B?RFkyckNkUElabEpaaXAvT0lYeU5sQVVGbXZ5UXFIWGpxUE1qZHVOaStLOVdi?=
 =?utf-8?B?SVhka1E1a204YkFueGVVWThzeEptYnVLcjNtRy82dmZFWkJrck9jdVFNWE4w?=
 =?utf-8?B?bFJtaFlTQXdSaXNSbnJOWmN0aUJwUTB4Q1FzWXNkMWNBQ3VUSmt6Z3F6T2dI?=
 =?utf-8?B?Y3ZOYkRETkhRVEVzL0poeHdQWlVPU1BwTWl0eVpNQjJya1FYNGFJakM3VnBN?=
 =?utf-8?B?eno3SVJ4QUErZVdDL0IxZUU5N1RaRGtrUnZwOUYxRTJucENlaW9RYlNMeGZj?=
 =?utf-8?B?SEtoQlIzREJPbFdKN1ZoV1YxR2Y3b0ErUllYYUZwdmpLNTNjK1l2dUJJSzJm?=
 =?utf-8?B?a0hteUZvQ2lhZ0Fod3p0RERMOWQ0NWdKTDBlQ0ZYWEMvMzM1NzJZM21keWNJ?=
 =?utf-8?B?dUVKQUc0WnBLVTZPNTZlaUUxNUc3NUlpanpVN2gxcGxQb2N1ck9Yd0JOMmF6?=
 =?utf-8?B?K1FpZXBGTjRPbWloODBWVTdvYnE4WmNXR0V5b28zbjVUSFFXdURUd2Q4bnhG?=
 =?utf-8?B?YUY4QTdubXh1RG4wc2hWVDJPeUFmWE4yZVNJdVhqUWdTSkxaMk1jNGlWV1px?=
 =?utf-8?B?aTB4WTBWYWhlUXprZmprNWpKS0NXSlpZVExZZEdCZXY0dFVIbFBuL3hkMTMv?=
 =?utf-8?B?QVVNMVoxMlJoNlZ5V2dJRkJGcE9XLzdGbnVEckNpOGxxeStZQ1B3NHpWRzBo?=
 =?utf-8?B?MllRYzAyZW16b1hib2tKTkEySm9HTWZwZ2lwd1o4RWhJejBMVGpZd3dEMktL?=
 =?utf-8?B?Z1hNTnhDN3VUUXhTMWFCVi85amNRKzdBaVJVcFVNakJLMUh4UzYyMVdScVM1?=
 =?utf-8?Q?YHTKwv1vMhYhKvVc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YFceymZ1p+XuT/5FUpw/U7iqXHQhPW6WkGcrimu2TWybMizvrrOR9/jHEehtuZwuvN5JDvuP1SEyLWUW9fzZfD+1AGr7YC8wQKkyg6yYdpDMMTz+JeKlllOFe1tNByEMPJsWe3GND5th/3OQ50z7VAIkWa7Y5STEqacmd2JvJ+0aNOudH/TSaQXsF6bzlqhd1iTb5qjz3ulImd5kEA3c1qcVAukFT1p1GE5DDe7LGWTzu77hEB2uyIiGy2A+xu6wiHwwpCpGtrVzAzi1ZN7USgmAi6pD+CGNs37A6dFtyZDfQl9SuRTGcuX4Cg8/0cvSeQTweNw+m3PUopTLUrPwwQdWfVexung9TEXyfBxiZVr7Rk4Vw5EU8WmUizghkanzrO+o6hoWTHEeqfV5aq7XK7wkNN9YR/P3wsby4Tv0/KmQ5YECTlWmTEqeuA2zrVefzB0ZEQdxV4cBcE8Do3zGDkGbXjrU5QAZDpSeLBfP7Ia5e9gO4QED/LSv95QJ7Wmww1vKcx5PBRhzkpM/Ad7BaZ1Kgs1y4VrNECCO7nGsMCpa9fcpNTT/TK463JfP+tcH8w+3TOa23a/qbqkMc9Divky58sCFKTSIPv6i+rMA3Kw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d5668f-625d-4c45-1d63-08de53970e0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 18:02:17.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gv716hAeXIfsy177uxAvPZOJv9d3zG6z4/Dvx6yIXgbeSLbncDua9bwRVk5V/PfV00kjVCavFlp5KDVkghHPrmkrmfVp149FQHGofvfKFFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140149
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6967da2f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=P-IC7800AAAA:8
 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=QZv_YxEV27eGYewEq1kA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: s6SKI04t90sVoTYsZKLOTjHcsHkObVRm
X-Proofpoint-ORIG-GUID: s6SKI04t90sVoTYsZKLOTjHcsHkObVRm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE1MCBTYWx0ZWRfXxDUxbWPoUC76
 iqjmoRbo1QiogBn89LwvxwBkoZ0dDF6+TwDUeBToIrTGVmBnddlJtuaubEmdbekr6xOb25jpC4L
 Zbcgn8y4CRoc4ZLRF0pc8qD9H8kuCg3zvLuw7pvvcpIf3X7SgcZ9eo+hD4PiS+AAKC6nTcfZGMh
 1pu9azG3IpEK9szaAChqWObl/Me7jpsrC0oJoSAl9IfSbgNrI+ObgRviPeTQo52cZHw+PVNgHGT
 pnBdh/oLct36ORmrSrOJUrPuDtE80U4SeICvQ9qOK3mnI4RrpCKvq3CUvugWE7EMTslI9vR/EDg
 TZGv10tX0ZpRqk9+sfobBo6WbRXM/jXr5trrVfEa1DY5yfZCocoQYAzKSrHYS/AcuxB5Ose0xZs
 xUI2idx75daXfh/gqg3XzwiJjHEy2X20xbv6K+aBCgVPDu8xqJ5KKwEb6mjQ69l8jYSg7zlfS4o
 n/7sN+6Kd8MqHETI7zw==
X-Rspamd-Queue-Id: DB498C001E
X-Stat-Signature: oxczt65r71sczuhb1n8osk9rt75gzoje
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768413755-940693
X-HE-Meta: U2FsdGVkX19gtzBZoXG6+tjoLKnBqHxe7tdtknfT8hBOs8piT7EAw9DMWxOXJiN3Q/a+TePPGYmD3NCbKOKae/n3uGy18/s3A3XXD52qa5zO3gLmQ9po5OA7eVlyy2LFWff1FGvPKtkClMtJxPslpXhsSFe/btv30VcFWlt9c9Wnco4hgj3G6xU6BHR+Pb9AbqPb74zZFUTbJOppbN3KZkOaMZ6KH5s/2zRgMnMO4uEWEIxHO66LPGGfHIpOHOTjz+QY3VIbc1KfJSy7M3ogUEGnlMafY65hmlSeouV98eHLqwNMxuLSeRj3vcStQx4Aej/87EPX0SUPiots13dgKa/MBQ+geSv6XLMzbp0M2WBdTmpq07vBTOZbJFPw2lQ0Euza9/UAXfD54T2KQGxJXscwd5fE2iNv8OWnVqTnwYymnbLA5xMfNkm/5dNVUa4qkrc8WHJ6VKwA9YHwTBN9RCihiJ7fbSO8FV9MzWtPxRp3+71bqry8X+QQY87L7prE70Ix1va0Q0JYBjsDPGE22ph19Mhx9EiZ4GfnUhkpnPn4DaM79Z2SzOuZdabQujtEhfsA62xiTWisDFTcMOQrDyJ97Kw4mJI48AcurDU6TiX0EP1sVr8iOb6S2Z3/Zg+puIXoHppMmTrI44S7Y2EGdg34fTYRyb+0lBAtwyNfz9EQIKfJsdSglEjXIsv28oCaYN6prSSjc2ob4kANiKt91A3o3oiRDXQxfBabz5MG9Dcq683Dl3iqXSpvacBcnWSbN0NVf2iEMzocje8KagvUDsS7743d7Ot7EDUW7vcqy+bXEO+CaeQP7IyEJyZejcPLVQkQ48xpy5iAborOX0G5NdcTWVTRQMIp/DoSiLn5o18ovdo2nxQZHBBuKi/9U41lZsk6m7ZFFmg2taKqOzWDPoKIQn0PG+BNHPMDNTC+W7D2+02uDo0yWym4mKsTWfYmvqFTEnfS536IMpETZ8h
 U8oI89rY
 uHjw1If6bBbRftAlQzLNCagjDlqHPklmlURHfvpksp6IIT6TXX4E0r6IXt0zyDxM1bok/Fcw+eir3gCakUF19v4YzzMZn9kOUIn/W8AxT2gC51yg/AeDwAmqHP9HWIHVNScXxCCjzmdmU9gF8LmCIMC4g2C0xw0vFUF9SThmbEs/f8jKMOS6EAFqrQvjEYgw2MGOukvg//mMwh/Ios1k68dk8AKIDAgMbL0ON+T/hQG4eyu78SFlhICW0JLJr7Gpz8JkKiCNeoMS7tBLPaqB6PL02R8PwDTwKaWPWmeNmNgSqg/De91cA4r9FTteMvdpDh3YWCqswXpdKnIcqhLqfJHty7/W8dKruwQlVP3XC0w5wai5qmc5+SJ+oM8iZWugs70wjSscX7WQ8fOZdPG4sYqGRbrP++aeGKfasBAoQKq6qVeWQ4G2b/vcQCubYQzmBnX6Q8Yi3ZRc2gCSkSPlDsiwQ8OX/zU/nLmzNmpEh8YovgKr+ClRUetyxIdRx6yuxAU/sFCf+spuoIF03je1Iy0YfjFxxZbswhPTi3MLXMTr070sU5n30N5Cdxo85TePySG95llRZaG2eUYb2Z0wIlBw7Z5fGUNkZc69KFjkf84HInyllh49TSCNKlFkYSzgROE37l4w1jRCz24cU1bSvjmDTMSWCwlBZecY3tXybLNzUGqoCcN4wPo+IJMjafz3aCxhTiLDcaWQdOs4fQNYiW/Ag69P/9FMCUEiOE0Y27BJUdFnDwBQTctJMYDVD3TAgvclZkcgEYd/PDy/5lOqhCNhhBsRJ5AvkKz5Xjzow9eEL4xJ//68wEZJzTeOSkJRVMfjejHgA71x0N+IU5q3dtasvndFXBjMNS4edu37pxGZCs7DZe15xzXNl376TslAqkx/hxeGsdWJ/tGvSBsOdYTKa1LK1Z/ZVPfdVNUpEI2KeinbDLT6I0DWX7PjGkfmvD7PaNUtOxtFvnQJXWK+HGKs91Zxy
 +r5pc7hP
 fB2Pnv2SZ8r9Znb1ZCcamCkGj/gnTZpI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 06:48:37PM +0100, Jann Horn wrote:
> On Wed, Jan 14, 2026 at 6:29 PM Jann Horn <jannh@google.com> wrote:
> > On Wed, Jan 14, 2026 at 6:06 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrote:
> > > > On Wed, Jan 14, 2026 at 5:43 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > > On Wed, 14 Jan 2026 at 17:32, syzbot
> > > > > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > > > > > ==================================================================
> > > > > > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
> > > > > >
> > > > > > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
> > > > > >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> > > > > >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> > > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > > [...]
> > > > > > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> > > > > >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> > > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > > [...]
> > > > > >
> > > > > > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> > > > > >
> > > > > > Reported by Kernel Concurrency Sanitizer on:
> > > > > > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W           syzkaller #0 PREEMPT(voluntary)
> > > > > > Tainted: [W]=WARN
> > > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> > > > > > ==================================================================
> > > > >
> > > > > Hi Harry,
> > > > >
> > > > > I see you've been debugging:
> > > > > KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> > > > > https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.com/T/
> > > > >
> > > > > Can that bug be caused by this data race?
> > > > > Below is an explanation by Gemini LLM as to why this race is harmful.
> > > > > Obviously take it with a grain of salt, but with my limited mm
> > > > > knowledge it does not look immediately wrong (re rmap invariant).
> > > > >
> > > > > However, now digging into details I see that this Lorenzo's patch
> > > > > also marked as fixing "KASAN: slab-use-after-free Read in
> > > > > folio_remove_rmap_ptes":
> > > > >
> > > > > mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> > > > > https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com/T/
> > > > >
> > > > > So perhaps the race is still benign (or points to another issue?)
> > > > >
> > > > > Here is what LLM said about the race:
> > > > > -----
> > > > >
> > > > > The bug report is actionable and points to a harmful data race in the Linux
> > > > > kernel's memory management subsystem, specifically in the handling of
> > > > > anonymous `hugetlb` mappings.
> > > >
> > > > This data race is not specific to hugetlb at all, and it isn't caused
> > > > by any recent changes. It's a longstanding thing in core MM, but it's
> > > > pretty benign as far as I know.
> > > >
> > > > Fundamentally, the field vma->anon_vma can be read while only holding
> > > > the mmap lock in read mode; and it can concurrently be changed from
> > > > NULL to non-NULL.

Well isn't that what the page_table_lock is for...?

> > > >
> > > > One scenario to cause such a data race is to create a new anonymous
> > > > VMA, then trigger two concurrent page faults inside this VMA. Assume a
> > > > configuration with VMA locking disabled for simplicity, so that both
> > > > faults happen under the mmap lock in read mode. This will lead to two
> > > > concurrent calls to __vmf_anon_prepare()
> > > > (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623),
> > > > both threads only holding the mmap_lock in read mode.
> > > > __vmf_anon_prepare() is essentially this (from
> > > > https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623,
> > > > with VMA locking code removed):
> > > >
> > > > vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> > > > {
> > > >         struct vm_area_struct *vma = vmf->vma;
> > > >         vm_fault_t ret = 0;
> > > >
> > > >         if (likely(vma->anon_vma))
> > > >                 return 0;
> > > >         [...]
> > > >         if (__anon_vma_prepare(vma))
> > > >                 ret = VM_FAULT_OOM;
> > > >         [...]
> > > >         return ret;
> > > > }
> > > >
> > > > int __anon_vma_prepare(struct vm_area_struct *vma)
> > > > {
> > > >         struct mm_struct *mm = vma->vm_mm;
> > > >         struct anon_vma *anon_vma, *allocated;
> > > >         struct anon_vma_chain *avc;
> > > >
> > > >         [...]
> > > >
> > > >         [... allocate stuff ...]
> > > >
> > > >         anon_vma_lock_write(anon_vma);
> > > >         /* page_table_lock to protect against threads */
> > > >         spin_lock(&mm->page_table_lock);
> > > >         if (likely(!vma->anon_vma)) {
> > > >                 vma->anon_vma = anon_vma;
> > > >                 [...]
> > > >         }
> > > >         spin_unlock(&mm->page_table_lock);
> > > >         anon_vma_unlock_write(anon_vma);
> > > >
> > > >         [... cleanup ...]
> > > >
> > > >         return 0;
> > > >
> > > >         [... error handling ...]
> > > > }
> > > >
> > > > So if one thread reaches the "vma->anon_vma = anon_vma" assignment
> > > > while the other thread is running the "if (likely(vma->anon_vma))"
> > > > check, you get a (AFAIK benign) data race.
> > >
> > > Thanks for checking, Jann.
> > >
> > > To double check"
> > >
> > > "vma->anon_vma = anon_vma" is done w/o store-release, so the lockless
> > > readers can't read anon_vma contents, is it correct? So none of them
> > > really reading anon_vma, right?
> >
> > I think you are right that this should be using store-release;
> > searching around, I also mentioned this in
> > <https://lore.kernel.org/all/CAG48ez0qsAM-dkOUDetmNBSK4typ5t_FvMvtGiB7wQsP-G1jVg@mail.gmail.com/>:
> >
> > | > +Note that there are some exceptions to this - the `anon_vma`
> > field is permitted
> > | > +to be written to under mmap read lock and is instead serialised
> > by the `struct
> > | > +mm_struct` field `page_table_lock`. In addition the `vm_mm` and all
> > |
> > | Hm, we really ought to add some smp_store_release() and READ_ONCE(),
> > | or something along those lines, around our ->anon_vma accesses...
> > | especially the "vma->anon_vma = anon_vma" assignment in
> > | __anon_vma_prepare() looks to me like, on architectures like arm64
> > | with write-write reordering, we could theoretically end up making a
> > | new anon_vma pointer visible to a concurrent page fault before the
> > | anon_vma has been initialized? Though I have no idea if that is
> > | practically possible, stuff would have to be reordered quite a bit for
> > | that to happen...

As far as the page fault is concerned it only really cares about whether it
exists or not, not whether it's initialised.

The operations that check/modify fields within the anon_vma are protected by the
anon rmap lock (my recent series takes advantage of this to avoid holding that
lock during AVC allocation for instance).

This lock also protects the interval tree.

> >
> > I just noticed that I tried fixing this back in 2023, I don't
> > remember why that didn't end up landing; the memory ordering was kind
> > of messy to think about:
> > <https://lore.kernel.org/all/20230726214103.3261108-4-jannh@google.com/>
> >
> > > Also, anon_vma_chain_link and num_active_vmas++ indeed happen after
> > > assignment to anon_vma:
> > >
> > >     /* page_table_lock to protect against threads */
> > >     spin_lock(&mm->page_table_lock);
> > >     if (likely(!vma->anon_vma)) {
> > >         vma->anon_vma = anon_vma;
> > >         anon_vma_chain_link(vma, avc, anon_vma);
> > >         anon_vma->num_active_vmas++;
> > >         allocated = NULL;
> > >         avc = NULL;
> > >     }
> > >     spin_unlock(&mm->page_table_lock);
> > >
> > > So the lockless readers that observe anon_vma!=NULL won't rely on
> > > these invariants, right?
> >
> > Yeah, that stuff should be sufficiently protected because of the anon_vma lock.
>
> Er, except it actually isn't entirely, as I noticed in that old patch I linked:
>
> @@ -1072,7 +1071,15 @@ static int anon_vma_compatible(struct
> vm_area_struct *a, struct vm_area_struct *
>  static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
> struct vm_area_struct *a, struct vm_area_struct *b)
>  {
>         if (anon_vma_compatible(a, b)) {
> -               struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
> +               /*
> +                * Pairs with smp_store_release() in __anon_vma_prepare().
> +                *
> +                * We could get away with a READ_ONCE() here, but
> +                * smp_load_acquire() ensures that the following
> +                * list_is_singular() check on old->anon_vma_chain doesn't race
> +                * with __anon_vma_prepare().
> +                */
> +               struct anon_vma *anon_vma = smp_load_acquire(&old->anon_vma);

Yeah I'm not sure this is really hugely important, as this being slightly wrong
only leads to very rarely having slightly less efficient lock scalability.

>
>                 if (anon_vma && list_is_singular(&old->anon_vma_chain))
>                         return anon_vma;
>
> That list_is_singular(&old->anon_vma_chain) does plain loads on the
> list_head, which can concurrently be modified by anon_vma_chain_link()

We're no longer using that directly as per my latest changes :)

But I don't think it really matters.

> (which is called from __anon_vma_prepare()). I think that... probably
> shouldn't cause any functional problems, but it is ugly.

But yeah this seems pretty benign.

Thanks, Lorenzo

