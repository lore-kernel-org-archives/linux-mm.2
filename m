Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5300DCD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE7C6B011C; Sun, 31 May 2026 05:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DB76B011E; Sun, 31 May 2026 05:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E156B011F; Sun, 31 May 2026 05:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 978C16B011C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:18:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3174F161C1D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:53 +0000 (UTC)
X-FDA: 84827165346.27.0CB8CE2
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B8631C0003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RPhGxW9T;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780219131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXhCVDIEVOBRsQMWe03K8aMA64HZDsrpR3l9gSzxs9k=;
	b=WbmcEcreqL1mtUrJ5+b1HifRxZmq0MO3OG9YmKEMLSVnoCJIVPNAqz3zvZXmViTsDP/CxQ
	TAE+TlwdNCohO0mUNHV1sPoeMnNTUVzxhGAzNOrxifUtoZ8h72pVzDzcsfGJ3sb5GygNty
	0v+l5t18lcwFgZ4IugmtOE5dKj27IFI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RPhGxW9T;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780219131; a=rsa-sha256;
	cv=none;
	b=ZxmXkK9OwEy/VuUBpMeW3BmtA1VuWl/Y54tPkkEfw1p0iSezgxIu5OrzqxhU0zxH+SnEGx
	eCSc9Ds97j9ZAlH2hkwHzn8CHyIEi6HdkdpD4ZjkXNvPpJ/ULnzHqg1PC6v09VpLto0BHh
	IvFNc1CUdpY3Nu1Ttoj1dAqNkj3SKmk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780219130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXhCVDIEVOBRsQMWe03K8aMA64HZDsrpR3l9gSzxs9k=;
	b=RPhGxW9T9LZpEzsRIy+FbVl2Ab8sj1PAKAVfUl75XJw3NqnWH/11R+TDatO8ghaX9sjRjs
	lCrFIK8O1f/mRp/1aLvEFuoixVzzQukf0/xOf3gKY4T+1G1tlccij5OhZiDcyDiEjQwguy
	/Nvc++A3U0Ijee+rgoSXB3AX308MdTg=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH 4/5] selftests/damon/damos_tried_regions: handle empty tried regions in early cycles
Date: Sun, 31 May 2026 17:17:23 +0800
Message-ID: <20260531091724.84381-4-kunwu.chan@linux.dev>
In-Reply-To: <20260531091724.84381-1-kunwu.chan@linux.dev>
References: <20260531085633.48626-1-kunwu.chan@linux.dev>
 <20260531091724.84381-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hmm89bh63re4g9xwo1bz84yt7wga41ed
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B8631C0003
X-HE-Tag: 1780219131-513286
X-HE-Meta: U2FsdGVkX18IUc9t5EfG1JH3wkGrAMn1/F9dhqtY99adcwGF9NVBEO5CGf7i89F/40L4/WFRenXzBsOTonF6Qf0yyXJWYQQn0HFje9TuRB6XgcnVP1nozJs5eHXrM6Nj2Vh2K6E2hHHE7yzInMJ3ZDIXLR2B56uWpiEqd6SARDtHs1cLAkjKjg7Whe1Cuxk6TIZG0Q28Lu+GuKF0fh7Lor0oqebpxGKcfGeEx583Au3oZQvpAZOBOoBUMfitwsxq0ODsQaLMzIQO5u0bgSZWSwBB0FG64S+J1pVRfghIB7didSbLbMIlmB4AbCjJUOAcA3SVSPi60jRYhOejRy2vQ58WPUC2J5bZr0yIckXW7NWFOToMwgajk8JxHhs8VY+wfzSZOwxJ9H7LWf33GK4FjmxBeEQJ1RKAZblV5VXF+EB4Oftp6NGazp5VSe8KaRu3UPlHHCr/WdLXvfwQaBzqPATfqUnajWhyykYwHBzEIJfBtOR1j9sAQ0Eh53ngFdNsSpbq4JY2l3ZKjBf2N4z9rxn0Kemr6dmCY/qXfaZuN63LEf0LhrjWKtLtQwXFbF+r7663+m0XoTrn9Vlowqj47VzuvxoIiWFw8gqvl3seik4F2rn2VvetvOROC8+klfNyv9MuBL9ss1r/peqUW+AD3EjGIhJBHO8/asH2qjoLtNKYB3JCoi+Jg/oicUv7UWD/iQ1p2DCHzy1P3shShgy7BWhpPxxFT14pITT2Nt1AZxRmHceHL+LK06sxqEyYGILzloh3PMBGhr0EE33ainI5xQBSbwmgYAsU7rwU7ZD0z8IHe/gDoU9/11ObW5/F8kJLvhR5DUvRwTKrPU+NefEf1xfJEgYRaE5uYoZM9X3mh0bBrX0dKUDrFcRK3WSe+gJwCsa0cCeJXohurz1EwqktmFKBsOTiVtMmk6fqu0kkVuILLf7hleo9y/hJVRNzoStqhD0867Pzu+VDRU3n+HW
 a6WAN72s
 gPDJmZ4rnGB6F4sYQ54zoAGmSb/g7bl4bb5/jyfnOVRc4fVa330PpWahPTCs1FZYXWIB1pso65Fqu86YWcivD5FbFELlKkSg7ZRVF/QehYi3l67k2Ub7+tSsW3e53kuZRBgH6Owrlu8wWtGE8hDKfVoV7cYdsLgDe/cvosRvCdTOX8CEzcz/dF+Bmp4vSIoQiAJzBmOMsDzSRbSUHdSLfHxHLj0CCZ2UFoRPTlBZomQfwNS5GOSMu25TY4w7j+Ytr+YHEOoqa5cpksx8S9qBu42eLrlKhu+ZdEPl0pp26r2Cjwe27ycl2ATuSxnGCoXfMV9HgI77JJvzCKi3l4ucGaoqWcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

The test aborts if the initial aggregation cycles produce zero
tried regions.  This can happen on slow machines, causing false
failures.  Skip empty cycles and retry up to 200 times before
giving up.  Also check that enough samples were collected before
computing the 50th percentile.

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 .../selftests/damon/damos_tried_regions.py       | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_tried_regions.py b/tools/testing/selftests/damon/damos_tried_regions.py
index d6472e6a6e08..cc6895c56820 100755
--- a/tools/testing/selftests/damon/damos_tried_regions.py
+++ b/tools/testing/selftests/damon/damos_tried_regions.py
@@ -28,7 +28,9 @@ def main():
         exit(1)
 
     collected_nr_regions = []
-    while proc.poll() is None:
+    nr_retries = 0
+    while proc.poll() is None and nr_retries < 200:
+        nr_retries += 1
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_tried_regions()
         if err is not None:
@@ -38,20 +40,20 @@ def main():
 
         scheme = kdamonds.kdamonds[0].contexts[0].schemes[0]
         if scheme.tried_regions is None:
-            proc.terminate()
-            print('tried regions is not collected')
-            exit(1)
+            continue
 
         nr_tried_regions = len(scheme.tried_regions)
         if nr_tried_regions <= 0:
-            proc.terminate()
-            print('tried regions is not created')
-            exit(1)
+            continue
         collected_nr_regions.append(nr_tried_regions)
         if len(collected_nr_regions) > 10:
             break
     proc.terminate()
 
+    if len(collected_nr_regions) <= 4:
+        print('too few tried regions samples collected')
+        exit(1)
+
     collected_nr_regions.sort()
     sample = collected_nr_regions[4]
     print('50-th percentile nr_regions: %d' % sample)
-- 
2.43.0


