Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910ABD2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DD76B032E; Mon, 19 Jan 2026 18:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26F66B0330; Mon, 19 Jan 2026 18:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D716B0331; Mon, 19 Jan 2026 18:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D43626B032E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:04:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 974768B269
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:10 +0000 (UTC)
X-FDA: 84350243460.14.CA9C4FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0EC46100003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ggts6Muq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8g1HSdarzqijP3/jpnCpDa8vZXIU77GlmxbrXw0pVh4=;
	b=keKqUXKPl89mC1kjlzICsszOURR3PJxvO+4ZJ3Q8SLcpgzDZI9rVOw0u6GE5TRKkjFkSVz
	3siHoZb4uxpi+jmj15rhBqA3tnJg/m4DaDQeigS6lGyJei04aJ1qfeNNGcdDWXUs86wR4b
	9VY0JQ5cOQ67Rhr2a9SAqsmXr41Zsfw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ggts6Muq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863849; a=rsa-sha256;
	cv=none;
	b=njfqzbh0D3mcQkmRz4wNX0Th/GhICKLEkUK1rK2OyRGwErvN7J5PK0qM06QaNez99KtJNB
	Hlf7yXVJPwWENcYOF9z+ayG5WElkgMiHYBSiThUvK9CWmgTT2JDjAdqOZ9ZzFL4srMFcZp
	WgEWHoPM32TU/bdFoQaAjtohrV/fuiw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90FA860153;
	Mon, 19 Jan 2026 23:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F420BC19423;
	Mon, 19 Jan 2026 23:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863848;
	bh=8BBEwEPOV2feM9asWnviMEeN61fjbzDKcbDTnI9BSWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggts6MuqPRmp6JPKI/imH0YjdupgG5Kahp6IN70J2t4YhljglpCtvsW2PUxClQiDt
	 Wj6Hp7ccAdgQvsCFQZvMpmP7bB96YInjP5Q/zNtIg9AqiTpTECEQpc9kKMrGX4pN0t
	 g3dDc1LkJMKSq4460pcW4IT+gsEI4J+CDyG2zu6z2gQPaSl6aVVYh302a8Gs1s7yrw
	 nvBRzFeoUppU9xGXtblIuqvYXVTFyJq2E16Y+kqYPerTaWPq+GM6IU11YHnz8WpJbA
	 Q1HICF/dmj34sRYrmkAOizVVXHXgufQSJQBq7HwJwOBBpkZ0vSBys3vymkNvqTa/0+
	 pMNsBWcnlnQXw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 21/24] mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
Date: Tue, 20 Jan 2026 00:01:29 +0100
Message-ID: <20260119230133.3551867-22-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 91um9rstkhjrxunq487pdfzfjr3ywyif
X-Rspamd-Queue-Id: 0EC46100003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768863848-61868
X-HE-Meta: U2FsdGVkX1/tFSRdg/HJvEt1ZvTVmG9geOt364NnuXknWOa+U5bHHeG1MCb0ugv7UPqrmEgcuvCPyIqApoqtpqioZvdyh9Id5wtQX7Pu7NIjPAD/YUnQihBLteUt3i7Cn5PE3OqYOhKAe7MqMjYp5UCdUqdOui+I2XHUU/JalBSsP2mWheUirrNnhy9s3/8j4OiO98ZOYsCk3kQbdWY2/QK96LAJ0xWeFn2G8OvtxTbApS3VQTDHKRYf/KrosDDAR+6LUncBdPhq2Pp0tRgNkIVfl7+L2MflVA+t4BYGwoCPxxd76N+Lr4IbVh2GmVU0HXYsn56FKJSP39w/Y3JNbRN5IhOeonWyNLDFAfIjxQPciuIuTO7/+4yyjJM9GLoGmi4gaGLRSbTvNtI6ecxse34YiBPO0dW4RpANExX1zIqWUBPPwLTADt+cr1pl8H3B9Kc9SwBZwfoazqXTXmMDmBft1CK8Rl4qSZfBZTRGQblHSJLzVelVY4CEjimKLDkFX9a0R7faqtMWaKu7OZFufYWsJmdww+8zvsJ7SvhE40zDXe/WLgqTBgBTcZZ7zgXlBRCfmyE6EE0G2+n6KNf8tt2DRJfx650QRq99zD9U4AjdFusQ3UDxsArAcaJw/DR/8T/HGOyJTkKrnA2o0bbNYysdfXR2VouYEyG7aDbCWWq3301trjKFhOwURfcBItt5X7ghkfnhguXESray0pJvIGuUS8ccaq6FQQd94zljttGSkw56gNQV9zDMgqCd69GImxaRHgVcO6rhjtQ7vkTgC2v/bR1H09WPPQxBFLTuA5u8cObZ7ZwAOhY73SdSm+RuoAosLIjrCQXm0ly2GY/Q5CiFlEEbD1Go3a/FZCRGy7DjE15JcOcMmkNojtwrU+C7gBFXUl0kcG9JM483UZepAzAiuhddUbxnwUUjEM063pqyJME+0hrdeaL6A+56R8gv99y+YlAvXJMfvLv0OX6
 CdPH9bML
 NZTEX4uGtqen8g1jKUBmdGQfztHLDbKcHoHONhAdsoVedtwyxqquIs4ZTcviQyO0qYSLa0rdcLS5y8rggvCmFQRZ1tOYQFIUZhk1D1HpEJfMol4xJN88lgbsUHj+bRu4FfyV8VoUwf2V+BvswGnulMHNT5FeXF/dX4FrZGFJM5gy65WNCoZk9jKIgv00r3/lXGbMMVR/YRAz714CSFcfqgm3JKAaJYWMVf6coln6SIkJSh/XRwra0wguMUT+HODLhqpIdatQjPXxwj2mBvwyoUMHBu0jgZy/tTMKIoWGiCjHC5POuGmOKda78oq+WNaN3FuV96vNwyw8jfKs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migration support for balloon memory depends on MIGRATION not
COMPACTION. Compaction is simply another user of page migration.

The last dependency on compaction.c was effectively removed with
commit 3d388584d599 ("mm: convert "movable" flag in page->mapping to a
page flag"). Ever since, everything for handling movable_ops page
migration resides in core migration code.

So let's change the dependency and adjust the description +
help text.

We'll rename BALLOON_COMPACTION separately next.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/Kconfig | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 24a3ff149a1b0..0d13c1b36e1c1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -599,17 +599,14 @@ config MEMORY_BALLOON
 #
 # support for memory balloon compaction
 config BALLOON_COMPACTION
-	bool "Allow for balloon memory compaction/migration"
+	bool "Allow for balloon memory migration"
 	default y
-	depends on COMPACTION && MEMORY_BALLOON
-	help
-	  Memory fragmentation introduced by ballooning might reduce
-	  significantly the number of 2MB contiguous memory blocks that can be
-	  used within a guest, thus imposing performance penalties associated
-	  with the reduced number of transparent huge pages that could be used
-	  by the guest workload. Allowing the compaction & migration for memory
-	  pages enlisted as being part of memory balloon devices avoids the
-	  scenario aforementioned and helps improving memory defragmentation.
+	depends on MIGRATION && MEMORY_BALLOON
+	help
+	  Allow for migration of pages inflated in a memory balloon such that
+	  they can be allocated from memory areas only available for movable
+	  allocations (e.g., ZONE_MOVABLE, CMA) and such that they can be
+	  migrated for memory defragmentation purposes by memory compaction.
 
 #
 # support for memory compaction
-- 
2.52.0


