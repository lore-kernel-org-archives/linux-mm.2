Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC95E83F05
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E61A6B0092; Thu,  5 Feb 2026 00:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693116B0099; Thu,  5 Feb 2026 00:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A366B009B; Thu,  5 Feb 2026 00:49:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3856B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:49:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07BDC8B847
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:49:58 +0000 (UTC)
X-FDA: 84409326876.09.95F00A6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8104C140004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:49:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oPZ9nVHk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wtlUDqPB;
	spf=pass (imf09.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770270594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2b6Rzau2KdM7TQLgAk1gINrgxIEuwtDrqgTqO0QObgg=;
	b=wBaXlAyumR2QGgDnZwqffrQZcK/ALn4mZStI/5W2CO5sVs0Eqjnl47q+oGcD/mildSJf7I
	HnFVtcc7mXKRg27jb8MK+n3nvrsqZ1jsYfiNOOpQZcWMkZMaxMUiXbG6wLvAy8IFSZZSaH
	XdaD3EE5db2xtZDVxAMfeAuxb+L9dc8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oPZ9nVHk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wtlUDqPB;
	spf=pass (imf09.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770270594; a=rsa-sha256;
	cv=pass;
	b=Z2d8lrRvJZpkd9AA+/UUrQd8oFRv1RL0le/tvxFEMLAc3s+AjTYG1dvLk2tIbNYY12DIS0
	QCei5lcn3W4LVVFfwHsDw9yk6A1eXTRTAGcFGa9nrGh6D2D1OaO/TyYA6tILoexh5QoUVO
	q783hBCYQen/ouyoJ7Q0QOkGUMSUXVI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614Ka1pN2730499;
	Thu, 5 Feb 2026 05:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2b6Rzau2KdM7TQLgAk
	1gINrgxIEuwtDrqgTqO0QObgg=; b=oPZ9nVHkPHym2X4a6FZzEUWVXOEGuqIrJm
	FL1RXkvcg4rU57hupL+6z7xjLuIgM1e6geRyHgSDOWaiXAIUuO1YUCgiSUmrFuUA
	Ud2zuC++NlSV0RB0XAzA7gD6e3Ri8gxGhPX2QZE7bLO0/IZ7yKmzsn/ZMazQiafo
	mVQ1z/0m4ouDINpFbm8dlntvdTiw3H67y45irQE5Ucy9jnC1ikRChdxoi3HcNHec
	bfsRJwRPQm7A2I/OjyggwjjsgWDA7US6rHQ1oAJRFwMKvIQMkdl+P6Eu4zzeTuVD
	XHS/HeOrRaFzxaayACHxdIzM7abN6XGnIeEMpy9nPahEj3JsoqNg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c4d9v0g3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 05:48:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6153oGdO034785;
	Thu, 5 Feb 2026 05:48:35 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186cjd2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 05:48:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8afIvIB87UI/UakjEvtKctyjb+aq+SDwvWx6gzew/eynyQ6cPGfBWlynQTQj9VQkbu3XFZwarD0/OvJPICgw+Phqq4N67tbXEmFF5X+n3bpJVPYxKSk9Skl6kNoN9yFCk7m9OoCjGI4JWh5SuwALgLH+KQuDhB2aF3iBYiGrydK5c3RXSl9H92dHyxHV4oAQbwn/mgUXnWukB768LtoLMhU9ZNa+8NMugNltzjI/wwnd9Gmvi2RRpVITKkgQSU+yE0aB2470YucJv8Cor4hYn2v4d+nwIJ11KcdvsSs6XQujAdHKsoFgSjZUt/NXygOp1Z25l5rODWzlvNMG/9s4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2b6Rzau2KdM7TQLgAk1gINrgxIEuwtDrqgTqO0QObgg=;
 b=EfCVv/WL531wwV4eOwTDouVpu1JZ6LquJRRB1PrPYwBkjKdjj5JNOKa3Y4U6mWNl/069tONq+0BKmVxyjBxwMZSWd9niLRzHx7/VSMkOTMIDSs7cECrukz99uOKUAle1Z8XU5xx/dMREjoNc//XJQna//pALV8JIBTZiQiSMf3qItVHV9apawuL+vPkoIdYDdwZsjGue6w+jgQ6Lx27UMSvuhE9b+MLH7AWTVfvi23sf3kd4hXfSLoqg5hjMbh9pYrOwpL6iH25bGxweOrDrUlfaUgnL4yGmmbK2cPua57sEwB80gJURc+mJL8Bx+UxjcuDbYyVE1BVZxCiYgHRn5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2b6Rzau2KdM7TQLgAk1gINrgxIEuwtDrqgTqO0QObgg=;
 b=wtlUDqPBFr1KN6E6WT3ihMV364/l2sso7xLtu3871VBYpacmodcg9aMhxFxKESUvIhdx5Uq6mO+dKwc8Bavlmt/E2vfDZNnP1+7cYkh48TUdy1G6RdcfPpKYCkj/uLrX6t+olENosxBTVp2vBZaWJTrBzCvmp6xIKX4bcljHEZ8=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB4931.namprd10.prod.outlook.com (2603:10b6:208:331::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 05:48:31 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 05:48:31 +0000
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260128185943.2397128-1-ankur.a.arora@oracle.com>
 <9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
 <20260204143116.968730e769500aea281809bb@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>,
        Ankur Arora
 <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        kernel test robot
 <lkp@intel.com>
Subject: Re: [PATCH v2] mm: folio_zero_user: open code range computation in
 folio_zero_user()
In-reply-to: <20260204143116.968730e769500aea281809bb@linux-foundation.org>
Date: Wed, 04 Feb 2026 21:48:29 -0800
Message-ID: <87a4xneo5u.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB4931:EE_
X-MS-Office365-Filtering-Correlation-Id: c72d7154-0406-4e76-e38a-08de647a3133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xRB2A5bXs7OvkSRPp0aiCt3UCubdfJsoS/3L/guOvkr0gjPp7Fekj0ftiGNB?=
 =?us-ascii?Q?HS/51cH4oatKkgCGnJEYlDaLpXgNepRVTo0wKAz/9+UYxYW7nuydOVqpCEFk?=
 =?us-ascii?Q?Bx0WKNaWfwmkOw/knO0zgILW0ocY0tVIVSfrKhBI4lQZ6bVtJCzSKTChrpee?=
 =?us-ascii?Q?4Esx362EUh8rIUfjQ6nZTSlY0A38S/JLkRZxYrzjt0nyCGOVB4NNuQurLUeb?=
 =?us-ascii?Q?w41flsVHKu4Z8+D1tNc4/zK9rAd1QUja7BbroIMr60WxvNrbcg5Z0GG5WCzN?=
 =?us-ascii?Q?TYSWH6AJkAIZ9S5Wd+fDGy7MPKLyIS+mWeb151934Z+neidc4dkdN8YfvGXd?=
 =?us-ascii?Q?y7uZ8zInfu9YJYQ0261vfNpz+dz1i9+k+ZWT0yst680wsG5gReqcoZDV+hJG?=
 =?us-ascii?Q?HNdBr4PEHbF8BZttf4qWGX4G1uYWTkqEkTa8Xeb7Wp9UdErqFxOk5Npr6x6h?=
 =?us-ascii?Q?6bvQkf9YKolvaZNF9e+OX7Z3o6VfxL3otUyPdgdQsT91ve2swuBQj3XrdqDg?=
 =?us-ascii?Q?ywmypfpI3oFYoutlHfydOrocDhMpyePUuTAgbm7TmizKykrmlY+2q41DC469?=
 =?us-ascii?Q?47Ws5pvy51DXT21SwSD5gsH0sgwTPOmt/Sg73S6Ad0eCyS00+EgQ4K8IGx5w?=
 =?us-ascii?Q?l/TnOvWJD/vPQQpeJN4PhulvjyH/zAna9FQM2sj5jnnBN0CKIy6nO/Mw0rh8?=
 =?us-ascii?Q?Rr0BaxkqeiGceAf5tcqIH/JWNUJ1KqJfIQfi5YvGmqjPNrh02CcMg79cpSVY?=
 =?us-ascii?Q?Z/jPUUTJ9z8AdlI7yMBte7SImL7UC46CW8K/vODxmXtjle4/YDmz6iCnl+pO?=
 =?us-ascii?Q?BbQmo1wchDX3QCyIhqa562BQVtxYIBKzpeXbXPh6jL7f5v/0UtNW2Hva0sw1?=
 =?us-ascii?Q?Fy4s24K2IFr5mgAgRu5sVm54mhkn4J8U6mD2ZpzqzuEtG2jaXAXpuxOF6YOU?=
 =?us-ascii?Q?OK6boq8xROp+DX9dqHKGKr1gLCfZY3tdmMvPT8k9UIHkh5uMqFh2ts3GLIkp?=
 =?us-ascii?Q?LBWEelwE4CEKcTtx9m18iEv4dy4jQbclg1iwTiDNn2UE03pONsMB6K2YpFUP?=
 =?us-ascii?Q?wdbCWCYmfNOWgY/G2SdmhhfONvebDzeEyemIrVeXOE91pOi5JzmzNaKJ61hI?=
 =?us-ascii?Q?MrwHL5UgQaE6oPU66f7QsYiGjNYfXT5B5aLdJo3B2AIbUVTn59MKW8kvS+zJ?=
 =?us-ascii?Q?UU8RVCT/x42HVSJG7goc+Wmdo0GypXQHLbHNhgDpHO42k22Oaxk5o291KmlV?=
 =?us-ascii?Q?m7IIfq6aOzKCMKO5Ni4JU/AaEdGkP5OayLnc3rnUctMY3U1nvSFTXAAnJQiD?=
 =?us-ascii?Q?Lwu+vtTBF/AwUxxgfaGoCP0/iLbi5R3uzzyYNv10BWerqiRo47Ar4SFm1jBB?=
 =?us-ascii?Q?7CEX78A3GguHdj+R4xRwI9PoGeWDqKK2tSoTztG77ELZH9kib4oPBTPh48YR?=
 =?us-ascii?Q?3wAxdjbtj4gNfq0uZ+Ad+GPNTuHvsn2JALefwDizUz0Yzuu8b5JobbrgYQ0r?=
 =?us-ascii?Q?qOO4n6Wrrw9DsSdxanUhHYCfo5dlzG7vyxQes+TA6YNQmU1kESSVSgXfODio?=
 =?us-ascii?Q?rqK9R4dVOkhfezgw2Yg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4DQX7M0BcDWRvE9XANjnkWGnaUvDeG/50uH+fcH5YR5Iqw7dqoLJB+jxAubz?=
 =?us-ascii?Q?RxVgnyUuf5QZr89C4a4i93WJ+QtsIdlr5YCcUxEYip8osDr30//s/KroVESH?=
 =?us-ascii?Q?lrq+fPGAnjS32Dw+rf24TG1dLtDOG0oZ4UYchfHcRXiTgW+2ME7ZT0k5Ukb+?=
 =?us-ascii?Q?/uUQXPi4P9qrxFavzwBqx0kRlaTGC/SifysK4N+sNFEtARiMKCPIfrw8xruA?=
 =?us-ascii?Q?P1VayG0kw6wncscao6tjwn/NfZ+Lqlx7SMtk1+4WYxCAoxCQGbUEu6pvVqyq?=
 =?us-ascii?Q?vc9QDev0MnTZN4kug76zf8W8wjKL+kj8JC4UEBFnyyNmFPOPpJA7Zy168+PF?=
 =?us-ascii?Q?KuhAriqm2dYUH/epIQbpe/mhpPAmPG0Z0JBHz/b6kC6ozpNzApI4VSJK9wQq?=
 =?us-ascii?Q?RdILu2APthx6coBlVndRJU7j3rezi+V1AhvBDZn5lYQEIXDt+vu4ZvKYVnlP?=
 =?us-ascii?Q?OGljsimzDxD36T37E2T3QcoiCNcozgHz6rVwzdH0BrsjFD9AMIs4Qlkp+p2e?=
 =?us-ascii?Q?aUnD7efKY7HIeKd3mpf/zz2yeKBG1U0hY6qHe7nwvh7Ysnuh32MdeUlTbSMo?=
 =?us-ascii?Q?kI7mqI79SPmHw+aGCUOnJtPW30VufBXfy1OLahCgIrsfZzTzRqjjlar6KE+r?=
 =?us-ascii?Q?i/GKRO7pSi/O+qCE0e7xWm0M9ezPO0LkYQDXeyAw2sXjjIOPlFNBZY6cSZc5?=
 =?us-ascii?Q?Gxm2mPiT3hTPUIXZ3h5ABh24pbB+qDYn9lPMY7ATOOhmh++SVhUccCpTnvBr?=
 =?us-ascii?Q?xcJ70yqmkQoVFcd05oVGK2T6zRKwvBoY/Dzdrvo6jCncgYvkIvDJhLFpsWSM?=
 =?us-ascii?Q?UZNCt8u0nnRAs7tasmaophzNVCJbwlm/tvDwNcLkIVTPk6kb4sQAF5Flo2u8?=
 =?us-ascii?Q?nrP/k4ErmSORqFOf1FeOGcRLeT+b8Pd7gcfgpgAF5botWNwhVvOIJUEu4gZK?=
 =?us-ascii?Q?eR/sSh2/k6E9i+ARIyoiJvEO822HcP+QLppjf+Uim/HNZcUs2tqmleqiQFty?=
 =?us-ascii?Q?KhmlLK2Ydt1T0rMTRffB5UTeXurdcHEN6xbCWwur4vvAaotpsFUaAwuXwSkD?=
 =?us-ascii?Q?W8fLiXIpa2Lm5F+IAdm227yOy0tVioQl8uv8co2i981dKDF8LttPfpfwhQRf?=
 =?us-ascii?Q?3s7Kzvtd0PuJNwneRPBzqx7J6wfUjV8AT0MxKTY68ATdnvut64w/wOARt2jU?=
 =?us-ascii?Q?UJvSDiTnVqL7oJ1USX/Xa1I6ualbtTx2u75pCP9zijp9Fmw9zjOBpCZ9lQtZ?=
 =?us-ascii?Q?b3gbfSfw4shJpAX9gFnm/aofp7bBv7glXbnBtCqLfX5UBszxtDUC5uRjV70X?=
 =?us-ascii?Q?U0NqnafRHeJCUsCDT0uu0cIMLP6bYsQH/sHBCc1TNlSiMPORwUbgW4LmdO5O?=
 =?us-ascii?Q?Ud78gGifsti494X5uLCUhQNc+lYzTwua13TSwNq4eKpDTYjVDLbmyEdsnI0f?=
 =?us-ascii?Q?GSITnN/2GpDpZYwqwv7m5ftuhRVDCcQX9Kb/7kuHMTm+2Vz42ccwI1rPU6jb?=
 =?us-ascii?Q?T/dqX5TBBdmiozZNL/cB9tPWqQEaSMdAmBVNFsi/J9aJoTS1vVIRzycZQYi9?=
 =?us-ascii?Q?DEucBJW+nF4xf36WQJrJ5ML7AkIEFRr2G8iVIZhuQJBv9dERltx4WMNlECMH?=
 =?us-ascii?Q?X4u4QT5oBcpd99WC3+bsSulISm4JX+r+p+VH9qaNumjoOTT3Q7M4W5+HmcqZ?=
 =?us-ascii?Q?moCLJL+CO3Lag1sqGUqcP6wCMslROJeon29oo3m7pHaCGKet93trTYvqddpJ?=
 =?us-ascii?Q?PA82Gl/He31dKP/mReAHklmPeX5j/ws=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3yoczgUp25LNpy8vQxDB1jD6tcvm7zQm8x7ojqv6NJKL5VE+0BXYsXJFkHJUJ1+8FFYRz1BrMowhH5yqDQ+0ZwpotL/VJg/GeNQBq4j/E1RQ+PPqiuU5FDgCmhnVgSMgKfc5VOCcbjJ9+O9A5+kIHRfDBDUW38se7UpS1jZ/Y0Ou8uAoxeL22UenGnugoNv8uX5uSllZY51FBnBQTzJXrDwUA09mxrOKkH4E/ERNGE8hME/9PAtynGtW8aRqb+okKtdX+idPK/JWfn+ixlG0dv3PiKln7HZEH/uh4m+VOpu3mmyuMKtSOHX76MvUrKkjHtVG/S8NZH8Ok+asaqEagwA78buq09dRf16t5s07W5QJMHVIJcWmz9YA0/4/HVAfFb8Qa7tAKg+jQ2Z1hSYmHLTYA7ZD8ZexRdPKlcnUavqogZN8+BdKvnIfAvAvpnnSKXC8Rkwj9BkreRnzBHVAyxmqrYJTN1AG7SBzTxM3yOfURY/Jy/WBWHHgehlWE77Z8fB2N+s63QWeiQN8WiriX+Vx3GpDH8+Jm8nM2ifqA+rAzyhZ8RnVa80VvBcdRepigz15YyINlfMCbp7eKyDqDBgCn9YqlX0IsNiHJiTaV4k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72d7154-0406-4e76-e38a-08de647a3133
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 05:48:31.0166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbaciP/5PuugMPDjY2J4QD2wmttBsUqWREnJAOS7AMR10QO5GTo1R42S3cTdawLHbpFA9hk1F91YJ4QtlYn09wXbawM3fXQIY80xCr1auyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4931
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_08,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050039
X-Proofpoint-ORIG-GUID: yH0eOIpabzTBex6ol5HIgwqOnLjIP_fO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDAzOCBTYWx0ZWRfX+ty0smBxwJyT
 LSCvfvpB9/wKA9RbkQaSLEg93Xnhw9pdGWz5jt6qdHYFTwv+uTbua49fMZZEQkcYGzsVgaaxkgW
 U6WIU/OhSSZ7FiGBOpPSEXm4MN8f0UbCgthIPAd5sUmGoQKCw/aQpr60nSk+IUcEw5/Hl4fN4SZ
 ZLQMDEe3LcR5g/h9eZR7sJdCSS2LCT1AaiLRwHDZHcAWGbKMSGfktFs7Hc4UYfoo57kD/CTNnMs
 Yec0YrYQk1YKR802aBnVzBeqXM7N3NMad7+J5MAFv/8Ybt7PLnuu8/gW2IDMNX4a5W6Cql+rYqh
 ySSKnR1R66URcK3mAqoSqkJL1ond4wiRE5I23nlysVtjLAIRKH9Ga5YeAQSswwaaiopyBLlX5ma
 PydESmhdheEWNdBp0M8GgOeuzc/bugbR95KLzI5zXj54fJ5Wx5NwAInrkqZlm2cRIRUCgYFqfIU
 EA5CzoHunyP1NR8Nw8w==
X-Proofpoint-GUID: yH0eOIpabzTBex6ol5HIgwqOnLjIP_fO
X-Authority-Analysis: v=2.4 cv=NprcssdJ c=1 sm=1 tr=0 ts=69842f33 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8
 a=noY2G2RG90r3zzNXGGIA:9 a=HkZW87K1Qel5hWWM3VKY:22
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8104C140004
X-Stat-Signature: sw5m75x8kg6hm4f3nk3yofzkr851mzib
X-Rspam-User: 
X-HE-Tag: 1770270594-618839
X-HE-Meta: U2FsdGVkX1+/uD8LdJJEgx0h7wvWz0wOkcfgL9ExT/sjM1lnvx91dBdkz6yGHYAzHoEYcIEyeAkGWkl/ZmX71ZG/5FuSFTlbA2Y1B1r/ZYUuXU5RIWSHP9T/COBB+9y8GQ4FRfisI/6vlcWxlm9imkoZPWKNiG+1iU6pvGMQ9afCZkBMqB3FoXvM9RrnHtz47GcVcShrbepg8EKRxnXhlUcoL/gTfHiU1CDC5CLNs45ddeI2AbsS50JmJY1byi/A/3jJXGAN7PrePZOHgfIuwNPRjONBp+d8jPqr3id5wmBD4TAitVGxdrYCbX01R9rql7VbD/Ppy1as4v27EuZe1mnXyGtj4KJhV65O0M7aNV1U0Uq+3yHCmVzqt5lOn9gWP4SOJSh1Y8oLhFde06DkYO1eOcs2c8Jtv8M8y9+IXzxniwdWXa2q3OTBbpLmRa4CTBaFhVdO+TWcZDgYG7DAgG1PAcl11eQ6hIlGc2bBFAQOuTLI626FfQRHTekeh1i3jF+HQ+loESJXfGLukCRCDSf2mwrsuakwUMsSEUVd8NmP7N9LsEAUZBDxshrkJDGIg5hD1PKB9wczl6PcxsTfbOVXkgPTgQTp8JXMbu0eDiu86oF3wg8Gms4rCiI65fokcL0VGd0pTezmyAB4ZwRBFTm3QGsAQkzIGxMNxzaWnQPYO16A5Mr4Ea3tRV87UE5lssnmK0tdRLToGUXwqYzlnCmfkyilEu1bXsULgGYCelhnM69yplTsB7yrstf87Aoh9oQaVuX/l+wuUn4Ha7VMkA6mK2GvX9gjULefw8GIiuTvWuZ973lKar0JUjKAauPdj1alWPhqc2mH3XgWJzJvhHkzta2CqMqKEf9xSZvfBG00m2Ur+jxaR5yrbMZgj85E0y66NRzZh6m7c7cUC5J1yJ4nIo2ZcldbWq8cOAKkJ1OxHPql0xWiQAjV/2697BcVrOXv4oJhVYrWztN66NF
 EFg1Flf9
 7H8D46gcvWwUhHrkMEN2/9ImCBpFJCnVNtPeBsL+EZT3awH5wvB40Plxq07D23DtC78QsQrKhBmOQuUas1NhkiYBMQm5LupscFsoFk6Fo6Y80UrZ0NQSkwyQ7FdHgYNbhBQMsBznhsvutDlPqy6ARQvsB7W5or/TAV7r33RnH4vLAiUXeIUxHPJZQqdWD2IIfwuP34UyEqFKBctR6861NLuzFhy+IusFUU5EV7v/ZR+k/xstyf2UlMpmxb558lPIL7yhlkVSIlnb1ALrg9UQfLIikrzEsZ+ch5ntn4ahdPUBVJ8ta2eLWZ7ZghsFfUdSGb2L3ofOZiA+CI0RUC63rlWBHMW7sOW4j8pFeaCJkfIj1CbzBXiCujLvzLqbW+Jxb6LYfIf7K8lSxLXMFZxHsfdJAAjQawTyQK9EqzqV8cOZvZNGuKgv0pRWf3baX6Po6DOZ/Or3z5wjyuqFXqfd4k2GzrNAzZxhxoc6sD2CHUr8MohnjGK5cshCg+o77FFeyuxU5ZP++GvRRK75GsCmZpda13W5vF9F/KDGTCLKbA/tPGdOaP7inqI7Xb5NE4jl2eQnFYN9hfzCJqkXjlvBTej7QcIPYVeFQJc+vqtmXjVhjYkxe0pAOYExTmiIwzXdImAOw5V7DYK8TTIcVRvGy8x8ZUMKrh1m1+bZ/JqWrd0QQq8/l5XNL1dTPHYrHCFJOTJ1DomIKQ4aeVm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 4 Feb 2026 22:01:42 +0100 "David Hildenbrand (arm)" <david@kernel.org> wrote:
>
>> > As David pointed out, the previous open coded version makes a few
>> > unnecessary changes. Could you queue this one instead?
>> >
>>
>> I'm late, maybe this is already upstream.
>
> It's in mm-unstable.  The second round of MM upstreaming is two weeks hence.
>
>> >
>> >   	/* Region to the left of the fault */
>> > -	r[1] = DEFINE_RANGE(pg.start,
>> > -			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
>> > +	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
>> >
>> >   	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
>> > -	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
>> > -			    pg.end);
>> > +	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
>>
>> TBH, without the clamp that looks much more readable here.
>
> me too.
>
>> >
>> >   	for (i = 0; i < ARRAY_SIZE(r); i++) {
>> >   		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>> > -		const unsigned int nr_pages = range_len(&r[i]);
>> > +		const long nr_pages = (long)range_len(&r[i]);
>> >   		struct page *page = folio_page(folio, r[i].start);
>> >
>> >   		if (nr_pages > 0)
>> > -			clear_contig_highpages(page, addr, nr_pages);
>> > +			clear_contig_highpages(page, addr, (unsigned int)nr_pages);
>>
>> Is that cast really required?
>
> Seems not.  The types for nr_pages are a bit chaotic - u64->long->uint.

Yes agreed.

The first u64 is because currently struct range only supports that.
Then the cast to signed long is because the range can be negative
and the clear_contig_highpages() is only done if nr_pages > 0.

And, the third one is almost certainly unnecessary for any realistic
hugepage size but since nr_pages is being truncating, I wanted that
to be explicit.

--
ankur

