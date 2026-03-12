Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1321106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6E56B0099; Thu, 12 Mar 2026 16:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5A76B009D; Thu, 12 Mar 2026 16:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8AC6B009E; Thu, 12 Mar 2026 16:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4A906B0099
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:27:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93CC913A70E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:58 +0000 (UTC)
X-FDA: 84538547436.09.07289E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F2C7B180005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsS71PUH;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lvy5rJOHJrWNbvNZ1GWz8/S5kBigQfW9EpQGvUKsjf8=;
	b=2ZNWEEAkQMURHJsIufcS7bGnNoK+WtXghVDQlfZJlNq/shXrrqePBgEBYUcZD1P6ZmO/mC
	mnR+5r5Yk2WF+LOu8Cxasc62Jl93xqLCPVlIrowCXeR5QxS0GfsE8+NuhDOPQN9nz5ciu4
	toL11R8Dm6oKfRoE/VCGr8exYGfUgoA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsS71PUH;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347277; a=rsa-sha256;
	cv=none;
	b=1m1XwY3gFmQYASrUNY3gJI1lFgGfAPqlFF/uKEiriiBDAlCxB6urBsCpX+tNn8iytzJVET
	EEY8xW2zOQ58ZXul2/EX43jZzaGI9uKs9lr/EPAnsL1NxlZ2KO/4V7c1Gq9Wra0Rjx9lxN
	syyZcD9htLoNmdh0d+vcDQG4nhPrpw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CA9B6183D;
	Thu, 12 Mar 2026 20:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98623C19425;
	Thu, 12 Mar 2026 20:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347276;
	bh=i54y1Tun/I2Qyiaxccl3VCrf2xJ8vhDj89GLGQXebTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsS71PUHhRME0/Uaazil3ddVQ6x1Nb+tS7PiTgEVD3BJWwzqK8TUuX/9qhmUpPZrw
	 Lg4mKIQkhpz4fU4hbDMTO9EUrAQT4wlbcLoCZKdOcCz+NZfjl8Q+mOJ+dIvGxVyjeu
	 ZS2is9c15J1TzVd2xFPIwYoozs+M9rRtHBaugZoVSZxArBJOvWnx8P1BE7Qyzx+NPC
	 d+nTISxjbSWvliCR1dzZZaWzKZ98G6sVj1YraiW2aZeukEi5vBTj0TkAo5/yilEylN
	 4qu8Q9EjngqPWWnJPTITewHgtWG6cFZT4G6UhH8g4Litr+0pJtyuOinB8M16lsR4oN
	 HvVHEGxDVmvjg==
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
Subject: [PATCH 03/15] mm: document vm_operations_struct->open the same as close()
Date: Thu, 12 Mar 2026 20:27:18 +0000
Message-ID: <52a7b9a003ea51521ab3c0baf30337a7800a3af7.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2C7B180005
X-Stat-Signature: gxsmq7eoug71ngmrmb61o7to3qkxurt1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773347276-281150
X-HE-Meta: U2FsdGVkX1/wQqMx449mkqpOPJd1gl4mEw9k2Qgx/LxMMZFGjlPzNMqvq9jh9eu9QA/1jTjTAXaBJ+Jy/WyXQTk8ZedPL75YPs5KZ+7ZaDujirhb4vKjZHUamRaS4GDpsz1P5b+PsHRaFm9q7Nh3YC/dZv+w62g74cMmQ52TIp6RCC5glfkzuH1ntWryJUNO47edF5NKxw/SYCRP1EpRUPUlH7tQeg3KvGdtXvxba8FmUv2yVl2mlbuWe3SzGy7ca6fY81fyfpQEkfRoJO7W1t5X8+P4v/dvs5TRN1iZTwUmTWdwRUm/24U87NvkbY/Q5AHQKHkq1u6rwaDO95IuUeeEbtO3HLq9CFNRBRlOfZLKuni8pfYct5/XKLJkvonZ+zUrW+WXQeMEyYghIl4mgQAP6qSo24EEbS5kNJbLeFvRonnEPCwWF8GnYCiAqwFSljJAAmF7/fwDbPWgXgSPCH+ehVNC66ov+XxEnkHBiUiOX0dZ3sWLmT6/+Iia5voOyj3WDuP9WvcOh5+GexL6pZDAkdxHaiq4lVY/gTqYbGhOtFgpCej27cEyuMRkRfvNNPHI4OvmQksyzkEhlmtE6XJyokcUu2CVXDvYLT/rudmIIrgrVf7xxoMdLgqeXqJujKtlFXfSV9HDIKa1X1vLY0/1Zll6x5DLbUFWPF5qq6wc1K/5zOA1FhjTWPLmG5EKH5dPFcC7/mH3ubGUJn9fNDQKMScwVQgUiinVYzMM7J9PDN6gKrgP9hfxd/lz9kibxZfFrkqORfdXahYPvfb1egfkPK1mgCW97HENRD7L7eeichkHdzMQcy3GeE/ZyOhHBOQ31VpTPtWQtBWyzgqTbXRZ+HESMuFU7vp7d2T12hoNMj/RbaVe5L9DJHw5th4AZTGDzc2v5dfT/vfoNp0bdn7I8n5EExkMOIRzDJFXevL6JLe1oJoCq8BqNqcgbCA4sF53AFooo80JV5w+Kbz
 ylrVrRNq
 NgKyfCWXdLO8P8LO3SSd8CVxFnIa9x0Wb3hNbU7jWYyvqcCaGaBzkfBjbrRmtTLRmFNhavUsazUEjsKLpDpdKU7t7Z6aFOTrzY5fDd6uniFKWJQmsd92FJJ6rcUIpFGBy+YXUoS8Bteq0hj75n9pRvAGNugoQaUntGK8FNmtuXOOw/Atmnb4epfFE0vmd9g9IHpoiKz3sOAFhcSIG7Flz9P2pMYu1jJ3Gl4MGLIJJDpOFNgNFOeRoHVrDkDYPN34rBrkoSrqkpZp9ebVuI4X+a7zyEyqY9ptSLSx0gIyAn8RzNrML6Qod9OaL+w==
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
 include/linux/mm.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cc5960a84382..12a0b4c63736 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -748,15 +748,20 @@ struct vm_uffd_ops;
  * to the functions called when a no-page or a wp-page exception occurs.
  */
 struct vm_operations_struct {
-	void (*open)(struct vm_area_struct * area);
+	/**
+	 * @open: Called when a VMA is remapped or split. Not called upon first
+	 * mapping a VMA.
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
@@ -768,7 +773,7 @@ struct vm_operations_struct {
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order);
 	vm_fault_t (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
-	unsigned long (*pagesize)(struct vm_area_struct * area);
+	unsigned long (*pagesize)(struct vm_area_struct *vma);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
-- 
2.53.0


