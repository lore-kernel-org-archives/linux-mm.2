Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4DDCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83BA98E0022; Tue,  9 Sep 2025 16:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2DA8E0019; Tue,  9 Sep 2025 16:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D518E0022; Tue,  9 Sep 2025 16:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0D28E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1784EBA2EF
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:56 +0000 (UTC)
X-FDA: 83870817912.23.F139B21
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A4BB40013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=l4FamUPe;
	spf=pass (imf11.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK7bLUEvESp+m8RqUZl4D2oF/6AN2tNxcr+b8tCSt7Y=;
	b=ft5do+b1yTNhQtdzRQruiys5yxnp0j6+XxSfh7j061YZt4TG7YqYTLzmoXHbeRSg08lc1r
	2fzaVksewSCRKZsQHMxBoSuSRdsBl8I8tWyqlJXWlhFa0DC9ID6nsio1xYz97FueEoAfJE
	MnWtzzVV6AC0PA0UNtMQ2UbGz0HvtN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448954; a=rsa-sha256;
	cv=none;
	b=OIsGgdL/BBp2OXjE3Ru5fWIvwPRqxkXw/n3Qf6kxCSqpBi1xNR3kAvpaUzsERLGI2nV90p
	uLmK0IaUveRH7rARAEndjevuaI9U2hhimE5oAnBK2X3E1MHE3o0FBHVHkVyJstg34Q7hAu
	945TtAkBr+xXl8VES3glzeXe/ARBIhQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=l4FamUPe;
	spf=pass (imf11.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id B39CEC01AD;
	Tue, 09 Sep 2025 23:15:52 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-oPNV4RHQ;
	Tue, 09 Sep 2025 23:15:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448952;
	bh=XK7bLUEvESp+m8RqUZl4D2oF/6AN2tNxcr+b8tCSt7Y=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=l4FamUPeJH/2K/fFm2QGMJdf/TMdhmYBjUawutzSIHby3gBQ+B3lL6Wpkipkd3fLk
	 sO7XVN91XoNbPqj1vqL3ON/aoQC2y44btVzcMZvR9PS7PeLW6Skpxltn0hYiO0//xU
	 NrpO3fwIt5K0uRDNB2l2en+/J4pNiYdBXZUszQRk=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 7/7] Documentation, kstate: Add KSTATE documentation
Date: Tue,  9 Sep 2025 22:14:42 +0200
Message-ID: <20250909201446.13138-8-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A4BB40013
X-Stat-Signature: 8bpuma1ckb5wrsobiky74fu6krf5symn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757448953-782883
X-HE-Meta: U2FsdGVkX1+MexpDYY0oRI2jzTo3acMt0NNfk4fxVS2zIJV5GtUN3Z3+p6VS8PWRLqQlSFnET85T1zaZqUJ7aQAx85Nxdxjd/vmM6jHhV4KGjwiQe7wnsA7VYDA70Wlo9V1MKnZcaLLV4xGiRU/CLV/N6+siNeHIIUc0AT0oVC7frS37gOSsQZONAmT9/I9ohhRhxhRjO+wexJMpbui8+/TCR59qnofn8KFO0aSXhSkZHMzTu4Z0lQ7iJFsrMYYApVxV2Dq6Gu9mwtMvK+y9wdctZmsgbL9uOBr/7s/fFIhf0/MzyK8eMT2likoU1rMbl+cwrp0Iqookbu0vKZ4cYCOncMmcJf+417t01QYwGqCvx2boCOpfqNtMJ5DipC4Onx6XmY8T59Hp6iL5rE+jecfDesU1Vrs0fixAblVdIdLlKI7yWl2ZgwC+jVKkg1TW76Q1uzUVoUnSXTt05/r283f1RyWOzVv3B9eTapMKuPGKI5bHxCeNGcZRmoCZ5HN1B1Nu4kDQ/qzh8UoGWDO2TTBgqKlt8nquKFohrvjnGq7+xQhJ5a3UbnGIUvJtuxCjqUphnVfHLF/mIi4o3QTlIjKw+guOh8RmVUkWWZ/mU5+fNG0RyepkKmU7empHKXF0EPjQL5jfHuwXDprD7jgQi8dOZQz6A+TG59b2w0/BVKAGmQsjw2r1/E8M9QcgJVKZn3LAoPG+7yBcLtS2/TbYtozZ99IDVlELpzjxVuVlXHUgZIIphcYmG/1YoY7Zb5EFG7ttkpBXRq0OyyE0jzcyW8YgFqkAb7zlQWszvD55EfV/+F47Qi5nc0H8R0K6QgYcJ97s/As81/Gwdk0DWHVZ0Lv6VF3klcgdADJaSNusZ8BQPQ9CWYrrFs9MKM6c34sJ1+gDaJKxckoerDnB+heAYsFNKpLHnGvfNJaLCL4pZuaw/+8KusVPRMuRVPbUW1hJu+OqdYG/K0qQNfSVob+
 /rY+6V3C
 w8XmlC1lzAJQl0spp37odtYP3xmqUvNlWKyvkIpudcE02KZsPVm5sqUV7FGozXXszkUMwHm4De3vvjMC45r5NSFwf6OsmSkT+KOBF3qMufIKXmCwwOBcU2CaMu4AyYoRk1mR2sGsOv99vfZZ7jt6IFyA/0RoK+/zxeXj0ANdP6RVMuDVaE0J1YwvcDqpVtBeEhm6Hdz87xqZJxPeyEcPWL4/U8a+AljhR9/ZRD8i9ExZ6kofEPvTRljJRMb5h5ar1acLhMHJiPtPUXjtlJhtLEHZwkhiUvqwfo7LCKabE11GcuMBM0f1STKKr6qSnhVkCrCGBwqA+97MVpBGMelt0wAblWC2i6jJw3dFNTWvpsXgP7/FUdCHRyWeotIHZUDM2MnVHSRzihzYGBbcxRjOKIsne293nyem10W1fcOkNubTh1jyuYCq+CuiqLqNEczOnZMQ0DyFkZX3cDVeeow70bdIGH7wcJXDe2YxX8qr7IxdesoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KSTATE doc. Describe 'struct kstate_description' and information
about versioning fields.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 Documentation/core-api/index.rst  |   1 +
 Documentation/core-api/kstate.rst | 117 ++++++++++++++++++++++++++++++
 MAINTAINERS                       |   1 +
 3 files changed, 119 insertions(+)
 create mode 100644 Documentation/core-api/kstate.rst

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index a8b7d1417f0a..6c0466e0bb35 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -136,6 +136,7 @@ Documents that don't fit elsewhere or which have yet to be categorized.
 .. toctree::
    :maxdepth: 1
 
+   kstate
    librs
    liveupdate
    netlink
diff --git a/Documentation/core-api/kstate.rst b/Documentation/core-api/kstate.rst
new file mode 100644
index 000000000000..981ba162109c
--- /dev/null
+++ b/Documentation/core-api/kstate.rst
@@ -0,0 +1,117 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KSTATE: Kernel state preservation framework
+===========================================
+
+KSTATE (kernel state) is framework to migrate some part of the internal
+kernel state (device driver, memory, etc) from one kernel to another across
+kexec reboot.
+
+kstate_description
+------------------
+
+Most kernel's state is in structs and structs could be described by
+kstate_description. E.g.
+
+struct kstate_test_data {
+	int i;
+	unsigned long *p_ulong;
+	char s[10];
+	struct folio *folio;
+};
+
+struct kstate_description test_state = {
+	.name = "test",
+	.version_id = 1,
+	.id = KSTATE_TEST_ID,
+	.fields = (const struct kstate_field[]) {
+		KSTATE_BASE_TYPE(s, struct kstate_test_data, char [10]),
+		KSTATE_POINTER(p_ulong, struct kstate_test_data),
+		KSTATE_FOLIO(folio, struct kstate_test_data),
+		KSTATE_END_OF_LIST()
+	},
+};
+
+Changing data structures
+------------------------
+
+KSTATE saves/restores structs as a series of fields. When the kernel structs
+are changed we may need to change the state to store more/different information.
+
+Versions
+--------
+
+Version numbers are intended for major incompatible changes, that are not
+backward compatible.
+
+Each version is associated with a series of fields saved. The state is always
+saved as the newest version specified by ->version_id.
+But loading state sometimes is able to load state from an older version.
+
+There are two version fields:
+
+    - version_id: the maximum version_id supported by kstate_description.
+    - min_version_id: the minimum version_id that given kstate_description is able to understand.
+
+KSTATE is able to read versions from minimum_version_id to version_id.
+
+There are _V forms of many KSTATE_ macros to load fields for version dependent fields, e.g.
+
+	KSTATE_BASE_TYPE_V(i, struct kstate_test_data, int, 2),
+
+only loads that field for versions 2 and newer.
+
+Saving state will always create a section with the ‘version_id’ value and thus can’t
+be loaded by any older kernel.
+
+Removing field
+--------------
+If field is no longer needed it could be marked deprecated using
+KSTATE_*_DEPRECATED macro and bumping ->version_id of kstate_description:
+
+	KSTATE_BASE_TYPE_DEPRECATED(k, u16, 1),
+
+The last parameter of the macro is the last version number that have this field.
+Old kernel will save such field, but new kernel will skip it on load. Also
+the new kernel will not save such field (as there is nothing to save).
+Such change is not backward compatible.
+
+Adding new field
+----------------
+
+Addition of new field can be done as version dependent field by using _V form of
+KSTATE_ macro:
+	KSTATE_BASE_TYPE_V(i, struct kstate_test_data, int, 2),
+
+This indicates that 'test_state' only from version 2 and above have field '->i'.
+If new kernel sees incoming 'test_state' of version 1 it will skip restoring '->i'
+as nothing was saved. This is not backward compatible, as old kernel doesn't
+understand the new V2 'test_state'.
+
+Subsections
+-----------
+Another option is adding subsection to kstate_description. A subsection is
+additional kstate_description which linked to the main one:
+
+struct kstate_description test_state_v2 = {
+	.name = "test_v2",
+	.id = KSTATE_TEST_ID_V2,
+	.fields = (const struct kstate_field[]) {
+		KSTATE_BASE_TYPE(i, struct kstate_test_data, int),
+		KSTATE_END_OF_LIST()
+	},
+};
+
+struct kstate_description test_state = {
+	......
+	.subsections = (const struct kstate_description *[]){
+		&test_state_v2,
+		NULL
+	},
+};
+
+
+Subsection must have a unique ->id. If the receiving side finds a subsection
+with unknown id it will be ignored. This make subsections suitable for backward
+compatible changes (migrate from N+1 to N kernel) assuming old kernel is ok without
+information in subsection.
diff --git a/MAINTAINERS b/MAINTAINERS
index e96da6d97e75..a9baf49cdbeb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13721,6 +13721,7 @@ F:	include/linux/ks0108.h
 KSTATE
 M:	Andrey Ryabinin <ryabinin.a.a@gmail.com>
 S:	Maintained
+F:	Documentation/core-api/kstate.rst
 F:	include/linux/kstate.h
 F:	kernel/livupdate/kstate.c
 F:	lib/test_kstate.c
-- 
2.49.1


