Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C16FED3DD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6C06B008A; Fri, 24 Apr 2026 11:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE246B00A0; Fri, 24 Apr 2026 11:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC296B00A5; Fri, 24 Apr 2026 11:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9AF6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:06:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 358671201E0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:17 +0000 (UTC)
X-FDA: 84693775194.27.2AA3BFD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 609731C000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MC8h2EZw;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf20.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043175; a=rsa-sha256;
	cv=none;
	b=VyLrUzAOacUVl0Clo5PKck3dfZmqM/1rnouaWYaB8cAv0N4vmng96Jz1EY6GbI/6TeNXM8
	nUakQs6ZWBcLBwuNsVVZzML0SeKa822J9ETOak4kj1gK7gliOqYaHfX1riOni55fxycioQ
	H1vdEA+S6uVrk3nsirbHRN5GAB6ow3E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MC8h2EZw;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf20.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RVe1mdDmSznkKrpLp6NnE1VBsKdidBovgIvPTce2MA8=;
	b=LrnNtyYEzn5ofqdpP3PJ3Bif+4e3ZyDSUuS1sd5buSLk6RsNfSUe/7LiCv1MjET01GU8rD
	5bTTD++dQ7r1H6pEdYAW0yeRTq4En9IAntqY5CtUIb1pH7UvDSd57zaQL9ndmd//SV1MX4
	dQjGrgBIlohL0lVGsmLARIcM+bb+9Jw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=RVe1mdDmSznkKrpLp6NnE1VBsKdidBovgIvPTce2MA8=; b=MC8h2EZw2UDsA9+IKIMMfh7cf5
	kLcUJSQWpritUAjOHjinxzecwdt8ShiBLtdL9JTJkmqfBcTuVaxUt8zbrHZjTyzdOoPx94Z+NQHq7
	2mUDPcGVjRIYYPADAld4VCf9WbRKS+kHCCr9RKvzfRxqYjhdHdgfNLqsyhQctbM9wNqnmMVvD/ygr
	0RuGCBykTtDa1X7slNTIvC7d1rNSJIceKXjV7ov476hShy4gDp2GP4MISqsWU4A9obLlRI+aOZyDJ
	33YfxZ6xXeVKMJWx7t0wMgjcSWz1suq8799QpiC/rdoAT4HNppApdtghCW/auZuc1yoTnT27ZlEMI
	KJmlDGFw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGI6U-003FtE-1Z;
	Fri, 24 Apr 2026 15:06:03 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/2] mm/kmemleak: dedupe verbose scan output
Date: Fri, 24 Apr 2026 08:03:35 -0700
Message-Id: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEeG62kC/13NQQqDMBCF4auEWZuSpJqCq96jSInJRKfWKIlKi
 3j3oqWbLh/8fG+FhJEwQclWiLhQoiFAyVTGwLYmNMjJQclACaVFrgTveuyfaLq7QzePvEYscu+
 NLvACGYMxoqfXAd6q705z/UA77cpetJSmIb6Px0Xu3Q+X//giueC6wLO02jov7NVhTSachthAt
 W3bBy8tbde/AAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3121; i=leitao@debian.org;
 h=from:subject:message-id; bh=53CbKSqQXj57Nqf9Vcb9wXKvGhXHDdPMsOKk02YRS2o=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp64bVaZSe5UJCGm+HP/1jieIEO7rM0Vt0wfUDY
 /arBRWi1SGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaeuG1QAKCRA1o5Of/Hh3
 bU0PEACC3Ijp/9yGwEZQmeurx5nfsV/JtKwQQEpzFC3nDcy/Zv9T5DT4VWifpWj7Grtp/O6S6tE
 FqBgyB6oS4v0MKkQfD7xc0M7A/FFv+ijq9AriWfafgVPWswwb8e7wc+mFa+ppmXnbguxv1HruYb
 VfyXBCnezMMGtL9Z8MboW/ToaImfAtMCgHJTtSFGyzxGlbU3VNs1ngv7LqPqIeh+7hDxCJOHU0r
 03xcbTN0vAFH00ucQ76wo54eCvUYP+MhDTfX2pzwgH103klaIv0DKUPXWQx+bzHSyFdXFLmCt6R
 mkS4pN7C8Y6Wa8eM81XAgNRIrC0w97OCriKyFXUI4VDxbKiFmejKCgsxxeEwk0txo4tErJA3nKC
 8a2Qrz+ZEHIwZGNKwaFwhEgOBiBxlp0vPp/BUXgA1D4MvTvkDdvCqXBd5b8U5E+zedyORJcMq2P
 EGIRk5CUJ7ljAGh/31D5+hmJg5v1PYyUjruXZwe/IW45oM361V8pkRb75Q+hIs7LTErP3zLTuUL
 usxb+zn56+oSm9GmmmYNCZ/MUcKroYuckBM+XrRgWo2qtt3oWAiMwfks732cmbIxpMN+0k10vae
 U9qGEdroo5Sz1eyhc2DKN36hazgvJzhpAyqZTFAxJp8pCuJI8dPmReyztJT4+BvlkjWGBROhIKT
 jtJ63D0AudqxoAg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 609731C000E
X-Rspamd-Server: rspam12
X-Stat-Signature: n6p1jc5ab8g7atypmsjqnaxozcz1hh31
X-Rspam-User: 
X-HE-Tag: 1777043175-337536
X-HE-Meta: U2FsdGVkX19FsUifl+ZL+F5CHhoi9cJpWuCw8iyC8JJHpllY/an8+eLuLo3hYOTj6JF9YaIYMb5rFw02lVmh6HmyWh39kzg5b4b7/ecpGmUZZ6ZID3dE1DD/hsnOL+UcwEaYczIsLfnISeZvGKbXP70lmNVBpp43gjLRf1YSpgIS21Kw9Tr2M8aXF660tI1jIPLGCeHrZYHLExQLojTENBaZIMf5JK8fKSEZi29SzNr5D8UVFcv3qKBmBVp9cGmHJXRtcNXKkTXIYBC4W4GKIch9RaImVwhvezLjvxzXRDdd+ncCPLiDYtSxEAwxiHLy+Ru+jDa+o8WdeljteyxcmiDdEythOsMSFNtI7nndWUXrI61X5Q1hfHxLm8tXQcqq11bHlNAyHSYgctVR4yEkZPdrdn9HxHMbmmBFtHxRkkvFVfEzJ41NVe7Q3XI6XEUiLiYFQtYXN+XVw7NWL+6cNgSR6zSVhJo9Y9KbL4rbxFieXjGWonPn7w0/+jzvbCmWuYcVyX1WdZuuFOl4DucOOnUPcYd7Elr6zzI+6ULZRojB/Yd2hXxS7r2GHGor1nrijpybygkLkCgLpgeZWHQPpAPbhlZpMYYdpuZfYsCXzLvEcCPx16TJc63FeqcwYVs9rZoj96+LrFwB4LexI2FzhU2ud9dl0jYfxnG/oX7au6ouyEA81NKo1jBur2tP/uKCuOvButa/Jxkaara7NCtA+lNZ57PHgLLkwG/pX3OTwJ6MKyFo/3bYb20dBSTGO0vY//gMCEi+fQ4XjoVQK12PBAdVXIt6ZBODe3X+Lx8UIVam2PZ3Ei9VvRZt4rLsES016A7R4tylFhlgGpF/EXyPic4hCzNSX56k9IcnAiexyzsO7X3yMN8McsiZXeb8agLGj/nINvQ6U7uY1Nl6PuKlwuufjRxHdXCiTcVmPlxp/bEq61d0DdBRVu0t1YH+B+0jT/CCnLQGaJo3iTljbna
 Ug0Bngoe
 /8kH1DtthGGnq4mp+2eV2iC5PWl672sUHFYVygVZ9HUwOa2N/ayQnigc+SWN4TX6wP70yF9DZzk0FRAE5c0G+ovbAvH1AETnKdDGiaMk2k872VVUecGY9C8Yy/8+9sE7L5v5SqijiBbG7Kw9fsL1x4OPAqOPrYTbDyzRD7HQsLbey1loJ7aiSMHVsXWXPZYxBYn6Hp1nAsbDHuLTUP22DdsmhcEEUq71sQh/Pw/RN92VffOjjnpaK3flWJBizZdpec9ONvcEENoCrEn3TA055Eq1MIr659lgxaq/jPl9t4jQRwtofmLMl9jdeUM/XM/KSLiGeiV9SKJnRVPNV/8NRoIPmTw==
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
Changes in v2:
- Drop struct kmemleak_dedup_entry and its kmalloc. (Catalin)
- Handle trace_handle == 0 instead of dropping it.
- Skip hex dump for coalesced entries (dup_count > 1) — bytes would differ
  across objects sharing a trace anyway, and it removes the only
  object->pointer read left in the deferred path.
- Counter narrowed from unsigned long count to unsigned int dup_count.
- Link to v1: https://patch.msgid.link/20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org

---
Breno Leitao (2):
      mm/kmemleak: dedupe verbose scan output by allocation backtrace
      selftests/mm: add kmemleak verbose dedup test

 mm/kmemleak.c                                     | 148 ++++++++++++++++++++--
 tools/testing/selftests/mm/Makefile               |   1 +
 tools/testing/selftests/mm/ksft_kmemleak_dedup.sh |  86 +++++++++++++
 3 files changed, 227 insertions(+), 8 deletions(-)
---
base-commit: 4c406406070d57dbefeaad149181785330c23f92
change-id: 20260420-kmemleak_dedup-bee54ffa65e7

Best regards,
--  
Breno Leitao <leitao@debian.org>


