Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA091F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1807E6B02F3; Mon, 16 Mar 2026 12:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1427A6B02F4; Mon, 16 Mar 2026 12:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E086B02F5; Mon, 16 Mar 2026 12:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4C826B02F3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:02:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD0DD1A0324
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:02:56 +0000 (UTC)
X-FDA: 84552394752.04.4213BA6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03CCB14000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:02:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vZzqMjx+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773676975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPhGdp8fS2iuoiGh9J6Zs2sMJGA6LuqofK+hwfYa/c4=;
	b=HiZaWjpZWN/3GZB4YpG8jTZlw56gtxmuWJ3PeQrFXhu55xku5dFY/FIMQRounA04knPYhn
	NEL7vpLbCpjPXtaPKoWmwWJSUxx/lyYMAUCUuJvwn8MIQe+lHkuFus1MEu4pykqZXONbcQ
	dkZZfPRWoZsnZJ4LFMBOa28IWv6/YFo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vZzqMjx+;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773676975; a=rsa-sha256;
	cv=none;
	b=y8ASwkvc8Bbgx9gJCxCM8gMzXwxxut0QkqafpROWm2pwIB7Y4gS822EOhmsyNVgzEuy4JC
	9TIpW6vob5WD7VDobxir70EEb6tJz3lGP5GQZdg8MGYrD8F3b4MaSP8mf0k8JSqNY1QuOO
	QuXnF1gcU2/4ogbJbuwjFztPB3NRnz4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=RPhGdp8fS2iuoiGh9J6Zs2sMJGA6LuqofK+hwfYa/c4=; b=vZzqMjx+Q8KfhCEsnw3DRTL4ld
	m39k9jPQmfZqhTm3Ikq3r/0OvExw8PYxYd79qiuIaC75ra3iTFpCiMEzAWx5BkH8LMInmwCYDH5/l
	NMYJVctNa7QW8e2VbCtqIXclWbtot6UU6hCgVR6/w9c4mEjLsJFIvgbBuu0rJJ9OraH+N46rfkMXV
	ued/6MZJDtNN5xGhj/ZOeCv+0W8UxBinKrBE1/G924FzyIOlbcbnbOw9XTa3ozbltP+0knw+H0o6t
	tTj6rJZSzdoSnrh7iGsvE8iQH1wVu4OSoz+RWRylJThICWqPRzygOyHTgiXrS++JK14EAblugBuGE
	VMy4q2ew==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2AOz-002E9E-13; Mon, 16 Mar 2026 16:02:43 +0000
Date: Mon, 16 Mar 2026 09:02:33 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
Message-ID: <abggyaVTdNe6n_ew@gmail.com>
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
 <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
 <abgJtJYQsGMPsTHr@gmail.com>
 <be860d86-75be-4c75-95ea-03bf79524be2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be860d86-75be-4c75-95ea-03bf79524be2@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: h94cjo4k99w9u98gd8wy1w4h4tfkm7bj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 03CCB14000D
X-HE-Tag: 1773676974-918287
X-HE-Meta: U2FsdGVkX19di393yRqX2n8qsNckCM0GrDBRJtZb0UESvmMPFMQblGSNGot5vqiczzGGLbLEIgVPlJMYgQeyMrAO25Lc2Rw/Dprtat71HH980ioe+yKiSb8aPEupfi8GfprmGpjAPY3u0+x3CN3qScPvNJGzlWzljkV1aUMbPr9UWxcN/HrNAEZPTHhwhmxZqnwfcaidYAINstbXODGnb0tTaZW+CLrQnb0+/2mFYqPD9NOEPRQ+UZ2NwfuV+Tic+NAPyEQr3q8cgxPVw0iBixeX8NYg+HNCHRfsR8VkC6ftgyy3mAVGQ0norjAmGi4pmgTiOpX2i2qnwjAy/A8EP9r+t1oG7T5JM/SlqT7Dy9DZuXwxPZDvsqsZGLzZM13EJOOc9ssrY1Gm+2OHm/xuQvQ6SU0S8Fai/KaSWW1Clljk6ZcHKmid1/RTKDLYr6ojYEcs5KvAQjASiYle+FKX3PF5U/BUkXg6Mn6iixvv3EfsndDpwBBJNfo+mZg6u6Tmsgfe31Rl4vrE5gG9k86/H87UWMuRq32vY9pnw8USgO36+ssJNxyLV9YjqHEd53mRbqjs1eQmDZuN4f9Qm6GC7y08ZPgYpNlDdl1wWMIREFK2vxK51C9HWkRYnEatB2vslJTR6Snneqx3gX+nEAlBquyAxA60iiaV5NMzW5m47x76wEKbglvmPYBcySKxlDMbuxuUKQDpCtHKSZTStUleHiF3yiOfOVdQNWSySLGG0wOLIuqpbnSRHpJ+hyyQqLef0DV3Oz5Y+eKmkLkrGNwaZyAC9E8fh3SxQ8gvN6uuVWPfiP0S4eD/mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 03:44:14PM +0100, David Hildenbrand (Arm) wrote:
> On 3/16/26 14:47, Breno Leitao wrote:
> > On Mon, Mar 16, 2026 at 12:55:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> >> On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
> >>> Add a shell-based selftest that exercises the full set of THP sysfs
> >>> knobs: enabled (global and per-size anon), defrag, use_zero_page,
> >>> hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
> >>> khugepaged/ tunables, and per-size stats files.
> >>>
> >>> Each writable knob is tested for valid writes, invalid-input rejection,
> >>> idempotent writes, and mode transitions where applicable. All original
> >>> values are saved before testing and restored afterwards.
> >>>
> >>> The test uses the kselftest KTAP framework (ktap_helpers.sh) for
> >>> structured TAP 13 output, making results parseable by the kselftest
> >>> harness. The test plan is printed at the end since the number of test
> >>> points is dynamic (depends on available hugepage sizes and sysfs files).
> >>>
> >>> This is particularly useful for validating the refactoring of
> >>> enabled_store() and anon_enabled_store() to use sysfs_match_string()
> >>> and the new change_enabled()/change_anon_orders() helpers.
> >>>
> >>> Signed-off-by: Breno Leitao <leitao@debian.org>
> >>
> >> The test is broken locally for me, returning error code 127.
> >>
> >> I do appreciate the effort here, so I'm sorry to push back negatively, but I
> >> feel a bash script here is pretty janky, and frankly if any of these interfaces
> >> were as broken as this it'd be a major failure that would surely get picked up
> >> far sooner elsewhere.
> >>
> >> So while I think this might be useful as a local test for your sysfs interface
> >> changes, I don't think this is really suited to the mm selftests.
> > 
> > That is totally fine. This test is what I have been using to test the
> > changes, and I decide to share it in case someone find it useful.
> > 
> > Let's drop it.
> 
> Out of interest, to we know why the test is failing for Lorenzo?

I really don't know, but, it sounds like ktap was not found?

Then the first early-exit path hit:
ktap_skip_all "..."   # undefined → returns 127 exit "$KSFT_SKIP"
# expands to: exit "" → exits with last $? = 127

> I agree that the test is a bit excessive, in particular when it comes to
> invalid/idempotent values etc. I could see some value for testing
> whether setting the modes keeps working, but also then I wonder if that
> is really something we'll be changing frequently (and that breaks easily).

yea, I make it very excessive, because there were some intrinsics in
those sysfs that I was gettingit wrong when doing the intial conversion.

So, the test is something that I trust now, and I found it useful when
finding regressiosn.

Is is something that will chagne frequently? probably not!

That said, would you like to have a simplified/different version of this
test?

