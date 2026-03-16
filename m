Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64939F53D9E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8326B0382; Mon, 16 Mar 2026 17:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C580B6B0384; Mon, 16 Mar 2026 17:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BC06B0385; Mon, 16 Mar 2026 17:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2CC56B0382
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:13:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59799160613
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:48 +0000 (UTC)
X-FDA: 84553178136.11.1B8C5A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A8EBCA0019
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWJusVF2;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUvO/OOUd9UySLDHj25on1dt+aaoauDmqJv//S9HN5Y=;
	b=Sj/Vs7AN2ekIZ4ZsJ36poIe689cSv+VeBVXz3zA5Zo/Sf4h+TnkVPegwxuJYXELvQhxT6/
	MWCNA9W3IOwSzHDhKyyqrpClwnQdv+zJlGxlBOOFeSI7JXL2zORYt5em7wu2VhMEQkGax4
	2CYOP0AdGTH4LAgL7cYv+XqNGZHLhCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695626; a=rsa-sha256;
	cv=none;
	b=cBSaxFazVdJ9Uk/WgaZ3lpa6jo5WdLdedXs1Q42S82Jeg7+ogwaA7ahfOfex8XpYeFHfyX
	O9u/X4caJcQRU8vPZqUUPfcXL1N+wNodmJK5iFmcexHZ/Jm/yLxAkZuoTucL/OeaU9Kt03
	68ZH5Bs7YHeAcOUhE6awE3pSoMyymJM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWJusVF2;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1804F6132F;
	Mon, 16 Mar 2026 21:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D81C2BCB0;
	Mon, 16 Mar 2026 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695625;
	bh=ZYlwd7PUB52+Aa0tSM/x3ehotacgsAAPggxfy3ZY/yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWJusVF2FYj6O20AjF69vHaZdlhTuW/FCX7sLY2J2xLq8x+plZOOruT+CF4eJYvzv
	 XjSYmPaEbveXWlez2yANSk5agjSZYes0IACOfpPEvuka5JegNzPZR0+OMZhsKdk2ot
	 0gTOgqPvBh17kkIac26c62pBaxMWDHJSOQ13DBcMm9h7Rcu1PBf31yVwHlyeTE01qO
	 qo1+4JBJvqmYyOvv1Djssoj3ko/LzbF5GbbJBGE7xGsguAdY/Y8V0TWdDHhMzwYRMj
	 my3q8mKn7Euc6QuFg7LNDQwpx7TcZ+q1HLSrruWE9RD2Z0nOIKQG4cYZDA7Ee1dXZH
	 ql6we8wIwi+qQ==
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
Subject: [PATCH v2 03/16] mm: document vm_operations_struct->open the same as close()
Date: Mon, 16 Mar 2026 21:11:59 +0000
Message-ID: <3cec125f9eaf9dc44e638a56c76d12c58684af87.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8EBCA0019
X-Stat-Signature: 61fyzzgr4a8n1rphprac6jheu9m745im
X-Rspam-User: 
X-HE-Tag: 1773695626-397796
X-HE-Meta: U2FsdGVkX1+EtdCXhZOr9PHC4DPK6kB1FwVC5WSGT7DJKWaWF1D7k6UJLeHVLzlgRFItpXckQ3QlyJhSMqX6eMjUnj/nlUTuuEZOPvFiImzY2FZIJ9pP7BQna67nELpX4iefQXAbDN8zdUBQRYrnyO30uCZmu1ls957BfF99DeYQBivLCsR2VBTOtkRKupvcZmgxzwBchBNJy1xKzGB34VXsLcKnznxrmHy4Gfq8kFdjuINX/QxAgpP9PWeyjzhOn5SYrJm/pUwd/AEFGKOn8qbYxbB8zenMSPt5n28BkXtDR66QgQ5DqvrBW0P9273M/2fFORz1rt3vPD9GD8QSygHYvq56+5Qm3bnBNBEi1m65I6OfVc8tSwPMwOgH5oneqOwF0HGKyuyJmS+2QdnfBEWTLPQc/1digHCjF9aytCGttIh+oP/MsjtfFYrxURHuS38KflXmFh/eyla+lI1+Eoxiw0OfGPYQUPeu8NWQnEEHfBO8DpjJcJ6iA7rPS3x1qxXbw3AqU0gXx1G+wVTPTkyWx7LNePxtvmCpbYZFhc0QDQ0RUQjDEdN69l7eolLHt4xT0reow03OPawV/faLNs3d8VHfNYZzD4o3XfKI3u/IRv/2yQmQU/ddcNRGq8nu91JT0+t3jQrrvDSwUj8mcFjV4SyY0J/mmU/MQDk6dJP4hB+UifNY2L8bP9Yz4odMfeUXTzF2SMjNtGS1dRyBpZdZ4yz01n1WOvvBct9DGrCd2ZrpYVC706AwaqJRhshmD4bkVYv7JZjbe1svigbRiSnNE0DNIKPnuDT6Suv1y53F4jV7vH/jZpEscjyswJGWavMNwRR7wYC+iudTjqFwFza+S0AhjWsdO7nLGlcZ2lJZEW2oJ6oNy665C0jGBc3lw9OSP2LWEwPPG151Fo8zyt8sueFezRyzah2Q5LQJjC3GuoeQ6v16NmSi/NQFr4hU3MSIpHGqSJzS31fhZC1
 IrvegpP/
 VTbSJBw5gTOd002d2JBv7yzW2YFEcFvPme+358QM9tzQuRbosMHBZdGB/QJNAgjOlm0yI4QxfGYz22Di6zEiak2o/55ndDuZXaAZJVYIwUmK5MTgOzw1QL2IK+P8z4D2jYkdGcJrZjq73tm3/duudY/BgqktQyNeKf8mR9xrgXXrfbtK5NY9I4VrP2MeCWiauvBBFCenoq83DYnZGRqoC249al7cLxa44vFhnosArzNdgvsKt/p5FRfQAbqlaFASvoA0xVVROQWMXuEWA0UqDzaT4o1WPVWLrJfH8z+sUPczqKMDIwiYHI4CvS5HaQJ3NvCMgSAmi2lAZ60qHcqN+tdSUBhGnWsCLWwym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe when the operation is invoked and the context in which it is
invoked, matching the description already added for vm_op->close().

While we're here, update all outdated references to an 'area' field for
VMAs to the more consistent 'vma'.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 15 ++++++++++-----
 tools/testing/vma/include/dup.h |  5 +++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1e63b3a44a47..da94edb287cd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -766,15 +766,20 @@ struct vm_uffd_ops;
  * to the functions called when a no-page or a wp-page exception occurs.
  */
 struct vm_operations_struct {
-	void (*open)(struct vm_area_struct * area);
+	/**
+	 * @open: Called when a VMA is remapped, split or forked. Not called
+	 * upon first mapping a VMA.
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
+	void (*open)(struct vm_area_struct *vma);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
-	void (*close)(struct vm_area_struct * area);
+	void (*close)(struct vm_area_struct *vma);
 	/* Called any time before splitting to check if it's allowed */
-	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
-	int (*mremap)(struct vm_area_struct *area);
+	int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
+	int (*mremap)(struct vm_area_struct *vma);
 	/*
 	 * Called by mprotect() to make driver-specific permission
 	 * checks before mprotect() is finalised.   The VMA must not
@@ -786,7 +791,7 @@ struct vm_operations_struct {
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order);
 	vm_fault_t (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
-	unsigned long (*pagesize)(struct vm_area_struct * area);
+	unsigned long (*pagesize)(struct vm_area_struct *vma);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9eada1e0949c..ccf1f061c65a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -632,6 +632,11 @@ struct vm_area_struct {
 } __randomize_layout;
 
 struct vm_operations_struct {
+	/**
+	 * @open: Called when a VMA is remapped, split or forked. Not called
+	 * upon first mapping a VMA.
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
 	void (*open)(struct vm_area_struct * area);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
-- 
2.53.0


