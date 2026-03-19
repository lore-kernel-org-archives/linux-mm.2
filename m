Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36B11091902
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8A06B0568; Thu, 19 Mar 2026 13:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B456B056A; Thu, 19 Mar 2026 13:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AA06B056B; Thu, 19 Mar 2026 13:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 559B86B0568
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DB6A13B770
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:02 +0000 (UTC)
X-FDA: 84563523324.21.054F7DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 29CA31C0015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bHHmODuL;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3fioxjDFRlSnWZiLdEAmcRT6TY1ObgyXmYFMHdPXDc=;
	b=P5PJLgQq8053xdjgGpLwzRWQpDly+NzfHO5Gy+dq3THuuMr8ueVHzAJwhx0LgFXg55u+jW
	g6Kt2QCZl5/1Fhoi+cI4fLWU4MRfUg6u4yy25fuG3vzikjeqK4eTKV32DHObLMghk5Kzww
	BRpZOdFO6J+O30fyFgAQ6HvqsaTqpvk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bHHmODuL;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941940; a=rsa-sha256;
	cv=none;
	b=H/PDUihI82qsgOmBcZrq0JI4nIEql4ngbVKUGEACvAtv971I+tUjP1sB3vn6MBMVq9K6J5
	8210b7JkGEEFb/ChQW/HCWem96vYUHGW0tYo7qHPGfTQwXRwCO5k2yxGmCCYJoY3kwsYzb
	+RvW+zi8xt32mr66npktjszhu8qNowA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v3fioxjDFRlSnWZiLdEAmcRT6TY1ObgyXmYFMHdPXDc=;
	b=bHHmODuLxUYCA+L42wkNaC3C69tkTnNvdUCNHwWnSsSx+3UvfZON0x40fxWR0ABf82ZWHv
	4B5Nu/Syn1SPZd3WHd8d47qqnGUj6QZdN0S0+SnWzluTNmim1twRJVqWr9J/xALdm+euwO
	Tys0NGM5oW5drSHqDEIcuRsSt+IDqcg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-cGyfdEitMnu807dx5kH8Ug-1; Thu,
 19 Mar 2026 13:38:58 -0400
X-MC-Unique: cGyfdEitMnu807dx5kH8Ug-1
X-Mimecast-MFC-AGG-ID: cGyfdEitMnu807dx5kH8Ug_1773941935
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0B611800365;
	Thu, 19 Mar 2026 17:38:55 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF49330001A1;
	Thu, 19 Mar 2026 17:38:52 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 2/7] memcg: Scale down MEMCG_CHARGE_BATCH with increase in PAGE_SIZE
Date: Thu, 19 Mar 2026 13:37:47 -0400
Message-ID: <20260319173752.1472864-3-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: I5uwbV9yVf2gLceXCZV1nR6nwBG1efYR_kq-pHV1IOc_1773941935
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29CA31C0015
X-Stat-Signature: 9z3mz7xby3jr4wwrjzqbxkn7qadb5pjm
X-Rspam-User: 
X-HE-Tag: 1773941940-965345
X-HE-Meta: U2FsdGVkX1/4UPB4H61tvPd96saNDhTM/A1BoT3m5t7efbWVORICUan1JiiJWxBEA5ffRiMtJsW/mDJiMRmMDZ3QMpOPp7Az3K79TmUvae6JwlW/KXhUsxeCaBbKj3wW/NIDvUTKixxVFN7A39E1vlqGOC2oTjV0PsLB6jwKQG3FgxHaJK47Xh4I8bTWJ7DS2MRkZoyuCnSRB5N784obXyVEwZFahBo0z3YXPXusK/hrEr1SJ+KsiR4KlkJi5UkCxHc7q+/36v9Iacoz84qFzR8yMZUAtBVSLEfunmWpjxvv8LhTqXn7lQjnm4nckJUehwlnZG9kWgCHXMsGpW4Xwzf72KuIl4YbdrJ4DJMh6+elGq79obOykDP04w495VQhEbn63Qpg0Hos3fMrqsc5uCD4XuDmZkdD689cSQjY6RU+cUtr3LWGBxc7F3lMpzQUtT9kMEY4OXCRLuXVG6zMHWPCqRkOkNOEjQg00ycuxkRYPz58HspsX+mbz7VWoHBb2r2O5s8Nigoh2Huz8gUKtsP939P9LVHH4y09Q2XrqeA4CUN8/U8FXH+SJC+wPl6SYkumLr4ZI0S+PdkiLs49zymop93qQOYinqe1erZ+uO4Cp0BetnhkE+nQX+3JDmmKSPO8zKAbLtGXqrPgBve+6MAuxDzX7v+RhaXh521DVCUvVn0l+UgLh7AF8hJ8necQYC3urEGOFb0aLc+BXYehNUnS3FkOX0/TDP1hRj77WfrEYYxuqStZREL02FSMSm9cxgHdCsklTgSz+OcQ+sjvEzvm3dXD0RCB8D/05mvXInvvg/5XDlDyUb4SRf1t1lP5IzSRt8DkLHXwS2wm28aIMx+toxF31ajRgZa2ij/6w1EOhvqxDn7qVFwL9Gdjq2Cg0KgvWai4pGrjFaJuY2gBui/j1kCNDK6dUDB/vQiUuXPmCMlE28rhRlIvuPNoUBMnhRILeQMkzbI7tnc5e/V
 P44SmEYL
 Ii3qjfOu8BB1MsxnGsAsJAZEvND651gAl6GfMNRwIBhxmn5D5PJkn3Oeyezy+nNTGIttXAd5x4clLXwkGs0f8PFei8m7XpH3J3FzsxtiQY94uh/oZRMZ6Vui2y8oKLG+kvArhGCMnJ4FxF6THpJSfXKnM7GmuugKGLlyeGvij4eOD1JHTHLWA6sI4/9TNAcM3VdQrOpqgKp9NrbLYIhpmRzird2OmQkKVjJztRSIwsjeHvlAkgzALlZLNYIRwarVwBNIe+CRfER8o6dhG4j9W1aRK5eiWgDP+MN57SRstJkw0Qu9UEUN7qdKtPGDlpH/c0UU8QiE3D/L6GQnAeyaKasuLnBgdJO5dy2EhqRMd2yxATQE1X5YQGAAvFxNh68s70ADfuB4Lo0A4mnqTdbtoFSldfZGSUw9I9kstKMVsQlzAjxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a system with 4k page size, each percpu memcg_stock can hide up
to 256 kbytes of memory with the current MEMCG_CHARGE_BATCH value of
64. For another system with 64k page size, that becomes 4 Mbytes.
This MEMCG_CHARGE_BATCH value also controls how often should the
memcg vmstat values need flushing. As a result, the values reported
in various memory cgroup control files are even less indicative of the
actual memory consumption of a particular memory cgroup when the page
size increases from 4k.

This problem can be illustrated by running the test_memcontrol
selftest. Running a 4k page size kernel on a 128-core arm64 system,
the test_memcg_current_peak test which allocates a 50M anonymous memory
passed. With a 64k page size kernel on the same system, however, the
same test failed because the "anon" attribute of memory.stat file might
report a size of 0 depending on the number of CPUs the system has.

To solve this inaccurate memory stats problem, we need to scale down
the amount of memory that can be hidden by reducing MEMCG_CHARGE_BATCH
when the page size increases. The same user application will likely
consume more memory on systems with larger page size and it is also
less efficient if we scale down MEMCG_CHARGE_BATCH by too much.  So I
believe a good compromise is to scale down MEMCG_CHARGE_BATCH by 2 for
16k page size and by 4 with 64k page size.

With that change, the test_memcg_current_peak test passed again with
the modified 64k page size kernel.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/memcontrol.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4..748cfd75d998 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -328,8 +328,14 @@ struct mem_cgroup {
  * size of first charge trial.
  * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
  * workload.
+ *
+ * There are 3 common base page sizes - 4k, 16k & 64k. In order to limit the
+ * amount of memory that can be hidden in each percpu memcg_stock for a given
+ * memcg, we scale down MEMCG_CHARGE_BATCH by 2 for 16k and 4 for 64k.
  */
-#define MEMCG_CHARGE_BATCH 64U
+#define MEMCG_CHARGE_BATCH_BASE  64U
+#define MEMCG_CHARGE_BATCH_SHIFT ((PAGE_SHIFT <= 16) ? (PAGE_SHIFT - 12)/2 : 2)
+#define MEMCG_CHARGE_BATCH	 (MEMCG_CHARGE_BATCH_BASE >> MEMCG_CHARGE_BATCH_SHIFT)
 
 extern struct mem_cgroup *root_mem_cgroup;
 
-- 
2.53.0


