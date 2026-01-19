Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E09D29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DA06B02BC; Mon, 19 Jan 2026 11:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F09B6B02BE; Mon, 19 Jan 2026 11:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DC96B02BF; Mon, 19 Jan 2026 11:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70D966B02BC
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:47:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44FE71601D4
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:47:53 +0000 (UTC)
X-FDA: 84349295226.12.4A0CBAA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5952140010
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:47:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dHqiK5Ue;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CfeU7CP4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768841269; a=rsa-sha256;
	cv=pass;
	b=UUt1/wmqQyb235dyy5ZBa6WZMzoi2iN7hTYwATKSbhtx2Hyty9U4ZsV76CpTaqUxWBwqtF
	UwE+QOII1cQV9cLlJjD/x4RKWtEZLlSIv9xEIZ33SDJ+tN6ZPtIIHY/1z5ljbpAvwkhV8v
	m92SuTgKfVswonMv0G8n5gW3E8l7Tm4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dHqiK5Ue;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CfeU7CP4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768841269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXLKn2QFYeNw5rDJ/fN6nlg9sjQD3fUxDd/yIMS3gsk=;
	b=d6QmfygE2+yiQG/SIWL6Tk65AOp4Lzs4/GpX1NUucmI9q15SfBiWC7TQCLuZdFpF/lXik9
	nDMX/yEnTZjob+dwDps65/4CSjE+zqu6DXftepYEc+uJzRmns/xMtzgi5Rw+73SMHstuMY
	zetHGh6ujIEWF8hPHzAoAFSccU2eUyk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60JBDQsx1341821;
	Mon, 19 Jan 2026 16:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vXLKn2QFYeNw5rDJ/fN6nlg9sjQD3fUxDd/yIMS3gsk=; b=
	dHqiK5UenYc84Z7THRny96SfXeBKNBDVSpAI2UINat33trZhuKjlEgHbYaKa6G31
	aPTfD79Nozntdda1LgKfrk0PbzzcDCS8DHlyDmnoUTt/ZNjouVQr9pDLgVRfJRBn
	25bnt51PyPEZ7AysS3XENB4f1XaT+L1ND1tYLYm+FXS/eYfUu8bscG4/gx4ywwiO
	M38isUj4CKi+45PAjd1BgRj9VAyUkm7rjbr9B9p3gzfdWM0OZK5o7NjxbNulT920
	IlhJhPHbiJWiiaMV0QOzmcyqLT4zcHCHWxEdc/VmGllF48IvwKQvXMkh6ugjy6/t
	M4CioaiZwbHozmB4EiRUyw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br170ajnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 16:47:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JFFcSs022445;
	Mon, 19 Jan 2026 16:47:26 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcb66t-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 16:47:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=woKIcshSmJ+jOVE05ggrXf+7wD6rlvI6MFKx6ujiXJwqLjLlp97yWv2+8CQcyWyzm39IizC6X+WKHaRKxeVpgmCEGlj74qftZI4BYU0O2fokPgcmUezdeA0gg67o8BLDlNZEB8efkuUzhK0qeqPs53HLrg3nvfiLU0fofew3CHFxbZqlCNMG5xyZ38I+zTVTcEyja88dugspo8o+qAN783jBZFE3xVlH5NxH9kTdlCqMQKD/AMPPAFzeIJGj2y39wwDQA4LOzy7DDqP0rMqNts/fTewcN7fzTN1PWer4DLy3ViCZDzbFs09rO5CHiOLm520B1O6e3LiRuscxyD2Rbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXLKn2QFYeNw5rDJ/fN6nlg9sjQD3fUxDd/yIMS3gsk=;
 b=UaJq8caCQHxVvQ+xXL7OqLw2/7m8/xwk7unKsHvC5xwCLyni9K7nmrw2VxYdzO6iFY+Mgspk/IqLBHBRdSIdNVq6jxMCEtv/vOOSGpa2MrsG54Fq1mrm13ajt3xFko732vIG0dIz7WznkvLJjUW/KoIOJd8jCgT2KcsZow2Txt5v5XqmOwmSwWbPIZM6059uzliKrZ/hQ4H7dulzgGZyLGaag6AAvMihjiC3TUbigCPg34cHhoUBRxMwb9swOFtNqE9Joj4904G8vrdayGrl5HdkTeucGwk1iFPVffLoQAHGdiw0S3xqqo1eyooKoO7UfbWtk8M55B+AfowWhTfGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXLKn2QFYeNw5rDJ/fN6nlg9sjQD3fUxDd/yIMS3gsk=;
 b=CfeU7CP4xc90BtfXFKrKhwTb4YfDOyRlAmlUT2GJ22piCyb1O2/f4Bp05mVm8SuU/wujXfGZsrLm2j1Vn9nAPbXcrkhWGCnAawhsAEjWi6qXmhgLCZmgjhS3MiTNVaAMm0IzNAko1sSF1v1p3kw+nvQWf0O3/49vqEXEZT8jT0g=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 16:47:21 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 16:47:20 +0000
Message-ID: <8808c9f0-a998-448c-a4b6-b88fabb2ca23@oracle.com>
Date: Mon, 19 Jan 2026 11:47:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 31/31] nfsd: convert dprintks in check_export() to
 tracepoints
To: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, NeilBrown <neil@brown.name>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang
 <baolin.wang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale
 <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Bharath SM
 <bharathsm@microsoft.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg
 <martin@omnibond.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: David Laight <david.laight.linux@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
        ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
        linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
        linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
 <20260119-exportfs-nfsd-v2-31-d93368f903bd@kernel.org>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <20260119-exportfs-nfsd-v2-31-d93368f903bd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0055.namprd14.prod.outlook.com
 (2603:10b6:610:56::35) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b5ecef-b5d4-42e8-2652-08de577a69bb
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?TU1sWVNlN0h1ckVBcVFmM0dPb0ErVjVhbkZHbkZjUUdRMDdQMk8xL245TnBR?=
 =?utf-8?B?Z3hwWlg5ZndIeW5ZbVphY0lQWjh4bERiQVZXdTFiOGRiSlNudjRoUnNUWGRk?=
 =?utf-8?B?TDM3OUdDSmEvNmM1MGVMSnVZVnpBOTBlL3k0VkVNb0V6ZXVlbzcxMW5oWUhz?=
 =?utf-8?B?cktCNHo1dm9BZG1PTHFRbXdkZTZtOHZhbFJDYVVwK0tacDhlYURzYWhPdmI0?=
 =?utf-8?B?ODg2WGRkUjZsYldXK2VLSnZ6Q0tTMS9BMzRFZ3pZNVoxVGFjTGNjdWdiVmF1?=
 =?utf-8?B?WG5kZDFuclo4cHdIL0Q1d1BVem01dnpuaURqbmpaN3lrMURvVjJNczNIbWRt?=
 =?utf-8?B?Yyt5QktSQUFYWjBZbzlFZzVaOUpDY3JTN0ljVHgxMDRuUFczckJ2REdRVWZ1?=
 =?utf-8?B?bXRFYUZYYkdqT0E3TXR2bHFTYWdvaHpHQWFveGhkUDE1eGphMkg0eW41YjlO?=
 =?utf-8?B?LytRNW44VlQ4bFRORFVWVW1oNlFPSEdiQk9kS2hkekorWUpkMzlGQWRKMTBm?=
 =?utf-8?B?djhXcS9ybDIrdW9IM0x0ZmRQMWhhYTBWZkZacGdWM1gyNXhZcWxmQk80M1VB?=
 =?utf-8?B?bFFBSGZjaytiSEtia1hwS2oxcldjc1NCTzUza0dGNENGV05zRzRGUzA5TmJa?=
 =?utf-8?B?eUdwbnIxQmdYTGZLNElhT0RzMmFLcUM4ZitVb1pTeEdmOGdya0hqM0FkbERk?=
 =?utf-8?B?cGl2UkdUdkxCYm4yQktlenNNL0tTNHp4QTBPSis5eFhFZ1JJQkRncWFkWSt5?=
 =?utf-8?B?cFgyaGFKYWJ1QndDdmpYS2F4d1RnSncwcFY1emVxemxWcVNFUlRhV05VRUNz?=
 =?utf-8?B?YnE3SUc5a3JycEc4YWRkRGxvb1RPZFI0bEtxYWVpWHp5SHQzeCtSMkRUSnUx?=
 =?utf-8?B?bkg1NGs1eE84Z0ZueERDbUNDRnM1NDg4ZVNUai92UVFoTHdqT1l3dC9mQWcy?=
 =?utf-8?B?QVFUV0syQ0pudGw1bHhsSHRQazdpQXltQ09iZDhEcnZJd3JtQTdGNUwybElY?=
 =?utf-8?B?Z3BkanlQbENUL1prY01nZmxFRHhtQ0pGMm5QcndCODlPVlBpVU5TUDAzTzI5?=
 =?utf-8?B?RUJ4NWZCcHJ2ZkxiMXJNRmY1WVJ2ZVRJVnJxbWh3dEhDSnhadm40OTBEZ2hq?=
 =?utf-8?B?VHBiY2VtME1KZFlIV3dESnZYQ3lRYzc4ek13a1VoWkFkYm81SGozNWo2NWtR?=
 =?utf-8?B?NGVHMGlBdmFlUTNuUlBna012akNFWTdmSDAxeEREZUYvVFFQaVpVd2tnak85?=
 =?utf-8?B?RG5lenJERjhSR05HZFoyRmpneDlRalJaZHFpbWtwODhsK1RMS3BFZFJiZURX?=
 =?utf-8?B?cTFxTWl4SXFZcG1Gd2FPcVYxcnZZNm96ZzFxbVZBbVhaOTUrTUdYcDl2dkZD?=
 =?utf-8?B?VkNid1JEb2x5a2FuQ3lFbmgxRlZhUXkreEFVQ1Q2VWxVTGE1Q1RCM0lVTHBq?=
 =?utf-8?B?WHhqMTJlNnJxY0w5Z21QV3QzMEZUNUVTUnRERkdGcENaS2trR042R1JvQzFC?=
 =?utf-8?B?V2d6cno3M2tpRGlISWordXpETjJiSjJlL29RUTEzMFpKQ2xSRWNiZnZROWhW?=
 =?utf-8?B?aFBTWmQxSDY2bjl0WXBHeitkZ1JCSXdpYnV5NnhBZGx0RFA2UUZZcTMzajJO?=
 =?utf-8?B?QmV5VkFPYUxQOFFGUDdPc1l1eUl1UUltZ0RWN2ZyaVNTdmZ6SWlTYWZEaWw0?=
 =?utf-8?B?MDF2L2JuZ3RFSGdnSmd1bVF1WG8xQUV0YjNUQVVHbUVHWDFKdWdjS216Q1JG?=
 =?utf-8?B?UzRqVk5LWWRDK0tnbUJ1Mm42blhMSk9USWUvOXF0eDVoOUU0ZlZNY0VFSnBB?=
 =?utf-8?B?TGdjNnhzckRKeFd0Q3pTUnVHNzNoUGlDWjMybTMwbGo1dFJjMUtWai9Yck42?=
 =?utf-8?B?R2RtQVBqdGlJM0p4S1pORWZ2MWFXRUpzMjJVTjVHelpNTlJqS004Kzg3L2JB?=
 =?utf-8?B?cnlmVVErK2RxWUh6QWdEU1VaVG9QcnpLZEpGQ2NEQUFkNVRMbm4yM2pSY1Rk?=
 =?utf-8?B?R1o3Mlk0d1gvL2laQjJRUTVSTGFSYmpBc0xlMW9OdVlrbEdnUVlKMnVSYWpM?=
 =?utf-8?B?S0tHdGVjTWo4TGJ6ditOa1NlbXlWc3IxU3RDcXFkUkxDaE95Q3dJbVhBTDhO?=
 =?utf-8?B?dG5RMUQ5VVdubWpBZ1BYeUcrUGQ5am5KbGZFQlhQUVF1RjVTUHI2TTRwVGs0?=
 =?utf-8?B?OVE9PQ==?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?T0wxSlJLc3psdFNIVkRpUnBOMFkrWURDWE5vYllzVGF1SWZLU092UzZYZlhV?=
 =?utf-8?B?MXIyR011SEExU2o4RkhBYU9RUXhvajBGSlRxRFJzTzU3Sm9oaDc2bzBoVGcx?=
 =?utf-8?B?UWhoOHpsc1I3R2VSayt1K3NqcWcyZTJpeFZXNFEySjZ0Undqc2ZlNHZneW9s?=
 =?utf-8?B?REVOVzRLaXFuL2xFRkQ1eWtlSEZUZzF5d0p1Q2s1endoQ0hZQ3puYUJxTS9j?=
 =?utf-8?B?QUtUQ3VvVFJuQ09XMkw1dXVrWU0yVGR6dHV4MWVGeDBTOGZ2REhSd1ZzUFFT?=
 =?utf-8?B?NmJjYzlPeUdkMzNaRnJOZUFCdnBkTkJpYzdZMTlEM0t3YW9rSnQxL202a21B?=
 =?utf-8?B?TE80MjJibVJWZ010UWE4S1p6REdDZzYvWjdqMVhzbXIvbHBJN3BHL1p2YWtE?=
 =?utf-8?B?WDZQNExPVENXRGk5WmRrOVFIbWZ4NnJiUUUzYU1HNmtNWXl6ZGZhNHJKdDF4?=
 =?utf-8?B?elNUMGxJMXhEVWx3TW5uZGN1YTJLNmFzeXhvNEp4MWQvMHVpNUNXWGpDVlhV?=
 =?utf-8?B?VVp4V1UrWVlFRnFLellHSHBLTjlXbFBQSmN6ckFpbTlzMkI1TFhUb2I3OGdi?=
 =?utf-8?B?OFdHclZWTjluRVo0WHJ2WWN6cTdCaE4zT0pSYzN0UjBkZmp6RHovbXZTM2NF?=
 =?utf-8?B?dUMwSG9oY3NGYVkyWm03YWRjbmk2UEI1QXFOejh3bkwvTFdiZDR0WkM5T25a?=
 =?utf-8?B?RUVlWkQ4bGxuSzBkaCtrZm5QSmRkSEcyOCt5dERVdE0xZk5ISHN5MHBodTNi?=
 =?utf-8?B?OHBsWFR0WnI0dGlUTUc0dWRtZFMya2Z3ZlBWS3dVeEQvVUZNeWd4b09CcDRk?=
 =?utf-8?B?YXgvQXBheGRlVThXUndLM1ZXSzJDbDd0MkU1WUVkbk1ScENWeW81NWl3WUlx?=
 =?utf-8?B?ZkpVcGJ5MGJHTFpoRHJiamRzeUtqdFhiZFYzc3gwd09JVk9yRUF0WmNyUE5H?=
 =?utf-8?B?Sk5HVlFtc1RMVk5ZVVNOT25kK0hBNTR6Nk1pMkFzeVpycnpsbmNpaUhYS2xj?=
 =?utf-8?B?ZnJ3Zk1JdC9lWDBuN2dnVDV4S2FGbmxIWHJnVWUxTFl1TVJOMEY3VjNwVVZ6?=
 =?utf-8?B?QTdMZFZqREcreDlYYWJPcy8rNXVDdm9yVUJ0VzBRZWk0V0N4NlY4MDNHWmxX?=
 =?utf-8?B?WVpDZDRlMjZ5c0sydys4RXloU0thOERDMzJ4NEl2U3g0MytxbUs5UUhZMlc1?=
 =?utf-8?B?VnNSVE96cmwvNk03WWdvWVpSVjVSb2dnVmRNWG9pdEdHOE5XV0ZkblNIc0lz?=
 =?utf-8?B?NVEwbUpnWnV1Z0lDSFhMdEFaTkQ3Ky9Td255NlRod2x6MW1MWGlPQU5wL0NG?=
 =?utf-8?B?MnRUYm8xbThUc1ZtcUR5a1FFRUl6UjBsWWJRVUxkdTRmWFdQNktxSDYrUksv?=
 =?utf-8?B?UXdySzZEQ0dXZmlIMm9NSzJaSXFmU1Mzdm5rMkpmWlJBbDh0SmpaRWFwOERE?=
 =?utf-8?B?RnY5aHNsbzlveSs5S25IbWNOM1FDcXdrV1A3dFdLU3orK0FKemFVTjNHZGl5?=
 =?utf-8?B?TzJ2UmU5OUQ1L2pDczh0aUd3NS9qb09hT1RlWWpZZ0dOUDFZOEx1ZFgyeVJO?=
 =?utf-8?B?cTROQnlzNWJFVUNPUVA5VWptbWRyRUVaZXJJSk1CQ1VoNVdRaVpXSUFQdnU4?=
 =?utf-8?B?WGQ4dlZaV0lRUTBaTmlLNkRvZktCcVlYbFU4THY0ZHg4MzNBK1BibmpzK1J3?=
 =?utf-8?B?ZE1kNHo3UkloMlo5cDN5YXFPcGJISHE1ZGxtZVJabm1hN1NUdFBYeStUd3Qz?=
 =?utf-8?B?K3dJVDJDTmlkanlKSlRLcnJkTENXR1o4RDdwWHVyK3hBemRwZkgxdkpjOTZS?=
 =?utf-8?B?alp3cnRTYVczajdjNGJWeVpLaXFZWVQ4VmR2SW5Ra3BtL2wxeXFTNmhBcmxn?=
 =?utf-8?B?aGVzZUx5S2x4dWhtaHp4R3g3dEdpNVFaaHBybGRGSktvWVVVYmVIbmdJU0Yv?=
 =?utf-8?B?NlJLWnFIMnlMQWpkdFExbHFjQmhPSngyT0VTN3Q0ZkNScGFQbUxPcjZ3OW9v?=
 =?utf-8?B?SXVHUjJreUxtRHk0TDFhYnY3SGlHbm84NHAxcVR4SnQxdVhGVHVlc0V4S0hV?=
 =?utf-8?B?c0twcmgvYnlySkxxc1FheWRNTlpYdmVVM2pSVzJLWnRwa0JaUVVya2Jwcm9P?=
 =?utf-8?B?ak10cys3OXVJVWZOVnhjekV6YjlUTjY3ek5sek9OcVA2TnpZNVB5L3RQdjZC?=
 =?utf-8?B?NFcyd1AxUnZXMjV6NnNLVnpRT1RzdEp6QWQ1MCtUT3QvUFV0bVpxbStmM01h?=
 =?utf-8?B?eFhVQkpCWjYvOWFybEo3Y1Y5ZThMRFhiUjFUQ0N2M2VjUzNXV1J6OFI1MENh?=
 =?utf-8?B?M2dtM3JOYkpPMVNTaG4xQ294WnZYVHBzbk9xd0IrRUFxbVVsdVpMQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iR97J67qB6booMUzGvhEMb1FCzeocFAm0jUyv7uPMk9/rE6IwTi9mkTGM2/UvL/0ViAyPPybh0IzP933wjhPnNNXR1lcXQ85jzHjjmo3RS77QalmH/dZmrbpHW09zMLGrFIa8i7XnjXubgjeABbGkrTc9zfKvYTUpggoMFKD8OT+k/jWq+1nnmK7K+BhwYTXUv8nEufsgVHdcISuKp0P2Mj1kyEwlWBWI2USfzZxImX4TquOu6I7Th3GJZfBQGrS0pKUaxi6CdteclYRjJ9hMz0N57iu2XZqaImRrks6RN6QwUHXvJbLwoVfkKU1MQFkdZOer2qIToFc9eXk0SGxCsbmZHCqZztQbMKDMfI0Ivz9sGzbO6A5wcChZI8QiWsjXfd9XkJfH/FdBZvDHD/8Zt5fpASp4xURC9GcMtrM4EqrLJe5BgjLWBhdqlLzoPgtgHYjM2eYpbH+OVnmVvSGOlEBhT0W2LyEw68WsyfMoTtsZehafhN7Nou3O++XU//r9qzsMRiJ/24WMjj39m3auJLU58hiU2zS9WI876YLdxWtjL+WPyiEG1qe8cpCIe/IStvNucOYSha65YsngRhg7gWLJYhHndSzBk+AWfsGIfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b5ecef-b5d4-42e8-2652-08de577a69bb
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 16:47:20.5999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TeY+n8+5fr2bzPzvRD/k/mpF3pw6X3JHNxBVMtnE56CQqwnIpGhGQvWyxMQNYsuKUtyc4qtqL86u96PZ3qpQQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_04,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190139
X-Proofpoint-ORIG-GUID: _grNjMp_nmGqlNOUEL0x6HiCgp9EGkRx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDE0MCBTYWx0ZWRfX3sIuVRc/unYI
 c4yIHfj3kx6N+HgyTH7w9KuXv0rdb82Pm3G150Ba24FPRqxMzHP+Onm9o2IQgxPKRKdicaVPB3n
 OlYryC4X8UXV2Ohk4jIYlX8p8wYwSsPirefAinQzOjurCpg/TYztB8gRCmAOxKrTCPr3vbrfzTo
 qtYCvqfhXHHsXEWOWYuHN7JjBvpv7xiQnnxYZM/10SaNQn2zJhV//9k8Z2tjwDpHB0unEoQh6Bw
 csr7HTCRB5FihC0G5wuhOL7Ijo9LQTlaTYdZQX6PEp3oScZjN5Ibu1WcZk31JRc4Jepd0OL9e/y
 KZvBkg4NNlcf86Zpgj77f/EcRCa6/uopiaNWUfcAfmEqf13RkumMXXnDyscgC///TKt+JXWdrga
 rrutaT0HOXMTGSBgNncGTVMhdHlZLDuubmeFYNxtnz+xg+eu+glhwWMZditWeBRRzMa5fXGt+q+
 aEkFOwCvulmv9sbAJXsns1YGcQ3jB1xHGa/kskG4=
X-Proofpoint-GUID: _grNjMp_nmGqlNOUEL0x6HiCgp9EGkRx
X-Authority-Analysis: v=2.4 cv=FvoIPmrq c=1 sm=1 tr=0 ts=696e601f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=rQbvMX7ZmuU9TDQPiW0A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Rspamd-Queue-Id: B5952140010
X-Rspamd-Server: rspam06
X-Stat-Signature: e7mpxe98o4w3usbaf5hgmkqdtiyy9dca
X-Rspam-User: 
X-HE-Tag: 1768841269-671878
X-HE-Meta: U2FsdGVkX1+tpr76kPp7QxbkKOW6+srpj7aauAn7S1XcaBzWE9IDMZSUcUW43VIf6X9qPu2XdtGRbJCmhVWJb7/FmOSQM6VH7mA57ITAyt6Dr9d99s5Aw6Hsvf/kYELmuiQ9QIYcqfmkYzz1t5sGVkt4WBlDWf54rJ6okcgCmqWiuxVsmuajz6gRe2YM0lzq7M4c2dNe5zIx2g42M1zf9LhsXu60j6Sah76TBQ8VEX7wFEMNBc/fd31HXgP7M3i0LXhML2sogEm7kBus9ooJR9yzicj0PIbzIEHcJlPNINyMCgiTlVj49b7csxECszl99LvsDw9YVByRL6BPSA6/GWvCmI/9vitOkh5ai6CUN+k3all8ZhN3reLDT31jGDHuA0cGJw/nFIWYa0NaeLrO9TM5DaVo2ExUo2UI+0192oAPSdZ6iUtCj7IdVQ5NkoS4Yz044dV/EcMsEovgg7qbfwpCXMYkO+qrQNQf6k+2868voP2Gs7N2JQqrGclHl4+h/SzGkBMeixBy2QxP5QRA2qSzY3zmW26XPh9ASYAaeXeCsUU8xU52fH9o4LUijIFakXrhZLDdEkezWhkFcCAIEdAVT/0NxcO+63UqTjzrhD9AzRmRJ+gzNOPWpT7OEk0sVZY4AxpZ9maokwe/OZLxJJh+UJao2pF2FPjQ93NP+UpMeEWlYqvcHEm3yUIqq9VXIyMS7Gy1D+nUSRyV8zdtnxzsA/2buDxNT1O2ZE90v7vvZ9GzaC5fZgN9b2Uh/MdvANY7luldlmHqK0etlc2A3Pxhcs5DqsUCqfxUHRw7B0jl7XLUUF5YCwjeiYXI2m9sXAjNs+brQ6Z37ITvI1fylc8S98NVxBNuLI2lsDHMRcZqGGzY7GsvNrjfpoBj3Hv498DXr9eNLO75TV5TkUXAmRfzuLx4zDAtbmqd2+1s8CDYVR9sSPYcuYFUzMC2xxA6RPG5R3AmtLsAFCBAGRM
 9ATfFRxG
 qFK0LHkJPGp/LfHUCLJRi56ELdAJFegr9LKeKmfRqqe2qru11t3MkHwJoIO6NQBXVxwQnfVvjghbWYIV3OiW99733fh4RyHzFz2hXqGLA+a93pIhO8rF8azAU7Hhwqo2MWQoa2lNEehQqx/MrKMtQxShxtfaQSGij02fATD+3T/zWJ5mVJ/UHQxHl7cDVNbEbGgdUpYLnqL4FNYjbvjWAA9cG2xUcMXy1sp/MJ69ixVOL6dpqHyxA8ngN6wRN7grui0oeKAK3dQlMkT7FrsE/RpfdF72u9zngFaEV8Nj3MpDa/1umlTc7EmvE6kTbs5Vs+xV0sglGPLt5uN+jVOsi8PvioGZOP4ZW0lA4YBFFgZqzGWWTS1UOQQ5pBt7aGrz9ovewHKKeDJ9aZX+N8gsrXKGPxPdWGXZvmVT0Tc6HEqofOtILjgUy6W4bxDYq1QwHEFPQ1CRyv+oG6mvLUKOkcTZ+sRd6BEnksYDYvLP5/sST4zL17x2LNEO7Wdbn6t03bkm2kiKsWCeB4B+sWFLuf8LSLluaBCiXmqSDH8O8H6tGiOcRit8wDZ50rHHPOwJQqOxCGOtbv/4MgnBZ1Ca4Q1h2atM7qDPDZI9QUG19k1c5Nc2LXo3yOduoSlwrpaV8k095tX3mhyQEUBduB46acJmWDiKAHI68edjalA/HWIDqh18A2G1FIdaEFFMHT1EkXj/GCv3UsfSCAeUdLANcXqBKrxW3eRUAsqugNyD/wy0QgeweIPB8AIvQlSXFeFHx4cD7TImbXgyigGe25ehMUZIlL5kHF01WRB9Fm1jj85Xbfw8/2Ie2w6qA0e4r/TdHWKgeXek18GWb0QY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 11:26 AM, Jeff Layton wrote:
> Get rid of the dprintk messages in check_export(). Instead add new
> tracepoints that show the terminal inode and the flags.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nfsd/export.c | 11 ++++++-----
>  fs/nfsd/trace.h  | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
> index bc703cf58bfa210c7c57d49f22f15bc10d7cfc91..3cc336b953b38573966c43000f31cd341380837b 100644
> --- a/fs/nfsd/export.c
> +++ b/fs/nfsd/export.c
> @@ -435,31 +435,32 @@ static int check_export(const struct path *path, int *flags, unsigned char *uuid
>  	if (!(inode->i_sb->s_type->fs_flags & FS_REQUIRES_DEV) &&
>  	    !(*flags & NFSEXP_FSID) &&
>  	    uuid == NULL) {
> -		dprintk("exp_export: export of non-dev fs without fsid\n");
> +		trace_nfsd_check_export_need_fsid(inode, *flags);
>  		return -EINVAL;
>  	}
>  
>  	if (!exportfs_can_decode_fh(inode->i_sb->s_export_op)) {
> -		dprintk("exp_export: export of invalid fs type.\n");
> +		trace_nfsd_check_export_invalid_fstype(inode, *flags);
>  		return -EINVAL;
>  	}
>  
>  	if (!(inode->i_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDLES)) {
> -		dprintk("%s: fs does not provide stable filehandles!\n", __func__);
> +		trace_nfsd_check_export_no_stable_fh(inode, *flags);
>  		return -EINVAL;
>  	}
>  
>  	if (is_idmapped_mnt(path->mnt)) {
>  		dprintk("exp_export: export of idmapped mounts not yet supported.\n");
> +		trace_nfsd_check_export_idmapped(inode, *flags);
>  		return -EINVAL;
>  	}
>  
>  	if (inode->i_sb->s_export_op->flags & EXPORT_OP_NOSUBTREECHK &&
>  	    !(*flags & NFSEXP_NOSUBTREECHECK)) {
> -		dprintk("%s: %s does not support subtree checking!\n",
> -			__func__, inode->i_sb->s_type->name);
> +		trace_nfsd_check_export_subtree(inode, *flags);
>  		return -EINVAL;
>  	}
> +	trace_nfsd_check_export_success(inode, *flags);
>  	return 0;
>  }
>  
> diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
> index 5ae2a611e57f4b4e51a4d9eb6e0fccb66ad8d288..e3f5fe1181b605b34cb70d53f32739c3ef9b82f6 100644
> --- a/fs/nfsd/trace.h
> +++ b/fs/nfsd/trace.h
> @@ -339,6 +339,58 @@ DEFINE_EVENT_CONDITION(nfsd_fh_err_class, nfsd_##name,	\
>  DEFINE_NFSD_FH_ERR_EVENT(set_fh_dentry_badexport);
>  DEFINE_NFSD_FH_ERR_EVENT(set_fh_dentry_badhandle);
>  
> +#define show_export_flags(val)						\

Whacky. I thought we had one of these already, but I can't find one.


> +	__print_flags(val, "|",						\
> +		{ NFSEXP_READONLY,		"READONLY" },		\
> +		{ NFSEXP_INSECURE_PORT,		"INSECURE" },		\
> +		{ NFSEXP_ROOTSQUASH,		"ROOTSQUASH" },		\
> +		{ NFSEXP_ALLSQUASH,		"ALLSQUASH" },		\
> +		{ NFSEXP_ASYNC,			"ASYNC" },		\
> +		{ NFSEXP_GATHERED_WRITES,	"GATHERED_WRITES" },	\
> +		{ NFSEXP_NOREADDIRPLUS,		"NOREADDIRPLUS" },	\
> +		{ NFSEXP_SECURITY_LABEL,	"SECURITY_LABEL" },	\
> +		{ NFSEXP_NOHIDE,		"NOHIDE" },		\
> +		{ NFSEXP_NOSUBTREECHECK,	"NOSUBTREECHECK" },	\
> +		{ NFSEXP_NOAUTHNLM,		"NOAUTHNLM" },		\
> +		{ NFSEXP_MSNFS,			"MSNFS" },		\
> +		{ NFSEXP_FSID,			"FSID" },		\
> +		{ NFSEXP_CROSSMOUNT,		"CROSSMOUNT" },		\
> +		{ NFSEXP_NOACL,			"NOACL" },		\
> +		{ NFSEXP_V4ROOT,		"V4ROOT" },		\
> +		{ NFSEXP_PNFS,			"PNFS" })
> +
> +DECLARE_EVENT_CLASS(nfsd_check_export_class,
> +	TP_PROTO(const struct inode *inode,
> +		 int flags),
> +	TP_ARGS(inode, flags),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(ino_t, ino)
> +		__field(int, flags)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = inode->i_sb->s_dev;
> +		__entry->ino = inode->i_ino;
> +		__entry->flags = flags;
> +	),
> +	TP_printk("dev=%u:%u:%lu flags=%s",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, show_export_flags(__entry->flags))
> +)
> +
> +#define DEFINE_NFSD_CHECK_EXPORT_EVENT(name)			\
> +DEFINE_EVENT(nfsd_check_export_class, nfsd_check_export_##name,	\
> +	TP_PROTO(const struct inode *inode,			\
> +		 int flags),					\
> +	TP_ARGS(inode, flags))
> +
> +DEFINE_NFSD_CHECK_EXPORT_EVENT(need_fsid);
> +DEFINE_NFSD_CHECK_EXPORT_EVENT(invalid_fstype);
> +DEFINE_NFSD_CHECK_EXPORT_EVENT(no_stable_fh);
> +DEFINE_NFSD_CHECK_EXPORT_EVENT(idmapped);
> +DEFINE_NFSD_CHECK_EXPORT_EVENT(subtree);
> +DEFINE_NFSD_CHECK_EXPORT_EVENT(success);
> +
>  TRACE_EVENT(nfsd_exp_find_key,
>  	TP_PROTO(const struct svc_expkey *key,
>  		 int status),
> 

'Twould be nice to report the namespace or client address that
was making the failing request, but maybe that information is
not available in check_export.

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>


-- 
Chuck Lever

