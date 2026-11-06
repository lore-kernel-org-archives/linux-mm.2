Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA90E606D80E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZsQM8du1
Received: by kanga.kvack.org (Postfix)
	id 6BF6A6B05BE; Fri,  6 Nov 2026 08:20:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696F56B05BF; Fri,  6 Nov 2026 08:20:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5869B6B05C0; Fri,  6 Nov 2026 08:20:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDDE6B05BE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:20:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E00E140D37
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:07 +0000 (UTC)
X-FDA: 85404752454.17.6D1A679
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25DBE4000F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:20:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZsQM8du1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTZCBIjpZOspCZhwg+BKx9PwD4UeGBiWTdjVtWLRfNE=;
	b=QmjYeFShpySAV6c6knkRdBnbo7c2pPr7kVpmj4FAJmvAZNmEUyNVOuQcuHDPQNzYArJwrq
	wwNtsAEfsiF9VSBXZmxh/NVsFuYh5YkgFt9oUjShgkcCEXWstPGXP1vGP5o+ZuHu5BToTk
	VlHmXfnpE963nYn6AH3WmpvwgxdxTR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971205;
	b=1P7umTcScEcaRobGAmQ0Ee4PPDTBP9nZ822CWi3gpSw4vCPa+65JWb/q3YAtgkbj9Wt9Si
	/TydlrOJHia4k3qI6tiVB4PhmvIrewiLcAGo0tjdIu4gWtjY7sdgzuaTNArYUEf9NwwAmo
	+EjRPCK2xmDVOgZdJ6WcNI70Q/9IjmM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZsQM8du1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SEovZ4ALBXSWOhtuKK3tlcth4LgwnYMDhPbgNF54x8Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971204; v=1; x=1794576004;
 b=ZsQM8du1un+p13NyVJ1yhVa398SB8wxdZLQ0JQyp1c6X5ODPLHnxJZqvtRCTrx1iU6llGtKE
 7Xp3yGRC03VJqWi9CIvNXW4YucO+qekJmzhNVV2+KxCdstjLOrP+rqHxJ3s/GMjAgX4LRILhr7N
 SpABoT3u/6S3cKTo5soLK5RE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7dc7413b7e7a1b47;
	Fri, 06 Nov 2026 13:20:03 +0000
X-Mizu-Trace-ID: 7dc7413b7e7a1b47
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 4/7] tracing: account ring buffer pages and trace_array metadata to memcg
Date: Fri,  6 Nov 2026 21:18:26 +0800
Message-ID: <20261106131829.3228926-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106131829.3228926-1-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uif1h4decpgabipq3fke1mtkpg5bjafp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25DBE4000F
X-HE-Tag: 1793971204-135617
X-HE-Meta: U2FsdGVkX1+IoyHecpj+o8xWU45z9yuw4ApCTUVDWAA+XO9/+Yeb0nF4sXtZ26UOT0wtLckUqLUC+nOXuA9zO9p3m2exmtoGvkRhboAOqeWz19q4caS1UY8Sri3ceqWEN+B2k7kcCaRQ482VA1ZIO+1EXAs5Aq39CLHJBFxo0PPZMoUzg3GysGzAMBeF+/hPY0R9KCNwMDiDfeb4F5g4yaOvj1qPr992eiBVqsG4bPy3ZL5MYgHQT9Z/j9NO2B+lQofEvQB0pSXIhasFbSPjrPZAAcifE0YojL7X4+YAoEP9Kht5w0Jo5d+i/sjSDEPbEPGQBQceyc9D5Z4VLDOmJ29btwt7UVZYZ8jpgGrNj1HNUBf2ZC1Jl6GrctGpZvtpNM9XkyNoqz4QjtwGjBHViz4nRH5vgt9oRfcpaIxYd6yIfS5VXpmg201AYvg3tNEXOxutNSR5aGWD7ThL0QO441CFGbv5t2/AgnHcpMYva0dNQGY2u23fN6dHYk9/0jvD8cnaCgiqYEGyqZp9KNWykb7b6HHGr8QR0JhcNokD1JcUroP11CO3ALcRoS8rGCxkp45KKo6BoEYmmQI7+S5lGCG7KTijrDSFahAEPJzUR+KjfFylg7hAcnZLcRj//wXSq2GJ4LZspHYiLMo9HaWZQRaYzeyvBrb7Iw79wqjkQl35ydNT8Tnf2BqIqFPOD/B5TraDUPzwc3BOM4KQsXAJeXwyUOxNqHtn8N4DYVtllhrF97Ma5lPG7s0o+C6q5htRbyuj7IqT/Ystfl+csEwICdh3w14SWdCZStBNX5WXOUdRx5O17+51Hs6pFUu5Vkb+brBeQFZLUyE7izyngZgOir8aDuITVYGTDLr+WLFrosRHhhIKYhsSaQ+y4VBlCbwVzrUWy1ohJs6uC+nYtABbjn+aaw1ubrU498vzYpn3Ek2Aot178tWABY3kq8WH2PJwK2nVyLNCVJGAWbl8FSA
 pNd3h4vs
 GJ5OdQX1pQVPppLLrT+RJgVUdkKqKXILyDlqIY6YkxwRv67LjoDqFrLJm6e5oBDekAvmlVyo+OI629X3/gqpIRk3VICC3qpkwMFxNSqcgMMyMEtL+pLKvQxHQ6qURB+ReNiiZ3noWCi0ZKgjMFhINf8E5+LP/MNFLiTSvjcYt0YAU4QSk7YeHzQfEDIgmqXGpgEhJzzUbb6GQBrei+bxZkZRwfHuLMKA3SY6PJmkFbP1Lx2259g6OJIf7QMQvDrWDiaNwRlhoHul9iRU64ziUAF8HYRBpI/wrflaof3WTJ2R53lcSIblpCQIZcf4S0mPv2XLZfIGwma9LZvNxPKzob8Ni63asjniUPlvM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

Creating an instance immediately allocates two full sets of per-cpu
ring buffers, array buffer plus snapshot, about 1.375MB per cpu per set
on the default config, plus the trace_array and its name.  None of it
is charged: neither trace.c nor ring_buffer.c passes __GFP_ACCOUNT,
while user_events in the same directory accounts everything it
allocates.

Instance creation is currently gated by tracefs file permissions
alone, so a
rootful container with the host tracefs bound in can create instances
until the host runs out of memory.  Charge the ring buffer pages and
the trace_array metadata to the creating cgroup.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 kernel/trace/ring_buffer.c | 8 +++++++-
 kernel/trace/trace.c       | 6 +++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1fd28a72e6ee..676c059c112c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
 	 * gracefully without invoking oom-killer and the system is not
 	 * destabilized.
 	 */
-	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
+	/*
+	 * The subbuffers are charged to the memcg of whoever caused the
+	 * allocation: the creator of a trace instance, or root at boot for
+	 * the global trace.
+	 */
+	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
+		  __GFP_ACCOUNT;
 
 	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
 	if (!page)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e8c4efa8107b..04b60b9cc4f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8693,11 +8693,11 @@ trace_array_create_systems(const char *name, const char *systems,
 	int ret;
 
 	ret = -ENOMEM;
-	tr = kzalloc_obj(*tr);
+	tr = kzalloc_obj(*tr, GFP_KERNEL_ACCOUNT);
 	if (!tr)
 		return ERR_PTR(ret);
 
-	tr->name = kstrdup(name, GFP_KERNEL);
+	tr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
 	if (!tr->name)
 		goto out_free_tr;
 
@@ -8708,7 +8708,7 @@ trace_array_create_systems(const char *name, const char *systems,
 		goto out_free_tr;
 
 	if (systems) {
-		tr->system_names = kstrdup_const(systems, GFP_KERNEL);
+		tr->system_names = kstrdup_const(systems, GFP_KERNEL_ACCOUNT);
 		if (!tr->system_names)
 			goto out_free_tr;
 	}
-- 
2.43.0


