Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D01606A883
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 00:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hp45uWNU
Received: by kanga.kvack.org (Postfix)
	id 33D426B0630; Thu, 12 Nov 2026 19:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE346B0631; Thu, 12 Nov 2026 19:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204926B0632; Thu, 12 Nov 2026 19:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB5D46B0630
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:57:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E76142237
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:57:59 +0000 (UTC)
X-FDA: 85428283878.06.10F53A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C542AC0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:57:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hp45uWNU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jfern@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jfern@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794531477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp8Nm+ZgjUiagLtuzyFv0b5XLhVofSDigIQqeI46CSQ=;
	b=OfycR+XuKhOUsipQeu76eoXqackqaHWYleKpwqS6hyv1sQMFG9mD2HjjPWNWCVA7CCG0Aw
	CZQ3+xQc9C7ejiLDXtUggpzWaEPJltdIfJPThei1tO2OQk0zUvb03xE8wYfaoKVa1sE1+l
	4ObUicCj7TqvDIMKgMLMSXpaOPbBx/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794531477;
	b=RHu04dpa4/zDjv4/5bIzjzo4DwLzsMLVj58ispbxuV/8nbeyBZB++/+l/J5qyaztjkuFKp
	10OqzDLwgO/2PJIo0Cshdk63OiXCtjmv3j1Y4Dqh7d68yHpOMGFKFoNzPXZcUV6OQIApwC
	FbN+S6V7i+zXk9Chlk6nmdQoRvwtn14=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hp45uWNU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jfern@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jfern@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 3E5A74655B;
	Fri, 13 Nov 2026 00:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D04721F000C8;
	Fri, 13 Nov 2026 00:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794531476;
	bh=mp8Nm+ZgjUiagLtuzyFv0b5XLhVofSDigIQqeI46CSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hp45uWNUlx5lB0g1PVku3oGagTt0MsHS6lj3WhUUxTU/sh90uSTmwJej9SWhs9KJC
	 Hm+EDQxGKsuT/SpE90FL0nUljOt4SQ50f3DQTpORlTjcMn1eGds/369qset1q1ilhg
	 YTnqJOmqo2upEg86MuCUcfvXyaRiaMhTduOXq2l06pteuFqveBX9RusOBL35DLuc4D
	 fbVJnHQ/myzneuQZRQhWLO24RwluZ22WkRwqWBcPwrWO/4HJyBU00Hxz2PsHVVxVxT
	 xeHJ3xk93ZyhE/reS5nRWxxiGYLEPh7FilrYOp3TLIqz9kZwOlzPvA3OjYi9oQ0sDp
	 Fb3qFXSyVB0UQ==
From: Joel Fernandes <jfern@kernel.org>
To: linux-kernel@vger.kernel.org,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <jfern@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: rcu@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH for-v7.5 03/14] kasan: Avoid an unrelated RCU warning in the callback test
Date: Thu, 12 Nov 2026 19:57:30 -0500
Message-ID: <20261113005747.2977123-4-jfern@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113005747.2977123-1-jfern@kernel.org>
References: <20261113005747.2977123-1-jfern@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q8gw74b8cn88neuqfbqjrzpguba16hkh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C542AC0006
X-HE-Tag: 1794531477-489692
X-HE-Meta: U2FsdGVkX1/3OBSfOlzsnzBS8AxdMlDNmbqRjXQZ87H2PWo5l3BbBr09fajQ0wcQsLwsrMQ7YDN9LfrouDN4c3y6vUpcQpZj8N+9l2Cuaxq/DIcJBlJa05qLJBkB4tkuR8X9E8AF+6c+ltfrAkvwggnX1Qy5/O4kqFm+wWfZ5deyUTUuLvsfL0bvHOttl4S+i+J0MLJDcIpAMy5lP+ifykWNVYBdIoDh3uBwEERoje9ADnfEgdoEkPsBZtML760vgkApZ0uJPCRurBRyT/wM+eg1uIGzff4KnQSq1IyTkwtsT9ozpazGVjzelpDSdfSD5fMKGFoF5uOzdDEfosRJKLNgsEzxxamX3Dw6/RAH2EJxBfCqgySH7hPhB/WF0wGRXQTyYPVoPNgQjdXO4iNmZccNk56BORy1l/lw4rDEMFhk0lCoKowpM8+THpCB9XUUXa64ZxhojtPCLK9GfY/MaDaRNCzfybrSiRr3W8l9uP9HlQtradeKuNuaN9Wdxmnd1uV15S6xjQktLYmZHaBhs/s7xGJo1C9YGC0RSfBqZgGESPEgdN1/7MARbAHWEFNOYGTaqaGL8fpxRNsXU6e72MVM1JluZ8sv2eOZG14AtuXVhdWhZTH1S4a/SnZEsdQeJVh7mLBIbA9Q3J068hCLNleTFiyZ6jIEQa1byFZzqik0miBSmQjtJK2694sdHig70GcBDBKts5ALYbxvg9/Z2QsMhRLLIa7kvr9P8x3zTQ37iJxSsOYCJEwi4O4bt8gNtMrODmULWPvdXysEC9Q0nwEJcxuZ1Ev5P7IbZ/9p2yqxdfSib7vgFNQkgUlvCv98XpEfDJV7xNBJg2wY6iSCulyrW2yLQiktA4gDDE75LkA9Ye2tCgd0o4xZ6WIqLN4NLVkMv++n5nR3yyK882kjx3Jn3eP5pKAX3cZpTozbwbr3iyZV9715tFpSiYIx+Wj1PO1XCHba32piSgvcr/m
 1NHZQIri
 xgaWjMpfF/9GvIrvC8pIhhnxW779ym0z8idBSeDX+bn5fkWub4O5Oxz7v+r1z/l6bFfGx1nuHNcDB56gmFyFPHttGOd07MuB5i5zFSNu887ibcgaagDOQbUwTsQ27/Cnwyu83W2bd+oYzt4QO6DAKISwngpTDNVBNXKXiBKHOTgs6tvUYmxqMWhfnpOe2w5IRQEExWr1WB7iSiv3/7hv3mYWce9cFKrKdkB1lYyFisW3lhWHAz/16ztJ6JcjsnzFjC5AD+r1gyIrx1yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rcu_uaf() passes a false protection condition to
rcu_dereference_protected(), which produces a suspicious-RCU-usage
warning before the intended KASAN failure occurs.

The pointer refers to a fresh allocation that has not been published to
readers. State that protection condition explicitly, leaving the intended
tests intact.

Test:
Built with CONFIG_KASAN_KUNIT_TEST=m
Booted Qemu guest (8 CPUs), ran modprobe kasan_test filtered to kasan.*rcu_uaf*

Signed-off-by: Joel Fernandes <jfern@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
---
 mm/kasan/kasan_test_c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..4e23765d722c 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -967,8 +967,9 @@ static void rcu_uaf(struct kunit *test)
 	ptr = kmalloc_obj(struct kasan_rcu_info);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	/* The freshly allocated object has not been published to readers. */
 	global_rcu_ptr = rcu_dereference_protected(
-				(struct kasan_rcu_info __rcu *)ptr, NULL);
+				(struct kasan_rcu_info __rcu *)ptr, true);
 
 	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 			call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
-- 
2.54.0


