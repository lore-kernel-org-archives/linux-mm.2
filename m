Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B6A9CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBA86B0095; Thu, 11 Jun 2026 06:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675426B0096; Thu, 11 Jun 2026 06:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D1F6B0098; Thu, 11 Jun 2026 06:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE856B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:51:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C582D1205B5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:48 +0000 (UTC)
X-FDA: 84867316296.26.6D4D45A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34281140007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=olqx5g2t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781175107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Daz2QfOWf/vQwHvERTl8P7zu3X8BbDfgjfcWXtlrYHc=;
	b=nX2WV1V2mOMSoVhvtGN/6dpel5p0Yhs6MAkY+25llsW1Ct8p/0M1Av5X+NGlNd3xrxI0Gq
	HslrOHE2rbxB2P3kwZ7YlTcGLIu2FzNQJBLsM0RYYmiLKaqN0wd4uBVSJx+uJAt9dM3MZm
	Hi0cZJfiUL6A12eHLsSW2Dd0x8FFEXI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=olqx5g2t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781175107;
	b=oFtBw/c124doVsfum8U+DzTSBVb30aBqg4zUpTaGM8WU2l3wlEoMqOzqSe4ITy8NaSRO5m
	P3XqOhrR9JtypgJ7v/OUFYQyzz9at9ueC1SDTiekLUJGdAQ/hJ1chJf5YPy7NAu6gxbzPu
	vM3a+3OETmvWlYsAndlQnoE+0s9DFxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB88760212;
	Thu, 11 Jun 2026 10:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F8E1F00899;
	Thu, 11 Jun 2026 10:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781175106;
	bh=Daz2QfOWf/vQwHvERTl8P7zu3X8BbDfgjfcWXtlrYHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olqx5g2thmz3pld3Q7jFbx2ndbz9i6fwyVTfR+AQ6Rzb1j50Mgv48OaXuQ1K3EV3v
	 5Q3t20cNEy9SFZKKy0VAIxfEh5LYaTpcSjqrpPHvyh9tDUZ8cRfmHDeMw6H8msogmk
	 7oob3s1OHFpEIhO5kXu+tvEs0mPC0hYnDECqTTFUNeLR6h/pmm7heAhOc732X5CjMf
	 8q8AH8i9DUXWjZq+W/mjFNTyTkeWnw5CBE1xSFSeg7DktaD6q2F8yVdR7edeZALK/K
	 j8GGn8HUWWvpcvOD+PEAnpInd0nFSgpQXwS48cO+IiawrtSk6/yMpDuRC1qGMih4ZU
	 wXv13/+Gcj5Zw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	jp.kobryn@linux.dev,
	usama.arif@linux.dev,
	shakeel.butt@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
Date: Thu, 11 Jun 2026 18:51:24 +0800
Message-Id: <20260611105124.98668-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260611105124.98668-1-baohua@kernel.org>
References: <20260611105124.98668-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34281140007
X-Rspam-User: 
X-Stat-Signature: yrtby67wbuid71wq9wtjr4zbkbj7mf7t
X-Rspamd-Server: rspam09
X-HE-Tag: 1781175107-317893
X-HE-Meta: U2FsdGVkX19Uyan5gCnrA9tG19uauvoyt6Z7tpM/BkrAXsnopFtsIaCkAMS2b3EPNoJp7EOmB4AM6pM55lMCwLLSrvSZd4foh7nslfrTCVVYZf/6P/wVdQFbLnwLrSkBTfOuC4zgBKujk5rrRVKQVt9tQqaSlW72ADlYMPiESEzjNTR0/Ny+VRBYbtXoENXCnvORfQfjUCN7eRDNKRACPAjul7N7NK9WhN9mt29MhCwXWl4NvxITPG1AIJmo/fRqxCmyWz60kTUraZAikK1W2pbGyVp5s7DlmipL245Ynbk3b3iMaUQnNXz2ZymampYtOK0LloretTc+buXSeFawaPZHR/x8cBmTi/IQxKHZ2+RKfpxC/umT1dk0AwZh4DzMQKbc6Iy69nXgXA2p5yEo/L8VQRqy29J/MDrhEITYzy34TE6Y9Y/cI8Gla12946AUUFWxSC/g+wtNxkXpXQ+yGkXzt3uuF72ZI22vTdmdI6dbv5t0k36p22jOUI5WF8vwJGTwiJKbTJ7zZ8WlTlcdblulGYBM6yQsM1bENrza0MEIo9QC0nd6wFg1NFL/hEO8k6/pLVy4itJo+aFe6UppcxYH+7JpOkYkvsGEJ1Nx8RnoPAGVMLF37OHotqa+8ZmwJiXEetoOhIxwNklXJ/tukwPg34Y/yh4omu01Lqxd6mSXA9QAtlYec+FxIS3PsaeGGa4YMN9FKX+Wx1T97iyUlMYvzE/ACqcuygKx5LY3n32pzAhdMeti5eA9AbDIfwl81vAmksTjYQHLT+jDBbLLjjbuNtn9GCD75qwQI5YrAX4LDe7NsRU+/9hSnnDn1une7QSulQzTtK6NHdN18uByrqBviEtyE3b+Y5pz/rgylx88LBXnq63lHUf8cLgl6I5DmP3NITg5B+yoR1e+ydxWa19aCpqvb4Yg2qy0KrR0RbJlzbj8F86dO/C//N9QhbqPFa4rrL6lMvrutlC+6HE
 gt9JbRjm
 NSC5SvkSVbDguC5boLmyhfFalvRJgvJGI2cCL0rr51WDyVFkP1iXGTMjMMEMSsvV37RqChtE8iURjCPL1jTh5HNsPwz+6KValZw47EljCUFzRzHE4vZ4EYEDDOLza9jaHe/7gmiie1+bErMpjZyuzkWYVXBb0EFR/qGuJOsc5sdI2Wf4gys2LwqelEdFNQBKprh7rrmO36hrXKNyz8wkt1I+j/ybd99EqjvugoE09ENMXHbyxVRV6qWPWUb2Vrds5UnyGcPEkwfEacJ2X0hPapgOOfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are doing a lot of redundant lru_add_drain() calls in
do_swap_page(), especially for synchronous I/O devices. For
example, the test program below currently ends up draining
lru_cache 100% of the time:

int main(int argc, char *argv[])
{
        int i;
 #define SIZE 100*1024*1024
	while(1) {
		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		madvise((void *)p, SIZE, MADV_PAGEOUT);
		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		munmap(p, SIZE);
	}
	return 0;
}

Folio reuse now relies primarily on the exclusive hint, making
lru_cache draining to drop the refcount in lru_cache largely
irrelevant.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ce8ef27e7a54..b5a78670bcc8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	} else if (folio != swapcache)
 		page = folio_page(folio, 0);
 
-	/*
-	 * If we want to map a page that's in the swapcache writable, we
-	 * have to detect via the refcount if we're really the exclusive
-	 * owner. Try removing the extra reference from the local LRU
-	 * caches if required.
-	 */
-	if ((vmf->flags & FAULT_FLAG_WRITE) &&
-	    !folio_test_ksm(folio) && !folio_test_lru(folio))
-		lru_add_drain();
-
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
-- 
2.39.3 (Apple Git-146)


