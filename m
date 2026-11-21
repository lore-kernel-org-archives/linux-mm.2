Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33176606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eg4b87Us
Received: by kanga.kvack.org (Postfix)
	id 99C646B05C4; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7E96B05C6; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778B66B05C5; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53D0F6B05C2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8D2F405AB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
X-FDA: 85460344578.27.65F02AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A8DE120004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eg4b87Us;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294828;
	b=dqnptzsv2ity8gPz+w4Ojx1CMCm5Cgj6E7WgLgi77vqJLadEZnh8jxrNu5c+X9FiP5akTd
	3FpvR/VLh8TXYJ8poZT9oPjpv6ZZVwaD58T504eLsozN3hsrEbXp02NR8re8WUZuLmTVMS
	MOtK3PNdudLLYHcmCG3U/nooloUJoMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzWAy5ljzbSA7LAk4a53ozwyTWaW9lGp6192iqNnFAo=;
	b=bTetT0cQG/B29dSBnr72ECQSnVeJpkXBpOGWAVy4W4EtMGMC6o4nEuZR3Um0ZGj2Faiv7Y
	5CoBCSQob7T92nbWeStvLkORcb/z9PhnydFeDM5ASSEP7g4hBn9CaMThkFmn0v8nFdBFwo
	Q//ccNCeBQ6Pya8GCy9+rZig3Dir8d8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eg4b87Us;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 953D04511C;
	Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB191F000C4;
	Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294827;
	bh=QzWAy5ljzbSA7LAk4a53ozwyTWaW9lGp6192iqNnFAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eg4b87UsfARa+Kj6OZKECF4s+KnvrR2O8U3LN9Qywf4lsek7PwUBTQCkoCAlxl4JJ
	 31CV6Z47vv1rRl8V5tA3p8H3CCC8F7F/8wHPwyzPDc6eEsDcN4D3xxU6dWHn9sGSl1
	 hcOb/sF8NzWVkBqWldybddYaxuVkNsuqIdHwunLJh/sOVovtkM4avYeA1q5K/gLuUj
	 NruMQWhS6We5fDKGPiYgAmO5Q8TqhPhVEPra8Xfhr01+TIoeUnp1IxEYS/2LuS4Q+s
	 YB7z1AlJ2y2MzS6lClPQSwPXLVcPNv7fQgZCfNpvePu1bQEwnVAD4gjreYX0+VG9gI
	 leuIyR7QJlXjg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 18/27] Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
Date: Sat, 21 Nov 2026 13:00:02 -0800
Message-ID: <20261121210013.130397-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 4A8DE120004
X-Stat-Signature: 968qg4p8dqh73g34ig7i591cpazmhyus
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795294828-174131
X-HE-Meta: U2FsdGVkX1/JI8oY2P8dAK7jKsvOawCJHITda1N2Ql6+rDe85KYKVcd+9aYfyXDr6tbnlLthkIiF/iG5DM/WWQVocwWgWRmT3Lh58DAtM70IzqYmISllPjxMIROGdAxN9p+/kqh8qwo3xbN2b+GPCCf0jTzbDlkUIcuZQEr77GDcQAFC7xQP6l0Wcry74mzDzlg/GmELrFPtrMG1j9ve6En8r/MjZ0OxRLmoMeHdeK6qvvX18Rldlg/1MbtaC6tY/PUH/7SVm2kYji62hyPHR3nsCadX+yJIClKYRxCt+hfHymwcvDZYwY2tEwCloE9sEIESC6KPF4UxTr9aXpKaZTBJBRHo7NtJKp8cfinMj/AC35l/FnaJiP4kEjUycwj6CsVdQ1oATso6wOQVCuT7in1SNhD1Hl5ebCzyvQOGebUNBkU5ygamHRZY1xRp/yMpFogUKp6N0hqSKlz7mTnIfVK6K+lLtxnNHAkBs5FwvKU+cMLTvfLLI7GCkUUNGIQwK8FVRymQDbf+GMIAEsosGsmAk/8eG6hiWw2zpubDgCZdGd/zvOwxfYL5mHLAVeFxqnvzd28g2bnAywKiDt9WnavGSRsXgj/mjyjaoJX51EaEhF15ci5j0xiqFYttgNOprAlL0ykZTCAAIWooPX0nTj+uWttpdB+tDBg5OT4l530yG4fUhoNFpc0GOQmU2GetHT5Hnr07BEeLdlDQ+y9Dr5xEwXICMUHaTG95dQOzP+VHR58eh+2a8qhaif26Nzyy0ILX593CRMgo8HQJfXN284q+4suG6NepKn7o6oZOT1gsy5T6fAbxWls01CQT+Wo8xAph+WCfv26GXq6n2m08CdEBrOuZR8RGHgpmvXIY7S0KbTTdWk9ky2E+AOuhJ5XvXJiR3+/p1o6+oTWYn6kzKD8qGOtnTH5YGVRciWMsgVfh0EV1qK3b/bdeO+zBX2XXSztpK0EuRPPi2ci/8Q9
 WNAO6qA5
 q9KX+eGWqFBPo0oDsFaDc8ayFJb5F03HkLFxJ/x/OGGFphELqPY9dWs4oix3uli5+PYy4QMceu79aHMN0RC15RDF2RGoN7tnIsHvzwK1Gbo4XSw8eryq/oD8aUFELPc0v4npuEZeTlF4kxFKD94xGHQUh0ktYHKgUm28cB8l46rctHqiJ2d4Ik8gZArAAt+T86R5Np/BFs2rXpxow9F5c9eCTrz8wH+81tmD0AK1U52DK/8XSh3SY7M33oz/ed3njKEFNEuJMbRgENaLeSrI/tg/pvXIzeSjrge81LaMTvwPHVxv5aTeLHMwPXo7Pgkc3QQGXDhkfGysbvwStKI+hHFJVcE6F3AAvsHPgDMhgdhdJhv1lTNrsMu5mFMRlKqoPXa2nkMGxKRCxX0DDdU9GPqC3plM0J91wHM4oqotpkkeYQkbSN+AH9nskcplz+Kr+8Pzxovns46Uc9xfblgS9IrqTtEleGabhYLu2CmyKp81F++5h1gvdeUxgB/TO71LKAAB6P0IdHHwmJU1nTGmNYxknoBjgK/rkejUiRhKJPXgZjg1VqrfwM+wd0j08GDdGM/OQwalguh+LL9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added REPORT_MADE type probe
filter support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 644250c7bd681..ce4e9e4c13276 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max,filter_report_type
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -317,6 +317,10 @@ filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
 ``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
+When the filter ``type`` is ``report_made``, the :ref:`report
+<damon_design_attr_reporting>` type for the filtering should also be specified
+by writing the type name to ``filter_report_type`` file.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
-- 
2.47.3

