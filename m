Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2F4C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2166B0098; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A5D6B0099; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078626B009D; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C84436B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D1A0C0283
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
X-FDA: 85036864752.19.E67D5D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F74B40006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTgkhxAj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qlh6y9Au18vR1Ou/T5ICe3OGlXl5Nc84fCTR2Y+rZXM=;
	b=vkuHfGLYE4dlM21PZxZOU/y+2tD0WRkroSAzSGXiQ2z/XukjWthabdNu5n7t+sJLlOmHQ5
	apsooLq3iheDd8hPeIGgL0jY/DO+K6wgk3C8FY1HPkU1rFwtfVJWsfx0eLmh9AsH5o/8Fk
	NsgoAeQy7ftpNZZOxFMIT5KIAJRVTtk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTgkhxAj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211974;
	b=BA95mdIlddN2pqPu7IW8cT4BXZH8Le7veFQVUS3CPFtgVAy0ON7Pt4XJmav+Sv6EA13vlQ
	8kLtnIeXfJhjQAxXqpPrtuV3KJeMhc3x241ZmPCMADxhPXCY2cZnqrd220uDwXDXPtzfwy
	cvb74ZGKyk2N7E4jOjaCoIFbutz3RYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C608A60A62;
	Tue, 28 Jul 2026 04:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0771F00A3F;
	Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211973;
	bh=Qlh6y9Au18vR1Ou/T5ICe3OGlXl5Nc84fCTR2Y+rZXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTgkhxAjPDwEY5OdQK7osbfQu9Mzfd5JomJmpe9Ij8LREGuMPl0mkLW9WK3Gl9T1a
	 zdpQjLUzW/ir4y7Bkrr+MZZCqL+fMzKQeplrCpf5NqzdIS3+CtYAKW7iXLIM3qNNUP
	 jYwjlY4gQ7PkXG7YOYI/CZ11apvsASV+hcIlhqPJo8n2YytaG7QiN8WkEH7pk/LW+7
	 9gf3FmI/x1/W1mKS3OeXDBE8szcqqyg4CSX5+V0SP3uGcUF9KXeseOeSEme77rvUbm
	 A0Qe0oe9lSNQDDOUm05yxXZl/MjMFj9qEKbWDZJvGg5YC39UJyoDxa+FWZGttzd+Yh
	 ELM4IsxQfTdjA==
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
Subject: [RFC PATCH v2.2 04/17] Docs/mm/damon/design: document pgidle_unset probe filter type
Date: Mon, 27 Jul 2026 21:12:25 -0700
Message-ID: <20260728041242.187380-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F74B40006
X-Rspam-User: 
X-Stat-Signature: bbimuei73uziqc8djj9gp5h48ypr59j5
X-HE-Tag: 1785211974-490741
X-HE-Meta: U2FsdGVkX1/63t1S5WRipWeG7YUJ7mfGGeKS6yEXXukYq3mujuis+L61RuMmMzgTa8Ood6CFRiP6B8JQB3yvp0BXzctrzQbj8rekapLCHnCkjOsfbcZaFGcD9R5WrTRaAh5OD4twkd14bAtraWVxhWwGH4xQOnC/x/hLSCH3O+BsP235gdM0u6QH9zQncCxPBmUIokWp12q9qleEHnJH+tA7tdwBNCrt4355gsANfd/H+ew7m93QqrdOvKU3Avmq09otGKj/vV5QFPhn7Dg2Fspq5nWhPkQAU8XOP9LYRlpUE+wRih8+ak5EyVFtKIOaBm7Ry5AwEOZ9oOgCo801mdpISuJnvFssazPeyZ53NqgLlThBDNMEMqqXn5kMfDc9ldLnIiI+1M47UMGOWDLRFlwu5xxJmi+DHevFoNkrUnrHNunPeRxPnXtSP8Ua8u+memYPltoR7nN13/hkcTNbrtwRAiAVfObElrbH02EIG9vbFFu59pnJ4u5AsTqDlcxrJl5gdOe70mMVThbyH584J5q2X4izZpZx7RDhKHMmRI8NJ+SB0c8FqERPiKxFTWtKNTz7t9Sx7T712pj+ivia7KaPN0B85Ds33DLVdNTuqKjsN+ut6+AWIZ5GADClQlhKI0Q4KrWmVcyG2fzuspcVt6ZLP28ZXgrIxhrKVy67Cr9g+E5+fRhhqkp0+FZ+Q3MVJuHiglsWviCZMMeHrD7TTV6LXjhZMtgbnVpZ7DGDALvhN03EoUZjQFKyn1K6LpeiSjC85df8ACbLwI2kEYKfUR3Q1U/HaOPcA4pPf/Lkf0tKImtKVwgGd4D/OaEcMwH3hH0sb7d9FheVBHUayRi5NYITbRd6O20YZkKCPjkKnbFnp9V80x5iJ3D6e0e5BeuhI6BH/SYrqyL+Q6ApcfU9NzF0XtZEhVII4xY/mSrRbhVwz28EhLiPDbtA30VfFdCZfLmz2vEviIqKfxPLBSx
 c364eOhL
 yOvGVdIJf47DGAF2fICeenjN2NbTCjKU3X0XBmp52roLEwMHuAYYEirfMBNYLFfnMZSQVwMYS/YFPDrmnAkcum4IW1yLkF6yEmWczQ7MUVSGDBVqcSws7q+yyDBraw9lApj05lcGlJ92sNXUluJHgkzd0qHAYmLd3V4YaQTBeLrYqZaJvlUdDMeIl5RkVlNeoQVztnKPB3JAl2DMs1bHj0nhtYMNgnKeASy5dj9uAk/O9r4o4ZSyjFPuxExjzslPGBVn6CxWwZSb+cKP1u/f6ebvZt+DW7k6P71v81k0rVGh/jg7xqvYCF0Rb7GD8+UHOyiI04tskZhwBdIlkcbM7IAEYVRU07Te/YOxmU2uQ7yNBfwOOQ88jRIZOlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added pgidle_unset probe
filter type.  Also use a list for the types, as it becomes not very easy
to read the whole types in a simple sentence.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a8c163475ef2b..c4830bd09498d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,12 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
-for data attributes monitoring.
+filter types.  Currently below filter types are supported.
+
+- ``anon``: Same to that for DAMOS filters.
+- ``memcg``: Same to that for DAMOS filters.
+- ``pgidle_unset``: Matches if the page for the memory is marked as not
+  access-idle.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

