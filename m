Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CF2CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935A16B0096; Tue, 23 Jun 2026 07:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE706B0098; Tue, 23 Jun 2026 07:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3246B0099; Tue, 23 Jun 2026 07:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 393106B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:16:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FE921A04B0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:59 +0000 (UTC)
X-FDA: 84910922838.16.8346D42
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021092.outbound.protection.outlook.com [40.107.130.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id B17ABC0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:15:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=bSQ7Kjz1;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782213356;
	b=RawDlko9XQhZiOva6zoVXXlRc+0RaP5fsLpB+2EIeNKsclP8qMr8Dmcti3tEsIVAIyPkEj
	u80c0LIpBioiCJT/Op7HscGr/3kgQE1GILcNmYAZyy3ELx790p3EANyJ/vZ4fYwaIp4sAq
	+fEalAcDOTS86JsntaNdzf/esPgmUYo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWbNw9AeJfx64sIXztFMGNnMWlJCcIETWjGyFPwDLMc=;
	b=3JjprdH/3/AjM6MtOWTCLx2SG9f+SZ84FqzWaX4a5nCYyOSTSNpyFXH+Yd8UhwEbDlZqDO
	T8ekCn8v6g0dmC+CltrocYYhFHcQ1qsLYyobK7jFa/Wu7n+/hOOXO1PyxYxI7NljTN4XPT
	/wJ1UIm3S58yNS5qsgDVw50+5c9q/AA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=bSQ7Kjz1;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.92 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmDAwTweRt0/VrEp9Jt9lm/odpH9FjnOPNggmW4jNARu7H3kqUE6F4FLPq9HfcdsALAWKFkilD7DfXrSesAN6ehWtBf0wN/AqrT0s4AxGmirfjUBEHpiCLCr/rurhMBOe2pHouiDjf+PT/N8Sa8cTOCRjEaYvfqiaEl36AsLMvVFsk7RUR4cvk+25QJwcOTQ7DNdjkpTHvT0A129KNErEexzxRIme/wQFZqXcBOzKLKKIzcFB47TH31jsBuJpXrKWMEdujE74xXjxCe0INPM/ATv1QUrD/H4/2ohe670/v7Bt359lQBzxzmbJrCUDoqK4lON6tMFhvFlCxaQvEd7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWbNw9AeJfx64sIXztFMGNnMWlJCcIETWjGyFPwDLMc=;
 b=E7Fist959hwpJSoAy6p50IMIJ++9krZ5OTGuDuQfkVrMkTHSpkmj8bDlqoeTUXsrLBscn4dlmKLeewSJkQoIiidAUsilSIvzd9zWoOOKffVPqwwLscpgsm/PNWVIHWTZ2cuWjTonDfdqJPLkje61uwrhyB2QKVvtvlfm3OlIdGirsWdpo6U+aLk4CaPnwd96xfXZr2PNmPJ5FwVphG561S4hpy9WK6CFvCGKl5UkFM0i7rRhsfEM8VsCszJC63goQeTzmlQA2cI5glZI1NWgrMVr4guz1gGJel2tfp/cl94v3RAm6OgyRPz4DcQPMyE4Ztc2RlwWHeKRPlxQh9R/jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWbNw9AeJfx64sIXztFMGNnMWlJCcIETWjGyFPwDLMc=;
 b=bSQ7Kjz1sc0Yi+60tIS+923dxvPhgU0jFfNUeqRp3nXkCBleDgBobghs8hfSSPbQotUd7C3zf/LDeTGAPkLN+KHGoTLtMBFLrgi5X91PLaUOXjROk5XwY6O0zc2zEaP0ZgD5t+qjEpX0GoPPoTdGan2NzOVM9Q/DktRq+g/fUifeuGVslScOpxT6uzUm9hnC8DbOUD2DZxU32/n/5m8KWxDHtZZXWq2DlAIJBj/iTBAQD9joPTWnSUkuMhsAZ8au/0DMEZo8yBglcSXuIs5yMzlDdJ56IhkZ2gP07LtSt4AhvgDeDTlTWOxT7m1dh9tGKm3HpiUWyxzZI8wNs7n1eQ==
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:47 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:47 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH 3/3] selftests/cachestat: add an overlayfs test case
Date: Tue, 23 Jun 2026 13:14:50 +0200
Message-ID: <20260623111533.2285005-4-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AS2PR08MB9974:EE_
X-MS-Office365-Filtering-Correlation-Id: 156a3111-d676-427c-87d5-08ded118c69e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	43H5Twf6rOanUvhVDO2+DKp+EHajZQs95QFPHxWvAH/IB8Ezc3VJasP9BHnm5ELMfjDB4Z9rEkcvL7hauUEqPdJtKbJN9Ob6KQ/CMSkfrHcZCTQwwG+xvCcqFh/KtYQHl9eL8ZJoAsewSnyUhvhOofm3FFn4pC9KU96R5ZXJ640iqQAocDcXNSDmPMjqxw0IaU7daqRDgws26T9k0cjA2FxzfkmciXp1gXdzV7y1NkPDNyhmeuKD1xUFT+gG3h05/+wrn+hVEiWGQJNxPUH5ksvjwAauUWoLK0NYGqVrYueXpEve6oRXZcnba7iFnbQqn51J1L+On509+lV5u1BPfbEmbHtznKK90BcBe4VypLulFV+7XtLNM+l3jobmQMWauvwj8plQseLIkieg0BJDfV0V7ua+bjn4sZhSQ0GPRzoCgjm7hRxMuq5tK7t9UMutsyxcWBuEPVdbpa5PKCMYEME1D8ezCqWJUnF932X6uFqpQNAtZN3KQGxZpTJSvX0YJ8eNj66uFcD1fcPFTSL9cWwvrcoB3Cr1k33Fm/ok86XgEvREcuLwZzJA1IDWFFdEY6PiIyTiFQw5vBVThIXH4gY4YfrJdb2nFLcKXMgiFI5f4tcaDHAkR7cB++1BHiTAtBMikwCdeBA4EyxA6HsaMIijUjj3gCUay9kVsGrhtfg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TFxABkXIJzCmOUvzkz9qalRd5p6AEmmIJj4prUHJxetFpfgL8piM88Z26+WN?=
 =?us-ascii?Q?5Tkj5hQJCvL8iN6u4tSa31dvohIKa8JVs2mtRZWZh1zCxVm6cFdU/Ygmli4M?=
 =?us-ascii?Q?GfKTf7l7DHnA3KpcF+6NNr+Og5HBQp87g35td6UBNMty6hsqUf9enobGVWvl?=
 =?us-ascii?Q?iZCQJaEMA17rQR7xy224E398SJ2oUsMlLbCT+EBWq2LHROhhC6vBrw0u1hZu?=
 =?us-ascii?Q?BEmKhRtnoWIUPTjGT8OPvcbi+JJDZ/ClK4JM8xSSQyvmTQcWGvt/bYRSnlZe?=
 =?us-ascii?Q?NMVdu4eFBsGE9EmSnmBpHfaKbesEAEBgNtjIorxqyChA4tkzv0cDjHDLLvUM?=
 =?us-ascii?Q?NVUxNT6C8feeWo3cRH66SBdFUoIM9hAK6sMlnkg60X7okWHlZFgiWvrwq7kY?=
 =?us-ascii?Q?JJxBFdtduYpY/Rl77swr3leacLkj24eZxVqEVTmK5ndJK+fM/E7eq3iiP9op?=
 =?us-ascii?Q?CfQKMTf4zoSYARR4+THpn45MdzhfI+qYIqgXL5gqY0RQtwB+4U54EvldCKFL?=
 =?us-ascii?Q?AP/1VFU7WLr5YVbuf7kb5DHowJ6yhaxs2E6AH1EB/89oS6t56znfNoh6Guma?=
 =?us-ascii?Q?etbz4V2jv4757K+aDf+WCtuezfldLgZ8Yj1gBQfhdlIg1UwN2AVvrlS4+TTt?=
 =?us-ascii?Q?aakTHB+yh+ONZnYcGCS1ZQAbhUbBjD4L9x6r84lBQSfDpd1cacJ1khFreq4L?=
 =?us-ascii?Q?MeAem42ggKIR9XlNstykPdEQnCBDUfc2oLxOLfXgNrtLlmScHTfl20u3Tffs?=
 =?us-ascii?Q?Rb82VyvIW/0zZzFNg/6I96O4r6QdmkSE0Ej98T0VbWFuPhPFYGarl2YjDRXj?=
 =?us-ascii?Q?JVkv6MpRF4Zn8otOAU6CUprNHqZp5Q5sOixAH91RuNgcWOXHUOPaua9d4RJX?=
 =?us-ascii?Q?9OyDuBSn5qRNRg2ZtMRLyXqTtI3ppDRM9bDYQBFtjMDkmG0VwrqYI4m9yePC?=
 =?us-ascii?Q?FYrcXzf2XqcWk9POQxex+bMGf346EiUnvOElS+zPvo56MmC0K/3jgUGqma9K?=
 =?us-ascii?Q?LRkm7ohwGiviyk+I8x34epPvzcPAdy4g5mr6hTgLX6tW+x0sFh1gIHowg5tl?=
 =?us-ascii?Q?0bc0eH7anSouXOhMfuz54VFiOmVsvYDitggMZnHVRZDU2YYlsuHqDW3qcBpZ?=
 =?us-ascii?Q?/12VqW/lWFeE+L5ZXWfkNrJU0RsOCK0HXo3nk16XFpzeH/HrNBIdEIbEA+2p?=
 =?us-ascii?Q?zQxBSStRlHj/UXH6Nna6+8vH0GKNYpLKXesFoxxDTRMKpJEixvxHqJlWyydN?=
 =?us-ascii?Q?2WzcV99beEcXVoNUuJzlg25etM58eShav9x1Ph4spp1zcNKZQq4O697BKNFK?=
 =?us-ascii?Q?X7RXvxhyevkl37teoalWKUF4jHUJ95iQ6AEwJSIy3Oe2rbopNTsPlsZTNIWK?=
 =?us-ascii?Q?EBgjAOc34PIRt5TQFmqePm43He8f4GMw2EO0jgKD8Ux/NU6Eh5TfgdyujYYl?=
 =?us-ascii?Q?4Fpk8yiaPnwBnjjGqgNfA1kmxYtou5eVCHPElQ8oOwAk8OX/q0eONzAZPOxG?=
 =?us-ascii?Q?Vwa4xGJnNgWJdJr8SOG9O22Cx3Fm0eYVZLLppAyrf+GgMe/5Z0NOz9PIw3av?=
 =?us-ascii?Q?TkaErls823QgXFS2Msd1pvzFj8FNrZnqNxjNfgg1hTix4ED8l4Q+PsYKOf6D?=
 =?us-ascii?Q?Yufr0sQ9iCLc5zLfE5pIiYNSbw4/StZberwK4GQv19QjEziJ5XfPLUWPZBbV?=
 =?us-ascii?Q?oYJFBeL8Sk5k5zKkzGH5BpYqxNIAWMzuumh5Pb82GKMc/KYBzzbYKG8UZgOc?=
 =?us-ascii?Q?WeoOeGkcv7TFiINdh6aawyQYB7X6FH/SKH+d+866BZy7GXOg4RBMdZJk3iFZ?=
X-MS-Exchange-AntiSpam-MessageData-1: emT9B4JvF4eaj4T6ynGt/kmh3RX5BL87bP0=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156a3111-d676-427c-87d5-08ded118c69e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:47.7201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YeAp9NTVmgNSQLmVx5GkrehbwCcUidFbkabAR+pWJsXHo7AYj3yoCtDxXScHUFWVhzrMKjzxIEOj+zq9eqx+kwqLeMp50vyvdZeN1URRW0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B17ABC0009
X-Rspam-User: 
X-Stat-Signature: t7dx9tsni1gu5r4bqk61i6pt1g85dxd4
X-HE-Tag: 1782213356-975520
X-HE-Meta: U2FsdGVkX1972/bQOCfT5cNfHjeAQh2YSRTx3UoOGa2GGdiTdWurtoHzQ2Rr8JwMVJPaOSPbCWg/HvuMocwIRcERWu7gLiKRbgVs7Z3zajbApvKmUGlXv69BEGlMxXAdu71zMQTeYpEXoOCofgOCanPCw+UYZ4lZCZgBI+tgOt/1W27rthyS074/XnqMmjm0odGnf7bGjqlEPvwQ9isKiDWLzCqzNuJVdmhXNkjtcM7DJlHpxAycxFfMYHcwb30OtzOFYr2XUitZ3ri/F/myi2DTjVoP//1qQHFLddh1HgM4u8CmTdoxoy6ZfnjK9lfueXoFpF9uZMx+pipvBU+L0R6uY9FgVsfXXyb7cWabmkAoMnqxMYSj7C8+jVA9jpWJ+79mSduI9+Ket3i+F0DngmjReBc3oz1kpRnCbit4ASHl+xY2FQy69hojSW/CnPlFCTFAYMQjzizkBqnbj+LWlL9VEmvnZCwis72IxffSxIAuGrPtauoGUJqm6pQAcDobtsN1dsX8Jc7X6T8tAqhMq3rZIRU4iX3bvwlYp/qt6tOier66tgaaqwquFWCaPI0CLI6b9kEN3ZgOcA7ZrNHn8ZxjCQSX7gvGFuI5wRMyDodf8nkSiZVZik1aFYIfblW6xkqt17GXH322sr18msMDPB19qixCAwqpxUGOXjJRhk3Z3CyWl9+H8DknZGcsdUc6Ulp8KMvqq2EsO68fiK8XXHH207vX3g3Rl23EvB8La9WXwwI/2vEZ6pLIwmaGhEr6u8M2i3F1xEvN4W06ox/+TPj6k62Zx3ZEGh3JyV0iyXpkRATwUgnwcUZ8pMFH+fasgwBDvQ7ZOjmu95ZKxNFYRTSnBygDEggwGlr56CqFqDF5qhpzsRUgPrxcqpJ1zyhM0Dt+14iWa5WZI0xrzGkH5LuqlF2meTe7HsBdNytmVsrT22F6zsbeDVrprxWXwPrT9zrX4dTXyOpDLi6azSP
 3G2sHxxA
 oydxJ9wG93a0TyqQtsoNtoBeKvyGO46oNSqEKY0v+RMgiJXDXr+/XCqbzGw1SaEYu3IpvKBw1Lx2hQiBw/H3fMBh+yvv5c/9r/0/3pwd+o+cnHHPe8XTeQxk/o7PV5Kw6v079sQoovAlRpDKs3DLonFSvRffoj1IaO4LmqxDVY1NymJ1Ir3G8Hzp0W6LiTpxMd7eE3Ql+ZBGexM7HU+uO7ISJENF90NTxeSn1IcuZecHyCRW5654ShaF+FuS3FPnVuxgb0plPnqhejW75+AU5Ipvm0lj9n2dFW6ARiYCnauC22PLmO7loJcN75n9DyrgYrP4tG2vz7sBGtMBRIwKBjz7fT84uvtG0LvtDj4cZ89Sh+UCwiei6BmXUEaN7wZ/C0fZHopXCLJP0xjRIc9BzBVS9hTmWrOlmm+8UlvJvLq6yXH6D4DZwDD0L9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mount an overlayfs, create and write a file in the merged directory, and
run cachestat() on it, reusing the existing test_cachestat() helper.

Also bump NR_TESTS to the actual number of tests run: it was 9 while
ten tests were already executed, and this adds an eleventh.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 .../selftests/cachestat/test_cachestat.c      | 75 ++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index 542cd09cb4434..1662d9817c50b 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -4,21 +4,25 @@
 
 #include <stdio.h>
 #include <stdbool.h>
+#include <stdlib.h>
 #include <linux/kernel.h>
 #include <linux/magic.h>
 #include <linux/mman.h>
 #include <sys/mman.h>
+#include <sys/mount.h>
 #include <sys/shm.h>
+#include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/vfs.h>
 #include <unistd.h>
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <limits.h>
 
 #include "kselftest.h"
 
-#define NR_TESTS	9
+#define NR_TESTS	11
 
 static const char * const dev_files[] = {
 	"/dev/zero", "/dev/null", "/dev/urandom",
@@ -294,6 +298,62 @@ bool run_cachestat_test(enum file_type type)
 	return ret;
 }
 
+/*
+ * Set up an overlayfs mount and run cachestat on a freshly created file in the
+ * merged directory. Overlayfs forwards data I/O to the underlying (upper)
+ * inode, so the page cache lives there and not in the overlay inode's mapping.
+ * This is a regression test for cachestat returning all zeroes on overlayfs.
+ */
+static int run_cachestat_overlayfs_test(void)
+{
+	char tmpl[] = "/tmp/cachestat_ovl.XXXXXX";
+	char lower[PATH_MAX], upper[PATH_MAX], work[PATH_MAX];
+	char merged[PATH_MAX], opts[4 * PATH_MAX], file[PATH_MAX];
+	char *base;
+	int ret;
+
+	base = mkdtemp(tmpl);
+	if (!base) {
+		ksft_print_msg("Unable to create overlayfs base dir: %s\n",
+			       strerror(errno));
+		return KSFT_FAIL;
+	}
+
+	snprintf(lower, sizeof(lower), "%s/lower", base);
+	snprintf(upper, sizeof(upper), "%s/upper", base);
+	snprintf(work, sizeof(work), "%s/work", base);
+	snprintf(merged, sizeof(merged), "%s/merged", base);
+
+	if (mkdir(lower, 0755) || mkdir(upper, 0755) ||
+	    mkdir(work, 0755) || mkdir(merged, 0755)) {
+		ksft_print_msg("Unable to create overlayfs dirs: %s\n",
+			       strerror(errno));
+		ret = KSFT_FAIL;
+		goto cleanup;
+	}
+
+	snprintf(opts, sizeof(opts), "lowerdir=%s,upperdir=%s,workdir=%s",
+		 lower, upper, work);
+
+	if (mount("overlay", merged, "overlay", 0, opts)) {
+		ksft_print_msg("Unable to mount overlayfs (need root?): %s\n",
+			       strerror(errno));
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+
+	snprintf(file, sizeof(file), "%s/merged/cachestat", base);
+	ret = test_cachestat(file, true, true, false, 4, O_CREAT | O_RDWR, 0600);
+
+	umount(merged);
+cleanup:
+	/* Best-effort recursive cleanup of the temporary tree. */
+	snprintf(opts, sizeof(opts), "rm -rf %s", base);
+	if (system(opts))
+		ksft_print_msg("Unable to clean up %s\n", base);
+	return ret;
+}
+
 int main(void)
 {
 	int ret;
@@ -361,5 +421,18 @@ int main(void)
 		ksft_test_result_fail("cachestat fails with a mmap file\n");
 		ret = 1;
 	}
+
+	switch (run_cachestat_overlayfs_test()) {
+	case KSFT_FAIL:
+		ksft_test_result_fail("cachestat fails with an overlayfs file\n");
+		ret = 1;
+		break;
+	case KSFT_PASS:
+		ksft_test_result_pass("cachestat works with an overlayfs file\n");
+		break;
+	case KSFT_SKIP:
+		ksft_test_result_skip("overlayfs not available\n");
+		break;
+	}
 	return ret;
 }
-- 
2.54.0


