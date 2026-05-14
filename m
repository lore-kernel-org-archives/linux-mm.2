Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6505CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1781F6B00B0; Thu, 14 May 2026 10:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108E86B00B1; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C136B00B2; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4A2D6B00B0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D6AA1609B6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:30 +0000 (UTC)
X-FDA: 84766208100.21.57B3B30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7B8918000C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K+47SBQS;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYvx1ZjdRykI9FzSdR0JUW82OieQVNXNXNQ31n/ZroE=;
	b=a3ZXgBlLT1nt+H5bCpsWrGFyAb1KUJcj4yZcQU28xKmuGJLW7HLKw8/dBAG+9NVvuTka7G
	+6ca9HWTHcYkZT5B8sv6fuCtGoPJcWTwabJvBpIBLRKaLRhUK7Q4816wuSlYOoO2mQtAmw
	pMYr7RsmTLfOWhTUMFbUAc+i/H37s50=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K+47SBQS;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767769; a=rsa-sha256;
	cv=none;
	b=TCwcsXcHzouvxF9QTVdbhAHy05vj4W1EtIdiw3aFH0KqfjWDPogd5XAxzDHK39R51NSwRw
	ReWClZzEy9WfiQPOPmMVleEcbHcBt1w3eJ26RPb38boMejbwA/vC5eRRFH9P0g5z7v/CgE
	D6zIXw/EzjZY36yqp/MeYTSRDgYdsq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A4BF40AA4;
	Thu, 14 May 2026 14:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04555C2BCC9;
	Thu, 14 May 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767768;
	bh=rQroR8oz509qjIfFzIS58y8CMFJSjy+X56KqeqKaBmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+47SBQSXDeEvO/BqDs+2vDvPP//VyoarqCKdJnL9bPX9vBUIdvKjYTjnxR15cizI
	 MEuxXs5x1dz1FR4o7Md5MFpbqp6xPIcn5da9tUAfSCDbSbt/U+91ToMYJw+8tQpO21
	 obhVOMh4Mr8dGtaYypr0tAfFjOQJDkGRTyDk4cneZJxi3N32bhf9WRiZcLVv666+Be
	 QuCmjiUIzbJlzoXBYEqSaMljieSYBEYHVrAMx8K5dtFWkaxlmUVUyThMVQ1Piln8tp
	 yizpmyg7JQKRU7mNyV5+7eivZ8f3Xe7JgX19hBxYbWA0nezPkFioVrUVgMr67xaAY+
	 FAMU6MdzWWIdA==
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
Subject: [RFC PATCH v2.1 27/28] Docs/mm/damon/design: update for memcg damon filter
Date: Thu, 14 May 2026 07:09:00 -0700
Message-ID: <20260514140904.119781-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rt44i8fcr4nybxd5x4odt14mm9sfrbtr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7B8918000C
X-Rspam-User: 
X-HE-Tag: 1778767768-4949
X-HE-Meta: U2FsdGVkX19H6JGW2MAjlDdNtZi1MWRaH7ZEkiPojRpdE/UXbnRdnUpYXrlYB6c0gSWOFgrUJzYvG10n+EdxokJTgONeOiiEJX1ICMsB5o8J0pciXj/c9TUjH0ZG62xxh/gdaBjcWrx5otSAsEERNI1lxgz5742I1hublZH+lZLPhA3lDX8RUIlrEL+ZoAueqFvMIGM62B//lXg0lXRmOarJazs1kazKnu047MYAS2uWavF33z2/+M6gKSFy40HBIOsKEH+/phB1aVOaUuUg6uyZoVZrqhFLXs20FurGPDZpVdplEiV8iZO9ybve9xbcp3ouS4SEGPO47q6vXAhcWvXQf0gUU6iAiXfTW7GPGKSbhIkob/+Pv650RCwwfhy1byflvWIjGVRmXM4eEUmQIJ6Jeg460vjylYkAINuEHMW7sTJ6unEHaCQrfI4rlhkg9yytwzMB7lZ3wpGxnMbTdNMfOGCokmkE62s7tvPoWb3maosHOsH/bpXL0CLGb3Egdp4yM+V5XCFettuYBbE1XBDrt0hPmfRjl4H7zqmmq1R+pRUVK7sO+yntrCJtquATPEfdpLb8UlP+ybUywlK7grIjoRxLE3TIoS44f9vBeKLXaAh2IX1nbMDEmP3KxwwqkaYeA9UdaTnwiWB8pGxKTL52CP+hWy+Y5nsHghEUZCVqAVNbYJnYlpwUHdkqa++7oKoo2coGyo7RpgksxhfZq/bhHFS1z4ir/s59ksCw0H42cqdWkizzdWvnKg2UoblGWuQ/k9whFQIR52FCzg/hEkuA8NF3yRiK+ZJyqlsp6/EES2mXpm1lQIHVOhN0q/8KB8p/E6szPZD8N/ihUPkePB6rLXmaethazmuO463aV6bXEueNDjVpmY6YwoSLf94Ij0O/WGlVqVkZ6ym3dvKA7RE/xraSfOY8bfbCJqM6Tv1JAnYwP0V6wHyCxKVuYEiE8W4FVQ9IcxcONYkSHWX
 WRCv5r8I
 kSEXlwNrrYbbNyDasjochPKWsZoS+IuKH/fVDQ5Takteg5ObVRvnmstFF4KDnVyCMCyeYDyAgNbRXlJvKeqpK6603vHZQ/VBXH03OZdftsWuf2MjhEX9PVIFbfwKhy3vgDopwSjXDvGXDMDHybtWeIpKzhs4TZoBd7Bo/hUjBnVh21AWj+9ByBNufyHunaVZtG66pYqAydbUtJjcDB+FShCVHzKq4gYrUpuEI0bgQ5I2Cmt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 887b45cbeb716..a24f9f00d1837 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,8 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` filter type is supported for data
-attributes monitoring.
+filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
+for data attributes monitoring.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

