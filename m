Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4BDD4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF616B00CD; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33E36B00CB; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C82E6B00CF; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C03F6B00CB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F2901BA92
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:30 +0000 (UTC)
X-FDA: 84335207460.06.7118362
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2CDAB80004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nZRwm0xF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sX5MPXtz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFj5CmPxuVL2J24845mlzZ3jgvVx4r7jprQdYuEyCXc=;
	b=c1L0DqmPFF/0Prm9jcH6cjqpQqyfbZgj5fCC2o7ClLIOiv4QxDRT/LszdfraER8wz3zdQb
	cBbhTWbRgSOAQaLPrM+337OXvv1U5T1g9gfI3qNH1ijbEaFADD2maP1fPDBeStK2oKoPyM
	HONoTYHoL80/efNcs8+COsZVLZKkbB8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505847; a=rsa-sha256;
	cv=pass;
	b=6HX94Nx4ewKYJbg4WX6xscv823tCot0W0pYcPMbqS71jHQH4O/XABLTUhmiiCl83g2PTj2
	OF62zGJ2c2GaknxdgcRQw6+K4d3x30XLMEAF3HR06gOJ3jlrQqNRKBR0X3Vb7PaH0bNuHA
	SCDZX3biEuWfswtzQDIesJmGimjcrwk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nZRwm0xF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sX5MPXtz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEoA1T1362590;
	Thu, 15 Jan 2026 19:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rFj5CmPxuVL2J24845mlzZ3jgvVx4r7jprQdYuEyCXc=; b=
	nZRwm0xF3pFaNX8iKnzlWc7a1n5g4i1odbbOI+w//uhhK2ONHV8oQSHffAbwImp/
	zwtFryEza0Y3ZaZb+g+35yLf1Gq5i2Bj71al+9XfjEDoACEdf4KFX98eTGIkCW5f
	SuSwRfoqE+1xn6UIU/CBqzg5SqJjdu0sE5Jyt/OEQGmwMG8xb8Z/83aGU7hPCjTE
	BKybbcL3Zr6IT8ZBwgvdgiUbxlaOLJlJrPhiPMobg8IbhOusWmCQf9qgt3mu15f0
	T5+IRCiTLZiIPK4BS8phtCqRi9DKatiGCIPOyD/eYWltrFiz9BJCHFLnRIb7bG02
	DI6r4hqOM5Ku8+V3tpsTCA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp3s4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJOrsw004503;
	Thu, 15 Jan 2026 19:37:20 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngu7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nETVIAYwEUPWVXQnVXxQ+EIsJ/+bjHFcKmLAfy+Z2noQtKrhK5kHDDE2AMmnwm6TT0J4/X1Ofv+/kDJHwyOe1EZTucKzzqWWtjlrsiG560LTm1YfU66vzpDfDrrkFhJSsKUK9kpAFzTjCae2CEHfb5+sgBIXyzbtHOO75DMUEPVN+phHmA4fi6Ksb4/NLY/1vUzT98KOeFPPxLmg4iz4NUbNPE8KxT1r2MSLODwMT+ybzsrbXyj+UEaywlPvLD88XHkoAenSGuTw2w/XZ+RI+M2fG1k76RWQz4Nkxfc0oNdTSzqW2EXosauFPBUw1Y/PCq0OlUHHdtS4MZrQTSXERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFj5CmPxuVL2J24845mlzZ3jgvVx4r7jprQdYuEyCXc=;
 b=Ul6Ba/X0LS3q/yFywZMpBWoASkYvmgTTbANA2R3BIhktIl9G1bUchsKEuwaRLlS6S3sjC9bjdoafsNHYq0+jFfavAI1DPyrIupGqdnNfCxHcOV2IDTTklK5zo8ymCEHOdZKwh/HNrfqXycKtMdSC96NWdxZpANVM6Au1tEneX/HPxji0ZYX2US1Byx+LhT2RVsd8t30bRVZct7De49Wou4GgQYalEgSWRjJn6x81Md7axTYlCONnZfi8Gj4Iqgbfsy9RsnSAeaynubJ1thbYM/rm2bHbKR/xi1BlSq2aSm36V/GjFqoChDEsvDjTKOTekq7qhIkZ7p+PEru9WZdZtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFj5CmPxuVL2J24845mlzZ3jgvVx4r7jprQdYuEyCXc=;
 b=sX5MPXtzHohviLp4V9zXA8PgFUA9ureh9qByTryYl8l8/ixDKlmchYVB9bovUFFhxbIRsnO5UKJEdKUkbtgVsbF4+ngngjHOFIGKrO/cmNu3/WzqJ5ZKxqY8v/sLho++UzX+IxRnIH1xIIndbNlryBk7wwuodmmH3DHicS/Rk2g=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:17 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:17 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 09/28] maple_tree: Correct right ma_wr_state end pivot in mas_wr_spanning_store()
Date: Thu, 15 Jan 2026 14:36:28 -0500
Message-ID: <20260115193647.1695937-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 7679352a-d1f5-4a39-81c0-08de546d7de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r5QvV4Z1Rncq7T0a+IfPo9uBqxq/PpbYWRpRSQRVxLCuxLnLiisvSwz0tSJJ?=
 =?us-ascii?Q?vIWd7ID2uVMgiK2BJTjKfKTmmgpOO5XXENhBbekVleLfePdVt1uwH2x12YW3?=
 =?us-ascii?Q?h4Or8TqSnpmelj6Hsypqmb/GIr+1mZCbNUeu0+qHcb6w/MlXn2kYI7RgOrRy?=
 =?us-ascii?Q?TIwQYlcwWoweDNvsouuJ9aRjDCk375GyzJ0+Z4ag1kDMDFoBhaLmOrbb4Jz6?=
 =?us-ascii?Q?FaNnkEulgAZ69Z11BqrbHFh2+YeplP4tJ0bINPq/G4kXVlyjTIwtXbyYfQwd?=
 =?us-ascii?Q?e2GbsPwApraWLddAMAEk/4k7gPtACI/GukR/zuy80yVfzrCZrfCH2m5NzZaG?=
 =?us-ascii?Q?Fi4DJXUvieDARtKTG5DgaFaKQasyaCoqLIFi5jA8xeDqKgoOl9tLjQ52B0HV?=
 =?us-ascii?Q?H30OQMj/vH+RDH3h4qUKz3fjhMKlA7Dauo2zToGC7H/t+7uEFi0UKqovTvM1?=
 =?us-ascii?Q?W49wa1Sft0bFTHCWBGYyiWuAA+OiiVE1N54KKRXCD1brcHFaNhcOuw9vAOUg?=
 =?us-ascii?Q?mmBQcdBcjXOmSBlh+eKfuZYNPjhimjFUV78H8C5U9N96dIOWCJY6LoiObMxB?=
 =?us-ascii?Q?PCBbMX3Ytw2xjoOqhu0K4PNFL/IS5s62uxAxRt/ywUeqnuDdJr6YVS63HRut?=
 =?us-ascii?Q?/HM9PkbpJzFk3hozpxRn17+KmuYbTXx7pV5FZQOwNHdcwv2Or7Pkw5aVvNzA?=
 =?us-ascii?Q?9UPYm2EpSF2to3fX0IXCcAxbxArnEFll1VuX8c3PC+nxhn9ISwQ6gznrjXMD?=
 =?us-ascii?Q?CJc6pfHt8d3KWUqG3FYGH9nUKQKbJ4/mGeZZhJrM+xS6MVySem/GVFuK3ZvG?=
 =?us-ascii?Q?JjVA2Lycz3A8xaTHgrVmOAAY4eL24VNhDjEbuRT4hsX4FAP/+r00Ji4QY5O8?=
 =?us-ascii?Q?9lYeJqVKWQZhmryRuLiPmCledkJOeTAwBFfW5V7oFL5SXtheZP8tymwyvnME?=
 =?us-ascii?Q?D/4enqhlOy0apHoHecGtlZp/gH1ZO3GFzM1YLh6rN85+GgdobcCeflhgbb/x?=
 =?us-ascii?Q?iyRZOsNX0VNGGZ313W48quMQpYVW2GjOOTq3Gx0hpn/WJQfCUuf3ZF0bu990?=
 =?us-ascii?Q?yxPYSCWzIXnjiYlcL6P+VS8CQNxaCfuBzdZKt9ggc3l6EPDIL019O5q1QFex?=
 =?us-ascii?Q?iLBGX7PvmoLVHQxng15JhHiRPP4UwdJEN0e0vFS/5COfbTBAVzY3YVwUo9i0?=
 =?us-ascii?Q?ILnRqW4lykdw7HDYCEKyjat1zWpl7Ds1IqhTrtNnoHd02eQFNBbauSGh4NPZ?=
 =?us-ascii?Q?OvATKPBz4gEArEAwCaOQQmJhWKkYv+bSof2QPR2XtS8a5asrtbCjYR2Xg1sg?=
 =?us-ascii?Q?iVP9dqI9pYtb1SnhXE5cC8cmNX2fDPx2t9y3kP6gwFiZkW7J4qN8VMAGgJiL?=
 =?us-ascii?Q?oZBYWGRnGUk1G+ZYE9VDMASg3OW2KETFK2hpupmidg7ASY4m+WAx14HyNgE6?=
 =?us-ascii?Q?ycaIwjUyJOL1Ec0wsUxm7A/OnzndEpOZ4pJ4VKmWehg5mAmVQPF1XCPNcBMQ?=
 =?us-ascii?Q?pONsvpgstfL73J9auRk/np+2XBijPrYy8585tqtpGcs2qOmSAh7TYfXaQm/C?=
 =?us-ascii?Q?ItKFzmDPyOT0lxFLYj8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?smAJBIqXY36wk7mxvZdXukSRsg2C6CiWDTpEkQYu1DYdzvowBpzMqOFatJVW?=
 =?us-ascii?Q?qrsC4QbnSURIux3IKhy53/LcpBmJ+JfNwHhk513ZCFZSplosj7iHOKXsNXra?=
 =?us-ascii?Q?9Az/93+qudtlS263myJhNkwYE58Z4hthxREtfH+qf/PRvfcF/fbPtS1K/5c4?=
 =?us-ascii?Q?4JV4lO34Et1roRdq2wohRwqCoKPBXZoDXPW3WmEizPGrk8Wzinij/Q+Lw6dv?=
 =?us-ascii?Q?3Zua7ATkFaC+1baeJtBdJutNtJboBe0T4cjLJcQ5sErzSUBXE6e3ATsN6GHB?=
 =?us-ascii?Q?AuH+0cEsVqGGCBpz2M2FKkDwNpNezpySrkOfS1rfmjt9B1meREEsvVaexJ0n?=
 =?us-ascii?Q?7cY/0CSXGyRTLwEZS4LYskzAld8VCbzCGwRNiZnUfLbKnnXfYOPjC8dcWDj2?=
 =?us-ascii?Q?rTFUSTOWSp5C8uNgKQokWrqV4BA36j2DC5EAx3vqt4jFybJcg+kJziHSPVYl?=
 =?us-ascii?Q?xmYgHUEmVRXc+KK8M+HMDI0G6fI66Lhu4zFePfiecyRWjc9FIuVgmFCCS/yw?=
 =?us-ascii?Q?zpGZDlJpQbst1GQApz+8aK8FOH1m/xOXF68FkfOtOiIVgm6clSFK5DjNYQHf?=
 =?us-ascii?Q?s/zcvbAkKeJWeRZn7BsoZ5HILq3PTJuJ7056ZS0DzoPTnc7Lf8Spud0cOB9M?=
 =?us-ascii?Q?HaTJX3SJw73e1CgzJ+xkM4ix7CwKz+YgQJmvucIDSEyrGHOMVxks4bRK+p0d?=
 =?us-ascii?Q?+x1qFjIhR6XQIzhlytIz3EEVFMPkoOTKPQXBFLU6NxllK/9PDleXuQQn/8Ag?=
 =?us-ascii?Q?cL8icvrzMmcblifKeAGWpnaa8+nkwoCfs8GaazZ1/0vwlLeHUG7oxGPJlase?=
 =?us-ascii?Q?xaSafe6cwIKrr+jJ8zSwPCAgIdMPOzj6auNXdZeA9YcSitQHx6y5l+iNlx3e?=
 =?us-ascii?Q?rFSlTxBZUbbc6mi2/gTWTV/URX9fThHB9Mgb9l10ComZuYyqzMlkDxV9CRwq?=
 =?us-ascii?Q?hGBPC5SwWxq9VpC9kGQwSHud04fHxqHHoa2dXMV3y9p3NbIvi9ZBpkAgbpdM?=
 =?us-ascii?Q?Du8fU7+5nxMqrV9Vm5M97BfZfU5ewN4yaezCwKmIUfbDzyXzOWPvOYSSlD12?=
 =?us-ascii?Q?WWhlPTfRfi0PLOJdYg6x69RSwCqsSyWdNKrCbgJXcdvqf1VSmv17qxDKpkf+?=
 =?us-ascii?Q?gEmCuU2ZNIjzPES1X17MtjWSIcs3ejXgG4RdljMEQW9E3qprI9LPa6WTTgFq?=
 =?us-ascii?Q?mXAV6eMbqUEJDExA9ckh83C6Z28BYF+n8w+BTJ46wTNCB3R22GYkOEYNF35n?=
 =?us-ascii?Q?hjtuP0jmjUQVaF09NCaOY1toQrgsRoA94B6g+VwBU3KTau1NW41pr8PbqziM?=
 =?us-ascii?Q?thkfKB4mEYEHJxk6CP/pv9yerQUj7OCDyu5Cda1VXgxTAQrQiV3KaruxDQYL?=
 =?us-ascii?Q?ALQPICUgstLmWRDSASxede8gDGXO64mQKTAPrhN7T2tndyGeG7LX1rbXZMPs?=
 =?us-ascii?Q?2+m7B3CUAMtbuqbSoo/URlCyqLyRJcd7ppju+TSAn/iSn5Hdx9akqXf/0Fu8?=
 =?us-ascii?Q?eP6wUWL2OaGiyJKYV4n+Zu9uo/QLtDoCyWx3ChkVMjbnZKA1NICD6H8A6gcU?=
 =?us-ascii?Q?D+tnrAkT5cNO8YFZhOJs+lGlRPUVujwYlGF3VrsWo5H5qIu0YnZBO0dSR+Dz?=
 =?us-ascii?Q?mlKHUlkY2cqtlf9H9pQM7t3jzBhr9ib5ak4PhEloSzh1lVkKhnzEoorYk1Ip?=
 =?us-ascii?Q?5BvhHi8IXvkL2aMmFuQbdiyo1BXpxJpJfDmejtXjEKbWLFh1pEmXkOVInYkb?=
 =?us-ascii?Q?veYreUp2sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/29RLRrSkVgIHejmBXaIyKvME+KE4u6NejkreYBmfpZJP5saICVsh3n+roeHL96d9/kcYznwDDywsdIDXggbIUNQmtjAktcLcA1B1HNAcAr07dSdUo5fug0WheC19zaKX7AdL4NTcGuHrYrKAaUYvbGI77Uh2iRw7dcJBXgVc8qV+Fp/VRssQ41K/8fq8ivpJOBNkuJuhK/k/ekx6hi/gTl1Qg/OBWRrIZxkElTEBace0t5pwhhudopObERiw0wzQ3p0Im8zT3kpsSdALS3r5KtcIbYw9wwyy04KxhRdokzSNtGiSmcu4Y78zova4zH7h4cdSC0DMo1XQiTiF1P/gbLmSkXYTUzWVGQnJSYN/CSiwJnpiTEU9NILT5KpIVUOwE6tvVADrsVAvfPIwHn+ChXS7HLrpfK3l+4JSwvqM4rtH8zniwurtgMKWP8nFsJt/Mi08IJXj0PaYfgCZQ4MzNQJNK4Sp8oe627sn7MrUKETVXLC6G+W68bdOgusc2IosJ70qnQBsL1k9PRcJl4rtjyKRIssawhftR3l83J29eoFAeoZtKPxwRDzZCcnnak9Zf8JLvg7aWEJsLCrR0/75CFFwUeQaYQ2XqAGB2ZEUzY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7679352a-d1f5-4a39-81c0-08de546d7de9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:17.4695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NTGr6jfD/CpNIfyiHOggveX4vyUM/DgHbgUgBBZX1BGvg0xDxZISHoi2HS5L+P7qLfcM9hwcqlOGFjt5V85xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX5IBBIYJlnu74
 mlIIg3ym/Wkkb5o7XTFgCBU8r0UnJVvUaNGv8DMMNSqJyQhr/ZzsYqY5ykg7BXIQa8x1QlztGCX
 r+bQ8vEZRs3ua87b2gA5hVQKWC74FAH3UH/VSPVqt2HK26cibDFlVtG70+MrruH/tZcN9tDEhrR
 V/yOWLShSmADAzoeJ4yJA0RPWiG/eYvHq2iQDo0CMeQUw+/2QHine0JZoFoVAlXVoKZmeTFUBAp
 aApg0Y03W42kt+V/Wxrg7psQ0uYHnoGa2kJHfUadKpVXNEpQ+bGbaBJyEZtP8VxuOpItzl0TIq6
 JTlmyPtM7DvpeEIb3ec/hZu7ERIKt75PPYyvA04j+FC90QtDjvmQt4J30wS2M59cdmNk2GHG44K
 JfMad9049+ILbTHoP/arf+eP63wfj8d6tXG4dLj1tcBNrGSabxFvLnzcm6MD2Ufh9uSbUc4mNwm
 RI0YcNK4qA/ezuvpxrQ6erMo6IBeeuWm0F15ivOo=
X-Proofpoint-GUID: jCv7Wpm77thIZIjAiTZG2uN1LBBvdiWS
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=696941f1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-8DI_9cH-nddbzlGVogA:9 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: jCv7Wpm77thIZIjAiTZG2uN1LBBvdiWS
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CDAB80004
X-Rspam-User: 
X-Stat-Signature: 9cw54jsr5khsgw1kk7z94er4pfj9ks67
X-HE-Tag: 1768505847-601383
X-HE-Meta: U2FsdGVkX18EPKIooNuPNcZygQam/BiRU/+d/FPfCnChbF4c1Gv+4UTr88EFGg9+WMEAchygtZvK8KhST/w9DENHrPsWQYxcdPH1Z/k2rYH4c0reaMFq9drGsGaY8Wzm3wznoXpszhmFfeSQyW8wID+wW15OVkHYH6BZz1tEC4iI/rjquLnTkmKsVS/FXbfRTg+u+aToKH4UqTo3eNjnqKarR5Ioh4Qu+IIeM5/iodnFY76SQod+IaEi6eAAMhKLQQcI2S/QhJSxSGvCDBoUwSELBhuP5TBMFJS3c0XD2nwwmT1CUycnLt+4HwzR3M+ei7zuT4+Hn9N/7JFBOL3mDrqNnjsLX0JNPGJZY7JRGaTedNdXb5vhMse6GHQCMFj2tz1EmtnTRm0uuNVS/+ABCrwdFGdCS5wlDEPrg7z0S4i6O35Wm+oPc0Wnl5fe7bmBXgyvIMuZe8FA1zNp8hnQ/ejz34qyYCDSNU77jwjDgvcOqZlVtr6nfEZbKEHHz38J/FgBT05RD2eE9k7piIH1qRoYfPDyXzBi01nWNhPYtQ6QmrddQ5xcp1rXwTEeN28cUXkjNdr4U8WVADY0ZGtQT1P+iq9Ni3cxyCOmEYqOevYAU37TOz66JOizMpESpb6QugbU5ajPpYJF4+ZCE1iuIdVtorH8q69S036sTx4ccc70CpbsE/Uk/Xj0rqY5ZfDKTHIJuxhT0SoUr1RZZbvDz6ncL1rMZ/l3/SzFGyh2mbzdYBzZshzBg6c1qI67U3zJ2y7PC8Ax8E6Ma62h2lMS0AvCmgaJFtR/aSPzCOswlSjEQ5UsaGeUsSkt/pE4sEnpS9uLTE+8KEF+Qw2X/5eNmkJericmO97SckGaMn+xxNEuzD3TE/DKIAaSnU8qWf9wa+Jk+QE82bqOU1NU1XBzBLQawoAE8SonS5x3l2jBRgVj1eQSL7SGC2da85JT/uNjzlpanSfyv5Om6iIlNG6
 zlbF9rua
 EegkBxgGGBNIfnFiHMLCp13m1ayUNepyOm2I/z7T8WkO9+n5Xzz4YVq+QtwSZS1qSdtl++FOIN0WpM9gYL4EwTfttanzjr9rgRrcy+hlbGMj1N2xQEOnWNmloPhJjlehs0Mhi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The end_piv will be needed in the next patch set and has not been set
correctly in this code path.  Correct the oversight before using it.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e3b9d6687e6d7..8cefaebf414d3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3494,6 +3494,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	r_mas.index = r_mas.last;
 	mas_wr_walk_index(&r_wr_mas);
 	r_mas.last = r_mas.index = mas->last;
+	r_wr_mas.end_piv = r_wr_mas.r_max;
 
 	/* Set up left side. */
 	mas_wr_walk_index(wr_mas);
-- 
2.47.3


