Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07658E81A3C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2400C6B0088; Mon, 16 Feb 2026 11:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E73C6B0089; Mon, 16 Feb 2026 11:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091BC6B008A; Mon, 16 Feb 2026 11:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E60056B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:09:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 903DABD666
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:09:07 +0000 (UTC)
X-FDA: 84450803934.04.A36739F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 002A58000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:09:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gPce5zX9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HAYshX7l;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771258144; a=rsa-sha256;
	cv=pass;
	b=MlXMnF6NZlV/izdp2oE4XRv9uOJBBaJYvNZ5d8T5VaRUX/B3LDqiKMLjXp4s3IV5igvRtP
	7v/V+uGfzcZYhqxFbgLSRGOnTqv6m2n0nSvE0qp8VgWUrn+4D5d+Ag4I3EC6V5PSoIjCnP
	KJwIkt1RV/oP9sj1V0in2FYRHLOWssI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gPce5zX9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HAYshX7l;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771258144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3eYAELFCqPQxm8tIwAit8NUlNDwL0QXCRftnF6NM0tI=;
	b=OiPY/f3bYPd8WHLcvzgL7gNosPtqHMVjfmVpj8inuiphWoPY6Q4xCEeGxlToKbNurlqDX5
	RVRqs4llNh6RZWpUdn6XxwhwtQPYlgipaCfOTGhZBltvqsmSbWbPZZADeeo0fVhKgplsvH
	t8ivJUbU6WYa28M3BjG/xEWCQPvmfF4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GFOqrm1343805;
	Mon, 16 Feb 2026 16:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3eYAELFCqPQxm8tIwA
	it8NUlNDwL0QXCRftnF6NM0tI=; b=gPce5zX93/piXIOfA8YH0f7oSLKf4mO4Nz
	oYyWWULGQrH4DN0WT5bAZKlfUlqSP27Gbc8WS8xEtlpoHqXnlAGkhGqcwt17NbQf
	omJpqs+E+amcD+Isp3cY42X8FnT+BbFyMf3/qwjvmWMPlJlHC3Pwxn+7Ux0b3bbG
	4UgGfEVD4Kd2sCpF0O+CAtc3LwDxpFyWMnxoC3+R5vytReE9bJvxaxuK0txkXIlJ
	IpOdT+QPicgKsvV+tZAyxq3RoniMP3s8sVuzmgi9Rz4jH6BE72VxN/P0FEsG2StR
	HAf7kMbX/B/WykL4N0o95g/ZcmhrnUp2lvkjyHY2oUI7PCNLvsHw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj5r2a2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 16:08:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GDr4lE035556;
	Mon, 16 Feb 2026 16:08:55 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cafg8hc24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 16:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNKZP1kG34lCtesttvmRWBN5S36QAQbiiPMvXpZnM66inWmTIw9c+q48ONJB3dSCZ9ruYMckTyYraYqTI9QXyyMX4p0nm6yHKimFJZrvWp5omm74vTQop/vnG+0StoyhrxPr6MCZ3i63+hYHAQ9TNHoov8nwt+p94i8Rg0bQdoFlOU3AL+AWsW9qVnIndurBoGLQYSUqOIZmiuHlpayuWH6klPobqOAVoBd1TPjEdWR8KKKzZKyiPq86MZ5LXqcIQzOhzTyiANKQ+AfOgVcZ8cxjzRccHPq8nCH8qRA9C4HXas8OkgZZhHKiDbBmFzMx+kF0LImVxE+BWaUWNTyWvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eYAELFCqPQxm8tIwAit8NUlNDwL0QXCRftnF6NM0tI=;
 b=L0lbu9nF89rMzPRkR0NjS4cX/CUoz4t759WMfWzlt6xFigFey2PxiyVZlmFE0D9wL4LmTH2D1kNwahGyMV0St5VXWQxCiMEbLvpS1af7sNlByNiOh2X14eWQfS7ADu5Iqy+uR0ZttRyasEQ80+jGN3Ky82qi9KuquR3h+QB8QOIImLaIgWCaRuqZIZPEPGX8THXWcvxOg9bS5d/kWpb1Zr/Qda515wA6po1i/RnErjzCWLXpZY4K2EdgIeg+9nQG9TVPJG5t10kDfTlC8mMUyXMLYl+WSHNQfJsN7K61XtPRJz3tRWTHJGe3UbMLVMudDs0Kxb9LgA0pmtAsrJcg3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eYAELFCqPQxm8tIwAit8NUlNDwL0QXCRftnF6NM0tI=;
 b=HAYshX7lARyMQ+wlzxkmh3sui2MeuNozUeABDV5S7xSr9zhKlh+dFDJBKEipFJx0Ae24ApQOlrZV53j9cx3DMQ/1O4FHu5zcoH9o9jdxqrj5WmzrUkzfIObql4VZ4YGL9ujwYgQnR5jp36VXs4rXW2TVWqYj1PO663IiP9NnWJ0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7916.namprd10.prod.outlook.com (2603:10b6:408:218::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 16:08:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 16 Feb 2026
 16:08:51 +0000
Date: Mon, 16 Feb 2026 16:08:49 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: syzbot <syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com,
        ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com, ziy@nvidia.com,
        Thomas Gleixner <tglx@kernel.org>
Subject: Re: [syzbot] [mm?] kernel BUG in __khugepaged_enter
Message-ID: <edc16404-2a70-41ae-9041-ca3c6b82749e@lucifer.local>
References: <6990a57d.050a0220.2757fb.0028.GAE@google.com>
 <5e95c945-dbd4-4714-afb0-9546b08ff561@kernel.org>
 <aaf78721-0bb0-40d5-9fdc-595942c66fd0@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaf78721-0bb0-40d5-9fdc-595942c66fd0@lucifer.local>
X-ClientProxiedBy: CPBP307CA0012.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380:1::7)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a4039be-6ec3-415c-6cf2-08de6d75ace2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M8Vm3Jtn5AC9aCvkYzLMh12kYGfHrsn07vO6jek/+HKFwnh140uXIe4KlIpH?=
 =?us-ascii?Q?ExCNL3fd+41/oDC4bOVwNt1aNrWSn5nzg43sIzYEL+WBTFi8k95y/tWJqFHn?=
 =?us-ascii?Q?rYvatibWwRfW4sD7UnAPzRXmQJpCIc8XiCwoSuKVOFM29AomhEBrBN5inwED?=
 =?us-ascii?Q?oX4F9xQoJ/e0Aklsno/jPd91hBFTHMJEBOCWP2sqj5RRTrbhN8mxMyqhjQ4f?=
 =?us-ascii?Q?0xZmMykL+c99nvLyXGCfN4EDvG1/DQ0QozJ1DC5tUapGuyz2TRwiog4aLalS?=
 =?us-ascii?Q?7+1cEeCwb2cxtUXF3VnWhCMW8oqrsExVs92q7fCULngj2lbfsDCzL5YEEffq?=
 =?us-ascii?Q?1gogrxhE8ly8WVd7ckvoQbTpbM+q9beaczhf9OtUh2NzbuW/D0EepQXkDf8V?=
 =?us-ascii?Q?24c9FiRCkl7w2Dsexu9AaBJp57BjTvdlwcdDn13lLgNh2Yu0eHv7kQi/1isX?=
 =?us-ascii?Q?rn9hdT2NrR1WYrjgvceqJf7BamBll+JYwRT7GwBmjXOi2jb0jcLzC1VHdYT0?=
 =?us-ascii?Q?yVrENtQ7wVmjegiXDWBbAdICGdHrywANRvE928xzFtH8lUAqMVf82VK9pBEC?=
 =?us-ascii?Q?6ugZOtAfmHWojPtGJKk7Xj91+WSzrmf1kImt/23lCQQjeCrLwMaKVH41ynMI?=
 =?us-ascii?Q?NbSm6ifDhkV9aieFE3JHtDqCIIUS9grJTKjwLPHWuG8rMGc6wuVlDOfb1HWI?=
 =?us-ascii?Q?RmcuelWBTm90e9JUNfKOXA++bkXJdfGFhJwga3YRp1dHHr78lcNPJaFnjXUf?=
 =?us-ascii?Q?ayfh2+e+2Qzy5/W81VwXCWw/kd6rf/Pn1OXaKx53TxRUXfXKs89FyhnWcphP?=
 =?us-ascii?Q?QXT4ZAE9h4pW3uTK+CMnmE2WGMIhKn9vUk7MN8U1aGeHT34sycIN+X26JLVT?=
 =?us-ascii?Q?Z6yMkXWdmGWQLI4A5nQf7aYe3nftyA5PibiJYL5JdFcREzPk25fmBmzmJOyS?=
 =?us-ascii?Q?5khnFaEdlGTv4JWHPx8rC2vfq8ERDbjlplrBm2G7+kJv74evuRp3FxLLUMYg?=
 =?us-ascii?Q?cFJo/k5HCqzmWyuUO3Tl6SnccDLGPKvv73CNasQgKuGP7TEvNXTpOiJP083Q?=
 =?us-ascii?Q?W8jeRjktL0BcQ2ga0eddhEP32RkZTLfHRqjyYZoYd/KkLat3K1RfQsAQowUI?=
 =?us-ascii?Q?7J1yx0manbfD51F7ywGlsUcm0OeG9WPNONN0+KtkVgwlEkGw3IWeh/2XbmjS?=
 =?us-ascii?Q?UjwF4P2Hf2XGF+D4CT0rVEKMtbu8bQCE0LpmSk9e86RdeJruw5TGBgLstPol?=
 =?us-ascii?Q?Grq3ae7EQ6ynJYPtmoUJK6TvteGMQPl/FvKdqp6xyEOpoFpR4ZkcXmAiNgWW?=
 =?us-ascii?Q?eM1ZIz2J+4nVnEJyZm0WmYVpn2XLSk1kza2edKgA1LtGGmyALz0BepgO/E1o?=
 =?us-ascii?Q?cHoXK/f0CCLcu+L8uDtO/fcSqk9ufTIFTUqX3y+8s2mEkyDCSPQuip2J4OSM?=
 =?us-ascii?Q?/RmRd6aKcUo+pAxjXxfgsrofbHhE4w2f4M0/C0M00lsf8KJDJ2Dv20m9ouqS?=
 =?us-ascii?Q?kh/hTr+2bhXUDde463Ee0p+SLpc/ydcUG0kz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?acIU8kpbhfDz74QRt8kuRU6DOfJrzuU7NWrOQELHpwFdrnrQg/V1hpNDZ7j1?=
 =?us-ascii?Q?aYcFxqxpgjGNcQ9ECEsFlpypd8C5NHzcDp0LYj2lvBMtVFLD2gSyF80+En0e?=
 =?us-ascii?Q?TwvHmzHjFEyxldsAJCLBHHQ9FOjZ3TgUSS5aumEdN/uXe4vpOCZH1LB2evU/?=
 =?us-ascii?Q?NGbPYsVeu94pEB1T/FB+7gp4h8IHE9PKZQq9PuZyiPc+SBKtjdGHUDAt9KCE?=
 =?us-ascii?Q?u+mEXZ1sI1Cr3V6eyxOFbuyuEbzct9auZDIcW9EQYLxjmZA4ZqCHvMGDGhao?=
 =?us-ascii?Q?DE4nO4Wze2kmw+gWGrRpqTKKr1bbS0oaD3bUHGA8Af9jjLgfdBb5F1eAaW0/?=
 =?us-ascii?Q?tJR0pbFQXOWvOFZuiDQZGbxhtgg1Xd1Qy+4vbxmezEawEJw/cWoatYl502s7?=
 =?us-ascii?Q?4Xxd/p5iko/vTVwXWlxTp5v6I1rR9gKinBBqhxf+noyJp6GXii7mw4JItfmB?=
 =?us-ascii?Q?b9ur1jAUCIuNG8dQBikOm1riTEuOn62eX4d5nFrjXfw+j67oM0zmlhYXqTxr?=
 =?us-ascii?Q?dgl9MG8dZIXjVuuhLdGJw0tIiO/zaDMoIyhjI9Us0AuskbCqipF5wLqHh/CA?=
 =?us-ascii?Q?BPUgF1F2s0DXFmLtBI8GH14dKtVYLxRULg04tV3Zkc60wOGv+bWMLwA0NVLl?=
 =?us-ascii?Q?zrW0ufCPGBCdndxwVOzlLYQqXPp3cw+z9k1P/mknwGwc34w2kSscDwbmrRHR?=
 =?us-ascii?Q?VtVt90gJCYh7sWUIPotMwjrvrfVUiEezjOI7Y1A7G3aRcHqRPpjZM3n8aXhC?=
 =?us-ascii?Q?XUAPKc2wCME0hcuyn94exUNNzXMZusxZQUmWujquKA9ZvCqk/vOtc3FiSmH3?=
 =?us-ascii?Q?w3yz8yZZdA8Aq97H2Gwndj0xDAfQk65YYNnmNcS+Ep5iDki374DJ9WhlV7PV?=
 =?us-ascii?Q?oS2YQUf9MTvFsug9Yel3co3owgCpzbJlnkRIQzv4qWIcNQz+kU+SSq4McOqD?=
 =?us-ascii?Q?hdOrkHCQd42fv0uXkeI3JOruF0EOX+X7eYqbFOGk9QwqqIxpSDlWdLSMCIP3?=
 =?us-ascii?Q?jUNyWNJuxHWupKkxb/WGIDKJuKYzo5WtF4A1qmiTgfQlhAOL8R2/QxwVX4Ty?=
 =?us-ascii?Q?xdNcElAqp4VXm99yzIMqm1FS1oKr2N2nkFFknSQKNKh3iu8+5ewEleEQqYcN?=
 =?us-ascii?Q?y+0jJ2OoeNZl20zd1+amK53VzPFAgDAY05IbpLLPhJkgkygcdFv8yy5lJi8G?=
 =?us-ascii?Q?SIqcSWLmKudbeQZuLJLUkaZRobqdW032muZ0mvAMpNOU0uCDoRG62O57Y+Iz?=
 =?us-ascii?Q?gUbk6JjECb36OkVnrkB3T70lKJwnFlJPCfimvUTuXPn7Iw5Zb8B4NYhq2VRx?=
 =?us-ascii?Q?8wsWiAqp6+MO+QQOcFeCa8ilS8nJPiBl8lku7dR0CjidQvgMOTWydZEBD6Up?=
 =?us-ascii?Q?pjDuprRR//3JWn58CSQvagTTYkKe6sZgjUgl7WaCml+/VvHDWM5BfHUnEN5X?=
 =?us-ascii?Q?gnmbILhLsxjH1wFNi7FvB5wb9fBBwLq1VJdDsk38i/0ki5EbQpcL6O3hjnVm?=
 =?us-ascii?Q?tAula2F45sxGxcUzwcxxytfB/N0PRmcowauZ5x0ZnxevBQ4BKhYBALxByrBW?=
 =?us-ascii?Q?iIEgGazG0AtEwuVewWuDHIMSn3kMZUKVQaVjgN613BhSRC8fE/WfSf+vHCLU?=
 =?us-ascii?Q?C67XeBJmPELUQ7tmrJok+gmVUAaDkZZ/+GuUBrDoJBBlR9hvXhdttAzBD5IS?=
 =?us-ascii?Q?MNeNPGfa0ek+UzxKRCeaOGeLj9jAEnTh364Gs5si3RZvM5s5/h3cuSSx/i9d?=
 =?us-ascii?Q?++6TPvn9wuGC67k4Op1y5hv7DlRoDK4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qBcjZv2idVYkSHifB4cLBHJwm2jmmdIF1pO709fpw77jLbvsiBrn5IEHZxyYaEwH79SXOgJTYjIZW6NASCZUJrvA9No/Ej+ua9/opQj7e+/E+SCokItxVNay96AYfXgbSziy5y+FwToVGHXjohfQuwFmjq5AyVUAZ65u3WFe3FhVO9ybghfdVhf61f1uYy/Fyy4JdxnT7cjrXmLuQTTnhDbOGBd0dyQ2Q4zGbEKFVOHF7gBmg7bCvcRGquz2a9oxXZUT5YSm68TMXjGFWKxcm7nd2y3tZtcSRbsZKwidw86UP5sc7LLH7y18KXmczzmbWIZGszHzVTureeH6++LyjGl99yrIQauQYJuFWgV1AInCpOZO0MyW4heIPiDbLfUPlmJJy2E6r5SwSagkwTegypQEWsj3hA3BaJOQGX8+0or2DOrOVsCX0EVaXzL5x03tJ/QlDCR5EYm33WjZBFUkwULL9LukJC8FnvKjVil9cgSqk/pXLO4ymVQ4AzYULhm9ZtFlJefu5msiXxcVRc0KVsg+gAElhwhOdOf8jwfBbdlQwOItkFyWEhvKKIr0FV+p7p2bVTvYDWQakxB6e/b0yOwjJ+v8sPgExBLoI4yDvbA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4039be-6ec3-415c-6cf2-08de6d75ace2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 16:08:51.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4mjOa7PW/VqMYaFKEtajK3KNYr4mNUg+L03mdAlatZ9qqn8AW1u52eBCx5aucHLZtFoZGEZ7wz/pyRvtUeo9Nnh8h1M2pLXKKOzWDFnSXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_05,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602160138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEzOCBTYWx0ZWRfX0If8r6ukAYrc
 G5GbpBYOab1o2xSbHnm1iHc4iSc3kEz4IS+T98/lz4C+ilTQuP1/tkE7s4Uc2WFd+7aNIgZxunQ
 FUZ89h/rV1msUlcl/d6uZWBlPk7/z4XJ1F0dXQ2hVuaB867AvG5SRxFLhkmhClr0jAisdbrhWu4
 JdsgyOyCmmuydRPlzVK+EBuznHCSP6mW+mSis4Y6RWHnrw1qES0/bgrsmXH/AeHldD+7d/KT0S8
 jM1iuLWb/cPunhmgWQuCojkF+A6wc+JhIHAW4MZ1Kiz7JMKUATXJqh2AaG2yKwtCAXN+Wgo7YPO
 nci/HA3VvGe+QEdNkveecDae/MFnS1m3MzBbT6NCq7Uyk2IR8/4abZSLtszwfRfsbsdPYa5JvtS
 oTSzryD3xbvNDtzrOX5JkqsH5EsZMY7QUe9tobjJIJZVx+5dTy2YKk8Q7RnYlhvialy8ZpQC7PU
 /tiyIBIHsKXpIAG06xA==
X-Authority-Analysis: v=2.4 cv=Saz6t/Ru c=1 sm=1 tr=0 ts=69934117 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=hSkVLCK3AAAA:8 a=hezYwQFQ_Z8LXQ4lowcA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: 3Rh4dc-RbFEmOZdxh51rxrQpoQw0mZ5U
X-Proofpoint-ORIG-GUID: 3Rh4dc-RbFEmOZdxh51rxrQpoQw0mZ5U
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 002A58000D
X-Stat-Signature: q9jfqbmccecq45uqduh5dyquf1s1yh91
X-HE-Tag: 1771258143-589371
X-HE-Meta: U2FsdGVkX1/j/vCLo921mwPBST7fo3ffFIb/hrmXyuYjZ8KvYiUJtLnltqgMVqEd0k9+EtvCQXZGALDWcz7shLPqZKPLmNoRdWePAraRGzysbPn8ThmFE7VPtKn9gDMQ4cWq3CFl0GnzbcuomwVKSRUpQ1xDxFDUC6uOMALZqLTRXWbLDkNW5dOQ9FJroPvmsNNa2jD88ZgpRcRtqPwxp9WgvCOgqqx7VQNTU1RDbSK9qoLuepnqFNnCaOUS9Wwltr7VJEGIt0GsrWX+hQDFXzl1jLA7RXXeW1c76jjLeH1Fn//RJ3ADop+OVqhWyW6gy73x8LIGzxHcaN5dsnHVW9qBo4MVEWbxeXeAv5A6u/fubyU4kFcBrIS66Ar1N7pmFwOD+6a7ZX/RVDn8ls9gXXV1CAh6r4hOxLWujWkJ8vuvRIa4pTuLvJIareNaZ86ez5+MkYMn897I3Eqdr8MiY8vLx9KXoqPT3cHjEQX6dm08qz3Drc9D69CrJ+36qhDtcsqh3/nxylTi7FCqmhlaGBx4VMJNSl8lKRMvLZAkpqroleyDMQcP8fCYG+7nQhsqDEG0l8GLAJpEnIVggWkabV/zFxjVNCY7an3mTqU1RV6eMe9AOlugCyZMzxWR95kO/c/tAfFmEw50KVHBV6R1NvEDxqSRvVMWonKf2pzuJw/Yk5dZU8ppEmIsbP2VIn8TLoY+J92E+kw8fNLb0HXvF3IDN2mK3uD+Fmap/jtTz6ZdNyu9ck1tVC+Dakiowk7xadyiUnU71KKXuVRE+2ce5l7GNVamrpjV6fp77CbHb5me/XxQmL75JJel90sIhU1FdZyaVKNAP8KB/ZFyNbgELLn0X70DeAJvIaLgtZHNG31Flm8Hm0PlvIUzF7nVMBOxbqlxOezE5ZVZR63SxAARhnhVra2MJ7u9RsFiKpJ4PQaZfo1VyDdBmCmT5vc7zbupJBKlNWZlmF8emYOXr5S
 v04CLZrh
 Ec/W7Qvqdckzu4TxQl7bkFpl5PUCMFYGOqMzLA74R1sfhOEu/zpFGVzEUUDGjtSD7SEfj8jqvx7IbEOwur+NAWXSX0I2GyCicd1t/CF1hmQfBXsTjuHeb53Xvuwea0l0gf5P1OHp/ISWdFbjMcp8CyrBXN4v4g0vD90MlpmCNcozSMH4gRRHd5BdNmH0CripFDnvKMkh+aNqyW/HM1dutwzG53YaZBhPUJAWS7lGFAvwanpPhA6UtJx1XpSqmW3DhP2wyyNSQXljna+/93w1fHefb3gdbXBhw8Qx9NXKwPoqfIByRppaiZV3rjOUZ/dQgSvOFCZj4Pwwz7sPpQfgUkIL0jMy1h+PyBdkdENut01/WbjoFx8ICCe1lo8IJcDrsBJQXs+1dTvrJbb4o7vie9lSwUrvxRWz/COAmbqXSiJIXk3W3m8pviJkiZlOnobBFBw2fnhM2sBXIY8gHKNck1iIaCDGsYYywzC4VnXD8yQbc8IvJhiJ3xaA4x5cQs6Rpp1M/8Lg9+dxlaT7fmGFXEkGdiGGFJJhaUqcxYbxtfFgQDXLrCBW3z2htxN52ssvz9NUFcCRCGkCFtDssMsTRZPX93IuR89xNJJbNexfm0s2FiIi8AzJsKuwLAxesJUZe3PhT8TRI8YoLheVr046K+/mgltNrZaTtyMG0EGGy/yCiDLsIcT7cs/naxqCQxrMSbJwwwjREzyw6P+Ie/ydvn6Xq6DhfkBo+BlnUWhupz49UZP4I5yv7m6jwKkeGm8LOYbgqykW8McGM8K9fhH75it4rxspc+uFSqVkjKuCIWrmql9wUw2cK6IBnnkW1ubUS1bd9m/C6sXbqMM5G6xQz2O9enrPGyD7RJys+tVna5qAQJbrBFOTb7jj5DzLh7L23ggDY+TMs+Wec5glNM1ZtaHpojtvBNbTj6bDdZibCY0qUkHKHLyNIoXSrDRPMmlWmOMKlD8cy1YZwS/dcQLP4SRCb1hp5
 khYaAa0W
 DFS09kARSLzB2Elp1vxwFWvmA82lohjePYpbL9pyu8vx2qVcKYqiX7+qrDRqFB/V0UtzvK9ywTz87drz+5J81mnYE8Evjohzq5twrxYAP0LSpSF38hChLwS9viYWZ3cgGYHUHhUQmAvY1j56oxKdQxqSFpfRK/VOiprh6R3lITp7gcVeT53BWZHFmnKoOPceDlGI117WV5CVsF4xTeYxr74SHjLy0T7TlCWZGluWYLPc/bB3kG1V1T8xFHdT5PvPXz+tIBxt63NTvVq6r4zaWr8ZYL+edENUCFFrknYdJwTU7pqOFn5djw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Thomas in case the commit it's sat at is indicative, there does seem to be
some weirdness with MMF_MULTIPROCESS processes (i.e. CLONE_VM but !CLONE_THREAD)
resulting in possible memory corruption?

We kinda need a repro to be sure though I think...

On Mon, Feb 16, 2026 at 02:43:17PM +0000, Lorenzo Stoakes wrote:
> On Mon, Feb 16, 2026 at 03:40:21PM +0100, David Hildenbrand (Arm) wrote:
> > On 2/14/26 17:40, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    1e83ccd5921a sched/mmcid: Don't assume CID is CPU owned on..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1169dae6580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=54ae71b284dd0e13
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=6b554d491efbe066b701
> > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.

We're going to need one I fear :)

> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/ed43f42e3ea1/disk-1e83ccd5.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/d8af54a32588/vmlinux-1e83ccd5.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/34e6a8cc1037/bzImage-1e83ccd5.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > kernel BUG at mm/khugepaged.c:438!
> > > Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> > > CPU: 0 UID: 0 PID: 16472 Comm: syz.3.2372 Tainted: G     U  W    L XTNJ syzkaller #0 PREEMPT(full)
> > > Tainted: [U]=USER, [W]=WARN, [L]=SOFTLOCKUP, [X]=AUX, [T]=RANDSTRUCT, [N]=TEST, [J]=FWCTL
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> > > RIP: 0010:__khugepaged_enter+0x30a/0x380 mm/khugepaged.c:438
> > > Code: 64 7e 8e e8 a8 dc 66 ff e8 93 e6 8d ff 5b 5d 41 5c 41 5d 41 5e 41 5f e9 04 6c 04 09 e8 7f e6 8d ff 48 89 df e8 17 33 d9 ff 90 <0f> 0b 48 89 ef e8 dc 51 f8 ff e9 3b fd ff ff e8 f2 52 f8 ff e9 e1
> > > RSP: 0018:ffffc9000e98fba8 EFLAGS: 00010292
> > > RAX: 000000000000031f RBX: ffff888079b24980 RCX: 0000000000000000
> > > RDX: 000000000000031f RSI: ffffffff81e5b2c9 RDI: fffff52001d31f1c
> > > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > > R10: 0000000080000000 R11: 0000000000000001 R12: 0000000008100177
> > > R13: ffff88804adf9510 R14: 0000000000000000 R15: 0000000000000000
> > > FS:  00007f06093436c0(0000) GS:ffff8881245b1000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007fff341d3f52 CR3: 00000000319b0000 CR4: 00000000003526f0
> > > Call Trace:
> > >   <TASK>
> > >   khugepaged_enter_vma mm/khugepaged.c:467 [inline]
> > >   khugepaged_enter_vma+0x137/0x2c0 mm/khugepaged.c:461
> > >   do_huge_pmd_anonymous_page+0x1c8/0x1c00 mm/huge_memory.c:1469
> > >   create_huge_pmd mm/memory.c:6102 [inline]
> > >   __handle_mm_fault+0x1e96/0x2b50 mm/memory.c:6376
> > >   handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
> > >   do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334

	vma = lock_vma_under_rcu(mm, address);
	if (!vma)
		goto lock_mmap; <--- didn't jump there, so is a VMA lock.

	if (unlikely(access_error(error_code, vma))) {
		bad_area_access_error(regs, error_code, address, NULL, vma);
		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
		return;
	}
	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs); <-- here

> > >   handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> > >   exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> > >   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> >
> > This is the VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm), which checks
> >
> > 	atomic_read(&mm->mm_users) == 0;

Yeah, and that just shouldn't be possible, so maybe memory corruption?

The crash log indicates the system is tainted by softlock
https://syzkaller.appspot.com/text?tag=CrashLog&x=1169dae6580000 so something's
gone horribly wrong there...

(from crash log)
[  696.104336][T16472] pgd ffff8880319b0000 mm_users 0 mm_count 2 pgtables_bytes 155648 map_count 32

VMA's still there so exit_mmap() hasn't run yet...

But hmm we injected a fault :)

[  696.293779][T16475] FAULT_INJECTION: forcing a failure.
[  696.293779][T16475] name fail_page_alloc, interval 1, probability 0, space 0, times 0

[  696.332139][T16475]  dump_stack_lvl+0x100/0x190
[  696.332164][T16475]  should_fail_ex.cold+0x5/0xa
[  696.332178][T16475]  ? prepare_alloc_pages+0x16d/0x5f0
[  696.332200][T16475]  should_fail_alloc_page+0xeb/0x140
[  696.332219][T16475]  prepare_alloc_pages+0x1f0/0x5f0
[  696.332241][T16475]  __alloc_frozen_pages_noprof+0x193/0x2410
[  696.332258][T16475]  ? stack_trace_save+0x8e/0xc0
[  696.332277][T16475]  ? __pfx_stack_trace_save+0x10/0x10
[  696.332297][T16475]  ? stack_depot_save_flags+0x27/0x9d0
[  696.332315][T16475]  ? __lock_acquire+0x4a5/0x2630
[  696.332331][T16475]  ? kasan_save_stack+0x3f/0x50
[  696.332346][T16475]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
[  696.332360][T16475]  ? copy_time_ns+0xf6/0x800
[  696.332379][T16475]  ? unshare_nsproxy_namespaces+0xc3/0x1f0
[  696.332408][T16475]  ? __x64_sys_unshare+0x31/0x40
[  696.332423][T16475]  ? do_syscall_64+0x106/0xf80
[  696.332437][T16475]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  696.332460][T16475]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  696.332480][T16475]  ? policy_nodemask+0xed/0x4f0
[  696.332500][T16475]  alloc_pages_mpol+0x1fb/0x550
[  696.332519][T16475]  ? __pfx_alloc_pages_mpol+0x10/0x10
[  696.332542][T16475]  alloc_pages_noprof+0x131/0x390
[  696.332560][T16475]  copy_time_ns+0x11a/0x800

So:

static struct nsproxy *create_new_namespaces(u64 flags,
	struct task_struct *tsk, struct user_namespace *user_ns,
	struct fs_struct *new_fs)
{
	...
	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
				tsk->nsproxy->time_ns_for_children); <- -ENOMEM
	if (IS_ERR(new_nsp->time_ns_for_children)) {
		err = PTR_ERR(new_nsp->time_ns_for_children);
		goto out_time;
	}

	...

out_time:
	put_net(new_nsp->net_ns);
out_net:
	put_cgroup_ns(new_nsp->cgroup_ns);
out_cgroup:
	put_pid_ns(new_nsp->pid_ns_for_children);
out_pid:
	put_ipc_ns(new_nsp->ipc_ns);
out_ipc:
	put_uts_ns(new_nsp->uts_ns);
out_uts:
	put_mnt_ns(new_nsp->mnt_ns);
out_ns:
	kmem_cache_free(nsproxy_cachep, new_nsp);
	return ERR_PTR(err);
}

So we're putting the world... maybe some of this is buggy?

[  696.332578][T16475]  ? copy_cgroup_ns+0x71/0x970
[  696.332601][T16475]  create_new_namespaces+0x48a/0xac0

So:

int unshare_nsproxy_namespaces(unsigned long unshare_flags,
	struct nsproxy **new_nsp, struct cred *new_cred, struct fs_struct *new_fs)
{
	...
	*new_nsp = create_new_namespaces(unshare_flags, current, user_
					 new_fs ? new_fs : current->fs);
	if (IS_ERR(*new_nsp)) {
		err = PTR_ERR(*new_nsp);
		goto out;
	}
	...
out:
	return err;
}


[  696.332626][T16475]  unshare_nsproxy_namespaces+0xc3/0x1f0
[  696.332648][T16475]  ksys_unshare+0x455/0xab0

So:

int ksys_unshare(unsigned long unshare_flags)
{
	...
	err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
					 new_cred, new_fs);
	if (err)
		goto bad_unshare_cleanup_cred;
	...
bad_unshare_cleanup_cred:
	if (new_cred)
		put_cred(new_cred);
bad_unshare_cleanup_fd:
	if (new_fd)
		put_files_struct(new_fd);

bad_unshare_cleanup_fs:
	if (new_fs)
		free_fs_struct(new_fs);

bad_unshare_out:
	return err;
}

And again we're putting all the things... maybe something buggy here?

Perhaps this unshare is racing with something else?

OTOH, we _already_ had mm_users = 0 at this point (as per mm dump) so. Probably
something before got us into this state?

[  696.332664][T16475]  ? __pfx_ksys_unshare+0x10/0x10
[  696.332679][T16475]  ? xfd_validate_state+0x129/0x190
[  696.332702][T16475]  __x64_sys_unshare+0x31/0x40
[  696.332717][T16475]  do_syscall_64+0x106/0xf80
[  696.332730][T16475]  ? clear_bhb_loop+0x40/0x90
[  696.332747][T16475]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Also from mm dump:

flags: 00000000,840007fd

MMF_TOPDOWN | MMF_MULTIPROCESS | (core dump flags)

No MMF_VM_HUGEPAGE...

MMF_MULTIPROCESS marks this as shared between processes, as set in
copy_process() -> copy_oom_score_adj() which has a guard:

	/* Skip if spawning a thread or using vfork */
	if ((clone_flags & (CLONE_VM | CLONE_THREAD | CLONE_VFORK)) != CLONE_VM)
		return;

Which grabs the mm in __set_oom_adj() which as per commit 44a70adec910 ("mm,
oom_adj: make sure processes sharing mm have same view of oom_score_adj")
suggests processes were cloned with CLONE_VM but not CLONE_SIGHAND (which
presumably implies !CLONE_THREAD).

Anyway it's hard to know with a repro.

Cheers, Lorenzo

