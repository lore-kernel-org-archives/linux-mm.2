Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F136C5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 17:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADB96B00C9; Sat,  8 Aug 2026 13:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5EA36B00CB; Sat,  8 Aug 2026 13:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26C06B00CC; Sat,  8 Aug 2026 13:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D62C6B00C9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:08:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEEF21C1018
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 17:08:04 +0000 (UTC)
X-FDA: 85078734888.22.86EBBB6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF1E516000B
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 17:08:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ADdbNH2k;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786208882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeQWGE2WNFCPDpIuTg/nUnc3bgLphNLiF4YardBGcsg=;
	b=jRaYLJcu/gcAbB4iidptQIMVZi6P5kjVXEVXL5AxeHlkILeq2bSs4mR0RguFRnSnPQIY1S
	LuhjoffEEbnUNSO3PK8ZNFOW3iJEt/PqKf/uyHygPKmn4bVwIaQemRpkiXhNo2AmfFJIC9
	iDaMIRgoAOtB+Zu3WBauLxtw60xHsvM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ADdbNH2k;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786208882;
	b=EpqblZomYRbrPqQ4IgfLeK63KrEx0XqkycFBp2RorinazRrFNi5v0wph/ALdpAacMSxaM8
	xtv+YbCm6GPyqEpOZPs1gW7oz+FqqcVTUaWBs51PGqHp2hhJ+kn+0PLnCW6rbawXPzD42c
	akx4s0sRjHzaRjJBhaKUUY/lPmcm1tM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nwjVFaWKf+2jYPr/QV5/XSaWKK1I4YGONfKCkco3GI2UjHGw3B55hv82Fh0JLqd/IbUvh1OUpW9TlgtTq5GY2QMeGc0nIxAXZ2IRpPYcRXhYvuhz6v8Xk1ukW2J/jHhtmPRZAty8G+sICAVL/qeN097oKGTeBEd9apwR1WtOPL9K6AKPDxXlePGqVwTsCsAmmBZBPFh/PEXjIq+Q3osKc0PPNkeyFLyvFJ0nhmMkq2qWqHGY0iQ8lFOP4554XEwfVOgh0ru9sU3QCHvsOkULMyFmw6p4ROHLjhSTUwq+cqYNk/t5Swkyn8FbVLHJQ2SiiDewd3J++wm1r2xtOxycEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeQWGE2WNFCPDpIuTg/nUnc3bgLphNLiF4YardBGcsg=;
 b=ULpAVd1M/AEM31Bmkv51l0nU4fQk0HeuPWmiYGtd8uZQtuq2iCMVa9sPUecvK5GFWfgY1kDGmv7zGrVbTGWKp6+v5TqMzu1CnqY/Yh0h+6tK+f2CQqM4edQWY+pTwQWtGZjjKyEftayH/amN38s8vur5kwuO/epM6aQe5XbZOBlotD//MNf6CtmVmYsdAy9kXzJAoDtzC7MiY2FcJhnQOXOTuoCd3pfN+whsspH8ySPYj5/96Yb/uK/mzKtF6p7WQ45NKMYzL+EgQNnsYgaMVlXD7v0eortPNhlXUFpBbZhrI2MZHP8e9recBOtJToq8sazkEUSBBNNqLuWMWKen6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeQWGE2WNFCPDpIuTg/nUnc3bgLphNLiF4YardBGcsg=;
 b=ADdbNH2kWluELraof+rqG/Y8FY3RNACv37PeLjWdYLTp42Y5RKOdBMBRFFYjppHCUz6NVDWX0iA6hCe/Xgaon+l2u5I+p1+SPKDMT4Fcs3S3pgteTLGglyBdX1M0nuNvCLj9Buz23kR5aTvLvS1Gm2ckeBr6XMnaU9My4qKmza23jgOcS3qPLKTVYq0NqWxI+GNwNocdeM3I8StVl1bGEKKafGFMj7NQaj+wfRjF9OoPxPxvqM0FOfRkhSGxmL26BgAx6pRx3OgTTnyxVmfPk20Hr35YpG6lj7Sd5KQTYHvuFaHmYNhfZtaHxW/nutztTwO+BTueSwK+klotuCyQWQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Sat, 8 Aug
 2026 17:07:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sat, 8 Aug 2026
 17:07:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 13:07:50 -0400
Message-Id: <DKJQ76XCM29M.2LN797LM9EELW@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 01/13] mm/swap: fix off-by-one in swap cache replace
 sanity check
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-1-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-1-689939a7ccc3@tencent.com>
X-ClientProxiedBy: BL1PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 86053e81-dc98-4595-8d0d-08def56f948a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	trv3X8aUUbuUY8bsXIdSqLlp3k4gMPRNSZh//nY7MEE6scXRtiUt/feA/csGdFcf8VN+z5qsk0g5nlC0TZvSfLTh8A3SKjTi5pAAGDhTxksf8cqKkzPJi9aviOzi7mIh85P6aTDBo2aYXrg5GjNX5gRlnVlP5h4nDHM1+pngRTfHYNQi/kynBT+pKsYofSggKpBC0CbvQ4Broq6HcL5lE+fMATmzgfCqjyIIB31k1UUvlTNZ2vSQ4+IeAVts05RxA6Vxb+akCL0sAN1VC3U75I+af4QUz1q0pS4/A5dwlhq3SDH8/POQb/+4KvU3qQP9kGaA/uUn9Mw9vUVupOohoJ4WUoMSdJXAuq1SP4Q6oTf8504sVfO7p3O+wlki1nJdE2v4SfqbUnMYUMlz78u8uiVw/acZFN8Yj4Lm7NgUQPgY14ymfFhWe44r68O0P5RoDk6vxv1NKrBiMph9ye3GGaaTIaWyH3Di5GZtE3ZlPkCNpPOfze7Q6xSEGi/EDS5IPwH59dPnmLZK792v180WP2aYnQGTIVB7YJLQ/HmO7+BtgrbKhhgHK+tCEs4wqp00yg4p1fbNtbEnlKwaV+ieY60P0aEBN1Z0tBlHWwEoLoA0x/e4G9a7STSc7o/gGkJeJUMwqZPNS7PsV1OA0Z1juB5NCcUfTAgBorniIWeQigI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3J5Zk5vMnU4VmJYZ21nSndnSy9Rclhrd2NnOFBybWNENmEwQ2dObEVjdXJZ?=
 =?utf-8?B?emhnVFVwQXpHOUpCQytYY0RiMmxGbnhxTjAyNWVuRG9VQTVvd2tMdzJMZ0Js?=
 =?utf-8?B?MGdoNGh4NVViRFdmTnJkdlFzdGtqeS9VRmkzZXZ2czMrbFFTN05PR053QjJh?=
 =?utf-8?B?Wm9GMEpPbm5pOWQ5MHJaSVpJUHQxL3Y2SjN0cmVaOFA4VndlK2N1bjVsdEtu?=
 =?utf-8?B?M2JpVFZySXVDTmh3cU5iVEUyR0wydGxlQzlVQXBReHJnSkhJUmJEZUEwL3lh?=
 =?utf-8?B?VlhMTXQ5bEJCOUwyUGpFakdCRjgxQ25Xams0MUcyZm4xdStpaDhYdXpOZFBK?=
 =?utf-8?B?Mm9sZllBY0MrVzAydHhDNkpoOWtIT2xTUFVKTmlRUTZaczZRay9RTlIvdnJt?=
 =?utf-8?B?eGJ1RFBDNDZvcnJzTFJIR0NKTzBRQ1NIQVYzbGlkYjM0RmYybjlBWWI3TkpU?=
 =?utf-8?B?aktFSGFvVkN4RDAvejNYVHo0SklsRDg2alBQR2o1ajkvUVpiSUtsVDdqTHBt?=
 =?utf-8?B?c1lRcno2RS8wS2ZKYlc5RUdqanQrOWxvd0FWYURNNzJXOHhtZ3ZvbEc1alVQ?=
 =?utf-8?B?L1k3VHdsS1RiYTkvUENjVXhjNGRMZ1ZyUm9ZUS8wZkkvV21oTnRodVhJa2tH?=
 =?utf-8?B?bWJKamFzOUFNSTFSRlFleU5vN040NGw0aW4rejRhS0IzamJycEhOT3p5Snps?=
 =?utf-8?B?djZTc2Z3aXRUSXg5ZkZTQjRBVVU5UUt1WWlaeGdJNFUxQ2lsYjJkVUVRa0Yy?=
 =?utf-8?B?dnFFalpGejBYdGt4Ylp0SCsxUnc5NU9mK0RtLzE4SEpnUWl0SGF3dHdodjRm?=
 =?utf-8?B?b1RHS2h1c1FqYmNvQWV3cEpCU1dCbVVWZ285Q08walRDN0RoQkxTUDZreHNQ?=
 =?utf-8?B?dUhMWWtmMXZsNmFrWUZYZXRodnErTlZxbUlrVnQ1S2dkWXpVb2VwVElzRmta?=
 =?utf-8?B?Z0duYm1LNjFWYWJCNnYyaTdYZW94QlEyTlJCeU56dzllN2dJTnliSEV6b2w2?=
 =?utf-8?B?OWRYTXdLUGxudHdIYXowem8zMzlEaVlsY1MweDRqM2JrdlhNWHVVNmVIa2pR?=
 =?utf-8?B?S0RNVVNuMHozQVFTUnE5NWhiYXJRN1JQTXJRV3U2V290bjdTemFhMWgwQTJP?=
 =?utf-8?B?TGtMWHAzUGhFOHdOSlVKWFY3WlpNNDJ0SHRIdE1RcG5OYXd0Rk9qekYyRGJS?=
 =?utf-8?B?UXcrZVJ2VDZ0aFFxZG5mOFdJa0QxbGN3RzFCV3p3K0xRYmVJU1U3cjRxK2kv?=
 =?utf-8?B?emY0N01Td3pnYUYwN0NaVjdwZ0VJemJlNyt2WUo0b2o4NHN5ZGk0eXE3cm5t?=
 =?utf-8?B?YmN6M0xqMFpvSE15aFlNQ3ZiQ1h2bVAwTmkwdU8raU1GZjYvZVBRMWhhUmFK?=
 =?utf-8?B?WlU4Ynl3UDRRTWtkZ0d3cmxUMFdrMmw5RmE3RUdaOElHK3NGNjNOM0dHN01M?=
 =?utf-8?B?NC9WdmY1T001Zmxjdlp1bVgrUnlRaklYMVBTcWRmcHh0ajY4WmFBMUpsall3?=
 =?utf-8?B?dmwyWGpJZDhZYmZ5dS9OOE0zNkdIOGduRi9UazFCWVVlK2VrTE5vTW50Q2hP?=
 =?utf-8?B?cUhZVlRzajBSUWtxMFNKUEFQWWVtRWRNZVp4MEt4T0JmMitpdGdnNkwycEo5?=
 =?utf-8?B?Y1dEaWtuMWMzSUhpbnRqRmVWSXpoNHlaaFRsZlpJOFhaTGxFMndOaHNjZ3VM?=
 =?utf-8?B?bHVuOHJrRW5wVCt6NkR6OFdmdGNqMGN3TmJBL3RqVTNnaTZORlE0Zms0VG83?=
 =?utf-8?B?bmdReXkxYXBBek9UZE1WWmV4Lzc5YUtHT3RtSWM0OTRXTkdFbVhhVkVwaHVH?=
 =?utf-8?B?d3lFclI0VStRVWF2U1J2T2ZQYmlOU1RyYlRhU2E3STJPQ2tpNStETUtIZnl2?=
 =?utf-8?B?VjdxRVFuRjBsV3RyeHlGcGdNY3hZMFRYVjZablZqeXhBdFVKZHk0RWFIelpW?=
 =?utf-8?B?WmlnMGRPT01EWnpwTUdENzNZWGxXT2cvaEswV0lVa3dQaHkveHBqTUZ1VTJL?=
 =?utf-8?B?WUp1U2c4V1BzcHkrK01Sb0o2UUc2NWIwdUZCZ1pKYnJUMGNjTVMzWW5Ua0ND?=
 =?utf-8?B?YWkxd04yZXh4bXluakx5a3hneHVkY281U21McUlsbVArbE9VcGcxZHFKendV?=
 =?utf-8?B?VDZJd3FDRGNSWVV0am5yakJLZkZVNFRLT3BmWEVySlU1Y2VOOGx1bDdMQ2JQ?=
 =?utf-8?B?emdDaDIyYlVBMTFWUFk0SEtNTkJESmpEaUZCUmppcnZicE52WHIxMlY5emw5?=
 =?utf-8?B?d3JTUU1PMzlocjVvak82WHVRSGZZcHg0dHBTbVY3VXAwUHByaUZ3UW9TdWoz?=
 =?utf-8?Q?ydKYS8PkgM2BxgwBLc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86053e81-dc98-4595-8d0d-08def56f948a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 17:07:51.7155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHWicmhUi0024oTHdMR5kOr7roc1rLEZLisNU0UXA5Fb51vtx0vUeLXo5fNLmBtJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088
X-Stat-Signature: 189fr4qn1mpx1sri4kti6jzg7sji1uq7
X-Rspamd-Queue-Id: DF1E516000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786208881-747251
X-HE-Meta: U2FsdGVkX1/pQE+H5vgUy6HCLgaw/ko26DF28LMhrI7MJa5Eo/UKd8QOjbrRlnNkjDEzYVgPOHjSFzkiBXng7XvASyhdNJBpa8kQfS0mB6fqiTGGeyCZJRdPNvgAZ7Td8ZhoX0lc4+tVxQerFbbW0ey5qHGbhCeezhs+CxIqEvfgeAAaLw+L9F3wdLIg9wiN1n1EPGbRGkOV+hd0xSfBS8QFQf5ELKuYvHVlG6wXCYe8XXVuFH0SE8q2zwvA1m9ovuTVNiVJapRVel35M5GFe7qmeanGNBEO99/QuNwbcdYd7fSLlaZ9xVMbc5jYpcDk/D+VuBl2m4hO1nvdVzMZmXdSQwIOsifgcsa2vfugUSqqefZ+krUxp/CudUUD40U9/DFgWMTca0mFet+LLn9AgNYzVBoWYogbPDX5rqkA7pUj7TqcIay2inltEBtKnYjbAVkapf0nhIZBmyA1ldTkjCv+0JKTc8wdHgAb+AoAOGDXir5Cd8SH09WCaDpEfmoyc+lTddsWH7RGJt3dqWwFt0uZVKD9gL8M00hi42zWPDnF6YKs80PY6FPenhw9dd/Iakbp28OaxGvLnLGESR5X+M7KmbY500Ot4n/4KFe62MHR2W3mbYWWRbtouQ7ad820IauERxHsHptDqcBLPbdu6l8M11MxaHoBvIVVp8KGCVdJkDnAp6CDfjlLgNy4ghQKWgE9fCTyrM9LEdEw6q04NgKlo4SJORjt8Hu4qsWC4XfyTmGEvSr7+bhzXT0RHtxBENZxznDyky2dEdJ3xLM6AhlW01/KF0iV/cZCy8JZiVFpxA+A648wft+eYKOJ8+70kzE9t9Cobrjh2c3FoLUYlw463xjtpRnv1RLhvPS7GiN4LwXRcyNYwtJZ9Yab0uWRvcnwumxrygsvoGiwAgnUuaet7xgdM+g9lyBx7DiV8gR0OS2kRpDSAiu5k4NV7Tp0Bu2zenSUAoMoEcFhdVk
 gOV/3/dh
 gdDvgapn9NEMoZ3LqKXSsFnORQCEBpEfzzFWRp6pyZDfUMclF/XdX176LtF+UMO7oVVmegQAEGYxD5T5IXqrMPAb3t6TcdfLpCmQI7YXBts/aRFJGMYkofmD4Yw8OcUAVVbJEUSjevJVda506UZ+bwOu7Gi8HPB16VAeBv6JIRImvv772VZGwhOCjf76kRhp8WfbP9CZdSuIGk8XQvZBhbCshC5oqHPmY6+VQkZJ4EH+rxetfWJ3Qqt55a8w9hRxZV5MWb+9kWos7tf0SpAlZiWaA2RL6CSYTVrVMKNtbrBgEPTwhr7BV0Nb/1YoK7LmRYGKxc/4WzmRSY6/sxWWNMtTckMTrR5S2BJgcAe5W+VDhnaeUPMYY4+mwg6cgrethvywH3D7QXwSuTJLOrWn8XJUxTCdT1VGclmTR0aRRNdpiblk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
> the old folio's range with "while (ci_off++ < ci_end)", so the loop
> body runs on the already-incremented offset: the first entry is
> skipped and one entry past the range is read.  For a folio split
> that entry belongs to the first after-split folio and was just
> repointed by the replacement loop above, so the check would warn
> spuriously whenever sub-folio orders differ from the head folio's,
> as non-uniform swapcache splits now do.
>
> Use the same do-while pattern as the replacement loop.
>
> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and=
 switch API")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap_state.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


