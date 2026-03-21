Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E541094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120346B0128; Sat, 21 Mar 2026 16:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1056B012A; Sat, 21 Mar 2026 16:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29176B012B; Sat, 21 Mar 2026 16:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEA4C6B0128
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:07:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A47A0160640
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:07:33 +0000 (UTC)
X-FDA: 84571155186.02.667C4CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 00E6E4000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:07:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5Up56d0;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774123652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnGlvvf1okFoHp6+kmTc+TEhwkXA5GWX3iHIdAKOEY8=;
	b=rIlO/n5+VLDPdXS/TQfjHuewWe3vx7mlY9X1/LIppE0qMBZqgfPOYNIUpakkSVs2+82a0Q
	aYxKrcscQWj6ddO+fp/mlx3jWLTU7CdScXCdcYatUh3j2Z9hgIUppg/3+l1VsCgTghb/94
	IuQ8KJcJQMsJjnAtwB0pO4ndfiA+u70=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5Up56d0;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774123652; a=rsa-sha256;
	cv=none;
	b=Ok0S7Ooq0OAs9Vm4ANxlZiVK/6oGucroxINtWsxsRanF2eB1uVn3w523wvVz3m1hj7Zuhv
	JqRrmxAIaYG0EhsBDGT5nPR0uX3W5owB7xhQQDUZp99rgOX685d7GlMx+WCcQkWDRUxyVf
	arfMJxJTTSekBN8QKAJYg64QnKlswpg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E823343B33;
	Sat, 21 Mar 2026 20:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEC2C19421;
	Sat, 21 Mar 2026 20:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774123650;
	bh=0MNSbzVZDYdlO97OIWpX8pZ4IYNdLpcfoylYibgIq8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5Up56d0Zpao4XkiAbIdKYjt57W+ElFPoy6ODEJOZ++dBPp05k9Ls4q8Z/3CpO8C9
	 NFvp/nP+31hmAzLygzvWicm+18JCX5d+X2f/9XHNS2YOZg9WPZPIZbSgt5HCYaHtYC
	 srSDJgSNGa3jqfN+/Dcv4ilKvGXpvylwWAn/lbFShXkyLQYrWlwbkYRXKyD2RvqrF3
	 tRTsFBa9/PvJLmLe1jytUodREAIwjJyP8VkES1Zro5GHICnBP1vIqD0lDqIkDVVzeQ
	 mirmhCZ8Sds3gKJHrmGk/5aX9sDCgyQc01fNFNECQ86wTRRhC98iNiRdCktEFBJPbi
	 Cm4/kI2HfVlIg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH 00/10] mm/damon: let DAMON be paused and resumed
Date: Sat, 21 Mar 2026 13:07:22 -0700
Message-ID: <20260321200723.95520-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 96k4berm63kybinh7pshhb8k4bq6wkuz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 00E6E4000A
X-HE-Tag: 1774123651-468781
X-HE-Meta: U2FsdGVkX192NdbSyDAhGH8qY4uWiIZPiLseyGqGgIuW6uOJ3OA3dNpxYWu9qvjx0RwNCQNKq/U64WuvyFoxrdsT4j1djhxv2OeRD2bCZ6URMdU5rNu3i51pFwrOyeQCOYb3ID6VQBvXQR46XIGNvlWRUICHvww003EksPr+D/OEDefTBYtdmBvGzehgWNc319aDRZT2Ttb/NHKBLuRS9IA4ozAIbi3uuoH8DaYqIq7uLB85wZ0iodWl+IXZiUv0y0ZuIz2bxFk1O9BMMUiIhfcYxFN5tjtapn7bBKCBCxnPnuPMzaDSNJ6OZLaGleNTc4h9j8zEXtQ4TVwknj2bi7cxlpEhIkSLZKrgo2CdyZD9U7tYcOe/3uGXycrZekflJ2g3N162j/HMwDX3gWbDePAsnEzCngTuN4LF9jao84XKN84kHzXcS0PtU2in2zV7XY/X3cEGhrYxlGWQFu0lxxeTtOD5w0fbNIvF4/XFACq0Hsov7ofY0gIu/aCNMn913iCuQt0RjuRHkfB4Cn8jGbtYNPx94/ljtYV/z+HJ1KkzbaRzqskS7Mv9Mxv+Fo2k2Hv1hYbvC8cm+wA+klbiy8DiNnsdC8EJjLF2lVrYMUNMZNoYrqSNSK+P28V/sQQhpQekKm5b8b7lyHtyLPxcTpQEhGD1VpT3zFdkrxMYHQ2P0s+j+nV/H6AtVEle5S+3NNYHBseREKKwqeWR2g9VSMD/sj3DGP7ryFDJukOzctzM/D961tZNqi2VbCN/9v4/wYUsBPEBI4pN7N9cmLpNUtTBnE3ALGjr+W9Ka57T2N9iXq3KWsaa32i5FbmiVtuiC0zVIB2PMmb75Oq3ZNXC3FRiX3uKN4hphhvUBDTiz+trX4GdtX67X41Pmda3ea9R6RO5tzjKYmB4QskfjNsCEwsFvsI4FJhFgXRvaD+jr99c5LPP6aG/i2IY2TGG0DaVi2y1JmZVqBAP2Wv2z1X
 qTvGpSuq
 U/5u0SuOUCjWnmg1M8Zt2wiicpJ/WhI4tBy44IYlDUfNx0Iq/g8fbBhm165GlsfRBnAR85wGyuKn6NdLmtHopi7UGXcO7R4H40JCsjkn3vkk7Q5qin7Tvne4c4oR8gp3m023/26OU/9rk8eFWLRI2JzLHqt27wX++QBf1td/tqoh/RGUkTAR2YzO/5Rga7ZGAAvyWlZghqbYmq4oK7/a7IySDwMF+ZhlOyDQsXD/P5Swnrc1dCsKivn5ycKwV9QNbXyhCe+HAH1bJXEC/hWqx5qjG3a+LJZp5WIdqnIWC3hVX+VIJ4PAU77lvpwjb0LYvnbW8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260321181343.93971-1-sj@kernel.org

- [PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
  - status: Reviewed
- [PATCH 02/10] mm/damon/sysfs: add pause file under context dir
  - status: Reviewed
  - review: No issues found.
- [PATCH 03/10] Docs/mm/damon/design: update for context pause/resume feature
  - status: Reviewed
  - review: No issues found.
- [PATCH 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
  - status: Reviewed
  - review: No issues found.
- [PATCH 05/10] Docs/ABI/damon: update for pause sysfs file
  - status: Reviewed
  - review: No issues found.
- [PATCH 06/10] mm/damon/tests/core-kunit: test pause commitment
  - status: Reviewed
  - review: No issues found.
- [PATCH 07/10] selftests/damon/_damon_sysfs: support pause file staging
  - status: Reviewed
  - review: No issues found.
- [PATCH 08/10] selftests/damon/drgn_dump_damon_status: dump pause
  - status: Reviewed
  - review: No issues found.
- [PATCH 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
  - status: Reviewed
  - review: No issues found.
- [PATCH 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
  - status: Reviewed

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260321181343.93971-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

