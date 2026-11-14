Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B625606A88E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SaqIRJoo
Received: by kanga.kvack.org (Postfix)
	id 9F7F66B05B6; Fri, 13 Nov 2026 19:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A88F6B05B7; Fri, 13 Nov 2026 19:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8491F6B05B8; Fri, 13 Nov 2026 19:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40B9A6B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:30:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F3471A030E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:30:03 +0000 (UTC)
X-FDA: 85431842286.25.353909D
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id CAF6280002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:30:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SaqIRJoo;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBroOjocv6eBCvG1grylAnibv/9seMQfy8rDwVLFt1I=;
	b=1QN1VqhW/kV0ZUqdzXL1vAyXpvjEv+9poUNd1cyVlL+hmGsKRw6Mc1yftzM+n0lFkPHdxD
	S3vDIMIQ8uMq2N6l4yRY4sSTgVgWFDqXvj7krYrEysrm29CKmW4QN8CC8h9rEaCRxVIlF5
	AFEHjFgV9GZA5bDxG/SnXE2a1QThYkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616201;
	b=TCxgx72e/w9T4msp96/dUwuFR7wyWZQki0HlFbDJZZ+SUYq1PWtyTX9I8s0KKWQ7AtdpPz
	oCNWmVBUGNfxalDg1tG2FQJ18nfFIXnu7z+y5h671JEfiKY5BDWbAymEeRn8He9Vgn8gOr
	p77d0JgbLOK7rhN5NwhLUGXhnXOODng=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SaqIRJoo;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67c6f1019a3so1971727d50.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616201; x=1795221001; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBroOjocv6eBCvG1grylAnibv/9seMQfy8rDwVLFt1I=;
        b=SaqIRJooQOSpM27RcdWcCMhluMxw2cKaH8ymAQ7AT/FM7dwk3CshWrTUTG49PclzLd
         A0Nc5KZftBpeYW/Z11NcaduMKTVKNGXpb8yBez1ehK9gte0YaIVUVRs6355CZX3WJmf5
         K1TkTiiKRY4cQyD5Sev1/pFljgzKptBliqW0ogNBSpWuOMNnZZgXTiYmqwesqWEqQw+q
         1tV6IWLTyZtJeA2X347caHJf+qITpAkjGBLNJZixjmI2Q0BDbXDCht8OpQZpP5uo9Fwk
         9mb9nO0XWImzHHR8DPJa1JxAVOoRr6sRybmpJdZuyCHMYgDpiUYaMMqLDqkeGjSgBH3V
         wIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616201; x=1795221001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBroOjocv6eBCvG1grylAnibv/9seMQfy8rDwVLFt1I=;
        b=LTvGaGTk4auPJMleJhgtF34lpF0fVEGFvDsWrdljXdpGjkYHOTA6kw4Rl4Cb1GBjNh
         t24EpiPb7dnb+kzKgpLaJgahiAuYtn4fx4lD2U23BMm4jy82WaH36MmYpw2O+YmwK7Ee
         VI1vNqaMil/PE3UaFN6mriSQJS4+iV+VlFJgaty7HE95fwzpe18sGXIlHTVLXnRqPvgM
         GAImYOrM1LPenSKG+sb0KYcPSvjG8+URc2qA3ZkXsQwTcghS8t9fTn4ujWUDFRvRJITW
         1W5LEnic3oyXTAoY5C9JpehyzVR9RX+wC6u2tDDSiXqBhTS8gvrpBRfeB2Y0EOod6isg
         9ccQ==
X-Forwarded-Encrypted: i=1; AL+hErH4n1vQs4NJyN0c1tywLBJApr7SjOnuNTnHLTPWa6cg0eM/d1sGrETABOyK/kLpNr7ZmuxewClnag==@kvack.org
X-Gm-Message-State: APuU4Z8wceUpKWVvsPtJWsK1R+lK3varb2I5t6ZH8hOdKfdHjRTDKcIC
	PF/JTfPjNgiCbbXjaQR/16yve0Z9XdXMI/FhR46Kv3ckDdmjGOu1/LOB
X-Gm-Gg: AYBFou2sdlY3686N8dpbB4iF9PR0S505bX6HEPL2PyOpYaU6I1IbwlYw9V3EezrNElr
	wHLTyVgoaBsP2nBUdCA7F49Cgp8PBP2IUUnsZaMMZ+sbwqurOQF+6LZXNg4IrhkwJKB74DxbwpO
	DyiQnkuythcAEUmSOsVdpN92q0s63cOq8LAYkEcrCdLZVr3LhAce4T7X1xjLx3CEoh0Wgoecjyz
	KxSan1tyxosKACeTgW+qYLiTTDjLJjzmoJUAq9DUKWuBB8ts1ijdQdrwGkkeQCok5imfYlsP36y
	FuTTRfBnpvYwh6138+WFJQQZ6y39HzcTfmJvQo0BxC1IIQEHrQaf+1fM/TPMwGY180oEWuwKRIW
	OxidoxPWG1Q+KzrDr7iPVvLeE5QpexOtLbeg+vSFbTVWXhaynnLojrz5Zeet30nA8oZcFw2lSjY
	DykwAb1WNoQoCeTkKDNJ9NfiBGkxSVBPuefaou681Zg1DKp9OHmK0wAyuZuzogQMFyZnNYSA7GK
	R7CeCWHCCsROIZVBfZjEBlfB0O5c0T99aOj4cMtW/bd6/2UaylSu8jrbyJCBMKjWtVIhB3+JbDM
	xArD9O6kVu0/TfiH7rExgIvMqHdkIaH3tg1WNR4lJ0HC20oEBHGYN4z/hLn9NJu9iMPuVq2f+og
	XXmaU2bW6NBvZDdh8rrRWyEm9Oxw=
X-Received: by 2002:a05:690c:e251:10b0:8b3:23f3:134d with SMTP id 00721157ae682-8b4aa2b33a1mr16832317b3.42.1794616200944;
        Fri, 13 Nov 2026 16:30:00 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa96b441sm33820597b3.23.2026.11.13.16.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:30:00 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 3/4] mm: workingset: skip the root memcg flush in workingset_test_recent()
Date: Fri, 13 Nov 2026 16:28:21 -0800
Message-ID: <20261114002822.1043378-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CAF6280002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5qe6p9x7j7hjpedbr1dexh5fzxojqwgp
X-Rspam-User: 
X-HE-Tag: 1794616201-897191
X-HE-Meta: U2FsdGVkX1+PhtiGs25iGZNSMsaOZAfAxn0gwdwB8esJokwrI59QoWXWPDsydh7u7n7melZHsZhkjEW/ZUxtr9E7RKa77jAtNuJFM+HMZaIHmRp5mQhCyhNFlxyZznWA1uelYzJt/52pUGhJMmlWb16ah/wa4evrdPuF26jiXd0+VHBxXuNauJ89U4e/Z2qIDGZf0t8sf+LnTLKMt4nhFx6cd6rUVszscZc3ZaC8t6T28Yuex/50Xws56paLL3kcBxpkMdOlbj9TC9u/OZTJ3LdejCBtWCpAEWEUlHukd/kaUGEqXz5ndOUGESjnsP2vHMI66T7sPGjEgitfhqimbpHQjJWkIPfpu5Gir7/cNvzupqG4srETbcaheG5XEfyx6lWEvo2Uvc/FjxqSza3LPhdq+4SwvlA72Y9lf+VevcaG/upG3y8tWmspruBLZwMrNmgrg9nXYm1DyKyJnOVyHJ/ToNNDT5OdCsosjiz/MqXkX5uKg1c9wKRWk5/WQLMeW33pPqvtSq3jSRjU93r4GIwSsrlFb8DtOip8RlRMnKrdkWiUwKoUc8rTbAvjAuom7ZePpUArpnBpkHsEvj2w4GE/PTEWiqs5aYsTlDEqBjSdhRC7q4IzXfccNO+WcfridlFQK9JGxIa6puesdhUrlZUniwQGewuO05BIYoLOvIHbBal/gQUMkso0MaD7clajIXY3RX414l76L5AUe9qR4wi5WirU8ZL5/r6lSFgEY7mTWo2eJ4BjE+n8ek5l5BBdu0YKaGLbUeCy1fYqCPHV8Z4IP9z20OkIaD/0l2I3JjO13iHGXSBkaTITnht/fSd8Xz9Af40dD3W1R6iIESkIrkPZoqFITo4Xw2k/OpjENWB/Xle7bHPlY0N2b27x7HeJMVpWIpBZbcM1o+kKQ3y13IxUNRv8M3062O5ZFa4FlPja/uSqAOrfTuYW9veEwehtzgv2afL+4BUyyDxKc+I
 n3r0D74w
 rkl3bgQebHLq9vtolPdWiCVJ270IKZkjVLFiJXXE4VfQFzakaE6rFko/sxY9Zi+a98ZoGOR+omzyH/ckOaXZb2vOCbnu+m+Ynk0TI2/qwrCSt89LVu4GlwyfRIUMTkDQDZG3Kfv6IqCceJneIV6oWJ6bys3+LLSkMyYk4ZRlVF9W5EG3ZmPCsjOmP4akeNmdk42WAgjC61tIk3E+Sz77gFk7+KV15FqAzqGIe/tH4+fpJxDmJ9o5Okzy8RLnVqjSzbKs4NzjKVXUFQmZhMMfk3t+zzHzEseGnj8lN2HQu+qb1tAQYKe0ImuvS//VNks8V17zA5bX7nVze08gtc4a3KgZRDt+uT3XmCVyEwoadCYuRN8WPs3estPZBSvhvXThYBXbQ5wCL8xuPMFBifv0vETFnzPyz1sMiPXTdi6jLv7F2tEuBEpNTh3J3OsSshsE+DoIGtIca31r6xxWMu8z1kwFkywBvJbRXvLTG+okIZ6kIhnKdxWsr7u5pCqO3IvnIhIX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We can skip the rstat flush in workingset_test_recent() when the
eviction memcg is the root memcg. lruvec_page_state() now reads the LRU
sizes of the root memcg from the node counters, which are always up to
date, and workingset_test_recent() only reads the eviction memcg's own
lruvec. This avoids an expensive flush on the refault path, as flushing
the root memcg flushes every memcg in the system.

For reclaim however, we still need to keep the flush (for now) since
global and root reclaim also read the rstat stats of the child memcgs
they scan, which the flush is needed for in order to keep up to date.

On an 80-CPU machine, a root flush took 69us on average with little
cgroup activity and ~0.9ms with 128 memcgs actively allocating (wall
time, including waiting for the rstat lock). Reading a node counter
doesn't add any cost. It took the same amount of time as reading the
rstat counter (~150ns, which includes bpftrace probe overhead).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..383f951eaad4 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -483,10 +483,13 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * section (for e.g, in cachestat) - these callers need to skip flushing
 	 * stats (via the flush argument).
 	 *
+	 * For the root memcg, the LRU sizes are read directly from the node
+	 * counters (see lruvec_page_state()).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	if (flush)
+	if (flush && !mem_cgroup_is_root(eviction_memcg))
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
-- 
2.52.1


