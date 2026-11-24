Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC9B606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=To2tbGyS
Received: by kanga.kvack.org (Postfix)
	id 7A7316B06AB; Tue, 24 Nov 2026 08:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F086B06AD; Tue, 24 Nov 2026 08:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC446B06AE; Tue, 24 Nov 2026 08:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B0C6B06AB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:02:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C44EA8985
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:02:00 +0000 (UTC)
X-FDA: 85470025200.29.7112730
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F71E8000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:01:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=To2tbGyS;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525318;
	b=ZeXdLbLJ91N1mCSHyLnq8banPrUavDzJg6Ut75t92WlmwvuclqNTAlNWXRFZpZX6o/l4ok
	7MxhMqPXCRjxRQYDhouBuPrgGEA4eTQS826Q9HJlw84vjGVrq6BmwRVSRJWlZmK33JUTnL
	nrScnenRHRW98h12bsBQ/lT459/Kjcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N9p6GMpiXBcl+jaczrOvf2ku3VNe7glVjQtCROb0hAw=;
	b=b4HCTGIv/i0TW13qyuQj0v2CaIy7kMeMxLVFJ9NnxhJ9NVd/UVx9XngoV4ZOm3V2PArzTO
	Nbgd12ujtHLLQf9VeKJvkH1Mna7E1qmjVCXWeOJArsprcHeUBFR2pQV61Lo7jOQiIJYjgg
	u2Zn1XiZk1JF3TXkW1QWrpiWUsOQi/Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=To2tbGyS;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JPkUZj7QGHtjWgvJq/FICVMX0UJPUNsCw+1258YO1uo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525316; v=1; x=1796130116;
 b=To2tbGySR1aM4P7ygW9usvjlw+G1CBv3/WA9W3qEcrKO34BtxhIpj/wLvcPwI57LJp2BwK8P
 /Z6m9irGgwbDRzqUhkhnJkI3/bUv5gH7xV9RRnki5xxtFiXSBw7ovhrRSm8Mksa1lEinFcVrVP3
 to0qjPuxjTRPoPsuoC1qfMBY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 821e2fd635352937;
	Tue, 24 Nov 2026 13:01:56 +0000
X-Mizu-Trace-ID: 821e2fd635352937
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	xu.xin@linux.dev
Subject: [PATCH v4 0/3] mm/ksm: fix ksm_zero_pages accounting on fork
Date: Tue, 24 Nov 2026 21:01:43 +0800
Message-Id: <20261124130143.128411-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8fo5fz18sm454f55bqbkxd35b7h67zhp
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F71E8000F
X-HE-Tag: 1795525318-615978
X-HE-Meta: U2FsdGVkX1/0ys3Ch/qdJx9gYgLOZyKcPgoyksCrQxcr1HIgJM+3947POY0ZGe1h4E0/tTgcx5d3Z24PQLsdetDiMuds9qLwmJZ2DWsyPGX5NfbQ8B4f6n9yCmjhacZ2TyAegXv76p1p/sJYSWaMeG2lBcPVifzgsQMd9hlmMn5Df75eAvzO7+ewcGUY7RV7MqQW0RHZvS2YzH0nWNvSitHwuFdfCs13iew5+PgD4jLM2uP6XCf4uku7QtbpkzO1EjCkSB1BfSlUnn/aFexwoYeyw5lrN3hOtg5zTj921YG/4as57p248wbfyMAIpkI8ekygraDJRBQIDeoSFKcwDwioyS+95ItXXZkK9VEsF5zU/I6cQZ3TWWEhccNcWK1ex2MWCaklRyvMg0iC4B+JtZJ/ufLVb3SxkNCRWBdtTKGAsvX9IGeJGw5iHNAen/7AJtA3uA/Ur9il6V1wqLmiZLbvi8bxpDHPEER6Kcqe8hwd9zvqPS5oIs3/S2kudJfFEFWMN489JviLbT5UJJ87A+ayrD1JH9GzEC1BVsYLUCQTkE53x6fkFqrVqwrD7pUVWp5B1Rw49wgk0xhV4Mt8W/7dXKOe0LK1tOUhdh9OvASXpPxALfX/RTQLW8XWHRvDde5w5l5g2LHoOiKHGLeOinhc4RUltVTjMBIoWg++41MwQI1hEVbwYDVtzA4BpqFmn0nT7ajSeox0vp5xo0XszcuazVbO0BY72XlVVGcyDCenKWLKqYvshRyze+C+wN60eqO9xGtJ7HH5E1kri0Ac4IY9n4Is2QLU80k99mfuGgs2+nn3Iuv/VibeKWlzVSV0r/dz7DSvJYqfiBNdRSjFwCc9eQllVVPHvQFWNpmcxC76rDeYr8Ebhx0C8/BkNuZDBxMpFp6JH2XwAWarW3lGutBI3zdxY4/+pzk290U1km6QUo15dOoWh0aFjy+2BKrOmhmfpi66qv1fC2pOM/d
 9ZXUXDyR
 URZRjBkpdLAVwEow74AEv+jSQU3kq7kA6bXViFQPIubd3UWniWV/RtbKq70Uqdwckb1XMCTD9DFv/gl//qcjOXo3ENnv1A5gbp0qxpsR/MdTOGdrESOr2M8p42PXvWaYdZiLET17riwvDKXxNveumaQ8OPdPZ5vdFkbMF5YFHp3LmM363pUzr+6fL3f4S67zP25yK8JRwwzqEdFtwAfNQ8gJoVkROM77pSrC+IRjuXVrQ/QEwGmt/3hNdeN9t99M+xTxj15Y/IDhKaPWeqnr04jlpPZf2rP/9y8YxOXQkGJEoLJMhO7rCMaw5R/rLHzCMZDwJLUuGUQB9xKpPpHVLY1wd15e19WI9FFMcuFisKnA9ICc6xMpHToo2J+KFfWNoGUaS8wxSYxTOHL0HYwkgX+OJn2GVvXBUKb92uXrjRGZVTDrw5PXPQD87CDrnGvo4pgmvSGWfI6CFdy2M1NFXLmpoToWOdhH6/0aEZoFJCF4O/sSeII5V0sIg8x1o3kLwbo56
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, fork() wrongly inherits the parent's ksm_zero_pages counter
and keeps the KSM dirty-bit marker on zero-page PTEs, inflating both the
child's per-mm counter and the global ksm_zero_pages counter.

Patch 1 fixes this by resetting the child's mm->ksm_zero_pages to 0 in
ksm_fork() and clearing the KSM zero-page marker when copying present
PTEs, and documents the behavior.

Patch 2 fixes false-positive and racy bugs in the existing KSM fork
selftest by dropping init_global_file_handles() in the child, avoiding
8-bit exit status truncation, and pausing ksmd before fork().

Patch 3 extends the selftest to verify that neither ksm_merging_pages
nor ksm_zero_pages is inherited across fork().

---
Changes in v4:
- Update the comment above ksm_fork_pte() as suggested by David Hildenbrand
  in patch 1/3.
- Rename test_fork_ksm_statistic_count() to test_fork_ksm_counters(), unify
  cleanup labels, munmap before ksm_stop(), and refine log messages in
  patch 3/3 (David Hildenbrand).

v3: https://lore.kernel.org/all/20261123034136.209410-1-xu.xin@linux.dev/

Xu Xin (vivo) (3):
  mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
  selftests/mm: fix false-positive and racy KSM fork test
  selftests/mm: verify ksm_zero_pages is not inherited on fork

 Documentation/admin-guide/mm/ksm.rst          |  7 ++-
 include/linux/ksm.h                           | 24 ++++++++--
 mm/memory.c                                   |  5 +-
 .../selftests/mm/ksm_functional_tests.c       | 48 +++++++++++++++----
 tools/testing/selftests/mm/vm_util.c          | 16 +++++++
 tools/testing/selftests/mm/vm_util.h          |  1 +
 6 files changed, 87 insertions(+), 14 deletions(-)

-- 
2.34.1


