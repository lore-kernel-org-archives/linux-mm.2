Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC41D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2378A6B008C; Thu, 15 Jan 2026 04:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2026B0092; Thu, 15 Jan 2026 04:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118036B0093; Thu, 15 Jan 2026 04:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036E66B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:20:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCF2E1AFD0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:47 +0000 (UTC)
X-FDA: 84333653334.19.54ECCCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A61C1C0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/0/kout";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468846; a=rsa-sha256;
	cv=none;
	b=Ijs6zRd2ckdIBGpZaH87JBzUCEhN34eMCOozeFAFl8ss0iRJsgp+4Tc6WTyjifSJWWJJxB
	kblMPlJTdYDE/43bJVfUOr8qio4jBFwimR/n6xNfpMg4jGYslyEi+/nDiR4yyreRUb8Zf/
	Xd28swUPN3C+7Ae7wXt1Yl/v4rssbSY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/0/kout";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ieq1MZjtKDgONKkNsiPAzXbKhcbuGXOsaOcGRgMyjZ0=;
	b=JSX9fMJLrHHwMqpaGtKnySbPIFgm27mEWMYxkM5FQvAMJamcNpnH8pWP5l5dINZC5rG41M
	CR7D87qP94bePmjm5mf1ZPsZ5w3B4OdDoqH8nD8sByIkWfXXMlbdvSy8BjBt74G4uZVBE+
	HXGr6fOc99BjFcB5jDR3W1C2D1ruyxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFA0D601B4;
	Thu, 15 Jan 2026 09:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5EFC19421;
	Thu, 15 Jan 2026 09:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468845;
	bh=9n8n+0cAzQ7vmJcEe9QB+II3uYJrH/Btd/75YDVJ8Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/0/koutXAAcP4I/4wro7W2QSvhddotARmsvMnQOx/nzQIh10ziCaQHXsjHoEOaqy
	 9bStFDwBLQn+lyP7xAZl3tkeGlvdb/CfyfjgsPqyrFtIrPmMOjYEHCV/23vKdM3v2d
	 KF9izQF9jAfa8ikcz+ZVZRrh9C7c/EFrXqAd6cLHHb5isfFKFyvkvam/DWsGPYByUh
	 d0nFia07jUa+e8BhXn+l+bfo0gQ+g7UMpuOJuMajOPz0SU7EAuzCbp9zimxyEJBCZM
	 ozDNgFuo4hwg9rU0B01n59OPHAlC1mgdXGgF//ZcI32EaaNtkCdbeEaFLywkokzOQ1
	 oC1dqiHkWvLzg==
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
Subject: [PATCH v2 03/23] powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
Date: Thu, 15 Jan 2026 10:19:53 +0100
Message-ID: <20260115092015.3928975-4-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 367if97d3c7czgc6qzrekxzusy1bpzzf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A61C1C0006
X-Rspam-User: 
X-HE-Tag: 1768468846-996335
X-HE-Meta: U2FsdGVkX18dbdoubIRJfWCZl02cqn5aqi6Xygoi5rHiLwv+Hi3JOSPf+DpNO2nI56WVHkAMsuea1dtQJ6LdD6NI1zEYSKGq9NEWPwc2TL4D2JVw9l9fI1/rGx9l08uawn0FGRdrfwROmJhWWQHFdEV4IkjgXe0UiylrybRDCV8dSTihlFbZx8CrdKTn3kTrL04Ftt+gaynhywzrqO5J0+CRKv+MeoJcsTrKre/3UBkVsYdyF221heOyZ9kJpEIHHOF5KDtqoVpTjtwwRg9wwaf3zmo6hDF8G50tzOeuU52cx3RngDvDD2/wt/KC848plH1KxdyAAbbW7rKdXT75qo9dIxvwX/jv0gAPVkKALXYN+BiL8Hay4PwoJxyY7XZ0Jg8iNZcGYmqzCLQIpvmOTcg4Ue51HYZOexEXWe3gVZm4jgLqiLSLXBoY7NvZB4p8AHsbp58jnAyy4imDZ1VBL7kAP6DZpJml9M3kWLICLA38z54TWH5v5lhLtQ2VT1AAVxzR3U+1dfmhvE011dngZKktpvnz1cyt69Hh7ffAJV11qYOWOMiX6lDk6YJqDMS2F85VF6SEx4kTSOS580aG0ZGHqjMYU6dQR6uJSq4exe/zV4gPOcPnqQuKpEzZVvscqUlBR2FIG5tjQCMchIFwUf7GZ2DB56uIZhSIy9WeM6eC2V+IWkppekcWmU/ElikFrEs6gVyAiXFLJ17TAGd/pGfpeSE0Ga1Xdr9DBiyiRNIYkZiEvr9x9G3WZPPM0injJKKtdtZM0Cn2a6G2+NQ0BI6n8AuozJT+GntWBM4ZT8E44gObVx/8yUjaXel49TQIcbWXd4GKKvaJM4KFE3vNr+mUrmbo2ytQ5XwqxTWiYRklg3sfs/JxzkwoWdQ782XE0G/4UIvSC+bDygXdkMl2xrQKbUVBuajgJGMcWCPs5pT2A9gTSoSmXFUt6xUvzeF/Uaserv5ZIS+sOW3hHAb
 HmO4D9xC
 oEBRD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that there is not a lot of logic left, let's just inline setting up
the migration function.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
the compiler happy by only providing the function declaration.

Now that the function is gone, drop the "out_balloon_compaction" label.
Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
to movable_operations") we actually had to undo something, now not anymore.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/platforms/pseries/cmm.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 4cbbe2ee58aba..9a6efbc80d2ad 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -548,15 +548,9 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 
 	return 0;
 }
-
-static void cmm_balloon_compaction_init(void)
-{
-	b_dev_info.migratepage = cmm_migratepage;
-}
 #else /* CONFIG_BALLOON_COMPACTION */
-static void cmm_balloon_compaction_init(void)
-{
-}
+int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
+		    struct page *page, enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 /**
@@ -573,11 +567,12 @@ static int cmm_init(void)
 		return -EOPNOTSUPP;
 
 	balloon_devinfo_init(&b_dev_info);
-	cmm_balloon_compaction_init();
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		b_dev_info.migratepage = cmm_migratepage;
 
 	rc = register_oom_notifier(&cmm_oom_nb);
 	if (rc < 0)
-		goto out_balloon_compaction;
+		return rc;
 
 	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
 		goto out_oom_notifier;
@@ -606,7 +601,6 @@ static int cmm_init(void)
 	unregister_reboot_notifier(&cmm_reboot_nb);
 out_oom_notifier:
 	unregister_oom_notifier(&cmm_oom_nb);
-out_balloon_compaction:
 	return rc;
 }
 
-- 
2.52.0


