Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3EB1099B56
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 01:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78EF6B0093; Fri, 20 Mar 2026 21:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29A16B0095; Fri, 20 Mar 2026 21:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18176B0096; Fri, 20 Mar 2026 21:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACC1F6B0093
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:02:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40E1C1DEC7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:02:08 +0000 (UTC)
X-FDA: 84568268736.12.70751CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F9561C000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:02:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMpMpIhY;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774054926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATyC7T95PUSNV8PobGQUzEgzjaB/UJ7vtwLTE9u36oY=;
	b=lG5QN1pXHnNff7A/9FnbZIOV73oLj47VBMkpD20qAQFCVxk8eR0qr+SgINm51Wz4rQpPpz
	ldXG1kdVFCHB++hfGfglcGFqh3V3Oc2DVy/jY5RcYPtyQdkRdEA70b9suXJGeSBwGEeXM1
	QdziR3nUu2E7biaqcNX3FYMyYEeknq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774054926; a=rsa-sha256;
	cv=none;
	b=XDaAtiOIi50nxoh/roNNZpAlRTlA+3/DUw3Xp9mIrBc0ZXTaVQ3dVzFCI+XSIVcW+lWQRr
	/R83QNKAEhocijJK1Se5qt+YNbFOj6ef4GU1pNsVQTaG2hJMKOwusQYzUHHb1PCc9O4Xj5
	+X5X24FWmBakIrBrKM1CQy8kGR5Mw54=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMpMpIhY;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 049A160126
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC03C4CEF7;
	Sat, 21 Mar 2026 01:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774054925;
	bh=0yYB8TFfBq7hSyyiDU6/wS7/MxpcVDUgHb7ZxIWACZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMpMpIhY+oJin9kFaNMgEx8u1rCcFnwjvNXXicnucVhUrhHq92rJfctXXDBpMFS6N
	 wiiKMbngcuEeCcNZIkz76p5WAgzgjnlKFdoG6Jw1qxKegJDCq431XVWWrkml2BJP8t
	 YAuf+cCK/e1U2bd1CLuyIiB8dmtjHSHIcl8Xiw4F/Izdv3v+63VoRFvgR918XTieVu
	 /elS6A9JwPTFaHxiQYSq/azAydQg1+N3Of8aLJSibOISuGAYKPtvi29QJe3MYev0S1
	 czivg0DIhShYu/K9QgeDXNQDUiFAYVCA49XubWxPrZhRUyvBTX8hk1N2jDg3rnuA9l
	 jkwiy35UJdR2A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Fri, 20 Mar 2026 18:02:00 -0700
Message-ID: <20260321010201.82092-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320154134.99740-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m9pjr7dsp5eqarf7hdckuyf3gnoikx5i
X-Rspamd-Queue-Id: 9F9561C000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1774054926-143158
X-HE-Meta: U2FsdGVkX19mc0xn5h062J1EEvaBMV/+Bt75ccdDGxUxLbOCb+Xz1yDPHyOdI3cTgdDBOGhMRYx0gUwXSQCP0E7MDXQHEMFFNGGD/7onxN7nHzOqrHvJDEIhCowku2lGfmtbBuxhJ3RWXAR19PcUOxlhNU5MM/n+eS+h6X3YM0PDVtPCut1ZgDhql2WF4h6GjFj8l8v12xXvj7LDW0avvZ4jAjkcJn22a+5o+J21NRnH3a9yNjiXyCQbEekRTEPjYPkGHa+cqf2nKtxcYUQmdrn9GsE6E39+2Jg1ettUD6/cG/udD7XnhyjPHp82q25zx0Lbhwz3pwbzCXeXHxZBic+h31NJ1hTg8H/wSa1eXRRa5jOrus1OXI+p+2IcRxuvR6+90OxJzprpX46j2162nvUqzvZP6jacMT9nyITQ1SjsDYlBFZB0QsjdoBeLTfLPqmTOuup2hRKzsPhMlW2Bwqx4haZ8N3qiRJcdLTpg6R3NpM3NVhOfgMrX6Ot1BB9QKuKnYwXqjG3sMP0iwLvYyftUmKjuRyLSjM6IpyhgclI63k+WDvKKGzuSJLqtRszOPiueAEZgsuotjHiAlN3/eKmkej9LloQmqa+W83S8NoN7bO81fJc9QS9g0K73sDigmaSsadBbTyj3rOKSefIH7AMXIHOmwVj0X8C+XcK9QqsgLh3b0sNmZIjjjLdJynhCYdftwZnoPoDEiamRxlhfJGdSbI+kIaafwLGBmFMiLx5W4LfDEkJmBBoe7y0YOaIPGpd1G+FoyzfER3OwUbBF1xeQrBxfXfXPANtLSXxseOR55vxNnhLiWI4dz87SwvkzrL8z7WalSuErz2HjBkcKZfc2OFenSndj+9oZ6i/ncV2AT9eZLs1va6LrXoQpKB1eoT/qSaqFWVgi+hbRR15nNDgNo5ZEkbMb6mcPRkX9k+hwnOzT3Do9LsNnKn61PMKsVtFclfVrXLBiruXj986
 6CO/3ehO
 CeSD4RtX5kDWJB/2RrbjGsMqchxYjO35PA886IQ6vrWesHcmuwIvIVOZxAl2fmVHtoz9DtMiVEop/p3t5I4/3jYHi9xGC2usnYJe+HUUpcdcF7rAOzFypI7f1e1s8TcF4BdygDBNJahYlYGZUViBfRyuNBCp5ulz3sUv8uzxO+5oIOyvYxBz8fCcXUq3z54RM3uGLOF8AnNI719HAYJBCQyin+jXvdskyxxRuh7lqQy23RBYE+DakqtuaN4wZqjE+a8tCF1eL69y9ZGNaCGjS0UL9NTd3SscaSx/unIO6HDpLHap1yfcin0G1cAigd6Nhb7IIJHKf5AoJd636fAZfVavPYIK8y4W8kgX9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 08:41:33 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Fri, 20 Mar 2026 08:29:39 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Adding Sashiko comment
> > (https://lore.kernel.org/https://sashiko.dev/#/patchset/20260319052157.99433-11-sj@kernel.org)
> > with ': ' line prefix, and my replies in line.
> > 
> > On Wed, 18 Mar 2026 22:21:53 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > The sysfs.py test commits DAMON parameters, dump the internal DAMON
> > > state, and show if the parameters are committed as expected using the
> > > dumped state.  While the dumping is ongoing, DAMON is alive.  It can
> > > make internal changes including addition and removal of regions.  It can
> > > therefore make a race that can result in false test results.  Pause
> > > DAMON execution during the state dumping to avoid such races.
> > > 
> > > Signed-off-by: SeongJae Park <sj@kernel.org>
> > > ---
> > >  tools/testing/selftests/damon/sysfs.py | 31 ++++++++++++++++++++++++++
> > >  1 file changed, 31 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> > > index e6d34ba05893f..704729c7a318e 100755
> > > --- a/tools/testing/selftests/damon/sysfs.py
> > > +++ b/tools/testing/selftests/damon/sysfs.py
> > > @@ -193,18 +193,48 @@ def assert_ctx_committed(ctx, dump):
> > >      assert_true(dump['pause'] == ctx.pause, 'pause', dump)
> > >  
> > >  def assert_ctxs_committed(kdamonds):
> > > +    ctxs_paused_for_dump = []
> > > +    for kd in kdamonds.kdamonds:
> > > +        for ctx in kd.contexts:
> > > +            if ctx.pause is False:
> > > +                ctx.pause = True
> > > +                err = kd.commit()
> > > +                if err is not None:
> > > +                    print('pause fail (%s)' % err)
> > > +                    kdamonds.stop()
> > > +                    exit(1)
> > > +                ctxs_paused_for_dump.append(ctx)
> > > +
> > >      status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> > >      if err is not None:
> > >          print(err)
> > >          kdamonds.stop()
> > >          exit(1)
> > >  
> > > +    for kd in kdamonds.kdamonds:
> > > +        for ctx in kd.contexts:
> > > +            if ctx in ctxs_paused_for_dump:
> > > +                ctx.pause = False
> > > +                err = kd.commit()
> > > +                if err is not None:
> > > +                    print('resume fail (%s)' % err)
> > > +                    kdamonds.stop()
> > > +                    exit(1)
> > > +                # restore for comparison
> > > +                ctx.pause = True
> > 
> > : If a kdamond contains multiple contexts, does this loop leave earlier contexts
> > : paused in the kernel?
> > : 
> > : Since kd.commit() stages and commits the state of all contexts associated with
> > : the kdamond, when kd.commit() is called for the second context, the first
> > : context's local pause attribute is already back to True.
> > : 
> > : This would cause kd.commit() to write to sysfs and instruct the kernel to
> > : pause the first context again. By the end of this loop, only the last context
> > : in the kdamond would remain unpaused in the kernel.
> > 
> > No.  The pause field of the earlier context is set to False, so later
> > kd.commit() will commit the False 'pause' again.  But this finds a good point.
> > There is no reason to call kd.commit() for each context.  It is more efficient
> > to be called for each kdamond., thouth currently we support only one context
> > per kdamond.  I will update the code so, in the next spin.
> 
> I'm wrong, Sashiko is correct.  I missed the last 'ctx.pause = True' in the
> loop.  I will fix this together, like below:
> 
> '''
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -201,16 +201,17 @@ def assert_ctx_committed(ctx, dump):
> 
>  def assert_ctxs_committed(kdamonds):
>      ctxs_paused_for_dump = []
> +    # pause for safe state dumping
>      for kd in kdamonds.kdamonds:
>          for ctx in kd.contexts:
>              if ctx.pause is False:
>                  ctx.pause = True
> -                err = kd.commit()
> -                if err is not None:
> -                    print('pause fail (%s)' % err)
> -                    kdamonds.stop()
> -                    exit(1)
>                  ctxs_paused_for_dump.append(ctx)
> +        err = kd.commit()
> +        if err is not None:
> +            print('pause fail (%s)' % err)
> +            kdamonds.stop()
> +            exit(1)
> 
>      status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
>      if err is not None:
> @@ -218,17 +219,19 @@ def assert_ctxs_committed(kdamonds):
>          kdamonds.stop()
>          exit(1)
> 
> +    # resume contexts paused for safe state dumping
>      for kd in kdamonds.kdamonds:
> -        for ctx in kd.contexts:
> -            if ctx in ctxs_paused_for_dump:
> -                ctx.pause = False
> -                err = kd.commit()
> -                if err is not None:
> -                    print('resume fail (%s)' % err)
> -                    kdamonds.stop()
> -                    exit(1)
> -                # restore for comparison
> -                ctx.pause = True
> +        for ctx in ctxs_paused_for_dump:
> +            ctx.pause = False
> +        err = kd.commit()
> +        if err is not None:
> +            print('resume fail (%s)' % err)
> +            kdamonds.stop()
> +            exit(1)
> +
> +    # restore for comparison
> +    for ctx in ctxs_paused_for_dump:
> +        ctx.pause = True
> 
>      ctxs = kdamonds.kdamonds[0].contexts
>      dump = status['contexts']
> '''

The above fixup makes the test fails, for the obsolete targets.  The fixup
needs another fixup, like below.  I will add that to the next spin.

'''
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -200,11 +200,12 @@ def assert_ctxs_committed(kdamonds):
             if ctx.pause is False:
                 ctx.pause = True
                 ctxs_paused_for_dump.append(ctx)
-        err = kd.commit()
-        if err is not None:
-            print('pause fail (%s)' % err)
-            kdamonds.stop()
-            exit(1)
+        if len(ctxs_paused_for_dump) > 0:
+            err = kd.commit()
+            if err is not None:
+                print('pause fail (%s)' % err)
+                kdamonds.stop()
+                exit(1)

     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
@@ -216,11 +217,12 @@ def assert_ctxs_committed(kdamonds):
     for kd in kdamonds.kdamonds:
         for ctx in ctxs_paused_for_dump:
             ctx.pause = False
-        err = kd.commit()
-        if err is not None:
-            print('resume fail (%s)' % err)
-            kdamonds.stop()
-            exit(1)
+        if len(ctxs_paused_for_dump) > 0:
+            err = kd.commit()
+            if err is not None:
+                print('resume fail (%s)' % err)
+                kdamonds.stop()
+                exit(1)

     # restore for comparison
     for ctx in ctxs_paused_for_dump:
'''


Thanks,
SJ

