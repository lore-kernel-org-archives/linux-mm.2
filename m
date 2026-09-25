Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB00C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 17:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3506B0088; Fri, 25 Sep 2026 13:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B106B008A; Fri, 25 Sep 2026 13:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A016B008C; Fri, 25 Sep 2026 13:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40ABB6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:07:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA01E1A06BC
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:07:05 +0000 (UTC)
X-FDA: 85252914810.22.1972402
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021123.outbound.protection.outlook.com [52.101.100.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD06D20002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:07:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.100.123 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790356022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ginxbAxDpO41IuzlVyQlSUGRU69R0b1raG2CJ3Z4Z74=;
	b=nbrS3do9u1og9w9pXuybdvWavXPT3lIpwfO/JREOoWPOocjmOgFKCryo5CJWe9Tf3ma9q1
	ve+V2R5IrvlT8FuVcMRgJsz1RTeYFoET1HkpoGfhvy7R8a/VHpM1yrIldhPMa9fOlBz9Ug
	fYOQN/5AmMVCKxfqLrgx8mi426YXH80=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.100.123 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790356022;
	b=ogSNpbW+Qf/19rQiA+LbVH3fZd3FH0ddadzBIBZGZWrO+JW1A220yT2hgJ/2p7ZvLDSX90
	xGxEpv0IUP6v9cTiewpU59tk2+JScXV36qTj5mhpIJX87yMvJzU1o7AtWDoPE5oY0kfriq
	+g8xjhWuGwaHWLfKaKM9tgoFi/c0wzs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlsvSaRDeuQP+Vm20ogl2kngwXXLPVhQsWZQdmhiyqG9MD3wg9xWELtCZySrkp042m7n6xTo2hJB0wEvqZ225fi2wJFsA8MgR1EWWxHDxkEYKctyXV2IIFad62zy8mSlQINMWpgNnvg+xe0rj5S1ytslycEN3sMWWjZ97/QHtPzdTHeKiZ+AcqtWx4iTgTH1gwrtAv65wf3p36ThWpLVXGzkUUu7jptavamTjV7lDRd5WBFjC0TuzCbS/Qseb5BgDMuCyNparLWiSO+aoLv8DroYjRDxxIgsJN4I52qhZwrLrw8fD2wEDlm9/RP5gPsKFjTmYJO+lmhXfZA8V3oaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ginxbAxDpO41IuzlVyQlSUGRU69R0b1raG2CJ3Z4Z74=;
 b=QRxkf8pFlNIAsdubY9UjI8agEQRLKxnu1xSHXe4YKLWSGBcqU058+MpOnq4ahUS90kHnvLH5yo6R0yMjeHfDqs2Wx8Xqqw+9mZg/lPtUkC9pI5sIeNHCoZ9XEIXvvqIcNwMP6r9v8+V3w8doguzyvHMddNIicjd4j46V+R67kWGCpup+EzynKxlGkaEeISJJPs942VN+s6n72z1a9ZsUsSkrpZHGXmp62kARl5ZE8cOu0+fYcD4ILz+zc99ryhwOBUPkH0nfs+jlpR2xCOqvPIr2G0YL5mPIGT1ndiwPLHOJbu3gOCIXCgSTOFGI2z0kYny+B9/DRCV9iX3oD8iSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by LODP123MB800673.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4f0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 17:06:57 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 17:06:56 +0000
Date: Fri, 25 Sep 2026 13:06:45 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	linux-modules@vger.kernel.org
Subject: Re: [linux-next:master 6196/6545] error[E0425]: cannot find type
 `initcall_modname` in crate `::kernel::bindings`
Message-ID: <xurzx636nabg7bxpw54amaj2uhdayw2qau4f3y472e3yy2gafc@jmfvaxez3lia>
References: <202609201402.NyS4lCWY-lkp@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202609201402.NyS4lCWY-lkp@intel.com>
X-ClientProxiedBy: PAZP264CA0165.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:236::30) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|LODP123MB800673:EE_
X-MS-Office365-Filtering-Correlation-Id: 498d95b4-b03d-4caf-bad9-08df1b276740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NgBYDydm3VzeIUQjO0xvnOpGYemBn1zptpz7+lrQL3DwnjsWLxsGTTC/fqYGusWcazVBm27XTnc64RnW+HcXa99mzQBgCiEjqouF5TbT/u1IUHT+De+WlUR9MA4ccdeGovkJIpYDvy6ut+9P+m4vgNjvaWZIhoCnxJU0SwMQZJ2lTp0+x29RNLvgm6DJXgQ7CxgUW1W6a0KJ4SNOANckqxIYDAg8F0uKEYObWYeCYzvShQ/9scguGZBXMj/cO4c0ZDUN3bQbep0PfqCfTSXuV4VzyQ+uhTHdDWlk/wNhyN5TVZ3iwwJWboJ3SBSx9wYVhaLl5YONnNR/8kzOtLrsEKDfD8q4h9ijGif1W1YMTt322UZy2DwbU7tgnUL/dQadYWrKhzcyG6lLH85A8l7tdwbVvXeLoLIjMLkzxGoqptbDgnDm8TVVKnOjdD5+x/aSvZab5/jMkR8TFd0Ubinha8dY2FzaNrjcbUVpJpnGz3w9D2WiZ7bkREE5rLb/vR+4nwOwf2VXlHjVWLjDuYQdVJFiZE8kIRZIRAuRtFlEZ9gNgNWCcEX0P3L5iPFuk7l5+ADm2WUEIAAlahy321Q3k3z53bEmdSvLszO1q2r9R4wKvJw4cAaxwqRy10g3C54d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnFKMkN2djFXc0RxaG5IcGRRNklSaTlVdGR5ZTVISWdKUEpYakNzZTR4YXBw?=
 =?utf-8?B?N2VyMkFJVVNVODh2MkFoZWtGb1ZxSVQ2WUJSa3hNbWxqaE5VemlBOXZRcUdw?=
 =?utf-8?B?Z1pVL0xybHdvOFdLWnVJa3FBSEZYTDhRYUhSOXVOTnlaVmtONlhqckJjaFlP?=
 =?utf-8?B?N1hRVUE4dzFHTnRsVHhPWXNSTndlZWE4akUyZkRnKzRiWHgyYmVSbFZsUXVP?=
 =?utf-8?B?YWhuSU9qL25xNkNjdHROTlFwMW00UXNtYmV5QWdmSTdjWTZtb1UwSUNORjhE?=
 =?utf-8?B?SjRpMC9nTGRCUGVVbTZwaEZmYXRDTno3eDRTK0I4cExMNjBwWmRTZ0pLMWZo?=
 =?utf-8?B?TUh6dytPNVJZYlVORGVJOGxudG0xaG8zWnJTM2FJaXlETm9ocmkrMU4wNWZq?=
 =?utf-8?B?bGJpbGhKV0hTVVNIWnVjSUN4MVJ0Nys5V3FBVnpseFdqZnNIb0JIdEZQQU1i?=
 =?utf-8?B?eDV5eFdKRzRuQnJPTURHenR2MWhZcENBbnYrWUhkV3JXSy9zaVhOd3ErR1FB?=
 =?utf-8?B?M1l5dkJOdlMxV1FJVEhuY0hPR3Fud1BYdGlwRlhIRkxCdFRJNXAvNzdsMWha?=
 =?utf-8?B?ZGVoY29mODdBb1hDdTRsY3lSelR3RVVKa0FndWZCZ1B6TmtDODQ2M3Z0ZThn?=
 =?utf-8?B?ckNySkQ3L0RwZGlmTnlZRHJHYVZST2h4YXhZd1N2SDZEYW1QbEM4U1FIWW9I?=
 =?utf-8?B?b3E4UVc1MWFrMGRNbWZ1WGpIZW90WDhrMzNWNmJYZ0xZclNyRHpnc2dmZ2l0?=
 =?utf-8?B?QTNjNDZCeUVPVmtEQWxpeE4wVlF4RXFodjBnelJ1dEwvTTluOENJd0VGTitT?=
 =?utf-8?B?TGNzS1hEOGt0U1ZlNWhaTHBNS1RubEM2Ky9vK2lITm55V2dpMEIwTFI3TVBE?=
 =?utf-8?B?WnVUdk9EaU40UGJabDZrYmRLSVY0bTRXcWRPam9CSWcrVnE5cjRIK21Seith?=
 =?utf-8?B?dktlSk9CaFNvNmMzYTk3NnNzbWlvK0FPSXZKajdqQmlHdlVUVzRGSW42eUxI?=
 =?utf-8?B?YitqeUc4TXBSdEsyMXFWbk5VNjZteUI5aFdkQVpuZSttcVNXTVgyaTYzd0JJ?=
 =?utf-8?B?SmxRbGhWOGs3VGVERzJncXVCVTRSNGFHY1laR2ROUEs0Q1NxaUFYbkIzVGlx?=
 =?utf-8?B?Y1AxUmlOQTZvaVcyeXlOblE2Q2d0VmdJK1hZcjg0MGFreUQ0dGlFVUxuNXJZ?=
 =?utf-8?B?YTlSUWsyMER1YVVqNEdwMnZnNkY0Z2lialJyVWpxTEhKd24yb2xzWHY2Wml0?=
 =?utf-8?B?MEpUSTZuUHBBNDRzdklBY2JQYmFDRDB4K2NzQm9QR2pBODRyLzZmVVR3QVVC?=
 =?utf-8?B?ZHErWS9XWjRxR0d5SjVkVGxiM0dldWk5bTEwSktaTngwUXlXRXZoc2FCTzgv?=
 =?utf-8?B?MXQ4dUVaWjFHd3pUY3d1UDdtMTZZWUxySVV3azUwNjVKMm13WG1rdU1rU0JZ?=
 =?utf-8?B?SmdaUVZEdGVuSlhWY1FzOFlKY0F3VzY5WklORWZNSmxwcFZCL2x0WjJJMEtu?=
 =?utf-8?B?dFpXQVRsejZ5TUlOMndtVng0T3VFWHdWcHZRWCtNNW0rMjl4K3kwY1htcnp4?=
 =?utf-8?B?a0RrdU1hY0w1TmxibjFNUlhNQVYwYWcrMjBBWHppY1Y5RzF1QnhuTngyZlIw?=
 =?utf-8?B?TENaUmVjUlYvYlluV0pYSUZtUVdRMmJJaHBENUIwSEYwM3pxNGhEUUI0ZXU3?=
 =?utf-8?B?VVlPUWxuSlhGWTFvaXRlQVJ3Mm5TVDc5SDVHK0tZcGoxeTZENWJiWFFUZDVy?=
 =?utf-8?B?R2poc2I4RDNjaHYxTVBPV0FLRmxwbitSV25XOTBqT29HQytjaVJ0Tjk0MHNx?=
 =?utf-8?B?MTNudTlXeHhhTXEwU2NOQUNDUHhSMnpHcnROZVd0enhJZ3JOdnZuT01ZTlIv?=
 =?utf-8?B?RTFjYjdIN0QxSktsQkZ0ZjI5QXA4VzRVeld4c2o0RExiK2JVcDc5SkdmVmNa?=
 =?utf-8?B?VER6bTRVcHhYUDk2NnRPMGFTTVBlVFNZL3RNZ3VLQUpjeDZaYTMwU3p2ZWdt?=
 =?utf-8?B?NERzdkNTMmRyQllGQmozRVdTRy8xcjhPaEpFT0pRUGxXKzlDU3BuRElOZHY0?=
 =?utf-8?B?UXJLZUlDOEdmbWJSbVZQY09uQXFXWWhHOE14Y1RBRmluRHkxWnAxanBXK28v?=
 =?utf-8?B?Y2U4U0NScmZpd25GbGVUTVVCQWt4K1dLMUgwWlRwZ1BGS3FuUi84OXF3bko4?=
 =?utf-8?B?UXZWc3NrYWw0T29EbTdLYXFBTktRTUdUN2lSajZxS01DV2FaQ2VWVmZpWm9H?=
 =?utf-8?B?WkFSME5US0lnQkVMWkxNZHBJbGMxTVE2NkR4bURvekhUMEFTejcweXlFcDdt?=
 =?utf-8?B?eVNPZGJJOEE4cDc2SDJJcXh1UXVaVC9DSUtZSHBxM0VydUlqUWZUQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 498d95b4-b03d-4caf-bad9-08df1b276740
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 17:06:56.6142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jf5oqRY9VMwTNd23Eyn2UhBRgwa+CbvFlaoQM5vwTrlbW33BGU7QZJH+Il1BOXNgbCsFn5QmNdPdimUwbJo7Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LODP123MB800673
X-Stat-Signature: 64qhpndfxqm7ew6d31exi6iks3hhxnn8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD06D20002
X-HE-Tag: 1790356022-178966
X-HE-Meta: U2FsdGVkX19WMZhszPhy2wl4pQctntHvMgBe823A3HaG0AaT9h+CGoumNCt2jsatQGuS1tNci4eDIyJYHo8QnZNkP/h71GVhOm/VdSoWSV2fOGAxqKCLIV/lXztkiztNBx3MnxOZCH13XqCrnKKRumcUt+W+C4pv6xsnkHJ3oVmyMXHe93xSaAKd2fHM+PfKYWJO4T/Grz+n1GPtF8slXa5TjIgEkK8/dZT57d7RH5WO6COi40o0juo2Xed270Rfld5O9qIHyDXwrcAphAbPhFml69aOG6VRpO1Akc8buYbjO0euRPb/W4giDzDtTHg+4nOwq+iz/1Xn+FO6l9acmyVkibGB7cDBn9MgD7VSOUmEF5uywNiyeabU0IznBmfb0L8OuIqYDuhr11V3EJ2hLEgzWNjnvPwe2iri794tKhls3RbrJlciS4Pqh93X3DS4kZrZx+sVyD8JJwuwCjp60upfZ/bfE+2xBZ6CdSF95cphUhorbrykwSk8IX6mqAvbHGJYXd4kl3gaHPVsWpP+gFwI8q/1Elz9xaQ7x3hMBxIitDYaRyTTDaNSSDn2JwGvpqOK+eurf2S5YMVTBBfuX//a52OJDfolZ5IUYJdCVDtShFlqyNEcAyb/ZwA3SREFgYh+YeulJrZLxrLGz3sk4nE//TOVY94cnFxjYVFjtbcJY6o4p4WhWj8kIbNcSCXo39VJDM4rZ8HTAUaT4JWzbJEdoZPyw5m9XOl7MRvEX09Jjmzs6YmO3KZPWIfrVlTTayqOX9LdPEu/qPabam+lm1Zae3OmLtYSTVQnlq6vYV2N16evssVwxpfQ3Jg4YTbiplI8aADGovDPmhYDwHJcgkO1lNMVo7dEewZolG/HTwoGfMvnorXUCB0cV+MGd68fZ3Oi/LDAmN26AuUckjVcgWiwk7Gehmoh/qIYUG0ePxiA9eyYrj39r49RwcKzGIomoKSna+aL64Q8AO482K1
 AvHenF+7
 cKiXj2nA84LidD6t+68W8aZjJiventiFilwB1xwtNRV+5LxJ/3HxcyFJdbdL+zyBTsDZ0svZSiVN2pngNvu9ZP3/XAvuw76bgVlwTbtf9vEMI5iTJuCgC3SqNqv5xFt/2biNdFUuUDc2Fxqm5DdIfoMaImJfmiLTF3UKJg9Pe0b7lVLQs3giKoTrVVh6yZ/ml2k+DL6h39rXTVv1/xBmWLuYZF06pQ8pGcWOE1SBKj/NA6413G8vWdNToEERi6EMVlOp4axW0u6O7HDU2I0CwjvMhwctnoSnp8fdNd/yU8PhEVQw+2Y8XIZnuHSS5H6SLPc80887zrbCnYvT3oxJPSekfKmm7Lo3uPQWJhsORj2cHkLYIRyAFtwgTaF+uesDXbnLCTrtGxtMhUUa3VpAI0ABE3PYxQfu3CBVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 02:22:08PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   3f2425f5b5bbbdd991ca9cdfd5502e68d8895998
> commit: b83e83203582477b2ad0631e29e6fd88295cd9b1 [6196/6545] module: extend module_blacklist parameter to built-in modules
> config: x86_64-randconfig-1010-20260919 (https://download.01.org/0day-ci/archive/20260920/202609201402.NyS4lCWY-lkp@intel.com/config)
> compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
> rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260920/202609201402.NyS4lCWY-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609201402.NyS4lCWY-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
>    --> rust/doctests_kernel_generated.rs:7459:1
>    |
>    7459 | / module! {
>    7460 | |    type: MyModule,
>    7461 | |    name: "module_firmware_test",
>    7462 | |    authors: ["Rust for Linux"],
>    7463 | |    description: "module_firmware! test module",
>    7464 | |    license: "GPL",
>    7465 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
>    --> rust/doctests_kernel_generated.rs:7459:1
>    |
>    7459 | / module! {
>    7460 | |    type: MyModule,
>    7461 | |    name: "module_firmware_test",
>    7462 | |    authors: ["Rust for Linux"],
>    7463 | |    description: "module_firmware! test module",
>    7464 | |    license: "GPL",
>    7465 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
>    --> rust/doctests_kernel_generated.rs:12639:1
>    |
>    12639 | / kernel::module_phy_driver! {
>    12640 | |     drivers: [PhySample],
>    12641 | |     device_table: [
>    12642 | |         DeviceId::new_with_driver::<PhySample>()
>    ...     |
>    12647 | |     license: "GPL",
>    12648 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_phy_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
>    --> rust/doctests_kernel_generated.rs:12639:1
>    |
>    12639 | / kernel::module_phy_driver! {
>    12640 | |     drivers: [PhySample],
>    12641 | |     device_table: [
>    12642 | |         DeviceId::new_with_driver::<PhySample>()
>    ...     |
>    12647 | |     license: "GPL",
>    12648 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_phy_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_driver_serdev.rs:82:1
>    |
>    82 | / kernel::module_serdev_device_driver! {
>    83 | |     type: SampleDriver,
>    84 | |     name: "rust_driver_serdev",
>    85 | |     authors: ["Markus Probst"],
>    86 | |     description: "Rust Serial device bus device driver",
>    87 | |     license: "GPL v2",
>    88 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_serdev_device_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_driver_serdev.rs:82:1
>    |
>    82 | / kernel::module_serdev_device_driver! {
>    83 | |     type: SampleDriver,
>    84 | |     name: "rust_driver_serdev",
>    85 | |     authors: ["Markus Probst"],
>    86 | |     description: "Rust Serial device bus device driver",
>    87 | |     license: "GPL v2",
>    88 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_serdev_device_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_driver_faux.rs:11:1
>    |
>    11 | / module! {
>    12 | |     type: SampleModule,
>    13 | |     name: "rust_faux_driver",
>    14 | |     authors: ["Lyude Paul"],
>    15 | |     description: "Rust faux device sample",
>    16 | |     license: "GPL",
>    17 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_driver_faux.rs:11:1
>    |
>    11 | / module! {
>    12 | |     type: SampleModule,
>    13 | |     name: "rust_faux_driver",
>    14 | |     authors: ["Lyude Paul"],
>    15 | |     description: "Rust faux device sample",
>    16 | |     license: "GPL",
>    17 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_debugfs_scoped.rs:24:1
>    |
>    24 | / module! {
>    25 | |     type: RustScopedDebugFs,
>    26 | |     name: "rust_debugfs_scoped",
>    27 | |     authors: ["Matthew Maurer"],
>    28 | |     description: "Rust Scoped DebugFS usage sample",
>    29 | |     license: "GPL",
>    30 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_debugfs_scoped.rs:24:1
>    |
>    24 | / module! {
>    25 | |     type: RustScopedDebugFs,
>    26 | |     name: "rust_debugfs_scoped",
>    27 | |     authors: ["Matthew Maurer"],
>    28 | |     description: "Rust Scoped DebugFS usage sample",
>    29 | |     license: "GPL",
>    30 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
> --
> >> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
>    --> samples/rust/rust_dma.rs:136:1
>    |
>    136 | / kernel::module_pci_driver! {
>    137 | |     type: DmaSampleDriver,
>    138 | |     name: "rust_dma",
>    139 | |     authors: ["Abdiel Janulgue"],
>    140 | |     description: "Rust DMA test",
>    141 | |     license: "GPL v2",
>    142 | | }
>    | |_^ not found in `::kernel::bindings`
>    |
>    = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_pci_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
> ..
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Hi 0-Day,

As indicated below initcall_modname is now defined immediately following
exitcall_t under #ifndef __ASSEMBLY__ and outside #ifndef MODULE, ensuring
bindgen (which runs with -DMODULE) generates the type into
::kernel::bindings.

diff --git a/include/linux/init.h b/include/linux/init.h
index 833b837ce11d..08cb8a294375 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -109,6 +109,11 @@
 typedef int (*initcall_t)(void);
 typedef void (*exitcall_t)(void);
 
+struct initcall_modname {
+       initcall_t initcall_fn;
+       const char *modname;
+};
+
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
 typedef int initcall_entry_t;
 
@@ -273,11 +278,6 @@ extern struct module __this_module;
                __initcall_name(initcall, __iid, id),           \
                __initcall_section(__sec, __iid))
 
-struct initcall_modname {
-       initcall_t initcall_fn;
-       const char *modname;
-};
-
 #define ____define_initcall_modname(fn, id, __sec, __iid)              \
        __unique_initcall(fn, id, __sec, __iid)                         \
        static const char __initstr_##fn[] __used __aligned(1)          \

I will send another iteration.


Kind regards,
-- 
Aaron Tomlin

