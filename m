Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0BBCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 17:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9B68E0067; Mon, 13 Oct 2025 13:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1DE8E0009; Mon, 13 Oct 2025 13:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2608E0067; Mon, 13 Oct 2025 13:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D92BC8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:08:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B81488015
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:08:47 +0000 (UTC)
X-FDA: 83993725494.01.1E3191C
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013048.outbound.protection.outlook.com [40.107.201.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDEFE40009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:08:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Twshfs4e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760375324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEybL5wqSYdwBJSikoq7TQOmHOBJ3B3P3+QkFs0CbXM=;
	b=rXIQnPYhDTCmynaWi4Lyi4lknM7rKfPjiwW064EirvJqN47aCkbOn9BTs2BQittbpNN00T
	5pQojDgDqFpciTXFka+Gl8Sn7Y5LbzkitbqudGIlYEFtj1ttNjAeKaHCxb8B2gSgc81nWU
	KkYNHN1T9s528+9II4opObiV+KmGtOk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760375324; a=rsa-sha256;
	cv=pass;
	b=hqKMJOGIKb/nBkP7GGDbf5LWpSJkAzxmyuGe3POvlnjfw3y2a+D3TYK7EyQpfDXlMTZAJf
	Y5h7PLR1fmRMln3nM6W7NUADz/K6viSYLEDD9oYqBW1hEUgkGThyJzksyUoSQA5LxTkSO7
	tVpSyC+TSoaQ52piHyR+ZqMqhRIiBeE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Twshfs4e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+UbBHE7grE9r8IbQRLWE1TUskK2ZTJy5ybjq5fwMRDyws/ZbJK6PFUT7T8tPnLlDfOUIhpO6SHgmZa4HWliSw6ZOCf1qslrLwiAv4b9xVcYjwQw1/t3VW4hNxz9x/B0LYioHUSGjjQJCY6h1uojjXj6Q2BDS1gawEF63hSKNr2N7ldX33Xn7N0qgQBOg2ze7fxkFUwCdTKh8Lezn0DPVw7zg1MLetJnvJPT3cuqDTZg75/CRx4COXrJQXyIb37qObBpzq2kO8g4OfhIV7L8pxjgatiM0aaWR/4igoSXxm6PUUZiFGFNjnMD8I7/pkFgE66RCflQM2YofRfaj/hzTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEybL5wqSYdwBJSikoq7TQOmHOBJ3B3P3+QkFs0CbXM=;
 b=AWsjYaPh3Cjk2SjD7utk52nQr8tXiUDSOtOMGKybqbdZd3A1tJJDlZCp40YZB580GHJfG1EgZk0JfAYGokVKsAjtmEXUnfCGyqpyU1gTkjtt9FvHAahLHUd1RnQNduXdTW1dKoAHFwk9KmqTcAjcx30R2cgufOk+HcVMNG60To0HfAlzvf+ZGgDw9fAvm8bjUVqQ6Lb3iLPAr8/V4hTDJuEUhS92romkwqXngH2Clmj1SKFXSz8S5nm63hlyzzkSSn0fi2FmZaO5DC1o9+TWqCjiS98+TYafMSeVpt/8LUS1bf1UYFK0K8edwGmwBYnK/aRNC4uwzKEj39wziu7NAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEybL5wqSYdwBJSikoq7TQOmHOBJ3B3P3+QkFs0CbXM=;
 b=Twshfs4ecXR5NZWetYzZ4BcBsqkgEITzGvOAVrzeqe9HNtG/+g70nk6cFQfXadM1qrZxDYdZv6v6RsZ5DW2lvu+nX8Dyff4RGThPENrcNqNZkaUCeMDjupJWsckbcMXIxCcVFTufwE+0wg/gfjc6IleGm/m4hIAlTPidPtUJak6fRcssDyAVZpdCnE5ZdnCTB2g2SxKxa0RdgvQ+BXYvzl0Med3HkCw6XWLMknGhxSsn8loZPNeB7Kbodor/LuVXke/6xkxWfL93h9zIL3QHwJf8YgHIwhp6TbWZ2Altc3OlGBZM+r+O1QzdSs/xAaFDfNWPGrcuQOtPhOTldOTmYA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9728.namprd12.prod.outlook.com (2603:10b6:8:226::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.12; Mon, 13 Oct 2025 17:08:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 17:08:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: kernel test robot <lkp@intel.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, oe-kbuild-all@lists.linux.dev,
 akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/memory-failure: improve large block size folio
 handling.
Date: Mon, 13 Oct 2025 13:08:39 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <CAB0F919-DB00-4599-A3BD-293E13063221@nvidia.com>
In-Reply-To: <202510111805.rg0AewVk-lkp@intel.com>
References: <20251010173906.3128789-3-ziy@nvidia.com>
 <202510111805.rg0AewVk-lkp@intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:91::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9728:EE_
X-MS-Office365-Filtering-Correlation-Id: 6df8fe2b-9f91-476e-cef1-08de0a7b28e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u0Az85Di6KCk1f0AnXMEM6tVN2CCkeYwiKFvOjhJsTH+MfxCxC9++NNH4q7a?=
 =?us-ascii?Q?Pq08jOp4Y6J3u7qT9zCc4bl6Ovds2tx5MPdXTkAs6ESOHSHWpyPLf6P4E75K?=
 =?us-ascii?Q?K25oSc6I57splRBJweEtHy8T6DI5Ax2ksmIwBHT/zkacFZI8+gR7K+qIM2Pf?=
 =?us-ascii?Q?tI6msWcDepehgQ1GF8DIsloPo2I7MYKCQuz0UERikisPkhe02Udn4cjnVmnD?=
 =?us-ascii?Q?a4LTdGNovdJJLLvNHnC1DPaaK3Epuk5KUqQ+SPLguYFbLeLu4RWcqP0oLPLE?=
 =?us-ascii?Q?TvDp3R78JnioCt8MVuSIwI838dmlHz+HrFu91yPgQMt1/vwKnXSaxsVDJj+9?=
 =?us-ascii?Q?GnIpya9K5AKGNNHbgnDH+Ozo/TLbonAE5oJ9NcvtOiA74Lwr4xsua1Sm08oi?=
 =?us-ascii?Q?xz5gMCB1yAWqA+pyymJ9lLypCYlU3H/rhHcYVNWuGwhGgg8qSUoAUX+irLWi?=
 =?us-ascii?Q?0Jbza0JRpO1gNKrS5UOOM+bKsDNbZHpVIe8Wp0WUBqpCJQlKPsjHcPM0enBK?=
 =?us-ascii?Q?MX88oVgkj0m7GPIuOrsSDRB3p3Cb0iTRXx9FHSnwuRDMZqtPN8zf1mam8m0M?=
 =?us-ascii?Q?+wdiztS+WomOZ4rwBQG8iJXcOUaO/Aj0J7YbNn8zSShmGIzJhjpfPVCSvwfR?=
 =?us-ascii?Q?8MljfdkKzJidAhOKcFxBqkcWyYsLMHjglyoIE09XyOU+rWINIeQP6jGNW5Ay?=
 =?us-ascii?Q?Jd8KUH7RaBEahcRa9A9a+2mXMhPZZtT/lsJ/dcDuX4Mxi0LwpP+Ar9TLn1yh?=
 =?us-ascii?Q?o4jT4qZk886hUbysBLzMFMW0QHNppht1/GQOHO23P/oXTGE03fB9cFe30f9Y?=
 =?us-ascii?Q?LNxLays2evIB1yn35cq7LSSIXll1jU/FRNKa1wgL5pxah4Tv6TXE2/ioXvsc?=
 =?us-ascii?Q?waDZN6uSbJewlAC1K8vc3D2smg8p1mliPiWP7mXvqzY48pmHrvNOUSQFvdVP?=
 =?us-ascii?Q?3cFu0vy0z2zqNWCH41rhTNVm7EqbP3rCUO0kpR0bsdroi4stZoZ4TMxoURGf?=
 =?us-ascii?Q?QtJ8S7aJf+LZn75VbNAlbHKt9Hxj3FbQBMeIhQ0fpCXnrZIxkqegM8+pdFcv?=
 =?us-ascii?Q?WnVcNVZ/yG/iclGVd/EQzoE9QYbFHCxRWxutu79e57xY6RiCCzN0gGORjsB8?=
 =?us-ascii?Q?/CKrkHkJNbbEHHa2UfgZq69VmRGQQLacTQD5py2yfF9iBWHfe6TJXJu1hHCX?=
 =?us-ascii?Q?u4CWxG3iNS7dcThOlkQ8AxCpICKee6Ja00neR14Dnvd8Yaow24ZPsdugk7BW?=
 =?us-ascii?Q?p/wgqFNKBn4W8S4Yk4puQz8GDSWwC+LbbRFA1idP6STUlCwnbV/mG5RpKxcL?=
 =?us-ascii?Q?HNy6YqsgO5XGwT7JKDB31dsQLicqZWPjW0ctirmp5vWaJDfCDRbyzUoWBsDd?=
 =?us-ascii?Q?okRlNVeoi6XAKy9D5GW6wBH1ebA1X12rsisN7PumJnfcNVFiSAATCTQ6P7WZ?=
 =?us-ascii?Q?4btA/wu+Kd+gLENNUEQBBX1CNVZszI9NccWJt9sX4kNswsRkg8Rn6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uoKd1syMVR1CNGg3zpAS5GPxOIEASx+J7O8/qKlQje5DuurvUOqra6JALNlo?=
 =?us-ascii?Q?aF4x4b84cRQ9R5YIJ1tgmWm4XSYvqJsvJoE5J3i+S4QOapLieOn1ivuqqH36?=
 =?us-ascii?Q?e1sFpGV8HTU4Eh7BC2OuMwMVQhgwTJvXIqLE/lRIpzgR+M0H+0agSIbZWrq1?=
 =?us-ascii?Q?ADC/RNWaI2vDHzjU54LpcXi9Li1EwUaeX8tfY2+qJJWEMFx20Ok8cSdjY2oR?=
 =?us-ascii?Q?7jiXYNhI1Asu7uXFqmN0YASxsJB3hXHvqJTRe9YSVut/r6HU3Gm4FlFBStGi?=
 =?us-ascii?Q?ICHB1NPdB3QlVAx/gR7h6e2xpeEKPyBCuYN6vR7UCYr8i4kMUHnktyicBPtn?=
 =?us-ascii?Q?RK4dzpY75/Gs5xmG8ZEoU/emGJQ2w2f3yC8bQsTIWApEnxeMYvkwoUjzc/X8?=
 =?us-ascii?Q?ITejE1kBDjuYaTfvgdJgm6bCQhsBXwlB82tt5eMC8IR4jFVXIWb9/IED20qx?=
 =?us-ascii?Q?VCPzyCqgJYc8BcA+iiMle5phbRZIiri9yu2ymrj4fz6W5lonjIyC2+afluO8?=
 =?us-ascii?Q?0yKVxh8P1/1btqwkcMBKfnRJ4hl1xXLqG2r5DgoDdU/nSV6RsGwjcf83lWoz?=
 =?us-ascii?Q?GNE1ND0XV5d2C/QSYG0dNAqwhlZVATT429dw3r+oPZ+oiMPQrqxZvLJrQg4v?=
 =?us-ascii?Q?AoKh1H3YTl5w3jeGyBQ8DeqFIE/ylEqL7tgMTNEdKwCIG5bymZCZcG1Wwqyz?=
 =?us-ascii?Q?vhRwE/fEdb6VlW4ovO9YNd+rHX+IufZyPLkViqsYND0GkSZ/tzSU+/m30EOg?=
 =?us-ascii?Q?4R+1Le8B2NmIUKXMR9tnBG1yGaZizxtLuW6BPFkm5fm6bG8V/Xd11YjNcE86?=
 =?us-ascii?Q?2bjS5Xdh1ULoc5eMtRX/xeMFxSIUNWIDtdcerI/SAyLOZYe7K+XJRNgHx0Yq?=
 =?us-ascii?Q?84ORxK/rdVCI/TYvjcikMz5CTNppYPZQX9nJeaRi8SgREFYZwBPg+Kh5g22g?=
 =?us-ascii?Q?m/1pWh0ekSLGDfKf28HacIYCRIyXYt9+IYgGuDxPr/zED3fJeNv5NE7TTGqc?=
 =?us-ascii?Q?ywWAnsC+HaPV9zuJFXJ5ZHDoTUYpJ4QL2ODowTS7kZSi2v2p7s/+094u/tgf?=
 =?us-ascii?Q?mszhxHztjRnP35bqekhR+HOm1cxfPU4QMumU7KaPYtQIIy2Iv29PH+WEwsy+?=
 =?us-ascii?Q?6OOLThQ07TIPe79BYhN6QwM2GXZ8Ic/3UwPu5SKaI7+V4CofnWaUbeIq0gy6?=
 =?us-ascii?Q?yly1WJA6QHaf0ZRn509MXQRFQjhTrRG2t6rT6b5sB7GvwaUhaqOw8CWj/pHD?=
 =?us-ascii?Q?1VXfUXVNOclldNSnHjMSqIVnmyA92fEbhjpqfjNUUd+j8wMjn6p6X9gidVGg?=
 =?us-ascii?Q?aTcDrHMI2C6n8Q3nIApp35hedFOjeGFfKdfY22HE15pt1eibIIow1QPQPprq?=
 =?us-ascii?Q?xseW64w+jNm8fqFWZzOJ4fT5MgGeg2weoRH2llA3T/lxK3JqK6gzpo1Axgrm?=
 =?us-ascii?Q?g07jU0JeBbrmSL/zACvxR8Y6lvt3oZq+BkEkOv0PTz6NRfvYOGlq32wJfCLb?=
 =?us-ascii?Q?0Idh63yqu2JAZpyvp96oZ6SnMvRUeKajBZbrGlUtyp98usvR7RdVDKW40pzt?=
 =?us-ascii?Q?gPnYiKbAC7+F4QfuYVmVVUfKOkTs/AQly8Yvdjox?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df8fe2b-9f91-476e-cef1-08de0a7b28e2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 17:08:41.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mj4E/kZTtimL9iuFEPIU7qGnpVgCqT34jEOkhcuy2Ae+UGmY6kSeVzNjSAm0mzYI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9728
X-Rspam-User: 
X-Rspamd-Queue-Id: BDEFE40009
X-Rspamd-Server: rspam02
X-Stat-Signature: yo6spec17hus6zsnhsguyne4moohrstm
X-HE-Tag: 1760375324-789261
X-HE-Meta: U2FsdGVkX1894PWHHpIb4XmpJOK3XEiuYi+1TRJTKldgZ9t4D6p7+WfOmfh3RWZ+3iwHxFc354x2inqQOZhHmCaR/ilp29KasOS4ZxcrdmYDhBDcHfY42AyazC/rMY/p307PBqPAgGWeSv2cVrj5w8qTjhhwffv0uD8ZT0Qypfr3TIQRapHkiLNQnuPh1PskT+7oermQeTYmwIa1T7T55n5OsLgLRtOQRkDrn8KYRJGJwoYRXTVwGECIBPlCT8pnnDCVJ4CDJoXuw0MMypOgzgtGBbIk2sWSjOQ6BL668xBwNGUzneoTjyK4J9p66tYWgC8qvwjbBjWnEqdna2kGnenHca0Kz4hEDcFXiflB8UQD3EzReJ6hxZjYTv1NvWK4kGC92Ds4DBqgWddy1r9kXTFrHAi7B/dDUfw9fe3hrG47T15nSskDRu6RlHc+OV8XhtETwAxaEjFhSDvTgJowB8FchU7Tk34PAgHoW5q5fKvIDj7q1V9ofOmbE1sdABo7ohB8pSsNS7PHBYUFpWVCw2mvuspYCwLvp+ZL8Md1jz5CpdvfGYAGns7AloQ+F8O32s1WVZDtmrYAt9A0s295T7Fav5WJeJbyApsfOISXq3AR59jJobQeHTEPRVRM/RcPmRv1Zzl2h1mIVToNXssW0P4NGpiihuLn9/WwpAVw9d6ozMuXzD0vokl3Kbo+Z/C9SzT9bDYnfyDNhETk/+jSbS0LZNoouEFcCClqhCCXu9kENyY/bFC2QVLP6cBBXcYVeYiFsEJ/P5EakwPTIuj1PLPAfQo8vANyXgCxTd1/E4PwYs6xTpZ4uBA1Qi8TYc0OIA5WOFed+rBQYSOovBDF7mf8Oq1Xo/jeTP8W7GxiSiUsFJHn3CxL+gw7X+Nd+7iiSj7p3xVQnqq8xTVAvjJMlh7xGk76C11PCGq3MZRdE+SwW3p0WiMoR8nS2AGisZo0E0+KYYt3k5w5zEzyGoz
 ilnlQkEQ
 lmM++ehOM9xXdpP/cL8PNmDdSPxC0Mab3M0bkEi36GPT6N4vi5qqT2DdCN+KxC8iNIsUI8vji7Zqpdz/MsOj9E0HriVXVuVAs5uWH9nPUQPPGIOi5AWLWjN/0QxwJSuUPObamOfDsx8IIshj5wJT8m1gWKHWfWxh9kOBu50tr3jk2z2pBSUFqWW2kWSMS8xxlKa21o0B0Yh4N1YV4R64gcpmUK+no/ynj5ATO0WDYEr2WRGgihAYUZoeFB44Zyz2gmMcW/3kDzXs1bGkVzKGCl61H4Zw6Ib48l3x5ZJIEKt/Xunje3KJQOLfHhI5zK98H62BgKWPNDojBU2qMbN0G2VKOsS/JSDP9IIo/WzgNS2OqXfQste1eQlY137b1JdCpp0pwYB0kt9nar6w9FY260Z+MWniwxjP8z5UmdRLRWr6Ao7grk+fWX1SLhpr1lWgIUnfqfa0XuHIVdNK5Lc8D/iBYXPj40A2GRnU0vJEdd2I83ljDPiIOj9biVdVW+0+J1uOhFtsCCe/a9sobRPWLzIWHwvecDqlI40dmk2oRIR3N3zEyHLC4Uv2PD1qim6D1MxKJWrm/7w/xZIlgVOJ5ZiRyeGXQcG3rPjkmN0qJr9+w8AcGY0abNKBhEVvCojaHcOw+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Oct 2025, at 6:23, kernel test robot wrote:

> Hi Zi,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on linus/master]
> [also build test ERROR on v6.17 next-20251010]
> [cannot apply to akpm-mm/mm-everything]
> [If your patch is applied to the wrong git tree, kindly drop us a note.=

> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-huge_m=
emory-do-not-change-split_huge_page-target-order-silently/20251011-014145=

> base:   linus/master
> patch link:    https://lore.kernel.org/r/20251010173906.3128789-3-ziy%4=
0nvidia.com
> patch subject: [PATCH 2/2] mm/memory-failure: improve large block size =
folio handling.
> config: parisc-allmodconfig (https://download.01.org/0day-ci/archive/20=
251011/202510111805.rg0AewVk-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20251011/202510111805.rg0AewVk-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510111805.rg0AewVk-l=
kp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/memory-failure.c: In function 'memory_failure':
>>> mm/memory-failure.c:2278:33: error: implicit declaration of function =
'min_order_for_split' [-Wimplicit-function-declaration]
>     2278 |                 int new_order =3D min_order_for_split(folio)=
;
>          |                                 ^~~~~~~~~~~~~~~~~~~
>

min_order_for_split() is missing in the !CONFIG_TRANSPARENT_HUGEPAGE case=
=2E Will add one
to get rid of this error.

Thanks.


--
Best Regards,
Yan, Zi

