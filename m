Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 278C5D29DD3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 06:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822BC6B008C; Tue, 13 Jan 2026 01:19:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BD56B0092; Tue, 13 Jan 2026 01:19:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5930C6B0093; Tue, 13 Jan 2026 01:19:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490806B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:19:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1A721ACBC6
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:19:21 +0000 (UTC)
X-FDA: 84325938522.09.0EA8F06
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B09920009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:19:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kYuomkkT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X8MiVuvc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768285158; a=rsa-sha256;
	cv=pass;
	b=yLTxKIRA0ywgDBz1XzSmQG+/kDqEIm/P1C2T3c0UA/890HpYUtkSoBVn+al21o3xGdCOqU
	u5Ea3Dz0OEAVD7/8sDsULBSHHTvfkJZAtZvW4SotaUFXN/tFnnPa8g5MCPrjnJsQJY7kCf
	le56p2xhM7Sz1C4oeX5mdPJ5epriGO8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kYuomkkT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X8MiVuvc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768285158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNCMD7XTyY+Ttx/OOdUNP0BUMAL+CtGKiph4AFz2DHk=;
	b=P3XQ9pG9KfoxkhqDRdod0dDrP+GZUoTvWNrT18JQWeO7utOeWQ8gJ0C4Se1ORaSTucROTB
	60nOEoxWbtAkvPM9kt7msZQKdLKPPiCViVh8247BXhqQjJo2ez8zwKvnvE1BvJclQXL8Hz
	ZzeJEScEOjZ9vCiP+rvGhA92wL/kaYg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1gSui2753123;
	Tue, 13 Jan 2026 06:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aNCMD7XTyY+Ttx/OOdUNP0BUMAL+CtGKiph4AFz2DHk=; b=
	kYuomkkTRl+ZfXfUfOTB9KoF5wHlOo2dssJ6QPYE/+g1kKJVayo8XCFq56ld+Sif
	l9UWj/piXBPuRhYgV66vYe5YyUGA8s85eMlNodKo26L7L/8YwZPj4W+vZiXTB6+/
	EQH26SLt1cS8dNL9b5q+gDWAUjjRbT5SObR6V71zShxfilNPp737ewTr2Ei3ohk4
	b0ntgCBFoT3aI2MVaKnm04PTrtTy1MFPXMrQ7am0Vtx+Tshk+RBLo8dp8nwAFIpr
	1L+IAOMNm2A6RRs6Lr6n/83uH8eBcBJaIUdwuI4oVfqODmZYK7AkEABR5M6LGkyE
	e4B7+aH1r7ibfV3gFj7Dqw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgjwnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 06:19:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60D6Ivcn003899;
	Tue, 13 Jan 2026 06:19:06 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd78b1ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 06:19:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sP+1FtFdfK0NMLmTOIg7BzdYtHwOnC7Q7elntjbT/UwXekSjF1kY5VKVEzEK1Ui5On4/l009xfMkT8O6Ou9JKb10/oMCnf+6HIChb+jSICb0b/uWVIqnPbA//9+AapZsiQZ3EvqLqNqfBLkSscKaKHXTEmJFAzPDT3Uh6QPHO/wSXb2PWRWwQ8AQ4xN34LRXO3EaExKarG1ZjfPbaHVSSYboNdKMyst0a0ucHXNjaTSkOOHa+FmgRtmWBxlSH5WSt7x5BkOWudIxFIyWS/ZLzcZ+Fl55w2pdOWIDue3nOlF9vYSndRN7gvhU1h/JD8y8ZZ4NG26TCQttdYE+Nr0E7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNCMD7XTyY+Ttx/OOdUNP0BUMAL+CtGKiph4AFz2DHk=;
 b=MErWAu2HR2/Ba/VJnWKzu0B3OTPfDxE6VOYsvHfCdPH+Ja2vznvqzz9E5Jrnh8XouB9I+oTKXltXh2DcnYVWnaXtDY8xylgrBhINT7+jMG23QSBZpPOKpnC9OC04J9a36zHPXXHZ2Vnrk7I2lHXHGiPt13Br5bTtHs8Yf08ISWg+yfRrTg6tDaDXruQU8w1DQQOhP/hfMHurPy4wBXBfE+I/vuuMaUBG61V1oZHyWU4Jad+bYS0sdkpg9XPD8MX9aAWVcwGD+TnAGDP9NT2Sg02vFEh+nCfpwldYIQAYj7MOUqVIYcMmqrXuSba18Acdsj4dz0rthqaBnvvOKZ1Bnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNCMD7XTyY+Ttx/OOdUNP0BUMAL+CtGKiph4AFz2DHk=;
 b=X8MiVuvcMRDgmieZLijKHTLH2wGzHENwmp4RRB1wgSIrzFLECElDUhL9ruvFZww6pBTkRFDdMQroczkVMHXTgMAwnfjg5/M+QcI9xqOjzZw7Y97Q8UPyunAZsKov3PBLKM2rIFZ8l72AdNK2iK2Cce34uxSADyAPIHx+ewefjak=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 06:19:03 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 06:19:03 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        hao.li@linux.dev
Subject: [PATCH V6 3/9] ext4: specify the free pointer offset for ext4_inode_cache
Date: Tue, 13 Jan 2026 15:18:39 +0900
Message-ID: <20260113061845.159790-4-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260113061845.159790-1-harry.yoo@oracle.com>
References: <20260113061845.159790-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0228.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5622:EE_
X-MS-Office365-Filtering-Correlation-Id: 49cd9cf8-3e36-49c7-e658-08de526ba5e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9SseDM8z3naYjuMkdigRrPPT1ZcNeRm1OVWt7JWhvdx9REA2WmxlTQVIiagU?=
 =?us-ascii?Q?0PzC1qkgwvXny3oxDixJ4d6B4WAf5MM7UWMAxEu9IY/mmMgRcRKzQdbkkHaV?=
 =?us-ascii?Q?cXXj6gC/GOzmAuJqjZtRzl9Nz7PlnekCgTxD8Kuppo5OmP7BuOluno5v2wYh?=
 =?us-ascii?Q?Zdct8b9kGZ1PopevdY7Bqs113tX7SQnSjLQDYWi4tGXfI+gI4NbplmZuC8Vr?=
 =?us-ascii?Q?8O/evpbIraizmhhBPrVOwYLHz0CxX8ooEmVjXRm69bS7q/0odwLGDD5lH23s?=
 =?us-ascii?Q?cvSTZVTcxKY/NDAhLxQL/9i9LxqDRXD/ffvJAq5WaaIOq7rznhVgqIoZ7/HU?=
 =?us-ascii?Q?Vd1DFvkM6qX8o1Lz6WVYP1c1YnzwYG8f/rZVVh9gtetHzrqGFo4g28UWMm83?=
 =?us-ascii?Q?sLWToYdLVG9cejXU3xI/wxNaFEHjqtoxdwKNDxevA8VCJUPMeLlmKw0h6CTX?=
 =?us-ascii?Q?ux4bjnhTcWXj9Q6HJGBTlojKHzGYUDTi/op9hUYtYD2p/TgSaqhGs+Vwldtm?=
 =?us-ascii?Q?H6CeUhfcn46PkMKS0OYawNNYTD6VopLJJ6rK0AC/IOyb92O3QaaKeg/qGVd0?=
 =?us-ascii?Q?fVHBM+rTa386MiqneTVbtE3s0pHHQ7hDjqyOxqN5jHZmokYWBLm6YMZ9yWfg?=
 =?us-ascii?Q?gk1ziwqI8LeXI2NNj1UDdVTbv2TSeVAwti4YVMnwrh/LWY238EI78zCRVtmU?=
 =?us-ascii?Q?CWOPGCCawG6XNZa2hK++k0KFMNHfqRrIT5IBrW3l2YEcQOk7tF+h986H+CHC?=
 =?us-ascii?Q?OsOeZZzglHLUNhwDPHVPOd0wk3AzJg4zvX0m6JsuLS3vPbI4I/vlwXPDhPqA?=
 =?us-ascii?Q?vm5ZpofNJI8EcEX8qeevpZYp5qPbaetLZUV5akKj0NMzKn0JIfG+8pqqJXUc?=
 =?us-ascii?Q?afk0pGnNKl3CI/6sbSF+qJR9vTFwGSNKIBkYm0q3kNhweJqzGSNVDj4NoCjt?=
 =?us-ascii?Q?GgKMVEQ2AnS+criAlPlqF+yliGguVV35x9n19/5/zNNcUD0ACZliwB23Cwzk?=
 =?us-ascii?Q?J4d8b2heYHtvkiORkaEmO4LpdzDFpCIRDPgMO5wI0MCLo+1vNyZq6rAapFTO?=
 =?us-ascii?Q?5bQCvJYslATo7b04mAGUvLL9ygTZGCN+h7x/EcjlKFlb1PSyJPVQ98fWTNFz?=
 =?us-ascii?Q?fsW4J1evAA0G+DPXMYvIlC2pGoN8CzbBYtbr8EwDp/UL+EOlkifm4xLhxRqL?=
 =?us-ascii?Q?76qYMxr6/MEhMFUasRMaOxaPkL7fhZv0boGzn3/5nl6zxnDSV2pGPs0AwlkK?=
 =?us-ascii?Q?siDiIP1igvP2wClvPKK4NXxe7yLRxIPzMQVDAd2kIL0CBwSYYWDAKS9zu4bQ?=
 =?us-ascii?Q?DlJ+PkESRErmFmzavB18W8SqCLOK5m5mFU5tC18ZzN8vD7+YZ7gqWUs9CMse?=
 =?us-ascii?Q?u6IY6jZTi8qiAKlxP397rWGKh8myKDuveFrCt0S8ZVLw8vMJN4kH0sle+ACc?=
 =?us-ascii?Q?HFtJfYt4PI2p8e/eQtHFTfvcRSVz3BvV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JoZ6kv3ckXJSz/CrH/TYDGDSMiCf1zlS7IZi+Sas7BcNlvdpgPTCT3xtZo6g?=
 =?us-ascii?Q?EEALNppecS/E7joiwjsRVNciMaj/XQoGNufbKESYR63nANZ0F/E7UleEMLVL?=
 =?us-ascii?Q?HragTLroLHYMOnYnppqqS8tvcUCv3Dvv/lo3HuCo0pZdBqaENnoaxxSgftp/?=
 =?us-ascii?Q?J5ViaKhbBzDUg1vUM175AucGzAj1x/m8RXBAlDyNj1bp07/BNb0oi9+Yl3Um?=
 =?us-ascii?Q?TxWfy6Qx9MkJz0YR08inIpckGXDtc9KOIoIGngz8pUGgJaJsMMp8WQlOA82I?=
 =?us-ascii?Q?OUNnYLUY3xa86Q+cFYfQo8OaSQ0PD7yTzDuFXIV+i2c2spZucxJfM8HRAcVZ?=
 =?us-ascii?Q?lcWjydfU0fCDQGT/k22HYOEfuPLbligVXFjQGBU7QNs7iMR4zOsYeLEwrs7o?=
 =?us-ascii?Q?tzMbmyy3fcXmVECP2h3IZYOmzuoqpLtkP/Ep9+UbsOBS6yRlYg76ieg+2vD1?=
 =?us-ascii?Q?BB9JcRCfdzUX0ISFA8e0jiad5QwxCspfEUlOaKq+57DrXGzPdP2LwQ91rK1c?=
 =?us-ascii?Q?HOManL+inLsolLCIHwVHE1851ICWdFA2tVehWIVHVgh1S+Hb+sq6tSY6UocX?=
 =?us-ascii?Q?7rME1mC+wiRFbAPUsbCbcjYA3FPY4D/Bf639Lg+3nzu60oOtKaYGYZ9D/7cB?=
 =?us-ascii?Q?qp5yI3tn8+FkFXA0MdvIt+nuxpqP5RF0CZ4HsM4nIkKpQ2HbU1nxUDSPyPot?=
 =?us-ascii?Q?bbaqdBIw7VHxgbMi3Kl8PvLraIgw8Mnpd57tIbmjYiSPTQXtKXki/3ro3niU?=
 =?us-ascii?Q?zcIRvmIwBHXMMcW2OUy+BTnrhp1A6fcvj/6yW2hd15aDmba4miyVbVYPqNRl?=
 =?us-ascii?Q?RntGg50TPBwkWoPN4GIlXP7rI5iPNv3r5cg4DoXpCgKnx33cnI+x34xyLkM7?=
 =?us-ascii?Q?6PCuO01Wjl1vlJcoyrYc7yZf9emfnPK8yHf8hxIlDHA6pkhpZmQC3VUTNiTR?=
 =?us-ascii?Q?A/q1xjYmfYr6BYsq3MViE5I569cbWjnwX9LpJuidHQys9v8/4Tvyr5amEe6L?=
 =?us-ascii?Q?gbo36eKmg/6Te81q7DquXKGVFI+CPlzvKOaqDzdYuiC0xUXF7Zft0a/aX4Ab?=
 =?us-ascii?Q?FrYNchbYBKIAkp3yAVrDUsB3V1YwUFKlZ3bubGhUrhLjOU3s6dooN/3espLd?=
 =?us-ascii?Q?cwxR7pc6biDao6EhEcoYn2g/vgbNwr6bjipa2pxABFePXCkIfkwUYLwuwP53?=
 =?us-ascii?Q?I8UpQR+Nw5DIklZ/FJc5DxcxIgfN5MYIHwP8J9iHqiDzhX41lH07AGu2lz+U?=
 =?us-ascii?Q?jNyI3kz8mOpya0STTpuQ6kW9b/OnuAnrGtkXP6ICo02ECLWIr2yIDhfQe8sf?=
 =?us-ascii?Q?y5fizDHUvbdy9sO8Z+hQ8XWjUNEBQ5BLTG8OGJiIJebvy/w3rNEQrS88NhQk?=
 =?us-ascii?Q?ymoRzer5SmV3suT1zLjG5jbaWZYh809G5RxmhdwPo497LOsTXlso1lj9kAaD?=
 =?us-ascii?Q?PVtnsw08DTg4B2kMUUKVAHLpt390b9dvfP2OzGOAVLiL7SUQfiYFjcDc+AEF?=
 =?us-ascii?Q?tkfXg7LE3XOKItkTm0fkbgwAnEnmtFeqrbarwCX+RSG0BnEemQAt4MKhKhYD?=
 =?us-ascii?Q?Xf5+4CNqSK4czdMm4MRN7T/HTn5oxws00KjmWBLLptUZOangbSMwNfG8JzWp?=
 =?us-ascii?Q?jO5tAAo10dbW8jx4uMH11lJEkACmOWY87tcG9A3rTtZZG9hoOi2cO8lPU7l8?=
 =?us-ascii?Q?e2NbvwLfEDkwRwI4eSSgGFvKH9Nn4+zfr8WXSi8FnqRIabCbjmSNVI/KEZxT?=
 =?us-ascii?Q?Bz5xzckhHQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qV97jCMP05XWv6RPF4OFMzQiiPi+DWhqlhS3S2WimMxRMvCyoA2ghUl/3rrPU+9uHRhap5Jb233q2XtHLIuWN0NtwwsthttbHVXqbbPJCQbEV3ICNRO8YfCxsdHpNJnpsYmnyx0uG/gQPpEqPMxhb5T3ng2R8GFKrlS324lnu0q09T4LCRYrkslpNs+QkHqli4hveU0ynmEKjaO5v5UqRz4INa2le/CD+NY1V+f0008/RjLRSpmC0xdCkg8j1xdHExndgTSGQTglt08RPVbYPNrwbIOc7eU7ptgOoTvmotPVSQ8kiV1x/eOP1hx6OLVXDidwodxPnBT7ZOynDI6uwk0WS9SNwAN7bZl0wtfS4pRlMZH6tHEsGxs4jMogAXMU7YoyUpQa04Bl4G+ix4Y+cJKG68ybRMRyyZaOaTIVxlFvdjsIjTFrBxgXXB/1H5jgwowsrDr7Kmxee3BoMygxz5+LK6FCEWSxl5e5VMGlZvzNKGgJFGWdexp75qJIktX9QsOoWkYpNJy37t60VH1x4G/x6I1dXw6O9P+gXjMhbQfQBBECl4LMvoeKnnxt5C5VUbHnd0TFJD0/5AmjwcGcABjuy1jFSSpjmPOJiVeh+Y0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49cd9cf8-3e36-49c7-e658-08de526ba5e8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 06:19:03.4260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9t3sICjm8KWESDdUvngUBQVYlF/motf9aq9lBYm4r2OOQdx+V6ae88gEbXVCXAXcmmZ8rpUohZSIbcLNgE8CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130050
X-Proofpoint-GUID: 4aZDj83vmfeDJZTrtogyiU6_e1umrXqT
X-Proofpoint-ORIG-GUID: 4aZDj83vmfeDJZTrtogyiU6_e1umrXqT
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=6965e3da cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=LnKeQQhI64-Y42c24gcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA1MCBTYWx0ZWRfX0ZxFgOix5guZ
 VGuj6NSY4oL0rSVtomY6nFCds6NnAEWKmenYeQX3c9naQ+QwxqcpeQVbRgDoydOm54f1CurW4/D
 EOqWSI7iBasFDFm0WCL/3ahxJ3ebpPwgvhqLf8Aoicz8JWU01Y3mLZP3nmW7ym61NB3FrEGShP0
 egTniPgu9gNrPYAfI2hIbE+bfIa8oVLkQxlqFgk7bipWQl03OenQOeO+GX7NihvyZ3sCBrJ9PG8
 CVIVM6lJW8kHqLN4nnH2aMq1YzrjccGH/ExDgd5PDvIJAcCNwT2BR5APFXKnrj6+0UY4FZ2vyQf
 qVoeyDVsdoGPvrPVg4MeEcQ9obzbAROPZtpve3SwVEzu2HZB35iOPtqifJHibodOiKOZPSMbRp1
 +us/AEV6aY78uI19r5qLkreVjfkmp9s3pmukib9sz9TI4jEGu9Mg5FCzBvmEkXjmx9swtsdKcmb
 mf+KsM694eOFWEuHbnw==
X-Rspam-User: 
X-Stat-Signature: b3uotox45ne4qw1rr1e1u65d4cc8r4um
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B09920009
X-HE-Tag: 1768285158-703799
X-HE-Meta: U2FsdGVkX1/ELrdrmZ9drmzOWEExi+0HgrTq91+i2VzR5+tNxChrDapAQSSQhYQL38XHp6KntgwO68pBaOmBcE+S+y40GLmuOqkGqsNw5buL2jbnHTJAf1oO+flPlI6VbkhkMl6mdd7zarF9BLLyLqvyZj4q80m5CegCR7fQnd0f2DPfjPCqE3uuQKChTKdaCYmfBtQK6ToVBbzIRLzvFB1E1ZOv/4UhXNgOaS/wQSrlkXMa9uOippQAund5PE3rtS10ZnwD0qY+ChaLyIAcQ4yPSKyNDCViito/T9/9AV5jLG6zaBF7SHiONo2XBUqIhImbd1GNmymIRNVD3HfhsCrvUvB+axJshkZio5Sc/F0lzef7yVgZB5HJF/sNNJvq8vHKtpoMyhQ2MzS969bSWK0HGci3W57B7gCqqFXTfl9oUjtj5w1MQ7BYT4i+ksyR2+00TQ2ZmasXTSvLuKg/j+6x4cROibY6pNoAV7blBtzoC4cwNQkWVbTtA3BziOgEG4ud2nmCQbOdwxZheqxfYiy1DyRDlkzGgnumXRV70BCdbNbKanm57Dt7Ix6Crzl4n8LqIeBE8uwRECC86r7E4i0tUHx32zuQcc0rp/bcvdeCyRCD+7SmklMb/a+i+HUT44CG89S0z5dd5fLAMtzpPIEL5ZTG4PtNpBktg+UEg5xmbPsyLQMWgFKqfd2gpLRP3bs1Sy2SKWylcwUO+fsBi7myEj2GoYDcMBatmUMUWR3ORJNotC/anH8hBWEKZhCOB6kBrP86xotYHGdbRGYPaOvaE/9N+hIrz64zjxvum+OGuDTOn6nzJCfEg1CIUBNZKQWekI9yjzsnBlzmyzcgrSfMT0rcA7oWdnMtDYaAjWHAKBwFqoW7cq6p5TiBpVuba96tXZWle0XdM4iMx7AiRcSWwvXM32wM5H5c9EH57QJ12s8Tg2otivfdkXIo1j0ZxCIvdOFH3lj2pJJzzzi
 G1eTJTYe
 gsJMYiTys6zoL5pf+jmYbSJYuwxN2sTZT9gKvpPf/lz7kd8uKd41uVib3qxywlWrtr0w+jP85e+Jmjq76Jcd9qe0aVzh73utMSLSf9rhZv9rxyDXAJGyJRybbA0iXH2lH3LCaUmc3EYFK27T5ySRnOIZHTsgJrkR6OeDVM5PpARkdxTqtERJSvnbxcTvDmEumKZ6jdkjtsx8iEUMykG4N9XzU+F02lKvjO/0IeV1ytS/9t8ysC82Kc1L6xw+++2lKp80U/wdNAAVJD7JACUC5ipeM186Cqe1hFl2mDeP8Qi7+bCtm7t82fPwJLGnHA5OEaso/9gEFzUyop/EJ7CpaK71hllM3heEIpSfcahjIiUBjzSt5FXqJon28Qll1zaRH5FOGApWK73TWL5No4VYpnlM+LyKUbZ9o7NrOCoaITqdY28Fa+G8rUapA0NwdqpAPf0+xZRr03RmEqAiP77Ibo0guicYaVauY4UZw0WlD36brTwUHuZ+1xSMC3K8/d4mpUjDQELubLm9Q60r7JbKt+on2bW2CEnL1gv6+/o4vNwIN1k+XIFOj2J8ly4gDb6cxeSw8/4a6pLszp4oZAJadsfoto2cNAfY8qPm6pxLtKkx83eSNwFkmGKQmIVsR7obCsWsnmFfrQR6qx+/AKi+j4KL3PSpSGvnyoXSObxu0eNUJ0XIQjw6FioilThtrjbO4ypjjiocgDP9czJuHR1ZQnwwTV/vISy4umiIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ext4_inode_cache to use the kmem_cache_args interface and
specify a free pointer offset.

Since ext4_inode_cache uses a constructor, the free pointer would be
placed after the object to prevent overwriting fields used by the
constructor.

However, some fields such as ->i_flags are not used by the constructor
and can safely be repurposed for the free pointer.

Specify the free pointer offset at i_flags to reduce the object size.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 fs/ext4/super.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87205660c5d0..6f1c2c497871 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1491,12 +1491,19 @@ static void init_once(void *foo)
 
 static int __init init_inodecache(void)
 {
-	ext4_inode_cachep = kmem_cache_create_usercopy("ext4_inode_cache",
-				sizeof(struct ext4_inode_info), 0,
-				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT,
-				offsetof(struct ext4_inode_info, i_data),
-				sizeof_field(struct ext4_inode_info, i_data),
-				init_once);
+	struct kmem_cache_args args = {
+		.useroffset = offsetof(struct ext4_inode_info, i_data),
+		.usersize = sizeof_field(struct ext4_inode_info, i_data),
+		.use_freeptr_offset = true,
+		.freeptr_offset = offsetof(struct ext4_inode_info, i_flags),
+		.ctor = init_once,
+	};
+
+	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
+				sizeof(struct ext4_inode_info),
+				&args,
+				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT);
+
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
-- 
2.43.0


