Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BBACD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160016B0088; Thu,  7 May 2026 07:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111216B008A; Thu,  7 May 2026 07:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B5C6B008C; Thu,  7 May 2026 07:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDB8F6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:43:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 666D01C0F11
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:43:12 +0000 (UTC)
X-FDA: 84740437824.01.A80E706
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010029.outbound.protection.outlook.com [52.101.69.29])
	by imf07.hostedemail.com (Postfix) with ESMTP id A2E4040005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:43:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mXzTaFaG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mXzTaFaG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.29 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778154188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfXWfESgLK8Z15evNQYqARn6CW2kf1ZFmevTGKKeBoc=;
	b=5PR3b8EOMiCvXXvjMJG1MnTxowDV3OOPjFTOqqPXCLaH6C9/UAo3jHSQ7BzEhjwMgE/wjR
	Rnw2KADMuczKSi8sK9/79NC+cScI+q1oU95lLAc8Fd1TPVluoIixMT6a6KrkSgAxKawX/l
	m3mljkyqBtbN/u9jxDFByB9/PRvjMfY=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778154188; a=rsa-sha256;
	cv=pass;
	b=5ayOavW6a06j4OdE2Ikk/R4sXMKxq5Q9k7G0rwFa3T5e29X3EsuJcr51fP0YDPs1jpwUUq
	YHdSeD7s33VUrX4D0ZziOBhZqJznF822TSm2KfaE2pQ8hIAVStVru4jcGnJ79jsQTHEsmL
	tRBbdJhSAbRSknGMy9kt2jyTyMOiBD0=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mXzTaFaG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mXzTaFaG;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.29 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wszSyv7S0heDhGsg4wo+XhWs1c9bqwE4C7/rjYLf3mUXiG8IeODdVd0/LnE89bTGNbNbqMzRQWwlpXpLWZ4HKEs9WQH6bFMkELerE7V3ixB7Z5fSXSHtgUxgjXOWqf4U6ptN7DCxBXt4NcGEXCkgRNV2jjd/UHATR7Pvryfp3tbdl8ECEQopipg2UCJ/yhYPUMxPhAJ4RVbS5eknUvQarThUsCGWRXM7YcaoXsgdy/h7k7RXi86Uc+Q+AS8HcYMwclPn15E6ZycZ7/lFJFgjkIMCKXMIcogBTFzaQH7Eu0LtD2ZYgEfT1GzHDZxKKQhr6z6mHoajFcH0RJAzkAIdow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfXWfESgLK8Z15evNQYqARn6CW2kf1ZFmevTGKKeBoc=;
 b=wmeparRROHKlzwurQNdlLkZlwXf15UsnII1BAtKGhu08XUsruDuFhxP08a2f+6pyYsyC+EuYrCu09JkY/zMsyhkDhnSoJInC5rEG2zZP8JQKcnaccllFgwud/U5rXK0CnfACx4zQ0qrWuBFy3XKhYc7b4rlJ1f5HHgu1VaBMiOCU7UlPbqm40lLveaiTqtduDNyF0PtSZRT0yoYlV/6LzQ4rXk1OwBByxzviy9p4TXOD/VqmmkHTc5hdfclSb7GbGhMVje9kQAJlDeL+5ubNbn1i2A2CfbdOWYwJuTQPyZBJJSE3J1b/mcmFmUj/QXB5eajOzncySQ4Z0CzddhlhFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfXWfESgLK8Z15evNQYqARn6CW2kf1ZFmevTGKKeBoc=;
 b=mXzTaFaGYUC7D4E6Pkbbhfj0x23P9TSCobJteEEp/WyFMjwPFT0i/C0VwDWxosgQIYncy3Iu+aAGmipExKOZacfxXiE6ZuE6/WY2n/JJDCpo4e+9ovpMUKT8XjwvLFT9XruMr5YAdvqKsURWVYMW+PoWGyV+sXOEpDNyTV3SSDQ=
Received: from CWLP123CA0234.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19f::9)
 by DU0PR08MB9300.eurprd08.prod.outlook.com (2603:10a6:10:41f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 11:42:58 +0000
Received: from AM4PEPF00027A6B.eurprd04.prod.outlook.com
 (2603:10a6:400:19f:cafe::40) by CWLP123CA0234.outlook.office365.com
 (2603:10a6:400:19f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 11:42:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6B.mail.protection.outlook.com (10.167.16.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 11:42:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tokPvvzatIUBpAoXKHVYdWKctF70F1lgk5PJ+6tjtTAS7uvfSxiayK8pguw/AVwBECGvbC6jB3ySO48CDUuZ3zF9K9FSOhV/R+20LmOH3iAQj3lX7qaRjrxmxoRUMlmNU7Aq5RPIKRFSro8Dp90phL1/BgfZi4Kzg4HSsGAZvjbxihX9ZnC5gnLgQNEh2KF+ITpEw1LbdH0B7RA8vMtkyHPHEerV7IMs+y2AWOIS3CAHEF5div2CF+ujznVD7tjvJICjulayWV3mO/SIUMskanlNbR8yJ1aOYgB2NCxUZ5Fgnyi/m44k5yFiFYohmt0B2cJbQrISQs5BJirlzZ+rEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfXWfESgLK8Z15evNQYqARn6CW2kf1ZFmevTGKKeBoc=;
 b=SvBo6cRG4qOkv449fsrJjem8Zd3LZlv+VpcXj8LSFlMu7LP2Rnx0g+dBb/Wx1afdMA3cKlJntkdAi7RjwwkO7oC4Q/fYHH3mMtlyCdeIm5ITZxWj/fdP2TSYvuqSG+7uP+mWmZAagHiiOnnaRzlQjEZNl156i3CKgoFFJv1HwvFB5fJJt23Xk6Rv08XT+zTkWzh1YWklYrTxEat0PTGQHPYeSJzNx7sKpvPUOKFxVYp2jGQTuekKnLhLo+S7pz7UGG3caPF1UQ2nxojem+64GRG/h1DMLpX2qrpqdxi0zJ1JEIzdhbIEb6QsFGikj3hvh9vyE6iMSUaEx07MLNuBYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfXWfESgLK8Z15evNQYqARn6CW2kf1ZFmevTGKKeBoc=;
 b=mXzTaFaGYUC7D4E6Pkbbhfj0x23P9TSCobJteEEp/WyFMjwPFT0i/C0VwDWxosgQIYncy3Iu+aAGmipExKOZacfxXiE6ZuE6/WY2n/JJDCpo4e+9ovpMUKT8XjwvLFT9XruMr5YAdvqKsURWVYMW+PoWGyV+sXOEpDNyTV3SSDQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PR3PR08MB5724.eurprd08.prod.outlook.com (2603:10a6:102:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 11:41:52 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 11:41:52 +0000
Message-ID: <b1213e99-c7a7-438a-84e8-4466e43ca003@arm.com>
Date: Thu, 7 May 2026 17:11:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 45/54] selftests/mm: pagemap_ioctl: add setup of
 HugeTLB pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-46-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-46-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0091.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d4::13) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PR3PR08MB5724:EE_|AM4PEPF00027A6B:EE_|DU0PR08MB9300:EE_
X-MS-Office365-Filtering-Correlation-Id: a9fb0289-07e1-485f-8152-08deac2dc8e3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 5ofj4gxEXjZN7ThulJKBzrNv06hiZgpKoYP6LRAJBU4/JvF3UVL80vPYGx4bfLQDLOr2vz9THIM8b6o0p9gWPbADRSavK4yVgzNLAbKi1BZwS0p+8IAatS07f3ivt+zjQknrOz0Vhu1sY/EC8yKR8uSpQsp46k2nx1AVo+ooEw8prRCbopyHn5WpCcPTtd830qwLFltVbol8ktzEAaSwP90I9R8utJd9l4giJ1Hr0YnxcHWbfi1Gi7/RkiVNVCUjs8gFlKMSF8T9Zh+N0DgWGX9Dj4wlLZ4CRjNAxMFeCjcCMNNrZg+0AYafnNd4juIOVBrfK1AThjPrgqdpj5VxHTF/n0Lw4kug9d5IJv+HvqLVclWM7EOdJ2RnCml7+VwFMHMaU2PKVsX0PkbrqFwgKvSPjt+ej8xKJN3pIW2FfQVhyLVpwL7dLPzp0Z6MteXCrcQ+7trIr8NlahSKIF4+xIVIIm6VvrWzzfbHQJoJXsy2yLQOGxk5TAc1kgL9l1Vpy26ZWdvhMtS25r2dfXf9G7rfOrXYCYB9JvuztJIW8qsdvS2q/EnRq5ZcepFJffXh/cMczniQ9UUIMfrQO2a2L+4msGUVz7cP7NipRC6aahIBMILskNw7xJoVVPVQi6Gtfaq559Ky6RlQSWSrZ9jBHYHQqxa4gtfUqqMWkYLJlL3d6KgQOf2UPbacb6u/tyEp
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 BVvmkQ6AQMyvx8f4OivxY9ZcRRb2XYt/s+sTfE9a0tJqk8TZes76Og2EWqs2M1z1lyRr6OdaBojbCeRTYjmazeLLAwyWA3kPY0u2kHoHnfm334OV7khIjlSD9bo6YeAG2MnJ22oxMWEnlI6qjcAFyrPM8lOBS8Ge9KWT9H5KECUkDqYeEDb3KixrqegDNK4+b/ua36rkMcmHwH2F/Mkt3uz7l7L5ehQQz85zAHu4f9jmNyklaC3M6+nwBPqIMgImKSQit72nWEdq/in70onaZrsnYgHdeoMqqEwhJidkI3vHobPItytXiTyEkVgi62l0wSYdT8cgQr05jEsyFvqQJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	578ea456-bce1-49f6-69fb-08deac2da1db
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|35042699022|14060799003|7416014|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	WnLieDoA5RWVN5VoWa1WIsTEPF/doX+6Cw64vUr3lOrPFDXd2Jnu3nfmIFXJBFh+EBC3hB37LMORJ+bsJw+RZ77W61APEf/j3GbhOPMiz9+WkjOCF4+k5dhw+voVis/ICZN2x00IOQ4Z1zTTUfWjOfQMHup/m6tLuB0L/FstE6jhVH8lPfWXZbunB+hGIyPVN0QSPqwRD+MoPtyFoAM8yKuP1PUqTl0t05NgnhS0RY1wE1sUaAs/vakIPUJDiJlDHWjVNksMvRkUIPSHHClJzCwgLQZVv/Bw9q4rTki7NmIIAncKGIFaPPqe90TGxPQK3H1yMQHFXuo2SEf9CD7+Vkg4BIvQwbf4HTTThpe4y91gKFsD4xf2wVzTnVBpJXYz5s90i1eEmXME550ImeW3a41dhSs/MWJ4jI7qZhIj4O8xXn2xWSZ8tcQmbhiEy/PKXBRbVqjmqM5tDu8gbpZZa5uYyovdYjqzGqL7raHzX1XqXkq76wpb6d/+8De9gYhhyg+Yql03y+AJQZdFtYcNnXgjlFx4ZURWwzEaxS6nDcOsDwBvu44sY33/3SZjweuN89F0tvQhvlipjVVRPnsPgmQzSk8utp0AR9NpjonL1+3YG0CThJ8d/m4TIwhneSR9b+Nk1UFp0Rx89zkT6iqarXeO4xBMSiUfXeOJFnum14JzJ1iTGIWYc7kFbrrV688rHuQpUCNj3WzF3ikLAFUE32jxbprQ3VTRjNmR40Y1Pio=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(35042699022)(14060799003)(7416014)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/wBTGDnufF5iW3MXVR9w+MYiubAZkwAG3Gr5rS9SHoYjvPRbJrwf8oUhK1qj8YABCI50nZMjVMP2ErLbDiCkYPx6+mTqunY4Exnu57tjUUuMJ2lyE8IxVYI9SRLDsYPO7JxKdWTu3pKEKJmC0+jqstkbvEyWEXkpp6KfqPN5STudb+73vD/oiKODH/PMV/aMjQvk/a6/a4We5L8G8kqXBezciRCZUZsAFiJMwSRrCXgVp4qca2KsRqqY8WZetvhGjMVvD6/K8UjR4Am+QtBSk6NlfVu74Fk+WrHp6RKKqDnxe4r/Jm1K1Y3WImaSlADFcGs3gnBzqSq+kNi1eKaSZ6CLDoMM1deVbb11gZuS6Wdphu737JWAl9Ciyi8P2niCqxV4+xphoF9VyoZ1MEm8UfY8uBJ16wzHWLG4HPvFFnKV1JFkMgLPJD0L1fXGdGFU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 11:42:57.6022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fb0289-07e1-485f-8152-08deac2dc8e3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9300
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2E4040005
X-Stat-Signature: 5r6u573dyq4ee5mw984nmbw3fzbbg5ky
X-Rspam-User: 
X-HE-Tag: 1778154188-376815
X-HE-Meta: U2FsdGVkX1/HIH1tgC1GrJGzU1DSmCZ+J/e8uT/cyzwg6P9WOOxoS0/qBrmKhEVMpUeGtoiCt6g5Dw3Ko0aQqt+7wsgHhz7UAERtQFK46xe6oO5MVDWLyIxhhHMRsy9cAb5K4RcTJK6m0IXTlSgSE45IE1HyP5ATKTjuT+xiYewyNkwI9WgWDAL/PXztmt3DU2WGgjSVVEvSbeWNXTNpcIDkLbH2ielBATwy2nBahs9vSEJK78mZQvuboB7lbO/H+7DbjKUEdKnLDxcOepJB/eKlY60kBrIQSct2KvN1NThD7Uw5N13zuidq+Ma6q8nhonFMbNBsrifHGjPKIrjRjAYWx8dKf9p1svsIINEBPXbKpNIKROmpxPiDiFf70RHgtXlA8PZifA/ozYPArVBA4gFU0qPHkIXkUeZbWfrG+P0iMLbhY+plKV1LLwbj56TyhsTx3OMooLILQOB8a7KAlRWu02k42rhJu/rTaLLOld7cpnK1KK+30EzllduDgVv1C7CLDYfqfnmMB0ry5HbAAgr7hRChceO+jpO/FyCCpyI5ftsZ+XSBScX2sxo5tY1kDetpZPVnmj3jf/kDDY00CcaFapjV8iHnxE3b2+6Av9mEvMhmHzRcd978miVfm/HubrAj0lWXJhfPGoxgsTNftOtI+obMZtb8aKdGM4lCkXZV+nodcJO9u6c+P6PeTAHdIZ4GCT0rgpfsuCk1Jagw04Qck3I9336MidYRNSWAnpYag0pWy/JVRbvJqzoTGXP8xHUBQDqLMBJaYEO4g3NjtOsbWv9wzLG+rokDucuX/g6gw3S1M/itJY+Wx5zpZQc/CbXt7DPSOz8mXvGcpBUhWOq8pRdrXcSHOVxtlomgnU5k6XIsupHJqUN3Yw3gLem/3skMMvruQ8M8aj37oP+mHHwfs6R8cfaQNe4TaWsWx87TeneWElrko2VnSCQzHK+Fs3y3t4a7jOubUh4qpz1
 ES7pldS2
 I+WIUYFsD/QXsNjYZrqjs3qW+n6IpMIHCZ9GE8HgXVaVpYbSwQy26nLUwo8ToIXkSwHHYcvmnPsykmx/x7/4SCdqkKnuhTqKvjdb1sgZPH/dk5G8KSsRSj9vPzhuXsLrGIPuOafvkvUBsY1b8zOnolrK2KI4F1jeRrq5TVNqJdxe+kVBxCaN3cDIV8KilmA91paqaEeetYtV+WiP3tljJS0E8baPV+qvR+gBof3F1Aso3qgqIx8rM4zEmwIOVzILLTHj5Mse7Icynk5yscLW7kljrqlCU5Nf0jQsVDHcyuLPMAsasFpwUAnNfQ0aW2KFd+1KN2pURDw5fUFYs7IqhqJCOMIQzMk6PxjSqmiu4jmvQ1ogojlM0TSSyfSXstjT0Wh7uY45A9GJGqkl0hBXoe7vmqgU6ee5sLfPWyhHiv2sS8Moxzr0OYN6b3n00lvMtPeNdOYYn5e71lSHRDjoVVD/DebB0rFSK5ehOKcx+5HknmYxHElG0jo3MPLazwndYSX0+HUbtZIYyV9jJZZxpfjxXFpiRfTOuLpoU2k2xzfZcU6JOXKnRyf/c//IeJ5NFAuY5AgZLebez6TsXFlbTTuEi0zn0x7+I3HsGdJVi9dQKgWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> pagemap-ioctl skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. Before the
patch, 18 HugeTLB subtests were skipped due to no preallocated
hugepages. After the patch, those subtests correctly allocate the
required hugepages and successfully pass.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 7f9428d6062c..e2c62cb6978f 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -7,8 +7,6 @@
>  #include <sys/mman.h>
>  #include <errno.h>
>  #include <malloc.h>
> -#include "vm_util.h"
> -#include "kselftest.h"
>  #include <linux/types.h>
>  #include <linux/memfd.h>
>  #include <linux/userfaultfd.h>
> @@ -23,6 +21,10 @@
>  #include <sys/ipc.h>
>  #include <sys/shm.h>
>  
> +#include "vm_util.h"
> +#include "kselftest.h"
> +#include "hugepage_settings.h"
> +
>  #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
>  					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
>  					 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
> @@ -1554,6 +1556,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	if (init_uffd())
>  		ksft_exit_skip("Failed to initialize userfaultfd\n");
>  
> +	if (!hugetlb_setup_default(4))
> +		ksft_exit_skip("Not enough huge pages\n");
> +
>  	ksft_set_plan(117);
>  
>  	page_size = getpagesize();
> @@ -1605,7 +1610,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	}
>  
>  	/* 5. SHM Hugetlb page testing */
> -	mem_size = 2*1024*1024;
> +	mem_size = default_huge_page_size();
>  	mem = gethugetlb_mem(mem_size, &shmid);
>  	if (mem) {
>  		wp_init(mem, mem_size);
> @@ -1633,7 +1638,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	}
>  
>  	/* 7. File Hugetlb testing */
> -	mem_size = 2*1024*1024;
> +	mem_size = default_huge_page_size();
>  	fd = memfd_create("uffd-test", MFD_HUGETLB | MFD_NOEXEC_SEAL);
>  	if (fd < 0)
>  		ksft_exit_fail_msg("uffd-test creation failed %d %s\n", errno, strerror(errno));


