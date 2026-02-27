Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E157FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B836B0089; Fri, 27 Feb 2026 12:55:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71036B008A; Fri, 27 Feb 2026 12:55:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73796B008C; Fri, 27 Feb 2026 12:55:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3DEC6B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:55:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B81E16072F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:55 +0000 (UTC)
X-FDA: 84490989870.27.1605092
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDA77140006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCU0mijn80sqYVCXZHzo6JoPVnZU8e21nTR/hv9oCwU=;
	b=CcUuOZaRmqVTdhlzfN1jA+GDpvuR7fankdYARu/rckqLt2Yuy5ucRavMMBhlI9ojCqKymD
	ARMd0YcQACLHOOFtx1PFEByzFcRRVbJyp2lRUt1rIK1awEVRWYXzZ2w8L1YsHMA9jNp2i5
	qhsBBF0aofMMnMcixqhmJ/5lvPi4yMo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214954; a=rsa-sha256;
	cv=none;
	b=zIa9Fx6/JR3eKhTy8aHmt4eokbE+0OM+1xf5C4k0VDdpXXBOOBkscISKuUDAgO1osOMHKo
	XMrKWYPmmVW6R1fckMe9HK1d1mLnWNk3B/TJo4z+viIXrLKwyIbbQTD30T05xrTNXNnnHv
	ze+VTdRDr2/564FrSHp5/O8ZpxJNbps=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 969FA176B;
	Fri, 27 Feb 2026 09:55:46 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 822BA3F73B;
	Fri, 27 Feb 2026 09:55:48 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 02/30] set_memory: Introduce set_memory_pkey() stub
Date: Fri, 27 Feb 2026 17:54:50 +0000
Message-ID: <20260227175518.3728055-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EDA77140006
X-Stat-Signature: trffw1an4be8fjpf9ecir7refgdirou3
X-Rspam-User: 
X-HE-Tag: 1772214953-774740
X-HE-Meta: U2FsdGVkX1/wnAqikduPt/oNGgVm126I+oAl6WtfqYeBnxUfxYf2Bpa1mkacDW2dakgw0MdQ3uPnL5o7HO5icvJNEDBeVIoVxnaOlBlFYVYdU1NNAMF51/7F771ooq3UhL6pnOM4/LP3d0+JPwXT0EhcS59hnPxkMOen1ukzSyh2Ov/BD2zKjY6/3dC4nsA1vQbYnN9M8BMuMUkPE/s0YW51YSE+v4NAsn0TMDWWptv1AeokM4vwj321jBQ8mNxQRS7zbfDPqd8K3CaGcEaW9OY6TuimTvs2RDYFmfiYqGn3IGSMEWq/2odlWd0JKCbXlnv8RFxL8TZLP0032zj0mxWe8Lfca7TUKmjc2fDs2lK5HEBYCGwRe/aMcxixDc6OP94MBA579uthuZYqgLYX1J6Al71YlCRllXbLJ0Amu4LeRJR9SI+mZJ8iFpw/YuvEXzBNPgr/zzE8+0y54zewnsMQQESDmCsllZIDuisK9/6u48K319ZFf6V21rzGdpfQalW15PZiAzYIIyyJ2GBJh/pLWMNmuz2eeCDIZAoWrn/gn7TVFF1wCkNmot/xIYT86ll9NJP66JuNhQrDlxG+PsVjpKSa8E2aIt8dzEcq1jUPuq2JmcaKr3h7FvA6IGZyX8MInoAtBI3MMVrmB7Jm6RFbYf5rFLEgI3lBls+aLigWhKCuh8OSFSX2TMTTfecgAOe9Loccgv2ItCJh6eVtVcsOap6xCG8dTy+l9pKknOyj4+U4O5MFMxOZEUuF4GmOzzG2WYWVaKfa82f8t7LV9pjdaazQ8KV6ghuRqn2iu9sWWMq80VR2Ydin6MurT739OEE2JDBDDrP0vab2oecEpPgXEyUHil78GgFsYLmYKnJ1ETPXJ0CRw7HVatvyg4gu71Dm4Doz8ziHamQc+pMhTIfU+e3bSYgwBFCBfSlnKMYduKrTiaE+wwP09VAMQLscHGCzv6To0348Q7owDuG
 ZGLPwmLS
 ZxVhqpGn8JwNyDmOPcZR3xvbbMtPDohJyktiRHITrYhIF5AxOyFibllzZ26gBCW/s9cllHS6FAzmrY0UW0laYYs82FStUNhVlbKy3ebhDvd0y9MDXiRNFZEsmW+kUX9ulsSSbX8r2NfQoKmWN2DoAhXo6f8P5Djofh337BFov9pnoA13WSWrwY8s9CV5thRVTuWJr7qpHuyoYAsEu665A9CiJ4W6qFgXrARcGxXqXSYPEvhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new function, set_memory_pkey(), which sets the
protection key (pkey) of pages in the specified linear mapping
range. Architectures implementing kernel pkeys (kpkeys) must
provide a suitable implementation; an empty stub is added as
fallback.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..7b3a8bfde3c6 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifndef CONFIG_ARCH_HAS_KPKEYS
+static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_SET_MEMORY_H_ */
-- 
2.51.2


