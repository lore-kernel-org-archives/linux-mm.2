Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373CAD25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4FE6B0088; Mon, 26 Jan 2026 21:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D1C6B00AE; Mon, 26 Jan 2026 21:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0B26B00B0; Mon, 26 Jan 2026 21:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 746CF6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4607D8C8B4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:23 +0000 (UTC)
X-FDA: 84376202526.09.2DEA30D
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E764C000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W4NnxCpR;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzpBZDmAb1p4WP9vTC/OiXnbOKBtuGA4TcHKnC3OdoY=;
	b=8Rt0wQxEOJp564GMX0btM73rclhAHLhS1vSYE6GWw9aVLBkwinsCsaH1eodgqsr3HOf4X9
	61anXepCF0MTNnF9mzkOovkd6A29ehGqnL3CJDGsDvU9F4lyngI7d98Y6HS91xv9M52uWS
	NkpJO3yUOno68yxYw1dPSBBhDE/zulA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W4NnxCpR;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481921; a=rsa-sha256;
	cv=none;
	b=Z9mdgVHFaOYvecXrrdJdACunrXQCRVG7P9bata3EsQYxOGcKt2ENZzKjPxSC1sxyKYkCzF
	5RAb7Biwz+8ILGVTm2hcI3KFNb8ybmgAgMxEP8jZlwqqPsA7weccejH4XyUHY2LckSOb1z
	CZWXzjhazuUY0/8+VrjwswpjRipozys=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzpBZDmAb1p4WP9vTC/OiXnbOKBtuGA4TcHKnC3OdoY=;
	b=W4NnxCpR+zzlLvZAm2ipOemGZT10gSpKlvevrGrARxYlDRfCjKQrMfzBmHj0q3VNQ8I6eq
	RyhTFtiNlV5tlocFaPiWBYGbgzq3OSGTzjjcZFXXYLRt6vCAR5O0o5/qQ0xha7iYrNVbl/
	kQdIRbLHdk8Md7JFLfOgvea/HJN3zWE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 15/17] bpf: allow calling bpf_out_of_memory() from a PSI tracepoint
Date: Mon, 26 Jan 2026 18:44:18 -0800
Message-ID: <20260127024421.494929-16-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E764C000A
X-Stat-Signature: sa4nzzygypzio6msf7trarw16tp9nj7f
X-Rspam-User: 
X-HE-Tag: 1769481921-961090
X-HE-Meta: U2FsdGVkX19gaM1yeOnhed/EvQWRmGzVrALiTALCYvxP9SoK9aWZqcAlX/Dm76Ge5y7szTRDkAFYxJhpY28QU+AzI3z37KTpdJFSKpcy9mM7e1OS+uuXEJM6wF3AU39LuPet5mVCSbcCGnrgUq8hx68yBlSfvUOT2wlruJn3Sk2Z4iZ3hN3X33aZtKQizQBe5PSLornVvfeS3TOk5rMPzBAbei2lVz4mO9Pdns3bNLcjKfE0hY7MKACAdse2kdQXNd71qVBLNKqRJDQmvbius+0bZei1NcetB0kv6PLQxpnG5OvtoI11KP6H8IS8hMZbir9fKD4ygYak7PNeomWlDZ23wGwVO8FzZKIgP8247ncN4ipw+GXNHfT6fdpYyIho3crlLKn/5iLmqXH1nnZh/V24G+zTTlNqJFUSa3O7/rdSDeqZrR9gxyS7f56A9UpAlPtE+r8NacFefAI/3NfpAFv1JAvD61rD+4F40oZKHtWwBbdt+3JGNrZfZuGCQCEAzr6AfXmgsjvWO01AoRX5yKwX7s0aRuk4LyE55Pi2i62LwZPUKL/tVWQFesLBjCJO+lqDcTWe+GWn2dWktW6HIqe60stOiltAI0OPFvT37RntfGqCWheKeCR4SeGmoXEc/28N9UDhNU73WhKdrBwkVJGUgL19T6eCfsKl9ae4cFkkhOhHUA5eC2wXKrXiAbOZmkZsqQgshlA4EvF+hBEqg9WEcaYV0AUx0pjf28nyLk6eq2d7fw8UTnFMt6Qxe2c0ubMCcqDGRHtxpxlzC26mApbzD9OS+zsO3KUX6vU2zkoQfob2FAxic/VXudV+LeJNc4kbDJm9rJRpZNOPTqhw3ySvawX/5qgEtpLokJcn2MS1B9dC3HTgt9HgFTg4AnG/1KBEXEyrk24pwrl3cCq+1VEpSYXl+5VnDSzu0hjFEXL0YFAwGwdfakcOWKXtuixfy1gjBbYN7V1Q1BXw8e8
 CvGgQjp5
 FojwTxpSUXzJtkom1IkYPgRPpxVs+NULKkZeWrCMG1g1FDTqbZxHEZS7xdXoQky6XFIDCsPys7MNQqTiSpdx4+tb+ILfIRfxqw4uoqDWpzWgLJ/OduQjzGYAEzOv0wGVET6L2RIY1YPvz+CD86f239Jb/UKVOemQ5OpZSW6wHacv44h18dP9g6yUDYrA47tJP1Qlx3k7ugg3RO5aye7hcuKOfDbohkw9jms3sbiT4Q2kwJA5xmaPJBUuzqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow calling bpf_out_of_memory() from a PSI tracepoint to enable
PSI-based OOM killer policies.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/oom_kill.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 53f9f9674658..276cf8a34449 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1421,6 +1421,13 @@ BTF_KFUNCS_START(bpf_declare_oom_kfuncs)
 BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE)
 BTF_KFUNCS_END(bpf_declare_oom_kfuncs)
 
+BTF_ID_LIST(bpf_oom_trace_ids)
+#ifdef CONFIG_PSI
+BTF_ID(typedef, btf_trace_psi_avgs_work)
+#else
+BTF_ID_UNUSED
+#endif
+
 static int bpf_declare_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
 {
 	if (!btf_id_set8_contains(&bpf_declare_oom_kfuncs, kfunc_id))
@@ -1430,7 +1437,8 @@ static int bpf_declare_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_i
 	    prog->aux->attach_btf_id == bpf_oom_ops_ids[0])
 		return -EACCES;
 
-	if (prog->type == BPF_PROG_TYPE_TRACING)
+	if (prog->type == BPF_PROG_TYPE_TRACING &&
+	    prog->aux->attach_btf_id != bpf_oom_trace_ids[0])
 		return -EACCES;
 
 	return 0;
-- 
2.52.0


