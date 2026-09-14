Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B920C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9B76B00A3; Mon, 14 Sep 2026 10:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353826B00A4; Mon, 14 Sep 2026 10:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290F76B00A5; Mon, 14 Sep 2026 10:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECD146B00A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B74EE40130
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:00 +0000 (UTC)
X-FDA: 85212639960.28.E004EB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24074180006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqRA3QNb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	b=kdwGjIePZ5lM7KNdujqunNSs8qT+ZxHm7h15upmmrHWYeWzPEqSfJ+jdz8bidrS4RXFdUm
	I78zQhbewBu3djpswyP0lX8eUaPLTnfdglBUUSKUubgsRxjQ01FqfExUsdvVrV1g3hKHfa
	aby600eqvC/TP6isExCcg5k4n+G6gDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397099;
	b=JUbae7GYmAWHn6vX0MvjUgI67KPpPf0NeV+ylMvDZisNSgIF+cHyFWPxnvdJpnFTZcxLXo
	DAcSdGtk86mbcBeVY9mM3yYRI2sLulvXPjZg5IgRORtl5teJAsfO6c8eIxF7buYWni0V8j
	vDEwzCP7uMto74aUB7n3m8xArUdoIMQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqRA3QNb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BB4E601F9;
	Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39A71F0089C;
	Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397097;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqRA3QNbasQ8DrHsKmqlwy9wG2lT8VVfjg6LzxYxnCX3jh7ux1jsm7Q3hdxxCndDN
	 nHqVED8xcle2ZqP9x1W0BvsO4H99I+BczwrFfpyeY15TFPxR5fzQZ/kG4jwkvfTmJJ
	 k2y4X9yD0jm0BwZXav5SG0fwghFLy4HfYi+TzrjyjqQ6oxyWOMxcpX3xxZtxvOE/PQ
	 NKp47PX10hdYkq6vxLJObHV26mJD9q5gxbTW/dD5I57cCE8Qm3Ba4vb5LqzPVGyxt4
	 NPBT10OFDmsTUbebfyod0oy2e+l9ulAIrrS3XdQIJ5knAVyzeSmpcl6VBu7moGNAI/
	 CIx4KguVr5x9w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 5/8] mm/damon/sysfs: support hugepage_size probe filter
Date: Mon, 14 Sep 2026 07:44:42 -0700
Message-ID: <20260914144448.93732-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 24074180006
X-Stat-Signature: 471c4xnw5ecurhbauo1qa45j3bocwnpr
X-HE-Tag: 1789397098-770579
X-HE-Meta: U2FsdGVkX1+NEV1N+qcI+ksnwAVBUeGmFRt/x0ZoCRoGUoVgflcaY2aZ3c5tBO2zHhQAOWZsg50+lCXJJLDgGBhWmaWMR0rBByRi1eXZtIK0BwtMuxqq+jcl3oUxwvagKkEyXDXowmG/rk3gVO2Ag6JtTaDd1lVlF6LkqXQm4JnSs+XQuLsy15yNIjGSev6Qe3rEvDAIdQFHYdFrbUQSOeGbivn0TvZSGraveMHewxYzPusw7agbBXIEBPKmV6Yk4l7hfU9SxKAWN8S4L4xOzk4A++U+rT9We+FpjTouZDuk5LDixtHomep150ssu3MAUPKDjQ1VKK0ZjolFfA10Y8O1SLnUr7PnfulgGJhDdpRyL/k1JZ5aMCnLZzFxc/7rsQr+qIs2FSsxjGdHw2cBXtuOQO3p5Wd6T/LydZw9Pz7MJt+weFTu42nkapqjtFe0L6pG3OONdEwDJQLq3gMq91LjyzqbJjX55klnH2cAI38HFu/HMCMZv9D5UM8IzkmWlODbDQIkAEJlWWIjPy5mUEt6pbdXXj0+kYHJ+m8HnL7TXoPSUULPaALOF5cJHIfwu6DMvU3+3vPMq3jKJqIo8OFqqVzOgNCxhTwvzssMT81sshbWhsiqTP50NZuCtMYBv4Z4zaz/0FmE9QMDdcZOJXhfXsCtY8qy8Ecfm43u75GFO00Z5Xi3j92fsIn1AJwYSyaG2O+xFgbRTv3o+kvfbPcOJWSNn6gtkR013rq3be5wFhjIUr1NialjHFkVkscF0OrDvednF9uBN+8Vz3rInZOCskOGSFNC99fS9DEbPcIUk8YZb56kz58dDY6mVT6YZY030WdsljnYOBlLWZW/cxNu0V036gAL8HJ+YskKxJNgerq+S4QwVSdy3X01li+M83KoKY7driiXmmtoENOFCBWbl5AOPNgWKlw1uMMNogh1uielll/JzRsIiBglfae8zYUQSIIIWm3UcrQBo/W
 FqQJVyW+
 WjJ9N+X41tXeyaC8IyB+aIask/kHFelZz3F70ApnKURzcYPEluJqCzFi1rCkSyhvU6RlzdNEzWfsIyUl6duCarvztcN37PKE/dmtrLnu54CNvDvzKrM9UaiKLAbsqxaXMuSbHNaiuPgbxfKuCkvtVm6wmpXy6rMjtnnFkiWLkQu7Gpp2t6ZPR197nM07DnIf5MZO1R7/fM59krUJJjvlxSmMR2w2+PmIXVbnlF3sB/yIj0LxLJRe0X2r54K7Cw+Xz8YVpgg9sL9GkP19qOEO9pn5raA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support hugepage_size probe filter.
Allows hugepage_size user string input to the filter type file.  Pass
the size range argument that users set via min/max files under the probe
filter directory to the DAMON core.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 8e8d89b8ed981..43519afb9eb7f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1007,6 +1007,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
 		.name = "pgidle_set",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+		.name = "hugepage_size",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2273,6 +2277,9 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 				damon_destroy_filter(filter);
 				return err;
 			}
+		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
+			filter->range_min = sys_filter->range_min;
+			filter->range_max = sys_filter->range_max;
 		}
 		damon_add_filter(probe, filter);
 	}
-- 
2.47.3

