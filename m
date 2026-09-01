Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79BCC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF026B0181; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D64D6B0184; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E756B0185; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8C46B0181
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD8541203EA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
X-FDA: 85165264716.03.3D8A010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BC46140011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4Tz3IpM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vf/K9c9fWpOSUYmz+e9QIT0AziWQ1IhtxaGnZ535xtg=;
	b=RLGwxbEDMgLc007XmOJDaW0w1md8uv/b+VHFwu/x2MKL3trOLnZAkJrfXjkQh/ny8TsjQN
	T+l2ywCYEnUP9RUX96Lf5pyjfyvyMxBEvbqKQolzLpT7Pb+i+csHwlQCoTCuTiYH01Fxic
	glqYniUueDjoCSD02ViqXQPLh7vn68c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4Tz3IpM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269117;
	b=at1HLzMRYsArIC7Z6R4IRKfe7kpA0mzPXRVAyJbOXhF5Fn+TiBg0CEWIbZaCrKYUGDxjtt
	RCtAvqFX8xSTZQKydRCsTUTdE3Yu8GmIorIcwV8rY83B5lIKkviz17usJQ8zmeDPx0IIaE
	hgCRoJGUtmZGl1tBMmf5b0Nwr3hyrTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA08360515;
	Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38581F00ADF;
	Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269116;
	bh=vf/K9c9fWpOSUYmz+e9QIT0AziWQ1IhtxaGnZ535xtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4Tz3IpMlXR7MLDLlIDUWNNwlBsLxAczPgma1Zv+VzN3rl0T0kRNRX2Sjj5bIA8E7
	 I6SjkLXtgMnfsQgTC4+gwZdI6R5xZyMmPANuw+14YT9t9+fy0PK1g8APz41IzKzI+W
	 e1EFi3w3wRZmVXlkch3yBAqwjur6yu84iixvMbtnuAhkdtilt/odBX2x23TQXlGTA+
	 UmWtkwOETAJcOB79YOAtvLjrvp0zc6Z+V7dnU5+jc7Uc+p6WiNApQDb9BYtaZykYLr
	 Fi6pbfVzNmvsCwuiCB6u3vnS6BA04GQcpxOvSnaOG9zXIV4QW4NWlka6VH853OBNPN
	 x6TMaGB6xWViw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v1.1 04/17] Docs/mm/damon/design: document pgidle_unset probe filter type
Date: Tue,  1 Sep 2026 06:24:51 -0700
Message-ID: <20260901132506.99243-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BC46140011
X-Stat-Signature: zwsunduteothf5akmae3xk9bfrk9pjgd
X-Rspam-User: 
X-HE-Tag: 1788269116-458235
X-HE-Meta: U2FsdGVkX1/n5K6wFoSsEuQ6sc44stYKfNVYEEbW27g13un0rC886fq+5C7AL7wKqDaGhHm0kiJlzg8sOJs4AgboY+ul+cfFd9SUzxMVKEttVPwVNORdj9fSNrVpO5O7jCmcc64tM1sj/VZbofjD6o5li8PmNd32h5XfZj6X4NbiOIDIytIADLs4S93iAGchyL4XoI8pqWfxRsK9aSTaYqclA8G6xHJnzb8XUly5VCTsQyIE8Udguv1ex538DniPqXKuyIJnqO+9DfoWXGUSAuUYEDbjTH7eyvTyd7MPBkxCGAX/q3SM57hl8sJJ/THZUvwUYSEAg/hPlSnhYoXTNqjD6Xd2arRwMMeNLQnZwCaRQNhym+lX6KW63IjQYMeqx+LYx0IPnwwfBFGALnqm08nBzf2e56dDZs9+my9rmtyVnS7prgPdnpwx0dbTsmbvgD+Okkq3Hvnwh2PmGbGOQHauEEaRTrA7eKecwRIFhKD/CjnoUKot+xFB9/rCjdYtW+MWtEULtgHkGacIKt9ROdUJTLfSNpMldKMabMfr7Gf+2B6mGETeGOwQL4xuwvI5mAHC+Nxyi6ScJZD7Ty7zbRyEHeyB2oPnojLtqj+y4uMBzSpwUflRtbRvMDTj5yXgT3gqR1oST5ym40YliqvHEscainOEsxYWCb79QQhtD8+mWrweV4YgmL5tZTUCH/Zc0ee5fxfcOpncYBkmepdVaQynv7P2Pt8iuy0YENcwXf9BmQ3VYsJColqOZ/RXahqbHeoBb2fZ4Oa1G5HaDHICBW14mDlmgCXCdP2oWCsjedt0kyyqnsquUt9vy88tsEw2s1N2AgBeLLecBq1CwHzFEiviWFpo0h51iDe/e7TIjj0PcuugmVAuP88V1c9PzqCVDeba2/vJ06v15xIfDACxbN0iWpSDnRYUF4Riqm1NowkDnDzAYAc0YcaPrJHZVoGWVkppqBxmWj+uo55b0Nj
 xsxDwgRC
 gy4igWlT3G0zvif7Ny1YxIJRsqvBgtAjYoAa4O/EPE3nwqaahP7p3NPoExODYwJH1Lk9hS+I/TkExqv39OdYwUY3/Sf2b3zdN8DagApnoMSJvOZIimSc3CwiRoO3F6g80XkQDyWxCsgerBM9AtFs5J0Wqvi5YdJuIeMSm1rver+VX+Ke1GmqiqNbRyUBSBMJ0NjFqTnqD5xXCRiWmB6DJi7Jyd8Fl4Ua4l0sH1DE+cCOSS9MdEOzc+dxpwmfLspasCxp4iVvcVzUlSTOcqQsNJivNvQ==
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
index 63cbb7b536da2..947d91ae24a39 100644
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

