Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947A0D41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FDD6B008A; Thu, 15 Jan 2026 04:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033AB6B008C; Thu, 15 Jan 2026 04:20:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3266B0092; Thu, 15 Jan 2026 04:20:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCC6B6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:20:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 724CE14019E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:41 +0000 (UTC)
X-FDA: 84333653082.26.B3B4C7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6B8E8000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AsKfcaRm;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGzDOwsL9PM7UwrJ0Pfn+jHlKv9JLZAV7ra+lwOfVXs=;
	b=WLUPm64FLOD3SuhQJnMJrRRHt0/Lh2kQKS4s6VKKXgme+dV3vifyJ8pAaPMhxq9hpyHMiK
	ixiTwCRIH6evCa6M0Omxo+S/CIPsflzrTvlP5Moub6iK5WIc7hNDBQKobCiVLP+6v8vMJ7
	2zKlTzXNTUrYZs5nEyz8n33i86FmmVA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AsKfcaRm;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468840; a=rsa-sha256;
	cv=none;
	b=dyXI/J1YwCn/TV4WnKMz0rnx8uvoGlXUZcKO4abqykTWHMFzsvMeFYcYsOnuKqENJjlMrY
	mt0C/Y4xLQp4gpqTc4+3awG9yH3yFxeGxXh1DKTAjEBhuDFeU+dDgpeqWlE5w4gOQ9Dz6v
	DbU91zkfRy1peE5CoozAJn2gumqdgKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C81C143923;
	Thu, 15 Jan 2026 09:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E52C116D0;
	Thu, 15 Jan 2026 09:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468838;
	bh=Cgrtz1QRoaELES+PU4SN1wm9f3oPVqbLP/yVshCylTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsKfcaRmJZR6QBoU2B6nA9WMeBDA1v0qFPTd0qrx03mzDkR5Nrbczuc/sWxeXRHPh
	 lq/FejhHEwMDemtiEzRaYK4TIBbMeGt4lXFbXhrUoYJsK8G6EEcTPcwzPMi+pFTb4h
	 F5+Rbu6bfB7cE3xBuYoT7INyzSbIiUHSlgPZwn8SetNoCS3XFXiPppFn/TGtmh+Qw6
	 Z6Iqq4cTql/fEOx82g1l+T+EDPub/eL5mnJL7Xs8eIjUVNdfPIstSZHPehcNI4ppAo
	 xcD8CZAfM7SEpMPAqxuRjP5ye4s3qDPmZ0Mzbyf955aFmneF9aDg0oTAVP0NWDlgVu
	 05tHWJAZpuPjw==
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
Subject: [PATCH v2 02/23] vmw_balloon: remove vmballoon_compaction_init()
Date: Thu, 15 Jan 2026 10:19:52 +0100
Message-ID: <20260115092015.3928975-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6B8E8000B
X-Stat-Signature: fxfb7cnpt8m5ez1xxgkdwjj5pbit6cud
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768468839-872350
X-HE-Meta: U2FsdGVkX1+IQZF1rnekuTkTX6terCcc1pwAoHZNtfpx14S7DHdXXGjXZ/Ie/Vx2627/OefQU+jjoNrHUBRzqSeaBxmhSPUCJSw9TJ0BwIsrglKYf2SjGSDFWmQTifove46he+465uP1LCaVBsOd2HryoHO4IMNRh1IGRLt0dejQf/NmBAUTtvw6I90CA6DN1JToSwHHNWyvyGuxTzcN9zqmHg+BTomlOgR/IrfoV1u/Z2T62ecI+ATJNmDKmyICWxtVvZXLRiFqae8fXgaA1zK+vTay1U5123kIq5ljGackq1Lc3YVWyvsyF8QwJOPj9Sw5R74gvJ6iVd3fDFQEXsPycfBZ0ldbIvWhe9umgdCNHN3gr+oWFtWqT6Hva2y5RhPw3/lC5/QsyV+6n1ZIqQWLML7novV2JewiADkXJB5q/32WtdlcX/PGRVQoLrrVU2Wr5StYJcQxYTfWnib3fmREk8evvnE4P7nDQ3lxr5D/V7fuU0g7mTMlVq/1i9GfY8wO0bPgVFl3pimhFw9UAnEf5uIApuVbQxmR8D9TVWWzhTHlR5rti04pPJ30icL3S+cBL6uhh0/PKPLcrCgERWSIje116euHVaNVUljNlabHhSr2eSHzj1dceSfmIU67jmbHve6+tlKlPH1OT3VlPfH5FQ95VlLWZnizC82qeZ1rk1QUbkbvRvQ4o3OYg2q6Guf4PlOqEzsMUckORo464PpCZoEpZbcN7hR+6H+hUN83DRO96uWIqI6HKAsvr+FOrhgH8OGrjcyJMyJ4PrbjgHdG91kCSMrBuoOj5Inza8GvEnepDsqX+4hgKrCibL5CgU4xWCS0Mpqi/is/WS/hGANMQB1efImJPfmCNqNeQkFrq1q9I+nVFZDol67JP0MDV/cfkGxeA8NWjWvIiM3qs27VlHCXjoniH0OgZrR+NSj1ifVOYVrS4FX7XRbB2mRchjj9LGi/rM1Na4B07sS
 JuZpsFMx
 9MWlygKb6czOcj1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that there is not a lot of logic left, let's just inline setting up
the migration function and drop all these excessive comments that are
not really required (or true) anymore.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
the compiler happy by only providing the function declaration.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/misc/vmw_balloon.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 2cc34c4968fac..07e60a4b846aa 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1833,27 +1833,10 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	up_read(&b->conf_sem);
 	return ret;
 }
-
-/**
- * vmballoon_compaction_init() - initialized compaction for the balloon.
- *
- * @b: pointer to the balloon.
- *
- * If during the initialization a failure occurred, this function does not
- * perform cleanup. The caller must call vmballoon_compaction_deinit() in this
- * case.
- *
- * Return: zero on success or error code on failure.
- */
-static __init void vmballoon_compaction_init(struct vmballoon *b)
-{
-	b->b_dev_info.migratepage = vmballoon_migratepage;
-}
-
 #else /* CONFIG_BALLOON_COMPACTION */
-static inline void vmballoon_compaction_init(struct vmballoon *b)
-{
-}
+int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
+			  struct page *newpage, struct page *page,
+			  enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 static int __init vmballoon_init(void)
@@ -1873,12 +1856,9 @@ static int __init vmballoon_init(void)
 	if (error)
 		return error;
 
-	/*
-	 * Initialization of compaction must be done after the call to
-	 * balloon_devinfo_init() .
-	 */
 	balloon_devinfo_init(&balloon.b_dev_info);
-	vmballoon_compaction_init(&balloon);
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
 	spin_lock_init(&balloon.comm_lock);
-- 
2.52.0


