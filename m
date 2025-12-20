Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43998E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6CD6B0088; Fri, 19 Dec 2025 23:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F136B0089; Fri, 19 Dec 2025 23:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CFA6B008A; Fri, 19 Dec 2025 23:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 885FF6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25DDE1A01D6
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:10 +0000 (UTC)
X-FDA: 84238529340.12.451A84D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFBEDA0009
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwAU33OF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203987; a=rsa-sha256;
	cv=none;
	b=puoG66Uz+MMGJD+MDZBPgt28+KxncWlnO5PoQJLIsZV93O3ubFT+JwFJUIutKa/RvpB6Tw
	YfthiNeWyGhjeWseuUJ3V4Jdl6NP9P5hNBNQQmzCv1AcZQKaP7jPeKNHlfWHVWPbvq6nXY
	np4oCsR8Pg8l1O0sFmYegbb+iDhtMjs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwAU33OF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wj67LJX/XEXlSZrfpiOUjDxm3w3z3jaCg452pE5m7xA=;
	b=BHWH8Adp4Igu6vYL6CRe8lifxjK/DwLaG/4tpuFg/h140MR4c/Hu/98mK/A2YgBL4vKYrT
	Q23fd0JMzCibxQnVbRybz8H4VGzjTk6/BKthVfhnY6tcLDBGj03fRO/P1NCxsyyfEj4OT4
	mnANkzcKCz5uvNg3QRLuU1fH4zlxlis=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766203983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wj67LJX/XEXlSZrfpiOUjDxm3w3z3jaCg452pE5m7xA=;
	b=cwAU33OF8lzqQdJ5ZZcFI2VxRJuRM5zjc43cBN/2hm2mUDbQJFu/4Z7MbYdkX0vrxeFZUj
	PelNzJYTzUeNfH4tByrRIV4mtSREmvkEfZhgtCRtaY19D4liYxRdFchAekbiOe6K1IaOhb
	SMqtUc6uPVeRTvok7YuS7qLe6wTcfIk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v2 0/7] mm: bpf kfuncs to access memcg data
Date: Fri, 19 Dec 2025 20:12:43 -0800
Message-ID: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFBEDA0009
X-Stat-Signature: b7dmxqqj3sih5xjftse86yqijdodctr8
X-Rspam-User: 
X-HE-Tag: 1766203986-376553
X-HE-Meta: U2FsdGVkX1/ifNlNTvbgdMRrSWPV0R3H2vto1WRZQCbO63B9SbyZdJVK8Y07L/3jBXCIOePSBIM2gn1Hjc2+63iw6wsOQW96mHpFv6zIg2Q/5r6/U8WChTPbWHUfxB/r6WbwLqDSlY85yO4FIrG4zHXE9j1WGOOogWPSkCcyHLSVGzUti9jj78xSrZpTFJsBzVJ8fYZhOyTCTO8Ze/CVTbbz/+cqhTYnhR3ayAfVpzLRXS8IXy0AEy4gybsCSI34g3TH7hXLKJI2g5u1eIHQDXy7PU+ykew+aH8Pb1KDRZkKkpUMhJT4A5+93ytIcEolzyHrtaS/nDIAVGXJcLrayEkAICss3X8Swpv9r2SdrlUKQr5qpyy0P9ReUvCiIGqiFKdJZE+DX9azpLrRt0WjPga4eVm8Luae9CC2woKs7UDFVHd6tymUsBQWUpNfekx7PHZ90oQRSfiXMgngw23r4J8cAfFk3N9RtdOydEFubPiaIMXxZmepXLHgW5R84nQlvfHrH1VYgzum2Gn2wNHsccN9VpslZ7kHdt2MwNQvLTqu6Mdr4ZL8zIAJs7iFXTUUfQqLRdSjA7cWPRbF3KkvM4X6ch8JkzW+1pyBuX3QZ4bKOKIQ1UwveUdy73f8O28J76gsTZV1iHx24DBoe6GJOBgl1oas79bF5sn8CLBkaXRbGtvco+PGGLi8E/DaFCGQaEJ+mY82ztH3nDbs6p7bj3BxfwhFTRjE1hB1Y/mwuIpHFFNn1aZFWHAq02uGMi7ZDszsq81/CDS/KgksIGqyrd617AZNlQryPRz1Tv5EeGbHmgA8+aPTc6L4nkjvk8AjgJfDnRiymuJPR/TrfG395PztBcjsvKdio6QqzFjub9rnNAp8eSxD0RJ/uOOKPdT9iQuxk44ebRdxShl8fMIjyhP7ck9kEzeiLhh6QJM3N0Re9ygOH+qAru95MVCGChByU3Ru6ndBQlPG5see4Pf
 2cYqEd9r
 FhOIc3TMkmZ3QjfS/BsYh8Ex9jhZwNTONOHEUVPqdMOoQR2F9si4fR52xZfhRH+j9lPGFO2bSfJi4ZDxW/CwxicGMHvJx1j9uIhurLO7jzg/K9Osw59Mq1zf2Jp0J3wR6/44p4k7AjNB41BbAoL7FbMyc3WUoXtl18A97/jV1s/nfVGF6XaM9dU/s747kyY628OVaMeNs8RdZZ50DZQzIkQzZ99Q16jGjzNzk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce kfuncs to simplify the access to the memcg data.
These kfuncs can be used to accelerate monitoring use cases and
for implementing custom OOM policies once BPF OOM is landed.

This patchset was separated out from the BPF OOM patchset to simplify
the logistics and accelerate the landing of the part which is useful
by itself. No functional changes since BPF OOM v2.

v2:
  - added mem_cgroup_disabled() checks (by Shakeel B.)
  - added special handling of the root memcg in bpf_mem_cgroup_usage()
  (by Shakeel B.)
  - minor fixes in the kselftest (by Shakeel B.)
  - added a MAINTAINERS entry (by Shakeel B.)

v1:
  https://lore.kernel.org/bpf/87ike29s5r.fsf@linux.dev/T/#t


JP Kobryn (2):
  mm: introduce BPF kfunc to access memory events
  bpf: selftests: selftests for memcg stat kfuncs

Roman Gushchin (5):
  mm: declare memcg_page_state_output() in memcontrol.h
  mm: introduce BPF kfuncs to deal with memcg pointers
  mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
  mm: introduce BPF kfuncs to access memcg statistics and events
  MAINTAINERS: add an entry for MM BPF extensions

 MAINTAINERS                                   |   7 +
 include/linux/memcontrol.h                    |   3 +
 mm/Makefile                                   |   3 +
 mm/bpf_memcontrol.c                           | 179 ++++++++++++++
 mm/memcontrol-v1.h                            |   1 -
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 223 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  39 +++
 8 files changed, 472 insertions(+), 1 deletion(-)
 create mode 100644 mm/bpf_memcontrol.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

-- 
2.52.0


