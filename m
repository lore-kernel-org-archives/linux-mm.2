Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05FDAFD0047
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 19:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DC66B00B6; Sun,  1 Mar 2026 14:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB5A6B00B7; Sun,  1 Mar 2026 14:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D646B00B8; Sun,  1 Mar 2026 14:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9AF26B00B6
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 14:14:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9030DBADC8
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:14:26 +0000 (UTC)
X-FDA: 84498445332.09.8521DC8
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9727D80003
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 19:14:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RkI3T2e+;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772392463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPyjmujpofD3jpHT46935+mfJWcwox3E0goTpqhU++o=;
	b=pus7HI6i6pRjhUTSpgHzIyrPQw8jeK0ABQowSP7pZ/y0IU9ePltqolTkdRcJOc+b5f46zg
	NUeLgyNDeqAj3Y0uBLPZUYPttl5x5U9gy6hbi2t8t/QvuRvzuMqZ25f2H7gMFjhyQyrJrk
	UsAqG8F6rBUV4kt4IcbpWr4p61uaYiI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RkI3T2e+;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.24 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772392463; a=rsa-sha256;
	cv=pass;
	b=mM7PtRUE12UsGmA5+k9DtErJw0c2OCZLvv0Hq9l+GyKYNMGI6kjZHxrvl82/DLEnp6jk4z
	J0AqZf0FJqog6Cfw3YTJkrWh1pyG+SOO9d7CcYst8MNmf+0nm2MA28a2l3F88uZyMrxJ/K
	ZhqhK2gsaY+aBkF0LsxvOp7ji8zvBx0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yMt0Af2QUM4o0e+hdpuAWvvrsNcBRoXQNzh1m168BDrjS2WxaJhSDadtoYAdUAofOXrT/0iVOlA8dXOjjKJqYcyUACZ1oot044B4MXARkJmy58v9834PSxvoZ/qeHOlJ0JL+EM9jTSjSdrUnUM+dRxOZnBnpAzhsi+WnBhTwoN1cM1HMzf6BJO+KBt7dD2aB2Y0Uk2WgpH88BO92YlnjQ5SZhlWmd/bTSc0Ut+nia3ZPrVRxx3rtjgKYefIY12Gx0KWm7Gi+JbrCE5KDXBcpkNtVfyFVqk715F9gByIg/tKTFCuFb8j7IGS765m/3D6PqUU6T/EfKapCHka+83PMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPyjmujpofD3jpHT46935+mfJWcwox3E0goTpqhU++o=;
 b=HJ2Far3pAB1sJZo7x5WbHQLVvxYWV2hayhA5uO+aJfVKIqhp49Vo4fYB8O0EUvNwVLggT2uBRZTZ0IQXaUDGrxxReAg8CkmCKRRGpaRMZIUNQh3ORhSHPSAXulkbcnrEgF2mxZ616Z9TNJIWP+NMTz6zbuL7NAxfFpfgXTJ3fZJaVRTGLrY61w0Sb1fP+PvLq9Z+gNtBDUVsDWDe0a0RyIRhqs3G+eVUVGZ16kdbxwcfMYOS7s71nV9Zu2f2T6AKcufUl1rXVMeMD0zLcDUiKz+2+sOiqDeeOuLEiZpzPfydHRyhkbEZh8L4AfvZpNRrGEJvVP7UrJpPrI5UaGjwyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPyjmujpofD3jpHT46935+mfJWcwox3E0goTpqhU++o=;
 b=RkI3T2e+VSLSnhxcevE2cipJQNzg5Iz2RBE5hykMFm5yeNT00gdy+gkFTFWcU+aPDiOFCpGPTAc9Pb/+zB9VGEkbIwckxhTYlZqKNQxydSKfuPYFGZZm6ckRREyf5joI5goSU6/DZ5olAHePf1DrGOqHB4B7KEvO2BdNr0C3gqo9BG3Tsd2BdKNhyLH/TFSR3Jdp6qDCwDulHs4RwzJXP44j9g5XCMnAH5+a94pkl9EAbVCYK+uDrLOZO4l5rDVGEwJad2+KCOoSAieJJKn78YtR5tkiplbsH+WrWJLaSvaXjxm60ANfY6aEVE7SLMmF7IJCdDyhsBwCAp0TI6qOgg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL3PR12MB6524.namprd12.prod.outlook.com (2603:10b6:208:38c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sun, 1 Mar
 2026 19:14:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Sun, 1 Mar 2026
 19:14:16 +0000
Date: Sun, 1 Mar 2026 15:14:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260301191414.GO5933@nvidia.com>
References: <20260129212510.967611-3-dmatlack@google.com>
 <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com>
 <20260227093233.45891424@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227093233.45891424@shazbot.org>
X-ClientProxiedBy: BL1PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL3PR12MB6524:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a50b0d9-c18f-4659-acf4-08de77c6bad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	teIeqMr5ernaSH2fpQcgAeRIaC2NQL1PRAxoMrnOXEiWeQj8GfAu5xXVTUxWjVJEF6eFaPEHwfoXosVmpRSL7ItlwyJLWlRPOdnW2wKmpi3c9/aX4I74s9qxCr4UA/BZvDchTu2SYojG8X+8HLrD2PILGt/gSx88VyHbl6xTpzW6/X5RmMf+EUh5J7s1hB+HtgyOK6vdOB7QnXxvCpgDimaf1ITaDkGrTE4khEH1xcTgMTeWPHV+peY0md3Nmdld57pt4MXxXV/hwNQvaByjStWYiBAcsxB2ODygEJYxwxwxmJbxP8oOTysMCoPo3RSmiMAs+tjbXrOj4U0H2sPcCJ8ICpkj3N2vxPOOQ+akpm+brPunrmh5frffsFqm24H3P3CGDc6t8PTrXH7SSti9bTXDeAQJ8ByhIht2n6D18UVOWkzSdrEE1zuJ0Z+hzB7WUTIYYHdG7p0fXukVE8q1YZXjW7ycUx7Hqy6sx5joyWJZZLzsQBt1Kkt6v+dXGEKgEw6Cgg0mePOqJlLpROpIz9WzkCfmtRU4pVjFcMz37/EsQjZxv4hWTowyGM7IGFusexygn1DqHkEpFtyZBGU9Z/Hkr0BjfDRqN9H48DsAlSXwQJ5RsYCZTY8WmyFOiEHe60P0PuWIs+AL70PGh5EgKUDOFzueYQky7qhyfiv0SfkxkItA/QaxFkG82JtE5euNYyV65NPqWCj9BraEigWHmBhYFL1Xc1W6aYraQN/wYb4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QbKAD31y4kwpj5brPQL9dAVbpmGVtAEV76bVLe5Nmo6AVXSrZLV+bX2654yZ?=
 =?us-ascii?Q?CQ7o2LLKamIQhba92NQV4UjJiJwphfsl1bRmkDEPPAxdb/FkbMIqanjA9GPs?=
 =?us-ascii?Q?tcYnSZSG7grPQiBPM3D2ne0LfdyTxxDP78V93phvLtfDPVwnG9z/Kevyz/Q8?=
 =?us-ascii?Q?/6Gv6XrRUGSLNDQBigCyAulvnzoc1xiP/o0tGuRgcHr2fP3cUB84jPBhQrCT?=
 =?us-ascii?Q?F2cjxivfd7ZIzn8fsBMShEKDi0Ispemmle3ug93HWWUks03+g/FccH88f03R?=
 =?us-ascii?Q?FzdwfX1UEOjUB0qmGlxP/6Hzx4m8l/rTj/6MILULLrLtRcDa+HhvWvJRqkGt?=
 =?us-ascii?Q?uT8B+V4VjSpIVC4vVH+uBOJ2nEs80zKGLIDFQXy5/Q0IKD9beg9dYhws6vz+?=
 =?us-ascii?Q?TSIX1A+LI5JKd0pLvUPsPLbAQonORUaYZfWMlOGirU0Ye1ClfVGOmBpFZVq6?=
 =?us-ascii?Q?9NTq06Ty/z3LZhsBapFuZ/4NNMeVomzXzY0tJxV5xo2LMjz9FQKdgwnvvygQ?=
 =?us-ascii?Q?THn5+619imvJqH0pKVGFBez4nk04qeb7SIFBeUfNA+jv01FmqidhRmJdIy0f?=
 =?us-ascii?Q?CP5NWzYhcu0bKs+mD/Ljzg+ovToMlWmobhXFjX/k8lW/vwnvc+ep/FjQItkO?=
 =?us-ascii?Q?zGr8nhnavGdKBMgBGYpccWQrksmuHshvSSCjUqn3Jy7IphGI0a+vwpG2e1I0?=
 =?us-ascii?Q?qY2k3OocEjshSVGY6fog77JYAH9lWehi98J90zfZz2XfL2Y5t74zDWqur+bd?=
 =?us-ascii?Q?sJXbla7BD4den6QGWFecjt+Uf8ywnz51ouh6bqWYG8F7h4g65c+2NKvis9uX?=
 =?us-ascii?Q?U73RierkyFXx14Js5HkbiZu12Zlv3DgA0bilhMtM+EanxfIJ2jaw7kNiB5tb?=
 =?us-ascii?Q?Qbp0SDXabBy7AQo0gfKmGZGb34gIqHPOBwL5vgCGFgHjwBDOfEk3QBJoH5wh?=
 =?us-ascii?Q?nTOuCr4kDbLvuPX+jaLIc4vP2rUzTm60KvnsDv10tCrWZd0oeH1eb6G9lBQJ?=
 =?us-ascii?Q?p1nWsJwCUai9WqrwENt7Mt+/19KgmqCHhlYDSdP27QZZu0IOEDvtLem/QoaY?=
 =?us-ascii?Q?lLYE02tcbjQqZ4MZ+/aSVd4db/gy59T8lz5820omgNfD9isi0tMhY/tMQm8f?=
 =?us-ascii?Q?aJWYrEVHUKVzSPq6yZcc2fbzGup0X7s7DroNjNF3e93r/67CMVvxyQsEzYYv?=
 =?us-ascii?Q?d6p8wvB5fWVIYC25vssluW+rQgO3hFWK4SLayhhiucik46BPqsSbqfrJwNnc?=
 =?us-ascii?Q?+d2WaDIpQ6hLhvh/Ersd68msr9XTPcHZ/Ln72C2qRbt+zpkdZDlAR8LKLe1e?=
 =?us-ascii?Q?kZdLtp4uJop6CzVhcWKza/xrBz61jPfdWkaV/Ai5Vs3KdrzxTRAcNyFFEX+r?=
 =?us-ascii?Q?BtAY+bvktx6mc8ZfHFiJJpvedSscVhasg6EBSp0A6c2pAM2Uvt4OvL9hY+Ko?=
 =?us-ascii?Q?DGgIwIL27f74vDARJMDu3tZmaruK1zbW4gq3sKs31w+nvKuBwyPKjsIUuISd?=
 =?us-ascii?Q?89rn+aEQZfaCygP/btdnlnKgrTY2ohRWKWXGeKwRP7GWcXTGSuI6UklcaIlT?=
 =?us-ascii?Q?ebm9a9Y7jAP/dKew7dCzOX4r2L6RvBm30nfv4U5UMOORtG3h8N4jhjRxNz2/?=
 =?us-ascii?Q?vf8z8SSB2uELi6VRh9l5fsKfrJRVebSm0oL5FG7HtZuF7XuSd+YBdP0Vh6JZ?=
 =?us-ascii?Q?bvwbNev3UStQAWlp2LR/Neu0/nohE1dP92sLIHexoJVrHNfs6w+nSdsEHHCt?=
 =?us-ascii?Q?fOLVrxylGg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a50b0d9-c18f-4659-acf4-08de77c6bad3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 19:14:15.7689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5kM8zkpqi0F7rTNdLz2qXNc7yyQjgmnTqqRoL4UcuNovvqfdmAYDDOjiQOZvzR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6524
X-Stat-Signature: jthf1mt4g7rhqwmroqim4q7kmht8bapx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9727D80003
X-HE-Tag: 1772392463-800558
X-HE-Meta: U2FsdGVkX18szQDZOiAqH+hXG7I+7UIKzyS8BjGtWUhv1tVYXYWx9wRDoLDXvvxkME9h515pvNJPugYLl7iFn4caDRlTfaQt9ixNmsdOV67KE5YkA9ZtL6M4d136xMQwF94oTrxNxcOi/siyU/DYINQCLHwnQiBlN9nHpLQC/SN0qdYkdkYWG/GpBn1GSR07k1R0LKfWmi6Uz+5ASbIFht7CswQMYVCf7jajVLY4LBMQqocNsm0xwwGkhmErUwxe9miR+DbKa26f+1Jt3CyWeMFX6QUCSb/86NmkW1DR35dceukR/Qu3lz5H4XSklpeKOTr3VSRu9eWghywmGS0AbMrx6RpBxiOJIYBDK/9AW6lPy7XUdirPXVO2R9/O8U7QXvNsM5dmPaozEFgazRd6gBtUWm3qbbTVByiB2Fya+vmGFcstRdCvFIq9Y7gYzHYF5IMoFRmxdwhkcEQLI9u5MrHMBFL4RLTA9gLje2Od7ziYQSPSF3xcjihTNGeDDIs0UE4a+Z/1/WftAVhIcw/MHuWJenhW7v4VF5IghWa3EWF6o9Z60YvPUZ1OICmLZja9OjWcFPF0Y8cUZJ7uNduSHVOXUECFaDI97EfiIqqgP9tGOFV4+TRLGen5jlJmvCfuEj+ve+7+bLnGvvpi/Z/s6BniJyeVDrXaVFjU0GWLVNveoiPb4YfWmzUWBnGDr6Zk+fAqXoedJ9A5Gz/tX08DOinhgdIvrgLnSJXQpx7FA3s58h8jbN9B8j+TEi9MhX839kG13cEOeGaQ4wVtwoP4VAycNzCwhjaaXvzh1g5xfJtIVr6G1iD45NI+24uMthopUGQgdJQ7piIDrU1iXsdWWkm3gNLHTXjdDP/xz14qOzEUjvvCFR7boEixyasCcGHGmzFG3cs7+48jdpD1neSkX0w5HPMhSSn8uDoydovfu9vFvDRftm4iwfrPnkjQv/6qDB+iwo/YqZh2VVeM07q
 19j/FmD1
 lVrX03MRPd4Vfunq53ye9KT6GW/z+Xs9RObw0Qiqfh6IPJOzjlipbiKCXqktePPhGXId4YUId+8q0ST7l8YF7r178CZvZb0WUKne53x5//KLC3Qf30rgs5c3odtJa/y/z06dXkisHD/utTJfo9AQmTb2AMYYHmijfoqXGnEckcCiY9UvAav3wH6iklc9Jrn3JRNWabLgcZnIJRYuqcxc72PWLiLjAvKiVae9LrTYlUf207xdpGgBUcRGbZl0/S3hHlwFVHyciEg7yO2Kq7sblhKD6wbnN45myW5CXSuaZjQ+IiWe6enI9PrG16kctMbvOYC/eGOBnWe2cvVt8eEqUqmQdFyoEnJZSBncbRuQ7H21S7CmUqZ6IVzbqGaI/1IxvzlaX8ig5GtIDPYPuFfQxzlMJvN2doP0QHVMUNrveLwjnSHw8iI0Zy9/PsJSge8/MKWQtA/PprxoLbRHa8vBcBlkgRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:32:33AM -0700, Alex Williamson wrote:
> On Thu, 26 Feb 2026 00:28:28 +0000
> David Matlack <dmatlack@google.com> wrote:
> > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > > +{
> > > > +	struct pci_dev *dev = NULL;
> > > > +	int max_nr_devices = 0;
> > > > +	struct pci_ser *ser;
> > > > +	unsigned long size;
> > > > +
> > > > +	for_each_pci_dev(dev)
> > > > +		max_nr_devices++;  
> > > 
> > > How is this protected against hotplug?  
> > 
> > Pranjal raised this as well. Here was my reply:
> > 
> > .  Yes, it's possible to run out space to preserve devices if devices are
> > .  hot-plugged and then preserved. But I think it's better to defer
> > .  handling such a use-case exists (unless you see an obvious simple
> > .  solution). So far I am not seeing preserving hot-plugged devices
> > .  across Live Update as a high priority use-case to support.
> > 
> > I am going to add a comment here in the next revision to clarify that.
> > I will also add a comment clarifying why this code doesn't bother to
> > account for VFs created after this call (preserving VFs are explicitly
> > disallowed to be preserved in this patch since they require additional
> > support).
> 
> TBH, without SR-IOV support and some examples of in-kernel PF
> preservation in support of vfio-pci VFs, it seems like this only
> supports a very niche use case. 

Well, this is a super complex problem overall and it has to start
someplace digestible. There are real use cases of PF only devices,
like GPUs for example, where this is entirely sufficient even without
SRIOV support.

I expect a long trickle of series building on an enhacing this
mechanism one brick at a time.

> I expect the majority of vfio-pci devices are VFs and I don't think
> we want to present a solution where the requirement is to move the
> PF driver to userspace.  

Well, I do, and am strongly advocating for this. As all these series
show supporting live update in a kernel driver is fiendishly complex
and most kernel drivers do more than just some bare minimum to operate
a PF for SRIOV.

Given we already have PF drivers in userspace and that is working
well, lets start there. If people really want to tackle the nasty
problems of a kernel side PF driver then they can go do that as a
followup.

> It's not clear, for example, how we can have vfio-pci variant
> drivers relying on in-kernel channels to PF drivers to support
> migration in this model.  Thanks,

Probably not without tremendous work to make the PF driver side
kexecable.

The initial use cases for this don't include VFIO migration, I think
you could say people are interested in this significantly because VFIO
migration isn't viable in the devices they want to use..

Sure it would be nice, but again, lets focus on the basic simple
cases, nothing precludes building more and more complexity into the
kernel to preserve more and more state across the kexec down the road.

Jason

