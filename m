Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C531C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB606B00E6; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2806B00E7; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCE46B00E8; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0556B00E6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2751DC06F3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:40 +0000 (UTC)
X-FDA: 85060068240.13.FE6242A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 94E4F20014
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm9t8U2r;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zkQs6mCwPIKeiUIY1+pQwOcOcVfTo/+g8AflA0OwVg=;
	b=TkGA/r0IdU9DxJsP+mLoIM6Z4e7PAsl1X7A6JpUTRAjZ2KL66PIG3FdT4xRXAPbXC9vdgd
	GaO/uSXzKWmHreXl5gq8naHUUVFIdIBoC8vz0uKZIQmmbsYmbqEKyvlWXDaB7w1IdPYRi0
	Uyt6IiSI/Pz32m+R6qQEzWoh1ZaGpx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764438;
	b=GcUvJXkWQ6MOz1syA6EX596JiJJ4wDKf3GbLms7iyn5cS3lsap6+kOVNdSeTR4ste+e2lt
	MGcXsJ73Fh/oAyPT9cFyf4imTFuLLx9yYTnogFooS/+aaTkRTWbV4IpeD3vyElYI4ru8iC
	b5rEXZ9Dm31JNyXSTqqvSvbkpHCesb4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm9t8U2r;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 332CC60A82;
	Mon,  3 Aug 2026 13:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03891F00A3A;
	Mon,  3 Aug 2026 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764437;
	bh=0zkQs6mCwPIKeiUIY1+pQwOcOcVfTo/+g8AflA0OwVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qm9t8U2r9bFuFg1CHc8XbomtNTuukfs2O+P4QF8UKRt5NFtnaFsw6S5QwVbo6BfOg
	 /6EoP5C1t/Y3V8mEdhzLsGyl2DjtF3T8eGj64HJvBt4EVbxeaRQxj4VKhDwoClqQSu
	 rmdk3CccJ34mWltPQIIW1/MNpuFXCoFVAG+jPF1OlincMYHS4OKPc9/VSb+qfcjwVC
	 wsbjdMzIzrK1j026l28CptVW1L6odEZu5/pfObtm/DbrvMqAV8JRm/GeM/AIymGN7X
	 X/qR5hlbtJ8bO7rpH54akGrq0+Y6ojSwhJdA4dnRku44w2Ry8BPDUEAewxBwgn3PV6
	 kJ8o6Ho098hsg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/lru_sort: error out for >10000 active_mem_bp
Date: Mon,  3 Aug 2026 06:40:33 -0700
Message-ID: <20260803134034.15217-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803134034.15217-1-sj@kernel.org>
References: <20260803134034.15217-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94E4F20014
X-Stat-Signature: b7yjfymf583h4kznwioymiq56csg9ca8
X-HE-Tag: 1785764438-904808
X-HE-Meta: U2FsdGVkX19FY1AqsV+a3Eq1NyUuR8B6Xd13TmDChXE/v8VlkGYzE1EZMjS57dV3qj6ggEzzIH3/kZVXHRCLS9ob0g725ifP+zNLFtUliQ1CLbBdD1cFIMSf+S8OL4HpeVGNOz/UOZDOdQYWaFocuWtwBwStVtDRlldwFUWaCEYWDKxbk5/hXNVO2faVo18jW+YrCxktmZG4wQJQ3AF9QF8a6Fi8R6v1ZN6hRQ/aTWYE6UFMFCfkJoEmFzGoftO7eUWq0mgss6ypbqbXOb8k8TvEqqsFDyiOb/7DxaJUYDQXjrHcOaPOWH+UQS1dWSEnS51VC8dQLw+YaY1nPWdJvNA2XKdbWgDg/b8PSdmEh9CSr8fhB77hLn1drKYlHPefKyOIaAtWsRtlYRLKGunnKZ+pFMIhstkc2ksfciM66dbfgjf45WhNM9AysKNS80dyUPnbuULOljU4wBswoUDijGrmiyT2/agmZ+meOtqcqpAH3NWblStfkzAeaewcczTSvG9PhcqEF+KdmZKQhNM1ElmacmQvq4NZO6RE/9QwqvxiMxpRVLCSzUhvFGc6Pz8bPhN7J1SFxqXGXpYjY9hs5nbSybA0xecE7SI/VYLwmcsP9Bhy7F0QMKyPT3OFKab6lBuqeYONQleJfDxbVy03STd4O7/VDp3u+nQO1gKLCnP0lzd4XVQw32r1vdcl4f9q/0G1Q5+BcBy6MSwbV68ISBVFAPXcLkMsdYLuE0FGhGW4R84vBTgmQ4cFvnXiIKhst2+z4zfYtuWu+WSomit8KVjsKNanm4L2Ii2DNttkQ4lei3D1e4w3W5L99zdVY1EIGeGyOH2UX/v/UKWwD9n1nsl5b9SvnpqVU625pYXc0D/lypVeBovGekmacVUHm2ikc7/wqhlFWhodkgVagMe60JqT2Vc4CWS8twKlBSa6ePstdnWL0tKsgE+U/o2Z47Xa0KklVyB+0si6edv30ab
 0DVCMPRE
 ZMJ9QpJ2JGkDxx0+a0dYdgfg6qTTKwK3SmUSvFDhcdWI1BVIsu4F3zU4u+9Uioo+cqAML529KHaI999TG/8nO2iCY1FsGyo7uYytyQJ4XZqIUsv2HRqncixmKZ8MvUfb2Km9nkIgu4kGpCWGM3BGSPhaszRZIEMba/sTbdWU8gGjAcPpSMCgEvX6Lj21ne8ubm1pdsOM/UFeptSc51nfp27YbqjN32SzIdZsI415D3gEs0zH+poewmFRSdcfC4pfW1OYpk+bmFUGI27kjHnJWs1PQXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_score() can trigger division by zero if the target value is
zero.  DAMON_LRU_SORT lets users set the target value for the hot memory
scheme via active_mem_bp parameter.  It avoids setting it as the target
value if the parameter value is zero.  However, it also sets the cold
memory scheme with a target value that is calculated as '10000 -
active_mem_bp + 2'.  Hence, if a user sets active_mem_bp 10002, the cold
memory scheme's quota goal target value can be zero.  As a result,
division by zero can be triggered.  Fix by returning an error when the
user tries to start DAMON with >10000 active_mem_bp parameter value.

It makes no sense to set active_mem_bp with 10002.  It also requires
module parameters write permission to reproduce the issue.  That said,
the consequence is quite bad.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_lru_sort/parameters
    # echo 1000 > wmarks_high
    # echo 995 > wmarks_mid
    # echo 0 > wmarks_low
    # echo 10002 > active_mem_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [  597.421247] Oops: divide error: 0000 [#1] SMP NOPTI
    [  597.428848] RIP: 0010:damos_quota_score+0x6f/0x480

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260801213028.5127-1-sj@kernel.org

Fixes: 40d98d31cd70 ("mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 7e077084cb03a..3920d5042f109 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -233,6 +233,8 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 
 	if (!active_mem_bp)
 		return 0;
+	if (10000 < active_mem_bp)
+		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
-- 
2.47.3

