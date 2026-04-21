Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E599F94CA0
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776FC6B0005; Tue, 21 Apr 2026 15:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725BF6B008C; Tue, 21 Apr 2026 15:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FDD6B0092; Tue, 21 Apr 2026 15:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 355726B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:20:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C494FE62F4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:20:50 +0000 (UTC)
X-FDA: 84683530260.18.C35B252
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by imf12.hostedemail.com (Postfix) with ESMTP id 01F3E4000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:20:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bkgn6yz4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776799248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iT8/t4hqx6YsKjv6GiyYdJPDbRUrv/SDi6uN3iMzbxM=;
	b=onf7l77RgHjeq1zTWsZtQ4udgI2m22QPkdahip3mcNZ26naZ+KuEBgNbgPz3O17Mtzimon
	9dihSJzpy+KoUrz8hRDxlcRbq0h8BkuNZjbWEnilYA8mpUpc/Kq4rzBzDBmPKw9Tz+xtrz
	ZgtEfVSEuIoRE+f1NUS1h0F+5TDM/tw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bkgn6yz4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776799248; a=rsa-sha256;
	cv=pass;
	b=TMOtDqOk64NOjqeeSUoDgW6mv46UA7tjhx+vUBkjXBXLMZdyFMEaO/7gEu/W+wIE6tzlEV
	cX+zDL6vmlSWeDMr0L3FBgcpgQL5IZZdeRQTQ8vUrZ9TRhmdTp0T6ntNMB/6I5YSNF+ZFg
	QrUc+y9ON37BL2fkwPTobpvsZ9QAEk8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AB3OwNmNiLq02cV/8f2V4xseVBLLBThFVXBBiLSa/G/kTDy+i/yImomm51X8cJjq28zsxlpNhDCPf/bK8et3hhNQzAD/7JCWj0TaOz9fodvDY6wJy1aDf/dFL4cXhdmhAGAopc2p7LzZkUv13uUtaVbDmATECkGYPOn/k4o9yI9z7cCwLSOkIknkuM8Mq/BS5sJYArypysdEtScdpbm9L2BBUOHZ4JAYCmBRpGa/MOwHvVio/N9vSlry3WApxVyC31tKxm3w0BsuAKbJmaLVIjwD+l2VCkEH0OeQ3H6I3TAvzRtM5ZgtDKcV4EhDj6rpxIVmbUg/g8R80exCitxfhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iT8/t4hqx6YsKjv6GiyYdJPDbRUrv/SDi6uN3iMzbxM=;
 b=VTVEcQ6yT5LFgtdje7hP7EG6GRbc2jfFn0pE9iZmwbdU5tNw9XuNbqazfsG6c9OaW9s11p8deOVbyppZP8pJqF+OCT09faw/O1aY6uhlz8JyclsZ0aY6gCq5qR4WBmKdkjbaRIsXOfas2nGui1XQU6EPiPzSWXcSexJ6cSo/ahqtA+3sxQttq14tbKH1d62qAwAD+O5UouuRsggcb3NfHoJIGhrVctz5IPCrz11SO5+4mHElkbi3mSecLLBOL4BmmW2soV4ESqCBSUfUlzHYy1GZS5pwurGQrLmja2QAgklg8D0h4kMQDCxfKPmNbLoSWWsRaIWzh50/9fpAUeHb6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iT8/t4hqx6YsKjv6GiyYdJPDbRUrv/SDi6uN3iMzbxM=;
 b=bkgn6yz4Xveuy6enkf1zsJpS4+8123bGHpuQWNRQ8e6v/xS1YqqSA+tEtOfxHMFjdlViVkyGd5ICiiSGRpigG3lIVLZanrkwGBmvMTUdhcFrj992VYxeh+U5a/bu3ng7B01XQ8PxuA9D8azDx2p60CQuysHpUUW462QLLiszccUDQwIfWc26VsFP5EOVymrRYumK0wLU1S8VbB+cgE9Ylr73zmhJA/UgSA2rNSCzYUnVoZonOziVQOsxfwyB03+jJJUxeY1O6ejoUdot/E1KE+0sCxHpvVa71FCtG4kZJzCCn6ZtQDKG7OGQHA6wY/braERzq7CJ1+n9IxS0x3v7jA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7233.namprd12.prod.outlook.com (2603:10b6:510:204::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 19:20:43 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 19:20:43 +0000
Date: Tue, 21 Apr 2026 16:20:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
	Askar Safin <safinaskar@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chris Li <chrisl@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	David Rientjes <rientjes@google.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>,
	Marco Elver <elver@google.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <20260421192042.GH3199414@nvidia.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-8-dmatlack@google.com>
 <CALzav=ehpWA=XchL+XLZuaYfYmBTPNWDYt1W3LFY5-6+US4E7w@mail.gmail.com>
 <20260421184433.GG3199414@nvidia.com>
 <CALzav=cFarR4q7NugCxXwCW6wnyU9dJRaaTnxs7MY5ia5SDJWQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cFarR4q7NugCxXwCW6wnyU9dJRaaTnxs7MY5ia5SDJWQ@mail.gmail.com>
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7233:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aca0a3f-9c7c-4b0d-b39d-08de9fdb14e3
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Kd8xGL6SFpML6qGGK7qRoCDdftITqEfgQfyjP+QBctPOAzLg+qIbTJuUwW6fsmjnP+yaYV1ooRguGD3Iw4v+YjtkjiGzAAEHux1hEoktfyto+3QV5dDR5veOFobyNtedtfwdyJRrmlGzxq5djEFNKUVgUr7H6Ud13ifzycrddFMrrzpijXGC1RdN6T7qzM5Hr3ygTuhXF3TNkbYcL0eM8ajLSAK16UkoX4fG9eB+KAhCGIQ09ax7ko0/6oE6ypw6Ymnx2ttTLnG+HliqjTDWrOCmeft96LDdB1li8pbPNqTJHt2xpLbQIgX0NFjRfcZiID49HKTOukygjV+59oJRdgINW2d1m+MDGdOGmOHwidxmQgv/NNEPX66cSLCstMpX6EbVF17mTlsmyrDi8XpRAPJjIzh4D0iUQStu2jfaKBCUtPiW/ztLNyD1LP1KHYYRh1/ulnpRM8OFKyBSTPGQgierQsa8pFaeOfy+2DE0NNdOyDGzBehOB8DjgFtepavMkErK7+5UxiznNPbZhTw0xw2tv9ku1P2tWkcrrzELyJMRarbwjP2V6d2yKP0TFkanGjqO7hqJFW1SH2nMBqUmZsBdG4u0QKHYDRc5dL4ZNnZv2t1OJKqux+LLaUfP03/yhVKAUJuemDc/nUCm9/YBb4koe0ikORJ/Id18rg3w+I2k/Va8pF76iOiVrVvtn0PY63JhuV7B3wncQaDTtLVZyh80o0YDWC//tz5E9mSmsoo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pEfjo0RKO370kJoVQowS1gGNNv2xt7J98af77o/R9gw0pSnF5VlNjQxjTbmu?=
 =?us-ascii?Q?DRbkRUmWKdU4EFlQ0/1HNY/++GMmdml4cvIXns0OIArRVJqgyRpgXn8vMISh?=
 =?us-ascii?Q?Z6QKsn23BRvEws6KOnCThapMRsi2nPGpn0yKN2uNVb4/QiP2X3L+jC0c+bLJ?=
 =?us-ascii?Q?rEcXfi/N+DpgU43MXR7EiAlgiF+VM3F881etdeYnfRQrQIc9+sCjTssCu2Jd?=
 =?us-ascii?Q?IjRfTfUH+yK66ylslRs+PZiGZVcChOJhoKLmFn1PN/5ps9PXHS9F0FT/9fxo?=
 =?us-ascii?Q?loLExhsKgCQTJix+OCCJAh1ybMnJ0lw/GpdjrkaTmlRznE8siy+80MglOyts?=
 =?us-ascii?Q?GhUWl2M+Pwfx4xVgBOtQbDvHfFSUSqjFxEjXdK5bDQWLqoc1quVyPct2kkqU?=
 =?us-ascii?Q?FErz4LCQwMSXgeS8hTa6ZUWLUSPQvH+DqewYBCXMTZiWdd94DJAikKBCwnqd?=
 =?us-ascii?Q?j/fCiegmgbz3jErhK/fx6KukvTTOgZlWMi0Dv9/pcKEo2DHRF8b/pCzJIoyH?=
 =?us-ascii?Q?2NOukZimtLtwjRRMKNdAaAr2EAkhCqMMPVvdPYzezFe9Lc8Ao5PqUsNkjHvw?=
 =?us-ascii?Q?eeiyfdx+9EUxGs3S9UOovKaSiCi1Q2v2Oo4X72U1UFtXhT/M9EIJNji0R6EI?=
 =?us-ascii?Q?IP3zwoN5pwY4tg0ByVCLqfMA+1SYbooewvtgsd0GQUyseBDlJPo+xpHEYqZ7?=
 =?us-ascii?Q?eHeYP0lphMgo+gmcKXiAz7/eeldO9XGpfr2Q1Yjj/aBDUFe45r++UajsAhhI?=
 =?us-ascii?Q?WFlFpC0jxy6b11+uK0nfa7v2Wf8rQeTaXmbjhrn/bqJsftczYAnks1v7TjlT?=
 =?us-ascii?Q?xWxD5G1htcym3/hEIoEs4yUk4ins9DJ7bHMnSj/yHicwrGMz+zCLMOucCUg0?=
 =?us-ascii?Q?GZj/wmtGuHQi58alHv6DwcqAK3G4t9Ecj9QGh6CWyZLgVoNSFeLLa/91Iki2?=
 =?us-ascii?Q?cutT70sl7g+io4HEE1VCJt/+J5xORsWQnohXy+uUYMlYdfHhdjeeCGqodA0V?=
 =?us-ascii?Q?sV2qotCXmaoi2eje+zslbxgPRrziQmdLig2Im3ael5eByhBJ7Yhp6ma+55Wu?=
 =?us-ascii?Q?P+uXPEKL5VkTQJ58D7e9fo7pYt3D1NmEbUbnt+CDI3Ts6FRUZ3Q+ps6xE01O?=
 =?us-ascii?Q?Q6MwEH8uFiusycwswyc5ciOU0KnetTumR+WDqYJI5u2KC2IsbvvLVbVSu66H?=
 =?us-ascii?Q?6/2JfsUTS06pkQss0jeSZnvzbh/COx2DxR+EoLg5Rl8L7I+wZ/YsmvIca6Vq?=
 =?us-ascii?Q?k6xvz9SVhJHoWfjgkgD34MmqxQlcGrSthynIbhR98aHi2L/HUVZq4lS8EWzI?=
 =?us-ascii?Q?Q2cbCLLgoqNGk9QUpaRjm9tKEKcx+4aq2lWaG4wQM3VnzkY7yVLFhjVeh/K1?=
 =?us-ascii?Q?ftVEccQu0sIlUz+PF5FdoOPyMKmomc0wd/FapUR5R9WqeulRsRktFnzoL6lv?=
 =?us-ascii?Q?XnKLlTuobsaTwlFRN22yC+QAbEXd+YlHYEwAHLqoZkKfgMjWUAAU1EJiQDlv?=
 =?us-ascii?Q?S/qUOWDzLzhjxIPvjc5KGfDZ6SgLPiESC0brfbA0Ic5FQQaj6aFLbogKbi55?=
 =?us-ascii?Q?SxfIDQYA1o0hwq23XjJS07lK27HpidbiS/AvS1ld8w0EcquTRkelsHSdv3K5?=
 =?us-ascii?Q?Ls2QhDG+Qrr836r5Uvpk+RZanx9ncJdUjDuARqnPU/5amoZ+gRbTEYNO7JP7?=
 =?us-ascii?Q?OzcrIPe+2vKyC3/h7QCU5i9/ItAxPRYcnrUYSXwgalZ5XjOd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aca0a3f-9c7c-4b0d-b39d-08de9fdb14e3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 19:20:43.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCUmHDPBTwPMLW8mmjZLB615OOiAdOwfBMHsvlWVNVTExtSxmzuJehv4Xx9UPN+H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7233
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01F3E4000C
X-Stat-Signature: 8n87zrmphxk34gm6oexfntsza696558w
X-Rspam-User: 
X-HE-Tag: 1776799247-575318
X-HE-Meta: U2FsdGVkX1/kZFz+spp0YeV85Tc75mZCljR8wFXJEAktFPmmHkWAQdncegB5pneIL8jw9G2EM4yOhpajCIN2nAtNS+n81jymw2zCNydin/rUDfOM9ZN9J9gwLboVJyoOYpAYQqjNvtnUAFkWyneQfXSS9Xhw4xF5tTC3rWzu5gV7Xvust5Lr7aTIgXbhZCgnobDrH9RDP2Z7jKzwDxeCww5NaAl7CLk12jWsvTVAC/CYa4JDFqK1NLXgQedPiVGG7T94crTXgU6ctYVSqka5ElKPzyjyrWsrXfs68Ud8H9hJTyKZba69zTvdwe2cEjO1VKd7sFpGxuKIb9uQ1UWzrNTtlxi/IfiTBSwaYE3M5QhahydJEjUQBTdsKGLCUa8pF5MdfkM6TM/COf9XSXiXW1hSoqrBa57nUQw4qaWskQ8QX9DacAMEPMP/U3Nk5zL5hr0BK11Su4eeBdSpy8mkBpsFUkDwxIT9txexh58ma+/YCaDu4o8MDjaCbdhNtzVToQKDT5jQezIMbPIRSezu8vYunGBPqiOSTkZMtWNz2l/i2YGqmvdZnxjfVnKTFOVamzVtHViX386awZQ1nBRSalm6MSTEiSEHkzJpS1dLEpJPgiPX7UjOhFCC7Gc9IWxWpa/WnpZJNO+Cxqk8fSWI/IsG9Y5UuAk42jGW6xA9kF3KIB9lCnSQ58jqUrdwBgZWrnB3yZC1EidiEo19uAsU7YkEDYREOVJxf7gNMbxn65RsD4rNf+IG/99eIiWPS4ycMS7+iyGfjGQ+3qS5jZ9hiSUYE3d312vH9lqoh7d88NwwdVP5v/bNDSD88ypwop6IoYlzyekO9m3CqHPgHINK6G1ei5xnubRN82wPK7FvT6nYOir2X3ctRkv3dMu5MDv6RwN25Ez2ayA2YHMF+fpV5fCB0RnkZKbHRZBcTgKQGmBvTlo4o2WBAWGzA06qahRGKKqeDdFrbqIGolGyk7b
 IVxI8cGX
 CWfYTBk4Lsu3homGvpKLrXxuqLgVfqTTSyNIC49Vb83pczijKd/bqbW49OzYm1u9ZF6Nva80QlaHNs7WOYpWK9UKS4UNBbekZpAJ8cqcRF6Lgw9XC2BAolY92VdIMh8C2PZMNXlO+xBKAow4ZF4N9OiFzNaSve6bfjmnnkF8k+Hkb1X+Ie7x5h6UZAR9JUPi8U1EERTdFTY5xniZfVRQLbTwy75otbP1OJ4cl2JDqSPqZ5vRfNvvKU4woDXMNkWMfOuZa3dgNWZmUnBQAwzd8i/O684EFkjiyNqkUoz6yV4cIviGCdf+d8APSG3gLVslAjyV4/HoJwzIo8Sf4KdMPrhqYm9MQKDXs5gCPOM4GQTi16e7afDe29Kk56GLtsJTQU4kkiJQFblHIOfpw1fqn8Loz6x7Vq7HqHFz2FIeSlbDS+whMOm9h4VHsUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 12:02:51PM -0700, David Matlack wrote:
> > > I think a call to pci_clear_master() is needed here to so the device
> > > stops issuing memory transactions while VFIO is trying to resetting
> > > it.
> >
> > That doesn't sound right, reset should always work..
> 
> pcie_flr() calls pci_wait_for_pending_transaction() which times out
> and prints an error message. The reset seems to be working fine though
> after that.

Wow, that doesn't sound right in more ways :)

pci_reset_function() just calls straight down to that and it is
directly tied into the sysfs reset file.

Meaning the sysfs doesn't work if the device is actively doing DMA?
Feels wrong!

However it has been like that since 2008 so I probably wouldn't touch
it and agree that disabling busmastering appears to be an undocumented
requirement.

Jason

