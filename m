Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64B1E81BD7
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161316B0099; Mon,  9 Feb 2026 10:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149F76B009B; Mon,  9 Feb 2026 10:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25DA6B009D; Mon,  9 Feb 2026 10:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8EF66B0099
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:22:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70ADC140143
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:22:42 +0000 (UTC)
X-FDA: 84425285364.14.A0E0919
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id DDD22C0009
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:22:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LAKUySy6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zkVii2GO;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770650559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0IN1CH7FaRUrFidwhXmqGhdDi1ozPtlZPEMVTuVh50=;
	b=ho5WYxCnqkCOpHocbOYB1AN8kf3oxvlQfH+1jGiqb/dZq9ONwdCdQBs22WoHalLW7myYVu
	ESwpbrwCK5GiiPGPJnLhkGWb3oFRcrypHVqpdPVxgo5UCI3jm/SLTBPf3GJlZHWMDsH8YO
	9FKDN4x5w2k0T4Xz90tm/OHOahGLYuc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LAKUySy6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zkVii2GO;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770650559; a=rsa-sha256;
	cv=pass;
	b=1Q47NSse2M5WFAPFimekOhXPyctBzYhYf7lRz/33Ur0zhhBtzhGwb1TDjAPOWCFKgzlvFZ
	h+BSO7w7zr1LtZMmAWDQiMel+IEkyOLVR58aVttszeHo2ILzd5fxH3s1YjOFqHHcBXERjV
	BDRjRiQ1cgkAK6zM4YBIBy8Fpi97bdU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619EDUA01629265;
	Mon, 9 Feb 2026 15:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=x0IN1CH7FaRUrFidwh
	XmqGhdDi1ozPtlZPEMVTuVh50=; b=LAKUySy65jkiui4TDZlsU2DPig5su02X8X
	EvUodSwLLt9sowO1eWdpjx4R4q0rH9YxcbsgRJfAj1v6BM5SoZeQdGeJGfsBXQLZ
	1R1Q0odbFX6/VJy+/FUHgSzP9fhpG9ukvpiVJtIQ8Fs9j8TB/913YLozoW239ntL
	AqpTu+2Jnzzq/57q4LZ9qBIBFDTpv7xSOFIo2sWY70884MX9hTEPCWcecJS+CDHv
	9B9l+C/3KOCjGWhEWG57AUCo9A0z/JSGSUIfldcIwSxnxPzDHxe/mBGpWk3KIMTE
	gfJ/JE6kj6pv22U2iivG06tPRv8hy4Lge+SQsK2VVyHySJL1QwxQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8t4n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 15:22:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619F2GQb000466;
	Mon, 9 Feb 2026 15:22:04 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uud56w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 15:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLzvR2i3uM+xsp9JQxU3XkT4F1dhtLKdDyJp4g04BuYWbV2qnM7kNoHSGWc3eqs1CR0uz+OUGouo85VGQmZZAuRYqmqFA0F7qK3wes55YdAvS3Ib3+5enB/NoGQPsOzC+Y5IqDVu0EDrIalTITWSW/LeVqOnbHjOne8KjJBV+rO3m++zjLkGQ4VldqkguKpiDdaDrLd21xWuOdi+ppXrqZvwYrbEvr1yVD1oKGCQXo+p8y7qMK2FTtbA1AUxlWsZD2cwmx/aC+h7daLoS4UkQU6/qheanOmbwb+TqpWprW6P73jE4My0D08zRN+1ct+wsdYgwqvrCEvL9Jfzo1AK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0IN1CH7FaRUrFidwhXmqGhdDi1ozPtlZPEMVTuVh50=;
 b=DiMVb7+4YUso9WNXodFfMbnuJTK1OqY2iIDJ/BBxWevQnJQQE3JIksEtLwv75UUyc6XIHkgOCUCJhUI4ZlIi16pR4bKRlpA8VOIfYQmCXURzLEGk0Ia1ExExQCQhavDtmNktWFe39QuhQXluLyqB1Cv4LkQ5WZPH/L/4YPVF03UBefNLjrqRjkkltbLVkTa4a+qDCBVX1yOObOSCcW0ZFDfw7TDgCsVT9GuPjQ9MpMuRRSIyyl+j2k6RoNgV7KJ+xiP+ftq39014XaOMA+9agptkE8GuNcT610ekhwdlwdAf7Gyf1lDv73l73x+NVz7l4/VGaWQkx5b8qhwUU6iJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0IN1CH7FaRUrFidwhXmqGhdDi1ozPtlZPEMVTuVh50=;
 b=zkVii2GO2at4p4xAQDNupHMqyHp5vrW6RojUnCOxt5sma192q7SjooOf88yIjEX8d0TCgIKcmXcnbtjFDALQGAKP7Xd7JR6NJgJrUwK9Co97HLQD7Q03Sh2KLLM4IcrpDmsYGSV18/bBg7DwnJ0FlLw/O6qA78sBUVGT/lVMIdM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6310.namprd10.prod.outlook.com (2603:10b6:510:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 15:21:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 15:21:58 +0000
Date: Mon, 9 Feb 2026 15:21:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        kernel-team@android.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
Message-ID: <df876a6e-013c-4566-890d-7c1d662fced3@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com>
 <9d0d6edd-eab4-4f31-9691-78ed48e7ad5b@lucifer.local>
 <aYSCNur71BJJeB2Q@google.com>
 <9a037fdf-1a98-437f-8b80-7fdc53d5b0fa@lucifer.local>
 <aYSfBJA4hR4shPfI@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYSfBJA4hR4shPfI@google.com>
X-ClientProxiedBy: LNXP265CA0092.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab98117-88e6-4856-5092-08de67eef777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yn3l9hspT6Nok2nY2Wrugzb/aDXjfS0IvRW08i+VIdLKKHbnOqzkSl4ysYYh?=
 =?us-ascii?Q?Ocp+VnpCxxdnM1EynBTlfMuwHaWXH3gTNEoSPyc2N0TjOgIoYELar7BJgTE8?=
 =?us-ascii?Q?tZpHsVLdZCPRSwG1UG6lYT+Y+ATsaiNde/FZE0L2OEHxumBS2v7qvEUl8Zmb?=
 =?us-ascii?Q?15TPzinuNG8soZLYSDsslBi4HTmgeDdY8dr+O4ijKhvMCrueZ6Cl/2h/il2y?=
 =?us-ascii?Q?Z1WLTCbNFNotxbXOAkhLmbaXgs8TzmvJwBeMowWlMuI8hTXu9Nl1Z2rADmN+?=
 =?us-ascii?Q?2fBTZX1i6pAf7uveA18KZh1VdYlTQ6tVOsUvBEzcDkxFaN0N2qB/V76zsnNl?=
 =?us-ascii?Q?Iy34qim+G6JS2NvxOyFqP8xpvcyFRTF7VOMNzZexZLsUt4nS2mdI28YAI5YS?=
 =?us-ascii?Q?gzULBhLDnGh/21rYfNKifoMtYpyQj3a4AuuJqs+d7mjadCAg9sT1Dv+pY+xn?=
 =?us-ascii?Q?wZCKdhWgoNYSXJO21HCjPVrw5nzyZTnpdlZ0vC8FjPX76CuREIl+a8BY3nVt?=
 =?us-ascii?Q?VSHcDxlI0v+WGJ9u7MAdT89c3D7CE0N5V9QrJqmO7pLzYHKNcWLhus0xTEpy?=
 =?us-ascii?Q?OsszV+yDGY4i3q39b9g0CXmdNO1QQU9nRT+6GPzdTaQxSVvbHxO81axNlgG/?=
 =?us-ascii?Q?7NY3+d6nL0OgLfkDMzPDlzgCy/ccNx5ELX5yhI7185uMSJMGmOm/whzua/nB?=
 =?us-ascii?Q?g0V3Sy4WmJJjAiqlNxXPSH+12OrYXHYtVJ5ooeRYoZK8ve5d1zNw0Lj62fAO?=
 =?us-ascii?Q?8TmlkSVAFrjEWBf0Lbnt/9UIqX8H8ZwcWElC6PPQteb/iy0PdSaM1EM+JjCa?=
 =?us-ascii?Q?eY0HtvOcjY01h07m2qyJw1BpQbxAznWxZlMkgCtb+qDoG/EdSXXgtrhZfXMK?=
 =?us-ascii?Q?nArAMmJjwn7WBEe01hyNRBTxxNupY7qU91GrjYVJtVCfmfDBCECc6adVnjAC?=
 =?us-ascii?Q?bBJxZqkdGJWeFDiqkyJ3Re7gdFTC3J0AKuz46YqdamuYI1y+O2qpKQuKXOKU?=
 =?us-ascii?Q?5w9Sjv7Kd9R92Dn76u5QrPmfl4nWiwmxVUgR3/y3EjYeWfRkWOU8tic5dm4c?=
 =?us-ascii?Q?Pr6b1ENzWEGsph2EfxjF2yULugGFxoR4xwYOMGTAI8zRboRACGGzTOEWP84d?=
 =?us-ascii?Q?YiOYtTpz7JlN/0xqgs3w6VlNJvx687B9PFlU1R9sI6S68HdeyHGX42bKHfII?=
 =?us-ascii?Q?DntOf4uESIU7ZUYHYLcp/gRye1wU7FbjO/JgsjlaCaHKBJxToQEsX/qJbuBw?=
 =?us-ascii?Q?LzTVH7CnjLDCcqBjh9Fh/vfIGLdzVvHZLq+nrcyy2AM+dzgVs8Br/LNAVM91?=
 =?us-ascii?Q?+tJ8oOGRJ394RYEztFFmFerEFMxKHmqAm0qJSalCHIFzFOAYKH9Aya9IRbIY?=
 =?us-ascii?Q?fe+iginnA/UZ8BnE88YUWCvzgAHBmjvjZv+MfxeRzXPNfRkam1Ui3n1lq+s8?=
 =?us-ascii?Q?esDyFLRLJZ7PbVoaYVO0JFUQPEJKGVPc5Cvq/93CCPFlC+nuA6fpoEvPwGDA?=
 =?us-ascii?Q?c23L9tA2iJbn0FvU61qsifXMhZW2bf/3V6e98X2f7Puu5RB1Q82ZyHWDQZ1x?=
 =?us-ascii?Q?wEakSCPU9mboV3Heoo0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dggBAxTNOWUAFqxlfcGp0UmKXeVcIcNB/SSWDds5iqLu1fDP8TUXNutX71zI?=
 =?us-ascii?Q?yh2F9h2blYEAzNYycZOfIsEURVNwiw1L7n6x7zilXCvEWJkni4IMYyYE9NqI?=
 =?us-ascii?Q?jCq1SfdN55UBG18tI5+UswDj7fzmnbSjKSdCHwiG43pk5r3llo44RX47X9W0?=
 =?us-ascii?Q?Xjv0gRpQ1ZLH6g8EdVUgjdxZjlArMZoanY5FT+fVgcN0JBf30x+5nri97PAh?=
 =?us-ascii?Q?FGqGMs6Chy51FssQMMJH6g5bGL0XP3RYge0/CkSSUAJnaLRMh3yA79y0X7M+?=
 =?us-ascii?Q?MhApCxTK6+6itlADu6M/Sl33vC9cLTX6o9uhj04z9vNp3KOIOiPgeyy3jmVw?=
 =?us-ascii?Q?cIgvNveiOvD5ULN79R/UirUyd0NReV6jLuT5vhBKvZqrWTA/99izpBPZN8s2?=
 =?us-ascii?Q?a4AXQ5npgNKDBqUhwNga9IuMVnyNzI4CHUQpjYRoVjh7gN8aAmuwCnKfRULV?=
 =?us-ascii?Q?OnjhWUsy49CU9Rev9mkOTBZQZdHW3VeLXACJ0hKQViewdk5OrNs8m9SXJnLv?=
 =?us-ascii?Q?wrkEg/Ag8gf+hzjF6C+KiOmHdfwaRDL7GM1Vb0OtL+9nBHW1/p7d5xqImsbM?=
 =?us-ascii?Q?wfiFMcpccZME3ymsmWps1jDB+zdeNP4fe7XhFzp8dji4bcMTDoAOZlAGTJdI?=
 =?us-ascii?Q?e/OtKfNXeWvQy2976QOX2Cl1riYGM+HJNgw7l3jzO1mlESqWWRcrYR/qO4AY?=
 =?us-ascii?Q?Defp5rtCEZpJhd3BnfHogZnhfzrlbniIpCkqhcm+PUFeR/u6bbEw0BWFzUQf?=
 =?us-ascii?Q?lmPqBwej/sb8M5BM6JaXLCu6DNtYZNPQQK4IV3xx2e75+tdJoSdajds0uUZa?=
 =?us-ascii?Q?CQAqWad51B/t6newiNtUV6Aoo403RCcyiQUnU3uYq5ZJ0i58GIWix9b8QECz?=
 =?us-ascii?Q?5QRhU29mKSUO+bvpcNOi7l+2GTrmgg11J2SJhbPffXzjbNJYVuofmIybsUhz?=
 =?us-ascii?Q?JwEBBnweXBhfn05/QBsE3lSq1uEJG+QU7L/8hPtQmVjGWFBjBSg2omYlEQ4g?=
 =?us-ascii?Q?l2G9KF447xrccn4BHqgxwQXmEt7EGL/XrlPMAj9ns1hUG+z95yIkIpSqhkfd?=
 =?us-ascii?Q?WKXy2Ls1T7KfC5NiA2syvEFdb3POznb/BQgEYbs1fF4cef9Awf1yZ50VF+X7?=
 =?us-ascii?Q?ttN14ay/9xgvLG1bGDU2lYvFMWf1Ytdbpz2MfC2Y3zyHjAPbsdxyutx13hHY?=
 =?us-ascii?Q?bHy/Ml+GTldv3jxSaunXm7Fe8FadrN4GphXSwL89ugbaEUOmgGyL+WSgUYfv?=
 =?us-ascii?Q?Fln30Yggv4ocGI77jO3OxduWDxjFO2lHEZOkyAyaw1uMbf3Wr/3BY4ju1IC6?=
 =?us-ascii?Q?ZUvm3a08KoTKCg5fGM+PmNR1bUeNZDFBZTH/kmAbAT9XIc+K4SYUl6uAGlFu?=
 =?us-ascii?Q?W1sFmvExSONYd0o3pjSgAXkkM1Y1fhOeGJDVjLruNxSG3w9z7eJ1ByCKpaPz?=
 =?us-ascii?Q?QcgpLxiK81cs0i/JqaFU8BnvkgvNaZMOxrADrbpIdM98iXe/8xLZwQg4iyMC?=
 =?us-ascii?Q?I08NhxUbbX5kOo+spe0Sy74MYTXBAFTmc3DolX35zpcyN2TdZi8k5/aeHKWe?=
 =?us-ascii?Q?1AS3pP295BHtcTF1tI209WIcnYgTFqjLEq7PbUCGSBR7dyaAuuATIufpS4rH?=
 =?us-ascii?Q?QJQ6Jj6pG++zWJziJh8qejBD8T9bzERxcaCnS25nEw1RaQWlclpGrMh6Rj/M?=
 =?us-ascii?Q?el4AXdLfLCCDQQ0Ec6edTaczC8QeO5pwJd0IuX/chxHKSQiILcvHrJEPKzFT?=
 =?us-ascii?Q?MNRRqdMHPw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c37EManUcl6fnU+gAxKNEjirpHYOAgJJam7/hwfm97xq53jB8sXMTeLoibIKR14NVOW8LJPnnPzDMhyTlsaCy2xUviV/VEPgVwyrzSDrIlfIOcihGaxnX0LZo0UEk67Fgl7S640s10PpSngpN4m19yx2LCm58u/7nohCQiOaBFur2sLQCjwTQQ5rNNreqINPtbB2Evg2d2tgYpxFXrxZmhcys1nV/qtC2dNv3Qa/nzOrhmaqOeO3i53LtDEt1zmmXhiDZnAN6eX+AfuP7kJuGY4wXAvNorzKiQSmdVDhYNJUN+uOTDEUmcW/MMIjb8/9Yn45GgCI/N59YRWaK7CM9erNr2IibMYp9nAuD7wRSIM8WTbx/6EqjgHSdetC9/nO7Oa9JN7MiMN8oCOenzzkAc8po++bTa2XP6Bloqx7GwFsUvetN+qkKZphUurLAnZxmM0oMimJCixm8dcZRGtmktSOdrevBzJw0Dww088iGeDP55KTKcLfOHCFlaJmHBBw8V8vQMNdKD2vKCp+Kfpko7MbV/Kd86u75x1zCZJJ0BK5CY75mE2MgfL2X3LoYaOjucM7l5mDmS7Wx+yR+ABAaKCvd/nHEtNQgHWfARk1dIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab98117-88e6-4856-5092-08de67eef777
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 15:21:58.6881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjKlK/v7RXRIFi574dqujywRoTjMReKlWObzYfMUn3VLt9gOWkTRZeJ2EYDAwTIvCO8Nn13PIWhhn468ZeQrZz38OlV61ipcmhB+SpedZ5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6310
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602090129
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=6989fb9f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=hLlj1LU_pwC3xl6fNYoA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: GeyDTgPrkbLz_7xeVxvgiMrbyGay7ICk
X-Proofpoint-GUID: GeyDTgPrkbLz_7xeVxvgiMrbyGay7ICk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEyOSBTYWx0ZWRfX5Y1o3wnBKZj+
 jHIyqQZaFVEqhv27Ja299/7515hi8WjkX67PjGSm+XXEx2BY/cLRs2LqsLTUYxNFees8rbTE91O
 k8WudiVScHIjDKbL1inRu+Sfsan6d4xEbjKQ+b3pZfVN0wtxNsR3N+fKaXMrLg51MNiR+MebUIP
 m+97+s3W8xw8gcBuMa0dAuBoWARCnQUI0t3OuUtf7C6rcPHyaTVaq41Uu/wbfM8j3xvzjsoMykR
 5oivrMECSgAZ6ATVjrgPYh/Y3qwsdkw58BE2qW0r1YWnCyammYM2qcqs/c3s+a0EivUgzm0ccdE
 WUdWxE/BY7lNysuRxPOxznzQMpcYX+ias6LbNHwMxVPImhqTBgmq0TQqYJ3REiqxvka0jggJWgC
 f/OS2AvEgGMg7M1N61CveJorjEp5n+Axo1lXHWkeN1CJok/5679c9xTf4v9FKYRMNCT49gsuVQw
 tVcjLl0v2QJL1bx1//PSkliYczNOoFJLsMrhBVQk=
X-Stat-Signature: t5q7xacyjuowwg6if9kwahmnxjwqie1h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDD22C0009
X-HE-Tag: 1770650558-692267
X-HE-Meta: U2FsdGVkX1+LW5k4agcwXllQ5B/+NHEMAXX+KM7TN31yWr9y3mq9874iP3Swvpj47T4e/PKx3m46VO2rSIT0zhQ8VTLUDELoqL1sPaulUNl2XI2JrUiEXTM4qFsqxo0/rwC0NpjNWCVcB/aWd4oyuayN/zT0gfKVy8WE2Yo8XBk8J8VrV6hdjQiM2qq3L9PNF/sDmjOYxV0vx/X1KZv3IACrDl7o1gnKfAHFgtmrlumCpf6BIMwNd415khQXNlmTpl3N2fkPMSIEn0uGud9wLtirE4GQ950OGL+kiGozl01fcYJBtDOAbYw1JC4mHrWY/JmRJ3xDVbPcSRv/jQPulYqbTPp9WVe0VpB4OvQgJoXdR78EGOZIVW/flI8Wg8hyPJQY4dPZfd8SQRS1uofrb1IShSamUOVQ5fbdrPmtYB6VqzHSN4ed1kjCjnu36miK1uELI253oyIkAYHoM/P4ZreZTc1nDJzCahnC4W5ZOs6d12RzmbYIshhHxkvV4mlGNmMNbyAvdxgl57OmhQde1USOZRANxkhSAfQNA9P0+F0R5bbArn4kZSZc8iX0yIwpOHZJMAnjTO4l5Pg/dBTEM41xy9ssxsM06/jUtO6WbnBxUtl3kx05HkLkNEneN+E6RnsfHsPYz0DRtQSA+LiiRf3OroYXg757ImizfgI5c36AWP3mLXnK/4jjNwSeyAWJTQMAENH7SwRxC5njg0hs7pdNJAjkj6OmgtcQ+agQMn9OmdkZ9AosJSWSd6140vn2iQDwne9klf7JQ8zcWB5iBaL/1xTlyISdYqLle5MuRLHqAndVrpjFEpfxZnE6T6hsqQve0Rq8zzxxNorOC2Ye42n9uUiurc9TcwG2/bqSCWIiC2vwJdQ6H2KQMCIop5bgrKPJGwSLFYDEyZhkPFywPA7UatzjFatTZbvyAhe4qmxFqlCgwlJdy6Lrdtwz07ku0XmG9jEr5mWu02DdWKv
 1BAiJP6m
 Pcb7vGcd5dHDVsVpl/zOUbDaB0BcQxhYk2jCEKsAZVu7hUS0hWgrXpFNUpT3hUHdfCEvWKSC8zcTI9FDqIgQls/5m+eOjYXZ9l3kW8QxK5YLccsSAZv+uJzRWKbd8cDR5shxP+AVx8DdDg6Okbg4kKXkRCrRftcgT1EucRHGU8p6xHVdwbuPcnlXrR4FRzcWn9c5+2B29U6b5NqL9sgRzXTQhpMQ939I2jqtziC2DEB91v3NfTz9oxej3W+9vvWgfQWCJn6r8sAtH6uN+j3AXoYmB+aFsEFfUpmN2mpmlzv7l3T/faeo6zXMQeHtwMhJoOM0BwqMGSrgytEXZl+cs/oWKyJHwlTj0Otn04yhtYuiFlt+Y/HkWCj1nYR1sS8gzfU/QoNcAf16Tgq8bDtLS8xvg/QFCu1GtxPit6oWOeA1cVAgDkXBfg8DGY9+X3f6UeFcUxGJEUYSAqQWWFKRYkHPOtz8NAPbbtQkmdve72g4URVu7DrStk4twb8XQtYQr/L+NTzZWBQ19LWKtOug58+rX1P0wOdlL+AQ2wtRDoqy8iv1Lnza25b4ozrgBvajAEu6FGWTskJQEHg+REEMds3iBgL9ppwGDtaE6tc6VgsFy4xNY6Fc6oT8oIJvigm7XWhG3SshSTVblvGRyaDcvp+J4djZrvjKfGr7nd/qMed3nxPnIYsNb537/gtILd/DnoEAjoShPK2qBH/L8S/24o3+ABR59YTl7lTFjfBZVq0sfIQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:45:40PM +0000, Alice Ryhl wrote:
> On Thu, Feb 05, 2026 at 11:53:19AM +0000, Lorenzo Stoakes wrote:
> > On Thu, Feb 05, 2026 at 11:42:46AM +0000, Alice Ryhl wrote:
> > > On Thu, Feb 05, 2026 at 11:20:33AM +0000, Lorenzo Stoakes wrote:
> > > > On Thu, Feb 05, 2026 at 10:51:26AM +0000, Alice Ryhl wrote:
> > > > > This exports the functionality needed by Binder to close file
> > > > > descriptors.
> > > > >
> > > > > When you send a fd over Binder, what happens is this:
> > > > >
> > > > > 1. The sending process turns the fd into a struct file and stores it in
> > > > >    the transaction object.
> > > > > 2. When the receiving process gets the message, the fd is installed as a
> > > > >    fd into the current process.
> > > > > 3. When the receiving process is done handling the message, it tells
> > > > >    Binder to clean up the transaction. As part of this, fds embedded in
> > > > >    the transaction are closed.
> > > > >
> > > > > Note that it was not always implemented like this. Previously the
> > > > > sending process would install the fd directly into the receiving proc in
> > > > > step 1, but as discussed previously [1] this is not ideal and has since
> > > > > been changed so that fd install happens during receive.
> > > > >
> > > > > The functions being exported here are for closing the fd in step 3. They
> > > > > are required because closing a fd from an ioctl is in general not safe.
> > > > > This is to meet the requirements for using fdget(), which is used by the
> > > > > ioctl framework code before calling into the driver's implementation of
> > > > > the ioctl. Binder works around this with this sequence of operations:
> > > > >
> > > > > 1. file_close_fd()
> > > > > 2. get_file()
> > > > > 3. filp_close()
> > > > > 4. task_work_add(current, TWA_RESUME)
> > > > > 5. <binder returns from ioctl>
> > > > > 6. fput()
> > > > >
> > > > > This ensures that when fput() is called in the task work, the fdget()
> > > > > that the ioctl framework code uses has already been fdput(), so if the
> > > > > fd being closed happens to be the same fd, then the fd is not closed
> > > > > in violation of the fdget() rules.
> > > >
> > > > I'm not really familiar with this mechanism but you're already talking about
> > > > this being a workaround so strikes me the correct thing to do is to find a way
> > > > to do this in the kernel sensibly rather than exporting internal implementation
> > > > details and doing it in binder.
> > >
> > > I did previously submit a patch that implemented this logic outside of
> > > Binder, but I was advised to move it into Binder.
> >
> > Right yeah that's just odd to me, we really do not want to be adding internal
> > implementation details to drivers.
> >
> > This is based on bitter experience of bugs being caused by drivers abusing every
> > interface they get, which is basically exactly what always happens, sadly.
> >
> > And out-of-tree is heavily discouraged.
> >
> > Also can we use EXPORT_SYMBOL_FOR_MODULES() for anything we do need to export to
> > make it explicitly only for binder, perhaps?
> >
> > >
> > > But I'm happy to submit a patch to extract this logic into some sort of
> > > close_fd_safe() method that can be called even if said fd is currently
> > > held using fdget().
> >
> > Yup, especially given Christian's view on the kernel task export here I think
> > that's a more sensible approach.
> >
> > But obviously I defer the sensible-ness of this to him as I am but an mm dev :)
>
> Quick sketch of how this would look:
>
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index adde1e40cccd..6fb7175ff69b 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -64,7 +64,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/ratelimit.h>
>  #include <linux/syscalls.h>
> -#include <linux/task_work.h>
>  #include <linux/sizes.h>
>  #include <linux/ktime.h>
>
> @@ -1962,68 +1961,6 @@ static bool binder_validate_fixup(struct binder_proc *proc,
>  	return (fixup_offset >= last_min_offset);
>  }
>
> -/**
> - * struct binder_task_work_cb - for deferred close
> - *
> - * @twork:                callback_head for task work
> - * @file:                 file to close
> - *
> - * Structure to pass task work to be handled after
> - * returning from binder_ioctl() via task_work_add().
> - */
> -struct binder_task_work_cb {
> -	struct callback_head twork;
> -	struct file *file;
> -};
> -
> -/**
> - * binder_do_fd_close() - close list of file descriptors
> - * @twork:	callback head for task work
> - *
> - * It is not safe to call ksys_close() during the binder_ioctl()
> - * function if there is a chance that binder's own file descriptor
> - * might be closed. This is to meet the requirements for using
> - * fdget() (see comments for __fget_light()). Therefore use
> - * task_work_add() to schedule the close operation once we have
> - * returned from binder_ioctl(). This function is a callback
> - * for that mechanism and does the actual ksys_close() on the
> - * given file descriptor.
> - */
> -static void binder_do_fd_close(struct callback_head *twork)
> -{
> -	struct binder_task_work_cb *twcb = container_of(twork,
> -			struct binder_task_work_cb, twork);
> -
> -	fput(twcb->file);
> -	kfree(twcb);
> -}
> -
> -/**
> - * binder_deferred_fd_close() - schedule a close for the given file-descriptor
> - * @fd:		file-descriptor to close
> - *
> - * See comments in binder_do_fd_close(). This function is used to schedule
> - * a file-descriptor to be closed after returning from binder_ioctl().
> - */
> -static void binder_deferred_fd_close(int fd)
> -{
> -	struct binder_task_work_cb *twcb;
> -
> -	twcb = kzalloc(sizeof(*twcb), GFP_KERNEL);
> -	if (!twcb)
> -		return;
> -	init_task_work(&twcb->twork, binder_do_fd_close);
> -	twcb->file = file_close_fd(fd);
> -	if (twcb->file) {
> -		// pin it until binder_do_fd_close(); see comments there
> -		get_file(twcb->file);
> -		filp_close(twcb->file, current->files);
> -		task_work_add(current, &twcb->twork, TWA_RESUME);
> -	} else {
> -		kfree(twcb);
> -	}
> -}
> -
>  static void binder_transaction_buffer_release(struct binder_proc *proc,
>  					      struct binder_thread *thread,
>  					      struct binder_buffer *buffer,
> @@ -2183,7 +2120,10 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
>  						offset, sizeof(fd));
>  				WARN_ON(err);
>  				if (!err) {
> -					binder_deferred_fd_close(fd);
> +					/*
> +					 * Intentionally ignore EBADF errors here.
> +					 */
> +					close_fd_safe(fd, GFP_KERNEL | __GFP_NOFAIL);
>  					/*
>  					 * Need to make sure the thread goes
>  					 * back to userspace to complete the
> diff --git a/fs/file.c b/fs/file.c
> index 0a4f3bdb2dec..58e3825e846c 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -21,6 +21,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/close_range.h>
>  #include <linux/file_ref.h>
> +#include <linux/task_work.h>
>  #include <net/sock.h>
>  #include <linux/init_task.h>
>
> @@ -1525,3 +1526,47 @@ int iterate_fd(struct files_struct *files, unsigned n,
>  	return res;
>  }
>  EXPORT_SYMBOL(iterate_fd);
> +
> +struct close_fd_safe_task_work {
> +	struct callback_head twork;
> +	struct file *file;
> +};
> +
> +static void close_fd_safe_callback(struct callback_head *twork)
> +{
> +	struct close_fd_safe_task_work *twcb = container_of(twork,
> +			struct close_fd_safe_task_work, twork);
> +
> +	fput(twcb->file);
> +	kfree(twcb);
> +}
> +
> +/**
> + * close_fd_safe - close the given fd
> + * @fd: file descriptor to close
> + * @flags: gfp flags for allocation of task work
> + *
> + * This closes an fd. Unlike close_fd(), this may be used even if the fd is
> + * currently held with fdget().
> + *
> + * Returns: 0 or an error code
> + */
> +int close_fd_safe(unsigned int fd, gfp_t flags)
> +{
> +	struct close_fd_safe_task_work *twcb;
> +
> +	twcb = kzalloc(sizeof(*twcb), flags);
> +	if (!twcb)
> +		return -ENOMEM;
> +	init_task_work(&twcb->twork, close_fd_safe_callback);
> +	twcb->file = file_close_fd(fd);
> +	if (!twcb->file) {
> +		kfree(twcb);
> +		return -EBADF;
> +	}
> +
> +	get_file(twcb->file);
> +	filp_close(twcb->file, current->files);
> +	task_work_add(current, &twcb->twork, TWA_RESUME);
> +	return 0;
> +}

Would need an EXPORT_SYMBOL_FOR_MODULES(...) here right?

> diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
> index c45306a9f007..1c99a56c0cdf 100644
> --- a/include/linux/fdtable.h
> +++ b/include/linux/fdtable.h
> @@ -111,6 +111,7 @@ int iterate_fd(struct files_struct *, unsigned,
>  		const void *);
>
>  extern int close_fd(unsigned int fd);
> +extern int close_fd_safe(unsigned int fd, gfp_t flags);

One nit, generally well in mm anyway we avoid the 'extern' and remove them as we
go. Not sure about vfs actually though?

>  extern struct file *file_close_fd(unsigned int fd);
>
>  extern struct kmem_cache *files_cachep;

I mean this is essentially taking what's in binder and making it a general
thing, so needs Christian's input on whether this is sensible I think :)

Cheers, Lorenzo

