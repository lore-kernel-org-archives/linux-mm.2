Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F11C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 04:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81BE46B020D; Wed, 27 Aug 2025 00:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC446B0246; Wed, 27 Aug 2025 00:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6465E6B0249; Wed, 27 Aug 2025 00:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5936B020D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:13:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 079401A0419
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:13:07 +0000 (UTC)
X-FDA: 83821217214.28.079C228
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A265100011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:13:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XLoG6wVt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nl2xD0H9;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756267983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6AiLpZ8dorAkEC6aHKDAINrleKq8cyOvR7fW761bVME=;
	b=AaMoQ+j6701L/ExQtAowafrUWlz9cKxT1tpBceCrfbUpAEWXvYzRePve0bURa8xcJ5WBmF
	0ROO9iuO7Ifwof7UoBL0sJZjFkxJW9LQeNrkugIGdOp/OQMEM0U0EXJgMCPbu0vsS4rG62
	nI3WHpvA3q0y8ZY9hEQpd2CSFGhCpdM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XLoG6wVt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nl2xD0H9;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756267983; a=rsa-sha256;
	cv=pass;
	b=3SlrR2rq9Y9fo983XId70nmFzNh1QNo3Iqw4UW2knWwKvinei9BIby9kFul7HVPCMmaprD
	M5J9spXof9aJQZfh2nujSCngAK5vEgExG+Tq/gMnzHSlqps6nwUEPyjvSE23i1WhjRKPLJ
	VTP448GFuqwvHMdfzYK/lG1dm07Dx/4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QLLnxL003260;
	Wed, 27 Aug 2025 04:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6AiLpZ8dorAkEC6aHK
	DAINrleKq8cyOvR7fW761bVME=; b=XLoG6wVtEnVp411aIf7WxoioTDRmwhk7Lh
	D2PLLv2isKPtUicnmyUfWYyy5MY4ZHbQF/eURV6iDA7sGvLJLKEseZYaPHLC2uSU
	jfVXqq/uvyZI6vMXrhkZRittmoWTiNoWEWxllhwzcVgD+0On3uIVxK6olpxPlJIa
	J+WkA6m6uHIMrJrcEeWVt1s9R6OIhYWVeXQ6lT+xgOvHfIVQB16fC38PxEVnR6FF
	TeUAzODjqQd/+Vtm87zPuin03cnUYiBKzTWXxYU/g4Wqi5f22XSN5h4h4HQuNczN
	bJeHTH+I8XqOb7dg+0akL6XhcmNi0nEysgw1qM5+HtHoyuI83f1Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e25t61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 04:12:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57R41Q8A005028;
	Wed, 27 Aug 2025 04:12:51 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012071.outbound.protection.outlook.com [40.93.200.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8aj5xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 04:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NeI9NNNjWHEsR4LuyoLWTck4k/ViakEt7QVf9P4zG00SxaAf5QZzQQz5d9AnLA7upzqCCFA6iXfFk6ve3vWO/guzN2NTC1CpkDNP05tgBrJEie6vpx9XeaMUvzrb6WM2Py1hQ0d25YOdKH64/bPzwUl+rfEqQ3fN66vyc3LEokfnj6bP7qodG+yr0STI+NG4TnS7WX37PX5YqeVFklQ4c+jYFZP19nbd7yZteiYJwVZ5zqkEgZXwLMt5AEybIKw45qWq4qvktO42FxLqiD/DpQ0heebAi+edUhBZgtcN6kAjx+ohTaTaOwmyU5JZxRkUxLDbOmQMURMCAqSX3OEd8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AiLpZ8dorAkEC6aHKDAINrleKq8cyOvR7fW761bVME=;
 b=LFesTl+SlE1o5uA23r0q+TwsaokVr/U9DsQfVkP8Sr6sRwMdv2AyAm8ifcT7mNKJKVPliASDTqUfk8/oOoIP2Z5VqR9gUAL6LVnuGG80byhFdFIbnDJzeyVt3guVGLQkQgT3vAJ9cVkY/4qBUAx8Sq19Nd1EzWA9nYuW65LNDoPe/e7+/LLaMzvShyTMuehJ0f88nJa1XErhd+hhVo2dOO7Jj7ku5pEEGAmXX2YgcKO4CDiHSkdijhCbMPylVLEgAmTe4qy3qe1BtPyIdhoX2Q0jU3YuUalVETtDZ1J0ObmNSwTU8B/OW+iY2oAqDs68PL2gZKAoXXfZ3Q/+4GyEBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AiLpZ8dorAkEC6aHKDAINrleKq8cyOvR7fW761bVME=;
 b=Nl2xD0H9wZnu4iAvEJx99lq3EkWz0KqyNxoLBFs75NS6tO6docVZYjWYuz0ZNcKL5VudnQWEe8RFp1jURkAjONZzrhMuXg4wkug+dXEooRdrk5wO4VV65h+EVdQVnfmhqjwZZngfZP4irPL6riE9ex/fdio532ljRpxC2PuCB2U=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB5785.namprd10.prod.outlook.com (2603:10b6:a03:3d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 04:12:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 04:12:48 +0000
Date: Wed, 27 Aug 2025 00:12:34 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        zhongjinji <zhongjinji@honor.com>, mhocko@suse.com,
        rientjes@google.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, liulu.liu@honor.com,
        feng.han@honor.com
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	zhongjinji <zhongjinji@honor.com>, mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	liulu.liu@honor.com, feng.han@honor.com
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-3-zhongjinji@honor.com>
 <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
 <nwh7gegmvoisbxlsfwslobpbqku376uxdj2z32owkbftvozt3x@4dfet73fh2yy>
 <bcabe7cb-d09c-4789-ae39-407b2e0653da@lucifer.local>
 <ip7al6pv3nm54raaptrxq3v4t7cpilqgppkezowzn2sfbjax65@qt72zuotrwnw>
 <oogiwonpxtqurkad7rt2zxc3ffgeujtilivno3ibcybzucsliw@ym7jm6r5kdil>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oogiwonpxtqurkad7rt2zxc3ffgeujtilivno3ibcybzucsliw@ym7jm6r5kdil>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0383.namprd04.prod.outlook.com
 (2603:10b6:303:81::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d6b3e0-d021-46da-b779-08dde51ffb6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p9uyn2WzkLxOYYz99zFOHFPJqAazz50vRuHQr07xw1/EsbQ4JI541TJurcRF?=
 =?us-ascii?Q?cyWcm/N+8BnSIuKPENjZcXN739PQ3Z0SzW5ZpSa2xTq9EZQyFzMiu0qm2O+R?=
 =?us-ascii?Q?XL7wpnvs4HI5YPz/bpyh4gMqgqmOF3A+0uOuu1KZdAzmhtMD5hFNYrW0OoTf?=
 =?us-ascii?Q?l+1HubLgAw/Kr/aCOa/FOpiZrjNd+Qd3NwD9NU3qAldERSAFc2fUd4B1vXCU?=
 =?us-ascii?Q?T6JXm5no6FNsN72fEITS0eCIEebu3Rgx011rcNb3Hp+mKl/BhMQ/cwU5Q1+/?=
 =?us-ascii?Q?UfgLMjas9iwspFbEKamhiF0VgdHS7eCqWF35u/9+yXWUkPiw8sEFBqWFhFjw?=
 =?us-ascii?Q?CURUhlafbW9Z/4baJ4tYPW+IjqlrL6bSC8TC4smzBT8PcEIbV/6JKT4sFvGx?=
 =?us-ascii?Q?OgVPfeRGwEcqW/6rtOWu+aP2J8lueazH7NMvi7O20dRDzX/WAHeR1uDgxw/L?=
 =?us-ascii?Q?tdxYcA3suNF/fwRFnvs10V9LShr/0E51OolQZUcoKLT102eoZ5kIoP91wU7g?=
 =?us-ascii?Q?KYYQ7jxh0TvHztotNlIQQClQago686epIKgc1HYbybweEVDGWl3Y+ROmu5VB?=
 =?us-ascii?Q?kwVH46mInL0+Bp7QwZXgjiqfT/QJWpFW41XP/ELeQv425D+F+xfyS9mg2oQq?=
 =?us-ascii?Q?yCCSrU+5bfhvUTWiJlra0Xx68cQUTV4+kGplGTzsFy8Fi99UI+pQg7RMWDOk?=
 =?us-ascii?Q?M/Eo4lwozjDDiJPe7V7/CmoZHca5yGPWlpRKChyD/X84t9rNsjx9/ynrDvwt?=
 =?us-ascii?Q?R9+dvNhHJzcCRC7rCz9P2824j62719tOfqwrj1m7fqUQGMbhooF3pm6zbxcJ?=
 =?us-ascii?Q?6/lr2bZJFdk5aI/sqn7BY4e4wkfJAefnxszmuO9IjSck08SgcKYh0jG/auwq?=
 =?us-ascii?Q?awALaKj1JM5b+kUMZ5f+WK4RzPP7yzO8FYFiO4x4xnzVtp/EJMkw43YpsvH2?=
 =?us-ascii?Q?vOT49hhjbDVpOrlJs25hh8zkq3WE38hpi9GJ5LO0fsluoTa0EtWuHQ4czJ2U?=
 =?us-ascii?Q?qXb/WSvsDa2gboXlKYzzlB6KsoHx0z1m/0VcDMtw0EwdibE5AFs5iy8Kmgbv?=
 =?us-ascii?Q?vSud6TiOzrd87+WuDDZggQurPqHGWIpQuL8xCdRyLZMfvkDMcXK4YAeFmW++?=
 =?us-ascii?Q?aQeBJatMPEsSfaOKBNAI4pUCc1JzFO36+DKK7LvHR7kIePf7d9PEmOwUL1Z2?=
 =?us-ascii?Q?6g7g3a3GY2sw+cpvqdYuy+8ImxRAn35+CWbQIqz9LcjiNdj7Vmu2BqftICXr?=
 =?us-ascii?Q?3NYWkjxdqu9ErKeopbTpSlrWWD7X7l0f7tkRlh+1Oef1uXEpCdFcDgZJoBbk?=
 =?us-ascii?Q?kpqOYR0zi7JvnGv6ss6dwNJYgEacfgCUzRSn+LET3HTivmdN0qK9+Eq9Yh6o?=
 =?us-ascii?Q?11q3zLA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W7qUwyVQ3WF4ZvFVzWsfu5tB7bzfGnQnhYLuD466lgNtna4zoWH33FeRKwah?=
 =?us-ascii?Q?vuZG5xxFXl2AJtGWDraXpANmxQ/6ikK2eZamZjZYodsscsEQ3IgXg0TSjeF7?=
 =?us-ascii?Q?FQAYzR/BJ0eHZGND2Rme71pbTuhqpJ4cH5H6u2v/8iWquM9q0sm0+8Bgkxxg?=
 =?us-ascii?Q?S4u76a7oQ1Q0ooRNwUqjtI5YB2uJfjHhzHvJMPzlnnKT/IdYvl69e0SuXe3l?=
 =?us-ascii?Q?Mu+xRtQn9SNXiuKh7DqB5jHemW4qrF5kxXAriflmsVUSIDWqT+wJE+v1UM0R?=
 =?us-ascii?Q?BWefRt9og9bhIycxvPeQoYdnqpjuKGSQA6s4kTwnt4uwYQ+iWohxCTZn9Itt?=
 =?us-ascii?Q?WWaHZP3wF8SCjqZHF1EpFnT6/KC2tPmJ2B7zeJy0hN+WgH5adjLO+G+CIus2?=
 =?us-ascii?Q?xTGLy31bjeAYw25smYwQaORmAdvOU96jCXcG9IB3JP0wrhAIihVMBgsVWeC2?=
 =?us-ascii?Q?6ZyUTuHi7D3TsuFNZoyWZGfMum+TE7wPWJpYqa1tt3WJWWR/9SJ2QBpAGAnN?=
 =?us-ascii?Q?vpZ4dzwNNvElJiEW/CZQ4yK8t9NjrcqznhZ0VHG5NpBZNP5ub6czCddrWo4G?=
 =?us-ascii?Q?8kcP7rLcta2ajArCrfu9h7NNMqhhIIm03WtfcmxPJvb6Kd6rIYN24bfzH6Xb?=
 =?us-ascii?Q?SR7iCu8wUwh5Oj6KkZFtKJyuXLUEn75+xlcvHE5hvars39ixmFp/U/ieYUPH?=
 =?us-ascii?Q?rvcMePujAZHnBHcNZgPe+OMMLNKJB9SwrW2IgZJObhbFWWUGLd2eHLkC0+Vq?=
 =?us-ascii?Q?6k2ihkq5DpTz1ziwsumGxoJu7h7DpUcWLZnUVl9Pirlyl4C8djVqdAFJPXrE?=
 =?us-ascii?Q?e4sNsx/VQIjSCW82TqGluMOKr8RG35oKAkOtNoPOz4kq8fG+ohHJtj5Jf+8G?=
 =?us-ascii?Q?+qSU/r70Fc9X+HVcJm85OfwNCyIf09Z52M46gn9idAGUErtPguBp/+i5bOD5?=
 =?us-ascii?Q?KgJn1mFA2w4x6KL56Kj7J+w+jX03SWBjZR67TK/sG7vgOy+THvLroVV4Zz/h?=
 =?us-ascii?Q?RJ+103fWM5nODLeQjW5x7xHldag8khmbSL9pgugiKpG2CrBo3FIFFs4wChrb?=
 =?us-ascii?Q?7fx09p+G7lMiQwGG82fzXkVlyNKOrM3866eo4+vv9RqZAb2w6xnW1XHUzYXZ?=
 =?us-ascii?Q?yjYGT5pvIDGUjUxdPfsIMTrb/eGflF1Gw5FTimYctxA/6brrWl/E4jcA4Iy6?=
 =?us-ascii?Q?NmV5aSe/cJClIa+fq0ho7/Ucus+awEsYfM0VL01BNwwFrZRMKiqFz3KBl/I5?=
 =?us-ascii?Q?8wd75yfkv9uOVBE8pXjMjtHwKvaGOiPRM7k1Xcgphf/JQuBy5gEklSOc1Mp2?=
 =?us-ascii?Q?qX8NZzAfyl/0e9K3XGhmm2gJALn+tyU6MlQA2LVkRdYWxiIlXsXBJOVVla5o?=
 =?us-ascii?Q?WEM6p1YCHfr0dAqpPldOteGnVXTwAwUO7LbZrB8c7Fe9JVV3HhCCebZ9FZIs?=
 =?us-ascii?Q?7aFsO4NeNffkbULXtZPpf7E+s6guEct7/mDxJ3xKhBkAB6lYD4wxYILIHwEA?=
 =?us-ascii?Q?zcwbGXZrSr0xZmfXYIiLxrruZ/oZmfPLkPdpgFBzmNkehZGUTqyIlf8lZnfm?=
 =?us-ascii?Q?JJ9aRLEk9s4+dH36lMp5+1KBQp9DIhKkPPNp33dx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wlu69DPecQZiuU0YgVnnRHpKnNI5efLE3brGPB2Xb9zOSXxJvVvF+F7LRo6Lr2+I09kqJo7pFqmEMib+AqGHdpFB3tEYhQoJxNFwruFAgw5KCKzxUgZwOn+klxUiDp8kEPLIDkl+SoWUYCRYB3gKOR/xpcHtTvxPdYk7FNmkaTU16OX5bl3sjUYJzqceHjQihdbK8U5AA+O9E7uOI4HfeWPWb/4piiJu0IPok405Tjvw/gy07+hY5CVfuHWm2KDtUDPEU9yUJjzoOWZilYoGoczOD4Reqg4ZMBpwsCr4/tECtHdeA6d01gYD0h5FdklsFj+r7ikkhY/fmuVxMXGO7Ggajn4cHe75yLxZ25dYRMPODPVEyzA4ouvhzmItRXg7jX9XAzrn4C+NEHnPHAcfAqKA4sqVJdwlt8ac87cMROQjlyENBeJDCjk+0XWf+naQwhQ2CXooEzkni4GX0ht2NaIz+pb5S65OgwqxAA825frMnf23hAajQjTpYFQCEm+dZKrC/zX8nZZ15u9XvpMl6dfx6I5AJ+76ko+HaO1lsJYYrCx9+uZYLrlwkb8Nn2Fcd3w6rwwQwDs9IIUJ0bDkh0OLtDV86m1Ybxh6BNAAy1U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d6b3e0-d021-46da-b779-08dde51ffb6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 04:12:48.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnFN7V5gbLeBT5V0ROI1vSYH6laOv1QRjTaZ0YK6GQk01VsaYUjmUbmaDF7Wbe5aMj8ZdNxDsgCPkSKUZ5Ad2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX9Fcsv9vJdeW8
 eu6/tssZU6Z/R8hALYUNVJKEql1ea1Y/VBgqYudeE7oYrQmuMBuKNvG9vd074d2odxmLjqkn62I
 dW/ir20ObttpkrUEANmnHE+MvlOWp/cPAA+VS8fCT6qv/7LYlkh28o+w3Pvw0rjHkZB8URvLk+s
 t8q/h7GQxMYo4zTnGZLJarI3URgzqxB/BF216QVaYdor7UuLf/obJYFb4dCyD2zwhC755l/ZBvY
 sfmBI2y5vVO1k4HyJ+Z6uprTJ4ngeQm2pict+2A2chs/MrZSmVl1TqdXtDTOkxYE6Qs0TWW9bty
 lLHklQeEPhu2lUmJzB2dc1daebUw8Tk4DFCZ8lIf7zKQjPfPEezWOQxRtiWWCc9BHWRwn7plNMD
 X/0JRkeaIpQfY0bnMAOzZV3NJ9Owpw==
X-Proofpoint-ORIG-GUID: 10tNh-qeldWp0BKMv3Fl3m9paWT7ffck
X-Proofpoint-GUID: 10tNh-qeldWp0BKMv3Fl3m9paWT7ffck
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68ae85c4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=P-IC7800AAAA:8 a=yPCof4ZbAAAA:8
 a=7eb1dzl1T78LbSGLERwA:9 a=CjuIK1q_8ugA:10 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf
 awl=host:12068
X-Stat-Signature: 1bou166mnywhxiyn9ops383odsp4xpw5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A265100011
X-Rspamd-Server: rspam01
X-HE-Tag: 1756267983-50375
X-HE-Meta: U2FsdGVkX19z2xmm+c0eAJ2LBo8HyUt+ahN67VUkYw4YjVGXWpdFK/5PQzU1O02i2dN6S/jjP1rsi1h4arwI+xROH9yIJ4AutmfvAgvckKwp9k5lvwSS7OSTnKkxLnPAOktR6LQ/JbKmhsMGxKXUx4e/bamW1n4PU65PdhT/9ZiSQdK89sUdKql0tpSjTn56oLIoI1Gz/c6IiV//08TotmYW+J1hJllPqYKTnCttrBUeVQjM+JCrPTcYxrWomMYxugkmOjFoMDz5KvJNiAJgAV3AWcsEfqfqzOoHbeVL1tA4AO+uhjdBsZQO4spZ//f5BzRGKlGGLKLUxbqznzjMd2U3vUXJEFzC9RkW+iMqDZQoCQLNe3nKuLnnrqAPC7l5xjiWwwotSwF6ANfjxNYGqyDuNyZDO0XpFEx+JLQ2Kgc68T+MwQeq+B3HOqO5hvCpbbI1+S9Nbg/bbA4XM6QBTenaWmWD8FbUWDqDAnxLyy0C1EGO53Z4rneZ5nIZPhlBtbjpEsEdqPmn4YAl3JlKPDBowUtrm9BcqUaWLzlpaFfE3K6vDi8ZVNXmuI2yOfMpcwhxVXL3ywNkjmxifw9LSric9D9f7E2HsHaJieONLOo9lU0dQYIvbSG/AFh2GM/n7ZI49DP0a0sAa6QkKmdhWSPaLEe7WCArKZB1UKKCOAy9KPANJ9ClJHJ34uVjxnEuw1CR6Bou4E9ruxTZUW4qwQzXKNWdE93PvfPtnMztY9werPuB4Lad4pvPr1e4vrtUXC6tKEU0bpIiPiI25BYVYTNgFvA3XTQXnSjM4yUTfvdvOV11E6DUue5o5WuQo4rKgncEYgDpnaygqf3qZ3S67ErF5EAUGCn4mhvwWlWjnwyRJCC5nU+0U+z6lfBF1124lOvFaP0YkmskwMN6Pobszj8IrHdzM4cbX28Vt/G1hUT19tWLdDcoy9AlIjShlvysWKY9jv7yeQk4g4AmC+b
 hNpOeNRZ
 3c+SPJ4+6sQ8ceRcw6D2fT/gnmUO1FynON9YK4lIz5x7SmnHVgWGmpO1saJ9+I8lNl8KR6st4OP+ntM0oTvMIpfiFcrb7Tf1epcj9A6CC7tIZ0a7Zw8A8zuOWGzbIPqvQhab3qS57PIGZDkGRpGvSZ6bT9tG9+e+1UcydKVivKADuhw7Mu9Mywu5+GSaa+3i9jJ9PRv4K/Jac9W8aABBKgBLQYh8AiM+plhKyqqHnyXLD4/KW7uH0YOUURkBjCEVLSfbETFynr+eHHtVhOpGsKAmcku7q3EB1uWJXnNkFYmWEMUshgwHyopZ9q58iGm23dz3JqIfhvOOZc9QmKs36rVw6faq62x0FWccfbLZ2YcpiMNqBnn6/dkjKOVGzZfPo4oSlpPJxYbur+UOpIG91K7lMN9CrmS3DHJCkQHvHp/10KI2Z4Q8yU3ENnfpsuIAeIkRzZwydxx+ivlM/CFCkhyWRV4Syo6w1ZCIWU7U79xp0VWH1G1IW9raV9VC8A55WLippNakz4d7OCemU18fE9oBTezOT0dEoCjyNRxE5u27Ki+3bl3vkHxARcvyFYnBoPs8NW0A95hoyw27jtv35ZRJ+fbh333qWKNpc2CgR56Bi3yaqaZTOD426W/wcYHlB1oIThboqBnlILeYiynL/1URrv3BhJIFwXe3fskAIpYy0hgUMoXuFIcJM+0NYblIsWQmYUhl7LYTwzPBy8ZYUTx5YnVPb3foB/nUZ5BjdJgZx1a9do3+0T2ebOxDSFjtzdgq6hoBEpGfIJDNsbfZiVyxr2DX+2h77Kg37Xy45bc/dmjATD7pT3rLR79ltUXBICmIrGA53W1oS8KKVKGVypyzL3TEoG6bVyt+g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Cc Suren since he has worked on the exit_mmap() path a lot.

* Shakeel Butt <shakeel.butt@linux.dev> [250826 18:26]:
> On Tue, Aug 26, 2025 at 11:21:13AM -0400, Liam R. Howlett wrote:
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250826 09:50]:
> > > On Tue, Aug 26, 2025 at 09:37:22AM -0400, Liam R. Howlett wrote:
> > > > I really don't think this is worth doing.  We're avoiding a race between
> > > > oom and a task unmap - the MMF bits should be used to avoid this race -
> > > > or at least mitigate it.
> > > 
> > > Yes for sure, as explored at length in previous discussions this feels like
> > > we're papering over cracks here.
> > > 
> > > _However_, I'm sort of ok with a minimalistic fix that solves the proximate
> > > issue even if it is that, as long as it doesn't cause issues in doing so.
> > > 
> > > So this is my take on the below and why I'm open to it!
> > > 
> > > >
> > > > They are probably both under the read lock, but considering how rare it
> > > > would be, would a racy flag check be enough - it is hardly critical to
> > > > get right.  Either would reduce the probability.
> > > 
> > > Zongjinji - I'm stil not sure that you've really indicated _why_ you're
> > > seeing such a tight and unusual race. Presumably some truly massive number
> > > of tasks being OOM'd and unmapping but... yeah that seems odd anyway.
> > > 
> > > But again, if we can safely fix this in a way that doesn't hurt stuff too
> > > much I'm ok with it (of course, these are famous last words in the kernel
> > > often...!)
> > > 
> > > Liam - are you open to a solution on the basis above, or do you feel we
> > > ought simply to fix the underlying issue here?
> > 
> > At least this is a benign race. 
> 
> Is this really a race or rather a contention? IIUC exit_mmap and the oom
> reaper are trying to unmap the address space of the oom-killed process
> and can compete on page table locks. If both are running concurrently on
> two cpus then the contention can continue for whole address space and
> can slow down the actual memory freeing. Making oom reaper traverse in
> opposite direction can drastically reduce the contention and faster
> memory freeing.

It is two readers of the vma tree racing to lock the page tables for
each vma, so I guess you can see it as contention as well.. but since
the pte is a split lock, I see it as racing through vmas to see who hits
which lock first.  The smart money is on the oom killer as it skips some
vmas :)

If it were just contention, then the loop direction wouldn't matter..
but I do see your point.

> > I'd think using MMF_ to reduce the race
> > would achieve the same goal with less risk - which is why I bring it up.
> > 
> 
> With MMF_ flag, are you suggesting oom reaper to skip the unmapping of
> the oom-killed process?

Yes, specifically move the MMF_OOM_SKIP flag to earlier in the exit
path to reduce the possibility of the race/contention.

> 
> > Really, both methods should be low risk, so I'm fine with either way.
> > 
> > But I am interested in hearing how this race is happening enough to
> > necessitate a fix.  Reversing the iterator is a one-spot fix - if this
> > happens elsewhere then we're out of options.  Using the MMF_ flags is
> > more of a scalable fix, if it achieves the same results.
> 
> On the question of if this is a rare situaion and worth the patch. I
> would say this scenario is not that rare particularly on low memory
> devices and on highly utilized overcommitted systems. Memory pressure
> and oom-kills are norm on such systems. The point of oom reaper is to
> bring the system out of the oom situation quickly and having two cpus
> unmapping the oom-killed process can potentially bring the system out of
> oom situation faster.

The exit_mmap() path used to run the oom reaper if it was an oom victim,
until recently [1].  The part that makes me nervous is the exit_mmap()
call to mmu_notifier_release(mm), while the oom reaper uses an
mmu_notifier.  I am not sure if there is an issue in ordering on any of
the platforms of such things.  Or the associated cost of the calls.

I mean, it's already pretty crazy that we have this in the exit:
mmap_read_lock()
   tlb_gather_mmu_fullmm()
     unmap vmas..
mmap_read_unlock()
mmap_write_lock()
   tlb_finish_mmu()..

So not only do we now have two tasks iterating over the vmas, but we
also have mmu notifiers and tlb calls happening across the ranges..  At
least doing all the work on a single cpu means that the hardware view is
consistent.  But I don't see this being worse than a forward race?

As it is written here, we'll have one CPU working in one direction while
the other works in the other, until both hit the end of the VMAs.  Only
when both tasks stop iterating the vmas can the exit continue since it
requires the write lock.

So the tlb_finish_mmu() in exit_mmap() will always be called after
tlb_finish_mmu() on each individual vma has run in the
__oom_reap_task_mm() context (when the race happens).

There is also a window here, between the exit_mmap() dropping the read
lock, setting MMF_OOM_SKIP, and taking the lock - where the oom killer
will iterate through a list of vmas with zero memory to free and delay
the task exiting.  That is, wasting cpu and stopping the memory
associated with the mm_struct (vmas and such) from being freed.

I'm also not sure on the cpu cache effects of what we are doing and how
much that would play into the speedup.  My guess is that it's
insignificant compared to the time we spend under the pte, but we have
no numbers to go on.

So I'd like to know how likely the simultaneous runs are and if there is
a measurable gain?

I agree, that at face value, two cpus should be able to split the work..
but I don't know about the notifier or the holding up the mm_struct
associated memory.  And it could slow things down by holding up an
exiting task.

> 
> I think the patch (with your suggestions) is simple enough and I don't
> see any risk in including it.
> 

Actually, the more I look at this, the worse I feel about it..  Am I
overreacting?

Thanks,
Liam

[1] https://elixir.bootlin.com/linux/v6.0.19/source/mm/mmap.c#L3085


