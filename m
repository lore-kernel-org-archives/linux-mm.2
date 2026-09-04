Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EE4C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8308C6B00A0; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C636B00A1; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C5C6B00A2; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0A416B00A0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EE3BA2CCB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
X-FDA: 85176560322.29.253B697
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id D568440007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=cW6VJOSA;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVIkjcqq74IZZNU1n5Q5hTuCbDzAa7ExJXxmdI4hdXI=;
	b=lDQvmcqlHOVR0qVwq5p1uQTmP4F0A1tkXrMwdNO3jsiQSPPx/V1DNK4GUtCS3PTLjdRZBM
	0RGKo3WDi3EzUsv7+yYP737PDdfQLM/sbUcPE2RdGtvaVkQ8A/z1aeR7VzaFIGopH0C9sw
	P00rDVX6RToZzP3YUdju2BdT4phzkUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538059;
	b=SVEofkC97VOpzLZZjVWQ9h1ouEy/76x7nER91TbEb9UNBz+Rmc/NH2bu2HiPxA3tb2tAr+
	BXb/I0S9x+S9c7uLggnMXxoOR6mGhuTu8FCnusV18lnTMBfGYPhrKX1X0NJXPX4zRrcSem
	RfI/N7Q+og0+jHcg4eiGGSpSMQJTZ3k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=cW6VJOSA;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538058;
	bh=MVIkjcqq74IZZNU1n5Q5hTuCbDzAa7ExJXxmdI4hdXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cW6VJOSAfBFhelVHcj0Vu6YZwxjtUoz4A2tuXiPyDVOHLWBwEqJtNtQA9QKYKy4C2
	 opyQa4xh2f13h5yEhqS51TqSVAvLtPsYWy64nAE98WYZfD3SNGxyNA4D5+LqsKNhBP
	 prsg2XS1x/SyowWHVR+RJd+4SVB2S1+GggUl0Sw0rq/KbLWFYGZCvsPRU6lM79drQV
	 NH1mpUi6NK9AoaLU0G4fmLzSUg47Wor4KkqCleAMsyR5PT1DhykYbDJ+m2xTltXYVd
	 +kKKAqdpbPHbCapIgqGXhiWdwPSMvPqKueNcqASNM4+LijddQ9IXZAUGJIX0zmR2u7
	 HDvUUqt5yIiww==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zd754SzWfd;
	Fri, 04 Sep 2026 12:07:37 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v22 05/10] init: move percpu_counter_tree_subsystem_init() earlier in boot
Date: Fri,  4 Sep 2026 12:07:17 -0400
Message-ID: <20260904160734.23445-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D568440007
X-Stat-Signature: bwg6fp7qohhpi4y3itpnjri5fieijf9n
X-HE-Tag: 1788538059-686655
X-HE-Meta: U2FsdGVkX18JU0AFxLOxYQlUCKzbBj1jq8stb9mbSITX2SghdBMQdlAriFDvGDtXCNr8wtE/cxdlGxZ7YRbZWxIPXLdy3Cp8SbHRDm4qfzs3VqXTYHG9rqT6YG3Km20QgDuBrTQM0smaGP2cXOE+07AYsThFqpaC/UkkXzXBfW3rUVbZDuFKQr1+m8DL5vTY2dTWLVbdWnsiXRjrWIpR51D/uSSN3dtuW3plQ/k+/KItF/k5A8yQRMy4X/FTWWulanJJDgAyNMBHQMIcHJUjnBfmQLscrTzHVuHhfO8Pjvy4/BBVg8h7YIyEL25BopSF/a7p9egtcWE6yzcT7WJccC980F7nsUDDNYjvPx3UpzfgiX4M9uNLKvVp/T8mlRoC0JrU3I6okOV/hYiblb3O+pyTE25xVOPdZID3p0uwou891tzUnD27/HmrBu+6uMlqQds2ZiJ6qopLabk8joUUDV6D33d9K51khit/y+XNkHzwO1Cij0is2wJmYyStQqB/B9IyKYGtHsAJdLx4KZ8HeW7X769Iuj3kbUorItjQ0G4IgLN1jIIu/DryZKh3MHzGa1w86FG0p+7++Skuq74toXy8rlYwoDY3ye/Qq4XJJm1Ldnu3ASjBT2FchHo4VfxTa35y+tGVmJpNdQ/hF34k6zkgtBY78W5Wq325Kf6i8qi+aKfJbgzPO4Iwu/DtdxrO/s9dOEh1OcAtSUJWmlyPN74YvE1hn6TFHyaKgkpE2qOsqHZ4GThhvPWcjeURh4YD97UOZCV2aaLExImnTt3HpaXalPDCSN5+Hl4E+mLD/TVzkqF9Jl5v6Kn0XSgQ7OjR63KCkGvbYjUI07BlyTsnhXcCs00dPC8no3UsTEIz7VesOtljLu4zT+/6C6kt0RSjAnL4/RlgYdPNaJor/UKRlY8Xxs1bC/FKBBU35/22vCJydot5MxqAA7m7+RUVBDkeQOJr8D1O4mn7lrwPbJz
 X+1G3LOR
 ZQ8wQbXBerQVsKodBU2p+mXOOrVu6YCw3PO2K9GM0vEf63xa0cy7CmPSf1XyTsOAfYkkTbmCktShwiWiooJBTO9RT0ikRZg+3MmLqHxmurTPNNPxVhUL1Gn591VZTAbnW69oAaZr6drQQDynm6CIeLNnZM0b80FgSLUFOo9rxN0m+aFVfK0Z57n6+BWdcQ59JLa7hJESPDthbjJ3x/o6WnpqFiXAVgKO5rIRJjzOyuyA6l9ZfRPLgHck4TL6OKjdXsDK58RvDMIlP3yVyfv+9jnBOxaEF4rSm9XyAGR9T7jKj8cjgYLnpOdl6U7f+GNggLFYqz0s3W50noGOrk4K79sABc5K9hO0H7LoFcFBVsguSJX3E4lL8zUtDjDnh0PBcTkXhm4ITTkfGnCO52QY8DSNZ/xHCznJWhxyQbfbfVMkkUq4/yFhrmKsAtks+mFUaTkLHD9XiiBHZSSqwnQx3Z3Dh4TmsmBiiEW9Dr0sjDE5UspqU9YxTeJqSQb1jzrsbljVfjys6D1Gzlzrm0BdmNOHmrUxNNlNfnE9KW6u0yM84czm/5Sk4u1pBekahITGENsYt7Fs0Lrz7jwM0bQyI8DPwDc9d49/Efkcv3VZXtYfrpb07TzAg0UUdd39+q2rfY8kVIXYQMHeEv5KjvbvB2eNvwbJFt29DZ/x8YwxTQMD2NCkc4PcJCHPDli+RwLiUHxkL66MvYGWAT44u+PW1P8Uvk6c0tu1e30O9k9+0b2bGZHLKbrrxcbNTTuNzNtx+5n5x1Gx602dbR2Wav5FhZJcXV76LXf3lNCUqgmgSF+HWJZ1jctaVgksv7iy7x9mEm+JlBjbWo+scIv5uqmzerRW38eShnzVIiKKtYDjbVKX64dlTlsRGOR7PC1+SxU6a6VhLAndGWXusgTuUdbNWyAvA9U7c32kdQYoFHqOSqgA4gwkXxHlQgCNx/SDz1/NwI/2Z69/Xpqto6Yf3PghB5IBVH+NZ
 NFOs0hHa
 zxCIZF0wFxsJf1eM+ZsIn0aE+5PDcOz3eQrI18ekFPaiZTQRqpqd6SMheOH7xvTe0LzFjZlDBXGhFVN5UmFROJ81KIfkA3xSHnK6VrOvIa1kLO+LDEMbwKRm8uR+wziG0MyG57YhCgwObAAPEyIpUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move percpu_counter_tree_subsystem_init() from after trap_init() to
immediately after setup_nr_cpu_ids() in start_kernel().

The function's only dependency is nr_cpu_ids: it calls
get_count_order(nr_cpu_ids), indexes into a const configuration table,
and performs arithmetic to derive accuracy parameters. It requires no
memory allocator, percpu areas, or other infrastructure.

Initialize the subsystem as soon as its dependency is available rather
than deferring until later in the boot sequence. This ensures
percpu_counter_tree_items_size() returns the correct value well before
its first use in mm_cache_init().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index eda2170bb21f..845cb57e9096 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1011,6 +1011,7 @@ void start_kernel(void)
 	setup_boot_config();
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
+	percpu_counter_tree_subsystem_init();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	early_numa_node_init();
@@ -1042,7 +1043,6 @@ void start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
-	percpu_counter_tree_subsystem_init();
 	mm_core_init();
 	maple_tree_init();
 	poking_init();
-- 
2.43.0


