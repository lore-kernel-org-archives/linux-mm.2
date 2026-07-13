Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDAC5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D466B00A2; Mon, 13 Jul 2026 15:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E4E6B00A3; Mon, 13 Jul 2026 15:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16496B00A6; Mon, 13 Jul 2026 15:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1B96B00A2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:27:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 811F380127
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:27:43 +0000 (UTC)
X-FDA: 84984738006.04.5106C53
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf27.hostedemail.com (Postfix) with ESMTP id 677A14000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:27:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tOw86IuJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783970860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOeeeWQvoVxsXu2OJErhgoCdW3xzL64SCCyFK8mKoTM=;
	b=KRwBXbB/YzqwDuz8ZmIsqny3InQ00rFVNVxW/5LBjhHoG5HNeT0e5zykdAPR260skGBvgJ
	Ku1bMtGHrabuI6zNk8BTraBFzjpADsa+XurdPJ1RKldJ+wt2YXoDOhye1DuPVPNJmuYCtr
	UiuPIdCb9nZEk8dH6K7EauderiIy33Q=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tOw86IuJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783970860;
	b=wdAzovy2hz8Jhzy5MC3LJgR9alcPLNKQE2pBSE/K2/2y2ZpLyiqBhoairp9PabuMwC03Mw
	TDCuGQ1xGSQJZg7xNiJCkoJ/gFCQm4/lBAN5Tn67ZEVucTLSJCml/OGjJziK7dsi2E2xbx
	HJ9AZ5z7ApSiabGy2Ry82OXyfGjxFH4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6Uh8Eq6sSo1RHzfT+WBvNEgqfd+ITMw4R6mtCZsnkKuxbLL4TLQs40sTplR1ATcsw0F8uZnbdwyBYF44Wqccezjh7431KO6eJtktKIH/coj6kI4cd4eO7/jcu06sAW9TSJGIwdKSRuUg4zJPcN+GVIaWxa2WfJiijWY9zUGRlfub/4JV0d6IahRptp3VuKtqixqCMx2bsSh02F7toVFB+hblAUII7V48fWQ1IRB//c4MjIyo+NypO1bxAp3S19TcqixVDZ8LdcYTtCUdOpQpYlA8mOlb9j+6KR77Xb7SGwEDyi9JD0RjrM4E2pMkSbCudD7zeYWHVZ9hIxq5Wpayg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOeeeWQvoVxsXu2OJErhgoCdW3xzL64SCCyFK8mKoTM=;
 b=NMPyyBAunxvLVVBjyKpPlUCjVUsA/yp8h0ASK1GlfqSu1cGRBn/zaCXJLcpGUbvCP/TtcnFb+XXafIHo+mJ5BimiRA5ared2JtF1IOQb4IA0p8vllgxmaZlCM0J49svS/OBrnuV63tkfN3Np3UYGjN/g3Gaq/X9+70SySG3cWUksSFboNuKmCM0wOigciQWFMPh4rkwDgm1pTEB7uN4MeBPQUjnUUxNSqfJDfhbhfpJRTNoRiX2Jsx6WywuoD+HI3k9OT0daqbLo6zs2ufkbjnaK50wR0WlqKg9hu1TH/wWUUyih2g3t0hbIja+J3oBfb4zfA3JVt7NdkaLPl7xchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOeeeWQvoVxsXu2OJErhgoCdW3xzL64SCCyFK8mKoTM=;
 b=tOw86IuJPtMsr5By85QKv0hhirBHh5NrGYuzyeCQpp+h6x+i44o2WtNplyhE14LMcBWdBM78EWDkDjszb+KKiy9jSqfEm7MCJuX2BcLPrPBEi/YfCBSVFnnxpV8owHPdjQ24RXXRcjibklqWwoJOBuxR0nzZoZ7CGHP7lcwK4MHJD8A7AW1PsPcUpa4Wf9SaQC7RGCsTfE6vK1oXl1qAF9JQ2n2Fry3Z/e1xxU3jKYMChXfLrd3DMGNeXgscAwulDuCV13ew93uxYXizut8+FaVzW/6E+b/cuk2UdGhd5D92WKQ4l0Jq95WNOpV0UwQ6GZwv/HMGoY+EfOTxHUfxNw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 19:27:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 19:27:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 15:27:34 -0400
Message-Id: <DJXOW0P35L9B.395DKD4LXEA3R@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Ye Liu"
 <ye.liu@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead
 of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-10-ye.liu@linux.dev>
 <0E890CCC-818A-47DE-9D1C-9EEF98CC758D@nvidia.com>
 <4d8e0125-0630-4070-95cd-acec3d626329@linux.dev>
 <622D6E1C-6E27-4912-A1A8-E5110A4581BB@nvidia.com>
 <4762af9c-e9ac-4162-a407-84d335325dac@linux.dev>
 <48dd2c46-bf55-44fe-b7e6-24037ba59aed@kernel.org>
In-Reply-To: <48dd2c46-bf55-44fe-b7e6-24037ba59aed@kernel.org>
X-ClientProxiedBy: BL1P222CA0009.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ce36bbe-1fb6-4f5c-206c-08dee114cad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+gIQkmhFylxMDsMEVOHm3scFczPoompi1x0Q6NXLV4ujQ4vgokuBfhvu52I/7TCQgDiCl8xv1Vw1iRexZfp9N7Pt1UcXLYpf1VS/zhd9gSgJMFuFkEFebB93x3TYyHmvH8ok2d0J1exgQ4Qfy1wb5veOWv/XUreaL2tuLo8dgb2ygLuSGsJ/arf7HYTS3AzhX3t8BkyzjSH+EPvs0kqopZdENFpy+axBXdajXvjd34zEc/P7vdkjT22WCDbgZA8haWpH6Fc5EnLE2OtPPJe2S+ECVlsEtoUTH/nhEF2ewgsl40w07eTdD5Y9GMffCKfMDzVMmJAWBYLNAkCczsKRR5Jil2/6wW12FzqC71u6vg/uni/RPbjys8MU5NNcJhmPgWXkgMA4xeV7D/ZbOXEt5MJKEWt7IfCFqNlbC91BK/KNLHgZVp7PBREC5afy2IjWpVKgGLDdTDJtxnd5pRJum+6uQ8gpx0T93k6LzJKPvwH1RsuMXdhQ6jVVaI85R4MZoX5OjbHwZOkvQlEs+ZhTMQwjbBKdUBMmRwzSKc7lvaPolbYtLWM8wpiuW6EjvcM/i6lT6zJ/lMWRLCSe0uYCYND5js7fFK+30JSPhFq00d7Oik28IwRMDUtCXUWE1W3AjSGscmIkdHkwZfbKcqJe9hSNyy/urb5W3nha2nPtoxM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3Bna0ZNa0RNSjdRWEU2ZkR0LzdZY0lyRUJ1aWQ2TFJpZFl1cUJQYmJLaUZu?=
 =?utf-8?B?NGR2MzdLaXBqek52ZGEvTHBtMGVQdHNjT0luRGpNekRGYW02Y0hNT3BKdC94?=
 =?utf-8?B?VkNSbmlVSW5KUFMrTWd2STRwR3pUQmwvNDBkYlEyV2NKS1R6WnRrajBFcnpa?=
 =?utf-8?B?eG5UeXB2UmtTM3lySTVlQnJkNnNYUVRHaGkzbDE1b280K09nQjF2SmFKQUZq?=
 =?utf-8?B?OXRoaThpeTRlcmdHQ1VCeTRSVSsybDJoTHgxZjk2RXd6OStIbzJib2tTMSty?=
 =?utf-8?B?SG1KZVFwc3REY3ArQkpPL0NTMThpTDlhcGU4MmtQOXlYM0gvTWtmemFqYk5z?=
 =?utf-8?B?OHdGSU5aWC9sVmhWc0Y4T2haeDdEWVFjTzBXbElqYWZxOTZIZSs5TUk1ZU1z?=
 =?utf-8?B?YjJlZTIwdmlSdE04ZjVYSzFRL2NtK1h1VVIxUDBLazNSWlZpZzkvT3NpUjBM?=
 =?utf-8?B?b24vb25rMFhzaEhtQldhL09Vam5yallLMjM2aHFPMmVsNUVERzZkencrdkV1?=
 =?utf-8?B?dE9MV2N3T3MvMS9LcmhOaWpyTzdCS1VRdExlRk8xTnRISnUvU2gzTlZtL1Br?=
 =?utf-8?B?NG5IY1gwSkd5YkV2blc1SHF1c3JMbTVzRUV2eWpQdzhZYmRsOGhjVFNlR1Nv?=
 =?utf-8?B?QmZFbnVMSmpHZUxDWUdldjEvQWtVeE1XTDhhZDVTVStDcDhURzcvTGkvdk1i?=
 =?utf-8?B?cld0MUVGcm1FK1VsYzM4UHAyb1A4YU1rVDFUTnRFMzZydG80ZysyLzNNUmJv?=
 =?utf-8?B?RFFxSWVaZlVqamc1NUZBUXZjTXkvdTBNUEkwOUs5Y2VrWG00VlVLNlFFV3pu?=
 =?utf-8?B?bGtnS3UwWXlFd3RZQ2hIWi9zRnUrUzVDeUU5TUI0ZTY2N3lRZ2hFeUNMWVdZ?=
 =?utf-8?B?YVZFWGZEcHRFQldyWmhST0MycDFqZ0xSYkRkNmM4QkJLUHN3WXZadW9PMVNJ?=
 =?utf-8?B?SEM2ZnJEZXo4OTJSd1B1YUtkL1dmY3Zvb2FBSFBXUEVMQW9icUhrRE9OSUhv?=
 =?utf-8?B?R1FKZlo4aHhmZTRTcUM2WE5kUVlEblViVTlWbjVscUwrQzhNanAvOTJPWHhh?=
 =?utf-8?B?TC9CMmF3ZU5MckxycVlkOWdjMWxOVHJ3NVJrcHlqeVcvbXljYkQ2VW9NNXpm?=
 =?utf-8?B?eFpqa0dpVHpJcGxzSk9ibCtTUFZuYzB0ZWxqZDZLUnJlV2JPUXJ0ZGZTbjlz?=
 =?utf-8?B?UXN6TVdqQzI0RXdLb2hjL1pYWlN1bEdWalZBTVE1WnJtcW5PZWNtWWZGbHZT?=
 =?utf-8?B?ZDlQU0M5VndjQ2xGcEp6WEZHQzZZOUVLblBaU1FqODhrcVQvWGJFWlhWUzEv?=
 =?utf-8?B?NWRpMU5FQU5Bakd4RG9pdTFsb1BwTmlqZmRSSS9seGZjVnRZV3MwNktQTFNz?=
 =?utf-8?B?dERTNm4xNE1hckJ6T1hjVG1hNVJqc29nZis2Wm5IRUc2RDQ0b25YV0U4OEJk?=
 =?utf-8?B?bTQ0VXh3cC9GYWJ0emRKNndyNHVkV0FsbncwL2tVTnU5MXg3bkJqa0s4WEEz?=
 =?utf-8?B?S21TbW5aU3YyaWkvdHRuU0VCaE9WYWIyS25GZlUzZE9USnZhdWlIM2pXckVT?=
 =?utf-8?B?WUpNTVhIUTdOS1ZDalRHWE1jZjN1N3BWV3BzOENUKzJ0dGRDdFpINW5MUmNa?=
 =?utf-8?B?eW04WXBpTElodnRCUXRzdW5SOFpuSG5lZXgzSTBuZW5CdDd0bzF2bTFlRkox?=
 =?utf-8?B?VjJIdjJxMmcwc01rR3FNWUcwTS9aQUpxWlJrUUkyd3BDTVpjRFFKa1Y0STBW?=
 =?utf-8?B?R3pscXBYZ3ozQ05lVUdvRi9sRGVSNXhPclVEbGQ3dzEwTWFXR0pKUVkyZWhO?=
 =?utf-8?B?U2JjWkVVVjJpNzg1dmRwdEtvYmZ2bWFHcGtvVDRnOXhGcFNLNWp2Znh2bWV3?=
 =?utf-8?B?QmxKZEprN2tGR0dDMU9aNlZacmlYa2t1ekRLVGMwSllHTFdQNXU0a1NPeE01?=
 =?utf-8?B?blc0aUtUVld3eHYwQjI5YkdJT0I2cHRFZ0MwQWJTVnZ4Y0ZNNVhZZGltOWpE?=
 =?utf-8?B?LzN4V2pMVldLeTN1YzFSaWNlMklVV3VOM2dXZXg5STVFMWd3T1lGUnV1ZkRt?=
 =?utf-8?B?NmlxWnErdllVKzRILzEzbGxBVXo4amNxTXJlNW9kZmgwTVRxeWxXdEVIWXBC?=
 =?utf-8?B?SmJnTXV0WllYcFFXU05UUmFmbktuTXRVYU5tOU9LQmdmUmdmY0JvUVNHdHhn?=
 =?utf-8?B?ZU84OWpLZS9rNW1vUzlkT2k5TmpiZ0hSeUtRK3dpVDhRMGFBSm1MS24vTUt0?=
 =?utf-8?B?R3lma2kyWC9nUy8zcnN6NHNsZkRTdEtZLy83cWlLRzRQOGhOOFhqUVdhN0tv?=
 =?utf-8?Q?slPGtTiDXo4aTyZ5hX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce36bbe-1fb6-4f5c-206c-08dee114cad5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 19:27:35.2871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61agDZLgeSDtpVPtEj0OxcpgXcstCvIQ9/p507WqGp6E6FD5w7ldu+dCjZdqWTM8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 677A14000C
X-Stat-Signature: ymr9wrrt5s1ox9ghohc843uz1zk5m9ej
X-Rspam-User: 
X-HE-Tag: 1783970859-686482
X-HE-Meta: U2FsdGVkX1/MoWkF4IWM1hgdQDiqFP0C8Vz0hz6vg25WEZkCBiIgncIQOhGAzkTX58C76Bo5MzX+CWDmi3U/88dBorjM1321/HAvvg0ekPqM73/TDp15+0gWgxUGbZSgJzMxQI7Jrg3ut2PoQAowIXbpI/R1fmOah0/DY7Rmp1RB6FgSdAl26PTc8HOGQP5lfjKuP4GIWOvYtr3tMcvssXbWcvcNT+yq9oFeFnKli1v0Ji6PWk5gQ971Y9CFem+9Zw1V/8iNjbW1OKspZZZ2hvabdml7gJN2L2VItk5GwlN2MqUoDxTjUodnsw+8PNPqVVqInJKgF8sAKVg3trIxDE/9CREj1RQC23bPpvzjXGxljFYs51qDmDdf1QDzHI8+uv9aUf4+S8Q5Mt3viJkfDca/1nscBQQ1eQAIu8hiprr9gCZOxUIqOQ0XTc65Kr6pXMSDFxOSRrZNFZQXbuiPndeZRv838az+q2F/T+kzgdig7CtydI7ZOqZbi8nXgNOTn3Wuf9LXyxpKz4FiWaJBc1sMSbCRUd/rqYOWuuCH3NKx+kSk6pVJvpLBjLSdEWXJlnGC9ak5LKrmZzPZxmSP17oOaO6KesTTMvwc0i8BZvo2vgBfpIGSYP3i6RIXSBS0K0ksY9P4Hre4nrUEOxbzyPoT0kmUjnDR2DVNE1Ez4JxfOK1jsfA+GhJrkGGYp6h5dPQA1vz9mQBKYzmNiQlCm/RIbjPnrzYQSdPY+z4GVoRNTItEjAGJ+pTljelc4R/Ub54RDcMNDoUokGXdIzhlu/GYy6vssttz1TLCHQG2UC1ZT3uEsj3V5c/cRRrQPZq/JhLRGPcZ8H5CHSTovJfgxRrre9pfPd5gk6B3xt/fgkChHzZH8ifuUZulh/9l49LX55mrivNERNTV/WqqPYaWIaMbdWGC9b9602l58MiPzAjIkdEvyLn3liPaVAfS75BoTjOIpv8naQ3jl1eo+jm
 0agrUnei
 a0+fq8Trr5s5oeQ9YcZ8ceBOQhPlnpyIqSiN/oX9D3ohSpdTbjp2fpR6D8CAD9/oUVIrk2vsDlZd5r/AjPgVq0TwjuhZa8NdE/v2hL1m3M1jzcJMYNB8mV1vVm5nAzr5+mdpGNcBiLpdR8wfxQrbgCPKxNk2WxMSEC3zTgQwXNxrAav4Sh6jPUW+19K67ZclJl8dOJVqAcvwMoHhQxg1/62t5RsQ6pZZlqlVsI3YrEiTTl1RqJtyOBuvSWmNfcIuva/L1j/QYmwQF5EMqlVPOePNed+TH9LWhHKPpsi3TerM2h6dh4gPufVydYncQNXfhWVU/L9fuf/BS1KKQwq/5FWnUn7NBTz2yIFRFxhdbmQG07zyiLLuKOWCP58NdJ6MX333TcuAnZ4wAjsFV3uXpZH9It12KXiyGwqgEP8GMsQu2ArznE1OjuVg4dgPBOgjGjQA8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 13, 2026 at 1:34 PM EDT, Vlastimil Babka (SUSE) wrote:
> On 7/13/26 04:40, Ye Liu wrote:
>>=20
>>=20
>> =E5=9C=A8 2026/7/10 23:56, Zi Yan =E5=86=99=E9=81=93:
>>> On 10 Jul 2026, at 2:51, Ye Liu wrote:
>>>=20
>>>> =E5=9C=A8 2026/7/2 10:02, Zi Yan =E5=86=99=E9=81=93:
>>>>> On 1 Jul 2026, at 2:10, Ye Liu wrote:
>>>>>
>>>>>> print_page_owner_memcg() takes a snapshot of page->memcg_data via
>>>>>> READ_ONCE at the top of the function and guards against tail pages
>>>>>> and NULL memcg_data.  However, at the end it calls PageMemcgKmem(pag=
e)
>>>>>> which internally calls folio_memcg_kmem() =E2=80=94 and that functio=
n re-reads
>>>>>> folio->memcg_data and page->compound_head locklessly, wrapping both
>>>>>> in VM_BUG_ON assertions:
>>>>>>
>>>>>>     VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>>>>>>     VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>>>>>>
>>>>>> If the page is concurrently freed and reallocated as a THP tail page
>>>>>> or a slab page between the initial guards and this final call, the
>>>>>> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=3Dy),
>>>>>> causing a kernel panic.
>>>>>>
>>>>>> Fix by reusing the memcg_data snapshot already taken at function ent=
ry
>>>>>> instead of calling PageMemcgKmem(), which is semantically equivalent=
:
>>>>>> PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_=
KMEM.
>>>>>> This avoids both the TOCTOU window and the assertions entirely.
>>>>>>
>>>>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>>>>> ---
>>>>>>  mm/page_owner.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>> LGTM.
>>>>>
>>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>Hi,Zi,Vlastimil
>>>>
>>>> This patch still has warnings (see sashiko link[1]).
>>>> I've made the following modifications, or do you have any better sugge=
stions?
>>>=20
>>> Maybe use snapshot_page() from mm/debug.c, so that you do not need to r=
eplicate
>>> the code from folio_memcg_check(). You probably still need the rcu_read=
_lock()
>>> when reading memcg_data from the snapshot to prevent memcg going away.
>>>=20
>> But it does a full struct page + struct folio memcpy with retry loops,  =
     =20
>> which is more than what we need here -- we only care about memcg_data.  =
     =20
>
> Yeah seems too unnecessarily heavy.
>
>> The READ_ONCE() snapshot is sufficient since the function already       =
     =20
>> holds rcu_read_lock() to keep the memcg alive once resolved.            =
     =20
>>                                                                         =
     =20
>> The two-line inline of folio_memcg_check() logic is minimal, and we need=
     =20
>> the OBJEXTS check to be explicit anyway (to print "Slab cache page\n"   =
     =20
>>  -- page_memcg_check() just returns NULL silently for slab pages).      =
     =20
>
> Yeah LGTM.

I agree that snapshot_page() is an overkill here and reusing the
memcg_data snapshot looks good to me.

--=20
Best Regards,
Yan, Zi


