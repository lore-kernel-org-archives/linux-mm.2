Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F55CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9077E6B0005; Tue,  9 Jun 2026 02:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8196B0088; Tue,  9 Jun 2026 02:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FB76B008A; Tue,  9 Jun 2026 02:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 631766B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:18:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 003578DEE9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:18:10 +0000 (UTC)
X-FDA: 84859369140.28.8349691
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 062F3180005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:18:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nl6M1Z8D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.42 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780985888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh4nhNZFXb3vwwG/hgEhhJE4K5vcS2eLYsFonvUYZx0=;
	b=uPz8/dHNKCHQkiI3BAu67BPD0tve8K32FQHJPY3y7gHTj+twAyUehjDPYqxAe3pVgwxvgG
	RpX5ihnLcXS2cJHpmAj3DqEWmub6SpwOY09oWnSC7rT0nNqBBd/Oie/vTKzDo3x3zAX5RL
	eMMst46/fz71MIV6ZszVFpaArQwYgik=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nl6M1Z8D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.42 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780985888;
	b=T0/SuJD+Z7m0e3S6VpgORnHVnejKkYX9i/5q+77hdg37lQHKJR9CAaVs07W5FATJm8DS3L
	C8QSYdzzTHhlCiJFNNPqhYkLohvUGa/g9mDyVpWGhld6BIkfovXl1PhHnZvKgjTDN95Z56
	4hT7cxSZNEzcYuptCoDfO5BkwF9wk9A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ust6VIXitIWa29RQ4UXvrHzyBfBctXr3FWWYp66I7WJ4k9QQyXZlTt2n/7ajgiiiJEZSAo1fimZTnHsdmNtPfVh0/S18R6vRldlcm8OdPFXv/Q4tl59q5ag/dtw26H66kjyK9m875gacxhsuVUIAk16O715XpNfAtOFBVKDvtPDBN8qRA5ZIBss8xhpeXCArcpGOruaE0/JIS7kIanx+ESdz0+3RaAaRSOBl3r7HUKK5zBL7ogUbb0BL+dpNaqT0YhphLVNsAaaGsbu62VbVoG4HyqQwOn0AyBI1lB72KFp43DM8jeAXKQcYKhRjTF1yteAjDasjaM+05o7OTxao4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh4nhNZFXb3vwwG/hgEhhJE4K5vcS2eLYsFonvUYZx0=;
 b=r1B6JesH0QyjHTCHdwBkHu0za8LX0sij3P0J8c+VFwL57rDEqQ6GfWwsjUY2Zd8iSKbDuVswvaGuKGloYUrtfREoqvJgIbtcislUsYuOjJI52ncMppLl8tXQwu+5W1+Pt0gVVwrklwdxYLI2veMepIbMzOCzJA22nP6cLT08wNTaYx9+Ls2XDYeH7f6ki/Ly/d+BwdD33GBLSHaRrit/Fdtm6BC3HhY4rnV4/xQN7bRSUjzC4UkZ1rIU2iZAAlnHdx/p5MfOiA4N7MIo1G4kUuFSwx6M7kKLl8FZiUz+tnLQEMUHTTvphQipazJDqwGskCbgCcRZJo4i54F6/NRX8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh4nhNZFXb3vwwG/hgEhhJE4K5vcS2eLYsFonvUYZx0=;
 b=nl6M1Z8D4QaMRjfP+rB46sBwmb1T8ZuUbFRuMRCbKM9l2Mn5HezhviKGnGXsgRE6mZPlDgWjHyiAeFfNfxKON2gn0/FmGE+TXRYT/0dXmqlyEbZ54YE4ILHPhQv6mcfRYQgq4q9BcNnOwvFi6bi29EBx5EbzuOyz6kpKOcMX65Y=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB9069.namprd12.prod.outlook.com (2603:10b6:8:b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 06:18:03 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 06:18:03 +0000
Message-ID: <d80edae4-a29e-4060-81dd-b95b3f945a6f@amd.com>
Date: Tue, 9 Jun 2026 11:47:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-4-shivankg@amd.com>
 <996a1f61-3b59-40ef-9508-ef339cc0c931@arm.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <996a1f61-3b59-40ef-9508-ef339cc0c931@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0231.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::7) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM4PR12MB9069:EE_
X-MS-Office365-Filtering-Correlation-Id: 69c541ae-3375-4a61-fb1f-08dec5eedcae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ClL00He2DvGMnPcopongL2vzu8B/vF2D7kfRCZ64SK4P3+mNR9WePvALNOPBU7LB6jFobgjzcsVW9M54E3AaBa6zSLKGi8R6zJmMY+FETaQtCYf40nOwpkSM6saH8EKfzoQTxnLOOT3mcoka5XFwlAiO3FsysFw9Dd1P3J53WJyzBTz+NWbcz8VdLXmDSTojOl7TKaz+oSeO+Mzuj5njVWAhSbN/FPyt61rCo/iw6pVRIsAQC/XLn+MSXwjUq8QiVccgdZYzD8xbJYDQjcsjlw4m0h5rlJUnWVh+JmsTjXtvXoISewo4tX4mMVHAV2Idnoe0d7g9o8DCM8hP2g/7X3VhFBf9rEZ9/048vjyuPoUxMrchPXcQDuU9O3XAgoWpri+ucpnisn0cxAUo+mS9bsuN3o/Kqu+QTggDtHtoNkrR6HXNadX4zW/Xc1lss2MyCuj7D+KqudHfJy9TIQOKEYLqBZ3skkgToU7wbcYAS4lW8FkLDO9gU1iQLsOwqGbhKgiBQZSK4Gzvsn5G5gb+O6A7pfoYuCUwJiA9b6A9NVP49QAZJran1dZlyIq7zTC4R5iSkj3ZX0pMs71nwZEeQsZMnY52biucDWu3JbhGCso9HqFJ8dmUfAJpbYOY3XdQsBgiMxTDw/Yh2Ar2GkH8iouY3wNAPgTJ+/U18SDVJv/Tn/dSpte1QOJK4dVJ/JkT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cCtOYllNWVhjYStpb205WTlzVlkxVWlraTAwa203YUx4alVOSFkrWWRaZ3R5?=
 =?utf-8?B?TkJ3TytKQ2M1dE1SSXFBM0tLNVNvajRDWC9MMHljTUVOZmJENWVFenlhdWpy?=
 =?utf-8?B?VTlFSWVKKzFxcEduMnpmTXA2MktXNFREc0tkUi9mNUhSMG9EVGE5dlJsNVIr?=
 =?utf-8?B?R2xWTmF4b3UwTTlmMExSc1RYMi9XM3pyUjBaQzg0MzFySzc5TUg4WlI2NWpF?=
 =?utf-8?B?ei9Ia2QxcXhrNGdva3c3ZE5sZ082Q3Evc2hPZmpoMHBnMWJvOW02NFd5US9k?=
 =?utf-8?B?cnBUUjl3R0R4N3Y5Wmh0VmVhUURIb0oxYzBoSlFKbjVDcnRqemdXSjVXMFdy?=
 =?utf-8?B?K0NZS3pDNFpmQUh4cGI0dENKc29NYlVDM2pST1gyUitnTzBmdVZnbFptL0Ro?=
 =?utf-8?B?US9TY1hQbVVMbUQrei93RnMxeGpTcHA3UVRaY2xkbXZsbmtjNTR4cEtQOTNU?=
 =?utf-8?B?b25HZ3hkWkUrTFFobXJmQ2xjazlYemZEN3labWdBRnpLUzU0a0xjcGs5dkhN?=
 =?utf-8?B?Z1lsWGJVR2NqcnJ4SlA2b2dUc0xzd0M4LzluaFBRaWd0TUhqRUlldWJkZ1VT?=
 =?utf-8?B?YWFBM3EzSG1lMlF2RzVIQy9OeXdUeUVEVHFmMkVWUWt5TUZUOTB5aThWeHNa?=
 =?utf-8?B?Nm1yNkhtU21lQXFQWTVjSWxyYk1qbllMSE9LM2diWGkwbmpkR2pkWFBNYmMy?=
 =?utf-8?B?Q1ZFOEpUUkJwMzQ2R203UUVMRGhFQkkwWTBEb2ZnelVhdWx5NUdjWjIzRlls?=
 =?utf-8?B?T2psc3JrQWU0TGcyLzB5TFVCTXF3Q0xiYTcvbFJ2ZmtXYSthVlV4dStOWVJn?=
 =?utf-8?B?am9uaXFMYWJrd3JSaTVTN1RTWU5oWkUxTE01NFF2RWRUOVNuUVEyZ3RzbzY0?=
 =?utf-8?B?QTUvYklmL3BneVFpK0hRMVJzR2hkU2tKNUhEcE42UmlBL2Z1dDZxblk1VXMy?=
 =?utf-8?B?cFpQSjFvaGFnRFR2dDFKeThGSzJDVmxaaG5aK0lFVVlaTlprNkFTTk8vWFJo?=
 =?utf-8?B?cGNjSys2TTNhZ21OTHdYT0FHMTNPNnNBTmV4QlpZdGFOck5YTzB0d0p0QU92?=
 =?utf-8?B?eXhKTk10SDlid2MvSEV1aGxCV2tDcDZQWERRTUxJQm4zV2Y3TndIOWZmdHVi?=
 =?utf-8?B?OG9qOHZ3ZW8yMTJ2SW1UTFBsVlRrbkd5Zk14a3gxNE1GclFtVGJZODNIbFQ1?=
 =?utf-8?B?bElFbFFBbGhxREhYNHAwYkp6YWVPeVpyVmEwaU1ncjNSNUp0Q0FtWWMxUzlO?=
 =?utf-8?B?VkVCOC9ibE9lWW94eE9GUDF1QVJ3V1RMQWRLY0ZjaVZrUWxvdE9Ubkp4b0t0?=
 =?utf-8?B?V2UrbS8vdlZZdGNNRlV2SFQ0MmlOTWF4VzBEM0t0Ym01K2JCOVA3T3FkT3Rx?=
 =?utf-8?B?a1VUVHB3QlkyUmdvZnNobzBOVFJLTGhvZ0d6TktTYnZFWHZRSDJIbFI4U1Vs?=
 =?utf-8?B?VllMakdjT2ZDcXNGdUl3T2hRcGhuQ3BmdkhFZjN0WS9NRE52a1JUZ0FCZFlE?=
 =?utf-8?B?VDR2TVYwTzlkUjhnTWxDalBjSTdPL1VxSWNJaW5OcjZveDRBVTFSSVU5Z0ZQ?=
 =?utf-8?B?T0ZHYmM2VU1iRHErMk1lYk9qcDJsV2RnSUljT0p4WXRHM09SYUdrV2RXRnZo?=
 =?utf-8?B?bUhoYUJEUVd1TkpSQXNlN0xCRHdNN09vZGxqSXQ0Qk5HK3QrN3pPUUEzTlpC?=
 =?utf-8?B?MytNK1pabUwvWVAyaEh1eHhlRHlTVEQzNFVMUFlkbTA2VGhnUVZneFZ0eFIz?=
 =?utf-8?B?QlBPU3VqbmNXcXpTZDNUV2lJNHl3NXg4clk1OXFpdXVpb2JFSFhNSlJlS0Vj?=
 =?utf-8?B?OEtBNDN4L2cxMmV1bENEYnFEUk5TNFBOb2lEWFFtL21oMGR3cCtLem5DdFVB?=
 =?utf-8?B?K3dBVWxpRHFWSlhzN0J0UEJhQi9CTWlSZklmRG83NmhHWE9QUWRnTlU0V2F3?=
 =?utf-8?B?SDBheWJuZjlRY2cyN2ZWN2tDOTN4U0V4S3NYdWdkYkI3Q25MZVhBVjNQbnM4?=
 =?utf-8?B?ZlduclJLWE5HQzRRNmZINXorSlFlMm9FRDNFRzQ2MjJvN0hTZVFMUUlidWZp?=
 =?utf-8?B?SlJBMXBydmQxdlhUQWlxZDl1VlE4TXJWbHhvZElINDZoSStQYkdwOXZNREpK?=
 =?utf-8?B?RDgzRVRjZGZyREdNbWV6aHFBRXlmK0V0USs5NDM2dW0yOCtxSDBNWjh5dEFN?=
 =?utf-8?B?MXJsZzA1Mk1lazBGT2ZxQUkxRWZlaVBtYjJPZi8yQUZMTG1wQmxQbWkvbDB4?=
 =?utf-8?B?TVNHK3dTTU1ZNGd5V05zcUtSTlRnVjdpT0VsYktzYlhwUkpoRnF2akZXRlZL?=
 =?utf-8?B?azlJdFdhNUFXL0h6UlM0NEZhOThOb0dIVFFIUEc2Tm1tVDNWbkQ4UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c541ae-3375-4a61-fb1f-08dec5eedcae
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 06:18:02.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LK4Wv41EcsYFhqFllwsF0mbuiXHQgXzBASA9CvvGo6UpDMXvdsa/gzb4hSZmjXjJX3RcVakDhLZxcZdFu5wdUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9069
X-Rspamd-Queue-Id: 062F3180005
X-Stat-Signature: 6qz7fq9aeyta1k74mdzj8oite1off6bo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780985887-229084
X-HE-Meta: U2FsdGVkX19XDpRQ20RtEWsRhQKwQGGI46Aui2dgeQVf7n5/kdxaieiFUC+nr2gEDwfLAKB+JMzQFYRA98J4bbAmA6+kNvawdUFo4bM7EoOJRUftpXwtkIbAAMj+RpBqwvWiBJYD4pSvAO+O6SuPCOjF+iJISlZJ4ZXogEO3XVz7/8C7oAluAX0DJOWHJA0iuByx58AKLZDxDUUTXGiJH/y95WB4gLrksf40u3jBP1WQvF/92R1T7dq4RGchcLSOedhN88slZcRN4TYu1+PP6XFp4NAk2FWuPZ9EXeFvbj00EUHH6NdMjLSDjueArpq++6vFJBLXhcfzeasX6L51VRXT1t1Yj9bOAzOkoPp6E1g/vbUg/wQu+4b+8n+edl7rQAsgYNVqDrYsLei20iifNCr2Jma97KEZr7sZdE0FLJAI5x5Nw2JApw6Mpie9Wa4fMKf0BMwVBHRCZjZK70D6KmOD9BFARiBZm6xkDNSUFKfJeW4FerKpvsQ4TPrcM1DAUFtWAlnIIAOeNzfajWb+7dQuLAsYjeeV7VoWZLO4qMVrpba2MDexAtHUlnOEk55t6TglB2DUGwYY2Y/erMXgfkXZ2gqxshljOT9m56w/trwnq/vTcslFZkr0ujAPJCHjiCj3vp31tuIir2elL9wYGWN6y+qR4xpI2juSDI6o12DvH0uUYN62p3dQC5w0bW0nmMJKep6C6Hz14dUGjDgxPtfulTdO+VPTaHXIrwLumUyH9raZlrJ+zl3x3U650rCmsetxl7mlGSjcGETjaY0CcqCWwyOuH8ey7m4fhWDj4N2DBksMG6qKsnHrdq0BUPKR0VjZHLzW9SGNlpdIbhk+jnboifJi7keYQ1GM60zTdzBwN+dUDgVRiBLMicZSwPFe0V1KBRNaCpb0/02qBZUUeCEwAJFoKx701C8pCJTrAA2MTXVlj51M1O4qq/BwXuJWGD3qsJva891D6dcEaKg
 io+wnCwZ
 mUY7G0ALv5/4S46cN7bamneJQCi5t/3ylj3UPmEMT1SuvivAElYIZ46yofKJ+YMmanzDm+BM988FPfNDl6eLUhfgdCFlyF7LLaNd9EiJfDxynP+EpXhjEShx33qjbo60D7wNXzwU7Q2EZvp9HwCidgbZqPciXHJvmIxBPzswjJkctI6xtzp1Z+Vbwzf/L6ZJkK+rR0P8jXeyc03voasUIFAL7DxP2XSDSlD7yd567kr0c4v4eWNtOg+rKiZVPEJEq81NtyMI8TfhGZY1fDEwn+YLW4d9fO+Zs+d5+yw/ePWO1AijgiaGKwxVZRE8cdDDAjDXP7ZRX/iR+tTE15Tx32BCOg5dScOtPYpnBvZulp41JuZOIG15BA2z/8YUbH7S3sb8g8+xG0ynmu0cC6dAVRjsYSDqe5pHnW/wT1F0fNCi6tGcTRWeWe7upMS/CpM+avOSR2xNbcYPTtzvnDsXWANE85yk3CYwiVc0piQU2rD02JTUGYCOswo5/XwSAeoWmMdqCS4Tnb2yt8VdCj5q5s3nuzHEjrcP8g+aNr9MDF+zSwJCLMR4S0GLXUCQ4abhW2tiSNfZZY9dUHqsxcsIO1PIq8HIeyxXANhkfGyYfaNwiWfpo2wT7aCtm5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/9/2026 11:04 AM, Dev Jain wrote:
> 
> 
> On 28/04/26 9:20 pm, Shivank Garg wrote:
>> These flags only track folio-specific state during migration and are
>> not used for movable_ops pages. Rename the enum values and the
>> old_page_state variable to match.
>>
>> No functional change.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
> 
> migrate_folio_undo_src() has a parameter "page_was_mapped", change that
> too?
> 
> 

Thanks, Dev. Right.

This patch is already in mm-stable tree and it's fairly late in this cycle.
So, not sure if the last minute changes are okay for this?

Given this, I'll leave the timing to the maintainers:
I can fold this and resend now, or send it early next cycle?

Best Regards,
Shivank
---
 mm/migrate.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 0c6a0ab6ecce..fd524f9e6fae 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
 }
 
 /* Restore the source folio to the original state upon failure */
-static void migrate_folio_undo_src(struct folio *src,
-				   int page_was_mapped,
-				   struct anon_vma *anon_vma,
-				   bool locked,
-				   struct list_head *ret)
+static void migrate_folio_undo_src(struct folio *src, int folio_was_mapped,
+		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
 {
-	if (page_was_mapped)
+	if (folio_was_mapped)
 		remove_migration_ptes(src, src, 0);
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
-- 
2.43.0

