Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0FCC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00378E0053; Thu, 24 Jul 2025 04:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7788E0051; Thu, 24 Jul 2025 04:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC69D8E0053; Thu, 24 Jul 2025 04:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A977D8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:45:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B97A802E4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:45:53 +0000 (UTC)
X-FDA: 83698525386.01.D3739D2
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013061.outbound.protection.outlook.com [52.101.127.61])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89793C0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:45:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=Ck5mLxGT;
	spf=pass (imf10.hostedemail.com: domain of link@vivo.com designates 52.101.127.61 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j2gZ1GPAYaRQwe04UEG7fyjmBPSujJfK3+RGx1T7+Mw=;
	b=d7LRCFLEi7GDRfv4yWfnCjELst5vEjnNa3wn0wwZlVoNJZ3Rt7YcN5Km5m/Ls9HVVk//R4
	opCNunOUD+53JLT9WnKUZk13qhtN/OEoI+WBdBx2yVg49N+TPWiXV7tGisXNW4XUDEbSO7
	bAKMm1dEJ4baPUGnOOpGGz4sYCXUfOk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=Ck5mLxGT;
	spf=pass (imf10.hostedemail.com: domain of link@vivo.com designates 52.101.127.61 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346750; a=rsa-sha256;
	cv=pass;
	b=TcnBCIpTP+RDwDobxPg/tSze3Tw8LJSihQkCN8KzJXqUG48BN8kHHkigSrUffhVbQ8GYp6
	rbDrIgTXXxkzjh53ctXIqIQLjUgiYludb18moZbmPhy1OAsbhaPF584x/m0Z9xHHIAjFez
	+VQcFMBTY+xz4fS1nAu8IaOAQ4SAGck=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gul6mbE3bafU5VkBV6kXHRsev6x/sEZm0O5uVAcRbhFtIGJ3RXhwrnErbI973F/MSViOGQjGOPmSNtR3eZ6CFR3PPLOayUo6JL2sLU9Yixieff2wdknYj9Arx1Jruh3jbHQlxx3/tEKMKp/qt9Cz7QESghBz5FdShjeH6KfxVCkXU2+iSDXirIzZF4NQouiWlOfD7acHXFVdinHKhr6PWoGbSD2tSw7AwIDaPxS1mlrJiZUYm95T/0XLErAvh8ML6EAiH7FQWDbbmC7Is7VpU7Z3oSjyHQYAWlvXfnFJJRSPf0zpboHFfk4Y+7ecqP9nYE2wwYXKYlV6HX3W3s+V2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2gZ1GPAYaRQwe04UEG7fyjmBPSujJfK3+RGx1T7+Mw=;
 b=oelT+Yb3Y87xmqeXaoBOTokVDM+2qNk/WPLmLwHkLOrLUBivK8bM3hHarqR4X6VCyyd48ckyGEg+Woxt093A/f58VNFzzColbTXO6CtTvoISnkwxT4bDfc5IS8H4aRnxDHFDtA9qjAdMmUtSsGGpLOrZ67jDPuJUAeTuxqPWnSTOyczcpUEx1pVhuC9YlAk1xq+HaIPILmXE2SSdr570yUcnZ7YputBDVEwrAvRhVKiTAXqOkgaRTz03MWtZSQmLL/BZn8dqodsyt5UcLdE+4bbW7rhW/+nnXSRjQtfjB40jQ96x+iYzXzanyp8PeqQZXeSoT5FDib5blC4AiDJuMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2gZ1GPAYaRQwe04UEG7fyjmBPSujJfK3+RGx1T7+Mw=;
 b=Ck5mLxGTWH3qjGk0HUU6d7ZnCNXm/GMeroWUHkxjX6ZyrEoNYWXqJPSiva2cHEWOgIWyCR2w71JoViXnz+ONJtHP6rYhy7Nlf3tILaFjJ5KvGuPyMHb8WAkvlWqqcQDE7OsyBshP1jS+q7/qjT6ZnDtTReRqLN45PlNJaPIEAdgdIAKAkPSIzumv7M/Sx7VoqgTwIEt1KIlwIwycT0N11lKAMAwZan5Q8BGKTwLX3gVMZR260ImuAyPHxro1+4MVZqXmS/N70Rsu0GsvSXrddXjz78z/Um7Fcaqrqx6LbhEdZ5HNLOF3kZgB6+pcrDxrzsK/cMKpBbygLwGs/Jef1Q==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:45:40 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:45:40 +0000
From: Huan Yang <link@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Huan Yang <link@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
Date: Thu, 24 Jul 2025 16:44:28 +0800
Message-Id: <20250724084441.380404-1-link@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYWP286CA0006.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::16) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|PS1PPF2A261C07C:EE_
X-MS-Office365-Filtering-Correlation-Id: 108ab952-754e-4aae-4357-08ddca8e77b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3RSWTkxUVdIUlNYb1JVbWEzNjUyeTV2UG9WS3QwdG9YaWUxK1U2RHBTNlpy?=
 =?utf-8?B?dXhGWUtUMFZJY3dOSGFqTnY5dGR5dGNrbDhyTGozMlp5a0piVmNpeDR0bXY5?=
 =?utf-8?B?UmFmVC9LV0dLcUtxa1YvWWVtcEh3QzJReXY0N1AzT0hFYVpNWGVVV0w2aTA2?=
 =?utf-8?B?ZEo5ei9OSVdLUzFpalF3OGZzc2JiT3JQcXdyVDJQTDNmbHpOdmQwWUEwLzlR?=
 =?utf-8?B?WE1nUGJTeWFHUTJkNkFlZDZqZEdZM05xYUdFWUxud2I1ZTl3RU9yV0ZKUlRX?=
 =?utf-8?B?VHdjWkdFakdUZ2VQNnJPanF4M1BRQVhBODMrU1NWQ3ZtRlk5SjRGRUtxUWpK?=
 =?utf-8?B?bkJCODdwY3dRK1VuSERsV2drRzI2Z01uakl0bmQ4ZEJpRXFkSEo4ZjQ3amZj?=
 =?utf-8?B?ZkRoY3ZFYk1hbEVYTzFQR0hHcURkRm1oSDFhaFg3UlUzbTJEa2RLWUkrNU9I?=
 =?utf-8?B?Wjhud2daWmxVREF2VXYxemcveUd0Um11cDdUZ25mK1dEc3pYVzVsQSt1ZFZV?=
 =?utf-8?B?ZVJXMVE0UTZkNHZQVytZTEZqajJTaUpJd1BqUDJmbjVxMVR5S1RoU3JSS3d6?=
 =?utf-8?B?QzJ3bDJVNmlFZFNEbjY2ZHloUzlmdThzNHIyQ05HWUlyUENNL0MrR1k0bmtJ?=
 =?utf-8?B?NGZob1dZWE9UdjRtTExGY2xvTVVRaTQzRFhzVXl6TXJ3Tm5aSXMxTjlHZTIw?=
 =?utf-8?B?cnJwT0VlQVhLSm1VOHVvQlNPdXdWWWNsVUJnVUhOd2lNc0IyNDVKY2REY2NX?=
 =?utf-8?B?SmNuY2J5RnZySVlRYm4xUU05UHd3TmszMGpQRVpIVE1EdzVReXBad0ErNS9j?=
 =?utf-8?B?eG10Q2cyVWR1Nk01Z2I4clFEb2tzcDZVN1c1NnRhdXM2cHhSdG42QmV0azNn?=
 =?utf-8?B?WVR0WkxIL3Vua1luMGlycXZINzhEOVhpYThBNThjYTdKbUQ2REdtdFlBVUVl?=
 =?utf-8?B?VGZDZGRlclV3L1BUOXlCVXRncnhEalplVkxKQ2hIenZwRDFQTCtqVzYxMTRS?=
 =?utf-8?B?WWZZWGYvTlZvS05pd2xOVEJ2bE9BZEVUU2JxZE9lUkEzSmdsdzFSQU1UcWxi?=
 =?utf-8?B?UHIxRjJmYmIrajJ0elliUkc3VU1KSVZwZzBSRW9TUm9ZQ0hpWk9YNlFnWmtM?=
 =?utf-8?B?UjZwaUR0akladStoang0cDlRdytsbEtUenc4ZUxhYUR1N005WXh2bExacnNQ?=
 =?utf-8?B?dzE3LzRJem5UQWhMSFFFUmdhQWxxa3hHQ1FPck1QTWtyMEdyOTVXaml5cno4?=
 =?utf-8?B?SGtxMXdPRGRBazBrYzNKY01xY1dMN2grU1lrZjlDd0NSbWlyNVNFV25mSUxM?=
 =?utf-8?B?QTRVRkJ5NGU4NkJWdVpjcVQ3VUdJZHVrbnJsVFkvcjNpbkppcjFNeW5tLzZp?=
 =?utf-8?B?a29jUnVYc3JXLzY3UGFwU3NQai9jZWV4dVR1Nk5LU0hwRThmRVFiUWlWKzZ6?=
 =?utf-8?B?VnZxaUtKdU82RGVxZzV6NU9XMGl0cDRXbjVObWllZ3M0c0FIRCtYc2hyQ3lT?=
 =?utf-8?B?VFdWV0o5a2ZQMHRHS1F5UC9KQmE4dXJKTjNpczBwbU9OTm1QNHdqM1dRdVNt?=
 =?utf-8?B?eENIUlhrT2NYeEtpNUV5VTJ5aitrMGpOaHNIYWVtWWZham5QQlNNVkM4cTZP?=
 =?utf-8?B?bzNkdHVFSHc4MS9ZUUkxSzljRlZYOExhMVI1RFA2VnpmRXowSEZ6cDVLQWs3?=
 =?utf-8?B?Zk9jUDczNEN4dmE3NGJBUzVLekh2R1RyN1ZGS21KdmpKMGlJeUVLUXNLb3lI?=
 =?utf-8?B?MWpDT2lGZ2RId1pFTkJ6YitlMHhOcDdDVkM3bjFGTkVLWUxMV3g1QWJEcmN0?=
 =?utf-8?B?dWtnbHZNczE1aUdTUWpIYXh1OU1qc3F5QlVtQlhjWVV5Mzd3Qnorb0t3NzUz?=
 =?utf-8?B?QjJrM1F3cjlvUjBFcW1nczZVYVJKUTJ1aVpNanJDUE5QaElnZXM3MjZFVkZG?=
 =?utf-8?B?T1VoUitzOWVybS9zRW9BMU4vRnZTdC9rVk9WanlKWWhpUDdqSjRTRjFzN3BQ?=
 =?utf-8?Q?Kxq7vgRdUXQxzmR8sl2mFBdTJBa2n0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHNMOE9hU0IzOHowRmREa0VCWW41aUtJMFE1SDRQSGo4ajhBTUt3Z2dkanI0?=
 =?utf-8?B?Wk1VTW90dDNDU0FkUHNkM0FaenN1VlRrR2tReUlZOXJGVzZEbFVuQmdaZ1JH?=
 =?utf-8?B?N00yeDcrYzF4V3hWcmhOcEdvSm10OHNvdlh4Ymt0Y2lNdXhlZGR1b21HUSto?=
 =?utf-8?B?NUl6Y012OXpROWVnbE9xL3VBTnpMS3RHQ2p6ZG1RN0JTdHRMMlRiV2JscEZn?=
 =?utf-8?B?YjdqOENIcU1DanhFMUFTSWYvVzNNODJPTUIvbHhoenV1OG5UaUdrRnlEemtM?=
 =?utf-8?B?bFJCb0pKWlRIS1lXS0ltamNHQmRHRkYwenhBbVB2b1oxbXk2Sk9xVm91ODFo?=
 =?utf-8?B?U2NTb1R0VUt2c2d6Rm1OSGF1aHo2UFdpWEs0ZTFtZ0RzYWNKbTJxV1hXQ0gz?=
 =?utf-8?B?WG9XbDZVaWFhYzVON2xJWGx5ZSs4dVBZODZSYytNZC83Z1dxNHI2WmZGV1pz?=
 =?utf-8?B?bXRzNEZPYWF3ZERuTS94MFFrTEdncHdKdnBJb0JlbHlpYVRJUjZJUjYyUWdl?=
 =?utf-8?B?aHhhZzRGTnVuNTk1dGM1MlNpOWg5YmwwMlFLZExtcGtrVk9mUHBUSS9IcFFm?=
 =?utf-8?B?MU1ZRnNtelFLcGxUd0w2Z1FybXNiQldYYWRhUGI5b0QrN2FBQXhOZWdFejdD?=
 =?utf-8?B?dlhpd0dMY0ZvckswUkpFRlByT3VuQ3N4NmViSnBET1kyZitNVE5CbWhFZThT?=
 =?utf-8?B?emJVWUhzQk0wdnJESlU0dFNSQW45RlBmWlJoTXpmZU1jODhSODJ0N0FWcXpx?=
 =?utf-8?B?ZUlaVWFGVjFDZFRWdDRqZjBRckdRRnpiL2UyOGdIN0xObUNpQkM1R1FCS0U1?=
 =?utf-8?B?a3JCa2IvQUphUHRVWkFKUElFVDl5eW9ndUdSSzR6ODVqM0VxZlc0Z0tyeVNw?=
 =?utf-8?B?MWwzOEFhUEo2T05DY1lSc3lrbXlLV3lYOGpHcVhjMHFIV1AvSW9lelYySFdk?=
 =?utf-8?B?bThLcFo3Z3lldVRvNFZSMUl4NUIvVUh1VUFTbXdnMWs3VisyNGYzRnlUa1V3?=
 =?utf-8?B?T0NqSCthVUhzQ092NlVtNTlvM0lCeFV0STNZOGd3VnVPbnhVWWduelJvN0xU?=
 =?utf-8?B?bHhzcDZaR0w5a3pFS29nenlkUTdHd0lGRFh5Rmp2bHRMeWxzeEMrSnJwZHdQ?=
 =?utf-8?B?WHhQYUJYbEVHNEtYeWR3R2lOSEpFYTlTb0ErWE5NZnJRRVFZRmNLYlNjM1FZ?=
 =?utf-8?B?SHZDUmNJSlZGaGEyZ282N29kSjI4RFJWd04zVFpJM3pZMkhKMFUxeWZBTzQ4?=
 =?utf-8?B?OGpnSjJ2NGUwVHBLeUhZeFNENjIrNGptVFNLMGtqdmRYNFN5NzV6d0ZoZ0l1?=
 =?utf-8?B?ZGYyNlpNVkZLZ04xNGRpMnc5WkZ5SFlhQmd1YmZHUkE5N3VldnJ6bXZIa0pa?=
 =?utf-8?B?QzJQNUFWdXN3S3kzZi9YaW1xelovQ1E5SU9LRThhZEpUTEhrWVdSeVc5bHZj?=
 =?utf-8?B?QXlVbWRJRlJ3YlRDSTVHbzZtNGc2L3lySXNaRktob2hTZnZoaDVIRTBLSjk0?=
 =?utf-8?B?UFYvcWd1MG94bWpBemdSb0ZoQS83bytPT21xV2hNeFJ3YkpMTlJQcUk3d0Ix?=
 =?utf-8?B?QmQ2NUhLaGhBOWlGeERpVWxYdnJXQmRLNG53dzMwRXhLcnUzMXNIYlp3UjFr?=
 =?utf-8?B?bi9Gbk5JN0sxakRJYi8xakc3THdQTzZieG5ydFBjdlhyWmErWHBXc0pUWGtX?=
 =?utf-8?B?NUNabW9GekdGVzBNUVNEeEtYbWdOdStWRHNJZDU5dk91VzQ5ZVFRTVB6aHp6?=
 =?utf-8?B?aXE5UllNbXM4NEFiY2t5a09PK3I3YWFWMGNaUnFmSDUyK1RNZVVDYzVwMHlk?=
 =?utf-8?B?MitCcDI5Wkx3THVBb2VzS2x4SDR0MmY4MjErcEtsc0NKL3VqYlJFWXJkNmxL?=
 =?utf-8?B?ZW5nYUs0bW9yUkRoaERZRkdKUEhsQUg5Q2ZJd2ZxTmlGRm9YTHBkRGpJdUNi?=
 =?utf-8?B?WUl0Ynk2R21xa0lhWGVoS3hFY2ljcGVvdHZvTnIrdVdxYlVNNytOOUs1SHh4?=
 =?utf-8?B?cW15RG1ZVUFvcUtCcis0QVh5SUsvbzAzQTdQcmVBdmdhVFdqU0xQbTh3Mldk?=
 =?utf-8?B?emlJLzY3ajRoSkxtK3Ztak42Z2N2MVZOVmZkRHVWVVdpelhodHdFU2IwOHVI?=
 =?utf-8?Q?AJP5j5/M+0P4WB3657ui78ZPV?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108ab952-754e-4aae-4357-08ddca8e77b8
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:45:40.1133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z06Hg8Q6f1KfpzQQmHr77xeQivUGAu6n+543qeaeSxOq3uFLxpiskNJ+UUCEKwHdeERkbbhHTJSVcvEL5KroFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Stat-Signature: mu3pdk3t9x4d7hrtaqey33ktxr8zm135
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 89793C0006
X-Rspam-User: 
X-HE-Tag: 1753346748-181637
X-HE-Meta: U2FsdGVkX1+YE3lRdpG7VJbl+KJd+wMA5vPRoFxOes4xnxC9Q0tzcIu4FYT/JIgR5YoUSKHk+E9XnORzamnpzEH2zsg7tkL8NAq6Ka0HgACXB8Ot/11c3SwOvgVZ4F+vAqSjXlaZp6+vAJsia+SP58ASkODktCJrT4IWZhwF4+u5MGgoIfDeCLgiRuP1B+whl1AqqQr9k5FqAgKAak9jfJOtTbGVSS4mLYdIB+fiUXkHgTpw4lNgPXTnzni1kY29tSrYkImn6LK21qWNeNdX6L0UbudkQ0Dz1/acRHsidDsBijf/5EoXkZ0G7kYKFREkeGYbOc1GpY1VtQyZ+Tea9nXVPDOcAhnL27CUBjym2eMkiCo4hgcAP0t7F6T6Jub/x9xy5W+KhVBOmJntzgyZAbpeigTX1pP2c3yukmupSm4hdBAZn3ljc/0d9GA2LiL7EL5BNYKdZuU92gbSWalOrrFfepRBLbS7Ok9Cz6bEKomuUJCnMG3LhKseNZRxSam52bupOUW9AEGerhtUBP21JKjsg3b3PfsG1xAdAm8qMKJ/u5G5qO25X+jypABGQuUQaziBjAJA/GfDk9LkxMtvulVL/p9IxJXOgSPvJGZ4HpIcCACi2wwt+MH6RNZGSnhyCqocwZt23Np6srW+Kkrt2tQGZwZW67BT2k3BzY9DIhqxozmTLJrqAL0tt7QsuGDrBTj1ZadyzMDxLXTGfqjHstkWpl62TArU/X6dAUxc5GW1Q95zzjWjYz0pgvwKlTOh2Ir+NO/bFPuck1QYXDnWnA+5QmKgmBVK38jdeC2Qu3ROtbjvnHLO9NP/a7xRWvbHia3WahfzkKR6D8hS6W/fobU9KW4vQhd3I/ZNkFXid00C1pODea2TkYIPMEvmWMkrUpE2YzxRiFyjTpB/Xx0Z9cMV7EFdy3XJm6ybpy/uYe4F0kfw+ix9wjY7pOYp7YYbl5k+FwKYtwEcrMnXEFl
 m5m6Pstn
 EFIg5fEJ8rKNpYP9grRwMluIYYbjvnZTxb+RHRgMhNkx5p/R74BDkVlxi+hyc0g/AXYhaZYfeU1eVAHqED/vgLJgBvP5URqOP5MY7+BJtl/KLxtw/RLVwo0PEpqdqWQiyRvxRPX0C8rl3tv21SvJ5oUeogE4KkIRW2sjJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Summary
==
This patchset reuses page_type to store migrate entry count during the
period from migrate entry setup to removal, enabling accelerated VMA
traversal when removing migrate entries, following a similar principle to
early termination when folio is unmapped in try_to_migrate.

In my self-constructed test scenario, the migration time can be reduced
from over 150+ms to around 30+ms, achieving nearly a 70% performance
improvement. Additionally, the flame graph shows that the proportion of
remove_migration_ptes can be reduced from 80%+ to 60%+.

Notice: migrate entry specifically refers to migrate PTE entry, as large
folio are not supported page type and 0 mapcount reuse.

Principle
==
When a page removes all PTEs in try_to_migrate and sets up a migrate PTE
entry, we can determine whether the traversal of remaining VMAs can be
terminated early by checking if mapcount is zero. This optimization
helps improve performance during migration.

However, when removing migrate PTE entries and setting up PTEs for the
destination folio in remove_migration_ptes, there is no such information
available to assist in deciding whether the traversal of remaining VMAs
can be ended early. Therefore, it is necessary to traversal all VMAs
associated with this folio.

In reality, when a folio is fully unmapped and before all migrate PTE
entries are removed, the mapcount will always be zero. Since page_type
and mapcount share a union, and referring to folio_mapcount, we can
reuse page_type to record the number of migrate PTE entries of the
current folio in the system as long as it's not a large folio. This
reuse does not affect calls to folio_mapcount, which will always return
zero.

Therefore, we can set the folio's page_type to PGTY_mgt_entry when
try_to_migrate completes, the folio is already unmapped, and it's not a
large folio. The remaining 24 bits can then be used to record the number
of migrate PTE entries generated by try_to_migrate.

Then, in remove_migration_ptes, when the nr_mgt_entry count drops to
zero, we can terminate the VMA traversal early.

It's important to note that we need to initialize the folio's page_type
to PGTY_mgt_entry and set the migrate entry count only while holding the
rmap walk lock.This is because during the lock period, we can prevent
new VMA fork (which would increase migrate entries) and VMA unmap
(which would decrease migrate entries).

However, I doubt there is actually an additional critical section here, for
example anon:

Process Parent                          fork
try_to_migrate
                                        anon_vma_clone
                                            write_lock
                                                avc_inster_tree tail
                                        ....
    folio_lock_anon_vma_read             copy_pte_range
        vma_iter                            pte_lock
                ....                           pte_present copy
                                            ...
                pte_lock
                    new forked pte clean
....
remove_migration_ptes
    rmap_walk_anon_lock

If my understanding is correct and such a critical section exists, it
shouldn't cause any issues—newly added PTEs can still be properly
removed and converted into migrate entries.

But in this:

Process Parent                          fork
try_to_migrate
                                        anon_vma_clone
                                            write_lock
                                                avc_inster_tree
                                        ....
    folio_lock_anon_vma_read             copy_pte_range
        vma_iter
                pte_lock
                    migrate entry set
                ....                        pte_lock
                                                pte_nonpresent copy
                                            ....
....
remove_migration_ptes
    rmap_walk_anon_lock

If the parent process first acquires the pte_lock to set a migrate
entry, the child process will then directly copy the non-present migrate
entry, resulting in an increase in migrate entries. However, since the
newly added VMA is positioned later in the rb tree of the folio's
anon_vma, when we traverse to this child-process-added migrate entry,
the count of migrate entries will still be correctly recorded, and this
will not cause any issues.

If I misunderstand, please correct me. :)

After a folio exits try_to_migrate and before remove_migration_ptes
acquires the rmap lock, the system can perform normal fork and unmap
operations. Therefore, we need to increment or decrement the migrate
entry count recorded in the folio (if it's of type PGTY_mgt_entry) when
handling copy/zap_nonpresent_pte.

When performing remove_migration_ptes during migration to start removing
migrate entries, we need to dynamically decrement the recorded migrate
entry count. Once this count reaches zero, it indicates there are no
remaining migrate entries in the associated VMAs that need to be cleared
and replaced with the destination PFN. This allows us to safely
terminate the VMA traversal early.

However, it's important to note that if issues occur during migration
requiring an undo operation, PGTY_mgt_entry can no longer be used. This
is because the dst needs to be set back to the src, and the presence of
PGTY_mgt_entry would interfere with the normal usage of mapcount when
setup rmap info.

Test
==
I set up a 2-node test environment using QEMU, and used mbind to trigger
page migration between nodes for the specified VMA.

The core idea of the test scenario is to create a situation where the
number of VMAs that need to be itered in the anon_vma is significantly
larger than the folio's mapcount.

To achieve this, I constructed an exaggerated scenario: the parent
process allocates 5MB of memory and binds it to node0, then immediately
forks 1000 child processes. Each child process runs and immediately
memset all this memory to complete COW-ed. Afterwards, the parent process
calls mbind to migrate the memory from node0 to node1, while recording
the time consumed during this period.
Additionally, perf is used to capture a flame graph during the mbind
execution.

The time cost results are as follows:
    Patch1-9               Normal(f817b6d)
      18ms                    197ms
      58ms                    152ms
      40ms                    120ms

The hot path show in fireflame:
    Patch1-9
      move_to_new_folio        38.89%
      remove_migration_ptes    61.11%
      ---------------------
      move_to_new_folio        32.76%
      remove_migration_ptes    67.24%
      ---------------------
      move_to_new_folio        37.50%
      remove_migration_ptes    62.50%

    Normal(f817b6d)
      move_to_new_folio        11.43%
      remove_migration_ptes    87.43%
      ---------------------
      move_to_new_folio        13.91%
      remove_migration_ptes    86.09%
      ---------------------
      move_to_new_folio        12.50%
      remove_migration_ptes    85.83%

Can easy see that cost time optimized by approximately 75.3%.
And the proportion of the remove_migration_ptes function path
has decreased by approximately 20%.

Simplify Test Code:

```c
#define size (5 << 20)
#define CHILD_COUNT 1000

int *buffer = (int *)mmap(NULL, size, PROT_READ | PROT_WRITE,
                        MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);

unsigned long mask = 1UL << 0;
mbind(buffer, size, MPOL_BIND, &mask, 2, 0);
// let all page-faulted in node 0
memset(buffer, 0, size);

// fork child.
pid_t children[CHILD_COUNT];
for (int i = 0; i < CHILD_COUNT; i++) {
    pid_t pid = fork();
    if (pid == 0) {
        // let all child process COW-ed
        memset(buffer, 0, size);
        sleep(100000);
    } else {
        children[i] = pid;
    }
}

// maybe you need sleep to wait child process COW-ed
sleep(10);


// You can use perf watch here
mask = 1UL << 1;
// migrate this buffer from node 0 -> node 1
mbind(buffer, size, MPOL_BIND, &mask, 4, MPOL_MF_MOVE);

```
Notice: this code removed many error assert and resource clean
action, time record ...

Why RFC
==
Memory migration is one of the most general-purpose modules.
My own tests cannot cover all system scenarios, and there
may be omissions or misunderstandings in the code modifications.

If good enough, I will send the formal patch.

Patch 1-7 do some code clean work.
Patch 8 prepare for PGTY_mgt_entry.
Patch 9 apply it.

Huan Yang (9):
  mm: introduce PAGE_TYPE_SHIFT
  mm: add page_type value helper
  mm/rmap: simplify rmap_walk invoke
  mm/rmap: add args in rmap_walk_control done hook
  mm/rmap: introduce exit hook
  mm/rmap: introduce migrate_walk_arg
  mm/migrate: rename rmap_walk_arg folio
  mm/migrate: infrastructure for migrate entry page_type.
  mm/migrate: apply migrate entry page_type

 include/linux/page-flags.h | 106 +++++++++++++++++++++++++++++++++++--
 include/linux/rmap.h       |   7 ++-
 mm/ksm.c                   |   2 +-
 mm/memory.c                |   2 +
 mm/migrate.c               |  38 ++++++++++---
 mm/rmap.c                  |  85 ++++++++++++++++++-----------
 6 files changed, 193 insertions(+), 47 deletions(-)

--
2.34.1


