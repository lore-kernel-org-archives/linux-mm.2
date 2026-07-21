Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855EBC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC2D6B0092; Tue, 21 Jul 2026 14:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CC96B0093; Tue, 21 Jul 2026 14:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572486B0096; Tue, 21 Jul 2026 14:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB166B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:53:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB59E1C025E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:53:08 +0000 (UTC)
X-FDA: 85013681256.04.9F4167E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 15C424000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:53:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mO2MpO3I;
	spf=pass (imf01.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784659987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2fxgWVfhVcDmmyCVbD7ycsWuJeu20Oz3iI8akrC0uw=;
	b=RncUDqUgvwoN+fqa3LWY13gGbprEzEvpI4cxz2YjVVrnbHwbDzY60uJJ16VQkzCLmxwpAb
	efoglvqFy8jezv6MNYX4lRX9L7YyIFoLcZxLH+EQxEAS7/KGpnDprDgOHagDXK2QAvRgIo
	KJJaPvi60ps04Eeeys/rIpM4fgqnAp0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784659987;
	b=IvA0lc+iLeNvwaZB8O2ALH6oFjRlo2G3n59dBs7NIHbGzgGK68Us2IGqrLHIFlIBVDPiev
	U3PjTFENaX0V5+YfC0n5dHA4YFSc+iLIA/Ss6Cbb/aDp3Qd3jCHDJ5vqFXl8lpP0aNHrPS
	kzpYTx3tjdV2if+l/sm+CToHa8MHcmQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mO2MpO3I;
	spf=pass (imf01.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83ABE600FC;
	Tue, 21 Jul 2026 18:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A782A1F00A3F;
	Tue, 21 Jul 2026 18:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659986;
	bh=x2fxgWVfhVcDmmyCVbD7ycsWuJeu20Oz3iI8akrC0uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mO2MpO3I7S2kPQkzxpVqQA6FmRmQugz1QqsWE72UVlYDgo/AAZZ3OfXbH547dVQ+M
	 Wu+6Js2Bk2J3tX4Po2gMlLLKtmQHJiPTQy+KW4s2ta2tRhd/V02Y/kMAVTz9ckWCzp
	 wAZPjIooxlViBjlEK/b+a3zem4aIDpOHiBuWrmbxJlTjFQeyPMY8hHahAbAOPn/Qvi
	 VGGZ3ELvNsvE4WaCL5pNc/Uv5SYZDZpsnHOAXMg5Q09j7Gzo2wpIO5hvL0Jl+iYN3o
	 88LhGLhGkN98oPXcp+Kmww1kHLtrGZS9mLlqENmhsX3K2u1jxZju60+KG6T3fondS4
	 WgF5NiFKPTplw==
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
	Dan Williams <djbw@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev
Subject: [PATCH 2/2] kernfs: Unmap mmaps of removed files via file->f_mapping
Date: Tue, 21 Jul 2026 18:52:52 +0000
Message-ID: <20260721185252.1670958-3-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721185252.1670958-1-kwilczynski@kernel.org>
References: <20260721185252.1670958-1-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15C424000C
X-Stat-Signature: mrjewfbpy3d9mihhwrd4mqe7xrops9zc
X-Rspam-User: 
X-HE-Tag: 1784659986-717968
X-HE-Meta: U2FsdGVkX181Bxo0Iof274Gn8AKxD2FoeoFj/5XHr51LJC0VrwoZr0FVgdTH+C0I1dXDVDWMMynJSS2SkSgpC2O2YVUlp+u5M8w4w6ZVeAXtxGhjW70n4dVSgE5q1vR8Xf8C9IE7nz6vv3t8Mfotp7/TWOmr4L8i75ynzLSj1LvEfaCIaapzU6rytPtI7gUGuw8U5QGxHTczXZ6fYyqnqoYUf/woVbGmUXA7Kwc+umDKe+qSJZhbhJ2tv+jZKuaVZX71qBlekxgxJmx29Zd98vCQ+i2q72Y5xsjLwmzz/3xl3zVr6/6+4jjjrF4uAXyQ7E/jCWuMtn560Ki5C8FymEOguZgPyb0gyOxFMh5OIzd3vmhM5QrY+3YwnPJ8nYbnpoFFd9hrUyPji46NOwzgIY2wzfWp3Nl/x/xFDVDio9PcynKkiSSb1P6WFeTqvBEVnj27Nkr2sKPsfKO9PEaSDwrL3MosOAdaQpr3ZgVDeExrbOkwwS2rxyP3UY/fti/oCLnthdkDqjM5OuXN+sVhpxBo941tbmkuL8nfZCzBFtuzVIJoFKmIp7FtkLIISFEkDw5Iy/cS4EzSyuBnAs2T9Tf3vf7HWohd4hb60623htg+xD/BFgAiC9sv2OpQfKDTNLpyanKo292Ard/pzUR+HVWIypK1UMNWrcQVk9RoxhvpssWGxy9evogNfCRFCtnz6lSTPtO4A53wFbwEy+MHGL2PaPsdXPT0GGszjhqUc6WTRsDjibd1W8jKhO8ZAzwPY5Mcsrhf3m+FPYUizzFYg3uFcc16qwGh6RnQorAwr3gmsojQOXzS7e4Mcj+lAl14vpbWSY7Z/5DelSxNRxv7fm4+L8nk2KJHnQRPpJHlUTmDHGaDLTNghGU1ZGxZUNJZBCn8cCCy2F7Ix2vSaQblcFbtai0xsph1YHzMmFpPqMOKEpHCVPRuxCKoXU5S2eq083v/JEbAaQzsxhBaOpW
 4uflRlZ8
 mJSZWGHmnPFO4KOpQ+A1WVhSn20Oqd8x63FVDrsys0EiRb7ljSFUtgCCNH3k1/jY8bfjGEAPPukdoEnsKP841jFstXpsireJNsv6kLeLfbEK/EtV0Lr3f4jxLaDuB8DvBEpjn4KbtAKrKdC33N4QVUxuC+4pskbkH/qJDTHOQB29oGgDnEnyJ8CUERo0LpDWAraeIjakdecl+AhLNl1ZB0pYjN2uTebS9Qvj5r+hUuAPak716zkj9xgbP9C0pTs0XgGnsOK8fopBULqws952VI1S7nGLoxVrDXvTf0HfJ2h6+7MEvcPwOcSURbtA9QWuq62tKC1l2aI6z0TbOt99Z78nHhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kernfs_drain_open_files() unmaps file_inode(of->file)->i_mapping
when a node with mmapped open files is removed.  Since commit 636b21b50152
("PCI: Revoke mappings like devmem"), PCI resource and legacy sysfs files
swap their f_mapping to iomem_get_mapping() at open time, so their VMAs
are attached to the shared iomem address space, and the drain walks the
empty sysfs inode interval tree instead.

As a result, userspace mappings of PCI BARs survive device removal
and BAR resize, keeping stale PTEs into physical address space that
the kernel may have reassigned since.

Thus, use unmap_mapping_file() when the file's f_mapping no longer
points at its own inode mapping, so the drain zaps exactly the VMAs
created through the removed file, while unrelated mappings on the
shared address space are left intact.  Files with an unmodified inode
mapping keep the existing unmap_mapping_range() behaviour, and the
driver-claim revocation through revoke_iomem() is unaffected because
the VMAs stay on the shared mapping.

This restores the teardown behaviour these files had before the
f_mapping swap was introduced.  A read through a stale mapping
after removal now raises SIGBUS instead of returning stale data.

Fixes: 636b21b50152 ("PCI: Revoke mappings like devmem")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
---
 fs/kernfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c93372..8d1e4acc6716 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -818,7 +818,10 @@ void kernfs_drain_open_files(struct kernfs_node *kn)
 		struct inode *inode = file_inode(of->file);
 
 		if (of->mmapped) {
-			unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+			if (of->file->f_mapping != inode->i_mapping)
+				unmap_mapping_file(of->file);
+			else
+				unmap_mapping_range(inode->i_mapping, 0, 0, 1);
 			of->mmapped = false;
 			on->nr_mmapped--;
 		}
-- 
2.55.0


