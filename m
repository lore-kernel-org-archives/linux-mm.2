Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770F9606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=L2KcSHE6
Received: by kanga.kvack.org (Postfix)
	id 4C5F66B05B3; Thu,  5 Nov 2026 19:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D366B05C7; Thu,  5 Nov 2026 19:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC2F6B05C8; Thu,  5 Nov 2026 19:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00B426B05C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87CB51A084B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:20 +0000 (UTC)
X-FDA: 85402845360.07.41EC302
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf21.hostedemail.com (Postfix) with ESMTP id C01D11C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L2KcSHE6;
	spf=pass (imf21.hostedemail.com: domain of 3pSLtaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3pSLtaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkvlpSHI6oVXBaKs0yGdR4zokFApEJwfw+eXrMywXPI=;
	b=Mj+r6AhlT1dVN7AocZwKJfdWyTE8hwjFw6ZHiF7unuNPyqZItMU2UA8SrgGVkZqT1f37zK
	EStDJzgJwWKoxjFYFHi9kyvTnRLdh4GfMRbqzDYTuu5hVP9QAEwxuyWxZTMbPVXF9avSFA
	rdGleCfjfzYSu6QycFJ8aZXv+1IiSgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925798;
	b=cxdfQIItTFCcn9xen9241jDIBBWyVyAzX6YYL/3YKEmwgLCWe69GsGZt3oIe3buUrjtsr4
	HiIyJW+RgkUiLU7CuwC4rLi+/2/SutvY6BGyRwcEYa03ooh31y5cWRZfr/M+FemYIVrJy7
	fsq8y2Gh6BYWnp5inCmhH+INgzkZg1s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L2KcSHE6;
	spf=pass (imf21.hostedemail.com: domain of 3pSLtaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3pSLtaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-84478a97bfbso331969a34.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925798; x=1794530598; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kkvlpSHI6oVXBaKs0yGdR4zokFApEJwfw+eXrMywXPI=;
        b=L2KcSHE6wp6SkEM/JXxeOSAwwVy2zD6A+jk6GTJYBfYZ9ANJruQqZLT+N570x0utms
         UD/QrzasYXH2MrPEqxA5N27nLlhmoyVGrsyyWXVUZWzZBvNpidQTO++r+ifvMj0tzS5E
         ulUkhGEpw6pZOufUsNmENgSUIApFvXz8Pa4gGpNOaPJ0LdnAR7kf4cynRaX9rhaYEPSH
         B4KXGfSkZP94lDqhM2WzNJWGzx9uXUdXMYrNIJlXOxr3WsHSkdNnKjgpPf18BUzjZiud
         th09kAEmDFxUUAHXSS7bkOghrdRGAVmcWV9Ge/g5mj8KiBml3s5pbWEsxyS/5vU4P6jW
         Mz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925798; x=1794530598;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kkvlpSHI6oVXBaKs0yGdR4zokFApEJwfw+eXrMywXPI=;
        b=yPLQQ2MS+ngh/stYu+eJRUuTuc/puPddkc6jg9HRtsqEXAapFvqnmpLDxnAngIKpkZ
         MO140g6wCy35TSeNfyF7Rmf7zd0LwzbUhNpTG5zKxmp4xzgj+Ey9cV0x6zxyCQmlGw7k
         YBfi9iiHe1FhmXODi3zjT5h16bC6AxAsX7dZO5xmgntv/eeQWPkG/YVi/sqhUZzP3eqW
         xXeh2EJtIgLwmpzPndluCt4woLTCHw+whqVdNMv+MqXI6WI5/Wt6BjDAlm6bD5EgktaH
         Y2Hwzu+YbxIQLKMUZqr3/3xeadwW1LH2sxPT63QVLxmp1ZZAJHf9dNk0quaCYAsJdIsM
         GKeQ==
X-Forwarded-Encrypted: i=1; AKwUvBy6RfwxyWpkCXLzhWqipoiJLhkG/yHxIRefk3u1Aq8H5Cvh4QXI/+Ko1brekH3zgT3me8/CnUK1WQ==@kvack.org
X-Gm-Message-State: APuU4Z9meM6s/SqUQnJ7bEwXwiyp/xEPFNbUQZHTavfqvhz8ze7fwCiq
	+0vZ0iQSKM/iYkdcT6yC2E9PgmScZIIgG0R15BMtk6aL/zwoNoFzlGWtz/mBV2yg0iXzJoXrnOT
	LLZdDcgYqrV/guA==
X-Received: from jasv5.prod.google.com ([2002:a05:6638:12c5:b0:615:c1f0:a936])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1914:b0:500:5e36:3a9d with SMTP id 5614622812f47-567e106112amr663076b6e.30.1793925797580;
 Thu, 05 Nov 2026 16:43:17 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:18 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-18-dmatlack@google.com>
Subject: [PATCH v2 17/17] PCI: liveupdate: Add helpers to preserve struct pci_saved_state
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Cc: Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Lukas Wunner <lukas@wunner.de>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9r9a8j3axbjc88718qrzwj7t39pdzopb
X-Rspamd-Queue-Id: C01D11C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793925798-607573
X-HE-Meta: U2FsdGVkX19W8SIcUL/WYXcPFxrsrAHYd6xODQd4aig/qQdVhzr0Y9JWwEdymxrbCSfUiaIH9a43AY/0AYeOFGlaOlWdLzxRQHHdW/2PD1fLpXO1N34JWMt883DR9I5ykkl866VCVibketljn33mYPUomJdDRrMbUfbL7gn37w7jTuVwv+U4bRubdFaP33XWPX2MuP5h39uddeh18HHPSvA760YNsKMPhUL5NT3B12WScPMPhmMIhY53JkEIkrKh0PKt6EtUB3ALNoP6P71Hjv7+hES6Tcqke7fuJ+10DiiCupWKxwFTGmC8CQFF1JThpo+E4xQXsNk+uWjGNtZzwNTldq64SuIdVht81xZbRg6ErOKMH1OcDRep5uityoXqshhIV9Jf4a/carZhLCvdKvM0t1n4I8rCCgJXW0/dDk0KkvjX7VpTe+CznhDPZWJiXdN/eiI5h8v7umN+nvS9JW56n2F7ZwhHDQsd7n0B+fkbnT6hJVC8IL+SZ9EWq5NBXI19lqPT3Ii62P94RiyNShmqXirSetK5uuSti7osc3ChmdeZIvasUuxuZxVUYNh8oAzoW92RjF/WtwbyWdT9TayoOqNlKUDOgePCMXgsakrst61We9dwKfK+/WbamrZkoWW0FdvvTztk1U8x+k5iAPuWXwGwqeG+61H3L3cxyr/sheo5V3Yts+d2RNJhH4HBCbTo67lPgb7GAv7tr26iQTvVWxeFyD5DCe102QVOi6OC3TmhVptfuejbENsGU7S75L6tJtB21nuhogc3K5iluoPQ5ytnGIUFl5CQnK69F1f7ZRbtzwL+2G52RXmE8+mXKauGEhLtAC9W44Y+bX5q5Tuf8FUBdKxyVyHGUExZ2IXXafxWxj6YKFT3skvL2z0lwF8XYLqicUjPRnnaIKAiTjyPiOo+XWqN0NXYZp6Wnxc9/Za7fyl2/rs+c4MRHk84hfHlp8JUYvaJmjLPnGN
 kqTCvpPF
 l4y4wH9I7lG1+XdJnnGw+VKxv379iAloMZ2QOpCQZO+SXXPMQux4JBHlKQAsY+MWYFVvd83SRqexS9CvkN7V+e6pHKKB7UaKCS/Rup5525hb1N+4mCxEqxOSf+yS0/ZVzAjUs6UEYmR6FDxPV4BBaGXDzOoCj7ozk+oaYr7GwUV/+XeEE5JMIC596NAsLeG8SX4mOmnjvz4BtgkBlQeOfcs97cprXPj00zAwdZuA8IBj8PRnBsiVdA689+alh8VmFmgaMAHrghdfCuZiQoM9ckjpkbgbUuKVKKwH0GzF+gVdIyA65fXNBduulItAKuAzLSKMDVPu+V3ClydlhqPtE4Cxj8dIG9kTzmBVXwAh9FEjZRNCSGeYKDHSUfEQ+TauTdacVvkwH0vSDdj1ulAyCAoX/+BBAf2/9p+t0vrYXCGRFPcx3qYEQ+sGGbpEiIC67Y3tbUke+jnCkn2nWwT3BV+BBvQXPBW3sQGgw/NBp+cA2VwItZiEJjvEHx1s8mObDeabtVhAORpo/PxYA8CbBDkpOCoe/ryonLIBs4BkGWYXl9oFRke80SyL5Yc6SAXgRjiqdwJ9DXn52d0qOPLhOef6wPQlkSgRfuQDyVbp6RYWGm1CYsjl/0n9A54XapvgJsNSCzlpnk71jRNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add pci_liveupdate_preserve_saved_state(), which copies a struct
pci_saved_state into memory preserved with KHO and returns its physical
address, and pci_liveupdate_retrieve_saved_state(), which rebuilds the
struct pci_saved_state from that address in the next kernel and frees
the preserved memory. Add pci_liveupdate_unpreserve_saved_state() to
free the memory if the device ends up not being preserved. If
pci_liveupdate_retrieve_saved_state() fails, it leaves the memory in
place so that the caller can try again.

Drivers that keep a device running across Live Update need to hand the
state they captured with pci_store_saved_state() to the next kernel,
since by the time the next kernel boots the device is no longer in that
state. VFIO, for example, captures it at first open and uses it to
restore the device when the last user closes it. Callers record only
the physical address in their own preserved state, so the layout of the
saved state stays private to the PCI core.

Define the layout as struct pci_saved_state_ser in
include/linux/kho/abi/pci.h: a bitmap with one bit per DWORD of
configuration space, followed by the saved DWORDs in ascending offset
order, mirroring struct pci_saved_state. Each value is identified only
by its offset, so the format does not change when a kernel starts or
stops saving a register.

Drop saved capability registers that the next kernel does not reserve,
since it would never restore them and pci_load_saved_state() would
reject the whole state because of them. This lets the PCI core stop
saving a register without breaking Live Update from older kernels. A
register that the next kernel restores but the previous kernel did not
save keeps its current saved value in the next kernel.

Co-developed-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/PCI/liveupdate.rst |   3 +
 drivers/pci/liveupdate.c         | 118 +++++++++++++++++++++++++++++++
 drivers/pci/pci.c                |  14 ----
 drivers/pci/pci.h                |  14 ++++
 include/linux/kho/abi/pci.h      |  32 +++++++++
 include/linux/pci_liveupdate.h   |  23 ++++++
 6 files changed, 190 insertions(+), 14 deletions(-)

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
index 8334e6fdd3ec..c1f1b71e5959 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -1037,3 +1037,121 @@ void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
 	liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
+
+static_assert(PCI_SAVED_STATE_SER_DWORDS == PCI_CFG_SPACE_EXP_DWORDS);
+
+/**
+ * pci_liveupdate_preserve_saved_state() - Preserve a struct pci_saved_state
+ * @state: Saved state returned by pci_store_saved_state().
+ * @phys: Returns the physical address of the preserved state.
+ *
+ * Copy @state into memory preserved for the next kernel, laid out as struct
+ * pci_saved_state_ser. The caller records @phys in its own preserved state and
+ * passes it to pci_liveupdate_retrieve_saved_state() in the next kernel. If
+ * the device ends up not being preserved, the caller must unpreserve the state
+ * with pci_liveupdate_unpreserve_saved_state().
+ *
+ * Return: 0 on success, <0 on failure.
+ */
+int pci_liveupdate_preserve_saved_state(const struct pci_saved_state *state,
+					u64 *phys)
+{
+	struct pci_saved_state_ser *ser;
+	unsigned int nr_dwords;
+
+	if (!state)
+		return -EINVAL;
+
+	nr_dwords = bitmap_weight(state->dword_map, PCI_CFG_SPACE_EXP_DWORDS);
+
+	ser = kho_alloc_preserve(struct_size(ser, dword_val, nr_dwords));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	bitmap_to_arr64(ser->dword_map, state->dword_map,
+			PCI_CFG_SPACE_EXP_DWORDS);
+	memcpy(ser->dword_val, state->dword_val, nr_dwords * sizeof(u32));
+
+	*phys = virt_to_phys(ser);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve_saved_state);
+
+/**
+ * pci_liveupdate_unpreserve_saved_state() - Unpreserve a struct pci_saved_state
+ * @phys: Physical address returned by pci_liveupdate_preserve_saved_state().
+ *
+ * Unpreserve and free the state, e.g. because the device will not be
+ * preserved after all.
+ */
+void pci_liveupdate_unpreserve_saved_state(u64 phys)
+{
+	kho_unpreserve_free(phys_to_virt(phys));
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve_saved_state);
+
+/*
+ * The configuration space header is always restored. Capability registers are
+ * only restored if this kernel reserved room for them.
+ */
+static bool pci_saved_state_dword_restorable(struct pci_dev *dev,
+					     unsigned int dword)
+{
+	return dword < PCI_STD_HEADER_DWORDS ||
+	       pci_saved_cap_reserved(dev, dword * sizeof(u32));
+}
+
+/**
+ * pci_liveupdate_retrieve_saved_state() - Retrieve a struct pci_saved_state
+ * @dev: The PCI device the state was saved from.
+ * @phys: Physical address that the previous kernel's
+ *        pci_liveupdate_preserve_saved_state() returned.
+ *
+ * Rebuild the struct pci_saved_state that the previous kernel preserved, for
+ * use with pci_load_saved_state(), and free the preserved memory. If this
+ * fails, the preserved memory is left in place so that the caller can try
+ * again.
+ *
+ * The saved configuration space header is always kept. Saved capability
+ * registers that this kernel does not restore for @dev are dropped.
+ *
+ * Return: The saved state, to be freed with kfree(), or an ERR_PTR() on
+ * failure.
+ */
+struct pci_saved_state *
+pci_liveupdate_retrieve_saved_state(struct pci_dev *dev, u64 phys)
+{
+	struct pci_saved_state_ser *ser = phys_to_virt(phys);
+	DECLARE_BITMAP(map, PCI_CFG_SPACE_EXP_DWORDS);
+	unsigned int dword, nr_dwords = 0, i = 0, j = 0;
+	struct pci_saved_state *state;
+
+	bitmap_from_arr64(map, ser->dword_map, PCI_CFG_SPACE_EXP_DWORDS);
+
+	for_each_set_bit(dword, map, PCI_CFG_SPACE_EXP_DWORDS) {
+		if (pci_saved_state_dword_restorable(dev, dword))
+			nr_dwords++;
+	}
+
+	state = kzalloc(struct_size(state, dword_val, nr_dwords), GFP_KERNEL);
+	if (!state)
+		return ERR_PTR(-ENOMEM);
+
+	for_each_set_bit(dword, map, PCI_CFG_SPACE_EXP_DWORDS) {
+		u32 val = ser->dword_val[i++];
+
+		if (!pci_saved_state_dword_restorable(dev, dword))
+			continue;
+
+		__set_bit(dword, state->dword_map);
+		state->dword_val[j++] = val;
+	}
+
+	if (i != j)
+		pci_info(dev, "Dropped %u saved DWORDs this kernel does not restore\n",
+			 i - j);
+
+	kho_restore_free(ser);
+	return state;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_retrieve_saved_state);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d2a9718b6a65..5b3c1fd6ba1e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1987,20 +1987,6 @@ void pci_restore_state(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_restore_state);
 
-/**
- * struct pci_saved_state - a device's saved configuration space
- * @dword_map: one bit per DWORD of configuration space, set if that DWORD
- *	       was saved
- * @dword_val: saved values, in ascending configuration space offset order
- *
- * Laid out so that the position of every value is described by the device's
- * configuration space rather than by the kernel.
- */
-struct pci_saved_state {
-	unsigned long	dword_map[BITS_TO_LONGS(PCI_CFG_SPACE_EXP_DWORDS)];
-	u32		dword_val[];
-};
-
 /**
  * pci_store_saved_state - Allocate and return an opaque struct containing
  *			   the device saved state.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index bc92b037b9d1..623f70cb57c1 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -242,6 +242,20 @@ void pci_reserve_saved_caps(struct pci_dev *dev);
 /* DWORDs of the configuration space header, i.e. pci_dev.saved_config_space */
 #define PCI_STD_HEADER_DWORDS	(PCI_STD_HEADER_SIZEOF / sizeof(u32))
 
+/**
+ * struct pci_saved_state - a device's saved configuration space
+ * @dword_map: one bit per DWORD of configuration space, set if that DWORD
+ *	       was saved
+ * @dword_val: saved values, in ascending configuration space offset order
+ *
+ * Laid out so that the position of every value is described by the device's
+ * configuration space rather than by the kernel.
+ */
+struct pci_saved_state {
+	unsigned long	dword_map[BITS_TO_LONGS(PCI_CFG_SPACE_EXP_DWORDS)];
+	u32		dword_val[];
+};
+
 void pci_saved_caps_finalize(struct pci_dev *dev);
 void pci_saved_caps_release(struct pci_dev *dev);
 int pci_reserve_saved_cap(struct pci_dev *dev, unsigned int off, unsigned int len);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index c2e3a5949f73..ee37d7c84758 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -93,4 +93,36 @@ struct pci_ser {
 	u64 devices;
 } __packed;
 
+/**
+ * DOC: PCI Saved State Live Update ABI
+ *
+ * A driver that keeps a PCI device running across a Live Update can hand the
+ * state it captured with pci_store_saved_state() to the next kernel. The PCI
+ * core copies the state into memory preserved with KHO, laid out as struct
+ * pci_saved_state_ser, and returns the physical address of that memory, which
+ * the driver records in its own preserved state.
+ *
+ * Every saved value is identified only by the configuration space offset of
+ * the register it was read from. The layout therefore does not depend on which
+ * registers the kernel that saved them chose to save, and the next kernel can
+ * drop values for registers it does not restore.
+ */
+
+/* Number of DWORDs in a PCI Express configuration space (4 KiB). */
+#define PCI_SAVED_STATE_SER_DWORDS 1024
+
+/**
+ * struct pci_saved_state_ser - Serialized struct pci_saved_state
+ *
+ * @dword_map: One bit per DWORD of configuration space. Bit N, i.e. bit
+ *             (N % 64) of @dword_map[N / 64], is set if the DWORD at
+ *             configuration space offset N * 4 was saved.
+ * @dword_val: The saved DWORDs, one per bit set in @dword_map, in ascending
+ *             configuration space offset order.
+ */
+struct pci_saved_state_ser {
+	u64 dword_map[PCI_SAVED_STATE_SER_DWORDS / 64];
+	u32 dword_val[];
+} __packed;
+
 #endif /* _LINUX_KHO_ABI_PCI_H */
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index bb79348769b7..9fe260fde5ee 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -32,6 +32,7 @@ struct pci_liveupdate {
 };
 
 struct pci_dev;
+struct pci_saved_state;
 
 #ifdef CONFIG_PCI_LIVEUPDATE
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
@@ -40,6 +41,11 @@ int pci_liveupdate_preserve(struct pci_dev *dev);
 void pci_liveupdate_unpreserve(struct pci_dev *dev);
 void pci_liveupdate_finish(struct pci_dev *dev);
 bool pci_liveupdate_is_incoming(struct pci_dev *dev);
+int pci_liveupdate_preserve_saved_state(const struct pci_saved_state *state,
+					u64 *phys);
+void pci_liveupdate_unpreserve_saved_state(u64 phys);
+struct pci_saved_state *
+pci_liveupdate_retrieve_saved_state(struct pci_dev *dev, u64 phys);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -67,6 +73,23 @@ static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
 {
 	return false;
 }
+
+static inline int
+pci_liveupdate_preserve_saved_state(const struct pci_saved_state *state,
+				    u64 *phys)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_unpreserve_saved_state(u64 phys)
+{
+}
+
+static inline struct pci_saved_state *
+pci_liveupdate_retrieve_saved_state(struct pci_dev *dev, u64 phys)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif
 
 #endif /* LINUX_PCI_LIVEUPDATE_H */
-- 
2.56.0.455.g6c5a503b38-goog


