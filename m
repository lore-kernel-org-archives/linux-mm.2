Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8D9D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 17:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF336B0089; Mon, 26 Jan 2026 12:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C7B6B008A; Mon, 26 Jan 2026 12:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799016B008C; Mon, 26 Jan 2026 12:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 694E46B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:45:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3CA913BB93
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:45:38 +0000 (UTC)
X-FDA: 84374842356.03.260CF18
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F30E1C000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:45:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r9tmsaTz;
	spf=pass (imf20.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769449537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wtayOmnwhUzFcyDzarUn+KEuppFLbcz0NQpv/iLeOf8=;
	b=z9HXRmwbOjPqHKkc8J/fIdpDGVZSHx8Nn6cjwx++CMURVXgk6U6yhs/u3cp1SLu+YPqhlY
	eLTIZKGuwRjgvD55NDhyasOEi/gT8C+bDoD1yIwO+xjP0SdBspDgGnD+Gn3v7wOEQaQlh9
	SE1/Hs05kYzlODsAh7HN/DV9GbUoSj4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r9tmsaTz;
	spf=pass (imf20.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769449537; a=rsa-sha256;
	cv=none;
	b=qrDgcyZ5FihxyT3z20ex2fFQYHko+ljtBd8BAYyou5lNOZe/sP1hj3aZ0huEbQeRILMjLJ
	0DRq+Y6wXiAXYStz1Js6afH1AIhy62O6Ft97IC1uIVtJ/18MND93RJqQHORVXjwCpM0Md2
	Fu1S3A/jOW0z2eO49rKGgxoVZIeWPzc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769449533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wtayOmnwhUzFcyDzarUn+KEuppFLbcz0NQpv/iLeOf8=;
	b=r9tmsaTzW9s6q4OnJzUK+BShlrGwE4QmjdaGRsqWmlcU+fvwjOPlj59SnzxBP8bpRmGP8Y
	NCH05w8oJmXteT7xU7fX71v6VLTm55hl7bj14uZbIDk+k021HEMedqUTUoDxwctRugtb8X
	M7asHi8Uj1CHlyEYyZg/eGckK1rYUno=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/cma: Replace snprintf with strscpy in cma_new_area
Date: Mon, 26 Jan 2026 18:45:15 +0100
Message-ID: <20260126174516.236968-1-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F30E1C000B
X-Stat-Signature: x9yipyii5u5d75y3tcqmdz68prwnr9km
X-Rspam-User: 
X-HE-Tag: 1769449535-113757
X-HE-Meta: U2FsdGVkX19NpEuSAGXoy8qJNa2Soyip70xRe4NrGqVioxKBbc3epMyf4Bk++DUaOlRyhSYZ0XJRg9AAVMNR6nUVRC3UaoFqQ5+YUJHdwoHTK5VJQxhdh6SdK495t8YINx+X+xDUwN6ewUdZ7qFkKXVGMtMbueulp1lIkZzom+apWSOpvrEIqkhsCOjXdryPbOnW6+jcWR3X+7I6HaJ6rXFvs19Zi63uD81BLDdLbdmsXM0leY72541OvOnG/x3fp4VvHQJV5BkKDqO9vMoQEPaCT7BW4nb2sRtPBDrJvG5NbmIm/vXXt6Wm9hguTJZ8qYpp9UUtzoPoxtfUbEdLjPR+I3tFqfIG1VOIlm53iMRFHu19DfiVzlXkt0WdiUyx9+HuMH7O8V95YlnL2vhcup1WBVNf82iyiIRG6OiF5H+6+IywoliGDEM7jKD45O+vK6PfweER5Y3WfPWmZJkPmpFisjq6CPkMa7I54BSqkwAAMuOQiXWcd7sNqcOxeU/eN87Qu3RyYNc65nS8xhtBycFzUrrNmrgskoGVQPpF6j8I6AkIjAUHQXDjAenIwH+s7dFmrxgdVTk2T5xpKdr5TvmENBb4qso7F5FTnhQtqProieD98x102qGaLdap/OHnOYftfo52X8XastM015EIYUdnSjoxkx1BmQMw8pCstMoopw0dWH2rJJ1lfnFBccBcc4XmwjGPWR4ai9yrGKE5clItNwjB1TY9H9AD3oDdfhHcrDOkWEY3h/P7PRpwTV1TzjMRCHYk6GqRWLaTmU324YLSVpcT2OHjK7SXjmfxCRUDx1lakRsoTWHGQGRHQP+wdr9BKEeaTzhmna+dhvglDYo5s1iZVZdzDj6zz9GLUWsNOTvvdGrf6Oo0qazPcMMP3D56PBbqD8qTcZdFUmCoAZDJLumrptTNgCUQlk0ofQU6aMjte6bzgBQDN+aOABjYZtqTpz+xdFPhhX3K3Uj
 Jel3USOY
 Vyo44YB8dwiW58MhrS3oMqLFduiMEDDUAOLcVcZZ2CTRN3Cd2Z4PrtuEF74kXRtIPHKh/2jx12/Y25Y5sIc3xCAy7OAHqRn4kbcLzx0X3a9V//URWpnxemDgwe/GEIJvWYHgI8tsj4X7qaIvWQSrW7pgTapc98lIQrbauBMuIRcHSjwdLDQsfuUlSMnqtUIYuVZA8M53B6qbBYWBgLyGHljK6yIDahV0nx95rA+4pA5l3Y9msAZGSaj0wvcNj0FisUAgn0MxRiFIvbuqtmjPRaN8zf10IsXly6v9GVdrMOPvWGXp+l3io5nupZMgqo4tgd9Ynzoui1LAakyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace snprintf("%s", ...) with the faster and more direct strscpy().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 mm/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 813e6dc7b095..44b43de28c13 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/string_choices.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
@@ -233,7 +234,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
 	cma_area_count++;
 
 	if (name)
-		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
+		strscpy(cma->name, name);
 	else
 		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


