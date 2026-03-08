Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD64BF5513C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 11:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD7F6B0005; Sun,  8 Mar 2026 07:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B916B0089; Sun,  8 Mar 2026 07:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597466B008A; Sun,  8 Mar 2026 07:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 457306B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 07:03:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB358C3323
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 11:03:04 +0000 (UTC)
X-FDA: 84522608688.07.2EBF62C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id B810C2000D
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 11:03:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772967783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dItoOuvfLDGqHyqGTKLW6q+r2btk7jU8ImqoQ9EzJK4=;
	b=1/2n9JiP9UfKixiSTj0JF6ED8PWiq9Gr48hVvWmCPHqiW/DNqG7vPbJ9sIJP3tohAzkPrx
	L9URViswmRrYTdgsUEc8w9esJUwAqMa6z8mNeco3HxWSmpzSNeRJBBRdThGG7jbdz85ou9
	TGbAwI3Sn+o7BU8oxCJgKIk5gOGT8MQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772967783; a=rsa-sha256;
	cv=none;
	b=ucEgAeK7pcqi8Mjx/KMoklFJNyAzYcXSu/SZzNsWu0uJzpOpLoxrDMxfdPOGtyn/t8ny32
	BYs8xGssd3zMH5o1DSZD/fIHzQlBho3nfYmpdQS36n3PwGJmMbENhX/U6k1iwETem/2CXq
	zYM9zEaFbQceJht6pqdP/8bEpiXTWA8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71CE61570;
	Sun,  8 Mar 2026 04:02:55 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FE963F836;
	Sun,  8 Mar 2026 04:02:57 -0700 (PDT)
Date: Sun, 8 Mar 2026 11:02:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qing Wang <wangqing7171@gmail.com>, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, chao@kernel.org, jaegeuk@kernel.org,
	jannh@google.com, linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de,
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz, Hao Li <hao.li@linux.dev>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aa1XX2ZXo-hc6LHG@arm.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
 <aaeLT8mnMMj_kPJc@hyeyoo>
 <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
 <aassZV5PjgFx8dSI@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aassZV5PjgFx8dSI@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B810C2000D
X-Stat-Signature: jczhq9nfuo9qra7z3uadqaogbh8ors1d
X-Rspam-User: 
X-HE-Tag: 1772967782-154492
X-HE-Meta: U2FsdGVkX19qFCQ83DAokwIpSGFoZ5FBVUdq+Y+1h5EsrkeODb4c3s1jyWNaZyATKfMFEm3IxE2xoHJKDe0fb1FvUWblYvqtPQpBOu5c+MhvYPc7ucCTnbiQpk0MYv0u31lwwOdLYjGi+I1BVFMTzJ9X3PRjB3eMjeuAWd5aHl0+VD+ag/bv3PAVC2cS0MoDeealbn2i6eIIfC24UC+kLShixeAn0hBRssU3t3Zyl4gmGMomADYdiK2JOyVNJXhG389V7tkJUR3riP/mbr63uI0lFBGJJ51GafSsKHI8NTYNCdIHDk06ns2dTZZAh8bJ5e/qmQ4iRI6nVv/v6I7yt57CyADRYVOZcx4gls1SYzkcN+S5nHpG2MpHXpxUOLHMCoujz6dvADt4z4odP46j31iIMR0X7f6zeeKPFWBL2+ie0gTTERzBzbOpXF7zBy1BK+gGQKx2OCG9Tsr4j2oPURDMeiqfz3OkOBiKGQV6zN5kEJmErT+ruvpJtuJpx8Lx/efgkYC1QViTHnQVUiT2N84EgQn6I3oDnlwAVRVPYetLQz1vqHk+mgA71bmX1RJ/TYYJRvEw19GFtDO6El0y47Rp4FYvD3I1OyTzC53BCSBLspq3vqVFUYI2EfijunEHmWMGz64e2qjhk4xBLPwBC4xSW95rQZxarjOUqxOSYmaAvH5Try2BdVm9uNXNAlPcm1MRidLcz53yChUQMyjlPnOMC47mP6dp7BoeIOrNdp4h8IdnMfkRQCXsfeW7Zd2gf2BrHGznY+BoZBuyhs945ZTT2IqJZaekE+dSxDjQ/JvciSSJuHQF5WA/ywBNYhNGAMRRspIOZphOFUzksoV9L8lWInVcvqFZsDl9hAnTOEBQSEP9lMSGv6OiX6OgvXwxNdTL0wCJWAbBBoCBDA2eb5ajzLa7dVWjIHwlQ/jPTvs6ntEifFoGnmAZNn4kDWNdT5MFB7HL/CpE2xWaqrn
 MZRs9b6i
 Nj/vfa0SnOV/yEOik4vppt5kKt6J89fk1cWabrPf7Bb9foO0QP0FA2mrPVYK1RF8pwokAjY0PIb2UU8V/6ATtSj229yTK7aCo7pk3ZH+D50pD5Yi+259LlQik1RTWWRSSsPjk9y5v0eegRIh9Pykd0h9WPwgAwD6PHqVnJ347JWwBVktEuLGO1vGa5wkoOlWtUA0+9TmydpskjNQ1+nPKtWOKxDHCih6SqpW4PZV+obTkXt3Oig3FxxzhmM2N61YIFZ2x8G1oSBJAKjkPbukkNJAMuPOnTy1GadmQ/XDT3Uy5PJYUss1FKN3RURQPmuIU//e3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slub.c b/mm/slub.c
index 0c906fefc31b..401557ff5487 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7513,6 +7513,7 @@ static void early_kmem_cache_node_alloc(int node)
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
 	kmem_cache_node->node[node] = n;
+	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);
 

