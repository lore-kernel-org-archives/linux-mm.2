Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 536E1F55105
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B13B6B0088; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7267E6B0093; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D63E6B008A; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26F666B008A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A2771B7D93
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:42:29 +0000 (UTC)
X-FDA: 84520288818.21.27DFE6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0130640003
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:42:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FTzb+iLN;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+oxeCGAykGpLOzKNtm0DlhsOLlwkJfxS/AcUN+UM5Ok=;
	b=66tXuQSztATCn1j7xV5E8Qt3X8dyo/g0y/42UtCsooSJKe1mTL/zNzJ8ErjX9/ra5UX0Ym
	lZ31d7TH9egA7c+DA+VyzGMjP68DKJvSH4R1VPYh7mOow+hac1AFGS4fNIopMxvSbJ3pgM
	DK9Pp4Nd1Sno6jJTAB9TYpP8okFT488=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912548; a=rsa-sha256;
	cv=none;
	b=RyNHypl6Wh+LBNEO6r8yblLZhwbFMmVGELaDqQwxUPVB2sjDjK23JNQV/A5+Qkl8ftytPi
	RFhFy1rzuJzs3mseGSLcfd6RSAgDbPsoVsnvV0wan/ZcP9poODiTVf561n3tqISt3URSLp
	yu+vXEgyR1VYBgRedqvZuOxhaiG+AGk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FTzb+iLN;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBC6F42AF1;
	Sat,  7 Mar 2026 19:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382E4C19422;
	Sat,  7 Mar 2026 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912546;
	bh=XcYOzSBU2Ik0HwEKQuQLPbmzqjVamPRGuDKVpDrdtlQ=;
	h=From:To:Cc:Subject:Date:From;
	b=FTzb+iLNu/uBbbSdvLtNPcvv40maRDEccaneyljx8hs90sXB3yQ6NIkDmcP1yiY2V
	 l4oL3AfHGNf5pNtb5zde1mcXnIT8/nchwCm5tQgndCyA8BaCSxYlF5oc+oDAYUcXa3
	 ZAI7EHpezLNrc/lXfXJ21FZWlJ+Y8GYEpyqjAgjcqLAw7y75iSm44rNKFQqpQbdJdh
	 QN7uOCqQix1dem5EPQvQNMg3YJ0tNE+TJ0p2GPZ9qq1wmbRKG1Oy0ApUxmEygjUnDj
	 kf/si1+GP5vCWQ0lu/n9ku4rzZjtxJ8Pc0TbgXNUFhRcf43zgFNtLVN9zOzAylqdBS
	 HAI2NK96bH8mQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon: test and document power-of-2 min_region_sz requirement
Date: Sat,  7 Mar 2026 11:42:19 -0800
Message-ID: <20260307194222.202075-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yxp8z3megjxecxndh9kktunkojrzdsbc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0130640003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772912547-91885
X-HE-Meta: U2FsdGVkX1+SRBGNi7vF++k9/Qbe2UfOQp5uMwFeT2vbHfw2wt3yHCkhqaUf6uXq3VARH5DDE0CMBPtzRcelGG6DB4bVnsb/iW+SmUwWPqu0yxrzOnCvjWCVFzId12WQBF7b7vcQwFKIOPdzp9GXflurFuwOVYafiFhnNobQceaGNedsk3MzifqnLlVu6xnERWIK4tTWywhKDU3B8oQHTxCHPhGaWKMoHlY4rNY8KHvGZkZi1FpKcU/BtxDZGZv9mHl3SVZfnmaccZDdDTbZWH8+AthlILYKzxTYEhEUo2aYh0w3iiqvoJlnBudJYwDAw5CzPteq3GjZM25KHl926HXKtalzGaBXK45O73prrmKqyYo7qTGgBlryBBWi3U3C8z8MN0SAHlG3Htb48l92a9DlE53fCb9l9fWIfn9cMR4uWQmQlTQt2gxwcg7yAWfb5T0m8yXqg6MthXYWFvJjbw8Giu+ll0ruDZs1sZgR/B1WwSM/lvZs7nNr5ph1Izw7pWimDCppqgancmA4BDDKr0PjHjCYZaB8XB7daWKsaEYASaYBySQE8StdaPMIqWds3km7oMwEB7xCUkdKZgXOL2HJenn9K88NYb34HEs38ZM0UWSJevifGgNsHRYpWoLvH3Dtc+LJSFKxiF09Lm9qrUtcGoa8cOoWBhQKjQ72sfons7wuoenirAEIZkNwu874k/5E7y514STjAfxBwnzAfD/cGqXEQwaX3LX4rJ8scH1PcpAYXlhd5o9HIqiLQI+WE/b4toBpZ5DU+u6cW4kyN5jBxOTbXaUZbpPvVMutsXVu3b5npdLOTXwg8HS+hsbFbmcdJwT8AroBCbTYJoYaxVk+LEJm7osC79I+hYBcnjCLIi3y0H4u2bN8yi0Bv69JgT8GODq2x4mKUmyBTaYqgsv1hADObdRzQp/VnhlQj1MncyFdgsUsvtnCNQy4LpQ9x1RCgXbiD1qiiIg7776
 xiRMTfXS
 5fIUm6QPkzNnhPLMv3geZHxJgR8Mb7dZPqKJTka4bFZ1Th8bKkvxPquzEfcxKLY/h91EJydsf6hka0EQji9zzyLEjWddaU2gOg8eOiOyQ8wMjqOlH1c7+3puPDaUqR9Dt8sdVKwr/k+wdzADFDr5vdLVcCoOpevkfuAXfRp+k4dzhwKwJ4zBbl1+1C/tv1sfNBcYc2QOeWVfL2WUROwKXLAhX0N3mr3ojae4shGZonm/Za5Fa69BGJ/t/0qcpmJjLaKEst3N/qrLFr23PCobZNUZVaEwW+3+7JZFat3Qr/nNcbGF5lXcZzviCOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit c80f46ac228b ("mm/damon/core: disallow non-power of two
min_region_sz"), min_region_sz is always restricted to be a power of
two.  Add a kunit test to confirm the functionality.  Also, the change
adds a restriction to addr_unit parameter.  Clarify it on the document.

SeongJae Park (2):
  mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
  Docs/mm/damon/design: document the power-of-two limitation for
    addr_unit

 Documentation/mm/damon/design.rst |  2 ++
 mm/damon/tests/core-kunit.h       | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)


base-commit: 4380f0b6370ead5000b8d155b25a86cb59d68c06
-- 
2.47.3

