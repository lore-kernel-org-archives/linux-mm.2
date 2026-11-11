Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADD0606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=GYsZL44i
Received: by kanga.kvack.org (Postfix)
	id C57DE6B05BE; Wed, 11 Nov 2026 02:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DE86B05C0; Wed, 11 Nov 2026 02:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CF56B05C1; Wed, 11 Nov 2026 02:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3E06B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10E3740213
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:43 +0000 (UTC)
X-FDA: 85422073926.06.46E4670
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 33EB0100004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=GYsZL44i;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.181 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383621;
	b=g7crjbc9RWfQ4BRF61Ie6hL6zLVvnFHPudfx0aKcfFFj8/KoW4q05fu+n7A9xDKbHvJqhK
	aJMG30xRCqG8lfyQ9YdXdCS/tocSDUTwI8eedi5CHDGA77bSiG2w/onE4HgcEa2xTHpig1
	poQKOXWDQ0wsFtRSFOZ0FG49yiJIFEY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sK/H9HvHFSTiGugEGJQyMUnIkFUyigqct4WxtQyCZAI=;
	b=Hsv++vt9vGj0GBPssMEL0OuV8uf9ezFDQuUSBKwuv5AT734JCfd+te6I4KPv5kjEKKK8Fb
	reitU8IaqJ9unUywfXDYAXTw757LFBA6GcyJJnMtCHaBxJzloAQoKWNkV9UvPB4+XNE940
	aAJK4hln5UOQdv/nOaCVtseFdJ8o494=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=GYsZL44i;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.181 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso1266134b3a.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383620; x=1794988420; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sK/H9HvHFSTiGugEGJQyMUnIkFUyigqct4WxtQyCZAI=;
        b=GYsZL44iPE8C25Qx6g0QijsCZmHaPaS6FHFRFq/6uIqj+fQYVyPRM34kBewdwZnO9K
         JQBDDRtcgP+U4j6I41/qJuetCRGQd4nx1CjhWEk5/upGKoAb0Bmj30bjf2V74oQ3+EAr
         D8+MtbC0xZGK8yr5sClSJEEnwetGLmDtEMtwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383620; x=1794988420;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sK/H9HvHFSTiGugEGJQyMUnIkFUyigqct4WxtQyCZAI=;
        b=N7dTngU2hysxEyaREJmiOKRhuYW15iCPuWl05hz+jqjmMLJvewCEddvH68Qy0IFMdi
         ozwrx2kp+Tryd0HC4WV1edrb+0ihVEtw40P5ZDxWx+Fq5yyieu5Ma91fZho6qJujspYK
         Zf+k/sjyYpluiI+cyu8JbO11xO5/56fvXt0pyP0TKGbg41HDik1WXlR/cJya1dN1FQwr
         7OIs2cBU7QOFLFRYgBVoaS0SKkFrvwe09NmQp5CEMrrAfgC5UWilj1kfBTpU8XU/pWSG
         B6E4DIwA2ddgb6YzIvLFDi9i515UQdlZf2DtdJaj4uqredq7tmSZY54Cv2JjUndpImO+
         CFKA==
X-Forwarded-Encrypted: i=1; AL+hErGi9Zt8iY40qlgK8vGuo3Fmtyv/8D/bid/CF4jMawpRYOY2LsG1W5ok04yG1D5CKV/4LGWVUFKCLw==@kvack.org
X-Gm-Message-State: APuU4Z//oGCx9XXMyfLM2mOF5xywtlufkw+gq1fUFMisuXYQu8pnBe1A
	FJmMYHvDXweEsjpCK2kd/cMyowsBWbEBNYxgGwdAGVCiP9346xZwoUrb6agqqhfQ9m8=
X-Gm-Gg: AYBFou0DtlbuQ72HK5uY+QsTgPMm/zF8wGDLahDv2j94djWblXh7rfAY3RpqD6+0HrJ
	XBJQyotAZ8avQoxE8yGhNIOAX2U//AMr1gW15QCxGgE7zY8Le7S9Y5XuPnKL+5KE880cJgQ2bHq
	SEaXEAzG20dmsM4yPBYczlRcrbjm+VCbAt4dL3C6sY1Eoa+6rpZCS242Cxj6Bek+8MaSiAXAK5y
	kGSHnDEfW38/BDBjwpVcSB08v9SldsnqO5Prl8LOcEbX1zEblB/X3SBsOvcUZP9oFzSLx9gdYMl
	wgTuTwOd0KBstJGV4ZPpKtgSuC8N68AjDJTcfqIRp4DCsNRqcgFiGcwcEaHRZM04U8Exz+8S+I4
	reVu7SJ4ZEeed2KTcy72NBwLPTjKraMjtmHg3xrn+LwKv82TbxfOJIk2miNm2Qw5Dn4l4FZB6lZ
	b6YIDzEv2SoSvUIXqP3ob4TTJnW4ny8MOrzSZ7Ac/LXSHkYXY+nifRcEPXI53YuwsDVdvfn+ERj
	oVxOnESORcizEei9xa4KxzLTjanuUn8oVvig5RTu902xD96W4Rf1v7+pjAHIV7LAlJDOvMrbm18
	afOd+v+2k/m6D+XexYY6OFALELe+SDzY4A/iG3BUqW3jXW08PvH29ki1F4GGIl3HAn4IC7Qu1yR
	kT0DbDY/m7jmDAZIAFia4cZ396uM+PT8G2YN1WfjsyFohy5nxaQ+g2aasDK0FbFMDINe5+vlc5m
	PWeFBIQS+yLaRvYmxNi+pFRlHUjsuXjrL0E+rtsNRai1AaEX4cVv9B4A==
X-Received: by 2002:a05:6a00:2d2a:b0:8a0:1e49:71bb with SMTP id d2e1a72fcca58-8bc1ddf8792mr1803838b3a.57.1794383619946;
        Tue, 10 Nov 2026 23:53:39 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa2a6c51sm1842597b3a.14.2026.11.10.23.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:39 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:35 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 7/9] kho: Report how much handover memory is preserved and
 restored
Message-ID: <920192d01c6534b5754648e12840f73cdcfa73de.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 33EB0100004
X-Rspamd-Server: rspam12
X-Stat-Signature: nyg83ay5skox7kuepnpqrdw8t5t77ku7
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794383620-375410
X-HE-Meta: U2FsdGVkX19Xp28l4KK0JisfNIETsLnuPY6RIzZR0yGvRzXETmCksffwXTo75+eYA8Pq5nlgFZd9+tSmz/A0xWVVMOQnXVkhrtI3xuIUlRVtAoQ2Dz/jqJ9h7M9CI7A22Et1NKESp18DmO4ty3mU9OJDDjAMNr+xUNO0np3OkqNTXnNtQ7vzKKX19NITePCJ61CbdRswq0VXnPw7/mxKdsVBFeZvY4stfyUJV0AK8j5Z9RaawPKWGVOi9EGsZn+d6uB7iHYwoLI4OovsgO7mVkD6rEtdEO0uIxMGZOJn8srnh848WmZB28W4MV+hlg8qJelF7k3Anmi++Ld5vdx3kVk2Eriv1bHKxQDuK1PbPrcVan80NlZgNwR972SMWjr6+c+u/4Hlbz0duA0N6wjonOuhiuqqQOqa6BAjen68WSyV2E29YVl0OhGAyzYdlDYqh84WVdfhL0L/1Pp3s6RD/OJ1y5eUC78hB2l+rxG5JtIeIvoIMk6/4acWYxriQRTIlK9KEvGd9ACgF6ylejUXPBD+MRnvCXgh/dCfGOOYmps8kqTvwdfGxx7UWveT++qerFSNEmofk9tzceplay9HukE6GUpzEotUfEEEhSPfw7KRVU4A3UagsHKQo2phdRcy6zTC8e2wKQ/XABCozI20fUkd2qc4KwHf7wesu5uWvbLGyetvl2rE2y44wXafLn6m9OQ8+jXls70OJ2PnNFXjgrRo5EK8uDaxmkFhpGBSUZseoOfZL2XQSaNLLUrUz5wVksdjIjkIkdCS0eySFqFJJZPwj8zh+q6eTFjKbMbQXzCMlwHllM+0jle5kdkwZpUQEk7zODL2G8f9M7cLsP+SEevFmBalx7i7c2H9L0KVfdiGoyzFhie1UMWx/rlE1yd90veAXJAPt7XwU/JXGM3bhY9dTpJFJUFcKZBxMCBMuR0/Vn3Xaz46PX2XsHlBQ4QNVMjsAMyR9x3A2y91P3H
 2Frtuc9e
 CR91NKSNGtEv5vcRthS3TkUHqNCmQxKgH3kky85UCVNMFjp3E8oARPswylngus0Kg/eriaKvJzzrjF2wBbsgTs/Ruo23WV4MLeko/jnHPXeozbK6kCxnZ0ncgNKzDyFSlXYsjfso9AsDerEuj7zKNdzTanAUhGfC2n7O1w2r8+I9JcR0LKGFKQskIJmyj2ZDz4FRs8+AIyFKCwRJvf3vzani+GFQ8/K+kp8gUOvFg/dWdIrUailtTZ2VRA1yFXASwhKGmgemK/ASlG40X912iUgKn5uDs3iextZqV+8hJJ8I0mNQtjVuEZSr0zG8nAo5MrXu5Ag7l46qMwTv+tkvGCxW9+1qQNyzIOd6a3Myzh6qVlt7rJPYn50FkQE7XKHQrWcLnP1QvcdcrFpyF5rbDSusfMG0VocTSC1L/hwruqDojl5RRe/rl67cFHwItxmQE1jYfRV1zazXpDzoewb7nOu2hDrVlyXkrsDvxV1t2RZ7c2Rz1DOmma3Mk+zATGIeXfhmluQ48z5Di+Y/vnoLzr2h4FiVoPc5P4GP1KyjL6hrKLMHoQcQw4YiAiRhFgbI7PThuYD4Xz/oqrNLzHufnlBS9NFOy/qdp5R6F3oE75LP3MIcZrIXJqkDZEYAoFRFyCnWooxd+/IWkSSSS0/vyerZu05OWLG6dEqT8dpPh/Vw308Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Most memory the previous kernel preserved stays reserved until its user
restores it through KHO, either to use it again or to free it. If
nothing does, it stays reserved for as long as the kernel runs. On a
hypervisor host that can be gigabytes, but amusingly nothing really
shows it reliably. The host simply has less memory than it should, which
is not exactly obvious.

All preserved memory is reserved in kho_preserved_memory_reserve(), and
everything restored through KHO goes through kho_restore_page(), so KHO
can count both easily. Let's add preserved_size and restored_size, in
bytes, to /sys/kernel/kexec/kho_incoming/.

For example, after a live update preserving a 64 MiB memfd:

                     preserved_size  restored_size
    before retrieval       67403776           8192
    after retrieval        67403776       67395584

The 8 KiB left are the incoming KHO FDT and LUO's FLB header.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../ABI/testing/sysfs-kernel-kexec-kdump      | 10 ++++++++
 Documentation/admin-guide/mm/kho.rst          |  3 +++
 kernel/liveupdate/kexec_handover.c            | 23 +++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
index 5636cd060cb2..2b9f9917d2d4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
+++ b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -79,3 +79,13 @@ Description:	read only
 		           the walk of its preserved memory map.
 		"failed"   The kernel rejected the handover.
 User:		system monitoring
+
+What:		/sys/kernel/kexec/kho_incoming/preserved_size
+What:		/sys/kernel/kexec/kho_incoming/restored_size
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Bytes preserved by the previous kernel and bytes restored
+		through KHO, respectively. Both are 0 unless the incoming
+		state is "revived".
+User:		system monitoring
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 9d74d4ce18b5..37a62daa7622 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -91,6 +91,9 @@ sysfs Interfaces
 ``/sys/kernel/kexec/kho_incoming/state``
     Status of the incoming KHO handover.
 
+``/sys/kernel/kexec/kho_incoming/preserved_size`` and ``restored_size``
+    Bytes preserved by the previous kernel and bytes restored through KHO.
+
 See Documentation/ABI/testing/sysfs-kernel-kexec-kdump for the sysfs ABI.
 
 debugfs Interfaces
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index dfd6fa7e4a71..fe6b66270124 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -110,6 +110,8 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	enum kho_incoming_state state;
+	unsigned long preserved_pages;
+	atomic_long_t restored_pages;
 	struct kho_debugfs dbg;
 	struct kho_radix_tree radix_tree;
 };
@@ -552,6 +554,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio,
 		kho_init_pages(page, nr_pages);
 
 	adjust_managed_page_count(page, nr_pages);
+	atomic_long_add(nr_pages, &kho_in.restored_pages);
 	return page;
 }
 
@@ -643,6 +646,7 @@ static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
 	info.magic = KHO_PAGE_MAGIC;
 	info.order = order;
 	page->private = info.page_private;
+	kho_in.preserved_pages += 1UL << order;
 
 	return 0;
 }
@@ -978,8 +982,26 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 }
 static struct kobj_attribute state_attr = __ATTR_RO(state);
 
+static ssize_t preserved_size_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (u64)kho_in.preserved_pages << PAGE_SHIFT);
+}
+static struct kobj_attribute preserved_size_attr = __ATTR_RO(preserved_size);
+
+static ssize_t restored_size_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	u64 pages = atomic_long_read(&kho_in.restored_pages);
+
+	return sysfs_emit(buf, "%llu\n", pages << PAGE_SHIFT);
+}
+static struct kobj_attribute restored_size_attr = __ATTR_RO(restored_size);
+
 static struct attribute *kho_incoming_attrs[] = {
 	&state_attr.attr,
+	&preserved_size_attr.attr,
+	&restored_size_attr.attr,
 	NULL
 };
 
@@ -1785,6 +1807,7 @@ static void __init kho_mem_retrieve(void)
 	kho_in.fdt_phys = 0;
 	kho_in.radix_tree.root = NULL;
 	kho_in.state = KHO_INCOMING_FAILED;
+	kho_in.preserved_pages = 0;
 }
 
 static __init int kho_out_fdt_setup(void)
-- 
2.54.0


