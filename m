Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63DAE668AE
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 13:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84156B0088; Sat, 20 Dec 2025 08:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D319F6B0089; Sat, 20 Dec 2025 08:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE0D6B008A; Sat, 20 Dec 2025 08:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA3496B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 08:20:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1511C13B44D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 13:20:40 +0000 (UTC)
X-FDA: 84239909040.23.5F94B44
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf17.hostedemail.com (Postfix) with ESMTP id D78214000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 13:20:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=WtZgonEZ;
	spf=pass (imf17.hostedemail.com: domain of "prvs=844923c223=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=844923c223=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766236837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPeiHRYBAvxtRiIXz8xfz4xYSoUgVBnLaFNjoGRxrs4=;
	b=rA8w6A2f6c4VZ3q7uRlK8IJLr0le1UP6YCdxu768azVa4QBO5+DTVoRiGRbflsnT1WMs2U
	HSTjLnppWBxW9Rclt3rZGvHRMZNNmTQ4m7r9yqvQrzYAhT980DpcCm0IUbbeG/sqGVIHDg
	cI4FodFJrjNZ88WAVTctSuJr1ADk2tI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=WtZgonEZ;
	spf=pass (imf17.hostedemail.com: domain of "prvs=844923c223=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=844923c223=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766236837; a=rsa-sha256;
	cv=pass;
	b=7Aq8sYhT+8jhlMrJtbaj6X1XqUEzjl+zgZB1Mr1QQ3ZE+BcDRXcl28i4B5EMSeBYFTMzLm
	Murqjyv2eZFCvEsCH9qbZTSQqerZtScVWvjqn/mOtNP7G5heTlQ8HQHlmOJSYNbZa7rr4B
	eD1nv4q84m1n83tySLlRsCFpA1Qh6Mk=
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BKApRix517470;
	Sat, 20 Dec 2025 05:20:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=XPeiHRYBAvxtRiIXz8xfz4xYSoUgVBnLaFNjoGRxrs4=; b=WtZgonEZ2htI
	K2rHZPfG3gbuBM1btUmvBDMqV1Qn8CI5j4KImPH8du/Ei1W3OlX3V5R546S+jHCD
	aWXb1Ux+i/ybNmI1wc0YtXyUi/JgFBIJctonayc/LA3A0FmPM8Dsx6xGp86O2D06
	qSVmt7n5iGRb4P83W4DmrEIOb+O4yKWBSQYwYibV1Di/szRscuz8WOdGepX4Jgmq
	FtJGx8SQS0Vo8vQIk0QHPkNi8feDNFmqbXIaErXo2fqT7R6Zfdn4dzB8Krdrf1Cf
	CU8WIwDQiMi0mvVqwZehNtW2X0zALT/2wawr3iaUjoAXedD1zowQiDmHT1sqEGLk
	av/fibIXWQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4b5tdd8md2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 20 Dec 2025 05:20:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsZABRZSqHFyYjugliTzt47PIeEyhcBd+4HgIoOW7/0Rp9CkMiTaRqr97sCnE0ZDSOUbNJz8KzYt7c7zT02v7gIZD1W2dOpD20NV24YUKSNvrIZ1BX35o3loXvR87DgDYMD8/DYzcUJhSYsP+gvB/aCBF3h6CjN+eRr7oZCPWV2D+8BZfE7btFa9NbrBLhQo94MqpaMiJji2jTjL65UNNoV/ru6xK0/SRoFEodwh0lPrSeV4OepqgJuuRrkwQwjIeByNfbar4T6YDsWKvVzFp8fXM42rb5q+MI5yYQUXPxDiZujTUo0uQ5WSkPI3EDIK9+3J7tzGvuWex7VUnZszqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPeiHRYBAvxtRiIXz8xfz4xYSoUgVBnLaFNjoGRxrs4=;
 b=eJtIgD3SvtgxtF0gOA4ixtUFtx4wMZmjSXLR4Fb37ZdRKJGkVFICN7z08OUQbHgmEemAvtoyfugZJRplealXrddtvod7FLh6A9lNq96f/6sBinwRZ/Sm+V/xRLlsQkppjB7Zz8RZJUGxLh1g2mK1H2acsZqJpVwEZgdD2vuWNSQVX/TbhUVku7ZV1/ntbb8kdIOUauuUkfsPfGIC8itZpeg3nirjx2Tn2WwQcdpyYp3xcZ3i38/rwoBppLvWQIfqt6e/royxItp2SBgQjZaJMPdGszwJqf6lClvKnMNPYb1jmDY+cTjz4BlK1kGmqXsz53jkt+VJ8GnPm49tF2/tFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV3PR15MB6455.namprd15.prod.outlook.com (2603:10b6:408:1ad::10)
 by LV3PR15MB6411.namprd15.prod.outlook.com (2603:10b6:408:1a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Sat, 20 Dec
 2025 13:20:19 +0000
Received: from LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::8102:bfca:2805:316e]) by LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::8102:bfca:2805:316e%5]) with mapi id 15.20.9434.009; Sat, 20 Dec 2025
 13:20:18 +0000
Message-ID: <dfc73fd6-9e5f-4b62-ac3f-7c9a327dd7fc@meta.com>
Date: Sat, 20 Dec 2025 08:19:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access memory
 events
To: Roman Gushchin <roman.gushchin@linux.dev>, bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        inwardvessel@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        shakeel.butt@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        andrii@kernel.org, martin.lau@kernel.org, eddyz87@gmail.com,
        yonghong.song@linux.dev, ihor.solodrai@linux.dev
References: <20251220041250.372179-6-roman.gushchin@linux.dev>
 <8f23848b8ac657b4b4a2da04da242039c59e9ad9826a8d5fa0f5aee55acfecc9@mail.kernel.org>
 <87a4zdepdh.fsf@linux.dev>
From: Chris Mason <clm@meta.com>
Content-Language: en-US
In-Reply-To: <87a4zdepdh.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:208:256::32) To LV3PR15MB6455.namprd15.prod.outlook.com
 (2603:10b6:408:1ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR15MB6455:EE_|LV3PR15MB6411:EE_
X-MS-Office365-Filtering-Correlation-Id: aae67b98-5851-46ef-5dd7-08de3fca856b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTdpVHg5ZVFYenVsS2ExMHB6a3ljcnhsTDNuaWdEbVpxSGlmYWlRU1RPNnZw?=
 =?utf-8?B?NHVmbjRiSXZmdGp6NFhiSW1IUStnUmhCcDVhd2NjWTRFcUtvVWQxSDlXL1FE?=
 =?utf-8?B?U2VCbWJxZ1A3SWtHcVM4elVRc2F4SlJsdGtwYlJhb0syQnhFRFE2K2RTK0d6?=
 =?utf-8?B?YWdLeXpKWEtYV3FtTGFiOWJ2SHFhdEFqYytydnliZTZiQTBVSU1KaVF5UGdO?=
 =?utf-8?B?OWZJSnJPVkhxQXFsUSttQWk0YnZ5Y0JUQVNUVE5vUURRcmplU1ZKQ0NVNEsv?=
 =?utf-8?B?NlJNU0pqUW9RN21mUVlMNm9oMGQvZWRUOWFqTzRrUzBFRFVaYUN0cFhMU3lp?=
 =?utf-8?B?Q2ZHQ3lqWncyclJrRHlXelRteDh3Tlc2VkJQRlVJSjI0ZkZOcjRXRG92YXk0?=
 =?utf-8?B?VkEvVlZjcTlBNHczeDNtMGNWT1VqTU05c2Z4QlpNY0EwTWRnZ3NUOUsvSlZL?=
 =?utf-8?B?Z2RiTUgyRENkb0hhVmNhQVVWSlJkdUVSOUh2MS9taVhDWldva0NFSUdsWDFM?=
 =?utf-8?B?RVBSYVhNWnhSZUNlU2dBTFh2OElieEJUdmYxbEU1R21wYmhHdGJHQ203cytF?=
 =?utf-8?B?TkR3L2RrZkx5b21uV3hUVkliTFVja1JYS010RUNCZ1dLVmpvQTROdENLRG1o?=
 =?utf-8?B?RUQ2UklmdUF2TmJ5Y2s5SzkxdHVHZXFaZmZpK0lOYVhnM3BLbE9QYTFabVlZ?=
 =?utf-8?B?NXhrVDRqbktncko0dU45K0R6aTVrUDZnK2k4Kzl6WjNXQmRFWEN2bjliWlFF?=
 =?utf-8?B?Z1FLbFZ2b1UyK25qMXhFQzVFZHdWZXh3WVJLR1B5TENqUFhyaGppUjN5U2NQ?=
 =?utf-8?B?ZjdLUWhWaVF0M2RtcXExdTF2RndoVlhUWEJseG05andPWG15eThZVkxIUFV4?=
 =?utf-8?B?eVVIaWlYSkxaZUFVOEd5TzJyRGFnanhxT3ZMWVZ6OW1jSVoxVGFZZUR1bDJi?=
 =?utf-8?B?R0ZQckl1aU5aU1pLNThWWmJFNVhKNzIydlcyRHNkRk5LZjBqcHlaZ210c3VM?=
 =?utf-8?B?bDlQeFFXRTRUVzRiT081RE8weFpDaFpEK0Z2Ym9Ba0ZSZWtDRWg4VmdTU04v?=
 =?utf-8?B?THQvWnBxMW9Pd3hSOER1dXJwQ2luc2ZyazBTWVlqN2lQRldISTU5MW0vM0s1?=
 =?utf-8?B?NzVySDNHNnVPdlFQV2VSLzNUL0F0TGFVSys3MHhhR1hDd3VCVFlNaWcwN011?=
 =?utf-8?B?ck5TUEpxbC85eGxyWVg2allRKy9IQmQ2LzBFb2thVllLUUVqR2hvalVBR0Yv?=
 =?utf-8?B?VDlROEJNSGJ0RzJKQi9BQm03Rk9nWFZjSnhyV2hIM1dQY2cyV3ArWExBNXU4?=
 =?utf-8?B?bWNrY2JPY01xRk10NVR6TjJPTVo0WXlnNzJWSDNtSk9OSTh0NGR3VXhxMGdj?=
 =?utf-8?B?S3VLVm5VRi81L3pTVTRZZzBDUVEvTTJtdDhpSlFvMjNRUm9MZWpzVjZHaFZS?=
 =?utf-8?B?bGVQcEdwV1VzKzJnUTVNU0NyR25jb2FqUVYwOU5tNVpBS1pjTlhSS2t6RkNQ?=
 =?utf-8?B?K1B3eG1SSjZ1VmptdmFDZ2FnU2dTWU9CR0NxVFpyOVByQ3dEajJaOGhiMDdY?=
 =?utf-8?B?VkJRSzFSRU0xalNEWEE5anJxLzhUSXNhSjVzSWFreWtkVllnQnRpc1UyVVh3?=
 =?utf-8?B?WjNjZEt2MTVLUjNpcjEvdUdNU01NWmdGeFVjNVIzZzA5czBMNUJqTlVxbnlL?=
 =?utf-8?B?bzRRamQ1QzJLdE1MM2NiYm45YXhZREtwZFp0cHdNanJ1YkFNdGxzNEhLVDF5?=
 =?utf-8?B?QkFORlRIT2tuU3BESEFhcldMVE56QnVINEtSclNDUkNwUWZGNnZ0QnA5S2pG?=
 =?utf-8?B?TUM0MHlWMTl4QUQyUERMaWpMTUhKWWt5LzJjQW5kY2NEd0lYVmFjcThHYW0x?=
 =?utf-8?B?UzNTcHN4U0RBbVliMTMvSUhLaWxqL2krNW04UXl5a2J4djR5Vyt3Z0pRaGRP?=
 =?utf-8?Q?piUrU35FhYt+rgw/xw1eGrQLPMVB2md3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR15MB6455.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHc5bUZKUndPdS9xZi9DRXVyUnVxeHVXekIyTTV4M2lLRTN0dEx1UngzL0xT?=
 =?utf-8?B?VXN3b2NnN2RISlQ0UnNERWxSQVIzQ3RENTg2ZEhwV0xmeDM5VDhtMTNzbFZa?=
 =?utf-8?B?YlU0VTBYSmZ6T284eHZITjRydFVxa2VIQkt5YXNwQlY3elFaUFduSEFLMUh2?=
 =?utf-8?B?bitKTGl4dXFHaThtUXJtRUhVZkxZalZsQlFjY2l4S0NRNnlwMUw1SEtrdXk4?=
 =?utf-8?B?UGpFS005aTBJYzNBZnZRUzU3YjhhZ2VvSkl4OGdZMnc5aGFzSWRmTlRhMDhR?=
 =?utf-8?B?SjZMczV5OC9JM1R4THpwSHV6SHN4NURRN2tkbFdJa3BSR2NjM3lzaHNVSUhy?=
 =?utf-8?B?Sm55dW10bERBUExsbWI1SExKQkJ6by8xcWxHcHRIVjE5bC9LZDB2aENYakhQ?=
 =?utf-8?B?VGg0d1BxRG5vWDNBbDR2Z2NydlB1Q2swUmtlNGdPUkVlS1EzRGNMN25haXh4?=
 =?utf-8?B?WS92b1MxVjRhM2FHZGpMM3NacVVGYWU3OXM5aEg3QjNZaDh5a3QzelhGZjd3?=
 =?utf-8?B?dEhYWkdSZnVnbk9UVnR3MVEzU0VCaHJValFvbXNjYk9UbERGaGZXWmRKTk1L?=
 =?utf-8?B?MkliZDUrNlpKQi9iMXM3QjlGZVVPQko5T3QxQ2U0WFRCT3FGMVpKeUVqb0hY?=
 =?utf-8?B?TFE3ampwTytDcExXQ3RJWDgvTUQreDR3RVlpL2pyWk9JRHZiZEFoZTlSYTNs?=
 =?utf-8?B?RWRwU2Y5SUw4TTdMNVA3WHh3N1NVYWVBYy9RY0pTTkl0OXFsRkJtRC9iVTNI?=
 =?utf-8?B?VFVqU0VoYkhmQXhCWEhHci9sVHBQQ3FFYXpJQngwdjlvYlpSVFdNbXZVdXRr?=
 =?utf-8?B?OW8vdXNlcG8xVW9uMjhWUG1SVnFpWVdDY21YeVRDUndjSmxidmFCVGIzWW9O?=
 =?utf-8?B?cmkwdW5WRjBianB3KzcwcVR5Qng4WkFjL1VtNmxCYkRCSFZYM0hFbWFXMGt3?=
 =?utf-8?B?TTdrdXE3NnJLcm54ZXB6K01uajZPVk05SkJkdnZ4TnlIQXF1UkxzY0FvZnJW?=
 =?utf-8?B?TDhxZTdjdGQyTER0NjNYOURab1p6OTRmeVdyNkZXNy9WTHptYitwdTBXRlJF?=
 =?utf-8?B?NnB2VGV6V2lzQ3Y4RVN6K0lLMWlCd1pyZkpwZ2c0SjlHdVl5eWowYUMvanYw?=
 =?utf-8?B?U1Q5MkErWnB0SWVCVjNLaDhrSWs0SVhmSDUxWmxjZFkrNHNmWW1HaWxBdDlt?=
 =?utf-8?B?aXE3ZUxwYmxQQjFTYTM0RWFpNDlpakdGRzdoeEw2ZEhaRnBZSWJ2S2VYWmls?=
 =?utf-8?B?a21jN3Vsa21kWWoxWGQvdGlJYXNxaFBMUjBwT1lIbGFCSmZHRE8vRUFaYTJG?=
 =?utf-8?B?SGZTSGNZV01CcHJwMGpYVGtYQ3duSlg5WmFjNm9KQWVrNnRrVEtRNCtDdGJF?=
 =?utf-8?B?clNkdmN2dnJBdzU0Zi9meWpUVHI0SEZmNDNadGY3Sk82dDA4TFl1SlNEUHJH?=
 =?utf-8?B?QWRxRkZuR1FoVnVYSWtsRmNOWEpyemZjSS9KK0h2ZTZNQlhPTndvSHlabno1?=
 =?utf-8?B?ci9RYXZhUW5XaW12akJWZlZ5MWhaK0xzWTZYdHg1R0pzQzRpYXMwY2lQK0xT?=
 =?utf-8?B?WXBoWEZidjFpYSt1RlVCTWV6dGxGU1J5VU8yRjZEWW9RUVUrQlJJTXV4YVRJ?=
 =?utf-8?B?ZStMdlRUMmFISllGVmZtbDZTaC9EamVoLy9iYms2WWNQS1BQMVppK0VoZElR?=
 =?utf-8?B?bFFISVJMMGdHL3lPZUt3ZnpIUm1pWHordmZaWUdhaW5JMEg2SGwrRmNkQjdo?=
 =?utf-8?B?WEVoTDU1cnZNeFdTVWx3ODFVYTRkc1hWY0V5NkxGdHFtUmU3dXB3M2tRYktK?=
 =?utf-8?B?YzY1SmJzL1VRQk0xQnJMVG1PWGFUMHBNeTBsaWpMR3ZlbERQaXZaTWxHSnNI?=
 =?utf-8?B?RmwwOG1tUXJIS2F5SkxPRGY5ZjN6SkxURVlMZkZoczdVQmVpWmNtcTR6NmpF?=
 =?utf-8?B?cXQ1eno4STFzY0VNZm1DeGptZHEzOUdTU01ES240eisxVGwwUVJ3dUJxN0tv?=
 =?utf-8?B?Y1ZVQjZ4ZzdNbmw5eXVDb1U3LzBWWmRlL1E5SlVzUmdTVWpUTm5rVFVQcW5l?=
 =?utf-8?B?R0RYVWE5UmlRVFdnUmhmNlUwRjVmelNnUDRzWWY1QUxkRW5vZmpGSjJ5cEZr?=
 =?utf-8?B?YlFlakFNeDR4Q1p5eFBQWnYzOHRoN3JOaXNDRzAxUHJ2V0QxVEJ4dGxJQ0hZ?=
 =?utf-8?B?eVQ5NURHMktCeWl3Vk9sSVpoWndnazBWS2pvdXpCNmxJWmMxWWJ4OVZDc0cy?=
 =?utf-8?B?b3c5TVllVzFjMEJlQUxVazVRSFlhT3NOdWovWW1mcjVRRHJMTzk3RVZKTVJy?=
 =?utf-8?Q?D93f8kGYu5/X5sqzD0?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae67b98-5851-46ef-5dd7-08de3fca856b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR15MB6455.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 13:20:18.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHrxdPkof3o16hFBF+uCPP3q/3kwIBHtyVyVbArhgLAexMHkfssmOYm0HB0LNlYr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR15MB6411
X-Proofpoint-ORIG-GUID: jB7EOhOM9bpWTL16sHXE-mIDKn_3Ngd7
X-Proofpoint-GUID: jB7EOhOM9bpWTL16sHXE-mIDKn_3Ngd7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIwMDExMyBTYWx0ZWRfX8KbdopYOiKfb
 tWzwEqSH2Q6cJ/h5XMrfP9gTqXycdxUZOwNt8MvE6n0jk4WStbvFbg1oPA4JfMLIxIOOgFj9dWZ
 TeNe4Nj1P1LsilXpWSL0YraPRJtHuq8zNt6jqygHzHB2RaTP5kV4gZLQMULxUWupTvhKn8HdLAh
 LopyYpFPwu7s/XQ/3SQX2eoePAeV8vn3YngxL+8G4UlxpQbSXUR6sZF2vb+sZblU1sOkFMRwDBu
 WQoEad+euzGMT44o7625k2M1xEoP2JhV4hFUYfGs6AJGwRKBpwSRJyQwmNy9x+0BezppTISfLHw
 jT29Mix5itWa1zL+BDqVIDqxuL3xiReySrP7Zk42gd6vmlinKlFpEdyS2rbeTMcR3tzFHESsNeu
 H8yDOwI8RnjUS4Yxg3meDl2d+xtiilHjrhPhVpZ9vXV3Z2UqECKyCSyh/Qnt9tYwNYwVLh7o6YF
 KgY/x2RpChMnfmuu54Q==
X-Authority-Analysis: v=2.4 cv=eeswvrEH c=1 sm=1 tr=0 ts=6946a294 cx=c_pps
 a=9cGrGZFDAlRO1ZcMJRSO2Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=CHCWEd8Fxoyx5fOImdkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-20_03,2025-12-19_02,2025-10-01_01
X-Stat-Signature: 7ft8ygmsdkm77a6tp3qfijaqeguj3b1e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D78214000B
X-HE-Tag: 1766236836-846206
X-HE-Meta: U2FsdGVkX18/wAD7VMrC+bgzpGeKMrPZtzCCwZXKZHDrQzitKj0PNBXdsNH5rfqtpiFAPXuZRIRMGL3vECm0Qma3pmfOTqJAbwEYXZIOAzcYu2laY8GhqMVIw6WHyNUw7R3LG4B9wAXzkd7aXVvLtyGBJybikjiNEPVj9tRDcxI1LaQGcxKN75jXQT5QS74rFbbHbFa34XUY4GHRBJ7T5uZ6SYRhnVK2ASutH7fHyd/0bLKKShS7zwQMdzIDqNMGZytv6cnH7aZG+K/pUAJdYgibQLkzvjY39ZGvQjPsMkEkpUKuCcHPK2wEEO57Vxe98p0w3FcXh0FxUzdvYd6e3Ae2MmhXYj6JO8MG38+LsscjUzvymsraYgQ1lZ+xKFXGG3TZGL8e5gV+O5Evk48op0k50LcF4d5p7bdwJ5tTLRPACGdgH66PQKR6KvSZzN7I9p61Q0+qCE1OzLANFs1pXTloV8UCT0Ra1qeZmSykFJz2c2H+SmVMGiyvLk+u86C7x0Ije8heqvyhddFFriZSPHrwRy/AD6xDDENqqqvnIiaZIQ81Md0Rs1EfG2QvH7Dz0IG7gJqPxlH5E+ekM8EFrDYirFwlIBfOqacw+7xY5t/vXhD8SaUk/xss2OButSWJpSSpEZDUTVw8d298bHE+gzVDftx5YqsyhAZ+EhKj1+2397jqbHZXhiRgktAbWq41HX919yb5r0CeAyTc0FA9hMT+gzeBcxpYJPnAb0fpKMixdcjxd6bCZlIsbsZltLrz8p1I6lksUkL+wzROoObPq2n8Ys2MUHAU1zHJDVAc8cSPNzXN4sjku/JaQYLADOK2ulfQuyIt5lbzZU+xO5D5xPePyn57qSxK8/zxfvnDNIOSJpF8tZMcKEINf0sEfYgrL8U0GE81OpUa14GJ4OYHUN7cEblLVy9UWRBM+10xHo3X7rsMS6dFVYe/WhQPr2usI6d1sJNWIVYTRI3SM4H
 q6326AO0
 QSh/rBwrvhBLl8WR2bU4ZmOo5+NUFRf0pa1oknLHr+bh+dqJE9xHUXWqVLked1jUIP3a5kPbF2iP6Uw5/73TtnXDW9Rs769Blkzqg1EDOA57VkYtBgtDONgj+O8qZZRtNdyevsYffknNiVtQS87JCajqI3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 11:41 PM, Roman Gushchin wrote:
> bot+bpf-ci@kernel.org writes:
> 
>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>> index d84fe6f3ed43..858eb43766ce 100644
>>> --- a/mm/bpf_memcontrol.c
>>> +++ b/mm/bpf_memcontrol.c
>>> @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>>>  	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>>>  }
>>>
>>> +/**
>>> + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
>>> + * @memcg: memory cgroup
>>> + * @event: memory event id
>>> + *
>>> + * Returns current memory event count.
>>> + */
>>> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
>>> +						enum memcg_memory_event event)
>>> +{
>>> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
>>> +		return (unsigned long)-1;
>>
>> Should this also check for negative values?  The enum type is typically
>> signed, so a BPF program passing a negative event value would pass this
>> check but cause an out-of-bounds read from memcg->memory_events[].
>>
>> The similar bpf_mem_cgroup_page_state() in this same file uses:
>>
>>     if (idx < 0 || idx >= MEMCG_NR_STAT)
>>
>> which checks both bounds.  Could the check here be changed to:
>>
>>     if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)
>>
>> to match that pattern?
> 
> No, the bpf verifier enforces event > 0.
> It's a false positive.

I'll add some words here to the bpf prompts, thanks Roman.

-chris


