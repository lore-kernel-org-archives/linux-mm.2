Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5685CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C51B8E000A; Mon, 20 Oct 2025 13:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D5D8E0002; Mon, 20 Oct 2025 13:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BAF8E000A; Mon, 20 Oct 2025 13:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036DE8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:55:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 806FFB7848
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:55:34 +0000 (UTC)
X-FDA: 84019244988.08.EC76605
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	by imf18.hostedemail.com (Postfix) with ESMTP id A1C391C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:55:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V4DcWIQd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.2 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760982931; a=rsa-sha256;
	cv=pass;
	b=YqSfAabJDbZFof02i0/4e/Vsx88XLWp2kINYNge5gPLqeNnST2Yxp7MutuHO6GO69tyw/N
	7ML7UFp9U+PLVsZqcqIi+t6N2MvW2G0mL+XVJY+E6oPzS1gAXmkQ3+6kKhyhn3z/24EhFe
	dh4tCpmWu7uNSXDISQVd1b8rYpwY0O8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V4DcWIQd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.2 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760982931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vjE7SPpx36V5X+A7Sy0avsEip8LzwqBFCgTL9p28iM=;
	b=YXLT68FZejtsbmS0tGcXd59fT+vvNu+CZPDnfbBY3KM6v+Ods27abHjeZ3iHBfqFh3/rHl
	1awDN/yVHT9AgjXNWKXCBn0ACYxwPbYR1uJ+14MlD/AxRjbq9LD7Y3vc8vhYCSiCaWlKcc
	kJCoPm3Pk68LF4eE7CDUK1hyKMsbIb4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCUaf7aWgdU+0ht9LIV4YfoIfaH27ThABSmdFZW7LvjkTifryGluMStc92kzkuFi9gInt+riG+hr2eiPb53tdYMmm97q9k82gdMyqPXoCDqlhkA/+nCUMx69YxqZmoUgyxgz6a8yNKbS0GMo7ODsRuOlFIfGKr7xMTSvWAuoITvtUVjHb58MUzBS310NVg0z4vLsF7moCWRDBfBXElBaKb0kl7ST/JxyoioBVZaMGV6QPWcdvwqTkl0JQGQTFHztR9rJF9bPOX/SxStl6QYa5aZfHyWdBphgWQdsSEUUK5+sk50nBf7ehrBvbfcR9943a3SzZT9uaESaMlBfBCa7ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vjE7SPpx36V5X+A7Sy0avsEip8LzwqBFCgTL9p28iM=;
 b=FufH511rQIvGOeQ0FEAK//3wLri2/RiFgKN8fzfyFYre3o+Vi8Bd8lpebfN0LTicfNyvqRM5x+/U1wzK83k8ZQwREvXcveFYMmHl/zCvx2P4071qqza2P6WkkzA1U99bzaycBnAPX7n2Aqbll6Ld8sA1Ia7aOV2mZl+pij1BztmMbY5wymStJsXEhR9K1CZTK26SYzYlJfqf2J/Rw+0Zm6NVucgFBJbRmkoWfnbG86sHC+8iWTBqEtEpeCCKyve+LO9N1lI9VnEa3hk383Er4LiogpwBVHq8P5c1k3Pi3LHKLadgME+KdqWkeBJBmYDJrsxrJXcnsPSFtdZLgf0PNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vjE7SPpx36V5X+A7Sy0avsEip8LzwqBFCgTL9p28iM=;
 b=V4DcWIQd0zDBJZuSXA//cylx6YCCNOQXkPL52lo/48pRmRH3zcj6Rmv5GIh1FPzGpRv/2bIRYOlcc92N0unLiepvYDIJZoy94mNuftYNiLPlt6D5zAoSRw+iG4xiTto0U8GOAjL5my86RMO2xwzsdCTy+uzPxvzhsNG8nsEQbOA5cR9clbWYFP7eblr7Nx+E+Ql1XSCoN6zr75idDM0frILZJedORp/vfjlt23EAfs1Jfo1azvhfu9+2tPKMk6EgD506nUTJ4FXNXYF6ASXQ0D3MM2k581TZC997I8msO+SC6A9UnPgz6bDZlgL0sHlM7h1O2BhKtCw9tnEjz3w6pg==
Received: from BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 17:55:28 +0000
Received: from BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4]) by BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 17:55:28 +0000
Message-ID: <a1cffdbd-ba98-4e24-bbb6-298eba40a11e@nvidia.com>
Date: Mon, 20 Oct 2025 10:55:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::18) To BY5PR12MB4116.namprd12.prod.outlook.com
 (2603:10b6:a03:210::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: 667744ba-e855-4638-fe93-08de1001da4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnJ4S09Oa2NlNUNLQ3lqblJYelQzalF2cDRQSWh6ZGZCS21BR3N1YjJEVCtl?=
 =?utf-8?B?OEplT01idzRlR1Q2aE5pTnBjeXdEcmdtZXc3WWdjMzBhUWJWOHVTajJyRzcz?=
 =?utf-8?B?b09BQWtEa3lVYlVqVkcrSXpBZElnNzRGaDU1OUNnWGkrUGhPZFJpN1Azb0gv?=
 =?utf-8?B?ell6b1RBWDExWm9VSGQwelZKYVB4aFZBQXJDUUtSOTlUUm8rUXhjbFg2aUFP?=
 =?utf-8?B?Qm5TVURJNHdPNWE5ZWRvVjVpbS8wTWZpUU8rczdZT2R4dXNwVGVxSEVTNStY?=
 =?utf-8?B?Yllsb2lmWFpRRXFiS1A5d3d6bjh6RTNEMHFFUnBiMGFSMFJ4WFE0cnhOSHBG?=
 =?utf-8?B?VGgwODRrRkVNYXpWM2kvdEl3QzRTdjBOM2NOZE9FeGZKUCt4QVhvQ2hWV2F4?=
 =?utf-8?B?enFGci85UjlKNW9vT2NZSk96WlFIMThmdTMvMFRJNmI2Rmswcy93V3A1NXpJ?=
 =?utf-8?B?WitwRy85NWl3cVhpNlQwbTBQa2lKRHl0NDhINTd0clBpVi9qNWE3R2dPd2Q0?=
 =?utf-8?B?U0t0OXBCdnVlL240ME9uV2FkSm9zaEw2bm1zM0NvaDIvYm1VVitOTGdkcDBv?=
 =?utf-8?B?cUZKak5GeHV6R2hkM1pLWHlkZEVYa3NER2RBQUlzNFQxRm0vaGUrbVBMQWg1?=
 =?utf-8?B?eGZtaUZLeTFSUi9VVUh0U1BDU1pVRlBpaXY2UWRFcWdpQ2l1Y0llZ1A3TTBI?=
 =?utf-8?B?cHQzY2U4OGc3STJYV3lDMzUxTG5iTFdhRWt0YUlHcm51TkMvNk9qcVErTHow?=
 =?utf-8?B?dmtKbmV1UVBOS25mTEk4eXovZ09La3ZqQjJIM2ZUM1ZTM0N1UFVqN2pOWVpF?=
 =?utf-8?B?b2t6Z0RIN2VydVc2bmhaQXdpY29EUFl0Z3g0VXoreXBBdnNXTmRIckF1WWhk?=
 =?utf-8?B?QnBDYVlQZkJBNGhWalVwUHpiWUJIcEpMZGhPRFg3YVJyVFhqWXQwaUdMekZP?=
 =?utf-8?B?dUFiNy8wQm1HL1pYTmhqSEtkZk40L21ScW4wQUswaXJNTWxxVlJ5aWdpUVUw?=
 =?utf-8?B?QmpsWjk2ZzlmaTZUMmtkbXhSMnIwSU9ucUMyU2JpY1ZKYVl0NlJETUV1MUpy?=
 =?utf-8?B?VitOclkzSUZINmhvTFhicjFvaU9DOVE3VlU2M3Zlb0xoRzc0d2NSeTloNjJ3?=
 =?utf-8?B?SG4ySFg0bjcxNGlVUFVQNjVaRmNvWkxVWWhRQU1ydm1OeTV0RDNZdG9sd3RS?=
 =?utf-8?B?Z0Vpd3ZieTE4ODdpSzdEWTBOYkM4Wkw2cURrSExpcVRsbkVKc3J1eW8wRGZF?=
 =?utf-8?B?Q1kxU1RHS2tJdjgwTFBNVExHTFUycjg0N0kvVmd1R04wQjlwQ1llUE9vSjhw?=
 =?utf-8?B?VEhnOVJzYzZFMzVMeitnejVBSFRsVnBWWmt1alFweHg5NzhPWEtyWFBWQlFP?=
 =?utf-8?B?bUlPYWdFcTNmYzNucVNUMmRrU29Udm1TcFQwaEcwVlV3bXZESDk1V2RvQUlG?=
 =?utf-8?B?VWdSWnZyOWFMcWZEQjhHZTRES2V3V200WjBUbDNjZnB5N2VsM1VFOGFWNDVy?=
 =?utf-8?B?MTM1ek90K3VGVTVCSVpUUjZ4WHl5NzhoYWtUMTNQUWZMTzBYN3BxVDdWT3Jk?=
 =?utf-8?B?YWFDYjJMMnJwck5WK1Y2djh1WjQvUG9vNmpQQXhSVnJGTWw1Y3ZoWGxXUFJZ?=
 =?utf-8?B?R2praFRFUmJBTVJBSzl4UFkwYzV0RjE4Zmcra2Z0aXNPWDhDUnB6UmUrNjNw?=
 =?utf-8?B?SmYxd2ptakllNTZPVStjVjJocndGTndaTllRNGFrOThHWVI3U1J5VWFGbDU3?=
 =?utf-8?B?QlphcU4xc0ZBRGkrUkJCWDdZYWY2NEpBbFJzTEZGSFJYenZzL2dFZ3hlaitr?=
 =?utf-8?B?b0Q5SjNna3c4VTFEZFVuYTdDNDYwRjV0M0F1U29ERm5HeGdQU0IzMVVaMHYv?=
 =?utf-8?B?TVpuSlZFN3BtWDBmd29PbnFDcktUVzVtSkR6Yk1yL3l0bG9VbG5xZUNsZDVO?=
 =?utf-8?Q?f6u995HNfzRTjORaKWc0HQmKtwJR1vLy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4116.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UllwZzYwQ0ZNSnh6eldPcm9QRlc0bzFaRlRKc21PVzU5YjVIYkhYZ01HaU5H?=
 =?utf-8?B?d0wvbjh5TkpLUUkxdUM0U3cxWTI2K3hpYjFHSG10NFZ1eEU3RGxReFdzL0Iw?=
 =?utf-8?B?QTRsd3dkRG9lblYzMEY3bFo4SHE4emo0VkJmamJET25nNTdGbS9mc1hrSzhr?=
 =?utf-8?B?SHRDRi93elI0NGpLMnh4T255WUFzUDZXNjY0MHFnZjIwbVRHaUFLRERMZ3FB?=
 =?utf-8?B?VU9tQk53K3o2azdnRHErdWc3WitSYkNLMkdCekFsdmJibTNURHRQejVNZTNw?=
 =?utf-8?B?TmFxaGNNZlJzbUZiZGxuYkJnQWk3T3ZneUFicjRibll2N2RtMkZhZGVuaFhZ?=
 =?utf-8?B?TG5GcHJFRmx4ZEkzczRZRlBmRUcyeXF1M0xrZ2cycGJDSmI0U1JuUkJIUmhX?=
 =?utf-8?B?V2ZzaElTa3BWaktDajU5OWVZeXhselNSdkY1U1ZyWjIzQmJVOTVBMkUxZmVP?=
 =?utf-8?B?N1EyL1hpN2pqUWl2Y09pRytCd0pIRWtVYWkxc2RsUHJIVlB5WkRmM1JJcnp4?=
 =?utf-8?B?K3pvUjR3SGNOanZ6T1FraWVaUlZ0UUhSQ1FrYUpBSjdHMXI1Ky9BNFZDRnBX?=
 =?utf-8?B?dkF0STRsM3hxOGtsUWVUa2hXS004TWU3VDlxUFpTQWg0b2pMVVE1MFFyZjdC?=
 =?utf-8?B?d0ZERkptWTc2dlJSM1JjeDBqbGhwWVpSeFBiS09pT0Zwd0cybUVwaG1EOEUx?=
 =?utf-8?B?eVJ2NjJ0MEdyNHhqMlZVNUpSMmxObjI5T2ZWWWdpSmdNTkFCTExQbElsTWFj?=
 =?utf-8?B?MEpEYk5xdGpmM08xelJTcjBiWkgwQzU0UEJyN2JPY1RsWDZnVXFMNHlIb3dG?=
 =?utf-8?B?bTZSS3dUcHFRWFExQkJQd3h1dTAzWXBNM3Z1L3d5eDMzMnlWUHo4bjk0dVZL?=
 =?utf-8?B?TUdyS1hHcWtoZWZlaE44S3ExOVQ1UGl4UXAyaWtENkVhaTRvWHJBcGhiVW45?=
 =?utf-8?B?ZzJVemJvdTg2M0NveEY2K1BoV2E4aWdIMFI1a3gxRExnRnRTVXdiWUFWR3d4?=
 =?utf-8?B?OU1rbm4vbDh4ZVhEZ1duNXhTMkNXaTZvaS9ReDdnK2x1NDQ5eWFqVzY4N095?=
 =?utf-8?B?L2gyRmc5Y2xONEsyTjg5dHI3dzB0THg4YjkxZjA5U1YwMXBTcHRUZW81ZVQy?=
 =?utf-8?B?WEpyMHozQ1dLSTRjcHJ2ejQ1T0YrSUJWaVF5UnUzVTVLNW5TSSt2VjROV1dW?=
 =?utf-8?B?RFRZNDlLS3drODh4RTFEYnE5eDY5cGZ6R3p6dWVFRUJQRWhhRFQwa2RnTGZP?=
 =?utf-8?B?ZEN1ZVpVZ0IvWmZZbnIvV01XdnFzUDQ2N3JZeVJ0VkhUekpwOXdxTHl6SCth?=
 =?utf-8?B?dllVMGZySUxpQTVGbHg5QS9iM0xrMUtycld6NnVoQ3FwWWVzcVo3OXlFbTYz?=
 =?utf-8?B?TTVzU2g2MmVEaWV1SnB3VUUwWUdHeVpCelF1RTB1YlBBNk9aekVOWFRxOUdj?=
 =?utf-8?B?OCtVYmZmazdyUFZYTzdzcFl1MkFjRGY2TlE2Mm5TZjQ0ckdVeU9XVjhZc0ZJ?=
 =?utf-8?B?eVlXdHBKYmxJL3NMb0Vjdk9vNXNmQ0NjWlkwTnA1b0dueGdSQmRMQjQvK2M3?=
 =?utf-8?B?UWZsVGFnMkJhbUxRWEdFU1ROTDYraE92OW9sdVM4eSt6bFl2ZDAwTEduUnJZ?=
 =?utf-8?B?RHE3amR2ZlRZZkVrVUFYYVF2aHh6cnFRYmltaDU0aUdPWUY0VFYzZ3NsbHMw?=
 =?utf-8?B?UzFrR0k4eDNoV0VLTXRiL2kvc1RqVnN4bEs2RUpxbHJ6RmlkbU9ZdDc3eTVy?=
 =?utf-8?B?STB6YmVicC94NDdFNUxNOGd3U2t0bTVydVlDajNiWDNVdnpiM2VPcXVnNXlP?=
 =?utf-8?B?QXA5ZkNGVllSbzhQaFN1a3JnbmkxM3hkWlNobFpyOVNjUnRKY3NVU3BJa3E1?=
 =?utf-8?B?cDg3TkRiT2JIK3VDTC9udzFhUEZNcEJLTnduMFNyc1pjT2MxbWluRys2VVZz?=
 =?utf-8?B?M2FpY2dodDJzcDlFYnc4dUlJaUtKaEo4MTFmMVprNW5oV1R6ZUNyUDRnOVFv?=
 =?utf-8?B?T0piL3ZGVjNOd3o0SUJsSGNiRnJDVkp5VExyNjZpWlYreFhSdEpTM1JwMkg0?=
 =?utf-8?B?dG5yZ05BazBKUUZFL2g2WjRWMGxObWo0M1pwR0VqVkMvS0dPRWozY05HS0RP?=
 =?utf-8?Q?iGpy230Id+VkkPhGjwy3o7Rma?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667744ba-e855-4638-fe93-08de1001da4b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4116.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 17:55:28.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85I8oVteaFpd26JHJwBjWoIK3ISxK4uwrCcmgqT7UdzS1Yx6q5SztlH4EzO+QkXRwsMWeRMmanPw33/d548g0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922
X-Stat-Signature: aup833r8wwu3u15hnqr41m1k4q34771e
X-Rspamd-Queue-Id: A1C391C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760982931-30502
X-HE-Meta: U2FsdGVkX19389h/YohHM7GqtIDB6cZC1JJPgYoc/+jzIlZJ+U3j3TlalDVGhs7QqBihZ9UY1WEGdF//4cSbrG2guDaLfVMrpvSTwuNHdfmxScIpG/HqXTMjMc8ZQKd4sNw7H/P1ssSxxQ8awjQrpIFOXh9ByJXU+LuORA2Kxn/OitpU7hdKiJMnHXGSIklnbHcPdHNz2aESEw0qODvnlWtuyCW6RJCRnY7wC5s+fiqxe5sxk+OxEhg8UNYkNI1vqyMuMIW+gCrDfasTfiGR3xeNd65yaC+/3z4M0whLiLNzp+zA0iGsATbh7yh+uaZF4Ffaa/qxppD2IeL/i9atXhWub1rmYktUpwhWK3Q0Cie+hjZpetdtah6UDdkl5UOvEeutsP6Y50dWBS2dtV1VLHHkI2LKxzMJjMN0EWZZCJAt5HvAiEAgdJKxVsOJtCXakT4uQHHcwbfEuxqO7K8V5KmVlRH3IMVknItlnJuoZEye1+ukJvJsF1tUOkpD3lm870NAGnQ87kiLOyblspkQI+z/x8tLuuMY4Kr7OaVGscEMJoWuFXtyxti3WfdDBWH8FU2BIlcNqbXxMj0zRhFbWagtlmAJQxdolajnjpdd13Zdp/6I+0BisuibI/ZaaB39m1SRhRWShD0ATCi4gv4so35Ka7WIXtEtLG/7atY7xF3ZKGCrmPqTNDL5pfo5GnsX2bDG0QTwz468KA7t23A4vj2n4QtfcPZ1oR351iwe4ZwkqNjNmYzRZ1u8g3MX+XdbQ0pm7vHb8eqRjueJO2wTvBCZQnp8RBZfMccps2kJXMBs2yBQS0LvfGHLin+MaHzJYib8xE5yRRjMSYNtaTZ97bZA+noemVjsVHIurhXdvLk6FG4YtF9FTTs596xQYPwVKr9fxmvHftbArnsn+AAG4/FCgPXnn6Tep7AhGwsfSOL8sI1XKIJosna0YtWVv10cQGAbJtwMHsd8LqoYLtR
 S0/66Yzp
 vClZyP2NVNz+Ga3zNWambHllDhbgI44a0spjKDdB2+c7nSAz1e54OYx/B/BC0AlIfbC9ib5tNWk2fBOnp6PNvTtdLTM6Wu3osmCB4TW22/LOc1q7jR+u517aK7NKHeJpE9b13GLIPiJbtl1uf0ykMvsGlVPpipXvgCox3LkAR0Wrs4WKV36oeGnXH0Z5vraeezhu+XJT6URqQHREuarEs6iUVlGtPPokQDACZhGF5ZpirK02F+tXNFjAtf6Hsto8Llj5LSxrHVWMMvaheoSLWpfn4OAZMTS/7vqqdSoSMP1b48mX7vc7Nnub3GdybqbiL/8lp9YHBxrrFrQXNWYuEGirQDu+djXZ3zbyGJMKjDDoA+OtRTKJ0K4Dk1sYu/WwRds2bjjwr9V9BjUpefboMWQjiDIm+TJS6FIMnOstxWfIY3AY66T4usqN0Vzfg5cRI4TSRsmoot0/K0XE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/20/25 8:58 AM, Jan Kara wrote:
> On Mon 20-10-25 15:59:07, Matthew Wilcox wrote:
>> On Mon, Oct 20, 2025 at 03:59:33PM +0200, Jan Kara wrote:
>>> The idea was to bounce buffer the page we are writing back in case we spot
>>> a long-term pin we cannot just wait for - hence bouncing should be rare.
>>> But in this more general setting it is challenging to not bounce buffer for
>>> every IO (in which case you'd be basically at performance of RWF_DONTCACHE
>>> IO or perhaps worse so why bother?). Essentially if you hand out the real
>>> page underlying the buffer for the IO, all other attemps to do IO to that
>>> page have to block - bouncing is no longer an option because even with
>>> bouncing the second IO we could still corrupt data of the first IO once we
>>> copy to the final buffer. And if we'd block waiting for the first IO to
>>> complete, userspace could construct deadlock cycles - like racing IO to
>>> pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
>>> of this...
>>
>> There isn't one.  We might have DMA-mapped this page earlier, and so a
>> device could write to it at any time.  Even if we remove PTE write
>> permissions ...
> 
> True but writes through DMA to the page are guarded by holding a page pin
> these days so we could in theory block getting another page pin or mapping

Do you mean, "setting up to do DMA is guarded by holding a FOLL_LONGTERM
page pin"? Or something else (that's new to me)?


thanks,
John Hubbard

> the page writeably until the pin is released... if we can figure out a
> convincing story for dealing with long-term pins from RDMA and dealing with
> possible deadlocks created by this.
> 
> 								Honza


