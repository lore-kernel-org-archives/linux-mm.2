Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FAD606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ruXVgjrc
Received: by kanga.kvack.org (Postfix)
	id D04E36B0914; Tue, 27 Oct 2026 19:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5216B091B; Tue, 27 Oct 2026 19:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D4D6B091D; Tue, 27 Oct 2026 19:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1956B0914
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:17:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72BAE160BB7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:17:09 +0000 (UTC)
X-FDA: 85369968978.09.DD21416
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010001.outbound.protection.outlook.com [52.101.193.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id B2CE1A0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:17:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ruXVgjrc;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793143026;
	b=K/xEVJ7QJkqOv8j9KL5Up8136ZWGFku7YafpkNmg5BfdNrrQc3PXb77qI3kOJq4YfSZ5bn
	+MAV/77x45phV5e9UOJ9A1ZYtyhqsnahOHYYrpruB6zU/3l9JS1tIvt+/P4kzIRJPzyBMt
	9Pw059Vpi9/IV/4j7M2KKO/MJyuwdmk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ruXVgjrc;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793143026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhTu7JqjhH8bvgsn3urzIlT64xKmXMY4abe47R5djjg=;
	b=F1Q3LmsfTso+1gYfS2HIW3+HiTCqs51PIm5pY/fvbyGUy4BHqXQTC0GMYMfQ7lUYnSIb6S
	lJ5B1IT0TPB5/0HJ14KxEntE0lg98+kQtJ7JjV+YIm85dkz9vLkFoZ2o6z/hRAIhrEHX1n
	4tsyHDoGMknm8/VH2ACtq6DCzY1yOVc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wWSYI/746CKnpr+kmXfQh5vvCwZu6NiJZTY5uMh2JHMZVodZdKGOnigNsyykALHumk62xj/rAcCD/79x2XcoFHCWqPlaLLoSWcbmvRdZ6oxAIJvVinzxs2Qc2TXhymNxoCawUnrVnQwjXeJNvPhB57AmDe08QacbSBiIqHKl6apJWpOyFP4ih9WsgA/8+oOpEuQNW1lkUeXNtJeDiVRgo7VkUK6T1CX9SAS4NRl+mjqkRV16PcFWoIk2gYsuJy0X+jhO+WYbHLx/ar2dLv4ouXqiNSnySqAieb9/eq/s45DhoUadbxaUt6XXf5N39tyrftotWwVFU4njJlKBjsfFsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhTu7JqjhH8bvgsn3urzIlT64xKmXMY4abe47R5djjg=;
 b=Ju69IEb+zJkOAUEszMj5nmCYv8QXHr9wOtoWpXwwJ7cc1bED97dhb1nuDhK45EaNMK3535fb2qPXHE7f4rCahsdoiyEkEBTq8qxSicdRRN19QwgMUgONkeJHgEebEVEIAG6dwL1NsMghLBWbm729YyFfvPtQhVc56nKHoxkqpXpHjyqAvNzlRU8kGzwUOHuLRmL4lPk/eqebwwnPVmoCe/7WQ5Tl29IPT82mB3FL0pAavvIgnKYnM2Cs3Wdia8xk6UaEQBUUiPgGYhgbC9YKdJT5FN3uaKPxL7P5TdDo347O9lr3H+Qa7inENSE1AWD0OV6OnYGjxjI8mkimjvLvSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhTu7JqjhH8bvgsn3urzIlT64xKmXMY4abe47R5djjg=;
 b=ruXVgjrcGc1peQmtbTSgJ0XsVSDMeLCvj9YPAuFb7lF3TolkZJeXnMtrM1CXZgiB3Nr/dDj88UPnBDL19RGuhR6XaAp0TsnzLmcEL6X/sNea3yNW6L2WuYarvRu3rGRbHfFAHGZsze7ebTYaE3oAS0prAUAg607sD4Zwha2xBVRugmAtptCsNImFF9s72+v46OLrfKCzzC+Cev4RM1bZr0jEGRoTDQzjOhmd7imYXG0z6AxkOtomseyK5w130g2QDoCu5NvNHAdSiv334VDNw5oVhvMXs5Faj6BB4Ax1q/bhTQ8xoayIqeN8c3IaCqhJYex5KK9pOm7QyxnEHt0E1A==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DM4PR12MB6208.namprd12.prod.outlook.com (2603:10b6:8:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 23:17:03 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 23:17:03 +0000
Date: Wed, 28 Oct 2026 10:16:57 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: mt4022@columbia.edu
Cc: Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tz2294@columbia.edu
Subject: Re: [PATCH] exit: use READ_ONCE() to read mm->owner
Message-ID: <auEw6ec0h0p6gz0Q@parvat>
References: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
X-ClientProxiedBy: ME3P282CA0182.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1cb::15) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e51382-270f-4ff2-c70c-08df34806902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261021121427099003|261022075727099003|261021123027099003|261009223027099003|261022105027099003|260925022911599003|260925021911599003|260925021311599003|10067099003|56012099006|261026140227099003|6133799003|18002099003|22082099003|261026121527099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	XY1Pfl5Kg8/Lu3aZAJ5XzNZY+d7o3KmLHuRRG2kLPo1RpnON8lAreJUU2PEC2CoEwrs5D+cS9I+C249XqDkixe3wp+hGycuifY+MSUb4rXXcymQr+NV/NT2ehihAkiIXNx+ohLc0JmyxfX4tbEe5ZRxG0lViisN10pQIE3CzGqNMY0uyLr+jZ2W7fuml0kPFvDHz9I5aMaaC7k6FL3cUUW2DQ/Pg7k56Aank+OVj+TeuU68tVQQKxinOeg7dl2P5QRxHyh7ssp0Xo5T7DZ0N1m/JxV/661qs5+2ow0xDZ2PJf+BhCR/rXHvEwIplQ+Z1pk1AIMcQRvrHdO8gJKPc67wCY8mdz9J2V5IqeSOYwtJencG31PTFP8k5XZKR7wH1CWKQX8qv08ntRvKUpuKyOe0uKoo01svFF3/oohaBzNda0AHZOT+ZcyKRcRHNzloIlh70iQjB7VN4UhKOhwLQ8z8JgYZeBcRgbae1oVPrsEK6sSGnDoP0PJf4viTTY86MoTqJeIj7CiNR7a+dAfwcBl+ujlatsM30d7fWQmVZ84rC/L8A6tubx5qe14StYbeZp93aWSvIZKXOXd11hI/jmg7a00pPArknUIgiGafDTpIpBJruh/ucBkbwxHZP2Ab6X/TiUrvvYD7Lor5cotoCyijEoNS5tvnQaLkS8LOc+q0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261021121427099003)(261022075727099003)(261021123027099003)(261009223027099003)(261022105027099003)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(56012099006)(261026140227099003)(6133799003)(18002099003)(22082099003)(261026121527099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y0kp4wuRf0mp/wiWX4KWS2ZDIKd/YfPnHN/sWXXoFhem++FiXXVoPQi9n54f?=
 =?us-ascii?Q?e4uJFbPnUERxo/euDD5T+9D/MekVRQyN65OKBd1m4OaASnWHnfmVqX1p4GT3?=
 =?us-ascii?Q?7MJIi0LhD3TJ6IqVJfzwRbXB2wGLwn2ekJWLppMuE89MSx1z8MjbPu/NaBc+?=
 =?us-ascii?Q?EbCb/P7n+QEukUkjdLIvtCZzyf+cDAcaYiCHv35LadcUEz8nfbCuOJdFRa4s?=
 =?us-ascii?Q?DNnVqNKTdZNGVcTRP6K5OXkDS/4QVpw52Xb1hovXdkcpiGW2Z7BH22peTgNo?=
 =?us-ascii?Q?6ndUhti+gdoEwzvz6/E1u5b0R1uwi4k9nH7JpZrTTfqYp5hYjbZwcRXlJhBI?=
 =?us-ascii?Q?OHqrtBU6F9Tl87aeQammwW9pTQc2nDcK4pahVRbkvVNvPgNdORdJW1n+EUTQ?=
 =?us-ascii?Q?JiMKcWUhljWTOyB9+yMA9tUQBxENPEI4zywwGJ05Lx58th0q+m/4MNB6Lf1q?=
 =?us-ascii?Q?Kz+ORPKBNBhekGxuS8NMjh8jzhUYk0T5yx0YFmfqLvUyRrxBQbjlr82ghArf?=
 =?us-ascii?Q?IBpxRzI8GNRta/Xq0QzpIu5EMIKNG335RhUykVqbm5t0Cf3VxzjdizhPba9/?=
 =?us-ascii?Q?Cv2KXt6Ob9c4NQV6lc1215TKtxjGxXEMemgEFlgnZW7AygAKc0cNXIuxrBP2?=
 =?us-ascii?Q?LE/Pk7x1bZGC4B8mMP1xJ4FMUvV8n1CfIxWgO/JBWTZSVm/n8wUrMMTs86pp?=
 =?us-ascii?Q?qQd3zT7M5FfuTkY5H3EaFDiSJhyLuOzW1d06Zt4pP92WmWLbOSWRW6I0F6+K?=
 =?us-ascii?Q?pD2jeYgLNb74AKkwmqgGel+JT9ChtarbOLTC3L1zQ7gcpObXthUYjf9RvkgS?=
 =?us-ascii?Q?LWQsEL1ydt/yjT2RTq2cEoNWh1I4GAPyz0gGY+GKLT7uXzTZqNBMZBlO7Cf8?=
 =?us-ascii?Q?vYPaYMOipRWmTHGpZT+LAv4IrEFNeDcF0m+KhzEDbdGH1hxIkMgKny5n1c5z?=
 =?us-ascii?Q?iPo9hlaDs2AjIluUPgW7QdTZ4fPGGJl/iDC4u6f5MbLFFptjVs22EBhjPGio?=
 =?us-ascii?Q?bQRbYqKuRKEQt/15oLlRdmPRTBY8WFD1Q6WQxmLC1pRf1PbskbuWEuJUuEMl?=
 =?us-ascii?Q?BZ3gPZJN6uHTpV6iVKeVyrYU8p8W6S4Yhxt1ZNG6QCyuiBTMN8X+lfU5o/vF?=
 =?us-ascii?Q?SafnjwyGGM4IhoMU+U3rrOH1Y9qPbKUEydMBcKuJ7J7lVDh7RNK6ndeYGlBN?=
 =?us-ascii?Q?se2NS7KGtcET3B9lN84EeD2LOS2V/eEIpb1U3PnpApq3kF6mEIdJAL2YfjHH?=
 =?us-ascii?Q?I+WLhzYJa0qVhgdrIOzqDPF7tC8guPkZ62uH4bXEJqyP12t5JMs5B1RIKcGE?=
 =?us-ascii?Q?m4ZiNSY3GiiwQNoiUaqHa9gDzNI7oXfrP160D3pdvJekVIyEe+yYlJR7qqHn?=
 =?us-ascii?Q?H4GW/5zSw4ff10eBaTzzGYP2CEnXAyWxTmc6mauuHro4+fgzNGmVa1LKK2LO?=
 =?us-ascii?Q?yMBMtevrGwLculq5+jx1TJRAtPL7+X6flBvb8ZkKwkmfkhpFyF9PssfwL62x?=
 =?us-ascii?Q?bvIuDdJg/50hVm3ZnJNbkTycMd2wSLpq8fZ3T7gDnJ4ms627HFLSjJmi3U3/?=
 =?us-ascii?Q?XWbPRGBRhfeZLPZesEWhXjKj3rRA8CPusssdoxLayiSwShJ4VWMeV/vGyxwK?=
 =?us-ascii?Q?zugYUL2E970GJ6u0tEO7z4v0O6ljubheDKAmm4PCIeCPab01lNmH0lSIg0jR?=
 =?us-ascii?Q?nzjB3gN2BcNkOFgvw9Ai0yOhyA3tCzBgnCeTkhvR3iKZgXaxAIkwbpSvWet/?=
 =?us-ascii?Q?X+NUWt7e7w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e51382-270f-4ff2-c70c-08df34806902
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 23:17:03.3005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4gwAM1GlDo+k+2YoDFKXjQjUM7DoOuxmAzaG4HmamAEEZQ+vr+MTHzek1dAiNte4DUzZlZyoYdCMxkiGoqL3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208
X-Rspam-User: 
X-Rspamd-Queue-Id: B2CE1A0009
X-Stat-Signature: qoypi9ym9won4uj779j38o8kcxaue4u6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793143026-279372
X-HE-Meta: U2FsdGVkX19z2zc3HYJKW5vPjOfYOE/XRxtJHxWEotTZ37d1Ijr2qemHvH8qm+t3+oqEHw5OlcL6UdLknLzucewXyS2GEnK4P8s8jGhsIRF1wqo2+XmRB04hEl5vJ6nTrPxy1zSBzGxV1r/v7ckQej9kbcAg//wf5/Cg4zfge3WEGYNZfBEmEuTQsEGwCYRW7fa02y432F2yjqHVQhqpPEA0oTpLy06739TYzl/ozpKYmaaSJ/DPg2W72/q0dMeh88sHBjAvch2NRUngp8UMtcSd9tiJiDasRCRCtUJ8CnoEo1/zsvHCtVwM5M3Ws0Mw8gmk0xlaQWmGyETrsuoWMlERNkxYPvfmuZ27sVLS5Aefhg21KkS5efOzwzFs1arLTROmoceFKmCXWz/Mjr0OafyRP1xYOV1/B6Q67WSXHbD5jdhIO04XT+tBSw4bt3MWk6cYYappu3v9RNpQ6gNPUms7ovChScLk0x2pA/bghT1dIxjt4ZCu3YQvTD/1uNSRvS445AUO7dGHTabLUCYX7E0CainylmWnOPRFQIgpU4umDc6N/OYFzVgLnwkeQ2sCy4Bt0t7ypiVFiRPrF0iSRb7khXAV+r5lcY9jWK7j/mmqL6FxTd+irnkd7A9ZIqezLRcwEAvUJ/O9ANJo0Og3HiaSmBwvNq9y0KaLyDSEjEyTDYOIz44JFmvw6xjiSaSvLGlvRG0mRcGdVyh9FnOvatOJti3SyMFqLnTLPFNJZWml56LPIqlFADFzgS30nkGGaJ8hzet9aZWx/e1qUIFF2fG8iFPJOANt4/f4fkInrbuPELcCa57YGHcFK3W1wcykCoHulFfv4OL6q4tmioMn8qMT2kWgj1t1BnTiPFe6Df35QUb40GG7QxBSBkXTUNuozPrJ0jJqi5GyTqiBXL7z8PF/yt/ou/7f8NHjAFe3PXiGYt7sXz0D9y5coYIAAWSxYL876aSA0gat5bOCLRJ
 gRdHniuT
 Z10QP+OXJSkgIF3FQUU7xHFc8pSYoyKKH8B2160paXwDJagNlJHZHPLHssqWyg7pH8LUgU2AGI82FZ+2fdjOVRNiPrw+j8MC9uudi2v7Jr+vjHNtcKMYTPO8wG6Z5QxbDIwSwGefLbBb1Sy71f2DgBKVY6tdNRjs1MWJpsWVZHOPQQqYONaq/6WLyFUfeT4KA53rPJzX3wg5WZ7Pt9QPmP73lzBGIMCAofD+88eS6q5C5iBegCJv1Cb/JJC6lJt6Fmr63xM3xCJOgSlheZgEYiBj3u/Orj/J0aUkeCHa7jyoL/VocnY3edKJ9n+fcGqCNPKLksttY3uzzu+NaSitAlIX2eSXkfc3kbvCZF4RbCr+mDlLQBkCR2F09q27FubO1AVAlv9On6P9Rcln8OYmOX2hCalWKBqXThHthHk9c6fU0Tw37l3vuqT1qUbpdkjJJK8ZFAqiALuI95ZE07alINQK5ju6O1EGHO6fV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 04:09:23PM -0400, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> mm->owner is written with WRITE_ONCE() when ownership moves to another
> task, but mm_update_next_owner() reads it with a plain load.  The race
> is expected, so read it with READ_ONCE() to match the writer.
> 
>   [   14.915975] BUG: KCSAN: data-race in mm_update_next_owner / try_to_set_owner
> 
>   [   14.916154] write (marked) to 0xff11000004471b80 of 8 bytes by task 71 on cpu 0:
>   [   14.916204]  try_to_set_owner+0x100/0x140
>   [   14.916302]  mm_update_next_owner+0x177/0x300
>   ...
> 
>   [   14.917246] read to 0xff11000004471b80 of 8 bytes by task 75 on cpu 1:
>   [   14.917293]  mm_update_next_owner+0x2a/0x300
>   [   14.917396]  do_exit+0x575/0x18b0
>   ...
> 
>   [   14.923906] value changed: 0xff1100002ec04180 -> 0xff1100002ed3a0c0
> 
> Found with KCSAN while fuzzing under a deterministic hypervisor that's
> currently under development.
> 
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
>  kernel/exit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index d5e7bc2af804..cc78596db74d 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -494,7 +494,7 @@ void mm_update_next_owner(struct mm_struct *mm)
>  	 * If the exiting or execing task is not the owner, it's
>  	 * someone else's problem.
>  	 */
> -	if (mm->owner != p)
> +	if (READ_ONCE(mm->owner) != p)
>  		return;
>  	/*
>  	 * The current owner is exiting/execing and there are no other
>

Acked-by: Balbir Singh <balbirs@nvidia.com>

Balbir

