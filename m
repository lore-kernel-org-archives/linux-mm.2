Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457E0606D830
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=F5meDUL0
Received: by kanga.kvack.org (Postfix)
	id E13686B05B6; Thu,  5 Nov 2026 19:43:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBB16B05B7; Thu,  5 Nov 2026 19:43:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA8A6B05B8; Thu,  5 Nov 2026 19:43:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A32C26B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21BD1C0781
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:03 +0000 (UTC)
X-FDA: 85402844646.21.FDF9602
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C8774000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=F5meDUL0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3lCLtaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3lCLtaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sjq9VdN6W+I9NBwFH2LvF9xugKaVKfSc0OTWV+x1HY=;
	b=omKgVJkZDHF37Z8tR7URoPEwTEc0cZE+N2vqo4qgPJalQ1rTd57y0+BERfIXRQi114DObf
	Ut6cH99NG7PfO+PW8vwHIKl+OHWlmws5/nKoXysmb7yRlfxVtA4oOpoRGbOUd5bVnNESZt
	H3D56THHDJ2mktgo4+f8Y4Lr/VgvYQQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=F5meDUL0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3lCLtaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3lCLtaggKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925781;
	b=QpZVgfBJjbk2Jf8GiLVAPra1X5kG8/JWV9KVg+3S3ybINjYCX0At/wEauodxbdhnLGUP+q
	w18/ek+09n7v7KH3OYgGlvlpEEl0N0hDBMkEFm/eAAH69yy2G2nyp1L990A+ZePDwAEoi+
	8aGwgri2vxENBtxlgPsuVWuQn3+S76c=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4db3db8687fso127484b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925780; x=1794530580; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7sjq9VdN6W+I9NBwFH2LvF9xugKaVKfSc0OTWV+x1HY=;
        b=F5meDUL05Jztn7Bj30Em53pjAVm63sdJXhRswtKvUEXN0lrge6BIr2CdtcqLHZOQeL
         n34pbI3Xftowi/VYnhOXRYyDzPpzQ5K2T9tNfTFAMhwHuPfhH9EFZ0maeLluCAf/6tOm
         yIErPMJC5W2dQGDq+zplox8uTKCdeVZZsYn02rSgl2IVjoKFkuN2gn5c1L8KawgtqHlM
         HChX9oGNPf8GBJApCKn3pvHYcCNV/ijpiioCUt/8iyOVzsLYZV27qNnLPo6ShgNLjim8
         Feismm8Wkn7VI/WLSM9sI3iTJXJQuVTt70dhQAAFZmWVUcBqLYl0r1ovylXcVghbURAJ
         jZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925780; x=1794530580;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7sjq9VdN6W+I9NBwFH2LvF9xugKaVKfSc0OTWV+x1HY=;
        b=1y4FGVrOYQ1UBGT1ATTO7QlD2X/T/0x+QfbWVqMaXhqd39X70QuuND1GvpWlYhKm4h
         Was2JtKMSSXP3s+W9a38Xkhja20Pc31gOta61thvfj/O4Qi+Z5LUzZze4+o5IzjRQXUV
         mQHOQRbIuWinFaqt2P4MdyGNrpgAAp1C3KwXhbNe8GC7VA0LsOUtBku3KUTUmU3uZG40
         4EoCNee6t7wDg+czOnpyvBObxU0skuTZGqHa26qHfaX8Hx5HNxmEme/73l+uOjF+Qej6
         Sabw+I6NVXfxl4izHR16+d3O2JEZxzVJ8OHEewKb9uwkfjDqbHfszepSNqTlK1XCNx9c
         3hbQ==
X-Forwarded-Encrypted: i=1; AKwUvByG8ewtyKAYybpimwuOEN6Jrh5+q0am8JTL/X/NrRbIE4ujgHiA3BU+cwpD6NbTmbXDTRwiFzmoMA==@kvack.org
X-Gm-Message-State: APuU4Z8Uou3mdTatLZTdi5cRDPscOs9yYUeqeQDBQb62R24OscO7Evmc
	wp0c0iO5R/ZGTSWHkndXXeJIOsnbPP8onaw/4J+xQpnvQLCTYWdza4TTeck8ZXfM7O7JQYJVhdk
	konBDb4XeWyOvkA==
X-Received: from jaan3-n1.prod.google.com ([2002:a05:6638:aac3:10b0:61c:f758:dde6])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6f92:b0:55c:6ea:3e3f with SMTP id 5614622812f47-567e1038164mr750724b6e.28.1793925780223;
 Thu, 05 Nov 2026 16:43:00 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:04 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-4-dmatlack@google.com>
Subject: [PATCH v2 03/17] PCI: Lay out struct pci_saved_state by configuration
 space offset
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C8774000C
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6zeksdgqb8d4o1ekq3joe4ccrkkjbdo6
X-HE-Tag: 1793925781-456748
X-HE-Meta: U2FsdGVkX19sJ6awkYw+zxyyetYcEyUcTz1GR8pLQM/WO02iutp2lz97OMh7VbrOWGfHpr7Cj5rkO0RUgvtcS+L0Qg6pje8zIyYGVeWnw+1B8pESKhatlph240rH7Vki7+szcEY2cMHql18CTDbOBLAhmhkJrXCvAYfJj0xgFs/qCEinU+JVLjA17zEr25CKZ9pDNnc47XE+Cqs4eCmdZy7+vZ/SRVCCKQW+K8uQ7f4O5nMpl3qO+bvuKwiZaj8vuirBJALjVhKhf2+wJ+JbK7DsxnRqbnjWc2ny2Sv7ExzYIX987Npu1knlPvoBv2yqEbmBFA5F9S8J733V1PDerjrKT+FqST3UqHyyxo3WXVd2Nuldahfrm/5JQJNkHALAtzOApynKOLfLdqOdvSRsY3CQP4LcftURT5nOUGClkeqxT0/J5G5uWOySRQqjimLJjMiR4aYaSZeeg5SPrN64Ok/pix5AJ2dGS5MyyBFHoBZ/ApJ2UwKWPpMhVz3cgldIS0wtaDNcTDj5KrrbcL9kT7Z6+14+V6AbMq2ek44+P6wrGvfBZE8fbMr8VhZLje2eqbSEwEOUMmYD9Cu4foDmporASAMjISfnscU5TpjdhPpo1Vmgd0iiWc6CRsnd/HTksClKstLiA3YvwijIvKngQ4/68xlba7zF+wo1/36o6548Fu0U3NAVG0N3ZRukHqM+Ary59e2ltroUp94/rJuDa9Rvo4eB5raacL6A4lsiGBPaXZ4hFIM93IfAAxG9LJQZLs5U9701S+AMfZYDUdMt7yH8ZODmRL6FQQyAnrmDZfSYDYdo2um/PNsNn9fF6vVIv7hhNVcBCqfxZT3kVsuEgRewjgx14wUlzvEYekh8PPa75Q2vIjVEVS3jX61Wf5tGuluaHvXN/1hws8rSdC+/9JfA+U8hqqO7ZsPtsUzW0xkQdlTDEajC6Tuk4g8o9kaDfPfJ2+tOHWvmKxYJXBk
 yuWhhGnU
 aKPz07tTq+UxVFqgwsiKhhz9rUD7J8yQyrXSsUIjoXtOi24zC67HEEBsXHdCRUoW06zG53wMUYpQ/uC4GkTIlFYBm5tZbns0naLKUYErC7oN5PmfZzsl185UB+kUN9OOrrstYeIA1JxrKlyoVGjsMv5c1TzpajGiR1++6Niw815Q3ywWj9LKS0ia6uowoL+JBFlF2NI5V/L3OxzzJ1dunA750qCuxbA8Wh9Cf3+xhO64t/4Py3PbckzprV3AYtP+NwkRDJfwe2EobOMIIWv3vseH/5cDnTqgtlnUo2Xl4CdJD5nif2+ly3v1DDmVjESYYl/MIWihoE4HP/otBV2sCOo09aCERgvX4V+YxYOKy/+kPWQACQkM1JkrDIqK5PPvQg/EZ24DXTLs1l9lsC+9uo4xrOCLGH/H486E6h7QiWjn7VOAta5u8EfbP6EY7qPgBUKV8WTFnBS3cCfStGa18HiwqBv6i8GKrSUDFX0Y0d+RSVfb5IkjG69EQLQDEk+M39MMcS3CTgJWcV7I0B1FaWRvsqvJ2zr3fO0VbfO5oH2v03QJvrPUQVOCC0QOJW7VGrOrztIqiNmDe6MykKjDwYji/UwJCX/aX9hBcETGR2a/UUG4IyQg7hP2augK6u/LXT3P7kUeUeuIoCUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Store a device's saved state as a bitmap of the configuration space DWORDs
that were saved plus their values, instead of a copy of the configuration
space header followed by a list of pci_cap_saved_data records.

The old layout is described entirely by the kernel: which capabilities have
a record, how large each record is, and what each word within a record
means are all properties of the code that happens to be saving them. That
ties the blob to the kernel that produced it, so VFIO cannot carry a
device's saved state across a Live Update. The new layout is
described by the device: a value's position is the offset of its
register in the device's own configuration space.

Keep refusing state that the device has nowhere to put in
pci_load_saved_state(), the equivalent of the old check that the
capability existed and its record was the expected size. Use
pci_saved_cap_reserved() for the check, since state saved from another
device or kernel can legitimately name an offset that this device did
not reserve.

No capability uses the store yet, and the patches that follow move them
into it one at a time, so keep appending the records of the capabilities
that still have their own buffer after the saved DWORDs. The blob
therefore continues to describe all of a device's saved state at every
step; a later patch drops the records once there are none left.

struct pci_saved_state is opaque to everything outside drivers/pci, so no
caller needs to change.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c        | 89 +++++++++++++++++++++++++++++++++++-----
 drivers/pci/pci.h        |  4 ++
 drivers/pci/saved-caps.c | 14 +++++++
 3 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e5b960ca26e6..007f9bb289d5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2032,11 +2032,40 @@ void pci_restore_state(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_restore_state);
 
+/**
+ * struct pci_saved_state - a device's saved configuration space
+ * @dword_map: one bit per DWORD of configuration space, set if that DWORD
+ *	       was saved
+ * @dword_val: saved values, in ascending configuration space offset order
+ *
+ * Laid out so that the position of every value is described by the device's
+ * configuration space rather than by the kernel.
+ *
+ * Capabilities that have not moved to the saved capability store yet keep
+ * their own buffer, and their records trail @dword_val until the last of
+ * those buffers goes away. Both areas vary in length and only one of them
+ * can be a flexible array member, so the records are reached with
+ * pci_saved_state_records() rather than declared here.
+ */
 struct pci_saved_state {
-	u32 config_space[16];
-	struct pci_cap_saved_data cap[];
+	unsigned long	dword_map[BITS_TO_LONGS(PCI_CFG_SPACE_EXP_DWORDS)];
+	u32		dword_val[];
+	/* struct pci_cap_saved_data cap[] follows dword_val */
 };
 
+/*
+ * The records that follow the saved DWORDs, one per capability that still has
+ * its own save buffer, terminated by an empty record.
+ */
+static struct pci_cap_saved_data *
+pci_saved_state_records(struct pci_saved_state *state)
+{
+	unsigned int nr_dwords = bitmap_weight(state->dword_map,
+					       PCI_CFG_SPACE_EXP_DWORDS);
+
+	return (struct pci_cap_saved_data *)&state->dword_val[nr_dwords];
+}
+
 /**
  * pci_store_saved_state - Allocate and return an opaque struct containing
  *			   the device saved state.
@@ -2046,16 +2075,28 @@ struct pci_saved_state {
  */
 struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev)
 {
-	struct pci_saved_state *state;
+	DECLARE_BITMAP(map, PCI_CFG_SPACE_EXP_DWORDS);
+	struct pci_saved_caps *caps = &dev->saved_caps;
 	struct pci_cap_saved_state *tmp;
 	struct pci_cap_saved_data *cap;
+	struct pci_saved_state *state;
+	unsigned int dword, nr_dwords, i = 0;
 	size_t size;
 
 	if (!dev->state_saved)
 		return NULL;
 
-	size = sizeof(*state) + sizeof(struct pci_cap_saved_data);
+	bitmap_zero(map, PCI_CFG_SPACE_EXP_DWORDS);
+	bitmap_set(map, 0, PCI_STD_HEADER_DWORDS);
+	if (caps->dword_val)
+		bitmap_or(map, map, caps->dword_map, PCI_CFG_SPACE_EXP_DWORDS);
+
+	nr_dwords = bitmap_weight(map, PCI_CFG_SPACE_EXP_DWORDS);
+
+	size = struct_size(state, dword_val, nr_dwords);
 
+	/* Room for the buffers that are left, and for the terminator */
+	size += sizeof(struct pci_cap_saved_data);
 	hlist_for_each_entry(tmp, &dev->saved_cap_space, next)
 		size += sizeof(struct pci_cap_saved_data) + tmp->cap.size;
 
@@ -2063,16 +2104,25 @@ struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev)
 	if (!state)
 		return NULL;
 
-	memcpy(state->config_space, dev->saved_config_space,
-	       sizeof(state->config_space));
+	bitmap_copy(state->dword_map, map, PCI_CFG_SPACE_EXP_DWORDS);
 
-	cap = state->cap;
+	for_each_set_bit(dword, state->dword_map, PCI_CFG_SPACE_EXP_DWORDS) {
+		u32 *val = &state->dword_val[i++];
+
+		if (dword < PCI_STD_HEADER_DWORDS)
+			*val = dev->saved_config_space[dword];
+		else
+			pci_read_saved_cap_dword(dev, dword * sizeof(u32), val);
+	}
+
+	cap = pci_saved_state_records(state);
 	hlist_for_each_entry(tmp, &dev->saved_cap_space, next) {
 		size_t len = sizeof(struct pci_cap_saved_data) + tmp->cap.size;
+
 		memcpy(cap, &tmp->cap, len);
 		cap = (struct pci_cap_saved_data *)((u8 *)cap + len);
 	}
-	/* Empty cap_save terminates list */
+	/* Empty record terminates the list */
 
 	return state;
 }
@@ -2087,16 +2137,33 @@ int pci_load_saved_state(struct pci_dev *dev,
 			 struct pci_saved_state *state)
 {
 	struct pci_cap_saved_data *cap;
+	unsigned int dword, i = 0;
 
 	dev->state_saved = false;
 
 	if (!state)
 		return 0;
 
-	memcpy(dev->saved_config_space, state->config_space,
-	       sizeof(state->config_space));
+	for_each_set_bit(dword, state->dword_map, PCI_CFG_SPACE_EXP_DWORDS) {
+		unsigned int off = dword * sizeof(u32);
+		u32 val = state->dword_val[i++];
+
+		if (dword < PCI_STD_HEADER_DWORDS) {
+			dev->saved_config_space[dword] = val;
+			continue;
+		}
+
+		/*
+		 * Refuse state that the device has nowhere to put, e.g.
+		 * because it was saved from a different device.
+		 */
+		if (!pci_saved_cap_reserved(dev, off))
+			return -EINVAL;
+
+		pci_write_saved_cap_dword(dev, off, val);
+	}
 
-	cap = state->cap;
+	cap = pci_saved_state_records(state);
 	while (cap->size) {
 		struct pci_cap_saved_state *tmp;
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 6676177706ba..206e0d04e06e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -258,6 +258,9 @@ struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
 struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
 						   u16 cap);
 
+/* DWORDs of the configuration space header, i.e. pci_dev.saved_config_space */
+#define PCI_STD_HEADER_DWORDS	(PCI_STD_HEADER_SIZEOF / sizeof(u32))
+
 void pci_saved_caps_finalize(struct pci_dev *dev);
 void pci_saved_caps_release(struct pci_dev *dev);
 int pci_reserve_saved_cap(struct pci_dev *dev, unsigned int off, unsigned int len);
@@ -269,6 +272,7 @@ void pci_restore_cap_dword(struct pci_dev *dev, unsigned int off);
 bool pci_read_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 *val);
 bool pci_read_saved_cap_dword(struct pci_dev *dev, unsigned int off, u32 *val);
 void pci_write_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 val);
+void pci_write_saved_cap_dword(struct pci_dev *dev, unsigned int off, u32 val);
 
 #define PCI_PM_D2_DELAY         200	/* usec; see PCIe r4.0, sec 5.9.1 */
 #define PCI_PM_D3HOT_WAIT       10	/* msec */
diff --git a/drivers/pci/saved-caps.c b/drivers/pci/saved-caps.c
index 92865891514e..4647ce59ce74 100644
--- a/drivers/pci/saved-caps.c
+++ b/drivers/pci/saved-caps.c
@@ -211,6 +211,20 @@ void pci_write_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 val)
 	*slot |= (u32)val << shift;
 }
 
+/**
+ * pci_write_saved_cap_dword - change the saved value of a 32-bit register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ * @val: value to save
+ */
+void pci_write_saved_cap_dword(struct pci_dev *dev, unsigned int off, u32 val)
+{
+	u32 *slot = pci_saved_cap_slot(dev, off);
+
+	if (slot)
+		*slot = val;
+}
+
 /**
  * pci_restore_cap_dword - restore a 32-bit capability register
  * @dev: the PCI device
-- 
2.56.0.455.g6c5a503b38-goog


