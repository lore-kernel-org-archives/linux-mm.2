Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37444D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC1A6B0093; Mon, 15 Dec 2025 16:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855046B0096; Mon, 15 Dec 2025 16:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755626B0093; Mon, 15 Dec 2025 16:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 637BA6B0093
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35E67C0345
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:17 +0000 (UTC)
X-FDA: 84222966114.02.FA1155C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7601A14000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B7pU4opr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833435; a=rsa-sha256;
	cv=none;
	b=p+kI719iavQdXD8NgzysFlVlTvm3JfOgeq5Ozx8aOpwWPU1GQFavg2erkIzLZvH4xoFeVP
	7OJ11tubAdr7J4s4hA2QR8hMGT2wyPfvBMaI/epmHDypq4ce5N/bNVTFl45ZSSzNIBsphr
	je238dq4ePrXFdGGgYPKUCb7c0YlIas=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B7pU4opr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqaTMrvERP62OfHMJQmBn/TEzJ/XjLPGcF7vgjITl34=;
	b=uptCGqsZCADTdBzoysDkpK3QKOxbT4J7B4GGOUrnr+V+faUPEJuQuuk0CcHHZEZujFHYsj
	e0IDdoHp+IGjbHHVck1mRay7w5WG8DY9xLEShhSFQhc/zvTZ6UUmhsANnbe2U2la6QhlFP
	o0dZ0kaMmqqilO+krEbs8Xfwp2iVooA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zqaTMrvERP62OfHMJQmBn/TEzJ/XjLPGcF7vgjITl34=;
	b=B7pU4opreXU1f+5UWbjf9IED3MsIXsccWWapat1fJlIIwH5CUEQ8diUVXp5DaBungI3ZWM
	f9HTN65T1RtqkrpRud3SmKQWtalvCiWLXGeGyn5sWV/ey1pMyR1SHJXxJod/4d98bmYjua
	0aScuU5bAEAiYKgBKoND+Cg//AkC9fE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-K0Myp6WbOkiicdhMMBtMMA-1; Mon,
 15 Dec 2025 16:17:11 -0500
X-MC-Unique: K0Myp6WbOkiicdhMMBtMMA-1
X-Mimecast-MFC-AGG-ID: K0Myp6WbOkiicdhMMBtMMA_1765833430
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2017219560A7;
	Mon, 15 Dec 2025 21:17:10 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D73771956056;
	Mon, 15 Dec 2025 21:17:08 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 03/11] drivers: dax: use pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:45 -0500
Message-ID: <07e9da953921df17a0a866cfc407c1db1f037a8e.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 7601A14000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 8aof3emf4csw5rqpaexwk7f7s1a8jr9e
X-Rspam-User: 
X-HE-Tag: 1765833435-313792
X-HE-Meta: U2FsdGVkX1+VDp2fzFX61exFooXL1naQy4OhaDsIgXtniDEUE5I/GcV0DUgAtXd+N3cqFqNX7M4jwY2cubzsXbh2fZvebJuStvvL2KjVuddExTHbu/W+E7yCznW/PTTnvjrYi8958rLryFxhbcNi+CxFmAFuFwKpuWPCVF1zE+x7vICNAvZ8FMAIjSxzTjAHeOnlCa/GWsIBEIXGyvH2y7ByLiovjq6xhiu3gxgfiPmy19vIMmeacU75MGvKpWAngIcERHiy3TkCrCmciXNvVLMCzM8Gfg4nqD4tHZBxTotH/QQm7y9WdtD5XL6rUCskExoKNNSTvtk5LeL/H4DeFpJ8FGJCD2sARGrjZDzKdXrrRagiT7eILykl11/tM0bDEx1kSml+fylsAEPNGHMJWkqEkJvaosYuAz2NOKbBO5oke+q2Ue0M78cE3pMjkayZSkT7oFXCSTI3JFIPV5h7UKhE5ymGnBsDGE+3B7nrOBdGNmSlZWUBkkEe4YgI2JGiY32apLnd2gj2z05Rd/LI3fCBOXLKb2zGdTYD9KOlJaFRCNoNppx1KIJtaf43EhpV1NjzVi75Q7K7IbryD6GqPaC1vtLT47Pzaz3fELkWxG2ykWnMAvB/GzaiHjQxjlO7Kf64F5norlzNBhisngn5UzKStZIuL4nSO9U6G5Q0sgndjyNmR4rh9G2Fp7ZhIruM3Mnwl33CN+tFAHklZsTmfxf7Q3IW5nwYIY9OBXvYBOLkOPjp2hvb1UDqnIEeLJy92Emt9aM1FLwuufwamIl+lMZpCwxPL/jJB1BeIijADAhq/20lyEvhWDqw82GAWhJHtZdTXImL1AWVCN+cyIelUGpsx3ur21a5AD1S579ql1faHpplOcxrI+qddT7lveXW6c6CaI6UJx0IxW83fRZRor2Rg/KXuUAB1RgqCrLh2/VmDIoYeE94TOYwx0iy3k5/7/7dqffkUU3XgewY3w7
 iAqxpWYD
 tduMRPhLfKDYFNbKUpjIU4dTtAoYUKf1qrxrV/K1fhfF6DBpsk+hwOzUH6/3E4xoCYGAxzwwQgXfIrdviRtWe9JLpHCxiI8ZErH5iRnvhVcpNKIfQRLNIGEKIw95RfqyVU/I8vy0ElfBJ+C7Qhz50qYN4A5jcx5EJYg6ZbRG7zu8qtTXNXzIsyBXLZwXqD92rO1WIltrdjkvX9DxzH6629Jk+obuJW4e9XkAhAH7jjhzhlg1kx1AMHXSkMVcGvR3VT2sM9jp1NRBzsKLXCearMV9TeTn42MtcJnUUzhkvkLGFvmIMM2SVesXdbZ4Cam3+0xLtQz/6IlT2GEaI8CdZ7pahdOMCdPS5Op5CVfdFaakkttuYTRjfoEbkpJ4f+w7cAfnaz4B8X1OzlVZXgBYGTENOAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 0867115aeef2..10aeaec9e789 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -117,7 +117,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.52.0


