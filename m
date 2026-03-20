Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE76109879F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1E76B0102; Fri, 20 Mar 2026 11:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B6F6B0111; Fri, 20 Mar 2026 11:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A916B0114; Fri, 20 Mar 2026 11:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F936B0102
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:41:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D47CEB787D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:41:38 +0000 (UTC)
X-FDA: 84566856276.29.B242C36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 385A6140013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:41:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uweqh+aw;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774021297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxDKFSIoBc+aIe74XUNaRc/6YMtZiFBIhQeTySGi1S4=;
	b=wJ6HerDG1e4E4+EDDleeXE0uTngyNu5FvNmIMRlOqeMCJfEMf35nuzMz5P24PAOcw21XXx
	/tCo+50pHRsV407P8q/h4xsN3OUj/hV9Q9hCZur4lcros5xTNZgPRHjhpaNs5KNeSybiga
	NbDB6mDeas/ZEuRk4R5nVUC3zvc+xe4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uweqh+aw;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774021297; a=rsa-sha256;
	cv=none;
	b=Y42sQZYhECNT9xoMEZgROKzPWvh1c+KschKibtd73jgbE4F19tudfqdLneQX68PXkj5B4i
	q3g9z0oiN6gvRr8kg9PfAjGdcf2icraj3QYoyrQrGF8rW6MnQ1ULmsEVmIGROppmTF8Jiq
	g6kdVAADeKrnnVaI3ctvNq3obvdikh8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90A496014C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FA6C19425;
	Fri, 20 Mar 2026 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774021296;
	bh=81ZkqAUVnlz41ptZj/553F+xUS7ey1nMbeOLZES5vfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uweqh+awyWzU6l9rWmraVnYcvbpC5Gum/rABVstH2RtHPHHtfj0saBZI7jw8hoKjO
	 jPIYxky/Er/Vg0q0gIVrcRgSGEQxTMr6CtGP2mYynkoXgn7aDCjgQ8bcyiZwyfWHPw
	 tIa2wy/r5tj63S63ajm2BWVqLx5+VUdXR44ehbZFEe9tOIdgHwAQHPtQhfLd8SQXTq
	 TaeOFQibOHTeTUBku4ljNBj5O3AEm6tvc/pgr+FAAtyTqWOzrTrEgkHmxt94T7uZf1
	 Vef1ULORT1iF36/Ek6Sp9ujMcSUG3L/MqODGzRnXCO1AxR/zNm/BzfU4yHHMeqohWX
	 b06IyCk/h2JTQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Fri, 20 Mar 2026 08:41:33 -0700
Message-ID: <20260320154134.99740-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320152940.99417-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 385A6140013
X-Rspamd-Server: rspam08
X-Stat-Signature: aenipjsua5rhghkirt57duqscjfa6m9p
X-HE-Tag: 1774021297-610769
X-HE-Meta: U2FsdGVkX18J0tPHpdCGFsQD6+kq+7M+SFBFyARoEjYBHc4q1/2jems08oQGnbTZVpd96eym3xFrYK8I9Zwgz03cBGMystSTkqfnl0XjmFRMqTVAwUp5YTku/m53otmfjE8d8PH+RlvDZHZdRTuBheXbzuatPdEMaLP+RR1bJNu63mBKTGtxfnSABnASVatwwRwCvctza4SDMpWOuLxYvUdk3rXrQAD8ZH/uCHzU3jek6cPzON3sQZrIb+5zwEikabkixz+S0M/ujAe3IR4jH3ysvjnjhzO6PPHwc5W09wo8XJdLRWfDmosrT2iwghbEgDiQ9VmTJ/lGPNh8lJVFmcxkTiGN+UTKPiNHThJXfAIVKfFQd1y1Ofzwp5hSAu7fMTZ8MiTWEs4Gx6m4Mz7dBuqr0K7oP8/OH3AuJEh80gehF+3l6Hxe9kdwQ94VVFA06fC4B2Ml9zpUss02DYhC4EzhCjNiW6w7WblvHojueEP/kz/a9tG1l4dbPCPj6DPcFchNgnnnRfMMWrMuWURRGikH0tGVdNvh7/pP5lKqUZVdrOALoVJIDPzu+NrK+z3tYotsWeMB+zMN3QZ0Q5Ukym+xHki8zeBM8B59B5kl1sdISojnWJSpr9irsGuqlaqMbwEKv4O3AIFheuVMJu8rYwQgmyFy/eceGyfc0Ka7XQIlFkvW6NadpqykJd0d4oBe+QEmppwIIvlDGj9cg9yNBvNn3jo9CD0Z8kc23wl7rFDGDC5aEsnDGrG6Lv/7CUS6vnSpKKH3FjsChoR41c7SYZ2MhW2T+CK0GIgneO9fuGDyd/UoJmubHuimvv4ae8icG85qXVfi904sI6b7Z9QpjEFe8WxUNBSEspTf6u8jK7qRikKarg/s39UnIYC2u+WDyYezVWdKm+Jm8lAe1CP7lJky+gRhwZ8Jr7sC5uI7O4vfZzMhVSJdD5oK1Lw7NzmwEKaweZpdgURvaldrv9+
 4Ezgx/Ce
 H8t0+mr2JHXihsnbIfqPPpBiDx83Y6oqBIbBqW8ghXiiPQ9oEaSmrf/TA0CSkHatW7jpQpQFpt4JxbpkdZeAppEhpvRWYLVgbt4+6AnFIxmTN0dvYtsmoIBlUyI6L5fmePMfa/XSrIW/Vj60I5UkeQWUCJkg6GHWMkhvRuByw7J/+Gc/7HpV44De6PLA1KEm6wjN/YNyqyetfY8Yma3xauweF3qyFEUHrfClWOI32fxeOyArh6X1j3ix2aQIe8za/J1PRYAV5uaEr+9XOr89WNiZt62DMjoYkQ/9YUL1y5/y3UHryDk3xhXE+sA+m06SFQdopEH0c5SjfozKu1d/z0p+fySXCKJdyreYy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 08:29:39 -0700 SeongJae Park <sj@kernel.org> wrote:

> Adding Sashiko comment
> (https://lore.kernel.org/https://sashiko.dev/#/patchset/20260319052157.99433-11-sj@kernel.org)
> with ': ' line prefix, and my replies in line.
> 
> On Wed, 18 Mar 2026 22:21:53 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > The sysfs.py test commits DAMON parameters, dump the internal DAMON
> > state, and show if the parameters are committed as expected using the
> > dumped state.  While the dumping is ongoing, DAMON is alive.  It can
> > make internal changes including addition and removal of regions.  It can
> > therefore make a race that can result in false test results.  Pause
> > DAMON execution during the state dumping to avoid such races.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  tools/testing/selftests/damon/sysfs.py | 31 ++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> > index e6d34ba05893f..704729c7a318e 100755
> > --- a/tools/testing/selftests/damon/sysfs.py
> > +++ b/tools/testing/selftests/damon/sysfs.py
> > @@ -193,18 +193,48 @@ def assert_ctx_committed(ctx, dump):
> >      assert_true(dump['pause'] == ctx.pause, 'pause', dump)
> >  
> >  def assert_ctxs_committed(kdamonds):
> > +    ctxs_paused_for_dump = []
> > +    for kd in kdamonds.kdamonds:
> > +        for ctx in kd.contexts:
> > +            if ctx.pause is False:
> > +                ctx.pause = True
> > +                err = kd.commit()
> > +                if err is not None:
> > +                    print('pause fail (%s)' % err)
> > +                    kdamonds.stop()
> > +                    exit(1)
> > +                ctxs_paused_for_dump.append(ctx)
> > +
> >      status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> >      if err is not None:
> >          print(err)
> >          kdamonds.stop()
> >          exit(1)
> >  
> > +    for kd in kdamonds.kdamonds:
> > +        for ctx in kd.contexts:
> > +            if ctx in ctxs_paused_for_dump:
> > +                ctx.pause = False
> > +                err = kd.commit()
> > +                if err is not None:
> > +                    print('resume fail (%s)' % err)
> > +                    kdamonds.stop()
> > +                    exit(1)
> > +                # restore for comparison
> > +                ctx.pause = True
> 
> : If a kdamond contains multiple contexts, does this loop leave earlier contexts
> : paused in the kernel?
> : 
> : Since kd.commit() stages and commits the state of all contexts associated with
> : the kdamond, when kd.commit() is called for the second context, the first
> : context's local pause attribute is already back to True.
> : 
> : This would cause kd.commit() to write to sysfs and instruct the kernel to
> : pause the first context again. By the end of this loop, only the last context
> : in the kdamond would remain unpaused in the kernel.
> 
> No.  The pause field of the earlier context is set to False, so later
> kd.commit() will commit the False 'pause' again.  But this finds a good point.
> There is no reason to call kd.commit() for each context.  It is more efficient
> to be called for each kdamond., thouth currently we support only one context
> per kdamond.  I will update the code so, in the next spin.

I'm wrong, Sashiko is correct.  I missed the last 'ctx.pause = True' in the
loop.  I will fix this together, like below:

'''
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -201,16 +201,17 @@ def assert_ctx_committed(ctx, dump):

 def assert_ctxs_committed(kdamonds):
     ctxs_paused_for_dump = []
+    # pause for safe state dumping
     for kd in kdamonds.kdamonds:
         for ctx in kd.contexts:
             if ctx.pause is False:
                 ctx.pause = True
-                err = kd.commit()
-                if err is not None:
-                    print('pause fail (%s)' % err)
-                    kdamonds.stop()
-                    exit(1)
                 ctxs_paused_for_dump.append(ctx)
+        err = kd.commit()
+        if err is not None:
+            print('pause fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)

     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
@@ -218,17 +219,19 @@ def assert_ctxs_committed(kdamonds):
         kdamonds.stop()
         exit(1)

+    # resume contexts paused for safe state dumping
     for kd in kdamonds.kdamonds:
-        for ctx in kd.contexts:
-            if ctx in ctxs_paused_for_dump:
-                ctx.pause = False
-                err = kd.commit()
-                if err is not None:
-                    print('resume fail (%s)' % err)
-                    kdamonds.stop()
-                    exit(1)
-                # restore for comparison
-                ctx.pause = True
+        for ctx in ctxs_paused_for_dump:
+            ctx.pause = False
+        err = kd.commit()
+        if err is not None:
+            print('resume fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)
+
+    # restore for comparison
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = True

     ctxs = kdamonds.kdamonds[0].contexts
     dump = status['contexts']
'''


Thanks,
SJ

[...]

