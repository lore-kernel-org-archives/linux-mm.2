Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9EFCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 05:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D6B8E0003; Thu,  2 Oct 2025 01:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF318E0002; Thu,  2 Oct 2025 01:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F5F8E0003; Thu,  2 Oct 2025 01:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE228E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:24:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 747F713AA03
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 05:24:18 +0000 (UTC)
X-FDA: 83952033396.10.B4676E2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5F1140005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 05:24:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OQB/Yh1l";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ed8JIuW9;
	spf=pass (imf04.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759382655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+ptFUHzAeB+KExlQVxXtn8lTbr88MM9nvfDyTIUCBM=;
	b=mlvjkMH6+YzK2DxFaGXXFPayCGv0oVdy/Rk7WHwlDWKWen6FznOjQXYQOwdcLeqBeoT4Oy
	K9K3xNbZK8RGNMdAhimZnJMBBVpuMmKt0pJeBcdNMIWWfgiHajogNOgi1vlfJSf9tKvRPw
	WRXoxj5NSHsTAXTviaTalJJaKFSzkTU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OQB/Yh1l";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ed8JIuW9;
	spf=pass (imf04.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759382655; a=rsa-sha256;
	cv=pass;
	b=AT0MdszETF01vsR5NCuE0mfB2qwVFwkmpFUiiA2i5Guoh0B38V3pk1ud2+sczttpt4x0fj
	nYWepIfAmLY0ASm617Hi+f7Na3QAl6HEYmUCu+V35jtXT+fXVSupBwDvT4/WUV49HAOnt0
	50YGR8V+4Ifj0SrXZkgZEi8L0faeUPM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5922Mvtn028539;
	Thu, 2 Oct 2025 05:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=S+ptFUHzAeB+KExlQVxXtn8lTbr88MM9nvfDyTIUCBM=; b=
	OQB/Yh1lOQC+1CDyAvpVAN9KbTdgkDLrbRWYKs/awUixsOM1TXS262hyRHxlcxr3
	FnA8t7aculQprVj3BkzLu8rM+9gDfuDtLis2+EbfsOgu9vDIJpODHxLOiqRCyGXO
	eyIxDIRnwR7Yu4oCdDnmqwGubai9qgTX8g7UhYYjXe1vZLNcVkzlyEAO7S7JS8r2
	VVi+mejsleCdZgRjhgrFzORX0+T6gZsUfk0ZXNDPg+uBQG3QFvfm8dLH62MNIuEq
	QGGYxCa15R6oXwB+vKPeCn4v7gBZ6yqRGHsmgqv4UC+WFxvror5+JWVKArXPNXwK
	fOFVehHZh1vmvgUpM1FGjQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gm3bjrst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 05:24:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5924eF2Q023209;
	Thu, 2 Oct 2025 05:23:53 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cb0mbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Oct 2025 05:23:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4rJ1CMFGAt3X1U+RzyhQzpK9wcGoYPspg8DvgvvicCF9VUwVnuDNS7zupQczh3kmSdwGUuNYVbBgVEV5O+W6LW61IuoBj9ZHD4JuVYwGnN0Jsu4mZGBEI8yMVajwVU8euZpe6R3C/kaghHpci/xytlFeyKe44hLa/uaJFCmvg2QgApnxE7TmE/+ZPyPbLg/N4Vxobf3MtRKMDeqMDyEpxw3sNYcl+EB3qJSvORJ3crcRwKzP4G9UDHnkw2ZoJEE4qW2RiKrEnqDnCAB4n7YHv1AIe8MasREX3pFhp4qQZeePkirlOOolNxk/Z/EHUQRIT6iiWk3AqMoES6BI8w9bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+ptFUHzAeB+KExlQVxXtn8lTbr88MM9nvfDyTIUCBM=;
 b=mmK5E6Uem2ZFmWnz54RN4NvlUWuUaZjW55TfCdFbF2MFtBG1uSoIG03xDtPat20wGwNwfKDk/yxGOVYeppqmFUfIDDz0XCh8GxCTsG1udsV7FZvp2OuSl33oPZSJEEMn1Cy/QlEGg+/4crwMvN5WPhHgnkS9nQ2Ei9CFn8F0zAJCmd+eZaZCEUX0T6eC/W5y3UBJEBblAvKFZ0+ypHiPqocHKhi3gS4hGQKvD3AjA3zrjXDDqLVwLUrshvOuqnzUhoj9HhBmLmQm99j58u5CjD+X4GqEREhruBPZMKBc8BDP0UjqPf76osxvRKSr4pzbHYG8xMCOBlN0r+JfFL6Ong==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+ptFUHzAeB+KExlQVxXtn8lTbr88MM9nvfDyTIUCBM=;
 b=ed8JIuW9mYN2tLfIgW9OG8xPHf7WXH4MBhIYj9WOUj5EmPzDswumZVMH8pZRl6VBUCj6CVONmb1x5q/PWHpnDMETVD4i6tKK3dZWHfyX+rXlqxW7eB0xFiUMT9VJH1oTRSS2jb5OcSbRPRQ8J9LP2iHp9Ze0ax47rDolHEFY4KU=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DM4PR10MB6085.namprd10.prod.outlook.com (2603:10b6:8:bd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Thu, 2 Oct 2025 05:23:33 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 05:23:33 +0000
Message-ID: <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
Date: Wed, 1 Oct 2025 22:23:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Zi Yan <ziy@nvidia.com>,
        syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Cc: akpm@linux-foundation.org, david@redhat.com, kernel@pankajraghav.com,
        linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mcgrof@kernel.org, nao.horiguchi@gmail.com
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::24) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DM4PR10MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b7eb6b-ffe4-49f6-c323-08de0173d466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUdZMXZES2tMempoNmZjNWx3dVhBdk1IbVl0SUN1aXVzcUM1dC9GaGtBQjBH?=
 =?utf-8?B?RmRDTGRGa2tYUGFPeGQ1RUlRd0NXWnVKbVhMRXpBTEtjbGk3bXRUVkVNcGhD?=
 =?utf-8?B?dUpLOEdBOFF5Sk9qUUxtRXpacytyTUpiL0lzQzlGaEU2U3VuNlBQR2dXWVpy?=
 =?utf-8?B?MVNKRGxIUWgvc1NUSW9jVUlqUFZVTVg1TlJRWVJHMmZ3bGt1Y1NIMVFQVDRY?=
 =?utf-8?B?dy9od0xUQWhEMzdaV1MzL0ZyaS8xMHJvSFFLRDdiMlBYRHhBS25LVitiWkFr?=
 =?utf-8?B?UlpGQ1hKcjlxdjhMRWxweW42amRlSkJIR1B3UFdTdENRRUsvYWFqV2xRYWFk?=
 =?utf-8?B?OTV1Z1Z3SW1sSkowUVpIL2dieWJPU2lHS3NMN3ppK0xBVFFYNGFqQmVCczFE?=
 =?utf-8?B?VzBzcmdEcjBlczhVUFkzR1NqNStRdjFGV0V0Zk05NHAveS9VR2MzRWZOY0sy?=
 =?utf-8?B?NkV5cWQ5ci9ma1luVEpxNXpVNjREc3NBcXFTMmY0NXdpVUc5TnJRYlM1NldS?=
 =?utf-8?B?L3ZyT2QzaUlsRWpRV1dqSWIzRTY5RmptdWFwWGVRVlNTUVhTaW1QcnZDa1FX?=
 =?utf-8?B?YTJ1MWNnQy9YSUxDM1IyQVZTYlBzN0pzdXBteWxWQWMzd213NW1KVUZvUFZZ?=
 =?utf-8?B?RTlDaGxYNVp1K2pWRng0QUNuZUs4amdodkp0cGRGVWNKdnJJalM0ditEOGFj?=
 =?utf-8?B?cWJkL2tmTm9MUVNvc000U2hxUUhFY2VuK0lTNGkxU1UraUQrdU9iUFhlTEVo?=
 =?utf-8?B?THFJRXJCcE95aGNxN1ZScm5hMFpWZXQ1ZUlQaHV0Y1ppbmdxYlk2N2swT1Uy?=
 =?utf-8?B?T3QzdVdmdUwxSGJNQ1RqbVRQL1gxSVgzdnZiZThSdFZvVnhUU1JpaGtvVFBh?=
 =?utf-8?B?dGlESTdreWk1NlpybVd2L2huTHBSVzVRaU4xTFFZOCt5K0N6VkFIME9pSGhl?=
 =?utf-8?B?QW42WWxXSmdEZEErWnpOTUUxcVpKcGcyQmxLK05mZE1XSDhzaHI5Y2QzUktU?=
 =?utf-8?B?OWI5Smt3RVNlTFFGenEyUFpXMFNJUmQzN09RNWxFQkVaYmJrTWE3UnREOGVh?=
 =?utf-8?B?QmdQby9FOU5IT1hmV0ppRUNIM1Z2S3doNGZES1ozVGFTYWQrZTA0U3BSQXFi?=
 =?utf-8?B?UXVoV3c4Wld3alIzZHVaWFViUkZ4REl0a0xneUV2NStBVmJqZTRITzZNMjdG?=
 =?utf-8?B?eXRGeS96U3lCQU53M0NveUVTMGlPdFpuMlk4bkQ2SlArQXkyQjA0QzRyUTlh?=
 =?utf-8?B?aktJZmdGVHZHbExkcVl2eTBXQ3hoY0JyNTRWUHNkWlZmZmhHWjlHUUNFQnE4?=
 =?utf-8?B?aVZFcURGQVl2dmN0MkUrWlJyUlEzSWxZRnd0MlBZaGZaeWovOFlweGRuVURz?=
 =?utf-8?B?S2E0SVNGbUttOVlxSDB2NUF6eTBmcDlUcGU2dnRMVnRoZ1NiVzdwVFY5QThC?=
 =?utf-8?B?eXlRQUNic3IyUkdLQm5lQXBkd0xVUDYzZHZHRW1rY3l2ZWU5a2F3bXZndjh1?=
 =?utf-8?B?ZTR5aXE3aG10YUZvMUh3ZTRtNTBVRDI1cHhQcThIWlV0SWdRMXF4VzJheWhJ?=
 =?utf-8?B?ZHZ1MWFia1pkenc4YmlERFBWejdQelQwQkNrSEFHczNBTHJJVVgwRnpNWjla?=
 =?utf-8?B?U3FPejdJZ05jcEt3eTl1Q0VNQ3l6SWhab0w2SUN4K3FQeXluV0tpVUJveVJV?=
 =?utf-8?B?ZFhzTFdzeVJaSUVvZjJqVkhvb2hVditJWjk3ZERsQ3ZKWmZPTUZPUGxJZElC?=
 =?utf-8?B?TEx0R0lub1FEbEEzRWJzMXlTMHJaUjRjQzYreFZyT29rYmMzWHpJSUZjTmwz?=
 =?utf-8?B?K2FoMFQ3a0hEbFc3eE1la0orZk1xdnU5b2VhME9ra0RyL21WSHR6QlVwL2lN?=
 =?utf-8?B?TWVGRkRkcWZIcTYwWTlSdHNhQXdwYS9RTzZoeXJ6bHZ6ZVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2s0c2gwK3MvQmdxbCswNHpQakNHd2lIVnJhVjJFSW50QWprR1BTamJpTko4?=
 =?utf-8?B?OWk3ejVlYUtCckwrZE00dFRFc1NMU0ZMdjkyL3RycVZLV0pQN0MxWTFwemZq?=
 =?utf-8?B?MmYwVEJ5L1U0Y1JrZFNKbzhqNU1IN2ZkN3pFNnhPRXIzVVBpemxOMkdQT1RJ?=
 =?utf-8?B?QUJTc004ODlMeUtaVnA4UStuWDYvR1VBL2prcjJBYUZ3RHJ0blBCVmUyQUtG?=
 =?utf-8?B?QXNXcktWZjhPcHNMempVdXN6M1JRQjdFUXRoTktSZmJ1TlRUZjhUNXRyRXNL?=
 =?utf-8?B?cHBpNFVLUmZneExsTW1ZNkQyd2doYUVsUDJYazMvVUxEd0QxYlN1Q09hRkhG?=
 =?utf-8?B?NG42OHg5emZXaXRaRWtCckZOSjg0MURycWJYMDI1eGtZTDFxU1QwZWVhd3Vh?=
 =?utf-8?B?WExpQWhNRGFUZlg0SHNCcnNlamJ6SHVvVmVIR2kzUk1LZHg0YUpOeHI1V3RH?=
 =?utf-8?B?dDFUb05RYitNNHRXODJNM2dyYytsZzBmSlZJVFlWaHNnL3Jlb3IwNXVLQmJL?=
 =?utf-8?B?WnFNeHdkbEpwYmRMc3E2dkdHSGZnVXU1T3BEdWxxaVIzTmVHMU8rd3czMFFB?=
 =?utf-8?B?WnA3QkNiQ1Q0NnFOdm5rbUdodFgxWWZCTm53VmVHME4xdUJqTC9HM1Azay9h?=
 =?utf-8?B?TElqQWZFb1RKN0Y5bldzdmJxa0VoWUhQaFVVQlY2b3lyNnlrR0ZBa09zZ2dr?=
 =?utf-8?B?eW9yY1JyRVpKdlZuYjFITTNJakdlaHNwVW1HVG9jSFFJdXNYaHFMQ1kxM1Js?=
 =?utf-8?B?SmZMaERPVDVtWExLSFd3UlZFMURxcUJqd2syc3FHU3FQbzZhbzcwdTAyL2xw?=
 =?utf-8?B?dnlCc0dGR0dkQUF0bEN4MDVRdStmSXBTYXBXUVRRU0xIWGpSLzBiMEhYUFRG?=
 =?utf-8?B?eWw0RHFwbXFmTDl0M1ZRMlc1MmhWeUF1cENBbURjaUlrSHZFOHQ1VUZ1VEVN?=
 =?utf-8?B?UjdNR2hDeFBHTDQ4NmgrRFQxSHB5aytqSUxHT2NucXQ5SFZWV2dta3ZqOHlq?=
 =?utf-8?B?eWlNUmxRRWFCQUw3OUZ5dkZNdkZneGdJdDRrV3VIZU1JVmRUOG1wU3hQZWl1?=
 =?utf-8?B?dzZHVjIxcEpBaDZ4WjQ2aWkwaVZhWnNMUUlSb0sxTTZUcnFlbk9INlNCeFBG?=
 =?utf-8?B?THJCOVNOZjg0SFZKSTRnTG1XWTRjd1hSbmE5TFNWY2RJRWxwRmdKeXB0Q1JG?=
 =?utf-8?B?dVJuZHJGbHkxQXErSURrRkJ1cStRZ01mNHFXZHB4YlJJNk1VYThZSWFZaHc1?=
 =?utf-8?B?cFh1NHhIYngxM21xM3NBaVlmVHdoWHBqNHNNSGducGdTRjNhUElmN01rOWIw?=
 =?utf-8?B?RTNBSlBXdUlXWlYxRDdQTWFzOWQrbkdYNFZvaWZmS3VkWndXVTBGZTEyOFlB?=
 =?utf-8?B?T3VXaHduelRJZXJUVWI3RjJpeG5tSCs2dzYzbVQ5RmNjTWdTdk9HdCt6VHdz?=
 =?utf-8?B?aXNGZ0hmdVZKOGc0QU11Qyt5QlhWVVhubjFVYWg4VW8vYlQraWh3di82N2RL?=
 =?utf-8?B?N2J5TWEwNERtS3doSG5SMUZZYXgrdWlxK3N3SzYvQlFFOEl2RkpuWGFpcVNp?=
 =?utf-8?B?dVhYUFZDcHppVjhsTjdZRmZQdVRSU251MlF0UkVGdVNIblQzWnBEN002RzVw?=
 =?utf-8?B?VjczaGlGZDJ6ZDZ2ZTVlZkZkVk52M3RtYnFXcHFlY0I0UXkwcGd0Ym9DNkUw?=
 =?utf-8?B?NDcxcjJUUEtZbVhSL0VkelpNckw2QzEvYlltbWdYZk5VYWV6VkhIdTg0YXRS?=
 =?utf-8?B?aFVKd1hBQko5T1ZWemFwQlhnVkNmSGl5a0ZNOTVpd3c0cXppSE0rV2dFNStE?=
 =?utf-8?B?c1M2TWNUWExSTUg3OUtZTXpmR1IwMThzSEpmZGIwN2w2WlJ0ektDb1NNRGlx?=
 =?utf-8?B?SnVvWldCSVU5VmozamVqTXBHZEkyeWRxQzBWd2NybXBoRko3N0g2SG1hOVNu?=
 =?utf-8?B?WUV0WEZNWitYUWRGbVduMjN4M0RCQVh2L2ZNNXFiR25NbDZUWUF1cDM1MkJz?=
 =?utf-8?B?Q0cweEVxWndXOGROZEVTd0hxZTNaNlNRZm5NdXF1YXM1ekloWmtHcW5Vd2t6?=
 =?utf-8?B?RTU2cWwxWTRMNlVyTHpuRmlsbzZiOVhaTHJVSloxQm16OWQ4eER1YklNenpa?=
 =?utf-8?Q?0QMPxsOGKG2eJMpAnYsB6Frcs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rRnA1bk4Hakau3zeWWsDcVasQfb3/9M+cSgFCAmmSaS4uArlHqDTaZf+xDaOhUfKyNUq/1BUuR/l7PeJOzPTxmR9PpAGvsBXlF7jANoy5qhjeKgxGKFz5J0t440WZZLRqhAwI5hw8Qt/qMYoHZ7wcjUNjhUBpw0H1t6j7Xay55XPO5MlGoZtLkI39zGRX4Tm7VKmasJp1HsPCmS3hEm3k/ViFMwLG5fa95L+3Kp/IkyYRFl4ni+QbtAkozYmociZ7C+Qstfq2WQ2hV1ba6W9Cq+/Lsw+MM5vckAqthwuXVQs2SibD2HR+O7voQm+735vq1UAHET8jUKYwUp/kuPcI0KYePbdelfJbLPvu1DBeH+wOmnjXJ6gQUCYFGZ/Wryfpq3XNcchtDAaboZ9T2xNIkFGYoUH06gu9aGxWDNk17oV1ZCZcskdsayWMepSPPeh6oewEHo9FPEaWw0N36UPUPmpeL7l1kAzY+qlbEUdWjhJV8CN8t2GNraKiBKlpO8pHGQfmiFve79dU4Vbe5zWgcgibAATeyBiQO311v0u0rpwrHmHGdAj//KfpYF/ElkMW3WxR+JGP4Vy2CA2XwzPQTUL6v8XnNxwgc1wHf7QFk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b7eb6b-ffe4-49f6-c323-08de0173d466
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 05:23:33.2448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nlbWQRtdcUK8BtJWMr5VuxhcKRRz2r68C+BZM+fogv1M+i97eADToGKEt/5ny/dL7zjSRxnyqE7Kit7wGonMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6085
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_02,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510020044
X-Proofpoint-GUID: nZir0sd38VPwvCHda6lP3Y6Ec8Q-eHNo
X-Authority-Analysis: v=2.4 cv=GsJPO01C c=1 sm=1 tr=0 ts=68de0c71 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=edf1wS77AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=6BapH0Fc4dt6a8Lr7CQA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MiBTYWx0ZWRfX/pkUfTqbuTG7
 IzOUioKbLCaIYZacxALF0Y6dFZso5JaT5dJWrgaS7IenYIuvot5RxJJUhvFN635gHSeVXqjl0MK
 v51wYaUn4UaX3I0y/UlejYR+0qJ1aOHLdtA81dqsot30rl7e8jUGyhXqg363vJTZiUM068Za/6b
 AXBZP/W8Zzdxqz985gGxMnQYttWYnVu6kGHklST1ijO1+6RqqImjzjoMgMYjtCMo3fh9w+GpWQ7
 YJAVWE6BXQoSoScjMfLPCP7KCHhf/BCWLd38ZA0hz0LnLwCEtYF7hlSlinyNgx83opL/QWvJ/9p
 TiySibubn6/Em7DxZy6z3xewzBDJfnRpx5UW8xzaadNLGvqnacKqIiRLAKI5+aUIqroGvB9dam1
 kzRkc80/B2z3u9CqfPfsCLy0QinD+w==
X-Proofpoint-ORIG-GUID: nZir0sd38VPwvCHda6lP3Y6Ec8Q-eHNo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5F1140005
X-Stat-Signature: 4ztqj3wxykfjsx1od5qsnnqwcp7c9pjy
X-HE-Tag: 1759382654-304409
X-HE-Meta: U2FsdGVkX18G+TlOubymw2HX7aSoGci5oXkEAWSvVi70Vc1AEoKDKdRUSgfai7lxKCFriv7A5321HX0hwqHVDckBoA6Yq2ljXk0Yx+v4L3QrwL4LSHzqiUE1bizimPUMXl/UrNjAKKOeezIV3ik52Xg5L+eYhXRsjGcUWr/q7++XmmJesn51rnoErBFheXg5rCY2b5K7iqHd9OJt5HOgp8/Hs7wyhn6oj5kq0BeIePJyEJCZ+pGxTGCz/igbYYchKl4rFheUzMXjIYk+CS/jfftgYaZn1kP8C1kBB8UeJ3heSFPen6APTjHik9RoZm3Ngh5jC/A1fKMnzaurGb0y6DLLuvxgPW6IfrIBexcibQZSuCcf26pDpss243b5rfkxqLtFMUEQbWqEBuZpzXod+VHG5X+6RPhSU5tms6pvohOvGfXHCNPKGxsDe8+umA9tduDCM0TMCpgCp7vw7JcGma7RcTgd/uaoXmNVaMoLiFq8XucTYRB/Eg6WHPYAVGvW7urUc/iK6b4HKrCGhZpaZXMwySAH6iGopOgVYL43eHJOPSzkf/3pMzmyBrtWS5FTznb/r+3HeKy40b1o/3hMzxX9E4N7G0I92Dp5uIIQfZEmB4bhfG/xlbuqE4MChy+yap9U5I357nX0kz7h38P6bk9z+1UoWmCrwdFav8NMnFIXD3JX1mEZs90Xya9SxTsG58pab2YpKZB0Q4N+/92VqtDF3I5Dt7CgFY7ovZxnL877zAVY+v+WRkwy/ADMKBFpd5/t4jlAZPd8d8AcGn8GMYNGsRhDC7Zs4b+YF+b0iCogGE/rQm1VXoSgTczfQFsJBtqy2yDta0vJuM6SzNocr+e/6VZKO5W4LXGT5ydNVtzcoxVCYWCdQ1Sb5zQoG/aaTV/PwoL73KjjpdqY4OYRi7mmMMudMw2ZJH4JJaTxLfD+KSYN5rqYX1lI1z5C6zUyq31CCETgTNHH4se7FPS
 lVQMN86G
 ysuPdbyI2ul2Mg98E1WF0GYfXJ7MLKmNYHVJe5c31KRcmKp2s1VpSjqhZnOQo8kgJpbQbTuLeRDqRnHy5yGiUe5owxps0DOnL9qOc8Qg4dSXyBfhscBFx7Tadmh2OPQKNzuc0DWrIc9HCrL8RjAR/9XtUrQJgxCCIV+JdXnkAuFWkNfOATZjE5YadwRI9daf0CRdV7dgriOd5z70+ECBJipgFKT9k7SJcT2k69zPVnVbZoS5J6HQZ+v5k4mI2fI8H/ErBTMM7zXSpQfEchOEs6MRylZQ1aSuCbn3AzU0n39rMdRoJVQSJkgihC6SPMaaerxro/iVs/q7E9LLXFaQcw9wi9OgMw7uWqmBM91q+FB5mbGzss/JcknI26ew8yPOrZrBlvwLR14a8la7AvVI0YQb9bx8RHHvH1l9ir+HU2U+U4XygOgyODAH2TOXWhlBR6Slj6Hix7hYsxz1IIAuZKuQaifLVYujxnNqBsv3mtx8nKSmrbTy4fC3Dj3VOcZ1ljb3cgy5gqigPDBietQ/OLwIAMk3oUmyoFJDUdYIztrj54pPXyIpa0Hrln72WBTOjuwvUXWx24MH1zlj5SsDouMUniB4VUohJYL7+KYlkDgQvg89NeP5RBkuIvXXesM8zQ/kiihaSR5o5gZizrDvseRLXLYJ1ccGCVXJiWgNoe+OCMvhslSl3si5SL4Hm1g6zRSmo3AqFf/BjoSF+P0WgUJYn+Tr8Y3ypQIm/m3Gr5sAyzJmPCSpoLZLxWKdXv4TvMsQlYanmbKT4kkCK9pg/JbqNe9N1C6I/77RG2jrFfDCWxNs0uyJkgJWRYz3QD+rfWRPTPrhSlp4JTxxEVOpC+TDZuLgqiWZ4f0f/LYLzpbp8Z/LWdjdRCATvfrfTMwcO5cjvmBzK6IF4HOnnrizYCC7swiy8irPv/DXTuNvvFjPCMWZHjuA5Ki7JTJFvlMY1f8ARIScWPhz4i+5uckUq6ApWZAKu
 Qiqxchw9
 zuVF6V4M1WyEBSKXD1g1WtThCADXudHcgPg+ooXGP36gzftdatQTDdUQuA2Hmg0h6g1J7tuDWxe1CEiLMtMvN9CbPKJLWxgvACGXo9m/4TQDqs3SJeyJrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/1/2025 7:04 PM, Zi Yan wrote:
> On 1 Oct 2025, at 20:38, Zi Yan wrote:
> 
>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>
>>> Hi, Zi Yan,
>>>
>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>>>> lost connection to test machine
>>>>
>>>>
>>>>
>>>> Tested on:
>>>>
>>>> commit:         d8795075 mm/huge_memory: do not change split_huge_page..
>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ce96e2580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=714d45b6135c308e
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>> userspace arch: arm64
>>>>
>>>> Note: no patches were applied.
>>>>
>>>
>>
>> Thank you for looking into this.
>>
>>> My hunch is that
>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-kernelci
>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev/nullb0 in
>> Yes, it only has the first patch, which fails a split if it cannot be
>> split to the intended order (order-0 in this case).
>>
>>
>>> the test case are probably with min_order > 0, therefore THP split fails, as the console message show:
>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for unsplit thp: Failed
>>>
>>> With lots of poisoned THP pages stuck in the page cache, OOM could trigger too soon.
>>
>> That is my understanding too. Thanks for the confirmation.
>>
>>>
>>> I think it's worth to try add the additional changes I suggested earlier -
>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com/
>>>
>>> So that in the madvise HWPOISON cases, large huge pages are splitted to smaller huge pages, and most of them remain usable in the page cache.
>>
>> Yep, I am going to incorporate your suggestion as the second patch and make
>> syzbot check it again.
> 
> 
> #syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_order_and_opt_memory_failure-for-kernelci
> 

There is a bug here,

		if (try_to_split_thp_page(p, new_order, false) || new_order) {
			res = -EHWPOISON;
			kill_procs_now(p, pfn, flags, folio);  <---

If try_to_split_thp_page() succeeded on min_order, 'folio' should be 
retaken:  folio = page_folio(page) before moving on to kill_procs_now().

thanks,
-jane

> 
> --
> Best Regards,
> Yan, Zi


