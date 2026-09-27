Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD175C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 13:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A210D6B0088; Sun, 27 Sep 2026 09:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D21E6B008A; Sun, 27 Sep 2026 09:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E81D6B008C; Sun, 27 Sep 2026 09:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8A86B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 09:05:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E32E7A7226
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 13:05:39 +0000 (UTC)
X-FDA: 85259563998.08.2AD40AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40A4E2000C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 13:05:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W9DpxoZx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790514338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oa25LE79ry5QOlFm4MMWdpvS+Odfoq8gGYf5zdJ0oxg=;
	b=cu1wnfK67RwaKAp3kAVPRHmxG5mSKUzUeNT50mmI46ORfzAKc0Tm5EZE+5sFQ8cHS/fXX/
	wwN3qNzKS+vY4gSdI9DyTiGfjqpvsFmnKIlzZMZWDHZxkNQ7F/iBZIFC064A89M+Nnl3op
	h7gwivL4Bz1EeJbDwnp0+U4WlRemhxw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W9DpxoZx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790514338;
	b=4NitExpGOr3Lmb4Mp4HnbHTfTg0vMXeedRhiePt8cf0viZUGYHlFsGrJ3ORXUkntOtasCL
	N+5eh6gLONy9em6w4nkMPVxPpbUhwHFtZ2gzhy1tY8f9ko9mtO9AQufFy8LuAGnPjQm+AZ
	PCu6rwqaucvcRrITr2vw/1dV1ETYX7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9BE560AB7;
	Sun, 27 Sep 2026 13:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403C81F000FF;
	Sun, 27 Sep 2026 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790514337;
	bh=oa25LE79ry5QOlFm4MMWdpvS+Odfoq8gGYf5zdJ0oxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9DpxoZxG6fy+HMrPslnKMmNxQHYsrLXlE7idgjRblWdGxdIDr1Zs9hzZQoZP6F6D
	 WqvXcVHNqgmfa/avRAbsuCnOzeg/bTgW6qj1NepP1S0ciypdykD38DmYM1ukofpw/v
	 HfGO2ZVZ4DYF7WgSmp+mLUqu0mNpKeRUy4VmTEnR549uK7cS+F/u/wFtfn/fhIqciI
	 u48bj2kH20JLxYmnc9KIWy53IVmr7FpmK3aP2yFUwj7fIc66HU8ENnLNIkBY3dotIk
	 bD1DXjoD5dtdBPZNkcOj8c0UFajZmyjuoexicoNz4BzR9A32Yi4+qt0sWhDtn9SIZ9
	 x+Vn2AskUvQBw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 0/7] mm/damon: introduce damos quota goal target metric complement flag (was: "Re: [RFC PATCH v4 0/7] snapshot_set_swap_area() unpins the previously selected swap device and")
Date: Sun, 27 Sep 2026 06:05:29 -0700
Message-ID: <20260927130530.60524-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: obk76m9huydgodwuyqo44n6oisu7bm3o
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40A4E2000C
X-HE-Tag: 1790514338-968203
X-HE-Meta: U2FsdGVkX1/xWEFaBu+EJfYIzHLqaU3AgAz4ZyXHCBhRp9gKNMk9AmRHm7A/DOu1ZW3WMc9Vc/e4M/RJTJF0jYboVfhHzlLCJuk7vLH2kULsTfAsAEp4nj94J42AF5LJSwSqxs67g0NMjJ4EBmidyL/9cUe5cr+4iCmoF1M73ZwXhRlSOy4mh5azV6VGJdPAeNCzfWN6qxNQXs3lfyCGgWFjVUtEEwI4UP9qUxTzQye4vdVMxyTefQwZqKvvPH47hGWKteInwPpWno22Mx0iawcpimt8praHDPmIj+y2yIoxlVscL10XnyxVHFcRQVM3qeP/NevbfMm/1wnGSYvAFyrLOgAKtQNWDg46ReWUh+3S1mlRSrMREzkVaZXLxcEDeggOKVDvP48ERV8NjxNxaGS62wt0yp01YbYTsuPcUbo7GHE613ukPKi4R3Fi28ya4tPdyWhEmwLQjyx5vLSh5ZV44ujfAn6av6J1mrKPtyIiGWGCKMZSev+j6voZazq3o5JhGgAN0o538FnYd/XNLL1TwFd3eRP77FhATB9cZ+nZwAGO/9Rev6CgaZcPrzx9UbEjf/OKRvhf2lX5NSwmLwvLW/Pjy4M9ZIuRiR/dNzxiEe4ZxlHCUMiDHf3YgEC1qN0jQHKsNHmaLI7nVOYWGPjvkO8cyDeZP7PtQ5vQic1x4VxnKOzEsu95y69jEZcJPysjAPIV8XWfMKsBAEFzRRJVEVT4zXddz1BNvKELaXPBzxeDjm2df/XrZ4o86tpvWhzGmv2ZVJv6eIcc31fES0US5Cw410gyk+Wr5zUhhXNY8rnZfHIYx3eKiqHoGh+JWutkqmddfr+rkCZjr0CBBb9rELxqxKvLt6ivCDHASiGr5MPkci0w+w6qxhh7oJma9bRVItkcEfbhKItJyxfMWbATswrAISo2abahIHWBMlOp94qohZr2CptTMEvcYjpir/c4i5fJUOpmQ2zbV1R
 bL3VPSC8
 gcLT2NDTbFk7e1azlMRf6R5IcoqNMp+oGQw+AhR9adTRLEo9G4UU1TgSS0Cfdl+FQR5BFFsOhTTBmdxC0TLW5b7Taa/88Pz6oCCXof7LxUiMTiESDj9ceVX6G0UZ3OSRq4zuxZlbUcwCn7pTY3hVzw6Y0LXw7Syi9XLeV2S4ODjeL6I2Jdeqwsnn8pbsfiG1T33XBTmNOhcMpFi4oaIrkmAJNzZ+TEa9YfsGUz4/BX9WES1qsvBD4J/WH4jHejDF1wHUNlfRnnPcG0A92w1tjply0a1JCXHh9RWfZcXaHBj3h1AzVRKCpAv8Z9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 05:05:24 -0700 SJ Park <sj@kernel.org> wrote:

> Add repin_hibernation_swap_type(), which looks up the new device, clears
> the old SWP_HIBERNATION flag and sets the new one under a single swap_lock
> acquisition.  The same-device case is short- circuited so userspace can
> re-select the same swap area without tripping WARN_ON_ONCE and -EBUSY. 
> Switch snapshot_set_swap_area() to the new helper.
[...]

Oops, this cover letter is completely wrong...  Please ignore.  My tool was
using the commit message of unrelated commit due to my mistake.  I'm so sorry
for the noise.

Attaching the correct cover letter below.


Thanks,
SJ

=== >8 ===
mm/damon: introduce damos quota goal target metric complement flag

Aim-oriented DAMOS quota auto-tuning assumes the aggressiveness of the
scheme (quota) and the quota goal metric are directly proportional.
Depending on the scheme setup and usage, keeping the relationship can be
challenging.

For example, let's suppose a memory tiering approach for higher upper
tier utilization.  One common idea for that (TPP) is utilizing two
schemes, one for promotion and the other one for demotion.  The
promotion scheme migrates hot pages from lower tier to upper tier,
aiming for high utilization of the upper tier.  The demotion scheme
migrates cold pages from upper tier to lower tier, aiming for head room
free memory of the upper tier.  Both schemes and their goals are in
direct proportion.  However, for this kind of use case, we need to
implement two different goal metrics (per-node memory utilization and
free memory ratio) while essentially the free memory ratio is just a
complemented value of the utilization.

To avoid adding too many new metrics, we are adding metrics that turn
out to be really needed for each found use case.  For example,
some_mem_psi_us, node_eligible_mem_bp and hugepage_mem_bp don't have
their complemented value version.  But it is not really difficult to
expect use cases that their complemented version can be useful.  For
example, hugepage_mem_bp use case may need a way to reduce the hugepage
ratio.  That would require a complemented version of hugepage_mem_bp.
Adding a new metric for each of such use cases could make the number of
metrics unnecessarily high, and discourage flexible usages of DAMOS.

Add a new flag, quota goal complement, to allow flexible tuning goal
setup without unnecessarily increasing the number of metrics.  The flag
specifies whether to use the complemented value of the given goal metric
for the tuning.  For example, if the complement flag is set, the upper
tier memory utilization ratio metric works the same as the free memory
ratio metric for the tier.

Note: Below is additional information that is not intended to be added
to the final commit message.

Test
====

I tested this feature using the latest version of DAMON user-space tool,
damo [1], as below.

On an idle system having 10 GiB single node memory (node id 0), fill up
80% of memory with page cache.

    $ dd if=/dev/zero of=foo bs=1M count=$((1024*8))

Run DAMOS with pageout action for 80% of free memory, but using
node_mem_used_bp metric like below.

    $ sudo ./damo start --damos_action pageout \
            --damos_quota_space 100M --damos_quota_interval 1s \
            --damos_quota_fail_charge_ratio 1 4096 \
            --damos_quota_goal_tuner temporal \
            --damos_quota_goal node_mem_used_bp 20% 0

Because the system has more than 20% node 0 memory utilization, DAMOS
does nothing, as expected.

Run DAMOS with pageout action for 80% of free memory, using
node_mem_used_bp metrics with complement flag like below.

    $ sudo ./damo start --damos_action pageout \
            --damos_quota_space 100M --damos_quota_interval 1s \
            --damos_quota_fail_charge_ratio 1 4096 \
            --damos_quota_goal_tuner temporal \
            --damos_quota_goal node_mem_used_bp 80% complement 0

Because the complement flag is given, it is effectively the same as
node_mem_freepbp metrics with a target of 80%.  DAMOS reclaims the page
cache ~100 MiB per second, until the free memory ratio (complemented
memory utilization ratio) reaches the goal, 80%.

Changes from RFC v4
- RFC v4: https://lore.kernel.org/20260927120533.50484-1-sj@kernel.org
- Fix a typo in test code (s/complementfalse/complement/)
Changes from RFC v3
- RFC v3: https://lore.kernel.org/20260923101454.5748-1-sj@kernel.org
- Rebase to the latest mm-new.
- Add tests done to the cover letter.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260919011359.88921-1-sj@kernel.org
- Avoid quota goal value underflow for some_mem_psi.
- Handle complement flag for psi goal with unset last_psi_total.
- Pass complement argument to damos_new_quota_goal() from core and
  core-kunit.
- Explicitly document no-op complement behavior for user_input.
Changes from RFC
- RFC: https://lore.kernel.org/20260918142827.85303-1-sj@kernel.org
- Avoid quota goal value underflow.
- Fix usage doc for number of files in each goal directory.
- Rebase to the latest mm-new.

[1] https://github.com/damonitor/damo

