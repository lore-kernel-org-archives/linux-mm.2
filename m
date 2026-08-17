Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E628C5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7716B085B; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F7B6B085D; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DD56B085C; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3A56B02D5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2C9D160811
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:34 +0000 (UTC)
X-FDA: 85111430628.10.CB91ED7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C252B1C0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OZlR7Gvl;
	spf=pass (imf21.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987352;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSa3UC05mxHWjaa/VTL/h5Jk4T3fXImK3Z/Uh0wjmJs=;
	b=DiHdXFx5AFMkFpFeiS4OSLXKNf3QhFJpLcfH/i6xzsIGu/8jY56mKiogH1mPXvj0USW+oF
	geqOrdX6OW5POSVamRnl4H9dpubNI1x3mAJ+HUBI7rfgN7aFLPenv2FpogI2doMEtf7BJD
	Ny8UT9yHcwQ2xw1P0yUv2n6KsYJDYnA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OZlR7Gvl;
	spf=pass (imf21.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987352;
	b=DHcYN+NgzaS70VTiBuD/TTNU/FSD91DOsrAPaba1XWU/lyyfmBhdFcne2J7AypJxnmFqQM
	x/QZuAbgH7Apzes680SaLu6b5IrNwWalaRimVuRTr0JOgZmyEpZEn+A5A7PfAVpuFRw9hq
	cwrYUVfZ9xisAhGjlGOPeNHF3LboEBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DBA543F97;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49D00C2BCB3;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=VljahOe7p0VAPWPJ3YuDXhxu24pzuwulFn3TWrtzzxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OZlR7Gvl1KE/j9ReXCRHP7Rt86OUBhV/ePaNwQDyxcSXkkG5ol2WLsDDGFfjNCBcV
	 PVIxF+ltwYjsXvOKAVy0xT+OFtG/i2egwaPIEq+RSrBCEqfBwsbu0GbdftUrtK0AMA
	 gGyxvRwfi/0LSmYuoH7CUu6+igpzb2LmBbmOGT9OQgMTCdtZBSOc1C7pEq3X4e11gR
	 YQhh8T1NPYniY1M0Ph059yqC59e10h8OudFMBZ3j7XV2N3EqMPAjGj+nbuz6HxS0z0
	 AdXgrz48igGjkaF05KQEDMxDTaOpxI7mwNwQtTNHR1zDXvoFTR68QNRpp1EvLon2X/
	 CvyjSfvtEP8Cg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2782DC5DF70;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:19 -0600
Subject: [PATCH 5/9] bpf/syscall: Route generic_map_update_batch key/value
 allocations to folio_scratchpad
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-5-0c1d230aa3af@gmail.com>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
 Jim Cromie <jim.cromie@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=2199;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=vm1aaD+pwQaXZSzhLFkT2JsY0U2BVsRDPtRXCFebL2I=;
 b=yxcUp3EtGyfmt7m8wjQpy/d4ZRch/7Ef/TJRKDqN6xOkUjagZRS1UvxqNUT9srZNE0A5I/Kqf
 Rvrf7VwYNhcAwfea2Ce5fgAe4ET6iLCh6mOiZH9iu26PxjqF38ObHo2
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C252B1C0007
X-Stat-Signature: 79gcjx67gnfrq4q7zorjgkce16bdi1w3
X-Rspam-User: 
X-HE-Tag: 1786987352-564304
X-HE-Meta: U2FsdGVkX1++ikWfUdsCBO9UDQCHq0BKbY74LacfT3Q22rgVJmlN6mbhVeysYa12RycAu4O4wPAZvsPEtgfiy+VMjrJkxx3RJ0nrUcII7FUgGuYIdT5nmRjqV7fxRTDwC8evBfw4mrNX7kqJL0AksAToQ7S9zDRmqDrEpo/S52cMUjkOFQXLmaXTOOtbbUjweY0CTgAcw8K/NpcNPIJmi1pK51b5yVUMtkw4VZU84pU3BS0QFnXXLOvfbbNCnfBazYKubUj7HSw2eA0klBp3qCjOraYBZYLjg8kLlM+pM/zZugPyvEMtxhUzfQkBZihvqd8ss1G0yk/6gu4ElmXM2yLgUgwTinB33tc4ha9MTIwHBFfpVAyKsfx3f3uoJGkv2tWnZb8YhuliEwDemuXbVnGMJmPx1S5DAh7uCSDby+Auf/YaEngUCBqhwbI4OHvG9/wP436aHAWqWZMvUAWH2BA+VyhI0eHwewPwzNRE2R3zWTO4f/WuS5uhqSL5MIFpM8xgNHFbZ9GusQaslq/2s+4kcLuNYx57HqTqHOUlLkji0UWuA33BK9oPUh4ibLL4btbKrY/jVYbTlo2br3sjKlw5WwAm5SppFBD9SS1mv/sHqy9ZtVovrWnlDDx6513m/sk5p8EIhmisyyWsSBry7ij1MFnpLPVLFrceMNmbd65AZMtxYjj09bQFp1AlmEPpDFVHDxeCF7c517iS9v0FeY52T31QgpezUNg9EW0Le8VXLxngKxirgwzaz9Y2mei2DUjpfApBdCeTMlizM+Im6+OkJ0MO9/BxnFrSg7nC5hJX8WCC7Q77v0g+g7VdkSL+3e//STaQmntmRLZbwamoScCe/XizYIByDpBPr+iXfbh822TiOpwoEr6HdpFR2U8cFXQNsl7PjKASBhNtmrv3Ir4luhKeortYZ2QZsiVO+pN2EBGyRI5WstYmJpOcJ5h8I5lgnHPWapsxZeWKHDx
 uLvKT1Yn
 2m5ipmOOhWJdp5mbKWECiQKZFFSy3fBdOYzK/+Pv1XYzmpsI9E9ZdT6nWb9vQQtYRNjDTglJC6IOUsBewtdHwR1aKo7UHIuu2ARcoDkbyen5ffEYvbt9wycToQEnc/sen20gfatnj8XXioX0DdFY8kEu9Soj2wRUm7BiX5eXgLH8qz8rrQPjnU2V/OPfqRpo33QrM99X+90Qg+ejqE+c5o8W6i7awyI2RIYLFnMljGxikbvFEzSubRetdNH2yy+XmRuv+TnFCOjOiBa/VHOnFl+FgIJ83LcvUsNEeVDogR9ZugP2qwxvvuxe19r+DQVU0mnOgx4maVLyKT1BYs98HzfP23Y5lYe9rt/DT8pTeT3m9UiWkw7RuKu0uNJEps4FL96ehak7k7BFxwbFbgFi59dYPA0IH8R7t+p3RG5PBoIF1JVHQ9tdWaNOs3jrl0qsli+imsVEEVjk/qWSBtUbfz7dbiXV2hEabnzZkmVDiAv4RBAF9Zp5usyz/ek1az0HfQRYU9ndoe+Vhkmj4SqmEa2LWVN/qTu/tsozSeCrzitxRK+8yTLn8+5vYHILclAuiSme9KgB9hKTdZ4Jm5giJKqpa2utRvAJ95Nwxue/oDXmrpac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

Use struct folio_scratchpad to allocate transient key and value buffers
during map update batch operations, bypassing SLUB cache churn.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/bpf/syscall.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6db306d23b47..8ef48673b933 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -19,6 +19,7 @@
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/folio_pool.h>
 #include <linux/license.h>
 #include <linux/filter.h>
 #include <linux/kernel.h>
@@ -2059,12 +2060,15 @@ int generic_map_delete_batch(struct bpf_map *map,
 	return err;
 }
 
+DEFINE_STATIC_KEY_TRUE(bpf_batch_scratchpad_key);
+
 int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
 			     const union bpf_attr *attr,
 			     union bpf_attr __user *uattr)
 {
 	void __user *values = u64_to_user_ptr(attr->batch.values);
 	void __user *keys = u64_to_user_ptr(attr->batch.keys);
+	struct folio_scratchpad batch_sp;
 	u32 value_size, cp, max_count;
 	void *key, *value;
 	int err = 0;
@@ -2083,13 +2087,17 @@ int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
 	if (put_user(0, &uattr->batch.count))
 		return -EFAULT;
 
-	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	folio_scratchpad_init_key(&batch_sp, 0, &bpf_batch_scratchpad_key);
+
+	key = folio_scratchpad_alloc(&batch_sp, map->key_size,
+				     sizeof(void *), GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
 
-	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = folio_scratchpad_alloc(&batch_sp, value_size,
+				       sizeof(void *), GFP_USER | __GFP_NOWARN);
 	if (!value) {
-		kvfree(key);
+		folio_scratchpad_free(&batch_sp);
 		return -ENOMEM;
 	}
 
@@ -2111,8 +2119,7 @@ int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
 
-	kvfree(value);
-	kvfree(key);
+	folio_scratchpad_free(&batch_sp);
 
 	return err;
 }

-- 
2.55.0



