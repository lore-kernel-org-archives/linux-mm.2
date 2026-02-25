Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DFCEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7974E6B0093; Wed, 25 Feb 2026 02:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E396B009B; Wed, 25 Feb 2026 02:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A796B009F; Wed, 25 Feb 2026 02:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 563946B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:53:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10B4AC1504
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:53:39 +0000 (UTC)
X-FDA: 84482214558.23.32D9503
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id D283140012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:53:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DkMMUtTg;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hyqbb8F2NRNHHFp77Ms/+jViunOCmw3TEFzht4PTD4=;
	b=ZT5xWOdmTX2c3wQesBuBVBLCvOA4xLMmlGkPPxoLA4nrXjBIzY5kl3049EzqVNHs6M3aV/
	1csfjYV8zdUtWqQQSvGx+LBQ08pUSoYe2rlUfLCaaPapQUFrFOnH68tOUjZ4vvS8s0oCxS
	QDBHb5A4fzIjVpb3b98YFhnnsYcgIA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006017; a=rsa-sha256;
	cv=none;
	b=OmyFlJktxdAU3vujupVl23FInkRA9wUTOvkRL/81RSmkZrkH4MHKLHI8PGezpuGgyI4Ndp
	eXccAIVajc1IpTepjP/Cq9JUgZbF1xJyu+giXJwhWetd23S6tEj5cdMiKrX99vGyAd8u4M
	nlBLSKO/dUu622ULZVxgCkiLff1GxII=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DkMMUtTg;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8hyqbb8F2NRNHHFp77Ms/+jViunOCmw3TEFzht4PTD4=;
	b=DkMMUtTgybWNa/0ty/FNauhU0rxC7aAnYGYaV3c2QbnRCJUGqb0/mocAAWR11N+NIAcKyp
	9/LTK3ai1uHLmFYnS/DpH4K2jx5HxBvsqUcHZHY3IMIoJHPfKViPsYmSkiRPd2rDc42pkm
	zF3Fdl1HnvrqSq41i5dL0qJq3DV//60=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 13/32] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
Date: Wed, 25 Feb 2026 15:52:56 +0800
Message-ID: <0f156c2f1188f256855617953f8305f43e066065.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: mzhxy447ux93r3gitr8qbk5zhi7zir6p
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D283140012
X-HE-Tag: 1772006015-941035
X-HE-Meta: U2FsdGVkX19UfS41SQOqfBPRWvcGQew9GaRciDQsbmRoURdWLcRmPx+9s3hbc+mDVZlw6Rwel/ugqsQflMxE+5wegUc3quBmyCEEgLgH7FasGXvGazrpDvMBWiBnjKVr3iIT6OVEihOf5+XuSgXTqJVqMnQz3+h985wGY6i2KEB1pSAVPQtXyAeQbG1qbh4ahwLy+DvjEh8Ovqqn1ItDqV9DF/FUp5XOYsHVyS38lu9hfSHev8DuX0IgV+oFn5Cqpb9sM2blx5fr6FG4r+cnaDoeIQxppsRS9/Wuns9ajdGmg6OYrLKhxLTv7tOs9g34PZgs9Ikr7mtSN0VCYv8DuBveR3ZZ3C4d6w8L5qNcUJhvKJyN2VAAFXV7ghF1MahPhutbHXfQnkTYHxHixRpJg8TcpMb5PxmMWA5fLn3pvPH8bEhVvLMQzR4d1EZURFMczPl9G7UtDEOkE4CYHnQeT+YBj0BL25v+ox9wTJbr79T09EovJvDXidtaWuEZAPoqzMPsQJTHm06yDQrLAnZa5shQzEvUhNQV8wKL15PSHG4/Z8hK1eRM1/XbXqEnPv+nsG2Zz5f2hpw6iaatisBfsVaUDyoCo299ddn0g0bdD0MJq91SMFtJasS7Os30U8RqK/bZYuiLuipRx0ow9O8OKV9Rq2JjNST7V8r3yTaUyxpl/es4FK136qQniq1AU2vaaaULZX9NirFxVexHBHRA4OHutgnQ7YfYL8etUgJ33WKyausXlJlJ819oYmpuQCZeiK9bEq6uY1KKJrkC1wPffyDXdfuXgVPzxn2mZVJI7Li9gv7WPoo9CpaUBXKjFfSvCnIy43/xsInhyI0Sg0K6RnfvUNejxXyF0/zFNA13sK5Lzd8XSA1enmVa3uGJrW0YMkiIwssZGj4lJoiVbeGd5rAfN/JCEnmT8lECxFpy4mPH8/0RKJtEYGpFuc1s84Ze8vd4eKZpJ1Os0SvF2Bw
 4nx6Ww6N
 W+eYy5dHgR6IhyuMau5ZYL+NOiatN0wdKa0QfhTL6GSXmWDqmiUInrHboQT9MOCSBqkAuOo0IgKawdUxGqb5X2yr33kH2VFAv0+ukybDPlnAGTJp+Ulcs3mgKhNT0xQogN9rEEAeJE0MEYkVt+KimuH+l/1IxFkTNYEBUpZHuPyA7CW8XpUK5xNTXjhTXvcZgadPdi6GrD36Xv/mdsW5RNl40bbBNxiSYkKEr/h2TFuko1XachkuA/Wyy6i2PibNAP4nNNlAvV+azU2tmANekFUgE6+89yCs1ZbbfxMHQze9g0eoVl69LjMUGIUb1bOjZwTQt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In __folio_migrate_mapping(), the rcu read lock is employed to safeguard
against the release of the memory cgroup in folio_migrate_mapping().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/migrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 6cc654858da65..27e6103037c29 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -672,6 +672,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
+		rcu_read_lock();
 		memcg = folio_memcg(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
@@ -699,6 +700,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
+		rcu_read_unlock();
 	}
 	local_irq_enable();
 
-- 
2.20.1


