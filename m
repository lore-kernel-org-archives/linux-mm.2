Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01EBCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127096B00D5; Mon, 13 Jul 2026 13:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BA16B00FB; Mon, 13 Jul 2026 13:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93CE6B00FD; Mon, 13 Jul 2026 13:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEF7D6B00D5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:29:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E375A0142
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:29:18 +0000 (UTC)
X-FDA: 84984439596.17.2758D23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9E8B18000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:29:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2ht2vVF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CQCu3DCXkh2E8vskCgULolMkoi8dFixsDbgG1aVFXB0=;
	b=4ksq0uHPC+YhM7dvSdUi/+hkkmaqIbqqkPDzGQAy5tlJuH03DryX59hO2IiruDxqxohQxS
	ldRnG4tAJ6+KBzUnFF60xt+h4FGClWre94xBOqoArsx18X0zL3+UUuLGLlM/eDCnZk/P3s
	HA4RdbWZI9HbmteMMC3bTkJnS4lA/4I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2ht2vVF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963756;
	b=cxAwywX9OzrOCfSQiuf7aj731+ptG8ONthks4i9rvWejYnKR0iG56yS1g4nzlEwvkELS7j
	65Vx6Q7HFm4wJEcd1T9pwmb++ER8kVI+DsQanF7vbgHZT9l5cBvDqtl05/mNQJA/a0EJuP
	pdVSMlIpLGos3dwfH2ex/sfTL0YgPkg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E09E60008;
	Mon, 13 Jul 2026 17:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C891F00A3A;
	Mon, 13 Jul 2026 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783963755;
	bh=CQCu3DCXkh2E8vskCgULolMkoi8dFixsDbgG1aVFXB0=;
	h=Date:From:Subject:To;
	b=V2ht2vVFbfFjbRdugHr18TSODgco0uJFeYKWhLEg4SFlTETu/jQcR8qQzhZeYuRag
	 4FlzDrT07LzgmlETsxYnuSckY61OP7GTcNzMwhbO6hw376HdDoZFibW6euapxtTVOf
	 HBSKY39T9hPXhA15xdHnH5V2YgXlj5XR6X/aAKA0NgUzAD/kPwxdWNYIS6bArLdNX7
	 4Lz5J5+bitv7pDVXabeu1TKGyDK9/r6sYeaOKONqI0WuRghePNqW5HyTS3zJFW2wSX
	 XdNXANpfL4830KXsGnC/KlAYwpxvOKnttXkPyWn4mBuu1eGUA8pexpxNFbH79B7pVj
	 FMncR/WPNyF/Q==
Message-ID: <bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org>
Date: Mon, 13 Jul 2026 19:29:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Subject: [Update] mm-next status 2026/07/13
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ub6rpo1ksu4hp9o8pjqh6k8t1196qq6j
X-Rspamd-Queue-Id: B9E8B18000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783963756-427429
X-HE-Meta: U2FsdGVkX19BL8vJtdENfasSOH6JDRHV3wcWGBSK6qpCv2w7Tq59p7AE9JlpcCQqqZVK5wM5BTl2zYjxiONo6lj9jYOKv1QrCVakbtELTcEcQO6vz1wtZceDBmLtBFfjrwE8YJY7R+XtJF0pBOOxGVetKX/SmkiZQvVp7TuwCVU/DVnV3HjKqrL5KFOQCUd0FzOJ+gk2YFDvONwaVkSEMZk16OVOoxTnGceuGSknvtyTPaA5oszhtggl5cT6o7z/kYN5CXft0e813A8st7PI/Xtj1+RA533o6u7c1dqbg+dhuRqx9Anc+KpTfWDMiCcrm9PinDC1C/281dbAx/YyMvQxrFQZ0w5mJEBgQBf1t8TM1/V2blgbAT1yBtSrfc69B/p+uK6NslAj+FH+jHRH+gY08ll5r283owgpe/rho0t0FcXf6wx1+Gi3IiCBhxFcIsqptydGHn/R2O0PAeIzeiz04UdZCl+GmBUKbmQPaoEq838qpT+mQhM+Fb5IyzdjnoJ/a3QyEkwApDyE1Vt8Ee9s1y6PfngvBCG1tmMVMQyAQdVdbyNg/TYkQOiMz2n7r0/2G0hI4okQE0/gS/cHehkqwP+4+DoDyJvzHV99CtDHsFL6eSD/y3F+USrLS6/CbQ8liiUfzyORcxN4a64PBv0D/5TLUuMYfocVDVkBFA9EItEYHDhkY2XpNJBaSf08O8Y5XdTjCUWa2oEcHFoUQwiuHQuuAoGYUJE9NCrIOsd2WdpibScmPnpWLkhIZA6gzJAcK2Fd5BrnJw8RYZqccCHONFAvjlMgl/GKnvsWygwZIlyK26GiqjXF1GoxWZrztu5yyU6Ng4khGpdKBSTmz61sFjgixR1vpMGkaG6lZJ3LgNNrJmUj6BU0ikzLajyUmcmGHDlU0c7mNlrVBOz319RbsNtQtPmpHAVE+WOdMhGAwYJ3xMJIT6iSjiIdnSWnHd/lhEDyZkJjmRz+ABd
 K270rhwY
 FoBJhXcKiAJLRaYyySwm/zLwZFW4x/rm3roED7p1fvz0PibCFx8RG+CqG60w9HhPDEkrlRorGZE62U0HEEjFwE0Nr9RFIp7koVapn/EeMG05R1utEo2/wLiAtDVMa9PzfFsdzEDDMxmfIW0lZ5zVot4R94o8HGsiu9b5XGBBAzjalyu2vPwlvTMoWrXbNmH6A192PRYyX2Pl6jIwA3MvOLd6kBOth1+9oJhkkh3UITeR4s70sV2e08jDMIESvOZ2pIlTB6HiJ6QW/1hSMeDtiRoAoPGv/gPLLMp66bkvOked89yccDlUetojOlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

a status update about the MM transition [1] after we had two bi-weekly mm-next
calls.

I'm sure I'll mess something up, so hopefully people will correct me where I'm
wrong or when I am missing something important.


1) Tree/branch Locations
------------------------

We discussed which tress we'll have and where they will be located. Tress will
be listed in the MAINTAINERS file. After some discussions, we agreed on the
following:

The mm-next tree for the mm-next maintainer(s)/backups will be located at:

	https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git/

For all components that we separate out and let component owners take care of
picking patches (initially memblock and slab), the trees will be located at /
moved to:

	https://git.kernel.org/pub/scm/linux/kernel/git/mm/$component.git/

Component maintainers will not have write access to other component trees /
mm-next tree.


2) mm/linux.git ("mm-next") Branches
------------------------------------

We discussed which branches the mm-next tree will need, and decided on the
following for now:

for-next-fixes:
 -> Integrates all component “for-next-fixes” branches
 -> Goes to linux-next.git pending-fixes

for-next:
 -> Integrates all component “for-next-fixes” + “for-next” branches
 -> Goes to linux-next.git master

for-test: (TBD, deferred for now)
 -> Similar to current mm-new, will not go to linux-next.git
 -> TBD if and how we'll use it.

for-linus: (TBD)
 -> Only used for building PULL requests.
 -> Might not really be required.

$component/*
 -> Patch management for branches while maintained by mm-next maintainer(s)
 -> Will be moved out once dedicated component maintainers take over


All integration trees are rebuild constantly by merging other branches, similar
to -next. Commit IDs will be stable as long as they remain stable from the
source branch they are getting merged from.


3) mm/$component.git Branches
-----------------------------

We discussed which branches component trees will need for integration into
mm-next, and how the branches will be managed,  and decided on the following for
now:

Similar structure as mm-next:

for-next-fixes:
 -> Integrated into mm/linux.git for-next-fixes

for-next:
 -> Integrated into mm/linux.git for-next

for-test: (TBD, deferred for now)
 -> Integrated into mm/linux.git for-test

+ other topic branches as required


These branches are not necessarily used for creating PULL requests. Commits that
will go upstream need a stable commit ID in the for-next* branches for some time
(e.g., fixes 1 week, features > 2 weeks).

How these branches are managed is up to component maintainers. There are various
options:

a) Have the branches with stable followed by unstable commits. Never rebase such
   that stable commits would change. Good enough for very little activity.

b) Have stable+unstable branches that are integrated (i.e., merged) into the
   for-next* branches.

c) Use actual topic branches that are integrated (i.e., merged) into the for-
   next* branches.

d) Do something like VFS with versioned branch names ... that are integrated
   (i.e., merged) into the for-next* branches.


5) AKPM integration
-------------------

We discussed how we will integrate Andrews trees during the transition.

mm-hotfixes-unstable (which includes mm-hotfixes-stable) will be integrated into
mm/linux.git for-next-fixes.

mm-stable + mm-unstable + mm-hotfixes-unstable will be integrated into
mm/linux.git for-next: similar to how linux-next.git integrates it today.

The expectation is, that once more components are maintained in
https://git.kernel.org/pub/scm/linux/kernel/git/mm/*, the smaller Andrews MM
tree will get.

Conflict management TBD, and to be learned as we move forward.


5) PULL Request Handling
------------------------

So far we touched on that topic a couple of times, but did not decide on it finally.

At this point, it seems like something similar to the KVM model (components
sending PULL requests to mm-next maintainer, which bundles (selected) PULL
requests and sends the to Linus) might make most sense.


6) MM CI
--------

Mike presented the current github-based CI that is based on the BPF workflow:
* A bot grabs new submissions from patchwork (IIUC) and tries to apply it on top
  of selected known branches (e.g., mm-unstable)
* Creates a github MR for that submission and triggers the CI ...
* ... which compiles a kernel, to boot it in a VM and runs MM selftests +
  memblock, vma, xarray, mable tree etc. tests
* Reflects the status in patchwork

We discussed that we need more CI runners. So far we primarily have x86-64-based
ones. David tries to get some arm64 runners, maybe some other companies can jump
in as well. There was the idea of using some of BPFs infrastructure, as BPF does
not fully exhaust their capacity.

We also discussed that the selftests need more care (e.g., stability, test
coverage), and that performance tests are out of scope for now. Arm has likely
some capacity to work on improving selftests.

We also talked about advanced tests, in particular performance tests, and agreed
that we'll likely need a separate test project that bundles performance tests in
the future.

The primary motivation for the CI is to make it easier to judge whether a patch
set is worth applying, reducing manual build+tests for component maintainers.

So far, no CI mails are sent out yet, but we might decide to change that in the
future.


7) Next Steps
-------------

* Start setting up mm-next branches and get the merge process flowing.
* Exercise the model with memblock and slab.
* Once working reliably, ask for a -next integration change, dropping Andrew's
  MM tress + slab and memblock trees.
* Start picking patches for smaller, well-isolated components into the mm-next
  tree and see how that integrates.


8) Topics to Discuss Next
-------------------------

What we'll cover in the next session will likely be around:

* PULL request handling
* Component branch handling rules
* Hotfixes process
* Against which branches to submit patches

Further, we'll also talk, more generally, about AI review in the context of mm-next.


There are still plenty of things to figure out. If you feel like you should be
part of the discussions and were missed so far, please let me known and I can
add you to the meeting invitation.


[1]
https://lore.kernel.org/linux-mm/3166fcdd-5f08-4f7c-a743-192d0e0207d1@kernel.org/

-- 
Cheers,

David


