Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC86CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098CB8E001E; Tue,  9 Sep 2025 16:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021A78E0019; Tue,  9 Sep 2025 16:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C988E001E; Tue,  9 Sep 2025 16:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C74008E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5850A140591
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:40 +0000 (UTC)
X-FDA: 83870817240.15.DD2526B
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43F80180014
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b="LLoW/OFB";
	spf=pass (imf16.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c7esRNmCAfQ76UO4jeOQ25FDN89DzqZ6jGwQAoMGHI=;
	b=Dpmk5lK0wBpsUUGXznjB1gnXOQw8VYhKi5kBx7pYzShelzdZvOfuDklcl4AHQYhm9CevWO
	PUudKL+JmrBg9FroACcNTNBM4YIWSNUaSSyyXD6fDitzkwovF7onzfp+cO9za2Kfj6WW/d
	uabjWMtv2RPRCrvemoBIudQCFIPnk1U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b="LLoW/OFB";
	spf=pass (imf16.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448938; a=rsa-sha256;
	cv=none;
	b=6+0QbkL6XpgFKhK0+uJ0EPlFRoj83G8rp3+GOqMMu1yX4jCw4rgqMm+trYHniMfbs+eaCp
	1UEqUMztKZtTRTnI84SDLSXVU8hlpu5GsWGVE1Es1OvxIPufWJ8Wr4QKdcoh8KeIXxmqna
	z5/pH20Hd8eWclBs/8hxjGvtnwrwwvA=
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id E4B18C0199;
	Tue, 09 Sep 2025 23:15:36 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-2VgA54Rz;
	Tue, 09 Sep 2025 23:15:35 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448936;
	bh=/c7esRNmCAfQ76UO4jeOQ25FDN89DzqZ6jGwQAoMGHI=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=LLoW/OFBYKbCw94LOyHDEROGdNEcEyETC7TmDLkpL6I/LhPNow0PEUvnd9LvLNw89
	 Tykobr/CP5UErMO/llY79wJUvHBeWNdzN+kHlX5x9MYt+1v4PM15zUNFJ1+z8jeaou
	 NGpLeCf3nkbl+5SCzmakKg9vcr9pPJ7uX92d3d5U=
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
Subject: [PATCH v3 3/7] kstate: Add KSTATE - [de]serialization framework for KHO
Date: Tue,  9 Sep 2025 22:14:38 +0200
Message-ID: <20250909201446.13138-4-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43F80180014
X-Stat-Signature: udoiuiz313inr1f6zdcchxdwrnqjc7pr
X-HE-Tag: 1757448938-145399
X-HE-Meta: U2FsdGVkX1+Zlad1dZX5CLyq1dI6trYwcBx7DxZFL8930pUYXNQkQM2VVtgJz25CCHppet+YZE+FRt2y9SK9E0R/1JjdZhgttK3gliRjwta5pAeZSIFhTFE/63p1CDazIS+PrSI+/VHr4Yz+HZQWhkrQIFTPV2SRHCGQeQy1wFC7+2sP17fCGZpmQKdGHWyBeA6TFsmydRyKK96h+hwPyL3TyS8LlDqnCLA3uKyTU19X51Xrm7c+AS9Jxuzl42xgYeXH7vVi6ik2tnm+ZRhCChBVxRjkDLffrCiL6VVmewBuTFTSSuH+pDPOOQjstDLM4K4lUSx9LjZdbtG2MnNvETHAlATP3hmv6DAI8d+v1G3vwbgioI0qBfUp6QsEsNN9LoYvRyXKdmwgiFdnd0ngSIaDx6la1yepxLVb+y7dEwXnPgT6EPHZr2WXYqm3sgoAW49sz3/NpnV4MWL71HjwgneOuxmVCKb4XFFpufqxtkOFH8ZzpOkI/+euNaQ8wWm1Kn85s8/1epxBSA/3HX4QBDLPtwIjepPIFSbK/L3oMtcPRzeHxyixX2piwu7PQt26Ji+KCBrqLKFHvbhhJmS+i++IZyxPSrSPeaNIxqiPIpa19mdhuBjctjizvgSiScOBJYFBRplHYgRuGKKPJhu8zEZuG/lTipLiw42I/ZYtStuZSF60RzPa9ySR7BVzGtydhKkgF4TgmPLoQl+1Z5SpGXrr3WrVBXVvov3gC5ORefa541Y4asWCxjyYg+GuQDR/fm1imvzTHN0OmhVVebt9WU+eU4+AYHfD2zPRAJKcMboGdqHmbQBitDLGVT0IPnibUmK13uShCWmAqQGZEJRPOHXZ+BWlvfhWfii3o24YM2nwo/kY2KjDZeLS+VYAdwbEV8MUeulqyCujoZQ9KoAL/2UFf82Llg98XLxyerEE8Kes7PB24LTHFb6ElfBFqCTA3maJCgmCpHXyns+8Y+A
 F/vi8mm+
 +gG1kQ8KvIPOVS5d6qSe1bIz0tgy6TACvfLzyo81uX9PFca0Nw/PpLHP6wmKuRux/hunc4VWZaHv2kMBC97j4Xdz9+RlcS8c29JWU0VnEs6OYUJJgh+wIUcbgc0+5nbtATIk03GLMzYSB8in5dl2Uxv4No1q+uHMZPmy/XNGnIzlKhFeoOmaPTTq19wk8iAJyNdfSOgTvRfvsqtxwr33wsVsx2DUGZxrlozRYTS0PMGnXqVXFroDJWl+sZsr531AFX89PZA7gkLppthkA//hNEYca/mPMkNHC+rRlfMzo9V9xb3ksKrAztCn9wzxqxLoT5E2kqmZW92X5jjTwIMjMQBygHHansI+uEZ4sPptrTRS2u+dWEGjeFQToyOtjcry3NENr9ofqHjSCkh1UxBmPW9v3xagwO+d6GvHG0cVD5TkyyJ15Cx99Izw9Fb9oVEfLm8H8i1iFjBvC3EBfqFN+w/VKopM7pCJLlOfONveWzHSKlL3tnjVTRbclCcHTUZicWyd1scqLq/6YV0kCbzKpEiWM5fIWlZ7p+hlMgsxLMK9JMROJJAFfOZv1t/yjlmLJzF5r/iByF/ZblMf/iVOuDdB7xeRqsyD0k3ewwrdP5XFnuL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KSTATE (kernel state) is a mechanism to describe some part of the internal
kernel state, save it into the memory preserved by KHO and restore the
state after kexec in the new kernel.

The end goal here is to be able to update host kernel under VMs
with VFIO pass-through devices running on that host. This implies that
we need svae/restore a lot different structs/state across different subsystems.
The purpose of KSTATE is to provide common infrastructure for saving/restoring
complex in-kernel states. Currently KHO uses FDT for that purpose, KSTATE
aims to provide easier for use alternative.

In this series KSTATE provides alternative to FDT usage in KHO, without
replacing it completely. So both can be used and FDT user can be converted
to KSTATE later if needed.

The idea behind KSTATE resembles QEMU's migration framework [1], which
solves quite similar problem - migrate state of VM/emulated devices
across different versions of QEMU.

State of kernel data (usually it's some struct) is described by the
'struct kstate_description' containing the array of individual
fields descpriptions - 'struct kstate_field'. Each field
has set of bits in ->flags which instructs how to save/restore
a certain field of the struct. E.g.:
  - KS_BASE_TYPE flag tells that field can be just copied by value,

  - KS_POINTER means that the struct member is a pointer to the actual
     data, so it needs to be dereference before saving/restoring data
     to/from kstate data steam.

  - KS_STRUCT - contains another struct,  field->ksd must point to
      another 'struct kstate_dscription'

  - KS_CUSTOM - Some non-trivial field that requires custom kstate_field->save()
               ->restore() callbacks to save/restore data.

  - KS_ARRAY_OF_POINTER - array of pointers, the size of array determined by the
                         field->count() callback
  - KS_ADDRESS - field is a pointer to either vmemmap area (struct page) or
     linear address. Stored as offset from the base address.

  - KS_END - special flag indicating the end of migration stream data.

kstate_register() call accepts kstate_description along with an instance
of an object and registers it in the global 'states' list.

During 'finalize' phase of KHO we go through the list of 'kstate_description's
and each instance of kstate_description forms the 'struct kstate_entry'
which save into the kstate's data stream.

The 'kstate_entry' contains information like ID of kstate_description, version
of it, size of migration data and the data itself. The ->data is formed in
accordance to the kstate_field's of the corresponding kstate_description.

After the reboot, when the kstate_restore() called it parses KSTATE's data
stream, finds the appropriate 'kstate_entry' and restores the contents of
the object in accordance with kstate_description and ->fields.

 [1] https://www.qemu.org/docs/master/devel/migration/main.html#vmstate

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 MAINTAINERS                        |   6 +
 include/linux/kstate.h             | 231 +++++++++++++
 kernel/liveupdate/Kconfig          |   8 +
 kernel/liveupdate/Makefile         |   2 +
 kernel/liveupdate/kexec_handover.c |   4 +
 kernel/liveupdate/kstate.c         | 536 +++++++++++++++++++++++++++++
 6 files changed, 787 insertions(+)
 create mode 100644 include/linux/kstate.h
 create mode 100644 kernel/liveupdate/kstate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8296bf89e040..2cd9e49abee5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13718,6 +13718,12 @@ F:	Documentation/admin-guide/auxdisplay/ks0108.rst
 F:	drivers/auxdisplay/ks0108.c
 F:	include/linux/ks0108.h
 
+KSTATE
+M:	Andrey Ryabinin <ryabinin.a.a@gmail.com>
+S:	Maintained
+F:	include/linux/kstate.h
+F:	kernel/livupdate/kstate.c
+
 KTD253 BACKLIGHT DRIVER
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
diff --git a/include/linux/kstate.h b/include/linux/kstate.h
new file mode 100644
index 000000000000..53992593cb19
--- /dev/null
+++ b/include/linux/kstate.h
@@ -0,0 +1,231 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KSTATE_H
+#define _KSTATE_H
+
+#include <linux/atomic.h>
+#include <linux/build_bug.h>
+#include <linux/list.h>
+#include <linux/stringify.h>
+
+struct kstate_description;
+struct kstate_stream;
+struct kimage;
+
+enum kstate_flags {
+
+	/*
+	 * The struct member at 'obj + kstate_field.offset' is some basic
+	 * type, just copy it by value. The size is kstate_field->size.
+	 */
+
+	KS_BASE_TYPE = (1 << 0),
+
+	/*
+	 * The struct member at 'obj + kstate_field.offset' is a pointer
+	 * to the actual data (e.g. struct a { int *b; }).
+	 * save_kstate() will dereference the pointer to get the actual data
+	 * and store it to the stream. restore_kstate() will copy the data from
+	 * the stream to wherever the pointer points to.
+	 */
+	KS_POINTER = (1 << 1),
+
+	/*
+	 * The struct member at 'obj + kstate_field.offset' is another struct.
+	 * kstate_field->ksd points to 'kstate_description' of that struct.
+	 */
+	KS_STRUCT = (1 << 2),
+
+	/*
+	 * Some non-trivial field that requires custom kstate_field->save()
+	 * ->restore() callbacks to save/restore data.
+	 */
+	KS_CUSTOM = (1 << 3),
+
+	/*
+	 * The field is a array of kstate_field->count() pointers
+	 * (e.g. struct a { uint8_t *b[]; }). Dereference each array entry
+	 * before store/restore data.
+	 */
+	KS_ARRAY_OF_POINTER = (1 << 4),
+
+	/*
+	 * The field is a pointer to vmemmap or linear memory (determined by
+	 * kstate_field->addr_type). This is used for pointers to persistent
+	 * pages/data. Store offset from the start of the area instead of
+	 * pointer itself, so we could defeat KASLR on restore phase (by adding
+	 * new kernel's corresponding offset).
+	 */
+	KS_ADDRESS = (1 << 5),
+
+	/*
+	 * The field used to exist in older versions. kstate_field->version_id
+	 * is latest version that have this field.
+	 */
+	KS_DEPRECATED = (1 << 6),
+
+	/* Marks the end of fields list */
+	KS_END = (1UL << 31),
+};
+
+enum kstate_addr_type {
+	KS_VMEMMAP_ADDR,
+	KS_LINEAR_ADDR,
+};
+
+struct kstate_stream {
+	void *pos;
+	struct folio *folio;
+};
+
+struct kstate_field {
+	const char *name;
+	size_t offset;
+	size_t size;
+	enum kstate_flags flags;
+	const struct kstate_description *ksd;
+	enum kstate_addr_type addr_type;
+	int version_id;
+	int (*restore)(struct kstate_stream *stream, void *obj,
+		const struct kstate_field *field);
+	int (*save)(struct kstate_stream *stream, void *obj,
+		const struct kstate_field *field);
+	int (*count)(void);
+};
+
+enum kstate_ids {
+	KSTATE_FOLIO_ID = 1,
+	KSTATE_LAST_ID = -1,
+};
+
+struct kstate_description {
+	const char *name;
+	enum kstate_ids id;
+	atomic_t instance_id;
+	int version_id;
+	int min_version_id;
+
+	const struct kstate_field *fields;
+	const struct kstate_description **subsections;
+};
+
+struct state_entry {
+	u64 id;
+	struct list_head list;
+	struct kstate_description *kstd;
+	void *obj;
+};
+
+static inline bool kstate_get_byte(struct kstate_stream *stream)
+{
+	bool ret = *(u8 *)stream->pos;
+
+	stream->pos++;
+	return ret;
+}
+
+static inline unsigned long kstate_get_ulong(struct kstate_stream *stream)
+{
+	unsigned long ret = *(unsigned long *)stream->pos;
+
+	stream->pos += sizeof(unsigned long);
+	return ret;
+}
+
+extern struct kstate_description page_state;
+
+#ifdef CONFIG_KSTATE
+
+extern phys_addr_t kstate_out_paddr;
+
+int kstate_save_state(void);
+void free_kstate_stream(void);
+
+int kstate_save_data(struct kstate_stream *stream, const void *val,
+		size_t size);
+void kstate_restore_data(struct kstate_stream *stream, void *val, size_t size);
+int kstate_register(struct kstate_description *state, void *obj, int id);
+void kstate_unregister(struct kstate_description *state, void *obj, int id);
+int kstate_restore(struct kstate_description *state, void *obj, int id);
+int kstate_register_restore(struct kstate_description *state, void *obj);
+
+struct kstate_entry;
+
+int kstate_folio_save(struct kstate_stream *stream, void *obj,
+		const struct kstate_field *field);
+int kstate_folio_restore(struct kstate_stream *stream, void *obj,
+		const struct kstate_field *field);
+
+int kstate_abort(void);
+int kstate_finalize(void);
+
+int kstate_early_init(phys_addr_t kstate_entries, u64 len);
+
+#else
+
+#define kstate_register(state, obj)
+
+static inline int kstate_save_data(struct kstate_stream *stream,
+				const void *val, size_t size)
+{
+	return 0;
+}
+static inline void kstate_restore_data(struct kstate_stream *stream, void *val,
+				size_t size)
+{
+}
+
+#endif
+
+#define KSTATE_BASE_TYPE_V(_f, _state, _type, _v) {	\
+	.name = (__stringify(_f)),			\
+	.version_id = (_v),				\
+	.size = sizeof(_type) + BUILD_BUG_ON_ZERO(	\
+			!__same_type(typeof_member(_state, _f), _type)),\
+	.flags = KS_BASE_TYPE,				\
+	.offset = offsetof(_state, _f),			\
+}
+
+#define KSTATE_BASE_TYPE(_f, _state, _type) \
+	KSTATE_BASE_TYPE_V(_f, _state, _type, 0)
+
+#define KSTATE_BASE_TYPE_DEPRECATED(_f, _type, _v) {	\
+	.name = (__stringify(_f)),			\
+	.version_id = (_v),				\
+	.size = sizeof(_type),				\
+	.flags = KS_DEPRECATED,				\
+}
+
+#define KSTATE_POINTER_V(_f, _state, _v) {		\
+		.name = (__stringify(_f)),		\
+		.version_id = (_v),			\
+		.size = sizeof(*(((_state *)0)->_f)),	\
+		.flags = KS_POINTER,			\
+		.offset = offsetof(_state, _f),		\
+	}
+
+#define KSTATE_POINTER(_f, _state) KSTATE_POINTER_V(_f, _state, 0)
+
+#define KSTATE_ADDRESS_V(_f, _state, _addr_type, _v) {	\
+		.name = (__stringify(_f)),		\
+		.version_id = (_v),			\
+		.size = sizeof(*(((_state *)0)->_f)),	\
+		.addr_type = (_addr_type),		\
+		.flags = KS_ADDRESS,			\
+		.offset = offsetof(_state, _f),		\
+	}
+#define KSTATE_ADDRESS(_f, _state, _addr_type)		\
+	KSTATE_ADDRESS_V(_f, _state, _addr_type, 0)
+
+#define KSTATE_FOLIO(_f, _state) {			\
+		.name = "folio",			\
+		.flags = KS_CUSTOM,			\
+		.offset = offsetof(_state, _f),		\
+		.save = kstate_folio_save,		\
+		.restore = kstate_folio_restore,	\
+	}
+
+#define KSTATE_END_OF_LIST() {		\
+		.flags = KS_END,	\
+	}
+
+#endif
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 5be04ede357d..b6ea861006bf 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -62,12 +62,20 @@ config LIVEUPDATE_SELFTESTS
 	  If you are unsure or are building a production kernel where size
 	  or attack surface is a concern, say N.
 
+config KSTATE
+	bool
+	help
+	  KSTATE (kernel state) is a mechanism to describe internal kernel
+	  state, save it into the memory and restore the state after kexec
+	  in new kernel.
+
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
 	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
+	select KSTATE
 	select DEBUG_FS
 	select LIBFDT
 	select CMA
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 9b8b69517463..0dc5122147d0 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -12,6 +12,8 @@ luo-y :=								\
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 
+obj-$(CONFIG_KSTATE) += kstate.o
+
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
 obj-$(CONFIG_LIVEUPDATE_SELFTESTS)	+= luo_selftests.o
 obj-$(CONFIG_LIVEUPDATE_SYSFS_API)	+= luo_sysfs.o
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a99425fdfce4..f1c6378b2657 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -12,6 +12,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/kstate.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
@@ -885,6 +886,9 @@ int kho_finalize(void)
 		ret = -EEXIST;
 		goto unlock;
 	}
+	ret = kstate_finalize();
+	if (ret)
+		goto unlock;
 
 	ret = __kho_finalize();
 	if (ret)
diff --git a/kernel/liveupdate/kstate.c b/kernel/liveupdate/kstate.c
new file mode 100644
index 000000000000..dde40899fd99
--- /dev/null
+++ b/kernel/liveupdate/kstate.c
@@ -0,0 +1,536 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/ctype.h>
+#include <linux/gfp.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/kstate.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+
+#define KSTATE_MAGIC 0x3B37778C
+
+static DEFINE_MUTEX(states_lock);
+static LIST_HEAD(states);
+
+phys_addr_t kstate_out_paddr;
+
+void *kstate_stream_addr;
+
+struct kstate_entry {
+	int section_type;
+	int state_id;
+	int version_id;
+	int instance_id;
+	int size;
+	DECLARE_FLEX_ARRAY(u8, data);
+};
+
+struct kstate_stream kstate_stream;
+
+enum {
+	KS_SUBSECTION = 1,
+	KS_SECTION,
+	KS_EOF = -1,
+};
+
+static unsigned long get_addr_offset(const struct kstate_field *field)
+{
+	switch (field->addr_type) {
+	case KS_VMEMMAP_ADDR:
+		return VMEMMAP_START;
+	case KS_LINEAR_ADDR:
+		return PAGE_OFFSET;
+	default:
+		WARN_ON(1);
+	}
+	return 0;
+}
+
+static struct folio *folio_realloc(struct folio *folio, int new_order,
+				gfp_t gfp_mask)
+{
+	struct folio *new_folio = folio_alloc(GFP_KERNEL, new_order);
+
+	if (!new_folio)
+		return NULL;
+
+	memcpy(folio_address(new_folio), folio_address(folio), folio_size(folio));
+	folio_put(folio);
+	return new_folio;
+}
+
+static int alloc_space(struct kstate_stream *stream, size_t size)
+{
+	int new_order;
+	struct folio *new_folio;
+	size_t cur_size = stream->pos - folio_address(stream->folio);
+
+	size = size + 4; /* Always alloc extra for KS_EOF */
+	if (cur_size + size < folio_size(stream->folio))
+		return 0;
+
+	new_order = get_order(cur_size) + 1;
+
+	new_folio = folio_realloc(stream->folio, new_order, GFP_KERNEL);
+	if (!new_folio)
+		return -ENOMEM;
+
+	stream->pos = folio_address(stream->folio) + cur_size;
+	return 0;
+}
+
+int kstate_save_data(struct kstate_stream *stream, const void *val,
+			size_t size)
+{
+	int ret;
+
+	ret = alloc_space(stream, size);
+	if (ret)
+		return ret;
+	memcpy(stream->pos, val, size);
+	stream->pos += size;
+	return 0;
+}
+
+static int save_kstate(struct kstate_stream *stream, int id,
+		const struct kstate_description *kstate,
+		void *obj, int section_type)
+{
+	const struct kstate_field *field = kstate->fields;
+	struct kstate_entry *ke;
+	unsigned long ke_off;
+	int ret = 0;
+
+	ret = alloc_space(stream, sizeof(*ke));
+	if (ret)
+		goto err;
+
+	ke_off = stream->pos - folio_address(stream->folio);
+	ke = stream->pos;
+	stream->pos += sizeof(*ke);
+
+	ke->section_type = section_type;
+	ke->state_id = kstate->id;
+	ke->version_id = kstate->version_id;
+	ke->instance_id = id;
+
+	while (field->flags != KS_END) {
+		void *first, *cur;
+		int n_elems = 1;
+		int size, i;
+
+		first = obj + field->offset;
+		/* Fields of higher versions shouldn't exist */
+		if (WARN_ON(field->version_id > kstate->version_id)) {
+			field++;
+			continue;
+		}
+		if (field->flags & KS_DEPRECATED) {
+			field++;
+			continue;
+		}
+
+		if (field->flags & KS_POINTER)
+			first = *(void **)(obj + field->offset);
+		if (field->count)
+			n_elems = field->count();
+		size = field->size;
+		for (i = 0; i < n_elems; i++) {
+			cur = first + i * size;
+
+			if (field->flags & KS_ARRAY_OF_POINTER)
+				cur = *(void **)cur;
+
+			if (field->flags & KS_STRUCT) {
+				ret = save_kstate(stream, 0, field->ksd, cur, section_type);
+				if (ret)
+					goto err;
+			} else if (field->flags & KS_CUSTOM) {
+				if (field->save) {
+					ret = field->save(stream, cur, field);
+					if (ret)
+						goto err;
+				}
+			} else if (field->flags & (KS_BASE_TYPE|KS_POINTER)) {
+				ret = kstate_save_data(stream, cur, size);
+				if (ret)
+					goto err;
+			} else if (field->flags & KS_ADDRESS) {
+				void *addr_offset = *(void **)cur
+					- get_addr_offset(field);
+				ret = kstate_save_data(stream, &addr_offset,
+						sizeof(addr_offset));
+				if (ret)
+					goto err;
+			} else
+				WARN_ON_ONCE(1);
+		}
+		field++;
+
+	}
+
+	ke = folio_address(stream->folio) + ke_off;
+	ke->size = (stream->pos - folio_address(stream->folio)) - (ke_off + sizeof(*ke));
+err:
+	if (ret)
+		pr_err("kstate: save of state %s failed\n", kstate->name);
+
+	return ret;
+}
+
+static int save_kstates(struct kstate_stream *stream, int id,
+		const struct kstate_description *kstate,
+		void *obj)
+{
+	int ret = 0;
+	const struct kstate_description *const *section;
+
+	ret = save_kstate(stream, id, kstate, obj, KS_SECTION);
+	if (ret)
+		return ret;
+
+	if (!kstate->subsections)
+		return ret;
+
+	section = kstate->subsections;
+	while (*section) {
+		ret = save_kstate(stream, id, *section, obj, KS_SUBSECTION);
+		if (ret)
+			break;
+		section++;
+	}
+
+	return ret;
+}
+
+static int alloc_kstate_stream(void)
+{
+	struct folio *folio;
+	u32 *buf;
+
+	folio = folio_alloc(GFP_KERNEL, 0);
+	if (!folio)
+		return -ENOMEM;
+
+	buf = folio_address(folio);
+	*buf++ = KSTATE_MAGIC;
+	kstate_stream.pos = buf;
+	kstate_stream.folio = folio;
+	return 0;
+}
+
+void free_kstate_stream(void)
+{
+	if (kstate_stream.folio)
+		folio_put(kstate_stream.folio);
+
+	kstate_stream.folio = NULL;
+	kstate_stream.pos = NULL;
+}
+
+int kstate_save_state(void)
+{
+	struct state_entry *se;
+	struct kstate_entry *ke;
+	int err = 0;
+
+	err = alloc_kstate_stream();
+	if (err)
+		return err;
+
+	mutex_lock(&states_lock);
+	list_for_each_entry(se, &states, list) {
+		err = save_kstates(&kstate_stream, se->id, se->kstd, se->obj);
+		if (err)
+			goto out;
+	}
+	ke = kstate_stream.pos;
+	ke->section_type = KS_EOF;
+out:
+	mutex_unlock(&states_lock);
+	if (err)
+		free_kstate_stream();
+	return err;
+}
+
+void kstate_restore_data(struct kstate_stream *stream, void *val, size_t size)
+{
+	memcpy(val, stream->pos, size);
+	stream->pos += size;
+}
+
+static void restore_kstate(struct kstate_stream *stream, int id,
+			const struct kstate_description *kstate, void *obj)
+{
+	const struct kstate_field *field = kstate->fields;
+	struct kstate_entry *ke = stream->pos;
+
+	stream->pos = ke->data;
+
+	WARN_ONCE(ke->version_id != kstate->version_id, "version mismatch %d %d\n",
+		ke->version_id, kstate->version_id);
+
+	WARN_ONCE(ke->instance_id != id, "instance id mismatch %d %d\n",
+		ke->instance_id, id);
+
+	while (field->flags != KS_END) {
+		void *first, *cur;
+		int n_elems = 1;
+		int size, i;
+
+		if (field->version_id > ke->version_id) {
+			field++;
+			continue;
+		}
+		if (field->flags & KS_DEPRECATED) {
+			if (ke->version_id <= field->version_id)
+				stream->pos += field->size;
+			field++;
+			continue;
+		}
+
+		first = obj + field->offset;
+		if (field->flags & KS_POINTER)
+			first = *(void **)(obj + field->offset);
+		if (field->count)
+			n_elems = field->count();
+		size = field->size;
+		for (i = 0; i < n_elems; i++) {
+			cur = first + i * size;
+
+			if (field->flags & KS_ARRAY_OF_POINTER)
+				cur = *(void **)cur;
+
+			if (field->flags & KS_STRUCT)
+				restore_kstate(stream, 0, field->ksd, cur);
+			else if (field->flags & KS_CUSTOM) {
+				if (field->restore)
+					field->restore(stream, cur, field);
+			} else if (field->flags & (KS_BASE_TYPE | KS_POINTER)) {
+				memcpy(cur, stream->pos, size);
+				stream->pos += size;
+			} else if (field->flags & KS_ADDRESS) {
+				*(void **)cur = (*(void **)stream->pos) +
+					get_addr_offset(field);
+				stream->pos += sizeof(void *);
+			} else
+				WARN_ON_ONCE(1);
+
+		}
+		field++;
+	}
+}
+
+static struct kstate_entry *find_subsection(struct kstate_stream *stream, int id)
+{
+	struct kstate_entry *ke = stream->pos;
+
+	while (ke->section_type == KS_SUBSECTION) {
+		if (ke->state_id == id)
+			return ke;
+
+		ke = (struct kstate_entry *)(ke->data + ke->size);
+	}
+	return NULL;
+}
+
+static void subsection_load(struct kstate_stream *stream, int id,
+			struct kstate_description *ksd, void *obj)
+{
+	struct kstate_entry *start_ke, *ke;
+	const struct kstate_description *const *section;
+
+	if (!ksd->subsections)
+		return;
+
+	start_ke = stream->pos;
+	section = ksd->subsections;
+	while (*section) {
+		stream->pos = start_ke;
+		ke = find_subsection(stream, (*section)->id);
+		if (ke) {
+			stream->pos = ke;
+			restore_kstate(stream, id, *section, obj);
+		}
+		section++;
+	}
+}
+
+int kstate_restore(struct kstate_description *state, void *obj, int id)
+{
+	struct kstate_stream stream;
+	struct kstate_entry *ke;
+
+	if (kstate_stream_addr == NULL)
+		return -ENOENT;
+
+	if (*(u32 *)kstate_stream_addr != KSTATE_MAGIC) {
+		kstate_stream_addr = NULL;
+		return -ENOENT;
+	}
+
+	ke = (struct kstate_entry *)(kstate_stream_addr + sizeof(u32));
+	if (WARN_ON_ONCE(ke->state_id == 0))
+		return -ENOENT;
+
+	stream.pos = ke;
+	while (ke->section_type != KS_EOF) {
+		if (ke->state_id != state->id ||
+		    ke->instance_id != id) {
+			ke = (struct kstate_entry *)(ke->data + ke->size);
+			continue;
+		}
+		stream.pos = ke;
+		restore_kstate(&stream, id, state, obj);
+		ke = (struct kstate_entry *)(ke->data + ke->size);
+		subsection_load(&stream, id, state, obj);
+		return 0;
+	}
+	return -ENOENT;
+}
+
+int kstate_register(struct kstate_description *state, void *obj, int id)
+{
+	struct state_entry *se;
+
+	se = kmalloc(sizeof(*se), GFP_KERNEL);
+	if (!se)
+		return -ENOMEM;
+
+	se->kstd = state;
+	se->id = id;
+	se->obj = obj;
+
+	mutex_lock(&states_lock);
+	list_add(&se->list, &states);
+	mutex_unlock(&states_lock);
+	return 0;
+}
+
+void kstate_unregister(struct kstate_description *state, void *obj, int id)
+{
+	struct state_entry *se, *tmp;
+
+	mutex_lock(&states_lock);
+	list_for_each_entry_safe(se, tmp, &states, list) {
+		if (se->id == id && se->obj == obj) {
+			list_del(&se->list);
+			break;
+		}
+	}
+	mutex_unlock(&states_lock);
+	kfree(se);
+}
+
+int kstate_register_restore(struct kstate_description *state, void *obj)
+{
+	int id = atomic_inc_return(&state->instance_id);
+
+	kstate_register(state, obj, id);
+	return kstate_restore(state, obj, id);
+}
+
+int kstate_folio_restore(struct kstate_stream *stream, void *obj,
+			const struct kstate_field *field)
+{
+	phys_addr_t paddr;
+	struct folio *folio;
+
+	kstate_restore_data(stream, &paddr, sizeof(paddr));
+	folio = kho_restore_folio(paddr);
+	if (!folio)
+		return -ENOENT;
+
+	*(struct folio **)obj = folio;
+	return 0;
+}
+
+int kstate_folio_save(struct kstate_stream *stream, void *obj,
+		const struct kstate_field *field)
+{
+	struct folio *folio = *(struct folio **)obj;
+	phys_addr_t paddr = PFN_PHYS(folio_pfn(folio));
+	int ret;
+
+	ret = kstate_save_data(stream, &paddr, sizeof(paddr));
+	if (ret)
+		return ret;
+
+	return kho_preserve_folio(folio);
+}
+
+
+struct kstate_out {
+	union {
+		phys_addr_t kstate_paddr;
+		u8 data[PAGE_SIZE];
+	};
+};
+
+int kstate_abort(void)
+{
+	free_kstate_stream();
+	return 0;
+}
+
+int kstate_finalize(void)
+{
+	int err = 0;
+	struct kstate_out *kstate_out = phys_to_virt(kstate_out_paddr);
+	struct folio *kstate_out_folio = page_folio(phys_to_page(kstate_out_paddr));
+
+	err = kstate_save_state();
+	if (err)
+		return err;
+
+	err = kho_preserve_folio(kstate_out_folio);
+	if (err)
+		goto out_save_state;
+
+	err = kho_preserve_folio(kstate_stream.folio);
+	if (err)
+		goto out;
+
+	kstate_out->kstate_paddr = PFN_PHYS(folio_pfn(kstate_stream.folio));
+out:
+	if (err)
+		kho_unpreserve_folio(kstate_out_folio);
+out_save_state:
+	if (err)
+		free_kstate_stream();
+
+	return err;
+}
+
+static int __init kstate_init(void)
+{
+	struct page *page;
+	int err;
+
+	if (!kho_is_enabled())
+		return 0;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		return -ENOMEM;
+
+	kstate_out_paddr = page_to_phys(page);
+	return err;
+}
+late_initcall(kstate_init);
+
+int __init kstate_early_init(phys_addr_t kstate_entries, u64 len)
+{
+	struct kstate_out *kstate_out;
+
+	kstate_out = early_memremap(kstate_entries, len);
+	if (!kstate_out) {
+		pr_err("%s failed\n", __func__);
+		return -ENOMEM;
+	}
+	kstate_stream_addr = phys_to_virt(kstate_out->kstate_paddr);
+	early_memunmap(kstate_out, len);
+	return 0;
+}
-- 
2.49.1


