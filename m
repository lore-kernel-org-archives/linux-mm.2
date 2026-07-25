Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1DC7C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 18:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FCF6B009F; Sat, 25 Jul 2026 14:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFB46B00A1; Sat, 25 Jul 2026 14:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE8C6B00A3; Sat, 25 Jul 2026 14:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 542AE6B009F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:26:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D431EA02B5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:33 +0000 (UTC)
X-FDA: 85028129466.17.AB4549C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E0D0A0009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rOOCGxeH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785003992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B3mFtNIDwmIHE/JWuXcFpV7vETg69hB4Zppykix3hko=;
	b=26+upc+J+XT05RIASlxNHtndDwO+7aGWzAEMXIR6mJrYOqVUOOn9n1NSaJurNnAv1ssYAG
	c0Im9bHVVsoJp1BxFuKFFoOo04c1Krq98hmyIW1tM+m6TeDr3mxWAbx/CRrpSAcucp6vhP
	DMpo9moMENpI5imUm/xLwvZf0ji3oQI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rOOCGxeH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785003992;
	b=TIW3vSMHAbhxZ8Ffban6WsEVVyGQkS5MV/cGKIwkLMTF4O5HaBkizg3vZ+zTYbcjAdj26l
	1wGYpA5LOesUuEVA7YCl6QfdQpyAHvnAt62N31Ua0IS+hCueZwZWzHYqvntps2KAffd9pY
	mpcq/EZ701Y981/opZjdMf42fpSG6/Y=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493f6de72faso11814275e9.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785003991; x=1785608791; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B3mFtNIDwmIHE/JWuXcFpV7vETg69hB4Zppykix3hko=;
        b=rOOCGxeHAIKe4P+nQxKxNowp6eC38OsrIXlJQbeZmg+qGhTxt/6xb/vY6876Nkv89I
         4kxeiw5nysOiRDgYftKzJByYc4k+t3SsIr57R5GSxCgKQtfxvqwt1aRXDVvNsqaolm5C
         azlaaHGfDfnSZTzW2p5tnWl+iNgBiBlwo+07HI8pZp38DxBxQnDnctZKUOpBJgYWmK8+
         yoFfZt2Jqsn+xxUa1sn9C5MOyrukHj96SpauJUovK1fKvq+cYNrOO/A7DBA3E2f9pN2F
         2v3QvTMlLJgdpIby18mnps8ZxNzB2zVHJ7Buz/euLSHpUdllG5p0QvIuzC/jdjCifkVv
         NzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003991; x=1785608791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B3mFtNIDwmIHE/JWuXcFpV7vETg69hB4Zppykix3hko=;
        b=LfUM141hZ/6a+3LM5pkY7DzvmmtxEyij7ktfeVcvpX0b1U6oaN6uBZaAZsVxWaMYUV
         OYjw5uuLsrBcYXZO+dLTJkzpKPLgX711KL9g7ftf4bp9HHjyRcWGJddNxAjfRhjAF5IC
         xVlBsEh10vWeelpTKSdlVdBYvjQi5HTTUR221VdNnNbeUieKGcnT+7moMeXl4UStfVN9
         iRiiVIS7FoMMsp4nM7LWqfJpaHWGTY18skfJPWHKaKFpzXBay4qJx/eE/svmPBGLMVVq
         TUhWmQOt0tmuQ57PcA4LEJeVlp1DCOoFR1ftRlc6lFhi9WKatXCj3mc80zo2jwU7DeAJ
         pkbQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBspFSJIsLZDJ1GDtZJI4mcFTYBEXdK7mw/P1JSLFS66QlMfKp962t6/MkKR1Doo/8kiQvVllXHA==@kvack.org
X-Gm-Message-State: AOJu0YxJPE+5bafzEivr70UODtJJ+HNKo+dFiHri9UUakfN/nNItHaSP
	0MMav3jjWyYszNW2XP2oYzJ+dj3QvHN8rWtZU+UhmUFy4Od5CT4gzbF4
X-Gm-Gg: AR+sD11gl+xzlQVV4F9JkkxBJ6IbwmUcUAYhu3jUNU5o9y4PEBYkiS567aDRS5+UDlB
	2qTb3VuBtKwcH6kYTPM4rat2dQhUlnDfA8MTi9Uu6sbvvR/l2ZQXjwYHn+F9Ih+Xis1aCT4vgCs
	DDmpgXGJFsopyjMVsMSZPT4SPm5sMfQo26GGhpCz1Ir2qkAWfIFms90zLln/L0efLzopG3RHfdl
	dzzeN6uhGONc++ihFQ7wmbpwqltQcbtUul9nUeIdUw474VxrL9DojfyQW7TDhrB0GUDEgEhnPxF
	/Mblli0V+EfOtdkF5qLuZBFubLNXk5X8df+O6EysdMwvD7Pyronupcog6hHFBDy0i/bvXLMbkf2
	DHyQhYLM1q70IcsdAeKtevBjueXFu45G9dVxlHOgvfIb2DWjvDhpDL//oAZPeQkmd/+gc+x3syz
	yjIgfojSs=
X-Received: by 2002:a05:600c:4ed2:b0:495:6934:4146 with SMTP id 5b1f17b1804b1-496b5c71914mr33588635e9.11.1785003990446;
        Sat, 25 Jul 2026 11:26:30 -0700 (PDT)
Received: from localhost ([178.241.98.184])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-496b485ff2csm111107805e9.6.2026.07.25.11.26.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 11:26:30 -0700 (PDT)
From: Ayhan Aydin <nsd.project.dev@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: nsd.project.dev@gmail.com
Subject: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
Date: Sat, 25 Jul 2026 21:26:25 +0300
Message-ID: <20260725182628.221603-1-nsd.project.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E0D0A0009
X-Rspam-User: 
X-Stat-Signature: 6d4zowtz7kbhmo6w4ygfqnq1zhpa75e1
X-HE-Tag: 1785003992-922871
X-HE-Meta: U2FsdGVkX1/XCLcklmeLdfLniP7JYJi5XuIZ4cAMO6iZYJv38K7GAQTTYVwzA8gBx9b0+WL8TzBJpd86L41tOs1sNBCCI9YwxK4S50rBMrwUtUY0TKyLVitCxdfnzc77Y6/nBAX9lCYJjE1TXXQl7EezIfYxiOY5GbmzkKyh05PxSZ+t3AbriB3y6zOo3wEO2f4XNW0RvWyw1hHuOMqoL6gaJjjnhenM2cBHGASUkZyQVYXp2PhriHIr+V3bRNRBHQHlsHVJP1ioeJ63gUi3SqcKN++yqFkbP6/U0kaZrmvJrziB0OV/VbExwZgb85ib+ZFPukvGjzqW1FZ0fOunySd2DmdlHFEhBqiyho2ckCU/9TqNNHmKbYY+47ZhkfdXuAH6eo2mmsMS60tgtm3FScjsSdpeiSdf8BKtLBGHzYsEhjMRnH7/gERqxQ4U+2+x8Lx0WALCT7GPTi0jleZJdLhZ0T51I9UC0Nhc7VVsSUdWIAcM4MNXxRyehh8ONViA2CI/BgKwqSzDvaqHYrhy4CxPEwocSnrGU4/pPGHyAeswudZb3/RbnhWw8zTJ/+fydUQeXji6RDZFu9Ao6gn1znbLqdGHdj4BGIzZNK8H77IVB9bfo+trD9L2tlv/t5mVHzmcoCQtN9hBFfneAxjmSOing5TdpOitK0VdMnzUwmUix2wbM++aQ9GyB08W6fN4+bziHH6BnJizYfG7ixoCZKd6E+bOzGpU8wBp8hyA5fjSitQdPRuEb5EJr6CfNgwa50m6jISQPuEfat4TKgbyiTuXLY5aba6UKtb0i90opU/GmA5ziJtBYGQvBem6Wf7OUR1KH1PWS6lHPjTgGgrAmHSTVS/MsnuNPyGuzGRG49Y/GCGfXoBhx5iznN5f9Q28DMA3vidh8a/roQ8Wy4Wv33DN0+rM5j3tPYIa6ea7xSeTOwgxoucWhgK3WFZXHOQYcVLi1Ss9wb1gkytFAxi
 q9mUpKub
 pThzGagAJIFf8BBfcJhMBc+RDha3Ic4tm4nt1+j6c9AoSxZVCdJWCIua+R4907jDELxBelw2Nla5FSx4jkfFM3miGlG9cefYBaoMlhQKH9hGbebOrbYpCH7DV9sm3HDr1VNFQwC8X+5SDp7hxrFruHyuHxFltmqrqx5oNk9JgyndcZQhMGdW7WPy12gwu7P2AOKz0Ok865CQ9KaAINsCPl/9DpThKSOUt9KvlaawDYdN86P1vkZBQN3yEvpLYAyGqoy30SeHAzagxzsMPea/CS7T8Aj5GpYbh5KMSDLTKx3+luKVxpI0oeQKe5jh5bdA35s+Abaqn3E2PUhZF6lwmsevHoWxAP+0Mra4jZNIdS4h/gfHouJvummzak036gvU/YOSVzamzQSDbC+HpboogegQp1e6BAZA0t1vsffVdDYAwtD5bjhW6XDm1/y73SOi3ZM7Gnsh3vmyM+mY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This RFC introduces NSD (Neural Storage Driver), a learning prefetcher
for the Linux kernel page cache. NSD monitors I/O patterns via a hook
in filemap_read() and prefetches pages using page_cache_sync_readahead().

Background
==========
The kernel existing readahead uses a fixed-window approach that works
well for purely sequential access. NSD builds on this by learning
access patterns at 4KB region granularity using a synaptic Markov chain:

  - Records transitions between file regions
  - Detects sequential strides of arbitrary length
  - Issues page_cache_sync_readahead() for predicted pages
  - Achieves 98% real hit rate on prefetched pages (SSD)

Performance (x86_64, SATA SSD, kernel 7.0.0)
=============================================
  SQLite FTS (4GB table):  -18.8% query time
  Sequential 64K buffered: +22.6% throughput
  Random 4K buffered:      +1.1% (noise)

Read latency:              130us (no regression)

Key Question
============
Is this approach suitable for the Linux readahead infrastructure?
I would like to hear your opinions on the architecture.

The module currently hooks filemap_read() and issues prefetch via
page_cache_sync_readahead(). Would a deeper integration with the
existing ra_state / file_ra_struct be preferred? Should we extend
file_ra_struct to accommodate pattern history, or keep the predictor
as a separate subsystem?

Patch Summary
=============
  1/3: mm/filemap: Add NSD prefetch hook point (+5 lines)
  2/3: nsd: Core prediction engine (fs/nsd/, ~480 lines)
  3/3: Documentation: Add NSD documentation and MAINTAINERS entry

Signed-off-by: Ayhan Aydin <nsd.project.dev@gmail.com>
---

