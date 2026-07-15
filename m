Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5E0C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF176B00A3; Wed, 15 Jul 2026 09:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6136B00A4; Wed, 15 Jul 2026 09:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE04A6B00A5; Wed, 15 Jul 2026 09:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3BDC6B00A3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:25:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35D4E1A0180
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:25:14 +0000 (UTC)
X-FDA: 84991082148.10.4B13EBE
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9FE714000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:25:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=Sd42QBdM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of "prvs=16560df97d=yun.zhou@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=16560df97d=yun.zhou@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNg0G7WpxjX18Ed8gO9R04LQrY8c68SY4mFF8/GXXUk=;
	b=Cc3BjLGA5fyhk9t35hJdKUBdMnSbVRlLYaNlUx/0ogYXCk/hN/W4NF6bKJeAmKnyj7vKMD
	U66jSs4nA6igPtx7TVsUombDteg7PnHIgDzIqnmmo25Jcz9DMDGv/PHSKwcopO00VRKq2N
	sPB2ZmzVstN7SObjJKIXralUoDkJ2j4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=Sd42QBdM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of "prvs=16560df97d=yun.zhou@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=16560df97d=yun.zhou@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784121911;
	b=bUra/2w1mXJHaSUCVmaee2VHZnfqKVceSTNK3AvyrZ3aAyXMUkwPm5Lb2KLEfykwyJde/B
	IN4YdASKk278cuBlUj2T68xFjA67Z+mP212duvrHJEmJ0cVcdEwKQM5CaV0TTBxsQHqlGO
	hI7aRbAqRMYNC6GbY9Ew0N1/Z93/hwU=
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FBdGr1370482;
	Wed, 15 Jul 2026 13:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=PPS06212021;
	 bh=fNg0G7WpxjX18Ed8gO9R04LQrY8c68SY4mFF8/GXXUk=; b=Sd42QBdMMgyw
	SWBIj9DAZfKTB7KQyjozMdZZyQ5qQmhFKzQCKwoZwzW65sXKxdiOn2n1wnk4PtYa
	7m3Odr4t86+OlIUe/2cFXrsSWOnOR44qeP7wRMTGnyUPePu93uI7pwyGzSYujh7E
	Hx+x+zXvEByRkxX0TLkQ+vOGT7gCQufopO7gzZDpZNIuFSj6nbXFjx/wS26tjrXS
	uxv6slrFlJIDjuiSYds93x1YzRGaR9stU+hEFbwiB9v615o1o+t2gZ/87haJcaEo
	b07rwDt+5K7J9dNjDQCGYlVcexvaxKs248TnGwWtnFg+xZpWszWhhwv0GwvhV2Rf
	w2hn1KkOlg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbcpn6560-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 13:24:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8iTaJYMMwWdKpnE0+RkkCZbf0aBNBJrLMTBC+V9L+Tt4UmF7as0K75YUjkVoOrHYIpTVyTCB0Ev9K/g18qbbP+b5sodchXNEsdzb3QKUxXIpJzI22G/50kByBIGq0sUiNYbRczyafRHDrISBX6dU25PrpSP2S1MOvbfDMrSBTgiD+ojgsOWen+3sRAxUYVLKhHRPZCcWaRDwjHe2tp4KQK4ExEDZmu3+UzSvF0do5MVbO5niZEt7AkpOVYWNDSYf49qa3EkoWj3U947po8t3VrT8Ykg0XvfSOt7X6jAbObZA0oZy0o5DfJoOIC/W7SOebxXqJhsotnWaZP6LbveIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNg0G7WpxjX18Ed8gO9R04LQrY8c68SY4mFF8/GXXUk=;
 b=fYlczW1msTJ67tAg8X9OxiKEN6H78j/y9xUDFB1NKfFsG/DZHBoL6bL+W7iLwkzWl+gmrPk4M4RJTIhNPVwawlQctmrNtz4mRtyozAED2Jsr1qLSndksxlvlroWclPIND8Iu5naDpKyzutniiowZCXiNGVLnBd2sjJB9LuhqUuNYJ13HKz8rC6Ra4vVn5o9yBdR9anKAK3+T9PhLfsc3hD0gQ7JmxqO2u3O6ZfRQ/EXmfCikCRIcpmgYdnTgKTCEWcPxnskv415smoeV1xip9YZE9xP7Zg8s/M1moPcU0w3i1bvRyJhlJYALtDU5AIwkJa6h7azqCR9RakCc9Z31tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by LV3PR11MB8579.namprd11.prod.outlook.com (2603:10b6:408:1b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 13:24:39 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 13:24:39 +0000
Message-ID: <2bd30a23-3394-4d8f-b96f-8a56aaa3bb1b@windriver.com>
Date: Wed, 15 Jul 2026 21:24:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in
 filemap_free_folio
To: Longxing Li <coregee2000@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, syzkaller@googlegroups.com,
        willy@infradead.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
References: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
 <CAHPqNmzacLWxDM4CSyEorgyh1tEyBfeOVr2gwUvUrtjZRCuh7A@mail.gmail.com>
 <20260630131011.67546c6e472150e22c3e7c7c@linux-foundation.org>
 <CAHPqNmwSgLNVPycS5DCBJe0fiBhOzccBR6_A7wKUQCKQ4QeQyg@mail.gmail.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <CAHPqNmwSgLNVPycS5DCBJe0fiBhOzccBR6_A7wKUQCKQ4QeQyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|LV3PR11MB8579:EE_
X-MS-Office365-Filtering-Correlation-Id: f3bbb1c6-af88-4229-9aec-08dee2746bb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|4143699003|18002099003|56012099006|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	pQeLlQEqgPUezxCP01/vbGwMuOUS5MXbsODgbPFMDz0d7s8CGJQ802P6U9+tA/2vJp4xNr0JZmd5Y2WU5QoQWlfcN/wNZV43LW9ilbghyNsMLdOdVJtN3qeGFPRzTwIBFGK8Srq0gD3tDE66mSFs1cJZFsdu/xKFHioL/1vvzrRm6BOew+AX2uSuu4atJQpyWjhut7UijFyae2t+DUTrF1pApKw4meZx7dChk6epgViGtNj3KujsqXdlaLwIse+hh4Yg+c3/+N3FCQtm4V/hB4uewDTMh/kot/egZK+QGtiAN3u53f6MaVd4PAhfrVv8isIG8lh5vvGGJcLepd183wIanDBgUM4ZZCCCiuBO5bzGgyZ2we1zKf+3LaNvjMdyTEk8aWYc0UrShGnAPCQGu00/BnwGGQ/D8OUnmtDZibBykPNcVD3TRQxexBFXF6RxelB4/YfixmSG/y2Y3t1krO0JF3Vhm1bbBme8wKcNiK8Oq2RPpiNWQp99X+4r1lnQaWbKhgMH+RB9rXCIt9uQdLDcPaskTVLEwpm4O5ut78b+t/mX6GXDH+VZkROtbVXxG1SSW5MrxiyZL6vVKOcQXh6EHEhwOrLKFhnNdG3ePDx4UxE2GiWg8Tv1ZD7VXgWAo5WdQTjEevCk2WT5ZVzf8gIoEns/t3ujn0niG/S4Uq0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(18002099003)(56012099006)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0JyVmZiYTJlSnNqcmNOdTBudEdlRGJUSnd5NGRpWVlOZVp3cStmQTkxQ1Rs?=
 =?utf-8?B?R3JFbzFsOGp3a2xQOStWU1NjSjU0NGRUaWNYeTZoTW5nL1BjUEFYRk5KSTdu?=
 =?utf-8?B?V3IwNUx3ZXpWaUgzSkcxc0xiSC9EREhJOFQycTYrcEQyM0M0RWpqQlM0M1dR?=
 =?utf-8?B?cXBOWWlQaWxPY2ZrL0dRMHFTaGNSK1V5ZXNrZkIvWG9YUHJPK3J6YkpqcWZ5?=
 =?utf-8?B?Z3k5ZHVBbk4xdVJwOHlza21OaUpvV1hZNDI5TFgxWUUwQ2VSeWZoVDlwVFhI?=
 =?utf-8?B?eEF5VXEvRUFlOWhXZGRlS0xjc2FuLzduZlNhNDZmSm9LeW9zM0xnalovSVZL?=
 =?utf-8?B?SllxUGxxMEFONStNTHAzbm1OQ2RYa2N3RncwcHQzeFdzbnlVTXZyL09aNGdX?=
 =?utf-8?B?MEJ5end2YTZCWUw3cW9xazhmNUdobzNxT2F2SzdHSWg0am1kNlFWczA0TE8x?=
 =?utf-8?B?YzRmaTB0YVh0bWtwdmRlaGpkSXNHSHNzUXBWSVRDVTVVRkJVL0djRFNsaGhT?=
 =?utf-8?B?VWtDMWtHQVlCWElFZXowbG1KQmE3cndMQ0tKRVBYN2EwWGhVbnhtOCtEZElw?=
 =?utf-8?B?eHpkeDVTOTdHTGt5S0JKUVBLVnV6UVBEMDFVelRaS045cFBzMTFuYWo3Rkxv?=
 =?utf-8?B?YWhPclp4aTJiZUpXU092ZEJHaG1qZ2hXbjYwS0xKNTVaYWRZbXV0YjNZM3pD?=
 =?utf-8?B?V3RUd3JHTWd6bjFMVE9HKzFRbmEyQ1JzMlRoajA2SVdrZDJRY0FWYnB4MUM5?=
 =?utf-8?B?VFB4cUQ3d0t2bWVZMmlLa01PYlZwSlpZWk5ZMG0raW0wMEZZY0JCR2hqb3dW?=
 =?utf-8?B?NjFzSzlUanR0bGE1VzBoNGo5SFBJcGdrTk54d2Q1dWoxdXdZSUY0ZTZaRjY0?=
 =?utf-8?B?OXRYZ1liSTdDY0NSZ250TWxuZGFkMkIrSFhHSWhHTjB2Ky9QUWpqanAwaWNZ?=
 =?utf-8?B?QlNRVGVZWFVmWUxlZHF4S2pKc2NJNkE0UG1NYVlwam9xaXVTV2NaMytVNWtB?=
 =?utf-8?B?ZWtpR1kyRjdidEt5UktDa2hRcHJtUmN3UHFxMGNXOVNJQkhOZmlYT0t5TWQ5?=
 =?utf-8?B?V3lYSnVGWmp5T2piY0djdzZMRVJQQ0ljVFhWOUxwRThvWW9OVmwyZkw0Unkv?=
 =?utf-8?B?QUdNVmRLM1NBRTVkUko3dlNPampwaytPU2dkR1RqNzRVR3lCUVNhUWNRbDZJ?=
 =?utf-8?B?OGl5UGQzZzdYZFNseHZNaUpTMVhDemYvcUhZSEhYZnJXSXd5VWpEZ2ZQQXhu?=
 =?utf-8?B?YWRWT1daUENFMUtnSlg1TnhqcmFqZHVUOUFOa0R6a0F0NU1jVkJuT2NRa2oz?=
 =?utf-8?B?NnJFZGF5OWU0TUhwc2VZaUpzSWtuL3RkWk1ISDhiVHNxLzFwd0VKVmZ1YjVC?=
 =?utf-8?B?eVJVL2lUTE03YmRoN2Uxd2Q1TGdoOGJQWWZJOFRyT0h3Q3h4OVlKdGxSQ21i?=
 =?utf-8?B?blBGNDJocVorU2h2NTJheE9MaCttWGZlS2RYeXplVjJaWUNTN3FYUVNsTFd0?=
 =?utf-8?B?OTBGbUswZjlXMzdlcWNVV0Znd3J3VHdiOU1vZk55Umd5emZLTStRTC9aRzFZ?=
 =?utf-8?B?S09OMDQ4bS85RlR3N0wrUy9Pb2g4R3FQbXRJaGplM0FNMXQzaEQzUGhNR29j?=
 =?utf-8?B?WTlPRFlwQU1sV3p0cEk0bStoSTl1WDJ1YTgvYUVacEZmckprSFJ6YmxmZVV5?=
 =?utf-8?B?TllxNnpqK0dHWDNVbE9JcGl3V0dVWldKcHlENStKbWdVRzFveFcrVXpIaWFz?=
 =?utf-8?B?M096Q0xUei9Qd3AxTXdITGtZVlcvOGxicVBDV1RnMnY3Z1JTbWpnb21URldl?=
 =?utf-8?B?Mzl5WUNXM29KSStkdDNYV3c2bVRtcFV0bi90VUtOU2JrcFhHZ0hJOHVjL2Z3?=
 =?utf-8?B?M090bGdRajVXLzY1bDhpVVNxNWFGZzRyWXFya3lMQ2RvTnh0YjZLUVhQM05q?=
 =?utf-8?B?UDVHQ0phdVBTeGVub3plakpuTXBTT3BQY2ZvZVFHK1FvOHQ1Q0x2TTY1ZkUz?=
 =?utf-8?B?eHBvYlZhZS9LTFdTYXIrUjJXNlZQQ3dnamJGODhDeDNQUUgrTlFxaGo4NkVu?=
 =?utf-8?B?NlNhcEh1ZkJUQjlzaSs1TTFKOE52SU9iaExOY0xFVXZoLzQyc0VkcTV1MEdG?=
 =?utf-8?B?UlBnWENFWjBKaDBNVlNUSjVmc2FyVmJFQWM4ZVdmMngyd3kwazdONVJPZzdw?=
 =?utf-8?B?SGRTVVJTNUdBajJYWElCdVdhcDJYZVdLd0NpSDRWMWFvaWZ6NW5NLzFJRTlz?=
 =?utf-8?B?TWxleTNyNjJ6UWtOcHlnUGFGTndZd0hMK0xLT0YzZXAzR1gwVjBhZUNTaTRr?=
 =?utf-8?B?N3hTZjFWR0VFV1l3VldiRWZmK0JBVStOZmtXSlhRR0dITlRkVDlCQT09?=
X-Exchange-RoutingPolicyChecked:
	aaNvPcEi8euOaN4zkavB0N63REGjr2C9j8oJMMqFNXO00ct5VScjF2tb4aQH3txWvtFc2G6Ker2dK4qFp9McIRxfGxXH2Pks35ASJ/s63ogzeb9hXjQ6jdggZESe+q1qd9JnEvunis35M7v7rLBWWwkkhYCIjZ1jBP2WeDx7x+JE12ZhLg2lUXPRZVuRnIjKZnp30DR28x90TjvhWdm3E1vbfMKlOjBnoGKx8oh9dDiiYBVVKIu6pS+L36xDtTMsu4XNPpnEfgQystgz7bRPPsrqSERbKEg6xeqrsQEgWJy+vsHi/R8zgIiIA6OCxHKQN48FSRvAZmbsIuemEVAsYA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bbb1c6-af88-4229-9aec-08dee2746bb3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 13:24:38.5688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVE1aX4GeN+UuqXVezS2ybr6Wq17U4Non35GX1gy9z52bhY9E6/WNDmaOzLJAIhbkJwBs+tD5KTX0RBA/4lQxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8579
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDEzMyBTYWx0ZWRfX29vQn3JT0t/I
 TTgufLJ+5OOcOh0kVQMbr16Th3SnnX1I4H1VkLj+yMppsn8RQXpRkEhhzKIbMyPh8Lw3d09fmTi
 E2WtmanTrSNXx0Bk1zCmOCN9VkSXEbdCNh/9VajNNufHGf8ifGCr/FgJrc24hNZZVxY+VIRyayr
 IS6mDZLMfWPWUoPxg3LIBylUiuUcTfkytmbuxcL/327/H2UP1FNfVVkcJyHqda5bBnCgQOq+RHp
 z5HIbJhRItE6yvzjnTasqypJ9qFjq6mK1e43Kh3qMu/i14T5aXb8wpfSGEOzG6G8f20Cxg8Z9RF
 ms42zL3hH+zgyR0NnbNdODlP4ca+XC1Z2Ei3eIdqOT95YfdsuBcdMxeSHtVgKPdUp6XWYwZGO+T
 CqTKqLB0UMd7ZedSogWNkjff1GOa6AkpkRitIrlBe8kXnhDH02KfLjzV51CCT4nwuLXJd8axt9m
 O6jz1gDs/50Ih3+hZcg==
X-Proofpoint-GUID: QMgsRnS_ANefh7x4ndcobWsDH9tvzMf5
X-Proofpoint-ORIG-GUID: QMgsRnS_ANefh7x4ndcobWsDH9tvzMf5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDEzMyBTYWx0ZWRfX/PiTiNWjlHcQ
 1YQbJbvUMAo8yEYsjHh+oW11IE74PYvFDSh5UBpy+3DLNWlK+a7gcNqWCQPJ+aDc8cWlleTp1U2
 Pl2s5usg6LWPkpPz0fb2fNIqejiiDjxiAfmm5LN/8QGKHrDX4uhW
X-Authority-Analysis: v=2.4 cv=JNsLdcKb c=1 sm=1 tr=0 ts=6a578a1d cx=c_pps
 a=v5NpUkBk8u87wj8Ets5Xkg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=RPJ6JBhKAAAA:8 a=SRrdq9N9AAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=UyuPvqRQIbQeeBKet1YA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=fa_un-3J20JGBB2Tu-mn:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1011 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607150133
X-Stat-Signature: mfjxrsgoy6qr6mpn89g3j4amdmngu6y6
X-Rspamd-Queue-Id: 9FE714000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784121907-257139
X-HE-Meta: U2FsdGVkX1+oJ4x7qBLd2ZbrV79Mw27vSb249N5KKyLwVfV7RXIiKEbuUXiOTmv1SmsLTbxHKszJrR4x+ghJ6wzQkEiaeEt9ilx+3Tz7Wv9/+hxCy2dE7k1Ka/l/mD/YeA8l7XXi76oY3G38tENj5W0PRiYYbAixu52OwaGh9J06s2RZxqFCEdI3uI9OAU7gp+6gTnxHaT/Oec2cUv+7uO7sSjqanya2W2TnJ+SZazp3c+t4c2LFkQfoW36stm4Ku8ooEmZsgNOexP/8jWpPFsAy2y+mAGH4WWYRxYcfvwfbHwkY9JeVKmLoPfcY0WrBh2evTPS7zNkwoswzOQ8+d+SCxwutfDIG7HSdQn8yUwcfpM9DnbhojsPlnRfaTOLX+GS9NXUgj2yiAM2kxdwhPZRVhINNXS3BQHCUZk7d+3Yp726PXUulJRIU2h8v8MrbguIG9oEuZe+VI5g2YaAJnb3ibcj6vdwIgIOuFR8HuJH873Tp5QiI1e6cVC24AUGGCCzR27mJCT5gBk9rcmYiJmooIUMkRfDYYDn3ag6ILIpmwc/lZO4USkEZeO3zv+Y8F+h4gkmrU+ThjMrZMncseQxSQD3LKi5JDy0mln7sio+pdGqhwODp6Wayz0CGz7+Xlp4ASMg+mGuSItMfIKYzK2SFlzHujjf8n8JEpZThbrTdCPOYSdv8ptBbgSBBwyJoxFYm/IrMGlmuGwHsuecdxztZwN3QzvHJGnMnLBa7lhv8grygRFw3E+6zK2AcQDRmq3Gna0W29qn4HuMUeSB1TWSeGdwIulutsHSJWw6NkqB7eJ0okVIENDLulCg80UDx+rpFFnIUtrXgvavEOFISg0lnASZ0DrG0Bd2vhki2pkbr7Mw46RW7HGTIfvLn89owJFo2Orgq4nSn+7dyywNrOd1DgAEJV5Am7Yz74jAqdvomG52EgKHnvNuJ9PnOWJiQ19sZvT9/2NC7AqrBl73
 5qhnSztE
 rWtd59vTVmXo8ZoeHyYPbbptfpimHHAwu+mQok1GCw6q2Ma+Xoz79lS7f2Sarghs7O+vaxDZec3K6/JxcSjKC0ZUNKEUu+6O2Kz0/A4P9QzWLp1JPl2gZ+aRz847akOo306OAXVno1atm58y6XO1jqdjpoK882qVBeurhsI4SDxrRNTnbtVgu/vCb4U20OShwks/ludq2JzKuUf9j93gR0Tg5LRt9xFn3p8eUcD6RJ0mrsfgCM7mH1gBMAg34CRfm9zqNYT+f6QgGJCoqcmP2GU0n7FnaUZI9eRWtuInehjiyPsStHEJzZ07h3yXgrmM5SWVbyk7Xn/KfaQI2kRNWcnKY3JpKY58XT/XFva+7bpAUFgaJR6TWxJAm5bdtE4OlnaGSzUCesYms45eHrNK446DCiIUuWJoP0/PyQOP1zl74kHH3fqX336p0dpGH1RGjhUZObn6xmTgvpzCueDu6a/NXCVKRuLQEcd67fS8DlDgwCJHitRb9v7o+k7QD8CfwNVJ6qCFq3rGN5roHEQkLL9SHWQd5+iL/b0ZcYI4GZR/URX/9knD4Iy+5mxUo+JnIsZGFv9FrqAcqRW5UW9FpYOiTlFWXbq3f41q4AnGIQj95j8/AbVu7zkuJFj7qpG79FEoTPMORb/rt4OB2acROBdARSoR0pJC0Cnpe8Kd9TFwakj3g9aVKpQn8uNISfjvp82HZhdnxduQ8l2lduSzFEfRF7JtJ4RkindI6aKSMGkIYk7WDwQlNMLGXbnYzQQF61OIfOujgc9sp9o3naWVBdfTkSxjDFtEB9w4432BtTt3lPQM6m9Ae4anUTm+Ti2F25PMNZG7jcynXvoIfkD7FQ/oviw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 7/2/2026 3:59 PM, Longxing Li wrote:
> 
> Dear maintainers,
> 
> I'm trying to fix this issue. The bug analysis and patch fix are as follows.
> ========================================================
> Bug Summary
> 
> ext4_add_complete_io() queues i_rsv_conversion_work without holding an
> extra inode reference. If the inode is unlinked & evicted before the
> delayed work runs, ext4_do_flush_completed_IO() accesses a freed inode —
> use-after-free.
> 
> ========================================================
> Fix
> 
> Take igrab(inode) when first queueing the work (detected via
> list_empty check), and iput() after processing in
> ext4_do_flush_completed_IO(). A per-inode bit (i_rsv_need_iput) tracks
> whether the reference was taken.
> 
> Changes:
>    fs/ext4/ext4.h      - add i_rsv_need_iput bit to struct ext4_inode_info
>    fs/ext4/super.c     - init the bit to 0 in ext4_alloc_inode()
>    fs/ext4/page-io.c   - igrab() before queue_work, iput() after flush
> 
> Full patch is as follows and is attached in the link.
> 
Although I'm also a newbie, I should point out that the way you're 
sending the patch isn't quite right. You can just use the git send-email 
command directly.

For example:

git send-email --to tytso@mit.edu --to adilger.kernel@dilger.ca --to 
libaokun@linux.alibaba.com --to jack@suse.cz --to ojaswin@linux.ibm.com 
--to ritesh.list@gmail.com --to yi.zhang@huawei.com --cc 
linux-ext4@vger.kernel.org --cc linux-kernel@vger.kernel.org bug-fix.patch

If you're unsure which maintainers, reviewers, or mailing lists to send 
a patch to, you can use the ./scripts/get_maintainer.pl script in the 
source directory to find out.

Before sending, it's best to do thorough functional and regression 
testing. You should also run the ./scripts/checkpatch.pl script to check 
for any formatting issues in your patch. It's a good idea to read the 
documentation in the Documentation/process/ directory first.

No rush, take your time. Feel free to ask me if you have any more questions.

Yun

