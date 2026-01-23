Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F16D74EC5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90016B04CA; Fri, 23 Jan 2026 08:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DD56B04CC; Fri, 23 Jan 2026 08:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BB36B04CD; Fri, 23 Jan 2026 08:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1AD6B04CA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:27:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DD481A0243
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:27:08 +0000 (UTC)
X-FDA: 84363304536.26.7BA6A48
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id DE90440006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:27:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iSHpk77V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Le9mA9nE;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769174825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5q9GwvKfP04mx7ZXHgJIT8LTHLag3vcsg8a4rGBjAME=;
	b=fEW/FlNQVx3ciY4J4rkbh5YCQIcYO0FYs1Tv46jLipVY87kGHs9sHzWKCJykTGzaXbKlqb
	jNzKxmEnpRFwz9vVgHF2ecea2U3OY26vRiQL1TbkdRyXS24twRcDRNdVnxgQopOPZEm59F
	arR3rO9cUjpAEIiIZy+6QcnfPRF1qxE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iSHpk77V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Le9mA9nE;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769174825; a=rsa-sha256;
	cv=pass;
	b=YJh1vG+sliMRAK9iF++y06eNIVtx7bsjavmHC9qWJvwBknim+UbzMNklRHRK7xSkIAl/wC
	ECzttz69dgNNjmxqWnwpeD3eQnDVAOIAYc1qzFoOra7kaabXr2nOt25uUOcVH/5EgDC/84
	g964+UIKDn9sNbhboo1PFqk98Cwjn88=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EH3Z2401474;
	Fri, 23 Jan 2026 13:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5q9GwvKfP04mx7ZXHgJIT8LTHLag3vcsg8a4rGBjAME=; b=
	iSHpk77VLhUT3EcnEtUTYpxdZKMTv5n6JjvxBZEsGglEXtVbe7FtQ1ECWB58Colc
	of9NaouvoOAYwTvvMH9c9/X8h1dJZ02j5t/nwCvzJMYA/VEvILbsM4wlnlM9po+C
	Zy4wlkVzrk7Xr79iowbVjz40WhgK7LtGYFPbivwuSaWU0pWaul35d6PprBhaZjv1
	j6ZAOuBwQgoOyWQbGd+/07egd0iAXuF+NOyaOkWJUCIuFiNBKBETr9CcKVj3kx56
	Obmicxuy3fIzR3xNcyjMxOfi39rupYdOTnLYIwk9q8irLUKekHfH7dCXlBSnc2po
	HjW4k3M7+PM2CRlxRQ65QA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qjgsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 13:26:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NBdVdQ022494;
	Fri, 23 Jan 2026 13:26:51 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011061.outbound.protection.outlook.com [40.107.208.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vj4avk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 13:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UdaHFQntzW51bpN2ll2FA5ivWOHvsF5wfYhzIf6fzxOWMHbpAv0huUMBxDIDW9reRcKzgWkFY9DOAVvlWxq2B+VWztx9vsbvNDvzj3oD/qppKM25W+aX0vQs5AMLUvS/7qqJXsa8JDYsGiaB+Ls7r6HtrWb9KTrKh/eFSAj9WZpUf+ClkIUGX/Z+HVZYzyH0Ux0lCmdsB4Mh/j/jBcCC+dqDJGqOcCFBE8ywiRCd77tm/oQ5adPQxDc5/5XzRQe6jRwe3DpxpUmgHAGvt/fU6VrU83V/zVNm4NFtJwAKh1wn0Fd6VDRV3tIiPNnn7XXhf21JLgjldA1o8NwyHjlGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5q9GwvKfP04mx7ZXHgJIT8LTHLag3vcsg8a4rGBjAME=;
 b=KY/1Z41YupGQ17rqSKsCUHXSoRhvJqOv3egrywzzAdoIx8wJ2PNrs5xn/L4aKUaR/wYr2IbtmvyonA45KNGKXvlKXsf3lXpbz/C6yRHCK656mAKmPRlle6Ylov+rJucoX8BceW7x0mUxSv5R4G4qGq5hk7V+y12aoRnIB1R/Usgk+ahJH0n4NrgYFEZRY1xfVT5QDknJvJEV8xDZeTIAYs6dj9C8rIeuE61qoGim1clgiJEwY7ySJwx7QKW0LY9uMGjLmpHaCv8YxtPgBExgRp0onYaYPRbwqL2sompIE/2XIf91QRFJ4gPgOyztFtElwt7kZvl446VaGylFmA0zSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5q9GwvKfP04mx7ZXHgJIT8LTHLag3vcsg8a4rGBjAME=;
 b=Le9mA9nEEPiOfQAJqaaVhy7SGes1sCLNOKDu58ev1a6HfkDk2v4Ek1ukiHW27soTwn/u5KBBT5NeAHD4oG0PhXUML+hj8cEiBtCmxQmj0WMRZg06sbc3O2GlkJvYl9w9s4KEdV/zYYbnWWqaLfeNNnWXDIvGBn+cD1/+OuY7q1Q=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by MW5PR10MB5851.namprd10.prod.outlook.com (2603:10b6:303:19b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 13:26:47 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 13:26:47 +0000
Date: Fri, 23 Jan 2026 13:26:50 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 01/10] mm/vma: rename VMA_LOCK_OFFSET to
 VM_REFCNT_EXCLUDE_READERS_FLAG
Message-ID: <81f537e9-7058-4f9d-b50b-b5458dbf4479@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpH-07KqsgLsFoBXjObMakVxb+w8w_UmZi9TTxCEzmaA0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpH-07KqsgLsFoBXjObMakVxb+w8w_UmZi9TTxCEzmaA0g@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0652.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::13) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|MW5PR10MB5851:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e1e5b2a-13de-4338-a099-08de5a830ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWdOMnQzRGRQdkxNc2VlWGxKaXhnb2s3SVNVdUVpOGcyVDRmdHh3MnJYVDVO?=
 =?utf-8?B?WUQzZnhiRzJaSFMvUGdJZEFwbzNEMXdINTR6bU5XeUZlVkY3eUR0c3hUMXh2?=
 =?utf-8?B?N3l0SmdoMWdNeFFlVG5QTHlwOEdIbXh0NGdUL2pTd3pjamlYdUlhSjFtSlBo?=
 =?utf-8?B?dzB3eWl2ejVHcUJmaHMrNHpNYmw5M3JmZEdyS25tbzJld2FrTUt1aFB5bVRG?=
 =?utf-8?B?YVRSakI0MGZLRVRXeWUza0I5UWhueGwwcjdwMHJVRG5wRGZCMXBiNUl4SFZ2?=
 =?utf-8?B?V1ZvMnhWTXJzMCt4bEFwMG55azMyN01FNVVhNmhKWUp5VDYyd2JoSUNMNC84?=
 =?utf-8?B?WG5aaXh2TndrRExkM09zU0lIU29qc2NMWWU2REZDVTgrWjJZbkRkMVdlYkpk?=
 =?utf-8?B?L0hrTUQwc3BEb3g5bmRRSzVXSEd3V2Z6MnRzdXFzY2o2dmVBNzlmYlJqZTVP?=
 =?utf-8?B?dG5xREM3WnFGM09nRDhQbmEzL3MxSVZ1V2RTOUxJZk1JY0hZWWZnYVpvdG5n?=
 =?utf-8?B?SmZra3NpNEdDa3FRWC9xOTZpUnd4SnJQQWUzZ2xJNXNvYTN2UGZ3WkpURW9O?=
 =?utf-8?B?VDNEbXZzeE1rTHVocDEzdDJhMWR4N3VFYkZIbFpMazA1ekZkWWd3T00vdmhr?=
 =?utf-8?B?QysyYUF4ZWZrRGh5NEVBOVZ6VVg3czZWcVY0Tnh0VkJzOVpZTFNubVlEdlFF?=
 =?utf-8?B?R3JOWW5UMGY0OXFnaERnM1JqVzNvd01oQTlRckdNQi9ldmhiYlpaWFk4QXFW?=
 =?utf-8?B?L2FlUDVrYmZ0MjA0SmR6ZmFDTGVzUFVzMnE1TkNvS0JnaXdxd1l3cmlYMnEx?=
 =?utf-8?B?dEdMeFF0WERVRnIyNTRmS3h5TVpyWXYza2FvZHhzU1N0SEhBWXN6WDNEMTMv?=
 =?utf-8?B?elJDV2dKWlFLZDN4QnBSd1ZlRnd5OGxxQUoyUlpYckZmcS9KTTk5UE9SSnhJ?=
 =?utf-8?B?MGZGdnZrTXdNT3N2c3VBdVlEenUvck9TQmxnTkd1UHEwT1BVS0tCWlRiVlNC?=
 =?utf-8?B?UnA5Ymh1dks0cWNKc1hOeFVDakV5MlNjR0NzRGFpUHV2Ykd0aEJsclJzWEps?=
 =?utf-8?B?U0RnMkNwcnR2TTRjT2xjdHFOVzBZZHRWR2pIbkxReUxTRTJpT01TTHF3Ny94?=
 =?utf-8?B?ZzJuTUNRek83eWs0eTdlWGcwZUZnMWhHeS9yNDl6ZjJNT3NDcUxaa1BDaE13?=
 =?utf-8?B?QzROeW9XQzBiM1MrZHJ2Q3FTV2srRnQwbUVpZWJ6c2d6aWo3VkJLRk9lZDZq?=
 =?utf-8?B?YmZaT3RtT0w1cU5tcDYxYmREdzZTMGFuRjl2S0lVMnZmWURERnNJUnNIOU9m?=
 =?utf-8?B?UU80M0pPd0l0VyswVE9RWmdZUTU2YkpCaEgrT1NDNFdtNkJrclV5SnUvc3Bh?=
 =?utf-8?B?T3V0Q29VeDhpZWhnNzdPbEQ0Y2dTOHczOFg1WWlxQW0vd3dWY0cxMWwxdEFY?=
 =?utf-8?B?VzRHeklJK2pJREFUUGgrWXIvanNpQlhCZktlN1ptMytTQnp6SkFUaDZ4YmtT?=
 =?utf-8?B?K0daWlFXWTZlYXdHNW9HYTZ4WjZ6YlBxUE5UT0xFclVKQzdSbXA0T09ReWo5?=
 =?utf-8?B?UXNSYUhQa1R2elpwdUNuNHBXOXc5WUtkbGwyS1YzbDFNNGVFNHoyUitEUkFh?=
 =?utf-8?B?YXo3T01yYWFSTnpBRk1SbG1Td0JrcFJWTGtwZGVWRmRwazhUQWVEVlYxK0VX?=
 =?utf-8?B?ZG8rbXdGQ01CaG5BdmY4WStYT3NpQXJVY2wrcG5xb2VlZFRIQ2JPOWtTYk1J?=
 =?utf-8?B?dTU5d3JabHZIdkY1MWtJQktUZlBMY0g0TzhMcHRQRW9uRlZrWDlaTzNua1JV?=
 =?utf-8?B?NXVROTdsWlhHVUdqMWtwZno2QWZqejkyZ3hHUDJCcC9xVXN6aFBnQ0F4cGJZ?=
 =?utf-8?B?V0x2bHBFanlaeWxBM3BDMlVpb25UOXBjV3B2czF4dmQyc3E2YmJBRmduU2tx?=
 =?utf-8?B?NFgySHJvWnJNR0lWYVpWTHJzbGh4WlJhWDVLS2NVRGl0NjE2d09XK0k1dm5o?=
 =?utf-8?B?REtPcGg2Z2hsNmJGVWdTTjFOMVJqVTY3dW91VzZjMytWeU5pUnY1aGV4cVk3?=
 =?utf-8?B?d043bVpTK25PcFFSN3VZdlBkem91T0xjSVU4ZW9PTm44QUdhZmd2c1pwK2t3?=
 =?utf-8?Q?q+8c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzF0KzB3LzN0VGJGN0F2S1pobWtraUxqUklXeWx6UEJZVDVIZXZoZWlyWmZN?=
 =?utf-8?B?UEFDZ3p6LzMva3NNQXJXbHIxcDNuc2VISlV6TU5mOUtTNDhKU0RJNDlKQlQr?=
 =?utf-8?B?MDVnWk9US3VISkxJWDBIVVZzN05Rc1RaM0w3L3Rod0k3UTdOSklGdVA0ejdi?=
 =?utf-8?B?Y1ZyWnpDQ3cwVEo3SEQ0SnRHZ1hkN3ZRWVYwc0xYQWVDMWpickxpRWR1KzFB?=
 =?utf-8?B?VWlGcGxDUVMrdVlTMWVHR0MwRTMzZVQyUzcvcUJURlEwckhST0l6UmM2aFRq?=
 =?utf-8?B?dFhtcUtyNVVQOFZuRDVGK1dYYVhjbUlLZXVtRzN5V0JvMnl2Q0xoQ3hiN3Uz?=
 =?utf-8?B?U29EaFp6SE5OVVRJbzNINmp1Mi9kYXdjYkxJOXl2Zm1pbHQxVEUwb3pzMHp6?=
 =?utf-8?B?VDFZZ1RJR1Rkd2dJWUFXcFkvem1JWWgxKy9EaEZ5cStOWFRRNzZZWXB0UnI4?=
 =?utf-8?B?UjRTQlc2NURyZFpUeFpvQ1U2L0dURkdqSFNndjdSbzlyVlpZcndvMkpDNjI2?=
 =?utf-8?B?ckhwdmNERlhROExRRlF2RjFxZnB2RUE4dVlVVjEvc001SWdEcGN5VEk0aWJu?=
 =?utf-8?B?K0ZNSWxVQkljNTFTL1dxTWxLa1p5L2dwcVJpU3k3RFlqc2VLeDF5ODVNQVFZ?=
 =?utf-8?B?dkRtVUhTMklpMmsyTlBQOGRWT1pBSVFnSFNlSmtUSjdnR2YzTDQ2bnYwWnd0?=
 =?utf-8?B?bmhOS3Qxc2xSRWZsQXcvSjN2bnB2QlJDRkFjSHBRV1ZKV1U0c3lzVjVyMkNR?=
 =?utf-8?B?S3IwSjVEeVVpU0t2UUhNVUlvZGtyaTg4RS81NUI0cjNDbzRYMThaeXJiVjJ1?=
 =?utf-8?B?djNwYTNkRHg2Nm5NQ3JwVW9aSktubEQ5VHdBUzQxYy9hR1VmY2owclpoekdM?=
 =?utf-8?B?T0xVWEl2eW41bU5tVTByV2IzWTBXN3h1d1ZEODUzM2d2VnpLczNqUFAvQ0hQ?=
 =?utf-8?B?ck5xZnoyOHAyQVhmMUJCc0pyVEJLY1JSalQ2MzZJNnBBSHNuOCszNFVtVHZs?=
 =?utf-8?B?MmlMYlMzRGEwWUlTK2tEYnFRb0ZjY0I0dUJBMUp6bUt3eDVLckdJeVlvU3NZ?=
 =?utf-8?B?NXdITGowYWIxNFdacUtySTJIT1FMTHE4Yk1nbDYyZmxpby9PWTRONVJkUE10?=
 =?utf-8?B?TkpRUkxOdzBVcW15VW1Qc3RwOW5ZbFdBM2F1aWZ4WXQ5Y1VnZGhnbmM1Z3dE?=
 =?utf-8?B?bGZON3RvQVB4REFjRkRJSS85cDE5eUEvVHR1Z2dnS0c5V1JFVEZ6WTlSU21v?=
 =?utf-8?B?YVYzbmJlTzlJUXlybGcyZ3R0cGY3T2p3d3V3ZDNzR3V1MUZQRHNwbzRpcmVl?=
 =?utf-8?B?akVhTEhWMzhFNHdsbS9hQTZiRDJiRTkrZW41amNGNlYzNUZTelllcnZkSGdh?=
 =?utf-8?B?M3NieXR0SkNhdHFneWF6bFJuN3hCRjVQc0ZRYzZMSXdUVzRka2VJZEh4TzN6?=
 =?utf-8?B?bnp4QmxuVlE5aTJ6Ymg3Vm56WGJCc09tcUNYdzQxWmUva1RHcUYvWFh3czFB?=
 =?utf-8?B?Sm9qakd3eGt5K2lES2RhNVo3ZjdqaGJ2dlRXQVlpb2ttdGlHZFhSb08rUThV?=
 =?utf-8?B?T25lYmdRRDhNTEZ2azUrSkw3YWN4WERIQm1KTThoYXhYNm1EbHNUZHptSWcy?=
 =?utf-8?B?aUs1VnBaN1FiUm9NUS83U1Y0SVpXeXNYMEd5VUlHTzI5ZHlFcVh2NFhEZEgy?=
 =?utf-8?B?MnEweENydUo5cUFNd3RzMk15dWN1SlNaVGhzdmFyVlFvT1ZsTmpNN0xpd1h5?=
 =?utf-8?B?ZHlyRVdVSC95Vkg0NTVuZ055K3ZXZlV4K1dnc3pwaTJEZWUzK29mVDVwUFlm?=
 =?utf-8?B?bndlcnFxeDltaTRLSWsrUmhRbmNWeUtXOUdRWEd5dytQRTFkVHN1Lzh4dFEz?=
 =?utf-8?B?eFdlVjVPRXVkc1BhYmJaN0pBcEcvNEZkNGhSbEFhL3c5NU8rVnFGVkRORkRq?=
 =?utf-8?B?SVRBUDNkNkJBNWltd2NHTm12b1hLQVV2SWZYcURZSDkrN01JOVJyWm1kKzRY?=
 =?utf-8?B?b1JGK0lGM0J5SEJMdmhBNHdLWUlQYlc5QmxEYmdYUjFRbC8zdFBiUHVtT3NS?=
 =?utf-8?B?Q2ZzS21WRUYySnhHUktTTmxZVnd1cTN0K3JzRFhrcHNiU3RNSkRXQXN3MEJn?=
 =?utf-8?B?MnVJSUtJSlFCU2lGaytLeXMxZ2ZmWDNYWi9qUjVlSHltanc4dzg1eUIzRGVH?=
 =?utf-8?B?eGFObzlSZ01yRWszSnZ3K3JLYU5FR0YrN3lNVm1PZGtleHpPSHFjQ2NldGZ5?=
 =?utf-8?B?NGZtTVJiV2krbXh0VDBURHZvUkdJMWZFZ09JS1pzcFlubzFPWVpZdlluNEFG?=
 =?utf-8?B?TkFudzJ3ZDdtUERaZ3VFNjNnOEhxb1N2N1hEUlo2YXpmLzFpR2NMNy84TUZa?=
 =?utf-8?Q?2P939Ar28QI/N9Ts=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S6CRuePiYXWHltvN0/3O5tRZL2TaiIPf53wbiPz72VnHKch9bm9Kx2sfDxemY35wg/5YaTFTVFPmzRm7UPdyxW8CZsr/8068N40zuFuZwxyHn3RQPYipdefqhg682A8lBHs70UK6zww0x1ZpRAI4RyZkGJwKbNiqX5byM//pVTOQn5C2Gdm9dX45LMzaHD05tEpfKwivr1x3sb4DeV+NLxkRSm0Kuag38M18jZNRofnEueCckhKscDrOhTyLT1/MNPFp3Oyuw4oBnGNhZXqJmUMLcanpg9CMz304dcEUDUxl+O89SwJk4trPlhTrj6/E0saG7rgD+2CnI20YaRarcN+DeEEUdzzz0vzW/iCpJj2n0s2YC4xFHzohC8UxEvp7RJI+2UyVsHiFRhRPi3hiti4Wd6eaeGQQtAnrkpfTWGAVJe5Snypnz0R3svQ+jQjWCGA04PEzpnyMOhvAm4vW+EbVN7zHo3p0rGZ2vRYsksHNVVcxpyeYCvECHzmtgzpBVWM+UuZKVg4j/MJXSrUTwQUV3NeOqDUMilAZuCMTdNI8Xxg2qBIBrzbvecHRmtfz3EgG0YqL9W1I3bPB+n+T7xe3YEBk3f4wFFBFUCHedeE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1e5b2a-13de-4338-a099-08de5a830ee2
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 13:26:47.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G44+1krNnmQVs1dwWf4OlODxKmkol1rjR/b3+iGLBxoxVYIE1jRtIFUKA53zG9Q6GJ0CjI8UeXyj2PMvGlrrurSyDGyHuSQo/UP7mFszsg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230110
X-Proofpoint-GUID: uP-cHRu7Y9gIcifN0hX8jHrGxU5fn4nY
X-Proofpoint-ORIG-GUID: uP-cHRu7Y9gIcifN0hX8jHrGxU5fn4nY
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=6973771c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=xsTsCLxMLOmhrjQPJjkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExMCBTYWx0ZWRfX8oJwez/fGpy8
 V6a4i1zIQ+iyq6UPKzdxjUXq/17+LHhB1/zeOl7gpLGMK2dAd17v3AIH1jPYn01/TOB69d8nBoy
 GxDVZQtGdS3m9gRQQnhumy8KREcnyigQov6qJDo4WZFCcPHr0H5CVK0UX4nLufvSV5oRU0uiztU
 JBgUWUPo6cshD7rqoIqsrlxLAk9h2gmQWRUrZeZpavOamsOO75g6bYmDZvJJJYSJFgCqTLjAAlj
 6CmbXJBEnw1qp7+hfTtw3ZJiXWhcViakQmkpQaXd53xWL2pg8wQldE4VOwEpLoW/wHUTW0lbwZi
 qryEu0KSc2/WcBKn0XJFkkLbNz0Iiy58PdsAZ3H8ZDSI4W3zP4mtmUfbOubv4X6uHM0+vNCSmEN
 wK9o2uHT8thsa2uTwQHof1hY03HmgmplIY2YOhGLDVIUIKOmyZGprTD+98VYYRWS9p2XNBqXPKh
 wcYwUNOOGG1jZCdHI8mazqfSJbujmQy87LPyYGe8=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE90440006
X-Stat-Signature: 8he7gzaky6sng8wz1jxp3g638u8xdszn
X-Rspam-User: 
X-HE-Tag: 1769174824-427651
X-HE-Meta: U2FsdGVkX1+R+9t6saKor+Ln9No/WrYsia0GzH45xLz9cFQINs28rcjaj/ulJ8fk6OuOfz2DDVbVcQDaPiJMWxqabDrs0mKkDCGZbH53BT85TIm+WXOK5XrlvW46901aGXJzjhTYK/bfFTU9sIorSXK1jqD/yZXU0qgGrJNxeC8zujvUuZpmjlm5Ugx5JrOi4biySchdQl906yj25Vr9tSHCVbYYXDZHn1axcZqMurvRhlKpgox+u10jgAGSuCTJ5FOVeIlowmiDYan/Z5wFTqw4l6dW/+lWzTBq7TnHIL7cpEUb0+auhvwE4YfbBL8jIf6hxcLY+anyC/QG/sq0PiK9GYyNKy3DgWrq2j8rJE//DIxuS3ygtX1MswSr73FdFBDQ0+Z8kBtQ5PqwDp23BTj61qhTGqDd5J/vBnwahEEscDW5hs9p7xS7KooTZB18b2oPWXBS2HkCtVjRaRlOMzPcqIMSlV71OCqoN9PlnmkKbv/HK0/OcHpJdAc54JwPmC3XLcLcSO7GzqTYZ7vzYcTxAxBZXAXXCXD1V+yKfugGAtuAnO9DsdakVUKkqh0gEVyrWlpmX2BKcsCbDJ+wfV0rxqSdiZH09puMCQjmb5yT1G3v/ZMYCA6tts08FivYLQck74RfEoJx+5EkcKwO9OgnpXtFXcHXLDRXhU+gSJFoI0Jtc5/1PTkR6yFBvA5o4H8XQxi9veUzVbb4qa9hYIE/CnU/zr0iCGZegnifQD5B3nTqepVg1PWwN39g753bJ8/jpYd7tufiT1joLJRoGJaEYPwMhEVBjJBaeqLzdVP5/mS1/NdFxJGGD6N8rUM1RhKex3Bu9cEHn62fbs/mU6nYaxKAnGcrRE3Po5y2+FLT69CWS5LTR/r+C1zGX8b5aSTjUmczXv9SIrqbIQVqwu9QtaAOTBi2k5zHZvHZhUlkfMmKaKfvVpUHArGu5QdFE3nx7LRSPoHTi0UzB3Y
 DOKPo9Ir
 3OLPrapjAti8f1vW1muUEUO8jykb0bToclmQzo/8VDuopABgdkUoboJVQtT0tyPdvU2ix05tclQVTLnkvH2Lpz42TNDP1Qwijfv0m9h2DbOLFrJw1t9CPBgMZKmpieWrSie8Ia7nwcG4lEL/uKrs9aOP9d6eBLZ+Xp3WVkB0lg835zcf84TaJD5z99ICm1evmJ63Ey45ARIbnUSQSySxYh/AuNi+qGCOq6XvnciHYpqZfA/9vcAwKZiPtiXvfgDYFx0Bz/Dsp6JtfAP0RkydGId60z3Zy0dewRKrpRSHTuGdDCpKnSAzRM6ejE1E2n+KPYJL1jC1xt8U0ljUnn9x4yYs92QJUiZVUiXh2qfAWc1DqBkYTbE9Mj1vrixY7ubedkAHrzuzKLrurhoeZQkQ+ACcg50efy+XslfmqRBl7sFH88S12qM71mFSMkPUFLjyyESL1F1ZwQMNfsjYXvUPjwaG89nhy0rbSQD5r5ZjEDyCY7McFbkDhZlDKMi8V55pGQC96vrodLb2dxTe+uwtRVBDycf8G0bpgYSMfweAeSqMjl3gBG91qAqoczs7YkkivTwU1cVtIVfSZsKOrpy0FgoBh7fma8j0AAwUuSsxInGvyU+L9IqdnFph7IBR0xQdMnyY9r1yRMV9hBOZV2ycg4wk7e3kNXpyIAxr0yy6A5OealAaVbzjfnOYFHd4qAdTKpO97fpvoXWdZYFPf/cKOLq9wdjHVdX54+UnKISBrO2wSvF86SssBF1EcFNip1nCjl4Gar9nVI4QIscM1Hzjuvi8Hmqt6ihNcjH0wdsCewJhaJqSL95hwun6zDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 08:37:51AM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 5:02 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
> > order to indicate that a VMA is in the process of having VMA read-locks
> > excluded in __vma_enter_locked() (that is, first checking if there are any
> > VMA read locks held, and if there are, waiting on them to be released).
> >
> > This happens when a VMA write lock is being established, or a VMA is being
> > marked detached and discovers that the VMA reference count is elevated due
> > to read-locks temporarily elevating the reference count only to discover a
> > VMA write lock is in place.
> >
> > The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
> > VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentiate
> > from the newly introduced VMA_*_BIT flags).
> >
> > Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.
> >
> > Update comments to reflect this.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Thanks for the cleanup Lorenzo, and sorry for the delay in reviewing
> your patches. I finally have some time and will try to finish my
> review today.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks.

>
> > ---
> >  include/linux/mm_types.h  | 17 +++++++++++++----
> >  include/linux/mmap_lock.h | 14 ++++++++------
> >  mm/mmap_lock.c            | 17 ++++++++++-------
> >  3 files changed, 31 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 78950eb8926d..94de392ed3c5 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -752,8 +752,17 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
> >  }
> >  #endif
> >
> > -#define VMA_LOCK_OFFSET        0x40000000
> > -#define VMA_REF_LIMIT  (VMA_LOCK_OFFSET - 1)
> > +/*
> > + * WHile __vma_enter_locked() is working to ensure are no read-locks held on a
>
> s/WHile/While

Oops thanks. Will fix on respin.

