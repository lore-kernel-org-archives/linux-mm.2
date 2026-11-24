Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F42606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VEnikg0D
Received: by kanga.kvack.org (Postfix)
	id 0FEBE6B0611; Tue, 24 Nov 2026 02:23:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7246B0613; Tue, 24 Nov 2026 02:23:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0140F6B0614; Tue, 24 Nov 2026 02:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4C016B0611
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:23:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51ABA1C45A8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:23:03 +0000 (UTC)
X-FDA: 85469171046.10.732892C
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf21.hostedemail.com (Postfix) with ESMTP id 401A71C0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:23:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VEnikg0D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795504981;
	b=rMK//PxpAIl+UYgljWqCDhRRVooEz7zYJzSUN1EClKcHOBfpusWnCxG5dYjmglNuKbj5hb
	n2X1WwQRkMdsOZum8E1K7/jk1NuJ6B0XKR8bAFBFlJcJS0D45/s+GYshyOIHOPKScSxh//
	1TudmJTw8DA6RWKraxj8VkOC9HCCs2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795504981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odIfFPrdTppXORcPrXGJMuPUFBc0MW2R/PGPymL2nO0=;
	b=R+leAFDU4f4e6EL7+gc5veRzJ1/sZYfX/HjchiMfFKLUxXx+PbJMJTU4/fUpJho6SLe4cy
	sw+TUCIs7rpm4wMOF6qLFgvDIJUA77n6CnvoNo7v+D7KkpBGLE7rzoDJSLjdUpNIqTx5IJ
	sT1oJ/tcE8/8JwxXXT1sZOGKd4B3hO0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VEnikg0D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6d+T1Q2c9FHX8B+LMfN0aHrDs83MDXu8GpfanTert7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795504979; v=1; x=1796109779;
 b=VEnikg0DrsJPoVYMNIHsiw2mJJbQTdkJLhrMJehjMyVbZVxoPvJsNzec/pCnwyTX6g5pfVzJ
 mAf6RULM0SWrWYdpCJR1i6HK7wwMAbCWuwEnzw+1CyAMaznO7KMUVdjWAwbdGC3IZi8lUrX6VRQ
 sYaMBZqR8zcSJ5czN5VAAwgU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0075ab77b34cdee3;
	Tue, 24 Nov 2026 07:22:59 +0000
X-Mizu-Trace-ID: 0075ab77b34cdee3
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 15:22:47 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH 0/4] skip empty PUD subtrees during aging with a
 PUD-level Bloom filter
Message-ID: <awU7RzHhn8FePuf8@bogon>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 401A71C0007
X-Stat-Signature: qc7q11dgno6z4wfirt18osjsygcqf7x9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795504981-22379
X-HE-Meta: U2FsdGVkX1+qQgaIWkb7KmUOEfqaql/4FYOg1g4xrC3Ll/s1YDykOq9xqH1qPfR2QiR1CrSMYuMvNFg0qLNdh+bj3B8Ijh7EEaHaOHdTL7+4FnBbxP8frR5WjpvS4P9SpGVPG9+Iv7ar2pAfcE+73v/HaH9h0QMkJ/H3DTq3dKC3bTBTMkgOcokep216D06v45I4tXzXa0L4AEZFGGqDbEO8YKhzbGrhpl8wW5+Ox+SwvXHmDVHXA1h3fxQTzlzZFr68k7o22gxa4lKzTVs6G3lA6dRM3f7oepGGDr8o1PFLHJ394xX/m05AjCkepMQ1OOIiVW0Eym28OiXLVQAi/iEmq9I2y7S/yQ1HBufhUEhNCRyiTpVRv9hVKLFIw5Z44dw4v2OUktR/FItPBx3zrPdKuSEHdx9cMs6SSlBRXcBTozH8TpT/QYFxpz4Qo3kk9kBdqXc94bWMmXfB90DlZCws43+CyXL5R/YkCxByYp9cL7xRctlybzoKd9FfOHT1Ivw89GENFmvqhcGLgTwCRhHzaIggqCn2zrfryGifbvoxmrlTtlR9cModUaWlt46AXK/676snpCo1HNLCo78QJmiEqDHGk/NfXV902knr/3Dg9x7kGiIexM6PQPAkT6ZCWEP2Iz4VUjEAASDR90LJxgtbvQJWT7RfaotaoryObvbfgpc1nyNk3w4YeF//GhLmKv24WG1Qs6jDi9oSw/c+rFjzuxi0s4wl8f/uy4Y5H4ahr6bMzUw3ymvBLwPPBEJfVgKGs4E70/A90LTajkyVKY/VwKdDTGN6jWapj6rvG8fXzol8QVGv3Gqd8RxxVjxTTsVlG0Xl9KEx1WJsbcu4PI1tvJ//ak/WaCSxhiDjZ1zBR/P0SCZxDfE6sj8isOrZ+MG7A/9Olf7N5e9Hl8jj3FIKeha5TzW3dYK/Ah/JQRhGpELHaFZpP3MZTI3hWpHga9vOFcr2FvRGWnSx0z8
 QxShwFpB
 K+0MXw0FMnlqSnT0YoExHASQvRucxpWFieWdK7cmp+Y6mdsml7vhQn+dq83a6ZXHIcss4QUY1lyH6E466h0wdVKGT1o3mz+2wHc4G76nc+fqNWlRDv8WJ3hxGT3I7tP6fJ34hVfyr7oS4crcaXi2IPlY/uSzmfqTNakzqGP0eV2r6Ek07zjFP/ph+8wze3Fwl6ZvqyQ7wTJIyRivZ//JeG5mB22qCI19S1wY6YLl/xCNAsYpiUn0zjjO1QFQ11NTyScP3HyWT5UqsEvUWrKZIOcPCIdEX6wavQ8F0KVj69KQwzXE9FA+j3pxZVS7omDZBAnej1HxirDKcA0Jqmqrnv3tsGiaXMcwLBST5BWoN2bbwqIx08GH3FKWGsMTaeR/nruZS7YGhLlQJ6reNW/GtaNhsKRSjmLEUKhBUUGyk0PvdNRdSBX279R8Kh9rchuI0bIHSpfPGSJzgXFzrj2JNqwQcfyicbKfAy8hs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 at 04:58pm, Baoquan He wrote:
> Problem
> =======
> 
> MGLRU's aging walks every PUD of every mm in the mm_list.  For a PUD whose
> 512 PMDs all fail the existing PMD-level Bloom filter, the walker still
> descends into the PUD and iterates all 512 PMD entries.  When an mm has no
> pages on a given node this is structural waste: lru_gen_use_mm() sets
> mm->lru_gen.bitmap to -1 (all nodes) on every context switch, so the aging
> walker of *every* node, e.g kswapd, direct reclaim, proactive aging walks
> the same mm.

This is v4 series, I forgot adding v4 mark in subject.
...

