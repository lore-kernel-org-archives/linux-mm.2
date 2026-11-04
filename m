Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013EE606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Faz3ZjK2
Received: by kanga.kvack.org (Postfix)
	id 157FB6B05B5; Wed,  4 Nov 2026 08:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130026B05B6; Wed,  4 Nov 2026 08:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12C16B05B7; Wed,  4 Nov 2026 08:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2CC56B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:01:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 384EE406F9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:52 +0000 (UTC)
X-FDA: 85397448864.15.1514103
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CC031C0014
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Faz3ZjK2;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5JDyfdMkj2wCtOOfN649rnZ+9k1JAyMoYfLCV4c9D0=;
	b=KegZE0NzW5jDBmz69eMqsV+DKt4GBeBmcET4aVAiRFATFYk6dYSb+UgP5JG8NxgdFRzRk7
	d8k/R4gdhKOoh0U/LkhwxOB9o5OEIWUrLwTLLzvzGe1lyrBQx//UP5l8bnb0Vm14BP9/JX
	/URWBKU0i6ejVZt/ICfwUatSVpssZes=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797310;
	b=LQ1NBt9IJuAayzyTD3hDpBHkpmi+uBznOMstdpkU7QcU2ZtBH6lRa9iIqTnq3enBMu49GW
	1BHp/AxOxdZ0m+tDdNKDqt0KU/5IjzzL1IhYfvls/Q2GiXv3VaSG3rmMTutzEcRZ/CSAwm
	n87ENdvXbzYC2nJIaHGfmTqd1ejUXpA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Faz3ZjK2;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6ACC60F29;
	Wed,  4 Nov 2026 13:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375651F0093A;
	Wed,  4 Nov 2026 13:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797309;
	bh=I5JDyfdMkj2wCtOOfN649rnZ+9k1JAyMoYfLCV4c9D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Faz3ZjK2Csai2VwqGdu5cZgm1R7gHNhAOvUatxXst7kNVDGJtMEIlR04nRTkJw00o
	 J93jsV1xz5rOv0TmN56RwnDBl2DAjjL1JGlbXV38vGVlt+uGI9bO0ags6GCgIbPIdj
	 LC9efBKf7oBCiaEcae2u1IyA+KpVgXJA5vWw9vBiFBtNBtNSwXFSNqXjYc8JkYTAQV
	 fKmejEOKaozskhfLf044dCXODEMfKizop4ijrC9HXIMmUphSa4ijQYYdacyGAvdtev
	 AP9I8ZusXEp1DjbEm1Iagq1oz/0kKnPNjp3hG6xjCnDyXsraG+HVTxX+kbEU6aSaJ/
	 0b8BFmpDKpBJQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 11C551980054;
	Wed,  4 Nov 2026 08:01:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 04 Nov 2026 08:01:44 -0500
X-ME-Sender: <xms:tCzrasLnQ-6aoTAivy6dIwb3QAXiDgsOwkB7XNibpfHeE300IgzEIQ>
    <xme:tCzrahYN1w4j905SN3NhF4jplVsHNsXUlUc5JnqlrL7nOXX3rrLDNn6YZPutix5ri
    D1SJErl3C5VDQDAvUmssApnUGf7L3krnoy3BZsPIouzDdrEB0m8L6k>
X-ME-Received: <xmr:tCzravWl5s_fXCNZi1Y-t1CAFz9SGWtnNx5qTk_tp0POGVoUrk2uCd8vxAI>
X-ME-Proxy-Cause: dmFkZTGcnWxWNdwzviArTqwO8SleswujEAoF3G5cAnzgWuj9VIXYzVn8L/YtSSoCVpDQCx
    AFAjkaMBKJDECegKseyQPi3BoJ2ULdzgEWHQh0kOOdV3qcZ96T5qYw8zvnYBduU6y+7gOl
    ju1hRqdfaUd029Zpq0M1QKVfvNYpVJXA03mIXM/FVYF2n1TVZdGxcwDBil6kVRafbiJtv0
    QuPNDwYksKVrYzT4QGS7HIxmz8ayVgiPQk5G9zoQji1nSBMTr/zV+0QH6w0a9BT4L54N+d
    cRhB7KhKgiZgmWNJc1G8l9d+gvjQ75B75nEIsy2loqzEXGvtqjUcmfJ5UhZu2fDzNX4RJx
    MXTgBiPaExnSeSGdTd2uIQPIf04/vV8GeZZGlCpJD3MJZYqa3/ilpSwupO/6D8DuMuVdgf
    lRhydXCQ6Xa2S+8DXLnkhoRuc1AjZzapOvhFIm7zq8MW9dqCj5VxcPf4OCv5NvmFJ7UYZ2
    W5KDa8ES6KsPHniHYnWGGUwJ2J4K/1PV1PHsiPmmHvenRB0ZPoybQ89E0SeGb9bommOpqP
    nH7w/zl3rKWJgnqBtibtcvEVgCGNRaGZi5A1a5NqGqAreUQOZZ+flJMakBeKirePoTtvdm
    jmXr2MmwPG2xEc7XfTnFlMnp2TzDvQD9nw3/qiRcvcRcLHI9+hkvlT78GBIQ
X-ME-Proxy: <xmx:tCzrapHj8fNK7yMBcpF29XSoU7Co7uGuP-5XZ3IpQ9GIsIXoWSQu3w>
    <xmx:tCzrakC5Nm0lKtJYDGNGsLNIOv5n9mqZVigJ3V2aszFgd3UQ5JQEAw>
    <xmx:tCzrasVyFTfFltq4x2-saDnpvghTxCZn5zweaKj3fmmbIpygVzC22g>
    <xmx:tCzras4VW6TSobJGmtOJftnDT4qY_mRwirpxa-3AhBFeorfQ2rWlCg>
    <xmx:tCzralGiIlFvyC1gpv3jZPsZOa5eFtYPy0MBq-9V20rRKnakIHq6cEMm>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:01:40 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 03/18] fuse: don't move a folio with PG_rcu_free into a fuse file
Date: Wed,  4 Nov 2026 13:00:59 +0000
Message-ID: <20261104130118.2507513-4-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: krmyfboz19p87wug6uh6kc1wk7fanuzx
X-Rspamd-Queue-Id: 0CC031C0014
X-Rspam-User: 
X-HE-Tag: 1793797309-296656
X-HE-Meta: U2FsdGVkX19gBc8q/krfl97oPi4u3ALSrQyNbVtX/LuIhTeM/7jKVGKTEnU9PZXB7/13xMal6mft9umUtsLfRxZqj9HMeW6MYP/JftS9R3Tso4tWVaobc6R/MikjYHwozN2aILDeI/J0FpFYAZEqcyr8EpuKW4iKMsMVf/s+2LayRD5Rl8CiEZQiGrcv80s6Dhsz5erXzAF2HQJmF5OsUMGuDodmLOQ3eXKmx9nhh0f2KNxOvbQzNPN2nZVkJazvJBCZyXDkVBH1FiRf0NeqZzSSD2lnckIJ4y5LpdQJ+RvoJPWd7tfSiqpP3MXeZgzj1p16Y8uRTC6eBVjmJefTm+Tad1jPqWs4c5CX/WPp9oA7migV/sp6dpgP0k06elVF9IWDFK/CJC6YBt91fqnmRfpQsSunQq1jfAkZAY6PH9lf7NoTh15K1j6zNscV+iUxNYeVGKRBgyVb+SyxZzAh/taVs52Io1qhEwzDnUI8B9A1nH+L4dI6l6xUfv8RmSxg/pL9Ha/H7H2jBIBlrMWlxnbS1ndukkzP+KwMHsVLF/CW6U2+lzLxrREleltuefCEyQvwmRygc8xSx6xYlSewq+ghS75HbTvBxkdhK5UofxsgTgJNCKreEgygUOgRbAZhhGFzWV2OBvxGXoFdunjoc6lWtKQE8S5J0xr0O24/avLQa/wgKdOCA7aj/FBqQ25RjMESLm7J2htk7KVxG+q6NnMRUTvKmx/m08/yNmsQR2hNzkwDIzmA6eOKCQAOAdMjHLUGfZ7fuPX0NlFZCJIwVhfqOwpc3KcamznID6DX7XtRxzUmWg4Q/+deUpflnKZZxplnELzwg3INeNprEX03WOSmj219Sj3USMlMpRCotUz1DgPZGk76bfQr1K0lP8HCGESYfehgtTSDEyFNRvT/SvWCNacDNWCM3oJDUdPTu0KVs0TBuj2exLVxAC0XjnnnWQhX+Vd70iLbN6ExjWk
 oM6o9YKa
 Q2drHFbtN2kHL+KYzpZZXEURn1Tm3RWQh2P2gCWH8l6aqL9sDRLoxYOAmBhAuMdF4BiP4tVRwt72LOiYmddNYWh+Z/Oe/bBay3GZdmQ+E8lqRfCc+JPORiiA6do4kRKIRKIbXwY103NcV0lMA3ZD20X/YxaP4A9XbZ53RQ5vyy28nH1beoS4ZeviL0XbwSjKsGF0iytgBNELXJEW0tIFY97Io6O2cLGIEGgEGCO8JwWw3zIOOTdeyYEt+dxPO0ruabr5R6QCZPOrxrgTtFjXJIHfbDEUQhm8bT2X5PO4VvwLMvTpn2qJaJOtCms8aU04Pmoo0oaY+Y6SLy8fc2tMaN8AtfD6EJVj2p5F7vSPC83RdDYXSAtlzhbpDRffVch2oKuMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fuse_try_move_folio() takes the folio of a pipe buffer and puts it into
a fuse file, where writes change it.  A folio with PG_rcu_free may still
be copied by a lockless page cache read that found it before it left
the page cache.

Such a folio reaches fuse when a mapped file page is gifted with
vmsplice(SPLICE_F_GIFT) and its file is then truncated.
fuse_check_folio() refuses it only because the flag is not among those
it allows, and with a dump_page().

Copy such a folio instead, as fuse does whenever it cannot take one.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/fuse/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4fec31fc0b84..526929c7b3f1 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1152,6 +1152,10 @@ static int fuse_try_move_folio(struct fuse_copy_state *cs, struct folio **foliop
 
 	newfolio = page_folio(buf->page);
 
+	/* A lockless page cache read may still be copying from it */
+	if (folio_test_rcu_free(newfolio))
+		goto out_fallback_unlock;
+
 	folio_clear_uptodate(newfolio);
 	folio_clear_mappedtodisk(newfolio);
 
-- 
2.54.0


