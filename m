Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D57BC79F8B
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949266B0099; Fri,  4 Sep 2026 18:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7116B009D; Fri,  4 Sep 2026 18:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACBD6B009B; Fri,  4 Sep 2026 18:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4164A6B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:51:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFB681A0221
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:51:11 +0000 (UTC)
X-FDA: 85177577142.19.133F001
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0773F120006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:51:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H3Yarn4y;
	spf=pass (imf29.hostedemail.com: domain of 3XEubagcKCLsxgfmjqfhpphmf.dpnmjovy-nnlwbdl.psh@flex--wfelipe.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3XEubagcKCLsxgfmjqfhpphmf.dpnmjovy-nnlwbdl.psh@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788562270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etVT3JR9OsRtloAyimt/t5S2ubPCA2IZVBKjgKO3AfA=;
	b=UvyJvvZiqt9yOfkN1GjJm5ElHAS0bYfDPbwiJrwrEgBgwoE9X48fbfaX8LwdAVytXwOeVD
	dcER9CXApPrRD1JB2+x144LsjRgi4APhiG5og2yZtlBhP3eJP5qPYKha44jaWuE8P4ww02
	J04tT5Fj9Wu6epyfzMciBMh1j2H+mCU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H3Yarn4y;
	spf=pass (imf29.hostedemail.com: domain of 3XEubagcKCLsxgfmjqfhpphmf.dpnmjovy-nnlwbdl.psh@flex--wfelipe.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3XEubagcKCLsxgfmjqfhpphmf.dpnmjovy-nnlwbdl.psh@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788562270;
	b=sUhofC8vbnMNX+fbkMSRhfyw8QQO2e2trGzYkFkkb+kMHE+GlNpzTfNHGZQGgitupS12q0
	NMyB/Jrrz8Hqe2VJGqF8kK2MVOCAmHhK+esluklipXRDlVRbBWXRyfVh0iB7Hth0kZ/pPh
	VRMo+499kOQhuQRC/JUh4onBqJJvihY=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so1853091a91.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788562269; x=1789167069; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=etVT3JR9OsRtloAyimt/t5S2ubPCA2IZVBKjgKO3AfA=;
        b=H3Yarn4y30I+yyZWC/kYif5eAUmZxnCc6j43U5wSNhzlcQnlXXxG/ySAs8P+St/sJy
         zVitUrpv5caYi/6qbyhmxNH+7PfQAIZHlOvYQpgUJnnvmnwMDTfHbGQBOi99tCNopfh3
         lnz+YCpoKMQwLGFXODVbsQvGCyZ17a0YgBwczdWCwW+O61lXtwXe0IWh3JqHyLw/7XOU
         tpA1/TFevvZF0t18SMLO9Y14+8nxoZt1wkjcHEZOvKL+isjJtI8UleKmxITayOYV9X47
         QJv6Z2LoyiDabnejuFKQ1us2pgHkdBs0GudoDGIjubPFq9aZ76Gv5lTX0lvtvdocCnGk
         iOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562269; x=1789167069;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=etVT3JR9OsRtloAyimt/t5S2ubPCA2IZVBKjgKO3AfA=;
        b=CfQrENQikZozddQrhyINxf6Os1c2L5YvGwM1kxp2iqMq7wt4NPOXZHk7GLqFv9GT+P
         kcr99FNKJyPwO0HQ+ysxyg/OfOc0P94/4R5K6j+ggzBLCBzOsh6MorAptG5nm7mzmo3z
         AQlBj/B1eZWTh4a6nVXoX0ra3Xm0Wk5dLVNMjCgLnhVDNWrjod3fgZGGEACajbtHdbSI
         yQ6g6Sd4PvfLk0JRqtdxomQYSrT/huBagyLekJCiolGLmZ52XUJawhvsrGabdgxocffP
         00cuw/P7iBbXA7OSfH1oRFItduHk9ht/mBfgLZqBjr7qHamGiY2upKrsGhyPvy08TOGC
         ARoQ==
X-Gm-Message-State: AFuF++kUTJNX1OUIOWMgXY9xYJWwrpuc4759208nRKMJ13W+NStZFcGq
	weBsQAG866HGDeOPNoVTxRYufkikmTOCqmR0C4w0n9QZArM3/DEW3jJoZtyGb46vjG0/O5gWvkp
	IT/1meIhfzA==
X-Received: from pgu38.prod.google.com ([2002:a63:1466:0:b0:c9a:53ea:434a])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4388:b0:3da:1e2f:3be9
 with SMTP id adf61e73a8af0-3da3a0b0070mr14239936637.22.1788562268577; Fri, 04
 Sep 2026 15:51:08 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:45:13 +0000
In-Reply-To: <20260904225103.2955759-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260904225103.2955759-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904225103.2955759-2-wfelipe@google.com>
Subject: [PATCH v6 1/3] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kpmrbfji8yykxxepke8a5r87dp5uhu91
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0773F120006
X-Rspam-User: 
X-HE-Tag: 1788562269-637633
X-HE-Meta: U2FsdGVkX1+uXI52wV/WANH9wSifc14t+GSRTZkjt3wKrWocMG9LJZKcSG+VBi78BPpl6GZJh6SaMfe07+LEf22huymBweNn1FE62hoYI3Ha3+VT8WKBitKldk3Ze4yngs0O8kaiUlQp3jIN4gv+QpJuvhBizoccsncWWMhET86dWqMI3bQsp+fPzqrSs/FfTWjipA31yfDfIAoAxRykEVu886MZeR1cUWPYuhG3OJcYD38OMPpkxfiuCic/d2tz9wWfhktHyVUjQfSjYDMjuc1loAq6grl9Dg0Bb70dzbtz7OghNLnOhZJvNFK3x3MJABQDLgA2S1fOv92ZNWvJSAT1B75GnE8Rnvz0eB4Cwe9X4DckQROpKNoEqTdOTKrMfRE7EAE5AkDu9XinCXEQUdngXW5DEkySyk3EFxembKNtbvrUWu2qP7HC0PIiOVrHuzztYfCnFthsJdzVplAck3YZtunlM5ea2XaSLID8G/FTcmZUbWeKjIFRxKxqqHbSxdVbtVdIOq2cYQW7/dQnp9hbmfm4QMtVWu2DzbyflvRJ3ewJ413DZ3w+Bi9VjiuxvdkyE78XfTgmOwLIu8PtNVgbNPSglhyP9i/d/Ay9B3E8BCVhAu0SlOlPDnnq1kaIizAggCZJabN1f61vly7Cn+h/Ycscqz2fbIdqznnT4X7PfrG+VL8CA/aDf0+qbV7cVVwQklCQLf+gBb7bn2RxkDacFfxqYRWFKKZLJLSIChq6u8wABVPp2XpvYl+d4F6paAq4DCTRamVZLtsmF1ESNDEIhJk8pJQC2UcZAeO/qvul3gyD9/crnUOZZyQ0tGfSOv9NYLteVJpTr8uOboSSdCGS1B7s4M1XAq/NH7WlntF14BYyCdHPWGrs+FARC8MzHamwC5yEm49odjM4h6u5SmE2LpsmNBE9/KjD+NtZJpIQgn9AkmhRKGl9l/lzvMeqEi6T60wI1P2PHrIxeDv
 4iiU+6mc
 b4DrpskCAXC/hfEASviuhV8Oer2U86wG8GywblCmfAqUTq+T7yXoZlQ/m/s2NyvoAB5d7glae4WSmy8Gp3aZ+X2Y09o+OTLxSueJX2ksQPGCkHUGmDRhMADmChxLS51bgamsCZO2yuafTcyU8EXTB7oQOB1HA+zXH8+NFvCvkv8//GfvecD4MABg7w1gxRFZvrUuRbWVwea6vakZMRtYG+AEVhdR20jp9CmRWSyUbrfytK1cdblMGN1uhBzWHFvIBIPvG9geBLwPVPOKsZrcZcJ8w/E/RpWMEYg1l3+uTrThoT/0DZvfBLEwgbm7r1yo6jvYgTbgTIsK9kLO9QhpTJJ2aUDFUs3c0o5i5XwBOxcGz3ZEoCR3r0KO2WB2+cyE9MGnxtILTynBwcHt+Bbyi/52itFpSALQONH8h3c3AEp+wqVm93DQVtWrVUIATiYMl7zJfsz/xD9oLm06dUPS97PxeXMSJSOnshWo0iVhE0jxlWoZB4+0z6SGO2GvljrjXZ3L9dyMgiKCXnjiR5TK8mhrXG6GYmmTGduezdCvU5hDsnkGVzbR9+qYWuqSQrQkQWr3CMmjgeIbEZwnMW40tvC4O0UJY2AWx56n40Z/kJVKZ3oPoImn0N750uDZIx0NKLbqZwSpZiDpKkHebGepKLi5TfYZ0bd07Kvkker7IVa98fpK5kk58i+jWpTilA64Js7S2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately. However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting
task is switched away via finish_task_switch() -> cgroup_task_dead(). On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 609c48f38524..8f2c9aa4776c 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -408,6 +408,8 @@ static int test_zswap_writeback(const char *root, bool =
wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
=20
--=20
2.55.0.979.g7e5102b832-goog


