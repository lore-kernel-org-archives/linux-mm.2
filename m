Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DBA606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jp2EfrI4
Received: by kanga.kvack.org (Postfix)
	id 872526B00EF; Thu, 29 Oct 2026 11:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822C86B05B4; Thu, 29 Oct 2026 11:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738BB6B05B6; Thu, 29 Oct 2026 11:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589B16B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:50:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 530FFA0488
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:50:48 +0000 (UTC)
X-FDA: 85376101776.26.91046CD
Received: from mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id E4109180006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:50:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jp2EfrI4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793289046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yaAYz8Hc0E1J++0lVxAIJTRPnroDQ9MIhn/HfIw3mGs=;
	b=6XCCXwM9/p5c7ztn8LTrcjGrV/2RRT96aXNWjI8ZWdCXtCH1fxcBW5yN825M3FA5huZ6sh
	BXn+b/eaYpdB+M0F8fvfIADnD9OAH/mHwBmVOzbI/FZiEMCSJ7ibrohn5NSFM18XFtCK++
	QQQOu0+Dt5ApP4ppSDGgYlh/NL2A/jo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jp2EfrI4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793289046;
	b=xxTy268d4WKS1ZuXSYnubu0GD8OKw9hU+lEz1V6r4DwgregwbnViZsfCYTOtQkxjx8VV4W
	scu5fo2sqCG/MPW2fn5nE2j9D6yJk17AHiWauElO5c3+F34xSTB57LBtHdS+xSq08DF144
	kKwvRzLQVBYzK6rpJQEam+D3OlHvEVA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n9CMCDalShVTKhOhD+z5DJppXsi7YqvLnst8+Zhlhxk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793289044; v=1; x=1793893844;
 b=jp2EfrI4BVBGN2zknGopZvCy+T/xY7ruX+Rl8f78cl08kZqIUKG058Yr5eU5pnNopGhE5qsE
 T0/y0iooL1vrTn9B54OCE8Z6i9vf6+egbewXom685DJu3Qz9gsLTifwpI7jznX/fG1UBE/D4GTm
 6lSJlF2DfLbRrRt8aW3b0P9o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 43b22051bb286e53;
	Thu, 29 Oct 2026 15:50:44 +0000
X-Mizu-Trace-ID: 43b22051bb286e53
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 15:50:40 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>, "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: [PATCH] mm/filemap: stop fault-around when the walk steps back
Message-ID: <20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev>
X-B4-Tracking: v=1; b=H4sIAHuF4moC/yXNywrCMBCF4Vcps3agiVCiryIupsmkTmkuJFaF0
 nc31cVZfJv/bFC5CFe4dhsUfkmVFBvUqQP7oDgximsG3etB9drg7DEE9LJwoIzHMk1ccUlvLji
 mNTqkQZ/ZGTLKXqCVcmEvn9/L7f53XceZ7fNIw75/AQGVreeHAAAA
X-Change-ID: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9
X-Mailer: b4 0.15.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: E4109180006
X-Stat-Signature: y4aodjn8nmkr6rftoucet1koczq7s4jx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793289045-428058
X-HE-Meta: U2FsdGVkX19Lhmsm7DVfUv+hEpEPXPoh0Gej+3+uygCfLuXtQ9BLUhhghFs1Y1fp8aAl0gj6ScG4CKaaMzyPH2M+BADMR75KtHNXIcjO1XgZ/9NAcPf3VwJXcVbJmHWfAH/F+kg7kcAjh/yZ1mdZ952gu+SlVMM/xguBSi0qc8nxgeQytKxO6fGBBpsRgL6r5AjsO9syaSqnxTWc0AhIt5EwRVA3HV/k2xCvVzBI2k0nuUsuGP53Y4D80sqp8p7S/LJCBskOpr/vZt7CmYCD9IKFqYG2tN/Mv/QxgJILIG4mZvCHxbaRhh6XOeUi2HlKoRdgxqsHvU4/TAfoOHk/OGtOeO7VQlj6NQem5BLnOc+l1FA43Lw/S/uSgc5K5E6mGGEDKLqV+u+Ezmps1ymS4o1aHyphm26InPPXDiVEhFVcHt+1Lh3u3LB0sd1Kwas2bSCCK8irYa047fJmpiZnpl3qPorip2G1g02WP8GnIW5kkvJMcvC/V2p/ZKXCacR90uWJwzGx++kjJNEw/czAvpJJCgvhCpGczSAhRxv99z9TXW4O5LFmJDTY5+XyXH27+k8FY9TFarrqHFowKr3C7IuLZX5UfDixW/EGgn4jFdpFHPSiBT4LlCD7VHRXtChl0XDgJF1Z3IG/davKjwYq8c2o2OEIOPzruU1gVvtfUyvFLztgGbE4jZmqGLP5Vao86DC91B8s4h/m62Qrygj6jFuQmvS4JbgWu+B/MuYaw9yUS1I/xRcZK9azPwTv43OU/ndYxl83VoIPIhHPd63nfL7xpYm/Vo8B1cUP8x5L/MIRWajhtoyu/Tk+jtY7Ww+Yw0lKOpuN1J+NZGd5QFGWHmnnw9zdUkVskkUkkIWUGnsBSae9hwigsPE1prMVJ138fz7ccBLnZd4UzuzIzON39P3PwuL+DQqH4OiV9IB1PXq1qB2clBOJ2nFc3hzSl5YAMp9+7Xh7u2+fcY4J34k
 DOjAVuol
 9m7BQgf3AANZ8UmGPB2BAqWj+QVW+cf2l72FWtkuic8y2p2bHxeKZIiWvtHxZNKikBF4wca6tWaLKokHLUGMUTTIv3hKzT7MTQdYfkGRuqphDEn48e6msEpe4+hrpBo3WAgMTPptQAVQghKoyVqNGWbLyLANdClXjcfCWI3yqIavFO/JXfnCyjz6FGYhz7h3sa6ObxsWsYWmCkjQXRLO+6ZNejWfHd5HMnAaXnRs45RcLRDxyWHo4urTYeqqZNoE6xR3xPdIq07jEwTpNLNZYA4WgsGWJNz6eIh7n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_map_pages() can dereference a PTE pointer outside the page table
it locked. KASAN has reported this as a use-after-free read [1].

Its fault-around loop walks the page cache and moves vmf->pte by the
change in index. A lower index moves it back. xas_find() can step back
to a lower index when a multi-index entry is split during the walk.

[1] fixes xas_find(), but the loop still relies on the walk never
stepping back. Stop the fault-around when the walk steps back. ->fault()
maps the faulting page if the loop did not.

Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 mm/filemap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..1df776907140 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		unsigned long end;
 		vm_fault_t map_ret;
 
+		/* A lower index could move vmf->pte out of its page table. */
+		if (unlikely(xas.xa_index < last_pgoff)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			break;
+		}
+
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;

---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9

Best regards,
--  
Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>


