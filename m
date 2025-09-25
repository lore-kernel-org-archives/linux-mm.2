Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED6FCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 11:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F43A8E0008; Thu, 25 Sep 2025 07:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD0B8E0001; Thu, 25 Sep 2025 07:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BADD8E0008; Thu, 25 Sep 2025 07:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEA3B8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:53:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A89913A8D4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:53:16 +0000 (UTC)
X-FDA: 83927611992.20.058AA15
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id CEC4340003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:53:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PzxRpVFS;
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.11 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758801194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QODKn9Ui+ltheYIHWDWac1wskQ/Yw/qpqIVGllIqi/E=;
	b=YqeifhDY0mKHTv6Jz41tEcESFrErMRj4eAWrM5NGEnnxzggzoBG13visYoAJo1+sxSxy/3
	uScjFl6zDsl1XEnb6SYUD4w6anb2XnJbH0NLL1TVjAtvbB1ajoFvIP/TDXbX1Y7/3WwSRw
	+YPR8CeUIy52DeDD0lE55lZi9LbEbxA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758801194; a=rsa-sha256;
	cv=pass;
	b=IKcC8+0VIy7PVfRJaNN3MNA2v9DetxFMUOvrgSO6z4yk7WypXdt1/ml949wDglw8wQrio/
	Je7CAXvtUHLINSfcJGoqHK2OW+Hanj+JMIqOkbodBr/42J4MuEYaW5hR0xPP6EVYlAaoq+
	GXtShhgnUIS9VIa9Fih2GLbV/oaBtyE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PzxRpVFS;
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.11 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=egii8MpGSPZHZ9cxM1fHyHN8mn6+quqIquH/K6lrg1zEfUldNoHyzOVPPn07vwC+0xTiLsmKiFE1pXc+UhU+oBywOpzOam0pSuxbtsEw6mXRsYqrAevwMhsTx/5rmajd4LVx8CL1b1a+rFLpW8SJmam2/19uw6/D1i/JEUYGLjZaKykZKkR4J+B5lkbLwiR0kzeLXxNNSVdHhYhXW5bOadqIMWJYTTE10oRlAdvKTr8lmo/h5hQZJN2qptMHb2gAEO5JCQNsyTiuNygTzsm6+6z3YRgz8zHUCA1ENBREmQ3Co+jSz6e0tad686iC7uoI0TnXxSo3sbdSIC0jI9J2TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QODKn9Ui+ltheYIHWDWac1wskQ/Yw/qpqIVGllIqi/E=;
 b=NIkJwtaBSHVtD8OpT4qQBkB4H1k9vDt/FDzngMkisylgJdrleMZQgfE/EnYfqYGICsIoLyfX5v/r9wAqOSbIY6qrjnEeKYtfUqhSiMbXwmBYxQvL3z83StwFfgznOaD4pyQk7242J36sFlysyYaB5MNWsJFCWm1+Jc77QmDlRF4WMrqPx2pThTu198KdloZM4n93XME606dYn3SXslxAak2mQasU4bpuDDxvvwQQqGkSihHmVWRcZKijEIy1vH23YZcjRm9UT5gt6FNmHpz7XepxTH5tNXw1JFXzxK8b31ILnfSQSwiezckRuaaDGXse3I6at2HUOu8gDfgsuaCl8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QODKn9Ui+ltheYIHWDWac1wskQ/Yw/qpqIVGllIqi/E=;
 b=PzxRpVFSn7daxkuBM45CbgmQ92VUwdudqOgCJfhdL4cwcrtiNhkYBzov6W93P7ePZAUMvsOM4Aw36eJjC+H3yeo8rZvSf4PglU0VJykjGptDcFhFqdoMjD4wsZPdToRudSf0i/s2jkTdoBvZvex/nyjNGe17v8CMM3wvXaSYz2180BuV21HdO2MbZHbsvHMRGRvjSnqcDA46gsgiG9kZ73Np+6W1+GTrWh5Ig3rulP2urqjynRJSPa0wLZCODG/083AuExm57bE3GpJuJIOesRherKapoCdOBArcYm4gf24lqKIrt+fok1eyX/GfMLZP0t9szWWbtR34KAj7gtdu8g==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6751.namprd12.prod.outlook.com (2603:10b6:806:258::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 11:53:09 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Thu, 25 Sep 2025
 11:53:09 +0000
Date: Thu, 25 Sep 2025 08:53:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250925115308.GT2617119@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
 <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
 <20250922150032.3e3da410.alex.williamson@redhat.com>
 <20250923150414.GA2608121@nvidia.com>
 <20250923113041.38bee711.alex.williamson@redhat.com>
 <20250923174333.GE2608121@nvidia.com>
 <20250923120932.47df57b2.alex.williamson@redhat.com>
 <20250925070314.GA12165@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925070314.GA12165@unreal>
X-ClientProxiedBy: SA1P222CA0161.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::9) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: ce458c94-657e-4a56-d013-08ddfc2a190f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pSgVEb8b6KvWO/8Kh+G0nNdWEIpSJtu2flhAl93INC79YkRIQ/i6SqWK/KDB?=
 =?us-ascii?Q?ib/RhJ0vjlXF66NRxN/kD09tPom/MRumuHrsD9r7kNqKgxW787OD4QS+oJpa?=
 =?us-ascii?Q?gwOKITSQaL2rccHRQwilNUmuJKXTA6Paf57x4Ccyz74DLdky1qNa/NnUA4+r?=
 =?us-ascii?Q?+12DzVfURLWkRqhNpffLGMnlJxVMaN30fJ4JJWgSoMsBifVpAkLjy2o09/rO?=
 =?us-ascii?Q?ZWi1n6OLhynK9X7VqxTR36PSD/u37oVn7/h9ZYf5dCzZgSdUKN3W6amsVZ04?=
 =?us-ascii?Q?gYG6Su0O4BkBZ8vV5GxtdDFpI3gqtFNbdHS2KwCjo+MjqvbZZ4q+KgqiihTR?=
 =?us-ascii?Q?5uzMZ2yyP8JfoG6mLuMOWOJmTiQboRXqduO3LzeTCsB7ghbbn8BxQEqYjwXe?=
 =?us-ascii?Q?JEEuyCQ6wa521ykEFeraq+lU72FYymt8ZVO9vKK9Ck7UPl6mf8EewqfyxRr7?=
 =?us-ascii?Q?QAIqryontd5LRyRbCE2Cca5pg0pMVJuvejRWsEg0lB5lXWLWERdYJefq/5qh?=
 =?us-ascii?Q?6yX1xfuKr9VphRe29XRZn9UEvitvK5gxkum4r38y+AMJZIDKMWC1/QC/o+lO?=
 =?us-ascii?Q?C0u8m1p5x6Z0QirgQhKUAgV7Ys5uoADlLTR7RUJpFbifNCwSnupjAPq2Zy2Y?=
 =?us-ascii?Q?Ez/6C4RJTnsRp4iHwGnAjZd1lTnYQZ/PBAXGz8p1DTOln3XzCX5rD47Z2xpX?=
 =?us-ascii?Q?qJCZ6FCU0RjbNI7St1wbPHcnJDr6Y8kYbLNZBS8+fldOIW2InDr+RW2yywdc?=
 =?us-ascii?Q?2EzXJAvusKWrgPCq7nnroktNG3XrdLbPjLuYQAB/E35v7U+Y3poG+fdjTtT6?=
 =?us-ascii?Q?De3wtSrgDAyzQhwnx9V1GyW+2LCPlS40Jf+axTrDOB1J7Fomihnk9D1+4Wql?=
 =?us-ascii?Q?Cg/huC0VSSnDdsw37gAoDIRTgN2Z701kWp9tejz236AoPQGlg1hNgcVJLw4p?=
 =?us-ascii?Q?/pcooPB3PQFj/Dpfuozk81LHJoROyi9/TlpbWhbSQADuwjbrEjTTOMtI9mRS?=
 =?us-ascii?Q?FvwmkuNCZNip6azzIQO4+hP6s/h7+vroRNnNjU0T1aYAQj8B0Udu2b+0C7Zv?=
 =?us-ascii?Q?RXBJxzQSojLypCoeVwHd3BBzEbSya1dtnrUheBNsyMekomGXeG3I+XRlRncd?=
 =?us-ascii?Q?66gKaflBsAq4Mca5jZbw0JTm5kZcAkijmfVxwuVYtVL8XgQUjhDYRGpeTEi/?=
 =?us-ascii?Q?YWTrojBCYlXUM/bVyjH0jQDpYQgs1crc1rBkGq3WicLAku4IgwwnYaIpK7Lq?=
 =?us-ascii?Q?X8kuXRNefkBmxhmobsvVFDnlnKK+o3i5E8RmQAO6XFW+C29kSR/CsaNHizWz?=
 =?us-ascii?Q?lcGnlFG3IXzQDQLiFr/1mtL982BdPFpd6J8j0eNIaIrUnZwl98VHHqNTjVns?=
 =?us-ascii?Q?QePNazHNEE9dATL4xTCGPWTpA7AcbhQ1LKNl+E6IlQx8WYgKk0zWpDG46WTC?=
 =?us-ascii?Q?3LCFmbV5oKI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i8fxwWWeHXe45Gc/7Fui0+yPn3NmkmmYud+HtG1HqNOg7cBRcTQPB5CDcsl6?=
 =?us-ascii?Q?hDheSTsI3UV81vhhzN4XuTl2RW0xLrFimwgRlEUMf1FIAcTAa/bVRugNVHAA?=
 =?us-ascii?Q?i5T4MmJqHv7vSkUEnuzwE0MQRFPYRx5d71RP6l581FObqH/tiTrXChsq3MPU?=
 =?us-ascii?Q?4kgkLoWSq7D04M9zs6BYNhyieGQV6jsjZDTcd0BGw7FEHYTS03rhIl40SXSO?=
 =?us-ascii?Q?NQ+oRru1PzwExWsRwEhOeDCjD2dI842os448QINVGNEyMw9GwtRNO9mqibWv?=
 =?us-ascii?Q?Xgpe7g4rYPG3v80LfenictE/PY/dHUzzZK+NRCTWCJsOfIaK0tYlbXssgASb?=
 =?us-ascii?Q?4om9WKg2IJufl6a4GCiW4A9JcDRIUH85rHeW4TT4BaGzxNJi5oD4AUcmVjyW?=
 =?us-ascii?Q?rZjh1rhIXrRj8dIpnYNl+CYX/cUJ9eEBCQ4h6yp7cq940YQlxNiz73CPppCw?=
 =?us-ascii?Q?Cuuyx/LAWgbeahsoiXDuKR7dHmIExLUgJAE394dip/33H2g91XiwQRrHDbpl?=
 =?us-ascii?Q?mU4RCsFQDLLtSD2DRXvmODX1GxeU3PKyr0BZ6bQ/wfQQBr9KvWdh1nKII4WL?=
 =?us-ascii?Q?OCtXZc8C/sBwsjVn6TBBJf22mEni2mYmNaXvuf2ljorQdfJ7kaaOKlG7HdIX?=
 =?us-ascii?Q?tKoDj3p3cZyoQ4gfq4y5/aHedx0VjNqo0bE1rDyvSyhLG4j+wEMA1JlIHXje?=
 =?us-ascii?Q?UtkHLhtJYy2NYVQeAX6z7JYMLPc1lHEppD3oGF2zTdizTXxFVuiXps9bcO+P?=
 =?us-ascii?Q?6+aEoBgzXranD9eEaigPcv7/WWO4C0ZEBl7Y8kQ1fWwRIf92NVDlm/zpNlmd?=
 =?us-ascii?Q?TiGpiHq3jHoKCtbv4ia30l5HXLWOX5YSKDa1y2jmu0k92ziqpm9y8krjttaB?=
 =?us-ascii?Q?rqyyAFl+WyvzzyGgjsknz2o1s2xb5RR185Nnl0BEE+lmpl7eHUV1BSjtJQXa?=
 =?us-ascii?Q?Pz+jdbVQqqsVqTCcvCFhez95vuO4DrsuDoz+sSl8zLZx73IXHQkidThsCV9A?=
 =?us-ascii?Q?i2BYMocAHhicNGBaiSs6HRcJEHnEHgDs8EaAnC3DfQR20owcjnroXCSOv6MU?=
 =?us-ascii?Q?+rrKet4IuE51qqoCz8Zv6EHcHDC3+lf9PAF6MCZBah71R6LXPiK3eEb8thi5?=
 =?us-ascii?Q?wMlRc8xnXRqXTNA+0OPOypJVTLIX5nLaWmKMDfBGtb7aPWggAzTC4Dmn+eq8?=
 =?us-ascii?Q?p/M7YoEJa+W5jkos9zk+NHZpXyDS3AgRPcy6jXfFL9EEsBt9fozQMPgpIcLV?=
 =?us-ascii?Q?/Ez5sw4+UP8qaqiKR6gXCdbkdehzo9Vet4/fDV8+eVZ1834at8fI8PklZdKn?=
 =?us-ascii?Q?FZEop8bCGnFgzvqqUkPURbVH1P7GgzXyVeG8m3BzfgqwnIdNDMznXo5shkQj?=
 =?us-ascii?Q?n1VnRJveSLRvk8NEdzuyLpL4ILaYx0OJfbZqmh0n+E1VuyuoKXLADGn/gl2x?=
 =?us-ascii?Q?BGf+XDgCb5Ql6xpwhNfR/7fkSOlWMfO0LV8Eky79PUrp9i3e2pU757dEa38z?=
 =?us-ascii?Q?q5SbydndtEl34lLotlCk9XD2cbEoVAwrYL50SLYkg2yOysizsYmCGwyav42o?=
 =?us-ascii?Q?7Kslylb7VQHs0+JShODSXrm/jLy7bTi9c2sHumZY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce458c94-657e-4a56-d013-08ddfc2a190f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 11:53:09.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5PwFHHVts9+Re3FZIF4gKRGUJRrPXeRuyK/vEUDVZM1wu6ok/ncCDG2to02T0oK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6751
X-Rspamd-Queue-Id: CEC4340003
X-Stat-Signature: p5qhih1kocmf3j6po676c6duxj9jy8pn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758801193-738741
X-HE-Meta: U2FsdGVkX194Q0esIsdf5h8H+ZQ8GXQAtS2EiBOhcl7fJzbXGinDZbHAb32d3V1uSQ4POehwOyMZduV5ZXuXT5PVCY8D6U81bsZZMhkS9HIRq16NihMvIZwldMn8WMX+8HK1njoxxGQnnPZb9n8Ty7b/naGZguzSs0JFpgSyALOb7RZLsztOoGsf8cHBwBPkgFqnoPhnYxPIEU7hLXfZIDvQD1ECICXIAk4mHhUc/0YLTu/vxE4RtcP6rkMldOXYarG1CppYgPbM0Se3uoxoFyXPLCR9P7QxmDK+CsDe9IN9FjQnVWjLW0zkS1dPsk46W1Y/seyKGRVbGkYGGeArl9lCuZsWnSu4HNA8tAxGuBb6HKnIieUhx39kTTzIX2a2m7LNhZZ57v0UHCEihn1pAyQfu8hXcrG32Z5uYiUGbg+q6MrDSmaHxBOP+zEEEj+t6t/hidP8BGbc9/K0vKPTCatp5gxXONLFIgyVZtWtHMrF2xSNI1bPR2N/iv4AdxhBMZazrHAnL8LvSeD0bz4AuX60VY6sj+LKvNvZq8MZREbsf2mWm1XtNdfqimej7AWep4Xg/V7yjrky8fSGy3SptlUtZaGar0Fz+UNgoK6iwOBIbGd8ZfcTsO3OQGib0btkT+TyNCbfgZcqrBAq0o6zx7O+Jf91H6NP/HtoBQGZx8UN6UykrTGlOIx4p3Z9njduELqL/i43ZoRZ5UBdfrujGns6G/B7CL9ysUAhx7Npw74ZBAvooyPSWhYjniiXXUHvvN0Y2XGqNTWp+j5DPiyF9g1FPMzcP3sGn5q/Gc2fh7vC20fTT16qmEssr39wwVQ7bSh8VqAiJVilF7e0q9CrhFvSv+XKNWxwVYHLnHjqnKc9nVc9PgQuuNC2u+DchaItDRlK8s7rIg6N0o+5k9ItEw6ikbbTkwDerSQs+aTvWdgQixpUof9stXL8eGXrkPRY6+v0pB1bw8t99h078IW
 1lxint28
 04ThqwA28MNbC6vdu99pHu98zs2P4v29K2btUjDnWUSPLh0Kx3/GPwSLaF9cP3AfSrn8R1vIVtL7bSopIC+qaFmAyTzDHu8xm+wFNIkqpP9unYB00UTB2DlNIzbz/Wts1XRva0nasdes4BV11F5IKp8fHxNECS+Zv8vTyLogsYabISi/lqS2Ew7r3wq9KJv+MGA7le6BT05wxvh4jNs925JeZ/mrg4XItFbX+GgsxuPCWf33mqakdyIHZqhFBu7sWbthTkarvnIjCtZhL2JJJl0swru8VylK4UHH4gCmgTJz0Hwrlg7TPFkpZuLepwFmu1NP2RckoEVsq/BMUe9ysOh8Ccwb6Lh5iUEju8dnJdoxKfAqgTXYftlsawhkuOCFlklogWYh9bZuMAon4qR88tNkkQAtxr3sgtSj5d+QITmzdjQl+aKbzj50H417W+bOfgHCrVg7jbZF+kp3q2FjYtcynz4ysZI+GUt4CaHFxPEjmjuiqi+OFun+8wA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:

> > It would at least make sense to me then to store the provider on the
> > vfio_pci_dma_buf object at the time of the get feature call rather than
> > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > the inline #ifdefs.
> 
> I'll change it now. If "enable" function goes to be "get" function, we
> won't need to store anything in vfio_pci_dma_buf too. At the end, we
> have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"

Not without some kind of locking change. I'd keep the
priv->vdev->provider[priv->bar] because setup during probe doesn't
need special locking.

Jason

