Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1950E1094481
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EDE6B0137; Sat, 21 Mar 2026 16:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FD36B0138; Sat, 21 Mar 2026 16:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245AC6B013A; Sat, 21 Mar 2026 16:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13ED46B0137
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:47:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87CD013B0F8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:47:28 +0000 (UTC)
X-FDA: 84571255776.13.67BDCD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id ECD0D120010
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:47:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fKyPy7Jt;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774126047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JDV4K9q8jm4UBs02F6iUosXTJ6FSmn8GtN4VTdkPpI=;
	b=pAtHQUqnB1PYtHhJsA9nfuI/Xo3QKe4ef1GTguhbjZacz9aXsaIoKIsmlWH3VmN33GbYlB
	YPcM/B/SCQLjHG0UVcqOOQHJ8jDYsRG4DAhIbyac7esE7i/zpi6ER6VeOOSVJULNNP2Zrf
	asZeNXNNI6VZPZSirjSxvqCoGxXhWn4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fKyPy7Jt;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774126047; a=rsa-sha256;
	cv=none;
	b=JAd257NF/wh+Z+T3wsNplqgfs781RjyBRvSCxrz5RW2LdAKF89P8EJ8nswcHQ0kNpySEPc
	SitzYBofxq2YZ0Iyg/PqHEhlkna3kLsQIQ2EG9jWhQaHK08noEjyom8HGRXdNlzHzzdd5N
	0NYDZq0UXqF03Z93p48UlQlMbphW5x0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55F29600AE;
	Sat, 21 Mar 2026 20:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F87C19421;
	Sat, 21 Mar 2026 20:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774126046;
	bh=RBNX+2Z4AQoEE8CopXAPjDqi8wnLBhXwutOSqIaoAjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKyPy7JtllSfPx3H6nNERtnh0R2fNDmdVVqCLCAHHRf72hw3dTlCtowh+zpEhaA0o
	 j1A9weHFbXBpEbUrJf7rPSJnBKIj+I4PkrgYm1uKZrBfmoZdZr2JZ+RCU7ZNtk8HC4
	 Xnj0kr3LyklOqw6oA2nZ78XG7TawP3JsL2wbtGeBdgS7e6mHcYI3ExkhXo6zbENnre
	 ZFtLtw+mcHCpwXZOro4zTNYG3dTBcplqaxABXmkhUTirzRSUquPYWrcoDwZXIhW6Hw
	 7Z6lEp+w9raGrebjRIpC2rCh04GfoxXnjllkMipUyj7Kh33MxmG7s/1ylrY4YlxRKH
	 kQZMA9lWs5SRQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko) [PATCH 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sat, 21 Mar 2026 13:47:17 -0700
Message-ID: <20260321204717.98765-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321201250.95873-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECD0D120010
X-Stat-Signature: eupsnxuzpssq539ay6ppdfm8p4s4187c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774126046-644866
X-HE-Meta: U2FsdGVkX1/yi7xiy2GQVjnJzTG0+Qw88heuBp10W10llNrMW+WNoQGndluavxoMahOemVVq1xjeTKi98T6YQ+kxyFOlpLA0ndYu8dOd9xeGqtgRs3eDBEwIOv+QXmwrtnM/Ty5Ojxj3oj4m3Hurfh1IAwdFOIhE4WN0yCkwkgUXDKECTeSRWWJ4LPmV1JQsdEidXLWcM164kGbshMgIujk7j7L0+TN1m91nWuAVJauHGd+2FxJaOa7KZtJJJGG6myYZC52KmoiJfsR8Ssjso035csfOmg2mZYnlUxoPJtp5cgLQGIyFm5CRgPEGLvNP796Vjwwm0Jn0XPQ232jBrqQTorosEj6cuviWZzWcAZ/Pbz5+e//NrKbzC7QiqEGJg8ZtZhBR0EiufzlgxpAAo0J6R6LBVFg9Wiu6oHOtKRgm0KxtlUl+rQILHr0PwiL8VI3w/NXhIwoYzoxmLwJU9w8Nt/aISHOHBulZ7XsNyGTD1yM3X66Z5L5g6KHjm/E/Xp97ZevdSerkUCSkbBKXwgOxyfQlcZ9bRGg4mbQ8I+VTasfZlkxQEgs98xa6ffksNVa+XWNUjusWZk7nlMjvT5Oskyes3TFAKVgIAXb3mngvSOdomDa04AIRCPjz62Y99cSEKJei/OvwrLscxLbER6rbmD39GqixYdJ8s8LbGmX75CftgJZPsupDhRVq4K/95BgtVZ8ecMe3mh1KAUtAL/rJw7w+uUtJtX+NxslMQyB5dTPk0IVFiLqC7CYlccsFsMn0rpjQijcC1L6pM4noONkSe1S+VKmIuiZ80r9yFnURMYOtUmOgYhvFujKKKIKX5Im2hqS3zNJG70hKf1HLIDeEf4w3RjX4TYl1yyvbF2jc/EKM7N4UhOWOvtHnt7OMcLYnpYuabL0nZpaNuCHAyjwBGPGECHn9uXdZt0mKvqGd7TXxTAWWwXr7Q7EmZ6sFeMP2eNyDUXe6np3fs0F
 /yiR5Gsu
 Z1Um8Nkzpa34mr/dNqSay5Oqa9VpG7OeabtmflFIO3X6OlMFciFG2WbWjDmUYhNSHEMj48WVxVKUfgKdma+RHYR0YzzILmXbB1pzXs1TgffmWrnRBI+C+rZIFeZBsWgNh/wSTBSyWZCVJN57xkhB9XeerEk66IXAFyyBzBhe7h8hE4hPvutzqWm0UHyKC0/uTA8GfCH8ZDBejGTvRxMVjaLN+Z8fpGYwjkiXyBgdzA4w6XTtu2kMxCrBjYB6B/rPvKy+TL7vs000a7D7yMqyQ3U7tCiaHc9DHCh/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: need to add below attaching fixup.  Unless Andrew pick it together with
this, I will post v2 tomorrow.

On Sat, 21 Mar 2026 13:12:49 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260321181343.93971-11-sj@kernel.org
> # start of sashiko.dev inline review
> commit 019bf04e4448bbce4f6d092792a1b959f718f39a
> Author: SeongJae Park <sj@kernel.org>
> 
> selftets/damon/sysfs.py: pause DAMON before dumping status
> 
> This isn't a bug, but there is a typo (selftets) in the subject line.

Good eye!  Unless Andrew fixes this up, I will post v2 with the fix tomorrow.

> 
> This commit updates the DAMON sysfs selftest to pause DAMON execution
> during state dumping. This prevents potential races caused by internal
> DAMON changes, such as the addition or removal of regions, while the
> dump is ongoing.
> 
> > diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> > --- a/tools/testing/selftests/damon/sysfs.py
> > +++ b/tools/testing/selftests/damon/sysfs.py
> > @@ -193,18 +193,53 @@ def assert_ctx_committed(ctx, dump):
> >      assert_true(dump['pause'] == ctx.pause, 'pause', dump)
> >  
> >  def assert_ctxs_committed(kdamonds):
> > +    ctxs_paused_for_dump = []
> > +    # pause for safe state dumping
> > +    for kd in kdamonds.kdamonds:
> > +        for ctx in kd.contexts:
> > +            if ctx.pause is False:
> > +                ctx.pause = True
> > +                ctxs_paused_for_dump.append(ctx)
> > +        if len(ctxs_paused_for_dump) > 0:
> > +            err = kd.commit()
> 
> Since ctxs_paused_for_dump is initialized outside the outer loop, if the
> first kdamond appends a context to this list, won't len(ctxs_paused_for_dump)
> > 0 evaluate to true for all subsequent kdamonds?
> 
> This seems like it would trigger kd.commit() on every subsequent kdamond
> even if none of its contexts were actually modified.

Good eye.  There is no multiple kdamonds use case here, but why not make the
code more complete?  I will fix this, like below.

'''
@@ -201,13 +201,16 @@ def assert_ctx_committed(ctx, dump):

 def assert_ctxs_committed(kdamonds):
     ctxs_paused_for_dump = []
+    kdamonds_paused_for_dump = []
     # pause for safe state dumping
     for kd in kdamonds.kdamonds:
         for ctx in kd.contexts:
             if ctx.pause is False:
                 ctx.pause = True
                 ctxs_paused_for_dump.append(ctx)
-        if len(ctxs_paused_for_dump) > 0:
+                if not kd in kdamonds_paused_for_dump:
+                    kdamonds_paused_for_dump.append(kd)
+        if kd in kdamonds_paused_for_dump:
             err = kd.commit()
             if err is not None:
                 print('pause fail (%s)' % err)
'''

Note that this is not a complete fix.  Similar change will be needed to be made
to later part of this file, too.


> 
> [ ... ]
> 
> > +    # resume contexts paused for safe state dumping
> > +    for kd in kdamonds.kdamonds:
> > +        for ctx in ctxs_paused_for_dump:
> > +            ctx.pause = False
> > +        if len(ctxs_paused_for_dump) > 0:
> > +            err = kd.commit()
> 
> Does this inner loop repeatedly modify contexts across all kdamonds on
> every outer iteration?
> 
> Because ctxs_paused_for_dump is shared across all kdamonds, this appears
> to redundantly modify and commit contexts for every kdamond instance.
> Could ctxs_paused_for_dump be scoped per-kdamond instead to avoid this?

Good eye!  I will fix this like below.

'''
@@ -221,15 +224,14 @@ def assert_ctxs_committed(kdamonds):
         exit(1)

     # resume contexts paused for safe state dumping
-    for kd in kdamonds.kdamonds:
-        for ctx in ctxs_paused_for_dump:
-            ctx.pause = False
-        if len(ctxs_paused_for_dump) > 0:
-            err = kd.commit()
-            if err is not None:
-                print('resume fail (%s)' % err)
-                kdamonds.stop()
-                exit(1)
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = False
+    if kd in kdamonds_paused_for_dump:
+        err = kd.commit()
+        if err is not None:
+            print('resume fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)

     # restore for comparison
     for ctx in ctxs_paused_for_dump:
'''

> 
> [ ... ]
> 
> > +    # restore for comparison
> > +    for ctx in ctxs_paused_for_dump:
> > +        ctx.pause = True
> 
> Since the context was forced to pause before the status dump, and the
> python object is forced to pause right here before the comparison,
> doesn't this mean the test only ever asserts that True == True?
> 
> It appears this entirely skips verifying whether the originally requested
> unpaused state was successfully committed to the kernel before the dump
> procedure began. Any kernel bug where the pause parameter is stuck as
> True might silently pass this test now.
> 
> Should the original state be verified by reading the specific sysfs file
> before overriding it?

I agree there is the room to improve.  But, there is no good way to test the
feature for making the test safe, at the moment.  We have kunit test for the
pause commit feature, though.  So, I'd not add change for this to this patch.

> 
> [ ... ]
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260321181343.93971-11-sj@kernel.org

So, below attaching fixup is needed for this patch.  Unless Andrew pick it
together with this patch, I will post v2 tomorrow.


Thanks,
SJ

=== >8 ===
From 90acf3dacea715790622c0dd6cf97c6ed97d1105 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sat, 21 Mar 2026 13:43:50 -0700
Subject: [PATCH] selftests/damon/sysfs.py: fixup: avoid unnecessary commit()
 and resume setup

As Sashiko suggested and I agreed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 7a4cd915d5bc9..5f00e97f019f4 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -194,13 +194,16 @@ def assert_ctx_committed(ctx, dump):
 
 def assert_ctxs_committed(kdamonds):
     ctxs_paused_for_dump = []
+    kdamonds_paused_for_dump = []
     # pause for safe state dumping
     for kd in kdamonds.kdamonds:
         for ctx in kd.contexts:
             if ctx.pause is False:
                 ctx.pause = True
                 ctxs_paused_for_dump.append(ctx)
-        if len(ctxs_paused_for_dump) > 0:
+                if not kd in kdamonds_paused_for_dump:
+                    kdamonds_paused_for_dump.append(kd)
+        if kd in kdamonds_paused_for_dump:
             err = kd.commit()
             if err is not None:
                 print('pause fail (%s)' % err)
@@ -214,15 +217,14 @@ def assert_ctxs_committed(kdamonds):
         exit(1)
 
     # resume contexts paused for safe state dumping
-    for kd in kdamonds.kdamonds:
-        for ctx in ctxs_paused_for_dump:
-            ctx.pause = False
-        if len(ctxs_paused_for_dump) > 0:
-            err = kd.commit()
-            if err is not None:
-                print('resume fail (%s)' % err)
-                kdamonds.stop()
-                exit(1)
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = False
+    if kd in kdamonds_paused_for_dump:
+        err = kd.commit()
+        if err is not None:
+            print('resume fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)
 
     # restore for comparison
     for ctx in ctxs_paused_for_dump:
-- 
2.47.3


