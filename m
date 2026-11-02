Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7510F60771CF
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ML7/UnYw
Received: by kanga.kvack.org (Postfix)
	id 67C4C6B00EF; Mon,  2 Nov 2026 11:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E596B05B1; Mon,  2 Nov 2026 11:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542CF6B05B2; Mon,  2 Nov 2026 11:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7C06B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:53:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AB20A0143
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:53:00 +0000 (UTC)
X-FDA: 85390773720.30.1976997
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	by imf04.hostedemail.com (Postfix) with ESMTP id BBC1540004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:52:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ML7/UnYw";
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793638378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TWlg7KRBcE3RU/NzvFLK7aD5NUhim3refNRN/QiCaA=;
	b=WD6X+gIKbA1xHO4v44nG2PGWK8gFep663Fy63tvU+7enXcTqLkmpUsYQ31TwyLx1+708N/
	luiaQGbXLVA4pKGugP+Di3hJ0Cqc4itsqsRRTBdLvZ6LvwA57uq9OfY9a8Y13pwG7NqtAt
	dIHL4mO5ns0RHFiuxWlt2zB2+JmJmRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793638378;
	b=j2MdMLQ+D+Sd0/ba8da4auqfLFbZhSIJrCusrvSNBkfJsgnTtRBBcfqytWSXOSo4GS92JE
	rUd8YY7Tif+Kz5BSwQ3JFAhOoV6YQQY9pR57tgJyiJiF07cJwZ6/Kyj+PwUCjdDHf4itdw
	Sn1QxqtkctipfE+0fKCaeM8ZKTDd6pY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ML7/UnYw";
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1TWlg7KRBcE3RU/NzvFLK7aD5NUhim3refNRN/QiCaA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793638373; v=1; x=1794243173;
 b=ML7/UnYwMPEquYAY5EDZj9SNyn3NruDTdhc8P8QW/LUX4zBFeuZomybTfcUZVxNWuVE3d1/B
 yuTJem48rHWO9gzghsG5Ir68XyQRbXzdwXYitKImfpU6SmZPrj6mcMkuIxyQlUyNAp94V4QpuWR
 VxK6L7O8lQUK8qO9VejwCFXY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d321dfeaab60ca30;
	Mon, 02 Nov 2026 16:52:53 +0000
X-Mizu-Trace-ID: d321dfeaab60ca30
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,
  Shakeel Butt <shakeel.butt@linux.dev>,  muchun.song@linux.dev,
  cgroups@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
In-Reply-To: <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev> (Tao Cui's
	message of "Mon, 2 Nov 2026 21:03:05 +0800")
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
	<0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
	<32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Mon, 02 Nov 2026 16:52:44 +0000
Message-ID: <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jgdsotm8m5d7aug6th6rkqyhf7odoa8f
X-Rspamd-Queue-Id: BBC1540004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793638376-143457
X-HE-Meta: U2FsdGVkX18dE5pPAcXbMpmwsxOEh9RF0ge2YJ6cYo+TEp9n6wL1W1Rmej62XtkPBfRIzmqDQkv04azBlZi77Edlogmv95LqUTN1cp7ymI26guBVy4H5OpT2GXOwX05moM0gOjAW9tMCdtV0Mp8yY+FkeUzDsNUZhcfPKMPp1k/4A9EF8PlceAqT5UQQ42Pb+hgoQqw0O9zl0uzooLhJ8by+6Y4scIRv5MMkDCUq9i4D0xK09TApr3hE/R2DnWgvVszwuLk41Wy63XgVDIIoqjEbCO4VYNCxTNYTvxqx0c2cSf/uVjJBY42f0+1x11phODTpgCZLreujVRNqy5RIcRPHDPW9R2hI418VA3GqtAlglYsT1qmCt02asGs2ATk4WOr6GLK3qMVF9fDQQ9JUBhSzva6aYNUpr7Q1vu/OE0hzQ0wRvBMIno4GIoiiLBD3GszCy9SvLTnaUotRLMo/B7YdYGmMfBk2y93gTjeqgrfqsJQ7WJaL7DTAu96vG18f6DserpNpOwxwQNiR2QWjrH09+ZneUSzYuJIAdec86Mw8sWgds0fSQZV4UOp7OtvWIKvXTjGTSwbuLMXlgoWzCxEdJRyiah5M9MIizkWu2rlLUIzwSoOJ+b4ChXatQTQ9zAw6tIj33AXXopM7SjBcLaTZ/58RkbcLbQsyt48lpOT9CV/SlcDLCAbjnkbKIulKYV5iUehh/dfIxLEv+Ne7F2qYIRO/Pd98Ce7QZvSMLwCp1pMsADIMZ9bXMn/MRCeKMgfcQoAhi1d/PEk0+FE/3gGliIE0BOBevddJEJBBGt5MmaVfSYrYMGY8+OhovXYchdY9fh74UWLWkYoY1d/ojp91W9g9k6r4FC84oMB0gZR8rDwEDNbrPlG/pjaAVYr50BNOD9FXFJm/YJ3hCXIwuM1wvwdVU79TdqvG0dZFXX6vk69RK1dT1hozVs74krDoztySdGTJY4L0f5IoaxD
 ZTCmrTsK
 05HNcoQgxfngkRcCMnqzIuvZab/12znr7ipIYakZzcd4HkKtl++6qJ3SIYfyfDo/L31+AUDTS8a5e3/xzAaGTF+37URf5rTDkILgXs35wzWgEjkZtbXLsOhDoEGhNFCtDeQEBhL4+Niro2pTESyfNPXF2zK27yxDH0sKGhOcvKbb30in/n13QEeanN93TiCNL3Xt8vk4QrEluV3RnmbEOm3VBhPyYvUUjyHfj/7teJW3q9Odb2hWnLlP81A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Tao Cui <cui.tao@linux.dev> writes:

> Hi Roman,
>
> =E5=9C=A8 2026/10/30 14:05, Roman Gushchin =E5=86=99=E9=81=93:
>> I believe we want to delete this code sooner than later, why would we re=
write it before that?
>>=20
>
> My assumption was that v1 would still be maintained for some time
> before its eventual removal, and the goal was to reduce the coupling
> between the remaining v1 code and the shared core structures during
> that period, rather than to rewrite the implementation for its own
> sake.

I understand. But personally I don't see big issues with the current
code caused by the v1 stuff. Maybe I miss something...

The proposed changes on the other hand create difficulties for those
who use v1 and maintain some local changes or simple backport upstream
fixes. Of course, it's not a reason to not change the upstream code if
it's justified, but in this case I'm hardly convinced.

> If the expectation is that the remaining v1 implementation will be
> removed in the near future, then I agree this work becomes much harder
> to justify.
>
> Am I being too optimistic about how long the remaining v1 code is
> expected to stay around?

Well, Idk, it was considered deprecated for quite some time already,
so maybe announcing that it will be deleted in a year is reasonable?

Shakeel, Johannes, Michal, wdyt?

