Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD6BCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861296B0391; Mon,  1 Jun 2026 08:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBCC6B0393; Mon,  1 Jun 2026 08:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B37C6B0394; Mon,  1 Jun 2026 08:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 563CE6B0391
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:50:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04D841C0565
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:50:35 +0000 (UTC)
X-FDA: 84831327672.09.54D1F69
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10A3218000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:50:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vYXGUk8C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jnHbUAkR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XAlpxXBo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="YqcZM/CO";
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780318234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e5FMNbqVpITkHP0wn7Xclb3vHyL4/l08M2os5uv+gd8=;
	b=zQxsxTbzPoVkNVd7Kdzf0rOQc2NJ7GnPivkD+pe8v/uibFgCQZAioG7gMOrdwwBax5CXh2
	j7L1jUv6rnmzdBG8bOfyp6iPKx9b8U6luA89N6bGX3gE5fCiB7y6Pn8tcv/e1dyVzo8Jea
	y3jCfA71PtwFKcIzFoRaNXJt6Wylm0M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vYXGUk8C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jnHbUAkR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XAlpxXBo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="YqcZM/CO";
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780318234; a=rsa-sha256;
	cv=none;
	b=H6WclTLvShZIYBFf1Xfuy6uTykbZuxCRSW/W7g6nEQynRvBsSVZR1kD05zxONAwMyECwnD
	w+6L8ly/KTcnKRkZHejbq6rXNiSJs7k5tmR34MEuqLZ1Jo7uF1d9zQrci3kouI0mDHfzJs
	7eESSD1rcWDz/nnw5Gtt0jmfqMkPn0E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AAF26686B1;
	Mon,  1 Jun 2026 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780318232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=e5FMNbqVpITkHP0wn7Xclb3vHyL4/l08M2os5uv+gd8=;
	b=vYXGUk8C+Iew5cCqDmE8CZcsAReILvnZHcIv8MeWkN6s1AnnN9SnVqUr0uqLcE2RHOZqlm
	nkXKRjM4GM4IU3borFXUZCJpuNaluso59v6J92UEMM1+yrmhn7MUbUQUwjSj9uV6VbAkLY
	2Kkd9eCpqMHu6v7pXp0xGrqr23VenSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780318232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=e5FMNbqVpITkHP0wn7Xclb3vHyL4/l08M2os5uv+gd8=;
	b=jnHbUAkRSQd8iUAx18BxKKfl8y//DatwU107mliT5s190/iPAAztYrSZBjDqUzm5kJ3sqH
	McpyTfnJ8B7qblAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780318230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=e5FMNbqVpITkHP0wn7Xclb3vHyL4/l08M2os5uv+gd8=;
	b=XAlpxXBowJUpgxboL7j0s79yYqNtz93wZjEgSrhc+H9G0YMAOysXpfgo8TNpnJwq5Bz/EH
	8YSlB6SVXr+6Mgfs/WL+UMq4r4Bigm9pazMtdFmv5EVHb7JV+uBWTS+scx9Gr9aP/Ebkv6
	2iMe493CNoIW5s7K8d0KqNpuFPUHQyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780318230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=e5FMNbqVpITkHP0wn7Xclb3vHyL4/l08M2os5uv+gd8=;
	b=YqcZM/COK2hWcyWoMvKhM1WgY+MnEzlUha0YC98i5/ej53M7s7AvGEbcg8revWZoJKg8M6
	81sCXGFgYV7LbEBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5686E779A7;
	Mon,  1 Jun 2026 12:50:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sAb/EhaAHWq5HAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 01 Jun 2026 12:50:30 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Karsten Desler <kdesler@soohrt.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH] arch,x86: Skip setting align_offset for hugetlb mappings
Date: Mon,  1 Jun 2026 14:50:15 +0200
Message-ID: <20260601125015.216110-1-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: jokm759gp4rcockm57dqtiro8j8xqe9b
X-Rspamd-Queue-Id: 10A3218000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780318233-355386
X-HE-Meta: U2FsdGVkX1/6+Pg9EkgvO0b6wVQ0sqZlf54KK8j5HGiVHHXgnTQwj3pu0jTl/HjDZZE01iD/NTV+0rYoyQ2GzruRVrybW50/3io5yZLmgkd6hK26FuOgAO2KeLiIumgeONMBYxYMmoKDO0MnoifkUCUC5hFCKMwIypSjrF+e6PK4U3PfMUhbpkSyhD9Zl72krrlh4YveI7jz16JV+LxKEaAQ6hPyrS4bdZj3zFJ4Y6fUPh7FtYFVtmE7bEtvAlE68waRFwVYZPxY4/u4GPbd+PMDc8t6XEoqOcit9Nl0CWTD51YIDRBGmIII5JLjbKNGy34HxHWFUI23CtoOBTEjfFeNNY/RW0Ymh8BgZCbHnMx+/xjNToTN6potrMjl3WEIioSEZn+L/V1Txt4LuOxfxj1MWHTuWI7BKXBE2ivdoVXH4eSXihAfcKz1hDO+KdsvK6LEWXoFySIB2sdAKakaU1TKABb91RE4CAZjEObs/4axvjP7MsF712z/SWHtYYmwyvvXTAGYh04NrtwyZflju+tnM05qm4WWzANn26XuiXnmYXtiBfJsOtsfGBsHvC7YVhyGqn6qkuN9GR1UwZ2GgaE4vETnoCsBEO6sFuL7CQ6uFmHreShEPOFCheGQ4jABqT/KL0qKpnK53P8avbeawkkKy7UToYCir4tQ2yuRP2Puu5LfkrxErAicjgXmBUwelnbqh0rp70Z3uxgCnK0u9lzb9FIx81IB6LpCCS7709QhP6y0VlARtKN3+hgJhIu9pUpkAqQw6UC7gWd3LkxkwpaTRWT4C2X38QtLo6c1E4KN/+HRSkd2rslQPwfwSlklaiKGDz7xndypmdOg3eatu8duwpccGNtw9IdjI0zHn4ZU3Ce6EX1JllWy8UVV0MwkiohATtS8MBd6AGAA5iuB+n9bMz09/UFsqSTxb8ZnhGE0dmx9N348wgGXjNpyoNkIQXW+zJ+4YRdscw+T9SE
 PODnWbK4
 UlNPSD3zls5A07OM80r0hzDJYSfvwYYQMc1r9KwvyYTw3iyN8VFnfmqVsSQGu289HczSW+1crNli2gUVrhTZ9aSTFnNhL0R3uZ809l7M/ZNpkPX3FwXQe7ls/WJaFL3VpiPhOfJ5yqU66TOGAp+YdCyiowa0Zm1xZvXHkqMglAcqeKogWLOx+6wox8NX75KLygjCs+pRBLEt3g7t+UoJrCrCZPN7lNMPNZQaOYvuSEQZcV7kmMgkY10Pdi0VdO3hcDIGv3M6hnJRWGpWsrSZ3qXwZCZEJjqS2bC2zO3S+6zENdYPeA1AP3cSHlmallMNfmNRpQQVnRQzWN2w3MMEZnZ3sxKKf935IJg1dgi+31yvkzr2XzBn/wM91Dtu/meApzIai
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86, arch_get_unmapped_area{_topdown} set align_offset in order to avoid
cache aliasing on I$ on AMD family 15h when 'align_va_addr' is enabled.
Prior to commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags"),
we did not have to worry about that because hugetlb specific code did not set
align_offset, but above commit got rid of hugetlb specific code and started to route
hugetlb mappings through the generic interface.
Doing that has the effect of handling non-aligned hugetlb mappings to userspace,
which is plain wrong.

So, skip setting align_offset if we are dealing with a hugetlb mapping.

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Reported-by: Karsten Desler <kdesler@soohrt.org>
Closes: https://lore.kernel.org/linux-mm/20260527143643.GO31091@soohrt.org/
Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
So, let me say two things:
1) Karsten tested below patch and reported it was working fine for him.
   Did not stamp his Tested-by though, because it was not explicitly provided.
2) This is a hack, I know, and I should probably be flagellated for this but
   since this is a regression, I went for the quick/easy-to-apply fix, so it can
   be easily backported.
   Having said that, I already made my mind to fix this in a better way, which would
   involve getting rid of hugetlb-specific code and do the masking off as we do for
   THP, but for that I need to refactor the code and that would not be so easy
   to backported. Just so you understand the reasoning behind.
---
 arch/x86/kernel/sys_x86_64.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 776ae6fa7f2d..60f876dce8e5 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -157,7 +157,12 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 	}
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		/*
+		 * Hugepages must remain hugepage-aligned, so skip adding an offset
+		 * in case we enabled 'align_va_addr'.
+		 */
+		if (!is_file_hugepages(filp))
+			info.align_offset += get_align_bits();
 	}
 
 	return vm_unmapped_area(&info);
@@ -222,7 +227,12 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		/*
+		 * Hugepages must remain hugepage-aligned, so skip adding an offset
+		 * in case we enabled 'align_va_addr'.
+		 */
+		if (!is_file_hugepages(filp))
+			info.align_offset += get_align_bits();
 	}
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))
-- 
2.35.3


