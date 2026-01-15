Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 285F2D41177
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57E956B0088; Thu, 15 Jan 2026 06:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556126B0089; Thu, 15 Jan 2026 06:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EE36B008A; Thu, 15 Jan 2026 06:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBC46B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:46:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2AD3C17A5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:46:51 +0000 (UTC)
X-FDA: 84334021422.18.3814ECD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A74D14000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:46:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IVQlEtA4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sZxs8bGA;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768477608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z73q784EXi17G0oqM8tPUNsqrybVd2SQ4TkBzituy8U=;
	b=F1bAYMdBlGXH4e4R6riocYCXlSyfzJ/vyN5BkIlt8nH1Af8jBHFX7lRsLlSrnQtR3qt3zQ
	uBOpORXUr6Gnj43yDCEtwcyK+pGibVOPlQ2oCIKePQB2RugpjO4kU6ne9AFf4JMnvM5BIU
	r/d8NIgMD73TR6KjLb8mn7DFSi7bfeg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IVQlEtA4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sZxs8bGA;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768477608; a=rsa-sha256;
	cv=pass;
	b=5mu/OSq782k9jfTwiz3JPUdc8h/vJLNdzbGggGBlmjksHDRT3lGDM/qhDiDS4cJRNfdPES
	5PtcV0gYXFSmD1o2nY6Az5bfxc7SlMRQtAVDct6oY/xqKmX8prIiot2ytfHQRS165YYrRz
	hDv9ksr1n3TPdmXyelqdViRHHgiD7Mo=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FAHW6x1362469;
	Thu, 15 Jan 2026 11:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Z73q784EXi17G0oqM8
	tPUNsqrybVd2SQ4TkBzituy8U=; b=IVQlEtA4pP0MQFUD+TxlGEfvQgQwZxLHma
	4jJetpeuhIpXmWwYfBIHaQvgysJpZYtl7/zn/HeGBTecyz7S5KOK3jVv133CU/I9
	+8UP4m/rbusnNbtYOz5O8Bqa1vriPpr3/ouVXbulrZv+QkivzKt25hAHAZnkY+AZ
	TcRrJK9KOfJFES9PQFkKV2YCVqd5agV1y7TE1sT3Wjp7/9ofHPqTJehp8/jXNL/P
	lbYG4zJ6AHoLx8iAMAamYJi7rnrER2uPkQeA/vmlA4/sJxL4Cz7LkDDqzJRMEn6+
	Rkrw35ngbC76M/iAuelOt/B5MsW04NpYHukWVnBJ4asPnUB4f8YQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp2sdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 11:46:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FAWJVc032693;
	Thu, 15 Jan 2026 11:46:31 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012006.outbound.protection.outlook.com [40.93.195.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b8htb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 11:46:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a7Cl+rxmwcGmg8bDvlu1Ij7Y+a8b/b8jxS8E/Jc/ui/CdbtpndfX0rGunvNXV32+Qh0XGm+Z+9+u+JoWxftGTbVjma0wkFTE6WM/lCirwp764iALD8nS1wXplbGBzq9LJiFDetzpLnb6qrO9KRGiFpZDr/loRE+zWhGuEb7TzrlNlQzFHH6045MdSBjKiPGS6smm47WIjSySOj+aYtFzZqonZcP54kRMmO5BGgf6aZnW+W+2QDXD2xT1wsuEIR0SQwRCgEXYhs7EwlViqbiF+UjxdHkMgR2Gpajj+9oeVlBiksPLrP2vXJJQ+wKsyuciUZYFj4EHFFveiBe0mjIJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z73q784EXi17G0oqM8tPUNsqrybVd2SQ4TkBzituy8U=;
 b=NunrHIEhIAqnREctUGwrBSfDFK86+uA3IVNrtm834NsEWVq1Ns7XCidiDsifFIlcU3BwX1iw9H3BUv7wbs0BdW1jikiw4Tv3Qxk7qz+4Ql/sHVVQmI6FkTsBRaZ/zXAw1yDttVDWTW71/8x7at0mlU+C2euCIPC3a4B2PYeKYjmOjOUTZSqKwW29ZB/H6OgSK2EPC8/RHcXtLsqCZ9Se8/R5LCf2DMqjkbPhP5neG4IGCHggsEFC0BLT5OrLCvJ2flkkHfEkFD3UhqXOk21aGUdLqkP9V6q2gp324pzo15YpQ3ghc5pd/up9C4gKK/icD1gbJIkeBbMmgACcq0GaBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z73q784EXi17G0oqM8tPUNsqrybVd2SQ4TkBzituy8U=;
 b=sZxs8bGA+4Nn/RHJDBLQY/MW0JbdvcOgNngv65bb9/ycYXnMFV5iCafVohiiqmimPrEiOS1j37FQ0FqJKywLsam0LvH7jPsAhgBWA0CR63dElIpWDdiZwH7mu6VO764jXUjbV8PwaS6pvIiCQbvaahzfAyAqPD3P4xOoegaTRyo=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CO6PR10MB5601.namprd10.prod.outlook.com (2603:10b6:303:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 11:46:25 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 11:46:25 +0000
Date: Thu, 15 Jan 2026 11:46:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 03/23] powerpc/pseries/cmm: remove
 cmm_balloon_compaction_init()
Message-ID: <5ed94c8a-35ac-4635-aeac-3fe72d4f9c8e@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-4-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-4-david@kernel.org>
X-ClientProxiedBy: LO4P265CA0179.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CO6PR10MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: 5431a831-c395-45fd-4b25-08de542bb644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Xn6woohHihB64x3MqHwBpSW84/MPIOApHTBvl3Plw/aYFwnqsjV2tQCiKkf?=
 =?us-ascii?Q?iDaKpb9gulsqJcGBxq5rWju3AG8RJcMnwrTBoMBsRnsN0w23lL5XGUJWNY7H?=
 =?us-ascii?Q?14al7dPG6sNjSV4MDXp/rlV8kTqnJSK7FbR8Sl5fExRBF8jeIQWTB5Tx2l/i?=
 =?us-ascii?Q?t1FbZjInL6jTcWWoYiL/m0r2fsTV1IBw95szms964oXNNfcFdp9Fc1YfLON9?=
 =?us-ascii?Q?x7oLHynYgfDzYZuXbx6MqtKd0t/s51xlbeZvo7OkT0iXcGDbOTmG6XVmCXdB?=
 =?us-ascii?Q?c8Pe5EIhdC/zpO4pBUAikbWNV+TQk9K+M56hoGDSR2lt7OL6zpM+B4ZjgoYS?=
 =?us-ascii?Q?pOWE3WgL3f4bCt1hvklwWBfNpWfC0acdsyb874F0kHiuh1zdMF/p91+YhTiV?=
 =?us-ascii?Q?J5o9Dt6r3lH5an26nrOcmJCk4cxH+prMDGpsUe6D1CMUx1r6Sg7aGsa/2tm/?=
 =?us-ascii?Q?ZufXeX0SVTCOwF4oDlEYmeBxcCz80FzhTj1H6hc4nl7+P7TTneQjB+Z1oTc/?=
 =?us-ascii?Q?3ZyzSNeUrIkpkYNglwGvVzoWOOgOL051BPDaOk4V35yh+FkPHg4L3A3S/ffS?=
 =?us-ascii?Q?73CkteFGh3hfLJRmE8vEwTBL7D1eidt75poMsPazVtm5yo7j82e73IEnExiF?=
 =?us-ascii?Q?lp780SAii+ctb4wueinvOE0a00iqKGnYL9eEK/83+gbfkOdRGyUDfo+7aW7V?=
 =?us-ascii?Q?qHUTcezO0RfObGrqug02X+a7tVSyQYliHg/QGQ/fiCJDlZXa6rO8SxDGpR3W?=
 =?us-ascii?Q?yeg3SjOBl7TA/wzXH8eQDXMLmPR0VSAJ9WcUl8nSMCMhv4pe3q0y9Nqqrevk?=
 =?us-ascii?Q?JNHO1+ocPAtmP6BinboQ0Y3HDumDYdFEwX7LsJqKIhlThwj53hz2SJ5mvylr?=
 =?us-ascii?Q?+MQKHaJcT9f+x21vUVeAHqFE9p4K+h2cbGxqbHRykeY5ArHEDBB7EPAlZd0D?=
 =?us-ascii?Q?YWjREZDUJqV19zIAvRGdPK8X7P0b/OKOjCJpVU/sTjorSFMJiXKZRDkZYls9?=
 =?us-ascii?Q?DELsHthansdRuzlmZxnKTjQUt6Dq33rwIE1qjW0WtF4/h/YQ/NHhUdm+ppGS?=
 =?us-ascii?Q?vjjPwdWutsGL0/+TRH84E6z9oQkk1i85/sn/rJ37En8avXSmaSzq8srWSZjW?=
 =?us-ascii?Q?SGBgXbd1qz4G6uu2RPxUCcTqflfWjPReOFwHsYy9lVVSfeYCHkB+ZgQTikmj?=
 =?us-ascii?Q?111Wqz3dzk/sRV9W4SJdMNne7BbpaiF5BT63sPYOOyp1cHsn7DdcXShKzgSu?=
 =?us-ascii?Q?BUxDIjY53BPBq5vT57T1kxvRQerhriBQDQEcvJkz0q5RaB4KHEnrMjYJJJO0?=
 =?us-ascii?Q?ketHaNAEt5YUjdTFmY3kZ+2/tLrAdE8NCgqyHwMYFtukFOnDVIQXlCq/9bmb?=
 =?us-ascii?Q?lXpq4frJnzOkDcRZPAiZkqTeA5T0UlhLTbnJt+z6TvOxiKyT6KxGl712sIe4?=
 =?us-ascii?Q?Flfc05nEyf5tle0dc+TaDF1hp2RbUOPwzResGhRL/MR9e4WAsMLAfkgAGHE9?=
 =?us-ascii?Q?hMfRjOqZpiJNcpSzTx8Uhef82MTfEiuT5j4PAPK+IPWxfCvZ0FNMDl/06Ws/?=
 =?us-ascii?Q?w6FGmkXg8f4kyAGcqZw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A2gbF/9sacFPQHKT4nWc3gDo9MKRkiQ/eSqPvHEagK0OMtMptmWRUqFEg2Kt?=
 =?us-ascii?Q?Y2ZjUI/Eu1Sc/5eO2l90A2xZT0r0mEj++SMi7HfwPfxXcHgKOteLGZmcgQDT?=
 =?us-ascii?Q?YJ0bcbuY6z9LBIHIHduR6lKQ5jxWYIk1QuwkQFDklcw5QSSIhHp65UNMJqnm?=
 =?us-ascii?Q?Som/LLNxg9RVYY2uSULh+6ZbmUlIXxc0XPAV4nI0zaYttEk3dJVW8+zg3GoC?=
 =?us-ascii?Q?qhHT0aTlfq0hOnZvLMyysR9jh11bipLclgvJG3E1utMcG602zChHXoi5iFTH?=
 =?us-ascii?Q?l0p7KyQ2yZrxbiQ29SoT/X5XK5m8oKOu868UWmytKgw/q/8mGpC/1+CT4Hz0?=
 =?us-ascii?Q?tN7jb4+EjmScYroAkpsWrwZ3+XcTFe71a90KRB6ikVDr0IRwBE7EhlIllI0X?=
 =?us-ascii?Q?G1Bmy9DNyOUJEMyshq3PwrMI8FOGULVYk5nIobTUBKZ8s6Z+vD2dAQEugB+h?=
 =?us-ascii?Q?qCOQYdpJkrQKJHxhM2JlhlBwWWgND5vneapSqBC4MDygOZEj/Ht6pKjpGuzV?=
 =?us-ascii?Q?YXtkAXCGCWmvyCNc7YEIOzE+kGGPLSdDM/StrkvoGsufBleUu1jYDup/NrMZ?=
 =?us-ascii?Q?/vt56cLHWGmyhD7HLvg+Lb90hBUuOMb1B5mu0MwjQ85KNf1szGC8QUcT9MIa?=
 =?us-ascii?Q?fWDUu/sQxgMiZRmTtxOqpAScXAqAUVeLwpDEFcv03PNiXEv6Sq9YnN6DjDP1?=
 =?us-ascii?Q?4FXvkquLvQlmsc3szNWHBaaexmS2N0xCQyGA8jTxjA61BaLDShoFTv2k0wDr?=
 =?us-ascii?Q?+KcT172OpPcxKH43g38Ude9N8Tlw6mHWB4PQ6DCtmZEojnKHUAQFHoG/lvlp?=
 =?us-ascii?Q?8ofGuh8zHTRab1zmlZTzGiIqZGV/kh0nio2l0/5HdKtcvs2Kr6U6ADwWZOo4?=
 =?us-ascii?Q?Sj7PH1r0xXFDthiV5BFFSUgg50D/6HvlFpVpSlgYo/JFJUFaSMkdbcheO1Nq?=
 =?us-ascii?Q?SI0fVUE+UD/KLvx+iSqDLzppcxxLqHYLudXv70j9U7GRKrUB37Za4WSZM9wt?=
 =?us-ascii?Q?pytSegrFG4SBCdADxOUjavJpwjMl9XJH316wNrA63ThCKSzkHRcyZrfZyAxw?=
 =?us-ascii?Q?mqDsJkZshBFHUVkpSgjNCh2G0ETJoHfbW/tNhO8ru7/0M93AgWnKZ9d5z1hA?=
 =?us-ascii?Q?o8BaS6PJ9b+8R43WoRpeF5wLK6ehRBnY9gpNWExZDOsgYePWxOMN/PhNL/pd?=
 =?us-ascii?Q?SKP0NmKsY3SpjdG1olDX4paPxoyiLOVPhh0reKw6aHi87liEAfXNjUfJH/7I?=
 =?us-ascii?Q?cf89T2stTONM25Eg1eVDsATPn6aLNnokl2LJANdlhGtIDOG6Vo0GAkLKuBmg?=
 =?us-ascii?Q?vazAOcXo2qJgIQ6DE62ShQb79j6L/mImgf3Wd23dYEIH6kFLVan6e3ppfRQu?=
 =?us-ascii?Q?LKLrJkqZ5vlkjv+OktC383gxcsQVSzD8wFmGTL3ensLw4gFXRvBjusmlj1CM?=
 =?us-ascii?Q?oKEnt5gyq/ZWCprbXrlPBWgDwfOBYdsvo+MoiU/Ptj+QkOc38nAhWn1QbfvV?=
 =?us-ascii?Q?vNNUM5Y81wjCjtd29luw81DAOCxglrQCrOPQ4L68xED1UA+8do0/MIakk8/e?=
 =?us-ascii?Q?cjByQJ+NCC+D0uQ+WdW2L9MVUSoo+0MJU2ZFOKUjoODtqECt/uLfZaiUnhzY?=
 =?us-ascii?Q?tmspyi1ZyNIxt/I12cK83K/2KX0AxIwB7B/HlFQj+UZ/qGFAY6MQOrgv7zYO?=
 =?us-ascii?Q?Pmttn0+/TJ7NSR8wAzR3tHSZwdYMdJf9BtXa6HGVZ+kkLuuXLarCOtkiEYli?=
 =?us-ascii?Q?eGcPvpVAsvHILXRl8LRg/zMbFqf1dUA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q3k/U5kelpR+9HDX7lnJASprF0NVBwdmGXOMteDXgdoHY9HZ5YG4zd0Z2pXrPHmFOtZMH+zqEvL/zSImE43wwqwsphd1AVX8dhHEvUzfmtEEIl6BviO0+IZu2Cje5MtqZcUeoskNj2AvJT6t38IGIbiaE/d1/u11wGWzaamvUmUMmFVy/UJoTnMhULY1Y/mooWf2C1FqKvo8JdZwAZDwGrvhthHjwGV5OCTuuMN/Jw4UJecnNFF9dYFKfGhLjxygld2bJ641LGKF26oIQxerlj/XD20c8MdKnXb2WeTt4MT9ttWBWSdwPUF2EiaQIvgzipbJvTi61OCKpbznlDFWApynhCa+tWQNmPN0k0e0gCnoBGIJcLAPty4VYUtJCaepjHAjfohb0JW+f5yYW8dqyNmu/qy6CBYpksedcyYZrmvurkmiFSJt4/Whq8l+YhX9/RUcW0T8+oPLEYuh0y/Qeor7VoV/D8oqtC7TIhbpACl2RDjzEC+MU5i+hX/o0cnObiwVO1/JaIut8QM4v/SqW0dkLOb4IKH6iYtibkK+Kjqw66bnj2AwqRQo9NxukoiCq2aoARbQaP6LwCFGvnKXydBcVeE2Fsa3mumuXISwQng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5431a831-c395-45fd-4b25-08de542bb644
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 11:46:25.5646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kn884+/CaxuTjSHRE+dsmNFlfoyyZnmJqXW5PFAtFMYvZ+v90xOqcIgPm1yZ+RnnLL/fpuW8c5NHpF8BDauPmLbPn0xdRKz28SLGagm+hlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5601
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfX/IccwVP9nebj
 LE/mMCxHnfx7SmV+dLQOlbVvtr8UKZ0BHDJRMt5wmQ9VatHFz6aR3EV7fSikHqqjX8d7nbR2G3X
 H72Z6QiLYzyUd6tOAeZ/dmckb9SaC3JhPU5LI3F1Wn3o+vc9Yhw3QyHySs0IWxs2/MBjpdLDaqp
 Np7URAQ2yKJQpkY6oJiaryppvB2Cof+UufThX+7RcXkgE1TnkA4pifr+lf/Q1Z4Az94+j3Ykffy
 PI0lCZmMelMd6G7Giwm0HJsGBoNEO4/8UCBkuP7S1fjb89z4s20XOFkDAJVi5eqGQJjlVxQLGFc
 cHDDb2zh7qU4IumeuwxcN84OWrJkNpOzXKoPNj6Jss4biWcgBWfMK1NOpwjEn0r/BJtrp1B5q7K
 8QzLVQlnEuEbUhMVuD3yecq9n6jUJ3QgjAfBDMQ7SL2qeHsncFLb9tTA1/7VDP/LEdXHvHIuSwA
 dv3tZX0dH24KGoG3tuA==
X-Proofpoint-GUID: I-42T8YJYIqRG3pXYvzo-nOeSrFLIN_j
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=6968d398 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ZutnN-bx-cp8jyhSmMkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: I-42T8YJYIqRG3pXYvzo-nOeSrFLIN_j
X-Stat-Signature: ipfn5a71duy3jf93gtynmwksazs6h9k4
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A74D14000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768477608-746390
X-HE-Meta: U2FsdGVkX18/UvfsPmgDbupvBpSQRqpHMf2YxNq6OrSQubjUWjgq3FOA/yGqqtSxhFI5C7Vgre33wSF5ztBhx8bLSei6xE0dt9OvxxdXJLyV++CAjtaNrqgdAiZuGkeM6Lw/9B+uPARM8hKkUvxa0xubsXouOhUUmV9e6AiSKQB2dBu7iMe/+Qros14wmSUUaRv0TGDfT6Nc5TCx7P+0C9MOhiqfenUdm0Cj1bGDdxtYzC8W2qV0U15k4kg8ZlbSIJ1Bplv93Vg9EvbbAKYxbeFxpMkPyAUCOUwGurPcpwzkxACPxNvsI9/N9l987Ov9xKdqXq4BUQbVAvoOaJ8LmcUj5n03D1Hro3/OQt79en5pqdr5lnJTDw0sOE4HuTWSQr/LEEkFq3l6kEgxZBCxEA3ecx6ht9bH55OPvPmBKCgIHkdMhEgElKFkweT4IX5MNEGeaXtXVloFilwcaIL2fkEsbG/Wg4oCsAL7VNnylqA4Sknsk9rZ/3D0cna1mFVtWo6pn0G90ML/uucYfFCNZIjs0603nf/HWYvzn5o08QlOXihcAOkME3d7B4lsyG4vy9PMv5FrYmVGfOEMeewcgyCf0aIwZektpLmnd89sscY96YHkldjPMi3d05PVW1VAKW08TZqH1rLRz7SuzZtlWvGEzvnGYv7vOMDYIr65DUGdbJYFEacdTMVqcs0dfbyFkUQwLDsn3ndKyOwmszOBpEKES5D0f3QoBbQan+OQxkQqD7NbxhSiRZKVQOdpj2w4G0aPbR60Dhs+fyF6vN8Rwr7ZZbD86qmEhjEfKrJ6Aaf7hBoR8wICLuTqr1aT6C+laQ1w6gWvXufQSn2TqArYwNqG9wAkh7R2wmxQmZSabG42JIfthRTd6ZRfCD+TKWEwDQ/i9jLdovmm2k3tF6OnGbNWIAMA593Wd7VjVyLiEqcBQ05HEfdBaah+q1si8duzVrfgaw8o6G6H7Kp+OwT
 7pGlSzK5
 jbYepGyJmG4QPBIA0phVcHNjjJPXr70QHdaWkD7ejgAICosRGbFh4DRZbQdrklSIlsoKghDOMiFzNeOPbyeSkfZdzDOhfRzWoUoAiqObpxqoFqbePHyMTyrfKbD29iLtOICZtgUbmXtU3LFr0yYIxvml57GBAKK9kVlr2mivbJi6PsKCfLgnIqqko+GF/5aGr30nksNYaKt6vxm2NefYaeGc7qDzYZQbj+Cqr7/8aA3Unv7EoGA99zS5A7wkvORZ/FZHFzhcwn/YbAVI15ReXzSk/Q4WAeOKZqb9lhQHVMgoZhivip7qD6pfiEo6HJOWSElqu0hrmTjrklTyyeIZNmlzmyczKsLQP5XAU+ziz2052tezHToIiBFmRGFUuvyiZxu6UUMsXEvWMmyc9eZGt9fb04yNBL/T4iR6XrPSjDY4pYAQ2aqxHvbreIhPDxyPO6kDcRYmWGVQLuUeQJKSXFO56XwnXTzE71SHx0hImYZ2Ywm7sJkKOqrU/cq0M6CUgIlNlmXv1XFo8J7jXVjIzkBwTrHmOmoTjcHWuIl/wLygYkQts6b9orTOLPq/sDYX0Gj+k9lU5QcUsgo/1NpCacKiNgzkERhGNNqPazcgRSxYu7bcZJvWhZFWJEVuLmUTOPSYJdcX04KJjrsfOm3WJwVU+gUtPE7feLt+9A7KGxjs81EDbeOxeap4jS9Q9zR9IKmGfRormNbDT4L/ji21iaAyXpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:19:53AM +0100, David Hildenbrand (Red Hat) wrote:
> Now that there is not a lot of logic left, let's just inline setting up
> the migration function.
>
> To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
> the compiler happy by only providing the function declaration.
>
> Now that the function is gone, drop the "out_balloon_compaction" label.
> Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
> to movable_operations") we actually had to undo something, now not anymore.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Seems reasonable so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  arch/powerpc/platforms/pseries/cmm.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 4cbbe2ee58aba..9a6efbc80d2ad 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -548,15 +548,9 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>
>  	return 0;
>  }
> -
> -static void cmm_balloon_compaction_init(void)
> -{
> -	b_dev_info.migratepage = cmm_migratepage;
> -}
>  #else /* CONFIG_BALLOON_COMPACTION */
> -static void cmm_balloon_compaction_init(void)
> -{
> -}
> +int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
> +		    struct page *page, enum migrate_mode mode);
>  #endif /* CONFIG_BALLOON_COMPACTION */
>
>  /**
> @@ -573,11 +567,12 @@ static int cmm_init(void)
>  		return -EOPNOTSUPP;
>
>  	balloon_devinfo_init(&b_dev_info);
> -	cmm_balloon_compaction_init();
> +	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
> +		b_dev_info.migratepage = cmm_migratepage;
>
>  	rc = register_oom_notifier(&cmm_oom_nb);
>  	if (rc < 0)
> -		goto out_balloon_compaction;
> +		return rc;
>
>  	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
>  		goto out_oom_notifier;
> @@ -606,7 +601,6 @@ static int cmm_init(void)
>  	unregister_reboot_notifier(&cmm_reboot_nb);
>  out_oom_notifier:
>  	unregister_oom_notifier(&cmm_oom_nb);
> -out_balloon_compaction:

So silly, I assume before there was more that happened here?

>  	return rc;
>  }
>
> --
> 2.52.0
>

