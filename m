Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6F0CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F918E000D; Tue,  7 Oct 2025 02:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF9A8E0005; Tue,  7 Oct 2025 02:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1D28E000D; Tue,  7 Oct 2025 02:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5E308E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:43:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7653E140833
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:43:44 +0000 (UTC)
X-FDA: 83970377568.25.7784D2B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id F329780013
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:43:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RcyP3boN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="J3p3/7Bw";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759819421; a=rsa-sha256;
	cv=pass;
	b=ypzdm6YukGhlxpK9c7VwPsIDOouWULC3ZR1C4B5/mXGEj5XyDbyOMjMFwok5LKBBYzp6Cb
	cUCaAQnBKuR7wSYlBftZeNAyofR9YkLqWP8QbO1h0YeSxcubcWBmCqeTlyjfq677F94yKW
	o9aOeE1Q46rkp0wLumuC1ySwq4PjrjA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RcyP3boN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="J3p3/7Bw";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759819421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K9AO9MWvHf7/U9FV12CesdCD80KGCxHZR6uai9EEZo=;
	b=tdzIQGq8qbt2IuxVp9rSmUeSbVmCN+8VDH7wAKn++y/H8dWhnx91NP+jHw8Y4C6MSheGLC
	dg9ghrwpaHqOT3T1ZTbDPi8LpIZkmqB2/3wJWi4CEKylfyUMRhin5hc/1cV/cnjdjw8a/5
	Psp5YJls4UFWPIfUk7RvYkTyO7xMFfk=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5974U2jc011561;
	Tue, 7 Oct 2025 06:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6K9AO9MWvHf7/U9FV1
	2CesdCD80KGCxHZR6uai9EEZo=; b=RcyP3boN8FfQGKEo9QvThtxWr5Q0kYLOEY
	YDc4ijvbPV/rvuIRMgG+udQVIizTR7axoUym5DDvEQTU0yPyoAdiswnFevKhHVXd
	HhKuT8qLO6DzDLrq8uMjnmUEy0CPPxIWnE5kTDepS3YX9eIe/Dp76pQojvawJV1y
	IjEHWV31jhzr7ychQu7ApCFBU+HBBOUwNW9i970doCLK15guSXUyzcfmFHxmopz8
	5q26s+LaBWX/L/beaVWuAwFin0JZERLxpyOfnVI94/KukWt0dipMUGEaLbcxy/cU
	D669uqrhMXH0PHkGRFJkRwouyoHq7b/SnbAKmZXXvQOPonSp4F1Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49muvnr67h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 06:43:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5976W0SS004311;
	Tue, 7 Oct 2025 06:43:09 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010042.outbound.protection.outlook.com [52.101.85.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt181hqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 06:43:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1391+8P1JHr6tcwAvbeDTjinXY7aK5kPji4CK4NJ1yIx7mjcmIWxvHRy+ylCl8LuQaZsraZ+A7dF1sw49e+adZwCPL50amHS0Cypqsw7+WRQ3eHfAI0IPHeyVlTK4W/W5rcScdXrTE+830igHDJ9jUu9A3zbgljhGsn/kmpn5SDg5MnL0LZUT/GiBj6q0cyBE3yiBgSTRwPtp3/0IX01SsLi1/ia5jDC9txCYxmipDZfTdt5xmJ/vlcGkhMKTuK3p8bxNnLbFTAE6Wc4P8KlDorqNprLUFlkuwWG9iTI/qZkyFJtsnnpwDEkdKYYxszdAwQQ2OFuNUzyGoGLgthnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K9AO9MWvHf7/U9FV12CesdCD80KGCxHZR6uai9EEZo=;
 b=AB+zFYrc+UCYoCPF+Ej/a1aI4rwJfct69h1zuV5kXGz+p97v8S0SfQl5TQyHytS/eYXA7v0T9S5P3AcEkV99GFnLU5TWEQammPNj1qRKOV70b+wpQdZlBPgG7+uAIOUZTSrfGmgaYdgrr+cpNYEdYNDt7VFpxa+b/Jx8e7T/G/epDKP48Yw1fQlUstH4oZGgcpGETkE4z824SfgSXsPEcPyh1b88IU5JuL13OTrOpx7vOthisL5z+2MdLVH7XJ4FDSZJykk+wYXvqWE5jC8GWLPd2Q1teB8EuWqtj6/8tIek7Wdv5Cex6pTGbZxb7Xf6BIA21JBQVQ9cc571k8BvSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K9AO9MWvHf7/U9FV12CesdCD80KGCxHZR6uai9EEZo=;
 b=J3p3/7BwHc1IAgvB2Fx/7NKGWBbhae4cXiCU5MHD1IdyfInpyKo/EBgqN3k1kv5w//9ubevXMVuFUlTeycitYwfCktpJufRlCRLKlapvCqhwWHXNUUo5sE5R6TdUWcGrPNMz0vT9mar6W+dZS32XLe8wllS1YtBhLMYvsE4evOo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ5PPF5467E3597.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Tue, 7 Oct
 2025 06:43:02 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9160.015; Tue, 7 Oct 2025
 06:43:02 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-13-ankur.a.arora@oracle.com>
 <d2dca02c-ec5a-4b3d-92fe-2b3a3614b5df@redhat.com>
 <87jz1obyd7.fsf@oracle.com>
 <d03dd7ab-5237-4de6-8872-a8ae2e9b7c5d@redhat.com>
 <87segb9i9a.fsf@oracle.com>
 <3cf7c02e-d77f-48cd-bd03-69d71f8cf92b@redhat.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 12/16] arm: mm: define clear_user_highpages()
In-reply-to: <3cf7c02e-d77f-48cd-bd03-69d71f8cf92b@redhat.com>
Date: Mon, 06 Oct 2025 23:43:01 -0700
Message-ID: <87cy6zfc0a.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:303:6b::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ5PPF5467E3597:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a213507-c2af-42d8-faf3-08de056cc33d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i42TPA8izuHbbuu434furGLSikgYwk4j96omL6t6q88lNHuzoh4pOVd1Rplz?=
 =?us-ascii?Q?2q6bO0HXfUYme1TdCX4mxmaDKbFABnU5HOW7xFrRkdzvmdRoR2MXuBxUN7oi?=
 =?us-ascii?Q?J9B+1lZ+rpBUEeNDXZ9ftyUzD+4e3Y6dkgHkmrbEp24gbn2O99+byk1P+yNB?=
 =?us-ascii?Q?5Cg35UF4Cm5/6QOClM7G4bYhraA6xVYAiSQckpZDI+G2NtuKczTw0JsHZOr+?=
 =?us-ascii?Q?IvLtz+q8DjLHix3+b3tbuYYgfBBcRb0Tir+FRkRfQtE1fbsoCX87ipMrGWop?=
 =?us-ascii?Q?J190Duwzie8+4bI8qvAoMKoEfyEbXfIfdUlNn/ZvOPeJZaOroRdQSaDJP1wq?=
 =?us-ascii?Q?zvodMlSEXlxHIaEbaQQkAhhBKrskCJF84vDcX26YDDTpN1q+VaksnjYd56gI?=
 =?us-ascii?Q?V1q6Pp++LMKfFRT6/M/XWAJh2VFSXGsdV7Om/hfiiaJ0w5TvgwkUnM1sOCCe?=
 =?us-ascii?Q?WXgBJqvVKxfep9b/XKUI9v8mI8/zT7j5gdDk4Enku5PbQUoqiopymAsYEUSy?=
 =?us-ascii?Q?HrF6zN39nnwVe/nz7dcOPo2eCHeLlNcXfuCd0ge2qjOnD92zT6vb8tEz/I7o?=
 =?us-ascii?Q?JvhPg7WcUW8nmJtQOfexCoE/QZRv30s4/2IH0QG448kqnT0gnAEOnCHDKJaK?=
 =?us-ascii?Q?xHmDRl8bXCuHksuONVnkXrkSzBPpVE37JC3znEmaNmCZIsMp30qN0OWhv7At?=
 =?us-ascii?Q?cQDHVQtVst66lE5cj0401t7rFcv6/8Efr1xHakeGqmckbBSMPcpxDe3OcGyC?=
 =?us-ascii?Q?4mZa+1JT5lBrqTl+z91CWo3cNKfz9nO+wtBDiscc1nHaoUfqsSdQa4BUqUAM?=
 =?us-ascii?Q?Hd+Ougdq2joAxP+6/HfuTC/kfBN1E1xLiLVsEGwisA+I5Z6OrX1GASIKkwK6?=
 =?us-ascii?Q?PYbU7HiQfwydLaLgcU0ecT/l2KCH7MPqL/SQeabf3vT0ZEYK5B3X9j7FAvED?=
 =?us-ascii?Q?4OfGlj44Jyq6un4HBvtss5Vd9daPSneRTbqsqy5uOftY0aM0AUyGbj96TOZY?=
 =?us-ascii?Q?FKpYEFw24oWI7OAJasB2WdC/vuczxASUTmW3hxtvtymdKCiekPSYbbG7CWcJ?=
 =?us-ascii?Q?EU4ToP81P5R2g8yJJ7bdIeNqngDNPeT77l+OVXZzTPiyCHJ+TAjGua59ftnn?=
 =?us-ascii?Q?1Mq9lGXEi/INPa5mm7/yFwpp2Wn9foJJs8bK+O89jva9a57aqms4te59e70T?=
 =?us-ascii?Q?J8vDLlC0UChijdLwVKDNi53UFSzKPIYNe7WsPJM10N2A8HTKLAIa93oLDDHM?=
 =?us-ascii?Q?xc+Tf7biTgD1i3BZaJ978xh6PS+3/yJEkVxNW/656kxi9em67sq7pLUqF33V?=
 =?us-ascii?Q?y69Tjj/GNXG8dQgsirI54+ZwJ9K0aWx+nNU7XU389yF8drSNdJqOrYxyzjnd?=
 =?us-ascii?Q?KQPu0FHfnDBBT3uYCZnFQDKavbCOrFGRuE4U36E/cM0JNtjIaixpknlZU6en?=
 =?us-ascii?Q?LH1mTEXPmF5DX38Li0qqk++Jej3vIc96?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zEscRmJLtIsU0QkkYroUpXoWXCiV6aP6mkKSE8+p1A6cqOoxZirb+Uz/SZdI?=
 =?us-ascii?Q?7QpJLMvYHaHMMlEkFvy9+401NpgPHmX1sPOheY+nLQyqGe393ivWv6fwHe+U?=
 =?us-ascii?Q?RVcttgl6StRCyORGxstlA15Wkw3BqbDUq9h9+gNJh5opXZ6TlrLiQxc2FxP0?=
 =?us-ascii?Q?azhlDNYnVIibjdvGm1mH/ugwJTHPB4xCJqQM5txnTsfmGXnM2oOB3XO6aQt/?=
 =?us-ascii?Q?dR5b8R5+UP2D2+axXIQcajBOubPchj8nitDenlBfl13KujKBaPY32SP4JsV4?=
 =?us-ascii?Q?C/l5vbmjjRgTvBCll9cH3yZ6oKva8pkM7+MRQD6Qixq2mj3qwqKUBoI5bnDY?=
 =?us-ascii?Q?QiAml7i8wON4V2oxgzEvvS2WkTJzUv4LKWuUTdloK/Ea/Ya4rt1j9bzqGUJP?=
 =?us-ascii?Q?5Re5jE411uCWsRPyC127ojUqnFCjB2mm/lmxVepaOHm5UpBDC1PEWHC1eaVA?=
 =?us-ascii?Q?IN5j41rUhKYj5id35+u+M91HObeY/ea9T0WJyOrNefmnNNnOXZnK7O+b7usn?=
 =?us-ascii?Q?zNifjfPATkzpsk048Y7HCjrtu44NQ5sNV4Am2HGBp0oyPrclZ+50XRUrto6Y?=
 =?us-ascii?Q?QCCJV8ylmmuRt6wNjsTFQzBQ/AwRnzcs8lRM+1q/M4tJOokBJK/LMJfgEzZm?=
 =?us-ascii?Q?iKULhxGkLnxN7VCxO4D5L6lFOoPRsCTzZ/hBPZcAfaSXncVOfaff1j1LOj49?=
 =?us-ascii?Q?IR8/GNHlWKUqhV5WfuKQZiiCve49ln1a7kSi8COVAbfE0kz54cPuX9dEH3e5?=
 =?us-ascii?Q?r2a9JLaJfc13TVPlHHs4m2oMPGAxWBstX1INw/5tK1cu06A1MVyR4qzN2ZwV?=
 =?us-ascii?Q?0dQzJvzJzIySdKtoJnQulL+BYcaN8N3dTz1DmYNjkLYY3AvNjR70Nz6+KSUI?=
 =?us-ascii?Q?rUA+m7tza0tBgDPi6zrbD40UdjIcFVWb5C4A2T9ACifHoqP+V0e5I/W/YRtr?=
 =?us-ascii?Q?zRkQzl45rQGNvnsFZ2wb2BHQsKL1r+GmkifQwXAGlEFrpd2sFD4o3E/0JCaw?=
 =?us-ascii?Q?9IJ7X0P6TR6tb1kPanc3SURGq1ApAczisEzs90VCrJ6BMMY7hwJw4WcZbWXP?=
 =?us-ascii?Q?BabolgCvMjV4Dgr/fvfSRp1zQcWSyGBV3w5gXHWbeCb/v4kJXLtgWeHw4q72?=
 =?us-ascii?Q?7JDxSwR5je6pSHtFEusCCv20G5pO+KmhqUaO1QHpxTrL3mbWRmVnnYEOOSEQ?=
 =?us-ascii?Q?v1cueLGsNBFdsxvenc1/Yr0VXitx1oQa+qDxtFxh1aNJCOH3WKcSFX/echZ8?=
 =?us-ascii?Q?qgjwwW8oyj0NxqwQQCv1hbxYagTfp7435XM0qUB2z9ns3fU/0cBkaEc0mVOs?=
 =?us-ascii?Q?+e/RQNXYXp0L41p9n9MBgtIbIpv9HyXIpwtK9NrGI0i/s7KoTpFZ5+pResF3?=
 =?us-ascii?Q?a7udLawf7ySJm3pds5l5VmuW24nRUfAiNAD3ZYAAuGOl7NnSfZfvkroArjRJ?=
 =?us-ascii?Q?wzJBLCzC3ttHyuR7WOb2m6AO/iMvQ/5aAAQfzaNY+G0VlROMmA4S7bEQleOK?=
 =?us-ascii?Q?uiW0PNBX1bcyYUwbvem3kXnqJ7hlwDCw66Ru3yIVPqsW2tFbAqjtUEJiASG3?=
 =?us-ascii?Q?KCZjIYbpmb6h0gRd5uH1Y7giajnaTYGws2ofbPvMN4g6HEADnGsaiYBfkpkG?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NrfR0ZT7x1ahXMYqAJXCSwEmZNLrKNWPO7vBiOADbj5+Lnwf6nX//8yESvlHfjFqztpwWGpXgKLeyLhIaQRSQuXgYTr0FtXqdbg1AMmt/YrITbfB70gDol+3En95Ize5mMBEmCtWfGDROTkmVTK6zCJlvlNFHunq8bcrytugKjMYVREZS0pdOTLKdmAnU5qmxpz8nxn1Up22lJWoeWrD6YWuF58PsJeG4nEnyjXEQLgx9tilBoW4ybjA+vcLH78YbiuTfvlGDI9mRzM0wYqIEX/Rbc0ffvr1HVxXsSh/63sFHTfrjeCoBM98GvkXY/ExaAqZSjr6bCaR+0wzvJcXuI0ldbtYK74L/AlpvVqsl02579rep9HhRQJXrUCYMd84sbrGmz8raR9eksSuMFq++esD/G2ZBV/DawsLV3Twv1UfwRffdfU3cq/IeDecaPQ4C1uFIRs7aHuQAk7p1hyzDIXu5T0dB6hfloX3Wv4I2gxLds/fypkxbACB7Ly1JXm++kd2Ri9+h8PL7OsrUPnURnc59YDh5PfxGc5cvNyomtL7odJMqMh/2XgYAyrrIeOanJ8oDFJFxz0H4HFfeEyTTgAQb5bMki9eCL4Waogn8ac=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a213507-c2af-42d8-faf3-08de056cc33d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 06:43:02.5686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mE76A9KWgfhuAOp3h7UpNOuoNdtYJewP+ooSA7hZGOOa6GWaO1yyXpMR4SVqh4GVIbZCmgF8I3HfpMJ7vJ+XZncYGlbvdC7N55HOAAXfrDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5467E3597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 mlxlogscore=797 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510070052
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAzMyBTYWx0ZWRfXyRKNQOy/OQer
 1qVyDU+d32GLIEOq+K3qs2cZ03ez8qnqzbtJZJJK/A4dLN0csRYnItd34LBorv4SGo4chBRNe0P
 i4CFwsNvq6VqdyWgsGlZHbg0GqObJJoeTzpP4JEeDtGBO1X9MIipoKVQygLm1Mr+0DD0eN5C65B
 sYq9HoCymU+K0VaKAo8qvDVVYFppa2nQ60zW3/c+Y+4Pk5RINhs3N2f4HDYGIBVGUV6q+3f880S
 H9ljNaImDcy2FhWnNgec8p2RYtLV1vi1ppBzt6RwUrlBYKYu4pof5IOPICLkwHmatuBMxyuFgAk
 PYrKKfCgp/CILrsWG4DF22FHc816mu5n9Yrvn8a0uDMYXZtln6yS553fcJwUAIEZ6gx0Kk6A6NN
 E2rCWhageYrU7BAyOKXCKdcekZB/hg==
X-Authority-Analysis: v=2.4 cv=X+tf6WTe c=1 sm=1 tr=0 ts=68e4b67e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=hSLYlPIU2sbDGEEansYA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: wg0btAvMjayV6TWSadTbv1StByL1UGnJ
X-Proofpoint-GUID: wg0btAvMjayV6TWSadTbv1StByL1UGnJ
X-Rspam-User: 
X-Stat-Signature: qfqdpufufrtin59sizpc676czyg5j8xc
X-Rspamd-Queue-Id: F329780013
X-Rspamd-Server: rspam09
X-HE-Tag: 1759819420-298891
X-HE-Meta: U2FsdGVkX19PbdcqbladK7tL25KnasjsCGMsDuQT8jxUecuuAzBCIuO9lzDxn+8n7fgxOnH+T6Rav4RewbBMMyNbKMzmhyulmpsBn+nI3F790VM666rWy2SyqFv3W87YUr3kLVB37iPvWqsdtrdWSN7MumnvFg3GXqewP0JManpKMc6f7UoRc7b7nzycDhbxBeg7yPZ+2H7fazcHcfioEn8q1G3AeQeGVQWZKtq1AEIMYVPYLYKMm2N0p5G4ZGENw/yLHyxRuRULKqdAt8ekmI6CGys+qHGLDSZ9nQpj+IixQz4R588snnn9R9I3NoC992YJEezrxPonStw5CY+naAn+mOwZIUp9U6OUQRjPKgSke5AsppYN/3Z6XGFTOm4kxeHqHbT71uN3y5qr0LtZqhUw2oVL5teFXFFj/GXd3s4r2jm1jT3ZyBrO7kbTcvqfnTe1VG1Au2nuORbLPSVDnrbwkPIXbL4R+qma4j6wQBgD5rPEZGo/GtT5zONDFzP6O+TVi1Bx1zJb+FTg6G9y1fOv3bmiwIrbchrPl5cVrItYxUymhIwdobGgQkgsRjvDId3MIvrMwru5z2Z0B6DGh/eeXu9Nna5puukPQGKhq1qXQIxHW6vbANYwMku2vvNfsJ39ecWum3xxBkhCoR9Y+bypEZJdvK2KWebONZJ22XmSMRkypjpECffhGxzNsL7f++fNO2LXtn0kEDeWUjrWmG6DMnqLRx3PnmMTAty2BEpRw5T+NEXocUHV8x0viL5Hh8EPKLNApczPXgzgbdZf5+zDlRHNMxN6ytb5Of8uAkJDn9d/Bf26vwP7Wr9weFbC5xS0LZyLnyyVBRtmrKLhbCkzKjC/+ni9n/oeMWhOj98da1VbjQibLqc+jsefVbCslx4Nqi5jj/csG9pG2WFdaZSIp1Yn4fp6DwSPjkI2jhnJVD+un2EWd0EHcfJ5Zyy0KqKbeIC1EfD9dsdW59z
 s0CnQhd6
 LWV5zbQ4wsWN8AOo1jcSymi4eTR6gsz4xE7nJbK+JiH+SuQpsIrq/3exOEwLtKIFJJ8l4P8H12MFSIh1SNTu2QGjz4syO/qHD/vygocZEI3Odqz8SH01K4Zh4dbK5Y0l7D7bycrO27LlX87uHu6FWYfxoksXLtTz8Epj5H63vCSpjj/ihcC/oYmsTskSqq8kTt+Y0NhbCFMhd71mS4bofPotTizHgkioGSUrLy2YUVX4aOvY9xA8aR7wHC+ewtycfuk3sysnEhDLFnhurOCaLYV7jf4sjtrSOsOoqE9nT6mEPHTCmXRYnu4G6fv8Fq5oBgKrdhzV2BF5RrFhBbx2GYlHynn/UnuaMET+QK/U+II3ITrf8lCEebawPIHNOJBiei1RIPOHucGUmKsVTiijDXKt7j9xvDuwWJffC0Dki2+URt4fzuges+w55gcGkjoP3yMQoLc+jWADdVQa20YZjnK+B1DjOopm5+f/IdYZ5+naIF1aKVEnrRB6AJqKaIOEgob/nAc3DPSb/MG9EY1cECIGLH9+7r/beXkWerj5olsQ+ezmGPcgC5IIFqRmpvRLYtShzelf1EoxQ1KpgMpUkPyO+ZKcLsB77VXdZZAY3w7Iz1kw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand <david@redhat.com> writes:

>>>> assumes one of the following:
>>>>     1. clear_user_highpages is defined by the architecture or,
>>>>     2. HIGHMEM => arch defines clear_user_highpage or clear_user_page
>>>>     3. !HIGHMEM => arch defines clear_user_pages or clear_user_page
>>>> Case 2 is fine, since ARM has clear_user_highpage().
>>>> Case 3 runs into a problem since ARM doesn't have clear_user_pages()
>>>> or clear_user_page() (it does have the second, but only with !CONFIG_MMU).
>>>
>>> I think we should look into having a generic fallback version in common code
>>> instead for that case, and not require the arch to implement such a loop around
>>> clear_user_highpage().
>> So, as you suggested, I moved clear_user_pages() to mm/utils.c and
>> conditioned it on clear_user_page() also existing.
>>    #if defined(clear_user_page) && !defined(clear_user_pages)
>>    void clear_user_pages(void *addr, unsigned long vaddr, struct page *page,
>>                          unsigned int npages) {
>>                        ...
>>    }
>>    #endif
>> That fixed this issue as well since there's no more bogus reference to
>> clear_user_page().
>
> I'll have to see the resulting code to comment on details, but if we can handle it in
> common code, all good.
>
>> Are there cases in which (TRANSPARENT_HUGEPAGE || HUGETLB) might be enabled
>> on ARM?
>
> Arm has
>
> arch/arm/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
>
> and supports hugetlb. So yes on both.

I tried to figure out a way forward for arm with THP/HUGETLB and AFAICS
the cleanest approach would be to have some version of this patch.

Just to reiterate the problem with arch/arm: it defines
clear_user_highpage(), but does not define clear_user_page().

This means that common code cannot usefully define clear_user_pages().

And the common definition of clear_user_highpages() either needs to use:

  - for HIGHMEM, clear_user_highpage()
  - for !HIGHMEM, clear_user_pages()

The first works but I don't see how to make the second work without adding
some such special handling:

     static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
     					unsigned int npages)
vaddr, page, npages);
     		return;
     	}
     #endif

     	do {
     		clear_user_highpage(page, vaddr);
     		vaddr += PAGE_SIZE;
     		page++;
     	} while (--npages);
     }

(Even this is a bit contorted, as common code shouldn't really need to
have an associated #define for clear_user_pages().)

Thanks

--
ankur

