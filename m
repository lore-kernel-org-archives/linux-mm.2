Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088D4606D2DF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYYdTd3y
Received: by kanga.kvack.org (Postfix)
	id 0BDE96B05C8; Tue,  3 Nov 2026 09:53:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096406B05C9; Tue,  3 Nov 2026 09:53:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7D66B05CA; Tue,  3 Nov 2026 09:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C09306B05C8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:53:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49B20120450
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:53:29 +0000 (UTC)
X-FDA: 85394101338.03.0BBADED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADE3E1C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:53:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYYdTd3y;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lN6/UyH0yVLzdc/bLBgkSFZGjwZsixPue/fM7Y5QUY0=;
	b=D828mkd/45jORNceEFIP7aKcuzMajWLVK9olZE76aOrONwDc/GjLhOVZAs/Op5Kq1K2yZe
	vmhG+MFRAlhZhrAY7lOGF3smUftccXLyqgqx6DLjMu7ocV4dgDgPyAlG7cS4kG9gb9DgJ1
	ZB0dfjNcIU9u8cbySVJWL7/gMaLtBnI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717607;
	b=vz2gtSVni8P9prh0oTCE2ZZtwOy9skQpn8/kLwjUHsbt62gcMOOtQKVyxgzYK2gl4CVVbC
	E4Fvk8X/ibHbqNTi6UngpQuHBoANIzI0Wt/YbAa+Muz0ZCnVYvH/sbbUo2iGmlPP/RzLVE
	bp7hiibcnUnQ00FHTjLGoMGHc6lHv98=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYYdTd3y;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B9D5600D1;
	Tue,  3 Nov 2026 14:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A981F000C1;
	Tue,  3 Nov 2026 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717606;
	bh=lN6/UyH0yVLzdc/bLBgkSFZGjwZsixPue/fM7Y5QUY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYYdTd3yhf0Ql88uloJlEQjPcAm7611vv1CFkAKOfqBFmbVpxeh9LsD99MWBK+VzC
	 OTpRXC1CN6sr6UupfqPB8Dy0keYYoMs5/g26kF6OFpSZIZqFJHwm8MO9VOqRGFgDCg
	 VVLMCUILiD+R0uZKD3Hwgs3o5X5av5i/QHt7hxHnQBzzLKlzTu84Ay+D0919U8SpMW
	 M2K9awzSTViN8Gyyn/rFkUVHJRhLMOhsF9vGZb46MZvW0M87tljXxuJyOwxO7LL4MP
	 yAfsdutiziA+UHsCoG/mAvMCElgOWGh8Q9yykv/lyasFQY609cIEUIHGXNLfj2A+Dt
	 QrbTm6eiwKQjQ==
From: SJ Park <sj@kernel.org>
To: "Xiaolei Wang (Kaihong)" <xiaoleiwangxiaolei@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	error27@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/damon/core: reject empty access pattern intervals on scheme commit
Date: Tue,  3 Nov 2026 06:53:19 -0800
Message-ID: <20261103145319.88120-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103105418.362459-1-xiaoleiwangxiaolei@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wnwq74z5w4dgedkczhznu6yp5gppko3t
X-Rspamd-Queue-Id: ADE3E1C0005
X-Rspam-User: 
X-HE-Tag: 1793717607-547046
X-HE-Meta: U2FsdGVkX1/HovenHAAEAtRGqcp2Ek2FobiO8wcN5s4ErN+gJbS0Uwu/wVp1aelHSLAdy7Beve2fblVnTlK8d+Sawv+7ZWikUxfB3QppliL6Q8B7WZ4Q4xUr99HauldAuALGhB/A0E5tQ6r06+3vGZqK7ad4AOscwUd3ORdEGf66NiJwKIk4wKc/FlPaZwPP1LgFwr31MdRikVv5aeXI2JNrevfD6KPRxbr8TYv5YEG2dlfq4+IBWdSR9wfeIPcfK8wZMdKeeEkgsDJGCDXoIIU0JYOAx+32evd8bQtCLqgl1FBSdXkrrC27gxMGI3SG+TiwKxQ0NTbI4VCJBkm7GSlp75Nj75dYkbJMsrSBZlhXjJbNijNmR85JshYdnw+FXtQmHCd1XEtSwRIkpLyVHesvJXmX8dMyQnFrYW4HEe8oHvWCIkOSwG1tcL82MhWcmT60Bobid+hJxCLWYKrPwJu/2l8OsA0QeAJr7NxXEiMCcNOtmldUf4xeIohhHxR/y0hZXeplGw4Xa2GKK81qXmnXYvpY3I/25MRKo73m2hFRoGcHPon8Up8t8yz+54Cv94FYhiyFUYIHK6tzbJryhHHe5jCZutKrJ81Nr/r1yEpw256A8J2BvfZbok/trgbrweGlWueA+n9uf0TuffI6aAqwu1x2gActJzp7y9O1UfpClGMrb90iK0sdgoH53wxjwhYxKJ/kiDG1uRc8Km759qg9m12n3UBa5pFty5z2Q7F4U+SkGg/gbjlpqn9lnxJNCVJWS4Xs/URh+Vi14RV0P5K+y2o2SRLuhMe2OHTyq6JRB2muIs/lK/BXnMWYBS9VlEvrPPXsEZLoDhEA8a0MEFznD/8HzE1xFEFCRdt5jouUQXihCNDTQ3j/wyca+ET9RvWVNjx8aX1UCA97cv6smsRJRQvOg4eYSZB7i8i0Ux4AJ8Krja+YqawRTv6JpbPmhi8xRRWgGh7lchHcPK8
 kBBPipXu
 yApJiVW+MU5/7AletD0RX95grq1WPlp1XyPdv+8cmb6ZRscE1IJoGpEfiYyeVoHMvqm0ZQ4ftZw7VdiVnE901Cm9RHdmgIYtVDQOyfOE/2KJZd5ewrkiGG0tW0nzFf8VyUJCHlXok1e1PdeX8nKYJ+3p1CgCwvTphnmAT7SYJMY0hDr6cMWWrptKRtwKvK1useDK9vBJpLsgD5UMDdxjs34crtoZe1vNcLvdaAH/AbBlDbWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue,  3 Nov 2026 18:54:18 +0800 "Xiaolei Wang (Kaihong)" <xiaoleiwangxiaolei@gmail.com> wrote:

> DAMOS schemes accept access pattern bounds with min > max (e.g.
> min_sz_region > max_sz_region).  No input path validates the bounds:
> damon_new_scheme() stores the pattern as is, and the sysfs ul_range
> stores are plain kstrtoul().
> 
> At runtime __damos_valid_target() evaluates "min <= x <= max" for each
> of the three pattern dimensions.  A reversed interval is an empty set,
> so every region fails the check and the scheme silently never matches
> anything: nr_tried stays zero forever while the kdamond keeps running
> normally.
> 
> With such a reversed interval, damo starts normally (rc=0, kdamond
> state=on), but nr_tried and nr_applied stay zero forever and the target
> RSS does not drop.
> 
> The same holds for the watermarks thresholds, which must be monotonic
> (low <= mid <= high).
> 
> Validate the access pattern and watermarks at the beginning of
> damos_commit(), through which both new schemes (damo start) and online
> updates (damo tune) pass.

The documentation is not explicitly mentioning about the inputs (min > max and
non-monotonic watermarks).  But I was thinking it is not really difficult to
infer this behavior based on the existing document.

If my understanding of the documentation is not wrong, I find no problem at
accepting the inputs and just behave as documented.  It might look silly, but
who knows the users have a creative reason to do that?  As long as it is not
causing a harm, just supporting it is better for both users and code
maintainability, in my humble opinion.

Pleae let me know if I am missing something.


Thanks,
SJ

[...]

