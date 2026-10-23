Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D802C606A333
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=snbZh5bE
Received: by kanga.kvack.org (Postfix)
	id 080E06B0BDC; Fri, 23 Oct 2026 15:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030B16B0BDE; Fri, 23 Oct 2026 15:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88866B0BDF; Fri, 23 Oct 2026 15:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C46D86B0BDC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:54:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E0B41A014D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:54:45 +0000 (UTC)
X-FDA: 85354943730.15.A9327F2
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8FB13C000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:54:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=snbZh5bE;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cpi2EB3quHQgRCV81Rzv4dQD8elBWDJHR5WGv5PMzrE=;
	b=0C8lRX+XyHSIZ21fBuBEzLnbqBmjFm1nLVipOfB8WfUbaUo+qCHyZC0oIRpUDvCTXwVbA1
	7T3WNZra9OARWqxkU2yz31FnkrDc3YDEE86Wg2m3i0usYNKgK9JqXKnlJW33y4FFn9+FQU
	+29B1meOWvnvb+VqDgnwxqPDAP3nsfs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785283;
	b=2ufOWlt28blrWv+YiR5IVThhDTcMyfuHj4NLU6BXhcqqHDeU7dlDYnKULidzt3hshnaBlU
	LcppvrPh1qPucqZql40wWoebzSAqBqDZhsDbGi8AZ9XUnCIOcPlsnab/MxNJQnKebRdGGG
	ZMqU5+DPtRFwOMwf3Y6xYBcJ6WX2LX8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=snbZh5bE;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b05bf699easo12867917b3.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785282; x=1793390082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cpi2EB3quHQgRCV81Rzv4dQD8elBWDJHR5WGv5PMzrE=;
        b=snbZh5bEQ4nknuubC79PtyyATElkIWkXHpDJanJ9YvVgDLzAjllrTqG5BYXC8wAQyp
         +l6F6tsOMboQCdA6dBGOevUGYq5uDM3AR0a6QeuIL4v+RrkTX9sf5oq9Q01O3EwvlaAh
         Prs2XMS/3lMV+DIMePDxoDOsVMLEBb9bfGkKzt73BaKAQJrBkzGBG+g0B2Vz+DeoYmLN
         kZymBRoaGUh/jeNvjuLWsPE9dn2x1i5Nqfhmoeo7VqkuZYX8CYv8ktUapothL10fXBNV
         x+lob9X+mjPTICNunKZZlExA/yJreXUaR1kkir4jR9ArxL+jEVm5bPwivogi4w8+1oD9
         s+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785282; x=1793390082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cpi2EB3quHQgRCV81Rzv4dQD8elBWDJHR5WGv5PMzrE=;
        b=sGDhNqMdYNb526P5oCqzroj5qAWKv3pxWQ+REwM/VSrY+cCRklLS5lgk6otNanRA5k
         qdAxdNL0cDTUuetcRTMxwfb0FUdSRnO8caib8CkLkYU+nTQ3DY3GkfadFz3yra0tXgmN
         kXAA8tm644Rbt6nn+F/PK6vAq86x/xrKvnbQ2H52hhzZL/Tay4xGkrY54Omkk3yB3Yph
         p7/f7pspcfN81yW4GMn7g4NwaXNeyn6gipFka4ICDhEaVh8Hq6UDDbAexp4L88Tn9d4f
         J9uG7S1in8a/B+AEBJMnLOazdj/pxMWXy1T7G6WlK02MbuYpYevK2cJZ4j8CCTSfkjrV
         1ywg==
X-Forwarded-Encrypted: i=1; AKwUvBwyBiYQzgXudHbUJXPi54fJRhVp0/iWLul+/53nYBuNyHK9Ddoxz9KRarrIaa0gaz7yHGLLHB32Bw==@kvack.org
X-Gm-Message-State: AFq9FYI+iQ+N/nSCWv/TUUZpsfMSQOKqL2O1nRVL7F3CxaP9gqRS37jR
	5SszcY1UhFewn6AWAPmLnRF5xplCx+Q+Kt9IO127M2tSrkwUBnir681m
X-Gm-Gg: AYBFou3aIKNSDEQubqB+mVGJ/j5nY/25q+qiFDRe5OTBkCyf+PweuLIz3hyxhlyHzIG
	BOvQBfmZKWkkszvzfzSTHQgecv6ruNQ0GXWZPvwc5TpQ4nkBQHV+0zY93aqMKoA6YXWnlmDQGzM
	Ghydvd3AOAp2JC8mzBeQol5R1XwxhwjJx9SFzeoD17bXaXUKCik53b4ZMCurmqZar9Dmy2M9DdI
	Q5zw+ozuGerXWDcC3yl/FE0acv/gLJ8mZslWsm5wvjG8j1hn6xw+afwpfDno3WOivZ4Jr+0+I4E
	6W2L+pCzJh5uGr5geBc4Ngh5JcnBCrVDig2ZBKxc26p1Xd6DYhAkJsqpzn0ul8b54Rw28gMi1Gn
	3/Itt4oWjVUjSBVE1i+yPNn/yJGh5T9Ru335kbJzqQsE9pfNZDjkItErn2pQmxIxsprZUWTqHil
	orIDGHIFBRCmwM4wNmEKidgKDExBH0z4JglRgzU12AQZwj3QLNC4y2+xhdzccouFTVvaUfT/Hea
	xYHUD+21DPV2VfLM+SAvobzUEALUHfKBZ3CSD8Lu6q9kh+L/tHmMEUC+vu9SgEez9YaKqQRvujW
	wtIBaQveIo9kvx8dwvltr5EGkljma+k1
X-Received: by 2002:a05:690c:c117:b0:8ac:805b:3a7d with SMTP id 00721157ae682-8b166c2de63mr1462627b3.47.1792785282377;
        Fri, 23 Oct 2026 12:54:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166dd01c0sm961667b3.7.2026.10.23.12.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:54:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec stat
Date: Fri, 23 Oct 2026 12:54:15 -0700
Message-ID: <20261023195417.1391216-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8FB13C000A
X-Stat-Signature: y8skoirg6a63pha1zw3z35o9frx8bw43
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792785283-765844
X-HE-Meta: U2FsdGVkX1835vkKGXAu4FfBNLiQJq5/9VzxzvhENhW475TdJ368vMz3ZNHFxfVmOcjtcCz85dpYLVOWo9MRBLlxLVmDNXJPN4fLqiEpEQVKosaC1IBUXcKedHZMSJDwUmWje1hF/yr21EONloi95XzKTbac/MPUSAECPwva6d4ql3VfX830qOTmMZs6pRxe3Ni7FT0yw/PsbduluQr40N7NeNB0SGLX8P0v0DXrpKevEVe76V8RnMiGfQ1sMzZ6nANYdSP7sqaoFkTrLOst3nXPGdJsJ+gOKNbAVNJ04mzvv/4N1h0nq5XvPmytNmHnvCRM3Kx6BCc+eLUQ7kFeZgj/FbO80D+sePeBUNJXeNA2mfRFoAGQ7LhS3ABXSudVzGpuJLit3WeBlUlhwkdKPCQsA45pM1iQtq4SlRDKT0OOPlWgC6HlmLL2b7ilje+SXzsKpkh9BFijjwoovWeAFR5VSarGzp6JGu1eB8m0/LgoRra37OECDJIQCQWkiU7UYwNl16XJsGc5LQ2Uxn6Qdj2f3p1DX/4hlQ8pyImqhvnYNg6uufzrTY0w2SxRUL4q+2DLVhUsgj3rZ+FFn1TWgNDRsQ4BsdY4XfQuHytk/SpztAuOMulXYXjnVM0z2daIV2/Df5Ox8YVfkwirGKB0i1UexDql0SlhbJPp4kv69oEA56gFAwT0BLdhH5IjT54VaP+CwP52vXcbHgOvbvqngKkOEXRhO7gGFRZgfQsYfpfJmHzzOYy0czjK8kFo3linKQXdRXEosUuCxwjZtLCDE5wAQZvAE2wDo8C6N/fUE6+KghsvJES70cdgHBRDatsgEzEy59Q3yUelzPnxAJ/QulU0LNDpfN/+FCBo3zv0BIbypXfyvNppCDb+wKJgFzRxxMeDhTwTf06eToHjgO1uXOk4rUq4rT5ivOeJOfVfwVITkwERt3qOZJbXdgWNEa2xkNl4gFWNv5aI0uzNRpH
 WkjqCYIG
 mAmrXhFRpm9ZUfJWLIlyRVjrX95BVqHk0ylP9l4h61W7uxTy9ZLJxNDce8hh2n60+pc7YBQgefrgM/J/X+wyS6KCVu+MoCXEleUwWFVTZ/1tPKru6l0r7p5+fq3WdidR20vMBjc4OgKYWqayNYOjuUKJjwXn/KmmFX+nQ6HNiaKf7QgudAsbOE6MNz3wfNKtB0tnbJfcaZqCAR+SaFE+Jik1bfPZaYB98UUKRf9rFOE7mhv+oWBAPcgspkY6daDTsOvoc6asFnyXlbHnltUbX43qE8e9yfRY2RVcmvEkKnmNwf2QCCUdiCGLNGjLGRct0WZbNPcIPxSYUBmyGMJRE/btn93xO19BJD5eXi/tk2D8dUmqJEQVoy/IcfujbB0U3KaIKmVXsDLKlx8M7aEQCmxaJFYdaXNgNc+E9Ax90Qw+JhrJ/mq7hbQMrSrZ9AjguKHGnh0qvP/mDbBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and struct
lruvec that can share a 128-byte cacheline pair with lines the lru_lock holder
writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), depending
on where struct mem_cgroup_per_node lands in its slab. On CPUs that do spatial
prefetching (eg Intel CPUs), this makes the stat updates contend with the
lru_lock holder.

Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly line is
paired with a cold line, and patch 2 makes the folio and kmem stat updates use
the memcg and node they already know instead of going through the lruvec,
whose pgdat field shares a cacheline pair with lru_lock or lru_zone_size[].

Results on a 2-socket Skylake (80 CPUs), average pages per second for
threads faulting in and freeing memory in a single memcg:

	   base     patch 1   patch 1+2 
shmem, 20 threads  4.74M    5.59M     5.77M
shmem, 80 threads  7.94M    8.66M     8.82M
anon,  20 threads  3.04M    3.08M     3.10M

Changelog
---------
v2: https://lore.kernel.org/linux-mm/20261022223930.138779-1-joannelkoong@gmail.com/
Changes from v2 -> v3:
- Add in a comment about memcg_pn_cold placement after memcg_pn_read_mostly
  (Shakeel)
- Add Shakeel's Acked-bys

v1: https://lore.kernel.org/linux-mm/20261020200730.250189-1-joannelkoong@gmail.com/
Changes from v1 -> v2:
- Replace the lruvec_stats_percpu pointers in struct mem_cgroup with a
  rearranged struct mem_cgroup_per_node layout (Shakeel)
- Move lruvec_stat_mod_folio()/mod_lruvec_kmem_state() change into its own
  patch (Shakeel)

Joanne Koong (2):
  memcg: reduce cacheline contention between lruvec stat updates and LRU
    lists
  memcg: don't go through the lruvec for folio and kmem lruvec stat
    updates

 include/linux/memcontrol.h | 29 ++++++++++------
 mm/memcontrol.c            | 71 ++++++++++++++++----------------------
 2 files changed, 47 insertions(+), 53 deletions(-)


base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.52.0


