Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A6E9D2F34B
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B146B0005; Tue, 13 Jan 2026 12:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032936B0089; Tue, 13 Jan 2026 12:10:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57306B008A; Tue, 13 Jan 2026 12:10:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3E906B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:10:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 669F71AFBE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:10:32 +0000 (UTC)
X-FDA: 84327579504.12.1659709
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by imf02.hostedemail.com (Postfix) with ESMTP id 69CA78000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:10:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jt5g6cIR;
	spf=pass (imf02.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768324229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpCq1/N5wJAdTSrXzI3rzm37O4bxo1F0yq6rHFtsdQM=;
	b=XLP3ibLJMhURD5EO6qt+/gHL1CvvFW8c9JKOfyIWi4C2D2tcT9CpRb3mrRt1oPZmJ4pgJM
	2EgLCD19T9hpWvfIeCdgZCN5xOwE95z3NdtTrrdt7Ofee3H/cLYWYqUFEUasqBDccSZDEp
	laNohzakLs52HGQ1EvbmEw6wktGW0Vc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jt5g6cIR;
	spf=pass (imf02.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768324229; a=rsa-sha256;
	cv=pass;
	b=ERSW9/f+9e+zVsAH2lZiDcF4mgPEqJSHOzjdqRaZFOQVr8MDkicdFDE7CkkxfausDSdEwq
	ZclWw/7eoZP23Hwndfhhtf5dNJiE+TkgKWuULtOBv6jzXMwY8PyQ1VFP9PD4m39+Bw0iPi
	IxJ6yv3di9iF8W2pAvSRN1IEyr2drSA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aB7aVggR4KghPkJ4c7/4labPC+ruCpmeLEDBrhrCrDnMRzBj6GkiT7g27WQE2mZt8KsKyTQUGIa1HPncXmNYdfE2b5V7k2G9LZWFC9qngm0DSL9HEqVVvbLdt7s2JYYfXfJGv3sG/pWbz0IxBsvk9QZorlPoiZEZyWjCJqI2jIj/NSdRW8AnCOhlZQcaQa4fFOuCuZwZHuvabYal1kw6T0mIDd3Fw4DOsWB3DpBNibnieS9DvxDmVAp+U8NAPgWqQ6EUcnOsFHXaxdZYEO136CIKHOSROnNiXATG0CnB/nBK6BidbKOMZynl9QDGBaEUjlHRaUKKrZL6qLNQvEB5Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpCq1/N5wJAdTSrXzI3rzm37O4bxo1F0yq6rHFtsdQM=;
 b=fmMqFQB3wKzksRLbRvlnQK/2QxcH1autQm4mLFsvkWbWqGgEBnn/yd6dMoTV2ze9B+SPjEwgy6NI7TJlLhbZyaISH/0J6AZOfp9wDl71vCt/al1Q8xzLemYIkNRwT7QuSckGAjnEJ96WW+22FWRr/3tRJLd2v0Ord5U1Ujv3/HKjPPZwQZtVCqtubD3V/0xtZ/vxbxGhp80yTMPWo0+PeREZPp+94e+bA7oOjq0OXYpS0MeWv42M2l9E96YOrm6LpSjuRjQSc+ARIp/GnHpDRUGS1GAmBOGwSCHhhb+oXeYmez58JEu31xivUwbthIAUWdvDthjMQIdhjll5Xpy/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpCq1/N5wJAdTSrXzI3rzm37O4bxo1F0yq6rHFtsdQM=;
 b=jt5g6cIRaRNF3ZJxqLBccN6576mGs+5gFankEd680FC3Hx7PaAQgTr2wKtJbHTSI8tSLYYXRLRRIimMtATcXUub7APgEEJd/heQ9yLCcRc3YGHxFq89xpZOF/7BimVU8PQNnlfGvbtdM6LqHq+WXF1YXs0zWHPT0QphkCkE+oJ4=
Received: from SA1PR12MB8643.namprd12.prod.outlook.com (2603:10b6:806:387::7)
 by DS7PR12MB5814.namprd12.prod.outlook.com (2603:10b6:8:76::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.2; Tue, 13 Jan 2026 17:10:25 +0000
Received: from SA1PR12MB8643.namprd12.prod.outlook.com
 ([fe80::f168:a4d1:aef0:3ed6]) by SA1PR12MB8643.namprd12.prod.outlook.com
 ([fe80::f168:a4d1:aef0:3ed6%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 17:10:23 +0000
Message-ID: <af3bf2ef-0231-4e75-9a80-c2bd3a7e1bf1@amd.com>
Date: Tue, 13 Jan 2026 11:10:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory
 after hot-remove
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-3-prsampat@amd.com> <aWYctexPTf-w7QT8@thinkstation>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <aWYctexPTf-w7QT8@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0112.namprd12.prod.outlook.com
 (2603:10b6:802:21::47) To SA1PR12MB8643.namprd12.prod.outlook.com
 (2603:10b6:806:387::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8643:EE_|DS7PR12MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 2931dcc0-15d8-45ab-5b70-08de52c6a38c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0hQYkJBbFNOVTZ2b1kxU29QUE1Oc21DY09uNjRSV2h6cUdPa1NyTzZqL01E?=
 =?utf-8?B?S3ZVMDZneFFNWXZNWkQwa01XOXlvU3ZRY2l1OWNCbTZyL2k4WkZTbjZuZTJw?=
 =?utf-8?B?UUlKNDJZWGllbHc4aWF0YzI3YkozZ1VBWURLSzRVNi9TQy9qbDFvdDBEWHVX?=
 =?utf-8?B?b1R4eHJrOFcwdVVqbHc5TUZ5NU5rUC92V2xjbjBZQTJpbUtpalN3YVJWUVpO?=
 =?utf-8?B?czZHMHczUFFxaTNHUkR3eWROWVFHTENmNGFWQjJUY0JKcmlzNnU1K1ptQWFX?=
 =?utf-8?B?N2c4L1ZwaEZKdlVnMlJUMDFnRjZLSzkzVFdURXNaVDdTMGxuSWorRm9GMEVz?=
 =?utf-8?B?cG1lNkp2ZkQwa0l0dFBoVm0wQ0hiOUVxT1NjRUhIdUlheEZ4SjFLNVZzOTVS?=
 =?utf-8?B?dVg2eFJPVzl6NUFnZklUTXhCa2w1VnNybmVJcE5sQ0NOR1BkYndoZkk2ZkFP?=
 =?utf-8?B?MXhaNmdMendHYmhaN29remNxSTZQelVUa01pR2xULy85elBYd2VCTFBXMVZt?=
 =?utf-8?B?enR1aWtVbDNOcEJ2YXlPcldjZjd0aVZneXYrNXlQcEt3dEJIMG9hTmRyUmRy?=
 =?utf-8?B?bW5yWFhKQ1ROb0VMUTZLZ0pqSkhaUUpVWGNmamVDejV6V2c4VWJWbWcyN3Ay?=
 =?utf-8?B?VkhxYVNJL1lMK3RjNVl0RG9Yays3UVRiQTZXaytuYTNFVWsrZjRmVVplWDZm?=
 =?utf-8?B?Nm5nS3dsd0lQMllIRUFnc01SaGMvd2plTksvMjkzNWE2a01OTXpkaDRzRWV6?=
 =?utf-8?B?QUJLWnMvYWVFVWJxa3VLU2d0SUl1aDIzeDQ3N2NIRjNkVVlkK2JWc3RjZmVQ?=
 =?utf-8?B?WkJIVDBEbG5UYW9yOWNtMzJJVFBYTlU4N2RydUNiSFdaRVFyRG1qczNKaTZw?=
 =?utf-8?B?VTlrUGR6VFdVTlFNOVF6UFVIOHJwR1ZoWWVpVCtCay91Y2g5WTE4T3F5R2FT?=
 =?utf-8?B?RDY5RkVncHFlcERvQmRsb0dhdW5PWWJPYnJLS1FmNUVpYzYxemJ0N0dtWUFI?=
 =?utf-8?B?WUVBSkxlSE9ubDhRcWN3L0s4bUFucFAxc0o2MmFHbHE4Q1o1UGlvWHZKdklr?=
 =?utf-8?B?czY4Uk03bU5ERE9IVnhCTGg2WFp0QzA2b3FLY1hqdytCQUlPNXErSHZ1UXhy?=
 =?utf-8?B?cFdINUtxVzVXWGtTODhBUm4wbzdJcEtuQThTNmsybytSbXN6dWRnNUo0T0dy?=
 =?utf-8?B?WWlhc1I3N2RVdnNnRXpKUFMxblltcjRKV3VGZlF1NCs2aTZwRHowbUgyNUt5?=
 =?utf-8?B?RGhWZ3FOZzRTWFY5WjdQMm9DRTdKaHVVL00yaXdMZ21ySm5pSU9uYS9XMGRY?=
 =?utf-8?B?emFzRCt0eUxCeHZpT3NLQzJEdEM0ckJ6TmJlSU1QbGVIbEZaeVpCbS9xWnFM?=
 =?utf-8?B?eUdNZWF6MHhNY2lrYXRnOWt2VWhqbkg5MXFkWUlQUlRnaTlwTzM2Vy91N0Z4?=
 =?utf-8?B?aHV0d2hyUFpmSC8ybXAyYXBmQVNwMzl0QXAxRkh3YXJzQ1dEVllzczM0NDVE?=
 =?utf-8?B?VFhiNW9vbHFGRDF6MG4zZHpjSEVzTlgrNE1WWE5kRGwxSlJEN1Rmcll6c3RJ?=
 =?utf-8?B?ZWg3Vm9jc2ZTNk5YVDR4aWlCeTBHZjNINjNkb01VVXBPWTJxTlRidkl2bEp3?=
 =?utf-8?B?eG9pUHF3MGtyOG5nUG04ZGxrU3BMWDJ5elBqcndWcXNKak9oeUVBTW5XUCtV?=
 =?utf-8?B?ejNoc0V5b2VOdWdJaEVPUjBiMTFwVWRzT2E4d1VZZzBEYk1jTHRLanQwSldX?=
 =?utf-8?B?M1I5VTF2UXU1aWpqVmg1cG1PQmVMR3hxTWwxc0hyOS83VTdlMWJRMGRIdm5N?=
 =?utf-8?B?c1VaRzZNU0h3Z1RaNHp3VzEyZldDV2NNVjYxVW1NeE1oSG5pbXdKRmFEbytz?=
 =?utf-8?B?YjFEaThrNHB6UWJlUHZhZlNHd0hETUlwcHRRdGVUaFpsQXlpZTI0RTVVQVpk?=
 =?utf-8?Q?uF94/wdwvSVNEsAPiXxQBwXF4s5iZvkl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8643.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGdBNmZvUUhPa3ZxZy9DMXo1dnhTN2VNWlJFYTJWbVlOZ1Q5N3ZHMDdvcEZC?=
 =?utf-8?B?ZXlNTlpMUXFmd28yNTduUllCWmtjUWUxUmp6K0xwUFlaMVdYTkdDWWpUN3lS?=
 =?utf-8?B?T0lLbjYvelZ1RmhqamFpRnpKdDdzdjYxWFRGajFqVHp4ekRPaDJjelVrK1lY?=
 =?utf-8?B?N1dTakVLb3NweU9MdXM2dFIzNDBjbDR2cStiVkhqMnViUkRxU3N2TE96K3V3?=
 =?utf-8?B?Uld1cUdtUmx5YitpUmRMWlhyUmZJNDBuNlRoZzNxNmlSSmpVc0FqWmhnK1Ez?=
 =?utf-8?B?YmxBQ09IQittemx0VFpiV2lMc3hneksvcnY4YzIxbFlwa0dGMWtWcnpjSTJx?=
 =?utf-8?B?RllIZW1maDlQd1EzN05qdk01SXIrQ1dLSVJaZTF6N05YNk9RYUFOOWNzR1F5?=
 =?utf-8?B?NmcxSmRNUWVuNDNuTWQ0KytncGtHVnFjbURiVkhNTDRmM0UrMWNOMjFMNERz?=
 =?utf-8?B?YTIzQVhzNTdRQWg0ZHkybzdNdkpHRldRbmlPdVNUN1pZZVRDTFFKb0taTnVz?=
 =?utf-8?B?WXhNOG0yUm5xU1ZhSkxWRDR2SGFyekZncUZkTENJdVBFaFpwUmNhTHBFSTNi?=
 =?utf-8?B?MEp2RVFhbk9kVEV4SGF0blhNbmRQb2xUTElOZFNWQUZmVTM5VzRhOGpVRlFw?=
 =?utf-8?B?emFDTnFGeFZ0SXRuUjNZQmVKYVFUaXBVWWhsekpaNHFSaysvbDlhNXZraGJC?=
 =?utf-8?B?bncxMitva2ZNU1JiampWSXJudFNQYjQ2WGRpQmVuWGZMWFdtZXhpY3E5N1F1?=
 =?utf-8?B?aDNwQ1ZIY09ZekJlSnU5d3IyK3c1SlFPV0ZNdFRWd04yZ3c4aGZ0V3JKOTR5?=
 =?utf-8?B?SFhRUTcxMXpyOTN5WjFoOGptQVdaSzBZOGtsbmhjVzVDS050QWlDaTNzMVBw?=
 =?utf-8?B?L2puSEh1WElkMGUyK1NjcWpOMnY0RnlINk1HNnVuVzFKNGtGOW5NUktzWC9M?=
 =?utf-8?B?WllPbE05NFVOOWRScTVjVHpONjEvcDJmNWt0M0trT25BL0xnbHN6UnNPcUZZ?=
 =?utf-8?B?eXo0cllFT2ovOHZPaFNsR1JLalV5SlMrZERmRU5HZmNXYlZtY2J2eHZCc3Jt?=
 =?utf-8?B?cm9id282RVVsdkNtWkticDUxK0Q1UlFlQnM3dHY5VDB2WDhhejVQZVdhREw5?=
 =?utf-8?B?eWtiZURFZ3VSKzAydllwQjFnNVV4OEVrcHFYMHFSSVZMdUU3bGY5WlJTTlhG?=
 =?utf-8?B?dmZFNExBbUpScGwrWEh2SHJjTmswU3FFTnI4SUNkQXR4Vk9tdjdFdkJQcnhE?=
 =?utf-8?B?WDB0WXgyZWh3VjJUWkVseVdwVEk2MytQZVNaazZOTDBkRmtSell5Yzg4SXhM?=
 =?utf-8?B?NC9BRkhFMXNSdUYyZnh0UmZyTnhMS3F3blNkK0R5d3JVMEV2M3JzS2gzSFN6?=
 =?utf-8?B?OVFQbTVxRk9GMGp5c3BRa05yVEQ0RWFDcUc5VnpjbFdGUHh2QkN2Wm9NTXpo?=
 =?utf-8?B?TllxM0dQb3JhSEFSTkxyWDFsSmk1YjgrMC9HZEtJdXAvYjh2WVBQdnREcUVi?=
 =?utf-8?B?dThsUFJrUXdJUHl5U2JXTENzKy9EVTVVU2RWRDAvTk5pbm54aVBWL2pxbFdl?=
 =?utf-8?B?cXVrODB0TlM1NmZBRFN1ZWFjdDlrdUpsaFlXMnhDQytqTExOQTRmM0hsU2k1?=
 =?utf-8?B?cFN3NHhqZkVDWERWNW5ObWZDVlk2Smh0d2dRR203dHlEUjVERFFUdi92TkFr?=
 =?utf-8?B?cUlRMmJmOUV6VUlIQ091RUtZTVIvODhRZmZtdm1ub3pYZXFBQmlrT2d6R24z?=
 =?utf-8?B?cGM1Mjd4dS9neHA5NktqZTEwRnVIa0dHV2hzMlQreE9PcHdzcGk4MjBGcDQy?=
 =?utf-8?B?MDVuV1ArUzczT0tqbXhvMUcyZjF4bXg3VWo4VXFKNTNVNDV2WEZOVjZxQlFJ?=
 =?utf-8?B?b3N1Rm9SdDFVVVlFVWJwTGJiODRudHdlNFFJMmdyVXB1R2tVeVpuYmV1cGVC?=
 =?utf-8?B?WGVtbURpU3RRSjZBNFl6VnZOeVdIVFFvR2R4a1BaYzUxTG5SY28xV2p0MjNj?=
 =?utf-8?B?NHkyQmg2SnhpdjNSYlVPWU4rVENMWVdHa09YZnFML29EYUgydVlkSEFFa041?=
 =?utf-8?B?UTZ2aUYzWTMxY3FuSmhla0Y2ZVJtOTI0eE9BbmZydlQ4NG1QOVVCN3NwNjVZ?=
 =?utf-8?B?OXVTdEFZVkZOMG4zQ3FCMjVZZkdycG1aVExZOUliTml6ZndxQU0rdVdHN3U2?=
 =?utf-8?B?cTIyMm53dW8xMjZKOGFzb0RmQ3dXb20wTDBRNk8wa0dWcTR5bWlRbXBjUEl6?=
 =?utf-8?B?YWlPL2hiWXltbzErQkhQdVcyY0R2bGhSWGpnS2g0U2ROUWU5aXg1eFBBdzZr?=
 =?utf-8?Q?PhzoJyfLU8Em6FhPFq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2931dcc0-15d8-45ab-5b70-08de52c6a38c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8643.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 17:10:23.7334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYaS3hud+K/oemDarXimfzt8BmDARD36DBFr82jS+KeYuDT0PR/UaV2QMTeg3D4873MkiS3iwid072CYhO9BAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5814
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69CA78000D
X-Stat-Signature: 4qmqmhuabqo8p6t3jju9gx7zyb33miwo
X-HE-Tag: 1768324229-148170
X-HE-Meta: U2FsdGVkX18NFMe++/75BX3JTXK+V4PjTiNL+n/A6dFY5L6JGrwWub/HYXXb3clCTsuCi7y3A9JngrmY9cdux3MK8Hhu113dwbarThGrqFA63FJ8IbJ6+OCVF2Jrbhkk/sdZdxDpoWRBzklysXD2+SUmlytjZIxeW1K0BzCQIhkWRwgrDuh6/OeVwVxg2pusrdZAmvmqxrYBCBDCudPFYmkMadeQEgMhKPunhM/LM+OVQBGuDYwA2DVNshX5nVfwjqcHNUUICtWmT1OngKjDNMUqnlttEogQLIsVrSy2Mrr/psQfB8wJH7Lpee2cyNvFOt8VqI8eVGK7uLsWkTB/eamhuN0PpwZkDEwGFsg3RKCpJNwlR2Y7bycW5TIlMr3q92QgHTgatfmGRMhvFXyU95kQ88M7jtNm4eShmL4gFAnq7k2qnBmdqrHQCcPupeEctRyw1oSK3Yf8s3GrxVv0G8ttPBEW2WrZ4d1hIHZtPLoMxqV/fLsNs4EfUDcKDonkPgYDMk6rUxbE3JDxA92ExjZGgojRGbTpkyJO4hFrOB4Tikh/QW9GO9VycR1ET5kxqNn3KM0ppxVpbO45SJNO4wqjeVasdUvhtYzG8YR7x2wFgzTri1cKtF7+MBHHxOUpvnKPE8cyKFwtAnaQ4BNKVJ/JDkq2qnxatZOA2stm/AsMNakdNzwwa5NJn6DoqdgzxDRRgd7DdQYlAQhBDnuB+v+OzmeaDyXlp4jZmyyUIoU2BNZEmuuXwydqTe60dbCmmkoi6blAsm1Glg4fWgqPSYvcim19q41oXt70Kos1ckO7EFbB8X4CX//pjA9ObHhix5TRm30LMEevT9YDEHD/AyvN8UxPxCBcJnnKBV7LU2BaeXGtYen+fLyDiIGIjVheBVr3kttfA6q/n+FN1JV3EpUwfFaG4sa/4KW6hLFX1KOdoRjgj3LtW/mHuxndcFjgAZ19yQItR+WH9K+lpq1
 mWCEYaqY
 8kRT/c2OXvHEpOE0nyn3IjDraPACMvTyGlxiXKXhGh8WOnuKG+MRGliyP+dgA3gF7xBHfGU+Pkn/XseMrqpXKySfMEF3wXKI/bV8SZluqPcT0t09liwkL0BFWeuP9RODOtpZuecosS2WsLUL3Mu6D9epf+TGoXiFc+FTbrQeyuCy4rqZZbKckdODEZt34iIGsQ3z3ZwxTBFJp+JQ5BpOcgNs5BsgiOVxHMBtzJ3RXvUNydUE+5Kd9GInBF+/GOWWUnAhcQiTOCuNifri9ZfV4FvIA/AiRMhbp3scVI9k/bvokNBRMZ63RfI2E0B3z6muQmmjZUIvzFY6KV6teKX8jV+I/XsgEwt/X3PCmpkniXItDRzauucJKjDP0Qpao/EoyV6UaigU17sFw57qJ0SGYI5g2/mbQo0Eu05OxT6/V9U9uIqVIx6mJgCUkRjb4m0HHJ0EL1otlIzYYsztfwwukGzxk/jHREzXOUOJAHQGAWGFG01TEWXFNr4hNQGan2/LVzcL2Q51v2GDCO3MWwgCTrSMSmT/IV0dgxG9BHckQNfPj4b+KC2onHHF6vVRSFAJMZeoeAhewk51PcVRdBY0/7kd0Pl9F8MLdsUmN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/13/2026 4:28 AM, Kiryl Shutsemau wrote:
> On Mon, Jan 12, 2026 at 02:23:00PM -0600, Pratik R. Sampat wrote:
>> Transition memory to the shared state during a hot-remove operation so
>> that it can be re-used by the hypervisor. This also applies when memory
>> is intended to be hotplugged back in later, as those pages will need to
>> be re-accepted after crossing the trust boundary.
> 
> Hm. What happens when we hot-remove memory that was there at the boot
> and there's bitmap space for it?
> 

While hotplug ranges gotten from SRAT don't seem to overlap with the
conventional ranges in the unaccepted table, EFI_MEMORY_HOT_PLUGGABLE
attribute could indicate boot time memory that could be hot-removed. I
could potentially unset the bitmap first, if the bit exists and then
unaccept.

Similarly, I could also check if the bitmap is large enough to set the
bit before I call arch_accept_memory() (This may not really be needed 
though).

> Also, I'm not sure why it is needed. At least in TDX case, VMM can pull
> the memory from under guest at any time without a warning. Coverting
> memory to shared shouldn't make a difference as along as re-adding the
> same GPA range triggers accept.
> 

That makes sense. The only scenario where we could run into trouble on
SNP platforms is when we redo a qemu device_add after a device_del
without first removing the memory object entirely since same-state
transitions result in guest termination.

This means we must always follow a device_del with an object_del on
removal. Otherwise, the onus would then be on the VMM to transition
the memory back to shared before re-adding it to the guest.

However, if this flow is not a concern to begin with then I could
probably just drop this patch?

--Pratik


