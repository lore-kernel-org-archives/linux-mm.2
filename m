Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9211C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8316B00DD; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB01E6B00DF; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC526B00E1; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85CE56B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3B921C2C0B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:23 +0000 (UTC)
X-FDA: 85237016886.05.53127FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2EF6814000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fT4dTiZZ;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t+8KVL++G1Km0Bee3Trq1syqDNE1OnQ/qkWeKzei95o=;
	b=Up00XDqN17vevEbVEL33h8DUSgo6C+zowpT4bGa/rHjf4rpHae4cWPJ5sJy9e+UVnobbxM
	p6xxtXQCAUvdIETyeRFiE82R+Umksl0XJQBZ9od780VKHJjtYcEQ+x2VX4Afvlm9fLoKjs
	6SGJG0MOnuT9ThiIiyNixWXwNTfgemY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fT4dTiZZ;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977502;
	b=7KIJEWHtHCxvW2Dv59dka8+FNl5a4H1FJqw0LMsVCDh/0yfYQCqhwu8H39TF8BuY/hgBf4
	b5KJa1EvDNQPtaL2upjqLpehlExmWcy0JZ2LsLT7+sC1usEZl+HIOReeG5HIrk07sxuRJY
	bebtJhZdWzm/+MzL08ENCKDT+2RPRlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB61E600C8;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF991F000FF;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=t+8KVL++G1Km0Bee3Trq1syqDNE1OnQ/qkWeKzei95o=;
	h=From:To:Cc:Subject:Date;
	b=fT4dTiZZpoj1elRQGQbDEEgl8/DcvFOTs0SA03nvSW+9nwlw9KLQ88nVPUrkOekko
	 RM/57GNFfFmK7Ytw+QM/sNvRAwl0ZkuY0dodriIs6MJ7tdYLU7em8SbIJsnHpANmVe
	 Fi4l9D0Gwnlkd24epzzyf8ENH2bdX5jrPXMtCS/49LaHxrkqQOt4vSF/IC9HRPfnOl
	 /7rsK9jUpTsKLgo6OT8O3rJeNCT8Zyleg2bzhXU+vU57/SxRaAR5QWC8qzgpxsM9l9
	 i7k6OuTdSJUjIdmfrEvO2HQqkkNMR31F/DkBMoRuxFB3VKHRLvxspAC5kB90VB2M8q
	 082GauR5SEQ9g==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Cc: Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v4 0/7] net: skb: isolate skb data area allocations into a separate bucket
Date: Mon, 21 Sep 2026 00:58:11 -0700
Message-Id: <20260921075811.too.775-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1585; i=kees@kernel.org; h=from:subject:message-id; bh=joPrY7JNNShNrQs9z9UcLkD5WrmYCF+i0Wpx7ebGiPA=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs+wWJTxKu2o0Mwfuf9Em3UcZZ78+DfDktncsuTj/ kQRx8mXO0pZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACayzZGR4Yaa3Ilp845Nz8iu 2XG3+exUpj17zQtmTq0S897nsY/BR5DhDw9rXXbh+uPZ/6/lvdkifO9IbeSXN5uFV0TXrzpoZ1v +hxMA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EF6814000F
X-Stat-Signature: zcu59ig4ko78uz67kfp4cjzidb5jk8o7
X-Rspam-User: 
X-HE-Tag: 1789977502-948130
X-HE-Meta: U2FsdGVkX19tPagzoBA82oxDdVxFARahpr25NVKZ2HL8pz3HOwZ6xSbZly7glg5wOX19Fh1TyyawRobAuoFC4e+6WP3YCWKGq/DamaBCHWK3RCkpGfFtzIOAj8PiFdabgKN0X8seU3DrwlzHuznWY8UJhNIJqEx3K8Y2Jqc+3QaLfw6IQDnLQ3nTD17mQYPd6rq911HorsVQNMPTUyd7o0M1xlFbKff5ZNRXzkSvAz7ZsS68qBV/2Sej7YI8VVSmL9qfb8z+l5fr7rLjZdMjMDgf50TLP/FMJWybEJiHL5q9XmSEuTJcsmP56UQ1oK7JKdK9wiGe91G3LP9bypEl80a9OnGlRtfFk4/6yDqe28StXtcMVfZ/uv7+T0GP+SrbfCjXLIWffUrafQmZCSOezHBr+tM/Qh4WBt/KZ+c2Q+4tW1F5Kw7vW3uxP7PhLZAh0cequHusA+uU9yK6NdtZgjpiqDoJXN8y6dgRm04C3D+e8TqhqrE2UNpYZM/s6I644qOeyC1Jjd/98PGhH0burLkUtBjO344iddK47yzlaMBhpU8MLgpM/6we6hj49nLeXd/dLw6B0gZ/LR2eY9japmX8GyMlU2BnlbnfNUbFwaI+4zzUEY9X8Cfrv5V3HxEnBgAEuS6rMuVFYrxJQoiXmwajsz47bQodJmhaTeIyFVyOD6kpxNVxk21W0r3WqP0ebK1+poA10iJYq4KQJYKrWzxRisrzjAWUiMpRSq7eg5txpcYjRUl6ibq0W27uiDcizlTXbkPHIxw//Lyu3dnsQLYYRvbrzrAoroVS+4cus/JRUgf5FBaG22B1Pg++VqbjaCw0fvs5bzIHkVz9lBYH4IpTdNyzszzWlVNv4pvxGkwCJoOKvxPlGsRzJxOQzyCJJ0G4A4ZhAeyPPdeAV6YKrnhxtWOSRxmpAHmx0mDM3CAjB76fQ7pfqF4n5wC2EOQy6cnkOHezL2B814wcZQ6
 YC/XnZX1
 94hb0rrh/XoT1Qg0iV5lCAxLOAS9ms+YZh1JwU1PUF41ERnDd4nhY6aShLuQQjxvbm4w1sT9gc66DxPqxc5ZJZ8mgh1WQLEn6TeBNX2t5w9HozGd/+sHfyg0Bh8CPi+PAdailU25aXvBs3YanYfH3KcgVQmZo251aUk+CYqSjtx0SBka/pJE2e9WrtTJtRoSlygDUl6Ltb4qowHEvwXA4S4m23FNwL4w9KkRB2CNKkRYR7s0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

I wanted to get this rolling again, and got the buckets able to handle
memcg (GFP_KERNEL_ACCOUNT) with isolation (since it's common due to
AF_UNIX), and GFP_DMA with fall back (since it's rare). It gave me an
excuse to build out bucket kunit tests too, and that (and LLM review)
found a couple other issues that needed fixing too.

The bulk of this is mm/slab, but the final patch is netdev, but Jakub
had acked it before. I've dropped that Ack since time has passed, but
I'm hoping it will get a re-Ack and this whole series can go via slab.

Thanks!

-Kees

v4:
 - fix a bunch of little things wrong with kmem_buckets
 - provide cache-type fallback when using buckets
 - handle memcg when using buckets
v3: https://lore.kernel.org/all/20260702170728.168755-1-pfalcato@suse.de/

Kees Cook (6):
  mm/slab: Mark the kmem_buckets_create() context as a Context: section
  mm/slab: Give bucket caches the alignment of the caches they mirror
  mm/slab: Add kmem_buckets_destroy()
  mm/slab: Add tests for the existing kmem_buckets behaviour
  mm/slab: Provide kmalloc type fallback for bucket allocations
  mm/slab: Let a bucket set handle __GFP_ACCOUNT

Pedro Falcato (1):
  net: skb: isolate skb data area allocations into a separate bucket

 include/linux/slab.h   |  59 +++++++-
 mm/slab.h              |  44 +++++-
 lib/tests/slub_kunit.c | 316 +++++++++++++++++++++++++++++++++++++++++
 mm/slab_common.c       | 167 ++++++++++++++++++----
 net/core/skbuff.c      |  11 +-
 5 files changed, 566 insertions(+), 31 deletions(-)

-- 
2.34.1


