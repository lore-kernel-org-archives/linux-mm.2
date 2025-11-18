Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB40CED265
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71976B000E; Tue, 18 Nov 2025 05:19:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B296B0022; Tue, 18 Nov 2025 05:19:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EACB6B0096; Tue, 18 Nov 2025 05:19:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 790576B000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:19:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A828C0494
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:19:12 +0000 (UTC)
X-FDA: 84123330144.17.9CBC9AA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD6D7C0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:19:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rS0kij9b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IBkYGurY;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763461148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTZvud34c6Go/B2rzQvutlMJi9tas+bDDXFiWl8H3Q8=;
	b=FYHDlIOD/Y9RAItEV0W2PXRJxavbxAx9g5Ubeu5Wi8tg/ZaJlM6Lrh03jEN/bvSPv+a+xD
	nUzZA/aK+8KJ2ga67Ib1HptKxkrdXgQOWEfKiVbebfCcQr/TH+f7cHapk7dQZsQfCUsa2W
	YJqh515yjkShrtFTHRDPdUYeNYwAd8k=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rS0kij9b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IBkYGurY;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763461148; a=rsa-sha256;
	cv=pass;
	b=Il+/JdY4AGiUXSijbMzJEoGZcy/40tOpVlVQ4rN50TW2xdwD6gAKvanM73bxstKMe/Abpp
	GAHqAK2J1H+vKK+NBQAGAyoBQcmAIGrrXD/E81pm6l0T2fo4lGDyQ/hKW26ZY6rC+HhWpH
	BS1YjXgkZFtchiY3ztWBGy8p/IgR6WY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI9CnqC008908;
	Tue, 18 Nov 2025 10:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DTZvud34c6Go/B2rzQvutlMJi9tas+bDDXFiWl8H3Q8=; b=
	rS0kij9bcm5hsGr4NLWv62V+UVmt4GdXcJ7n/jPetpzNPaSdQVTzZd3+96QeQE6k
	sbrhGe7NyDzvDqwL+UOWUKxJO6L6yQVwsIqTDGy7N0JsgljzHJW+lyjQiq4rIUnX
	UTazeuAoZQWtZ6tNy+7nUS+hcgZr5jvN+mApdB0MiCjUl1x0HjpAUxRkToFsj+xe
	Yc9c8zHsyHn6dSqyPwVDMYZUf3YLDEAM9GgAi9KMyLZwKLfMnCVeaQFzam6j/z6n
	PbxvPi9+opOFwASY4AIlRJ56uS1q+KNWnjxECxZXpZ2kcr6+lQjaN5rpbVom3fQo
	3g93sJOmYd5bk1JEo4l/aQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej964gyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 10:18:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI9NsrY040040;
	Tue, 18 Nov 2025 10:18:41 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyk8qpj-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 10:18:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vuwEcqBQjqW5FhUdYpufanrPfbi20K9LaopLzGFDXnNXk6jB2sKkhgGsUFS1vLi3ITwC12XhOj5eZu953D/4EyCuz/q/pzcQrwO8FmHaAQnBY5UxP3/oFVqK3vMUVDUpYRnAs47XAB/QgJWzfDezayGSmnrTHMye56eKDASCrpKk4YTP403c+NDjgHHGTCrfGhroNjqr1OLSg4PxW872kWYTeyirfymAIpPZTNqjcJXvXuTusKz9i63yHQ+VgUzYptHmapwJWaWGRiafUQkTUbCMSwDDo4m9787AFAJgu5O7PFz5bwsLS0ymxugViPS/d61CCS4q4m886Cs1L41REQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTZvud34c6Go/B2rzQvutlMJi9tas+bDDXFiWl8H3Q8=;
 b=np8A+EIOYzxjjMFpBujoAYj02mZXaF76gZAcrm/6Wo5g1vY8BcN954+1AdhHvjfguRKY1yJVsqiXxwhXJ89yVEeFLYNH+qRdAQaURxh6g7pV0AC96nbNZasbmQjYKrHwiVnWD9nB2pS2pUn5Qrj4nMcDTNPtTaOcE5YEhdXr4lbI/moGRrlc087kLS0F+8pte8rOClBbETakz/yRrNqAADNHzNgsoQGjINbAc8qrz73fBqKypDCB3rvFDhZHVDm8hegnSvsytmzNfnM8qHtSNb4VHr/fK/YIxFMkru8bh7x1YHjsUaamM4UYEDE2EFToDgdwobl9XUgB5R5/Y2w+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTZvud34c6Go/B2rzQvutlMJi9tas+bDDXFiWl8H3Q8=;
 b=IBkYGurYbST4DZHOBT6ot9RkBnE9PNt9+C+3CqtBWjKCGw4Dq+2vADwVD6/w+CO5gLfAS0lAldxV6czOFVgaeUdYbS8WZU5oPFJMJ1Qvf2zJeUfPqJMyN+bdSOcf+lrqUi1QUtbGyBHMa+6eivJvMei+JejqjNPIkB6zhWmkmtU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8756.namprd10.prod.outlook.com (2603:10b6:208:562::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 10:18:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 10:18:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v4 8/9] tools/testing/selftests/mm: add MADV_COLLAPSE test case
Date: Tue, 18 Nov 2025 10:17:50 +0000
Message-ID: <0748beeb864525b8ddfa51adad7128dd32eb3ac4.1763460113.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: eb6e117e-daa9-4a03-f96e-08de268bd6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hatMU9Py3e9IvJKIWwG1bTzCpEReCpn3g/ZjIXItx4V1yUFLTr6tXmn4NbTt?=
 =?us-ascii?Q?iP6PDCQf6LgYFmbPHJqXSCFUAQoOjkz3kzaTJKATPtbfWjEwPKDoFdN2Tobu?=
 =?us-ascii?Q?f0r/rjbmhbjLJLsO4pXyNw2N++T0ri+efVmFdHFQYSGr5HvNS1Td44RohY73?=
 =?us-ascii?Q?Nw7RCQmHYeB31pZGK976G0t9G5s+PyvEBh/EPR9u/eHWbAjVbK57pQpsgyLR?=
 =?us-ascii?Q?XV0deoRT5tLSVH4y7GuNGsqrKh2OxtaRWbg7SQgqdZVlrOgKsIHgw/IDeQf9?=
 =?us-ascii?Q?rJCMaKcpNVIA/cgMhpz3BC5eolEqZvu9r+W/iGZXx/SzISmC0hr3FZ2jZeiZ?=
 =?us-ascii?Q?9/c5GRHA9pfKXzL36m4S6Kc/RaThR6mGBXHVfS8T0Fha7aA7y/hNz5Gx/rDm?=
 =?us-ascii?Q?2StUbJWr+Z/e31YXNp50PcePu9of2XEJ+QY9Gqfi6oAofQThPGUX2A2hKpmL?=
 =?us-ascii?Q?sDpoC9t13neI0Rf5VM4YS2159sO8Do62HtxW39A5w9OhpMeCW/REgJ+pGBC8?=
 =?us-ascii?Q?KPrr6jPBqBHvx0bl5nmSDudAYmN3sjJPulY/Fb1i9zxSk5JWgXZ99t20duot?=
 =?us-ascii?Q?jnSqNZpKflYn3Lqlwrjv6tzysRVQ0NTh5xobcMyboSFaM6he6evsp1oEnOvF?=
 =?us-ascii?Q?pl5u2Jn5YeLlPfxiy6dYzsMl3ZnwiCeugTgWlGJrXAEDVRJIX+rFW+pSqfyY?=
 =?us-ascii?Q?LLmktz9uRRT2PGoSjYaJnCvjXMbfMDyot4GdXkkav1VPIcp3LFntVAeojQt6?=
 =?us-ascii?Q?KD5MlW8f3oy5ZwT4GJ3pRh7FTlk6YSj9dpmXA4G2aerGnxoY+7nw0aLFtKFA?=
 =?us-ascii?Q?iKLuETIigBmbEs2UxPLnt1Jss0JX6lkDUj4J1Jx6YPWXmtIWQSg6ke8/cvcR?=
 =?us-ascii?Q?9cgH/Llhy3ay4KF+1tvN5KKzyw0zwJ/LELV9hHE9SIvHekvCz34BRaDXy2DJ?=
 =?us-ascii?Q?bQufaxErTQydy5HErkkgxRYLoHlTgD50gyW/qP+QjkbF+Ht1e1lxGEEl4XoB?=
 =?us-ascii?Q?6tsNDjuZmeQE9xK1gUV54WhcwiCbzkTmE4aYA8zytZ2QkF3MKLi2E/Onpwe9?=
 =?us-ascii?Q?rlZdYiRt0mpbfiucmhHP1bHdvIuzEDvwPZQ9RBFOSeS+n0xywBBij+lJOqks?=
 =?us-ascii?Q?3syQdy4OWVRlLeJcbvfUINuP/9/bp/nfHQWjF8rBHHyzOqF7VMQYhV9uQ01J?=
 =?us-ascii?Q?PuU25WMkbD/cxyA7IKHRuRjxSQqZklZeffWJK7Y36j8Qb39RVHqKHA6bPQrZ?=
 =?us-ascii?Q?Thq3BelU/WcD9+PkhjVU8NMqFsUegp/dMcO5ztRDlDK9IUCtzSLethRQrfd7?=
 =?us-ascii?Q?RF++NPNu4RUn4FdT1c0VQEvyLZHBhOQgBYvPabM/eYEQZt7nXpZIWfw1rJCj?=
 =?us-ascii?Q?ybEAOEK5D8czqhvJ2vxNwdv2asOW5K7DGRD0ZxrWoOQRkJ+k9JShhSjK0jEf?=
 =?us-ascii?Q?fgDORoqQuc3FYgIyZEJKlfaRlTC0ptke?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IThwP4h/vmyTNTBALuEExU7vvzY3KF8y0xeCLCIh3VB+c6/YjxVwPbLwSykO?=
 =?us-ascii?Q?GJ/MnP+GMB7QjZ/bxJb5Z5IrNumZU4+foBAu/CyKzPalIumyJOp6KNdVCfMe?=
 =?us-ascii?Q?ar0eYcQqqJL2ywBggLsrwaMEAAasVACG6yeKHWSx3Ax3y5a6zKfLKM1G8rbd?=
 =?us-ascii?Q?jgeta+wO3zCsKVjVOXeDlp/AL7AZKMH7MLtP04s6t3wPHSEhqOFZn5KW6f5C?=
 =?us-ascii?Q?apWZujYHn2sCu/Vq7yUVaN4TtWu1QsS8GgfGvwFKDm7UsdKbTMdSe8GVi6q9?=
 =?us-ascii?Q?mBnbP5951t+Y77fPcYM7IQcHqgDpnaIJtxQJIIUO879g2NBaqLVdOvPj0MpN?=
 =?us-ascii?Q?+Ftbcsq+8Mx+62oxfF+K9L6jDW51vekwZXcDlY7Lrv/APWUTDVVrrxj6nA/U?=
 =?us-ascii?Q?DHFFi1zm+Z0XHNJ5pUmgcrBimFwElBAvJEKC27X3bn9v6MdyQafJn7BPumUW?=
 =?us-ascii?Q?hcc4sibb4bFYvIVmwANb8X4BTjRV/hg75DR6kX8bMU8SdeBlQPhbd5qsoYqM?=
 =?us-ascii?Q?9CKZUNdF7Rer+iwCHUYwry0H+/cGIJ/F3BhNM/V7VLu3dNgeZ3WotJTYPPUh?=
 =?us-ascii?Q?fg21psQl0G83XjXTBCl1LNFc5I/Phvd2T8gw3BMpFjsH+v5gO9fAWuWQ/yoU?=
 =?us-ascii?Q?2W12bfvvyXmkfKHftjZdkNS2ttwDxVlQeyDAH8ZvGTb8O77dd3yWnH7Ew+Ir?=
 =?us-ascii?Q?LlASSZQHivMjm5XdtPpgymo/zJoBfE2aDjr+PXO7eKqlotgNmDdMkv4fjE28?=
 =?us-ascii?Q?Nv6UYpN0JoYR1lRyWhzKY0r/50lwO9iF3nNhinhZAt8DTgda3O3sGPfeYIgF?=
 =?us-ascii?Q?kmpH7t41YzgjPhtUsEcHNwFEP2MIGjePLXkJDEfiAPJ67Cn12EWTLOSWmPEK?=
 =?us-ascii?Q?m8I+EdICQZU8awlfR/1DP5FfZAJsXZ28BQs+tEaHD9OpuU9c6D2OEvmo9X7D?=
 =?us-ascii?Q?ChYnMM9nGtZJpDugw70zn6mj315O+JLrq44cX++Red33JFg/XpmWhepFmjfu?=
 =?us-ascii?Q?Rmb+evCdvlWLWyPkkYdXygnLMGTa7R487H6r4taQQ9bl3ecHiP6a0LnMSYfR?=
 =?us-ascii?Q?2rfSktqP3jfHo3/topjNT92OSGxoa32vvHSIWjLez2zMEU9SV5H0o+VR3NvK?=
 =?us-ascii?Q?KSWn7aDHJn7E0BRY6xgwuOnbzZwhH91CVLagSmx/7mtgmTKwAiLoE6FienDW?=
 =?us-ascii?Q?Twk0qIirvZWpDhX84BqMtMZ5+CbKtcGnxsMq1xD//3X8TeXqtTQEfhT3Pz82?=
 =?us-ascii?Q?IWAUpFD7USvhboO3lNl8iGtLKqJcu6Ry+KuVkiVGOJH8ubEhgXVZfxF+PYf8?=
 =?us-ascii?Q?/x2DFTQ3QJ4FuL7D+TE98ebsMI9AUY/8CLqiCR8a1FMXRIJIq10bV151ExS+?=
 =?us-ascii?Q?vgkxhRw/rTr/+jlFz1FfKea3YUbmAjbbfEkStwn3/R6LG6ylmqcDL3vb1rkW?=
 =?us-ascii?Q?s4jtPYQA6RusmXf6VVZJIkF7IvpBODA74nMcG2TI2jtjB2baURmAfy4mo4NC?=
 =?us-ascii?Q?UJyxPz283SCgIu4Ed5MuUy/QYkXd0dXzFD6IY+SAOszfSnfpdDxQs2N1L1xq?=
 =?us-ascii?Q?od+1OAAT9s2B+k6vQfrx0uov7hwpvSJ6qxEsgD0U1JXeMIoMxjiEdWsaIjHS?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ow3KV7dI0XdzDk5J1D5Yhf1/gwa5FiejeE0sPX2B+ZbfizWQOgDWgVw7zO33RK3RYOGbYcjshc2exlqCt/nMj+mXQlgMC4+t9duaqSBG1sTYKcBKls3K7ixAtkM/ahNMrYEbMZ7TWfjM485X3vlbukJharyMjj3PBDUCfwiMsPa26lAHk1aIwa095ihG3HWydAkg16kKqRvFzIuJrRAZcwvB8P+pe8WYI4QBFXcJv6Tm9Cpe0YF7bYzoOsUmm2BeTwypoqbYHj0tIG6C4CxokPiIlH+BZhHd17BD8b9s/Ze6+iAmRg3tA+d/rwjsKl7w03/MKLOENuahL5lGqbCHkUIU9gbhjS6m2VtI1lvYylZN/oMbfHIaxaDSIHbGsFDnCZqUNndRc4Li7+ACY1Qq4gVHZp62wkyoBWN5ki9P1T+mc/BMIJyCydYtsImvmNJ205PPQNt5Ko1QOW+NJiN4uHqVi7R2zlAHOViDV4rx1R62efMSu+dDLdFq0wfG1oOd8OgJ7TJiqREBNEWsby0uNiOctzZcK0rGNAkD2otRruClpPZAIBfXo+iLnvJShyD5xnKPOKqqRSwJAzjdKA7aIqkvHnIQrI20wmiwUa1xeL0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6e117e-daa9-4a03-f96e-08de268bd6d9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:18:38.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/AXhe9x0XC+4fpL20NwHHCTPrcAwdEddd6o0fvzwJ3DlCr6yK3vZxzI16+7z5JEw8pgkIjXz87JTZUBPMniBYnBChMKfFu2p2/u9QIbpPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180082
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691c4803 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=WR8ShyrngeSRY8Fu9_gA:9 cc=ntf awl=host:12099
X-Proofpoint-GUID: ugPfONMteMM_2N0Zrcw9yUaoJuTwOddB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXxSMI79a4Bgob
 +u1kp2HDDQztAjQZLGjUeoiSsKe0sYD9pAdXNPvtLGvJ4oMMlwH+sYGSajxvuKNmkJyaGifF5Sa
 7SHTn2UJC74Rb2j9qX+G6L5raXjBCiN6fq4qpwiebJ/nh1ht30tLtcsBWzRme+XhfP+eoma4y6L
 ANE0vQQP6TGGnhlsAIwN9eLBADcTvl7lov9RM0E5qESH8tZoEAUTqW4ja+yYMsjCdLYejZsd+Dc
 B5T75XSdubGB5iNyaEk1BadDbmOa2OuJIKcbRbg83wg9EJUm7As5J4/89vLMfXGYcwu25UKpfFx
 ookFr363C37l77unU0hq/T0/40l1szPwlmG6JXBwdJmyYN9i1jxODQpfzECVLTweDrwG1vFzwp3
 Y4DdLYg/tHR8HCyHJ+yjR3DfyjCv/9OPk4gi8ftIxubKb5IFsZ8=
X-Proofpoint-ORIG-GUID: ugPfONMteMM_2N0Zrcw9yUaoJuTwOddB
X-Rspamd-Queue-Id: AD6D7C0006
X-Stat-Signature: 4fzpqsq1r394ndyk3354drqh38741tr8
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763461148-559855
X-HE-Meta: U2FsdGVkX1/hNQbOPINnmpakh27yTXHWNCf21LE3AxBecGslUjNY5T/cQkXW3YaPHZKQKvDpNRNhFqxXBQKC7qTRc2geIUrUOdZ64VuQQI7e6Ji7YbboaF3sXpgSSqhMc/TOSZz8LDRAzykyz1WQF4zvLGWg1yROu8sI6LQKCknAuy6uUZZj4aPKKQXLYsVMNDOilCuR3Ja26xFwXfuD6gcfKBzjz9ftyO51ZdQ9hjJGhoSexbhOYrCLmWmK0Cpris1sM3+opk9WTWakxvtd/cUsGfi6um/JCiP9D79/Q/7ESVLtSdJl1tgQ/TBZ1TYeg8peCaLcFRQ+l/7I15XhtvzXjbGxj6EfJR7G9G/wtsx/p4HIGm5PLfGNoUKvMscmCjCfNVxBzmq27b7hnzCVrWuyWfOhLgG+mQyBhUwEJmoQ+9jxYQonqb/fgHfFLLoJLDioII71wZ3sNl2eDmWLKmSMkv2ILjWI1SrPqTNcDk4uUwN6DR4LhxdxqfUDkZHaIbweAMfGzQtsmrZKW2eRzyLOMpm2XPBpBog1T5YZXk6889DB6jQHMzfLXXM+5nqFMuu1d3jRkdDLyPR/1IPV3KJHctgE+dMzZq408pstjPhHeA2s/8nR7ZFB1AfbIT2GR+Neh8iZCER4jcFTOZxTZ5/uWLgx89cBGfGwrBzXuhcBKLD0uComTj92c/F4UzYDqM47Aa9g92TdgtiUB8cKIWhGJBK//LnspdvjOkvS9qfEZjf4pRzjt6k0QTMsC7516332GRiw3LQOV4E7cuUhJt5vCRl1OJ33vCNai9/mVwIHIMlh646f4Z/QHHU3B5UasdCUFkvdrHyIeO8dcvkDUuUQMqjCG0lPlvGpM91KbEoybGBMgK8X+x59e0EiAJr29gIycY1/XptYbz3Eojrw8mYQPgU1og1I4jwvKpeyIDZ9ZLHCWFy63tl/Hx7cwEuZ99vgvWe/9JMKlzsMSP8
 5pd+Itf3
 IMKgjZ+V1yvP9a7Vt/zxAdCokqbd7rWddpNloO9Zlw5EVUS7j+iNsk0/eLD4oZQQRe5Mq2xVxtzwzDMj/vw2bx3F95SD/uQs9QUvusStTpm3NjYtJ+sL+lEBr/prrpmazchuX1jie+Sag0HVWHR++uPi+osW6hCy3h/CkNM1sIAsbLD6y0hJn5jYtFfmF8UVFY5hRByx1k4iwTUiaQ2YaU9T9ooNw8Ol2L3eRsb8X/+8gwgahiu/6rL9917IDF/xxHZ2gFxJhRJU1HPTrZHTi5p//w4Qq1x9sO4eY3AXR+WvO4snmuOmOJp1a0Squ5g7RYdz92FN0PPzSGhNX2Z2VDWsE5/uYUHYgfLHv//lPzE6/OFngr3TaTujbcQVHGHRwIWlZUFfRRKJ3q4cRpi8FHoIrE97XPkcuDHdd0A2GUPWVjgq4SmstGXGm1jJ288+edcDPJBA6q33KsSO4Ar83k0P0rEo+EPGZfdH6xoDa8fNKHKJashEeS7igaHxoLaoKdhiBowPDFU/GelHM5YZKQ1shqQLybGkxS6Dk/O2Br8z1LEddsMkzZeYX5Dx8JUBKB3NnBZR1VUU5pwX8bDtPLWheYfPuF+7ZwAxXq1BPxtJLmj6wkTeOZLGja3YjxaPoWUls7qut4KIVjPrw3lt7s2qjMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To ensure the retract_page_tables() logic functions correctly with the
introduction of VM_MAYBE_GUARD, add a test to assert that madvise collapse
fails when guard regions are established in the collapsed range in all
cases.

Unfortunately we cannot differentiate between e.g.
CONFIG_READ_ONLY_THP_FOR_FS not being set vs.  a file-backed VMA having
collapse correctly disallowed, so in each instance we will get an assert
pass here.

We add an additional check to see whether guard regions are preserved
across collapse in case of a bug causing the collapse to succeed, which
will give us more data to debug with should this occur in future.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/guard-regions.c | 65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 8dd81c0a4a5a..c549bcd6160b 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2138,4 +2138,69 @@ TEST_F(guard_regions, pagemap_scan)
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
+TEST_F(guard_regions, collapse)
+{
+	const unsigned long page_size = self->page_size;
+	const unsigned long size = 2 * HPAGE_SIZE;
+	const unsigned long num_pages = size / page_size;
+	char *ptr;
+	int i;
+
+	/* Need file to be correct size for tests for non-anon. */
+	if (variant->backing != ANON_BACKED)
+		ASSERT_EQ(ftruncate(self->fd, size), 0);
+
+	/*
+	 * We must close and re-open local-file backed as read-only for
+	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
+	 */
+	if (variant->backing == LOCAL_FILE_BACKED) {
+		ASSERT_EQ(close(self->fd), 0);
+
+		self->fd = open(self->path, O_RDONLY);
+		ASSERT_GE(self->fd, 0);
+	}
+
+	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* Prevent being faulted-in as huge. */
+	ASSERT_EQ(madvise(ptr, size, MADV_NOHUGEPAGE), 0);
+	/* Fault in. */
+	ASSERT_EQ(madvise(ptr, size, MADV_POPULATE_READ), 0);
+
+	/* Install guard regions in ever other page. */
+	for (i = 0; i < num_pages; i += 2) {
+		char *ptr_page = &ptr[i * page_size];
+
+		ASSERT_EQ(madvise(ptr_page, page_size, MADV_GUARD_INSTALL), 0);
+		/* Accesses should now fail. */
+		ASSERT_FALSE(try_read_buf(ptr_page));
+	}
+
+	/* Allow huge page throughout region. */
+	ASSERT_EQ(madvise(ptr, size, MADV_HUGEPAGE), 0);
+
+	/*
+	 * Now collapse the entire region. This should fail in all cases.
+	 *
+	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
+	 * not set for the local file case, but we can't differentiate whether
+	 * this occurred or if the collapse was rightly rejected.
+	 */
+	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
+
+	/*
+	 * If we introduce a bug that causes the collapse to succeed, gather
+	 * data on whether guard regions are at least preserved. The test will
+	 * fail at this point in any case.
+	 */
+	for (i = 0; i < num_pages; i += 2) {
+		char *ptr_page = &ptr[i * page_size];
+
+		/* Accesses should still fail. */
+		ASSERT_FALSE(try_read_buf(ptr_page));
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.51.2


