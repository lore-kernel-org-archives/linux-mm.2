Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D101E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 05:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BDE6B0088; Wed, 18 Feb 2026 00:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019C46B0089; Wed, 18 Feb 2026 00:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68226B008A; Wed, 18 Feb 2026 00:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEF9A6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:43:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24C2B160499
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:43:28 +0000 (UTC)
X-FDA: 84456484896.06.0A8F33D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60148180006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:43:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MlOgrrIH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771393406; a=rsa-sha256;
	cv=none;
	b=fM9fyROuz9aDo8YUUu17Kp/3KZX5UBHb3tvmvuyFBMPl4ThaYmaGntcAbxUVDJGwsPMvoW
	bTV8MOt+tLfUDJyARvjYnwc2UDF0e5NvEFSsmbx2gOZd/vNugDcjAijdS0IlJNpq4SgvkD
	M/+cWF1JrkMddjiwwXBxMiyzehosy4s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MlOgrrIH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771393406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ywZgaue80KA7a5hq70O6oYe33mde14tBZMvkSb1u1aI=;
	b=u2PbPGgt1FOjg8rPdQkDQ0VNZd1e4JQ2+SWnxF8KAZLz4jZuyykpFiRRmHO2EA6X3RF8Pv
	aO0jvxsnJzhDSekyjRWgVh+iX/H5AAgTshbHF0l0jLj/SKWqWckZNfcLtZpX8JgDkLvJOX
	biFPq6DNzVx4bu0vN9ezCZp20++VhyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0199A43891;
	Wed, 18 Feb 2026 05:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF06C19422;
	Wed, 18 Feb 2026 05:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771393404;
	bh=L92QtPQXcBW0ot4moYIssOzoK2uvvCToQr0AXIabFAY=;
	h=From:To:Cc:Subject:Date:From;
	b=MlOgrrIHD8NewjsF/uGbKmrBMiZHalWWjRu4+Sqlg7XlRZEMQHTc4/UMfJUYgp4Q+
	 aZPyGRdoU2yk9mmqs8y4+PMVzPKF9L8d05e66cn4IRRovyNiVJXERHvA8xuJrxcpLr
	 SldWoAc0KCUKsGrXQzFGbuUTiY6czJrJGrn/q1Mxq7/K7fKGtRLAS+jyZ27wpSLxMu
	 /D/EK1A74L82rUruQw+Qe5opBPfoHXqIrPxMNt2u+7zik093zU6zlwI/vhwTjsGM2H
	 qgmPPl7vBozWgbGg/uObr93jRGo/PNvAECeGqujCQC9BT4oUhz7NWpMeqX5PlUp2T5
	 nhw2uAl9eDnag==
From: SeongJae Park <sj@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: [LSF/MM/BPF TOPIC] Allowing NUMA hinting faults or alternatives to DAMON
Date: Tue, 17 Feb 2026 21:43:19 -0800
Message-ID: <20260218054320.4570-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 60148180006
X-Stat-Signature: 1cjaer7kbao3moyakhqbxnt1mactd4xt
X-HE-Tag: 1771393406-951593
X-HE-Meta: U2FsdGVkX19GyvrZFPPojYBqkykMA5jvbkp6kHxfWTiqsAuYBf9PiGVTCLPH1FAzNKoqgJEkFQKtKR13pQh/ligGOdtjoLLVp6COkp2k94xbJqVjqSAl8JnnIsN9jVlumTelOevY588cImNcKzDTtXDGRBMvOtDt6kTe5h6AEvo2NZMnCUCeMoisNQZvptiruJW3w59rLAByaF/MRRMEFUCrhznnYe4YX5bIlSfDmTHXGN9jujXn6+l6yB3tEDWt0mTdiAK21R+jctx/DJ56eESNaGbTYGT1IL/K/512oDfgGYo29pF5LSpSY5jk2O+N01d/ejKFPl3OLC+2+JgYObWpr5qAI8YHORAfG+YQasEv4oLV43LkyEV5E2+RVr2J6SBB7LUhS6i6AHA3OHiNhPxv68+eIlYWFdUtqW6/ZP26YcYxrKv8sAozH+MVI5I21p6HluY3FOadxgBeefC949QqKGN5SPS4Q/5+cUzuIVnoXtZq8o2wpQPj2lTUTbWYnv+C05dwcNufaI3QZe4ghDmNbKU9MQwnLuS9Br2UakuMJCtzH9MbTGXeYI2Fa6jLXQznNUEHjeC7oxVBy0AVEfd/DxGh0OUr1/X7AzvtmWsOUa4HVYtK++7hXwlV6sIV8ZN2OJ2dCrLbkqjTIkRbkviBPpU2vTfgNyn/Wg4nJj1zeRj/L4Rr/BhQjx93GAt87faa+4Z5A+ARNaF5/vWXceH/LsgcgZbCCh9QR6INRHYR3YqodRz2MVEKpo1RRCK1VMuFxEBoXYW7Cgg0SgHATCtY0TSYPQoAdNa+M0lcKy5/XlUXKX3zMo9cEeWkfMFIzDSaFPATSN6gEKoPaaqbSSG7rzZWlZsmDAptSdNJTT6V25QbuxgoU4AwXNr+QTNAezRuWfyKJwTx0TIKJvv5bQrkWPJ/hxmWfdFiJ6lXSqsCxKC4FgFUZBTlM26eGHTdic7UaQN/y/qBT7rPXhq
 0DYbPElX
 f5Ex19YnZEWAaAhJObBK5aQMbTD+qC3MyNTgQQtdi6U7clWCXsscgTH0WchnKyQqAsm8nnR3LTUNQWNPvjw5VjyxE8g6xEQzV9/ooQj0T9NVxS+wofEQOqFDoOmo7OYi6yaz9mjPJg1tWMkxhIKj++YvvrdPacl92BIEKqh4ZIhGiF+TBZywhx/hv4HHkT5WDHkdzmTe6rO1QtrKASZ6W9vmbbbrDffqBB9G7Lq1Wh/fu8TPjeAiE4hqoRhe62hnX336kDXSxIKNVLYjOUY6c1S73QA0Nt+PZpVHhg3jXL/vJEnooNRnid1k6P055+qUOsLje04nzyXf4rl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


Why DAMON wants/needs to use NUMA hinting faults infrastructure
---------------------------------------------------------------

There are users who want to use DAMON for access-aware threads scheduling,
inter-NUMA pages migration, and fidning easiest live migration target virtual
machines (dirtying its memory in the slowest speed).  For this, we want to
extend DAMON to be able to monitor accesses filtered by the accessor and access
type information.  More specifically, access monitoring per CPUs, threads,
reads, and writes.

At the moment, DAMON uses page table Accessed bits as the main primitives for
collecting the access information.  This means that DAMON can know only whether
a given page is accessed or not within a given time period.  It cannot know who
made the access, and whethr the access was for a read or a write.  To implement
the extension, therefore, DAMON should be able to use other primitives.

We think NUMA hinting fault (or, prot_none faults on accessible vma) is the
best candidate of the new primitive, for following reasons.  The infrastructure
is developed and being used for a sort of similar purpose: finding hot pages
for NUMA balancing.  The infrastructure also works on most common architectures
and virtual machines.  For example, a DAMON patch series that aims to do
similar extension using perf events [1] was posted recently.  But we found it
is not available [2] inside virtual machines and some old architectures.  Users
of the above mentioned use cases plan to run DAMON inside virtual machines and
some old machines, so I think that's not the best option for them.

Current development status and challenges
-----------------------------------------

Hence, we developed a prototype and shared it as a few revisions of RFC patch
series [3].  The patch series is mostly for DAMON internal change, but also
adds a small but un-upstreamable hack [4] to the core of MM, specifically
change_protection() and page fault handling.  Lorenzo clearly and kindly raised
his concern about the hack in a previous version of the patch series.  David
also shared a receent discussion that could give good idea about its future, to
the latest revision of the RFC patch series.  Based on the thankful feedback
and my self review, I find two major problems on the hack.

First, the hack is adding DAMON-exceptional code into the core of the page
fault handling, making it difficult to maintain.  I'm planning to cleanup and
refactor the related code so that NUMA hinting faults infrastructure becomes
more generally re-usable and easier to maintain for both NUMA balancing and MM
core developers.

Second problem is more important and challenging in my humble opinion.  The
problem, or the question, is how we should handle interferences between DAMON
and NUMA balancing, that come from their shared use of NUMA hinting faults
infrastructure.  Should they be allowed to fully share the infrastructure at
same time?  Apparently not.  I think they can be exclusive at build time via a
kernel config, or at runtime.  I think the runtime option is desirable due to
its flexibility.

If we make them exclusive at runtime, in what extent those should be isolated?
Should they completely be exclusive?  Then we may need to make them use the
infrastructure in completely exclusive time.  Also they should uninstall
prot_none protections that they added, before they stop using the
infrastructure and allow the other to use it exclusively.  Otherwise, DAMON may
receive fault information that made by NUMA balancing-installed prot_none
protections, and vice versa.

The uninstall of their prot_none may make the behavior simple and easy to
understand.  But I'm wondering if it is unnecessary overhead and complexity.
That is, letting them seeing the faults caused by prot_none protections that
installed by the other might not be a real problem.  First of all, I don't
think users will really turn on and off NUMA balancing and DAMON multiple times
on a running system.  Showing faults that caused by others would be quite
rare events.  Secondly, DAMON is providing only a best effort accuracy, so some
of noise coming from past prot_none install of NUMA balancing shouldn't be a
big problem.  Lastly, NUMA balancing is also getting that kind of unintended
information from its past run.  That is, if I read the code correctly, NUMA
balancing installs prot_none protection to a given range of address space, get
the faults information from those and do needed migration.  After a time
window, it installs the protection on next range of the address space, and so
on, without removing the prot_none installations that made for last time
window.  Hence, letting DAMON makes some more such faults might be not a real
problem.

LSF/MM/BPF discussion proposal
------------------------------

I might misreading mm core and NUMA balancing code and misunderstanding real
concerns from the subsystem developers.  I also worried if I'm biased only to
make my implementation simple.  I therefore want to make high level agreements
with all related stakeholders, first, before taking too much efforts on a wrong
direction.

For the reason, I want to discuss related topics with all stakeholders in
LSF/MM/BPF.  Particularly, I hope developers of the page protection setup, page
fault handling, and NUMA balancing to join the discussion.  Lorenzo and David
are MM core developers and already left their opinions on the previous RFC
sereis.  Mel Gorman is the CONFIG_NUMA_BALANCING reviewer and Huang Ying made
many great works on NUMA balancing.  People who have interest in the aimed use
case of the DAMON extension should also be welcome.  Andrew Paniakin has
particularly shown their interest and testing the prototype.  Akinobu is also
working on a similar project in a different angle, using perf events.

The high level discussion topics include but not limited to below:

- Is the aimed use cases valuable enough to let DAMON use the NUMA hinting
  faults infrastructure?
- What is the shape of the change that will make the maintenance burden not
  be increased but could even be reduced?
- What is the preferred sharing strategy?  Just sharing everything?  Build time
  config-based exclusion?  Run-time full exclusion?  Run-time half exclusion?
  What are the concerns for each options?
- Is there another candidate other than NUMA hinting faults that can also be
  usable for the aimed use cases of the extended DAMON?

References
----------

[1] https://lore.kernel.org/20260123021014.26915-1-akinobu.mita@gmail.com
[2] https://lore.kernel.org/20260127064338.67909-1-sj@kernel.org
[3] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org/
[4] https://lore.kernel.org/20251208062943.68824-6-sj@kernel.org


Thanks,
SJ

