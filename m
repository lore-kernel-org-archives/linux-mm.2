Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8627AE9D809
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455ED6B00A0; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320956B009F; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1676B00A2; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E76326B009F
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91CA413C05C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
X-FDA: 84624844080.11.2F49AD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 046DCC000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mzFr1nw+;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SmPp9FW1bqj0VHLIVFKnPWuzW/YQLR8mb9hLB1n8vg=;
	b=Qw2sMnpkIxAUhiAOTr/D+MfUOHr0EayHi97Pr+iShVbprCRFXfcIC73ctaLZgKQkNB6/HK
	p2txiFwFZKe+eb5SoyW5ZcF7mGVAslVXotvP3i/CaK35emL3lEu43ZYgZF0FkElonF5ie2
	Ks6xLJ2V6TEGuvqbN6HIiQE6DJFX+ps=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mzFr1nw+;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401959; a=rsa-sha256;
	cv=none;
	b=JBpBzy+sZ4xV8mPWb7OmGLmscc9hfOXVwXMAOND1d6ALl+preutDE6nApF2ZqrODRF5HVS
	DNDN9lUFs/nFNFmRH1CyuQP5eW2KIMVthGDaBs95BVdkJZUE4AZsCdjh6pLHVzgYk6/IWi
	VuHYBa+rgyvKrreofXSauz15Mh4CvT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90B8760123;
	Sun,  5 Apr 2026 15:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2F2C2BCB3;
	Sun,  5 Apr 2026 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401958;
	bh=wTsJFLfcGLj5hQNAgMMrTSRf9Xxnu3P2tGtJgT/UD5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzFr1nw+rcLAXTUg+EVg/b6BBnJx1FjVt1a5qCAYYpmhDWqAjJ3yYdFlWunnzRvam
	 S2v6p9qAsl/T4zATyo8fTQQWF1XnnqP2DDs+3C4Gg6L3PvuBpGt0Q1pgaSutQj2mS0
	 X/0TJRfkgObnxwaCGZl8o2kJNQ+rGkIKMxsSP5E/oREiCaCWmprOMUmO0dUnIcL3tr
	 HiROrLEK9WGTFhAanhk/cPDPkPyrzuN5l3F6xBiQbWbyETcohQ14/fr9/ri9b2KKPb
	 JpXz/rlhslBtUFC9BhKrMYDu0NSJzmWDP6Zfhkh67TECektmrGRmtX5WWifcYcVTvM
	 kiy6LRyooJu7A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [RFC PATCH v2 3/9] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Sun,  5 Apr 2026 08:12:21 -0700
Message-ID: <20260405151232.102690-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f5sxk36d3gzihaxkbuyk8b6u3txt5s47
X-Rspamd-Queue-Id: 046DCC000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775401958-982474
X-HE-Meta: U2FsdGVkX1/fEX/eB44NY6sJ7xt+3NvYed0jlYnPSsXxBmEhJSWRcuFzCS2W3hPAYs1KnlH6OjddnJtH3VJRnK2MvPNIBaFFMVi8JUR2Mc6paOtRFsLTl/dqqpQB9NAKCyQupIyHy72/rH8ZB7JGV1k2rDK1mVHIjmZpCSII+nG8k4KwSgld+YUF1vu8ZMxR0AB5wrZtpRh0yUSRX9jvCqJ4Lu2ks2ppexLTPwYW5cWFDkAH4zl9FRxFCZQJAvekoGhMwAAIx9RRISwJ5K/lT6IJHElzKre3tKNMFtH6OkOSnKN/8lBMLPSoo/JWrgnHoAgLg+O8TrNSw2FT5m2YvCFubGyw3MRGnFCHHbT+uxN677DIJ0VGj7yG81TyJktEyLaJRHetWwxcH1Omz/1dxPKqc9hfBx0e7dMEILRam7tGCbNWtu+I1LJHGTJT6fmaO+W5hYN2VcScE18ZB/6Ro2iVrKGqDIMhTCuj0ibkYtU/GWUrHtkicUTeGmRVKF6lW/Q/38twFaQSmKzGFIubYUnMiJYd7yTV6sTe94LMyW3So4XuemEzDm5zsBOs209vCqV+Uz7HZYfEEd98LNmTlyWiww66GD5+ONHYZsKqxDx3zfxSNY9cA/Ig2bbCJhN6IAkjGpBDJg/1fmTxka7kk9j43KD7U8D26KA631B5C2Lj5qnhfwMmociYlocj+vufc+GVI+uoa22IrCF/x4awTkrrZNKdYrc+TYgI24rqIC3d7yH7lQxXNr6wd6rhPJgDoHWULCOwD9EOeTSCQNvRpc3pT/hJOZ6fYPY+rOTKckDWoyEZd25425Ap9Yk+zZsLd2y/VlwvpbJlApHCIjforizGjLGgmu9uq53RTx5OLAWHXC0cVhg045aLgaqzVFJBs7kJa0gpuOnDxQwfRnkKp/M+RflD40XxMfS9z9sO5zSaCAibqi6kiQc90WrultCUhworFCQOvyzHb66oWe/
 fqzM8J4k
 A2duFExf1PQwxJFcfegB78kLUJK1iYA7mNHxRLKCksOiLWkNZiUvnFrefjuBTsJhZ7zPlBhl2C7SiJ27wKvOa2VAS4Qg3t4rQu1YxRkoyJDKy+Ld26p+icoEqb3St2dMx3oT2RvpisyDQVAUPiwYjPOwhYgJZn2qi8P1IF8rQLf3uj0p6ZWHfmvdicYU0dxjQyUEm7kq0M7ZSQcmmX6E1Mpncd2HZK8P3IYX40UXl+NLgFdWHlfioL7TsigNr2bZrnbkLRx4DHk+ZRZjWTYuGUpd2+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 510ec6375178d..3ea9c81b756c8 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -572,6 +572,27 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

