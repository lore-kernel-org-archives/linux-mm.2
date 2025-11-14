Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB0FCE8D4B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DF48E0033; Fri, 14 Nov 2025 10:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045688E0029; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77C98E0033; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D25378E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A12D8886EF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:14 +0000 (UTC)
X-FDA: 84109659228.17.821E764
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id D93314000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jmu9t2T1;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tk/MJG6ETPbjL9I+STB4rCENdOaFkmH/bVv9/0YHmw=;
	b=AsyS2vpszPHhth9NtefqPrYvHBSuH+fz9x8tI+hlehyn9qF+T/jX799k5Xz7zy+KX7edvn
	1WSImFcC0MxGaa0cmM6yyCQgnHugqggd0MhwdhTrAhwydBa/zxE31Cy+CRMwyp3g9YnBaD
	gUXC5nkn3wNB2loqxNPQfIpXLRFtntE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jmu9t2T1;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135652; a=rsa-sha256;
	cv=none;
	b=boArNCbswbdK1PYPDD8c8cMpnBwsjYxoAwcbwITQCNs/AqC+I/vtr8f5lHWjtz5/rLOVrT
	5RhxBIXOOskyOyMJuFRFyIowe5MHXu0cXW/poSqn/gaWicLNRyfPFXxsuWKu7fmCrgm2/g
	To06ENDPT3RRZaX5Q6W7p5hVkI3zAXA=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-787df0d729dso21110747b3.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135652; x=1763740452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8tk/MJG6ETPbjL9I+STB4rCENdOaFkmH/bVv9/0YHmw=;
        b=jmu9t2T13DE86Coy5EwgXlXO07ZSqDkosN+qmByCKMWYtdu4S8NEZqyxITfSGeMuvN
         QVEZzy63N4jo+TVl7v0fBJr0eFFxzGzP9/4fIDMJjRHgiA3sr8D9uDAoCQoep+6TfCUF
         StnZIDGmLL0Qp2oR9obSXlIoX7SuvBUbJ3D+56kKT2sc1jF3OiFeTYf07f3j3uNJ3xZ+
         Cwq5Xf7s+NkOS/DraOoNX23zGw6ABYOKQwfaRIrgZ5JxkB9MneFBJa2pSnePH7hHX8IU
         xeisrBKC8/ZJMPeLE6ylf/rmdHHY6TakLXWyRzqcxkC0cxi6TAdQ1U22CM3YSsSc5AwH
         XoYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135652; x=1763740452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8tk/MJG6ETPbjL9I+STB4rCENdOaFkmH/bVv9/0YHmw=;
        b=nSSwAXIZA4ZhtFwOt1qAd35LGeuC/QHrqhlLKdBR/QEByiMy4Hx+hSuT1WdRHxboyf
         vEVYitJqL2k0NBpYQSFwR7LMgVD3U1jYjJ0f9Z1IFCnMq6pdLtJMHqLv3HXACNZz7fUA
         DLXNA/1doyrB4M4tY71swkY5bN8rDxFkNDN+USpVoTLPHxq/gNQl+th0xCBXSSzA7IOH
         h2kjNXe8fJtweWU+BCDDhoRr8Y2SBetTna3RbHLYydgUKEr+pvyrHxXb/7UbcjS/ipu9
         ZpYmBzgAqZ5PoCmvJ/KT6DLYsiRB/tSPFeM8+TG+LSaJsgwx9YZZ3rrxzsWZ1AFOyZ+k
         B3dw==
X-Forwarded-Encrypted: i=1; AJvYcCVPaSd2eRH4eKjFKxq7FXVHV9nzePm8xfk9VuswZZwIUFOFBf4imOSagMQ85ZpSTZOoJSHdf7KweQ==@kvack.org
X-Gm-Message-State: AOJu0YwdRnMVUu9wtNkcxzjCKgHgssAdIklgI2sBcTjPVN/OBNtJjmFT
	q6qkxpld91+PKBGJA92HReyVRdGVhsgGcaGrru0pWLqpcO+wU5paSxwU6w3hPVBc0yk=
X-Gm-Gg: ASbGncvy0h44oxpxyXFm8uINWsCNHgCnu00XdD4eyOe7HJM/+qkCaOvr3mWyO5GS/0p
	pU8Kx20HJrKTFhkL1SH6I3pQJx4agITISxhcFFj5yJXSFf2YSV9zIQi4R6CTEZDz9EUpaYEim8z
	e/nviJJorUcXl2t6H/xdrDj6jWg44FF2Tg4VdlKlCtG4fk3qMPgJonhlGOQIEwbylVxxN7fyrLj
	Xcc32BtEAOJU6DyzEbtpDr+02OtN9X9jzJHzgkc3+zd83E9YXmt5HI3ekI/iSN8Qmr5aZgskZz5
	ojyv3txsPkvdKu5h0sWqJrlLBE3B9k94uaYyD+13XIFnPOFvVkCwsToaLuE1KdXDYOlupf21cJJ
	TxF6PeA/+ayzqMCn4Lz32UPODEF69LtoFwtMP2fdvLrFssE423XC/RuGqAEl+zOaBjz/BVDEgpk
	VXEhy0ClEwW4VWqySsoVQbIG99SS83Tm8eK/S4tgILqyhbsYLy8tbzjHEHwVeW0Hb6Qozf
X-Google-Smtp-Source: AGHT+IEKPjFYyY+rBQyyxkjYTOGTZ+qMZUOunITIXFEjHuqgVlVgfx0m5Asn01m13RGlg6YW8Khzhw==
X-Received: by 2002:a05:690c:338b:b0:787:d13f:4b49 with SMTP id 00721157ae682-78929dfe0e1mr36529017b3.12.1763135652005;
        Fri, 14 Nov 2025 07:54:12 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:11 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 09/13] kho: Update FDT dynamically for subtree addition/removal
Date: Fri, 14 Nov 2025 10:53:54 -0500
Message-ID: <20251114155358.2884014-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D93314000E
X-Stat-Signature: gmtrmobj1mmmn8cjx3ram1n9tay8c3zi
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763135652-241624
X-HE-Meta: U2FsdGVkX1/hDkBdijBEJslUd5AN5O9F+ClM41Bvlkx469cSaEfbIwx5qfvA9MHWjZH5SiyALnWlbAkhi3n1jMSKvewmv9TngLfSvhZeEmLqyR6CcJ4uf25+jOY8YNuyMEMbdQ39ZCxUBoqVg/4VMUuutYUfn8XwmnYs1C7WDAj5k5uZVYMwgW0vjgIM9E2DCYNVSO3xVA9OFUam4elCvH5b4WoqlaJIGCLjcimUTc0Kz5iq4WnpgvSL1xN76g5lgeutVnccwY5uPrqm2GGFKZ3NTtOrz53JQ/7jkHnge27vjFjpuu17L6A7qhDfZODcvHCy87zx5nYGj0U+JdNcCKSnBgP0OrX/S+cQ5cObEQmVyNdm4fCn2lG8V4eYrba3QLog6LTZHfeVxf+vD91acyiHEgKvb2di/0ZB088CvGbtuK/HeCep430DPfG38bixz4qMZnbgP8jhPUszSeTdjhW6hH3lWdEKG4ryEm4frWwO6Kwi3bm0xkNyZzsV2uDaMyrZ7xBA7eJ6D6aiLDovLPlJfdiLHM0M0QQBphv9atweZ1cBmYLelkeY0VJEuPz+yHhJaKYBnc0XF8L83+kHtxxyhUUltSBQ8CkVuBeGj6QZwLBiGX3tnd3H8KP8mqcT07qTtrergjinMLaqKMUaI7wnQzzeOxzQ+FW1czBXtkv8Qb+EmqoLD7Xf5lh4Hix+BWgLMgE6YAwR0unxeIzNh5fkobv/LTgJyB6Mc9ofB76PtHj4iXWKUu+loYzA+yJamnG34BRy02givyi2lfyOv6X9owSu2S52pdL+s2c+MAyqAm3mdlObPImjaD+BuDDxUn58/CRXTsZX3X4uzaBK/rGF6YKPEw4tie5hCTmul4rL/VzwRylofL7JAtPds/1XlZUM/229WfnthrrZBOhn46WIvybgY5uVKVd30YT5dkqD7Qe0SI4pxcZJ2MQXyXtzSso7dA/Bl1JsWKDrB0C
 zdBMQjvt
 +nacvPgporhZ05EnJcaGgLZz8HYeH+6WjKrIwo0i9/glVR6bjKXdF1xFQ41Z1YgKfy8ox9Ot1Dpz591ipabzedLcLLINHIO0qX/sNGCz0A5pItM38Fvd/I/S+c50FF5ZSApo5sC2JpRy5qvG9Mb18COC71ez7Vnqln8JtI+pBtEtB04I+Ru1ymKUvhABLlu1XHrEd295ORbcFGh/CpRRzBGYO5TlzEJJKlgLdKdkUICumy/Al+mJ4MGZl5CVT3tWW+LVMtEygY8kM+k3w8l3uur7+UQTPLlGtRiOqDSY7gs5omvIjGDK7cAvWcq90dSRYfDYN5eMGiz5fnF8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, sub-FDTs were tracked in a list (kho_out.sub_fdts) and the
final FDT is constructed entirely from scratch during kho_finalize().

We can maintain the FDT dynamically:
1. Initialize a valid, empty FDT in kho_init().
2. Use fdt_add_subnode and fdt_setprop in kho_add_subtree to
   update the FDT immediately when a subsystem registers.
3. Use fdt_del_node in kho_remove_subtree to remove entries.

This removes the need for the intermediate sub_fdts list and the
reconstruction logic in kho_finalize(). kho_finalize() now
only needs to trigger memory map serialization.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 144 ++++++++++++++---------------
 1 file changed, 68 insertions(+), 76 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 8ab77cb85ca9..822da961d4c9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -102,20 +102,11 @@ struct kho_mem_track {
 
 struct khoser_mem_chunk;
 
-struct kho_sub_fdt {
-	struct list_head l;
-	const char *name;
-	void *fdt;
-};
-
 struct kho_out {
 	void *fdt;
 	bool finalized;
 	struct mutex lock; /* protects KHO FDT finalization */
 
-	struct list_head sub_fdts;
-	struct mutex fdts_lock;
-
 	struct kho_mem_track track;
 	struct kho_debugfs dbg;
 };
@@ -125,8 +116,6 @@ static struct kho_out kho_out = {
 	.track = {
 		.orders = XARRAY_INIT(kho_out.track.orders, 0),
 	},
-	.sub_fdts = LIST_HEAD_INIT(kho_out.sub_fdts),
-	.fdts_lock = __MUTEX_INITIALIZER(kho_out.fdts_lock),
 	.finalized = false,
 };
 
@@ -724,37 +713,67 @@ static void __init kho_reserve_scratch(void)
  */
 int kho_add_subtree(const char *name, void *fdt)
 {
-	struct kho_sub_fdt *sub_fdt;
+	phys_addr_t phys = virt_to_phys(fdt);
+	void *root_fdt = kho_out.fdt;
+	int err = -ENOMEM;
+	int off, fdt_err;
 
-	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
-	if (!sub_fdt)
-		return -ENOMEM;
+	guard(mutex)(&kho_out.lock);
+
+	fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (fdt_err < 0)
+		return err;
 
-	INIT_LIST_HEAD(&sub_fdt->l);
-	sub_fdt->name = name;
-	sub_fdt->fdt = fdt;
+	off = fdt_add_subnode(root_fdt, 0, name);
+	if (off < 0) {
+		if (off == -FDT_ERR_EXISTS)
+			err = -EEXIST;
+		goto out_pack;
+	}
+
+	err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
+	if (err < 0)
+		goto out_pack;
 
-	guard(mutex)(&kho_out.fdts_lock);
-	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
 
-	return 0;
+out_pack:
+	fdt_pack(root_fdt);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
 void kho_remove_subtree(void *fdt)
 {
-	struct kho_sub_fdt *sub_fdt;
+	phys_addr_t target_phys = virt_to_phys(fdt);
+	void *root_fdt = kho_out.fdt;
+	int off;
+	int err;
+
+	guard(mutex)(&kho_out.lock);
 
-	guard(mutex)(&kho_out.fdts_lock);
-	list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
-		if (sub_fdt->fdt == fdt) {
-			list_del(&sub_fdt->l);
-			kfree(sub_fdt);
+	err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (err < 0)
+		return;
+
+	for (off = fdt_first_subnode(root_fdt, 0); off >= 0;
+	     off = fdt_next_subnode(root_fdt, off)) {
+		const u64 *val;
+		int len;
+
+		val = fdt_getprop(root_fdt, off, PROP_SUB_FDT, &len);
+		if (!val || len != sizeof(phys_addr_t))
+			continue;
+
+		if ((phys_addr_t)*val == target_phys) {
+			fdt_del_node(root_fdt, off);
 			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
 			break;
 		}
 	}
+
+	fdt_pack(root_fdt);
 }
 EXPORT_SYMBOL_GPL(kho_remove_subtree);
 
@@ -1145,48 +1164,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-static int __kho_finalize(void)
-{
-	void *root = kho_out.fdt;
-	struct kho_sub_fdt *fdt;
-	u64 empty_mem_map = 0;
-	int err;
-
-	err = fdt_create(root, PAGE_SIZE);
-	err |= fdt_finish_reservemap(root);
-	err |= fdt_begin_node(root, "");
-	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
-			    sizeof(empty_mem_map));
-	if (err)
-		goto err_exit;
-
-	mutex_lock(&kho_out.fdts_lock);
-	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
-		phys_addr_t phys = virt_to_phys(fdt->fdt);
-
-		err |= fdt_begin_node(root, fdt->name);
-		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
-		err |= fdt_end_node(root);
-	}
-	mutex_unlock(&kho_out.fdts_lock);
-
-	err |= fdt_end_node(root);
-	err |= fdt_finish(root);
-	if (err)
-		goto err_exit;
-
-	err = kho_mem_serialize(&kho_out);
-	if (err)
-		goto err_exit;
-
-	return 0;
-
-err_exit:
-	pr_err("Failed to convert KHO state tree: %d\n", err);
-	return err;
-}
-
 int kho_finalize(void)
 {
 	int ret;
@@ -1195,12 +1172,7 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized) {
-		kho_update_memory_map(NULL);
-		kho_out.finalized = false;
-	}
-
-	ret = __kho_finalize();
+	ret = kho_mem_serialize(&kho_out);
 	if (ret)
 		return ret;
 
@@ -1285,6 +1257,26 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+static __init int kho_out_fdt_setup(void)
+{
+	void *root = kho_out.fdt;
+	u64 empty_mem_map = 0;
+	int err;
+
+	err = fdt_create(root, PAGE_SIZE);
+	err |= fdt_finish_reservemap(root);
+	err |= fdt_begin_node(root, "");
+	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+			    sizeof(empty_mem_map));
+	err |= fdt_end_node(root);
+	err |= fdt_finish(root);
+	if (err)
+		return err;
+
+	return kho_preserve_folio(virt_to_folio(kho_out.fdt));
+}
+
 static __init int kho_init(void)
 {
 	int err = 0;
@@ -1309,7 +1301,7 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
-	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
+	err = kho_out_fdt_setup();
 	if (err)
 		goto err_free_fdt;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


