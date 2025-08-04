Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7078DC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A1F6B00AE; Mon,  4 Aug 2025 09:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B806B00C2; Mon,  4 Aug 2025 09:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACAE6B00C3; Mon,  4 Aug 2025 09:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6F486B00AE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:31:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C03D58B8E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:31:26 +0000 (UTC)
X-FDA: 83739161772.22.D056A94
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id B51BE12000E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:31:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IA6DKP6X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zlf7erzE;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754314283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEnYQMvHXQIO87ASjBeiagXlFo3zF/tu6JPe32N8qgo=;
	b=hByczrsRleQ8b8GqhIvC3GVLJ6TN6sw0nY0HM6egLAlVm+weIH+B1qGmdew0yuXsDvdW0u
	rcvMgz0lUiDXfwzPW0xXUBgRZLUAvtOxtyxXlria6lCDV5ERoBl8hAPRpvIqZd9qNxa2Fn
	nZKJkPgOypJfvMEXEPaa8WzjBaX0oKg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754314283; a=rsa-sha256;
	cv=pass;
	b=MgjxAu4kuqctcdCdqo6CKbwygO0bASZQP6Xzvx9zfYfM1/VDPlFkrY2xVDvdSAAtLwi1HL
	7ZrhX4bamqJ6o57i+z/i+SRex1kfKsuRXPvJbo747f58nMOIFT+Lg8GW/HjseDwBvCO47C
	jku5WfcMjCK6GYiBtVbVIO/1KWFM7ro=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IA6DKP6X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zlf7erzE;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6fsg021638;
	Mon, 4 Aug 2025 13:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FEnYQMvHXQIO87ASjB
	eiagXlFo3zF/tu6JPe32N8qgo=; b=IA6DKP6XfNZtymztqLOYOUBwkcnnF/PIIj
	06FMtDUWTKPZciw3XG/f1re4bmfgjT4T1fT8ugUn6eSBPIaxxKutTl2+zOBhdV9i
	gB4zBes26bQTZsmIMWDzKhNrOj16d5NMV9kEwPRe3Ewfq9MleiId1HhV2qHbBXBX
	WyYv6YjeLBy5ZgugWIcfdKUa2Pqbize1Czkbe2gPNsIRMfu4SsmGp0mXvBnanEGv
	BQ5IIlUzCHdTMLDaUE7b1SXuRt2mS1avBQaZs5MZ0nOkVJqEoe4I9ZPkZqhrcqtR
	GAlXl/oJvEyTYej9xy+n0mTY9p4oqSnmUR4tTDaGGO02nY+INnPQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899kfapa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 13:31:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574Cu4Jb031976;
	Mon, 4 Aug 2025 13:31:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jum30p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 13:31:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SVdDEMfkS7ByA6XxXoktx1al0MCo+5l/s/MH/AH2QjcuRMh9mI0jW0EZmASyOdabmkWftdkCfybEPyAZB+EsWaDnJH0XtEsSN81/jdd1kYs5CJd/1gCG16KUt992g6v/f7e3q69GrtfDoVU+fUhWwPdyx0xZ4XzBZ+4w1n84dg/IrjRikPvJryt48eiRnbwNnUperuIyT7lG+EiencSMIL9cPXPzqnDQoa75AMWNZchFo1wq9GGzBPbVD7FBSoNhk5WH9KGT8alrDKUaiNWEKuwzJ3uRA6GuUyp3bhNpOG/mQnyZik+6ARqeHMhMyIiNybudHqfOfjGAyiabINC3Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEnYQMvHXQIO87ASjBeiagXlFo3zF/tu6JPe32N8qgo=;
 b=f6C6njy/dYuiqrMLk0rtofinV23plmwK/jYmEomdTtdh4afJauS3O5DQqNWudViYoGoadWCXNBASV7YXgVDogboBl/qxfUKARrB7F3RohjGQXdtqdovUmlbEQVvg45TK8tYfbkAMzUaw2bB1FIb0ZbTNwvLrSfPZvOGo0MZqeieeAdWkJfDdDX/W1kKrKAaw43UQya8cIKm4FkOEW642zYFH2iJ9sL0qcu+MbYScxSRj/R4fsygaesaG2jov/RQYViobYZyjbwHCRC+NVZ++2uum6s8SGGfx7V28HNtVXMuOai3xaO16boLhNYwShz943iNpvd5liCr51dk3k7Urlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEnYQMvHXQIO87ASjBeiagXlFo3zF/tu6JPe32N8qgo=;
 b=zlf7erzEnGKWwdsZnf93IJktxjF6OceSfluEZwYNHfuhezrGNjFmKVTzLHmx7GURaD+WvAfH0a4UXP+2LPWQfKfnG3mZpH1wW7gSPFudwQ4z8PUrTq967E3CmKtEA45ayTnKeV2xLGbQpz6XllUWqs8fe9VrX7ZMQLl9FgRbnZ0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6742.namprd10.prod.outlook.com (2603:10b6:8:10e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 13:31:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 13:31:05 +0000
Date: Mon, 4 Aug 2025 14:31:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <67d11254-67d4-401e-ac8c-a8d50e43f087@lucifer.local>
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
 <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
 <ngytuoex4uvu5epsdqhvhypnhqidkr7cpwmmcxrml6kpftgusb@jo5ql6eko2ir>
 <0e3d0dd8-994f-4665-969c-6daf332c5b94@lucifer.local>
 <dizfk5jqwwzozotvkk6phb36blcpsve3yw53xrdjwqeut27djt@rftbd7lkgsjp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dizfk5jqwwzozotvkk6phb36blcpsve3yw53xrdjwqeut27djt@rftbd7lkgsjp>
X-ClientProxiedBy: MM0P280CA0078.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d9b4ec1-5cf5-42a7-066d-08ddd35b29d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Oqe9G7x8tl3TczeDsYlVhowJpD81N9JWkyojUMYINZIYfeDJiBvhrQYKXoa6?=
 =?us-ascii?Q?mOWV3H91qjuXBmpwZGskOAvRG7yh0Ra5CA2scOZmIR9aKVrR3id8ix4sajXM?=
 =?us-ascii?Q?paHcJMPQmeelc9d//QTdYdy1WITOVk+6kHKaRNqPA+IB2ghk6viWagIORkP5?=
 =?us-ascii?Q?Co1P7LtDXR0K2BJWUV8trJ4i4NIexgfpKziuv9D3LV2v0r829N85B7tmEnK2?=
 =?us-ascii?Q?b0glzjK7Fiqq9dINY8HbprPKDsdfE7c5ptlTq0LdrfrOKGsTsGH4oQ+bW7NH?=
 =?us-ascii?Q?TtQpJc37Il4CzgQdrZEaKS1Vii9gRHSo6wUYqSXcSqm/7j8SrQr1AssBnivl?=
 =?us-ascii?Q?ge+sYOXwIqeNnCLkqrRJoKkjsoEmFawiVGctEGBF0YmzuUoaXbmlwMBf6htm?=
 =?us-ascii?Q?OL7yIx7I+JeqT0i10+kZkAL0O4uy9koPi60TU8cJJ1It4NC1ZOpS2k8btxPo?=
 =?us-ascii?Q?2ac6qLhldgyszGUlzvcoSciUsjU56JzkWKdk17RQStN22NK2bLjayrkNd+jC?=
 =?us-ascii?Q?HPiNCbKqozmDA8ZwdsqUcz0a8LlQnUf4ToTKLEDYx63cPtV9E1HYky3QRAEY?=
 =?us-ascii?Q?eob5oimPCk3CXFFzfXb8+8A8VcHk83es3b1ElZKtEq3tQrn8nzjxLK7mv66O?=
 =?us-ascii?Q?CB7DjgCaH8MhzrP1QxYFrMWDrDff96oiqBa01kz1+Ln5kW2+rBqwFyWje1I8?=
 =?us-ascii?Q?EIyYp4hUWOcX71Fp2c3rN7aQ+/wY2S9mkHseGuVSHXC2Kb+zJW2p2dMgXnpX?=
 =?us-ascii?Q?VbP7MHd5JQD8RICWjrobrmPnk0c7xxDSt+T8NW2cL+rNwEyNK4rVd5j0NDoe?=
 =?us-ascii?Q?mjrPGmyItKapqdo1ySeItaEJg8JpIcZBQHNyi3JH1nwwvpW218r4gpiW7MZZ?=
 =?us-ascii?Q?rFHLGkGrlUnJX6lr4xJXIgMVDdOAIw38MTBPWPWlIVuy3UsA0g1RGL1FdKHA?=
 =?us-ascii?Q?h7Nmw0+GI65Vc9Y6R6RcTO+jdv3yA09s61pSp5MT2Xf2KWk2+saLTqem9pTI?=
 =?us-ascii?Q?lFareT/6BgKjpkPflO2m8CFR7cUMjZ03FrX+aGjhoc0BFOHuTSGeA/nYIyQ7?=
 =?us-ascii?Q?YEMA5Z9A8vRFPVVaSh66Nhj3fa7JuGANzW2vu5KgtLUOz4tFdaMyF6zqrDH/?=
 =?us-ascii?Q?KOH3iuyYUlRFuIxRqsO28MeuNdWntmfDqEWTD/R1RehwOkr2hRgJf/qtgSVj?=
 =?us-ascii?Q?2aFlBuThFVuQQel+NymWdfKzwYgLXN1X1s0RfPD5w1NWlXAN48u1IcB+ZiyL?=
 =?us-ascii?Q?vET9VCA9D9RzVRwUaNOShYME41qm9gPKO+sZWWDb+hpV28oC5kZprBdUw9Po?=
 =?us-ascii?Q?qevq7F2PGw6KZjESnMvbNxielBMs870UN/ZTluCfVZWRiOgNlDLA5IcJ6ygw?=
 =?us-ascii?Q?jjSqM1s86bcyAyDxn5lEwMR0wWJsMJ9E6nyUG+4ZKjWGPQ3Q8pTZgMLYZlo+?=
 =?us-ascii?Q?r+9SCXm1HP8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7YJA7PbcH1CAl5M+hJI7+H3FppbU+guM3hZkgNNS5feKihgXSK4PnNmDVsWc?=
 =?us-ascii?Q?Okl7VVqsAZSYa9NdRAh3GDilk9clDannwn5PDZFQq5y4g43kSXk4QQdoi0A2?=
 =?us-ascii?Q?SJ9BWuO64QvzacrNDpQvq7x1PAQji+UK/TMUslKx5FDmucntjPW/YwNW4mIh?=
 =?us-ascii?Q?x+pWjULgWDm326VPl1T1v3WzM0gf7Tlqb8a9B3Wkvqy622iwC0m6Jx9aOsJA?=
 =?us-ascii?Q?582D+lO26XE4H7BykwPaD4hJPPc9xtA9E0HOIUcJzZUd6Go6WRzLz3Vm+d4z?=
 =?us-ascii?Q?caiA6RQGIW0b2YECLxpTl3ltyDhvWLLr4JzBtT/OQp7HyCc1weAFGJsr4QZF?=
 =?us-ascii?Q?FN2Y1D/34kVmAb3zPrUNhFR7syZmrnEOBMLcwuDtClifk9LXYFiZCau84V9V?=
 =?us-ascii?Q?yaD+yCJ50FUKT1sKTrqqW8jCjVqAwDHJlQtcd8XCnk6MT0g2kicWY+fa8/qC?=
 =?us-ascii?Q?+QvumgRfLjdgWb8N5vPHKLswjgpu5hINP/cbye32tyS/medJ8QbyohKSjlvB?=
 =?us-ascii?Q?iM2yrJ7+7WzQUE7DdyxFxTAQW/kyZREr/AG9O1pPMu4fIozibAklzIqj2v3e?=
 =?us-ascii?Q?J20lHQu9Wq0ncD9UjM8U6zOwW4bglLLt4vY4GEqHXFZAuy5CcvIBWgjlJkQR?=
 =?us-ascii?Q?0AUttFdLF7pZ1bC6V+tpLB1vmHOKe4F/WnEwvq57HTR+iGVEaYmNso0rqSyp?=
 =?us-ascii?Q?+9ZQlshrv8kOgkvawb+kpfvVcQefSh9O0Y2P0XDGEsrmPhKc//S4fi3oERTr?=
 =?us-ascii?Q?7biQNakL9RZmyCP4MD1pQ/oXREz1Ur6V/FioNbADLSWs+X5Q/FQFXXrWqn+o?=
 =?us-ascii?Q?kY+e6ooyfqxzQ7FdegHYa6S/daRppXIeZwA3kl8wy7K+TJHDMLEfQpYo/FYJ?=
 =?us-ascii?Q?bDw5UhIeXtym0wEtqc6xLOCRYXqpL9mJ0mtzib8dO6G2cHabRlRwDjMEW2O4?=
 =?us-ascii?Q?GNmdcQ4/GtGpxhCWUo/CX0ebclBGi2K9q2FRssFX8GlLS2lEONmUrkKpGAIH?=
 =?us-ascii?Q?Djwnoka4T3U2Zcscb7Cw8/GTnW8YExAspSf+uROfJsevMh36sDWnQOUc8pqf?=
 =?us-ascii?Q?wPkS4tZ+r5+gWMO3abkGLALpJRo1j0uIxmqSuJlBfV0+Vby6TcivYhevbg5X?=
 =?us-ascii?Q?UOmzl8Vw6nKDUD+MwC4zHMKEcsdOvC+wCwSntrSnRJXEzfs+oh3SR73rEHbB?=
 =?us-ascii?Q?ZfzOYFQggVhsgpYR/+klsIVGgu9kLAAL/n0Swvkk28y0OSvDEhiSPne5+TUR?=
 =?us-ascii?Q?xL1NlnfU8llgmFKV8u03Yzj6GCBEY1q5xLBCJZRKJEjhDOsrB76AcqNpR3Y8?=
 =?us-ascii?Q?7wPOb3dhUJOYoKqWTdlrmuUa/nsk+w4UxfnpV7V/BsjSDsuE5AqFvi389khg?=
 =?us-ascii?Q?6goLPFPc+iJcV1RHn7SqSqTbrCKmpc2RRvOq8sJX3T+W1MLGxUYyNBvVSsF5?=
 =?us-ascii?Q?1pHTZdFu7b4bcebcrp+/uIf5G2Mqo46bnrcG5TiOhsbC+1GcfKgnnZyEBShV?=
 =?us-ascii?Q?adpTqoGCXTFR8AhuWKz9bsC8ttdRQFRAbiUSEXcfnCHjYEgGmRffjR+9Ra6Z?=
 =?us-ascii?Q?K7usFc5jhA5TqCreBJyw6V6pC+olo8bENE5XERnC/hgs+oEDVYiWOdrQbHHx?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5lmZu2Vc7OdnnwoRTlXW+8DtiFuh5bBoDWQXA9sxb7owgo8q9Ioi+op3dZST8C4uyDDepRXfiO5pysslER+ISBO55J7nLdJML0L7y9KAyhVh4BoPEdwsYRAMWhpFcjfxV+S56L1apG80n+kJ2fNrCHSKg6/aFbuHEGvUOqI4DjbDUNxX2XsjPfjMwG3/YOKb2niwEIfqdIep2nSt1fbh+GIiY65IBAG6SXhbHSICmsEZkVsiQS1rP5Vo6ZkF2Swgik4WzcsBHrfKplcjeT1OhzLmDHBuLx+APdXpM2wYYO+8/mUyiywa/890kQ8HIc8vUnMMGkyVcsHBQPqfCCtVx+lptS0JgtWeonsdqjayB+pBIucgO/LPZ8ParE86IlYWDwkSWCjSXiKtpcOh+EvPspRF/x3rN1IzsNVYMhUUDaNhIknuvUpNdXzXUmESMmdeyHrz/CA36P+st2j+wOoI9jMDDwHeRHd5jmtbxx+GosMJovrAKnZzMbyOFu/2pWKyip98YywHfk8CypLr+ByKB7VWxX0CCds32DA6tJPMPB+ypsz1hpCN6llQ1bF8rBev6+ZX8hC24I4phkx9DGb1AyB+sP8EyQ8Pe+LEL5aJpVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9b4ec1-5cf5-42a7-066d-08ddd35b29d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 13:31:05.4112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LHe311RBX5Ywg2mrNWyP5SB00Jb1UpfULrUZUdUIqdpv5sEdjRB6HpGc6IMu03S0Sz/YKIU0LsNz26d+Qg+LfldlLUurpxSEY/w4EzJFyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040074
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA3NSBTYWx0ZWRfX/cczVgEwFdDq
 6un822egQSZs9fgC4A4Rw5Y6uS1lV/XIH+0EOOdL+pSsrERgumviuKGtVZHXcyqWVwKG6FCiBoo
 kprVnrwed/EexI9gHez5RYtVckGq35Ye+hvyHRcYV6pr+nCLIxedKZliQxf5lEbluMyVFOwgFzx
 T+2u+TaESpY+BEeWHiXp9/ZGOXSTiuyvq//wcKT3E3X0o9wnoIyi/WB/RXYIMOByxKHTnX4phqa
 2Dk3I8vug9bijZJ0KdQ8F8q98SckY1DZJ1ZcV+2XnuLUXhdvETWF0RvbLLFEGzgn0skN/NDY4jv
 gSoeUPuflmPzbPuhd5W3xE9ITwS3VAHZnHa9rrq6R+A4PRPjObAQwMhlhsrMPUGB9o1mzkxdF1V
 X8sT84paYZpG7UcBbOLzSgfDhYAjrnch0YMwDVMze0weJZYZLXvsUxHngLbfGa//6dreIsz1
X-Proofpoint-GUID: AwFa-UnWOI0zWDd6YG2NIFajMqtmKwa-
X-Proofpoint-ORIG-GUID: AwFa-UnWOI0zWDd6YG2NIFajMqtmKwa-
X-Authority-Analysis: v=2.4 cv=VMvdn8PX c=1 sm=1 tr=0 ts=6890b625 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=cruQpLOzQDgxFGfOXy4A:9
 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B51BE12000E
X-Stat-Signature: d75fg9au9cyor65b4e494ys8pugsxpd9
X-Rspam-User: 
X-HE-Tag: 1754314282-238881
X-HE-Meta: U2FsdGVkX1/eYGsSXpkm0N6yFJyrH1al+lY0IMYPLWs2UQC87TSnyHfsMnovLmxU/z1i8YYObQP8ZjaY/SA9bxh48nZSciFe7Gs7b0fYRVpGhV84/InUgBUhYb9K5YGpcdrQslrpUoQA9cpcjbgEXWwD3V+ZH87CbxeGIz8AeM3KYK3YzFdRGa+wkn9J4dvlYLSk+YqyQaGxTwUNdneld8wQWqYvVfie0OTXLv0l3splutSgEONYy6h9LA57vkogRDdVmuCeyX4twhj8Cn6zwuppnmqjHBoKXFXM7iUMkVpLF0OxN6OCNplMjnksqaq/jaAHwUQpLENqwvGAuX3O68KxRWmX3zCuTpj46P7jyRYjst5k0vB6dRDA0mI3QpkOK1RRoDs94kHTdEYrEp23z4PCqsEwvmVuXfkMLRv2OzYEyZSLTlF64eSqzV+XN790XjONruJS8qE+B2WSqqf+y8wsmuSh+a5+wPOEOAgKWGoos6GlJC5YBBollnGMeN7ki0FOa0xgRbXX6G7JnQ5sGq9sf6uSg5tyxEY+EgQD5ucHgrl1ubtwRjLWV/yqxYK9FsUUNY49zEr0/0zgzItXYz385mZACc04NYcEZSu408j4RR6zJRlGSXeObkBWYpqjofUpdINMHKRZOvZc63c6B9Q9xdh7iahKWAkhdgfs7gOFFUoJ+tKNNGEuzadFFayZ/+J1wENrGQSEsYot6qIgeffjaJunS+3cdFRhovtK5EHLdVCee1tCI1qGBNxykV+nh49kln+ZiwnWSxKGS3Gd0WOvdeTiLvYep6TndNtRR/crmbj9DSYua9vQi1LcmKkWNWHjEF+NlVw/ygBb0e5Dc7BfiGJURubRDXq6bi6l6mIJK/Wf8c5iqm3OcJIi2hBx9WQWVE4RZemvhF9mqSciS/0xgvKX3ZK7RoSqgSUyvyrX2UomRQfGayr6GF1CJh/ofdq0qKIpZGIl+EPlOUC
 kNEn+pC2
 d4YRrEtmwclqxarthOZTkmuh/ssHu9rDNjHL/NNMlaVd1Rmn+t7qnf627YjsPBVKNe3bf3aiNcZxqWFm6LYjtdYbnjl0pvw24YRun1rnGBaXe7YreqCNKteRs9yCpq+dJUcNyLnLRc5pPyAd3IU1oIW/HAs8GRgTUBozGcMtAjbt2oMSvcT8QJPvXYZI0PsLo6O5Lwhg8Y8kTTAg4ilcBqle6/Ox0qM4myCZVgHjZN9PMHC0plACoFeXL66VdvIjnWJNJr1CNLdWLdNeBZlkU5kH4oM2pNuAZjYY/DRmfcS0S+XeawbEIBI9ZrVZLmeFupA722x/9VExGPiuDpmBOFQa9Tq/6vi3jIUuQg8pzep/zLBIocMvtODr7BjfOB5AMlUJ36/sqt5d35qpjKCX65+m35C/fvf7dScM4Lo9xqy4eiZa0u1j7riNLlLF4jTDUAlmetBom+rebt3tPkq/19g0M7AnnnYueILLQIbKKTx07s0IOyh0+RD2uWIWqK6C00fkuxpEOS5xzY+D9QYrLEkWiuYoISehdq+6I/KY7cBHWsa/KS9ShWO6+q+bEM00lVidXlqN0v68t3pSUN/jEwXRz2mkFBvquCh29MfZMZrl4Ammp2MLsOjWQPp7yU56vfne5WpglPNTe5FDcrhcKeMxhHK9uN88G+2+feCgbkL4EEZME9kgb3qkg/eQDbv1ggxo73sRrEt8s8nmL+vJfRM9ejOT0kdjNQ9Ux6gHMnnmkH58=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 03, 2025 at 04:17:39PM +0200, Alejandro Colomar wrote:
> Hi Lorenzo,
>
> On Sun, Aug 03, 2025 at 12:15:15PM +0100, Lorenzo Stoakes wrote:
> > On Sun, Aug 03, 2025 at 08:47:28AM +0200, Alejandro Colomar wrote:
> > > Would it be possible to write a small C program that uses this new
> > > feature?
> >
> > I could do, but it's an unusual use of mremap() and we don't currently have
> > example C code for the _general_ usage so I wonder if it might be somewhat
> > misleading to have example code only for this?
>
> I didn't mean for the manual page.  It was more for helping review the
> changes.  If it's very small, it would be useful to include it in the
> commit message.  What do you think?

Ack I can do.

In discussion with colleagues I also realise I have to add a little more
information to 2/2 as well, so worth a respin anyway.

>
>
> Have a lovely day!
> Alex
>

Cheers, Lorenzo

