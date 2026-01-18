Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8145EC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F326C6B009F; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0C46B00A1; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE39D6B00A0; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6AAE6B009F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75EEF59800
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:15 +0000 (UTC)
X-FDA: 84345856350.01.D6BBCF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D797540008
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SSD+bNz3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759393; a=rsa-sha256;
	cv=none;
	b=e6sIq+59yH4rkoOZp2WITOsinfnB/dxUVvZs3NBRKpHarO7QLRn6L4eg9q6v2d+X8TqbN5
	jpTd2ZeLb//hd5NeaRetEi0W3V0KaML1KSIaWIadCj6LSK2bycSjBNYAZYejcO+jJsIqIm
	C4GVyieC1swooWCUMtFSk2NKAKsBly0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SSD+bNz3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH6GrLUMNmKO1HzD7WA4oSJ3aA9HupMPxG4s3dSYsXU=;
	b=j3NZgPk6BhVW7reqisAf3WaIn0Me0Svb8vkwkDZclC6NW9/uIkCsItvdihCbhr7KceZPIX
	IDWi+W8Qb9IJbS5A3ggrcd0hKGFHuBaNRcPjAWaMr9r3l0AEZfYb9hSHMXGF9E3qKok4f9
	JuuJjBh2/u+yTXJwx3l3xyV3shFvv5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AC7A60130;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABEBC2BC86;
	Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759393;
	bh=kKivkzBbiXhusYPA4CZvWuiT6LLGAcIHoC107wxKjT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSD+bNz3uMdp1Ai4DC9qcx7XGfCRHvF82aWlIkI8LkbzdKtGwhY8eZY8ddphTbF1I
	 rH24XGtcKrBvYKQi4hEkUxShF6e3jwwIGd4eAlXqknADMhGvvjw6JY4TJc5caMaQx1
	 k2HnWCWrqbVWc13mN4KaHojAi0dKqUJqvCqDKYhhDRQlgOVbxpO3bSnSAUQd01+3a7
	 9YgtVGy8LU+0GF3APRr0AelWTAPPASpqzm40cbA49FXhyVDYg1dVNlrJct9FGbY90g
	 /qPiMgm8xW8liWWCHJT/uLFQKj/1Dw/KRxo0B8edbcpQqSxWKV3PaJkfwtvTf+M3Hj
	 uOgKAkgG/Hq1Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] Docs/mm/damon/design: add reference to DAMON_STAT usage
Date: Sun, 18 Jan 2026 10:02:55 -0800
Message-ID: <20260118180305.70023-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wrikcecfq7h5fagndqs8mfys3p48dfxe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D797540008
X-HE-Tag: 1768759393-454734
X-HE-Meta: U2FsdGVkX1/w/T1bodNWQQ8A9aXD+8UdUN2PvaMzkZEJUzIT+mM6dnUlnnd1I8OEkETDHw6sz0YI9CxW/zNdxIk84jbjMnoM5+9lGLYGnJ8TBQjmfw5J1HDrBRLaOsup11zvzdY+el0E1p9kkVInUnebspVUymrtrENZoC5imF6+fiYSeHczUG/cvssHEq8y6TkxE0qdVhyGdZ24qRbrEm7JFpRMASo5UbJFXIElFaWujwGKQeot8eQHZpoBjqnPy8POCjtvKZD83d6k5C/IziJcY2fKCf5xm62Y//YfmzKdHUqE7n4qcwRRyNOcnYr4SZ4kdAj0iYK1L0GrWb/DYg/pMrnBhRINrbwYneXnHR2g5+BfXndnixynEnxmkN9wd60w1A/jCEG/He7CvM3Roq+IbSj5B5hgKhWQ//XipKcpByI3tiQl9DURyKjc8MoNhhDEhe8Tcsb7TLUzx5xlMjl8Sbh1/gHpt+QNIKZ5ZTDXSF5/2sud7Yp88XYg7sOBp0yKf04ZM69AJDejCU5KhZhnQFqVb1daGACEyXaPOTAVQbGJC6xlJVf3hwlZV6C97mOi+cvplyUdnIsnvVmmoWonV0U3Jyh/qISkLNbxmlA/bw5Hmtj7plQiCPL7x21u9Vx8IoyOCSpsf7x7qVKTD+7lf/P0UWX1OqpAbqbXxSBz7r/wQhj47AnnOnxuC7N+hCJkv9bzkNAUGHbnp4sb76v53thLYGfZ8S5kngYWTA9c3jqLWHkGFtIshBcEhyBqdD7Se7u2LZ6YTVvW/h9GHFZK5JHsyRWlZJyaXvgk9rA/hvF7cVDfB9YQPCAhZAk285jZeKEdbVm/3O6+m7wAJkf+Dng7kLWSuPUHYyjIKvI5UdPU/IAFWrcQew+fUCJLG+sHGZiMmchIslAlbJZGTHbpdSkkqM29eB8XfjpLMz+03jXZKNi4xZFeH/RqSqXImCgPEgYE+mNSA6YNsHv
 S8HK7Pub
 c3xUnHtsXomBjZeiCUMxlTQ/lVNYCaloufyHoZQpmaoH9b/OT0fFFLlj70xHe7rgcHCOL0dIgZDzluJrtIHLMloldoerzzEB3IzlhuijLwnuWx8eB6dZA3Hzhg7sGPcY2JY3HmrFmjL+GukaxNHSpZD6JDxIIvBQoZtDUfm7nqGU8IzoZV2GdL07otqyzja/MyuNAgRQz6DW/BBJpINcXgXCqersJFJwJIDKtQLP3xESQBqj2V2FSNy8VGemtQR78GP+ATG6ZnV/TpSXbtF8ro02AtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Design document's special-purpose DAMON modules section is providing the
list of links to the usage documents of existing DAMON modules.  It is
missing the link for DAMON_STAT, though.  Add the missed link.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index da0bc40c2261..c10a3dea3aa8 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -834,7 +834,7 @@ To support such cases, yet more DAMON API user kernel modules that provide more
 simple and optimized user space interfaces are available.  Currently, two
 modules for proactive reclamation and LRU lists manipulation are provided.  For
 more detail, please read the usage documents for those
-(:doc:`/admin-guide/mm/damon/reclaim` and
+(:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
 
-- 
2.47.3

