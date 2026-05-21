Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E904ACD5BB7
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1496B009D; Thu, 21 May 2026 09:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8DF6B009E; Thu, 21 May 2026 09:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7266B009F; Thu, 21 May 2026 09:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9EF16B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:33:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C4891C04F2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:34 +0000 (UTC)
X-FDA: 84791519148.09.93D8CBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9DE9A000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aURtmQtr;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj7DVCvMStdFPb34OrcUAAH1hWW4OYzU+C7hp9VpbjY=;
	b=wYo2wv7AzLBL9KnDI4nA/HoKb6wnUAJ2nZOjLVZlYLdopHeXpeOq/0K9ghu/tgQucKTY34
	KBudiG678xHIOQ4mWhavboE3DOnzyiFyBYVaCxtrDnmgQxj8FGNFHkj2rMcpW/hLEhlm8E
	nMqvj/ySuxUNLD7tBGHJCvWGo8KDDeQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aURtmQtr;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370412; a=rsa-sha256;
	cv=none;
	b=ZaUzKiNipLPnWy2rskZyFj7UqBbOCCg7WmArPqFC4rILbDYLv67Lbu+kfSFBR38xhCs7o0
	N5mQCdpXF6ELq2RnrnRLXgiMZG/PLJL0nihX9Pl2DY5wlal8V4NZ51gtz4nzBkgU5nu987
	1kqNo9DwEaeIVrWHUSe9b/D/EQb48G8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2532D44629;
	Thu, 21 May 2026 13:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEC21F01565;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370407;
	bh=Mj7DVCvMStdFPb34OrcUAAH1hWW4OYzU+C7hp9VpbjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aURtmQtrwPk362cS1vDZGBJmbbXcm3ql47tmCQHz8PJEmKOF7/jLX6+fHXlEqbEva
	 OwKnOcM8EQ2xhWSTSyGGYEKpHyvyEBd/6fgnNr159VVhcsbUpOC1WtyC6v/6zEJPp7
	 PfX1fyNcqVsrSCL7uuLFL3Ma0mOwSc/FqWMjfb2WpGH+pZhNrZwj6CgkRIxXL3YNVz
	 gZ0zLwRhyzfV0vFW1qYm1/eyWyAnFWpN/ARSge3qfyc4+8HkcpGHlvX9JLTbOkIU23
	 ufiacMGKFizrGoSI31tRqHYQuHjL4WtX4qjOWurnM2F9zXlI3MXo0XHg0Hoh6hp/z6
	 Tk/4oaz0PA/ZA==
From: Kees Cook <kees@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	kvm@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 06/11] moduleparam: Add seq_buf-based .get callback alongside .get_str
Date: Thu, 21 May 2026 06:33:19 -0700
Message-Id: <20260521133326.2465264-6-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3696; i=kees@kernel.org; h=from:subject; bh=T4N6FoAPN5e2cqvWSGS7oEs1xiLk99wdr1LKck0ur78=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nIs2HH8iHuPEcem9X7HM2rJrS2LZVs8vP/M+reLdF K3trxtfdZSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAExEwZOR4alreLoXi13roV/i 9/tfrbvsVLZZb2L3Qh33TS8N1v2/U8fwT//2x1KTz9OUg91P7LvT39NrdVL4qeIHRzc9ZcnAHRc /cgAA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9DE9A000D
X-Stat-Signature: g63mb3cncnzqyutjkzeq1x7m4tuk9p4k
X-HE-Tag: 1779370412-942006
X-HE-Meta: U2FsdGVkX1/HLTT42lv0mcmwcaJLIdS87h1CxqcQxpqllrQZgvmKWxuIdjo6vtMktgbB9kwnZ5px7lfX/JGUMIGedK0ZzMzS4I2BSaN406GwDnZ5d3/+GTx6mF0M0pUAwZZhNsEg3cFkjIE74VZVJqcGOYz6V19DD6ZAubNxLqB3SD8WaQMBT/KtLM0wRJwWA8ozpWEjSHj4E5njYsTNyGdL68wjQ6e4szZOnW1bCmuQ3qQ6RysNBoJgnB5v6QqC2YSbrqSi7ybWIJ8UDWXMo4F7gsi/v2La7l9nNmudYnaKoSb2ndI6CldI80uIpwFUx/xp7gJkt3Vek44OxgVA4YgPpmtRegryyThglIlGYhlf7FJHRVgXPR/yL5vv0DUOxtabxdfkREQkTrfQNcBdCELqMIvYPYZQA934ZcWUYquT87MTXE2t8dhvFw8fLX7tjhrH3vsDDjwjtnnNvbGWnIx6VK1Ybht/bekjZIyf57CcFi6KQQZqk6IQfo9TZanBRDPQpknp4bfNexLXxg4M9KFyfnSrvIrYL3yRI47BhKtSP9KDgN1oDKzo/+CR5iy3Kts9nALzVBQqC2AVmov8cTqGkfLem5e454ch7e3vCzqMzQ14eQUyKFNv7wyS/8bpxrfWWPxJFJRQvo8fQTXUZ8DgLPOxFMUKbCV++fFGGy+A0yZUHgheepAvPz8HfUCYohQgt2Rd2j8bquygR70IriY8hGv51tD/y27eNwFTnM0+72eA4R9PELnsz4S1LVqz2GlwVujDRp2B3lf9qKmnt1qNPUQpAB5/rIyrJpM2ofkaDUfPbmP+iR7FsGFtMUOqc2+SJiq6w6oAGTAeXIbggHV2Mzl1BM/vX4oqeEt7FWEb4I29FNgeJV7r/0dYEWL8PvZvSpUoT6yilzaKaw96eq/c7opyAToTqYXq1vnheHiOI+YA/TEtHTurxNRmScsqkpADqLuk0U9Ky8DGpXH
 2La3pNEt
 sH/i7hC5B0XnTzMhuDSJfcVkGzxlFCdmAqehDKgJX7M4KqtNVqMquP5J0uaAJVPZbxsKllZDZ3Bq9C2SYDsRRvfpZ7RyiirxI/+EKJFLzTCjNC2kJC+sbVmX94LYq8K2tkStSM7tsl4w3DkBJ/UVGRXpl/DA6xd5JV47Q/EOqNGM7pNZ4mRsrZnPHLDYsh5yXAky6IuNBK490PWmnrMP0aK5umsdhaP05qFQNSEfLjKoIawmop6iPb7HxTJKrkVprwtomAxODEm4yFMfgurq4qLnAi558ELjLgHhU1JV/7d5sXdJSu3CzvRQcw5aaSc5+MrX8O2L+OXqvxB9ihev7QmgPM3jDbs3uZFVm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new struct kernel_param_ops::get callback whose signature
takes a struct seq_buf instead of a raw char buffer:

  int (*get)(struct seq_buf *sb, const struct kernel_param *kp);

The previously-legacy .get field is now .get_str (char *buffer);
.get is the new seq_buf-aware form.  param_attr_show() prefers .get
when set, otherwise falls back to .get_str.  WARN_ON_ONCE() if both
are set.  Return contract for .get:

  < 0 : errno propagated to userspace; seq_buf contents discarded
  = 0 : success; length derived from seq_buf_used()
  > 0 : forbidden; the dispatcher WARN_ON_ONCE()s and treats as 0

The default policy on seq_buf_has_overflowed() is silent truncation,
matching scnprintf()/sysfs_emit() behaviour.  Callbacks that want a
specific overflow errno can check seq_buf_has_overflowed() and
return their preferred error.

No callbacks use .get yet; the legacy path is still the only one in use
after this commit. A subsequent commit teaches DEFINE_KERNEL_PARAM_OPS
to route initializers by type.

Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/moduleparam.h | 13 ++++++++++++-
 kernel/params.c             | 26 ++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index f5f4148e2504..c52120f6ac28 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -7,6 +7,7 @@
 #include <linux/build_bug.h>
 #include <linux/compiler.h>
 #include <linux/init.h>
+#include <linux/seq_buf.h>
 #include <linux/stringify.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
@@ -62,7 +63,17 @@ struct kernel_param_ops {
 	unsigned int flags;
 	/* Returns 0, or -errno.  arg is in kp->arg. */
 	int (*set)(const char *val, const struct kernel_param *kp);
-	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
+	/*
+	 * Format the parameter's value into @s.  Return 0 on success
+	 * (length derived from seq_buf_used()) or -errno on error.
+	 * Exactly one of .get and .get_str should be set; the dispatcher
+	 * WARNs and prefers .get if both are.
+	 */
+	int (*get)(struct seq_buf *s, const struct kernel_param *kp);
+	/*
+	 * Returns length written or -errno.  Buffer is 4k (ie. be short!).
+	 * Deprecated: callbacks should implement .get instead.
+	 */
 	int (*get_str)(char *buffer, const struct kernel_param *kp);
 	/* Optional function to free kp->arg when module unloaded. */
 	void (*free)(void *arg);
diff --git a/kernel/params.c b/kernel/params.c
index 6852caea1785..4eda2d23ddf2 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -553,12 +553,34 @@ static ssize_t param_attr_show(const struct module_attribute *mattr,
 {
 	int count;
 	const struct param_attribute *attribute = to_param_attr(mattr);
+	const struct kernel_param_ops *ops = attribute->param->ops;
 
-	if (!attribute->param->ops->get_str)
+	if (!ops->get && !ops->get_str)
 		return -EPERM;
 
+	WARN_ON_ONCE(ops->get && ops->get_str);
+
 	kernel_param_lock(mk->mod);
-	count = attribute->param->ops->get_str(buf, attribute->param);
+	if (ops->get) {
+		struct seq_buf s;
+
+		seq_buf_init(&s, buf, PAGE_SIZE);
+		count = ops->get(&s, attribute->param);
+		if (count >= 0) {
+			WARN_ON_ONCE(count > 0);
+			count = seq_buf_used(&s);
+			/* Make sure string is terminated. */
+			seq_buf_str(&s);
+			/*
+			 * If overflowed, reduce count by 1 for trailing
+			 * NUL byte.
+			 */
+			if (seq_buf_has_overflowed(&s))
+				count--;
+		}
+	} else {
+		count = ops->get_str(buf, attribute->param);
+	}
 	kernel_param_unlock(mk->mod);
 	return count;
 }
-- 
2.34.1


