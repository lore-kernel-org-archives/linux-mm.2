Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF111CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 16:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835466B0088; Sun, 11 Oct 2026 12:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5866B008A; Sun, 11 Oct 2026 12:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC076B008C; Sun, 11 Oct 2026 12:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F33B6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 12:20:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 488C6C0729
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 16:20:31 +0000 (UTC)
X-FDA: 85310858262.16.8BFE899
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD27B16000A
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 16:20:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=XADCc8U9;
	spf=pass (imf08.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791735629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I2h0x6MRK97TXy17q/oGa0pHMkpomhGIicSPhvbv6/g=;
	b=AeavYUtWpvgw0RSrsm7GC+4t+uXNKgVKPDnqgHMZxWRKPb0xIY3iiE2xbkRe2yW5BAwAPF
	BVlH1BEeMb4pHuCLV2mvP1C69wKnuDszejII5pEwtmXAAdq/FM/XoQoY+INMz/GBpd/+Pz
	jOL+aUXwUsycCel35Zq+49DxOgXQrU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791735629;
	b=YvtQuJaJIKsvkw01od4oxLsLBdj8Rt9D1lwbI1iw86+KRkESw6sLfrPFlzra0s2tOmJe1P
	MvGwlOqRc4EgycGp1QN1WyPYYAw+GWZoA7TT+BxDD8/9Nmyg6THPRyORXwdV9jkK6jUq2L
	rDX43+kXiy/J5IkUPfGSM9EzTev38/4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=XADCc8U9;
	spf=pass (imf08.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1791735627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I2h0x6MRK97TXy17q/oGa0pHMkpomhGIicSPhvbv6/g=;
	b=XADCc8U9B8QaYAchNDAG8w3uziok9xva1leOsMX6XlYarOzrlxHLQiQNEA2yRR9eYfHsJD
	7tcUmPT3d8Cz1A7pCmSLBgwzP9OKi+w/aHtUT76trhQpWU5UnKoKsXeAkYiDPwZXaY43+/
	EGaVAudImrmY0ja78Nii6cGyHZEjtJ4=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Andreas Larsson <andreas@gaisler.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	stable@vger.kernel.org
Subject: [PATCH] fs/proc/task_mmu: fix lost maps entries above 2^63
Date: Sun, 11 Oct 2026 18:20:19 +0200
Message-ID: <20261011162019.922436-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD27B16000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fm8mxgk49h9f51uqimjq1fcyzhrs7sze
X-HE-Tag: 1791735629-439311
X-HE-Meta: U2FsdGVkX19qXT7R++BknJ5Ft7LFyjGeaL/QULX6uenoH9DrTi/qy4cw+ZCqaQclcyHvbHK6YmXjVOAO00ZJbJK4qIg3Wj1qji2nxWRuS+VanQuFhFHtWl3e8M64KqqzE+lL1xgRvuN+PN4NVdDAE64KONO5pW3TzfLJ3CW+GaGQ5ToQZ3RiHqw5PEbBfsZd2Q8C7ihQT8Ef7tABeRm5YOyRJn45MLjvSZ+hVFByfyeKK0Xraac1BjalBVwzKylNfbWHK1s5oBMVSFzqb2JNf7DbrUzK6oAKU1SRgIHVWQWsI2mJXrkyExFO3bbjT/H8dGdG/FPsrR2zHR6TNBfFCTiQ80LBaJGrGVo9DbEZxZBBxv+ZcwlJMJ/o8m/eA3hMUnQnTOVczArT7DRI+8l81DRDdvC+nzq3jtJw/siyjUxcztrmLip3O8xgo9CjQZgjBWMgxk0Bk8U/g3pb/05Uv4RLQIjvs/ymDhghuGGmnNoQA1wCIHUyzbcoSu5e/oOgNOlzJU2gQVZpPvZehfW5YynLktmYh7+INGUHEOqZFWMyw+I3cv9v7sxwllbCbeBqo+MgnKmRRb1uq49uXAB9WMWvWf6SxTlPsMqegctjO5UJhKlOYwV1dYuAzX0GjmmbRr+YF73bLGgJl+L7HSpsYHRqNwnZgWcGNQan3lxQTOIzRq+UuDz3cpZP/SS78dvdQPU4VokY3cPwqQRpV1Sp7J3gbmsEnr2KxABHxTWMWLmhVt9IV1UIx6Yl7j/pZTaMoby0ynDOTcA+Z+HO7c5g0kfb5Cv4SRqXKoRVNeU0BSfW2NmkN9sciwCa+m7QwZ2XKieD+kr3cgRuGeptsUY/WG/ukxt+K+SE28EdxWND4LRsFptXI+AXgIFeRCvWEoV+AX1kAEjvKb6OZVqxVcPvLLfp/iP+Fr7DA8cmBumN+s/kG4W5wFJLmvEOfBALQVf0ayx/Brk+G9DVfo0wOZY
 htFYDiDs
 8yK5A3Md1e9kEu8dpa+OQJOd3reQVp9b6x3H/Dtnxb7lY+S+cEvzQBaawdxfDrsvMXG2Dh+yPGu/nDxb+Tqg7aHRIMAVZh7A31t6ysTkjt+uNXkhDDx700F+JUhWNMDLnn3BfUJuZcs8M9SKrlvIZGGKQhs6+mE9U5cPWirPJmt7frDjRNV4czUQ6+q3nc5wPvG//v3hfBLQbYGimeJ30RTka45Hey9YRFRZ5vtzpnllz9Q05oQrO/rmBJzp28bDaWe+V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a read of /proc/pid/{maps,smaps,numa_maps} resumes, m_start()
rewinds *ppos to priv->last_pos so that the vma which did not fit into
the previous buffer is shown again. It only does so for last_addr > 0,
meaning to exclude the start of the file and SENTINEL_VMA_GATE, but
last_addr is a signed loff_t holding a vm_end. sparc64 maps shared
libraries, anonymous memory and the stack above 0x8000000000000000, so
the rewind does not happen there and one entry is lost at every read()
boundary.

Reading the maps file of a process with read sizes from 64 to 8192
bytes in steps of 64 loses lines at 126 of the 128 sizes, smaps at 123
and numa_maps at 97, and the proc-maps-race selftest fails 4 of its 6
tests. Python's sys.remote_exec() reads maps with fgets() and fails
intermittently when it misses the libpython data mapping.

Test for the two values that are not a vma end instead.

Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Closes: https://github.com/sparclinux/issues/issues/111
Cc: stable@vger.kernel.org
Signed-off-by: Stian Halseth <stian@itx.no>
---

Notes:
    Tested on a SPARC T7-1 (sun4v, 7.3-rc5), a T4-1 (7.2.9) and a Sun Fire
    V240 (sun4u, 7.3-rc5): no lost lines at any read size afterwards, and
    Python's sys.remote_exec() test passes 20/20. On an amd64 KVM guest maps,
    smaps, numa_maps and the proc selftests are unchanged.

 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe21182..cdce513edcb1d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -339,7 +339,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	 * Reset current position if last_addr was set before
 	 * and it's not a sentinel.
 	 */
-	if (last_addr > 0)
+	if (last_addr && last_addr != SENTINEL_VMA_GATE)
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
-- 
2.43.0


