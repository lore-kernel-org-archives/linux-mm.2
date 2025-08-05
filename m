Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E019C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEC16B0093; Tue,  5 Aug 2025 02:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6976B0096; Tue,  5 Aug 2025 02:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE39C6B0098; Tue,  5 Aug 2025 02:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2D66B0093
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:50:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BBC5160B36
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:50:02 +0000 (UTC)
X-FDA: 83741779044.14.0469E26
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3208F40006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:49:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="997wEMd/";
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf17.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754376600; a=rsa-sha256;
	cv=none;
	b=rvxavLEJ1stOtLF/l7ZJ2J1jPnDfiM0eUeUG5GpThD7H2MIBUk8qX6mvnpSf1pydIrcib3
	PS8tFQob30PSnfbWER63PczpQsZGbtsrSTqsKkXB01tDiAmYtGwZZaVtIElc3SVuI7PA0f
	nqo0bXkjvKnKUcdgWGm+O8s2GfV/pY0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="997wEMd/";
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf17.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754376600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3YyntHiLqkFTMznGicglNGAVD8aH+6NcVnSLXy6N7JQ=;
	b=QJsdgmoyc/kwVAFAeVLVAMs7r1NhlmBOPNpC7ANCgFAfXlHL6PxfhUI5HgJ8V1NcfNeapV
	u0CE8lFbK1TrpRYC2aOR7wNn9s/QVAcmcx7sTp8S5Djl68EsMPEWhTEuB/65kkGoEsj74H
	jZpZ23luBSDWA11qG2ywcOarB7vWaEk=
DKIM-Signature: a=rsa-sha256; t=1754376595; x=1754981395; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=3YyntHiLqkFTMznGicglNGAVD8aH+6NcVnSLXy6N7JQ=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Transfer-Encoding;
   b=997wEMd/zggrxvDleB60R5dGg49bH6E07bd46h3avriRN8sGEODGLeFYm6CJg1FHDefRSh8Q9m6xlMrhEr51PAdJwwOsHL2Q9HZxnTZSsSMCmdac5+cBOztGkJel8UGvYgEdu8Rk6DLwrZC4Ip68URqAZXoSNOzm6Ei6IINTEM4=
Received: from osgiliath.superhosting.cz ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508050849538632;
        Tue, 05 Aug 2025 08:49:53 +0200
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>,
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Date: Tue,  5 Aug 2025 08:44:29 +0200
Message-ID: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002111.6891A98E.0072,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: 3208F40006
X-Stat-Signature: see1ne79w4icnhbh4qu5ff7nuxxzsqhn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754376599-701017
X-HE-Meta: U2FsdGVkX1+Tf1AXcuYOnyAI57HTsTEbv6CUbfjRswcdQrCrE2C3MFNOZCeWmix+IuyT3eO4dYr7tzOdZsV7/WV0XJBiMu3kH5QnGK/IpkTYpLcLZ225dL4ouzexuYhDCMUfvc5alraQGH0dEYJ3pyb66vEZc5WxS5BnvNoPqtxeuk91WtFmDUpEZXRuYuP2LbW5cwqw6x8vnHyAb46wQYd9VfBktxGBbgHUFm/wtBcJW7eOeOoqUexEyHptf3UpS7EgtaSElfjrbgGAezPsy5obs5gaylkBthVwLl7v+w/KRFQByorW/+Ntby0/bMhM7bg/5asjoW+bJji97RuE+MsvZ+gnzVaI1odjDGIgX+ExktPJHrHBoRG3YdYFu7QMcRaJO1hIWQVjont/l6tDa+J5y2TfLoIr/2dPV5SCtVYSlEdBslOkgGTXBhi/9vQjcoZI7HNXch9Q+zSsDNgBc9MHCWpJZ1spRYhAZ/rJ7A/7uWx84qOEZFrQ80y/Iur2A9Ef5FynZj0DlJikDMj5wIGGs0QJcwriZ/kuZZTc2dNsXAMo/lyM0dgd3gRFosz7xihCpmSYwrz7adDMIOx8xRdBXYR/65Cc6yL9TJwx+8iDA9zli77VvPy2aT0agXqHBqFV9Eh/ZRqdlTMFnlYBynUlKZFLZbG5vb8k+AIC5QrybO614a3Kyvfy0H5NZFRpQCx3d72I46EBts4rpnoTF/cmS4/qeiKXLqikpgy43nhwNwx17WdHgRP6M/1RL5dQn15YWkTwGT78568jfB/qzWSuoAl7E1V8M4wQrt9TvWxPq1oZA9p9zDD6V/a+w65AzFOk6IOaVNLpfP2j6Dk1mam/0e7ERHqnTz7rRh7TbwjNOCUfOKy7NwdezjOj0t7tHRIzy2k5C+Vr4EzOVdpU1qFGbTSIrZjs9Q7qQs81IaZmHZCTyHBaKjAeJqcowzliCZkGZ2ktnZxkjLGejNg
 kJWai6BA
 Pnf9W2biOFjFGhgBNFFgHSbSrTk1PSWh09beOsKfYgFb6LX3uX6omR3k+r4KHoj9WJ+D5yMZbAb7+fA86joAKoxwgetG15+CAjQoL0eKLkUmMKWffaYLIXQFly178WujCgz03NUG8oghBhKq3uaji8Yiqh6YxWumxkbawAgz/XeIW/xENjQDXtP9khrLkp7HQfVq6JtbfUzgPPSd1AHkCfTrEEYAqSkBVpFdhA3bqRVhO0/kWxd0QN86AOehbwTTr3ikT7OxQLuBa+yFsQWLFFfN4+7MuNT5wGhnP1YGCpzAnyjBb0FsTlrG4L+YEnbymykHPKNovMpg4W9O7ikNltHkcC4L+LUB+fPZR1aEqak1Wa8dj/6BjnfqGyFGMprIqLWTm7aMQjEUs8AV7yRaDMpJoTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch is a result of our long-standing debug sessions, where it all
started as "networking is slow", and TCP network throughput suddenly
dropped from tens of Gbps to few Mbps, and we could not see anything in
the kernel log or netstat counters.

Currently, we have two memory pressure counters for TCP sockets [1],
which we manipulate only when the memory pressure is signalled through
the proto struct [2]. However, the memory pressure can also be signaled
through the cgroup memory subsystem, which we do not reflect in the
netstat counters. In the end, when the cgroup memory subsystem signals
that it is under pressure, we silently reduce the advertised TCP window
with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
throughput reduction.

Keep in mind that when the cgroup memory subsystem signals the socket
memory pressure, it affects all sockets used in that cgroup.

This patch exposes a new file for each cgroup in sysfs which signals
the cgroup socket memory pressure. The file is accessible in
the following path.

  /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure

The output value is a cumulative sum of microseconds spent
under pressure for that particular cgroup.

Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/uapi/linux/snmp.h#L231-L232 [1]
Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/net/sock.h#L1300-L1301 [2]
Co-developed-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
Signed-off-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
Signed-off-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
---
Changes:
v3 -> v4:
- Add documentation
- Expose pressure as cummulative counter in microseconds
- Link to v3: https://lore.kernel.org/netdev/20250722071146.48616-1-daniel.sedlak@cdn77.com/

v2 -> v3:
- Expose the socket memory pressure on the cgroups instead of netstat
- Split patch
- Link to v2: https://lore.kernel.org/netdev/20250714143613.42184-1-daniel.sedlak@cdn77.com/

v1 -> v2:
- Add tracepoint
- Link to v1: https://lore.kernel.org/netdev/20250707105205.222558-1-daniel.sedlak@cdn77.com/

 Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
 include/linux/memcontrol.h              |  2 ++
 mm/memcontrol.c                         | 15 +++++++++++++++
 mm/vmpressure.c                         |  9 ++++++++-
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0cc35a14afbe..c810b449fb3d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1884,6 +1884,13 @@ The following nested keys are defined.
 	Shows pressure stall information for memory. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
 
+  memory.net.socket_pressure
+	A read-only single value file showing how many microseconds
+	all sockets within that cgroup spent under pressure.
+
+	Note that when the sockets are under pressure, the networking
+	throughput can be significantly degraded.
+
 
 Usage Guidelines
 ~~~~~~~~~~~~~~~~
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 87b6688f124a..6a1cb9a99b88 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -252,6 +252,8 @@ struct mem_cgroup {
 	 * where socket memory is accounted/charged separately.
 	 */
 	unsigned long		socket_pressure;
+	/* exported statistic for memory.net.socket_pressure */
+	unsigned long		socket_pressure_duration;
 
 	int kmemcg_id;
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 902da8a9c643..8e299d94c073 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3758,6 +3758,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->swap_peaks);
 	spin_lock_init(&memcg->peaks_lock);
 	memcg->socket_pressure = jiffies;
+	memcg->socket_pressure_duration = 0;
 	memcg1_memcg_init(memcg);
 	memcg->kmemcg_id = -1;
 	INIT_LIST_HEAD(&memcg->objcg_list);
@@ -4647,6 +4648,15 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }
 
+static int memory_socket_pressure_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure_duration));
+
+	return 0;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -4718,6 +4728,11 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
+	{
+		.name = "net.socket_pressure",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_socket_pressure_show,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index bd5183dfd879..1e767cd8aa08 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -308,6 +308,8 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		level = vmpressure_calc_level(scanned, reclaimed);
 
 		if (level > VMPRESSURE_LOW) {
+			unsigned long socket_pressure;
+			unsigned long jiffies_diff;
 			/*
 			 * Let the socket buffer allocator know that
 			 * we are having trouble reclaiming LRU pages.
@@ -316,7 +318,12 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 			 * asserted for a second in which subsequent
 			 * pressure events can occur.
 			 */
-			WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
+			socket_pressure = jiffies + HZ;
+
+			jiffies_diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
+			memcg->socket_pressure_duration += jiffies_to_usecs(jiffies_diff);
+
+			WRITE_ONCE(memcg->socket_pressure, socket_pressure);
 		}
 	}
 }

base-commit: e96ee511c906c59b7c4e6efd9d9b33917730e000
-- 
2.39.5


