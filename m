Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66358CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 23:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FDE78E0006; Wed, 10 Sep 2025 19:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEAC8E0001; Wed, 10 Sep 2025 19:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB398E0006; Wed, 10 Sep 2025 19:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8B48E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:57:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28FF813AAB2
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:57:41 +0000 (UTC)
X-FDA: 83875005522.14.FDC2D71
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80A92180002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:57:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IYLAyL5N;
	spf=pass (imf16.hostedemail.com: domain of 3cRDCaAgKCOYSQVaMgPWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kinseyho.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3cRDCaAgKCOYSQVaMgPWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kinseyho.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757548659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U3W9KmAhRtbP+yDFjRzq6OkAwTzphYT+gRDr5EFEvmo=;
	b=Y7Rejoq+SSkXAYLrlJ9LT8sQYKFZHQ4yOpk63CQ5/jKEGZOsN6U8FLzvp8z9RyM0+cwgih
	51+hnUZg7AYIYcENwTKgECQd5TVdE3wR31VMv61kbQeRNwLxEYJ80WGqeKv2V+w2uIficn
	BoayYDRwYYOo65CA+R9uEifFD6Y5kvE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IYLAyL5N;
	spf=pass (imf16.hostedemail.com: domain of 3cRDCaAgKCOYSQVaMgPWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kinseyho.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3cRDCaAgKCOYSQVaMgPWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kinseyho.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757548659; a=rsa-sha256;
	cv=none;
	b=6PYenaZ6ma/Et9i7/iMfk/+E7+nNDYHxbP/OtGmTlymr2RLHXnNNVrNkYL7aN9AbREKL8Y
	Ho8DG5TqPxW6uHv3C1LhSp1y5qIzJ6+47/1ySLEzYdoii+hzM1OD22HUgLDCck1QLpKsSy
	1z6Ws0vGsJkxQBmsnUapiaIHiSVB2JM=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24c9304b7bcso1064585ad.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757548658; x=1758153458; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U3W9KmAhRtbP+yDFjRzq6OkAwTzphYT+gRDr5EFEvmo=;
        b=IYLAyL5N3IGlDkgcxAx9mZk8mR8Bz2lZndw0flZnnwHkyygjeqAJ4mfpZKL29UDcDB
         niVWXt54VCC+0iq9Y0Dnj3VQOiEaymlqfx0hOhq8btgr0A+v+SqJXVXXKqkeY4wRij5Z
         jjFavX7cYHecbKFxHbwjOR0DsldwQhwWCnNpX7T3yX8ZmlIib4PsgZOkNZKTYsJhMcTD
         87fIiDP7mAA5R3lthvl9Xnfpho5+CdWrUanJhtFKfkYTPYENyyzsESaN+hIC3HQwYJKi
         2D3Y2CMYrbpCbLVe/BTss4jRjTq+ktjKBWAKGA5S9fmz8NCXoZ30uctmLfByIcJUWciu
         EwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757548658; x=1758153458;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U3W9KmAhRtbP+yDFjRzq6OkAwTzphYT+gRDr5EFEvmo=;
        b=eOLdosEWA0l0QH7xe+SX62xYqlHde1eS8rEyHvgvDWu/yA7JkdZUi+vaWGytduEggE
         LPk8c/ZmYUt9Hr1n7R16MXTFxYfF16rGNULGbtEcfKeAHWBQslMKQB5qL7y8ajryRwy+
         1zK4r409aVEQJXzgdPXpX58BOvwldqmIlgQ6+wfQSpVOmYEx31syMzYquX0zGcnH29D9
         lHoP8wHTxjTgVHgN4gtnIid92XWzYBaqoWdniVDETl7Sk6I6giPPsWqFc/bn9fWUEJRp
         7y49Ll/54mCGO5AqvgqiE+DvGyDj4nL1zLaicGn516fF040ppY7TsYGIE8HPtVHbCjfe
         c1Rg==
X-Gm-Message-State: AOJu0YxeArx1g2MDt6JaPB+cMdNcHPHlgP1dY+vbc24CvbecsYuvwA96
	0mL5T7l+rk37ikU6yPMMyUVAAnJ27TjZssmtiyrxu0SP3BMLPbD6V3EJtmDaQ/VC2DmCWzvsrCP
	sqLTH0yUZhlGW9uqz0qyF6GvHidWJa+71wkWeQccpBld4RpJtyRoA09r2TRmomwXwPceYkWk89d
	o2XNz4/gQ0ZuI6A//dPjv233cThjz8OC7n576sg1AJaw==
X-Google-Smtp-Source: AGHT+IFUIKZ6YAAu0ecY4R9EKyV2/HbtOzWNpGLUTDE+qaL3FL5lUcCQHJs46ff3j8+VKUmaZpk3coRYbtSDEw==
X-Received: from plyw24.prod.google.com ([2002:a17:902:d718:b0:253:4280:9f31])
 (user=kinseyho job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d48c:b0:250:5ff5:3f4b with SMTP id d9443c01a7336-2516fdc77a2mr262461415ad.15.1757548657920;
 Wed, 10 Sep 2025 16:57:37 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:51:19 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250910235121.2544928-1-kinseyho@google.com>
Subject: [RFC PATCH v2 0/2] mm: multi-gen LRU scanning for page promotion
From: Kinsey Ho <kinseyho@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net, 
	hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com, 
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com, 
	rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, 
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com, lorenzo.stoakes@oracle.com, 
	axelrasmussen@google.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 80A92180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: udwmtg94cx4qijxnhmm93ow41x8ybeeq
X-HE-Tag: 1757548659-749156
X-HE-Meta: U2FsdGVkX1/YcwvrB3uXRliHseln4GvkvTv6EschfaqJkq7dKrwAPOiga67tqYRgxAv4Yo/aqbiYbtoD3eHqbAJqiXLPHbtc3kpjSVsoLyDSEd8Miv8vPZWSA4AApDLeWlVfosnkl4mxFucydccjh2NtgkneH1+na4s4LO+TlTB48873tlqMEnYCxMU2PbumnVlv5vtlHYE1EOXfOux0CXn4A9uqd0dGGyt8V95aYufNcvpQY40wAkAV2M3Oe0qrOMTv85gJI1oQWc44b0FH3LXerdetlvsIPvmVfk3yx/Y0GxGUTO/X5ZXh8tA3BMKg22ZR6dv9hLsqGpsFFEE5UUb+C2JuO6UE6IrTyVRoFuwEknL931NJ9Je9YlTFzimyNLXBsvS3GI60mJYk69csw490GdkQEE34Mxl9ImkuqmR4cUb7ohGpL026q/GwEWdfMS2LAU748vS4wXdqq4xpIr5SveoyyKuSsrwMmn4Q3YWgNpHit8Bt0g1omoszWXdnIPHmEH2p3MQzgPhaGaZZETqjN2yuR+eUT2kgX28CpGqt+l3ZvZGJ251ayzKszp2sjyxbI/EVbRnZsh7AH8E+nz4FhBBNXMQPRywKIovlTkHd37hfi/E69OLtWrAj2AqiwQxsRZ+/itLcSlFKGGfY0TdvBa5vToSriZ3Sj5dtVzNhF6S6QDhbsVjbgLlQvoEV7resvNoAyHwZbNmLUlSYQ63fh6pZsIazQu3a9svm2BEx/EE0ldX2nCKl7TSHEBhHwKRSlI/y5DvlHldp53pSqI01VB14xTNtSa8RYakiu0307ZqiThJuTmWJ/Ev+R4i+KP2F+PkL+Kg8fbbh5VisGD1P0sUN8GtLlG25alZGNKCGjmS4IjSL9RUeTQOczePCQW2xTIaVoxnjqjZ281eV2ApUdeULtnhqp2eWNc++autb2DcVhQPV8BzTWWLNSqV/ljjSRwZGrWkaiEzZgrU
 6bw5qNTK
 nHiv+c/CEOWrFMiM1pX6rsNOEAA+uwdQnYETZZ3ZS/HEUm42hYN5gl/dtiTl3rX5Lr+/OCFhODGZUhFLwwCH/G9AILYTZz/O96gUFal2b8bfJePjQaF8/BD3UrbmWnz82WaJLNHbXsCLEOvfQPaSTUGKxNQKnumVNwLhAc4KWhd/GkwqwarH5GeBpja/nqRgyZSddGLZnNfbpnWaZZ3UBOfdig2VnKjwCGmKg+0aHXQEohxu9pWSEhHrOjY2gcRFDpnlrMP6aZVqSmVo+667Z1iWtQXVovdKBgYL0LtI7DG+lbQkVReHIyA4fq4hxNM3Yua14wNQpgQUBvwvp3k1YI1zI967fL8TSC/qJjAJmNvBI/GVUKelixWXmTejaeNK+/8HH6BYvC/oASpBgyI/tKsx+CM5DMdasryVAtIhbUXzzo1T1VSEq44rTlvHlxA7iiau1iVdibrGDOgX68a4wMKftIqNORZNen4ql+xa+nEbhXZzz8NHqNJCK/bjkOn+K9OVdlL+Nc1OBxufF8kYAMrIP+UDoJTBTSjaoMb2SBcLefmnlDUTgF8nHDFuFVpXJrOL0gz1RHvBD86GBkHehfpnEMVr7DLhpgob2DmRd2uQu0NRVqoUl5CNOPlyR40a1PUainNDoYF5KtCPMR+8AQNaDSCPXmDuG8zrFXGkRKZN87gs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces a software-based approach to identifying
hot pages for promotion in tiered memory systems, particularly those
leveraging CXL-attached memory, by utilizing the Multi-Generational
LRU (MGLRU) framework. This method is designed to complement
hardware-based hotness detection mechanisms like Intel PMU sampling, AMD
IBS, or dedicated CXL memory monitoring units, providing a more
comprehensive view of page access patterns, similar to kmmscand [1].

We propose to utilize MGLRU's existing infrastructure to provide hot
page information. A key benefit here is the reuse of the MGLRU page
table walk code, thus avoiding the overhead and duplication of effort
involved in implementing a separate page table scanning mechanism. The
working set reporting proposal [2] also reuses MGLRU's infrastructure,
but focuses on cold page detection. It provides its own aging daemon,
which could additionally provide hot page information by integrating
this proof-of-concept.

This series is based on and relies on [3] as the aggregation and
promotion engine to implement the promotion policies. This is still in
the RFC stage as a proof-of-concept and requires more rigorous testing.

---
v2: Fixed a correctness issue during page table walk, where, on resume,
one page found with the access-bit set was incorrectly not added to the
pghot data structure provided by [3].

v1: https://lore.kernel.org/linux-mm/20250324220301.1273038-1-kinseyho@google.com/
---

[1] [RFC PATCH V3 00/17] mm: slowtier page promotion based on PTE A bit
https://lore.kernel.org/linux-mm/20250814153307.1553061-1-raghavendra.kt@amd.com/

[2] [PATCH v4 0/9] mm: workingset reporting
https://lore.kernel.org/linux-mm/20241127025728.3689245-1-yuanchu@google.com/

[3] [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/

Kinsey Ho (2):
  mm: mglru: generalize page table walk
  mm: klruscand: use mglru scanning for page promotion

 include/linux/mmzone.h |   5 ++
 mm/Kconfig             |   8 ++
 mm/Makefile            |   1 +
 mm/internal.h          |   4 +
 mm/klruscand.c         | 118 +++++++++++++++++++++++++++
 mm/vmscan.c            | 181 +++++++++++++++++++++++++++++++----------
 6 files changed, 272 insertions(+), 45 deletions(-)
 create mode 100644 mm/klruscand.c

-- 
2.51.0.384.g4c02a37b29-goog


