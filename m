Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E10CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABA46B00A1; Thu, 28 Aug 2025 15:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783816B00A3; Thu, 28 Aug 2025 15:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671E36B00A4; Thu, 28 Aug 2025 15:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 576A96B00A1
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:18:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0ED521DD5E5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:18:33 +0000 (UTC)
X-FDA: 83827127706.17.2D68BD3
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5249720006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:18:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kUdpqfjk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.50 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756408710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mgqg7jv533EByceZHfSmVEnFe8pbA07e3o/tOscS54=;
	b=3O8GMiCD0yfUjzI+6IL3EbHnO+pXVhPGSnh7xJmf+zE5gWomUm6hoxJL8lN3H6e3tipnX9
	Y+s/TOT0mkczywQM9ChivxciFjLQZNOFttSrtkl9PwSkAroKXfaxPZ9VlLySAuViw99QmW
	RqFbLQtZ5TCDCXepMBfNZxBm2ZlwAfo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kUdpqfjk;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.50 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756408710; a=rsa-sha256;
	cv=pass;
	b=43WuLUK9GW0p6+V6WGjRCJMfS4LeHdgzGlT05QatdlFwcZ63wNAqrrhHCehA25OYCk3ypt
	7hKpNwcuPkMVCxEuu/0mAlqkBhHrX/V2ltxPOvNyoRLEw8zDxA/6aRoomqohE/kA/zpikv
	+Jh+ltLfImaMypJcxMeSup7E5xjOu0w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewH2ieH5LDzBiW3oheyBFwIa/Nafy26BsTHhGXxP7b7oUC14NAtvTcoMrcTe/vUn3asLXce8N7ZgywJeBWvbYuqtVhk8LHfBS14S/3ApUUQJAoxzcMIrv8UGGtdiXt3PIk/3AK/ZM4b5WUg1vPLXt3REDtkapOr6yV0q9GHLjiDEwejVKMtAM8sCsEsUEZaOUMdDzDbYSynev5JwfpIiOHFliZ8E1Kj4H3F5xp17cI49SV1htvUuGW/AhcQDyAI1yR84Rqn4omafTb3RS/siwn/lNZSgQuBICE7YiCC8yAT2+LanLJ9QQMZaqoDD1GDDVWm5JZtJMKigGAA+ULBaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mgqg7jv533EByceZHfSmVEnFe8pbA07e3o/tOscS54=;
 b=X/7wBUXT89nTZbGqbEYuSk7vOfv4nCYGYmap/KinegRe3Rv421Q/5BOmPy1DsUX0ZMSRf3qBc/2fdRB4g5y2NI0ZqHw6QonCPIyyX4MxS+WNjkPC/5Fl9cQSPlRvR79DQiBitxLE8WWHv9XhLh1j62d+C5QYAn/gPMP4q/r891Hz9nq5CTkNmLvbgqbNqYa5pPcpKPxYz3gti1wcdWoKNPULQC9cVGv8fEDezkmtBEEqpkNkFKnX1dLkuLj4JGL3RvjXYwfiAQJ8od2bpzAzM/jexnkcb8vdnV3vc1qP6FoP7NAOGAUE2wylRptmaubaFD9o5RL3yCfElffu0CDaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mgqg7jv533EByceZHfSmVEnFe8pbA07e3o/tOscS54=;
 b=kUdpqfjkBAAzbDQlcZiiGcpXo63H4J3J9+CzG2+Xga9Htp8ts7ArC9Y2EWbyVIS/qoB79IfgnGIjx5a6i4+tmEiazA2Fu6pJBAzOnUlSa0u1Kh+Q//uaCcyEP4ls0FzPtcTj0ueU9TmeqdlDwub7dKj0la+hnE9M1h5Ak/JedTvr9gn3+OlAlBbYoN2H+zfe9cy94i1N8ly6wn/50oJhuaodMzAoqqsDasPpKPmlo+jDM25MPDmIfQJj0AzqUXYWyp3uE1bB4g590sct6itCmwvzPWxI8Bg2EET6RcFx1UsO3t2+JXlNMUEgIXGjh3QVW3C3jRnly/oP3k3zjZ8QXQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 19:18:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 19:18:21 +0000
Date: Thu, 28 Aug 2025 16:18:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 15/16] block-dma: properly take MMIO path
Message-ID: <20250828191820.GH7333@nvidia.com>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
 <aLBzeMNT3WOrjprC@kbusch-mbp>
 <20250828165427.GB10073@unreal>
 <aLCOqIaoaKUEOdeh@kbusch-mbp>
 <20250828184115.GE7333@nvidia.com>
 <aLCpqI-VQ7KeB6DL@kbusch-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLCpqI-VQ7KeB6DL@kbusch-mbp>
X-ClientProxiedBy: YT3PR01CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4483:EE_
X-MS-Office365-Filtering-Correlation-Id: 52013604-2e30-48de-7d56-08dde667a72b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tkzamAbH5/chdWZm3ke+JvfeqA3hIcFqXbx+r0hKEizINFNE62neCHrkqAKo?=
 =?us-ascii?Q?GQw1qGDwSs3TS+26QCrA6PZpWQTzbU7LKQ83Uk3UlOHPCCU5xsrzJujNvddd?=
 =?us-ascii?Q?OehQwAUTsfK303zab5MCQrE09VBsGUPilNO3T1aJNCEGxeTULuJSZ++yxYJl?=
 =?us-ascii?Q?FlgvgSF4OFzaaJgeeBlol1BfkrZ6JutsedecnGm4fadF5v5qKcKkWiSbYaJZ?=
 =?us-ascii?Q?Q7KjhQ6iuhaaGW/HzzlIcBryVYIb0zhXbiWM4yz4pdVBAHmsOWn6fPztT2xI?=
 =?us-ascii?Q?CgRX34Dd+L7XXIfkzThN7GixgLCdVKm/6H9auCcYq/eKzShWVUTsPEydphF0?=
 =?us-ascii?Q?hEK3AkzSkOoGpwwvg0FLHnLPk0TD00/jZFYa3uDjrMy5OulejmplpaRvV4V6?=
 =?us-ascii?Q?1NbZOuS4LbRXHz00PF7LNPB4tvbLwjY3oMDtREd6DhcoP/FkIIGOzeePZqqG?=
 =?us-ascii?Q?WkkGYvEVecOnHOOSSoW3JNtWVbVy4dGBpVsFLSE2uKt1GcFUimdOxlgnSWCT?=
 =?us-ascii?Q?n1sEZlVQvw0hj9aWIErVnvFGFktiZpBDhCD2fu3frqGLedE3pDmml7cC+ReI?=
 =?us-ascii?Q?cMsV0hImSgwvs8E/AnS50UBlUAyolgVsq6eH5ZH1jJOUragJUXshbOpfXba5?=
 =?us-ascii?Q?cPQhE4fwX4mLT7FjuHd84RtUJREUcfXJWWyXODHoCb1YzVEB0tBhPKDwq7cp?=
 =?us-ascii?Q?bySTSPdaFAusmpRom51YWvAmn6Hp/6NrJxjapCZW1yJrpVK+BMVN8gxGE5Cc?=
 =?us-ascii?Q?DZyKydvUnj16k6RLTbxAd1leamkUiJZDWOxq05NnolwwWkxjmqjFEu8F9P/D?=
 =?us-ascii?Q?cvMezD4FVJXuY8ceXcbif3j0PMPr3UQ7Eb1Rww7DEshvjDp7lq0FVtGrmYyx?=
 =?us-ascii?Q?Sc0Zw4f3m+YzB/F+367AXTigA5Te45yigKc+JeHBCMBmoxnKTLDaBZNr1sqA?=
 =?us-ascii?Q?ZmXloRKJjUp3ynhRIVRkYhTwGxSnnJdciu9/ZTrcceii17N/AEDJHfIKbOLT?=
 =?us-ascii?Q?/Hb9jteFnXzwUZmvAVv+0RB9OI+llcTWo9WTcTQ0e1eVKPAEJHe6Q/XtWOkc?=
 =?us-ascii?Q?OeEcZpGJdgTn/n84ku29rld2xou+WiWBYXA/H3vsJ1OTobb8aiJwPwbPxGtD?=
 =?us-ascii?Q?yaAffWzTS9fNe4HpURb4JmcRYfadnPNLI1BKTRyB3MspRKVn5YNcrYJpsdzB?=
 =?us-ascii?Q?6RXZrdUiV1cE4+kPAYl/AZ5U4TGPKYv46MdftVKtqd7hjHbCc1iMk6Q3PZ7C?=
 =?us-ascii?Q?E16vp2SHCkKZhX0qaRcMz7wlPlC2FtYSSrXBmsyKzcKZJLsu35FPtenmIy79?=
 =?us-ascii?Q?sE/+9vfZTDd5IuPwUz2p8tCwsmScDWcRlJ9fgzWu3Z6D/chLmAqP8VgcK8nw?=
 =?us-ascii?Q?G0RW1qpUFifPjZx5cixCprrw5GfKMKhHdzQbEFARFE5AhBor5h9+bECVAmYX?=
 =?us-ascii?Q?o5aUVOB9LeQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5ky7gd8aT6zgXZ3S9u2dQ9wfKPLFRzCut7RGugI01Pf4Eog4OrfHb36oULUM?=
 =?us-ascii?Q?lQvuNDmGms0FsQm7SQAbJXvnFC2FBGxUqSisCJWTxG1ACYv3V0xKN0dTF7SE?=
 =?us-ascii?Q?yZQUEEGvX5PoOXyQz2eNsEDzmPQObvhzReHlm0bxhkUjW56bHpTHH7EwuKBO?=
 =?us-ascii?Q?1/FD2o5bTIp/+kHebgvLj9elgC54ARBPQVtbai5ZtYiSiOOvGRzeSOfC+FtM?=
 =?us-ascii?Q?sQif8EXHeXuZlAXZ53QAbPOs8Xl11PauIjy0sbinkp+ArJVGXqXqQmd1zeCb?=
 =?us-ascii?Q?aXLppKpxeIoNIJR++6stE6QMJdsPMPgHyaQoSSUPKImjqz80YZi2wVie0n36?=
 =?us-ascii?Q?ZakI0sqTWwh5Rkjou+uZG6R2ADTmM48hr/zKeFcIl1Z7cYLpGMfccJWUKxXU?=
 =?us-ascii?Q?ZKQk44HnnxbvyW57MXYfjwxhrjSUmIRVldoky0tEKDSJfzTLziPOy3V5OyYi?=
 =?us-ascii?Q?sXOVBCWqmMb55IAzG5VxU90BGilWh4lthyWGVDyN4c+JJpn/DzUNkbIgOEt5?=
 =?us-ascii?Q?wtmLF6Mt+eoEZ5njkBtUAbfPU44Iwat3iOLVTJIVf/WS5gwHMC5EoOHv5H97?=
 =?us-ascii?Q?gUB9BJfHfcY6sDZw6mXn857jfuIABDcet8nLyDqr18sdyk764gI31BdGI4NV?=
 =?us-ascii?Q?oVBrIahCpllgByOuio4OUUlrjXx6LrGXn22qthTjwS2vnK36xgjlfurJKFoy?=
 =?us-ascii?Q?+yOdBxt5KD2hw8/SdbYNDXrsZkF/SynBCKk8fHB9K5nBDDP/evgule554rpj?=
 =?us-ascii?Q?3sMnqD5o78y7mOIP9EUfi4YsWNAhib6Pb9LoBFt5ChmCISM9//zhPKSil2Ux?=
 =?us-ascii?Q?smPk9BeuFpSkfasaiNlnuJ/5NkmprQafGR0xa44/6Q40vIKgDIzWsFKSDd6+?=
 =?us-ascii?Q?oO6J1DfbJz7fGz2bwXX0/GqrLCuVj9V0oowgXGDa5aCN0S3DFSGmc2EkQxfl?=
 =?us-ascii?Q?UllYeNA7AM+ttA0/FbHgkD7h9actDtyrlsBNKtBS1L/JfLRTUlNGBbj4XHVU?=
 =?us-ascii?Q?9u1l4DuMFLq3GivCBp1rZOd2os/O4iAvukZ422zqAuYLSQu8BSExUTOEvtiR?=
 =?us-ascii?Q?39g9mSg3Z535dtWBdo4nP32e4AHmvrQe2SLI/1Zz0FD2CbGwSGZuW0DtQM+A?=
 =?us-ascii?Q?frdJNMjWVCbo7AxfwIFSPhy5G3IOVygXoRBQ4V04M0wfBpTVJ4KqK3pgULAQ?=
 =?us-ascii?Q?0CL7r6hi5Fl0+yoNYyD1Ohwow+fi/3TGY8RJtNHC9AetvMra5ckKM6cRuotU?=
 =?us-ascii?Q?wLKR80vFplmKVrRTjgMQCVUSMQ5eTRZ1qaPH3k8Up+5Hx0c+oSmZCcN7tQOY?=
 =?us-ascii?Q?2/cN3Gj6XPil0H1Ik+KhKjq0rJ9o49M7L9fITJUQ31uMPDEn3Ymg5H5Z+YLl?=
 =?us-ascii?Q?PvRGSfqJwpB3FJmweuifLM1Ek+W5g4JGeM0xcWzd5hCEZHYIGbt4JuyRm2Rb?=
 =?us-ascii?Q?84vjpS3yma0Dv0io44RAe1eO3CHnVzinSkzulYRLZvA7PgTCrAG+JR18Tgtb?=
 =?us-ascii?Q?/xJj0RtMfBIYhpyZblffBKIRpMl7noh10yYTlcjabPOIoXVPPHSpPkM6n+R4?=
 =?us-ascii?Q?vIw0P2IDKKahN6lpEoM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52013604-2e30-48de-7d56-08dde667a72b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 19:18:21.9042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHBOMGpozkeIevL9wLHwQhy2eRzFmZhbRTFbZweAUasp+caHeKpopNq0/07EWPc1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5249720006
X-Stat-Signature: iwt7cspe6dxddefzxbnb6udebde7g8bx
X-Rspam-User: 
X-HE-Tag: 1756408710-523675
X-HE-Meta: U2FsdGVkX1/Rp/BFJpLOTbuvBGMri9K/er9cdn91c4p7Ecuw58uCab6eHyWyhUy8fNGJ9gSeDQByz/6gYmKeoLftO8iAiVOYr7vh5TMxCIJYVPFt9EiINnXQf11IGECxHND/IL9i9QJytFq7UDHolwyp4EhE9WetJdToZlHDXclx2pPsLtzmatRtxFDfIm7L6//bL5tNBCV+4WFz7xtMjUBps5skjWst9rLlRMBQ1wT2RtlD8mIIxhgzW5y594K189V+oH0JfiO4M1w1hq3NvL+JmK6TD0TNTwoCnlWzZo+qspGKYQf6EBo6KuqdyedqKruD5tWyn06YBAooR+DCRzuoeFvn85N22W23GACVPOe29NxMF0OM8ONipZsD87m9oowM5X/9BJRuSTl8bS/b0wsgQGCy4OaYIPxMFbdWxarAVzOg03n2diS2Pzm+Dg8ZHQ/f7oBW78uO/3nypGD10nBsJUrQ9+HKx/IQR4O2DR/yMw/FCnAFL2LHkHRRAuVK+a7OlqRgIhSfsQYFlBf8m/1ghaHAExtCTFev4RZQM8S72dpvt84OqksrzNq9pFzloFzF8rrY4lFT/c3sQguWFUUGZwE1+PrISjk7b9yRU1gl0Sq7iQLXagX3sY4n4oNbCICCWBROM94yMZdj5AyWXd1GSVIjQN+MXPM5Ijxv3LGFU8PKHcsR4tt8ERTo023dUz/vVayE+o8i8sVXPSOfBTdXV6rDI9q9/5KcNYZqNfCAVlPAym9rGmlv46RvGiFn5jvWYVFDXOQj0boW9geUYqZygSri2EY/s9VV5B1duc1ew2rTmC7F5+FWOrVgYDi5uiJ8lNNpZT3wub27NJLXSRrl/eqA9GnxmA1NBbfeO3SI9XA+L1dtxF1Y/KQ8BCovDAMD0JvBTBX87VV1c5/Jpx+UoX4fV5g2oIWjX9mWYdKqhnHSKM96GXNOXuDP2z/K/KiUD5jbsRi526j6kGJ
 jlY18JNn
 X2AJoC6NmTdLmVPmkPFHPulH/saewWOMYXX4wwFitauadzYvq2GG211PGtmGtNu8ZtGzHezKYA7Hc/y5yN2IjDgQ87ZvtT/Kt8sZXTnWJkQ+Qf/vwPN1V7JnOBfYrxsOGWaqvfR/vjvG3HInFU/hYnj3WENU+ZIFKZWvlNgA+UJ/SXTnxVyvy5/ATd4PQoCdd1Inc7J42Pp0SP+TFsnUaz19dWK4pu7zQtU6aTrfFNVBfKDMV9T1pVuJwrxQB2GI4c5VWBVz+X4hwfIVxZR1oYyLPzEZyPT2Jr8X4NPauYuOa65pbBdinXzQlpFEnBT+EmkweMaTW7R/BqUynWR65pO6zXHoiq5tfOMYL5XMCB9NcazUaJjBc90NBGk0qz9skJfYwL3nEhQbvC7kMUdyesFT9ohSHpAFHQ0srujwXJsAHg6jTpEbomghmLTuheM0sm4ultwlp5O+QBGhQ+nXPDfEylhC0Rrc9UlkQppxOIuAspkz2u9YwZ9YgNa88QMDVrtSzIINdzu7KSKk++My2p3DdJH2KQvxmo4RykO1jeC/V9h4X8Rro0Kho4YV0yi2jcnuJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 01:10:32PM -0600, Keith Busch wrote:
> On Thu, Aug 28, 2025 at 03:41:15PM -0300, Jason Gunthorpe wrote:
> > On Thu, Aug 28, 2025 at 11:15:20AM -0600, Keith Busch wrote:
> > > 
> > > I don't think that was ever the case. Metadata is allocated
> > > independently of the data payload, usually by the kernel in
> > > bio_integrity_prep() just before dispatching the request. The bio may
> > > have a p2p data payload, but the integrity metadata is just a kmalloc
> > > buf in that path.
> > 
> > Then you should do two dma mapping operations today, that is how the
> > API was built. You shouldn't mix P2P and non P2P within a single
> > operation right now..
> 
> Data and metadata are mapped as separate operations. They're just
> different parts of one blk-mq request.

In that case the new bit leon proposes should only be used for the
unmap of the data pages and the metadata unmap should always be
unmapped as CPU?

Jason

