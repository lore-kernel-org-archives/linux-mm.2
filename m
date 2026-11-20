Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C0260A2634
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tv5T4EdS
Received: by kanga.kvack.org (Postfix)
	id C1E936B00EF; Fri, 20 Nov 2026 14:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF196B05B0; Fri, 20 Nov 2026 14:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD776B05B1; Fri, 20 Nov 2026 14:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91A946B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:51:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C6B840159
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:51:03 +0000 (UTC)
X-FDA: 85456540806.21.E15FB9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7259CC0009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:51:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tv5T4EdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795204261;
	b=T+75J1ZlrZLowUjrK0kIYDcwGcN6sH8OLlfG9Iq1zvJzleagqgGTYet53aeGNHwqv2Te+f
	0yNGQ42/qYufsIvaMwq7n29XMx+JBfyyb6s6TtvneivYKfhwIbB2BmmmNBs9YkZVXsFUlV
	7Wxc9QfM79AuORYUv9UQf5nqbq8XOgo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795204261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qvtZxwS6aBvafq8naMZLaT6JY43Ysb0JUYqUGkLxZes=;
	b=sGOngbe06GpNbX9ey7Sp9yFBgLoYYsF1B1fMnCOzX5CBbMVtwamRLNyERVXVm04EHTcT5T
	0Yis5d5KHJLOfK2aZfP4W43MyvPweRHFYn2OqqvKIl5wvIIqq6OKvl+49V6/0iRCh+itdd
	1s10MlwmqdcrV8i9CG/W05EhNQ4n770=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tv5T4EdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 533FA4642F;
	Fri, 20 Nov 2026 19:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D897A1F000C6;
	Fri, 20 Nov 2026 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795204260;
	bh=qvtZxwS6aBvafq8naMZLaT6JY43Ysb0JUYqUGkLxZes=;
	h=From:To:Subject:Date;
	b=Tv5T4EdS8xlnjAqJgA+EoHWrBpxllAI25gggFzEvImjd95LdGAimVeUv94M+YAodg
	 Mn3kirTrVTk8M2LHAmlW3baCLW1zTRHgDFcvwGivleEykgLrmJgnwm7hvzoISwPUHi
	 f87bTP9tpgE++wnAUkgZ1hsADpVHGqLkzGmuu5LYmrRluoW1AwEnIn5Dv/eQg3jysf
	 bYJc2n1jMO6ilgvSLB1gmO+P3jQA60onJDruxwVp1dbrMwePuja7pxUgfZ5zIvMrog
	 E2WTK7vuot7W+bLhVHkXJ7OyTQ5Yt5Ido9MN+Aeez2xA/nq/sPNErrh/DiZDchVk9a
	 Gc2ANcwhiE8DQ==
From: Chris Mason <mason@kernel.org>
To: hughd@google.com,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	qi.zheng@linux.dev,
	qinyuntan@linux.alibaba.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org
Subject: [PATCH v2 0/1] mm/shmem: don't use the memcg of an uncharged folio
Date: Fri, 20 Nov 2026 14:50:57 -0500
Message-ID: <20261120195057.50031-1-mason@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7259CC0009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 9cb1s4k1tah6fud1men66u3nihwryzkj
X-HE-Tag: 1795204261-730792
X-HE-Meta: U2FsdGVkX18vvvsuQC8n/YiKwOpWuoVxtnRuKxa29lsVL4J5z/8qYjdkpK+PReksls3jhM6ym+OWFi1xbn36ww9BB/PChkORwE7I8kSp2U82sQQwi6p1hrqMmRfBPRur9S2+w4fOiU1Wx3oZ+fvanw5J0xWmD9m/eEYmrvtm28ZmaIxhhMAbUCchUzcpPKPu36rstt+qKu9+5sI7wEyhTN1XRqhwJ+Bm9+Uuv0ZDVtmSOJcQZXFGTUwnfGsZfNx7ytKFKzEhM5NjTyVv/AtFRZBYLlzhqRppRGFHsD0o1pEZuqE50hzSAbivUj7ny+CTjlLfNnaZvwMJou+wGLOQBTstQ2FxEwPEQZfkWAn92X5PY6UzytpQ4iUcZdvuvVyvSsNSRfEAFGCITGMEMglUUU2sFzXkIfrJFIkdnlwlkwZcfgozTVISwONYT4ad3Yh4bh5+Ky2EeWvHoIUeK2jdoYWrP7iMACGKtTFRzHvI0J3ZDe//eyA0xsF7WMy03WYnJ8V1yiKW0nHwcBf7/xsDLlYQKGB90mXK0g1rTCeOc05MkoB1uaGRwrrNyX7C/1Uh+nFExC8VAjBKfk4oZxsesR8q38VybgGTvY5eMwRrcq8cOYWwjymrpgVuV1Lhe1zJr5Gl759SdTcLTEyCamcC0pHMMYnvAg/eEZdDbUKoKGdsG0IxyFBgAJPbzgXF4HT1+qCfeJEBerFjGdcaPm0Uy192W588Esup8tZeLTtZW0m9BO3WkVyFvhzgKoSnab5J1Mq0M0PYwkCum1ro4QOuQ1Ctj8hOBMEVqqwQziHQkKQQ5s8Qiu99CYouElx/9ld3vABRLqRTP3iWpszYGSIehZbgzJrDVQosAMds4wxjNvCkgbrZkTGf0aY+B3Q16dgXYMvSNmFCgcS1+bpiIvrKwgeVGYFdzi+HSRvoZRNeI/juJDuwwt1nxMV8EsIS67/sCutqp0KstGpMMg7Mfcy
 I4LOY5ZH
 BxzVfvyLz9d6ece/W+U0RIm/9WKuGGbxfSWe3zLwkNWVU52GLpoSAvSbM/0WE4Vhg9geb5uZsg1Iokd07zn6sOhWSPThoFBwLL9kunoHsrWmk32iq1YVeRro9mAk2M16HTxcwFzWtXeg1/Qz1MPIQBFFTaovXnGcjIuU09Mk9iQGlASaWoPNupy3cHJk1dOkuk3LYO0oFyvccxL1lgJuFDtPXlhylTCO5vwb5zyLPlPJC233Z83Ywp1DHa1D0rrX2KFpSHGz7sKzvR/KLboLz8MESj8iwpoagQ6tFK9xKu8Hq5W7wRwC+xuJm1tG1NcyIJFdy9wNBZ0GEhOJKYWXklRWXeLvFqsBGt/gW1inD4dLUYcN1BtILT9/RXs3OS2Kofudonv2rYA9KYqKjRGY9Ca4OlgndcWlP5Nh0GtzGlfEKXNbJ2KY6OoRuqlDigLJ25SJo1/dUX2DnR8AdP2ay89XkiIQEZLEyrDYmACyjPx3yhEjW6wuNilRu7GNhIJixhGvyc90JnwPetE4oviws1X2Eiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everyone,

This is relatively niche, but actually new with 7.4-rc1, and I would
expect it to trigger under heavy load with huge=always on tmpfs. We'd
need to run out of room in the tmpfs or reclaim memory while huge folios
are migrated.

Qinyun Tan's pending series fixes the oops:

  [PATCH v4 RESEND 2/5] mm: memcontrol: drop kmemcg_id and use
  mem_cgroup_id() for list_lru indexing
  https://lore.kernel.org/all/20261105092233.3558950-3-qinyuntan@linux.alibaba.com/

It makes memcg_list_lru_allocated() accept a NULL memcg, but I think we
can still race and corrupt lists instead:

    shmem_unused_huge_requeue()         __migrate_folio()
    ===========================         =================
    folio_memcg_list_lru_alloc()
      folio_memcg() is NULL
      no lists are allocated
                                        mem_cgroup_migrate()
                                          commit_charge(newfolio)
    get_obj_cgroup_from_folio()
      returns the objcg of memcg M
    list_lru_add(M)
      if M has no lists, the inode
      goes on the parent's list

    [ later, M gets lists of its own ]

    list_lru_del(M)
      locks M's list
      unlinks from the parent's list

I haven't tried to reproduce on top of the kmemcg_id series, so that's
all just guessing from the code.

v1->v2: adopt Qi Zheng's suggestion to return early in the failure path

v1: https://lore.kernel.org/all/20261119193656.88678-1-mason@kernel.org/

This is on top of v7.4-rc3.

Chris Mason (1):
  mm/shmem: don't use the memcg of an uncharged folio

 mm/shmem.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

-- 
2.55.0


