Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73321E9B342
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A596B008A; Mon,  2 Mar 2026 05:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7D36B008C; Mon,  2 Mar 2026 05:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E38B6B0092; Mon,  2 Mar 2026 05:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 878186B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:14:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32EE9160BBB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:14:13 +0000 (UTC)
X-FDA: 84500712786.25.A855F37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8DD924000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:14:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=afiln8Ly;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772446451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iTB8khiaDP6C34ZjGbxZIf00mczh0eYfY6sX1cyVTs0=;
	b=P+DyPQ9xtOxePaTmem9hZ3ishTT75x3BhgdESl8dFC8lJ+DuyTSqSVqK7WLfQZQnUxLZ/j
	RL9P4kWct5/2kVvVhmebVpf2BusAC/k7DhUoqCsjChkz3ZvLt+wui/+WZ6NKo5K4En5Eu5
	5S83SnoTWuxKNbisuuGnLs80FKZ7460=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=afiln8Ly;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772446451; a=rsa-sha256;
	cv=none;
	b=0DXZj/tozGzNv9wcPm2eOJcYqXwdMNZS0r3R4y4Q/RBfE9uGRoupozVQ3fquNnLN2pq4qK
	qW2YvF0CZIECmHU7QhfHQdntUyFFb34kHwJT6jSrcRgdYDVwyVIvU/gbQdVTFy/xqD+yy6
	oVCljL104kgpN8g3763z6KXyFH/NZPo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 980A543E32;
	Mon,  2 Mar 2026 10:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F350C19423;
	Mon,  2 Mar 2026 10:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772446450;
	bh=srIuuoMPtvXCLPWHQdRHEfgX1q8mmI8oAwkrIMF+mSE=;
	h=From:To:Cc:Subject:Date:From;
	b=afiln8LyM7AC78D2PUw5VpRXzHkkUNG11OnO4Ogbvojhxje4apxM4JUVgnX2dEHPP
	 TgDYh5/VNe8o+fa/cCbBGPNPDuz0hwb5Bo5HbFhsSacMlPz9tGyfHcAvjgke5I1bLF
	 nJqjE4Ics+cAGxPoFozZdeMuzU0DpLUqtqYwioCDnm92a1YwsdGP/hhoSTisFXCKQJ
	 VMMOu+kddr6p5qN7sIVT2Dq6K/1SLcqrz3itpDTbqtOPacvLxd5YtEUmi2xXVnI4zP
	 Iq8uq7qvG7NIIWVZm0apyeoFGDdbbiF2H/xcpMTMt2LPrJ+7ATq0YttEhXlG0h4eQK
	 KFivsK+cIImSA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Harry Yoo <harry.yoo@oracle.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR
Date: Mon,  2 Mar 2026 11:13:46 +0100
Message-ID: <20260302101345.36713-2-vbabka@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DD924000A
X-Rspamd-Server: rspam08
X-Stat-Signature: sh9dqzcaifuj6g8enbsc9qnz4craawa8
X-HE-Tag: 1772446451-224234
X-HE-Meta: U2FsdGVkX18w03JIO6UQf2vmTI3SiDwkhtyVRZOvlrM6dmhSzk1gCh12HE1qs4wDi5SyhlUOBhmO4ZVoKIBxnu8tV+CCqIZA8S6fzZvRGqg5/1/aA4ohd7bqZpnyAe5MwW82pT2qxtCuA66s0jOsVGmvnFdn/M+nLo4Zpfnw4U+19fZb175u/jbEyHn+DBZG+tfx7nQMmIwI/rJ1oC2k3VFVU9Y4ZZ0x2YQZVcev2pcnGYqQ42Y2TEJePQElN4Eo/jHjY2KtTKwfSVAGw+MSStrUZoPrDiDdq0w5dNscTH3EAv5uj94Mz5l3H3RrzbIoBCjJkyRTXGCcEr6Wew/+swxhn0UMaIFZW/wZ0aExTkeoh3PaKyO2WVS5whfWX1JvC1BousDXyK3Le0SfjKLVFxQCxrOBMcBjKTn7fRhZl4SIu24WCd85+WmEAWcdO/JdLE/1wHWmy+hF1XjY7nLFatcx0eqSAEgMiBxvLE9UZ/xAKTmHr2/C2Fb7kfjUX2kRAa6SYCNJ0ONzbvkabDugw2c4aK0uxscY7qvKrvBQqnqinLvSHNYPPnbSEkvfbMxBmXReV/P9+YD6H1z9xehHFJclg83pWBEeduYpLtd1t4XjK8gKXtnGSfG0SwzIuIwKBz3ilbDWIwHZrkphyGC4Rrg3N71PSnAJa3qw0pwDBIcfiCee0h5Rtbh84sGH2OwpBloiLuB1u930nOQHVAiAzSYeqxCM7wTNj67XfP6ScVLbbSCbEOBJNbZEfMah3EhoE8NRIFBUSrbLcLZDLYuNSoavMKCk546cGs2pCQyTrAukBvaRuqSzP9VqzDwL3nMJ0mZcEz6DGRTOTHoJxrcoXyyFAFyy3o568XVAu4M6Y8UE6JIvwRBR1kvt/DfgEZwfmJfqGShddBVBaST518Mo9dYUlrSaXsbMpKxdA8U/S214c660OwV+6r3DkBlgDknhVlqbz6W7lKV4kL6hn/2
 kIoeCbVt
 8aLtHNm2G4zhCBBghkxymj9gQSq1Te+BZ5gqNLVNjNqCX4MHTWuv3q6OoAuzO+nVTQs2KYDQ8i3F1fbhDmPrHDfcD4e9LM6ord0rb9ja8XWVEiXwwk8UIRZanWwW90dR0yE42XBXE6n68NUlXHr2cp2wAk8DQrzEQMbIBJ121ewZr9qOvCb+NJNrVl9QeNfI9/d6AcKVuNuiz0qhXND8ERYEUaH0tg43w5f90sS8A/2iu2VgscNkD3unqUDuxJcNpDH2jfUuIr+bDhgzFuXYpfLsQ8BxVl2nvVi8zulDyUg5rXzw5dkppUXXlq1fsEVIE4wfC+bRiK1tQ5EaeQGvhNzGfL4A1ZRlG+PFY+dBzDzqwYvSP2HGgkRl8bjwAp/Uvm56V2CWKfsYrHPtVubInRUS4+VOBndacXoLB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Promote Harry Yoo from reviewer to maintainer. Harry's been involved in
slab development for multiple years now and doing a great job.

Add Hao Li as a new reviewer. Hao has been doing very useful reviews for
a while now, so make it official and ensure the Cc's.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61bf550fd37c..5f3cc4193a8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24350,11 +24350,12 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Harry Yoo <harry.yoo@oracle.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Hao Li <hao.li@linux.dev>
 R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
-R:	Harry Yoo <harry.yoo@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
-- 
2.53.0


