Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BAA9CD5BBC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20FB6B009B; Thu, 21 May 2026 09:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984406B009F; Thu, 21 May 2026 09:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6049A6B009D; Thu, 21 May 2026 09:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 479596B009B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:33:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BB06140668
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:34 +0000 (UTC)
X-FDA: 84791519148.20.E214E30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E6D2180012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsMbrSfw;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D92GfeXfztwtGh+NKFXW+ejJ7GCi/ckBt7Icqwg1tfs=;
	b=UGRUMwZ6Hx1JzsqMM1mAkUduuOlFuzah41Zxz2UYQqRRfBAjot6isxaxTVJbTQloquSQzN
	DntckKEwRiGtuyxG1KHTBZfnYEBLd0cvXvhbwwQ5fCZ2CdvkX/EaM4Il9TGAoLqr8xB7ja
	wpErPjUbbzfFmI16+BaSVC/7LT3+Hqk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsMbrSfw;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370412; a=rsa-sha256;
	cv=none;
	b=VTzlFtwscCphLeL8SCnaHqbKmJjbfkK4+YFRrIUQN+LzNXOZHbT+OXMXZrvAWq5Piim+DR
	e4GJt7l/VwB9liliZOKHdqJaRJ981bWhcOWpgQSZ77jjLIl7owD6odu0YtGSh2FKsiDlkK
	+5dKC6OGrOt7mbGYf+KQh7v42h5vhNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2528444628;
	Thu, 21 May 2026 13:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F301F00A3B;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370406;
	bh=D92GfeXfztwtGh+NKFXW+ejJ7GCi/ckBt7Icqwg1tfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsMbrSfwtX1kazk5IQM74ggG4Dvao03ITo2rB7fjYJyw9ABWXfqI+9aA5qAj2SR/5
	 bCJNN1CMD9hyb5ppglH/pZwAMSiek0jplgAMqEVVQL5JpcL8KAc0T0+rQaEkPfLgZJ
	 h9CesS2RNlFMe0lhxQwlPJ5aoyzt8jSouyNeQ/ut9fjkrIWPM1iotTIo8B7ZH0pEOt
	 PXBO5iwh3tZMUmZ6TsOUjTCKa3JTEC0MG2ngQVnXCKyNc+yajzL20Z6iBGWjesqILa
	 wl9GSf1Gtg2R6s/MvPcceAUrPZB+a/bbJr58Jk3b4DpNimJFAtwQW4sG1Fmcwkxlwv
	 gBE9pRr5KxqXg==
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
Subject: [PATCH 05/11] moduleparam: Rename .get field to .get_str
Date: Thu, 21 May 2026 06:33:18 -0700
Message-Id: <20260521133326.2465264-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3072; i=kees@kernel.org; h=from:subject; bh=vLGSuUHmnLi1/YHHelOJK4C4TcXRiKv4YFWn5np0glM=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nAsD4o0V/uTmcB53njx1B6e/bj7HRgn2VXOEOnsWp wZ2X7zWUcrCIMbFICumyBJk5x7n4vG2Pdx9riLMHFYmkCEMXJwCMBEONkaGy7PKr73Ur1Czz5B6 etdJJuEbm4bhmk/7zrsdOuT8PYl9KSPDwTtq/fyyAtr+f2YaPvkpdWtWnGfLNNfmFeI5M+tXlVf wAAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E6D2180012
X-Rspam-User: 
X-Stat-Signature: 1176311mefr1x6fyugk58eepdjg6gb17
X-HE-Tag: 1779370412-943965
X-HE-Meta: U2FsdGVkX1/+qhlYL0LXQiNvZBsoY1cE40aPXkCB96AuhcorhrF/Z8bXlzlyU7KSLkMYBRdGJt9VTXi7SktyxkdMWbop1T0tf2EkzM4N7WleS9Jb6GmyOEGKd7jsbMvR02vHNyZcB2It3uAvVezp/9tzTStdiDPkRK+b2RohqOmsaJW5EJxfWEHtbgBd8LNqFHZgTLjZcxcxPcpdtPTm31zMCntOGkaZO8IqrlGA0uI8ugvoPIIBIrkMbzcp0i/kyM70Ui5dRmBNfBXqMlV0VpllegsvKpHgb+1jA5kbjkU/6viSDO1Oi3qyNElKp8lNQauP+/m1N8sBP1yh5JkSyE7wn+jkpAxtvw69iJgohCiKp5HPOKkJPsigoOYGfzX582yQZTZL3ZGWrDGrFvZpZTxD+6T8JTWQl4diVwP649JCRDQv8Sq9k5faEBn+nT8ZT2Ty7L3epG8JV7nAJjKBwSrMUjhQVb8SvTSxvgZv2pjxZ7O0hbms0h+qzSGkFlQB5iyuGfWuxP6CCXwGhR5fhbbr4xJ6P/MWaa6l7O0JUS5Gxb5+ndy9L8KqeYRUlHl3iRdvPwlNYLYeN7ZzhwwdcJH2sE8L9uXnlImC4vZMzK3oDF5MkbU7rU6W/gmDajfe8HvVwDiGWGcANycYidmmevlhmFmHEAOTde5ROu7aqBrvnrls/jSWdkFIBiGu9J/m0xXecqy+ITAZabo2KgG3o5XIV5MjGVCAzkfjEJWXfvS+h8h94vpeCmwuvTBxS/keR1IqqEl9FPfKkqH8GsAQSw8gPWB90LF6M0bNMOif4G+f07PQfUjuSxMZDx6l6DMUIgck8yn2DSHBGY31KghCOpk/pt1PGQ6ntitcuNbWfNJezJskn0CFskIMkr5y3gwpamse6osjlCS5kuYb9+a4vNMd3RL0pYb/9owRrU4DVSlzvoiwex1litRUIJNtohHJodwnz6ohVJKZVZ1zjBG
 aNGGZcVA
 Zq5RCSS9kwyMheBaEuImp9tJjn1IsVIgVAD5XtTMY3C133+SvFQkVn0WR/9GQLLeUkoDXSroJ1wX4+zAwkvFgghTFBBrYhnx4Y1KOl7oFRBjciYYoRr0zWcATAnTryjP0uNeFmnuDrY/pG0IdPv922r4QAqzqpJnGwuq29rJVpt9tzTwfnn8qyKu4CSwgOcEwdp7fR3MeGD5GhstHUrdNV8sttWl0hpVjBDGPV4d8p2M4iteVoVqTFJ6zu0buLakp7W50N4XpStegrqYJamNOX803j6JsO/Orsfk8vizuODBY0jf5OjjYuJgUMK3tkyvtGKvkHm5BZHcDxFgnICc82ZnQTHXD9/TwJEEn9iakeMcl6ZOls0uCk5jl7k0zjpxRKOqL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that every kernel_param_ops initializer in the tree goes through
DEFINE_KERNEL_PARAM_OPS, no source file outside kernel/params.c and
include/linux/moduleparam.h references the .get field by name. Take
advantage of that to rename the field to .get_str.

The bare .get name is now free for the next commit, which adds it
back as a struct seq_buf *-based callback.

Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/moduleparam.h | 8 ++++----
 kernel/params.c             | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 26bf45b36d02..f5f4148e2504 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -63,7 +63,7 @@ struct kernel_param_ops {
 	/* Returns 0, or -errno.  arg is in kp->arg. */
 	int (*set)(const char *val, const struct kernel_param *kp);
 	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
-	int (*get)(char *buffer, const struct kernel_param *kp);
+	int (*get_str)(char *buffer, const struct kernel_param *kp);
 	/* Optional function to free kp->arg when module unloaded. */
 	void (*free)(void *arg);
 };
@@ -82,7 +82,7 @@ struct kernel_param_ops {
 #define DEFINE_KERNEL_PARAM_OPS(_name, _set, _get)			\
 	const struct kernel_param_ops _name = {				\
 		.set = (_set),						\
-		.get = (_get),						\
+		.get_str = (_get),					\
 	}
 
 /* As DEFINE_KERNEL_PARAM_OPS, with KERNEL_PARAM_OPS_FL_NOARG set. */
@@ -90,14 +90,14 @@ struct kernel_param_ops {
 	const struct kernel_param_ops _name = {				\
 		.flags = KERNEL_PARAM_OPS_FL_NOARG,			\
 		.set = (_set),						\
-		.get = (_get),						\
+		.get_str = (_get),					\
 	}
 
 /* As DEFINE_KERNEL_PARAM_OPS, with an additional .free callback. */
 #define DEFINE_KERNEL_PARAM_OPS_FREE(_name, _set, _get, _free)		\
 	const struct kernel_param_ops _name = {				\
 		.set = (_set),						\
-		.get = (_get),						\
+		.get_str = (_get),					\
 		.free = (_free),					\
 	}
 
diff --git a/kernel/params.c b/kernel/params.c
index e19fff2926bc..6852caea1785 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -467,7 +467,7 @@ static int param_array_get(char *buffer, const struct kernel_param *kp)
 	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
 		p.arg = arr->elem + arr->elemsize * i;
 		check_kparam_locked(p.mod);
-		ret = arr->ops->get(elem_buf, &p);
+		ret = arr->ops->get_str(elem_buf, &p);
 		if (ret < 0)
 			goto out;
 		ret = min(ret, (int)(PAGE_SIZE - 1 - off));
@@ -554,11 +554,11 @@ static ssize_t param_attr_show(const struct module_attribute *mattr,
 	int count;
 	const struct param_attribute *attribute = to_param_attr(mattr);
 
-	if (!attribute->param->ops->get)
+	if (!attribute->param->ops->get_str)
 		return -EPERM;
 
 	kernel_param_lock(mk->mod);
-	count = attribute->param->ops->get(buf, attribute->param);
+	count = attribute->param->ops->get_str(buf, attribute->param);
 	kernel_param_unlock(mk->mod);
 	return count;
 }
-- 
2.34.1


