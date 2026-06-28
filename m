Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DE0C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D24B6B0005; Sun, 28 Jun 2026 12:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8832D6B0088; Sun, 28 Jun 2026 12:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798F26B008A; Sun, 28 Jun 2026 12:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC386B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:55:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4FC3140453
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:55:07 +0000 (UTC)
X-FDA: 84929921454.15.C0E0FE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 334B11C0008
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:55:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvUnhp7n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782665706;
	b=XtUYa/pAuoPmIdF2sYydWXOJ78jzhXPwnZ3HJrkayY7+82rAEzksd2R3YIjmtcVaj/NE5L
	ZuLCVJUoWt0w6A8fKl+dzz+zFVDvSn5ogUiodxwpRKvcAqLx92wqRsnrD6ItHm0XBqxOBg
	QPIPSpOUvUrTpVidILO90OtLDK18/eg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782665706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WnNx7JGiiiPZrlprnXcKYwyKhDFTWq0vvPCdgz5lwaQ=;
	b=Px2FjVy9tfYitca9korrjxwcLPBInk4mRzmAS7dyZ/dooA/+bUFu6kBUm0dwqy0dG7vz98
	lCfIvMv7K5R4irKcA7PeBAslkmDEUREU5kiXo0oYgtnRyBT2DOa6v88RYH8JLmg7sijF0U
	p4r2SvPZq96N85w9+CGtbv/vKaZ9bBw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvUnhp7n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92E096001D;
	Sun, 28 Jun 2026 16:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CA61F000E9;
	Sun, 28 Jun 2026 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782665705;
	bh=WnNx7JGiiiPZrlprnXcKYwyKhDFTWq0vvPCdgz5lwaQ=;
	h=From:To:Cc:Subject:Date;
	b=IvUnhp7nb/iw/yn1ckX19zJmPsB3c5cYpg6Or5AuCQnNUIccZVZJcrYXoAPHVo9we
	 ZWcXaoKKiGXDgUva+BaJ8w807AdfgsE+NaPBclzG8+8+nXoMa8ZucaZJXbcQqVqcGp
	 p8OBzAgpAr3NYVFoDe+Xlxw8xajgJ4BVduxORZQJO1Z/UI0CB25jUlxQ5/zT4eVcnn
	 n9ereCDbVxOukVLLp0CJxVpFn/7sjnPLKkX1DFO7FtBPqH+1ObU4GXbPh3cP8iH1G9
	 xByqjDst/Ky+ElD5Xq6NLB/z/VV5j3C6dRxme201bs9XCaiR5GURBlYypn8X3q3QkR
	 MgyGI9ZY5T32A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH v1.2] mm/damon/core: validate ranges in damon_set_regions()
Date: Sun, 28 Jun 2026 09:54:41 -0700
Message-ID: <20260628165447.86217-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 334B11C0008
X-Stat-Signature: ekt53c3aqn5afti4y69te84m9o6kku3h
X-HE-Tag: 1782665706-842714
X-HE-Meta: U2FsdGVkX1/e96lrUUTSbjbuBQJhNKuKsfzM8hyp+P7TjBHwWi1O5S94PxFtp2VfLik04Q64fK5xmvOu1mX6Ef+OE1biTK4zeartNQbpGa925+5jc0oU1XtPJ00x+Ke1VeayhpnLfwK78iU7pewqLjln325dtUE5FPwIgEAiAWC9LXAwRouAMephEqMVzaz/8cOToWuyml7bizhhMaa0AzRR75P8jftUP0MEsBSeF5o+kq/0GUcN4bAww91kgCzNFqMkg5ToAJQhRkiFty+qGmeWJM77cLdFrsCUbQbZvdg7bVZZB2pesKEp5urGIJNCk+zk7f+ogBccTBhn0FI2NpbF6SJovPR9gK8OcsS7NURxzD37CZ39F17T4CoijbQ9R7yATpryB5sB1HmMQxucB0mPtGp2B6fQACiR5UWC2CA4ZiMb3PgzFZFk8hvKh72QgCWuYXv7MMv3YZnVj1D9mzXsY9nSLvqF51cORAFvsyewY1vAlbr0GTHhDF89BmYnm0lt83V+tl8o0dOmMpIGfiHxgDkgZVAHImUnn9l5HCMdaJU7k9mPEUiH5tYBthSVzAzootlpDU6PnQMBPSDcM+BciQuP6v6rxddni7U0XSTXkPkq2IKtHxcGexEVf/Y1uKmX6RfNYDTG5YlfV1iyFyQ6CuERm4MPh4G8CnFZYgbMartwJZ/MDcEZjxEMGuKfuFLV7Kh7HgkJsWX/kxPKUkLPKwc+ybqIbL/KeC+aTlbm7blJp/hQGz1JO7E9VfTkCOvR+VCQAZnjX29O1RljYC2b7nXd/5F8Jnyr5MXM0hXiyj/StaiHrLoowxk1gSQRB2nEg7aBJUIHohRlBqYBekdnduU0xn1icEuijDhYE9wpp1xIp8rGox+v/4FM4BrTqV01qvx9GLa++z9z+g8fdJHtbRCkYtg0wYBI3GoQubxxSwRBT4Pxqbd31anF9KLkOYXdLjWaUoSSQxgFOyh
 LlUV0Htj
 26W+HO+kInJLdcrwajMUKCKjC35XLedQkN7OVEu+/EADwCc68Jni+imMAGyWhOP6d3tsT9ujj2j6niqyHAoxOP9CKrrOUUkcZfPGWbnnnkeytm7jCp0QcBpH91sQ193JZxWO3XUBoHMNQKHKY4TBJ4leeX2DFA9BeukQhDlRd9j1Z33LaGVUJoIar48dBAI7KHscB68XtPfAV8Qp1WktDwxJo+I81aR4WkEM6micxsXFocTm+ZTu2LzvZR0IxmMUVUV8HqguNqzSB3bHb9aHywXH2mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core logic assumes zero length regions don't exist.  However, a
few DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and
DAMON_LRU_SORT allow users to set empty monitoring target regions.  This
could result in WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel,
and divide-by-zero from damon_merge_two_regions().

For example, the WANR_ONCE() can be triggered like below.

    # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
    # CONFIG_DAMON_DEBUG_SANITY=y
    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/targets/0/regions/0/start
    # echo 0 > contexts/0/targets/0/regions/0/end
    # echo commit > state
    # dmesg
    [....]
    [   73.705780] ------------[ cut here ]------------
    [   73.707552] start 0 >= end 0
    [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
    [...]

All DAMON API callers eventually use damon_set_regions() to setup the
regions.  Add the validation logic in the function.

Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260628005723.28549-1-sj@kernel.org
- Use ALIGN() for end address.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260627170057.1867-1-sj@kernel.org
- Fixup the commit message for how the fix is made.
- Do the validation with min_region_sz-aligned addresses.

FYI, this fix cannot be applied as is to the commit that introduced this
class of bugs, because damon_set_regions() was introduced after the bug.
I considered making three fixes for each caller to make the backporting
on the old kernels easy.  However, the first LTS kernel having the bug
is 6.1.y, which has damon_set_regions() and all the callers are using
it.  So porting this to necessary stable kernels should be easy enough.

 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d99f7a297fdde..949d5309d54d3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -356,6 +356,12 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 	unsigned int i;
 	int err;
 
+	for (i = 0; i < nr_ranges; i++) {
+		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
+				ALIGN(ranges[i].end, min_region_sz))
+			return -EINVAL;
+	}
+
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
 		for (i = 0; i < nr_ranges; i++) {

base-commit: a5e5bb743e4c174689e5d57b25fa8c78c49546e8
-- 
2.47.3

