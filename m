Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA87ECD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30EF6B0005; Wed, 13 May 2026 06:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAB16B008A; Wed, 13 May 2026 06:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82856B008C; Wed, 13 May 2026 06:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B40036B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:58:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F68E1A07A0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:00 +0000 (UTC)
X-FDA: 84762096720.09.50395EA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63662180007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:57:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Exg2M772;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778669878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WFiFqrfIxZKW8JDnQ7Bqz8YSOm+TOdxAq7n8QeN9+A8=;
	b=1K4KeCyxjI6GzDpaUPEQcFvhvAui14QXi+9sN4OgA49vbdA+lDpgT8vjDRIEP43hDFrOJu
	oMV/1z3hHvE7i17lv2vRZhgIs1vxclywrIwt8EATicDmU8quBHeoMP2jmICsYlwaeCt4OW
	YB4Qnkkp7g1jIpvB8SFFdhjd4F8rS6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778669878; a=rsa-sha256;
	cv=none;
	b=jWaKJ8lrg4HPCQSQO+YE2R7qv09MUQAtcYOJJ7gtHQL0CpNp3t5uCWUHmknaFQXgFonVni
	Jj+G1HKe2FGKBx6Wu4Y6sys7bESl1yp6KXvdyYsDai6cFEgxuOHVMYplpiaqRxNn7uixxu
	H8rDTgtdcN7rdEb3n+4b94XL5xvOGPQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Exg2M772;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B80811655;
	Wed, 13 May 2026 03:57:51 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ADC443F7B4;
	Wed, 13 May 2026 03:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778669877; bh=ggr4lWgxj0PVy4G+xEkFtwTJwkTF817dsnRVC/g/pUs=;
	h=From:To:Cc:Subject:Date:From;
	b=Exg2M7721p0tBdyqCgso9KybEzTA8oAxesZ4mf2UMIhbm0gl3yHm2Kl6DkVg3/+Yb
	 ox7M1f3Qz20fiOdNkTNlcL836gk8nUUtcKgWeB3JF/aucbc7utDkpX5SwT2Xo3Vheb
	 WD+VyxUy/vBf6B1lbYUoDf6lQJzVgmVHyjf9c38E=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry@kernel.org,
	ryabinin.a.a@gmail.com
Cc: Dev Jain <dev.jain@arm.com>,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com
Subject: [PATCH 0/3] kasan: hw_tags: some micro-optimizations
Date: Wed, 13 May 2026 16:27:31 +0530
Message-Id: <20260513105734.3380544-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63662180007
X-Rspam-User: 
X-Stat-Signature: 7tgo1rzbid3diga4t6cdcjuzjanukszi
X-HE-Tag: 1778669878-104734
X-HE-Meta: U2FsdGVkX1/B214Athsqssjmca58UgegG9dBIFtJN5Ao/TTYvFojkhf9sJu96DkNi461mRm1hsSMd3taW7bMp/v1LVMUJLVuwLMFp59gLdkMWiyer8UGIotfR61JjXtQ17WwD5IwLT+dGkCdf2t5oyKtvBvyhSZNn0WzJ+iZMtWXvrDEu3u1jY2vuv7hBvZlCc8Ih3eX1O6OheS/R7Vrst1b3J0wMs886Wqbfku0GIiMc5Al+qY63IvyhwJx2YvYJLPLLGaCxd3ELBx1n+zQm7G5f7sZvTZLfk+Q/WRlFJ/OhGVvG8bDtPY/GgncUqCAy683xGeSUBYiksxbcfCtvG/KEtuTTX/811YighorM7LrGV8GG302G4RlcYbtGaa/aeK+XSo+7Cf9Eey9/5kk8x1WVzPwN5wzOwpvvq5VPisVwuZNAacBMQDprfhHg2Bkq1piqL808mqSnlBHFxq2rw2hKzKu9XsC5/d8WYvLDrHz1qDmW+79guEO5MU9vGa0zWozYXIwplC3XV8mbYNKf74VP/h1ddraaGrg5fLMnWxuI6vuwuCzC4bBFWoJICHDMrX09xS2C4BHkruKS/SXxbNPK+gMWf+P6sUGnUPq7NaALgOnWn3p/LLJrdL3aJiwupRYx3KIpgIAvVwor4P+kJGl+aieDyEXwUfXGgqjJnQWpoKfgYQ6ryEuw8U96YG5+ZcZOPDs/VPzbm+s6OWjfGwpytLv3l/A3cnBoK6f1mHbDsgFNwSvep0V1X/zB38O+SYPn21sHyX0BwE/Fbth5bdC5HQYRbOfQrBHv3rLx/78vhVgR/1n4bbtc9AP5IJf1pl/hxFZ8eHDFu0j2l8wyB1+9vWeOtnxzceqJcS5W4wv9L8Q5jDhv21NlrX5Ub7gCOuN1sMbY/h8DK7P5pqMkTHSJ2Mjpnl9y4TP1b7fM2SWztqUpTDqReRkUHlRgHR+nXH11mJZ/P/D1vHNCv4
 TD/kjw6F
 wo1mX+YsUN1qJnOVbr+AWkpkycgPZ6nQJM9hemSB3leUYegCNwpBDYjMutSda2DD5tNGPRMMCwtaeKXycAFx6QoZC/cHL8MTezU/gxWeFesl9hrMYw8QfgQ46Nj59in9lomvRP8ZdZytu8ukdtubs/PuaVLvCSma+ESXAqNYd29we+8rF57CdCJkG/sWXJDM+vVG4TPkyCq0+AD/kWEBBgjfxZsDsUk0pnaD7igK3oBA9Yz2cwYwP5amMQFOjzxYpGwUm/aYoMo02YHczjxsdQfRRwGR8vRICHhl7MoL3eHCd32Kii5VP3z1a8poxDtrAuWi9B3+5/7PP/98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 uses GFP_SKIP_KASAN to skip unpoisoning of a slab page in the page
allocator, since slab allocator itself poisons the slab page immediately.

Patch 2 and 3 remove wasted work while poisoning the tail end of the
vmalloc/slab allocation.

---
Based on 7.1-rc2.

Dev Jain (3):
  mm/slub: hw_tags: skip page-allocator unpoisoning on slab allocation
  kasan: avoid re-poisoning tag-based kmalloc redzones
  vmalloc: hw_tags: optimize vmalloc redzoning

 include/linux/kasan.h | 17 +++++++++----
 mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
 mm/kasan/hw_tags.c    | 13 ++++++----
 mm/page_alloc.c       |  2 +-
 mm/slub.c             | 22 ++++++++++++-----
 5 files changed, 79 insertions(+), 30 deletions(-)

-- 
2.43.0


