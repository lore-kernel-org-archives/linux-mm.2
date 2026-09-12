Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8504C88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F996B0088; Fri, 11 Sep 2026 23:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730BC6B008C; Fri, 11 Sep 2026 23:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620B56B0092; Fri, 11 Sep 2026 23:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBAC6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:04:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B030A0290
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:04:31 +0000 (UTC)
X-FDA: 85203617142.26.D5FB36E
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6988E120004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:04:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TLInIuTm;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789182269;
	b=BGXHZz6W7oeRKX99On6+xaZLIcedKWjXjQRIDgXSyipsAjt1TrJ7pwfusKeLNws4xIFMsx
	vTF9gVSRO7xAh5QlWzsGuc1VBqK5xfkhepbpdxserUO4VDNhELFpg/F+Iq4/dztXPIJVJz
	vMXKIz3lTDQFEBs34bCTsfvmnWT/Bz0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TLInIuTm;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789182269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8PXNL3BTwfgQ9sQ47ua6UOJz7+dhY/eFnsGANIW5HtE=;
	b=Po72qtC0JR/y6yKdMoICUy3hDAOfJxScw3h9GV67NvW1uH28r1xOLG9XDkpFb5NFFJHBDG
	s44sLRymnYDl8Ct3ezFIuw7ZdtmqzpAwfNo+7aRo0USDRStAoLpZtX+MyMmZ+fm+W8mUbp
	0qUP79/4EGqF0VWeop7pfF2jCsn9kts=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfe60d5fso3260326d6.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789182268; x=1789787068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8PXNL3BTwfgQ9sQ47ua6UOJz7+dhY/eFnsGANIW5HtE=;
        b=TLInIuTmC+TDUoHKoEbq7PQiL8TvQW7pqstm8bp+9DjRxK7QKLX3xoen8Suny6ti1I
         nS+voyXDcU0piSsgvzW+9/dcZzk8RqP7Bv/k+4BUoVjWG8iJEKypWTx8u1KTMzv4dvl2
         4vXX5e+HnO6GxoTDbQ+Qve81sfKupSWeNU7GGDI2EFLKYm4Fc2cjfIXziw83JWo4gMZt
         bIlE86ylgPIEY19CuluOe+ier7WIUHGofHpCg7OnN55pvR8kZNe2mOa92YahDpgX4nbj
         ljJx+i+84ciylZ5+/5KRat2L9zNq3JzyJtaDvos2fPUorGWqKzCKLGsHjWUqitJWcZb2
         671A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789182268; x=1789787068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8PXNL3BTwfgQ9sQ47ua6UOJz7+dhY/eFnsGANIW5HtE=;
        b=ojQdWD1KCXzdTs2cBVIz4AyBmBYn3rn2EjPdmk0y1kIhSRC4Zm+8V46PznQq00PdTO
         an9CfM+f+c7RaKMEg2ARpBONDHl8XFe40WfXTdDCLzZBtHnjnW79uuLxWJmM+mrbuNgT
         mEmsf8pRT+bj10fSkL0WXa+x1+1EyZ0135v+pWQWYYYol/CW7drtVvXv7nqmkAXNx/K2
         vyMpDVbv46BAz2UnhZZP9j775e2L/ZtmTzXGz1BqZ5jhrYwyOm50im1VqxnPo0VIEPgc
         onYoR1YNdEaVFbiO7oQV6tUKnmXa24ZoTCME5MGYg1jJgs0ETrcXYf+b7BhxCMzZPd8P
         dOrQ==
X-Gm-Message-State: AFuF++mpKt3fu9LK5sKU33v6d1Q03Ck1YxBxQ0Mi5JUg0tCrEj9OVAeV
	Gq0f+aRn6zQwhUrYkJC9o7LAoGXHNzZy69AWRFRuotqxLZBTutwrELYDhn+KGlyC1gOIvEMwtR0
	0uRpW
X-Gm-Gg: AYBFou3ChwoEzlmHUve2Gz/gv6C6uQkYXT/S9JWS9ugRQiK4Y7U61DxSr0zx3lAS6HJ
	K0GKTlskk42KM0ZR17P9P1jZ8fqr3dloHQ1LwKT2RCmEF2fwv3fTad6sJjXAEuiBnhQHTuLQR2N
	0XHjcc+PsTDTcxwa7/h3ednTCR27eq/lxEfotga2QbPSz5TVavBTdtMTnHqxqIpD9Jyf2RC2d6v
	MSSh4zMPqoCw4jJt4dysEHcXOqWvb5QQKlA3iZbZvUWMwoQZxBZ+vT6RJixG8HCMUENGl0zBRTf
	HhtyvFEVPUGAviw335tNOZ+WeCPeGiSMycYPhL9DbDn4ymlCawoGN3KI738cDs1BhtAzAF9PTIH
	1nvqFbPSv/gneAHHWwy3BYgnQzTcVtKV3fAvJL9YJ3prZCKmcbBb6MRrK+gRFegKE/wFX/lT+hB
	XA1yMBJf4oVCtjy5PcQpPXh5ia6hVFE34e+OK9CZTNNFejQYGlaR3H8PikG47U0IeYNSyeejRyl
	W5CvghVVnVa9nZEmdSK+DHaHlQ/Z2NWSb0NpcaSb7LFyJRSwvczdwwI7LJo
X-Received: by 2002:a05:6214:d8e:b0:90e:8cae:7fe9 with SMTP id 6a1803df08f44-9121da4d683mr18657526d6.24.1789182268435;
        Fri, 11 Sep 2026 20:04:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f202856sm36085296d6.2.2026.09.11.20.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:04:28 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: [PATCH v2 0/2] mm: refactor zonelist constructors and iterators
Date: Fri, 11 Sep 2026 23:04:22 -0400
Message-ID: <20260912030424.2889731-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6988E120004
X-Rspam-User: 
X-Stat-Signature: 9m8sd1ts6o6gkocq8aeb8n7gdc6qmnqe
X-HE-Tag: 1789182269-972644
X-HE-Meta: U2FsdGVkX1+5JqChFSzGi2LYUwlN6zloVlT2kOX8uKl0XPvP5bh1TaWj85BPwdy6ySvQaFny+7yA5PFYdt1e16jip2FDH1jDZUrsRAEFZOMWBOJ9sHAsLYuUXZQw1Muw1nLZqOOAJpyWbd+LOrJtQNFeFA8byZ1T6ACXNbYsDYnZc1ceA/SyPXvKKF8d9C5qdkblqPFl1+99hpSQwV4vRYMgQnkkmrIDZ+tT33nii51zaYZBQqpeXFN/leZgVYjK9UhLDHSlC/4S5rFzTQgx2KkQyBiIdyAroqnvLO/m3IojhQGWVn4Fbhhd3DvBX11uVBGQmfrl+ZvL16frS1lxvGqW6LjZGhQ6xw9fonTkbD3cKuCcMU4V0p5XBro52KFDG3UaRuOTmdKarlziJJpQgp110+rgb0M1FTW6L3WocKHqAcY39QTFqDEz4VBKfHegRmxlyAfrShbip1SReOb3osP5Z0ClqH9nyS/grVUcG7L3JU5rCM/7rsMQ0ih2GaQuTMkQQ+EJ+g81LMfFj0VMe4M/9E5gmzEMu9PyAswornIX6WlltFPDKAhV89KR+QlB/xc7V+iM0xUQ7cq8GhR5rIZFmo5guEOezNkRso6TiuP4B7QLl9JX+NNE4y9FdiFihDQZ4jnxXRfrX5s7Rm2Q3PQvt92XoiU1TtW8RMitgGch6iQTWg9uqMUcFHgqUwjuNgfR+5ZAm5PZQIQR9oYxaJm8cfMWEPQiXFyD6k7Cr0mLU/mIlBzcGtLF+CibHu+DDeoa7ZKzaFJv51uQqfIymXOVNKFM/AoVwPW5Itp26fF8snsAnGscwBiWWn69PslmmRHKYmVyfLLLI6P2+wOYRx5wkg8GHyWiVCTKqFUizW9yzkBBOqdt63jEELdvUd5KIL5bW5a1fm2pNlxF+UNXcAeTA6qbAwI8V3wmvWzqf5+IUjorCHIeeFMMNkZOfAQL2DyEwZMoEXBLvJMpF4s
 EA9KsVSi
 +Jo8GHDltrJ5iR8wghlwguLlRz4LQixAVvdl7ScSXBt7YNBuott59TW3dYQvnzB96kYHOURzMt/a0bAwJxVKQxjPA4rNX4k9ye3KAzuiHWURgg9aCtLyBVVK82oWv9BD4LWiw7Or3yR/hh5tofjqrNPDHwkOjV1MhIt3cx9oFidpjBa+KIUc+n36ISly9pdk1nwvQ4nfHcMkZb+k/XtgHrIH6SjIAQQTOAQQUxZ13O6ZUm32cifGAlBs5ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_best_node() picks the next-closest node when building a
fallback list, and hardcodes N_MEMORY as the set it picks from.

Refactor it into find_next_best_node_in(), which takes the candidate
set explicitly.

This makes the existing behaviour explicit at both mm/memory-tiers.c
call sites - they select demotion targets in fallback order from
N_MEMORY - and lets callers narrow that set.

Then extract the per-node construction loop out of build_zonelists()
into build_node_zonelist(),i parameterised on the candidate nodemask
and destination zonelist index.

Together these allow a zonelist to be built over a candidate set other
than N_MEMORY, into a zonelist other than FALLBACK, and iterated in
fallback order over a caller-defined subset.

These are prerequisites for generating a private node zonelist (nodes
unreachable by default), but are otherwise general improvements to
the existing interfaces so I'm proposing them separately.

No functional change intended - purely refactor commits.

Verified on x86_64:

  - find_next_best_node_in() compiles to the same 319 bytes as
    find_next_best_node().
  - Both mm/memory-tiers.c callers grow a single instruction - the
    added argument.
  - Boot-time fallback orders are identical on a 4-node guest with an
    asymmetric distance matrix.

Gregory Price (2):
  mm: refactor find_next_best_node to find_next_best_node_in
  mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()

 mm/internal.h     |  6 ++--
 mm/memory-tiers.c |  7 +++--
 mm/page_alloc.c   | 74 +++++++++++++++++++----------------------------
 3 files changed, 38 insertions(+), 49 deletions(-)

---

v2: 
- drop extern (Vlastimil)
- move printing into build_node_zonelist() (Vlastimil)
- get rid of node_order array (Vlastimil)
- drop update_load bool (will add back when relevant)

-- 
2.55.0


