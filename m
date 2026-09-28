Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06C2C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974A26B0088; Mon, 28 Sep 2026 04:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924FF6B008A; Mon, 28 Sep 2026 04:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83AAE6B008C; Mon, 28 Sep 2026 04:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63EEC6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:40:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4AAF120135
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:08 +0000 (UTC)
X-FDA: 85262523696.13.9525262
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BCC9180002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9jAARX9;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790584807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=luI3cyiFOxUaGqTjp6wOLnxw6rfD0knECSRuoDaIkvE=;
	b=laVQMe5nPdeBRUqbqpl7ZQ1d/6eHQW0iQT2wJTkDnfYjchuPlNt0xOvCEZylBmsd5r8Wud
	uk9mEtoHFKgC1A8ZUNslegnFAwggWBO8KgVWQ8VlEFJqqqTuYJK679lJbNx5MYbkl0ntyg
	AuuwJ4giifUj/WYS3gHtIGqkOfU0Fp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790584807;
	b=S5kjDV4htjQccX+Nx6X4qWZdeiSqGMRaeuR+f7T/k7/RFMxBr+mGFEGhDt9nKO8CvZpFH+
	GViLBaWpgVQ26uGEf3PKZHmAErbMkeV0RSCsxWTIFvEyXd8Gkcpm6+4N5NOoWgEGVGtJKn
	l1mp37AmUKWohyw5Z0+wJp+8LdS2YKY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9jAARX9;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33D1543C8E;
	Mon, 28 Sep 2026 08:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4663E1F000FF;
	Mon, 28 Sep 2026 08:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790584806;
	bh=luI3cyiFOxUaGqTjp6wOLnxw6rfD0knECSRuoDaIkvE=;
	h=From:To:Cc:Subject:Date;
	b=b9jAARX9b4abbQnaQJg5hLkdK3FfaAc7TIbNbQDri1SX+IyOHh/xS5XU7rLUL0ZxY
	 Xk4EJKOQLMGmkqxZoOxUc0SJRw5YSAgfAQQ9dTuypJgX9Z534jyCgD6MbHVXzXgPgD
	 EfUcxueugy+VOpFxumshq0yaR+ltZ8W6FPEdeC3+FP2oPUIkY22Cbn2ck/MyGXLGyr
	 AR1fUn0guVbfAQxS9dslnrqXFCYHnRTVxQxk9/Vi1uOuOcW7G7m8vniDWjgqYcx+cO
	 Oc3WQOAm1d+8GjsrPBmfvchSY3YMOD0Nsg3fZ/4qtBQKSvqvGq8H40T973DbLixDzc
	 7Vk4VYNodUhPg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Bill Wendling <morbo@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Justin Stitt <justinstitt@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH 0/3] mm/damon/core: cleanup code, reduce stack usage, and add kunit
Date: Mon, 28 Sep 2026 01:39:54 -0700
Message-ID: <20260928083959.4030-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BCC9180002
X-Stat-Signature: knc1zrqpj3ikexkqcpapp3kumhz31r4q
X-Rspam-User: 
X-HE-Tag: 1790584807-389302
X-HE-Meta: U2FsdGVkX19imu7rSDynrl0FeyxFUJSP/aoK+QiKCrBRaBhHpAWKNxJzubEdQ5p0CqoA/LHmvoVuPzPo8yb21Im49cKh7s8UQa3FrhZ5oMtBTANMQTUaPKJlgyt9wa4lSlfuC+yU+1JCz0XEQxa8ordFdoNzheFBcPNrTqfPf0h2GXuazGVRCMvkLoez9cvjlw2AO3Op7zat5THGlnL3pbdLHso9LwJW0q+udjejxHG234IQN8s98n3i+YUFkKidst8ao79l9d70VbXtMQwKNpJOUdMXI9hHjfuyMTRUeQX2PukyjCGstH5O4IdjJ41WtsWmf2KqufQl/qEoo0DIA6lBrv18XY1goNRKqayKI4X5uajlHMe9t2lV16f6JRtLO+pJpdlfa2KpckLAEuHPtgpddFhr4fU/z3da7kiirTkNrqu3p/cOhnYphu4EdSbrnvJvNERDuiLWKLIB5RLcDrqQcZsfhAZzLa52KcXZhoRIIMqyEs+QksrCmxbte6uLsxRBGcZLgwCJ68U2WbOBOvGNp/0FdE1atiuo26DFAQSMg/Eg+ef1DTEtRVfEdVGw4BvW9bcm3sGSEIu7+fF/M9FOV0rK4M7F9eysl10ZvNcideMHCtB/HWzKcZoUD9hHRhiIQarCHNTyz6ra0zGhtEJkvsb+vX7F+UyurZXJDydwfqvTC/9YEt9c4wJsyLIv8cH/EWlZB2240QdQNLK6DRH7aVqS0+k8vPEhvSkQUYmkh+LnRBlwWq89YrInLQAedCeiCV1dxd20T1qHJzYA680VogJOJxhtYHCMY4+XyVieM2p0T39U7JXx8EIBR0VH2H1jLQqpJxLJdSZ7hMv/St27Eba2LDj/SLcNM1Tep/29bkm05QUxLvZqioabIVSyxvN96mFXoI8T6n/GUpXvkF0dUw09bXYDVUtEuqYBF2ch1X+xR0yx7iw72dG9+sgK5b9qW7uFPUB5rAMApIP
 zYbnBDzE
 uvkzrJWVXBAGBX0vbPxkWzgUs4adbjxWETsDl18Z/yGaqE6BFHRAiXIPQqm4Ua4sdQA/QS04lHrgLfAxHVWwgxyXB4liQzVR4QxRCzOV/k5WxoNbwMIQuwGwbzu8p9gxdCWabwISfY34eh3NTx5JkEW/PrgDKpuX02ID9B3NQ6J+IAeUhKsH2rEc4axcQU65+MuEjEWkNWXSeaxmsfa1jeGzAJzw2fBbAJCnmbC0t21iOdSzx7j9DOmdcNiwE7ANF5G9Wyh1mVY7+V1qT4zIbgRSj4dt2L8kZNvGh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three various improvements.  Patch 1 from Zenghui Yu (Huawei) cleans up
unused enums.  Patch 2 from Arnd Bergmann reduces kdamond's stack usage.
Patch 3 from Karl Mehltretter adds a kunit test for uninitialized PSI
quota goal stage logic.

Arnd Bergmann (1):
  mm/damon/core: reduce stack usage further

Karl Mehltretter (1):
  mm/damon/tests/core-kunit: test PSI goal values with explicit samples

Zenghui Yu (Huawei) (1):
  mm/damon/api: remove unused NR_DAMOS_* enumerators

 include/linux/damon.h       |  8 -------
 mm/damon/core.c             |  9 ++++----
 mm/damon/tests/core-kunit.h | 43 +++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 12 deletions(-)


base-commit: 9a7b617f9c0b3cc653987c9e6d0434cf1079130f
-- 
2.47.3

