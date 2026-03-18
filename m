Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69277103E16B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4CE6B00EF; Wed, 18 Mar 2026 08:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9668B6B00F3; Wed, 18 Mar 2026 08:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DAB6B00F5; Wed, 18 Mar 2026 08:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB846B00EF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:22:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1914FC25F0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:15 +0000 (UTC)
X-FDA: 84559096230.13.1B9DC35
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021104.outbound.protection.outlook.com [40.107.130.104])
	by imf19.hostedemail.com (Postfix) with ESMTP id 33FAF1A0005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=wOkulb4c;
	spf=pass (imf19.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.104 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cII6IWXqlDfrwosr4EmtT1W7PdmqCqC/TgOY5suwxNA=;
	b=TCHjVz97vIULicCWrwmBpiq+KRUohOTBDWqCVVMWA2KaMw4mv/s+zHcNs7Jxdy5l+oNSm/
	P92rKxtEReGqdy7GyF/X0U+yWxYdCdcSACiDQ6UmnyyjWp093vclfh4fWbv/TBCAPuqA1A
	GWIdfznssedN1xESWGgQc8PMEb1wBL8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=wOkulb4c;
	spf=pass (imf19.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.104 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773836532; a=rsa-sha256;
	cv=pass;
	b=lJBFPPTZzGQbkQLhMsl7VbOt8Hg0r8TpI9Z9p7vrtzcnDgaKJZ96aoqAhI+foTAQrcSIRH
	/buEjVzmAEyu51JdEZ3BynYrOpW/B3p6SF/GlvVgXQaIvV8yzRlTwhdocix653qIjuI9NP
	Kb+U9RpCTkAN+4eOKsmWG17Vn/u070c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FG4149eeF2BypUeCc3oTpTNoT8xaq3fLJsPhQTR0qVqBTA8Hi8DgBoikPfOjoJclMbDeojIqbUeirW36/RK7jAiLU6e/lIkRL1U7ccwBEHiUV2pmU/HoXt1d1FbUFNw6u+7tW1cv78Fpk28AkpfESbAGmfntKPZdEWaV2Dfa293sSze7jAWGNgjWOYxm0nl0fjukP7VnEZi1oo9gj9KECLKHnzxJzVmzJvdeiTVapMP/cQXFRzF6hj2fle0ZjpVE0ggm6KTRtiDJk7y95ziqdc6hlygP0ltVCfypkVYfMax0sGkOQzRqjWS4yY5ePyaXSvKKrisxdpgPRVCECnROpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cII6IWXqlDfrwosr4EmtT1W7PdmqCqC/TgOY5suwxNA=;
 b=upbY2dtuqxYEWiQyKMNpSdi/S7t0i42ynVBIW4Kc6khzfrRvyK24C7+3IcL/FPeDav0faSVkg7OghaDwiAQgj8aMFcgXiBqWBMPouQc9mKrmWJw0ST76RJZYL2IC+Uq5uqHYqW8fZeC67Q9/SnD8ZsGaxRVOa2Upwvukno/ax53yHh9YTNXZeGp+V1kNVBGv+HfLh7k1T9h/trkLXUgWtafaqQA9tNb/T0vExqmoxVIyknHvFQWVTVJl/Ht0U0oyJn9V1q8E6JkUIoKxQZujBs78OpDjqWV1LN/c2dsEaA+0TWJ7LRgsorpLMVd8rFNBa3QqkOLoJErLlc7Jxp3w+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cII6IWXqlDfrwosr4EmtT1W7PdmqCqC/TgOY5suwxNA=;
 b=wOkulb4c2ObMa8JGXaGPzdmfrMH6sMYKUL+AgGFHv7La+D/D9k2bu7umR1gN5HOSz0UrIencLkaDqXj6Fv18X7EMqKyF8Fo0/7oYXi4PlQPcR7cobfLYI6uJ380xIYiiJsLEgPoF22+9+MCCe305wD+gLwFuwMT/hgFNGjOptWm16bP48wML9fu9oG/d49tO6idHOuPgvqd7r+E7rb+u2HhyuMtxXtRU+hmidSN+yytJeon4qJ9OTP8xiVUsyMRz2MkA5BevePTD/viXB8Xok9i41pMo3OfU3yafNOFLt1Q144CBdgrVP/QfI421i7fLM48wXpECguAKjUWjKxztTQ==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 12:22:08 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 12:22:06 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 0/5] pid_namespace: make init creation more flexible
Date: Wed, 18 Mar 2026 13:21:48 +0100
Message-ID: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DBAPR08MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a1b2dcf-aa04-4d20-d931-08de84e8f826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|52116014|376014|366016|10070799003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	q2Tv2Q95XJBn9Ilwav93YKH3Tq7B8K7qyCB3JVEYHP+HI0z8R1zSjkndciEIk0zAEJpveH2/D8CyAyrPs1znsyb9PKeLiEEhHM0+kToGffY/GHBbTP19vjxQ5vtK7IYWR9fdANZy50B8dhzOVgraqes6M5AOxcujRzw+zomSaJjuFVEyZKGp0oLN0cr3XpdSWI03nUkvappKbwyyMPlg7lLO2uE8u3s+GzYbhXapq1MAVokLxyo7LtfUBTl0KncmTA52BK3eCxJ8iXn/c4I7A0RgtgrO61sMsGCyoTG/IaBrXrT+TyLs2p7TjOITxMG2tlf0RX9aSNcTCeKQN8Y9u/1DaK3GVE/mFowfzDLGhY3FRpiH/7ajc6rJvTiaNXnBzEYcf0s75IYUdUY7+3AUFw8+y5J7s4u7EV7M5oJq3pmWyl5asQtFsaaVzy8tIza4mRbYvVx387aaBr6qptThGk2l9FO9ufi5hthnpXoQWC/2OrR2SM2Ro6XyonbFwsDyqMvkyXN56hnM2PNI59sKFaeaeen8cf+gvF8p34xJfkRzuc8Zg4aFW76yJe1tbUn78msL+A/x5hzdHefzjT9SIKedHpBX040RQyLXa2H6Fn29mKGk7mtXAq2ePrzDZzMYgRGFMf4NUoqYpe6q23gtNP/tNrKY67FOZrx3c43VTpVLrFU/eitjhHiGGXLLPbPbHKkTXENzyF+NPr3cK6GTPzXUa0TtGY6cdOfr0125ERU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(52116014)(376014)(366016)(10070799003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHZIamZZTmp1cXUzMk52RmozYmtMOHltYzMxZjVlc092VUd5TUdERU10dGdE?=
 =?utf-8?B?V09kODgrLzRQeGk0QWdleFZHWEo1RFhXMHQ3RlNlSDFKeFFEQTRkdzNxU2Fj?=
 =?utf-8?B?R2FNRnZrYnpsd2lUTGt1ZHc3U0JlZ3piQ3MwYjZmUGo3MmhGa2FOZndmREFv?=
 =?utf-8?B?cmlSUlR3Ui8ySHVzbmFSMG1KbWlEQTlXUDlnVHYrdXhzRStzc1BRQVl2OTJj?=
 =?utf-8?B?b2dEVm1pNTJyaUJ1cnQxck5qZTN3bmFYN1BiQzYwYVRjN3Q0bENQVW5UNjQy?=
 =?utf-8?B?K3h5OUl6OGFCbDE0MUF2T05tbzV6OUd1ckhwTWsyWFFWbGMrWUdVUTA4WUc5?=
 =?utf-8?B?QWEvZnhkTnh1VXdvZjdpRUtrNHloNzJIeHNZZ0ZoVE9KYkxZRngvVmVxU1JL?=
 =?utf-8?B?bkxNUTJCUzlWejB3R1FSNUQwNWEzZDdvR04rOWprdkNkZFkvVEdqSnJBeHVZ?=
 =?utf-8?B?eGRDYVBvcjk5L1VMYnNzWWtxa0tPSmI3U3dMNUYxVTd1Nys3S05XczVHSWEx?=
 =?utf-8?B?d2trY1NqeDZlZXlNN2pQSk5TUzZqZDR1VXVTeVlvNjFyV2VZTXkzcFZ1bEUr?=
 =?utf-8?B?d1ovWmRCcDMxMTQ1czhweE1MY2FYbURHYlE5SWtrYXdYaksxWGw2YUJ0cHAr?=
 =?utf-8?B?dVVsSllsYkhKWlN2UkFvWThBRUdUZDMyc1JaTDdibHd5WGhVRDY4N2lsbDJr?=
 =?utf-8?B?b0hBVnJWSmdiQ2tQb3ZZODFpRmZRZjI4YVFPTURhaFJYR3JDT1VWeHVRYlZG?=
 =?utf-8?B?Rk1SeWZrMzZPMzNEa3d2eVJQNWJBVlBxbmxLOFRldExGcU9XaWVUZVJDMEdw?=
 =?utf-8?B?cm10OEZob3pNcTVML2QrVWhudjVzNzkzeXZMblFVVVZQYkRKemZSRGcyYU51?=
 =?utf-8?B?eUpPYldBS0FveWtNcVFuZEdpM0JCb2pqcnJoVDhBZ0lOdnRMVXl5ZnpFWjNO?=
 =?utf-8?B?T3dGS25hdFVVaXF4S3dkMW15S1d6UStYT1F1d1JKaFZabVQ3c1hwZHNOQUpS?=
 =?utf-8?B?WTIxNk13cFlPYWVLZXlWSzFRc2MvNXZwUmZhTWdrMVRJd1Bsb0VDNHRWaEVC?=
 =?utf-8?B?aC9YRytVVjl2dkF6M2FXUnE5T3ZGUU5DZXA4aitCaTQ5cjZRc3NsdXdrdit0?=
 =?utf-8?B?N0J6b3VVbHNNRmN3aXRTZXd1TGhYUDVDWitnTEV3bUxzU3RqanAvVUpkdU4v?=
 =?utf-8?B?eTd1cDBFRFFBRUlXT2I5cUpaQzVEQzBZYlJ3ZDdyNnB0emFPcFZTMGE5empY?=
 =?utf-8?B?UmlBdTdPZkorNG50enZVTlhMMzNmVzR4Ni9MVXpXMWpodzROdmR5N3RSUVc0?=
 =?utf-8?B?L2FmNXBMZXZyRlJ4ajNQbXlkcXdXNHNqT1IraldwSTA5ZUovM1JwLzB6TFp6?=
 =?utf-8?B?aUlWWTdjc3Y0NVYrenVDNzlRemgrMFAwYnpNUXMxTURNZHcrcDU3cURoZ2N6?=
 =?utf-8?B?NnZtdGxwelZkT24xVG5hN3lmcFFCU3creWd3RGlRR053dEpKL1BqYlJHTWFP?=
 =?utf-8?B?Q2swMWJkOXhvNlRmd0FKc2REd09VRHVLWUh0RExEem5uVTB0MHlyckV0c3lI?=
 =?utf-8?B?dnZhUm5DSGxPdEoxRmtTNSt3VS95bEFTMXVKZFo1Vi9TeEk1bDJad1VQQ0Ey?=
 =?utf-8?B?ZnY1aGVOaEVPTURsdUs2TGdOMWVHZW45QmFuNHd6VGtNUExiOWhGUW1hdUhr?=
 =?utf-8?B?enhLZ1pXSWFsOVJaU0pmM3JTekYzalFmai9ndk9mV0pDZ01LMWNiSS9nck9z?=
 =?utf-8?B?UWNyTSsxcHJONHRwYml0WnV6SVR3QUw0S3JZQ2RxMXRMK0J3WGF2OS8vQXRj?=
 =?utf-8?B?c1Zaek1LL0Z2a2xhNXI5Q0RmQ2FMZVdERmJsN0JIZXo0cmN2RG5Md1g2SUNs?=
 =?utf-8?B?QlFsNExDS1RlQUR4T3dQNW4wQ3A5OFAzbkhtRUxrekl5ZTVWL3RoVHNOUEs0?=
 =?utf-8?B?NDZTZytSY3JwTk5JOXVLdWZoVDVaMVV0dVBzSG1jUzVVTTdBTXVPcTIxeTRu?=
 =?utf-8?B?SXliUXV0SllSeUVqckhMRmVvYmEvRmR0SUkvZWZuRnVmUGE5WVozQ3pIdGNr?=
 =?utf-8?B?UXdYa0YzNjROdGRJUnROTS9GVk1pVFpKRTMzM1lwRUdiaTc3bkVjZCt4Rkpv?=
 =?utf-8?B?RWdhb005SmJGdTdQTUZsLzJQZkhpSkY5OXZ1UE50WDFza3hQWHRPSkpXc2VE?=
 =?utf-8?B?anNBUm1IZk01SUlRRFRtYzBkWGJVQkhpQ0RCd3kyTWRnZERVcEU3S2FLZkI0?=
 =?utf-8?B?R2oxbGJmUlJXbDBxNXpuZWpRNHQrK3JMd2R3b2t0d2x1Lzd1SXJGSC84Y1ZE?=
 =?utf-8?B?UjdzSkNHYVlkYVJxcVdMMkFobE96eGlKeWhBNUlyd3BudnMydGZUVEZtV1g3?=
 =?utf-8?Q?p1GAEnKVV3xn9aD5gLcStldDz0fbct/Kwl3kyQXTWdjIm?=
X-MS-Exchange-AntiSpam-MessageData-1: 632nDw9uVM5SKsiIea9VHmUG/e2J3IVtTR8=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1b2dcf-aa04-4d20-d931-08de84e8f826
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 12:22:06.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdPH9tFv3nm7oLtDZCbmNWiPsrUNt6Gl6twKsVV8p+vgTXSQq/X2NhxOPfF8uDOf8di0RZvNpC8EculO9QKwJ2h3iW3K/ZnlwjCW3rlJHTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-Rspamd-Queue-Id: 33FAF1A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 5h1fhou195ch4b7nrdf5urht8tiksexb
X-Rspam-User: 
X-HE-Tag: 1773836531-413340
X-HE-Meta: U2FsdGVkX1+Y7mOGrAGC4XBdSxKRiN3ORYYzg/xNL4arzpDXz8JKGUJ5sM60x8GbvEvbiYXRw9sydenl8pnbZeyPEndzPCEW4aFG0lDoWdrh88de38GE7tfGw/vJyrFMiVSCSt48U+H6plA8WGWddkJIlVPJAn4dS9eG97BmArtCYDNSrDgEX2XzfqAIooCSnst5kYBJ9d0YIWObGk3qOyunjXmi2ircLiQADa+yqsEhHLubDaqzQu5IihFbA0AIQObW78l3xxEn/J87jtN16fDiIJO8Yns0pNMRTyWI2X7X89eayMwrh48VRTqy87P2UddMpMb5SQ1oopyIHDwlUMaTGmCRpxk8SEqfBriNj9RAg/AZhyRoSmUKLXbcrCZwqSaOoDJyCfpzR6pzTys9lYVelzP85+jBOM2lQnSF6kvHg2NgUnBp7afwd22qgFTXUVPvk8GVRaaxA06Z1BjtfwFnV3TZTo2vEwLFWIjNzfNUtSPBKZZdXD1G6O4U14TRW3Tc/a+SfAklxF8BOtMzI1vhJr1WmU0hLICKSZNi2KITnq/nrGl3ZEvBJC7D5fwK8cUTAi5s72C04swzs/ductzJ+WEauaiEFCJSr0P5ECryuldqKIHAx1WOKNWj/HmZ8RQASm35j48KypHNQvxvZtZ5ASYoj41zGp8opT6svGZy451729gYX1phaRLasZStLin1LlGPxg4kZO2qUIoDDbBZ3bgeQNXhl8/L9tDQZT+qN/Ja2Yf4BCp7Z/6CF+KYrdttS61HD31ZCNEYb9U50O0i3wcLH0sXC73wgrU1XWnXNuDcsFmlZgIBrUBEVfnLtOeUNM6IToTYLq1RE4XBfW1ZQDAZdYhoIsqfPaKPHfJE1TBUXU1UCwEBa0q9CJdhUNwR3NWtUvWTXo6R4pwgfkNSbPyCOz7hGFvJiDNvu03MzPzhbkdTFdbz1Ydrc8ooeA/gyb8Z2HKkmRWjYl+
 hQAPIfxe
 xdLW1LOL33j+TgYLxPqimeYbCG25jTYpblqmAHoq9R+fvY26pcYxyO/KjULDhrbA2z/71RkCZM0JBOdDfD6I8M3g3kJ1HHIyCcHzgjqbe79ILnwF1cAPO90W9n8KiBixp+vyIr+zAj/w0ebMvvdMxKrUwJHBXZfp6fEW2kawpWxkL7hkJL/4WURlOJ2ex9hYgFHG0Dt99qv5cx3ufEInnetkxuui7g2GIPHM1LUiGhEiIxhuMOMo9+N2xkcsZyUm1gwpQTFjWO3dpXkLHAOhmLcaJq1NtHGtdImZu8P6bHJu/s6xPYM+I2XZFtcsD2KWUFecNMjK8DTAqxRD1RnYfpbfpB5GSZNSy+9T6EP6NM4DadoMXSM6EJRRVWu4mf9LBdVbNcP36iqLPZgY+Iop9JJASDb1mOtW/kTN7CUKiXD+F/3yxSlNOsRqVPE+WPuG2nBvtjQqE9EVEC/+vokVmdIYNSi3cBO1LxuAN9sXc3ubz6eGvQ3U0GqY0NNmtxllsTx174d3gIOOCg9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch properly annotates accesses to ->child_reaper with
_ONCE macroses, to protect unlocked accesses from possible cpu/compiler
optimization problems.

The second patch makes sure that the init is always a first process in
the pid namespace, previously this was only checked for set_tid case.

The third patch allows to join pid namespace before pid namespace init
is created, that allows to create pid namespace by one process and then
create pid namespace init from another process after setns(). Please see
the detailed description in the patch commit message. It depends on the
second patch.

The forth and the final patch is a comprehansive test, that tests both
basic usecase of creating pid namespace and init separately, and a more
specific usecase which shows how we can improve clone3(set_tid)
usability after this change.

This change is generally useful as it makes clone3(set_tid) more
universal, and let's it work in all the cases evenly. Also it is highly
useful to CRIU to handle nested containers.

v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master.
v3: Separate *_ONCE change and "init is first" checks into separate
commits.
v4: Update second patch commit message. Include Oleg's review tags.
v5: Handle one more READ_ONCE case. Include Andrei's review tags. Base
on top of mm tree.
v6: Require root in pidns_init_via_setns_set_tid test and move the
wrapper userns creation to the top of pidns_init_via_setns. Add an entry
to MAINTAINERS file for the tests. Base back on top of master.

This series is also available here:
https://github.com/Snorch/linux/commits/allow-creating-pid-namespace-init-after-setns-v6/

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (5):
  pid_namespace: avoid optimization of accesses to ->child_reaper
  pid: check init is created first after idr alloc
  pid_namespace: allow opening pid_for_children before init was created
  selftests: Add tests for creating pidns init via setns
  MAINTAINERS: add a new entry for testing pidns init creation via setns

 MAINTAINERS                                   |   7 +
 kernel/exit.c                                 |   3 +-
 kernel/fork.c                                 |   5 +-
 kernel/pid.c                                  |  19 +-
 kernel/pid_namespace.c                        |   9 -
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 8 files changed, 264 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c

-- 
2.53.0


