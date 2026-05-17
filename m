Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C25CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700F86B008C; Sun, 17 May 2026 08:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688476B0092; Sun, 17 May 2026 08:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C116B0093; Sun, 17 May 2026 08:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B42F6B008C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:34:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2099405FC
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:34:55 +0000 (UTC)
X-FDA: 84776856150.23.54D93EF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F67540002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:34:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ryDewiyB;
	spf=pass (imf04.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779021294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+qbvwXhuv0PGjSrMzWrSxISPxVLoCXGXxeXq3G1w9A=;
	b=uPySvCDmdAJGSU2ktDdvx9CkStsinmZZ5g7gmaVTqy0dFj7XgNJOutPuuuJsHMi1bM9DsK
	zIAlQdKXv7A2THxexIObgkLPJ9pbjt8YKPS7o2Vh6BlFZhSd5ndu97FpTbWCpOW+BjcG4O
	ZasiMxIvKsNnsPgRnXpL39E00RZeyaE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ryDewiyB;
	spf=pass (imf04.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779021294; a=rsa-sha256;
	cv=none;
	b=K7nAlGlDQJGgur+/r2V1IPQWbzw9aGFaj/YcPPDxgwReqjeYlH2WTjSCZSwAjEnu19AUd2
	tnZKALyGtyp8lrZKjGCQJkXbVjOJazFWEa7V+AUyqg9i3c9oiPqdIV8hsrLBDWG1p2ESOS
	1mE+ulgJDl+bExdZt9qKeyTokA+ppZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779021292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+qbvwXhuv0PGjSrMzWrSxISPxVLoCXGXxeXq3G1w9A=;
	b=ryDewiyBeRCZdoqBTpXckvUxX+z0N/+lwOy9NWt6v7tMWBWSHsPy9Bm2UM1az67KoFVziL
	4rY/MCSZMJ9C8mQu6eV8jNxWPy4mod0R2n3ANZir/baaJ4ngIqMHjoraVu/eQXq+kJQ3lL
	izt7urPHqoZFl4aDR1Mpf2wt2v7gNmQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 3/3] lib/bitmap: use bytes_to_page_end() helper
Date: Sun, 17 May 2026 14:34:31 +0200
Message-ID: <20260517123428.1181981-6-thorsten.blum@linux.dev>
In-Reply-To: <20260517123428.1181981-4-thorsten.blum@linux.dev>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1090; i=thorsten.blum@linux.dev; h=from:subject; bh=hpcu4Twx3gTUyOEcBev0JAIwm6gyfAkaADjQ/9AVL4Y=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcW28KCe41WLlmfSBX7e1nx7R+H41YwCGkY5v05oFWP /Oj5fMUOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAi6zgYGa5djP706t6tHZlp 81dmBZdvfzT11fTbO84evn2oIqwqw8ua4b8nP9NLBcO7kue+zY96tFz3WEP2z4OJeyJWWpbcDz9 ol80OAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nt9rnh33ntmacsta79nkwrecwdn1jj7x
X-Rspamd-Queue-Id: 1F67540002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779021293-856030
X-HE-Meta: U2FsdGVkX1/7b2G4RXlvRYMpO/ZENfeqqU9YkHrY8QtK7i5rpbZKXlaOXq6dktVK/Ycq3821CL5Wx4YYlvzjQtRM5LMzzm2N2Hw6X6Ud03/NTGitz8v3pXTVgJ3enJV2eJ7JjaMhEo0bJEjqJWMoOJLGTk8lVB/jIIbYtCcVIn4/DfqIxTbNy7CaUY0rM/9HtHYAhk/j47hYrvlZ8QAge6XD3ydwrXFUlfbFR7P88EhOR4jJzsDjJr9e+0qic1AyXaGgYqq6sjBxnZvr7fAcwLNOzcu21Q41B9NPbx0KbC4ITLPHij5sydKWN8MN60U++fY3JWvjd5SneUqyaI8Wwvb+fkD5rAWDzW1EaZVaULBQIzIJ23BT+/UBUbOYBJBEsfxzYlcJ3N20XnCuz/doQa+DnBcdKPdh27Y0ZucZ6C8ImJwDF1FCdCqjETiaNqEfY6zXq5lHKJPh4McBfvGQjXV7G/ekjMGJHPF/k5HJ1gX/s04F0UzsNCJglC/v+E6BATbdb8Z3K62OXJeaTOrxDcoMEnjbubkDc80YsyQCsHUSDSUdu2snwT32BkjrSDKdghC11st/fg3izuAAyoVGjYnJzOJlt4Fy1pv6h0cH1P+mWNtADax+Sw2Ybyl4dkBPMC25t20wQksWmyYPXmnl6URT/3tTbdqaFkvNtRwgELjq574Wm0009LYL9uWJsysV67DF10TEVG/79vR0mS9MHSYzbRavZY3Z8Hxccpixz22G9uNJh3ZqUyOuW8HUOv2zA29emH/kSkDqfdkgQULJqiDfHhVwSSO+P7hql2OTQp0ky21gtciWJ2iijTmHMh72WzvmgYW+L2LXbzHMZyg/v7BTpLLYW5/3CYSekdluBi74f3V7HbPvn9ZMVc5GCogwHNepuWDUFCwrMRyV5BSAalO84aQjnDwFS6co5R9d0sF5IQ1+3LBl8mptN8YoZL/guVPA2fjUAalrdbwSp+I
 NfMv+fDa
 4UxTfPRT3aoSioWPW1rVyt0HKcFCIut2VDgUj3d3fSc8pUlmAkwy0CSqeD+rrS3s71F1ouW4uRnHK5lQE+vAmAFM3yob9f0wqk+UlfUF/H2JB8T6CWPR9bqEt1MXwScpXRY9aZAM3iRdUItJYsmJz+Mcb+9wt1RrEpXijDRXV2H6hLkG98GVg66j/hpjM5tQox7CDGvc20jcTcYTbxH/oqKpqR8I92N0DsMZtvqpjET9dWaW/uc27ghVg//M1a610j0QRwkKkmd3yxlHhhhnubuXY6HBL9O3AcOU0zFEmCACQzELzscRo0HPn0Ek+dtLOGRUfoNMRwNCtvJtocBq5Lo9ufSQnbc0x263c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bitmap-str.c includes linux/mm.h for offset_in_page() and kfree().
Instead, include linux/page_helpers.h and linux/slab.h directly, and
use bytes_to_page_end() to simplify the code.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 lib/bitmap-str.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap-str.c b/lib/bitmap-str.c
index be745209507a..bf245a3eae4a 100644
--- a/lib/bitmap-str.c
+++ b/lib/bitmap-str.c
@@ -7,7 +7,8 @@
 #include <linux/export.h>
 #include <linux/hex.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
+#include <linux/page_helpers.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 #include "kstrtox.h"
@@ -58,7 +59,7 @@ EXPORT_SYMBOL(bitmap_parse_user);
 int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
 			    int nmaskbits)
 {
-	ptrdiff_t len = PAGE_SIZE - offset_in_page(buf);
+	ptrdiff_t len = bytes_to_page_end(buf);
 
 	return list ? scnprintf(buf, len, "%*pbl\n", nmaskbits, maskp) :
 		      scnprintf(buf, len, "%*pb\n", nmaskbits, maskp);

