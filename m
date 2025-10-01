Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C870CAC5B8
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 02:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90ACC8E0006; Tue, 30 Sep 2025 22:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2818E0002; Tue, 30 Sep 2025 22:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0638E0006; Tue, 30 Sep 2025 22:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 693078E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:13:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF48D11AD9E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:13:35 +0000 (UTC)
X-FDA: 83947923990.12.3583CE3
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2017420002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:13:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LMVbHnnf;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759284813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzdxXIveayq2K1aICTqv1gyU1qWdEZXL/GS0UiVe01E=;
	b=umA1OXf3O7iDUEpq+WFnDgXOsiPpB1Y0vxtxpzW83q+8nLf/N8gh4CNKTiCUGNVI9L049O
	lCLXQrJlv93ta4OS8nxa8KJGHzrsQCS5abPvs71fkTPISggyePtP6OYfPcpkIKejC5mVqA
	6gbF3WmaRYaQSJxNbHD/avBHgbbO/Rg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LMVbHnnf;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759284813; a=rsa-sha256;
	cv=pass;
	b=2DZVd9e4zFzZSotVD8vECymqBs3Wn3ubTTQ0/zKZSuqUn9PAz+nGEKK8UAu53sp3R7izbI
	fR/ZuAp5rPAoYIgPJ4ylo1Ta56GwUjDRqOsIMPPnWWrMjpN9znWLOY/DaLK4Zp2sU1CfRI
	vLVzDycNN0YdY2MIM7VcJPyu7GntBow=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CEdmVHl0pe8oIxq9TCW3OF00LFeNDGBc844HcP9W+UC28uEJNBto/xOcur7dglSLKa3w+0L6nWw7X3AzZ/QZ6bDijs8asQD9zsPQmmP3ta0ogLcO8aXZG4PxMUcdAhRS1aw7nAcoyY/2RGKpGf4bBRVRn93HotvodY+TZwP/igtk31rP7tI1Mwh2H/oMwP9LZqD3fwG+wsWPkL8HFiSC0CKXtr46R5OhwV1VsidZc45dGFccR4UhmdAChPzF+z3pmP19hRN+E92z/CXEo5hqMwwRR1gdTOD6FsRo288dOlrlw/d0tG2QV/NygtP4bkhHsSFrw8fm9OulY1ZqCeb3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzdxXIveayq2K1aICTqv1gyU1qWdEZXL/GS0UiVe01E=;
 b=bTgWxJYA7G4mlIw3HNddWZwYzuhtVQga+MeTXnS+uJ4Iukwo3tStpFQ2nsxo8o2v0YZfJFZRWhTFttMQxhGl6cTsMRDb1jjYONca3dl16n1zZHhMgxILWbwds+28sEdKnSuCCkxZyu6/175jv6iKUKeU8wGlGxIE1B3DWJQ5yB4RhnMSeBTwZVDjU076glwKQyBkKm11eLJs388VEPBe9J03KU1F0gZYZhEHqXyYD4q1h1PvwafUWbopOrrE60PZbm3yLYSVMzmJzYE+/HnuMfkOz9F7w+X8E5a6zmboKp6TLZwRGBeeUyC/xREPL2vmvWGRIlYGd95WgpdEMXtcqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzdxXIveayq2K1aICTqv1gyU1qWdEZXL/GS0UiVe01E=;
 b=LMVbHnnfGj56BPusK8z+e6jv1uej92Kx4S2d2nhWn7kUJW4dwWfyCJjKADA/Zy7VWqRxouBs828Djb5QuFi1EZ3bErHsNE2Jn5ULR4grmmDaF0iAdDG4FrNyxnXFq2yYYE4xrRlMpP6fvFNdjHi/dWjpUnMG4DfEFDM+7R70lExcUngHnsCYsjmzmzlwn6xApByLE81+DIlXPIhTM0pK10SM1DzQHbzg2n2rnVvTT5YQJB7A6beHYwaizZjBkdYnM2FoA5eKedUumDmtUpxaG+Ngd/O6oPVU/Wj5vO4sD0Rfv2iVTcpBwE28mp349CmghQWKgEEbGUCt8M/+ijjhvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9141.namprd12.prod.outlook.com (2603:10b6:408:1a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 02:13:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 02:13:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 <syzkaller-bugs@googlegroups.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 David Hildenbrand <david@redhat.com>, Luis Chamberlain <mcgrof@kernel.org>,
 <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <nao.horiguchi@gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Tue, 30 Sep 2025 22:13:20 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <7F95F86F-F002-4CD1-A5B2-4A261A9D1317@nvidia.com>
In-Reply-To: <C7CD4DE5-1C8C-460D-BB9B-1A11C8E038C6@nvidia.com>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
 <CB2E9455-480C-438F-982A-AFCA1051BBDF@nvidia.com>
 <C7CD4DE5-1C8C-460D-BB9B-1A11C8E038C6@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:208:160::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9141:EE_
X-MS-Office365-Filtering-Correlation-Id: b7a92cc1-880c-45e1-f78f-08de0090190a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a/g/kK0wqZai65lL7dh1agae9/k6qzBnz0cD/u5UGMrV8GQsrAR8iMRgZVZL?=
 =?us-ascii?Q?Ftexj/bJKI0ybqfOCXkj98ovBUV1XG3JvfzkYf5btfUfxjUDAAiW/v5BgY2+?=
 =?us-ascii?Q?RfrWs2f/HSC28EL/LPLz8Cvs/ku1NIgoobA6W6qroHVGmovoYIxM88M0gYlo?=
 =?us-ascii?Q?zrUaBbi3QQWaCTZw3Eh1GsKGhs5BfUtcHdUXloYAia6lB/eZzl4t8hnrx4uR?=
 =?us-ascii?Q?UlqT7cbI+HrLbMOrs6y81qiB5MyclKd8YVi3lh69/CZkNf+BW37KpsCw0ORh?=
 =?us-ascii?Q?e4W6T2C3CYJf/xP9xmZtcEgMXJRDoIIQ39HZ/vaqTdn3IQpHugf1uLZqfsaP?=
 =?us-ascii?Q?DVqyFdkN1CZ7pX3iT/YU7NzvustPaqTsF1NO6+gJkFLt1hFEWoRWy3qjGQKE?=
 =?us-ascii?Q?R8+NB9dLptUks8K6XPMSU10es2ww5J7u7WDLyVHgcjiUkP8+Ay/OvSS8do1Q?=
 =?us-ascii?Q?dOZjJiYygasBos6EbEE/Euxc3GwVfzR+YC+dzYTvuHrxLIB+8WdjvB6UPMoa?=
 =?us-ascii?Q?TuMHyRPrPM0IhLMTGMnEkXobJmss3qtPoZb/WCMp6sIrkJIO6DKn2tTpDCRG?=
 =?us-ascii?Q?8FnMVekdRyd8aIsk+FlWxgK4m/gdakeoH16VyqLgAVSNWsrlHTZtA3HQvIGZ?=
 =?us-ascii?Q?nPXu9BMbXGslsRa7vhYnUjbfjqQKlA4WfsH6czAM1cBzrM91amzm01tZ2kIw?=
 =?us-ascii?Q?fkM8GOyPdPUWKrVS81Xf6zfoHNSo7upiprqE3RM6g+tHyeCllyYlY9OBrSAa?=
 =?us-ascii?Q?RMB401PxwCzTW+Qibqp7rsI15vQoUjA/iSvh7qJoDJRTyVh+HJLMkqa6aNbZ?=
 =?us-ascii?Q?rdh+doCKee4+EDWzR+6DfBWdgYAj6uCkcVhrM+n2maEYany943ETutiFfWA2?=
 =?us-ascii?Q?jZ3rESg4h1d5GyFsObG6TyE5R5G6Ce27tqJIt7a/7sPjyoYCNMIGVUdF5ZIL?=
 =?us-ascii?Q?C9ku3EYzkpVNMNZGKTQNi8oCrvRChSmg73INIFxJXmkWLMEaQq2vPoqa3I0+?=
 =?us-ascii?Q?SGdfLozjxX45iQ69zvcv5d0XNuphYpzxybh7zMHef6kPrQRngI+Hroj2/0o8?=
 =?us-ascii?Q?+Yx45A/nmg1SUDQjtyY8LM47zO3J7YKKBz55HAl9wJbqCTjdeOPg0kCc3drb?=
 =?us-ascii?Q?rckNZ6FghaRy/g+zsOFaGNG5BiMhDKUZcVBKiLzsgiUPlLn1Ol1l25gDwp7c?=
 =?us-ascii?Q?QBLliUPV2hv9clHQPlwoekP3J8OhSYJvYIchDCNWMah7EnruzYwV2I+ZGNkn?=
 =?us-ascii?Q?wBTq9tkFzoxQ336LkE6k34TXeucWrCD9Hvz8ZTgmdM/xHH8dDHHaQnOpMB+6?=
 =?us-ascii?Q?Rd3+9L6xl0sUkUtZDBgLGmz0o0ZcL98y0+XIW/Pyg630opbh1/T+sGGQNEtp?=
 =?us-ascii?Q?ywUFF3MI0D0a2j2EcDt5TD3xclQWR9X9ZN+JMHqoS1XD4e3v6+wGro7l2SY8?=
 =?us-ascii?Q?MR8XUKTuNUzgR3Asr0SFIlJH2KONp7RGbwfpKkED2rNfReEi5LxpvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vD1/1bjHnP4hcPKssvu40JOTYFrCXIBOflfCv2s2JSTLqcLfLrFlNvbocr2t?=
 =?us-ascii?Q?me0XZ3uzuKJCvXwYXpBq9wOgQ6n4u+xZDRCjkK2Bgiv/Mal5VrGz0t/kDEOf?=
 =?us-ascii?Q?wGME6dkFY7F2LsaObmXj8UTI/yaYUKpzpUPUZZHvKJLaj7GScHrH8VTQ7/OM?=
 =?us-ascii?Q?2V5VPpW7S3WU3T/NZpYL6eXir3GynKXVZc5JW2eNf/rjbzdVFdbPUOMSVMyz?=
 =?us-ascii?Q?qwtqUTZ8jUP3SJ4LQ6d4zEknHFZup9psuOu4xCwCIcm22opEJlzDk4U+hdrY?=
 =?us-ascii?Q?+gp+fatP0IHRFyVA1AUiQL5pc20RLYX8rm9dHE4wG+1v/VvgW4bAb1DTQiUK?=
 =?us-ascii?Q?gEQiob0kYPdLS6/Y3O9xxdQIFE37cxhsNdlXTQgEZw0a1JN1AAyJoN3cBR+x?=
 =?us-ascii?Q?dWuFsoozvmclaE3ciY9PvxAgfqk0DeZ2N+92yBaWhhXuDlFIkUWCsM38Sbb2?=
 =?us-ascii?Q?ZV+voUt7MQ74t7+7u1k5kFN4tDmrpZwdVeBY6f2M0dfP9ST3XBMNAUZIEirS?=
 =?us-ascii?Q?S2r9UFGSXv4hFlslPeMmlIeiUBGOHRL7PS8rRzdL9EsMv+eM/9s1ypRTfwN9?=
 =?us-ascii?Q?n+zChgc8SNM/PrH1JTRiwuBQDs0nS5+1Kp1fWeVlTD3We1GyGK5YBC2KNsiS?=
 =?us-ascii?Q?WQ+uibxi1laFAdMP99kvnWv/WEf+ikUS2MxcwW1BdqMLLeMn5VttQSm/B1hI?=
 =?us-ascii?Q?sLM5dMhkux8vGtd/JZ2RtCPmyFMZJVlwc2Qo3uhXksXNyTiXTn5BTiwEnB1a?=
 =?us-ascii?Q?9zZSoL2XNhiAkADXN8NxIn/fNfMkAuXX6aSH6BEOj64jOBRs+jdvPcBr5xru?=
 =?us-ascii?Q?MM/j1g40eJZK583vP32hJrnr0N4+zQsm7KGhBMRC9PxMEHK+obedns4TrnJi?=
 =?us-ascii?Q?QKNa1TZlCi3vukbxIgfH0dcImOGAi+vCsgMboNrRkSjTDPW29mf12RHUHdid?=
 =?us-ascii?Q?BKOFAfRMk67WgH7QTVZV89x4gu+jCAZHdNnCaJHDBR46EQeI4olALUx9GdaL?=
 =?us-ascii?Q?EsYa9KpvabrjPYkx9mINeOoesXYgO4TDFQ/Ns8tM/p1b49Ws9XkBOx0hnCIs?=
 =?us-ascii?Q?IDS/eXCdBbmIQmRf5cuaAUF2g7cdwAzrrum0B1EnFXBah1wxh1i5bRFEQVxa?=
 =?us-ascii?Q?ZPtKynMZNwXuSNYeBDWR5A4r1725nS+UlmrbypOCdJZHPLs6ozCle0w3eUBp?=
 =?us-ascii?Q?uPSo1UYkiWpSwzq4152CZduWQuVtADo/ekY5Y32IxzOU6s8MHQW+9Hk5hK9w?=
 =?us-ascii?Q?gztKB0ftXqJueg1mSkzQLFI08K1bdIs83k9nqFtr2kz4OlrSANXb/OHXHLgH?=
 =?us-ascii?Q?SRKwA+9RngcoBkUMLzBqYoqG7kFHnRHhO9F99lYS+xuhW/UrDJYMnXVRP0Di?=
 =?us-ascii?Q?3qnJ7ap26jNL/9FOWueAlwApUExluPioS/HzM2AsrV0UdP1CFBEpk64kz47M?=
 =?us-ascii?Q?cD1Lpd6BZ2W0bTCY6PZly7Rd89cJYqO4MWxa92UzoONFGah0c66QR2cTm8fe?=
 =?us-ascii?Q?HDmwXFmgBOgKVVgrUCadz37GBxVJxE1t8X9XhAJrT7s5Wv8PATrlvx+seD4e?=
 =?us-ascii?Q?gVgGEUVIuw9qXKi7fLjmDYODZgyXpLXiyRCHCYS2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a92cc1-880c-45e1-f78f-08de0090190a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 02:13:22.9582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPDKDA4SIsWdVvP9Nors7l+MgYLyQtbymBNnMv6nhLRxnWhBi7um4vBD9fbnZGE4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9141
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2017420002
X-Stat-Signature: a19dsdepcpxr6zwoydwwrfm7oxt5eyou
X-HE-Tag: 1759284812-122766
X-HE-Meta: U2FsdGVkX1+sP0UZ/PndTaWrd4IADjRI24aob6m2h7DYfQz1nIrjqeEa9jfBxQOnBRgqxgXXzrTuGU0s3YpUngk6QIt7H3aO2NGDxjfAtDXeslkwOvksHsXktsErhBJwgD/F5muHFRC+mj5whjKG5DQjEgNFZIhrjg3nJz1tPnpZbsZze6V/iNfSLqrQRDVENoXdCvHu1y3k0yoKTLEOHAJR8zYnIBy9J7MN74YLEAD7b78D412ZAu6wF9QOdHRi7IzkNJf6JRbdA+TjHyYCqjPIzWln2Q9+Hq4Lps9BImcpd15zNjUMMWGbBNbsudi+nSzMSkGhBRg6MkAIDsRx7UzG9Dpixup6o6BV9KFFsSiu2n+STxj2aIwlciO+H6ZTtgie6b2bnOpSk0N63uRRwUfZBKh5XMeHgyv4SSesv9fpL8o+AOOHBEgAr+zydQg+XybDjayN5UHxoldjaAXHnxTcLaXhuwZDLoKIFkZtgqfS6tHPD821T84+jFqz5q+KsAqCQ4Ymji9TA4rPi9JT6P9PPJ4ZzMG74TSp06EP+GW0QNysBwX9AV2hiAOtEwB/cYGZgg9o6C1aQ+dzXzON4PsttOEXlO4zz2+hzOqjsOpPvR2U6AqgQWkXd+vjL6EHtsAYViZOfs5kuuHjuuwMv+Fb4cwqgBhqPsVrvFdlMfWUVPvyUsdtKgpFk4N5I16gP9Bhvje5Ip+2aopYBG4cQQnMhmt58f8KeJkIw7paudjRj256JW3nZ6ZnLEwtuSpnWTcfDuckmkOeTxReecH8aWJ3uWk933eJxRGy+WW/4QekZP5zHTjfFtrVixTh6BsK4MzMUDZne/V5uhWCtO7Nuw0LFhKagTjTJ36JlY7beMKDTRQylJ+QWsc6KL8F4QJETwbnNbyOGEjPpCFvgB5iadAHgsa84/GeXQ6/9r+OH+ynApw7j5PefWIL1ZrMk+jTJ40tz+WNGQeWrS00gW2
 kk1SOdm4
 1MfDuns6SOz9/os2kz+BqJZykaH+xmwNmhtUKNz/9pakmTIeFErpM6+hZ4Gp/HW+pM4l0LNZZXOtwWqYsOqeNSveFKvs7dM6LasAQffhtV5wwdEsLq3Ow1FlH/e2zDAKR54W09ZtT4NwBjrabmp6jZ6ZoFU9Y3nmmJ1z4GrTITAYWJoTjg84+9uqqRP9i2itxjhkDIeKbbV2faQHeGYxBvhuWZXQ4fj4rlHuJcaBi+jpFTKs2aKoYxA4ZcscHV2MK9XpMMbIKtldSZhJJaOxw9orgCjvkXh6VFrVPhPGaUvhU/3xyN3/Wo0B/u+x5ft75XQO5Y7yXigTQvl9wXJvcKLz/nxXGYK+zQSpVCr7OLHX5Q6JQQZ+T3ZFMPbrruS0n0nR62qswx1r8IrBk3ufFsxgk2fCoXaLDCUVy/DAgIPWABua6Z2+Ch3Gebnbj3k6l+iJcLN+nHwOPKevug0rVnv0kECM4LpHxyiV5o7C1+hKxkq/QXak7ktViuHWlwFSNTubRXAd0Kz3UIc1PdMnM36M6pM5wGOhxoqrUhIk/S1bvbvqCPSeQIjGlJdJDlTgWIwSF39ITgx+KLrP5PVpN2+jhctcabXBi2eRVk7vEPB/xorCJZO2l4DTd1EpudXMu6/g8SrNfMSpU4wDHGeL1hOB0nqlO1xbDCD0w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Sep 2025, at 21:51, Zi Yan wrote:

> On 29 Sep 2025, at 11:20, Zi Yan wrote:
>
>> On 29 Sep 2025, at 7:08, Pankaj Raghav (Samsung) wrote:
>>
>>>>
>>>> I want to change all the split functions in huge_mm.h and provide
>>>> mapping_min_folio_order() to try_folio_split() in truncate_inode_par=
tial_folio().
>>>>
>>>> Something like below:
>>>>
>>>> 1. no split function will change the given order;
>>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided ne=
w_order
>>>> is smaller than mapping_min_folio_order().
>>>>
>>>> In this way, for an LBS folio that cannot be split to order 0, split=

>>>> functions will return -EINVAL to tell caller that the folio cannot
>>>> be split. The caller is supposed to handle the split failure.
>>>
>>> IIUC, we will remove warn on once but just return -EINVAL in __folio_=
split()
>>> function if new_order < min_order like this:
>>> ...
>>> 		min_order =3D mapping_min_folio_order(folio->mapping);
>>> 		if (new_order < min_order) {
>>> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
>>> -				     min_order);
>>> 			ret =3D -EINVAL;
>>> 			goto out;
>>> 		}
>>> ...
>>>>
>>>> WDYT?
>>>>
>>> I think it should be fine as along as we return an error if someone i=
s
>>> trying to split < min_order for file-backed folios.
>>>
>
> <snip>
>
>>
>> OK, I will send a proper patch to fix this. Thanks.

Let me try again:

#syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_orde=
r-for-kernelci

--
Best Regards,
Yan, Zi

