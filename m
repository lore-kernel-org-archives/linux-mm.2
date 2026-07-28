Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53347C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D6C6B00A6; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F64F6B00A7; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5339B6B00A9; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7F86B00A6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA4971A022B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:13:00 +0000 (UTC)
X-FDA: 85036864920.27.0C29AF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A87A40003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2dEu6gj;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	b=K/K4wd55PU6/VwdUvC+Lo9jyWWtEaUYMEPdFdHXHQKSFLV57vxB5pal36b7uvg50WrSDJh
	W7N32hmI6Tqe1D4MPkcvPPVUAmr0cz3ZezASKhAUjAVLLyfQys+TNj1mvtXoVfptMJi6mK
	KUtWaUAbVzBTgzvZB0NN3PvBtW2iUVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211979;
	b=Tw5gYqrgY7CahPlvVNFCCno/etXgEIukx9DwddrHPTTvLVt+qoFSmsxjOZr/ebw72rNTQ4
	E7KjSi6Ror5gPb70KoAX3Fz95pbiALBSZttfSTP0SwKV6rQFbItaHQDpbPAM9DtxhSAGfZ
	bY9R9qaxx9PP08dVsHBjBZQStwa13Hs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2dEu6gj;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FEFF43EEE;
	Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB181F01559;
	Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211978;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2dEu6gjew1sVQ013U5ot8/JjImPQeDjvFR0hp+Iopv5PLuzrtXdaOvhgaR2GN2Mx
	 C3w/uBFrEcR8RpvqhEbDpb5pUthMDyB51JLJLNRXo1QWLM57qdWcEWAQP0szxHHiwN
	 dKRJhmXOE4OhELaIT4jRHArdzIf/brcx2EEI7UY4KVFUWElGBYFiF5Qslk9yMBI0IB
	 GoWsbFcsAM7L1Je2u293J5h6EsNtr8Xxl9aSOGV1id2t/z57eQ85WIztzeajuKRzHy
	 x/WGD3/dQvIjTxLyBa2AgcVCuCMLxiCqdDf+NAignYJL+FPOFcZ2xvNwd3m8j4nIxY
	 9jKcuznFyodTA==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 16/17] Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
Date: Mon, 27 Jul 2026 21:12:37 -0700
Message-ID: <20260728041242.187380-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A87A40003
X-Stat-Signature: jg4nm5d9nmfytkh3ns3gt7pw684t3k11
X-Rspam-User: 
X-HE-Tag: 1785211978-789631
X-HE-Meta: U2FsdGVkX1/LoaNRL0n+gzOmQLGsG6wN3R3ZxLQvMamIJliNIxdPUZbQqFMLyTRKNw12l0TCLTymajZsjkGMBRVxz6c6PbNANe9zaPV6bsKbR54WUquiM+289uKjB7zCeVPjKFTHJzZsUSPi5uWzVsPMZ9iMvxn8yhPNeIovwW9T/mLY//D9jhjPr/0y+mbMkHLTiKMWd3APb58yAwM9ewWEttfg0f9r0wR/TgGryn7aL1DE9gI0IskHriksZ019dV2NPWAWGp/BOFjfJ4uTVAGHT47/w64xiosit9qTQ+IKNk1nllVAufnO7INN8/qBXklZVuxH47RLt2e5DCmEQqokXcM5QzcQ8UM1eHqdfI2ZLMvFT39K2lrw42x1l/TmVcp1aWxl2bFlxP4r9UV6MmD5taR5j/D62IkxsMmrBFh5k3vZZ71z2fuyliCKVBB6tF33UNfn/ONwkZvL8loMTP459jt3bU2efiyzLOapqtxxyhZiCKneSl9kVYI/OZUewXU8CVd8kfvGMrYEczIHn4w/UTdGJC51/D1hBGz1qOHlFL9n8GMh4tj6eVpB2AIMGnLHSHCtxVx5g8on6vPke+S4R1Z8hCGyduitrrHKypCp7slpGdhN8bThmxnmrVxh4t6OH19oN7YyYAwC5LTvA9t2eAy+IewCl0PKHRWBGCX8PoCnWeCaxQ7CZcEca32g3/C9ZHnrJsM34l4XqgwKBKQqF8AsE4YGvXT2Hx3kbs/IeHRxZZKH/N+FA1XQEe14pXpsQGwiNoIYJikL/bhJh5G8pCGkghVoUh/zvMQtwtoJ7DpOHYfc8RVaSZUhv534u19RaSIl2RPFovzRoKlY3nsNCs+4oxa6ARvs6N9O/0OAOO9VRJZolGcGqyMkNRKNBjulEFrCVxelREkP1kOjI3432ZgAdaRRTrxhJBupkyVSl6GA1wCyogn5qgEfFqc13IETeP4XaTpTer56CQa
 KLKBoKNJ
 VlU0ptfVpLNcQinTH2rduCx8KmvOpVrERHBIkLK7VbCH2iqBPWiG4RT8Wqu6kKqKMOfFrt4hkDApfmm+W8iRGQ67mlmczMTOJZH2M3TTt64rfjIKJVsv73jOHBFOucGogKK7BMoWDwE4ASErbnEtsURZBD23S1b8lycpj8aWhfbb/SnTMFAOos2AX0K4Lnet8S+UQmYQniCe+E6nZ9gF7gpQ3OfBHl3AMxZ4+GupzW6PKHofSYnUcTOYXaWFhWmGQ9wrd0EuXjiv50F5qBsgAwOUPU4qDYBGjz2z77nbF9d7qRuVvv8aFEYg+uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added DAMON probe preps sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index da5f9afd08aef..023c6334024f8 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,6 +74,9 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ preps/nr_preps
+    │ │ │ │ │ │ │ │ │ 0/prep_action
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
     │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
@@ -283,9 +286,18 @@ In the beginning, this directory has only one file, ``nr_probes``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each monitoring probe.
 
-In each probe directory, one directory, ``filters`` exists.  The directory
-contains files for installing filters for the probe, that is used to determine
-the data attribute for the probe.
+In each probe directory, two directories, ``preps`` and ``filters`` exist.  The
+directories contain files for installing probing preparation actions and
+filters for the probe, that are used to determine the data attribute for the
+probe.
+
+In the beginning, ``preps`` directory has only one file, ``nr_preps``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each preparation action.
+Each directory has one file, ``prep_action``.  The preparation action can be
+selected by writing the name of the action to the ``prep_action`` file.  Refer
+to the :ref:`design doc <damon_design_data_attrs_monitoring>` for the list of
+supported actions.
 
 Each probe directory also contains ``weight`` file.  Reading from and writing
 to the file gets and sets the :ref:`attributes-only monitoring
-- 
2.47.3

