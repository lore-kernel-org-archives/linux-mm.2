Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6865DD41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD57D6B00BD; Thu, 15 Jan 2026 04:23:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9F56B00BF; Thu, 15 Jan 2026 04:23:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9BC6B00C0; Thu, 15 Jan 2026 04:23:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC4C16B00BD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:23:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6560579EF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:23:05 +0000 (UTC)
X-FDA: 84333659130.21.3894B36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA9671C0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:23:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AAEkmlmh;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJrhwFM7+l1lxczhOrVPKHhE+iuROxa+v88WKvwMQRY=;
	b=d+J7h0Wdyr57WaovLzrs06YYsrp2Cb2bRrTVKARhB95vt9JDUATBmyJrNdl3JFAzDirygO
	3LWLzMfWwoZEP8Vj0cyWXskDjnCwxODfFmFemb3aqcWcXnLg0TjP/DyKDDD1jKjPBAMC8v
	sTdbElMwlQlDRxkukjbfTHZN24xEw/w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AAEkmlmh;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468983; a=rsa-sha256;
	cv=none;
	b=QUwYRd/7byLnCao1BHtdXqIChYJ74L9VzNA5KcLifXIX4iYGUr2TP2c0vK9t2VaqZjqpjw
	2rXJIk8gW52tuS6Qzduju8RhYIdu3EP4L1YqxDA9AkD4dZU6W9WYcvICG42/jaWwg5sBT8
	r6dxFPfylgOV7FqXzn8oys1tl1xbcAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AC2340D81;
	Thu, 15 Jan 2026 09:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E0EC116D0;
	Thu, 15 Jan 2026 09:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468982;
	bh=7bbMIQHe4/weqHbDvWGJ/Jw7lMXhnWUDxpL265aHTuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAEkmlmhOTceSZ1CTH7c6V1r4hbYnHKCzeML4q4ap22b0eiu4voauLSYHnNcbJ82N
	 VLuftsgMRoUyx0cMRJjfaaWJ6BiT8gRsgO+9Q5aY0E+33tpnidcAehdKF26sx0Twyc
	 lSHIO4sFT4VXKuEckOYXFbcwO2lHkZw6isdac90GlKa7IY+CT1/zmbixS05MAgrjSs
	 Z7apK7S7toMIAwBpwp/8ipTr2iGV5xeHGgBeyIIdb3peRCRXYh0JEuQ2LJWKHD9JLB
	 XaIoAfBmxPPtpSqNRqqIm2BJ+5OlceBGoU7EDpzHi+ijxE9wxxjXP8/U4A5zoNmLHw
	 5WaX+2zvRSF4w==
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
Subject: [PATCH v2 23/23] MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
Date: Thu, 15 Jan 2026 10:20:13 +0100
Message-ID: <20260115092015.3928975-24-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: orzaa7ukcecyo1u4dewk68ztifw3uegq
X-Rspamd-Queue-Id: EA9671C0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768468982-519907
X-HE-Meta: U2FsdGVkX18GU3nZLA9dc08pI8HtSWDJyWlgkMHJiHMW3W6B+0KntTNNr8lCwampLA0GBFUa8LeNqcCjfaUJ1YVRNOH5M3xVay8X6fP+pBo2jvobUIx0S0LB8PUeQrJEcMGf8/HCDZNDCm4jHJfjtT4mccQ5sL9vQJWvApTOgyh+iqVE76vF+33D2ZpLOnr0SlSjwZ4JTHnCC0gneux4W6VSr3IPIRZBbVivFr89oVOQmlYIx+W/QhFxjVtXQ8XYObgzp0+eET15sR1AzQgDK/Y4xmjfB8n19Qbh4IbBLesIgkzEV1rM+NGtHZA4sdwLlVKM9sWbPv+eHQN/ppK3CCsKec3l9pe3w7ZcvBpusMFPpjzXNe2t4uy2H98ZMQpuvFgKgINzPxc6UgxYeLzyrhQgvCCbtGZ+hN74y4dFOmUjqbaxiatEsZ6HAgmZ5P0S30iLF9eSyhmpe3Qr52dbslG5pJ3g64YZSkK1Mu50l0UXRv/2QjDF9UtGRAS9XdbMwqQVUEM9dGq+W5wCR4DgZvsHDu0g8hcXvG1R1uGcXjgeOq0BDYa55zLPXThGSIC8iUH8TYhO+vTzUSWQVnZfr12C6lf5QShICojsZ2wHsrFdRJ/qv1YIQqUyYclF1JhNCAAfyuJurOdCc8W00bi7zHQpGx9sIxZ/xOz5IrtvYz0+CcemMjEPQ0FMM4ioe6h1/nLifT0r/t2dpXvZnX3IsNqthMCBpvz+jt+S1FiHS8Qj75pr37vJPv6nAkEVV+Ggn3RFpg0m7Rp7GlHmt8f77K3fsptklAQnLpW2krA7kCIrICaJRX8Wi9Dg8PZC8VW2/JDJNnIyoKWze9+JySPZ7+3OQqgyQrPiA3YVYHQr8Pcpt/8N45i+DZaJ8G0MSextP+NKMBiaS7kLk8RmtodKMSExZjHGGEhUTxTdKOImy/P6EfHwfl7r2pca80yeUvJ79fFOPfyXdPOmX7tUDBz
 G5UvRchb
 xyv9K0tZrkHUQFv5MfHc+uS+G0VqcIlJ9ifrwQ0c5Hi/4jO4QEPLZx1TMvin72t91Q8XToNayHT4rrrmdG19QfNx1zAXrRl+1an7VCpbwb2PPoR/lrDyyk1LoS6SysSG7iJG/aiXkmX57FE4HUyneYEOjncHir21iYLK4yn4Fi3H3S2OwUtDhhkuq470xT28ur/2cBEIDqJqjuWg+knh9zXwZcXBlH3CBZi/02dTVeYlAdyMYsI3fmiX7fTmhlT6RWYxjU+a2fDCugCkzXhqT+WoM/ScwzSPXweZ0vG4tVrv3Mbh6oPeyrVBNxka6ItFo6j9UiGSejeAOUrKdsq37ipqyxoKtitxxTy0b7gSU+6ITHHZlxZQVOssbn52L+a7vf0nGt2I0SV2fzOai7pYHRREX5IuLWGZ4+nU2RfLR/5juL+SPBt4WiWMKAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nowadays, there is nothing virtio-balloon specific anymore about these
files, the basic infrastructure is used by multiple memory balloon
drivers.

For now we'll route it through Andrew's tree, maybe in some future it
makes sense to route this through a separate tree.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 MAINTAINERS | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index de8f89ca1149f..b974f8c1c2225 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16454,6 +16454,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	mm/
 F:	tools/mm/
 
+MEMORY MANAGEMENT - BALLOON
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/balloon.h
+F:	mm/balloon.c
+
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -27536,9 +27546,7 @@ M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
-F:	include/linux/balloon.h
 F:	include/uapi/linux/virtio_balloon.h
-F:	mm/balloon.c
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-- 
2.52.0


