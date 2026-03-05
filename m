Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 819EEF30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6996B00A3; Thu,  5 Mar 2026 06:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7806B00A5; Thu,  5 Mar 2026 06:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE42F6B00A6; Thu,  5 Mar 2026 06:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB96E6B00A3
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:55:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8360B1CE1A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:42 +0000 (UTC)
X-FDA: 84511854924.06.988B82C
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id C55DEA0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VoyQbhDY;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/198v9MPJs+KJCrWZ0LWBhkz6feBqnUHTx73TsS3q/w=;
	b=TMpr8+KEmszMEwhRqgsayUgslrENslCTXQD2TzUo8nqI9GqpH/IGx9atHFI9tUdRJ5c4v8
	IEu9yVlffvfqU40ttf8cUIORJnWxRTolaHh46HJ87WQENLMDVCB3RBPc8CXjg0gfd+MCcp
	VLyZZmdRR753ezh6ca9PSst0LrNA7II=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VoyQbhDY;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711741; a=rsa-sha256;
	cv=none;
	b=WG6YtSXSTy7aUOLi0VhbYhEBBz0XAt6ur7mZGuAwPR4fLEpU5uixtYQ+nvRVSvH9Qj7J0y
	i6qZMlDrHTn2dNDUbQZGNqxVgmTpx4QboNo1sLARoQf2wr7Qt9YoE0WRtXtarPs0csyLKe
	U/CyNn+dx2974jJste95eNejbTYEoVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/198v9MPJs+KJCrWZ0LWBhkz6feBqnUHTx73TsS3q/w=;
	b=VoyQbhDY1PB+RM6iyqZa3x0Jh2dPgk7SFfWgibufrQHOlTEslOuFJAu9GjifThbapQVtua
	GxytC/w0MWXOIowX12iVAw+ZNgiQLCSKsK/Hzk8l0BRxSt7qQuQ4Vtv/zD4rGjWM/S56PU
	xD1eYLKZAhEzrdgXKBHIOReFT3GAaA8=
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
Subject: [PATCH v6 09/33] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Thu,  5 Mar 2026 19:52:27 +0800
Message-ID: <d6d48fdcf329c549373ac0a1c80fd9f38067e34e.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C55DEA0011
X-Rspamd-Server: rspam07
X-Stat-Signature: aujd3j6zrhjhgy7ebh9od95b58gf6mn3
X-Rspam-User: 
X-HE-Tag: 1772711740-873195
X-HE-Meta: U2FsdGVkX18mf4fY+AFkRFOEMlkh3ISU3gmZYSbfkPm0FP8tD2rLFAuWhS328Wz/AIISWKb0jvzyRgcAcbXB4bJg8KiUFw9zY5ZZ4fDsSy1GO7o8hYTfL7nZUxHO6A/1RFj+cuFeM4JZt7PR1fY9YF+yoLe+SWZZ4pB8RARm7435w/BXZpQbEuZvjDWQvzDCg+VltBtH5rWvoyK/yFGclqQ8Or+RJT/BKcSbspSikXCDcIwHwxM8B86Rj2qoBQ6aarIUa9E42l5w2748e6KzMnZ5XMjv74kimBPnrbFNIJsqi3iCx9sVka0PCR1hZ4VLWftomd0vE9q58KTmQX8wpGVVqMRRACAGT7osC9Ccj9C1TGD0Uht2DXlubKSjtYaPeJtDQL/Fzs8G6j+qqMlb+MxqVQkrJkBzav3VUCKYvBKfH3CLuJchqY7U7MYSr3o1fAZI3GyKLCbaXO8Uos+Go9fKXnbiUTF0e7Ti95iuDeCUzrBXDsAxXsYTLcERkSS29qSsXoK5uL2O1AJoEhzmrS5YA0cNovVzyxYkKVLSqWqqtZovQuY6ev+hcoUNn1w99t4xirzg0brlDWnkGK6JzvUwryUie3KzXWdHYTmVuVp4lzNe+dNqDeB29mnD3+71qdK0umtiyyNyr5Bxx0mdfLjcb49jEPadWO/o4SM48cZyJHadswOVLy3DZ8KgnAo15+lb30HyNse4ytcMHZzscWjwhRdKpDN577/NtE/o9U0mOjJBpxSWWjinLh8ccQKHIvshv05Q/Fiz7x16m2HP4uM1s+f2wdwoFYKN6DplDDzb1SFrbdfUVp1Lr36oHIrZxW4uuzHxb1lMcLDjBZ7hOUSdV9SlrTtvrkHG/q1WAKoYRdcOgbD89SuklPsa8cM5Abjm01I4Mrim/O5xwGKuMw1reUgdTY3O5SmsVBvkHY0bOlk30PYuINd5STtrLa8FvAMUuUr1NsYnjZ6hRyO
 iA6Uq5Nq
 Eap6u31xyL34+QutmcNAwclMtgH0Ne7XiN0UpdwMhIoCKnZM7pFcHHhQBcYY/hjB30e9B9RXohZBGEGcZREQWFyTHT/ldXlrPljn0Ofvu0XQ84EI3jkFbKwF/wc7FWhVJndmymVG8za92VbDjnZALwjo7rLR/ON2oPACz0s3HNkwSbTjYMoG1Q3cJqDHKcD+TFZM+fr31EujWfeB4Z/DMczv+OH+9li6Edl42SUd5t69HR8fTAyVDz0IXAtkN+n3+aMGpI0O4hb+JBE9b4i0ntLMPeecFOZYmzvb3cIsfgJ1rdJocU/yiPQFx5+Kffp2ga0Dm
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

In the current patch, the function get_mem_cgroup_from_folio() is
employed to safeguard against the release of the memory cgroup.
This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba574..343c97eab9e57 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -922,8 +922,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -944,6 +943,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


