Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C7A1C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D426B010E; Tue,  1 Sep 2026 00:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6206B010F; Tue,  1 Sep 2026 00:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82316B0111; Tue,  1 Sep 2026 00:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9D0A6B010F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34B77402C7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:34 +0000 (UTC)
X-FDA: 85163927268.10.A9CDC89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B3D6100005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KYef/bpG";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zxj0qXZlLFjv8Oo1ubEI7gb1ZBWWHlkx56zIdj50cXg=;
	b=arZlwollpQKwO3/3UQfV8zfVsLSCr/Qg6ytFzBGHak/BgE5Ul8M/5NMA0LMQ1obY5zrIfN
	ai+ICYNSdkVw42oLq3tRa7TEPG8D3yo3E2qM8QQb6H3miASFY2zkGyZtDmh0nvI6li+lue
	lnF9QZln01cyPxLcKiFgDKpvRYfeRAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237272;
	b=knK0bzYg2r+YO/LuOpzLO6UZZ023M2fd3D6d/xz2OJpokXcQ/u71bkU9EmU8a2UsAitmgZ
	Qv8bRz6NZ2oTqb+cY7CR0uZ2cr+59k3hRRAYv8OhK9uVaLZXXjtIheeOmUBT2i5lddIJVG
	h+k9WdoBOUmzzPYkb22VFUHD/LHCYbQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KYef/bpG";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EBF14013F;
	Tue,  1 Sep 2026 04:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F81F00A3D;
	Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237272;
	bh=Zxj0qXZlLFjv8Oo1ubEI7gb1ZBWWHlkx56zIdj50cXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYef/bpGHdth5P4hpCVs8AlrupN3bO+g/Ct0O+xni8mx5I4W4aahUiVZOSvaeGt5P
	 hFQr4fppHSKmAviFXy3GEKD9F2/WlLSse2r99DeEt3jwhJRPXwqjk71puz7Zm6A1p8
	 1csdIYo6QqE5ct8u+ONiCVPaio6JQERUgSb1EGHaIOaBApezvGSDrF1CAp41wmxpzL
	 kiku/sCeJaebyCTbU5DDEjxJllIO0lHjfTQwmHe170oOIzdm6RKYlvdyIxrdvC+26+
	 WiZGwNs1kKYsBOBytH2hvAupF53+GeWUzC3SJm/vGmoS4GGcZqOMTbxLvfo8MAuBbm
	 0ZFv0izsEPekA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/17] Docs/ABI/damon: document probe prep sysfs files
Date: Mon, 31 Aug 2026 21:34:13 -0700
Message-ID: <20260901043417.2165-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B3D6100005
X-Stat-Signature: 693b5thonjig8gif6y6xfg4munn4155r
X-HE-Tag: 1788237272-732414
X-HE-Meta: U2FsdGVkX1+V5nLtICZ3bHhuesDMYOJOx29nw254+6Nq1/rBB3L6zlXgxL1S1YzH8gElUlr9HUev9kEVuZLJkgctBBUMtUhpS0iELydmE/eIceVHu9avur2TB3PDCITro+eCbQBaO8BTtKIp8fKTQ0ih7PllGrNVY8ZNR2LnAOOY9BAO2yQDcHU3bX4XmrBO54jjf8s6bNXr0jt5+euRsTl4UYj8sAScoxIdV032hPbju1Y8bChDgtrZZNcdMGeKQa15LeeG02jPM+5znwSxsAWZ2UVj+sN6kqIOSczZyZtx8TjePnN6ZVPRMpIQxSXCI1m21a9W8//+5jsYOY612PW/Nd9sAWglTb4XjRHhbT2LTd1iXZzQKHMuxGHyAY76iQgAYkg2vPuK7VwZmPRiE7U9TOpEnH4CXg/8VCujJT1HZ45NeZke1IIC48O/18ipjZjiCZ9RDrzvqz0o6u9hUZe55omHuGMqIsxeNkhLX6gS6Tq/sV0ZjA9XDUQZNyXqMA7SgEpn+kMJDgZQ9zW3FhUf6OsVYTDSEWK0E91hmxvV1O9A3lsttGKuNU7CBiPInLis+ex9apxzPg73+Ed/SpKTMvvWXEpvQDTeiEOMD/i085oJPP7kQZWdNZhkTj2xLKeT/GVbW1zMwOzuFeInsZZKTLtApztCTAteU0V9jAtiKMMqM4nG6xkynoJaa147uHrLQI9vpOXta2TinRS5h0tPPu0dIp898XUtjdPGwRh3y7YwB7GZaXBVO4ENEkV5MehpuHWMNbFjZs0pLLVvD0JkOKnkgay4QHH9aIbK7Jt454vNOHqRBbquwGM9h9msA+xeHGBSlp5ntustC4x0+PVDhYku+YdBvILlEkO4VEtHuuJKFaa1J0398/eWURCsDN2o0XpSCv/X+XhgCe/775Gf3xn6eMaCuJpNccf0bZqjgJeGylOqLczyISLTcknp4PGLja8av3OogpOrip6
 hut7qC4d
 j7cyi50T5g9+CDhZae15kyaaGISzTZc3SI/5OBCAPJOMIZhzbD07uVZwaN3ESVsKOUbJYMt4k0V2a5hhzfRK2rL7R5njhZb//39jHf0PgwFSQ+5OsBt3DtsYX2gXF+z3szs/cMzHkR79g58tPK7W5h+utfmjVgFJx3Q4Sl0Mq2sf2VbHX7u2JHuuMS5YIGo7W4a//t3V1TXHApPgmoHySntpO/IHbbB69y/txJ6XsSXdVEHb5K8BKL5jobOiXDv/GJpEQCJanIJmbfM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added DAMON probe prep sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e675a57145e36..f8d2601e82904 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -173,6 +173,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		per-probe attribute weight.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/nr_preps
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probing preparation action named '0'
+		to 'N-1' under the preps/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/<R>/prep_action
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the probing
+		preparation action.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

