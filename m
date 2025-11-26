Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35733D11192
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0046B000A; Wed, 26 Nov 2025 14:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7C06B0023; Wed, 26 Nov 2025 14:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F206B00AF; Wed, 26 Nov 2025 14:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 564AD6B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:00:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FD1914072F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:00:24 +0000 (UTC)
X-FDA: 84153673968.02.27291B7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id A127EA0021
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:00:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jxASQpZO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wevdkZDw;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764183620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdLWCjSfRto3LZVeBaStPRtIoGq028dQ3hPD1GMnaQU=;
	b=gF5Kxt+UpCrJ+qnOhYyTHu+Nzy04enJVwSRvnzmPx98012jArtq10AWafDf8Xo4FUGwdGQ
	/qYAnOvK8oq538K56ORkUjrEYBJVQtiBn9XahJLb8ZJQS5k0HZcsloEMgtFLSnpxf6MY7U
	gn4hhFsdudkWnutF5UpZQV/I0+DXCck=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jxASQpZO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wevdkZDw;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764183620; a=rsa-sha256;
	cv=pass;
	b=wph7A/qdR8tS+fQJlJ5GceRQpXCx9o8gA+h/jlcsjV7f2ObHe572Nl+JW+6gUyuqWV3cKx
	4J/v7eOKQI2M1JxYycroP8GvY7SNd7RJrwYzkxbWQlvta65aalC7toK0smpgJ4g6eOMDnb
	kSYzrWz9MjLqGwKZUulC5dFqtBmatKg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQGHXmi2614589;
	Wed, 26 Nov 2025 19:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZdLWCjSfRto3LZVeBa
	StPRtIoGq028dQ3hPD1GMnaQU=; b=jxASQpZOKq7oIF5/Y7Knqs1tu2HW4hrrGa
	mfJVQePzjU9fuWPPjsKnAtb/NbQuOP0ieUX11WU1+ZCl1t5K31pIucIqXrv8UWRl
	5p3FzSu/5pf/BlAbqtsSNFm8zrM90KJum+HbgZFuFESKymROnG7CbGaU6Q152CQz
	mGRnZEUrwS0ZSauuD6QS9K9T6cChwf5WNKsa0b3cfHaeG2dPrgMvxjeCVo8VzzGW
	UR3n8x/t2Hy1McEvDabpJzZXGZ804miRLSkQ3frCkqMxMNO1XOlc0auXmcowPmBz
	TinKMBaegzBEG3PX0/WhHmb7re3+flWLHGRmrDuxh+zLYp+mhaKg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fkn8sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 19:00:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQHedNc032688;
	Wed, 26 Nov 2025 19:00:09 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011003.outbound.protection.outlook.com [52.101.62.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbc2ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 19:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LHGAooSY6efZHgHp0wI/VUCP55kN91ESO3p/cc4asl6mdgiOWZSmTjVQ++EOnaR6Mys29b4yZLiPw5lEAablSSxFe6WNnGvP4yaxfWvvriqN/VV1ytaLMTekcUN1Zdfl+hOT50EZPiUX8nmzlD5HFXbxufdeoANjCLW41VuaicKyYCWmTZWRnls7fbWe+s3Z5e9tSdXlssO5VsY3X2ktCcTi3vVCh2tv6WhnGeUDgBXDVW6YxTwRXOw3U0/LCHKVBrpPYh3zlBf8ymndUq2eaQF/VsyU11DDr90ppoDnnRhN8N8BcpCfV6QfvJ8FIWnF7dU2pPqB/+4W3tlEdj5Kpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdLWCjSfRto3LZVeBaStPRtIoGq028dQ3hPD1GMnaQU=;
 b=Hecn2XY6KWc+/+u65279XiDlXaq+YTXnLCqSz9mceAWHM1+RvpaZFBskJD8rLRGhhDE5RNIlaHA2YaQu9Z/w1Aqqnmbb7I+4HrKeQiItpObUhHp0HbE0dapHxhXkxvzo+a8LxfvV0IbdV+e5a7x2W3UfBl2o+JVwLmcoxP8QpPii/NiluWfVKGWRDB2vhY7T00POwmCesT8TVnAKESfsJYJDDegPFQg3fI647RJ2e3TY7nPDUlSYCGeFtWR/lN3VJ1Jze9ly5YEW9v8aFdM9bHJtQfEJSJ9JiwwDLkWLWtq4J4kndkNDtfDChzgepu3+7PC09+iRKVJ7MB4oLk0Wfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdLWCjSfRto3LZVeBaStPRtIoGq028dQ3hPD1GMnaQU=;
 b=wevdkZDwvC+RrIgAblzMWfBES5HEFswbdFtxmv49pCGxZ3pILruj3swJDuSUPng5jkiUNzelp8pVtqrm8jnWHUCkAZ6r3WZx1xT9CaKkFm17nDfFDX27W++RkM6bZMAWu0JWdh0M5lAi/KIJijD9HPORt+s+nKMJ02eYiAcQIQY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8395.namprd10.prod.outlook.com (2603:10b6:208:57f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 19:00:07 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 19:00:06 +0000
Date: Wed, 26 Nov 2025 19:00:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <24976124-d287-4ac1-96b0-97662f5d176b@lucifer.local>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <CAJuCfpHheus2oiv94r14afjVV00XZnfqHY0p+H8fxjxCSYjg9g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpHheus2oiv94r14afjVV00XZnfqHY0p+H8fxjxCSYjg9g@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0525.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8395:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bc22d2c-f760-42c1-0eb5-08de2d1e03c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QU1l1uKDstnzSAYOH5n7wd8e1ZxlJpdDAN4onotWlKtjeXJun2eU9MfGBD1Z?=
 =?us-ascii?Q?FTwekYzRY6BmwLhclj5GRUF9FHrbOLLW4gtH0XDUwveXDyTH1/bIzvgboL79?=
 =?us-ascii?Q?Veh/s1XK72Q3gNGyXvzHBBrdlq1FRNwKXuZ1AL6Y9u5I9IZJ+vlIWXR2dSZZ?=
 =?us-ascii?Q?RoxbjojuIYw9nZ0KDs+vHm6aNSDCD7Y4G6WZFaNGmApzo0pQTFk0woGXmTeW?=
 =?us-ascii?Q?9N6/9T+lHxFrTDqj5beq6Yj6G/VasU37Wqe7YTy9kSVFkKdimwc9BkXJbF2C?=
 =?us-ascii?Q?9vCOM3BWaeOqvFzHausmLTdfnuRE1TyJjw8klMG01xmPmr0nZHKnyTcm8DYD?=
 =?us-ascii?Q?ztizxyVLk1bNfFJH96nffmZWgmikiLUue4GdxUfrt91o6uhcNqDd3Oa2MQ0c?=
 =?us-ascii?Q?SiYoCUjFMlv8uzlbVkwqVPyfKEiIARaSDYs6+X6hcmp/34BtpROpGIggTxSp?=
 =?us-ascii?Q?tS/1rMUmd6J4l/Zb/JWP1ATLmde4ss/+lqoUb2Ih8+BBGt3p51qW6HmN1M/B?=
 =?us-ascii?Q?PPLd3GsNZKzisauUWukAEd+hOnum2tChPUtj893glQNSG7zImSWDHPRgct2n?=
 =?us-ascii?Q?AeldTdycWAG8kBmrif8gEDEvr6x+944j78Y+ApASFF92SZFq0o1eOxaaB4e4?=
 =?us-ascii?Q?+97R9JUpEJ09kFMh3BCRPBUdA3asuCB3uVOqIY0SGORCO0hlOVY9oQLE8hcE?=
 =?us-ascii?Q?fM4GdNuhj2lb3ulS/QTdeoqZ3W8j3DlUvWhd/85Cdbf1PftcOONpRQpSHWyD?=
 =?us-ascii?Q?6FsscYYmpWAEFHQd349zZ+V+c4MsmiSWHEnENwecFcPKNOVHwEqzl+CO5JVy?=
 =?us-ascii?Q?9G/d1O1v3MP57wyk4vwOo+HeWd99zcWD7DWjafCR/+daTM/COUdldzshAd4n?=
 =?us-ascii?Q?05BnBpaN5L+vcsBpNrKEluc1SQdp3pByisR7QyzDhrtwTZ5CoPV1y7xgredC?=
 =?us-ascii?Q?ZJDBqwXbA+B0NcKuu3J7UNDuAs/m/mBJiTvvoa/Xp8b//eCQIGCH+QR+1V/L?=
 =?us-ascii?Q?HgjAa1iERraU8NnctlZPiz4fyX9Ui9Nj2iMx87S+yTGqiq1Y+0vjmAMvg9b8?=
 =?us-ascii?Q?6H3HkrJNaOqe/6Qx9X2S8RZwtlMzwQPatZwCHoVCLeD58kFdLrD8q/OoV/Ue?=
 =?us-ascii?Q?xbvyRosBCzggRPJWaZgx4CZPOCY9SkPjRAP3xvW9GEza5jTst98ARhawQoBK?=
 =?us-ascii?Q?jEeai+hzQVXNWuukAgJNbOdJtBl0L2kNbpvRQTG45m8F/u6PaDvf7YtlrG5a?=
 =?us-ascii?Q?MdowhAFJE0tkbWLeiHGXyMT97/wOK7zfhTQT8P8oTDJPykbrBaNs+WEvVE+I?=
 =?us-ascii?Q?RuUct+FvRcthqui6/AG8Uf7w/GnUi9Jrb6uPEsXQR1n4hdPit8CWQEWIHDhd?=
 =?us-ascii?Q?tal4ZkAVH1o+s2emKC00cvHKf64BrOuw4TnAN+CYYCasvFXClNFilsy/elgk?=
 =?us-ascii?Q?VJdK/zUnfc3139InSXl5rqaK66o2eKMu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cvO5QFGeqr1lRGIFKTlQBNCpCi7Axme5bE96vUYYNhHKi3r6GIWo07nEuCCQ?=
 =?us-ascii?Q?jd+LzRo/PQ9KgaoedrI6zTTL0LGx+jua55+Jr8aVNUO9UPhKK/y954W64Hw9?=
 =?us-ascii?Q?v+FZy/RyOBhfj72LmobTMXFkYngS3JXrL9ouVHX33B2VhMCBrFjD7Jqo4A1c?=
 =?us-ascii?Q?NraTIIkODbgJyvnfrKgXpsRvy0s2bGoktke71CnDK5BoU1MPuP6spUih+BRL?=
 =?us-ascii?Q?wjj6z5DIkH9j/3JPsW5mBu+IynnfhCpGlPJSk7OvQAPqqbnesJh79FwECiUE?=
 =?us-ascii?Q?rG0b8xMxc6dXAoWaUW9VecWLnPvvp8cEu8Y99glzaM64DyYBQEs0sCF5AJva?=
 =?us-ascii?Q?fdG0hhIAzunfXfMBZ4v6AWuuiN8IEy1SFhYQBaDzIYlNWlK4jc6rCx2ZiOCZ?=
 =?us-ascii?Q?ki8Hq8SaG7mIbPVdtXYrH87v2jya8ju3R8ZKja4r1JqGIsEPNbUTNogxiud6?=
 =?us-ascii?Q?Xshfb99UzIM0iM4xJutpKVg3wl0DTQd124N/4/C99LsBRzF4Q+cqmUPhD4jC?=
 =?us-ascii?Q?dc0ceMJYgf8hkD4eKhfnfFMAqSFcyxVjI8E2f/fQBzq1HXWYmxxzjooqjZsN?=
 =?us-ascii?Q?p1SPQRN5QtIVgfihTLlxqIh5NF2almnb2aPYgMZpFdwkPB8U+cDkkCepRFMo?=
 =?us-ascii?Q?Koa+tVryB/vmZF8fYRf1f0mxVLcZjKh56Ut+AUGkXyfi+MuAdNCMg+6G7KOH?=
 =?us-ascii?Q?QVohKYWuMFmRsM2j+W8C1VltjGz5BHE4VUaJ/XrqoxTq5jn1RQciK8MHWBYy?=
 =?us-ascii?Q?0PJ4hT6DtCM587msH/Kvj9MFyFjk456mSNY3GxJnQqQKZy49yF4vDulwQrBV?=
 =?us-ascii?Q?tKYKXJLplavXsYeUf2D8JMWMDk9FEu4+RoBc0l49DokrG5eLniE1t1dCBPKk?=
 =?us-ascii?Q?WoujcdypOi9Cvd2YwFL386kwIdfuVH6Cak67+rpNEn6VeBIWITeQbGtYZ6rE?=
 =?us-ascii?Q?knFB70FS3Uu9D7e8oLjnTTaMsKeuyqrlPjPOtu2hMgsO20gYc3eql29FkDln?=
 =?us-ascii?Q?pM1Xfo+KvMfcFW9llwZ8Hj8PDpGQVlqXdVdKdmstgGhLctMW1OCZK2aglgw1?=
 =?us-ascii?Q?WJpjU8S1OXrLp7ELyCmADHbK1uD556TYPSQr/xlAP/1Jd+xUD8GD55+iaYrl?=
 =?us-ascii?Q?Jeh58AN7leb/pKLg1NRw2HefOeunk681MaBVzBdLt3mMjDtjDBFKyciJg1jk?=
 =?us-ascii?Q?JmA+xU2Op8Yb3b8qO80b423xO5sFKZFvVn6dswgP1s+QehsPB7A2axOA9RVQ?=
 =?us-ascii?Q?9cWJ9UvVIAQNJ4lMgyq4o18u4DzZxTW78TlHn/vAE3WWHgUfFMKrSS3hj7bU?=
 =?us-ascii?Q?dfI9GbUETpucqv1aHU27Muy0cz5OYWu3/UPUbXdRVwMT3CwDZe4qxMZuVVou?=
 =?us-ascii?Q?AUU1oDd9b31Egs3Api5gq7/IzAfBbGn6kYPBSQd9wFJ0ePZzEoFi3ihN61r7?=
 =?us-ascii?Q?HpEK84d0VIPiRyZNOY7RMUrkxkwpB++7QB3rsryH1mLjs6C4QLRe4u0azVWo?=
 =?us-ascii?Q?v9f1I57HsyPZQlRUjle6JfyzL5XJCMfiNgx5yBVD4njJHFWq4F1hSYeHUwQJ?=
 =?us-ascii?Q?pgjBBP4sKj4ZCQwwKtFhc5+vAm0G0hF565IBZccwGWIvmZBHHX7d0+XeLWLU?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XO2xQvSCs2EwNTjuIBdG6FPNElaNxLkfepujeG0WSknlHxn17KkvzOKpnncSKtm44IFtnd7uZvwHy8ixUu6bXzIseVqFKwFtM/RhTZAQEF6tPPESraSXdi9Z0a4zdIO3JBgT8Jq3PA69NKC1K0++MYcmjGJYpcV9/zuSLRepqLzwZORkL2FHoeerusS46jEs7dkIcX1wYRdYwYJ+qntB69WTJnE4Pc1g9eLxdkmLQhSk2VTy2SDmoxWEUSc/Rz9xrvRGAn5aqv4qzPKoR+aO+dMH70XydKJU8dppq/5z6J9tWd7/X1VJUjcEC5guDvgpo5RT0bbDp6n/C6i1yjXz/joA2QudiO/B9Qa431dRj9wrCkQ1O5OKB4K6FiLvYKHhw8uJVbTxDn3jgBHmrZ5jRNrmnAtiNB3q/7+u+i6WVyU58oAJ05rWnqlHFy21lALwEQwlPh3Sa39qt7uzBEzvgH564A9weFgqRxhjnQTpM5lHmbghSdzjeRIw9wCefnkvJIewf/6RRP6DxiGtnk1v1/0Bti+hhe3E8tzx+aM1BNF7lACIhP2yoOvlt/txEsAzA1GY2tcEYaH3JNHVUqHEBXeeq+hFTQqe5X+m6Wcd9FQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc22d2c-f760-42c1-0eb5-08de2d1e03c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:00:06.9324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IIpbJUsvvx2qfBkC5gKsjIK/QilhThA2jEgqqSZEYw3VnucUdosEUDCDuLAETPpdofvh5HyKLKYWEqd6zMaBxRE0jO9IXK4is6Bq5ji6vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=809
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260154
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=69274e3a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uNduKOJHOJhOkfLXUYEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE1NSBTYWx0ZWRfX7k3ixedb4vuh
 v+mlTXi71T5BRDzShFnu09L4qyfTzHuD3imcFm4nRiyxDDLjW097nA6TtpD614n7oCLwT21DTLi
 ISW2HAQsEz+8MyRAeS2i53uo4pldYTZ6umK+hz/QsiS3/R5v30BmSQjIO7to1DQ7FbB8PxRUvYG
 pFgzTl7s3FGRtTAuNQ8I0rarRL1lzgH/3CIsOCaIRtlvDojEMks2BfF7gGAv7ltRewtdQx4SC8k
 RtcdAABdsNyfsFSFCEaVY/Xs0oaCoYPBPCMvfD0k6VkrQ+TAXfqsMXXn1TmcbAbTop7WuuEoYS4
 kTkQjuvU4Ro9ZTB1G23L5tCsdy6fSCUn4c9GBMlsI/E3/hGJFYU598d0iHUuGz7UnirP+/CDwVp
 vTJof/H9befz2Rrv/aUGxmj1nwqWtA==
X-Proofpoint-ORIG-GUID: egIjClS1pHJr4T_rPna3iZxPxKM2TAH0
X-Proofpoint-GUID: egIjClS1pHJr4T_rPna3iZxPxKM2TAH0
X-Rspamd-Queue-Id: A127EA0021
X-Rspamd-Server: rspam02
X-Stat-Signature: ijj6t4yfqyiejen9iihgt6g5mqp5uuk8
X-Rspam-User: 
X-HE-Tag: 1764183620-613203
X-HE-Meta: U2FsdGVkX19riRmzMUKiAKUhV/EZugV7P96IylWsdxbEXF4+wEBGhXjTVCdLIBZs3qFtpbwXVlZDiQS+1H1+2OjnDSLO4EpKgurofwNerVUvd2f1TCoWLl9M2xA53M53w+47+8FRc/XRkdWiq4rFydXfhUGfK0bkHeoL065honYmZcTM4WiruQ+v1MENaEBJPGPIi6TOAS/p+BoUIIJAsvBSZCJl4UvzWrIWD3Joed9g0ViBoerQKpVqFiwYA9mr8gFSMXmKFpbvDuPIOTCxCRAHK7j63eTrKjSRNoJ9tOqizHcNI0OUcom+P3Sy35uayqTQx3Wx2tS9F1WPrbTo2ewyktZT5q9fPUpCpvblAo3Fbn9bNi+j8fSyWvaNGGSlFjX0PZsoHaltoRqpz5+adqAv284BJ7eZdwglUy9dRylAkJuobnB2kBiRcBFXGZBdMZsQk0sLjBzvwPVBGFWUssVtT3wbmdD/g27X5RAjOCvMTwTWZMwdoJcCAPcrcbTSyNjzmszcWqObwx8ImLHSDJl35gi6ba0KbMvphiMFol1rLF2D+YObdSKm8ABWsyUNSLHwVQ//aTEatsnqDFfwu8tV9HgnfAbbrwo9iM6G8FcfNNIDYYKKMOfk+/69eStvOlncw7sjTzbRKVIu6RTnsOdzb7pWP8bkK6dK+ecQinGIxYxOpI/Eqk3U5RL8aX8XZth4mqfbXFNfbu/p6JB66lDkmWPgHGcUPTlhAHUHU78++LajW77D08ifzQkvfuXeAgq6EKwTwjO1tY0FoH+m17iW2PLtcQy7GH35ixUrqvpKIktS4zSJZmrVxBj+KLDYYCDz3/qAy2f40q9HYg7uctKlepIk2yhRxUMVmzD6ahJy9LVOzpCDvw0ZERrvkOgJSQwPtCMnivZIkFyn3pm9OL0SpEK78KE+7lG7hcyzdoqq2Kh7h9Q/4LMjN8MeBxLA+pi9EhkaWK5IjdIJ7So
 993JwKrs
 aPHBNGjEYfuwGT0uMV2NxnjqJuLOGPs2RnW51PJ/gkhAJuo5C+YrjtutJZulJUMGamFxAIUpPeydWE7Uj8gB5x53n/S02ChD+fKNQBqSy3sZzJcC1kTIFGURGyWceDp7VJ4kdMbBKI+N9WLLP49zBTVOvLN4imLOY93uaSK8r2cBg1iPIR/y886SD5x4uK9T00cL7p4Av1c2/7TiRjP9WNI62MFMhQl5lhvgOG0FlDSddnT6YkyHK5NmukLdEwvexK+uYGJvu9MtAnBxCR9quTIxk9wbP35VOxdtcfmmiMC2C335PmhbhU0IfhdBIXgq6kOZNKozz78U+jxhnTMu/7Y3pH0kFv0nTtICYdMDyPkj25QeHUYGGSivITrugjvg39RO/T7Vzj+CiBU7H6oYIMXbN+X0gcMtS14wShc8EMQ38nmb0IJIcwEOWEGkwO5XyJxXcr+iZxXk80qLRDw+7Z7+Phi9WKUncy3ddGgkN/LIrYt94SJQL3Zkep/W2UC6d4h2Jv/iN0D3pbngyDFef+wGcPtIbNfeROpVxsu5MgoFb/J8l1535gv/c+DuEGlg42+/+D8a0ZNeJwKyYn5XKKAtMeeP3H59Yx4alzpqH7Zqsg/8SbXXo7fl1BlLvdqtnz0f14g9WGqAxayxFDKMGzSO+Ozp6gfx7HIXl83vFGtjRSBVpwUSPV7uMm3ks6SXXbcUqu2JMitnVAMnHfFU5UkZwDqNq5a6ierAV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:43:15PM +0000, Suren Baghdasaryan wrote:
> I agree with Matthew. Returning 0 here would work correctly even if
> vma_mark_detached() starts using TASK_INTERRUPTIBLE and 0 becomes
> possible. The comment also seems appropriate to me.

See my reply to Matthew. There's a lot of implicit knowledge that you
perhaps aren't aware you are assuming _everybody_ will just happen to be
aware of.

This is natural as the author-of-the-thing ;) I know I've missed things
I've happened to assume in my own series before - wood-for-the-trees etc.

The fact that 3 (or was it 4?) people missed this bug is a hint as to the
subtlety here. Let's just make life easier for ourselves by spelling things
out.

Thanks, Lorenzo

