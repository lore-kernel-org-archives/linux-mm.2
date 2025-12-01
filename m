Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC53AD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A990C6B00A3; Mon,  1 Dec 2025 15:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48886B00A5; Mon,  1 Dec 2025 15:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2AB6B00A8; Mon,  1 Dec 2025 15:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 713306B00A3
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:56:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F234C1A03EE
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:56:36 +0000 (UTC)
X-FDA: 84172110792.25.209CE6D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F04A80005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:56:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="NfZ/u4IO";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RgMZzwu+;
	spf=pass (imf02.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODBPFm4dj3OGUMeNw4RLKTjssfaSGZ5VYDBBPpN+w7g=;
	b=ULorvtz79BU5ZF9+Fb+WP9/qTd2sx9ON0fswc6HVoXPM8g9XNk2TxJ088Oi6+gh5Gi43KO
	vXCqFw+oiovPr87SRnoHsC0/xKkENlrhMr8H8Q9DU8CGl9pZ3CNCpYn+FRlGM0mccVLKTT
	nUG20Rz84Edg1JW1bMmShKNXk0urFT4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="NfZ/u4IO";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RgMZzwu+;
	spf=pass (imf02.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764622593; a=rsa-sha256;
	cv=pass;
	b=XqzHHAd5Zh614lb9xcIC14Siy35NXAVYmfd8PwiAifb04Y2OhZ2hfsvPDzh8ajU6sqgTXT
	OhPf4ThrSiR04uxUfqSvANkMKA0NRjocrqgu1k9j4KHqgyy1K1kNh4CcEiHbxE3o1q900/
	G1x9wgD+zpbMR+Zkzx3zmFlxMGdn5e8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1FgGY72363830;
	Mon, 1 Dec 2025 20:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ODBPFm4dj3OGUMeNw4RLKTjssfaSGZ5VYDBBPpN+w7g=; b=
	NfZ/u4IO4WAiJ2wa5vsOuh9x6jPWT7ZrsMp8UmrwCYVag8KLDUf3DTpTiz2e/cPn
	+Ns0fvXbPqXjb8BtjfpYJE4I5zzLrIGsNPae1Ge9vMzBJ/13W0N4+28cYSuYj1St
	z0BAWSrgurfunjj3GP1FPHojzPToLQiITTUa1XPG2V8UtSfCK0fKNI9a70WO+p6B
	YjhbU1KFVHfdxaKSti81jUTTqMAIbK3T4nR+Gq6pSOv5irAWEDkz8oEJPoc7Tu4s
	TmfRFz15J/W8xYOCSWCIMUNzb3zgcSZcOVuAl11Wp2lpR5D+1FT6SDsOMKkXYJCF
	xIp8cA42g84g9S6X47NqMA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as6v39gsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 20:56:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1KtZvT016554;
	Mon, 1 Dec 2025 20:56:19 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq988uf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 20:56:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D31WiJV1bvqCW/7tTIrH1aas7ay2SCflxNDXz1wGy+2SYAwLcdgb9++DLit3yftd8Vz4QIOxQjYftwo/3NMon36hwNf5lBVBPJT9OYHXmsJ/SykuyC894gKBeRULN41V3lTQ5xKwrdEmkivPMq7IdmIKzbnTVLk/Hj/AeW3uuUhwN2PeUNZqJdLEHaglhWdfruXNNaxR46ipqy3zZmnqneeYjFq0B4GHCB6Yn/5jlblevgXPnGmQW5Mrw0UaPJRbeuabymBDeNtxrT5Zb0vCpfgX5hp+meUbk9jNgjd+yga3cQn+qloSWRhDdDPYDzPcFDaNmBP1DA9M4Vj7BigpVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODBPFm4dj3OGUMeNw4RLKTjssfaSGZ5VYDBBPpN+w7g=;
 b=EXjrqCMeEKI/hDm5MM4Tvp11kSVc6hfdvZRzjsQxDHypbhiy+pWR6VJl+HMJdDkvowsc7GeCQKJLPQiAcZQ54sZfLOEE2ieKa8IBBgNSYjwld6uhtB8JXY6AQ581iZOgSU1VUQ+B8ZSZ168Zi9Nqlrway161zDUw4MAvxMgpBJJdA6PreyahilD2+xVA3Y2go0IlaMkjbOJr7AUxl4hLUt1P8tQDMH9Jt5DatGSLYQ1+SZBRfwphuIVL2oIQkHdH+BCAZlKLO64H3yYNZznhH1ikOs1cRsc5AFrGLJ8HwyigDUzKuar3OwwZYpa3GsUj/QtSutkr3IxU22dCMV2UCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODBPFm4dj3OGUMeNw4RLKTjssfaSGZ5VYDBBPpN+w7g=;
 b=RgMZzwu+YwfBgrpqDok/vVDVUdFxWUq8xnhuWRqyrHbRWHXAlp57tiPkXB6LCwPtF3dpFEawi4Q8et9aiReM2n28HW4CezNdEYXACNdZn9Qp7V70Zv9qHRhhEHSAuI3orsRzwPDHqVF9kAQUTWuKR9gIY6nhpO9FuWzJIiPQG34=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 20:56:15 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 20:56:15 +0000
Message-ID: <e32f61a9-0461-444d-b008-bb09a3d85510@oracle.com>
Date: Mon, 1 Dec 2025 14:56:10 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm] f66e2727dd:
 stress-ng.rawsock.ops_per_sec 46.9% regression
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Lance Yang <lance.yang@linux.dev>,
        Liam Howlett <liam.howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
References: <202511252236.33b899b3-lkp@intel.com>
 <16995732-b7b9-4121-be36-e912a4154958@kernel.org>
Content-Language: en-US
From: Sid Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <16995732-b7b9-4121-be36-e912a4154958@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH3PEPF000040A4.namprd05.prod.outlook.com
 (2603:10b6:518:1::53) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|BN0PR10MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: d947bea3-5c39-46fc-4c03-08de311c110c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDl2dVNmbmttbGlBWURSTnRydjJadnJFNzd4Y3dlZDBvODVEc3U1R21EUWxs?=
 =?utf-8?B?dFR1QU5WYnR5QnVvRDNPRWxOcTBwWFBNNHh5Y21Zazc0U1hvd3poY0JMOW40?=
 =?utf-8?B?WExxTDZ4M1M1SDc1R0Iva3h3dGVveVA4VUJUR0NxMUczQXdhZHBzWUNVZTJn?=
 =?utf-8?B?RTFQSDhEajhkaFlXdVorRU11dUZGYngwNmpyQTVURnVxNGJMR0dORGNzYmdJ?=
 =?utf-8?B?R0R4eFF2ZWxCcEZBL0FYQ3hrVmVtMm90U3JMVGQxeE82SElTOUsvYVNSc1Jm?=
 =?utf-8?B?OC9aQ0ZTUi8zR0lXYThGanRGK3VVNElvZTVTZ2RGM3ZNWC9hclU1WUNPVnJl?=
 =?utf-8?B?YjRtNDRXRFZBZEpQSXhWS3dlSUhNR1U2NE9CRUpKeEFtUjVaUVZhdUhkMnd2?=
 =?utf-8?B?bEdBdCttdEVYVVZPanBVT0pvT2JMNGZwa2RtcEttamVuOE5hTUYxU3JSajdk?=
 =?utf-8?B?NkM4R0UyYzN6bkJPbm5aTjhmMTlPOEpEL0JDbjNiNWlvTitJQ0JXc0svU2NX?=
 =?utf-8?B?clFmZ2txc1craUNwZkRHSDRJZzgyRytzdm1QSHpmTlh2UzJyUS9ZZHlWaVpv?=
 =?utf-8?B?OEwyMEtmNW5KcDJvZytsMEtlMzB4eDI3bDI3SE4xYVZsODExYWRZeWlEdFBk?=
 =?utf-8?B?ZGZqc3hzenIyd0todHdWUll4ci92R2EyblpEL0U0N1oza3BMQzBzRHA5eWxa?=
 =?utf-8?B?c0xvSU9RRWFydnMwOC9nYnF6bVd6MFpCYm13ZEZmTE1ZeXRKMFJHWFBRLzZl?=
 =?utf-8?B?dHRIdkduQXdPdmtHb1c2OURpejAyTVNObDhuWkNJVUVKR1pRYnpDcTVHTlhU?=
 =?utf-8?B?Z0xucEZOZExNQUZzTVVDbWpXaGJFenNrR0FaczFZWkFHR3dQcnQ2VGZ3NGxM?=
 =?utf-8?B?ajdmMDd5eHVyYTRxZElxcEFIakVEcThPNTdtUFc3VHlDRnk0dzZiVUlSTk9X?=
 =?utf-8?B?RWpydE9ZQi9XV0YzZDlvZTZLVENaaWdUcXVuY3pTL0NIN1RqQXhqczVHNEM5?=
 =?utf-8?B?SDM5WUZKWmFhdUFMdEw3OGJEZXNNbGhzWXR6c05GTkJVeXVXVWJ0TmlIbjdh?=
 =?utf-8?B?NTdXcmVmV1ZsMXphUTZpdTc1S1BhOWVRSkdOcDBGZVhBY20yUk1uWmFUVU5Z?=
 =?utf-8?B?RVcxL1hsTWFReVVtZGVYY3A0UlU5aks5alV3TE5xODZBQjNsQTZ5OUhxYkhR?=
 =?utf-8?B?b3pjOTNIYTltL3duWDQxeUdNRmQxV0lORUYrb09WLzVZQW1MaDdMc1JTaGhW?=
 =?utf-8?B?cGxCd1FDOXMyZ0QwaThGT1lIazY4UUVKR3ZaTVkyZW01OWdXeS9qZEZpdVJp?=
 =?utf-8?B?OHlHSTlKQzRyNW1oSU5rd2VlZ1VXK3l1YUdGWlFsWTVIdm1XMVZ0UkRIVjNw?=
 =?utf-8?B?SDRIWmo3RzMzblJrcWM2RGRsWVhITUI4dUNYZkI2WlI3aVg4K1YwK01PWjlt?=
 =?utf-8?B?QzdEVlZRM0Z4NkkxTHc5YWVnWlVlZXpLUitZU0V2Uk5aTUpVTU1oM3gzdzZY?=
 =?utf-8?B?RXNCajVianhLVVd3c3BTQ1VmMjNCMWhWOGZ5dWs1ak9DWUY1MUNqcHI1ay9i?=
 =?utf-8?B?bWs5NHRiUldhUDJnSXFPclNMUUwwNGR4TmN3bzkvUVY4YUZMMWVwTm14dy9W?=
 =?utf-8?B?UEJRNGZsUDlsa3gwMXRRbHEyeDdyKzI3enFvTWV1cTRBeGYxN1VXbVBIR1pp?=
 =?utf-8?B?eFppTEMxZnl0UGoybWRWWElMUDM3bmUrYlE1NjNYTEsrSTJldkkyODNzclI1?=
 =?utf-8?B?N1hzV3E2TUJpbWVPRThGTU1hUWJNeWd0TkZmaElET3JUOUM4c2VLUXBVQnJt?=
 =?utf-8?B?dFpLbWgxVXp1eE9WV3RlY3lXMzY2L1ZMUnd4VitaenVTWU1sUDI2WVJ4V1du?=
 =?utf-8?B?Ums0ZDM2MGVrcFNXQmVNYXhSREhCTDFUTkVLd1BxV3JSTUJUV1V6SmQ1cG8z?=
 =?utf-8?B?RHUwS3ppenFrS2MrSWlwSzhKbkZyY1hYRW5TWXkyeVMzZXJENS9KR3AybHVk?=
 =?utf-8?B?c25ObDljOE9BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmptRWtSeDJLV0dNNkxKZHU2a0pRellzUXlieVdBQzhEbElsWU1lKytwWmlB?=
 =?utf-8?B?MEhwVWhMZDVlcG9zNzl1U1dUYU5yd3ErbytGeEtaSStMcm5vTzNNZ3Y1bk0r?=
 =?utf-8?B?MkhnTEVCcXorekpRdW9vZEFxaFNxQ0lIb0dQVW5yb3hSRmtZNHFVUW5LRjM0?=
 =?utf-8?B?cGlHblgrZ1U1VUZicE53UG9pRXc0WnZCNU14QjVQaWNuakY3T0lMZkNSQW5k?=
 =?utf-8?B?K09xRjNzRkY2Z0FBMy9YK0JERDk5Wjh3Z1RHUkFDOTJST1VuY1IzeHRnOXI1?=
 =?utf-8?B?NnVYNDhsQTlnRGptbTRTZTNHcWxTYU9WaTlwVmFTcDNXUFAvQ3ZSMjBBTFlx?=
 =?utf-8?B?WXp3a2FrWFRiVHh1VGtQZlZnNkRXOHlyOHlKdkdKRVh5UkM4dG9LOGJiS0Zv?=
 =?utf-8?B?UmVpM0M0YnNXK0RCcHgwVG44T0JMUEZ4ZFA3YUtRTnd1QmhzUjRrajcvR2FL?=
 =?utf-8?B?WGdZV0V5eDU4L1RPcU11OVZxaWdQNTZpSTduQ21rbFMya1ZLVERjU0ZsUU0y?=
 =?utf-8?B?WlJGZ2tndTY2ZTRNa3pRNGc3VTFEZ3NuODFUWHNpZklzcng5cStJRCt5RXk0?=
 =?utf-8?B?TDJ0N1JHNVJ4SUMyNlNsTzNVOFk1aUtmTWhrQ2FnaW5Na1lxTXlna1VEQjc4?=
 =?utf-8?B?aUptdkJ2RFlSTWRDTFhOYUJDdWpsbEJudGRGTTVrNGZTSS92aWROVi9YYlMy?=
 =?utf-8?B?Y2dCL25TUTRieTJMVW9oTStDY1NkbXVyWmp4cGd3MUM2eDV0RXhOQ01WYmRG?=
 =?utf-8?B?U1ZxR2tLTXl0NTFoNUlteVVxTkJoTGNQNUFRWGMvZjNkc0tVbHV3aXNEZTJy?=
 =?utf-8?B?am5TbkR6WGVUa2NwRjIyL29LLzBiQ2xkaTFVMjFlczlUVFlxSVdhaVR6NjBU?=
 =?utf-8?B?cWo3SUY5aFlKL3NHZGI5UXd5Yld6dVh3QlVGYUFSdnVXMFNlV3BrVHJrMHVQ?=
 =?utf-8?B?ZWR1bGV1QlB2YlA4aVBaVGJ6eElrdmJRbEhPWDhFTTZkUjlmSjJsT1FQeWtp?=
 =?utf-8?B?anJBck0zay8yQXFiSFM3cDFMd2RmZ2dGZmlMd1ZrRzNaNWxNTlNKcDZFNXh5?=
 =?utf-8?B?MnFQNzVSNmM2VkpjV29keWNGT3p3ZlJvREpJeStLYTI2MnlEY3hWZDloS0lq?=
 =?utf-8?B?Z0Vzd2RsZTBkcWZtV0RPdTdNZUl5VTl2dE00WlR6Q1hBcFlRbHhqVUtWaHYv?=
 =?utf-8?B?MjgreHcvclYzYTFjNVVuL2V1QjJmQ095em5TY0lZSXdwc0Q1V0pFaWFuQTBK?=
 =?utf-8?B?cUp0ZDRiMG0zNnpETzdTalRLUFlKV1VxYjV1Wk1JcnY5T3RUczZoME1XZ3Va?=
 =?utf-8?B?Q2VyV0pWaGVncURWT0FyeXdKWlhGS3BhU3lsNXlscW9ISklLTDB6TWdxZW91?=
 =?utf-8?B?bzU2TGZ5S1B4OU5GN0Fyb2JDbXFKSXQrd29mbHlIQVFydVJSUWRldW5ialdw?=
 =?utf-8?B?WnR1eldOMlpuVWI5VEcrTmVVTGdGejA0N2dLUW5hckw3UjVCUnIxdjdwSGIx?=
 =?utf-8?B?Wm1xS1ZwUWtOaDNpSzNJcXV6czloZ05oMDJoR0FNV0dCY0IxNW42Z1Vtc0RF?=
 =?utf-8?B?QTN2VDkzYTc3aUU0cWllTWhTRmRvczIvbVpLUWVxcE9RVENkeUt4VkhQOUgw?=
 =?utf-8?B?emJMU0lMMFQzR20wZWFJOS9Sa2h1K0IrOFdBWHJPMGZXTzZYTkN3K0VMTFpo?=
 =?utf-8?B?eFd1dlJXaUlldFl2aExxRHA5T256aXFtUUNJclErOHE5UEVvQ1ZkY293dUZr?=
 =?utf-8?B?L01ZczljR0k0WDBQWkVTZVhldzFRVittUitzL0lpcG5RUTNHN1lVc1VoUUpp?=
 =?utf-8?B?dnp3WHRVcWNhL0ZjZnY5MjBvMmxlOVlwZ05YWGhvc09GZjdlOFhVZFZrOHFD?=
 =?utf-8?B?MjMxcHEraUlFZWZlQWR1UGc0YWZwOHV4QUlCVUdrVTF6b3cxMmNIUGlJMUs2?=
 =?utf-8?B?cXlHa1N5TXI1K25MTG9vVUsrNS9nYW5lR0NQV0NFZGtuNW5iV0txajRGTktK?=
 =?utf-8?B?OVdHMGVybEdUbXVKTjczZStZSWNFV29wYWE4MXY3SHA0MDJtSFZRNnVvVi9T?=
 =?utf-8?B?eWMxWklURERNZEZCUEJFbloyM2R3RzJZNmVsRWVmYi9Wb1hpY3ZCSXpXdW9N?=
 =?utf-8?B?ZkJ0QUxOQ2dDSllLdE82Rko1K0FVeWdrSjhGeWlMYmVZeUxzY0FyUVNsMnhI?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	61rtKCZWqkphKcrtP9OJltFxE08PjTKKTtgyRSatiGF6PtysMISCIKpxhSPIZkD4dEvOC5ND9JMFBPrSj6tsHJGdVzoknWFe91ZsbS6STRpDfmcmhaYYM661UWRG08BH507PFxE4d++seG1OSqbsSrKv9zyvRoTmEO5VGrDV21aPyhKy6QjX0PG53Aa0QwGk0Jn+hAVzz3EXmAbKFXmw0B/W5rGKCGjTkzDz8eDUmFpnyB5reloPKk+qRkCfV5vXImGHlAzTiU0mPmei0RZCta4YAJMcQ6zTQfAd82yj03tq33o8W9czBOqlCRNNWEJDxY9MPebuD7EIXtQPL/A7YdmF1l+76PGq4FtBR141XH5jr1HUoZyufowQZscLGsbAiBwYqP1IqcNtK0R5XvDg2mXreCWuaETHPYDPr0PToae2bkaCTPe+HwzbsTwYapDZMrjUeIJnI6nRiSWMlCzz5Pw9PmwlgEcIq7FHK5nNW1zMOLab4jFtvFQMg/H+ezN/5rrIViYcHDvkKXYxHlGU+Ib4TdNdSEKWyWnEW++d4CN61SBbAc+cyZtPPaj013q4RzKmP/dDNFvY3jayjMx6HuuOqLvRnbdRNkEbqw6KOg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d947bea3-5c39-46fc-4c03-08de311c110c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 20:56:15.4680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQsGc3K+rq5lRsbq3wp0OTu1uLG96f0AWGQRWicSgHfI/Jon04Ou+N89SRaFabUaVJVQQZbBVM8mTQA+vB7vHaGI1QYWxvumlNFO1zrNIzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=948
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010168
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDE2OSBTYWx0ZWRfXyztEmjpowcgl
 XZU9Xd7q0lR6SPWgf1+JYDP5LYWxCX7xPpIbTfg3ixRgMJd1Ih+FFZMWsbQILJGtMu5O0GSv7L7
 5Ab5p9vpPsqnLl1tz1zzh0n5657AKey+sZ9mnaK+dQvWrJ/1Sxp6L+2URF/ftJxD/NqxOCMbkdu
 U9Y37Ro9AWberzMyaLShqTODHlFIOvwgFGVbEAfqEdx+QZGWreePeaTdJa1QYFrV6f+BtsgYdNa
 qA+pV0XzeJ2k9yDdcVYzHP6tusuMnoDOothy6HlDVFnfRxz3F1jCszyA1cZJQFE3Tc2lpUtA4ql
 G9xh528kzDSAJtm5DaNBftQqa/9owhzoo+90AX6XhRfXjKjAUbs+O7fsjBlynKo0SW1qL9q1WhB
 V/nLPNTXBy9zzTg3QPtrtAC1hu9iyw==
X-Authority-Analysis: v=2.4 cv=fqjRpV4f c=1 sm=1 tr=0 ts=692e00f5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=4vCj9qD_zc8sfylniEwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: jOCWuckaMspQUR8r4ecUbXBV9ioD79jk
X-Proofpoint-ORIG-GUID: jOCWuckaMspQUR8r4ecUbXBV9ioD79jk
X-Stat-Signature: myruten74pfohmqd8wrs3zxj9pwz8z7p
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F04A80005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764622592-608679
X-HE-Meta: U2FsdGVkX1/csJu60ptgUqtBiMzkLX/Cz0tQOa96UtqLVxdxUzabzBy0SJQBQ6DPZuBrCTdPfaMZK9g+T1ab6PP2N4YzLc4fBqYLacJrDnPvD9E5GTz9ASYncJI4094bjXI9FnOq+mMpJFUNOmDPYD1gAdiqx/xSAdxRsqlXeylQxkLsmjLJkJX03Xx0xkLhoF0tprj4iodhNDSeeFuNJxIzXcOE6bQ70QWMYSrzX6+8IIaCmKrMpe5VXdQxslsobQQQha7dzlWyT3pkIW/3V0BxpINE+pCAzZTEsjqZosGGQgY9PdR4D3LZwKKQUd4MKNHffJ98N/QdBdgcCo+7jjt7lXYyMZAhYvGr8vQd7FrEF2ZVQm3s++lPumcXmErTuWD0HyXkalztnnRiuJoMJmF3d/0bz3LjUPoq1V0hb6GUBuqxAutw85qYsvMvQhjBYk6gLk/npiXLiGZevZDlhxP0+Mmgl1261eFoZkoWUYObhd+lMnaxRAuNqAexKjj/2uW1ggvhUx782mGNftrYMxnxpF1GL7noIO+8bysx6NxAW8sa9xYCyREa79TSpM/EXuFd8DhvLCvNsBQ+RQwK3SATSzLLVxYyshQyhSxz0tmIgbMzVcWwxO8AbbfFDcxoNixaOKXMgKRbqmRJdKAN1FIDy64YppslKNyEERPm0KMh2ZbEZKOs0csakmQmMeHFhjsqQ8snORBMXfj1KDFe2i/jv2XB0vriCi4JxORddIHciUWtepAgb+DZ8UXH3/BYkp2fmjsWQqdrV3Q44UEy3jFa05Hl4cWCre+OBpOgF+pmLlV1aa+XG+EEhK8K8cNqFKSqjZozLuytz6RRLwVpHzIpjZmx8l+jSHNTs350XFQHnG0gcVPCSj4z/U1KU9eJaU1Zh3mx5AH1olnWIdECgvLBN2sgZhoxukc0SGUh0tL1L02fL2BXg25172VXwRd9lyUvqdmd0gAxF9hv2wD
 /RkBy+Yd
 d4oG5TKB5iyV8hFNSJmWnL0gEnSR1eHOKLF/eZmBkHXbWPboX0KW2e36wfelqt+vA0/jHN/q6BLbc09AlUCWn7YI33jjCRLgfjNUfHjJ/dduVF6yuSuw5zIRjYlb/KTJhv+VZS3yGVIMt0yWX/Y3z7HhNFUnDhKgSdoi2EVLukfpqQhMsiuJ6ghQnr4mZKGKCbf8boMkqrgil+n/KJicjOggoZvGT1XHohqje0s+K/5G+sTPntiQhn0e4bc0wCa1B8rIdT0eNiq354efchjuhbNiQSRcnp3LILy8ZvMDBLCPzqSB4NPbCaq0ia+SLoNuFGn1KQQTLtOtlFlT0i1ALy9yWG29e+piDl6QUMMvXD2xITlQQCX3tATkWsIrkYhCEhTzetMXDI8T4CYHQZbFXmGnsAedZ1+J5SbZOaJZLC/77rwxY1TxLHMCmDWzlMqD+IbI9Y2mUryrS/pZA41zEACQZpiKwOeBF108zFIf5ZWSvJE4uwHiN2X2OystUTCdrqYCRhDJVTekFTvX/yn+K13zWTksG3OAjxAr29lTW3ZBdCLoISuv2yG0Om98uMuLdmASwFqdz7ssUXe82GJrXoEYZ8K97er8b6CM5oh0fcxXXF/1o1QELblkhKyvdI/Fsly/3pspWvM+iPmLcVcixjQzaKbQGBCn4f32vigIwKk1f4+YS7VasnghyOZN46tMacksNtp8tBp61HfTsTtmShHNqlNNlBrQGVrhy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/26/25 3:49 AM, David Hildenbrand (Red Hat) wrote:
> On 11/25/25 15:46, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed a 46.9% regression of 
>> stress-ng.rawsock.ops_per_sec on:
>>
>>
>> commit: f66e2727ddfcbbe3dbb459e809824f721a914464 ("mm: huge_memory: 
>> use folio_can_map_prot_numa() for pmd folio")
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>
> Unexpected, but maybe simple a symptom of doing the right thing?
>
> "which skips unsuitable folio, i.e.  zone device, shared folios (KSM, 
> CoW), non-movable dma pinned, dirty file folio and folios that already 
> have the expected node affinity."
>
> I suspect skipping shared folios or dirty file folios might make the 
> difference. The benchmark results would be misleading in that case: as 
> we shouldn't have migrated these pages in the first place beforehand.


Reproducing the benchmark and adding prints to show which condition the 
return false occurs in shows that:

     /* Also skip shared copy-on-write folios */
     if (is_cow_mapping(vma->vm_flags) && 
folio_maybe_mapped_shared(folio)) {
         printk("false at is_Cow_mapping\n");
         return false;
     }

virtme-ng% dmesg | grep is_Cow_mapping | wc -l
25302

is the condition that now fails and leads to the regression.


Thanks,

Sid




