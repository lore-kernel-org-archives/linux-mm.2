Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F949CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60DD86B00E2; Thu, 25 Jun 2026 20:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596EF6B00E4; Thu, 25 Jun 2026 20:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45ED76B00E5; Thu, 25 Jun 2026 20:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 186616B00E2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E3C18D1A5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:07 +0000 (UTC)
X-FDA: 84920148894.26.841BF11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 07D9140002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZ+BQUVa;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433026;
	b=8o+KwcKxOrHOFIbnAHbexayuo5qL8JbTWFtHxjDQ6sxcf5UyGOsqVPQ0PLUbymu4uZJxgc
	dFDHoNEzmSIfF5GV04wuEWPMJl8Q5LYznZruViBrAhSAEChdgggqnv5+eD0a/ldD9VLaCQ
	2oIeZE9ziFXbT2Sr0nhvflx2eXXswgA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61iW0clYSHE8gzHIMRcuF9jxdl/Em5VRtXAIIrwedXw=;
	b=TIGP/LbR4rKcolswOINzYPcyVqSQkcrugk9kRsQz2vqyq/UkS9eCii1fiZbmHyMzaKVyt1
	9WrfLd+O5wn9GvU9/GgGKmAYIFU0S5Kmrh7ymQiANmY2djW9pYNFByxcTO/iYvMOJW8uB1
	PdGR/B/TOSx+d9UV+hUclqpJ9ZSk6U4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZ+BQUVa;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 684266020F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B001F00A3A;
	Fri, 26 Jun 2026 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433025;
	bh=61iW0clYSHE8gzHIMRcuF9jxdl/Em5VRtXAIIrwedXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ+BQUVamR1Vt07epvnrnuCcZuBm2nX2Gxts7PodxZ61o9F3V4cP7IVBGLuv8W1op
	 0SJLOFRESTADPdWubbgrymXNz7UfGCNQTTAfo/Vo1xDKIFvQCsGqMz4ryg/rGxkEFE
	 BMwqNBPu3ysg5rCCOPT/v1nns0z4C51mSJWZy3bZ7qO+bjMIWqyTr5lCXz2ghd4Rzm
	 lEaeYsa6ZpdK/gclljobd1LIkO7OENaVEnavKIi6H/+uu3BBnxaXwPmWr/SG9y9+by
	 iHrEbRxlB3NtCIkCsiddKrAxqb1DoAjSTuEJfVUPFJhjADPVJbd/vV5EUOzqIVNN4M
	 xUEiascwFyCcg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 04/11] selftests/damon/sysfs.sh: test multiple probe dirs creation
Date: Thu, 25 Jun 2026 17:16:35 -0700
Message-ID: <20260626001644.85825-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07D9140002
X-Rspam-User: 
X-Stat-Signature: kd564fujyxfcwp1pcxrrcnzi5hah4973
X-HE-Tag: 1782433025-382802
X-HE-Meta: U2FsdGVkX1+WXXF5BnIrQQ5Utjr1+VckQqQP+2elGI5B3Khz7YkmaCPPnzL1AlfWki88IgzDfqmcnrNTxfZ+ZYVPWr9EsHTVGHPORmQQkzJzRzhG3dGXdYSPT0L6kxYQQHuBBGkk/GZi0WW+1sfhFnU9Q/s5no2uth9Dfi4HcYdlVAU7RyhtUoUo2QQz9GCb50AcXe6GcpPYpiVgY5RiWc1WGK8DSdE4Gmj7uKAc9RvWkpcYM2RqC3ozlela0YZ10j1EmnAu4rWfllkTbZ4fmxOcJV7YVw7Qm4smTpnT7/BqoSCatfwa+TmoqoWqCld4wNJfy57NkQktCsXnRNuKX3UaISgTr8bRd6MtvFi+cnxLQOIeDne8Rx7NoMJY68MNrd1zk5Afqktl8An0AVjhaS4fa1mfTpBGc9CERP6mRIgHW1YnsyjaZuK5pgQadTAJmH2RxNQu4pgIWrtw0QrNP7sgnDhDZ35/ElSYmqCGeFXwwb+5yXETssKknXTPThcpOQP7O+pFjeFfbIrBziRJk7fQPge5z0lKe1HnSd3OkH/COFXbAsnwSTpXhxLiPwIqhAu9lShFFnfndkELAmZcBLTu3I99w2eUb+aY/Ao0EntsWDpREQxobIOcSkYYrvd/pCPAGdB2YnNgdDhsZVV0WhHGQgD9AxDMNPjgo+u55RlHRqwoyxQYnXoO9NpgQ9gZTt19R+4zsDZBE8xZ7ZkLZRs+4k2uagcDCtIqGVxt7NdlDnfZ3JkbPkm81I0IpPedCrfUTtAaXul8HiReKvUX4Vanv4BExnqG/Rz6CvsTDaGtYvJUp7yNIW+1YF3/RYsG9clnzqH/nKYUcumCgR/lIGFvEGjnW7k2R0CS69xuj2s2kuHm3H1ZoDjhNVYv+KdG4AL0kwtwq9DnaAziiLw/Xh0aNYy9tfwvMAkAUyqzgpk50ScIu20bpqmQ2w65P0XRMfDulNNf9ygMEYRk186
 ErxHnx3e
 Ygs+V9nmPrd4PU44AC4T0B6B/57sOJA6a8RWFxWTXt9VDKFp3kJtM3+wxMlGY3Jx0b0uKKqOtSnhgaqmfYZZyVb2nor0nQFYsRSparJzzKFssiiQWS+sD6q06EDmQRXmskHKf/yCJa8eY8jS+0lEffK1+8SjF0GkpJHTK8PRva8FStNP6VyP5lBYqIPWSpDWq3gIUAOIURpIpbzo6o9YoTQ4Owghpp9GJRIPBFYY5HtCLenkfT4asAxguJLTAB3yK6UAo/QEhIG1EB5CCvjJora62m9tFNmwSEkFwrzQXzIaKk4CU9CV7n18Uuqu2g4jibLfAi2SI2RSGUu5u9g4UmtkwGsryQeOAd4I3Qbbod9sudyZuORwplxoXJQLVAj846FDZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs essential file operations test (sysfs.sh) was extended to
test DAMON probes sysfs directory, by commit 14885da09b0f
("selftests/damon/sysfs.sh: test probes dir").  Unlike other DAMON sysfs
files, it is testing only a single directory case.  Extend it for
multiple directories.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78f4badb5bebb..0f2ef462a6b6a 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -346,8 +346,13 @@ test_probes()
 	ensure_write_succ "$probes_dir/nr_probes" "1" "valid input"
 	test_probe "$probes_dir/0"
 
+	ensure_write_succ "$probes_dir/nr_probes" "2" "valid input"
+	test_probe "$probes_dir/0"
+	test_probe "$probes_dir/1"
+
 	ensure_write_succ "$probes_dir/nr_probes" "0" "valid input"
 	ensure_dir "$probes_dir/0" "not_exist"
+	ensure_dir "$probes_dir/1" "not_exist"
 }
 
 test_monitoring_attrs()
-- 
2.47.3

