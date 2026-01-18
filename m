Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA30DC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C886B00A4; Sun, 18 Jan 2026 13:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57B26B00A6; Sun, 18 Jan 2026 13:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7BF6B00A7; Sun, 18 Jan 2026 13:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 707246B00A4
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AD87D2045
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:17 +0000 (UTC)
X-FDA: 84345856434.28.DCCF36A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 756B2A000E
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aV9+A/Tj";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJhQxvsWrc6hjO30sOukHU6kKUkv/N1Um5LMo42llcw=;
	b=mhh/9XmkfR5Si8jTdYrTLjmFa5bnK8BwUTbowsp9w1qR+mhhXf/xrvvckfE69DGcateO2/
	MmJfMLi7SYsONYcPk2N/PaBMysY2TaILSdIiRcNJR0GKrc37PB/HchDaaxB9U86OrfOWUd
	wBi54SNGwjSAeVnSds2OPSHiGd1HJzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759395; a=rsa-sha256;
	cv=none;
	b=uiVRjA5oKbdO7GXMRad9/H/0do9a7eGmxCTZvZ82MltG63B9scyRIDm0Yw/eVJNZtrMRcb
	WkxzR91YJfQU6WF0hi/jnwuJbuwoMpMviY9h1PMiyQFnA5rW12zaXuTJVh8RFXjSQYkTIC
	hCFFy3NYDV7TbPZN8lSuAHB3xHlI8YY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aV9+A/Tj";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A71C2443E9;
	Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487CDC2BC86;
	Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759394;
	bh=z3Zk/jJdUa1YP5N4FiUh/fhzLI3wr0WgwfqrSYYQ9/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aV9+A/Tj2q1TX85Kvgou1yTr2rX8pG4GZCqHcC43bHHnXvnhCMN55xe0yC4RLpH3R
	 AuGH1mSPhLXa2LnTX+HmuCvrLcwrXTC1ZiR8N8lnssMwtiFhf/xFQ/rxD/EA/z4mFJ
	 OGaWsvs7+uE44Ed8UiKsJqEWis3/CMFf5HIQZrC+zRxMN28/y7qX872Px51Ag9TAKD
	 3YhggbDuE9tnjGgECcOApWRtgF4Onitp4AAoEgIFunMk/rfh+nJ7CwuMeH3PMY+jlw
	 02HqkCAEglLbmCzFuElojYT57sxYAVVROePpAyxUDXWJNANEhX1QWAD3OREp2mv2OH
	 SCRuguUrfsNTg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] Docs/mm/damon/maintainer-profile: remove damon-tests/perf suggestion
Date: Sun, 18 Jan 2026 10:02:59 -0800
Message-ID: <20260118180305.70023-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 756B2A000E
X-Rspam-User: 
X-Stat-Signature: 5oo1jcd3awa3iuqnsimqkm5ab4qz9wrq
X-HE-Tag: 1768759395-13230
X-HE-Meta: U2FsdGVkX1/0wsz+VVUbK5K/mDg/YINJr5uR5LRzV7XFUJDO1eZUMZhi0B9hSXLrsEuUZCW69ghnTB6zDx3DkAU0lNggjri15L2WKFsiu+uDRQmNRTLYleRN364h9c9VBATFBbwO6/MpjEoePJR4b6OcLd/odotAfE/9PhG5ymCaV9JXIz/dWdOhMyId1/qHQ6XsXKXhtPcd2WFMDyb2kZCmu1L4qAu7puQdljvnKHJJC8eUvMvHm4KX85YVej+qjGyUHTnpEpaoQZ6fQCoPlRvqEkJayrWXYyBqlzZcgfWl8WJbHOq3YgODTqokWrEBn7SgWo5MUGBlOzJDJXlk11fxuKFIyghVExwaZQZ7SyhGFp+fPiZYSBHnM9JV3znk76F5aadVaqV9cdvy6LEW/1UCtn1rIKDqIFpPMt5VVqus3yiL3FWfkFN38ORmsgPn/ETEtoQFo6aBSWZU8dGhl37HuNpWmR43VX9dl6PWXMrgDMQ32rDRbxhIXBbmGHVQI7ixTc47hlk6vN9jYTUJriyb2incJPO8rEpHjwwFVOLB3/tpE66Y0jAy17YsVKoAOjKGzmBu6ri+M/eig1jE33D59+IJh3aEnmTxcIsOu72n/IwuAfD4l0EmXsnwkeB8vwUiwffL+R5o7y5Ae9OGZkFFArKhZUXqTuYF4oBnilUnJWFSHXDH9RACTgQVmbxx5lgNsvIg6UeDJJNREPHtUx+WWDJDv/CRbHtEFneb1JFqR+TQ04HqAP75BLSQzE0X0VCNntL/qZLH1a9382ERADL+Fy3FURRoLl12AFDRn0IFsU4RgfH3fB2ORwLsAJlslNMPKM5c6GLSpwPbTMLnA63b9vaB+NqdNVi/gW9v2I4H90TJAmocZ9gZVwCIVeKnccA8sJY/fltVUGsVVWp9niBt5EldMpj5MgOpOHaThW1WNdM2JnNUMwGRH2Q9kUcR10AGfFAXaRvjBwczjIk
 S8R8Zs/F
 zVT60vT1X1uVy+oqp+tdVRaqK268GVk0Z5E2VJFljbRoUrY3PdDv1NR8f17HeAaCEbQUK41N62WBkb+/kJy/Gt54nP9r2+V5hV1xClFdOtsiA/KBm4zMRgp0q3ApekNW69oZFc0MDSxZUjBNplHVvtscgKY/fG5DdIOdlXNa5Y812UIdgssevF6cYAGIhjXW1QE3kw7FKLk4lx3XC+DUlgyesLp7FeFnGKpAyOxlpFYSy1KWTFeHqglClZNxLK41Uy7//
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON performance tests [1] use PARSEC 3.0 as its major test
workloads.  But the official web site for PARSEC 3.0 has gone, so there
is no easy way to get the benchmark.  Mainly due to the fact, DAMON
performance tests are difficult to run, and effectively broken.  Do not
request running it for now.  Instead, suggest running any benchmarks or
real world workloads that make sense for performance changes.

[1] https://github.com/damonitor/damon-tests/tree/master/perf

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index 4fa06b21ec30..41b1d73b9bd7 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -48,8 +48,7 @@ Further doing below and putting the results will be helpful.
 - Run `damon-tests/corr
   <https://github.com/damonitor/damon-tests/tree/master/corr>`_ for normal
   changes.
-- Run `damon-tests/perf
-  <https://github.com/damonitor/damon-tests/tree/master/perf>`_ for performance
+- Measure impacts on benchmarks or real world workloads for performance
   changes.
 
 Key cycle dates
-- 
2.47.3

