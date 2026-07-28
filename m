Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4334C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0E26B00A7; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A716B00A9; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49906B00AA; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A96196B00A7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:13:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23D6380291
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:13:01 +0000 (UTC)
X-FDA: 85036864962.06.60088CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F1B040002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVsc48ZM;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zxj0qXZlLFjv8Oo1ubEI7gb1ZBWWHlkx56zIdj50cXg=;
	b=jifbqiN1Wt2MsIrw1B43Q5LD+lo6LGJ3ORwXaYrsMQV4uZM3kxP+/xclCfig1AsMwauQQ0
	Kfq6ufCMw5DxN2nbpyQCd2Fh43Ou/k13xf8+qQySWE7rs0NLQTRXBjjVs06ZuwAl+Sxn8h
	2WDb7wtruuPqnx+NNu0SfLkeP9X2nLQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211979;
	b=iHqLXs6ddWnlOCDiROMNdTarcHbmCZUw/i159CiikuvLcnT5wv7ayxED3Wtra4BrBkg0ja
	WTXfbJg8vS4s+i0vgYucd7opXpRT25B5kFw1C6o74jkbvxGAT8O7ZZ4B2UuVVxBxF8nx3+
	YpFWlYDI3vbvQI4J5tZg/oUC5tk0KFM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVsc48ZM;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F3CD60A75;
	Tue, 28 Jul 2026 04:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705F01F00A3E;
	Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211978;
	bh=Zxj0qXZlLFjv8Oo1ubEI7gb1ZBWWHlkx56zIdj50cXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVsc48ZMsvgyiWMHlS61ZpD4dNmpJRBDNPgwVvto//guZxfLhO+F8al8yu0jjFz4X
	 iDvOZwIWESzX8fm05Cm676tXJVryNFIQ1DaXKw5Z2JSUMrHgKmWrt2W6L595mPeOmr
	 /mrnbLBxTtfsCPJpamBZYR73gybiemFKOL96URlxN9/63L912MTZH2XSUMFj/JS8nG
	 4tDpSKQJtOoVNAmm13QD9kKJSuAiBzViz4XoCpKel3zeF8DMP8ZzIRzHX9Wy2E4qfS
	 h17jbIf+t6lMyg4SkEE9P5zd+ZoEMAqdeHYnZBAuEf0TlCecn56RFIIylWhj5iPyqg
	 V43wSVl6sFjjw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 17/17] Docs/ABI/damon: document probe prep sysfs files
Date: Mon, 27 Jul 2026 21:12:38 -0700
Message-ID: <20260728041242.187380-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F1B040002
X-Stat-Signature: tbhcpn5wckpx9c56j543tg1hwj8ygzmw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785211979-276986
X-HE-Meta: U2FsdGVkX1/hhkznj3ZMEkUPQ5JSsN1PGYrP94s1qXXQzcj+uL3utwOllp4HcLzufKJY8HBP8ZL2/3dHeLbtfF1Gg9WZfGAgP5VrcpIMibQiWbKIqTzC/jwJAN4FVPMtTWwGEenO/uw/yKiZ0k+r9OTV64aajegz4SHhRhgjRIa3xItpjFGYedPsKRhWj2bd2QOQxc7IPVSLSHB+oxaTRVrg0f1DIoxQAWkgxawu3H+QiKwAlIhfvs6US4fmVHiQzJg4lSmqjue/rqFNnUzDMUctgRmY0TESUE+2OpqZzQpFQdNvcfp0crIf/2yXLB6LJSBy1SVJNt9eZfC5IP6RqPrAfDPLR290zlwB/1ZJYrIuyG5etccCQEVeHJHYRze1YWHhTcGiHHOnKm+h5VUhsbdBvrP/ei1enVXPoYvIbxTbX2UUf6rdpMjgnVYvZ4Vg2AbuHE2NaGWwbDvD0rHQLkemiyJs1qd+MOq9AvuH+ICOXQcpVmQkoIRBlzN9RX/7w0YzV5A3EDWGoVs34PaZWe0cuhShWvMrYlqV6RbixjbQF8OtmShXoN2BWbA7yJyzyI0Sd8C3OHvFs0hb3ZRGjRUo4+oEiKvNZFEKupTU2Md7kMNKy7qHF6AKf+ghq2HqIztjltm/f17/3nd0jrqhg006ZItQ/Mnr7Wpt0aPdzx6gOWTk1pgjBt61oyAiyl+5r8FFUexYHgkyjCEzRx/9nzJEaSh9vk8kV6fFsEmGpQIyrkwlBYkqEZGxVXVTTGk5kvW6XR6N46iKRzXR4SYfr9mtsHf+lBsy9hqR8+JVVm4jVI0ih812L6TgDbPrcF/otxZPbCqVG7xhmAmbZw+VTaNFrpsgZgBL671cLrd2hrue3vqrDD3uInE41v+Wqo/VO++DZFdAz1OIWDewHnWrLvXvL38mJpQX593XdGHPfxVeUYr5lo2siLXt9IXEukoHsDK88bwUSIK1MnQq511
 iLYznQ+c
 SGKuhW2P4wmeB9xUpYO6UI1p8AXdWDz7S4N4VwvfQToInv0mg7jlxOYlKrg9bzW6dBN4F0EEU+mI0tX2N2D+h1nbmEI5VUDtsekCYaAkzJSZGu0JhgvBHZSu0mCuJqh7H8bOg6p+t4+T1qVSr7oK7sctC5W1qY8Jq133s5NDMWXcZsMfMqyRIc0D+76nDtWxmaReCoM76U8MqACUW9tp2mJGNB4eMaZlp+PrRUdnOC0FxV/rO7gBx4ZpCzS3PwJL6sZ+R/eoAYDmEzPc=
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

