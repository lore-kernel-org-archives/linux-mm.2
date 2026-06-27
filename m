Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27366C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E396E6B0088; Fri, 26 Jun 2026 20:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E129F6B0093; Fri, 26 Jun 2026 20:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28CB6B0095; Fri, 26 Jun 2026 20:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF31F6B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:05:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B4E5C301D
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:05:03 +0000 (UTC)
X-FDA: 84923747286.30.A8797A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A52DA0002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:05:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZTbPqdo;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782518701;
	b=6eWqntNFQ6kNiZ9XJJ7sX5nlWSHu7r1ArlD/rX4thbF7RB/NXXeD3sW8DqyBLZdRvqQNWc
	qHxGdOQH/Ct5hPFjtYrUlYiGD02ENmOBgkoEyugRUmAHE5TjL7006UzHzR0/FOolw3ARzc
	raphMj1/Cf2c9tlpmHWKX4/BvfOXcXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782518701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaTIdG2spwckKCehRc5kJjk4jNw/YP4es+XSEGs8qSw=;
	b=j14YByO3kCR1ouV6D4yXjtctuXElggW/HxKQNtMmW7W4uE2GzDk+ltpY6GsjVGI7/v45Mu
	EeLE6PpivjSDtDxGR4ujCKat9uyzL/+SmH4Ot4N7TUAnvNk1aTubkhgpATGj2NEv+5BGOV
	0aCdVaKHggchI+loxUverwj/CfC8fuY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZTbPqdo;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 047AB600AA;
	Sat, 27 Jun 2026 00:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BF31F000E9;
	Sat, 27 Jun 2026 00:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782518700;
	bh=qaTIdG2spwckKCehRc5kJjk4jNw/YP4es+XSEGs8qSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZTbPqdonoA49oh0gHgSqOLKuwIFjZJRM4j1UsXSBMvZ63LI0/LOhspgpSuv2LA2h
	 sm9pMMPk2qW8nsLrI0LgGk8bglA/ELX1QAuq5AecvwjL6Jry7RCJ8I9kNC/OrkJwYl
	 cRGZFZxmtaMNYlRIBXS/jsSOZnBbmMXZfLJ3SJfUz+Lq1PsU2ZDTXdZx4Hmnktn697
	 EeE/L+uVvYc7yXEZCS0zirjwi7USipcIQvFt3AE1EfOd4nPfNSRglHl6vg+K6XWMxh
	 PcuoEALYr+JpNu2Mk93yC+/xWfvhb9Sot7JVEA2q8fpg7i/z51TFWD2aRBWIMjRvtN
	 1VWQ/qlStZjBQ==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare() stub
Date: Fri, 26 Jun 2026 17:04:45 -0700
Message-ID: <20260627000445.85650-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aj7KoDXJv3NByGUm@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ofh6genab481s61cri5wtfyh13tfrscz
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A52DA0002
X-HE-Tag: 1782518701-52208
X-HE-Meta: U2FsdGVkX19X+rb0wH7LIfmHFViwvnzsfoXECZHRkV0dRcC6Q8OUn+ziCacehMQWCr/Rqm/X+ROTX4a6/Gt3wW1kcAuh+HxSYWf/bSkhhm/6poFSEj7XZx820vW6XtvmmFANTqIyZSxrMs76E8QIwZNDlwjvZl0ZsNHQcMmyiann/6KKWx/BJvN3/QQoT0ZsDqjzic5mZBqXlYTWy/tDPYUCskkrzF0j9xTqORzb8WLR69l8oOAJahyc3cTxz2N0AvQBpk62fJoWT2ifgIuniqaFU/O13VgXmg0zxVtb4z65dReukmuS3GOT3g+w8Zhr5g6zrEx846dSXzUw+cCvx/kjtLrGCBnZprzMcl9aoMwmSzjjuaqWDxu81MF4/ZAMQWi1YUPOnzGW6XGtwQc7RLQJ+f3DYztidT0L/Svj2KGXFgaNfneqq9GMkK4P+xbv9GtFED93v3F7Yd3faRmmX6513gkPA3LvtjumA5t3Zhpy8ZSbdwkrUEucgL+bo5/oC4/zMARVfWVhE9eVMSfaMvNJBSv+3djCBoct4JJiP/qP+XGpt22+cvsicqpyEyjDjfHo4rmBE5ho7XcfbCyj5Of68hlp6WgFptl6nwwI3BkHu1rbI6pzDHwuXpJdv9jw0HrF3qaK6RyZ86e6PIRKopfmmnc1NVXboDVtxGpXFV7FEapg1Dpb7uOBAN3sDRfjM9/O/GxWE13caeLn/K+nVALsyjy8Ldzt34sOFh9L52gcLp0iERFSmnSCb0DEFQz8agxo5X1Ki/F5u0Jx2Nx651io7+S4h14NUjaDRgxBgyoOpiUMjx+XHicssANLoUl9LRsV3f3NDGr6pfpKg8nNLnf42oaQ8hcJMsSFVOv5YIPN2xAaUhjAKTcqz2t9TgyImm2entdOP2eCGqYocOBLrSkP/9ssygWyvY+h6MoCVS7E5AuWJh2A+i99ulMnCxITtmZbKENPtG5q5B29UMl
 np0pjSPo
 WM+BRHwuOvZEJtmmUS/fTrUs4vNJkYlanWyu2Mjzg7/sMI/sG19qlC8Sjtko5sBLCi9K3xujlaie6ubwO3QoUvYX19moH3ssZ5qLDZW9pchKkhQi0IcJtlZrgKGA6YMKveZXemT8BRHOv5fNHzO7WCBfVoKVxSLq+77mh7ITJX/IMvZiz8Qy48TZy6tdOe2neqzUdd2tqdE2KRtHNF5h6pJSFGg0DgrVX4GG0BP3Ttn9S20MnrRw/zQkkrgb6JCaChgh0MK9hPkD/WFKoGnHeZTG9rfohZD7EeCGE0Ovj5digoB3IZXZeQCcsOli4B4IIiRnHQeBsZLKLWlBbJQ+bdUpdJUliNeSwACwGpgnR9NK70yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 14:53:20 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Jun 26, 2026 at 05:43:02AM -0700, Breno Leitao wrote:
> > mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> > and reads it back in memcg1_oom_finish():
> > 
> > 	bool locked, ret;
> > 	...
> > 	if (!memcg1_oom_prepare(memcg, &locked))
> > 		return false;
> > 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> > 	memcg1_oom_finish(memcg, locked);
> > 
> > This relies on memcg1_oom_prepare() setting *locked whenever it returns
> > true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> > CONFIG_MEMCG_V1=n returns true without touching *locked, so
> > memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
> > is reported by UBSAN:
> > 
> >   UBSAN: invalid-load in mm/memcontrol.c:1932:27
> >   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> > 
> > Initialize *locked to false in the stub; with cgroup v1 compiled out
> > there is no OOM lock to take.
> > 
> > Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I prefer this way over the idea to initialize in the caller. For the
> actual implementation, the protocol is that the thing is initialized
> when the function returns true. This version of the fix maintains that
> for the dummy as well:

I agree.  I also feel the caller code is _slightly_ easier to read as is, than
adding the initialization there.  If it is initialized there, I would assume it
will be used somewhere.  But after finding out it is not used for early return
cases including memcg1_oom_prepare() reuturning false case, I would be confused
about the inefficiency.  Using a variable after passing its pointer to a
function depending on the function's return value makes me assume the variable
will be set inside the function.

The code is simple enough to read in any way, and my taste is sometimes just
weird, though.

Anyway nice fix, thank you!

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

