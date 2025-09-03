Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4CDCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 04:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792DC8E0007; Wed,  3 Sep 2025 00:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743978E0001; Wed,  3 Sep 2025 00:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632838E0007; Wed,  3 Sep 2025 00:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527728E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:10:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6F3A85D91
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:10:07 +0000 (UTC)
X-FDA: 83846611254.27.E394350
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56F3F1C0010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:10:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bP+ga39L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WONY0BdQ;
	spf=pass (imf21.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756872604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9cPOrXmBGSeR9+BRTrhz3aSTsIr/Z5Bf3ucdxdslww=;
	b=8jRctT4//zpHn7L65SVTIk1zHz4Olb0+CyZQJkBr1QMSeDO/2QKAYNSzidSfFvlrsalKSg
	pV98SM+QRPDCHvzKmmjKxCsvwLPZBMUhfJDNThctiG7V27yrqHU2DoQi1vUhikPzJQRUXs
	RGk3/YMl9Rl3r+k86OT18IFAhAOhD0I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756872604; a=rsa-sha256;
	cv=pass;
	b=0NILxMBzBjHUMgNpeYHPkFYkKGSiLL7MMImpApD48klEhtGnkx6uzsZeiRq5KfnSJQ88aF
	Zxac3Fo8MdrdPSZSkk5Kzk3fLEFznfyU1knP1SDI3teF48xSh6EJx2KrGNu2TOFw3FlfHo
	/Vm7kDiZIFhjhlybf+UCq9hsaiGak9o=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bP+ga39L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WONY0BdQ;
	spf=pass (imf21.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582MNWvE001693;
	Wed, 3 Sep 2025 04:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=f9cPOrXmBGSeR9+BRT
	rhz3aSTsIr/Z5Bf3ucdxdslww=; b=bP+ga39L8uBu3mZ/MLISF+dalFk9xp0kqG
	vLX1idPFFFFxZfmT8uyWHLBWKD5R1A5+jTMw58NrD8qd7Cphww63y4lG3QS29+sJ
	Hzg9WiUf2MrNj0XFp1Qw2PvcjmLGfLLTVz6VDjDnXlMbqk2n8QtFjF7YTFZHXiNs
	f7qYrvyx2D0TSAIYw4NmAnpNHs9TEMeo/T+Eew+tUgVflvEnxHFu0rh81Xwh1g1D
	oUeiyyfMA9mLbd/5PiYbyANEI7L4aeLGIVYAA/zRrvFBPR8WYfGR+ZtJPvNDmIUw
	WV4a8xnpU35mSbUj1dfnCkOSX3wCSg0S7gGxkte+Dxa3Xk+0XHAg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4mumx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 04:09:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58320oOS015790;
	Wed, 3 Sep 2025 04:09:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01p4mv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 04:09:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jJqtD2dqPNdKXmBPOnG6ES2QcK2koZ86LTsDR2Oo0Vjq+MaX6bVBVv50KZ3X5+mPDvTzu1HHeoMnfHlNZbXeoQkOPfgnTT7wq/L/mtuL1Y4+NiSk+iBHwtxH7tR7xVBQaYtfWSgf5djDL8QL7nHebghtUFH0sMmue1WgseOHTIi5xQ7dIisY0z0B15JI9ome+X2alqW06I81UjjkQkpu8ajsEUYFuwHKfXYNNNg0yDeHWi9rA77LDXT0px6K9dWPDUkIPX0wuNA2jlmznoGCrmNNS1+t3HL4AumzI1fOhS0kXu89nDyO6/awLoAbg2ZqgSeRB+05RX3S3lF74g6SZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9cPOrXmBGSeR9+BRTrhz3aSTsIr/Z5Bf3ucdxdslww=;
 b=HKY8KWGhqYKxb+8vfjV9E9yRxC7pjaxxUzDnz7x0irkmgDdAk7QDwF7Ae3T8nuayTyssgZ3cINrNXieZ37LiAbdLCQEwex5dgtJW/m4Ax85kFJ/mlcpUb2Lw6eREXX0Odi8B1xhgcNn/Am1u+5dZbHlBRXIENMThV6sXPT85a0aVgEFESnMLlHw+z3r0IhD0rYCgvfz9zrYDvCX29vLftEN6hxaybTvX4xNJ28DTXyUrJrEZ98wdqGdwYr/A0PWYIuPPbeeTRS1yvD62VF/6t3GovIhZ/yAV6KExL+eXAsZ+qtLaeSn7xPxYZzDYaKJbmd5zScwuWOVVVfHD9xiarg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9cPOrXmBGSeR9+BRTrhz3aSTsIr/Z5Bf3ucdxdslww=;
 b=WONY0BdQtwgKgXd0iKaIwQ317Txhu22fFvmeYjmvhgtYjx4Krz9CC+wL9S7dQo3kJfoMu/lHmX/3cpd25zEOP/gHjnBNHhYHY8RDppCM0hC30XuguzDeKxngAzWUnrjl9KifxmVM9coOhmZLVIwaq5PgUGLwqtiXkLV473IMMpM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 04:09:44 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Wed, 3 Sep 2025
 04:09:44 +0000
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
 <20250902080816.3715913-13-ankur.a.arora@oracle.com>
 <abacf7ba-f6af-40ac-b8b4-afe259546c16@redhat.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v6 12/15] highmem: define clear_highpages()
In-reply-to: <abacf7ba-f6af-40ac-b8b4-afe259546c16@redhat.com>
Date: Tue, 02 Sep 2025 21:09:42 -0700
Message-ID: <878qiwp46x.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:303:83::6) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: f2ca48fe-efaa-4657-0f2f-08ddea9fb648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y96CGmQyetDt6YBZfyO/5sWiLu8CWzcVdQTz2DoANghIbtoRU75Qn8n3gmOy?=
 =?us-ascii?Q?HAPVJjeHwsw+ONRcEfEki5diefrj0RC6m5Ue7Ekkq6xC15lD+xmDO6DmZLEV?=
 =?us-ascii?Q?J2SG7qp7TeIL59qmF7G8AY09Bh4yiNBDa9aH98NwyrJSrt0r68Gn7xoRGnqB?=
 =?us-ascii?Q?INBf94TOZgjlBYRneNZgjOuLaN6sXC/9SpG7SBs9Ud7C6dQdl7eGfwjnXYrt?=
 =?us-ascii?Q?0Cisf9KX2RWgN7CyLFLQhJHcvE21SytirwPzz5++URKgv88vZHMpAB2WOIbY?=
 =?us-ascii?Q?8OK9aMZN/0aN0I1U3G1PwlhyC1z+eX4PjvUVqltCQWW8hVFlLuoywHZoviYG?=
 =?us-ascii?Q?8v1gk4eFp36HFBUHjg1xa1YwYJ2dlmSQqeEcft9V9nBShZs2OAx4ODEAmhQI?=
 =?us-ascii?Q?bO0Mh0f2ipjg091g9eFXgCFyPOdAKpuAThELedIKglmMufgQ7kaeerQiI6IV?=
 =?us-ascii?Q?TjWbz3Re8Hfebvp3Q/0ybXIu1mJzGLcTy9jm4Ptdo3gEPU8p7BhUiSOlHd62?=
 =?us-ascii?Q?nSCrLigFFq3Ljj3YrALJczeJO7s5Vd+1dqjaCzi6i3veylMyECCFHnSn8E0K?=
 =?us-ascii?Q?Y0rjFq8CUySHaGutSgtGJ+LtAodbDDKoltSZFXB6hCAdpnoi9AQEzBOdiNo3?=
 =?us-ascii?Q?WekUMbEEXy1/b279+GDqEnsUS1PeHC/2qaSM9OUl7VbTNTCSZF7ciN+T7AFd?=
 =?us-ascii?Q?I4wrMX183/7RI+PegflK8FaGuZ42RGw29ByxhpiJaA++nOBtr7CHVgvAejbT?=
 =?us-ascii?Q?+EEfad8RDqa8nhumRrI0Pz60v38vBOgg4SOmjnJXLq8qxiWrEfZb24XoBFe7?=
 =?us-ascii?Q?LJCx4ln41bYMxykIXmOQhJcjx2d7dJkOoFUtsO0yK5YupkSUChcXYI7WNGhe?=
 =?us-ascii?Q?PJ53hUtm+MsKfocIv2FV0rp9zCFpo7oEQy1HhepJUM2aYLuDf8dRs/EQ/bOp?=
 =?us-ascii?Q?yg8SHRU1gpDXxXStQz5jmwpH2/CLjjYukFk0r3P8+b7yB4iIRI1DN7IOsni6?=
 =?us-ascii?Q?81jjZx+lJLUA8zeezJNfnOwBjfS+kIMtj05vpKvM+QQ20vPz08IyuGcg/95E?=
 =?us-ascii?Q?SUPHesYZjjS675CGv5t+G/eBsoXlbzbfyK0gBSiSk1JcJN1mM9fGoRIX/az8?=
 =?us-ascii?Q?LA5Cql0bKAZPQx8vIcTGd43HDhTBw9IQjtvF9FPmVXr9UJdm/RJv1yGgeCrP?=
 =?us-ascii?Q?uzD2aPFrdsefLnb8xQFNg85/RjPvVA8I0SYLkT61wkWlEVhVEmfJ3tsvlhjw?=
 =?us-ascii?Q?lBbt34aFxJwUBIe95Ae28GQu0uapIbS6LbqyWQLDQBHOkn3UQvhCJw5VlsZ1?=
 =?us-ascii?Q?NVbB1G6x9+wD2ccAS/E+byV7D+ixriYJ0WmX2Eny6kvbDzT5TR0tJxM5XtWg?=
 =?us-ascii?Q?61uRMaHkPSkhH/zVL7ZCuepDjmv+HNa/ZV+oJctCofqAjGrU3g/tGeF1+Ytt?=
 =?us-ascii?Q?HANqVMVUYGg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IV6r2FWRnpXlbLURkuNpZ0VUokDAb/xaO+4IYnPNm3mcZGhFu7w05Oki39XG?=
 =?us-ascii?Q?usLWZT39gzm94O3jpPEfG8QiafOXO90/s7XctO39Db2n7KUjwj93f7G6Vya6?=
 =?us-ascii?Q?94tTe7xUCjgcVJ4s5SxXYiTJDL35e2YUX2I/YX74x2AJg+cTpA8VoX7czx40?=
 =?us-ascii?Q?qoRD7uzHITVZ8aVnITbd3hI6HLJZ2n8bSKUgMoJJZ7y8Jwa/BYagrApePVrF?=
 =?us-ascii?Q?JXZgP6LFfwJ1xoU90jsrjo0CW6u0NucUUZhdez40Z8rWBa9IsNZjjFlNnLzp?=
 =?us-ascii?Q?3Od/zxprgtB2O99NjhWbE/Xs/U9RS6OqSXbNK12H1RHivQOk7mdMAwHjARHK?=
 =?us-ascii?Q?2Po7K9rmXRvCr0E9j8oGaSiG88dMvEQxlt1UJdMzwntpMsuOiV1RJJLCYVnc?=
 =?us-ascii?Q?N5FkDLPhXp/wN6t2gaisMitHa2Z0FzQLQ9Ma1hjfjXXi6yWvg5mTVEzBJ5Q+?=
 =?us-ascii?Q?JW6I9w6MOAwVnXPsQxsWM81cW8X99KhoEBHj5AdNTJVJ4/fVnFujm8wW9iwf?=
 =?us-ascii?Q?KBeJtvg6KkRCPEHWjwufxUEx6zck6nZ8W6zR+VRO4WWlwZTCB0LrOLNgNdKw?=
 =?us-ascii?Q?SXAr/w53XpWoACRP/nVhOB1g7UwrZku7tGMSxubgwXoObFtvjBTccyt5Cqah?=
 =?us-ascii?Q?LnAFzP/lDx6rNiq52+gcyGah7tHFHktxGJDPaxJgZQEBV3ZNaloH+E5gIbKk?=
 =?us-ascii?Q?PgzHdi6y8FV+6Agn4lQAVdWbR1F8aI/1H+mC2/IBaN5pZ8a/405NXw7CRq1Q?=
 =?us-ascii?Q?t5fX80fCdSENcBlHJG7KdBYgg4WHhrY8Zl6xuf3kwljhunEc/HGNdZC7oEyx?=
 =?us-ascii?Q?GSAW2zIcADIQL7XZS2tFvsckvUmzVYrwJKN2RrEVbaiFq3yhpw7JGiPAAwyh?=
 =?us-ascii?Q?x4L3bfScXe4UupWDaLC9gmCA7H/0bMkfd8VKRxihoU1tX+SA9RJcZmN5ndpx?=
 =?us-ascii?Q?AHNp1iiRjv0hNgYbXlVg1/2VXtWETL8n436bf8nJnQhU1XpCjLbc3B+M3WZ5?=
 =?us-ascii?Q?2SI9FErR9L1WFy0ua3ivei7WD/FO0JPohlI96957ZRI6Jkf6HHxa0z9JG+dE?=
 =?us-ascii?Q?XJlW590I4N8LWuCN6KptvOXs4sfO09KCLfrfT3jYB8E5ow9C/Ev8830vglE6?=
 =?us-ascii?Q?xzLAdYk56mf74h/3XN7GNVWtVIw2kPgvXClrERSG+4kPQw5WWpl02GzN8HAE?=
 =?us-ascii?Q?7wyYYP65RuQDwaJpuH+IOYHcAcKBiiTkXnrul8TfwsuEUos91rDc3gSDXY7Z?=
 =?us-ascii?Q?pQtgJiHuNlRTvwBf9/7KFMHOjP5rzTr+YaKjfUdO9LZ75UjbMsIpEk37M9QH?=
 =?us-ascii?Q?J/d0EhkP6fKhEunK52qvv9SDl4I2dp/Q2x3IFla/MxCtHup2r2llt51roK5T?=
 =?us-ascii?Q?Fc7wFvdBObBsiYG6H70GAL5aPAdb9ImUcwXdyRLSNGmD4S6SfTv9+9jMzGdK?=
 =?us-ascii?Q?jYyXhQWEIhYmuej1lzfh7JkufrwjTBAs3ITJ31pwzmNqE3FnwouHNU4k4KWC?=
 =?us-ascii?Q?oneXIg1PbhVYp3oIsYIdxwkkdvptQgTZ1nhUvYBFU9W42fTsVQPPjxgr/9Y8?=
 =?us-ascii?Q?Zlj17dfqZIaHedqXgf/JjAxH8KcOeT296RLe5VbJP2/T7iis2jdmV1xzjpX+?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BbsSovxxzRS+RIlPi4K4OSgae+NMfAHr4XU198GgKThCMcE4jut0XSy3cEb641eNY6O2LK5YU7KAGhNM91u3dBxPKo1jXn9SFb5DKd9GMUuqqDBBELdrevKNLcIOM2tGc80UPk46aQoDsgpvBH2gJQJsWyWyn7CTqGwMxEG36HX5XfH9ef2argCi3rMBs+DfiokQxCJECfArmvxZXDfMIFizaZJeJc42IdMn97XYVNu3wxcWG84bDbv/diD1qd8MoJlPzb2fGxspK22BYaPIVECsPGYb41AiBtOZoVfN6uO2EiKd4CNzUPLBuEER1dH4nfNTZ1F+J93peq8omqDf5qauIXxGv7uHOIFrav4pfYKkGnpcDSv59fS8paY0sQNzh2EkAHINjBA2stluMlBEeQHsQkiyADoFTTyk7nPz2Ie+rQdRgACLFPniIkvuK0rXhm+9RLq9MeoBhhIARSXztjF4Exy4zxEee7Tg5iypKXuz83CSR3psScCmRgLjysUYPnB+1KAacbGcVBnVDG+W4PZr5WWEeKzbxCUSlVudRELDN1/OgNfjWMowX6Dj6XgJbn6hCewzEvzgB2oxy6BNyYWNP5+3qjo2eXenCOJm+fQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ca48fe-efaa-4657-0f2f-08ddea9fb648
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 04:09:44.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmT6FqNf0tJrhYWZS1dlewDwLGGzkG0oaHkffezKkK+o/dNzgFYF3wqWskfH5tZXe4mhlNVbs+Ndwde5FS154crt5dzPGpUi6cS5WsB0v4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509030037
X-Proofpoint-ORIG-GUID: b573AatvO4EuNsTiel2WjFBoqvaQyxaZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX3RO3rtewJbFr
 QaNKpDkHHmUOMdFgFFuYCUvsIokX6h9SOBthlpkeZ9QNrC4/XVWsCq5pIYMw+xKTu5eGZd6oWDM
 Sm/hyW3PgylabOP44fu9TB/B6lPTWdJYFReI1PNmdPXmnFT5MFyGu3db76kTPQKHhoOZn//KumL
 HGLZdXo4TdtEAT30JwnRKAEa3TtVHSMQCyVpZ5jpxy/pC9ORjJozYkytvAPE3glim31hTpfjkVG
 incjYitzU5Z6ZUi1JDSKpgKdRof5j9u4eBBV0MoLOwJZjUGaBejiZ+kgkteLEOrk1XroS31Yp0X
 ZsAa8Ptw09iipzo9qS1rRSRa5KGD4G0yYpfQiBYcCN5LwLPtelb78vY+Y9WjoPC3E1rgkvZxrsY
 8B1NvTQd
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b7bf8b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=4YNN0DohnKyBRUrxpcUA:9
X-Proofpoint-GUID: b573AatvO4EuNsTiel2WjFBoqvaQyxaZ
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56F3F1C0010
X-Stat-Signature: oyjz69t73i64gq5kc7fjqkt6xanj7s7k
X-HE-Tag: 1756872604-169932
X-HE-Meta: U2FsdGVkX18sRdBYFI0A04Kk38xzh5FVdQkul/zbE5csluE8ldY/snutpWHmyJaFoMQcqBgxKKOS3NBvILKnm29/N47w2G7IPTTDksCUZrhaG6UpBnkuZQquzo4dtJGCplwkhtrMbg6YwEa6yKmk8Me1cjGjdDIeXQrVjDmBODUEEwIjrCeNlqCiXtk7aUzlS4i7gzz/KMecT+oTFclzSraXsOsLHPV+a2gG31akuJymZ7gA8OKneLBsA/+tOAxi7RFBwQ819TnhHTI7/CCk7917QDOh2aDQYPj6km5x8u7n2SWTxlud3elYYETum67UubIwX41F5bmiGBykvCjWO70qUU1oUEyOm02VjElmW6VuB1s2586qwnEfwk1/74qc9rRV7Ap8MZpq9BZGSEyGA6Vr70L4WhPd4rQnJdVE2RNOVua87zZknZfC7smNUAZ5ldqEZEAV0CnlSymqQwYwrb4HdmC18f2d00S/jQQzQlXtgeERggi6pettv5gQQD3VEofsTdo9U/2+PblqnYa4fOlK3R85epffbP6EPQK1zi8h9yThIXcmH/LgYzX1vyFtAlp0yiVOgZ9BMoC4d1J0woCPdomREDryQJdHlre6n7Ut83iLK2s0jQSiX4DebJDPc7Vfjm6ZchVhXJLLSxkG0eWfRESvoE5AWnYttSZB5klC/8hQd89k/thF9olcc8BDj08nDsC08aF5g2oTRVeK7hXFlkYvA+E+JzM/38GfAOr6LufABPtmrpuLwN3sp87hFM0YTqpdDpjzozU9//zGad+kdj0odE3SlqrZWPKWj7qYDbDHMcQVQPgp/ZNNtu0DDG67J4xXAcyFq9rZYjtiiFO9ZcIgcrES6stHqiEHaY5VjyQlj4zHh0aY6tURQPSVx71cQIEAqolFli6j5UiPx/G0Crnvt/7hck9CvEdM3JpTLcRHfNlgLyPyNbOAN3q8RPAgXRGwnXaGBM5Akz0
 nqmu3XOL
 qbsRr6kwacbsmLilXZVeLOTy4B5imYDDQ3IGLhiOcWFMe7vn4l25liFtEcrN4kEo2JWBQS2JyqO7hwyHCTvS7CnD0Tse9DprKqoE3wqsyqSczllh6FBRnRnDD964AG9WMLPiUyma/sgJpIaHuXxHXp9cR1qYTEZz8QBXTBwiAuAukRacZ48+izwBAaKgUuhJmnYXBmP0Jbqspxddi1/8BWW5pRoirDqd9oS0e/B/4bxXUgoBOLvq0Qc8oeJ8BzsDOjpYkvolOwnvzhoLz+rXIA4hOp+BtYH/AcBsJtwyX8iMzH9URwVCK4iue5ECqk7IpC3hSGn6mjIMrAXEGD4owIJwCZcO+nKowj3b+lKhBFBbHnEqj9c5s1ub6AyViZm8vsWCxDbtetjtkKL1UCIeVOi5DO0V1ipl9Pu/07rkucSWW6nffYJ16SahOFgMwFOx99eFMH+6g6mDMAJ4PNqiM5awBDUnm9o1N9tNtJtyTzZZN+0R/eeTqCscUMtNhJrZFKMCKc+L7wpgCiYe0r3iZ7R9fiWOnqYjfF+Ryubz3MLPjc4oaESr4y6fygCQXE1hW3/CcDZ/UZ5NZLIta/Wcp/NgkzHfbZt2LFa9DwveHdYuUue9XyTAIN9rw7siXYbspWNFPsJEfZYdCfW2iqmykWBt8XTE1zvIJdiIYrxc1WHBJpk4F7eGtP6DvWi3couBPNd1DFbrRkOfib1gduc6ufGvoAbFN/qCAGSKXzA1jQa58nVu/R8zDWASi/QMh1Kl7NaxE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand <david@redhat.com> writes:

> On 02.09.25 10:08, Ankur Arora wrote:
>
> subject is wrong.

Ugh. Side effect of dropping clear_highpages etc at the last minute.

> Maybe call it
>
> mm/highmem: introduce clear_user_highpages()

Will change.

>
>> Define clear_user_highpages() which clears sequentially using the
>> single page variant.
>> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
>> primitive clear_user_pages().
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   include/linux/highmem.h | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index 6234f316468c..eeb0b7bc0a22 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -207,6 +207,18 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>>   }
>>   #endif
>>   +#ifndef clear_user_highpages
>> +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>> +					unsigned int npages)
>> +{
>> +	if (!IS_ENABLED(CONFIG_HIGHMEM))
>> +		clear_user_pages(page_address(page), vaddr, page, npages);
>> +	else
>> +		for (int i = 0; i < npages; i++)
>> +			clear_user_highpage(page+i, vaddr + i * PAGE_SIZE);
>
> Maybe
>
> if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> 	clear_user_pages(page_address(page), vaddr, page, npages);
> 	return;
> }
>
> ...
>
> And maybe then the do while() pattern I suggested for the other variants.

Sounds good.

--
ankur

