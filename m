Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822D7FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1776B00A3; Wed, 29 Apr 2026 13:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E892E6B00A5; Wed, 29 Apr 2026 13:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78A06B00A6; Wed, 29 Apr 2026 13:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C67C56B00A3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:11:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F9F2120380
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:11:29 +0000 (UTC)
X-FDA: 84712234698.04.5AD4D2D
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021124.outbound.protection.outlook.com [52.101.62.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8CE7540019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:11:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ADESk6Wk;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf01.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.62.124 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzf4xkQBqoJB7MfypbSvNbr7G86Q/So9U+6UxcUqwH4=;
	b=z0ehKzG6RuMJHI2NlBqAXmi6N7SuTWK5K2wJ6cggGu6MuZs6fO2ccE9PSEb902MOsYhHdm
	TZ6Mp8EpXHbOyNrsbGUBFrlbSliT57AyXc33eRqfLo/K1aSw4NhgRVi2dcNLwLcIcz+PBF
	jyKgtBvOzC5E4tSQADLXb3Vb7SygrCo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482686; a=rsa-sha256;
	cv=pass;
	b=SFHYRJApTia+ufxtSaON8aPpur2FWZMAZSu/jXK2y8xm1yP4TL6fGqIK6EURXw0Qg50AHF
	sXjzYRztiZ8vUTUQtJxFk0eNPP15KKYsptFPX6M0GrUfjt4lqboD6iEazLR7Yu10xgqrAZ
	8WIwbr67H79wC448+g3Rwoi1VvPA2O8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ADESk6Wk;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf01.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.62.124 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kr3HYB6I0ED4cyUmLacU31oKmHi7QJcc2GAK2dWVnCTamx4jyoMt3qQv9Eutq78LITjWEaEz8iKKoWedQwLKtyZC4TE1wVO0xQUrZ+PvEXwz+L4m4couKDn7VpAxR7GNRK5kEXfh4MRphvhzpfDnfIljAvmqmmhS8Pmomw3IUjh6qEacNi1sgAM/UNTFyRLGE3I65GQoAzsZ8uOi9LyBZGtCi2MwqLctaXboZxReKMO/9q3p0tnQHc9qP5RE7Dhzxnf0Bu1b+ILTAexUo401rBhpMv2u56LwtPDPig5SU3Siisbj9STzS/PjZ1NnTcUwmmj4PvC/pm305AeZD7BBAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzf4xkQBqoJB7MfypbSvNbr7G86Q/So9U+6UxcUqwH4=;
 b=vSlkNinNrJnY6jMJpJm3aoRrQrMQDdQ4Wc6My4CmUgjIVZtr3QiQ0mdiqV8vOW0sdEWH4eSU2fkDjVFeZwPWvDXb7L47Oul2HzXWd52zCUiUpzKE8s+/LI4aIspm5Kbzki4bi3VcatetfNwPLj2ZsEyJGVyAhfCWq+98scrZ6MuXZtjKmUk3cwQtmKIn1yvv2Z+zHm0idUw8IrnBPTM+cALROa6LLscyccTw/NXepXR3SKuPrseCmSPB7t60SFznk6ugDO/OcDftrBWK1S2rGKS+XWx4eVNoy/gLY9PrZFl1mf3c3VPj0nKSmAFRRj47Jvigb2lunlXzaYQ+sA/xxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzf4xkQBqoJB7MfypbSvNbr7G86Q/So9U+6UxcUqwH4=;
 b=ADESk6Wk2Hu0PfBzgthd6fDYiih1X5h7H5f5WOP2ldH8zL+VW4txMO2KZisL7WxlcwvgaV3D56w4GL4oUmQga0XvjOptQEns4LDDVItSt0cjFn5JzqUOpyJsPTsCpzDXphHi7ZPthrITkR0v0cYvKWShEKEIeWMYq0hzc67sBKI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:09:00 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:09:00 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] mm: percpu: prepare to use dedicated percpu area
Date: Wed, 29 Apr 2026 10:04:32 -0700
Message-ID: <20260429170758.3018959-5-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f46388-51ac-4858-a26c-08dea61200ff
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
 DtFWfVYH5KhXnGAhHh8qUO8hotpDcU6rD6qfq3sjxYgntnvOz3FnjqPvJzpFsntwKXzVG3yBwqpLXwJmbSugasVuKd09lCrlB80t1wexAadBqSGg4Cz3EcY9lMrZfMkQ9Ail21r5hanUlaS8x0yYlxQBdsVuFEQMv+Rcgwt6TqVTqdK9uxHUuEbDX3gzxYENoWiL8x1y64ljy3l3Ut62H01piEctwzCXD5boANci+BDdy9AowCCzYCdEmYaYcIH6TMTJ1j5NGoBtu+f1te9YK0FNcbKBVvGD5Qgk+2iOuYB3Yu0pqxJTe4Udy9XagOJrOFLHLVBGZZfjM0rHb/NqAFkDxW1v21mDaxm9SxAyrPg2JioOPQmqgRr/rz71YlLf0XtViXx0TNr8eWfd5Dov5ovQjmkdI/YMd/RMzE4F3LM6/6kWZUwY3pGkqeKqOsfPV8cQHGlMdxlrX5qw+r1VMTOroVfAjCAIY3hXPBqmBezSs4hmveUp6kZV226UzS3OczDCAxAzCbywwYyox8PFxdvDyn7kbBfNnaR0sfkFdpPRIFH+3a9icvTTb2JkE6W5eXbgo+6y4AH+7Iod7I/cxkakrgi+SrvnLhwRl+y9Pkc5CHDupyPi6JSuStvpEZq/h56A3HMn0uPsRQdKwez7aHo6QBwOuazsRgEUo2lfoSSyoJ2J2CrRr9nDm11Tw7L/yM0Je/fZxuAiNO50d3riXk70Rp19r9x92sUtPq2LBRCCwH12zIGLSHxa1HmLgAeoljQ43mfBtsiLkZ/+EkaDGg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ICCb7TNNxsUQGTgOHZSG/Ugyuf2DMji0U0RJLgAQ3TwPA8AvzXUimLxWFC7M?=
 =?us-ascii?Q?yhZ9lGDMbO4ptzTpU+jQsXzfTYimWQ3tZUQRRahL2Pwtb+Tyq7AxaOl4hIo8?=
 =?us-ascii?Q?hN3BwzJW8cQoLKTG7r5FcyUFMWhCk0scj6to9GMvKQ1Shi2571fTen0gp5KQ?=
 =?us-ascii?Q?4UT2wAibJxaoNe+vKJZmB+Bplv6wWKlOM+0Qru4QIS2Fq3IEhTPWiDpITDij?=
 =?us-ascii?Q?ycEPyD4eyEUzwSjkzk9KEVJFYzvk+/70Y1PX3LNaQDMcVY7vqHtZYp/eD9D9?=
 =?us-ascii?Q?gEhzFGwcE9lcHJR4vsc/FblClQ8YWqf7hW1fm/Jonk771xkdjQqMOTn/IhpT?=
 =?us-ascii?Q?nJd20ud2MpfSbKLp7mZWwn13Yn0Glk4jUZ2H5/1Tazm5oM9aroVJHE8FK79w?=
 =?us-ascii?Q?4FEbtkyaW+IPl0QPGewQpveVhKqMByQkgmU8L1nrmHCvqanTIU2RZBIOnY5x?=
 =?us-ascii?Q?GLW5HjI8SOv0/f25FPMfUAWUYUxkeR2AACPU8GUSmE28i0Gux7ctoiAP/jcd?=
 =?us-ascii?Q?TYdWzsSUt+YK8gBcxos274CZ2ZhKFi3thPkem9+ktnJUsMCmiGUg4NpR46t4?=
 =?us-ascii?Q?bbBKPNRa+BDSIiw9zCkJo84lCde+D+2zQitJhMvncMXe0mdGpcHMZJaxl+yS?=
 =?us-ascii?Q?3G5sJl4/t5VYWgVf9JfI+eRVCOCdJhcrik8c8QIPjdQrubIC5ePXPLbRHOeC?=
 =?us-ascii?Q?Jnl1E8dLGLe4GdXw87LjCI+FPHDykiv10E1BGyjO8AG2oZ1qMrL2fnssml+t?=
 =?us-ascii?Q?RT77ku1oIOeqS+bi5kFyZlfEuM7CcyYoI6Sy7dxZGFK147aR64qtvjY05qRa?=
 =?us-ascii?Q?//n3td6aNLWW9D2B6aUTXfTqrRh6KSGTFpiKir81Y6tRRyX2nn0xH5z8Ln1a?=
 =?us-ascii?Q?Ylx4AWbkpewCRmeP+tCPGDpJY9e67eC7UYx/fnBVN6E+jM9/EEZmBhG3HKiZ?=
 =?us-ascii?Q?xJ24bynSl7thtFp5pnr8nKcEASIxfZxfJLYgkOPLizY9IyxWnIOdLq7BFSIX?=
 =?us-ascii?Q?Peku+d8CHmVO1NIJHIxnMlPRs8MKEmz4unTay0Ut/MTNWeBGIPE7WBbHxSOx?=
 =?us-ascii?Q?eaxPkNvUGaZSditRkvG6LkHVJ2e66dq28R+Gzg1u3r45huumhgSJUE/P4+lE?=
 =?us-ascii?Q?qp3mB6kNk0plubyfds3mah1TVtuTXB2hF+t62azrtb7w5VPT8EJNn0pG7GiL?=
 =?us-ascii?Q?spiC52a2wiMJKqqgFKgfHynRdT1HP+Qv9phUOWoATt3jbkpH3S/d7Bktp/7H?=
 =?us-ascii?Q?3V0B+Cs7MjV7lCBrKRDAzAtWBPnXaz8Jes4nZGus5pLsvJ8ATU8fM63Jw67l?=
 =?us-ascii?Q?Tv8bzjDKlBLYoMttvnNoBkbtYvY9l5Kn5RS3LA3cqemJlc8Al8W1URX8p8kF?=
 =?us-ascii?Q?bQ4XEuPzboOzbsZDCwEe34nf11DLzAUlC4+eb21Wn/Sj/k2lEpmY0NCcsMKI?=
 =?us-ascii?Q?oCDD8mU3ooJNq25KDzM11Yxpixe9/QrBgoA6Dmw5VpRsNsueAPUs6k77srcw?=
 =?us-ascii?Q?fjemnXJ7+IMhNeubWTgzLuCqhySqbBCejpp1+7jZq1CcGtgxmyi/fNIMwY4c?=
 =?us-ascii?Q?wCwHmQ3UqgoiMchATar0ucIIQn033h+ZG9UsWRWHxtYHw4K3KdDLCepT5GR+?=
 =?us-ascii?Q?uNkqaeofoZXhgxm0PjTPoK8OSEx1AwHPH48Cs3o2w7PX6r2+HJmIuQPXV8qC?=
 =?us-ascii?Q?JIwyE9SPqFGBvzlU/wjcT+N8AhJnDz1QPNlHeFZAcImChJjAkf+Rl13elVUB?=
 =?us-ascii?Q?HLvXY5fHoFIVO6DSa2UEcBor3aK85S0=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f46388-51ac-4858-a26c-08dea61200ff
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:08:59.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDZvS75XiO0j0JqsNVJ6xgRmMzJoDC2mBP2naU1gbT1gwQR/EdHPUw+rBln7dMDV6JSjDCudm2FhJEmq7VYJia8Tvmaabb/a5fi7MgdDQqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CE7540019
X-Stat-Signature: djaqhxzaamhtxyhjpc67fss93xzhd3kf
X-Rspam-User: 
X-HE-Tag: 1777482686-605334
X-HE-Meta: U2FsdGVkX1/s3JQe1bNqmxeu1we1NOlRn4vAWUBIEGzCZQ98iehXC5qYEVBQ+Qm8nsahhBdmQeyeuJ9nbnvyO2o1ZvWr2BTvPfidT56Wi2zq9DXQeLxZRKDb/Y4YYi6hy+fvYDhsiqjFYUX9BuGJlov9xFXOHZYtX3oSMjUkp68v3jRkibZTHcTrqawjd443AtPhREB0xwNQfIyROtX1POgDGT9kBs1Gxt9GP1zsHfRjZArvN5wzi1f0p1ABKlUKdB10WtTEHWYemcYm51lD09cFhB+qnbY0TP6GN1UsvDP7pbwm9A2tyOLM5myqY5qnvD4snrnd08TfOP3RoV+TXAxB40z3A5NghbUVM7hZKZ5qu5cLnun5ryJ3nLsL5bhtIWbs8eFhiD62lOXFpRiw9kPYzvDJ1YtKJIpLK5RL1SPvUZdGEMnViOpgWNOiF9e4/ZcrUeywx9t4zp2dnwclaozioUO+tEoGZhuQGNpCcOUIR8ZvnWfQemQsMDB5ruv7RM3j2yxwHxo+PNIC4tmMRTh+HymkjWRViNCh4C1//JXuilsrfrSW3jpHXIGu/fGhGUiRGmkdEkuIldnrzSew3rb6+064T4Hi0f3RJqEUNzwYgOrCrpO29/q32KHDUpM3FsDgHeVVKrjWUtLyf2UIqc7wPOiIAFCOa+MuDuXb1yVxEd/ldw/pHbNaulpu5nvm/SnFgzGvuBeaNJP4r1ywg1x5rB3hx0O2c6tNRqqTEDrZlhU44xP1YRcRGWEFo6xtJJLifEmqBijCePMYplcObMIRhaWAdoDTzYYsbbgvZCMwE0fWbKBKNJQ60UXTxTXjaFN+0a0kjOIrsq7eJN5RkhrI87cZYL3mV7G5xbrL7LyYXtpmAVdDBO9a/Ky5bGpQWKKu9I2Ko7tH5LZF0mycvlV9vjpf71CYo8lmOteTladXBo1CYdFGBsXkD1NadSgLyoydLVlfL4vcwpOMIRe
 A2lMIfgv
 JXaV8FpejzVlV34iJsAq5vY/Qob4QikoDmLrtzqdubwO8Gv60rR4E9maXGfkYcx5297vD2Y5RswyscVued94LoCbIy6xqEFm7MlrW3an/6NKgoDAlBQRSG0ABreApQI7pC6a5VXSsKJYD0kiKcVMOiTJFvFMk6CsnFINsvYLIgQIOfaKBW3oAc073i8+0VCKWArPxBQRIORnDxgGIg0yVItxvzVSja672vm7WUdpY4RNK4vnD5nUAYDPQBMgbdNavarBa8l2GQwCRDzIZSNq0JbFnyJNoKpZbMxMHY4BSJkMp/8UJ750fkPicUgaYpCnuQu6CoGdh7iVPS0Xdm2SxLsqBenSxRL8sSgssFN0ySlWqrOG3Qmn692i2ZCjde2uxw/iRbtxP+u0IY/QMsVWW+8NyP6UGSJa4yBaG+mSTb84aeTAQge7EgKbyBxLeDh5q1Zksse5tMK8zJqRzXlBdiqEvzCBKvp/TJIyLeEK2bXPb6oiY4oLugJBOAXZRK6izdMBp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The percpu variables are allocated from vmalloc area by default.  The
architectures which support local percpu map will allocate percpu
variables from dedicated percpu area, for example, ARM64.

Introduce a new kernel config, CONFIG_HAVE_LOCAL_PER_CPU_MAP.  The
architectures which support local percpu map will need to select it.  If
it is enabled, allocate percpu variables from the dedicated percpu area.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 mm/Kconfig   |  3 +++
 mm/percpu.c  |  6 ++++++
 mm/vmalloc.c | 20 +++++++++++++++++---
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..ccdf58b63fb8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1022,6 +1022,9 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config USE_PERCPU_NUMA_NODE_ID
 	bool
 
+config HAVE_LOCAL_PER_CPU_MAP
+	bool
+
 config HAVE_SETUP_PER_CPU_AREA
 	bool
 
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..daa2c88e6971 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3243,9 +3243,15 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 	}
 
 	/* allocate vm area, map the pages and copy static data */
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	vm.addr = (void *)ALIGN(PERCPU_START, PAGE_SIZE);
+	vm.size = num_possible_cpus() * ai->unit_size;
+	vm_area_add_early(&vm);
+#else
 	vm.flags = VM_ALLOC;
 	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
+#endif
 
 	for (unit = 0; unit < num_possible_cpus(); unit++) {
 		unsigned long unit_addr =
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aa08651ec0df..068a6709062d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4841,9 +4841,15 @@ pvm_find_va_enclose_addr(unsigned long addr)
 static unsigned long
 pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
 {
-	unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	unsigned long vmalloc_end;
 	unsigned long addr;
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	vmalloc_end = PERCPU_END & ~(align - 1);
+#else
+	vmalloc_end = VMALLOC_END & ~(align - 1);
+#endif
+
 	if (likely(*va)) {
 		list_for_each_entry_from_reverse((*va),
 				&free_vmap_area_list, list) {
@@ -4884,14 +4890,22 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
 				     size_t align)
 {
-	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	unsigned long vmalloc_start;
+	unsigned long vmalloc_end;
 	struct vmap_area **vas, *va;
 	struct vm_struct **vms;
 	int area, area2, last_area, term_area;
 	unsigned long base, start, size, end, last_end, orig_start, orig_end;
 	bool purged = false;
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	vmalloc_start = ALIGN(PERCPU_START, align);
+	vmalloc_end = PERCPU_END & ~(align - 1);
+#else
+	vmalloc_start = ALIGN(VMALLOC_START, align);
+	vmalloc_end = VMALLOC_END & ~(align - 1);
+#endif
+
 	/* verify parameters and allocate data structures */
 	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
 	for (last_area = 0, area = 0; area < nr_vms; area++) {
-- 
2.47.0


