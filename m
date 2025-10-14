Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EC5CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B708E014C; Tue, 14 Oct 2025 16:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B134F8E0090; Tue, 14 Oct 2025 16:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50518E014C; Tue, 14 Oct 2025 16:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94BBC8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:59:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61AD913C087
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:59:53 +0000 (UTC)
X-FDA: 83997936666.07.045B592
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C4724100013
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:59:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l20NnhA7;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760475591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E6VxKMU7UUJEV8NpebYiCcgIEykMSfhXGfboDwXAvHo=;
	b=5bfr16VyCdkiwI8QK5XrbBt8otPpvg7vIVzYPW2psemF5Asn0in+TOT/lNcVRF9lhkHcwQ
	Ni9QgqrY4p5O++UjjdB0WtuvBpGzyTkNg+uO6u0QJe+2x6MPqPp8SYiM/6vHF07iy/FRpv
	2xfh535IXw/ciuxne30LmCMSTucKdMk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l20NnhA7;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760475591; a=rsa-sha256;
	cv=none;
	b=v/tEQY6IjkBzERgIsF9CwbEL8Z+RNMffVPxzgTBGI8k75I9YMasplKd+yk2iGMuc1uONDx
	uF6o4LgS09M4B/lLM8JmOZNofiIS7DDAD5NmdcJBug41kAFQV2UfCcufsZYbWaCGNZN+rs
	r0pDCp3J+dPJji3Ai966LdDt2Kp3nnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98EBC4181E;
	Tue, 14 Oct 2025 20:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F46BC4CEE7;
	Tue, 14 Oct 2025 20:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760475590;
	bh=CwCpWIEbjznOcuvaN31S0BbRxv1BAYgTlvJi+4awgk0=;
	h=From:To:Cc:Subject:Date:From;
	b=l20NnhA76N7s1JSZeE4HhkKM+jYSydazTLNhwgoJedy5N4CCAltIeitOYzgB97nb4
	 yJSSA9ISOIGcN2F9dO+VCT1VLFrvp54XNbUrWUdkDP2FiTUs/ZDkDeRWtmzY/FhZ7+
	 Ag9wxqiH2XLDqbC9Ggh/zHwDP6RlKazJnmRgHiV2FJAyV/4/EQIRApzSRJoDFpR/D2
	 G0WEYRuObwpMkxOXM9nuIjaVqQyPF++e+Nhf/APPitSe86Ru9BXWjh/pmchadrsuWT
	 3t5rjmLa779clCBhePxGVHmeqGxEMLEm3mMkhZ7cPhhZloWcJIWfjfJzO+QjzwkjjY
	 tRLtLdypBkohw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: fix list_add_tail() call on damon_call()
Date: Tue, 14 Oct 2025 13:59:36 -0700
Message-ID: <20251014205939.1206-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cjbd4ufsdhwzizgqgujdpzkotf9arh7k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4724100013
X-HE-Tag: 1760475591-706351
X-HE-Meta: U2FsdGVkX1/T2ZxVmvG+vKuSFB4MnvFVxR+K1JCSwgd1C/6EMao6DygqcIZjvF/HyWqNNG9OrPkNOHfa+37GORK2+n0z6Jqqb23RUfjzG/6WaXrnE3SkaLNvqapsjBq3BjC+KnZKzL09XT6M8W7Q6Z1G9SHH/UsVwKidLUGRwFLNjT7BtuVadD+CfTUVl1w0Ll0zk0icrw1cWni4tH553MGVkLEGWv+920ClFZyZNyjoKBK8Dxt/NTIEZUxD1nJMY4E209RnoelTt2SF1j2iS4XTtPPx3KmHEqXf8CAaAyUGRefrJbH7dwKqVu/lYecMvu8yQiFMTuS2L798p7qL3ND1w2qZ9t2JVS0eumtBJvnaKPVxX2Xu0VOF4+tj9jzYwmtqdpa2uZ35OpSJH2WwAqd8bQOyCTE+XQJ/heqMoe4pCeacezxtoiLsZt6bSlGNkUXRYL9JGsEUMf0YcC55t001UarL76XoVteOa9ANA2KQlHj43gB78DDqp3QfrJwy6JOgQTFY8eCvTbuFH1cRHYz+UZPlO8f3jS9fBzH2TCcycYyVyHSJJNuPlnD1DrPQiPb7Oe9sOzVrgLKCt6c4thctEplc7Pe0f+wBawe3ImNHUUQ1oarW4VA2/gKPij+FBGLWbjrzp8sV7S72UthxhKQ8ZF+Ybxvx0vWZASoLgoMu3TS2mRjMlJSh59i/b/BGouBqhXgUGrbC85rxR7aW4fWNhbVwCMJAPNvrZl3cyNBpEnsS9WilqCsIZvwwMtrL6O407LiREfkbR2ckyfLXtPHiLIHlutc9kW8kS8WLDSltq6jAHhrdEKFyJt4k8tjuVgUQzILHxMYUF6ZpLtsHlLGldr2vrNKFyd3rMsv56q+5CHgHLnltFZnoL3iSQCYDZGCtDbZxRUIMSSYm5VLyNLL5CrnjZcc3+4eOYVT7l3ON+ogPK15i3dU7bQtx2SaxsnNPdJ0qhbczEqLl0M0
 phDKGfYH
 zwWe2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each damon_ctx maintains callback requests using a linked list
(damon_ctx->call_controls).  When a new callback request is received via
damon_call(), the new request should be added to the list.  However, the
function is making a mistake at list_add_tail() invocation: putting the
new item to add and the list head to add it before, in the opposite
order.  Because of the linked list manipulation implementation, the new
request can still be reached from the context's list head.  But the list
items that were added before the new request are dropped from the list.

As a result, the callbacks are unexpectedly not invocated.  Worse yet,
if the dropped callback requests were dynamically allocated, the memory
is leaked.  Actually DAMON sysfs interface is using a dynamically
allocated repeat-mode callback request for automatic essential stats
update.  And because the online DAMON parameters commit is using
a non-repeat-mode callback request, the issue can easily be reproduced,
like below.

    # damo start --damos_action stat --refresh_stat 1s
    # damo tune --damos_action stat --refresh_stat 1s

The first command dynamically allocates the repeat-mode callback request
for automatic essential stat update.  Users can see the essential stats
are automatically updated for every second, using the sysfs interface.

The second command calls damon_commit() with a new callback request that
was made for the commit.  As a result, the previously added repeat-mode
callback request is dropped from the list.  The automatic stats refresh
stops working, and the memory for the repeat-mode callback request is
leaked.  It can be confirmed using kmemleak.

Fix the mistake on the list_add_tail() call.

Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 417f33a7868e..109b050c795a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1453,7 +1453,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	INIT_LIST_HEAD(&control->list);
 
 	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&ctx->call_controls, &control->list);
+	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;

base-commit: 49926cfb24ad064c8c26f8652e8a61bbcde37701
-- 
2.47.3

