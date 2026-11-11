Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B79E606EDB3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qCInZunJ
Received: by kanga.kvack.org (Postfix)
	id 6C2C66B05B0; Wed, 11 Nov 2026 01:57:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D866B05B1; Wed, 11 Nov 2026 01:57:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C266B05CF; Wed, 11 Nov 2026 01:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 393FB6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:57:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34BA240204
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:57:19 +0000 (UTC)
X-FDA: 85421931798.21.FF156FB
Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id DBE76160004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:57:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qCInZunJ;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794380237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R0WtzFK0QV9dTe74u2VAXpk+0dxVm5YnUHawi9+Z7JE=;
	b=8Ykx4RmvgQKojJoBWwxwsyaDVKu56bo7t7tFjvuK/XPdOalbCQl4zwEf3+Y85cF6HooQlj
	oY7DnPt6JDOmTb2g3aUyEDG0OCXfCdH10k6fG/2akFj+Jp+iCo3LaYqv1hu+p7a83+kbdi
	h/pgUMxGIp3wNgmInvmlLXMTRckacbc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qCInZunJ;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794380237;
	b=NaPLuziF7dqYtKAmOP7KFjDlBlq0YQz1pBRylWQlOHCNi0sH/WevequoUhFIQr+qPRTGsO
	RX5UKoABtBQwtjcPb2S/oC11aAO++9qJD4c3WkF7HOYwFvCB8BL+6fF/uKq92iOJAYdKUJ
	tr0FuT+djt95MSIVe+86nUAebPYld3w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OvQTYxYMkTqry3acjf+Vcm67A7weKjsIyvcUqj9sVD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794380232; v=1; x=1794985032;
 b=qCInZunJ91dT4NW8VshVhxlnxfpaB6Hkf+dDLxOpjaRZt/31gYcz6sSBwNcSUmQ5y/ff8x6Q
 nT/J9um+GC4isFsbDp81LXxNnxkAdLk2YHI+oWBdUp57up3HqHbi7coSwd3YVdWPT9piW06xUWD
 iJYi5yGxGyzBvVI56FkdbVzQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4febb5d57c92655e;
	Wed, 11 Nov 2026 06:57:12 +0000
X-Mizu-Trace-ID: 4febb5d57c92655e
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 11 Nov 2026 14:56:57 +0800
Subject: [PATCH] mm/bpf: Add bpf_mem_cgroup_memory_events_local() kfunc
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-for-bpf_memctl-1111-v1-1-8b56784d9e5a@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMSwqAIBRFtxJvnGAWDtpKRKQ+60U/1CKI9p7ln
 Z0L59zg0RF6qLMbHJ7kaVsjFHkGeuzXARmZyCC4kEUcs5tjarfdgosOM0tfqaTRgle8NxDN3aG
 l6682bWJ/qAl1+FLwPC+EilzPdwAAAA==
X-Change-ID: 20261111-for-bpf_memctl-1111-f3b6dc2040ad
To: Roman Gushchin <roman.gushchin@linux.dev>, 
 JP Kobryn <jp.kobryn@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: hongfu.li@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794380225; l=2008;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=44vpfizS0VlosmJiTV7G7pfGCN7/3RT3A4dbxD9R4JY=;
 b=6gHInHLqYiXWrXrNKs1ifLi/E8r+1T4xwxFAc+85WJ6yuMI6cmgl7yLnbs+kBxc10cJVZZjFA
 R4BosQQkj/ZDPQyCe7D5Lff1qre8GMIERQTTAFcD3xRCzqBI3Xvd474
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: ksj4nbp8gd77t561w5j93itoa69zfb7h
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DBE76160004
X-HE-Tag: 1794380236-797911
X-HE-Meta: U2FsdGVkX193CvAJWdqo5CPp5fkyGUvqEe4ZDu6utpV/c5X5ABSR2ZwpUdWfWy/FK7pwFli9js0EwtSmfz0UASCqhSLeUs5w06qjLjfDLDEjZPEz0QwkWZb0X0Nq4XJqdvobrHh/MPYm9puVioN5tk/tUxplPk1CDKPsTEcPhqKOGf7Mg/GcibaSTdSbKfN/EjENB2WG6Otw7YwLpRALKkVnoUvwLPrqplT+HQvbXAJflwh4QBmuDvkkNV/04FBzNaH1yrkhokXV2sj1pP7cbY2AZtpBDmqbCBGoA/GS/XCwTRRLF+mpsyJA2d9JORr1IR06p2LdQZ6SbzNpvnjq5Ymr3wQPjKjwkM2F+JJZQ3DbsbR9CHwremTecRw6lRy6LAvK0HYEu/y2BYXHFgdLewS7kprPS2Nz/I9Ou6FRhts5cxPnbqOMxa9RDIWNU+5vN3OGwQ53I6Zcvm51srJHRq80ZcB+EMN+7+Vp39MSSAc2r8mQnglOheLfxWKko5tFXu7PEq8NgNboYCXys1aKEeaA9MoH+j6s154E5S+RUTf3Nh8jdfCDCihtiCBKdtU9Kj3vSVGX9FpYGNrFBrtrIkIl5o0m4bBepdjg8O+/XlZfRhH3KlW91RS+iGDoCvng4kkN2DePCMy6BH9D8jYNXRdE0774yfaYbqnDoJzxREIl0G/LhimZHARYL+mwGsnIVJ1FytSYtmJI0wVgxUwG7tK4lxrNX7XI8NiVCVE+015HsSW7xeiThgTCGGX68ALrRFiBZYKh9en7Z+V2QD7atuwcYfQsyWDCeHIdgh7S3na5Jjho8nYvAlkqZ3pQKJndOiFiyeNSAnuY+YC+XynYYxeq851q6YbRi+XnpqW6MGz8ujW8FHSalnqeiRzDyE6tXzKusWECesWxmxOATRYENOT5orQQG9lwMDfW32ps617XHMIFaMluOz2kifewMzrbZ7Ct2UhriEFcc4DnwmU
 fjifKPt9
 Fx33OOQd9QGHgQ+LaYLpcRedpKjLwLmo/bNsPv0efryGkZaV4Ld+xmDsYAOFn2v1/pqwKS81Et8I7Pb2uaM/0QiJy21P47OYJIr+QVCOn18EL4301nEJiWoU8s9u9LDUFXF+N0i6Ap2Hp6forFEOapZuPDpxKVPLbTNmiDqPMeXslznMOyJFfmtIBi4XFJZRsJ9YNFKiMTDDH1VGtECG5MlCvzKmG4xedZ47XteVdeMaC/B5NcymUtG0Ffg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

memory.events counts events for the memory cgroup and all its
ancestors, so it cannot tell which cgroup in a subtree triggered an
event. memory.events.local counts only the events of the cgroup
itself.

Expose the local counters to BPF programs with a kfunc, so that a
policy can attribute events to a specific cgroup instead of only
seeing the aggregate of the subtree.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/bpf_memcontrol.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..826f711718db 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -133,6 +133,23 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
 	return atomic_long_read(&memcg->memory_events[event]);
 }
 
+/**
+ * bpf_mem_cgroup_memory_events_local - Read memory cgroup's local memory event
+ * @memcg: memory cgroup
+ * @event: memory event id
+ *
+ * Return: The current value of the local memory event counter.
+ */
+__bpf_kfunc unsigned long
+bpf_mem_cgroup_memory_events_local(struct mem_cgroup *memcg,
+				   enum memcg_memory_event event)
+{
+	if (unlikely(event >= MEMCG_NR_MEMORY_EVENTS))
+		return (unsigned long)-1;
+
+	return atomic_long_read(&memcg->memory_events_local[event]);
+}
+
 /**
  * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
  * @memcg: memory cgroup
@@ -215,6 +232,7 @@ BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
 BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events_local)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)

---
base-commit: 2c5dafa7f289d760f4492260b0988029aab478b0
change-id: 20261111-for-bpf_memctl-1111-f3b6dc2040ad

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


