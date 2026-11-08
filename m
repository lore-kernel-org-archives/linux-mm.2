Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3191606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 05:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jhwXxMjJ
Received: by kanga.kvack.org (Postfix)
	id 9C67E6B05B0; Sun,  8 Nov 2026 00:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979386B05B1; Sun,  8 Nov 2026 00:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867906B05B2; Sun,  8 Nov 2026 00:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60E056B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:41:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E729AA0194
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 05:41:02 +0000 (UTC)
X-FDA: 85410853164.28.6630B3A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1AC56A0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 05:40:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jhwXxMjJ;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794116460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I3WRrinu/jT9Jg9NAfoNC4MFsm/rU54sJV2l8lqiR7g=;
	b=J0CZjPkZWpEX5F7YD1w2fnh39n+kJmE4++i8YgiEPhVaSeztLWrasoOQrjjUhbRks/L23G
	pZTL6P/1X1Q0XfXVT9MxnSfckMWfJpXoOdsJY7quXy6BqHRu6bzNr+3bgZITC+VpY4SQgC
	YQ9FkM++8vvuLbedxbbdd6e5BI9Oa38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794116460;
	b=UNUXdmnNM5dXIJUGIA5Z6Rw9MUHrPvFYJr9xPqnWLPDzXg+Tle1pxS4+XDCgiW36vThmZZ
	nvO39Rg0XAEOvRGk+XsM0PZeyd3ACMW8bzQfmIm2lMpmX3lQDsec6hstqmGR+kFyNVA5/i
	i4oQRYp6uvZ9S2OSN7AF0TaLdCliIxY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jhwXxMjJ;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso145836a91.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 21:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794116459; x=1794721259; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I3WRrinu/jT9Jg9NAfoNC4MFsm/rU54sJV2l8lqiR7g=;
        b=jhwXxMjJXYyRh/UmvuXpG+nDwJm+4FK3O7BzcjbryAnq4gtPXxHn/xgHXzp18fMx6Z
         HhrGcxUPmYGeqDLLchx9jN+hNkA0ACeTLW1XEJQG+OU9RI0v7Dg3pwecibs4+99WV1T6
         MYPpLpWdNyeXq9Hym7/qvkFisFCi/vy9afuG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794116459; x=1794721259;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=I3WRrinu/jT9Jg9NAfoNC4MFsm/rU54sJV2l8lqiR7g=;
        b=dqfKNTkzJhrJMMUnv20ueavoLABJyJXfm6J6FCwwjlSoHlrvrm8pkwb0B7nQfSxQgX
         Mx0P/EYqnj8+JjBbQCVXduX8xqwX+w//jsf9/qgr98HgcLNv/cRO3h4iNip/+iIg5Wf4
         vtMcR+SdlY5/ptC68bLvgConW8dKmiNuAJII1niKn9y6ifUXzH3mqI3HNVbQIc7rSFZC
         /3fvlme/b2rn2lfAilo/P/A1GHLb0FrWGNGKfMGtlGbB3iUDMCa2gP1bNEDzA6dlr03R
         UNusg/XW3GWCTe6m5f8qspSqFdwZrVKq8jVXIzORBtnlIZKkkAOZaSSC88UjHDcucm/S
         ffbQ==
X-Forwarded-Encrypted: i=1; AL+hErH0rkyrcVldPiLoB8qTCjurZ1i7bpei9Q6TQAxutAl9vF4Vl4NyLA8F+DzRujiCTzKibTRwoI7SFw==@kvack.org
X-Gm-Message-State: APuU4Z+3TCrlGOL8bTf8Gx3UMOdA7whysrMNRknlaEnJ656rtODCOlm0
	iDElIA+HfBIg9EUtbJIA71btcR3izGvD04gzqcMEPBARIhOp+TsySM8/rHMf6QhlRyM=
X-Gm-Gg: AYBFou1jJQ8gsqxDlKs79108MSB/vdpVpNWC5GftOkWbkWokv4nDJV5SWk0HLg46Uem
	SmnN4OiT7sfeShjDTDRZr3lSbfZyJtyccCAqFAt+YpNXhid0/kYA/SGfud8RFTDDjIWdUDP6zpr
	piKJDml5ed0WodNauWKIU5v9NgWyQDKZQvjSGJkZ4tQj+8KmN8rdzoBwhJDUXalqo21e2oAQVYq
	JnkLHbKYFkysakP5V7bONVgKS1Y8stp14wOfU610G17AVe0iklJx8fdpvg8zaQJ6wi6UC5zqGFr
	cQw8j5OI4aw0x0O+34YpfOijFCTKSsTq+XQ4aZmLtii2soJEqqRJ4w/YuoDZT+CkLvdhe+w639l
	846Ms0Ktq/zEnLmD/iYRLzEucBiasFhB+0sB/xCGPpGUJWtUNpm1obhXVQ2vkM46M3NUu4uBW27
	1taJZE0HoDmeJmIXY4uaUnKJ/Q6lXzx0/EXSk2CbHEO4gLWdn2UQLgtpf2ORDVcHxEWpOdsCyG3
	+Rh2me8Yt6eobGj0CKFrrifdZgu3RkuEBhnVyTNTTkfGP5rErJlSeHF5SBw1zv1gOlqf8W5U/HT
	ZiDXI8dv/0/r1jiOMTWwcX4Tti+exi/X/0Fh2wqJI+jumULmexK3JXzF8BxgxcILW1orHnycmd/
	k2w4ycW+3ryres5sTNrfzJQVQkGrKnolw4w/RItuMqk9witdYOfGZIS1KbWBcgMKl1SHA/iT0ow
	ePxFi83aZySkQq8L/1bBMXao6be3Za2rI+SJTy2ue426QM+8VWaOX5c6IVF+EoLdAqmbsZxOnIy
	w==
X-Received: by 2002:a17:90b:3b4c:b0:3a4:e735:b39d with SMTP id 98e67ed59e1d1-3b12d57457cmr400027a91.64.1794116458854;
        Sat, 07 Nov 2026 21:40:58 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1278918e8sm1796511a91.5.2026.11.07.21.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 21:40:58 -0800 (PST)
Date: Sat, 7 Nov 2026 21:40:56 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm: memcontrol: don't lose track of exiting OOM victims
Message-ID: <avALaDR1_epaAfOp@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam06
X-Stat-Signature: hcfx7ha86fzzco5bgpuxm5hcatqxj3da
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 1AC56A0003
X-Rspam-User: 
X-HE-Tag: 1794116459-748914
X-HE-Meta: U2FsdGVkX19TzfQSiXSc2+IqcPWpqVqov1o0o2nAw01LOvDqnd4g8xgduHvmhUyHLl7IcmfJi5W4QUvfVj+rZ9N1/snPOo1+uzNaRmKTAOmpSLA3+3stKdtqa9vxI9S/9LcNkS1sR7INyhDKUqEJjcu0sVVaj5gXr+kiswN2LeZaXP5JccxJ5wJuACPHodVVC63hU9PlwlVUIsrNDv5PADIygzkj9yDYYYLvrklfpKEKCz7psmmaHwfmgjjz572FQHAU9WXwiZ51dZrbdktuNfv4SVbljp4mJDe/dKVRAoKhMr/IkAPfENPEos7uWI7wj7i+SMzdhwFkEEpGNPE8O8X5Ou6loMVvJ+/8vDipu8B/rt+fM9CGZuiuc4ErvM8gGTik7wVwf7nod/9c9YrjF5fnuCztj0IZ3WXpA4chU7OAd4zkSfCj5x5S5EsTEKT4/QkCyNX0c604Gm/PEmlpidfbga6akrIWTaT6GYwGbNiZjk/7VicE+SN5hMd8wWpnr59MgQYz1sWjcSeMx/TqyRxVCEDNna2jpDfHL0e96sZwXuD6EO8bjFpIT2tLHXbzTvbTJBgDq9aeKjtK1X17K6GpdOdQ+NAT4DTQS5BA92Rg29qecgWXNYqYPLObf9z678kD0a2bMNJ5aI36FvJvfNBW2CMx0QyfPRvWBoxhM4bkuzuIvc2fZbGOai2meFCDt1NAxW/rmQQZwVYjetaG4XNdmi64Vp5ui3Pn7ZeXJ21As2jdfSiTbuO+Z1nQ9+HSUbSEhv8HVDTzzNtneeBZHMO1z/6YJmqqAa/rZmptpnqrFKEX9gw5gy5DcOG3G8hgLaYVXiYjb4oGO3mXk9qAAiOghtTJIdMep6829fuWh2H8Q1FHBdr2ObeZJLeZBeaP1OO3aG+wExk2B7Rkgq3CzteOoB/idEeqcaCr0dOw4T5HUCeKjVK5gSySGBD7ByYd6XYdnjsZgrniw2Bv1O6
 m6wCQE8f
 xgGnW7UbsNF4f10ePYCT8XGPWhsrfT3BP6Biz4im8Q3cBZWc3RUiAIYIFRTvQgXSSRclzt+8ZIlzRx0p3Nu7Xa4FXmk0Ai20w0LzbtBOdE09uL7R2vl3x8v10CJn+Hg4u4shKQ3vhnC2W42Jc/Yk5TjFdLLVOwts+0fEpUehbdb95yDnT/ph1PsTqjiSFNUYFUH48G2UaShuwpTjmDUPzuVqpPqnxGJy97L3jstRFIS2dX9DFq5z68cfIiT8jGUl4GNvS7wno455GleKGfgAbweNgnbpE58AN5UB4TaWs8RASijRUs4yj/MsfmdYWuiO9+5mSocYPWV0VI77yq/ZohhJu6PLQSomkLAlC/XgOsOueietabVZzCY/ZrFAaJgEb+dx8MTCo1WhMYRCvqmw1Xh18B5Olx32D7vCqFTfAW4IOo5r7OMp4ASteYnxmM5nCTdlCAmiLMoH64vea/TEdghBp3z4ZSl8M96Xv0+w19TakJXOXvuvqPIEN3xGJS8Za60zXR1EBcp/20cA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When oom_evaluate_task() comes across a victim we've already killed, it
backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
a chance to free some memory before we kill anything else. However,
since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
css_task_iter skips exiting tasks once signal->live reaches zero. That
happens before exit_mm(), so a single-threaded victim can disappear
from the memcg scan while it still has all its memory.

In tests I used a 64 MiB memcg with swap disabled, and found that the
OOM killer could kill both processes if the first was still waiting for
AIO. The first process faults in 44 MiB of anon and submits a direct AIO
read to null_blk with a 10 second completion delay. The second then
tries to fault in 40 MiB. The first OOM kills the larger process, which
gets stuck in exit_aio() waiting for the read. About 5 ms later we kill
the second process too, even though the reaper gets to the first one
about two seconds later. memory.events showed oom_kill 2 in all three
runs.

The cgroup iterator hides these tasks so that cgroup.procs doesn't
show processes that waitpid() may already have reaped. That's fine for
cgroup.procs, but the OOM scan needs to see a victim even after its last
thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
for sched_ext, so use it for mem_cgroup_scan_tasks() as well.

With this applied, the second process finishes faulting in its memory
and memory.events shows oom_kill 1 in all three runs.

Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---

Zhan's patch for migrating a process whose leader has exited also
changes this iterator call. This patch deals with the case where the
last thread is already exiting, which came up in review of that patch.

https://lore.kernel.org/linux-mm/20261027144016.2582880-1-zhanxusheng1024@gmail.com/

 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..cb7cfae9ce5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		/*
+		 * An OOM victim can start exiting well before its mm is
+		 * torn down. Keep it visible so oom_evaluate_task() can
+		 * back off while there's still memory to free.
+		 */
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
+				    CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
 			ret = fn(task, arg);
 			/* Avoid potential softlockup warning */

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

