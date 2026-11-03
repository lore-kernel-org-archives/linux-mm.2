Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A841F606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=J7tCpviP
Received: by kanga.kvack.org (Postfix)
	id 1CD8E6B05B3; Tue,  3 Nov 2026 17:31:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DAB6B05B4; Tue,  3 Nov 2026 17:31:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F113D6B05B5; Tue,  3 Nov 2026 17:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B30656B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:31:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F12B4140588
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:55 +0000 (UTC)
X-FDA: 85395256590.18.54BE6B9
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A2761C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=J7tCpviP;
	spf=pass (imf21.hostedemail.com: domain of 32GDqagcKCKEOIVIVBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--nhuhuan.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=32GDqagcKCKEOIVIVBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793745114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmA/Tv3awqiayprrH2/NBc4Xl/piE35b+PCQgPAxOS0=;
	b=cLA1iKPh+vVFu+SaL6yBiq3RZpd3gL7LYeWN3IcTm+cA3yaGm4Ax6IO0Y7E18PhprE3ct4
	rOE9bZtA6aq99kawu0YJg1yaiDmoc1HmWUhlrcVXOvLwzVnhzv6bMvWhnG8/4sKYr/aKZP
	fXwCpyTgtUn5kvJwrjEMx71PE1bjcEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793745114;
	b=xLBj5ppKanxfjYfDTCXoe7ixnReOK30uEhBMQsGuqNzenm1rxC+r///d8h2/yB2YFa2uB6
	TZ0Dz1ldZpdUeQix6Pl2OvhqhWTtbbo0nRvZ6cE6E8cU8xJnR8429Xk9gQehwzcEeEj7XP
	ixaJhLSJHkHoNsuZmdg46RL2Lz9xZAw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=J7tCpviP;
	spf=pass (imf21.hostedemail.com: domain of 32GDqagcKCKEOIVIVBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--nhuhuan.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=32GDqagcKCKEOIVIVBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b238436265so87373c88.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793745113; x=1794349913; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DmA/Tv3awqiayprrH2/NBc4Xl/piE35b+PCQgPAxOS0=;
        b=J7tCpviPFlrGz1mp0PW/J2DfD/R1Z4jFjyWJCj+Uce4NZxvGkKR/w4f4PFT617+KA5
         t4xGfD05ox67pUVpzk0O4ida0dnkDZJO5pJKDSSnXhk499RQEMDreyQKm6AIJKeapc9A
         TrST5XUPY7bh9mvfFkMmZkHATPAgFCIU6RxK3zgroXOkYRVU7riY/ut3D/DRYjPQ4jCJ
         F4Wby3/ekGD3/QOs+o8FodGnItJAQ1hjBw7cs/lo7PDirj6bBwxeTwqhD+cRoB42FfHz
         F2A1x9a1iLa6ySbRdq0w+xm+VLy0qn3K+7t7c5O+TDXBapg3cH0KEhZaZBmA9fUwwdH0
         19YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745113; x=1794349913;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DmA/Tv3awqiayprrH2/NBc4Xl/piE35b+PCQgPAxOS0=;
        b=glGaAf9LUdmgQAjiBdPN9U1Jyf2SPXxs58nlRI7ffrD9fvmI5bNluNLUJY14agjNzI
         oAizOKrS4/izgOwt9AXGzyj4yYKRx5Y+w2nbmZNc+/ayDrPxszT5rwWAB7t36JrrI2lG
         IEokyUh+6ufiV9F7T16d0XEU3tKBsiGaWJu6z1z7aNEEXs+t8sqHG3TvMvA2KktYdqMW
         LRfSIMiYyZX9VtK5t6kJxSb8u+lr+NxpW6sdkfEd70fFzc+meila/4zI1PpXbWr3t8ka
         aWG2I9DP6AfHFNkY6sBhkSqVghVLnR02aYGOBNlku5AjFObqkzUWviuiXrS+DQ3AF2Pp
         UlOg==
X-Forwarded-Encrypted: i=1; AKwUvBxK+copN+utzh4jbLh3D8lXx+fBV6D435WOV4zVYxf9LAATpYKd7tQUFN908hXW1rlIqQXxWiBrKQ==@kvack.org
X-Gm-Message-State: APuU4Z+8ixdPGPDtYHk5avzYn7vAbsawotWf1VuQYuAiLXYCwDjQsvIO
	9nCnNk10bjqK7xDPnBFWDracIJOUTQW9xvwZp0fqHfrh3P0aARKeg1QOH9E4/kbJQqMKXS3+G0r
	eXa3qNfkB6w==
X-Received: from dlai3.prod.google.com ([2002:a05:701b:2703:b0:1a7:6a69:e56b])
 (user=nhuhuan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:2094:10b0:1a9:f3d2:6262
 with SMTP id a92af1059eb24-1ac5d69f68amr21601092c88.36.1793745112607; Tue, 03
 Nov 2026 14:31:52 -0800 (PST)
Date: Tue,  3 Nov 2026 14:30:25 -0800
In-Reply-To: <20261103223025.2482227-1-nhuhuan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com> <20261103223025.2482227-1-nhuhuan@google.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261103223025.2482227-4-nhuhuan@google.com>
Subject: [RFC PATCH v3 3/3] mm/vmscan: demote folios using non-temporal stores
From: Huan Nguyen <nhuhuan@google.com>
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, jackmanb@google.com, 
	hannes@cmpxchg.org, shivankg@amd.com
Cc: rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, 
	fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, 
	sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, 
	dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, 
	nhuhuan@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A2761C0006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: t7tn7o98yeqqdygzyipntuoox43cbihe
X-Rspam-User: 
X-HE-Tag: 1793745114-781405
X-HE-Meta: U2FsdGVkX19E/ZvpQxNZpYQgG4H2LGi3jkwHRfriiQ3SuyOS9SbgJSaBC+4QSUQveCmhR4DpskqSneDYgL7gg697r79aoqoiILQm2f7vDA/mSZ7MzTjEQii4pdcnCYC3CJGcQYV383FmkXyE7lAK6fDDOmXNe2S6lUvxWYpN2/0QLEFzABpcXvgj2AKm/e3dzhCzUZQPAXy52K4cCzzq06ImhWJ23ffePxApsv61PcFeRL/RYqslztgboCwFPHQlvqn14LbBojtMVmNgSryPMwG/GAnOr4X5LDLDQ5S8FQXz0FzjBTdijGlceUc5g/HvDzoWwP4o7HZYg+CMZDiEw46JX3wx84Z+nUWeyRqDnhFofJSZj2Q23Bj1YbZCs0ixQEnRR1nYgEn5xmGLRPBEED7ZlDNy9JC26l6BtSjLs2ervFtFc09U6+TzLr2goCfOgT8SHybYGJsj3uSiibzrbSQ2qJ6pDUNH1bPmU39T9V6AAeNBJTjdWu7FxMhQ7lHJcsYYB0pGqs3uGdq/yylJ7jsqcYsVbR+LeKc5xt1QNmsI9RA/cxEAwP7v49MimqttWyFelHpgNdt7+3D6YtqkMzDq7S0UX0A3GDXJJosYTjEFpYHUerVCHiDjd2I6g1IJ5mum/UDjOoXuz1GWK/cReq/M4+vXlR640u7uohAJGEY2IiUjAyDAlRpI+MKrAOca7jbOvHWLF5joRM9j1DJlXis2ya89Qq/9A92Tw7cuxl3zU2tyRIqn13tnBmYWCFsM3CtHCnO+XPme1lLnPE3CqI9XQ7GpkZy4SJF/Y+UsWW1xlXzD+r4DlkSSjUu11vDgUA+wbASg+aSlPIpvPBrN6meINd8LOMzkShUQL3x9swWv5e9fE1GVmQ+dxhvl9noWOsSLXC6eveSLgXqqaqnwuziLQtxul3k1Sh7dWHlbVrJsQBML87+kShK1ZjO1e0KP2WyvzTQaibsrrms0Zlz
 nXOa93Cc
 QgGN5Uuanyr1bkJf3Ex1OeHtVn/Nn31VTItJEOHQueL1UfZZwDTjIOlUqIky+h00dPVb4VOkZnsFgLP376pLNGWvWPb6C68UShGCbhSgmrZzidPauQPiSwOhGlQ9nNFzv5RrviTgJP91RklWjSTagNv5OGl16NyLE7QA0Sb8IJZyj8fMniMg7ZD1v1qcShIZ/z8Sm2vVIBCNq+0gibuuH3TbSGv0xDT7bfFMKD+5VOlFooJDyUZjMapdN2p/fmP+sEZA7IVKRnVmNFOT/NbgkC/BwqnHcTxbXxSqB1BNAjJhUg8+dJl/L80gdvrcZtuEkosud2J9wqmOlM64DgcPoxUk84ubxXsiQspehciHO9s+K9V9zt3pPvv7YblZHwMxf40B9QdJnQk8mBZS4wMTUwFnwia47NzKMAql2HAoz1O4E5PIa8i7otc68RxdXcO14S9jb0Zt6wRLUZySGETm7mFrZ/oNzfxD3J8Q2BwzZz2uZDoLSPrvniYtKZR1nY0BiGr/64glYaDy17AP71djY/W+blu55l0pBULoCMKBnZSqPOTV4Yo+R2QnLC4JrhQMLgdmh+vHygCSoN3wdmTz9YffQ/39EpV786hEfm+FC7vEc6Q9b5tkR20PM/DJ8U8g0zRs998raCEQPOQjmXbH074YZBJDtVDqtAvC5otv9MZYCCTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Demoting cold folios to slower memory tiers using standard stores
pollutes CPU caches and incurs memory latency and bandwidth overhead.

Update demote_folio_list() to use MIGRATE_ASYNC_NONTEMPORAL, avoiding
CPU cache allocation and improving demotion throughput.

Suggested-by: Alirad Malek <alirad.malek@zptcorp.com>
Suggested-by: Dimitrios Palyvos-Giannas <dimitrios.palyvos@zptcorp.com>
Signed-off-by: Huan Nguyen <nhuhuan@google.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..b44b7cdf8a03 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1134,7 +1134,7 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 
 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
-		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
+		      (unsigned long)&mtc, MIGRATE_ASYNC_NONTEMPORAL, MR_DEMOTION,
 		      &nr_succeeded);
 
 	return nr_succeeded;
-- 
2.56.0.398.g882cbad275-goog


