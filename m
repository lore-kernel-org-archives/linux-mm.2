Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B2ACA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F4D8E00E5; Tue, 26 Aug 2025 10:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF946B0113; Tue, 26 Aug 2025 10:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739788E00E5; Tue, 26 Aug 2025 10:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9466B0112
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:22:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2CABB63B3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:22:47 +0000 (UTC)
X-FDA: 83819124774.23.73E36B4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 253DF18000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:22:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jNMCRp1D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bhwW4fao;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNgKwYqdgs5VaYEe44bB9jydieCDvUfxNW2js/nRxYU=;
	b=N+VWs5MUSmdqAwTp6JyTfnzBB0eAeVF7v48vFX6/dm5IemXiKaH0nFixY6xjuBx5ZrVcxh
	5iMZNZ8FDQZCRyRXfP1DUVw2ZcK6mDSk1NzOKlrvuyL/D58HWMe0hFa+FqG7SXrZsNsBSw
	l85JJGfMc9hopHkK/r2N+QN4zUhpJFU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jNMCRp1D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bhwW4fao;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756218164; a=rsa-sha256;
	cv=pass;
	b=Eoq+F2Oe/LaM/6+lgx0MBZE0Zfv0+mhRAq8N394GGsReBidXCt8GAGIERfCmlkhwAb2vzv
	rt96LF7rvpe3MC1IJ/nKjRDsuK4Mnt8xMFhH/cO0Uk+KyIHGusgwgU0LK5zH43yIChMXqL
	UIeEQzZVwNoT1BrBrH6QSGn/h6XF4rU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCGvwl022280;
	Tue, 26 Aug 2025 14:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VNgKwYqdgs5VaYEe44bB9jydieCDvUfxNW2js/nRxYU=; b=
	jNMCRp1DhpmIsHlZv20kUVPeGRdJFKXoBpLUqDZ9X1jvgGXMEXLI9YCIpHN05MJ5
	NKzLUlWIPlQgE7G+GDxB08zgavtJhAQDe2yL1RL3jgpuEtRZTVBMkD1GfIxcwWSK
	N8s8fUr80qMsYQkNKeEGNlOY3SPvM/MzbTGXhOxTfMp2bLLiGKeb5tUYnIkDk+ZI
	oi9LfxrX8FAHViNCqVNus4H+cH/Xpjc38LwypdZcLvDnYGyWZOOn/hR+wongbjrF
	N5N5CWao6Eq1fHXZ6h86Hxe6jFfkO4MJ0Mr+O6dt6gmDhWmBHfRl7ISftXB1/FLF
	SDsjrmX+mRetUcoWMw1LXg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678vhtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 14:22:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QDHxuV027362;
	Tue, 26 Aug 2025 14:22:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439ha4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 14:22:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YMdiS5Y3Ti/Z1Dx7qbJ//RARjFb6O3BiCYWL0675Ghuo3x6bgTmCfquZLR2UBKWzb5az5QIoerMHen0qHk+DSUlA1MsKZEcxEc3mnb98EmDVHiZcI4+gQ6leqAe+gAbcW2WyE5ypdFh8swedztuBwvO43aSlAWqHKGUH0YyPA1iqjK2dV6r6Rx4jBvqY7ci8InWiks/UaO9Nvhk3fleJBjtypXDTdxAOrGvsEfu1BpakupviI/El9he0DL37K08zlVeugaQPAbY726wm+U9pCKDJM+2T5Yqowo6a++x4D3lV+iT3ts30qSwY5fkFVeNJDjG4GiO5dwiQEu23ydMirA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNgKwYqdgs5VaYEe44bB9jydieCDvUfxNW2js/nRxYU=;
 b=vdx+dQvtWI2Tb6H4ga2XUVw0anfZ5c5AG+Qhq44T08iIm+IyTf9oXXrWgPz2JK5XuUrENfM4rR3YNsJvRTOL1yTNCeCziHHcymu6DpJ2loRT30tNKndeeu+ds//89Kcx1Q9e9gE+M0/G8NlgV37KMmLbntJ5epezzyPHC9X/hzgJqnFBV7xdXDIRkkhnh17CTfS7Jsx2ICHQHsc+xaOTIhT9gjONBbmfhwMGq7H19pMYOXkP9ERyC7KeOJ+FTrKTcjbbXajL2yOFHfo8woqAEs82cB2Iw2CTmWBIS2cam5O+YNTywhLNlflLEaN38T5J2CYEFNgh2V/F5s5Veud/ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNgKwYqdgs5VaYEe44bB9jydieCDvUfxNW2js/nRxYU=;
 b=bhwW4faoTwyDYTLuSSzL3ewDuzjZCHKR5Aj80iXWZGVdgSqYzV9cG1GPha7VmQqc55h7zXErQ/A3ZQd5n6MydrnePMGd6NKZNMF4dlssPjv0IQUsobui9Z7rbJ2smdB1AHfgRVA02KKPgwOD6a+GLGnu6xpoLJzhpOvlo37HfDg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 14:22:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 14:22:36 +0000
Date: Tue, 26 Aug 2025 10:22:32 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 12/14] maple_tree: Sheaf conversion
Message-ID: <nhw4odptloo5dzmawss4q3mg7b5mtcfcs2z4flnqpduws7tlfj@hy75m647kp5z>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-12-b792cd830f5d@suse.cz>
 <CAJuCfpFKjKAAyXgW_SFBXEp9N55txYdayw2h+=cSLO7wLvO2Pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpFKjKAAyXgW_SFBXEp9N55txYdayw2h+=cSLO7wLvO2Pw@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQXPR0101CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c42a62d-f799-495e-21b2-08dde4ac012d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aThqUGFLWXZYbmhncmNUaTY4NXBNZnFIaTVjQVFvU2hNKzhUeWxJRmdnYjV3?=
 =?utf-8?B?T2FOZzk2ejFFUlJHWW5JcFZIaGtCMEJxb0lDenErL1ZIbXpoRGtVbE1jTGox?=
 =?utf-8?B?aTFNS3F5cTBzKzFOa2tndGh0Uy9rU1NkeGhYNXlIMCtrWGU3aU5MVmtvYlhx?=
 =?utf-8?B?UHM0U0l1Ykh2Vm1EUm5YZUFLK0pJK2puUStmL0NzbGdFaUtSOGFTNVlJK0hT?=
 =?utf-8?B?R2NEZDJ6OWtNYWI5ckpCcS9UMW84RE9hOFVMak82Rzk0Z0x4eVdkaGpLb1Rm?=
 =?utf-8?B?V2lXZ3pQSHNENnNCQXNGc25QODVZcGN3NzNrdGhRQjl4TG5tQ2wyUXk1U2VW?=
 =?utf-8?B?OFdEMUp3dFg0cFNkb2xFZ3k3UTQ3MGxwSW1ybDVyNFlVSlNaSlFpdU4vTVhI?=
 =?utf-8?B?dVV6UXN0Sm9VMlpEd2kzWDFlYzVhZUMyblp5UGQzTEtVdVZNdGZpWnQrM0lq?=
 =?utf-8?B?dHArLzN2MS9TcUlnU2E0SEU2L2xJYzRjUS96NjRQREpLV25FbWpzKzNZNDRj?=
 =?utf-8?B?L3VOWkJMZUdtS3hKZUNKUE1sMGtNcENzMmVpT29YNzl6TWZDRCs5R01QVVFv?=
 =?utf-8?B?TkdCTGVIVERHcHpEMU1vVEZtY3h6OVN5Q1M2bWdGNTRSWURHbGQrRkxvVU5Q?=
 =?utf-8?B?T0JrZmlRNHVIZThzUWR0SUJtTUE5bkU3K0lrMC9rNzBuN1dZYVhFSFhOY3gz?=
 =?utf-8?B?cWxweUNXZDNBNEpMeEdXUy8relcyVWJOWThQUGl4NCtSWko4Tm1QZHBJTzdy?=
 =?utf-8?B?cCtsUmRSRi9xbTlkR2hzOTdTVjFuUHpFb0xLQTBadHppZGl0c2ZuWUU3MG4w?=
 =?utf-8?B?VE1CdzQra05LNE00VFN6QzRkNnc5UTNpb3A4WndUcDhxMEx2WU1KZUROT1dt?=
 =?utf-8?B?Yi9wZzExSUgxNzZIYktYTHUzOEhBRzk2c3hyUTZUVzlXUnVSaGJxZE9ZMXdN?=
 =?utf-8?B?dWhJOElnaXQyQ0tRNjdWcGRuVlpDNi9aQWZ3c3hUVTdxNlRCY1AwdnByeTFR?=
 =?utf-8?B?QTBmZzBwdE8yMkI5MWVGQWNlUG8wSkJxRlZna01rWUJxNGJkSVZrbGEwVXI0?=
 =?utf-8?B?a2d4ZEtpRlZHUTdlQ0tCWGpERFJzeGcxSUVrK2Mrd2pZSGY2TVNRdmZQR0Fz?=
 =?utf-8?B?T2Q5WWdmTmlQVUlEaUl5c29qWEpCN1NTdnJCNi9hb1ZnSS9wNlA0WEt5T0hu?=
 =?utf-8?B?UnMxWHF1aDVHdThPWVRMNEVFbzlGUzk5ZFBLODR4VnNWNGVxTGRhcENwOFRD?=
 =?utf-8?B?Ly9CN1RFclNiRkdjUjU3a3pqRnE3NUR3SjVDRnh0Snc0RUVWdGhXSGpnOXhL?=
 =?utf-8?B?S2lNbkhYYVl5eWdvUTJGVFlwL01oOHo3b25RMjZMLzJuS0gzc1MxdEliTHRE?=
 =?utf-8?B?d21QYVRabTlVV3FkZzBlOGRMdE5pZ3Fub1UrS0gxRk40TVRIdWs3TlBBcHV0?=
 =?utf-8?B?YVdUbmkxdm5idHJXWEZIOEtnVGRESFd4WjBHU3lQcjFESHI5K2o2aElkazdX?=
 =?utf-8?B?SkIzUndFVTdpODZlM3k1eWFzSXAyeGJjMFJBMGRvdHZoK2pFUDRNaWIvbE9q?=
 =?utf-8?B?L0NLU1VaVmptTXZpaWd4L2JZY21vcHZsZlBPZEhCcDBsT1l0a2x3dmtBRW1y?=
 =?utf-8?B?QlhCUDBLb0E0SkgxQ04yakxlZDN0REY1QTFhTDZwb1Awa3RINlR3ZnRBUFNQ?=
 =?utf-8?B?dlowcVBpVXpEZUFCaVhNSkZJSHFPQURwSkxTZG1oaFh5VUI3UVhKVmVTQmN6?=
 =?utf-8?B?N1o2NGdGRzNXY2JOa3hoNGdyRm13WC9DU1ByZktpSkhmNEhoUjNOMnUyZFgv?=
 =?utf-8?B?eEZzcldFRnNJN09WQUdwQ2tlN0lZMDhmdG5xazRDMnNVeTB0OHh1bURlblVK?=
 =?utf-8?B?d1U2L3JTWDVIdENjbFZtOENPZzMrTkxRSUxNaW4xQXNoa3lsRTRKM2xDRGNr?=
 =?utf-8?Q?ZRyd1Wv1B20=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajN4c1FUUTM0Z2VKYnhad0N4OGJPbC9yTWhhSml5SmcyWjkxVGVzc2ErNkNU?=
 =?utf-8?B?NEZwd01iMEZnUmpYUm5oMlBjSkdvWi85RFowMEdGb1V1dGFrY3JESjE4WFdk?=
 =?utf-8?B?VG81RDZHUnpSc3hzKzBzUk0zYXl0Tzlzb0lHaGxYK25nZUJ0M1lDSXBKdTNN?=
 =?utf-8?B?OWdBcDFDTnR6TDBKczNUd29rN1VLcXpjbU1iaDJXejVFcGhWTWI0TXJoMVZY?=
 =?utf-8?B?R3BNbVZWNytRb0FqSnJGTjhPU2dxRTliZkNTd2M2b1hCaFNxamI2Nk1XVGRQ?=
 =?utf-8?B?Z2JSM1N3MGFSbTk4ZlVqNHhreitoV0J6L0JtOW1oSzB1dm1ORHY1U2NTM1Vh?=
 =?utf-8?B?cUdnOW4yMnhjTFQwUkpwT20yQzdjTnlJUnVzczRBWnhsSFNqVEl5MXBpWjRk?=
 =?utf-8?B?b0liVEdJR2xPbFdqSVlPejNKdXFNRTJRcFFTS2VEQitqdUgwZ1ZhTEJubnNw?=
 =?utf-8?B?azlnYTNjZUdYc1VvOUFRcXNRYzE5b2oxSk15Q0xkK3JsVnBNL2grVFpYQUJO?=
 =?utf-8?B?N3Y0VldlNDBYRytWZUZSR013Y3B0VTVicWZVcExsNEdNRG1rOGw2VUl5WW1N?=
 =?utf-8?B?ZzlBb2N2dmpsU3JBUUpOSU9aZEhuSi9QNU9Odm9hUGpGTWk0d2ltaWRYcjlF?=
 =?utf-8?B?RWNWblJzMTlmYWxiK1hoczh0cDA3SzZScjFRV241NGoyVllHSWFST01FL0VG?=
 =?utf-8?B?TGxrZDVGdWdOWlN1bGV4QzNseWxTWDMzZzlqcXVBOTdnL05BTnJCN1Z2Qjk4?=
 =?utf-8?B?NHcxQXpjenE4ZkltTXZseU5EbUpaeENiUzVKZTBUcDRESWQwakdjOHExSkhr?=
 =?utf-8?B?V1hmZUxaMjBidTJOMGNDWDcraUlMZTc2R2ZBZ3RuZHMyNnlDZUNZSUt2aDBQ?=
 =?utf-8?B?RG53NVIrek1RdkhJUEkvOFNxbnBaR3pzY21ob05YdU43Y211UlYvZDB4SE5I?=
 =?utf-8?B?M2I0RzhmaFNVOHFKUGpMeE1Rcmx3QWpudEV2YTNiMzh3LzNiVCtDNW5KZEpB?=
 =?utf-8?B?ZGNtY1V6RW1hWFdsbHhPblUxMXI0aHpab05qWm9FNUVPUDdrVDFiblpOd1F4?=
 =?utf-8?B?Q2RmTEFvVlRaS25kbVZBQXRnZksvdEM3NUZESVMyaFViTXArS1NxUlRFK1pj?=
 =?utf-8?B?OWFpNFpsSXd1eVkzMThRV3U4R2xFU0FneVdHSnpESHFEQzVmRFZGWW5FU2pU?=
 =?utf-8?B?R3VNVzFyY3oyeGdBM2VwSzZOMEMyQndad3AvSzRXMWFjNjBGUXlTMjBhdEFX?=
 =?utf-8?B?UUtzcTFmRGFJb3QxbllnUDBsUmJjWmdKSkdIUERKRHBncExGRjhCdUtON3Jw?=
 =?utf-8?B?ZE92ZHQwNUw1RWMvUFlUU3BvN3JWR1RLbW1mUjhManNZTWh2cGUycklPV3Fo?=
 =?utf-8?B?UkJtR1laejFVT3BOdVErMFBMYUs3eWpHTGpTdFZpa3NQZ3JaSXRmSVVXR3Z5?=
 =?utf-8?B?S0MwYUVJL0lKWkJWMHNuSDJXUlFVOU51eUcwcjBrYldCays1ZEY1ZHR0Q0Vm?=
 =?utf-8?B?TDRranJndDJObk8ydVBWOFUweEVSN2pHbUNCY0VmQmk4MExHWGp3UVNoRmJ1?=
 =?utf-8?B?VGVPMGlKRVpLVUg1cE9rNmFVUXp5THIxelVvM1ZUekhBQ29tQTVrbXhyZE4x?=
 =?utf-8?B?TkdiSzlEVm40V3BRVzFNYWNkM1p6cHJnS2x5S1Y2elVyN1BtMHdYWGtZTUZ1?=
 =?utf-8?B?NXRKZThPUExlZHBoc3VtYjVCMDRRSDcvUy8xK1hFbkdlalA2SnNhT2hOZXZv?=
 =?utf-8?B?a1FuZHF6Sko4QnZMa2tKeU1peXNYa21IdW5IbUhtMVNkdDVRajI2cnEyYWcw?=
 =?utf-8?B?Vk1nZEVMNVNDY0t5dHFCcEExYTdhUXRIZ04rMDl6TnJjVG41elNIYVJVbURV?=
 =?utf-8?B?MGE3cnJYeUNkd2dOR3QraVg0ck5FUUx6MWhHYlFNRHB5UzZEOTRQMXZSSzN0?=
 =?utf-8?B?ZkFmNGkyYktqWG9pd0M2TVBIdjF1Y2Q4VlhwZ1d4VG5PMTBpaE1BNi9VR0VD?=
 =?utf-8?B?cXJVaXNnMjNGa1JUN2hYbnFtWHFlQmNtZ2RNbzdLVkJLcDJBRGZ5VnlrL1h0?=
 =?utf-8?B?R2JWTHl6Nnl0RFd5WHZmNnFiaW5DZXhaY2JzZmZHbjJzZVB6eitjV3FjUzRQ?=
 =?utf-8?B?Z1prTUpGQkFZMXhncmF0WWt3WUtDMUEzU21CeW41RGdDa1ZKNzlsc0FtM3hp?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	24wZRZE0orQFZrmwvEKWF1ZrAvzjW66ffZDXjU7ylNNRY1U8JPWoAEqw0cqxVyoKZ7QuTwof5md+O/20K9df9PRaWl5/Rmp/S56nLx0zSxvQAngm15Shp3fPHcLv3Csk6IJm6IMTdlZh6XIIWOi26//s23l+bL94kfyryL2F+wb+kxKun/ZU47CLjNEOgkM1pGgKqOOgm/04CmGq6+rKhIOkzoVTfUSS3TqGCJzxQ7UM8nshB9I1L+5sK5g1VrP57kKxjS571/11Ynl4PKRIwE5Bln7iuo9aktTsKKNs3SG6L1nOWaoSvuQ8EE/SNk0ScCzCwTstWxm/s39/IzLkw2+gp+4qPx7nWeJR2Ibovr6UxqkeLwJtjkkSISu0HkwbF00WSyI87+4BUQDfRYUQyScxQtXF5UkFex0XtSkVsBZV6uc2ZP+y7jWQe2jh2B9e1ilZ0GcKCBQsjUYr0cgRPayZMajAAsxbpe6EevVDpVqRDT/HKOzLRMTj+uy8Zx7qt/VBfHl1JI8+AjzsNBPJnZeAuVwE9JA6JtEV1mEZV1H8G4gSJgtoXCT3nyvQZNaGh/qbwxLBDs46kUpHWzYsNCw6NPEInmmS5+h4y36V7hA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c42a62d-f799-495e-21b2-08dde4ac012d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 14:22:36.3658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V4Iyj4kPfb8iP/PoPsYGRSa3bmyOG+qw29cToVHt/1QvdswGR7C9OUcGFAI8o06nZ+4DnQ7JOFiWx0sRtS/GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260125
X-Proofpoint-GUID: bU9kIQTyC0uM38TH4E0ddJbHcjLBTeb3
X-Proofpoint-ORIG-GUID: bU9kIQTyC0uM38TH4E0ddJbHcjLBTeb3
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68adc32f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=r08tu6Bty0SbVdcBj4oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX35Zsp4qq2KrE
 G5qJ+0cz1cyjdjwjPcwbBR/LS7JoOInbI2HX5fTUU/u+zsmSDC8X+uHL8r1qrZKMUduVsE5ndfv
 YSkigMB+/2FcdGqddQbXCuiS5dJcIOZ3gVd9Qwcs2RbhbDXrzZpAFgHnhmXhkmwU1343wRIZ6t1
 o+zIHtGR3hIcUpx8ulRW4pSlX/6RFjKDRXfZcmVmqjrtPWMP8ojoWsLSmi3345auUIF8lEJLCKK
 U4DG/WDfb0xMBdt17aS+rTGT+ZHcoBsiZmqEcYyTv1C8amAkq38YT0MwLXbjoYAwhqZTAIyXrUl
 cdj7WbFp6rrZLqK9687uCW/BD7r1x8hvKDfeWrCJBFq8IuONM3F93kKeLjt0lNZh5cqaVbjNR9a
 m1kiTfgF
X-Stat-Signature: rghefrp1hjnyfmhqssd5kdiywn49uxgm
X-Rspam-User: 
X-Rspamd-Queue-Id: 253DF18000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756218163-786570
X-HE-Meta: U2FsdGVkX1806w6WkTtnIM9MWQqn9Z6ihdmexdph62qlDv5QH6jLMfpYO+n85P/9e9QcJc6SNFlV7fPaPOyFdTY0g3964UwhKEsPGTshb2uwMRjOD4tl+ZReYPRJYiWCXhFyVyfUx/1qSJWtWrfmG0kWE+2lrW69lRKApy+67455QR96ypkXhKy7fM8wHb8kFeVa/MAGCwTfwsuy/npV6yLNmChIZVzYb1ksX6GEhPqyc46H0dXshmH0NL+wJkTjJdRb9jG4Z+LUFaqG72jWYT/9nIzuWFGdA7UnMwS0f/LK8+Y5yrjmhejUR1ISVpU5bwsiLUpEizTDIe++SLdlJCvNQB++LHtsE+EkGygvEJdp5GW4U5sAjCkk/MKksaxjetC7O+wP+tq9D6HKBjMkEmZ6TFfKW6DltDvKkZivoBLX8dE3UHNRJMRPqSVvT3ZxMetVO/4mq08PLZyokhncfIHzIxqs3wXLf2xbd8qF1GJ8ziH0OtbzW5DbNVmEEhob+uGOcds0TpwGcCQL+Kq0DW5vFIeOX8oFoTopblnEUd7BQhzVIDlMuerv8M7wtWSnQm5vnOWwNDFZybGy9NGBnuM6iHkRFcKnBt67i13hpViqYRHwYh0aMLxT8bAx23MDXig/xQr21o6pTMt4kIREG3fq/oQKK0zuDsqOSEdNFd/aUlVSbgQokMlj9HhdLlWcS2JcOUExiOclXqn/pKAMCVO99QqZmClgGZvnneIKZ64/MPA3E5mmdpCDo6eHy+TbBK07slMZo36Umdaz9cButox8roBqBEjPfPEezyYsFeDsCLB+ymZGMru/hUE3aTr1WlBvyBMC3QGhibtpkXuLqRcDsGVfQoav3eFg1eRhglWOWAIj9Di53Ses1WXa2TvN3gOXz9w1i84gLrkoHt+5UFdXSLUlNJp0dHZ7h0ooyZIFuiqCiKMHZkcl1EGA/IMSqSnRnbeTuEb+L6erGBq
 ff55+lM4
 lFeXNinEsrZcJGxRRPSpRVQcNmje+HN78BwucC6RmuQmK5KnzeLxHqhB19P7QnSX9mcV+Ip/5cMEOveaqCxLxeavKNjg5zojpJmEFDDzE3tow9uZyi2snbqWQFY07tSttkTnoZRsU0Z5yXwFUFOvpx5EyHnnwFvasKgJhD8dqdiO1AYR7A9Comw1CvPTLoga6c+c0ZBCREkTjoDPxYfPxf9iLO2V6Z+y8/qxWxK5XhsKKkeU5IyQcKd7KuPnmHy6R5QucbOX985V8NDO3CJKHw6v4gPk8KmSH67UzB+ILeIWcFRGjwBHV4hjDLPG2Rsffn6D3RiXPtTcwXRMEAOXlqvILwPkXUi6ytIwswaV4NGoe9MnfvpC68pxPOg/JnWs56c3bgBM9KfHTOyNy6LQo0QZvIHr4N2V9jK4za13bE4OnoCHK4R8OcXGJ/z17qZQ3E8XAhZLLhOtkBxqdxBmk84K2ONU8gBe3lngvx97mrE6HCe9KLZKe/6emG6F9vr57fFWRjTmKnEHYwsLrMNJ1tPMmcEt/3nyWbOBo0mKLedgav2PqOusxDKPq7dFoV61vXhJZA4nhx/fjV/sG6fOYDtkrL1dkgUsuKiKFBJHv+YgOOpHIv395Honbh7b6FqcB5szAYz8fOgPlsWyefTMILRwOX7UdaSnUD8HsnsmwZtV85P6P5ZqqAgnCy+plbGaJn9drbVU9fA4WF/+UfDgvOlnX60QP5mbDfgUTXJegZz+TA3gXlD9RIeSJKEpaA5XWmG/qzWhNE9bdXCA9KHQOxcTQ8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250822 16:18]:
> On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> >
> > From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >
> > Use sheaves instead of bulk allocations.  This should speed up the
> > allocations and the return path of unused allocations.
>=20
> Nice cleanup!
>=20
> >
> > Remove push/pop of nodes from maple state.
> > Remove unnecessary testing
> > ifdef out other testing that probably will be deleted
>=20
> Should we simply remove them if they are unused?

Yes, I think it's time to drop them.

>=20
> > Fix testcase for testing race
> > Move some testing around in the same commit.
>=20
> Would it be possible to separate test changes from kernel changes into
> another patch? Kernel part looks good to me but I don't know enough
> about these tests to vote on that.

Yes.  I'll do that.

I'll drop testing first then the feature so that testing will continue
to pass on bisection.

I will also stop moving tests around in this change.

>=20
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  include/linux/maple_tree.h       |   6 +-
> >  lib/maple_tree.c                 | 331 ++++----------------
> >  lib/test_maple_tree.c            |   8 +
> >  tools/testing/radix-tree/maple.c | 632 +++++++------------------------=
--------
> >  tools/testing/shared/linux.c     |   8 +-
> >  5 files changed, 185 insertions(+), 800 deletions(-)

...

I didn't see any changes in the code block, but please let me know if I
missed them.


Thanks,
Liam

