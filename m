Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E36DD31A0E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 05:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52746B0089; Wed, 14 Jan 2026 00:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A3F6B008C; Wed, 14 Jan 2026 00:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF096B0092; Wed, 14 Jan 2026 00:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9AC36B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:01:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59DB78B645
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:01:08 +0000 (UTC)
X-FDA: 84329370216.13.1C7CB1E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id F33DC120005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:01:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=crMfuWlL;
	spf=pass (imf29.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768366866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBim/v7LOH7y0gD3OF5xZ1YGJw09ZKE2NccN2ZAeYfc=;
	b=PuFQMd0Rjg+KaRUADZx6eC+DEcp7RNi+d2kYFPHlCemq6FG2hARW9QcQ6rAWUpMZa2gTu6
	oOX4WFlbHQ8Pxwx3d4Pbzd06kJuDzTf0av1I8ZLb1qGydwVfy9LfjuTQY4zr9xUOgK5RKI
	07joWnlZU5m97Ps6oqsR4xssE9EqrWk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=crMfuWlL;
	spf=pass (imf29.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768366866; a=rsa-sha256;
	cv=none;
	b=Pr+v46ryZz37KXCN3c0MUDq1a1loUDscF56jvVh1MXN8nNqA0srX98QzV/OzPQntrUUoj0
	G3K43dALtY2U3SMpQPuXheWJ6yYZumBGf4Yv52WRk/qFGqH5lwG/+BuCdyWiIhJyt58uve
	EsY354rQjG+OGha/SM+V1lKzNHH5Sq0=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60DMsvmY023555;
	Wed, 14 Jan 2026 05:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JBim/v
	7LOH7y0gD3OF5xZ1YGJw09ZKE2NccN2ZAeYfc=; b=crMfuWlLB1BWWRxg1gj4Oc
	WrVeEVGL0VXcAgTqRDObMghchQHjKU/s9tSnEr1R/3NHTMTL5/5+vyIKXZQTCtD2
	fRbykAGfNG4oTgNQ7jpB7V9ymCjnXufD1oML3L3ZJxuEOhi74Beb0okI6aKdQ+40
	nsT6BNY6vuj15Wkq59MGLXMac1lMivC1qlQGJX/vjNnOxrtTOe4dId2ogsU2Y4fW
	Eef+Hil3EM4r1WkR8rs+6qKTWiMs3PvRSTQIMw9QX8DkxXutlrtl9WInSVKZOPTZ
	j+m2TEQ/dwMpDx5uDt7Acz6huz9KKGqggk05EuHUdBUCHgZy91uUQb17EUEn5vdQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6e7f1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 05:00:57 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60E4vERe028834;
	Wed, 14 Jan 2026 05:00:56 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6e7f13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 05:00:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60E1kIJ7002505;
	Wed, 14 Jan 2026 05:00:55 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm13sref5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 05:00:55 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60E50rVn62849426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 05:00:54 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFC3958064;
	Wed, 14 Jan 2026 05:00:53 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 891505803F;
	Wed, 14 Jan 2026 05:00:48 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 05:00:48 +0000 (GMT)
Message-ID: <bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com>
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton	
 <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
        Christophe Leroy <chleroy@kernel.org>,
        Alexandre Ghiti	 <alex@ghiti.fr>, x86@kernel.org,
        Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Sweet Tea
 Dorminy <sweettea-kernel@dorminy.me>,
        Andrew Donnellan
 <andrew+kernel@donnellan.id.au>,
        Srish Srinivasan	 <ssrish@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Date: Wed, 14 Jan 2026 16:00:46 +1100
In-Reply-To: <CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
References: 
	<20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
	 <CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D29tMI6bH5gyA6HysOSYI_bS916ORpCJ
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=69672309 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=GVBHeeZ94gNsKoPlMCcA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDAzNCBTYWx0ZWRfX0Vkb7HNvEaQa
 hy2cDyWGDGhXh35qOYGM3Zm3zYME5RTxV2lNCbHr3RQjpwgSUVPhgnqztBE+yoyMoGt10W+Nva5
 U0RMB6L1iXffAZM2sFQ4LqX4IWMRqsutyZ4hR4RtZNwG4iRi27J+Y5GtPrd9xSnsIApJGer4o2T
 5PYCPl0+cl8kZC/0Ea9uc1Ys89wXY8PaCJ9bGHUeU+qIh7DvPra/og3+p2S+0/4uYAmgSE0hCDn
 rg6dbydLCEbJFfN9kMQghGehdVtKNFfrUQPoBn4sQxrWZ8JYsHZDmLztby+guTX1CmEDJztms9P
 HQrUQo2/XtJxrHTeUEGzEtZbRGK+BeSC1tr+tyXL7FANaDN7juC9E/bVvkAnvI+kWRhXRIYk0gU
 /MO2Zojy92eITze9WZfePkxusI/wuDFE0cBFvQIHLhf7AB+uaiNmimawcPyOql+gLaMK1itArx2
 jBhMBavy9xYz/yRduaw==
X-Proofpoint-ORIG-GUID: Ir1PwfNOTcS2nyXFoa-xZGG9lRuyv2Ax
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601140034
X-Rspamd-Queue-Id: F33DC120005
X-Stat-Signature: b1dpquo5q31zbjpq7rj7y6j4k5r17qzs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768366865-552311
X-HE-Meta: U2FsdGVkX1+NZy1g/xitBzp6izsr/w9DenXj8sm0Igz0FfFokHomlZAfGlMFaglw7AFxutSxCbjoYifKDBG55pPiG6CHxGkHuU8irxmOLJ8JNQ6P4O/FdfrDoho0j+UG889ty0jMzJhXjUKpgHQfq28rGGURtDaT+W/CgQSZZouHRjMZj8/eJWQ2bJEHR3Ep3EZbJezH97M8ibfbVE8stBBWorIrsLZqUyG1jcPBDOCZL2w9zsXODBC3s8yuWph1+jP/wkYek8Q1NPy3E6cZNweFITeJSh5HhnHa2XdBcVq1s+QSUV5DQJAQRvu0pvNsGMCoefRlatIvEdAUoxL8MOdPlZxAIV4PwuVRzrcomJisBlLwXR2KlttUCqPiSHDDBbhJwY7uGB+VtzdPvUKrl9u6e/zwOItrjsvEgLVybWibY8V8jxcwbvI3tgDFZWGrC5JADvr4UKjW4gNsBOdnqDv7+u4SzZXJzCvRG7b0VBrBPMYGqJCyKKxKKk0EBnkLLGKvmO09iF5z13/Xbd9qgoYc0Ksz3V5fCFHI6De7J02waOjbtAtpYTrgeVyVi40vrWrftj0w0Fs6vH0w71HhMYYY6WaVjpr7gew6eMnnYTjjilhi1IVr6unqpLbHlFCf1VtLfGSlRMvtiD+Lb7n+DWM+V9w6+5ajQ1AP80KKCeexAAYh5SkqLY05n5X1tYp7rOIHRYFYKknrekYxeDHy81MtkYlxJV6w6jJc53PjI3Y6xO0y87yoKrWja0OIYAPyrtnK86uw2/42SVX/5bNyXK7dX9pOFlTq49gEqmD1ep2DzJeD6CF7sh4HCXDKxH8IzeG6CH8Gf5Og5Ht5CbWQh9FZfw0WpWMwvZ52UiRSB6o1DkpO7uiYpYxAYsBdm38knSUFS+j/0BHLlKfFNpU9HsHDMshx1S6Ak1cjf7SyXvMjfj3au38OBhL+bSQ9Bk4X8G3+MV6KVpGOmIzZ0T3
 IKpPXFV9
 xAQvM44ENQIV8VFnbrPK0Wie+R3kiFGjjT/yY/vHzJKkI506tp3YL3aARY7hBT1keGtza7Hm7bz67WtzvUWxd0Ykeo/Z8SYO9KCPa/ETemyKz9WsWkEYnymwgJJBGKE13CjHdAuWJ0yhHeo219n4HLM0FVJA5K1ZfCASwnOunD8FQqzJDoik8HGg2Rkw4BrBXK5bi8Y4xBPiaZPH6tQD/XaZ5fDY2KCgpQ7i5BeCZ5HhS0sJuudVs2kRiGDIw7hCK9LD7l5wrWc6X+rreKRISRHpShWzJNoyqP8/LpUSq/pPZszzye+GFcCwl12PD4G4x97NpKACcM0xxhw6r/Go1W7e4ZsZe2jTuaUC5UUaWfCm5D2Ke/nLGprYhiynUTRoMZaf24fg6j965Rsdqlj2GnEG9ZNM3JhbiEq6Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-12-18 at 12:55 -0500, Pasha Tatashin wrote:
> Thank you. This series looks good to me.

Thanks for the review!

Maddy, Christophe: any further comments from the PPC side?

Do we think we can get this in in the current cycle? My last day at IBM is =
this
Friday, if a further respin is needed then Srish will need to handle it as =
I
don't have any access to powerpc hardware outside of work (happy to provide=
 what
help I can from the outside though).

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

