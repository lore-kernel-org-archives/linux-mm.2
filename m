Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B63CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DE36B0198; Tue, 26 Aug 2025 05:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225DF6B0199; Tue, 26 Aug 2025 05:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EDC96B019A; Tue, 26 Aug 2025 05:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F08006B0198
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:59:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A602C1606C6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:59:15 +0000 (UTC)
X-FDA: 83818460670.30.7588110
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34A88140008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:59:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kLibp+4k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KlQmGc6c;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756202352; a=rsa-sha256;
	cv=pass;
	b=3aQ+iPGS6W7ra4psDenfgApuJMBtzrmX5HWPnPzJZDX6X/m22XrABKGaCF3IVfS1aYu0ua
	yW4eXfG12VPINeXXG40Ocu9f1MBtEW5NsBqgcLDvExvwtp1XmIsSsD3b41yEs1Y15H1+42
	Olas7ai7zdABcVSUk5ebbAHClxCJDi4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kLibp+4k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KlQmGc6c;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756202352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gj9k0Pf1pL1z5GJZa59Tib9NedcSBwgVLtj7beyxx2I=;
	b=NZIfNJWmYfPCvVL0jy2T03ipno5SJ7wOHU8xyEqTCqWYJ5VfX87hEDn7/ymyYOvgCbLEUa
	sv/vB3xKLDAvRRrMMPSdGLsQ9Bgb02xk6XmBUOhRNaOBXPrxxWdMMlmBYc4+QXS5kgHNRm
	WB8Kta9hTx3yTjEeoZ07SyClPPZ9iNo=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8mCFv009733;
	Tue, 26 Aug 2025 09:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gj9k0Pf1pL1z5GJZa5
	9Tib9NedcSBwgVLtj7beyxx2I=; b=kLibp+4kxO/TTx/gLpvryYBZAlmys8ZEaT
	Ow+qQjC4on95CYiy9XEVLYs/vtqYLhtpMxuMTaaatqewldTf9Rqazq8dJXxJpvxx
	1xAlcS62YyeBdh9C0fyVqgJRxxKnP5PQObScq/q+9UFKXnXK/v27BUjeQAqvPYcK
	NGPU44pvazX9L2GWb90yORB6Ypho2GpQcKwlaboaI5vf6BREA7KFaqgsukiZcgEv
	3AgB9NOZI+nL2WfsKW+bnKoMVqaVlhm8N8QO55hDks8dcm6zH35tUUGjgQ4K+63h
	64BxU/+dfM146saZOKVcx5vQhqE+SU+IcBMV4pY88LUKJYIUYywg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48em4ns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:59:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q9s6Yr026710;
	Tue, 26 Aug 2025 09:59:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439956b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:59:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cJWvXEqMo/gbrdfF1LED32JF7LtpDH1T9Qlosi+zbaiUofskwgwzsyZ7nclJw6yGnrWJbYh+m44ieZs4ZtkOjNhFYdcMYgZvQAUpRyVyzn32hzr5MKn+Qx/2ZR9jpvpaBeUD48+WAATVRXgndGOv3Lp5pD9U8IcBIkzfAdOrOoe1Gp8+dBT8Uhk5Gerijou2KT42x0c2jLGJC9DGJGcD1zAJf3iEH9wPcJCEo50pxI7Dh/XILPiUi+RokfIoA+JE+NgCCMlfOg4rGlgiNfodhZjOFPXMt1E3vlTzieYVvTn7AItfNYCOaKXN+0gQQJARN5y/Vb9yAc8Zknv0rHGJnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gj9k0Pf1pL1z5GJZa59Tib9NedcSBwgVLtj7beyxx2I=;
 b=XOjTaVavSkiU+Ls6QjZmBOE/u3E/QmVApon9ZttP9nTQoyaP2N6/Y1s+XXRPzVN7VoHlkZnbhFQLrrtw+tjKTfob091kfajF+YXITOqc6k/8tfAXCsuuELGm/ogwos2vmz8dxFMyigLfM6poT1IOHfHH+So+fdCkbvLgHu7Z378WlS4is5+A/+uZcFAoWzRMaaPyOumQMsuup733/CiejLr/2YIK8qIJg9JiNQCON+o7UpZBv9g1OL1XTaxcFIfGUTrt1KUnPp9GAtAiHWdeUnPctJxMFeI5YszSTDKvxR7RS1lh6E5FK4bzrzrL/ix3g6PvkFZlRGvAk2ruK/MReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj9k0Pf1pL1z5GJZa59Tib9NedcSBwgVLtj7beyxx2I=;
 b=KlQmGc6cZZR47Hu00lmD8xVZlWfOfz8zpjOAXJAKfJzRav9EGYLiURaKGlDtecw39CfwCzyKanaTGzbvKRP9FWPeBvPNKZPIplGzoDkNKkufVnEQUF7Cahw3xfA8SHAziuy+ZAenhAKCBQSLdg0OopZjuMlHCVG+7qqR+SJIaYg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF44A241B91.namprd10.prod.outlook.com (2603:10b6:518:1::798) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Tue, 26 Aug
 2025 09:59:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 09:59:01 +0000
Date: Tue, 26 Aug 2025 10:58:58 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to
 be taken during mremap()
Message-ID: <88b41934-2c3c-46a5-a86c-0c798fb7d2d4@lucifer.local>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
 <87v7mabl9g.fsf@trenco.lwn.net>
 <f64483ac-31d1-4f80-8fb0-fcf15867c6c5@lucifer.local>
 <aK2C-Wuv7c_yIOJ0@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK2C-Wuv7c_yIOJ0@hyeyoo>
X-ClientProxiedBy: MM0P280CA0080.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF44A241B91:EE_
X-MS-Office365-Filtering-Correlation-Id: b890c08f-c47d-42b2-78d7-08dde4872ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HBD9Qc9T9wLnBSn8ceRAYpdYZG3j4zjq6hjMVRUX0AuvAqnw+wAH8Y4OiiBQ?=
 =?us-ascii?Q?HJjn4afChbMLHhP/LwcoITFooXPgVI2QSbw8us6ol+JGYX5TufBAVmEaoMt0?=
 =?us-ascii?Q?tQCX0fNP9Sh0/AWil26fDhEsEbDwQJzkCuKr5XN34kRKQ3LbnmkE2MHAUiU+?=
 =?us-ascii?Q?69l+bmOS5WCP3wA1WmLZMaJ/ergZPNt082lLr7ht2b9Smw2T0UkuX2JPFCxZ?=
 =?us-ascii?Q?x3pK2m/80G87DnmylxIyS1vJ9RkR7WKkn/3BH+eCtatCDZMU284h+jF3A2QV?=
 =?us-ascii?Q?3R3+XJsL7fAiWzy8W1EWFIjN62SUcWKArXAqtjdWCK04gmGx9ELeEqZB/3Hz?=
 =?us-ascii?Q?Rd4cXxENmHNBRO66gHH/PNgUbHH0KO6l1LH2fn0Y56PF7zkuAHmycyic2Fp6?=
 =?us-ascii?Q?IwM4nmS6sjiEp774sZ5qvmv3mbYSLLtHUl1dC74oeDYObw0Ppqbrkq1PjaMb?=
 =?us-ascii?Q?4KpWSnsdaWEN10XDEqaYNyFKuWUTwDzuYXyynSXixNEM240k9RGSdRXXlBgZ?=
 =?us-ascii?Q?rHew+JroKQqJ2RTASOrLtIukRky2y59JLSt/iIV4QgLbkbvEnwfwSLdvPsW4?=
 =?us-ascii?Q?6wvuGjRLu8BerNSwjq043mAUksNuvy5ssxxSUeN+wyBpnPQZBC3kOwjlBC/7?=
 =?us-ascii?Q?kjRIvLG0HgD55RRp6AcFM6yBRaqRInxM/esnZ+Z0T5hP4GQSIQieLdwdJyKg?=
 =?us-ascii?Q?fnYaTmpk0tooxnRIEuFis2XGLjmlh6gpddL7Wp6KUammuDWOkYGKTGOgJ+Xy?=
 =?us-ascii?Q?tO/tZBxwaAfkuBFXlpP9eF5rpUfwbzj9WhwK2rTBB2BQVgyuijuaNNHN/0hF?=
 =?us-ascii?Q?1xk4k6oS9AWulfrFglOFi/oMEcVTvOZBTqHTGw3c+H2Vy0jhxLuUj6HBLjfM?=
 =?us-ascii?Q?9VJVNuH0AiIASWHqiq5sLB/1tjINU+uMN7bMs22MCnh9OdYaAROzbyf7h3Le?=
 =?us-ascii?Q?3s5CLJohViPk/oyA2kfz59LWHA/PxWHat1BPC6heTTThgf3D613V1Fghmjv+?=
 =?us-ascii?Q?pELMOpb/O+RePel4SaUHvJLdjShg2InxM2jgbbN0i8JddQ1uR+fBxuiyIsVW?=
 =?us-ascii?Q?TZ5UJrmBXvWhSKF6Oxj8AtE6A86p3Uc7lewZfv7PsvkZqGR1ibF73BjTcPzJ?=
 =?us-ascii?Q?e8K9aqUwo0K6UBhJXHSNgJW2Dr+obO8KTfa9wQQok+HIepmhYmcVH+MwS6nv?=
 =?us-ascii?Q?O3uthH09g7STqBeZAw0Ogl/sHKO9CXELKRKhta7bZawqbfEdt2jb2a8/JAkJ?=
 =?us-ascii?Q?Eyqr/YgDyou2tLPrDOqrr6lWsqYvAAVKuF/AdhCrEMyTQ3S5g41yYKqqp0Z2?=
 =?us-ascii?Q?OS1Fq84cHtzEz8S/H/IkioQ6IT1pcjJokVqATi9sukzv667Yg8TXQsr2xS0w?=
 =?us-ascii?Q?Aj7q30RPhPKev7NnrUK9+F9HGifz4IrpMbShcAgH/YlQVCHU1sh19vJASZj/?=
 =?us-ascii?Q?QoHBuHxzi5c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eP4J+IpbRVve348rhxHHJ+e/4EaDtbT72iV9qAEVcWkf7EMqBxKNBnk631h3?=
 =?us-ascii?Q?tz/GAn6FjDtxXUMxhcMYDnEP4m49A87qmpGB6/thFFfrQK/8WkoyzOs6uL1Q?=
 =?us-ascii?Q?HjOB1+VAWomk4/QB+3bDJ0jm5CkWTc621S4ZwxljVM026MxpdxnrzE0ydTvO?=
 =?us-ascii?Q?65IQ2C72GB7R48t53jNXeAmevyFs/7HMRAQFSckgaBkAGGvWC5u7V7OxABlq?=
 =?us-ascii?Q?dMnP8kRADvmyYPawCmvPDJh927x0izFqrwhSl94rk7AARkn1VHAhjsfz4501?=
 =?us-ascii?Q?//bRzXoSjrtf8Yxl6/1YJyxd+LNtb1ajHepN2DTkUJkA9KC4iS4/fM0ynDmH?=
 =?us-ascii?Q?dUA6DLRb+/rGTH+fLC3SkZFhEc62NNd2CeJhWWLH1giunWlV5OcNX0zni+dm?=
 =?us-ascii?Q?HN5w1kYDhFC/lnSAtaSg8h9H2dq0HwgHdiKSQlHdBSz1cKf9LrXo0fmOUOT2?=
 =?us-ascii?Q?en3CWG/DFOwSRjmHhTs68nCIoQ1gR7BgilRS0LBBrH8lEeIQ4ZxZgKIE9FVh?=
 =?us-ascii?Q?4M0jKFW+nS3UZLlzzDl3KFG23pf5BRap0jKYswvGL8swpMu51Jp0HIqtyzIP?=
 =?us-ascii?Q?sleKbnZmoG5LLhi1mTcuoXpmISEwgsrJsU4/x6BfwH4bKdCrx1s3umfXrgzn?=
 =?us-ascii?Q?SMreRtMlJMTpxA7LPNSsCc0uNsNzN+3eRwv3Wq9FlSSVcK/+IrMBYglWbTP7?=
 =?us-ascii?Q?h8CnfmvDq94T9TjsxrotBcyI4wBvZ6CG1icUNf3ffXdmHirux918bRD4ytDt?=
 =?us-ascii?Q?9QZRf+EclBeYThda9GG40DgGow3F7NspsUSa+9Z7Zx98YNpQv0Ge7Soa03E8?=
 =?us-ascii?Q?sbzOUIuyFFcMWbadVbzUtDc85ww09iDpnABCCiVQdIOuW9UhI7C6fON6NgxO?=
 =?us-ascii?Q?2uDt98yHkf9owmrw6lNF7sUAP+u7Aft81yUY4kyeegunrAThAwTxcWm60Hlj?=
 =?us-ascii?Q?OFDya4ml/U3P2maisM9Fi/ndsNyD7nZbpN8JzHdiDtnaUzRcEHBpx9AaWpgc?=
 =?us-ascii?Q?mOvbeBJL3nCEN4qF/nopcyUH7pmGo5ICoICxSAVKLP6k3EpkuisLrAdRixLo?=
 =?us-ascii?Q?4RZb15KFCiMcAqnW/TXfrpUhnYdlRpl+lUiX1gSDm3tzvSJ/68Ug96ELL8Q/?=
 =?us-ascii?Q?UXyp2MQWJF00u0s0H1hShOuTydK1WhLG8cz2z0hUxPaPW7t4bmLudhRiha2+?=
 =?us-ascii?Q?bxSbrGFMsMYTT1UTDPkF8a9cGgdZcP20nQocz+UJwpjXVCngXJRTlcaQadT7?=
 =?us-ascii?Q?Ze805sWc5flsSqQJCKRmYe8Hh+iqNg2R2kSLJ1cTcLymMIskLeFfZoaYdq30?=
 =?us-ascii?Q?mdtoIqekMWdmkaK7zbobH2oPoYSaishxPQhcyqsgwLvrTKvVYMbvKaAtxt1u?=
 =?us-ascii?Q?ljSLqtln0kbPOL4U3SrKknLyqY8LCiTcXG8zXAd5vA97PuL/PLsrTDZVYiUc?=
 =?us-ascii?Q?7A3NTDE6KnWSw2DcG7QktQSBl3yp01xypOZCIOn9nxX41itk06dfb1QiIS9G?=
 =?us-ascii?Q?+dkMvjrfpZ6D+VSnF3mD1QRV2Y4NX6uGPIhFZmzQwzapNaKDhnqW5pXKUBDd?=
 =?us-ascii?Q?ADUFWF9hOlXWDE/O5mZqM4I6l0188d4a2XA0JCVtUtbKrDEAcs2cBfWjIPmL?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6oavsFjQ3JThduW925pcttt7s8sYR4e8KlTEA1CAysSVW1S1LDhX1af0NKvd58vcIcT/p2ZYesgevzet8Npb2CUPNfH4SgpUclvQyCCCr5DkDvc1YMDglz9g5FOkO4wn3r/pftHzHAXgZjmV0XLTkiUOjdWDDwBAONaBPyHk3yxqv7ZFohlVfAKYmjsM3x+wjz9lIqfqd73UgiEi2HxYme33HZF4nB6JKos/SSXcqr/mL7iz5ycjWZfO51EMEKtEFK5RqWoPd7JccQR9D7Yr7qpKAoCbZQh2yYY31Rn/qhpz/8zlVGHHf7T61Hp1YTlDWXFCUa0yya5UA+km1nvQ1qL3ZxByJdsITX93Ldrhxvx6zE4iwqRuleFayPjuuHiTiCLnMBiWOUrTPuYCnY8R3wU41X2WZ3Of1g9rrmDMJdtg52dt79YilPhyM54EMcx33nrVaQwtybccFR/eUmyEm0gIQZCJvfpJuHObZgtvjsx/Hk4l5iX8YlU0XUvP/dYoJIevQ5SkemdhQTfp3SnfUNAzRcpwedJffw0Gsc2wZS41R79XQWXPnwkB1AESvDPYwts8Kz5L6WbEskOcUN/P/VihXVdMMOaVuE5/4t/L8+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b890c08f-c47d-42b2-78d7-08dde4872ef0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 09:59:01.6386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rch8+obEEHicG6GEUPaHUmfEO4co0E054IGF1FZcLckmaDo/RFslB8PX++EIDTP+K/M5hAlNonA9OoSelu9ghCzz5BHL8MTQyTqIfjbiLJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF44A241B91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260087
X-Proofpoint-GUID: VWUdiaBG9JDHyTTxQGfeBxZS66fCNByA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfXz8ujVm7rUQ+b
 7590VWnb1INklEYdtvn6Jh3M196o1M6Nd1LtuWejzoeb63QYnYZrr7hA7cQ27GxEXcxlw3lC8O3
 YvUgdMiQul6zvcF1FrFzlAridW5eq4CCyD9Cof6l9yC+BzSjneSG/FQD+gPxKelOtw3XJ0JQtwe
 aNsUmXYbwdqXzz06bXVnceCFgfncMdfYH4bUzJwbQXCSQK1mi5gICgONHN7cEho/AGeP0YRxBwL
 voh2ug1vw0HRtGdja9UwObEGpQfxuHrjwDSv60gHPIp/dFLmWcvBdvrXlhhFGf3Yv+SxzelV0vX
 9DZyN1d/Dmvj88nTey41aSZTzvobpOnpT9YtkrYPOOZo7Ck1n7XUWYkW/WZKtEIwZzTOuDvwtvJ
 E2QgWVEf
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68ad856b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=L4LWFoIeUsQ24wZfG8sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: VWUdiaBG9JDHyTTxQGfeBxZS66fCNByA
X-Rspamd-Queue-Id: 34A88140008
X-Stat-Signature: zojfs8j4aqhp5nuwkut3bxmm79skcfdw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756202351-281900
X-HE-Meta: U2FsdGVkX1+v5mbr7FWbcuDdNQAKU6JogBFzZktxu5IQGasqWjX8V0fi5ymql1yAYl3oz99iUHrjXFXe+0t9ZxspSphi3pcDKgQhnr4IJmNadIqComshjw87XP406kb+SzpAyeoLGqvNEqzJs1IicyobznOf37yD+527jFFh+9WiHPzyp2PA1SPBtqctsyyNFi3kKCOeBNtNsPd79yChpM84I4P2/TjFdMf1WypmKqi0kkMInE4F1shkBLdjWywZbz74WYHtzG0Mm9oEo3pPG46oPa8rUUaeC5NEawcEAOafNkFxyUwct7Mi1qj6vW6Hx0wwej4JwJDiA0CDVdzqkD93Cj63iv5BGL0HOvpZL6oMVMAWopLVcvo8fJS5+tBh7kuGV4ELlL/l35ZVkW/raSyIsbE4AQFZNBAKMOFXBC3GllUesxv8aae2ajMJsiyz31miF0VaeNQNBU/xMzbbGfW8/lAX5r8VIA04CkWcGiqrNnS4MgGQi3TRw4IafehGVYII5XrCtTJhZOdjmv79MAaV+nKKf2dBdmOGmCZFNHoG5Qn1s80xYLb59M4rHASW6+qOYLWqNF4J09Vr0uMzrAUZLvoiP2+Mu4RM6b53DpMU5Txw1GivuCAi6oqEITcS8VjIQrwyPiq8O9XGHy8SJnTcBTK+rnLaFfyoBvCUYoZLD4JYnllBudfp9W9wwRz8As2v5yFNDUcqeQkaabJeYChMPGRlv4d03XLcaaFXggKLFcsIpuGapNT3pcT2ZgyaSyOoLOue+cGiSlpP8WLameItsolp0KSVVe7z8h/ArkilcSSYuKEoAw5h4d8iNbXJ/k0atcDSZBtdqUSfsANXjWag8yf/G5xRzRZAK0Db962VMV28ZoAri7nuiWqtthS8BUzgv+CRt2ab2jWnraPmtjpmigYBButCqYCe/EiKClYWKL6tmnzdFYM1t3r+mIDTMTdATitgAvIdAjjQmU1
 492l8WQN
 x+JM/3r1bNzDVchTfNTCQHxwmvcXlHv7GVp8ZVRzf5dQVdcLCwmN77p31KdSdIrImHidFldb4IiDaboeIOjpfjUv8WwjRQLboVzN+aJZl4bKrLgYqmpg0PFZCZjRWr5m2ATRt/kANzkm49pNalCluJ0gZ1OP/sOJ/5FmFVUPFc4iVINTk71J38N1UkWSixp44x99ZM2ubF2yvUqndA4GJMZA54WVxeVoTcOEEfjoVshrjUbzupcgh5HQLHme/IyGrZoYFyYLthQULo1Vjk70ymw/+5oEsffcgKcN1ZM2mZ4dGSj4YEk1AeibCFYJEesuAtX8ATFrXlDA95IsDz+hH+8s18pwCPhmjcasL/xFbpQdbKhViHayNzo1648Ae9ZKeEaYnhSLYy8wLxKYZaopsfYOBbJrh2TALXKJUSl8YXcfaMAB3QbK3NnkjgwBxDnUi/xA+oEAIvwN0RfS+g/9DuGy7qz3z8CIvHAs2BoIFDt1vYbPPVN8xEJypeQgASPhc8W1rQF+piiroc9WRu/Rr7IWpFVQAQoW0Isqk2mOHRa/kEm81m3War8krF9u2nzjiJOUCoUBc+jKSZfgco+VqS3Ux3xPPeRcL4Pc55GWuCeMGUBHir8DZ0X5ehcxRDrQ+8GBJE+RLTln+CV29fr7gnmqEUwyMDeYJdsB+Xv4kQPA+Db4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 06:48:41PM +0900, Harry Yoo wrote:
> Hi Jonathan and Lorenzo,
>
> **blaming myself for thinking**
> "Hmmm it's already there, it should be fine to use it..."

It's totally understandable :)

>
> > Yeah sorry Jon on latter bit, I did mean to get to that but workload
> > been... well you can see on lore :P
> >
> > I have a real backlog even more than usual right now too due to daring to take a
> > day off on a national holiday here in the UK :))
> >
> > Harry - more than happy for you to do the above as part of this series or
> > separately, will sling you some tags accordingly.
>
> Okay, I'll do as a part of the series (process_addrs.rst and memory-model.rst).

Can you please though make sure the formatting is all good? That doc really
needs the function names to stand out, so that's key.

I _think_ Jon fixed it so that should work fine but do check first!

>
> > If you're not already doing it (expect you are) you can generate docs via:
> >
> > make SPHINXDIRS=mm htmldocs
> >
> > Then get access to generated HTML in a browser locally in Documentation/output/
>
> Thanks and yeah I'm doing it! :)

Cheers!

