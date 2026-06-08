Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11244CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D6C6B0005; Mon,  8 Jun 2026 14:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4CE6B0088; Mon,  8 Jun 2026 14:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E42E6B008A; Mon,  8 Jun 2026 14:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7046B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:19:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F05881C1178
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:19:26 +0000 (UTC)
X-FDA: 84857557932.06.3929BB0
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17675A0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:19:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kn6IFVV2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.5 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780942764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5zHtme6RaqTYCQxZu5V8LHuH9mvVPTHjeBZ/akUFWo=;
	b=BnmWhJWuPDwMoQOyoKVLrUI4p5QreGIVvAIoz4/VGEdjOQDFJkSF1QBfHx1Me7w+efx29o
	pxjO6vGBk5SeoaPzUex2JDHtfDFgOdNMnY86BQ5kAYaOA8vamP7BODf36dlB5d03GHwpf+
	FFWcgaZ2Y0VncZXTZV1RSxwAY+jeKJE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kn6IFVV2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.5 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780942764;
	b=xeNIoupoBwcAqu0iqdJrUpZnaAMid+6gqaz21XNa43s7cePaTgYHG93YiUVzo9AB846BgJ
	Z5uJyfUpLXj4VcfE5EQFrSOFQ1YtPs5H+Y9O3oF8zIJA8FQDGby8E33MuwbnyH9HoVXXN5
	HWcdCySuUmY8BT4RB04zN+14c3PArEE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gr0uZqOH5RLRAiD5yZlYXB+EODCkoSpMhs41AYB4MlmV7butyEvjdDZNABDi380aG///aW3mFgjeEPgkC0Ont16dP8IMDL79PryLZ6GySMTCXNU4KUVOPzRZwzs40zZI82v8kT/YSdFf+cF0sI2ZMEKgRbn7uaEj2JAgQaoZ2BW951JrslwwUaQTmUsEqdws5ZKOb0g6twZCrRgCop1iWoeNmtK34n0bk/aBp2c5oH34x6I2Bc9eTs9FFnlkawkpxwyVcDuhkk3e9pQnCCfpJY1MyuEZvPFyPOKXY8ef2PNhbG9I3xVNuV05MBk+sbtOo9sMifuv+WZwJs//h0QeXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5zHtme6RaqTYCQxZu5V8LHuH9mvVPTHjeBZ/akUFWo=;
 b=N+qdT4f9rgULf0PhU5IQrhodSoz9+jjyssf/il2bCoijDlLMOHxX/4beLAGd9JUT2x0B271S6bmbt7BMRKpRLVg/khx7I9G+CYUIf2P1UQOVGdLhJ4znxZSVhVmt8bbrFTarE5pCguSlt5aGw8iNX9sEFaC1FDRzPaVw7K0j83ubqUx2iZbRjN4Dy1MDGLfKrcBmNvmHlgj56H8DJTUCPq5DLBJwdGPNJvGwol2jDL1EhB2efQXm4971NAUD8Tbnk99Ikz1/E4LhuI9fsh150fmmTTPQh88xKmlD6QPxHeUq6jMaQpn5He0qzIRK/gCq3YiNuIwNMiBke67axncMdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5zHtme6RaqTYCQxZu5V8LHuH9mvVPTHjeBZ/akUFWo=;
 b=Kn6IFVV29zAaEXhHqj+FORnThCOQ7K+zXqsR1WL5IDJcyjWeBinOzNZNgmeNHF+SHua2pZIr3wnsj9a6w8bMoBKI2Uf3we+LH3KUX2mWPrTPC2CvT9BKdQgNQahQBDXah8Kcj0m9Gb3G0Sl19RLPziie7SyZbC+7IU1MB7nBdTBkNLwWkd6ZE3BJtz3r9i4nnNBDGjtgZ5ljlfaFdk0r2OxhqqUMEqdgyhVUGHKca7CRCB5tNstoxTzFQ2wsy8cnHI9Jryxmth95fYJAVQcN1vJPtabLEff2DCsOBdw4DKeJMG6SBn6B8n+hJB2W2x6dZJme/thL9Bghbjce3NR60A==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB9211.namprd12.prod.outlook.com (2603:10b6:a03:55e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 18:19:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 18:19:08 +0000
Date: Mon, 8 Jun 2026 15:19:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
Message-ID: <20260608181906.GP1962447@nvidia.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-10-dmatlack@google.com>
 <aiaoc6Y6qeF_5Wn9@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaoc6Y6qeF_5Wn9@google.com>
X-ClientProxiedBy: YT4P288CA0042.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB9211:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e23ff4c-bd7f-43d6-59b2-08dec58a6e01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	0Sl6ou0t25oBe3u7vvSVwfieqDymPwci6XJEtmbYgCo1zNUTJNXc2i+QlETyIZkfgn+BRzCcP8f4NjNOOlMtohqYSlfqhCSEkhNJhNfH9U6LQQ9X0S7pkgLcBvkh2pn90uOOLU0nw8vizCqQw+Z9jBSjbwAqOUwGMDpmNDI+GIp1UhqqLTM5oknSHXGDZyEOxAE4+yKh1LbtCk7LzPugxVGQq3p0qIEiALLM9/g/TstAlfJULCqCr2PLNb/Olsv+/YaSBBD1rBSB0FlrfcFtGAitEDCwqq2IzUBkNQozx2bpJaDOvlfXsdMxYh+v2hWxIP+yHYYthWfq3sB1j2rrcnl7asrU/HkrMzXR6lfCcBFiJcXuqPGIXznaxm5JpXJyQvU0eqL/SD3SmgHhUR6bfFi3yQ/kntyAjmMB2wtiXOqS0pqemHB306q3AhG001chNIlY6sF25+9eTjkMLrUc+AeacYYkakxDFMasIRz72IxoPFwkF1U+jBY0p06dNd9hWoC9JIZlIXpQ+edy0GQUUG2fywlkYg+uxj4/IuHWlBLqaD6VypQSwBiAujfZG7HgvwHLOLNwvynLpfUWLahD7R6ydl+jpXiOX0uSKIe/+VU3LBvYPr5IrC4oQa3KyVt1NmSgT9KhwXFa/I76GWsx6lg3CaBBflIqnSm6tTJF8LXqLLv2BKQk6MPnbzZP4KHG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1xDz0d7vqnXBKt75xRurnWm7F0FjObO77Upc/ykXLVb64oKlBGvmxI2fQm/5?=
 =?us-ascii?Q?HOxT+mdGvimBa/iA2mH+aOEPFeqHlT7WJWa1cTHPMY0D2bu0UTcYQAA3jc2U?=
 =?us-ascii?Q?0gegpCQbHtjpCk0aeSdvY+xPNywSccfrKDqFGOI7MO+YMB7a0FTgsTRnzrSq?=
 =?us-ascii?Q?pbzsntq07jP5KimKGDqO1SWt6aoR/DU2JNb8zX2lHiLr1oxH1Zyw4+lAR0ls?=
 =?us-ascii?Q?AtpGxe2kimJG/nRCbm9ymDu6r5nChZ51LHPWr/6e6bxtZEpnxbrDu1gOSryd?=
 =?us-ascii?Q?WPhb+ND9skLKfQqtnZB4Jca5HABWhszrnVzq7+QpEg+czdSZegQmGQpQ8SV8?=
 =?us-ascii?Q?ejxb1ya64sHSqCYdvxl3aLj7tJ0gMyaP2D2iAnI4sZrtCvTaXr4cRV6dF7j0?=
 =?us-ascii?Q?5GDT8xVFN3ZcSRUUpioxfVu44/lOKfMaEl91U7o+W3r9vsfdRGqCCjtVI4v2?=
 =?us-ascii?Q?CN6iH8m0HmK3c9c1v97gEjGZ2h0Tc7cDjY2mLKZaDhKg1NYaz3Ek+2PO+2sO?=
 =?us-ascii?Q?TET6CgcfZoOj/cUNVSPVS9B5iD326OoAE4z8wPAJFdp+26ZmoJ4HaLjwd8RV?=
 =?us-ascii?Q?/kIJ4ZDqC30oWZEoe1oNoj2/+FN7KANggsxXXuw2IkpJMSSPQJ3vEXqslgkM?=
 =?us-ascii?Q?Mx9RzuIkUvJXuctMkZLUstQgXQmaHTA2sFzQrrML/0qDRKXb6JHehTVtRSiX?=
 =?us-ascii?Q?CgFyhbaqN1truodClHvC2b/9VG/ScSMuqm6crXhQ5v+Qolrftg2+eAh7Vl73?=
 =?us-ascii?Q?MxK+GXJ7ntkzeR8fdkNomk9jUs3qzUjPdtnzH3iiu1TiKjXSjj17srV1bbH9?=
 =?us-ascii?Q?X6BuKw5OdTADawtLnug63A6GJaCLltw9tWy99etgDWAkhHSOaA2TM42ohbJ0?=
 =?us-ascii?Q?w2oaF2Z0V/NHWBrT3ehdZ3312jg7BNFGQkdsVg3bfXALMUXVhOPY/M33E0xH?=
 =?us-ascii?Q?aLdyrvN/ET92WIP9A6Agbpcsh8O5plANUREARv0MJlpeTr8Ep7XSb1C61A3T?=
 =?us-ascii?Q?4pi/lbTY0Zcm2kw3WYP4j6BcFpYpV+f7lC45h+l6K9I2PZ4W7FfF8ejMBL9B?=
 =?us-ascii?Q?COyPxwdPln2ioZ5rO07+8dnn3DfJjyQhFm6gZF5nuqs3TzDur79DNGD/3vjJ?=
 =?us-ascii?Q?bIZ2pmcZaN8+zR3J1UqJWloSE/zya52cGaSzH5Pva6Q6iZbNL0oZbhPO72dX?=
 =?us-ascii?Q?jwF9vIq6F+800vD+n11sFk2jgasf/p60ksscUxkhljCIq9k99SQ4mC0RYm8p?=
 =?us-ascii?Q?L5Fp1xMRhv0jakmsMnhHEKK0Zvz8OdqG7WAZeUELjDtOG47KLdR929RojpOS?=
 =?us-ascii?Q?Dgb/nLaEZ5HRwlLSkfS3ax8K4QhZK12rlOt1Va2SdsARNFFvYAxWRKy7d/Yq?=
 =?us-ascii?Q?llE+Wf2yxc9KmNKE/wTtjQU+9xQhQqJsHUVPA3C28MfNQANaG4gheV3tEaGO?=
 =?us-ascii?Q?HOQYF0Jp+9iseXlXtp1XTdi/MQJPMwKBpllOV0dbO1pmDh746TEGeV5A/gj5?=
 =?us-ascii?Q?9Zu6aSaQhwRgH962bDMPP0pkpEtlmXacTNrE/7VzQ0J/NwoX1Ct4rpHIj99j?=
 =?us-ascii?Q?yiZoSGwstVTrWgo3bs677FqwPFSrjvBfgYACGxF0uWKWXUrUDXflI0Jc2cOr?=
 =?us-ascii?Q?awjI+fujmDO2KmKiitUjxCz0mr30OFlS25PcmkYQRvmKFsaGmjFHwUR+CiWY?=
 =?us-ascii?Q?bDfT/8StuuNPqlubHIMrL6F56gKJuH5nX7+og5uo/R97rDIz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e23ff4c-bd7f-43d6-59b2-08dec58a6e01
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:19:07.6048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGjkI7HI4/aSdRCMRnFAGzhNtco1GPvgHbPRp9qesI0FIqqdDdqJOG9UcDC+iS9p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9211
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wakxi9hkgw3kztigfh7qqn6ngqnhuo6d
X-Rspamd-Queue-Id: 17675A0006
X-HE-Tag: 1780942763-51305
X-HE-Meta: U2FsdGVkX1/0lSwT4PBcn0K++tgws4Y60ccAC/zK4+9CXbk/2SiIjN2Qs8mJZmK1nAG1wpzJ7uKbiQir5pGldvXL/tdyTfv63cYEx18gCr7qURRwIqVyd2G5woJNKKyYUtajbNTBNEHC7bYQ+1MHXvG2nhWOACQAjlb2GjXggtAvUD/FLIrVvmOzf0Wun3qerFBLNg9M55uDxeH3PFubAzDHSJg0rFvDEzDy2gVMg4ciw4EjNv6/e79EZHtNxPRqkBJMfi5rUAteu3Xi9ScpaoFfQXrmTIte1eyBDsOyTBSX4kPkyyCLUZt5uypmWRzvKjq5ly11T3poiMB176k0RUFVfH2XTIPJB3lskSTA55K8TeOUKxySCe1Q5CMD6+BS9WXybzAYR3CrJtEeJLNCeHtVr8emmIslCYuEz+oECNPkV/QzfCLSUsL75sa15On3S2X8wja8Xzyo0YRcv5xIP8AXEh5Rc67wB6h5jfkc8cwGGiJvWm0zNBf56vi+5DT9E6J0mhROdSeasjwWVrtlgyjpq1/qpNLrsYPFPP0srLYVUwK6b9zwSgmr3TCLtizxcimIvjIwKemF37J6A26CSCzsM2gfkeq2frkTPJJ7Ganz7JUXnCopeRYMzVQ08/kmTg6Ve8Uy/wxzoIvkXibZbdNYLN0yNJDyoo9FdkfxU3hpamSsWqbuDtPZV2BlFiYSNiYtw273RafqjnUMwL5Iuaiz7SuYRBoNkq20mzQDb+5o1Oavs0y3/gFD0zTkZ97/zIy9/zd67MepCmFozJIinfGqwstrG6vWKN5FBiB9T48RQ5Uj4QK7sPGWDjtcIYl9FpNl16djxexL+bg3kLVX2stGXqarrfCzznllKo+Do1xSo5J2PtJHGCQtUdhZcUb/o1KYSBDRNKLkDaJuIVOwMlXtImDUPn/nOKg8yVloMFveC7iGhUuDaEv2+l1PD08hyVElEUTlqS9H2pJB49u
 jPc442kB
 oCz0Reh7dI4ZoVbafLtobx5fGZF+hheWM7qMg08qzaGRM2yk/q8tZLQ2/VFn4KeKdHXIuPlfeV9+Wah34O8BsmVAo77XHXcFwoFQ5pYROO0rcDw8PlVQEhwstGe6nMee2LUe5SkRjXqHjWKtphE5CZ40XR7kBZasKpMEL0mcucZ4QycEQw4mdU/KlsVVwpKFArYBe+TqYasSe/eWK1WIFI/EnL7gcBO+JPJ6QO7ZtKUzuEKb0bJ8cqUjvJMzvSnUkH8Q63sGJUoTQzTZTe1W8SwhL2I5T/7BPQqY8aee0tpRAHFe//SADNzOEIsTydT6W/rzV/UZ0rFkUbTLAappUZ917avYAvWj38NctKESHm1HyT4aKUGZXfxr8jinyJWXO9xMwBc8E/NHOg1yJ8rBCX95AvROLkcHV0LV/Qirij1VcQMq9TZPDpQTFWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 11:33:07AM +0000, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:07PM +0000, David Matlack wrote:
> > Inherit the ARI Forwarding Enable on preserved bridges and update
> > pci_dev->ari_enabled accordingly during a Live Update. This ensures that
> > the preserved devices on the bridge's secondary bus can be identified
> > with the same expanded 8-bit function number after a Live Update.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/liveupdate.c | 18 ++++++++++++++++++
> >  drivers/pci/liveupdate.h |  6 ++++++
> >  drivers/pci/pci.c        |  8 +++++++-
> >  3 files changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > index a93b7ef065f2..701276ef6cfb 100644
> > --- a/drivers/pci/liveupdate.c
> > +++ b/drivers/pci/liveupdate.c
> > @@ -128,6 +128,10 @@
> >   *    way after Live Update and ensures that IOMMU groups do not change. Note
> >   *    that a device will use its inherited ACS flags for the lifetime of its
> >   *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
> > + *
> > + *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
> > + *    preserved devices to ensure that all preserved devices on the bridge's
> > + *    secondary bus are addressable after the Live Update.
> >   */
> >  
> >  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> > @@ -756,6 +760,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
> >  	return 0;
> >  }
> >  
> > +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> > +{
> > +	u16 val;
> > +
> > +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> > +
> > +	if (!dev->liveupdate.incoming)
> > +		return -EINVAL;
> > +
> > +	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> 
> Again, I might be thinking out loud here, but since these are
> hot-pluggable devices, with some FW / SW running on them, I'm a little
> worried while assuming the HW registers can be trusted across a kexec.
> 
> Say, if the bridge experiences a reset (e.g. link drop etc) during the
> kexec blackout, the PCI_EXP_DEVCTL2 register could revert to its default
> state, meaning the ARI bit will be 0.

This does seem like something to be concerned about, but realistically
I think if you get a PCIe error I'm not sure the incoming kernel is
equipped to handle it at all :\

Just resuming the driver is going to fail too, I don't know how VFIO
can learn and forward the event, and so on..

But maybe it is worth being a little more defensive here

Jason

