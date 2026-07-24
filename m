Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE78C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6316B0092; Thu, 23 Jul 2026 21:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276FC6B0095; Thu, 23 Jul 2026 21:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165BD6B0096; Thu, 23 Jul 2026 21:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78C46B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15DCF1C012E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:05 +0000 (UTC)
X-FDA: 85021951770.24.859DBC6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4362A20005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZ1zGEie;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVSG93ZZmpsoCFPChQ51HXQTyyrA3EtBA9ejpbXNmtc=;
	b=K7ct/u7AAWnmqhUsw1sRpNPK1rByM3uZgKbO0qTWqZZA7Qj9joeYK7/KurGQhvnbjRl58H
	PIHQES511R4DKXiiZPEtWND9xMQYAFcy2QeUJJ1ySLwCY7vho8TL2AvJYJ8d51OPz6XbM+
	0MXD/fcrJWkDjrwaJ+YTsCrCPRD7jUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856903;
	b=DxGkAy2Hl6AGcoPoIiUbcPz/jzV/AAcdjbY8GspmW1m0dFLHi2uO7HR49qjqaoJC8fzpBO
	GmI5htMSNb1qpLFKrsJOZA1RQ8AFtTmLX7+pWuTug9Zg662uEGV9FxEx19/HyBIj/sApkq
	jTzJNATQJSRZ6KqjZDQOJvkEPTE4Nf4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZ1zGEie;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVSG93ZZmpsoCFPChQ51HXQTyyrA3EtBA9ejpbXNmtc=;
	b=AZ1zGEieoCjTW7UezsIWCxnJzRsSHPTgG58EES/7ib0gceR255625l/KGsv0FOtc/WRPSK
	cmHMtwxbPM2E80mHNnMIcSmqTdNU5cHU+gtnkUlRK4CvtZtPIHVhOpfvt1F9piTw8xVJiB
	xPv64k7rbRQ0+BqkUwqGkq3ZdefEHC4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-CWEtSk_2Nz6eK3sn3xADZQ-1; Thu,
 23 Jul 2026 21:34:58 -0400
X-MC-Unique: CWEtSk_2Nz6eK3sn3xADZQ-1
X-Mimecast-MFC-AGG-ID: CWEtSk_2Nz6eK3sn3xADZQ_1784856895
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2626C1977534;
	Fri, 24 Jul 2026 01:34:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 924A3180059C;
	Fri, 24 Jul 2026 01:34:50 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 04/14] drivers: dax: use pgtable_has_pmd_leaves()
Date: Thu, 23 Jul 2026 21:34:08 -0400
Message-ID: <ece5eb95500ed3dc8573fe55f0f5b77039370ac3.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: npUm-tRQAXmc3AEdUwpitRE69FuYIQkZMBuEgn3LIxI_1784856895
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 4362A20005
X-Stat-Signature: 4jg9hwzha6sc5e6ii8xwoxkbtjb9o3tn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784856903-272540
X-HE-Meta: U2FsdGVkX19eJpHyA2K5Wtjd9V3AS5a1Nk3Pe5EBNgTXrpnsXWo4ZPQ356SRA2PwYDrL+ZF3F2TdJD7VhrjKNqyz7pE7d4OZNbjq2P5+B7xF85CtwUhZYRSwzFTo2fh8nJ+WVHpwzNQUeuN44g3imJgn55qJ1KP588H+gOfbM3vS006cu6dJew++tDGnwy4rtQKlm6BxQ5cIEeZBI0bAC/GUMAtlJharIwi8ZgvVcGXMjEL0CrmOqMvkF9U2MoO6PKK0fO8h4TSGuS7eLdIY6jA7vjic5UwnuKVtiun5zp27i2GLa1EbnZF29Kq3dAE2kR3cywxDrnUSSTY3uAoCsK6WyCt6pu2UCOPdatBCvyfenE13fx7Wy26X1cAosfa4+npaPV8pIhL6Zf3okp1gQ1M5ea0UMBgOoDfQPtVfSqvmhl8dtAsyoDa/okg/Fem6EDK+2/dIUxk7yAIHX8bk7mqxdhHysUef0r59Xl2DgnC8DY00aHR6AdShO9DrKz31dqQl6xFKOlUlf0v2019H3Oqe+ZD+s6033ZNOnMhM1JBB4agKY8aQDcsh/SmGjVvVGExfzsb30rpm6DI9ta1rOWiQYTdu90UqkT9i0mchbVhwYsrezGGYCPJVBiPISBhkO658hQrKLWBL6m5z5tjR83jEV2JUfKM3Qy9srKlOylzoOr7C5eYRSIWl9WoACLxSZrNrDbPuyw0eOWNibfQXIsJiJSV7Mz5Eh21otInBNe/2yW5Z7PR1Y0HqbkSdrhhi63wtz5aFIqg/KezLP80ZkF9onreg599zwlt8Ef694JKkaBoW3PN3rClsia/PFoDrbIxGJ4WyK5J7F+02xwWR9Zx/qKOeIGw2ZijiWvvk4+VHB5Gj8SB6rsKb4kSpod1SXEXhvAEcDxZhD6/xrWsgsgdHUlRgTXMt0wCOYuESHI8oRTX0fm6ElpPsuJjARO1xm4tDnV4AxdKbdp4snIg
 khtJ+mfo
 F4cBiHYTEia1lahr4Ax6EASWX4nNh8oChGuEemj2i0C7yllFIAzE6j+6BcBOXCjSt+2kYdK/ndQ+dH/kXokSTsNEqY5+lItqNtdnc0FzFbQz0+vvWH9OfpoC7XcqCc1HRCxiKFaS55J9maZ0FjS5VAYRzlehNO9qeIty6pIUJabId3COm/lwllESE3/4PbNJzSz9tZZz9Lgt6NgHX3jyvSVLsvKWjZt7en/MxyF6wM+uIff8/zNHGA/ErBuQcaYp1utvSsvwT8cno5cd8ypar4VDuzAWKNwfWMVUZPIqvLPVUojRNdtgxkSYhjXDPCNQ192mrqunKtLklJOLTK2B1eguqR5Yj/TJYd7B577R/4h9k0vMRtrVPBJScc9Y8anxuWJIMtR1VHG0SYzChlopCNNvpSoy8uwweaoNm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
pages are supported, use pgtable_has_pmd_leaves() instead.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/dax/dax-private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 81e4af49e39c..35744ff6592a 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -123,7 +123,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.55.0


