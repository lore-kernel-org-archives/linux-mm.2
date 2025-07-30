Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708F9C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 15:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9F86B0088; Wed, 30 Jul 2025 11:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1546B0092; Wed, 30 Jul 2025 11:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1F86B0093; Wed, 30 Jul 2025 11:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA9696B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:17:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51312C04BD
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:17:53 +0000 (UTC)
X-FDA: 83721286026.30.7FC653D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5BC71C0013
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:17:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E110xJtn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=otVfHUFt;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753888670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1PLhr0GWqpiJU7joFgsvkYljYGmclGzq0YR8q0uy5Q=;
	b=4sNz4gMxHWXp3xdJ3cWb7tu+WYjRHFZhpfvsuaWyDw3ZgBJRbnTHSME5f/Xy3/Ldv181pB
	XOMVdUD6oo2tLeAeCV8UXhKGQrytvx4n0bY0L6osgfzTv+P2/qdhM3KwWD0XzTQ/lfGcsA
	npSG4RmKPuqf4xJ9deh6MIbrmKKg7Wg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E110xJtn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=otVfHUFt;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753888670; a=rsa-sha256;
	cv=pass;
	b=RxKa1ntZP3a70CJAfQo3qn6aUzVhJgwBCVmrbYChnsDkqenhQrJfKhR++16c9GzUz08YPK
	VIfmq4a0W6LUnnqkUYfu7U2wb4pWvLaBvRouTotLbENodkJsZRRMzxwO+s1P4uLoM4mPqn
	qxbpjfSnLT463iJhNny1+7nkAvZSLDU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56UDMplG006924;
	Wed, 30 Jul 2025 15:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=J1PLhr0GWqpiJU7joF
	gsvkYljYGmclGzq0YR8q0uy5Q=; b=E110xJtn6xq3KRScdJ80uPVad8Zp6F8c12
	gXVRxHsoM3Jb7CRqRHSX/a2i9aWj/O6VPUCqRtpk64AjUQpgAKun3bL1JqzAm1wQ
	WfCGupXP+ueJntnZRHLmPoK/SgGQXlTCOBpVm00+8RsoqRohG3ESJJKVVnxN0RVc
	Het8/Vmu+ihV9JtTUnyxyp+SQHDvDDav2g/QDX92xZg6RN5S/kNX47huvvTpags7
	jgkxEk3jv1uKkeaYULcRTay4ViJc1e8PnVVN7mSfdr9C2TtC+vZefZh+I5Iwau/C
	JpVkcD+ow+tu/vuaY5WoRsmV4rKbsHdRWsX+Q5mO1Bc+1LR+RJLg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q7326h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 15:17:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UEtdGb038608;
	Wed, 30 Jul 2025 15:17:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfb39hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 15:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIPjqRfISntBE+hJear/zH4LeyNa6H/idrGp49hgf/yPjdOBlRlHr6LRUtR7zZBtS2i4sicWrtpfcd3G6np/DaAzdtVL2fwTnqcYQMFD6So+wYGxIqR2yjlotEo+rPG56/G+wIHomb5HUGx105YOsrt9Gn5RN2a7hb3a6vGM5A7k+fTk/SxKx4rTKqfKqTba3STQaw29OG57FmWmxdTFqHb0lTp8EaGaUbJp0o0GEFxcxDHmmkWSeOjUEmGVnv79nkf9Plnpi0ThibUlcu3H8v/NCbnL3s0Pa1PS8NUTcteyIdxFydieFizw2XDrPNKHH/WZ3k8OnIz5puiRVQX9vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1PLhr0GWqpiJU7joFgsvkYljYGmclGzq0YR8q0uy5Q=;
 b=Y0DupW1PC6GnY4pEA5q4CCAp+qa0Oqjwj4U4uk4sc6WwZWr2lwXMx/IJohJnInpky5+mwlNPgWbyqJVt3QCPfxB4VqROZNDEBZjQATNu1Q5HFyYqeEYsPzd2UqTkbWJgbON3VCV7XrBfzpuM4MbC/m4GoVjY6V2stJvcnp7MG3zqJlklLIxZpeIx1QW7L+Ed2TmJBSp6Q3rakt5onq0xjujLSMjzDRjr11NlcUJQ6OGacZp3KEhNnbXWuioVNv4nvNYQGwkcYi2fxXHLDHIuYEdjalmp7kl+A1UDt5m0ItWChNxSzdKYKQ0u9bsE4o+58nHpXvYhEkmKN+yjEMlabQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1PLhr0GWqpiJU7joFgsvkYljYGmclGzq0YR8q0uy5Q=;
 b=otVfHUFtKpiBAFiCz94uf/x/GBUcaaBkHB7fW27czukVhELYkTULfLEcmstFXMTEdp0G0m9sDl2QX48o+ugQefdXgqLjV4qzQ4xcK0ESGyBYX7TuZFAIIfUd3HQiidMpIcs0XI0CiVIhMcDHOOMcDfS41/MjN+yM0QfgjNhychQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Wed, 30 Jul
 2025 15:17:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 15:17:36 +0000
Date: Wed, 30 Jul 2025 16:17:31 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org,
        david@redhat.com, ziy@nvidia.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
Message-ID: <5578907d-3583-4a87-8b60-0cda0284a358@lucifer.local>
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: MM0P280CA0086.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: e013af47-40e5-4353-1678-08ddcf7c36d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?91VnOv4RJ63PcXJ5iXzmfvY31D4F2QRzv0X3maiZaotq8CfWUQ6I+c5zgwbI?=
 =?us-ascii?Q?p8l0NFaDyzal9TmxaddIbDO1SHYSRDrpM1s5/AAlxFUp9WeuNvJ/Ck5cjRXH?=
 =?us-ascii?Q?wUdQwxUeIo8ZCaLQ1+S6q1B5oHSVlwHzx+jBQdGVCdf/hgwqxxIzWFfUK146?=
 =?us-ascii?Q?A29ZBHZP5sGm0Ly8cFHo6pBEyldCH0KVws9tDW95MoruUBSXo/VWJAUEmd3I?=
 =?us-ascii?Q?UtYFgKBLMVObCTpHhdROf7V+zSw/NULnF4pwetZ3xICeTbDRwi66kRgHYCjW?=
 =?us-ascii?Q?lvIfcMuWjsa3z6j+nvzEkqJjxETplV5fl3l35I9/VqzQ+E92lL9Jik6xwmYu?=
 =?us-ascii?Q?V3LGkQuvybqTe1FPyayHWwjaMybnyaoBXFXuMQOPUJ5fzb1niypoZQjzs0T7?=
 =?us-ascii?Q?8HkCpJkiwM0GK2t7batKq5UTQUsH+P4z6AD2joHkrsr9J5AE6aqxsEsbmaaS?=
 =?us-ascii?Q?tInWTU1mkowuvdi3OGw+oEfhHQnHoY7oSCGCip0g2LaJJaUBVaJ/e12ELO87?=
 =?us-ascii?Q?XHh3xsVcrmWroqTcgZu47CyYmxWN1dLdXOr7THlcUrakYUgNDXL+b6hCTP8i?=
 =?us-ascii?Q?OM3lzQQ4iBA/tSX7eshv/B9da3X15aJEbH7Ka/g5Mau5/i92BRz5l9O2fWIQ?=
 =?us-ascii?Q?12noB33RHP1V+vH0iSItUqfX/kW2+KjBwKzubFJtG4xcstjl2o9OyOZAzLrS?=
 =?us-ascii?Q?I9Tp14qG0dkGrOl96ZF8jv863M1Gj8/f+F+cTLn+todBzRGThgVVXHWz2Jy8?=
 =?us-ascii?Q?FG4DBOwiho8E0Prde0fZ9acW3lB+1zDPAm1dDp68Wbym/0e7Iolp9R5ezpZS?=
 =?us-ascii?Q?CNcBI0oSfH0vHTKnMYXB7oMHrXP/nuXp4FKj6EkGInYK3reyjd1lEWeNX44F?=
 =?us-ascii?Q?Zmz6fh22PzV8c5FTCVTqx3w3Z0cWxSJXEClgD3rUWziUGJmFkEYzBKac2rJ9?=
 =?us-ascii?Q?ZsSxszvs0Hxng7ea0w9tbir84EwSZCp/vUWlPtb/aOUshn0QL3vbXeEMewid?=
 =?us-ascii?Q?p6DEaDeH7L+fBTZH8leXItzVF3zPgw9Qm+MCcxyLf2TIFaJxb4PuxeQWCJ0k?=
 =?us-ascii?Q?I7K3dOBXEaslB8yBxzfvWCJQFVbM/DNfbCjPdXIhHRXq0BJ6En/ogqqfIpne?=
 =?us-ascii?Q?sRlQj+UVv7AXnrGUddeCH2CI1dsl3aTjNuNtiOqjcrdp5J0v1PbJXqZrMlyn?=
 =?us-ascii?Q?AuonzCIk2LxqVBdFKH39nmWgX8eyO911DI++1i78DAkoCpCBO7Z6ZFvOB2Ku?=
 =?us-ascii?Q?2pnWLnQt5/XmBwpKuTckwFrq4kEsq2u/mUDd7gZTfegw6SOa4YdhIY/4MhK3?=
 =?us-ascii?Q?OaMYg26ewDbAPc9/XWzf9h/dL4hg5SP7p9Mbk4G+a3tClhYJvFZ8wuGBt6SK?=
 =?us-ascii?Q?f07KL/3AaRZVXNEJs0nWjCIw7m+41NcvNPTAtHyOFSSausLL63QKNWQQJrFB?=
 =?us-ascii?Q?RMU01OyTGJo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2kD2B1wEuxFNsAVuOZ5cLcSjw5LrWp+qKWXUUSzI06+P1Op6Vwsny03Y1ChW?=
 =?us-ascii?Q?6Ntyd3NbsmfD7VayxTrPKtDUcyo5tmTWL/jmE1vgJiVBlWgwFoA8qL7bQkQh?=
 =?us-ascii?Q?squa+5Up68I7SFh/Bv7L+rE78FWRE/0f0kkTYwlr7iflnx3qpcwXYliP7sfB?=
 =?us-ascii?Q?Su/4lU0U2aQdJ0OlUTiwjI3gxCCdkfETFKtA8Od4tudmvRKEcIlAgW9r7DXk?=
 =?us-ascii?Q?yTLrCCvWp+UVFRykbIeLogaACssBkIxl70vO13a1mxkwgviDSE9U2oeYfvx2?=
 =?us-ascii?Q?9OFdClfyQ9avSLhhd7Hy57aBLpic8lTX9GQw/b+6XciDWplEs649oZVdFGoy?=
 =?us-ascii?Q?cP8cJsqcpjRQfThhf/7L+UiCqZE3nScutXM123uJfwuC9sQK3F/jgxivAGxN?=
 =?us-ascii?Q?PjGtIIGvqbk27DMYArcmvNX3olzpOr2KsDISdlPtSu/xUNT060+eboQFfGjM?=
 =?us-ascii?Q?urmBDnM1QEh3vWUq2U2PDVer+DqDTWSbtRd85mDqXGcup7PPl+SP82vFIlog?=
 =?us-ascii?Q?Ay2OWV9bbPNxtIaJUmgQtDY2pXHwVFc+UykIIUa264CjjbRVn36xM6Lt4zkQ?=
 =?us-ascii?Q?R3Leg1oo+eADV2TOPLJom31QwoGYKYks6T3WirZkXygiubYmpw+VQmCdL+d1?=
 =?us-ascii?Q?sD2BPzMPxLn+pzWa5r3SnMHBARAvORElyt96Nv4LGcEMcHpzp+CrIcuw0xYB?=
 =?us-ascii?Q?x8j7REQrvKF2388f5EoTCTS4miFSKaWmMiLktCTOwYLSxKwwSR6h0T15sV+f?=
 =?us-ascii?Q?JYgrMnZN3Xh5Ye+f/cNlPQAyTNt1Fwlebup73m/QHsiHcNJgaV50JQJOLrYW?=
 =?us-ascii?Q?6Zx14JES3ZG2v1QiUZa9qpjboCjFQTW4WLxVnInG+QShdFLpZ5ihnP9S+sPQ?=
 =?us-ascii?Q?cCO+8pGyDdQ/HW5rEwtGTwlTT84wKCfnn1gaorGrofDAuttUHg+641yOVBjQ?=
 =?us-ascii?Q?BRKvvU+5RAtB/byv90SGfJu3ASBvtVKBT6u1bF6YdeghB+p1icCLFlFRjojA?=
 =?us-ascii?Q?6/8ZYdGfJXeCGB8uWcsaR00tpD44HzpZcEhlSXsNPBxElfML9kI8+qlIbtrm?=
 =?us-ascii?Q?/piHGp8kgJfRb/vRhybuCxmFx352xMwpR/zw/Aq7nzOfV1kyoFXkBXvATbNS?=
 =?us-ascii?Q?iDVZUvnOWcDsJU95S/rs3F/NwWGdli3ScSYVW94YttVTaFwb5JA/fBua5GGp?=
 =?us-ascii?Q?wRr/BTk9FNa0Ruj/7bB19MWMAKwg4BNlkxuqTbxrg51trGSnOU116FgKsXL1?=
 =?us-ascii?Q?CqrsK7vH6DkIfyUzhMQ/C6unCwyWI0Ja/DbugHuV2YILx2A8mO+JXjPSqLCT?=
 =?us-ascii?Q?HTp9RqXls8eeDR90kp1+gfEMsEtuHvOEXgXnjwjKtpsnsiaVaBsIxNNAj39i?=
 =?us-ascii?Q?UoCLGOwdcz0kHPiNrIrH81IZMxZnFdae536pXLj7S/Lqe1Vh7C46BIYGFYTk?=
 =?us-ascii?Q?rTwpW9FzVkVao6XKGOrfukJK5JYoaCIHEoQqWJMpJvuG8GQzjSYxUBrYERwh?=
 =?us-ascii?Q?WsExUBS6QapJaaJop974oFx4KKrgD4EbRkLhlbHScfqhda9JLc/MF1DVZgr5?=
 =?us-ascii?Q?ua+5ojuDz37cZWxjEeoTWad+SBXJdAAy1hVzyCPlTjLE+pMS+cFHGaQ+jgzL?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V/46jJyqqa4tJ48nW9lXH/Gef24ZifOq86/DW2kfAvp2jwvrny+PxW7iCIJ9ICXNkbB6Kl3hQ33JyiSbdfx4+94kWTdSOGU2FxGcO6/33S5kiw5ggn1uiAWm/CgplHtiH50JnyJ4Nu8rdheHQ8/SCJ8ivzuZBgxibhiIfT1QAzXQ7V56NAq/s6ImWWR5n+E1jdBvaCS6ye8cYISt6fBh/yIL+U0HErnJz7uW4JAtfab2AX9NOyHmThxB4jkk4p9fsbKoV36/QaJsU1gDrt+a5b0m9Nr1a2zRZNYhsjPbxhxrMILsd9LwuWrgVPX/c6sposil51QCLlUiaW0AWG0Nxg0p9LUIanEN6StcbBH5ToujoLNEcTLr/zz9GnWyvZtggU9vvd/wiiJBl7u+uZ1QoVxyHRzOBlWeq9f2S/2TOYEtw1wzP2p/YH9jMyM8iREZzaU+Jrnkt3fic7AMumtiuQa5sa2Xynj6fNskXhx8tFKduNbOeJGHAjnH/aS30QHeHC+h53MyjVVPrAx1buX6UOFmkIiTm0qpxiNrqEqq9m+n5b4Z2Cb0Kqjaeb+Rl94tJBGUIh4d6PVQKHxddLa8/aO4dHqTA25ue09pqJiRKF8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e013af47-40e5-4353-1678-08ddcf7c36d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 15:17:36.0268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mT0vbLQXo3vmeyVq6jIhkMn6PAW7VgCCRCUWaWFnzkSo0wgQ+Lv80IezvtxgD/DrCnMioLCJcvuu1dNJSrTSPVnYyFKihL60IfIntJe4cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_04,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507300110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDExMSBTYWx0ZWRfX9IpMqT3CmQ2n
 eDZ/wZE+BxacW3MQp0pW0kV9e8f4MnUmeuK1+YCToPDbx8/H5Tt6PsNe8cBy6C5vrzVdesDgnyt
 +qN2DmJcw7i/+9cOMfvpmHRf00Hb6pe8reGmGix4gNwfZURskYAVbJ4Xi7iIi0p9r+U0eYIjLD+
 W5YPSqAYl3WZ+G4Q4yROig9JuAcoLpCNSniPxUC9d7P4vZ7tubWzCPTGdocZsjwRGo+Ro7Unss5
 kFcKo+qu4IikK6RBVkV0ehlkrwS3jeGX5nzIgsKS8Try4J5T2p7weeh9hvNTBV4Ulj7KvqMRUwI
 XaYRGk+0HB+WstzeLS19cZlLp2SX8w89pr1ArqqI7X/8RqFGescnC1kNj+MyB6hjaAqMX0nks1g
 aKZbh4QAYEAtUQFQarPjo2u8bkjjdLywXRPd0FgZAjvpw1408+dlRsS2g69DAuL8ODwjK2Ma
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688a3793 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=SRrdq9N9AAAA:8
 a=9LFU2g5AkH2JgJ_b8AYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 4c4dNGHmOEQFWxO8tV1WhO8Cac4dULj9
X-Proofpoint-ORIG-GUID: 4c4dNGHmOEQFWxO8tV1WhO8Cac4dULj9
X-Rspam-User: 
X-Rspamd-Queue-Id: D5BC71C0013
X-Rspamd-Server: rspam06
X-Stat-Signature: b8z1ex5kpk3yz4ei1dfmggp6jes478s8
X-HE-Tag: 1753888669-364270
X-HE-Meta: U2FsdGVkX18QgQszHcQnGNHvbK9wGi/fNNi1cXrtKR9CiyNTcXr3gMoTy8m4og8jUt4mmqN6z7X8ync99JNcdc9Z785Y6zrbtxuOnbT74pLYxplu2WtqI+AVpEFw5x5rQJH5Apy9R9cAz7jEDvG3u0ndWXMEjrW6xb7EEwRgp1UCxjlFFaLthpOCPKnjKZGiIbbmikp18sLbX/a582bgBxh2sdrw+RLioxi3+9guwkHa3T68vMDXOzz988E9x4meuAsf4R31TBCxGz/m1uuF84003AC5FnGYXTyVuD97crnYimonWUT1QXj7UKCCUdBP2jFrczPmLJQCxZc4O7z+k7qeQp+irYbMJaMK9bopF1ugl7kvYWv9O4YElzpAzVlrn5BxJl8nOkBcb/Kv/ds6mC++HhMEZobhL9p5mXWQs2TPwOVEgJ/JEMyIaBUxjkkEAYWOAIPZwtR2pB3bc7xVe5ew5Mhef9/Clf1IFBVsllKaMcmPrtH4EO51AipetqOfsI4eQCzY+4VvcOPLjNrmAdWRu/irnFln8cwFkogeG6TYVWqSuHWuvYJg+eC/WAxcTz4Ma+XH6PsZtOaZ3QM7dMP50nSnDbfTgN7fJwM5m6lqgVXG8dYg53P49m3HjcuS3ONlcr/SsPZHIs0aX1UYGDPFa3QvK7skwGidmLcHiI8BktY6JPULwAyUaPZdgdMkGOuRmIYP38r9q/BGiydUht9EUUmgSUihkG2bkIGT0mvcGI3oIDYz+T6s6iYpnMXPPYNe4cEVf9nfU3ak0fB13Q3/PJUBN9qUYlvvdYhZmPfgLCpb1SKiuBSez/QL5ujgZJ7MUAeB6Kkrtz6azO8rkkg6k69iz3QnuXBI15Y/dAHQdsWSvpo0LRk3FsLuDs1ZTezyLCa6Iyy7Lm7alGHp8zWhP/UwzuU44SVoH6YP5bDVN++SoQ1e++YY/VO/I7ndOsRX4Xxb44DlQ0kP74S
 2TVArFJK
 6EeqVHjYCA37xPVbfIrtdzlD43i9TPAJJfScmOZ0ec3XbjgRXIzHtY9DynZng1GY6OSLtd8UWdFRoXOr5J323Mgd3MrSsAjbCXy6ej8iY1qFhk4hKvssZR4w4ROw0KkSf+0/498gmmo3xNdHuV0vwpOgmd8C8T9x9wwYy1DtWt/VL9DYZaE8iuBmWzJCpHMmm2K7PyzvlZGM1ivKvQg+GFTL67drEZWqAfoXuDvaykwZ2ivKgHBlLFfOv1/h6+/uf1Wg202/uiGx+hHbb3DUfe9SXymrsiYmfx7bGG19uCoTcWfpqk9U9DC0ZAIkIh77RKazrboN/sn10lTOP1oi1E1+S2ZfUZI839cfJI6y74OYrf8FTZOwStZTvyDZkvJf7Hhy6gbBc8nt/iPGVuZTKpmB2whfC5fz/PFaasCx+vl/k33yxNT3L1k3NySZ1aM0EVETd+QIgI3/cuBwK8j3VOmlILc3DCDMDytlrwf9z4YYbpdj2PoEGKCbrRQIs+QmxXfLDDFDYLwSQlVR9Pz16Un+cQRDm/EFcAzWvx9WKX6Cc5oKksxI+9q+9RFKjbGym7tVYR3mjZmI8kUj802Z05C3KQGll5T4Evn2Eg/Y9YusZHpn29ugNv5SH0doy2QMl3PAo09ChXuvQwWIz6VCsHUHzEg6extj5q0nwaDxmA/xDlvZDsKyOF0J4phlPusrOhRkMLjfC77IZCDNPcNWiUramNAzDTheUEv+t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 04:14:55PM +0800, Baolin Wang wrote:
> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
> we have extended tmpfs to allow any sized large folios, rather than just
> PMD-sized large folios.
>
> The strategy discussed previously was:
>
> "
> Considering that tmpfs already has the 'huge=' option to control the
> PMD-sized large folios allocation, we can extend the 'huge=' option to
> allow any sized large folios.  The semantics of the 'huge=' mount option
> are:
>
>     huge=never: no any sized large folios
>     huge=always: any sized large folios
>     huge=within_size: like 'always' but respect the i_size
>     huge=advise: like 'always' if requested with madvise()

Sort of hate we have a million different ways of setting behaviour for THP
and they all differ in subtle ways.

Also this is similar to sysfs settings but with slightly different
semantics... <insert appropriate meme here>.

>
> Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
> allocate the PMD-sized huge folios if huge=always/within_size/advise is
> set.
>
> Moreover, the 'deny' and 'force' testing options controlled by
> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
> semantics.  The 'deny' can disable any sized large folios for tmpfs, while
> the 'force' can enable PMD sized large folios for tmpfs.

And what about MADV_COLLAPSE?

> "
>
> This means that when tmpfs is mounted with 'huge=always' or 'huge=within_size',
> tmpfs will allow getting a highest order hint based on the size of write() and
> fallocate() paths. It will then try each allowable large order, rather than
> continually attempting to allocate PMD-sized large folios as before.
>
> However, this might break some user scenarios for those who want to use
> PMD-sized large folios, such as the i915 driver which did not supply a write
> size hint when allocating shmem [1].

Hmm, this is unclear to me, surely because it doesn't provide a write size
hint it's not this behaviour that breaks anything, but rather the fact that
we base things on the write hint at all?

>
> Moreover, Hugh also complained that this will cause a regression in userspace
> with 'huge=always' or 'huge=within_size'.

Will cause? Is this not already the case?

And what is the regression precisely? That i915 doesn't get huge pages
because it doesn't provide a hint?

>
> So, let's revisit the strategy for tmpfs large page allocation. A simple fix
> would be to always try PMD-sized large folios first, and if that fails, fall
> back to smaller large folios. However, this approach differs from the strategy
> for large folio allocation used by other file systems. Is this acceptable?

Doesn't this imply a waste of memory?

I mean if the 'implicit' semantics now are 'always ...but respecting a
write size hint' (which kind of sucks), is changing this ok?

Maybe somebody relies on that?

It seems (unless I'm missing something here) that in THP we've both made
never not mean never, and always not mean always.

>
> [1] https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Note: this is just an RFC patch. I would like to hear others' opinions or
> see if there is a better way to address Hugh's concern.
> ---
>  Documentation/admin-guide/mm/transhuge.rst |  6 ++-
>  mm/shmem.c                                 | 47 +++-------------------
>  2 files changed, 10 insertions(+), 43 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 878796b4d7d3..121cbb3a72f7 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -383,12 +383,16 @@ option: ``huge=``. It can have following values:
>
>  always
>      Attempt to allocate huge pages every time we need a new page;
> +    Always try PMD-sized huge pages first, and fall back to smaller-sized
> +    huge pages if the PMD-sized huge page allocation fails;
>
>  never
>      Do not allocate huge pages;
>
>  within_size
> -    Only allocate huge page if it will be fully within i_size.
> +    Only allocate huge page if it will be fully within i_size;
> +    Always try PMD-sized huge pages first, and fall back to smaller-sized
> +    huge pages if the PMD-sized huge page allocation fails;
>      Also respect madvise() hints;
>
>  advise
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 75cc2cb92950..c1040a115f08 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -566,42 +566,6 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
>  static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
>  static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
>
> -/**
> - * shmem_mapping_size_orders - Get allowable folio orders for the given file size.
> - * @mapping: Target address_space.
> - * @index: The page index.
> - * @write_end: end of a write, could extend inode size.
> - *
> - * This returns huge orders for folios (when supported) based on the file size
> - * which the mapping currently allows at the given index. The index is relevant
> - * due to alignment considerations the mapping might have. The returned order
> - * may be less than the size passed.
> - *
> - * Return: The orders.
> - */
> -static inline unsigned int
> -shmem_mapping_size_orders(struct address_space *mapping, pgoff_t index, loff_t write_end)
> -{
> -	unsigned int order;
> -	size_t size;
> -
> -	if (!mapping_large_folio_support(mapping) || !write_end)
> -		return 0;
> -
> -	/* Calculate the write size based on the write_end */
> -	size = write_end - (index << PAGE_SHIFT);
> -	order = filemap_get_order(size);
> -	if (!order)
> -		return 0;
> -
> -	/* If we're not aligned, allocate a smaller folio */
> -	if (index & ((1UL << order) - 1))
> -		order = __ffs(index);

We need to care about alignment still no?

> -
> -	order = min_t(size_t, order, MAX_PAGECACHE_ORDER);
> -	return order > 0 ? BIT(order + 1) - 1 : 0;
> -}
> -
>  static unsigned int shmem_get_orders_within_size(struct inode *inode,
>  		unsigned long within_size_orders, pgoff_t index,
>  		loff_t write_end)
> @@ -648,22 +612,21 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
>  	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
>  	 * allocate huge pages due to lack of a write size hint.
>  	 *
> -	 * Otherwise, tmpfs will allow getting a highest order hint based on
> -	 * the size of write and fallocate paths, then will try each allowable
> -	 * huge orders.
> +	 * For tmpfs with 'huge=always' or 'huge=within_size' mount option,
> +	 * we will always try PMD-sized order first. If that failed, it will
> +	 * fall back to small large folios.
>  	 */
>  	switch (SHMEM_SB(inode->i_sb)->huge) {
>  	case SHMEM_HUGE_ALWAYS:
>  		if (vma)
>  			return maybe_pmd_order;
>
> -		return shmem_mapping_size_orders(inode->i_mapping, index, write_end);
> +		return THP_ORDERS_ALL_FILE_DEFAULT;
>  	case SHMEM_HUGE_WITHIN_SIZE:
>  		if (vma)
>  			within_size_orders = maybe_pmd_order;
>  		else
> -			within_size_orders = shmem_mapping_size_orders(inode->i_mapping,
> -								       index, write_end);
> +			within_size_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>
>  		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
>  								  index, write_end);
> --
> 2.43.5
>

