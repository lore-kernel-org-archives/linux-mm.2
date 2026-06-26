Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8C7CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D6F6B00DC; Thu, 25 Jun 2026 20:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D73D6B00DE; Thu, 25 Jun 2026 20:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6BF6B00DF; Thu, 25 Jun 2026 20:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C746B00DC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22676167361
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:02 +0000 (UTC)
X-FDA: 84920148684.30.8D8D5A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7CD7C40003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnR1gZzR;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433020;
	b=laqmEByH69np7XGaLekJe4uuQ728upPVNu20KHVJZq+roL0RXvaowEL7jmBH89FDSMrV6z
	e6nZ+GD5bbsDtxCju+neSQQA4hhtVO/KxJc7nisco7u24uvBKFuUatlwJ1H3+i6qtCVEGb
	jbPhvhTl9mRhJpCr00wVKsyEqa/dAys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRKZafStRhOZUg4JkpnCijAYobhpC1LwOvV2Kj0cqgI=;
	b=rIAZya8oKb0bhkrF4FybT8UyqfzYCllJ3jf86bpM0XdV0/JBO0Vgpfk4qOTN41nY5BPslT
	WbiRg7IALNnXmWimfKIao7cFTVKbFG5iycHQN2bIiZ6Z0+IRQjRIorZ3ACl+F6oosrOA4r
	Y5CICN/2C0+F8MCBgqGqwzBgkXG/Bvs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnR1gZzR;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE0F7442BB;
	Fri, 26 Jun 2026 00:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A917A1F00A3A;
	Fri, 26 Jun 2026 00:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433019;
	bh=pRKZafStRhOZUg4JkpnCijAYobhpC1LwOvV2Kj0cqgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnR1gZzRhRPKnJAQ2r2PCT4CxE2aafs15g/Z2MBYLUx/poayWUtFh03IxNoZsUpnM
	 f2io6H6SIKaedqp/Y5aBZZrrpSpgNelqaMQ1ZeX5UmQn6/LuC8tl9ISObGYA3uMxqc
	 heuwrpPbH7q+yk/GZH3m+C2gg+3iTs3rQgli9ES1OhUF7CYJdyXzPaXO3Y9WBDMvBE
	 5icDCsNA3GGaXXRlMokCWRKyhi0iNTd+1G9gVPAlwyi+HLsERw5FRfZ7TGaQAdP5AC
	 g5T1cIGjNEdQCitrUIjzbh+rVADtX8fBq/b+JIs9jGGq76RtXaqmU5dOx+17jEOM1E
	 Z9ddFQvv26dYw==
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
Subject: [RFC PATCH v1.3 01/11] Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
Date: Thu, 25 Jun 2026 17:16:32 -0700
Message-ID: <20260626001644.85825-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c1kstz1hhhtez7brjfye3xp651hqmor7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7CD7C40003
X-HE-Tag: 1782433020-109080
X-HE-Meta: U2FsdGVkX18OMLApikn9DJ6uuL//Pu3p2tuEfi9Zxzi1O/Na8SGRZncUrf+XnWs5JhMYTtsZYhqwonr0fSJyoV9iJxyKH859FkfOi2dsSKATXtjPU7NgW20rjAIdAy8EaNmZIGi850GfhC6AZoqyBTLgk5debnZTIyIFfEe4/OHA/u6fXkjkBQtZdCsYDWuEL7R7vetDY3PdEs7QiderfxNrKnyVLydwqgljCx7XYXVQNBhuSxdekCLuxznawFLxhv2ZboMVsLU2YmP60q3mGpBHyiPLcjVflYAuIj+aPBMqLHSqkCjEFSJgPr9L1pRAlj3BYcgcOtsUrS/S7dwZp1PTOJp37NDrfOPLF+5lIVyKID8+o1uRCZGyKn3qpERT1ndrJhe/ArEyHMC4onXHCn8YCJYPl8yqWxEN1vb6la02Dg6IpFDEykHcmHDyLD3dP2S/u+P4+SfD8v4IyAFXGSBTlx9o/EDPJfxGxGUqOPQp9nNTL35Obf0oQLApK3arvrCJSdRWIX47WqsrWy/SIDNlrH/uEM3wLmrNe7d9Sr9w1YEpkKl3LQaD9BYwoYiFWzzZWH8Yvimj301i6jZHZZF6cxbF35I6A0jXwdfA5WOAUrtDr91kS63nvCpuk15E2Ct50IVE01+V+mZjHcVZjmB9mujQDd0aNGfltI5kYFYg8NAF/tpyApSHcXJBtkhV2l2RjMymw6EvKkehipzIhDWbImwoY7O2brO/4/pgJjca1wUyBmpgw/AvSiyRXiawOT4GCpRiSNIkcKgs15TTKC7+TlLKCFVyeQmcmsePvceymPuu0ImsypuHG9et8IivDiF2BifvXxEpZbGTRCgJAzaLmdzkxEdaGIky55ok/jxeyWilhyh3aO2Ui96tkzVCqWfFLWxFLalhCz3QSYkgHyryhPXBOFm1l9S4AUTC5+/l6Haz+NTpnTjkj1E6nKCpFPgbHjn+bKM118Q9XfB
 3nEJZKsH
 +bCCurtWTOBOtyFHYfHrCAP2W0b4ExqOJPgo/NyalgfqwuS1pnvNd/beUtCYoiZZgkV9D4JNzgDLdhLChT0a0x/hjLtrh0w7h37jemxnh71vlKL6cTSztbnhKfd4KOdxGG1ST0k5Lgqg/+m60mBUJ5ZWJlgJQvzRcfhkNsAw8UsMK8IHqARfeRAdcu9XfncwqayxI7U8b8By8zb3GWt8/Z2WpnCe4DAuwlBFm2lUr+ZuC4NU6jNoSkE4jqsSLHfkPJ6uGDQHSfHLK5lgGOzmNQIgT2ZhSwLDHe5xM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
introduced DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP but forgot updating the
DAMON design document for that.  Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17a..f4efb51688853 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -686,9 +686,11 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   (1/10,000).
 - ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
   bp (1/10,000).
+- ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
+  of a node in bp (1/10,000).
 
-``nid`` is optionally required for only ``node_mem_used_bp``,
-``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
+``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
+``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
 
 ``path`` is optionally required for only ``node_memcg_used_bp`` and
-- 
2.47.3

