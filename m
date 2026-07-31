Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE54DC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 10:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D90B6B0093; Fri, 31 Jul 2026 06:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813F96B0095; Fri, 31 Jul 2026 06:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757606B0096; Fri, 31 Jul 2026 06:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4549F6B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:13:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48A5814039C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:55 +0000 (UTC)
X-FDA: 85048660830.26.A064958
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 918AD140008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="v/AfJXjO";
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785492833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubcjTD4WMXtsiq8p2FJU6LDktp9obYXwMtyJ483ghMU=;
	b=eakGlYozI0fbJTFUgwRMJnx14C+CkoDGNQrV8SOY8EhtLujweWgJmxfuHFYX06HTMIrVvA
	9xerhYOGJdV4roR/kjtuvDJY/Jyt+QZq2U9sB/7Y7qD+5WfO9Fdl0YON3Qpa8AMeD1RYgg
	RaQj/eKs3szvzWhImEoDDFa3T2BjEeM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="v/AfJXjO";
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785492833;
	b=RsbixZDgbkXnWrt2ktC7G4YTdJqKgdL1xRUiAFZaZ90+Kf8nTpELEAF8IJCNgGoM3QWgz5
	6hCzh4FcZ8M29r0aXGERNFebb2t7Okp9KScq6STHtx8Qu6fvr+dDu+ZvduCOTE4pXyZjOD
	bkmuKATbJgVFkmvbmvo+SY6D5gEUyg0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ubcjTD4WMXtsiq8p2FJU6LDktp9obYXwMtyJ483ghMU=; b=v/AfJXjOnFdaw8rUFIUcYMWkI4
	qQN7iICNQcgMvwpO7u92p4W+7U0OoO+jXPOymbTRLEutPeAYZkqNhghiRJmbEkVzOGL1gFhcKpgei
	+wsd+HGExLTqCGMKNZVuHivIcLKDmycv2G9cd+TVaZMSvaLhR+0vJ64XHkxIkwxgKBFFjlupn4cF/
	KGqGWjMp+DCVvyWrZKu0rWAxaMV3/tK8/SvZ5z9jH3mXuatdCfzdhB8QGadIv3AONMPX7lp+LARFp
	Yj2ong1kVQqxYNU3wAxiLPV4JoXrt2meAu21/h+ZiNrin0gRCAZuEPMEABK/X/OAHYr7i8jYmg8pD
	qlHfDU4w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpkFJ-009wBK-1J;
	Fri, 31 Jul 2026 10:13:41 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 31 Jul 2026 03:13:06 -0700
Subject: [PATCH v2 3/3] selftests/mm: kmemleak: drop stale min_unref_scans
 default from comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-kmemleak_hardened-v2-3-7b9689ac77cb@debian.org>
References: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
In-Reply-To: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, workflows@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2281; i=leitao@debian.org;
 h=from:subject:message-id; bh=Oj4udiEjmpiOjfHea+V/PwK9ca6Z32nug57dxTay9Ho=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqbHVAWQRNUMdRa9PHEBXY7Nf8tp4hOStjJKxld
 uKVu49wgSWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamx1QAAKCRA1o5Of/Hh3
 bXlrD/94O2e9I6iW9tkOQ8YBD5tmLc8N681vxPuVSgqZnf4F0a28eyrsM4SHdjXBOYfkDxqakwT
 alJi3+n+fVADlOmxOsH3DxPtRzJ9Ips5yCM+oYMqmN5CzknQpLupbeTqAa90hH2D2qGpzlomVR/
 UJReyIkTFNHj1+OeymYac0D/PQjOokkvuSb8qQPIle+jA2o/kZS58GV+0Vc/VEqX/M1h7K++s+P
 Zn/3eYAsYavPJpCw6GE+ZN/mNj28KmDWGMOg2LfULmIvqtTqjeAHnqB0Yf77nCKg4oHQjjioh8b
 zxQ+ZLujJ3CtUixw704ZM/O/qICJSHIBp12aCTgRZ/ilCWL3CEQ17jSFkGXzOSa6y0TrZgVFwSK
 YkUsAjKJlXGmrk+o/6vAKvz0c+1t/S7lfqpKJYzMRlc0UmVBLXNnNnBohVhPARVK9bHsvI5mNC1
 IXzaml6bk3bQxE/KNM3lv0G+TfZkA0iKMX+DROuDRl+9JwIO7Pwc5YAquuOA9WaAczOACiIdclx
 QGIoztu9sCIy8MeK+cA+EQJEWH4rhMVO3etUWzy9kg+jMBKTgOfnpfJrsxnZdv1GJ3cWtC+1lsX
 hF39qVjOljB08s6XxAVj0gcXIt0fFKbSbOR57nxyDlQtGQ66R4Vo7vM3CZ/n2NpAw3g5xhT8ht5
 UMv7S0LQJtBOL3w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 918AD140008
X-Stat-Signature: bmepsh47zsgg44j5k9hu9o3pdkzumqxu
X-HE-Tag: 1785492833-318841
X-HE-Meta: U2FsdGVkX1+NYHTGjYxACpTgQMwQLhNdPdc4VJv/aagwM2NJoQHEdBCReUuoFmEcsVt6NUoERTxqV+xGmuai0SiznNgUKip2AJ4slqWrkEtQbLvZLxecQ1qv9+WCiEY2JPNNVkg1L9T96tCLE93K2jE0TcX/n7MDdFq4WhxerpT3gY5Ux9ivOknUhaJPKVO+IfY+FACRIT05BNKsN94dcg22aswlhez6/Om2jm+zVBYUBqTfGIGCoztggrWOuWFwcuDux1gAYbo0TX627cmFROMvgbQnUSqebGeZjECjysQOo0jjx00uESiHPbHNZNZRnZGPv1d2nC6kXaPTpKVFbyyyppnPddTT5XDlYMu6M90B/LFoPDIqswEe+z65iDtbhTEauGZD/esJsaWHKQmjn7viupnInUAVJ0RlFMukZap1MgF/jPARAGDb4B5RF5j6mzTEprEXapd72N6ArHEqt7zCoEkx5YwpuaqYAKjALSKRnTm/2qBDC3m1A2xMsthhPKySoN60gbzetDU7x+OPRPpQ8SayVvnNmneyau4kkwqrh55GKpZPrtIWUuTCxeqaU3hRpD/dQJwRDtqbfjBna296f0vf/rVZr+/LrLTc/x0bcXnBd2mmeuZNAEgcA0p3Nw52xCXT9mRMZNmfedyE2+5PIfOGvhH79FMs41TgyCVfUbw7no60FpWjGMZ+by4YP3PvlDjw8eRYZmZ2lVDV4sYR/I3p0y7rTa/fV7TUWkVny/oeFFq0y6ZOeP8qc35QR8nucesb5uTyWFNCSK0zOFwmeBO2Lfe+AaysQb+Jb8WP/mdv9r7JQk9WPRXYJGLqIYDgcRdO1qQCey7CwIdKHkcrhUNTJ0t+0h5NliGHVm5LBV/q0n6p3Mpo0TQ3T48+hSsqFttLNJCwEL5jrfO1kEodhKwOxKWgy5Pe7TdTlCZHSpAE8DIBhiaSi7D86oPTyoayGiNuS4x+eO2ovG3
 xC7COzuI
 /4wQXAfEqd7hllYShugGQIAu08pLqILQdvMhdaT/PLFdeVmvZ9i0zF6o9BvykzguZPBt8JAl32YaIohx6rAOFNxgChQlva4EdBd1RycQa/Sc5nUVazuRMth19ndjgaCs1A/KEJ4RKWDoxB1nknrE1WqASFcFKA8qxKj0BHSCrxpdTjWFSqGfcA0Hh0e9N164k18UviGjf/PiOS+TUonAHcmUkgznhcYF4jDTLHYyXSSiZlXhvnnEc6iPe4mydaDQ6+blV5fVByOr6rkt7DVgktVKiG2Qs9ysRG3WRjKfS6xGiFYLjzhSYqu7arAn0qWIn0Hz9CuSTiF6bN8JwIhWVqU+7bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test writes min_unref_scans explicitly for every case, so its comments
describing 1 as the default are both unnecessary and, since the default is
now conditional, wrong. Refer to the threshold values directly.

No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/mm/ksft_kmemleak_confirm.sh | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh b/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
index 3a8576e835c8d..72ded5e6794c9 100755
--- a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
+++ b/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
@@ -5,7 +5,7 @@
 # (the min_unref_scans module parameter).
 #
 # kmemleak only reports an object once it has stayed unreferenced for
-# min_unref_scans consecutive scans. The default of 1 reports on the first
+# min_unref_scans consecutive scans. A threshold of 1 reports on the first
 # scan (historical behaviour); higher values filter transient false
 # positives where a live object's only reference is briefly invisible to a
 # single scan (e.g. an RCU tree update in flight while the scan runs). The
@@ -16,8 +16,7 @@
 #   - a freshly allocated object is greyed on its first scan (its checksum
 #     settles then), so nothing can be reported before that priming scan;
 #     each case below primes once first,
-#   - with the default threshold (min_unref_scans=1) one scan after priming
-#     reports the orphans,
+#   - at min_unref_scans=1 one scan after priming reports the orphans,
 #   - raising the threshold to 2 needs two scans after priming: one is not
 #     enough, the second reports,
 #   - the parameter reads back what was written.
@@ -105,9 +104,8 @@ echo 3 > "$PARAM"
 # scan. Every case below runs this priming scan before counting.
 prime() { scan; }
 
-# 1) min_unref_scans=1 (default): one scan after priming reports the
-#    orphans. This also establishes that the helper produces detectable
-#    orphans here.
+# 1) min_unref_scans=1: one scan after priming reports the orphans. This
+#    also establishes that the helper produces detectable orphans here.
 echo 1 > "$PARAM"
 gen_orphans
 prime

-- 
2.53.0-Meta


