Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE1DCD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8062D6B00AE; Sat, 16 May 2026 14:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791D06B00AF; Sat, 16 May 2026 14:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657E26B00B0; Sat, 16 May 2026 14:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40BE46B00AE
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 073BBC17DB
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:38 +0000 (UTC)
X-FDA: 84774141396.26.B416818
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AD2740007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUF2xE1J;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIIYQXCTscUbmSmYOxuaTHGWR54Aft7g7qNjrgGO3IU=;
	b=IangoZwb83qD5OBgSuI1Ry+uh/C9ctkXa8G8EjfT4R0/p+s4a1Zk+MvYZ8rVyDm9n0PCQ6
	BkUbC5Fp7HuEzZJFSXbbgR3ji/RDTg1PACmrMQr9/o3prxiGxKRxlcT0NDrP4gaNJTc89b
	6fFFeb8GrayAB0Mqljxvop05Zeh4SnE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUF2xE1J;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956656; a=rsa-sha256;
	cv=none;
	b=1GFgiqDYU6/O0CJkbBU2HyiWWbCg/V5SFeN8oLCWA0yWIJx8Lt4jdNKOROACJQT6589wql
	mfXMJHtKWa6ZN4VNDy7dMbkmfvy+Lb6cCgNRodt2zIRf5/9I8KsiIgCTVn7yfohIo4VIGX
	ZFPGvJC3pi3ryc22+vzcTA4Jd6xpYnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85EF944549;
	Sat, 16 May 2026 18:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D551DC19425;
	Sat, 16 May 2026 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956655;
	bh=bkzOsZ+u9cB/tv1smaMAlVTUS7NBHktW+3LSKT4hgrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUF2xE1Jg2MnEobOyg9RnlkwjukUdD4EnA9yERTUFrZ8ALkhO7gMOR+01OI5A71jP
	 CH8937r40nphJCVvEoLEQzEXfCkoew1Yow9xncb4OwdKn9LSdQdTWK/RoYeqYSMER1
	 Wco1YQh0RUzwWWApRfhR3nux8PRMIlHIB8w/8/c7hMAYt2MTBy/Sej/XpvP7JNX7ZK
	 VGVgLL4f5ddtcmAXHZzo3mmuljNSU4jLY/vtQCaUF+YW8Ie2lBzIkZMihQ95PVooYY
	 QjPDHggOMP2F1wBQnbHRpeJj9CCdnygY5brVxCgfo6pZEWay4qG0ZRLVG3nS5o9zOl
	 z8Nta5ezLLx6g==
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
Subject: [RFC PATCH v3 27/28] Docs/mm/damon/design: update for memcg damon filter
Date: Sat, 16 May 2026 11:37:08 -0700
Message-ID: <20260516183712.81393-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qqft3aqwbj7g3b7t7zadxtauw3mj54q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5AD2740007
X-Rspam-User: 
X-HE-Tag: 1778956656-508445
X-HE-Meta: U2FsdGVkX1/giLFueADqQuxM/vSBdJ9W5//riqnnENG5NgNZcP6H9l0auDgZP2O+nKiLpZWX/dT5MTk4rGAVCtj8X8GwTVrMSxCwFnzHHfED5cuZZY2MYa3DX8b6eFqo1E62B63qXzYtA2cxcpo0SDhGT2fKZUjEw8PsgGfi4tdjfV7W5iypFK3tuRZvjGJf8w1gUvXhGJQAXr3VUq6pxRXBt571hpG758x+jIdQXnr8WUyR06tq0U8qO+umxQ+YfMEMhLLpMycCMD+c+Ik/Es+I2QCs0sukx87bSOX1UbxChvWRl+1lKIu56p2+q5TacisinXB1Dd/4tSBDujmqAwOjQE3W+sdBIyh2MkDnFA+tPVEq2VnoxW9M6DmzRuYhd/T8/kbhzXwgO8dytvGAixTZkLl4ZL8WggUVw5NOKhdghBR632WaNuuc9J0VQZPBn5qeSvVWBWy3ZuHfry/H1bzgGmI2ZTeMVkq81U7m89n29XvnhiUDhmRSZSGJqVx3STMp8Jhqa0zOD04iWXJPeh+ZVOgcC5nxF9fcjL8pLKEjjOcHwl3+YVyIG0UQhSemlafMmYZ4mjAzf2e48bWg0FVR+0HpU0jdDGsD2qDutn4PFtgrkkFJtcg6XEJ5RekzXiwRCIJjh+EekpWxYky27f5MYbcuXNiLF0PUiq9vmaa9rV5jzNYUP8cRY2I7KTladnDapEedW2zmHEDF6AYf19BFNXAREW8MghD9pSJ7jZyRhX33ABLbpH9dZFjFzqHLsyVDEKbkgLRDoZ1zufdbGO+t1MX2JE6x6JQwpwXE5ghfT4X528FYfSmHtAAUTMDd7QMfE4VK7yniEzDD+TG3UO62RRfP3BzropZLpBaPlIhmPVIPB15u6DVir8jZT5cbd/rcZEkj18U3HpAMRIlqwqMB3J3cnAfG2s5c0gZmiAjIqdwCoK1OxrLD0T+sR6CmGkVQj0FLg7zqRDCR6KH
 53Je1ktp
 FeiMjPfHyFBvXXL6T3Y3aILHcuoizChb3Ka3sk/390eBhrE3oUo5VfaluqqsKhPU3ZZJh0WJLqreWJWucFCPvhFUMIrSwQoBM6Jk6EYE4yKKf737u0kh0uALZf4h+Zl63G71Be+D6OOvwPEUhbYT64p+ip1CRLe4etUNtSKzxKOV3sMfZtEkyatpYQ2FSsaoozlOWUZ7v0VBSKGU1Fwz1hV01QLG0+lGyFHJysEWRgFUrNpE=
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
index 85d668e929194..8a2d68cbcefca 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -286,8 +286,8 @@ registration is made by specifying a probe per attribute.  Each of the probe
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

