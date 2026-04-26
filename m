Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2B8FFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DEA6B0005; Sun, 26 Apr 2026 17:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317F06B009F; Sun, 26 Apr 2026 17:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFE06B00A1; Sun, 26 Apr 2026 17:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 081146B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:00:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97A3F1C08BD
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:00:12 +0000 (UTC)
X-FDA: 84701924664.21.CC55689
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DF81A20011
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:00:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKei9MSL;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777237211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOZL4+mogu6T8E7PAy+IXa9AoTCG/gbBu4Qc7S4VdJI=;
	b=0/78c3dZ7ojyQzwJIh+TBZMePzmKmowwp8wmSEy5q0M/a4zjV+jIktHDFT8XAsWF8iAz+2
	5dHxGvVbCB6dy3WXCqvdn7dfr5zz5iiUwKmNSjjTzF52k7zG7UQATJgWuAal2TYwHWQp1G
	9zGcs8zCpA9rcA8DccrCyT4QuLhGZ3Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKei9MSL;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777237211; a=rsa-sha256;
	cv=none;
	b=YO+i6idul9rnyrxiIQg4kGmxsCCXd2+BF2cwYv+XU3Ope7aeEe/rp5Ygyn9LsMXonvWxTD
	bTPii3x/oJz5KrJVOGmeUrS2t3ERYsrwmDhDB7yITICZvZ3s5rdwMssr4ttaTQZqFIz9we
	iObeAoDDotu/uTpCEEpLGPIbyOeseG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6FFC60145;
	Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE4C2BCAF;
	Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236761;
	bh=wSosBJ8m1YWd2zOlUhMAmjSvy68tqvEfvThHsZfgYFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKei9MSLej3nBQoIt35TXjx08PyE2lIFrsCiVH0/Db+cqf2NdpqutXo1dWu15EuW6
	 W+yz70+C8plwYoW+u2T/GwzygsHdjMmeQmAjxz/NZiaxeu9gGDc70DSykNKBsDKpx4
	 bdigEK/hhI6sjbUTEo77Tjw2+l6356TPUKMcwQHJM2WCcbSLbXLyoxXx4pAIagyhxx
	 WA0Nwe69ZaQRWBakOMonl5LWFPWsN3WhUmD93EPngyblc55ZUzTIzx81XzwD29fF2v
	 eCInb9rkNMxRMXcnJ0koevDoFalxQo/ehg/rFqbYUIHCnp4rPEADrPbL+6WKSWay6T
	 CH08RjmYjyPeg==
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
Subject: [RFC PATCH 18/19] Docs/mm/damon/design: document data attributes monitoring
Date: Sun, 26 Apr 2026 13:52:19 -0700
Message-ID: <20260426205222.93895-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3qbwa5rdyaocdjaz33q3hxcwwtrfdq49
X-Rspamd-Queue-Id: DF81A20011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777237210-350366
X-HE-Meta: U2FsdGVkX1+OvEfWmRxW1rQPBf3wYxdDV7TQ3E/iya7Atx+iQDS7xyluoqQrhrnIChBlHQBcqwRBYj7oBPiytpW1PK2BBdLD+RD52Zsq8NBEsUl/pRx6Zl71kiS18J9RGv+mqbUMwX67x9V242h46n9yvA84rT98IvXordKaHkKpY1HOJuemAVU+M77oX13aKfadROCmvBQ1YDxyCDY9W1dW03DokeGjkJcISh9SqJlBrzIgzAz1SZ7x8gDQ8kUqWzRvIkDM+f6M5hcjk7fXwxCf4Dty/gqYNUjvAka+5DviyYetfklt6xYOkqeAmLYRiA5STcd/G/pHwhtG7/6UHE4y8kKhaKQc9SeSzp0tm+Hv/ERV57sv/BgfSIK77ZfDaFlJW65hb/iqU7mjRZVEmcpSSddI4GIVY/VHxcLRrIShAukCDElH4XAaxkr4f8LS9HkiV+MlyqAAJ2XlfXDB3WxFxEX5OYGoV4EaIWnLj0cy6L/jN7tcwYrHKtdt+m5CfdOCs9gEhEmndPjQSAfCVJI/G1aJVQU5pN4XO7ukn6EMB3pZsJ1BznMIXgTCvuVhYWpyWlPArKhiFr5kX5x+bv5/GZmnjo+f6pA8ta8gQhOhgDMAOHcBDPkCSyEWAuuhi4OT7jo1JO+nOlGTcrdhbKLHS90QPp25SZmLw+9MzlLHOqOKvhubUF1iYhhWusgVtiuCyPkhQ2sCb0x3KNoGDxJ+ciHuezcA+YhVhS9IqbeylX2oxKaKaOcg3GaNoxxyHfyzMf0VFgHR/kHV1cSN5hY8RhjHFtOz3JVwWMweKxMKqT1KayoVbs8SKi7jud5sZs7/z/0zdce68XBoetKX909vGJdJJJGXMXlgoQ4Lfw++ln8AzmN4Up5Du3QXbWUDbZrgRTBLaiVnITpXsCIbWodBoH8+5c1lLbKTdat/rR2EDiaMGZUZjpa8SXnByFtGrafu0x+TUXPEIKv93OU
 zBN5JRPJ
 m4gfaiyPuxovWuDJ1Q7BnFJReenWHggEt/gwzcN4E14rKZavqHnQM76GUTIoN2XenkPC+ME8WvgkLu3b3fZAHn+dupLFR8XMC6KT1AcRekL8MLYkRtMs1lB9YjqckedhhWPe8FEkBsK/Qb15QhXg7r3jBBif60fIGlOBqVUE1zaqRseIUDWxgz/PzKQngemR/zHPhFDhNISDeKoi1uXQtNTkTHz6VcWESZ4cUNz42pWDTuAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for newly added data attributes monitoring
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index fa7392b5a331d..bada2010ad1ca 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -276,6 +276,41 @@ interval``, DAMON checks if the region's size and access frequency
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+Data Attributes Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access pattern is only one type of data attributes.  In some use cases,
+users need to know more data attributes information.  For example, users may
+need to know how much of a given hot or cold memory region is backed by
+anonymous pages, or belong to a specific cgroup.  For such use case, data
+attributes monitoring feature is provided.
+
+Using the feature, users can register data attributes of their interest to the
+DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
+registration is made by specifying a probe per attribute.  Each of the probe
+specifies a rule to determine if a given memory region has the related
+attribute.  The rule is constructed with multiple filters that similar to
+:ref:`DAMOS filter <damon_design_damos_filters>`.
+
+If such probes are registered, DAMON executes the probes for each region's
+sampling memory when it does the access :ref:`sampling
+<damon_design_region_based_sampling>`.  The number of samples that identified
+as having the data attribute (hitting the probe) per :ref:`aggregation interval
+<damon_design_monitoring>` is accounted in a per-region per-probe counter.
+Users can therefore know how much of a given DAMON region has a specific data
+attribute by reading the per-region per-probe probe hits counter after each
+aggregation interval.
+
+This is a sampling based mechanism.  Hence, it is lightweight but the output
+may include some measurement errors.  The output should be used with good
+understanding of statistics.
+
+Another way to do this for higher accuracy is using :ref:`DAMOS filter
+<damon_design_damos_filters>` with ``stat`` :ref:`action
+<damon_design_damos_action>` and ``sz_ops_filter_passed`` :ref:`stat
+<damon_design_damos_stat>`.  This approach provides the data attributes
+information in page level.  But, because it is operated in page level, the
+overhead is proportional to the size of the memory.
 
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.47.3

