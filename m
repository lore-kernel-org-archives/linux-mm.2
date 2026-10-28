Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74562606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=scmphY3W
Received: by kanga.kvack.org (Postfix)
	id 76E616B05B5; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FE86B05B6; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635176B05B7; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3005B6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A846A0286
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:36 +0000 (UTC)
X-FDA: 85371338472.28.268A497
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8DD8180002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=scmphY3W;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K5LKyQgYKwl4SQBjA15TdSBAX9bbXAc3tVQHLRXEih8=;
	b=gvLj6/ZY4Oz4TrepxZr/vV/5dUdj1le7SVFWd+1SBhq3bwNepJHBj2/lqj/toOXHgnGUkk
	a8b2QAzCj0h5vrQOHAxz6avIkXNXc+yDZYqan7svbM41ZoQ+fYyhQ8D04k6pCsskdkKAXY
	AENfR7klp9RdsfxKMHW87qVkRIgp1mk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=scmphY3W;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175635;
	b=MlvIXSTr8/0fk+IlqoQ37aXlsQvZg30P9sRIa6XwybulWvALgCYyvUZAdQtn1enPmx27XH
	LkrO201nFvqT4RMYyPpQ7HvdpnRrrjH2bMcYCzCgIUnwtnNFsthNTK29LiFz7D/ycqyRhD
	MQTxqqc4cJF8h9zckr65OYPu/IMfbZ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175633;
	bh=K5LKyQgYKwl4SQBjA15TdSBAX9bbXAc3tVQHLRXEih8=;
	h=From:To:Cc:Subject:Date;
	b=scmphY3Wunrsmp+34WEVPizPYNuER4OuyqQN+7wcAk8b243s6Ql6ZgZzt2Q3H2Zn3
	 fwtCXvfv3lUFbjuEGdD5xIfcK8QirvUz/AoB8DzMfhdVnF9ZGl/3QyMwT3LvSHQOfV
	 tYEhcDcVdgbtrWL1qNZRxMyUJGS6xrDDGVIAFe9A=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E3225FBCE3;
	Wed, 28 Oct 2026 08:20:32 +0000 (UTC)
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-leds@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org,
	linux-hardening@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 00/10] treewide: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:39 +0000
Message-ID: <cover.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8DD8180002
X-Stat-Signature: 9guhssc9oeyjgdjwtgfqzq7uxjaa1d8m
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175634-891779
X-HE-Meta: U2FsdGVkX19DF4yLLuDyruELQIgqImYNydjeLgFBDX3P4RoUx0U01u7CwdA3z4yIZ5OaPv5deSXCy2AOVxgmwnXF5AD6ZgTH60h7KHCOsX11Y4LGg6eAouCz0ImJb3I2wjiv0YseaO4z80EU99e2uG/oUXHOGqXXkp1EujKqi8QjDxjjac9FWlQnxBP46MGZPunANIAPbzsiLOStjMzDWt5GFiwi7bxK4XvzMBVfnpInOtu4Pp15MjFB/mxDpcGHxuBYacMpJNMREeP190e1fPCo2w99AH0kxn2judVZ6aDszUHVi//7wCmb1a6cwsnPBsY9bQmF0yIdmCpHUSjhvhQQxETskaKIENPsEJYlHDCBVLY1YLfK7QKhpl8KebFk1ciar9fdkWWBbeel7vW0jEpvViTBiwHnUI98ZNAQe8+o8q7DCxeU5gPf+Ag2HOJLRzSQhrNS4MdSmoOw3e0dMvNHNAnFBJ+MsHKs6Jkh2EZWbzc2L3QcVgbyMwJ8wcHF+5q6XMgmtn364ApEzalXKVo/Km5zG2W4Od0kI3hgQXPTvaB6cS4n/1ELqt8ou36c4f+GtVbmHakgzENokoew3WtznhVrVNmj4cJsTOFQQP+BW2yucPyWquwjBZIOYdG+m/0K01jFbVV9ScyzvJt9jggXbeIseLmTigDQkwooOj4vPWZ1zkKZEC7enjxIXUdm46VvjJ+/p+9oxAQ+PAWOiLF8sc/+abpXd7yU5KD2NBoFIc7FJ2FQMEhy34NWDOHdbK6eNF8AjSRFboFh2GUKwBO0KriLdYLLR3NH/RgCS98iaHDX429mSUOdr/xaGZOKDK+FpG2ShgiT4NuC9HS+NJL/WsB8vI/lT8XUqhajS5yu2fTuvabmWKfyLRsC8HbZrg0KG+XtbFF+fiNKEJXbthexLoHaAFRA09J3Cq1gealM7jJK7JakymBOeYmXfpPKrxQf20gDI891pBsKU+M
 B4OZJxv7
 txGN2OuRmjkQeG/pt5bKzU0G/Ob0BGpOCRDrlVlvLasEtAizyjuoV/4rxPVoQBiMWOxW5Tycz9gsjDMy6Rdwyt+oECQpbiVjR2lR1MIpZG57N6HHFPr5ZXuevCxijKz2XOktLC7jZ40otv7HaNQC8R58cGhnF8eqdLi8d7tZbsNZyrLUYJYXTKr2b4APmnIxXcmT+ZDfYhM546nkFmLObFpseal8hRb88sD7+mJrsOrUeAsqc4e1K9lGDh/9IGWb6TQuN9ROcfAiXBdnhIEq9J8sBJq2Cp+IbOux1PSXapBVpg3GsGTvCQ39BIjVDJIQOko0P113yG5q8KCri25xsGF9PS+t9YSzO8EWB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the __nonnull_args() macro to wrap the raw compiler
attribute, keeping the attribute's quirks in one place rather than
open-coded at every call site.

This series replaces the remaining open-coded __attribute__((nonnull))
users with __nonnull_args() to standardize nonnull attribute usage
across the tree.

Each patch can be applied separately by the respective maintainers. The
only dependency is kernel-doc: the string and lib/list_sort patches need
patch 1 ("docs: xforms_lists: support __nonnull_args()") in the same
release, otherwise strends() and list_sort() drop out of the generated
documentation.

Latest Sparse release could not properly parse __nonnull_args() without
arguments. Fix was proposed [1] and merged, but until updated version of
Sparse will reach wide masses it might trip on __nonnull_args() without
arguments.

There are few more instances of __attribute__((nonnull)) usages left in
the tools subdirectory, they are perf related copied files and can
(should?) be updated separately after this patchset lands.

Build-tested allmodconfig with GCC 11.5.0 and clang 22.1.8.

[1]: https://lore.kernel.org/all/20261019175633.415493-19-bvanassche@acm.org/

Dmitry Ilvokhin (10):
  docs: xforms_lists: support __nonnull_args()
  string: Switch to __nonnull_args() macro
  lib/list_sort: Switch to __nonnull_args() macro
  xarray: switch to __nonnull_args() macro
  drm/i915: switch to __nonnull_args() macro
  drm/amdgpu: switch to __nonnull_args() macro
  drm/gem: Switch to __nonnull_args() macro
  leds: pwm: Switch to __nonnull_args() macro
  soc: aspeed: lpc-snoop: Switch to __nonnull_args() macro
  checkpatch: suggest nonnull attribute conversion

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    | 2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.h | 4 ++--
 drivers/gpu/drm/i915/i915_request.h        | 4 ++--
 drivers/leds/leds-pwm.c                    | 2 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c      | 4 ++--
 include/drm/drm_gem.h                      | 2 +-
 include/linux/list_sort.h                  | 4 ++--
 include/linux/string.h                     | 2 +-
 include/linux/xarray.h                     | 4 ++--
 lib/list_sort.c                            | 6 +++---
 scripts/checkpatch.pl                      | 3 +++
 tools/include/linux/compiler.h             | 4 ++++
 tools/lib/python/kdoc/xforms_lists.py      | 1 +
 13 files changed, 25 insertions(+), 17 deletions(-)


base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a
-- 
2.53.0-Meta


