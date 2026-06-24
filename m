Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C70CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1766B009B; Wed, 24 Jun 2026 10:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A206B009E; Wed, 24 Jun 2026 10:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317376B009D; Wed, 24 Jun 2026 10:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03EE16B0099
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CF47A02B6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:27 +0000 (UTC)
X-FDA: 84915016494.17.9BB613A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D33940005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjzXCQu+;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310825;
	b=riImSAsMydQRvsHAdmAti2YBVlR4xKkQREeJ1tjekdpQc3hJ8TYT/SYxVi4l++AxDyv+uC
	sZ5nTPaUJIsMxguAQ5MU2PSW+2mL7nyCGTiA1oTiMi6boP7LBNoYkv4N4nvf0PDxnmo/Wa
	NfPYK28FLi/O1mcntVDvsg9BUnaTpyU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARqAM43ohvafn9UnTqgU4RPIXqjonzaqaC6qJIpJbfo=;
	b=nEjw8A5pxbDnZVgtOfVucy0XdnPiTt4uf2sHize4WrM8r9sagqOcCCY4ZACTMpV25DeUKO
	N7uWhmcQkT/1Ux7C8rf+jyV4iybFO1GtLldhqK83atbAvuyAcbfRQV6675dME6vUXx1Xf4
	fARXkePiX7+DxExLz+gcLuOS17Tm+h4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjzXCQu+;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E60FB41A05;
	Wed, 24 Jun 2026 14:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B91F000E9;
	Wed, 24 Jun 2026 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310824;
	bh=ARqAM43ohvafn9UnTqgU4RPIXqjonzaqaC6qJIpJbfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjzXCQu++yR1i3ggwiu2WUOZOwR0zBCvwDCxPbAa9CbdTd7CB9Sd/83XmklRrdxC3
	 7LzNXSoVWDZ+hcviXzTXVQXDcVpLIoukQJ2g7zHwfc2TRxlbcZuFaLwoIw9S2fBby/
	 JD8qv4UHoVfDCSBmFfzOq9jP+s8J60Cw25r2rIvsWJvWPtGEFYx3WVx7vTTDUnTIo5
	 d2r1o0y27pac5Lrw0IxlZxfso649hocAiUxlhl2O3jsYj15kaa1fyLHK7aPBz5rBEW
	 cPCytv5OGS4gfs3KmsR71kdIDbBR+BHST0wf8XKbu+KjmXyyUc2QzOc7aIlHRWGxPA
	 E0+dvG3FZMTug==
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
Subject: [RFC PATCH 02/11] Docs/ABI/damon: document probe files
Date: Wed, 24 Jun 2026 07:19:58 -0700
Message-ID: <20260624142008.87180-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D33940005
X-Rspam-User: 
X-Stat-Signature: gpwwe1ysg51jdnsgekrmxg1q83bskhww
X-HE-Tag: 1782310825-33834
X-HE-Meta: U2FsdGVkX19pwGRiGSLgVf6/Qx09uGpWBs/aVFC3abQylKHFnvacy2jiCpWdeNPeJAqyhOoYo0dcX2ySTUrXPWT5hxSpsLyvDHqtwC/ysY0lDah/8oE5ZIFj0IgJJmOo1eyG45O8cvHy/cTYpGMyIImKtouW173w2DwApLCrUnpkcjUysXDPMHnbJQSO7e+cvCjUg2JplcK0oOKDG0shRNgyPQ6g1Qs19zYAJ/cii6tI+jxFV1pK6LgVt+g+k48sIufQ7mtCTRzuitQq8ESDG1gJbJMUtG/MpO7b2qW5Y2UqETXf0kBKmDwwIdHNJh3RBQYSSIGkb7FIoN/nmCub4FpgG6MxrFUg0If63Lf4lvIrqee7O5vZLwgPt5YFhwErmg1YbkUH6XvZ/65S3FN+aDn7C9NT3gfY9hQareEao9lVzFyI03PRteUK5ePQMT0VrlIYCSITVl5kr906N5gvbXK9V0NjS2i1Gdzrpa4CfTuQ0zL78FCANF2XeSnebcBAmmjOamIRC7gaLrJMkwRK2jI/8/1Gp5c0oAfEFdDsXmZYPGnbrObrhSMkJghkIid6sG9fwJWxv6hlbmfgPAYgO+WxqwifwnRYdO0b8vgJLKdc3U/s0KZEO9Qa8HNg/VvqypwaLsyPTBV1SqSnlH+H7ZkLCNKDPgCmHM4/7vBgK9QAuF6mvImqBanQn1r1Wd+t8b51tkD9JdOa16vAw0MKtR3QQZ6QfzeC+kxbolTW4G1EeZTRt+3dhyeuDV8MZ4KQoGgVORczAGcVCvtsdxkJduyUTASyRZAWvipYsI71InMy/jkRRRd3uQyi2GWkKJfJ6/UAgcj2qMXyaJJ9HM4A9ocuktQIIKZJ5p69g4vTLx55dIcjTEGUmj591u+vph7hMszbArcIEnI35ddPfcZ9DIYEB9RcquaLx6Ct3qW6DNcNBRvqMBvaHPnaggfx7TVYRekmpVLeYbjBiumIVdP
 Of2u7uxA
 HXBWaHUgoiWdprUx+IyoEsOhW1IBnCkrypsFqU1+1Vd7EB8rGkQLvCNqListmH+/92DpFtpVRX/uCYtknUOFLO2WaZn9SnxEpMGbGdFsaw9dkWbLcXS0PDZ9RYE7v+nW6/7wPJ39pq0HqpWYi204z9gEpZ6xIDKDHguiVZXlqk6V+yTpv05DfBYkIMIP0vvG/pkiIYId0pzc4WVGiyesBOOOXBp+9SBEHibaXEQxrlbP2Cb2PThAa9VfvHdCX4XYq3++3QBuNR+9hNcs=
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

