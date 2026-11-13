Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8276606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=iSRJgcQM
Received: by kanga.kvack.org (Postfix)
	id CFD756B05BF; Fri, 13 Nov 2026 17:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE946B05C0; Fri, 13 Nov 2026 17:13:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F686B05C1; Fri, 13 Nov 2026 17:13:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9976B05BF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:13:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0950A0297
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:13:51 +0000 (UTC)
X-FDA: 85431499062.10.D188AC2
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC6221C000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:13:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=iSRJgcQM;
	spf=pass (imf21.hostedemail.com: domain of f3lix.dev@gmx.de designates 212.227.17.21 as permitted sender) smtp.mailfrom=f3lix.dev@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794608030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1APlPunBoDj1BI8mj+IbyZx7pU1qnOexHufDgnUoh0s=;
	b=wwUERoE0+dAkTGmjWGYbr9in8YOlcdJ/VM6BE93BMH/mEoMrBFQGAgBjHn0u4pRcNwykuq
	N09O4fzJ7HQ0hPsnFyrWwJxamJLusslX3pGU2PIBExtqG+ipQjMaUz9jskIZOQ4fXtyoVc
	PtHtqUQ+HTeYLoX/hvJisAExb1iFGbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794608030;
	b=g+iO4/gCsPII5NVQjU5AISiZpE0PRmBc1IW9AtaNAF4qVDg63Yf5XteVrXAwjgUIyXbuc6
	8RQa3WUxORMMws6O3dgM7+jxKhp4E5JtFR5AgKCzJbvpdQiOGVYivtOojxf2+YK+BMXJt2
	Gd+RUHE1d1aVB88PA2D4Dmj5kY9C9Ow=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=iSRJgcQM;
	spf=pass (imf21.hostedemail.com: domain of f3lix.dev@gmx.de designates 212.227.17.21 as permitted sender) smtp.mailfrom=f3lix.dev@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
DKIM2-Signature:  i=1; m=1; t=1794608028;
 mf=PGYzbGl4LmRldkBnbXguZGU+;
 rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
 d=gmx.de;
 s=s31663417:rsa-sha256:KSDBgkvRRyEsWADDvbCR5nDACpwv
   3yeANPrmoyuAqSh33ntH9G2CXPSAGj4onJa/qxwxZf184gJa7fCcoP1GTJJ1PSc7Rz3HunZPxje
   xEmAuppPeOJlxxP3eV6cSkX+dqN6S7o1u4ikAnL01Rft6ijCKIEFVIb13ucbLACaB7G797UI9UJ
   FV9tqqqd1Ama1U/p5dOX1HllFDZXszfGv5PwUZxWX0+aFyXIwP6F259qSXNbPVPkxBI55LwCQyg
   IoSKQJq9tIagKgbdDVSGSixL3d2mieqzg9kZlug0DPMfu+qnPurZ6MrHjAXkT574AX6FETOCr8j
   JxFWlYDebKSuLA==;
Message-Instance:  m=1;
 h=sha256:
   ByK8lr/d/c2qF6jNv7YOjfg5LqffyJh8MlJqbLkRYdE=:
   BAh+AYGkQfGwvejFJXmMQBzbqktADkrcebCYjF38WtA=,
  sha512:
   KJei4gKmMC3I15uiipcaslebHWZmOdo1uRw3KDWzaTX2cMqqwSJXlmz5bEzRjJPqH0/064lsiHt7ZOjoAOuE/g==:
   tALft6IDZZlS6rg/CRS/VzdZL+jUaJQ1csnYHq3F1tHXeVODUandGF2CqIlAkaaZSCMWuutihB7+Obg7A6V1zw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1794608021; x=1795212821; i=f3lix.dev@gmx.de;
	bh=1APlPunBoDj1BI8mj+IbyZx7pU1qnOexHufDgnUoh0s=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=iSRJgcQMZ4Iidss5JiSQbnuMN8vF6yeKEeLyWtS/EGysqMrp99AvtL+JUsGl0cQ9
	 oTBZNePoaTZdMcpmoiFn3pzsycSmu4Qm21qMwS1CJRZkCZwG9cdsBCZN3YQiO6sGP
	 S+JfWwgePHiU19Wh7a8LuE3ETmJb86rYKM4fqA6TXWcfrI7GLTJZOoB5qGCdcmP6e
	 TIKw5/BFSCbOdMxAZMdMLgnWoQjKdtHieZiGKKMXEt+qlGBIsgeLFqVEBxojknOeJ
	 tPjAVvRXWAO4toONK3hNBLpw8O5toM/ha2x/ZBBn/YzfrQdoENxy2exntjwQGl11b
	 M1KdEUSgfM07ITN+fg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N4QsY-1wQiGp2dxG-00yS7C; Fri, 13
 Nov 2026 23:13:41 +0100
From: Felix Hoffmann <f3lix.dev@gmx.de>
To: Jann Horn <jannh@google.com>,
	Matteo Rizzo <matteorizzo@google.com>,
	Tamas Koczka <poprdi@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slub: Flush virtual-slab work before cache destruction
Date: Fri, 13 Nov 2026 23:13:30 +0100
Message-ID: <20261113221330.162567-1-f3lix.dev@gmx.de>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:akNYmqQvLVur68rWWgy3sX/p77RzGQ7hIrKAsCvMWSFrYKJc3po
 T7IziOU5S91CgQHKN98TLrwiU2X2HcLM9qjQnNIMy+pdfr8cpmmWmyHyTgCu/19D0I1Wlez
 QjnR3606oYQxdIOYPD6Ns27beobS1DSURa2ZACCjYF1yOWrEL83CA1fNfU6WndU0aSiWPZq
 JABrloYamZeIFvp7q68oA==
UI-OutboundReport: notjunk:1;M01:P0:1nLtmfppK6U=;RANPJBYQr2ShfjpeY6cGH3nihSM
 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
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 57p1ewmi5d1t3zh1oqrxfwhfkmeafmsp
X-Rspamd-Queue-Id: DC6221C000B
X-Rspam-User: 
X-HE-Tag: 1794608029-134814
X-HE-Meta: U2FsdGVkX1/VsgAvMa62JfotPPeJ6qogBru161N6LVSq4a+8AmQUsmqJN0wDcqm17NL13I6I5WsQt4rGD+ANPadZtH3LwtTIeffm4kvE4eUOoEqC0xxDtsudJ8FeXINaLbnBTVG3HjgR3MXnt+OW/dPAYG46ZmVn6yH6Xz4GitVe4g4FgqTTIpoYEI+fplrLTM0utDTqu12TQyXw0obj2nCDNeKSM031g/ZbPEiNHf2nUTxCiJRjQb9Vy54zl9JV0Z9NuBhvWR6issjkWIWS2YdRE5yuvbooBs7zEz3cWpusBMORLB5JvX0/7XD53aFQR7z1hwceZEBEbdBMLvXHNekYHBP64dTheSWOnewGeD9ql5dhHAVTbJrNl76Ivyh9+3lSLRgPBKSZMd4BciB08I+nPSLPP4QyL5hAGe7NmiHAej7Cogrr+4CsSzjV7FKV3os2oFDXQcWpAzzAho4lg9sVW4arrtR2cUZYJ7UlM/HQH/EvmCUPFDIcfy0M41TMhZkJG/68/JqxDhgfV/zHIqByhqo8vbnRggM+jVaB+LxsD20OCDqXNvgzwtKvWS2HWK+wkh8fcwZ1lGLyGdLo9Y0f2FoKw6hXQQQV2Me6H8pJdqiACd7i39uzt785sfWVuaFuGV0yTqQuyjj8BLyV4/7RPsuAobAHxH4jQyNGMqJhPmvtOco2FBYu91L/hTc6SmlriUC+wUd3B3MoTDBuVZ66eQ6XqYb0IJr0YEnQa332x4/U9ONDz+7xjm8tgUgOmW3QA/l4CqfmpLISgNk2mzpaeXyzGg5VA1ojY2rtEEZ3kl34MRVVK2gxLelSyWqr9c/RU04997C6y1QKmBTvYaut9cWGitHZvN7gZ4Yw5YUn9NRKvDn7vwDnTDYy7/WeC5HCQPBGyZwf7ojJnJfw3YptPPfLhG6aaQ4WMl+U6MdaYCKqa6dwcfcn2q/7gwgutCdtrer983hj6dYvt4v
 rN3WgKQf
 7Mk7FCAl6//U65eSo6Cyd5S8dMsUH24mHWIQ+jshxuhK9MJZMEC/MZk6WJIQBadPzYtaPW/DLT584dENm4rxhI/f00XussOM2VqM30JAUw1yTwAx1t56gpIV/FhdaZE+2ayKQYlsIsenwAJnGkBuWd3kEiXH8N9XhEjw9boVEIc3OfLBOULv5MZ5VspYkMUBxrSGSXWjy4X0vs4R2wmuxZrE09BMDfujltVBCDQCMd9xxsZpbEVzS2cjAeeN3HSQApMNaX6+xUtNgwbfSQJ3DoyHY2WBSA3oDXt14EASPUHFd+nzSdI2DjgqFa/Nz2ikxS4cdcESjT4xse6fbmL8cnWhtYCORJW6lBpZw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Under CONFIG_SLAB_VIRTUAL, freeing a slab queues it to
slub_tlbflush_work. The worker later follows slab->slab_cache to take the
cache's virtual-slab lock and update its lists.

__kmem_cache_shutdown() can report success after the last slabs have been
removed from the cache's accounting but before that deferred work runs.
The cache can then be released while queued slabs still refer to it. When
the worker runs, it dereferences the freed kmem_cache and corrupts its
lists.

Flush the virtual-slab worker after confirming that every cache node is
empty and before allowing cache destruction to proceed. This drains both
queued and running work that can still reference the cache.

Fixes: 0d6f38b78adda ("mm/slub: allocate slabs from virtual memory")
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
=2D--
Tested on x86-64 with KCSAN enabled:

  - on the unmodified SLAB_VIRTUAL feature kernel, a stress module that
    repeatedly created, filled, emptied and destroyed a non-mergeable cach=
e
    triggered list corruption in slub_tlbflush_worker() and panicked the
    kernel almost immediately
  - with this change, the identical module completed 10,000 cache
    create/destroy cycles (81.92 million allocation/free pairs) without a
    BUG, warning, KCSAN report or panic
  - the fixed KCSAN kernel and the external stress module build with W=3D1

The reproducer and complete console logs are available privately on reques=
t.
 mm/slub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index b4c64b2bbd334..dbfd42b31a0a2 100644
=2D-- a/mm/slub.c
+++ b/mm/slub.c
@@ -8541,6 +8541,11 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 		if (n->nr_partial || node_nr_slabs(n))
 			return 1;
 	}
+
+#ifdef CONFIG_SLAB_VIRTUAL
+	/* The TLB flush worker still dereferences slab->slab_cache. */
+	kthread_flush_work(&slub_tlbflush_work);
+#endif
 	return 0;
 }
=20
=2D-=20
2.43.0


