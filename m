Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3FC109879C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3226B0110; Fri, 20 Mar 2026 11:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A42D6B0114; Fri, 20 Mar 2026 11:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1C36B0115; Fri, 20 Mar 2026 11:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28B156B0110
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:29:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1D1F13A1C7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:29:49 +0000 (UTC)
X-FDA: 84566826498.10.3319D49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 08CD94000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:29:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e9ZRE4FN;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774020588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zeia2oPvck3WRMERWIoseuqT/uf4dQcoHS3RRBFpPpM=;
	b=kVsKiW+dzj55acCn6dHEjsSa82xMb0zRmvL65Of1VIHZo43HFItOMic4nOW+7qsP5YuN6x
	pAOyXngbywNJgZnOjd4yXI7MeOgTJSHaPIEnIOtMOHb71jWAYvXw5V6Cacr8uLxUNB+TRo
	SlUQEcxlorROl8N4oWxqzhTStxoxk28=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e9ZRE4FN;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774020588; a=rsa-sha256;
	cv=none;
	b=ItmZhig0Wc/fYz4QQ0gadGX1JwUU/wdtHMVgQpZ1zn2wR40rRMCJcHg0CV4XFMlS7feuI9
	BDlqdilVkg1i//0T6oitRD4wVVFVcW8088dYFyfEV4DhWtRYWD+SHbidqga5QVVHNmNW74
	jIpylSwaDHzvgcDIRDnrn3q0M1wp4Do=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0379B43D44
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA7BC4CEF7;
	Fri, 20 Mar 2026 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774020586;
	bh=Hnfc1lmVge3EQAfJyvbeflWiY1wped76gtYswKbHG1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9ZRE4FNUgrxcLYK2pDr6SXT9DhTb06gwoRktQnxJThWwERm2dqgiffuh9yx82ung
	 vkJl7M1wZy4nI8CrdhlJhqsmGG4Yt4M1L/9+tJwrczKrnTO1DT1hSogfGqNBm14FjO
	 U8JC/nM4JNW3JU6Cy4n1jwkCj2QLI5BgmTaD/HDUu/5E/vC5T3HObgBglDbrRSjJXn
	 9rlrgG4EG8L6JTGLqF4I2szubQXEu/PggTDRYV071cxZsLwOuAdJ/BRxN+M9dLmO4i
	 iilYC5qqVIyuml7I9V3hd4z3ueeoyxDR711WXJvv9n6FqrxYzjDFG4qmPQiRisJkdE
	 ihd09bzzES0vw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Fri, 20 Mar 2026 08:29:39 -0700
Message-ID: <20260320152940.99417-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-11-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7jsexeajf8cp735o7sg4hmfro6xhjke1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 08CD94000B
X-HE-Tag: 1774020587-23066
X-HE-Meta: U2FsdGVkX19KNxyUUNefA3fqXZ23Th0LpF1M/tP5mQqBj3h+1ZWM/2bjKxMzAgU41IdZ3erIkb1IgspozZPt/3dq0wdpxnOk1kduCJekLx8FDHgKxvoQwiyjF+pdSiGNoQgStvzmDmue732Wf8rSLfdL6QAZWHCTJhnFZ8RAPigPRuaWfQ40gBZW1Oz35u6QPsNNJAcsYoCXp4RD7S8BRpOavCcBXdGg9sioOWU2Xn6SdimDQ5sNdmcVpqkOqDRh21J+JbKdjoxS7j2wt5Nho2BpBPD+tv+HsztWcrVP0k8cxSMTbYQu9Ey4TzKmC4OH8kusa0GGHXwJurxdULvLYx+mZvUeIl2UvuD4/9cSqUB3TEGXQsMAuxghOr3xZ+O+XWtOSICSqlpIkM1NeNrPT3fJTR7CSDKAPZ3Cavu1B0MOUm/TdJgfSca4nIc0/odu5+z5urRVMGraIsBZjH6Z+zFq2I6y8HrcB80OEYi3yQtHpAVeQKoHU34K6g8c4V7IBLdaTr9UjnjyIPX+wp5+YPAx6a6hxGuoysuNDoGWEfpt4RzGT+7OvHjvjqzSfOEEV60BWqwlwxjN/zmLJenm2i4eRTma5RAky/w2ashLZ9QG1LAQLfzedVNm8pq8L6JAgJFkDzJwcE8ObjfzP7BcvU+cmz/ZEaB4DW8kLHCzPqNfZxOHUHS5DJEMaqRLTQtEPakVqYMvgAScEWwnEsC3v/fRbJd7Lvv4i7ttoo5Mled5wmEas5Z9n/Gc7axlI+CnRo6Uv0fl8J9RKDr6Drklkxx37fE2AMhWLzv9HDftCohXEogb4VVF1vjrd1a3ySmzGm/w43O7J7CB4thtXPi+UMS1ypDfAkqyO6r0y9UfE6EM/3FPTQNx4pbgN7I7i3Vlehg2JrJdG+EniGNUjUkGR2zqrbV6mWnVrKq3oBb5HldW8utft3wco8tIKkFsXd24xo/F88PyF8n4i5r1usn
 00gZ5xeh
 CXNzWE1dlxyiVy12svUdF0NnruaXQxTZaHeclo66+yoKbScLfhccW5WQmJX0i3FCV7Fx2lvlSgt0uUbkPxUCpjdkO2xFOvr0gK5k44lZUgg4HtqpgUqNK4SOKFE315Qp79BEtBAeafh75KTsQiYRoc93LRq26BcsbXXEJ147Zb8bfoKFFZ73WBhzaZEjrTH9UHEoDXz5+rK0nemGmdZ7BkyLqPPdu87uZEa1ZyudK8pEhblYZNzscCSQ8Tnpa1oZ+egMCgV9+tQUFcCMJYcZPnZOCTrJVELO97SoTYEa71mqqj5URpU/Lk3N8Y0T+5YuIAWCkZTmTE00df6f8rW1G8EGE8yXBfxzba3H2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding Sashiko comment
(https://lore.kernel.org/https://sashiko.dev/#/patchset/20260319052157.99433-11-sj@kernel.org)
with ': ' line prefix, and my replies in line.

On Wed, 18 Mar 2026 22:21:53 -0700 SeongJae Park <sj@kernel.org> wrote:

> The sysfs.py test commits DAMON parameters, dump the internal DAMON
> state, and show if the parameters are committed as expected using the
> dumped state.  While the dumping is ongoing, DAMON is alive.  It can
> make internal changes including addition and removal of regions.  It can
> therefore make a race that can result in false test results.  Pause
> DAMON execution during the state dumping to avoid such races.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  tools/testing/selftests/damon/sysfs.py | 31 ++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index e6d34ba05893f..704729c7a318e 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -193,18 +193,48 @@ def assert_ctx_committed(ctx, dump):
>      assert_true(dump['pause'] == ctx.pause, 'pause', dump)
>  
>  def assert_ctxs_committed(kdamonds):
> +    ctxs_paused_for_dump = []
> +    for kd in kdamonds.kdamonds:
> +        for ctx in kd.contexts:
> +            if ctx.pause is False:
> +                ctx.pause = True
> +                err = kd.commit()
> +                if err is not None:
> +                    print('pause fail (%s)' % err)
> +                    kdamonds.stop()
> +                    exit(1)
> +                ctxs_paused_for_dump.append(ctx)
> +
>      status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
>      if err is not None:
>          print(err)
>          kdamonds.stop()
>          exit(1)
>  
> +    for kd in kdamonds.kdamonds:
> +        for ctx in kd.contexts:
> +            if ctx in ctxs_paused_for_dump:
> +                ctx.pause = False
> +                err = kd.commit()
> +                if err is not None:
> +                    print('resume fail (%s)' % err)
> +                    kdamonds.stop()
> +                    exit(1)
> +                # restore for comparison
> +                ctx.pause = True

: If a kdamond contains multiple contexts, does this loop leave earlier contexts
: paused in the kernel?
: 
: Since kd.commit() stages and commits the state of all contexts associated with
: the kdamond, when kd.commit() is called for the second context, the first
: context's local pause attribute is already back to True.
: 
: This would cause kd.commit() to write to sysfs and instruct the kernel to
: pause the first context again. By the end of this loop, only the last context
: in the kdamond would remain unpaused in the kernel.

No.  The pause field of the earlier context is set to False, so later
kd.commit() will commit the False 'pause' again.  But this finds a good point.
There is no reason to call kd.commit() for each context.  It is more efficient
to be called for each kdamond., thouth currently we support only one context
per kdamond.  I will update the code so, in the next spin.

> +
>      ctxs = kdamonds.kdamonds[0].contexts
>      dump = status['contexts']
>      assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
>      for idx, ctx in enumerate(ctxs):
>          assert_ctx_committed(ctx, dump[idx])
>  
> +    # restore for the caller
> +    for kd in kdamonds.kdamonds:
> +        for ctx in kd.contexts:
> +            if ctx in ctxs_paused_for_dump:
> +                ctx.pause = False

: Since kd.commit() is not called after restoring the Python objects here, does
: this leave the previous contexts permanently paused in the kernel while their
: Python state reflects them as running?

No, we already unpaused the unpause-required contexts above.


Thanks,
SJ

[...]

