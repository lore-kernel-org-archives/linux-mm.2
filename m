Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED60CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 22:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB9E8E001D; Fri, 22 Aug 2025 18:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4936F8E0018; Fri, 22 Aug 2025 18:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B1A8E001D; Fri, 22 Aug 2025 18:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE238E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:55:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 635B281556
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 22:55:24 +0000 (UTC)
X-FDA: 83805901368.04.85DCB4C
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	by imf24.hostedemail.com (Postfix) with ESMTP id A08DC180006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 22:55:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=llHF91lR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of vdumitrescu@nvidia.com designates 40.107.223.66 as permitted sender) smtp.mailfrom=vdumitrescu@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755903321; a=rsa-sha256;
	cv=pass;
	b=PnUHS8p+mJlqDodCjj7BpgdXDlizdA/98SWQAT87wjwWIj5oxgaNqP6VXFpcx2ZeVgSzqQ
	YG6m7pbvy27LlYkkBTf7Roq9BReAvSrRJ/hQIENVYce+Fv5yoopiJ3JJEN7QsTIFoSOPv0
	Wfr8oVIxk7GHZyB0CjWoqEDdlNoZc5A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=llHF91lR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of vdumitrescu@nvidia.com designates 40.107.223.66 as permitted sender) smtp.mailfrom=vdumitrescu@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755903321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ktGT4bbvvZ7I1Q3qVa27WlbHjl1spnruvu/v1iAFkFg=;
	b=OZfDWY5mmE957NpL44+6xwlnCDPSUaZXpJj6Zm+pESBrlKWjZoRwLsZASh7Dx9dRoyK5om
	srIgta/j0i8sQSqlByqEkOjuxuxx3/fK2CHlk3sH/b1QDToICFsIH1vSDoDBBRQuS+QsRp
	RRB1ZpGL8P9ICLAbBrodY+e/djJkX2Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyFBKSHVq8p8xg2tpkwJG8Xlu38FxhthZUB85B9NhgZVh1YcQ6UgU2ov6rjWGVL4vWE4VmeegMwe+1hVvsqgb69tAT6yWFjIjDqtZC4v1x92tpZG9HZlNjYxQQr/Hm20+hZ2A6tEtvdqtZCwQChW8AVc1IgrHBLn+4/x8velGN9F1piI4ydDHPq2mwW27bA0UjwTQ1CsZO0GC1zhdnxgwPBiKoWSHJGakDR8VF2J0y3tlteiL5Oyna+3KyR7cINFjTJMl21XMNzxquFEhdKIRyJSuCOmWA9d1ijs7zMAFh5jikl3RCxL59dMWXFwueIedsdLD7Rf78zywNXCH/lNUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktGT4bbvvZ7I1Q3qVa27WlbHjl1spnruvu/v1iAFkFg=;
 b=jRFA33tW0vmksusmAsIFH2ffjm3XDg+cj3q9Me/ajBwVpepR6y4/y5XEYiqhO96ZEvx3WlhZCXTIIZ0o9jcVGXAVFoNcbbUon8YtkJ+C1kDPksf2AIzF3v1d8wcHtSOYArET0Q+8pKh1o1MbwKRyI7GI1tHAM5wH5DIht6WHparwktc86agJHFok9+dQSkKiE+3lfM6ByEFYWA27dNHLM3Krma0KeGmrDRH+5FD8NAUf4Aql2cNcf5KyLO6nm8n+Zd+heNMHV9bpkw0LZ/eYSq8J6kybnJhNifNFFA3xshBYC+Rpp/yW0l0NzCSD050h1l+EmiloIqO16CSPsB7bdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktGT4bbvvZ7I1Q3qVa27WlbHjl1spnruvu/v1iAFkFg=;
 b=llHF91lR8MclaTojnEN+zZm5tEIsN1MSVIA0lD/QZKDu1T2GrZbUcVFBrh8g0ex8KpuvP69Mu1rSlnI3JyQdaeZeGfaSiOqc0wZ77eL3Sx4S5rRPi3m755Ov3hWnMUxAWNHRix+dorHTXzfqSLWsdQIGgOuQYQ8Lrb4AhXJXJu9NSlwIXOjhlyyvbL+MKUB7me+iCL/HQ7Uf97Nqb8kULErcg5mMPYGUog5sBVs19iI3BCFCx7IOXzIPA/lT10hnKndnx3K0QLa8IFynyHHwu0jYg04tOZ2KecZP3l+b5n7ZQ2BAQe80G6AIO2TFVecEG1tSlHIpr6ptBBjQzcoVQw==
Received: from BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17)
 by MN2PR12MB4126.namprd12.prod.outlook.com (2603:10b6:208:199::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Fri, 22 Aug
 2025 22:55:18 +0000
Received: from BL1PR12MB5205.namprd12.prod.outlook.com
 ([fe80::604c:d57f:52e0:73fe]) by BL1PR12MB5205.namprd12.prod.outlook.com
 ([fe80::604c:d57f:52e0:73fe%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 22:55:18 +0000
Message-ID: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com>
Date: Fri, 22 Aug 2025 15:55:16 -0700
User-Agent: Mozilla Thunderbird
From: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: [PATCH] percpu: fix race on alloc failed warning limit
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>
Cc: Baoquan He <bhe@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:254::33) To BL1PR12MB5205.namprd12.prod.outlook.com
 (2603:10b6:208:308::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:EE_|MN2PR12MB4126:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d6a4c4-a910-4fc4-7784-08dde1cef72a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWhwMW0wYUR5c3RqTUVVSktwanc5RzZMMHJYUDFxMlBVWWk2Q0svQlB6aUI3?=
 =?utf-8?B?N2JEbEhOOWo2V1MvUkNIN1p5V1Z2aTVvVDF1NmErY2FBMXF0TkpDak1QNHg5?=
 =?utf-8?B?Z1RTOGI2Z3R2SVRrRXhyWk43MERFMWVtbmhjajczRW53K0dsOGF1ME9EVUN6?=
 =?utf-8?B?WHE0SFgxMHhjN1NHdVdrK0ZHL2pyQ2xlL1JrV09YOXYzLzkyQVFMOFdTdk1l?=
 =?utf-8?B?V3NMVFZuazRUQVVidWZkMjZEbzh4MTl1bXlnZjg4cnNXVjdURXBwZFJOKzlG?=
 =?utf-8?B?S010VjNtZFduUEp4VHhHbzNvOU52blJlbUxFVTBodlNucHdRdjZDNkd2OWtz?=
 =?utf-8?B?QTF5eWZIbEk1ODd4NjBzY2h0TnRWbFVXWU1JN05lbWh0V0xIOTBnaGN6MmI4?=
 =?utf-8?B?emlneXVMUmZoQ3VHSlNhOUNldW9uWW1GVGhhRko5aVlzWHNrSGpZTXpCSWph?=
 =?utf-8?B?SS9EMmNnQ2hzdkxLemlRWEJ6UUZFTVJ5MmFOSSs3ckZ4RTRMdFV5T0JUSDZi?=
 =?utf-8?B?WWJUaitXYjhDSHBFbFhXdURRL0pZRVpzMVdvbHk3NDUwMnU5cWUvK3hiekgv?=
 =?utf-8?B?aUNuUWx5Tm9jYWxTY1JjQjY0NUhZRnhjc2pBMTdncHBCM1FqMXNlSXluTS9E?=
 =?utf-8?B?bFBtSVA2ZG4rek4rM0dlNXU1MjlORGc4NmVZUEFqLzV1eVBKN1pJcTgxTmF3?=
 =?utf-8?B?d285bW03L0pmODl4SFJDVytSSVptR0hOY1phWDBCRitJdlhJa2o3bTJoOFZC?=
 =?utf-8?B?a1VDMTBBdXBGdWlYcDJ5Y1RxS0dDbVhqWis5bDlZQTVXMGRYQU4vMStVbVg4?=
 =?utf-8?B?WEtrRWMxTWlxY0dwbTFTcFh5eThZTkpXQkF6WDREejRQZCtwWnMwY1JFeWpZ?=
 =?utf-8?B?T3AzNE1rem9EU0o5b3FGZEExM3YvRFplMUpzY3oxVkZ3S3puV0I1clJlQUs3?=
 =?utf-8?B?NWF1c21iM0FScjhQdUdnM01McUtzWTc0eTVyQlZCT2NOdDVNckVvWnFqZVBY?=
 =?utf-8?B?aWNOY3ltbkFDeWpaKzM0TjFwYnJxb0dmK0ZoYXU0VXZFQnpPNklmM2NtdFh1?=
 =?utf-8?B?dFdPR3V2bjlBQ3IwYWtvVGxiOE5HbEh6TkxHUWlXVk9Kcms3UGEyTEtHalR3?=
 =?utf-8?B?MVdiTjd5QUIrYkdpQ0I0WERjSlgyRWV2ZGRFZkFpa1FzZisvUnU3cG43NGJH?=
 =?utf-8?B?aTk3ZXl0aXVPQkxHWlNpOHRZeU9od29IWEpEMUR3ZE04Sjg2cFRHOGlmcEg3?=
 =?utf-8?B?VWZ5SEhzYUF1dndqWjcrNm9JRWtyRG1wbXJzbUh3WEFpM21pL1poN0xUbWND?=
 =?utf-8?B?bnBIRDNqa0U1c21oNWJEbVJhdUI2T2FLNVRHMnhsODRPZDNtbTNnSFB0UVFF?=
 =?utf-8?B?OEVCRnhvbzZCTnI3dDFpclhkVFR5V21VUStRVWhNczRXOSt0cUJrcEJId2tq?=
 =?utf-8?B?UjdNMHlTSE02L1A0NE5vYllaSkRub1ZNcS9LTkNzYWlpU2QxL2dGN0h5Y3du?=
 =?utf-8?B?VDR5d1FrWkkvbGFDdEdYVjhkWDlDRU85Mms4NTJqcEFzcCtacXFCYVQ0YkRo?=
 =?utf-8?B?ZUpMbExMVVFWSjBIQ3JMUUkxQklPdjlEVkFROGg0WXlud1ZYNXYvSjVEUFdn?=
 =?utf-8?B?Ylc5Z2NEUVkvT2RNc0JKY0FGM1FRaTZFSGpPMmNNN1ZLdEtPa3Y0OFlFVkYr?=
 =?utf-8?B?bmhBZE1vL3pzVVlWYTRWeGtHZTEwQ2x6OHV4S25FOHprbGRJcFlMSVkxVXMx?=
 =?utf-8?B?V2tWM1d2a2lxL3dWTDJxUXhPTXgyUTd4WC9FMENRTDBlQ09aWHBwTDM2a3Zx?=
 =?utf-8?B?eVV6RFZSZ01Tdmt0emxVcVNUTFNBL3gwbk54WG8zSmNYVjRzYTJ2VzhFT0Z1?=
 =?utf-8?B?NnV2VGVrSnhMME0zVUdhcElOWDAzU2pMSUZoNjZ6RCtMVmdmUXpub09SWWdM?=
 =?utf-8?Q?BWewsbJxMvI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5205.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uzk1eDZ5bU1EQmhhck1DQlZhMVJHb2pERStKVTk1cytzb2NIM0cxcWhLUmsw?=
 =?utf-8?B?cFNTMGQrTEJIQmxoVC9CSFlGOTVoTU1ZUG01cW9XTDBGMCtWYm5xNUVOUDlh?=
 =?utf-8?B?UjVZL09EbmZKUW5LbzUvM2RQdDh6UE9qbkx1amQyRnR0NFpOSFFMajZhc3NI?=
 =?utf-8?B?Z3Z4Y2oxcVkrRGRzVWVETmxkY3p2MVc1MUJUVmtXdEZBaGFBNnc3YU9Qa01W?=
 =?utf-8?B?a0VoLzQ4b2cwMlFVYVk5UmF5YVZqS0pBZHc3bXpQdXBwYTh0RXorUXFkeFZJ?=
 =?utf-8?B?VVZhUzFLaVptYnlJSEErTzQ4VHRVc1ZYa2lyNzVkNU9YQmlZNGxZSXpvQU9L?=
 =?utf-8?B?WTBHSDByYk5tTW9sdFg0S1Fha0YyMXRJd3lidk9iNDFoQXY1eG5ScUhlTVFZ?=
 =?utf-8?B?a3NkY2M2dnVCUjkrRGsvdTNlTmdxeUFmV0pWMmxQRnd6MEJiSk1xV3dHcnVx?=
 =?utf-8?B?VDVVOWc4MlpWQU9jZEU3b2xPODloNmoyZXZZM2x4WGFRaWV5S0hjQ0dBSnY4?=
 =?utf-8?B?VTFGU2lGaW5iWk04NG8vOG9JckhUY0cwWlgrTjlDTUU2ZFhSUWJtajdKajBi?=
 =?utf-8?B?c1VvclFqOW5yQW1ZSU9QaFpEbis0YnJmN2NieXhoMXM5Q1h4a3JIUTNVanlC?=
 =?utf-8?B?SFk1cndReFV3Y0RzTDZub0JVNDVKNlJhSllqWXF5WW8relpEY2Z3Y2JBRjFp?=
 =?utf-8?B?dUJCemYzVUNlb2hnbm10aWVlT2NwYXVsQWRyeUNhRytUYlNhNzhuWlIxR08v?=
 =?utf-8?B?dUlZOEpoK1E1cGN6b3AzZHMxU3A3UzNQWG1VOVAxejJiWnkwZnBUY3YyekV4?=
 =?utf-8?B?RHU4TkU5WVZabkQxdGlrcmM3cWRXbE43cUc0TlNMVVR5TnIyM1VBUDZCdkhs?=
 =?utf-8?B?VUw3WEhPc1QydXlVM1RvT1FBbjhwcGVsUDVvTzNPN2NGbzFXTEo2eUdSVXgr?=
 =?utf-8?B?UzlWdG5Vb1lzZ3d6NU5pUUdqQ25JdkVyT2dsVlRkbHNvcHhpZnNoclB1dTNP?=
 =?utf-8?B?ditOd05uWXY4Vk9zclVVU3RXUlRscXVtS3Mxc213SStlazkzc3J5cmNOcVhS?=
 =?utf-8?B?eFdmMXA1NzljcjFWdkhlNFZtb2dENXJFdHV5ZUpPTWZqdlhJc3J2d0lzTUlp?=
 =?utf-8?B?UFpRTnluak9OQVo0Wlg3L2JNNkpoN0JoYWVXTXNFWmFlVGo4OGtnRHp3TlB2?=
 =?utf-8?B?SWxIR2kxT2JuSnBsRWloSEo3RGFCY1J0eGFJUXpxT1VHV2lRZnVEaWwvUkM4?=
 =?utf-8?B?dzNUUnU2Y2NkSGQzYUJUMGk3aFA1b2JpUGJPM2M1d1JDTDVWcXpqV2lMdEsv?=
 =?utf-8?B?ajlkVm1rTDVoeXVac2VMaHpCMXBqeUt0U3hHTlNvSThKU2tiYTBTMkJtOVJw?=
 =?utf-8?B?L3NOaXBuTHMzRGFiU1ExRVRXOFBLVFdMaDdScko4ZFVJNFVJRzM1djlvL3U1?=
 =?utf-8?B?ZGFFam9nTUtKd3VrN3BtWk93L2UxODlWVGVrc0E2YTgvRklmVVBwZlpUL0hF?=
 =?utf-8?B?RWFNWnhnV0s0NWdnaGRqSG9SdmlzRDl5YzREV1hqeWRVUnQ0anNYZzBMMk5h?=
 =?utf-8?B?Q2k3dFF2eHdUQk1FaUIxRVdUT3Y5ZUxvdkRRRHc0ZEdWRjBxZWtWdmZYSGli?=
 =?utf-8?B?UzVTSjh5Lzk2UklQQVdjN0ZYbmRRbDlKUkpUM2FZSytUWlIveCtSd09kYVhr?=
 =?utf-8?B?RXdLZ2MzZE1iMzAyYWhJMS92RXJ5c3owWTZ0MFhYMFVkbG9xYUMxdVFBcG9x?=
 =?utf-8?B?VG5XeEVTaUxuVk5qREc3K0hidVFSalJjNmVQV1pVN2FhMVYvQStSVG1aTFdB?=
 =?utf-8?B?aUlBZVlMWWtJcXZlRzBsb2NJNVhjT0c1NEw3dXpzZ0NCSERwZE40Zlg4SjZl?=
 =?utf-8?B?UFE3SnlMZnpac0MxUG1YZGNFY2FvblFGQkljQ2w1RHNuMjZ4YWFGVGFmZlIr?=
 =?utf-8?B?a2tyblJYckdxS3NVRGZxNm1sTmxObkxhNGFObkpxSngySVJ0cHNtb1NJYzZL?=
 =?utf-8?B?b3NEVno3OFZLNk5VSHJZRDUzRm9OTFFmUXhDbjZyVEllcmR4WmoxZGxCVXFy?=
 =?utf-8?B?cTFIWi85dXpiczdqbWY5NFlSUE1Qb2FyOWNsQ0ZXS29aR3pFL3Ztc0RBVWxx?=
 =?utf-8?B?VDJRUHhUcUs5N3duYlJsTHFuZGt0R1BXQkVlTWpXY2lHYTllTnJqSDJiTTVo?=
 =?utf-8?B?Smc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d6a4c4-a910-4fc4-7784-08dde1cef72a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5205.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 22:55:18.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWpMdqcTDM5KmHU+PQ8jniKntyCQWg6j/N3gWvqKZ1LJG/ivNFPD0V2Bqp4N1YTW4Q8O8hak3QxocP1961au9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4126
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A08DC180006
X-Stat-Signature: 1copk5jc465qh9qtho1hg47knh9jrdow
X-HE-Tag: 1755903321-828370
X-HE-Meta: U2FsdGVkX18BDnf2bUKxGwZR3Eo+z20fhvuYrHkhOsTLVeMjphRfbe9VsXR1yNF0+gBlBC1H8SWDjMwseSUQoLssCL8ySBC7pVsFjeSUGr6sQ9legSlNqEbLwElGVQ9t3vhJKevYfjx7w5+qMKzTWHxHUtx2R4iRqYQ/NeGGP+ergkWz4327zL0NRYS6ONwjeG/KA2tItL05HP7igR7p1/OZ4nTLRvOi+fXaSJ142PYQN9JD1hQHLgqokS7ZbJ9QzJt0JOMYiDmbDIPHhoXcnnTgpOeP49hbFOClEE27z7W8uh56tb+K/t4aJdrP/D2rDO9W6q/SRAXq38B/SSPVMjFFaEYKMU6V6zJRBqAbfMxxmfS/pGqy5UuoLVIOslwOsKtom+ZGTojyUz183Y1Sqxx19K7nEcR4l6THDmnQSr4oxO+cdneEpMgP2WmtockfFQhncqzTijygs3z6H6KAoYwSlpSUFXKNFSvuKtxOIICZQM2g6EMg69Wnk6UfQDF3a4r45zwTC9hwWHrJwnXcNkBxX9fnDAVP4ENt9Okp2wSlP9cCa2MpFYZxspM0vK9nB0iPcKdup5nxRIOwK8+he8ruXrRTNnwVmCDV509YIJW+M5Fz98WmS1uHC3M8Aa5jQjLNScYY5t37+qi1BtsLwA33wCsqERzSBBZze/bQ/cvTiak2wImE5qdlVrzhrJzdu2bnJyLfubwSX7dXTpuW3CWY9kZAMHvRaST/6lIgQXdI9TTfb7syJuT1ekEU/gyhRT0g1CXGZi4XEgMPjLskKnRimUGyHNGNosiu0y9xBdzAk/Y887ohAw98jNgs0l+oJbsEjN77Uk5ESQ5bp2lmk44GfokYwuh8ftvyBFSdQtfaZHhPv3YUJvXPotjh3MkoRZ2ffEX1SyL7CLMKu+bfuOKFFFkpOiKbCA69OUmnQUbxuOfd/QNEY5LvRc7jgxgfovYDVOP7JyFS1NOsGaW
 T8LTy3z1
 fBpkHKfiNy1Y1r/vYskQGj5HSB5Kk7akeMI5yCHxQgTAHQiolsmBrO05O7wUSCTImdDW0lmDeR9edHqtg1fa7Ov5oLXDSnXiddMIrmw1zSCeg6poNZGlne2pCcmJVr5/dlAMC3IFJyjXCO+zX3VZBLGmHG/9xqXfhxax5pPzzygGxTqQulvkkQ08ldhakSlpBspBHc3AJGoulr1WLELR8mcRgj+DuQsPJQJC1cUFMaZKS2zJtmiBYhXvWLOwDGcQHgl8+0idkPU3kgBb1dVmzhdum5D6PsF0I7kckev4+q92SF5iwlXXc/ksUwqLYaqGijozVi2cJ0PLjeZ+z7Ykm9nODLdpFhYEcavBUIKf1a83D4KzrTnZHwe7SKGDGLgNxLRa/AzHsrYae0avm110bUiPJkozp7LtMI1fgTcftozWF1Hu0+bLkBnS79MRQrZ64QGd8sRGXZ/0fbJ9qhHsGVg8JO0AUrnNps8ylsFDD6mVQvn7VI9lVxYKXujMTdTbU5/9zWwI/CsNdn62O81PBpAfjDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'allocation failed, ...' warning messages can cause unlimited log
spam, contrary to the implementation's intent.

The warn_limit variable is accessed without synchronization. If more
than <warn_limit> threads enter the warning path at the same time, the
variable will get decremented past 0. Once it becomes negative, the
non-zero check will always return true leading to unlimited log spam.

Use atomic operations to access warn_limit and change the check to test
for positive (> 0) as it can still become negative.

While the change cited in Fixes is only adjacent, the warning limit
implementation was correct before it. Only non-atomic allocations were
considered for warnings, and those happened to hold pcpu_alloc_mutex
while accessing warn_limit.

Fixes: f7d77dfc91f7 ("mm/percpu.c: print error message too if atomic alloc failed")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
---
 mm/percpu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index a56f35dcc417..c1a4089eb4c3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1734,7 +1734,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	bool is_atomic;
 	bool do_warn;
 	struct obj_cgroup *objcg = NULL;
-	static int warn_limit = 10;
+	static atomic_t warn_limit = ATOMIC_INIT(10);
 	struct pcpu_chunk *chunk, *next;
 	const char *err;
 	int slot, off, cpu, ret;
@@ -1904,13 +1904,17 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 fail:
 	trace_percpu_alloc_percpu_fail(reserved, is_atomic, size, align);
 
-	if (do_warn && warn_limit) {
-		pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
-			size, align, is_atomic, err);
-		if (!is_atomic)
-			dump_stack();
-		if (!--warn_limit)
-			pr_info("limit reached, disable warning\n");
+	if (do_warn && atomic_read(&warn_limit) > 0) {
+		int remaining = atomic_dec_return(&warn_limit);
+
+		if (remaining >= 0) {
+			pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
+				size, align, is_atomic, err);
+			if (!is_atomic)
+				dump_stack();
+			if (remaining == 0)
+				pr_info("limit reached, disable warning\n");
+		}
 	}
 
 	if (is_atomic) {
-- 
2.49.0

