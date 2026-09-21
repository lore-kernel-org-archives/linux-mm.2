Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D11C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004C46B00DD; Mon, 21 Sep 2026 05:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8BF6B00DF; Mon, 21 Sep 2026 05:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6406B00E2; Mon, 21 Sep 2026 05:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABCEF6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:42:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D5DDA05CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:42:59 +0000 (UTC)
X-FDA: 85237280478.01.8A1FD80
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011019.outbound.protection.outlook.com [52.101.57.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6388514000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:42:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MpPB4moF;
	spf=pass (imf23.hostedemail.com: domain of icheng@nvidia.com designates 52.101.57.19 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789983776;
	b=YQkCdxCOvreBnB/ZO1b1+ln4q80zwIdAea9HvdDiDSZbATnnADKzAb61j7lht9c+5PEU4I
	R61X9f8m2ECqrks/asEU7tdHA3n15VxGn7bOGCcLnBF4Y5IhMM24xcC76Ddh7yV+tEbSu2
	87vyIv7OWnVXTYG3jN7NtEHd7hjnYsY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MpPB4moF;
	spf=pass (imf23.hostedemail.com: domain of icheng@nvidia.com designates 52.101.57.19 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aJ2YjiW4T/1Hk072IaU73NsGnOPbUPytaz6OeYSdfr8=;
	b=J6Y2XoV9m7SL0lBiyB0yz690pBR9kXS45B4jX6PZjgCQASJ/UvwpabOiTF6j/H4YN7qBuv
	tvtocu0IV53onXn+wmpAfRfNeZZYt0edUbiQrx2gbRB6IpxJtsgh6mxgJIdDGGhuA0YVZS
	U9Dbe3zq0M7/eHgsyR7agj8zNZ05vwc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIZsGOs6NUtwNEMsK351rJ4hNY2ThNgCo/xANI09gIBkjO/L0+GnAefro/lW1dYJoPecsC004cTguUZpp6/KyTNFfomlGCOxfKFf/NBf6kWMFfORaHJYvXz2F6N3SsCKUv/XpGjSWhWQBghgyZobk9seTOkTE73NESRoqeWAXI/rIvCTPOsCmsvPeavAyhLq4meaYDORUbo355ckRqdrStrrvzFOdUyrNcwwXadX4n8HvGONQuZ5t/l98S2M1PHXTcf7CVH0YjgsLTQN2PLwpHwzdBrU4qj0OvxDX7t/rzunvQHIQww4b0bAsIjjYd+fYtmIoHc2sSabJrSlGqRJHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJ2YjiW4T/1Hk072IaU73NsGnOPbUPytaz6OeYSdfr8=;
 b=vixeCsYETP2lK+gYWRxQ9GqDGeQQDtJcCyPtFf7z4PDmIfdtQvbL38PyjfEzwTdAUUV5UOCH3BiWizIbVSEiadBM2GixXs6PCGZ6PjJxZBoj21BYVplPd8TxTN9Iiodj49K2h0Fi1psFbd6M5VY+O986xEdrX6jg61GMqZumx9f4yfBmo/w3RCZ0Gfyz46Kp3EjDrO4CGgq6jzXQPwaxRKP+3BkwD6vgS1GYIxpoklwcUBdfHZfKSN6UaClqu5wD6loGZa9gChLM7WGW8pVXIqt6QrqpaKBuBA0+iZLJlQ4UyL6zAjgaDPCqN600AqQebwN2gVLMR4q4WewCqlM5EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJ2YjiW4T/1Hk072IaU73NsGnOPbUPytaz6OeYSdfr8=;
 b=MpPB4moFc8dI9NJlSYVsEonZDmO0PEOHThJQDJqbgKZdxeet0nFOzBXQ2XZvAYxFhn633EhQ+kkWgnvPBUfa9bUqXffcC4dtIXYyoZXD7Fx92MQl1qWir5RFUtTRZRR+OKlM5I4sJmNGrOMf3hIeEycSHiXxltEshqGKbc12uYIdej2MntNVmZ7Nw1RXKMRNCfcU2OoraiokjSXvwufo2NbxLRy5g61Fl/gBLRwoKj4ydYhHs84/La9mGIeBm0Eo9ZVp9frAp/OBLHB16mCyEjvYRYQkBdCjJUOIKgK9giDLzDIOWwcn57NSO6dooQh73ztIz+rGbPTUgPCMZEFLog==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 09:42:53 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 09:42:53 +0000
From: Richard Cheng <icheng@nvidia.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	kobak@nvidia.com,
	kaihengf@nvidia.com,
	newtonl@nvidia.com,
	kristinc@nvidia.com,
	Richard Cheng <icheng@nvidia.com>
Subject: [RFC PATCH 0/2] Fix gup_test long-term pin ownership
Date: Mon, 21 Sep 2026 17:42:41 +0800
Message-ID: <20260921094243.64698-1-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0013.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::18) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d695e75-fa5a-4c7f-6e72-08df17c4b4d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|56012099006|11063799006|6133799003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bLqpOGZPFwIT11+9c+eQWiAgtKCKGc5x3qGti/AMQDwyVciR4k3g3vw6HVHVGSBUtEAf2YsShScBFLsz4qt0IsqTUmRY8uCBh/gXAPawDsqIw8PqcrTUW6blixVxectJ5GoW7Z0cChX8dsVqK7eU+C7LQBQ53nUGfPZV+tB+RRr9gyKHqkZk2jOyoKtpN0U9m9zcGQj8p8wdkxISa3jvbMVgbb11hw/UJynut+UX3Ly7c9TuFxvymObiUN4j1GEu6IK+sV0bFbZkGC3jdvHs00R0+Ijw0RBCXnHiMI502P4dIutekvXq1wdNPuEF82ogmH0VF2RP9uHk/K+ccUr1fGhJekLSo+P0p0fjEfB6J/o5HytRlAEQZ5MG8+GGM3C/ROD3NI95zo2x1ZJs+eZF7I8osTR/IRaqxkDp66rzf+TIb7pVXWSYZ7hlDzPITufDWlTMigEG392W75TYVZ0yStUp48i1nMj5JyNfo2rxdD8gxM6aSTauSTGNpAv4laGZz8R7e9CmQL+mFbUunxDsf0kZqGndZGLFDQbnRTjfyFqGb6ucE65g1EpDqnj4dOc7ZEt08I+4tla+slIJHgJENKUNcOYa4DCtz4mOSqp9CJh3B5LmRPKbd3Drum8O3vLIJWXHL3fSPqDCL7QXqIV4y8ejX0KIxSxMtFJgtbgIRvE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(56012099006)(11063799006)(6133799003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2tSBjySOhuUTOV8W+Tew1QBn1QZ8f+/Kcwa0UCez9LDIUpRiGsm6yizfLh/J?=
 =?us-ascii?Q?s08sFm0tL1msa0HTwzdUNSaf8FK7WWwK9EAsvzOiTv4tT9iLNeumgQ7fD3mn?=
 =?us-ascii?Q?3hbwtbs04uCcC06KHJHH28dQlvLNiLpPzpgJ5HArhYTR8TWaR4XtQnfdWa11?=
 =?us-ascii?Q?Vf+wTKBbzAXijtVxViXmOwvOE5+ZD9pfUAvX1fpZAjPtvEG7ufwHj8H7pP28?=
 =?us-ascii?Q?jYoPL3UTJ86Wh8DV3ou99bflActcd4o7RK5QjU3XelJMvLEFPWtS/tmw8ufM?=
 =?us-ascii?Q?HpDFPI9sNKaSz/ZPHyq6oAlB6WuzF/27shUw4XjI0qPKSmmP8w0VsskvAe6F?=
 =?us-ascii?Q?iQu8eKg8bmsvW6HrEQZ22JRWRGSdo6FsyoARijV4VFJSH8jflXWvZjK14NIv?=
 =?us-ascii?Q?QOQQbnvEg/5chgCUZ6uq48NZiwoFfWCSwXZRhlAHQ4+P6DCL0LNfbgF+nX94?=
 =?us-ascii?Q?sLfbL24A+xnAWZ+4AlXN21GY3ZC3gHLOhkPTS+Rd4OWzvDOslEPEOgkNR2rQ?=
 =?us-ascii?Q?NToo6cF1nmHzNPrJ5oPMp6sn7cBb4dzfXiMsX3WjBsERMnR0MLBOK+bwc7di?=
 =?us-ascii?Q?rwU8mkPGuGON0oMEIOfjuRZECvM8sc2f2Ua0LMMzi4aKhKBLN/q9ZOUZgkb7?=
 =?us-ascii?Q?mmNkjsQD2TB16d/IWzUjiCJRBetTXYB7gbA3RwiJvOJDRiwLkfxAHiu2m6da?=
 =?us-ascii?Q?59FocwKsuZT2CcTqorH5TDF2s4EFQ0TzB/UijY1TZE5xZJ/o/tNUb9igk6bG?=
 =?us-ascii?Q?Iz/4e67JI8UUovHnKw9at1U1RRY4uJp3sz7+qdF5j9v+VfGCY6sHsNfKHXIT?=
 =?us-ascii?Q?jrl9AmS0q718lAjosyR0uRag/9a1zdFJrl9AxZOrwERWRqmqA+Kl4V7fb60d?=
 =?us-ascii?Q?0OoFqtKznQ+PsPmWSm4QtVoTn9k/VgZAy5OGOXWBc5DXSfVYc2qb6/wvSGJw?=
 =?us-ascii?Q?x9A/hiRX8qNLP3pKiu88px2q9IYyrk1amc2/x5SEsZri5msZIyo5qEg2EEno?=
 =?us-ascii?Q?92jbTZVEjo2QP9tkwgER8zrw/UxVGcQXTTSBSzC5XN0LpDB2H2cWD/Ao6hRx?=
 =?us-ascii?Q?lRYdbUy89fpS1wRbrkTjym+rw+55UvdrQrOC+WZYFngpaEtfXy4/ZrTgXtu3?=
 =?us-ascii?Q?NcNp5FE90pR/O554lQ64KXO4ASl/bFY4CcFMf3K0+wOQETJLgDhFz1bDSsRE?=
 =?us-ascii?Q?EJrzznfZxexwPNYG5pPkFEUj/6fWl+/Pc/nh9YAkNgtTYunLi52AzYl3k1nt?=
 =?us-ascii?Q?JzAuJubpORkG2N7HuBDB/K4xjaex4lakdYZrjmJ5XxkIpfRATrUs8rLB8lEO?=
 =?us-ascii?Q?V1IvdQsM5NJQri2Kh46pR+6376PJKxN1wejiumSV+4xnWeYFwHpjhTdNmG/1?=
 =?us-ascii?Q?WV7jBqOqhEbk7QgwX1vqeVFLm+KgRQCNK0krEDkhSVdvPLcY94smXPrGIKag?=
 =?us-ascii?Q?eXuPRy5FXdTig3UDA6659KZJzZHKvF/lrvhaJvnZTekk3tVD+8vUnAXzZhMM?=
 =?us-ascii?Q?0ibf7sueGoOOeZLN4Yo7aBIy1EIn6gIvvuKLjHS2tion0SQgvjNbnC78+QLc?=
 =?us-ascii?Q?0I44wUqGF867zNKnFyVwpxo2IpyZ6m6B8Yzf2X0JVaMuMWPpKEbgO/u8XUYp?=
 =?us-ascii?Q?93k+mexRkT2OgOAtOps7e8W+2XNNyXqMDf4V78vaMYsLHnr3yOCfcIJDorFd?=
 =?us-ascii?Q?2t2I37f8HFhtaiOxxcFVuYQi40QJVGv8YeFsZR3TPnrQkg98osTVKNRqzZsd?=
 =?us-ascii?Q?K2xDriVleA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d695e75-fa5a-4c7f-6e72-08df17c4b4d8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 09:42:52.8333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgAlnIVn23IIaVhTgvtwNSWOuOzTNcY0lUV/KvHJzEMIYk9AiJveDW7zfRTw0bhObL/ttjrHPHq9D09ARt2dRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6388514000A
X-Rspam-User: 
X-Stat-Signature: 9unnz6pi83kgh1ccd87eoogowxt5ei1x
X-HE-Tag: 1789983776-976655
X-HE-Meta: U2FsdGVkX181hpqzNrz+hUFiCWca6fMsjjBq1/ywUgbp+MpfGkMhs+KFyYzT+Da4v9kWedUBfC7dsdg+ID8EX5NdZDLF+C0OVnxSRnVIHvcArH3lJwXDaBXkL7BcLRYoUKLOemDosENkCIiundAA0PA7QHNrENXIdNHuE22tbHtR0soxq8/znuLijTWhDLwtfsSwp2WKzw9gqI6zKAF2H0hrdwSj2KzPishLSnt1CB+aNgdHOQ9U5eQFbWyfcOvTFYpOVNBFfc9B2S0Mgcs4Pv8jGOR3rFLDKqNotPTUOfUYAIYzw3MjuH2xLDvEi+BXPZVnsPgLQCjLB26lMijoa2fSgnGkVYEEGYCniBo9COp/4KWs8N1KEGkqTcyH9yYzarcP24PhttGaPRGDZhu5dX0BJBWZAbr8gs/Fn+u1LT007J/OPK4XUJBv9CCim9QzJ5oz5D3CfYdwZOBCqj3Aeza0Cz7rRI7efapJzjKDJ3Mmer+tVvuFjaNMor0OTvitA4LmsodHmh+oPiFk3PgE1GZ74Fz+o3aJtNczFJu8HiYMKdYmfiIwyOKyEv/zAXeNW9Q2bC3PJXs/OOtVstNEUME6HtMTIM1w3momrI9ZMk+gNOAQb5E+RSF7C3Z++LxvrEhMeZ/Lohvf/T8TjtbxE3hUXFDkcPVQNHF6z/WVgQUHiWaEtdLuOjbRwancqfcBHtaCj1Zv/KGtyMsTDyszwR1tJXNM5C5K3WpsNSMRr35wW74oh30MycYedQXPW8ztLU96tcRFM6T3u1/C98SbMPLQGgUD6bf+/1utzzlu82Sf66KloHnAZlsTyoJluL+wJhf2k85ivreUB0Z4ZB5BfeiiE+5WMISu01NlUNBXrLqKU6+/neW9W5v2sawLHLiphxxVBZg4AZiD7/PO7tuDkVEYIo0gbA/hocOZZkmf+gJfmE0QRjLTYQ1uHZy9+k+/gg89PTY1C0GxyZ0Vcsr
 VdAHSB0u
 MY5Z5zYFdA4EdIaF2PH6JKfdo0MnN5sZJJ/AJzKgyvy6UP3jdXNcnUBJupSQhRsaBgBKwSJp5gd5TwZ3eZOf/CuAK39BboK92rANDkYy0F+iVPFcBOMVyXSUs5vBCDAnf6inVdy2iI38sVoOu1OmxBnax9PJwtsC5u3y6c0a/2RLSFEcM/ltxch2Ga1r+vqR58il8i/vBIonHxotXAkzoM3lZrCvs7RwplnKrjeyJ/xyxpO94PWkQycZ5iFLvqZqVdkkJVIwTzA6vn3jXq9xxU7zegPPB5ORMAlXHVO82n3YVoo6ezThOMUPtZ3lp/lEehxhlr7WMNmwXd7hCysSM5iQHLH9U7xLMl6OAAXeN7BPFYu7rrpBo1HfyjQYe+08Gesb09rPGlWc+m/lFCEleXwDu5X3gRQAZK69e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_test currently stores long-term pin state globally, allowing one
open file descriptor to block or release pins owned by another client.
Move this state to each open file description so independent clients
have isolated pin lifecycles.

Patch 1 moves long-term pin state from global variables to per-open
file state, preventing independent clients from affecting each other.

Patch 2 adds selftest coverage for concurrent pins and verifies that
stopping or closing one descriptor does not release another
descriptor's pin.


Richard Cheng (2):
  mm/gup_test: Track long-term pins per open file
  selftests/mm: Test per-open gup_test pin ownership

 mm/gup_test.c                             |  88 +++++---
 tools/testing/selftests/mm/gup_longterm.c | 258 +++++++++++++++++++++-
 2 files changed, 313 insertions(+), 33 deletions(-)


base-commit: 66498c75b4f8017f62d720d9b59675bdf3abce91
-- 
2.43.0


