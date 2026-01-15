Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875AFD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB54C6B00D3; Thu, 15 Jan 2026 14:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98E76B00D6; Thu, 15 Jan 2026 14:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938046B00D8; Thu, 15 Jan 2026 14:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68F496B00D3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2724A8B87F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:36 +0000 (UTC)
X-FDA: 84335207712.24.52196F9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9842C100008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZxGKU6Go;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NJCiEA98;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
	b=AEoTo511ho4A16T+YuABrZqSvW+Ul+7Rwx6B5AwBLJ7ALr93Ss3R5XZkoXAyoGqO9zqvZt
	Atf9ZKxoPQOUpSVaUWfytjeSYjB29xYJ53oSR2j8y899m5EVmrlOpIz7n27K8zpIin9Qew
	FnAuXCxd418ssE/Aj4A3YaOFbG5vBWw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZxGKU6Go;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NJCiEA98;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505852; a=rsa-sha256;
	cv=pass;
	b=gGwK+Hs95QlDUOX5ZdV24xzUH3boUNUNKvVK20Ux51N40MxSEHgqrmjMsl1x3V9xUSRVNv
	16ep/g2Oks5/faJc0IdZJNElffzT3JtCCKOOmWG1V8v725BlWMz9edf/yQOUBmHh5de5LJ
	Nxx+lYb8/lCQtrrLbSS5VlDJZ+pbnUY=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFQL5F2812196;
	Thu, 15 Jan 2026 19:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=; b=
	ZxGKU6Gow0PaZtYDpuT1vyIqEfdsmzqjnT+3QUXZw3GpbyxjnW0GaDy0aeGmVv95
	kMmzzLc48f3HHhd65JYIj9GvTtCkw8jpB3/B1vChdL2nR2MvczfYBvnrh/A05q3+
	zp9HwmRvgfu2F6antcQ7CXENFt254XU70msbh8hBAcw8UDi6UX0RS8kAMJl6PhuP
	47gvPQqpaNT/TUSU/WCoeO5yHps3vy1yUNgu3L71g8BahVH6Sf09PTqjTiDbAdqf
	kEhNDGEdlis3ZHM2Fctr8WUX2uEw5G3DZiFamsjv3Jnk9rkCJzKiDpDQPuiIX2rJ
	mHeejF2m3R4rk2Qhayz/Gg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nrnqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJXTmV040477;
	Thu, 15 Jan 2026 19:37:25 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010035.outbound.protection.outlook.com [52.101.46.35])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgkkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atCjz+1r2a5H8/ZY9Eb1uolVOGAjnUOYvoqxUnQzxfht/MLD6q5ASavLZhtO0h7VtE0X+MU35nyYcYNbcNwxDBQVKDUOE2RW6AExrKtb8pQUU0X+fIveVKYPdwTVj8nHutSajah+0nLKjGXr2acGBtK5RYhGCE0WLhkNdA6xogED2G6Nt8NHFPEqd0W8adJCxLK5iLGJKkmF9M6blKI1/6E/3O5xGvEPFp8ywAmOX0vwWbVZgXHrNQNu2UJq5dDaQOaN5RcYVhqIPOOkMqZSO1lmePHBHduymDMX9mPnWwFTv+Z8mvy2k6T8p5NQTkBKDDEf35ze/Lm/RY1ScU4fqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
 b=NMiLpP9Na7lxVsjI56xLlsphOUjS/bn0MnmvHADfSCxBv0OQmN1kD8/7mKXL4I7XAazAjYdGQKBBI+oRHeN9LmsGjgG8fwAfDvE2q+JvOGBy7RBIgR8UqWbsVEk5nV9aX9M9s+45mpxlk0+99Zmzy2MOMMUVmjE1U3bYsjRNrKwfT0wzROAuHT98m5M0i7jxIHr4JMpyJinnGpZWRGM+j44vBuBhcfs9k7wgeOs7RsMiNOrhfxv0EHjbSOkhxr+F88SrEiLIP5QaRnbLncghE5yj/PtGIS3Hqpxsz/x2MMOHUnfhyrkI4LvJ2Tx+y0LS3em2XbMx7JN77Z63MkVNQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
 b=NJCiEA98fc5gnKS8vTHyrVK1DUZDiK9T18+heCQMshWD7jjZdfwhokfrckRjDHwsNRu75UFpzO7Q++LWVnMOn6A0jVWUz3iDGfzgYtinpvW+f5BIDRosbuLY/r7wA+JXIMjVgnUNumiDGLc5QGlWxDmLYfaO0Y61Wv+bGChWCAE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:22 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:22 +0000
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
Subject: [PATCH 11/28] maple_tree: Testing update for spanning store
Date: Thu, 15 Jan 2026 14:36:30 -0500
Message-ID: <20260115193647.1695937-12-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0398.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: b7f7f509-fd04-44bf-bf69-08de546d80c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E/AEMfefTvrsoFmN6BCP47gQEBjuSZDsXjN1QUFasHXUP45wYPpGBjEWzBHg?=
 =?us-ascii?Q?im912jPmS1Pmw8ZuSJ2Q2Rum22WIdFYf4ItluQDX4SFaGf33o+GhNL+s9pu/?=
 =?us-ascii?Q?KFWwIzMEj4qB9XpMe9UXJqLuT4pVySQfj0nJuEruIHfdqQ9yB31VasQJS/zq?=
 =?us-ascii?Q?a8IP3pzV1iXIW5I2sbESaq2JJj0XtpRXExp4VEC4O1YidvxoiEe/IZS2F4+7?=
 =?us-ascii?Q?L1LMn+HUf41edMUZF9pKz+mKswio7gvd9JHLPSIJSO0cwBey2bQXAw0avCrr?=
 =?us-ascii?Q?lvMFNAdnlBbzmY8/CdVFQFQMrj6RRoY09s8chVXr5FyIjteufSB03HUjfOfs?=
 =?us-ascii?Q?2eTD9nfMl6shj7MTPtvjmZKctXq26s1eCMGkhYUzy9mKIvLGBtidAcwKQRnh?=
 =?us-ascii?Q?9C6LIClAJo8/mSTKIIojaIqvKZ7z1Y7YlvO3JzQccX8ay42dQMzA4tdzMjmA?=
 =?us-ascii?Q?oxq1PoXNaVJrOCwPlmxe0faRK58VIYBzrSqunqPHGZ3kj5UjOWjONCVqApbv?=
 =?us-ascii?Q?sqFaCWmrlCowKivUF1XDdrhJGIoFgKRWJyUsyJ76eZr5rwoXeXrcUAQsFs+U?=
 =?us-ascii?Q?61KNNOxUbQVQVVJJ7mpdDsrIR/bQ1TfbZXLnmUMf0nK1cFT53Sjr7wWvqmSE?=
 =?us-ascii?Q?Txtgdhgkxkt17p7NJVQXUswk2rU85QD74TpdZmkd3H06NpTMWfRMjeWz0BST?=
 =?us-ascii?Q?LBhEomCba6aPYRIc0iDYcv+1xj72E0XIiKQKkOrnWCdgL6c8qejhdzmdF9qz?=
 =?us-ascii?Q?Mm89lVZ7CmYfNJq3FRVNa5FXfObJCPDExdS6rSGMHJQcF87zU9l4VjVjHF3Q?=
 =?us-ascii?Q?QMbV7+OuzZ1x5+Nl22rRrK0Jmq4+vclyjRXsAM+DCJQHglESde4ao05FVgHy?=
 =?us-ascii?Q?Ypb8vtp5yHTpAElKJPlwSqN2KzKlV0o+aHturZU0139NI2HpGiMd6eIgdRe9?=
 =?us-ascii?Q?Aqyd210oYoIFYPnmVycg3n83xLFm8ICS1+auJszNuAGYPXNIyXr5LZHuZFYq?=
 =?us-ascii?Q?DM6gHNRZEybppzhu9zfQKe9CJdIXTZcZOOAM7D56L3rPndfyQ8s9dOR08uQa?=
 =?us-ascii?Q?xVCQIZEfM19MC1+RVS/+5ZpmjbEHz/MlIEsGY04+lqT/HdfWcuOj3o1biBYY?=
 =?us-ascii?Q?OAePbh78M/zdJ7MQH70mVlTEngAu83r/MMhUQ01kHhdcuYjBdb0JwWxE8t7b?=
 =?us-ascii?Q?owBJanZOh2dlTx+8KiN4nqYtZ1evFn1Qqr2lGgCDGSWrUhtM3eFq4Qzz61g5?=
 =?us-ascii?Q?H2Xv2kkL1xsfYFnbIlz3LLSX3y4QRPvQkOitkK7uHVAcMYn07Hx7Q71ekBm8?=
 =?us-ascii?Q?BuidCZtzP3sdlpSdkmH3888VXrkaLWCq4lGW9BNvClq7dbrf0lWflPgIoPIr?=
 =?us-ascii?Q?DUfypeOwSO412sKovI0YMW1J/eodgMR7T7DShpa1lY4FrZlXVfJfl4l6KJFx?=
 =?us-ascii?Q?GhH1hlYySnwyxuF6RnG3RQik4KnGJXX/PT7P8iLJ9pN+i13ckX0+4P8VHcDz?=
 =?us-ascii?Q?2jYv1KT0JopX/lfbfEuTU3Ejgm+FfoDGBoUPKUn6g0LgRChJ1dOEiVfYez77?=
 =?us-ascii?Q?l8hc3XrHhXFXWHf/Dz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fw7wCyRnHUvC9Hms+WXObwCjYPLOpdvz0QNFG8PFYsWmieMboE4TZm6f8zmL?=
 =?us-ascii?Q?sGRem26fDVeZvU2nZ34eVtvz8Y9UMM37dOwfugWjWt8Fte/A0vDphz/BoxkD?=
 =?us-ascii?Q?KDe8x1J1yMXrlPO3p8EqsJ+zqhRVi9gRCitVgotcO6PxVDwaDFG+VyXEFD+K?=
 =?us-ascii?Q?Acqsb2L6c2ETVH9/CFm0cT/04HuoRTtg5kuuF/iqQ03L6xJFdLjeNoPKAdwt?=
 =?us-ascii?Q?DfXfnxnZAFWK7U5Fe9SxVOADw93A4XFe1Gi2QhMX/qS5WAeSqMgjyC5+FB95?=
 =?us-ascii?Q?6bk1tXMuuU/n8TWZuxdmKNHbH0gzsAW7nUOPYSrIyLDPPr+kXoqIEeMBeC9j?=
 =?us-ascii?Q?+rw7Q5kME7u1FMK2LNrgJf93PhaPy1z/XP92tQMbTI2dZt4JHA/6gLerDzku?=
 =?us-ascii?Q?j1227X2b6T2DM3fR1A0/8ZRzQ8T/M/inG9H5BToeeRVOpogjyPivsskaDs1S?=
 =?us-ascii?Q?Zqat+YGUHvBrMhYgKLG4u8CvQu09mg+hvb021mjAsbmcXY0219sDzMZqKFs3?=
 =?us-ascii?Q?D3yeICk4qF4GnuvjrdzfpI+x9uA6UdGrEIzK8oH4KTDw3cg7tQqxdRat7Fzq?=
 =?us-ascii?Q?aPlgMPGkDOI1sWIrARkYe9OzY1WSQkSd8IQ/Un89e/PvIKr3DRXO0X3FRlPg?=
 =?us-ascii?Q?yk/L7kL9hhNP4v55qOdhtRulMby3XawTLcTdnxIterCtguP+05HhJeSiI2T5?=
 =?us-ascii?Q?e7YSAX/z8QfGAeGczAYRHPGDXohL6OhcK6Zmuif6JAU6dXvK6FSqAzdOMZBs?=
 =?us-ascii?Q?yLmDFsioMhh6+tgD8nhmQxEcZ7tTMxf0SGN0MklS0qhXH39Tgq3ki4mNOj8b?=
 =?us-ascii?Q?oU1oK0S9saweG0DkcVcn64qDnxiyb7ysW4U+AZJKWkHl2L0XdI0sIa07h+0T?=
 =?us-ascii?Q?SUIdA48WhNHCfFG1+qgA/Bn8GM+qWbxjzR8CpDKfRuru99Ho8hLaMNZY0rLQ?=
 =?us-ascii?Q?MHB9baMJO2vzQ1/M0WtMLrgvyUjeBdjI9sCTnf8SMIR75p3bzapng8dgZ605?=
 =?us-ascii?Q?qmslxYlNKfo9KB5EcSC9sNbEyTJKjRL2sKFBeOfaKCuy4Lx0SHaW6sCKz8zD?=
 =?us-ascii?Q?+o08LakTchYwOkdZHJbatXbaOS54opbDkiAazFqBe0H1ZK5NxpSRvjBDFVUS?=
 =?us-ascii?Q?DeryOT2kWaH8h6+DGlg/8y9Wn9iE0aiwZ9S+Ikp0LS5TZ+pxWe1rresuvbmb?=
 =?us-ascii?Q?IY0zJgihzI3zGxT/6izAskDM9IF+4TsZanb3HiAnaszhxAMS8ye9M9kzjCl1?=
 =?us-ascii?Q?MViDND4Jwesp7x68ABt8k5c4UJOLIoOSIDThfKhnfazsFhL9OAAlMZ3SAGcr?=
 =?us-ascii?Q?6d57nWxaxYcGuG5FLXnn/QeSpMnVYVMWgBf/uKJ2aIvrhDdojSAvrkRkRzgN?=
 =?us-ascii?Q?bUsZgxrJiNibRoqmm6oP40jNOBZta6RYy2OqbvSoXVWBKKaQ/y2NTPKUQmkW?=
 =?us-ascii?Q?O5bu28Jzt54Ai5vAKBQ1AFkgpwJCA6mOoA7UTZNhTl2jm4tL/cQpTc3sOiZ4?=
 =?us-ascii?Q?Zz4zVYkq7mjKvM7iqqf8tAdn16SNYWFuSXbDjpAZf9MEFSxc8TJoWl6n6QLG?=
 =?us-ascii?Q?6c593dy9pxgdT0bpALUP2RbIA1Hkl7h2LnHZWl7OrB2L8CFzKUmujfxenM4K?=
 =?us-ascii?Q?/yoqc2GeTsJxp9wxZ3A3uGd4LxiSIW1ftfkYQyYP52+FAGbeYVGFqWM7we7n?=
 =?us-ascii?Q?A9pvRaEORgQosrjxD0cxDl8tdj4mbVrO1WJefqEYLmjMm8xcsCnjWb7AJTqt?=
 =?us-ascii?Q?6O49TuG7nQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tl7lku5ODWjjvBnzR6Sz5yIw2uET2atlphEd1Lmg6M5o7ki+zw26K7rqGgL8BU9iyYTKFGUFXAFSIQjNo8RSfXoGDOzpEC/xadXFGstv4WHfAh9a4WD45xhjbonSWJKn0wGRThd3+Tmy+77MMhcvm3qlaMWA5Sdgb4Qu+1YRPLToA0dHxKPnJgIC9rDbFZCHrEbfxQm5K64hMF93ZpRuFpQyq35iZPBp9lrm2BUgt7xjsz8ag/mhDuwMS7UMuA3qvgNrEPryS9A1puvPgOlKPzdUNMv0smiYIF6FU5R/H6x6rmj7gIeu4SNaca1qo1BtHpIO2pkzJUHjB3D7WE6EN0yXzzGhADuxNgyf519x2HaN04yXgYdRytVEqxfbvc3alXxCspR2UV5BC1Hg7TGuKRVQU3dTV32FH5mpy+mI8BPTQSLGHyyOkCRUOF0dLhaYeeEPCNXnMR7tYjeYr6oXH30YIGfp9AlGFoUU1HRS1hL0JHQA1oKR8PD2TbNPyXeJcXUC+O9KwF+/FKmCnyRO/Zy5BDxEsUbMCV5ICsyHx++3rzojKmmdVDqKkbFTxzOlLbhXUklaimg7UsNbk10zEsPgZFi82InJlQkq73WWuqM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f7f509-fd04-44bf-bf69-08de546d80c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:22.3206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: madpjPVwSQKuSYktRDp290Y3D0zCsFHd4SD/23uqSIbfn94XqXRlcvbwxdBtG4A8xiaJJvz05lizELKtInioXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Proofpoint-GUID: 0UthtBlRU-WflBg5xU8qKa-6woHHJX0E
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=696941f6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=t0zg3OoRVwqkdlAMXQQA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX1cX4koBgm4/P
 Q/tlBk815/5GjknB0eB1yW6tQWKevb9xVwSfGMb3BcioK7BTlNLk/Il1sv47T6pcBXMF+ut9aqB
 vHqFo9nY8p1LCuU6TGgaISvp2QGlo/kjRtQK+d/+jfK2SoEhuAqiReYMYne3KECLcJeeJwTPCPc
 5t1DgbHsjlhZtbtsF42IRRHwNLNjI73mvUg1su+BC2L+bEC/hCuJkj5YKpoSgZ/d4HiKjEFiL1l
 ayxtsNZsWfu4YWgMBhssYcGwAZuDzhH7QoFnDbVBDk/rh65Hf2VtrZo1l1nyA5z06AxsYBZc5lT
 MplBkKPwbgWn0cD0HMNhrHt/Ddh7UqmB/2hNcyaA6Ol1DalDVra4op0JApXL/q9tZrLQcvXCaxU
 ENcjWxHn8iCWIdCaR3bXtDWfKUgyHl3LxHIerflGpc32Ug1Hc6PlkRmrDkL3KbDMRfAeo72r2y8
 uyZLF6h87iBqHzbBcGrUonyxWQaGZe7MfdbNa0Xk=
X-Proofpoint-ORIG-GUID: 0UthtBlRU-WflBg5xU8qKa-6woHHJX0E
X-Rspam-User: 
X-Stat-Signature: xxhq4xdhye7p77bbjhbrrckcm39ucif7
X-Rspamd-Queue-Id: 9842C100008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768505852-74752
X-HE-Meta: U2FsdGVkX19Ico9a1lsBPk7CGZvtIQlXh7EMT81a9YP2mJKTBO+he/OLi1BVEVkfCVeYzBuFIaQHk3khHOwM7BnQoobfNAYiF7wqti0VMATzctuyU62DK0eNkIZG61jgO14lF0pvBPLTaObm4i345LXzR+RqgIE9FIUTepLyzFfwBoh3ykS6pvafjX3yWdjHEZIFXjEtO7JueZPKnYO/htdXYVO2k1zsd/pfvLD0cNPL1LZlyEGkeve88MRCmUKoL1B9lJWFyPWusqKLwFqt1FHfzBQhFKZA7WvdSp5YYAvqzNLrxWZ54/EjgvzzPVlilQEuAFY8X15qFoE9KW27lCgaQcJYTs9JOLirw9wCdwRVVAMxK7jrs252zSMDHLbonuqP/srRhnK3juyoLgOTaLtCRIjlXjA04Nv6+WPO4QUfwRC5A1F6aRZhNUPV+AFmAD4JM4YfL0lFSx+lwY0yk75nW8UMoJiO/305Y/D63/Wi7hpiGynL+a1+ZC6zsQ140duMmqjSwzab3/R2322WYJgGTH4dmIf3/2x/uA7jFnm2JG1NTo+9DULaZga6XKpyFhPvPYw9AfOYjA/c9CTekU/KHeQKUKE0TbhvD2HTR/3hgA9y6AJ5tMkO/rxOLTRCxo4WJtVjLtzavarxqow0pE5p/VqR97d29E+liv7KSvOwaOzvSXEUufhBPK252HdcSujxFssZ2HbTGhwk7vzHlrDM5HIFo8eXnVSnpqpJn6UUOHNDYCYyYpmKJsTlHsbYowO3Qc0mXqtGrPQX8FmK/b/13d6tnogzpv6nCS2xuLEomYhPtvGFc590YbSqtE5O1KUzM00N13Agnuu87UFouhwej4wo2Wywj+PaNNnAVfQxpic2g1KM+P4xhAKYoy3taSeTig1PV2XTS7NHHkvELGRZrOWeJnyf8kKQL0DIyI/Z1OGF5ES1cUXo7X986W449clhprfLoTpRuzEbz5c
 DCztTdju
 vDQKaVrgayUHVQgflpg3qosK2AyCBP7TUy0KAOk0gpGzSrKTChujxFL471plaiBfibN+NI6S0HYYvZR4rOYB032fG6Udl861B363JZf6wDl1TCnfYMVlxjO8P2Kyk/1p72Q/vyVj0afDPEnyb31VtDNDuBpPJlOCNi5v0ssjXAxzS2wov8FhqLzSXo3v+Fkz4lQBbKhfLgWNGUDgmKD+SFo20/P4yvEFziHzjd/w12HtgxpymT4raGCJc9q18ggSExSOEG8eiq4iRL/ugqUaswkRW+Pku4hUQOqwt4KWkdsoMq8rP3E5781CCPwlvT4HGvsik/iM3ed6Y74vQNfeINXlJKaPOqjBud/B9mEc6aZ9VDOeYvAnK7EUl2kIpGZp05qP7YFgM9ngwCigPBWuFK1g97F7kHkFFsjDJgefwCD/z2QA0rhNrDvy5v4ME9lZT7p/fsWp/X5Ohhl3/jb1A/PhUncnZRESWQU0E5ZxZILjV2QL1xda+Fh3qcNxAqQgOM7vkf9sjYFm4xXFQ6MsCibCE3mexAAXDj8q06v8jhbP9egQUXIpsjR7mYBlD2tXAU5id3ddOrKOjRd7HsZCi5G3hOQ9xjirOyD8xSLsk54jZaN5qtQmB0dLtpSYnE1l+yP3YDHGjZKKIksVKNxgiiUveb9DuIRnD0SQlg82UTnZILVBNCGl7mvk3gi2GLL5S34tc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Spanning store had some corner cases which showed up during rcu stress
testing.  Add explicit tests for those cases.

At the same time add some locking for easier visibility of the rcu
stress testing.  Only a single dump of the tree will happen on the first
detected issue instead of flooding the console with output.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 tools/testing/radix-tree/maple.c | 172 +++++++++++++++++++++++++++++--
 1 file changed, 163 insertions(+), 9 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 5c1b18e3ed210..85fb5616c133c 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -38,6 +38,7 @@ struct rcu_test_struct2 {
 
 	unsigned long index[RCU_RANGE_COUNT];
 	unsigned long last[RCU_RANGE_COUNT];
+	pthread_mutex_t dump;
 };
 
 struct rcu_test_struct3 {
@@ -33997,8 +33998,25 @@ static void *rcu_reader_fwd(void *ptr)
 				}
 			}
 
-			RCU_MT_BUG_ON(test, mas.index != r_start);
-			RCU_MT_BUG_ON(test, mas.last != r_end);
+			if (mas.index != r_start) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+				printk("start is wrong: %lx (%lu) vs expected %lx (%lu)\n",
+				       mas.index, mas.index, r_start, r_start);
+				RCU_MT_BUG_ON(test, mas.index != r_start);
+			}
+
+			if (mas.last != r_end) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+				printk("last is wrong: %lx (%lu) vs expected %lx (%lu)\n",
+				       mas.last, mas.last, r_end, r_end);
+				RCU_MT_BUG_ON(test, mas.last != r_end);
+			}
 
 			if (i == reader->flip) {
 				alt = xa_mk_value(index + i + RCU_RANGE_COUNT);
@@ -34014,7 +34032,8 @@ static void *rcu_reader_fwd(void *ptr)
 				else if (entry == alt)
 					toggled  = true;
 				else {
-					printk("!!%lu-%lu -> %p not %p or %p\n", mas.index, mas.last, entry, expected, alt);
+					printk("!!%lu-%lu -> %p not %p or %p\n",
+					       mas.index, mas.last, entry, expected, alt);
 					RCU_MT_BUG_ON(test, 1);
 				}
 
@@ -34047,9 +34066,11 @@ static void *rcu_reader_fwd(void *ptr)
 		usleep(test->pause);
 	}
 
+quit:
 	rcu_unregister_thread();
 	return NULL;
 }
+
 /* RCU reader in decreasing index */
 static void *rcu_reader_rev(void *ptr)
 {
@@ -34119,13 +34140,17 @@ static void *rcu_reader_rev(void *ptr)
 				line = __LINE__;
 
 			if (mas.index != r_start) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+
 				alt = xa_mk_value(index + i * 2 + 1 +
 						  RCU_RANGE_COUNT);
 				mt_dump(test->mt, mt_dump_dec);
-				printk("Error: %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
-				       mas.index, mas.last, entry,
-				       r_start, r_end, expected, alt,
-				       line, i);
+				printk("Error: %p %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
+				       mas.node, mas.index, mas.last, entry,
+				       r_start, r_end, expected, alt, line, i);
 			}
 			RCU_MT_BUG_ON(test, mas.index != r_start);
 			RCU_MT_BUG_ON(test, mas.last != r_end);
@@ -34180,6 +34205,7 @@ static void *rcu_reader_rev(void *ptr)
 		usleep(test->pause);
 	}
 
+quit:
 	rcu_unregister_thread();
 	return NULL;
 }
@@ -34329,6 +34355,7 @@ static void rcu_stress(struct maple_tree *mt, bool forward)
 	test.seen_modified = 0;
 	test.thread_count = 0;
 	test.start = test.stop = false;
+	pthread_mutex_init(&test.dump, NULL);
 	seed = time(NULL);
 	srand(seed);
 	for (i = 0; i < RCU_RANGE_COUNT; i++) {
@@ -34414,6 +34441,7 @@ struct rcu_test_struct {
 	unsigned long removed;		/* The index of the removed entry */
 	unsigned long added;		/* The index of the removed entry */
 	unsigned long toggle;		/* The index of the removed entry */
+	pthread_mutex_t dump;
 };
 
 static inline
@@ -34506,7 +34534,9 @@ static void *rcu_loop(void *ptr)
 			/* Out of the interesting range */
 			if (mas.index < test->index || mas.index > test->last) {
 				if (entry != expected) {
-					printk("%lx - %lx = %p not %p\n",
+					if (pthread_mutex_trylock(&test->dump) != 0)
+						break;
+					printk("\nERROR: %lx - %lx = %p not %p\n",
 					       mas.index, mas.last, entry, expected);
 				}
 				MT_BUG_ON(test->mt, entry != expected);
@@ -34854,6 +34884,7 @@ static noinline void __init check_rcu_threaded(struct maple_tree *mt)
 	vals.range_end = ULONG_MAX;
 	vals.seen_entry2 = 0;
 	vals.seen_entry3 = 0;
+	pthread_mutex_init(&vals.dump, NULL);
 
 	run_check_rcu(mt, &vals);
 	mtree_destroy(mt);
@@ -35250,6 +35281,8 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 {
 	unsigned long i, max = 5000;
 	MA_STATE(mas, mt, 1200, 2380);
+	struct maple_enode *enode;
+	struct maple_node *pnode;
 
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
@@ -35410,6 +35443,128 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	mas_set_range(&mas, 76, 875);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	if (MAPLE_32BIT)
+		i = 49750; /* 0xC25B */
+	else
+		i = 49835; /* 0xC2AB */
+
+	mtree_lock(mt);
+	/* Store a null across a boundary that ends in a null */
+	mas_set(&mas, i); /* 0xC2AB */
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.end != mas.offset);
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	mas_set_range(&mas, i, mas.last - 1);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mt_validate(mt);
+
+	/* Store a null across a boundary that starts and ends in a null */
+	mas_set(&mas, 49849);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.index != 49846);
+	mas_set(&mas, 49876);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.last != 49879);
+	mas_set_range(&mas, 49849, 49876);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	/* Results in 49846-49879: (nil) */
+	MT_BUG_ON(mt, mas.index != 49846);
+	MT_BUG_ON(mt, mas.last != 49879);
+	mt_validate(mt);
+
+	/* Store a null across a boundary that starts and ends next to nulls */
+	mas_set(&mas, 49800);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != 49800);
+	mas_set(&mas, 49815);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.last != 49815);
+	mas_set_range(&mas, 49800, 49815);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	/* Results in 49846-49879: (nil) */
+	MT_BUG_ON(mt, mas.index != 49796);
+	MT_BUG_ON(mt, mas.last != 49819);
+	mt_validate(mt);
+
+	/* Store a value across a boundary that starts and ends in a null */
+	mas_set(&mas, 49907);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.index != 49906);
+	mas_set(&mas, 49928);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.last != 49929);
+	mas_set_range(&mas, 49907, 49928);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	MT_BUG_ON(mt, mas.index != 49907);
+	MT_BUG_ON(mt, mas.last != 49928);
+	mt_validate(mt);
+
+	/* Store a value across a node boundary that causes a 3 way split */
+
+	if (MAPLE_32BIT)
+		i = 49590; /* 0xc1b6 */
+	else
+		i = 49670; /* 0xC206 */
+
+	mas_set(&mas, i);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != i);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	enode = mas.node;
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	MT_BUG_ON(mt, mas.index != i + 6);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	MT_BUG_ON(mt, enode == mas.node);
+	mas_set_range(&mas, i + 2, i + 7);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	MT_BUG_ON(mt, mas.index != i + 2);
+	MT_BUG_ON(mt, mas.last != i + 7);
+	mt_validate(mt);
+
+	/* 2 levels of basically the same testing */
+
+	if (MAPLE_32BIT) {
+		/* 32bit needs a bit more work to fill the nodes.
+		 * The two parent nodes need to be filled (they have one space
+		 * vacant) without causing a split at the store locations (or
+		 * the siblings).
+		 */
+		i = 44426;
+		mas_set(&mas, i);
+		mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+		i = 45126;
+		mas_set(&mas, i);
+		mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+		i = 44790;
+	} else {
+		/* 48950 - 48955 => ptr, 48956 - 48959 => NULL */
+		i = 48950;
+
+	}
+	mas_set(&mas, i);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != i);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	enode = mas.node;
+	pnode = mte_parent(enode);
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	MT_BUG_ON(mt, mas.index != i + 6);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	MT_BUG_ON(mt, enode == mas.node);
+	MT_BUG_ON(mt, pnode == mte_parent(mas.node));
+	mas_set_range(&mas, i + 2, i + 8);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mt_validate(mt);
+
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+	rcu_barrier();
 }
 /* End of spanning write testing */
 
@@ -36029,7 +36184,6 @@ static inline int check_vma_modification(struct maple_tree *mt)
 	return 0;
 }
 
-
 void farmer_tests(void)
 {
 	struct maple_node *node;
-- 
2.47.3


