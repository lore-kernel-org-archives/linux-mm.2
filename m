Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76722D5B86B
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE246B008A; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB34E6B008C; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45776B0092; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 806296B008A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:49:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C532B7FF9
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:55 +0000 (UTC)
X-FDA: 84222897150.16.475E643
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA47B80007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d7wPGaW2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ble/Tog4";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831791; a=rsa-sha256;
	cv=pass;
	b=cOvg7iMqUHGOdgVYC9EPTQR0ZKFartWYRTYl/xCC1BrK+rea/5FAwU99vIQ6OIuW16k/CA
	DLNanBr4PphlhzptN9vv/HaAJgA0lIbVfhdur6UyZKiNXVWFkCGAQ8Hb4CCaeOLCFftFzC
	P4ETScuKtzipvI8RR6ISXEZuRSiQX6k=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d7wPGaW2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ble/Tog4";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpFq1ymArQ2xKqgTVLmb4fljTM+UUldv/8SQ63qpNMM=;
	b=Ls/vvAaaPicuaVbDsHTG/yXxY8Tx4DT8CmhIm7kF+vzrCCvYj/iD5ySWRUttw7JD5AKJNd
	D0rojQtQ8j+4ABJliFvzD78p2mK6hM5+7lcpiplGfiVc/MrLl3Rss9v3bmCTCx6dyOtX88
	54UiiRCalJx7KPvR++N3X7ONWp1IMNo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJCJl52788721;
	Mon, 15 Dec 2025 20:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UpFq1ymArQ2xKqgTVLmb4fljTM+UUldv/8SQ63qpNMM=; b=
	d7wPGaW2P8Uh/qBm5Y7/GIJsfvJ21KOytrKKi1+aiUCaDKnptSLCs5A0kzbG+sWH
	1FVbfywiO/xsM5LSRkTNE/iuYks1ptL7XZ0yJde6UrpCJZ02NvWe5gQwzYCFgdTj
	wyxex39mNjphUMJ3SXGff56q9OEc5vtpAaTaXILr8zqbwo1hV90kxW9hGGvxE1Ht
	D/i+ZinS7LU/5QrQSfaJIcGPj1fZCu+xdVx4rnv+X1eTjG57MnqsbG2b7m8Iq4eR
	P/4lrohI5yMzJ1PW0afTRcnrKx6NakGKohrDTfP+AZFptwMp2bfaFhus/eZKI/jU
	7Q+ZLiMsxEQRCoAgyY8aWg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10prjssw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFJJR1g022444;
	Mon, 15 Dec 2025 20:49:30 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkjej2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQIHh5CoSRLIQBcEi+1l+/nRDJpLqZp6uVz1fcEYn6zWvi0YmRYtrfiYc+yeqYu10kui/YJ5CzB06IQR47BfkmKCapPUBHy+IGrsS/QRE4WCACk/9bA47lQY1Sya6U/fyVMCEGwRaYFhLFnsmlKO+posKSQ2x4RUqeuyiPZJ1xuTpWYX8grjLj1cMG+YARyR9n2h9sHwJNYmg4jLk6frqORnM8Y1c/gQgozKKTDo/aYQCmxraVoSGLkLCbmMfpLAIQ7JrXhVTi9h32zwv1absSq9ZkdDimVLU/YUBB7KbkX0CPPdyX0FB2GzV41vHTHk3vsJ7KRltLgoLQrNEn3PVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpFq1ymArQ2xKqgTVLmb4fljTM+UUldv/8SQ63qpNMM=;
 b=UEN0TmAeTMwAMM+R0YUGgfkSdPeoI5o9dH7DdLxwEvAoZCXwsu6IOz2uUwUaphS6NJF5pAXhZtgarLPJBZevUDXdV3V5lADfsThttU03O2ARIKZU44zOZUaJ/EryR+JHwLiQJ2jNBc6u5KGpr1kPch72nm/FGrV0yfMlvS/o1EvVvsklOG1o6lCsB+6Eo8NbkBNab8xulUTcwoh2vaRXDCC54R7sFa+vQI1I1pb1S8GlSTQ/Uvo+I4pT20gBL9hOKK5UGHMDpXy6b6EUhYZjp+XOJyybnjJKdzWQKCwZ60tuhhgWza4sU/nBAtD3gN/hQANzhJBcD5zLAAKFS1bTEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpFq1ymArQ2xKqgTVLmb4fljTM+UUldv/8SQ63qpNMM=;
 b=Ble/Tog4hjwNzXkRej1QGf6PXMEkDVshpcp1U+7qSkchCN6VowXnvAWvFFyZkrBGFoA/sn5pqblnOP3WRxS/Jo4ifOSSnmSy/DWo7lOVfAJ1wnzNBlyjEWZ3apJ2KbjVNDoiTdrGxtDXMT82MLJQWT87Qx2rlNdXS9CoDrrNVYo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:25 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:25 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v10 1/8] treewide: provide a generic clear_user_page() variant
Date: Mon, 15 Dec 2025 12:49:15 -0800
Message-Id: <20251215204922.475324-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0268.namprd04.prod.outlook.com
 (2603:10b6:303:88::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ca9734-7161-480d-c056-08de3c1b6ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VvO3tlmyOaAjqv2uLFRV3aCq7rGDliS4x43cmWBRlxt9pykhsdQiQJmgB+NJ?=
 =?us-ascii?Q?+olyX5mHQnR8eF0cwAcC4BMQCfqQn0feTTeh6y0XYWFcoMyF06oOGm3w2NeR?=
 =?us-ascii?Q?0Pr0OQZTSAAc7+dg0Z4J9qKzqz06zkCg5rQGfi6kXxtyltafA9RqHq9rl7of?=
 =?us-ascii?Q?KksIsJ5bSrdRxvtziCjezVlsEbf+v6ysSbpcKbpL2L6sZTMy82PLg7/5Q2QJ?=
 =?us-ascii?Q?nBpBiu7W404AwVfUg/2uNNbHs3FELZiGKBU0UdTKonKVtm30eWyGj25TuENG?=
 =?us-ascii?Q?Z/NcQ9sRWVnv9q73ZYbHhAipx2IgULkcWsf+ILZOLAF4BaR9xKI9AnMgGKdi?=
 =?us-ascii?Q?KP7LkQlNpxMOP09jhcn5C3qb9r71IY3KBlcP13WqkiyKs/fxSB1bEben8MAI?=
 =?us-ascii?Q?I7nCEYQMD5mF8QQOftv7OnKRY1K8/d3k/ZcboErqKzgzMaWPoy6I53Q7v572?=
 =?us-ascii?Q?kV6pvQvy7sCIYqMRh61XPvkLHyDRSX8+VRq6rnF89xBJW04vMJrk0nKVqn7E?=
 =?us-ascii?Q?fDHEKsdxu8vj/fSTX1yswbb3D7FiIPvWdty7a2PglOLB+apPXmfWj84gGXSz?=
 =?us-ascii?Q?tgAWuwC9rBHEzZ/EZ3tjr75Loz2jPxc/QT0S+NOuMEGxd4YGcknwqBNH2B4O?=
 =?us-ascii?Q?kCcQpwdPRKUlML5MxC2pI6vYwiZ3GIkNgF5U+oMzM2LQuwbBhyCPnvcV/E3i?=
 =?us-ascii?Q?fHtm293w2+JJc1WNVzJPhDeNbM+2qW+k7u2NeVPWJrUBILPH3TStQaPpyqzW?=
 =?us-ascii?Q?QlYXWwDVOJeQ3w//qQCVL11Dd7lPhpCrd9SABMyyIlMXq5yxe3dE/Mdxx1sk?=
 =?us-ascii?Q?t+y7fbi2YuPTtVSnb62oPv+Tt+rvHVAFhGtboox3mX401+lgY8ZRQJRFXSOd?=
 =?us-ascii?Q?/q1m9vPzhgB7vzX7oEDO4Vnxil6V8feu4bnrGfr+5LW/zdnpjmizYHTCXkhU?=
 =?us-ascii?Q?c07ZUs7rTNOuqz4n0jIeZUs6qPp8RyQUjPiCRtBI88nPd3MTs1Dkz7ghvLZL?=
 =?us-ascii?Q?coeexBbwaoh3xI/o1E3etknoO2MuhWlIcG1WZ0sE7dHmo9At5/+adQ6tzzrc?=
 =?us-ascii?Q?O0xDI5hKA50n51fv+GF49EhBorxCRCqpKY/4MOxz+g6jJZYgqXIZEjpgdlrr?=
 =?us-ascii?Q?ZP074ufM4LRLttJKJlu+90B6hBTAFLhGB7gFAcvD0eCsSRUrkz4f6Engo9Jf?=
 =?us-ascii?Q?z1KZziUqfKG9BOBmwojCdeO9wy32dWwdQSGbwUnwxf47v42a8ugAfqNZ72e+?=
 =?us-ascii?Q?il4rotMKmA5BCLN++Q8KyxpCbUCCBfDrvkqX16q+hg0JFK/n5lqlZr5irBjc?=
 =?us-ascii?Q?BhVosbW+4xFFjlS0i/6qeGE3tXou9rf5X9v8d/0qEnz9zRiarkACcXMQI2xC?=
 =?us-ascii?Q?O23DAocdqVuthxVgux+GOn976qDOOWe2ctK7ezM9egdDI8Bq1zNUMQtUtPjN?=
 =?us-ascii?Q?Hna3vM1YiOeKWVwMPxaJGW9wY4M2fPBZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9atcQdnJA5OttILoslCTYnIk8JmQROgELT0Cd1aQqUhPFQkP9qnZXoNpRp29?=
 =?us-ascii?Q?y/am5ZOOKqXAgm+JDJbKwsN8b4bSW3+lTVq8gKvYlRk6bCuaMfVdNqM0k34L?=
 =?us-ascii?Q?xLOglrkDOmS5ghKe0K3grE6WlXHqJiVNkWmlkD+pRXy55n6QfBUklPM6RCVD?=
 =?us-ascii?Q?FkbTu46n1hqpUWXHSXclbWLRCLGTV3w9/HOiZXdY+GfdEs8mbqR3nxnCnJl8?=
 =?us-ascii?Q?I5AZVBYMXuLUqkyD5kWsbqu35gF/Rka7BiCLgcgI93ZxJO9eXnFYUW10ypGc?=
 =?us-ascii?Q?wKY9OaBpYvfTEZQsR1mmpoJNKI1pq36tUm3tdl/fq6gmOrszNxdftPYteh8q?=
 =?us-ascii?Q?bzgH6e37KNPDMrKW9kin59ux1hb/8Q6aG4rqx/BLNMhPqTRIBUDc3Qd42elO?=
 =?us-ascii?Q?qXjBIjpzgDmkp19rD8hqCBr/xSSU490q3PoTZ38twp2Q2wKwEQmR6ll3sqVs?=
 =?us-ascii?Q?vjpm923R+5ZnJTX+BLU20BdqjymWpZ3zfrtfofesFJ+TsHJ/jph+90/0q9Ab?=
 =?us-ascii?Q?Pr2BCqpVtb4/NnRaJDBXhJuWve8BdWOPIrdmH5MLUtFXIYKA4VptzIcrNAM0?=
 =?us-ascii?Q?+BzFZFTJVopwjc1iMPBWk5XZPjMODILT/72n+eX7vWhmgW3b9wSSRNV67DEK?=
 =?us-ascii?Q?+yyTO84CQRvM2ukmsvbLOhe78I+FmoqU/OlZttti4rZ9c9PeilMIxJcAczok?=
 =?us-ascii?Q?AkWKzGFLvW3NG5quPGtJSl4oSaL1oY6DscuIWTmxBrpeE7Ocpslbhtbn3fVC?=
 =?us-ascii?Q?LQQ0QHSjj5D2mlGiaqlu73kFSba4PcML4LqnPSPTiRH4/3OAH5mixg5ZnENm?=
 =?us-ascii?Q?JC9j/xTasRWSZcgrWbgAP9aYStGs+gHhRyHz/5rFhMSRzO1pYnmXiZtbpHki?=
 =?us-ascii?Q?9hoXPpzvsgqnxsAnJPQddxk64+2R7WlSYdECPZwMJwCuo0UMTTs1NeVFRmcd?=
 =?us-ascii?Q?Jq2SjXd81wV6cjWbjMsZpkL2lSZLTqypJH9zPsdHCVNvnpI0N7TKD8Jf4JJi?=
 =?us-ascii?Q?cI/tUk0wm+d57zhLnuGJjwnk1T1qy8eka6zgXryWuJ+hwatnZ9jMNSCa0aKe?=
 =?us-ascii?Q?sgYhZnfGeDWr9nEXe1GInVj+MjN8Fk4m6BaJ8+84ZKh7xfUCJzKJ/XbmeUBw?=
 =?us-ascii?Q?71P8K89q5cKmTWuNQaeGZVkeq8x0VAm4agfqHDH7GnjsNpNs/QEBkWTSNsap?=
 =?us-ascii?Q?5gs7YbyhNz4BBB/AzqISQfBqgC0FiNW1Ohd2Hk2kXLGu7cfGSSTWdCekVyS8?=
 =?us-ascii?Q?U9tpd7Fl/ueWrUUTa/cqbYSWLF+MorhU8RivkT5hTUj+YtE7LGTeOJuLfcCE?=
 =?us-ascii?Q?KGlnzRMEPzHyjoyDE/xh8JtJ9kO+g4TADvDXDGv3ocDxBaYwnZnPKfFV51Y9?=
 =?us-ascii?Q?qkZCDGBYGbuUCiuQYwEQGp8DZ+OpKPbfYi4b9IsKW/rP4tfxKQ+lu15voFEa?=
 =?us-ascii?Q?QyTepw4a2PrQ/fb9SQw0/v2gzXgOsUbAkN9Tdc+Agf0pwBtyswNdQerT8x/u?=
 =?us-ascii?Q?gbsL3FMvjFJzikInMgh1wskMJlvM78ymkluYcPWDkQnmfpJoimokBPWbZEMI?=
 =?us-ascii?Q?0mQw+5jK39l2MagVWErD9OIgQPArd/23E+AAoI1GTZhrSicPHEGtrZ9/N8Uu?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GAvV+yPkhXUohsHytv/jOi6rmldi7kgY4F8U4J7WeoFGuSrVGtlaWI6qDrILTOwIG9xU2ozVLVe7ZbynD77Gm3baxyadAd9r/xqMcMdDPdZ4q/cWyFg1lK6SZ3nlpOSJGWLDHu9cgly+npgO+NiXB+9g0DxbhpHZMRagPzz7Pv6lC7zMX6vgkva983X7Co7se3AaskLoQ8PYvFeTcpB5HwF6SerhRz2kLsqh3GSCdy1dNx6zCE2BA85zETFd6/SKV1t8AvIqWCaAEj7HecDmZEZ0TVwOaJSfpch39xiFn6RiH7V+3Zl76PbzFkSN/angVBrn5Eo8ByhtBKMFW76+EACcmXuW8wqa7w0VxPrCt1P1+cwu4/cVFX4O0vqWGUPtJg+nrpJkydVMcyMAsQ0HFfdYjBxVwFz1u1uBihjlcZUAASx9TcqBkdaT8533ou+pJX1eyCtsB2pIY6rIMBhdeB3IPMY5MkimzAlj7LSLQIaGxfixfT4ijUGvWyostXoeJWOuLIejP0cXeGXwMuemSZ+HMw3mEO8Dc+MzGqTWBMFCktoJ3m7LWsjIJzqIKb0PMW0VO3rhkg/66hTzR0Twt3lU38ytiT8KAY8nWM4i+6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ca9734-7161-480d-c056-08de3c1b6ed8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:25.5865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvwALTOcoPpvUwUzqDIHSeOFX6MFwISW0ypsrNhUeJ2ysdhlaH90F/IUMVxywEvuI8Pfrc7RGUPyr6+hGKKWqwAbRrFJyYuHi4my+3IvCho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX5Pp3Z+gpCtko
 6BeUZZ/H9vlX1tMPN1tbyQAo8UGUD7p5yoqlXMQSasR7vCRLmF98kILRgFQtDICYM73I05fqQBs
 g0ZdocUTQk8tbqYvP6L+W2B7pqMhMvGHkHF7p2DTbKfySvn8yODiIjs5GD5ceFnMcKWCRdBnO5W
 jX6fT1lH8T/jaCrf3tun0NGGOJn2r/iYiIPXI+qOem6MmBVHnnM6xRtPF/8AVapSiPcXXyFGHXJ
 offlTYsnDaSrSF5L0rUdI3HTn7AbcCaJK2XN0Htbb5Sl9+1e8yGS8rWPCq+cwx/IEdWnnnqU5gW
 K0cPm2p//kGnwwdBAbC4c9lSoQpOAFk64OU4SOk9DSJ4I7byS/EMVF3qpH15uoVdFaP7HudXc1v
 t6XXtU+9w0PNfoA3Vf4YKvd2F1nWlIrljXd8xe6gvUSgbKk5yVM=
X-Proofpoint-GUID: py-sUDFe9a2evjIhZdyo-H7N5pA_qa6j
X-Proofpoint-ORIG-GUID: py-sUDFe9a2evjIhZdyo-H7N5pA_qa6j
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=6940745c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=a41sh9qVG0UgEE7tqUwA:9 cc=ntf awl=host:13654
X-Rspamd-Queue-Id: AA47B80007
X-Rspamd-Server: rspam03
X-Stat-Signature: 997kk48yhzuwh3ihi3agp7k64m8ox8jj
X-Rspam-User: 
X-HE-Tag: 1765831791-865233
X-HE-Meta: U2FsdGVkX1/qR0r+MdsS0JQWe/rEvARSaaTzsXO+Yq/6KsRjh5eflzc0+CrXuOMfDRYgE7d7pDFS1SqSNTRQ+3WWmLcDWi417vC3UVrx9DFK6vmNeBxdnWk3FCdqK61E1wwhkYsrEF5jN9+a8gRQZAAHJbuYBbbKtxbIRLzoF78tGw4MtyrFxyfvZJPujrxHGBEjCZft1o4YyhfI2/irgTfqfN/I69UhLAS3q1hcNKpnsPB5gpMl3+YWXNokWiiJFXsG2xEaa9nTJlAieVjD8dKy0MhFOU2/mdfraZ/pEyDFLtCLWDQP1iKeDL2Pczoik+/l+ifIF7l2i5yK/pjn54CyPlp0toRyOaz0Myd7YdH+ag+CTe9U3MRRuccUj2gYaBHKNpXz3I7PbusDjCMadpoKDpZD+mD5ISFvd8DDIyqeLC1g7i0iRqQPlKTjZPEiVV+NA7Y/MuLqi1SAhkX5Cb7FYhws+Sh01rHKrfRX35xx2Nibu3FJ7NavICt++fhtzruolSnILGwfcLmCSG8YGlkgWoo4tK/IPMPP7ITX6o3Swi4sIrfomLGeZwIxG1MZUBHWw6G4q0hwCD9CN0He9wo+uzZwLojODrXawl2OOMU3XXHFc4eKuhXmud/Ee1OYsloRYJDzYYVzM6ypT1C6eGbqbXwGoLfyhCDQ0XpxwZUleWY0a8eOVVdkK8Oz3EDNuQf+NmtH+lQsERCF5ctRtNzM5U4rVCMXDjMHiroTybxDBG3DYzPcRCl2eWa3VKw2QYFoD/uWFedzXDruPud1MDcnvYPOuRgC/K1u2vzhS+NPu8kXBm2kytqmqqcV6Dqm74HmdlHrJ9f4sxh7Z3qvnWYikTQruSYwlRRQcmah19mTXkGZ08glBQqKY9Erv6VzqflQ4CKXD9E4P17rJ+WMaPD5PfPm8c2Sjtl94k0H8DvZuhmI64FoO/Go03eD85DYmwheIHvzWluCNGDWbw8
 20YROBu8
 i7+hBxAL5+VUDSH36JGPnOb15Wx3/8vPXa7mJOFHNSqFFWLFrEtw6XnH0pwwtdLMbh1ZeC09yrpNgpnwzzt0Jr7zmJ2BM+efHUY6DruKjw7Og8e5pgxkn5d2uewxTNC3It6CtePuA9pcIrjEDnuwN/N5S2Wr8VQsbLI5N8iPqfYxzng4++yg7oxwcDVr/mLLThINaAtU0H4XITilFmGjaiFsI1KicTUOmWplkFg8gwXwXiUBStZY7q1B/dLk2N0HhV3abqueQyi31H2oVZqLgjWQVNYHsA8weLRCtg/QlhjZ8B35fg07dk+wtWGTh/XwWkmeFJHddJZbvTPb7xOxymAQQsPAFQHLwYuWihU7I8nwcoU7BQNA8VTE/I0Jefim9PSQaoS8b8Y8ZRsH+8VGAMNJbfyXMN26JVmJbvpBkphX9/VPA1O6GevvE5JGWCNSqM8PRqlzfREwLKi+X3DQeuGJ6c6zP9KisKuWazueynFMdbSuvLy5PttyVo0EaNbTQ0zZRRaEHCXtFv5RFFoMMSkQwEWWFmJI33dob7R+SS9Legf8lXBlppTzyDPgWsNabgcQbdtQJ2V0X1mfPg4TDo3rrem45pxAjpDuoKcxR4GXijhEsGL+KcEt220NZ/hBBN1V9WQJEgxNYaZRaLWmmrIxqfc4ePRne4/jU1GqIptFulqS8bWooMAR27oDe9CRMzfaVo0OS5R4CkyY65QBI2wbyMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's drop all variants that effectively map to clear_page() and
provide it in a generic variant instead.

We'll use the macro clear_user_page to indicate whether an architecture
provides it's own variant. Maybe at some point these should be CONFIG_
options.

Also, clear_user_page() is only called from the generic variant of
clear_user_highpage(), so define it only if the architecture does
not provide a clear_user_highpage(). And, for simplicity define it
in linux/highmem.h.

Note that for parisc, clear_page() and clear_user_page() map to
clear_page_asm(), so we can just get rid of the custom clear_user_page()
implementation. There is a clear_user_page_asm() function on parisc,
that seems to be unused. Not sure what's up with that.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Notes:
  - incorporates Christophe Leroy's suggestion of moving
    clear_user_page() into linux/highmem.h.

    The linkage between clear_user_highpage() and clear_user_page()
    isn't completely obvious but I hope the comment above
    clear_user_page() clarifies it.

    Though I guess if HIGHMEM goes away, we might have to revisit it.

 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 ++
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 -------
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 ------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/highmem.h            | 23 +++++++++++++++++++++--
 22 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index d2c6667d73e9..59d01f9b77f6 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -11,7 +11,6 @@
 #define STRICT_MM_TYPECHECKS
 
 extern void clear_page(void *page);
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
 	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index 9720fe6b2c24..38214e126c6d 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -32,6 +32,8 @@ struct page;
 
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long u_vaddr, struct vm_area_struct *vma);
+
+#define clear_user_page clear_user_page
 void clear_user_page(void *to, unsigned long u_vaddr, struct page *page);
 
 typedef struct {
diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index 7c2c72323d17..e74415c959be 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -11,7 +11,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 /*
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 00f117ff4f7a..b39cc1127e1f 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -36,7 +36,6 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 bool tag_clear_highpages(struct page *to, int numpages);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct page *pgtable_t;
diff --git a/arch/csky/abiv1/inc/abi/page.h b/arch/csky/abiv1/inc/abi/page.h
index 2d2159933b76..58307254e7e5 100644
--- a/arch/csky/abiv1/inc/abi/page.h
+++ b/arch/csky/abiv1/inc/abi/page.h
@@ -10,6 +10,7 @@ static inline unsigned long pages_do_alias(unsigned long addr1,
 	return (addr1 ^ addr2) & (SHMLBA-1);
 }
 
+#define clear_user_page clear_user_page
 static inline void clear_user_page(void *addr, unsigned long vaddr,
 				   struct page *page)
 {
diff --git a/arch/csky/abiv2/inc/abi/page.h b/arch/csky/abiv2/inc/abi/page.h
index cf005f13cd15..a5a255013308 100644
--- a/arch/csky/abiv2/inc/abi/page.h
+++ b/arch/csky/abiv2/inc/abi/page.h
@@ -1,11 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-
-static inline void clear_user_page(void *addr, unsigned long vaddr,
-				   struct page *page)
-{
-	clear_page(addr);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *page)
 {
diff --git a/arch/hexagon/include/asm/page.h b/arch/hexagon/include/asm/page.h
index 137ba7c5de48..f0aed3ed812b 100644
--- a/arch/hexagon/include/asm/page.h
+++ b/arch/hexagon/include/asm/page.h
@@ -113,7 +113,6 @@ static inline void clear_page(void *page)
 /*
  * Under assumption that kernel always "sees" user map...
  */
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 static inline unsigned long virt_to_pfn(const void *kaddr)
diff --git a/arch/loongarch/include/asm/page.h b/arch/loongarch/include/asm/page.h
index 256d1ff7a1e3..327bf0bc92bf 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -30,7 +30,6 @@
 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 extern unsigned long shm_align_mask;
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 39db2026a4b4..d2532bc407ef 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -10,7 +10,6 @@ extern unsigned long memory_end;
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 90ac9f34b4b4..e1e396367ba7 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -45,7 +45,6 @@ typedef unsigned long pte_basic_t;
 # define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 # define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
 
-# define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
 # define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index bc3e3484c1bf..5ec428fcc887 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -90,6 +90,7 @@ static inline void clear_user_page(void *addr, unsigned long vaddr,
 	if (pages_do_alias((unsigned long) addr, vaddr & PAGE_MASK))
 		flush_data_cache_page((unsigned long)addr);
 }
+#define clear_user_page clear_user_page
 
 struct vm_area_struct;
 extern void copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
index 00a51623d38a..722956ac0bf8 100644
--- a/arch/nios2/include/asm/page.h
+++ b/arch/nios2/include/asm/page.h
@@ -45,6 +45,7 @@
 
 struct page;
 
+#define clear_user_page clear_user_page
 extern void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
 extern void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
 				struct page *to);
diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
index 85797f94d1d7..d2cdbf3579bb 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -30,7 +30,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)        clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)     copy_page(to, from)
 
 /*
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 8f4e51071ea1..3630b36d07da 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -21,7 +21,6 @@ struct vm_area_struct;
 
 void clear_page_asm(void *page);
 void copy_page_asm(void *to, void *from);
-#define clear_user_page(vto, vaddr, page) clear_page_asm(vto)
 void copy_user_highpage(struct page *to, struct page *from, unsigned long vaddr,
 		struct vm_area_struct *vma);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index b28fbb1d57eb..f2bb1f98eebe 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -271,6 +271,7 @@ static inline const void *pfn_to_kaddr(unsigned long pfn)
 
 struct page;
 extern void clear_user_page(void *page, unsigned long vaddr, struct page *pg);
+#define clear_user_page clear_user_page
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 		struct page *p);
 extern int devmem_is_allowed(unsigned long pfn);
diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index ffe213ad65a4..061b60b954ec 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -50,7 +50,6 @@ void clear_page(void *page);
 #endif
 #define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(pgaddr, vaddr, page)	clear_page(pgaddr)
 #define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index c1d63b613bf9..9c8c5283258e 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -65,7 +65,6 @@ static inline void copy_page(void *to, void *from)
 		: : "memory", "cc");
 }
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index d764d8a8586b..fd4dc85fb38b 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -43,6 +43,7 @@ void _clear_page(void *page);
 #define clear_page(X)	_clear_page((void *)(X))
 struct page;
 void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
+#define clear_user_page clear_user_page
 #define copy_page(X,Y)	memcpy((void *)(X), (void *)(Y), PAGE_SIZE)
 void copy_user_page(void *to, void *from, unsigned long vaddr, struct page *topage);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 2d363460d896..e348ff489b89 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -26,7 +26,6 @@ struct page;
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct { unsigned long pte; } pte_t;
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..416dc88e35c1 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -22,12 +22,6 @@ struct page;
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
 
-static inline void clear_user_page(void *page, unsigned long vaddr,
-				   struct page *pg)
-{
-	clear_page(page);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *topage)
 {
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 20655174b111..059493256765 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -126,7 +126,6 @@ void clear_user_highpage(struct page *page, unsigned long vaddr);
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long vaddr, struct vm_area_struct *vma);
 #else
-# define clear_user_page(page, vaddr, pg)	clear_page(page)
 # define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 #endif
 
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index abc20f9810fd..9a38512b8000 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -197,15 +197,34 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 }
 #endif
 
-/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
+#ifndef clear_user_page
+/**
+ * clear_user_page() - clear a page to be mapped to user space
+ * @addr: the address of the page
+ * @vaddr: the address of the user mapping
+ * @page: the page
+ *
+ * We condition the definition of clear_user_page() on the architecture not
+ * having a custom clear_user_highpage(). That's because if there is some
+ * special flushing needed for clear_user_highpage() then it is likely that
+ * clear_user_page() also needs some magic. And, since our only caller
+ * is the generic clear_user_highpage(), not defining is not much of a loss.
+ */
+static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
+{
+	clear_page(addr);
+}
+#endif
+
+/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
 	clear_user_page(addr, vaddr, page);
 	kunmap_local(addr);
 }
-#endif
+#endif /* clear_user_highpage */
 
 #ifndef vma_alloc_zeroed_movable_folio
 /**
-- 
2.31.1


