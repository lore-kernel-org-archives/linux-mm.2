Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE0DD4336A
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFD76B0005; Fri, 12 Dec 2025 04:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB04B6B0006; Fri, 12 Dec 2025 04:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E526B0007; Fri, 12 Dec 2025 04:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A731B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:13:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DCAD13B194
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:13:55 +0000 (UTC)
X-FDA: 84210256830.27.FFFBF92
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CE5B100013
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:13:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="uKg/GSQK";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765530833; a=rsa-sha256;
	cv=none;
	b=B8byFhUNk2vol0+ImzYODZE3ZuxmVuyRDgEX3WBC54QJKlI0z8sCxjV3xKNs+DVrM8wNlw
	sXM+XdDxQawHq381mlKF++/31SSlWdJiiyNHOR5RQJDFBLXtm0S/QMR/hGfJrXDdUoB3nk
	RV4yhHRYkr3MRprp5GYtgTtUoEjNxkk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="uKg/GSQK";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765530833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=za3Z6nCogcC2rSrqJPImaYLaC5FD9fqlNIQmXXHpQIY=;
	b=yIC2gRvdaQ6QjxQmM02FpyOzJ7lkbvv/o9PLqCwPKbVAPm44cp59CeGGsN7g0yht+S2lrF
	cf/0uFGubeFw8fjwZrYMvDXSbzBLp1EVGYj//KOBmNdpJLxvqz8ssxKeFTTTSlMA08VdjD
	/QJdLd2lKYCnnd24n5RK7/M549cRTB8=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC90N7q144497
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=za3Z6nCogcC2rSrqJPImaYLaC5
	FD9fqlNIQmXXHpQIY=; b=uKg/GSQKP65HHIXIU/0QSpgmKz0ZJ4mRqkKK0wXo5X
	4p31jMkn0OhTgbSuRyvk+bMLxQmI/TdY8r9vZfeUc2AlUqm+gfU3otqXmISQCjOu
	ydBvK32hqIcxPh139Zy+AXkgKY9qjEtyEaWFwmHClh4bWfpZDlZQ4YYtXF++MeHu
	02LCDVqak3NcTydE2pt3knXB7DVFhmVf7oraRiG5vDoI44eQG2VLZREASUW46fXo
	j9dZReDVYy2mdV13vlmgY+55fRCWQzDz0KmEpPCZY4v4BfbvLaXjtxH9sZ1/DhsZ
	yUq+XbpvKtvgrWAWl7JMk8Pbl0wG5OmkUqJEcj2EukrQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4b07h2j11d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:13:50 -0500 (EST)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29f29ae883bso3841125ad.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:13:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765530830; x=1766135630;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=za3Z6nCogcC2rSrqJPImaYLaC5FD9fqlNIQmXXHpQIY=;
        b=gu1TbXQxB4zV/56aaZvf4encZ2zZjJRzsCHsuCE09/5iYTydRYcBLF3Y5daZyiaZas
         tpUf3e6T/mQMivMNRvavJoo2O31YLzMUsI9VdgdQIWUpG6PR1hgCqaO0YRmL5uhX9YfU
         sJbOx+rwWsFNh3YOXscuUFZwrwuotRTlR1Flc+Knm22cg49nADzcTKkRGVx8XqgZBh2v
         fsOhcZmaS8gZ+vXCpzJO9pgofCLYYVZ4FaxJZj0dvnkIa35K8XW5Eu1RMRpHoKccgVNZ
         K9+XAabIZow/bDw/bhzxF9NBwM/87TJwsVUIbtlmDwySI8ErdOckjpMdcLUm1vPIh5so
         yLXA==
X-Forwarded-Encrypted: i=1; AJvYcCVExDmMiV4xgG8jT86x3UF0joaqHpHLZ+H2WTQk1iJH+Sva1X213uQVO0cXPSnuBw44aqlWRKZzHA==@kvack.org
X-Gm-Message-State: AOJu0Yzo0Z+i1YnTiCEhE891NxhTslS7CWonE1eRWpNwruKsVgiLXmfa
	Yga9ZyPV+KfTncaG4n2LtzWIPkuWlnPqz7WvHS/DR3mmDPP/QEZCPHFNjYEno0PYe+2HeVgfPtt
	Tyf8bVmbaeffhOi9m2ASqRxTAD/mTwEyFR/vVacdeFUMmK5Mre2cnZvu+
X-Gm-Gg: AY/fxX5Vh0cG2SaNWe0NO8yYIjrJM8x8UjrNxQ/R/omzcVj5u5Ig+YxZU0krAi/ZDkL
	3AvUwqpVG2qS69QWX8aJFk9I+cT0mYHmph9Ry1OwNP7WxURYSjW4YgcZLb6iYiHg4AK+xOh437D
	sK43xHirEuXoheAXFDkAeg0GQgzTw4K8BwikIWn7hJTke2YAiuSPUPUuAjbjJAfW+O3b+vEsFBa
	rSTNa9nWm1g+lPeDyUKblZHfInEP0lLhwJ/qmgOXHPtfslqHvibv+McZUudsHo3TgyGNQhZmTUo
	cfgrlrmq9mBAjyBTVcL2hCrjBWjtzwj3Qi4Ts9HOziIg1eXzZV5NB3u6WZmo/3e4iOIdMo5MCET
	4UWeoxlgMuvj4jQpi0fwC/JjU0MY8HolMGpGLBDeLfi9nxubz1eHdiojU
X-Received: by 2002:a17:902:da90:b0:298:68e:4057 with SMTP id d9443c01a7336-29f26f02492mr12993335ad.59.1765530830001;
        Fri, 12 Dec 2025 01:13:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6sKbsPSYsaMyhULdwVqz1JoQu+BSE8km39oGocnv1+kBEsKkLBQeMpkHcDjKtUuydOVQxbw==
X-Received: by 2002:a17:902:da90:b0:298:68e:4057 with SMTP id d9443c01a7336-29f26f02492mr12993135ad.59.1765530829488;
        Fri, 12 Dec 2025 01:13:49 -0800 (PST)
Received: from [127.0.1.1] (p99250-ipoefx.ipoe.ocn.ne.jp. [153.246.134.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016e57sm48497255ad.63.2025.12.12.01.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 01:13:49 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/2] x86, mm: minor tlb_flush tracepoint adjustments
Date: Fri, 12 Dec 2025 04:08:06 -0500
Message-Id: <20251212-tlb-trace-fix-v2-0-d322e0ad9b69@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHbbO2kC/3WMQQ6CMBAAv0L27JrSUARP/sNwoO1WNkEwbWk0p
 H+3cvc4k8zsEMgzBbhWO3hKHHhdCshTBWYalwch28IghVRCyQ7jrDH60RA6fiPpXrfOXLSWLZT
 m5ano43cfCk8c4uo/xz7VP/vvlGoUKKlvjOpco4S9mXXenprHM9kNhpzzFzEpeemtAAAA
X-Change-ID: 20250528-tlb-trace-fix-eb9b6fc7bb26
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        x86@kernel.org, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765530499; l=788;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RQs+Cr//EkA08UpbUBYAdwgnHf9vZ+MF64Ay7/KhotQ=;
 b=HNx9jzUDiAP5JSX3noLQxFsehtAhFIOg4dMKrEKthREshjiRp5BImwVYJwMexc6sxNAWzyZPY
 sa/Ub59Y1T7D4+rjSgEPJvT53cMT2cdm+oFqczWFoehSiGm+14I70uS
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: 9OXOQHFI3kLgUIKTZaC899P0VqicoIkM
X-Authority-Analysis: v=2.4 cv=Vd/6/Vp9 c=1 sm=1 tr=0 ts=693bdcce cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=gC7H+NTNV8TiHuUi9Bl0tg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=D63WkmDjCBH-idvp9jYA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: 9OXOQHFI3kLgUIKTZaC899P0VqicoIkM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA2OSBTYWx0ZWRfX33SuwuLkHJP8
 lMg7Yq9D3uW1IoZt40ni0/+o6tCDf4ygnNb5QMNPi9tBWOqIrNQktHLvlZj1zfxKI1gMak3QZpH
 wnLCYUIdC4uRv9oS9LBOS5xvNgggvJpkBZYAwtamBkQ9qmlJDrJ/OK6U6yZBm1AijAm0NKT/02R
 Ifj1ReuNmS2EbQ7ApwdGReVsVA1LLxUluL+PDz/V/0c1iqe74oDdaxDRy4yIygEUZFBypmfTumU
 nVsmc0SE3K+F5w51JImBalqbn0d6JZvOFXZ1ztPmZG8S+IVN5xLmIBUrlk5dgxAwOcuxBF2pRAQ
 N4GXqSzg068vmYSQtgD2abJeD5jd4A5+w6OaWfZ6+UqGGsbYkp1HN9XEfYrXSfjBVbzGn7r6Ouu
 q9ehlK3mV2+9Tc6D17e3SrIz8iTBJw==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11639
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 bulkscore=10 priorityscore=1501 adultscore=0
 lowpriorityscore=10 phishscore=0 malwarescore=0 clxscore=1011 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512120069
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CE5B100013
X-Stat-Signature: bfptdud3hwkgmcczhfcped9dhs8j5jq6
X-HE-Tag: 1765530832-344541
X-HE-Meta: U2FsdGVkX185qSyKC6nejbGa25wm4h7nwd88ndPs1ZR3Oi35psZSXCItIQWu8opCW5eowP1XqBmkUzRtwrmmYxWUtecawyig9r2H9Yts5MzTxaKAqYvHgsZ9OBqCpKAg7CKzX1wsQWQdHWWpfuGKz5xDOdbuCGPsfsw6XgOuHRz8lQfcvjqBgn4JMIg4bILUfNQdIFWkY4yGMq9VnZNAVu80mGCSxkRCDRvVdJGa6X6kBovrf9yhyAnn4VYYqBKtHrJXOXhH7TPZQzzQ5O/ENodPXXd/v7K3TNRHQTDMmtymeHh5Iui0TwkPJ9BuPfFztrBayRcrlFaNh2YjsBnIYJKbJi5zLhpUwrc+OlE850DRLQCOxMuw4leIGG4tg/Jg+XkvMmKqLeiTh3ECwnBxNczCUsG61hh+dBHxfX8KVKDCgxHk2QQaF+hfoRNT5TybtJlw8WTwYdd7/1MEV1tx+/4fhFw4zTxEmL/f5n/pxaiMyvBTXB0Ir4mzQL52mVRebZ1sYyFKzNMrCmChWUipqEBv4wEUkCY0t6BKngF/gaucZBV6NmIp43TeRCY6mZnCXcZNRU6AAodpU8OB0JDvjCI2YXSjRKt476PtgRNx/ZNbkQbsAg9ws0mDhnH62cOFXFS5/DrDjXXHKL5FQqRe0ObTfY8HTLOC1GHaf3+8CgYPJLIzaDBKdud47j0KIhNz5EXDTKIjFY/jnCnBXin2li01hGuwiggBC38IUf74Fuz0DGh/qy2tzgc3MKln5Mr3mPCgOGPhC5sbBXM5Cwap9984rW6zRO9r9eUmEW8sR+4goTL9T3W6AhFo1pnSjjed06LVrxUYNXuMGHE1aiYDmNFplshbznCgZsHasA+2/crAn4Dgt9A5pvbccSGc57SEn7poUjh8wJR2SIdCMGEnRFeHE57UUHFEqAO3q3P4rq09829MQtpcZJGo+bHMDnJ4jkvS4uOdn2JLor4O+7+
 d3/FMAYn
 I3ifWfQL8Dd4Y7njd4gCt/FV0U55i8T1XOSAY92y1B7I4l9xXxgHn3T5BzNaZgE2gMTCSPvwhTpAtCfWOieAuHlfrDgUtiX5oM5hElTAPfLFstmXfu8WL8g0/4ynzRsEf7ctGatle0XA2rYMIcT6EbTBMnd2cLdT24OI7X57Ec5FfEG1HmZB/0Wi6KgVMcQ9RJRRCHJmDCX94aGxfTXOD46e2McQzqnDm3657dRU7NrEeaC6SOdGht/eiyGVfK58XqbplRdnOFwwNQYPGP1+ChjieK7Fc1vWJODMgzpq8mRHKrPc8Lz7UJiFYzlEQKewlKpchma5sb953jAdc7p9uHnXszp6MZtevA96GNb3JIfxpLnpMoYjlpyWaSW5fB6W1tyGCigF0I2tYYeJ+9gTUAr/dF6XLZAg7NWgPL4t3WJc3g+GfcrNv4ERnsU93aBhV9zBC1ij5zNTU4IRMI1+sX2MKW+nrFrhUBeqM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One minor fix and one minor cleanup related to the tlb_flush tracepoint.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
Changes in v2:
- Propagated tags (thanks David, Rik, Steven!)
- Added MMU Gather maintainers to recipients
- Rebased on master
- Link to v1: https://lore.kernel.org/r/20250528-tlb-trace-fix-v1-0-2e94c58f450d@columbia.edu

---
Tal Zussman (2):
      x86/tlb/trace: Export the TLB_REMOTE_WRONG_CPU enum
      mm: Remove tlb_flush_reason::NR_TLB_FLUSH_REASONS

 include/linux/mm_types.h   | 1 -
 include/trace/events/tlb.h | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)
---
base-commit: d358e5254674b70f34c847715ca509e46eb81e6f
change-id: 20250528-tlb-trace-fix-eb9b6fc7bb26

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


