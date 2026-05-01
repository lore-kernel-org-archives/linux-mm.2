Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9456BCD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15816B009E; Fri,  1 May 2026 05:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC68D6B009F; Fri,  1 May 2026 05:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD086B00A0; Fri,  1 May 2026 05:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC8676B009E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:50:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DE471401C6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:50:18 +0000 (UTC)
X-FDA: 84718380516.18.4ABCF84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A45BF140005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:50:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AE9kxXYN;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777629016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zGE50/qHyVK7VFBRu/6JHAkqfm7V1SKgvV1mRG24AK8=;
	b=XXmYEG1VP/0W67CitgGniSTdMD9Q25UXSH8VFgVcU6kHxBzi9EVUoMSheiw5TS/1e75dLP
	ly4mIT1k6//eRkK1U7OH1yvlMRUYXvkgR4DyJBclzrA6jMsGKjibOkaHR8DGbY7/xaZ6Ak
	n2mbHPEuBPoEwq3bNatvVtaESKg7oUY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AE9kxXYN;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777629016; a=rsa-sha256;
	cv=none;
	b=EJVjwuxu4X+AfclDQ8ux1SnBRJIZ/1vaJNO+suHU2SiQ45gQ1jW3n52gftMTmAiLaochzE
	0ZAo6a6HN3+AZ05RRyt4Fq6cPuvILtWm95eeLLwSeISt20PvkBuyLocXH3cdkBuTWOTxKd
	mdyF/VrAcBBKpcWyPFw9+x1tq/WyQ6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8232D60126;
	Fri,  1 May 2026 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72166C2BCB4;
	Fri,  1 May 2026 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777629015;
	bh=mP+fXN+cyH0QE8nS6Oz/OpXZk5m+VMXyOKE7LaxfOhU=;
	h=From:Subject:Date:To:Cc:From;
	b=AE9kxXYN20in1PQFB2FIpDD/FJhdX3b0QIsQhWSW/y+KVKeacFOn77Kb5GLGO4scX
	 oPEOSW0E6fkR7txGW6BEfT8w1rFqRrIizIjWxqqGfGfYsc6rBwf/xRzCfv5s51lOkg
	 JeSCM5r/0Cmoz3Xlq/lcu8q5AF6qf3wzeXmpJ0WATmoogcxXvzOeH5VcaSmZfMvncF
	 QTR+VwLGUQFOTB4mS5Cj9ZIypNANkJUvY4kpxsm5pFTYxvBKuAqzVKADw67m6soE0p
	 tKDFjSqChmG2h+NhIjYIMhFLmoWvOyh0qK/aEVy5uYTuzpTQMKjqY+eiTe0MkHnUwU
	 fpnG7OfavuC3A==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v4 0/4] mm: improve write performance with RWF_DONTCACHE
Date: Fri, 01 May 2026 10:49:34 +0100
Message-Id: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23MTQ7CIBCG4asY1mKA8tO68h7GBYWhJRow0DSap
 neXdoXR5TeZ511QhuQho/NhQQlmn30MZfDjAZlRhwGwt2UjRpgknFBsY5iMNiNg0VIKzirQrkH
 l/5nA+dfeut7KHn2eYnrv6Zlu13+VmWKCqROKS6d7rvTlDinA4xTTgLbMzGra1pQV2vHWgqGgh
 Ox/aFNRJmvaFKo66BtldSe4+qLrun4AkWURtRkBAAA=
X-Change-ID: 20260401-dontcache-5811efd7eaf3
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3840; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=mP+fXN+cyH0QE8nS6Oz/OpXZk5m+VMXyOKE7LaxfOhU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp9HdOa0u0OLd8ip7GlOCc1ttZzER5B1Il5CNrT
 xGtvmsi4EGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafR3TgAKCRAADmhBGVaC
 FRLQEADXbJsWzNf6xlledXUOy4FvUKU8SNZY54YjBCf4Tqyat3f9Aqy3BEgKo6q7+9sMAYmLriK
 IcCUN8Mxxc1XGR4srl6uTf4vveaNzepzTMonBen210IBhm6zmDL92iiCj8AOKBNgtidBze0Nfg7
 XMwsdicxH66RXnSM/y3bdrcJRUAHk7M6t6r9LZ12CfgApcCGXPqW6NwzAg/88A962tDl2/oep6B
 3AoHavnSpi0gYi/cW5IJIKQ8g/M93LMGBTBR8x+VjawVyAkG2+gb56ByCAdgUXSRSdzHZ3BG2KA
 bTNHgPx2Y2O/aRQ7wzNg9HxrHVBLqwEG12Iq2cDTwkd0p+KV+05CmEFCcWUQRxCukhf14wzbP/P
 gGDBiUf33lezTJldqtLhyzYaM/hsP/r9RgwvRMNzxR/pKrqSd1Erras6As2sPPoy2tfcJAEWqe1
 udk6X9zFA/aZxWdvomoVRtCyjBQ61mMDXGl9EdqiG6Xijms0CxVKS+gjhu4+cLRBMRihWt1Zq7O
 Ue78ljy0nFc70iCld6I06SO9cMgCMmHKgUPtLOtHeS9xGwmERx5aveG2jYpk7+NnRmijs2I2B9y
 peFUXvIYZIO5daBqodbpTUSmHwa3QhPF749nVazDzaEO2YXrYC/QAIRNRPZe42Nmc0N/4zfUBvY
 Fz+6DJkvsj8mJoA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A45BF140005
X-Rspam-User: 
X-Stat-Signature: crwdptddkoqeqmdrz95cyz6kc4wshcen
X-HE-Tag: 1777629016-330282
X-HE-Meta: U2FsdGVkX18eYs+MxMhb/0I6iAgAYMl9+qATUbXspfNiudk9WToVRLY0qwo7RFx+Bgqn8i9IymBARJ+vhOG3lMXhwxrfEOQtq9IVR44isNi0Bqju9PTJjxnjq4eVWBnJSQUZRoLXRRKrB4fzYPWBOp2szcPFR+d4AAthV7whfyQ5kaJ5wnPZ1qQjcbbS3FLdVfxrMB7VjPgRBEOqWDz8t6JzXzz6D2T4zJG/lLtF4kWtSb8oQ8rimNt9yRWPzMOjugMMlRLx/jvwXwPg5D9yeyZbyz6p8PsekQcaEnw8pqjj27bWshVdM9rsea8REbZ6SFFtN3cCLmKunZ3U61RQrSvxgV0VM+pIDrS/gxvSV7cQqalgwzi4D8C7HgWRgISj+Fh1gsvDC6HA/pfdQOrY9K7vVwCIIWwj3ojazAybVBcg1yBSy92j1w/ORR7bbw1zd+ljfvUHqGOO8SHCT6+PYfYZCqBOWu+zvms69SNxDF2NQjdcRoBpTpzQkLcQbmuYvrem4rj4ajn/VbPVgB96lPXAlE7QaeSdna+xcThn9kFw9/HqJB3ysvGtsk+k6gDbInnG4cRMcmyL8x+n88RFnSnhmRHAkjernWVhGXTpe9m8ZSpcYQuuY+bgRKpgqV+GBpYy5EesKVGDkuFRzeZ7bTpbfpG7zWDbz9hZwVzI1zVt0R4mcnVHCD44U24S5tq1T3jVT5TCKx5/oCtrXrRF5iXWuw8iQjM1hrWbHmyNwbCFgBAOUaR7TQBvRmKsAJTe77OoE6kJ6pS+97H2etVXbcbosk9IGzQDoVNA6oNJ+FcJbAuSzUhqiYc7YcgNd1sjTPK+pDWVtWDIDwekSoGMWlwhI7+qPQYOOJCjMOS9nV9hrXJLz/sSLyoBXnjaGVP5mneI2xIGhBh8/yvoZL+cQB08WwEd3MAu3nopX+7Kr4I8jw+6u8cBmbkZapyuqD4N2TL8EuELNGlPiidEiTR
 C7muhvps
 Wo1d4i40V6alazRJi2lldR+Z0i119FZVO8aBpTL/IogAzx9Kk3JNwygZoMgr4bpc6vzCXBH7PrOSGU9pGwRrSRKGJ4CH9P01K1aBQGDfjYYLKIm2RIuFyBdJWl0I87gq7aUC9ng+tMZdjBtX9ZoP9NDbE35KXC/IMzBsp1WIEcIPhNvs85l8ZOBftwXTEQte0TTyRnmzk6ckHGtvsjq3pDeFynM5wzFjNI7KOVd5Nvv59hqZhTrvpHU8jIQ7ctGT/qrNZpt39uj0cz7H9/Ec+gyaU/OMEGO0rfHAigqbMoM0yQmo3vYS/087PVuwsg+Iw2vcy6N8cfjYHjQT+CPIzeTUQCfbsD5L2xk/K1HLDTYRCFHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's a new version for everyone to contemplate while traveling!

This patch series attempts to improve write performance with
RWF_DONTCACHE. The main justification and benchmarks for the series are
in patch #2.

This version implements a scheme that Jan Kara and Christoph Hellwig
suggested during review of the earlier series: after a DONTCACHE write,
kick the flusher thread to do an amount of writeback proportional to the
amount written, but don't target any particular inode or pages when
doing writeback.

The second patch in the series has a summary of the benchmark results.
This seems to markedly improve RWF_DONTCACHE write performance in all
the benchmarks I tested.

The benchmarks I used are in the last two patches. I'm not sure if we
want to merge those into the tree as they are (mostly) AI slop. There
is probably a better tool for this out there.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v4:
- Track DONTCACHE dirty pages per bdi_writeback
- New benchmark for competing buffered and dontcache writers
- New benchmark replicating Jens' original 32 concurrent writer test
- Link to v3: https://lore.kernel.org/r/20260426-dontcache-v3-0-79eb37da9547@kernel.org

Changes in v3:
- Track dirty DONTCACHE pages in the VM
- Have flusher write back a proportional number of pages after DONTCACHE write
- Link to v2: https://lore.kernel.org/r/20260408-dontcache-v2-0-948dec1e756b@kernel.org

Changes in v2:
- kick flusher thread instead of initiating writeback inline
- add mechanism to run 'perf lock' around the testcases
- Link to v1: https://lore.kernel.org/r/20260401-dontcache-v1-0-1f5746fab47a@kernel.org

---
Jeff Layton (4):
      mm: track DONTCACHE dirty pages per bdi_writeback
      mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking
      testing: add nfsd-io-bench NFS server benchmark suite
      testing: add dontcache-bench local filesystem benchmark suite

 fs/fs-writeback.c                                  |  60 ++
 include/linux/backing-dev-defs.h                   |   3 +
 include/linux/fs.h                                 |   6 +-
 include/trace/events/writeback.h                   |   3 +-
 mm/filemap.c                                       |  13 +-
 mm/page-writeback.c                                |   6 +
 .../dontcache-bench/fio-jobs/axboe-write.fio       |  14 +
 .../dontcache-bench/fio-jobs/lat-reader.fio        |  12 +
 .../dontcache-bench/fio-jobs/multi-write.fio       |  11 +
 .../dontcache-bench/fio-jobs/noisy-writer.fio      |  12 +
 .../testing/dontcache-bench/fio-jobs/rand-read.fio |  13 +
 .../dontcache-bench/fio-jobs/rand-write.fio        |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-read.fio  |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-write.fio |  13 +
 .../dontcache-bench/scripts/parse-results.sh       | 346 +++++++++++
 .../dontcache-bench/scripts/run-benchmarks.sh      | 643 +++++++++++++++++++++
 .../testing/nfsd-io-bench/fio-jobs/lat-reader.fio  |  15 +
 .../testing/nfsd-io-bench/fio-jobs/multi-write.fio |  14 +
 .../nfsd-io-bench/fio-jobs/noisy-writer.fio        |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/rand-read.fio |  15 +
 .../testing/nfsd-io-bench/fio-jobs/rand-write.fio  |  15 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-read.fio  |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-write.fio |  14 +
 .../testing/nfsd-io-bench/scripts/parse-results.sh | 238 ++++++++
 .../nfsd-io-bench/scripts/run-benchmarks.sh        | 591 +++++++++++++++++++
 .../testing/nfsd-io-bench/scripts/setup-server.sh  |  94 +++
 26 files changed, 2199 insertions(+), 6 deletions(-)
---
base-commit: 26fd6bff2c050196005312d1d306889220952a99
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


