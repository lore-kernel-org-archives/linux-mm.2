Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7044C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0AF36B010F; Mon, 29 Jun 2026 10:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB6E6B0113; Mon, 29 Jun 2026 10:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABDE6B0118; Mon, 29 Jun 2026 10:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 844506B010F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:55:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1297440178
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
X-FDA: 84933249492.06.99FD242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 783224000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ab23CYWO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744944;
	b=ng8CfqDFOid1XJqndBubU+QlA4Qvy8PlPuWQMfxdeYsJkzDC0h4zDMuq5I2q3hWMlMPYgR
	t18CGIu37DeA+qAc+iJZuTfxnOGg42sffsRrzUOgs6wUWB66vx7PirPPoN1g+cocQQJ5Yx
	z/YOhfRQCEomW0RNd7kz6VO5HfyzWOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ttGyzzeHcyljjJxDkR2hOA9v80OHBSDRc7TeCp+VQP8=;
	b=ww/54Bw6r+F9sFRVq27FMDKGI2N4s6/5Co35d/zeFmIYDO9Qat1vvp28WKzaKxwC81I32+
	NaFooReyoAiIkSh4FKTCy1BHTTuq+JsOQYV8gRQyph1J4I9iBZ/UP9G3gWGkcfuPOZY//e
	ri7t1LAyHgXU5IGsBTfPMUJeKT3/Nv0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ab23CYWO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B083A40512;
	Mon, 29 Jun 2026 14:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4208E1F00A3D;
	Mon, 29 Jun 2026 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744943;
	bh=ttGyzzeHcyljjJxDkR2hOA9v80OHBSDRc7TeCp+VQP8=;
	h=From:To:Cc:Subject:Date;
	b=Ab23CYWOV3R+jpaIPE9R0BH1pPzkKLGN9yekJMEuyHJSGLOiW95ZIKQhVlSXKcc69
	 jJa0VyN9iR4gaTg+wwjnarmCYMOsJeLQl+kSw+AD2+qpJXKCLLUx8yZnaJGEX10knk
	 1ET102mc69Sbjd8CcoicFTKmLNpVf8/SgvhlUUT20WrdfXo2BJd3c9XT/ZfIiiq5F1
	 BPIkWBIcc773ohFNpPn8yhjl8mOtQI7eorbvIgIxIaxj3D4fT4x9EYsvH49pCx1N3P
	 U55ZUewOXAfMBD/jRdoLuDAKH6mzoHygxc5Mx9/Itt9FVy98qTpKWsZoPtYu/khVmg
	 bPdasO5kJ4vhA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] mm/damon: five misc fixups
Date: Mon, 29 Jun 2026 07:55:31 -0700
Message-ID: <20260629145538.134832-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: djyob9h9iwq66ydxyok8rbehxuirz1dr
X-Rspam-User: 
X-Rspamd-Queue-Id: 783224000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782744944-57260
X-HE-Meta: U2FsdGVkX1+8TEOjUlvnfraPRbEwPxCC0eTrAQ47p8kK7aLOXr8FwefxJ314VNILnc71WYq/nYW5dsJwGuEilTNgcx+Y6YlJjLrbTLTLZs8jNy6egmta8IMkmfHeH8yjVY8zf4CIWLBjYr4MNBPZyihi5MKsLWy8+1TTnKzmXPcfxZmpX/0fQ6d9bfqaUxELL38e+AOS04zUdy0aCy0Wdd+xMNyg9pkzSp2/6LvrrXLf48MSS7xXG+BDRmc9D2QBFT8dX2Yqrrg+IkTf1Uav63IW4PFlDKzLtUMOwg+iCGcTaL8T0sFYzDb4eDJS8qbdcP2UJOtyT3MgYHf0S8qPMHEXFv72H3EE4CMAWtFJdy9qqc25pLJnnkvcgN9d05uQSRUPWYCmlind+f/ddMj89tE0ZFGXI+U0wcdCryImfxk3yvUSf/wOMN4bfgTxWZzzUVy3B5v5rk9icaMwyDPIFy/VLgmZ4XLXR7Yc+0RnUyqxAt0N+8zsSh4FvPbmxUs3NP1H4V4b+Z2Xu+4n7O90ttaPzDX3BFoOKEzFh9MA8qOz/xsjMqCjyETujKg0JqCiMXz76H1xp7eoxCJILFxoEwj63x4GA65Tlu0uoIjLN/L1lcdbT71h+O66Z3RlHJZK0FE8Md4ykRjD2haR3HeG4UTl5ZlqtPbYOfy3OsS8Vs/HsBNn0UoQM/OcxZ0a7YyYCAQaWZF8mn5m/elUnB5PjfHt8efqyRzME/NbqAJRg6QR9wIViqezopHfHF0HYTsGiOwglIVE0OYMvRITcd6Uepnqok2WyMPinWYH3TZ5QT2V5oPKbamKP7sW7fkKNb05vLXMjumIzNXdaZNYzz6vrGv/4zjxJ2HAZi/afSv4Vwds0C5fm0KRRR6Ifo5LzLSVAi7g5vJ7hf0bzEVjfzVR9KEztCMZ+YJNwPKd2SraJq2XC0jHTr7jx9/fFx8s8nz4YyN2yFZ+0VI6vZsrjbm
 F+KGQ4tC
 JHdTpKc7G9ZD0JfRRHWSqoDd9NVd2+AiqDfVgRabnyb9LANEhjNn88eTfX71P1S/6GFO3fov3WIohb0rh/5H1WjukAargBIlDA0x6oDPLUHI/2+2RLQ4Pk4rYToTzmwVKn5nQ7L/eW3ilP4lJeMEb1yTbSmY4din+oxCFuJNRkpE7BJe054a5Ti8kA1p9EP48ZT4kUTI2/BdsPdH4p7/2MJG6ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Five patches for miscellaneous DAMON fixups.  Use better fit kernel
functions, cleanup/fixup documents, and add unit tests.

Below is a note that is better to drop from the final commit message.
The five patches were initially sent and revisioned by different
individuals.  Each patch contains changelog on their commentary area.
The patches are curated into this series by SJ, for the convenience in
reposting.

Akinobu Mita (1):
  mm/damon/core: use kvmalloc for target regions array

Asier Gutierrez (1):
  samples/damon: Fix typos in Kconfig help text

Doehyun Baek (1):
  Docs/{admin-guide,mm}/damon: fix DAMON documentation details

Philippe Laferriere (1):
  mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()

Sailesh Nandanavanam (1):
  mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete
    behavior

 Documentation/admin-guide/mm/damon/usage.rst |  8 +++---
 Documentation/mm/damon/design.rst            | 12 ++++-----
 mm/damon/core.c                              |  4 +--
 mm/damon/stat.c                              |  2 +-
 mm/damon/tests/core-kunit.h                  | 28 ++++++++++++++++++++
 samples/damon/Kconfig                        |  2 +-
 6 files changed, 42 insertions(+), 14 deletions(-)


base-commit: 58a53a487b7a86995fdfba07723fb8416fccf830
-- 
2.47.3

