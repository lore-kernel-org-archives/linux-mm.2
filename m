Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4695A606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iakxD7Fr
Received: by kanga.kvack.org (Postfix)
	id 6C2366B02BF; Thu, 22 Oct 2026 18:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672B96B09FD; Thu, 22 Oct 2026 18:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561906B09FE; Thu, 22 Oct 2026 18:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30CAE6B02BF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:39:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B384F160327
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:39:54 +0000 (UTC)
X-FDA: 85351731108.23.FBC2F8A
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 08ECF40005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:39:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iakxD7Fr;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792708793;
	b=0/q6neZv217YyN5DWS+w8EI/geREe6iHzB6Y2YHEBBdfNACD7rPnGbo3o0Nn7uNF3fPBbI
	jCf3B1CWnEtjA0NJtMez4a+b1c6nFlPEFXGTPX29q7uvpCRW620EANTgax8NRDgaf0r50O
	xRXStSh4LbrA7iPDHLtI3TR8CP+Wen0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iakxD7Fr;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792708793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JtKxQk17mKJ5H+rcmhYc0xGV7tRV/52vlvUl23dtKyE=;
	b=1Yq71Q2SYHQTa1sKRSYfeYqBSYkrKVBmFSlP/rRvt8RXmBKgl/P42o5DjnHoL8NfZgC2/K
	zgxw6kD4ay+bUrZYVD6dU9CFGgVnKZacH+0Kl61REAhoYFTBHGihpO73vHDohBWnvOGfUu
	XdCn+Ga/eTAbPbXBO59BRyrx4OQII54=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8ad98c3fb15so3026197b3.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708792; x=1793313592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JtKxQk17mKJ5H+rcmhYc0xGV7tRV/52vlvUl23dtKyE=;
        b=iakxD7Frtd5O2EK15flMGH14vppfLnnZlHeTBvrmF42vCgZ3nA0ZPJocseM/66ayXs
         eGy6X7vjhb1ZOLgm1aAX10BrGindHWpqAx7fUhmeutM1lC58cF3VG1dVjjAel7PX7NAo
         Y4njcbFHgLA3oU6feY39EpHSmBEfnVs45wj3mwXNWDXEPRa0+7eF7R7/vmrG6Za1ugTm
         RoaisQhIG6VJGZwv4JZTmcSXD3N5b8ScIO9F3xyciIbZpNOYazjH9mUAHS01SyG/4Ixn
         /y3YrYAWbKiM/vsTu0Ea2qxUmOGLR5QAg8SzWa9z71FGZZpMSUfWEkZKpP2xVDJK12l/
         67Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708792; x=1793313592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtKxQk17mKJ5H+rcmhYc0xGV7tRV/52vlvUl23dtKyE=;
        b=HJSgKRG+ldIhaVz9iEOFh1+k/bMkc/12HqKr0wO1Of8P3ktEu9Q8tHqegW11OQCMXq
         7fw/uH3NPYmbNdAxk5V2TZ5M0fMM7bmQeqdCTw71P6G9MjTRTGiLrWgP0xZMDcdvjEme
         TlaJnQ7JQ+dzj9HmHXJMyZC77Dsh8XTNDCE49kd9V4gXqu8exkda4WDtj4/sPacpk0bZ
         n+Cigwy+f+x7B8c+wPb81DvvfOiGA0WNzGlHIWQ5Nk5SbJDq+TZe1HeG+OEyEJlMk0IT
         FVfeZGmt/oEiHeZ8jTnQ26CdJa8+6MpY/aTZKUKGRK2I0QP4SP5oTqSDkuirh3ffyZCo
         n0Jw==
X-Forwarded-Encrypted: i=1; AKwUvBxCQ9fQB3u0zlmwnzhuV+IPaieRBAtKe9qlTQWo9Z22Wi3k5bq7grCqXV6ZYlqr34h2eCEz3qUJjg==@kvack.org
X-Gm-Message-State: AFq9FYJRm+LHalI+I18gRebwelft364Vh53k1d4C6GE9W4s8O+Kc9jR9
	9q2V6btxw7xI6D9TpykikJUg11eguXlg/NEeMea8qskpzGhO2K0rInA9
X-Gm-Gg: AYBFou0Dkd0JkC5hNXUofqjCWnXCeDPaS906ZN9/n8T7sVOfjoELTvBAoltlbZ1UHvV
	NgTz/cccOu/xpmaAZ5vZW4+yV+z2fiQ3CLE3gz2zjE6xso6L4myFZjZL1bv5e62CI74wtCWQ4z0
	VRCMQvCxgVhsk1qqLp8MsgHQe99PnMiMD9aNt1HGL9f2nIJQ6v8HnHqcC+9cs2y9PrmL39zr8Yo
	GIK9nS3Mxc82z9OKQlwupFe95jk3Ch65Nd/6rGD7YcEm00VYdbqs6UynjTm7dqSJ8d7GRquCQ0/
	HQ+1bvTt35KcL25ICAP9GBM5vG5tjquJ/DTMeUyBn+dMulCZ7lOE3d+pxsf5a7XZa9ZfO5OUbeU
	GspCVONoi61+O9OIao9QfFzijN0nfCddfobST9IfGW3DJoQR1Ok5X8FYUKi6DX8vlgvn7ios+MA
	LLQkDLPeZgPPYNMAg7XGgbljnmPI+hvylIlu7Y2y3abQv1jOxzKwQGE2CsJelIZfV9k7tMkXrKo
	ikVnGs0iSxMJ0gKtD5rHoiyaJPe2hOfWw47sIOoD1oZnLFr+3wMyKiwYjd/fIz2fIG9ZnMIAT/w
	oF1JBzIXvVuPmYF3f6NDhcC8qqWbw+5i
X-Received: by 2002:a05:690c:c4e9:b0:8b0:6d14:23fe with SMTP id 00721157ae682-8b157ef7c05mr3917477b3.52.1792708791905;
        Thu, 22 Oct 2026 15:39:51 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b155f8af63sm5238657b3.2.2026.10.22.15.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:39:51 -0700 (PDT)
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
Subject: [PATCH v2 0/2] memcg: reduce cacheline contention from lruvec stat
Date: Thu, 22 Oct 2026 15:39:28 -0700
Message-ID: <20261022223930.138779-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 08ECF40005
X-Stat-Signature: hth7kenbp7rns6ihs561uuc8h99htj4i
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792708792-9169
X-HE-Meta: U2FsdGVkX1+u2d6hQAb/yLnA4N8dOS0GgMtngoe3wuqYTT7VOZgGZU8h6x205JmET0ru1m97R5nikycQhLzeXboR+22idLs2BNuIrq8Pa1dIKetvgG4fephHr3nts1kzT+tf6sMqrgSBb0h6nqXp4/D7AlHgXFUtFqpcUNnjNVPxZvYGkb0OYowbXf6VTOGxivTNCL4WFJ4L68ng3SkXhvVDMqIn5ZeBk64LBFAnnjFiSUqq6rUeEnMAI15P2oHXmNjVTZ7LTXovSQX3L/m19y4l6PSHCxOl4ESqTUrPPNoAXrL3taR+/vRp4fiDUlSCPO2lCXtxTFbCAFRE7k4ZJN9miw54hSckhauDtDXiWxCZz0q2whnGFNpGZyEmQgF9QyY0G7Z375mo6je/q4N5/NLlj0+UtZsGkjUlK9Vswl+Mbo9dxF33xyH2Clgz0mz5liKQ5kB9Xz7mnHBI+iSyUq1d8hyU+NJgs8WPTxBhRpIE/Z9wPUJ9JssLAyOIV7XQWwa/9PWqpUuakeC9WAIwdMaCTjui88ikXYX59W5bRh54JqjZX6AZd0PV56iU5iGNf95UD8tWrFz7SK7Qgf0P95gjERLpU1hO4N/dIs9pCOQkC5TqZKtzv3bX5v9/WCQ93ZLq/WMEnrC2OHsigiAJ03KTFDXmX/tsJl27WCrkRyiojWuMvJUTJWKMZJLe9WxubJv+5ryCOOK4E9Iq4y3nsxZz+XrpJIZ903TYpR/zdSX6dUQKkUepVSSyUhimnp1ntvmQ2E3N+WO4/2nGZ3p93YILHa7Iar9UOrL3aFiW42/KaxFdTyTBb9y09ctd66ewZuy13AXX+UhUtLeprz7zUq91tSeza+Qyu9b0SNHAPUjhkXgOhdp6mmoSIChCM7ugfBjwAevwzWlADIPDtfcWqi34yIDG5+ZC8LjJohopBJsRquunXYff5gF9GmSYCNrpv7Uepy+QTV+XHxZd1pc
 qbD6IV7t
 AONUPyN6Ngms14q1tAyAQ4zBr7s4WEJ0U4N704owNWuAnnkGFOTx28xN4A3CRaQpOYbL4ra8goPc+Wxv+FFUauvxNICaAtblOnNAZQbfHI+jInrmN9sohUP9ebO4MwnGZe6i1qyxf70Cwx+11rQ9SEksh23m7wQUXLfbnXyr9UzXq0Y55vPAU5nWrD7hPUIU/wXlOT/ddgiwkzL6kHLj2M9J81QgkTxX4B82eUNBLBQCC2Hs4lwHSFgOL0Nb7fZoCtFWEtTtAvMDRQyjH6FElgDEWZgqFCpLkbYYK7n95gvfDig6f0fgBegpzR3Ab+548HO8F4qJd6EJkVqyJablYXyaoE8RchRVi9x1+eDktOTb2cxWYptUS9Wvr3BmYb3kGRhRavLqYnYMl2f3eXbkxu/S0R5dG01L9FneIVRI7CwDQwa0jIr0PbjlOvDgEhOX7GqIuaQmn8KXb8yJsDgvjxOY/Nx+6ppUOsCbXeXqZ3ddPiH8=
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

 include/linux/memcontrol.h | 22 ++++++------
 mm/memcontrol.c            | 71 ++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 53 deletions(-)


base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.52.0


