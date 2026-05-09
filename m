Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF7ACD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38A16B02D6; Fri,  8 May 2026 20:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9686B02D7; Fri,  8 May 2026 20:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE6D6B02D8; Fri,  8 May 2026 20:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEF1F6B02D6
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:57:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A1C5A048C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:57:31 +0000 (UTC)
X-FDA: 84746068302.02.794D850
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 818CC180006
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:57:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LeJ2zIJY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778288249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pD+nxbDFKBRIVr6vnl3tCVeWtnpaIBk5Z2HqW3vTtaY=;
	b=yHPHh22dHv1v+4Fo9YtLdYqehiK2R3FSShwPF6Pvq6DupwO+AowwwdaSvjQk4Qpb9gQOhZ
	lzkLlIKhB3Zovbzj8jCzhPQiHV/OGJb6LPtJypamhY+eb4VX/JeJMplcCQ4CFVLWfi+CZL
	8nqrrkpgaPEQo9txMmjSGKJMkgtP7+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778288249; a=rsa-sha256;
	cv=none;
	b=K3Vy/xE+CAPxXpOlsQ110xhY+yj4B/O0pHT4awYLi18/KdtAc8biV/AcNbKPpB3X9uvNdE
	6HW7/GeaWtynAcW+KRkasaIu3IGf8c/MLuMcANKarQM3BaiRzjvqoNV6ruQpABXQecfrtu
	rTWsQEg0hCjgAykZnmZK9L7cnDSycRE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LeJ2zIJY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778288247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pD+nxbDFKBRIVr6vnl3tCVeWtnpaIBk5Z2HqW3vTtaY=;
	b=LeJ2zIJYOzcHEaRxAw2nzgaqb+fd2XmIDoc0tiBe561WpKjciHaVjnk+8f9FzpLiuvHdoT
	U/I8mzU6c7wYdctZTeiZMsFHOv8lvP7gyV0RrUSBPP1R9Ji6cgZaX7nf1iUlUn7N0d1XaS
	SNdesm4yr8MbYbcBfWOZVogSsiBaE1o=
From: Hao Ge <hao.ge@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v3] proc/meminfo: expose per-node balloon pages in node meminfo
Date: Sat,  9 May 2026 08:56:31 +0800
Message-Id: <20260509005631.17183-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 818CC180006
X-Rspamd-Server: rspam04
X-Stat-Signature: io77w31qdwehoe8wueei5oeeznjp3c1h
X-HE-Tag: 1778288249-640568
X-HE-Meta: U2FsdGVkX1+z6bUh9QRZasmTmmcOFBlA7Q6qFBw/Qcv8aZsRoGgGFxgepso1DWf0zVe9jApDk6ixiLGHl72RJpcexntxpmEO4YbgZoMF2lsCl7uRPJUqn1Mc1uoACRSlzWUIC6/jwmFZ13O9O2mRG59lj+ELYDPpwfND5AdKjFoWsHSO3Vo6b15ZSWrFonRE+LgsrcYdViISK2bga1/q/DJESBLCQOo+6Qj0UdLJcaP+ecn47rb7MItcrrQgL9Z/QSTOk6UeX6UEPSMjWtyxLam9uKdSOktUjeI7dLlnYvFi4rAuWi+lefPy8mNbv0a+M2pch88/qxaXIWozDw1naIcMVmGIqAhNNQpTz/EXpf6qnlvO8PIux0/zvN5FrmvxmQJ0kx+JPuNcL1XtQPdilfcixJSLxPfQtkUmjMIoteaETgtQPgE0icLCcNqTq+tmpUTERQrjxO7VeDHVp0imn+62QRnDQxeDxRhiD4BlOB19WPqlYOeUhpG1Op8mYB37/rmOzfY/qQQhYRZPMshWwq6qflQ51f1DYZK8eQEgY+FMF9mdaJVSlBViYN5HzGMbToQBo2/n1S+PoQB/uCgStmaMAe6xXmH7OTvfrkuaVxEwabZX/nDY/oKTshTk8qiGsYWLpBqUea55lbk2Cm7jAUVEFw6ga9T9Cn8nrL5fJwLWcUPB3K2S7Xa7ITTimQBZVrk1OIS/PSUYbacQXZ65X7M+DaS+IOshfkMmaSt21IyOoIL5/jHXfOXuskQnaAZ5zqO/acQkgPXGbWzFIp0vVYMCubXmblTpR0z91Hcj23OP8Knmvjk435nnowTjnSkXNfRVcQdLv1KuXaUWgFKIg46UXxGOEM8FCnqZxFxO3Us7ieuxQ/bbnPIT8ZqXsoaBtpRml7ikqY5vd/x86J91quT/eq+AnUpOGgHnopAUxnuDOXhE/yfOCteV01eUKtGgsoAFgnN9msQGcXwcW36
 WJnvmMd4
 z+v/Mw/UZwjw0Qk33i5EReozVk+NId0uiucxipTDQTRdIGePlUIQfAoVMFMDK3A2+kfLUwJMhnuf3anAxCq40CS77pKEh5dTdso1e7cjBgl64762e+9pZ1omUEJUW0ownYyQZTr+lNWYm41fzJWT3lhch/R1in4Nd+ZlrvCdzlkcOUXJJXrNxZXaMyHjcXQQhJWFnHSwzMaJRhB7ZnxSm/ktl5oVL3gJ6aboW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
However, the per-node view at /sys/devices/system/node/nodeX/meminfo
was not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per
NUMA node without having to parse the raw vmstat file.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3:
    Rebase on top of 2232ba9c7931 ("mm: add gpu active/reclaim
    per-node stat counters (v2)), place Balloon between Unaccepted
    and GPUActive to match /proc/meminfo ordering.

v2: Move Balloon field after Unaccepted to match /proc/meminfo ordering
    (suggested by David Hildenbrand)
---
 drivers/base/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 126f66aa2c3e..f4d9a21cc24e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -523,6 +523,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
 #endif
+			     "Node %d Balloon:        %8lu kB\n"
 			     "Node %d GPUActive:      %8lu kB\n"
 			     "Node %d GPUReclaim:     %8lu kB\n"
 			     ,
@@ -559,6 +560,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
 #endif
 			     ,
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES)),
 			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
 			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
 			    );
-- 
2.25.1


