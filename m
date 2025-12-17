Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC8FD66B9A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57F66B00AE; Wed, 17 Dec 2025 14:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9BC6B00B1; Wed, 17 Dec 2025 14:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E9E6B00B2; Wed, 17 Dec 2025 14:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA906B00AE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:49:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CE365C7EB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:49:45 +0000 (UTC)
X-FDA: 84230003130.25.E78FB21
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9501F100006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:49:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QAi1BRCy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i6AnOUxr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766000981; a=rsa-sha256;
	cv=pass;
	b=zQ7+jBDiwuzugH4QGHfSWG8N/r8IoCAlhgrKSsYKTVtENuO3eV3pn9usJAAmXit7Inu5+X
	ugaO+kYKeFczyhAMuAgIiFvBGdKWd4qNLJ2s1WHaSZ6zFXoZVOEZe1iTiqJsXDK4bVETdC
	nFxnPulbGWL3H6pVx4xA618C+nS8U9s=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QAi1BRCy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i6AnOUxr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766000981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrpntapdPSxlUk2OojT2rqmfaaWuMe7XUQ3wFkT2uEI=;
	b=GbzVCBaOQiThcut+d7Ts12LiV6a4Pv6791xyNNyHhIw//O4d9F84FY7SjinErpTWnwfkc7
	lG6RUEPJSq12XRr5i7SafoJ380HoodVhzvcLHrtkjNiJ97qTeOnyXZxOAeqHFBme378H6Q
	iEitsDGxjQVTHXmS1Ujp7LaIUQtr+kI=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHJQpwO3319003;
	Wed, 17 Dec 2025 19:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MrpntapdPSxlUk2Ooj
	T2rqmfaaWuMe7XUQ3wFkT2uEI=; b=QAi1BRCyELTqkpKgTjwWq//kACZEiFy4Dk
	SUVdwhxnR+wEsMQMkKiLo1CGfc0piiXDXd/0/LbWGU387zXAIycXX/04YIRgseNB
	l/CNSJrGZEYH+URWK4Zg3/NK556fzQPL6gi7HL+ssVp92gR9r/l1sCtFawTKKVFT
	dKLFvbXTCMM5IL8OAOaXn2SEFQyZ8432LzV3EfxrpMGi0BMQiptE/EyiKZ+8vIXD
	LCUrhu05aWBjb9/L6iTWfBbhY3IVvk5xSHTu++8muAeyX538IFWDCtqQ5kyYLKMN
	G91zslJgj2CIn7rmNWnlwXLpZTyDCcaby1SfES/GKjiJB3H3vHcg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b3xa2rkb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 19:49:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHIm1sd024747;
	Wed, 17 Dec 2025 19:49:26 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013030.outbound.protection.outlook.com [40.93.201.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbxy43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 19:49:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdTdVB4eAoygc417MyDbcGmEggFWTCOVDqZPZ3sN40m8UIZ2nG4TAdW7eC5suyZF0Oi59myrEeNciXBJFt/GocjZg3PzrjJaHN0GGzcemjlZIewVttz+Vzj8fj4qOpPdpujR6ffmVnpCreICyA5l1BhZnK6aYMLWuY9HPHQVGlolUpcr3MjKYjugun5iOTXT5mv15kundSqEvikUWgw/tieJ2+Kfm2j2sCWd/1lpwlR5pan8KnwlHo4cvTe6ijktTWpKR/mDykpmhWWp/im5Gt1zfB/MDkHi0KoPI260DLowEpYGPhBxU313/JrgSiCv4FgRAravTz7mmXxLtcbjtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrpntapdPSxlUk2OojT2rqmfaaWuMe7XUQ3wFkT2uEI=;
 b=BIXuR1jcBopf9aI6Zzf+zrXRvr1Cbt9N3Eagw6tVwn6NKBTYNc7kmBQsKqEjit+A4erNh/n+brxS4Jfo2TxQWe2Uh/aGWOT/pzUgeZJpriLGUXBmzjOKtEI28SwCp+APjEzXNIZB95E/9a9nIM+bQy0ywUVTirdP02OMakwZxO5Dg8R5d6zX5zTEZGa7xoIeLcC/dbYtZvIflNmDTEGIgAA4N9n16yQ6b0phrpkTTnchLtgSQ8nC4at6QKz24KgdIaJgQ2vvRm0tHTq9P+CqTHZmOj7eosco+XSKHFXnGSXqvas/oSZF8hiG3goY2OKbp2dwbau0wPVsJduLP9tBKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrpntapdPSxlUk2OojT2rqmfaaWuMe7XUQ3wFkT2uEI=;
 b=i6AnOUxrpeSTdMmZCxGJmCw9/VQQlrdoTpuPW3QpRs3JsH8v1HQTkbZGQ6daFy4PqtArx2FBcBG7ZoiIM1oIfh5xmX98CiJxqTn30o0qzM97XBcqZmqRNmWIRq63gLsHaTcuigytZ1I2d9DAWUDN/iXrFdE0HVZxNa5KRmggNfs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8419.namprd10.prod.outlook.com (2603:10b6:208:57f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:49:22 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 19:49:22 +0000
Date: Wed, 17 Dec 2025 14:49:18 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] rust: maple_tree: rcu_read_lock() in destructor to
 silence lockdep
Message-ID: <rfpdf2suobpchpuw5gqzgivwvon2kd2cub5eltvbburnsus2iy@j26cinzdxxnl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT2PR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8419:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c65d8c-e72c-493c-cfc9-08de3da5601d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QyChc//ui6T8q2wuK6hLvzF2vHnVCzHrVD2lOzudWOufmUXz4L2zTTNkn0Yd?=
 =?us-ascii?Q?iCxCFvlGaH5vaZRtn7kMPJ3AkNiMgSDhHRMTtwq/mCGX9mrZl/gzX+VZvZIq?=
 =?us-ascii?Q?Z3ZtaZrsIbjJO2KuuSSICwyKdSl/G6BCHQTh/m1C1S/SSIQVReCZoTw++L9S?=
 =?us-ascii?Q?S/rq7Xe1vUgwqC/zTKVnmOgJm5L6+sDUaTsyWhdZrTdGPZmeahktgwwwj07V?=
 =?us-ascii?Q?ovhAwBGIJ4Jp0RqaYXZPYpQbTe1VhHhAd9yuH7Iq3GoVU3vxNjWb32JYx5cf?=
 =?us-ascii?Q?QHUPybvReB+9mxURmRAPY/bvoDFitxGpjH9/nZeaW317Xdk1f1OtGWFOpVSe?=
 =?us-ascii?Q?Cq2L2fWeNtl4vdPKeTu6gPjv/e23AwTXCxPZVms90waqHz13Ul/gqI/S64Pe?=
 =?us-ascii?Q?+ejF4r4dSwi/CaFM4joC9F7EsH1TkPTeE0rMye1OVLduLUt8jgeC7FaZbyQ5?=
 =?us-ascii?Q?w8QPzU0NFdZa34bH09atH14cB7LAgVTyihYGQ01UiHhgNfba+L+pnP3tz8pn?=
 =?us-ascii?Q?JQZi4VHx1WPhyzN1k6BAxHDlps/At1XQaY1aTNJuHHeE87lvF3kmyhYOxTUq?=
 =?us-ascii?Q?1iOqb8lTzQqNLRYEiU3YI7P9TfbTjmZMkr9D53Bx2XMN9ksn6FsaCiZax/Th?=
 =?us-ascii?Q?XbBLKTZKhvjQXBi+7cPwyQ7CEj+Yy60CsBmgVkbuSL13a9/5gGp8RnaOldXb?=
 =?us-ascii?Q?1z0r4ConssyJDC8V8h3MeB7YCj+SU+k6oUPD8KKo2tepz7D8owfLwILCo5sZ?=
 =?us-ascii?Q?cp+lmwwqe33PqrjEg8UpA3bvqjzrqCQtK/sET3BYyH+eTlFDDmKXg9byBrR5?=
 =?us-ascii?Q?U1EPrhpQHu/o5m/lZKVFRtHkWbspcnBBlE8tr8gQ/Faos1QRy9TiRrBA75VO?=
 =?us-ascii?Q?/c1RxXGZNtuMrPQkYba61epwzc9NkSjlYsH7sMfxJfuNU/AKSY/D5N3WCl6m?=
 =?us-ascii?Q?tz7HaF07Vf7VyeMvm39BXFRLi6qTkc7oz78qqX/fyJRrgA0CUOkVltAQu9Bu?=
 =?us-ascii?Q?8q04eZb6tBiJwcmRYUyEwWzVMxveuDOhDVdYPZnUmiWOXKt0aopHeckJivXk?=
 =?us-ascii?Q?hfyD+NQg9g4mI58E1kpZEHk+/Nwjra3T1yyy9PkCrzWFecGk6MequeZfFxYP?=
 =?us-ascii?Q?KJ1VPkSlRaW7kFY+/QA6qFMEKBTgnvlK/KUCCL/dsPJbPBLcl4xgEr1LRzYg?=
 =?us-ascii?Q?kfBvUIRJvImMdT3Zx8TvZvCV4tguPaSqk5NVz0j0GEGJm+Ty5rHpQKKEbYB0?=
 =?us-ascii?Q?2Ep4+8P45XmK5fjg1EjaY83J2rc6Mo2iWdM9XHm9uFFWO1jZ5WSOQxhbkTp+?=
 =?us-ascii?Q?7xk0m8dVNQoFitgVPRj4lqSVyslV4lSm9/4/n1tYZq2vGjatkUpHEMGdSv2a?=
 =?us-ascii?Q?ubO8I8nvqNiJp68977P5GNrsxf7inhxr0pWQZpaMpE3Qfd31KQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5wgr69r2ryirHo7GmfCGrqOgNbuvwulUh2W3YCeOvYvWZw6kkeDwqbwqR0wI?=
 =?us-ascii?Q?OG1XwyK4J6yu1+zCeW134TCFwCgYdQKqcaB3HQCUtZXCJEYrPfLbCYCMJDfX?=
 =?us-ascii?Q?15bJWAAz1QvavJRF60cs1MnppjQ1X8M2MdpZemEbsKAb4fjVCVhNxxpQIDqM?=
 =?us-ascii?Q?UP8mEZBFzr/PYAcfxUCaH3NJ9KJWwwuc8dgT7WkKhkbkrK5oVvEhLoeBDzw3?=
 =?us-ascii?Q?2iTaEUYqdwsZ1pjHjUFuJ4ejloiDJLSSGeKOAKzMicY6tj1witRDeQ9v6JWK?=
 =?us-ascii?Q?vYmpDiTLoHssX0+kWbdLYs7XvqIPIWw9bOxU70dP6wilNMyGA2e2XZ3ajjeB?=
 =?us-ascii?Q?mH8TW2n7vgIF3nQ9wgKF0kSl4LhSx/ZmJCZbxuoiiIfcgSYke3o5aBnBdxQf?=
 =?us-ascii?Q?6wAoGPh2P0uJ9PqDmH9BW8Kyfzogk6icGl4pOIIRZntQZWyMOX+eY2jooFcY?=
 =?us-ascii?Q?2pBhkO7/Ze5nwgfAJr9JT99JDWsKB/nUzMUAJAVxoMR88EQ2tiabHYIosFna?=
 =?us-ascii?Q?3N5GhsBAdis3jc86t2sUYFHJ6KyvInXKwRTNVu2DLAfUM6+PavG9YmjXh8oh?=
 =?us-ascii?Q?+hcaf556s1d214+9jnI2rrnxIdDt7VldIWkvcZvAqwOGmBeM+lRUdVsX0a2T?=
 =?us-ascii?Q?YxsusUWEgAzBgqDp8ni3T1JSULUJtzYYqxx+VcC3SeQIrg/VQw5sTJ9dlbjo?=
 =?us-ascii?Q?/tB9NK6Z6v+AWBGHRGITacyT5P6SivAdVsA4QClIe+CfeRUtXYGTF2VAR0FT?=
 =?us-ascii?Q?PYFSS7eI73iDytyQK1m03S2GhctYg2FpDtdfskaLxlxLeXCPmS7Y9zjqXxmX?=
 =?us-ascii?Q?/KNH4QsW9vBMyIwqt9L7rxO1UFkv5nAHVpkVDqe4Uv9fbLxxL7dWEs2S+cUR?=
 =?us-ascii?Q?bq/Fa3xV5kIPwYEa0W54z2q3/PVgDwuSK/+b3niKjPYl5UPaR9So3j54ViBU?=
 =?us-ascii?Q?VfT171R86a8DmZaFwBi7eq8kk5Bs4lo9798jUwX/MAmN/G/P0gSstfNoHdrY?=
 =?us-ascii?Q?cEsDU6Pxi/7oOq/bq3B2NwSPTgSuAiLClfjI7fzSnm6ik5sYVCdTxTC9vnjD?=
 =?us-ascii?Q?1M/593MIaLdtrdSbFnyfryaZVgWLq55d2PW0mpqMNvQeXYQ2f2w1b8KL1Zte?=
 =?us-ascii?Q?2wDn5Foj5pRlQnXWlj5Rw2IknUaq2xP9C1ocCmxjhtmAoDM3O4ns0cfpxBC2?=
 =?us-ascii?Q?xwaOG26Ue+ceKjbtGDD9zeSrN5Kqq7l787H8su+yEliAVic+MIRBQC4JtANg?=
 =?us-ascii?Q?EVnWcnIA/IShDK7ZU5MwVqnuZ8/zcODhQ6vdSvnAKcfhIOuODqlAyzahJMRd?=
 =?us-ascii?Q?8UI635B9mHtIc9yQuTzlb+c3tpWDLyJR6ASRAkJ23DlLagfbLIfObTywyL46?=
 =?us-ascii?Q?z6hns/L/e+17SSRIjciVRE5sbxy5RdGzzaNtjniFpWAHxKyYIjVpwBFkC269?=
 =?us-ascii?Q?g5JTCwUWDhtJc9m0f1O0AOcu3xbCKTAS4mchJqZqrYUoepx2I9WuZJXXVHdE?=
 =?us-ascii?Q?LSNVlmvgXc2tMrqFWA8hzLOCy3kkRIhcFkQoXPUqT4BruAm3jL2GP8fHIGVf?=
 =?us-ascii?Q?q9TUNMcfKaHYq6Lb9o7663VJVm2zTY344nIMJO4d?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MZ0K6scCshSwizCtKFopWz6fukjdlJG2YhVuGoEM+ec1QFMGNiVfXTv5iEODlsOOhaw90lJADgfdKqMYcJpWvVu4kDDyr1OiO1nRkaRnOFK0EVZAwUIaE4k5AkKK+GK2Mkd9cSoO+cpC7/tRt7hxd5/P1PNKv1xJ/jT+aeCcunGy98LmZlu2t3JVJq29WGKxEZ/T3WIYuF7E2PTqdT7ztzjSOyR/RjW6dCk9I9WgfKOPUeIWDKB84OZ8mF0mqW+cbaXdRZiiw3KxhVHveClnaM01ztAI28k1T3HtGWXP7R/mnphvw6BLQhNGqcksz2T0VNZUZq6dLfx3VTq4B60lrdvGoXzURE15v/oMyzFaa0iMFMhaWKIEMO68GQmmHPBq1YaYjRKS2hjBo+AW1tm2itVbSIQqilvbAAo5myoUelePbRxdF/MMaSquZgf4xLn/O3GJl4kkefICAtzYbuAz9BsQErYO4Jr/5b6tH3lAFRlLSS7VkqqVdcibayF7nk/FsjJBJb15Xu8xQEhpsx5sZ92orjlenWMaEBZxDEmC6WYQeqqptnhvLkMNcOXcmr0V1YIGXfVq6UIZhoIF7JxdUOw+m4oD+xDCpfrYwuT63pQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c65d8c-e72c-493c-cfc9-08de3da5601d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:49:22.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMSNuGVFGY0YIyto1b65rXZfE9ebXrzuR9iFDee12FBASS6B08mD4gRluRhxu35Fwzu3B0B4StkPnsbWfYqSSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8419
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_03,2025-12-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170157
X-Authority-Analysis: v=2.4 cv=Ot5CCi/t c=1 sm=1 tr=0 ts=69430947 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=b7BRixBjAAAA:8 a=1XWaLZrsAAAA:8 a=ID6ng7r3AAAA:8 a=VwQbUJbxAAAA:8
 a=SSvv8DXhvRfc-a0B9roA:9 a=CjuIK1q_8ugA:10 a=L52EH0_zNN2ZrnE8bm5f:22
 a=AkheI1RvQwOzcTXhi5f4:22
X-Proofpoint-GUID: cC6v5EHS-9xRastaoCgYSzQKaIGXEV9C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDE1NyBTYWx0ZWRfX7OIOR4OjbYDG
 BkCi7Xpl2A2Jg7dhwNDN1gSK6TC+uQL/0PFbVzCrr9yghbttYfGN86TNa1nL9wssTDAWktn/t3A
 Q45K/GpuysZV3B8DEfDb9rh8aRDWq05JJ/9YVxK0fX/Yhgguk0qccyYySyBdqvlD58hI8rFG3vu
 zcLBSlW3X67fT9BF8+qYRZz+E7bf51YAp8UrZEDISRQtyihs+VQQ1mq5byIwIPJ7gse7DK1Gxgc
 3ELrstyhsdFiv5v6LBgRMsso1LI/Rs1D0ln521B3zBFqcgc4a5g4Q01oaKJ7WfV/ioKqKLb7XoW
 +6DLrqKntr3N5zNX2o6qCgRRez89E3nTbT2EJf02/4dkQDPN0jchuMSN0XnsaS4p46144iGidLT
 /pWAcF9HUQSOX59gThjz2LO2RXb4VQ==
X-Proofpoint-ORIG-GUID: cC6v5EHS-9xRastaoCgYSzQKaIGXEV9C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9501F100006
X-Stat-Signature: o8hanjcbmb5po5zkmb6hn8jn3d61ymrt
X-HE-Tag: 1766000981-130614
X-HE-Meta: U2FsdGVkX19qDRJd+Geswhak4uRvjnNEPb3goHwPfQZCh/au8vs28igXrGk5XDr6VOST3KbFVMGR3jLQc8QZ0rpABIA+bostwc4PezJRL6Fd4TQG57PYjRqvLolT4SkeF7F41qlnlwmEoU1boN4JzMDHvmHA+LtdH82xysf2M1fz2LgO7CbnAwZK830tP2o6uVWUdLu1xlevBJ3m1pzTj64nJW52sqNibgBqmGB5VfhHVglHnD49cgn7C/ChRWzttCkURQDY6+9Qd4LkGqurzzU/c468JhFJz1K/Myaa2cqFvJ34+3EhBiQ1aHlqj/zH/saoHGQEH66+aspPNPMzNKk8CEwzw4414ujPOArrNxzWcxb64lanC3Xm2V1W7MiKqk4jhoToPPY6bZHIQvUbu0KlCDsGhAp1KYezajSrOfyJM2kvXWdrEyHCo4FTQFn9TRMcO7nM5QWtF6x2PxF4/ZeF16NZ3s+ZN7j5XnkKe8umD+w85tt6s5Q0x+X/824m+Ip8w6kaqeuUQ11gwSWxcUJ13LOXbts1an4tH6O7PPOBaHqVWY0l5IiDxn6ABkoe3BF90nh9qqf1uBWVTjYBMRj9bhUmL6FE1ok/X6dAmEmYZMPxBOkjfxxIHP2eBtLp5PLCTtqODVvWuG8z8T52Lf/qzhEkhMXdmnFDO1R/ymWvYwnz5l8Gf7IZsl8zdErhGBPCG/K5oaBCC7NOMNrCPdHGG8DIvLOIEbTREDBO4sQB9YqQC42NGGdYqqLfe2PS/yCu/jIzl+8bV5TDUbWNVxN7UHMayhGdOSgfPUHLqUNsn8zhRGsZb6jpnxQR608qwMeYmeKkNC38bUalj7ZirHFF7nC51ku5Y0oIU6q1WtQbmibDkvGDoHqLbpHDToaWNQ1siO5Rq2+lWrcFK606RsACBKP8aq+LogpSOehi4MpfRDmLZUcDf2z9dktR0qRZ60NEUuiz07oAlFUr/Y8
 gCFCtj5z
 T5/1WnJYSjE/+GCkExZfXGjb3eoGR2766dUL3j9178dl+sRiJD/LFhtZS2kTZeLiS4080L4kyQgOSGRO8YPuEBxMbQzMwIDdK7jRqp77005Ht1OB8kDG5V4edQfv0KfmHV+RWQQKfxr335pCcahKG2rD+6QVTEPqiUFadrNwMjKzmYf2FsvBT/qEBaISmliDE5mEUlWkdZKyj0VJkBWxfBz7FCepYHlHqWB7G2CO9bMqQO+8qn9nWtdnZbpZFqnrqjkOClc3m0lo3ooHpbsRsWnQ9Q+ENJmD+/5XRuYUF2DYWtXCiTSspSGNO5RUEuqwv5ij6Ii5O428zcx2emtDH6QUPEWhN3bQlO/Gc/tRgvN7Fg9ti8EksB9tWTsx86cA0CZP1JHPwXsvM5ywBFCSFj0QM8k+NKshjuqhfVuO8lh9+Ll0mm44DoCRpMUGxt63EFRCDzkvQe6Zn3BLElHz4qdj+v9rp1HBZMDTrk6MpotfkvOMTq3iqc94oLXHXZZx3b7g9KZ4KzOk/fP1dKZ5BYy9J3tG8QKMYKYnlP5yh6M/S+c3Jq7gdNRoZz104C2GsennVmcVbdC/NsTL6ezn/Xp+cNbybSl0KMQ4HutUh5ZJ07izYdM2R3GNaYg0w/WjT4FUPeCU7FNYj42iR9xx7ziSlFgczKC0XKyxAJ+4zCiCynj52qJzuG3+g2HgWzlTQzD9EqmdTJIqKT6kCpO3br6LXLTspM3XX5WyqqU1IkFk8DjOHry3fjfeu6cNky3WIZFKQAH3U30czD+cJm3n1arL8llg9AoibsE0usc1UkC4tMUcxGnbbLRg07K89chFQ8EbdtV/wUBjtZr9HbQOxzKIril8UZaY9KYeVOxrXaKEcJLf2c/oxi2h+IkVH6t/JbsNqSY/1CRlzTWS8th8uEe8853Ojw6LTYp4i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [251217 08:10]:
> When running the Rust maple tree kunit tests with lockdep, you may
> trigger a warning that looks like this:
> 
> 	lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
> 
> 	other info that might help us debug this:
> 
> 	rcu_scheduler_active = 2, debug_locks = 1
> 	no locks held by kunit_try_catch/344.
> 
> 	stack backtrace:
> 	CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1+ #2 NONE
> 	Tainted: [N]=TEST
> 	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> 	Call Trace:
> 	 <TASK>
> 	 dump_stack_lvl+0x71/0x90
> 	 lockdep_rcu_suspicious+0x150/0x190
> 	 mas_start+0x104/0x150
> 	 mas_find+0x179/0x240
> 	 _RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10maple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEECsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
> 	 rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
> 	 ? lock_release+0xeb/0x2a0
> 	 ? kunit_try_catch_run+0x210/0x210
> 	 kunit_try_run_case+0x74/0x160
> 	 ? kunit_try_catch_run+0x210/0x210
> 	 kunit_generic_run_threadfn_adapter+0x12/0x30
> 	 kthread+0x21c/0x230
> 	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> 	 ret_from_fork+0x16c/0x270
> 	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> 	 ret_from_fork_asm+0x11/0x20
> 	 </TASK>
> 
> This is because the destructor of maple tree calls mas_find() without

The wording of "destructor of maple tree" makes it sound like the tree
itself is being destroyed, but this is to do with the stored entries
being destroyed, correct?

> taking rcu_read_lock() or the spinlock. Doing that is actually ok in
> this case since the destructor has exclusive access to the entire maple
> tree, but it triggers a lockdep warning. To fix that, take the rcu read
> lock.
> 
> In the future, it's possible that memory reclaim could gain a feature
> where it reallocates entries in maple trees even if no user-code is
> touching it. If that feature is added, then this use of rcu read lock
> would become load-bearing, so I did not make it conditional on lockdep.
> 
> We have to repeatedly take and release rcu because the destructor of T
> might perform operations that sleep.

The c side avoids handling the life cycle of the entries because we
really don't know what is required.  Maybe it would be better to let the
person storing the data handle the freeing of the entries (and thus the
locking)?

> 
> Reported-by: Andreas Hindborg <a.hindborg@kernel.org>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/x/topic/x/near/564215108
> Fixes: da939ef4c494 ("rust: maple_tree: add MapleTree")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Intended for the same tree as any other maple tree patch. (I believe
> that's Andrew Morton's tree.)
> ---
>  rust/kernel/maple_tree.rs | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index e72eec56bf5772ada09239f47748cd649212d8b0..265d6396a78a17886c8b5a3ebe7ba39ccc354add 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -265,7 +265,16 @@ unsafe fn free_all_entries(self: Pin<&mut Self>) {
>          loop {
>              // This uses the raw accessor because we're destroying pointers without removing them
>              // from the maple tree, which is only valid because this is the destructor.
> -            let ptr = ma_state.mas_find_raw(usize::MAX);
> +            //
> +            // Take the rcu lock because mas_find_raw() requires that you hold either the spinlock
> +            // or the rcu read lock. This is only really required if memory reclaim might
> +            // reallocate entries in the tree, as we otherwise have exclusive access. That feature
> +            // doesn't exist yet, so for now, taking the rcu lock only serves the purpose of
> +            // silencing lockdep.
> +            let ptr = {
> +                let _rcu = kernel::sync::rcu::Guard::new();
> +                ma_state.mas_find_raw(usize::MAX)
> +            };
>              if ptr.is_null() {
>                  break;
>              }
> 
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20251217-maple-drop-rcu-dfe72fb5f49e
> 
> Best regards,
> -- 
> Alice Ryhl <aliceryhl@google.com>
> 

