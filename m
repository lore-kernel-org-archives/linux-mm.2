Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF332CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B248E0007; Fri,  5 Sep 2025 12:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02768E0001; Fri,  5 Sep 2025 12:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAA88E0007; Fri,  5 Sep 2025 12:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B72168E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:26:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FD251402FC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:26:23 +0000 (UTC)
X-FDA: 83855724246.02.5857B68
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3AC8180015
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:26:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IyX9kK7K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NWPu4MJr;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757089580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hKXuxo8ruVrwOChqtyJP+61b68DZlevq+XMkSFY32Q=;
	b=TjrTA27qQtHEzHOioCeATTDkjsiMxMrPKIafnaJ6aNdKAwbgzY78PdOffqr4O1GU+6cWU0
	U5xxdzvTWt38N/Hme24Pp3acT58Ky7sUY8cIUWVHL7Zj3DHykxsayVUqGhF5OzrTp6Dtdk
	YiAUEX+9kEzU/PnXOHmjSmA/ABksgzE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IyX9kK7K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NWPu4MJr;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757089580; a=rsa-sha256;
	cv=pass;
	b=2QaGgH/XVCsyonUTAdvjPw+By/R8jxlbZTpwVmvgexUNBqsZhJvJNxkgHLljqtDpOk65X4
	TiHAroQ3qSW/B9V3xqLJ2podUWafDxKXEHC/CZil6oI0U8zjVYEKCUBQapiTkOdtkP5Sv/
	KLp2WO3zBV+FTINclnXVxvZVdnUqZck=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585FEauI031966;
	Fri, 5 Sep 2025 16:25:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8hKXuxo8ruVrwOChqt
	yJP+61b68DZlevq+XMkSFY32Q=; b=IyX9kK7Kkg3DAndMCTd51BIZ46u/9NZnxl
	O8bYnxh0tp2GXpCYO3RCoD6itIEJsKGbxTjkAlrUmN8v6WLwUIidqzr15PZn5yd1
	Dz/T4imV/6aIvNCOtIX3A7h77q6/4OHQLITJOY74n++P7BqzJwkf0a4H3NVwNNVC
	yshWd3K2KB3C5/gDAg9dagoG5Usg0ecanuKrvGCIrwniodxxMJMwGDBKypMDG11A
	yLWc6Gn8a8MusCRlz85wTiPq6Nq2xGnNFJdZOwr4kt0PwVXmCLf07ikXFB2ncsJ3
	6ZftE6SS7mK5+nyyEIPub0dTl6r72LN66bCD0NG7gNZJTXZKHhHQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4902b2g4q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 16:25:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585FFvUt026130;
	Fri, 5 Sep 2025 16:25:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd7c2t-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 16:25:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BrnefgS17YfE9rmPRPiSktVFFm4J26eRcnYMsWbLBVv/jKa8bz+1XacOQZV1UI8tC+FW9Ey5dLHjx2ZE6K6H+lfw8ITKiweXc49LUgC+L4qgM0iFYIyfy6gHQiJ2sdYrXHZ33ue4WZQU/lG68nI3hn3qknJ9ag+CvLrAKXpfH8t0Qc2Kc/JGdmimzf0wvrVZuK77r7bKbpr4zcpAj2TSABkjNNBLZsmaGgZQYbDYJT2pVvFySmSjJzEyR0YsXwKtH2Jm+xBgJkEf/vHnyNbeAg9qQdMX0HPvAzdl7OhsghxtrsrGYZI3gpNGhu6R6amxTjMVrGGNPswdbOkgE0b5tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hKXuxo8ruVrwOChqtyJP+61b68DZlevq+XMkSFY32Q=;
 b=NgJg0msnDSFFZRX4EzSMtTQVnXLtJzvRd8L7DFr2jT0Xq/AVKW+2stz9MEYszYPCWm7zNHGupctCnTNfvj5mhp/90Vn7Nm3jonKL/v8l6hapgz9Orq4vSgkEYYymUk+wONuLS3ccwp0Vl26mrW13wboaXyHw+mtCB/7yQ8VZT+6W8KXwxEOyu0kZGZ7MX5JEsTkxRJBhkwfp4qp8xWAwQ1NecBxENxd1gBVbXpW70kejc8FrM3AmWVpo4nrzBvc7VGr2DflbYalg4zIp6J4xoDa8Plk4z6UaEA0+PavbSla2JvjyxlBRUg+jk9+9ceMeFbCxYMPUVVoA/f4rA/+E+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hKXuxo8ruVrwOChqtyJP+61b68DZlevq+XMkSFY32Q=;
 b=NWPu4MJruHQZ77vB0AIK58LHTQxC31ayBOrsE+WfzOsm4eb0ceev/GoJabL56SYIxdWkrT1pWnL5XQMmSI9mgRUEiDynU9ZKV/bUBkSANWtGv82fyJrWyCHqb+Xi6fFJyU1Yf1wr2vPIz1nSXC6MklYyG1Wv89y/Ws1zjA2pxww=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB6805.namprd10.prod.outlook.com (2603:10b6:208:42b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 16:25:49 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 16:25:49 +0000
Date: Fri, 5 Sep 2025 12:25:45 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com,
        "Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org,
        osalvador@suse.de, nao.horiguchi@gmail.com, mhocko@suse.com,
        lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, jiaqiyan@google.com,
        jane.chu@oracle.com, david@redhat.com, bp@alien8.de,
        "Meyer, Kyle" <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        Shawn Fan <shawn.fan@intel.com>
Subject: Re: [PATCH v2] ACPI: APEI: GHES: Don't offline huge pages just
 because BIOS asked
Message-ID: <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Luck, Tony" <tony.luck@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	surenb@google.com, "Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org, 
	osalvador@suse.de, nao.horiguchi@gmail.com, mhocko@suse.com, 
	lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, jiaqiyan@google.com, jane.chu@oracle.com, 
	david@redhat.com, bp@alien8.de, "Meyer, Kyle" <kyle.meyer@hpe.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz, linux-acpi@vger.kernel.org, 
	Shawn Fan <shawn.fan@intel.com>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLsHh70jI6BGHjaN@agluck-desk3>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0491.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: 72de98cc-abf5-40bd-8701-08ddec98dff1
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?IDcpLhPra3wdy+L8Y86+Ej5zAxetd2onYTJDv2S9P1aFtXRWwcIjv/qQ4lc3?=
 =?us-ascii?Q?uXRIT54ZUAyFd/6dezNlgYKR0QJOOOVPnSdK6KRcSDS6d/cCTgkT9wS0zeYZ?=
 =?us-ascii?Q?lWbBVB3WSvWrJSvDf6bLYwp4ihGaiiGFo2aPxCBhcI9lt+BZTspeDvUBsj3r?=
 =?us-ascii?Q?CcMW4DJ/bqH76G5CBGf/pNfrLUboxgxui9oOVBHlksxvOVT3pDXpLglov7WN?=
 =?us-ascii?Q?0eH8pR7nnNc9d5CDmi++UJxa68uZwzhbUshg3VRQ5FausFgrjx0TxComEzHe?=
 =?us-ascii?Q?ghm9wpxocdr5I6bVn0y97O2c/Y6Bun7IzbtgoJc+p70AsJPDhQGYN9U7ud87?=
 =?us-ascii?Q?mmTzqGm0nX2cee5bK3bKolueOv06+eE6VMkm/l3/VfHPH3DICbyZeoJ1683U?=
 =?us-ascii?Q?q+T1I1aU+Yh91XqGGkjLKMbTA+xIJP+QtYycxIe0rBoc0ICGe3NoQxuYwBCb?=
 =?us-ascii?Q?18CcWE5XFk8CV6qpRxMFcMe/TVRqO5DoMxysywwhHo3oNrJ5/kiMY0nEScA9?=
 =?us-ascii?Q?ZJRlTWqZtr+AP64hIw1ODFhiLzGIrQKeXYFeTZakjxMp3akkP9s9sRD1TdEe?=
 =?us-ascii?Q?3nxzPPiOYJTkUZl7o3YGT1p974MdhbMQKt5wQBj/rmbNdo8pP1jM/a1lF1ln?=
 =?us-ascii?Q?/tAlBQftLvIMnOshXOlk3im0stMj6J88lQ1GVyVpJpm8y/OOr01pDPJdQPdZ?=
 =?us-ascii?Q?RBrGCbqZZVy1gg/1ic2FLsP8zCeDcecTUG9eDWt/Le9k7DqLO/uDJXqUTp82?=
 =?us-ascii?Q?a2odSYVeCFJed68t/I7xXszhYC/bZ0G+YK9lK25VIHvqCSrD1aBDbLGwec9U?=
 =?us-ascii?Q?S6Qj50vbsNOOY73yhmSXezf3/TcESnvg3NICJ0hp+bXwlJxdNslLUYJlQyrg?=
 =?us-ascii?Q?K4hcYZ4b2K3vUZo+CV90DPYORnr6Z5CNlIIoLnRiumUOGfh98YoUJPMi/nVU?=
 =?us-ascii?Q?4DktMc9TuLsLu/pgr0XGUBx659uFyId2xlalr7V968vrzzK+P/78H2lCmvav?=
 =?us-ascii?Q?JWlxa81s17dUiQ7FVuclfnUfGAaMvGetyxA6qfOg6FT4Nxm0Bv0OdUw/l27e?=
 =?us-ascii?Q?HVTkCy5M9hygUBUAqG7iUzpxz/N3WhOmdJFbGlfdbckbpgUZQo3bQ4dtTybs?=
 =?us-ascii?Q?KJ6KEL3eLKMUsn1xGjIrsrnQWU2+goibF4K7j59UnzLskwhtkh3zph6gnQ3O?=
 =?us-ascii?Q?5SU76e/13bxF7NPK1ZlQOvqHRiWQhPM5IDUpXAlOr4LWfLTXOIyCZvlJcoXA?=
 =?us-ascii?Q?yZhH/uK8m3tmz62d246uVE1XhKXfLoADH4upcnFZQdGhRlQOahlplf7AEdoo?=
 =?us-ascii?Q?gSSOD9+l0nOhAmFMwLvlDf7LooP22eCPb4dkk623fO93CGe42q4ExHaCFRRh?=
 =?us-ascii?Q?HXDWjTBAzlUNcl32k3WrUAJhIILlxDOTJEsmuz463Jjyzy52jHvAjmtct5VY?=
 =?us-ascii?Q?IiZWABrUrLI=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?PY/HAs34Bu82kkYf19viJ5Ehlg5EQr8dd3xvuBwSfXfjOuExOXbtkjG8TcSg?=
 =?us-ascii?Q?yLIbRg3DV4m5t+L4V9y2doIsHVBQz4ufDp1SOCPSml7xG1pFUVKwn/4VAjXC?=
 =?us-ascii?Q?jVbjMVrZ7hAMWSfB8fOjkxRHAzKbf5fcJl6iKuZHFynRXm1Y7VWeosC6ppWG?=
 =?us-ascii?Q?/6pDqsD15C4UjLR4Kb011Nh/X+uCUrmoTtO2zHHGEDBWXPOxAI3D55vPp2WV?=
 =?us-ascii?Q?CCF4OxLr7cTpNVSeHBgGcC6h4nM6JRRBzpzTe2CXP+YgqdW6QmL58RHDkcF5?=
 =?us-ascii?Q?YTn6GtD3dFcHgYYfRUFzaNn/yhNF7wFzt+Mvoavw1kzoGJEpQTMJ4U+hqUT2?=
 =?us-ascii?Q?2L1B9cTse5plKWk74s5uUuk4QRizitrwUWJhEkrEAH2pECNMZ8sqb/NJ/qZZ?=
 =?us-ascii?Q?3WHPEk2LPLMCarOhxn4RtYGq4T0vSBRSEq+K2znZHczC4BMF/BdIZCAP81dk?=
 =?us-ascii?Q?QRrQsMXAqU2Aw7Pa6Lt+3QtRCeBN2yaBlmIArWB6x8aSg/sNDTObSysWQsdM?=
 =?us-ascii?Q?3mc+8dQj17Hc7x0WEcMun0+qUHGgwywGE2tx8GYyo4+uRl2xbjeH1MAmgqKl?=
 =?us-ascii?Q?wsNSndEJkYtyVjgAWJZazBT806iV5DnwnxsE6EJDgOeQQADmFfeeAaHDIEms?=
 =?us-ascii?Q?kUE08xa/k2byGA9+s+4O2Uy/iNzbuxxfTpsMJVJRq/UbFQzYoF5GK1zdYuvK?=
 =?us-ascii?Q?7QZg08lR2o81P1+sOVcjYPFS6RGLAN7Nr/ZWuskFk0N49Oqn2NL+fQvxlz80?=
 =?us-ascii?Q?0/2nYJwJvL+zUqHh8pAABXbN/2dkv6WFdNgTDfNPO3wvcXvuvygES15BbsSc?=
 =?us-ascii?Q?zY6R0ldaW3cZUDooSvKTf2wYk/iQ8GhbM+Zj0IOrZpVEqkk6ro+qOQagPc1W?=
 =?us-ascii?Q?IOnKw4cGIQlCrd9ZtBuIINVcm7McKqaogAs9qesbmbQx5jfL5dDomNXMGzph?=
 =?us-ascii?Q?+KSehxL/wsfl/Nwp6rMUSwWTC1BWGIfS1PQIKEb6v5nGeEKZWdVqfCnIXXxq?=
 =?us-ascii?Q?BFRRe1RCSXSHt7EHyx3ZhsHAeX+fVWa1QKaMnLzKfeCyBuGtgL4HlU3071cq?=
 =?us-ascii?Q?YuFyO3AAMSR8NxRewkqHYny1BvIZiHqzAAi6mkVdAubkwDNlRW2dEOIqyyed?=
 =?us-ascii?Q?pUJK3I8GoQ5RuZaRUH4xOQoBomk8Q6t66kMcnXOR+EHsGNK/GTfKL9sO0eqj?=
 =?us-ascii?Q?+4WGWjwIonDClf9/Xh+RV89GVQqKvcckvRlSp0U9Dp/iYtpuAqKeY/SFe6/c?=
 =?us-ascii?Q?cp3LfJdM9gsIAf1Z9l7JRms8IKl1sbn5xOOgAzUD4grkdt2BotyEfFQlcxlm?=
 =?us-ascii?Q?Howdx/4FOsgoIIUpoFnRJT/pHWvSr7m+JDellzhSjnSSISH2mP4G0JM3rXFu?=
 =?us-ascii?Q?IMm5BD/yKpaFAa9XgMcy6plJPU4R2cwJ07dtOm1xIIERm8eO2bJ52Nb68ia7?=
 =?us-ascii?Q?BkQK+klkmyqv0K16KRZ91n9UL0+ENSwnCf7Y+VBmN1N7Daxnk2fWazeeFeAH?=
 =?us-ascii?Q?cE6myBVhNGWcwO6g3O5uL8supfD6UJeqslNC0ajilJmdHNOBjYxZCSBTqYZI?=
 =?us-ascii?Q?jCj78kdRyrGFRIg1T3oy/dc0N6DzQ4/MkfCT7D0K?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R8cmeC4+nb6Y0oWqr3LU2ShplB/Oqq5dHZ26BwbURYi3pqJZLpUtZMznopI6FBALZU2387RnkV0662feXuG34cun4v8eJIY1GyMvsmOv29SY/u2tuF9RViZlYf/837ybZC8AwuJwD/XU0qkA1lx6o/M/7H1Ylp7EtWKMQ58JTrLAu6OqcvZV8EEOG40vCq3n97zYlDB5Fl8PxfbzkrggkZEwowrIdJh2QRH59Go/bFlVK36+oi4RMBdyRwENu6KnpqfUhkSzdT5Nj1t2aGJU0pDjYJEZ6SHMq3DH4I3Hdt/GTfbAXUTfYkXFNftJesUY8eScLhk07sukeaEDjAvTNnipj0K7bKGrA7o8Z3gyA0xTl6xMmXUkhf1AkIQQ0Z2vrEugI29f9huNIOUVk4rKjN0pAob+JzUicUOUZQ+JmwwoXPhLknwZcQoOsD+2sGFtnEJgxEfpGSXQRJ39MTBnEw9bxpdYVB78IDdAJse7dyZgEsWTZUkcfQUFQUmfU1jUlxXxUk3YqWdBOg0bCw36LQvEzyCQ1v6P6UNfYPlsqISgelEY9o6BAFwvfdnD+FEin2SD9GVhILFq7MDqidzT2BzRt/Fa72EMWn1ohfIlY/E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72de98cc-abf5-40bd-8701-08ddec98dff1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 16:25:49.4616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6dQJ+C11gJCNHJVhLvlBhh4oxSkR1TTIC3oOc8mdKdXvaDIaMTnjLZ6211axnNXdUzLEyJg2bjwUr/eUlzqrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050161
X-Proofpoint-GUID: IVcozh4_I19KPDFa5m9iZy4xNXMxxM-K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDE1MCBTYWx0ZWRfX4hTgoe7V1H4x
 78vYEKjt2KBSAjf9Yai02CNV6+ACLlhWwv4Orhm2BxKCbSIswvg8kH+CMxizgRUvdk1qxR+uebT
 lBKCePzvr9P2axSf2KDQfkJ4iQQxB3uYF6qgEZjJOsRV6AmqWZE4UB2Mb8H4UMfcEPuF5YW8k6m
 xthCQq6kE2AxtCl32MczvGBWvEfKwpp1RnTKyIrD8ylNuXIguMU/eJECcGTM/LFyEu+EvUlvRl4
 xlHu2FuNwW4uoUQe//Sh7I+QagS4KTuCgqDCb2Grrl3vKBddzSkpf3yQpfjG7q2HonmEHlJYlLj
 FwvaNppafpujZCgJ1BuSWbvfDjnUTCxgougbEnfVgNYYvv+RNYNWIo71B/JWdgVR/22r3UZaEYO
 9tmmCILJ+VKrhAdt9p+ZF+aazFUU+Q==
X-Authority-Analysis: v=2.4 cv=X8lSKHTe c=1 sm=1 tr=0 ts=68bb0f10 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=xK0TI8keu1a9eb4zSekA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: IVcozh4_I19KPDFa5m9iZy4xNXMxxM-K
X-Stat-Signature: 9f1j3ht1jmn4dgpq3fn7pnoz5eutkhd3
X-Rspam-User: 
X-Rspamd-Queue-Id: E3AC8180015
X-Rspamd-Server: rspam01
X-HE-Tag: 1757089579-159036
X-HE-Meta: U2FsdGVkX1/mNCjTehV2k4Kdf0/0yG1xNZxx7yP7ZMZ1BfAv73ns236xPotB29ZJVXYlVAqFgiJJV2GYuzXBbrT/eJzBzvDH+Rq0Q4smdfJI747/XMx/8RPf/fdaX/V6AxZ06bfp2alaP7L/GD45dKxjGrhGKUr5IRRKK6cycwpOeLQUFaYVNjc/7VLZBoj4W4otzMAIPDaTMDjNRX9OlIDgwNkMHDbWh758UHxAbeZhW/qezrMtCpOfJ9wD8MR2FiKJb/X1hkp7Zk/Y52Ja2zR27OiMgiqplMWz4YOe+Fm8zMIChG8daqYFeiWCP2zzeX9Q0FvXjPTVUQstjSvbIEcwsVFGHMOyuSCYyHVrjnKX2BhSs3iIis9OGmHKz3bXMR8OzQ1NuMx6KGQtQOKPx7qbIZAq5TS6XWHa/H/gvk0sQ/sN9AksSw5RRmX5yN82XwZUzpK9HJ+h/Py+ZYebYG/bROZjrV7g9rMpT3b1xeRYcKtcAB3NjRCZNqzIa1I3u+Bi13/Trqxk4UkuW3zQr9AYA1L5yxCGKynMB15MNylz6oN62Za63BYM9iaNVmeEbSkk8HW9JEoTLeK2QJdbhee7bYIjtEqE5XgIKCVMKaM/pNUW9B3zO33d3on96yo0RZvR48jpEKqwLIYWKU1Ql1P1XeinrFHnvbeEP+jZdK6Nmz/RTXC1un7M4tdgTsgFahbR+y2QdqWP7On2zvvsLTd93ihla8YEcek5aMOsePzsAmKn6PJhgblum4SaZcYf2+l+6GKrejHNyy9UvomCkr168KruR/yZuJrau2x1H1DAhbzt4J+cjn1NbpC05WwOgtblXqY8L5GLxbZm02T4GUQCJ/ESZkfPKxLN6P0xWxh8vKLjCAjHd8ljtu3lynjc1GiQpgbIHqxfFd/HFLlh/qMWaNNLV9C0w7ne9CSZMt438POY78D50TPvXxqh0irx6ifi8KcEduXRFetMbi6
 fWxHAM+E
 RwY7yHac3bEZ/EiI7OVsBWZt5Wo4TpdQ/BLtmXKVgzlVIl49GNT9x+e4rj9ylmwEKqDocg7i/Wutl8RsFucY0fO1s78vd4lAHxqZ6aOSk5qVGr97pTTF4Yo0ZVXO4bgNAob69OWl2foCDX69wczBksVpfCN+Zz5VGgGu5dmS9NNXrmIrB5up+q/Ir6dplXmuPLIttpQafKlHCYPriJwFu2iZRtdp/EA2pALDrSpBjCVqc7IV7NJQgTycqxUT4HsHoZAWVDpx1ePAkU1S58cCs6uM8NBRbOuBeYBn/mmXHBcR2nDG1E3o37S9/P0dg8O6vaHN1wzrvQ/+3XxMEafahqcHRvAZ4pOeaZzmIZ5vDcBcZIEyYTYAB+ACriDQwJzm25maMIkLUohFQBxzvRWRRAiR4jMTVqRlli4SNlKmCFJuhBq6TNMdOwjrFs9MhLyn4Hpf5XogStjgFf/r+LTLfUrDHYCQyTN/5lPnYlSCS3J1VMYDMVTS5wmRb+Uzi/9qfApOuKGNqunZJjahaGgh0vV4zws8pa9mtJ1y+PrBTvR7u/onjeW/vgB4VusWPArbL3OKJ9fuexe4OSY0+Gq4pSVHsjYTTT5tuYGLevq+zV9WrMJNbuQC8o7WlDCefs217gYamq22NvKn3ZmrxUFA3xyoYgmgVB4LF6Oi6aMymk7KURxoHC9WIVRtJLn+5yskUFea6UnuZjclw+cvVsAym3Tj6XktsYTHiRVrDQPuUBGKlzialJ+CbjpRpLFFA0JJtBY49XpaTzmAzyIfRfxAitXynyo+ztUo8czVeDxDfuqAejVsgYalJksY73FtV136CXrcGZO7UNP730fY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Luck, Tony <tony.luck@intel.com> [250905 11:53]:
> BIOS can supply a GHES error record that reports that the corrected
> error threshold has been exceeded. Linux will attempt to soft offline
> the page in response.
> 
> But "exceeded threshold" has many interpretations. Some BIOS versions
> accumulate error counts per-rank, and then report threshold exceeded
> when the number of errors crosses a threshold for the rank. Taking
> a page offline in this case is unlikely to solve any problems. But
> losing a 4KB page will have little impact on the overall system.
> 
> On the other hand, taking a huge page offline will have significant
> impact (and still not solve any problems).
> 
> Check if the GHES record refers to a huge page. Skip the offline
> process if the page is huge.
> 
> Reported-by: Shawn Fan <shawn.fan@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
> 
> Changes since v1:
> 
> * Mike Rapoport: Save a line by using pfn_folio()
> 
> * Liam R. Howlett: Don't return false. Continue to rest of function.
>   [Yes, code could use "else if" since "sec_sev" can't be both GHES_SEV_CORRECTED
>    and GHES_SEV_RECOVERABLE. But I left that alone for now as unrelated to
>    this change]
> 
>  drivers/acpi/apei/ghes.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index a0d54993edb3..92a767fa7ca4 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -540,8 +540,14 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>  
>  	/* iff following two events can be handled properly by now */
>  	if (sec_sev == GHES_SEV_CORRECTED &&
> -	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
> -		flags = MF_SOFT_OFFLINE;
> +	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
> +		unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
> +		struct folio *folio = pfn_folio(pfn);
> +
> +		/* Only try to offline non-huge pages */
> +		if (!folio_test_hugetlb(folio))
> +			flags = MF_SOFT_OFFLINE;
> +	}
>  	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
>  		flags = sync ? MF_ACTION_REQUIRED : 0;
>  
> -- 
> 2.51.0
> 

