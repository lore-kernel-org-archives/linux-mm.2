Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0D3C982DF
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478416B008A; Sat, 19 Sep 2026 22:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402AC6B008C; Sat, 19 Sep 2026 22:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3FC6B0092; Sat, 19 Sep 2026 22:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A94A96B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:31:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBEF11603A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:22 +0000 (UTC)
X-FDA: 85232564004.09.A48C76C
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2077120003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ItEbDpmU;
	spf=pass (imf13.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789871481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDHeX2pbe5QJ4kKppVbv//QlUrFrGxWdWrRVc+dGwWM=;
	b=XYjDsWn7AgeTGYx4TODgnRB+12Y8qu9ovSXiL7Ugzh0ASmvdSXlTXoZunVowvmIfhSMNM9
	w+np1uj4K9t+faYEljhEVsjyjQdPklgfaeUzHxlc1eItaTO/rom+4lncm3WoRspNB134b/
	EYk4+rvsRUG2owOrI9fVtxi36erLVfk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ItEbDpmU;
	spf=pass (imf13.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789871481;
	b=alKdU24zYq0azoDEYVOl99ZAQNqiviF8c9baln9F2P0UPTh57GGIW/CnWr4Kr/awUpBYUo
	368W4g9GuW+9EWY1gBZNGndWOaMXDX3iKRmYY7fY5vol9UGJfuS7IIev4RhVVE27fsuIeP
	nhfcwjI06e33jj9CkJdeGpx8q4YrL38=
Received: by mail-pz2-f43.google.com with SMTP id 41be03b00d2f7-cc433d52421so1052764a12.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789871480; x=1790476280; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BDHeX2pbe5QJ4kKppVbv//QlUrFrGxWdWrRVc+dGwWM=;
        b=ItEbDpmUIuAo1cuKwpDzoeTuC0B/sat+BusR62BsLyenl/ywhE20u+7X4+f/lG8JCA
         NSnqr8iQ2w48hrBm7cmTxd1da4FsqMD1c+zuBDIFNBb8SmL8UoLNUxwoDSG31LnGai6w
         M5a+l6LOu3C+mf7dIzgxfm71ZBcqhG7u005u+FZSH8lh/IgCHizm7exLrJg7pb9/ZKeP
         AFDx/Kr44Lfyoebi0Q/6ow5OnftdqCpI4mbJC47lCIyBsyyUpnds1xWA6QiiMM8SFVL/
         I9sU1ZHYW9IBH+4CLZojUlZXEOHbDIo/xWqsgJKYuH22b7EP0SNTUc7ymXT6CrD814Mv
         Bb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871480; x=1790476280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BDHeX2pbe5QJ4kKppVbv//QlUrFrGxWdWrRVc+dGwWM=;
        b=UAE9Wv+BTf8Ic4KTXO6ngECdDMZW2HHdpm1z9a+2GbfWH++IxwWGp6wHOu9d3DTm8j
         /0fwDdC2jGnh3TWW0amQpcV0tg1Vb9t68AZb04S5S880fZMl1qrgBNpGjcvT20f2MXEc
         19g/EHKU1SoDyaZrqyGNNOLWQIJQU3EFVT63IYdT6qkDyYElS4yBebAXSq984Y72ra8o
         rX1eelDQc4cfoNKNUBvRYIiTXYgKRKE8rn1tlVR63mppikzAxh47uLl1c180peJRilei
         xN/KAZoTAQp7F1d1UbndpoTjoRJGtqYO6tarEERoUhNN6uBq44uWXJ58IqJvP3VTK5iZ
         B28Q==
X-Forwarded-Encrypted: i=1; AKwUvBzOJ8bUMVs2AtenFhYH9/oYzmlVMaOcPgfzcMWrIpz40iE9cV4TySGhzfXDDPh+M8/bEYqkIFX1+g==@kvack.org
X-Gm-Message-State: AFuF++lRfeWa2TVvd6ofbiMgJuA5NbtirQesmpdQ4gBXJOCyLcPGv3oZ
	dluiJRc2rEQR6oOr2XPMn0CsZOqVuC6FXMbFM7WyIr/KzkhHgCFeGf3z9KKlxpBePg==
X-Gm-Gg: AYBFou0FxGKAwn+PgTV9lLMi8mzXvovN43cKoyfL4/ojXWhvfZPvRQ1Q3YoVlc9JyWX
	wVFQs58ZpepymLYCTXdv1pR1WVwxBeat5UINKOvRcC8mzJ7Ja0gTvLZsiQ2Jfla2AxU5GGQmFb/
	bqZw8Kq/BuwmMv3ghnKrm3MM7eehQrg526hGoa9vGMVv6Nic0pDijcIQ5xjqQVSVaNLFUmRpBbh
	432ocXFEfM2PWypc8crpSK+YrAPD0WmavXgXCmvqtFTJMiGGkzYz1grzi87RFAEtXn9lBmNDjHy
	iOByw7mCsVGXkU7Mvhu/0Hb6nOm0Vp5jioPumAusl4GcoQ6Sgx2m2jvsBuJiih/jzIpL1psNcLS
	fk79C1bwfHqZn3jJCKagwHasH0ANFhUyoitR5v3GauDU7wP0j/uMMCOeQYT8anL4SJg3bswjxgZ
	3Ly/iuY+UZMRyaLtp/spUJHXzRlZuNQ6DnAfz+hqmkgj+ncVfZN0MpLOuzanAgXk/VsT9OgePu+
	VenAGY6NwiZsh+ZhGpSmVLvew==
X-Received: by 2002:a05:6a20:db90:b0:3da:1e2f:3be9 with SMTP id adf61e73a8af0-3dd8c49e92dmr13033406637.22.1789871479726;
        Sat, 19 Sep 2026 19:31:19 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:36d8:54a:e0bc:3e5e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aee03efsm1481341a12.24.2026.09.19.19.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:31:18 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 11:31:09 +0900
Message-ID: <20260920023111.2466265-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
References: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9emszfmt96rxr6o4w7b8cartb93z14jt
X-Rspamd-Queue-Id: 2077120003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789871480-22360
X-HE-Meta: U2FsdGVkX1+VR8rFzH7lW5vMMm+jV/d/hQk7KR9X2PtZPhTAh7kecrvhmmr2gVM7PFVFUj7+GAAT4x0rV8v8rNS7oZqSVO4UDhXrHIcdgTsXlOXiipYmUv1F0tHFkNFztXG9C03S3qvQSucalg/c4z2IFoI5lYuGJlEfa0tJBXHxJnPHnXkJdrAE1bIL8dE60Uu6Term4V/KTLT+Ai+cRDFHjdHGWqKGaiFH2FRGW5Rqx6SlUFMkLbyTmw0ut/NQl3L5rXQklTmT+wS6OtQ4wsORZg7eCteUbxvJHLhpoIJODC4NKiFMQyek/+fwxoLjG0TfCYa6pwcgxZlZC1rfNO47ybmg3lEa6UHDikXRk8dz2Fk/enOKtizVM+uPAAOKSMKYVjLToxE8kjoBOnOdYWhL78nnmbie8KA3HJZmwpZ9vHR3LN8/1oHMJXxvAJ5J2lWmO+gfe/42rB6qNNTMhNt6GcT2nORMVEK7IRblQlY0cBh5kgzQ8J2tcmlzynksti9hQEuwnbwtcKuHP6MjxXV8zVxzXXTlYlHiMhnGZ3O13LhAYCGYdB0uFhL/t5fWptYq5+cbnPrTePytlqwRawRcqsEdHJerwbwyM5yXoZxj4WBbA9yWSz2V3c1PjjxQobVbREqQh3BjN5dVcC6kq0FgEzw/0424yD7urhLQetKhMeUOCN6l+pyEi2SvZv5u1QuhyAczAAnbA3UB+5SmFGlpElaN5Defugh01PtrpzRSVS5561T5oDtxClHSyffCHa5fnkYdWYhRVPgMh4K48/8EE3b9FIQ2MIVwaVXFEzdosoXPGZdCVlFxlADrfu7hsAkcHC8Fo+8g8ejn0B3KcpYfs25XxsvFlphV/TXW3yUipJA5hostL6Eqpv6gk6IFcOFTQnkKgobyP6DafbfL5ccxveWpEtQx/BrVU9nyJ2/JipGyPzbUvqppF9i2MQynQfECBC1hpS4iGF5KI/y
 xMFA7jmu
 c95K/D2hDBdYQnj6YKnw2TBrcIJpx3AiS5EPHO7h6clQqlzi5yfS6Gmmj9DdIGwZRGJLXK7zIl/3HtlZdeSzjiplcuWTIv8LQ/0XsvHDzMDf9E7P6kWEIr8IZPoVo4Y8A0W+Kvir18L1WZ8SEuBLSG03CZdKqZedjNlwvY6Ed4z1hMLH1ShLY7hOXgTtfl3qbeoL/9XfSNv/gbd1eFpDIpQQkpl9ytQvgcANZ2gM+fDHDAyr0u2eJKULiiVLUc6OdcSmt/nstZHLM2iKFk5h0ONra911xZw1GAa5W07dVkcUBPSSgi0FOi4us/gEPR2wgHdOz9YKHd9KOmbzrr0O3hC0lXsfiNklinsttjWbvuTnKEwVA6T0IhriSPP2/oxKXj9AJDvHvAvJ4bmCzq7dmKnpdwIILhGe+fjySIXXJP4LAEIBCJ+VEtwXUzCtSpEe1gCEBa3/H1LpsJ6vk1z/COtznZv65iIAM5b96yQmKgiI0enm/kL1mRD4VrE0/u3rjwpEjNHFfk23pnK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,
and damos_set_effective_quota() divides the result back by 10000.
quotas/bytes is unbounded; bytes_store() hands it to kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX / 10000,
that is 429496 bytes.  Documentation/admin-guide/mm/damon/usage.rst
instructs "echo $((1024*1024*1024)) > quotas/bytes", and 1 GiB * 10000 is
2500 * 2^32, so that documented value wraps to exactly zero; 256 MiB and
every multiple of it do the same.  quota->esz then becomes zero while the
goal is not achieved, the trailing "if (quota->sz && quota->sz < esz)" can
only lower esz further, and damos_quota_is_full() is true on the first test
of every charge window, so the scheme applies nothing and the goal is never
approached.  Other sizes are wrong without being zero: 500000 yields 70503.

While the addr_unit parameter effectively mitigates the overflow risk by
scaling down the values written to quotas/bytes, it does not fundamentally
solve the issue.  Theoretically, an overflow can still occur if the scaled
value is exceptionally large.  Furthermore, because addr_unit is exclusive
to the paddr operations set, vaddr and fvaddr contexts remain fully
exposed to this overflow since they take unscaled raw byte values.

The 64-bit boundary is reachable without any scaling: bytes_store() takes
whatever kstrtoul() parses, so a quotas/bytes above 1844674407370955 wraps
the multiply there too.

Bound the conversion, so a size quota it cannot represent falls to the
ULONG_MAX the function already writes for a scheme with no size quota.
Widening esz_bp instead would reach the consist tuner, which runs the same
field through damon_feed_loop_next_input(), unsigned long in and out.  On
32-bit a large size quota then behaves like no size quota rather than like
a dead scheme.

Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
Measured on i386 under QEMU: one paddr context with a stat scheme, the
temporal goal tuner, and one unachieved user_input goal.  Each size is
written to quotas/bytes, the kdamond is started, and
quotas/effective_bytes is read back after
update_schemes_effective_quotas.

  quotas/bytes    effective_bytes    effective_bytes
                  before             after
  4096            4096               4096
  429496          429496             429496
  429497          0                  429496
  268435456       0                  429496
  1073741824      0                  429496
  500000          70503              429496
  4294967295      429495             429496
  0               429496             429496

Everything the conversion can hold is unchanged, and 429496 is what the
no-size-quota row already produced before the patch.

Patch 2 pins the same boundary at ULONG_MAX / 10000 and so runs on any
word size.  Without this patch it fails on x86_64:

  # damos_test_esz_goal_temporal: EXPECTATION FAILED at mm/damon/tests/core-kunit.h:1970
  Expected s->quota.esz == (~0UL) / 10000, but
      s->quota.esz == 0 (0x0)
  # damos_test_esz_goal_temporal: EXPECTATION FAILED at mm/damon/tests/core-kunit.h:1974
  Expected s->quota.esz == (~0UL) / 10000, but
      s->quota.esz == 1844674407370954 (0x68db8bac710ca)

 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2258b72da7a78..16d4145379a2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3274,7 +3274,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
+	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
 		quota->esz_bp = quota->sz * 10000;
 	else
 		quota->esz_bp = ULONG_MAX;
-- 
2.53.0


