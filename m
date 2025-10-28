Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C085ECCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C1E80154; Tue, 28 Oct 2025 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5DA8013F; Tue, 28 Oct 2025 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0669A80154; Tue, 28 Oct 2025 10:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E20B98013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71BBF140139
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:05 +0000 (UTC)
X-FDA: 84047689530.15.E95F724
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA11A120025
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=maDouu5c;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ul0akWBgQO9d8PYcmieApSptZ1K1m0W1WjLnOQW3EIU=;
	b=D+tFBn3fxEPePHfgp7IJXNp9WQ39v7aWMpTLfWdhLwBGJtgXY0xQe56skgbyOweL6cE1Z5
	UBUWuS7bV/W8tMB6Rm460KDkO+r7NUPiLaarxxDg2gLSYjtqBU9Zh7axbUOZtg6BIfWEXk
	pb09Nsw9UpfrfgDrrXLROk3/CgGokoM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=maDouu5c;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660183; a=rsa-sha256;
	cv=none;
	b=sGuJTpVf+DHWAmQloD4TPIpNHo6M5LmHCdR7D+9D07iS5rVMTTE9KuoGaYTA7MOBrf5pQ/
	rJr/W0JD8W67tQ4p7OFfOwigKtIWGQeiansny3uebF/+cVmDmGM/ZKsRR4h/IhFNCo6fM/
	/lmAmTdu+Sr8LVWhpqaXsPD9+ZsAY1g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ul0akWBgQO9d8PYcmieApSptZ1K1m0W1WjLnOQW3EIU=;
	b=maDouu5ce544NaChXO2olwlSoJjFWIOouCmnASfkFN706sflQURVJ7rfqaMcU+KKGFzR1j
	b7Gq5siNpsBiC9GDc6Px2VT6uFOE0GtMoXgS/KvQOSx48h4q9XxMHVQ0aMWon1S84m/pky
	13xFZW1Z9O3abQIUUWzA2GfMn4SyxBM=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 08/26] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Tue, 28 Oct 2025 21:58:21 +0800
Message-ID: <f62ef59c751a710b0e1adff07876c02942664a7b.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA11A120025
X-Stat-Signature: gseeukxus5qdsnaktasq1zsww1n4t1cc
X-Rspam-User: 
X-HE-Tag: 1761660183-719492
X-HE-Meta: U2FsdGVkX1+Gx+b3U3O0KZyqgLncIlh/CIGKsoJA2wmghvEM9b5AiPXJowREKvKYpX0jfLosvPaenDdvQac5kuJTsmjzzIefXH0wQNjnQrYacKYrrnWkhKs1v0e6RrVpNvND+z6/D7LSmt4iQCuq5O57Ar68eOQEZh/W9vq8fY7fzOqFl0JV4Drcl0tsfuDpkPaG8CrX7WfaT5m8wi/jO+dvZ1OR/CCeOaaCFnbLMRFk5aLGiiW9N94D1ExVcgA+IxLuhG+taNWNuEPEQGS8yjCj+m0HHWtyWTmYaf6M/7YyziVpW09lDToEn8dhYqigPPwQndMhbT9fo4Si188inIDYAKPw4UnjNqNc3vgLxa161OtR7mkE9m4OSc2ec+ajchhHZ2VWsydxC/PIvxopDVhmi4rAGPt9ahrSvZ7Xb09p1Zp07oLCgh/WlEf9VV2Gum62u3Z55/nCspjZqqUw32wv0OtX36vOVVeB47FjYZjZ8f8TTvv79boRiVfz9DUM0eIhvZuz8ro7GrzdKWSnzNs88HUpNqftWdwXB2ZxZMiWNtaaRPs1PSjhskN2eOG6yIl4dB+zqCAS+OsEKypI/a21J/bQSaANUrllkoEe3He88xGgsvVUjnDhIJqO7io6XWRP3HWwIEMfaMvgL/gUeXPtwNUcHXAuCbh45DykYJZuIPidPk3PrpxI1vPgP1OHoCONywomNBZwYpbzOe2k3tGtBn+MQ5QedrXjuSFbPvKahvlecDO6QOYdF2xroXEPWUCTR9qU2UFbWQ9f+Ky277UUrXPua/W/bCExD18batVuQGF8XcxuqArTyJUnS2Y/NT2ghgGy+ScbWfzXH2OP1LXZM6lfFrsY9A2N0HpKSwSE/BcqmCxq5SQn3zOwGAVJd7lRmDLyNeXEZF8Nk7w3pn6AI31Ch58e08wdZsPL1yEArOD8abSz8IRLqWrd3OeYBWV1vQnUGFZ7tYgtgFc
 Qg27/bLT
 S8O6ocpj9SknS4OSz95uFIhdKlmdYvG0PmbBFGMlO33MsgyC7aiFjx9eXr0OhGkvUHeuQ9/1Hs6+Wo64FFNsK+/QdJmvv7hwOfI6UOyZAJkSUMBZ3b0k8cJiBiEZ39ALr1xUTiHXEGkPM0yBUs26/5MJ6cc81gGW6cQz7it24FR5B8EWM6fRmYHzUbpUbagH40f1WT9sVSFpSnvdHjYnU1kbXMpsrQcnSY8nOJRN1JXcxbpedJeYZsloagjTNZ3j2ausNaRZxahQ80Io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6a8752f7bbedb..bc93d0b1d0c30 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -925,8 +925,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -947,6 +946,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


