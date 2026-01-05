Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80486C79FA4
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0586B0177; Mon,  5 Jan 2026 11:05:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D7B6B0178; Mon,  5 Jan 2026 11:05:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9FB6B0179; Mon,  5 Jan 2026 11:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 930CF6B0177
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:05:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FB5589FDF
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:05:17 +0000 (UTC)
X-FDA: 84298384674.19.AA4191F
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id A070DC0012
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:05:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="Oa/djvKF";
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf22.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629115; a=rsa-sha256;
	cv=none;
	b=UT3tXQOu6DmjwTTfkirtL+6SCJDf70h4AEKhU1XeXcysc/FebaVUCkXX45cpYdHbi8W3E+
	hS6iW1EGgazMu9z74xtrmyw8WNWSPXscNpz5Znt4WAvLIfDj1Y0pE5q8dDQ4dPcGxZzBtp
	FiBJQka7TemZw76igktibphIIAFF98w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="Oa/djvKF";
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf22.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3EQP30nopHZPddhWzpH8v9mca3JEQ17NQqU4AosWpE=;
	b=E989u9QN0TRQa+mneKnnG86c+3ARJKxjvOvTjFgjBgibCggLmuPExwstu21cu/UmgpkZuL
	TlXoqLB2FribUHEPfqYD3cZ0SasyQ+WBoSLRSp7uCYbYG/4BK/HsKgpmO5VErbfgiT8xIy
	vE0egpUokKNlr/FsqHgygE3k6YeTM6Q=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [108.142.230.59])
	by linux.microsoft.com (Postfix) with ESMTPSA id A9CC0212539D;
	Mon,  5 Jan 2026 08:05:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A9CC0212539D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1767629114;
	bh=D3EQP30nopHZPddhWzpH8v9mca3JEQ17NQqU4AosWpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oa/djvKF8HsXMv/cBXOOeWFV7o+9EJjkm59K0Kce4TH2gEKvOaGXbTkXvHAIh37Ef
	 a8xFqIoJIWUsPdlFnrChHCodP4f5V+8iru1uCMHwp+n0AqVEF9xsPfA0MWRnToSlF8
	 E5pUymqzBIt6aLt0bUQJimQN0CvmCcKlgscAo7Xs=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v3 0/2] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Mon,  5 Jan 2026 08:04:21 -0800
Message-Id: <20260105160423.23708-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251216140252.11864-1-tballasi@linux.microsoft.com>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A070DC0012
X-Stat-Signature: h44upiftzxhoq6mqiuujhub6sic9obp6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767629115-652893
X-HE-Meta: U2FsdGVkX1+EmZ9n7L76mtqAClKa81AE8ii/fKug7ieEkwA/3iNJNhu1lwEFGgy10kqOMLGC93QhgYnDTpyihHVHHxdrwKYtnF/HH08NTVnlANmGSdZaPuOCPQYsirwXp8+1qJkI3GsBNdlQWfEVqfXzhfCjyXJnhdKpfHuuGC+cNsMuaGtc8i2rUzpB5IE/oMGukR2TN1Lz/NFzd0YRCrFJ4a9E88Z8jMiv3Ilq7A1XUDEJGahXO3rz3mzRrUOPJldM5UgSpvOw6urvFnudI8+tTV9ylv+sZmghIWne0+HXzRP9FnqYWrchyfKI0HtUb1fwg0j/4L61XtTgeaQfh9O/6uaaLWtffmo/3c0D1v8PBW+G6/Z6vJUQ/dEn5PHZXYS65gCeBWZMSJ2VQI8f30smlZibgMMiPD7CmEdnSJwL4lH6YB37iPgXbMl5jr8bRBHVEhcXj8i/0DwIXkLBU3vOzXTfmrIbYd7QyrOK1ekMLWpjUH2Ic02rcKOZiJqTuQY7hb44FbPtDjwKPzTyUTD7OFgWOxjI99nBdQR2nBrK71JJe8NItCyQZAxVuoQs0BwPwini3XwSZH4YzwMU23IL3rkCONbKfQlCey2p1TrNSwR1L1CXtG0tNBrln5pA5Jn97bQvi44kKxct2E+Y8u8QYCrDKETI4H9Rpd0UY2sB6BhVgkKz9n43Mj080GPsTY0ek27Jg6C6cfeUYP02UYuRrNaYOK9cSFGev5741dYKzheAFcO1qbKiVX41Cs/e6iz8a+0QwBIAHOzYdiMpUUsDLFUYl/o9ZPM4W397ZGMuUOBbUW0foxN0loSCsfQFjwNKm40XinVkX94KxVvncs9pPqLJFlxwsRu/+iTcI8Lx0Qt9CCNl9t9BOtpnBJzXqkCtzqm3QdOROzLfmqXa5y8UOXcRimKpVZDvFFvP/iZf2O83JHsBsCCFdKpoaxMOzcZQqmsYdzGZOu9xyxA
 CRk+b3mY
 B5mqiFPGAYTzUsMUBNea1gTwYIgfWg6tv97YlMftmPFzHvwo+/ruNywlCG91wnOKZ1fHVtiGFS3IYUisdgAmP1l+TyRNLlBmeiCQKkeCCG7WDsN199d8lJfV/oybiVxmBS4Wu94L6qoaHAgEGZUa3vH0+gNctkKIWw87jBSBas3PvfsD987le0hlJ7Ck+3xT2zJCCenkRafGiAcTa+r1hKTC/POctZ5FO+54RwGdOpuDCaZ44hA7njRQTOYOxt1zAqGTtCycBYVKKzMV1LU79HDNvfoFKETpszNKJPBHsRjuxAde298z2HZR6hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v3:
- Swapped multiple field entries to prevent a hole in the ring buffer
- Replaced in_task() with __event_in_irq
- Replaced mem_cgroup_id(memcg) with cgroup_id(memcg->css.cgroup)
- Rebased the tree to latest 6.18

Link to v2:
https://lore.kernel.org/linux-trace-kernel/20251216140252.11864-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h | 100 ++++++++++++++++++++++------------
 mm/shrinker.c                 |   2 +-
 mm/vmscan.c                   |  17 +++---
 3 files changed, 74 insertions(+), 45 deletions(-)

-- 
2.33.8


