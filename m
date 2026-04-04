Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D78E63FE3
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A9D6B008C; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24DD6B0092; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12F46B0093; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 982E36B008C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C33814088C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:58 +0000 (UTC)
X-FDA: 84621435276.29.432A2A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 62F568000B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJEOZTs7;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJEOZTs7;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320796; a=rsa-sha256;
	cv=none;
	b=uWfsEp2MLUvU6oACKCCzrhTIULYLyi/8HjXRIiNeyEw9mDtnoW2iRC5KjdEtKkFAK2g78V
	XbpW1oTTERilhF9whW/MP3QTNzpS7MqxSqIKsm1VFDLbcDVcPOpFi0zOLqHBJ8k6PfsMn2
	5jexGTTTDrsidMCqvSXnO2Csunr4zec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGkKE+lBVTImm1FPEyfbGJlSAIicDAbr7MEtEZCR9BI=;
	b=K+uxd2PWAFFe4R+mpTJBQIlrS2f53DjD81FKb98eIctnTboKuUSAfGAzj8YEsbVmxo0sw1
	2Zm6nWbF9MSyFBC3g4WM5aDljveyFlcBxRMX55TepRm6ayDRipTRHJjo1uS9u+L8tYQ+QQ
	j5geFLzph9C1FjZdZYbLcnj9yifNIdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B300444F4;
	Sat,  4 Apr 2026 16:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8119C19421;
	Sat,  4 Apr 2026 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320795;
	bh=Egl2SkMuNrTljH9TxpqPoDsyTYmIOrP1f5niqsDd1BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJEOZTs7RjB5ahLxwXas0E8qadLdvlKQ7QlVoMYlCx8qhy92q1xktWsySWuqWeSOd
	 ejP9tn/GYV9qE0EcWl7i4yFiISDpOmbMZ4P82pseGLq57a8RRridCGmtx4fUCJ6kap
	 iFrZNuZsTt8ivzlFaZxYnMFWt/u6cxROy6ZMZFRRLY3jK4QT/12dL1P5Qi3biD3rop
	 whFVAdwazDBwU5Khz6SbMd5RtZk5F08QZCu0aMq11VUHUsEoNhVMFecXYnJpGNL/e5
	 xNS/84pMMOYHvBMYfivjeT/4my2fPRepWyXTpHBwW5BeyWCFHalIWK5/hNGwsOCytt
	 12979jQnUqfrA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/9] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Sat,  4 Apr 2026 09:39:33 -0700
Message-ID: <20260404163943.89278-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 62F568000B
X-Stat-Signature: t9rsbbhyuz3hemoha91i8fi733r84ewm
X-Rspam-User: 
X-HE-Tag: 1775320796-705489
X-HE-Meta: U2FsdGVkX19KIEVJjlnveYJxaD6eYJfjAyQ7MCIOD6pIs6r39j5wvctx4etz5jHN13bdwCQlVWw4CpEuacNOM3CyTl2K4RUyVcNzqbLmPXj9Ve0B/5OMWqh4r27v2nzTFcuHU3o1EVrYhg44Qm7dMfLctAImKGKprYD/V2yRUsHLmWjDkBq73FVFUCqbgD9HA3+bNbDUxNNwNJUK0FAfhjESD2Y/4+mwjYXhnVymBbvPNBCxSbGRbawORhW9gDGmT4e8gxvJWxaspvOjD6gCj7/Uj6ykvcA4aTLuFi+F3nqYrtFD4DnXzbL3ssAnrBG6iE2q/VEdJu8hbsUfxy08UpC3064wvychPll5TGvFOe0dzHQQXswH8Zq1F6rxOwdY5NQvhD/xvy1AzAGW/fz+zOW5y7B+ar8Rl/MlagQTHgNTWl5NDDaF+crt1tp2xFBEhQ+jGd0hGQ/kK+W7W5VKKuhDjNOoXmW5CoVsp3tSQVg2PDdqHrV5rwwJTSqm16up5e8zFaJMkUwFSAVHRKi92K4SFuLKd+gCvspROrgSyX5ZpMeG5x4kn4xqY1Tb/gYnHcGTmev7llPRQCLrLW0dKePQZ8xHiucFdYPNNoFFYDFvRnqzHFD79CLB5NbyC1Le/cz2rcjgJnsRhg95iS2SdqA9+LWHoQppK7XCh6/Nxnb7droNiclB3r5XCQWvKkol+NXoifx9Skzsbmr9Pgg7lquIjMOs22CkB0ObXEmpzRbMznk8TXWeh74iI4pXSq6dlYgn/M1HKH7eaMjmPz7ZepwQ2d2PC+5fAc1CQcP4UUhDHI48Ez/Bol0Ftfm/TQwh6GdL8CGhOkHYVxEY/uJhw75jmMKyA8n63ZuU/u6djXg6oVOBHUFJCnruns8dllxx6wbuOxvmLZCnbTItsYYqVvfg/6UEe5zSXkZrK8pM/sU/QmfpiEZQ4/+GDrmT5uEyAgRpOJslS2guQogvGfJ
 8hN9kVkY
 XMOx6UxMCZlO0FaaMFYcVfwFtJjC43iJo2pm9/eZ/glCisPDyxSmO6q3VgO3rV69kNSkpu/TTz/WJr2iyt34pW7IhfGA67H+nOkaP1K1d4fwgR/BwHkom0Nx8VXTy8FA0S6n6fX9ZqPWwUWT4CFg+8jIoVssX9zerGlmKcu8C0YHcczXr4LAgPxzCBZbx99ts+ht2DWb9MoPZhAvNJzj8lHYgpOMd4SPdctMmZEXHpkY9gfsm5KupgATaZR7Air4HrnmC792mNX5NmmZ4ZbmWEVyarg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 510ec6375178d..58a72bd26dc11 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -572,6 +572,27 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for sub subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.
+
+For example, let's suppose a DAMOS action is applied to a region of 1 GiB size.
+The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

