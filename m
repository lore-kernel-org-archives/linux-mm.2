Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BA8CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9656B0096; Thu, 25 Jun 2026 01:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFE76B0098; Thu, 25 Jun 2026 01:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102BB6B0099; Thu, 25 Jun 2026 01:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89FE36B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEE764055E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:11 +0000 (UTC)
X-FDA: 84917253582.15.D8DD80A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F1C940009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EjlAViuN;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364090;
	b=YhDOGBnEgK8SfQBWL5PObU3DlnOC5lmj+2rMDZoRlxTmAVPVX6CvpaCkFaSk29WOS/G6cj
	y35oRIBYNnmcq3jryneY3vj/WgbAQayaENKZ88wd74K7MMh4KtSmj8B5jnrxTINySpR1mC
	EbGpPswMoBzIDZUIQDV/9s2hu3ZX4Fw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARqAM43ohvafn9UnTqgU4RPIXqjonzaqaC6qJIpJbfo=;
	b=ql39eVDddcRo5wCNEGZ1oksjb9XRsZHvKk4FDmDJiK4uzcg3R7Dr8qzUSQ0vJcO1hc38BX
	wQDqYyeXTxAF3OS012cDvjL/tLFOgURq5rHJl/rEL4iwkWFOr1EB4aMQNBmngqgWad/Z0r
	blFQuvTNfJDhNh4bZLAgZjKkHkHfbGo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EjlAViuN;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0B8960218;
	Thu, 25 Jun 2026 05:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9913D1F00A3D;
	Thu, 25 Jun 2026 05:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364089;
	bh=ARqAM43ohvafn9UnTqgU4RPIXqjonzaqaC6qJIpJbfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjlAViuN7VP9dH5uZE5DNStA9OVBKWR007GKBVhzpt33IEFLtChCT+hoajgvYR6RL
	 svzp24NC84pc+IHlsreX4LlM0RXo2Yo33sg79blIETzKBenObu6MddmVTgkWpIMTK5
	 ETc7l09/41adA+zengVwSA/s9VsTFr1LVmbUN2GVTUli41BUiJh0AxvJ4gBOczMz0K
	 V8AsUPAm1+iil98pfkp4j8QT2OhA8sXz7Exs3jKqf9JIpC9Vkx2PWIsBVhPNyj71ZA
	 ZNmqdZll/N12Q2luiYrdNqHXJqes9XKkAiP0wuBMtLFHk9EoRgHD/WyYp7fuN4taHm
	 MM3F+5EXPgOCA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
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
Subject: [RFC PATCH v1.1 02/11] Docs/ABI/damon: document probe files
Date: Wed, 24 Jun 2026 22:07:45 -0700
Message-ID: <20260625050756.91115-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F1C940009
X-Stat-Signature: d8ziqf9fg1e8zpbyruddwu173rtccf6w
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782364090-33778
X-HE-Meta: U2FsdGVkX199W4u59nTmAr3B+4xzD11mxQlFtc1lyVXOlafSoFpiz42Xuk3euOlJFWZGqXgjgugN1FLlXnWDcRJL9RRN0OJdLHdtk0BKwGg7iLLvCHeVp0OGbjslc2Gq1thE3EPg4nQ22/t0NETg8kS2UF8M3yNj5x6JgdSO9pHZa3BDikcAxl4ElHimm3qrEIL1yFL/x4QFpxMEXJwGHNM1JyaWHgouUh0VuPSMBS2bZyeRa5N4OKRR3NFGGLSBIcX57QGyWstk7gqibCieQthxGdRfzbdBQoqty9OL7PZm/wKhtpvxruW2fki6kPCsOkv/HQgce9mMBgCh7OtOGfmrWbm0puBbhwpK87uyFuKeF3vWidfshCKC8jXJswiSIwwhKPc1xt0FZLaTtfkXaSNJ3BgnxowY4wcyTOr/zVKvplmbyJV0E5nMBs1O9Pwwcs9rJy9ug+QqUHNca2GdGPboLl1L688ZyUMEZ/He8S22k/YQkuOgR9EyO1ygXehOLMI1Y5Kn6DbDmc/Mb6ctoh+kaTFEw4kc/mascp89ko9WGg4ydKRmxZcCXx+zPxxwBKRQxvPZFgjg4rfKFkM12VySmSQ/llpWwcIcclLOG68lQzR3rqk8rG9K8BRAlcCDOx/TMjyezrul0Soo7pdMaYN8ooGlv/fveO/gWcCIGAzKvk5o4/xtwQCYXOXp7GprzcuqRgrdmJDoMFvt0szhyYekMf+D+ITDWkKASdU9NhY2qW8O7dF7VSPyPfAxkcb00DPmsollAsQsEE/uQsd4wUNa1uzbo3OXBU+DKViNX8Yc9a0Xq81BtKt+0ubra3bgVRVynoVSk6tPOc+pysuySHD3vNMFO84uukOdbpEr8DQArng0AYCdLilccm5jQfcZlGK6rHSHhJ54fMv56j8PoWejG1oo8vcFF9beHmEa4+L1C6JeNQ/JtbiB6gw7pURDS8dXX3CLyEwBygVP99M
 1PZzh989
 hvIev7GbvQLmlGrm+xrqZD2kwuPuEZ9amBUemAzG20I42rpCeHPQa6wv6m6zLIhjEtopStkKTQYDpKhk4+wGwazU5hkU6lj/wFqpaTtnJFRsVGBD1fRv6GyUgzrcjLxhD1nkHr2jnUQAVAeDjHvQBlhoozS4e9TZCXt8UpweGU4mQJJKlCvzEIE98xDwkSuuFLCDzlGrLmEKrDw0SgbxAPaTe/0RQrOS8RWo9GdX0VvbXkJn5dS2GMdht9lTDR5ITGu0gxa/usRpWq2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI document is not updated for the DAMON probe sysfs files.
Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index b73e6bc28ea5f..2815f6bc05c18 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -157,6 +157,46 @@ Description:	Writing a value to this file sets the maximum number of
 		monitoring regions of the DAMON context as the value.  Reading
 		this file returns the value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/nr_probes
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe named '0' to 'N-1' under the
+		probes/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe filter named '0' to 'N-1'
+		under the filters/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/type
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the memory of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/path
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'memmcg' is written to the 'type' file, writing to and
+		reading from this file sets and geets the path to the memory
+		cgroup of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
+		the memory of the 'type', or all except the 'type'.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/allow
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
+		hitting the probe for the memory that satisfies the 'type' and
+		the 'matching' of the directory.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

