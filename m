Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ADAD606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uW0yxWCj
Received: by kanga.kvack.org (Postfix)
	id 2F8966B05B2; Wed, 28 Oct 2026 06:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9DD6B05B3; Wed, 28 Oct 2026 06:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199776B05B4; Wed, 28 Oct 2026 06:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0DB46B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:41:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47D411C46B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:41:21 +0000 (UTC)
X-FDA: 85371693162.08.2B58043
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf05.hostedemail.com (Postfix) with ESMTP id 459AF100004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:41:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uW0yxWCj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793184079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ohDeqYAoftxje+G2/ZUXITZjGtasxeCYee/Ib/dRfM=;
	b=u7MCZ8XjUhtGd50NgBSjBN4vt5b+ZiNAlFGLlklbWca2rJAeRGNoCeeqOU21r35MM3Hyi1
	gc6uncJOm8EyQRFoHYbYTv1o68yRf2/SCrIaPd9d+jbPxZdsp8o9Lhgoc2TJgFl7mcsdek
	hKMVVG8GNFkXL7UtLTyz5lMspUNILok=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uW0yxWCj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793184079;
	b=0EDpUFFYmJyCiwtTCMGpqAO6PDIiqFoiWTjO52B7sDuHCbRcJOgM+5c6R7i5s0od0wRjkE
	yMeHC6VG7+4yxAiGVMeMWmMAGgA4tkiB4s96LDBnh2v+oLtr2d0TWYitilgtkhxyzWJgIv
	cRZiUbl74L/jxUKp6kMrDIu+7dbqunM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=da6hytzw+BnB+C5CyqKjthZJsFrZnHpNjbdkzPMyrmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793184074; v=1; x=1793788874;
 b=uW0yxWCjiuY/QAk36l36xDIbaSJ/T96tA0HP6WqCEveTeJBUYemWYRj/4Kdrl9erGZEE7or5
 sUiXKW8oNGaHZWY2AFZKIRSJoe9vBiTzTCKv4/3aisN/9I/naSVMw40cQwofFWY2LRNiPMMzlhF
 fBex+2wJ8adqN7qch7lrDyRo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b2f499d91e478fa4;
	Wed, 28 Oct 2026 10:41:14 +0000
X-Mizu-Trace-ID: b2f499d91e478fa4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	stable@vger.kernel.org,
	josef@toxicpanda.com
Subject: Re: [PATCH 10/46] mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()
Date: Wed, 28 Oct 2026 18:41:07 +0800
Message-ID: <20261028104107.31470-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 459AF100004
X-Stat-Signature: ehnse64iqdwwrcdc17e65p5abs4a8e1d
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793184076-734637
X-HE-Meta: U2FsdGVkX1/z/J5JERb/k9gZJHb94+g48rrbSnmIyQ4zhEehDa3V7lBXHtPVUkFuz9xTzYaK4kgYRGgRtsQP6mhB2qKzHXKGVmgjbQfudtGgl3YuCMupC7RgU3VJMhlx9x6C/IyVhGlRf4ma8XiiKuHL9HC1ZEUrEGrjWrDRn5heohmKmGZ4OyKuCAD25RboiozYCgqSM4nNSZYTtn5vgc2kb3lC9OJCzkfZQ/NXODktgy4luFjPhS/v/s/THkKn6xdIBfYO0JbvmifvwpqMuOIN1sp6OIk5BV3kAX6gyfLfv7D4V0tGFVdiigaJwOFTCpQi67M7kQSlgOXPMAVtwhCqhLp0wHg+0gYyNMvIWql2zcRUB57pBbDogxCRN+UQuzTbb2ujerSgZoWLFVUyvjKQ7cVUH7mrUs80o8vhG7T0xBMdER8vTx36CgLYwxmoazAyHoSZDeMTHoo4cyv0IbLPJs3sHQjLuSy15UjyMfNTOaZaDJV6Hb2YMlzeXwifWcp1VP54iI1mQ4CXHxZNuWFAj/EJYDQ633eMTwNLS8lAfcGPK8zvKeZAvay6Ev4DY2KfWnTJlZbauLhK2IbN7G6BOc6qmcBFn52bAbBgEavudl65cHNMmlq4iO49TARYPTzGbZnJx/zxS2kU0OWixQizti5IMOQbZ8vlfxoQGUwjU6G5PEtgO42Al+x4hwsRZhAw1hM1n74WEhVoZUj2uTtiBnZTPQpDUv/Fusgi9aQOFkIn8ZhClAjKk6ZgN1JUcIHHqiq7DM2hzgXCTigX7Iw8hzoHwjNjCvmX7zLlCO/FuNLoe6/O43ewouUVc+DMKXS2RNDcOETXbGidmudOjSPRxQorOXdPs2Nr6nSSxZGsHR/yP4pETadAAJHCvBu+5beE0Hhyjnb/+27X80ZYD2oZ1ZhZr83ykXwgfE3AALXh4QcficQIhEZzadGDYs2pHk3Q5rHuNCGB++FyBgt
 ZisFTkar
 jnHwuXid+64gEAJh/i25ekamsakYEg/r3NrE+rmrZZLODBnv4SgG0TwOv2ZlRn8yNzajHSx+4sMQ3GlqfL/1O7ltXRU4Ut/kdmiL+mHCI4NQfkF5GjDgAyHcgmXPxQxJmVShwglxTR3CQPO0XtnaqTJEt7nVbARMfO7wj206FtSwy5aA90BRknP4iiiqOKxMnOlpEn4wP9BXPL6tY8sQ3LyyPqgW+2qEg/T7H7lcnv8TrKh8RvJJ6ciSojHbz3W+gS0Lp4zNhS59QeL+TR0jT3htXRYxLpsoDEfk677AiVRroZsy3+bZ0vf8p3T0XgAwRw46x4aKhlrQZ9/T1jz/8qdxy6f6IXPdwkD5B1mnFVgWsaLKptVoChYbtx9w6C6ChQZQjHJblU0ABRiCwkOU1UDpT0gxM6Sqcb/cx0L81+I2Wftgn8TqYWnKbLBh38Drrg/04
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 27, 2026 at 12:17:30AM +0100, David Hildenbrand (Arm) wrote:
>Since the deferred split queue became a list_lru, the isolate callback
>moves the folios it took a reference on to an on-stack list, linked
>through folio->_deferred_list, and deferred_split_scan() takes them off
>that list with list_del_init() without holding the list_lru lock.
>
>deferred_split_folio() does not know about the on-stack list. It only
>holds the list_lru lock when it looks at the same list_head, and it can
>run for such a folio: a THP is queued when it is mapped, as a candidate
>for the underused check, and is queued "again" when a part of it gets
>unmapped:
>
>  CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
>  list_del_init(&folio->_deferred_list)
>    next->prev = prev
>    prev->next = next
>    entry->next = entry
>                                      list_lru_lock_irqsave()
>                                      folio_set_partially_mapped()
>                                      __list_lru_add()
>                                        list_empty(item)  -> true
>                                        list_add_tail(item, &l->list)
>                                          item->next = &l->list
>                                          item->prev = tail
>    entry->prev = entry
>
>The folio now sits on the list_lru with ->prev pointing to itself. The
>next removal leaves the neighbours pointing to it, and they still do so
>after the folio has been freed. With CONFIG_DEBUG_LIST:
>
>  list_del corruption. prev->next should be ffd4000000270090, but was
>  ffd4000000278090. (prev=ffd4000000270090)
>
>Fix it by grabbing the lock around list_del_init() so
>deferred_split_folio() cannot race with it.
>
>Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
>Cc: stable@vger.kernel.org
>Reported-by: Josef Bacik <josef@toxicpanda.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

