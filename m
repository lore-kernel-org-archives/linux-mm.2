Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A732EC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1FE66B0099; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFB96B009B; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70936B009D; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6701F6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CE0AA55BA
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:43 +0000 (UTC)
X-FDA: 85199709126.07.6109321
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id ECAE4120004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHNOCgDe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHNOCgDe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089221;
	b=I87yt9d71eKC7hEYUqDqLIshkAy6X8XKK5nwwD4sNvqlL2qGKaVoq6E0zKdGTON5dRjrDn
	piFjhRfzo9rxsKEeDXstWA7TVIx/qqyb5BnB8bkTcCW1cgeal6GzSfIsIJE6xysvVWd4yQ
	xMyLb7YaeVOU72erliO5+4dvoeV3YT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	b=6HYcbjTkeCf5wftpKgj3uCpmvzfOpg2mXcbRpGtwee5k1ZMEAOdo0Mc+G1QSF+DU1f3IMf
	d7N4vrzrh0Kz6SsRk9du4otIcEAyplIuPO6E9scwkof77xsVLV9MpjfpW2POYyaDVQ3lWd
	nIxPDXTJmb6AnbvPn00Kpg13pE4C/AE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E02660200;
	Fri, 11 Sep 2026 01:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57FF1F0089D;
	Fri, 11 Sep 2026 01:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089221;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHNOCgDeIocttiQy6albuf/07KbOo3GN/FoSGTxbAdorMZGgv2lPClYOrWcEyKM0M
	 KjTCo53iFApu2tsNRzWMOCE0tz0GoIeSwUmFbzZzQXOpCWe482lVyt/+00ZxSXbgD6
	 5FWNLdGx8DmV0Z5OXTQBmmII4ZdjZKlmXhta+nwPTN6E84YzpPZFl3Aa9Vnky1Copv
	 fL6oWcBWGX1atc5GU2b33X7kf3UhgW7T0MWBD7LZ4ltJ2TPVtfDhtzQgQn48h4FP0a
	 PZdm3d2iwGjYwQAknwn6H4CFsLAwOH96ETGMCshoLIBQfYjJx+esBtNU91tTXwBK4D
	 xU3Bhs6BWNQ7A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 7/7] Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
Date: Thu, 10 Sep 2026 18:13:28 -0700
Message-ID: <20260911011330.93678-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ECAE4120004
X-Stat-Signature: e37j5c8durb8nmrgb7d1z85h9ua7r54i
X-Rspamd-Server: rspam01
X-HE-Tag: 1789089221-110996
X-HE-Meta: U2FsdGVkX1/Ix02t1n2aKeshlS7+076ttdLPrE+1JeL93qqe9EcU9bd1O45D2vby3eCvTu/mhZIOYkKa942Ivs5MSDJ933j2IuHpDtC/80xwkcfvTs3z3A84mlqeq7TyQbMx8lxHQ+xwYLMhm1auSEQZX3wr+b9A45Y7l+WLJTRm7zX27E8hN92BXNoxmUKDPuGSCltzwmB2AWTitClh6rxJNFiRKMcVMLqbhoGaGhkdiuQFsfJnuV2E2o/49n9MfqTFkSeBdLTkXLYyWhCKf4lTIVkJ2RbwG11JQv3Nr1TkveGJQXiG7WJTxgPH6hqQg4FEHdvbrUoPIpGjeYFW6D098Rt+/emIifKWH18eIEZ79CBjuDyvVqbF0li92MEyhvqhqnLxdSyb0uDeQeP165v2t7lpcCfMIqo2NXa1CcImKZiLAJ6kktok8ZsgnT+LIJyhOHwnPD7RR24zgy8/EBT0B8G4bfWnpJJENlHmRnh0Rt68nIcNa0pWG561vc3Am0X/yC2ITR0jETu7Nzttg3jZLH6AHQ149jcI9RkfujNY3iQdjPB6V1Mo+t3QxkEKfDNzw6q4EhqQaP87+Z6SszHzyYNesuLxy9PV3sz6OL+zmE1S/tC2a24N0a+XIVGXtCephZpIBdQgeH/pmcyQRsbRZ2RP056Frw5xIqx5XEafDid26SfDbGzT4g690XX5UNNXBkKvlME6a2rQaj+03wsdnA+2S+Tpffo4P8PU1jMLebfoPPtWpWjvmrnl4mWy1mve8oyIyWEelLKH4ceDIHb2fSZ99IMaBwrUDRiR3CH9GER/28dqB2aKuLxUV5nKnJYH4B5j2bsSnxp2NgdZRM3RwrlzGF3iUcpoFKFX0UhUky8Ml5zmonlBBOWBNkrCxACEbTapFk0oYAS9tvY8KajgUpvZI/WlCKhY1OvldEkoheAUUhMunaUP/rr8i3PK1jfcG3l8DVOzkgKlXYa
 hQrB3yy4
 dSuJz0qtZR+WcGUSNJ1sH1KrWxVibt+FC0EEaMgFb1orwg/+SnEc4u8bsBEdxclRoRwbj62rdwMMa03BroeJa6qUyFRli3Zb2Mi/JrF+mJV/2zunhiuxucCyDvxSes3J2jhX9B6VetDnmmfdcOZzMr87j4mAQWVYbn+eVHsbrEBH7vZ9oRrZshBCZrgiSES3b8aDoyNTkNMUVKEVa3qlGJg75ewIsyKw2FTBI8l3JCIaYVh/K51la58+XQpSeDfULuNuRu8xd9EVSW4SzJ3fzRYgRQF6eXOQcRljr94nzV2O5pmoMQ9q560lyT3i1aC/j73HIunECTG/gVH42bIgv3C+mErlYAgXWaDQj5843BgBpL1yfYWQacn5P2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 023c6334024f8..d3e37400367bd 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -551,6 +551,10 @@ and ``damon_target_idx``.  To ``type`` file, you can write the type of the
 filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
 available type names, their meaning and on what layer those are handled.
 
+For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
+hits weighted sum value for the filter to ``min`` and ``max`` files,
+respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

