Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F9CC5DF97
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8B86B008C; Sun, 23 Aug 2026 23:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279E96B0095; Sun, 23 Aug 2026 23:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168A86B009B; Sun, 23 Aug 2026 23:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E45506B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:35:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66FB01403CB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:35:45 +0000 (UTC)
X-FDA: 85134748650.13.67E124B
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5EEA100007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:35:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b2HGDRiM;
	spf=pass (imf14.hostedemail.com: domain of 3DryLagcKCBEDwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3DryLagcKCBEDwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787542543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xxIn6wRkBnBvygNlVhjjksdALrlKyZQyyugm0lI7tMA=;
	b=aU0TJbJN7RmTGr91vQHTBViZ6GWyK+9GxKR5G6BVFA1P8TP8XMAOpboGXcjjWNAsWMxCch
	jHZMYMTuu7iSwuX71CG5UNg62ud8SemEcvZwhTUnP7zg8qH/5eOck0EKUNKOvJl0hz+mQt
	9kw5sTPk2mpGn/gP6Qfjangn2jxx6m8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b2HGDRiM;
	spf=pass (imf14.hostedemail.com: domain of 3DryLagcKCBEDwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3DryLagcKCBEDwv2z6vx55x2v.t532z4BE-331Crt1.58x@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787542543;
	b=MV9sW/bbEFyae6/3cXJJjYGqMdcW7F2gQVGkm/Zpfhw3kwYSEp0OeNK7aHMJEslzXydtwH
	POg8B2w6v3FUWg2nSTR69mOK3ZwzSp9Uie2WTh2kUFFE/xYV+sbBhDA42Dz7I4wvSW6Y9c
	1j20Cudh7wo3XPOopcuVw0/0lo3p660=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d6c166bafcso4511165ad.2
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 20:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787542543; x=1788147343; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xxIn6wRkBnBvygNlVhjjksdALrlKyZQyyugm0lI7tMA=;
        b=b2HGDRiMJUTGVQTVeYKvtMamCmoP4MMBZJrNoYPCU9UE57in6YBpUHDFINee2Wdgld
         foJ3VkYv3CskzoHSyhuIhJwnTApX/C62t+hgekS02dZtU6IWR+JKqrffZ0Z3SXLO6jTA
         sfiygrCfT66gvYxRlSau+I4Vrg/n/ZO+Y3qzoNIJpfR0pDMuLYhFTweqM9ZtO3GZLrCU
         FpYSORcW7fX8qNBqsYoeBZB8GMmtigKXBOLm4fmx0tGnSpJ4WQA2BP112NYCjfkTtTHb
         w1Mu+LY5U9KS5HfINfSAhFZqBu64BTSoZ4l4ARDx501jv+g35diO4dHB6aBcg48secrN
         s7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787542543; x=1788147343;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xxIn6wRkBnBvygNlVhjjksdALrlKyZQyyugm0lI7tMA=;
        b=WvIXGGiPTTrDRsnTmsEz7BNA46RVUBl9S7hK4A+3zfBrE04mhppZCIQC+ehxK/o+Pj
         sLSWZQBPcQkx7z8Qbg/Y+J+0hIp3606ra+xp4aNNNbmASYxMdDqE+W/qJu3XSKvvGglf
         0zZTbsfjZpmgskEmyxDlJ6QpgGXVSKYnAaVcGFLLF5zpOWwLlhS2bRdwoFC6m/ZPf0PW
         GPkuwGRiljOtVzcUj+OLJ1x/qzGr3niK0tu7laMR+mZomKFKE+YMwrMc5L8v9YXNsVyY
         nqFaTlGxLrEGhGolH+SDp573/gxNlJ56mJVN0rR0ODAU4Gw7ANQr3ErMLCnBN0FKb4E5
         N51g==
X-Gm-Message-State: AFuF++nzPkBAM5va7zUmzMZmLdEw3NHKRz6gVjYpntqq1rVadxmI3l62
	ApK8O1EhaqmkvatFGGorsJSEvBR3Ev+CRqrKxh49Hh867YxA68i1qh1sn/7cBCsDi6vPvN0oN89
	cVEsRfP73FQ==
X-Received: from pldc11.prod.google.com ([2002:a17:902:d98b:b0:2ca:c3ac:bb34])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f686:b0:2d0:cc92:f7af
 with SMTP id d9443c01a7336-2d670c96265mr233860275ad.9.1787542542407; Sun, 23
 Aug 2026 20:35:42 -0700 (PDT)
Date: Mon, 24 Aug 2026 03:33:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824033533.2147900-1-wfelipe@google.com>
Subject: [PATCH v2 0/2] selftests/cgroup: fixes for test_zswap on single core VM
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5EEA100007
X-Stat-Signature: it1rwf9yguy9366tu4zhmxk14nta8o9p
X-Rspam-User: 
X-HE-Tag: 1787542543-54877
X-HE-Meta: U2FsdGVkX1/KBnlIlhh8UVtSSzqv/io01pkoK8oz3NkECQJWb5Wbo+T5WJfMi21Ga5z8acY8V9rPdqQDKXRhugj/OUoF9yyGSPm/u9cZ6jANXFSGT1jvmlV5GNDb8aLPAvTjD0VIifO0bzDmpSaC1IVCV42JdVHKT5CEULlG6oVngOHAPG3VjmrZLCLSk/vrvVQjIJ8Cfa+LUUMz23pirP48/hXFj6hdZ+Gltc/kskxQmn2UrqaTxKQm9JDaNDzTMpwqK+H/qpZ0Ba+Tv6yKPyXnKdGioaeZMLjTvIRlBatzxmjgZRAwcdhVC+Mk4JgriQULdWhBaq7jkXi476xDUSXP3K+11JIaWdS8hMv5U9wJuK1jyE5kh6W2l6Iv/YApIQcD7kFcci6w8lkbJhc3qPiB14h1mQpnLF+2yhwpGaE40MEPO1sUt+am0NRLMwZZrrfdYMpGM0IV22rM4sZS5R7dybSwD6SOTy3hL14yHHJDt7Q5VmpxKw//VOlZaeCcN4uJFHY+5PwsKVZv8UOEfFC+hAZS9A4k694laZRA4KMHzjjq5piomSXF3qAYMCquNSi0q9c0tA3ae5hG/N/MNfb3VnvDCQ3RjY90yl4V6rBdLlKOYIiTGkh2abMspi1wIiY4m3ve+inL6Hw5UEmvS3vrdqa+J79ReynjNsN+gbVCpZsQjUVS0zUKzuH3EN/+Svv2IkIMRUC7qwRj+Fnx7Wc+wwnPzKbjq3VMpZ1JtEWCBN8Cidd1bj1TDJQ4Cl0wG1xEUbXCm8CGPoBuPKG3kyyvCaHEZX9gR0Bo8+8xGVWDnjZ++mEPiUwpXMfzeykxYdhW4C1S2dYcTgqK1FtNEhF0YnQEB/iZZmd9iJLxzPoVMv9UoFfny9GFGekeOzWCKPmcbj4c5ixvhI19t7JPYE2N32S0ll0n2qWTqjNU+0rvV9SgUg7+lSful5eZMK4eMQbyGhrxlw2YtkA3/KA
 wUXd4gxw
 ipvYYZaP8D290DPloCI4SMxh+aEx5ww6RwFwnFic5/FTTbdcCDn6baamKfYuvL/mBtcenmESma/TUQbyHwlZSR/1d9Yi6DSZVP0Vwez97Kjmc8aFhMaoBOWlIA46bQWSziidP681fltr84MJvgIpjZESv0XSFg3qkj/9jgamENpdsxTvVmaX0KOJ2sRvolrGML/ncmFiGpxdZRtrj36NoE8+RjnvNrsy0IgUBf2NSViiOPHbosxItpI7gNb5ec6a2BZfmEyfZMVLDpY3aQTiUzA8pbBAKXKRNXEteAGX7t7+B6YO0Yt+lzHPX7RU6um/2Vbbhn6y+1TrKcAGMf4l5iaCZRvpkHvUqZmwdBI7CucL6pQWgIljshI4HgkaJ/uV6FUwa+cS85kJ/uQB64l/vV1fRGxM5SlJCyDN+3Xb66zsbTmMKrR/nXYWX7VpWdFU1Q/23tReIounoBBwAAA3sgak0OkWX8XCPIBRvjljKu6GDqXIS/2BIOcuyka46KdURabpfLyV7YZdVdY1QS0aGzDGECBuOrW/uU4T3Q59BTzmx6R3JctkALk/3U+QcBEDG24Hyi0WA5XIrSt2OXKQOgjhE6UvScqROkSQEDMjjQhJQH/Xx2pyL+GcxIBevyvEf7Nu779ngpxAhubwsP+MahyERkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY. We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.

v1 -> v2:
- Patch 1: Replace EBUSY retry loop with cg_read_strcmp_wait() waiting for
  cgroup.events "populated 0" (Michal Koutn=C3=BD).
- Patch 1: Clarify task lifecycle in commit description (Yosry Ahmed).
- Patch 2: Remove abs() and declare delta/zswapped as signed longs with a
  signed threshold comparison (Michal Koutn=C3=BD).
- Patch 2: Add Fixes tag (Michal Koutn=C3=BD).

v1: https://lore.kernel.org/all/20260804042053.56940-1-wfelipe@google.com/

Wilson Felipe Pereira (2):
  selftests/cgroup: test_zswap: wait for cgroup to unpopulate in
    test_zswap_writeback
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 tools/testing/selftests/cgroup/test_zswap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--=20
2.55.0.766.g2966f0265a-goog


