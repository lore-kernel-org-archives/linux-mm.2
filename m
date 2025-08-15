Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAF2CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CC790022C; Fri, 15 Aug 2025 05:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D3E8E0002; Fri, 15 Aug 2025 05:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B1C90022C; Fri, 15 Aug 2025 05:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 032258E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2630C091D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:47 +0000 (UTC)
X-FDA: 83778396534.12.9BD5F6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2867F140009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1a9WkvtlFuudKbRk3/HnDrqSKmv2hnJGHHDj6ZZi/pM=;
	b=j8yV2wnJLdugmhaQwSpMioi1ghm/tf3M4fT1fwjYSHu+dxFbWlLWVf0QN2UodwVTij4+vI
	fRPY9tKkleBjQsuVE1FQ0pBJp2BaWlaUAT4mXSEFUH5bNmW1OTJGbk0vghlMjQLQyV1Eiv
	SB3PABBuIJNtqlYR5kY7QUYBGOdEpvg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248446; a=rsa-sha256;
	cv=none;
	b=pmqdZ8o+XTbLZf68Cviw+tS3uDEqbuFr+CdYH6zhZJthOjG8urSCH0tP5PhA190J72UM7Y
	cZZ1dDMeaYQZh9terSN4QFV2KwmzTw+DzxPs1IdYmKb4pf8FkpvRJX0KEu3xKsjKgtglW0
	4O/17GQEJwlc4I1L0ZO/9JwkTWvMqrU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43FF02D8E;
	Fri, 15 Aug 2025 02:00:37 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AC283F63F;
	Fri, 15 Aug 2025 02:00:40 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v2 8/8] mm: Add basic tests for kpkeys_hardened_cred
Date: Fri, 15 Aug 2025 10:00:00 +0100
Message-ID: <20250815090000.2182450-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2867F140009
X-Stat-Signature: d1xzekw7ngtxgorisgriq35hn3z6oq1p
X-Rspam-User: 
X-HE-Tag: 1755248445-142056
X-HE-Meta: U2FsdGVkX1/DuM5r67uF7UvD2ytx2P+3t01GH+ua7GeABsrEJTqIDfHkz1q9HN9qiu0k2q6Zek1ZGutULc1QlV9JKCixEE+N2b3peUA6zitzvdTcq4/Z/WXTx5ax/B/zK/rBkltviHCLDj2xzGkGd3wPCnNyN+r6en/4a9WIda29qBqZqzUVja4vh8HqTSqVe3XBjE8Rgm9kyWZLtCylVQq+ukFOu8Ou2lZEoMUW9WQKaru6m4TD0fUZyVFSpexem5vy3EbVyhFCv46VxZnMvkNCWyIwqkqztv0dkDw2hmmzEqH/5JiO+lXDZQ5qTEsnTxODK+ZHTNiCY3Pw5AgXdPT/pRFh4+3x3SwGq6jCWjA4PZ+ozifuQ+tylYKjJzFpXmnVg8mBDtKfwTDj2GeDT6V17OMr6DDhFplq1XB2YyF7nX1pRlpIlX5hg4G2lzE4O5f4AXxpGc2f/kNIpY0Jinphn61mCZhJmHni8oDJ967v245HWOvR89zlsYso2VdS1Jn31HQoLV+X4ra45sa0HbRUEG6fQfO8PXqLRHJY65+rc8f5xz+3TrBkghdOS40X8Ag1GpK0ITn/BRelaZtpw0iA20SSjFPKj71e4ZOCfVITa4ABPvDbukLYKX9ANttgj9nseqOcQjN6aJtDQmzrpNjGu78h6nJilXhh6FuZDIO6E024gZ7P3r0AVv4OUmEFyd8vTk8xjs3ggSGAN9zzNgwAWZBrhfm4PA2RCZQS5YdDjlXZE6VYh6wP1so3cOLrWqUdSjbXKFwj2PbzPARO1aMUrKAd7pih932ZeDRno6pFgOsY4Q/hhWLHKwDH33pThhAw6wOWvEIwuhOb2oy3Ky5jclYwHgEdzfV91nl7Xh45tKGYHG/4v6rfgMyl/lXnnVrTZJ6wzsAD/re3adKhReBIWgKzvutRzsC9qEbPb7aXytoNnfVDLcqTekKbcxWn1W2jrn7+4ynuR16Svkg
 4w36u0m3
 zpI8lPyFI7ua0Ij67lZhsLcK8aIxjpDylgg9Iq8nASPvWGZNIzY+S9rE+rUNr48gPd2HhqOzCvy3mxSQe1AnZDvs6MDBFIA7ID6/HwwlOTaWrcE95oI/FYUnPsCWcjT1FBaH/cdw8zD11eujeSy4ROzT19jsLle6UQbbcfJMKPCg3vPV6lrFJpeJimVW5zZhPANO/FHJh4e258pV1KyPikKHuMqiLmokHWwJ5ZXlRRZ4LWGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic tests for the kpkeys_hardened_pgtables feature: try to
perform a direct write to current->{cred,real_cred} and ensure it
fails. Also check that prepare_creds, protect_creds,
prepare_protected_creds behave as expected.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/Makefile                           |  1 +
 mm/tests/kpkeys_hardened_cred_kunit.c | 79 +++++++++++++++++++++++++++
 security/Kconfig.hardening            | 11 ++++
 3 files changed, 91 insertions(+)
 create mode 100644 mm/tests/kpkeys_hardened_cred_kunit.c

diff --git a/mm/Makefile b/mm/Makefile
index b1e6cf7f753c..c79af57c0aa5 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -149,3 +149,4 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
 obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES_KUNIT_TEST) += tests/kpkeys_hardened_pgtables_kunit.o
+obj-$(CONFIG_KPKEYS_HARDENED_CRED_KUNIT_TEST) += tests/kpkeys_hardened_cred_kunit.o
diff --git a/mm/tests/kpkeys_hardened_cred_kunit.c b/mm/tests/kpkeys_hardened_cred_kunit.c
new file mode 100644
index 000000000000..ed07469b504c
--- /dev/null
+++ b/mm/tests/kpkeys_hardened_cred_kunit.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/cred.h>
+#include <linux/sched.h>
+
+static int increment_cred_uid_nofault(struct cred *cred)
+{
+	uid_t val = __kuid_val(cred->uid) + 1;
+
+	return copy_to_kernel_nofault(&cred->uid, &val, sizeof(cred->uid));
+}
+
+static void write_current_creds(struct kunit *test)
+{
+	int ret;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	ret = increment_cred_uid_nofault((struct cred *)current->cred);
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Write to current->cred wasn't prevented");
+
+	ret = increment_cred_uid_nofault((struct cred *)current->real_cred);
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Write to current->real_cred wasn't prevented");
+}
+
+static void write_new_creds(struct kunit *test)
+{
+	struct cred *cred, *protected_cred;
+	int ret;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	/* prepare_creds() + protect_creds() */
+	cred = prepare_creds();
+	KUNIT_ASSERT_NOT_NULL(test, cred);
+
+	ret = increment_cred_uid_nofault(cred);
+	KUNIT_EXPECT_EQ_MSG(test, ret, 0,
+			    "Failed to write to unprotected creds");
+
+	protected_cred = protect_creds(cred);
+	KUNIT_EXPECT_PTR_NE_MSG(test, cred, protected_cred,
+				"protect_creds() failed to move creds to protected memory");
+
+	ret = increment_cred_uid_nofault(protected_cred);
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Write to protected_cred wasn't prevented");
+
+	put_cred(protected_cred);
+
+	/* prepare_protected_creds() */
+	protected_cred = prepare_protected_creds();
+
+	ret = increment_cred_uid_nofault(protected_cred);
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Write to protected_cred wasn't prevented");
+
+	put_cred(protected_cred);
+
+}
+
+static struct kunit_case kpkeys_hardened_cred_test_cases[] = {
+	KUNIT_CASE(write_current_creds),
+	KUNIT_CASE(write_new_creds),
+	{}
+};
+
+static struct kunit_suite kpkeys_hardened_cred_test_suite = {
+	.name = "Hardened credentials using kpkeys",
+	.test_cases = kpkeys_hardened_cred_test_cases,
+};
+kunit_test_suite(kpkeys_hardened_cred_test_suite);
+
+MODULE_DESCRIPTION("Tests for the kpkeys_hardened_cred feature");
+MODULE_LICENSE("GPL");
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index cb494448c7ae..7ceb1e6846f2 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -302,6 +302,17 @@ config KPKEYS_HARDENED_CRED
 	  This option has no effect if the system does not support
 	  kernel pkeys.
 
+config KPKEYS_HARDENED_CRED_KUNIT_TEST
+	tristate "KUnit tests for kpkeys_hardened_cred" if !KUNIT_ALL_TESTS
+	depends on KPKEYS_HARDENED_CRED
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to check that the kpkeys_hardened_cred feature
+	  functions as intended, i.e. prevents arbitrary writes to live credentials.
+
+	  If unsure, say N.
+
 endmenu
 
 config CC_HAS_RANDSTRUCT
-- 
2.47.0


