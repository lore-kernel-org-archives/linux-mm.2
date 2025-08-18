Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC33CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 15:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D93E8E0024; Mon, 18 Aug 2025 11:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0A88E000F; Mon, 18 Aug 2025 11:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379198E0024; Mon, 18 Aug 2025 11:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 216448E000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:49:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 809E81DD45C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:49:24 +0000 (UTC)
X-FDA: 83790312648.10.298A958
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F1ED20006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:49:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D9owJR+f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=df6xq0nf;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755532161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D20ExnMSiU0M9nrgFPZNyiP7TmEqYqSD450kxRMWMi8=;
	b=fvZAWJ5zsN3PTtFpLsGzrFbYQ7xb1Bx2w0gJmdJMmCTuRxaslL/fAx9ER19TGb5L+QVK8W
	7dcLzrpb/eFnIcH9hQoOYNk+h0UjcWH2EbftWKfxspS25OOnAYX+VATy1eDyeq6IIQ8kQk
	s0Z+qV6KfUO4onapP3s0530n5WlmxmA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D9owJR+f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=df6xq0nf;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755532161; a=rsa-sha256;
	cv=pass;
	b=ESuLkqAECGwX9qrxAnAFThLZPB4t2+pwFVB8Gp6o5E3iqkQwpnR3Abagc2IkaO/fEJZUuj
	EAgB8fOB0cPDe0yeiCXKWu49LJ/fn5Ms1mpAl0vhfiHr2PlKfo1aK/AAyXVEZx3ydX0AWb
	tSGIWUpH239ClA1erl7A4I0SQ05vubA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEuXp9021068;
	Mon, 18 Aug 2025 15:49:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D20ExnMSiU0M9nrgFPZNyiP7TmEqYqSD450kxRMWMi8=; b=
	D9owJR+fbSDESIoiFCkKYRc4nr8BxSPDxZ7GDlzTlPt3h//brp39U1Y9atvxkmrz
	GkwJik7GNLgHkmsdHk+2xq+QmEwUi+S6Q9uAL4PEPvDvSwAd+pzwhsv4rerVfXQ9
	reXHwexeoBwPjCvk18T7libWmOZBEGSKPYt88BPTXnB38tri69YaKTDQJHXZuS7B
	Ll5XHRwsoxPIB3ti4RxbLR6x4PhuU+Yc0hTzNIgiEA90HsXZNaF17OH5HDGC7+AM
	jaHCJaXPU8KE+wKixdvL/MMKKF1RvEtuhw7gj59CKr2nstgyU+NxzcfKak52UhWV
	8JVh/lHzvizUgeMjiiTzXg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhkuucey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:49:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEquis010944;
	Mon, 18 Aug 2025 15:49:04 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013069.outbound.protection.outlook.com [40.107.201.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge9ekqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:49:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eWp0XBTDAW2jkuzO0ZPnW4MyF7Nqr2whtsLq+V8TigAPMUjqv7VXHeX6pwOOjaw0hOH5Ivxr5YMHpDq+2sLElnPh/zERsGhyLDZszKFuBIRNLwYdkqOPZL2TzryxcAbPTqgxWjSe2y9VfPYaeUalwpIiCiLhNdyFeXP0mqN7wh+4DkcrhIOviH3AdkeqbA9SJqwS68DG1SKNbhxSIrnxT/v6KavE+Rn1RsXiWQ8O0dJM12vWs8Y7yCUNlsFqWFkxsgko6Pe1VsFVLqdpDnzVKX9VsTuGWNx+NMXMuKdq99r4/KjpvlAO86DrZz39vPuL0N+ypCZKE6TDG+yCv5uxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D20ExnMSiU0M9nrgFPZNyiP7TmEqYqSD450kxRMWMi8=;
 b=t5acgvHXPWNrWXBOtuiAiqSkIvgzoZwzbtTzsaCW13dTaohLnKrDifD9+h6l3bX0Tlm3D9h+yu6BsW0BmLUx0sVSMxbil7FgnmQMouV+7h63yEa+WjkOcx3JDg5bDO2W9gAlKRh1dR/iC/TZZHy3MDG5RrUb861ufNdUltdQbJW/+gUI2Us3WN/RDDYipoKQUswImhEz7PmVaiuFU+aR/38uc3YvUoDzPG+n49AOnXCYvOwdOvlhpUTiVLky2tUBDMCAdSCAvoSvg4mXcP8t2LPIPEPmrT4b7Le9pau9PZKkubP/1njQe3UfiZSnDcYDFzKmZ30viDB1W3cH0N6MWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D20ExnMSiU0M9nrgFPZNyiP7TmEqYqSD450kxRMWMi8=;
 b=df6xq0nfrpazfNbjP/vRsRWuQS17FX+02anhuPgw5LTJ/uZ58siNVdKXLSri/tzz3Cq+h67+6OmGvRhFpd0Mj8Pz2L18HhBIR8j0fC23+3kpKsxoYcwItYCC6XDnhwXF0qF0cs7a9zg7iKinX3KQZRMSD42LTSeSlyoI0V3pWuI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB7230.namprd10.prod.outlook.com (2603:10b6:208:403::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:49:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:49:01 +0000
Date: Mon, 18 Aug 2025 11:48:55 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/6] Remove XA_ZERO from error recovery of
Message-ID: <3iptynmztv3kdxkf3gaz6cgee2v4j3lkd7aj2cgftpgcmyvgyp@sdemowhht6zl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <CAG48ez2FCsKNNaKa5Y0xBJTdtzptoCxM_+XNNg=bUMgoLDyC3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAG48ez2FCsKNNaKa5Y0xBJTdtzptoCxM_+XNNg=bUMgoLDyC3Q@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR03CA0340.namprd03.prod.outlook.com
 (2603:10b6:303:dc::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba76bf4-4892-4547-6d1c-08ddde6ec02c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2RzaUkzS0JXY1V6d2k2ZDRvTkdoai9GS0syT1AxcHBYSi90YWFKdHRtTm5z?=
 =?utf-8?B?OTIzVFh0OHR5ZGJZSmFDYzl4T3hNQ1RTUlhDTWZsbWVEQTZhUVpOOXhZUWlk?=
 =?utf-8?B?cy9ZaDdZeVIxM0p1YU1Gb2RYSXpEUFJObTB4dEtHL3IzQmhsZlZzcThIT1VF?=
 =?utf-8?B?TUNGbmM2MDY1aUUrZVRIcFRtaFhQOHhyR2FSZkMycVd0Rlp4TDVRNDVmWXhk?=
 =?utf-8?B?dXRBNWRuNW9iNThNSzBJRnEzRmFMdytlazVZUlhaMlpQK1MzWFZteWxHdllU?=
 =?utf-8?B?SXRLaHNVbXFZZWdpNlFoOHc0bkNsRWtDN1RDajBINExXK2ZQU09BZUFtckxE?=
 =?utf-8?B?VW9yM2dTRUVmVTZNaVNOUy9HTXBRK00wa2FScDlRMlcvSVdKcldzY2lrOFBD?=
 =?utf-8?B?Q09aSG9IaWVWa0Q1dkIzTkl6VytHMW5aWW03bkxrUzlJN1FKaVljVk93dkVt?=
 =?utf-8?B?dVRiRTYyRkd4bDlENDRwbmZZMWJ4VFM2Q1RPZ3FmNHhxajcvbWNmVGxYRXI1?=
 =?utf-8?B?ZVF2TCtxemFoSmNQSnNYa1pMOXUzS1hIQUhIUXFDZW43TXo4QStBa0N5TW54?=
 =?utf-8?B?M3Y3RHl5QzAwVkxoOWR1ZW9ncThTT09vSGxqYTU2QlRNcXZyWHZhcUN2OWVj?=
 =?utf-8?B?bDdNdTNHM0JjZmF0YkxQdTlWWWVRWUc0bWduZW42eGZsNC9vNk8xTTJSdVRM?=
 =?utf-8?B?SVlYUkdiNkJvVWl4cWtCUSsvdTJXZ0xCMVZSWGlyY2pBU0UzeTJBQS9icm85?=
 =?utf-8?B?RUtCdGJkeW9wbFJSaUlzbUJPWGpjbFRVTmRKRkZIU2d4d0FWazZ5YWdRTDBx?=
 =?utf-8?B?d1VaRTBaL0VZT3dLOXJDWldxUHpRZXpad3RvMTVrK0dwMVlmSmFHMWRHYmFF?=
 =?utf-8?B?TkNRdFhIWk8wbnF3K0ZMdzZLdDNvVE9kR3RNTldnc21ZNGZ4d21qWFZOSUgw?=
 =?utf-8?B?MFJrMWo4ZmJ4cUJyc2tnT044ZDdQQnFtZlpoM2ZvNFRNMWY0c2I3TUk3aVBt?=
 =?utf-8?B?cDFXVXFFd3JjQW00bEx3VjdEUS9XcDNnNS9iaXR4RXdVMEIzT1B1SU9BdDEw?=
 =?utf-8?B?dm5DcktBWHhoMVAxZ1Vld1J3TkoySkJjdlhkRmt1T0J0VTlZenlSM2YyTHBy?=
 =?utf-8?B?cnNIcnJ0TXZnVTdXZWtKUUlaanVuSkJ1cExVT2VvTEtxWkV2RWtLZlJDWXho?=
 =?utf-8?B?K3dETWRLTGpGSFhRR2kvVE5kS1FNWjVWVWM0aFFnVkVHK0wvcWZyQWkrY2Js?=
 =?utf-8?B?djB3YVVaSUU1OU5lMnZWWkgwNktKQk44S3d2N1JncW5DOTFsNDhXMTV0YldI?=
 =?utf-8?B?UklQb055VHFUVWgyZkNjS1JMR2FFYlVhblRnRnFhdFVRWlJwRE02UGtBUEpV?=
 =?utf-8?B?RXFPdzZWUERQUWNzaUEzV3FFRVFLVSt5aTBqamhUb0ZxQnF6bnpxbHZOVGRC?=
 =?utf-8?B?ZGVYWE5CaWtOQlVQTXlibnRUeThDZHk4UU5acnRrRzhMU0pST2JZcE1CNFlH?=
 =?utf-8?B?aG5oWDhsc2llTWJXaGZRVVFQR2lDTldlRkI4MFM2UlNHdG9vSDh3SThibEtZ?=
 =?utf-8?B?ZFV3TmprWXFCcUVhRHVQT2p1Nm0vY3RDbmUyVjM3UXV0YXYxTzV1Y2R5UGk4?=
 =?utf-8?B?dUlGWUFIdkIyd0FqR1JaVHJzWG1iVm83TUc2cnV0NENFV2FDdC9EN1p4Y2NH?=
 =?utf-8?B?eHh4dUc5TGZxaG16aHl4VE84QzlTMzErbnpQbThPTGR2MDFwb1EzVUR5OWdx?=
 =?utf-8?B?NHBxRkJOQW9temZZVmRkc0NncTlncEFpTVI4MHlHaG14T1hRcWozWnpvV3BL?=
 =?utf-8?Q?td2HZwAIs08glEaU/cgHLltyG402jCn5Bu8/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzErbDEza0U3SzFMWk56S0xrR3NYZUIvV0ZYd25mdmpjSXNxMHhCRGQwbXBB?=
 =?utf-8?B?S3ZXaGNGdDFua2hRNUhpVGpSVnFDbXZkVDZlcXFIWVhXWHQycVdSTjRnNEd1?=
 =?utf-8?B?ZmpFRXB6LytiTWd5cW9UelZURms1UStTMmViTWtmdnh5cGlxbTJuVmtHZVNG?=
 =?utf-8?B?VWhBc0MzcWZBcjIzV2FIcmhrNndUYXlBMHZEOUlkQ1hrUmQzaXIvQmFTRUVk?=
 =?utf-8?B?Y1VzMHFhWmRuZEhvVzdWWWc5OERGcm1PNGZQQUlnUTVGVWlOM3I3OGZCTUti?=
 =?utf-8?B?Y2l2bEJzR3Y4MFV1OGNPdXZQeXQ3TS9Mb0V2YUF0UWgwaThFUitNMk0ycUUv?=
 =?utf-8?B?aExzTXU1bkMrVDRkNWRjUStjZW5idXYzMGlkRjkrQUJoeUgvTnJmM1FkYSth?=
 =?utf-8?B?MU53MDM0dVFVRFkxcWRteE9zWmJmSW5nWHM5K29qS0dJUENDZTlKNHlGb0xV?=
 =?utf-8?B?SUNUbDl0OGJZWUZXVUhUQzVNVXN5OHRjdXNsTUVFQnJZZTdldHh0elljbFBo?=
 =?utf-8?B?YXpXeW1sQnZqbWl3ZGlRZStzZS9ZaDVHT3gwemRra0pJNUlqRy9lWDdoc0Nm?=
 =?utf-8?B?anFlc0xJOUJqaVgxSDA3WEZnZXdXZkFReUpBZWNPMC9aUmhtYmhGenNVcWdt?=
 =?utf-8?B?SFAwdVdqUGdvdlF5eUZnMjFUUU9rVXV1OFZvNkdtV1VPbFE3R2Z1Qjc0ZVcy?=
 =?utf-8?B?VWdCWG1BUFlpU242b3hKNkM5SXJoTjFWNGJUVC9pRUJ6NjdEQTd4VFBrQ21r?=
 =?utf-8?B?KzZSMDB3OXhtWGU4NjdHaWZvNTlrV2RYZ25TclBTT3FBclcxL3JQTmFIR1gz?=
 =?utf-8?B?a2UvVUJ4Q1FyMGhZWEh4WjA0ODZrTi91ZllBeE5XMU5UVi9ucVAvM2xpTnNK?=
 =?utf-8?B?c3orU2VBYmdSZTRNcUJlc0Q0czdWZ1B4QVF1enZSdWtNdXlnWXArWFREWk8r?=
 =?utf-8?B?Z2thSmxQbTRHT3B6VnhxUDF2aC80NVJ4TlFCSFpWbUpySGRSdnFncGlxZ3BY?=
 =?utf-8?B?eGtaR3lPQThaRGN3YmVpNDQveTBPR0NYRVc3MkRhVCtQUkZCSHZGQzN0c1or?=
 =?utf-8?B?RkJJTmRRckk2NGlSazE3NHp0VXN3RkZxV0N2RngyUURYb0RHYWVDQmdNc0Z3?=
 =?utf-8?B?Y053aW1wUHB4YlFJY1d4OFhFRFZ6ME5ZZ09ITCtxZFdkVU5JRzhuYis2WTZI?=
 =?utf-8?B?b1ZTT2FjS09nQjNPL0I3UUtrWm1zZ2FEdnhDaXBPc2VsZERGbFpIelVJSmVa?=
 =?utf-8?B?c2RkUmlTVUVMcDhUS1NIaFVFVkdWK1hQbm1ndU83Uy9Bekx2Zko1UW1UOUJG?=
 =?utf-8?B?ek1MKzU5OXJsMVFzWmk4WnVtRC9aR1hGL1lVUDkzVXozQmt6cys3M1JKekdp?=
 =?utf-8?B?L2hUaUtFTFc0a0dZUXVlRjQ0Y21hZ1FwQlhtSTZDT2hkWWNOSHU5eE9TOWFr?=
 =?utf-8?B?WmF0QlZuanZUQW9yTFdXWUZLNklQTUd6QlVzdlZWNFJudXg3L0RiMUJMdTgr?=
 =?utf-8?B?cm4xdVJHQ1VUUGNaR3ZuWTI2QzZJdklDQU1DUmw5MjZkK25EUzcwQXdieXl2?=
 =?utf-8?B?UStEdnN1cGZCTGZJbXZ6QkxySzk2cWxRdWhmV0dqVnJSVmhHN0g2dlNWNnIz?=
 =?utf-8?B?SW0vbnNDNkR3b3F5aU9rcW1nSm9QR3p5MThhWDRzeUwzdVNoYXFwUTMvRm14?=
 =?utf-8?B?MWRNcUdwTXVueFg3Wi90cHdxcGhIQU5EazBwR1F1UVZweVpVTkl1V0hFZFNm?=
 =?utf-8?B?eWo3Wnh0K2xmOXQ5VUVKZjhydXNObDdLM2lvamYrT09taXkyTkZBalpjMnA2?=
 =?utf-8?B?R0VuRUF0QjU0UDg5dkZJNmhKdlNhQTdwNVA0ZUtkRUo2ci84Q2NyZmM0UVBz?=
 =?utf-8?B?QW85Sm81N2tnUVlOQXVsbE51OVF5Qk1oT0R1cllpZ1hkS0NYNktrOElDaERX?=
 =?utf-8?B?bEtLUDQ1ZG1oa2M1dTQ3YUNsa2VCZUNEdndiTG5zMVFHQVQ5V2tsM0VtaWRN?=
 =?utf-8?B?S2xoaHQ1bHhFWWxuNjVEVWZSOTNRRWsweXROZXREakpOVmxUYVY5SCtVNkNH?=
 =?utf-8?B?MDMrYXNTU0srdy81azlWKzFocm1zS3AzTFN1endHVlJUc0dSalNDRndXNUEy?=
 =?utf-8?Q?onMUq8BCxm5vSJnA+tjkifbCO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gi+7wylrrdeDfieZhtW4SWDrBaESMK2SWcMY7ONPpt0rkfFg6Ng9o4LBsDs2D/IzNTSk8AJHByMCCAghiJuZfTeQU3H1FE9LpbSNF51szDWldN2aO8GDvfqqIBPYAgg+wIKkRnazFYia95/21sJkkjSAvfWlwGPfSuQpahI+F/aTNDyibL/eWXyG95TzS/KK2QED9MiN2z4Iw/LmlQ2oVQP4Mf94JA/YB/mBXnukn2nCn+eJxrG7sAAy8bup3XovyqCk0IxCZbHG3PWpkrOcy8iPocEUGVcYqWILmU+TIawxcXNTkvvwnqHFY1W2CpfQOfd/mVbd9V0Wfz8oR5v4evuSGyoVUptGbPd7wTmW/kPXLY3t5vYNHsjaXAwc7yjYigZ7tSKHqrc9YMAeBj5ntJ2tDFftnn64WG9wo5VPNoQaOkdkJYJm5QZnvoj1YyoE6V/c0XOD/sRDBWVVAUNgitfnIfp6OFflys0eDEjVW5Uy66tYtLX8kvYeKBK2U4r9yG6Ux0hiEfy0jQXpczkiSkAnZhc2oEKrGgAZWc6/vKDj5d9eOzvEaT7AyRjHVP2PjSCq0PY3KgAA0twHnEgdmk6cy96EBiy2leK6UKNgdh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba76bf4-4892-4547-6d1c-08ddde6ec02c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:49:00.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyDRfMI9GRk/VDjuskJXAo4hHqcqrF8CIFLNjPr3GIFJD2lW2wwPFUDiPMsSpwIAQh2muLthGqD6Xn3Z6MYncA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180148
X-Proofpoint-GUID: nV7S4BgBIea_yF2ZUZwkL4VLoJOkOWcG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDE0OCBTYWx0ZWRfX73Xh7m4EqtmG
 +8hzIoxWjsQMc+qqlctcu6hJEyN5c8bejuLeJXgopfnPNWgH3f1HcVit1Fl9kdXhG235MF1XyEa
 iVY+66Pxaqr+vBa0gQUS66Mgbsp/2ndDFMsjwa/jNZYXO+p/o/VqZpnm3rbahEXGoJ2cN+UsjnD
 rkOpNAor1FRCCOXXaMV1bjo41cKjRRHwgnife0Byf/VSSldfjM/FEquTr3b2sTuxO5RjBNa0knw
 VANRdkVs99QMuGPer3BwQxRfypX9Y4bhocdlxWFh7lq668uBhiKwOmws4EzagJLCro4Zr8vtvSS
 MQXSimNxB8AaB1GnY8EwZgSb7uychiTbat0y57m+xEyKoePNLq0RJ3+fh43vqcghPa+skjKAgqa
 DNDScNLj7cWa1TbSiyLUyjHC4dMC9sAkWuksCzHx1kI48pWcAIhSb8/kytz877jZfQycaDHQ
X-Proofpoint-ORIG-GUID: nV7S4BgBIea_yF2ZUZwkL4VLoJOkOWcG
X-Authority-Analysis: v=2.4 cv=HKzDFptv c=1 sm=1 tr=0 ts=68a34b70 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=8sZ5ufNaEvnPm-0ajrkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12070
X-Rspamd-Queue-Id: 0F1ED20006
X-Rspam-User: 
X-Stat-Signature: 9bdrgfbubd1giozaz6t8xryusgyw43cb
X-Rspamd-Server: rspam09
X-HE-Tag: 1755532160-824617
X-HE-Meta: U2FsdGVkX1+l1lBDv/Ci8jatJHHJ3NClPB9QgK3u/pR/7NHGZnrhXdJkMy4MnEekkdsOC5woIIW+WtqKFUX/WQcSAuzxpOEzVB4rlHt3ooyt6deuhVWTeS0dFGYxDfWczbsPq758/pEE+FXkMaCeb+cSccH61rLrag3/o13H6EVlCXt+TsgHMC5GH8o5nlRe0WR/oSuCf175wv8vPrA17IoynSmUNv5Of2YkrYKQvPop2/q04hkHtPUWmpGeX/+A1Zz2wFayOC4okpX4HKFKFDo0rhE5SXki5na+SDnoReMQE3RzifbFSwEiq9/OI2WNO/YhgmgTRaxpOtXKK+k+X8R+RuPBTxmYqRnAqMe2ISkmkDK/G3hrG0Fu0yxtNeKLfiTA0bUVhGpDNS88ybXlcX1h3aPrktUqHLpuSUBSJE1YPXmNyh+m/dXqjUPYktwEkGcpamfokuPGRSAXd+UDnZsZ0VeIGSAGT0Kmztiy4AjcWRcZ+c5lEralMBsPD5qe6mzAkKdbeaM6xEdRsn2c0HWhw8NIp5U99EIWkV3opDvLEW0wYuYgdNQA9+IbfRPVBVOj/d76ggT/cOzAi58PKFpw/z7ZPETtDpIINyCwn0jLCmnIj4PF6lxxRXmukTsZZIctt/+81Pa30CDZ+2hi64wCrvK0GJe0aU2Dqjs1F7XkEc5zQoDzcBQ3hOqN07stMLamkcDYF+VJhSKc799YeYf0FvFI+9V5tmZl6ExWkgC5VkiO+avqt78OwX8ELEkR7XakDfEbM9kGpKUkhpEh53ECtwwAHs1r0fzUXpYKlR99Kz/8FQa92bDtvWdiPopxLXKQ9YXxFF1ZZO7xxDGtNxTPBdLLxxmLnPBS1ewZulf7ShRDMLlKpDDsVLPulcFThqnYT/oZxOVykOcTI+muk2shu2Lim8RlQcWQx+sGrgcCDybWEgUjEUC1/m9nmoX24DRzhs8mECxbyMZ6Idy
 +CrbudmO
 RvXjBTpgZzdTt4D4lXwIoop2IbOTwEkZrjso+/+LqF9Zp8TE9qa34sSDGLGHowauHlX3iz6OzRNuX1W7GZ00gIF+r1AEkElHTb0eChRGrKaF83675vswrHaDOubv/XEUAMqv5gnCVkQQ2VY5rXxR/V/BG9lI1wHEeEUaEkvvdF7QQGoigl/gFBbeSACpLeND7G6lquW8o77FGjJULEqS3iUDhB1l/16j10Ykj83mr+JRvvQtw3c67ek+8tMzmF3j8J83ZOr1BQv/Fac8HUrQQwQ1u/556xMieIOVN/NzlEIAswVGknPGr1HtTaV68DMiUOyVHVurtI3lc5FAQQaEjU8HelaGPn4qkVqyEHS+OfCHLNhWcqd72SYxUGBVKUW+MTyizdwrVm0rLQUG8JY9KQRKi4RHv+BRln52uWgEGUCh+XgJws9wLMPZkDg/g8vX+Et6unf9VV/btQJFBY6XruKzh0wqe3iRASkuxtZGy8NbCURBKdgPZRkj7BSpRiipd26wOKruPdGgo02iN3xPsJgOi/cXcnSPkZSIthn91v19OUnFC7T1lPahQb9HSrMgIe90vEf1ffcRFGsY9CSk60gBOAytQVufmSEosUZ8zmqFYBL8J5KEIQpIr3qnibrTpp72Q5SMJNZh9DZQkKlakt/kTWEdRYt6bqXgiWiTp0+Nq9oymQd6FVBtknJjMHP7wApIDhaWI2iok6uifyhApQU23VQPfwSWwlK+RlZjt5HZMCNLpM0WH4f8s4jKKyGVoUSeEib5Xj7XQ5BmiJHHB8yucjEHyW9YvIQvu7w7IH2G/erkVxh0UgxsHNH/FM44hopy1crKYg85hqO3+u8kKAI6ja28/gdSXZ2bT9frU4U/97sKkkWiROFR3nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Jann Horn <jannh@google.com> [250815 15:50]:
> On Fri, Aug 15, 2025 at 9:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> > Before you read on, please take a moment to acknowledge that David
> > Hildenbrand asked for this, so I'm blaming mostly him :)
> >
> > It is possible that the dup_mmap() call fails on allocating or setting
> > up a vma after the maple tree of the oldmm is copied.  Today, that
> > failure point is marked by inserting an XA_ZERO entry over the failure
> > point so that the exact location does not need to be communicated
> > through to exit_mmap().
>=20
> Overall: Yes please, I'm in favor of getting rid of that XA_ZERO special =
case.
>=20
> > However, a race exists in the tear down process because the dup_mmap()
> > drops the mmap lock before exit_mmap() can remove the partially set up
> > vma tree.  This means that other tasks may get to the mm tree and find
> > the invalid vma pointer (since it's an XA_ZERO entry), even though the
> > mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
> >
> > To remove the race fully, the tree must be cleaned up before dropping
> > the lock.  This is accomplished by extracting the vma cleanup in
> > exit_mmap() and changing the required functions to pass through the vma
> > search limit.
>=20
> It really seems to me like, instead of tearing down the whole tree on
> this failure path, we should be able to remove those entries in the
> cloned vma tree that haven't been copied yet and then proceed as
> normal. I understand that this is complicated because of maple tree
> weirdness; but can't we somehow fix the wr_rebalance case to not
> allocate more memory when reducing the number of tree nodes?
> Surely there's some way to do that. A really stupid suggestion: As
> long as wr_rebalance is guaranteed to not increase the number of
> nodes, we could make do with a global-mutex-protected system-global
> preallocation of significantly less than 64 maple tree nodes, right?
> We could even use that in RCU mode, as long as we are willing to take
> a synchronize_rcu() penalty on this "we really want to wipe some tree
> elements" slowpath.
>=20
> It feels like we're adding more and more weird contortions caused by
> the kinda bizarre "you can't reliably remove tree elements" property
> of maple trees, and I really feel like that complexity should be
> pushed down into the maple tree implementation instead.


First, thanks for looking at this.  I appreciate you taking the time to
think through what is going on here and alternatives.

The maple tree isn't the first time that we need memory to free memory
and I don't think it'll be the last either.  I have a method of reusing
nodes, but that's when rcu is not on.  What you are suggesting is very
complicated and will have a number of corner cases, and probably zero
users.

Having a global reserve of nodes is something that has come up before,
but there is no way to ensure that we'd have enough to ensure that
things won't fail.  64 is a huge number of nodes, but there's no way to
know if we're going to hit this situation multiple times in a row in
rapid succession.  And since we cannot depending on it working, then
there is no real benefit to having the mode - we have to plan for the
rare case of failure regardless.

There is also another project to reduce the possibility of the maple
tree itself failing to allocate [1], but in the dup_mmap() situation the
tree is not the problem.   What you are asking me to do is to add a
special mode in the tree to work around the fact that the mm struct has
a life cycle problem.

If this special mode already existed as you have suggested above, I
would advise not using it here because we are out of memory and we want
to get memory back from the failed dup_mmap() as quickly as possible,
and the tear down is the fastest way to do that.  I don't want to have
code executing to juggle things around to fix an mm struct so that the
unlock/lock dance is safe for random race conditions.

This is why I think the mode would have zero users, dup_mmap() shouldn't
be doing any extra work after a failed allocation.

I see where you are coming from and that having compartmentalised code
feels like the right path, but in this case the system failed to
allocate enough memory after reclaim ran and we're looking at adding
extra run time for zero benefit.  From the maple tree perspective, there
is one call to destroy the tree, the rest of the code is to clean up the
failed mm setup.

On a higher level, I'm disappointed that the mm struct is half
initialized and unlocked at all.  Really, I think we should go further
and not have the mm exposed for any window of time.  The issue with just
calling exit_mmap() directly is the unlocking/locking dance for
performance reasons.

Equally, the !vma issue seems crazy because it's about avoiding races
where the task has unmapped everything and we really shouldn't be able
to iterate over tasks that are in this state.

And we have this MMF_UNSTABLE bit in the mm, but other tasks walk into
the mm and access the struct without checking.  That seems suboptimal,
at best.

[1] https://lore.kernel.org/all/20250723-slub-percpu-caches-v5-0-b792cd830f=
5d@suse.cz/=20

Thanks,
Liam


