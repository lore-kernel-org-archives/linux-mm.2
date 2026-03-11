Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E1EFD88E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6EB6B0088; Tue, 10 Mar 2026 23:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64936B0089; Tue, 10 Mar 2026 23:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A123D6B0092; Tue, 10 Mar 2026 23:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD066B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:21:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1681A1B8282
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:21:09 +0000 (UTC)
X-FDA: 84532331058.29.E3FD98C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D0F01C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:21:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hv0gKaGq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="F/6mbnaP";
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773199265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWRUCZOIVgAqaUol9IcfAsuy0h2siOQCSNSW1Km6zZg=;
	b=kifHJ8KAU4ftw734sJcEUKHVNLCHe+PLKYCS2RrmsZ9Mt9GePHL6NH6Xbeoox/WrkezKsS
	nOCwJA4Mc79GJPX86QqY3m++cGXs+SAs8utL+dNbQngpzq9svGn9WIBQZBhg9FnGs0nWKP
	wec3CeZkhzaY7rUwqdpppARtIE1zDf8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773199265; a=rsa-sha256;
	cv=pass;
	b=2RMRqCuyk74Zd0DRIbCNAHAOY5W2iGgReZxaCNUERlRA5XNSLezzxuneQuQ9/cGJo9NCJ6
	IfmhLQrPZZzZEQDzJDBfdoh2QFggXvc10sdbFFVLMgvFsV6uFsZi159b0Dug5SAhVUgYBp
	y137hZb7K3oDVWryzZmmG9bPwZzRF+k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hv0gKaGq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="F/6mbnaP";
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B167iN3630177;
	Wed, 11 Mar 2026 03:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fWRUCZOIVgAqaUol9I
	cfAsuy0h2siOQCSNSW1Km6zZg=; b=Hv0gKaGq/jdzw8X1B/+okDZOaode2xkMY4
	/p8Si09Xi/Pi2VGxdT6edW7IMRNAEqhN2YR9kCd2EX5cATPwrLOsk7xXXUw4QNGF
	kp3vBpxNZOeWsoMXdxYzLgq1ii7KyJOEGX7CbuY9kCebeyVeqxgD2ORvgT4XObu7
	Li7StM+R3ymsKZBwbfEiL1C9ZYtEoT2wvWZCCsycg/3298NmxSLdPns4zDmAX0HV
	ybxhuh1bRh5mtJCQA0/6YtztKDwFWRTkJMYNeV+K1ihBELRoKr9HL5PRINv7naY1
	08pxWGotsf6h4T+wyO5Byidn0fv8Kd2fJvZzqePRhdoUWGNnNBug==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskua47uh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 03:20:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B1XYOj012950;
	Wed, 11 Mar 2026 03:20:56 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffgdpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 03:20:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n59owF9IU6IAHB6khbPRU6z5ea8rMZuP/2Rq35Xz7m9F8IbGPmdbwf2C6NFyXGFqz1Xp4sqIt34zRepoW9amzxlIYUJFDHCOeH3Q5H+eV3PfBUZLjKK0N5k0aVryjBVbTDzQ/8HDbrm791Fv+J4nwrRSUywccRo4e7Ue06NGLzhQN98eW/WEll2u18jglBfDqv4HXuXhTRnXpGI7HVP2vYfAjxD0Djv7NkfQycHbEgXdSFKIlKFZZTUPSRwlJNGXAejODuvYMCIH8nXyf2cRtUkiP/3pWsHlUxJ5nBeZ2x6A7Jo/u24eEfF/F9uGlR2ViC339Ys/fIJ28NmjRalIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWRUCZOIVgAqaUol9IcfAsuy0h2siOQCSNSW1Km6zZg=;
 b=ctEcPi8KtHE8vYrqmMlB2ZvwIg0eqT60GkNtxWT9U/S++3FkZCe8nIoKmxhyQEE1UukoZONWZTZggefg/DQQstnJnRT2CBnQvll1YKuDVf+ka51sQqcMhId+PVe7KNIA+5e8XjH50kUoTqK6X1F1Ny7K7EAWN2j+UaLK+uum5LZMcqxyJaphsi5vHsJOEKTcSscn3FAT/jCibMR1y9B8GvwCZKESt82IPzZNNEzfw0dC5K4smciHCIS/C8KKNorbkXPih3vSQ/52VQPoFDFp9T64S4BfWko0tbMkAMGf9Mzhfh7sdoeckoilJBPnT4xsG7AyWWKbQLKqtqYLZ249Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWRUCZOIVgAqaUol9IcfAsuy0h2siOQCSNSW1Km6zZg=;
 b=F/6mbnaPASc3LZ+aPgPY0VUe/i8lb4dNtWnk/KHjwyq8SnjUmZrVVsYvsvVHmsEt7LdqypFJpNSQWlwinJENkNDLyoYz3KGSMRBrxD6SoIwokuQOt4hsmoC2cZNaIO7rmg1qtO4xxYbEByrENo9oE+jZZd4M2pXOcCyabkqw06Q=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Wed, 11 Mar
 2026 03:20:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 03:20:52 +0000
Date: Wed, 11 Mar 2026 12:20:42 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Qing Wang <wangqing7171@gmail.com>,
        syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
        jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Hao Li <hao.li@linux.dev>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <abDfiqS7A8S6TsPd@hyeyoo>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
 <aaeLT8mnMMj_kPJc@hyeyoo>
 <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
 <aassZV5PjgFx8dSI@arm.com>
 <aa66XJDX4QfmEbNA@hyeyoo>
 <aa8uByvL9GwsGfnO@arm.com>
 <abDbxMmK0XEYgM1b@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abDbxMmK0XEYgM1b@hyeyoo>
X-ClientProxiedBy: SE2P216CA0090.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: ab10ed20-80d0-49f8-c10d-08de7f1d32e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kpQDv/+IJIO6ZTu3XrUt4Z5d7fNb4xVFalaEDENiLiWiXsDdOMjm5DQnK/9svOg25ZZSamwrIWmcWlU6If8Eukm/vRb2XoOjwP4rpHA4JRUQ0XNUz1jWn5tbDoRwQ8/Q6x6a5tEkHrtgDr+1vZjQLZyJcObSXwV/0VpSbFEMxTeDRjv/avbRfTOAYpeGPZgsM4riioliJ+KSrpJ5eof4PASYVcubuUCHrOvq273bYoZSJi6loITTtqTqnhBr21aKYf+xKcHsTEC8kJl6Bkepbpcv70V1uXjtlg9Q4dvqWN/j8t0ltWq5c25rb3wlmlQxm9Ed6NcDsvzzcS5IL9o5vyRunfSo60PkIlddwi1IjzSm0MLUh30MXfEr3gtZRkXMa33JQTqd1xK8GEjcnjWOMjMuriXjpHZ4gyfR0zRTx/F1eQ/f0NmR2BDHLqSmZb+J3EftlwjSZIupPtV+64JIsjldvCOqD+2HDEYQVtkIfSGjVUl67BOiZj6jCJXuTTtQIlO+VRwiW4OdiZ6DHRm4gpcPH91V34XhmvH2OYmupRuRRypbSLEee3R1yeoeET0/0dMCK2e1W2SoOfCQVDHB8j6bVL05SZIeGizinqApZTJrI9v4Ta5zfsKVD2hv4rKfgwQoOyV686sGzPnVnveoKch3Ml+oPHlLtpBhe0BcaUvlt0fLvC4gAa307tbAWrs+yW/Tiu07an8djrucHSSW/UPF5oLVgJqbaTmax0tPjOQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WFFJot6shS+24dju5rkbkTZSL6C90fyGWCKN8lGd7Imgl+Yz4t5umcyc1iNW?=
 =?us-ascii?Q?i/r0gGKOmUEvW4EiANkvTyhesLKr0Z4o+4gtdqm2nu6HudHzYTx1bJcvyNEO?=
 =?us-ascii?Q?gibp1CC7b00gAuy129DUJNueai882ORlYGuEyKtxhP5ntZHJV2vQ9NcU7my5?=
 =?us-ascii?Q?dsDXXAodPnKt7JK8UKtfphZuUJ1oJQExDfV6RfCqiamr0VbtKrHy6NFM+vtC?=
 =?us-ascii?Q?bB6rUGobQcBAtoDmXMTYqcs/2CaKa4yGBxx37p8u83fdU6iAkZ0DKx3mIoAC?=
 =?us-ascii?Q?rV0p3YjsKzUvZEleVYc7VrLiyTIod2nEdTdmSsaoD+ihdzDrQM38S9KLRh5p?=
 =?us-ascii?Q?H4r7hTKmxvkZCNIjmLHFE1YTlB4k3wmF00k1fDYaRDpPL5fsURlkCYJn09Hm?=
 =?us-ascii?Q?g31eVvoM8tv/z37caU2A+aeMcEb25NNbivPjNz4lNWvF9C+PXtb5LYazqL4y?=
 =?us-ascii?Q?tHz/hoZtKnbnZ5/rQffoCo48crGbvTN+TkkBdekv96P5oycybWQHXzbpsU8J?=
 =?us-ascii?Q?JBGgj85bRTWKMBaqIFGf/2V/4wCMF/0y566ZMJlCLO5up7Gt2DKvaP6GjJ5H?=
 =?us-ascii?Q?Lqjhu8b24OPcpH5A6iEUJDMina5YrDjQ7lji3efg4nwKyTkrWjTSM8YfmsAf?=
 =?us-ascii?Q?A3NFikLkNYsAO1PSuDXlFvyxfT5T4RPecBUHYpQeQM7oNFVAZtbEBfrIgyPs?=
 =?us-ascii?Q?K1nuhNql8BLiVpr3F1ciuKuDJuwKod8jB4XWIC8g+ZPrRJnR6EOEHBkYaRxe?=
 =?us-ascii?Q?kjLAC1eVFen7sl/ETGf+s32PTDsR+KO871fv/Ua0EhpGske4XS1iUxkH3y3e?=
 =?us-ascii?Q?Mq46p7LWSYb1yaiNfK8OGBa/T9N5jOO/HOh2Ha5vmOMQb3036mlnvDq88u9T?=
 =?us-ascii?Q?qU1cPn43XAmEaAf/E9Byml1PjaXPMheamUlDVi8EY7MxEUzu4n8xnpfLq8gD?=
 =?us-ascii?Q?sjtRgVpTK4vEM/Z0bOD13zcKvQxSL0TvQrRKWNhmCqnAmVOevFWPPfB5e1Ki?=
 =?us-ascii?Q?xUMjWn3+nLlt4n4q1K2rt6At/CvdMp0m2A5g74DgW0+cHUeXiZyCOJRXM+f5?=
 =?us-ascii?Q?KKs6UgAcmZhlyalgpqqWipMoUYjdyvf6C9UfzX9YQAJsXXR30qtKv+BqMrIc?=
 =?us-ascii?Q?0I/j5B6nVMapz6VB86FuF7HEvi8Eh4mxpYqOwG6TRPxD/Cffcj0/5FlS71HK?=
 =?us-ascii?Q?FftXs/pD9x40U3v0sP8I0dT+ySZKxbQ4acDxzgEYeCBg4ndxDIZFPl4CJuRO?=
 =?us-ascii?Q?W3GBunvL58qz+KZLtauzSvT35S1EYZNGrrofw20hK4Ga3B3mUjgp13hUGKkU?=
 =?us-ascii?Q?hWmDzKeJ8wNWkKsQ+oh/9b8Wx/EsFJ3b5DQOqSJ17XwEqFfxx6iI0g5c9L41?=
 =?us-ascii?Q?M5Xo2WC7KJchE0Jj9vHe/n3K0EEsszTs3vXC8gtVifGmO9J62FJrj3fdo2D7?=
 =?us-ascii?Q?EfqF6vcs1QWT/g2VVbavrYjZv/YaWrCCUxDGnRQmm3NrtOGuII9f700CLAsO?=
 =?us-ascii?Q?a3DjVJ3+2T8UbLI5v3UrfHcRaoCoY3yWnXgfmuEouUfV/oK174Wy9qYoEPsp?=
 =?us-ascii?Q?U4zlQCCwVMcq/7NjOR14UtPk01f4ZFjYk3d1j/UBrKgs6bobxgONw4rKntHr?=
 =?us-ascii?Q?bRteSerMZvYf5UUG+uGbhRVeaSDDMz2uWP7ZOVyi5vcJD4SpWWsVTOU/BtF+?=
 =?us-ascii?Q?obdhvI4jwaeJ3GPG+TQkCSY/8DFZutVHM7L91YW2r41F4Ty6aSjDT2O4/CfH?=
 =?us-ascii?Q?zsVYlq/PYg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	GltdoRKKsNS6Bsv2PYhAPodpVxMFoYfNeexOXb3L/iJvOwEdMz0u/Oj8drVpJlKaqYGULqwoo3iypM/bQlCwLESjlJWGcz8dFnYY0TpJt33gAQbqJUk72GkLyQDl78E44wnTLApCpVwaQ8BQCTOoXrQUtA2ZWDtzvs/EOF3SzGQAsnFQ0QxbWqjV4o6T/3UdZPWE+tCA3Xn9mEyizLvyn3MWuKlKQddzZ/QMXL9RHiM+GSaz+Ja6u5VXRltPlEXKHw/rL1esUD6Ct2rlHMiuDQb57I3JF014OVtqS37eTFz2tmvV5SaL4/j5o790juiggvVhTzcWjHeqU7TGSxDpUA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rr2BeikWG9sw5EX/LtgSqm4nP6TtdQmeTjkiWsw+QatLgFkH0vWCPXwd0ypHNsb3rVmCnByXVRZCh+B/kHH11CYgcq6LAGsLO3qXmr/EJHYdUNG9X4JEtme+w4RYXW5syytjJTxcIL4LG7ENld9Fr5nJ2YJGwyriviqm6wIo6kOf7saGn3CX5qBnI9z+BBg2oKxhn36j6btHym74ahmcwfGitN0LXVHvj3D03STh0W0jLieVaMgAIF5N0cIN/DXWNLCIAlowojPbEEowqtN9U8m5zC0eZkUnvPLrEeAzDrmWmlmVfRWjZp652eiy+1RMpreUzgUDRgwDCalVZTn+y7/j2KVgChYcOR+UxlfQWa7+3CrvFgHeiZ2JuxN7BZ4dpbdqI8LL6K+vRayx0zfkt+jlzLijvy9Ih2Pyv5KF/XsXyYJrHBYs3fbf7g13ky7miyTNmxWFmSDV0run9DozYU0rik+4e7U5TvtvCOahKAuNxvCanSGsHmgfI+j/f5gLkS+syTaoD10DvSETtaMKtVx2+Mnyac6AjcdTS1Vtd1rAuvCyfTzELuvVpjg37BB9uzoLNdQ4MurDU+667pdeqygZaAsF1U59uMaN7UFRBWA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab10ed20-80d0-49f8-c10d-08de7f1d32e2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 03:20:52.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auRsLeBIqoaXtaboSTZhnx1CawdT2w7J79vhIRBrxvjfbNZQ2UAh+mr511c6t/Wlpn+tEle2b0ckB1vnInNpzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110026
X-Authority-Analysis: v=2.4 cv=Methep/f c=1 sm=1 tr=0 ts=69b0df99 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=_DZJeIRjfaHWHcdDIicA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13819
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAyNSBTYWx0ZWRfX/ZWGebC5wp4A
 T4l0x/A8MaBLYDoat6ZdQEtJb5y4fL2Lof8ytaH/abFwkd1BM03/5OpECgw+t1rx5XW5661gfPC
 ugPAv0s3yAFZxIMWyJw2yy8FkDIcy7GbytrZAV1bjmk093nC17r+UvOPvG6duZ0VBzSZ8YbzVVd
 CFZdMif47xA61miZuC53mP4A7Y8R9p50qFd7fffekGvI5+bLaAhMaWCodatOmRjpQExqw4H1Zmt
 sIOMup11M5aFcrbYIEljGOJtRLuuPBY+Nhhp+sy1c4T4N0GJOT/fig2AYI0NSO5vp/ejEL4mV5Q
 kJ1vLattuzypCnRW2oCOmMJPTn5+42G5jYlhexR+Peo2WbxJqqWDejCrCYRih0aCnaT/yT2OeE5
 0FrMG3iXqmbYpgV1DfBcvdo9rOkvYBmTsuC7clIoCVywDLD6p2nKkfX+c+ohDVbvnidH//zPi7q
 pPS1vTtvsxbjvO6ka3CU8g58hfUnNpuu9jFaV/nA=
X-Proofpoint-ORIG-GUID: aHPGTOuir9WRX5kRQHIvk_ZY9Ybdk5tI
X-Proofpoint-GUID: aHPGTOuir9WRX5kRQHIvk_ZY9Ybdk5tI
X-Stat-Signature: ucnc9zfjyyr1d57ex7i7db7k1jbrnzny
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D0F01C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773199265-147506
X-HE-Meta: U2FsdGVkX1+leIB2B2FuU+mbVEL5173UJ9vPYxWpRZrjqqnjvhMr5ddlvN7JhESZ/vkAEec/HUzRfvHjJyNpEaC8oRs7cKdQMouQaJF8WAUOjxy2Y/xva22HMFg1bsm3s3huOEB3iqnPlbtdEIsIlDEWbG9f0GnDJycaK43fOMNGh4T/PRmha8edFZ3+y6gnRxW9N00WmSXjZtBk3wfF2gAw4h14j+JkYzuUvBHA1fNFYx1IG7SZLzkiHuUskmI8/gGYJhrEptCaq3U034ya9NIxE18rFOwvLT1m/F26EKiqbBtP3OQYLD57fKAOIqlvLHxVMMhqPAdrZ5bfh2zW8dmx44kJzpSHTa3nvBrVd5TwYQtzeWwf/QG8uOi/bszT8WVdQQbD3qo+sY6tsbvO9fcSQ7ckTmtQBqUdnD47LldgSeCK29ge1G+CWM4sKshIPgHqfVZasA8maUvyly3D+0duSR0EldD0BoZv3mMnGDi72GhkVBYuBP0sxp/sBUbhXtUciy43nNPqwmbyg8V9eoEVRBQLAeKAEAECMgsIExBNJO2MsUMqzvzE8ADOY8B7ujc3VivBOsuLFLREhxltqMe9AAOSPK7vz7Dbtad3Lsa19O+x1sGRviMeTsOS0MziS+5vb+x5t3dSrPUr+VQciAYqgdphn5d993Gn9jW8+Z5lqLdrC0yLgX3z5gywQGrbXb6XfOE9Y8RWcyJs6mHUi4615z3gjHv0bJZn72+ONDehxYaamyEFkgu/Ajk+T+m0g37U/oRyXn0R90Ub1Wm2xngCFNVx0TkW/S5NAGJvxAvApausFBNshGBTEBkQIqCEzfTfsFkGGTdE3j0dd4tzkLJja5U9A4etkgkD0pwWeOZ1suE/Xis6vV9mAR3xrgATaF4FGzj3qVRjSi731OOt5RVpGmS3TbQ9ioRLSGYcVYcNun0As5DCgjk3gEnXUAsH1ae/v9yg6HlXeLtkCXU
 leSDbQX2
 XYI150cWehD6ApnR/DqIT1alIJueuF99vD/igNpeQ++1xK6YTJ5ytX2WveF0gHBzSd/GyuLu3vla122csEaTLdmRCfQj1NhwhNkmqE9ATOp5GqRWtAltWnJupu3rlgdXELG6acwVcEfgRko+FHsm2j4TSYDcJRDgH+V2mqDE/kQT4Ugj7ifWsLIqP3H0x7hkGTXiDUsd3xMIFnkYx+DIhsQ01UVh7cI7p2RwZ5bj3jKTxWb1IlzocHwyB1+ePlvaUyBOPR2CQn5biVVSI/m39EVPHS29uBUixNyCMUEoBL8JWLwtUE8Z/DLpmvWPNowfEOfNINRwnXK8cqhWVSrP5V5ZWUhvOiJ6i+NAUYLDsbugez2MwkDbxZYx8ETaZN2RRFpO3qzc6vKdeKgzZ5NZXfBCF25GfOy1F3YYS0KfNN1RjiraXqe9MOLR3cvJMB4vTY9pCIOk9HSiYxG/vEBfGpXeJ3M8qn08OJ2DaMhuz+fW9MKTMRCfLZs21SC4F/XDPL2k9D/tnfscGfj3CJ9DdbJNXXwnMZn+C1ik5hGi9aPaTaeWMs6NuIfCbNElIjWRCuTBOKNxN1od7pU0qziaxJxMDztDChJYHUnJvm8rJm98BPmB/VBpo4Fgiz2cHMvl18of+pPu84obtUxKtQhVIYZuuKNjz/yyci2Bg/ih2vejoz90k4bt0s+ycuF49NoNY6OlnHdRBgOUhDplk2bqghQfIpJMlbfRBNLJ1MiveyRO9BnFeF+n0v585dBFQucM0Kjv7qG3KSJ6GsEF6anewVRZq+vscc5Dz5xsr2imD7Hi1Cn5GmFnd+av2MS/5G7ibHHwOiT+azZSTLGHkZFUofPPER6IrDIA8Ir4o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:04:36PM +0900, Harry Yoo wrote:
> > > > -----------8<-----------------------------------
> > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > index 0c906fefc31b..401557ff5487 100644
> > > > --- a/mm/slub.c
> > > > +++ b/mm/slub.c
> > > > @@ -7513,6 +7513,7 @@ static void early_kmem_cache_node_alloc(int node)
> > > >  	slab->freelist = get_freepointer(kmem_cache_node, n);
> > > >  	slab->inuse = 1;
> > > >  	kmem_cache_node->node[node] = n;
> > > > +	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
> 
> By the way, this should have been kmem_cache_node->object_size.
> Because... the length of kmem_cache_node.node array is not always
> MAX_NUMNODES (yeah, that's confusing).

Oops, please feel free to ignore this paragraph!
I was totally confused, it's not size of struct kmem_cache.

-- 
Cheers,
Harry / Hyeonggon

