Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C21FB5EB0
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA85B6B0005; Tue, 17 Mar 2026 00:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FA36B0089; Tue, 17 Mar 2026 00:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD076B008A; Tue, 17 Mar 2026 00:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B62846B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:34:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E17BB9899
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:34:39 +0000 (UTC)
X-FDA: 84554289078.28.AEBA02C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AEBC940006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:34:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=na+iKJmX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773722077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpBuDoCbW88godEFeJUa1I5ITU0g4TLF8a1GE09wwCk=;
	b=vytmOmtyNO7v15DodhMs2Szh5mwKk/eEuNF2Ug/BXMYb4WeaUArSgUuNRv4pAb5yOSvyLE
	AWx3Lij8b0pZ0VtDznpUoPHL1ySoTJdiJw8DqNN8JaX9HXCsTQ0WuGn8dYZ2Lclcz/at4V
	gdgXA0Ote7jxqJtzQaUx+BPKuFYxaeE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773722077; a=rsa-sha256;
	cv=none;
	b=U/gxICFKdALETpUjtCsuaEWQeNWTPTneJbz1Nz5augQlTmUkPL3uEE3osXYzdqsGBLG2WR
	UqjRLGTFQb1Qq3D0L/q530k6ZdeduRh4wYsmEI1mmf6HNfFqTiLOcaZltbRpQJcqNm29ZJ
	te4rO0/ZS6jcmChP61mzdGqE0/ucc3Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=na+iKJmX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0FFF60018
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9E5C4CEF7;
	Tue, 17 Mar 2026 04:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773722076;
	bh=0/0VFLYKi+mk4PVpGHBEzM2TEEJ2Vb1grQB/KFxONgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=na+iKJmXbh0gkpBBkASt2VVz4NPNOAYTNe5xFQuv+bfr57NqS2qN+EWjUgYG8bKJd
	 D+86JTxRGDLvR19RtV6VyfEXf7bhrUXfywiyOkSy+E+acOEkk32T4r2x0AbXJDmOs/
	 rffpgkrUnASX6V2RDvFBhs/EVrD1a4a6P7RdL51Z/fOq3q/IE6FbtnQ+qF8/urXAs8
	 9nZ65ha6IFkbY8Q7seCJn7rNud/NKIvnKcHU62ht2KBGqm9M3PlTnFWcJcuFyvzgh2
	 2DJI0fpg8vj3dZNCnY/0eMVn5Kk9mnNoL7eaEYnui4ET/sSGpkIgRPlJGpYS3mLxGj
	 FJ8JotwxdKV0g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Mon, 16 Mar 2026 21:34:28 -0700
Message-ID: <20260317043429.1057-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-11-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ycajsea1xq91qowmyks5f5tco3nhu4h
X-Rspam-User: 
X-Rspamd-Queue-Id: AEBC940006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773722077-461727
X-HE-Meta: U2FsdGVkX1/IfOSoFEty5aT1XAJKcvG6zfUCbo6/4AXXXVVVhON+NaTlF6ho74KBnrOws087ejOJoKlpz0sFW4Tk0ra+fQyr/DsQlUtgL4bjtBbqTs0r05E1ysksClUCBmnsDeLJZ1TBRp8cpxQxTXp+TCy4AdBRSGvpTU0G1lAfYyFdh4ZNsaTQOvHsRFXZG94HyXtGTkgnnwPUVW3XW69v2oXmgn04hSStH9AGqgMp3E2HJh89hRkuGcry5p3cxvmk//s8TYE+i8Ci2zcPaDddoxSHkPaBdNoJng+8X+JYE+izyXXKWlinPd8+XDSaflvTN9suO4AkW/qUynM9eZl63g9xmPrcLW2YkyHJ6iy8Qv3DEVLhtYbBo2uDTStfV2DuliOxqiqiCwl4EWU0c3Nc7EVpJvLvbX7v+XIhXefph4jbyK81uNBfnUe8FJzL8IVRdLT/rJcKbaPatxzxv/W7yTL6feRY5pfYvdQAnFV9XNCyWfLp6tm1FN3g8O3M2Ha8dSG0KQIW9GBFqi3HeFJMLL1ouSzenl003Qhq9l6gnk087uplmnXZrgDNiKLJcX/fubgQ71YtqiCx9oxhO34kW3QjsAvu44ohOXvYNOgqOsvmre0ACXlaggGDJHgc0Gd6UwYbehNUKlC2ZzTyYV2gq7PMeoCE3vsWEz9G7srStbKpMrTxrLCnZspFQ4l0ZAOrcPLZHN0YzJGZqMqbTh7qAWEgjOcJuHHWbpl4Y8PeMZhk9uFy0AvW4RkooZjwVWkfi4aa52pQIHYN0Cx6K4QxDhP/7ckP/p5KDZDqBfeWh9YDS+SeeJhjVY/G3/HZtTd4QhjxHGzU0whwA1aGD8wTEYxY8Z57FGJg2DOXH9RBeGYt1DnqYOabLt9Ab/vPymH/7jMI3s2eZU7qoGJ0sBXmm8j8piDkThKdMpcniVqm/uuwvWiyiDNOX5OEiGXRLhrD0gIogPUh1fBDjWH
 yGZA1CSi
 hCTktyGHBdJnRz31H1w4+Y0IXWnizT/uhLOxzG10EcBd0z2NrRYB2k9PJ5+7R8a8836nr3ydUGONSugSHR6PEpcFqi1141Dm34VgBn/63rFO09wCzFuQhjR+aeQZXkwHzn6zOVnD9bOzHF60dkatd1DTG3jMtrTEQtEE3f28yU91cc8+OY0eFdGW5rB/dwx0f64deFUe5NQ1mtCEu6OZd3RzYVlYHfE+zmy6rhh0sB1e4yHWPgl2/J4azvOxY6dzyja7I0/piUkpPeYKc/qd8qWpGioXdRAvk+X5ViGyiAkswCHJQb+OaN/n5OO3EvGv9XbndkJgGPPJo/601PV33SilT6ViEQhScroQl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 14:00:09 -0700 SeongJae Park <sj@kernel.org> wrote:

> The sysfs.py test commits DAMON parameters, dump the internal DAMON
> state, and show if the parameters are committed as expected using the
> dumped state.  While the dumping is ongoing, DAMON is alive.  It can
> make internal changes including addition and removal of regions.  It can
> therefore make a race that can result in false test results.  Pause
> DAMON execution during the state dumping to avoid such races.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  tools/testing/selftests/damon/sysfs.py | 27 ++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index e6d34ba05893f..a1a29f1a7c27b 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -193,18 +193,44 @@ def assert_ctx_committed(ctx, dump):
>      assert_true(dump['pause'] == ctx.pause, 'pause', dump)
>  
>  def assert_ctxs_committed(kdamonds):
> +    paused_for_dump = False
> +    if kdamonds.kdamonds[0].contexts[0].pause is False:
> +        kdamonds.kdamonds[0].contexts[0].pause = True

Quoting sashiko.dev comments [1] with ': ' prefix below.

: Does this code only pause the first context? The validation loop below
: iterates over all contexts in the kdamond, so if there are multiple
: contexts, will the others remain unpaused and vulnerable to the race
: condition during the state dump?

There is no real caller of this function that uses multiple contexts.  So there
is no real problem.  That said, I think this code will be better to take care
of such case that might happen in the future.

I will therefore add below change to the next version of this patch.

'''
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -196,15 +196,17 @@ def assert_ctx_committed(ctx, dump):
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)

 def assert_ctxs_committed(kdamonds):
-    paused_for_dump = False
-    if kdamonds.kdamonds[0].contexts[0].pause is False:
-        kdamonds.kdamonds[0].contexts[0].pause = True
-        err = kdamonds.kdamonds[0].commit()
-        if err is not None:
-            print('pause fail (%s)' % err)
-            kdamonds.stop()
-            exit(1)
-        paused_for_dump = True
+    ctxs_paused_for_dump = []
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx.pause is False:
+                ctx.pause = True
+                err = kd.commit()
+                if err is not None:
+                    print('pause fail (%s)' % err)
+                    kdamonds.stop()
+                    exit(1)
+                ctxs_paused_for_dump.append(ctx)

     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
@@ -212,17 +214,17 @@ def assert_ctxs_committed(kdamonds):
         kdamonds.stop()
         exit(1)

-    if paused_for_dump:
-        # resume
-        kdamonds.kdamonds[0].contexts[0].pause = False
-        err = kdamonds.kdamonds[0].commit()
-        if err is not None:
-            print('resume fail (%s)' % err)
-            kdamonds.stop()
-            exit(1)
-
-        # restore for comparison
-        kdamonds.kdamonds[0].contexts[0].pause = True
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx in ctxs_paused_for_dump:
+                ctx.pause = False
+                err = kd.commit()
+                if err is not None:
+                    print('resume fail (%s)' % err)
+                    kdamonds.stop()
+                    exit(1)
+                # restore for comparison
+                ctx.pause = True

     ctxs = kdamonds.kdamonds[0].contexts
     dump = status['contexts']
@@ -230,9 +232,11 @@ def assert_ctxs_committed(kdamonds):
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])

-    if paused_for_dump:
-        # restore for the caller
-        kdamonds.kdamonds[0].contexts[0].pause = False
+    # restore for the caller
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx in ctxs_paused_for_dump:
+                ctx.pause = False

 def main():
     global kdamonds
'''

> +        err = kdamonds.kdamonds[0].commit()

: Does calling commit() here inadvertently mask test failures by forcing the
: entire Python object state to the kernel right before reading the status?
: 
: For example, if a test marks a target obsolete, commits it, and deletes
: the target from the Python list to verify if the kernel autonomously
: removed it, this commit() would explicitly push the target's deletion to
: the kernel, potentially bypassing the test's purpose.

No.  Callers that could have such problem should call this function after
pausing the context on their own.  That's what the target obsolete test case is
doing.

[1] https://sashiko.dev/#/patchset/20260315210012.94846-11-sj@kernel.org


Thanks,
SJ

[...]

