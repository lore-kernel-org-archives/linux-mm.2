Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD458D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF4B6B0089; Thu, 15 Jan 2026 04:20:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4964D6B008A; Thu, 15 Jan 2026 04:20:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F716B008C; Thu, 15 Jan 2026 04:20:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0286B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:20:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7543C13EF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:33 +0000 (UTC)
X-FDA: 84333652746.11.46E79F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 62EFBC0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYttf9RS;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8hRciOpYMgwwM4lWsV+OrnHR4QWdNhYMUfFtku6z4Q=;
	b=3EBFv7iY97Y4g7uhAvVEGl9/40T0Fy5rJxQiZ8p90y3SV+XY33Q6+C/DWAaHKhqoD7TWcc
	QOl2Svdy8M7sbySTdLlUncNdh6CCIUdiWkXVcd+kHUtR9i/r8dso8Y356UWNYZki7GSram
	AWZmx0jzC2O92eAJr+1/tIYf71AOA70=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EYttf9RS;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468832; a=rsa-sha256;
	cv=none;
	b=ZSUVVKnvfZPLxMSrq8EBd1o+7iWlQkUMm+HVIo1ljToRStlD2Qv6kqS+kGyYxITVeCFV95
	LHYVpF1aqIgeFhPUaY7EFxfNFMAnx8vEz9W+z1ipUZCU0Q9/PQw5u2/E1owS48tUREQPyL
	bTw7/bJXC4G/KeBOD3/Rh39q9eskozo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C98B7601B2;
	Thu, 15 Jan 2026 09:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E4AC116D0;
	Thu, 15 Jan 2026 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468831;
	bh=Scv31UliB8apDlHu70nbhgpokthEcnnhLLec4iJu0Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYttf9RSd3DbdTaPTVk+zCGJKvc/Oez8ig0lU53ia9jJ6aGdraYIQwgrN8yJDx0Pr
	 5qlJKitoIajMNIWc7kDHGqVMM0UaKRvQAC7bbk7mgQkugqLRCBR8BUyRmOqRFH2N7Y
	 EJ2au93bd/o+ApHVyv0ol6BDQCWpCFNv1hC3BOgoWcmnv7HvfTvufkfjUo08S6jWy3
	 5opLIIVpz8SqHZkxP47qBlAAYzOLBQ5lRLzyIQQhvTJHLC1jIMu6+wxgilo4nYr7cJ
	 DeabCkk2c8fFv90mHyJ5RnYg2v4W7YzhuhYwVVVE1jXv557Xjjd9lvqckiUc5tazSb
	 PsIdQFPAUZZCA==
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
	Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v2 01/23] vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
Date: Thu, 15 Jan 2026 10:19:51 +0100
Message-ID: <20260115092015.3928975-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62EFBC0007
X-Stat-Signature: ob358wdp6raijnmqux6uwtkimzshtwsf
X-HE-Tag: 1768468832-209484
X-HE-Meta: U2FsdGVkX18FhKmruhr4iPAxg7wpGQ+2Kd9qRgFFakG+3IAlZkMsOeZhzfJFbrIFOXEyxWQFobTE1Z93365BtbVDZaj+S40RMx9mDtW1IbseRFzV2uMPGb8UUgoqa6NazTiKBSKo+8w6+VEB0qyQDSVENEcHDw2tSevzDEYgNSPFdw2FCKnpf3VOW11BgW4hESO0uLm3ifbkv/gDbAceMXVEdva5xf8QziBD20gO/adr3Y8+Ojrb2DK0I02JIcsj70umQYpS+F9zEYGSlOcE8UA9v1Yi6fksftvjG9hjN7tPkofiX0Ny1e8eBzwuKZVOPW/nxbBPBSj6rvS73l4aojEnvY4jZIG1C/ZZENe4G2QWDasoPMAXZhLO2K8L/2Weoy8KxAi02I56MYWa/VXCceGIcJ7BIYSHmIPCBJbnjDvQuEbZS1VMUjEkkhm+0BBJWjQK+8/cMxuf4jPjMsNDlBHIyesgxnXa+urSAq7qbjSuG4M7pbZg4kRUMXSnXM1H4deHhrClgqEz295T2ohGdS1uAe3RsiuOSW9D3nBHCRqeCEckQuzaU7Rm0t+TSc0CQ9DT2fZ1WW7RAWMs5C0L2PxnvQ8ECpASXXRqLuYRfWopMAnxWJfRPVhFzdKh00MiDgmFL1DbzHWhqbNRZ7FPOoFk3BafM4pJhfidVlzYYVjjdluuVaWpf68HlCfYAQ1wxNJ1eEy+2s+NvdwBW9TcSpT5i2CkAJyh/+9DXFyRFaAJh7kxdIQxjcZr2CX2Ji9efnFNNA06s5FoPAin/t8JbUSBESpxPxpPOmJl7voy/yP6475eI/nEQZlV3ScWuqoi3t8o4wqv3DwmnuMxgWA8JGCC7mYxUhcogMkGFLdT+YiDCtwLRF6dDESeYQ/eRQXPifrzlNGT9n0LOCzmClO5aJ32J8NU7TxqbZek0Bb/eCANK/KJV1UK1+ASj2GGqZ/5Fz9G4WVneg8JaS5A7PO
 jfRQ9oDk
 rpPMW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we're effectively deflating the balloon while migrating a page
because inflating the new page failed, we're not adjusting
BALLOON_DEFLATE.

Let's do that. This is a preparation for factoring out this handling to
the core code, making it work in a similar way first.

As this (deflating while migrating because of inflation error) is a
corner case that I don't really expect to happen in practice
and the stats are not that crucial, this likely doesn't classify as a fix.

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/misc/vmw_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cc1d18b3df5ca..2cc34c4968fac 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1818,6 +1818,8 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
+	} else {
+		__count_vm_event(BALLOON_DEFLATE);
 	}
 
 	/*
-- 
2.52.0


