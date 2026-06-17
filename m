Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD80CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5CFC6B0005; Wed, 17 Jun 2026 09:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DF06B0088; Wed, 17 Jun 2026 09:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD2F6B008C; Wed, 17 Jun 2026 09:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDE96B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:56:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9A3514043A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:22 +0000 (UTC)
X-FDA: 84889554204.28.886B1D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6DEF31C000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JSjo2ERn;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781704581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+k7GiQAr5qIJGPs8oEGZMT3wvgrsyPuY/ZtZCXE0gOQ=;
	b=TjYby+WbrPGqF5LlyI8Iji1oxuje39E1iDdIsL+WrGXmphugfKCwip7O7MNPXLNXVbF7Yf
	yIY+9Y7PydwJjLQwka2ntJ2pWyxID/KGC5+HECADgt9ojCTWrYGoubA/lvabo9yfmI3gcO
	G+7NXHSY2JSnfi1kUCXvnlXT/IKA+ak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JSjo2ERn;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781704581;
	b=WjdUK5ll40GXQak7j/FBO75hqvEKnbzqSHay1EgusHwJXST/JcDZic5n4RigpQA+oD+i70
	7nZT74gXr8wPVxxZKI6KDdy0ljHYLgktW9D/POxiBTZuk3T8ImRlozRQSt9YfjeSGDo7vv
	XIAwcZnR1xzIE+Pnmi566ORmJqgHHD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE17960121;
	Wed, 17 Jun 2026 13:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C411F000E9;
	Wed, 17 Jun 2026 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781704580;
	bh=+k7GiQAr5qIJGPs8oEGZMT3wvgrsyPuY/ZtZCXE0gOQ=;
	h=From:To:Cc:Subject:Date;
	b=JSjo2ERnKqWiDkNoaxp6FQ6YwVXthztVeQbIPBL55PdCXbJe94JT7T4zYvG2AHJza
	 YJhElL/k2RQJzN4HvMawBsEk7tT67FQ/luwlnsToBNV+WAJQ+6Y1byV9ikNb61tnVY
	 pZc103+uS4TWTIQOr752xzX0Ofv9/nfvqX9HC3E4+lwcoaC21Y7Jg3j1U+P5p8vCfP
	 gG0177c2H9m2cZ2YxewSspS/Fvf7H+tUipQgSZbznRZ1pGi9aGrQj8Eu+BBsXgiWDc
	 jO1mo4Dtf7AOp11nfcp5iVL1J5UTB+kXqBgm5B4NvF2ICONcneILEkUIJXcx/5+hLZ
	 yYbXxOQ3gnOpg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/2] mm/damon/sysfs-schemes: fix wrong directories put orders in error paths
Date: Wed, 17 Jun 2026 06:55:47 -0700
Message-ID: <20260617135551.86013-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DEF31C000A
X-Stat-Signature: afhhoq6sqhe61hfpm8r37616ggrmbswu
X-Rspam-User: 
X-HE-Tag: 1781704581-278207
X-HE-Meta: U2FsdGVkX19ch6srpR5eoRSli09f+3NDOQKD8DEsuUyim6qIuSNBrirYv0UiKxFgMzejPO93OEiu6DNyF3Rpu7TogtzhkEdk71S1WWOEv2BTLhKjy2PS8ekzEXd761ybX+yZJt/bEJ/Hpk+3zgwn/snG8TJz8UnoDOlRF6Yz8qOJ5L1tQPZrnyyqhCro1Ks89wjbiJ/sq/5aGGcAdkKV43zxCmrAUV2/19Hv4aSyquAI/AP3iHPwAOH6niXpmWUW3uTdYzyTkg0S88jdNYnl6MK2Fku9W5QOgzuloYSpMSdrZ3n4N+7nnO3zyTKAIoMfsyiPav6UlNY2Aki6W1ut2CqdZ8gElDte9J2N127rVn3GqibtNrTuu6DkFo5hB39lxypOknM4bDso0ihJ5HQFGvmXBbeIAbaqJeoB34FOZJmuHJitYX3I9DGs0k5uLo5Vq4O1tlii83Mt2AxdqJgsy6srV6F7QVIr15QKR0WAE1CYay5oSlde6fBK0gQgB+vPwnU+OnCc2xREE6Ct/CV/OySmyxW7bovJzGiAbOi7G7iXwvkuN8vekx7t4NzOzGNGpiDO5U/FugihMg8yOHJ+7cWTlT6E7qK4wt+CpQzf4p9a+33AZfMMhaUPfnmwkLhDb05LvgcpaDfDr7XAOndajaY6IM4aoTgSgSFyR7JET0BX7sB+uRf/mlgd3vVAZStsXS5AkmfLJpDNVLqsnQ51jQuiWD6XQCqP/LRf+STjWMApYtmXsx6qvKEdP7LCYxqh0h4oL0BOH+YXTV+HDM2DtTI3gf2xRMhpkvsukfqmwCFERNdOeMAZCe/BNvIehRyJ7vE8OcyOy2vXWdi/AQo+/1+3XR77oj0jDMPHGyEO34PWfULdf7ecwO6rzAQ+LTH9T747imSMChAkstl9hNmI4x9qhTzfGBe/ydL0ZeQ17fVMQDQ9NATaCWy95GSs5IhWDRpv3Tj7dviyWUkEqlt
 JFUhjaoU
 k9LDHqwGtybcPUPHExX3oOgFm36orp11rH9mu8iXPmgG41mje2aY0Aob8sFBJPthA/eXJfDsth56Lu6Vccif/7kPzUMpSMhe7nFELnxUo5ndCo5e/EtB+KrfHnqAHJ5UUDolps5dYkZZVsEpKvDaNikrmH8L1jWZbbeFJ5+qPJeoUfwcYncAvRzsh/8ppXPGnDRo5Id6rCXI38dXqNy+eNcPTyiR2BsouXIcTLzJ8TIILNQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Error paths of damon_sysfs_access_pattern_add_dirs() and
damon_sysfs_scheme_add_dirs() functions put references to directories in
wrong orders.  As a result, uninitialized memory dereference and/or
memory leak can happen.  Fix those.

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260617053308.83200-1-sj@kernel.org
- Add damon_sysfs_access_pattern_add_dirs() fix.

SeongJae Park (2):
  mm/damon/sysfs-schemes: fix dir put orders in
    access_pattern_add_dirs()
  mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error

 mm/damon/sysfs-schemes.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)


base-commit: 7590ff339c62226d7e1eeff03918b8d27eff0872
-- 
2.47.3

