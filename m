Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CBAFCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B866B00BE; Tue, 26 May 2026 08:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC296B00C3; Tue, 26 May 2026 08:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2EB6B00C5; Tue, 26 May 2026 08:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8806B00BE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:50:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 571228D078
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:50:50 +0000 (UTC)
X-FDA: 84809555460.25.CB95809
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B2FEA1C0008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:50:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQ1b9wxi;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QS3zRW8grvktqu3cBj8ik+A7ULBupIIqXCgnBPaCvWo=;
	b=PnYAX8mZAyF83zCahPlu4fweMG2myxf9dI/rW1+rCpt4f9ce9zW+RAd72a1EB4Xu3Sqd70
	x9PB961IErnXc4Iy2aly/FUH/kFhfgoTx0h9nO2ECaMVknyVphteTEbJnptSEVR8BR2XRH
	zgZvhxTa9SNiuyy+qLU6Z723pN3zxB8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQ1b9wxi;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799848; a=rsa-sha256;
	cv=none;
	b=FjDVGIw5HHuqdWE61sS2ApDM4/OCEm+3IEfBSzID5SCeE4AOefP4am7e9n/LJ0EQVWhs9j
	gnEgYq5P/kXDHcHP0cGlUZFV3mF3LlnqVJdsGYd5QepXNM0569eNO2/GMs2uzwBEJlrVfI
	rHn2M+lKF+kYmLUd7sBv6y0OS6rsags=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C82ED43EC0;
	Tue, 26 May 2026 12:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A701F000E9;
	Tue, 26 May 2026 12:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799847;
	bh=QS3zRW8grvktqu3cBj8ik+A7ULBupIIqXCgnBPaCvWo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IQ1b9wxiRyLWKHqw+KxnzMq43qjljDVqd/WO/+7KPyig4hWPh1VKmjmKKkWy8lH5Y
	 dqKRK+jjsUHHhYgbLrv68HFDOiXsmfAYvck2KGHGI+hVLxDrgYgsQ8VKFM8cxqR+0F
	 agAQkMh9sr4/WIiGPgSSFwO6QqjX+DTIE0L/eoYfp2Bs5w423vU6Rr3jNWjheX+Mf9
	 EE6vu3kBG+pApECzc+82V1HH2lH0QMY3JsLrv9lhQfNNUFSgShmWLiIZFgr9hvumIL
	 hUX++I+joboSxouM4uH4nkcJxIThVoLfkamIptxo3bwdgLdx7cH0DYcviSVYt8pht6
	 UGhc+KlmTbMlw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 26 May 2026 15:50:38 +0300
Subject: [PATCH v2 1/2] lib/raid: use kvmalloc() in calibrate_xor_blocks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-lib-v2-1-ca3f0fc24b14@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
In-Reply-To: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
 Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2FEA1C0008
X-Stat-Signature: eznibf558zzceen1u7i4jhrt5t7g7wky
X-HE-Tag: 1779799848-584199
X-HE-Meta: U2FsdGVkX19Hry6OndoTZq9MzBgVLT7jqwOv0yZvLBoqgTHY91GPw3a17bqOQpXrhyNB43TQzna8NH3okrMrBgXttS1wrspGEkzyEReooO4f8TROBi8s4sSTpjcvL2YaFPdEkZzNBAPx291erlfMiGDttmjQ4r6ldx1eSEvPDO0oZMj4jSY4m7UbKGNeiGqNQkLBsmrhZvKc/C5blhTRJ5HT+B8EyfnG+VRLQyioIwBfR3R4584MIdANNpZc2hUzTIVxlP4AEWvmqrgrl/a0wdytpDpmwe7t48y9qNGGMGu7Of17GKG1yCdUeGnoK9tLlOqSflDu01tQqKCsPi5kXTaFrCYdKtXJ1bfYqfYegKBISFtZRufp+ZvIRvKn0tTVr/tyNH33qFDQWPhycSPmir1nmrvI287Ol284x3vMN1H+dgZXWB9elLnzyXQqZcyhxb07zaJhNgGQNCHuhwglIrdcf9rK+s7boSBWk8mTgop5/RslZ1t+/kmJnYGrsz+eVobnUmU90G+5aTE//ewG3aI3cDxBgCTcfHlkGYtVHfu2b1K4nQqs3LRTQLRjsfxWC85RfE8zKxIQ3spkcidJkimb7dFxzMiujyO6s2FCRgM4xbau1DUYwFRNt5bNlQPOqms9N+oD9jWNONat4qM1hv9fyVBUgpvKV/eXy4QVC/4eeCwYnBQMv2wn1XfCjRYgs3WAFiJ12/HSrdgmEcwNy5uJ2VT1EFrsDs+5MOyjTcZofqcwhlDxqHM2/nO+1GitjxFyNyhmEA1q7PCMnaCyWl+UiIXIYFGgRSK7xxicgAK3ne8NxjuYPwbaz8yONPCl9tktuWHq5/r/VPBVU1KTnUzYGhNI2KRC6Z+kvf9B5O2mxHA2lcnZ2JB3sL2jm+4iM/G4llCwcgO6YINAGpO4fQvnXUt+6RzFSiXZjG1O93rYheLTBaarxYxoF30R1vUWgsbVgsD8dtfQoQWdEOx
 zX6KJ9QW
 ILgmpB0EdTUvhLPFv7xW3Yg3YFTtUDmI/3vPBFaH5Fu0HtcyermhEBrwlIHiR16w+/CffNbme2aM9HVYOWzUtZYXYKdmim/DjOMEW960nw21nxsB/HopvVvhrk9UlkCS3yr+w55nsdSejBVy5z76oquHIa+wRSGdJp8ceCGJeJyFRSWQYJNo9R83hrRCGG5blOoGQEDlLM0HWiIlNmndD29awKjjN6SjhO2WPO276M6jWY05PdhscS6h8tDbIE3oBgupO95IsX+fdzFEAg7amy03bvOh89UyFPD+4Zsr+6YqQoVIp1BoGlcbx5ubCQoq42jm9BJq/LdjjcbtaC2I3o1nurlcmJcB3ytEOJ5c2NgiqU1GSVN63rguadvFmFoybGhvZTz+rR83B1tWIm/FliL/M+KWGBtly06tZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
used purely as a CPU-only XOR working area.

This buffer does not need to be physically contiguous and can be
allocated with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid/xor/xor-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..9f90620617cd 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
@@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = kvmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kvfree(b1);
 	return 0;
 }
 

-- 
2.53.0


