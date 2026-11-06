Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA4D606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Brk88eoB
Received: by kanga.kvack.org (Postfix)
	id B6B4B6B05B3; Fri,  6 Nov 2026 09:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B434D6B05B4; Fri,  6 Nov 2026 09:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80006B05B5; Fri,  6 Nov 2026 09:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 818D26B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:17:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6FF3120D61
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:17:01 +0000 (UTC)
X-FDA: 85404895842.10.4FD406E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EA7CA2000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:16:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Brk88eoB;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uecgvdcnBS0ssXlLSJ0XuUQT+Bqc+3M+IkCyY0hC8q0=;
	b=mOqNKh8uGiLlAVJbE5DxmdMqh+AQ8W94XrjjgpMg+fUVymMjyOiiURb8yg2NNwDB5wYmi8
	dhWkKQ3oyPzSMuhvZHeHpQGsQK04Rk0Et+KpAwpSS/UZHZNeBNSb76w6nhtw6FqUcsDz3C
	g0vIDGRv+UO4SvN1525CsFj7iaOGnOg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974620;
	b=LkZgJ3IVJ3sJCjmVXldJxhQoXSwcWhNVQ1XnQBkfVudysk9vX2tQMxWKLXul5h0YHuulnQ
	hF4ei3aXEHVn/ZS2gRwTbBLaODPl3YoSCrJnlbT/B58a2Jy/oWt8jfg+qmQP5Lat3sRObJ
	wZYv7JGoPyHILVCJugag2odGG5recno=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Brk88eoB;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EFA5605FB;
	Fri,  6 Nov 2026 14:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B5B1F008A1;
	Fri,  6 Nov 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974619;
	bh=uecgvdcnBS0ssXlLSJ0XuUQT+Bqc+3M+IkCyY0hC8q0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Brk88eoBEtDsQXHFyYUp+pJODIzkeWJ06z1vTkD7owXBB9aQ8/wPo0pGvH6yQsk5c
	 xoOXKyjgBNAXeP0LWQ8hA3QYoapPGEdJa6mNg2MZzIHFTnMFGVWRjYbgYBW8+a9JZ1
	 3kqtpzfbks3i/5u2/V+v7aIvPewO0SfbXGxvrd8ioj7V9ZDwvukpLn0Hg9qBHba7cF
	 V8YGjZpxNJwgnuIbwA+7z/QpzruaITRvV6/mV2JHGD1UkIKdJMGiD8Hz9lZvGilZBA
	 L2rUTnvzcU08BQINjJaG+G5BnhpAHMDbQ46VcMXUsLX7KEYD3od5CTRhpwP+zshTzQ
	 VIbGgdz2574LA==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, Joanne Koong <joannelkoong@gmail.com>
Cc: shakeel.butt@linux.dev, yosry@kernel.org, hannes@cmpxchg.org, 
 mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
 rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
 baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
 cgroups@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261029204157.117879-1-joannelkoong@gmail.com>
References: <20261029204157.117879-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
Message-Id: <179397461320.8873.1139979903597807353.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:16:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: icnw46qjcdp6bmnsqi47mushrzmo5tm1
X-Rspamd-Queue-Id: EA7CA2000C
X-Rspam-User: 
X-HE-Tag: 1793974619-126874
X-HE-Meta: U2FsdGVkX18WspgzVbJ6b/OV9wcad1MPmWzUMew17F4qixeXfNGnETzQS6ng2xjnYJSlotZ/B5HvxhgygEN+vwbHoTZ2BaAQEzoByU+kmPudDsj2v3WqBn5bxLFPkpRpvhREf7bARjKiZp+vCajS6mUWUjUOa26Yaksw9DXKj8rtpSX2iQ6T1r7Swxhpb0H52FyqlxBa4r4x1pSEazOI4Dflp0o8tt75zcm21fDJRIXiwWJfORH9gan4POpFk5iaszVmR7DmNE4/m0Ot7cKY264UN0guxXFoKX1aY6f12b5sLM5OeGKAd6Eg1nWwpQ5sqtoJQ1kz8ZW/LMKicZp4CuK5Ltd2LxshOpxSKqFxfH8YTdHVCf2N4Fgq8gg0NEa8XUzO9DEuqwd+xDe0AtqB97jVRY5PrvBxhynrghboMxE5XiGk+/71JppV7QzMMx7IuHDnKU3HC6nhNvJo2kKrLNVGL9r5Xa0hmKfmZ7eCaEAYIy1pZupD12wMuSa9DeveZCuLtTdaUn3xku/xWFd78kHkFmLbG2vQd0rVIBmqChYWWTW6pAdnzqJPY6E2ummk1XqITnkzudEXluBlqCkBK6Ym5lWr5KH1lijuJ7J9I5tSeK2svaZ9HH7+X5TMHfd10yIFEkvUIYfreVWGz+3pHqKq6q637MI50oc1Vh/1jdo6znOvlxaB1xsPU/DH16h9Nm0IoweBt4hgZJCPoPA5Qyl2lWpZuVj56zYbXkDugVt9ZpH0RflC5KQYIpKI5vEEQ+rinH1Tyu2+Uh2BcGRo367df4GqOiC0jl/Zx488GkbNzFodZBenEYcNyZKzGsi/l8MFfO0Lsa+iBKVwLIcaTMQkCiyoFbs+VHh20w6vKzbbfhNnC1b0sgiFo+rx8ylwanHP6IDP3X2Xzp/3faMKBz1daSvZ/LCpqxp1CGHvgIDnQYfvGH6TYmWPdClpsNxyHBpK8vJPG1U1S+l6T7N
 1wAtyZ+T
 3eg3Z96MNsqQQGXHzLQNkEjTBya09DAMkiyVpUj9A7s/urkFGpywZ0+NtsHxQwEFzl/sZIzUDSK1yzx8CHeFkvGxgbwbF89bQoaRMVUYXqjApTUOe/eICQpEsOicCEranyfNpoZW3zBeNhlinsGetpM3VsX9RjvYOpygb2TPwvI3T8R4u5zSJD78oNArOgmzXO3Sq5QmpC8OY2AVmABdvXwGIYwEBdSiBPvDQF6zDUhzz77R/JtDoS7GeVUiwbDAYSt+0wh2cVa+7HT/cC6zyZw/8p4nvXm2DEV6Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 13:41:57 -0700, Joanne Koong wrote:
> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> once per batch, but they update the node and memcg lruvec stats for
> every folio in the batch while holding the lock. Only the LRU lists and
> the memcg lru_zone_size need lru_lock. Updating the stats while holding
> the lru_lock is unnecessary, and they make up a large part of the
> critical section, as seen in [1] where a change that added just a few
> instructions to the memcg stat update path cost about 2% throughput
> because the LRU stat updates run under lru_lock, and the overhead went
> away once they were moved outside of the lock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm: move LRU size stat updates out of lru_lock in folio batches
      https://git.kernel.org/mm/core/c/ee65a1da

-- 
Cheers,

David


