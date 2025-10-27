Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB53CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6880D80028; Mon, 27 Oct 2025 05:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660378000A; Mon, 27 Oct 2025 05:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527CA80028; Mon, 27 Oct 2025 05:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8778000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:11:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0B6DC0570
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:11:47 +0000 (UTC)
X-FDA: 84043326654.30.5859165
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B5CF4000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:11:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=glyZgBo3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WvfT7GSP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761556304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+p2bZ5JOVzFlfB0y2/AJmzbKorj/+Al/dmO5ujwE9Dc=;
	b=wy5N+PJA/4onM4sJ/2FfhyPEIBxmZwXdJmFR3DnuXbbuAwUUpuzlMJOrJJHSeVkHi54tP8
	3slXHil86LQ95Z7FMmvGyolGytZoefhDbrXh8MR68X0+6SPvKtU7FPwcAHvCBWq4OPIN5B
	zfwI7diS8z/+PDtAhR4F2RhJbqWroLw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761556304; a=rsa-sha256;
	cv=pass;
	b=rzUsT+huvT814h+yzDL2rUcRQpN/LkLv57q1WVlAxlXT3Z/w9nGKDBBZt4mc+wI83Ik37a
	ZBfxoVFkpUTa7isYC6RbN6EeJ53LuZFIdTIwIA5pDYIkleMMM5dBIRXsd/axCSZDLMQBpR
	EnOp8wno4fu0OOZ7yOQq1OnC7VzLuvo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=glyZgBo3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WvfT7GSP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59R8gZ84015156;
	Mon, 27 Oct 2025 09:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+p2bZ5JOVzFlfB0y2/
	AJmzbKorj/+Al/dmO5ujwE9Dc=; b=glyZgBo3vVI+UPjK22EN6vpFf9oItuXEP/
	h0e1xg7pI7N0z+Oux+HBlVATsONL8J+1TwWtp2o0MJ+XnU6qq8JcYWbXPg0BbOjb
	qL3eHCPakmGT1mQgYRqCmSdPQrGNvzTHybnJhMPf9meXABK4zH9ZOLb5+VQY3Iys
	RkEmO7zt9XP0XaKcVoDXWoLs8xaY2sqNj7xPBCXIxaPZHgNWGHvgfTriaMzR/KVm
	Vjm9yUToGNCka/51/DRtswJZQ8+GDwzRprvDY0Wujco28FoBDHUuYOdRpNJoPd1G
	GN/ZelI73gRqKSpRE+uB7eXaQWTqBlNEEkF3w7VqxXmgqIleIECg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0n4yjxmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 09:11:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59R8Dbrn025790;
	Mon, 27 Oct 2025 09:11:36 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013061.outbound.protection.outlook.com [40.107.201.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n06s99t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 09:11:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzJ4n1YQAwNq9cpyx6SDWU1AfEOZlg8r/WsHbBvu2FyuYZV8y8mNlM0fDzgeGY5e/QzDbOYrnblCd2NR6ttW1T+NmMxUPLq6yOS7/vk9xp2RDnJ9pbMLdNK7wpIzL0XpPdRngM1+4iB3yfeytVY2wmjJur+WG7LCrtD0ECAiEErR6ZNIH7tDHvdNFEuFXsXcfzYhgdPONKlWTIFuUs6xi9mkbwVrARq7+27E9pAlm9VDSJo9ONMM0D1d9AG6fXH03Q//o4ESH/ck0QIbVYPaV58NDnPtGYmcjxpUGZUALvl0ywID7kVTW9iAZ9K6O948i81wnPpknpCDA3d+py8+WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+p2bZ5JOVzFlfB0y2/AJmzbKorj/+Al/dmO5ujwE9Dc=;
 b=EXFPJ7LchvVTwYkGbTQORCg94dGImwVWB4m/oH/iEyk9I0nhOFmJxrhaLpPwMSTrS9JiNxheS9oQt+gv7zqJgpfJiqeDZfo2NHowBQQM6O5LSlnNk3gku/ziHrxvggFfWoU62DLdRotGTlyzNevQCF3XE+xu9PyudRVoZP51G/b0sj6KKmuHik6+3Ui1LUIJVs96VgSaQC+Mx7w39/nKYhZ7AtBOKqXt9j+vQIwXkDsFzGMsjceayYdGdySj2Hu/txzo/745Dmy0lchML/b/wWaxClb92RIZAfGI92VinE+b/lxmm31k1cBGUoM4zXqwBpyXzBCgRpCsaxUf4UBeQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+p2bZ5JOVzFlfB0y2/AJmzbKorj/+Al/dmO5ujwE9Dc=;
 b=WvfT7GSPrD6jHBjoSh0sGOo/X33ZFDqMMIUDJSuB6u2vHMBPP8AJzu0RrDtdHU9tC7nN6DVs1FRM/7EWbkf7MAbzrtg3nlm7LquOrhxlAgGOp/1LnDUAHjxBB9P3tWYjuizk1+VEF1+OAAUZTHffLN2QFff3NLAJxmLHbTqHHYQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5590.namprd10.prod.outlook.com (2603:10b6:806:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 09:11:33 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 09:11:33 +0000
Date: Mon, 27 Oct 2025 18:11:26 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC 09/19] slab: add optimized sheaf refill from partial
 list
Message-ID: <aP83Phkqnf7PGGmL@hyeyoo>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-9-6ffa2c9941c0@suse.cz>
 <aP8dWDNiHVpAe7ak@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP8dWDNiHVpAe7ak@hyeyoo>
X-ClientProxiedBy: SEWP216CA0069.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5590:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a24a7dd-67e5-47e2-c7da-08de1538d2a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ohD2E/xXLw1bkWq4oDc/D32ccCFhyoSgovk2EfDNyc5rLgMcNX05Ur6aVvOr?=
 =?us-ascii?Q?x9vK2uQmgLM30ymOQ3KXmeFkg3VHrbskPDb9+zBcWe/3ATD/jF/GsOq+ustC?=
 =?us-ascii?Q?9t187XNRQ3Sf/SkNssA3gMcyO2nxVojB/Nk7vFPvGMP5rWjBNg9o2+NzPqEz?=
 =?us-ascii?Q?audKlDbg0komS2FInmYPANBJ+vYEUzvchQtIkcdgcVjZfn35TE+FmNWCv+WE?=
 =?us-ascii?Q?wHZnaLs2MXgvlwmXtqgl/7rdJ2kJFRySO13w8Jaic1DGfR0b5heMALwJoy9P?=
 =?us-ascii?Q?7yijLUe0jWBe8+XdgXYADkh59bU3DN38mcuYD12aCe9LIbW0KJOZnU53uxMV?=
 =?us-ascii?Q?DPZg2TqvN4S4MoJRlv24Y48LvVSVzWMPntrUSpKFPDBBbdogOqnrleWUsW//?=
 =?us-ascii?Q?1U5c+eX7tVDx3wf1xHlM73aogNTatSlcj87hTlQlfsaw5VNagMzYoO4dl54i?=
 =?us-ascii?Q?FDt1XTakBKD437kAJxgxzvc2wwOSMpz9lLqbGEDawRZhR9oogvodIgJ/xCYj?=
 =?us-ascii?Q?HY9nd/oajZnfPbvMAuso6lujjo3E8bqqnRaJbZzUVR/rGUJBxrVFPouANOGz?=
 =?us-ascii?Q?k301ISsnUjzfH4LDt35KwavXFswVZ0eFTXt9ldVWA0XryFqss2BvRyohA1YH?=
 =?us-ascii?Q?rD+hAVx5Db16xMSgWijOmmmhnjuzdHWavdkqvLRBAzNLz97NOWrmWzMeBYDg?=
 =?us-ascii?Q?n2a48pCDCbRqfIpIxo1WHszs5f396EUAoTt0b8LkfIAeZiqfn5zYVBurtr5j?=
 =?us-ascii?Q?X687aYvMaobZmyrtt1y8ZD2L1p0fYHOBwOIxs/sswIo4yGeUO4vcgOkOguIU?=
 =?us-ascii?Q?TinXOEGODjdZ6MD/XIEvATeoXdezg4dOLlWwh6bctBMj1eaNcOTYs7a8Y3JG?=
 =?us-ascii?Q?gxi8vwuXsD+Gz5p7wNLnkc/7YNnZUmfscl+XXUbiEvyxgZyhEfWfnD4IH513?=
 =?us-ascii?Q?VsonH1w6Rti7aHix7OxKOngghd7xPQg9qruW3glbbXzfbukv5iU66qxQZueb?=
 =?us-ascii?Q?EZMErDb7tZV5cVMmFO1xqwIjI/JBGS8bfJqfAQL3Vn5GxbUC8x0bimpRIqAS?=
 =?us-ascii?Q?1eSq/Z+cyKfP5R7ZvVRTMN4xr1w2Im9/XDOZIj6L2CRRF0MTAolIHTUVMgnd?=
 =?us-ascii?Q?xDFM4hACCUree/PeGW/+hfqA1wqUKWNygefQyepHDsJsBPjPAWw1ZbmriXFy?=
 =?us-ascii?Q?GNlDnnFVpRTP56BFApPOEmmDu2tPQsbmRPKIOTXS0J2ISEHV6kT6n1Bd1HBW?=
 =?us-ascii?Q?yUbqaXHdIzaCgDmstpulUp9ku1gbSTlPNxaT35sPHTNcYMIdIImxkbZg5Ycx?=
 =?us-ascii?Q?CNnoX7Wz76iug5X4g7EeOtRKWb39LicQkNQuwny5/8sIzBy2sjpP/LINpocS?=
 =?us-ascii?Q?BtlpL78jgi3oBIv3h044SoFVLoJ5c9GJBNbQx5iRfhjED8qi836yPP+KfGp+?=
 =?us-ascii?Q?OhY3nhKgnWAV83CMH63pysvIxm/PPn5V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bnPMPHGXkDnK9LgNFVZteyzmwpqPMhRvizycTs/DUwf09OOFNk95qaZrbFgo?=
 =?us-ascii?Q?vayQfiy8pyFC1PzpcVE99rNVQ0mnGsJwU09hNMboAsA16IWi664YRqiEDetu?=
 =?us-ascii?Q?SqyQGbEs8gkMPOHzKQchNrPzgUP+vgl9gFO3FFjHLySmDJBk2LVuH9ZH9Ull?=
 =?us-ascii?Q?XsFVsGoNip2sSMeDQ5/yFCKLlbcTfyZuTgVnyjsm/fLQMvvZLJLIVJndxAWL?=
 =?us-ascii?Q?uySMZxO6AnjNJ7GmysravAPgu2kb74QMst47t41rj+D0KxPhqxHuWp3Vy0iQ?=
 =?us-ascii?Q?bhnIPHV69q6OClb2jPMPKL4sVB42VHnG6MA7ul0Rzw47pE1A4OJJFBzrgxfY?=
 =?us-ascii?Q?um3GTijr/cbI3S0ub8ia6JBHGY/t9nuQiiSbtfHpk1497H4Rk7uCZYHgukx8?=
 =?us-ascii?Q?WGVDiUrRmVQlVxSykCKK4edryDbHQEJVZfo5O/c2gSGNFbrh5ZHs1Qtv3aZG?=
 =?us-ascii?Q?2hhIy1NvcxAzKzVwFBxKHSsEEg3Erqph1ifTQGDNFte/X7sqTnR7mS1JVc52?=
 =?us-ascii?Q?VaIRcWsom6t+pdkH7NPZy53jZh0C6hZuLcw4GyCgJoGQna16eLmc4NCxFMlk?=
 =?us-ascii?Q?uZDfp9n2FQ0uj+BoNn/XwWvmO6VqFiCrYmT6IVsCGPgYJPl1Myb8LUxvBm82?=
 =?us-ascii?Q?p7/eD25xhb6VkPrwSt8UkCjrjCbSa8qc5p63QIhtm8e47DULyq27MQxg01eh?=
 =?us-ascii?Q?3iLe4XIuD8YcRvxD8OKRGl81k/DynGIX0g6gCFu0uTGUAL5VamYrDrre6Ls9?=
 =?us-ascii?Q?WipJgMLKG9TySg+Ll9w+CEKoWgrhul9ucVkU0jb7kqvPE9wYRGPhsO+KVuGb?=
 =?us-ascii?Q?qa6rptKn5CC+fLhRCUWafp6kAqNj+QITBEIgMUD5tJOHC72PrCSfB42L7lJx?=
 =?us-ascii?Q?KKEKngq+ppBGYJ+o22Ddx03Rt+WBAv25JpO97hzm3p2QnBgD3M3UEwr7+LJo?=
 =?us-ascii?Q?6EU8SeN2E7rMbEb24Af1Gg5ezlwJniBQD65ITUfurNuYaOVKGNLoWoQjpxx7?=
 =?us-ascii?Q?IxnJZfO6EeNL3NBwx8jBXJQVtmoNsqkeKUUNMuD1orpZ9SI58fxXYwteYNhT?=
 =?us-ascii?Q?lk9vru5QyhJ7kBjlX59Xv2ymUi9sEfcS7opWFKM3eNNpa901tRLQXKdlQdDi?=
 =?us-ascii?Q?0a7bdwRCUCkovTEgKa8qmbEJ6abXJs1r3HMt7Yv9Ceae3w0GgQHyqgjtELsO?=
 =?us-ascii?Q?LfzSIVKBEgrkxzbhioVPD1Erlb4QGCoO3acdqm/3IrkPLx/ctmJzXhkCuKoz?=
 =?us-ascii?Q?JPxpIrgGDKX9wL3FD/apzwD+9aYhe6xOzH96meFTCCaYrkjJZJddpT+0WK1M?=
 =?us-ascii?Q?GMRSnG5SVdn5cVVCzUjNwWESnlAGq3JFuQnCgFdJ/Dwk+8n173WEu7UVfmt2?=
 =?us-ascii?Q?H9rr79sYza34jiSHgRdJw8Dh//skRrSJefth4uOfWl5587CI5Un+clSDCZrK?=
 =?us-ascii?Q?el3fnK6i46cK8q31i+e5NQJ3YuC+tUbLIAhKN9xUeuFK/NsDHQ3Vciwn6hEV?=
 =?us-ascii?Q?PiJDpZq3+cVqqJh7egTmP9F2ep8uoAFUDdswg0sVtFL8BubhZl/Bx+NBKKiA?=
 =?us-ascii?Q?OqgYE6k4QFlnq2on/IwzRoQQSZXq30bvOZ9cz5oQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	glIikd305AGz3D+sJS18HT4Q7fhMhj64B/hl6fCSJWLKj8uw/qnzeW1SESy5nQeurr1z24xzgvPN5B3u0pZRNAT/COymrNBO2ch0J1zACY5189dCn/GOvDJKl+5KFKQQnmO1JjDFwfe2Oyes40DDDt1j/4qV72paahaZ2WpXxpcE3BbJTTDWnRVEuZPmjOlrE3d5U8A1FnfQZA5DTil208iejPtItJWUMFPFiZ7n1lzuX89u9QrROssT2F5mYnQWB/cWrUqPKqg8ZA+9ZfIDRQFDUUyXn2d4rruoPB2GGjZ3pzvZ5tUrmSos89ULRDmIiFV7I3QW3l0Oa6JRVBTu7C84OlQdmQxKGwSE5e3ht+VJHHI2df1xWCOtIvhG36JsXomWumnvR1lzCvZpGXlH3HVC5R6f/GSXhrBpQ22H3MhPkRM9HexIxtEVexpAKhZk/yWY4SChjVlR7GdGEXsE/kdAC0yQFQ4EyZFvNnxZKhC49Foo76aHhKEFSEz/tRn8fRdpb3O8EyRxSG9GPwJ32+r9UrR4Do/P2t1k5BYvQ3Lyu7zC+rNNsYEZekJbGTQ/hl2XXzwPJlslPA+8mjswqzeTb/G8ZccxVa+SIQjNIrs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a24a7dd-67e5-47e2-c7da-08de1538d2a6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 09:11:33.1515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttTz9iGb44/LT76aDNEAjv9nVEW08Bu7K16OjHBP/mGL5u7kPBWlIrxhAJPlGaw9RuYZFMD7AkJW8hUpCr5wKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMyBTYWx0ZWRfX0nkH+/eR3NuS
 MLGlaetuyXEYH85hefohzAEJOnGtbo6PaJkxA+bfzYgdzaiVFHeJEsjtCG77C89Kmu2WbzCKBw2
 PHwY6F2qoOqUBSFf/S3nXhMQGPS2GVJIcoP78JRyImEZacGrP4ttjIge/G4fQ8OsABhGYxwQLp8
 DloK6ftRTqJwQ0MWN7sWk1td6q+zxrLjSFDjQ/p+eF2hzHLbui5Y5HYUI0LAld8xKI66HY4Kj/G
 RDB+HQA3hodCoyMsat6I99QZP0yj175WQC8HFK6sneLMHAf9ntrElHhjBVqmPfWz7ujb7fRN831
 IsQoct5mrouhF0SPakJe/LAFZkXszGsG+ckv7bBqxM6KF6SsEReRrqHpPVyDDLRUrrZh1ZPHajS
 RYWre1kZqfkRejrL/dYDW++3sPIGvQ==
X-Authority-Analysis: v=2.4 cv=Z9vh3XRA c=1 sm=1 tr=0 ts=68ff3748 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=AlIOxi0qyfaPRz1eFCsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: WZQna4yTk3B00cLETsXQvNxUQG95lOmT
X-Proofpoint-GUID: WZQna4yTk3B00cLETsXQvNxUQG95lOmT
X-Rspamd-Server: rspam05
X-Stat-Signature: f8ccf1x5ohpt3hmw5eqnc3b3kgtyxdcr
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B5CF4000C
X-HE-Tag: 1761556304-82816
X-HE-Meta: U2FsdGVkX1/XTECkH66/nW8yo+JEO6HJEiIm+SNfumFQlCAWb0XNlo+Bl0VJTbgegLyQlg/IaoCALamTHhxxgTCxJ1YP0G02KdfLYgeBaFnAAtvzDf9agINh7u0WCrZ5Rfbkw8o7D1txayIOrQLgygduHAoo43UryHWyb1TFmYZbYgmsfSeZ/HMj6G56C9A1mDeM39QNToTcpiw1L2ZTpKLdIJ08427ZFzEnbe5c77iisHlrLB6W7gMiNhOEroSb7Y/GUU3nbbF4ygMUYJmAm4RtG8Kt0ZciaQoAGNVsbvlV7jywZaQSyaQ9KO4lWmZjgqFmYxkOv4J5Yi5yq8P6Rkc68ZY6eIScT71sl8lr4JJZKHcgovuPR2/MUlmnf/1Bacm+OaPEhuxOePdv35vRrGXlr/TSHTTuSYi7vkf5Ao+BFyEEcsVVlcu5zkEL0JhD6alC7AmKd5Z0qYwMPSLAtf6gvLZQifDn6JSR+sIC+shUzxQAfsFEQ4hhm4RrQrsHRthGMToKhbOMb3Tkjfm8Pdi0jY/ZHl+QnAto7ja5n931j9WUgyxJSibyTGee0Q+lMpkMfwwVgRbjr2kuWHifeiM0e5Ojd6VAmt0AJ7SF5meqcBAKiiTU1JfsBik7+n1eiw6HICotAamvUIuM56asHqWyIPi8d+HkUF7xO3CJzKmWjtLaJS+inkD1HAigr5Ch4vygyXHwwc4/E6X35cOtBoHpzsqN0b9zSWDofBxIMpDL2FGW+4PxJaX695C7JvH1EUe2P5sAMORl5PxZlh6WGAFQW/9AeWOEplvE2qkS61zGzOkIkm5Ef8ayZOaoIVRBmES49acofM48EWV/XhcHiBmWeScr4Ep9Jq62YG/cf3nbrRTYGD8WC7UBz/Pm6sgPiAV7E0rTb5vZGYwGcI1klTJsPtJioHFjlIEdiXUfeoexzCAIpNzHgXWJSBdOMSOxQg48snriJo3vxmah9PJ
 08E9imoQ
 zgK4mFTrHbNGNDlg0c+vJ1FiKK+HT+ygkJqZFm1HqvB0hDQKLSpVaQrHJ4+hwrcRSIWcuXILb8rxluvkN0MJaw7Tcf1BCaaa+7fHlbjN7k4tqubGQ9mrpQASm70y8Ebf6M25rYWoOKeS+wSJdEtO7+LAfa8plXnvn80kcvlmj7kfcsYb9cS81QjOik8ao/0lGh7IidsUVE2/fIlViwKw56TOyFhLFEWsx8ezueBa2kln9NvG7wvE9axd7GxFoGPReR+t3tXQoYDjc89G/HLQoyyxAOHqV+bDkAFFExzrBSIttA2WAm64YmEzLiT/VPX6yPtyF8bTA+uxpwdqJOdCKbJKq/5tNcIVznbjjt/4wJ6LHWb7vIvIfI7asBvvgdRT0VqxOyFEB7c8MRlXD4bjbeG717xhZeOvEcSB4ly73PBRJ52AXS4KD4RABo1oP3BI/J7JYUHOfpYDLJhIQS/EG/2DwYhXiAM1bPr1XWK8Tn8ZKlP8nqAPixCkX1qX8JCS5dtPHAA3/XyqpExgmVSwJ5PL1Kx1TcWqr4tYcXjX+fmdiOCdTK/ZpN9fL1Rso17fZiCCTEYeCgqa0jzeyb6rmau3nQl8f2sfW39UFZ44Z24FtjOrU4qf5tRcg7hD5Q/Un7LX8GKvU6c9V/oZWzyzOea7Guv32GKC+p4p2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:20:56PM +0900, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 03:52:31PM +0200, Vlastimil Babka wrote:
> > +	if (unlikely(!list_empty(&pc.slabs))) {
> > +		struct kmem_cache_node *n = get_node(s, node);
> > +
> > +		spin_lock_irqsave(&n->list_lock, flags);
> 
> Do we surely know that trylock will succeed when
> we succeeded to acquire it in get_partial_node_bulk()?
> 
> I think the answer is yes, but just to double check :)

Oh wait, this is not per-cpu lock, so the answer is no!
We need to check gfpflags_allow_spinning() before spinning then.

-- 
Cheers,
Harry / Hyeonggon

