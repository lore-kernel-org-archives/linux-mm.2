Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6B0D2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F226B0391; Tue, 20 Jan 2026 04:19:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116916B0392; Tue, 20 Jan 2026 04:19:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E1C6B0393; Tue, 20 Jan 2026 04:19:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2C326B0391
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:19:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 706D0B99B5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:19:35 +0000 (UTC)
X-FDA: 84351794310.04.D146F40
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id C2C36120003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:19:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EzY8N8RE;
	spf=pass (imf29.hostedemail.com: domain of 3o0hvaQgKCEQysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3o0hvaQgKCEQysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768900773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gf2YI936iIbQws0HxhhxYueO3tESeyYZp/38y2RVRZI=;
	b=B5LLA1wnsAc8Hhi2qozPyCZ7tiH52BkFxzJNS3V8hspfdcDw8USHlkbvpW6Nf8yvM2DdKR
	BOEL5kqOOZ86hHgGs1tjLCSFN5i0hxr6tW9+Nh9VfRMYA8X2eFkRMHuN97CmU7z1DPgDJk
	U0Jj6rYNw7EWic1MWuKILnMlKou+nVY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EzY8N8RE;
	spf=pass (imf29.hostedemail.com: domain of 3o0hvaQgKCEQysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3o0hvaQgKCEQysuyzglgmuumrk.iusrot03-ssq1giq.uxm@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768900773; a=rsa-sha256;
	cv=none;
	b=4Kw956W2Iou2FhQllP27Ee7qlTmYrNk7T3jk7WbbB2gMeV64DshySfWScjwX16YBLxbDWO
	/fxd70oIma7RIfxEwvQFx/gqomCLMRs3VJO44SqslqR9GmsMRrauWVjsEZ62vSd0DByzpf
	rpNGMhIMwMJvchzK36tq6JrvCSfgclQ=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-434302283dcso3864440f8f.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768900772; x=1769505572; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gf2YI936iIbQws0HxhhxYueO3tESeyYZp/38y2RVRZI=;
        b=EzY8N8REJW9XyjRfmfKe+kfuMBTtYHpeN8UlqI3OySqRZQjSlbUKzzpFe++x68G0sz
         V1kQuraCatLkIkUoMVZn4TAN08qn7zaeCxBDWMWnJ+UWm0xUb7F4+CYWrBFMCpam3pZD
         h+4RX/Md4iv0V/WzRmGs5ijUsGzzvdVNOC64MFmgYeSMJDqIwjMqRWAzIq3TXWHmrjno
         rJ/eVEQcm7BsRrIWQdh4DV3BLF5zxtk5+Ftr6hZ4/7LcTA7ojvVIEoAjdnLBcp6E87nl
         UojjXaSLK+QSiKwb1E+EG4RlStBCjQPbEmi3WlOSL5xTkWl8cuNRJ8lJ/2EZHf3x+1oW
         duYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768900772; x=1769505572;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gf2YI936iIbQws0HxhhxYueO3tESeyYZp/38y2RVRZI=;
        b=XWGzbQCRCcIgL/fpE3zTmmVEfatCRDxvvNQsrNuyKWVS8fwsAT7eHfU8or653XFrUZ
         XY1yVWJJNj+rlIQYb9606K6BN3HK++PG4vvYJETCBvwt6er0dIrtz5qT1ZWkHt6TbnfZ
         AL/jR4CvanaTghRp4RIGoASUCWwZ9e5kMCsywYj6w4mXlyb65IPZm8vaDJCwBJbpBiho
         VsaUMsZdFfsuymaYgM2i2+jq6VjtH/+yd66+OVRTZfDX2FUoKJtZwWpwpQRVQIw/VoBx
         nhgukUBEJSPhTx4MluwfUprCNoKkdvGC8rO+ilbeMNI/xMS1nKL4MT7cW7ZXTU6McSzL
         L4aQ==
X-Gm-Message-State: AOJu0Ywe2+EH5Ep+sxbE02roCZ1cGMkU57sfb/PNXVNYzAcO2mrc6uYt
	qG62EDXxb7LhZLBGvY+PjZSuDmfJJSixGVtD794ijbUfQLwsJW73nhRqVCrQNlWOXp8jwVKyS2U
	X3zAj4aOa4GaxPMAVjjJ/mloFWjTJWTqXa/i1XNMaPP/5Ggad84zsXD12VI3EmvU4Z+qDHW9sUS
	v9ieLsjJpRKvzC/Vq+OCvEGUgYsAV9Amn/wdCgXVUEzg==
X-Received: from wrvk17.prod.google.com ([2002:a5d:5191:0:b0:430:f5ea:d30b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1448:b0:42f:f627:3aa3 with SMTP id ffacd0b85a97d-4358ff398b2mr1994536f8f.56.1768900771795;
 Tue, 20 Jan 2026 01:19:31 -0800 (PST)
Date: Tue, 20 Jan 2026 09:19:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260120091926.670155-1-smostafa@google.com>
Subject: [PATCH v2 0/2] iommu: debug-pagealloc: Remove pfn_valid() usage
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7tss7fqdmcz4k8heit5c7ogspoqwq6br
X-Rspam-User: 
X-Rspamd-Queue-Id: C2C36120003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768900773-939768
X-HE-Meta: U2FsdGVkX1/VrptlNINvkERifl2RLCvnd3/dwM9hvM0lOdSF3kBvLC/bt7u1s3bJteBdwANJtbtWc4YuyvDKzQSU2bR5FgOEydUs0mi35S2/HzG5QidS8HolJTF9Kv8SJbiKkaliwm90e9qpHL9RnFtjlPiQ3sJ3b4zM3JkElFheegN2xQVn4yPiF5m/VzqkQJHUZk69JZSEH0g2MPkkU0zyviM/tFo7tR4MGAFZRGlvxcPJwELFueC1xEJLisM5MrFr+6U3YqMVZRSBY2hKbVcWKTmvzh77aNWo3PRkGI0VT1mPv3uJNGOczEp245JNZfCY4OhEa1/iNV4CCB/v/wDcftrMl1LquvewCZnWl1Tfk3EGiz2GW+VYuuZ2ANirfGt+bJAWB21R/X7zSp8/Z8Xx7CTVlikJ9+ksGdIKIJuZ8Ew4SWONNwMQM0x/2bvw7/vQcDtu9CpAK7R6T5I34A4sa/4uH4F3tY7FmluRklDJd+PZk04mnML7U0PA2n7nQlEOvY3csp79Nszvsn5mOwg6VwJFVqr8nbsSxyoQbj/VV/yNiUq7jAExzpN2gD493PJcyq8r2myYpmfIyvnuUeuILk+yDfKyuo+v087/cVig+H9r3u03HaECmc20ES8SA0D8V2UTyFjyGlYEfsycgMyKoJczfMADazs69Skcvj6HBDKQYy3BkJBPhcyNozUwRb5KYSv/2aWSEEg2+QUkcsa07t6MMvp2RPaLw3t2bVY51T94Sd7I+DdgyXY5vqCt64ykJDt4kax2hKIcZd2zvcHKjbJxPGiIzonBgJ+qyvfn2/t0n3ViQDZSn6ZIfNJjztZFDbmUpZltIvo5DCt8ssqnKvKdypVazy/MTZ57q0cLU+m9gGZWDWtvXkRws3dejVnB19Ng3+AmfrtcXZpLbs8xTiOhmn8lKUeoc2OdMIusdQUdN1fWjSUWltA8NoRvNfQXrg20uyR5FKMF/Re
 mMoXxjfX
 3m15DL+yUNqBVeN/HLVAdzwOpzN7C8uOYwSwmYiJwSXyNShLnZ31Rua/GfKMNE7Aq69S4dqE+nMwthm+vosAof1L4Q3YF+2vX1+ZciOxkQHUy9OeacRW+8ytDtRWfQjHy5vXz/toNBGpvOMk5NHJNkcHAw81ouO1Cqu9hi82BDt59FKz/NHwbRf16h0TMYqEQhgWCjDJaBPpZAaDtu0nWyvzUEMH7VOhRsN40/ztEj7C6m/QPP14RxSGt1dF/71Nl3++isMaDLxRA2lqAm0K++gF58jH/eUELPuTRgDTq1pqnR68+TzKKoLr2sH1vwx3r3qTs3rNEuury4Q0sLccK3R48jCPVbdMdSJOJ0adO+nN2q/cAEJccjORz0Bx8z8mVH4fvTxfmWgVIaqOr+vzdiL6eSemf8WTD2OD+UA/10CSUsCGk2rQ0Nu+VeXczF7HwEXWANoY1gUhJzbn9+FuJH3oV8ZfeGIcg0gqf2zJq0DpOfz90n8bLuozyYACMOQoR7Cn8ulz9WboreHxWtaFUYyRuzdkIpK0LusWHy1yljKS29VH9JW6B4cKMOyKa+E3Xetpghx/65bgLOhJpRIZNB2uTL1VG/CRD0O4xWjGBms57QJmELgPFgBXXKDR7v5USj7yXW1nMAMbiJ7EJoBnVZ7dqMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a small fix for the new config IOMMU_DEBUG_PAGEALLOC based
on the discussion:
https://lore.kernel.org/linux-iommu/CAFgf54pBAUm3ao-UJksiuGKtvv4wzRyFq_uKwLe0H1ettO4DLQ@mail.gmail.com/

Where it was concluded that pfn_valid() is not enough to validate
physical addresses before access to page_ext.

The first patch introduces a new function in page_ext that takes a
physical address as an argument, and the second patch uses it instead
of calling pfn_valid() and phys_to_page()

Benchmarks with the new implementation can be found in:
https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@google.com/

This series applies to iommu/core tree.

Changes on v2:
v1: https://lore.kernel.org/linux-iommu/20260119142246.3821052-1-smostafa@google.com/
- Rename page_ext_phys() to page_ext_from_phys()
- Reword comment and commit messages.

Mostafa Saleh (2):
  mm/page_ext: Add page_ext_get_from_phys()
  iommu: debug-pagealloc: Use page_ext_get_from_phys()

 drivers/iommu/iommu-debug-pagealloc.c | 31 ++++++++++++---------------
 include/linux/page_ext.h              |  6 ++++++
 mm/page_ext.c                         | 23 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 17 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog


