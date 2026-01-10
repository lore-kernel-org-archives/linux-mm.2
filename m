Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968F1D232D3
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 18:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590036B0005; Sat, 10 Jan 2026 13:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527466B0089; Sat, 10 Jan 2026 13:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCB16B008A; Sat, 10 Jan 2026 13:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 268D96B0005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:20:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 916D11ABF12
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 18:20:54 +0000 (UTC)
X-FDA: 84316870428.16.50FD210
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010023.outbound.protection.outlook.com [52.101.193.23])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8273DC0005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 18:20:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pnCMQ395;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768069251; a=rsa-sha256;
	cv=pass;
	b=2sZTDkL+SBJeCTDiMvfUf8KcW1wDCEmF0OpWi0c5vE99BpzxGzsEeJExyowSE7c53unNyg
	7NdCyUOUgtq6B2LPvCSqQDC7v115FL8Z/2rfI1ZunS8Okr2jTXTQnPnuRAWGi+jvV0sf22
	jHwYOuauNZtkOYBpFt2HkA7vz8+cpkI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pnCMQ395;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768069251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojB9COjcpSRzpUYsPLC1MiQdTUTjnqbvdMIawwoOc20=;
	b=rOVa7eK73CYwdCXypQwhB3SVmxb9pp+n3plYly6pQigIWL4mY9Df0C3PHyjEMeVfLmnHJ3
	t635kCnUO88AFN52S7WCewq9Bm/gQRV/nkjrH6GOMhTMLvPhsHOvT0wausql+KU4YJrguS
	hSHySbDIHP+dZDXPD5bk6vYVdqAyFlI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NiUt84FtM/3fJr9zko71SW75+FK+M6o5MRimC0C7n8cLZ9f1F2ahGZLTaTs5Y3zWkzrvtO+fSTbDUft0Nk1Xv2HL6pEKYEl74dqGVNoG/79wRRV4ZxpxdvBnh34783PzN+N1UEaEDZSkKb2uoWKZk7ounErmyFUu+Gxhztiiux4y/iY0m/hWDhWUFR6UjtUCIXE/uPfpJPFUK9yMnf6vyizF/K/KEff2TDd8VOgSIStcTa/qlsk0BKZM1hjn8UZsxz43xkjxVHr0WYpTQ7KxB76XswY2GxiKlkc7Fc37/hIUBw+Oz85IbaBfzX8Zb6SnY0PaeKbXeXOwoGbDRqRqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojB9COjcpSRzpUYsPLC1MiQdTUTjnqbvdMIawwoOc20=;
 b=mcAGvFMBaHH/m1Vy2AZ3ccsQ9RNtb4DV0Bbv8WADztJgsAQU6aSEN08vny2POhWCVb2cUb3Axso+jL+hb47sJs1RhJEAQFOi39ojpxQUM8calz6WKoT/bGUbXO4IJ6RdTNPKXR0b9RHPbnuKzxpcZrmfR1bd8LtxRAsksvlQg0gFq/Y2o36D6pJxNKxaUWMpIgV3tUqWzXjno+grc0WFzQf8vxgANcxT0Gmxhx/ppGHQC4CHCwotjSBIHN2TiCBcX+T6+0+R+Os7qU2/5cotzyhs1WoQvIj72hU1bzpNgcAuozYeCF1EiBr2ZRV3q4fQOCCxrWfSbRqVpRIjoq074Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojB9COjcpSRzpUYsPLC1MiQdTUTjnqbvdMIawwoOc20=;
 b=pnCMQ395LFQDxXL1HAyaSqRkiTpiRVAMGTjOuQ7Dz85Vy5Q5gtKOEHf5XOoLBei3Oq02BNZYPwR8KIazhbzavN78WWtAkzVXuBHnChvuQ5lqaMkYceau8WDUkKJBgRfuLSBExiF623ItNUauaV+4Be2voz2KXXTNwmD4dMG5mrQ=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by SJ2PR12MB8979.namprd12.prod.outlook.com (2603:10b6:a03:548::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Sat, 10 Jan
 2026 18:20:33 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9499.005; Sat, 10 Jan 2026
 18:20:32 +0000
Message-ID: <dbbfc5f1-d9e5-4d39-a2df-e35d6ba73063@amd.com>
Date: Sat, 10 Jan 2026 23:50:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251215084615.5283-3-shivankg@amd.com>
 <20251215084615.5283-7-shivankg@amd.com>
 <3cc27720-8f53-4b6f-9202-42b3b73928b8@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <3cc27720-8f53-4b6f-9202-42b3b73928b8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1PR01CA0152.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::22) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|SJ2PR12MB8979:EE_
X-MS-Office365-Filtering-Correlation-Id: ff711bf6-ce55-4074-c81c-08de5074f13c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clFDdFpvTW82enRSM0hneHF2M29DUFVMUlF4dzVSWlVPS0hobzc1djluRjEw?=
 =?utf-8?B?Nmx1MFVsWXd6Y2hVeEdaYTAzMEFXTCtPc2lCTlAxTkxWK2l3SFBORTh4YWpS?=
 =?utf-8?B?ellIMFdmSGFNSEFpdnd2enJMZ255bzFSV084VFMwLy9laENoREpQUURzMFRP?=
 =?utf-8?B?WjBndnl0Q2t5aERHLzJOSEVTeUpBQkhOZk5qaGpWYy92bG54WHVmZXFiV0l3?=
 =?utf-8?B?a2JpRHNRakl4K3VjMEJhRG1DTit2NHh2UVM3cHdIY2VyZEwyUHhRTDdQY2to?=
 =?utf-8?B?ZkNLcnM3VmhaTG9vTUFQZ0hJWk1WVVgxK2hwRkRkTVp4MDl5dkpQRFhPRExO?=
 =?utf-8?B?Z0xlVGU3eGc5dFpVUHh3aFJ6Qm9wTWhOcklMWmx4aHlaR2ZYUXI3WTZkVEZD?=
 =?utf-8?B?N0I1K3NVQkI4RDRaRUlkK0J1cVQ5Vm93UmFLc3dQNlEwWTl2N29UTkdReXlY?=
 =?utf-8?B?R0RxR1hUUjY1ZFJpRUJvcFlJSytsN3lhQXNrODJDU0c4UDdXYzlmZFVhZ3ZZ?=
 =?utf-8?B?azNvZ00weDNlMFg5RXlySlVVNm5ibTZoK2hxeVlhdUI1NXIvbkxOT1hrS3hS?=
 =?utf-8?B?TWMzTmMvMUFKelZwUXV4SUIzOCt3c0FobUF2eXU1dkVmVXZkOTNSMkZOMlpu?=
 =?utf-8?B?ejhWSGoreW9nSGp3ZUhLSnczSnZUcE9RNXBPYWZSYmcxbFN3ZnZzN3N1MGFi?=
 =?utf-8?B?MVp2VVZGeVcyNzJyQ1N3bTZVM0VXVDIrcU1wMVhzMW00bUpTSHBXZWF3N3FE?=
 =?utf-8?B?eDlxVEk0ZmdaVFRpWXd6WDlGMTRFc0YyQmllTnhGcEQ3MnBNaVdDSWNhVnQ4?=
 =?utf-8?B?SVp2SDNublJDVklTTGc2SVBUVWNlOXpaencvcE1VcTFEKy92TlRXQWl5NDc1?=
 =?utf-8?B?MmVacTlpbkRJSGZjdW1sZkZzbExMZGFoZ3NzWHdqSE1pRi9HeW5IUUNRMTJR?=
 =?utf-8?B?SW9oZzdPZlpFN1RpWE8yK0tScGo1VU1ZVUh3U21ZalRacSs4SE1DQWVrMzh2?=
 =?utf-8?B?Y2R0cHRxVGVQcC9GQzllQlZVR0QrYnVZWFNYcmZJYkp4SWVJY0RkcEJWRVV0?=
 =?utf-8?B?WDJUNHJZVlRLbDZMOWMxd1I4OXlXYVE0ckxDOTZvNEhSVC91VlFoakZtVHV5?=
 =?utf-8?B?OTF4TDlPNFcvSHE4QnJIQUFCQnFsZnlGc0VTQ090TlNEQytSMGxhL1krQ3Qz?=
 =?utf-8?B?Q0Z2VitTdDBBVFNXeXN3aVFDdSt1QWNjcTV2SllCOGRXNWN3UTNiMFBGcHY0?=
 =?utf-8?B?RXFaSW1zRGhVV2FEMHMzTEFsdWJjRmljdTNucU1aWEVMQ29aRVZPMWZoNy9E?=
 =?utf-8?B?RDhyK1Q1azIxZzBKc2ZCY0J1MTRDd1RjSTE4V1FSUWR0S2VhOVF3TnI3VS9i?=
 =?utf-8?B?WnRsVkJxTWlkZEUxQUdlWC9PVTdOUExBaTlRWDNGRmc1MWZHZXl2Q2FrRXNJ?=
 =?utf-8?B?S1FndU5vS3UyZG1vK2prMkRDdWRkcC81cStlNTZob0VHL2lpS3ZUVktaNXY2?=
 =?utf-8?B?VE1icnlrZEhMWkh1Q2V3TklVS1FaNXNhWGloMWtYaG9JT05vN1hUeU5UQmlW?=
 =?utf-8?B?NnVRWEp3Z3lBa1BrUS9FclJHQTUwbUtPSzRPb3IxWDV2ZjdVc3p5SzcxWU53?=
 =?utf-8?B?bFlwK25GWXRMUGxSYWhiNGlEa1ZGYjNoVkNva0UvUWtyTjllbnZaaldsQVdv?=
 =?utf-8?B?aE5INkNSQzZ2MDkxQXdKc3ZvUWJQM016bC80NTlubE5ZUFlPVTNFN3VOM2VP?=
 =?utf-8?B?STkxYjlSZkFmYzBVa2J2bDh1aDd5UHAwU04wR1djL1NJa2dzd0JhY0d6MnlE?=
 =?utf-8?B?a2UwU2RwaTUvQXY3TGZPd2tWZzZWcTludnFhY3E2RVIzVk13R1o4MURvUVRB?=
 =?utf-8?B?eWQxSWZYcUZRQXdLT0ZXRitNcEdDOWh0U1Awd0U3V0dGd1plS1J3SFVmUDMr?=
 =?utf-8?B?aDRCZ1BqVmJWMVZPSk9LSHdxdDJkcGlDZW9rNzhXaGlTN1NWUG9BUytnaVdl?=
 =?utf-8?B?WEUvUHd5Q3lRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3VyVFhJL05JblUxVHEvZmQ2K2Q3UzdieXFIZ1kxOXJqdzhPWTBsbWpINU5s?=
 =?utf-8?B?SStJYjYrT1ROVUdBY3NVWnVyTTJmOFc0TjdrMmtKVHFBN3U2Z1VjNUN4T0k0?=
 =?utf-8?B?c1ZrY0l2SFA2RGVnelRWUGYxZlUxbDhkOFVEVzI5OVlUcXVpYURmRFBYSWEv?=
 =?utf-8?B?YlA1TW5aYzQwYWRwc3RSZjl0RXlta3FZRkF3em5WdnEwTi92cGsrVlIrbXds?=
 =?utf-8?B?ejVoWE1URTNKZzY0aE5JK04wRm5YWE5weFYvQ25HV1hEVlg0VzVUeXRhNjd0?=
 =?utf-8?B?S1dTM003U1lZdXVRU0YwNGpCcVgxNWxkSzNJR0FaZkVVSEtpMlJ6Qm1yd29X?=
 =?utf-8?B?VytLYWJzaWRJRFFmU0hZSmg1RnJzamh4d096Q1lRQ2U0aDF5ZWR5L21ETllq?=
 =?utf-8?B?REdnWUVFa1VHMGpzNTVMSjUxaHR0SmRNRzFMcEJWaGJSRlBjcERaRDZjSlhC?=
 =?utf-8?B?ckZHS2xyT2RsYzY2cmFETStGL0xsWlZKY3VrTWdoaXdPWWZ4TjlieXd1anBF?=
 =?utf-8?B?VE9EUUdPMjVKK2hIS0pkL3craXFnSzhjZ0hvTG1FdWY5dnpPUTEwUE40U2Qx?=
 =?utf-8?B?OGpDOHVCZm5rZXZIazdsa3hhQnNzTm5qaTJWczEzczZoS2sxOGxUbFIzWWJO?=
 =?utf-8?B?eFZNNkhFd2hzZitFSzllT1Iyc0NTYlhMSlpCMEFGVWtQcWdMR1RaY1Jyd2dE?=
 =?utf-8?B?NXd1dzVVNDlwSXcraGowVjRMWTJYN0hobXZLNjRlcXYrb2FQbzkvOURQdFRy?=
 =?utf-8?B?b1pGeWxMODJpRnIvTHBuM1M4bi8ydTVERHFpZUY5OFYwMHk1N0pidVVkcmw2?=
 =?utf-8?B?STdaVUIvZ21Vb1NWTWZxRHZlMk9GUitCYWtMSzhTS3VXYnJYRHZ4U1h3VVJG?=
 =?utf-8?B?WlB3dkc0cDNCbEZBaU1QV3o3ekdTWURsMmxsV01NWm9VSmVwNTBXT3pvOEZv?=
 =?utf-8?B?VzN2ai9hVHViWGwrbzBDQnBDYmdIaXdsanZSZE1KTWp5MjFVVW5VdU9xaWY2?=
 =?utf-8?B?akRUMlZCOSswSUxxcEd1VjFmanhIaFRFcXlrRG5lekpuRU5TZ0p4QUc1aTFm?=
 =?utf-8?B?SDJDbXR2SnVxZUZpUURmSU5xVVM5OHpxZnUwamZpdnk1czBQeWYrczE0bkxW?=
 =?utf-8?B?eU5YM0NWN0JQZ3I2a1B4enUwZFJJSG9JcmlOdUZzYWlCbnJMSjZaV0tPQmgv?=
 =?utf-8?B?YVEvbVZTeWxsRDNuUmN5cmJUcmFaYmRnMWs5bXd2dWQwcWhVOElwVHFjVXZt?=
 =?utf-8?B?WTFkaVgvZzhnZHMrSE9zWU1GVTBONDdDK2MvcEcveXhMdFFvaUtXbUNzWS9k?=
 =?utf-8?B?c2creEJ2MWdNNXBGWHNZemxXOW5pVjkwZTIyTGExZnFMT0lMRTYwTjgzUXV0?=
 =?utf-8?B?cEo1Nk96bFZGamFHTWxMU2tlR0ZSME53bnJINGFjbW5YYWhqd2hmTkhPcENF?=
 =?utf-8?B?Z1R1U2pTTEtSTlIyck5sTmlLejk1K0Y4RWNsYXlkZFh2Uit2YlM5NWNIRS8r?=
 =?utf-8?B?Z0dQaFdYZjVtWUdEYkZhVjNZZk5UMFZaUUpRdUEzU0lVN1Vkd0RUdi8vcTNH?=
 =?utf-8?B?cTNtK2lZVHk2RHVWMC9aZ1hnRkVMb1BoWlNaeG5jdmhKdkNYMnFQWGN6ODB1?=
 =?utf-8?B?RStySU5KRiswU0tWa1lGRXRjRXRvOTVNKzJXc0hRSlhGaC9CekFPTmVCQWp1?=
 =?utf-8?B?ODVxK1FxbXVNbUt6eFhESG9VRG5HMjlTVWFoMW03ZzJNSnE2cmpRRFZRUHNX?=
 =?utf-8?B?eE51RU9RS3k0eUMwRys3ZFlEdkhIdkdNL2JzSGVabWxtR0hqb0NwMCttZHE2?=
 =?utf-8?B?Z3dIbmIyazY0Tk1BUkZwZVMwdEppcUcxTFNlVVVGRlVwbkpRRjZZM2NWUGIw?=
 =?utf-8?B?bmkzSzhtWkVRY01HVXdSWkNFSXhpVzlGeXpYU3Ywd2xqdHd4NjFlcE9xRVBW?=
 =?utf-8?B?MzQ3WDN5Uk5PSGdQNk9zbzg2NlRzZmNRaEtZVGZxQTBINzZTNXJlUHpTeWRk?=
 =?utf-8?B?MkdnS0k5T25rSTJvZFNqM3g0TEtuRVdXdzkxWWZ3MUtKQXB5UmVSWnRKZGp0?=
 =?utf-8?B?NEhXT3FhTGtNM2NGUEhBNkFjdTBsaGFnL1hybjlGQjErbGxFNEw2bHlvaHA5?=
 =?utf-8?B?blM4c1hoMWN5ZElodktCZUQ0Y2lzcUl1cE5LVUk2VXI4RXZUeGRUVVI4ZmYx?=
 =?utf-8?B?N3MvNVcvdzZVc3JNb1dFM3AzT3JiVDNBWGs2WmZtd2tUN0p6WXZjUzJ5cXhG?=
 =?utf-8?B?dTAzMWNkdUxadHlRUG9Fa2c0TXJJQzNsTDRiUjkwdXpyWnNtUWNudlkxaVEz?=
 =?utf-8?B?T25YRzh4SHZKcmlYRFE3OGhOdG9kUWhLSngrSXRwbDZhVDZIMFU2UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff711bf6-ce55-4074-c81c-08de5074f13c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 18:20:32.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBO4ANFyT6I3jWAYV6mU38KkidtIvnOK+TmSBEwczSQrylR49bZIIdYNB+DPyhNFcEk+k6kFYTiQjCaxkN2GJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8979
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8273DC0005
X-Stat-Signature: rt7e8f6f9h1qrxckobjsn79cg875fsem
X-Rspam-User: 
X-HE-Tag: 1768069251-738921
X-HE-Meta: U2FsdGVkX19dWplXWVQswdUBbhxJFh898dZCcFshrmds5UjyiIaLPAS8qFIynuquv8Am11xyPtgedybD+QB60h47ymK0+qLQk7qS0rVxgu5wugadzhzbAIfYp2q3hv1vbeqIiJCBZgYuAoBBgF92s1a6q/1ZQ5ZzuqvixD7T0ULVCTK8XU7YjG8gFfMOPYAjqeWOZ0j+FvVHH0+SSX+BLqHetADCAtdC3tOIFfqcqJHVT2lHyBIu3DredqJamvtP9YDg5ctgdIWysNotljFNRTZE4Vsd3B2amkAJUxJrVOElOh/xTorOPvV1pYv9bq/xyD0whN/D9eh0LYmXtJZ7Cj37JTm4yL2xbQSRCaBu84iGiDjaIDzTxlUtIZuuppFE4bCeMPGPs2Mg8dy3ZwRJ3e791Hw2LX8frdnxPeUVd7n7t9Q/nDXDyDEnvetLYz7qBmJS2kGspS+ufHK9N79PX1k8NqMlLrcoENKh8SQdSBOZzZv2vUJJv0PiU0V5UmoJ/5aQgbGJruq4w/3R2QKmz6T+Z1XQYtp8TPvrbHMD+oZuipxWQiwlgR9y/mGRdzEoRWaj+T3/w+ZrE7NOt6AQpRgXYie1BoQ1hq+6EMFV0mFYPPAn0QudwpQg8yvd/yFlOhizZiEqrR2LfBVw715i1mclgRY8ON+m6jxSgDSSRlHylf2XyawC4iP6T0VsTARTjUby2bVw6g30aOUDHvdi3iEsqBnURuQWGMRA4Nt9WJmMBEiyoVSO8Y40bo0PGyUreh/EnSHWoMHDIHqiuBwwr29w+GVzv6UKKLO3Aup3FKOtYMc+hRGcfDyT6sIq+dl6OdcnJ0+iw/k02NXYDBuPa1iU13yV8gTtPO2XPoSWc38TPZHy2ffyilUPkcHKEB/L68EBR3xLo1SgHVB/r7ClpJ1MCg9fUuzIG/Sq2n9sBe3UGu/NyEyMgXv/BUr2Fg7BK2+gLCAOnkCLnsX6q8J
 svpjFpJC
 JPDXW2eL+1oQ4QAN2L87nhcytPNr8GHTWQ4nanbPX0tFfdfoG14MxVXVj8SK3cKFUwRiOcKzA5ZJlrWgSVUL7g1EUFOq5nVnO3hchjcwwyicMeeCiFCSeCAs0MUlFgGe6RvZ+XIyNsFYAnZWZ/gmxdB1eE25Qk1Egi++150La2cV/rxQZBxQFMTQTPW9f7uvPS+IFqbzlp5QN8UY+wG2m7yp2EspibrnhF5ChqNFxF1a1GP/7awqEbQzYDRqsql3I3TxwGXDW34O0TWEEBiSYqnOeklUh2Eebk9xKpsT/6kSUAeStZuz7Wc6DtTOkmV2RG6jg37N29ik0EiIK0mpvKWrkHlyyUM+H3hvn7wqtzO9uYQdsi/BIFKVXEgEMNhYRSNEdCBblJIDCqsL6nLc80OE4z8ghCvKsl+dh4s+JH5x8D5vlA024srF/EEFD+e1xBAp1BlfvrZgjD54qr1WNvXTPiR3vbcKT01GskKC3KP/PpZYJEQLYokeSVD73H40kXPI6t+cIrpONeL0Gut5AXlrTfIrdOY0Y/SYM3ovPGUOsINrLICTXtyW2DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/9/2026 8:16 PM, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 09:46, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes.
>> collapse_file() will trigger async writeback and fail with
>> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
>>
>> MADV_COLLAPSE is a synchronous operation where userspace expects
>> immediate results. If the collapse fails due to dirty pages, perform
>> synchronous writeback on the specific range and retry once.
>>
>> This avoids spurious failures for freshly written executables while
>> avoiding unnecessary synchronous I/O for mappings that are already clean.
>>
>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   mm/khugepaged.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 40 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 219dfa2e523c..6c8c35d3e0c9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>>   #include <linux/pgalloc.h>
>> +#include <linux/backing-dev.h>
>>     #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>       hend = end & HPAGE_PMD_MASK;
>>         for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>> +        bool retried = false;
>>           int result = SCAN_FAIL;
>>             if (!mmap_locked) {
>> +retry:
> 
> Jumping into an if block is nasty :)
> 
>>               cond_resched();
>>               mmap_read_lock(mm);
>>               mmap_locked = true;
>> @@ -2819,6 +2822,43 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>           if (!mmap_locked)
>>               *lock_dropped = true;
>>   +        /*
>> +         * If the file-backed VMA has dirty pages, the scan triggers
>> +         * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
>> +         * Since MADV_COLLAPSE is sync, we force sync writeback and
>> +         * retry once.
>> +         */
>> +        if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
>> +            /*
>> +             * File scan drops the lock. We must re-acquire it to
>> +             * safely inspect the VMA and hold the file reference.
>> +             */
>> +            if (!mmap_locked) {
>> +                cond_resched();
>> +                mmap_read_lock(mm);
>> +                mmap_locked = true;
>> +                result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
>> +                if (result != SCAN_SUCCEED)
>> +                    goto handle_result;
>> +            }
>> +
>> +            if (!vma_is_anonymous(vma) && vma->vm_file &&
>> +                mapping_can_writeback(vma->vm_file->f_mapping)) {
>> +                struct file *file = get_file(vma->vm_file);
>> +                pgoff_t pgoff = linear_page_index(vma, addr);
>> +                loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> +                loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +
>> +                mmap_read_unlock(mm);
>> +                mmap_locked = false;
>> +                *lock_dropped = true;
>> +                filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>> +                fput(file);
>> +                retried = true;
>> +                goto retry;
>> +            }
>> +        }
>> +
> 
> This looks a bit complicated. Can't we move that handing up, where we have most of that
> information already? Or am I missing something important?
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386f..c7271877c5220 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -22,6 +22,7 @@
>  #include <linux/dax.h>
>  #include <linux/ksm.h>
>  #include <linux/pgalloc.h>
> +#include <linux/backing-dev.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -2786,7 +2787,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  
>         for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>                 int result = SCAN_FAIL;
> +               bool triggered_wb = false;
>  
> +retry:
>                 if (!mmap_locked) {
>                         cond_resched();
>                         mmap_read_lock(mm);
> @@ -2809,6 +2812,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>                         mmap_locked = false;
			  
			  *lock_dropped = true;
>                         result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>                                                           cc);
> +
> +                       if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> +                           mapping_can_writeback(file->f_mapping)) {
> +                               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +                               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +                               filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +                               triggered_wb = true;

				  fput(file);

> +                               goto retry;
> +                       }
>                         fput(file);
>                 } else {
>                         result = hpage_collapse_scan_pmd(mm, vma, addr,
> 
> 

Thank you for the suggestion, this approach looks much simpler.

There are two small nits I observed:

1. In the retry loop, it is possible that we reacquire the mmap_lock and set
   mmap_locked to true. This can cause issues later when we do:

       if (!mmap_locked)
               *lock_dropped = true;

   because the caller would no longer see that the lock was dropped earlier.

2. We need an fput() to balance the file reference taken at line 2795.

fixed patch: (tested it no longer reproduce the issue):

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 87ca577c2668..b88bbb54f109 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -21,6 +21,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/dax.h>
 #include <linux/ksm.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -2771,7 +2772,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		int result = SCAN_FAIL;
+		bool triggered_wb = false;
 
+retry:
 		if (!mmap_locked) {
 			cond_resched();
 			mmap_read_lock(mm);
@@ -2794,8 +2797,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 			mmap_read_unlock(mm);
 			mmap_locked = false;
+			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
 							  cc);
+
+			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
+			    mapping_can_writeback(file->f_mapping)) {
+				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+				triggered_wb = true;
+				fput(file);
+				goto retry;
+			}
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,

