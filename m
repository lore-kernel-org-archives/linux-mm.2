Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21A2FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 17:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B60B6B009E; Sun, 22 Mar 2026 13:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266B56B00A0; Sun, 22 Mar 2026 13:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C246B00A2; Sun, 22 Mar 2026 13:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 095A26B009E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:05:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90F611606E8
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:05:16 +0000 (UTC)
X-FDA: 84574324632.10.8CB4BBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF7CF1A0007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:05:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MCbu3oFs;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774199115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htyhCj5MdZC28AEPD/tqfxQ4iWf/yWfUWKgy32VjOTE=;
	b=yn179mhOEDERdw2FP62qMlQPdYIQTBcdB3Pddayn9G13tGUMnGpA2wAUyplvKjAMF/4SfL
	FZuYY33xQyFD0f8w0xT78bnz7iGRi9q13LeEng0rmoeFASa7YgtQTE0P/eFJRBfytyegkC
	4blZUlDLsPBmEKdJLo2xaW0am0hVKPY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MCbu3oFs;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774199115; a=rsa-sha256;
	cv=none;
	b=LI0Ox93jPPPwtmJjXRGzRJQArgha9kYk4z/m0bDvVAIUTiB3rT9Z9eEhW8mEOzEDl7e062
	WjEWsz2G0AuO1cbWmJc2a01aXOv74qbEVpwGeepKKN6GmHOCZijYGSsgmp2rVVAU6n9jWg
	g6hJ5dqAJ9PL7IAZ0fPnyyT7zDIopCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E68943F41;
	Sun, 22 Mar 2026 17:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13093C19424;
	Sun, 22 Mar 2026 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774199113;
	bh=HJoiHpMG28GmRpq531IW9sBKidvKsblBjEBS3EEdba0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCbu3oFs00BZy4U6YYmrZ95gZnQkmg/QYu21GQI5AKJ3TWQvP16KJvFCDa7ILJzjK
	 qGIkvLizMUBjCg9x7UIS4zHWIaQHU2dpPb8t3p08w8yJqq6lzFzvWi95pcGpQr2ruZ
	 Gut3d8vRgNpKOMGTn5tL5zb8UDTLxjBowGL31FsjB6Ykhd5cQDyPixXqh9C5xuMLwX
	 KDx2WI/GGfBf69gbYXsGNNdMywRkqjkVhDzMG/x70lNvtNNmVA002mn9TRavRBPMiQ
	 aDvoL+KUXuVyLWJK+j91Z22Qt6iJeuqe5rn8Q8/vn9F3niwaZlEtIubn4R+ma3NwgT
	 pL/sAbPW5la5w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH v4 00/10] mm/damon: let DAMON be paused and resumed
Date: Sun, 22 Mar 2026 10:05:05 -0700
Message-ID: <20260322170506.82977-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF7CF1A0007
X-Stat-Signature: ebhooy37856su8aq5hoag4dncweykmny
X-Rspam-User: 
X-HE-Tag: 1774199114-534494
X-HE-Meta: U2FsdGVkX1/dGXimlcTCUpme3X9NknjvXVMcTaNVY2fujfwrngZIXbAcexDciEGboRWoiljaN2J7ENfVMiz+6q4aIDUpLHCCuLn46eHAvLISaEnjMSkteP+ycBwlkrIK3gfOTwwUhalRklR+CVJpzXUPiDB2aDiGRGjoTor67I/PQwoJz1EM4XojrYTIxkz1M9baE5vvDzZv92+12Q5rb3XYfm1YjUQ0mEEN/qwacH+9ikaIJAL5N2YN6JkaY2f71B/PGg+SRdBACtiHT+mqFbvnyVt5A9i1CyTfvLSfB62X0lWAWkXPU2eaZ35sf6Z3MKK/t8Oiwknr2Wm03lIvMrlS2HHIvJnsYRhM643XSV9z174kiYY5Fk8x8y1rsGUYxuPuCZMYvzV48vZxarpYkQSZJVBzozTQ6nt88tvPJLJh7lrxZwHRPS78Gn9PhkQiGYUd0x6rfW3RbcygItT8c02Oh9iwTUAWWTLO1ZApMM+g5ZUIX5rN+D0YVhs1r2++IwxeK8ZSWjCfXwupq8yA3C2qVnbRY5f5YB9VNH1c+LJxoC7bsOPZXjlnL1AD+E3WVOwFkSJCz61r4EfRJ8WNNmRf+EoocSleemiclllD42in9XIjd6DQLgvHWgdLgqhzs3oRtzUTkdA7zlwsA0Cyb/3qFI/dgctpGr8nVMLnGU7qtFx14HzkQZqIWxrfDIlfT58rig8VCwk5KMUmWQnEpDbkXTdICL9adV7a2SdkZYRbymXnMPgFKmgGutaFew6PVJiBEyGEb6Pc9SAo8KsIu7X0qYK2Ggo86mfdeJknuGbdiDDbvr2HYK/+XjNM/rnk3WE5lZfH6pkvGi9YbDm9s8lIwukpnqYQIc4eQUUwOmas63XABpIpaUlfIgK0wQR4bZXZOGX2xFdOElolz2F/dpQrgcmjmlckMVMtgvEEYNwIY0RA86SmBB+utxwJWszzdkSZ0/V7R+FiqZoU9Nl
 tWZiJrLG
 I9pjPO5FreOOP4XQVwR2fzHHXqFAWvv0t57188EAIMNJpSy3EgF+4tsZ3Mhl1DV9/TU1/g5UBTrY9GAsgv+c3XnUCMYjk4Bo+e0CPvvHANAOSPLIwCquTGZEDW6SgMtPjEXYZAhErI3D2oRz3irecn8YyHsx4jVtTHpZq6AyOFJQRJFEEGZDe/dTP6HC7mskN1191JMzN/ygpOPsHrsK5YNYRZs6WVdE/53h5qiX4MplLXAl8c4mzeawxsZ1MkTIcvWrkxT8jIpM6eJOpPhbwmv06f8uiilfIH1krude9Az64E6KGgitvfsz2R7V059JBvZkA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260322155728.81434-1-sj@kernel.org

- [RFC PATCH v4 01/10] mm/damon/core: introduce damon_ctx->paused
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH v4 02/10] mm/damon/sysfs: add pause file under context dir
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 03/10] Docs/mm/damon/design: update for context pause/resume feature
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 05/10] Docs/ABI/damon: update for pause sysfs file
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 06/10] mm/damon/tests/core-kunit: test pause commitment
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 07/10] selftests/damon/_damon_sysfs: support pause file staging
  - status: Pending
  - review: ISSUES MAY FOUND
- [RFC PATCH v4 08/10] selftests/damon/drgn_dump_damon_status: dump pause
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v4 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
  - status: Reviewed
  - review: ISSUES MAY FOUND

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260322155728.81434-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

