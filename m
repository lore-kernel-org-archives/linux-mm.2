Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B49DCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 01:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34286B008A; Tue, 19 May 2026 21:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE2B6B008C; Tue, 19 May 2026 21:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB166B0092; Tue, 19 May 2026 21:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A180E6B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:21:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 657E4140DC6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:26 +0000 (UTC)
X-FDA: 84786045372.22.44090E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E16984000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8C90cYh;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779240084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DIDlUu8aFd2dbl3UTvG+BWXcnjPd+VsOywP93qiOuI=;
	b=ZoXuaW8GYset6xXX5H2U2TW0Fq/ro6IseIsHlHX25cQxSeByiKz2rtdikJ+cr/tJze5fXE
	XqW9lXzMZQ4kuzkpLhfPuBxBOsYIccCDL2ks1m0iDPb/NR5YgEyxNWyzuEEqnL/ErkiNXr
	oJdbdwkNyW2ubIcOk0v7kg8V1qiVV6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779240084; a=rsa-sha256;
	cv=none;
	b=ymKiLFlUvd/eAsQ5RQzw6URrePSV9OdhR+CwMwctvnKcO08YJpF0WIkF/oQ094e7DE75KX
	8hgwJi5YS1VTqIp+GrqaguLEm4td+jgx6yF360AVp2heyrB4HeA6IL6i+7PuaLMKX5vwil
	IrljK1p1MWin2hG/TrmUD77zrotMOcY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8C90cYh;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 794A260237;
	Wed, 20 May 2026 01:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0671F00894;
	Wed, 20 May 2026 01:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779240084;
	bh=8DIDlUu8aFd2dbl3UTvG+BWXcnjPd+VsOywP93qiOuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8C90cYhbtNtnQjxj3IDNo0d3iQhHzuQC2kF9hEyB4hjs/vc1cfJkyfVFm9/wa9t2
	 X9tChHOu3vN8T+EPmRMuCmVYIcEizWz0vAz8BG5LnegqOdlHQ9Vu1JVPBZP+JwOhde
	 CGxKxWUrhnAPlVmnuNRNgryETukOJCg+Ilag2eB8fyrQ2ESF119upzvXAeOzgRDkeE
	 iy0zHqMLvdwfHFGguUs4pWh9Y2gZWKzS8dbFgFl27dYzM0nBGl9iD7SCTy2ds3ziTY
	 tarG8cdr03rP+4QLD388y6sBItezOma/hL9Eq0YdqYJda1ov/wv+WQ1eK+G+ql/cGe
	 1DCeRzKfoFrnw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sakurai Shun <ssh1326@icloud.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RESEND 2/3] Docs/mm/damon/design: fix three typos
Date: Tue, 19 May 2026 18:21:00 -0700
Message-ID: <20260520012104.93602-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520012104.93602-1-sj@kernel.org>
References: <20260520012104.93602-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E16984000C
X-Stat-Signature: iwdfy4bkhfwjx3p17tp8wht9s747zfxe
X-Rspam-User: 
X-HE-Tag: 1779240084-378341
X-HE-Meta: U2FsdGVkX18n3gXsJbDgebgVjeHZJTp9CPEoB7fEKPl4DLT8J1ElMK/Vbj9urHhBEa4nJ2s1qJSr0nS5aJREaM2u3i3xBMMRzL2w8IT/jMAB/aexDhFuhYhzVzhV+UNyZc4yZzZzVF+wDv1n2AVUllj0o+6SWYaYQ6X9HrNXi6XI5hJuIXnb1geITdpLRwjsKeVCq+x10Jvca8YdNc8qZhlFtCsn/Y4Y8hj2EOZcVMaPZItahwhJuilcp+H/3jdIke+YiQGVBwKFJg3NIzaflC/LONqADXEAfuDfpgKogw1WHCG45ZyqhhpFW+nsNgLSX4zf88nNrb4ADAeiNByqYOt0TxlHRgjbbXgoPShaWvNlsE0drDjmWugjSm0P0SjIBPN0s4F/oO7hqDJRqX+xvSuDsWQT2rwJHbsEAmCcC0d2RM3A/oPUzPFD3kjVVQcbdHpLMyh8HKJF6cgUc09j1Dy8Rh80uYhdyGkNxAGVI3xf9GsJ6+OgOS5pMts1VL3+V2kVDqyCygv2jHMU/KrSvH5oeHKdrJW5bRYrK1OdP9Vww6ppPup2mKcKomuXfD5mcV2yUhDg3hscmgQ/15xdtdSvWGhFrkgwYk4K1YPbVPnPeBJp8aFZ/KeJnJkXklPpiBwLqC/KnRZoeT89ZRzWQmEoCLN2z3Q01+WuBMUf9BNb/DrAKXZDmzSN1WekL7ggoz8WUf8G9m1muF+drHdW5Yp+mttYBgDwkozkphm5oqzAnvmMlxtadh1pLzZNRIULp5Ujcfpgwho6B8RfjO/abWid5feHw326QnRqIHuwjNJ74Qj9mys5QuB83EqKZdG8go3EQGf0gZhbdzWgpD1NZNF6yeB7ZKQCvK138pPzsbr2Rp6uNdItqw/ipAqdeMd+iIW+5AnJwIbHhw2ISfiwNr3pg3Ht7gwltdtc+GNsrBYfQTh/x4qYf+EXcY04JEbG3wl8vu0gpfPHSUX5mk9
 KBfmPoyC
 Y9iDoFfRBZqoCD3jiUAJXWfeQMJ7fqZEH+zEfpBApjaQKFA0w0cI/EuL9UOn1cF6EBYgevpnas1cnqon+y7LsO1aXNh/N1xxzur8PfWgasDGN+sRhM8mk9/Q+/C17tcTW5vLCNs9syR0giU/vLAucB3fcLhs1QQRooufyl65joqmqAmCrysFAVfZNSupmDTjYVbDSNEPdJ6uHa+v20V4XzjUQSKR2HS4608ML+PN+IuNnghqlm5OgHyXRNDSiXqUUKlnD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sakurai Shun <ssh1326@icloud.com>

L140: "unsinged" -> "unsigned"
L371: "sampleing" -> "sampling"
L387: "multipled" -> "multiplied"

Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20260517073433.3015-1-ssh1326@icloud.com
- Collect Reviewed-by: and Acked-by: tags.
- Update commit subject prefix.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/20260516093552.8404-1-cheesecake2960@icloud.com
- Use real author name.

 Documentation/mm/damon/design.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a24f9f00d1837..2da7ca0d3d17a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -147,7 +147,7 @@ as Idle page tracking does.
 Address Unit
 ------------
 
-DAMON core layer uses ``unsinged long`` type for monitoring target address
+DAMON core layer uses ``unsigned long`` type for monitoring target address
 ranges.  In some cases, the address space for a given operations set could be
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
@@ -417,7 +417,7 @@ with theoretical maximum ``nr_accesses``, which can be calculated as
 ``aggregation interval / sampling interval``.
 
 The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
-and increases or decrease the ``sampleing interval`` and ``aggregation
+and increases or decrease the ``sampling interval`` and ``aggregation
 interval`` in same ratio, if the observed access ratio is lower or higher than
 the target, respectively.  The ratio of the intervals change is decided in
 proportion to the distance between current samples ratio and the target ratio.
@@ -433,7 +433,7 @@ The tuning is turned off by default, and need to be set explicitly by the user.
 As a rule of thumbs and the Parreto principle, 4% access samples ratio target
 is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
-to capture 64% (80% multipled by 80%) real access events (outcomes).
+to capture 64% (80% multiplied by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`intervals_goal
-- 
2.47.3

