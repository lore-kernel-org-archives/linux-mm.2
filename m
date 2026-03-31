Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC8810F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBFC6B0092; Tue, 31 Mar 2026 15:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD006B0095; Tue, 31 Mar 2026 15:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC29C6B0096; Tue, 31 Mar 2026 15:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB2EC6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:21:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7318613AB4B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:21:10 +0000 (UTC)
X-FDA: 84607326300.25.08729E9
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id C411B20004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:21:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q1Zrcu22;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJE3PpkFeGHJrMNwgWqXHyr2ZWENeuionHCcPXCokI0=;
	b=3AbwDRRKSNm4FQkfLPkins+RFvio6hKYPMThFDGcJ2q/z1P8o//R/1VvpIN6EXNV4ysNvB
	mVQPNf9fwKbtm4G/FMe5BpDn4BUQWGW3Ta7u0ceB8pDtxiLvkGcOyc7cBX0Fdz/k1Iehy+
	voaSGWX2tY4CIpqNanG5pKsr7kvp75Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q1Zrcu22;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774984868; a=rsa-sha256;
	cv=none;
	b=H3NamPJwUjijb9FSuR0+cUZEa4nnNg/4WgoJcJCKhxgyVTHrQ51L8YLWZ05BgtMRYTvJZY
	zQlnvjAs2lIAk5q5gw63Nx7Rd3was6jPqCpQd8I0XIbahBmqpvLlaIXKChD3bIOyfwypZO
	SvN8DSNruKL1f2cPiL33M+GTXcIrNZQ=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40efc77933fso3837918fac.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774984868; x=1775589668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJE3PpkFeGHJrMNwgWqXHyr2ZWENeuionHCcPXCokI0=;
        b=q1Zrcu22dRp4mKpnByWUOFCCquEeBVXF77onepOyGD+dSq/RKYwUB8HO7R1YwxiEeu
         uiAz93akewMP2SnC1fVcWuvbr23DwwXzmUlgyXMD3fujFCqlSPxTlFrG38DZTdWRjnpZ
         6WvwFNKTDaflIF4QZ3S/H/EndXCD4oIEFkyWAA3tSlsAVC8svlwuRQ1jKJGiH3Vmzsml
         b5+aHueMQOR+8xXRmRUA/0FQlfjaL5+ARB9zu0gmclY+eZgCXGNcxBO9oQyJU4GerO16
         Er1oJGBTqBItZ4GuT7oYKh/mAY5LM2sPUzIIeewpj7IOxB9GIdKH5VZ8rrncoO5ee+9r
         J3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774984868; x=1775589668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LJE3PpkFeGHJrMNwgWqXHyr2ZWENeuionHCcPXCokI0=;
        b=MMHcdGRy+rIK8kj2A2KKOET87HZ1jAo95/Pe5IThL7nTjH/bzbp3VttAoolNqBAtfE
         68XdWEbqn0JF+1hy8h62rh57ZuTSo+OvvdRwimMw3qOJ/CfMmvlfrnlB5NGC4ytGfs2s
         9Qzjo58TMUO8fD5Onn4zgamSUhEBadrpiLMZNg3RxCfAxN6tpqV7bxIH4DXGN+GAZXSV
         1c/OLhILBX20ZEaZd9Lll3LL0TAsiq6UwN/FnsebYxa2EwtaZGltWqcW4drR8Y5boXR7
         uGxqpPZfvyhNkUAwvNuFSwrcWYNh2IZRpluWIbVKXsJ0ucJtUeNSyAFS74pqNu+BYOvF
         KR4A==
X-Forwarded-Encrypted: i=1; AJvYcCUpuLeBR/y2jFvJG5tRCC0TqDU2XfbvVbA3ze2pCxyaS0h6KLQMOWhTlTOs5OBaekvasOq+Gu5KCA==@kvack.org
X-Gm-Message-State: AOJu0YyOKqInufiMjRBxK2GhpNJRjpY73IfIpFTsSo4uEUBPxzIKUhPx
	ng4TO07EDIB2QapcTSo2oPcNnNXVG5Xq4K2b/OJsaW4gs+SJha6BNPVz
X-Gm-Gg: ATEYQzy+p9WwK1fmwo/vCg9/hyQAxFBnVNnNasaoEHzyz4F4z0NxFUVCIsxf7IKopQK
	wdWJQQRZeALlBa5htfIWZO9+eXnBQLuzYAYXI7XRf9Ndo+dvNz4qsmCyZd0AHAMCSx8cnWKCsdj
	ExumBuTVf/0Pw5E+KUDwyy0uMaxkE2/tVPwoQat35oAtijN7vg6t125MXa6njIIoE7/SV7pnODF
	xGZd8nlgwKZ59l57i8y9w6ZU1bTanl192C4CwTwOQpgvb7rVtNN/Vj6VMYvOp5VcRhVLmhZP12q
	8KRobT9VjOVLh2M315WkqEFDnvzEeajnk9HFTXSTTc/TgrwAe6/mwCkdqAjhTo3LVx0ZAo4Eokz
	h1SPiF3t8/AAmaCoY/aJfjNUQ9y3YMWwasRL7xrRakfFgjJrUDtYxr3NoCeYfWCwGdIFfx5KN8e
	A5XQcXWWc4SR/eoSmlFOO5cw==
X-Received: by 2002:a05:6871:7601:b0:41c:e4:f93b with SMTP id 586e51a60fabf-422d0000ea4mr505280fac.43.1774984867505;
        Tue, 31 Mar 2026 12:21:07 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:57::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d04501478sm7851874fac.0.2026.03.31.12.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 12:21:07 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Price <gourry@gourry.net>,
	Jackie Liu <liu.yun@linux.dev>,
	joshua.hahnjy@gmail.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
Date: Tue, 31 Mar 2026 12:21:04 -0700
Message-ID: <20260331192105.109847-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260331120110.9136f80efa9c41146f1b92a2@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kq1t6jzes687m98ykbeyeexhwbymt3bi
X-Rspamd-Queue-Id: C411B20004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774984868-320154
X-HE-Meta: U2FsdGVkX18GAzdlTvtIJykw+hY7IzaL9bc6yBe2j8rQ9MDrZILt7FB7Yyy7iH0AWJKdJFhBlKfH7kKjwui7Vswbei0apjvaz4bdEqEvFjhmDmL55qGbzOFkWTpwXimNyF0AErzp4MOJNi1idFdSM2AemcCgUG0UB9BJVvsIuYpYQT43IvAJjOyACabE8VOWfRicp1NCR8hkHMFvfPG6wsh9MMuFCa3o/MP7Y+Uv8/e3vqO72ZJ4oQD/yNnIXOLITcEdBcHM/NAMh4ZTcegvefXf7HaAO4VI0eIXPl2TtOZW4op/4rFWWRJ3yaFL2ixxushKDfVTrWMtwme287AlydwITpRhFfBsVMNga0c9OhI5a4RoBig2JJFn3HxGfz1G2GrMruKpOWq/NBEWQ3FRgoV3wVZd7azDBNyRHp3OQhXkpHzlT7k4kL6L9F+Yp5dl4YCPMAN0+tLy4G9FWUQrXcXMRjVot/+142mkAIr/5ZxRP6UracGRSUifLKvYhZbSescvtlMHOjVpt2QKsHT5kEuC3jVg/sgo5E1DSpC4tip/gOXA1352zBBcVQocwoXnnS7AesPjRv1CioIN+RHmGsshveg9eTJpajA3Yj66TrMRJYqg/CKiSU1uqWpItkPbZ/PNpjfdqutFpE+76RXtjYo3dUoqB/7Qwz6EBu6QkeCtpcRAypvN+ViPbUSsZ4z11E8W36p0VSTGW7aX9ofj0aPP08lAxJtSfFmMS9N7P7PqC4DgJlH/IwSTd+byd8a1obCHilw2N1E/5VWHUatYih2ig4BWsm2Scrf/xrRX2rbAu7gcDZa2ELHbfARicDEsr207Zt73p/0lCPM7AK+prkAl+j0Aez6upacw+yGtfUGUoXrKyTpFDJTVEeMGHcN4GoEeBDnZx4zHCDKHa2MTivcJuX/Ic6VUsdZyKLk034H93KspDRzsl2NiiNrtobS51ZZk181bWKfOWxCs6np
 1R5oQ9/L
 I+rSCO9rgSLzJp1EC+rGSmZU/rt3RpRML7tBJGR2KfsrX1feICbvTrIeQDdve+JzAPffQkvFdVDksxwwOUWZLF6/8cHE/4o7uP87dqs4DK76GoRVMOd4TrCiTdVqNnMj54PGErQxL+ryVH+23UMZQPCt4nh+DJ3IC0DKWIbenJ6Q3tn/XaCd9u+NS8QN2Za2Ckl0e2KaJVijvV+KmFmgjhi9kxgEHFW8m7f6AiByYL24NhePHT90AclvaOvbdWCy0dFKV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:01:10 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 31 Mar 2026 12:53:40 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > On Tue, Mar 31, 2026 at 06:07:40PM +0800, Jackie Liu wrote:
> > > From: Jackie Liu <liuyun01@kylinos.cn>
> > > 
> > > Add the missing kfree(new_wi_state) when the auto mode is already set
> > > to the requested value. When a user writes "false" to the auto sysfs
> > > interface and the current mode is already manual (mode_auto == false),
> > > the function returns early without freeing new_wi_state allocated at
> > > the beginning of the function. This can be triggered repeatedly from
> > > userspace, leaking memory on each write.
> > > 
> > > Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> > > Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> > 
> > ..
> >
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
> > >  			goto update_wi_state;
> > >  		if (input == old_wi_state->mode_auto) {
> > >  			mutex_unlock(&wi_state_lock);
> > > +			kfree(new_wi_state);
> > >  			return count;
> > >  		}
> > >  
> 
> Thanks all.
> 
> Am I correct in believing that triggering this leak requires elevated
> privileges?

Hello Andrew, I hope you are doing well : -)

Yes indeed, writing to the file requires elevated privileges.

While going to check this out, however, I noticed a different bug which is
that the file is no longer called "auto", but called "__auto_type".
I suspected this was the result of a newly defined macro, and surely...
commit 6cce897a37dc "compiler_types.h: add "auto" as a macro for "__auto_type""
seems to have defined auto to always expand out to __auto_type.

Of course for using the __ATTR(name, permissions, show, store) macro this
is bad because writing "auto" there no longer works...

I'll send up a quick fix to just manually write out the name instead.
Doing a quick grep for the pattern thankfully seems to only point to this.
I do think it is a bit weird to pass a raw, unquoted string into the macro...

> I'll add cc:stable to this and shall queue it for 7.1-rc1. 
> This means (I assume) that its entry into the -stable trees might be a
> little later than if we were to upstream it immediately.
> 
> AI review liked this patch but claims to have found another one:
> https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev

Sashiko seems to be correct here. Pretty neat that it was able to catch
a related bug when analyzing the correctness of this fix!

I can send up a fix for this one too, or leave it to you Jackie, whichever
you prefer! Just let me know : -) I'll go ahead and send a fix for the
naming issue though, since that one seems orthogonal to this.

Thank you, and I hope you have a great day!
Joshua


