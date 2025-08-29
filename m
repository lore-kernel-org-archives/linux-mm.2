Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C46CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CED98E0006; Fri, 29 Aug 2025 06:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57EAA8E0001; Fri, 29 Aug 2025 06:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8288E0006; Fri, 29 Aug 2025 06:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23B5D8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:00:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B34BF13A572
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:00:52 +0000 (UTC)
X-FDA: 83829351144.02.E0CF452
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 56BDD2000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:00:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AJ6GSsKD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uLRPui0B;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756461649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VbYIF5kRR8Psauu+U5/+9IUdCHJo3gmUsxRjMkuDig=;
	b=PB4S21SjWXuTL5hBpl4v69/DvEBaiM52RLxnBLseeDFKYrnh7rmWSTohgjlcuGOCbNY0Fk
	bSys/0/V8EvDLZfqn5XS09+NNJfMK9QzYD6CyvzW9sqQi46avQpMei2RKkPCUVlyeTN0Vg
	jdwEi8sfouD8+pw2Xi+4HcxxIwW0MX8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AJ6GSsKD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uLRPui0B;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756461649; a=rsa-sha256;
	cv=pass;
	b=1wWR6OU0RC+cv9N+WtAPePXX7HgU2XOo+zKGPLVTWvhuul9w+CukeS+HEOzfKNqe1byVaN
	W4Sve5mMNiNhxMTzVOC2mCLYNc+UxNwz+XMJ4GE2ids1nkI27U1TsiotVFfyySOkRbqa4U
	4AQHZa0QLJVCgYAVbbiOI4zGCdHDPco=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57T8485s027629;
	Fri, 29 Aug 2025 10:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8VbYIF5kRR8Psauu+U
	5/+9IUdCHJo3gmUsxRjMkuDig=; b=AJ6GSsKD2UagrZRhTEzdNI0OsnKu/R+405
	M+PrsyeawjnCNRM+Gl1UVoGayR6fp/iXJMj+E0V0qZPk5WkM8X19IV/MLbL+E3br
	dtn56pWlbqOGHP+cCguUCMHAFj9vAVC4CywVOHFsaggQ4JpAzLZ8Gr79e3rl54Uw
	RvgUfW9WzHzM0PSZ21rO6lKCxd3hbCkfYNABmLlp4FRon9XK3mlzSDpNvQm38n/5
	nEbyOZVHC6W/SHPtfR2Ip6QS0wSPpYgw3PynQNy226MhpROwKiPGo6NHZLknER1A
	r/y1YnSH9L5jX3kZtrcJYOBUjnSQEKLs5leMSutjRIOw4aCRPuLQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42ta243-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 10:00:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57T8XIuC012406;
	Fri, 29 Aug 2025 10:00:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cxe0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 10:00:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbXPbYgFtgSBk4z1O6b/LD6Io0vdk44z7u6E1wKgXy5L6uT0roba1Jx50JhGrJo302jMBebLG0+N/6ObYzri0dBD3gWOeklpXkFYUH+MAsV0hBZv2dWexMfXjyjpBKdtUCXjqhSb1Qw+4IpEEOXv3RIIVDDzIyAl6AZ4H7hPo+3bsz114NWfv6w4JdXv7VXtiEB9KvIHCAOsl3IBn/+ioHDxx2cQC5vEnMfoxH+QKBhyPusPav/Cfu0nw6fFvzmf9AMrmQDN3ZpmQHV5d7efXgl0j0hunuAz8OFciO9mgAeKi378yjL1I5CItiytsWzklRAkpd/K6CBEG2wPE4cQgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8VbYIF5kRR8Psauu+U5/+9IUdCHJo3gmUsxRjMkuDig=;
 b=PMLtwyCi4C2IT2Zo5QEmzvQzkXAaXRlmMCh0+f5wKARmJmgpVdYY7cI5bLwZYT7oFnN46cszhXdyRmbAg1qMfzEhG5WX1LJZXLYqE7Nf0k8DulvSjMqJDL/z55VXkEqrTgZSv4UgYCfZyRPIXyKo4BTOKCJZokX/kCeX2WZ+cu4avKBCYjwdwAr0fq+8mxNFGDSPZ27BTkROvLJkvIi6A9caTlryW+oAs7WAyIz8X4YH1WeyeIJ7M7z/xazSUQCe5pFeZB6zIyKGNbJLjWEs6DFnAPAe/ikot8NMvrhU5Ng0V0dYi2reLNfOgqn0T7IBgbRe+8xaGmPn1DS1aDlkPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VbYIF5kRR8Psauu+U5/+9IUdCHJo3gmUsxRjMkuDig=;
 b=uLRPui0B1+mXa+lT4/wbvpa0HQZ6St8xsjHlGix5lYvurcELvsofDMAzkP+2OwFWD/MOzqV5NWMBaU3DtWCj0tCQsUOtspeYwv2j+PQdzJuFTp7Vh1OGTJzg+5aX2M7d5RtzTLQE+sGktY9JRfOcOVcuW2DVXZyY5/zCLOXR/7Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5754.namprd10.prod.outlook.com (2603:10b6:510:148::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 29 Aug
 2025 10:00:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 10:00:30 +0000
Date: Fri, 29 Aug 2025 11:00:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        liam.howlett@oracle.com, surenb@google.com, liulu.liu@honor.com,
        feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <be5be19d-54eb-4fa6-a440-f0241da4c00b@lucifer.local>
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-3-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-3-zhongjinji@honor.com>
X-ClientProxiedBy: LO0P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cd460b1-f20f-408e-a4db-08dde6e2e31d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xLK6sYo/XH7ZC4iNWVbdaXc3KPYkdDIjRM8IHZxJRJj0DDQFFajtOZUbh08q?=
 =?us-ascii?Q?7gzvSJ8bI51380+jb/PeBQRYOz/asumHDLBJyLAaiRl8JxUcwMjTprdmio3Q?=
 =?us-ascii?Q?t3LnSihS9gSQxF4c8NvFTw2JF71c0VXzYxy0CHD3rjTwS2QTy0HHv9Jozq2c?=
 =?us-ascii?Q?I8YY2IS429bTBF9Yz8EOotNHaLa1fIsgRjMWg3bEpa050+rUN0hL3YoCEoxo?=
 =?us-ascii?Q?B0rJNTzhikLBvsUtTO+yN4Ry4q7sweGqA+Pv9wIo5T6NAQaDTSalJMNimArK?=
 =?us-ascii?Q?roAfFYHXqfNUjE32sD5lFi6sJdaq+rRct1UJzG5EFQYnfC55HXzGFao0Fp/w?=
 =?us-ascii?Q?swIIK+l9SmHObERhoX55fWO6J3QJk3ae0YJvGhHqYil2YE2hkpGDPFG/uMcm?=
 =?us-ascii?Q?wUpgldaILXVeoOpwIPBdWU4uhcST0HCgnqzAmJ/2NaoPM2lGjAutilxZ6uqf?=
 =?us-ascii?Q?eoazjnTAiaQFz8rrif4Vyil7qMZPoYxxlvIGTCr9f/Tfx9G47iAn3ensPH6z?=
 =?us-ascii?Q?IKksNHRnhN3/Q/sjVtM8WYM8r/9uZL6xO2vswoqoHD/J6FrFqoT4haQ+xrA4?=
 =?us-ascii?Q?lWha404R1PlJ+p5i4lBBT5HNqV8J7MqZoB54NUXN62vGi3PJIxtrDaBgdHSw?=
 =?us-ascii?Q?vpxPwMH0rEI7jjNyrKwIT0dJ9XFDUOaa8XH0z4zX0xfQpFeDhGpLKyWJIdd9?=
 =?us-ascii?Q?KLrfGx3rKI6i31lPcMDDHAV2qEJLF7868grI68RPg/8R/LNj+ByyxuZjrB8b?=
 =?us-ascii?Q?a1BBzXXy88C9oZuemRJ3l1svAVEV9whL1rzY/pPAnzYdK7spVeVlujJW8b4R?=
 =?us-ascii?Q?wPELXl7jVqQ+nljFsv9SFGoKxO2i7htlbb0so037r0frwd7WAY2tkiGxmHgt?=
 =?us-ascii?Q?RlVSsRgbx5asdLxdlLQ7UAfySwAcTCBabbUw8ipI7jIXsHKgK2O1LloTdgHC?=
 =?us-ascii?Q?qBgbJKrz/UDcCXtd8bn+jEvr/4DrI1b83J6TyyTsYpV5tymJf/V/7Qy4PNrr?=
 =?us-ascii?Q?DsBp/+XwFyDAUy3mqyJiFy14UBW+7CaNVzwCfm2BORnBFFjw3vtS/Qegefjh?=
 =?us-ascii?Q?hWDJADvCx/clt76hcyoAFayXXNFSW9bC9Z+fnfi3FU4j2c3ZnkQNG7BliOEo?=
 =?us-ascii?Q?tohqUqq/YRCDGmbcWLOEFboKuH7HCmI7sxzLxwhFq96ICpP+Xo1HDZDOkRTU?=
 =?us-ascii?Q?t8T8KWI3ta7WGYJK1Nfh5NAtFm1UB6zfhDtk2W2wrVH546mKbPUmr70din8j?=
 =?us-ascii?Q?0fnSB2l0bC6BMFevGWGP697JuKGCA1M+p6kESYW7heUXj8n8O+9ushMTjDqt?=
 =?us-ascii?Q?nKTHHyGX3Sr2tRX4D4fT9Tat4vcalTRSOnXx3cdK7hoEcSt+L8HZgqKkbo0j?=
 =?us-ascii?Q?bpzFSyvW7Gw6qD+E5Y94INIfwyWk0Mug3Yh1WJ1KKhKAnBn9JmNv+7AZrc0o?=
 =?us-ascii?Q?Y1FDwmo9gLA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lmjKMxIIVRIwwSSjaOiN7BicOEOTn9nyRs0ZhKdic5rKsoAFjGoxPV57mQck?=
 =?us-ascii?Q?myFJAgi97CSKNUfDN4bobrKrEXGWdNC+X5CMLo90kewXEQx9QPeVcuzm6WXz?=
 =?us-ascii?Q?E6jY6cBZvkkqScPrWWQekn4TzKJ7GNwMIPxLEXxCi4blE4Sw+RxgObb6Xwn3?=
 =?us-ascii?Q?fgWYQeWZfaOHcxqa/J7Z0CZz4+sqLuR4yUfzRh75JAMncoRb1h56PbyHmGKL?=
 =?us-ascii?Q?mUBCTtnMwbbYkaIc3zhoFX0leOk6He7FC4krbyyEO/ywCnU/1SJpCAQySsXz?=
 =?us-ascii?Q?PuLIgntR7g3YIaGcg30FP0bieJFKEarTLT04g1IkKTFhXqEAcdUe3TRiFjnP?=
 =?us-ascii?Q?OPINGbxdGCvEV+SpEaCCjJV3+AcF0ejDzjJKjN/z+/xJMcnXIKHo3eF7VnbV?=
 =?us-ascii?Q?zgnKx+qyOi2I/I6skUJUln47YAA6fBSPBpbaDjC3molWrCaxvGuJaKVT7vnG?=
 =?us-ascii?Q?zJJldZKTZIXnFw1XMZemhUolA49aLG338F+xlwK8dsottPJXpRfffJisZcBT?=
 =?us-ascii?Q?lL02yfw+vhCm9UuMkCkDjLhSXYo4DBmC1CPv4x1Yf24ILX9Y4K1TXr47+5FC?=
 =?us-ascii?Q?qa+TcZVjAh3YJIBG7PFyvNhf3qvm/r7fOSXiU0D7yyJeEqOjQjG9SE/PhRV0?=
 =?us-ascii?Q?WWEYZjJ5Z5e5JXjeKyPTET5tXjl3JbV5f471ggAtZ5GfKvPx4B5FGiWOhTBy?=
 =?us-ascii?Q?9OHwehkvXeqnJFk5+FhJG7xO/jTL6Fp50wB6QIRL3rfcNIplNMjWQrn12QPn?=
 =?us-ascii?Q?x63POo4Fl2vVPLYF+GDT1IIEdeUgm4X/3QEfKKdp8uESSGFvEw6qiQ3abJ2U?=
 =?us-ascii?Q?AqQXBq6ZjuBYMK4DkUaQ0y5NQ9846S8bu8vKIcdApJg/+eBjA79QYhZCqICH?=
 =?us-ascii?Q?WSnBcjBG+2XU63BUAr/SAUFd9vAPDqmWqcW1RLH8FmQZkvVz6inEbfdk3RQa?=
 =?us-ascii?Q?QPQDlVl3CutCokVtB60SjlPbzrdb2FRdVTZ52T11YpX19gBb3ylXzytFvlNI?=
 =?us-ascii?Q?xJj2VoeNcq3vRrVmJ1Tm6RLnsOoKCivTx/pQ00O7eHSaESHSndKC/kUhkmHR?=
 =?us-ascii?Q?2HQRfWodZE1SkuE6GKeLGnDpDcDe+rRJ8zS5Dd6IsUL/p2OTHKiP1etaBxrt?=
 =?us-ascii?Q?J8wcfte2tQ7gdNDHlkqhUCydn1krAjJ4uABTB+4RGoHYE5wcX+NiRACQXIpY?=
 =?us-ascii?Q?GD8O0t2Ik8Ee1IBS2W+8IX3r2XnRlon3sk18By701FV3YaSX7tuIkGGtIPA6?=
 =?us-ascii?Q?bLdwtBgAdkcNIDjgaPg6Yv4YbRiqZYDDaaFHRImQvtayh880fTInyaOsNqfQ?=
 =?us-ascii?Q?nQxO+i0vXVz5MTRRrNdUQOpN4a9mVdmbbyJDcIgcJjVi+d/yoONkGM8vdHKH?=
 =?us-ascii?Q?mlDV00EsQf7jxwwfiJlCnqvll7LcA6XVmWrURYSf9g47M9vlBVsh5ZsOZVNV?=
 =?us-ascii?Q?6KJlFYvATw4eMIPZwT2raDqjxNMjWgUC/6CjVQL9OyUlAkyjdirvszkRF3ZY?=
 =?us-ascii?Q?QmK8ZyVLQr+9rddnkM2jGXwaAFLryCN13GLNPslhOiszzTGKeXfvLIA8ktBF?=
 =?us-ascii?Q?ZLoMn4TQnMehQXa2jmkcvrWoThfphclI96C5kWi271m8ok0Yq9Ck6oPtiina?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A1rOxRd+6843vXyxbZGMpjvLTZT8u+1dNn4BZZZzerA6pnM4HaWAnujX0nm8Y3Z1G+GQ92/S6f7RgeCdbCFDJJ3I5eml3/AhZ4n3BvrYY7OX4ewXlFCD7k/+YIGXjTDzANI03QKFeYz9JJsMrqzTp8wBjb0DmqtrhNq1CzE/kis+3r7oORj/DBBhGZJuBQFOllkbluWjYt4UW+lNIBnTMOIYD7yosuM7XFhCm0QK3nM49HH52JJnbdn3I6VBM6A4lVhI1P3ObdRYMLmkb5d4ejjjifGSfxtO87Sw8MLhf1PQBA2F3AyeRcLu52oVXkE6E4KGJavM6zYzPtA5aACv1P0KskUfELi88Vbvt3ZtG9/26orGztx8PzoR2abzj15UrwnBxoG7u4Es+nB3YDpYDhb9Ui1rS0bph9gmMArxPNkNkactmfFeJwtqj3B6n+E+ZwQUE61U+jAGiSezz6jLFt0WGXYpdrTiIzFmKiWGxWUStXlQEpoztb+yk51vLfGPoYbtlR8kzDUxS1TYhFCKc7l3YjC9KX8O1ic27lnpCdfuCrQwy2JT5HHE7lOpgM/0GZyOAvUkknxCxTKu+YLwBCbWSwX8UiFmfXlC4MRRF2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd460b1-f20f-408e-a4db-08dde6e2e31d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 10:00:30.4399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvU//eWNLJv9ySvyvgVkoyRPrUKEsDsXkpMjTv5EoOyVzXGKqUkuChuemFFJ2rMNsdVSQW9VFJOiBxI2wkopVVohmgIu5PHEvUuHZMGT3xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX0Fmr9w8cFK1j
 Itlde6EcpKdA8G32fVZ52jgc6zTF6SeV3XpYZV/mKTlZqa9/brFUNiuydHmcMqboXs36x+GkqBN
 BnIYSoSny1sTKoi+f3svA4gn/maP1f3Fzj1Iu95N7MU7ixJx1GaObCEPyOIgPyoR0iYGvIWWM74
 i4zTQ5lIcfhpVwzCJV4xLV+10FC4D8Q/5+sVxc6Mq9tMQGDkqTU/pA3jwd7H9uC6F/tnzyh4/iv
 VgUVeZCmnihK5EKQccDOcMcRN9Wvwv51WFKB/eqddhjMqAJuon+L/COjJwidMVGURt2lrQiRZj2
 OyPqwTIl3YU3XfdyGue8I2elWVU+ahl/jcKv6DKO2x8qx9SIe1f6W/jpX37oUa9Q0xZJJbsxwgr
 6cEil/yCk+7KQFUGFfRFKlX95egY2w==
X-Proofpoint-ORIG-GUID: hZsfvCOEjS-eoIeqt3NY24VYXkWdtFJw
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b17a45 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CvlTB2HrAAAA:8 a=yPCof4ZbAAAA:8
 a=J_SxZE6CJ_X_S1rR0yAA:9 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: hZsfvCOEjS-eoIeqt3NY24VYXkWdtFJw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56BDD2000D
X-Stat-Signature: tsn4opef9rw4pijdehrs9a8xczgj91f9
X-Rspam-User: 
X-HE-Tag: 1756461649-497919
X-HE-Meta: U2FsdGVkX19t9W4uplnwdoHzphhZlZGSDESxYmk4hdvUsJ44BUYuTlxGDW1Adi1U4ZZGKEZWX1LEaIyxwn3SdNQ48ac1Sb87fhBl8jUZyFW8OYLW1Vqt9CCeThTfpwqoREb2dnZi+BGK5YQACS5r2h1dc3BhMI6/GsIJv5JEIaPBZTkBOYAiClDGnL5j2ySqKym/NAm4RgBE7lvoTPKXznDvlFfWOOOyEmRhAs30aQR9Xi5oKJvLLAh0sVoeuN27PAujqg+XngeKJzjtltsrtcRl624Rv52ZPf8SCQCtEWbIlVdxMkS5C5hQwxqMyNYIp9tZ75OjWTqIFlr88LiNvj42LG2fTEFHybgycJyQF2tJ/isgf+45G4uXfiaCVzRNrPIp2tGnpbD4idbUaq5/+QTHxDLT9dB7hTeSx/6yk/S+yryXnGYGjW6KMOgDp4voCsocboL/+J2tQNRfmhx5umw5wz6Qvuj7dlQpFt8UHgoIearUCOTnKX5USwnVfZVaVBvhW9NfsX6Prl/qLZ2+vD46YFxIfI+vkQdy/kVxqMlbHfAlRqPKT/ErNq0H9S2px7sh6T0SE+mGPPuq9taJdztXKkii3ay58MBTmtUxxX//UUSyxB43PAOvJzqZZXq6iQhHSyAo7VBAYimkyEobIlmETOV2VnusU82MuIhV3vDfEBn9NW9eIlbdL3j4JE+TYe69uJkgN/fTBG8dHNn2lY/DoB0MSoXsXC7Ho9vs+WmTv4iG9gO2+LUIswavCg5nPiwsyINELf6t6D0Ptc5OWkpa7TlZt9dx9sXIyGGmOBofItKyAdGD9kRob7rYYEnmBmsfEyy6i1ZLzDOlOUnn9S/GdMDiUI5Ch3pi/txua9HhtwIfz4J6MANYfhwT4c2QlsuBp3vVzSjwEYya4knUlrsLIbhRT2EqDzhN3Ata/9WccdiATDNfmGzpQxb7mJe8GoTuybzMVQfPJ/+8MzU
 5h55vUAd
 N1u3jGDOH4QSItQoejuE/FUdSMMcz6M8SdedUXnfxhhqpD01VUzBFrvEg6PdEhsmNtyOCLWWNiYbXSk2z5LXK2eBcGlCmxBmILNCTzJeTZD+Dj1yDcUxbHbaaNNNrerget/92MjLgALAIFpGi97qtpPItyLtYER4PPCU+3uzNu8OyWy4kHT7g44KaIYA0p0V5dNpJ+daHetxVa7YxRHEY1etSCKRG8sBtEkMrGgq0/RG4OEWa4vCZ2jqFmBYZgCMyqu1x9wXE2lRsEU+jtIsnhwfa7PeaVBtZIJ+hMxYUMEcbL0ELNYgxBcLGEmZIBC+6FzIST8iodhEO+1DubYww58gHTkbZlsBVVt01cYsB/45R05nINKF0EkzNXMTjgZuPUGzAcL7S3K9TYhI23PQO47710eXP+FAfL5qXuXjrMXM8xwAj1PCExIEZuhVR6vE/L09oCT7Yo8sp58AggnjbowLFyaWeq1OHhG/jsJSbYuFG1hJC0ZAHvm3odPu0iTJJA3nzm6DjqmCAZl22TYIXVINUhp/SIG5YNEyqhVShdZnbjh/g+HWj9SuUyEJvvwXYceruMxVBX67o3Wdt7WU6q+6/QkOXI94EwmW5KghcGxXEoaYJqRN2JFE0mbuWbqql+lz2+Bwi5eGz08IarBNmyDhyhEURErW8uBEzYaAX+9W0zrn3ia1GBa31eBrYofGxzn6nroEadje1SeKSLUCBWRu54C9veyfyoxsWKmGbfLe6NxrCMzQ9ycp5QEon/n6+Do3DXHvNpVysXj44jfu09qK5Db75RACD/oRQqHNageapujXVLQhsTPDMFJr+4y4ZcLIORmgmQ3QfIOVGCTnSaMXbi6YA/6aWQ+ORZp3gm/1MuqIJtdWN+YfzuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 02:55:50PM +0800, zhongjinji wrote:
> When a process is OOM killed without reaper delay, the oom reaper and the
> exit_mmap() thread likely run simultaneously. They traverse the vma's maple
> tree along the same path and may easily unmap the same vma, causing them to
> compete for the pte spinlock.
>
> When a process exits, exit_mmap() traverses the vma's maple tree from low
> to high addresses. To reduce the chance of unmapping the same vma
> simultaneously, the OOM reaper should traverse the vma's tree from high to
> low address.
>
> Reported-by: tianxiaobin <tianxiaobin@honor.com>
> Reported-by: fengbaopeng <fengbaopeng@honor.com>
>

Very nitty but weird gap here haha, not really worth any kind of fixup though
Andrew will take care.

> Signed-off-by: zhongjinji <zhongjinji@honor.com>

As far as I'm concerned this isn't too bad, doesn't really impact anything
negatively and fixes an issue, so while it's gross to have to do this, it LGTM
now you've addressed Liam's feedback.

So:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/oom_kill.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index a5e9074896a1..01665a666bf1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> -	VMA_ITERATOR(vmi, mm, 0);
> +	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
> @@ -526,7 +526,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	 */
>  	set_bit(MMF_UNSTABLE, &mm->flags);
>
> -	for_each_vma(vmi, vma) {
> +	/*
> +	 * When two tasks unmap the same vma at the same time, they may contend
> +	 * for the pte spinlock. To reduce the probability of unmapping the same vma
> +	 * as exit_mmap, the OOM reaper traverses the vma maple tree in reverse order.
> +	 */
> +	mas_for_each_rev(&mas, vma, 0) {
>  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>  			continue;
>
> --
> 2.17.1
>

