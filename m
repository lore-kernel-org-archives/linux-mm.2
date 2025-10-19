Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24714CCD184
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 07:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35868E0018; Sun, 19 Oct 2025 03:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE66A8E0002; Sun, 19 Oct 2025 03:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADA28E0018; Sun, 19 Oct 2025 03:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B56CD8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 03:25:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EC2DBA2CD
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:25:46 +0000 (UTC)
X-FDA: 84014029092.02.7E0EA14
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6CE120006
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:25:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="BGIDnsE/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m95Fk1Ed;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760858743; a=rsa-sha256;
	cv=pass;
	b=ghIP8MkSeTNgQpFCvu9snUbAzHOuanhTE5TduIWnO5uYQKxa7K70Rd8BVydiXO2W6MsdCK
	YitIcd4zRbLW9FXr0NYg4mFrhMSaxfn0p2Yyz09/rOZ5+Ial1wbgE/j/jMtPGGWLEddro7
	wI2isx50dGO3S8DH0j4/2WRddig40/Q=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="BGIDnsE/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m95Fk1Ed;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760858743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PYtYOqxZi3tTy3rISd69QaMbbncpysl9S8oelgfH804=;
	b=eq/7tlKf9CSUTO6dLdumUHFrxrVtVAJEUe0OywfeQ2V3Z6m1bsRQgeBgu6a9rad/5H1w10
	Cs4ZGk9qaMtbioWldNXQCPdD7Rsf6wj5hkS9NlnZWHkfVbJzb0/DOA2rLYedutz8uB1QFw
	+2J5XBFrCfSMIqXLXCvfpj+GIfyWzxk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59J5uaAw021338;
	Sun, 19 Oct 2025 07:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=PYtYOqxZi3tTy3rI
	Sd69QaMbbncpysl9S8oelgfH804=; b=BGIDnsE/blcjqR7qzphyRaKkd4rgCy9j
	U3LreJF5jrt9652ovWEDeZIFMYVZzZSoNbZBvk4SRmgZpC/qsltEqePFgMiZvf9n
	q7uYLKZypRcwuYk7PWYWJq1xBz1QX4NxVwJQ/UXDnssg7R6PjKfuAWI+m+n91fPH
	2M5h4MwWbymIgGreXECkYumqJ44GergIYocwRaOf/wXLZGGZhnhY9Bp37WWjc+vy
	5bqHeK80ImoMDSZMRVqv1C3vt0x4CY/R6+QVgInZSn5TpE9jFEek4sw3AJISZomv
	S/e7dKWGrKspajH/yHelpSWgSF7GcB0xq3/XJuzGl9P0YYqh8P1RuA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d0tuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 07:25:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59J2U8cc032359;
	Sun, 19 Oct 2025 07:25:37 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011018.outbound.protection.outlook.com [52.101.57.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1barr7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 07:25:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAS/UHbpDQaft584YVZK93gqGyfUe/U+Jx/5QMQV4psLx2LPiiGTLCGB1AgzPwiE3LMwai2iH6QWzN2NTJ4UCOtk41ls9xJZhP2J6Ki8MTmFZtv9326Bxn4+4UbIkTDkIFfR/VDdAN1rh/TAEjyUcHSmIsUFEUD1X8U0nPDtyETlhqIaqe39YX4ChBV4tRKXvzIomTs09MtwzEFMgD/C8TOZ85uqMRxE14Oo7idN5SfIO7G2YOPJZS4FNb+z2hjFO1huXlT6U7FVdH2Dda5hMwbTckKghAMZH0NRQW6Lg2m/KztRyFzETCfyXFM0LpaX+uJyE629epaERT6lTYm+sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYtYOqxZi3tTy3rISd69QaMbbncpysl9S8oelgfH804=;
 b=FbkJGwrXATyRJlCjakjDyJm0cl8Ph1vmJade2M4TPaYtja31VfoIaC76L6j8EDY+rTlEkYBMjUIL0wNdYY34vpiAJ0OE0uomASaIDDg+4b41eYifsLKzq8VYHd9ZaNZbUbicDoHX20WKIfM2NUlWhDnmKKHEEOrkZ2Ka59RYcVAH01m3EXZcIVpsPLe2aEWIaEwQPhn06bqdI1jhvpAwbRjL+WCXNCZJAW2NO5qPdUImrjT0p5JLM8WGGaL0+F9EXBUsUcFYk0Tlmz5OQyAU5OAUnfY/pH9+YRuBFJm5fIxOCl8n+lZth9MOSm8vLPMXtiAqjM+HjeDiMEBgEBK+BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYtYOqxZi3tTy3rISd69QaMbbncpysl9S8oelgfH804=;
 b=m95Fk1Ed/pQB3wy6YCm13Rep1gKHSRTpcYouc4nzkUv2m76VzkiftmNgbPKXvUSRcOmYHsRFgFqGWCHfJww9hMA223lVNoGcWQfBbxv8ladJ4Tr0GCO4lZ5GSe4Mpb9nM9tTPtQW/des6R34BUkLsAOZhXEqtsBdP1SY2O3UUvA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8759.namprd10.prod.outlook.com (2603:10b6:208:574::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 19 Oct
 2025 07:25:35 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.014; Sun, 19 Oct 2025
 07:25:34 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V1 0/2] mm: MISC follow-up patches for linux/pgalloc.h
Date: Sun, 19 Oct 2025 16:25:07 +0900
Message-ID: <20251019072509.9488-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0225.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: e0eff9bf-2a02-4d9c-671a-08de0ee0b140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f4XDGYI0pMkU6Fa4RV6Ik6WZDvfMx3capfv4hXcfEhhMUsarX++cDW6Eg5Mf?=
 =?us-ascii?Q?FGslKOu8M3zBe5FWy60oPdep/4RDCuNvIqH/tzxFuzkZowVKe9KsCG+mIJAe?=
 =?us-ascii?Q?V9WtyzJT/zo/YN1b9tUyWa2qHDuBusPWPnMPxOHuoSLgQN13XKmzhTSjzI7B?=
 =?us-ascii?Q?fh5eLgdneXxgq7p/1PrOJf/kwP6O+YuehdLwWSNDOfJaM9P7Lc/7reUQeRag?=
 =?us-ascii?Q?96PydBt3L3gl7NNetPbgBSfsaJCEAY3JwOfyR9FxwF/M5uZs7AKhbhRDxZoD?=
 =?us-ascii?Q?WbPAoizXHQCWRXOUZlZUgyOsCp6rasqi2FOoVPsosiD1vPkzB4KRp9ZePHhl?=
 =?us-ascii?Q?Y8FmlmkkVY/rwiiEs+nBuNFhkqwi4aCiTXeM8NZ28nl/VqrTYu/AZQxYRF8W?=
 =?us-ascii?Q?W2GJOpNu9JYBRFAZDOMu38N48ooQhib+ja6R5COMFMum54exlOC94009C3bC?=
 =?us-ascii?Q?Xyph+W8UZTkCHU+L11HBUkiIaKMaC6TSSVHTI//KBYw6qQvjuWqNwjVRhu9i?=
 =?us-ascii?Q?L+tcXZQfDHCKrzvgTPxtrGSAA4cea1Q9nHlTMcWEfHkVYYhr0hy21yzcRn+p?=
 =?us-ascii?Q?BoOv3PEYwhOhIuRdtloa4u800SJquwLWmu7uUONOYrJzQuFqKNT6OAYyFd1Y?=
 =?us-ascii?Q?0DPGX5W9pkr4B1kqGzf/OUjyZQAsg5BBwa00nXtxAOigWAt02eUznDDkWqsj?=
 =?us-ascii?Q?4sb8uSWW0uLiHmv+ADUS28lS+KMT89Yjbca5Dj1nHTkP0poRjw1sqcoJtFj8?=
 =?us-ascii?Q?PL8Csh1QkUEPve09eluac2fniR8NmpwwBQl4Yn1X62Qu/UtqrP04Z+0taeOy?=
 =?us-ascii?Q?QAtRt8bI8mC/b0c+HbO5RVUAz5VBxLwj92wGRUVsG6xXSoCActTbXXvJFgCq?=
 =?us-ascii?Q?0EpSeedJSWYjhjiKWXzPSs4dQxpOExr2j8+nDxDKD/A9dQXJwBB1tOMNkzOB?=
 =?us-ascii?Q?VHkO7eHtglU/kLProyvttgzBvxCk47u8KlrnxdUm1pdFojeNM2vKUdLNh6up?=
 =?us-ascii?Q?DGR0EdZQW/gE7xVhVf3GYGVMHQvM7fb82s+1NmiLClHFvuuL+xskr+GT496g?=
 =?us-ascii?Q?ETVJI1toHlgz/v7B9ftF/rPl+4IAsbrmUQ1D3O7wuGOTQAJ4wP3+H80MCFtW?=
 =?us-ascii?Q?+M/eG6MnNQGTh3F2UD2/FF0j6jL7YdfGS8mo2C23AOINnkTpRe85ML48ad1Y?=
 =?us-ascii?Q?Njc/7LDEfszhI91KgTfG8IL0CgX9XNax3+T5Jk9yTbcxKiAeflG6SebW0G47?=
 =?us-ascii?Q?gwf/eQ7VlDwLXgnIUoO+fMXXFWYp+gab+IhtgQTHZ5EJ/8PCYajBpXj7tT5f?=
 =?us-ascii?Q?fqdKSTHCD2GEzbpiflT8nE9z5L/J/qu0lY2m82/GSzX33eawfbWW72G78Xgc?=
 =?us-ascii?Q?k2g17M2ODZO+4gRphpM2gtVuqdVfllFWOGXCOMvH28/XBgdjM6O1GXcE9QUK?=
 =?us-ascii?Q?ENB3HiOWzgoqBaVLEss5qLrwawAPl2MJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lf7PTHeXv7aOgwGqZGkZ1h0SrThqRE5q842rKKFO1Zz2ypuDpBzRsY4cDgF5?=
 =?us-ascii?Q?FHhqDxLZD9mdbWHxEN++sXD1DrV0mQ2GK6/iymBzaa708/7h0tEqmwPS+gfU?=
 =?us-ascii?Q?GajB1H0+XAbkMgFSpD3fxq2cG/X7QREZTly3DP/IhSZm2tZxhm4FJiiW6ApL?=
 =?us-ascii?Q?tE1i8zq083IurBY14KboNd4mZCkbSevI1zng9LXk6OyuWRaxf+ugozH94LiA?=
 =?us-ascii?Q?qtLk5VK8IdaBZZBXDyh/FD4I1Ap+qiTzBF3XjEgevg9T3ilqgLE+6yGW8fH9?=
 =?us-ascii?Q?nbBiuodbfuW4FXxtqnUiZNlRCI7n5GmWlargWg8QLx3A6XdmHFBOzJd2qTu0?=
 =?us-ascii?Q?XNOyX0IbiLT39E1mU1g3mszZGtVwzyTpqYJmVNqh7snfyLisKhoq4aaEBskw?=
 =?us-ascii?Q?2riIgVbmjIpJvn+rRvfAxaGic9ynnXQoR4JkrAdE5ibbBM4XF7TCQ5ghw8/l?=
 =?us-ascii?Q?3D+9+JAk969b0YGjD2zWFAbkybKAFSEkly2UFbaKlBJ9Zlt05UtJEklZ/4br?=
 =?us-ascii?Q?5eq0JNgdBRTdiEjyP7uP6Gq0fIQdzFP08kZDsWTvNBE824DDAqM8hIhFZWPy?=
 =?us-ascii?Q?tULmk3zU9Xd/3FTaRReAPY5WY9v6eDyK52P93Ns5ZGOTcPd4HglrjC1BAzyc?=
 =?us-ascii?Q?Dl3wRsXICJm/C+f9SBV182HdSUbvOWuiUcXG0NenWrPwi1aLNv6pfJndLjma?=
 =?us-ascii?Q?uuPtNwE66YcorJwNcb/apVLfiLW9fhzZKkugYe5s+T+VE5XTH9O9/329Rhc6?=
 =?us-ascii?Q?1/vY6BznKro1iPvyIpKcOOl86bTqZvlDgiEDLzawa/QWB0Lzegu+KIqt2HCe?=
 =?us-ascii?Q?5f7U3fDMUQarOlQeq/uuijb40/y/IRhVn9658Q96fL/WMIBpN5tNh2VR47cu?=
 =?us-ascii?Q?tLL4eNOvIOhYg4IGU7ZVqfvfuz92Cw/bg6SsICnoSeohuGSgFefW+utUSkNd?=
 =?us-ascii?Q?MKDJsbNKZ2SccKaxX++af5As7sWWBXLvDN4pkApwI0ltvSdTXS4a/x4mTxWW?=
 =?us-ascii?Q?qawpAt176h/FCDC7agNdnQLuZiXFxrH7/xHQHn8HvyhYrbFaZC3EIuaXXGUa?=
 =?us-ascii?Q?fAZm9iy2tF2vPZSXwsHs/7zugRxiMksTzrPf4hJGDbvCuRkkdgyvutguZCMD?=
 =?us-ascii?Q?/wCj9UmXeott8g7cNC1bf6rUJGha/SeSr4W7Pn+khsNgBASsmWqg83yUEqgN?=
 =?us-ascii?Q?6bIEEKoIzBx9ugK6jKmDBMvTeEXFhUaCNOtkpikq9fh6JpYheefuGOfBKjp0?=
 =?us-ascii?Q?SVxGlD3QVJ0AM798ZXELqNfJKMsJbtjjayDGJG30rIWg5I30xNRlaaV2BVcY?=
 =?us-ascii?Q?Ai25kjYuQoiZoNlzd13tT3dgUZ3Ep2Kp1hhLaKvYR7TJa/ispBjdS7R2+W4/?=
 =?us-ascii?Q?rr8zmGYC6n/YhC1MSmPIXIVRIXUQeCaRN/7Ju9gDNzxcP0NpPRMQnQfoD9p1?=
 =?us-ascii?Q?31l9xY74TQR70OqUwq9BNakv7Ivm2BAcxyI2aj41pg1cIt9od5/eZd6XD/rG?=
 =?us-ascii?Q?dZT4AHIVLKtOa3PwiggXRhIEoi15gWpXOC5LHwQegWRY+OpBzbrdtBbhj19Z?=
 =?us-ascii?Q?4ns+2WsKaU2fQXfAfA063RULFmsKku4jvxkXa7JR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6nT9J6QWvA8UqRFQ2cxv6ZYmpmVnMqIDV7MRG1N//NZ00MmL9F6x/e+KsKy+/xTxqiGJmpIuxqlHyZ1jI0OSCz/cqMuJzXo1VAWm3vESc8FOU2+7ThguYkryc7MiHPNSRoI5iWiACk/wzwBxh+C5Mcyzz1/ZSqVblFEx4VUHq5qXCaquG/96o5g/TM77zi2eAhiWBpW57hbt25LRGdRmUgHddWWuvDIsAGLOkGLfLZz1ppYRlcmZ5lyWmvYMLpr10XoBdWgt02gn/rwg3kkFmBbWzYM+5XXzDXR1QMGh5U+dRZ9xhjj2Cx9/gAGeIGTJNM7dTPBpx9FJAGK1PirdEQExC6g8cpOXTzk5fO5AM3lxiFC5QD7Ou7wL2pUC3aUOipr0N2xWJ5RCS9hcu2CmMhmomBfZ1en1+VlJ+unLdISGPpUmm2vkIUdFTXFzPsu5vdmNBimlP/XbupauhWqrhn06aiNyzuuHkwpM55ePIUdtKUmL00Hwcw3upvqj3deJedZDB6AZu503sfVV0Wmfu/xiosqVTPg4t63xaIsE2Sn3a68lRlh69IGaXTTsi4880MpBUYcfbgm0DOo3DMcQ8R26SAhatf/Eizb/4RJCZlM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0eff9bf-2a02-4d9c-671a-08de0ee0b140
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2025 07:25:34.7152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8r0AalG6W+uz7/gHvb/VCNCkpA+b2fVqmQMFzXmPDp+agFHcFj00JZN3ucrB/tcEUm835jk5PhvVFoDL29ONxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-19_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510190050
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX0fG3f9I8opAx
 UnKgGHR4KUxOdzLCmQ5IZQxLl3TirjVmzlgHc5E09pnHFW64JnNOmMq/DpERAIeyu1WioKmJMq+
 iUoCw5Oor7n7mWYRegQhFcQ9gllhSfBYcnOepREhu3gW5Plu0JqZeiLd7aSBbdwoCiFj18Wf25N
 IHgwQGTheeraHUsIqIZPxdYW34vAFk7nv4xTBHNPHyyraJIBFX7ZgqerbwkAAHiV+y8VclEYAX3
 vI8g/LOMeCumP7vTL3dOjRQ4xfC9cgq1Tmsw7XOtTKqlRpFI6EU8WK9gtX8zO+KdWP1AWzGiXqh
 mMjMgt2se7G5PtLx/zROB+dJ9BqknoZYiU3VYuhkmyFKb0uhwbfmyLc06aMoR62UhMrXPnFAfsM
 uI+tE7e+wKFAEXH5g7F9ebA4HlTwfl3b0a8W1gmmOtXiYWmx6qA=
X-Proofpoint-GUID: Ypizuoy5DbOFe3MOumJ9CkFoGL_Tj4dF
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f49272 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=lo2N1JL99uwnjFVDFfgA:9 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: Ypizuoy5DbOFe3MOumJ9CkFoGL_Tj4dF
X-Rspam-User: 
X-Stat-Signature: yto8choxa631caffe6j393pjpg7xxmsa
X-Rspamd-Queue-Id: C6CE120006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760858742-508121
X-HE-Meta: U2FsdGVkX1//cZ+WSOPkyFDrWpAIY24qRsba+PgvApyb0DTVYQa1WLg8uQhUWWlHbqdx4NV6dC8jPdwmjx4owNA1HMw2gWaCXhbiFjX9hXu0plJllQlmJIjLkaxgAfEAqF+qAOZlLtrUvGKkkmdxJkYlxB/6FY9N64d7leAxuYDXh+8ceVXrcHoaVNMijLHQsLRnPVOyRxCRRTnRiBZZ9Q0SNBTgwVDl+7BXjOh5QhfkTd/vuADBBdS+EYg9mReqcQL8yJ3R/ebTP71nGD7TADd3Xxw4l9434Q3A8HkAIJ5YQDKtOyi2JAC7slm9lgK8DEsqWKVW+DN2wWKZD0wzHlFMp5X3KWyi95dYNcLPsS/+0RvzwZNWdF25dC5rfmDt0sVaQspcqY9nPDfPjwYb8PDfR2KXiJairIGP2/21XeYfzw5BmM2QQMKTiuOWhXRnmLF82yRoPUMw2hI5e6ALWnEI7TsgworowlXtmN+L2vtbSiS2bcWaagUioKzmIs89K0IDtvKF7tMzPY3uqJkBqHksOXSbfzldFcmo3PcwKWctSiAZ90vsTGRuHzGMJf0cdIBlavzPwyYFAZyVJ3cmXmTuMCwXopLjXlJLV38tGIBk1lUGHwNTTE+/UxTyVLFNoDsxqQu4pj+7Xgb/8Brbuav5nyxJRNkJ0Jtgb+IKpOU/Z6o0WtWZRi4IthLIsXvDL5iXyim7JRMvqeXWtsyr+y8GiyfY3vntSR3AxaP/ewDbcLmNoKOEwyGmQ7fB3MwGlpv7HZjQl0eZGU5hQM/V0Cy/tpGSbUxHazuPv95RZ9QWSSiUUqYVK/q6UGp4nf42dH6x0n6jhQnm2LXKpdzWzMgqfhbeWsu2OAwkdjY0I1xk0OLRX0Wd3f6hsTEi0EyPGqPVDvD6Wbydsdp/VpXzmI7yG5aMjNhlJzyrKlR/MaoqvcizJEIn46KI42SX9pwj8/AE8x9lVUbUhl2u52J
 tQCzGS5x
 9QoMIDnawB52UYYs1myowwV97h9zsBAQUBZi2NQiXFYaJAYVa5cE0324V234eeR+ei2mK0R7ydN++kuerioEVrgz0JNwanKwKu69ukAi8/pi+XhxFs9zai76hwmEMR4WEwsxMW1t3qvY6nd/nrJMT6YhUunGnsJFy4C8zdEKQqITABSOMjCAS7dw8ozV6P6lS9NLdoBsV7DneVKV8PmMkcDa0uaki3+KEKmJcLmEU/abW9zgoXHSsWBfaxTvt86fOAAyo7JmPIt3iUiriRlUfXXyEkO/+iMYGMxTx9Ps8cfnUzsK/3FdcDNy7PvofvnVpWHvwga5muR7Fdia1mz4bFT4aTo+VdbyCvjLPuu+nURY/1xK3RxcRZHET2pVUYPfcTWyLbmGprgErbuYE+jI6iymiRtaUWIcTT955dvqKCfjnaf9wppW3AqM1Q1Hs24u+lI9p9B+hODd8hvWDln3rgzHo9XFAuCKEfQP5M7zn3bC52HH4E+WQIKRsXCYISdlAy9qjt3OrJKivCvRAXkaIGW6phSvlmXZreyWJJOZ3n7yVfClj70Zw3ZbvxiyQ+vpGDmPEc7oFjHopxS+aLrTDu30n6hv1MqEqWc9wwUozyuwMeUn3TLYpxkrbMeem+FZzRLMLe3j6gEkrcn2RIXw0XsqKA5iP/nkw1H0f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks.

This is a follow-up patch series for the patch series named:
"[PATCH V5 mm-hotfixes 0/3] mm, x86: fix crash due to missing page table
sync and make it harder to miss".

This is a follow-up for MM. For x86/mm specific cleanup patches,
another follow-up series is planned.

Patch 1 creates a F: entry to MAINTAINERS file in MM CORE section.
Patch 2 converts common code to include <linux/pgalloc.h> instead of
<asm/pgalloc.h>

[1] https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.com/

Harry Yoo (2):
  MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
  treewide: include linux/pgalloc.h instead of asm/pgalloc.h

 MAINTAINERS                          | 1 +
 drivers/firmware/efi/arm-runtime.c   | 2 +-
 drivers/firmware/efi/riscv-runtime.c | 2 +-
 drivers/s390/char/sclp_sd.c          | 3 +--
 fs/dax.c                             | 2 +-
 kernel/fork.c                        | 2 +-
 mm/debug_vm_pgtable.c                | 2 +-
 mm/filemap.c                         | 2 +-
 mm/huge_memory.c                     | 2 +-
 mm/hugetlb.c                         | 2 +-
 mm/hugetlb_vmemmap.c                 | 2 +-
 mm/khugepaged.c                      | 2 +-
 mm/memory.c                          | 2 +-
 mm/mmu_gather.c                      | 2 +-
 mm/mremap.c                          | 2 +-
 mm/pgtable-generic.c                 | 2 +-
 mm/pt_reclaim.c                      | 2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.43.0


