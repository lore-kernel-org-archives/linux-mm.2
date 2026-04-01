Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11827D3517F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1D66B0005; Wed,  1 Apr 2026 15:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482BC6B0089; Wed,  1 Apr 2026 15:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398B66B008A; Wed,  1 Apr 2026 15:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6F86B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:11:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0FA41A006F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:11:20 +0000 (UTC)
X-FDA: 84610930320.28.D5A4BC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E95FF18000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:11:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJ9aigXR;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJ9aigXR;
	spf=pass (imf06.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775070679; a=rsa-sha256;
	cv=none;
	b=MfEwcRrATO4KCsSvM6thqELrlbAT0F0wO9mw64VPo92NOkoZDQe/iJTZKBBF9UtTGykAtC
	wUwd+Zkg1F8GH/QvMf48zs3q9UhgrZTzsdVnX9OhMvVpygstgmIXxY9V4DcIjthHMhT67V
	L0fQmY5Mg2kF78bZYty568C+RZUs+v8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775070679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jqGBPyeVcMscXitt2lW0thrwX0zE6CI6GhL7xbrBUNE=;
	b=Z5scq63wnuzwmnnN+/fedAZvQc6HqmdnFy7n/3xIaxoMdSBppl6i2ggendZlSTFmJy+miJ
	m/t5g+UmJGscPU9ALm2M4qjqLxpDo4492KpncQ6RJHO0jwB1PwPF/jM5DGLsyYknoVi1MV
	Y8Gjawz81rBN5gT53s4KAB4rz7N1riw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28DC160120;
	Wed,  1 Apr 2026 19:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3611DC4CEF7;
	Wed,  1 Apr 2026 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775070677;
	bh=W3khz0/FaDX409Tx7kW5G/eq7tLBZqNVTt0R4QEcmc4=;
	h=From:Subject:Date:To:Cc:From;
	b=OJ9aigXRAGsDNqFn8owwPTH2MRIk2E0Odqvpz3JrGPCAsqxuZr7mIDw81EiavEAS1
	 0SBni5EJ8H3RBe3NHbIT9l5agNPnYcT2AleXiaAMRrLj1kfJ0Hc5XggpEmRQMxtiHS
	 GtrT0udiGe7PcmETaij+CRFcKW5wvgdcUefQzGY5pyt/R6tb5yIKUpEk4Kmvy3AVP2
	 h9SEXfTF+b8cGCm10iDYRnOc9B7axg7HhFJiY+Qa4WbVMr5ZR1PQMzHYOyu746zkdO
	 IChVH4yBM49oUyFYQ29DH4JPi02H8wgNHFxVYn6JVrxE61gQI+YMItDqz1TxWcuO8p
	 lbqaA3RLm20bw==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/4] mm: improve write performance with RWF_DONTCACHE
Date: Wed, 01 Apr 2026 15:10:57 -0400
Message-Id: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEwND3ZT8vJLkxOSMVF1TC0PD1LQU89TENGMloPqCotS0zAqwWdGxtbU
 AYtJmkFsAAAA=
X-Change-ID: 20260401-dontcache-5811efd7eaf3
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <msnitzer@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3732; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=W3khz0/FaDX409Tx7kW5G/eq7tLBZqNVTt0R4QEcmc4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpzW3OqVuSS1iD8Mwo5RMtTr77fM7U7mAokbsi5
 OgJEe0DwK2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCac1tzgAKCRAADmhBGVaC
 FTC/EACC/RtmsGbID3jfaAwUx2faSaic4UxAkejxoMPme/+/EXKCuFne4g2GircdkYunzZ3Dp84
 FR9CvgXFybwNdt34x7Cb4kZEtr6Mpu8M/FotZSN1ja3LQh4d+svvL4/8WmF+ZfH97oVFmsdl4U8
 ewj6GfMvH+vRgGUWrFnawi/MnbCwZgTEUqqfXAI+jdec1gAdDd0NHrYk/QATNxTElX4T2eQt9Xv
 TXa6JPgNBQhYGMeX8/xFMUWsb4A/NWURIlbnChKL1r371kHRilrzl8ZftksYyFHnon5qlw0Q4rW
 MK9tn1KOxorZIcyvPsPdxhVhksMKA+S0w6x5+GJ/oFEYHGLh6BEbszXGnTHoKsBAMcsDGLS+y0U
 gLuxSRGhV2WI5Cnb10L0eWS9EknpJ8iuruvLSF1kKBhOQI9f4szdiWOfAzaY5gZAGgXHDZ7PBJn
 3CKl42UKOlzm/D4x4Vdb8Qdkw9oatzqA5B0DrnJFlMQL/+uCr6tsfjfNzgH2vBFIR1z9oMJVZtt
 GvYGgUh45wLltmyRmdc5OaInTf68VN7XFJaD1APvPsZyQYN2OpMol8iSCmADt4GJvMAdrc3lZRp
 5M9qEvrkxoUq+fnpZeAOwLgzl0onerUD3FglU769z/BG9su1LIXJhcXii4XsosUWcfYYCGP6qGS
 hmD+5VZP50aQIBg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E95FF18000B
X-Stat-Signature: aokgifrttqxxj3kyx14i9jdbarosfqe3
X-Rspam-User: 
X-HE-Tag: 1775070678-730708
X-HE-Meta: U2FsdGVkX1+wqO+vHLOKWeGkMLRT18wJES5GArjih2XOcaZ0YAw3n+4hDuZr9dMZ93JnxmpvTYXENN4JmXvgwT64ZBJklA9rkhaM34lHoe++dfZrPbQLvQtbPHFCPXnWfcj6zlF6tqMlYwrAdmx6GFHUQQ5RpQzUxHKjVss/1t3S4vsAyBUcnqOqpz47IJQItKaOU68HctkWlZp2xGHcyBKPdkEbyBQ6OR/vpnLGxC4NKmMiRuRg5gjFNzL5k+MnGHFm6DWO0S7LNWUcVvSKKBCWxEKcWIJRtNzhVcvghDYmMY9kL0UrFRu9ie1GR/OKhqTNgEC9sIheIInSXn1m5m5ouCIhm66Jml5XZqqhAL7/2doru9WerFysFUMSAs4lg4k5aVgzNwX6/jln81d7I+qjgMMvdDkYAB89UUiusxJuBiPiU9kcL7ccc2fSuoJv7bA/ojb1R/ACwkGet1wGsm3fcBNcWlVIQYkQNbLQ9whn1yitOKT5gnC2zVfIpm0EvsnnRASNLjzHSNesZA8iM57XCxMMR3A9XonOELYQhuhge04NExO9LnUon6ni5GfFctT3SynziKLkWswFNdE8hbuI3Ia/3QCY1oS64dR82kr9zDp2HNuOSVyq76rHACnbuGwWveZAEQxNbVfOUplriqC4rYW3RPbX5hySrSRUQ8iItz/AqhhyMXSiSRwetxmda6eRYJw3SMk2eSTKci8iDdGz/9aQT1Cs92UNGGYlotJW+5SDibCfkn/Sh/2rt4pW9HM560bXUaU2zDKH8OiqbaS5wMfkrW7nA1RzL7CAPcruZ9AUhGy/krz2dWt6DS4XOb2mfkd0SVKIFoAbb6b9iYc+uyIEOpZYptJdC0s2LFkRWdm5zKcV6SXmjEaj5S8NUeufHojCUlZPdK6vkZNHSeGZ5tFZxFI1sk5ZvauQWKTYyDUEGshTLhz4pD3JyoK7Lf0N3DrZOFu3+6UIXjV
 3e3WqWKz
 U4Dqy2nbcmuIFPbyDH+GKeJoGk3pAVub+GhHtR048vjaWaQwsNOisbsj0nBG03Qw8CuCfqb4nIKzNfdv9g+jyZqiUudZwl+uOkhzo1zFIPy9uGBOk1GRlGTire/tidafVV2gbPwrkr0Zfv/sMYye052dLuIOkOKEytILIPDNGH6KZ74OdOStrjNqbAtrcauSFhBOCDiqQsJ9AxKcz5/z3prAC1xq7HhkfLFUg2L6SUd6a4q8iSpUkoE2nhgIrVOX65VAWu4+fdcY6yGGsKP44IBCXAZvDVT3AimACjiscAi5SDn6E1N9b1rTz1htSTp1yVqiibjUL+9Zs4xJdcWmllJ9w7Oji4DDWkgq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently, we've added controls that allow nfsd to use different IO modes
for reads and writes. There are currently 3 different settings for each:

- buffered: traditional buffered reads and writes (this is the default)
- dontcache: set the RWF_DONTCACHE flag on the read or write
- direct: use direct I/O

One of my goals for this half of the year was to do some benchmarking of
these different modes with different workloads to see if we can come
up with some guidance about what should be used and when.

I had Claude cook up a set of benchmarks that used fio's libnfs backend
and started testing the different modes. The initial results weren't
terribly surprising, but one thing that really stood out was how badly
RWF_DONTCACHE performed with write-heavy workloads. This turned out to
be the case on a local xfs with io_uring as well as with nfsd.

The nice thing about these new debugfs controls for nfsd is that it
makes it easy to experiement with different IO modes for nfsd. After
testing several different approaches, I think this patchset represents a
fairly clear improvement. The first two patches alleviate the flush
contention when RWF_DONTCACHE is used with heavy write activity.

The last two patches add the performance benchmarking scripts. I don't
expect us to merge those, but I wanted to include them to make it clear
how this was tested.  The results of my testing with all 4 modes
(buffered, direct, patched and unpatched dontcache) along with Claude's
analysis are at the links below:

nfsd results: https://markdownpastebin.com/?id=0eaf694bd54046b584a8572895abcec2
xfs results: https://markdownpastebin.com/?id=96249deb897a401ba32acbce05312dcc

I can also send them inline if people don't want to chase links.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Jeff Layton (4):
      mm: fix IOCB_DONTCACHE write performance with rate-limited writeback
      mm: add atomic flush guard for IOCB_DONTCACHE writeback
      testing: add nfsd-io-bench NFS server benchmark suite
      testing: add dontcache-bench local filesystem benchmark suite

 include/linux/fs.h                                 |   7 +-
 include/linux/pagemap.h                            |   1 +
 mm/filemap.c                                       |  51 ++
 .../dontcache-bench/fio-jobs/lat-reader.fio        |  12 +
 .../dontcache-bench/fio-jobs/multi-write.fio       |   9 +
 .../dontcache-bench/fio-jobs/noisy-writer.fio      |  12 +
 .../testing/dontcache-bench/fio-jobs/rand-read.fio |  13 +
 .../dontcache-bench/fio-jobs/rand-write.fio        |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-read.fio  |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-write.fio |  13 +
 .../dontcache-bench/scripts/parse-results.sh       | 238 +++++++++
 .../dontcache-bench/scripts/run-benchmarks.sh      | 518 ++++++++++++++++++++
 .../testing/nfsd-io-bench/fio-jobs/lat-reader.fio  |  15 +
 .../testing/nfsd-io-bench/fio-jobs/multi-write.fio |  14 +
 .../nfsd-io-bench/fio-jobs/noisy-writer.fio        |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/rand-read.fio |  15 +
 .../testing/nfsd-io-bench/fio-jobs/rand-write.fio  |  15 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-read.fio  |  14 +
 tools/testing/nfsd-io-bench/fio-jobs/seq-write.fio |  14 +
 .../testing/nfsd-io-bench/scripts/parse-results.sh | 238 +++++++++
 .../nfsd-io-bench/scripts/run-benchmarks.sh        | 543 +++++++++++++++++++++
 .../testing/nfsd-io-bench/scripts/setup-server.sh  |  94 ++++
 22 files changed, 1874 insertions(+), 2 deletions(-)
---
base-commit: 9147566d801602c9e7fc7f85e989735735bf38ba
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


