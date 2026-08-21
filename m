Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240D2C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 21:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C726B0095; Fri, 21 Aug 2026 17:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD3D6B009B; Fri, 21 Aug 2026 17:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D45F6B009D; Fri, 21 Aug 2026 17:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68FFC6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:35:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0D81140290
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:35:16 +0000 (UTC)
X-FDA: 85126582632.23.F88FE6E
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf08.hostedemail.com (Postfix) with ESMTP id C166B160009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:35:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HLAC3vTl;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787348115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mcusd25TqiiguEeVFskWqDuX2/CfPhjxnrX4zJ1h/iY=;
	b=pCeKUc/9YzFNYc+Gh7tyT0cCumOGGUa8SAxYnWDneOcrmitVf5eTXr67u22fSsCDfGk7/r
	HVyAtm++HFYapy+dGEy3MxgXcojYpuBI7yQQ+IHESybgbjZqSqCJuSXIrDW2dOiMVSOn69
	7ag5+oNvmSO6apV2mSeWBVqlJQsfCNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787348115;
	b=aDjp14WR34f7QrmemtMCQBC6B24d/aLtlK0p4Bf6F6oBmTRvaOKMrUDRoBNtilLvn75hIP
	LQA6XsveEPkVbdkYDSNOf2Yfoxqm8WFoDFjlczP0dipsqJVZ0UFKQ8+H+m10O+ZxhOQ5Fq
	vCtxYjyzQk2Bu/a6L4WD5G0XTux4S2c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HLAC3vTl;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o8c4zF4D2sASPXDeNAkCDbQ/WUugHXEUBThuwoDLNnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787348113; v=1; x=1787952913;
 b=HLAC3vTlZSKWH6d+79LfitBu65Z7UoiAqNK2Tp/f19hvsa61rPgk63oCMneCGlCKALnXqjya
 mps/5lHNLtjCU2Z/YJIY0HVdYeVXObjTg/rABSmbsfq1umwVhOsLC2Dyn20U8nZjX100nv899Wj
 bh6mreEIK2V99n7vcc5ma7tM=
X-Envelope-To: linux-mm@kvack.org
Received: from castle.c.googlers.com (35.203.187.139)
	by mta12.migadu.com with ESMTPS id e805eb4d6b971688;
	Fri, 21 Aug 2026 21:35:08 +0000
X-Mizu-Trace-ID: e805eb4d6b971688
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,  Ridong Chen <ridong.chen@linux.dev>,
  Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  David Hildenbrand <david@kernel.org>,  Qi Zheng
 <qi.zheng@linux.dev>,  Shakeel Butt <shakeel.butt@linux.dev>,  Kairui Song
 <kasong@tencent.com>,  Barry Song <baohua@kernel.org>,  Axel Rasmussen
 <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,  Wei Xu
 <weixugc@google.com>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
In-Reply-To: <aogQ6iDA7RkuTtDG@gremlin> (Lorenzo Stoakes's message of "Fri, 21
	Aug 2026 09:58:52 +0100")
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
	<aogMyu5R_DZRqp2J@tiehlicka> <aogQ6iDA7RkuTtDG@gremlin>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Fri, 21 Aug 2026 21:35:04 +0000
Message-ID: <7ia4tsonw41j.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: fpw65hkziuzjyhx1xf6piry8b1jfzxtd
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C166B160009
X-HE-Tag: 1787348114-669909
X-HE-Meta: U2FsdGVkX1/BsiaTbIm5uYCBVVpS1L6ABwcVc+gjJXUHS/VGjMY12VXvuv078vFKCgrCrkmAKspbzCMFaEe6idmAAeRe/1NwDVQ6RDO/wanJIuBLwj76NyrEGQ6Gj+ScyCQOE7OdYfBPJcqBnK6p6cPIvXZNLmJHhGywY2d09ndbs9xG0Ccm1lPfcJDH/xRV2gFsXXFWABfCvzy60z5yGK4qV+ow8lClvG5BJUQST4bcUaZ2Yyp+Xhfds1HPIkkIAdV7xMjUD04k+Kz7bQvSpMNG/TqkqpWzQhxPqa09BmwIIXCygH9FMXNJ36ty8vufC3jzaB2P+rTPolqIT/G+1mFbCthfjE1/YL92zTv44k4hFtnBuP9wnMI4J5PwRFziCY+pWyvlw0qF1B1+3Wjuuj4V1b0JQgPEanpJMrvl20oR1QE/EWD4nrBJO+kq0cGkRy6XY5hyxDOc3t2VOwMboY1VyCTMvbSp6FDC/Yrp3beqIZulb8QUzOgogj25fGnxmx5YwVAaajF/R0D22TN1LrGX57K5CJBRG+9Yxc1zOmYgPusCavP36t0CSkFs56V7r6RDMiUv0yaK9AxKdnr9hJATWV48KP3BmnWwuFHqlSMKnv4FVt/kBQkNybqDr8f12GxwvgW9L8QNdPhKCQpPbqVYfhq/v6yk3JaqnGMS/W/YBkScXMv9eHJwXP5+i1VVJ49dY3SMUtiQSNCzoV65S1R+m3uHCN38DvBEwXdBen6TsIOMUmpi4m5EkXjozth/7y3mnF9oe+s2JhtDrZIMdA1SLm49uHpGs1eixqc954m7FVKHnQrWBR+o0+C+oTrP5DF6P2m6959NEgPGjwht8XY2aQc99ANgKFPJ3WFHbmkyIuXe3AQAcBgLKqT4nyztRy1qGcMAEmSl6fmbpzrHJnKtPzZX2OKo1OHJWuKSfWCHHJaq01vo0sPW4FdUZEWe+tMAwWCDPRUbJmD5/c/
 ktJ9giH8
 QdBpGFT4QVWiQ486hM5oAtfIxZpJBNdKKa8nmt1Rzphwfd7oxwBwjZgJiQCNFycYTNJ/OkEPaDNHfMEGMJpaIvkUcxB26QX6QQUOq6vJ7DDUz7TOX0m0N7qvN79Y/eRneSQukO3DbZqVz0cb/pB3JIW0dGfohPm/UhVfLiG8pfz0j6rqNoJj2sGieL0618Nu76fdkJxOJYGMlq6TG+ZuMlE3qcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:

> +cc Roman for suggestion.
>
> On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
>> You are explaining what but missing the most important part _Why_ do we
>> need to have this addressed? Is this just addressing Sashiko review
>> refernced below? Is there any real usecase where the current behavior
>> matters?
>
> This is exactly the issue with these 'unrelated to your patch but' suggestions
> from sashiko.
>
> You end up in loops:
>
>         AI generated patch --------------->  AI generated review
>                   ^                                  |
>                   |                                  |
>                   |                                  v
>                  AI generated 'unrelated to your patch but'
>
> And _at every stage_ reviewers have to do _additional work_ (with ~50% signal/noise).
>
> This isn't sustainable.
>
> We already had _too much work_ prior to the slopgeddon. Now we have a multiple
> of that.
>
> Roman - I really think we a way of switching off the 'unrelated to your patch
> but' stuff per-subsystem would be useful.

I thought about it, but switching it off completely looks dubious to
me. So maybe moderating it a bit can help? Like not reporting completely
unrelated issues or at least do not report them more than once?
Even if it's only 50% accurate, 50% chance of missing a critical/high severity
bug (other are not reported) sounds bad.

But also I feel like there should be no expectations on fixing
pre-existing issues as something _required_ to land a patch.
It's always a best effort thing.

> Maybe we could figure out a way of funnelling this stuff somewhere separately
> longer term.

Yes, there will be a database available to maintainers soon.

>
> (I have I think 2 slopped fixes to rewrite after the previous what like 7 or 8
> this cycle? So forgive the grumpiness :)

No problems :)

