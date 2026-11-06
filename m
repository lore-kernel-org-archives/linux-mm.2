Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8A7606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hsD06pKF
Received: by kanga.kvack.org (Postfix)
	id CBDF86B05B2; Fri,  6 Nov 2026 12:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47376B05B3; Fri,  6 Nov 2026 12:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EC96B05B8; Fri,  6 Nov 2026 12:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80BEF6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:40:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E69151C0EBD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:40:46 +0000 (UTC)
X-FDA: 85405409292.26.0A74E4D
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37D86A000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:40:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hsD06pKF;
	spf=pass (imf25.hostedemail.com: domain of 3GxHuagkKCFQF580Dy40D2AA270.yA8749GJ-886Hwy6.AD2@flex--tjmercier.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3GxHuagkKCFQF580Dy40D2AA270.yA8749GJ-886Hwy6.AD2@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793986845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y13j0LTUOpG3IGiPRUu5f/tDHT82BAGPGt8tpe2/3YY=;
	b=H3/lHfXGj5LXgAVjaFprhFLBuK48Qjbpg9WguzNnn+Km7OSGyzSmTbJlvlcKnlAI0+dZNq
	cKHW0S6IkyMFw/HiEi8+zgZENzHGIncmatP2G2V7aGFXaix/9ZT+dVfcmwdPyg6OkcLDXe
	pu17LAF9A+znbvlnpzJg3okhBXyTgIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793986845;
	b=XgVFhSlYBFOpepsYU77THOrIkrPAVgjNZG1GEStxFUCnuz4MD9qyLfuLq1X3Scf+6Xf4Z0
	GhC0dqg+7FOAXgPGmU4QSYC/e8/NOrxYF0+Pxx+7/WybNq37H01dGH1coFzQN4Cl6cQqkk
	/YKGNYOFCBLFvVV4D84tKyIUTGcPtG0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hsD06pKF;
	spf=pass (imf25.hostedemail.com: domain of 3GxHuagkKCFQF580Dy40D2AA270.yA8749GJ-886Hwy6.AD2@flex--tjmercier.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3GxHuagkKCFQF580Dy40D2AA270.yA8749GJ-886Hwy6.AD2@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-84fe2593525so1173634a34.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793986844; x=1794591644; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y13j0LTUOpG3IGiPRUu5f/tDHT82BAGPGt8tpe2/3YY=;
        b=hsD06pKFjr7WZJCk6SZ0EbhalUqU4tkbDiH5AkqlTA9kp3jp1Fi37Q3BY4N3JWV+KF
         uIW8l25JjjADWVWM4F4CrTxQynY8CDShKQPZ/SLY0UAWFWnAsgToWWbTzcQ9g3wVb/vy
         /I4DIVkhFkdRgZP92VU5ArtbQza0XalSxVNv9ZvcEMd7dmaK3fn1AYrL+m+088GJ4Ib0
         E0yy8ODtictIwh8/slayXKWxr6DWSnzlFJ+YTFcQmZxdG4IpvDR5+EdgENW5tv/obbV6
         Vr4LvJVTHMOYHoTNjPHYs8rTkKgW5jaTMq9RAQ/vTGncLUS0P53KrYhHwzI12qghZE3C
         VAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793986844; x=1794591644;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y13j0LTUOpG3IGiPRUu5f/tDHT82BAGPGt8tpe2/3YY=;
        b=R9FadZcCVuX/fmcdUpCx+q5CfbwuaKycrpu4Rm68IYj3VuCKdhwNx1jsoGxB8lrz79
         p8t9n7AS90Ui22loC0zHPaWbRuaBDvLCwFl2ix3T0lApC5CTUYa9KGzdVYMLAq/Lm6NP
         DcM8B1q6mP6jY3pQGxcy+VltQAotsU0qYy12mYDGlyUjjhB+o5Ka7hnRXR+Wi8qmi751
         DCCfyz1OPWzFMsqt/MJO6GMcjbrQoMtrdeTPTjBgDcQDy9wOAxoaAAukhHvuhrY+LxAx
         QsAco78RMJVCHg0W9GeTz1kFyxLphJrFf5+2zQuKhJ11CZB4NG0cBpQfBnEc9RUTGxDi
         yCAA==
X-Gm-Message-State: APuU4Z87yBo3fdAZZEdt0EOedarlgzwSM9NRQRA2gw+Vz8bnJHUUTp2J
	dX4fMfDQ9DWlkx5SxW8zga+Ee1B9RNYxDtiEB7PEup+utSNOGEO1Ej2PdwGsCH0Fa5YRmsl6S0T
	+8L774HrZDVstQU7MUw==
X-Received: from ilef12-n2.prod.google.com ([2002:a05:6e02:618c:20b0:53d:490:b043])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2443:b0:4f5:eaac:517a with SMTP id 5614622812f47-567e0f40db8mr2120139b6e.1.1793986843828;
 Fri, 06 Nov 2026 09:40:43 -0800 (PST)
Date: Fri,  6 Nov 2026 09:40:31 -0800
In-Reply-To: <20261106163056.541441-1-ehagberg@janestreet.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106163056.541441-1-ehagberg@janestreet.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106174031.740868-1-tjmercier@google.com>
Subject: [PATCH 6.12.y] mm: remove '!root_reclaim' checking in should_abort_scan()
From: "T.J. Mercier" <tjmercier@google.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, zhaoyang.huang@unisoc.com, shakeel.butt@linux.dev, 
	qi.zheng@linux.dev, kasong@tencent.com, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	ehagberg@janestreet.com, "T.J.Mercier" <tjmercier@google.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: daqkn1bmp3xjbsccnsykzrybmtm6k5to
X-Rspamd-Queue-Id: 37D86A000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793986845-108041
X-HE-Meta: U2FsdGVkX18mLxM2DyMVdhsJ9M8hEeOWwGtzIJ8/5jCg6Q2go+OIFyGpXOK/AKEz8NiiUMnHVKgzygzUThFFquZdud3jW4zjJ4b9hs/1aeeMH8YPAY3o1LpPqXIr1+a9lnwiePGWCQfClNson6td/XHdDp5bAuE94L4RCF/X8d14XWhMIP/tjnTSxVz7mkmFogyt4AJVRQ/dXde5te/ReTqnCxS9Bs2TPApJXA2i+mYHd8s0zUF5ywo5nGf9bmeHgYC7LZfVs+ATOSCaqNiBhNZYS1x7mn4jDMJMidnntC6HC9ju2iDljDQDBnwuFrsv2Z3DiRqZOzii1du8qy6wzx386+4F4aZiCTZ+DiQBEsxl/YeffD9hKx2mVZ7XvHRMD9eEr6ywysgcsb+gg2pDX7nLkwuF2DtuuwBAOsaM5pmqCcOMghXA1umWnD+RJ0DtVa8C84djQSukonr1zje6bcveENX4K0k/Vz1ndt8o4jy5az46aD9Rf/2QQpmRI4fQ97i6/W2EcV4JXolEcJTcMU9z34TaUPY2qZ8E/mpS5fTmJMVj/Gy7j7rQuAXZa46AfQz1bdk6MaEjkBEebXgwj1/mBGY5uOFieHxkpogmkxAwfrDftBDBpR+GKR9sBjlU60CBwfqB/NxfXhvD5+nw/uY0WduFIHEKQBU2woVVb1VzyJmLHMBjivHw42JB2yQBh2a9g8XaZujKB9QLhCrkIFERyRG2yMorepZCunsa5RBpJRKINzf6VToEg9Uj6xPiGRncZQwB6p3XlhosA2orDOw4cqefZnhGmIf7G43sRKjpmxwEdmm+ANOeX2s6B4KzaHJtZFW5siNub3wNu7YQqOFyqZRhMRIqjbMgq2qnGxI1aL2bCDXW9ToF8miUDbxGtnXNhlhJQXHA9Yjrnp1exdwc8agkMfuRRB3Kj6NSaEu4cyjvp3+No62XdPCUHaTbrZTSJwCywvww0w7FbCW
 zfj43mKy
 VwTVcSS5WMziMX2c0BjRforSRXpfiueO1VbFcVtGt7nO0KV43PrrXu3QAms0Vyh4DlxVGcIM4nl8Y9LvVeOSQ0ou++3JSL0HNa4FPKT/0CfC/FYG8Sbi4SlP3P2SsAGgqGZ9mS/yiE40tPvT8x9fu8BbCu01QsqSZ+4X7ww+NTEiit7NwWKzvQWn7zzEgd6SmoI0+2ch8Os/YhO9lA0AQGhbd9RhE20tIzkQTyR1KDVt2ySIdRCD3PCpTvuDWe8KvRpY+yvEAE1bztw2mdj8TOXQ9GQbxIhJLwEH6yfFi1zvm7AVObD1LHGdX0RLDOxia/rAouNmmr2T8hUrSuf/6Z3Tc+UexeeY03rXpVyBTcclSimX2Fi2EBcDoWopZn7DvUb6Pbkm2ax3566PKNeJyJ9At7BwTk9jsWOIQWNgraW0795+QgrOc3D5rxd+Nkga1y0/pEXhhdPpdmZD9/n87KilQSUXPe3fTUNLAzmYZhfx3b5wrtrR2SKJyf0Dff+AWIPM8cxTF3LP+LDA01SoDCfRhV5esBvyVMc6bhdE3ZGHWNugtwpU3s5nxEPthoCHaBzPt3RTZZiAmW9f5TDWzPs/r8NG6ZTznsgrzu+jtEjwBhu2/ZGVS86tcRCv+C9wrLjaI9ba5Ex/IABeSv2L7wkHlaDRFtQxEeVEMn1E5JRoC7hxhNBhYXJL5mQmv+BHV68U0tIY0rSnEj8AL7O2fAsCTqV4ngCjWvNdwqLIQ4xuczeyXczDt2tG3NzYTGBd5ab9rTokormz/F+7dSgNc+VD0e9IPkKItp7gj7rKmvgrH+HHML1OQM+Y+ticWX+GCo2cpiO2FSmu6LtKKCznRQxxw/7fTTs9eXXVQv5yKEsIp6ZArEGNz6Sxz+9suzCPwIa/T2WIVOs4nSmdEQSRnVTM6IOZChZ/EMhGuQMi+yA8WX7MumRV0GCcPomNOeRFxoKFZBTzpWs3Rov/KhzCbVafh5oTK
 3/w1YYET
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 19999e479c2a38672789e66b4830f43c645ca1f2 ]

Android systems usually use memory.reclaim interface to implement user
space memory management which expects that the requested reclaim target
and actually reclaimed amount memory are not diverging by too much. With
the current MGRLU implementation there is, however, no bail out when the
reclaim target is reached and this could lead to an excessive reclaim
that scales with the reclaim hierarchy size.For example, we can get a
nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
cgroup hierarchy.

This defect arose from the goal of keeping fairness among memcgs that is,
for try_to_free_mem_cgroup_pages -> shrink_node_memcgs -> shrink_lruvec ->
lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the !root_reclaim(sc) check
was there for reclaim fairness, which was necessary before commit
b82b530740b9 ("mm: vmscan: restore incremental cgroup iteration") because
the fairness depended on attempted proportional reclaim from every memcg
under the target memcg.  However after commit b82b530740b9 there is no
longer a need to visit every memcg to ensure fairness.  Let's have
try_to_shrink_lruvec bail out when the nr_reclaimed achieved.

Link: https://lore.kernel.org/20260318011558.1696310-1-zhaoyang.huang@unisoc.com
Link: https://lore.kernel.org/20260212032111.408865-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f9b5fbd072db..333e3c800e78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4752,10 +4752,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
-		return false;
-
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
-- 
2.56.0.455.g6c5a503b38-goog


