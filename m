Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1254FCD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 13:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F6D6B0005; Sun, 14 Jun 2026 09:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9396B008A; Sun, 14 Jun 2026 09:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D714C6B008C; Sun, 14 Jun 2026 09:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C21706B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:26:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7927AC2897
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:26:00 +0000 (UTC)
X-FDA: 84878591280.07.F57D0D3
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 134288000C
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:25:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=OX+TjmXP;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	spf=pass (imf30.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.128.170 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781443558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
	b=nl8Gv65jKv3JoIBEkeEhEgoPd1NUvdIgiIGL1XvfzgqtIBJk3jrUreOZRkcg7TdI42gfmD
	I01k6lacIizp5LCII2cOpMdSvZvzeGRAeAWqGwYqnfd/p4U12tduMwtdyYUn6IkSvXlBjx
	TizwUqigN3uijoR/s1ro5koNgHTZWtY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=OX+TjmXP;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	spf=pass (imf30.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.128.170 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781443558;
	b=jQD39AXzx7gpizQFUctUE/Ozo6kwXHlXzc3sPWmLfRbdr7h3y5BbgTNWxelGzAtvF4mY0l
	bfSqeGpNiq/M6LxewK0rEtDt4EF0aTUt105Yg6MqkslPiDnS/Zihl+3PaAEzI/bSKrOdzy
	zDBd0DKgCcz/sEsjTnUxxHnTTgEZNBA=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7defee656dcso14736387b3.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781443557; cv=none;
        d=google.com; s=arc-20240605;
        b=RiB/L4xOao0zwdkHY7t/6tTi1qKDWpdb5OCPxxHQxX1o2ql38WcpcTO0RKceTlCBBU
         S1NMUd/mU0gcNdKfHTsHAEBMbRRtxgmPxbWy76Th/4p9v2KVVCwp4YfiQp+PBO9AZZAJ
         2mrb5tLMmlXSAYUd1hTndR3CwbHd2YdkTz8OcoWcSAUfNYnTMIkWYWhPYABgxaU5RzyU
         8NVY6v5TTPP4+qlpm8DX35yTXc4EMG8CcPs7KGSNBaFnzWbOPCUl32xiRDFuyNB5+lzT
         ba9DVO0llk0K1BF+o2bTDObCMyP+k+QeOEHlFc1hvOVgtOIWEZA+QON7r27Cl1iXbRfe
         1pGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
        fh=JVdfWTb4K/4VsDtCqUo2LWCQs9JNak2qk/lSqsKxcic=;
        b=TeL4h1/f3+ShL0l7m2QHqKaefathmAIIQXRx//WVjf+Irj+LW8P8z0tWlEpSs6iA1x
         uVN3VZoN7JYoMj5Jm/wKZVCPehmgnsXElMIBJpriGBZUheIqKpGdVPloahcioSy8bhNd
         zQbld+Mmj89BEQFGB1LqiZ2e4O8BCnZVYYIo3TgNjgG/Rb/VtuKpyH8IRwAYjL2/GhGm
         A6hm3yua6aGUVlaaxujHAl7ukmJ8pqrzZYH6A96Sv1jo47DOMw7h7+arVar/08FjUBmF
         QQ7UtnwdAHoquZ+lKw6xxfWg7kuxRiTrsA1m6UfoFffxKhQO2AL47qy23Q2zf3Datqu3
         6rVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1781443557; x=1782048357; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
        b=OX+TjmXPMF1E27QpXbRKcE/Vbi3+2Agpmq+ZqwTucGmq6LWd2TTj5Nn+De+5vx6YHL
         QlpUJivhslR1ONBGuZ4dsgF1an6P9PcYLue9k/GwpAotqITDsI74jjkCbiEb45ninktG
         5N6I3Fas+Vuyw1UtFvae1F/4DGc7b1VBXK1tUA6vnrG4RRaXkrDxoG66Y3Q52ieo8Yfu
         KJMur+69YAMc5R+WZnt4wlPbmSbLQY7yC7Q1Wr48TI1Ac8YY6FJQkIWFvuB8KQ+sQFtP
         HsSKNhFbGwstWOkzgVKNuS8tqRd81FeZIY1dYNwow+g7gOUPqLe/8xjtgnbISFel0YMV
         Cr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781443557; x=1782048357;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=my7WznhvuaINq07i0eln+93EnzFiKa95Z+VUna30ulc=;
        b=s/Ga6t6j0AYD/ScVEJYe8WvbbxX8npUoe+b32BZO48yTxTHy6jZqsMFV1Ihyw3Z6BB
         JDX9M/Lrbw5eZG1zPSJk5ywcGa+VySAkHw3dRmhAiiuLu6imKwqmK3i+IfUEQe+XQtzh
         GNRmBOYIlgyNuW+DDQ6jVazvyLarAQv9kEqadDckUWPz/Kd10/JJnfMN1DJuxKSDHGMQ
         GGgSJeNWf6ANZA6rkwCVg5Uc3Kb3rovYGncFW1kQ8p7tsfqt9AsgW0WqSo+K18Z9ei/V
         CVrhYfVgmhW2Rnsi0F7Y5l3dpUbP998a/NotWbJXKaLf8esDEWCwtYhG8qveIjp6JDKZ
         Mgww==
X-Forwarded-Encrypted: i=1; AFNElJ81NfOR3nVDRA/FUfVB3LlsrE0gUaac9u4dT2ki9RAhouORy+Wc6GBt2B0C8zOkeUORvA2r4C0ukA==@kvack.org
X-Gm-Message-State: AOJu0Yw6zjmCAtkRanK3UTQ6OQXKdvB0fSVoVavUswf7CVxbBqYESk4g
	R7grq1/Jr5vDwgdnQzmQ4WjGNvUzsL1/lQhDOxQas5PvbaDetrp+Z43o9glMPtwctS9iqqGruwX
	5RTa0wEYt6D3HCAYzRdqZsNipsof2bY4MQhWlaqM9
X-Gm-Gg: Acq92OGvvrDX+F8bU5XqBb69YW307kbDYq/ZA3YVvYUjAccdPRO0bHRA4tRUHiKZAjr
	dcwV3VLPWUEIW/1PUKDo1qUbhis1xqVDk4uxt0RDzAHsJZsXFW3UiCwTQu4O2YNbqPNtVoa45Bz
	3jruXaa291lS82g9l7vX4uCPXExESIQ3vNdQcaF7tFVkZBqqhb/EX18rOiEnv/WmH6xelTcZPeQ
	lh3zIkQ5L34nwuV7trrbFtXe8mNywUD9pA3d55eR/Q5WcT5rlQ79G0WuTL+zQtNVS7S8w+UBjrz
	VAaCDCZ+Ag==
X-Received: by 2002:a05:690c:3745:b0:7e2:a956:4083 with SMTP id
 00721157ae682-7f8c1f15742mr70603597b3.20.1781443555816; Sun, 14 Jun 2026
 06:25:55 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 14 Jun 2026 06:25:55 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 14 Jun 2026 06:25:55 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
MIME-Version: 1.0
Date: Sun, 14 Jun 2026 06:25:55 -0700
X-Gm-Features: AVVi8CdOyddTc0VCwydJ03Yt1oOOOGpiCzbsY_HpVqvtkDz1Xj3Bl7yujHIBV_M
Message-ID: <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
Subject: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
To: Andrew Morton <akpm@linux-foundation.org>, Waiman Long <longman@redhat.com>
Cc: Farhad Alemi <falemi@asu.edu>, David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 134288000C
X-Stat-Signature: xuuksfk73rgp7ce5t8kxygewjjbs6csz
X-HE-Tag: 1781443557-510412
X-HE-Meta: U2FsdGVkX185+wDHTvg6aWsxOp5CZSppWr4AWEWhhMaJJSf5WQWOOF18ywejGnVBBmjgBmJiOm/FpQCDf7LqpucQ6jKC2bDhO2XIkU+K3TUiqb17LUFd1c8URHKX4sWYayKfW4UugWMgSTyrELJwu4zS+CBQ6gSSmHkt1Jj0JXTsiEdzjDI96/mCE+W4+rBvE36nBQLGsrd9Pm+57VX9GZqRxUgdWhb2rI1BtuumBapbDn183wH0us6Tx2/b91gVihlpDn6P+Km0IcVuZgn2C0Jbcw1XQASPr6crcMNZXO2gszOMdd0aSQqCRwGjJxI8qjGnJzMv2cXnYerZDDOO18QZt2xazgKXfm5Br50ssnOzso9Kr4Gdy6T+EhAEAIi280L5xY9sC+9hUmU2UUPX7fk6RJ+y2LwPxa0Su3dnLb8Pv2xjQBQ01ecjEMxjEUaGAOAahV5NkVjEU9E5o30t/6cWX+fC92cfYc8RD8LfJ79TxLzecpx9sN18nq+SJBkc/8UxfT70cHdnl0elskZRoqI0eYity2Y3C58/cZUB/KM2VVRsp3Wn9rHsxZY+kRFxEga/tgpO3+issmyPocoDMbeUQLDny/XNP5yV4lh3IBHt94i9TmGeVrzSGVFypXRaYloBeIp5VBFJDTBv8B4hpeH8FyUmBKK1FAdZ80JnS7By7WJwPruf6iB/GugottiOM6RfvDVc351fv/p/O627JZtxQzFEGLh+Z8uJz+o8oCIK4nCUuDU4obUo0Q4fX4VTBiiinbt7OQBYLCrtIti21iKRvKym2D6RrVgAIKpRgNkSROxCEKE5sIm2H6ZYW/33umzvehy7I7FvwUMO96TRIJG3AVA8YeY8l2ZJPI26j92qXiKdfIIksMwGDtnu2RwC4QiWz0nZz4DRExZou8zyS1ISps2S1JGknk0vsT4Lqp6EUo9WgTu03jhlgJLxsEYscdMPuBMSSLNn6q42p82
 YQWEb4Lg
 pKqKUFOw5jZpW19xbLIjXDIBwCa7LSerFeARZRGGVWEAvLwffGhpNSEEK5GSiPDDIMeJtaeCKChZiU7gqmWw04Q6v9Xs0lIWK8KHbacLKE6ZDaTo+HOjVQq32rHR/RaKFI1Q8sY6nBR+OkocWvMHhPi6QpIJ1WcJkDfR7ejV1jufAlK3hrTCtqu/3taKX8JxUhPuXRO/A25u/U7T3NLweIg2uh22EPOsf9PGV+MSViygMvDURNAXTbwlp55r/mNd+AuDy3LBAVZ5LYXTgkqNHCtKXVB8rtaBJwb3t96uE8BNrKgXuoujQAX8eJ78xgiIrbXZWKLFSJfliAslxIK8C282qOkpaeEcVHvqQGcIQXIzdbGsrv82r+2qCffeEv/n5+yCJYYece0xNt9pQ00xIb47R+iH51yg6jowtIhnQwRve2EjMnqvOBtqo3v3rH1eSqA6T95ulcg9uj3MEzmBwNxKyRx3UBSD0C+D94ZlVHb4iCNzM1MqxVgYtnAu3i0qIMgigDqGhx+OpH+SjiratNOY5irntEoU4uQL6T7Hd/AHlR8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask.

Link: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
---
v2: rebind to cs->effective_mems instead of newmems (Waiman Long);
    condense the changelog.

 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)

 		migrate = is_memory_migrate(cs);

-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
-- 
2.43.0

