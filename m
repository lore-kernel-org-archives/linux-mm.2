Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DBDEF8FF1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE796B008A; Wed,  4 Mar 2026 10:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B686E6B0092; Wed,  4 Mar 2026 10:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98B16B0093; Wed,  4 Mar 2026 10:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 974516B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:03:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14AAF160647
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:03:38 +0000 (UTC)
X-FDA: 84508699716.26.8C791AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 450271C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:03:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJAqghuQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772636616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+SWAWnk1gAvquZZSVt/h/wJvUHN3wtyGJzvVA/4ioA=;
	b=ryH/RM0hUjtEO88o9yQm0e5BV3JvshVKBnhn+lQvjzsR++tLWsm4dVa4HnFz8YC5W/a04t
	BHx9itL9XN38Bi70bu5bKnIWp2g7lBeUkjvukZl1g9zSKVV5yierDCan1qfShI3UryyuYD
	MutcBRPLDwEqWkpQUNZ5b9k6EDg921g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772636616; a=rsa-sha256;
	cv=none;
	b=Rab7J2PuQCun2dCqUqVnINqPy+efTJfzb3QQhYPNw1LlgO59NQLZPO/W8CXfGc+aJehIsv
	0bO5Di1C0D6mY3iVG6W41UUn0rEUSj7hZREpWLkz9NsrTfID33gfsxzbfM6q09nvUxaGPq
	Y99skjjP20FgbM73SeLSaModK1VJnaY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GJAqghuQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1129144028;
	Wed,  4 Mar 2026 15:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAB9C4CEF7;
	Wed,  4 Mar 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636614;
	bh=mE040friD/D8vUlGR6SF6lCV5t9rYG9oPgW77/JY5bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJAqghuQ0TJn+SKiqRfKLM05J6MzDxoz3ubM1FnAUsKVkhZKV/rlhFG8jkc6FrLBQ
	 rVBxbihRWUo+j/hmjHxVYVU/PyIyG/lsNEyi1T4yWbleHpa1RJct0xyZ6VqTsKK8xM
	 /NtKB1W0z4N67tvUK8suaSegffaOU3yBHYGtuqI4f4x8DlVzQMT3CIUf0Ww7n3e5qo
	 MBLukmLDkYuLAHHCsdj3dHmTa0uHdqgjPUJ2K8JZjrHxGstCpXGlDftEIXBE8oNTF+
	 PAxbThpYqfTUBZSw03Qz2N96iHdBeWUf8bAfHtWR5YO8fcTq2VRcP/pD1gUKbq/05h
	 GcbgPiA8Z63jQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 00/10] mm/damon: support multiple goal-based quota tuning algorithms
Date: Wed,  4 Mar 2026 07:03:26 -0800
Message-ID: <20260304150327.172442-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3c9449c1-95c7-4770-8e06-1ee50e263db8@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 450271C0002
X-Stat-Signature: gcfracxye9b76wmmmtxqzs164uwaeuzx
X-Rspam-User: 
X-HE-Tag: 1772636616-32865
X-HE-Meta: U2FsdGVkX18uW7ExRi+J9VoPpFzg63u29sqEyaItZQCFA0SluSjO/KuTn21XrcFOVoIi+7jr88l9vu8awnW4ScYsAjWz0rMBzG4uyHTnUx8S+eTpEtBPsD5eEJQMdMK9CpQiA32eDVW3UKELvyPXdGlKUlAs8Pna4qqQXc0bTRQCgdq+urUjN/Y0X8o73OpnMfEPfcGUWPtTRf7eYaiH4EPO8wJrr/ZLp6LAfWo05ct9jPiqNRrvNHrPwFrhkYHrTOSJiXFgCNAZr53+P65PuWD+WcPY/8ebbG8OBYznECU7pEpJ7C3TItFhtiY+dx4lX53uAMC8Hio+Z8GU7E7pr30r512Z7Caur9XVoB4JUl/BStuvxf48hoU6yunbXI3RFVKswwnJiH7qsXxU5z8dwnWKEz0rVUAJOixxTGCbTHQ5NC9MFeXejuED00P968JfV7CT2ZszA0T7iTkyF0SD80sUrbYqOIuKbpnCM/BAluv1MgmVurmM/nQnq8ugqF6WVbsKitdTZogkbEME6eshSMoKmqqLn3TvzNk4uFzXKsRm8J6kSWB5sYyxXfAWmrSzR2BqpvT8zmxcft4sRz8SlZZyeUGrFbAsidrYik2mAEP2bbZr5aqprCb4v2i/tnU7w3kmegPwMHUzjTeOA1vUSOnTlAsAdIMG45mlGJ+AxwhSpfm5kvSNtYns4KJr6/4vABbo0IGYdEL+r/M8I1NfhmDJ9Nzi4s3mdJaiMBBUeP2LSukhuw5XtbQZOq3gXiZnGoJyeen7CahcXC41r3uTlmKjhqfL1JjhX8Co5l7miBvfhix0DgPhlRkD/qKD9wipwUf7eBkVOALCa4JZQPBKg+TI1JVDHzdzAO15YLKC4SCuTj7e6zAtR0qBm29737yCJqw1rLa6lFIU4AyZGhRkhf00pkw0LL8xv7FQjghVEA7EzS6HQf2vpMzCNQqAzMfxD4IoxxznSwTS8R4mfnv
 /F5QiUrg
 yKXOQsxB3ytdEdlL20eM6FCxkInWZMPKZsNTMlCtqZ61Z/JSEBQ6euGneLPzGiYn9zrQoSuJ7HkvhdKteq/m3D2vGni/T/QVfGru/dT98MWXzzAtwJT4MrWio/vxTSJB8wozmwm29bJADWBhnVZipu04YlAwZmYjUM3oY+dhhM/3d+3JOgE+2ss2Kcp/DDK6CjQVN1xyGQ7VOEI/FUTIgeet2PGfP26OIfcXB1cdN01nBWuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 13:15:29 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SeongJae!
> 
> Nice idea for dynamic environments.

Thank you :)

> 
> On 3/4/2026 7:41 AM, SeongJae Park wrote:
> > Aim-oriented DAMOS quota auto-tuning uses a single tuning algorithm.
> > The algorithm is designed to find a quota value that should be
> > consistently kept for achieving the aimed goal for long term.  It is
> > useful and reliable at automatically operating systems that have dynamic
> > environments in the long term.
> > 
> > As always, however, no single algorithm fits all.  When the environment
> > has static characteristics or there are control towers in not only the
> > kernel space but also the user space, the algorithm shows some
> > limitations.  In such environments, users want kernel work in a more
> > short term deterministic way.  Actually there were at least two reports
> > [1,2] of such cases.
> > 
> > Extend DAMOS quotas goal to support multiple quota tuning algorithms
> > that users can select.  Keep the current algorithm as the default one,
> > to not break the old users.  Also give it a name, "consist", as it is
> > designed to "consistently" apply the DAMOS action.  And introduce a new
> > tuning algorithm, namely "temporal".  It is designed to apply the DAMOS
> > action only temporally, in a deterministic way.  In more detail, as long
> > as the goal is under-achieved, it uses the maximum quota available.
> > Once the goal is over-achieved, it sets the quota zero.
> 
> I'm not sure "temporal" is the best name for this type of behaviour.

I agree there could be a better name.

> 
> How about "by_score?". For example, "damos_goal_tune_esz_bp_by_score" and
> DAMOS_QUOTA_GOAL_TUNER_BY_SCORE.

And thank you for the suggestion!

But... I don't think "by_score" is much better, because all tuners are assumed
to, and actually do the tuning of the quota based on the score.  Or, maybe you
mean it makes non-zero quota only until the score becomes the goal?  That makes
sense, but again, in a sense, that's same for "consistent" tuner.

Naming is difficult...

I was also thinking about a few more names, but my conclusion after the self
discussion was that some of ambitious names are inevitable here.  Otherwise,
the name will be too long.  I therefore picked the shortest and simplest ones
on my list, which at least contrasts the current two tuners.  I agree that
could still be difficult to understand.  But as long as there is a good
documentation, I think difficult-to-understnd names that encourage users to
read the document is ok and might even be better in some cases.

I'm of course open to other suggestions.


Thanks,
SJ

[...]

