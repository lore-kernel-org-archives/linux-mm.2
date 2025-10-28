Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779DDCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CCD80124; Tue, 28 Oct 2025 02:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6412800E4; Tue, 28 Oct 2025 02:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C3F80124; Tue, 28 Oct 2025 02:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0340800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:41:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 600481A03AC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:41:17 +0000 (UTC)
X-FDA: 84046576194.17.56C61DF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC20F20005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:41:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1pdYJ+v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QclXOqDX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761633674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNznZlWHurlURdH0JWccGDcL9a8vf8YQ/wP4uTT+acg=;
	b=OlC2557sTMHrw3h6a0CF1vspGKcHx0vvUFh1pYtF+8dFCjgWyaX5Z/gdz52gQXi6oa0CaM
	9W6ym1u8cDp0B4IWrnBtS6r+XTlKfPYnOhLuNhSH+jaLmc1+bl9aDmHEZJxNwml7CfNNhm
	vWEWQrs2G2c3BjcWys4+6bXJfIUqT/Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761633674; a=rsa-sha256;
	cv=pass;
	b=lf2eJZhsJEn2IyeFFtqEiEJ44FBd89uleh+Hv53h7yJlfFszr7WZbKGetFFTPAtFM/k93n
	wqwDl/mhB9VBJmaGKoQQVzhB4VBwZVO0T3u0phkbJmZaHhx0AwMSyjUXci/uyrmcerDkF8
	eVjVpReqyx1BcIeJzQyUrhTUCetOxmk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1pdYJ+v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QclXOqDX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5NEP4031223;
	Tue, 28 Oct 2025 06:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TNznZlWHurlURdH0JW
	ccGDcL9a8vf8YQ/wP4uTT+acg=; b=L1pdYJ+vEcmi+Ua8xQz87cJ+RBWOl/UERK
	bxxP/cR+aqMWIvn+Y/u9+bhA1WB8YS34ZtfsGxaExFN10VhGmsmnRQZ03Hgdnctl
	cAdWUkF5U3uYkuI+x9ItHc9K+2eq8oo5mDV5cE5m+KJi0xkPxoPH1Xk7uow6N1OL
	xTkBWhYJP6MB+w+5PhhCTZE7NQcmvLP+Zs0b+2A6Yhi++enLBZ2BFcWF2HBKczvP
	/NQ7ZZE61HnUcUKt0nZRx30bRd4LDFox6KKFXqw8/9KJJ41IKdtlGsg/iwLdLcRZ
	tF515w6iYKtsonIjvcFwDdh+lYmQT6RQ7YKkKZq7W/TweGkD3Ixw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357jqsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:41:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59S50qAh034862;
	Tue, 28 Oct 2025 06:41:02 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pf60r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6eGd3QFkyOLXWDmup7C40dECErHxPcBFqqd5e4bL1GbGdGnPCqsxmgTqOaNsbxWNOBv+c8a15Ol2b0h729EQVpPvuD8PtiIU35hw8lrWyErGhnOZ4fzcNGJ8mLTXDGU/bRkzjr1SevKan+lJGEUWSMhhumKRcp/ldlX6BtIC6VKGsOdjTOreuRTMjnTHeePTpVwuuSos1DjS0ngiLA/oPeQd7G61CNXTlVdyzvE/3/LbVmkgvUNAHC9a5sUcJJyDVy6Y/Bva41yzKobkAzbOh948HzyxJE1N2fljnpJiVkCUuTBS/SLpLTmOVisdx7u7oKexYpTrdKZbrYTGYyBbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNznZlWHurlURdH0JWccGDcL9a8vf8YQ/wP4uTT+acg=;
 b=JlZoFKDLC9SEhqaO4KoH2SVI0FFruBbqR4yRgZ44Doe27JYjGK/FzJnHbpSBiV6TJ9Uj0gGO5nyl/jh8Ggtw1THcB+6IeXJK5zu/9jt8Up6kd21esNrPMiEymjOiCWH8WGt/gxE1+p3L6oMItvPl/2HD7NplIXeZyOD1OmhTMOleAslKBR8Yi/4plxw0uEwWg77PgVZEsgODgNACzuIunC1ry80JIEnjqtF0tz8aa8aDuNHR/svGBriHCPqpztFrLxMf9xkj2tyZb84Ii88OupG6gTIc2cOlzjLVs43DwKMR1rQpG/7/3wreWkU1ivZookkLVDWEupIqcMSmmBpNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNznZlWHurlURdH0JWccGDcL9a8vf8YQ/wP4uTT+acg=;
 b=QclXOqDXu/CD3u0bv7ybsIHbw5TKpe+RTUUVXcv7Kdel1kMZ+H3bZXWNpjaxNwMNLUX+4E4vHxW7xE/tytLaEd2ZvTSRzvkpxzN7wg0i6FCdbItCulxVEuwddWwZD2fFjRObD4ucX4qJj8J1g7gdBhyutIfcHrbWiUC6VYh/OKk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH8PR10MB6313.namprd10.prod.outlook.com (2603:10b6:510:1cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 06:41:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 06:40:53 +0000
Date: Tue, 28 Oct 2025 15:40:44 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/17] slab: Remove folio references in
 memcg_slab_post_charge()
Message-ID: <aQBlbMKIIedDrJet@hyeyoo>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-4-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024204434.2461319-4-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0157.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH8PR10MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e5d2986-5430-4653-6357-08de15ecf125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b1Tnv9bitbEf7jDjmfm28zr2QeU07Btt+1HTJDYjMg3swBT2qlhDx8Ud5pjN?=
 =?us-ascii?Q?rTRZEtfpHiYs0h+8oMvocPZYAxQwv7TDE3P26c4pf4sTX1oxrkyuF5FW3p8o?=
 =?us-ascii?Q?H8e8CNxTLypV4Nz8bO3VMAsvKU1ys/wSUNZGwgUl/m31s0s/x/PeknKqbVaW?=
 =?us-ascii?Q?ldYvUpvaoT8EuQUTm/wD/jL+/jDN3rJX6+TJ1C9YANfgkWvKcI1goPLGX3A2?=
 =?us-ascii?Q?i3UM9cY7HP9Q+rlt8AeiHyfIAG0A5mqBlXyVssRYZLfvE3G5JECM6RU4wbap?=
 =?us-ascii?Q?H9rKwudMo+9s1iwvoluqNWJQnwz1FJhYWG7ycDrpnde97VbzWhQXAzrOkxoa?=
 =?us-ascii?Q?5fNhhO4gu9Mk/dyrnFe2DvSUi3r4xN+PyFTF0k9Km+dIymg04vngEwzhaTm0?=
 =?us-ascii?Q?tMe1ctEn7zrHD+EA+2VNoYB7h3SrS4IGjv0A8PSZoa7HJZNI/9oy0ygDtYtA?=
 =?us-ascii?Q?k7YKLAL3MbbEK3UAsvzzrBRAO3+5MygASQbyUbQSTcSLfYrUVzt2SOIRVCTH?=
 =?us-ascii?Q?BpelaQfcRudvVoItzWIGR3jw9rxZgwnUoq2N9fklPFfV/4UUK42dVIepfQJ4?=
 =?us-ascii?Q?NVGI8z8oF0Za5C7HhJZ0HkavW7IC8cEnA0Pz6+GSrdjlbY7eQI3cyZLT+TYZ?=
 =?us-ascii?Q?qUa5MCHJSnFCKsdz7z1kTFZTEYeVsso+OXGi1yNUqVBQnquRGWqfMY/CZsqY?=
 =?us-ascii?Q?uM0xRRvvRMiApgAJIWTCvfgYeQz/MwKT5uFVi2cDdjkRXOlExNA8JrK0iRv7?=
 =?us-ascii?Q?eC8s6SZQ57MrQ11HFOESzHyWUB84y+jI7slxdcAxisc81exhzSakLtjXkHE6?=
 =?us-ascii?Q?W25MZGkojYp+oY5lEYfFDy3KvvhyHEQgWTsXye3UMU1iVGQ5qc+0zNOC3fn9?=
 =?us-ascii?Q?IqvX2Fs5AJN9VzP3Mkv6AD8vTVIvmuCG3JDebqBGdKdCq9RNKyuwdiHkuWYX?=
 =?us-ascii?Q?thiGcOVAuaJMGwLUiybedBoz7+IHgSlo/ErwjaPGwowSUyjR4YctzCHyw7JI?=
 =?us-ascii?Q?y2z/1rATbdkhe340+vB7OLlcPcyghhgqcH7raebUUHiuD/DxIChaxEHAIYiI?=
 =?us-ascii?Q?6nCszjgdtOP9OlCNMrFwxM3sLcIY81f1IktN0XLepNoQEm1Cv9F67nnuvCN0?=
 =?us-ascii?Q?ikUVtTUchQp9mZXN1a1Ec0uFntlq5RHJJd8YbtW+jGzUO9DOAgp53kjlj+fo?=
 =?us-ascii?Q?eTsNqY+o5Yaf1qerEXcU0SWszimG129LU16btFYwfWxbGtC5CvOrKtqd75BK?=
 =?us-ascii?Q?61U4uM4fJ1HlD8/03o8TjqC9omEtNYgDsJaqaNjZY6alY62257btyc0dQmJ0?=
 =?us-ascii?Q?u8GBdFiSohWuLzyzCaz8EaIfaLs16yZgyRGxE5NpvzDL6TfG9B1tZ6wjdTZv?=
 =?us-ascii?Q?tCgHir8E+qfzuW1ewp1NK9LWQvAvKlHq/Sx8xkRFbGL4X+vJf9jVldKUFptV?=
 =?us-ascii?Q?KkXT+Cbs7fVEzS+g4GJiD/oHLZu4BVnJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BiaBFc+rJqpieoGc1FtuO8gvvqxCAhpjSIiIqOog2ezbI+Yvzv4Ecv0quqTW?=
 =?us-ascii?Q?ovgILsLIli5ztNLDn2G5pkYuhDQCQCmYEo+K+6fOSasEnuyRSwXrfvc1XeTj?=
 =?us-ascii?Q?ZFwr9taTAofA7bi2Z6CFx5u+yivRb6jUIM1HaEqOc1t5/D8nJwj0XMoGFpUk?=
 =?us-ascii?Q?aYVUVm0jMqcNFE8KmsgLcfynuAOV/PaP9TybLpBLoN4v7tU9mBlKeZPT33yD?=
 =?us-ascii?Q?L+8yZXkAo2W3AGHh2uskrurI3xFKyDwszJvzfolAdjq3pc7mTP6SnA3/osDM?=
 =?us-ascii?Q?g3+NGms8Hkh07aInnToFQQ33Wp6eQoaX0435EJlENSZb7Dw1I+LH10s5zxuy?=
 =?us-ascii?Q?K5z2S1dBb4pkmGp23uOF8aClYWm5ydL8ygzK31/sBg/Plzb1G6oGJ4zZ9EkE?=
 =?us-ascii?Q?SFjf9MT+82RRM8hjAXffW35AgPWUvGFLCnxJPA0yQtYBXCJD6xXjCWulcY0a?=
 =?us-ascii?Q?y8tgvuo8b5NFuKXQky6MTr2LsJ+TdIEs7uxxRHVc+Mf/JwnMsASXgKLN/X+n?=
 =?us-ascii?Q?zHUyU6moHQ+0KfSQbAzwOhr3yYb7J4ty0ALeJ/M3ru6eRqD+400Z1yJK82z9?=
 =?us-ascii?Q?Nh1oW7UsxYW/1vA8hXUBh13wOQg5zeq21OADXByUtXbF/E2rYYth5nJXNp5x?=
 =?us-ascii?Q?8Nji4W/2pq4gB7vlkR2aVmbQPENISclJ9RRLTosVSUIgfFsaUb/QPmSy4/Mv?=
 =?us-ascii?Q?qgCBE72EhzcY4D9Oh20q4OhtqejakVD99DNtEZlV78J2vZAN56bM+jVWybr5?=
 =?us-ascii?Q?KsjT5br3cBOaQsgP3neOWxHy+hhLUNnsj13ts+HdxetmnNWLLw8J60nqJNeU?=
 =?us-ascii?Q?iYaA/rKCU2yRAbdmk4i+yyTHmLe10FkwfyvYg5fID+m+ci33cwJ4EimjdVeZ?=
 =?us-ascii?Q?ws1xDKwn8nSUuouNXOsgaLCS6EiBKaHekvW6lrOmwcEfeLjKtm81zgHk65m+?=
 =?us-ascii?Q?Hrj8c6VWCiUCVhq3HjOCJWLENkUUY/ZmOlN/bb/gIFGKEtlpufPNW2Fw35/y?=
 =?us-ascii?Q?iEFqn6BwHERF1N/4v4Ss1pu4ZNvnX3pCxDN1V4FT3t7Q4S1t+IQ4UsiEWLTp?=
 =?us-ascii?Q?NaBiFeWuAwmiPcnhFjMlIXSUm4g+1gdlQuHuliVPj6D0WkgYHdyHGAhkK8mK?=
 =?us-ascii?Q?lq2qt2M/nFCQayZ+1KCdTl7Pus9xBHSHHUzd6VXHxIILRelHUTxKPh2nYSCh?=
 =?us-ascii?Q?eothc4KUENXWzAqG8ebnOkz7fDHuiB+lPsom4VMXdn7NFViJjufeFtxL1yg2?=
 =?us-ascii?Q?0KYDyHs19g7GPaafArCaX4sKW0G+21od4+2taqmBjjpV7I92mtX1zG6CNL7A?=
 =?us-ascii?Q?/wKrnLItspgdlKQ1vu2mOmN+UKi/9Hw62QRdyc/ayzhf17sdchdNw4OTBDHp?=
 =?us-ascii?Q?gSiYdF+vhf/IkINQZVGqvVnhW5j9nSGi1W9yEQCXDZXl9JnasVhrrcE8vnqs?=
 =?us-ascii?Q?uy485wbWTMZHem6xvWax69bLUt+VKSyL0FI3rYV8d5Qtp5VlI8hYB1jHrBna?=
 =?us-ascii?Q?h12myRnyMWtGcHveh8Q8/qccy+GxRMJ0Hu74QIJVuceCMzmL9cJE0ZS/lTCk?=
 =?us-ascii?Q?rTwhWjqFdazyg+TyGiSCXIGSXAANn6wuHMxrEnon?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vjmfHUgJ0Nk+fJYnuOdRBrbj7IUm37X2BkKlsZ6Jw0ceU1AJxJCVJ/XV4M19fSaSUpH3J50ofy9OnpzzjA1nG3lPLJUUQXcM8xKc13cL3DbtdTkVnPQc4Dyj97dI4J3AgiPH6HZp0Ktb5wVKF0QyJrfvZucyp5c1YP899fJIMRK8zIFfimkGLZM5Hs73njlLwEiXnAuwN6j4i4qs/8yiYakaROxvdkZMtNH3LKJi5UvSKStFH+hoMRp4RqCA2hZY0XgeYlEzemMp3mu0L8odNlw85gw7f4KkAUu1U01BxiuiInCyIBM7rt3woH3kxwW3OVOxzIcuWMwesGf2Jbgdkz+WpbM8myTlR2isYmF0+91P7zi/i0HiVNC0KnNE1SoNFEQPmsb+ksiwfHIdAzwyfTIn+QBoMVSpMXOZFZSzn2bLOaOUQVoqcVNUByn6Qyn47YccVPp6+Irbiahvj/g6slVJym0Kvk78OKCy/000+HAcrYXqa3kRxDjE4oXPGP8bSobD73bxKAyirascgIK9k+cL6KK6gL2g5Ci4SF12IC2ImuFWOVpTyd/CCktd1Mxsy5pfb4ur4K/Hwuist6ZqwqtBWlz0PmpNdPb8Fq+n74g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5d2986-5430-4653-6357-08de15ecf125
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:40:53.6474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Gz9oAu41h+Guv1jdMSKzp83C2GWLuA/f2P4PnKFwnY6aI+/gGYiRnr7cH0miI8EgeUz2fIeDXRxoGWD365zzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=927 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280055
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=6900657f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=FEHSA9HeiVL-lX7-fHYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12124
X-Proofpoint-GUID: O8Y8RSdvE-Rmnx55CQebfzie0OtjLNl1
X-Proofpoint-ORIG-GUID: O8Y8RSdvE-Rmnx55CQebfzie0OtjLNl1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfXxgMdd+An95/5
 pYOLFfq3QRPOwU0aQQKK468CswbstBY1WWV5SBmo93pBaqKP2ZpAD9u7WGZ0D8oAbuHOfzPknJS
 tMhpxEW4hAK0QNb4psvfvuDOB8HhbFL5MbvRvd/iT4Ffjj87FA+Nu6AFAoLNxwETXxMpm8C9lZb
 SZ4zKB8qoq7zsaBWfnHNvrq3DBLZmRimo42WxqVYYFnfG66iKoo/b6te7+/Bt0jN3owf6c/GnBQ
 B4xOs9kFXu/IbbRc9fu82HT26RlD4hJsUUjzSB+rnW4GunkFNTEPTkxqpLrhWZ9ZLDkOuqYUC6Q
 chjEks53DiGGSlh2CzclGg4Rq34guFBSX3LJIQWLomEEUhoXg8zYB3JLn8xamQm61sGqb78X28D
 luXB/EcRtHwXzIxvRwNMn/3RoiBqAufYRnReYLXNpm0Xa6TPKak=
X-Rspamd-Server: rspam01
X-Stat-Signature: k51zjea435ihqehnbax8c13qkho4o8g6
X-Rspam-User: 
X-Rspamd-Queue-Id: EC20F20005
X-HE-Tag: 1761633673-69210
X-HE-Meta: U2FsdGVkX1/CUB6qA0x69RX7Ci84+Qt0roYwPiUG6wxAmPn8qFelTNvUcn7gFETVcRf4tV+FZSsJomG1en7jKoIHLkUx5oApJZE3LT1i/k53LiGazTI24brH9AA+eAfEQrH5U9l2nPdmn2xShI7QKp5sv7nOWbbLcpg2I3tSZ1Stz4Y8IxkgtSJH8yBnplIGmvyJgk1VBQv6HgMcHSCcRxJUetdQy1jLe8mMH++zC8WN6MN/EzzwC0SJVicHKEGwR9NthD0XJBnhRLNb6Lybqkl1u3CJlWS+RepGTTxlaO6ASFfxC0iOewXdb7+5qsq5jtSEi/sDo8pjxbKJgcRVq17FZcAl/emNQFO75GVssURFCzVIJLTH06XDoWDGAKNaJnPpSwjsz6dc4s5AZlXCsrfmxS8UedzxRmtXJZzqXHKA0z0lCfDJAnzbtAQXtePHpzHyp31ENiRrELufUvdj8VPzsRYaADb3uaisTZr3MQSb2O3+yLtTRlxNG24iUh8Xr7iFDJJT7llHIiQHxPU9mlamdTRExH4rwYP7icj6DK8IBBnWfYQmaGkHZnNVO/tG8QmTm1MQNtn6kVkgmMdB4u1Sheid+4Or+cvvH7d0Ma9fRsFvUkEa7kfDA0hCtIfflRA9Pgw+or3SEI0tpKREY98sIeWOqLCwOh4ReSNpuX0xowLiv8wsXx90WufRoNP8bsohyGc28dbY9q40i8PfIr/qGS1p0S1fDqibARqtLEd9yKt3XqGyv2KvY9poFK3aupNJI6B0lPC+SmNWQC4npm6kjMRETwbolRjWfbY2yoGjyq4mcaReJYCPk8kP764t+BANTk6iNNgys/gdltoJd+KaD0luNUthQYE8M78L+ne1FWaPrz+/EXIFr1aeLGfH0gLjwQaSznktpwcf30+5U2Udl9A6FF2FRWJRs9uvGt/YUWh7xOReLIU0vN+qHrV6yPx2n7vA8U1p5BzOe+T
 AlbqTy8v
 wmY81tDvyqtRR/E9esmyTD9lHaD/mIM6ZWViROo/3N4HJBSXpQhkrzBHzxkK/tdixFQ3cqSsno0dEqgoJKiTWbp7swuJPHkn2nudfecN1PN8vtj40RJ8ZWoWcZnkauEhzw5hqFGrQDaLbv2GUbgEPhLgtT/xBngl6SGU7Ps7pNAHQHiGqVNDCXDCYWhQCuhUrTSip4xlx4tdBxU8QvnxFSqa4ymH+XvTHLgcboIAUBrDM6QguV8I/5ADTdp/jJv5eeYuPqixVTwY8sIRaYjRTCZ02L2UZPUNtQEQTI4LF27DPgJSzKxW47FjEr2eYzVS+H1SVFFruXGzV9yNdKYSgEdxc+JdEVX/jirCZhN+9+DLoUOqnenZqe9CP5rgsfWCIt/1qRk+dp7+6dq+71tPRqTiN7NRDg3qFLlAgjgSpyrLo0KM35XxOsgwlmBriHKYl6ZRB6NHEe+M9Z9S4275OmdoIWlLY9kVkhY2BAVRPJzypHOW+wXyYpkH+EobxCdtiTSZr+TLSDcNdGZq1IpOrtyBg+Ss8Vz/DmWyHtr6NhBHVpE3QXtOJxqioH8lWgIOHqGOy2LMxl/e8U5won+/zwDK6iOgayjcJzBQFdK97vRiGgCigG5OEe2FWcPz7QzJkvbOHVtmZwn7AGj6YFzl5H+F9MZz1b20yl1Bx5kLSXBhzrhEGus5EJM9OM/zzri4AD7wXl3CjilQp8j8+x213HnsQqjBaFIKwKSYTKqQLSM7nvN3wKyfNFCgjiomq4wAkUwTtfFs994dp4PpyC2ufwzEJXHigmZD1BHbU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:44:18PM +0100, Matthew Wilcox (Oracle) wrote:
> This allows us to skip the compound_head() call for large kmalloc
> objects as the virt_to_page() call will always give us the head page
> for the large kmalloc case.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

