Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E1F1C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96176B009B; Sun, 18 Jan 2026 13:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19746B009D; Sun, 18 Jan 2026 13:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26196B009E; Sun, 18 Jan 2026 13:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADE4B6B009B
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 792288C097
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
X-FDA: 84345856308.16.DB2042F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EDC1F120002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1ph9fId;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Irb7mLScYNtRYsLKxxPwdYtDocne9yH27NG8Yi3aXjE=;
	b=l884Hc1l4GJ1VWQnh+50gnca7kee49hQ+ur/2NO4KhGCHi6JgH7nx1EcAQ2nDn531PBZJh
	B3yE04RWkpn2OFFNwEmw1cI88hYF414NgQWkDfzIzvp8f8Qi0s0y4n9V1ZMbP/YNZKPrB0
	XeOTbuXd1rjVQ9BwE79JZJxXFoCGscQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1ph9fId;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759393; a=rsa-sha256;
	cv=none;
	b=pG2QxTiJbVBNvSrKhBC8PrYq+XWrk+S/zRAzwaxX22f2v8T1OkDtOPYL02xVDFl4NegxmS
	Ha5DRv8k2XRetfVqTE1gpjWlG2yYUcblu/T61s9CKw6lxDBBi8uOSDwpY0nKj4BCGtuKQO
	SgrOfd4vRCC6jkbp9oSqDeVLssDl9GM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBD31403BA;
	Sun, 18 Jan 2026 18:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C6C116D0;
	Sun, 18 Jan 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759391;
	bh=QNYks7ttqO9vmoAFlbyr+Kp8wOzmYyCyw42vhGbKo9M=;
	h=From:To:Cc:Subject:Date:From;
	b=u1ph9fIdAnZvv9dJCjjcTSv4bbYyqmA328oMhUxvu485T+x7uorCIBD/RYRusOVXA
	 a8JBOWQ6Ee3v9chlzb0necHDvjcvbtMgWfVB5EZ2Zq5SUXvGfD7IuFZ8nbG4j+BJwA
	 K/93Op3MB1fy6zig5Pu7X5hfPHmQzyzL2nNNgqSAVLibscXv9JiVqKaW/CQDufDQhx
	 Q3YKl17q1h6u5Nn9BCloV2Bdv/IwWGQntCP5GYGf3RVAO8dktfaMjkXLi4LElkkkMP
	 CAKMwmhwA2gAJbzhHne5R4IOUEyHVkcgZqu0dN8s/CKcBUhEpHKCExW8EKcwHFKYa6
	 LCe9LZdXfaUIQ==
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
Subject: [PATCH 0/8] Docs/mm/damon: update intro, modules, maintainer profile, and misc
Date: Sun, 18 Jan 2026 10:02:51 -0800
Message-ID: <20260118180305.70023-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDC1F120002
X-Stat-Signature: ufyysd9ysakbbjpruq57us3xdr7gbqcb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768759392-94372
X-HE-Meta: U2FsdGVkX19MMlTzssPifvZht9v35zdcZ1tuBY1HJUr96laBg2BrIsF0Cp7NXnsFbZAMBa3PzbtYwDUul6B+Gfz+RRitD0AhTODtgLlyNYCw2DX0Er3iMZFTHt15TtKzwSTiNSr/iKCcH1P+/WM5G1YywOfqBH1lVy13SjDJr3wBTwBULUWCPb4tu5N8NKdxwh9EGtfOp9ToSSX8LmIJ5SFYH4tWhZvPaBKl3ZfzSh35Qs8Oec9eDN4BgO7xpz+8X/WdaZKdPwT30IbHETwkI7+fprmEqea4PO8ycMJtbXb+ah+fRquPpNG0syusIWLksXQpnOici62YIS3v+/nJJ2vsRgTGN4JcMzzDQTAI7sQO9kjcACn4caudmV4WBpPY8SNfNRdYZbyt5nulbOprvwZN9w38SisfYx0KuBul++pMvfi8mo4GIn0ZgPvTRwo0rOeYZiVPRTqXKxUqs6O6aPoL58/K0qt8c0XgfWprKPHn0p/SIzYSXF1EJ0jfZerG1ZStTzVt4K26NFZs/M6uWN1EW3QrdaDwLjHtJ+8YDcCrw1T0u6yyFHitYp2eV235Nm0DgXRXZdzFAskPdISd6jaaqMwBvQ84fwMrcQw718+QrT6UH3M+75AnTuughEXQff1j+f9Pc/LHXPvxCC6l2if1QavAgaAa/0yW3gbGGTihv+erjsC2PFs2TIdVa2sp8I5QjTzVUIra6/l73+TtDjitKd7cbv3w/dvgcWr5UdXcDfvFvw5FVCj446FXk8vCK7gH7Y3KjYg6SP5GBCc2xkqCNlsA2CI7ne/jmVYq0Gwol0AAe1SIVGlk/OKVMyaZYJAgEm7XvLaAr0PZS24teceC09jcFAnfOi4ALLjofI8Y3gPjAr1I5zKznASf0BoF99Fdakpb1eqtBXd+Ujzo1pMwDhGZV7POA5Gytjt+OFTICjCF3GJdL7BAUyRDSy9YUpQy3EMuLA1ZHfxmP7h
 5802KWVl
 JGt1+gZ/BPLUm/qjt2apRfjFqpXtzsgQSA+snlbQl0GXW27Ql2L1i1cnVitkSkdqy+ibgS8mnv2VXLx7mmqQ5q6MX/iW2DmiVzeCRQ/PUsoDydMbU1+A7fPL+sjRZR852uXlC9dLo4KI5WUlcizH73c3XPpdy4dkVnB+1l2cMghUW8ngHmgw2GFovkjv6ChUJ1icQrmLp64a/v3HuxvYtFyvlHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON documentations for wordsmithing, clarifications, and
miscellaneous outdated things with eight patches.  Patch 1 simplifies
the brief introduction of DAMON.  Patch 2 updates DAMON user-space tool
packaged distros information on design doc to include not only Fedora,
but refer to repology.  Three following patches update design and usage
documents for clarifying DAMON sample modules purposes (patch 3), and
outdated information about usages of DAMON modules (patches 4 and 5).
Final three patches update usage and maintainer-profile for sysfs
refresh_ms feature behavior (patch 6), synchronize DAMON MAINTAINERS
section name (patch 7), and broken damon-tests performance tests
(patch 8).

SeongJae Park (8):
  Docs/mm/damon/index: simplify the intro
  Docs/mm/damon/design: link repology instead of Fedora package
  Docs/mm/damon/design: document DAMON sample modules
  Docs/mm/damon/design: add reference to DAMON_STAT usage
  Docs/admin-guide/mm/damon/usage: introduce DAMON modules at the
    beginning
  Docs/admin-guide/mm/damon/usage: update stats update process for
    refresh_ms
  Docs/mm/damon/maintainer-profile: fix wrong MAITNAINERS section name
  Docs/mm/damon/maintainer-profile: remove damon-tests/perf suggestion

 Documentation/admin-guide/mm/damon/usage.rst  | 16 +++++++---
 Documentation/mm/damon/design.rst             | 21 +++++++++++--
 Documentation/mm/damon/index.rst              | 31 ++++++-------------
 Documentation/mm/damon/maintainer-profile.rst |  7 ++---
 4 files changed, 42 insertions(+), 33 deletions(-)


base-commit: 4bdd7e0e4afe2bb6bc27862130f1cd365f3cbbef
-- 
2.47.3

