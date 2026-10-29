Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A333A606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zfnzwmir
Received: by kanga.kvack.org (Postfix)
	id ADE926B05B1; Wed, 28 Oct 2026 21:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F676B05B2; Wed, 28 Oct 2026 21:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E526B05B5; Wed, 28 Oct 2026 21:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6297B6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:57:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A6B8402E5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:57:36 +0000 (UTC)
X-FDA: 85374002112.30.61F45D9
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8A55520003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:57:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zfnzwmir;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793239054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BjcCXH94r7SdjUIQrzA7CN3lEGDn7+Oy+/jo/lJEHMY=;
	b=JD6eSQ/JxFbhQPQ3ct1QQ7erKbUh1Q+WJD48v4rExr2ZQ/p+QY1caLKTPMR1mza9qTld/z
	cOSWJh8kQk3ohShJ5y5u5dlD9YWa4WjNjF3zc5LWZV1RAWQoMVoA5rKEpX7bU0lNKTNvDO
	gQkTwqEJ3OoeZo2+VJOXYLNk8JAoMWg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zfnzwmir;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793239054;
	b=yJM//V73PFbMl/Q5vij5oJ8yCkfZ0kHAgXza2fyxYtCyl+K1Wxbd4sW7Ftc5+9UGzAP5Oz
	PVYDQlOSZtPLhuIzX5mZ+K7ehFW6KVZuwmA6ghxdbgbEg2g9dIwaJGQbOnOsTi4Aa+iwk1
	Jpw7PJqXlc54642PzkkrztxRE7eFQ9g=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso953983a12.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793239054; x=1793843854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BjcCXH94r7SdjUIQrzA7CN3lEGDn7+Oy+/jo/lJEHMY=;
        b=zfnzwmirmUBfUKkiKcWfenmmLOddz+zrKyVkIaZcqBacDWvRnNyQGZAk1wPO+yimaW
         OBsa8v1MBmQ9/pUDRUNKyBAaQ9VX5OaUU7ERuRZprbt7cnuOZrPcy02H7fWiMN0kGsRk
         1ZMftf3UBLXMJNxBFsJ0yBldwzKjXWbAWhyeh12A4SdhUvoiincDvwwlILOF8RbpkAVO
         eZKmCnVxj+QMkKHeU2p6JDGsrjPiV7F/nYT6pFPi9aK6HHzL9/aXSOHwQ3NjnkKimqXj
         2xS+ZOiZFBXRKxKl+6Kh3ngq8bHnckfYwfVJuzFUbCxfhz18ET88Iae/so+lEI93ffS7
         bPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793239054; x=1793843854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BjcCXH94r7SdjUIQrzA7CN3lEGDn7+Oy+/jo/lJEHMY=;
        b=0bFpr+cikXVIp5WGNri+akPJvr4wRhOsD5J/v0/svvPRfC+v7yK4Mp+MDcUXVNcnOl
         6PFINxXIgbku0xYtxPctQlEeSHExHahc+SsnD4ypLfLmBSRX4OD6nuaCz4Zz/EGXzvLI
         QA8aKoSP0pzOUCFj//ihmJp5DDC+knQaSiSnt2yJYyAvfnlmO4fqrT67JDzMxd/JI1Yn
         M+bPLIC0t3sBhXJcPxQjyE0LzF7MaTQw5Q0MPg6WEyIiSuPj9jb4V7wPLrV3rb9i4NS+
         Flz9N2ARerR93c7Zj7+TOrBISRCTyAKB0m0Iuzvk5xoZWlcq1bIgGXklR31DAunPzVo0
         GIGA==
X-Forwarded-Encrypted: i=1; AKwUvBznPSMZjBC9zPT0qiEMNdtdUTUCgOTom4p42VZapm4MxUKqU/M0ezxUzvw5PdhT37jApbR5XoafRw==@kvack.org
X-Gm-Message-State: AFq9FYLwumJu6XKKp/+qzf9azLAxLdvHJFirez10nhtKRmlmfP18zTO6
	QJ5XbOrs72pG2CPrONW/lWKrx2MZH8RtBNURmn3THo7ercu1lpOJ5IyZ
X-Gm-Gg: AYBFou0fpwrH4zgxKlwwMTzAIvnjs4ZBpj+AOhiuRG9GRqlugyoq1JZOfGHP4GTC/qD
	8cXTrSh3Gxo/YjcE09v0ZzE+bYo50zU3334rMsPMEMN17i9dFmOA8lLceBIMZDBltNPYcIOspOe
	BTJ6oqEGk/EtM/mIMiXxHGKp6h1dNlnP9rnZViGev3V8S1fYhl/cEEdphZldy9Ge1+MFBpFQPRe
	kRH9hNrwupKhQ+0WzH01AxxARflk1ahrlxPTclS8CQiLfomYnE1x8EefcpV6ACakSHIPmPwGLCv
	3r25DLIo/q5fpnsXnS40KibxPT6GiBdkmGkPki0ChiPlK/lEJUT0CjNEG6wsYzea5CWysWX+ASX
	sfirwGoXQtFkEfht7ktze0jOYgh6vMZydg8pJjMEBTTBPq0SMN7iDqcy18vtEH9o8vpFHNIQfZ6
	SBEot7zX23egtAnqLyKZR0WlCYhO7Pbs9EZlVdGSQ7YjPkpd9X4y8TAUzOKuBBBWBzBx0R611+3
	B4MXsA1tb0iYybDjVws5DVQljRpmcrPNumAGCaTH6udEr8irJcRYF0MvEw0vlh0Pjf/a/qxvgie
	HW0s5ugrpeCcfCIsz9ysRISDgYiwBTJ78m+oe5nvprcWWme7lORt4wZ3fdsz6gM=
X-Received: by 2002:a05:6a21:39a:b0:3e2:8f64:e4ff with SMTP id adf61e73a8af0-3e9023c11b2mr3442531637.31.1793239053550;
        Wed, 28 Oct 2026 18:57:33 -0700 (PDT)
Received: from xiaolei-VMware-Virtual-Platform ([219.142.21.190])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8cccbaaa9sm4534694a12.23.2026.10.28.18.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:57:32 -0700 (PDT)
From: Xiaolei Wang <xiaoleiwangxiaolei@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	error27@gmail.com,
	xiaoleiwangxiaolei@gmail.com,
	yanquanmin1@huawei.com,
	wangkefeng.wang@huawei.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH] mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
Date: Thu, 29 Oct 2026 09:57:25 +0800
Message-ID: <20261029015725.17378-1-xiaoleiwangxiaolei@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A55520003
X-Stat-Signature: rdgw6e887nop1q7astaw7icw43jwbnpf
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793239055-87227
X-HE-Meta: U2FsdGVkX19CsV6fPYANd6BzrmAncSEsH4fxj2jJ54HOYcvjS+KnfDPe8Gg1CXBS4KBr1DKOB82DOmmYsQUpBPzHC2lO7856LtTO5F2b0ekq95xb0pVYAmM+V+ZZswJMpgybozPSQ139XcXwSbuEgiw1/jPYoYZdvNKiYczZcmRjXV5T/Be8gKLPw4+ajeUt0l9o3NeL0aTCkayE9aO0qKk7SjiYUCNON2f+ilTqoLxe8C2m0+ObY0GpXdntPT0NI0eSVETXNDIIG0xNonPG7Us3sMGSOnhu7TapDVSMaG5ljFGR5Idvz0/dNGPYCJwNK7JwzAXarDyZrSLb/Mn8kRg74yehZJTuVUq/FNXNkE+hRCXQiy6hAlVjj5pvTKiVC3PZP0IKWCXnEpvih0jM0UeeKl0/NGPvWdRcdFlUd/aIdz2CkboVQt6SENhdj1sQpeQNx/lIPTuo9VfBRCOGt01L6/YKyGaoCIw/P4fkLXKub9ySIfQGvLW4d18yydWEw5JvULEvP3sB+F8Ugy3jbYaGEZPiBiIVaTUPlnzoPmJI64WaMavQgB8edIarPajs9uxSvb5tN6kFtkkpY+ihYdwTVohSSmDaRkLkPNtCiPQJobkFdeqtFyxZcpCjl/KWCLqeG0B8rtKlLCDjZMu9af+tO371On0rP3UKROWQ4n531OE/A+LyFEUpQ17kcfeXUTYGB/J1d5mwFJrXGPRx27IDIymvETtdqBRrL0iV+bm7tgG9DAPMuvW6YyJfC296QJfc04YOU2jcPxGLNt/C69y3nvRzM3YWrSt76KRtaaU71wHfaTS2ssWq0q/OQCn7LTAYvF2v4dnHt7mzZ+capkRAIHawK3y48dGybl/vcV+aV1mqSrBxzmnKI375Mm2eKVzJilQdVd4aCkz2yhoRQ6NN1tza6tnpdfjLPsqBXhV+mwPegIHG5CNp7ixBLJ69ga84Hqps6jR60FlW0cv
 E0R+VGbI
 2T+NAoaDqP1XY9lS5Yvh6rYAcFZaSYfpGN3truRIReSIOKn0p4E7evAVp0zQ0in7iARijTi1YIqH0ip/JppfhxF7rlK2JgyTmp0uwae9S0izP8HxzoO8ZwFUVz6KRdSXVXjpnk7qHAn0493TN6tquKesKJYB1es52RjzsbVjEYuuaWkd0vI8BjKQnNDeo0ughhiYsQlqZLIUYti4ixPfhd0Xx+lPZUteH2D+ENSlYANPppNIUFLSBuBa5Ui6YM1KvILYHZlRaS9tEZ1dIOX6psC/yDDwY2zbTjf/v0ayiB4iln7fYXCX1GIFYQ+wam1WV74rk9wUVHFl0QkBBJlEmyajrE5JEj/tLhQKmvbFkP32ZSdwJT4UUPhI9LquEWsQEjwXo/XVs6a5r5aDBYpnjJL4k70p92dyC+Qkq2WvgEuEOhQA32vaF/Y//DOCt0UAetVafTnl64AJ+SbrgkOFjOteTp2XARkGYBvaEfuzH9Y7jTCy6Wf7HhsdIoad6SOZdOsY4a1e+zx6L9Lboq+UnxLSieaGhUbtxEqFfGqZt041ZxEkB+Y0CcJl/llyKKg8a1SCQI7vao7QVJttWWYSA3g9xWSbU5tLNuM9+p9e/F3fmNNbAc/3sqfxruA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>

damon_sysfs_test_add_targets() creates its monitoring context with
damon_new_ctx(), which leaves ctx->ops zero-initialized.  Since
DAMON_OPS_VADDR is zero, damon_target_has_pid() returns true for the
context, and damon_sysfs_add_targets() therefore calls
damon_set_target_pid() for each target it adds.  That function grabs a
reference to the target's struct pid via find_get_pid().

The test then tears the context down with damon_destroy_ctx(), which
releases such a reference from ctx->ops.cleanup_target().  For the vaddr
operations set that callback is damon_va_cleanup_target(), and it is the
only place where the reference is put.  The test never selects an
operations set, though, so cleanup_target is NULL and both references --
one for each of the two damon_sysfs_add_targets() calls -- are leaked on
every run of the test.  Running the test with CONFIG_DEBUG_KMEMLEAK
enabled reports the leaked struct pid objects as unreferenced.

Fix this by selecting the vaddr operations set for the context before
adding the targets, as the real usage path (kdamond_init_ctx()) does.
damon_select_ops() fails if the vaddr operations set is not registered,
in which case the test cannot exercise the pid handling and skips
itself.

Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
---
 mm/damon/tests/sysfs-kunit.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index 138a4b8d14e7..634387c6178b 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -79,6 +79,14 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
 		kunit_skip(test, "ctx alloc fail");
 	}
 
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target->regions);
+		kfree(sysfs_target);
+		kunit_skip(test, "vaddr ops not registered");
+	}
+
 	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
 
-- 
2.53.0


