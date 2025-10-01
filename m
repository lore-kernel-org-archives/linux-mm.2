Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A2ECCA471
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7AE8E0002; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6617C8E0007; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576C58E0002; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8798E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A201B85D15
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:53 +0000 (UTC)
X-FDA: 83950527906.08.345E03C
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBCFDA0013
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L8o3qpnq;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uoJH/lcolEp8wY4uBr8sDvnPy6/VHLzLkYAlVtJGuRo=;
	b=l8NfiYGx96sJIghEQTy00lVzNqkq/ndt/Njd8RS9Dr6kLlJ6qFQ60aB5zQQInthNtd11mZ
	zwyM0ge7ehGUVt7JS9/pKH6PebaSKfHqgiUoT8fDSjIDaFx/z+RzWS/W7Yh65Bh1ohdcSd
	aT4BZtIlmhUU9g4+F36FNB5UTfqqcHk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L8o3qpnq;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346812; a=rsa-sha256;
	cv=none;
	b=E+3jtYA/zq08JNj6Xp2GNQs6vRkpO2juVTkY/m0hWA8VgPiMrn5fFYYiSWe3kq52aIK+aa
	ZIsRONYG7BIdogNdVo1vEP+BabNv5ibjgmuWwhBvXcQcXpUROikFSzEGDVq0cqtebQd3/t
	hpq9wPES60wg5s+9smXlfyXDLYAWA2o=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57e03279bfeso236453e87.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346810; x=1759951610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uoJH/lcolEp8wY4uBr8sDvnPy6/VHLzLkYAlVtJGuRo=;
        b=L8o3qpnqD6zF4/Sh5O7YR6+dorqWOGKC5Gm5YoFLH6syNSGdSqyyMoOYidNuGr3p3c
         UzCGNqB12EqRxAeA47XcbJ1Poiv7Tn87me6d2OHMqZ5ZhWkMKoTXODY6sebiArlF/uE1
         LRbIA0Nb0UzWk8XiL9w0phV7xMsHXX/ueX1KLNk3pCIUONLxmfVdhBOB0p453qO9cswn
         Je8MhmvF6wVirK0kX83saE7fkAyWx6tc/yUcxlAI+IK3Zf0D16rFNtxpSI0m8lworN9I
         OH7RsCLTXo88ebrJkB3fKtApQwYgVV4GicbjH4qsLPGpSiu7CK5ZxMLM5GTHUNYWjS2r
         CHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346810; x=1759951610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uoJH/lcolEp8wY4uBr8sDvnPy6/VHLzLkYAlVtJGuRo=;
        b=ZSZpxQg5iJdA4mvOXpNOAmn/ITFFr/F+49tobWmh76VnwYd9JfOrWgqfdOf7kjlvMU
         BQMx4/mdpajkPW1QYB6NXukzelWUKpCiRvVp1+IrnZn3w16d5peduSXDG1QtsPw6IT2e
         5q+vpTUZVtaF6jMx1PPAqMVW1DrNtVh0/c/hA9XjPg/MUHVo9SEcS5q0jZjfjV8/+KLf
         LqJcxIXfypqVbnHDcL2tBecJXYaAhGJNeq97x4NGmMtBgs8D4SA0h2X81prp0NZfDdjL
         Rx5/D4wUnGQwROwOrs64Rie9Bryi/H0lMx3h4HVO86AtPHrmAjrVMDiyAfYDy7GL7nEj
         yjNw==
X-Gm-Message-State: AOJu0YyA3+5U4vu226hYjZIBo/WjnnI5eHpnjhEW2/GoCYqmAxI/VHWU
	U+AQA1Guy82S+7m20o1jsGJZINmB6GFGHpZEbZha8fGVDO9tfvqQ49nzaNSus0hNH8Q=
X-Gm-Gg: ASbGncukJ8FkVqgkhsasYZDQek73nOghvv+6tQt6Jht17sEPH6dWlqI5NanVa+iLrF+
	RShvK3WP9+AQNJv5w8UmI3oVo7aafKozy8uxfWguYHG3fIapwJv5EWD/OAct9Np5KTS7Cycoi3n
	yOpe9lJdO3yV2icO7B8FORpWyefjD+YLCXqIulq+cGKy0gcndtgEPWyeMcyPd7rQ2p+2p6fW0mI
	Cr/b6B0ktaBFCZA7F8JB7UE3ICRxgpqFAeMMpRv0pzL/PKQmrXv5mquijnmIv9/IyKONTCIhkrZ
	w1TJ+vjdCEOjQ0k/OQ5jKM9kbWd5kzOuQvHE8istDCa59Z0r94jqyC3INO4IwlfOOYg1jMqSk7t
	1JHsVHyGjoO4pzw+CFKJKlpBnFdaN0NuT/AogTV1l
X-Google-Smtp-Source: AGHT+IG7A2+HurTIogoizvlvVPmGXQemL/KztO8gW6gU2g/wKjfszWE/D2KeEK8JNoWJu1NyJQd3tw==
X-Received: by 2002:a05:6512:3995:b0:560:a641:6499 with SMTP id 2adb3069b0e04-58b00b5b4b1mr215972e87.9.1759346809174;
        Wed, 01 Oct 2025 12:26:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:48 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v3 00/10] __vmalloc()/kvmalloc() and no-block support(v3)
Date: Wed,  1 Oct 2025 21:26:36 +0200
Message-ID: <20251001192647.195204-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBCFDA0013
X-Rspamd-Server: rspam05
X-Stat-Signature: wqhmx6m8hkimq5t5q51fufz8s7ah7ggj
X-Rspam-User: 
X-HE-Tag: 1759346811-44868
X-HE-Meta: U2FsdGVkX18V8YBp2uswEePYwsSSNAv+IjUI1LisdP/X02B5dWiu1VqxpfV08OXNrRLwZE/eZpwCpvq9VORAALDWdYVpTu5+cSHgUzB67KpYwCNHglkL+WIEYWOIBA8KVsKHAsH7YACoNeYqWn6jDLpPktpXhU8jHry7utwm+GZSA5obBDxiuuenbp59tAPfQNo3I28qK4GmEEp47T7Fzf273hrNe6R5lTKo9VSaB5+o9xqvJnpTcFvFSfRDBLH5NgrzBEUJNGGj6xGUEG4xI84RLbn/oE+h/dwN7g/1c5x1PwJAmb/CFtptXjYkshzF03QDBWR7Jby7isMg6dnd7HhVqmCsK3g9KrAGFY0ZsqSID/BHVjHX3OAu+VwTaH7qqXWZbVC+FGgUOfBX0QsVZjkt/u+oq0TE48Z9iVwiv/AV3T3U71gHp35pfDNzMKJF+DbaIWXx3/DL/APHsSe6E//g95A5hoIY8xAcLf8Nk3KZ91vQbDN5Sv1Z5GnNeJ2mCm4iSey3s8m2nTq/Bk4GuKONEDZnimOawJTfsGJEH5O1fMlCP8XSyxjiwFRSVOEnWmNUrMTcA+gsvu7n8u1NdN+/q2P0XsrnB9uA6hfOLYhvpjS1BiI1j97Jl37+SRajjMTL++dfNad3vVoQ6Ywjn+I1PuKX1xo/ZghEuPL6dg+/pTQjH9acPd/lOdmqvB31xsoqHuCwGDI/nVeLiC9Fp+QnC9jhunWwQRSOv3ZVQBRZeTXTv5QZ6noNQUnyqklG/sufnoRVIrqdudMgWTLg/PSBOpCiInx+fc7aiROqIrmPlLTxLJTuK+ZbO3AqW23wOX21DhCuR+rzKB1qoidcBrIWG6lSADL/3IV6l3/Py/Nr3W6TGWqSmrzZkm7lqwZiNAZHuRx/5jLg+65L2muE2fLMGY14XkVGzt2/Q8lMe+2qBNcT91pb9c6KyPNROsPcFuMkiWP3RBDa6qV6nqu
 8W6EhXZn
 DOndhNBiDqwOnX22JdIGzk/Pe0MGIc8WMpvf0/0wprXhCS2R9b9N2fSC3aOB8c3KZQu5DZWWi8yAqmGVoF55GYk+8lFt0g9/1/HTpshnCur05YuKlJ8PmL+XVGEYWGY+EFmgKYVRrnReZDD2MF4DPsZ9C1FCdM+6Y7laIrFVDo3euhEl0y1QSf3+pYsN6k+HGUMMCRc+F5JzOzt1ha+/emqTKI7m23lYKjlsgqavWorSfE7aIEx7WtJzPKl9vhzF0h9mRDtpXS/s0Np1UZd3hr+x0njz0I/SwnmvxdG5yftFZ40VjYKnM4CzGOWGUFTvy/ShjUX3JJu7E9xOvqrif25Wg9/BNlUHoV01Zc3FTPR/vX2QS2QX3CgSAoH5JYQ5gduE/w1SDK2p8CjJ++xqDvpXqDjcZI8eOgur2HvGhsqDzvB+0y2LdoDVNf3bndmmQIvTAONFO/3TQUoctFdL+eSyS2sQLtNpwAsM2sk13zVgk090dzvRq0EkI/4qTxPip+gysIzbjydmAd1BY7U5J5v/7aGAZ5C8R/ROpGLUfW8AaJGA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v3. It is based on the next-20250929 branch.

https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
https://lkml.org/lkml/2025/8/7/332

v2 -> v3:
 - update documentation of __vmalloc_node_range();
 - update documentation of kvmalloc();
 - collected Acked-by/Reviewed-by tags.

Uladzislau Rezki (Sony) (10):
  lib/test_vmalloc: add no_block_alloc_test case
  lib/test_vmalloc: Remove xfail condition check
  mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
  mm/vmalloc: Defer freeing partly initialized vm_struct
  mm/vmalloc: Handle non-blocking GFP in __vmalloc_area_node()
  mm/kasan: Support non-blocking GFP in kasan_populate_vmalloc()
  kmsan: Remove hard-coded GFP_KERNEL flags
  mm: Skip might_alloc() warnings when PF_MEMALLOC is set
  mm/vmalloc: Update __vmalloc_node_range() documentation
  mm: kvmalloc: Add non-blocking support for vmalloc

 include/linux/kmsan.h    |   6 +-
 include/linux/sched/mm.h |   3 +
 include/linux/vmalloc.h  |   8 +-
 lib/test_vmalloc.c       |  28 ++++++-
 mm/internal.h            |   4 +-
 mm/kasan/shadow.c        |  12 +--
 mm/kmsan/shadow.c        |   6 +-
 mm/percpu-vm.c           |   2 +-
 mm/slub.c                |  19 +++--
 mm/vmalloc.c             | 153 ++++++++++++++++++++++++++++++---------
 10 files changed, 179 insertions(+), 62 deletions(-)

-- 
2.47.3


