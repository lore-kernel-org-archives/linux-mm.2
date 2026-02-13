Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F9BEDF145
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 10:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92BBB6B0005; Fri, 13 Feb 2026 05:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9886B0089; Fri, 13 Feb 2026 05:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C156B008A; Fri, 13 Feb 2026 05:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB376B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:10:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6EE013AD4F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:10:09 +0000 (UTC)
X-FDA: 84439012938.08.AA8B686
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013007.outbound.protection.outlook.com [40.107.159.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE9AF100003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:10:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bML+29kq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bML+29kq;
	spf=pass (imf14.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.7 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770977406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHGzgu9/onA951FTWwWWPMRHwsQT6y06mEiZEyOc9wA=;
	b=MiOb78QKnUk5xKwL/74usCIFvzrsvNjbTFWBHoZVBJ+W+melxninsqMgVpmj9qjpoZb5WJ
	SEiim7vpFlfXiYf0obg+SQ3USyQAtYSDuabAKJAW0kXmmS5KBNdKD40J4BtrtGrXcgyUTo
	vq4sE/qGIpn5j01R2zRRw5nP+x3emh4=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bML+29kq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bML+29kq;
	spf=pass (imf14.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.7 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1770977406; a=rsa-sha256;
	cv=pass;
	b=RDzbagS/2dosIJBowA4oH+yQUG31jAYFki1hFpkl8pLQPcddFkiDgYEwP+lN/Zd5h6OjnD
	D3i1xx7YFzCPl+QwMncz8QjNfBGEavLG9W+kuqX78mgi6+J97wImstVrltrxfJ635TNA3g
	bDCPxowBr4Im4J3hnTfrh6tYhOW179Y=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=A1wu0T9LwJ98ahHpuBLiHM2rtzZS3mC1gIMkgATy9igSlRLOmzdkWNh2MeLgPLHlhrvF8tWFXPG5tF1eW+fQP5zshf+X0fDtEkBvOfWn57hc5UUQ8ydUUGUdJwwVtdmYjy5iwZeIj1PRnaOpNGzDibtc2KIXFtvFPz3G7UZdJnE4gNJ9dOLMECtPfrRKXL+oPsSjZj6LsRJX1l55gva1P9wdHUYOT+9UuU4h4JlxEy66nUi0FAHhuDEtCizTKMZgJ/KYSjm4tDFvp2vXKhmx+TpuHG8SJY+sjzLESsnBcOPDyx7et3/Tw+J6GFpdaQt5+zYflmEVWV+N+FOn0AjKEg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHGzgu9/onA951FTWwWWPMRHwsQT6y06mEiZEyOc9wA=;
 b=HLRlfgmqRJOk4dV4erlQhWPRPEO+sUe74LCMD3W3ZdWQ1nXtB/cXz+er/bUFMnPLuspa8iRec1vvnsDb54ujb3gqTS9MonO5a75umapu0IXrSD8h/GIgjgW0S/CuXEpEHAcbBybHzP9p6TkDdXB6bXS/S9j3NY3MWFO1VuCtFdhOzKe1mjU9jbFwd7IeLhh10EjwgV5UlLYUCgNVoidMgOP5PYNtLXhTvv5GGosE+++ChW2GfBMI2VniOoM5aPsdI9x/uc8+Tv9NXKgvCoMVOFhEQF8l10Hi3EVk47RtFYvVoEb1TZhBV9Mrem46Z1wfiLwQc4e/S6vX6dbxBWPIkw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHGzgu9/onA951FTWwWWPMRHwsQT6y06mEiZEyOc9wA=;
 b=bML+29kqnDUt5T4HhRzMaczZH6KHEZMm1Cy/mElSJ/tKBzHJQ74Lo9TXG281VGGMUy1VU18tzoH9NWGdkAUjDqiQdKhW229qOu34pbF0vMqXnkGKMF71TuIn4s+48BdMPKkUTf+OvIfuOyovQZxgBeIo7gEmP7yS99kAR1zn1ec=
Received: from DB3PR08CA0004.eurprd08.prod.outlook.com (2603:10a6:8::17) by
 AS2PR08MB9569.eurprd08.prod.outlook.com (2603:10a6:20b:60b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.13; Fri, 13 Feb 2026 10:09:58 +0000
Received: from DB1PEPF000509FB.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::8b) by DB3PR08CA0004.outlook.office365.com
 (2603:10a6:8::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Fri,
 13 Feb 2026 10:10:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FB.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.10
 via Frontend Transport; Fri, 13 Feb 2026 10:09:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xReqUSdzEeQ6tUu6nJ+oXakI/oGRmCo2tp0slv0FMxpuqsAj/lPaVEFLP4v+COrZqGVUjY53j9I7hbKdFp9QTkv4b4/6DrhpuxoAgAtuDCrv9B3j18mFjgB1eEEXcsD9Xtkvem/QSOHzK+ye6LnxYY6M0InuzIZDoHB73skh0RXicEDZZGqb5FjTGk33hwD7qQ5pgtoLFDrpYrqzavEqesghGcKcrnYfmWYMqYh20Wvy+fnOhX6LfKuV01DdlJdz+lqc71+WRXpKHYImsO5ziFMcFbvztDeurIXoaMKU7iYxmys7qItjcV2gKq3rPf9T+1z6wfUiPcxTEoLT1qn3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHGzgu9/onA951FTWwWWPMRHwsQT6y06mEiZEyOc9wA=;
 b=U5qScxEd5efyQUxfZeYln8SWn1NrEDZqa2Hw779G/Tvoxm+S434pKSHyDIGeFDrsDXQmKSSYeA1k74QCpmvLpClxzopqpgHkB/yguCZbb4KLL7CYMnh2dl4Ii1X/Wo5aKB45aZTfjfmTi9N3yrTw5zyEwld0ucxSp4vFvcQVCohh5F7xlKu+mYKwq6pDYAEa57cRpRFfZwgM29XHZOgU9+e7kTXxKM/EauYKV/tKARtRqkGqiDCSkgDys5SXfgTJMxDww3DfC+Er/tyf+vto3cewWX0lEKn+gx58XhclS9UQfrir9bLbcFBulvD5oMJI2xqjJOoQdUDMLvj4DjtCjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHGzgu9/onA951FTWwWWPMRHwsQT6y06mEiZEyOc9wA=;
 b=bML+29kqnDUt5T4HhRzMaczZH6KHEZMm1Cy/mElSJ/tKBzHJQ74Lo9TXG281VGGMUy1VU18tzoH9NWGdkAUjDqiQdKhW229qOu34pbF0vMqXnkGKMF71TuIn4s+48BdMPKkUTf+OvIfuOyovQZxgBeIo7gEmP7yS99kAR1zn1ec=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI0PR08MB11843.eurprd08.prod.outlook.com
 (2603:10a6:800:317::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 10:08:54 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9611.012; Fri, 13 Feb 2026
 10:08:53 +0000
Date: Fri, 13 Feb 2026 10:08:50 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, david@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com,
	sebastian.osterlund@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
Message-ID: <aY74MqGV4A+kwsQM@e129823.arm.com>
References: <aY3+Raf8eZqipCd6@e129823.arm.com>
 <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
 <aY4Vipl+4rGa+u6D@e129823.arm.com>
 <CAADnVQ+ad1Eu34hS21HNLgzA5eeFHMvQmoC33xKpP0z247MaHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAADnVQ+ad1Eu34hS21HNLgzA5eeFHMvQmoC33xKpP0z247MaHA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0683.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI0PR08MB11843:EE_|DB1PEPF000509FB:EE_|AS2PR08MB9569:EE_
X-MS-Office365-Filtering-Correlation-Id: b3e84854-f38a-43e4-3db0-08de6ae80a92
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?REp5UXAxdlArS3NySDFHK1JlakJRbTJ2bW93OTFoM3poZ1MyWlk0clVzMHdQ?=
 =?utf-8?B?UkQyZExXK0t0U2pab21uUHVEMVV0TGF6RUFxVkFzUFBaWkdJQ3JtTHVSNFZx?=
 =?utf-8?B?V3FyM2tpWVFBN0NOQXY3LzhsWHNlYzhWc2ZIUDBnSHM3TDFQdVZ1MXdVTVFV?=
 =?utf-8?B?a3pBRDN1R3NvL2VHaWUvemlGK09OakZKUlBIZFV0NnRadmJOMjROR2tzQy9W?=
 =?utf-8?B?UnM5VE1LZzFHeUFvdTBKeEYyeS9oZ1RoV2tmNWczZWN6ejQ3bjh1QVArcXJl?=
 =?utf-8?B?bElGZ1k5bWdQRE9manFFOWtJRDV2RjkzRFd1bEhXelFZejgwanZKWVZMU3Mw?=
 =?utf-8?B?MmtYZWlyamdoWDRwVUVXQXd1dnpLbHlnOGdDRGVOcWJMVFhQS0x1anhaTTlK?=
 =?utf-8?B?blFoY0JtVHdIRnNJTmF3MjRWcUJiRmFtUW9MWE1rT2xnVjZkR3VTWm8wWity?=
 =?utf-8?B?a0ZzVkEraTkzaVE3S3pvRDRYcHA4c1o0aSsyZWk3MCs0WmowWWhxSnpEVHpo?=
 =?utf-8?B?ZUpoRU13MDBNckgwWkNOdFkzWHB6WDZjdmhXUlRDcFp0bHNBRGZPbWNXUWUw?=
 =?utf-8?B?OHJ3eGpvTHh3UHBxcG1HZTVXUlZSRFNvakJPZnVyWTJxRXpUUlVucWhscUtF?=
 =?utf-8?B?UjNHc1A4UWcrV1BvMzV0eGU4bnU2bkR0RHJWNkI1Z3ZvM2lmVUtuYTRvc1dj?=
 =?utf-8?B?V2ZBc1MvUU1TLy90RkJ2eW54c0UxSVJuOWQwd3RGRG44NVhURENSUXQ3Vjlv?=
 =?utf-8?B?SlJhL2VKY1YzZGJYMVN1SlBxVmYwcHY4djc4alcvWGs3Q2ZCdnd1SXYvTENu?=
 =?utf-8?B?OFNxWjRWVkt3eVBmQ29TYURGLzlaV3FoSzl4U1NCODZtK1JCdFoyV2RoQWRT?=
 =?utf-8?B?Rzh5MDgvaVB1OVEzUG45d2dLaXFxcXIvYlRrbG5xNGVaK2tzUm14RE9ZaWhR?=
 =?utf-8?B?UHVqbUZWUTcwN3ZncWwvMXNDbWt3Y3NibGlCcTJjM0Q1elFzdkQ4ZlFjWDls?=
 =?utf-8?B?YkJjblo0anpwVi8rNFRkcnJaNkwvaW9iam00VFlhT1p1VWpxTElZVWt6VVJQ?=
 =?utf-8?B?MWFkTzNNQXN3NTUwcVlzRHREUmJURnRjczRwbFYwTDIvc3hyQXVjS1NDYkhL?=
 =?utf-8?B?OFY4OCt6VmhqRW9pM2dQazNYTmt0SGgva1k0TTZoaXRsRlBtLzZxNnJRbGVJ?=
 =?utf-8?B?RGNHVVA2cHpSNGdCZit2dzBtcnp2cWdnQXVuVlB5N0p2U3JHRi9zbTJnVjhQ?=
 =?utf-8?B?d2J4OUxNS1R1UEVNMW9NMkt3emlLTVFjM0kvN2FEaWVISklwZGlvY04zS0NH?=
 =?utf-8?B?QVRSQ05CZ0pQVWRvdXhLZmtJUC84c0xWaFo4VEZ3MzRaNmdhRjYrbGNlUTh1?=
 =?utf-8?B?TjdvSW1aNDE5YnFqb0dxaVBLSVAzZDlmODEySTM5UURGM09rdW5hK3o1TVo3?=
 =?utf-8?B?RmFLdTI5Ym5tN2dYUnhGdGdYNjNyeEpzSTFpMVZmcnlhL3Q4ZFJ1OEp6Y1pt?=
 =?utf-8?B?UmQreEFId2l1bjZBbFBCTGxqcHpyUkt0dHJHV2NSWFZWeXl2cGJnaTZzWkZR?=
 =?utf-8?B?UVhOcjhmQkpDZ3dhZzVFZ2p5RWtxU3BseEN1RU5JdzR2eVRGTUVtZHZlOVZl?=
 =?utf-8?B?NzNRNi84cFVFSklkSjZ3QUVDMzRHYzlsdWtkN0ZYOGJrbUJLRFdLd3RhQW9B?=
 =?utf-8?B?M0NiS2VxMHk1NGEvQ1d5WmhpbmhRMTQrNnZjOG1sT1phZm9XS2NESmZFUTk5?=
 =?utf-8?B?WTJTM0g5RS90Z3FwRXU0R0x3eWlGR21WRjRHTFhSMGdWbmhwS0N4UzI0cVBR?=
 =?utf-8?B?ZXMyMTM3MjJHOTdwYW9pem13WUkydzNrQ3Z2SEo5Nzg1WVF6QWUzbkJKWGNz?=
 =?utf-8?B?ZG5qVTl1THQ1MURCTEVOM01pUXBPYU5YVTBLc2oyYnhaMi90UDZ5Z2lxZXpE?=
 =?utf-8?B?dzExam9Vdk1lemN3ZDRXV2U1UmV4d3BNbmdBdGRxZktISWlhdTI5MU9wcGRS?=
 =?utf-8?B?SjByM2p4Q1NJdTN4MTJQNTIyYmp1N2wwNktmT0E5SEpQMG9xTXYyV2lUSFJI?=
 =?utf-8?B?R3ZWZGJOcjFQTlczK2cyd3hqR25ya3g0Z2dhT1RlY3hCZ0w2Z2tQWUlLMlkw?=
 =?utf-8?Q?t2SQ=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11843
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4ebf44ee-6978-43a4-4ed2-08de6ae7e443
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXBFcWxyWnZONTdwcThZZ2VPTG80WXhmQ0JMaE5qNkJBZzNOcWU5d0Vnb1FP?=
 =?utf-8?B?dDM3SWd3aWNFVWQ0S3RNS2tKZW85YjAyY0YyNFpPTGYyYXFQZXN4YWNYVTZj?=
 =?utf-8?B?VzVhTDdKMldkRlhBeEJFdVV4S3ZNempKYzhIYnBsR1BuUTVvcFJtSkpzMHdS?=
 =?utf-8?B?Yjd2dnZBWFR0N2VGV2d5K2RKVUFFVlVLV2svbXNCKzdpUHdSL0JpNEswZFho?=
 =?utf-8?B?YkNPUlpDa1BMSitSU1NPS2VNSWc3QmhYcVk1MTMwZUpCNXFqdVgyc05SZU10?=
 =?utf-8?B?eHRzSG02MUZnOW5BOTh3S2ZWc2dlcUY1blFJZ3lGZHA1TEFQdGJzS3R5eEo4?=
 =?utf-8?B?VjYyMGpzNS95TGdUdHRGLzBtYzVoeWduN3pjQ1dtOXJQQnBVUGtYUURXaXB0?=
 =?utf-8?B?RCtTMDRMTlhrQ0lrSk10UGxwaXNQM1o3Z3A2SE5NaGc2WGYvWWZERVJ3M0o2?=
 =?utf-8?B?RXpwN1BWN1N5NWkzUDFYNnJ6TVlkZ2xWdmR2bStSbGh0bXliQ05OU0hBdGlZ?=
 =?utf-8?B?R2hkUGhSWjhUdmplNlk0U1V4K3BKVmxITElPcHYvNmVRcGNGd2dEc05oNnpp?=
 =?utf-8?B?TW1TWXJkUG43NnJPenNEakRpNS83RmNoQnRtanFiaHFpR2lzYUhaeFREOHZp?=
 =?utf-8?B?STdOVnBLWjhwbzFJN3ZHQjFqSVJyRmFwRnJKaVUwUVRyWTNVWUMxWDNvdnBZ?=
 =?utf-8?B?M3FEYTZVU2p4RmsyVnAyMS91dm4xL3JUR0czTkN2UXZvYXY4WnRxYUlmQU9R?=
 =?utf-8?B?TWl1WURyMERxU3dhZE5BTThScE9EZVdNQitBcHN1eHAyRDNQWnA1dFhCcnd1?=
 =?utf-8?B?SGdKRGt2QkxCcjhzYWlhNjRsN0xMMGczb2RUcjFUWEptZ0xHZTIrWGt5YzFQ?=
 =?utf-8?B?cHFEejB6eEF2TGlHMStvOXNLWGNnYy93T0IxQlNSSENINnMrTFBDcjRuM0ZC?=
 =?utf-8?B?emhDN3Q5UzAvdEpzRmUxOE45VnVmWk55cWVyYkdzV1U0MW54NkRIcytIem9P?=
 =?utf-8?B?WlBmYTM0THpoRFRWTjQzMEZiQWNLYkxITmtoR1lRMnNCRGVuMWwwWUFMenVF?=
 =?utf-8?B?dnpDVys1aTBPZXkzYWp0Y3lUajJJMWxuZEdRQWFKL2E5NitGdUpxSVlqVC9X?=
 =?utf-8?B?RjZhcEM1NTlUSXg4UnRWbUloNWw0d2xOcVdJYVROZXNaM2JwRVFvbUIvczFZ?=
 =?utf-8?B?OFhYZitQeDd6cjB6K2dYL0F5a2VqQXppcUgrOFhNcGY1VDg3bjMrS29uZFRn?=
 =?utf-8?B?NkZiWkRXWGxZN004NENUMGJVMGZISEtFY21PYjlVVnVZSTVLWWFjbkR4RVp2?=
 =?utf-8?B?ZmVtWTdVR1hlNkI4dCtnRWcwYy9DYW8yVTlvbEZpdlNiMzN5RjkvdlkzL0gr?=
 =?utf-8?B?ZVR3Y0lqN3lsOWtWS05pMVdvYW9HWWdDQmdQNlhyVjNaZ01jQWZIVWE4WWxW?=
 =?utf-8?B?TzNwRGNMKzNEdE1tTFFuL0xxY2ZRd0p4YlF5NWt3MndiVXZKbDZObERGc3Za?=
 =?utf-8?B?dGZOV21WRU52OVBNa2lBcko5Z3k0YTlQM0R1b1l2SUNhSy9hdVdZZnRkNVow?=
 =?utf-8?B?UFhJZFd0dWdrNTkrRjJaVUk2aDg0cGlJbGVOVE9WcHd1aytod0R5Q3h6bHN3?=
 =?utf-8?B?QXB2QkExcTcyeURXckJzelR4blEydms1REoxc09JeXBqdUV4MFk5WkxsaFFj?=
 =?utf-8?B?YWxCTjd0TUZZYzlUZXM1RUpxSDlxWjY5V3NHK3BSNjcxWWlsOU12ZytNdjlJ?=
 =?utf-8?B?ME1pM1BNTUtiUFhEbTZMTWlQYmhDbXo3Q1lHbDR5YngyVGdwREdNT3A2Q3JH?=
 =?utf-8?B?NGZtODNVSWtBYmxrbzk0Wk96dWhMRzdlNjgwUzlRMXd4SDl2bFJ1SG1UM2hZ?=
 =?utf-8?B?WVprU3BrK2E0anJ4elNuYXUxNkQrdzluRE4wclNJWE9FbHJIaHR5bkg1ZGZk?=
 =?utf-8?B?RGJHNFMzSmc3Qjc0TUdKVDF2M05OUjNyR0xzdFp0eGVCNlN5ZUpURUVscHVl?=
 =?utf-8?B?S0xRRXVUcHltVWhqUWcyMnhVZ3hrN1JUZnZXOFNPMXVSZ2FBSDdlTVE4VWVy?=
 =?utf-8?B?UmlBMTBWNkhqWWpPcWhENkM0THpObDBMcDVqN2dhd1Nvb2dwaHhNSERubWll?=
 =?utf-8?B?bkhpNXUwYjF0eUVLKzRaTUs1ZXBkWlFKUWVTV1VjQmtXZHdacDdFRHhWVHpI?=
 =?utf-8?B?aVVsa1VLNWlQRTFMUEpUTHVOQkVIazdKQ0s3QmRERE0wOFhTODB5WWZ6NGhu?=
 =?utf-8?B?SzE5aEpEWTBhMElZOUNUWkV0cFlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MbMne5A9ik1NfmDJCgAhllz6F2CoFvE6TYZpb8TIgXA5EU325VI1EHkwRE0ZzO40jgz2FtZ4W+LsPiZhFjw3hgLqJp5fTsGqLufKxWb2d3QfaFQMYrpjadH9UTx8gINzYxuhtYl3R3gHUf71t2oyDdAZvQWgqHAMRGnzP5WO/s9h+oq7y1Gmi5+JgR6fCp2BVuHmHSw95brI5weSIcVdEi91w2yuUSllgvMjHFw8HwszUR5H+EJJTPu92up5dS+3qADLagEk0R7l8YK9sIESGI/Iwn/6owD792Ix9v/srZky35LERUbJ8dD8V+jkFOpYaFFlhVdT1B8b8FVMChHSb7T1llPv72mn8koJIWiaW3+jnHXH4AzHf0TSP+8R9fi+PITaQ9c+rDLOJn84Zke6SunWfdcpFEplIEV+F649S3mP3rKUqjmvgvYd4bFn7yp0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 10:09:57.4381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e84854-f38a-43e4-3db0-08de6ae80a92
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9569
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE9AF100003
X-Stat-Signature: ry7te5t1bs1n5a7q7ztz3m371dbpjbfy
X-Rspam-User: 
X-HE-Tag: 1770977405-179704
X-HE-Meta: U2FsdGVkX19pzdYgA8pllC99LDCRaT3Q6YHCuBbP+AXrkKiEeNO1c0BhH/AHw4BIzneo98bC/T8AizQgvNup3umZQsho+xGwSlfhj/LG/oELNfRj89mwIL6Hf5beLj3sKbY+Hga8jr5TxMxe8wZYjFSt/o8MEz3IR7PkwM7/n2mrOcbJ73m0+mKwRnTJDlV8GN8k8+1HXZUFc6PAQEgyTiCtVVEIEVYQH/wikZU2Dz9TYfXJjaB5C8xFA8scLLPm8G0s1MkJMvntC3i2JXsOKpnXU65cHEuh/TaSqYNnwm6SOPkuaDTOxvME+2A59LUsTq0HWWH7RIEyOmzkixt5otqiz37XoqdwpjxiHaFpx5QsEV8/8zaq64+xQuSo2mESiMxAXCyVjEYLyNLBtQ5iqnNM+Fjwhm9TRG8ZT5jBBfcUiZbY3Mffmbrcf7LwOYjKp+XwCgdXcuVHg7O5ipqpbY39D+NMLiUWNq5KMQTrRBfYKNFw06A5/QtA9FfqpldkfkFk+/PVK2xJ1on83+K3nO1yLgGjw7nxLRMCa+ClcRJmIS7OjL51PijfHad7zqXu+lW7hK2ircTf/zDML25404YDjh/dfQfXGJ1T37rslfrW8JKSJJTqAvR+jCMI+5VePkaBg7KDijpUEUvnMx2V1y6BUxSmy50grMECa2k7nccFHdMNZwzdaAEEDSk1VB5yYhm0jBEug0N+fzKa6ILDSqEi5VYqjgIqwSniX0Ai1LsdSxLoU6EwPBxm6p10GSEp9T9XFo/PF5eNpCnNl2nThBPwfix5HyCpbw5Vx4ggGvyEDVWPZJDAw3vJrjjx77gj4UQm89QVWSeJ2DgXm6ACRNANmCc6QESlFjTfadzX0RhtW5RsyAmRU98IsGKEafyH1RmKXPyEoF4NKoDr+EJjaxRoRKm7qlOBOIiEP6CeQkzDsM+C9CRp/3W9zJNHg4xxw/66i8p+pGNz/h13C9F
 wToNj5Eq
 Qz1Bf6p0oyUJh/vcq/TmY2PJxaah1nAv316vTEi/2IX2k0qb6NNOEdusb9QdjQdZRcT3GQVyUi9bmx7ippO6mRvlTWvtWCrDgKsqRYTeHUjB3JMPBBtTkiYg6kAI2ASKsggi6xMQd/i/9Pg+W2RAINKj3nGe2sTbl5sEjzZcJ08GhhQVsY4pHjUkb80BMmcvyq1SZv2kGbeq8UV+NauFnRGdhLr/lsTYfDUc0pfLn8F8NfWmIHE/h1FaKD3wfBhB5xKp40dtumaFhs7Q9kYHgVQWLyITokmk+u+7Xz/shKw0qDoBgxs1rT7o+0hzSZSi/VHOooVZlWZd8jUOsoOHXLQPw7VUNbuMrGrK0BSN/IwKcZynQ347C43iSB5xRQwTrEew0TbHWLLguJSfFxOcYW3dY240aZ1MO6IvdyBm2y14+D5lvo5j9P8YKCsxADK1qiymihBf6MP222EifEKEBrllHfQEeTJvms48jdD8wGJNB6CbqRmKvlhOt+X9AUfQCleKPNRf1NFDnsYh8umOTJ8x0nwKi3ToqTMH/Dha3pdY98lnIyEZd70cSjQ6jMlyQrmn/j7xSdSvzbBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexei,

> On Thu, Feb 12, 2026 at 10:03=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com=
> wrote:
> >
> > Hi Alexei,
> >
> > > On Thu, Feb 12, 2026 at 8:24=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.=
com> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > I would like to propose the topic of eBPF isolation with pkeys at t=
he
> > > > upcoming LSF/MM/BPF summit.
> > > >
> > > >
> > > > Background
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > Today, eBPF programs provide powerful capabilities to extend kernel
> > > > functionality without requiring modifications to the kernel itself.
> > > > These capabilities are largely enabled by the eBPF verifier, which
> > > > enforces memory safety and other constraints to protect the kernel.
> > > >
> > > > However, vulnerabilities in the verifier have repeatedly demonstrat=
ed that
> > > > eBPF programs can also become a serious attack surface.  In several=
 cases,
> > > > flaws in verifier logic have allowed malicious eBPF programs to byp=
ass
> > > > safety guarantees and compromise kernel security.
> > >
> > > eBPF was restricted to root for many years, so the above is simply no=
t true.
> > >
> > > > Representative CVEs include:
> > > >
> > > >      - CVE-2020-8835   [1]
> > > >      - CVE-2021-3490   [2]
> > > >      - CVE-2022-23222  [3]
> > > >      - CVE-2023-2163   [4]
> > >
> > > None of them are security issues. They're just bugs.
> > > Like all those found by syzbot.
> > >
> > > > An RFC series is planned for around Q2 2026, and the experimental
> > > > implementations for eBPF isolation with pkey and pkey-aware memory
> > > > allocators have already been completed internally.  Using these
> > > > implementations, we verified that eBPF programs running under isola=
tion
> > > > successfully execute several sched_ext applications provided by
> > > > tools/sched_ext, as well as some bpf kselftest cases.
> > >
> > > The stated goal is wrong, hence not interested in patches
> > > or discussion at lsfmm.
> > >
> > > arm has a nice hw feature. Sure, but this is not a place to apply it.
> >
> > That is correct =E2=80=94 this is a verifier bug.
> > However, the concern is that such a bug can lead to a security incident=
.
> > Not only root, but also users with CAP_BPF who are allowed to
> > load eBPF programs could potentially trigger additional security issues
> > through such bugs.
>
> Again. They are not security issues. cap_bpf is effectively root.
> Just like cap_perfmon in tracing space is a root.

The argument is not about whether the verifier bug is a security issue
per se.  The point is that relying solely on privilege boundaries
(e.g., root-only loading) does not eliminate the impact of a verifier bug.
Therefore, leveraging hardware isolation to further constrain
the blast radius is a defense-in-depth measure.

That said, I may be approaching this from the wrong angle.
It=E2=80=99s possible that I=E2=80=99m somewhat fixated on my own line of r=
easoning and
failing to see where it might be flawed.

If so, I would really appreciate it if you could point out
what I might be missing or where my reasoning falls short.

Thanks!

--
Sincerely,
Yeoreum Yun
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

