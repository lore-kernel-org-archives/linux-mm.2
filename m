Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D52D4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0AC6B0006; Fri, 12 Dec 2025 02:12:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960FD6B0011; Fri, 12 Dec 2025 02:12:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876CA6B0012; Fri, 12 Dec 2025 02:12:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7692A6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:12:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D2E816046A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:12:36 +0000 (UTC)
X-FDA: 84209951112.23.67A58AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A685240005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:12:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QEsCh096;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pwDObE/G1BfwhHTTvkJQ7iWyEhDvPUTAI1iZE0TzAIE=;
	b=MGJH1YR8zuyQ9uxTfYaBQ88yobkd4Nucvq22/XQApUvdzFsFsgMx4qFyBkvsWcCKAepiLI
	yBlZVVvXLQ8zivm3XyY7fejQvHC8VyM06l3ZmFc6Dvy6ise7+8OBavsIJ89K9pwtohA0zi
	KAdTqTSYd3DxmZIiSRZKoofjoT/wkmQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QEsCh096;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523554; a=rsa-sha256;
	cv=none;
	b=EsFMgF2+3JQR09bw2t3fSPenrvtKVVOpobe0mpQBlMBzC+FxAOfNGB65Wj1saNWQ9FHkOJ
	ljDJyQSaOytfl77cI6cs176NiZKIDlIMwRzho+0fy4YK4ZJkvqx+bVsondemzYiC7DujuQ
	LpOl2BCZ6qk5T4gxumsHOfn1DpOxs9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8E8841831;
	Fri, 12 Dec 2025 07:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8F3C116B1;
	Fri, 12 Dec 2025 07:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765523553;
	bh=VQI1ixqU/VwWGZqg+DPna6u3ZBdsY/8hJmGuLZalUYo=;
	h=From:To:Cc:Subject:Date:From;
	b=QEsCh096RYH8wJEmj0TujySEBnuf7HIc5jz+UgDDxsrGEw8KpO+TG3Vag0Ut7w6LE
	 kKVjmAj7+/NmobEoyGgdJ02V901kWnBqhhlzZ8nrMeRuPBrgw8yP68z0BEfFug1yEx
	 QQHgUBdcc2miJlkJpdABsc1r38CLsAF5EEAQbKGhC2ClUBZqtCWI2LO8RT73aPtFXa
	 rrjzh0jaZBqbZ+rumwxYGJcEBuWIxM6JJespX1tqYOIwTADHitoa34XB1k1iI3xUcz
	 t1NSIOP9XgLHFzmda+EIN9jNWrhd5+cs3q2GLI8tYEqJ18sw2AVLvjj0PAwgn84YUb
	 ++xRvVTb5N5MQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add ABI headers to KHO and LIVE UPDATE
Date: Fri, 12 Dec 2025 16:12:02 +0900
Message-ID: <20251212071204.398788-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: zjxw78944h9qmjtfs7bo5y955j947opr
X-Rspam-User: 
X-Rspamd-Queue-Id: A685240005
X-HE-Tag: 1765523554-249323
X-HE-Meta: U2FsdGVkX18VAd+iZEgrgXoSfyDN/gqw2M/cJC1XH5+rCj64szOBtjyXg+cBpjchsrp3DfAIHbr/TSHQfmY6n2ikhPMJX1tLrBjSZ+AOBkAQmtnbhG8fLDjBqTHSUPIMF4/S0klJbs92JCz1A1whh13DJOTID89U8bgPsoZHBgb1WcBLu3ZyQWPVtKwFN0CcvNPLzUFcDYnr0b1A6BKsvOIfX3yjzY94NpYAzs5RdMpfhxMs4VkLSFXE551IHuTjQxeE3PT0HCVvWIXsNeAByNbnp55m01+20ctQ5KbFvyMdq/iWxeCNJIrmvSPoQGRsdpSAfSur2glKCxP5VQz72KHe4Qdj+IPXZG7UR3JYUkTUTYb74+Cty7z9bSZBUnslTLvPbgoLiFKxcualG3FyO4LpIRl7nehTlCYEKCnxuTE/qoY0180MjlVnzaJQQ5BMuGXuHL+vUZku5QIoyO16AgPdB08JJmfocYvzCihOwmjVIg/8MjprYpvoiYHbHSDmJpGVr1WaXdcps4Lh5Wd9wBt+3AycQe34fvKp35VYT05AAFnAG8iFvY9Tw1/V0ndnjdyZsNPDtF/VAgRDcEpRCLE/dQyyKOcHtzkjuAPi996i+czPP6wv18Mye4nrMqbCGAsUM6HW/y0dwn/kXJ6SVygavy1EadYU9IQbh95dJf79TG7j26aVwrwIgegVk6KGscl54NhX7+jOjqNJzHIMcyxNsvG4MqPPaUEEXohk3ogKo7/hJ6EMQt/ls50Z8bONByHr8LUpkTk+D8x1ehbRV7nsAp9Ybve7lMGPfZSjDZF9WcOrD2SXQYRH4V2lLngtQXC6TgRXLHGxn8nnz0hD/ojZ/TILi4i9Z362o7wfO4nUhy+JBa7sU9+rlB9ttciFO3UaSJ4k2cZTJInE5wl8R5IHf8VLgJSg8k84CbsR3QsWY+cypEXsbTl4MZ3GQp8PoCNS6jEm8aRtpqBOtLY
 ZERiqKak
 UQoH62OWWqyvgLjNgH9lPty8k3NP+9yzACs1WnT466ZkSQaRRLRElABGHcEEFUehnrKWI93cdCp39zMBOEZzDI1aOYIT/uP9/sIT+Y2ZQPEaBcJjEBaSLILcpmv2nBsSSvj+mm55N0iqXV+6q/YHeUk3Jcwd6eCcwFqzj6j1ofIUDNzK72fFzcI05/GOG4DzS1NigsAp7GA088ASAHmRFTLSUm9Z/qSA7DXW05K+m6ju7fk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

include/linux/kho is supposed to hold KHO headers. Add it to KHO's
MAINTAINERS entry so the right people can get patches to it.

include/linux/kho/abi contains the live update ABI headers for LUO core
and memfd. It will also hold ABI headers for other upcoming file types
as well. Add it to live update entry so live update maintainers can get
changes for it (currently they happen to be the same people).

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    Eventually we should have separate maintainers for each LUO file type
    and ABIs. But for now keep it simple and put everything under the same
    entry.

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 656e29624d4f..99b3c84d6be5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13799,6 +13799,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
+F:	include/linux/kho/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
@@ -14475,6 +14476,7 @@ S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
 F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h

base-commit: 601cc399a01049efa76be8f496541315dc9cf914
-- 
2.43.0


