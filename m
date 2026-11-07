Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78028606D80A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VYLeL/lJ
Received: by kanga.kvack.org (Postfix)
	id 90FBE6B05B5; Sat,  7 Nov 2026 11:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7806B05B6; Sat,  7 Nov 2026 11:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6CB6B05B7; Sat,  7 Nov 2026 11:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5465D6B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:57:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C50D41403BD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:22 +0000 (UTC)
X-FDA: 85408928724.24.5F154C4
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFF0D80003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="VYLeL/lJ";
	spf=pass (imf30.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794070641;
	b=PQ3PmbZ1xPGcBioBgeaVDANQp3qzxpBh0P6Ub0UT4vInqZp1vpUmXyKw37AOvIJ/5sR02p
	Ds7gyh0QboA/Zsg4FJhK/E5y6mJ7dhAG1qBjaplaIrj/APNcFPnXkZXX1ngZ8AlDsxtVNo
	/l13sYbHfNpCTucTCDITn5YmP0isYVM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="VYLeL/lJ";
	spf=pass (imf30.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794070641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hy+b2FmS+WOb9VH7r/wCKLd2ZpYqYwoBlahUfl/vu2s=;
	b=J551XYyxGL/jpOzjyvjCarCif4CiFONoNiujxJqvwWjhPocUBeDFoOC+0VXC5XuC85E97p
	ZPgCIBwG/tAOhI1VBiC4/X/Y/k7htjJIfOr74tzeMYYoneQLZwa9tCrKsmnIKMgNLYyrsO
	hL4hq6ErbEmRJWPgPV/zGBZ7G0PLbC4=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1a2761c69fbso487014c88.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 08:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070640; x=1794675440; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hy+b2FmS+WOb9VH7r/wCKLd2ZpYqYwoBlahUfl/vu2s=;
        b=VYLeL/lJSwau5Qak8SlyVVbO3cH6/H+Skh4Co5eb9mL/hin9DyXwFeD069W4PLYLYG
         N5d9jzpn8D4HBuWcqoHk0erB2Gvo/siNsnJLcQwFPPSAEn2XY4Bq6I/7KEyGxcFTYArR
         Ijohdj61RObAu/XKwGcFzI0Yjzlk952huOUCZ8CtteypvumIwcbH9/89bYCnn41x1DA0
         Xk8dfUsM26V7+YRrP4G1XsdWqod3MGMUbCvP8NyridnQXSRnd8U32HTLKmBW9+BCShqX
         rBAFPMjIDFTiKjW+K2ytEXWXhTdcoTDebdY7brn4DQZTYOiTDjQSmB1Juz0eveGHk+4a
         RQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070640; x=1794675440;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hy+b2FmS+WOb9VH7r/wCKLd2ZpYqYwoBlahUfl/vu2s=;
        b=ZxCiq0ZR6mj0na6gEv5IjYlnA0H6Uq8hG+6VWG+OMXjG1tmwtiQ4mf3ug3TBsm40zK
         xpAnSw3SETmFl6vgFNy0lDrej1hjyKgqnGw3Uul6OpgV+N1ezXu9CBSYVv6RXZ8PzpWz
         /c/lEUkIebP2SaB7jYDHCJ98RVjNSyAA1SKQ72V9QMqEL2vEUlSMjhdOc70NOsluKNOo
         YTpGxXUcqNVovrYQib0P6tjEj3kxnLhN2EwcdnVBnhoCJoHbErSdVIXfHvCGcIO915md
         iqyc6UA+Ci0MBmsPa5Nw1Gx91vv7MYkRrlBnLJXTx4yUYnL5vRinKbAIx/7tFBQW2WZL
         gvBA==
X-Gm-Message-State: APuU4Z+V8EeArXn9Cy0BG/uqzFAPEp26/tcsihkBzYSmL8yMpYEynaLT
	czXmriGPorxM8IksBsa7A4MxjA+A/fq0fCZnziMBZtimeShcwKuw0BED
X-Gm-Gg: AYBFou0D6Nj8AAA67MNBA8mpVYoGGs9tDqiROohPQHZELKMzvWAisgpNsWMxHbrcoiK
	3qpQubtBHYh3phA/RdhpCzUPJY+bora6Hfvobp6J7WTl81kPjniY/Y4pxfaAy86i7XPG84zh1lf
	2L50f4gHDV46zFw08B426Q9DS7gyTDoVLVccUudibZfjJ0vYHpXpARgl3MFuFgyhxyU8OAnvtK/
	M7WMpvD8SE7pgnX7sLo+ylegL8TdVoHC87r4XhWfA+AvT8vI999cwvIEmSQ1qimMOOiypgB5/3S
	6eP6WjfY61KP+FskY8mocG/nMODMSil0ryeYXxhHgBA4fvrzZJtlW9G5msmGJohpYtk7JstPNDd
	TeneMDrbDXvuGvxhE/sp6Ma51ZjfH0blOp5SHDY90AJ73M6L1HK/YxIY6YN0HVGU0Gwgwxrw7+i
	ZyXKzfRrqXbN4qj8DpV8xKjIRoQdqYWxonZw/5SwjTZNMGsWV5ylSM/EJ1ayRu9OnzkdfVPn2G8
	KQg/r6ZgYTc4qJkRTPMMMr48RLvG174gMPtF8i9B9wA8YYBuBMbSAjfUwm3sw89hYmOuRP0ng46
	58p1h2EXCmO4e5K/SP4lcMu0
X-Received: by 2002:a05:7022:5e09:b0:1ab:de8b:5f0f with SMTP id a92af1059eb24-1b25d36f9dfmr7314191c88.40.1794070639786;
        Sat, 07 Nov 2026 08:57:19 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4b4aa7sm15456126c88.13.2026.11.07.08.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:57:19 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sat, 07 Nov 2026 11:57:01 -0500
Subject: [PATCH v3 2/4] docs/mm: ksm: describe how smart scan picks the
 scans to skip
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-2-16d5ce8b5fd6@gmail.com>
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 79hpn6rp6c3hudj45w9gnpqdhchawzcp
X-Rspamd-Queue-Id: EFF0D80003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794070640-867990
X-HE-Meta: U2FsdGVkX19kr8so6+HbZfxgeAchtWMm6JGaelONGXW6uMIgD53GLr/2RUSlkn9p/Yjfj83TfuJtWcaCpLUAizpTE9TElqWdG9FCwASgY4IlSvdOdS+gKsLb6j1M46UV5pyXayA/rrbptqY+GcVHbJigCCuwZriekrgcz0inE+EEgOD1UK2tMfl3pW1xoBEpHzAwqycDYMtEERHKgTJfbv45cZdmB8iAQFZ947BAjHy07SLxGTwRZkNAyZmlbTtmhXPGFf7/juRtMp7H/TAknzaZrmE+SuUcP8OENHQTzIFy74GVGEnZ81KsnKBzr4mnZ9dyaLZ1nWNIZV3AYlR99p2+GyaQIODNx5SLGbd0vuJ9ZUW5tI763eNx0g3Br6BVvlDIXeuqGWsif8tDeWVTFQ1sDaCKJYXOszxo8Acb65+UALeSnf8I7D5G28i9uaXy0d5obwcXKv153LerHJRYrNRREgZmq0lUEapEu13u/uYV+FlnS8O2JPfU7Vu+Y861jASpT5oTA5vm0VKPy7XTPnUj/aRiPuFCYEIWXWqu4KNvJv1HWhD6853p+k6/knq7UtlyhQyonycr1YFzVs04ZJX2YlvBJLdhdlGIC+adC7LJ9NMCKtineFJFfiIuw0yOL7cKbMiHGD8zy3LaFdvYBDT/t/caKs8luouEFbOp2HmAzX5Gcy7s/aFfriVep7F80nalIWzzuDS9GoT7GPT4nmSR1doYWZc2PpWp6CmpnBO8+6MzAVgRyQrzUhZ1gmKEmb5EJ2LDA2w+2TEtw4daOVmzIEaZtPzqz/lhGN3PHgXzqJIPHTo+Fzo+fS7SrePZ+jLB3B4LChzQjS3HS5/WUhuN76pfST8HMj1n7aTUhUCE2nmTRe0W3beTS8AFBQEcEjlG5VZR7h+kMV2xzSaFq7vSSg0c6xdtQiAfWQL8GsYAabjWhOEeSMnUeqFABVq8RRd/0gmYW8vrGWGLAmp
 +Eejlshq
 LFzHrmcsdaOlZyyWCajsk0F40xP7tbBDv1G9j9jGS5YheqSg5whd7siZiyPauCI8lthSc1118cCFMDk6Eu301x4x8JPNsY9WgzMu3zer475oaL+TdXQMad13NDjSHwRMq5F9oPRqwbjUYf9/FKLaNHSQty8r0C+0Dm4gPrIVg1t0s8ZfHOgr0usUG1QIDvNZqx8ospz33SSj5CuJLlathub6fU9t4RTmSsg5JJ/7PhcsdghJZlmAOrddrZPO6uV0x88rpNMAeyO8J7U06nwIhZs+UzZBW8nbAWqft2bxY3s4QkjplnmkJjx/XcZ0R04fIRIiM4nRZOo9UbEaIVbyoDa5bkfElGlhX2v2RrQp3h82c6LqvyGW6xpJ3N1f3k/iCGgHiS1daYzs0qMhLcr2fSMClUXU2qYjzLCwVSEAJlW21ecOkflhwrgfzlANYeLMwTpd33o+I+22gyoayQCcIpiH2LO9Y5hePhibHoJqh+7t9nRztc1SPRtUCuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Documentation/mm/ksm.rst covers the stable tree and its reverse mapping,
and Documentation/admin-guide/mm/ksm.rst only says that smart scan skips
pages KSM has failed to merge before.

Neither says how often an unmerged page is looked at, or that the scans
are picked by the global scan number so that identical pages of
different ages still meet in some scan, which merging through the
unstable tree depends on.

Add a section on smart scan that describes both.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 Documentation/mm/ksm.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
index 5a80573162def..f954d221e8017 100644
--- a/Documentation/mm/ksm.rst
+++ b/Documentation/mm/ksm.rst
@@ -75,6 +75,22 @@ The whole list of stable_node "dups" linked in the stable_node
 The frequency of such scans is defined by
 ``stable_node_chains_prune_millisecs`` sysfs tunable.
 
+Smart scan
+----------
+With ``smart_scan`` enabled, ksmd skips pages that it has already tried
+to merge without success. The ``age`` of a page's ksm_rmap_item counts
+the scans that went by while the page stayed unmerged. A page younger
+than three scans is looked at on every scan; after that it is looked at
+every second scan up to an age of five, every fourth scan up to an age
+of eight, and every eighth scan from then on.
+
+The scans that look at a page are picked by the global scan number
+``ksm_scan.seqnr``, not counted per page. The unstable tree is rebuilt
+on every scan, so two identical pages can only be merged in a scan that
+looks at both. As the periods are powers of two, every page is looked
+at on each scan whose number is a multiple of eight, so two identical
+pages meet at least every eighth scan whatever their ages.
+
 Reference
 ---------
 .. kernel-doc:: mm/ksm.c

-- 
2.43.0


