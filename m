Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCD5E9B252
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7206B008C; Tue, 24 Feb 2026 06:43:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC786B0092; Tue, 24 Feb 2026 06:43:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB75A6B0095; Tue, 24 Feb 2026 06:43:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5E746B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:43:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 502C113AE9D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:43:56 +0000 (UTC)
X-FDA: 84479166072.06.88C7F82
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB1F2120009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:43:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OPI+CmSs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="AwHejz/z";
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771933433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htRm2XmmivAqNRg6vcp+zNUM8KcZ6pQ9cHT+yhQkuzQ=;
	b=B033WK++IVuumYfnaRneANUNoUVLI17qyFBwYNWFiqQZrOYjwvmG+8391r0Cgt0SLlnAAk
	63HHR1X1S40BzRn1ss1jOcz8ZsnPd9FMvOaKcAvdxvwa9myLNnGeFgKyVddTaHVtlYm856
	Kh8qM8AruPgXo6f3Md/YvyFbSB9A2vA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OPI+CmSs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="AwHejz/z";
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771933433; a=rsa-sha256;
	cv=pass;
	b=XWnJ0PF79s3vGmM9rj8g76GX6SZq8LA6EBVHG8RgZuvon5P9cdIoHaNQMWQRKbiKg4oRHA
	YQYnl0tP9QWDq3osTz1Yfn/L2889h33qk/6Unb+QqiGS23AmQ6EUI9rACP+ekaxAX5Qmb/
	8h+olKPchTl2L8Jl9RtRDjzL2Qaq3YM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61O1JL153174594;
	Tue, 24 Feb 2026 11:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=htRm2XmmivAqNRg6vc
	p+zNUM8KcZ6pQ9cHT+yhQkuzQ=; b=OPI+CmSsBlsPJVeKINNmGZeppEpohaU02i
	hfsZq4PuIpjgGCDsOfsff/3x1fVH2zk0Hk5/0hZxwa5I0vyMUpz09DUbZw7mLxyl
	6NqwiCIsUIMt9+tp4td2hnkzYfJC6KbYJVM3CX+2tEIBDehfSlmj04N/Pp7DLUkX
	Pkev2VMyceM0Fkb2QcI8e/SMVjf0qq4zK7tMoEIJLeXdFOVdjvHjwDHaZs+/BOEl
	lRT1NIlAO+bLtoX27be+bv3sJ9SfatRFuu3TFv2BUyNrKv9Ulk440bYhsOd4EZYM
	qBktZqa0Zvr/JaIlKZ+CYPiVRkiM7SOIS7w66ClLNkYt7kGmyXVw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b43h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:43:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O9wMvk038444;
	Tue, 24 Feb 2026 11:43:45 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013009.outbound.protection.outlook.com [40.93.196.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35kuy5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:43:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERgUvjNLJk9so86XjKkKvpX17m+TfuVg9fHUFd9QD0nXd85KL1d3pWIP3O2VwSpqlgGUogEijIQai+yklW+YYQMMAmbmbAFNQl+MPV/nBhXOcJA04OSD/uMnGAN21Nmg83xSHctRtEecZQ4dK3lwt0dzQyFqj3SHsxT4e8XYjWGITQGuioHIZCIcXEdZ6dD82evUxw7J/DAbpCZgmLa8kLJ7DHwZR2z/lieBkzx+sSH02RvNcFQwW+s3F/ozfWYuL8DHiQPfZcaAth4JrOXa/IotIWOglxqsj4PQ1v95w+X2zGGupSuN7gaI/BSFJdo/OVjfZ2wxHgspgpVRonI8yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htRm2XmmivAqNRg6vcp+zNUM8KcZ6pQ9cHT+yhQkuzQ=;
 b=Kf+tR3UrX7LtvWQBboARwSyR+CoaCZ7/hOrUrCsDwNUbbc8CoBA28BWSwtpHWAOc/UuzHc8UFy3SMeM9YqXJurQKrS7w24+LvWuhX4O14OYeORSmfq/f3sDK7ncMyYzpOqec99uU609Y6h1UMoZQGPTfsAWCExXoIFZ/X338FoRrTRa5LK4x6EmyIGB5Q8bl9cHwO1yPb/y9jbjbXub8Xkv5CwnK6Mz/ig9FthQAjlsgKrwjwqzPNdXsthPVWDciFuaPqB7E3lBoVB2beIQGTyQY5ogenMa8fsiDMpfpVp0gMZF0ilh8g19z7hg7E5Gm/X23Idsklx3CJkPsNfrljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htRm2XmmivAqNRg6vcp+zNUM8KcZ6pQ9cHT+yhQkuzQ=;
 b=AwHejz/zravn4ZqKMbLJmdheJZAHZqz7VLUlCXnQIX2h7D+q3ZxhDv6QMtYqwLHnpZNvSwGSr8KAeyT1K4zRiqexJlsWv/kQddcdwJnpnm5g9QsPDOeQlKHNCHaopf2VYvbQRhsknHby0X0iBtSOqEjW7ue8YBtzmNqLUD0qOFc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6178.namprd10.prod.outlook.com (2603:10b6:510:1f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 11:43:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 11:43:42 +0000
Date: Tue, 24 Feb 2026 11:43:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
        jannh@google.com, baohua@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
Message-ID: <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
References: <20260224110934.881360-1-dev.jain@arm.com>
 <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
X-ClientProxiedBy: AM9P195CA0012.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d32304d-6089-4bb2-ef26-08de7399f5bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HrWSVzSnsE17xrhtxoujgcTbcUgnT46cxPgNi7IJy2MoVCUevlUGd8sfzVC1?=
 =?us-ascii?Q?dpX/263ynL4wIpTQu3x2bhm8rNH6PmR6pzsy4koQCao5lZAsSU2BRTMChk4q?=
 =?us-ascii?Q?3TAJpcvY2oRnS147TAYepilKvoJfpi/ym20a+t870el3SoFOxu3bnlXZAL6+?=
 =?us-ascii?Q?6FZbmDNitWIBGd1iKAnqQ7WLUgLntrzoc/z6M8W8n0R0EycTfyingr5lANSW?=
 =?us-ascii?Q?VEI8JuDUOBUcg851OdKpn3W0jjBT9dOZefv8Kyqx5NWYpCBmIzxatNcBaaIF?=
 =?us-ascii?Q?nn4z34A57PlNJCFkAF/gHX2j0jqKSeFiVN4EqC4X1MbMixbkZ4u4yTW3j5yO?=
 =?us-ascii?Q?KFFRL5NAdQKAhYRhjwpmzliCdPKKlj7JgA7jzrqbzw/k1NWYqmeiIB0r3iSt?=
 =?us-ascii?Q?dtcrf3PENGkaNcYse+5yZR4bo8LN7lN0hoSRTblQZjBooCrlQGXS8LBV6AVB?=
 =?us-ascii?Q?RqZBvX0VImNFHZg17elXLhJZxLMfmMTZaj+vSF/G5HHtCgQzDJcLy5C6+yU0?=
 =?us-ascii?Q?XVxeQgZSclR5MlhDPA+wXRSJAtSLc8DvP03zu4EzF9e6iBGu6m2b0J8sYPZL?=
 =?us-ascii?Q?KOx9ke1tbB/obBvtunkzeXt/HDdiftXPWcf54/fWoObM4V7X1E1eGdk2NObJ?=
 =?us-ascii?Q?8AHwhk/rQnNh2xJX+ryQGWePiQpVnXQ4O9a25HE6dOt9Bq55Lt6NtRzANgWm?=
 =?us-ascii?Q?GsXqx21m8pA5Gu845v21l4nyuB3MwIEgfGA3oESz1iWNYdCFjdJfej0g8gXg?=
 =?us-ascii?Q?RqSW8KW6Ys0RhboW1VJXfygJDPwLRpYjCDjJW5ywRj2oTNJnWYG7MfCz4cfv?=
 =?us-ascii?Q?CATVEyxmjF6+Z8hivz43Day+6VwLpAFDlU2A1BbZSaSPO5di0i9dCPLRQgLJ?=
 =?us-ascii?Q?jOrFAMC2gJPgWsCgE5fgZzD6ThiwOTq9hnfOjjZdZk+zkWUisHu7gyNOXM91?=
 =?us-ascii?Q?/UAIy/olXrPl26WQx4TgpET2uy4BmxnUmL9rp2+S4XQHZjS/qIonC8CI49iv?=
 =?us-ascii?Q?1+YEC9S4RfX4o0vMo2NP5c0PCDeMvNEw/mfm2Qpdt02Z/ypo6xa5JrbEfNJy?=
 =?us-ascii?Q?IC8oXFqb5ONBXhNm7smilWBsgPL+O7gh1qe0Mztd2W5duML+4wJDUVACXk2k?=
 =?us-ascii?Q?q9cTgzYaAr9R3U/P6+l4mSxRU5yzXG0A8mjzNsMm+Pjgf9Vi5FFJNMfYHQ8w?=
 =?us-ascii?Q?xTFajSE6SLUclz4AUfEMKkl8eFLjQyV5SUHcF2zTZgz/AGHloibpv1chDrbK?=
 =?us-ascii?Q?CUq11ZGppBz0MaKecvmS5ge8HZVEj0egmcD2PFLr/8ZUe+eFvAkuS8nI4WC3?=
 =?us-ascii?Q?LOZyXjpUxhai8lS//J5zTuEHIjmewFUjUc/n2kcaOS8yzh8YYD+ss6w1Pz62?=
 =?us-ascii?Q?RJ6bxF4joTll1341+WkdExLa0J8tP8RrEVzWfZIQQB1wsP4JNuBjgP2eH8kB?=
 =?us-ascii?Q?aH7BlPHV5Pogi3l5vkn3DxIUMn0ngTgDR8gjFm7kGnwJw3YihjUs2+8S8UMh?=
 =?us-ascii?Q?r09fi4LDP0eQLrIbFurE/P1/vef/May74+XSLwofv6LA5ShvrXYyXvFAuWKR?=
 =?us-ascii?Q?3O2xm/SR/Uojh2GabXM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ctR4J61Gz0qpBNW5+Ut7dFjZxu6/0wC8gqe3/2Whckcl9JQLhd/3cMInidb1?=
 =?us-ascii?Q?XstGlKjcnoeILPY3cAjxzZ3nj4rTq91LM/HXoY0vAu0CfjtX/G0HZ9KjLmaP?=
 =?us-ascii?Q?/t4TiVvE+B3LNeN41FfRz6J8JfCkCoNheaIasu/u8m6jSSF2BNYm3IbmapNK?=
 =?us-ascii?Q?WEWARgtUc+SpGscgL9J4rLhpdLGNVtHq/gRVbKjf6sYn5INx0oeRyBwHPldK?=
 =?us-ascii?Q?EQOuAVQiQoEFRZPJLLKYX9PXpWsU/zv8lkcCUKbQE4v9a4rB1fm4bLVtKAgp?=
 =?us-ascii?Q?22W7J+CPZPBvYtdc+qolC9FPaRBT01hH+fqthy3tYAojMIthrB1c8Ot88ZJa?=
 =?us-ascii?Q?JH9koYbMx7E6HRLuU8E2Yjq2bSqyk9ZzaqR3MbiwBNv8/am51F91IvBq4tME?=
 =?us-ascii?Q?vLfgcGCOIrpMeydkQ6hKIfi/sMrm5vbcZJD6hTUiYn1RBIUwEMIX0cJ2QL1T?=
 =?us-ascii?Q?4MfOQOfRGJt2MVDkcxMvyEVP+PkVQb31upRhFMDUaS0WY2ND+m2CV0w/Ktv8?=
 =?us-ascii?Q?re6uyAhzqnG9vb1TBq68Phj88gMcyYw9vAKcaNwF7fCovPrSFsu9NItdXm4X?=
 =?us-ascii?Q?z/oFO1ZG0PqeOkiHSFiDlgVgxtpe8HDGHk6JmYdA9ZZ029R33yo5msaQeQeO?=
 =?us-ascii?Q?I6llHNBKHx4/lZW88R8uImH44cBIPHj22OdhrAzbzUu/WoZlkynsdAvq9cpO?=
 =?us-ascii?Q?hlCMgQNuSFLL1dJB73jr6I6GptagSMlV/A5PHBmmPinm7zapDQOB1psSYRqS?=
 =?us-ascii?Q?q8Y5S/UD66mcQK1TYKElJ1js+/+JHmdoog9sXNfIzTF2nM+qDJzHC0aMCwaQ?=
 =?us-ascii?Q?K3/dQToiqi/rIpcQznJifm14IP5cGn3f9CuBdKo5r0FQXMC/KQRxPAAUCaJg?=
 =?us-ascii?Q?e5dnsvNCv2sPQGDsUzh27qEGT1+3Ivh6s4hSu6QS4q1yge1pzIEmgVsz4w/H?=
 =?us-ascii?Q?x8saj/wXowEUyKJdqoUoW/DgqgMFVuN5OseOZ9hlJvVC5HngFDVKHcketaXu?=
 =?us-ascii?Q?2G7twRqvgQy8yLvO3Ig69RTM7QmU2iqI+vIYtFSGS+PmHzeeiEU0VnRr+Xs6?=
 =?us-ascii?Q?d4Ly3RB5DNlw0yJVwZJQOU/jINH2NSQKH1aJC0dd010JT8nDgYO2PqxkF+ri?=
 =?us-ascii?Q?/Y28gbQ+MgzRRBdChMVJTxfbU6PsWx2cIY5+j1xc9QL9O5Ivrp3Xjamd0YwG?=
 =?us-ascii?Q?9BHQClzyOkems/DFjL/5LEuXZk7RUdvLz0nlWPg4ac9XpaiXpZJ1zl0mB292?=
 =?us-ascii?Q?zqiu7PFVpBkC62oVxpDpvIwtR2a6OBYAIHq0r4sYSc4XNKzno6/OcWWPjP5i?=
 =?us-ascii?Q?XzHrxdFjTqCEAu2/3jRGwOyVEj4awsq3K4WIDKUWrly4FVwTirPgVFwBZNjd?=
 =?us-ascii?Q?Cxnp9lUPn+TMsicNKrg0JeJoEK1CeTrVEt85qSXPSjxF04YYdW9i4NVDtSX9?=
 =?us-ascii?Q?XXpa+SB0xEIwS/jbfYhvKskctB0tB77y/sY4RhLHBbgSXCDGFg0pnNkCvTCN?=
 =?us-ascii?Q?ntlCBjag3MDKiMrxblVhiuFbsAo7MXuA3+MljdNW0fhacehzPSbp2CVX4hoq?=
 =?us-ascii?Q?fzh6rOwM/1/8o5BDBRYTdbwTytVyumMsnVROtBr1QeaaSW7I1u+nNJCoAjJF?=
 =?us-ascii?Q?C8sHnM0VY8I2xfAWL9JMrYAeU3tA56WJUx7MNoeZbYXYhlo7Eov306RqAUDn?=
 =?us-ascii?Q?dNp57VuGnNuVcFoosv+KVIOr5sB0vzqhE4lsM9799Em5t6Y/tUn7fkc6mdct?=
 =?us-ascii?Q?TtvfdP9JSh2hX91DpacM2foBZcEJ+uA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sH1M8NUEY7VZiWSpNY/kFU7jgzAsWoZlH0J9CaIZjCj7QyL6fRtn11aL3wS3yzp7gLhcrrglxYJyNVv1Ifr80592jTDtNWR9BVk+QL98pqHQPFNqMsbPMROL/+uRqjLBdPWaSQXi9CO8HCz0BQqELI6XjQdfqTIZfWYgZcO8AHISAdFXZ5VO5wd9OnsEWOIWYuT41S3JaZ7k4hzF2DcTnsVuljCWjqbGZXV09FleL728m1LHBs9r4h27TDX3JWOGoMUF72A+gnN1RHpLAHjFSUR2hgqTFm1VIPjVwYutb7bYoPFgf91ISFmIS6+UlCnEyNSkDkeBj7+ZB8Vr9t9h8YgGtn+Yl56JHK+dmJ8ppZE5KXE5YFXeunlDsBHRhFMR7leX0amcmUx/0xgSyiMidJvoQNbEKBfa87hb7YgJ3iwS3GjrJ3m9/IMy51BnhZvHCFSmuHoomvpeSEuVsFm7klSDBsEJ7LIDamNLmCdFUgOE9C0PN3IviEgdT5jAQhVaf+h2KDHvBCycpWCd6oiPAbfV9GxjZZT5TsvJkoLy4DtRSWQwUKgxEEBOig8UZTYKAPzpIoKGsnWsViTrPXSM29eKrrMXGaZkNEdMAtKkSls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d32304d-6089-4bb2-ef26-08de7399f5bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 11:43:42.4343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qozgj8vjW+MgpUL75hjA5NIEk/3Xy9iDZ7C7EksVTcZddAusSyP49A/GlpNy54s0g0A0Qx6hp4UPnGoUaZuI2fyB9pUKtD+7gJLfx7Y7c5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=889
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240094
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699d8ef2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=4I2BC_AwkSKamAEvIX8A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: KTeXIDfI9UcBV5VrNGi1rVBm9MsdpaAw
X-Proofpoint-GUID: KTeXIDfI9UcBV5VrNGi1rVBm9MsdpaAw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA5NCBTYWx0ZWRfX3DyESD3R7CPP
 cJci2ZO+LwmS4T9kzo9msQV87pkohld5J0MtHURtNe1rcBjGO8HYZsh1GxXTbqge19XfCWTqtw1
 X2KfBxxLwZN4hW273znPuf4NXtoQjfj9LOkf8AY4ZN0ez9le7k/Q/ivmtqEQDh3aUdiK1Q3l55j
 9YTyLymGHJsKOwLrGfoYLnH1AcTuN0V8c4YHYiHmRCGfHuvr+GpKCJTPPC7O3IG8wPS2h3HjTBf
 fJ5sJawWjRxNhWX41JK5dXYigxAbAGh9QXryg09PYNfQMR+tTIorTenfJ5BwlJFnquT3AsisNEc
 eCWbUfkJ/beOFU0k4Anzx/1ZH7kY0TG+R6BkKVKu93llF5srUr0sIP53jiKiP87OiEYGIpe3Udk
 dTKGjde24zA4VK7F0Kc/7Y/rd3d2x0BtpROuwbV8YeXVqfLfRcB6DJ6d2ojO1cxgKa6HVjQqPVX
 CJzxeGBnT7ODkYXgNpWthC09gzMSdFTrYcoeb/UE=
X-Stat-Signature: 7r4bd66jid5caedknb78bwrpu18wwgta
X-Rspam-User: 
X-Rspamd-Queue-Id: EB1F2120009
X-Rspamd-Server: rspam01
X-HE-Tag: 1771933432-705389
X-HE-Meta: U2FsdGVkX1/PC+eIt0w95w/HjTZl0SPu5fDzAZGedZVOH0O4Dje+UGErDU+OQbsmTNI+cyFCXcwrn2uCDjIW1rYWXKP1TRN0ZcyTRPbgqPvPNM4tYbbmPNp/yt7QBuXDMW3bZJLvCxT4gwtRxv8wrEnoe63jxxNpIoyU+mM9jDnewx/iVxb7QpUFrgu2knAE0d8/ceFTnOsXxdlW6p8ZD9jzJ+1M4d+XJY0WwOBxPvkHHqVDwsCXqMQvJrl/zpKJCoYYOz6mu8FaKW0JXiHuaWgipbI6RtYLpcsaKXOaXDDGFHzgEt1/FFZrMjw25b2BGdj4fWBTGRIggux96J4fnW+I/04d570ZlWaCWx+ZqYpOw5a0tOKsO/cQQsta7W0ipfKiGvLUIeF/n2tDJ/mMsH7sKuFAbRZaG1WLX+EXaXPzbLyIZ8LD5YRTI8kR9XVifI5NfGqWdTWSD4VOxrlXgLm8PqhBjUm7Sl/hvXzR4StZPKjGrnIHFzzS9Z2YVxuIdyVxs5/zsWPLX3QbIBUzOzZe0SQHSfSqhsdNDdYOYcBiDqCnS6cPd+r74kHMpxqKSfN6D8L7oya6aMRXW0GK9STo/rm0cDrRnIcVAybHjVeikAfpRcTDOUbiv69UUuanw5ShNE16d2EAYG+K2PRAwOnag+M4UIxDNG2DsHOTRBfZRxNR7FKOsV/6ir/dwgVHynkTPAbj9Ulkr4ikFzyLbF7L0q6FFoIS2b0qLRjXgFTzJZo3I9Pqa2kYS4HxGLhHxKkxzLxR9XeDiXpd29wMCCZtoon4+tD07eVl9ds6Um8dcPToflmL4OkdeamYr9C1a0rXZDOkZNWj6+ayMUuJ8vl8r7Z/y+Tmp9HBR/4+03JWsvqFiq1Ytp9wuja+5OzbdIVMwjTttvw+cNOPdV0yUepXkGThB9OwXELArA4plOfo78BFVR/5+jKQbBQYv8akuuXZrY54wnIJqYjsd9b
 49B7y0Cw
 XsqvfwYxZ5iLbQ4Gv6t5ic/ZZ1jkynDxf7OeBUlZ5QHD/Y4uYZqy271/ZYtb2esGJLAYeLGagLIBooipun6xLAXTaPEvIXiiZlY2e6gzFVGCUetjHRTV+CQMPMw6k0J9wcb3KSGl+Z+xkJyHCdCGeD2U5JNBXXSXYE+206ZxPnFpXRkbXUj9GF2riy0tF5hKghTgiMtHooOOsMlaw/jzcLa2GKZ3CcS1uTZtGUYKJche7LYq/4m4VH/Cn3P71zlI/ChjadKNP+4O1UdbrUzD3liaftzJc2dvPslM/vT+Mq9WVwHXCOPOSurH1YqXEnOWeb8JJfcARQktIRaT/bpg6C/6EtGrFPkgLckKzYfeXieKW+4/cBimursAadgJFNaF7nBYpCRaeJywFj4A2a15cA2bXAUCKkc4iItLVWHgZniJ6wUhCnijXndPZmaDDrx82ur0gjld4sAz7k1WyFCbECFeUNLdZbwDJgNT7LUngrV80WJGx7jjDeXQMHLFPHZQd4QjDryw0A+rCdfMj9ElF6IRM64ABvkIW9Nzt56GAjq8UV/c8dZGRmLBhLLM1ij7pmMNqHBHW9pBvMMACIPXBIubpzc+nIDZltzGIlZqiX85PBr7Us+sdnkv38BhoaznYoh39PA+9g2H0XmXT1YGTJZUlXyILi6sse1A+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:31:24AM +0000, Lorenzo Stoakes wrote:
> Thanks Dev.
>
> Andrew - why was commit 354dffd29575 ("mm: support batched unmap for lazyfree
> large folios during reclamation") merged?
>
> It had enormous amounts of review commentary at
> https://lore.kernel.org/all/146b4cb1-aa1e-4519-9e03-f98cfb1135d2@redhat.com/ and
> no tags, this should be a signal to wait for a respin _at least_, and really if
> late in cycle suggests it should wait a cycle.
>
> I've said going forward I'm going to check THP series for tags and if not
> present NAK if they hit mm-stable, I guess I'll extend that to rmap also.

Sorry I misread the original mail rushing through this is old... so this is less
pressing than I thought (for some reason I thought it was merged last cycle...!)
but it's a good example of how stuff can go unnoticed for a while.

In that case maybe a revert is a bit much and we just want the simplest possible
fix for backporting.

But is the proposed 'just assume wrprotect' sensible? David?

Thanks, Lorenzo

