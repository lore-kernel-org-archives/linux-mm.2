Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5212ECA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FCB08E0069; Mon, 11 Aug 2025 10:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3CD8E0060; Mon, 11 Aug 2025 10:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C158E0069; Mon, 11 Aug 2025 10:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4BE8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:59:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9D421601DD
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:59:57 +0000 (UTC)
X-FDA: 83764786434.08.C7A8926
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94F51C0015
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:59:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jKiYnbu0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qGyLoW7o;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eke5O0l8ECzfh2oJPq6z4c+0Ae1qGlDC7hfldsYPOaw=;
	b=UeLJ6r9HCIMGoFhIZWr2lViLrFijWLEQkx4Hr8mN/Pu/yaHU4ksH8r+aXMNugQRa8OqYBJ
	fHpfWCzTZccv/9BcaXCWj8HXCwtaUEu9UO3SsaKTkavcukC9OUK4zhqeRd6/YrjW3ywygs
	oadjDCVU1jCUoY1ks86Wd9cagbDn4C4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754924394; a=rsa-sha256;
	cv=pass;
	b=FrpaKSFZb3jfJY68Sg5EihLFckkVmtSxtBv7Jx7hbrlCttxmEzwOpdcuR+pOaUQ2wXSSy9
	X7HbyoLzIqZ6fWvim9RB0Ona/YO9Se6pBFdDoU3UDZVSeCuFe1a1sMiOC7Hu9r+5yPo7Du
	JpR/FTYewVVNN06oPym7wURtaEhjfTE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jKiYnbu0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qGyLoW7o;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BEuFZm022462;
	Mon, 11 Aug 2025 14:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eke5O0l8ECzfh2oJPq6z4c+0Ae1qGlDC7hfldsYPOaw=; b=
	jKiYnbu01emWedc83J8svJFfHcAM63P2UQs26zXo+DRuD9QeRQwi1g4a52H4psjw
	XKL8u8YBAR78KQTYqvmcgXEX8jXJeK9dvICxBsTxDrcasLZUhzhbm/XSOm9HvkO1
	5AvwRt5HjdzxjCU6PSIOdQv3jDI8Qw22YuMQ3U8W8TeobWpsUAWpdHMDQAH1QLPG
	E3uypw4Ac+VMwpT7oEWiAZ2iksFBOkIXytiTVCqKWuOiBMIUhIl5TkePLA09UjCD
	fCkLU2KTSoLV7lTXKp1caLbzI5Uil8GeX8lQxibhsWcf601tpJSGftlx77936y6w
	Ldj8UAFhB/mEOsQqWDKXTA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf2tau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 14:59:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BDvk7s006371;
	Mon, 11 Aug 2025 14:59:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8h5wt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 14:59:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mNPTjYYh/kZbhw2HS1OMxhN/gDsjuNAb2ligXisIlZBKsIPQpvGoEkkuDVZLoCHQhhq6P+YfztJboVH6y2LreG2r5+JaJuLNjbZeZd+hJkUR0P35jxQtlK0rMDMwnR49kQ/QEZ0/O9cqEsCl3mj/VvwydxNkUbopg7jH/WhR3CDmUtaSd4uLbViZKEgBoFy7Fufxd0Ze7h5AegHDFXjueMhs+QrYn1Gl8uKaSthwEaIjA5Uf+rt+2iMl29rRENnjA+H1HEEn/yiBYQsDxSm/sFxpcPHgrVhyx/Hv5W/Lu2ovxCbHcVW1Nm65/U1491YCEwO+pjVSEj03yXjnitL59A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eke5O0l8ECzfh2oJPq6z4c+0Ae1qGlDC7hfldsYPOaw=;
 b=RK97wRLdoeYhnjhh0DxAxsdYzodvuycluQdbz0CPQa06jGn/VgL+81HFOxrLJECAPHjptyiD5NnPAgHo2ePwZZA8PjAybtG+0poBOglhlsvYLMfC32mqR94qJMIXZnhZSY5QC7z6jfXJs+CaU/nZln0kQkH6eiHoSXMgA6rguoLz+6ys3/mY9bIPBQ0nWYk/Kuhue4q19S3Lah1Uq9V0LMPW2P4aN35prV5d00CoCUlViseboXWqyH2zccFFSf516p7aoq2dD2qSy1luvv0gtdMTlR0jwPzPdzQYeCcL9tsFnsyJ5FJQ830iNfKVU8rHSNDoDVZjIo9Cgi7xUKzRjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eke5O0l8ECzfh2oJPq6z4c+0Ae1qGlDC7hfldsYPOaw=;
 b=qGyLoW7odGm3WMf+mMAtaJx8JLHD123tRJgaWWClhol+ZvjDZHan4OA7pWBsM3gHc39rdaeaIiwEGoGsr230GPSWc6FFPf6AnghrXot/jX+DdfgXtq0GZDMh7pYdJPhYlyVrwDmo1x1+BVxbEyrCSAL296qbDVqij75tj1WHql4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7553.namprd10.prod.outlook.com (2603:10b6:806:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 14:59:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 14:59:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v5 1/3] man/man2/mremap.2: explicitly document the simple move operation
Date: Mon, 11 Aug 2025 15:59:37 +0100
Message-ID: <0a5d0d6e9f75e8e2de05506f73c41b069d77de36.1754924278.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0027.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ccd0d70-1319-4ca9-f383-08ddd8e7b6f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yAet+M1iciP0H/clGwxbRHCKN33BxUWTp4qjyYt2UzFDan6U4hBDYkxF06Re?=
 =?us-ascii?Q?pthO0D1g4/ejxnH1Sa9lQpJuvYRq/U8Mt6i6x50MWnBluZqOYID0df1LgESx?=
 =?us-ascii?Q?bh+5wfw12ON7zyKl8ebpgT1YqhON5XW9C9l/LFTRNukwrmIJLrCTed+7DZbw?=
 =?us-ascii?Q?5WftkSCtOl1uchWZ42ja3hdUQNET4yiXmrlTnQt6wWH4OYmp0Q6DO05446sb?=
 =?us-ascii?Q?4DrqnsABdr/2F50Gl/aeCie1BYrruyoiNzfXldNG7s3zV01tZ62/eXKHmwVn?=
 =?us-ascii?Q?yVqEH3N91yViLp9xqPEhAciLgmzypAhI4JixwFD5Y3cjHborhkL1hWqEXv9c?=
 =?us-ascii?Q?6vbv12hW97JVNb/qsU4NhPYfhAX1SAsfc3ZR1lhjS7bRsGXHMoclUjoSgYIe?=
 =?us-ascii?Q?arUBkN/heKTOQiNI/QKpUMb8S//11u69mKB6ukq0BIZ44451XBGf5KIgshgE?=
 =?us-ascii?Q?fKofxQMC1mSf85TqoItbAXWDfvjroKSDLWcLnDtol6mMsS6oJZGaMUS+tZsO?=
 =?us-ascii?Q?uujAIMVrY2Ztge9znx9YxkXljcTKpvAejAMWUbPoyGOYLQGu7t6oLN+5Nhpu?=
 =?us-ascii?Q?fzK0oNbsMoEco5bdtaGSkmR3bmeRntQO4vuql2AeUWUzY0fdt56I6wuqfFAs?=
 =?us-ascii?Q?ws92kEbWXA+YzRcMwCklVVh8ngDZPKTHiglXfg7wnGf6N9lHUP2Ep84KRzmq?=
 =?us-ascii?Q?35P3q7Jp+cpRWTzYQ7jkqLz5xp+VbQYwVgTufogNzGtWA0ALsBvuqQnYtGG0?=
 =?us-ascii?Q?uUpoUcKfUWudWgHloMCZPnQUmPOgiAN+nyoR5m7x0FrX1tUrbzT5T7597W8P?=
 =?us-ascii?Q?OoJjGOHh2bcpAYN85A3JUh1DzXBEKD1h6UfcncdDGAIwfhV4PdU4Y7qGq1EI?=
 =?us-ascii?Q?M0nIpJMDgSS10SGTtPsfZJKxS+xnuugx7Xd/ZpsUCRvF/4VP0GFvmZi+WDtP?=
 =?us-ascii?Q?tuTKFMwRMo9DnihwjLrQjSe83w58q3oeRXFoNCOl+zPRoWJeSqvC3m7HGLBh?=
 =?us-ascii?Q?XmMAs6uCXrpNBOHWOjNQ4QQRTz/6xS9iX5pSFrl82VpOx3wFl2tjTtKt9ftk?=
 =?us-ascii?Q?1ue0pOfNP13TqudBpmsNygz4GwNX3fzLHJ/SQcqA8/irgaxy+3BXgiNdyorx?=
 =?us-ascii?Q?uhhIBWZahBE7q74NzMZ8dsE1YmQ94FpB7cWXuOGJqMQ6R0Fo+oL+6tfQIVwg?=
 =?us-ascii?Q?TnDNByIMu0t/7wRuvI00jHEQmDFhL5i5n7O56R44oAMAckybB0iwqrMv7Gtk?=
 =?us-ascii?Q?htQhjbjqu2EZl7NfxvuK/cv0dUTSYEaYpskE1VmpUiAfKKLQ3hkAyENFmTrW?=
 =?us-ascii?Q?bxAKIJHB7hj6tgEpaPVRb8Kui5C3AwCPya7PNudKSxO2qhIMcepEiI0eFmOv?=
 =?us-ascii?Q?V8nkIMRvnzf6uUEH/chu3Zjvr3cEgpAlCy5FeVeavEerzLNSOJCe09+ZxOoy?=
 =?us-ascii?Q?wXVnHcS6jjc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pFtf+muzLuMw8XA1UAQpEh3ypH6Q1Ek6kpBxUuv/ZP9uXonbvTWn2U9J9avx?=
 =?us-ascii?Q?pxETDDAOqq//OkaIGARYFZhZ9mC5b59req4jV4fZldoT3as45nJRu6y3W2ZG?=
 =?us-ascii?Q?uPC5aieNkX1D2l+m2dJ5xw/yiJQznhakMp6j2M9hskwJvs9lRGEI6kOkUxP4?=
 =?us-ascii?Q?6Sbgx30oiRM/eu1l5mylWeLY4tUPAhN7vPfFmj5Vju1fduRm/dVYiQ8KY7MD?=
 =?us-ascii?Q?AwlMd2MohgypIVYnZmrjmystzxJUMac8IXg+GXsWugcfJUosTy60WhAk2oxB?=
 =?us-ascii?Q?69jLTtDJ3QM2TYNSHv1jgieHyseuW+olHE9yOJimMhO59ITLjfsMYlF/+LAv?=
 =?us-ascii?Q?1G5LQcQ/Zhf5wTbxye8EHveLdzxv3Cxd5LVZS990vADRwoVIDLzRvmMpHgXL?=
 =?us-ascii?Q?vAVYdByC3xGfhXcel33KCui7YLhm08MFOhvUg0sMhXZ31PfemhH0wM2Zn3/I?=
 =?us-ascii?Q?IyEkNRuXoMqrra0CQ0Vk03b6ueIEpIPtqSqM6PgwyPrJGEqNiUgeS6moUyVJ?=
 =?us-ascii?Q?bKP3sLmJMiDP/6zMLxyOwxl8wtdcfO8x2gntA//OdFu0lnSU9r9PiTTC0mKK?=
 =?us-ascii?Q?95MmuGBGPFz+IgV//Z6CO2tv4cQjj0Cv+sPzRY0wtBf28+vkI8KsJcoyZ/Dq?=
 =?us-ascii?Q?gXaJyZdlcTPdq1e566XnonjBbGdROvYbOuElfJ8xjR3Ih1msfdge2BnHHAwH?=
 =?us-ascii?Q?29uyQ/eOU/pB/BQ8778xLBTveecdc9Sxs/eMXP10MEVAh1EFqOf8y2CKI/+N?=
 =?us-ascii?Q?df+Z3WpzBP+mALmHiyKL4n7EW2nsrVd4Dx2LK30AkXjYdDdJ44sdt3czlmGD?=
 =?us-ascii?Q?kRJzmlZj3TE52GQMqfyl7FFbEG4mqC64AiKPIVSB1FdlmGZderyjGKl8hoc8?=
 =?us-ascii?Q?w6yNcU7fZTCzxVYSVmJDFmSjWXlgs6nZZOBvPBzFiZpyVBTg+or+Bi+nFZvY?=
 =?us-ascii?Q?hCk9rdQGy4yzqZsY5CkH15sPCJX2mjp0C31dJjSR5OAjmYOJksGC1Pvd3w9v?=
 =?us-ascii?Q?VFrglKGHWC6Ywa7ga+2YpbZPBB75ZIFYRjOiHLRLJRE9Ds8KuPrjBcXS78mX?=
 =?us-ascii?Q?p2dicPAyQf2N00PG8n11Ur34wfiwBh6N4xCjJOXrY5T/2+iET+x/qmD1vubz?=
 =?us-ascii?Q?TiZhj9y/bzQtI7YdwH73AjBhSFuGqniX4PY2goN4vaetdXiZqYjdnJRmuhuM?=
 =?us-ascii?Q?4JKcK+pTgqPtmV75z1eZaMva2N75FxjMR6nIYYt6uhfkspWNR48sxfVWR6eo?=
 =?us-ascii?Q?/1wAGvkKRSZFdPGAMSxvC8QVgvNSDO4fcfViD0zQ9AybdjvBDha/sxDSEeBB?=
 =?us-ascii?Q?S0+FdOwXyvQqRjVF0wNycqJPP3lg6zJuJb4OX1uV7JMtyWlhOH7aEUpFDtvU?=
 =?us-ascii?Q?O1Bc6SDr2Q+wPDdi60makevkrE44YnsaVlh5dZ09QTsSSiYxye58OkPodEfr?=
 =?us-ascii?Q?s/VmhW/Qej9nXCONPg+PDAvCfam3aCQarL0e3um44koMerMIwNBZ1guz/4zG?=
 =?us-ascii?Q?C7NabQWU3r4/6kbhQHvHC55d2MwGRF+GB1WmmXLYewOCtGmYk4dft5WWBwh5?=
 =?us-ascii?Q?MRLZnCUCtpi3ZZnB+plPudCs9NbiIBDC+IUyG5PM897ItRPFVONs6qEoMvVf?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RGs9V9ppw8AoggBoQ9wVgtwEl5dmFei1aIDNcu/bt1W9/J+OlynZdjMEExG8xKDF8/lHhkaHnUFX/W+MTsYW+yIjr76XVV4Tyg3UohhG31ob+Qfw20raVRqTr7+rnlrr9RWXTVo/1U+AXT4P62BNY87HZ2e3eRNSThF/6NOQnhUul/7Q23qdxfBTML6CxyHA9tkfs02wiKkOJFCd5yrOEWOMxTf+8yQAAzN4k/xQv16ki2+EmK6qa/tjEoHQLhN014sgP3QOooMq5WL+49tj2qKrGRb7c9STkzO0w5iAODzT3dlCewVCOwonYrJetuUmG49j0QReY7KgrprfAGLeDbVcHXUAnCP2ploU9PDxnnop3HK7rs3hQRVYk2KuRGN/tUJZxkXYq/svKKlUMKhLDvqmS9PTtjN52nA2ShGMx36OhiXzjUThpZzqRQtkXbjscjnJQUj9cJ1BxhGUsxZdAMFXAwRDt26x5EnvXO8BlkZ21YugBEEX75MS1LbiqypGpqSASWqIii032ZP90NgYgndgbyJMQWi7H6gG9zO14nHxAEEaNc+QLBt9xJwp9j6quul1xayuUubSDkRSoYnxuEEImh9YWvhr5OI1/44FLUU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccd0d70-1319-4ca9-f383-08ddd8e7b6f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 14:59:47.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tq4dVm2nmHOOIpAT7U4m/t1G1eamrt8bZQI7o2zkSKwgd8mb3zmSzy7xiPKfwHeKPeVeQimBZb/dO0Ahp4Qj+2tiYCO9BAtmHnILzbVPJ9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110096
X-Proofpoint-GUID: hQdQs00EL6xIbfGyXcbtJCjaPSp3EKxv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA5NSBTYWx0ZWRfX1dcbAG0GAkhv
 cJVNE8OXAoeiVwugNhgiuiW6pjiVISitgR/DihgQBAn8Ii0GS6QJtw0rWoLHvhjLW/7eO9y83C0
 IMJgrG+PR1fPSjNBECi/WAyr3E/BxATGVtBdO9IGS67PRlllJGGfbJZ5JpZ6AxY3lJUbGHC1QV9
 6TfBx/XPNsvlnRjwJ2RGRkVG2E0mahYX+QKH8rmZLfodKuaCo4tG2mJb1dpIFGOoUy+UJRdR/Ne
 dvUqPJhlTAvdwaHmuZOBUoejJPSdoMgTEyn1tIrY31Y9LLtlI4VJGPNy8MusE5zpO/OjrCRVAMk
 SsW2q7WyCNFV4cLr+CHhX5GgKL0GLQnnO4PnbkyRfciJFGlVNZJ/8FsIer44VOe3sqcpjDu/8eC
 d3DzEm6khDEvHWo+rcPTedaJ9mkoDC8ubH5uLaDHipWeD61IOOroP/m2V02WhGDnxIK0aT1l
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689a0566 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=jsI8mISQ8N6HiLSqmHcA:9 cc=ntf
 awl=host:13600
X-Proofpoint-ORIG-GUID: hQdQs00EL6xIbfGyXcbtJCjaPSp3EKxv
X-Rspamd-Queue-Id: 94F51C0015
X-Stat-Signature: e6feigt9ku5asoxfg76mzm1edwt16fyw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754924394-166247
X-HE-Meta: U2FsdGVkX1+lY+KsxfIa5nh7dLGIEqhlJETCgQIvaxRKHExXqFkZ1AAxnN7Nr6EtoGMNht/q8BcikUPl0CMtsvD7MJ42c+ewejeNpXnbyuQ3EWz6/1hQZlT+siXIl5aPfVPJwIk9664W7/ioRbTPmde82XEkFa8ugwQuV5qZVruSeZpFk5ahfcdul8RIKK7W49LQgh2zj20k0Cc4s+UyhMXc2E+M5iTl6E6N7Nx2WRxBSoHQiwEP9tJEKJ0y/wzmS7FvSBwSkk3ERHFTjM9BdFaS7E5A1SoMQI1o7SPgeqZdqz0hJ/TpyjqGtlz6mUESNHmASXCCpiBUSrZoB4pU9uyLgvXLExK0GFW+blKT8rsfHrSNNkFBH3xvDAzZDAT+Gjcq8yQM2y0sWvmVHnuvfBEeYJjt/MaQI43yD6MXAHUVYdV3hCIvGlt/U+F68kzBi1J1ZiwBcJ1mu66MamQsp72rz17woD95MpExKKbe5PBpAAcGCd8LJw8VJdyAJA1VzXHd3Ili/fWYe4xW1YNJaKMeOAY9r9yMCLlrHzS4VEoqrT8edGOHnqoIJl2QYNDlspvQ1KCCIQMnc7rnan1ArY/1nw90arKhZoG/a9yntLGBUd9dup+DnVp2NOy8JsESKhEj/GR/1R4T76Ms1lWrwyHOwO4KAjR5P+oX5cvAkD2tL6g+2gj43xkexudW6Ih/+CPAA3h9LIrske3Jtb+1AmFSjYgYk+1K+xiQY/rsNQPgkLKirgZ77UB6fZoEChH6WL41xQZhgBQSq+daDesZvPG2ZetvlHJlZ2tjHisimbLof5xSEywJ6HXfwvkt657mVl/l/7AGJtCNt5iFetrBmUi9rntEUQAfBfQzjiOYe7yr4Vyk9hYylKOfCVbtSlzmma1ttlX13ttgtXHS/LzMQEsklcFASe+jthWFYzimgNKsztvAo0xtMg/vlOhk+WveLmnTzxx6Ec2ZZKXD/cr
 g9vpWAXL
 +cl8eyNj4BZ9a4hEuzjM7murcdeu7w+ljj4Sv1F0By74dM7eSmrqvsaR1llb+ChJIvSNvlefGHf7wGTmCzXLip8ejtvkdlu+ROCaP63dCsq8tUm+mnqZIdYZAhW06FbdMQLmUl/2n5lZjrX6tgNCm0Ns3kHKGt/dtCv+1n8FzzSF12YPnJf26qrb7Lt6QQGVgBTRxNOwIkUCT5U7Snd13m9udehF3LVXNvEh/8QiSsh+xv7jd4vnzvZFTNyUAA2eUKkkNYQ6oh2Z4X4pQWTIM5X7OiZoqrTK9jAjAGcRg+4aucc13docSlT9tBQhGGD2xKN/pF0cnGaY5UNGXOFaCV3M5CIYWKxCk0Ykz30Ebz1Zfy/VI9I9xLxixgqDcfWLP76o7jFJbEMg6GDCPUEeCiKHPP9ekRjKPdiMPXZay64m0btb0gon9eIK7G0ChRgV5WyjMifaQDT+sgGg8ML70R0leu1XXft+/d0CwbgrMJ8nNxEGOjEhOQwCJ73Jy2PY8L+YeR43CDDNvweaNwdU0R/KsKKXtFWnA8JCbI8hNvfNZHeH6FtNhgFAKRRb8GP9lzd2cXeRKBqhXwToVDoTMU0I10GQt0ZgpgrqtHnIneBMhVJLaKlNjmCRXOci2uR6g5LIk+w2Ej+ZWGmO521mKxqiZBvHdPVcAcG71NRyuA1rxVNf/ilC281hGt5Ec1yHa/nDU8tgPJNE5pPhxu+cHOX1O33wQkLARlI/VNscvHwLPAuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for discussing newly introduced mremap() behaviour to permit
the move of multiple mappings at once, add a section to the mremap.2 man
page to describe these operations in general.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 man/man2/mremap.2 | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
index 2168ca728..4e3c8e54e 100644
--- a/man/man2/mremap.2
+++ b/man/man2/mremap.2
@@ -25,6 +25,20 @@ moving it at the same time (controlled by the
 argument and
 the available virtual address space).
 .P
+Mappings can also simply be moved
+(without any resizing)
+by specifying equal
+.I old_size
+and
+.I new_size
+and using the
+.B MREMAP_FIXED
+flag
+(see below).
+The
+.B MREMAP_DONTUNMAP
+flag may also be specified.
+.P
 .I old_address
 is the old address of the virtual memory block that you
 want to expand (or shrink).
-- 
2.50.1


