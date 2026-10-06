Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE22CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 07:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8956B0088; Tue,  6 Oct 2026 03:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082D06B0092; Tue,  6 Oct 2026 03:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8BD36B0098; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3BFD6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27B63160581
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:22 +0000 (UTC)
X-FDA: 85291310244.06.D418652
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23780C0002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dC+4del+;
	spf=pass (imf28.hostedemail.com: domain of devnull+michael.reeves077.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+michael.reeves077.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791270200;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72HD+4CvG27mbCsOpVyKRF2JNwWFA5HtrUBznnE2lDA=;
	b=XbyiT6jc9kTt9BKki8wha+dp6wnXLVC7Pw7cNtcTDXwSL0e1fjIv/0XVyW56KS7lVJ5MVf
	uBhfSXlaEHlClOVlklnZn7v/mmMugCUXT8kDPjl0VGVTSZABU+PgjJPZoJ9n1pI/iJcAxz
	aOpc/J9uK2wYD6/MdaaX43iw5PpPIGU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dC+4del+;
	spf=pass (imf28.hostedemail.com: domain of devnull+michael.reeves077.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+michael.reeves077.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791270200;
	b=f2LlsNgWm9+TE3FEOun+rigergeCeYm5c82GY2x/wKmFBVOIcyaXwaO258+W0T33rR3Jp6
	wjAAU7f5g03oJQ66SsR5EUZ9VG/26GPiOFxQwZsUcSIASUoeOoDFP51iB1aTCXZMcXl6EX
	Vgip0iR8tG6038hIctAtY+jopat6+mo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5229C43C65;
	Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FD37C4AF13;
	Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791270199;
	bh=JibEKNEcmqb57qhexlohigAcFZyJJ9PXqg76F+GByhM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dC+4del+bSd22JNDwtGhVHPQ0pXwhcRaRJGlGO+oLVuW3ByDlMm05j/WMTnJBbOiD
	 2F26JFh5HWOZVkhCLMHNSRQoxnvnFMi+i6DTOfVytM2k0v2s2sUNand4dRmtKzhneh
	 dHsw1tsKjq9abykTppCQ+YSNNvSwTG6n7fu9noxfUc7zeUzVjuBDXRG9jSv7pfyLPF
	 Wz7BxDarLcjBQbgYcBGK7WcAQdc+EjllZ8MBsSvC/ymlanQ0z0oEHOT//OzDTscs2f
	 L7LIlC9vIoEa+i9pd+3RYdI42xipO+IHPpM+67Fg+DzQNlCMNbjf8hAobtu9+NVC59
	 nvvWtRZlqSpFQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CA4CA5FFC;
	Tue,  6 Oct 2026 07:03:18 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Tue, 06 Oct 2026 18:03:16 +1100
Subject: [PATCH v3 2/2] regmap: Drop map lock during cache init and exit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261006-regcache-lifecycle-submit-v3-2-37bdd82fd47c@gmail.com>
References: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
In-Reply-To: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
To: Mark Brown <broonie@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, 
 driver-core@lists.linux.dev, maple-tree@lists.infradead.org, 
 asahi@lists.linux.dev, linux-mm@kvack.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791270197; l=4482;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=SZnYqaht9eHldUBPSRohyllzfPag5yZhmg8EqkFgLTI=;
 b=uN5nLx6ZAujPvKZMbgpw3DySy1o1+pySMXk2i51JpxFsW1vI7ul6yjeaShfQMDox58eZ0ur+P
 QigVOzCdaz4BIRbCRE2hVKGYtz7KbVfe1XF33e16jGnFVgEnrsdLO0B
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 23780C0002
X-Rspam-User: 
X-Stat-Signature: gts9p4s8du63md4garhory5fzwuottet
X-HE-Tag: 1791270199-787422
X-HE-Meta: U2FsdGVkX1/eNOZgjUsKXUvxBhAysA33wvLtoSuHOcv63xtWI6FwpwLwHGaceBE/mCYtoGO6uMgSDNL8TW/ZwkwKtTrPBsPSE7QODF4T3UKr0CQAP2t//VyVD8HjlmelTz1HIq6JXr7/RVJuoqTcq8Sgh7TK5Wv5l2f257Fu2F4BYvRY4ksSfgziyT9T3C4oT2XcfkvUdlIUAlq789MttgFk06impH7ny6UAnnlJMXhuHe7zRWo0SmG3iIRZcsz5gfBXMDA2v/cgU07KBATCrFob3x0SjNtANhARkUL9yAHdaBIw7lUKgvrUqMpUXZrtEIOCGajlhcCdWFYlRTjZ0f6ucQA31zRhkblwfPiWn/UmmWzJf4y2Zygk/8wHGtuWDNdjHxV53OBkuLJQpYkLI9yj8CH0bkdQmWJodblcj0Sj5K4rtVF+PMBPh+WbFBaEfmQwNM7pFHDHMGw7Pb/cbWU3afyL75aERxJp7f4NQNN3AU6fjlyN0NH6XQOsvJdXY6k8sW3vDQDfOhvttJToZmx0J5DjIx6Ol6kpfVOqfc0mR1CFAYTwZdz+4LZ5fCE/nRIMbEPz1JrYPVQMe+J4TDI430KGB0o3capfjoLZlgkEbSrZB4+Nm62mRst68pGkKur1cZoBCnYt8H+DM6jVFI3MNbX5L0elotleEeO3nmaO3oNLllnzMmBtB4v3ndM98tO/JLxHGape2kwhmsc22Ss6ltmVW1LeBs/FLSDTnRKrmE7OcGDjgRh9Bi9SkvoP/qXxefFXu/aE/7sn33hAbKk8xsRANVrTGUBjkSrG36RrdZdcq0bRtPw98rRdtH4W//K5/e7wwK2m83kp/w0OW0Bm4LDIFUp+Y6s8z8rOqeBjub78rgwBB3fPvRZL8LfWpwl53XZpD//YunpfTqPN+DgXx3MxOIUTqUz11NGcJ3JP5Id05rvlBFHFru+Bfp/VNige2UxtEY5LhCMjpM5
 XNdMcvzP
 9KHQqnuXR4vTm8vnJ6c0LHPGpNFYb/drJR0qlu2oEZ4qCjF/zS2pXCyOoKAo8ZITTd8zxuA/PIvE8Jq5EWU5xYhB8TtSbgckxwuFn703InvrvPNpHdIhPezh1m/w7gH8b5GCayVCAbJH4OegVM+0r/NjtZYPiQhw3nJggI/RlVDMPWUdlg+30P5Jy2cgQ1sHB4kwza0hgw3f5V9fkE/4DiM7h82JJShiolWEz7CrbbeErrh9coQFhCgTi05eTreno14u5K+c31OcC6+RR/6GKxgkK7GM90Gpv2OSD6F8fJE+VkeLm7qpAYHko47mD6q/nv6sYOnBvY70Co2vMnwZ8c9iUB3MR/KwKn4Hn87uBccCWsi7jIDg5NHmGZDN1BPC9ugT9EeaaThNT1pGK0MpMeq3as1yIpsAwWFtAzPD8qy8mTdGWggLXCXSG/r+4RoW3jBS1oeylULohbhlgE5e+uy4oWM3g4G9D3VVuJHQfZsxFnnmK//NG69G4ZFcb90s8SlN6/b2dQc9cmtXsQtt1TbxEgVl7xrABkka6akeF0cBJVRlNxFi0nCkn3G24ii9K1YW77V2RmOMfL1H4/4twMZlVgbyZpAbebBCfDI43RRAi2DHSxRj/27mTYJ3Ic7uQxvxa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michael Reeves <michael.reeves077@gmail.com>

On systems with CONFIG_PROVE_RAW_LOCK_NESTING enabled, Apple GPIO probe
triggers an "Invalid wait context" lockdep warning.

The driver uses a regmap with a raw spinlock and REGCACHE_FLAT. During
regcache_init(), regcache_flat_init() allocates memory while holding the
raw spinlock. The memory allocator can acquire a non-raw spinlock, which
causes an invalid raw-to-non-raw lock nesting error. The abbreviated call
chain is:

  apple_gpio_pinctrl_probe
    regcache_init
      regcache_flat_init
        __kmalloc_noprof
          __pcs_replace_empty_main
            refill_objects
              _raw_spin_lock_irqsave

Cache allocation occurs before the regmap is published, cache destruction
occurs after users have stopped accessing it, and regmap_reinit_cache()
requires callers to prevent concurrent access. Remove the outer map lock
from cache initialization and destruction. Keep it for cache population
and normal register access.

The Maple cache still uses its internal spinlock during teardown. That
lock can also be acquired from hard IRQ context during register access.
Add Maple-state irqsave helpers and use them during teardown to preserve
the lock's IRQ-safe lockdep state.

Fixes: fd4ebc07b4df ("regmap: Hold the regmap lock when allocating and freeing the cache")
Suggested-by: Mark Brown <broonie@kernel.org>
Suggested-by: Liam R. Howlett <liam@infradead.org>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 drivers/base/regmap/regcache-maple.c | 9 +++++++--
 drivers/base/regmap/regcache.c       | 6 ------
 include/linux/maple_tree.h           | 4 ++++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index e46fe5c32b..16e488da5f 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -312,16 +312,21 @@ static void regcache_maple_exit(struct regmap *map)
 	struct maple_tree *mt = map->cache;
 	MA_STATE(mas, mt, 0, UINT_MAX);
 	unsigned int *entry;
+	unsigned long flags;
 
 	/* if we've already been called then just return */
 	if (!mt)
 		return;
 
-	mas_lock(&mas);
+	/*
+	 * Register access may take the Maple lock from hard IRQ context, so
+	 * preserve its IRQ-safe lockdep state during teardown.
+	 */
+	mas_lock_irqsave(&mas, flags);
 	mas_for_each(&mas, entry, UINT_MAX)
 		kfree(entry);
 	__mt_destroy(mt);
-	mas_unlock(&mas);
+	mas_unlock_irqrestore(&mas, flags);
 
 	kfree(mt);
 	map->cache = NULL;
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 0d58d900a2..b137ded7fd 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -225,9 +225,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	if (map->cache_ops->init) {
 		dev_dbg(map->dev, "Initializing %s cache\n",
 			map->cache_ops->name);
-		map->lock(map->lock_arg);
 		ret = map->cache_ops->init(map);
-		map->unlock(map->lock_arg);
 		if (ret)
 			goto err_free_reg_defaults;
 	}
@@ -259,9 +257,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 err_exit:
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n", map->cache_ops->name);
-		map->lock(map->lock_arg);
 		map->cache_ops->exit(map);
-		map->unlock(map->lock_arg);
 	}
 err_free_reg_defaults:
 	kfree(map->reg_defaults);
@@ -281,9 +277,7 @@ void regcache_exit(struct regmap *map)
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n",
 			map->cache_ops->name);
-		map->lock(map->lock_arg);
 		map->cache_ops->exit(map);
-		map->unlock(map->lock_arg);
 	}
 
 	kfree(map->reg_defaults);
diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e595ae5cd0..f6491a92ea 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -507,9 +507,13 @@ struct ma_wr_state {
 };
 
 #define mas_lock(mas)           spin_lock(&((mas)->tree->ma_lock))
+#define mas_lock_irqsave(mas, flags) \
+		spin_lock_irqsave(&((mas)->tree->ma_lock), flags)
 #define mas_lock_nested(mas, subclass) \
 		spin_lock_nested(&((mas)->tree->ma_lock), subclass)
 #define mas_unlock(mas)         spin_unlock(&((mas)->tree->ma_lock))
+#define mas_unlock_irqrestore(mas, flags) \
+		spin_unlock_irqrestore(&((mas)->tree->ma_lock), flags)
 
 /*
  * Special values for ma_state.node.

-- 
2.55.0



