Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09508C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8A78E000C; Thu, 28 Aug 2025 08:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C07B8E0001; Thu, 28 Aug 2025 08:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6A48E000C; Thu, 28 Aug 2025 08:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19FC68E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:28:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC9EE55CBC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:07 +0000 (UTC)
X-FDA: 83826093414.27.EEC6ED7
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E53E80004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EV60mlW8;
	spf=pass (imf30.hostedemail.com: domain of 3VEuwaAgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3VEuwaAgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FqQKwAIz2LU1OWm7bXmF144o14s2i386mLuf3AdVSG8=;
	b=xbibW0691l0s2vLwQja/mSzwxokIp17ryJS2lAtlJBpUW+c86EaVy/bhcgtP2B0pehhNj6
	/PTVNww7GLchDs6zXZ0+e/V+0KikS4g7HWkFtpg399aEflCwH9FyR60B92+zTZxCkotBTu
	zKlRZxyUMVFxT5smZuWBThMxzTdEPuA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EV60mlW8;
	spf=pass (imf30.hostedemail.com: domain of 3VEuwaAgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3VEuwaAgKCPciZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384086; a=rsa-sha256;
	cv=none;
	b=p9aQCM/OpVCYopMoMNiUrQVuo1pHPk7UTS/Y1aISyG3/CnUYSKIdNluNCZcQ/tzcE5IoXU
	doMmov/M7duXZOM+gwFvhisJdSzPudgkkTPfYoPDvbHdbRrZUasAogo7OYosx+BTTt3I/J
	h5DsC4JitXY7ch5lSwi91TjXXDvHgVI=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ce65accfc7so336435f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756384084; x=1756988884; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FqQKwAIz2LU1OWm7bXmF144o14s2i386mLuf3AdVSG8=;
        b=EV60mlW823vSP/h6hY6eZBSHA17wXFwk7hZDojQ6b9rBtlhK4qVzvpRAtjb5XlW9Qh
         SZxAoJ3qS7F4QT/QzyL9Z/oArK7TOXTdDfPIIjIRGdmQQMyzWjcrCCl+JxQfL5LkHwFB
         IlUVsjhQVGk5F7LZY6IReNkSVOAiFfGyJDmBwRDSvz9aTGrwxuZZRzsVdAVeOMSyS3w4
         KQvRM9x+PcQmgPU3s3OvVttg+oZaXLPRpCmIe+6uChV7vBkBygz9u4EoHzVzMVgF9jKM
         TAEp0Cx4KQVKK8ifPqvv0bw5EF7FfDrSvBay8b+uEIS8CYF7P8QX57D5x1eF4g0m+jUN
         XM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384084; x=1756988884;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FqQKwAIz2LU1OWm7bXmF144o14s2i386mLuf3AdVSG8=;
        b=n4kyiVih8wBdJwd/OApKWZjGyqkOGSi3uSxsMtiGVzJqkCqd7F6ri+G9JuYaYd4qrU
         8DAYEjO7lglF3HbZOmtAPgAYhN+XQPa6BKi1A6R6J9MEQ9yLV1tXJGdTuwh9qZCN+ste
         n6hs9gDapDXQDwyytO2vExXje6EvH+Nf6F3o7gufAhyDc2FxAFKIDQMhzGOrNUuwAMpV
         CIBZkfaoWjRpatAGaGtn/pCktaXTUtffHjxwa8zk1jUOeC+WzM34B5RGU7RM4so9kElo
         7f9xPSAYFj8+aU5pc+eD8B3Geim2qqd1r4FyZqaoWAVgHFCa4Gn3KCMmoN14anMmEmU1
         hAiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4fz/NdKkXijnWU7Sv4t8h6yd+LXFQevOTi9RRGnwSEW7TvhvbLiyMQr+JBBKqxB3jMWHxFDooxw==@kvack.org
X-Gm-Message-State: AOJu0Yw8GQglFw38I+vfSH43CSotgKDmVC3Ljl6IXEBkw4an/yVO+6QH
	OCcOhaWimeJPb5kHBSsmr80whyrpLzCHRhUAspAKl4eilJ+eCego+Rh/VZVO2f8ylBAWqJsXo19
	aGY5l8otFAx7bcQ==
X-Google-Smtp-Source: AGHT+IHZCHmwCefpydsRTcY/KLOL+C0u2I1bBuHeaqD36WPuC2sTn7PhhQE1Zs20gugP/+7/d3IKRiWaT7ybNw==
X-Received: from wmth22.prod.google.com ([2002:a05:600c:8b76:b0:458:715c:51a1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f85:b0:3cc:b206:bca2 with SMTP id ffacd0b85a97d-3ccb206bdf3mr4803717f8f.33.1756384084504;
 Thu, 28 Aug 2025 05:28:04 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:27:57 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAE5LsGgC/32NQQ6CMBBFr0Jm7ZhSQcCV9zAsSpnCJMKYljQa0
 rtbOYDL95L//g6BPFOAW7GDp8iBZc2gTwXY2awTIY+ZQStdq1Y3OFQYF4OroNlkYYszKtfSYLW
 jynWQhy9Pjt9H9NFnnjls4j/HRyx/9m8ulqiwHi+mqwxdG+Xuk8j0pLOVBfqU0heA8kz5tQAAA A==
X-Change-Id: 20250827-b4-vma-no-atomic-h-0f8ebc2fe4f9
X-Mailer: b4 0.14.2
Message-ID: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
Subject: [PATCH v2 0/4] tools: testing: Use existing atomic.h for vma/maple tests
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: fqgiyc9epd3scb74uh66f1y36djr13qc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E53E80004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756384085-451794
X-HE-Meta: U2FsdGVkX18zHDKVSi0kuRm9xoJxf98tVeKzbe5E6AF4J3uo+IFjXaFUEgtQ2StURdOSqLeTGJ4RuH9782lwmwHPrFmdmUrtc6MBR0JfxRz/41Zq7c4G91IE0YHzY+OOaLVUuDtlHAi7NSZiLL91wTzLezBMiGAxDKWmpnwtfYBRcaRbRWarn5Pgd1S4reWYvGGM4NoxE5JoxN5LmcWohT0f7LnRmyWPllkfa01yzAGC2yebuYunk8fiVncHsVW1ua6FO29lFVqS2gMXOek7i7QA2qtbw0FP8rW5oBhnsbAI4CFbVLelKYJJ2jOsGxPKJBfhpKZJrnVX+3bUomBYSj/JgJRoRGaON8PPS3Cg4zq39NmS5Nc0IUfWfWTl2AqGmF3VMSFDlKbi5WAqVbVmjarqupnqsFV/x/iadnXysS3ekAsBdDDu2WcgqsRVbx8rasEixfzhPUXUr1FVWZRAPbXIj73Yv1F7OCRrPOpYzsvxayk86Jte6VWPKf6HYZ7/9M/x6diEtOBPg70xAnM0tSOMJqp00Z5C7KfV2ey1q/Zf7FJhXCMJdUUURw1Hzesmg0fpmJic4f5veXZfsn0kTOXKxkUSpN8IZ6bMtnYxeKWbBXJXatRVZ1xgfjBuIHba/eAmilS3x4dLQxSFyI2oBeuJIh3UgY4IgPsxNEu+EdS4RqsgHq6AU0gvIjtnu+bflB5KLaLvb10XW+cXQ00g5FpCIBcGa2QvW6c4ytffX+nvLIzMqIAl6uK6HI3SGbj0P31pzVmIhclLMtXN8tOuqZKCKSAJlvonfCZYfRdcX1/o/jPJSbISOSkFjPI1hMqaJkApeJSzeBPMFpCYHWEnnW1Bw986oHvbeBctgbZJuA5TNc+H03Vjw2ajaFry7RMfXO0VDR5vvkWj9/IxnpInrVy7ARS6CUYV2oMImJP6lXFPm1STg3YYL1TjR8uRzp2KDvdjJ/M43H65PkeiEkq
 s1uwhBCK
 JXp2XQ8qiZPpapzYcI09oZg3gW9iOmd/Rga7dF6BZ8sHbv1VrHEKBbCfe0wWlT/qeoj7axwaFBzaike16szq+9hSUtYFSKqYqEvUsmHMEx6AWVGqYCIUJQ/s32W/UyXiyqNfG/iLHS3G1RqJyN1s3nGlAlC7mgm7j+DHqfRVewBMrsQvyAp/ztzLAsJxfVOO4LMmLgC2Rxlsp+00ehZqo5NN9MDCiKFBOksYVfKGvGy/OXbxd60hFg/RVs/Qm0nHEetcMhHuH7b4iGANAgtxYm9PixmzLxksV+6wv8C+r3tBdyBaNqCChHmrJeNa3XoovVmikPEjOj/9EausON5vxFEOa7rgSHcqG2ps7YZPG1PYdXGFm5TG9RUoVt7grazl+U1pFN4kPEvUuMEvEwiZqyaAEBKPVCRV4hxYGX9+TXAzZNaOvP3YqleY02BwZyt2GnVakZdxtTRXBhLTaJLfyHfNB5fPM5xfA6XGNa2VKfsBJEkrM8lON09LePkA5fwpbxHXuexKUtk/w9+vr5Tp1Qm2f40Tjb4n8z6OOV50zCqerOfD7s1RfCQWpYYJ+uvUl4YF0Z18beXPbf0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

De-duplicating this lets us delete a bit of code. 

Ulterior motive: I'm working on a new set of the userspace-based unit
tests, which will need the atomics API too. That would involve even more
duplication, so while the win in this patchset alone is very minimal, it
looks a lot more significant with my other WIP patchset.

I've tested these commands:

make -C tools/testing/vma -j 
tools/testing/vma/vma

make -C tools/testing/radix-tree -j
tools/testing/radix-tree/maple

Note the EXTRA_CFLAGS patch is actually orthogonal, let me know if you'd
prefer I send it separately.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Added some new operations to atomic.h (in support of the point below).
- Fixed garbage synchronization in mapping_map_writable(), thanks Pedro.
- Clarified commit messages:
  - Mention where $(SRCARCH) comes from 
  - Don't talk about radix-tree for maple tree specifics stuff
- Link to v1: https://lore.kernel.org/r/20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com

---
Brendan Jackman (4):
      tools/include: Implement a couple of atomic_t ops
      tools: testing: Allow importing arch headers in shared.mk
      tools: testing: Support EXTRA_CFLAGS in shared.mk
      tools: testing: Use existing atomic.h for vma/maple tests

 tools/include/linux/atomic.h            | 22 ++++++++++++++++++++++
 tools/testing/shared/linux/maple_tree.h |  6 ++----
 tools/testing/shared/shared.mk          |  6 +++++-
 tools/testing/vma/linux/atomic.h        | 17 -----------------
 tools/testing/vma/vma_internal.h        | 12 +++---------
 5 files changed, 32 insertions(+), 31 deletions(-)
---
base-commit: efa7612003b44c220551fd02466bfbad5180fc83
change-id: 20250827-b4-vma-no-atomic-h-0f8ebc2fe4f9

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


