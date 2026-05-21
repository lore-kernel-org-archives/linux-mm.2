Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83FE5CD5BCF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC896B0096; Thu, 21 May 2026 09:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3326B009B; Thu, 21 May 2026 09:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D796B0096; Thu, 21 May 2026 09:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA40B6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:33:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 699A7A066C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:32 +0000 (UTC)
X-FDA: 84791519064.20.3C803C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9AAC7A000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7Ykfcvp;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIIxiknLSHVZBHNOKlLgNSXxWTGeUxPYBjk6/bNkxVs=;
	b=LVVxlyomE60kqPuDGKRsMgj7EIpE/0zcLh+QylyHWIe+X7hO4w/7GhUVru4J6Jx77hE0Gz
	wfsQEfF1YAzOOgMVapaT+l32NeKbRBO1Xa9DRHWnC2klc2F9NiEvVryV9D+6fQpsb4opwo
	JYypEnz/8pDG68zgx0ei13S7Tdk/6ug=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7Ykfcvp;
	spf=pass (imf25.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370410; a=rsa-sha256;
	cv=none;
	b=nM5MlWVYVEU/7lcwsVyYzFnRNtznZC/ZonaavM0fGLt3s/WxfTzqVwlBkOEzupUiKzkl7y
	5t8xc8hIf2Xb63osGoLyKINqQpokkyWSXHfhvUdvh8Ndibriaw2OuShEojLl/5e0CriLCd
	qtT0pWTBB1XOFUntite8wH4LgCEmizk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E160F4460B;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930C31F01570;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370406;
	bh=xIIxiknLSHVZBHNOKlLgNSXxWTGeUxPYBjk6/bNkxVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7Ykfcvp0h6C12Jt7BShNBYGEpfAXvBIAx55A0+93dBwBTPwWMwDWRrO5isUznkhU
	 itctVylBMPCseJ9S3+reU25bfhnxLGs81ROGkHDrSKeWpg/Rez1y63/E0p0lUE95MZ
	 f/u4MnqyDBhhEHDleXISBtEDS8S6m8ZqoBy++9FLbj+QOoOdhCrl4GIXgLtDV0fnor
	 mdHdAkA0VigFdnzXd0I0EUKIL42pTjUoBNZrx7zwWr/eWeE294mHLH60nGc7HBVsnN
	 mHi84Fj8xXC12VUh1R1/Dg14UV22HTZGInV0oKdkocpJo9YXz5btVupLw70hiUfFNW
	 gaqKIygTuUjnA==
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
Subject: [PATCH 03/11] moduleparam: Add DEFINE_KERNEL_PARAM_OPS macro family
Date: Thu, 21 May 2026 06:33:16 -0700
Message-Id: <20260521133326.2465264-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3674; i=kees@kernel.org; h=from:subject; bh=3qCwRbQEn6qV8q9ahXLM93O2aOukjHk7G2WsPfFNfHo=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nAuull67+C5txg2e1YGCbPvcujb6Wx/JN/xsvCs3x vgezzqPjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIkYvWZkOH+4UFL72GLVDkfh BLNPz5NZzv2JWSzlWpkxwSTGt4VrNiPD9r2rxE49blEzn3CRa4uBQPBb6Zti6VkbO1blT5RSdFv EBQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AAC7A000D
X-Stat-Signature: bxcmae6ww61cj5n15j6qw46cch3rybed
X-HE-Tag: 1779370410-506484
X-HE-Meta: U2FsdGVkX18npH30OHerba5YHkJ+PQhSLrwvnXctopZeh7Bcv3Su3fBIoMcaID5p/g8THClFOF3gs1RWn64Vyn+etqQ2m4hf8WvDWd2XvlbdGhE91wZfDEfmgTUaxMyASVFM+mj2Cnj3yR8eIQcexyUJnFuUmZS03SFwSSGQFD2j9yHFr+VNlub3IoV1S9Kn4DuiTxxKMc78Xj9DtpW1JPAtCgwU6i43FKgqVNTJjwdaKQiS31vjjMspWM/k10IlMSMgllRUJksbO33bmnxLk09DAUutXt7+2kRJe13s0vIdpLxLsF0ljtu3oy83KW8PHICDybfFHsYjNJYB3evHiDlH19nPudl1NReCsgJhIR4Mbaz1/ilaYZCnBe6H18jutlMpbgptm0jAOG4N54DKh9VzoyBA/V42dpD6ngf8X67V0BYrn6E/L8Uujw8V085/CjiHtaUUiZC9AlejM9jQoJoWgimAl5ssav9A/gTkwF3lySAGJgFGJRhSZUSe+jYpnqVf7cL+c238XAitLZlVHLbzKZhoImH6yq1iiTzRlmq2+LxoQSXy4wT4d5hU4dJ0CULuvq5IU2mZmndTrBAIDLcag2nsTeQQyPjeQY9yGlR6WvyCGoHlyM9TuqRBlsWWMmUVdDGVMcGCb7KybBQx4W6L0fOOe+9OvosmYjDCYQ9bdlqHBfHGFOKmceV/Axmtv1RTTUEaPqhHbhw0owsmFr99S+ILlQYdonjcamUkKx24lZisKojnHwRE9d93O9KNjg3u+HVwoy5wMPN9eBhOMHAvHB6leQc15os14PMk9c34rbQHsxCiSwIQ/7b07EfVZGnAETK0zHHk0a3zp4oXwOzYzD3tYF9M8vaOSpgeTgKYnkxk063O8sGN31bS/FcvpYRgLuKkwyr3NVejH9VDxtdILvRAtsLJVI/jSiYLxmx29K4ui4WdMJ+00dZzKpY8tXJCBSRc6/iRpoV8PZX
 z2MWrZZy
 ECEA7didZpuPMGI6/UD4q5whPfk/Cd/g4/LdUvsehEPzn52NC2pm1PmwYjOyvhNbuVWUHxPx6RRrJd059X/IlGiog3AGWSgNvXZPBjhj/SBqmZ+Kked1vfiKbketF3BZ8lW5KpGuQ8Cdv7w8hcYLloX12+dgalI4CSq0amiIpgiqsBt8q4fIFFfrG6myyzZUYu7WC2KUe38CYMwN75OIlQUSOQr6s3KjCAL/LQjvxPO54vli5Rxbt0XCD48xymgtdLUmHovGsc46xgymsnRYR/ciWPb7zfQm8WChvZdkMqkikIu8de41alPnV4ejIeK1re9YVCutL6El8KGMnnqnY/9kXBha5E4ekuE+p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add macros that define a struct kernel_param_ops initializer through a
macro so the underlying field layout can evolve without touching every
call site. Three variants cover the three cases:

 DEFINE_KERNEL_PARAM_OPS(name, set, get) // basic
 DEFINE_KERNEL_PARAM_OPS_NOARG(name, set, get) // set KERNEL_PARAM_OPS_FL_NOARG
 DEFINE_KERNEL_PARAM_OPS_FREE(name, set, get, free) // also set .free

Callers prefix their own visibility qualifiers, e.g.:

  static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);

Also update module_param_call() and STANDARD_PARAM_DEF() to use
DEFINE_KERNEL_PARAM_OPS internally so the generated ops table will go
through the same macro as everything else.

Subsequent commits convert all open-coded struct kernel_param_ops
definitions to use these macros, in preparation for migrating to a
seq_buf .get API.

Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/moduleparam.h | 36 ++++++++++++++++++++++++++++++++++--
 kernel/params.c             |  6 ++----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 075f28585074..26bf45b36d02 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -68,6 +68,39 @@ struct kernel_param_ops {
 	void (*free)(void *arg);
 };
 
+/*
+ * Define a const struct kernel_param_ops initializer. Callers prefix with
+ * any required visibility qualifiers (typically "static"):
+ *
+ *   static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);
+ *
+ * Routing the @_set and @_get function pointers through the macro
+ * (rather than naming the struct fields at every call site) lets the
+ * field layout change in one place when callbacks are migrated to a
+ * new signature.
+ */
+#define DEFINE_KERNEL_PARAM_OPS(_name, _set, _get)			\
+	const struct kernel_param_ops _name = {				\
+		.set = (_set),						\
+		.get = (_get),						\
+	}
+
+/* As DEFINE_KERNEL_PARAM_OPS, with KERNEL_PARAM_OPS_FL_NOARG set. */
+#define DEFINE_KERNEL_PARAM_OPS_NOARG(_name, _set, _get)		\
+	const struct kernel_param_ops _name = {				\
+		.flags = KERNEL_PARAM_OPS_FL_NOARG,			\
+		.set = (_set),						\
+		.get = (_get),						\
+	}
+
+/* As DEFINE_KERNEL_PARAM_OPS, with an additional .free callback. */
+#define DEFINE_KERNEL_PARAM_OPS_FREE(_name, _set, _get, _free)		\
+	const struct kernel_param_ops _name = {				\
+		.set = (_set),						\
+		.get = (_get),						\
+		.free = (_free),					\
+	}
+
 /*
  * Flags available for kernel_param
  *
@@ -311,8 +344,7 @@ struct kparam_array
  * kernel_param_ops), use module_param_cb() instead.
  */
 #define module_param_call(name, _set, _get, arg, perm)			\
-	static const struct kernel_param_ops __param_ops_##name =	\
-		{ .flags = 0, .set = _set, .get = _get };		\
+	static DEFINE_KERNEL_PARAM_OPS(__param_ops_##name, _set, _get); \
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg, perm, -1, 0)
 
diff --git a/kernel/params.c b/kernel/params.c
index 752721922a15..2cbad1f4dd06 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -222,10 +222,8 @@ char *parse_args(const char *doing,
 		return scnprintf(buffer, PAGE_SIZE, format "\n",	\
 				*((type *)kp->arg));			\
 	}								\
-	const struct kernel_param_ops param_ops_##name = {			\
-		.set = param_set_##name,				\
-		.get = param_get_##name,				\
-	};								\
+	DEFINE_KERNEL_PARAM_OPS(param_ops_##name,			\
+				param_set_##name, param_get_##name);	\
 	EXPORT_SYMBOL(param_set_##name);				\
 	EXPORT_SYMBOL(param_get_##name);				\
 	EXPORT_SYMBOL(param_ops_##name)
-- 
2.34.1


