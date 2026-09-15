Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B6DC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E39D6B009F; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860A76B009D; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700C56B009E; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48CCA6B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6E8BA02D2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:42 +0000 (UTC)
X-FDA: 85214365404.07.C698C99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46BF114000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZEaR+tj;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	b=5ehedF+hIojLEdg2Y4h1nNbUqV20AX+gjDQlnvZhyw+O8l0D6OPjFVjVHhlRMsyyObW5VO
	Hp2/E8FYU9WHgSHhW6HJ50CSp4qULIVUjFeFDW4Zd2JaKHGSHAB2X+DF18RO6/bJ2YgCJQ
	FQS30aVgNSagXJsW6AABTG0ltiQT+QA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438181;
	b=GVpUYX9NB5qQD32smVQN4S0Mf/SJdLQ5zICF0B5EnqemCDFU1OtuQxSi+uVvY+H5GQegQR
	HpR0O19F7NnJfaE4AfAYEJmGZ/dAwP12DLly7IyFVxYntMING4xsEXmgo/XxLOKrBQ2qG1
	W+xfB2zuCuCaZald1vaeajdiuk9Ajrw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZEaR+tj;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6B326025F;
	Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F16B1F0089B;
	Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438180;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZEaR+tjQZp302g4QcqxsMTXQ0mr5kYSEZDzn4TUhQeprL0iJn/7uPGhc/hTk6EJ4
	 R68Mfa561JYWg/IURyV6qoMK6+TJu/BqoXpZWp4bN3JGvHLXcabEReW5VCbkwHSmG7
	 GK6JIEvQXM9YrjkWQreC7YLvBlfPcKcy4ZCi6bNSmwm5ZUQmz0uS+Z2d0tpPfZgEi3
	 o6rdQk+Srftd/VuCLmrUXsH0IFH76bmk5wEBEPd7PggzZJO/DC1Chs8hhjkNZpQDQo
	 PJz2i+0ypqcyir3TWLs2BA1kGQLunjUWZoiZfhFmznW1HdgwQWbGR93Js2km4GTGet
	 QCEXGuX6zEJpQ==
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
Subject: [RFC PATCH v3 6/8] Docs/mm/damon/design: update for hugepage_size probe filter
Date: Mon, 14 Sep 2026 19:09:25 -0700
Message-ID: <20260915020929.102953-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zre9tx9sq4eux14wunuoz7xfajnz1zy7
X-Rspamd-Queue-Id: 46BF114000C
X-HE-Tag: 1789438181-979109
X-HE-Meta: U2FsdGVkX1/1bKTm4EqmRKShpiHrmEx5i0p6psUTwvmNmAb7Chn/iEVSZYJDhMREE1afaAkRBR0VZgq1rpgCfI8D5gt10Kq/ZYZGzFPP4wTkceKZIOD9KfriMFFiRE3GWDOUiPerKWUll3EoyAKSbLgKM1vqmalYsFIcwlrNlMc065SDGCw+mehXzt6FMwfu6EHZwH2+NHpR2ygLTDPdB7Wm8knkIo3vFgwGewJUr2Jqicl39SQZE03y8usMundIO6rAWPvKLiDn+yqDa276p+pNCIfJQdhhIa/SCV7ks4xhxt8Y1aOb3NmHWOg63vDfYFJyJmxlYTnT3YRjoKFg9cChTBgytqdluOGoBfGT6nt3o+wvna//CHjRE1FRX3X0UshzIOV8s7Uozl+IMcykavMn3Ggh/aHFhOU2fdmgD7AlvDs+EcT1K5y7zjMcuIX3gfPAswt+SQ7DGpNt1WHhZPIyuxn5xwbHWm6p5mOTG1T+fTmph6tGFqyfroYF84SMM2S72/UzxMrAKrwK1eLSHsWata/BWH1vDufKu2J8Bd8WZhEKbEr43411f0cUPWtB5OoFgPjRWTHtzHWosTDCWs+qKvF/nZ2j9N9PqoQ3Q9G9bOGmoKwsfZx60GXgm+1Njk1y5ufKaGsnIohtQgHVknXL03kHqihDo+657mMvmHrzTDCtadZdumELYr3J6gGbvtqUZ67M+/3twwI6nbWV+MVkpdpcCGmYfrWAHlkTPVekeqPb7Kv3fwvkqE64GQutlhvYn0Pgh1uP0cNvwXLi15+FXhPATn6miji11GzZX8uBE7ZbKdM12zhy3P1h4pgEM/aOVw9CskIOpFfjYgOqnOJ9vRqrFux06cpw2id4RPnnh9JTJjRB8TAlPyCkGYG6ELlCrKyenkkAfrR5o0bYASca1vZ76ZEAW/ZCZmKWURJfBLkNZhc3zCo+pYSTy7ABrOPOD1tzdeZLivQpymL
 n+BfMkn4
 Os7lOaw49CSInLxMqx2IRxqDYTql2rhJ3OwCPBDjyOT3G2ezT9Zu3XJvQFszVjdxaYLTQuhG+Y3dYlicPcW5oQG8qeHFOVg2kiVLFr1r6AO5/hzzCsM7pimqELlsL7mJ0Rxv/pMfWCI1CQ9e5PA3fH1m5zVsKuBwqzWUstDIYpEtiuAHzhjh7MC1w60CnnONxoltr0Lwspo4UerSN5fkfdMPtVSk03YBLvJnL4bCYXSrIbMLtW3Aj9YuZ25LB8GH+6ONC/XWhITrfDFQNoP5JgZcoZa79B2FRbuFuGiJvZeXH7QaL2anx1eVO3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added hugepage_size data
attribute probe filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 707170bcd1b33..0a86792f90a18 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -300,6 +300,8 @@ filter types.  Currently below filter types are supported.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
+- ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
+  of a given size range.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

