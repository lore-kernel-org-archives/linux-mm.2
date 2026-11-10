Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3339960A3825
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eGebV1oP
Received: by kanga.kvack.org (Postfix)
	id D75956B05B5; Tue, 10 Nov 2026 06:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45DA6B05B6; Tue, 10 Nov 2026 06:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BBC6B05B7; Tue, 10 Nov 2026 06:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 909316B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:24:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E883C4059A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:41 +0000 (UTC)
X-FDA: 85418976762.02.7A00BE0
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE57E40002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eGebV1oP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAYaxeqiO3EFcx6b3dV/TijEGWqi49tfP8usMyM8q/8=;
	b=aHGgDralU624KdIu+CULIe/tZLx40W7hOUUW3Z6sHZZUCPBxb6TZ8uHESG5YSYve22Q1Mu
	mJrG3z8qPsT7VqJXZBYTVtoe02FbO64GXHtd3p2+w/Re5CmblLFAviGuzV1zRD69r/BIgg
	6ailx9LPMOyYABssYqFe+lCEMgZOMII=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eGebV1oP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309880;
	b=gmdk0C+J0GxnVTIrCaLyMqM4BUtVss28iUybF1HN6/txgWZkV9lEiUY+YOaTUKiYnXtNEc
	TySuv7K8leuJ/A8veRRBN+y0wNu4FrebflRIW3N+LcfJBJTydR39e3tf16yF2e/3Q3Xjei
	veohjLdiI2HkYtI/8qkWuzkoJ06jqWE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M2vUNFESdf8UcymT8hZpLIfWSeAjBKgtnQoCKkOWGtA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309878; v=1; x=1794914678;
 b=eGebV1oPyx6afFuHuI/2Y2t3YTlleYH6W+PMr+X9IniPEeUceuoQo5pQ9DLWos8ezbAotpOJ
 XPSmVLWtcnb2CsCMYNz1UYwiXlcHj6paESxKt79lCqEe5iTQx5gnr8wpb9/DclB0fPI2C3mrNeZ
 jDNTD+VYwefaoLtuKqBY1cdc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 195e13a19fbd8c13;
	Tue, 10 Nov 2026 11:24:38 +0000
X-Mizu-Trace-ID: 195e13a19fbd8c13
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 2/9] mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
Date: Tue, 10 Nov 2026 19:25:39 +0800
Message-Id: <20261110112546.261415-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE57E40002
X-Stat-Signature: xm471mjdg7nk74rbkoi4tfguuro9p8tx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309879-8753
X-HE-Meta: U2FsdGVkX19875ZNyolBF2cwPXrJ99ihq6LqMGGHWzI3CKZloRJZBoYqDu1ZuhuUMH1Gr2SeTkyhgCEfPcBjA7SITxZQs//aj+jZrgHuvbi2rnBT1XBb2UQwyLfwWSxq6WT8mlX7yDMa4eCf2EVp5dG6bHQYQMTmMAkUK4sHW60nOW2bXgKfBsAXp8HLqJCauZl+bp0Gh+z7PjDpST9PVrsNXz8QerNUEph2JySrpsa/PbN6TFwhstcrJgavHhP41BFiJg+g3/Qbx3y7mjWzM892gmmrpvv2FAeSa7aRXKbiDl2RKbYkg1ofrdvZnL9KPgvePyc2FoUnFs+w0+jNzwkr1VilaPll0/q0wWLvELBbdXl8105jc1WuD8eiiMti75fgF/IV6eS2J9KVl/AKn4uKVVyROUOMm3Qh7A1DAMOZmyigoCU6gf4JJFi6CGmfB5auEUJUiDwK/Gr5ZxxjEELHoG2RhVn/Pez29hhqg0x7heOtbZtoSmO9KojWuBC4fbLaOD6Xp/3fnRROCnp95RcmlmLXYeLGnaUFI4RdkgXJBvYHqDntucfdC3nGD9ZPDXJ4HEBmurOazHGgehr1KEi7+koBTkTPVDp5sODgMPZ0pHEHleqvZRmQFdK/E4zrSbLZWsq0MxOkyaAuDlaCWuc3K4PL7fl9ccqvvsWIUyO1QKGigVpjNP9Ktjjas4SqoaEpqrF4jxLLIVildd/iuz8doPS788K3jUbn9ZNes1VaEj4JUYFfkFPjN8JvCGTuIMBSIz9XkFlIVexatv3cGQJBobQT0eNMri2iZxSw361FvR2kHOy9jI2j8L7J7z6CWc5FTAcCMZbFTxVmTW9PNKNRRJjW4B5thfRrOU3TT6U0EHrFrT7EAk064irvJpJk3uybIq5WJhwcowpGDP0d6+uMl3KleGT+pEukl7q7S5TQXNrAWUWqmoE7+e2jIo1+XJ2kjrFcDY2DUxzS4xw
 U2HYABo9
 PFZ/srLAuPadl5Nm7O+Bjv0/su5bR/a1tACdo39qPlDwdKYoZrKHHU8ixMvEzeAv5yYOo6O9CgF83te1BwuVdpW5adD/gVX2v3lwB2IC7L8W849U0UTZ3uqb8vcfYcNFIapJNMYJdSfHb0qxL8iJ6hH+qdBPQraSE9VjHATEz0ET9axK3vVrIMl17vYHET/DFyLk8PIGkYNJiTcHblxcYszOupFxWniISc3ggSJRhXbYWhkMCLhxY6PgEfM3Iz4Z6cF8kDw6OMLRoDTpMJ9V3fxwIXc52YMZIHWiVLJ9K8jexI9o0Rv0zkhwV1zB9x94FzL4isHZmZ29srEyse0TAbsXDF597rIHS+zFKbNzO5gfr61qa62uiHWPg2slJZqNz5i9LXxONZUEVf7M1ugHpDu4k8j4ptoG2oImJDpqBS5XTAETbgNqowzxxrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
false.  The unmap side does not, so it still walks the shadow and
origin page tables even though KMSAN never installed any metadata
there.

Add the matching early return.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/hooks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index a706666db097..107f66841274 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long addr)
 
 void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
 {
+	if (!kmsan_enabled)
+		return;
+
 	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
 	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
-- 
2.25.1


