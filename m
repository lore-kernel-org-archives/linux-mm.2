Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5659560A3801
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Y81hRksu
Received: by kanga.kvack.org (Postfix)
	id 59D886B0A0C; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574866B0A0E; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2526B0A0F; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25C9F6B0A0C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F6D11402F5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:45 +0000 (UTC)
X-FDA: 85351758450.07.6E9E500
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf19.hostedemail.com (Postfix) with ESMTP id 84E571A0008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y81hRksu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3QpPaaggKCDEQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3QpPaaggKCDEQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRGmnu+5Eb3jc4pybJnePwOeBfzJdgL5DEYasCwAfpw=;
	b=bQjF6Dq7/NSlYUIJRt8lTFmEVmFa/AEERXQdBbmM+EMXQo0YWvG5pjPj1Q6Bu8oGJsXGBF
	PbuCL748PjGr6gzGcPE618eEiJ3G8qmlecCNNZatYGsUMGb9/ADOl3YaW6cwpxm19VELqa
	E6H0VZYonzX1ao7esMJ1AL67y3Ude4U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y81hRksu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3QpPaaggKCDEQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3QpPaaggKCDEQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709443;
	b=7evy3AZ4E7pPzeiWerqb0Ca6DypFigLPeoFR6Y7g1dnQd5KY16wM5vXlygdFNFyWqtqZ81
	bUNYxxkOHYQYIS2gn9W+7HFMvsdtBzmQWPBz4MLZuHMXpM91zV0gMFWMZvDRLeHuJQ4dwW
	wcHppzklCFsRddcm8cWaBpbeXGQovCs=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e93e2f72bfso2654255ad.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709442; x=1793314242; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QRGmnu+5Eb3jc4pybJnePwOeBfzJdgL5DEYasCwAfpw=;
        b=Y81hRksu0SmMYsIQzqyXM3YTsyNIDuYwvo6YUJaomqIl1xxSyU08HesukidS6xG6wu
         eT4JSylWL2Tqshp6wIrKIAsrQi1ESrvvcdHCdfS7lUgLIhr2nJyxiJstEJ+szsPq5l/9
         JHUWs2rJRItO/lmCyFEqk0xIgzqvS3cf9PL3LknXMgSpKQjXnKs5jiFXZfYYe9zEU+Je
         ko9j0TrUlgjvokVZQ5Z2hN1SFeuWb+osf++jH7504xxBJHeIe0Y9Ajog/EXkloXU+X5N
         2PcuBPV9TB67KJP5CdYhxubymgQaq6dymxfc+6LTA+ff4DdlzHW7CWY1rJXwbzaQT5Rz
         L+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709442; x=1793314242;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QRGmnu+5Eb3jc4pybJnePwOeBfzJdgL5DEYasCwAfpw=;
        b=dnU+yM4FVDMcYxBSiO4ZtD6pcz1Icpu57kVl35oNO4MIFvWqcj4odYitboVgo+Yylk
         JdLu9tL4ZWfXvUPs1RIBAAiF8A0dNJVa8B8v+aXfDZYFyFY0wv1VqmDu8s80DL2CRjaD
         x/ElPZqoOoGBEZtJeWEhR1pv4HFvhIArwatTQ8gnHaOYrHOyR5qnayIghhPc5+1wrJJN
         v3GX5S51wptLRKF/RDV47LuvCpm+fOSC6u7M8qeCrITdDSSFuOY379Th063Ds2gvM0Wq
         ydCURBSMslHUM2ohTsFyE4vTqtYkmR/pKGplta8ERlacFUNxO9iaqdD5wdVUWrox9Mnd
         ZLsw==
X-Forwarded-Encrypted: i=1; AKwUvBxd3rUJ573t6qQSU9UNEOGEYhTcNEnr/xZRdSsPtIEMKomLf0GEAEwvMF+hR3FPYlRKpteARi0trQ==@kvack.org
X-Gm-Message-State: AFq9FYI7f7OmzPznMAbpFco4F/rag19GUyQvlmBZKVvRVj6eL0Fc4R9x
	ljsqByLPeoIK3UcgK8ZxaYWfg9sZC70VCV3/sfCdS6G65shUcFFYuWYQCfdJCh0lVGnyiqqVohi
	HxjrXCVFh+IPxTQ==
X-Received: from plpa12.prod.google.com ([2002:a17:902:900c:b0:2e4:8c0e:97db])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5c8:b0:2ea:192a:13b8 with SMTP id d9443c01a7336-2ea7d09b8ebmr5151125ad.20.1792709442296;
 Thu, 22 Oct 2026 15:50:42 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:30 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-6-dmatlack@google.com>
Subject: [PATCH v2 05/10] liveupdate: Don't WARN if tracking a retrieved file fails
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 84E571A0008
X-Stat-Signature: 9rnqn8aesnskdbczutrwinkpg9pom6ic
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792709443-304965
X-HE-Meta: U2FsdGVkX19QYMtsHXQ6rlgltwjdjSfRpXBvD/cHc/A7F2DEWuCDbRiM3jMoajmZFVD+s9uXA/7R890adhO9jgMuHrgzrlhnutnDHeCkaZFdP8f1nD60Ce12b7k50LBaR38bBkIjQ2bfnsvPMeNjLZxAWdiQpuyJj2f5ELLlSE6aUdpZ11VO+RXZ9ApyRu8UaZPLRC/wf65xEFJhAafhBzKXYOJnyEHxb45e7pizJj37Us9WL4tOk5a5JO5ir7hGtCuvmhT+tsXcpvBN8ofFVFklCBS1juaZMVx8SlgEWtDqoq5PJmBRacQ2gnWeCN+0F4uFud14boYlyubKFEs7aLFU3mr7xBrvi6I9jkIuokVsUW17C6PdrMOV452HTzoQ775OHAHo5ZeO5/xnyjZ0iwIzxUSL4kA8rjuCAoee+DaXSszv+XJ83pcyoqAo9nmER0y02v84a8FlfMvg7F/dIA2wzFyatAz2vhcs/Q8DXYg1epAmSIRWOv8TU2/lgtZMxBIlklbF+IC2luFJj0Ohp+sXs8BdIm6r8rj4YsszLepRtusvpbMZi0atm94RTaE552iEbzSgFwDVD/NG1hyCdND9O8tLDJAMgSK1u/u7a/BPjen2r4AS6iztM3fy5+WZpvabjjLit4S8opt8azQIJVgZKtSnAPZTx7umGE9Ip1FcMYonvJKw0Ro8QidbUozjU425xqj73JhwtUOHKbKqYs30ZXOtuLQHjNHmAnQXoih5WI509SNi7tccSN3lfxAjEZ2ZJpyFgRRj8CcfRkFFZ7gvEzQJXhl+yh79Iwn2ejQdiQJqwj1M878UGdv6xH1Vaq5Dt591YG8NXg18nk8UZWNhVOeeucI8nGoLlLteNOYhhpUn0OFKFVL8DsCpYJY17JRvYWY5D8Ty1mlutOyZGX6K+twpXfM7Fx3WfLqehj72vBSFQu5OJmSS0d2bh2PEssjhFVZCLUAFKTXZZ3y
 WIyGf17X
 xRDHoRJCmoFyYCOJWrgbXzWXl7in3XtDYOm/kNF2/MV+UmXtcc2koasENT4xmku+UFGWbyAgSUATWV4L/JY6t8kbCY0icfD7AILlsPLo5n96YloMojm8QlQpovmaGGKayrLP6q8z0k84qAMBAzksJCCUaDL1J9kOTdtsDO1eH3Smkq1Uqs9Z4f830IosnACLBXB13laQmfvbs4DLf6ZPZEzo+hp42KvLfsowA0Yi956u/xhqTkvGuYhdDR1FB3bWImKsgectrkDeUq346Nq39QOfXlDaeNgLvI3pOM13YQDW1OjWLfuuT8mB8zoSAl69jP4f82Uofcpcgc/AkzF6weSqbeH1DKw58qnJsAMuHx7kQNFnsY0kg1uHG+0/r2GCtyVERvPNbZTYmXViSXx8Drna5tBxPNd8abNQl5kvyuYVIME30w459psOky17zg8b3kOxuKC1txOIwLNe0+NVChzPNFQ+cfvZY/86DehQ1Zh0BKDrkyk6NorbziXLzZ45BYywcf33Q1zD6PNL/B7rNRFAlzcZ39gnaOenHy4xdvwnSuSRF6vZHuBfCauFP6TRLgVYWyKdT7zs1CrQ9Ve7CmIVhJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Handle a failure to add a retrieved file to luo_preserved_files instead
of triggering a WARN_ON(). xa_insert() can fail with -ENOMEM, and
userspace can trigger that with LIVEUPDATE_SESSION_RETRIEVE_FD, so
warning about it lets userspace crash systems with panic_on_warn.

The handler has already consumed the preserved state when this happens,
so make the failure permanent. Keep the file until the file set is
finished, like any other retrieved file, so that its resources are not
released before then. Finishing the file set then erases the file from
luo_preserved_files, which does nothing for a file that was never added.

Fixes: 00d0b372374f ("liveupdate: prevent double management of files")
Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 kernel/liveupdate/luo_file.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 908ae124ea5e..5a82e45b9062 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -684,14 +684,25 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
 		return err;
 	}
 
+	err = xa_insert(&luo_preserved_files,
+			luo_get_id(luo_file->fh, args.file), args.file,
+			GFP_KERNEL);
+	if (err) {
+		/*
+		 * The handler has consumed the preserved state, so the retrieve
+		 * can't be retried. Keep the file until the file set is
+		 * finished, so that its resources are released at the same
+		 * time as those of other retrieved files.
+		 */
+		luo_file->file = args.file;
+		luo_file->retrieve_status = err;
+		return err;
+	}
+
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
-	WARN_ON(xa_insert(&luo_preserved_files,
-			  luo_get_id(luo_file->fh, luo_file->file),
-			  luo_file->file, GFP_KERNEL));
-
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
-- 
2.56.0.257.gf7497c7d27-goog


