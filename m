Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299EEC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C966B009D; Thu, 20 Aug 2026 22:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCD46B009F; Thu, 20 Aug 2026 22:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBD86B00A0; Thu, 20 Aug 2026 22:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F01E96B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:09:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 721004035E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:22 +0000 (UTC)
X-FDA: 85123644564.24.B05DF62
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB487120002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sZF6OF5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787278160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dKjbfZHkiNhUGqU33xNBmYXaYrU2IxP4A82LmlRQCB0=;
	b=LCUhAbf0W8a1D+4/KqIKGL2Ifzm5UpJbf4h9LebvUUpV6znh6w+ZoRq2Eb4BYNc95Pwrzu
	JG3zD1K0wwgRhZWMTbyL0IPeCxmVy3F3A18d2on+INPwvwqFcaa3cpV+Al6OX+5PO0UvqH
	KK//7MXYr7LoNjLV935J+gedh1WhHtU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sZF6OF5T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787278160;
	b=ACUKl8wsw1EhkEwbpltfac46ECNpL8m0k4JOnrm28hsEgffiqUO5iOI8r4OQT5EdLih+DZ
	E4P20nWcbc6nrTv9qDWO/DPhQlXaGnSeJb/Zm4zxYlVjZxaEhHYf09M+WAcENa1OR2FFHm
	zsRpoFUhKw6CU5/Dl9ioT4mI/tuLVeo=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d049069377so5180455ad.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787278160; x=1787882960; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dKjbfZHkiNhUGqU33xNBmYXaYrU2IxP4A82LmlRQCB0=;
        b=sZF6OF5TlaIANxDTvc7U56LzWpu6gHx6N1P8wQVkryYc07rAAUjDXJBJSytjDE4m54
         qVLkG4yYstZ8cIt7LsW4ewyuiNgBFAEz0h01MdRolx2aJehRZkwp+jHs/X6tLGoMzZy9
         775RSQX+3DPQYxag+YPBGY9cuFrZOz2XGS6Q8LU5EFAyXzNnm88FQRNVtpDI4FPq6Lwu
         /rGiezt44XW1dJWTGizeDLrXJqoxHmFwyy4no9jpmxFA5kqL5Op9IoddtpicKFtS0ktd
         jH6Q0PnBQ5X3Q9VfyzAqyNCg8MPFE9J5pOZqbJ3hg4kybqWDLmxOmLElvSmOnNjUzIf8
         hgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787278160; x=1787882960;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dKjbfZHkiNhUGqU33xNBmYXaYrU2IxP4A82LmlRQCB0=;
        b=kc1v8UNRTJQL34UNgGucR8UFxvNIGCv45rzbpMhjgC5jumAiqmMscxPLPTDue1yciY
         0IiGIgTpefQ5fH66TLAnJo5yrfR6V5OxSjvg/GE2IlzRqS0029BTCJ5H4ym3UUCxSmAM
         AiFUI6wnHzrJdRQlRkhuUsili82fxKcKfSLPoXR1l0nBM28FnkHTGY2+SQ73SkaKF6HU
         Oml9KqTOgBXPyCtKyNcaEDBgT00RAv+3u532yiZZLSNzgFeZhGI+0qpTfZS2x4apToGZ
         1eUaORRTm97zPtHjPW+ubndHRn2w08EXLVA9mRtG/2TpEFG9ysAXOi1Y/DYEhcUWgNB+
         Hlgw==
X-Gm-Message-State: AFuF++mFgOw4msCOBEOngwEUF9mixbIJZCzYeHKF7HCzkdZwIoqDptgw
	Oz/hFj26YgTgedUSdnABdUzRagF6fPiq8EZJNQQ9W7JzfLkZDEU+9guK
X-Gm-Gg: AR+sD130Lx4RYgHVGFx+1/WiMZoBOkaEORoa/bXpvpbbvJpgxHSzsMWyw9QZZX8CxI2
	+pwCNq1nivViFhBvbC2bHKdHhTB7WilCF5GLxGgg6eVNNaQib0Eq4lIkcM9KTscEOHNxbtku+Le
	ZHgZwjdYaXC3U9jvmqOIqkXPYFYBSe1Vd62JDvqpZ23F6d3QA/C3N9iq6+zNSwnI/uruPkzhjqj
	yamV7prxveuZLClIHoD4VM3C1giJ0AsdsUFZUxGOIZHenlM4D2QAOkuJuWiXt4wuseBZG6otiRl
	lgX4gPuq0H0RIqFm4g7pqPLspjAx1GX1FliUeh0dCBUy014rkeLhlZDt5x1PUQDm0cFRLBt47Zp
	fYpJhjW5f/E6cbxTKCUecX09sMdp9z/TB339385LbJTDcRsSOb6T1oK5QgrzRMk/SMAvuzUjKxR
	EVKbK/zmI8p2ZVDv+IOKHmxA9Uv5EzZVVDYkrLhXo6XkIlfrj4S3WHwqzbn0t2ldxm1j5cvGjhV
	OQvClGi927l1yZ1hlQgb8sl2t4=
X-Received: by 2002:a17:902:f68d:b0:2ca:660:b1d with SMTP id d9443c01a7336-2d64b025d01mr50792365ad.11.1787278159529;
        Thu, 20 Aug 2026 19:09:19 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cced8sm12851045ad.75.2026.08.20.19.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 19:09:19 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 RESEND 0/3] mm: memblock: fix debugfs flag reporting and synchronization
Date: Fri, 21 Aug 2026 10:09:07 +0800
Message-Id: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h6yc9supj1ah18szwt5xtrcweox5oe1s
X-Rspamd-Queue-Id: CB487120002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787278160-937425
X-HE-Meta: U2FsdGVkX1+SCdvwd2VQnXzg9ZstmoVbHruaW+I5ci3NNZUwfgm88av9NTmoLoCfiGtsjDVUeXMj8AoUzY3EQRBK3iwm9KvNs5yVAd2ePNwmyDvbN8fqBkfMRebzOAhyyTnJUm2aJ48k51Oz4cWKnq39aWNWBvFaRDuyKltp5a/BBxla+y0V4VJ4vlQ4sCZijvkt+vQh6gtpLphjED9Fn90kS34N7/A6wwq1YDAK8A/FNb7bGQj1z+FrWxZ9LYyY6p3kAO547bYtnJzAhC6PCpgdkJgqgD/e0Be7laYjzL8rOe+O394pUu+rFAzk/a5Hcbd0ZsLMM+dw4FhRmgMaOxBRik+dDX9m32EhR6Yi+S7SejwaLHNYBQgQIvTg+jvpil1JPmv80gKmum9X1O1qBtO+nv9aoNqfXX78CtFxVGhXl+vumPehbs9CbemFqK/+AXsIqeC9/ddcdK+hUD7ReKWtpUp7g+lgOx5PDUnc3cA0E8kaolCh7xTqD8Hi6VOMI8ijM8L4mwdOnyAn2T/CiJelN/+LiQP7n0tJHt6vlD61WTsTCfDSBTTodzQvxht+gC4tbdamjmQyyXYXHTlbS2z6fP30t64FOjkgqigCDlyNfcW7bMy/dLms3EQ+IiG3rtYJGQrJ6/Ip5LEA0CvXBIz4/e/ozwPd3u4hsdM5gHshhwdMS2bKreoAbxpqz5VLrenjVMNRgyGAlDCxWfTbqbcG90JPb8Vb7hY57YnH/kqALcjaLAUP/Fd0UcVSMa0nqFmAZOi+paYVmJsmrgtGJyAAomtBsFyTmBYgqHc28UAFWUfa9C9CdmoJDcdjER6aiEu88W1QD4LeDjnYrXjg7AFgHULL8/VS6jV3ueKmDWKfnVVs80BhC0MtUCyNrL/aOVUBfLjcYzTW+gr2Loz8s4HuocR6jEI0Znn61E+l60pLvJjjc4rYZ4j9ZrWmYOWF6qThuK8OuUjEf+Sgeaw
 mKiSPpmw
 AIOn7ERBBqgh/Q+/0TOhSOJQRE6q90IXGJcJyE+KG7adsQaRWOtRmGTQAMLwsbyHNYWODEHGtgbx+EHReZ/EIpmx3zVtoVpNMXjznV4QaWJ7DvFX79E8BfrGN7pj1Zc506FYZNWvEb0rKrTNmpn4BWx35QdnHSXzKp6e4bnKkXHk5qDmqWe+osDw3IM9HmUhfOQyEEhtoVimua4RyoLJrABIpyY8YM2xwFHN/ChoU0k4YSrVxQfxr0uDd14hTc+0CM4XAW0gARDagBDeCuHl8qV4S/iMAFhnX2XdiIrHE21cRqcgbf4bDmMl27Vjc8o6E7zcPpMPTXxLRjpGkWYy/BpHO+cqeuvoTj2dz/4FZpB5pA5FSGyNVKWqS/0ozNDgGQ8OmH5uKwjq6zphpDzIKRafkbhGFptu21cP0tJBHuiEM+SmELk8w70jLDH6AYxq2I9Kr/gkMkXol5iggNLuYoBed8h5+K+d4GssTphI8eZZBRlyiHwLMXVxP9VscaKBZvmoUhweMMYdGTOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

The memblock debugfs interface has two issues when reporting region
flags. MEMBLOCK_RSRV_HUGETLB has no corresponding name, and regions
with multiple flags only show the lowest set bit.

In addition, memblock_debug_show() walks the region arrays without
synchronizing against memory hotplug. If memory hotplug grows an array,
the debugfs reader may continue accessing the old array after it has
been freed.

Add the missing HugeTLB flag name, report every set bit including those
beyond flagname[], and hold the memory hotplug read lock while walking
the arrays.

With the series applied, a HugeTLB bootmem reservation is reported as:

  RSV_KERN|RSV_HUGETLB

RESEND:
- Regenerate the series from the same clean base as v1. The previous v2
  was inadvertently generated with an unrelated MEMBLOCK_NODUMP change
  in the patch context, causing apply failures. No code changes.

Changes in v2:
- Report set bits beyond flagname[] as UNKNOWN instead of ignoring them.
- Add a separate patch to synchronize debugfs reads with memory hotplug.

v1: https://lore.kernel.org/linux-mm/20260819075422.2387980-1-zhaomeijing100@gmail.com/

Meijing Zhao (3):
  mm: memblock: add missing HugeTLB flag name
  mm: memblock: show all region flags in debugfs
  mm: memblock: synchronize debugfs reads with memory hotplug

 mm/memblock.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.25.1

