Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65CAC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53FF66B00A3; Tue, 22 Jul 2025 03:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517BE6B00A4; Tue, 22 Jul 2025 03:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454A36B00A5; Tue, 22 Jul 2025 03:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 376386B00A3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:12:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8275B7C20
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:12:45 +0000 (UTC)
X-FDA: 83691033090.04.0E15E29
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf12.hostedemail.com (Postfix) with ESMTP id A76A640005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:12:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="VqGXw/tv";
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf12.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753168364; a=rsa-sha256;
	cv=none;
	b=2g0v0PXSGvF0HAgfqqZ3uuorFHJxKrILJBiZeGmWMHf9+ZkExqimN18tgv7Y5DXQkN6dlA
	iP0mLBzlOX0M4+c6Gg9gq3MbTfMTj1JbIcS3cpAc2o0jk5wLQNoQnRaFnEY0qERuGejFEH
	OzN63V0QrybvHcmhcl7FkFbnZRnRVGM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="VqGXw/tv";
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf12.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753168364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=G9jb3st1obP8Gd9xyUJPV6c8IdsyENVMCWvoYCoWByc=;
	b=wp1/jBBW4tHHkxv/ctoE4sGucFrkbJKOFmnAo6BJWzC4H3qSMfQzZzzfyHULRBW18skqml
	JSkB2/4L97CW/OGZpyyBolduawQmuJAxqIhHsN+M/5TQ30KoFz7Qg3Ct9a5EJ1HExLCKfH
	XlGOglyqKCEvlzfmQ897NQhgN4ciKS0=
DKIM-Signature: a=rsa-sha256; t=1753168360; x=1753773160; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=G9jb3st1obP8Gd9xyUJPV6c8IdsyENVMCWvoYCoWByc=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Transfer-Encoding;
   b=VqGXw/tvesgG2gtVuhtJPArWgMROI/mJTgqt4ysZzUMxE4eZ+kpBLHKXDksPjpIGJU681T4/wa9AiBHeyCX8D9opXNgKO/xIdL9B1hKZ0LifSKviL7bloYmI32xmTnXnrhhGi+ngUmgp6+8JQbLPG2kkczyvAUdI0u9CNZ6W6j4=
Received: from osgiliath.superhosting.cz ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202507220912390266;
        Tue, 22 Jul 2025 09:12:39 +0200
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
	cgroups@vger.kernel.org
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>,
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Date: Tue, 22 Jul 2025 09:11:46 +0200
Message-ID: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002102.687F39E7.007F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A76A640005
X-Stat-Signature: zpba4a9f9mrm5q34e1ofycp4qfhbu5e9
X-HE-Tag: 1753168363-259732
X-HE-Meta: U2FsdGVkX18el+kptxX3WBjwBnyjTCFUDdEpa+3H7Is7HrkghcxAGJM/6Bab4Z4F3RAU+YdfgPN9C8CgU8nU7Ie//EcJt5NRIYH/PwgLO42t28olJQljzpUs00YwNoqBpB7REB3sdeClm539f/8jwgeq2g5OjsfDdKKqZjWARorH2YIpEjHaFoTtx8enHIg07HJsyZB63NudddRAgCNi0C5Hh2PkeBxIKDFTWU4TUn8B4886HmEdF+UXrOYE5Bd3cMf6HUq8Hxf9rID1w+XCCSgwgR5BKziI/hQAOd5yCSiURl+RLNkbfbNGHuFI1VR7YfJnV7xp1/kC5EAtJIt7xe3/z/xzzQRJqvf5lmlCgY1xBYuIV08Bg51VQf4ZG7wKNpcXDea6UUhSO+Pi/rtnbGS0jA/HxaY2QZFnqRQK75OJvqai5POJO1CbcYTnk8ZWYjaEN4tDSmFhDX0v23HMe+YkMOoI6xXilj5K/oLq1MZWIU05UDzS+bNMSgUA6MfZh/lEq7cFqm03bAATTVxiMtkLYl0sC3H5jw5wPqpaJGpNuHXN9dDXAIAMw6vnfMEz79AzTLBqI784ZAM7vg8Y9F3YzoD9UH56szzdbT3Jz9X6SMPdx8e6IW3h71PA4w+Co76hJCqDdkQrE+ekMaTG2Rckx6/Z2bGjRl8GiXr5s/wZJGl5innjATvKPRTnUlNFKkwordet7aPpkcApqoMX8AinH21Pwoyjw21DU/YM8U6fvPTUoqyBUSjthORAeFi/e7qKweH/feQuxG1Csn3aSAIa/1wcQlgyN328avdehRvyUvx/b2W6hPRelXdcegV8hSk9xnvvijkMi4pfgMnAEk2MM+7WlSFnvYqBwDhOHRm68hLASrl2TfFYoN29m/v7irhFP28GdmrQxPZNVzg8WRVoF+SLQjnHH938H4xLK0Rr1UDz1iyN2WKqPwZF9ZidV78doOUMRrrA3mvdUej
 SbZ3l0WY
 vFt+LXBMzZl1wQc/mPOfd4KW2e2e6x+79q7Z/PwGYz1DF0QtOK4R2HZ0Hr67FFAz9I3F+IhMZ17OPBymUAlGRr3Lm/E+Bdj5ng3UsSzd+8t87Wqf/iX9yyYNfI7jFV9sqsa2QhXHNR1+Q21SeSdMBMCastL8L5IJ/IL5hdanC/5GjuRvAQZ1apj+cQlEEUZ36lhgml0eqEU71pGIWoa++Q6eaAjW/6RLTCPwVcowzl5zhPxGbylE3VPOI5lj5+GaM3353ObDdAXgJ6D3czgr1Y2kBF/NgL+l0cJHCRm5+Qjz1zkJVt5JcCFSD4u6KeapPDFRE0gxwkThesr6FSBP04V5ZJHxJ8kcRSu0776yx7piabGQ=
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

The output value is an integer matching the internal semantics of the
struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
representing the end of the said socket memory pressure, and once the
clock is re-armed it is set to jiffies + HZ.

Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/uapi/linux/snmp.h#L231-L232 [1]
Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/net/sock.h#L1300-L1301 [2]
Co-developed-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
Signed-off-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
Signed-off-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
---
Changes:
v2 -> v3:
- Expose the socket memory pressure on the cgroups instead of netstat
- Split patch
- Link: https://lore.kernel.org/netdev/20250714143613.42184-1-daniel.sedlak@cdn77.com/

v1 -> v2:
- Add tracepoint
- Link: https://lore.kernel.org/netdev/20250707105205.222558-1-daniel.sedlak@cdn77.com/


 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 902da8a9c643..8e8808fb2d7a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4647,6 +4647,15 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }
 
+static int memory_socket_pressure_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure));
+
+	return 0;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -4718,6 +4727,11 @@ static struct cftype memory_files[] = {
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
 

base-commit: e96ee511c906c59b7c4e6efd9d9b33917730e000
-- 
2.39.5


