Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05D5C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A4E6B00A8; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01076B00AA; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D946B00AB; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D19C6B00A8
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1F2F1404B0
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
X-FDA: 84930693540.22.B94F3B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 62499C0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHH0LRSL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684089;
	b=FJSPgkAjwfWAIDERC+vVJqJDFxW0gB7wX1EKFlijmm9u6WsRl35t17Bm4LCzryAsMD9E0i
	exomMNI1C6zVSImJdookto8RornIBpOI+apFn0x1tEjDT0DHMspQSyhN33PFZkK6GOSY06
	V//GXyyj1z5GG7wivMO24lFjzu4cY5Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yM5zo/CZPKVrarzYTBC5EA96PqDEgGYSVEKgph4Q9eg=;
	b=H/Aqq8toJwH0GOlLqOZgwYezRMtq4RYDtIlPMQtE0CVwOIy4MxK8taLIJo8J2Zsxaiabn4
	5w9GVLB1gpbj1w6a/PZP5dyU8GCpQWM8a79s/stqZs1nJc55PUM2mI/upcs0Slt+M1Nelh
	j2/rcp2qS9xvJQ9KQegLcWzh9Mr4lEQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHH0LRSL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A881B43847;
	Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8981F00A3F;
	Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684088;
	bh=yM5zo/CZPKVrarzYTBC5EA96PqDEgGYSVEKgph4Q9eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHH0LRSLcIQn0D4V9+fdvYi9AvAbxtJflJx8rFZFuuCGRovVMG6GZnvMk2LtGeSUu
	 m2hFV0MHLisuUr3GoLz5AisoZjOcg0piidbvHU1Kd9Hgu0EindFq/ab/2f8zFnve2W
	 0q8rDWbUtz8FRsv8/B6T5WlxVMLEPZaGml4zvj9ulC433P12wCGwJEkKSDyRoHqn1r
	 kRzEQP+2MZju/eegtFjlcE6cvwAJmUEKEvvtXf8iM/v5YnGfBUkG48ZvhDyYe1L242
	 MSwnxlH9foLvpnwPx+HzJkfGy4LGWMBEqLIvhOC0uQ8MUp9pimzQHbpXe5NCszWGqV
	 EaNG9KNddd6iw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/11] mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Sun, 28 Jun 2026 15:01:16 -0700
Message-ID: <20260628220121.97360-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 62499C0003
X-Rspam-User: 
X-Stat-Signature: 8n9ijobie18tjpduqpxk44uqkokzonbo
X-HE-Tag: 1782684089-950721
X-HE-Meta: U2FsdGVkX1/cjpQF3zxUqrvf130JkSiUh3+dsgXkEJMRCG+/1RNoh8veBGjTVlDXItAbr3Hd0xFeYJs5x3cgSaL+kW5zHCOdwNFXeMccKaAbggfI0yjwETGZv4ZwHpGUJvpn1I6zsM9LjxCTZAruO5ubhumXBbff9U5HJNbtbVOu4avBZkS8f5nikf7uKtl48BzUILz/EheeC5SMRPSL0iH8aMYDZwoZAtWpwolF8+CR2KEw6XGc4iLxJ073k7kSgNDbS4fIKZHkPlNjuqClM4fDbY17Grvt8tdV5bpwlEomNaDWWWJT+QhLbmO3gmQhSfNwyUAjc8uKy/gpL89QRzko1BMEiCvTDA6eJ8Z6w5GjnhZLYSnkeB2QKkyxgEqR6yHFtQheoVaRPG5I+DCj4XQ6PlMZ30nGPZ2Hj3ScHDkg2/jgyNpzzTPMqMA5K0B5n2qlURPV9sqSZ4GUnl5oydBpm4zwDNMJWij5jMGvlX3Rwe/WWm9gy2uocT7M70eOa7tOpzqtpxj2pKEyARKEmU2ICT/f5CaHGE9Qjspya34NnnLV59jaF99aAF4Nzw+JNtrqlpMnzVodnm+GMtKLupZsO/9NogTljp7i7n3GO0/7JKnuycgMeL7aR0M6QvpTs8xXimjrRgXXrWoINFG13odZQ8Wzyi0Ud++//vkSZvap/7AfstJvY51fT6iU3++kuWgU54hkovuN5/7jDMrtStex2oOKOfcOvBzFyjfWNvlnSMFgUA/vm+o77WUOnyoRQohri/p4YcBBewY580V52tgv7Xc8JbM73lrX4dXdw2WffgRuaMyvdb/1d9vwiV29jd/sqPWi/7yIJMkL5uMc9Ux9ZywXjGOOcEpOhE1ITXQqMxBLYYe67wueOy1s554ca/4mwdZ/SyzOMyYdyl3Bd6b3yQW4DTm+r954vuUzsMbDFYvwt1npqin1/6mrjWllQUQoyGszO7CDMkog9HO
 YhQy5Qbh
 SZAWZSzDWQPRe+RpI+gTCW79VFJLbXcCm9yUCkhJcjzBL/712XhEFORLwx07FiBvSGJ+jgXPJRr5jsdxrSNymx7gDHjMl7Qi1+fGvYGihzhjjXpBzLj4T4TE5JTDzQoeiyHVWuwXET+ohEvVl6/yNG+ft1TI63RmMBIZLE6e5YYgYXQpQCGJJriUz/dh0NA7NWOuBQmQy2srHaoQYoxo4SjbOKz5xdictzitJQfQOsmCpp6LF1ylTWvyf94NSl3yLC+CUfrmJpOC7Oq/4QD8+0TXZhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 58051185713cf..e2c8716be6c9c 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2143,8 +2143,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;
-- 
2.47.3

