Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 089D9E63FF9
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 21:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C966B008A; Sat,  4 Apr 2026 17:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DBB6B008C; Sat,  4 Apr 2026 17:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323DF6B0092; Sat,  4 Apr 2026 17:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20E266B008A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:01:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAF991A090F
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:01:27 +0000 (UTC)
X-FDA: 84622094214.16.D87ED73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 11D8E1A0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:01:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=djJY5HVr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775336486; a=rsa-sha256;
	cv=none;
	b=BfTIc0xZWvqITwJaQGV1Bm5BhCPqwtPACixgpLJrso/Hq/CU9nK12f7sAvMopmAcB4Q7Bl
	nbvAfSNTAB+BFQB4f8NZPvSoQNayhVLqBYWFA6udSD9lPTMFjXvosEl2UKK/OrEv2Z/kdE
	yGhANumnZjxaAy+UjiNEYUGoK3/5TT4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=djJY5HVr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775336486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2oHcJXx3yGLx5B5xG+6VmaBPueARtArg3mxO0g1ASg=;
	b=qkjSt8c7Ru2rdO/Ha61xKLEGrCTPtDQ6ix/MWe8dOdwCn4uc7Qdg5Pz2GWGejWS63U9LBk
	cuGQNPVNZ9BGKbcNVv6VyRe70eXZa0oDogCUgz57yQteM6EZLVN/3gHi6ItIjciArvkWgd
	UCs9WICOTt8VMnxP88emZYP107674pY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D7A660008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E307CC19421;
	Sat,  4 Apr 2026 21:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775336485;
	bh=BE7WCOjZCyh3D0O3nA0Pw0gvP5pQ6dq1vt184ZQYo8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djJY5HVr7Z5Iz/LPL7rFSferVpA/SvHCZN3DD9pCOxHKKFnUgEkj5z7wcMMCuwWFD
	 FVXmBVGBZ/EqUaUzmBTPu0PmmJhyFodz9TMjVeHj2uLXL93WLFxNhx4LFUCm2nTWfB
	 c/XyfM+qqIG7nbG7sCEO4LZVrebBrjpXHR5jJoBRPJn4CDEp1aNggi7zhilMvECetD
	 R/YfQKXHTXGTIErUNqvttWPacVb83Q+0hAygiOof20RiEXXM8CXsHpAVl/1jHryAyi
	 3Ki9lTMMFUJ1YjKE6+hRn3P/tCTvACkCwAvp4TNCazoTqiTJ9Pm0pOgpkKdZzrrY4U
	 to08EN6ITZUhg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 4/9] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Sat,  4 Apr 2026 14:01:15 -0700
Message-ID: <20260404210116.87508-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f54b5kgpyibf7pykm9hb5n91z31yjwxf
X-Rspamd-Queue-Id: 11D8E1A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775336485-569509
X-HE-Meta: U2FsdGVkX189HpoLrpxHoS2gBMkc8tQn02+su4PvHlHymxLpnfMzwaC49aJpGOx5/HK7nIufqJZf1PcLTQN1kAy3g2IRi8kMYmReAQoEisFniUk3+jIgqxMxFHH5c2fVmXbur/NXQY5+dohxrQ/gEtoSZ3l8AjxaWgKP+F9k67ajx/PmRER0xdSkzzq8jDDCjzoZfH1dsTdnf4L4c15HbBc5YJuELI8VGQcKZdrs3nj7ht8S8RLJTmzoc4sO3I4TYP4AO+7QKzxdbT13djYRkaBGmgIzKU31Xs3ZTus0YHbrDtjbH5gkc0b1YCV9upSzQDLmNSa5nkTpH/4sXFSmdLgs317jdLrtoIZKswKdxIAgbp/ZLh3cOFAWAQcJo4jUo4x8z0CD0lrSvrDmviHUhDwGrlF+y0T37CRofx9bxfeJzv58jPB3YBSubRizIWppOfzDX5Rjai5ZtT1v1nH1lAk2dEWix8xuusHyr+GpunIvPF9PDY5Pks16/GLBkggcUALmtB/BOhMZO/CBfJbMWdelMzB5p4te9vxJjZ2zUUi9oWcN/4QeWcNLSL/xHT/G3aHUjSyHSv/B2jo6Z9IZ/gXUaYuoh8nfEneNZTGAViUgYQoDsqW2NclCqbCx+dhJJXGgHOvS+N0g9IfdGAJE80JfWUD0pSETycL0O/efIsQseylZsZYvbAHkN0GSLRm5UiAf9LAbkWbMmE98CkB25+lTzO+QWX1tXtdhCmz1Ea8GVL1ephEY57nsuheM7QzbdB9lFQaA2iC5lzaM25T++Zy/Qjm947FljKBqDG70lY45KqQKvsZ5MqxM9VT3dUwNlCi/JkmxX8LR/zBHBmr0XKzNqnAyUIWImqsBjuNDCh5oq5c61gKqz9Ct8plrDAobwyrf/g5QXUESyZrDpdUKwJhuJJIP/nta3I1DzM34DsUWS/xk5xUMjJvPmsxivAdj6sIN2grzZaP791xWSeD
 qD4/FAyn
 SE/r5jaUpaom/iV7QiqxjQmOVrgG6zIgOAzdql3heQ+oqk5Tyb6oOMSalXduWHMcw+XuL01+G/0DKBmg2yUCSmVGELhkdVav0felkhydKaQS/Jc283+y+ESfVmc8qFG61hpJAzqYHfZ0f3slXp3kZeTaDhEHP4JHbvsNySQ+P/n7kmMr88/VI/hyUXePuGHpGt056MgnjGvb/jJeHDkGOfd5ygVKOvTf4LLsAeP195/mWr5uoWrvk9bCqCutk+NyZzibKp+QG0ENifhBHK60QDzo9y9BpQTifdELUZ/Tl+jNP9RXDDHCQSRQ0QfBVE0DwcqXAPkxR+Jp4pqmHudo7xp+uX9aIo33jQ77aQy+Ss6JbJluHga2BzXxxsp+br9eyx8hNotHxz3jlD/LalREHg5ZTBPCqFdEJg0hakKuoAiHHXb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dropped individual recipients from Cc list, to reduce unnecessary traffic.

TL; DR: sashiko found real issues.  I will fix those in the next revision.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-5-sj@kernel.org
> # start of sashiko.dev inline review
> commit 5f8a4cfde3d93d0a4d4ac3d9a57f14f310c43e02
> Author: SeongJae Park <sj@kernel.org>
> 
> Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
> 
> Update DAMON usage document for the DAMOS action failed regions quota charge
> ratio control sysfs files.
> 
> > diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
> > index 534e1199cf091..3d6af6ce72d82 100644
> > --- a/Documentation/admin-guide/mm/damon/usage.rst
> > +++ b/Documentation/admin-guide/mm/damon/usage.rst
> [ ... ]
> > @@ -398,6 +401,13 @@ the background design of the feature and the name of the selectable algorithms.
> >  Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
> >  setup.
> >  
> > +You can set the action-failed memory quota charging ratio by writing the
> > +numerator and the denominator for the ratio to ``fail_charge_num`` and
> > +`fail_charge_denom`` files, respectively.  Reading those file will return the
> 
> This isn't a bug, but fail_charge_denom has a single leading backtick and
> double trailing backticks.
> 
> Additionally, should "Reading those file" be "Reading those files"?

Good catch!  I will fix those in the next spin.


Thanks,
SJ

> 
> > +current set values.  Refer to :ref:`design
> > +<damon_design_damos_quotas_failed_memory_charging_ratio>` for more details of
> > +the ratio feature.
> > +
> >  The time quota is internally transformed to a size quota.  Between the
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-5-sj@kernel.org

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260404163943.89278-5-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

