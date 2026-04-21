Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA05F8FA7B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D706B008C; Tue, 21 Apr 2026 09:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925256B009D; Tue, 21 Apr 2026 09:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862566B009E; Tue, 21 Apr 2026 09:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71D746B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:45:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02DEE1B9510
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:45:30 +0000 (UTC)
X-FDA: 84682685262.03.4FDD8AF
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1591B18000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:45:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MPbgQoiT
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776779129; a=rsa-sha256;
	cv=none;
	b=rGjSnN5efQ+AoVe+kap6xF+BBnoNn/yNH/hBPC8BhxwLZrF6JpVqaApcJ6ByqjkLb2Uv61
	U+cW5hcWhwwQ5js/x00Aj1QUM9GhXAwytegO5ymSezZZHMdU/W8KbljITmTn7dQp8cDn5l
	n1vhIyAzGZz0HC38Knob9Zs3smXZnXI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MPbgQoiT;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776779129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bfcxF2u+hQ4VdjQRf9kqyoNx6rQM7T3312bTI/HTZHg=;
	b=3QIcMb7uf+WnACftDcCJv1B1t86u8UoFwsLZKpA0rUgifLj9aW8r0j2kia3awg1P5eN3Gp
	qFgg/XRX3nAgbfhFAtYU+JRdc1ixARrSy9Q/1hCYUcYj4mJ3akWoJhh5new5CffzO2DZY3
	n8hU1ia5Bh3LGmMfuU5xcqA/1ArptQ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=bfcxF2u+hQ4VdjQRf9kqyoNx6rQM7T3312bTI/HTZHg=; b=MPbgQoiT+/tQc0iC0nnsMfSORr
	DgmmrgoIduPqozuq0h1YJmqHVrWcxOS86sI91DObsnYJqQ6kH6QyRUgHx7O2VzcKs8uvDJFgqrv0A
	qyWCbo1j185tdD4lcSfR3MzckeE1XyvwVWSPoZopIVbCC+PkYBKL7HR5xIhAbyYtBxFQ4gwB+D3TW
	cefLvJW10RHq5P9rAiRudOiHv0uaVE9rVY4klUhUzmJszoRvGLEsK6801Z6+924h00V4IaZhMeSOp
	1afj/CZ4oRXzEXMKJRvFJj2frTSawftLTvzkhaVM1GCD7ISj05Su8z8oJQwgnYJBlg38lRlbqXIy1
	uh+MDddw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wFBPh-000tUF-1n;
	Tue, 21 Apr 2026 13:45:17 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] mm/kmemleak: dedupe verbose scan output
Date: Tue, 21 Apr 2026 06:45:03 -0700
Message-Id: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGB/52kC/yXM0QqCMBQG4Fc5/NcO1lCDvUpETPevTqbJphGI7
 x7V5XfzbSjMygIvGzJfWvQ5wcuhEvS3MF1pNMILnHWtrZ01w8jxwTBcIuM6m45s6pRC2/CISjB
 nJn3/wtP577J2d/bLd8G+fwBvkKDAcgAAAA==
X-Change-ID: 20260420-kmemleak_dedup-bee54ffa65e7
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2566; i=leitao@debian.org;
 h=from:subject:message-id; bh=8c1FCBDluisN++wCqVaPRqhusGeGZbFLq+Rsv1qpGoM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp539pNPX8JyvWSFZg0lwaLVLDVjeBHI39/IXG2
 OHTw6ccuAOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaed/aQAKCRA1o5Of/Hh3
 bbl7D/9nUdgcr7VM74o/Dvc/6FI4Hvf37TKvzCH80sbO7zoFxootHE6USvSApY1WG1yXPq340Px
 GnFcedrx7ZZ5HsrFB0ykmap2ifZtAght8wU56ovt2Dw78gdCfLynbg/dNNHag4Zvc1e/BTlsyGY
 VWi5kY4pRbRSEEK20/6cpQREBIwokucnzQ4N0B2JpHSAFv1vBLcsNbrBYv1oGlfzMUtwSaNI8aM
 wzJJg4SoUiaynBj8OpMvcT9/ykz9mnMfZVmU+5MFVifsBJMIpOw2RVngoL65lBYMWsb6/T6h0oe
 kcah0hv93DniQW0LzLWNyCqw7Ryzzgl6VT6pphaQkO3F/jsJ3CQ8aE/FgK5BpaCL4TbTzpI2m2S
 ipm/YOIEoFQHFLTFvitM5+KFr5x7Fa21rXOpJsTYFmZIXNo3YLabEgIzhVO5jCMkbwu72orBQHo
 MheYWDGiArsLhSqgL0KN69cNEvtDp/P6Bct8pNQpbZ48TLKYmSvSxy/m4WfWWXjPNvI4wm5Ds0u
 KTTEGhKQuBsDxtWbeH+LmpCDLYA9JoVuHha1D1d4p6CtEydmjShtpvhB5e+8dyupYM0ly1QsIZs
 vnryt9NloXzzOdsYubIBuePVCM0mgiyqBN4J2RtNCKOB3cB6tMbGLf4xQAMl8TSXX3wqsy4xOqw
 6CqRIYJsVwTf5gw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 1591B18000B
X-Stat-Signature: fbuc9ikj451mszhxmjt8udde76k9h9we
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776779128-860799
X-HE-Meta: U2FsdGVkX19EEZ13Zw1KOaSueSTL3YO0mqLSkGMlXxI/M2Wlpl3kJWTZF/PKy/YFacpVTbhcgmIXIAdMUjEjAsRSQewH6A5KkqTASErJMYsXSZ+S1gVvpe6oodLxJuYmWy0tQ1slXk3vvMDSuqHUPtkGrkILnbDJut4VvaNq5Q2IcvHosXGaVc/TawhGylDQq/poRNBrj0hxHPZhG99o6HxMvqDkfJHJ42cTNUa3EDRCqy9Kh2FYVl6EQfsQFiujNe+h1zxGf9F8FjYKwNaQZyz5Noz5xqZhoo19B02RGfRCcJXhBBYZtNCAT840Qud2ewc5soWWrHjiDpR8CEIssLm2luwSdF/6XxrKKHSEtNJxoplurxU6dApq+FdIRDXVEMphUvDTVFdf6sdFdZ/4SDXAUg+G+iGLg3RrYYRYvGb+abYWs6AS7kYVO1RoNQrXA47KQU+6wqTEA/Dvb1p1tis+2Bv3Ptg9teDE2eIvZr0FB35qJgBdtkCpW3Sqi1tJnGu+MFL92kFLwsDc3IHS4wQaEZGDPogqKjch0zYQSDlJlo2JaOonHnYOgojOmMS1wSW9cjZNmJignz6z+sc7nt7FXFfJ+0rkGFGTXo7bQlmt98dBggJd/vTBolM9XsmYETeeQnxCMen/DE7d0jfMEtymg3zYN+hutF1LPs99UnLFT5BhwrO6zAfcxOP+PYyo79qoY7VgpjyvLkcwAxFUyI2fCLqVapogRA2xiYWCA4qC1bdbVDF9VJu3v3ENy21VbONViceLQo4vXNhPBG39sn2iGxWwHZvkwpDosPrXgzHcz7aSowVrXWjTFq8dMTRBwFf+Vpbk3WrVkVDnCKTwyR0h5XLD3325sscZTYBPyIaqtUoKxNr/OMFpKfLrc1rhkHHg/EJ+qnyTMXrYN9NtoALcoCXuEj26Ow5Qf7HdF86e/J6WK6KpelOJASyiPlRo+KUHFgFZbgEOROaKmWg
 etmhDg2E
 a1f3os0PnwfcVl5Zph+cp9guZW4IYkMDhGOpD2q0MK6A4/Mv8SBnO3Egw2RR9QqTDRbOE6IXAC61Kk/yQ/dc4vXwNxG24eytvrI984X7Ml1YxWY2kxFxGI/V2ABR3w9wZ/Urh4QtqUB+CrtVGKmu0DPjLVaap0f/vRzrv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I am starting to run with kmemleak in verbose enabled in some "probe
points" across the my employers fleet so that suspected leaks land in
dmesg without needing a separate read of /sys/kernel/debug/kmemleak.

The downside is that workloads which leak many objects from a single
allocation site flood the console with byte-for-byte identical
backtraces. Hundreds of duplicates per scan are common, drowning out
distinct leaks and unrelated kernel messages, while adding no signal
beyond the first occurrence.

This series collapses those duplicates inside kmemleak itself. Each
unique stackdepot trace_handle prints once per scan, followed by a
short summary line when more than one object shares it:

  kmemleak: unreferenced object 0xff110001083beb00 (size 192):
  kmemleak:   comm "modprobe", pid 974, jiffies 4294754196
  kmemleak:   ...
  kmemleak:   backtrace (crc 6f361828):
  kmemleak:     __kmalloc_cache_noprof+0x1af/0x650
  kmemleak:     ...
  kmemleak:   ... and 71 more object(s) with the same backtrace

The "N new suspected memory leaks" tally and the contents of
/sys/kernel/debug/kmemleak are unchanged - the per-object detail is
still available on demand, only the verbose (dmesg) output is collapsed.

Patch 1 is the kmemleak change.

Patch 2 adds a selftest that loads samples/kmemleak's CONFIG_SAMPLE
kmemleak-test module to generate ten leaks sharing one call site and
checks that the printed count is strictly less than the reported leak
total. Not sure if Patch 2 is useful or not, if not, it is easier to
discard.

Breno Leitao (2):
  mm/kmemleak: dedupe verbose scan output by allocation backtrace
  selftests/mm: add kmemleak verbose dedup test

mm/kmemleak.c                                 | 102 +++++++++++++++++-
 .../selftests/mm/test_kmemleak_dedup.sh       |  78 ++++++++++++++
 2 files changed, 175 insertions(+), 5 deletions(-)
 create mode 100755 tools/testing/selftests/mm/test_kmemleak_dedup.sh
-- 
2.52.0

Signed-off-by: Breno Leitao <leitao@debian.org>

---
Breno Leitao (2):
      mm/kmemleak: dedupe verbose scan output by allocation backtrace
      selftests/mm: add kmemleak verbose dedup test

 mm/kmemleak.c                                     | 113 +++++++++++++++++++++-
 tools/testing/selftests/mm/test_kmemleak_dedup.sh |  86 ++++++++++++++++
 2 files changed, 197 insertions(+), 2 deletions(-)
---
base-commit: 97e797263a5e963da3d1e66e743fd518567dfe37
change-id: 20260420-kmemleak_dedup-bee54ffa65e7

Best regards,
--  
Breno Leitao <leitao@debian.org>


