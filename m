Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F26606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IEOQmJuh
Received: by kanga.kvack.org (Postfix)
	id 5B7936B05B0; Sun, 25 Oct 2026 09:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5684E6B05B3; Sun, 25 Oct 2026 09:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4582D6B05B4; Sun, 25 Oct 2026 09:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10C366B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:32:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74E3016024A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:32:28 +0000 (UTC)
X-FDA: 85361237976.02.F9CDD42
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 782F0A0009
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:32:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IEOQmJuh;
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792935146;
	b=JVHITj2Ky7vXtsaoj+myxE7Lzw9ZC0/+x3sXbcMI22K41ouaWtRyihkyWtz1AxMf1gLF64
	zv8jYboDI1891bvAgB+0ouC8BWTuJsPmNw+Q0zUayTrLGzCzVH8QN7aJq56A2kohWq+Kf9
	wz9nRdpHuQ4JvQhbAwMPzaCF36AdhNk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IEOQmJuh;
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792935146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcGgvWRppF08rxdxED6gZ5Zn9Wj39GXAsFDDIxUPXPQ=;
	b=BEU5oAo9FStoG2f/yHtKNB5RBND5/fL0VXr8xv0TbLDrGIYvR+5A6XhJ1qNTy1QSzUwMPD
	Y0NfTfQSLlnlwM1+VjgCMtwIUUwbTQRKEL6ubqw27GNBSm/3meyidB9enu747LnR0C4clZ
	lz0k4uzw7xkGRpciH2WRel+gQAuqS0c=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so2730724a91.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792935145; x=1793539945; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OcGgvWRppF08rxdxED6gZ5Zn9Wj39GXAsFDDIxUPXPQ=;
        b=IEOQmJuhH/uJd+qujAR85ALI7nLjlQuTLxM/of8Og/KYcYobSJI+UMejqceea+vkK9
         apwoPMxXff5vlR7oHTAWNoJ0M352/DUUCO06QdAWw6yq5Uvb25M0jHEqZpRKPORrOsCB
         cTF1JWhOLzWg/R0LHKYg/ux0HU3FmzGNFYTQ+/daOFnG2asD+nWf/IAzU8L/T9f605hm
         RXVx960RpInClicMLFmtwXg+266povne2NugKugJ/thvdqA02/6UJVDeqCktaunWpJ21
         263bCsqq9rrI94T7VUZ1IrGn3BxZbgtChHXlAch9zH8G6JEPJhR2tvHLXzDC/ggbX4lL
         gdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792935145; x=1793539945;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OcGgvWRppF08rxdxED6gZ5Zn9Wj39GXAsFDDIxUPXPQ=;
        b=JAJUaqzk4DSjJcC8jfB4FHY2HJO96sI2bVnbOUCnsHDdcK37Wwa5vnXYQcWMlaZxdj
         Mu3j7hsTmEDhvHMOzM5YO0wwPrez/K4IG5zC1NlsQZJomlVHPrAV1uDfIeHWAabQVtMF
         Nco5RTW0cZkFfP55N2Rjty9rvi0kgLPfyU3IK1aQdGwCLHXge1/Rie4m+mUmIfzEk6CB
         hfwhPH2GHeAm6CRK/MHZIix+a/tfytP5chGzcAM3BIYSGHIa9OQIYxso8sfalqsUdxvK
         G7qw+Sgv2pTH1xdTKkk8yzeqCkMbecHo8untT4924Hjf7S9efOZYy8VZh7lnsKcvPdRk
         vCKg==
X-Forwarded-Encrypted: i=1; AKwUvBxaxwVt1Nkhhl+qBazmFOAtQG6Bo5Tjda0KmggcWwCtnQJjSQ9OW20POHx5qPWOOOxsw+8WtnJGpg==@kvack.org
X-Gm-Message-State: AFq9FYL3Cp0OppvNrge+HxD8KTOmlNqxR+xRjHqi+0wj9LVeJmvnaD3C
	bn9VZ3UnpUJzt1aVYMOA8OcpSBmODdJVRGmoN8EdT1nKxGaER3KrqSPM
X-Gm-Gg: AYBFou0DMSibFm0CQPeLcz43+9/iuRBj9tWl3Zm9Celu1aSffyNB9Oe10fOHkbnPDP5
	1STzDnJV4QvUnUXuKCeYEcnk9p/U1OO93A6LO9ohVRkL2Lo9G4DMlNOkjalyVTidb875RBNgMpF
	b3MZv0mzhwPDGfZE6idMEOjLSeqNe71nhT6zft9FfAHX5G4P8lZ12n28oLf5O8pxSowOzljWvv0
	2YhUkPnBqZWad8CUwAv/HXhnUruRMiaMm7OjouCCWJXH9Dl3MvnoxjyX7roBum8ATrlQ6ZxVc4A
	Z1MzaQxJ17HY/CFlDxlOeh7ogPuz6fjVLhutZD8k7/fCvnnYfAOec2MLEHOh5hF8NWGQ9HbD8hu
	LdimnZHMvzgBAFc04YdDH646nB7D4l/n1d4zlJocoXxz8ApO2WIocWvXuUGxWLkTxbskg9CnpLX
	Ba9fYjj2AtH+KXE/xe8Fo/eHlHDcsfcGoR0gU7QwwlkxUOwb9F9oQnCvvfUNSeAO0MNWQiaV/7n
	s5WUXZQZEaiuGMYHMCND51tIiFrf33GdVmEs/VSAg2ODrqxv5Ct+Sx8D9Yw71a8rSIoA18FDJ1n
	0kZcz0rvz05j8p5MsJVpHoQwpgqEA2bML4eYSA==
X-Received: by 2002:a17:90a:e7d2:b0:3a8:c0cd:57f9 with SMTP id 98e67ed59e1d1-3adead2426fmr3897098a91.25.1792935145198;
        Sun, 25 Oct 2026 06:32:25 -0700 (PDT)
Received: from yafangs-Air ([240e:46e:1b00:3755:d15e:318f:88ff:4335])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adec0bf7cbsm5070368a91.16.2026.10.25.06.32.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 Oct 2026 06:32:24 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: tj@kernel.org
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	juri.lelli@redhat.com,
	laoar.shao@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	memxor@gmail.com,
	mingo@redhat.com,
	mkoutny@suse.com,
	peterz@infradead.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tim.c.chen@linux.intel.com,
	vincent.guittot@linaro.org,
	yu.c.chen@intel.com
Subject: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing mode selection
Date: Sun, 25 Oct 2026 21:32:04 +0800
Message-ID: <20261025133212.51440-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <7bcbfa61a8c69e6ffd81e97652d981b0@kernel.org>
References: <7bcbfa61a8c69e6ffd81e97652d981b0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: usqbewm9r158xtiwx75re56phxyiyra3
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 782F0A0009
X-Rspam-User: 
X-HE-Tag: 1792935146-689419
X-HE-Meta: U2FsdGVkX1/DGZ9cN+lX4lO3vs2OKWZtk7K8lYpOZCrNIuT2AECKDvZnpQ1zMg4xVyIdrEf2nQ5o1RGIexNheO13cTULWTmtz9fbsozCDDgnWHvGt9Y72cRr+5cAimKruGCpw8ywQD2s0J6wcKyU2EMvJ+nLqZypJHLRcDHTJg2zmcr79Tt/9V91fkmAw+uCA7knBlq4eWOw3FcAn1SGgcWJ3dMTt1dt9p8w/6KIuHWIf2XDpooN9rCQVCNguAvR3OY5Q3eex0pdM2BhjWYhAcN0pu0sc6EktoqTr6VTzVGuS8hK01Y1HS/0/R8Cxvh4DcOth5txU8tb8heIbwXQe1i9VbcQiTgzCwB29p5KOxEL+bhqUQY0htqPyOrudOyRRbdveDjg12NNA3wksFHOzD7+W+f183lyWTdBCB3ba0dJ/ov9if8MsYRnG219Yf25oGl0dFv0M5WJJzXSw4DRUW5Meok0hUBIlKBpDcrGZMYOguknTnxAnb+ySD6ST/W/YVgj7gwd5FOXxhcpRVCaVuFqfqPEjmHP2HmICWdFZVWCRR53pKf0bZ1Io3RQrwIIJCKch2WxUib2ff8jEVIIMpxsi5hDNbEfjWrYOhcbn+vmEtqSSjpdhKnRPpQJ+OOm5Bc5GHVHKnlTsNNo+uxPSJhe4Rcw56BbASz/DMJfu0SdSIyYIQKLzLi2iziH0g+Rb8xMCgqGPJECGEvnV/hqR5A7Bfts1SPcGEDqfLGylx/mFu1Oh9aAYtPO2Uqs87aEhMYCtfk6TuEY4b8Mu01/d2LL0Mr0Vf9yA8WHrNEoj05vI7v1GgoBcgzjsMb6oTZdehgegsFE3z8L8tNtxufWlnSU1HHhGnUGi67Jtc022SJBDjplm8eomRyT4+srpxIC7bgCAqWhDoRy8SbcFVGpilEScYLUMrEk1dXqiBrpGlA4tON+vSogFCiQQZ3/HCogvXmI/JtsHYzIRQf9nBl
 gC9Uojox
 oxPv/fcj4GEzoR8vvp1/gvgP1bqgndiZU13NutzREKJhOCIJSQ0y1cwuJj2eNaivyaoxZLoHAvT7cgIpbV5WE8lQDnt+/Mc4RGgmQ58GPVJSqBbbNcT/3dzC3FqbSejgWqJTaqWUq3oA7AR4v8392VgGfhHBdJObAoTAV1vr2ZGXbB9z5Oce4ejEv9KQOe12fmV3fyl1Cq1t+vjDsaIAI+42JOdRyQ0IDGMU5Q23JNLFrBZzrONub7tqyO40zFtlzfa6JbRdJwD73WUdutIvS/8SUEOkJG75R5kQ4FDAs0LaJDp6MSHX1VV8J0PnGF/F4WHSg3fIQ1wXxc3q/shDUZSWEy3Etb3rSeRJBQVZJIE11bO8wDT51pe0e9nHm5H0X18C1IrDGEz/deL86SwO9cRqjLubGIn0wmvN2YurRiWI78IWfQsD5iv7CBK2TFI0zH5L2PPeYi1ZmK+AVcZWuA9oL5k6dPogNwY7TKL4Z/MMIqi/825MC3jHwpt3gpKdQy8HdyU1K4wPeoqHb8q0PNU5iBHQro/FL/4430Amj/I0pdV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Tejun,

> On Mon, Oct 19, 2026 at 02:41:52PM +0800, Yafang Shao wrote:
>> An opt-out wins and binds the subtree: a DISABLED request anywhere in
>> the chain opts the cgroup's tasks out entirely. Otherwise the requested
>> bits OR together and the kernel reads them independently, the way
>> kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
>> both modes. A DISABLED request only speaks for the cgroup's tasks,
>> never for its memory, which follows the remaining requests of its
>> ancestors.
>
> Can you explain the reasoning behind the basic design decisions?

I missed your mail before. Sorry about the late response.

> - The folio paths resolve through folio_memcg() while the task paths use
>  the task's cgroup. Why isn't the whole thing tied to memcg?

On the unified hierarchy the task's cgroup and its memcg are the same node
wherever the memory controller is enabled, so tying the whole thing to
memcg is behaviorally identical in the common case.

The only difference shows up on cgroups without the memory controller
enabled: today a request there still reaches the task paths (the field
lives on struct cgroup), while the folio paths could never see it, since
folios charge to the nearest memcg-enabled ancestor. That asymmetry is
exactly what your question points at.

I'm fine with anchoring both sides on memcg, and bpf_numab_set_mode()
will reject cgroups that don't have the memory controller enabled.
Deployments that don't enable the memory controller anywhere can
still make a system-wide request through the root memcg.

> - Why do the task and folio paths combine the chain differently? DISABLED
>  binds the subtree for tasks but is skipped for folios.

DISABLED is an opt-out of work, not a freeze of memory: it speaks for
the cgroup's tasks and never for its memory. A folio charged to an
opted-out cgroup can still be hot for tasks that opted in; freezing it
would let one cgroup's opt-out block the promotion of the memory they
share

> - Some of the folio paths already have the faulting task.
>  should_numa_migrate_memory() takes @p, and the do_numa_page() and
>  migrate_misplaced_folio() checks run in the faulting task's context.
>  Why not use the task there?

It comes down to the common migration backend, which runs for user
tasks and for kswapd alike: folio_migrate_flags().

Fault path (user task):

  do_numa_page
  + mpol_misplaced
     + should_numa_migrate_memory
       + folio_numab_in_tiering_mode
  + migrate_misplaced_folio
     + migrate_pages
        + folio_migrate_flags
           + folio_numab_in_tiering_mode

Kswapd demotion (no task):

  kswapd
  + migrate_pages
    + folio_migrate_flags
      + folio_numab_in_tiering_mode     

folio_migrate_flags() must key on the folio: kswapd has no task to
ask. And one migration asks the same question twice: once to decide
whether the folio moves, once to reset its access time. The two
answers must agree. If one check keyed on the task and the other on
the folio, a folio whose toucher and owner disagree would move by
one rule and reset by another. 

So the rule is simple: if a folio is available, key on the folio;
otherwise, key on the task. This also makes the keying robust to
future refactoring: if one of these functions is ever called by a
kernel thread, the answer does not change.

> Stepping back, the basic design decisions don't seem to have been
> thought through, and the descriptions restate them at length without
> explaining them. I'm not the best person to judge how useful the
> feature is in practice, but getting this version into acceptable shape
> is likely a lot more work than having someone who knows how to do it
> just write it. I don't think it makes sense to drag this out and force
> it into shape over many review rounds.

You're right — the descriptions restate the design at length without
explaining it. I'm not a native speaker, so I had an LLM rewrite my
commit logs, and it restated them at length without explaining
anything — the exact symptom you called out. In the next version I
will write them myself and only use the LLM to fix grammar.

