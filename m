Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC64E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 18:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0973F6B0088; Mon,  9 Feb 2026 13:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045246B0089; Mon,  9 Feb 2026 13:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E936B008A; Mon,  9 Feb 2026 13:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBFD86B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:39:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CB9BC05D7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:39:16 +0000 (UTC)
X-FDA: 84425780712.28.C615453
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03C6D10000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:39:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SZ0QwF5a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HGGLVR6/";
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770662353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWaPjDDbq+L2kS1wjKJcu22viKs/ZyLev4ywQ2mcd+g=;
	b=nEphX66txyo10C5d8PsLyfOCgq/mHBwkJnuebfn2zvUN0mL3Yiy/Hq8+441oKJ1OjV8XAb
	XXp0Pu+zo1CA2zXw88rT7UgInmjt7z7zknUvUm+RMkQpDT8L8RapD3j+qXY80eWiYyXzXE
	xIdf9a0/PTjkx7Mzny9Y4xi6HsZukEA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SZ0QwF5a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="HGGLVR6/";
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770662353; a=rsa-sha256;
	cv=pass;
	b=H/FWTV56/xfEkPoh6/aYqdOSXEhZhg1/qxeWYkrU+fHXbuA3Q0dIZAnKGnzWQVR9fPvq2M
	UaQdbTQcgeTdYinaT+hW8C07Iw0qjoSfeD1jZYNi8ouIWHrtEX0g3bsQf89mVkpg6jpNxP
	oNHnxMVsBr+A/+2On7BBQc/VDIzxKog=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619Bv9bj1596777;
	Mon, 9 Feb 2026 12:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iWaPjDDbq+L2kS1wjKJcu22viKs/ZyLev4ywQ2mcd+g=; b=
	SZ0QwF5a7wC+5KLHLHscVCmgRPunJkOT8gUA2G15i54mV6hCN8fZoSJt1u1wtVq+
	5+UY+VnYpSX6OdQFdSmqqZnONjlZ8zaVYrTy+x9ZdLcux+WBNNyZFkuUgKgbxe12
	156CxJVJk+AMiyDncqMaTRnigLQpHromCP58Z+4yAJLkmYKTPTmTe7m2q9c7FvKz
	WS+t0YYIS2H36KbRJAiyD68WMphIQQGf4u5PfIWuZbYfQL0TGw5i/zoNQDUZZUif
	rRANVmRPLgR3uALopXF4Bc9zaFQPc8vX4YtOYTI7kdDX0QSQ+hqW9eBul4KEgl6c
	f/Jh4l7QjwlHprnRtnGPEQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xk4sur9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 12:10:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619AYUUO000637;
	Mon, 9 Feb 2026 12:10:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uucxt3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 12:10:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+zt7Ob0+6L9nBha1cX3Q+GK3VSmdXFh9KYwzUqS1XjoIfZtYgajyDRDqAZYwc3a+oKnw+00qF4h/PoTk34lGhzrkGbqqxypfQyhytkVEKVfDzxoCKFJrgpDHLRqTjVEf5G6ZPK/LZEdv018cf8Qd0KnxGswdtYNQVXHfDWpyhxlfwviW7mA+N7VFOtZvA8zUui43m7izOJ5TtrTDyILzY5VBZ7+OP6NJVz3WFpsTSnTKsOl9wVyAro95a0QGP7L34frG0n4/90ALH2KjSWGkGebAnwB9zIOC30sh1Z48zxClpH79Abq4tAeLQQ+aH4veFtmxmmBPTEmbhGCGe8fXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWaPjDDbq+L2kS1wjKJcu22viKs/ZyLev4ywQ2mcd+g=;
 b=DdgJvAXVjuY6m77dfzZU7Waw6WA6XSxkSd7qGt6PaTkJNAuWYExlJ6obXwZqUQ7H7mXYz2ic/xyqjy2nMs27BOC1gJBm4lRDQuU0dM8rWgmsCsFZNTYltDvfRO/EOnGknLdwYVulItoYuaBNn1ty3UWFc13QvcSMpB+R+Dtyn/Dm7XTkgeMV88prTwuZjbX19hk29lYI3wa91fttMt51tvKu6qvAR/yS+5KA+qCxWij0jtH0p7gjGSc97/C6sMzaOeducqzZpNh5O3WrPhbmJjhZMJjZBKqa0IAg4ibdswFFZIlONIhvGodS3QS09J7Y9+fXnvqQ9N9846DqgGTs9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWaPjDDbq+L2kS1wjKJcu22viKs/ZyLev4ywQ2mcd+g=;
 b=HGGLVR6/Ir4uibIYMQQ2LO6s/eMrMtsLIIjXzdaRmrmvpJR6UqK9/Us+lBWFUejz2/2UFFxilI+IT+xKLfQReerygfTeuu0fsHUlKDeqNWAZyKbESdUmczZ2igLJhNv1rS6/bMIuwFq7LEy7DDYSreuy8BQE6ljquOoM1RVQCPA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PPF376CF97B3.namprd10.prod.outlook.com (2603:10b6:f:fc00::d13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 12:10:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 12:10:37 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH 2/2] mm/slab: free a bit in enum objexts_flags
Date: Mon,  9 Feb 2026 21:10:13 +0900
Message-ID: <20260209121013.50475-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260209121013.50475-1-harry.yoo@oracle.com>
References: <20260209121013.50475-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0099.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PPF376CF97B3:EE_
X-MS-Office365-Filtering-Correlation-Id: 67a6fdb7-3d97-4f5a-a0b8-08de67d43c2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nNwprOEVKW+AP11XI+WB+3jvnVyTHT+GhM2N7OJTM9Y3fj8fkOhzrdO3UemV?=
 =?us-ascii?Q?+kv/fQRv/QRQdZdKOopBlFr8fYrZ1ZVmC2LY9PuSRQuNMRX+3GMpiC8QsDF9?=
 =?us-ascii?Q?VXrNZbea0zvu2XD/XclJywLG/bsSHd0JiaQXOuh9IonbXoz2IYMdnHv56EMU?=
 =?us-ascii?Q?tiXuKBk6Xz9MkJBnZz/+/opQMzAx5Tii31pzxuOrkTXWHYPhqOLoYrxNY6E0?=
 =?us-ascii?Q?4WYmq1E9o69xtIEQom5vdrl6Dy3yXxcHQKpYawe3h3b+vb2vPTwFVJzIhQXE?=
 =?us-ascii?Q?fDa9V4Z4aNhBVUMOj36diwysMNS1sZ6PIw36QxP5LfveNufgJ9pjXCWoRTvX?=
 =?us-ascii?Q?9AW+2q6EAK2O7ttvMpn4U5fRTEcFnxOTWjEFQDZGZCkPOivNQb14CkJ4L1Eo?=
 =?us-ascii?Q?m1OiyUqDI7RDJMw5fD+4X0HgmgZfhs/MFlwORyB8B50w1MnAypzbnLBSNTRR?=
 =?us-ascii?Q?T6lEFCHXVo0P7QZlFMLYhobXEdKjbQ6Wwziq+7FVQzDYjdnttgU1RFIia0iA?=
 =?us-ascii?Q?kg/Eu3nrpB9FSqtSMZiWXwrdDSn7uwTXMNKweFNGEOzLcV/IbPGvIbrVyH4d?=
 =?us-ascii?Q?K093CGzarW1N0kBIsjCXsA9bfeYt17U8qAdQ1UHvLVtMNyxYWAThtgc6y+oK?=
 =?us-ascii?Q?YfgjqWtd4r3bpAlslewl82f2TWC7D3w/awu7dwtth0DqnhBcdmb9e+oAQZoP?=
 =?us-ascii?Q?+1/PiU8iLvS0KpshNcXI+oy3d5U/HTeWip1bvmHhapV2mAUT4AX50JP78BQp?=
 =?us-ascii?Q?c+zQHEDIQ3fsIPy3LLh2HDiWbI4uhh9pboeTT76qfrx1DbCzNAq/xbhmL+61?=
 =?us-ascii?Q?q7GFCG2jnfiPkbSWV5BPPk34oNAEpDJlcMWpfCyVkntrxkz2PcH6cS6iLT3E?=
 =?us-ascii?Q?VkKFebemY80VUSFZ1h2kJNJDnZdvTos2UmsNsoMBaWcxKPuOKTt+PRK4w2si?=
 =?us-ascii?Q?EoLTVjX8ShsAVX7XZ28flIoTIKtTVjlusZ9GN9B1qXYaZURCvYQwX+sDRzrA?=
 =?us-ascii?Q?YzGaB8bJkzt2nXfwWezgg5k52H2bo+/RxMlQRapBTPI+WY6Qmgd7m79AweAW?=
 =?us-ascii?Q?H3P90UlXGzocYLQMFq4JFcWyQFuSwHoJGUNlZNnFFahyOSDwnCRTuJ0r2Ox3?=
 =?us-ascii?Q?BrdLZg7xZf5FwS0f04IFi4QoIX64rQ1312Xg2fu/SaY9A09RPg6CUJfQXF1h?=
 =?us-ascii?Q?FEJJ1BuElRY40PZI+FbMPsi1eNMwMV5DpM/lgUHvR+nI/cQ+4dsvFhi2S26l?=
 =?us-ascii?Q?oWwLiUCybOxJ1S/soKx32AWuhZZkCNnu9ZP70c/UCOv8DOPgG/QFU0TErq29?=
 =?us-ascii?Q?9tK2/Y1BkZUkWRcsPI+Z/u0oC6Q+BrNk7TCgykGTk1NhhLylEkKE9eVkLsyB?=
 =?us-ascii?Q?yvQhPWtVgW2Lj5P2XhQKlp1EiCRhm3wT1LGD4TG+dw9BNKFFtGfpYHsQR1UK?=
 =?us-ascii?Q?X2AVyN3l7dfX4SjchNPj9lTOAXTxwW8ULKIUFoQvz4J9BTDbEqfJMeoCQH5g?=
 =?us-ascii?Q?XN3r3+3MltS5vyAg+O0hfGspkJW68y9wGUVMPRZmZD3KMI8o7IO5X7z9TvyB?=
 =?us-ascii?Q?LWg/XgSnc3Rnb8nszd4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nGosW/a6OlcaL98j5psMzqDhbBY+k3gSNV3q3SmkapNFEePj7DvVcT3bEC8j?=
 =?us-ascii?Q?DdU8Db9AmnDV9na4lM0HKr6uTb/kv9xQN4nfsJ/T0SNtPKYAtRsAPyMJgw9e?=
 =?us-ascii?Q?xuI4Q++zEcXpycyfsMBTLAMfgYffo3ZaSMChfXj8lJE2ZIUn4H+VlI0ZuMrw?=
 =?us-ascii?Q?zDIO1zJ6D3uun6z8WKsarC1NpDeDBwPzPRCKe7jE+wq66h2ZY9tfdzGt0vrd?=
 =?us-ascii?Q?/b6BkXg4bm2li5tyhO2iNo6rSX+2J7NSFML3WhNz/2mMZQWhXf8YFvFuoZ3k?=
 =?us-ascii?Q?QQm/w5OmX7Ee0xcvbW+mgBxX7LxowEFubRrGM4VeMHTzQCRO92FqBTCc34Lf?=
 =?us-ascii?Q?zsA4OyxjPQNhkoLJe8KBRvfLm03rjsvjJH/vysngbsm+bHr36ncbpodOXJ7t?=
 =?us-ascii?Q?4AM0jWpvUnDsLmju1UBL+Fil28qCR4/Dfza44qLGW7wgXuTJNP6vfRbKbVBM?=
 =?us-ascii?Q?iwgg7QF+EtfNZ805OyaYMPGJPmP4rbDTiotsrF0H5c33OPDt+x0afHoFexP6?=
 =?us-ascii?Q?1KGdGnr3vy9QbkaMglIpy1JWwu9M6xRJ8Xcd2HPlVTNDSQug4E5ZTgnx12cx?=
 =?us-ascii?Q?navdke/Z5q5WyRLNiWNq0/QssRs/jEWG4gfdBpbWwXOrjGZ3in/bf6CAK9mT?=
 =?us-ascii?Q?RMHPkUVEIqJ8tlYWH/K+3kc28RG/Y4cO6ptmXXQVtAyzDIyK0BTB/74T630F?=
 =?us-ascii?Q?izAxfbdt3gI71EjyS3XMS1nVe+xctc1VFiEtxSVgeCt/6z4akAPvW82nNCC7?=
 =?us-ascii?Q?7//rYo1s3ssFOrwfByxKnaqlA9d7B3U5Q1PwHSLUZYgHmFfp4uR2m1tT3fWc?=
 =?us-ascii?Q?Irf44BrNdgYT6lv2cupFXPS/uJmXaybXxDjDXNXXMVsAp/IhEEFq+IIwBkfL?=
 =?us-ascii?Q?K5F87xLFfyjLa4Dj6UkQ4WiacEe6xWjq6ZHuqMx/LOPuV5c0m4FhqKamxfDF?=
 =?us-ascii?Q?LJcUW7wN9VT9zdT+qYm2TeIrNfk8FhzxYKkowuL7IieMClnuRmaTZCiJ+Ogx?=
 =?us-ascii?Q?sC+fO4kcgatoFEh7OdaXLhpkifUD7ENtlAPBGOBTjkq/gjFQf+3/MO6jQ5DT?=
 =?us-ascii?Q?Xgp7sPR1TFtc8ocEbybIU9aTJqyb19gfUJTXKD7DEF8VarXw7fX2Xiw8IDmY?=
 =?us-ascii?Q?HdJWHEOusvpfsPeia6ZcyOXB/ZJ1znDeJzt/q8ZeEO1aww6k6ZODCrJampjq?=
 =?us-ascii?Q?GfWhP723+zRMUCjNqXT7BriPYGlsRu2YBOJOOpepL6EIFsNlP6qfAKvDwAYy?=
 =?us-ascii?Q?J+N2WL2GRZxTd6gXwCFEG/9wtj8d8Vdyh79SeuWD9Rtr4nvDNXzBnn48i4xp?=
 =?us-ascii?Q?O9kqvJYp5yPgcrEANYIqvQEZjjJgNnVfnBAQdnr1hhzJPA/JR4w1/9BlkeDJ?=
 =?us-ascii?Q?q4hm883rrAwTLAB9AdODMLAQZ98VnDSPrWVjwoLzgSzBQcZUr7Ec2AEXhIBd?=
 =?us-ascii?Q?Diy82oAQq5J1l/UCw+T7MbZGVTVsLxv0pRIhRCGVWyZr2NZy0vxwnghYz3w5?=
 =?us-ascii?Q?CWVz4MoqQAgYWqyv5tXVmX6+QT98cms2F4LDepwGfT0JRLrah8YoPIegPGRg?=
 =?us-ascii?Q?BfnInu12fz9OptZpbZq6tcXa2wv0iphwIcHJpec3HQuPsq60yQmK/Z7/zMM7?=
 =?us-ascii?Q?hiVECk2RfLEqk9pbQUYIEqR5N4CPp3w0fK8snfXuiWLSaZwWeXgkEdGuUvfr?=
 =?us-ascii?Q?M++c8MSn+raoZCCGnj3LzC06TtByqtD5tKVADUTelWvJAZakFpVCdIMdS/TU?=
 =?us-ascii?Q?1ff1L0jUpQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+WkYavD6UUxwGb9sh5EOli6An3iSYXGY2CgnOZCv6qkzY2h/fY5dF+SUcXccRyE3AR+U2Xo1WkgXpkETuRjRR4qjSV6OvBjNP/nhnJqdaUxaNipRynfckr6AfRoX1RO23NV+jH8SY+Dw2mY7CAWSlZpEqsF4n6N8xjULGksXxO7cefsDNM1oCBwp/nk57pA8NM+Lm1l9rEDyjQZjILyVtOdwGGfBlvNS/oD8UOb7eNDCT8sNZu4N/29RSKiuArlqlyzmlPV9JAR2wcOmli7gFPPBdbC/xIR0I75hMAdo6NAsXgd0y5WaYWkH9KhAkBV3jnhSCEe23k8QJMJ9bp/l9I4LTZYOfKr0l3hoQq3Yrt6Poo4oKDF27yDwwPARfrTRGIWGbZu6YqGiHCuYlHqNTZHPmJD0uL0bxp2jciJAZZs6oCryJKPBl6vE2NH2d4P+H8BN0qzz9ZzwUzIXi6XOi1c8kpd3XTlqbvMDN2z3I2BlZDrRxxWuHG2sl6Loyq58ND8zVQ2ZfIpfuodj0qYTFsVXQfatNpZQyuOw2s27RE6mJxG7hv5WNnwC4GVGWvoJHBqpkI2vcgV2l0qMJFVRGOGA3cIUYdOZpGBIcOPdLYQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a6fdb7-3d97-4f5a-a0b8-08de67d43c2d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 12:10:37.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNXt0H0qHrgZ53awK1ytN9/C7snzfJc7bJo/VSVdFC9n6xoVwJKzFKu488eFBUsjhlEKt4WVw2GBGQ24shgL+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF376CF97B3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_05,2026-02-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602090101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEwMiBTYWx0ZWRfX0xAPGbbzMk+n
 S0wspg5CIjOovcTS223jPl8w9v5Taqb5+XIY8FsEsQL7VwoPUMJcLc1nXk9nt1DtNSrHguB1CPl
 1Qdd1Juha8TZNK8/Dpzd/i6Hv9p1i9UhdFgMIfgN32GjdIU7a1PAPgyLzdMKOt61BDck36hGtzZ
 3RxUeXk5of9U+rKQ4YPiMMMK3vnA8AlZL1jkNFujBnpCWa0tqq4TCM5XhV+En3jxmtqkiclOjVr
 nUyowFwpLIlSefhqy0uWO5wk/XbnKU9gSpR3A7plU7tLyIkP1OQc2UzY9fmKNeZmwW0psXd/54q
 J9cMtU2b/qQk2r11Y9LAITAyVgZPMhe+GRBKtMMmFHoPeyGvNBjYf51AZursgXq0RcMc4gLB2V6
 /k2NR2Cgv2qlZip+/H92cOYcpF2NyahJRoybJa6mTIAIQGDsFDW2fZlqV7oEt3cpMmuQKqODEDf
 ruUFZVUTBruTfNT/QKj9kxSs6qj96vEHFAVsZF/8=
X-Proofpoint-GUID: RMSHFs-OEEA8iEORijJmr8Qp-b-3xjJL
X-Authority-Analysis: v=2.4 cv=ccnfb3DM c=1 sm=1 tr=0 ts=6989cec7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=zjV6mD0EZtXkyTl6xJoA:9 cc=ntf
 awl=host:12103
X-Proofpoint-ORIG-GUID: RMSHFs-OEEA8iEORijJmr8Qp-b-3xjJL
X-Stat-Signature: pdiqed9tjg53r88p8poz6syw1k45c6xa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03C6D10000C
X-HE-Tag: 1770662352-627808
X-HE-Meta: U2FsdGVkX1+SkUm0Kv1pxtFU7U5OkPMaJIxSAxQIpf9kaZMT+w6kutSPi8EVaM294BjJy8OrvNu8CZMAbcPIduaHjqNuNfLTOiY+Nu0oOFM5AcJ8VuYjxGWZbuKpPo8OGA9/dcNWA5OnGg9yAOjN3wEbuxIdqW8BhYuk4JjxNvc/4mg3sKK1Kl8Lv8vZuQKTFLp7ZgVy7mE6jDc20YJsPGnkvmRDDnaX1eRPNm9gqNxa4BDw5u3rLIWy/wRNptopBxB9CRWeIMwwTxtKa37dovV6wh4xJe/XBPGNRa0D3WSo+JLa461StffSEhsTwO13pNc/lSvRclKvoS+NL+xNGSrxCjTJrwt/m0n9EpJyYbJ8i6PTf3HNrYLfZRQfruiHVDRvA4MR3LQC+5DMFKuYyODnRSmHdkbG/6h6RCW2WJ2jMzdWBmbd/N6NepAKxuMg9gZPsguXtkf/1WQeN1+A7Xs5OFLfytW0hP9UaT6KLa9LDsKjTgySeeQ09uuxPRaYGMcSwQAzisxqGwVFSGrQOba4EJ6mPGYOAymsMQcxYdmH5tsn2xl+MT0tfXXGwU4tRwrhHfEMDuHy5+OuPcsmS+XTRt/HFcA0vL1xAmUuyMvTZ067nJ/99IZ47FxIBKuZ9IR9ufVNGPm8CimBnt5FBr483FfeuE6+mmr/yMQ4UgDMEwS6O1UZoxh5oQ6siqTcoLKtMSdUmPI+skCV/q5/sH/pjAtEz/HgbXniCivwIIZDTkgMp74OBzXLJs0ZKhJifzcgNATOsFVCML1yl4z3NdxE4pF24Rxxt9d4UktmfCMV7ETVWXmPtuMnCxKVSM1Tn0Q9BEXkxiic3+jibos3E+vPyowA2EGllI/bUM4lDr7XpY5o+djPeFaTwRDkWCX8mI3h4HZoFuji9y0JJFfpQZaBQzI0Zf3H9dtN/ytbp50vSmFHQK4lRFTahOsUlPSTFUhYFYX4XGH33reOeTF
 Jt0VVZrI
 m9oFnWQT2++tJq+oixgQaS+jBSL9Y0lN7fuRxcu2tFvaQxtfsaNNJex23lYUd3ygy/wNs2yBEnUelSS2iQiqSvQ8rPxu0tMAs6ulf8ehbK9RKHXFh86ik8+tjnblkjeJd05sAmqt7eEirtZbr0fXUQucjNEr/t8GcFa+eo3zNi61GxsBeP4cPD5T8zPzql6cabFx0ObEnNUzJzQFwgLBb86jh3xNVINilOj/6w56d6eDZlFa60O1tTDjJo8glbtV6MeibYwj+290Bln9SM9vhpd/XFlcg5SQxc/JfCGnwDhiWH6pCC3SuPlC0an2zNLMtzfVfvaIz3faNPJcVNk4+YAsnAHmzmxkwii3HBCRIbhgypcJU6XzW9pknHFkTAleCwN/uuLGMMM4RozsmHx1SAmqDlY/Ft+E77gi69LNts1MOYO6g8zpLh374maYBz29ikD+a+OyRECaj5OBbca0peqs/nWJoaarL7P/6aIGFxW3H533jfIk2ounI/9UgCmj5/FAQDT7RHopmSxryTNFWTrIYA1XQ3ykq8RcJfVsoXsIQ27bKYtKINdpLOJnNMr1K75oiEAkzKxsd/6gRKplHDDYTryDNShfmfs9qELx9sMy++ZMPPAdG3KP4vgm+dSCqYoqY0V/xICoQCQHaozEQloKYTGuCYmB/VbHHgpKLSLN2XvUev9Yme50RHOAvzZ+/WtvOU+pFopJKbvQ6VUyFp6+ooyxR2qXCATht
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since kfree() now supports freeing objects allocated with
kmalloc_nolock(), free one bit in enum object_flags.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h |  3 +--
 mm/slub.c                  | 12 ++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..bb789ec4a2a2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -359,8 +359,7 @@ enum objext_flags {
 	 * MEMCG_DATA_OBJEXTS.
 	 */
 	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
-	/* slabobj_ext vector allocated with kmalloc_nolock() */
-	OBJEXTS_NOSPIN_ALLOC = __FIRST_OBJEXT_FLAG,
+	__OBJEXTS_FLAG_UNUSED = __FIRST_OBJEXT_FLAG,
 	/* the next bit after the last actual flag */
 	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
 };
diff --git a/mm/slub.c b/mm/slub.c
index 63b03fd62ca7..33d2cae8f939 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2189,8 +2189,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			virt_to_slab(vec)->slab_cache == s);
 
 	new_exts = (unsigned long)vec;
-	if (unlikely(!allow_spin))
-		new_exts |= OBJEXTS_NOSPIN_ALLOC;
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
@@ -2213,10 +2211,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * objcg vector should be reused.
 		 */
 		mark_objexts_empty(vec);
-		if (unlikely(!allow_spin))
-			kfree_nolock(vec);
-		else
-			kfree(vec);
+		kfree(vec);
 		return 0;
 	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
 		/* Retry if a racing thread changed slab->obj_exts from under us. */
@@ -2256,10 +2251,7 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	 * the extension for obj_exts is expected to be NULL.
 	 */
 	mark_objexts_empty(obj_exts);
-	if (unlikely(READ_ONCE(slab->obj_exts) & OBJEXTS_NOSPIN_ALLOC))
-		kfree_nolock(obj_exts);
-	else
-		kfree(obj_exts);
+	kfree(obj_exts);
 	slab->obj_exts = 0;
 }
 
-- 
2.43.0


