Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED994FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 11:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1CE16B0005; Sun, 26 Apr 2026 07:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6376B008A; Sun, 26 Apr 2026 07:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E176B008C; Sun, 26 Apr 2026 07:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF4E6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:56:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01A5D120572
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:42 +0000 (UTC)
X-FDA: 84700555086.22.ADA8977
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A87AA0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pkx2DBIS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777204601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z8bJH0seTnZd88bPok9dS2KdzStFUauwH8mSDYyzRLY=;
	b=TOQUitYIOPQgcjAwHFOLZsRNdXhALfLToQMQP0DdJcq+g+lmQxIEg1uN6WUPsHYb3ej6Dt
	e4kYjoaIcz8EY5vTblEXi5oqNuNyIt3scMUEJFC+zajAvdexPzGNxDqi+i5nqNm+1ifgin
	r1RsoaiaYhh5k1AH89IZSzQkieVYuZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777204601; a=rsa-sha256;
	cv=none;
	b=582RaFDYzMVDFS2Om4hd6UKKRb7KS1N+UJsh0AzlRe1VbtXPYPzlEVqoSe7ekLh4Wg4j2M
	wXqp3s6ubi0XU9X+DC+3+Ha+/n9BvlGgCEtdATlJl7yHtbtL8LzQ+q9HaLq5Xi9vySOgAE
	1V+yfXeP0Brn0cSbB6sG5+Qk9X6eYEE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pkx2DBIS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B012F44329;
	Sun, 26 Apr 2026 11:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1221C2BCAF;
	Sun, 26 Apr 2026 11:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777204599;
	bh=bl3sJbVGz9TiGz2FlHfKChu0f4MKe8tz0T9GJRS1TBM=;
	h=From:Subject:Date:To:Cc:From;
	b=pkx2DBISHsaExlC7SN08Iq4EDDICnkycUtGnKY5GeLzk8p55eo/XF2fE6FkPsC9iy
	 2YSYKU9VVJUgVRZjhSzRouPan1R3RiuLGhnkPZIY5CGz0Do2h7RBJ77VAxOmMegNc1
	 YalwLgs8OOCjenA471qkhEhY15v5aFa2w/dQqXu15/MjQh3fr0lFyBwAJmnn379+JW
	 fYKUzigcRAIkhiWB+Vwy8uM/uJgC9Vtro3SuDh4rpsYdaRsRipqo7RyILqk4EPuPG3
	 AkP7YphApRU1F7aimgj7btwPdQFfB2czHxsU6kC9emKkUVe4ap+seJ6nGG/oMIXBuy
	 +Qd5XJzc5ae4Q==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 0/4] mm: improve write performance with RWF_DONTCACHE
Date: Sun, 26 Apr 2026 07:56:06 -0400
Message-Id: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22MQQ6DIBQFr2L+ujSAKLar3qPpAuGjpA0YMKSN8
 e5FVzbpcl7ezAIJo8ME12qBiNklF3yB+lSBHpUfkDhTGDjlLRWUERP8rJUekTQdY2iNRGVrKP8
 ponXvvXV/FB5dmkP87OnMtvVfJTNCCbONFK1VvZDq9sTo8XUOcYAtk/lR7Y4qL+pFdAY1Q9m0/
 Y+6rusXm5JfjN4AAAA=
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
 Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3511; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=bl3sJbVGz9TiGz2FlHfKChu0f4MKe8tz0T9GJRS1TBM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp7f1qg1sKuyaOZKrn3qCqDk/uRJ3vfoQhHnBVM
 EQ/kc3F7cyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCae39agAKCRAADmhBGVaC
 FR0qEAC/tsTXxpbW9lpyK7ZFDMkpNcA2PMA93Bpgv7oLQI/LKg8aybErtMbgtFZ7vAElKL7BNoq
 cRmUU4BGOS5fBjpJL/ZmDCeAoQveWsDIncrUDoSshvPREODKr3urQywMntRtYzfr9Iq371l25EL
 KAXHyQmxQN2f3R4iVdyeuCm6ETxzFMdk1+zROdadqogg0GQ3uaZJb3YrxchmHrdXj3H9tSHZu5q
 27GD7c8hldvxxPWJyEk5G8mBcLj60cmO/muMgsIqliLi+us8QK7f/PjIV9xUvq4/EV2DZpd2coH
 hCiqe8mNgKw6er1ciK0t9Pn/2oSUZsEKriuXoLxdw64+cFlbHlwS5HKUJzIpecg+HXxoyGsZtEJ
 l8BT5J2UDXOtx+jN2pjMW6ZSXQ3Arw/w2jUZklH8Kt1WjMqriRhFAzoHf6RNftue2S8Z6c9vNT3
 MurJjnKgbO6fkZSdujKePC0mznbztbgXlYpys0xEbheGklBOzZTb/O75WD16J//Xc/CWF8FfrXq
 VqUv3/wJUoSJD+K3dZuWa1l82VnUbdePH9ISDV70KkPTEW6Nta5msHhN1rX45V9mCK0AcbmCphX
 tL2m7jvCf955HCF/Cp3zKczyVqnygTlch0z9rm0X83mBlpBIEWLte6ABk2wVjND3H28amFEPRpa
 92/1Z8RCTzeb00w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A87AA0002
X-Stat-Signature: mdwm1qtqjb4nwtkhis7xfzh5fiipoxqo
X-Rspam-User: 
X-HE-Tag: 1777204600-48003
X-HE-Meta: U2FsdGVkX1/3aVZ4gJP8tTcEfduWz4OxZ/hEek3189gByFlQSFBJodeDxZcTwGRzpgDivNVip4PW/Tps+NQLbCO16R7Pe5zcrGJM6J/e4D118X9pT+MNE8YThYNA9oX4Pd3fwXbGfUhTj2gbrionKE8Krx9ayb+mPELVHjCvOog3FxrhVN/dorRpGRg7ANUDMI59TR/HGoFE8RIoRhNUoEbaCuj4oJ/3Rs89kmr+TVU/wG2lAJVSZvvgcF5CRF1I7pcYZKNPuh5diiD3WDHGTS3fNQvGVSJFIubI4QQQH0ES6iwXlk8jQtfw9+4+erzdV7tyhUyBFJkNLcDcGO8Pz/vUnTZCDUkBhb3BN0Mp3ODKQJ+MZif8VASKwvnzvHDuLYEXUD/YMZR+IfHuKHu6UPoF7kPODe6ontDgtRLjZ4NtZTi5sn/XPujq+u8lyhl5l9qt9KFXEN+pd8hx5HGIdAjIQdelYo6AvF8NAOrCqcyaFP0Yc8nF/O0FpMh4m8CDv8HmbYJ1mhPy4kbQaTkKfkBmWWBJENxKaZ4pT++UmZfQALcBf8oQv7Il2tT7FNjsq9kPkgS3SOtTOAlLxBId8tiSty4wAI0AlUBig8n6UCU3oi4sw2fNqydW4EQmLqEblc5uWnqkDJpUTqhd3aKO7vKOIkgA7aECe75Y5JZpgjYthQmY75FP99qRrQxx0pWIlyyMQU2b8PcIPxx7VfkMdL95HvngzzRmTtY5b75XvnJgm6V5N4M5ffH5p2Uz5kVdg6hRtBLdTsAbajaTl8pvohDB1MD9K8CyMO1QvX9GCbZGOTL9Q3e3Fyjv19g1EzbApHp48VWE6lM6fUaoFy4bC09p4dNe5+pNT6EFI0/dmVfeoArYr/+QWBNYvnAwulNqyewO/IKCNWfTsYErN1SbhSVMq5B28q68rPg7IdKLb8oQdi3gg8BqIt9j+KqDxnjyS1pZpKhtdz8pkPdIRmQ
 MyEQN3dZ
 soR80HRHFRS4NlDvpBVzfgW4a19GJ0IJVVhbO1/wHTInvDhDvXG4Wq7sBtB63HxVrQiRfGnIh4UTbdMVzOb5EP+FG6NOePMhhr8LR9m9BYC0xkU6RMZuusfuEMLktLzrRWpFCh3elDJ0matcrs3vD1a9n3nEFU/1/oqRbz/pHBbq2HX35Pzsy84rznmukhkJ4n7LaH2BsBDoxfcui4vP+DUDBZnFwysvhn007XAsw9S/PWlsDD1Vus40htdJBOvcug3CXZSTQGJKmhBQYEVB+MVDorZ20EImaneMtqHd/Q28RcA5NspxO5EtKlA05l/flQaLFTuH4ZJrhX7k0xE9wAmCesDWPhtZ9eOuA7FMKqfc2QUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series attempts to improve write performance with
RWF_DONTCACHE. The main justification and benchmarks for the series are
in patch #2.

This version implements a scheme that Jan Kara and Christoph Hellwig
suggested during review of the earlier series: after a DONTCACHE write,
kick the flusher thread to do an amount of writeback proportional to the
amount written, but don't target any particular inode or pages when
doing writeback.

The second patch in the series has a summary of the benchmark results.
This seems to work as well or better than the earlier approaches.

The benchmarks I used are in the last two patches. I'm not sure if we
want to merge those into the tree as they are (mostly) AI slop. There
is probably a better tool for this out there.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
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
      mm: add NR_DONTCACHE_DIRTY node page counter
      mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking
      testing: add nfsd-io-bench NFS server benchmark suite
      testing: add dontcache-bench local filesystem benchmark suite

 fs/fs-writeback.c                                  |  60 +++
 include/linux/backing-dev-defs.h                   |   2 +
 include/linux/fs.h                                 |   6 +-
 include/linux/mmzone.h                             |   1 +
 include/trace/events/writeback.h                   |   3 +-
 mm/filemap.c                                       |   6 +-
 mm/page-writeback.c                                |   7 +
 mm/vmstat.c                                        |   1 +
 .../dontcache-bench/fio-jobs/lat-reader.fio        |  12 +
 .../dontcache-bench/fio-jobs/multi-write.fio       |   9 +
 .../dontcache-bench/fio-jobs/noisy-writer.fio      |  12 +
 .../testing/dontcache-bench/fio-jobs/rand-read.fio |  13 +
 .../dontcache-bench/fio-jobs/rand-write.fio        |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-read.fio  |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-write.fio |  13 +
 .../dontcache-bench/scripts/parse-results.sh       | 238 +++++++++
 .../dontcache-bench/scripts/run-benchmarks.sh      | 562 ++++++++++++++++++++
 .../testing/nfsd-io-bench/fio-jobs/lat-reader.fio  |  15 +
 .../testing/nfsd-io-bench/fio-jobs/multi-write.fio |  14 +
 .../nfsd-io-bench/fio-jobs/noisy-writer.fio        |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/rand-read.fio |  15 +
 .../testing/nfsd-io-bench/fio-jobs/rand-write.fio  |  15 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-read.fio  |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-write.fio |  14 +
 .../testing/nfsd-io-bench/scripts/parse-results.sh | 238 +++++++++
 .../nfsd-io-bench/scripts/run-benchmarks.sh        | 591 +++++++++++++++++++++
 .../testing/nfsd-io-bench/scripts/setup-server.sh  |  94 ++++
 27 files changed, 1989 insertions(+), 6 deletions(-)
---
base-commit: 27d128c1cff64c3b8012cc56dd5a1391bb4f1821
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


