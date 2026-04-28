Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50984FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55026B008C; Tue, 28 Apr 2026 04:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CF56B0092; Tue, 28 Apr 2026 04:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942A66B0093; Tue, 28 Apr 2026 04:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 842246B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:52:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F73A8BBCD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:32 +0000 (UTC)
X-FDA: 84707348544.25.AB7C5D4
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id B6EA61C000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GJfyLHx0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777366350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e3sNHSEvdT5tHKgIgohZAf9cczsNpU7ZSQz8YQr/Ej8=;
	b=mVqYTQzAJLDwTfQskwnl+e8o1Nz6HtjfY2gVrUp3qYYOEOHkgzlud9uKdupMYpuarZ3awn
	IaMMuTD9PYnZR/M5k7xOY/lYqaUFFGgx7ulXYII+AyYLDynpfRcqPMjnyRjkX66tTausnd
	VzfFYhFxjzQyfDqPiQO/dkm5TlMrrl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777366350; a=rsa-sha256;
	cv=none;
	b=IrkTO5qjvWMQ+DEPr5FlA2IokNBxMvCQnlYAvUaB0FxooEeq61K9gJSjhUMVxwf3rP+OsY
	J8Vjc+wVlasRhrxu05QmwXp9uxUwMr98sG0HPvkYGv/FqWSSazscpBZr8MTrD5L91QWYho
	1dHt+ZYtxzob2dB8taOz60LAJR8KH5s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GJfyLHx0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36146ae9dd4so9375285a91.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777366348; x=1777971148; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e3sNHSEvdT5tHKgIgohZAf9cczsNpU7ZSQz8YQr/Ej8=;
        b=GJfyLHx0C633vyn7VpvdtG5mnPJ03hvomY/7ny6kydKjMiODr0n5Zco5hoCjir2F7n
         gx94qd4xE7evMYFdleBQ8AwouRCmpjClnXAY1wes5WE2eWZvZ755eT1mi4GKwFmrDNUy
         pU7d3H3JtO2e7yWxgpks8rOgws5/vMmefGxS6xUrpufyS3QEa2Jx+uHgUJH68pEGaW8v
         0qWtRZHeIazKnUGc8NLlgzkIbPIJw/dGcX7nRRhRSi/IF8sOvr2/1dgYfpi1NYE3UpiN
         cHd/27e94EbD9gWoeJCdi53Sw3c444W5ud3+iYBdEsgDMhd64BLIu6VUlUHAasY/bihK
         pqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777366348; x=1777971148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3sNHSEvdT5tHKgIgohZAf9cczsNpU7ZSQz8YQr/Ej8=;
        b=XfU1GGqbL2d7Uy7zFFdFNHh82crwEAHoIP6ovZnp848zn4hI5UNmhP79v0bKVhDFob
         aojmOI+4JeufKkf3wKQe/hjA8YDCVI13cpqzU681YOS1BFy5lXIIWqETkQt+x07ZiA2H
         TuL2ygGDiLj3kKOxoFgGwG2ZFUNlQ0lInw2mMaPBbqPHRaJLpuRHGGj/0ROhMgyi3QEC
         ziYIS+BjEleiOKBk0AY+6mLvwpm65AWz/lyDi9hAU8S5RcD6OaIaABLehOYSwfMIOD+b
         hshRIcvlYnvvylRzbmLejYd/DckNh63s69CGgsVPRcaFuonMGImW14jhJnO4mOQUwZow
         pHyg==
X-Forwarded-Encrypted: i=1; AFNElJ8kRL5ioWx3N+gpTKY6uornDqNM3b/6DHwSPyuUtX4o2CIRkM423VHwCeSO06G4+jDVZ/1w32fQ8A==@kvack.org
X-Gm-Message-State: AOJu0Yy+36rsnoGvtKZWWaJ753o/jyCkh4J9DsmU7VabQYbjDokIMPwu
	vbUShk+FnaKPEKVi7c/eWNJJj4MIbo3+xCcv1qRO8lg5Xd/0jp/jp1OFVvewZT0KBvE=
X-Gm-Gg: AeBDievwT+pMh0IzaPgtJdr6toTHsMGEml0dG74SawkMx1MfnJqzcjILWyXAy9lpQ6W
	wpb0bUeoji0p8Z/ShWW68NIhhv3MwoYzWYpJ/Ro00MT1BjOjsKa8z8ZXAw9ap5NBdfIvl050A6L
	Imhkc1ahRlz3F9mSOep1MEco0j6MgJtPUPw6Zz2GWGNmXh+HhhgUv1+58x1atPls7cCHDb2osjB
	g1jlDf4NTh0CjXgyA2v0mPDCxQ04qY1j2Juyv/CHCKVPabdhM6LhsA2PhSQ99UROTI1MslR53Ql
	vPoqhiae8aV4bNnxWCCWb6yJovY66KY8jVTHEQgVlv3uLVz+ckqaj+ZEWnWlO9B3uKSJh4CeH39
	+WkKNsJ8sdmROysFlKYKq/FIiOtTpTFBHFsF2lBL+FKRyjaUt3V5VN/dRUpajHMRIccX5Pt45dO
	dc9grrEcNrQfX5Z+nMRm+K6G/PzQlC8YqDo04g43HlWyCp6SWxcJUScDs=
X-Received: by 2002:a17:90b:2ccb:b0:362:ded3:bbcb with SMTP id 98e67ed59e1d1-3649204c801mr2305930a91.25.1777366348422;
        Tue, 28 Apr 2026 01:52:28 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364902e7debsm2889080a91.15.2026.04.28.01.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:52:28 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2 0/3] mm: Fix memory block leaks and locking
Date: Tue, 28 Apr 2026 16:52:16 +0800
Message-Id: <20260428085219.1316047-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B6EA61C000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 8h3ps4reo3634do1yqdjdxgjfyu9dwyy
X-HE-Tag: 1777366349-295932
X-HE-Meta: U2FsdGVkX1+kJw0DH244JBw2OvSPpHhgVYX8LUt2UlG7HZqoMheLJiNhbl7aR7VfGNfZi//cZPldWLgWDYN/ybIoaLiwvo3yIcnqH95Ip03sPSgjfd0HgdztUEsXdmH1Sb2ntSgwaQ9A6SmLyw021uC0T8aCGA544y4UyjLOQFmed8BugJhSnRqgN0Vy5PRLT1YKtTq77woX4aNHCv9lNer09+t/aR11EChai53qLLUgtY/OoYHA9YK1da9/kYA8d3BCrJeTeoC9PT+len8CNUA2k+iea7wiOwb98xqEsvV9XRqzlCbHti1sVWJDdvnOnzKRJyuABT2QKyLo5PeqdyNmhWKPG8Vlw+Jbn2zw3+TTQ4stB2+1YtImI80GWB+WVGGQ2Se7BHkXH2iRM6INiAdts+/aXo70TWgRUO+sW6NO54ouVHdPcPXVR2eq5EpIWAyA1K75hEmZfPWJjJ1iARnFMFdPgRlMDf6hOz7OWzaTcuNHpsuQcezh7cXS7rn6wyfrcsj8kfeW6JXXuNRyq3fgVPdufzbLp4WAZM7FDZDHj8yXEq51m5bqTyYNDZ6Sh7wpQC8pJrY++3S+8GUB0i7HQ0QpCvkcenr7B4kEKGk+vAZlm8O6tUX5UtdY6XeWd+BbT9Z5OEaxd6sLaqiEREYXcl1SU8EuZYxYsLmsH7tzfBqNOuYQRNY4MSoIvHSG05Tjbh01RzpAv6nx2KfwvePOY/753PIJ52CrZWkxW6RVhD125taXr8pmfD4gTlBVw662I2+s14HWcMAzlteg6bTJ7m39Hd9X65JIHNUEzLbeQCp998ylL9gHTBaAYzjVodlH6aNdXqP8MFSrIoc++da6ivfRA22fvyBn6LYy7I75iqj2+3CoPlr3NX36u/2W9UnexutP1nW9o2vUYnmE8Drs7ZngiSLu3zMxCQvHaF5x0hirJPlTxmAFd91PgiD5P+kxkz2290l+9hEfiIx
 q7ICXY+z
 H3/JGUTNVJAOw+tVBgo1Npuo2UPj2j8/MOi7xDRHw055Qq4Ue80CBeW+kk5p9AudqPRjgq1JKVIwCs471y58QYpTy0foq3i0wusZvpMpWHa76dzdSoEXR2Gd3NKYxfi041mkzRP0KPPbyrchkJNnEWsdkUIJfUcgsk0qIW9e5daI6UUbV7FzyfCQbFsAPKrBx+XMPy0WLX0idlFO9wW/bm8wKTx7Yfw23P7gy2C9qAa15i9DqdU1UNkDLwQAvHrzuTPAXQv3KKcRtLf4oiqvlEra+tZRYuk71/qgE+jFUW8L46A3dM9nBjgUOa/RNsaGtEU130yFmXv/F/QrNyf34QE2FbU6KGWVK0cmY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two memory block device reference leaks and one
locking issue around the per-memory_block hwpoison counter.

Changes in v2:
- Add Acked-by from Oscar Salvador to patch 1.
- Keep the series as pure bug fixes; defer
  memory_block_get_by_id()/memory_block_put cleanup to a separate
  series.
- Add Reviewed-by from Miaohe Lin to patch 2.
- Add device_hotplug_lock handling in patch 3.

Muchun Song (3):
  mm/memory_hotplug: fix memory block reference leak on remove
  drivers/base/memory: fix memory block reference leak in poison
    accounting
  drivers/base/memory: fix locking for poison accounting lookup

 drivers/base/memory.c | 18 ++++++++++++++----
 mm/memory_hotplug.c   |  2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)


base-commit: 7080e32d3f09d8688c4a87d81bdcc71f7f606b16
-- 
2.20.1


