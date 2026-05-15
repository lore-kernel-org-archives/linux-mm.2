Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B4CCD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5386B00AC; Thu, 14 May 2026 20:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FBC6B00AD; Thu, 14 May 2026 20:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8E86B00AE; Thu, 14 May 2026 20:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59BAD6B00AC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:45:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CB451402BC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:45:01 +0000 (UTC)
X-FDA: 84767809602.24.567FB97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A378B80003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nYXLtAJo;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIIYQXCTscUbmSmYOxuaTHGWR54Aft7g7qNjrgGO3IU=;
	b=URp1us8NlVohz2i6u4MUjG1+0Sc2Apw8deIJ6XFJHcHvZ8zVAs2Qx9asrdnGzK0K5AFPwc
	2NB+egWj7xwr6kpYZ/sR2m76fc+BlNU+f3VknyIcdmgJewKqsP2sqAOnxAgcLpXPCQzisI
	v07HuLv1bofgr8qio1ipkHbEDmSFDac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nYXLtAJo;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805899; a=rsa-sha256;
	cv=none;
	b=SUU7xBjmYlPSvUJsMI9NFrdBN+tvMAUYMKyO5wJFEgrPNNb75W/z6HKa9pGHiXFJ/bPnyr
	q9clGfGd0MIVd5IYkI8GFcp6ou0I8A9/vdXqmUkw1dKbjugm0tE99SbCemxDirD/+IWApi
	YiKUOZHYcxMogJsQkciXNIo1dK8spmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 216DA61335;
	Fri, 15 May 2026 00:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5002EC2BCC9;
	Fri, 15 May 2026 00:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805898;
	bh=bkzOsZ+u9cB/tv1smaMAlVTUS7NBHktW+3LSKT4hgrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYXLtAJofnvGMsX5N610DEVOEWQGgqst5scso7bMmO664008bpCCtvsRi4GQ2IpFP
	 vVQhKkRMOHn1S+2+lVx8JZI5D7L9I37LR+nI3ry4dRrArqdLDn4diRbM6F0HP20aiX
	 FFABYnrQYKcr/FZqZeVpah9Q+9DbzGjbc4Hy2zuK++yunvpRA5yoJbkYxsrsN2HGgm
	 GJ5URnPTmKdAXC9dIHP0/Fz2izknoIxQoCd2AI1E1lwA+B5hcTtZ7wnnM2R9Kf1kGF
	 mAsPrzuu3ylMNBwiNL9Spnj5751YSOgGJQqj+ZyAeCZHoAG7VMsWoO7243szeFb9pr
	 pGDYWXRkPS7Hw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [RFC PATCH v2.2 27/28] Docs/mm/damon/design: update for memcg damon filter
Date: Thu, 14 May 2026 17:44:28 -0700
Message-ID: <20260515004433.128933-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n34f6mg4638j1pwii63edfyynaipkt1t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A378B80003
X-Rspam-User: 
X-HE-Tag: 1778805899-460786
X-HE-Meta: U2FsdGVkX18/bkhz4ExZcDxqOR4oj8i+cFjOdgjwhoilYaadTgQ3ZhDLJOBawZ9sUW7ot+S+CidkBmbJWlYyspW4/uYw4+VmGyPFiyaxomXNnHVM+nkqPSokxsAJlH6ZcJ8vt5KFx55pdVdiYqok0ce5n2YV+SjKuVg3bV268vAzkp2WF4oR7cfWw7v3pG8j5hQripHSyaGad2XvbIi6bxob9RhkkLBI1hb053BhCwOBr365Zb6N+XVKmhfcMuhIY+G7mOf+B7I0YUzZWUdexmNB+05BDg11AuT1WIvNj1lOD5JHhoy2oZENZq1tBwtzXXvXMeHSt9Ilicgx+oL1W99RKhOVIthR6BwT2dXbydhEljV50wZxn/QfWmJeZGY9V9iej5380JeSbijKunH8azTy192G6q4BQrCAqW5v/w7U2R3VAvU3YilugrROcsrTJOT25mW6CTY19aixnQiS0QrlCiBPPlVjpLdFgRI8YmzurTE4hdw1wHJkxedTkYDduyZAcrCJvkRlGWgOch3QBSVjCSNr27Xm0C9acwFNsaeJxRjLsQtIMzDHGEqYsUn1YaRrHoBa5rASICl0+LvlfxcRNDQIy6PW4Z7XCRAIAVXZSEs7kd3Z2ww56o+xEuLPxS1dqsKhT3/9j02EnR0y29I5GZ/CGcsAJO7OsA5Q/P94stc8nWNFA66KQ5IpLGSgRg8nOwOYal1duQIQ+CfsekIT2BHrlc7yoALam7sdf0DMBvW+ur3iY2c4YKJV0ZQfeh402sSxRKuPfn0u3sXg1lePJuopn4fIe7DmKQIhw07cdTTe4ESJ5gbPdU43ec+pfJjnuPWfue0i147ns3jfQ+A/7jFBb3MK4gGGbhObFh/QHBdxWjo1f5F3/gyPMJS5ESS6DaGDLca3oEXMxX1sGcLosdBupBpfXnmdDuCs79faSGW8suzRSmAwops+UJ9LfokAEj85DgHOpqoGt2b
 41sc5Z44
 vkG48R/rx+L2UeXpYUucdf6IwsuSnAn62R6psDvItUnm4zPd19eqa8sK6W/QAhKiLq2tHFSkf3rBav2pcK5EKSVifUW1y+ZN2tzbfg+geGsLAZQicb7+m8uckpvlIJf+vQ/sdSxV6BC0qI0pTfuMe+N5AIqCMUFlGIXC326FMV/LdIKmZ4W0jtvy88baOPuzVpxnRkSnhGDNNqipZIQuxcm11QBByzBQ4kjfymH4PiH2RcM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 85d668e929194..8a2d68cbcefca 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -286,8 +286,8 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` filter type is supported for data
-attributes monitoring.
+filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
+for data attributes monitoring.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

