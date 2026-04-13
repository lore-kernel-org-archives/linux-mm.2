Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E346DEBFD2F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC416B0089; Mon, 13 Apr 2026 06:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D6E6B008A; Mon, 13 Apr 2026 06:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CC56B0092; Mon, 13 Apr 2026 06:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11C986B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:10:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A99F8E0215
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:10:01 +0000 (UTC)
X-FDA: 84653111802.30.6FC67FC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3B8B40008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:09:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VCv21jxm
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776075000; a=rsa-sha256;
	cv=none;
	b=Z/9LhoTyWch1ERlkfjIVC26D/cxaQpktdkLGbUjKDbChjfhtkPJGp9a5t3G+ipdSVTB9kk
	yH1dnKfTGrDP0txX3wtopC6bU8joxmgEErjYNjgnVBPvER85JelyKY2PPr7kbyec+uxWaZ
	oKnhyN6nGIG+8I0yFYOTNEZ/VmlPMBA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VCv21jxm;
	dmarc=none;
	spf=none (imf04.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776075000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vSWC/GeLWhifKgmfiRwq3q8ElZnUZcjI/gPacHzC0aw=;
	b=2RWuL9QN1GPGV898+i7uzB4s4fgOvHJNt4LXDtv52NlB3tBKr5juGK9i5n1mnBaFGsdPXW
	nll2ghy8CkccfbvDzaqdmdnH9pM/Py6s0GVdXU/yYL8SyDbekprotWp+r1w0l/AEKEh3z8
	/WX/AmeDen3/X3zkf5wAB4n9Xvw7Lig=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=vSWC/GeLWhifKgmfiRwq3q8ElZnUZcjI/gPacHzC0aw=; b=VCv21jxmLcVGvOwA60MIs8XkT1
	WIQ/aymkI4asw9Itbt1KuONFmXxqnFq5Q19qhNW7pH1MlG8fzasxLCoyKITXqgDxr7TmoB1KR3kWE
	3e78k8SOoJkmiciE9yGKlMcdPMG1gnkqXdVCsbm1OPie4cutNiKHS2ZoJWS9ThTU8qSm0sg2POly1
	cuh8FgnNeeUbM9z1NuN3DZscZsU32GoXEBnv1q6z8jWWUDCRIo9L3DrRCknpG8EyxruHviSgHE4pj
	Llu0752ONDGMe6spjFXtS6/pEf2U+m+2Fg4p0XxvzK0EcX4jbI0bhQIXFTz7pqPfsbYvzz0rbOZMz
	+cnSn3Cg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCEEX-00CDUJ-2x;
	Mon, 13 Apr 2026 10:09:34 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Apr 2026 03:09:19 -0700
Subject: [PATCH] mm: blk-cgroup: fix use-after-free in
 cgwb_release_workfn()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
X-B4-Tracking: v=1; b=H4sIAM/A3GkC/6tWKk4tykwtVrJSqFYqSi3LLM7Mz1OyUjDUUVBKz
 kjMS0/VzUxRslJQMjIwMjMwMTTWTcrJTk7XtUyyMDI3MzIxNkgzUdJRUCooSk3LrACbEx0L4Re
 XJmWlJpeANCvV1gIA3XeHQWkAAAA=
X-Change-ID: 20260413-blkcg-9b82762430f4
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 shakeel.butt@linux.dev, inwardvessel@gmail.com, hannes@cmpxchg.org, 
 josef@toxicpanda.com, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, martin.lau@linux.dev, usama.arif@linux.dev, 
 kernel-team@meta.com, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3105; i=leitao@debian.org;
 h=from:subject:message-id; bh=mM7zBvgBx42iFC8b3TBI95XMtmZTg8a5yacqwUJ3qe8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp3MDXbEz+UX3X1wznCg47+bMMLUhJuXtNNGS+G
 UDV2+dls6eJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadzA1wAKCRA1o5Of/Hh3
 bV0QD/sE4UyxgXl5apSWceLym9lfJpaUKx/CuJT54NBvmiXhJsfK0YCrX6agjJv+/FSQnXQrIEH
 gyXtFTRw3Wy6Odt9GG1Pgn7N5ugE5aiA2GXwSC92IVUzYJSyHik7d59F7dzMe6ZLeLN70L852G5
 5eFrewoy5uRVHaFMZmPzSMhpOXw3609WV7NP9cZrrOwEvSQ3xfKmjPKtYuHNWviWsS6HG7N4F+L
 26oqRoGhH75UmRESMoQ5bF20/x5btY0PBZQl/v1WptA4o35ZSpOVbfOG2jlzFFZELMfTEcACUmc
 au5t7C9xbrmM5pTCb4DN2hgRk/+/da8nYE45M6d7ahcRiGb+w+90s8rOogszs3yiR56RSN2fYyA
 bCJ7b0WYuGZUjmHykfim0w2UUzIM6PZeXEwdXy3IUSXQuyEmYdKY+V6BiaYvrEkcAkwOf4xHIA5
 L1g1UH5Fbzbg2ZJywnTyMfsAimsw9FHHMJrE6Hx7uf/ZWlQgWbjI/LHLrR7cx2Gq8op7mGnbfrA
 8VPlUWaND6J0TDH0kQH96ZbbrLtjVJ73kJXDqW6HtOBreFBtYzuYziHtTy02i3lWKNU4NGOs22i
 0jPsw6NlfFLnJriIbYYqzzSxzMszKidANrHwWFIPr34u8PZyyC581LB8bpsS+HJvXOH7+J1ZSb9
 Gu9VbGs88iYZfpQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: i8p75oj5s7tsbsk3m7fg99nwn4ax7i4x
X-Rspamd-Queue-Id: B3B8B40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776074999-204939
X-HE-Meta: U2FsdGVkX1+re2GKuPQZro97ZxwnGVvkcUrOWitsvQC1gAx2uywHGVz8h1l+AsbXEfsN9BjK21mr3d7Zwewq1b46glIYnUj+dYjhisk9p0RczBwoELt0DzCNYUfifVBnEs9kix0UasqzDHVt73AhNzQpWYkPp6cbKSUx7HaA0tDgw6g1E1ibJkZF+j+b83f4gl0441+t8XOz50gOHowH31SYuvTuRRVWlKmgO0DESwa2TvELLnUEllO6NptvUUcbcNEeLRYBlA9h6jCyxL3Rk4prB8nzt9NmogaPePqduo/qGONAwHZFbzLJs9yyAmpG1yIbdY0CvrutRHcrM+EcYphvZbYZBygce03uD6kK2ARiqAS0KmukUNdsbvCMFy8bDuZtz5mP3qTWBLh72BvBQ1Aq6xnJNxj9yrw+4CCK2mhieifHDhyVLMYiU+7qT+NZWDaAzEN9rIPWdfeI9mkIccC/fbiVBQSCYCaeDed2yRus9jQbQxjKwHc8JdhyFJDyr//hF7F9Gl8/NEExEdPxIXDMYCWwRS75LEMSZGZRA7fY+OvrCDdz+2Jx8npirfSgoeSaKJ60dtG8RXd4hH8LPTySOAR18Xy40QZlP39CaqMStdPo9ME1baqCGMwQDKA5hcBa05/CE8La7rwzhBeWxabnz/HVaCIooUfkLyoqt45CtFXQfvG8SnbRHsQiRhmw7MmnPRep7prwkrXUZum6tu4aZDtgGX4jvWcoh2oULjZiNMJKckT63a7dZWpwdzf1SLclBGBWfOX4HCF0q3bWaKDyJTcmFD5llx/G9XgNIg0tmQjUyXSc3dBRu0pAZyLkC4hrkZcG2FqoXkABLYmSWUBXXCTxMRO4g1XeEyJgBkUpt/oZfzRt2gYJwovrOwYHxOJeiE9mRGriI8EtjcEZp0zxiWaJz7dojExjFnF1WRtiRgd1RwEMiz25K4qK+4LVOmcA9l10rX6cblMqfX5
 8gucuZoO
 S1YPXzAkvDZWiFBqUEMwFRHEc/3weEuygFMxYSeml/ZlzEX6ZtQLgSqhS8Hmh1LA1beeQIPuRKduieCKE1OmqoPDRWMcDpb2IWtAbFILD7JoKCdcKn6zY3HBAta9gYU/2+BVnfNp3fFx9/OuUV9x5ASG1RGfWgcq9lKaj2AYsTwFqpA0vgZve8jDF+iWau1GIFQ2x6TNjWhbzQ2OU873wxQ3ZxfCWrQFEUYic31GLoBREhOdHhuonIBWI+Z5stnxEo2YRLXqRjlAmEiw48Om7XDzwbh9FojMrL5O+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cgwb_release_workfn() calls css_put(wb->blkcg_css) and then later
accesses wb->blkcg_css again via blkcg_unpin_online(). If css_put()
drops the last reference, the blkcg can be freed asynchronously
(css_free_rwork_fn -> blkcg_css_free -> kfree) before blkcg_unpin_online()
dereferences the pointer to access blkcg->online_pin, resulting in a
use-after-free:

  BUG: KASAN: slab-use-after-free in blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
  Write of size 4 at addr ff11000117aa6160 by task kworker/71:1/531
   Workqueue: cgwb_release cgwb_release_workfn
   Call Trace:
    <TASK>
     blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
     cgwb_release_workfn (mm/backing-dev.c:629)
     process_scheduled_works (kernel/workqueue.c:3278 kernel/workqueue.c:3385)

   Freed by task 1016:
    kfree (./include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6246 mm/slub.c:6561)
    css_free_rwork_fn (kernel/cgroup/cgroup.c:5542)
    process_scheduled_works (kernel/workqueue.c:3302 kernel/workqueue.c:3385)

** Stack based on commit 66672af7a095 ("Add linux-next specific files
for 20260410")

I am seeing this crash sporadically in Meta fleet across multiple
kernel versions. A full reproducer is available at:
https://github.com/leitao/debug/blob/main/reproducers/repro_blkcg_uaf.sh

(The race window is narrow. To make it easily reproducible, inject
a msleep(100) between css_put() and blkcg_unpin_online() in
cgwb_release_workfn(). With that delay and a KASAN-enabled kernel, the
reproducer triggers the splat reliably in less than a second.)

Fix this by moving blkcg_unpin_online() before css_put(), so the
cgwb's CSS reference keeps the blkcg alive while blkcg_unpin_online()
accesses it.

Fixes: 59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/backing-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7a18fa6c72725..cecbcf9060a65 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -618,12 +618,13 @@ static void cgwb_release_workfn(struct work_struct *work)
 	wb_shutdown(wb);
 
 	css_put(wb->memcg_css);
-	css_put(wb->blkcg_css);
-	mutex_unlock(&wb->bdi->cgwb_release_mutex);
 
 	/* triggers blkg destruction if no online users left */
 	blkcg_unpin_online(wb->blkcg_css);
 
+	css_put(wb->blkcg_css);
+	mutex_unlock(&wb->bdi->cgwb_release_mutex);
+
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 
 	spin_lock_irq(&cgwb_lock);

---
base-commit: 66672af7a095d89f082c5327f3b15bc2f93d558e
change-id: 20260413-blkcg-9b82762430f4

Best regards,
--  
Breno Leitao <leitao@debian.org>


