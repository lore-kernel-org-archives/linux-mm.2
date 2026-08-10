Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8C8C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E716B007B; Mon, 10 Aug 2026 05:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF906B008A; Mon, 10 Aug 2026 05:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3051C6B008C; Mon, 10 Aug 2026 05:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5D66B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:57:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99BF41C104A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:57:52 +0000 (UTC)
X-FDA: 85084908384.13.FE22732
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id CC72C140002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:57:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=KUfI1DZj;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786355870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aL4Y3k21PGVS3UmK0vSrCZe8gNNQ0oA2E/XU6jNiXg0=;
	b=iisefXKqO+JeY93AgOahlUr8M0kUlc1BeAoj5/ODL6O/zIVNG5VIn4Ya5rknIva6MuN9ct
	NHuhodv07CLlnu3HwHW5dLeFhCL7FxQJ2TpOIJE548OMUSkfbrbLrQyTc34RrMRLjJxaWB
	p7xatkDHvfEZqgSsl4PWmLjFPNmBS6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786355870;
	b=y+H8iBndQq7eS+sN2DIZNdbbRIzAhkfpgdeke90g4onRY+GIl0zrYFKtsbdf1IfMoqGLiX
	wC3NIoRFqLSveNOkvLDeASCyzI1Nc6momw36Bvv5wr3nPU3ozoIThqb1R3nlTCtJvld0lt
	iOO6Hk4EoQindeuSTpy8Vu0U9UPaDio=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=KUfI1DZj;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=aL4Y3k21PGVS3UmK0vSrCZe8gNNQ0oA2E/XU6jNiXg0=; b=KUfI1DZjXqL/Vruue4o5aBZ2p3
	OoixOh3ygSwcf0yEhumKG5uDDA11d84lWixiNYDVdNpqnMtMmA/9qSu/H7JTMIvA6ozviX92N8qU4
	HoHiHB3qxa7Gp3nwRXUJB6/gn3w208eQA0PYeaWo7rqZcEftdPkRsMRjvqRp8eaowh7qFEvNLrgY2
	Rd6UJClXQsR3owlDWTF7Y385ZrQtc/nz2mkWLuOygLA+5nHt8C6KRz+Twaiq/Zv8PtgClqTJ5+gbl
	zGyA4UbMItmYiObBMQKKIP4Mzq2qUSU+2xK68Fi2D6dV4aNds31V7wmI0lAl6gne0niurOL3Uq5K1
	Tt1RHXlA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtMlL-002fPE-2v;
	Mon, 10 Aug 2026 09:57:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 10 Aug 2026 02:57:36 -0700
Subject: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
X-B4-Tracking: v=1; b=H4sIAJCgeWoC/x3MUQqDMAwG4KuE/9lC04cpvYqMIjWbQelGMmUg3
 n2w7wDfCRdTcWQ6YXKo66shE3eEukztKUFnZEKK6RYHjsHqXj6Tr8UX07aWzfZDauiZmZMM/Sw
 RHeFt8tDvPx7v1/UDSyqAyGgAAAA=
X-Change-ID: 20260810-rcu_task_shrink_lruvec-711112e87de0
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, paulmck@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1691; i=leitao@debian.org;
 h=from:subject:message-id; bh=fmI8xADi6KWlR3J6/Hbvd2ecHxpAV7Iqo9WVc8nZUVM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqeaCToqI2nT8QJTT84s4jrQ7GMvHwM36xgVmyh
 5GeZm4IMW2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCanmgkwAKCRA1o5Of/Hh3
 bXz0D/9wIlKhOvTMTno87Pfk5Lc4xEpnhJ5xET8HtTcF1K3Ho1A0Hx/Id26g9EBF112EyxBkIiF
 5+DLmbUKFj3geNY6shSQZUgyH/jIe7AYj/Dfnmj0gGgno6sQ2TxGOadkpv2gZRTcWJKFwM15moG
 ySksHCa2U6y7rHfkn1QPGr9hXM9dz8KI55VUbTa8h4ZT2+V2ajxqMUckYlistFjA43J6eFa+bh7
 ncsWzyxcQzp+kDiEkeVYIVTrBuP6rzgqcBK898ZoSqsqMQ6WQ8fTI0OdRAovmiK82rwbvSJPgX1
 BXkFAffch4gPDytj/K4pMbZrHCTp/mfVCcpaX7v4EG2ISzN2El8BpRSFISafFXmTKtCKqH8QVdC
 DIFZhMk8Zrkaa7H6o7DZIwcPnbAJDxzuLdzRrCSTJC2obsn/TNtVmymRdUnZHXYgkgRjk/7HctI
 L22Z9mrWFukw1n5gYajo1z6oBYBLohHhNIyEFr3ncHO06B2otAGW+J/KbKFtwHF1cYdgZQeZFCD
 bTTjjNmpwMIVIltTt9PLrvomJaHLfMin5R6R96nIOnALSun7XAqR/A8VBCauE/8+Rg052j/Xu6k
 rxsqqPlNIw6TTdgXP3BbKZvR/m3gtmgoCOcg2CfsyOsM5Y34AI3jjYhPzPd9eazsWDuFiXeOMHx
 hilvBDWbfGwTYtw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC72C140002
X-Rspam-User: 
X-Stat-Signature: 6j7qhc1xd6j513iqifg7krpoym8wfirj
X-HE-Tag: 1786355870-966255
X-HE-Meta: U2FsdGVkX18Z02ztuQjdeAgwjyS0PPlh4f4QA+XuGzt/4R9ADPJfihuyirQU/wX9UaK3pv4+5GkBRLnckvychoyOD4xQdJyIXi9VDLbg2WXT1+HFr2zVvSa+j/AWvnnEA7bqARqYuPMBlyiq8XpggJYbpBgQqD9WMzwC7GjzwDby8sMbVuPszkPfNbrHwXJoWUDDeDLc+HGnTnVKTu8R7C+v6cIFwJUocYiQn8ww2AjkT0caTfanNCnGVKWajf79Sn+a0LBCYBSU7FbBldhNFuNfjPw7GEpmJL/TteF/B9ho2IDQo+P+y/Q6YCTur0KmnYhkwf+XqOikPL0FuH8jMs/Z8Z0La1S6DzaIUF9TdbZ/H43JgTa+Te79LvwQfgnhWSHh1eEdVR5FYDO6CiYXmiS6F8HryImVRMJ47/OwRbOCysJzvuA7OWncjAojP2p+tg83Y7s0ruwvs1r9a4LtwRsnReIX48OEMHrTyxKfcn1SAGdo22T3nkNYUBPc6zBKbnfAiSWmUZfepZjJlNnT/VG0oQ7daT2pn3Cy0sq3qe1hI/oTsZqejG+XOJynEnV7texdweksyggWrTiH1A6RJITfZV5vZyNiKHtmP2Kt76u3NbQbELEYL1R4TdDa8nOqAiefOr6M2vyCPNF8SaX+mccgH96e8nbu+yMr35AY2MOO7dkblxBY9M6lmxfrc6VN93Jc5fkIN+bjAuuZD1m6sEy/cFTtKxyxKhWqIdPqK5eevNkn4DQPuFqlJQSfFdgQ8hR+op1fwOPQ9ps2+9g5aOPbIXxX7LKkFwvlSXd4EoxuYt77WSWKU3tym36VMZcJO8+cOzKcdFMhGA8Sx+Q6nFNaG4iiV5j0HjAS000/XAylItLmvP1/0yh9x+Gn0XJF9mek3tQEk5hvNht4YTC2QgnEhwPvH0Ojl8oc8suzcgcAwoqhsCl3RG9YXMGI+8VSL+ESdHsJsbvegodExdX
 pyaRk9Jn
 igAYs0PoWNL8bltD2sBrI52ProryyeC7K89zmJQpvN2wK6qhmPWDQ8zrkoDyeXqbRrSTqoAwNbBwzqAGelOOT29sar1AvYn9N1ImCS1msoVnjB4Sq7C8SmlQZY3oSuO1kZ/9Lw7zzqAJSv6fjq7V1aKHVfq2s+fFVJpZMPiDLkJ/evxM3ex5rrAANs7gUL+FGUgTV87LZb8Q96lwcx8YnDQBqsKXGQ2kUBYW+/PWsjzoGTMqdUKmm1yAOqOlqoyDhhLXYcWH9kiM6CHdBKF7rEQHTw2F57uFS7Mmzhqsb5mh29edTH+WWFRRJ1HoJf+x+m1AXYYfwXWHiKEn8HnxihaSqUaSxp8hJUW7xDWeAwl8hZOyicwYAJT6HLzDETNVNTGw9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.

  INFO: rcu_tasks detected stalls on tasks:
	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
  Call Trace:
   shrink_lruvec
   mem_cgroup_iter
   shrink_node
   do_try_to_free_pages
   try_to_free_pages
   __alloc_frozen_pages_noprof
   alloc_pages_noprof
   pte_alloc_one
   __pte_alloc
   handle_mm_fault

Nothing promises direct reclaim returns in bounded time, and the scan
loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
quiescent state, so the reclaiming task never reports one and becomes a
holdout.

Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent
state even when cond_resched() does nothing.

PS: This has been discussed in [1]

Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26436059ea394..6ac2fde137b89 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6023,7 +6023,7 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			}
 		}
 
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;

---
base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
change-id: 20260810-rcu_task_shrink_lruvec-711112e87de0

Best regards,
--  
Breno Leitao <leitao@debian.org>


