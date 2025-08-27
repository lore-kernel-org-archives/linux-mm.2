Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AEECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DB28E013F; Wed, 27 Aug 2025 07:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3DF08E0105; Wed, 27 Aug 2025 07:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992038E013F; Wed, 27 Aug 2025 07:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 772EB8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:38:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A921405B4
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:07 +0000 (UTC)
X-FDA: 83822338614.30.7E65EB8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id B2AA914000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pbpUyAop;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EqlPEqND;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wxjfqcwn0jiVICFhFZTIKrQEXvjlu0yBnfKzNG1zRyI=;
	b=OWozSzPlezym4MwtSQs4+E/3BCYu6vVdPCIKYAG3uOCQq42DCZF25VHYrxGDWjvvVkR73U
	HAO5EpiOMCLfQFBIXv46r0uXhk5Pmq0iVKshn0aPM3oamu2C3qC/URZIKiYlI7w4c4ylqF
	JYwyf6FvbBE2UPA7xAOetJXd6gkPzkE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pbpUyAop;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EqlPEqND;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294683; a=rsa-sha256;
	cv=pass;
	b=X0cf3rymdkPO3X1ryY5lPusUNjQVM+Y3QHDs/pavhnYjMzyQ2nT8cwLJ5Km0zWf8GXK7X9
	BhqwsajBUVscDdSZ3pmnzg4a7mY+bMh/EjW0bDwVxuqrpeZPDHMAs45qlIGOF1ht4rKUFn
	mrW6RySXb6RR4BBxq2prMDfy9v6NX9I=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7trCe008540;
	Wed, 27 Aug 2025 11:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wxjfqcwn0jiVICFhFZTIKrQEXvjlu0yBnfKzNG1zRyI=; b=
	pbpUyAopmx5s0aHRMjJ5vhrQYLzOVseP5rNOzmEj3gc+QWdPR4jyqzTCJtINX1Ck
	yP67nKcdIscgADYP34yLXMRXqT6ge3mcFtFi0je6A20nEmao+DPcRwTH6uyjUIK4
	uQeTVW/Jy+iWrBwWmRzyBR6l22z9dweUuspuYn84nBbZk7ihHK1xfcJRbMgWhfI5
	EKTE3R2mPwp2X6d93gCUKJasUoDeUEpBUxHQHTtvxBAriaJxiq/byumUAKB6A2nN
	f6ksK1wS8T50ykN/ZPygeDvxiZ7ZG6Zn+4Xf3+yyIXwvmi6ZtP+oc+RGypMtkX/H
	DNwOtnRWGLtRWFMDLcLOMQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt6bhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:37:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RBasMp004951;
	Wed, 27 Aug 2025 11:37:52 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43ar3v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:37:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rgp7cx0eiPTAYZDNNOF+8L8094aAtGdTyBeruokVD6k0OuZ1+i+NE+W8fMdbRocBNtKABvX40Rc2eVUB20mxoYnVE5CuMk/Jy5I0zU6bwPfWGzbE/B8LeqMSP9/i1XA8HpIEpwzC5+0BOpgj2ULMNYJjyJY08BKmJ1sxjHqWJbgA0kMG9Mt5rGdrN+Qdklx0IXoSC/5QHSV2kRWqqXjZaDZIgjgky4CHH95sMBMKimgENlb6dlEv9xHzDnqu4djd+kTi42CjQ1CrurYbXe0OqEW6G7AP81t8oqYk1wUN054Lo52RMiMr/hsmsKMzkAoChpmwhgXe6cOW1xFnz7339g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wxjfqcwn0jiVICFhFZTIKrQEXvjlu0yBnfKzNG1zRyI=;
 b=hqemsAWcl8OWNw6h1F5cdKPmuNoxlBK8Qwcs/3SiL3IWCw4Iv2xqnAdvVVwEu8AFAzuaSLjUFd/VXilJatzMnR8Aj+Cd7qibZO34Ti2F+XTINJp7EPxc3umx9cvLTXeDZEtepvZlmoqPf+WtSIwwRlxbNmBtfHmLF0CF+fCDPw/tRFrqJ+VxHf99yxT95zzbXjr84osqmxDPPW845XRyqa5QKzKvwsZt/uI8F9/0/l0O1BXyOlovtMK0PpAmNiztpS5jJXyzHRr2L+Zik8cdoxC/WFTQ3HTVGxr6MUg4eljc5biTCksSSh8EUpyULXj/S60x14Lw6A3Ohb2WbF+LeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wxjfqcwn0jiVICFhFZTIKrQEXvjlu0yBnfKzNG1zRyI=;
 b=EqlPEqND5JL/+B+IjxXdg3txKbbCmW1Omb6hRVkBjyt8SrwP6P3zgBM6U7eAODWMbRGitPoZmGA7zDQL+02l283IGvOyjcs6EiJWB9pwfo7DJ9UAti48VLEsuIT55r9gI0in+8nRG9d5QQPMfZ+ptPVAAIj/2vBhd5mtPJPOsjY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB6721.namprd10.prod.outlook.com (2603:10b6:208:441::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 11:37:48 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:37:48 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com
Subject: [RFC V2 PATCH 2/5] mm/slab: abstract slabobj_ext access via new slab_obj_ext() helper
Date: Wed, 27 Aug 2025 20:37:15 +0900
Message-ID: <20250827113726.707801-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827113726.707801-1-harry.yoo@oracle.com>
References: <20250827113726.707801-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::27) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: d932f922-2df8-4d73-7f9f-08dde55e25f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CETKsh8AMYzFc4nuhuO+/3/Jd6C3Gi5D1nmEHYXv6mFiPhWUyWG2PzQtbOBR?=
 =?us-ascii?Q?2htaUnRAj8tbSM9B4D736YCvaJXdFG5TlGJ/XOzMLjF9lcxjK2fYok89R2T2?=
 =?us-ascii?Q?7O5ZsYjcSgK+RHZl+jC6lm0qCshsKeUWlPjUBjI94mkMokqWqOuWgwllL9ml?=
 =?us-ascii?Q?yGULx529KEVv+UHpnJaBZns+baLSSjhlmxaNrcA1aH6fnz1zfZ+K35cqVdOY?=
 =?us-ascii?Q?K52q5Oq7YzTwaTziB3LGbtA8zWYyk6An63VgwcO5BaYGDuujbmcwgh3AiuO+?=
 =?us-ascii?Q?ZiAtl+o4ZiiiR+nxMDtd48BZHU7xb2r+wGQMS6XMac0m9xR64Np5Z1FtRgC6?=
 =?us-ascii?Q?IEHqkBRV2OCcfq+AuGXg1vvLvY0rHNsKg1eAiC4uw4kw2o6x4jUdMpl/Rfxn?=
 =?us-ascii?Q?FSTB1VX3fb+f5zW3oITsDst8bq6K89xYbsgXt1q1/B8TXzeLYHrlaE9SZfEG?=
 =?us-ascii?Q?KgpnKYZ9B8zr0BIxO7+ER9PgT2+zlNIhbeQSbmQ23UmgrpFV7phfvJOPED42?=
 =?us-ascii?Q?ehVqIUZXORnz6tRxxqKUDBXquuTQbjqcxRGm8xPA5JxeeDL5X+8VMZhIX6RD?=
 =?us-ascii?Q?pZIxFtUGUjwu4MpdDBBOmgr00oIzNl4TwELlSQeVVrU/hKbUN3ASa7kOLfpM?=
 =?us-ascii?Q?CnHvLMyB4og2sF4/2bmlTwSqBXGUjW8zHpjKCEoXcj7b/WNvAakoSc/9sct8?=
 =?us-ascii?Q?o6Z8iDSDty94GpXGlsHmJgo5ixjaVOqoMAu4v6QVJ+X2zquNP5DL3ReynoZP?=
 =?us-ascii?Q?yARrjJjCCszylCsJnB2R8x5jE47cvJBO7o5gNUieNZWgEUxDrfAaWpFktmdT?=
 =?us-ascii?Q?DHaJjstfTeZMxeQ17MMSYZrCd7ILCQqDLFJQbSh6otTA2y0xzIQIXEJYSkKi?=
 =?us-ascii?Q?C1nidtG9GlZNVa8o9MbUti1y2y/LNhXhVL7bYZVJnovganceGomuddnSGYCt?=
 =?us-ascii?Q?W/22HwqjNKS4w/sVXnHOtfDrL0ED55XSU9Pbj9HIz0Etf4LW/MmgOlPZvlPs?=
 =?us-ascii?Q?o3UfH+7JoGnRHxPGtVF+eBVc124ckDa/dkOJL1dym2edxm8LXvKuvQJHT7J7?=
 =?us-ascii?Q?7v9iywpi+F7eearYnabRyafEpphQs8oTIQUgo6Sg0gJRl6Tdw6aLKxon4x7Z?=
 =?us-ascii?Q?xeTV1d/rzS90PWmTCai8D/ZxuPl4rXU/OOvgaZEcMhkPTjhBbTRC/vdFAe8z?=
 =?us-ascii?Q?dXb7ZJfKaprJLXrWs1FRZotci9nhMNdrT6nGGeGJB4u6WCiklgnRCTk6oP4n?=
 =?us-ascii?Q?+8C513vPE7fqiMdc86+3QqYpkec7vGfI4Mp3lIpiGQAgOar5zOk7iXCb4w9d?=
 =?us-ascii?Q?5jwooJwM+bf7g/qc4EEtlpdlSCzIf/YYmsTCeJbwyXi8UINdvoPZyS8sD8D2?=
 =?us-ascii?Q?+fp8d9+7f77uwEEEQZwjF6WhPNm2DtlRJb+9Grp4yCp3ZJL+PQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FZ2MHmPbMaoGAxPdMJxWhzLVVOtJZiQFD8A6/Zv7nwLZ6QGsUpwOgRhP1L1A?=
 =?us-ascii?Q?zEvHb4ONS6DfaiufP6c7Zd3jjqf11jX3QstTCy0KkGcyfHMKPgqJNeGcxX7T?=
 =?us-ascii?Q?fuzattxd7aif3gfuoKfoWU6WqrgYNFUhv9bIjr5v7jRHlNjL9IVW3WhfqPLC?=
 =?us-ascii?Q?Oud+EQt+BKhSDiP4i8ADKTVwsEQ2nmCAhfQYqU2gMbKI370C3ZfJhh+cVI27?=
 =?us-ascii?Q?g/z7H+Q5bPuLP7858Gm2XF92zbrw4XIG7s0NBU28RIgogSTpGbHpMtHQDcub?=
 =?us-ascii?Q?Ybwm1iwgVaMgUv6RYsCEUsy2y6G826AYZc5Rq57IVkrdMRFZjd06+VJ8XCRH?=
 =?us-ascii?Q?IZTpjdeAvi4GAxCA1nvVnKX4IkorQvZgmFcy2W4Nk1wodPO13DSgZusWXlci?=
 =?us-ascii?Q?zcD/p5yJOQTmlQUHZWjsqcYI5OtljtPIRu8aRq0Ua04eNidAMAs+xg9G6vqb?=
 =?us-ascii?Q?Q0dKeM3FwE6y6hgrDyhqQRtoYeO5UvdjgXPL0LDfVYRJ/0mNE1J8j0HAMdfs?=
 =?us-ascii?Q?5F4SYG7LwhsPASFapRXrCQMOWNfG4pXNYn5igrJ4cqdV76RTZR7n3+gU3PmY?=
 =?us-ascii?Q?u+esuTEYhK7fUUIP81/njsjohJW9ythmph/1518ukV/auTyr0S3mHOEsIKbo?=
 =?us-ascii?Q?oU7X5xBPeLHYANPE5gS9eJkoUS22QXrnJl5z3jGFjSoMOJZfUU4nMQXKEUKH?=
 =?us-ascii?Q?xqbolMFzeYbEEAZLYuvS8vrwo7Fg2C4DWYm2LBYxxmU/DKG/LyoxsmaHb6bT?=
 =?us-ascii?Q?hOPRMJfnymr54MHHPrmOVBsk0VCs24x8hqB3Pg5/PazVbIFQ1N+2URcVU2AF?=
 =?us-ascii?Q?WRJJ72wBZbNVac/2IsxdXXFLhbxb+RMIAjT2dXjXqKNPO98V09xjwQ5TnzMb?=
 =?us-ascii?Q?UCplpJB2cLrszOdTooL5i9QCLrtRq0XI2pBV9ayUSkg6dLAWI/5heEBuaP7j?=
 =?us-ascii?Q?4eUnFZwfZArWgBgdUDIbhfWSHVdCK54dm7tYFSR4uTOXOvLHNt5VYQcTTTjh?=
 =?us-ascii?Q?KwHEb0EGTBKSMqY/g3oYR7EGbIAVmXm2bggeqjuxKSbtNVEPpl7QxpqM2sum?=
 =?us-ascii?Q?FT4CQlOBmlCGxlc/GaoeEAhl6Ac2Dgj1KIhIbAt9Fb5NIjITaml30Mpazkuf?=
 =?us-ascii?Q?h/U+tH5nmjRedk11PiZUt6Qchj1xZ6yJAeyGZUbPQ+h/deaVtr2JT3b47QLt?=
 =?us-ascii?Q?xQeiwV6PnWdBlvOYaxfNtc/OEqDVCcwaNhYN8XaE7eCTcGi0h+iTZRKaTIkB?=
 =?us-ascii?Q?uO4GSEL63ByuuPZYiRv0X0pwx4Jvuc/IsM9cJwAqw1m/PxmCIHWNxNWK2lI6?=
 =?us-ascii?Q?0Pz6jq/BwPbyducu56G5JoTR64BfP+wg+NrqEea1voemBZ1VPsNEIMqYk5LM?=
 =?us-ascii?Q?sFrOJbRTYElvQpC4QeuH17D6brqWj9Yp2zWGNip7apJVh+oCFAm8EvNGJ85y?=
 =?us-ascii?Q?QEjEy/Wtd2Ogf2OvSObryMMVjoIBU0DxchNJMng7R9xPQy4CWdm+qHzc27zI?=
 =?us-ascii?Q?fwh/Rfv4O3EqiKgQ005/H2Psi4uu65cwtOce5/HERlAusFZCkuMDGfc1LRqa?=
 =?us-ascii?Q?Z/oVbi6QigtC9vfI9vtgqqCzXeb0ZRgoNK3BMNAv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Yaj0RpdUW2PImMFAnnwOKuq5Xl4zK7mo+tx7ca2naKYxi36dWc1cG9XJeg+WRCvIulnMioqn5Izvb4F9GcnkKKGHJ0vHDmbmHEkYJeR+QuakPCHDA3BxWnp2iB0a33TvKrbiiPWphxA+P13RKkKsPQbfG+VNqNiwAkLAsCotGu810L9yBi4CwCaTJv0msqEVdWteenoMD4R4MTQKk0kkUEnL62DLE6rEaK55nXVzBP7em0u2iB/E2owmroHFOr4Zl6Y3rkq1NQj7sdNCKPMeAiLNj7ALMcUziwG297hcip1m5OsKkAJTW/yBqoVvXPaP0t9Yn1ZbBipkP98/e11SmEpFQn0yC36FQFhRy0AIA1L9I2GBh587G8cNK5mVcioRTfhhn6EWiKS6CkTdbdyI+E69O07jD2UN1CgElpi7a+tx1mv/5YbasQomDBDiQWEdguJwld5J7T22S0mLiTSY1AZFCNNj8lP8yJICXLvL2c+obk3CWOBdO45c6LkNZaAE+G/pPuO0JrV7b6FuOY5o3mUHCgmHxoQfECvPzcFlLeTmhfZ5IFJuwdBv/FlczsBQNwatl5tmP4B6b5yDlcxqeyNGA/oEDEfzj0FoJa3+FU8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d932f922-2df8-4d73-7f9f-08dde55e25f5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:37:48.6444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2siylcIpgCHL/+y31L7QdB5mIAzWFG+jMlJcz4HkwD/xplrfn7+UJEVLUTQdgQ2E8/RB9RZzCauiC0F9AFHEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508270098
X-Proofpoint-ORIG-GUID: aLu8DRPl5aTgFtPeV4NZhEeSLN42n1ke
X-Proofpoint-GUID: aLu8DRPl5aTgFtPeV4NZhEeSLN42n1ke
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68aeee11 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ZR5oq3Xs8z6_6OyQXH4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX8ZAcGEJnc54C
 GBwaIGcam4n/ZGf+IyLOZW0T7ESphRd+adPiqKq+t9lo9TF5pd3gsVxsmcNoChVFWIzHdwBPunk
 FRt43C7mJ7oUod3eJ3ZFKP8pCLIfKsisuEcxgBZKLqukcMZHjhblpusFCEv17yH7u2uwFJyI700
 eyxtC6E0KfxQjHVEU+LzhF+WGx+aXQpUhJ4M404MRNzdZSoH+0lvyhgAaEIylyj86mSVU2d86aF
 7S7psGvH7hmJ+Z4JGTcb4KLgzzY7PS9XhGlAt2kwFJqI6maGGwSGA7jfnNMi8XzoXY5wl2o7xFi
 /+Hn7nW50dJQgnw/CwwikQXV2xKAmVvzfmfRadJJ2GnYj6Qja9qswG3qTpEEjiYBYC1/1STp0s0
 LUjrLH7F
X-Stat-Signature: qq8fsxprq37hprmd6ftye4mdsxsj37na
X-Rspam-User: 
X-Rspamd-Queue-Id: B2AA914000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756294683-577326
X-HE-Meta: U2FsdGVkX1/42NP+4yqSORdONsJ+HTjcvduaGNMqpQBOt7HLGrWee6sw++Es5OTybJUL6IEZij+T950uiVNfLgt2/udiioy0zlELmTL8oitykF8sFWOimk8grm6Gja+54XRWtJen777vlkIIcIn6fJUcBWVOiasA5T7IOD2AG+ZyAoj5bvpi7+r92AQYswhVVoIE1tyomd5Z/2PJgdjdB7g2g2gTMeFhKwZHI4/BotPYzeU1orSijpKx34tTRJRENrm1cXB8np4QlG3vfZRxRSBK737FrKbHYqJtEHrPzgQcqfIzqscgc6rXk4bnXmgtHexzyGjEaF0UCCEWrrOPGwK1Cf0HtDedIQpOfExI0dmdQEUzbB25SPIq/eW+dotCP1aBDOYURftRwc65P4i998cgG3qDMJM88U0stOo/IW9CCYy/C4e2GgWjLEoTYb1mFCSnbXS+0uQ/N8uQkDH/V3X7Lw2mHpE/sDdrNVH0Lwb4PqKrIdMpJMarn2RPjet/Jf2+aDwO9x3Z0WOfn4WLNsExfje8NSkG+7skkzLam7NqNuv00oMqfN7pn/MSrAQd8h0WLrbPrMh9c1YHoN2Hv8yoIrCMtIteKI2SgHOpCPthJtOhIE8qAESeOt0NP1xmAQByaSO5Vhh1prRM+KDg0DAxvyCcmT+j5ps1faOZtG01Gy9l9sl1qnW4jQ2aTHj2CeQ7BjqXrd1mDLxz4F8wgZ4ZY3R6gX1lpRL4+lKsZCcDlmxaOo9KfW1y9hdLGGiNOf2yMfN2WXAH2elTpL3G1qAovb9sKs5bJOFiNSyrmpdLm5ermlKsPm0Mz0fSaCzv6UhPxyqbemMTutq21CI7jvgjtfAjqQY2I2m6JSQFGZoNwlgtJELipEZJ04U3VvBiIGCd5ShazB8lVFPAnkAq18WlppNEml6WoxwXCMzAKPnWEP3zn8fXAIh6R8MKW7aQB98pVitOOzNmqDqDThL
 Lv+X6h6M
 IuZwucvQcCKse4J3c7EjVRJAlQAU5Fstg5B+97uOl7Vu8PelCRdpGAdkvZxyX2vhdssDg9LYl95WoWQSycu5hDWC/izq8ufYGuoZXt476P5QWYAkKy3qRzVucyw7gHWkgu9o8wCwXr7dJkBdtX9u8IUhMzlejMdsWbRCka5kFPJJcpaNHVAk84FlAU2uoGRZYpCCzJNadqVHwhfkCQloaDYubessHRw1xw3/0OsZcPKlNrPWtTwsMlSwk5LWnnIbRz/fPJdN2vhtBcB1flaht6IvLsvpKGwjAiyFsRNdgQTDFGU4gC98sgp9vbn6BQBmidf7qq/wxHsXEo+4puDo/chnpWbfsDiBUJX1uRvi265m09CF/5+xoDCnR4uGYZ4hjg+HII9gHcqAqyWsMg+h0ejqEqm/WcZAizK5AvNoo7oRYOP1s31fAjFYqypHJCX3fe54x4gGZyaT5Iht3G42clL6VMAE1O2IRYn3jk2yn7avziib0i/BLXEQTYiFwAZc6oO3ne+Um9ZXdF3dly2e60dS4xAETSU4dElHNF381tc76roxgC0v87LSPKGl9m2YU09v8VDcRlrmnlG+RPEkjxu+JRl5hJSVyKEO3yO01+r9WmVQcwYR1TZ/UzUmcou1yzY6wuC69+ZbluYhOYAb/LiJ3yPVRtZ009OHqxHc1WdXmxzsQsUhgKau9ulxP38ZI3CiaHXBH1SjrKk1/4wYHgj2lzRJUVrrYLo71GIz9sjmqKWkfSG49fekbTOArUZ8gAvJKMbjHjpDGiM6V0RqGXcb2pncLEKUy4qsOQSgEbbF6YbD6tJ9OVLTejkeZzakbDNU/BWqeUYY5NvHmpNKUMzTBeaSk2TTZVaZY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the slab allocator assumes that slab->obj_exts is a pointer
to an array of struct slabobj_ext objects. However, to support storage
methods where struct slabobj_ext is embedded within objects, the slab
allocator should not make this assumption. Instead of directly
dereferencing the slabobj_exts array, abstract access to
struct slabobj_ext via helper functions.

Introduce a new API slabobj_ext metadata access:

  slab_obj_ext(slab, obj_exts, index) - returns the pointer to
  struct slabobj_ext element at the given index.

Directly dereferencing the return value of slab_obj_exts() is no longer
allowed. Instead, slab_obj_ext() must always be used to access
individual struct slabobj_ext objects.

Convert all users to use these APIs.
No functional changes intended.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/memcontrol.c | 23 ++++++++++++++++-------
 mm/slab.h       | 43 +++++++++++++++++++++++++++++++++++++------
 mm/slub.c       | 46 +++++++++++++++++++++++++++-------------------
 3 files changed, 80 insertions(+), 32 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..2a9dc246e802 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2566,7 +2566,8 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
 	 * slab->obj_exts.
 	 */
 	if (folio_test_slab(folio)) {
-		struct slabobj_ext *obj_exts;
+		unsigned long obj_exts;
+		struct slabobj_ext *obj_ext;
 		struct slab *slab;
 		unsigned int off;
 
@@ -2576,8 +2577,9 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
 			return NULL;
 
 		off = obj_to_index(slab->slab_cache, slab, p);
-		if (obj_exts[off].objcg)
-			return obj_cgroup_memcg(obj_exts[off].objcg);
+		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		if (obj_ext->objcg)
+			return obj_cgroup_memcg(obj_ext->objcg);
 
 		return NULL;
 	}
@@ -3168,6 +3170,9 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	}
 
 	for (i = 0; i < size; i++) {
+		unsigned long obj_exts;
+		struct slabobj_ext *obj_ext;
+
 		slab = virt_to_slab(p[i]);
 
 		if (!slab_obj_exts(slab) &&
@@ -3190,29 +3195,33 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 					slab_pgdat(slab), cache_vmstat_idx(s)))
 			return false;
 
+		obj_exts = slab_obj_exts(slab);
 		off = obj_to_index(s, slab, p[i]);
+		obj_ext = slab_obj_ext(slab, obj_exts, off);
 		obj_cgroup_get(objcg);
-		slab_obj_exts(slab)[off].objcg = objcg;
+		obj_ext->objcg = objcg;
 	}
 
 	return true;
 }
 
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
-			    void **p, int objects, struct slabobj_ext *obj_exts)
+			    void **p, int objects, unsigned long obj_exts)
 {
 	size_t obj_size = obj_full_size(s);
 
 	for (int i = 0; i < objects; i++) {
 		struct obj_cgroup *objcg;
+		struct slabobj_ext *obj_ext;
 		unsigned int off;
 
 		off = obj_to_index(s, slab, p[i]);
-		objcg = obj_exts[off].objcg;
+		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		objcg = obj_ext->objcg;
 		if (!objcg)
 			continue;
 
-		obj_exts[off].objcg = NULL;
+		obj_ext->objcg = NULL;
 		refill_obj_stock(objcg, obj_size, true, -obj_size,
 				 slab_pgdat(slab), cache_vmstat_idx(s));
 		obj_cgroup_put(objcg);
diff --git a/mm/slab.h b/mm/slab.h
index f1866f2d9b21..4eb63360fdb5 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -522,10 +522,12 @@ static inline bool slab_in_kunit_test(void) { return false; }
  * associated with a slab.
  * @slab: a pointer to the slab struct
  *
- * Returns a pointer to the object extension vector associated with the slab,
- * or NULL if no such vector has been associated yet.
+ * Returns the address of the object extension vector associated with the slab,
+ * or zero if no such vector has been associated yet.
+ * Do not dereference the return value directly; use slab_obj_ext() to access
+ * its elements.
  */
-static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
+static inline unsigned long slab_obj_exts(struct slab *slab)
 {
 	unsigned long obj_exts = READ_ONCE(slab->obj_exts);
 
@@ -534,7 +536,30 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
 							slab_page(slab));
 	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
 #endif
-	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
+
+	return obj_exts & ~OBJEXTS_FLAGS_MASK;
+}
+
+/*
+ * slab_obj_ext - get the pointer to the slab object extension metadata
+ * associated with an object in a slab.
+ * @slab: a pointer to the slab struct
+ * @obj_exts: a pointer to the object extension vector
+ * @index: an index of the object
+ *
+ * Returns a pointer to the object extension associated with the object.
+ */
+static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
+					       unsigned long obj_exts,
+					       unsigned int index)
+{
+	struct slabobj_ext *obj_ext;
+
+	VM_WARN_ON_ONCE(!slab_obj_exts(slab));
+	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
+
+	obj_ext = (struct slabobj_ext *)obj_exts;
+	return &obj_ext[index];
 }
 
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
@@ -542,7 +567,13 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 #else /* CONFIG_SLAB_OBJ_EXT */
 
-static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
+static inline unsigned long slab_obj_exts(struct slab *slab)
+{
+	return false;
+}
+
+static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
+					       unsigned int index)
 {
 	return NULL;
 }
@@ -559,7 +590,7 @@ static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
 bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				  gfp_t flags, size_t size, void **p);
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
-			    void **p, int objects, struct slabobj_ext *obj_exts);
+			    void **p, int objects, unsigned long obj_exts);
 #endif
 
 void kvfree_rcu_cb(struct rcu_head *head);
diff --git a/mm/slub.c b/mm/slub.c
index 9e91f2016697..33e2692ca618 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2028,9 +2028,12 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 	if (slab_exts) {
 		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
 						 obj_exts_slab, obj_exts);
+		struct slab slabobj_ext *ext = slab_obj_ext(obj_exts_slab,
+							    slab_exts, offs);
+
 		/* codetag should be NULL */
-		WARN_ON(slab_exts[offs].ref.ct);
-		set_codetag_empty(&slab_exts[offs].ref);
+		WARN_ON(ext->ref.ct);
+		set_codetag_empty(&ext->ref);
 	}
 }
 
@@ -2129,7 +2132,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 static inline void free_slab_obj_exts(struct slab *slab)
 {
-	struct slabobj_ext *obj_exts;
+	unsigned long obj_exts;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
@@ -2142,8 +2145,8 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
 	 * the extension for obj_exts is expected to be NULL.
 	 */
-	mark_objexts_empty(obj_exts);
-	kfree(obj_exts);
+	mark_objexts_empty((struct slabobj_ext *)obj_exts);
+	kfree((void *)obj_exts);
 	slab->obj_exts = 0;
 }
 
@@ -2168,9 +2171,10 @@ static inline void free_slab_obj_exts(struct slab *slab)
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
 static inline struct slabobj_ext *
-prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
+prepare_slab_obj_ext_hook(struct kmem_cache *s, gfp_t flags, void *p)
 {
 	struct slab *slab;
+	unsigned long obj_exts;
 
 	if (!p)
 		return NULL;
@@ -2182,30 +2186,32 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
 		return NULL;
 
 	slab = virt_to_slab(p);
-	if (!slab_obj_exts(slab) &&
+	obj_exts = slab_obj_exts(slab);
+	if (!obj_exts &&
 	    alloc_slab_obj_exts(slab, s, flags, false)) {
 		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
 			     __func__, s->name);
 		return NULL;
 	}
 
-	return slab_obj_exts(slab) + obj_to_index(s, slab, p);
+	obj_exts = slab_obj_exts(slab);
+	return slab_obj_ext(slab, obj_exts, obj_to_index(s, slab, p));
 }
 
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline void
 __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 {
-	struct slabobj_ext *obj_exts;
+	struct slabobj_ext *obj_ext;
 
-	obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
+	obj_ext = prepare_slab_obj_ext_hook(s, flags, object);
 	/*
 	 * Currently obj_exts is used only for allocation profiling.
 	 * If other users appear then mem_alloc_profiling_enabled()
 	 * check should be added before alloc_tag_add().
 	 */
-	if (likely(obj_exts))
-		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
+	if (likely(obj_ext))
+		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
 }
 
 static inline void
@@ -2220,8 +2226,8 @@ static noinline void
 __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			       int objects)
 {
-	struct slabobj_ext *obj_exts;
 	int i;
+	unsigned long obj_exts;
 
 	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
@@ -2234,7 +2240,7 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 	for (i = 0; i < objects; i++) {
 		unsigned int off = obj_to_index(s, slab, p[i]);
 
-		alloc_tag_sub(&obj_exts[off].ref, s->size);
+		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
 	}
 }
 
@@ -2293,7 +2299,7 @@ static __fastpath_inline
 void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			  int objects)
 {
-	struct slabobj_ext *obj_exts;
+	unsigned long obj_exts;
 
 	if (!memcg_kmem_online())
 		return;
@@ -2308,7 +2314,8 @@ void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 static __fastpath_inline
 bool memcg_slab_post_charge(void *p, gfp_t flags)
 {
-	struct slabobj_ext *slab_exts;
+	unsigned long obj_exts;
+	struct slabobj_ext *obj_ext;
 	struct kmem_cache *s;
 	struct folio *folio;
 	struct slab *slab;
@@ -2348,10 +2355,11 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 		return true;
 
 	/* Ignore already charged objects. */
-	slab_exts = slab_obj_exts(slab);
-	if (slab_exts) {
+	obj_exts = slab_obj_exts(slab);
+	if (obj_exts) {
 		off = obj_to_index(s, slab, p);
-		if (unlikely(slab_exts[off].objcg))
+		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		if (unlikely(obj_ext->objcg))
 			return true;
 	}
 
-- 
2.43.0


