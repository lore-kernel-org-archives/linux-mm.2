Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D281EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C046B00B3; Wed, 25 Feb 2026 02:54:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573EA6B00B5; Wed, 25 Feb 2026 02:54:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4766C6B00B6; Wed, 25 Feb 2026 02:54:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31BFF6B00B3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE33658508
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:30 +0000 (UTC)
X-FDA: 84482216700.18.F9D547B
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id 31C3F14000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IoHzQvlA;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuGdh3NsMuiZscvyzRC4/MBSUBTvm1soytMKG+347XA=;
	b=oMDP571LjZMV9laaJ5+Ag2BjNUfYNDDU1/nh3ezlAqtoe8I5Wvw5HNrjbXz+ohHCqpFnST
	NWJCJzlAvjSXuTt4SsNrF2dbidVU9rfgrGWGcNnXf2+B7qUFwQNK9lbkH1Od+dSoMMvvSd
	iNhKN3RRNdsF5OItZ1OYaELCNnYK8lo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006069; a=rsa-sha256;
	cv=none;
	b=5Qq0R2Qf1Pz+6WOX4GHMa1rXxrhlxDod5x0jdZbrNoTurKRQziUmMLL93MLls7Q0wWcUxu
	UbMNHXe0brF/AqGNdmO0zWWFA3wSfOddo0YApTzfK+YPwk5cCt7lglTOTSFj7DlKXGlPHz
	YBL5rLyIV9KhiYrq8HsEqcqmjFQQMeY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IoHzQvlA;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MuGdh3NsMuiZscvyzRC4/MBSUBTvm1soytMKG+347XA=;
	b=IoHzQvlAdr4rD+FD/M5TxeHkj6Z1Yf3Bt9mMo1cNdw5GWe/sW34+7poVSghcGyT342IZtt
	uyNiSKWskcxowhg7UNCTpsl/XrHNJXDbnchSCSD4L3deiGKznqgitW3WfMW3V9dYHDj12n
	d2IHaA31CwO+7R93t9aiC9+l+QHv1oY=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 18/32] mm: zswap: prevent memory cgroup release in zswap_compress()
Date: Wed, 25 Feb 2026 15:53:01 +0800
Message-ID: <340f315050fb8a67caaf01b4836d4f38a41cf1a8.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 31C3F14000F
X-Stat-Signature: iujksbzdxngz1kk6yomrrfwsgrkyfjtk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772006068-313029
X-HE-Meta: U2FsdGVkX19Lnm9t5MmaEBD3NvVNbDSQnUCZcwpzOy879nTWPxW4jHp1bFft5iLsazlC4+CgCiirI0VNp2XGRQLJfwtJiHm9goepc7FJqHAE5JTt3GwWI1MdVl7CYopiWrDlLuGe6HHkwpQ4F/Olfuu1jnqO7RvMVQ9YPdaSnINcoZ0a+3YDmo4QKMyTj4LsnmlTyl716lfxHeqvdFwAcfx025GuQ2O7eWhK1zIPfvdLG1V0ZVht2BoIYPFOokQerblGA0lpvMXrWNQbNXPZq1UTh2JhY03zJ5Dju1HOxy2WwJXJvrRhQ9Yr9FuJlWy0WIv8LTFXQx+Ry/GxSdAIB6YqPjU6XYBBktceFsZuDZMAXAiFazZ/o4MRfQfG22Ou7fvFuYydn9UF8yQvdSq7l0mLYuKW+OsZz0FT6A9Z2ftMVRAYO8w+S0RVWeWqsKaS/3U24IxF5zvpLR5lkk1+yC/jXLH6NcKsY9qk1VTsXGk0t1q1IrcGvSPkgpV/v4D+b5xYr4MXixFZai2TTRkbiEUw2amhpUyXKgqE9qRhmxYSPEOC92AikV/mmA7uG1lSx3PF30NhmCcpzZYJQVdyYv66fZC+YxdpRtrK0MRj5ecyKIH+F1aqFXM3Vp2lFXrkvKoFcdUi/vFODi2iaNZ7NJdlRqUP1UcT5ld9rHAhqlpJWGY/rdIdkBV0NmklUShXBUAUEPmAVMLSIlS14E2PkJpMrKatQ4CCZLPgP7hvWFZFFlNsbJs8pw+eOxto/0sm+FTuUrl9LGCYDTV6FPqjnuTRlqvY4F/oAMzAVh6JMrROgOKb08Ug9j0J7wpiJHgIDdn/Ov5WGO0SnivOpcyeIk5i/2OGOv97cS1CQV/Wps6ZIzHVKdPZw3IRtljw+39VPV0Vzea386h1F37tendnYooqpgiZL+k4FqkZ9ysA09QaFIZW0rMVJe9+sxs+/OW5XYcJC4Z0QTymBei76R3
 YLyfN8dm
 Npk8qfKGp7KJNwwjPM5jZgkYKc3Tld8BEItetWH9AshWzXhdspVpfYH4eB5ACF+bCJ869fFuo4mo3vL9VMop5VgDhpCKc6VRfhpgoy7o+WzI3Qpt3G/w+uNyNhaxyDGG7ylUhfrSnstY5qLTrvgECRoLzKhg9HpUs/JyAvraw6xRI9gM596SpN0KUcW7ZFQ3CUoKOPTDkJoSOkj2xBLs0shAtj3Nf8CZtp883q2Y1YObyC+sJbFZKRin44Id22ZUzDoDhmxQgtiHKzITNvoYyRlPRLvvcTBrvn4e94O0myTA6QzHP9QJcC3ChWiqbDdbKHFPI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in zswap_compress().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index a399f7a108304..fb525874a1b6b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -893,11 +893,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
+			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
+		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
-- 
2.20.1


