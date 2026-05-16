Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D72CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D634C6B00AF; Sat, 16 May 2026 14:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D354B6B00B0; Sat, 16 May 2026 14:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89946B00B1; Sat, 16 May 2026 14:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5D016B00AF
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AF7E1403E4
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:38 +0000 (UTC)
X-FDA: 84774141396.14.C299EB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D57CEA0007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEvgDpTH;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLGxhUls7fda3WZ+tJ6CcJioVVB35IllZH6Z0eF79fU=;
	b=j1KN0yQ1wftMRCCKu7lRFz7KLr3Q2oajATjffJpS6CMDs9hIaOaWPge3D2ic9ZipnhbOtS
	8QjOPui+8WiffhbJFwOQV0XoZnOX/tb50JqVzh0jauwmDY03i39i8727trsZSBnsmc0FTD
	jv97AoXRr/4O0IWNlUtzp7T7eBFRo9I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEvgDpTH;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956656; a=rsa-sha256;
	cv=none;
	b=xLO7QxcNe3a58xAYlbGB6cWCSLYXjG9NuQI56fzC2PPrn7bl/DCbnlcUqA8CtMj1GxdDev
	6CXZ4wGGQlpTKv6nuh1cNHz4ZaDSBUfCSQnM4kdZ201vTyju+Ic9WeJI6LRsEr2lDxt0s7
	eiXOEtsoPCYqJTHBtUYPCAasXm9gXgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FF106020B;
	Sat, 16 May 2026 18:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9452BC2BCF6;
	Sat, 16 May 2026 18:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956656;
	bh=2ezmr596RCMSl8GJn5iaP7SQwY6FO5nwtQYKenA48Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEvgDpTH3zyWW+YN6W72epS0dus/LicSC/g6uHpwevrjqMsjmJXObfl863R2HHT9b
	 miL3e7k5t/sewh13qlcBGSUdM2CapWSO4SChKv4AcOSbEyDyIdH5JKtV/+1RHjfruC
	 78nXdWXqDQ6PTM3vnR3rKdXxX29VNXbLZJB9YIDY1u8DHv+gNhskr8DYgyCk13nS6O
	 eWXFjn6jAXDtZThwLCd9hgqLtMK3y3o4NjjXyGG6/ynmbJ7a9dC97rN83TqX+jUIjb
	 OMYfwxFxxDrkuwE1tSgqslrSBMQSago0ixpzXe8ExzKa5bNWIIDK+MrleBvkAKAgBx
	 MeQSe21SJFK5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
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
Subject: [RFC PATCH v3 28/28] Docs/admin-guide/mm/damon/usage: update for memcg damon filter
Date: Sat, 16 May 2026 11:37:09 -0700
Message-ID: <20260516183712.81393-29-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D57CEA0007
X-Rspamd-Server: rspam06
X-Stat-Signature: 7p6j4futs7u9fn6c5ap3txr3t4auze9z
X-HE-Tag: 1778956656-88633
X-HE-Meta: U2FsdGVkX1/aRkFwReo1mM6whQvR0S5S+kqYnZ66ZJZdwD5gmwwlX9zbp6aZjeTZk4i6SfpWp6bfXdpOZJ2hUo+s1R/ebJd4ZK5nr8tM1A7iwZkhJvksCfs7IHTtW6iMGArkrNLGi+Zjn/O5NnDEKwnwhtKGxp3zJoKdIqeFgLQ8n1Naphao/OZQax2cf4r9SXbqcdJV8l0VnniC2BMFFTFY+dQQ2fu8JzNQwANPwzMifqL633yJL+gs8OJEhniB8BmZmjM1JnO/PNHQ8rm+RHQThV3fwAPHll8T6Tezulz0+bM/bquu8qm+ohefgwXKOIv6UQW84SC/ykHX6TSbR8sfv+d3KWUWTzPuygmnhJSabFlOJ8V2qzqwnW3mspEGvpyTuflp02YZLPurtB2AsWfCPe+O8hD7M1VbrGhdENNCM+3BLTU6ing+E1JPP8I3PopF2mIiXhS64wHdJ5HqvSTHdg+X6xlnrEtYgl6j3qYzetZ6mGk5U9Mnsj/eZac9nSKFCG0Tua8GXaLc+FFyQky5GJbVQg7BQ8XWlfCLze3SeLJ33Wyl0p6dWe7b9NSQNzeipMJrmpThy7hqps489i+/W7UOpOg4UJf+xn+z8o8uq0nVuTILpZGffC685Q7bjSu8BzlWsrzeAtRpoHs9CZOdO8bGTGDX+5Ssv7TFw22vIdZpB/JlzhraLAtbiycNZwNqtG51hMghf6ooUMx1BxpbKpOI7ZoLB/Jo22vVXbai+CIfBKrZVgI9kylNF57jbLv5c108uI7GM75s0yEK6PDkgBzkQL1B1P/5YziIsSZMuwKrudE9YZrutKAbqzjBDzd029ElC1U3oKIXc5BqJZzbpZ2xyUsLSDNA9PWg04wMJtimtczt2ho5e5HXpnAMse4nmHV8wy+u93lsS8lFJxteVdxeho1CSBX/wOG0QjWQpRksiRt/sTuHFDucHrqJUK8JuJ/nqmGJKJSjEaQ
 K4Nh3am+
 hGi4URKuL39IZ8pnNpxoNr6MzKKnP5BQL9pXJci47CPyvzVR5mA+jd332FWXWVAcvGMzJSyE/wXqyhmzsCubryGzQzCD0cOBK7XS07GRfUSrD7OzMDGdXsrEXQ1JSg6sbm4wLQWcz7G8/aZMqCyx/954CbtUGd3vktipcRnkzg0sTWojQO7DlWSxVfRuDLKh3+L3KCt7MGO/mTmuNBayrdYiMg2aCaifsiQgIiTKGLJWBnoB3llg9noMoTfXOS8DoY9IElWbCzipWjrLvqrcIRIjKuioczAqlrIhsQ5MiveNB6oPWiIteLBvBUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 7b6074a1666f3..b4584c0e4cd72 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -73,7 +73,7 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -283,7 +283,9 @@ the data attribute for the probe.
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
-way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
+``type`` is ``memcg``, ``path`` file works the role of ``memcg_path`` for
+:ref:`DAMOS filter <sysfs_filters>`.
 
 .. _sysfs_targets:
 
-- 
2.47.3

