Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86FDC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38C86B00A2; Wed, 15 Jul 2026 14:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE94B6B00A3; Wed, 15 Jul 2026 14:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8486B00A4; Wed, 15 Jul 2026 14:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 847DA6B00A2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:06:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B2DAC0222
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:08 +0000 (UTC)
X-FDA: 84991790016.29.3CBAF74
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020078.outbound.protection.outlook.com [52.101.193.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46B27180003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=MceQqPeZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0cNl+F+N/MuIxcquS5c8uEGtyAEfWEhi4ngJqfJiDk=;
	b=rDz1PKNBB0XJZ1gAsodJQF9/OdPlqIsyOHg+gPasFjrDSPTE1G7RIOP/B5zspI0LKR96xg
	uQZhJ1/eCNHhfShLdU8tnsXhO8jgc8a8ER+mRz6ZTIUwheNVaHpreQqhdbjqlDl+z6l85v
	QgLxvzm4BbZG/l84tEbiARYwwM9k8qc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=MceQqPeZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138765;
	b=7I+hifZgM471a+EJo2//VSVU2MK8+oAG2H/XmkD+X7qAxESQQCQacGqxB2Oa8vV8Vy3NVV
	RYAWghw5emWDi6OGlf+jHruXs7bgP4Uw2pZxRu9VxF8v7P3maUN7rLw6UF2k16GRTmVkPJ
	EAHhVFtuC4wMw48LucUHevnlpq/9iOQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=slt6WGMfpg5v+hO67u7WwX9IZ04+JvfDETkxeW7FA44E6sqHBuWAAYXUvirxjdXYHC8lIwYDFZy19IbuyHMaoUkr5DmVN89XNx2sujroJy6xm6wRiQTZEkp4GRh8zOJNn8wsWtKcPUgYPCWcB1pMggEZK3pAelnjFktiiC/pNB4EqAu0JXIwHb6p2TNaTLL3o0kE8t1FHqeH68EPdCiPcwSGwr4F68oIulLn/5PJ/fIEF/49E4JI+b3wKb7g8OyQNBKmLWkya1fILU0mxn2gAiyF+fxYWH4SLof/wuzwPfF3daU2DPx7MslMll775/b18FrJkF/sj7U7yIj2OANumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0cNl+F+N/MuIxcquS5c8uEGtyAEfWEhi4ngJqfJiDk=;
 b=qLFk/kaKbT4zI9oBMRMBJ+hs6SZPLPJrmlhV9qvoSj0xd1/diJwKrd4AXBKIZItIpvlWAxAHJmlgLj05d0re1WyNaps/uRdoTECFCArbtjujvOxdzX2zgEYoY3csXD56OcuZb1qwXSm5Twgb8+M+xBuH0JG2tkuiyDKCvwPGblcdL8HZgJ034aDmOckuLYScW9tFLLpp2KJynRVIgGLLbKfPVEwufzm61cV+S+FDFB6bjrzi5avUgbCstVpUb14ku2JIcM5JmWvx1nZNYIR8Sx0xHZSxlRGrXXXa8cujcAca3CqQlTBvKqYWNVrsErOSS5GFA2ThJTzIXfanY0e6gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0cNl+F+N/MuIxcquS5c8uEGtyAEfWEhi4ngJqfJiDk=;
 b=MceQqPeZ6xudZmh+n/2knrcG0PpsP3OYBNAjdP+YYO4GNUTDmvdkcbKN4Uks6HgOg29DtpsqzZJFg84e/eZCToUfOj8Tu1Hq8hXfOJhtAueoyjxg8h7IX/6ugvL9pFmgh6GMyWtnsE/N6g7/Sey19n8yfhf75NoLrjHZSRooczw=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:50 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:50 +0000
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
Subject: [PATCH 14/16] mm: percpu: allocate and free local percpu vm area
Date: Wed, 15 Jul 2026 11:04:16 -0700
Message-ID: <20260715180455.515692-15-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: de4ff39c-60c5-4af2-94eb-08dee29bb3fc
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	aeYk+Ocf0i2ubpnXZYXyre0SXJ/oYioPwKXnGJuXVoutVTUWnq5XMJ4898xyNy2S9smymVWPco/dYmeWNiocrNlaKEx8WIY9QkNVU4TpvrW2+bbv9sXB1KzReHZc5mEZVD7HfEsY9xKioK0Q8gEgN76OPBMiaFQ1E+RytHmT4SKFsN3tfMnT7emPJ0XTx/VhEnU+mfO0FGuWlIOwjYfJl8CnJpfkqgXkTCNuSkK8yTDyx/+LRrzaCQUz41v52NK4NK8indZHuQkDWnOr/0prM1tASseJMMm+4j46EBjEn5Sk+5sB99l1ebU0mX5XCitf3IxiOQd9zBu5494iXmtbvakTz3w00os8zf81S/2vh5my4zPIY7wlpT4fCn9TyBZXAfL0O1EWiiOeTTDAZ8BpzQO+F4zFNpHyWWnAuXF07ANFhKcw4x6WQAg7C3RtNaRIdErLIb9Y66GZgtBNXcGdprGjAxCw2rTX0yRlTlrQocRAoyI5g2I/uN4I7Xp6ymqQSR4nt4FEb5pI/R+jWQeOJufd7bAeYbQ6fuDXUyodlCi8vRwTDYZ+nUMNZ3Losq4+qUgfJj9isT8h5c/DmRvDXY23phdgehP7Yr63G2EEjH82Aqjn/A0uGv9Q9ZRrkJ0/bo7BTPZ9HCzap1Nr+0n5AHFemjC7rPoYIx3hjDdmvu9lN8NPndY4seIaOMe6JIGIKTWQ9C97hHU4C4xBEI3jpw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k3Z2msaU/uaNwTlauFJjp/J0xUWWs3b14Y3kcA5yCKa8+B3Qv/mvo2545I76?=
 =?us-ascii?Q?i/90C0YQ5SbzYnxA5YoewigG6EgjcHlKkLfmBpF95Ri9mcVUojLqMd7mRwcq?=
 =?us-ascii?Q?DwBoYSNaXgp6f4qv6t1JBPqlJSQl0s7gZ+LWbShL7iOcR4MXznbsJt10MQS5?=
 =?us-ascii?Q?2Ul7hN1/mnW5lZlALqJDEL3IFWBA2Zy6FjAPCCuyHLovbATyZxAJyLUas+JY?=
 =?us-ascii?Q?PJuI6djNkK4Xpl4lgnQ0UcAyphxhDPYAVrPpNl6WNtZ8/bIXbvpoQaqy217t?=
 =?us-ascii?Q?iXtHEyaAGQb9DVRP5ok3Qlgl3MxstsTISu/HHDhoKgq+FW6QI7T7wpUHCV8c?=
 =?us-ascii?Q?kQUgBNf8btr3sDHmdznQm1KCO6Qv/yk4swp8rYl+vIJ8oE54gXk3ySCLAnM4?=
 =?us-ascii?Q?m7a1ONg/NOwXXEb0gsRZfjtUCY2SvE43l6Lx89GtL96IMmIOjBvOpFNaR+Mw?=
 =?us-ascii?Q?T2nQ2eOv9wGK/ZOG0k0TPvYC9Ox8XD1CsNSQ8M959KDGKVVVEVWPRCOZpsMW?=
 =?us-ascii?Q?/2XSai/f1U4xopFgYlaibRe/oHFKe+nT3eX6ET/0bf9p+Xs+6WTKvEBp6Duo?=
 =?us-ascii?Q?ZXrD6M+8SOeBV1V5g+3MF+jkU9UXIVvKpOstx//zQwiQdA6RYSaBJ9BjmiUD?=
 =?us-ascii?Q?3R/NasebqmGfHkDb4cpD7Zgm2jbAJJUtGcdXJB60+4TjN9h8bbuALbcJmE+k?=
 =?us-ascii?Q?BvpD75svuycgNEiiD5loUDParOh34ePXKInK2KvYxJK/qh4KQw6kv6l3SBbM?=
 =?us-ascii?Q?XyqjdYwuriXxIf0oq/T+vBv2HXM5mSlL2f7wB1yODvXOUATq63MlXl0JE+4R?=
 =?us-ascii?Q?FzYySBQWeS2gyB5OIj3Aa6kkI1GYK0P/XgvS2TrvshO1IIs5aloLfABckjf0?=
 =?us-ascii?Q?3o9TUxOTo0HKCaUAWjEXAVWQYOVyivnazCNAtCzNfpkb9hsdUUjFE1hiSXKt?=
 =?us-ascii?Q?ao5srFY95xIuc11MOzOaUhG62uN7G/9/PRUQ2dTKrEO14LXbnZ5zkH0qi4tY?=
 =?us-ascii?Q?kXa2oCKtc3+zj6KcqLg6ZEJHprbsrys9bpC7JnQk1YxnKlsUrvATVyTew8Lq?=
 =?us-ascii?Q?p6RoRm9eyWZQGbi9I53bDfGizW6A5GywCl8Hw7OUvvGKveBE+rIAkLovwMVI?=
 =?us-ascii?Q?1VrbFhKmF4ElNPeOyIVQwz35LnsEShJT9KL4lBn2L0kTdEXY559Lxc5izJtm?=
 =?us-ascii?Q?2A2p+tN1NdzDFjUSSljGnuHCIeNG2zAIRY1lgTWUoOSPw2Cw39eTl2o/dJzQ?=
 =?us-ascii?Q?nEqT+/j8JPeRWBvNsrOqagveyG3KzoJ5fRgNpgvRQkdC9w7Zp69hk5f93d92?=
 =?us-ascii?Q?8u6fVf+xHDPiaC4X3Khdw8FwN6FFsvlkqU9IZkgihc+9myknS9dRRDlgneNY?=
 =?us-ascii?Q?xsviGonZ0yuCCUgvrkWAPcIH3S2vgdGWquS13mtge6ZHcRO4exB8L7UCKvnT?=
 =?us-ascii?Q?Wcbs40z0fz5TAVfA1NFNTfKwZVRqyp/GEvdxQeXajGbn4QVeyBrPx1vBy0T0?=
 =?us-ascii?Q?FcTtMqCCWjLZY7T69dcSDfEZzh6IGg23LMT7+xAPlZJtooRo7hmDaxPh7Iyk?=
 =?us-ascii?Q?NoU2e2UvACJE3bSC7KCFmNmSt4oO55HIGDWiItVEfDpOeuA1ca/UXsRfEHqe?=
 =?us-ascii?Q?Rj7BGIbrD7BvdwoqDE1MSePmOQW+wmbus7p+7U06jc3SIL3c4pxLSoxnY0t9?=
 =?us-ascii?Q?SkE7MoGfdEPGtw97AM+RLHFWLbYL+dxcb9LCqgr8SHEv+rMinUKJcBHT729q?=
 =?us-ascii?Q?oW2vj8KhcYGWucvD436mSD5YwTViYl8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de4ff39c-60c5-4af2-94eb-08dee29bb3fc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:50.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcBg44gWhAxN3xigMQvYSm79TO+Ixq4KR9/dNG3leuBGu/wtAfqYx8I+saTHkzrdzOJrKqj1Nu7G0BiLE0AvnXHP32mMsPGfKyxsP774jXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 46B27180003
X-Stat-Signature: xmit67s81ntypioy8sezmxtzk43g4isz
X-HE-Tag: 1784138765-568203
X-HE-Meta: U2FsdGVkX1+ZXdYoB9Alt5JUp/JWvZ+UI+ev6LwpmA5thDxi9Q/VD9OQ4wgenYZE0OX+DL9axpoJC6GtkmdN8fDc7PmT3tsf8OmioXTfMNKavDcU9tLte8utAb76BdQRIrvkcWfQGmxHFD9fHapkKSMaKdHm6+o4x38jZX9aCCO2jg0p1WlHzi/O4bZvVkpTO/pDcAl/HHIa0HFUpwByNxJdG7MLv6VlGya1T8peHFgVSstn43WZkEMxtJo3Y9+PxRU4rIdlZNjG480V23scjOHjEDysSw6xi5vkFsvoCzFw0hq9MPTe5QQ41zwFUXt/dvxobFQ+arMjiHiomQ/EgdV2eLLXNSko32a9Tik18ooJyMEVWQLAGu3xLgEpI9jsHhDBM+heamr05c1s+ygRcrrIsr1BlM2fIshkByi8Lz8rHcRnFE7I+MBTr3kfPxtIl0mOE/cJWZZxBymE7RGqkmhp9RS2S/IFGxX2Axs+/eeZ6UmmJKs4ju5Tu/sV0Mudg1FxT1o310uskt1cfo6TkQLydd/ml0MfV+68XVH4Q3p4WMHd8eCQMH5abFpYdqYEmuYtlzgWA5KaFmRXJKNJRz483thX5ol9L9HkZGnnFIOGFiiGE+pX+hJqwx1AbJeTuO1JGkfDvWK8h4f2rg4DaHO4QMfBseyQkNpbjLAOxfbJAKjA1Vtg8bNVYgiUxEEJjHXFT/Ewb6XQcL9wG5wi5L354VC+sVCPaVbE5/FSlk8zR1XDRG1BlDGCCM1HR+zevYQmBrw237PbwCRw2KpMmR6N5lMcMxveQJCRlODr+T+PxB6PSympGH09hUmo8ERNp0cvRPkwuDnXobbE30SknlhZNXzjiEYN2wG9Y8kdOU8K5VWEqzrjsQfju6MK7346skelP8cWuIT87qh7+xsMJJ+VOJ/3xX0det6FejWYQKezLFgtoVkDblm7l5s58aH+dSmyIjo+1L3PIUj3HkU
 qRQJap3I
 M4nOupyF+XKkMZNeXx9UW7h/P4b0Pf7I9EEevcer9nPBGfuqx1ctwuzOwxqJP3JLrbXGGT3iuDkYj3crDVQZB3tg3tiIP5b5BRHKPUsXOAowL4bnGNW1XAk9YF9jwAu6WAbLvwAuyZtDeuZZREF54NGqfIdUQxdCv0NCa358f5J3Lj32kzHFdrIiiuNAgt7vBfWNn677j06hbRmfMf3Vf7a1zyTF8Zc+7pMO6FDQp/3h67o2j0beeBF7AfDCgi9fPDWQeiPg2OtmiOJNRn29aFe8dKyR3J/oLS2iZxfNzz+4qQdZIMwN5Ebttdtku0iKwOU9S/2J4svMJ5EECvYOJb53+mXdG1Lh1/J4q9uOBbmQGXHE6vkiPMwyoPh9LO58vqP0LhH85PnqRowLk93iqKJFoIpW8bzOx48WMti1eTbDEchh8/iGOCdycvfBcEjx4xA2NPy1+n8XdSrHr9AzYTT0LDqihb+7o6c/LJZcwWAcOIsgGJdkejXMk3nLS+S4NOakM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocate local percpu vm area.  The delta between the allocated addr
(chunk local base) and pcpu_local_base must be same with the delta
between chunk base and pcpu_base_addr.  Each CPU's local percpu area
will be mapped to its own page table.  This section of page table is not
shared between CPUs.

And free local percpu vm area.  Also unmap from percpu page table.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 include/linux/vmalloc.h |  3 ++
 mm/percpu-internal.h    |  1 +
 mm/percpu-vm.c          | 94 +++++++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c            | 92 +++++++++++++++++++++++++++++++++++++---
 4 files changed, 185 insertions(+), 5 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index d87dc7f77f4e..daf9965a111d 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -313,6 +313,9 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     size_t align);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
+struct vm_struct *pcpu_get_local_vm_area(unsigned long hint,
+				     int unit_size, size_t align);
+
 # else
 static inline struct vm_struct **
 pcpu_get_vm_areas(const unsigned long *offsets,
diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index ec2e55a2f836..4d461305243b 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -70,6 +70,7 @@ struct pcpu_chunk {
 	struct pcpu_block_md	*md_blocks;	/* metadata blocks */
 
 	void			*data;		/* chunk data */
+	void			*local_data;	/* chunk local vm */
 	bool			immutable;	/* no [de]population allowed */
 	bool			isolated;	/* isolated from active chunk
 						   slots */
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 4f5937090590..5decaad7640f 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -112,6 +112,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 	return -ENOMEM;
 }
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+extern pgd_t *percpu_pgd[NR_CPUS];
+#endif
+
 /**
  * pcpu_pre_unmap_flush - flush cache prior to unmapping
  * @chunk: chunk the regions to be flushed belongs to
@@ -130,6 +134,11 @@ static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
 	flush_cache_vunmap(
 		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
 		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	flush_cache_vunmap((unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+			(unsigned long)chunk->local_base + (page_end << PAGE_SHIFT));
+#endif
 }
 
 static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
@@ -137,6 +146,20 @@ static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
 	vunmap_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT));
 }
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+static void __pcpu_unmap_pages_local(unsigned int cpu, unsigned long virt,
+			    int nr_pages)
+{
+	__vunmap_range_noflush(percpu_pgd[cpu], virt, virt + (nr_pages << PAGE_SHIFT));
+}
+#else
+static void __pcpu_unmap_pages_local(unsigned int cpu, unsigned long virt,
+			    int nr_pages)
+{
+	return;
+}
+#endif
+
 /**
  * pcpu_unmap_pages - unmap pages out of a pcpu_chunk
  * @chunk: chunk of interest
@@ -166,6 +189,10 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 		}
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
 				   page_end - page_start);
+
+		__pcpu_unmap_pages_local(cpu,
+					(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+					page_end - page_start);
 	}
 }
 
@@ -188,6 +215,12 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 	flush_tlb_kernel_range(
 		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
 		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	flush_tlb_kernel_range(
+		(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+		(unsigned long)chunk->local_base + (page_end << PAGE_SHIFT));
+#endif
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
@@ -197,6 +230,32 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
 }
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+static int __pcpu_map_pages_local(unsigned int cpu, unsigned long virt, struct page **pages,
+			    int nr_pages)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < nr_pages; i++) {
+		err = vmap_range_noflush(percpu_pgd[cpu], virt, virt + PAGE_SIZE,
+				page_to_phys(pages[i]), PAGE_KERNEL, PAGE_SHIFT);
+		if (err)
+			return err;
+
+		virt += PAGE_SIZE;
+	}
+
+	return err;
+}
+#else
+static int __pcpu_map_pages_local(unsigned int cpu, unsigned long virt, struct page **pages,
+			    int nr_pages)
+{
+	return 0;
+}
+#endif
+
 /**
  * pcpu_map_pages - map pages into a pcpu_chunk
  * @chunk: chunk of interest
@@ -224,6 +283,13 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 		if (err < 0)
 			goto err;
 
+		err = __pcpu_map_pages_local(cpu,
+					(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+					&pages[pcpu_page_idx(cpu, page_start)],
+					page_end - page_start);
+		if (err < 0)
+			goto err;
+
 		for (i = page_start; i < page_end; i++)
 			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
 					    chunk);
@@ -233,6 +299,9 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 	for_each_possible_cpu(tcpu) {
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
+		__pcpu_unmap_pages_local(tcpu,
+					(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+					page_end - page_start);
 		if (tcpu == cpu)
 			break;
 	}
@@ -258,6 +327,11 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
 	flush_cache_vmap(
 		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
 		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	flush_cache_vmap((unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+			 (unsigned long)chunk->local_base + (page_end << PAGE_SHIFT));
+#endif
 }
 
 /**
@@ -349,6 +423,24 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	chunk->data = vms;
 	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	unsigned long delta = (unsigned long)chunk->base_addr - (unsigned long)pcpu_base_addr;
+	unsigned long hint = delta + (unsigned long)pcpu_local_base;
+	struct vm_struct *local_vm = pcpu_get_local_vm_area(hint,
+					pcpu_unit_size, pcpu_atom_size);
+	if (!local_vm) {
+		pcpu_free_vm_areas(vms, pcpu_nr_groups);
+		pcpu_free_chunk(chunk);
+		return NULL;
+	}
+
+	chunk->local_base = local_vm->addr;
+	chunk->local_data = (void *)local_vm;
+#else
+	chunk->local_base = 0;
+	chunk->local_data = NULL;
+#endif
+
 	pcpu_stats_chunk_alloc();
 	trace_percpu_create_chunk(chunk->base_addr);
 
@@ -365,6 +457,8 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
 
 	if (chunk->data)
 		pcpu_free_vm_areas(chunk->data, pcpu_nr_groups);
+	if (chunk->local_data)
+		free_vm_area((struct vm_struct *)chunk->local_data);
 	pcpu_free_chunk(chunk);
 }
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9ec401918736..3d94ca4bbd17 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4923,17 +4923,21 @@ pvm_find_va_enclose_addr(unsigned long addr)
  *   in - the VA we start the search(reverse order);
  *   out - the VA with the highest aligned end address.
  * @align: alignment for required highest address
+ * @pcpu: whether request allocation from local percpu area
  *
  * Returns: determined end address within vmap_area
  */
 static unsigned long
-pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
+pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align, bool pcpu)
 {
 	unsigned long vmalloc_end;
 	unsigned long addr;
 
 #ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
-	vmalloc_end = PERCPU_END & ~(align - 1);
+	if (pcpu)
+		vmalloc_end = LOCAL_PERCPU_END & ~(align - 1);
+	else
+		vmalloc_end = PERCPU_END & ~(align - 1);
 #else
 	vmalloc_end = VMALLOC_END & ~(align - 1);
 #endif
@@ -5042,7 +5046,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	end = start + sizes[area];
 
 	va = pvm_find_va_enclose_addr(vmalloc_end);
-	base = pvm_determine_end_from_reverse(&va, align) - end;
+	base = pvm_determine_end_from_reverse(&va, align, false) - end;
 
 	while (true) {
 		/*
@@ -5063,7 +5067,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		 * base downwards and then recheck.
 		 */
 		if (base + end > va->va_end) {
-			base = pvm_determine_end_from_reverse(&va, align) - end;
+			base = pvm_determine_end_from_reverse(&va, align, false) - end;
 			term_area = area;
 			continue;
 		}
@@ -5073,7 +5077,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		 */
 		if (base + start < va->va_start) {
 			va = node_to_va(rb_prev(&va->rb_node));
-			base = pvm_determine_end_from_reverse(&va, align) - end;
+			base = pvm_determine_end_from_reverse(&va, align, false) - end;
 			term_area = area;
 			continue;
 		}
@@ -5236,6 +5240,84 @@ void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
 		free_vm_area(vms[i]);
 	kfree(vms);
 }
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+/* Find free vm area starts from hint */
+struct vm_struct *pcpu_get_local_vm_area(unsigned long hint,
+				     int unit_size, size_t align)
+{
+	struct vmap_area *tmp_va, *va;
+	struct vm_struct *vm;
+	struct vmap_node *vn;
+	unsigned long end;
+	int ret;
+
+	va = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
+	vm = kzalloc(sizeof(struct vm_struct), GFP_KERNEL);
+	if (!va || !vm)
+		goto err_free;
+
+	spin_lock(&free_vmap_area_lock);
+
+	tmp_va = pvm_find_va_enclose_addr(hint);
+	if (!tmp_va) {
+		spin_unlock(&free_vmap_area_lock);
+		goto err_free;
+	}
+
+	end = pvm_determine_end_from_reverse(&tmp_va, align, true);
+
+	if (hint + unit_size > end) {
+		spin_unlock(&free_vmap_area_lock);
+		goto err_free;
+	}
+
+	ret = va_clip(&free_vmap_area_root,
+			&free_vmap_area_list, tmp_va, hint, unit_size);
+	if (ret) {
+		spin_unlock(&free_vmap_area_lock);
+		goto err_free;
+	}
+
+	va->va_start = hint;
+	va->va_end = hint + unit_size;
+
+	spin_unlock(&free_vmap_area_lock);
+
+	if (kasan_populate_vmalloc(va->va_start, unit_size, GFP_KERNEL))
+		goto err_free_shadow;
+
+	vn = addr_to_node(va->va_start);
+
+	spin_lock(&vn->busy.lock);
+	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
+	setup_vmalloc_vm(vm, va, VM_ALLOC,
+			 pcpu_get_local_vm_area);
+	spin_unlock(&vn->busy.lock);
+
+	kasan_unpoison_vmap_areas(&vm, 1, KASAN_VMALLOC_PROT_NORMAL);
+
+	return vm;
+
+err_free:
+	kmem_cache_free(vmap_area_cachep, va);
+	kfree(vm);
+
+	return NULL;
+
+err_free_shadow:
+	spin_lock(&free_vmap_area_lock);
+	va = merge_or_add_vmap_area_augment(va, &free_vmap_area_root,
+			&free_vmap_area_list);
+	if (va)
+		kasan_release_vmalloc(va->va_start, va->va_end, va->va_start, va->va_end,
+			       KASAN_VMALLOC_PAGE_RANGE | KASAN_VMALLOC_TLB_FLUSH);
+	kfree(vm);
+	spin_unlock(&free_vmap_area_lock);
+	return NULL;
+
+}
+#endif
 #endif	/* CONFIG_SMP */
 
 #ifdef CONFIG_PRINTK
-- 
2.47.0


