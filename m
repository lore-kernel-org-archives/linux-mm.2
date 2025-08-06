Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9992C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368746B00A5; Tue,  5 Aug 2025 20:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318A16B00A7; Tue,  5 Aug 2025 20:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1E06B00A8; Tue,  5 Aug 2025 20:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 062D86B00A5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:11:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C54195802F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:59 +0000 (UTC)
X-FDA: 83744402238.06.16873B6
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf01.hostedemail.com (Postfix) with ESMTP id D551540004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="T Hl0uyU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Xc2PVzhP;
	spf=pass (imf01.hostedemail.com: domain of boris@bur.io designates 202.12.124.146 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754439057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ7TZBffuEffDJUzZyM4ZUtL9XNWT9f5kOkVlSi+KCM=;
	b=os9iHdMWsMKzNSXIIXzwiiH8WSKHqMhSkAtERihbrelVTFsrZv2oGpr/Mrkraqw3UydxuR
	TSV+uoImSBcfHhpkIBePbfkcAxlb4+eNDLRN4LQXcJCYcXxR6dvcRmCXRzgIZ9NaHKcSRn
	5T9hhMVnhKTrMAIdP60v1xUL9hkSW8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754439058; a=rsa-sha256;
	cv=none;
	b=4Srbxrkap0TbcyMrU7QUONvurEVZdQmOv4OexyU/1318XMITz4fU/JPiipVQv2Bgy0gHuY
	dhoaZanIffc6nOlFOOnI3AXQI5Z1etG8viFXwun2Z4qRFxlbJJuJllQJr+eSiZhand43w3
	7MOMc3xM29YYdpWhE1PZW5QVjL7q4o8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="T Hl0uyU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Xc2PVzhP;
	spf=pass (imf01.hostedemail.com: domain of boris@bur.io designates 202.12.124.146 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id DB23E1D001BF;
	Tue,  5 Aug 2025 20:10:56 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 05 Aug 2025 20:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754439056; x=
	1754525456; bh=NZ7TZBffuEffDJUzZyM4ZUtL9XNWT9f5kOkVlSi+KCM=; b=T
	Hl0uyUDCDWHd33pWZ1uMbQXhsdRRcJJRrAH+g7B4PkT9ObG76RBgGWKHwNCsHFk1
	mkY58O/hpwpjdnzQnAp1ISDsIamu04TPsI9iQ/s2mGs7PnapMq2qvJDouu01Wcft
	33RIVS0+vPZGM3hcsxM6gFtt/vo3hc1c6swjB/sXE/lBUB8xdBAAlGbuq4aJDCqi
	OuFgJkTrCKywpNePty+6N0qUWfQFkVE9uuFJdjaqLbDP83rukrndHvWBuBBeQ+e8
	af16q4YCxT1W0B23byonYVTvJDuXqrPoUwjjSSKFANlID2/t0DPyb646KFA+k+qy
	75eUdIGBE7A6V1gUQdWVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1754439056; x=1754525456; bh=N
	Z7TZBffuEffDJUzZyM4ZUtL9XNWT9f5kOkVlSi+KCM=; b=Xc2PVzhPIXXkfThYe
	SbPQ9DRZprBnldpzeRw+pnm2rA4LOa+OQyPbEO9M59wf5c51TTJAmWFqQB413zEW
	fvMsdfGZljbcLkLOu24PWcNZ60uZyUfSMTpVeKLl40RaV1BP1E9ZKTvTqBtxXd01
	Fc2j3/luXH0KFE88eAOF20zEntBSeU4cK5btBhR1xYYvbmWYSOH1lTIeIuyUrP0/
	ICIpwXgZhEhHRl3Brevhp8dpuqhCzsUt9N7oNsORTYD5o+TPf7jY+WsXUoW9CFij
	yORn+tMPcbfRwkdVqddCtjwXlp7OiSKgXCnK5hwrPU1AathgdYmOvttQzY0E59P4
	8IEwQ==
X-ME-Sender: <xms:kJ2SaJA_7H5wLX-S1XGsDNrBtZYsGidLKn4anpyHGWySGEU1lTa62Q>
    <xme:kJ2SaLVEJwxtfaHZJP8ZxUURyOkdqDeFjAZumzSf9J6KdAPuihYsT8LC6fAD-ihe_
    CFax02rxCxQIQvK0UA>
X-ME-Received: <xmr:kJ2SaNo-nBOM5ZXi4JixsW7h3bVcEKlzh-ILppwnKti_lDSaAvDw_zDFzURFeOV26KoUi2vHbB2fdPc7mHJZ6Ap7RWM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduudeiheejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepgedute
    ffveeileetueejheevveeugfdttddvgfeijefhjeetjeduffehkeelkeehnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlh
    dqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslhhi
    nhhugidruggvvhdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtg
    hpthhtohepfihquhesshhushgvrdgtohhm
X-ME-Proxy: <xmx:kJ2SaHT60CohRpcWORKyL9Dtxv3cnBo_InPO_khRHvlCf61oQh05SQ>
    <xmx:kJ2SaH3WVwUkzRf2KHBb-F9W76aG6iU281gy_g5xmdT-8KYemzxaGg>
    <xmx:kJ2SaDBf4-WuHmUXbw2JQsxxkOOtSGkNt0x9kYQQn1HFA8Iba6Uc1A>
    <xmx:kJ2SaDjFff54Aa4ybzJxDv0RQhEnRw7cABsAU0RCdmAmGrz7aa-i3Q>
    <xmx:kJ2SaKT4L7eQKJhUd-ZuA2qMn1M36aScMBI3hIDGttEaYvzCh_CptYIm>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Aug 2025 20:10:55 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	hch@infradead.org,
	wqu@suse.com
Subject: [PATCH 2/3] btrfs: use filemap_add_folio_nocharge() for extent_buffers
Date: Tue,  5 Aug 2025 17:11:48 -0700
Message-ID: <176a4973304b6c04c9a85f5f08a03d1e90e30d82.1754438418.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754438418.git.boris@bur.io>
References: <cover.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D551540004
X-Stat-Signature: c77o7gpasidd1h4zoh15c8g46pq1xpbp
X-Rspam-User: 
X-HE-Tag: 1754439057-186058
X-HE-Meta: U2FsdGVkX19j5S08xGcaMQo5vWu3L7Qjk75pGpch4txi0C1ZvRxD4xTyWqb/k6WG7raGMCuqRP4vn8W4Ho3iwBt+TN8FieY6GMVEtXLUtt8ed86meaNMs13mMDfWk3Npc2ybYEIYARCvilHOIBpptYtLYZxYXOpg+sIQ5YS4XKgb+ALEunZ/IEyK3ncAFY/NQiiXww15NacXAYe0xLSNbdfAWNdopnr3DjSxQndB/HsD5fr9vce6X7TLAiDoLd7g3IiX5oZBc4TnrC8iTQxvI+1PEZmNrOHkomGjQc4wQdYoxJVnVMH7FP4cELohqPAF7g/xaL3nDTuhyxQJ1GqIgJ+ZuGBDPtQ50e/Gbko+yb+XiWNAXXqDp7LPIxQFWXyPb/JFdrv2yib732OIPYYJHMr4ewAHXEhl0/nQQiQ02OZn91Z5GmHx6HLy6+y02kYTgw8NjrN0MBzKKFRK2wrqG1RUDK8xTMVMyO/DHInB26pb3LVFciK9bu2ZbxRYcIoCz5PeEW7pVF++DPL76oUNwAwT32wfJ3kqjE8MXKPwRnPVymU+vdbtCbyWlUFx4846N5unlmHuXra+6FkdmofqIcD43von7t2nkuzKgY+tVb2QMPL2v0MdS4roK5MLe18tQpjZYnwW01JkjII4F6uvYFbN4mYf3M5jkCFINRnnPTZ6GJMGR7DilWfoVtCzriNQP2O+qm2nfsaDsnwX+zXLJLHxnTbJ67WiS0zI87SB81Dsl5kJamIoLoL6X9puqZ0wKU1ElX5LyAl77qwgqcRDbVThnQImDZQ9TYnij2gvPWcIYg9wHUqSF6PerQKDTCFGvi9ir107fAsi1iKQaKUp0THTR7/a+PqJ/dYvC7G6FcRswDd5yRnzddU/FRr6zn0u/4oUhaoidAiiwidr7EJbL+tN4Tj33j+JCaRK+0u2izBeRAITQcGr2AA2yZZ06uybOfe/taG1Fz50IL+9wv+
 fNTq7hwP
 cYfKelKzq1LTAqwFw/blYwb99zleyD0j6+CrziJVGMjnRxgJ1p0MmiQk5X2S4v8/FCHSOgq5RADjxlyeAlcr+xLga2gwxjra0cSlmx5w9pyTb9DjZ9Z5hx56kLFyNsA0CftbYC0Xtxn5Cjzx/v1f/ae2mbUk1lJtUvvYhyglfuTxmTCv7945wvbzwqK+2MdHJ72yT+r/04cGo+uCx5yhtG6E2kREAbjaCff4gX/8z13LwUt+UcCnLAO+nhruJyAwRvTHS90pZiFGzKb18BdyF6HzTWX0t6j3izIQMCZJ52iKY7/p4fM1PnwK36QWDGuWup21Ez5XDIw620F/3EQgI+fV/AO+3VNxL3EXDPTTXa6O7hIY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't block on cgroup reclaim or subject shared extent_buffers to cgroup
reclaim.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f9ccbe5a203a..1f25447f1e39 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3258,8 +3258,8 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 
 retry:
 	existing_folio = NULL;
-	ret = filemap_add_folio(mapping, eb->folios[i], index + i,
-				GFP_NOFS | __GFP_NOFAIL);
+	ret = filemap_add_folio_nocharge(mapping, eb->folios[i], index + i,
+					 GFP_NOFS | __GFP_NOFAIL);
 	if (!ret)
 		goto finish;
 
-- 
2.50.1


