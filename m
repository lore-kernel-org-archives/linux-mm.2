Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DDAF3C991
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1B26B0088; Tue, 24 Feb 2026 10:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FA76B0089; Tue, 24 Feb 2026 10:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41C76B008A; Tue, 24 Feb 2026 10:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C067A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:36:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D77DB686E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:36:26 +0000 (UTC)
X-FDA: 84479751972.20.DB94374
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E6D35160003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:36:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHPhqRfC;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947385; a=rsa-sha256;
	cv=none;
	b=5k+UTVCNMs9Vs4i84oofpBBLi11tBLSrnHdqvTfy5aagd0HuV9wR27qtozC9+2uXDi/kkp
	c1kAGyuHl2zscP7+wV9VoDuwdhrmOIHJSasFj0h3I5JVQKPrN21fvEQSxRczK5f3W9IYRD
	fjbfl+hbjvW9cKD0XejU0qPAM/GfmNE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHPhqRfC;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YuvwBbv6W/8oddvC3LjwdIP2wGN5HXEYacDDnYDTYAE=;
	b=hY2wg8GF2oA+48ndsKdHieJA8Bsta8XzAAz5Y+y/0sV6ci+KSwpO7XGi2CjtuEWoC8vNWs
	LyoDvxP0ppgOW8zcWiXdmZvtna3rxgcQIFQyA7uXVyCAXf4YN3lpiyhX66xuFQHJNgQu3Z
	P7aRNxIoXl9qNveoc/M/s7bjmk1yBbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E589044577;
	Tue, 24 Feb 2026 15:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB61C19422;
	Tue, 24 Feb 2026 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771947383;
	bh=inPeW8Ltl8DwsLwViDuuASFW9BZ3AShy+bMVDFviVnw=;
	h=From:To:Cc:Subject:Date:From;
	b=GHPhqRfCTFoL1NJ8zbomiN7PmpKkazXiyFR9razi5rbPhvsDSVSI7Xr67qMwmjOnv
	 sc+1qKEaJDXzEx3U042Dr9s2frcMnUKFR6Gu/bTDGJ1NHTnu51D32njRreOQZCRhxE
	 /OJWmazmsDUc8UvYmzXyqEaoPZyHdnf7vRJoXvAbcrPQ79wiIDZqNDVafJo8QWZi59
	 geK0beCgY7QOKG1W4INaZ2gKJBBEmA7IE59Thvq8so5cfyHCz4vsb6eKQelFA6S71+
	 GYC6q1MXuBfgk61VWzgk6WbTIDeH54wsi2gcxxEyfInrxVfRjpAdElapc93zEsTS58
	 D6LMCgFepC4kQ==
From: SeongJae Park <sj@kernel.org>
To: linux-mm@kvack.org
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: mm.git dashboard for patches and review status per subsystem
Date: Tue, 24 Feb 2026 07:36:21 -0800
Message-ID: <20260224153622.60028-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6D35160003
X-Stat-Signature: tugj7xbipjazhmyyzao8b9m9b731ost3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771947384-654160
X-HE-Meta: U2FsdGVkX18UENN+0K0KmHMEtx9d9uslhUVnJSqpKJpBz41q0X4YIsI9AGyKiYVRVDZJnjI2Id/+eepW+qFeFNKSp4LXzOwjj1hVpVTM9PSAjDegovz68sILMg6/KnQZPmT+9GDZeXlKUKYT0wV13GZOzEb1gOzYbF6ZdAmlOp1sW+Apm9IGgBBd1tV9PF3Ft07t2i+3bbwhUhUkqMLBWSai/lXo8Iey7zCQlC9oHsm0fKxaREzkFoa6Cujsk317NE5KRZN4l96lmGbMlRwfS1WPKV84itzQ5jaql1LveUvteV+iCuYyw7r09e1DCCSdpdQwsQOzYwWIpSEicsmrhskdoJqnZODT3N7DoY2MRPX+y3uoKWwGEJyoEgesRn+x/yF2ZC1fwSKrH5dfBobFTki7AcGiHXFQo2PbUJtULn9zF8o+zeDP/5kzXIoSd+DvBul/G2OD4bp32WMVLTUkZx7Q7c463M5URWDwiF17plP92Pxb/Hcm1tsEeXPVMxOXzuIChEJz7nCVSE7m91ALluOZFD4dL/+ZnjgAYvudAEdxg1KazpmogrZZkGycYxXlJVoMYMVH+pve9S9zkonBhhkO2iq1UbEB9zsMwUDcTV/rzIB1zyIFq/RqTiu9CWgdUm5cf+7wnTzjIfkFvcwbOaedZcHwh8LoGD6asdw9tkZXLZ6NNnQ3HBRWrFwDmMaFNF5DOFAf+kJMbcxL0QteXXrlSr13APfso1tJ0w7XTbziniou/BoQfhXVHun39Pl4qO1uS4YQmaUayLjd2IR5ZOGYVOMMqdRovx48Lw+LOmSRLLlIoVNybv+esLoz042m51gQq2I6MMf5v7PbarxRYUSFiEwG4/p7DYnqOEbBp+EWuA2mBZyapIR12A8RejMRAjKaT2uF9WCiXrSueX85nfqfF1mk1EiL5yZYA53T2Tj4aEbzafb3JltkU/vkQwSordSYYQEeYyLv7Fm9ruh
 eKRIWBnd
 EuhveB07i5QxivFhfnuzD/7l/frXDgWlWk6egGrB0kHr1hw6goI6psEtlK4YR88dltQWVGGr0zCLOB5LKa4miSi5iCcGHVIuWmBG18UfeZ3Mtab6FmJDYIPtAbTPN0hAPYWoEC8ENqJFr60d87tB6nuUuddTx5BszZdm6kZUrKPqLBD+SGbcdqH7qXygEzBvKx5XYmY5g+CbK3OP5B9ge3kWEVAOwN6jcXXEiM/gN7I/5XSeMDV0vxqICKiocNWo8wIPNK37Q8h1byPDoQ/mA7h4wlJX9+DBNpj7XD0v+OUEXFkPzdhiXo+rf75tn4MbZYZS5d5ZhZmJHqAD+b3aLRbj9gITZelBJqjbzYRLGZV03E6Nd3SLv6aGVmDkvwUH/xfQieXG85QPFHpfp69fxTZL2cx5lf+OGkf9ypL1ZPK7tWv2OCQYd/v4u46YBTcwaVkh/Ve6lQoAVV5Q0rJCpO3K+/+uA3MrBWMP3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


I'm a super fan of mm.git.  Huge thanks to Andrew for the effort on maintaining
the repo.

I use it as not only the baseline of my works, but also a way to understand the
status of ongoing works.  From mm.git, I find which patches are in what stage
on the road to the mainline, and what patches lack reviews and therefore I
could help.

Nevertheless, because of the volume of the patches, it is not really easy to
use mm.git with only manual git commands.  Therefore I was using a few script
for simplifying and filtering the information for DAMON and myself.  And I
recently further worked on making it more general for any git repos and Linux
kernel subsystems.  I named it 'summary_trees.py' [1].

The script shows the number of commits in given branches in a git repo,
categorized by their review status.  The review status is defined by who wrote
the patch and who reviewed the patch.  The actors are identified based on the
MAINTAINERS file.  It first finds subsystems of the patch based on their
touching files, and then get the roles of the author/reviewers on the
subsystems.  As a result, below 12 review status categories are made.

    Author        Reviewer
    ------------------------
    no-role       nobody
    no-role       no-role
    no-role       reviewer
    no-role       maintainer

    reviewer      nobody
    reviewer      no-role
    reviewer      reviewer
    reviewer      maintainer

    maintainer    nobody
    maintainer    no-role
    maintainer    reviewer
    maintainer    maintainer

For example:

    - baseline: v7.0-rc1
    - mm-hotfixes-stable: 0 total, 0 (0) series, 0 non-series commits
    - mm-hotfixes-unstable: 15 total, 1 (2) series, 13 non-series commits
      - author/reviewer role stat
        - no role, nobody: 5 commits
        - no role, no role : 4 commits
        - no role, reviewer: 1 commits
        - no role, maintainer: 1 commits
        - maintainer, nobody: 3 commits
        - maintainer, maintainer: 1 commits
    - mm-stable: 0 total, 0 (0) series, 0 non-series commits
    - mm-unstable: 94 total, 9 (61) series, 33 non-series commits
      - author/reviewer role stat
        - no role, nobody: 9 commits
        - no role, no role : 13 commits
        - no role, reviewer: 9 commits
        - no role, maintainer: 15 commits
        - reviewer, nobody: 1 commits
        - maintainer, nobody: 35 commits
        - maintainer, maintainer: 12 commits
    - mm-new: 7 total, 1 (3) series, 4 non-series commits
      - author/reviewer role stat
        - no role, nobody: 3 commits
        - no role, no role : 1 commits
        - no role, maintainer: 1 commits
        - maintainer, nobody: 1 commits
        - maintainer, maintainer: 1 commits
    - mm-nonmm-stable: 0 total, 0 (0) series, 0 non-series commits
    - mm-nonmm-unstable: 29 total, 3 (11) series, 18 non-series commits
      - author/reviewer role stat
        - no role, nobody: 14 commits
        - no role, no role : 10 commits
        - no role, maintainer: 4 commits
        - maintainer, nobody: 1 commits

With some options, it can also show the full list of the patches in the
categories per branch, like below:

    - mm-hotfixes-unstable: 15 total, 1 (2) series, 13 non-series commits
      - author/reviewer role stat
        - no role, nobody: 5 commits
        - no role, no role : 4 commits
        - no role, reviewer: 1 commits
        - no role, maintainer: 1 commits
        - maintainer, nobody: 3 commits
        - maintainer, maintainer: 1 commits
      - full commits list
        - bf16641da830 "mm: allow __GFP_RETRY_MAYFAIL in vmalloc"
          - Authored by no role player, reviewed by no role player
          - Link: https://lkml.kernel.org/r/ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com

Also, it can show the changes of the status, such as what patches are newly
added to or dropped from what branch, what tags are added and dropped, like
below:

    - mm-hotfixes-unstable: 10 -> 15 commits
      - series: 0 (0) -> 1 (2)
        - no role, nobody: 2 -> 5 commits
        - no role, no role : 2 -> 4 commits
        - no role, reviewer: 1 -> 1 commits (no change)
        - no role, maintainer: 1 -> 1 commits (no change)
        - maintainer, nobody: 3 -> 3 commits (no change)
        - maintainer, maintainer: 1 -> 1 commits (no change)
      - new commits
        - 7dd859e3fb0b "mm: fix NULL NODE_DATA dereference for memoryless nodes on boot"
          - Link: https://lkml.kernel.org/r/20260222115702.3659-1-ming.lei@redhat.com
        - 3c0cda2b0dda "mailmap: add entry for Daniele Alessandrelli"
          - Link: https://lkml.kernel.org/r/20260223170905.278956-1-daniele.alessandrelli@intel.com
        - a51c6f1008e4 "MAINTAINERS: update Yosry Ahmed's email address"
          - Link: https://lkml.kernel.org/r/20260223160027.122307-1-yosry@kernel.org
        - series "mm: memfd_luo: fixes for folio flag preservation". (2)
          - 76ec99cfed40 "mm: memfd_luo: always make all folios uptodate (0/2)"
            - Link: https://lkml.kernel.org/r/20260223173931.2221759-2-pratyush@kernel.org
          - b6eb2bd40c1b "mm: memfd_luo: always dirty all folios (1/2)"
            - Link: https://lkml.kernel.org/r/20260223173931.2221759-3-pratyush@kernel.org
      - changed commits
        - bf16641da830 "mm: allow __GFP_RETRY_MAYFAIL in vmalloc"
          - added "Acked-by: SeongJae Park <sj@kernel.org>"
          - added "Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>"
          - dropped "Cc: Christoph Hellwig <hch@infradead.org>"
          - dropped "Cc: SeongJae Park <sj@kernel.org>"
          - Link: https://lkml.kernel.org/r/ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com

The script can also make the outputs for only specific subsystems.  For
example, I can get the counts, lists of patches and daily changes for DAMON or
'MEMORY MANGEMENT - CORE' only.

Because I find that information is useful for me, I wrote a wrapper of the tool
that speecialized for mm.git usage [2], namely mm_tree_snapshot.sh.  The
wrapper script runs the tool for mm.git branches (mm-hotfixes-stable,
mm-hotfixes-unstable, mm-stable, mm-unstable, mm-new, mm-nonmm-stable,
mm-nonmm-unstable) and a few mm subsystyems [3] I collected with my best
knowledge and interests.  I started running the wrapper and backing up the
output on a public GitHub repo, mm_git_dashboard [4], from a few weeks ago.

So, from the repo, I can find per-branch per-review status patches counts
summary [5], the counts summary with full list of the patches [6], and the
changes made since last update of the dashboard [7].  Same data is available
for each subsystems.  For example, the data for DAMON is available at
summary/subsystem/DAMON/ [8] of the repo.

I find this is useful for tracking DAMON patches that left my tree and merged
into mm.git.  I was able to easily understand their status and needed actions
from my side.  It was also useful for finding patches that I want to review for
subsystems other than DAMON that I'm interested in.  So I will keep updating
the outputs backup repo unless I find it is no more useful.

The scripts are open source, and the output backup repo is a public GitHub
repo.  So, if you want, you can use the contents of the backup repo for mm.git
info, or modify/use the tool in your way as you need.

I just wanted to share this for a case that someone is also looking for a
similar things, as I was looking for this kind of things for a while.  Any
questions and/or comments on tools and backup will be appreciated.

[1] summary_trees: https://github.com/sjp38/lazybox/blob/master/linux_hack/summary_trees.py
[2] mm_tree_snapshot: https://github.com/sjp38/lazybox/blob/master/linux_hack/mm_tree_snapshot.sh
[3] https://github.com/sjp38/lazybox/blob/master/linux_hack/mm_tree_snapshot.sh#L77
[4] mm_git_dashboard: https://github.com/sjp38/mm_git_dashboard
[5] https://github.com/sjp38/mm_git_dashboard/blob/master/summary/summary.md
[6] https://github.com/sjp38/mm_git_dashboard/blob/master/summary/full_commits_list.md
[7] https://github.com/sjp38/mm_git_dashboard/blob/master/summary/changes_from_last_update.md
[8] https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsystem/DAMON


Thanks,
SJ

