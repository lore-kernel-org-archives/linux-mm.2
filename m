Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6A5F53D9E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01CB6B038C; Mon, 16 Mar 2026 17:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3F16B038E; Mon, 16 Mar 2026 17:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84F96B038F; Mon, 16 Mar 2026 17:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94F4E6B038C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D34ABA19F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:02 +0000 (UTC)
X-FDA: 84553178724.08.B9CBCCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D89BA140006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SooNWz9o;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLQ5/+dAFTyleEjPQjbNA1FoFbhiHvxjMg5pI0fqPpk=;
	b=ysEAojenBIZmYcu0JbViiKcJBo5bufNjAdwsJ0Gaj5keQioMt65GtEmGHgAF4M8QcCYGDz
	mbT2ycdkjLSbtpOUrzayDnAZf12UL5daBpy3EEP2m+8cq5rOytmnB+qcJutfBqWzxSuEnx
	13RY4IVYsvNhcK61Hg/cp1MofxrCyK8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SooNWz9o;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695640; a=rsa-sha256;
	cv=none;
	b=ABC4P/CRoamAFEVDRhryoegMelU+o0UQDJgmn+zkzER2G7tO6aw5sRGY/p0vuiDN1xAxwT
	WGol0nC+Kb4LnsRCKsSXzRf4bkTnDJIKrRsjDalDcHgl8qHMKViBngJy8yYYMSbC74CAin
	PZuVXylpmNeeFth/xqjdFH8aewT8jTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5990460097;
	Mon, 16 Mar 2026 21:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5307EC2BCB3;
	Mon, 16 Mar 2026 21:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695640;
	bh=N35PsY/nqCRIMm5eMpyBBuhak2KyJHh8Z/VDZF7nLys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SooNWz9oGWPLg/eYQ4qw72qEAI7Ry/S3s8O8gOnGA6CxS8wYVzRNuxA7Ln7HYsFkB
	 zhRwtIZ61cvU2ELt2XjfJmPPH1gjNGhUmnwZ8mBvan4MrFkQ2J7BVbSn1VBjcUJ4k+
	 Of7ITjP7YAjTJ88QPRrmbFNX3DQtiru1EFQMUzDLKhqyY8W4/2OqNh/cDJAks0N71e
	 PqRbTzN4rS2Q33fuhZlURobKEa8hORbg2rbLlbLkyDcgniHiIgMm5saZU/WsJ2tGru
	 k5CxuqZc0QQnh1Zx/SWQnWnt/r6BZD3Km201D23jHKkR6KkTJyIpVF7uqiTCJ1dwqg
	 2LGNPUjqjjKAA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v2 08/16] hpet: replace deprecated mmap hook with mmap_prepare
Date: Mon, 16 Mar 2026 21:12:04 +0000
Message-ID: <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D89BA140006
X-Rspamd-Server: rspam08
X-Stat-Signature: 199zyxt43wwgu83kfgr6jrhztsknzn4g
X-HE-Tag: 1773695640-175240
X-HE-Meta: U2FsdGVkX18M3uX0ThUVDrOXt/Gg99Db6QF9EdYCQPMTg8k3dh9QijlylrEunhaHRDigK9WB4NKwMg1hFclioUgIdg+3qTWfafejLFbz5PjUze9wcOedASTAYVgQfCMdjFXAPG7bj7PgNFjSlB5mc8VQZk40pJ+dlHIYkTUKXYmxsIfJ2xtse1zu4Femjtb/YHD+ei6MKEp8mGzmj96P6NVWbxN2jQEhvrLuTtmRUQxPrxxw+jociqN9CAkMZ0+SAa9NSxpj2utnRnfqlGlcMM0/LW9Dp868UtOnAkIYLdkyd5tNorjHaPGWKlCees06O+VtXSWgUaa0tLN2dmGDLe8v1pc9d/w1ThwewiAVgyB39nl0r9TmP/Rnsahj8IBayqcQOA5xjdiwQ35eQFctmOXocgs0Qq6Lo9c56VwvTnxQ7Fs7E5LSLvyv4nLsfkRRjGWW8AYqUqNe63e4IZg7Y0M0tz0i/cV7a3mfdFCf0hp68XEQft/wCQ8+gNJJtwxx9Le570RJRMc1qllLgTUeoYuysXCUGMBNwY0Ud9hqxLfjISHZwwul3E+BZzO4ZIlVcv+Vm2XB9Ak/Pa6GmOBADCh/GbDTg0MgETC0+RGn2K6XqLSkr5o0vSKoyN967wTH+0S7N5WuBF3dgCfruJDGD+vkEtONu1ypu9x+4JVOmpOMuTWEFquu63EBa0mkK9FjSVp/YaKxIxALCoq4mj0fgH6EMD0zlq75fOHxeL5prY8ch/mCMQ2mvb4mO5BV85Uec5ErXwL2riR4jRL2F1OSPoGWFFAVOngOzw4tewISsMxG4VGkhA1PhO67UNRMa23ROj9A06+eem5pH11yc9vjV0hnmiOcDxWngWfGLWFhecrEe8idRDAPILm0FOkIIc2M6UdSVQHksixCEzS7xfjqPKeUaTbTJgeV37QrLbDhyon9HEwX7AR35bz3z3100aIIHCoOX2Aa8srNIQeicGf
 F44dykSi
 opTe5wM7I+Z4C/I0x6BUE8N8ja7bwKzkwCAmmFlWCxpKvpflnO9FVBSsqwFnxs8MKEUV7NtHiNgrMk5QO9dTzESULkuQ95L8NLV16g3LaJH/+tC8J1qqlEZ8PA3FxYlIYfqPukIvzq2Mxevcjg9syUgYODKzG09AxDXrVfPewshXyZf9d5NgZgVfKUBW/gASr0l7MdNTJ5orFoW3nLD6g/o0xo2OAJw/ck0ZkNfxRjLUx+QCxPBto/rOt6JPSu/Vsd4n+5WD0WspMbHY7D4xBLet+mk3DBWZgLydzXKPAYhPDCNIKMGQCSsZqDCwQRIGTp6pztA/vFrXTH7xKHIzPo9mlIuVmC3pYuLprI22XRmVFaC5u6jG//wiovAA2Z/VvUwoP3UOImehztwOUzPai7ss74iMMdn+4bqxtZwM5E2Tj+mLqcpOTPrdZ0wblGENyZ/mVvXrSv/eIQ7puYg7HTdimQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The f_op->mmap interface is deprecated, so update driver to use its
successor, mmap_prepare.

The driver previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/char/hpet.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 60dd09a56f50..8f128cc40147 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
 }
 __setup("hpet_mmap=", hpet_mmap_enable);
 
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct hpet_dev *devp;
 	unsigned long addr;
 
@@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	return vm_iomap_memory(vma, addr, PAGE_SIZE);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
+	return 0;
 }
 #else
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
 	return -ENOSYS;
 }
@@ -710,7 +712,7 @@ static const struct file_operations hpet_fops = {
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-	.mmap = hpet_mmap,
+	.mmap_prepare = hpet_mmap_prepare,
 };
 
 static int hpet_is_known(struct hpet_data *hdp)
-- 
2.53.0


