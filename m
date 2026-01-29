Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB859D6B09D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 16:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A566B0088; Thu, 29 Jan 2026 11:44:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A136B0089; Thu, 29 Jan 2026 11:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7246B008A; Thu, 29 Jan 2026 11:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C62CA6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:44:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C36B14020C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:44:47 +0000 (UTC)
X-FDA: 84385575414.09.8551F27
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA61018000E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:44:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jR77Mx2y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jpFXlRFA;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769705084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T//YAfnJVzO6DVf4k3ecrSKiaXRDycpG04lRL/qoKYo=;
	b=WRJTg8l+TkAn+Tz769mTIg0Y34r3ELI/f4Xv0+hTMFwjsvVsSEitzOsrDzQes5WOLWIoiP
	y+Rn0uvT1S04HO5l3vchOlT+k+wjhSCls+xIWJvuMo3mvj5DDJo4RxOWGXbhBPVYYv0nbP
	pN1/13CjOvr3v6OA7+lDwYmjI8q6OTg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jR77Mx2y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jpFXlRFA;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769705084; a=rsa-sha256;
	cv=pass;
	b=1cBNMfrcMVrCslDdPNo/Max95XgQI3Z95cHFhCVnAWxOKuOYiHkL69srqqCVSRrS6UbzV6
	5wWOyfhkAXFDz/yfY496PH+OHKRdD9M8yOtVxqx4doh2TOhRsNZQG3C7n7bf9rVA9h9uL+
	nryNgaxNeFVCbEqOnBa5yLvtbrzGQ6I=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TDgLPC299137;
	Thu, 29 Jan 2026 16:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T//YAfnJVzO6DVf4k3
	ecrSKiaXRDycpG04lRL/qoKYo=; b=jR77Mx2yEFTRwklzzzFub318mHsEeiYj9x
	KT+uOEmkjZjiBbmRStqU57oTw6xT8zCiDH6Ke/Cs6PXPOszf91PqyJjUZZXjC+IL
	7HnAf/AFCN3EHaCjB0Y5PaxvclK5I7ENNWUQVEDZ0Il9puuWXePXepwZPc9YdOqD
	kG6sL0rdJQs9GfSVo8ERWgI2YN/q5DBIYLd2VxVDGDlfXAhFuBHb75pjNl0Mpjlw
	/kuAEFCy/lIDO0dX+LUisho0oe43FM2+OSvl2+LKMNu53TPFpxYSf6JqaofSnVer
	URbD/uCm7jsiZYjbityk7zGcz9J4YojReRcNBOqnRm3uF2yq6UEg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by39rbmp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 16:44:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60TFhF5R010020;
	Thu, 29 Jan 2026 16:44:35 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010054.outbound.protection.outlook.com [52.101.61.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhcjnt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 16:44:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHNPB8d90wMGO41DW0nO0baUDofbXQEeyKniT9nOPJU7Q0wrlc/ME24M+Ssw4mJZSUH8QU64mh4eW562nEqWy7QJZCgbJ5HQivlCqYedPHl/idTWQ7g/GEOIHPrMdmGZwXnMdwUvswkdPsC75NDV66g+9ElPRl9GEiSXhzi08ZL0JzaRLr641OdVCsMDr3bCp/MBi2HYo7NDC1cK1A6sKq/cqqMP0Ah4ct8V497AamrISy9ifQkW58yWZ/ii7E639ijsckjHqEERjfBrrlMa0GceFDJACgKtQtbQlI7EhcUe9La50Nn4iolesDKNJav0RbVk3Q9s30gq7U1KG7Tg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T//YAfnJVzO6DVf4k3ecrSKiaXRDycpG04lRL/qoKYo=;
 b=wsCoWzi/XQMktp7gAd3rMOQxX5++N0bpVKz/BZWc9+85JxWBzIbu8c1rYiq2iR+JV4TK7dFrITFcHDINbLxVuHvdi6dGcj0rTb1rupVjXkr2m/2XcDP+o6OT3Xdv4uY6Zbhh+CfD4XwnI00Oy7BBvnAjYCn8ABMFV68n1tqS+7oCuuSq9xoWPhuSZJyiCoWle+UhbC8n9wgKBHZXgoANBmbP9pnXvaQuvoJKXwfUWQIuN+kN3uP0fAWu29n1Ymo+kbzPD1/GZyz00dCefXMeZHGDt08dAfCUiPngqJI6vUo4w55P5U1A0E9q+PH5V3CAWUtTOijrrWIdJLlfJ0vz6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T//YAfnJVzO6DVf4k3ecrSKiaXRDycpG04lRL/qoKYo=;
 b=jpFXlRFAabL3xaWFTko3H7SFsNk8s7DvStjbRLsOuBtRfMyDsllMO8m29fk4Ou6vDZP2bJ4TckNs+RMPanur3YpmFNwnZrfiaDmKocj1IJybmZWTLONdmuZDpVOCzWKv4UVG1k23F5E+1o0OhNZrLW7nhXDacRclzZqrOJWC+fw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY8PR10MB7290.namprd10.prod.outlook.com (2603:10b6:930:7b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 16:44:27 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 16:44:26 +0000
Date: Thu, 29 Jan 2026 11:44:21 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com,
        kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Message-ID: <aewj4cm6qojpm25qbn5pf75jg3xdd5zue2t4lvxtvgjbhoc3rx@b5u5pysccldy>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Hao Li <hao.li@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com, kernel test robot <oliver.sang@intel.com>, 
	stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
 <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
 <aozlag7qiwbdezzjgw3bq73ihnkeppmc5iy4hq7zosg3zyalih@ieo3a4qecfxg>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aozlag7qiwbdezzjgw3bq73ihnkeppmc5iy4hq7zosg3zyalih@ieo3a4qecfxg>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0080.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY8PR10MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: 894ca28b-bd61-4ab2-8d41-08de5f55a9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+zhjZLWvUR38ZXyh0PAnXAtJXkmYEjrWqpduOrm4Zl1eGgRJkQTgd50aDZvM?=
 =?us-ascii?Q?q8/eeI1EWlnsa0RJQOlcEt0+kLlu382obqMFLH8bgepPydQuaSRAl+WCHkU0?=
 =?us-ascii?Q?ECqFheHP1pYaQNv6jcmEmyhZ75Q7PcA7HeZ2zm9pB1+r7nHyev0HTfy3wDAt?=
 =?us-ascii?Q?Brhsc7ZH07QxQZh/WMMUKT8FFlC4h2clp54LgqSxqVEW1R1ndDJGvnrJAhR1?=
 =?us-ascii?Q?gfwWmOY4RU4aB7Sx8fVvN85v3ehNbH01oUtW3LWvHNYAjBbd7rIIofsHTt0+?=
 =?us-ascii?Q?lgllW3SHpio2FQEkClHbLZduidNZBMpMp602INUJp1fcC9yMDrVh3KpZtLRf?=
 =?us-ascii?Q?NW6XpBhezFRxAZF6c2uosM7Iy7ZadU+guQsCExeivjtLrSOmroUZvrHk3LI0?=
 =?us-ascii?Q?LC0R0rwHB8HPILsAZX/fMPeWyxHUpVzOyMu/6EefCkq6D6f75b92Yk7bYUYK?=
 =?us-ascii?Q?iX47k6+FhECvEEYiU+3BzSCvjWVxBPa+H1AlqUKqgyercPmNKDijvqT3uIwZ?=
 =?us-ascii?Q?Bk+fkiUc0NeRube7uS7tlt0Ni84ZD6gLQ4FlkPMfHVNKlhJdVHXKjhK+c0TW?=
 =?us-ascii?Q?JfwIILYIe1qCObig5y8OU1UaD/QqizCFAYLoJG4G2/qYs+1txQlgN5yb5x1Z?=
 =?us-ascii?Q?RlLiiCeFaWNmhls4pGdaFMK9kOG/xPgubG1uqfuOmpmzH+U9yC4zeHb8R26S?=
 =?us-ascii?Q?Yxoq30sbUKoa4Fivmd9poR5HTvzIoBdgkzn8QI24Bk+PIkgk92D0aqV5eHJr?=
 =?us-ascii?Q?2mSAb3HWHv3lreIfts6keNzR01I/kmbgcey0+MsC1Vjotkk8vl8yAVwKDfDz?=
 =?us-ascii?Q?HOeOdYpozdGeI2QQXuZ8G7ji/qcKDxk3s8o5LJ6ghagg5bf9h68QGmC20f3t?=
 =?us-ascii?Q?IauH8MadUmeskrgMNaF2RzQzUYIfWhT/eKPnTya71g1gvIF6P243sVvSrsrl?=
 =?us-ascii?Q?0XgFaPHFcvmGRU9vdy1F/qbfuVnW/4RhepPvFSleHyF+C30pNBafsjqO9P+u?=
 =?us-ascii?Q?THOMyAsCsryuDQ1Lz0rgo+BsR4UHA3dw6zRewDupADay9FZ5zWIJ/nzPYl9O?=
 =?us-ascii?Q?56ImXjr8aw3s4VJX+IfckDqqRgd7bGQy4WpJmDeqB/LgNNaO09avQuppDHy4?=
 =?us-ascii?Q?my4NnH6Fx55ecYwcda9JhHYXZT/r3f6vUfxw2rcgDF/Iz1Dwv9/hE9pR1ojp?=
 =?us-ascii?Q?qDkIE0Gnmvg10az7ireiW1u+L1MUKVXgow4enjmeIexqloiEQmuBICSVmTi3?=
 =?us-ascii?Q?QL0kCfXdybdOomRD74ZBKO5jft7iCN6YG3Gc5Nejd7tPgEh/Q/a+4GaASppT?=
 =?us-ascii?Q?4VV/SoRqy42Yv/rgexmnJQ4bF6M0UdsVVN5fKpYZiOj+swNX2hRc3Z/Gaq5w?=
 =?us-ascii?Q?4LViSQRQXb2L4glh9UIF00x11DSG6d0FzQ8njpZCqPWzHjcrRQACT4fXGH9k?=
 =?us-ascii?Q?LqG3Vo0x2LxzoeV4a4uRSJCvqeEgtd52Y/wWATAfEH7gYdTv7uMhwnvyGEg+?=
 =?us-ascii?Q?UObUEEgg2rznNENWw+C93Bh+ewuGiySLqZOnnXl9RPEEbd0AZqFbTtL++uUN?=
 =?us-ascii?Q?l0XFHIhSZmkKFmINynE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8BcMrlGa6/VECXyvRzwpxlEcjwduVDfAJCVzO+GgLmP4N6B9GvcwOrPaz2jb?=
 =?us-ascii?Q?cwnYfKSmw9Yp9ucNP5vgswTOn8kB3R1Wzb4OKDXLS5OaTzj+pGPRIQviVo3L?=
 =?us-ascii?Q?D2gzV1bLlgAf4e8ygruJAAxPqZg97LhQeVRwsaxl2JJV+gVFLO4UaaLg/ZF0?=
 =?us-ascii?Q?YRv+I31trX8N7ZInCnFo+0E8uewMhbJjfZGBIsnIj6ggsVaTAENEA+eoiYNv?=
 =?us-ascii?Q?t91g9hA7Tupi/Weuh3pO9OGWzRkuwj1mUaelc7UOHoz6ygLpsQ91IEQ0jUTn?=
 =?us-ascii?Q?uVdq7GyeSvjo2NTqdbJtz2OqZnzeaF1XSvzP4uI6SfEvCxqAwigMgGf3HaXn?=
 =?us-ascii?Q?J22nE4eI2bDhE/LoEELHq5AAXdKQYzr9BdUL3GPIPcqq2mz1FMfn5bbt56Co?=
 =?us-ascii?Q?cKGBOJdnHgmOcwvSoFS/aKBbSXcGG4x86TFg5iQyUUZNNZ/3cIWyoo/d9gS5?=
 =?us-ascii?Q?8IEVTUnX6/s50ea2ru+HDze/pYLOY7R+V1o5XAkxtbWxr41SsLAhzfq4fAhR?=
 =?us-ascii?Q?ZeWqTgoFM/O4Re9Brjg5ytYr2qSDq4njLS1ftfuSsfevHdorcdLrwyFdEntw?=
 =?us-ascii?Q?+XaTXgRemK5q09rQyhcYt28qbpUpzQ+XBt5wDKAMtf91Yl1haA73M7m3zpFF?=
 =?us-ascii?Q?ih1yJlU/dzLDlLCyL/CuK0TbLUWRWX8LRGIAjYlEUzU4/5EXC2cBdzeEfsuP?=
 =?us-ascii?Q?4yczbJ+Fbjr824evcY1augO77ZArQOAlODbABeiMRmk7KSjR21/jOUiWAzro?=
 =?us-ascii?Q?hkwqgWxWkfR0cHmBtfCInkFnvsrYPqwOqTdNcRjsX2Sd8LnTKmcXy9U0ykEc?=
 =?us-ascii?Q?UoCYiTCrLXQTsLn9X1V7iNRSDsSr0BHlndf67oqfokuhbQHyP/YoxJgdVrAG?=
 =?us-ascii?Q?osXny3FqrIrSiVTyDhuNVAvJjw1zvIUpw8BbdSWeClBPA0/0doT5daROUMDx?=
 =?us-ascii?Q?YGPfDlyuFhfKLmcg5bRUpV1DehvemSQm6KaL20SYbljH1EJ8N8Cg7Sq6PfJG?=
 =?us-ascii?Q?XZBDnrx0glhSL5rb3oWwQvRf2JMb+wuGrNOHs9zTW3MYpD0iEIcSL/pQwQaH?=
 =?us-ascii?Q?QrVhGltK1ACvmuLqRdKXbsxzWipdSCdI+hysIKu8TH+Q9mZyJU1UiGN9hq3f?=
 =?us-ascii?Q?SbygLWlaoVmI0UgrmKEAROikddSfB8qzBZpv10BXpKIckNH/yq7SFwS+ng4X?=
 =?us-ascii?Q?nKE7r25v0tD9OnLAXt9WvNFMlhlYHs0Z1OMA7hFBDCreQ/JEdoOiOdhBIwqi?=
 =?us-ascii?Q?0vs8l7Zdhd0APgziSi6Dp/RAhqJO3itXNe5vvpq/AL9uTeV9LqUvnpNreIOc?=
 =?us-ascii?Q?YbzLltd2GeeoVz7hHpoaljs3SPFFpwtB2KC4nRVs77rQrnAmGa2mmd8bWVbm?=
 =?us-ascii?Q?++oNZzmr5NZR3cZlgHd+NIlhBrHvhjVKFDFLzXvGjPklGY+M9IEfZsBVyvcX?=
 =?us-ascii?Q?UZoVH5SfvCALeqXCY1sKvc8fHyBggoag6xoBdNp0AgjZuJaQrtL4d8eyZlfG?=
 =?us-ascii?Q?fFgfXuUc0E9DvJ7rDlhJpkGFWlRCCaBPylQpOQbML01lsu+ndSOWv9hpS3PD?=
 =?us-ascii?Q?rKJRjmq2t11oW1A2xqD/JkJWjbP2NA4ssK1IAXLLEZXBCwBpoFQJWH1dy2Vx?=
 =?us-ascii?Q?efMNeAJPTOeuntfRnXK9+/wWV2ov3lkSPNYax7lS5QDJCxiJQkCHnAHoXSDi?=
 =?us-ascii?Q?MJpF07Tve2Gh75Lp8SNHY2bsiisa+N6/lUp7E0RG9JhoNskEc32jedb2MmFd?=
 =?us-ascii?Q?z/QRdWJiPQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LStf2ajFj7dTSogWEtcSwcdLIX5B+I5RZ7rbGtLlLTJ4m0oNwf2CZLXoJm+QMVEhDuzmHP2EMB4qFiVBnsxQSLOBM1qSseEJJQ/E/pmGjSglUcoTRjN/MEgO3JlGpC+23IIRrQA3+s5sCUGxIPoW2nWsDWgc7LUiQfGbzuBn25K4DzHc8jL5v88hJHCVGj5H2+yKVscQE5sEivA1meuus/lo7qq0uA8nWESWcCstSRmkN/eyFAhzmDi9657yibUq30kmzrS3mgV2Xx9uHKR0uP5y20+zOqo3ri8VH7Aru4h/FrDoFDcWG9b0jclE8vTVVtBgsb9YEcYeoS7aPhvFMo+YZCVB0iCKmLyfQkq3oLDxaLQTAlcsjdNGsWNbbhOiRmNqDtB2xn32u1Fnt+9cj3iQ0Fz/kPKfVhtrU3CLkr3xhKiHD3+7X/eTLaFfs2/VaN/FivbWbftGN+aFUpXvFQyjjLnY79UN8S2s/aTwuSar8+bqqX7rkmskvQY4t6uDt1gwp1gm0Q9YqqES8UrT39Fq1GtyYxJjCsC3V+BSuVG+xEXfzw0Xub8Epd+KkYhetXx+s9Tr4JctCVcWdYlZ2C7mlYX2t+ZugmeNvExH5Lo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894ca28b-bd61-4ab2-8d41-08de5f55a9c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 16:44:26.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hE82nWmvngBFPPJYYAIH5+KaZ1DWuxCpKqPSB++kk/GkEnGrZoIR5zHYKHhhr2XpSI1qRagT7T2YO9Z4+ghGMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7290
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601290117
X-Authority-Analysis: v=2.4 cv=LaoxKzfi c=1 sm=1 tr=0 ts=697b8e73 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cd61lHIqFd97GbbyCNkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 5RGPxr0kEKOqoVAFiMqfPbSJsdC6Wwvd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDExNyBTYWx0ZWRfXzZfQZV+WXQoa
 avmYFuaPfnoVMC77YlmZTHr3gBFkX/tLFR4OY8eY5xz/ejDcdUASkxQI5iEJ1xWitMvS4v2t7hh
 43lIILUvZyyLKvBGSLK1/k70oVXrqbONsaVH/EUUkLGlVCYBFHhDFMPeAp25efia4j8YIxYugfy
 bfRpQ8QeFoNtaP7NYo+J6mT16zWL5j53WZhB0571/XHg9IuBGg06/4PY60MD0n2chMOZUFPmrVA
 yjGkDOTkOIazomfXyPpB2Y13aFvFp0ADzlnBG61dRZXtpjTZXqgJra1IIjGfb0lR7kVl9lVdTGq
 1qoircAsKyzPIo8BLLFbQ2WunNko8pwnrYJy5e+KPz5j+1MaDB8qz6pX1SMRy7C/KP9EMfS4Lc0
 k9b4bgefashpW/Vmm+WnSa/qGfVYeHRBgsfqDekVqMXJkTZjZv3K03IXf2I7Om2NKhJ2P/lJ03n
 pqpaU6SJx2cp/ZC2NQA==
X-Proofpoint-ORIG-GUID: 5RGPxr0kEKOqoVAFiMqfPbSJsdC6Wwvd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BA61018000E
X-Stat-Signature: a9jwomybtfu91zuement4r5bp6g4qir5
X-Rspam-User: 
X-HE-Tag: 1769705083-533084
X-HE-Meta: U2FsdGVkX18E4R56EKovULkNX/dLU/mgtPUFfTWXU4x46khPA9WJsvq3HiUWb5fFqt7ChCMDepuSVkONFpwpmXiPNnPgotSCosTDOfKiwbF6Edf97TkcIdUGc5TAs64IpKbIbbRecoRquMRtB++yYJpjiXoCt1J77hVn8dVClqXfIjcIxaKV8rrgnxr+nkjqxO6ad5ziKNfEZkG6C3t15qInsWrgpHXXcT7Y/XEx2a8iXrl1t2wvOaapXTWJAeo9JGO4X0lIZPYXIscPBdg8pegWJzzjo6zwDy73Siyo/B/fp3R+6ATiSoKK5tFk0ViCCfNBoyr0ZGRlxBhFpc+Cv+zswgq0N7G0MRBsK+enmxzvvsOP+qwNS7C9u5ikCdPLelPkP4mHWqk87ZZktDKVSHXXvOW/SbG/ckuu6BBDkYvVRSSfkaFfmQ6Z4eyECxdfqsL0fg94WoPTqnPIxOY9xB1o0+Co0G9a0E7DTDIuQ0QNdwUKZv8YVrg6a4MeF4GICB0GAe4AQ5IPl9UYcVYPx9NNBT8KLzcW1i3sOsmILsEkPmiPyaGEQfPeYdxf0njz03Tr75ZCGZ7aLFakeM4d59nauGzMYkER9QOlymcZKsvnnJGon4sbbpBKRNkYlYmPq4HAyCjMUM6Yu0b+A8lKEEYURdlm8LLAmcVzk28iVOrqq8JmUyIZfKndmB4AEGSvPbyVuIErzC77hcXVHNq474RODUJJrulbV7ZarN4nbmDmQ3HbbpaqwZxsAmwJinj5qB4ZiFgzlgI7E8UkZ6O4fCcWwYBBZj6R6y0ukHGN+QdwxX5iPAtPvSSMHFqlRKTjGkVSiAisFBtQ1ZdCvKC+OOYlApo06cYKkrF599jZbs9NqaSP3aPegeUriC0G3mIn2HsWp+RhqYkSxV27O36CwPJJIgUh9oneJD/SDkfVNcHQmFspAurGpR0Uj/CE34KLZCQ1kCStFTzf0b4OhXn
 3ay5KMl7
 t1c63A+c/1mKOdMc/9//mMqdUv4+YxjhVkaQISGhfJj2paQ8hWbuTm/0U7AJX5SvZiqcgo/g+0pr9+q/VafnIjvcsYBJRQzAQzN90yPDMK9OXFyA9nh35LVnrHlUv2t0vEmCNsgCJZPl4v8+wR9xxBnpsyoE5iL01GuWmLB8Vl94fEAI4T1lVyZrdAte5U87XSXVaC+LBzUoC+/WOHeLqBj/tI9WMlgbNebElZGVWTpAJqk7yhIUnUpAc+DvNRqgjz1CkQ6alR6NKFXEDfuPfLd/UzcTNgTMwmPh0dAlm1HhJF1g7Wsfi0k8NW9xmjmVBmBT+yGmFgu0oIUwu6HNGmdXUPFtbnFi7TIyWB8TLu9wbiCHATPCrwRV1UGMlBu6GJ7IyeD66l8+mHWUF1w1NW+y2S6vqJrD0hpHN6Wbh9cGsGKD4fqFtVhswKxna9qwUdWvrYVhy9URlsq3h25N0PB+zCA0gsjHqPJPvlgElMM+fb3TKnGqhvWlCpuKDpvDHfOXArxVkHpsnBUtivTQKWHKK69rFrAtVg7HG0cghFckbntyqEILYCB1A1H6zXsJPF63G9Sm+p2iP64y1+tZ/Kq5DqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Hao Li <hao.li@linux.dev> [260129 11:07]:
> On Thu, Jan 29, 2026 at 04:28:01PM +0100, Vlastimil Babka wrote:
> > On 1/29/26 16:18, Hao Li wrote:
> > > Hi Vlastimil,
> > > 
> > > I conducted a detailed performance evaluation of the each patch on my setup.
> > 
> > Thanks! What was the benchmark(s) used?

Yes, Thank you for running the benchmarks!

> 
> I'm currently using the mmap2 test case from will-it-scale. The machine is still
> an AMD 2-socket system, with 2 nodes per socket, totaling 192 CPUs, with SMT
> disabled. For each test run, I used 64, 128, and 192 processes respectively.

What about the other tests you ran in the detailed evaluation, were
there other regressions?  It might be worth including the list of tests
that showed issues and some of the raw results (maybe at the end of your
email) to show what you saw more clearly.  I did notice you had done
this previously.

Was the regression in the threaded or processes version of mmap2?

> 
> > Importantly, does it rely on vma/maple_node objects?
> 
> Yes, this test primarily puts a lot of pressure on maple_node.
> 
> > So previously those would become kind of double
> > cached by both sheaves and cpu (partial) slabs (and thus hopefully benefited
> > more than they should) since sheaves introduction in 6.18, and now they are
> > not double cached anymore?
> 
> Exactly, since version 6.18, maple_node has indeed benefited from a dual-layer
> cache.
> 
> I did wonder if this isn't a performance regression but rather the
> performance returning to its baseline after removing one layer of caching.
> 
> However, verifying this idea would require completely disabling the sheaf
> mechanism on version 6.19-rc5 while leaving the rest of the SLUB code untouched.
> It would be great to hear any suggestions on how this might be approached.

You could use perf record to capture the differences on the two kernels.
You could also user perf to look at the differences between three kernel
versions:
1. pre-sheaves entirely
2. the 'dual layer' cache
3. The final version

In these scenarios, it's not worth looking at the numbers, but just the
differences since the debug required to get meaningful information makes
the results hugely slow and, potentially, not as consistent.  Sometimes
I run them multiple time to ensure what I'm seeing makes sense for a
particular comparison (and the server didn't just rotate the logs or
whatever..)

> 
> > 
> > > During my tests, I observed two points in the series where performance
> > > regressions occurred:
> > > 
> > >     Patch 10: I noticed a ~16% regression in my environment. My hypothesis is
> > >     that with this patch, the allocation fast path bypasses the percpu partial
> > >     list, leading to increased contention on the node list.
> > 
> > That makes sense.
> > 
> > >     Patch 12: This patch seems to introduce an additional ~9.7% regression. I
> > >     suspect this might be because the free path also loses buffering from the
> > >     percpu partial list, further exacerbating node list contention.
> > 
> > Hmm yeah... we did put the previously full slabs there, avoiding the lock.
> > 
> > > These are the only two patches in the series where I observed noticeable
> > > regressions. The rest of the patches did not show significant performance
> > > changes in my tests.
> > > 
> > > I hope these test results are helpful.
> > 
> > They are, thanks. I'd however hope it's just some particular test that has
> > these regressions,
> 
> Yes, I hope so too. And the mmap2 test case is indeed quite extreme.
> 
> > which can be explained by the loss of double caching.
> 
> If we could compare it with a version that only uses the
> CPU partial list, the answer might become clearer.

In my experience, micro-benchmarks are good at identifying specific
failure points of a patch set, but unless an entire area of benchmarks
regress (ie all mmap threaded), then they rarely tell the whole story.

Are the benchmarks consistently slower?  This specific test is sensitive
to alignment because of the 128MB mmap/munmap operation.  Sometimes, you
will see a huge spike at a particular process/thread count that moves
around in tests like this.  Was your run consistently lower?

Thanks,
Liam


