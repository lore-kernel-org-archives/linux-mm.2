Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEC9CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F1D6B0005; Thu, 11 Jun 2026 06:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08BF6B0088; Thu, 11 Jun 2026 06:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0B76B008C; Thu, 11 Jun 2026 06:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8873C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:51:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30D8F1C2286
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:37 +0000 (UTC)
X-FDA: 84867315834.06.BC82BAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2EE4C000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFJYVtwB;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781175095;
	b=G9fILzCNnxzVtFi7goS3AxmP3wOfxcW8s22EYmYeLRd0/7nixZIHGlOU5s+wJ/VBfC/lnG
	RDU5nIAgampiJslDEmPCP7JSBH5P67lANrcCMmFR03FAPz25QebIAOEQxPM2PBXiVUMlgU
	Yj1Z5XizlJMV3qtKoR85kHc0vHWbekg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFJYVtwB;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781175095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rp4x1W2aaSXSOWAvb1ECGK7Mj6f2q5dWywK0jlX3R/0=;
	b=gL4hA5etMwl3BmmdNx4FHZGM65+057evQfRzGUBnAzUjx14e0qtlODj1PSEhU7SejojGX5
	h42z6ZS/bB6MHot/W+2Megh4T2urqY5rPM4GZ+MUhZGZMPHGXdaOUaqu6BptbgnD44A61W
	RiGJj6TXSDXP5U6ZtD/WOFaqnjYIPVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 435646020D;
	Thu, 11 Jun 2026 10:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8251F00893;
	Thu, 11 Jun 2026 10:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781175095;
	bh=rp4x1W2aaSXSOWAvb1ECGK7Mj6f2q5dWywK0jlX3R/0=;
	h=From:To:Cc:Subject:Date;
	b=DFJYVtwBXfYe9uyg/0bHusYw5TtKQ5QnASLgQG1otjGAy3ixDyXm8aH+KBUruvYS1
	 3D3XJaHo9Qj4L1Si3WEzsDmxNMfaOt1ug0KhYQdaCQhOLLP89D9jiTDO9Pd88grZzu
	 kMRUljzHrqtJa2CMDnbX1+m9Lja67RzDVpYsQspPTIftgrqJlnrndp/ZYpnvZ2ZhiY
	 1yJaIZ4wxtWT0jhBi6t6t7ydLRTKTC7p8k5l+Zd3t7HSHNw2OYsqoQGCglpr2jceX/
	 G21sbsxvhQrHmNIdvMXzE0WXGZk6sufS0HU1I/o1knq1R6qa5/DgIY9pm2uI1meAym
	 wnLCMvmKunxRw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	jp.kobryn@linux.dev,
	usama.arif@linux.dev,
	shakeel.butt@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 0/3] mm: drop redundant lru_add_drain in anon folio reuse paths
Date: Thu, 11 Jun 2026 18:51:21 +0800
Message-Id: <20260611105124.98668-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2EE4C000A
X-Rspam-User: 
X-Stat-Signature: n4teo3udnuioqcekbxrm573ghen7aiht
X-HE-Tag: 1781175095-205147
X-HE-Meta: U2FsdGVkX1/SF4flmgdM7zBc1Thqf3GsHqvyMVttS8ImQHjyQnsRGrBEyayvtk+JlT+BAStCfuN3YekOj+vbxPEgVhiktODb4tYSzp2jh0T48WA11dRZvRBEMaJ4NEUVrHVKXXtbr+e36QZML5bQzDToGMalI24izMzW8gkxwQE8LePVaKNEl+R9JSyxzKltFWFlYbRiyw20DisMHltdBUZDvMBZAGiPGoFVBuFxIJEijMRfhxjSJj2i+jSMXBx1WkdDviBi/ux9X9Ttg4FMRF6WUo7JJtDomnNWcNdpwpb0TUc+kmwsXzJOiacTUBN4UwtJTMymLAjDyxY5O/PZkidSzc9OIUyPW74kq3aoF8BnrPioaBdTRvzw2TpqFXeVrlDl/lX3TeeCt0u+KXNAQaYHvWTcjXoX1mfPqsgMVIIPEob8hY0Pwm+XAWjd17UuFoiGUflMxGJFhuViDI0ChUtnCRg00G5THFjOJsSW2W9m81FsqWkMNtULUgIdMRk4JNJKquQL8r7ah6fw7dy4/p4NKxyFz8RzIjrUut7KxXShP4BtAggWBnwIzNtuba9gxXxna1JQpixbZgbfZ3crGBzpqAuinMADLKKp4+yxmC2L7Oryub8FYAuVNU75eKIAgsW24QrIdL3s54EjWQKrgJzsSzp2pQKtKijsydxD353BXPM2nJkrgIRvSfVtIgmXH8zbGpkSacvAEgo1w0MqOvpKJPDdix52MkhvHmGsKwY2qtZYWmnIpHvHOo9zKUn3o93N5/iRe618fheP0jXOjBow7W72DkUl+Hwzeqz3c0Ja/Xrd4PHt+A1DkPbVW5njcZ+fRBWJ3DdW9q11rJH7a2ctGgcC8RnateZWd1KRpelkyTsPAFv78CUbuvfd7e057335PC+6iRdE28j2oUdyIVczW9/jqXvRp1L/T8N35w4FKnPxiaebbnKVyps2+lTK7yl1GNr02t7ZS85zRLN
 LFc+Xdii
 S/h7gw8UmJ+N9bpuiQ46gEN/r7/1if3T+LGMaP4pZFlWfZEFYdWaVqlmnHALzYNeIqK2uxAWRjg7+z4Wj0Bow5XFVWB3kJ1dPtoPpIKY2p10fbk1q+YHeoko7d0EXMB1iOm1hIHiiuXYksL3rS4MTROiT3YMJubsnCZkpxPFdcqhUdKm1j1dHQ5vaq/5iEn7HQWo0LQGk1pO4scOcVNVDk3pdtR8XKZJKm1EyX+laGIWRaq9ddkn24wCNf4dQNHrGwfy6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are doing a large number of redundant lru_add_drain() calls in
both wp_can_reuse_anon_folio() and do_swap_page(), leading to LRU
lock contention and unnecessary overhead.

In wp_can_reuse_anon_folio(), we can check the refcount against the
lru_cache before deciding to drain. In do_swap_page(), the drain is
now entirely redundant after Kairui's work to route SYNC I/O through
the swapcache in the same way as ASYNC I/O.

Build the kernel within a 1GB memcg using 20 threads with zRAM swap.
The number of lru_add_drain() calls is reduced from 276,787 to
230,283, while sys time decreases slightly from 3m40.125s to
3m37.128s.

Build the kernel within an 800MB memcg using 20 threads with zRAM
swap. The number of lru_add_drain() calls is reduced from 796,661 to
537,262, while sys time decreases slightly from 6m25.981s to
6m22.678s.

Barry Song (Xiaomi) (3):
  mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
  mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
  mm: entirely remove lru_add_drain in do_swap_page

 mm/memory.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

-- 
2.39.3 (Apple Git-146)


