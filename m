Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B19060EC3FC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=J+LROApq
Received: by kanga.kvack.org (Postfix)
	id 0EA5B6B0644; Mon,  2 Nov 2026 10:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073616B0645; Mon,  2 Nov 2026 10:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56A36B0646; Mon,  2 Nov 2026 10:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABADD6B0644
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 511821A0170
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:08 +0000 (UTC)
X-FDA: 85390582536.23.EF078E9
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id 90BFB40004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=J+LROApq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3Ia7oagcKCH4xkrkpujiqqing.eqonkpwz-oomxcem.qti@flex--vipinsh.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3Ia7oagcKCH4xkrkpujiqqing.eqonkpwz-oomxcem.qti@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmR/P9susfgWpN3rWVzDSZpJhyqX0qvQbvTnkpaf48E=;
	b=mDT6/Udi+NApwxIJ8z7gWKp1QZjM80ZqwNfLylCzf49d+oEENi33YMjJgbWrnfGaiA9pCx
	cguUZ/G+xeqXzEg6fXnU20PqNP+Y2xn9e3yGSHLMfNbASimXuPv4bfgSEijOVf3OwYIjIR
	MvAMqFQhMpvw6c0WcBX8i3wbiKp7X+Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=J+LROApq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3Ia7oagcKCH4xkrkpujiqqing.eqonkpwz-oomxcem.qti@flex--vipinsh.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3Ia7oagcKCH4xkrkpujiqqing.eqonkpwz-oomxcem.qti@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633826;
	b=2ei9PDWwj3pOnh5UvZoKP2zxsqTz9aVvrr4kihC9AUbWr61ocepHKoxZLDWkNxd5JTFTbv
	3hXR8rtXMaIcUBRt91R+dihThmhuHy6BvuOmoqPSI7rUwUSzrNy4VkqhSi8qwJ6zVpnpm5
	nLemYjjNr87HiKyHko/xhRg4c2xkQ4k=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e869e00005so49833935ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633825; x=1794238625; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YmR/P9susfgWpN3rWVzDSZpJhyqX0qvQbvTnkpaf48E=;
        b=J+LROApqBVE+/+xZxpGpsdKFRk89KoNb1APZ2jdchqLc3DxN/dD6GKXyKniP8GKl27
         XlcFev/zZvmtspvoG2sii/57vBNTEnJRTjfZJFTkiZJ97lZaxYcpUyB67aPXxqf/TfO3
         i6i3YWyR5ZxvrgO5SZLa0iF+p6A9mvcUOdvtQG/BtnJYrZr8NzYscqSJYCB63UaPZveZ
         E+PMWl1PWnlUMA8wqdQQ+2zXeplg8wl7pAHIJFjvxfuxrnBX1OfTtxsPZqCGzvVV+Gdo
         +mq/xpvLoxgQJs3X57W8Hu+N6jAYkMCVdrsWeeLLe3Ey+7a72wfpwmCBa7nCh9eqyqp6
         nMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633825; x=1794238625;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YmR/P9susfgWpN3rWVzDSZpJhyqX0qvQbvTnkpaf48E=;
        b=mOlL4meWTo2ut77YdBXmZeFdVj/KEp6BmzG9dO8t5oUGEqS03PGdGrlR+6uh/RNEd2
         5VR4KxheSS6vqPNBqj+h+/W2Ryxgs+WwnRm6L057MtBHFVKS5hhLRNjN1imUBbef+dmV
         NpiipwluvJtvzc4NxJaVWW1qD6bvlFNfkQvLH/3EBWJKA7OabBIuq/o3ttCtNa3CQaKV
         lbLBUiPuPANPqXCXd21/f+l9eO1aLy/i4fiIedyqgQOdR2vNahaldVqEOFhzNPVvklQG
         A1HTvj17PndkGxyCMDV6fQAQqMrHQ4jdkZfgvnM+VKzXbiDtYytrYz3jevkCW2gO9aTY
         sqVw==
X-Forwarded-Encrypted: i=1; AKwUvBzcp01qOfDs0gQf0N3rzVhSpv6JDA3R2bGV1EGZkJMwqCBtLwCNTvrGDaT0EiXBbAAqgVsgrF3nDA==@kvack.org
X-Gm-Message-State: APuU4Z/lotZED/2bGIGo+cOHpITJg1q5+8+jfg/yvy/+/opaMkYANaTs
	iSooIYgeafPsMHIRlPLhou2bmc438hxWXwhZd0bYHH3GPJwylLnhrJVT8ZPYvA/8L2pvyqUEa3+
	oNZlOT3F2gw==
X-Received: from pldq13.prod.google.com ([2002:a17:902:c9cd:b0:2e8:2364:2533])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fd8d:b0:2e8:7686:4d46
 with SMTP id d9443c01a7336-2eb364552bemr101310195ad.34.1793633825121; Mon, 02
 Nov 2026 07:37:05 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:34 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-6-vipinsh@google.com>
Subject: [PATCH v6 05/27] PCI: liveupdate: Add helpers to preserve struct pci_saved_state
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 90BFB40004
X-Stat-Signature: y86kf56386crz6uazdz7esfbs96g4dbd
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793633826-476691
X-HE-Meta: U2FsdGVkX19OTf6trtNBHD92Mm06ao/kXp5wq6FsyI2Gza9KLZSirlaFbFz6T3oc5jZGexDd3X2tRDKDr9egsiTMHkQGwtZpWs6mKXkS7mZVCpoDi7nLCFFbuxCXm5ZsIy8HVAs/mshEhOIDOk9PQ3SuA4MfWFHLI2z8YglplCgangGSqeC4LT7iFU5qFHNlNwvtCP/PNw+zJyX3hRk2HCc/trp7zwAEEUerVS27ILn5lL8ccV8nr7ly1fLdvA7pB17QntFN6BSF6abjLVMb6dttkU2qFhp6+zVxgSyqyfKVa9R6I4BcYiV1J9dJuPuE3+eVok+b0a4DOhevjj+rw74r8l/fB1s0D+n45u9X2WYZ4k6sKd2CjH+qXIWKacjKeQ/otlqBtInnTe8YHZKeRhXtdlPPq6CqmPm887fLjuWzVjTQbh3P09yz8WNnA5y/pZabiSgpvM/lmnrvirbeX/SNXiqiAP7AcDYhxONm5tqKB4RjKK1fRb+lAu+2m2WtFAw3pqJL1WDN5/61hxKOuArnTGXblGqY0xD/vyTHu1FONjk1Spy2PAlj/miIIxG11yHw09QM/5/TXg+0NxrGKo3DEGR0QGb/ZmORa4qJamqhuS7zF7KuvEdU+zIW4DAoB/L9DGCkd/JJy6jE3KRhKWfx2+JBzdjpDt0UzyJxP9pUwBBzDS8sIIHhVwSX7FyBUfKQoC+52nX2kIB51VrnEn+HpdhL9qGYXeV5rY5yAc/f6iunNzsRdp0Qw2uvHM1ito61xrKtEoJ3a3Y1N5x6DKIxHlHwkyCcZnycFBRwENUsq8GNrvhcMuPDez9zQM4H4RK/Wfmh4Y4QizuKv+xAbFEZozkfhxOP0INPWns4lkCd6jnV7dBcRxdW3b3jVkyBAL1R8nuZ4l8PIMjX2cT7kZ8t+9THtlYDoqNLNpgH8PrETBWd7/SUI7+YlKTYU24BV9RkJkvY9dtmag9Nr0W
 6BSaQzdR
 6lxNsUgZzBowEVfjemdkoI3lKHXuXOyCejbL4bIa1qgUMPWSy072qEBAZ0AHSt3/EPbwP+sOkRWHp+FtfuRyLRDW+MD3403zYriUeJm0rYJ6/l0aQWaK1+GgJAM37zeksM4qgsNw7z4JNuzof1H5jXEL3Yts+mQkYodwZgW3gjiOVl/fM6FT/1j2KDhZI1G6NPuDcmo8aMR4WxlDjCHrnQaJD6/Jfqt3yDhdbVuMEr1t0x5ysK2mfqouA6XRCSXiF5A+u+ILmFDxsFWG0UQz9yrZItOFPYOWAE3Pmx5ZsV73XfYrRTOpwYeX5wWdK/Zs8C6CZIjrdkup8s55KHngPoNb0oNeU3TMkXulg+WN7LZv5aPVmgzIx0DI+sY8UI6ttDot6yKoSGioTKgb2mpgXEkH0S++F/QXatJqIvcsiBTq26J+ORO3xi1FLnR8epwnb+AIm0JsqH5azJGNtrrBbOz0pBqp1P33OiOwsEnHtfU9ObDnMYZufAt57lJ7smxuJtBODuFKEnHIsZp/WBsmyhGX2peM/r7KoRPJxeAnT+tmYT7ru9+gLrfS4dSFwi+HYeKu7X98TjwFnnViRuqNcsJnnSShMWa3aHDY2jJ7gmheWb3qsSv0D9MoQAqEFNxxfU+OH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Drivers that keep a device running across Live Update need to hand the
state they captured with pci_store_saved_state() to the next kernel,
since the next kernel never sees the device in that state. VFIO, for
example, captures it at first open and uses it to restore the device
when the last user closes it.

struct pci_saved_state is private to the PCI core and its in-memory
layout is not a stable ABI. Add helpers to serialize it into a
caller-provided buffer and rebuild it in the next kernel with a stable
struct pci_saved_state_ser ABI. Using caller-provided buffers allows
drivers to embed the serialized saved state directly in their own
KHO-preserved data with a single allocation and lifetime.

Validate the serialized buffer and verify that the saved standard
configuration header matches the live device before rebuilding the
state: the vendor and device IDs must match, only Type 0 (Normal)
headers are accepted, and BAR0-5 and the expansion ROM BAR address must
equal the current hardware values. This ensures that restoring the
saved state cannot write stale BAR addresses if resources were
reassigned in the new kernel. Only the address bits of the ROM BAR are
compared, since its enable and validation status bits may legitimately
differ.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 Documentation/PCI/liveupdate.rst |   3 +
 drivers/pci/liveupdate.c         | 223 +++++++++++++++++++++++++++++++
 drivers/pci/pci.c                |   5 -
 drivers/pci/pci.h                |   6 +
 include/linux/kho/abi/pci.h      |  47 +++++++
 include/linux/pci_liveupdate.h   |   7 +
 6 files changed, 286 insertions(+), 5 deletions(-)

diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
index 96b1d7f5df3a..b6cd9621b3b3 100644
--- a/Documentation/PCI/liveupdate.rst
+++ b/Documentation/PCI/liveupdate.rst
@@ -25,6 +25,9 @@ Live Update ABI
 .. kernel-doc:: include/linux/kho/abi/pci.h
    :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI
 
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :doc: PCI Saved State Live Update ABI
+
 .. kernel-doc:: include/linux/kho/abi/pci.h
    :internal:
 
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 6f92d4ddca2b..363453b06243 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -1036,3 +1036,226 @@ void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
 	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
+
+static const struct pci_cap_saved_data *pci_saved_cap_next(const struct pci_cap_saved_data *cap)
+{
+	return (const void *)cap + sizeof(*cap) + cap->size;
+}
+
+/**
+ * pci_liveupdate_saved_state_ser_size() - Size needed to serialize a saved state
+ * @state: Saved state returned by pci_store_saved_state(), or NULL.
+ *
+ * Return: Number of bytes needed by pci_liveupdate_serialize_saved_state(), or
+ * 0 if @state is NULL.
+ */
+size_t pci_liveupdate_saved_state_ser_size(const struct pci_saved_state *state)
+{
+	const struct pci_cap_saved_data *cap;
+	size_t size;
+
+	if (!state)
+		return 0;
+
+	size = sizeof(struct pci_saved_state_ser);
+	for (cap = state->cap; cap->size; cap = pci_saved_cap_next(cap))
+		size += sizeof(struct pci_cap_saved_data_ser) + cap->size;
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_saved_state_ser_size);
+
+/**
+ * pci_liveupdate_serialize_saved_state() - Serialize a struct pci_saved_state
+ * @state: Saved state returned by pci_store_saved_state().
+ * @buf: Destination buffer.
+ * @size: Size of @buf, must equal pci_liveupdate_saved_state_ser_size(@state).
+ *
+ * Drivers that keep a device running across Live Update can use this to hand
+ * the state captured by pci_store_saved_state() (e.g. before the device was
+ * handed to userspace) to the next kernel, which never sees the device in that
+ * state.
+ *
+ * Return: 0 on success, -EINVAL if the arguments are invalid.
+ */
+int pci_liveupdate_serialize_saved_state(const struct pci_saved_state *state,
+					 void *buf, size_t size)
+{
+	const struct pci_cap_saved_data *cap;
+	struct pci_saved_state_ser *ser = buf;
+	size_t off;
+	u32 nr = 0;
+
+	if (!state || !buf || size != pci_liveupdate_saved_state_ser_size(state))
+		return -EINVAL;
+
+	memset(buf, 0, size);
+	ser->size = size;
+	memcpy(ser->config_space, state->config_space, sizeof(ser->config_space));
+
+	off = sizeof(*ser);
+	for (cap = state->cap; cap->size; cap = pci_saved_cap_next(cap)) {
+		struct pci_cap_saved_data_ser *cap_ser = buf + off;
+
+		cap_ser->cap_nr = cap->cap_nr;
+		cap_ser->extended = cap->cap_extended ? 1 : 0;
+		cap_ser->size = cap->size;
+		memcpy(cap_ser->data, cap->data, cap->size);
+
+		off += sizeof(*cap_ser) + cap->size;
+		nr++;
+	}
+
+	ser->nr_caps = nr;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_serialize_saved_state);
+
+/* Read the byte at config space offset @where from a saved config header. */
+static u8 pci_saved_config_byte(const u32 *config_space, int where)
+{
+	return config_space[where / 4] >> ((where % 4) * 8);
+}
+
+/*
+ * Compare the bits in @mask of the config space dword at offset @where with
+ * the saved config header.
+ */
+static int pci_validate_saved_config_dword(struct pci_dev *dev,
+					   const u32 *config_space, int where,
+					   u32 mask)
+{
+	u32 val;
+
+	if (pci_read_config_dword(dev, where, &val) ||
+	    (val & mask) != (config_space[where / 4] & mask))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int pci_validate_saved_config_header(struct pci_dev *dev,
+					    const u32 *config_space)
+{
+	u8 hdr_type;
+	int bar;
+
+	if (config_space[PCI_VENDOR_ID / 4] !=
+	    ((u32)dev->device << 16 | dev->vendor))
+		return -EINVAL;
+
+	/* Only Type 0 (Normal) configuration headers are supported. */
+	hdr_type = pci_saved_config_byte(config_space, PCI_HEADER_TYPE) &
+		   PCI_HEADER_TYPE_MASK;
+	if (hdr_type != PCI_HEADER_TYPE_NORMAL ||
+	    dev->hdr_type != PCI_HEADER_TYPE_NORMAL)
+		return -EINVAL;
+
+	/*
+	 * Verify that BAR0-5 and the expansion ROM BAR address match the
+	 * current hardware values so that restoring the saved state cannot
+	 * write stale BAR addresses if resources were reassigned in the new
+	 * kernel.
+	 */
+	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
+		if (pci_validate_saved_config_dword(dev, config_space,
+						    PCI_BASE_ADDRESS_0 + bar * 4,
+						    ~0U))
+			return -EINVAL;
+	}
+
+	/*
+	 * Only the address bits of the ROM BAR are compared, since its enable
+	 * and validation status bits may legitimately differ.
+	 */
+	return pci_validate_saved_config_dword(dev, config_space,
+					       PCI_ROM_ADDRESS,
+					       PCI_ROM_ADDRESS_MASK);
+}
+
+/**
+ * pci_liveupdate_deserialize_saved_state() - Rebuild a struct pci_saved_state
+ * @dev: The PCI device the saved state belongs to.
+ * @buf: Buffer written by pci_liveupdate_serialize_saved_state().
+ * @size: Size of @buf in bytes.
+ *
+ * Validates @buf against the PCI Saved State Live Update ABI and @dev's
+ * standard configuration header, and allocates a struct pci_saved_state that
+ * can be passed to pci_load_saved_state() and freed with kfree(). @buf is not
+ * modified or freed.
+ *
+ * Return: Newly allocated struct pci_saved_state on success, or an ERR_PTR() on
+ * failure (-EINVAL if @buf is malformed or incompatible with @dev, -EOPNOTSUPP
+ * if @buf uses an unsupported flag, -ENOMEM on allocation failure).
+ */
+struct pci_saved_state *pci_liveupdate_deserialize_saved_state(struct pci_dev *dev,
+							       const void *buf,
+							       size_t size)
+{
+	const struct pci_saved_state_ser *ser = buf;
+	struct pci_cap_saved_data *cap;
+	struct pci_saved_state *state;
+	size_t off, state_size;
+	u32 i;
+
+	if (!dev || !buf || size < sizeof(*ser))
+		return ERR_PTR(-EINVAL);
+
+	if (ser->size != size)
+		return ERR_PTR(-EINVAL);
+
+	if (ser->flags)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (pci_validate_saved_config_header(dev, ser->config_space))
+		return ERR_PTR(-EINVAL);
+
+	off = sizeof(*ser);
+	state_size = sizeof(*state) + sizeof(*cap);
+
+	for (i = 0; i < ser->nr_caps; i++) {
+		const struct pci_cap_saved_data_ser *cap_ser;
+		size_t entry_size;
+
+		if (size - off < sizeof(*cap_ser))
+			return ERR_PTR(-EINVAL);
+
+		cap_ser = buf + off;
+		if (!cap_ser->size || cap_ser->size > PCI_CFG_SPACE_EXP_SIZE ||
+		    cap_ser->extended > 1)
+			return ERR_PTR(-EINVAL);
+
+		entry_size = sizeof(*cap_ser) + cap_ser->size;
+		if (size - off < entry_size)
+			return ERR_PTR(-EINVAL);
+
+		off += entry_size;
+		state_size += sizeof(*cap) + cap_ser->size;
+	}
+
+	if (off != size)
+		return ERR_PTR(-EINVAL);
+
+	state = kzalloc(state_size, GFP_KERNEL);
+	if (!state)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(state->config_space, ser->config_space, sizeof(state->config_space));
+
+	off = sizeof(*ser);
+	cap = state->cap;
+	for (i = 0; i < ser->nr_caps; i++) {
+		const struct pci_cap_saved_data_ser *cap_ser = buf + off;
+
+		cap->cap_nr = cap_ser->cap_nr;
+		cap->cap_extended = cap_ser->extended;
+		cap->size = cap_ser->size;
+		memcpy(cap->data, cap_ser->data, cap_ser->size);
+
+		off += sizeof(*cap_ser) + cap_ser->size;
+		cap = (void *)cap + sizeof(*cap) + cap->size;
+	}
+
+	return state;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_deserialize_saved_state);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e5b960ca26e6..192f6766cc31 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2032,11 +2032,6 @@ void pci_restore_state(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_restore_state);
 
-struct pci_saved_state {
-	u32 config_space[16];
-	struct pci_cap_saved_data cap[];
-};
-
 /**
  * pci_store_saved_state - Allocate and return an opaque struct containing
  *			   the device saved state.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 037c1674f164..d10df3203725 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -244,6 +244,12 @@ struct pci_cap_saved_data {
 	u32		data[];
 };
 
+/* Opaque to drivers, see pci_store_saved_state() */
+struct pci_saved_state {
+	u32 config_space[16];
+	struct pci_cap_saved_data cap[];
+};
+
 struct pci_cap_saved_state {
 	struct hlist_node		next;
 	struct pci_cap_saved_data	cap;
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index c2e3a5949f73..3d0822f2067d 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -93,4 +93,51 @@ struct pci_ser {
 	u64 devices;
 } __packed;
 
+/**
+ * DOC: PCI Saved State Live Update ABI
+ *
+ * Drivers that keep a PCI device running across a Live Update can hand the
+ * state returned by pci_store_saved_state() to the next kernel by embedding a
+ * struct pci_saved_state_ser in their own preserved data, produced and parsed
+ * by the PCI core via pci_liveupdate_serialize_saved_state() and
+ * pci_liveupdate_deserialize_saved_state().
+ *
+ * Like the FLB data above, this layout is a contract between kernels and is
+ * extended by appending fields and defining bits in ``flags`` for features the
+ * next kernel must understand, while recording the size of each entry. Unlike
+ * the FLB data, it is embedded in a driver's preserved state rather than
+ * referenced from struct pci_ser, and validation failures are reported to the
+ * calling driver rather than panicking.
+ */
+
+/**
+ * struct pci_cap_saved_data_ser - A saved capability in a struct pci_saved_state_ser
+ * @cap_nr: Capability ID (PCI_CAP_ID_* or PCI_EXT_CAP_ID_*).
+ * @extended: 1 if @cap_nr is an extended capability ID, 0 otherwise.
+ * @size: Size of @data in bytes, never 0.
+ * @data: The saved registers.
+ */
+struct pci_cap_saved_data_ser {
+	u16 cap_nr;
+	u16 extended;
+	u32 size;
+	u8 data[];
+} __packed;
+
+/**
+ * struct pci_saved_state_ser - Serialized struct pci_saved_state
+ * @size: Size in bytes of this struct, including all entries in @caps.
+ * @flags: Features a kernel must support to restore the state. None defined.
+ * @nr_caps: Number of entries in @caps.
+ * @config_space: The saved standard configuration header.
+ * @caps: @nr_caps struct pci_cap_saved_data_ser entries.
+ */
+struct pci_saved_state_ser {
+	u32 size;
+	u32 flags;
+	u32 nr_caps;
+	u32 config_space[16];
+	u8 caps[];
+} __packed;
+
 #endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index bb79348769b7..cfff200bce36 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -32,6 +32,7 @@ struct pci_liveupdate {
 };
 
 struct pci_dev;
+struct pci_saved_state;
 
 #ifdef CONFIG_PCI_LIVEUPDATE
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
@@ -40,6 +41,12 @@ int pci_liveupdate_preserve(struct pci_dev *dev);
 void pci_liveupdate_unpreserve(struct pci_dev *dev);
 void pci_liveupdate_finish(struct pci_dev *dev);
 bool pci_liveupdate_is_incoming(struct pci_dev *dev);
+size_t pci_liveupdate_saved_state_ser_size(const struct pci_saved_state *state);
+int pci_liveupdate_serialize_saved_state(const struct pci_saved_state *state,
+					 void *buf, size_t size);
+struct pci_saved_state *pci_liveupdate_deserialize_saved_state(struct pci_dev *dev,
+							       const void *buf,
+							       size_t size);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
-- 
2.56.0.317.g454f8302e1-goog


