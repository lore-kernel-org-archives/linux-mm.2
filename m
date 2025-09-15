Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23479CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 21:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E09E8E0005; Mon, 15 Sep 2025 17:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8088E0001; Mon, 15 Sep 2025 17:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F52E8E0005; Mon, 15 Sep 2025 17:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A08D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:28:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB58E14079C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:02 +0000 (UTC)
X-FDA: 83892772404.26.6D902CD
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D674140010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1kNwehBs;
	spf=pass (imf09.hostedemail.com: domain of 334TIaAYKCFgIKH4D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=334TIaAYKCFgIKH4D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757971681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2QKU8X2OLNyvmPPoKyCMxJy3zsyaNlhag0ku2tl+L+w=;
	b=K16OT5MDu9dS2FHphg+D+TZRDZET34Xy3e7RG4adNsr9JoWJmLzXU+I6E+pc6/d/noSb5d
	htkJACzsOrMVtNC2u+JImCzr8S8CVYrgFNgyxvug/rhueshX1UcknrZtMwA78VXaUVL0HZ
	046C/KazAAC1HhDCI7sqUNVbHyTTUns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757971681; a=rsa-sha256;
	cv=none;
	b=ItxbLP8a1yyp9IkxiAQzIRCGYnDWTqYHCCRCuLqdMrCbcaRsuutqs3cM3xsfgR0mMIDMIb
	C5nmKjlwRqKGVvJoI8qK+N2/8rAqGdLgxAsXU5u+Ya/64S8u5vHVSj69XQAfMD7hlmJAv3
	56Ke1BinXgafPvAJGj6gfroIFk2L8qw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1kNwehBs;
	spf=pass (imf09.hostedemail.com: domain of 334TIaAYKCFgIKH4D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=334TIaAYKCFgIKH4D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-263d67851edso39588135ad.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757971680; x=1758576480; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2QKU8X2OLNyvmPPoKyCMxJy3zsyaNlhag0ku2tl+L+w=;
        b=1kNwehBsO3FOEzN0Lo8IzuITIJZo2+lGQtcyrRLkJ+6wn0Gvqpf+EvoYbi2Q81BgJj
         TM5Fij6zee6Q8kRG4JoqdIMW7AtLGqszVV23++D3DAv4w/AbRn8evDUC/x9Rc/QUWQvf
         RM1iTu/ZQ+TQfVRlXysf4oq8/kdbfNnLcAwrR4WhseCXKu+j8zceSw+fCFzG95gitAy4
         AlHV7pQh7cB1e1Bcar2rOforZ9IBuUZ4P24kAAeiPv51q4UsfJhcncawpsuPap7uHobJ
         PpcezhRtpr4egq8t8B9kfapC/d20uO3/IJyp011UmlqTISSFOV3bdYUYGL1r/nfQnON1
         AUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757971680; x=1758576480;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2QKU8X2OLNyvmPPoKyCMxJy3zsyaNlhag0ku2tl+L+w=;
        b=W2IHHSLYlkJPg9MdUsVUDrDclw11Ma/di6OY9rZqlzSX39VDbuihKABMr5xJ/oF/HC
         KNQo/tlLWfYtml0tZAtkwDvRWl28J0I83xbdO/x4GgSdIPqt0DOYdsPnKXe1mgO3Lr0U
         8OxqWBAwcG+3lcl2jgZZ/X4Ul+fk2Xevc/1En2DAPDeJyWoVJhsIp6hic/hA4aGeIeV7
         xvLAMhp1YrQm78A7Fzg1QJAMDenrqsLBBOdZAU2ympok+h/QEvmiTOQqBTmZLlV1blJG
         OEpRgen1c1pQBjwxQ1/EOekPZ9j+t0miFWoWFobpFG4zTNOQUuP6hG4lWe/weNaZbg4I
         72yg==
X-Forwarded-Encrypted: i=1; AJvYcCWEIaQwdcDC5R85N0l99rBSTVgG/Wfd17A7PeGt6TSz/ttDYRQFfkV079ly6nPWI+4qhZvwFDXoIg==@kvack.org
X-Gm-Message-State: AOJu0Yxv7iHiTA998+PDW2YxNCCV7pcbi5xBEUXxMPrByCEyJ2dK/Bpi
	DO+DQMjkPtKS3Kqdol4O4RqXAx5CsYbi93cVPgE4NIeQtab53pmueh05HDByWFLAPtebDVOvoEO
	vaFXVZw==
X-Google-Smtp-Source: AGHT+IHkoD/lEawRNElFhxNEl/WOJq4C0zSRWelKBAr/ygp+ovcGulyXYz087TxgFrqbeQksPgPmGrTBe8U=
X-Received: from plbnb15.prod.google.com ([2002:a17:903:15cf:b0:24c:af07:f077])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ecf:b0:24f:5447:2197
 with SMTP id d9443c01a7336-25d2587d2c9mr148167205ad.14.1757971679741; Mon, 15
 Sep 2025 14:27:59 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:27:53 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915212756.3998938-1-surenb@google.com>
Subject: [PATCH v2 0/3] Minor fixes for memory allocation profiling
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ir8h3oa81i4rd3be7wrhy3g46pkzqnzm
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D674140010
X-Rspamd-Server: rspam10
X-HE-Tag: 1757971680-44371
X-HE-Meta: U2FsdGVkX18pHOIDkZWre0/m3YmgLaKzFQZVSLFYQje6ZBTmzdV8MHGi3Oz6Cp45pQWzaoza0/CPoaC3HCJK/rWKFc+rV7FY5QGIKpu1uP+2MikJlYbFOUSJ0nmY5ZAVMDP3ua6bYk0+TRBw6nhpI/3YAdmM6bwIFF7KOB+KAa+3FbnUFedv2/OoBIhkQ5CgfYTNhrq2NYICVn1Dojor7dI4BfTR8NoETP8bDoNdX8dTMokFN7oOkQ/6AR7HrS4OQsbotcftrhQV5d5Q2JvJdADKderSKzEa2lbJVfMc4PMdOyAjvrA6/YASD3lM+nGf9duqW+vRZjISGbZ+UadvwzcduybPDJGSEvZbAtxwto+cXN2jEyjq46PVcd7MhhLCegKJxmnsf0QfdqKoI/8SMEUtjJnPFHLCBj0VIH2YefOCTLKj5XYJ6O67h18j/3YwiGe6orwCbO+nR47SPJ0XYaZy9m9Wr4T0w6hEpsDZaRDkEGNnjcqcLVN4SM1RQfdZJDUmCJgigvuT4Z1f891/1OGwU7I247KOWL8Hv2al1N/gx3Tdpf7B3hCIpzEojKBK4ug07qBwauYQDFsHSzcyclx0iZAM0zKpIdk3eKrkdw7hzMEGmtIFG3nzzCkjG6BcN3dBL4vOUINXcmwYeuApQ6ei1ZBbfKEIBtXkvfFdksB60KQ469I1VOtuPZNWG2wmcr1jJ1TJP+EAGuLqmYEnO/Xejdz4JuFGPQi07YG61f3xCd5l/rHOvXC2X7ZRVMUXPOGXWjvIbv3TFLr44hTlsv9Xsq+L2CpWTUw4TaimCtqrC6FjNebpst1Qvz9BVgZ8H6A9/UyJtHfiF1R8D1+O0xlNPVV7RrqEg0KyI4C1rynOXdwINDmqilH+JXEQc4JJ5jIVAruTIFZvzqQ5UwOtlhb17lc2QVFSyf9NqSCztgW7PVQAZHUYDk3Mztz/gvtiePQh/86IL2J6hJqFZJa
 veysFFl4
 rr+dbv9PGUwuIrejXtPxu9FgX9uVH3qHDM9Vngw2aGUEQSo6FkPP71hC8D8UIO4/i8Nns2ae8a3MS9Ip8JK/HDtujkfSKDWaAXS8STL1DuayxgcTWDIbIl8OEUaVtKzp/NYEhlpk/FWPhWsti1N2rvhBjYPZgerBlQL0eXnsFMO4JvKV2JlXELBhpdj3g8F07kH6NxXR8umzHRfYjsJWQ7ipwNFWgfKPCoNZ4qMp/08oBuQ7wuhADNF+Fjg4gbS3H605aSvRmFTqW+B1y/wRGYzAY4oJKisVYhQ3q09kOxXRy20KeOo+id3jNSIlfe8I9auGpuXbMf7xPG/ti6JuOCMnXnM+GXnRhWPu0T6cMyUInzN5mjdS5rxbUeODJ5h0XdWMzRm9g/wMx7bdzF+pCcYd9vQ9O3g0Ir0+7FQxeLu3AoyxNtFFfe6L5e/G1+0v4uCtfE7PJ4mFyMsNPoR+bLKbo2MNcSxnH5HDJebRtPsBSjshFtRDSLmAFNtxB98Ku4CyynF4RGZRWdjkCoA1Z8Zk4TcHMOIeAbIbMiQ1G7zjWGbkGLe58Pj3S6ZWkhNrkshaIwLIQHaqHjE0gTxJxZJcSvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Over the last couple months I gathered a few reports of minor issues
in memory allocation profiling which are addressed in this patchset.

Patchset is based on mm-new after reverting previous version.

Changes since v1 [1]:
- Use release_pages() in free_mod_tags_mem() in [1/3], per Usama Arif
- Add comment for proc_mem_profiling_handler() in [2/3], per Usama Arif
- Add Acked-by, per Shakeel Butt and Usama Arif
- Fixed a typo in [1/3] changelog

[1] https://lore.kernel.org/all/20250909233409.1013367-1-surenb@google.com/

Suren Baghdasaryan (3):
  alloc_tag: use release_pages() in the cleanup path
  alloc_tag: prevent enabling memory profiling if it was shut down
  alloc_tag: avoid warnings when freeing non-compound "tail" pages

 lib/alloc_tag.c | 26 ++++++++++++++++++++------
 mm/page_alloc.c |  9 ++++++++-
 2 files changed, 28 insertions(+), 7 deletions(-)

-- 
2.51.0.384.g4c02a37b29-goog


