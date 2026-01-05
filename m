Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A22C2A075
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 08:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8516B00EF; Mon,  5 Jan 2026 03:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780DA6B00F1; Mon,  5 Jan 2026 03:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445AE6B00F2; Mon,  5 Jan 2026 03:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA836B00EF
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:03:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81663DDB37
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:03:07 +0000 (UTC)
X-FDA: 84297169614.11.7431C09
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2841CA000A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:03:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OIKFkST2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qNs+lii0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767600184; a=rsa-sha256;
	cv=pass;
	b=UnpQ2UCbPLl1QbA4/6jkU5R2Sy8N7+B795epQ9On3QGmF1PGgLRCBsSbDdZSWBYVu4J8L6
	nzdn68gOT2dOwY4g1SJje6+aDw64QzbGYmMW2Gdm2hxlgHJzGdZ242wihQCQIKBMNVVVkD
	BXkI3AgVYDJxR8CxLB3ljhmAgILE10c=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OIKFkST2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qNs+lii0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767600184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmT2/eimzYvizrkfiSI5RtuA0QTDsOCdCd0UhJgGl2M=;
	b=gHwxUYLIbihogDWjv8DubwPBqL2t12Tr8XjmU40D0BYaYjHjoDqDOtnLbZkXTTU5mqjDse
	XfO1fYc/5drNjJJUUwjOayD+uiMg9GOzRmayIOo2/qE2eVZXuts+UNDSe3i+m+Iz7qf0Z7
	e4PenntmiCvxE49xqKLpMZ+PsYblit8=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60501vox191951;
	Mon, 5 Jan 2026 08:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nmT2/eimzYvizrkfiSI5RtuA0QTDsOCdCd0UhJgGl2M=; b=
	OIKFkST2MIJb42BEy4Q5dSNPtkaqFsKPHFSAXioDOkyJOh+xI3o4KoFEqivPkcP3
	lIKtN1Otn9Z2Pubp+Ln0Q2lbrJFSYoFLRVqZxNs42RIww241LM/jTQfK3jo1NnxX
	w5yuvj7F/kNnX2+4/v8tVPROjHzMvDuq6SDXGG0oEuGwL5ERCyMrrU34T6PLcBJh
	Bd6VKePEwjeL5qwFehBNjLCDL9vE6McnbrTL22bnb60pw0C9+IUPveL2tMKj4xeN
	BALNDPMfG7UY27Mrn3xPLsAlUq2gYG6362WaseRbw/bIgDcPNTybyGbhpMtRK09a
	zh1lbvQYCtTeWhItDswIGg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37sbgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 08:02:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6057XRtL033898;
	Mon, 5 Jan 2026 08:02:53 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj73vhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 08:02:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MW+8hBgK+poT/jeeSPZBRU1fkOMCJr8RfuIDbXdZUJm1GJd25IncXVWKni+T0pMtQijF9htxmXjT+y2QmZuoRd+Fi0PWJ/Lu74DRTaxz95pvqHOiKitao899IhHrpAuBqyrHCb727qbRJl0hQSmLUCQwl0wVu9JUeDxwiBcFmeB8xzY6mDarTluOepsi1eSA65Xb7oijp+gklmnMk89uIQSQPKiVI7qRjXPtLJwnz0zqBJZQK2RqEgtiy1sISeJmY47VvjLI6e1naNATNJdQKNcXqIzFYHCYGyykfph0cBmZ2qsD+SQwGKWvWHufXaZJQ/jnXTco0D4eVfWQBWUV1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmT2/eimzYvizrkfiSI5RtuA0QTDsOCdCd0UhJgGl2M=;
 b=ahBN61g5xPAAo68WZzhCErRdRQq65Gc42n51bkEUae+VhTOyRCAbXHpsXx/CHEr4JAxAM2KgKwyTlZ0pbC0wCm2pCyNuOXS4uHVExnuO+7JdBFBsO4hTBgjJQ6b8CxuAlppLHrrxp8DBK2vnxF65io8KutjeV4swqzb+6SnxYnbtJ1aMY/R+8gFbmG3bIUNVmn4uNDmhdjXg6QP2cbaRkwflD6wP8BCl4AFoX/sa3yXgU3/SfWMYsiMwWp2+sCSIEeDeSBfHQFlxBcirRROteUgJCy9daw+NZrfQ2fyBe1MakYsNtj8T3JseLvGrveWy3nKxquEbJOleffvg4hGZRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmT2/eimzYvizrkfiSI5RtuA0QTDsOCdCd0UhJgGl2M=;
 b=qNs+lii0EI/O6FDGMAr71fly8k41gpPp7P/565NJfqobXK/0Lynli9WjCb3N7SvKP5Bo8cPf4FBgG6PlKJZ6OSEcfDFlLL1BCQdsgoePvORaSXOKbtBtZ7AO1KDQdQFpO94Dvx2mbfEmQgxs6zqzPwIE6a7WcE7J2gVpKZbhvOs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7531.namprd10.prod.outlook.com (2603:10b6:610:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 08:02:51 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 08:02:51 +0000
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
Subject: [PATCH V5 3/8] ext4: specify the free pointer offset for ext4_inode_cache
Date: Mon,  5 Jan 2026 17:02:25 +0900
Message-ID: <20260105080230.13171-4-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260105080230.13171-1-harry.yoo@oracle.com>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0076.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: 07028005-394b-4638-29a2-08de4c30d2cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rEHjR5mgwWlGrCWutHtis9K+YCjNCRYQriu53Lg8plm0dFVr2hVETfgr920A?=
 =?us-ascii?Q?O5fY2GcELTG80WTILR6pUUVedBPwYt7cXvomwJA1d1fgCy9SKURlvogg/eoA?=
 =?us-ascii?Q?ur2RGanmWlNtXICRuRhnPPIyCxxRnLSwiX1+dqbRfqQlED+5UPh4GmGTfkd7?=
 =?us-ascii?Q?ccNsC21M+wJL+tE+8t3KsKFsC6HGJMPigXvG+ocfW1CFMxuA++aVnMt+f8Is?=
 =?us-ascii?Q?KGlxw0L+W79aCialRvF4AZvcZNYEVhDSrgIqqU6bMJUXBN3d+Be0OcpoLFJt?=
 =?us-ascii?Q?VVZ4G4KnvuD7tzr6TVRFCSvA5l6oTHouwjZ/TKHrB3yYni12tJXLMIyW7PrO?=
 =?us-ascii?Q?DJN8Pj6eW947bvUVk52H+XpQgnQa4zPyPYQ35s22wt7e1kIX01mSMe9kWKae?=
 =?us-ascii?Q?/Ul3m9MjnKa8UujMgCLh35Kxk2Jei/P2bYukRJ2jj2x3aaVdoW48CHf2h8+a?=
 =?us-ascii?Q?IMjNW6++RvLXW/wl3Kd5Ev9RwDq6SJyrZfLxrZ1z3nMpZZaELjjmkuLCaslK?=
 =?us-ascii?Q?1C2EZLgZQXD7unHXFYxjTBfkB3gTilVG+EeXR/wIvv+wLMUqjTDe3UmOWoWZ?=
 =?us-ascii?Q?TVS2wmBZ8841Tjofy8ajzo3B8ckcbrCCNU9q4ZG+oYvVx1XeGKH8rcA5/tfh?=
 =?us-ascii?Q?7suOvvCMYgC2ssuGBCoBrcbvjWaLURE841QzXwImb5h3b7V2oGgfUi6bQOyQ?=
 =?us-ascii?Q?3H7YmapNLHgYNYTy1HSLieU0BYFCt8aExLQLxNADSPS8z8AuVxERpaROpPeX?=
 =?us-ascii?Q?FKAuBKhOAx2bv900/JSvzpoCyRubpTl2umfI08K44chE5VbCXSbaItSJWPv2?=
 =?us-ascii?Q?+Xq/isOKk4jGWR/uSUdEbLyW97UqZMOplbEqwhF64fdkY4+jlYoQJO2W7S/1?=
 =?us-ascii?Q?8Pa9ifXq2f9hreGxNrpOzefzqQSr5o8sTqTmDQBTXCv6Kt70fHvkLMbMsezE?=
 =?us-ascii?Q?5z515+KaClo+cCfkTeutG9yTKu8WzPWxvBXxhahJrz3cYk2vJzJkADGr4ud6?=
 =?us-ascii?Q?bxh4LvMbMXArpmHKh9EHot95pxz7VwG9amz6Ln9kVeWdwPQFO9jyRLle/cyV?=
 =?us-ascii?Q?DorY9/A1qrYFw7QCkqBR64I2tBxkQSdqaSHuGE1APDsqPuzt0egsSAY5lO4z?=
 =?us-ascii?Q?I6OhzLpPtZaxxSMmfBByepj4dBY0+O3Oy1T4IoOSNIW0B3lFrq9ASsYmhukr?=
 =?us-ascii?Q?PGoul345LGnnt0UmG4Xecs+CQgYKENIJh29GZ5urAe1eCtZ30sIqPiIEu4sW?=
 =?us-ascii?Q?Yd544PsMDDfxVTY81tFWEHQBN2mcThyKUBMJgaE9iS/Y3o9BMAsDyYeyBX+l?=
 =?us-ascii?Q?dcZHkRj5aE1LN26pgdSpPlEZEUzaS7lGvNUdts3wEisj3ECpwaX0p1ps5a4F?=
 =?us-ascii?Q?tAUJIv2PV5lvPrVK6neFEcxkbB2SkomTzNyA+FrASFnVayaPFtpaINho6Jr+?=
 =?us-ascii?Q?iqY5mxQZT6eVU3EUOInBUCsPRmuXqghW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z0K+/Ew5BlZ5mXv10wsuP42/OzNyMZOXrKMuO2dF60iGIs8bp7BUMjD2xaLz?=
 =?us-ascii?Q?4wPA/1tM8gF3qHr9shsMqKYLWqAW/VjzHN5Y2S6AIIfgauRNQqqnY/cS3YDz?=
 =?us-ascii?Q?EC0PA6FMvQVl+PAe8G+Qgi808U710ZwDqsNl2aH1maZcBfwZSeezoe2cNLm/?=
 =?us-ascii?Q?6VoqPRlj0uKROQKtOrkGXQ2echRqIKzKz2jXox0B2PwN7FUzV+22jiRBH9uB?=
 =?us-ascii?Q?DT0DyJhX1oZ2IYAWalI1gjF4rsF5fBGgm8+H19o+gGMNfeVusAANxMNst7X2?=
 =?us-ascii?Q?iq9ILs9pPL60CNco1RDKgGfjLzTSaJ0pttq42g3WgaY19zBGL8h5jZZx1z8T?=
 =?us-ascii?Q?Fl9zFmeuZZ/czw9nfLGnoXB5NnBaGeDoLXWTUC6VXCQZcZf2RaWmpcE0UUbC?=
 =?us-ascii?Q?JjW+qpWGds90nuE+gCm/iYnU1Z7UA6ngb6TKGly9oy29jFJQzY0dEYw3pdQO?=
 =?us-ascii?Q?l9T/UWBipcctv//Z1vR2DNns61l0FFTbR+QHp9J4bf0Cz/EnEBE7e/TJVBxL?=
 =?us-ascii?Q?51mAigWhtzeIes8UzHP00O1tbx66mWyXPKTCjJDvT89iAs3AinwPxRcs+vGv?=
 =?us-ascii?Q?KidTgzFn61iS4FVpVnjlmXJGAWZG8U0n7IXNGFGhR81jRlgpNvJOyInrRGd/?=
 =?us-ascii?Q?9CJAITGfBJeEYCnepBwm0sHYc961pcWdIXnEfsYdAxH6BLspnTwhiOlhsmRX?=
 =?us-ascii?Q?APi3EOUjaJRLZiBkVZZsqoBEVZltIVEJ7uzqyTwR9YhVMbpV02T/fYXALTer?=
 =?us-ascii?Q?J+2OpWUgIoDinbytcWLzTbvB4ooujM8gbWCxuO9Uj8o1PFzTWRaj+dZ46TzH?=
 =?us-ascii?Q?b2JK1+DH72d1EA999AEz1GaBQ2LAXYzWTq9qCTA8ltCSCh50C4d67VvY8bz+?=
 =?us-ascii?Q?J+4Zs1zgum3nhbkBfQerc4g8qhCl5T83Tq6utTtWt+nxbZxth42GdHVqP+J2?=
 =?us-ascii?Q?5GZMbAtey9/286sJNNC2poxO14lsbrgacOoTGQPROG2NvdN/8Tc0f3CuZaD2?=
 =?us-ascii?Q?CU8uA4YqvAFU3X9IQpTj+mGIqQhRMHhZM4wc22GWG3/pQbEfoInn6JnPDXdA?=
 =?us-ascii?Q?ao66xSD8UQkXtNAgT64GoD55bWJlmC83cJrfZ1qN5juYcdyeIfJtfqaBbbYo?=
 =?us-ascii?Q?GivocBTqQovrNhtcAtmrAkfeMIt/NvkKwgPmqaZncMXxUxa6jvdQRnk7lsH2?=
 =?us-ascii?Q?JKLpjuQRjzdA2X/n5wHoMh8w7N/ku1FS38iIKkub3RuE+B6GxqfyKplQjmDO?=
 =?us-ascii?Q?2VqKzlqFdd8vohjMmtJqskhqlyr1RL/llqOAAOmmBiRgwOw8YkaqOFzi06rd?=
 =?us-ascii?Q?tVOdynwN0soaY06D3mvswLYvDSf8CjWZm+aBPlGezOSj2ejCWLdhtA8GBG8p?=
 =?us-ascii?Q?f8nPmFvlSqY4GCPwdNojtiXW3rEI2ECemP2M/S6/xYJjSNidvQHQDo0R/cWT?=
 =?us-ascii?Q?sha9+kLu6K/Q1dzXqEmDVnnnKY4w4oDIczqN8Th4y2U77XgTCOVN8loQNEUn?=
 =?us-ascii?Q?cxUX89jYsJ1ttRaq0lFI6GepMtsCD1P64n1FViIB46lQTNOLfSKhRxvkL3Mj?=
 =?us-ascii?Q?Lq/GbjmY5Q3tB1VQl1yARq8FaI5YztzPSBVeskEUlespsxtKwRpX8dNNzBLA?=
 =?us-ascii?Q?pCB936S3NObCLuMCIvwXtQ9bIPh6k1xt2l+MJbx//RGdz611cq8xGil5THca?=
 =?us-ascii?Q?WxJ7R7MLp7XwcHwxe09kwlvjzFJybjxv6dQ0gFDvnlY0spXex2cxm9Etw/2y?=
 =?us-ascii?Q?izNyZLPP4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XaWyh8dmYAgw2IKHqPGpKWezODQNYIqfPBtLTxZqSC5n3ubVxo5izcrN0s3KzJmo2NEuFIT7aohz5CrsakAin3B5wb39/Uh8LAY/lzSJI9Pg6U3lCnCBgvF41hLuDMz5fSlQ0vcglx5AjzjOGm9NanFVaOdUlh9Q7opW404YQRMfotnEGtS8VaRInrUcvNZ/gyeyYOKGJigJ0FK7tSGAslHW9YVevYwcprvSKLKfPrDAqxqhqgXYlzMeOb6HQhdXHMY69xfwUtmpK3tg/So4GlPDlp0jhKKslu44yq3U59X9tmB7QBigVG15dcxyJK/m4TEE4YAyxuk/Pco4qWBp0wDPsQtDXQOHTXelsH2qmRwTRQRgmbwvm31BZvEndx9DvO8pkJqq9wokS2XOJCWDmqRpy+T5/jMts/5n3GZJZ4ePUMCSgyP14ag9kLIJO7SwZyLhXBa64dzDm2AAhc275dDf3brztIqz7Dyz/HOy8sCChNaUXCX6fr5P6CdZ1buw7IfqGyBC4+toGA+aMKD8iSoL/S2Th1X2tg+Up/7RzMRZDt4CL63EHKWx4e47Fs23Eo5h0eoBNBRjID+ZTgP5i5gxRureAKDlv9p/AJmZAdo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07028005-394b-4638-29a2-08de4c30d2cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 08:02:51.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGY5vfSYEiO7Zsm/PEo2k8gN8N/t0cEs/CKsFbuMqD+Mi3NsNJGpqblYIDitDJNzhRZv4GglN+RObpz8pee9dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050071
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA3MSBTYWx0ZWRfX5SVcjrjxFl++
 gNGQM7EMkUQKKc9zZi3/Wo2TL2bDOIx8r9dRqc5wbp0S5JjozMBWtgoAai0ESe53uU81fW/GGBB
 J22o7WREG0gCLb+TFL4yyGIIASyePfBLOa5Igrk1MzE94B+oR2F7ZlLJG80LY9MgxvkFVqmIw2e
 GiUQQqxQYWNAEIK0Emn5xXnTU9Skg47/sYkgVfIW9GcEg0dv5BUAiQ7zdx5CHh4VsyPgtW7Jz0s
 /UgNaMFXzHmZFEDlrZOab89F5MOrn8fWFNbAD3fk/zMPxLjHRekFDtvJ73a4Al8t+UcPUecW/8k
 XRVPhWWdaQB6dhdiJsUp3ByzZXe9ovMamCVOxjjygryCTpKzBEGkyYzuSAeQKqE1n/1qbKdhOj2
 jEUdIi8Q+VLFTAbTniubnbMQHkKTkg7ZDFjgp/eU7EsEpepOlrSSsGX+2NZab7dJhTzMDOfXi/M
 ujtljGiaQn/osyQIf5g==
X-Proofpoint-GUID: Ru7UinuyUx9EsV-mCpHxvndGjlEQvXoZ
X-Proofpoint-ORIG-GUID: Ru7UinuyUx9EsV-mCpHxvndGjlEQvXoZ
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695b702e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=47mjobULUKt9l-LCgRsA:9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2841CA000A
X-Stat-Signature: whebjr57besi7b8z81nyirnseusqhinb
X-Rspam-User: 
X-HE-Tag: 1767600183-528732
X-HE-Meta: U2FsdGVkX1+6ixhlWQnL1tEAhANE4XwrylPfFZsK3xht8VSJf9HvpKGWQbfyXUlqV0YmoQDGPEZ7ry1WuQm4kfErgF3Ec2zsNsDKoCBCoStVVx147mgNTME0wLjp04vKJEo6xzNMAAtH2oUjrUHi3iKYodS+x3JKOae/DgBvMqElPGBYdgCS9waUv8ClRbFHAqDOz/e0EWrVj8ReIvseGQJ0zuH4kPI0x0GGE4cT60K3hxA7+tjqRLBfSDsH/LIG3/hO6G7hMP4njRRa6YyZAs0hQTAxhnL85nPfPnYCNfGvRaPK037BE2fS+yrVPSoNFbyRdRzCly3r8JZx8LX7XYUCbOGuIX15GvWUwcCDhMtMAF1UHLSx9QEYAd8NceqOO9UB7xrvVqiNt+N1mEo+1aebFfGwJn1yVq69XzNxR2DlxeEUVmsHKwZlIzggi/442JB3MnZJ4aEXd/4PvPvZRmgUQLrcGnIY69MtgsqpBA4lg8JnMSfz5tn8cq9IF24GF3lTLKflqziki+ZNfnGoER2ibLvrifI05+CgirdYEZLG7VwZczdfCnuFWOBeZ/bqA4j6ROdePTpD6Ef29/Y21eYFFX+osTdLQY+udWZng2W3UsrFqOJsqcP23V8aSzQU7t6PTmjKZRTn4qOgUp0tljp84auqpfHLAadLhB6SaHs6f60cdr69+cJHz77hzWRIIKNlWOkZdMHJgfJpnJr75BWm0+9som7OazvxUGSJGdQm1R18G/OsQ8XK5J9X/IJYGfmDSu6gwLozd0hbv/5FnVyaiyHZZk0ppVc9/wJpno8CO/acPHvkWZbFdiCM+f7JLC//chI9NTFirnR4IKqyy+GpZm3SNkpgkSarNPCUAVE2jkNRwvV1Wbyjy8l/dw9UWm4s+kVvYlbkH0BN3nI4Qj5OeXbfnOeC2Ynk8wmJDmSyv4RXtdF0M5FgRPvfOH0X7ziFc9D/s65Y6kjTy94
 OjcgONzi
 qDx9y4RhuENXZIlKthAYmAMHUIPHN3vW8YS+hZGwnwdrQ5U+MF/k1Rha9MDScxi7IADsVLYLQ/1Roizovm/UWfQO41Azj7MtgEtB24uj8vEWJs08MsOo/VOChiMiCl5B/06dPDCQrmlSaIxeLSwbF41KnrO5H8uylLvjstk76rQxOLkDO67ijrWxd/Hl2vYv7Wyb8HOFH89CE3hYknrVnyUvug5ATIPj7vx1QrYXPNj3wr31JwVQlZoi0Ui5c+gR1HFiAhd1cM5goy1MmB4yoa8Up1W/xtQSBiPOPF6RSs+0f+QKJvVIz+t4Mm9gT6yIxe7vYnAEEkSCnw2goECBd0aqcF0CLZPPGDYOyDkUtapM+pEAOAX05SR4ivG5LNxpeOoO2YWDMwiIj0i7zZQX3+rhpeH3YQNpvZLRKfIA0JE5fmxZk+DKZ3QgBKJQxyKFgzXlq9a6Mne5velxII2WHLBPeIJNK2mlISFLucTQr1/oO8rw4nJbqFxFmkIfgM6HsoctT+lO1GXQH/LfT4p3TZj2w36PsZX3ILVBPYQTMM4z1r52ouLm0GMeU8hKwXwgsKsvyPpD115z6QRFHF1XTgL+I0hJqiHvZOihl8LT9ssB0fh1E33K9Fa+b5Ix+lqoyez8mQIW1jeKx9zkmk+08HSXNmp1SwAHkLoRYkfJF4pQJVbPNpzQThLJR58UrVU/+ybY8RbNMWWkqRb4dPYnWionoSGzcceINzyWQVjtazRi0GdB6u/mPTVgXqP+OGkz10Yla
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
placed after the object to overwriting fields used by the constructor.
However, some fields such as ->i_flags are not used by the constructor
and can safely be repurposed for the free pointer.

Specify the free pointer offset at i_flags to reduce the object size.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 fs/ext4/super.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87205660c5d0..42580643a466 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1491,12 +1491,20 @@ static void init_once(void *foo)
 
 static int __init init_inodecache(void)
 {
-	ext4_inode_cachep = kmem_cache_create_usercopy("ext4_inode_cache",
-				sizeof(struct ext4_inode_info), 0,
-				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT,
-				offsetof(struct ext4_inode_info, i_data),
-				sizeof_field(struct ext4_inode_info, i_data),
-				init_once);
+	struct kmem_cache_args args = {
+		.align = 0,
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


