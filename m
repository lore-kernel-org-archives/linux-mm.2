Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9EEBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C259E6B00A4; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCEE6B00A5; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB9A6B00A6; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0DF6B00A4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19CF2A01B0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:12 +0000 (UTC)
X-FDA: 84969412584.29.2CD82CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 61BF140005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lcoLpowK;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605970;
	b=mI+C9EprTDLNbX4vGqUe0FLw2AwjX2P0f9ATh0dB33jz30RKibkOfu2W47Mkod6Umgx2Ca
	zAoex76bJjaaEQ14IlbJ9Z6EXHcTxSh1rTMipJVvljBU2BeQvxIZI7Bg3vcmdAIDLe6i2+
	WRCefSWNQr1rHVnZbvOv1oM+/fiHp88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lcoLpowK;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	b=mOlFtecd/qic4tCMfnYmMVBCqbv9ikB2nXcxR7zYUhROGFhXHUOHd/paXMJekvL548K3tE
	HI4X5LxS/OMFjkoWoxK0HuRw3pfuqE1qw3tj5QWDuSTRzqiTKQBs65aFgWXlRVUFA9iVQL
	gHk7Nz0P8XDMP3W5ufvMfNRyZ9bEgik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3433B42D77;
	Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EE21F00A3D;
	Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605970;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcoLpowKzXU4d91CEtNawIU5Mo+YzK9W4zgV+PrB3BxfG3k2K4DL4kg2KvZVEYoQU
	 YSwwY8nDZ4tOLrNwWHIAcMZdyyIOCDsJoS7lWE8GS+8qjucCoc+S5fv03G9aDWHd/u
	 9Cyl7Lp2kFiC4dSu9KCO45kwLj6k+/GIQQR1/Jf0sq/f4LDqQBFdSmOre5KvuHUh8X
	 1bDdmjcil1EyvxGtE3SJ878y267uie/s01hdtwINYiZ3aYdy+SkTzvKQags22znDQ+
	 7Eq33ZD4ZUt1mzEA03vE7b2PLPUnX7Wk3CTojYpcL/t0fimBC1MXn6ZWr9RKj4UzWT
	 WGwpbJOLMUz/w==
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
Subject: [RFC PATCH v1.2 17/19] Docs/mm/damon/design: document attrs-only monitoring
Date: Thu,  9 Jul 2026 07:05:55 -0700
Message-ID: <20260709140600.90950-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61BF140005
X-Stat-Signature: 35m8p7xgzbk75jtsk5pwqxmhwe3s8uyo
X-HE-Tag: 1783605970-980377
X-HE-Meta: U2FsdGVkX18hTntbQNvvhEK8tMtQ3FTG4sgEICPRpg1pa5lhWgbNsOMFUYgCfsGMPPLOXXQllPA2cAgZGsKqvqawelUQQTcXHJmgKkMOfBV3pTtPZx6vwpvvSXkhMlv2546jL1fnLHI58PwkrGNrdaevrW3aYvSGhuESnOTbKv03CtDTkNMbr8NBsupPOM+GEwnASiP6LT8uWJamRH/SMwizSdgFt9IZmPuH16W1qCgd/dfR/pxTSojGQdifN4fsd9H5cZkSMvJ3VR738fxK9X59EnRZfDmejU9afibDBOrezS5RBAc5iQsoRN8upPLjR5B4Hjofca7gcs+oJu//LVn9vQ7KblPvYtTXude7O6PqQ+6MMEvcqR6Qn4LyT1nphNbt4ClrzoCZnjFhw71YH/7jKGU8mPpx6fbGnvd/oR9efseOHqdfxWtunqzhEjIyteFSx0/Jyy5E0FVvx01SV+g9R/NNYqSoEi+YZUwB7W4JQdMNM8QdcT+bq5t93CMdZ7lNFN2EXjWDm8KU1Ps+MyLOcyqywPvXujDaPwQbBCo3fUuawFWpOpI6tupNr6RAz9Gk/9/3LCoisD3XacKZNkYkFuCO1hcURtDpHnUVzNwU3TtSUnQHI/Z0BePKxmZUZV0wuC8KlU4hp0kjvjEzIhggf+AUrfocVrGJh7az7Ley9juatGTyWeRGiRVyxRgY85RYaLDLkwvYwezgnXRO0QtM5fDbo6x9EGKZyWDCtIojFndgBVU240QnBAHlM5DVv9h7eb0t20W7g8Wh/RGxQQIktXZuZNv469tJPMGmxfeD7ygP423YeJK/Gzx7mkIajOWvmv3sl9jTF4uFxCkJywH/OXSDmcNW+xi4GdeezNQ4yo6eRnq+EBHAdXFK0wUTjKJeju8yVJwTk7WfwVjDq009AkVQy3CPgEjR8rSlnkXk7ir5vNnclOj3Rt2KhugMak4xlWz7J/d+6WWxYyf
 GrSQdOhM
 d3X24BxigVCUKWuS1d/dqKHwnIryxkMO1A0NDeU9d9cN/a7A3rjKPIIOgnrRa+0ob8nwtvSe8SxRXWYslz/gRKnzTpvzvdLTOXEsgDi+/lEyrhy3CZxmgAaoDDg6JENz+j/H5S/jfa5VE8v3a93mVs08nM72PUG574kBVaFVRMdnvwnCyNdqm4fHofZ2Ons8fAMKBWO2I7GhGXVe0Kmak3twuftlLy3Uo0x+C6/Pm8K4/r9WXg62FpVgJQUFno7PonyH7ilE6Y654Sb6zfSyXT28eqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the attributes only monitoring mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 457d6e8bc7878..6d79e7d69be84 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,26 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+Data Attributes-only Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access is the primary monitoring information for DAMON.  Hence it
+:ref:`adjusts <damon_design_data_attrs_monitoring>` regions using the access
+:ref:`counter <damon_design_region_based_sampling>` (``nr_accesses``).  In some
+use cases, however, users may want some of :ref:`attributes
+<damon_design_data_attrs_monitoring>` to be the primary information.
+
+Data attributes-only monitoring mode supports this use case.  For the mode,
+each attribute probe has their priority weight value.  Users can describe by
+what combination of the attributes the primary information is decided, by
+setting the priority weight value.  If the total sum of the weights is not
+zero, the mode is enabled.  The regions adjustment mechanism uses the weighted
+sum of the :ref:`probe hit counts <damon_design_data_attrs_monitoring>` instead
+of ``nr_accesses`` in the case.  When the mode is enabled, access monitoring is
+automatically turned off.  The access counter (``nr_accesses``) will always be
+zero and not updated.  Hence the mode is called Data Attributes "only"
+monitoring.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

