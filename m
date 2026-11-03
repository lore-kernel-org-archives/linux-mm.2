Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2818E606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=ioYjiNwj
Received: by kanga.kvack.org (Postfix)
	id 9AA616B00EF; Tue,  3 Nov 2026 06:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A8C6B05B2; Tue,  3 Nov 2026 06:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849B66B05B3; Tue,  3 Nov 2026 06:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56A3F6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:01:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D162E1C3A47
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:01:49 +0000 (UTC)
X-FDA: 85393517538.15.E6AE259
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB795C0014
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:01:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ioYjiNwj;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793703708;
	b=QX2gOtNNLkvUidhj4jyRwqawNhFDbR4JC0AcwvMWyWxVpGQKmRm1RBLj/QuJQMMbreMD0Q
	iY+KQEjUWYz1ZQ6E0nnB5HlskA+29XS+Q3hQt7k19fbyM0zCK8jEkKjgVUVXfKt8Pirte0
	JdfT/1+B4gyFJXSwOB3aDVEM+x3LaKw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ioYjiNwj;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793703708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i4BuV+xJDMpt+a6aM2LeHcLbdcGLw4EpHreAM8/xql8=;
	b=OuuCkpOkD7xBA/W9aZFp9BHM5P+dNtDfrVLL09cMgV7m2XtKXV1KCjOnnA+0Jz9NSoR8T5
	PgrGjl/hAHO/wk9cWGk8SK8cQS6ffWC3g4L8iDpeK0Xcgr7QnyUu+OOVx0sAMnf1PNKG//
	LMpDJCWxpFb/ubo+eTRqVHu8zyDeBb4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=i4BuV+xJDMpt+a6aM2LeHcLbdcGLw4EpHreAM8/xql8=; b=ioYjiNwjwOSAdJFv5Po50A1bYx
	doVgFk1ctwHpdDQO+z+sNnAm7LWzJPDrauq6gPShnjatYu9jowV6PvokkkKn8AwyWrM7/HlVfdxrE
	5wFOetJ7vF8wt0+Ljy1ffAGy3qXWthdXmjSGY1QzaTJq664DmLWeao7B3fKL+chHfaL2Mypalisx8
	R13F8XIGJOzvtCTYPiuzvMM0bLRRTOssy1zuITm81LJA7EoocCOx2fGTKAU9XxU/oYMsGMR3iwQcS
	OahRqcibjmlH9pdwIjU2OEHqPhRFxtWLlCJ07vP9OMEMMou0IyV/YrXsxGxbap/sl80Ij3RBbpL9r
	pO9g7E0Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOCGf-006t2e-2J;
	Tue, 03 Nov 2026 11:01:29 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 03 Nov 2026 03:01:24 -0800
Subject: [PATCH] stackdepot: don't WARN when the depot runs out of pools
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org>
X-B4-Tracking: v=1; b=H4sIAAO/6WoC/yXMQQ6CMBBA0auQWTsJrdFYr2JcDO1UR0khnYImh
 LtTcfkW/y+gnIUVrs0CmWdRGVKFOTTgn5QejBKqwbb2bEx7RC3k34HHoWCc+h4/lBN21pELFxc
 NnaCmY+Yo3317u/+tU/diX34vWNcNn4LwQ3gAAAA=
X-Change-ID: 20261103-stackdepot-full-warn-b29a9d89f1a5
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 John Ogness <john.ogness@linutronix.de>, Petr Mladek <pmladek@suse.com>, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2785; i=leitao@debian.org;
 h=from:subject:message-id; bh=jwKDCBiNKXRhEaThEtOoJhCUew+ugIivFnvIfhhvW7Q=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq6b8GPtCfeSXEGwKr/Xa7cW/D666cXD6f+3aqD
 0wnhqL4Ge2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaum/BgAKCRA1o5Of/Hh3
 bVVVEACRZ4nT5VoeolUZDwdLgwk6XlE5pHtEM/hoUYB0ZwuZRy+EGwFeozpNhqbQ5W3YMoV/wGx
 C6FNk75KD2U9qMefo006+JxeuLOteH2B1sLXVnGcBLZtgAUlZIE97m6T0n/mLRbDveh2Ml0agXm
 UkRSjPf414rufLQpCxGZm43KW5B47kyb/VxMxAohW5SBEhF9NVXR57Bq2igDC4TqheCXZN2tuDZ
 FQPQg4H/bl+wl8USDLA3OX9JMAhbsbs4wC2Vz274Ta1jPNcr0qu0CK261jC66mima6k8tNCTiFs
 ip5tAyx0KVDQYCe8/AoJWfq6xAE9GjKQxgb+bVsdO7TSuc6A2ikc1CE38NPxTtfrJBnhJOHh6oJ
 5B71JiFyXhQoAOPvZU4nm2NrvtwiJQGbhTRiSCrs5PbNK7bxUXfO3xU/ECr55M7TMyadaRSabsi
 /C9Z6hLCCQkYrQbEZRfqkRQZbF5qbayw8itsdIZ3swqTM2IqydSafD57oo5Kn4vym4zJXw5Mby3
 9DF9l/EMDoKA6lATVyxK5eypBM/57ObceO5+PjBvb8fVuMnS90zkYzAgxJXoHMhg/jINSlzr0PR
 OCkwJhBzdMAvqIPyCgp32/UgQ/4/Yrjf6YdByGJetfseoa8haMMJSyix6CTgqYLrBgNWOAnFPo3
 3OploLkI7DYpHvQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: q4bfxdzr5chitg4a77tsyfpkda6gjzk4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB795C0014
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793703707-455612
X-HE-Meta: U2FsdGVkX1+UQQqzsqI3QUQn3byKgE4D9HQFRb+nFruRga5tMont7aRg37RFuIajcszvDyy7EUbYVpqne+uTaWaKAhjhsCsjmAzUrlBATBndHxlolB9nCOI5aOERajWI2nXhKgAyIU4g1cl4cU4JJlgWj27kE5poiq98BXfiV9NBmqvMGNGC3vZIBZe/m/nSuZmU8ErdYF0ymWlx6kWFvS/rBG29KiaqYigBRlBj6odxuFY4W10Ds1XBrhQpxBNskP7IuHNKQx2Z8V4sSpZILhVH5h5bUN46GjFQycZIJBurbCbgk1Q2uJ/zQPS3KAyB0jjm3iEdroR6D4M42swedcw/pWvPZ0WM+6T3YnAWFaVyHLH1aNOW4mwW1nx2j5aTpiskXwEgtuiwhnRX7YMARBuuGTn1MQAF/5toQ26c9LEHYka+8/8FdS5VFhHBYyLxdzaAGKRvln0FPFepqXilPPkUdjRa0YW+GXBckIBqzadhWH7yDjT1vE9zHN9ZDg6eBW3PYOn2yJM+5tXgBHLL+Ge7hEIbSA/MyLHQFV8mbk1x8UFc02cvIDWopqGp9ntpC7oMXHs5mvtZZ7+h5bmljPvGvg2161RkY0R3lotOuxoDqBZ7JWEFQ+EcbMdswK6OR1Huacy3sZ8ossbv4NmiOIzeh1qF3kMQsyXi+imRoce6I0vDQhzjO3ETpkvRiVao+g42gKBVrPmvwksHSPaZifSZXFFZa3EB1O7Fk5p6KorS0Nvai7ePqy57YFAIJKAIiw49oqHo+jIQyce+ZCwzMwy4zxculXEdD/zzqaM/dL1GWtash1MCIMPcfoVTPO63pbmF8XOf3CuIx2YdFufBnGTYzN1sDVgS9j3stZMC2XQLafEZ24KfPb6bep41ekRIrtMPgJLjjAW7PnQyug+ED3ElVFOrt9L5K798QjLr6Dq8iyEieHTJtnLU6yAANg0YjzhQXLfZwTKn80fuZ0C
 bF/3ocL2
 S4GErYp+oB+d2zNVdvV3XT2qsyMYRE/oPpD/fN/cgJMFLqbHB2yyRqdgkoDjRujevF3FmP/6F/OYFLuh0sD9wz3K+47/BDlXi7ayLtHHx9ArMOLxaH2HVAMew1S2LHOx7g7qqtLtKI0cXRRtVxsZYttKpDMJQUOePA4+FrpFwHtUS7VgM13cMMTP3qFEJkj4ImILr7HKa8J1etpGYP0xr+Quj/5r6Mak18BcOKyP8a0DEcKbfJvBcwsNdQLbVPeClmvpE/b8nQJko81nXBmhfoc3FgOrGhJJRLWIvXq6hBFbQaQDlYzdcH7fWldinpJop3P26L5S1BGiPO9CTjGS2wLo/0zczs1od3XIz0DfP0PzIS5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

depot_init_pool() emits WARN_ONCE() when the depot runs out of pools.
It runs with the raw pool_lock held and IRQs disabled, and
stack_depot_save_flags() wraps that section in printk_deferred_enter()
so that it does not print to the consoles with the lock held.

That deferral only applies to legacy consoles. ON nbcon WARN() puts the
CPU in emergency mode, and in emergency mode printk() flushes all
pending records to the nbcon consoles from the calling context. With
a slow serial console (pl011 is an nbcon console) and a backlog of
messages, that flush can outlast the hard lockup threshold, all of it
with pool_lock held and IRQs disabled, while every other CPU that needs
to save a new stack trace spins on pool_lock.

This was hit on an arm64 host running a KASAN and kmemleak enabled
linux-next kernel under stress-ng:

   Stack depot reached limit capacity
   WARNING: lib/stackdepot.c:302 at stack_depot_save_flags+0x6b0/0x6b8, CPU#56: stress-ng-dev/3466160
   smp: csd: Detected non-responsive CSD lock (#1) on CPU#66, waiting 5000000030 ns for CPU#19 do_nothing+0x0/0x18(0x0).
   smp: csd: Detected non-responsive CSD lock (#2) on CPU#4, waiting 5000000030 ns for CPU#61 ipi_mb+0x0/0x18(0x0).
   watchdog: CPU53: Watchdog detected hard LOCKUP on cpu 54
   Kernel panic - not syncing: Hard LOCKUP

The rest of the WARN splat never made it to the log: CPU 56 was still
flushing the console backlog from the "WARNING:" line when the hard
lockup detector fired.

Running out of depot space is an expected condition under heavy debug
load, not a kernel bug, so report it with pr_warn_once() instead.

At normal priority the nbcon consoles are printed by the printer
threads, and the legacy consoles honour printk_deferred.

This also keeps a full depot from crashing machines running with
panic_on_warn.

Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 lib/stackdepot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 90c52f2e0d3f42..dea6338f73c1cd 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -299,7 +299,7 @@ static bool depot_init_pool(void **prealloc)
 		/* Bail out if we reached the pool limit. */
 		WARN_ON_ONCE(pools_num > stack_max_pools); /* should never happen */
 		WARN_ON_ONCE(!new_pool); /* to avoid unnecessary pre-allocation */
-		WARN_ONCE(1, "Stack depot reached limit capacity");
+		pr_warn_once("Stack depot reached limit capacity\n");
 		return false;
 	}
 

---
base-commit: 2637bdec0535a2044cd830eba9a79363651d9043
change-id: 20261103-stackdepot-full-warn-b29a9d89f1a5

Best regards,
--  
Breno Leitao <leitao@debian.org>


