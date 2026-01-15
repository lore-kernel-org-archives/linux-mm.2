Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DBFD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442406B00F5; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECEE6B00F7; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D5A6B00F6; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03B976B00F2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1E6CB9A49
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:42 +0000 (UTC)
X-FDA: 84335210484.28.49F6675
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F5E1100008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FKISqN4l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eVRsglHt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq+AFfx7DBNF3MyPuJbZmB/jDLJOmgdLrx5jnbBO/Go=;
	b=MlwaDERFkBvHqt08T4YYDV8uE+hzXDTlYRH9DXgESJWX8uz7Rvi+/LX0zeOiaTCk8KIGnf
	Gqwo7Bz01eYX+6SLlX5v+IfMbbHRqmzYYHWHdzuWs1DRR9mzoRug8g+b//lBQ4/MPNIJDX
	JeIp7Te0G45hdJJUiZFupRDl+MDtANQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505919; a=rsa-sha256;
	cv=pass;
	b=haHC6uYje2mNZORt4BKSNIlvolnSRJ2mluT+JrDbNhDO4S7wfQY7wn+kqWl/ViLMaFVNEF
	beqQ2Uj/x8MoUpxqwWACwZFS2jECqcaZYaEVsfd0nKgpn8vNz2JLHswm9Kal8aOHrTZ8lE
	9w8vdbu5G8woSg/qz6ihRB+MM4opbYA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FKISqN4l;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eVRsglHt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFSXnx2753320;
	Thu, 15 Jan 2026 19:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Yq+AFfx7DBNF3MyPuJbZmB/jDLJOmgdLrx5jnbBO/Go=; b=
	FKISqN4lAAbXnvGuwFx/qjKm0SHlqh+SaQlWlF+lpIOZOuRJ+lZVCvFvlYc0S1vt
	6PsvhoCkDHuuaTggksxqNGu4uj/o+FpbhIYRnegaAFqlqu0TKsyQRv9xn8r5d+nz
	ehgAYQW2md4qyScFj0NqVMqdXY16cuqNWW1pm0W7Jf0mhBAazagq9HS54JfxxcZA
	XkgeZpU/o0zVHgARYO6pINGFFRE3zYeQ5DXOqJhZVe4bMujbyh4Q7qUiDusXAgrF
	mwhNxAGIhGingJL+Gp0gvunOJ6W+HiVsSe9wanhCvaAr3cx62USRTchyoeLyIz/R
	7rMVe0CT1KH7MzZsEMYzrA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrgfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJbCBR040448;
	Thu, 15 Jan 2026 19:38:28 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgmdy-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrLzipRhYxb2XKg61Qgg5YtYd26TVGmRTPO87XMaEr+Dpi2lyKsi5D2kaPeCvPF0Ku/VU0U8Ysrdnf0gEYoHMzzrkAi4FZnPKZ6zC41KmJ7fpwR2DPVjHk8Ih5PNrUlssaQvqEFW6mI6gQDI9ep/w6MvzrCypxDEFYx0nnMchWRUStGUovLc2RFr9POFe/m9cVlti01B2+pN3OX0wvd9LKLkMEsfn6dPnj6NRAh+gdw4lnLFrejGI643GaXdSz6ZllmCPS3OSSXSzJUHj00Xc1bfzrlwwyvOrNr/wKLc6xPGVmFGaIR94ducr/SuVU//6Dy+3hC6dxnd9Oo1c1azWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yq+AFfx7DBNF3MyPuJbZmB/jDLJOmgdLrx5jnbBO/Go=;
 b=PRnpJ9Q8xfUr+pf+co99VMqm9oGdT/kUcR9PL63+JIknZopVlI3il3KDMIuC7mnSlES+ypvjcVHXS/gtK2iOi4QtdVEGWQ8IRkG5R5lK15+d9OJVvXKlk/cGpnXLD1smFhfrVQX6hg6kmxL54DznZlhaABzKOA4g7LeXQS1/OuorK6FpDfyxi1/tGPqHCLNp9Te7bWyYcD7gcTBlQrWqPsPcw3/u2pu7r2i56ScZ2RQpxUFvyek/miskFtrxVc1qRM3SXhCqwG1fY7Ly9TaCgflUufaIbC8ahqMvaEObaaXxpy94nUdDOq/5wKt9VHtGZO891j0J3TFy85xiPHoqVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yq+AFfx7DBNF3MyPuJbZmB/jDLJOmgdLrx5jnbBO/Go=;
 b=eVRsglHtYZOlX50H/LLRNaRY26LHecVYYK21GX5os36uWV3oj/YT6I5gyvopO8k7tL4mJLyrpCFP84MlPr8rGYGC8PyiAt5nq9tQGU4aitT3/x3zQKChEMr9jjuJh9rNrnEfu/XMN2yN7Ufyv8LaN1UIfvNDgtFWTlTyAf9BnwY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:37:59 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:59 +0000
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
Subject: [PATCH 27/28] maple_tree: Don't pass end to mas_wr_append()
Date: Thu, 15 Jan 2026 14:36:46 -0500
Message-ID: <20260115193647.1695937-28-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0188.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: a539cd4f-01d2-4842-2a2f-08de546d96e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rYL1Z5XFHmsc2BpO4ADz9a2+V54+r4CCRAc4+yuDVS9cG6dCBDoJzQ6zS5WJ?=
 =?us-ascii?Q?lYAN2lVlZUzxMV0elIqAazUcTsvmx1jcE3TLNkt1kI0ZRzf0D38J+7oOMbbz?=
 =?us-ascii?Q?5F0cM74ytox0UNnP3YX7EfK6FKIhELCfwiEe3dLFnajfj6FxpLArI27Zjf3q?=
 =?us-ascii?Q?clXY4on19Z+rXbzOzua0ifC/6JuLmyNRwh78iOqBQGFgEi+UWrps/MDYT9jK?=
 =?us-ascii?Q?ObIYtaZfxa0UKglpnPgPZ6wXIX8sXLjOZwS2s3T+VDN5ES2d7dW9mNYbIMTF?=
 =?us-ascii?Q?98BVYYlLEitgT6h0DhSgcQK5IOWcQURWiUDD6p0vkp6dZycGO3mLiIeF6sC3?=
 =?us-ascii?Q?/itxAvC1LxdAGvYlge9jk7z+iyOEtk0FEYqJAE5IfwHG601QCtOOKo10fgb/?=
 =?us-ascii?Q?eVz3mSr0MqLHRLV8HV9AEA6W+m4qSuuaRnq9XXStu7AD9Q1I05x/YcSWHLh9?=
 =?us-ascii?Q?Vv32qmgUW8xh0tbz2OO3eygvGsKNjikI0iZygOmiwBc512YVVSQhTAuKzPnQ?=
 =?us-ascii?Q?WrufYYSTsdZ56R5NUQkAqjg90stNb9k1Ad5hdKB3bRtTfJdZtCTbzzM/SfHr?=
 =?us-ascii?Q?/RsKQIwC7KJ4KBMGE1BPV5ZWnPbOmcoY01aekuEzbTgkyD85kIQtu1WQitgN?=
 =?us-ascii?Q?SCIn7U5QJ5kRMV3BydwCARTiqowRk792KYJ4dmhuEMAWJOJwyw1n/HP2nEWS?=
 =?us-ascii?Q?apAWKR0A1zkipoqBjwohmEfoeuRueGu56axc5cwGArQHnpEX5iaJxaAcqL5p?=
 =?us-ascii?Q?E10VoUJScpDS1HVIwo0hzVi878xQLHTpfIs7SIqFMZBnhvriaqZKf5FQQu0+?=
 =?us-ascii?Q?/osZqpPEHUb1eZ7d56UEsy4mtQxaG1Tkj+qy1R7Fs+E3usjNgS6vdaj00O+6?=
 =?us-ascii?Q?75fektQoUj0OySBBjN4QhU2SwCa912Vei1nXq3yKa0V4ix3BveiZMa0YbfPH?=
 =?us-ascii?Q?pCxAom0xeUidDWAAVO3CQduALFkE6WwG8iHobHXltv+X/5GLPEQGW2FVMx5T?=
 =?us-ascii?Q?cAgzxut/g0JQs/+xrr5SbMCqwfzFUsQkPLZHpeUegSkKatczcZ7I2AYx/jEh?=
 =?us-ascii?Q?45IT4zLoqmEJKNXM4bNpZYgIYQ9tduGeBSmF3OqHdCfOE+/Hzv4dG3nsm3WF?=
 =?us-ascii?Q?HFZnzfqyie/bmwozHfS+2Ihsq+xtqp0S8zP8XddbjhwmsOtX0nlBte2c+fqO?=
 =?us-ascii?Q?MMzRT+hVnbXHiA1TbFWtan/xHFnX9PD0Sw8jAylQniNc9YR1gJGtXeChpTxQ?=
 =?us-ascii?Q?R/gS7CG3r47reNQB46LSXdT7VfdtG7J83uPzTWZdwXxLFwF7TquLZdNIbYnZ?=
 =?us-ascii?Q?B+gAKUFlN1H0bFJjInx41s557sT+dICgGFLVnEH+2sB8BnNu+CZ/f3S4TiLi?=
 =?us-ascii?Q?mFFEiDOT46h0DX3/T7z/fy8oBgWkMV8EZdvThPpSrOp8Lf5KNsh+ozB8GNYE?=
 =?us-ascii?Q?x7UwUsW+a21us4UV/i8X/VqR2gsvJU1WXcZTKGtPg9HgTLfHudIfCMc6whSn?=
 =?us-ascii?Q?2CTwpH0mzvSTPNhw/DidHHXA4Fc0KVJBAUEmZvQE3MjRLTo/M/QDgighSSRP?=
 =?us-ascii?Q?g9sj3wdBnnBucKJBTz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4WvDQs4WLjEE2jsVnXtEbcW0T2H0lasNkSdT2O7s5t9Z8ob0cdtd8agVMQ8I?=
 =?us-ascii?Q?m/7htXh93hNneavsJLFlqR+Zm6hz/d2mQZbJDfPhH3a5T7lKcpPF+Saz7JzF?=
 =?us-ascii?Q?xYE5j9hlKGzlVrSZh5GFQdcymTuBfFcpoXlS6P5YH/WW8AaRRvUoJnXRvozi?=
 =?us-ascii?Q?CV38XxXh6uyPs6LVljG3ZeAKi5rL8jMvIHiAynp15NL16Eccu0pkkUEQIqqr?=
 =?us-ascii?Q?g8jQJ4CC2pgpViATJFdvqPpv/mfZ+oBe7FLBI8typ1LxDvq3v7b7CxMD7JWa?=
 =?us-ascii?Q?xXoO2SptGS0HsBkXttOu5X/2BdbK+4MJPWIA/oz5X3vQMYWbGH0/4KgO8UVn?=
 =?us-ascii?Q?4avt4GW6Ac7u70CgySgeIlvDwY1eF87x0RV/HAO6RA86eN5mnLEV3XUycSId?=
 =?us-ascii?Q?25KqNEaqttQZiO1RBidQ+ITw9FrVSR/RIx6tMgHSxoHnxEzjkOPXcPBy/r1g?=
 =?us-ascii?Q?iFSy+oIVtIxZmJ7NnpmhZg95W5l+3mihlFGSvA8z1fI+gnbEbkDEhW0MX/y7?=
 =?us-ascii?Q?ec0cucxfQ4NgTbEDU25TWT5KAKXWi4dN9AenuPk0lJBZiUg0v9y4S03SVzOp?=
 =?us-ascii?Q?VcGeNo1XCp6Nk4CltXODCMqgmlRws9uWRceNY42AQvB54qvZGkVbm/kF95dr?=
 =?us-ascii?Q?VQ8agK3Zl99K7zqzE86ofxo7JZimhE3bl5bPPRkPpfKgaVl8rIkfSBgCga9L?=
 =?us-ascii?Q?7n9dsvYAUNZzXTWAqFzxAgEpI8Hlv3OVL09SFGZrP3raTw6HFbL6mVtrL9u0?=
 =?us-ascii?Q?NqGxrQPFkHtP7HItl7CZXV+x0QN98gK/Lkck6KKktMGA9ra5ZdmTJI4JK49H?=
 =?us-ascii?Q?Q2nBhoHR5HTUN2ktRmZ2VRD8TZafSTl+qLvJd6rqzwP/LrlWvwDj6hBHr43B?=
 =?us-ascii?Q?TmuH0FGT9LuzHXxvdFHKwrkSXRMa0ffbZxQ3OtMufg1KTSWLEvalYTn9nDoz?=
 =?us-ascii?Q?4mMda3Y6RRNgWSnF+epu+YwD3YHHM/7e+gy1GHzMAQjS/dPz4vyLsmzlfnsx?=
 =?us-ascii?Q?pBmprayrOL/3CIte4NZDYGwNhQ29NzM7maMSWnVdCARuSiuhvrk/gRMypHei?=
 =?us-ascii?Q?cCHpU1/gW8+bNaQU/7U0DhH2NfUdM98P00Hjixk8XpQgev2lIeCepgepBJra?=
 =?us-ascii?Q?YwLw9/c2T4NVTeKfcnvlr3QDnwYAXu4qa+pxDyJD0rrVVUHNqmbc+QaK4nOy?=
 =?us-ascii?Q?GkcezqxmwvhF9DlNgtesc0cFYRMJMz8YPle7BOwKRJv+oYPuohkGW6Bx0pTG?=
 =?us-ascii?Q?1UBhqWIY3GbHwS3Vs5ZkBwvBcoVQNDKgRH1zzu+x2vlemzFUOO7SW0QpFNOA?=
 =?us-ascii?Q?AO/r4EC8/xRjGKyKGoJzMeTiW+PfmEF96y5CHc/HWjpaaDDj+huiVcQGAt9z?=
 =?us-ascii?Q?hchBueLvfvYK17M7hSwBac0MeUiRkLZqimTgy1eqaybnXDO4AAvc27Xnbtlg?=
 =?us-ascii?Q?YI8/REi/vweVEEhFHtd9hcN2IbRw/mddIke08PZU5sVeKA6YEGbntKXCh1bD?=
 =?us-ascii?Q?6F6d0iPM6laoZAl6g7jXvZbyOItv9+iJtsYBIfJu57WGkQ8WBAxgXZyn4xtF?=
 =?us-ascii?Q?0Ni5iZNl/mKke3yNFiHUV5gx6NM3BDqME9NA7MvJX0nD/MCq9QzUt3qSgTn9?=
 =?us-ascii?Q?uUfkzmQfLTH7LeT8Pfh967cJ9k57ao6NIZtcQgb+AQYerqpnZaWinDdbfF8v?=
 =?us-ascii?Q?VqGHlkHx0yLstQVxrIAhBOeJCOa6daEgUjmLnR8+XkQf3hkA9kb+S7+6qyOz?=
 =?us-ascii?Q?2j8sDrW08w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tsPOslrkUN6i6PgUBFx1bNn3isswd5sPQo1InIQE1A37fPpj3sv1dO1nL12rPG4Okiqq5Gi2GEVnlz1sTDZZ8FCa5QmlP3MA6aOGMXTktFeI53TQpkoKDq1KY3yUn9hOxezdew9ipyE80bSY5WykV2QkQiGGXSQzQjzCcieH1p+6mgQZouO9w3fpIQssfZ+5+s9TaofJqyfxGKkEri3Cse8IUU/VSWP6i55f0N7r3yBRhAtVhM5ylcykS0PSp/Cx5fz0WBNIKeBDCoZnoKnWig4t1Y4Ud2xmJB0BGISTit0qdbk5HRUE0GxBqXzo3KziK//17Gqs3goENt74VDdSzy+Jv3mgTDqzqkZs98tJDS4EtZvEaTpWd86hcWTZShiNc/tCqR+4KpkaIOjEtL3mBOeQfHpTaUX7v0tTzEPclIX1CbOPj5yszx1yOxGWt7VptKObfYJ7slOpNKRusDPJNLQFrNHf5BY/FZzlniPbP/yuNhJfHK495/r9shoLJFGTQ3q9/DUFawyLV6EvbZNhbEyVGO0FM4NsFLj3tnyfddUGD9qNP1FKC1oYVUi1iaEAVllgxHQIp5bIy1vE9KwhvN2HjPWnIcn82LwXX1R8X3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a539cd4f-01d2-4842-2a2f-08de546d96e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:59.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nf8x4Q3gbKKkJjIs9NEYoznSHAI2K+8q0c9ENn6/IbMzBsQygCrUicgabc4WEt63W9ZoM5sxKQtG/dL8YuTyjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150153
X-Proofpoint-GUID: VV3bA8skipKAI2O72jgJ3sxsxDn20inP
X-Proofpoint-ORIG-GUID: VV3bA8skipKAI2O72jgJ3sxsxDn20inP
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69694236 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=eQoyOrWFz78r1Bu3z2gA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX5bMZnPd+9OGy
 0rqJN4Zp/rvIitajBBFKzVdg3XDFn98PNl+ZUjBOgTQw0+3kGHXFqoC2uqmUgihjeggVpsBM3z+
 0Kf6fQRX/Uwvv0XQlNMXS3YvSgA8VYWgunSkiMEZVJxgx9Ye3ZTjd46iIMyGPBLO7JmL+0KoOfs
 p0Zdtkx1y8h+udOmLOVfUPBwFeUC3Edmawx28lPPhD+D0syO2vwn7ek2bFqf8OLvxsYvrqrzGzc
 QnI1MtFqaeuX4V2xPGZPK85Lt6UKLNLDF8KZk1d48MoLUduZnE0oI/PefcXEOuixmG18jjWC9k7
 NDStUEegbQrrHdowJjkkrnN6Ff2J25iPVIHmD/ZKxrhrOQySNf2iHzgbn5mvwSd0Zb5btW+iPf1
 F4znDREygRlrDVtxXYg38ERa9Gxqy5ULa4pEJ4qta3V8yDswPRam2+cksemPeYhdKfE34PCUB47
 H1Xt15zIwj7STX+mcwtCqmeLE5TvEIzJEnQVV+bs=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F5E1100008
X-Rspam-User: 
X-Stat-Signature: dkj6wefues7naqisqfjktequm3t9n75u
X-HE-Tag: 1768505919-981264
X-HE-Meta: U2FsdGVkX1+HRIyI/W6vXeD3PsxIOoB450W0mmTdrQiRvyDLnWp3Itj4Hgrs+wDCFLFbgroiPmTROLYgYwGUPoSKIIvwhJ22z0hjvSx0aKA/HUNy73F/KrmKfs7M3MgQ9rUXmlKtb8p8Q9Wy3UGy7u/0BsgifCLXQ09GTJ1dB4A3VqvEarBEV6gfO2eAJhzTrbSyOFC4NWq8dLHxNTZEsh7woFCp4oWsM8t7yolLEc+cL7eUtlC0vu23IosTgq8LSXOZJyV5JewLH7n8iRrHe0A4JgHmT27lJaCi/C6V2+N1rESc0MXRRZ2jPKiCO7tRd9YqGoNGnRwxhkeqhM7L25ebxQcN3rTxe/aKoElZgv6yFtEIzST7HyiT2zY1Niw0+7SXN9XvGpdG3Xo9VmeHj02q2Cx1y49aafIS9hJdCW3ZfhWq4ad3ppta5LM5d9ZvX4PyjbYMwLcUcMqVahzVap+NrOqitWvwdp5OGUAH2WklH0ZBXDJETlX5CJC5oLFBtGukqbgLPHJgI6olGETjv+qm/fqS03acKOQN09SGKgsL9iFAYAFRiXkyAf4eZaAzhljcumzKDUG0funB88hA2X0PJqqLzfteRcsABuxdtpmqR2ua5ZmtZnekbj6jw1tI0IXmB80K2lH8Uk+7XuVqfPX6xTap9Z6tj2l80gzVP69c8aK8bWu36L9b6/jxXaQ7V0dTaWEX8mVonGU0sTh5LzkvFJn+U7X3KatLVYMwk07b859USf5H8ISzEpK5bz+kwN4Mv7L1TnFz8HgbpEcH+eAxsYZQAgLs1FrdQbWTTUMlUnwT077NWz+fDRNzglDaXWph76hlwq6F398fLAcWsw+9MfRaULAaognxORJVbpSSbfsO9kdCQn1NY+A0FzJQHxe14jfNa3PxWHWxVM1ofuK55vJ0TlzGrMQdOP8JQxmi4ZIET+paciSEKHexPNFEe0V1EpvnWQ6xUnWBOuJ
 5bi6/C/c
 /4Ubqu1HXDpN5G6wirRW1EN4NQpiaSa3Izt97yHoOxVIWnt7FIgzVZeQpstVIuaZ5vS8Z6KXIvLjwTT2/FkrcZ9RS6XcumzdFD7uEa25chqrDceXkvkh0+S0pj+4wKwGPMjobpQmw+NC5ANBjqJF9rm3/XCtJBWcOGNMn0AKGFLN+iZCmN0lp2wTonE0qJrM2QK4T97zFjmJVW969+IGCIPk7I+RYfb/zgGCzgvpEs7o9wrfX68zhx5VVGkH9LY4lQfQZVBwBys7vG3AmuIqTB+O+cxu2fYM7q1/rG7ghy8W+ctyGX+wKVySNa8CBWwHA1MeDGonwKWINUskt71u8cK3bCTK/Fnd17D9Da4ZuVDD6KluS39DDrDo71PzVBOY/wcQDHx5WpDjBfg+ukXQrPva6DjQfIwbPFLy4nsPmPfNiZ2jy8DUWBfMdqVd3S9/9QXGchlc1OeM7RMelKbHR6L7xgSd5kwza0db5Gk/JCgIhAN+ZrIVW3tGGB2QcH9zuU60HZHUU9PL5VYXhrxbEpDJ1EDb5r4QBElVLCvyaUZ+cm2Pswff1jNFcMdFtIElg2if7He24eUZWso5dHg486GoIt1yg14UP/RVdUCvITjQ0l5LBjhylXu2ceDEVcJ6bYt++9af5CpdKNP3vugCvHutO5L1He+uHElAQ0/88MvHD0yV4YVVpGX516978ZhTsVBCGpfeXU1u4ADZxxaJu+Rei5fRMePjdbqaj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Figure out the end internally.  This is necessary for future cleanups.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a66889658fdd4..4e6ddcdf9bc62 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3278,18 +3278,17 @@ static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
 /*
  * mas_wr_append: Attempt to append
  * @wr_mas: the maple write state
- * @new_end: The end of the node after the modification
  *
  * This is currently unsafe in rcu mode since the end of the node may be cached
  * by readers while the node contents may be updated which could result in
  * inaccurate information.
  */
-static inline void mas_wr_append(struct ma_wr_state *wr_mas,
-		unsigned char new_end)
+static inline void mas_wr_append(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
 	unsigned char end = mas->end;
+	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
@@ -3482,7 +3481,7 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 			mas_update_gap(mas);
 		break;
 	case wr_append:
-		mas_wr_append(wr_mas, new_end);
+		mas_wr_append(wr_mas);
 		break;
 	case wr_slot_store:
 		mas_wr_slot_store(wr_mas);
-- 
2.47.3


