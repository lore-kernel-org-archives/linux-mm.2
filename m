Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9742BCCD1A7
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 07:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F207E8E001A; Sun, 19 Oct 2025 03:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8688E0002; Sun, 19 Oct 2025 03:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72348E001A; Sun, 19 Oct 2025 03:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C328A8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 03:25:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 564CB16059A
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:25:53 +0000 (UTC)
X-FDA: 84014029386.05.83B0231
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id F0E301C0006
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:25:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rzDsFgXd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gn8x4R/a";
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760858750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1AlFlewMZ2qZPcOkIEUs+m2ZVGzgdKqWpBTamoEzOI=;
	b=G7jrbn3fhjuzYUhGCsDg22W3uv5aBTNbzTebrFBDwbTQVNgCck0ewPh2t9O98V0+nkaVLZ
	c3/s+N60L+VfQpeJElAQqItT1FCx6ykGSDr6/FSNqTjSrZgK6KDbXWPzpvVX9o7BHhRN+s
	slr3BdmDY14bg4ixGJSkz4HqrAN/4FU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rzDsFgXd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gn8x4R/a";
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760858750; a=rsa-sha256;
	cv=pass;
	b=dM6UTNk0M5lx/ok1PCEA7j0I4qlOetK7llPSNy4diGQWI7MjiyGrhVrTEWGPXuCQEJWnQL
	egbX4ol0lZP1hB+sGfUS9Org3wfeHt9i8FcZOTDS0SV5qMp4QEbRRrw955sbx4U1hEp8it
	V9INVwAIMeCCyxzmfu6RE/6uF8UPJdY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59J5F12o015222;
	Sun, 19 Oct 2025 07:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d1AlFlewMZ2qZPcOkIEUs+m2ZVGzgdKqWpBTamoEzOI=; b=
	rzDsFgXdvjYNu5uD9O3RZR6CyAv4zonUd+vmmeS9SLfhcaU2Lbx896VOYzqg9O1N
	3YBSHSFSNJqVsO0qf2sZW+BELGb/0/Z91ssun8+YB3fu0+mnYLy5gtfgKiRWRoWI
	vW4sjof5mX0RJCb8bbBXEyxnBb14VlgxjDQ7XI4CkKOLuyvYdVqMGqrSxVL2FKWr
	DHwDnJ5bnGEQETyvWSUTN9vrySYIAfrTv8pVYlaWlCM6c/3H1cEln29L+9WS4vJA
	WimhOh5s0UgZbBx3bTiD7nc9oR1alJis5VN/SXH9PZlKaqaakZtX+7ZJkPqm5NX1
	py1Za9SCRlpH/o1G4+apxw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2wartfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 07:25:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59J7Fu3G007196;
	Sun, 19 Oct 2025 07:25:44 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013034.outbound.protection.outlook.com [40.93.201.34])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1ba0rgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 07:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8+qQZLuK3CkJP/AfsCKRLJHfWgVzjHx63XXl69Oiz5zTzUwNEBVkrSyd8m6DTfS6ZpZBIv1y4JVFJ9LBFfQmsdaFvxjqjRimtcgoroEK+OTiWpSYgw7GU0ZVLEg1uJMnATH+vhNwwWnV14pCFeQVygsHsEz0wy/EKsAAgLQcy8p49g/IhNdHcHsMXBtGq4FXMnMqSNHkl1P/HENx62hr5xAW5M/OMF4GcRd6lAI4x2FAn04SC5C2feWEcmJZ4JKb7fYRgk5FjwAT4D70mFTs/F1GU+sNM3ewyAI13buk3RzL7qBDkW8l/a4+LuGAJHhVxeh0WchGIjRXxJg2E2Lcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1AlFlewMZ2qZPcOkIEUs+m2ZVGzgdKqWpBTamoEzOI=;
 b=Vk0C2FJVrf7fxl7Siyue6IWRwV19YjroopW5WxX5rfuBuSf0OEhTe4vefNEOZXvXy5uygmamL9xMsIcLvqsNQucjOFSkFN+8/IhQRhIzqiiAjX4PfmdRgVvJ1XBDjPkKLmjGlvHA/kmnl/cdLuctYoCjplbwbTw6ESnOpgmEXRchXXERL76I/lJzCKKFP3E4Vcrj9swS2L9VD6LEAihQwABAP6YeAJ7gVwL7DdbC3RKdMQWHHjgn8l3WgOI12GSqd+ZrXa0pbjc7vNAavB7KVZJjsqjl7TjLOiDLI0EoQSr1JEr05z7SYGsGXwN62EneLQ1REuDCb4ItTaHxCq2GWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1AlFlewMZ2qZPcOkIEUs+m2ZVGzgdKqWpBTamoEzOI=;
 b=gn8x4R/aW3L2CQBCuTYfzoHlBBJTFmdaDY7naHQCqYkc5zVupzoHO7p1iYJsdmrNeYhLaxMMMOgXln1aAO7Ou+Gxh//cBefuJstOha2diVOHYTnqtP2d796kxTHCI0vdUj8p8hZcBPvrGEE9wGfEr4UWEgdqZy43X9b/TuqVRlI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8759.namprd10.prod.outlook.com (2603:10b6:208:574::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 19 Oct
 2025 07:25:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.014; Sun, 19 Oct 2025
 07:25:42 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V1 2/2] treewide: include linux/pgalloc.h instead of asm/pgalloc.h
Date: Sun, 19 Oct 2025 16:25:09 +0900
Message-ID: <20251019072509.9488-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251019072509.9488-1-harry.yoo@oracle.com>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0082.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c4ddacd-d4e9-4dc6-2388-08de0ee0b5a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p71Rc2PTab9yNEJe/sF2I1YoeNvcwXZq/8tBtEo3wdrz7heNfJ2giM1wofOT?=
 =?us-ascii?Q?XVQXrtwhNuFwH7LrJZI0S6dYfsi0rYcVAliDrDHhR1th0HFdg7vBi85WJf7N?=
 =?us-ascii?Q?HuHikkBVfbGWKwpVzTvu6eGQXbusRthRVtz8OvNf3oCDnDPm6BV2XWOoqr4+?=
 =?us-ascii?Q?/kmDgtG4GcIvsH7wTnwuBDP9dSgOZikp+D4LpkmErpspvM9tUiHUVEuqWwTj?=
 =?us-ascii?Q?+pDX1dO7vxQNSqeNuy7QVuFRt3PjKKLWIS5WexkFLuIIDoeTiFTxVhYSon/U?=
 =?us-ascii?Q?5fW38Un0tWw+iIXEhGo0ah0Pp/huVh0mn+HFYt5OvsQXzFNLDSYWL6zouBEc?=
 =?us-ascii?Q?B/L1r9IHGRx8LCgVVwUuSwP5aa80960NLGFqDlig8HEuTlWYDPufaO9RVzN9?=
 =?us-ascii?Q?BivRCvrHOjfX2fMDB9CojhAd+psHzueAZqUcVzKZgJTUJzPKBjgN7IFD7Nra?=
 =?us-ascii?Q?QH0Ivzz83bWRbPIw15PjaZOK+LqVVFnZsz0ChwnZL8SnDGdUroY6MR5pk8Xl?=
 =?us-ascii?Q?Vl5yZ1Cdq/kytyw5xrPoSf+yS9MGWSO3Dg4qaexFdxunxGTDom+PsI/uQ9Ci?=
 =?us-ascii?Q?rsarW8+cGTHJH+GAkg/kUehJ5flSgBePiNUU10OOn4R8m+QIE0VaFZhRjT2X?=
 =?us-ascii?Q?4gCUZvODoRHNEhoLCK/vib+y8ZNcPqCkZsTAqj1Kr0WsKI4A3tJp3mwCHPWq?=
 =?us-ascii?Q?oOn2zp3HzVYRq86WLapL9aeF+7JvzrjNOSs/WlNe03dHShGSqzm+47WqyU1Z?=
 =?us-ascii?Q?BGxWn6xpdRltNod7KbyOXmEweDSF3kpkp9OA3IeYvSoBsDDd53HbnJqXZHBf?=
 =?us-ascii?Q?Csi4oExHooK2FQ557dFOhCRxZ9pekySme8xiDk76whxqmlu/O/G9sm1xqZxt?=
 =?us-ascii?Q?vYKUAaTTGYfBhsKk/YgFcxK1ZAIS3CZGE+Gn0WwbUDjYL8zM835bIGFvY1OH?=
 =?us-ascii?Q?JNJNU+uF4/Rkswbggp+OgIzhyzXcFlXMHf7y9DQ3yxgyN2RLxoqKfOLVhN2Q?=
 =?us-ascii?Q?AL5+F9P0EODlqzIH03HIwVkM86a4CIX+Xnjl3aIM/vTzgTjozLOxJ7n4s+nz?=
 =?us-ascii?Q?wfLevDqQNQyG/bKFSy7+nTLF7BZYGaMONuasaRZEO2Qs4DRZnwtfkvAncX3c?=
 =?us-ascii?Q?ySqhZCZIb82wk3e9nJJYO4N/Rbi30FClGwMT5sxDNYZ2PgBeKTx86q+E8qBO?=
 =?us-ascii?Q?AsF3oY3Rqy6gu4ohqO73ndLS7bMwFZVybJC4qLqcpaetaf8WsQYssdr9Y9Vb?=
 =?us-ascii?Q?eCvAn2W7kTu/pBLcH/gVq2Ekev6oW6ZSt5EAGNnEnck+AET5qjENWX5UDx7A?=
 =?us-ascii?Q?wI0OhqaNgaPV55f8XYI4OW3SWbZkk/WUpOJKhUzi5w7dy1kiVp67h9iTAwAF?=
 =?us-ascii?Q?gBDmYHPWyPJVUkN3EDYvnKsRwwLYWf+mty+9cdzYrSinjagYPanccf1O0dXq?=
 =?us-ascii?Q?VG5tg5/i3NclF4yul01RS5yb8/HE1CEd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p0V1MxCOA7U750xYqNu9x3N7BjpVVaWb8Y1vrogKo4ieurtCv3HVO+h2XO5S?=
 =?us-ascii?Q?QXj2n7zjeOq/SpM6QO1hKG+jjrmva49RwsbB1KoppOXtboH8oiivbGVa85rP?=
 =?us-ascii?Q?3ts+Bx5fzxMucNqKd8JxozoqVWGwVJX1xkgRIiWB2OBmsuZKroUW8yaFE0A5?=
 =?us-ascii?Q?C4e12/L4wjXK9cfgQ2ogCHfdD5uof76gFU6bV5VNQRgcxp93nG4JNVI/Xk+b?=
 =?us-ascii?Q?ixB8mN8sAIeGgP8AfRjnWpOtDuS2gI0jCs8H84x6cUdcbiEOvrCIq+tCsyOa?=
 =?us-ascii?Q?DAr80TP29xr8DzV6a6dVcJJn7mpp+F7RqVelX5A9tqN57Ri2PuveGsw9M0kU?=
 =?us-ascii?Q?YgezgvYjlcSzSRKeOZEQziRsnSpnqEwK5h/tevEQ7hJiVvL4CChJgr73TlWX?=
 =?us-ascii?Q?EtXK4nebTkABf15MYmvvWcPbLkahpXUQ/RnIAOlRkFJsFUDU1BYm/RDqXF4d?=
 =?us-ascii?Q?wEQzau2LlfEokvPmZIcV2lrmKY+yPzpZB0nDMjshKAt0NoytRwtfp+7EHs11?=
 =?us-ascii?Q?MQVakLZC9o8ZdVGZN9NiKMmVjVqLGDbsEWSdqCXKswNgeTBvwadYH/P60bfO?=
 =?us-ascii?Q?FBXRVRtpC7qdQVwCuO9oSRxeygTkZWv2jhaWQryvKpC/BBTUsj5N5QF42sQQ?=
 =?us-ascii?Q?AhcVk4HbmR/q4EJ99uyp/3wkAjbscw+ESEh6boJBr0YTOtp/skzBvKWUyODd?=
 =?us-ascii?Q?SZT1o7Li69yxYfm5HUP4syG/gZK73862PHwcvvWL1cYqU36nZHIH8zMu9XLK?=
 =?us-ascii?Q?9Z49olY/IZpfiKRgn/clYxoAW/AT5A57CpRU7JUFPizSrgwwIllfQIA25plS?=
 =?us-ascii?Q?u09eyGMWzV0vA3/aRVrnFfzTzL6lb2/Rw2IxSG4W0azwIRcKzFZK76nwkqq+?=
 =?us-ascii?Q?yXvFBMrfit3cjbGnRbn49m2XaDZi/EsRAxtDTVSGB00F/z/MhDAiMDQ0F6sZ?=
 =?us-ascii?Q?VqF2ax4M0XHpQrAYQiUHkGsATXO+qp3kt5hyoHMDj8F6fHGvVzVprH0LdQ9k?=
 =?us-ascii?Q?tKRLNr0RtZqSBKww4jqAWdhXl/I3GVt2brYK9nl/5z/8vXyr8rdd2lIZ1khP?=
 =?us-ascii?Q?L8jZ1UzICayMBfaqiw57fJW89zk4bbXbSgT2iE06oGE2rU571TxBRNNGg1NA?=
 =?us-ascii?Q?hkwOqGRL64Cod4p8KhEEZ/1A5CWnYJknrhIKhq+H890kAOVSrGV4LftGT46a?=
 =?us-ascii?Q?ZpE3fqoeD7j9mQ+mAztETSxE5X89TNFNGlyh04ib8YPoL6I3RzO2QWEJuvdq?=
 =?us-ascii?Q?+FHJE0CyXJcax9wcteiIVPyGfdUsD05hfGq5+1uv4r9wNeYjNop5m11UqdGj?=
 =?us-ascii?Q?6LSgzaa6CpFy/F4zrTkM5yMTezFu9pt0Btof+0AL2DGT63oS+ITteGDABmQN?=
 =?us-ascii?Q?K0T+sDG1++Ia2ljMLK0ZHalomrTCGyj4posJxcVIyP3nYH5tvKimtCnMsKx2?=
 =?us-ascii?Q?q7OeNB9lpw3BVnZNsFwKe8T7ixWT19M8G5+n932FnXCkGvQM99ZcUvQtmJwf?=
 =?us-ascii?Q?5+/VaWlZpbxMd4UWHUDppIsm+je1qpxBpgVThMNZs+f3fG6NByCC8KW+SHav?=
 =?us-ascii?Q?guKrz3lUOxXCQmKacuCVpGkV9W7Z2Uh3h/lY4rXT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+O840sByptixtzUp/UJS8t6edxuZ081jlwXOw6XZG2YhZK/KA9I3SNLdumoFCcs9sDkgrput8MLHLH2hNnU/U5luabfFpD3rXYz+9uIMNf1w1yeBo/xcMnWRSCHJjxggs4ePKedZ2XHkkOkYvobd7yZ1Wl3XkDZJupdVfdqjpvi0xqPHjEdPb5coQ2YjWPOmx+lwd5yhH/at1CQt3NmlyM1MWpICExfSkYVmBzPmXB2q7FhwiGKF51nhF5LtHi8jEQRTQCiQ0vBB0qEDr2/csND9jduOTwDPTJqKWQSn5Nb094YiMG6FiN4rEBRkksg4VZ1nHLxxCPEsAjuNKBe4KBuUrdu9/ND0M3mMkxJhd1qLcPux4HJCA33CNx0NnvKDNHPS6B/erLehzbiPBp+ZvPucuJCxMyGtlf2YyvKCdhJqGGlvKryBZVeCya4pWUTUf3VmV1Cf5Y1yDO5SFKHgaQcFX/YM5vrS+DcYeutsoomGRdCL5rsmTSnV0waLMgjan6pwbjewtFuG+1s55ryivouUZbhzyMLLTYnCQqmnHOhoJojTpRROijAUBC+kBowGNTf4AhVaAZUvW648/QE3FvGUbd4/3B8Yq3QyQjyYKyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4ddacd-d4e9-4dc6-2388-08de0ee0b5a7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2025 07:25:42.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5B12zZO9rn2FxUfS3CoAhjtr4SE81pKGFxGNmA/+UYE2kDQVfBCp4i4rRG+WjyITdtYRD+doQafiN6y0DWmesg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-19_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510190050
X-Proofpoint-ORIG-GUID: RMQtTOTltRNXjw_erdh1BNutyYR4H5Xd
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f49279 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=0sROStnqeGfzfbUMjOEA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXzFh4xK7gGkzB
 JxkafYyzxMfyn2zdgH3shO+7RadKlREAfVQ6rKmacF/c1A5bpTAQjaJA8B2v/2qZrXmhkpCiQB6
 Lmc8REAb+n2xchmX8tOyZMBhine2O6Zkyrej+4Leb0wqPkFyaLCSfMcREtUp/dhsGaLkvp7JWXv
 DuucELs2iRV8Hw/8iHi5qvjHC5+IuqSMKroHri0s+fzPCRrKrL1Hf2kxI9pb4MxuyUtz/BNSL9x
 kRZhpxkiHJWwtVivMqV2toGDIX40zCXBybk4AfFNQDA9SytU0n0/W2SU2nTanUAJ1u5QNV6BrP7
 YCiqIOY6VKFm6VU0Y6RtXMQwxHK9oHz4XreKBLLzqemc9wX+IdmBuZrLe82bOe4066DLmjcW1lu
 mgZOQxuUwiNJK/hJWEqt0tIzGXWg/g==
X-Proofpoint-GUID: RMQtTOTltRNXjw_erdh1BNutyYR4H5Xd
X-Rspamd-Queue-Id: F0E301C0006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y9y59taqiywfzcuoxrrxeo7sgyo1r1x8
X-HE-Tag: 1760858749-115825
X-HE-Meta: U2FsdGVkX1/r864vDtfK/beZov0C+9q5fklQNQog/onASmSnvXObvOyaiN9HtBVJV57u8Kkyzm/wvAhopY6qtqK8vdXDP7VYH4v5jwCCja2SPXDFwJdrsGs76hodpFfrf+m5sBSfYdEM5AE9d77Dt0CR2Oxp2l+1Pb4VbXu8x2T918nkxt/RG9dJr5bZxpnX1SFMrj7AqLWXMlKZpT3LQ5HlMLsOxmdGwKjNZUwQ+modaFsDNp1A6lDbxj3gXoUTzHhKbV3JbIiWqbsSQVImmfHNvOm2DaUy7pNAPXCsrypgGci9Get7ooSuRA8ZNe5E164HBnc8CbCjUc+cwEtiMp5me38C+l/xgkT0TrKmMk1ZCUuaQjWUaioab+MTmVRgwgKYR0sw0A+fzJyBjMQojafQrxcCxe27cSdHZaPTjzjEVp9Pp5C3KejcgAdWui46Cw9T0ci06G5SomGov9qHKnQPebI+LTVH1VdoHUbzwLbAtlrtCV7c3x94frRcgQtRH2rOJwrpOybWMB4qF4yxXQ5cupmgmlvrHE3gytmYtGcjoiyuvvhNaawZN2f2v8mQzNkvhQ3hcHrnViW+xVB6PQcUnPnrsJcHGhWXTndqa9e7LfEDiRnK6RPdzX7BdErB6+688RJPBkhgp484BJURgbKd1d7hLQuARX3BHD0TA6VDxmXabC61rGQQD7Tf0ziS1RlCniwRYgQ6CPbXHtg+bgjWiDiAkqZWJCtuB5cvAb4tyd30vjVbu68sTmrgrQ1fTYseBHJwt6q7llkLdFzZM3SM+4F1QwJAH7z/OJ90zEpYphn4yCXRNUtYAYTfkHCoFje+2AMQ1jkKTxWWfMmkW0nwzsHNxUiOj5cQvrv1lmZdbLZuFO7HZBu4Gdy+aUisOKBOYlvLNYf6PQ7L1yf9k+2O3Qa3uAu7Bvnv4CghAtktMnMdKt5XZwhUUXbJz0TOIIHHGV22p/aNh/yB2lm
 ch9lwkWE
 7bvzbLadayJ94U0wwL8XL+XTDMScJxtPSor8crGTGTi1fdvc7Hm/mg15vGRkiVLtRjPgMrJiTnEghWli/nmuJ9/MEur2ADnlEsUVTwjIrkdTu4vRr90UGc4KteFNYWz09P+ZsrPj8cNFCv3s1J5MvbFHvhDRXt20xjjkZhKDEoKfjR295mna+UEAwfE4nEfV0RwutOBqZLGHZRJZvWplVL58vQDfyZBZ0E/elDE0dwioLi2wjLZvVdAN9lkm1XJqWEerg4HesiKDGt3BOXGE3HtZZjqiRmRltl518RMJ3rb5VMvyAbQC3uDeLEHSHZSwjK/v1dE9IcrNJXjQ9CWMTD0hyE5/4thA+YiA8vAjfRYcUs0wRNDe1BsotUJvZq5ESgrG2V1UgYzpCyCJ0S0H9PaMpGmG19a8/WT/j5tuOmWYTInrJejMv1kIPlnGNZgc869MdyAVG5NZgage+fMdjlQmM0YwGl2UIRbpqMnZ6XHjONKAZV1uO8e7ra37/QCbxh2BIVVyKrZDPy2ecgv8v/SC+zYzuRZSQMtuY/bohzCM9kZa+if9dJR7f6moAkKTr38teLhjUwGKlZiBPwAE7O7zKXEsk4ZBEGSHiK4G8qmOOOtY+zfKHbe18W35LXz2G3Nf+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h>
is technically fine unless the .c file calls p*d_populate_kernel()
helper functions.

But it is a better practice to always include <linux/pgalloc.h>.
Include <linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
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
 16 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 83092d93f36a..2e3b5131df32 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -19,11 +19,11 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/pgtable.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 
 #if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
 #include <asm/ptdump.h>
diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
index fa71cd898120..5b8d72885fee 100644
--- a/drivers/firmware/efi/riscv-runtime.c
+++ b/drivers/firmware/efi/riscv-runtime.c
@@ -21,11 +21,11 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/pgtable.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 
 static bool __init efi_virtmap_init(void)
 {
diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index 129b89fe40a3..7a791cb35aea 100644
--- a/drivers/s390/char/sclp_sd.c
+++ b/drivers/s390/char/sclp_sd.c
@@ -17,8 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/async.h>
 #include <linux/mutex.h>
-
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #include "sclp.h"
 
diff --git a/fs/dax.c b/fs/dax.c
index 89f071ba7b10..1c78fc02462c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -24,7 +24,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
 #include <linux/rmap.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..9d48646e659f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -107,7 +107,7 @@
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
 
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..25a823bddb92 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -30,9 +30,9 @@
 #include <linux/sched/mm.h>
 #include <linux/io.h>
 #include <linux/vmalloc.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 /*
diff --git a/mm/filemap.c b/mm/filemap.c
index 893ba49808b7..ffcdf4f81d0a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -48,7 +48,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bfb52c564fb3..b4d18172cd53 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -39,9 +39,9 @@
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pgalloc.h>
 
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 #include "internal.h"
 #include "swap.h"
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 86e672fcb305..1ea459723cce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -39,9 +39,9 @@
 #include <linux/memory.h>
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
+#include <linux/pgalloc.h>
 
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/setup.h>
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 96ee2bd16ee1..69d71e048e16 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -15,7 +15,7 @@
 #include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e947b96e1443..cb2245085879 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -21,9 +21,9 @@
 #include <linux/shmem_fs.h>
 #include <linux/dax.h>
 #include <linux/ksm.h>
+#include <linux/pgalloc.h>
 
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 #include "internal.h"
 #include "mm_slot.h"
 
diff --git a/mm/memory.c b/mm/memory.c
index 19615bcf234f..449d3c312fcd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -80,7 +80,7 @@
 
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <linux/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 374aa6f021c6..247e3f9db6c7 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -9,8 +9,8 @@
 #include <linux/smp.h>
 #include <linux/swap.h>
 #include <linux/rmap.h>
+#include <linux/pgalloc.h>
 
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
diff --git a/mm/mremap.c b/mm/mremap.c
index bd7314898ec5..a7f531c17b79 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -25,10 +25,10 @@
 #include <linux/uaccess.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mempolicy.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 0c847cdf4fd3..7b50efe9c477 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -13,7 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <asm/tlb.h>
 
 /*
diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 7e9455a18aae..ec6fe4eb2644 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/hugetlb.h>
 #include <asm-generic/tlb.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #include "internal.h"
 
-- 
2.43.0


