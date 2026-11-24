Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC5260784A3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6MV3T+Q
Received: by kanga.kvack.org (Postfix)
	id A56666B0713; Tue, 24 Nov 2026 09:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A081B6B0715; Tue, 24 Nov 2026 09:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CECF6B0716; Tue, 24 Nov 2026 09:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68C6B6B0713
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:05:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67D96C0BD0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:05:00 +0000 (UTC)
X-FDA: 85470183960.08.75241C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A9C0A40005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:04:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6MV3T+Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529098;
	b=XK60JzqVIhvxxhPkvyXY0YhCoMNS65H7LuMnITcSR8DqFQt8FMO3HyIV2bcGXeGffKNt+K
	ks1JGnO7JzWRsI9HQLU46gJNKQqQwR/3FpPbDOkaj313fIRnvhLRcIKcDirmaKkwkDPzwn
	PX8u6YKcIYjN8gby7MIjgsjZgH8OqyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyKHuWz1d2Frm11VryLe5MVhcgNxdq9OLcfJXX7QEjE=;
	b=Qs2qBgCuUtNEqD5R+9daQTZ+jDtcetAKXy4WBLv43ouVwnxJzWVz+FTNUYKY9Ewv+kqEK9
	UMs5AhHMg/fPIAepbVhAUo5c9fo4uL3G5y6cGgt4KaX9IUxJgiLDGiMJ5+rlGa0hYyOAXj
	l2iEC1TOgklw6zizj2j3pO14VTjU5Lk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6MV3T+Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A2CA620C2;
	Tue, 24 Nov 2026 14:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F63E1F00ADF;
	Tue, 24 Nov 2026 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529097;
	bh=dyKHuWz1d2Frm11VryLe5MVhcgNxdq9OLcfJXX7QEjE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q6MV3T+QtMeFGS05JxbY86fyXxb5BpRhz2xNTl9eMNfcKfw+grBzdABfY7zkWcmhf
	 3oXmd4lIvhn6HY6OzXXCGpX3x871baxo9e2taEWdz4G5NRtFr4HIZLW/Mmej4HB25n
	 pd5Rhlwzeg+i3fuK3nnd+/5nYHtvXaH9/5nXXdyOVT9uYdK2a7c0OsQs/bVh+3Yb8D
	 8M6p5tkece9ezcQQtmoIpKbmcdZqP5JmjEIvTz5EAB0KjX1oZMDeijKf3LV7e9LjgL
	 CH5DW18DiH/zpC3bH1tBGKVdQ66YVARE97fBELOKoKVCGs4OrCADqFtuBQSEP/uZlf
	 9AljS1iLyidaw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:49 +0000
Subject: [PATCH v2 06/13] selinuxfs: convert mmap hooks to mmap_prepare
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-6-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2650; i=ljs@kernel.org;
 h=from:subject:message-id; bh=cFTcX5zX06yJZykgfJZX7vj2B6uDxu9XGGETlT23sQE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4oXBnSrzg9q6W+pOxNa5sv2mHvLOWmLDf/9bu4Ve
 ODDKszVUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIm8fMzw3/3c1MgpujcfSn5k
 2CWletNH79GRC8V1Jxk2GHx6IO3yXJmRYf13k5To5D2ZX6wtDu9wmJ724si7t5XdipY5N4On9PC
 z8AMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: A9C0A40005
X-Stat-Signature: jtxeerms9hx8qhx3cggch54txy6qfted
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795529098-207751
X-HE-Meta: U2FsdGVkX18RQ+WuqmaefxRb8exzRq0T+Vr5Eh8jtqoV5NRpNtqUlm9hiXepC7HVBJCgwMKXIRmHAhNHPJVBQfE/edBzRWg77QQU0jso2MOb/SWzmf6ilkejiY0jVKrnFuVTaO9Wocy8t5CC113vQErrCdaZJLeRBB85N9sqhQpoxLE/f5wOsT6LutzuEZ92g5om7at6tQvZYWAEkZgVUTZ5DPsjKUBOmUiwTLBuBT/JDEJocuMj4k4ODXmZxGcTEQ9PgrzRZmikhyUUwXWaF8jKWPGSks6JuHpJaPvhOE+B3y8V4dGhcaH1iQQAiRnJbs1DfLPXK7A6HtnQerns4gu7QvFC0JnHQe5bz5p38Ja1Wm5A9H9zBdUKhQszeOK/pgtoDs7n1Q3gXq9lTV35Gr/+k71SmGcXtII9uW8VGLVJgsdgeequG+5bMcvpArLy5XuQEzJOJ+00GiAhRfCJ5loOCm/suObu13HvAgwsB+VwibmNJ1QCix0G9RxpuuOKAwecr9IAqxG+u8GD7fKWuq/W8uk6egyjK35Gvt/B7pN+VYod4To9AR27RzAwwsmLGQ5ywAvqCjb8yBQCxQnnSv9K/vIgTMBIh/rbaKN8fSQKLkuqGFRNKzK5aaw/usKAMLCdORqoEmhNeEkZM4LLyTpXdJRQZiUQS6FaooUwOcZ89OojS5/llfv4uPpzrzvt9KbZtvb+RGUEecPH2tcyC8BFD2YhsqQBLcZGTixuufGyWv7l/8tVf7VKErpHmjWOT3Vumy44C5kWhZByI2tcGEEiImZB00qEztb9/tyX4H4MkyCz+C8Jyh4I4wcDFYkBcEW5QXwcOK6KXaMaZHhZpd8Sc8Q74wh5y+RjTLsQIQkFr4uRexkBXoxR695t2CBSGtWmoNXWDECJl3v05UUDsg79kwwIiQiRBMnBkrp1/y6RfFZ6RYYG/5RIGgOGWgmX72nkEz6jkKy8bOmA719
 yLvdlS5k
 e9adhR7epyMP1MHVQa5raGTUTqaEPletbvjcIQGm3w/zxs6GLgHc7+WSOtKvbolHt/6QtKV3JCYQv5Iqead17JN3H5i5Mo0SqLi52U3+tVLKCIkUlJjZe4X6L6BS2un97j3RgmQFX5B1mfrD9V1aoh/3PgVhMY5uudXauYWEYLZqsSN6w0pr5W1NVoIEuZ+/EYK3HatJwX63wMqCXGgTIrDfvGvQfhfNisqpxRoe3DGOjDvGhla8SJMhD8NARNTZfxn6ByNWOgJoHHiNxcRIp0liOzKAjfq/4nih8Q7zb1Gc8/UGxQ2A+JZgX1s998RH9KjGeVRhIxANotwW2zloA90h9O8fyKwpSZNeA7wAm7pj6TJUXGHBkjNz9hvV4sHqJTFcKmWVu1/bdE0Q2QsfXZ4RuUSaPdHrdjKoR+gycBufG9A1CMSEbTKjdoxZYP+NzKVPEXSFikc6J3sKHbcIzTnbdCi3PlqfDvbzwh7Cu94k87r3aKOR0NiYWYtAb2jTinF+F3XKPFEU8VQLTTnJlc0QtnwH2swNgpBmy8DeWq7yezM6Mhtx4/tuGDZnoaHGl+Fj0LioWd9D52pXIIG2LJ7mB0azWGuPA5RJP9fhEkd+CBeAhLrFGte1UmBUx49fkiu7YjMD1THHyIjAuO0yk70bK4SOmsGaVQ1HoWRmauH9mdgH+iUWfAQG8Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move from the deprecated mmap hook to the new mmap_prepare hook for the
policy and status files.

The policy file only sets VMA flags and operations. The status file remaps
a single page, so use the PFN remap mmap action to do so.

Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 310e19efff1d..e78c65685020 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -236,27 +236,25 @@ static ssize_t sel_read_handle_status(struct file *filp, char __user *buf,
 				       sizeof(struct selinux_kernel_status));
 }
 
-static int sel_mmap_handle_status(struct file *filp,
-				  struct vm_area_struct *vma)
+static int sel_mmap_prepare_handle_status(struct vm_area_desc *desc)
 {
-	struct page    *status = filp->private_data;
-	unsigned long	size = vma->vm_end - vma->vm_start;
+	struct page    *status = desc->file->private_data;
 
 	BUG_ON(!status);
 
 	/* only allows one page from the head */
-	if (vma->vm_pgoff > 0 || size != PAGE_SIZE)
+	if (desc->pgoff > 0 || vma_desc_size(desc) != PAGE_SIZE)
 		return -EIO;
 
-	return remap_pfn_range(vma, vma->vm_start,
-			       page_to_pfn(status),
-			       size, vma->vm_page_prot);
+	mmap_action_remap_full(desc, page_to_pfn(status));
+
+	return 0;
 }
 
 static const struct file_operations sel_handle_status_ops = {
 	.open		= sel_open_handle_status,
 	.read		= sel_read_handle_status,
-	.mmap		= sel_mmap_handle_status,
+	.mmap_prepare	= sel_mmap_prepare_handle_status,
 	.llseek		= generic_file_llseek,
 };
 
@@ -419,10 +417,10 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 	.page_mkwrite = sel_mmap_policy_fault,
 };
 
-static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
+static int sel_mmap_prepare_policy(struct vm_area_desc *desc)
 {
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &sel_mmap_policy_ops;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &sel_mmap_policy_ops;
 
 	return 0;
 }
@@ -430,7 +428,7 @@ static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations sel_policy_ops = {
 	.open		= sel_open_policy,
 	.read		= sel_read_policy,
-	.mmap		= sel_mmap_policy,
+	.mmap_prepare	= sel_mmap_prepare_policy,
 	.release	= sel_release_policy,
 	.llseek		= generic_file_llseek,
 };

-- 
2.56.1


