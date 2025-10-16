Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17A1CCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074028E0099; Wed, 15 Oct 2025 21:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B358E0008; Wed, 15 Oct 2025 21:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA38A8E0099; Wed, 15 Oct 2025 21:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D90448E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:14:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92F09B6066
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:14:41 +0000 (UTC)
X-FDA: 84002207562.15.7C8699C
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15D641C000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:14:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sOaPkGVl;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760577278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hbz3JeY5nZozEmDtODcDGq8MVsAWnCAeoX2um0uRtUs=;
	b=UJcld4SnvWdYx2H04upRclaR4c6spze9qUD4HKRKEd1/XojXT03cNXUyGaSA/B0YnwhyG/
	AN3HsYpGjfoZ4Ap8fgW0lhtxRfcUkIOYh9n13nij1GIecJOWejbZ/vn7jJGHsWKkFgxOMj
	7edKtFpE2F95Javqz6tfNoDuRQKjkrE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sOaPkGVl;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760577278; a=rsa-sha256;
	cv=pass;
	b=yoms95aVZM8LJFzqE1+n9iPiOK9gWnqTJblL6ycQ2fHJwA74ztBeqdCbOi6QST40K7eGBZ
	8LNOBKPzXDbVxeLEkfmjTwxP8rob7dZoc/t93WRuqfDNY6Pu5lHPMNrspjDVy7zhm/xwlx
	1CfUDTuYaVESo2R+mkZy3wuJbuYuqlo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqQP3KJkejbt0kYLrwMmDm940MiUNbC/B6xjDgOyN+lCMnm8bgWIyjHgoYri0+UzfwYXLL9O6rhKnR3soYs+LidQUXCFYAvxttGn9U6rMF40SmG/KRO/7Jtp2Rp1lF7JmrHHUyJKvnZqDWvvvFf+SdQJyMyZiEZ6yMaiV6wUXdYoG+e1eLIH4cCXnUHdCMWcWhwSUCugMR7HfNxSmwZapy09GDNddlyL3eQeFJE3ph1dZ/GN3SqUSjrxjWx2HeA/UTM4YqvvqDuS5j/gQdijsuIQJO5mhpgRx9dFnnC40TU+UC4zfsG9NcvW42m1iHsMeqQAmtMg9DhTlhPcuD9J6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbz3JeY5nZozEmDtODcDGq8MVsAWnCAeoX2um0uRtUs=;
 b=UMaR/tYA6cLpdIvRx90TVX3A/jTbWlLaSGabUOl/AvJh3y9IO6xq8pDoRS3cVce91rbLBdqgDuuYtWFUbN7H2275mk2Al+rvG2Qy+gJa4n4ZGc6dnMdW4L8E7ZLVk5i3KYOya/A1IrKUcw75RwGId07b6grJLTCLzWx9T8eOzZ9IcJ4/+2WQeSXimP3eymDpKxn5OJel9WLOLuTJy+4lMgKG4g616MQuYbZaJG8l83FDwzeV3eNEdfI96x1O190WgKHII7dscU02bQVu6cFdRxTj47QOrCFyR2DcFYmYqjetjozjKaQPKYMjLoKIOJPL8RPCZCKZ3Y9McOTXBqaPgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hbz3JeY5nZozEmDtODcDGq8MVsAWnCAeoX2um0uRtUs=;
 b=sOaPkGVlXSCYZkOgBDq+zn6SGAHNAVt14RGypiUJKwXvqh6KJ3qxI5+k/4ss2FrNGtNUItYKfbmbuX+WOYfIOFvO5qeI0ZUUn/D1YsIJDFVkgAHPtxGtlqn+pYKbWsRcGqbgwzbVXGk7iSgYSAW5Vd4LPUvX6CxcJeJHYsZbuJ5FwCYU7g8vitu3MSdEfXPjqC1EJjlQt6pAFHD7sVGvi9HzfdbrAG4V2J3Zyk2FFhPkQk/MKBrUPUApzVLCe3cgKIaQM/v71LjOn32XCckeBYQc7UBr/cnVU8vq1DWB+22C4KjL7s1gpDAxamjPLRu6W45SW87QTUws+PKTPSmgHg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB8916.namprd12.prod.outlook.com (2603:10b6:303:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 01:14:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Thu, 16 Oct 2025
 01:14:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
Date: Wed, 15 Oct 2025 21:14:31 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <1732C470-7FA4-4B7A-A8B9-8EE880704035@nvidia.com>
In-Reply-To: <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0757.namprd03.prod.outlook.com
 (2603:10b6:408:13a::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB8916:EE_
X-MS-Office365-Filtering-Correlation-Id: 309bfe72-4811-4a6c-afd8-08de0c515d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fl1ciY0ykJqZKvXUEd8BU24MrpyX4rd5CmzKz5auYdOGIG3JKoRubv1EnJM3?=
 =?us-ascii?Q?6f6YaBB0B+i1B5rTGJrYG3Q41CxFZnKC6u4/xYn9++UHSB5IKove4gNqBeBH?=
 =?us-ascii?Q?T8OpLo+whnzJ+1hp44NKv8LxvCfq/r+Cw5uO9lD23mxnw5BoXHAW3V4YGBcN?=
 =?us-ascii?Q?sD7cEi3HMd+gZh6Q8AQR/Ka4FJxO4PBA5Pk/pPtUcRXk4qJ426n5WpLDCO0W?=
 =?us-ascii?Q?LhZ2dmq1e4YzRzUYsW8DGT4j7spY2qQbHYATqTtGyO0fiOQmLb0zD2WSpVe/?=
 =?us-ascii?Q?245SV219rhxEvrHhMdvKO0JK7mVMfnoPOOKqYkPBlGG6HZyDbVhlyqS44KrC?=
 =?us-ascii?Q?jPR3iTb9SxUhljdyafnWyPkzhoW/CWUcmekVuuzL99puv2pNSsOi3JXUKGrY?=
 =?us-ascii?Q?PKAOSGEz3bY1uba8AwS2S9pC/ZQMBRcVF7O1V3im5u9DD+FkdldgTqwPi9X0?=
 =?us-ascii?Q?3QXgFFRDA1uT9QLI200flJVbWRT2xWPtPHBSWUuLtfN8FO2MVa0DxczB8ByN?=
 =?us-ascii?Q?kd+dvList8NWq9q7GYNYmlwVUGHRvDD01ldZfZpSQOawLiqYcZ4257OYrRQm?=
 =?us-ascii?Q?Zkd76BV8DSEfJWWGu5lviTAvWU42FC8DtpbXibow3oJ9JtPUbp2TpsdVaIsk?=
 =?us-ascii?Q?Whl9xxoi7kofS2t4zLP4yjBkfw6lJU344vZpO7rld7c/jWZoAYHBG2qDKCLx?=
 =?us-ascii?Q?der0EqTfW0jRxfndccwk7y3VihreLKETEnUsaFibYRfF5Pa9MpZQ3xHguifF?=
 =?us-ascii?Q?J5Kb4DqKihE50lqgCJ34LKDInp9hrmG2iq68i6Dmped84jjC88LJn7rmbtTo?=
 =?us-ascii?Q?/pkInk/MvOUYNSauLK32q93e2bi/l/LikL1FsHqnw7XEgl3C5Rw6d7Qa9W83?=
 =?us-ascii?Q?1leLCW3t85swVNSn/AGHDYEArsk5f1XPOG4g4dy/zJbz69SqXeHXP95lt+Sb?=
 =?us-ascii?Q?rqGCHfCMS27yojCC05oYwtUIhczErABbzN/BSFNgACCzvfsaTVR1bmqJKGC6?=
 =?us-ascii?Q?6YOyRN71zzLs/LzjAXJD3PkimzdCIawXzGBDaV42y3AS5UghV/LYpRUZWpfs?=
 =?us-ascii?Q?impM4oGmo+UE6XK0b66vMQLo8MgeBL4l1WKMrRaDxi5gpq/fRh6VqRBsd7nE?=
 =?us-ascii?Q?VIZvq4EBd4b3KO9wUVBJOMuf9b0PyC9f3RekwuBgs4U32GvN8Q6qzYhFNjZW?=
 =?us-ascii?Q?4CkCT+X1C8KJd2UhOb5EEXLDK6uNfPS8Cq9ohyg5vNe1TO8XPWRuliJJwQKo?=
 =?us-ascii?Q?X08TTdyGgEMelY793/RoyJL+X2PHWZAW59j+mbt2ZO6xwAkl8MXIf4SL1j17?=
 =?us-ascii?Q?1LMoGixlE+vsCsTcz8bXbRdRx7e36OMUmdcT2gBBBolA7B4Rl/YnFohJAqEC?=
 =?us-ascii?Q?o/OBBt7xicrXhoJ5JhXNM4C1ItSYcxw+c6wRREQiThR/niQQDFmJE9FWj7QC?=
 =?us-ascii?Q?37T/HDPINvMe6jztQuOySfZyr/xC6voF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nGc1FVkhbqIJisv3V3KVI//H93CXGoj7e2H90OiZDaZOER/W0Wm0YvvZn8fJ?=
 =?us-ascii?Q?n0Z/2dsy+l/n1eG+L5eiDPBNc7sr1iswZVOjXcphBTLwqx3+wgHo7E4B5i28?=
 =?us-ascii?Q?1B43G7PyZrkVzEtkLvWM630ctxlJbj3JEr4KgLWz4eeCUDSJFBJbmRidj91t?=
 =?us-ascii?Q?aNimV8EByN2gsvlhaQIBemdy2Lpz/QsERiw5Qn26GvhJXOCvlygBlcikZEQi?=
 =?us-ascii?Q?rSyw7BSBcZeknSRaaDO01Gn7OGhrnacFAwTyW4saBgZdtRW+33jUZni47pP2?=
 =?us-ascii?Q?fOFUrkkoSel/fGHrrA3s3jNi/PsnH8GqRax3KftzfgIgl30boE2B68ep8W8C?=
 =?us-ascii?Q?eeXGBt6/twH9iIVkyFla98SiSZvNF+3KcTkrbBeLpwOhX13AIspQqTZhlB2E?=
 =?us-ascii?Q?Hxk4ecpQ80VoJ+d1UdcY8w8XDbaOkmgt8kT5Qg1xcaSji7cYp0uPdwYh7zqI?=
 =?us-ascii?Q?1Z966wVidzS7emwD3TDXfqKnJP/qmYmEDmt11pHwIOZtCE6z+vPI1R7XARPT?=
 =?us-ascii?Q?Oc0KktBwwYcL6PAfYY16Qe2/g6yA9aeePDOz7kPEf+jnO+tzCaAZal0v1WU4?=
 =?us-ascii?Q?ABlotftudGpaJ4Vxes5xsicRDNcGQg9ZuoW8t4g15WILYiFtYSKxZmmsgRxF?=
 =?us-ascii?Q?LDS/98q/Y94yj6RAQSJMCwTL1QV210hciyhDxbf0tDuB+xHaYNe9tM3dFY7B?=
 =?us-ascii?Q?MZSl+zGw5BSKiU6ejghLpO+iXYOY6AqW3jKec+I3fye/darwFeLhpND2qIBq?=
 =?us-ascii?Q?IfmEip4uoIMSvgQqjETPGeUV5z8AIDuGDpC1aP8nT4EPvDXSjWlY9GKk00Mx?=
 =?us-ascii?Q?tTF29btgtzNqcjskyotxIMS8+U0anCqzIuW1QFzWCl0bYMH2KuZG4JXpSnO/?=
 =?us-ascii?Q?OridkSRJSybiDs42tweYoKzPw2OiBk2WeqdzeRaA4mfzhYnzXx/+L8DxjdaZ?=
 =?us-ascii?Q?sCgiHm4FPFX5FD2xQHYGcX1Rg+Idx/Og3K8MUEv6TeNvusHdmqhNJ4Q3bo98?=
 =?us-ascii?Q?ktDiaFYnMRDiIpU71BZNcXuV7RycHwqgdZCZ6lLsJ0hTuQJiTvhpuxo0AUXq?=
 =?us-ascii?Q?UbJwYnvHT4ZIn4rfmpA1WNEZX1cDr2N8cWJkWcRdhMmuKtNAg5SNpeDmlW+7?=
 =?us-ascii?Q?6tiTrC3uWsrE6VFqcmhVqtKV+j8SHwTLLBYWdZaZxTRD5NPyPzgoh2yRkUnO?=
 =?us-ascii?Q?5YS5eXWcpVlmai1Fl3YTXn8Cjbh1zdOF41DSIicVudYiAW0QGQlrCLx5LLpj?=
 =?us-ascii?Q?10xOqVyYPN+3lgTtm/jIjbQMSz2skI2HcUcfAN2Fo9/dZt8oQJvoU+A/ePZQ?=
 =?us-ascii?Q?ggDfekoQT8RjAId4J60i5mbIX9iGieu7MbIPvSwAAQ1ihZs//O7y0Pgtt5tr?=
 =?us-ascii?Q?mD+va3O5GzUyCCHEV7mhx8tEO8Y1Iq5Pi/3oj4wgzByn0hyuYzuKhLFXZVMm?=
 =?us-ascii?Q?vhKbfZqD8r5T1oNy1ZRkV7HXabXdMrvam61M4a4pUW1ZFh/JPho6uSwqM/pX?=
 =?us-ascii?Q?08KhEOQZP/D3qf6rmFbbDe4AXNIaXf0g/vCHe6zexz60iDUQntzMEpXFYxCY?=
 =?us-ascii?Q?OgkDJLg8P7DwNxmzmkx9bfY8HAVlT5MB200LGxpM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309bfe72-4811-4a6c-afd8-08de0c515d6a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 01:14:33.3399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvkYLmqlB0mwINhB5CKL8SrmD5A8j5MVrwYSXVCZdtTfYWpItp52TNm3hFjuzUrW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8916
X-Rspamd-Queue-Id: 15D641C000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ntzx4fenznqeo4b4w4bh7djbuztc69f3
X-HE-Tag: 1760577277-415873
X-HE-Meta: U2FsdGVkX18q2GrskSEZAn71UcTVN1Dmid78iPsb5o90PWBQLu1o/BS98Y83X+x57TTsEjVYZIEmI81UW9diAhuWkiyyF3kUA5Y/xbBlQPhsPL3qrvDfzihNiDkQflNeKgsuEaa7heL9dguHUdRUb+F+9ye9PUWY/Ixy6NrmrfjNt+j7v6j0sthS+3MipmAHHYcIlUTUfD9xBSfoR7++mhkOnjBDSHLQyQL32SbZVq0oC7hWGLaevgnjBbrGphZvWeOP4LCaa9pdE0q9e1//NYBg7bC4S+COo8+LvQUnjH05qiICO3o3ioqyzP5ahNPXeu7UNa5exuhci1U2j+lNS8DI6WzQIyD27eJWJBMro0gI53Lz4a4EaTpFAJu4DeY8zOnclGgR5tXbw4gUU2925S+M3pujGWfam09RBugE8Lyc56xGplDhxK6NlLqYr2616UhsOTA3Cl6AVpS4XoZJ5rGriniSZbVSiP5oYeaTqRMoOvL9C5ceTk3R9aa76IioVeShOe0LXeCV0j9Zsi+ehx+BaZRWI+YmOaeuNuSQf42sQ7exIUxMQpVsXt7pGp7LpFR7fMvb/upI9LnlS+7oSQop3pBpToEofTFWwdwNHrxo1C4jikQxoXyv/MhDqdZghZa9IuOD14lgqHSDS+vXaGZCvCCj+Gzhmjdga0Q1WjEuFXDuyn1ysZTlnNuhSV0teWVhyovikAVQII1J+/8OH7UBQopNNc36ZD0Jr85c4/mXN7SMKJ8yunvVLGCtdSvMs5DH2ySOFRs41stv5CQ+Bgo3FMgP4wJ6QTRnuw+4MbwxiF8dFcRmfS0VrcXIOb4RknujS3zD1AnrqcySduDTRxpW62pY+W8tCPA51EaxZPJ/Y0EeXejcxt6gamMwLd2CANkzoRJBUcMDLNTgNsLyEooeIM9lUrdTIIfjJDh7ScscZ80GZPP7sEAnoEyt5Uc2wB9ezDB1rs8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Oct 2025, at 8:35, Kefeng Wang wrote:

> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mprotect.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
Makes sense. Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

