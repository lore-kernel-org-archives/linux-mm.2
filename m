Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D4A606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 07:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WNZ+fL7a
Received: by kanga.kvack.org (Postfix)
	id A687E6B05C1; Fri, 13 Nov 2026 02:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19C76B05FA; Fri, 13 Nov 2026 02:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955CA6B0604; Fri, 13 Nov 2026 02:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 736066B05C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:27:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4C36801D5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:27:30 +0000 (UTC)
X-FDA: 85429265460.20.74D38F3
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25423A0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:27:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WNZ+fL7a;
	spf=pass (imf25.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794554849;
	b=he8zKMmxZVIlYinqXVO0Rb65nCvvUGXbXI3J1RSzoQzC+n22/JqU1QQIJ0ALG5H3v91Fld
	ifrAfbwdx66lFOW4bzpABFE16flS/PmQAemyl3iYm11xPYaiKgF8QOi/RhmgZGbcKFbv0F
	NJgsc2dM0zqZE0frhdUV30aFo/PiH6w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WNZ+fL7a;
	spf=pass (imf25.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794554849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hbenJVq9I5uwkDNPOZUGRpBZdFROzQQvvi7cvGqBcJI=;
	b=0YrmPPKHqSPGE7k1bvPia39Pg0JNqh7Vh9M5gsOi2Ahalo3C1+pxRsdJtf03+fO5B9nTYv
	5aVmYMMbsT7tncjQ/neN8Ku0jLfyY7sNEabMJGHOdvxc99NaVtaXWw221D7bir0GjFRDOf
	We04bg9Jb0x9n84+LFIp6AnW5bTMeLs=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso650243eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794554848; x=1795159648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hbenJVq9I5uwkDNPOZUGRpBZdFROzQQvvi7cvGqBcJI=;
        b=WNZ+fL7aoBsa4E9/xf4H8TRO/aKPULYpNC1dICqCTEqim0grnCxfACoKH2cP28PJ6/
         9ruhJaUwVMcI/hrWZEYJeQBe8s1UL67vPPrwZsnr5/y3/T0kVsUrJTYHnphC69yEVmol
         3+0XWqoacxtcOzKoRG2VVQ2GrfpNYC7Fyz16oQmwW7ogwGeLOhRcilXAY6NW+2NevakV
         MJ9qhpgyyONJNpuq9blVjMWIRqAjz1IJraLnLgxx1qpQXKcY30Gm8MNBaa9c77r2DxYl
         T9aEmxmn18dTX0yOV+spnoEVnJ3MMLKORzSMIZereo96F9AOYqWyfhjPJ4xFaDLZWMZ9
         6wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794554848; x=1795159648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hbenJVq9I5uwkDNPOZUGRpBZdFROzQQvvi7cvGqBcJI=;
        b=iaLMDKbOfhtd9fwiNO0YUbXA7bL+3gbKa6+vp21LGzhGIY6TrN4mYbYdGx7dLA/yCt
         JgzObHa734NYu6KHDMXANeIvRx2quABpQA3/Nn59sBsWRJOV++LL87Vx7zqj1GaXTtrE
         AQ85WTAKlzmUJlOQ4bq7nRgVr6VoF3hykah0CtDcGzo5X1idHTv+mNMrXchzjtq311hc
         IiBtMY8wHnBZQxmEc186MMgJzy3U2qEr1gb/ltQAwHyqJ1E4UrwWk1nHdGN0QU0DLxCz
         uJE4xpKFbjPG/gRmbdoBA1By3YPRX4UQoU85qrUoMNsw2A+52169a6DL2paJ1RnSSiUu
         4e1Q==
X-Gm-Message-State: APuU4Z9GVELCszqFwFfeOIrhNQEYQJGZ485UYVAIR3AAsRjd+cXHxqKq
	TZ7Ro11XV+j8bPedcAsn3DZh7cs1uBLUKEZ8Y5fY1XdhcrkKHW5wnoJR
X-Gm-Gg: AYBFou3wYgeGNO59OK4je3nEj7h8z1updjyuMhxbp4ex5ZzIdiFDVsgklk+glfrwspH
	FP2e5G7orRmaGYhX3ZeLqjl3myK1f1qMEyW/YX5ZaaNXYWEd1mV3Q+K/b8QJB6f7u6FJHRz3rd5
	nv+7jCCCasNLWGKzorjVEyWeinltp5hCp9XUAxSMgkAlG4WnzuRIpfShCXSztYamJAQrvkzAp6w
	PsTw3patYUEobmeroGI7HDus02QqQOwq41LMjVqMap65DK9K1VK/KKs6+5rKk4Yj+fWte4bMhkN
	bVWxScYDijpwFPUnkZYNUkKrGMQOLi6Nk/CUbfVRMk8SVSzjx5+aMGf87aOC54yd4s4Uztootjq
	t7Qsvh7sakQMab2QC+pj47VRwyZeT+jan6nmXqILsi84JB+EX2gj2UhueRZuZol/mdSmnGHHDZL
	0mYY5HRYW3zajRGDRYh8MKGOV5tG9EdQzo5l/itcFuzYXCRrzbM07g2k5rci3ySFz/H3rnototn
	voV3VIce4SQ00x5Bb+FFfDLL+H4i798CO9kz8ZR3Sm8Vwd4uwxGuzp2hsX172pz+XqX6KbFghvA
	IXrb/bGrnTtji3l7+b9w3G+778s/Wv7HWZYtvOEApSoBtDXb4ZNYkNts5pyz8sXe5mQH3DaFT1k
	7vRM/2jM9PpQI
X-Received: by 2002:a05:7300:828e:b0:375:dbeb:b363 with SMTP id 5a478bee46e88-37966a575camr1303312eec.28.1794554847648;
        Thu, 12 Nov 2026 23:27:27 -0800 (PST)
Received: from LAPTOP-KD1TH5BD.tail375eb4.ts.net ([47.11.114.36])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795378c2fesm4906698eec.1.2026.11.12.23.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 23:27:27 -0800 (PST)
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
To: akpm@linux-foundation.org,
	willy@infradead.org,
	jack@suse.cz
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	p.raghav@samsung.com
Subject: [PATCH] mm/readahead: don't skip the fallback after aligning index down
Date: Fri, 13 Nov 2026 07:27:11 +0000
Message-ID: <20261113072711.235264-1-gopalmalaviya53@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 59i7pg8pg8c79ki8g69p6a5h4f3rfqat
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 25423A0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794554848-250309
X-HE-Meta: U2FsdGVkX19GKvs8rNj+ICy873+Hwl0exhbg5VaatUIL3JaG2IFa+dvdypzWqXqMl8r9AMSJstx6GzNTrW9MjnHNcvuThQ+JcV96QN3WZu+Z8MJw+tzx2iOEdtH/stsGHEJKBgoDYPLZQpiXFrzAcGChP6RMwMOjPgfcRJ5jTS4r1vLZXCtALISXuYPB2Mx7771+nG5auhyWZv/o8sTrJDDHMFo5E1GUM41VriTBA2HTnSz6BrB/49BGaH2+CFc/BKPE5EtD+clADcXoI1XsIAlTNScKyiv7siu8i5ijv54fJixPpZAGrocm414syWfAzJis6S+C0WDjuZRsQjPiBNTurhKwrXa46ha5BvtnKkZVl/ulXFvvPNEoD7qAqjhAAFOAPGb/O4u9IpjRGphrZ7a39eC/xC6OKdQ6AOhKal5703WZQzz22ehkp08j/LDjLD+foG+jw0s9q2htq5B+mNreXZPAc5ZlN4nWvsp5z2jmvFiBIdaw56WPwfZfOZDWjGdAERtKR15ILFAWgvpI42idb2ARFeUKK+pEZDpDqm61/PhXhKRGnYSvFJ6Jb4GSOys9Ee7Ekdxfj1Qfce5p78Pj4VHZH3vcaCilWjNUJW1+bWiB3AF7BbdgBuGbeHBZ/g27qaJdryhFPj00raKY96CLAVFwEN2z+tJnrgqYYxZCFhPSoDYgOZKvRi8I/LtdI3rh+A3vrxizZlnDGRAnOytaWQmDjSVQWIFR3b7hNwDbbfaeN7H5nN5Y1kNo6yfofeoFagicF2Jd+vBO+AC7uXXXBZwGUst4rQ3jH1RLMRfN9RCQdy8m0vvx1ikTGjH6PWHs2pptm0W16aO0zVu4eStYnb6d4o5+dSvk6TGgIkBXAowOlpWF6igJFmc1nffnfTrAovptIKT8kB+CnUKQLP+5i+KdPOC7Ctm57M8hmbMKKonZJYFAOoYqTGFbGI/ab4VQxV/J9VMYbs8bltv
 QCauex1J
 79jL2JquEvaJT4l76cjG37/6EY/S5Hue+w0/tGWxWbjhMW+3A7Qh6ujeLlLyGKoJs2wNQw46v1o7Utq+PvvIhluQv3bEFWrV7LnNz7AAYCjw8ifZ3X4ECB4u8rDWomMZbpoV2OQfkqV8hv4JKd0h7bNNAtrXY5FyNeUm9De5D/HOz9uEyZpwl1AzcIYDJ5P8KjB0g+l5O8RxXhlFPa86jcCuPZecw6Vv6tqHKt7rSi3Uygw2iOWWPHPDNDQQr8EsXk1Y2GzkE45CkCnFiHATmQ1QqZkeSTU39oZl+9jjj7bMbp810vmw1AtKMqXiKSYwXuIMZkUrmPDOxdRzpNrG8rhPwrh3JlFjx8cUxRTQVOjxh289vW1GC2lr3ReU6U5UZqPPccNLqMrY9RRPiLXaOoUwV3CctvjHQ16HD7bJMGajbdjpiH7Neiusn88o6FVvz21l2Uxf7KUl9stLnlN4qAQp0ejkcwF35CmxprhMMlQ4m1WA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_cache_ra_order() rounds the start of the readahead window down to
the minimum folio size of the mapping, so on a file system with blocks
larger than the page size, index can end up below start. If adding the
first folio then fails, for example with -EEXIST because that folio is
already cached, the loop stops with index still below start, and the
check before the fallback

	if (ra->size > index - start)

wraps around, so do_page_cache_ra() is not called and nothing of the
window is read.

For example, with read_ahead_kb 128 and 16 KiB blocks, the mmap
read-around window for a fault on page 1042 starts at page 1026, index
becomes 1024, and if pages 1024-1027 are cached, pages 1028-1057 are
not read ahead.

Compare with the end of the window instead. Where index is not below
start, this is the same check and the same number of pages as before.

Tested in a KVM guest (x86_64, 2 vCPUs, 3 GiB) on mm-hotfixes-unstable,
with XFS with 16 KiB blocks and with ext4 on virtio-blk, read_ahead_kb
128. A test caches page 1026 of a file with pread() on a
POSIX_FADV_RANDOM descriptor, then faults page 1042 through a mapping,
and counts the cached pages of the window [1026, 1058) with mincore():

                                       before   after
  XFS, 16 KiB blocks                      6       32
  XFS, 16 KiB blocks, nothing cached     32       32
  ext4                                   32       32

Tracing shows the fallback now running after the -EEXIST, as
page_cache_ra_unbounded with index=1024 and nr_to_read=34.

Touching 1% of the pages of a cold 20 GiB file on XFS with 16 KiB
blocks, at random, at a stride of 2053 pages, or as random runs of 2
or 4 adjacent pages, reads the same amount before and after, within
5% over two runs each, at read_ahead_kb 128 and 8192.

Not tested: other block sizes, other file systems with large blocks,
and other architectures (built for i386 only).

The problem was pointed out by the Sashiko AI review of an unrelated
patch [1]. An AI assistant (Claude) helped with the analysis and the
test, and drafted this changelog. I reviewed, implemented, built and
tested the change.

[1] https://sashiko.dev/#/bug/linux-da6e8836-f808-4b39-9f04-de52995a0162

Fixes: d5ea5e5e50df ("readahead: properly shorten readahead when falling back to do_page_cache_ra()")
Signed-off-by: Gopal Malaviya <gopalmalaviya53@gmail.com>
---
 mm/readahead.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 6e55632902..afcde18316 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -552,10 +552,12 @@ void page_cache_ra_order(struct readahead_control *ractl,
 fallback:
 	/*
 	 * ->readahead() may have updated readahead window size so we have to
-	 * check there's still something to read.
+	 * check there's still something to read. Compare with the end of the
+	 * window, as index may have been rounded down below start to the
+	 * minimum folio size.
 	 */
-	if (ra->size > index - start)
-		do_page_cache_ra(ractl, ra->size - (index - start),
+	if (index < start + ra->size)
+		do_page_cache_ra(ractl, start + ra->size - index,
 				 ra->async_size);
 }
 

base-commit: 76f5384740b2fd9ee5d71da9d49b271d37c5a51b
-- 
2.43.0


