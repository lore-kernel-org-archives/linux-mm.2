Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C1DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475D06B00CD; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF716B00D3; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315B26B00D6; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7DD36B00CD
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:46:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 110BE8C57B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:40:52 +0000 (UTC)
X-FDA: 84944551944.05.8D81645
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id D21971C000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:40:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="qrdK/fl0";
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf18.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014050;
	b=vry4gSw5Vk4prn2MbihnFecF/BHZ0SK1oaDcAY9rWJzJz2DDBOGekfyG/8yAhL3p8PESqB
	B4UY4EoUFz/ZJtII4EfpBep8cabaije9QVtWq6f1E2ArHpfi1GDnz+tp5X6QJgOK9Whxz5
	gUdfgHty/jJdEQgzklQHnNrTmudpXMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5y+H67ThXEbUdB02JQVhsVtUDnX/kL/u90pAnPi/57A=;
	b=CoCZt09snke4SWieKw17Hao1vVCT0SMr2H2Flyj6ndatVgevh/TFjd2itsq7bLCH5omT4x
	Qi0rlNqIZeRwr5Fb1upJFcolFkvgRi5L/xDPRSycyQQ5u5OyuMzqXHePVU+7/dCK05+/RG
	lAJ4k2PCqqTt9QoLPG+KAWtq+6X6BAU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="qrdK/fl0";
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf18.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014049; x=1814550049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5y+H67ThXEbUdB02JQVhsVtUDnX/kL/u90pAnPi/57A=;
  b=qrdK/fl0ArqbXZ52WjUwEqHQwRz0zAbanaoYD2PMgDBGgaYLnQE8zsk/
   74Ym++3jqLJJysmZL4jV91oKU+ZObrDbwJgZjSeqmBo1KgZf77pujJmNV
   wEVb6BbvayruQ6g5EA3cNv1HyUuFETysa15aCljbkKT9VeBkVUKmaTiPv
   scRCIcdQNaIrZje3pCUCk4kquPzsRtmlrjONyN03Loh7rbALPudNoQSKM
   CxD17LQAyEIjvfEDf5fvu8RaSoYA/T7xKbxeAtxcAOBaTuJkZV/aeCkOa
   cXHb+o9A88U8cqaJP8NTpt4XdIny6GSLR9q+rQq8z7/Ci3EMEE15yyjr2
   Q==;
X-CSE-ConnectionGUID: Z3ST562ISvGKPYlXp7BD5Q==
X-CSE-MsgGUID: i8mNv5wBRKGRhF0eq3+5hA==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22738367"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:40:46 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:21839]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.129:2525] with esmtp (Farcaster)
 id af6c0e5f-4b77-4570-942d-449df8c7a53e; Thu, 2 Jul 2026 17:40:45 +0000 (UTC)
X-Farcaster-Flow-ID: af6c0e5f-4b77-4570-942d-449df8c7a53e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:40:45 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:40:43 +0000
From: Pavol Sakac <sakacpav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tejun Heo
	<tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <driver-core@lists.linux.dev>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, "David
 Matlack" <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 03/14] sysfs: introduce sysfs_kf_syscall_ops dispatching to kobj_type
Date: Thu, 2 Jul 2026 19:40:22 +0200
Message-ID: <20260702174033.32116-4-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702174033.32116-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D21971C000A
X-Stat-Signature: sdngz8poneaorhk7o461y17gqgo6ffo4
X-Rspam-User: 
X-HE-Tag: 1783014049-563442
X-HE-Meta: U2FsdGVkX1/RN9SGCfImUr6eKJnTo+x9XFy686vtDpoQtldLmDyFj/hMt1PZo8IrBAins4vKnk7JNQNwLJpQrOJo42cvsOEd8tnC/NkWhgbMcUjTmtH8wPrUpALCF4hWSWR2uhhM9Ylu7M3FSty1X62QCvB8ZQC667Nh+dBBYMBcZWDVnLuhXA4TKWC0HLOFzyTKCB1J4WSJvQDchYMVi6Ry5/9KiH1NChCluKJIjQ3dpP0tYjj982WERNZbd7gP2XN5jFK4bFVltB793bqAf2sttSxny9wNbyEGn22nOBDfUc8skIa9obgllEgXRcA6G1nvX+867waXozVNwH6fB4eUTpkXP8CoGTwkF1ZOjRVtjJIkk1vGzLwjZ+hfeC+n/3bANpF/B18tJ9dByPDHNhcCWztQbYkmq/pMPNWeC5tR0rQ/J/zOcJH+MCY62wxM708H+L+3el1GDlXZtjB1SFdtWB5haTmVWlgMDamDBDFNX5+UwPE8ywPnKyb1Kc1AQd336Vvz0IWQz6CeFShosxLiazUnYknrC75+PJGu2XuKlY7bHtL/0L0m/EQr/7+Iltp5OvTAO/gsgapZp0HaOeHkBnKhRBXNV8P2/xjOo3Jg1yme/8I/nimRlY1tz6BuYzfOVrqm7bXdVms/6xfgIf8SwHr1X3K2ks1MVzMOBwpq6A1CvOswOmrTMNBBuaXMdTEaLyxsCvowy7u3XlvNSyP7vqfpjrXYLwG5Ln249YszdQdMsjkesjOT47OGQ3aHQBfGyx85/wxWjHZLjVCOOuHpFPvL/DjLm2NqLLnL5pQsjEy+qBeApNtRd5aSYEbgpVh0uarS3v4+RGBgjiS9BxsDWdWSgSfOK2t3O5u2buLWkl6Kv4nhkBshjc5dnIeq4yFsPrW+gXZ5crz/y0V3Ognu9+PDypyf2zKTrj2xmzJkeKyGZAdQ3cBEOEyOF1pTjwYJyvaYpBS7ucud29H
 7TQt9iUF
 lqHmLtBt2HVxNXFQDPPg2NRAtWwXPFMykIZRMZAWpjOXdlJHKSz3mXo5j+/Q/WnlpYC2L84p6fhoKPOU7dGcJRQ8k4KrIpZJ8OKLpgLbPYSaM8jA/i4rLfjxL8DdnH9Re1/9s0ZRAJIuAOonjVEcJMNXNby8dFtwmuBOqaKthYZ8rrlP0qNE1xxy+Z0svOlZfkR4CJdA+Eh5wGGvFJtxIT5U2g8r3Q9o2oUPFf2JBD3aNSmyOtXCbK62547hJjMMQ/+Tnmf+HkXeWHWNOURnZkbwS3+L9IAyLQeBoD9YdQM51zPefYHyBfQRVtAuk3DM4OzAjssE/9citgbg+oh16jskUXEISkWXrsemJH2Kz0QS5HyeXxDBU/K7c5t3mlOUXHHFzW2SjrjX/H7LWF6qB2BjhEYi3Dvt5lJVdP+Oek7Hm+yd6wKY+Q31h2SqHoRktuN129+mcLnw86WyeHRxRBou2D9WKsRPItWH1e4jOa+VE1j0apTrUtg8lR+bU+EnvmW3zURiGVxxuZzvyYUtZBpJ85VtHkwXJV4zLgAEf6FThainu9uOhawxfKaSSGHkcFLTt6dWv59Hb8he9tPYd80OKKBQOVYtuoTLXpPkBCwwXRdOyD6cjF0oHlraH7ZiUyj7DE0965ltFG9wPTFXvqMX4hA0z3h80RLxWsHgLwquOc9+RnxNZMjtA5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire the sysfs side of the lazy populate chain.  sysfs_init()
previously passed NULL as syscall_ops to kernfs_create_root();
install sysfs_kf_syscall_ops with populate and populate_all
that dispatch to the owning kobject's kobj_type.

The kernfs lookup path pins the parent's active reference, so
parent->priv is safe to read; sysfs_populate() additionally
pins the dereferenced kobject with kobject_get_unless_zero()
across the sleeping ktype->populate call.  sysfs_populate_all()
does the same for ktype->populate_all on readdir.

Both callbacks refuse dispatch in namespaced directories: the
initial consumers (PCI, VFIO) are namespace-agnostic, and tag
propagation is out of scope.  Transient errors propagate without
negative-dentry caching so the next lookup retries populate.

No behavior change: no kobj_type sets populate/populate_all yet.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 fs/sysfs/mount.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index b199e8ff79b1f..9e0a37b60d6e7 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/kobject.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/init.h>
@@ -96,11 +97,68 @@ static struct file_system_type sysfs_fs_type = {
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
+/*
+ * sysfs_populate - dispatch a lookup miss to the owning kobj_type.
+ *
+ * kernfs pins @parent across the call; we pin @kobj while the
+ * (sleepable) ktype->populate callback runs.
+ */
+static int sysfs_populate(struct kernfs_node *parent, const char *name)
+{
+	struct kobject *kobj;
+	const struct kobj_type *ktype;
+	int ret;
+
+	if (kernfs_ns_enabled(parent))
+		return -ENOENT;
+
+	kobj = parent->priv;
+	ktype = kobj ? kobj->ktype : NULL;
+	if (!ktype || !ktype->populate)
+		return -ENOENT;
+
+	if (!kobject_get_unless_zero(kobj))
+		return -ENOENT;
+
+	ret = ktype->populate(kobj, name);
+
+	kobject_put(kobj);
+	return ret;
+}
+
+/* sysfs_populate_all - readdir-time variant; best-effort, retry-safe. */
+static void sysfs_populate_all(struct kernfs_node *parent)
+{
+	struct kobject *kobj;
+	const struct kobj_type *ktype;
+
+	if (kernfs_ns_enabled(parent))
+		return;
+
+	kobj = parent->priv;
+	ktype = kobj ? kobj->ktype : NULL;
+	if (!ktype || !ktype->populate_all)
+		return;
+
+	if (!kobject_get_unless_zero(kobj))
+		return;
+
+	ktype->populate_all(kobj);
+
+	kobject_put(kobj);
+}
+
+static struct kernfs_syscall_ops sysfs_kf_syscall_ops = {
+	.populate	= sysfs_populate,
+	.populate_all	= sysfs_populate_all,
+};
+
 int __init sysfs_init(void)
 {
 	int err;
 
-	sysfs_root = kernfs_create_root(NULL, KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK,
+	sysfs_root = kernfs_create_root(&sysfs_kf_syscall_ops,
+					KERNFS_ROOT_EXTRA_OPEN_PERM_CHECK,
 					NULL);
 	if (IS_ERR(sysfs_root))
 		return PTR_ERR(sysfs_root);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


