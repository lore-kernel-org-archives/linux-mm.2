Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EB2CD13D3
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252E66B0099; Wed, 29 Apr 2026 13:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204186B009B; Wed, 29 Apr 2026 13:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2296B009D; Wed, 29 Apr 2026 13:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F205C6B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:09:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B8FE160371
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:44 +0000 (UTC)
X-FDA: 84712230288.11.E4E4FCC
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022130.outbound.protection.outlook.com [52.101.43.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id B75E9120005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="MFE/rmRX";
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.130 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cR2gsSQCfjRpJJLDProNsnd3zNE3zRE0nO7toQqdzcA=;
	b=xmdHDabT72PVbYjU0SAKratd0mrwhmTsudHn5ArOZZUEnreJzCohJnnh0REFz/RRYGxb3b
	sOfOnHQ/LXP57NiTHIA1k7Mn61NYT7KVS2NAgolF0bMWxPJ5S8Ebz388k7gFiO5tHDF799
	KI2aMsQeEqJvdrIwMYHPF4+1ywFvnwg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="MFE/rmRX";
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.130 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482581; a=rsa-sha256;
	cv=pass;
	b=WGVYW0syXDV6/XMG/Q3SKEz27hwZ5P1PpdlDNYlhChpRqWXhDrJEyjVMT7IQKbTzhjUaHT
	BfS7YTUCv6lGDOIcrI7lAs3y1+8lDJ5Sucybu4wIBI+jy2uzdkQi7k3AcXvah+4H7xPsSE
	SvtawGep64zbf712ngCi+h5h0/YfUM0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XbRgWK15T0kYcaz5Sa/b3V/BMezIJfHDq4MU0bJjbcljJoaZBoDkx69Rhm6GbVWTGJgWZXwLT+Tew+F2VriMcRougHuiBJ4uJ9t0XdD0nLtUwczEEt0298DB30Nqu/gL8fkqG9/SAvApZe5T8BNoHh0J91rSZ3kL2TTyKp6dTuSZ4Kwhu6vdnKbXCdPXqTR1aYr6uV7AqC7Pnrnvcg6/hOL91YqLmgUiPI4Ja/lkrIKmO04rc0hw8UaX60AUufpi1xGyEm7r1o8cneiW/+iFwvnKzdF/8Bifm0SF+RpiKd0HamlIPF7r4Z6r8E4jHi8y0k5QYLcN+/UaN3Ry4WBNMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cR2gsSQCfjRpJJLDProNsnd3zNE3zRE0nO7toQqdzcA=;
 b=bYUiVJA9NJ5E7tSqO+Cg/u/naic7O1qyo1Qk9rjChi7H+Y06a9vxZVjlMhDw99ozYTHBxlId/kudm7bjJF0q362yEAl5cPSDmEIC7PPC6a+Kfw5U+1VSdfBDMvXr7tMDvrrwK4K/xtemRdEWeR3vZSDS4vbkzRkMjXHKlGpmeVeMusEw8/BX7CUTP566mrcavV4wlGXTqxKh3fwlzY9a7imPR/98WzIRzK7RzEZXph/qk3BcmyGRjvqMz9hzR4k94AgLjRZBDr6EITV7IjEsx7WaxYhMwG1Jk+9gi/g+l0pdIzEACFhKUkm/awidq2ZnPhTC2yVDNUMC7f9S7+LB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR2gsSQCfjRpJJLDProNsnd3zNE3zRE0nO7toQqdzcA=;
 b=MFE/rmRXu8szx0ta6noRKTvl9+yXdMVSEa3kOXXHj3y7/mOgJT3ugF8QzSQTOf0RVDh/YLK1Bga/Y8I0xECnUEeI3XDYYhu0rPMZcXjCokBKF/Cd65LTxx0Fmljitb8XMgBZ93Z0nCFRgbV7gtVAm7ye6o+jd6kQSdJQVuQwujk=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:09:03 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:09:02 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] mm: percpu: set up first chunk and reserve chunk
Date: Wed, 29 Apr 2026 10:04:34 -0700
Message-ID: <20260429170758.3018959-7-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dd2fee5-d3ba-4f00-0ca7-08dea6120340
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	BLg2NbHog/FN6UkvIrZXdRJpOvsIUHei1xYlqF9fo/u0TrwI0HdCkQDSUdwFBCZSU4uAqyI76t/JO6Ss5iuV1Mt9T1IFULLR/W5ZOSMZvgpe8fDGrv4MfOV76gd3E03rA5nHQ7wh1xaPLtTlB7q8IkM8QE/zcX8Z/HXfiriWZYDPtz6QVxlp/cZLH6jLA9zJSoK/ZKieoQJzkzDX11nWdBIg/kckD5U7Y5HlPqxrSrMM2olsYOZgsFscpTzqIQUeG/DA9QJ9CzRaU14X0KZ0b80UacY9sj/G9Txx/uhadDjs8SZF2tPQ7+k1B1pZYuZ1OE+pSVqZ2IsAFMGyIJcJwDEPtMB3REwRuJaF4XBs1m/RwqRJqXrXu73LJvZjpCZwvrRq9SybL8RLaP01EOEovh6BzMOi37rx5/z1uJbXzT1ovBh6GjnFTtioLm4bleDfAJx5g0b7e8nHJtScIJWDh3d6A6jsVSOTGo0b35Gbyidwx0yomYr2+Jq2fZJUzMJAcTjXpkIgwV8BpPI2sduCvo0QCxIWXMt/8DkclRGfh29wMg+fWpPfDNtssozcLVnaIOQFKQQUqstbsKRlHFsIVBICeyo3RPtoFhYxXGqwVCFhPF3vEp0K3SQ18tacqxAZBlasYuZTkVT20+VjSW4WiQvWx+0TUlcltoKLN/TeHslNBx6vRX2YqD+O/ym8WsqW5REDIx07gFChHp/KAEnl/grx+Isd4nyK4AqxLE9zZacWoOcXkZIhrEqB++4wvi7Aubj7zWpkieD8yEI/pyZdFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mp5cub10C9j7m9IG87opa2dRYQjdKLZGz2zxi0HCSAF/eAlU7jjX6p+uewi7?=
 =?us-ascii?Q?F6q9giuSQKVFDxXq74dfvw632xWfcGaZOIrHeBUmYvsZk7gkfswv8QXH7JSx?=
 =?us-ascii?Q?LORMsQHtcjj8+Hx2SClAv6E2iTwWMDsf+KPUud6h6nvYw5FFuKaHutZ9S0h3?=
 =?us-ascii?Q?ntQg00jV/bSZhSrpqxOXKWcDNnuU6tlSpoQgG7ghmKylAKVe96b1yhgqlpA6?=
 =?us-ascii?Q?n2YPtlvmtkIyjbu8fz52litmFcc+y2fTHatlx8rST59dWw0/N+CK4VNI+hyI?=
 =?us-ascii?Q?jeJ5fhb9JKs2Ur2CpoYOd78cHjNHGT+vGVu/VuqH4CctTzhO7B9hHjs2+uuX?=
 =?us-ascii?Q?0I1se2iOzabmFvsRTT+fUyMAnYxY53s2nxLlb5BuJRo3SE4uBEUatV+vkwlu?=
 =?us-ascii?Q?T0Accy18/xj2ReMvVeTtdARjR/Ye/UeUAc+oIZTvmV8YuroArmt2xsSknqnB?=
 =?us-ascii?Q?5LVIt24fhRyt0TKnDoeN9v/eGNcJFDNA7t3XwRavSXyCEfi56p7zVL9em5kD?=
 =?us-ascii?Q?a5BCaRm2AqeRwsRxPNDMGrfcBQ+M/jaBlp1j0EFNy/lrw/OA373W2KZrQN4D?=
 =?us-ascii?Q?ue8drvwkYl0NAM9GND92yt6j1A8LGPNq9RW9z2mzeCrqrkTCTxz1R0nnxtnA?=
 =?us-ascii?Q?1IGTqs7kayGbaJaW2SmSrjVAKQd8GE8sBjSwgLvv/6rN2JV9ubDi3fuZz5dg?=
 =?us-ascii?Q?P9DQv7oixp5eapJT0fnCBRX/cV/B+W6CCqLhKHwGfKVwatZSawcYWADVPsYh?=
 =?us-ascii?Q?xEZN7B+WS98a9OKihlB9nAmTYvQMnsQojcqcMdtZfhPi4M0GHPr1QzGq52Ks?=
 =?us-ascii?Q?hxe0f5DJMkZGr6hfX+etb+9nfkScfXksPZfzbpXn7cPVKc1Wcr9Bpr/MmM2y?=
 =?us-ascii?Q?K5tTDyhwdmUADq9idGCU+wI50BcNntRvpZKXGv686HU2Zk8M+/cRjoS0qPm0?=
 =?us-ascii?Q?7Agfog/++a7ttq4Q1HPvvp/aXR/LvL9Ighzy1b9whbdc+7fACqh8QMKTtYpm?=
 =?us-ascii?Q?6Wz+9m4AlTPq6o3eO25vDsbifTIZUcJFRmuCHnPYqJP5d5FmpSLKvo6J8Ri0?=
 =?us-ascii?Q?GoTUw1MRXJI+9NDKJuXO0YH8Gl5iW6thV6tIlBLlAFolvWgOs8ss34zW++Sq?=
 =?us-ascii?Q?JGPgjbeC6I+rmiNldrkjwMrL2fStDjIGXlfEnMb1ou8tADLLMiqnXqmBLvgQ?=
 =?us-ascii?Q?RBTvK6rKHOPxRAx0B0nTalxRSazh4V7AX3Lt++xma33mrueV6orK4jy7ELes?=
 =?us-ascii?Q?F/s3J+2xvDJ/RwHtnP3IkumliqUGajV2VHQUm+drzbQf9sRqNs0J1cU2XGfF?=
 =?us-ascii?Q?NOSrQJHj3NJKegGMniPOqlW+wLyNoqoMCP25pnRPIOeJHZ24HU0GY6o2WL0m?=
 =?us-ascii?Q?vUqutGV07RZtx08tsDUX8+JQnNCZEVCPZMw915/vLE+Zz4UmkeektNFoUdG6?=
 =?us-ascii?Q?51W8aabjJAwB7pY9ZJr5kl9icRi1LzE50Sd0cWkM0kKtSkeUm1fovL9Vy9xo?=
 =?us-ascii?Q?0dkMYEcLHBe6gDTvx2nkh2Z+mFDNScGFhXcrB0cEsyN9w3dcruBxi+B+lhzW?=
 =?us-ascii?Q?rRQnwNSy/64/vLNox3fOR+Gi0a+I1EB/3FVrCEqt5s7K5Wplkz+We4O7iQFP?=
 =?us-ascii?Q?5fGVBOf6fzVAWEQUAFPX/qX+EZeEy/P42zjuvLzv/ttoRnVxqddpXXRAim5r?=
 =?us-ascii?Q?VrpUg6Ncel6NbPcRp2/pyTTlLqrLkTWYAlQYyr8lmYz7EwoVv0vMTUUAQDN9?=
 =?us-ascii?Q?Em8eugCdxgSuRLMwlxUvGqkmfGV7dDY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd2fee5-d3ba-4f00-0ca7-08dea6120340
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:09:02.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8BkjaLcYHgoMCdbIWxuhJATQTpsPsupMjfz8TdOsegqi8neydQOKP1PfwEKMuMOqnbw4kz5f06KPeuKZqVm6XZ2VJ0fWwwLIBFw2W+poMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Stat-Signature: kxfgjqtqb8mt1phc8sp5k84eq6dts7ha
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B75E9120005
X-Rspam-User: 
X-HE-Tag: 1777482581-645440
X-HE-Meta: U2FsdGVkX18wAu6HVQKIzjjgp/IUoAjyqe25EZfAlwWw/QiSS53RjTNuwA0F580mGy+L6GfDgEbVZ45tibXe6FWJM2JKn42HUWpbRCRPALgVcYr8ldbcIZU1f0R0Z916mxH2pkg2lYFdbI4OEENvCdWPVgGh1ynQQwD28bObnceCfE/Nq7m+jXL5gk/NVXYZpWFPp2johCInDOk441vmH7UAC6vaYyk1jAw2eyp1gBoMCRfgU/hwa5rt/BdaedE32TthGI3FYPUcATB/9cdCNOFfTWbRML42g0iT6vovtSiojILkYQjVKwpoiBeyTSqB9lJ005YOnriqKSBj1VVsv/Zslx2aQ1dfYQ5h9zblTjzR9F5wN83UHASBT4B9sHQ/2MSWhe4HBtOYzd/z2zSEsVkv2KBFbABzbFoA6P4nZzrj9f5vka2KIlDdL/3Cyq9mw2iMuoiYzeQO9q/iQ48fVVf2hk8Urbe1TEQKaNI1XwztMR+82bPw+wLN6UlGQztZDbrchXgBt1xmbySu6JixaT9K8IbVt7bYy7VjfKxIHTtwBHG0EDtPsv0yXh6t85+gyOn+26cGw8DdpisRbDBXVZ84a8q7PzPeSJtTfYRBXCSNjF3cOlu5odyxJyrW+Cdx4wgrvyUTxsn03eE6m8RcMwltPRRUp+u12E40W/zK8nPq8rab9q7RJSrgCxI7ccnwRBMyPGqoAzmVTIcwdRapznzcgZ4/3EymAjBwm2T2YfChPf61y5KLs4ccyh6fAqjka4thaixsadD+jTq4TA5l0s4Ibjhe3zpB0/uZEbbTDQXe8wGZjTr+YA4IC4r/Xtl90xXuM7NB1zc7YJyxMx3FOE3uRVd/Kd+88qpRFc7NAWgENnbERg++uv1XvCeCzSA/WYW8j4jgsxOcFsOII/dJMkYPETeoGzRrJZKutAWHg02dExOnGEASf0SFmYA6JaKivxZPAFoRjknRcdMjc5J
 qCqcU3+l
 MIiOy6b3Jj4XktVuVNDoKGHQX41JpK0Xo6k9Cg8asrb9nqDMyFHfftvdFn9N6mQB+mpTHGCa8yagpg4cVwoO36l3VP34FnsRacCffN/78OWW8vKz7xot5cZVX/m7c8GXu2ZPC9QCY1dI0v6TLPlUR0uAjeggjB4ijVCBzULVZPWhY7WN2Dt6m1AnFvjA0akFD5G+NdNDXwS2vlQ7S/d0g0KGkNJ/IJlVAYSjjIX0Fr64AZv5Zs23a2irxoG8G3c0ZeI7z+L/ygqiKYzQGltO743uIzNfsznfhZ5bseQz5wq2IiaApe3AZ4WVPuwPmXRTNpEHsVzj/UTsV0ZV5sEbtWWR8Uc0Jc//raGwdEbjKHuDteJh4wKrtFOqoymI0a+xF2aEdkKlvshDeseaepgHqr5yl+vuL//Lx/Lu7LGQalQGiCPtipW8lWYucx+fMCSTZqoYj195bgN5nhIPCXtwyJ7COECl+k9M/J33R63H/lm2EWTtLyln6tvAU45PYIGHZWWkf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set up the first chunk and reserve chunk with local percpu map.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 include/linux/percpu.h |  2 +-
 mm/percpu-internal.h   |  2 ++
 mm/percpu.c            | 24 +++++++++++++++---------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 85bf8dd9f087..dba050f5b548 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -113,7 +113,7 @@ extern struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
 extern void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai);
 
 extern void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
-					 void *base_addr);
+					 void *base_addr, void *local_base);
 
 extern int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				size_t atom_size,
diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index b33d1f5aba1b..64b48b99ac06 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -64,6 +64,8 @@ struct pcpu_chunk {
 	 * chunk_md.
 	 */
 	void			*base_addr ____cacheline_aligned_in_smp;
+	/* percpu local base address of the chunk */
+	void                    *local_base;
 
 	unsigned long		*alloc_map;	/* allocation map */
 	struct pcpu_block_md	*md_blocks;	/* metadata blocks */
diff --git a/mm/percpu.c b/mm/percpu.c
index 59682b77089c..5148c5ccf9e3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1349,15 +1349,16 @@ static void pcpu_init_md_blocks(struct pcpu_chunk *chunk)
  * Chunk serving the region at @tmp_addr of @map_size.
  */
 static struct pcpu_chunk * __init pcpu_alloc_first_chunk(unsigned long tmp_addr,
-							 int map_size)
+							 unsigned long local_tmp, int map_size)
 {
 	struct pcpu_chunk *chunk;
-	unsigned long aligned_addr;
+	unsigned long aligned_addr, aligned_local;
 	int start_offset, offset_bits, region_size, region_bits;
 	size_t alloc_size;
 
 	/* region calculations */
 	aligned_addr = tmp_addr & PAGE_MASK;
+	aligned_local = local_tmp & PAGE_MASK;
 
 	start_offset = tmp_addr - aligned_addr;
 	region_size = ALIGN(start_offset + map_size, PAGE_SIZE);
@@ -1370,6 +1371,7 @@ static struct pcpu_chunk * __init pcpu_alloc_first_chunk(unsigned long tmp_addr,
 	INIT_LIST_HEAD(&chunk->list);
 
 	chunk->base_addr = (void *)aligned_addr;
+	chunk->local_base = (void *)aligned_local;
 	chunk->start_offset = start_offset;
 	chunk->end_offset = region_size - chunk->start_offset - map_size;
 
@@ -2562,7 +2564,7 @@ static void pcpu_dump_alloc_info(const char *lvl,
  * and available for dynamic allocation like any other chunk.
  */
 void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
-				   void *base_addr)
+				   void *base_addr, void *local_base)
 {
 	size_t size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
 	size_t static_size, dyn_size;
@@ -2572,7 +2574,7 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	unsigned int cpu;
 	int *unit_map;
 	int group, unit, i;
-	unsigned long tmp_addr;
+	unsigned long tmp_addr, local_tmp;
 	size_t alloc_size;
 
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
@@ -2713,11 +2715,13 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	 *   chunk.
 	 */
 	tmp_addr = (unsigned long)base_addr + static_size;
+	local_tmp = (unsigned long)local_base + static_size;
 	if (ai->reserved_size)
-		pcpu_reserved_chunk = pcpu_alloc_first_chunk(tmp_addr,
+		pcpu_reserved_chunk = pcpu_alloc_first_chunk(tmp_addr, local_tmp,
 						ai->reserved_size);
 	tmp_addr = (unsigned long)base_addr + static_size + ai->reserved_size;
-	pcpu_first_chunk = pcpu_alloc_first_chunk(tmp_addr, dyn_size);
+	local_tmp = (unsigned long)local_base + static_size + ai->reserved_size;
+	pcpu_first_chunk = pcpu_alloc_first_chunk(tmp_addr, local_tmp, dyn_size);
 
 	pcpu_nr_empty_pop_pages = pcpu_first_chunk->nr_empty_pop_pages;
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
@@ -3108,7 +3112,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 		PFN_DOWN(size_sum), ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
-	pcpu_setup_first_chunk(ai, base);
+	pcpu_setup_first_chunk(ai, base, NULL);
 	goto out_free;
 
 out_free_areas:
@@ -3256,6 +3260,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 	vm.flags = VM_ALLOC;
 	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
+
+	pcpu_vm.addr = NULL;
 #endif
 
 	for (unit = 0; unit < num_possible_cpus(); unit++) {
@@ -3290,7 +3296,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 		unit_pages, psize_str, ai->static_size,
 		ai->reserved_size, ai->dyn_size);
 
-	pcpu_setup_first_chunk(ai, vm.addr);
+	pcpu_setup_first_chunk(ai, vm.addr, pcpu_vm.addr);
 	goto out_free_ar;
 
 enomem:
@@ -3372,7 +3378,7 @@ void __init setup_per_cpu_areas(void)
 	ai->groups[0].nr_units = 1;
 	ai->groups[0].cpu_map[0] = 0;
 
-	pcpu_setup_first_chunk(ai, fc);
+	pcpu_setup_first_chunk(ai, fc, NULL);
 	pcpu_free_alloc_info(ai);
 }
 
-- 
2.47.0


