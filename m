Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9690D105F79E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08996B0088; Sat, 14 Mar 2026 05:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5BE6B0089; Sat, 14 Mar 2026 05:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DCB6B008A; Sat, 14 Mar 2026 05:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 990926B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:21:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17316C2BDD
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:21:56 +0000 (UTC)
X-FDA: 84544126632.30.E870BD4
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id BAB0D4000B
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:21:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QEJw14CQ;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773480113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r8UyqgPfbZdaAqDYqS1YD/8TcYT8kvUB1s3GvokTCwQ=;
	b=bTJ8ilH1a20tO2P4hQz418MPqkCdHanSHiq+V+9wilm/HbTLZGRCRHsSgD6SyBrlOZDNDt
	SFF1K6KQcgRrh+jJF/4mAxjR8ftfMqUDJeMdjOXPPSS/fWOMtaWpr5zCnQMufsNJXukBeI
	MyvNL1HQhUbcESH+WjDLxyBUPefg9GE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773480113; a=rsa-sha256;
	cv=none;
	b=IbMDl/LySLhRyTqeKpVrXoEgRqo2/sDQ4/U9FR+ILsS5rfs3yuwWFPHUXZo/NVKkOmVYHe
	g7Y1dwlPI5uTetiIUgJTF/qAKIYzeTHyeKbo2O39O1xc7Hnm0YuI1jTnH5mH4OenEZ5z8I
	zGw6njMB4uv7iPj70ad/+/LBHlwvqV8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QEJw14CQ;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b04075d1e5so3591145ad.0
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 02:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773480112; x=1774084912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r8UyqgPfbZdaAqDYqS1YD/8TcYT8kvUB1s3GvokTCwQ=;
        b=QEJw14CQEEpnEkxRXj1UPZ+vlmGPaAhc/TjZiik6OwgVY25hZbqAvROR5yLbTgR6gU
         G+7mbI/7m0ISj/SuUSmmgMfMDQd8R6rrZ87rwlh3NsckADNMLkpOtVHkJscTgQ2GkRUB
         EVrmNuYHdR0T6JXvxA55qgNGhUJ7Ayd2GjdDGnEQLyc2cHskv/NgNN4eKmad7FJys7Gp
         DYjH79c4XnLzA0G9SkOj0KO+Q3fI0xq0lemYXX/k0M83RQNSneuwtBip/oSghDHMvmp2
         Aeide4bDyO81thujTosWp1QbxPO/VM2e6zXfZ28G9st/U3aqNAqKX5YAFqnynG7dk70g
         SMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773480112; x=1774084912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8UyqgPfbZdaAqDYqS1YD/8TcYT8kvUB1s3GvokTCwQ=;
        b=LbD0/YLkQ2TvhYnSlEmQ/r13OZCgnU4s56UFBuNYrGbUYGHr7SFW2u0oJginHJgV33
         1GIpJkFsQSS+FtHHuyxXusxnAwDAk23D2i8/w4XBpqYhOvISnUfaExwaLUaGJBMpdB7w
         fdsKJTgRSXhLOaUJKgAXuNF4LQKV1xJd88J4RPs2y8iHKoS1TjWfNz2hxJjwBnTwn8OH
         FNUkq+MNSeQpaVTSgw3H1rr0faWYUwhctdY/12xKcZ5t+F/UnLawE+nayWzY+iYG4MTt
         fCKddU5Q80oXqTiBkatM+yOV5VjYuLtgHf/hiFSCafp4kgWX/FV5KFUx4haFxsAI9k6Z
         /wkA==
X-Forwarded-Encrypted: i=1; AJvYcCXoYXfP1rFSkW2DrhZvv0uUdzFhBokjS46iF3YSQl8jHFfETj/RrEVjfk//MW76I4kwoFDHQEa7DQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9v+0eoccOQhK62dwa77Wo07B5QZQHUtr2MNls8z+uwHKX48Sp
	5B+W8XdJHdKOvXNBygdREoDI+y565fMT85zMSKZScr0lnl/8ZlzwDD2G
X-Gm-Gg: ATEYQzzrWa9q6mS23J5HJAnxeTwKTeUDy3mGX63wmT4gLzNFHs3U9WZ4FDWbZUVogq3
	kEVIUBNCy5PJKXoqoK89VG31uuUtZNnnnU3li6nUt/iUDv009voCAb8cuYoCHa1WoTBFjvHYTzA
	yDIo14XItXiVcl8t4EFJukkDj5or6gVyt6iVooa96U8An1aG64nTR9+QO3Y6zSNxV3NNpXMLHa/
	jSJHoii8UGiJVL4Sp17iGsabKAWui2vBMw+6ToWnlCOk2/LEN8pB7Z3Tk0IAxszWBpdIVzHUscU
	axsE6pW234QmlsPrjEAVUA3HgEyh5d3ouFlOK91u41T9QK5Cbuf5JGgGsU7OFVzamnU3u7MQHL9
	z1G2qgAHM/vYyBnqDqc//G8WWRZS4b5SufX54RQ9UKdwPGdKJ9Kgz+V/OXg5HWtz7hmqB87MYV2
	TYeaeYA70wjLoG221AX0SbgCgVMZvcKsM8npRkoL1QbLA7dkF9zoV4rQEhDSpsZg==
X-Received: by 2002:a17:902:db05:b0:2ae:5eee:7a5 with SMTP id d9443c01a7336-2aeca9a9d72mr69364795ad.12.1773480112336;
        Sat, 14 Mar 2026 02:21:52 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:89d:b6e6:2613:d00e:127b:1c64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece62c4f9sm47907385ad.38.2026.03.14.02.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 02:21:52 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH] Docs/mm/damon: document exclusivity of special-purpose modules
Date: Sat, 14 Mar 2026 17:20:22 +0800
Message-ID: <20260314092145.7496-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yoi1qfae5frpwd5dj4hktqqkk7iaxrxa
X-Rspamd-Queue-Id: BAB0D4000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773480113-564569
X-HE-Meta: U2FsdGVkX19rEXibhOAnPyQMt+DYq1CxPsqtxlKr7PhqfpQbS5c6mBRXuBBUMwDhmHITqMT5wsXDMYN04nz0DtO0VRKG9ajYNt6YrV8MOjDNyF10nPgp+AsCGsnOaNjZIE7GJsm1oVZAzUSVCglb7UmlpfzEW0gHA+i40gWJP2VlqBNDOHIRcgbnBJJDzKSSCPGsQ586VYAib9pamvb5e3seWg2tmEdQKiXLosHWxI2DakW/0v8i6znwuN5Cv4NGGuiu5V/G2lcThzjepwHPWhZ29nmLbM++RK/O0LlCqFkqs+mukyg2Kbz9vraGyNtbuBoCZT7gDCLMluUO4QcC7E/tH38Y9NXAoWE/ihNBl710UDj9243sfasKeNoPDtipy2BNXWSeh9C4WnWs7o1zXopQ1Z77FrGozqA4SfV6zg3vGoASH/QZzwrvy4++y9I7Mn4Q0GepEZuYazgKs5jl12PY7tdNCCpoupzR9X5jiI7KF3y5mhz4yXyuWiz2d/Ba6MWzQO5M8UjYHLcO+uKbVq6gVXcL07XZ+Cs4EdUsW6qX+t93TX9LG31Lq0BLTujr2qbJ84thR4bYAWd+eYeLz7ZgUx8r1P+EKbxP6OzvrsDaNd73IbkVbydfb63NxeVSOlO2vNVrYongBg0bBaTQUR1vbzYmWT8O63uDw0KX1pX0J34jPZ+YCD3WObMYUThf2coDF9LTPlvox/vKKFJuJqN45cs2P6uPJ1KOf75YUHqfGTLnVPGYkXPO3qvZIaB5PubMdB8RCAGJfZZsXHY52srJ74YLBFF5nRwNtLehhQnkyhZ21dMyB6G3CPMTtzu2/pjdLERFqg4W56GsQhX+9BHQKo8PLVgFW+UyTXGz0d7c/3jlq22w5nqZBj1sFWm/9zEE76MBzfLENk8Dwcbo7c/UgRwConY+j27TzGUAkWZym4TCnJqjbVFCeDcRUhGURez/nKuAXrViuOivCBj
 iTunHIdz
 N4wB41mqvJs4hyE4z+7kHpmB9bhg9VISZgFxqr8YuqztVV4U4y+4R6sM5eZndUfA0Een+xmZfcY62atmlcND9xEubYu/c/em8w3wMaLOzoEzboPnnZB+aH6kgNA1sD9B/zN315zAs4ylyJvLISWg8yUo0Xt1uYMrsdz8zF8Y35yY1QO1mWXRM/q6ry45mlJDdF0L+QflXXrrqWT2/b1FYlOp6qDqb7xn2MKva6zdYfcnhnE0g9U4RMHncmFlfgfVTlBq0IHMhXbQsP15HHeDL7awYX2fBCmQqK/h3025c5J75RtY00dgbdW0OMLgchQ4Ss7fa12vG+xeNwFttNd9QPRxKzJyFo4FQ3So1ZhOmL2yK46ASTxQnqqdhHr7ariuWd3lS98Ba1UeWxhRXsMU80yranFMWXp+rajzeG23ab4HgOwBKs7pz116MrNALaKFSYoSZ9cIZz8N3lkjesHqDvNQ8AXgjq7+rX3jMI35TTm7SObDzBuv9jL0LN42U33icZAg3a4R8i05RRfN/lk5+fdDjt+hyteKH7GJtTR4l1TgJ7UmbiIZcy0wx9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a section in design.rst to explain that DAMON special-purpose kernel
modules (LRU_SORT, RECLAIM, STAT) run in an exclusive manner and return
-EBUSY if another is already running.

Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-references
to this exclusivity rule at the end of their respective Example
sections.

While at it, fix a Sphinx syntax error in the "contents" directive in
design.rst (missing space after :depth:) that prevents the table of
contents from being rendered on docs.kernel.org.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 5 +++++
 Documentation/admin-guide/mm/damon/reclaim.rst  | 5 +++++
 Documentation/admin-guide/mm/damon/stat.rst     | 5 +++++
 Documentation/mm/damon/design.rst               | 6 +++++-
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 06a46812a728..0198dfe87f4d 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -353,3 +353,8 @@ the LRU-list based page granularity reclamation. ::
     # echo 400 > wmarks_mid
     # echo 200 > wmarks_low
     # echo Y > enabled
+
+Note that this module (damon_lru_sort) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index c5b4d8a1b001..a37ce6fdff05 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -331,6 +331,11 @@ granularity reclamation. ::
     # echo 200 > wmarks_low
     # echo Y > enabled
 
+Note that this module (damon_reclaim) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. [1] https://research.google/pubs/pub48551/
 .. [2] https://lwn.net/Articles/787611/
 .. [3] Documentation/mm/free_page_reporting.rst
diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 468c122c4259..46c5dd96aa2e 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -45,6 +45,11 @@ You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+Note that this module (damon_stat) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. _damon_stat_aggr_interval_us:
 
 aggr_interval_us
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0a3b77ec458f..3694c541e65a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -5,7 +5,7 @@ Design
 ======
 
 .. contents:: :local:
-   :depth:2
+   :depth: 2
 
 .. _damon_design_execution_model_and_data_structures:
 
@@ -960,6 +960,10 @@ more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
+.. _damon_design_special_purpose_modules_exclusivity:
+
+Note that these modules currently run in an exclusive manner.  If one of those
+is already running, others will return ``-EBUSY`` upon start requests.
 
 Sample DAMON Modules
 --------------------
-- 
2.53.0


