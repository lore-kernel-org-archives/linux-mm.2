Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BBEC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7286B00BF; Sat, 25 Jul 2026 17:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A216B00C0; Sat, 25 Jul 2026 17:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3183E6B00C1; Sat, 25 Jul 2026 17:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFC1B6B00BF
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:06:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FB6E1203D3
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:06:09 +0000 (UTC)
X-FDA: 85028531658.13.5FC8F36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9547A0007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:06:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IwtkvEFy;
	spf=pass (imf25.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gp0it8LdFQOsDvrEyvMyOsogKt81zs4FSO3UF+0hUBw=;
	b=VOwFzce+zjxR/sWvxtbt71nZF2vzra9WDbUcXk3av0ZLp9E6Rk7dkyKVUN6ixYt4QvCqWg
	Z7MoY3Vwp/JOq3jqb5/brrMQxsG1kmNruofJbQZp4ZOKLd1uk9sZoLFDkms2/Gp5Oe00hy
	EN7p1+/95wG8iCYT++ZO6Pp0g4dpPSs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IwtkvEFy;
	spf=pass (imf25.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013567;
	b=aA9yNHMqzyI7/KNBpX+0K/24RVUcPFIcd65pnhV7SkBytwQH5W5A5O8Neflu5pAx3hEV0q
	yMApB9zFPWvXJocCIOC/hWKCk5Mv5Xo48QO3AO9a3RuVS7cH4ojIiHnMnFXVeQMAalJEWw
	14wx6cXXu1QuS/h+cWDjGAteCmEEwSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2CAD42A78;
	Sat, 25 Jul 2026 21:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0388C1F00A3D;
	Sat, 25 Jul 2026 21:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013566;
	bh=Gp0it8LdFQOsDvrEyvMyOsogKt81zs4FSO3UF+0hUBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwtkvEFyAIM6vGrDMW4/eUdNQ038aHJMSbJCAgVJsuaLJ5jupcJsAw/nYe6E6lw4T
	 YhHwt5fqo81OTeSFy3m+6oEOt0xQeFajetvg4K400c72KKY2UurSSkwefCB40T7p9e
	 LGLPNeQPAz2eXdLWjyBJA8on8wZC5JRnM+GAE1HThZqfu5MFqNZ/I+HuF5knkEXm0H
	 BWt3V+O+L9cJlnq3dhjZXHAvdatLD31aNENVKgeMfT52yLNg/agMDhL1vTBw5Fe63X
	 4Uix4b8zjxDzLQ0Z4eMxM+LiTeEzGTUSP2N6+DZ61oNgbWgM3iIde6udTc5qeZcqMf
	 G2V/byQRp2Tfw==
From: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	kexec@lists.infradead.org,
	driver-core@lists.linux.dev
Subject: [PATCH v2 3/3] proc: Unmap mmaps of removed files via file->f_mapping
Date: Sat, 25 Jul 2026 21:05:49 +0000
Message-ID: <20260725210549.3716546-4-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260725210549.3716546-1-kwilczynski@kernel.org>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9547A0007
X-Stat-Signature: ph34o8jpabbwoydjyrqfy795cj9hsjhm
X-HE-Tag: 1785013567-470438
X-HE-Meta: U2FsdGVkX19yd998FD6OpqoxIcjSx6mCF6vtfP8IWJuCHvHjFt9qkG38NPzvP/bBvKqbzkQComxZiMaU7PgQPfBfW1vmL3+s6Vg4qSTgyt6M276CmgJwG7Q19MvxLfPdtTJc4usYAL6hKK6XoxlvpGZ2zM+DxG/3LzIzwn70welHhxn/its4Yz6ufsLT/4+pNYOc1zyRi7uMlzDKbqlON3lMMDd1ui/v1tSXbGAZNjDlPPsPt7bYcRp+q9m7akDtA6I4N5iqE4dQbYF4nGNGFiEz9VzJCAkSrerTNZOwdwMwhzlDS732019xFNFqDjuAAW1VSpSyBaNu1PEhJAtuLnNRhHhbkHhqCFTgoTGC8htocXLLy5U3rxiA6Qoh51fSw2a9RxNWCoyF7He7prWuAznXHq5LdPmBctaLaHpGRmQfIvVDwTPRU/ixpME8xz7pQQtJrGo5xgs/NByvXyJ5PRXowQEThyneWxzynE/TGBUBneeVGyXQScaytm1EFLjDlPePC6iQSB9LMHzyk4ENaBaA1l/+fiC96HADstf1Z0U/rugZvujqxu52BK+zsGQ7zyZbG+dZR+2XJMz7QcoCHcIbkp1qU37rRHvNUYYKQNB6DTfaNP6akaK9UIIh665BipzRRKEuj+DwAuAzDhLZCosREmJ1CAlJTF6hCYdHUoGket6fcOhs1MdoSUpOxBFgZMZkkRubTdJGX/w/sHV1LIncqpVQt6Y0eFDyU7Y2VRReU+U2TIeZHyl53/yQrroBKLKyDfMtTjoH9tG/vqcaHOGiY4BYYK1Ew8P4bpD8N6MresVD/Zt95Z1IpyRaBrQQAK5yLe2ZDPX9WGBxSOIDmYGn3+P8MT5HYyyNvlSioG5Nov4UpuEHxKOQWh+hu2WTMyOy+icG/lvOMzUr/eCiXDJZJ2yOBTzhV0+s57jhyrEPIE2jZVKDHOwg2UT0JsdH6KWQT7Lj5iL2mL0Q91x
 ptN4zulo
 W2t9r1OIHyZ84IjbGiN9mOJ83h3vwlHN/AftkBc8dSx00U3USHGzqmIKgwLVq69o1jmpenz5zVNxu043DKJry/oogAjd27110/QBFQxTdGnMmuS8ueUU+RSkpuOFLvUuL8RpNldNxWVQ0oxcwviOAR57Y6LM3XUuE7wPygaDlqond6HSVS/xFgeIrMOvkqJUVZu0dtSaSKLQ6teXHnr7YrplF9gOwSd+NS9Ap16KkrOHMlGelIkYPFZNh1d54O3t//7UVWGD+Rnz9efDYf+36/rqmcaavUBR0u/TrPGo06UPI8MAMsoZwC4cWK3MhrLpuOQBgwaDWiwVUWDaBTAY7JrKoRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, proc_entry_rundown() releases every open file of an entry
that is being removed, but never unmaps the userspace mappings created
through those files, so these stay in place after the entry is gone.

For the /proc/bus/pci device files, the VMAs of such mappings are
attached to the shared iomem address space, as these files swap their
f_mapping to iomem_get_mapping() at open time, see commit 636b21b50152
("PCI: Revoke mappings like devmem").

As a result, userspace mappings of PCI BARs survive device removal,
keeping stale PTEs into physical address space that the kernel may
have reassigned since.

Thus, use unmap_mapping_file() in close_pdeo() to unmap the pages of
each open file, so that only the VMAs created through the removed file
are zapped, while unrelated mappings on the shared address space are
left intact.  Add a pde_is_removed() helper next to pde_is_permanent()
to tell a rundown from a regular close(), which leaves mappings alone,
and use it in place of the open-coded checks in proc_misc_d_revalidate()
and proc_misc_d_delete().

This reaches every removable entry with a proc_release() hook, not only
the PCI ones.  Other than /proc/bus/pci, the only entries that also set
a proc_mmap() hook are /proc/vmcore and the ALSA information entries.

Mappings of /proc/vmcore are now also unmapped when the entry is
removed.  The ALSA proc_mmap() hook calls a per-entry callback that no
entry implements, so these cannot be mapped and nothing changes for
them.

A read through a stale mapping after removal now raises SIGBUS instead
of returning stale data.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
---
 fs/proc/generic.c  | 4 ++--
 fs/proc/inode.c    | 2 ++
 fs/proc/internal.h | 5 +++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index adc9b9a092b0..0d090e3f3a26 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -222,14 +222,14 @@ static int proc_misc_d_revalidate(struct inode *dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
-	if (atomic_read(&PDE(d_inode(dentry))->in_use) < 0)
+	if (pde_is_removed(PDE(d_inode(dentry))))
 		return 0; /* revalidate */
 	return 1;
 }
 
 static int proc_misc_d_delete(const struct dentry *dentry)
 {
-	return atomic_read(&PDE(d_inode(dentry))->in_use) < 0;
+	return pde_is_removed(PDE(d_inode(dentry)));
 }
 
 static const struct dentry_operations proc_misc_dentry_ops = {
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index b7634f975d98..f1ebedc85b15 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -239,6 +239,8 @@ static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
 		spin_unlock(&pde->pde_unload_lock);
 
 		file = pdeo->file;
+		if (pde_is_removed(pde))
+			unmap_mapping_file(file);
 		pde->proc_ops->proc_release(file_inode(file), file);
 
 		spin_lock(&pde->pde_unload_lock);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b232e1098117..53335381ae89 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -79,6 +79,11 @@ static inline bool pde_is_permanent(const struct proc_dir_entry *pde)
 	return pde->flags & PROC_ENTRY_PERMANENT;
 }
 
+static inline bool pde_is_removed(const struct proc_dir_entry *pde)
+{
+	return atomic_read(&pde->in_use) < 0;
+}
+
 /* This is for builtin code, not even for modules which are compiled in. */
 static inline void pde_make_permanent(struct proc_dir_entry *pde)
 {
-- 
2.55.0


