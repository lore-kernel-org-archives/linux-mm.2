Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7419BCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483D06B009E; Wed, 17 Jun 2026 11:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D566B00A2; Wed, 17 Jun 2026 11:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5016B00A5; Wed, 17 Jun 2026 11:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D60356B009E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:16:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DF1F1A0497
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:10:49 +0000 (UTC)
X-FDA: 84889741818.22.7EA314A
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5026A1C0002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:10:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HD6jZZ6w;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=b4Jhd0A9;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf20.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781709046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YBziW+jNxpYMMjSuiQS2RoRdi8ZQaRWc1l2ZENqmI0Q=;
	b=jKCoK1x4MAQKokJIOeTXYgQZfm7XgZnQ+XxFyPyWaReDhApSuP02Bz3OGk9mz9wmvUbbPe
	gO8d4DvSf9U7TuPMTRedjYDHO70EEQh+b4U2BSsqvqdHD/xnK2iRySjNB7Yfle3LzDmePY
	lXpursRqrafnT+PbaVh7UngkeZ2bOUg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HD6jZZ6w;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=b4Jhd0A9;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf20.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781709046;
	b=I9acG7ssvfjmM3mMRhFU9I+Fhem9Odnf7L2ddfzoY5XZwnxZ5F28T3ha+Igz7WxZG979bP
	hp82XO7natDG5RMMnYfuQKHUqiU13saev4cuAVXC+f8tNpUWZfFZhnYlNm/bJ7h3rg/QJq
	Rdzth+VDCIWnd52h2Lvq5Tfxf/xvngw=
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEE3YJ2509988
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=YBziW+jNxpYMMjSuiQS2Ro
	Rdi8ZQaRWc1l2ZENqmI0Q=; b=HD6jZZ6w07sak7vbBJJ+G9Dq9HebSrf4st71fk
	Uh9MBcww2qBM8VeKuG12ZSHzuWJz7g8d0jO96u+8NfwVJO09BIhmGVxwY5pvjKZ3
	rPAR7zgGz0+PlWoCOQdHCJiruhHONn3QEbXNXTevjETVJX2D0NwwJ86iGQKb3xTZ
	jgWJ3NJmzCpjXoPEhzoDnJweldWTW8Kbx5E90v/Dcg8vCQ0c8+4hT302uoSRQq5x
	RYRRmH6Uq3/jKA5W3S8fmapto/yvrUU+nCXZAo1h6anahdYwX6vBfTfH5u0aRVu7
	NcQUq78PYO+gVCxXVxKX1CMfV9AEw/l3Umfr6BVSX9Lcj0RA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eueemkv70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:10:45 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bd04e4fe3dso145112065ad.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781709044; x=1782313844; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YBziW+jNxpYMMjSuiQS2RoRdi8ZQaRWc1l2ZENqmI0Q=;
        b=b4Jhd0A9sMS5u9JOGqoVlPtez7fFmaEqhITN1+7Gk0+DFIZfs6QOgUYuGhwvc7Xnf6
         eXD/6UXMqQmVJDNkMeGdRbr9AqzBWCfKm9pBA0yFVGjnsocE+KgNmQ0pC+JEIMT69lXm
         88n+YuiyLloaoZf4TVS5nw2jNc6DlgQHRAlgHoA+RdF6z++0jVvj7cpPhqult3cfiVqe
         xaUnR1wggUXkByjQmy7Kn4offtMOQde8iT1sXhfgF6DxU1EN8Hw2Fra/wSqlZhKGInmL
         lS8b81ysH/GTImBJZY3QG0AnP2ruKBfpUPYjs8gAkjwaAeuEHWTV2lTpRdofGaGCeC4d
         XFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781709044; x=1782313844;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBziW+jNxpYMMjSuiQS2RoRdi8ZQaRWc1l2ZENqmI0Q=;
        b=oa4bg0C18BXHvO8tf0vTuJythoaKVI74gQWJ3UFwGtQiiOo9z3GjoWCiM+o0PrQk+5
         an2sGsSEMAmb9qBBIU1vbBebQoq1bZMi8LjlMpCCK9R/WWe7uP0aszmHhV5Od8sxQCX9
         FpUySln3cRq3ekfMt1gLOGpjgC2rMJYa6qxHoy+l7h7DGdSqznGcd7cV3HgG0ZA2xigq
         jfLXTV0Jj1zj7+dIzRqHNapRB/DKvOiDWJM3NbMJ8d3oMvGoaiZzNgELbdfI3uzCSeUe
         QEJ+ryHgV2lLGeXznkds50Iu7S1v6SvN+ijAxU2L+DZWrBOf7aZsMT2Atf6E/aTblBUe
         nnDg==
X-Forwarded-Encrypted: i=1; AFNElJ9mxTKLwgflCHybvBXoOZoduBHRhKFcaF3nRaSzJRchx+mmfzdooEQaVAAAqCuoZPf6b7iQ+eDE7g==@kvack.org
X-Gm-Message-State: AOJu0YwWPJp3paJZtjF6dqvkbcOrVN5RM+uA9vPbqBt6JjiuZTdQki+Z
	AQrdEPrjfSSxMYOqUaZpIMnO3D/1w+PXjyIeiioTZtx4VLGL28uvl3K4C85hr+XNow5sLBPJ+t5
	gWy+ySAxhRJQw7SY3FiJ0UwVIa40NsWprVWnHsA3KiaF+dIu4lr3kYw==
X-Gm-Gg: AfdE7cmqPEn5D1BQ1v4oNN0p5q1YhEnTjR1FM1w/quHKx/14/VAtonZ8kDDCi/IQFP2
	NDTo/VQG+BrJs66i/rJz7J3mBh8bypl01cQxpOdcmZ+hnURb0TI8ookDyH/HEokQSW4gsdxNH9P
	DB0TIWw72ZrDrAlKp27VCabItad03+MtsimiQrlI3IByXTpj2DwNypS2Ky7f/4jh1q4SuYtPJlh
	+1ZjlF0C/Qy5bW7f3Mpt//XGFNrsbR+qhVuhPGSaBVnnrVPvik8YBzybzypSltlK2drn3Lu1HW4
	afeE3x0BsX8chFT3TWeLP04ZgJLO+aq4ajzw4EGejSWqrJPLZhP9CZCiUiDnb6hkkJWRSvkM3Oh
	V56OOoT4VwE5MYnGHH4EN3rovTtarJeiTMllmjzeO3okN
X-Received: by 2002:a17:903:41c1:b0:2bd:c925:3a16 with SMTP id d9443c01a7336-2c6bbf90dc1mr45959885ad.2.1781709044417;
        Wed, 17 Jun 2026 08:10:44 -0700 (PDT)
X-Received: by 2002:a17:903:41c1:b0:2bd:c925:3a16 with SMTP id d9443c01a7336-2c6bbf90dc1mr45959445ad.2.1781709043901;
        Wed, 17 Jun 2026 08:10:43 -0700 (PDT)
Received: from hu-ketakish-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e5369sm173008955ad.9.2026.06.17.08.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:10:43 -0700 (PDT)
From: Ketan <ketan.kishore@oss.qualcomm.com>
Date: Wed, 17 Jun 2026 20:39:37 +0530
Subject: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIALC4MmoC/yXMQQ5AMBSE4avIW2uiaBeuIiJVU54F0iIScXfF8
 kv+mYsCPCNQlVzkcXDgZY6QaUJ2NPMAwX005VmuMy21WM2AFucmCgmnlCqVdpZivno4Pr+ruvk
 d9m6C3d493fcD7ufg2WwAAAA=
X-Change-ID: 20260616-page_ext-31ef555456fc
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Luiz Capitulino <luizcap@redhat.com>,
        David Hildenbrand <david@kernel.org>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ketan Kishore <ketan.kishore@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781709039; l=2403;
 i=ketan.kishore@oss.qualcomm.com; s=20260617; h=from:subject:message-id;
 bh=1LsqRg7IYtW9436fFoRllRoIaDA/Lb7rLxc81bje6EE=;
 b=XqI7HYIIV7wdxk8hxavHaHVk/Eq9wSVzsuqlY04ALCXvamsaHtKThbz+KQmR0N5ogkDotPFvM
 hXYpmB4cobPBfgF72wgbehZ31RsS2qgaoH3fLBQsJT+K+b/2CWMwPYO
X-Developer-Key: i=ketan.kishore@oss.qualcomm.com; a=ed25519;
 pk=4sb5Ima5x03wc0KSnl57v8kR/7FxMt01+xlZJ53rSJU=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE0NSBTYWx0ZWRfXye1sNgJb/dZN
 IHP8Bx0yzjOA7JVoOcZq/06cZT5Ot/zYVcQupu8BppxNt9SFjy7+dhm18AeMoLkC/6m24ucoYDZ
 wssPxq9nGjFNOn6mdNJ+88DCnsCWhj4=
X-Authority-Analysis: v=2.4 cv=D4d37PRj c=1 sm=1 tr=0 ts=6a32b8f5 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=6cwOV1KxhTczzfVf7psA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: NtftjIJTf1RQt5iafM5-TKW-Q5YFNwgW
X-Proofpoint-ORIG-GUID: NtftjIJTf1RQt5iafM5-TKW-Q5YFNwgW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE0NSBTYWx0ZWRfX/HiAP09IaQl8
 uC/aqPk0h6vQJbaNWNv/9rmZJA864906z8HdYEDgdUNbMqib9oJTRNdfRamsYhtfn5jZ5l30X8B
 80jZNXKWjWlxQn61N/a1f9XWeCFew6xkF8kY2XTqxXViY6ocv6YkMicRCuyYfsv+aecDhBQoef1
 8ISZbCtHMid5sTx7eP2I0jRxSBJLNkSwgXGRJSlSGxMtNBFZmmgplA0d/I+K8vWH9CgHWafxgLG
 fWVVJY6Zb+ZslnDLOA2Auc5RZR3YjbrwiWEMXLJkTgtB/LnMQYHBr0AQwZ/gVf0shnPwAp2bpPV
 ak/RA6Td5eOmdVSbZqrTRqv08Zvyk9EeAIe3wWbTG9QcUQ2Nq2xDaDKfecw2RurLVll25tuO0fa
 spmWCMeBaR/7XhMl/WgkDYhWWCnzyqlSfwQvHOC3Hh+rpnEymhv4nl5Xlh8XcW6T6PsbE6uvhOt
 3hAEaaW7AHQFLv0ljRg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606170145
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5026A1C0002
X-Stat-Signature: rn1mjezd9s7iohbm95h5xfqo7paj8zdh
X-Rspam-User: 
X-HE-Tag: 1781709046-516692
X-HE-Meta: U2FsdGVkX1+vpzrq+0iistz2GOZi5BF2ao+vxGRkchCjQxqVb2kmNfKbNVpBK16QDd8G+A+uodT28HWt5UumVsVJmB00l0CL9pn5JFuKFJnvcu5FvMtoah8mn3/iPuQLczjIFwAsAit1QxZr+Mdibr9uV1ysy9kS9v6w43OYZWen/y4DsGMZ4AcYshDQFzoblnMxeff+yhl0zXyxoJIPUI7g3qdxEx1P1rWv7n5k013wo2BDfNujKeJG03Bee80qVS338QKSAoW5WZuq517hu/nAowFR+yXH7HZOjrMNV+AwL6jZBEOCVHqmbjI05uL7wmZsugXyatJm8Y3atTqKcyP/oudF7uAAPINgVRnUVt8LeijsDtbBYpaB3r7cbjtp2VAzOcuYU2XiKdQaOqzXndhc7NINKwpU2YETNn1WMWBnUdZc75UbYJ8M2ndqcSbCHnRydLSVODdDfU+1DJGJoFJCmE1aR6WhoVj1YUXo2FsYPhtqRhizepQ5XjGsJJJ0+8P7ZayrAoOGWdywG/CcPTIzmIFiJaJFgHjYOanzyoKeut7uIQ/SRe597gPUOhraDFpRrglUjvNO+9yrjdA92GhrN0VA0NcYlXW4PI8CRZDpc0F25s1FyI8oc041UghEOlQw8AEojT9ku/cT2JTBEk5jVctANGVZvN58ehS2U1HLCokZG0h4RAPwRs/DH+q3Uh1I+ehTwHpM/sULmo4RyiqXYY/ok8c279RAPyS9Y21+g7m65wGDW9aP780QW4VAEbGstO3zoO8bhSzLs6Xf+cwDvoH4yC5ToJ/vDjKm3uyoEXI4vPCmw3QPk/7QjuXMTb0QbD5vQwjSoaGIBmjfjFfYrKw/YNzkk3pad5Owpch+mmbJNZFztbOIzetrm4T77+nOxiRuj+4m6TYID9WhnfaP4WqsqjVm1tX5bcCIsj1ZWsHIhIScNIUe0jyy3VX5Ox9B9XAAGIENs0RV7rx
 rT2DGgdx
 Ppfus/Zhuf1bHRm1aKIAWodvA6rLXPS5J+p0j1puk+u/0F/oiIZpVmtap//1LUxNL4/ED3uN7F2svcxkQUjUwSbqZONWLNADmyz8qSTPcHRgqqeXslBwvuczvvw8vFaLpbJH53JotR6RK+fyYxXj9nyfLd33U4SBjHJFYqN134IKWwfzEX8Sop2/d2PO9FxnSwLTEDG+jG0Ur0KPpd6G+97gz30fbk5E8JnufAr0mptdH/DrL6a4SN2WatQyZh/BfOS/rHxCp572kKaXzCtvEpevYTC5El/V1l40wsbCau48B/6J+TzCBCNu3Qb75DM5ZAb2EZMhHOiof1hSQmEBKbI3ng8s3a/YumLaa7nM89saO6hmkFhjSALc/j0OqvC2zx7yo8CsDE+6znq5ctTa1ygOBzmOFU/41XkF7q91CCconEKrCbBCvb2bovhLHN+WJn26kCxiTcYmTOnrS/UMP1kP8tkLaxF3YEXHofB2RGNHaHs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_ext iteration API do not validate if the PFN still
belongs to a valid section while advancing the iterator.

When dynamically adding memory in hotplug path, it can lead
to a NULL pointer dereference during page_ext_lookup at the
boundary of the last valid section.

[   14.555124][  T846] Call trace:
[   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
[   14.555127][  T846]  page_ext_lookup+0x30/0x3c
[   14.555129][  T846]  __reset_page_owner+0x11c/0x260
[   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
[   14.571204][  T846]  __free_pages_core+0x78/0xf0
[   14.571206][  T846]  generic_online_page+0x14/0x24
[   14.597782][  T846]  online_pages+0x178/0x30c
[   14.597784][  T846]  memory_block_change_state+0x284/0x32c
[   14.597787][  T846]  memory_subsys_online+0x4c/0x64
[   14.597789][  T846]  device_online+0x88/0xb0
[   14.597791][  T846]  online_memory_block+0x30/0x40
[   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
[   14.597794][  T846]  add_memory_resource+0x280/0x298
[   14.656161][  T846]  add_memory+0x60/0x98

Add a valid-section check before looking up the next page_ext
so the iterator stops cleanly at section boundaries.

Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
---
 mm/page_ext.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index e2e92bd27ebd..74067ea740fe 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -253,6 +253,18 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
+
+	/*
+	 * section can be NULL when the page_ext iterator's for-loop increment
+	 * computes a PFN one step beyond the last registered section. This
+	 * occurs because pfn_to_page() uses __nr_to_section() which succeeds
+	 * for unregistered sections that share a root array with registered
+	 * sections,while __pfn_to_section() returns NULL for them.
+	 *
+	 */
+	if (!section)
+		return NULL;
+
 	struct page_ext *page_ext = READ_ONCE(section->page_ext);
 
 	WARN_ON_ONCE(!rcu_read_lock_held());

---
base-commit: c425609d6ac4012c8bbf01ec2e10e801b1923a7b
change-id: 20260616-page_ext-31ef555456fc

Best regards,
--  
Ketan Kishore <ketan.kishore@oss.qualcomm.com>


