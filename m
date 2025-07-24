Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09DCC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077F28E0074; Thu, 24 Jul 2025 09:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0285F6B02BF; Thu, 24 Jul 2025 09:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31E18E0074; Thu, 24 Jul 2025 09:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE4F56B02BE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:34:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 888AF1603D9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:34:32 +0000 (UTC)
X-FDA: 83699252784.25.124507C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3939540005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:34:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hyp9VFVd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Unukcs9I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753364069; a=rsa-sha256;
	cv=pass;
	b=37QBmJ34lIVKX7nNZdyBc4p5hZc4cmlToO9ltSl7JksZNGbFuGmSbjim9T19SdpYv1S0ED
	xUQhZtWVvoLAuSgBgIImH+iqbp0dkfLfTrU37amlC2YiizI/DhPUwbITe+LtcDfdJViSf4
	st6DOc2LzB1R4Qa9YEOEsd38/qTXom8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hyp9VFVd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Unukcs9I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753364069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=x0mppO2il0BYZNwxi0AxPu8GvbnFpDa9BjkC2iQ6KSQ=;
	b=K+CfPXV6HicF0cyGZubl0NotTUu6tBqnU+9A1h788vDmX+veRXXlrpQZNX3JBcyQors/rh
	wxGaiBbwtNXzWB1pC7Bkn7DGgV5b6YTgGi1qSrxsjuBw7W0jdJAVZPGR9w04SDP9M1daSf
	2wrDXFZemam47y+w9xKhWDWCMZtOzBE=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ODRIng008343;
	Thu, 24 Jul 2025 13:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=x0mppO2il0BYZNwx
	i0AxPu8GvbnFpDa9BjkC2iQ6KSQ=; b=Hyp9VFVdyb5lueOu/h4C2DYucMxzwXqF
	6hSNZLWwvO/nJTMY3bBmVKBP/aWzrghDYRgdTofbuCtaeWUY3aMppXaplkqHEsWU
	ChlMWGdsc4iK+bgb/nNkYBchJM92isX6kBDtrSpG6Ne5nKoZlbH/YFGwy1BBarch
	69sUM/S+83lsGfipq1O6fgEtjTau6CRzDYPWbmh6M6Ytn8/SYh4vlAojGaywMmHv
	y0GLWvwob4itdTXmEu1tQM1nhiwjE+EbBjWv36uuUVOcaueEzSs+j2sdhJYAEIfx
	JYiJJpGX1l8k+OMP8AOKJ2L9Pto848kXRtmfVVbn2zuKo0l7FyD6Rw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805tx9n8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 13:34:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OC99ti014657;
	Thu, 24 Jul 2025 13:34:23 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tj6bra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 13:34:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uxsArRY2SBsPFUDGRuabSUP1PIuP0/DN4dpCyK1QVMahT3LPbsAVZ1jjTAj7EC8/CXbXXijbLT7sv8lrLQeNKNIubTXmetXDwJ6WUzwKomz8pHtOTU5reB2MeW5wNhgxXy0GbVEispA+FHLtlugRp6CqN1gUzkRWB6BRixqgXhNUl6OrFz/E5KpJR+7HPfBI3wZfCuD2AxtuzfZa6wjfgeBaMno40rI5+wqoTDMg1YvI4PhuPU/5GeprBYwZOApkau0bCGB+vBrVfI+tZMPc/L7WKivxw+g5757ktKNZDhSqpyEHYIwHgc/7ADtRDLkQVx/fdthkISO5eIzjPNlgwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0mppO2il0BYZNwxi0AxPu8GvbnFpDa9BjkC2iQ6KSQ=;
 b=yf8RD8pK67VoZTxKU9N6I722uGG3Al+qpL6xddzE8AlTbO5dAfR4uadDtzdYdLIzEEOx8jGgi4EtQ3Yq9fmsJ7BJPTGOUdp/u1aJqwEuyk+SSEhzPRKGfTluo/HyMwvNX4XoZz6aowrp7h0lmq8hLcR4H2bhNf3HNsX3PkVf4tXwiyZPKb2atPtErM3AbYwBbLRKWzeM94WWIzTFObmn2gz8sKKIlvJIGgVKt/xWe0IQIf+8DyuUn1/RH6gZL2nEMnrJ1FNU9GhQjJccwE+irV7U/tORGtyLB3MOa/a+Mtx35LATAhHBghZbF/mWOT2sG7S5Fd2aGJBPAFTu9QHtyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0mppO2il0BYZNwxi0AxPu8GvbnFpDa9BjkC2iQ6KSQ=;
 b=Unukcs9IgCQE3P2L2ztKMF7pXw1pVxjCzfubJMaSa6gQEq9U4IWFMN5OWh8MCt88OwBhsG4yvQrwxZ1tTum/mt9kUSKmh1rha1axILjmopVymoYUZvavsFHdO8rr0tjuzFGmdjzrIp/ZVzllvsszYnPZ+EazjNTAYsKhkZZoArw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6110.namprd10.prod.outlook.com (2603:10b6:8:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Thu, 24 Jul
 2025 13:34:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 13:34:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3] MAINTAINERS: add MM MISC section, add missing files to MISC and CORE
Date: Thu, 24 Jul 2025 14:33:56 +0100
Message-ID: <20250724133356.49487-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO0P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: cf5ada25-92b2-4e7d-3449-08ddcab6c7da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6biOasW3WI7p+lu+dor3DWOLomsdyOkP//2xNT7s4dso36Cx55lCeP5d02ml?=
 =?us-ascii?Q?d0pI45EFQjJaEkQra7NA/Oolv5CoiMOsu5IDthmP3xBRPMES2hFD1JRpXLzg?=
 =?us-ascii?Q?hy1Ht8ywGP6zSeI5ivn6YD3A977cAlc6M880+XdoFgVQQu8xR9lqoByqMp7e?=
 =?us-ascii?Q?ZXKGX1LAyObR5DE9LfCL/FizPMacbQ3Hli542hE46Xqi9d2EZhQopeNS35kK?=
 =?us-ascii?Q?xSo5TtWAUSqOSBVFF9z6e8csNxBBcp9IY1T8pfzta15VZ2xS6NAbhsONT9zH?=
 =?us-ascii?Q?xDa9zjWb2jYag4dpobH71pt5HNXGJ5XCIbMBS09xhzYuqExlTMcc5wJGWB3L?=
 =?us-ascii?Q?Yzc/4FO3VkJGOzh7ydTRuOAy92FnfUQHK67T1PdqG/wC7zDEhCYAunZttOaT?=
 =?us-ascii?Q?03qf6DcZ64uOnW8ozHqueUld9hXUkyUE+MhTV6qa/H0Ep016OkjK/n22IVWE?=
 =?us-ascii?Q?7KCGWJ6J/gKiz+0m4mtt2RE6P3DxHQLxcxrJ/MwuUnb2pDbGqS1RNKsLDVnz?=
 =?us-ascii?Q?pgjKJce6nBcztonf+Rbo90rdAJ+zN9FtBvZjrkJf2ZcIEVPNyLWe63JkykZA?=
 =?us-ascii?Q?0D2/lGzFyI0M1ALQt2lK5IjQNhBjTunqHmPw4daFBp3HuxMxIq8/XYDe7/SR?=
 =?us-ascii?Q?CXmv+CDAELA+xUW3Ix3TOWiRLcqWBT+2bcAa0c3F2pQ1IhG3NFpw0mxiNN5K?=
 =?us-ascii?Q?NJUrrPGD2TmXy6ZbgqfYJxwzcdsO+jrF9WgtzkE5NooPGukF6TGbq60vcwbu?=
 =?us-ascii?Q?ZFnZw1Vbls6UtMnm0LMAuCirRRVa2o8HhfRk78uv2a+8moSwG80U5TNmg8KO?=
 =?us-ascii?Q?RaUnCUfPKgvWgUEhopGi7E9rgzt6I6NTEqxNKkyQ8JFOtHufU5xVKjAnHoD5?=
 =?us-ascii?Q?aqCjx77qZLwFVaYTyrwKVJ4WQRa/5M4UZY1QvCZpy955lXrysD9p2yaY91GA?=
 =?us-ascii?Q?V8daw1k52+r7iBfbT8zfhjUCctRsXNHxLN8FyDLmEcaHTdIHoh0UD6bg2fWW?=
 =?us-ascii?Q?tWHCiEqIrycxN3gRV41IzTxa0BwyZOwNDq0PIpCHTp/nM/Nh6WK03QlinBYF?=
 =?us-ascii?Q?sc1k3EW51xfBWRW6lsNlbNwNcdL1JtHJ7oDwH6nkxhLKYbzL9Z7mnnT5dpkt?=
 =?us-ascii?Q?Zk6MFqjlqqs+IuaszSTFqM8Ip7m4789xQ1s44ezwzOLizCFrrIe+2tIQFFSM?=
 =?us-ascii?Q?VE/CfcPAx+H2LhFSUAPw4L7gDeT1CLFTprbAEAbL9N85kS9D680Q9+Z8/Q/P?=
 =?us-ascii?Q?F0aupiCSPDVxG0dmzKOOdJOsT+ge91UDpqDLgM6U/SA4g37ZRtwHjkzzj6+v?=
 =?us-ascii?Q?qY6XwmUn12k0DW/4VAbAM7Rdhns5lbWdZNPgm3i4apSTyOVplx2520ENhkBR?=
 =?us-ascii?Q?RxUQzUj0xkuH4SEJCZhL1XS1iMGt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CxJYPZm2suoU1a8sLsgDL37yXMWf7C4SUwhzkWJpxYs6LR4t8yRcy6b8Btmg?=
 =?us-ascii?Q?Mxdt23Fn5o4o/YMl12CwE9q51COTxEDB9gOhwkGiLdrSTTCwlXgULthJ+M8a?=
 =?us-ascii?Q?QDgaAevNMPuioiPJShNZG8tGLaRBzwJdZFwo7giKHxJ9CLak0mg8Ev5kYMae?=
 =?us-ascii?Q?XijcKXS+94+8o007GzJh+YS+070mDODviAmkamzKz8DdMy6qnZ851NRx3mst?=
 =?us-ascii?Q?zJQgCongBTXBuyBIW2FL1HBs7ydqC8Itqy+h/Ttb2mZSwJGrU1cyFFiPz8I+?=
 =?us-ascii?Q?iFxDR6c1oY1MgRVMFa4fmcQinv3PcTmYOnm9IfJD1WZupsoJwPpKrXdWnFYA?=
 =?us-ascii?Q?Ru0yPg3ERaVwpsu990YliOVQ4hpVareqD1B1fZzLEwdTjlxNSgfSNvQydowJ?=
 =?us-ascii?Q?emysgxlmcjaJhCj51GF9itvJMR+xnBWayqt0qnu5VwhEJc3JUXCaa6ioEfyu?=
 =?us-ascii?Q?j+lnpNVloxFDJ4sZjR/mD1HI8oGdb2GZVkV8URJSxXb1YmgEcruao1LTuj3z?=
 =?us-ascii?Q?8bDXkZiF47mOwxMOymN0WIC636nB7liCTLNKxgVgSoMxWA6c5wfoFKMUu/xF?=
 =?us-ascii?Q?ic4WzYOClataiSUDUq8YBJz2j/xhI/bH+57i34S4RGgegVnTEbGDFoeJTNbi?=
 =?us-ascii?Q?PdFNYcPZEYsUcFuAWJDgkb0rimUykjhnlo+B7ALv8tdkp7b4TfNiW8wsO6Sl?=
 =?us-ascii?Q?M+LBQRpYsOZSN107oD3b7sYJxYlLCz34IarFaW4ek2n/Zu29oo8NnPc/vvwq?=
 =?us-ascii?Q?qiHmJHR9dJdHGoM6g+76lO0c6O8Wieup0I6bkTsn5Nltp39OUoSJgmcTpilR?=
 =?us-ascii?Q?ywaMs6232Nj+66ABdc+4ILSZJW9XqNEXAdkOBm1wc+pVcqoKpbtoSXU0xndc?=
 =?us-ascii?Q?43w4enNWe1AUi3qUrIXcvLzzic345PmT7HVKdfjeHnk98dXYrubjN4wCmiqX?=
 =?us-ascii?Q?XZtPd3Ks1VfCJ0z6hujmOXmYfL5NUDOL1h7frXNm4JgLDGXNzwWC5x+xaKmn?=
 =?us-ascii?Q?IdCFhVS7g0lTG2dpRyGpec5LuVAwgkPPDDcygis487SUT5wp5lQcVNCIXzzY?=
 =?us-ascii?Q?gI17RQeqpeCRyJ+xiy6ZEqp+W9C6EmdadrT5W5dnVOAy7I+WbY36EFGtIucL?=
 =?us-ascii?Q?PFlRQpYymhjqmj4Iig48KKYP3XqNbQAfqLj5JSBlDhswkxiFEVjXKU7l4Zj7?=
 =?us-ascii?Q?hrIFRAagioOxL7n7/7R2ac5JDVhf1o3m2dHqnxlA7Fp1gSD3ICof5ZiHhU4c?=
 =?us-ascii?Q?lxNNawWy082KsdKGNDOG+H7UmP6yCsiHvWIlaX9/BddEyiOd0JgdRRO7a0Cy?=
 =?us-ascii?Q?X6Y96x/ygIuI75VEWptRI1dfG1z1mhPVShxMBsTpJP1W/frUt7GDDqP+BMxM?=
 =?us-ascii?Q?3R2xWoky3hMiQfLz+jA86rvfYl3prhtwR/Un8Z2ET2GyNwk6eplqyHwbMG4w?=
 =?us-ascii?Q?ke2m0TTfofXwoKp/fXWRrfrOmqiuYPQeqBcYcj2ttFNgVfoQxNrKNC1vzhol?=
 =?us-ascii?Q?3msJrjUDUhwhgD15D1suhCnir1+ug+Iw+5NljZ27GmPewj2iaGvZrgiCVM4Q?=
 =?us-ascii?Q?zB7eDGV2isHebst/+cZNbGmiVLpnlOnlx6zZWo4yDZjeZPe6DDGGIwrynJe6?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vc8o4RPQ2k2bcV84xcSrWatqnL5oEKGO4I2cOXlnyrzT0OvtfbMTW40AcFXxLvaw1YpBgtW8Xvnbf/G7HWsxtChlLmA6Osli1IRuxLKhCkcsoGk8bt9j5rO0hOQj2ZRVApm13EnJB3RpGrSPjtQmnzq9QioVAcwepeWGFo2oruuQM4Exb9CMzhkcF2DzNZTXK8bwKybqrFdnpZiqwVbhmnvBsVRbuSsM8DK7ikacpQQwPiskYl+UILcbltNEXw+fNHtj74V4bvrkUTwYjjBh3dJqfeqB5tCHx+NyhGKQvPUukKkywoCQl669hUgNhfVquX5qHT0zsiiMcgLWrqngLWjzPOSCPgcg+ZFLa95s32v8zApXYrGTp9F+e4mGb77TFFgSAJ4iazaCFm9s9qNe06cW5j5tU+jeXBCNE/VC4FgZR4of4NHPsiXiAZ0V2nkeJdytiVUb6tYTihNw6/ERikxvOmOvxfOK98fVj6+9XgKAHEetVSUP1AAlWB+8TL7xRZr/L2ek8M5Jm+RNWpuqx2LUDV840REk+TL7jEJqn5nO3IJu4Je0jUs9uNgxVgMqvK6DMV2arFF/nwoHAsOGnOibQ3RgVZvYMBw0od8x0KQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5ada25-92b2-4e7d-3449-08ddcab6c7da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 13:34:14.6848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5CBAR9XwzzhIMdpB4Rz2ikm5hL7uMb+4h68A9u6vAMvqB9vJ1FlJ1Ydyr7ha9yl6CjwHujej7PP4nqkTGH4KyeO286kgDCedmQ6108ZwWU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6110
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEwMiBTYWx0ZWRfX0OrOcsjd5QhF
 qZJ4dG9zEMRqNpWV+9Dl4jY5otsOlu3qrPH93/3KHtWFc+PG0jUxFU/6xYm98FU7ZXX94HLyWfo
 jipxj+OH/Xez2u3dLYUI6vlfE9UslYVRmXL67Dhqsw3TYDahkCJRax+HqA22sUjYDY5vI6p0caZ
 xHdf471XWkMJzpj7mPIA7h4BxMzQGqbLbKnbbIZju5MHmuGmPkG7ahn5dK7BBjsr5DRKjmeXvfC
 q/byABt7VnPuFIoqIdMXwuDhl75doY0BOHq88jwVh0I7b5EX157ZGsxLVsLCZAzDIJq+N3s6th8
 7IYuLPPtpEmpn7gjX8kxO7W7pNVN6UBDlKpAfpOtwJ3hRLBkEV0vDv3acSPL6GD+CDVzhYMRSpH
 CU8A6JxaFJnznqoqYUDazZtqKq+UfCm1386zONxMSvTbRM5Y29S0jbJsZUpab3b6pwL+TR6x
X-Proofpoint-GUID: 0nulXctdTIWDWLFRKmo3l47gG1JDFdk-
X-Authority-Analysis: v=2.4 cv=IsYecK/g c=1 sm=1 tr=0 ts=68823660 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=1-S1nHsFAAAA:8 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8
 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=zzIyDT9sRKWamUAvEncA:9
 a=gK44uIRsrOYWoX5St5dO:22 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
 a=WzC6qhA0u3u7Ye7llzcV:22 cc=ntf awl=host:12061
X-Proofpoint-ORIG-GUID: 0nulXctdTIWDWLFRKmo3l47gG1JDFdk-
X-Stat-Signature: 1smh4sbu3crkrwwpm588r1ewqu4fz1xi
X-Rspam-User: 
X-Rspamd-Queue-Id: 3939540005
X-Rspamd-Server: rspam02
X-HE-Tag: 1753364069-512444
X-HE-Meta: U2FsdGVkX1/D7IG2K67P3lxEt2q2Z6GUtnl/1a4CgUJJcMQetJ6QSTlUpKL9SCHSxPn2XiUUL47dkrk6YLPCyqajou7ArQHnqyP/iHvsLuNo5aUVrnZup4/BHJ/I0JNW7hcAV4a/Uq4MR0Cngbt+7dIVMppCRDlePc0bN10OdWQEFDSNYJkc8/4QwQJS+KzyowsFY/ssEuhzQzhXu5B5m5V20oJEpkbw8SK8ipVqzrrTgQspJDltaXQKsunE01Y45ES4Ix7hyYrgk+t2oYguOJ8eghKVV1VLuFLZ8sxYe7I4ldVC0XoZxPYbzMx5YzmzPY5+ybBcfUfovVQ0wLJ5/BzVQDu/epN9Xb8EYTVPMxOIdvaKAVkwiigMUdNm8qFtKVaJFXGGFnd08TGwvhpKtos+C7dcyklHapMHuNvowZn0y6xz9xXliO6IPlRjMcXCjeiTVIN98r5Lqw5P8ppEfMHLq/vTtcWRdi/erICG2DSpmaTnOOIHSGvKuP7LF9olvOK+EvX6UP/kesHRagvDZYy0BFqBclGF8Ur1XdAVSo3N8TuXKyrr2rAw8AJgwvo0ZG45AIXKkh89MMLtimQgMldfaRc/r82DAtqS9wjHHP31ksS6+FLItPzHG7rTtA0NcldHTN5e/rdvy7GTt7RxyOleP+gtTpmgz7cB3mrDoPYYlNxYpuDssf19DrFsJmLcsUH98tc43uePa7XOMb5PiyAqx+FJprBYGjgeApIVOXuQowyw4LOxQxmknpaArKAn6YVVPV3/D21otdrLlH1c/1MhD7iMUh4tNuw+58/yLWu+cqQ4qaCJvtw167IgQZ6fIVjIueWsfi+u8w6PAx/5YEY3himpAPYCGbD19fagTWy/F3AlFs6q65xzYGgMC8A5SKpoGrglFoLDHUjwpUAsGCt34sbb68r2amW6eLzcb7IGRlf/TasBQwrAxG+LxfzvDG4gOBtulgOHVAuEIew
 8p8O4faI
 rZa+cVfnEOL4ZcgYIHwEryqFzTyWTo7asbW/nBR8XFzF6a/qqRMDo3YUVE+SdaHQrGLpUUtKl5P2a7ghGKg1Wd6wvOdHPC4lomAykIvOg1hYRMsMKFrY0oAOpmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a MEMORY MANAGEMENT - MISC section to contain files that are not
described by other sections, moving all but the catch-all mm/ and tools/mm/
from MEMORY MANAGEMENT to MEMORY MANAGEMENT - CORE and MEMORY MANAGEMENT -
MISC as appropriate.

In both sections add remaining missing files. At this point, with the other
recent MAINTAINERS changes, this should now mean that every memory
management-related file has a section and assigned maintainers/reviewers.

Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
related for this to be sensible.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
v3:
* Rebased on mm-new.
* Remove mempool.h as pending patch going through slab tree will put in slab
  section as per Vlastimil.
* Eliminated duplicate entries as per Vlastimil and David.
* Added mmu_notifier and ptdump entries to core as per David.
* Add some missing header files.
* Dropped io-mapping, which will be removed in a subsequent patch.

v2:
* Propagate ack (thanks Mike!)
* Retain MEMORY MANAGEMENT section to contain the global mm/ and tools/mm/
  directories and remove from MEMORY MANAGEMENT - MISC section, I misunderstood
  how these catch-alls would work. As reported by Vlastimil.
* Update cover letter and subject to reflect the above.
https://lore.kernel.org/all/20250723095823.21940-1-lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/20250722192704.164758-1-lorenzo.stoakes@oracle.com/

 MAINTAINERS | 72 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8905c56c4644..cb02e18e93cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15741,22 +15741,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
-F:	Documentation/admin-guide/mm/
-F:	Documentation/mm/
-F:	include/linux/gfp.h
-F:	include/linux/gfp_types.h
-F:	include/linux/memory_hotplug.h
-F:	include/linux/memory-tiers.h
-F:	include/linux/mempolicy.h
-F:	include/linux/mempool.h
-F:	include/linux/mmzone.h
-F:	include/linux/mmu_notifier.h
-F:	include/linux/pagewalk.h
-F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
-F:	tools/testing/selftests/mm/
-N:	include/linux/page[-_]*

 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15771,18 +15757,40 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/gfp.h
+F:	include/linux/gfp_types.h
+F:	include/linux/highmem.h
 F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
+F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
+F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pgtable.h
+F:	include/linux/ptdump.h
+F:	include/linux/vmpressure.h
+F:	include/linux/vmstat.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
+F:	mm/folio-compat.c
+F:	mm/highmem.c
 F:	mm/init-mm.c
+F:	mm/internal.h
+F:	mm/maccess.c
 F:	mm/memory.c
+F:	mm/mmu_notifier.c
+F:	mm/mmzone.c
 F:	mm/pagewalk.c
+F:	mm/pgtable-generic.c
+F:	mm/ptdump.c
+F:	mm/sparse-vmemmap.c
+F:	mm/sparse.c
 F:	mm/util.c
+F:	mm/vmpressure.c
+F:	mm/vmstat.c
+N:	include/linux/page[-_]*

 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15845,6 +15853,42 @@ F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c

+MEMORY MANAGEMENT - MISC
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Mike Rapoport <rppt@kernel.org>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/
+F:	Documentation/mm/
+F:	include/linux/cma.h
+F:	include/linux/dmapool.h
+F:	include/linux/ioremap.h
+F:	include/linux/memory-tiers.h
+F:	include/linux/page_idle.h
+F:	mm/backing-dev.c
+F:	mm/cma.c
+F:	mm/cma_debug.c
+F:	mm/cma_sysfs.c
+F:	mm/dmapool.c
+F:	mm/dmapool_test.c
+F:	mm/early_ioremap.c
+F:	mm/fadvise.c
+F:	mm/ioremap.c
+F:	mm/mapping_dirty_helpers.c
+F:	mm/memory-tiers.c
+F:	mm/page_idle.c
+F:	mm/pgalloc-track.h
+F:	mm/process_vm_access.c
+F:	tools/testing/selftests/mm/
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
--
2.50.1

