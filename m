Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287A4D715E3
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 11:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBCC6B05AF; Sat, 24 Jan 2026 06:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B29E6B05B0; Sat, 24 Jan 2026 06:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460BA6B05B1; Sat, 24 Jan 2026 06:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF956B05AF
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 06:12:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 192811AF87C
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:12:41 +0000 (UTC)
X-FDA: 84366594522.12.736F5B6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id AC26640005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:12:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fu+djooW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sJG4QZcv;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769253157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qb+uMiz9/YpeoI1Dy6bVucxFF1UwDiZVa9CEll8O4Cg=;
	b=hxzNM8aZHXBMusLT/niZNpNJxYb8RUcL7eZT7QcsUHgt6d8R0w+spir2/Grq1137jw13Lu
	FqC43/8G4uUKEO3UxMkN7T9W82YVe3Sd+KbVPqvVBicnXgRP+heAzGfk2eSNONL4wkKeuR
	R4Twwj5pwiPgvd5r/7crvCSyFVcFsEE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fu+djooW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sJG4QZcv;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769253157; a=rsa-sha256;
	cv=pass;
	b=bimtLUZBD50apr6t3C6zplngQULXqN+VMBB+grF38j2gU7d4JWnIu2C5XtZs114TjqKdKO
	wpIrAgfjI+8sD7RFcG5p/5Q4uUPXI1KUo9Rbm2s0jwA7PBGA1KkQRDIFk8g+8/Q0b79tju
	KL5oTK35qly6APn1Lw4lDDw8W73WpCw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60OAg6kJ1280628;
	Sat, 24 Jan 2026 11:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Qb+uMiz9/YpeoI1Dy6
	bVucxFF1UwDiZVa9CEll8O4Cg=; b=Fu+djooWvWBSVxfZsLbADbQCRV4lOWgrsU
	+X/vvRMl6nrHL8BstRQ0lKSnMUFsAERGtu3TBxxvHOEpbg/CaEHLWJfX1FBi/JK8
	RWv5sNmXUVA9Ij1OA0DQbgA8inkxwgMgDslKfLzNpGATFISCoKiBhfhvS9LH1CQj
	voaQkLQAF4S9oSivaOY709oSypBTme7KSGsjelU1ykrv0GAkuSmtumUQ1aSFtyhD
	z5dAp8iVSQ6eGjHqNQs9Y/M60QReywldYFTAMrYuxhf8syd3Q5YAp2wAR6ckn9md
	vUhOylHFXYhkGJ3LSDVQvLjJ73YUq/fEEJYl5CY4KqOaHMh7q7gg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnps85ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 11:12:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O8BkLS036177;
	Sat, 24 Jan 2026 11:12:33 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjm0gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 11:12:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKQVsTeGthrmDmzU2V4grfCb62EsgrPFu/tYqjOQRi4O/RPqLyyNRG+QaQ954mTRjk8/2/HLtAD3Pk9xhDBzoIdGtsMmFPMjqDdeJH4dknzsDr05nUQD3A3KP740CKmzxJvgNKCcPYg11+NmZR/9QeLA2XfRPHy3moUrO5eolWVWtseHW03rW4O27DCa5oqhAqSYaMmXLkqB7o2E9P183rT3Ag3n6XLsK0kyTN32gVA1/bkWgQqXQh37xmhnjvFsHxw0ASmgE+ZW9LhfO5hV3e3LDDBL/G+U8H6KCwzLAJQtJ/RAT86UDM+LuZvif1lzWjmZ02TV+KZLM5o50LxPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb+uMiz9/YpeoI1Dy6bVucxFF1UwDiZVa9CEll8O4Cg=;
 b=DhyZY8tWuh6xqJxNjF08FH9vJlc2eP9VQQHtr/HLZyfEdBvRb4POoodEeQy9n3msUlwWutN+WFHfB43CBIpOyB+W445EfXDA9+Pob4tuwKWU8JP1l92d0Ok6fS30qsxiy6o+Mrwiq2uaIaRRnjkCvxxKXtNbmp8y4uzBHn52hxWczccTDFhu+b6ggLbCrjZvFeV1ouLjSYDseqmQ1dDcUz8FV2Yr93PaiMcIeUvrowfBR6qbyfpOWGBWkSQVPQyLggLtehv5YOkze3XoPsDOBl7uHhRePqDlYudQqDd+MzwWyXrpMiOUv7yyBh8pBmtLyYkNbnmeIt3Fs8uv6gEBgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qb+uMiz9/YpeoI1Dy6bVucxFF1UwDiZVa9CEll8O4Cg=;
 b=sJG4QZcvdEYINVT0BCB7s9z9BHF1f4vlx69Xl5+Nyqo2x15r9e/gdH5/xiiGWjrV2NsIMj02KO35V0c0c3pccyQMCvGUKMXzwvFcwObVxQjF7oMEUkwasDe2rL7vorCJiywcYlxAheCvUDwsjx2hdrQ6x5nAurOPq9ttk3pLY/M=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 11:12:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 11:12:29 +0000
Date: Sat, 24 Jan 2026 20:12:21 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, surenb@google.com
Subject: Re: [linux-next:master] [mm/slab]  4fad56bdb6:
 BUG_kmalloc-#:Padding_overwritten.#-#@offset=
Message-ID: <aXSpFYShAMM3MnXu@hyeyoo>
References: <202601231457.f7b31e09-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601231457.f7b31e09-lkp@intel.com>
X-ClientProxiedBy: SE2P216CA0201.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB4797:EE_
X-MS-Office365-Filtering-Correlation-Id: c798b521-01e5-426d-472d-08de5b39768c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7053199007|220923002;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PqfLBdYgbhKIPRmdIjLSg+NGFP9Jf4gFxR1p8orxvY6LCk3paFATYWV0KRvT?=
 =?us-ascii?Q?ozuzaz891bLhg5HGbE+M8b48WMzQfW4z8NqoOHiGU3XQMNf1+yKSDqq1nWcv?=
 =?us-ascii?Q?Vi2bd5SkJoqMxdNS8obUV7VqM4ZJZKELW49y6vZKi7JUKoQj7t5Wtz1bnC7R?=
 =?us-ascii?Q?E0dtCniGY7UjbJrBb6jG60QE8kD+STxfQe4cjQSTN18ppmYoysT2VacILRQX?=
 =?us-ascii?Q?ps9aCcuNTF98tAenu2pNVKVAXEnwE7Oc5rN6Th/pkBjjn0jfB9dPJ48+cWu9?=
 =?us-ascii?Q?yicprjXK8blB/y2lRerfjmaBTtuz7aSAtTfC20V3wNBam23jO0y11BI9uKZo?=
 =?us-ascii?Q?GQgf4t8PzN8Kzf+/e4RFJTfSTwdbIEbihFlg+0f9toN89i7rclVx6kHDDg4W?=
 =?us-ascii?Q?oI7GJh91rwJXkTHTy4Ahqbhra+tDIRxwj9Ak+Syj+KCsUdgotDYigZcnmO29?=
 =?us-ascii?Q?3PCiv4VGcxXkZv8KoJbYjT4RmKAsWRTM+hIMpllhCOOSiPahZHa+tptVHYjX?=
 =?us-ascii?Q?ChtSA0zsUVfEL+yR3kUIzLsELCW4SX+YKyCfX+e25rCuj9dZ7c/t/2tOC4/f?=
 =?us-ascii?Q?oIoUp3qj+CgV42b350PIbdJmifqMSZ3eATWvXrKZayB2EaBeLF+mwxum9pXK?=
 =?us-ascii?Q?HzjQVo5+oqzSReR1rpBryXqadV9eGujIpq490WjnSdXQ5HBlPqSi7kviMQTX?=
 =?us-ascii?Q?s9KwLgt8HXiSENaIj2+6ZrdA7NyksdpEtUedR61bVWu+nyvaRmG88lA2NgRK?=
 =?us-ascii?Q?Ww+v8jzzIPAzUXEnZaIG3eYFkBrB9lgksIpzAK30np0cOLpJISvyzzjLPF1X?=
 =?us-ascii?Q?G4Fi0+CcJjaO7BUEtuMxNHRQhIvwYtmr8KteA+glaxvdXob289BNFJJxgiiF?=
 =?us-ascii?Q?MvrJy3kPq8f8953U/AtT2muKLjfrRNPQmoDovgBcbxzrYisa3h6pa+k895oA?=
 =?us-ascii?Q?2j7ldIlnkXrdF74/OyGtgKfKfIh7MCM3YKi1q/Z+2eg8I4HP0jM0mRYckkTH?=
 =?us-ascii?Q?GYkqGf4Qo6fSpM9dNn0KPdUiujCl9KqyUM5CaHw46Gmxjj/a6fIBM4WiKsdG?=
 =?us-ascii?Q?Q+nLJ8KbRoeRE8vFi+Cw/tbOV7fDJ12KfPhlWhFhrU84yt2k2te65qXVsYAM?=
 =?us-ascii?Q?eofpsjMfqcVeRyASBoTEqbKl/yyYct2MPrXPQeJMyIxzN918p0bTV2mI2EhK?=
 =?us-ascii?Q?3r1Nx88FiKB5JLJprc2okI6RDR14l0Jak1eLh4iOwvimt11glW9D9ooXiZJ8?=
 =?us-ascii?Q?917CilgBTKuDRR7LeAa1bs/cF4LF5MWl2OznKcN0TrhqNy4ro1OBaNHkTb8E?=
 =?us-ascii?Q?gO276DFN6DDaNNsMfsjwbWnjh/JraHGQER5jEyLCeGQrORMW7mNptQHb2tJc?=
 =?us-ascii?Q?lGYn3ab6fZmNc4tkq6A5wg+0hCDb4zrcVCyu0+AYOqwc8KMxGNwtgiSXsPZS?=
 =?us-ascii?Q?dvMTQmcoSjqnNyROHEROfR79j/UgPmXV4yo0jWPzp675kEny6ek3o95L+S0r?=
 =?us-ascii?Q?9+HkoUavPuDDdOnB9Ok166Lq5JThDQ61yoxaaX3OWAH4og5zDa6fKUECMa61?=
 =?us-ascii?Q?gHpH5S/VCMRtD0gRCnloFXdb6fWANe83fA5qt6/TQg7DnaX9mTBoLb8NWaEV?=
 =?us-ascii?Q?7Q3MZzbndkTMeqjJivfe0/Yfz7DJJ71J6G7arsUs0Dyu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007)(220923002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eOmTS8hDhQrOKnfCCtQ42zIHXs5mj14OVZl5+rjorgOX9jGjW+g5aDCoM4cF?=
 =?us-ascii?Q?ulmZxmQ5DcBMbW47MWWHrpopPdS+/R/AAFIGxJ1o7+zJDA/1hf4VpocyNkhD?=
 =?us-ascii?Q?fE3KseUDO5VTpLZrerYlPIDBrKh23dLQveRyED6mS8EzOQl2hTCuZvSvmuUf?=
 =?us-ascii?Q?rS3kIQK3UWGFRBLY4JCDJ9lBE36p0z9d5/Bbwh9rUVdfBRrDer7jzpVTYV0k?=
 =?us-ascii?Q?9b7B3qpz1C3HnSLcCnpfGkZnHdtYoozdC0htDGSBGfaXBGvkuiuQxcJJAeFC?=
 =?us-ascii?Q?zCQOkrifAk7cEG9y2odMAmVG/bJOWOPJ4qEDrOgIMIrnbd9MKlbLEull1CIE?=
 =?us-ascii?Q?XpIcg3wzI07g9cmTzaKQIi3UAaU+dPIAVs83IO5FAjV9xqtCdDzsWa7en/dE?=
 =?us-ascii?Q?kEPILtXp4SP/kgUVaIgbbFBF73r3d/XJJPHf5LwKK6hkbfpPw4S+LFLKbggS?=
 =?us-ascii?Q?PRZTSyDjriOC1A9IcqwJGhyDnq+CjBLyx9GlUoFRJSPqbbUj8ny8wX1kLN3o?=
 =?us-ascii?Q?TMy/vu3EiYmZ+zqvsrqBD7rFS7QkXiFUKcpxBSaj+QpFgNZGTzi8kZD4FQcp?=
 =?us-ascii?Q?sAoxQyokB4fgQedHUGPtd8292ZSjYhsIl89ZLs3ass5LvzHA/HGVBDi0Hn8S?=
 =?us-ascii?Q?M9gsK6KpWoTFvT9+5Uh5sx6LFJffCrkJMT48LCdnBunqZjJZiZ+DnpcINPN1?=
 =?us-ascii?Q?8F8tGskGZPIV7YteXZYOPAlf8LWgyiZC1uq8Q1xVCnG+auiylr/OOS0lTQFm?=
 =?us-ascii?Q?+n3K/eUm92YGMqmVSREPg3FbM9N/k3iwRJmYcVAnDTgr4lZ9bLB8lfSjVw6L?=
 =?us-ascii?Q?lj0i3Vs2FHjZoGaFYWT1T/C6JgwoHAqhRL363BOC2H+tgtcmKJ+izGRtvLLj?=
 =?us-ascii?Q?jSvvajsj6xvrA4kR8T2aFrMhkYHrlilggflOyeKGfY/iVTRFwzU2Noh3gw4F?=
 =?us-ascii?Q?qiDBmIgprv/Mle9Bao35MkV34Dtr2z1ZTz7ZaqgqBBKvWR5Px/5ID2jzMrV9?=
 =?us-ascii?Q?cPHGSr1gLexoukn5dbe8/+TgKc3qbn2ZumqwuIDiI/gbGecWwoYZjBIbN0XS?=
 =?us-ascii?Q?kBhjtuWBBbuXll/IACUMxMDxdSOe1wtdTxo1Y2hIWzPOxdfEbHKKfwqTJTTk?=
 =?us-ascii?Q?cgWGyEMIYmG2ujr0bmt3hgq/oWMa8Sg3yAPWl591niKIAz3NmxLR46OZjfuC?=
 =?us-ascii?Q?UU7MM7efIEP4eOXrhiZTW1cUPLJvU4frwG8w4Fylu6eHUEOvFvyUb3FEd4L2?=
 =?us-ascii?Q?8wvHroNaPMxlU6jmnSKKwLtebxeER4eBv+AlYxQZSnOqwY2yTp6kEgMTKNUp?=
 =?us-ascii?Q?6oprFEwbg6CYXXfdO3vJbnD22eLe9iqBbKasi9GGvBFAiQZYsUf9LIgeNyOG?=
 =?us-ascii?Q?Scu5fbD5WYwa60HnmS0CBFaD+pB5ooUvwpY220S985JF0hG0lOyaqvi8cR2Y?=
 =?us-ascii?Q?8c02HjwkNQAkcWKXyS6d3jg3SCYefoMI/zyuD23Jwqs2Sa9f4mV7s+M7lq5W?=
 =?us-ascii?Q?Jw6SaSdx9KNsOZoSj27NYf5CB8ilEYg5yQQdPKrhiubpdVQ+hdLhx/ub4Ljd?=
 =?us-ascii?Q?oAaWbj9ItQIyZEV6hGgkIUXPp7kBKRh8QePBG/9yrYgEGBnUyu8dXDRjrXll?=
 =?us-ascii?Q?BVvj8FYQcG9BoeOupoY8YRkYcf49ofacGGUax6l/vGeQOf90A7gpT2/NSWlH?=
 =?us-ascii?Q?Q0bsnyM812YkCSt16uuwCtEvzGUDsI6m3S1oqZ/cQus5zs8FWmpzVrAR9GfZ?=
 =?us-ascii?Q?yWu9R7GkzA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jdg5Hpmpoqt1LQWMF31NvguvoNAtPWtX3Qtwf/NN6IcypkhAyoXmmJmsUwCAc9Vnkrp5Cg+msA7yEgG+0XuMgIiTph6Z5gOSisfkc52hQ3ggEccK19lcu9koIUCHnZ058rEl7n0IyV3cwze6LuS39FRUZ0pfnTpBmYCsdsfSW+chmednxf1RuNTv567T5D3yfTElIXDzUnQTjGihP9JkHMP5+jqebY9mG6kMfpDYdrmWIJYI2kkI671k8jrfKFDiaRckgD8PuLhkPcH1tFn0cXdjRhjpqAw8LfJOEMOmL1zWogR5kYuaoCtO84tnulq4okL+9mfbwdoMsva2xC03n5UX6vGNV0Um4SylRbuMvZkvGDEYZR23HgFbBLo8m0GLDHFs6Gto9mv3Nz1nZeqDvJ2q4MBX48ABf3fSbmvjkDWUWzOOIvj9akZ912IDXqDOcUYKSv1y8esoCFd8Ey+NIutVigBgmq2ovYbQ46Qzk7fXvAmgZ2Qy83+Y+ZD2nqzlDCcpG3fmaZISSjT+saZ6K0ZIUJxKgDFQQJO5B39v2z9mW+TWMZUyfhJHdGQnmZ1sm5SqlWJgZdb/fSMDefWgQnOPXnS6SHQal7YxZ3ePbH4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c798b521-01e5-426d-472d-08de5b39768c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 11:12:29.5484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ys/mBuew9dh6Q5TVK6GjqOwndqbcI7vq/1Jw/OPmVNkaTIF56yx6d/VDXwIOGVUhsAqI2y1YpjN+CeD5sxJm0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240088
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=6974a922 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=i3X5FwGiAAAA:8 a=yPCof4ZbAAAA:8
 a=kfnae9sCGfUvCpJJaI4A:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf
 awl=host:12104
X-Proofpoint-GUID: CMXE9vcfKQXt_sHg-QNuwTGL_OmqHl7z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA4OSBTYWx0ZWRfX7/BQLU74Mj4Q
 4E/GWfjJctlQovIXw32uEnIzMovJ82Y6Q+E9/fooSMmjAApZ9Qq1+3/W3Xzu3PafGu1U13hKV42
 ZEtfHvT06yh9JiYv8NOKto57a7kHHJ6M3w6Ph5DPzyQeEKslhEGoFcnYK9tLsSaH11gO8e0mYOF
 A/XrGiejA5eK5IB+W0d2OBh+xl7Xr0lghhw9H9OqTFMbDqk4S1YhKkrgRkPs6ytDguBVunsb7Py
 lz3z2WSiKpThZmjhL2G7Wl7fGiUNxxLCKgrXmhn7voMJAPIzdYR05xf8CuqYZYVJN/VSewGaJAH
 F0yRTXNB6Dr6pf28HU1+realHs0M7Ui+N4IncJvdyDMO0YyklvP9AJnO/usZ399j2d/LZyeHerH
 N+s/9KLV7H8FTxWUzNRT24wptot6pSv8b5PVYDxoAGgNJBU59V+veZ2cvOgH++RTBqUr1KFCSZR
 zFCQStseDXmXa+TJt8/476wNAm46GKHL6h4Gc/Xo=
X-Proofpoint-ORIG-GUID: CMXE9vcfKQXt_sHg-QNuwTGL_OmqHl7z
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC26640005
X-Stat-Signature: cjxg54yx7ndxfysjtgoduguyk11a5crf
X-Rspam-User: 
X-HE-Tag: 1769253157-288815
X-HE-Meta: U2FsdGVkX1/tF3CkAanXrNoHDsz6Pm11ibCo5HVWK1h6wvu53KAUlRv9KEi3iShF0Adzn0in2aGkzCeoPcVCzN5VyJ9jOdbF8Rsoe9L7svgibVTNC0xagS1EZHXzv/pqicAA78T9eP3fmtZN0uJsDEWvX10vSWWbAYG/8orUa+dWR5nHwZWDAfUe8utwzH1hlGeoyL7ARNtOVWcg97T3RHPIpvfsUMmCxvKRuEIrwM1P+sEUVIvAOUh3psQ4/pUFVo0+LK7r9eikMuH8lQLj4TF8kZovcZw5GNt5oCt6l5y/GdiRAwavmpR98rDu3lrKHCkUEY6TRVwIvolNX709qJOHUhReGbBFQCNFLuMfq+P4Lj+O2go68qseZ+tychASCh133A/PYpf/cdJsYUE9LpgUCfAg0hF17YMgzMjTk5J5hcwZnqdBR6ATR1IRsZMBdNTc5Ugse/cPqw+M/nhuCItCbKr5hR6rRjsZ6jbIEPAnhoJ3lgkkqOGmBe0H1FBrfP78tAFbcRgoeUl8xqxv8c7OBw5etvzj/A6Q8/64UIhpvwbbdjB8YX0tLvgqnZYV8N2n7cKZ58bTHicPQ/KtpJdu4PHiztPuz5N3RswoHhVX7XPBdvVf9V2+EVChkQcDhFkQp8DqifeBukCf8+g3B91xF1g7E43LiEzk8a1Ak4/3xQP8dEo89jC2Rp1kZyYIMB0qK7oyTYbHHgH0r3uOt4X8DQRhi88V0Bw4VWVgl519zFlIObw8ysevOoqrBrMpwzcZtS1QjmbHgbxSsN5GwXEdDKrOChjD2QAsMVcKfBupFarCTrRSRTPJYt3xqJ34BGJu6jfxGPzq77J/I/wTRxBqMzPs7+aPLRwei3PZ+bjFpoZ1aucxWmEW0XP5IHQ4CK0H01VwE3CqdyXnuRNBeU2CGDGZZ1ZQ4+B5mgeu65C+MxCmpY56LzxH+wmhqcy+F0h4D7pep3j/+Za5Asy
 hPymxM6s
 fOOeW8SnoIQyQgKQ3CTerU6eYbZOYZhLWTiSsRgXdPBnaVZadwIJE5F6OjcoChdWANDIMBmVPybnw5ul8zVb9DO6wfwYVt8PQzM/V/Stc3ohrDbAQK7XkK9RdxiNJ1cd2jnhcSMyyRAUzzpMz5/6IvL/8zYdi1sh7t7s3dqAqfOi8LrMjwmO9eTafRvkGlBam27F6m884wC8zOgf8t3LnRy5ly0kPD35TphJNFg4hY254yHol9jKFUw0gLFe7rBescjbh9TjU1igRnwPDyxkmPUWGjTaGaEjkO6CXl4r/3HupiMDiSzjh6cHcAq7zKCcEIENQi0/1TwcyOoPyXsK/vuxHsXvl5JazdmG+CkbslGFOW9a0L1fX5ZfnnTTv/eWH4Oa7Ob0WDwjmpgmRQUqumlplpCG0sRfUIrGwyjPeBAGQttanfkxwWIkbWiBDn4aYMPHsye1hG+oMUpz2pN3Ip7gX63rxC46EtHvfyjMQJrpFve6gaOXTFkFg7MiaTQB9j258PBtXT+wDwb0nX3ySZgkDDmv0uR1EnxCDbX9ZoYzxIw0fxZss9pEf/jdNoA6OUnvoBlotK3cpXBnP/buQSNeOeER6bWTvwSIbFRvlf/BhlJ1TAbv+vp13zwlYone51CfOKzCtSooodp9ovXRALaVM4Fbfn92+llp11NRhRd6cSG/MAJDC5LOXPDKoUkC30CW1JP/bVaCXtn6DJulJwuzU2VYE0KEjwKejw7Aq/9/H2f0SHQJyODo0tn/KubRFWaISCc/EHJDLFmyjcSYgWcbq5jgd+u3SdVubelx+vzy+D7yboVQ3FNBBv0rO8DzEcziXVsBzmaiVGww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 03:21:19PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG_kmalloc-#:Padding_overwritten.#-#@offset=" on:
> 
> commit: 4fad56bdb6b4c4bc0ea2d919df1ae4eef7b69919 ("mm/slab: save memory by allocating slabobj_ext array from leftover")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git
> 
> [test failed on linux-next/master e3b32dcb9f23e3c3927ef3eec6a5842a988fb574]
> 
> in testcase: boot
> 
> config: x86_64-randconfig-012-20260121
> compiler: clang-20
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com
> 
> 
> 
> [    3.646661][    T0] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> [    3.647660][    T0] **********************************************************
> [    3.648834][    T0] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    3.651537][    T0] Kernel/User page tables isolation: enabled
> [    3.653242][    T0] =============================================================================
> [    3.655191][    T0] BUG kmalloc-192 (Tainted: G                T  ): Padding overwritten. 0xffff88810006c028-0xffff88810006bfff @offset=8232
> [    3.657925][    T0] -----------------------------------------------------------------------------
> [    3.657925][    T0]
> [    3.660319][    T0] Padding ffff88810006c028: 00 00 00 00 00 00 00 00 30 c0 06 00 81 88 ff ff  ........0.......
> [    3.662476][    T0] Padding ffff88810006c038: 30 c0 06 00 81 88 ff ff 00 00 00 00 00 00 00 00  0...............
> [    3.664649][    T0] Padding ffff88810006c048: 48 c0 06 00 81 88 ff ff 48 c0 06 00 81 88 ff ff  H.......H.......
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260123/202601231457.f7b31e09-lkp@intel.com

Thanks for the report! It was very helpful to reproduce the bug.
after some printk() debugging, I discovered that the slab being reported
allocated the slabobj_ext array via kmalloc.

So I added a warning to confirm that the array was allocated
from the same slab we're allocating the array for:

@@ -2145,6 +2164,12 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
                return -ENOMEM;
        }

+       unsigned long start = (unsigned long)slab_address(slab);
+       unsigned long end = start + slab_size(slab);
+       unsigned long val = (unsigned long)vec;
+
+       WARN_ON_ONCE(val >= start && val < end);

and it was hit:

WARNING: mm/slub.c:2171 at alloc_slab_obj_exts+0x18a/0x1e0, CPU#0: swapper/0
[...]
Call Trace:
 <TASK>
 __alloc_tagging_slab_alloc_hook+0xac/0x220
 __kmalloc_cache_noprof+0x196/0x470
 ? __kmalloc_cache_noprof+0x200/0x470
 ? shrinker_alloc+0xa9/0x3b0
 shrinker_alloc+0xa9/0x3b0
 vmalloc_init+0x616/0x8f0
[...]

I sent a fix to prevent this and confirmed that the fix resolved
the reported issue.

https://lore.kernel.org/linux-mm/20260124104614.9739-1-harry.yoo@oracle.com/

Thanks!

-- 
Cheers,
Harry / Hyeonggon

