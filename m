Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C17FC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1096B019F; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69DC6B01A0; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D598F6B01A3; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF4266B019F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36B531A0402
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:22 +0000 (UTC)
X-FDA: 85165264884.15.220DE28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E9302000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMSipk8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpXkgOmW3GSwhrOkMdO/S1mj76NXWWV8m3WM4J70bcE=;
	b=TILAza06osa7WlBbpkpHClLUVTi6M82UsZP2ho7gSw3nf3xWm7C77d08MI/JahOxOq/B4w
	XwLPbGw/tjjAqzj/ELHj9487ai+5Vkb0+F2bkHyj7fyU5Cq5qoovMjrD+h76SlezcSiuOS
	L2LTN+Ci7KpWorePC/OM0z8oD6LCb54=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMSipk8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269120;
	b=i7mB0O+DimQ5aBkTxuuY7Gcm68+G66MtLs6dJXOfJkZBFxG9yMa8Y0m5nxFvP5euBxg7qI
	NBivFPjAPKvyPbdQqpSrEiMMolMyAaL7iCi0tt0aLOkHcmsH0PnlvGIfKXunSOU2pqIldZ
	g41OMaQ5d8xVGCzkS7oil8ACux0hEQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68FAC41A1F;
	Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF59F1F01559;
	Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269120;
	bh=CpXkgOmW3GSwhrOkMdO/S1mj76NXWWV8m3WM4J70bcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMSipk8UkfFIcDDvF7JZOpQ51OlDWE7AOEaYd09MsYdaYHkkpPXXCCoqVV7aN89la
	 57z2pqMr+WWOj6RieHPXnhPpP6e04h3p0BuAdUHBkTQt7rnyI3B3uLs0qzYe9Sgzxx
	 zOelOFLUtOdrdche2+1I3cLfGOzGwOO6diu735898YqgOqb5jUBldpRlsZw/wu4r7y
	 72e7X1zV/j5GM2ETzVC7IdrY4AuRDHaqJ0BsOldg5PiGnB3afG7XvPwGGSDmdVNSHJ
	 f5i/sRhT0sNVX3RnwKRTeDiwMoFPe+WIrbN8VWpLYy/VLrrtAqcyPpvVcMxhsx/nF/
	 CcC7v1hGjZCfQ==
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
Subject: [PATCH v1.1 15/17] Docs/mm/damon/design: document probe preps
Date: Tue,  1 Sep 2026 06:25:02 -0700
Message-ID: <20260901132506.99243-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E9302000A
X-Stat-Signature: bsebxsmg6b51cg4r9b6zfmsooug9uufj
X-Rspam-User: 
X-HE-Tag: 1788269120-606601
X-HE-Meta: U2FsdGVkX1/z9mSiBV4MU97R3HCMb5RSM+aqNm+7ganmdr8y7diA1bkCrSewrbkQJYe5kUAg1aiYQae/Ifh+/OwA9vQ4gnNYGVv54T2fhtB7S9SHjcqv6sNykgY9bv51q+ZsBf8yAJX9QNGRottQHYy1lX3xPNWqOuGuKjEUKGlZ/V0lyfATNNE37iIYATKrcgD+pqzXwNQNZGcWf2UyBQkemsA/tNwM62kxtlrD0386qBdYwz+ITmmEvB3OKLeKM2TYF5FKvl5wG6ge5yPHFTM0K2kwHtEL4gzVhg9DgRGCV4v8zdfGP89JWEqhMTkCYqvc6en4afV90OTDl9dINmWbm8TD31DzsrUfqlbF8ww4xWDQwr8RXclTVOIE73mbk9TBNfIPQwNU/c5sTGHMpnTcEF7/i1xDt5d4KfrRjSNPmWona9vNOE28H+27hcY0omvEoYdQxReDENNWgZaH2SGr9b/7UzkAnJrnGq+2MfR5oKr/1+indBpZnGEUXWs1cCJGtd+fGcUp5XvptEFvyPwcTON+3BKIKVrE3EMPYZ8Uaixc3SmKOYSfGoiks/VMquiKboPR3d8iXaGzsi5yADTn17RZEykAXW+ufHaGmN2DkMrbFowAelIeFgCeuN/KgAl1wumg4JbB6f4i50YLJ5hBCBmHBEd03NaR8YRmjrgVAhd/Hq/zQ76t0ogS+OPvgVNYicKjOTqzZs1GPcHy9P51vJ04IxnBDRBwTmm8r6li9Yr2wGkcDlwhUDFgrltTMY0ApSseqyvOviQaxG7d5K6N7lNg+j6DdxYQK7OtR3iMJ5/J2JPLo6chJz/vLfDMCgYweQ5vae1ZftE05L7PqSyJE1mkjO9TWU4Vs6dU3gIgczsQidIGK5pt+ZBVgrmOZqWnzifoIKB7vAUi0LJiYVLHY1JzY2zoVqyXPt3fie7d0GE4zqGMy4Bk0kObHcF0FeoTJlaf5SdHs1qu/s6
 XO6GYZm6
 uio7In7woivK/CWCVzHhicoaACgRvDsRxJcLy8ldW58dkDVnpWijbg/2aXN4UusZQmW7BsvyAxf/sobY36orfwpnfZhGNMfmayJftE73iCB+LfcZ4GaJAeB3bVg31xhgtz9swVAWVLo17IYFKIpLL2UgqgEQTassnUkVREOuZ4/eM3a5N5zxxviNzaoZ55uQuDpatKjYwL74QF+6hWwTMpq/ecKOethmFjRDEf8KCCECiqbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added DAMON probe preps
feature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 947d91ae24a39..d036340dae8af 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -309,6 +309,13 @@ Users can therefore know how much of a given DAMON region has a specific data
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
-- 
2.47.3

