Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8830B606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AHVFcn0g
Received: by kanga.kvack.org (Postfix)
	id 9DC696B00EF; Mon,  2 Nov 2026 17:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3D06B05B1; Mon,  2 Nov 2026 17:50:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CAB56B05B5; Mon,  2 Nov 2026 17:50:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60AD76B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:50:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAD531C319D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:50:58 +0000 (UTC)
X-FDA: 85391675796.15.F7E4664
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 354B3160009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:50:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AHVFcn0g;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JZOd5uUgyv72utWzP1shduuWDKjucDdTZdv55Qn50b8=;
	b=3ibHbZgpCTgnZ0CPGImb34nmS85LKDqSKrgfzZQlMhL5sgNc7WbX6vvk0oGSHuq+JX0Y8d
	vsARkEdYLokso/FojpZ//IRrRSIH7wnsJTqD0i+Q7/LJPUD9Xj1p2XDWVvjI0gpjaooase
	WmfZ5kE3gL6C3o87wesKzF0j/KrE4zs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AHVFcn0g;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659857;
	b=sqRFDSBENUouOJdg2FfWa7OoX5QkFoFVXOvdrHT+cD9Sklx6tsuVKeO4x0FfLlmdG4yqKU
	msnDC0SFMOVErkPDgpmSVZ7E5C25F9bH75ekI0zPaneoI0ClwIg8k8lkckYZPXgevzuosM
	yu7d5MPd4YaW/h6VrVWyGvvfgj5Civ8=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8ab3d3c5761so33901937b3.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659856; x=1794264656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZOd5uUgyv72utWzP1shduuWDKjucDdTZdv55Qn50b8=;
        b=AHVFcn0gDPaa4AQ1oJYSVBA2s/TRRtrzyzTXNVgOzTqIsbESQhDmwOGuloYdzu/037
         TwjDEc5IBXvwgSGek0UdcsGjY0N86CgEhVTPBKVDrACXmG/xcbP7vhYqZj+mZ0Zmw7P5
         1lMlh1YtkqSi5EaRojDnUdbaMSmU6gyxxZjhH4soGD6/cXaPRFclyu3yYG8Jk2sAGvBH
         wSm2+5NUPBkC8CU973HruH4QfsCnWl5+KDgTZ6LNNlBhqo4Rn5SdGKGPgbQQ+cSd6O4S
         QYpXL0q32sIVe8liznG7x9fkry+I1oNz9tQvcUPXkp//MU+edDwJlIIC79cC+KyxJXUO
         EZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659856; x=1794264656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JZOd5uUgyv72utWzP1shduuWDKjucDdTZdv55Qn50b8=;
        b=rQWuJm6HnHNDmN8AJcc+iZaQRBYNVxkukBAxUwpqcIlLQbRX/uAAOyBMo5F77qv+qj
         jj3Sxzq+1eLfAc0cGiYkj3wBVRFHBZnZ2gUuFDjSkXYx7EZEEY4G+hMMbNnEsRlg39Wp
         GncFO+vOIB1I+PqTNqJQKU8z6+vqAigXIEG0rhbpZ6jedhxeZrv9JA9P5C4p2rAqG007
         Z/k7w6e5w6xA+LqWC946fNiQZ3onQLRv1UISRzCn8CR8HGFd4O7+BHovTsensf5xQIUK
         YlfyGBPeaqwLoyD/SD1/SJK7HOhA7bm4RVMeZFED7ckwweVhQcO7fd1MO2qti0TSqmlk
         F7dA==
X-Forwarded-Encrypted: i=1; AKwUvBwswjGdT6ckdltlVjzaH+7Mcgd7gic/vS6mMoUlhQiKhyTi6NJAroCbCq60ZhnvPBr7jjLGkW433Q==@kvack.org
X-Gm-Message-State: APuU4Z+U6pO9NBlQeCFGU+5mXKt/5zvSpS/r0Lun8Ey4v6sQ6fWci4xi
	2g5RPZhdAjlhBY5Equd2TdtjUj4gnDmVUyDMTVYTo2R99dmE4SNRG+Ss
X-Gm-Gg: AYBFou2ksF1xFmyEHV2N9Jd/r30BYkVkmJwudGrge8rQh9KRtFV0nHo8WzZy+vssZBe
	a8hdTg9Yi/0DW3GjcmyF4XS3SbVgfelrty0zPC412f0Y5DJxowoV8j33a582/quIVw2FbgQkmkI
	TLpzYXHztnWzTYB+n3IehnRry+JsGri0IgxLt3dosZ3BoTl9AzkeUgWmdUMT8ANFw61/c8gXYPQ
	WluJMAobadIWU3MOWjDbU0COEt5bTjsr+pHDFR3fPty8r38Mwq7utXSB8D2H70g7x7ZcNFgMlRf
	7ZwNDS+gUDwVZYco77+Y414FEV/8hUBDeIcqFIfKpB4XPMTVW93nHKOMLb3i7vUtEpuhFU+vML7
	6XT9UxQQNqMLF4qSvH5WYrQ+HXjIw3gZy41dtFY5zOIH9FwoKrplDhemutLUIZkOgnxTSCqoE8w
	bvgqyORrwsvEli4OwYIOUMEAT1ViTimCHVZUhSKxBz97GmAi8lZSi03rsbp1D/SqXH+H6HQFKSO
	+zY8u6EpAdEC1xNPtFdvLo5O61JOx6ftaSHd9jtQ6jr0d4YVOZCKG6TmqJ69qe26e1QOIdasTUz
	4QBUe2BYIrjYeTY8k27edo/5cbYyNUHjv8ha6MANNkZAU6dkYalAQKghNjF09HeZxyo/j5Q17Im
	IWrLxS6LaTO+v8rF89WBZkFzZ5v5R
X-Received: by 2002:a05:690c:397:b0:8b0:9e81:8ba6 with SMTP id 00721157ae682-8b2b67967afmr88183357b3.44.1793659856054;
        Mon, 02 Nov 2026 14:50:56 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b704dab5sm61260967b3.1.2026.11.02.14.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:50:55 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 0/3] mm: read root memcg stats from global counters instead of flushing
Date: Mon,  2 Nov 2026 14:50:27 -0800
Message-ID: <20261102225030.2743129-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j9o75spq9ezz63mfpojsmuhnqgcrasan
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 354B3160009
X-HE-Tag: 1793659857-761456
X-HE-Meta: U2FsdGVkX18FMGIfgnPPP0KUKzUwwpyEtcbzi0jX1Pv3Z1yPZf8zdNjjpf8MovxJQ2c/km32i9AtTiQ45WM09xSARJCz/s3yg00jANX4kBpk7aNL0pLZ05xiULKpLKLKdJZ6qNkzj6vxqx+Xe+5B7EzfmyOjXguvxbWF/Dti4yBOnuosHrviQxEtH9lIkAIOgPXbdiMlVF+aN1bPoWlDBcz9xLLfSwBXsYyxuzcXv4UHLPVDVvV96aZweYrQjK9oVcy4rdNBkq8X4A3VCPTThg0v9O6kZKUibkIkmilmdz4M5/X1L3a09SZFbq8ogII3birPJmuDKQs32ml9Uacsu5COr3wY3G8imgNcT6OLYMy57aAZzE1q0wZX1b8g8Ash2EH305QKRLrABSxPSXfy61smBpT5kUrKh7WZoNOwydY0aKe0V6PdxMnnMqQx+CkbNPHn0ToBhh6v7jYraRQwYj/96WP56HH2DzhkJBAf6zVQniTM6dReKu5ojb6SaFw7p6wgN76XZ9NmiZnKx0+bqeclnI05PIrZqd4V2NSxaXNpZ9eyOKuyHGbE7n3lw17Y7XjV1ZvWMZbPsyvQz2QqNyztZoJz6Nd9GW1V80LL9Du/XC6cpDTPVdhlsdCKM4BNDrrSsGwhLxt3kUZkeufgXd6FTYkW5bb97RaCOzXZLEvC9PMaWA5vzUFs9+/hoeur4BAH19XpeMIS3+ghZiBQDKn07l5D/h8KcMMjFpBRhLZgrtpgw7okKZSjVjl+h7xLURh+tQQgunQJI5nqCG2KQs0CdKGBgf6BftSRR1clYqiGzkxPfzRcxA8YYUm5L7pXiBYvPZcRQVHuLAEW+OCPLZ4As+pIvQPT16xOSPMR4z4DsPaGObtCuCjZmqr7ONjtYuGNTwP//Nh8mC6wPh9mje3I2e4EpDDquuyufawDRT/jfA/gAUU+u5iSd3MRL9jMzgHQKzVdzdRXlF9C0q1
 Nm8E7XF9
 yRJOqwKbmJ12gtV9K7IEtVUfjOIfJKnfm4DmlZDeRgIzuGgm/edtxlN7FMkmohBMABCGMqRbAG4l99B19erpRZtdVYsD+b0FALuZ/JFlhRRNc7rrmdvltm/ZWcoDRADn2VZYyfUXZjlT0eHOs6Db4FU7rEQ6Flx2tDF7u7XFt1NzX3bmqk1QnFwd9Eg+MJ8p+MaQbS1sUn/TbRs91ZVxrJE63YRMWOiPUbE2IFa8SfjuuxiDm02wSc/kN4mEdqewUTZYdDoICJAWJo+TFhgckHbGd7oQl7v4PjgUa+rZc70nVQUsVk762Br5bZBTIxnB6807NfU6MuaOXvrWIMYKw14MdnW6ITJYfNy0TPF27ZTuY98CbBq9Q/Hu1X73oM8QOTqqz54a9ZSMSkvD2KFOhpo75FiL55YtnjTu+9VAMi8kEF+0Huo1quAF/lmT26AE+ocXwrVszeclvan/jyDyepv0AY7+VYJc8Y1XjDHpEhUeQaxrF1V7oPUDsxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim, refault detection, the zswap shrinker, and DAMON quota goals all
flush the memcg rstat stats before reading them. When the target is the
root memcg (eg global reclaim), that flushes every cgroup in the system.
Most of these flushes are ratelimited today, but the stats they read can
be stale for seconds.

For the root memcg, the call sites can just directly read global counters
instead of going through rstat. Global counters are always up to date and
don't need flushing. For stats that only track memory charged to a memcg
(LRU sizes, workingset, rotation, and reclaim writeback counts), the root
memcg's hierarchical value equals the node counter.

Patch 1 is a zswap fix for the shrinker's count for the root memcg and
can be applied independently of the rest. It doesn't have the stable
tag, since the zswap shrinker is opt-in and the fix can change writeback
behavior.

Patch 2 adds lruvec_lru_page_state(), which reads the node counters for
the root memcg, and uses it in reclaim and workingset_test_recent().
workingset_test_recent() can then skip its flush when the eviction memcg
is the root memcg. Reclaim keeps its flush for now, since global and
root reclaim also read the stats of the child memcgs they scan.

Patch 3 does the same for DAMON's node_memcg_used_bp and
node_memcg_free_bp quota goals, whose flush is not ratelimited.

Three root flushes remain. Reclaim also reads the stats of the child
memcgs it scans, and count_shadow_nodes() and filemap_cachestat() need
the root memcg's own (local) stats or the stats of arbitrary memcgs,
which means global counters can't be used as a substitute there. This
will be addressed in a subsequent patchset, as well as getting rid of
ratelimiting for most call sites.

On an 80-CPU machine running proactive reclaim on the root cgroup, a
root flush took 69us on average with little cgroup activity and ~0.9ms
with 128 memcgs repeatedly allocating and freeing memory (wall time,
including waiting for the rstat lock). Reading a node counter doesn't
add any cost. It took the same amount of time as reading the rstat
counter (~150ns, which includes bpftrace probe overhead).

For more context on the background of this series, please see the
discussion about memcg stats flushing in [1].

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com/

Joanne Koong (3):
  mm: zswap: fix shrinker count for the root memcg
  mm: memcg: read root lruvec LRU stats from the node counters
  mm/damon/core: use node counters instead of flushing the root memcg

 include/linux/memcontrol.h | 16 ++++++++++++++
 mm/damon/core.c            | 15 ++++++++-----
 mm/memcontrol.c            | 44 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                | 36 +++++++++++++++----------------
 mm/workingset.c            | 19 +++++++++-------
 mm/zswap.c                 |  7 ++++--
 6 files changed, 104 insertions(+), 33 deletions(-)


base-commit: 0e02eb17f263e4a3ae6bf1fe45122c23361f0cf7
-- 
2.52.0


