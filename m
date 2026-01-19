Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957F5D2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BA46B030C; Mon, 19 Jan 2026 18:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FDF6B030E; Mon, 19 Jan 2026 18:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B9E6B030F; Mon, 19 Jan 2026 18:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B23326B030C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:01:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FA60C175F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:01:58 +0000 (UTC)
X-FDA: 84350237916.12.31AB95B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF5471C0015
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:01:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=it6JXTLD;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863716; a=rsa-sha256;
	cv=none;
	b=i4n76GpwJLN6oVFkTyoUKSpSoP49wB5f3hcaOdIW2BPkv+MuRukvwydiRr6itD19cFeAsG
	bj9vWZhHYrrmn/D3H8HI0bQc2Hp5sY6GogqtSs+Ag/JFLSDgU16UcyvQ68T0z0z+ZE5H8K
	DXmtgkiGvf8S2A6k/NthQaWQXtkHaEg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=it6JXTLD;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1Xj1RX/NA4HAZv7tAdB9l6TMArwAx2JjRBIpQCaQPk=;
	b=fUfqWApNYFQz4Beoz+FIZYger+IjfHjnb6UNOLIC5uJ3Bt2h2tkr0zf9CrSc8gOW8DajV8
	OTWAjTSLCCIK2hu9l1cYQy6qjx7v8Dkg6/4qZh+UiICO64sQJux1hWK6lZl/fNKnmp6sMC
	quFRqBxaj8BLyuaZc7Snw0+zcAilhNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4829860151;
	Mon, 19 Jan 2026 23:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A858AC19424;
	Mon, 19 Jan 2026 23:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863716;
	bh=zu0MlNB3uojZ+XY2eNxlLUaMnPt4RrYT1MRY12QCzSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=it6JXTLDKt1WuNFXQ9Ce1X7YpHetBL19JtOQyj2tZ93grW6ScBDmXXEOP5WPBzLwR
	 xQ4EvMwIVRU3DGciBAEfChSWKPMiG3WcY6iGQxfhEv6ldblsZoy3hkwEtm1zhAY//i
	 zzS5ZbisMo5WLMJuUzvfKOr0asy6qJZoYH9hIniyfin1T+JY18S+HTHiU1p51xcLPJ
	 HhvLlwhAEQ0vWvQMhMNmumzc8AyZhR+8sWHtcZ1t38HBXWFLct4D9EdXXm0KrLuR9J
	 w9qfUy0JmLPcO48+ptAY7t/Yvn8CpMKvaSayoObgChDoH6uXNGimWjcswTRPrSslUV
	 x58d/Nlt99UJQ==
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
Subject: [PATCH v3 02/24] vmw_balloon: remove vmballoon_compaction_init()
Date: Tue, 20 Jan 2026 00:01:10 +0100
Message-ID: <20260119230133.3551867-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF5471C0015
X-Stat-Signature: gjqk79xy3ne68hm4d3b9my1wsipo7ffc
X-Rspam-User: 
X-HE-Tag: 1768863716-656063
X-HE-Meta: U2FsdGVkX19By32XFcIdikuNz8RPsNypRfLK+estPuOe+05O0ADOYDg9nFpbYGRc41ZRhKlV8Ora5Xzccp4GiBNw5mUEsK0VB/bDUN7Yh/nnLKFXmnR8mkVDsZasvlcFny7Hr8r/zNFHs9nKJA+n1hEC6j5CoYCScs5ZNZEk40mV42mu69yBN/YG9hQM7omivTBzSwJ8gQSNZrVLIMvLQsUP8iv7K1DzXKSQMsfruo+qoEIkC6GP3+0rI0phnlcxR45gsm8xsoAsXg6sqsYQ26URUWBRXeLtSIwYJZU7sKmkr+ctkbMUqpkrfg0+apsf1RvOSnMii2g0pexNfBavu2ar7HvTqrzNenrpO1W2HbBvRqNvMxkWVg8nFL9i+e7Wh3tdqFU1C8lihM8/ZoUYoQITBYED2/RThIdUBAq+8cEYMfWsl2GUjwcH/p9eceq3zjWKLEcsSkuy+ThXHrmbzZEYF3WUS3z75bej/hXspOfzvWOz97ErCd9zPRx1nJTo9M5iFQ4MrKdZyyL/wIEiwtsMb2nrTjSvu2rm3IPJIOeDQ65YYCkaaumhgm8F0lAZrAWOl9xr3PYkIAntulXnY9EKkLgWik5kQRSN+Gs9etJn4dr/fXVVFLVfCBcpMRwVklZ0i8hNXiJDtBU7/sJ4T3/4UVdaFopuAio/dMx7BVwSjI4ONsesZ+ARRlzbAyRjY3whtwNnAu1JC+f+53QwOk3uOnl3603/JfL/fhU82ItdQNYKRWbAbUeVBMGoch80Tq6a0DaSnVpoOVbpL2FIiwpKvqdnnyWnpbWxRQ2y9uaLY3AQ6G6Iy71SuGzytUpYoDeuZXkxXa9sk7RbwF6Nyq2cHpQalm8T/Jl7k3K7fVPC6XqglHBbvcb1lslcm+QKU0BxV1CZw+2F8UyH0wWfNysrRVXlQQW93KVAQzyI8XeMewZpdHXI2rPb1B6MXe772qWGFvHOiN79W+9LkxX
 LIOZfj7I
 0z2GobLXMwGz6zWKybUmijcUstv/kUYjK1/hYQGsqyV863jXwHtN92LGTMBed9BTp75DsAmaFOoN32w/2VpG19ApPM1IITmn9OztiE6T+Z8cQCS6w6vpQvd2M89Bnq1YYNxRBTF3ZfeN+5gM3mMY72dTPdlqO1qvmfjrgiRMvnh5+MgXZkaDW+hnjaoJ4E/82y2GQxOsHcdKKmnl2gIojsG2f+UDp91sxHPqUY+HvvuzPyYy1ayUhdUilxZHIFEukp3tIJlxWQnYQyx2ZbJMCidUEVkzg3RS6gwPpq7NJr12EmElymYbQmHAQySTn/qOCZRGEhuJrYUz4ljU=
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

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
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


