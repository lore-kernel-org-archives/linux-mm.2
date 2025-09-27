Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30453CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711708E0006; Fri, 26 Sep 2025 20:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9818E0001; Fri, 26 Sep 2025 20:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625A08E0006; Fri, 26 Sep 2025 20:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5061D8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:45:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5DCF5A625
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:45:46 +0000 (UTC)
X-FDA: 83933187492.25.2AADE53
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5AC3816000E
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:45:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aMWFACeF;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758933945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=cBhzNFA4bXO13OUU8twBPHBM6cu0MPpceqhqii/vGzs=;
	b=tk4tBKFGnkMT8Q5WK3KbZMBJE9Or2DEafJKkcXTeT4Pl5Vw3cXbgnW0Zts7D4TY+PScAof
	Wl+L6IPBsgAFvHkPk1iNiTBHXomoaxtDlgWnXDPCOdm4CurrgMeh7D+QHvHU3dxAMYEksG
	GgVDiiWlo63O7McKpb/bmQSBqURXH0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758933945; a=rsa-sha256;
	cv=none;
	b=6oOl9v5b0paoc8/JYKLeidXwHLza/AtHnQpNUF/wsDb2DJi0819iC2wOsY60HPL1wGj1rF
	bEwfQ68N7noB5a2iNzGrhKujnFQfmURkC5gRXWpMnzY5nE71A6bypX96INk1IypxLNk5x4
	suJKviKr4fxVnjz4MIUhu9tMz8997Yo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aMWFACeF;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62f24b7be4fso4914167a12.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758933943; x=1759538743; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBhzNFA4bXO13OUU8twBPHBM6cu0MPpceqhqii/vGzs=;
        b=aMWFACeFEFQxMMkMGj9/k8R/da7t+ko6CJRLrlw68zIz6z4709KypDKEEcZDzu+WnD
         1JGbS8284zWtc6hnGDgpniCAdDjOX7x0kJjGfyMMIVrokTVLho94J9y5ykwfp4h5mQcm
         t7es8Bn+kJQl+S1wBj/GevbhXCkq8kNHnfM0o1xcjsN2pqsWCTXCK485zS769kpKyG9n
         GQL/Gikeek6A6md6ZpEnRabYm4Ej+uPDPjNeO0ArSCAUPnC4nd19L+MuA1z70/EtDUj1
         Pgk3v4Zks9/bF4msl0BRw2dFVABs2A5fNjKa4R9JAxkWrzLD7WSUkvixVVb1Nfn7jLLK
         dYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758933943; x=1759538743;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cBhzNFA4bXO13OUU8twBPHBM6cu0MPpceqhqii/vGzs=;
        b=iat2e7EYak1f4tR8Ctqx7d+HisZ60gwsdK2sixEVG/5gMesx8zUIlE9iW4ruRmMXuA
         XS4epaTP1eHpVK0+S3wPzw3iSx56dtx2/QtBqbJrjMpkPK2mVrmskubkZ2qS202fL2/b
         0KcAO4zxjLpeNn9PL60ebhbjN/DLjxP0fskiYKnhRrUaSOm+5AvWDUV/DlGjZ+qMze+G
         nTqHiNFx3+YTCmJVUDQzo/x3yDniBCpe29XrNv5tUQWJZG8+y8UgBSzJJS6VXonAuWj+
         E5RSLCzOAVqZyr7vEvkGV1p6aPnv57Rb+ZOEgIJBn3i+FO9elPQHB8r9zHzIuyOHJ9co
         mnNw==
X-Gm-Message-State: AOJu0YxPZNr+J4MsVUmFMC5TdoguTKHLh4bK7hRXRtRtEYDwPnFHTX5w
	m4hRPelB5x9B0bUXKglBSXWLeqqSWGVwpfm1ni5AjLui5QYoEZA2YLKx
X-Gm-Gg: ASbGncvvzrvZuOj+D9CDnf+H8CWYkIUcHmluhEah2973Lx6LPdRzqu/6M2TSniI2ufG
	nqiMrLOzos89l16vPhaq7jmoD6XgboSogPAfQHV85ObSRWVTyl4+7vMihlw2IJWI4EtfqmnLDWQ
	GDKOOk0TBAZCWp5byMrIV1Uqa1F57vkI0JGD01xVeblR473xygg7kEn2TjRc+496BWySNtzqQEt
	kl7fnifNUAwJ30cK9QEXhhaQfz9oEno4/bJ6WjOZ4X18/JSqwNzZ0oWG5ncjF/yUJVz64T8qYZC
	NQDEk1VHMPj5m7ijddgRCBL7BqZOt7ZRejrr6ML/lbz3zdRPb0xuvkPSgXk7v7PccmubMgnJfeg
	KlucaSqtaw5QgJLQzxW0n8Blrgw==
X-Google-Smtp-Source: AGHT+IEc2IqoFQVsXNgRP3nkhTMOHhGSl4o1gZK8MJNnBptaNQs0ygFA4nzdcPnltRnrR+YbM1M1vQ==
X-Received: by 2002:a17:906:f58a:b0:b04:6412:9612 with SMTP id a640c23a62f3a-b34bc876274mr1126293066b.46.1758933943374;
        Fri, 26 Sep 2025 17:45:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3544fcddacsm471592066b.72.2025.09.26.17.45.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Sep 2025 17:45:42 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v4 0/2] mm_slot: fix the usage of mm_slot_entry()
Date: Sat, 27 Sep 2025 00:45:37 +0000
Message-Id: <20250927004539.19308-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: ap5a8w5rx7h63rpm1f8gnf1wykpub1u4
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AC3816000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1758933945-727015
X-HE-Meta: U2FsdGVkX18eBAEkbDx4xLLhrr1tAhUlCuEJ42Rf0NIVNFTGreMUoaLfHlsslT4Q56/VzZl+Ec5ICraKNCgAsShyxevxQ5G/hwPRuOUfwRRu+5d4smDwl70RCiIaosoaQoQm6ZeUZqTAbUe4TQjA7zXOCScacTljYcaPh49BXKIfudw07HnWK1HpY7G1w0NUJ/FNpSSh4kbIAoTEk1lkvlw6tgrtWvzDcGVpneUzFUbPMorqMZNMDrURceFMGeRhBOvuCikzUGZLBCn1DQ+zrxQu/JC9VTWKeZ+s86xzn+MvhDM865C6IYuqqTdrrJ78X19ydu6BRI/hyd5X8nhCwXAGgHK/ftmtvjSgmRknszs2Ipj2gu1CNpmOI6YixtaI2YvgI1lc+ewcmMqKUlX8pkdmO/laDmL/hNjXLkzpClns4lgYnb9Vb2VoRyAiTjPy1+/JB3+elcOOa57V1Bo8eHIbeGWrA6DtflvR14sLSEP2e1oqtx2nD8SX+8VnzNvVBDlgAEmGQb4Cto4weVyXEDuly/RE5xJn0yUgo+x3MzoM/mynvO9hMdN9k9rXaPGO/7X+ygMYP4DbPIzupt0In9bc/JrZKiy/5+mKOn6bMqeE39SAkmTsfSeyK3CNvfzDLgbzA56SYNi3jpuP3V6BE/hgHYyjnf4AjB/6Bu4SfGWmki5pP1j8QGWf7OdUzXv5JwlkeUg130tMzIELCo55g2E+Zl86WdM5OCFVbuO2KY8ItclEU8WVYai08ZuIkBzPRzIiDFkyIRFOaJ+e+ibyiJ5PiYA1duD+s86Vjbunm3DAzV4sGb/h5w4xBED74NhJdC16z5GuNutJLZFoF+pzJosSEfESw2SL2wfnwCOnS6bv9irZ4sWGCavy041JfDSyqnD/uPk6WaM40+eT4fv2Kk9KKX9ShHVTmGYGObXQvvfwTpxxJbET/mNVylLC7dhibP93+LNyZiCL3iIdjox
 FNUbErOO
 jaPIBH7AMklnXvMn1+90uj3sE7o62eq+eR8qIqa0bWlXfz9B7EdkfxpGFzGqYtdR1bByCCXMB7vHbteuzoZhdUQYb0x6aTCkVJKbb5MwsPJR570NMndwo7ISYQtlHTBDALlE/I9/GOfljy2vjdVNHjkgTIxzgMn3jwkA51mKSeHgtPGVLtZMaibHppbIxtJCxur5K005jx45dH8KdczBktUnibw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The usage of mm_slot_entry() in ksm/khugepaged is not correct. In case
mm_slot_lookup() return a NULL slot, mm_slot_entry() should not be called.

To fix this:

Patch 1: check slot before continue in ksm.c
Patch 2: remove the definition of khugepaged_mm_slot

v4:
  * adjust change log
  * use invert style in patch 1
  * rename slab to "mm_slot"

v3:
  fix a pf because of slot change
  fix uninitialized mm_slot

v2:
  fix the error in code instead guard by compiler

V1:
  add a BUILD_BUG_ON_MSG() to make sure slot is the first element

[1]: https://lkml.kernel.org/r/20250914000026.17986-1-richard.weiyang@gmail.com
[2]: https://lkml.kernel.org/r/20250919071244.17020-1-richard.weiyang@gmail.com
[3]: https://lkml.kernel.org/r/20250924004854.29889-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/ksm: don't call mm_slot_entry() when the slot is NULL
  mm/khugepaged: remove definition of struct khugepaged_mm_slot

 mm/khugepaged.c | 55 ++++++++++++++++---------------------------------
 mm/ksm.c        | 23 ++++++++++++---------
 2 files changed, 31 insertions(+), 47 deletions(-)

-- 
2.34.1


