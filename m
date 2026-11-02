Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3431F6070DBD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TqJySAjz
Received: by kanga.kvack.org (Postfix)
	id 4AB8E6B05B5; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486546B05B7; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2056B05B7; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5046B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8826140110
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:38 +0000 (UTC)
X-FDA: 85390455276.18.4483669
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C77A31C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqJySAjz;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CF7ShlzIhzwBW+s3yeojdJySM8gPCUgFHqUvtGr8dsI=;
	b=cxPmDrleWbiV3iHNxKoQM6kti6Pygco6DfGS662PCmTEvrI1FXFoJePUTE6gtKVFnUM6iL
	6Odnv1JKPZ+fri5fYRl+Ki6vkq84ZYq70ugSL7Zsn3BDvNNkjccJdtvt+QZTGZHhwXo46M
	EQk6YelOyEY0SPOhYgWNj7DOMhpScxY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqJySAjz;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630796;
	b=wBp9ZymhX3hDozTqj5Pasjz6Q58cwZgcdGKEOi+pMNhonI5JUn4igExQ/etkusOglWn0F1
	vTUSSdG+krUoG+xECWf50Oaxcr9xL3kv4uM9q9MC18tRVNcli1loH+WWnMIwzjGAHzL1Ri
	c7kx52RlK/N4XjkWiUk7l06fJaoQY0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3087843CB5;
	Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1361F00A17;
	Mon,  2 Nov 2026 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630796;
	bh=CF7ShlzIhzwBW+s3yeojdJySM8gPCUgFHqUvtGr8dsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqJySAjzHxs1XsxoE6HX68+Lx9kxA0VsODxNDkN2aNx1ie4S+lOd/IUDbpnsK3xcJ
	 BuZEeEKcNnFOBhAO/zxqRTc0Q5PyIGNVV2bdypcqOq4Ff68Dr4tvz6MfmRNvlR2s3u
	 JTZQsnzeiLG6nWB1YqcjozpXGkG6f3FUkT+YqwfZ7pf3SaAxPOUYIkdJNzKDus9vD+
	 XEzTQ+oe3vQI217NaRmyTT9O9eFjA0IMO+EwS70ITn4fVk6szbaVdNDXfVxiP190yL
	 cYgwVNApXVOov1zQwkQvlYCneKUEh4r1eB6RloWpF4/aEkO3/yN7dGOvumW3npSz6k
	 oICrkeRJi708A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SJ Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable 2/3] mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
Date: Mon,  2 Nov 2026 06:46:25 -0800
Message-ID: <20261102144627.88843-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102144627.88843-1-sj@kernel.org>
References: <20261102144627.88843-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C77A31C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kx34pah9n1mg91p8u6eqzjcpyusash3a
X-HE-Tag: 1793630796-977943
X-HE-Meta: U2FsdGVkX18yt9reBJLv2Z3nTYHtSaOOyMmuxO8lWwgkTUKzbFPHlMewzsgIJzfmERz0Puqs5V3kO49/ugwizSqTOq5uPnRZviTnTLu2de8uYNTg4NP36K8eHpjhfRKiZraNPguazd6ojZcasDe+oz6AFzx2VIHFNNdhxQwmC0HnsQIeWzVQybFWu391/zCV9o7vL2yBwl1LpKUJAbgWB4rvowvGptHnHdGMQB6sAlJitTYJmuXtR8ncMqb5pXTVHkMlui4Mw8wybNrs0EtMGJrkVCHOR/TccetvgHv31BmmKCtfmcBL1JbqMeVxYxKP4GTVwFLmkuv46ZoQwluDOHfnuvtEZSUasdVPnHSzQmBp5L0dr3dC2BkW7gYHYPYU39EefKLCwPGczHtpMBeAx2zGh82BZRu7YEq5AvvgwfMS90deI0leLEmZtZZcN5UPYTTsPISAzznyJmKfYcN9EpaH5fZ9lTWJTITUMpb8uajWEcIOYC+DWtVAmMrqNs8Umokc0I00IaNssLvTYPp89UmlgAIpnYr0K0g0yxzHX1VitJPirWT0bdl/f7PEiYjoz4Gf0A9m1I8iuzJPcoEUHm1mq2lonfoyZV6ml94env8dbnod0xuqgaWnLU81YxVdVgg9rvlDHq1EUGoxYNkuaQXtNcvzwXt5T9sa0FCp5UCtuilEqrACA+/cQytm4QLNuXUt2pnZatGzdjXqgWd7PzNX+86bSQjo2MFJcniTf7kUYRr7LBuh8h+VnR3GBf+6SMI8PDWEHqwZr2ucsx4cSH96PK2sqLgs5ItxFXA4mfZlQX37KefsudD33aCaktt7D1DREA19mR/1Q3dB0wbA/UxNDFVnoxGkv4F/gdFeN943Zxm1xjumk/iXF8GSfrVuEBD3TINYbcVhWQ7JtljXUM1qdEV3aq0TWqhKQj9oMKbHXI9JyUrazzVpG7jFd4M4UyvWFA+dtoY8LCYRBwu
 IsnAMLkl
 9opBALR5toLzPdvFZgWJjxmReU44dBEa5Qw0kIg5tKXylEsZKuFH1E5tAoGtUuOvkPRl7feOLVDN3DHt1Dk4+OGCfsYsHv7uCV9rxHNUBzCnTZOkEyn3szDsx6X27TyERu6mB6KwxuGY6VU+zHxwIMuAcqCHzC74V7cI3VE+BJmckLTlRpHroSuLEAuTWP7EgYxS7D553kaoT8cv9vrRnjhZRfdbBokUnShfNrdI6w8N4PlQ+nki7m+5FP534k02rUV/Dr8Hv4Xy/NRXRCMsZAT/o9Clvl1M7D1yljsNA8VbuDCB7XW+SWg9RXpv4aikUcsnPgEnIehUCB4jyN6YBhbC9Cqh3IBFRXuwiL/LOvYJFdePeY8dyW/OZZ77xeXISSLZNBgKOXmdBaTgpRS8yBsuueBW9EBCmgpZNKtHs/2X+IkJDtFCt8PVz3YBttb+Jh6pk
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
adding the targets, mirroring what the sysfs interface does.
damon_select_ops() fails if the vaddr operations set is not registered,
in which case the test cannot exercise the pid handling and skips
itself.

Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Cc: <stable@vger.kernel.org> # 6.7.x
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Signed-off-by: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261029075609.35661-1-xiaoleiwangxiaolei@gmail.com
- Add Cc: stable@.
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/tests/sysfs-kunit.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index 138a4b8d14e73..16373ba751dbc 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -79,6 +79,15 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
 		kunit_skip(test, "ctx alloc fail");
 	}
 
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		damon_destroy_ctx(ctx);
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
2.47.3

