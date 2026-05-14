Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C576CCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D0B6B00B1; Thu, 14 May 2026 10:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5226B00B4; Thu, 14 May 2026 10:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAC36B00B1; Thu, 14 May 2026 10:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D34BD6B00B1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7C101C1483
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:31 +0000 (UTC)
X-FDA: 84766208142.27.74C2705
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5EB2C0012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sDBNJdUJ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVvgkwoumhFmJdDElpW9sDh/rhAQYtD8kH0626J2Mz8=;
	b=JH8Pv1ukROiiLHOTkfxymFZoVWO6Ugac2EFQXJmfhbAtm2/8vzpoXjD6wXlVKjXnaOruKS
	N8KvxL2wlbqzfExeV4OzfdQZiTiTy47aZpB45LmxbWU8Q09oLxrTomWLGGnxv8L7wl1r9i
	7GNeaa5WLbQ++w19RdNO/7MK2KDmYCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767769; a=rsa-sha256;
	cv=none;
	b=cDKJy6or06LKYNBxA1hCUgcGgWsJ5FDSaiN8ClpHF4H0jveBBZrSX9FO98hLdY9NgvkU4S
	9MHJuZp/cgddhmZPZKPYNZV9pqMjBCsLdZ+V3adAZfa1ZPXjIMLl0waRxg604fv4VaBl3U
	m1oYB6urnxFaDkjfpaG2lTsXZK7X5Kg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sDBNJdUJ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75E4060132;
	Thu, 14 May 2026 14:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A461BC2BCC7;
	Thu, 14 May 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767769;
	bh=QiZyClLpM+jtGeAv4uUzZ2zYrmnjLH6QxsmmjjG7o5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDBNJdUJQvuDbJbFCDy15+8/UKoJbIsU7vPDhbY3Fan+17yfUQNE3SkOIxk38e9J1
	 0kxRuOXNwUuyXoHJFmVxzw/zDQXVT1d3oESt1vgWRRIpyn9Y3/3byNxcIDwyKM2x+b
	 hgHAtDk6fY6uJceFx0Bob5PC9ltFeYH6wyXMff+dX0OyuNC4Igq8IvtyNcE827V+n2
	 dvPi9uGHpKfW48z49oaOdccZ3kgtMCbod7LsEfpJ4UKHJK2pkR+YDzRzZ2GApTV/Xp
	 ZWsyvWKBkpOTarFi6qF3TEyvJp0KS6qo2hACH4t59BqpBo4WYQo2Fw0pMs294Fj2hF
	 W4Gr2ZuuJzAPw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 28/28] Docs/admin-guide/mm/damon/usage: update for memcg damon filter
Date: Thu, 14 May 2026 07:09:01 -0700
Message-ID: <20260514140904.119781-29-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5EB2C0012
X-Rspam-User: 
X-Stat-Signature: ctrfk3cfxps79jze87f68saqdjmq7rkn
X-HE-Tag: 1778767769-372512
X-HE-Meta: U2FsdGVkX1+qes05hFtjalLoeRxFAtJ74HgJ7RteQQ8DVzDHTwwZeImCoNjGrn5IJvBPjj38cMzRZaGDZZmOnEtz12bP4cnSkHfupPVfIHBpp8qa/FbI+o37a2ioE45FkDvtGW4QIds0E/T+Og863J/m7p4pLI0wb0g1xBh+OC5/swJ7bE/iIp8wgeBjJSycTIeXUuweE7iJdAIbKWwJyLDQJnt6gLamOe3rpfIwyeoGluZdnePI2A1/S5B30cW3viZOmPfWi0+Q+OAZRUG8+sGLebsD4BnhxE8Y3l599o90RYgLVpgbh3J9VIVarzqbn+IhkdkKoSnWk8JNQr7awfK5ymocGP6Axtbrs2aLVTq0wrddGsDpNCIFbAFxfkSq+b0Wg76PMQ5kxOAOiqhMLTd3fNNhffMP6cT26fzWTsiRLNsWCXM3sp/ivnLoj4KFshE5k2mhWoODqVEAOAdL7muzpKI6idL1eEuRkCPnSF4JZrDnfi4VV0f6MXOdLuFb0KxwDsczYH79wIJsQDxkJmX/1RvkaabkTsxkJ3ZB7De8aa2glhgam/DoTbSRUp1+lcngaHh1O1NYOAR7G+O6OTBL8Cv5Hw+Z9EW9hfhFNDV9ghBbCJqetQRtRVmrIV4OKEBEasgzO6o48WoXBMsHI/WqB37j4wugD48duDVGJXICChfj9nvPT/Z6FsPCsFmMZ97qyMA5/jhAogsPGJMbl/FOYAJUlgaRe+muVwFLyCaTkiciyY5rZIrORGRy2U/9ekFppJuMH0T66yVVxoCOYzGFWoGlY+Bi6B+jNri+CX/NNqvZ9P5QOB+KMtpbYY+U6x/ND6VLLuaoQGLlzr7oudGDxEW2jE1Ak4GnN0tEKvQOqbDLduCrEFQJKMfeFcdAlI7jWmv0Y1y/3rPD+reWgSeNVcLtAjbzqEgJQi/V2k5sEyVJcspLV3VNkTpC+ZTfg32TRjlyQAwACugttRs
 T7PhH34G
 VhyyMmqmWYDPF3HqBNiQuoHM+Bie7EvfM8zOlsr8qVRNxxaOe8hZqzMWD2+E3VNCQWidHaXY7vIPx8dvHJGVjoU/DIrphmvd5qRbA068VihPUap25RG7Hxn4GbVyGkrr/1sgH4ncrCtLXJ88kQFMSpkR97uWq6yr0Ya2yq5w6txGaZvwgjT/YiL/xyp9ez2OPgxkOn2Xdh7sYBuwrNneN42ajMBihkz3xzDtYMIW96nJpN8brv4bGUOkPQWDOpASp2r7tgeXrXUDg7MrJFR7ag5ynFjLYjV17drQPRUEGRaRcV4+0DdIyTKtIYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 465bcdf89b182..84741b4cd1877 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,7 +74,7 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -289,7 +289,9 @@ the data attribute for the probe.
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and work in a
-way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
+``type`` is ``memcg``, ``path`` file works the role of ``memcg_path`` for
+:ref:`DAMOS filter <sysfs_filters>`.
 
 .. _sysfs_targets:
 
-- 
2.47.3

