Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA55FCCF9F1
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 10:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254E28E013C; Thu, 30 Oct 2025 06:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205AE8E0112; Thu, 30 Oct 2025 06:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057DA8E013C; Thu, 30 Oct 2025 06:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92098E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:16:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74EF55C444
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:16:22 +0000 (UTC)
X-FDA: 84054375804.27.F50ADCC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id D98BA4000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:16:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QBNLzonV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xwXiVrgz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761819379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMc8L43EV4HXtVBnj05in+9IKCb612O8CEZYiPTDr2A=;
	b=QXSJUJwfcGVErpBN8gO3FWA4NYVdzzAT6U2Y+iov64xyC2vwjEsHQEFEFHRAHQ64h1GJZI
	tyBXhhwEN9aycnWNPwGb3LpMmGmfBDc0jUNkxULn6MlHycQO9QniYMjduM3q3R7rUlq4el
	uGUeu2QV8HDvSg78JWg2asb8MhNLr9Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761819379; a=rsa-sha256;
	cv=pass;
	b=ZtfmOKeqv8nN8g13Z2APaJHFvqzzrqcdTlOpOXTUAwP7LukJwFCrGzdN1jLA+dy267BN5E
	2JZR1ZRXJyTG6GtJrXw83Y2mjOCFBKL81MC2hxVPHv3nv7S0SxFhggqxxdYnUZx+L50/s5
	F/yyA50G43YmSBlRdS84U+2eB2XZZhg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QBNLzonV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xwXiVrgz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UAC3Z0009549;
	Thu, 30 Oct 2025 10:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MMc8L43EV4HXtVBnj05in+9IKCb612O8CEZYiPTDr2A=; b=
	QBNLzonVUsr0W8kUch6vlg5fjYFgPiN5SSEV5+WckkNAYIochhSRvB3VLyK8aVIT
	QTBjCPoFO7iu9QHuFgxw/s0veb86hl1YT3Z8+yGfNJ/ITWtLMjemvnJzB0EJRtNs
	xivPKsZzrZ3VD7uKxCpbrrRMaFlWeZSSuykpFoQzDDMaVf4QuUOV55/avxEcd3fL
	HMXojZvMDAwfJFtzKojMZGZJkI1yJ4T5s8vSBqZz9idW7xGmjOMV2jOIZqnn1vty
	Ss1ZR1eekH4TSIdim22HSy7r5xgUKFSYvqtfj+kIl4S6d76pjHtE6mAtbEQ4SAxG
	v5R/BRSUGSp9h3uUHq9M4Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a45k081u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:15:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U8UPhc031595;
	Thu, 30 Oct 2025 10:15:56 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34ed5muf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:15:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ih1I1TUkKmXBxXmMw945Rz8Mnr5A4RC3uc5kVu8dE4StelzOx4AMZ3NjP+YoPzbKbwZbXa7KrT8Ynyi1Zl0rHEKhgSvWARh5stZ7fVCY3duQckrwwpkY981OVbAduc9w+NiQH17rA+E2g8g5HwWlNJCjZr+jd2mBZaW0YGZtgWCjaQE70k9JONivbjKAXjsnRv+JwhF416hXuZWdq6ItxbkLN2dh2Fer3vrHFRNXIuAVw+b+i7CnjH8Mr0tJeH6qwU8cDwJ2RQd0n8vql/aVVcr/V4wyjK+vs739ehy0Xy+8FxngfG3ARB3jBpfMYwKequMP8lHdNJmeXCLNsJ67BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMc8L43EV4HXtVBnj05in+9IKCb612O8CEZYiPTDr2A=;
 b=YE091lLev0K4bdB/+va6sOkb5+hlzoRYnMc3sJ2LR5NuGhW0fZK7/RbOByoirQrpEYwI6K0UQ6S72RZ3cc8EVFgNCaQJUjpGmqBVrT1xP4qsp+eENejOmd3K4t6WQ9pvxlzNh2mP6f+mYcj9UoAf8zUl1S2etLC5NIISNs2K4Qlv69HoZSScJedhus9iOOjZje3qbUK6zKAVOQchRqFKSA/YasVRa6NmmP8e9Z5JIVM4100LcIyFV6+HniP5zEtKrfa2m0mpiiV2ARliuaPbFEMTs3lXdCQrUJSKVJn1QA8I3qz/ve9CapYX0tM5DTkg2QRqxTFzsXqI+4JSIufFpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMc8L43EV4HXtVBnj05in+9IKCb612O8CEZYiPTDr2A=;
 b=xwXiVrgzMbQECLQVlI0zb5nxtmyMIQXRF/zBdxh0v9FNo9Hu3kytMd2rYsxZtl5LwBZoRh4hp1IzeHzS02nP/DNWPx39++X+u19C6v7xty4Ct+V3xyZ14eBBoeuv18bkBO2uqPGXN1ckdQlW4MJgZcpDkjCzz1vIQ1+xEc7G67s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB5804.namprd10.prod.outlook.com (2603:10b6:a03:428::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 10:15:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 10:15:51 +0000
Date: Thu, 30 Oct 2025 10:15:49 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <05622d09-f746-494e-8140-8f69b409b698@lucifer.local>
References: <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
 <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <CAA1CXcD1YDAbYzdYfchOWbmUasa3tN55AYroOLJb2EqoQfibvw@mail.gmail.com>
 <02a72419-bc89-481a-ad2a-a3c91713244d@lucifer.local>
 <CAA1CXcDR7pe1jKvPOBv-WVYObYtZNNx0w9vESaUsLe+BPR=Dzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcDR7pe1jKvPOBv-WVYObYtZNNx0w9vESaUsLe+BPR=Dzg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0158.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB5804:EE_
X-MS-Office365-Filtering-Correlation-Id: 79a38d64-0253-4c70-f523-08de179d4dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SktBMTNhcWtEMCs0QUJDQnpOcmhGektrdmlzeUFVbVJ5cHRuaVMvbEJqd0hS?=
 =?utf-8?B?SzZ4dlNqV0ptTVdyRzlKQU9QbjMyaUpzSlhtOG5STmdORzQ3aEFhZURVbUc2?=
 =?utf-8?B?Y1l3U2VNbjhHM1AvT2hHbzZ2WnFjZ294U2lRZFFJb1hRc0hOUGVLWWF2SXRx?=
 =?utf-8?B?TGgwb3VWWmN1Ym1lVi9PWHJ0Z2Vrd1F3b2lWM1ZkaU1GYzFja2psMGNDTmNN?=
 =?utf-8?B?S2FHZGh5ZzIwWkpuMGNVc0NuZlZ5TlN0czd5Vndha2gyalAzVlFaR1ZmUGZx?=
 =?utf-8?B?bWhiZStXeHp2cWdkd0p5YkdNUnFrNFh5elg5M3JnbUxhQkFHckZ1M2hEaXJu?=
 =?utf-8?B?dHBKVE96SUNKZ0x2ZFMvY1R6d0F5SGVzNnprZ3B6U0NPVnNvUmdzZ0lheDM4?=
 =?utf-8?B?NVJ1OUVLSjdHR0tuRUVVT01TNGFOOFJqQjVvTUErOWtxSGpGcXhCOVNZRVRp?=
 =?utf-8?B?d01LZWJWY0VJckV3L0M4RW5GK2hXdGNVTDNRVXRaWHJWWEdBa3hTZVNodEp3?=
 =?utf-8?B?QUV4dnF5RDc3Yy9SN2daUzExWmo2L2NjUVpyOHhpcVhyYUY1WXVoWXdYb0x1?=
 =?utf-8?B?SldpUVZCSGlyN253QjNmaVA4UHJTS3Nyc3E2dnk3T0ZHbDJuZkxVWUU2bUJ5?=
 =?utf-8?B?V2ZDOU9aVTV1WXIrSCtHZFF0MFB3MW92ZUVta3E5ekVVZ01jVjVRMjRIQUkw?=
 =?utf-8?B?YXhacEVmbVVkZGQzNVgvUjhwRWxNWjdQN0Z6UW1mczQ1cTNaN2grVFFEVGli?=
 =?utf-8?B?NHV0dEcxL053bVNtVmlZR01YR25GS3NLUEVZWFdESjBDZVFMekk2ajFSWHVz?=
 =?utf-8?B?NDVKelhDS1ZqbmJKaTZoOTRXVE1ScEpJcVdpbnptczNvam1OZC9GVlk5ZlAr?=
 =?utf-8?B?enRsb0grVEVpTHdERkJJeUpUeC9rUU5YM04zNUhwYXExMEl5TGpjY2tscHRR?=
 =?utf-8?B?aTJyS3lGTkhNT0dFYkJxK2dZZzl1Y3RiT1dZUnp4SWFkR05RbGZHbnJBOFdh?=
 =?utf-8?B?Tmp6L21zeHVtR1h5R004VGM1RUtvM2hBRk5GRXJFVGRvSEhkdDY5aHVLWUxJ?=
 =?utf-8?B?UEo4Y0kxMThZc3VRdlhxcktwSTB0Uys2SWpPaGNpR0ZvRi9sRWdrU04zYURj?=
 =?utf-8?B?bVNwOG5CYThlNjUvcmU5Y3d4QjV5M3Z2bUdsZy9ySzdBNVh5SXlrUi9lTk5q?=
 =?utf-8?B?OG5TNC9BTEZtRVZwdldhUzhXWTZJcGppTmNValMybVlBeGppdjNTV3V4Qm1Z?=
 =?utf-8?B?eHBoRkt5L0FZQXRyQUxQTGZtMWFQemJPTWRiUWlyN3FNbUxUUGZpUjl0UXpC?=
 =?utf-8?B?dVdvaDdGOGp2THZrUHU5a09KWW4remhlSDV4REo4ajlRS2NmWk1uZHhyTUdN?=
 =?utf-8?B?NFVmQ0lvdG02UjlnNGUzT2dTR3RmUGFuMlU3bHZrbFJ3MU5mb3gvbG1qVHdJ?=
 =?utf-8?B?V2R3bnBmV1J1RGEvMWZVZkd5UEV2ODNBUU5NVTRGRDNoMnVpM0pGVUZ2WnpL?=
 =?utf-8?B?MCtRcFBBZGI4cy9nbjA4bFYzVjJDNklZQkluOGhXdU5hL2JRenVtTW5aR3c2?=
 =?utf-8?B?NUUrdWFwTWs4RC92ZWQvMDQxVjNyTlpvTmp3dFg3RmdQYWxSaWk5NFpUSGgr?=
 =?utf-8?B?QWJJYlZCbHZtemNoWk9ybkp6MlVreGd4QXRvVnNiMTZhRDFOU0lBSDlwV0ht?=
 =?utf-8?B?ZlBtRzVRbm5HVjh4K2lHazIyMzVkVm1KQnFybDRaSVUrM0locGRSN05lU2gr?=
 =?utf-8?B?c0ZsMStIZnJXSTV6ZVU5ekROMmxoeVRnYkNRWlh4Tk82S0duT1lPb2RneDZV?=
 =?utf-8?B?Nkh4eGhoQkhJNG0wL3V3cWt4eFJWUVM4djRYNVVlNGtnRkFGcCtCYnNWeDNo?=
 =?utf-8?B?RGNqVDFkWWI4VUtvVUhiZkxmNHV0WUtXUnVRMmExcmFCU1FsQW5hcEpPWC9D?=
 =?utf-8?Q?g1i7k2/CKBOsc9/6g0bt8TB6WTDDu3rf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3p2V25wZzBxTnIzbjJvOEF3c3c5RmM2ZTk3bG1Va1A0Rm5QWTdPN1htY0E3?=
 =?utf-8?B?aE4zUExoZ2psamFueW4rcnJEeDZ6dEdFeUh0YjEzSUUxdDg3bG16RXNRMnlC?=
 =?utf-8?B?Y2xuL0lDZ1Q4RWozLzViTkZlakwwR1plU3U3c09HMFV1Qzd6ODgwMjN6SXdQ?=
 =?utf-8?B?MlQycUVSM0d4TTFOdHEycVdQcTRHMVI5NWZNdFFUUE5XaGsyTHl0UVl3YkRv?=
 =?utf-8?B?Z3BFYkpMUkZXUlR1QXNqMUNKVUp2elR0L0QwSUhqSi9iWlJ4b0RuQ0puREdn?=
 =?utf-8?B?L1JIMWxMV2Vjdml3aWZaN205bkJKejB6T1VHS3lrU0JId2IrVjUrWmZGY3Ra?=
 =?utf-8?B?SWN4bldGcldnWURrbXJnK1hKc1R6S01SWW1PVVFwVUhVRkJlSGNRT3k2MGNy?=
 =?utf-8?B?S2JzNUhTOGs5UWlzMm5kRWFzdkluN0pTRndXeVlBWncvYmZUNm5TVEZvOFA1?=
 =?utf-8?B?Tll6Vmp5L0owdW9wRWhKNTdMbW55SVFGZWVWOWNMVC9qaHhEdWlLSS9oMjdX?=
 =?utf-8?B?ZytNLzA4S0gzQlZCL2hLNmc0MnZxMXJuSXRPTmR5SWN0RDRnZkVoRHltcngx?=
 =?utf-8?B?NDV2MG9UbkZVUWNKbjdhNVZ0dDFjWFpTTlNmTVhsRi8wN0h4NEFlUXJNdGV2?=
 =?utf-8?B?Z3Avb2RtaFRYbENVMDFOVmlYR2VtTkdxcjQ0WDl6VU5pYlJqN01lTm1MMVN3?=
 =?utf-8?B?Zk9wYVNSRHUrb3ZwRDRXVE41d0YrMmh3bzVKV3NjaHIrREZrUVRoTTFETGlI?=
 =?utf-8?B?QUVRVTE5a1pXZndVcHNLUDZYdVhaMEs4R0FrTjRTbTdwYVd2SFRYZmNrVmI2?=
 =?utf-8?B?RXF2OEtpMERZRXo2dlFuYnlXVGFwRWtsUUUwbThQeFRZY2lYN3JwVWpwOXpi?=
 =?utf-8?B?b1I1d3JkZ0xFVVNmZEpqSEhVT0pVT3lkMkxmU3JHSVl0S1hHQ0sxSG11VjJv?=
 =?utf-8?B?Nk1tRnoyQVo4OEVSYTgvNjlJdGJaYnB0bmtiVm9udWtLS1VRdzN1Rkk4ZVho?=
 =?utf-8?B?aWljQU5PNGVlUmJIb1VSc2xmc0xLNS91dFdyOEQ1OTBCNWRFK2JkdHZoN1M5?=
 =?utf-8?B?eGI1NEREU2l0ZG5yOHBZeXdVaWp1STJFUmhOS2E4YjUzeHh1a05EdDk5WVhK?=
 =?utf-8?B?ZXp0RjZuaXVFZlAyMWVFSlZTdTVOZEZkUE1WYnZsREVmVUZDWld6L0xxU2lz?=
 =?utf-8?B?a3Vkd2ZLa2pJS2x0dUo3T0JwNGNyYURRQ3VQMW9zWVVpemVIc25yTVlPT3dq?=
 =?utf-8?B?M1RHNFhOdXRCUVdVV05neUJrcWd6STJGQUxEVXZIZDBac2pxWGEzOFlNc3Rt?=
 =?utf-8?B?bllrS01NQ2R6NFhZNlJrQU56cUlMeWRhSHdnT0ZFa3VBR0hGN2c5aVBIc3dS?=
 =?utf-8?B?b2x3MTdkZXlrRlBWSFZHOGpFd2tDNkpDSlQxaDFPT2xSN0xnRXRMZWNReEpF?=
 =?utf-8?B?cjZWTHhJUUtlaU9nSFRzMUZKK0RNMlJIcnJEYnRpZEdpOWs4RFV1YTB2aGk4?=
 =?utf-8?B?UDhQYWpsSUIxNEd5VGJUdkRlcnFkY1VsQk1XcklHM0dSU2dodk9tK21IcjhE?=
 =?utf-8?B?RG5Oc2VuOHdlVkdDQVAwWDI5R0VaeStDUHBBQVZSYjVsZURKZjRRcklBejly?=
 =?utf-8?B?Z2hTYlR0blpkVThSdE5rZm4vU1F6ejQrTzI0TjEyM2E3K0hQU0pWY2ZDdUVB?=
 =?utf-8?B?MFNKQUxKdlVBb3NDZ2VQUGRraXdCTGpIb0FScWxRMFJoenlPZm9UckdGcjNY?=
 =?utf-8?B?c0NqV04xZ2ZNb01RMVpzMDdoQklqL2QyaVB5R0JWeDU3Y08waFZ6dTdXNCtK?=
 =?utf-8?B?SXdVMkxRcUJ6Q2JZQ1ltWDFZVEJaNWdxejZ6K1J2b2RKb09aMmlYY0RXRDY3?=
 =?utf-8?B?RmlhRENJME1qOXR4cjhiMWZ5YjYvYjZjN3phcmxpcVhOTnNxMjBHSHlmMzB4?=
 =?utf-8?B?UUJzL2dLell5NEJkazNxdkMxS1J0SU1pcEpPdHhWUm5tVS9DdE5DRDltSlEw?=
 =?utf-8?B?TXhKL2tpczhUck96NFJ0eTY4Und5WEZtOVpmdE5jV2FlNmhDeGZrZWJqMVln?=
 =?utf-8?B?NlRzMGZCN3kvdFYwbkxsNnVpK2MyZHVoK0ZNVEFYM3JXdW02OVpHWXQxSndm?=
 =?utf-8?B?SWZIaEZndEYwM1AxeTVwdlBhd2V5UkVCUkJvMHVkUXd4YmExOXBVT3h2UWpL?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	emN2mY+sON/Rlkw3D9BG4I7UxjHbe4jUDxZs+fI3zIEvlGxkZfB64rO7ugrx/QObQ6jYqL6qxeRp/t5glrOa8N+zahR6XMm99jkW/RJlLMh7fRYrStbZhTsEU5B1Y9t0kBd14/FtmC8OKWzG+IjjolCPyA27ilcXVQcMtRRcI3kEyV9/QUd7/Ejjn7eSxErigloLZRe6EpoeW9XHQ5NI0RbLQMXr7c2PPknHATAC6fMqCQptxuJTQXfshRwNATucHTwVkrZgHdntRFbidLwOLHKx9l2M0cabWWk/whNr/nhDyFDNVtYyZZfb4/jY3/GBP30guHgfh+B8DgqMI4ZtmSSS0tIWf9FlA0GekHDN+L382XbazzGpFVEADvaz53h632AtwvmMkCmcv51yi4uoJSLslWEsw9J1KrdfV6X9166nFsxcsWPLr6UTQaTHxWOIbAK0nvH0f3JyNQZeBzKv/KwSKQP6Tsna4896OxjfXQXHD3gg/MG6914aEnOzpt82+rhmuyjPXneSd7IiCcRSe+GJ3IjIIhE6czJgPLo5dCziV7i76DWX2Szna220j+Txrd3ualJnY3UjVqMWb8TOTrs/7v6FReqOBwejxl7Z5MY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a38d64-0253-4c70-f523-08de179d4dca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 10:15:51.7515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SwxYLO+mGrozeGZWXJOtXVlU8+OsakSXhVSiBW4AbxsUgcXuWv1K45l40PAXbKk4yPa0pkg8+pbkl00Rer56Tuq6zJUpvD99yMkIc6YFHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5804
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_03,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDA3OCBTYWx0ZWRfX/y1KAyUUkaFk
 qLGhImos9LHvvRrKAcjeqvHWEAil/IQ0y7TSfXLJzLHUk8IILmUlXXZFB3lKyFK9ZvMTc6Mthy0
 kjvWZ30SRJ6kze+DbpmnSu1Baj2VHVzkfGJfnm3MEy5ary8e7QjQcNg+KzdkFx5zoRRpLJRDWDK
 C4Hfq4Pw0XONouEC/ObusHx5Ez23sgmsALVV7vI64TIdW1kejc2Jm/RfldTrI34t9NjUHII3gBv
 f4dBJ+tvipCFF9Phk6+FmwKyv+b34BuImH4X0BXHUBzVHkwDexwM3Vy79ePkLyZ8gP0ke+g2uzi
 6rvSw3Sa689P+lgZ+RZoa9COEyomg+3EEYygGSWeT5JvwrnyGsM7UyIcdqQ0RQ/kspDXeFTGAMU
 keOQlvuFBgEXrryarutWnkXxNYITEhmeRl3zM0A3rTyuwtf9t5M=
X-Proofpoint-ORIG-GUID: BszvoqtbOseDegkr4FUBSNKt7nNSwVtJ
X-Authority-Analysis: v=2.4 cv=WdEBqkhX c=1 sm=1 tr=0 ts=69033ade b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Q4V_AGX7bINuW7elfZsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13657
X-Proofpoint-GUID: BszvoqtbOseDegkr4FUBSNKt7nNSwVtJ
X-Rspam-User: 
X-Rspamd-Queue-Id: D98BA4000E
X-Rspamd-Server: rspam02
X-Stat-Signature: jdnqyjok79c9toig6ekobwsrknecrs4j
X-HE-Tag: 1761819378-660680
X-HE-Meta: U2FsdGVkX1+cAcTciktXztiIgtARfq4zYqt6TY7s9nlTgkTojwKNRmSasZsaXXyp+DQrUCbbWLHYBhZYDkf4xs/vkLlCTHITIoeKlL9dDY6MyzyId5kqZNPHtLNqqtsikPmhlfPQtU0gJJNKeL09z0enpChPnmbRfmddsTj6j7ILG0+0fjmQ/lewaLMpAQ/dHc8fyrVnZS4huX/Ccn+4xuYsBf/OilqBn9Al3zxB1q2pVyR4hIpPg3kUGKExAEDS11U9SDOLFE7EcOXH3JtqRdAgo9hGpP7xxrak7tjENqRFYwSkCV5fPt5umpS9oNqhTkhcGgsq2hmd8feMeVAM1+vRFWkIo+zy3rvFdewJVNzdnjbMRNfI9eQRgxwu1savmdlg+vzsmkhDbfXpPIiJ/lbZpuZPOLQklymvoOBfj4G9Q8v+vk2Qt3efOCPWouYlWCAOIYVbwFlW5ZSA/FazmwujfFlzOqxUC8j6130Zs1VnfC6BL0IiATtUvOic8yzP9sGl5VegoX7Hwdcuq43W+ucpGXI7JnBwLE6C7YZ9pLSgr65jF0bh/yndvgaRIzX8yPZfXqheGtZpSMUzPxqJveVQFc2XKZs5sWV10ghno8qGkQpSv8yu0HW1sbOGHomMAZy2LRpjymjqwL0thjUrKPw0CdL0b9adEocScSJ/HA6ehFIN5zl9mdjJ3DRdBX+6M3doDk14FKaj6yR95etdPLJprhV9DJZmg2f0IvcpFXV1cagFZCO/okI/Fb/rPbYfxzxygFIs9v4/nJa2EJM7GZoz60HqhMBzY3VIy/OZuIEqDNPe5dz6F9+qu4YcfsgQWT/q+x8GXK0RYOGz84+eNoKO6JggZjTcOjl5tawdwRYplfKP2pT5u8hATmsOvKaRWmJBcgprTUy/5K0myJAsp9qX3Vo4LHB0QIeodppwrUuOJzn2n91t2zTXxvS9oJIQlZm5alPEOfuzfZjrXz9
 yQ1Er6Vh
 efYhpgwAd7bECOcSYSrGgp0zj8aGdF8d0/XYSpvnbS2N8/lSuePVHrvODfL1rVwIKtpgHBY4ph579fEqdXMog07yUMh+UNG27zLpnk1Nvsl/fP8igdPhgby2d85DlicduVQ/d6LtjlIUS5pqaUVvJixcX1ocHyNTetVysmTwAjIuJKI1q0i78vqoIQNoroVIIa4zT9iA9MyxTW/CBb/lnIlYMDZMLyM6Dz4LmrT2ETF3GGEhuK5768Eg1NLlL4n6HPlE4vvZrT9afGmh9Fh6mCi7RXvTRRXA1QXjfHKK4tDMyQJYwsboPPzTAM5UKKtR6qICt8ZX6qJxOn4DBI7ZuxTvovZhkml4OF5kgl5WZja83XdbsE4Nw/RyxfzCe9s5XqZrvI5/EKNZ9myV+BHrNPLJdGV5s+eQA/hNWRJSR/spxa+Z91hrEMEnQmNuhfiRGKpgtVp/qa87HD6lpbC9JNlrzRHHayk6sQ8hpK+ps8SRRApkpvQfL1LIebuAkCUpYfjH59XXK0ID7UMC0EaRVQzbCV/rcbPxy8a0oPN3rpBLzn4KgSSBBLOSgkRe5Iq7FUqujifTDsez9grF7/SahFlfgS3uHO+zu5GboONO1gA51cBOgUKKZ325m3pBj6+q500iTwTL7K4FPpvl0l9yxiTFuB3n1ogcFf8Um6o07P6owJ8uq1Ow7uCsJpMpcujDeNJdBfr1xhKvr37B+Pu0JNRYGlfLbDrijE7kVQd1uSS635kElTLYY+7KCcenLM3DUQMQZHELlnuv9BfXvZZCr3gddilnBWFwV0v1C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 03:23:27PM -0600, Nico Pache wrote:
> On Wed, Oct 29, 2025 at 12:59 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Oct 28, 2025 at 08:47:12PM -0600, Nico Pache wrote:
> > > On Tue, Oct 28, 2025 at 1:00 PM Lorenzo Stoakes
> > > > Right, well I agree if we can make this 0/511 thing work, let's do that.
> > >
> > > Ok, great, some consensus! I will go ahead with that solution.
> >
> > :) awesome.
> >
> > >
> > > Just to make sure we are all on the same page,
> >
> > I am still stabilising my understanding of the creep issue, see the thread
> > where David kindly + patiently goes in detail, I think I am at a
> > (pre-examining algorithm itself) broad understanding of this.
>
> I added some details of the creep issue in my other replies, hopefully
> that also helps!
>
> >
> > >
> > > the max_ptes_none value will be treated as 0 for anything other than
> > > PMD collapse, or in the case of 511. Or will the max_ptes_none only
> > > work for mTHP collapse when it is 0.
> >
> > 511 implies always collapse zero/none, 0 implies never, as I understand it.
>
> 0 implies only collapse if a given mTHP size is fully occupied by
> present PTES. Since we start at PMD and work our way down we will
> always end up with a PMD range of fully occupied mTHPs, potentially of
> all different sizes.

Yeah this was my understanding, I mean terminology is tricky here (+ I am
probably not being entirely clear tbh), so I mean less so '0 means no
collapse' but rather '0 means no collapse of zero/none' but of course can
allow for collapse of present PTEs (within the same VMA).


>
> >
> > >
> > > static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> > > {
> > > unsigned int max_ptes_none;
> > >
> > > /* ignore max_ptes_none limits */
> > > if (full_scan)
> > > return HPAGE_PMD_NR - 1;
> > >
> > > if (order == HPAGE_PMD_ORDER)
> > > return khugepaged_max_ptes_none;
> > >
> > > if (khugepaged_max_ptes_none != HPAGE_PMD_NR - 1)
> > > return 0;
> > >
> > > return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > > }
> > >
> > > Here's the implementation for the first approach, looks like Baolin
> > > was able to catch up and beat me to the other solution while I was
> > > mulling over the thread lol
> >
> > Broadly looks similar to Baolin's, I made some suggestions over there
> > though!
>
> Thanks! They are both based on my current collapse_max_ptes_none! Just
> a slight difference in behavior surrounding the two suggested
> solutions by David.

Yes which is convenient as it's less delta for you!

>
> I will still have to implement the logic for not attempting mTHP
> collapses if it is any intermediate value (i.e. the function returns
> -EINVAL).

Ack

>
> -- Nico
>
> >
> > >
> > > Cheers,
> > > -- Nico
> >
> > Thanks, Lorenzo
> >
>

Cheers, Lorenzo

