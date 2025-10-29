Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A26CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1588E005D; Wed, 29 Oct 2025 06:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9428E0045; Wed, 29 Oct 2025 06:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2D18E005D; Wed, 29 Oct 2025 06:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDC058E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:16:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CD8C1407FA
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:16:29 +0000 (UTC)
X-FDA: 84050747298.15.C2B84A7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28F07A0007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:16:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PK2kfhlK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TpWNFdFz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761732986; a=rsa-sha256;
	cv=pass;
	b=gelC/oZWH/Nsn58F87qAGGx+rnpi9KqgYiOjX1g9aZDSI2K81Y93MIX9i49EowdAgbZ/KU
	sytVxE6XX4Cc7MY/kglYOyhO9hyBfd1UPb9dwLO/PtPb02SeJMj71CvZxU311HhFRBAkwi
	vbioQ7vYxtal/L8B4qIlj/LBfOi1cgY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PK2kfhlK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TpWNFdFz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ChBstwYRuvnLxEwauQoYMHm38kNPG+PHx2jRVoo2j8=;
	b=cB3CJL6k+gVWil5vrTppNHn4EX9YiSFP8S15OmvC6KG01adbSdHelnEKjpruUyIBH6SEGX
	Hgem+64KH1xADL4/t6MtUVnB8+biucTVdv3df41zRNsnU1Dh6DfBELY3QQturTRD5g9q+u
	1ATuBqDf87rU9c57mGyx9z3vqi9oO8s=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59T7gF8L017054;
	Wed, 29 Oct 2025 10:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+ChBstwYRuvnLxEwau
	QoYMHm38kNPG+PHx2jRVoo2j8=; b=PK2kfhlKE6Cb9YcDWtjrSWVNslzmMtd26C
	ykpEYzCvLPGcwRvec9ywnz/fH4Mz7UCkfXatrf8Usa4NvPcvHJUOZOkeuC+D+GIt
	cm+zElwOx92rRrapW9Ae7/fP0ZVRdLfrUDAUqZTjNJeazVmYVZl4YpaotOGPiLY3
	qFMxu3VLiKq1rj6YsHR9oucKvThm5Ln2rM8jgFifFyx7R1YI0DhWrOPMm31PeUQi
	milCiqUTEkGbwZNVszUxd7DKQROE1+aqd2xQ6gqJEDNeMc8TyLfja6gbmkFwhZe0
	pNif4YUKyxlhi+ZHm/CqPFs80+iRrNRLnZsjG4Ecugijo2l47I8w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3c3b0j8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 10:16:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59T9NZLG031706;
	Wed, 29 Oct 2025 10:16:22 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010058.outbound.protection.outlook.com [40.93.198.58])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34ebrb1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 10:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKl+wbi+q7SBoispaklpP3Ssfx+F3RyOfF7C5GpZjaKDhlKL048oYZPTrrqE27fE6lfyy8Y3d1nLwJl70p8tI7v3Tjm+nZvTMPeMtIKRHFPbnWtTOQRZouBEIw3e1e386ELrUsACawuO9TB0wvp5h7QzQ9/sQ6fbZFfADqlECnVKGoNHYbk/xiThYrVZ1uADUy2d3+DB9pTlaQ1HIiORSf/YuXqchwDZyvPvw+BZY1235Ls7h4x7GQvRSP7HZwy/uj22Q88RBbKpihz34fAY79z5IpAXB5Zp/gdMFw2pkHz7a3AWy/r/Yx4x1utxz/oD/aRqlIIruB3LdV4MAb6JxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ChBstwYRuvnLxEwauQoYMHm38kNPG+PHx2jRVoo2j8=;
 b=pPfk4zTv6IHRCt2Nsa16XjzaAuwyFH+/fEL6qq06tYLRLeFwMkxnNMuX0DE4OKnhaBJkFO/4YmtTBiZl+0sZDRBgNBKRIdrUTjyGkTDM0Ottrb0Ym10aUe60AQzNFgr6ZYVWnenPKV2Vsa5O0DTMGZJQIeaL1wVIO+eKGQS814O9v/tTfbXAtA3S58aIMkmn1dY66UTwzJEOn4L83MMTfp1UBv5uA4gN1igSCwtFm5OPy6lV3igTMC2gPZ5QCkX4ydDfY+cJgs/nqqjWTNBlJ/769oB0KA+SFZF2oDIiE6prbKPqOPlap+ep5nbjMAXwLZgn9w9LTMnXCBGGVdqSDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ChBstwYRuvnLxEwauQoYMHm38kNPG+PHx2jRVoo2j8=;
 b=TpWNFdFzme4dqHOc42K3MnlR1zU3boLdc7XSiGtMzlpM/E3Fq8mGHBijlapS7kwQWAHmG9dimaJMGeXO+WS9SmrF/+DbGBa5neOq1kXI7oOeLWrheYScTjFqdUs50mwN8Zt1dylpzwCLTVAMe+hQJOqtApG31wT81NwQlI5DXZk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CYYPR10MB7651.namprd10.prod.outlook.com (2603:10b6:930:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 10:16:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 10:16:19 +0000
Date: Wed, 29 Oct 2025 19:16:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Petr Tesarik <ptesarik@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slab: convert setup_slub_debug() to use
 __core_param_cb()
Message-ID: <aQHpatjGesXvwMBj@hyeyoo>
References: <cover.1761324765.git.ptesarik@suse.com>
 <9674b34861394088c7853edf8e9d2b439fd4b42f.1761324765.git.ptesarik@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9674b34861394088c7853edf8e9d2b439fd4b42f.1761324765.git.ptesarik@suse.com>
X-ClientProxiedBy: SL2P216CA0142.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CYYPR10MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: ced3b9cc-be96-4ddf-9db4-08de16d433b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wKkH9FkvHbA1lnpSBeAEpH+CizSh9GXdYRQQoIW8V0PuMG2VZ5wBb+y/HyBF?=
 =?us-ascii?Q?tCWC44FeeTqlDcZCoR1KhYwZrh6ElJO0x1wFfkt4x6M8A2BXJN4XAF7RL7v0?=
 =?us-ascii?Q?OoQLigVnzDE9HBMxGLzCY3TsORSNg+dGYDtDz5Njw1KBp0kD9e841QKEIPK7?=
 =?us-ascii?Q?XcrYYJHY5BQMDcZ8noss6sFpohZsT8qTl0te+kyI/a3I6RaOiSzUBAk3N5+t?=
 =?us-ascii?Q?n6tk2QvvbXKF5B0yXFqhVEhK9+Hu+HBLgLFOr4PtT6mcJ/wKNBXXua6VhX4t?=
 =?us-ascii?Q?eYcofzCgKl9d8WNec08T7tQ98HLGCBcPif/qMg+3i2xTkj9ubptZZqbSk/fy?=
 =?us-ascii?Q?jzFF6HvL1AAJOHykph0H+Dl6xn1d47S/PunE2whGIiIfM4epr4aUdskQfNe/?=
 =?us-ascii?Q?YLecls4LMdqoCK2jUwLSIVKKDPJ6Daac14voB1693zKC4gU3krMw7Zv0wAgh?=
 =?us-ascii?Q?kH/QoB98E/SXv1FSodq71dCrqaGB4NSkX8zzxGHjftBECwMjaLNuHl+4lNdc?=
 =?us-ascii?Q?awS+MvXklyP10rgwlYINQa95Q+PSKPoQQuMeOFaBmFY06hBI2gJTIJ5hkiUb?=
 =?us-ascii?Q?yxjaJ8C9+oBy3KvNlZGJDg0vjSJunh1KT+t+V+xwWhCK6tOx2oLduVIDyz4p?=
 =?us-ascii?Q?XMDsDYDs1ajbiBb82uXambPR3Rky0SOYnM4hzoAtKdN+ex1Nj/IdKCOJLXbH?=
 =?us-ascii?Q?Gkh2zcIENKgxGvsO75mJUkATQAcYojPuVV0pOJ/yeC8bMZg6YfNU/DmF+/T0?=
 =?us-ascii?Q?2O4gKdrr7lVfudGiUBELaCEj9UX5Rz3Secyo0T4HHUG7S0JHeAgh36uPsYk5?=
 =?us-ascii?Q?daF6719cfgDYCv3X1WFfxT+1ay3ORJs7LvuR4mrUPjTFb5wkNZ5tSKuoYpFa?=
 =?us-ascii?Q?TzsbFG5iH05jb86i7Rfmuq8Ci/B6MKZdlEpYsBoHYuyN4qEVYyt3zO28B1A3?=
 =?us-ascii?Q?HWat2Ra5MLCQSTrVks7bXVZwclV9rrfDTL6C/jyGx13jfZScnbF/KrQ3E23d?=
 =?us-ascii?Q?QmkrlGiVreAmLyno4UfH4xMesA/Jvl9fMSoBZFoKNjgQb0NiFj6e5xW7qvzl?=
 =?us-ascii?Q?oriNd5wIrGuykucAGYwv9Jno0HU88m2o3Y3cCcWV8mcxPnlEB7Am0qxcoD5G?=
 =?us-ascii?Q?J2aRtBNTFfUmeaUqP7ZmBfMwcfInxcf7tjeoLAtwwE6tY0tE1Ksv38EG33rp?=
 =?us-ascii?Q?KcLe+Nc8cIhM5UryTFiRmw22xZ6tZh2DGXLEFFHTo5RU0IGlMKhzfaMY6qGe?=
 =?us-ascii?Q?KYyrlf0pY5ucpEh6nFFPUMX/qnZRZWYT4Sa3CkUCqYSdCvKJVfRSOiLpj7/R?=
 =?us-ascii?Q?VjCOfQWdBBg8vViNyb9rO++lQWlubMJsIgrJUNiWvRAnXjEpWd8lLOjY6WTI?=
 =?us-ascii?Q?JoMZTAW1rPl3qnTEa9baUih25uaafSBpPTa/ZZwpNguWpSSjdXPj0HR/T4ik?=
 =?us-ascii?Q?VM8GeKU9a5XTY78QFybnGIm/V/dYmBqz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xgpLyxWNoYf2Ybgw37hLZrKPbfFzHAf+4Gz045xrK5z0LliYmIAzCtBmAAlE?=
 =?us-ascii?Q?W7hEejsbfv5JhYb4tyNlmGLYjH33HHEudiciCPMBboIDC7UyFBIYOTlJOmqa?=
 =?us-ascii?Q?TUpJBbmx57NSx4WNHzpg1I/tV1GhNoE7kswFleyfmtyMFv8Ev12zW9W7FJJS?=
 =?us-ascii?Q?hjqqUxz2H+LPH5yh2Perx8dkcjtAcwWzCFNrXhIwbbmYaW5h7EKO3O4+FYcf?=
 =?us-ascii?Q?W0dtFvXFw4JtAWfCxXEDBFk/vOtSmGv6J1vWdYbWO4bAayGXaC50e4/JB4ku?=
 =?us-ascii?Q?cYD4xnp8LSpidAL6N062U8jRMkNpPJYdGwmvPyBHhO32rsqegQIuicihTXsf?=
 =?us-ascii?Q?Xx8g1iWAwAO1j6NdOc7i88Pjkk+D1z+BXc+05vaX3I/oE0U2j3gKKGC+UYeO?=
 =?us-ascii?Q?xsCS9Ccyrld/G2AtdV6Reeei/DmLTvCMyAkYlM2ALwXAagAwXj8nBJuuOhld?=
 =?us-ascii?Q?zPeluBhSd6ajaFYBQDmbPBecYvaYl2lI8+1PjjMHOp9Rl2To7xpMuz2ZjIiH?=
 =?us-ascii?Q?fsqU/fAbLimpxL5VwtYH1PHPZS3neRkhkzBNX/MQ9xFLNF1v43D4p2bQM3a2?=
 =?us-ascii?Q?viL5vZmZ53C1mDuYGISGw9gaOfG0fE8DNDa9ky5Jt7PLDLIrSLsmTczYEdUo?=
 =?us-ascii?Q?abavz4IqvKBHTel4Dwn8lh7AfQwCddWylerb6ai80Xe+IInbf8RHpiIBFpeT?=
 =?us-ascii?Q?m7jtbOMEpSutDbymv1eHZEDYoL5ucMITGW7V6am5DILbsqhpL7wd/PsbePsj?=
 =?us-ascii?Q?ng0rmjcjqaXHLuEHZHYvV1t/9uF8I3L+aSpFtq9auxehEUZRL7cxpQZuI+q4?=
 =?us-ascii?Q?isfewe4LnPNlrjXd9ez5LBCdGEp8hFlQWoKlgtS1Lhcm/A+OyERu/FElJqeu?=
 =?us-ascii?Q?ul0Z2D+phONoQXYg7z/etERSzwVwNYFkTsoxuUgfnQtr934DbZbQmMhmGJbe?=
 =?us-ascii?Q?HgTAOVCkZjzv9MZZPTGsl4WvioxTBifza7QF0txpvH2oJO9g8oQqhte0irC4?=
 =?us-ascii?Q?8Be6gkTH0E+lciDa/iXAn79vH2k1HZKV7ib8L8oV84N4bQv2SdXosQBrG+a7?=
 =?us-ascii?Q?ZK4f7V0MxH0ARMGv9aiRoka81dB8n0eX0Wf/T6/nat413qLCzGOkw+Z5gUFC?=
 =?us-ascii?Q?1XJSMj8m4k1GDsxyxxX9sQQfzHAky98cOkeNjO38IbqLaAPWU+NhQj+TW28V?=
 =?us-ascii?Q?mh7EBF4G4UducKNR1Oz6L/D5jPDMrY4Hou6T6nTcE/3geFvRNtuL4e4YboNK?=
 =?us-ascii?Q?zXUn+KuorC0W5PobrQ6jfeCl8oZVzanG6I3v50B66xr5v+X+J1X/l/Cgvfh2?=
 =?us-ascii?Q?YNlKke1iMGBbNZ4KcVeO29SROAjPldMH7U9yA/RFKWNkeAFmmnC2nM72utIv?=
 =?us-ascii?Q?fFP1WnQSygO7ndBoiGUj8joPcBf2dq7jpKxvy2awylzUyR3IZR5VlRFq5jtm?=
 =?us-ascii?Q?02WAuZ01FK1iy2iAl1v2ILczSY4eviKZvNhgBo6IARjTEhyyLLQJxdf4fHOT?=
 =?us-ascii?Q?PkQx3oQf+iYyea4MP+QU6Ib+/ir2NYfGBROpnahMxKLIM+iAqmwYu5pa3suy?=
 =?us-ascii?Q?MF8SYmq2tj7j3DFNaA1fdkqj1Rxp4X+hQK64jUfm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fovzF4+5DShOILN2O4bnkd4k3j3SOqrjbLCjIvQE3/HGPhcLXe+P2kFOHa2U3NudJR/Nv59eDfPP/7qeXLBE4ZE7I5CIXWNuoPWg+xAPWP/YGitlWtSacv/UpCActrbB/8jmbNuynoZHd2pUrCUQNSe0RDUpulxd9Un9bcJpPDxWYkvzxPCHFnErADiF/HwIw97X/ZpfGl3GHVL65Sqff/n17bte8wcXevi0nYIZi8og2N8CRRAn+KRTFAzNRV0p5CIf9LxpCAFPHDu7NyDjMLHrVhvAbeznoRg0cmSjExohq+ymUSHHja8fV3eRucTjMW5cKXbHuwts3j4AkRmViN3JLABAx8rJqf7GYUg/8IMmRdGEFcpHYWgGDYkOYtuPGUxGI0cmchCao8F1EPayNIIND/qmFNrayhNQLQcLwFQtFnAdeHz0foKWAGnX0SmQIvqEwS2w5Sv7U8A64IYRF74a47ZG84uCGoSb/x/3PFOzi+bS4hFc8+aPtpZoo7xoYQLz4iX/CrHiK0NhCGchAs5zpAJvoBO3XkH2Ys8yQzsnPH/fz4SPPV5nOGUHX9RBpF38tlWYpO9MtGGDMAvn1vdtMiVSNK0RT5ybSciLSe0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ced3b9cc-be96-4ddf-9db4-08de16d433b6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:16:19.1280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cHJetiMnG6GML5b/Ac3YzA18OQGEWnFqno5R94x/V6t2RdgRFPAT+0svAi8p6cCiv4RvZEXCYAePbB0f0LMpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290076
X-Proofpoint-GUID: xRaaQ4biUuKNnMlI1d4Wr9my0VdLNd-x
X-Proofpoint-ORIG-GUID: xRaaQ4biUuKNnMlI1d4Wr9my0VdLNd-x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAzNCBTYWx0ZWRfXwEQstVItr0Il
 foio9xOniuizEJaB9bsfvyd2CGwvAaI/jsY5hD8ioTd+3UMIC2MINvwiA1JlQFK6d1BBwR0syeV
 xUqNS4fjuDe0hw5DhBwVB7Z3B1eRUVRHyUUhlp38vhiZHhkl1+UzIcGarBDbKcjBp+h+2zn5Vzy
 AYycmJDSIleJ0bh95m8tNhJZGahqv0hd4DtMJUXjJPJyAjT0HEgEHNTHe3xcyk5A9Dbaio4JhHE
 OiuWuOgpsQ4+ByAmT954payD13xv1yWeppv2sUI5Egw6vob6Wd+Nrwn6AEWyF40GzzJR00Hdpn3
 s+h3bW604wXpVvqBT6EAfKhDftwrHjQAZjOF9TL6rdrRuitS8VYvCiTZWCgCjBlpNprA2gX6Is8
 q0G4vBIHrUBOU+ELpAesr9ue5tj0We/sVIjRzs4IyTmnQuU6dPA=
X-Authority-Analysis: v=2.4 cv=S4LUAYsP c=1 sm=1 tr=0 ts=6901e977 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=iox4zFpeAAAA:8 a=yPCof4ZbAAAA:8 a=nZUC6xAEwtXqnwWAokYA:9 a=CjuIK1q_8ugA:10
 a=WzC6qhA0u3u7Ye7llzcV:22 cc=ntf awl=host:13657
X-Rspam-User: 
X-Stat-Signature: mkcqksgzwtexpzxiwz6ahx8bos4ywjwj
X-Rspamd-Queue-Id: 28F07A0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761732985-627276
X-HE-Meta: U2FsdGVkX18VmALZN/ay5wqXZ1ikPwTYXAwg00zx+31m+ggTulr4XwRv5CbnNz6P/J24/nWnJmhutFDXcbn3KHa9MGinCyfm/XxlbCSWVSg4sSu6kKWAZHoKL+PQwOebqsSzuiMVD6DwyfPdkwi41l9N+TfoN+DfA/AtQCdnQzlt+Z8BOW/HWTrzYhjqQM5ui/+ONPoq96c3vPBP/payCiXV+sckZhGMDwW5aXplPT1o8vu3ThTNGLkMFbl+zoccV4loEQyfkOjCk21Msrs9GjmJYclmk/4E93bZu7SJCe416gK3wO6GOHlk/5sbi9B2DF/q3ILMEz5bkfkeIRcjtoDNe+Oca9FPS2mnwIT2N6X2hU7UkovLS3b5mvnAtEHW2HVFPucHOPSXI4zJCcJlu4sPaXDJSjJmCucHGF0rQ2I/tqpRrFeomFU5bGwUwApqeuS+2+KEsFFUk8jWRmBOsRsZTTUSlv8+o+WztvMF0AtyxZqXzqx82SYQUvjwN423mjVjEXG7g5QvddOUJCoCBmg4I7Ny5ZZO7ohdbjzRNDcmBhQwlJXwX9KLN1o9SaD76olb6kmXoRU3OtELfAlndgMXwFzA2iVFwK3h3GH1R0rorgrQ9/MG5/FHeSQeJSjmz+1Ssk+FMKAXEVB7yAwpzJxrOi+oSX3ODj4Kb8T8n99bQ/r5dHN/CLQGj1IdEYmLFDlcnOKphEgasjiE0QXQSb5pzZDwQ8kb+DxER/AAlc+wDqPvBH5NWq9qXLfDpM6oN3Rx9BDhfuq2ygaXEEQYkLb0+QaaFqXh6xf7RJ0rOIrKOMOukLUDEjFyWKWk93f/xuYEwi5S2phyJS0Nuti3F+wvzhNno7LZidb1Cw4Aw4XQGhVCmeiYBfUeib0PdNVpcn1DNhVdnm+0NBIk6D36JxL5ifOJ705O1keoSLZU6TvPITMnT5JIWdxwLYnOP62q+91RK4Am1Y0FXJ3G3cg
 3imalIIw
 LNULCNA1RZBNEEOPSe6l+N+G8jiSzHGMdIZTCgBa+ss9Xwbi/P/SgxiWIF2OyRU4CSBft9wybRayUgpoPMOg6o6VpjSZmGZq+uV1W+wzabvsJbncK9ybeOvghSXZaFTNDNK140sucNq36C/HaNhBJVcwdbJAOLypPu86fWYySLhasGVqMHFv+6fAcwDJnDNSGZ4dm0FCO2IPqlWTS2pf4m+R81NiTDZ1v+XT8RwhTu5Hj4bcvDQO/BSK7BQcBD6/7yasQ2HX7V7xJCHf4bGiTbHox0mgrEm8H9xQ7Ulq7veOQQoMTcJTFRyhDhOzGW/QPwbkXKLPPgkvt7iPeAPSK5jn0EEZWHO+yYzhpxZTyhgQcturbZVv2kCJZSeS9QpVvzjfgm2hEbSfpBQ4nFMt/BtAaBCi9RbMQ7IWt7ksaVo38HoR50t5g5FJJfZUr8k3xxchW2zz/YOOD9389GRV7J6r9JUPkdLnvGBP8mrOAs8wIoYuj3Io22+wMf5kvIJfEmAuTxu1Ex9lbiMkXWNicdvUwbq+FUMiNOhI2v/raKBC4WNE+saRe8xuvKjf6w0kJwG4gbTGbAXRyWr4XBHyKwAq9BV0zWu4OefOAu4tpIKXetcjqkJvaVmXdag2YkK322QhfA7p3qN787AnHWueZ+qLFWagZM8GrSrcFqhDzre79LJxHzqgNP8A31vmDVu09O39Rlo/bpmGv5pW1f8goySQRMrgThEyjcigta0qlOTx4DExPo/BbVKXOEiMVvEO3zQ3hRZAe0mM/7AOh4obxjiAEIRJgXPG3eZAZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 07:06:53PM +0200, Petr Tesarik wrote:
> Use __core_param_cb() to parse the "slab_debug" kernel parameter instead of
> the obsolescent __setup(). For now, the parameter is not exposed in sysfs,
> and no get ops is provided.
> 
> There is a slight change in behavior. Before this patch, the following
> parameter would silently turn on full debugging for all slabs:
> 
>   slub_debug_yada_yada_gotta_love_this=hail_satan!
> 
> This syntax is now rejected, and the parameter will be passed to user
> space, making the kernel a holier place.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.com>
> ---

Good byte to slub_debug_yada_yada_gotta_love_this=hail_satan! :'(

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

