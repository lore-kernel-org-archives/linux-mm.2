Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF02EB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B7A6B0089; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9C16B0092; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A33A6B0093; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 65D496B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8B0A8C607
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:16 +0000 (UTC)
X-FDA: 84413523432.16.E3318CD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82509C0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2yPyQhY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J7yBHXE3;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RqwQ58VPEey4b4vrdx+MrCD35OAGJBDGo8V8zpcKjyg=;
	b=UVfGHN9B1H0uv18T+QFGt8/x9kbbj1e+nsuHOAtgPbU1MqYF/rgWNDrfH11HHrUXArqtE6
	3ydLKqL9UaRtVMBDOOK595fIgZqnAPp9RaBc2TPqhpdKlss5pMWyowTfLtN9ylEV6/9o2x
	dbaLYJaLKmXzdONAs0pHTOANezcko3I=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2yPyQhY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J7yBHXE3;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370513; a=rsa-sha256;
	cv=pass;
	b=Uda9U7Xg4SNzCGjYYwVdherBFvBdjVsWJc7o9s8bKSe/maWnJ/rFks0vTs+fggel5bbrnJ
	0SugbNMLLcBQrfByYu460zzYdlBRHFyoc0y4EPoN4EviLnduK65wBP25YY24iN1V4z3/cJ
	4C6RRNypD/ts840OiJm3vQwvxa5WaP0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615IKmLx1076689;
	Fri, 6 Feb 2026 09:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=RqwQ58VPEey4b4vr
	dx+MrCD35OAGJBDGo8V8zpcKjyg=; b=r2yPyQhY2NmMeKmxraK1WY8qhc8Dg6Iq
	/vcnr3TBvIxsm806iTZAh+V4rTgGPpi54X5Vm1ZImzsaFJPwLupKum1S864MJZzR
	djhumM8JZr61gdBzF9EzAdcmMwGpDKAYKrcpZXeLWtki8391LhAhGFn4YyrF1eTq
	mH4q0Thp66UHtyvp3TGz2HXN9t3BuRAagJizNmk9PJWQHvPG0bHE+YfxUcIvFpER
	VMKXwOF11Y5I4U7dVgeTLmO+svEMjJLpvqXRmrxUoKRNu/GD9bGeBXKh2juv5Rla
	69w/5TrAOdrAJE9ZlYSgx8CcbIhDs9ThDROdRu2dk6yzVoMeQ4dDAA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50ddgwth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6168CFVO038957;
	Fri, 6 Feb 2026 09:34:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186ebukn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYTAXMHFuuGoRvCHdRJ2Ke8PThV6iW7mJon6SSl/4CgtVMHcctGnOOBZCPlCK2nbiIhPjX6Rs8ZhI1xKYqxy8L12duOVo0oHJbwBp8nO9Oyli3+LIiPi1dLLv88ewWJHWRM6aEpW9Qf7mRvQXJAMLIJz70+9uXucBnREUIu/iBX9schYV3ZaQKX6FFcpMg9qyKbjLZSAOzMVGUWBa8NXMvevaI6Eye8ID9gpUdVRGAXecs/k8i6rZvTdDolGZ3gUg3OLOraw93zP+wMw/lJIqZWuM9ouEtMMvLIj+VUMuUwZ1PnQD//X4fkmkRANcR8GYv2UnUkCvmmjWdqwHxCTLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqwQ58VPEey4b4vrdx+MrCD35OAGJBDGo8V8zpcKjyg=;
 b=O4J5X4kWNRAHQQMobjZjhcVMn6tnRyGnHBH5+LsbI4/s4X/Es+sWpg+Z5IxpFspkopoJBhNLufadytoSvhwQYApyDR5QEyzis0jhcMOtL+c/rv/Qzcxd85UzR6RCTIadsxZ48dqUqMO0EntLk2YtZnBHV7pGT1YMrr64XB/R2zLNpZ07J3BoQdrEqbXb/jXe/G9I1VZyGoQ1vfeGdqzsfMZvaCH9WtieKJp8RS5bTZf8IpswZ7yRCInLtFRG0dVkyavEeGMLccigAURsBOoZX3vQjuFp+vYMfE44FgRohEUlvVgSItLtGOVrb/zXetnkml+kXCWMR5n3T2xN0Zc1iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqwQ58VPEey4b4vrdx+MrCD35OAGJBDGo8V8zpcKjyg=;
 b=J7yBHXE3bIKB5uwjcA7Dd240SVS/hjaW+fKz10+qtgOQo9YYxdmITZNoC3S4WCZJTVSdZHY/AS1gEhumIEY409OZzvsUtpTpeXmWKDnSUxrQ4962HSPRFerJFqJpA5LMiDLvUtLPCuQQVl9Z4GTYMMZe76FoYJfQYiC21WlAR3U=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:34:38 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:34:38 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: [RFC PATCH 0/7] k[v]free_rcu() improvements
Date: Fri,  6 Feb 2026 18:34:03 +0900
Message-ID: <20260206093410.160622-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0149.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e0087ee-5c12-401c-8a9b-08de6562f29f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qJUfcnI6oBl+0I/Ey42xvoxW+Hxy+yCmlk/zTZW9QBQ68phBCLIuf/B1a4df?=
 =?us-ascii?Q?ujIu34aorg6BV0za7aB4rlbaT0sof1fCMXXIJGWKr4PIAlyYg5bfMBTayFat?=
 =?us-ascii?Q?4G533BN1N/s0EDNsy4AzSNoAmVaUptujfA4Nlq0/VbKElgo5/ku+bqB2WDVu?=
 =?us-ascii?Q?2ijcY34Cl/Xh8v/wMiBnidzK6mtWhotfOswKFPT9mEU3D+S7nWWwyp95HgGz?=
 =?us-ascii?Q?8JalN2Q7oPtWEpQI2LfvNkPngA1oZg3dGCwBuG7dLwovTzRLBtU5g1Zb07pR?=
 =?us-ascii?Q?X5PzAlW7VW7lGliBi0bW4Yq5koiMwSxAFHvngHcRHbGKyFv3g3DvEG188Rsl?=
 =?us-ascii?Q?Ypgeg80bPPR3hP6NQynA4GYOdI993hbL1ME/QisrvV5thyas7Lw+tGY1Xw0/?=
 =?us-ascii?Q?uUIzo2pT5wtwiO+rcb94uRQoJ2m19p7E2OT8T+j+Slnqs97Ilbyu2Agcm9M/?=
 =?us-ascii?Q?XTPHs2AodmQnyZl7oTmJ1ruS6MJ4C8KQpMZSCaG5RQYYZ6Vdp6uSrzJyS0zA?=
 =?us-ascii?Q?kawVEQ16FfHijGThHbGYiejLPhKAmIXYuwsMvB6RIUNWH35OWMlrhwiQxEBZ?=
 =?us-ascii?Q?aeDldunqg6HXjDSAK2A1fykIpSU795fv9DcCInPqtr09f3lM6aSd3iHcJKFY?=
 =?us-ascii?Q?SLE1oHnDc7AMooSObKhC9SKJwheaS4mZoGXe1JoiL20hsximJdF0X99NW/40?=
 =?us-ascii?Q?fd2ax8CUaGJZirzyqx960k/iTys3qvcWKtJEI1rN/sqLeIPBni0snNHIRyXU?=
 =?us-ascii?Q?dwHmuayuvt+SV2jo6Un1P0n61WXyU4VvJnR5x66Qi29RWp+JDbb0fAVApI8K?=
 =?us-ascii?Q?1RHd2VPXwQ+Q6ilwxCwXnv1vz0D+KCFsa73dGDbqZsyEOm/gk0Ju1z8/zORm?=
 =?us-ascii?Q?Ntea6GOZhs25hbywu5ehZSyPJLZs12bDSDKNn3tP6w1y7rXK/kpNHpZwKtxS?=
 =?us-ascii?Q?AiUb0i/aKZ8+rWh300kXHNcRnIn0r2tS06oPceEUGPV23UouPInNvc1p/Qpp?=
 =?us-ascii?Q?pVC7QKWZ+kMWBE/4GSmFsTKaFtdDBkviibZixuJ2vHM6f7dIbqF76LgFyvx9?=
 =?us-ascii?Q?cQ6nYjikJqoEkXB1DyurIQmiT0u5+yCvqRl862hui1ikW2VuY1x7Fg2NX7UW?=
 =?us-ascii?Q?Kf/Pu2xK26hdDHrEgiAqlAvNIPrBMDk6a92IwtoOsH4Js33BJ8PM7kAMujsX?=
 =?us-ascii?Q?TJ4SZGh0JYZsFESREYqbZ72fd1PuGnyveZBeCYDfRDzRnRisVfyt3lCMQdjC?=
 =?us-ascii?Q?eOkJVUMzX4dK02/lQbg4f6WZGqE58fxm0OhLV44Bm3Pdvsx7NbiCYaAcSeDy?=
 =?us-ascii?Q?cwRgZ+CLEuYdyYCwUozc/Yv9r96wprHMbay/RzGVfJOVq9YxW8D79FT8w7tL?=
 =?us-ascii?Q?/e/13hxIOd9EUtwQ8JgkgYc2Ou6BznI0U5jRtz3wwnF5m4ELdiQ77WCV+HfM?=
 =?us-ascii?Q?Si7TZ2eY2UwgVHa2OV6WVoNmomU2S/qqwJThK3FjngDsRgvTYedJf2Amdwm0?=
 =?us-ascii?Q?cnpQzCBNHQNBHX636gF1OzpQH7jzyz4PlfnVnYNhWRlHFV5loWchjp7RQOYZ?=
 =?us-ascii?Q?ShDwkEHMA7ZquF03Sa0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fv2iU1IL/WDcWtCVLEmBbY8EMNxy+HZNyy+efQmPUDmkq3Xe9iXjq+wARaJE?=
 =?us-ascii?Q?TabW1KOGAtn3O5vm4JT8S+/H6R5FGaRr67wcjzKPBQFa5T8bIvao6oEtJbYB?=
 =?us-ascii?Q?wFqG/f0MebNU8xKyIXPI194Yzn14ZF0V1xI27/hfKjuDs9ejiJnEZ661dHkh?=
 =?us-ascii?Q?AiHCB3m955J4DMX95H1eGJD4ElughK1nw244WkI19ViotsdspMFwVbiNm7QR?=
 =?us-ascii?Q?HB5Km9qZLzX8qMTEb8QDyaASJHHIb4PtYpfLs+iexj2nSgoxw9EEitpH81vH?=
 =?us-ascii?Q?ayBn6WcV9y7HZgsvilu6IgpvLanZ7/HYAic7eCa7sTw8G/IWbv3gK44Fc2Li?=
 =?us-ascii?Q?2HRgW8E/s2mThrMzSzbCnYHgxPRDDB+WgbjWBkXNuV6x8K04vErhSaqMfZSZ?=
 =?us-ascii?Q?cF4L5n+qkjB9F54qYxFR6saDAcsRSwRC+NvSVYl/zMwxNJ/mcxr8v+8uCN+W?=
 =?us-ascii?Q?rFunEUL1p9zGnYAilqXXECZUiwnPrNy39aWz6y4NP35WwLGkWl98Vihqr7zs?=
 =?us-ascii?Q?bBTUg3LEi50RhxYVvJKp/bEDfZsbhINxyWHA5X35fBpF0KPfAbj7QEypNvdR?=
 =?us-ascii?Q?AiU7ES54zXXA0c+z/PmxKj2H4Nh0qEjZ41sPpRmnndpymXuInoRwpBnRLJzf?=
 =?us-ascii?Q?OeEMUHR3OHRGSkgZK46CRdAr8qHyxATiiAf3EgJAZd5od3kurJZxX7A2rxU+?=
 =?us-ascii?Q?4dQkIgJTJTxjQ7WlD83wQAmn8QtiICVJ2c1cOm1fsI7UXdyBfiTf7YQ0Q3dg?=
 =?us-ascii?Q?FskKvQkx9YOmpU+cM+XVmIi+xY7uJ5pYNPxijD47iUZZIEF+YTK+6AjQiiAO?=
 =?us-ascii?Q?Xx1UiyqxQF01+marhkpvmUwuEoUy9gqPi4nI83yREoaTIYrvg6zTqhiczvLo?=
 =?us-ascii?Q?EaX39q06Bhmo1ZXzSEcKtkSvVKymr8Lpe9nLRqFHaLlom5KFDOF8pZk+7NLx?=
 =?us-ascii?Q?a9Y2MYifISKrJDxl3yn8Y/CVJLr8PbacEk+dp/VsyD+4CuvpSSXPBbbBD6tm?=
 =?us-ascii?Q?wA6GDr8JHetfsXdHk004yQqYsawk6BWrZBaOan5vtZ9NjlomyAN97+2H+XcU?=
 =?us-ascii?Q?MmjlKlGhp1uY7voKxLnTB848Fy2jDSlPhCOfXO0LvgH/hWsk+umyqVEfyrbm?=
 =?us-ascii?Q?DEaqYTucPSspFH0MFFAVeyKgMAfcAIL+BGejOKMtqNO7a4VAX2GwmXJ+zRq1?=
 =?us-ascii?Q?qT6zK6RUD4t+hKicvmHMiI8XH6RyTS89tHYabfcOIKpy29f/dfqJdc7/o3aB?=
 =?us-ascii?Q?EmpDL3VYWS6t6Qa09ovuo6DvNMAnJ5f0IlRXg3cbmdJYZGyOVxBQueO6U76P?=
 =?us-ascii?Q?envzPzyABj62afTgs2f8tLZ+9uYZkgYAIQOkomzrXlkBNNKuH5H8OeDt94iy?=
 =?us-ascii?Q?vbjPtlGGV66clka5XKkDndQBcRCS1OoU4xbw8/0e8ttq1bM/Lo1iNdQyVFln?=
 =?us-ascii?Q?5FBMTRt/SYXhwWbvPnLMOksPxHbQLRhbgmuppwGMi0f7cGNHreyNstog9lGe?=
 =?us-ascii?Q?aCrOo4/R8MN8yft557ZEiObzSKbf+E8LnPh8+tYwyK4mYwcPxm6g8brAR3Rk?=
 =?us-ascii?Q?XQcErCVYpKeAM2eSODrNYQdpfPKq+/zoMtkV8euevcyoj2WWFuxUSSQbpFNJ?=
 =?us-ascii?Q?1mJA2IIyRxIoiUPRqdw4so3fiUz9V/9/F9XZ9ulbpu8nXOHepTDU1u7Ee5mn?=
 =?us-ascii?Q?3HfSeajn82sEB62ZEWcvi3ypekaULDj1hJgzuHsmGnuna6G1b/Bh96efrYEQ?=
 =?us-ascii?Q?74zbiWw9yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WtZFVPhAJKy+aJ0i6xzUEkDOzOVzXHlhM4Rj5gUZsg6mEz4OuPDDHA+27Z0ycZdc+2U5wj0E2vn1KAn7bboHsimpxadIIkPOoys+M7C24ATWI2bq29rHqO7DAe9HQRrvpP8BwG5KErS2k9xtQHSNns8435yx2IJezja49mWWpDwaPtWU6iZeG6oEMcvU1yEKA+u4lwZsPQPBzPMMfRaFxrpT8yDqqE9zoWQZO78d/o5jtjiMMD+XnwJKlOMWdt9AAa/KYTJr/Um3CoyGEJL3yMjx5N8z6bvfuIewJruR11zWZch1c6I8u5uo1PoFL1nwZdBtHGxhjf6zy9qOpKIEcub1swcR8Q1Xb0LI3t33074djvfFVY/hz5qB1wu0/i/GJdyonICs7+gOUBeS72QfPIOfv4sfeR3fBrTnVCX2nPaGtCMdeWlAM/dz7zi8eNfG/29vFxnHlvfyIZWQhadBXVcj8LzzSkrDxMvxDzoH2JI2HJfCpEf1V1pT3MDuL6CSRSv1wGLlETjoDavcmCFCxA+PoTeeH9oJy7RTl9a3mmejQ9z+7+1WyafSjVYTfecK2PSm1a2Xdcxg5LAwZfUhX5Ayi7qbIL0qhzK0G+Rju/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0087ee-5c12-401c-8a9b-08de6562f29f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:34:38.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQb5N+WnTOCPUlxJKnZH7+kHCli5aFGDdiN/igvPvCMpKeqFrmU2VPijDeoIla/ZP5wq86T8qd8XWKSK9kjWvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602060063
X-Authority-Analysis: v=2.4 cv=TvvrRTXh c=1 sm=1 tr=0 ts=6985b5b3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=_FhQP1wN110f_tC0GWcA:9
X-Proofpoint-GUID: T4APNB5BLYBpNpaQuAfN7OvWY4Uttn8r
X-Proofpoint-ORIG-GUID: T4APNB5BLYBpNpaQuAfN7OvWY4Uttn8r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfX1Z8d6UyMIGB8
 2subwtqqVxXcU9ZFvvIf7aQmnuAAF5Qf2Cr/sVtBw4ksKIid5BFxOsKhqTOjKlW4nC60EOAKn07
 LBRkc3OqgVhf4ZfWiV9+UEz7aNKSuRkbBp7HEiaeQbaEsrWxrENWY1Mw+MfMSneuDdwaFxuu6/+
 FGINMrKKX6JTK7cawLwVeF/1OvGSxQ+4XWmQXwCJeo1e9OibdU+rQIqrVxAwb9dAWo4M+cxoQ9+
 OiKri26wxT4PUIcrYH9mbFX2Tw0NwW4y6/a6fLsUinohgIYymX4csY31QjizBfAT44qZVFoQfDu
 wF0hErSQYJsrndzxtSc3IxfX6lB51SbiSxv3R00AB0a5ReG2oDjUdGx4g460nz8J69ILZ+/gYOI
 GvfylVC8YPaxJ6wFpvE4EE0ZSd4EQtYBe2PaxN6IjH0k2D85GFL4+wgmEUcRIVMqw+8hFWWfdei
 9pxgMSFjDw+zgNu6xRA==
X-Rspamd-Server: rspam12
X-Stat-Signature: ojniypbwue3q4ks7x9ntikky6iqb4qot
X-Rspamd-Queue-Id: 82509C0002
X-Rspam-User: 
X-HE-Tag: 1770370513-460051
X-HE-Meta: U2FsdGVkX19sPwF/yy5bdOjbWBZloWt7pl+mTgVm3s0YGhe8f8AE5deu+/LGz0L1YBeWg5AYATmbdz7crzNV4EQ6JsffP4IELGfZT3HxdN+jZLtufHmUN5sxiDKBVVrLIcKls+0gcQdh7ql5MvBZ+YjrQ42EFPYJykTwUQs3sFiVpeS4bZ4IdLu63supb8piQSVVYl/PmVnVcFgSAukhYMNYily/QabBNj0LkXL7jVlzEWKGK573l6YiNPiEi3ha8KM1ikk/dNVYFFueJtCl8VmQHS7CpHIUyuskTmaPx3zIB3hGGuAxT+RIQAt92wOd5q1sjL/zrI0XkgKAV9Dooy7XE7mdWS7lJqIyrPbcayGYMEixBNVqgpymXmayBJSPQ2BJXR/1YWltRUsHc5W3Lj/MVLNto83XeURoIQTtSbPnFK0ciFerPG0Yvyp5zH3aizARrSfPVZRqeP+mnE+wsniQp6WT/FIb+rRmqbmZKDExJQMjhdTu/Crz1LL8xPqzT7lr0TSynxmjhDsx1ERBxvYnjfFAeknOq5GpBt8Q981mH/LKYWVALXJhMDs1XfNbtlDAZ/QFQ3m/rCp6KIbh/HUOvSO+dNnjP9ktOpm9py4ZiyxxKLAF8X6UpZ7U/oUOh9Q+gIQ6Inf7nX3uAwDXnfx6KQ1gnSan6GHgFpe9a5os/eDRoY/a8qJSHXpvTFvhnF+/b/wPUaH0o4lhfQW3W6gfbwom+pADvWvoJAVIekmXC5emERw4vPJcWCzFaShxHBEQglXlz8P++M19t4qO7EEcPfeF31fib1psMWV/9wLVlepFxHNTy7be9/Ab0vbok3NSe1gIJvE7cRY2y/vnHVPBgAlEMWNzaU9ZQYIM+1KFhaVnmyuXgVj40Pl9dt0Mmn836Q6EGhTyRM8GperRfRW9ioFO+RMByg8OvgWrdvvYd6LAY+Af7Q+iYx3bt0j0HeMJXzLoXNy9KtAOKec
 s3sY5EB4
 o4qYcRYZg+AYu3HR27y0Fwp6GXJEI2pB4kaknYdiiqSE2NANjCh1ePueEuNMgdMDrQ8nVYGzuQDeXhO+8JVIRQOk+ro5yCeE5rAavvWYIeSYFo80Zvx2dIqQhn+NLiZWZiige8qFtKxYbj1CF3CbEirejDnyV7E8yQRXkyP0+SSH/vmfCG0BIRdcnTXSEV0wG3qYmJTE9mJncseuTr+RiQSyTmUlR3UfUCn0MfJMo5rdFZQFG0kC40kj6JY9lH8X/Vk0d2z0ybLBQtOReAzvhCF09ePjsZVhDXbmf643bc8FNRKaBFPOqplJ3i6iEidXETTy4KSy0pl9pibd0sNO8ThrojnTmDwstElt8g/5AwkM+lC7G0hKVT80lQ0DFjEa4QQ56iZhXNJiyw+0ed5mRrgkTjGQ3TJ5N/0ewwZGc+M2b6iDpzVxgca+NhgbG2mo6qeLyxZdRP86ARIbttqDYxxjWcu5DRK896Krt/H0pi2SYa8ya5fva1vOtzrEbQrByOYxmxGWcUb17nkFRmV9qu4DlXk0lP/ndCw1hscscyxQJlhDqw3n06cGsD20BuxYFzEI+Eugqy5Q/+fCcz3ZjmyU1eBCk2ndI06sbj3DTFidv7TMu9bnQIxhsWBV2zFwCuIQFRXVBg6EHqbimZpaVeSNjNViYK6kq7nRIWkDB+WtOmgCRz5ovjG9ClDB/KB832VEnan5pj2Ju9A63m+78bUr15Hn2LF5iqhWQE1feUK7LinM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are a few improvements for k[v]free_rcu() API, which were suggested
by Alexei Starovoitov.

[ To kmemleak folks: I'm going to teach delete_object_full() and
  paint_ptr() to ignore cases when the object does not exist.
  Could you please let me know if the way it's done in patch 3
  looks good? Only part 2 is relevant to you. ]

Although I've put some effort into providing a decent quality
implementation, I'd like you to consider this as a proof-of-concept
and let's discuss how best we could tackle those problems:

  1) Allow an 8-byte field to be used as an alternative to
     struct rcu_head (16-byte) for 2-argument kvfree_rcu()
  2) kmalloc_nolock() -> kfree[_rcu]() support
  3) Add kfree_rcu_nolock() for NMI context

# Part 1. Allow an 8-byte field to be used as an alternative to
  struct rcu_head for 2-argument kvfree_rcu()
  
  Technically, objects that are freed with k[v]free_rcu() need
  only one pointer to link objects, because we already know that
  the callback function is always kvfree(). For this purpose,
  struct rcu_head is unnecessarily large (16 bytes on 64-bit).

  Allow a smaller, 8-byte field (of struct rcu_ptr type) to be used
  with k[v]free_rcu(). Let's save one pointer per slab object.
  
  I have to admit that my naming skill isn't great; hopefully
  we'll come up with a better name than `struct rcu_ptr`.

  With this feature, either a struct rcu_ptr or rcu_head field
  can be used as the second argument of the k[v]free_rcu() API.

  Users that only use k[v]free_rcu() are highly encouraged to use
  struct rcu_ptr; otherwise you're wasting memory. However, some users,
  such as maple tree, may use call_rcu() or k[v]free_rcu() depending on
  the situation for objects of the same type. For such users,
  struct rcu_head remains the only option.

  Patch 1 implements this feature, and patch 2 adds a few users in mm/.

# Part 2. kmalloc_nolock() -> kfree() or kfree_rcu() path support
  
  Allow objects allocated with kmalloc_nolock() to be freed with
  kfree[_rcu](). Without this support, users are forced to call
  call_rcu() with kfree_nolock() to free objects after a grace period.
  This is not efficient and can create unnecessarily many grace periods
  by bypassing the kfree_rcu batching layer.

  The reason why it was not supported before was because some alloc
  hooks are not called in kmalloc_nolock(), while all free hooks are
  called in kfree().

  Patch 3 adds support for this by teaching kmemleak to ignore cases
  when free hooks are called without prior alloc hooks. Patch 4 frees
  a bit in enum objexts_flags, since we no longer have to remember
  whether the array was allocated using kmalloc_nolock() or kmalloc().

  Note that the free hooks fall into these categories:

  - Its alloc hook is called in kmalloc_nolock(), no problem!
    (kmsan_slab_alloc(), kasan_slab_alloc(),
     memcg_slab_post_alloc_hook(), alloc_tagging_slab_alloc_hook())

  - Its alloc hook isn't called in kmalloc_nolock(); free hooks
    must handle asymmetric hook calls. (kfence_free(),
    kmemleak_free_recursive())

  - There is no matching alloc hook for the free hook; it's safe to
    call. (debug_check_no_{locks,obj}_freed, __kcsan_check_access())

  Note that kmalloc() -> kfree_nolock() or kfree_rcu_nolock() isn't
  still supported! That's much trickier :)

# Part 3. Add kfree_rcu_nolock() for NMI context

  Add a new 2-argument kfree_rcu_nolock() variant that is safe to be
  called in NMI context. In NMI context, calling kfree_rcu() or
  call_rcu() is not legal, and thus users are forced to implement some
  sort of deferred freeing. Let's make users' lives easier with the new
  variant.

  Note that 1-argument kfree_rcu_nolock() is not supported, since there
  is not much we can do when trylock & memory allocation fails.
  (You can't call synchronize_rcu() in NMI context!)

  When spinning on a lock is not allowed, try to acquire the spinlock.
  When it succeeds in acquiring the lock, do either:

  1) Use the rcu sheaf to free the object. Note that call_rcu() cannot
     be called in NMI context! When the rcu sheaf becomes full by
     freeing the object, it cannot free to the sheaf and has to fall back.
  
  2) Use struct rcu_ptr field to link objects. Consuming a bnode
     (of struct kvfree_rcu_bulk_data) and queueing work to maintain
     a number of cached bnodes is avoided in NMI context.

  Note that scheduling delayed monitor work to drain objects after
  KFREE_DRAIN_JIFFIES is done using a lazy irq_work to avoid raising
  self-IPIs. That means scheduling delayed monitor work can be delayed
  up to the length of a time slice.

  In rare cases where trylock fails, a non-lazy irq_work is used to
  defer calling kvfree_rcu_call().

  When certain debug features (kmemleak, debugobjects) are enabled,
  freeing in NMI context is always deferred because they use spinlocks.

  Patch 6 implements kfree_rcu_nolock() support, patch 7 adds sheaves
  support for the new API.

Harry Yoo (7):
  mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
  mm: use rcu_ptr instead of rcu_head
  mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
  mm/slab: free a bit in enum objexts_flags
  mm/slab: move kfree_rcu_cpu[_work] definitions
  mm/slab: introduce kfree_rcu_nolock()
  mm/slab: make kfree_rcu_nolock() work with sheaves

 include/linux/list_lru.h   |   2 +-
 include/linux/memcontrol.h |   3 +-
 include/linux/rcupdate.h   |  68 +++++---
 include/linux/shrinker.h   |   2 +-
 include/linux/types.h      |   9 ++
 mm/kmemleak.c              |  11 +-
 mm/slab.h                  |   2 +-
 mm/slab_common.c           | 309 +++++++++++++++++++++++++------------
 mm/slub.c                  |  47 ++++--
 mm/vmalloc.c               |   4 +-
 10 files changed, 310 insertions(+), 147 deletions(-)

-- 
2.43.0


