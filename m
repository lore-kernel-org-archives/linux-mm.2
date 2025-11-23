Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEA6CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402246B0030; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC446B0032; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8F26B0062; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0E006B0032
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 600871DF393
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
X-FDA: 84142745736.05.615A5AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A3E342000A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vzf43v1m;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAhUZLX5/094seVe/b4E7Inb4L4so3OFN4Un8ZOjDLg=;
	b=wM3wIDF7CeLrlo2gMgkxFPPrtdVvNFaw5mAQRMg3rY8GehnKsAvaSecFFMBrWUoPe9hZr6
	CbMdT4+0VdYIx4zBr0e8ESuH24td5jVF0fTjAGz+45JzVTxjnaOtI89PK95wDaRNwcTSIj
	kha94nl+XgwExMKYZ37ByNgEqJRKoAU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vzf43v1m;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923426; a=rsa-sha256;
	cv=none;
	b=SdikinNUIjLrvPMDcL97yw0OkvvYzTyMjy7M44Yk+p3dWHiJSh8c7gzodzhEBlWYLjSDos
	t6YWlJwObemhRdSD9/7H1PYu9LY+kL4Z7NJDOxi5QNkTJXL7UxTD4kIQMSC8jpHsGDg056
	qLXm4vVRYws0Z6RPmhEV4K8DnJLt7Zg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1DBE43A65;
	Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4F3C19421;
	Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923425;
	bh=MfosQBkwjx3KXwTbjhH363GcqS+Z5CKxnOYfPNTR2Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vzf43v1mBUX0UuIUB6lejQV22KhuCioTa+XZkyrKmUxCAN3RZshlIJT9eO2uUeQMA
	 XqbsH7XvIM4FDKqiQb8EmZU4/45WF/aDNo50DOt39X1JwG0bVqy35aXDseaEjByKPT
	 EjUhpd5bJl550PaXpzGmv1eEflrLI30GID4TjFRkYGYF18EfnJs+o1GjflLK9dTqM0
	 qHdu7ZRZK70H+XkAdAd1j/eT0nvTAWujdJsMb1vJjl1DzQ+hX+lVdN/+Q6XihPPlro
	 n50GfeGpiSUyBZcm7oK65jo1DcyKxBxM/c2pLurqJg6uLeqseqavg04wNlOKBjy3O+
	 AU94l7kBCINvg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH 04/12] Docs/admin-guide/mm/damon/usage: update for nr_snapshots damos stat
Date: Sun, 23 Nov 2025 10:43:18 -0800
Message-ID: <20251123184329.85287-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3E342000A
X-Stat-Signature: 7bb7fo3odemkcr3nz4cnu6wxhm8ffxrr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763923426-549468
X-HE-Meta: U2FsdGVkX1+NvgzkFpYsR4yC1168vI6PR2WefVZZUhQhbNZWi1rxQICFgIerqTCWEiJgxPwBJeNS07J6kv37cANTHNSlirVZdokIn93URqzhYK81yRFY9kTgjS2shwcAmu+s9mNWREEd1EdLpjM0lxAWEFNyZWbwnl3/igTLm1Obce6fzwkESlMBQDCqVyW3BU7lhRicjOrcXZYTBNpSyw8zjAq9ry8ROKsYYn/wGghPhlwP0uk7GFKtEN3O1OZzLiTbIZFD/1uEiHGSuSRnBNX+FxsZpKT++ATnOBdtNIaWRZJgTWVu1BkGU6hmT/uJp/2I87qK4oUszafpskABwlQIUMPo2Rr5YkpQGj84XkYt6GYmBNrgUIVetsSOerLydY1nizrse9p7rXXVjG58tPLEi5xpULVWMlzniuMxt6LBrcBRNfhJgbVnfREljYxKqlD2etf2Rrb9cs2IHrducwMBOVk2FCIjT/C4inSwc7kmFzhMsYkP7ugO4dSu1BKb2Wr+KD4ItEeC0cP+0z3kxCDthZ4sgK/r0QF7+Nr9dCUt+BrjGIwobWtjIvXOPqE5c497dszJOa6l4oUA6IwvI5EBEPD+7QgWM6C5IjV+RqFRl8u853/NllB0sNzFL4r61mcsH9lUhXXK60B2dtQGcJmI3gEKj8d2xLacvVAz+AXiQh0/pK/l/WcpRwSz2hsU4qzv/yPTwf0un9LlfePFu5Gn6qM9D8pFkY+QFOVNyZ8sVtxQQ1BNn4CxnpZrGm6U2uygHkQ8GT9bBN7L5OParU6Xe0K8OdI8eE+9foYb/QMAKgWr9Bgh7Q/oucz0mqELT4TUZDtBp0QnH2C5+Qshyeg4qc4+B07+hRB/Z27gHuwpKSZn0MeemFCbfkflR4kaYE91h+GVOLw78m/P20PHisBapxjt0yoyNPZAcmmQLWBP05P0CmVVWYFHipq7uchwS698TDbG8uJYmfMNcOr
 2gYHG0Wf
 rwkqXR//dJGOeQKEWytBS/Wk8Q930rUrF1v4GzZX2SbSXZgtSbSehpNtNDsRHsAPQSSGQOU5TI2JyvP6NPsC4QAOUK8FF+/ElSZ1FWWn96IllIfeSL4XsN9+1Zonebo6xmy2g3Y9zzOeUmwDkGbXEBJPBzgRIF/yNIbVlG8tUFX/Bn24569RkZUDBCzku0FmTtNglBLLTV1O2UUTdZLifWecKEGD2/vOepd+ep4cM0q25Esujtfproa9E0WFAsYi3sW+RB0iLAMaY8YTv8R9c1tZbFRYCHOMSvPn609tiuu7jobl9b3NgIjRRdg0b22VCqfcYiCEKvZauiFcgkcyLPZEcR7tu9pWV4nxN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added damos stat,
nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 9991dad60fcf..d0944bd78964 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,7 +87,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ ...
@@ -543,9 +543,9 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, and ``qt_exceeds``), respectively.  The files are not
-updated in real time, so you should ask DAMON sysfs interface to update the
-content of the files for the stats by writing a special keyword,
+``sz_ops_filter_passed``, ``qt_exceeds`` and ``nr_snapshots``), respectively.
+The files are not updated in real time, so you should ask DAMON sysfs interface
+to update the content of the files for the stats by writing a special keyword,
 ``update_schemes_stats`` to the relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_schemes_tried_regions:
-- 
2.47.3

