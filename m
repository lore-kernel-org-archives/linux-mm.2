Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D37EC4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0206B0093; Fri, 17 Jul 2026 03:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0366B0095; Fri, 17 Jul 2026 03:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3256B0096; Fri, 17 Jul 2026 03:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD9F56B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:03:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C0F21C0254
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:03:25 +0000 (UTC)
X-FDA: 84997377570.27.572C932
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86B101C0005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:03:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LFWcRMMZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784271803;
	b=RjXw7i2z9AmLX5JB8Hsj4cH/M39j2scbMQ3E+QtGi7I1VnygLFNt5aPBhLhxTZzla7L+kV
	s948TQowrNygLMZVyugsTpXiSA+NHxHorDTFkxunzWWi7HvYQGZ/K6+Qrst9qPegZl/pjQ
	laR1WFf9MR3TPoSXWxddrvYDwa5s6OU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LFWcRMMZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784271803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z8nty2Cb7mt9YgTiJdrfdlvIVrvucL4Q1GJIZGhzmKI=;
	b=KUNZc5pzQ3p5USDTPmW16+QuzU5S1oWxyBtd+D9K9R4nYBb8TGeP5vh0xCLUd0mE+gUl5Y
	pxBZeoueiPTWphsWbCv3BEem5GPRYrZn+GD+Rsr/m6X24oOepSeJVpth+bPbvwto2Tb5UQ
	82XWO4zYgN7nqW9y5sXskIVVXye0IhE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784271801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z8nty2Cb7mt9YgTiJdrfdlvIVrvucL4Q1GJIZGhzmKI=;
	b=LFWcRMMZC3ARLQWT4SjdxAGcKL8fbEaE50vua4PcsSiuQVzWqpj2o2VTZ8d32o/Y5iltB0
	JrY3G0HQcQStbJEORWi0tLNNlPdaH5+xYCUxADZmgw/AF9tB9nfQ4Vk82qS9+jJHfX7NAg
	MJ9UJQB3AFFY+k2/7NvkzZ6JMf8ZPNg=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: Fix BUG_ON checking wrong variable in mremap_dontunmap
Date: Fri, 17 Jul 2026 15:02:51 +0800
Message-ID: <20260717070251.73212-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 86B101C0005
X-Rspam-User: 
X-Stat-Signature: cyeddy9odfohyrm567x7qzfn19hxxgrc
X-Rspamd-Server: rspam03
X-HE-Tag: 1784271803-812612
X-HE-Meta: U2FsdGVkX1+ZE5PegxA8fI/2Hw6ufv93QMsEU70KJTUoFx8x8cPb6dxKjPFeZVTfWLz5wW7muJE1tqBtafeNPUNu6rS/trBsk/5ZC7HVZZdKc2/yPx8AIfrhzYuDSbGTRnusWZEEuHkdUCNZ6olEx8UNtGbYob9YJ9zmySG2GrlPCNkljqrF1FqcxqfZULC7LKF9gusqVBxee9uL5qRRlqTgXXgmltVaaGUgP6fxaA5VWV/f9G/biRXoarACcAM2E9JIyZT31MmPj5kWVzCTn42YEylToY/VzJjSX0Sm0OJeWeR7/tVFnCk3YtaSy7RTCnuQUiL9IPs0EiTgtT+VwkmosKRs/qP5TeLVMsuwImpJgMft2iZGOSceXJY10LOTOukvqckHYPI0BVNnGWORxcDMqoreRQ4p6/oFEoETCFZlFZ1WnDLyoI7sLIMuQtZvWazDhhWpA4vh53j8udc5zZ7N4dQE7oa3tLoa7e3ZRabxNa2bUXO870m17FQJAP0iZ3teGvChlfsTrMZV+3bxSYTZ/voTM9iwO1vaSj/T1mzVsscIoPiqZjzZDHkR4Zpb5OnFttJMTKsRLu/Xcs6Avpjefy70rD/rV3SWlY7cNkeL80E8a5JdCM97YjsZ/hg08yV2sWWwq6nqCkkBAhnGzU887G0NkR/qiBzrjWUtkw2yZUO8a4O3CyBeAeV2U8OWSYUFWVox/7AD4Y27y4jJM2vZwle/wi1rtw8ddT3XYYRTnfVbwaulizCQCo8HvuXP3HYA4/vfR8qfkRZRXDArgJpIWDzMLyXvSX/XRbuFyxyxLQKLk0KW75AuKSJ7jmEYBueNSzrbau5uQQ2oUdY/yN9kgpyhCTn2xnVEhThkGRVwwM+nFQZN3SQmUT30w9O3dls4dMH9x3ak/0Kh41MhJZvxEfVvq8CC+6G2R69Q4+wr1bKQUFSjOeXuX18P6jbnWBF8zy2+jTTD3vnPro+
 b4BpkDv1
 uxLz9uURPgnZ6Z6PBWsz8A0Qy+ga1RFLWYponmJ+g11f4ZBPlkwISLgfdn2jPreWeMifNH9QHomtTcW/J6bqcVESdMayPdnHbTg9dXPpiEqw2Rc8imbLUCGtDEgXhS2pldinSWR9d0c9BSrD/IazgJAbgymz5+yL2IGO0oDIYRjPKzV6D/7Sg32/6dJR5xIsfLxgGd3G1fXBzvLB60Gq8CfrUfRD6iY7/OYxox/jrW+S1JLwinuf4oW2e8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

In mremap_dontunmap_partial_mapping_overwrite(), mremap() stores its
returned remapped address into remapped_mapping, while the BUG_ON
incorrectly checks dest_mapping instead.

If mremap() fails, dest_mapping still holds a valid pointer obtained from
the prior mmap() call, making this BUG_ON never trigger at all. Correct
the check to validate the actual mremap() return value stored in
remapped_mapping.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/mremap_dontunmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_dontunmap.c b/tools/testing/selftests/mm/mremap_dontunmap.c
index a4f75d836733..96ba537facf7 100644
--- a/tools/testing/selftests/mm/mremap_dontunmap.c
+++ b/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -313,7 +313,7 @@ static void mremap_dontunmap_partial_mapping_overwrite(void)
 	    mremap(source_mapping, 5 * page_size,
 		   5 * page_size,
 		   MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED, dest_mapping);
-	BUG_ON(dest_mapping == MAP_FAILED, "mremap");
+	BUG_ON(remapped_mapping == MAP_FAILED, "mremap");
 	BUG_ON(dest_mapping != remapped_mapping, "expected to remap to dest_mapping");
 
 	BUG_ON(check_region_contains_byte(source_mapping, 5 * page_size, 0) !=
-- 
2.54.0


