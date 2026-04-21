Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4897DEA71A4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AB66B0088; Tue, 21 Apr 2026 00:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711B46B0089; Tue, 21 Apr 2026 00:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EA66B008A; Tue, 21 Apr 2026 00:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 543A16B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:49:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C96E61605A8
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:47 +0000 (UTC)
X-FDA: 84681335214.06.61CB2F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F1783180011
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EoN5bv5m;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776746986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1DypvMNdGM5qWWCjV3GkyxhGCydomjBprjP+wUWjo2U=;
	b=wsA9h9Av7juLUF1YHJLPoLQID9LxLebx5VtL8ClkbSrnveK50pdisEXkjF+4oO97E4drk7
	CQ7UefFMYtK9b21khvflLqg8nERqHHbO+G43WBXKRWxGT0eoAuhvTA1gmb4hsD8gDuiN2h
	h00NQVro1FIY3O8ebBpOhLQt6mkmVQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776746986; a=rsa-sha256;
	cv=none;
	b=wGFEEP1agRYbVGAlU1znpE9CgFlip3yX08/2gwKirrJp0ptVMoqGDDs2jNXCpsEGnwrZre
	x5P09ChNmz/C610Bw1+NveZ71SUbG90ESszoMsTDqXKC+RIAHo+u1klQpbdcn8lFVdi2bY
	6BTTuVrQ+pcshb39854tIDB8tzLGyfg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EoN5bv5m;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A2CC60018;
	Tue, 21 Apr 2026 04:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B859C2BCB0;
	Tue, 21 Apr 2026 04:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776746984;
	bh=/7YRpBxxWTP/yjaBm581Uag7GQgE9REjtg9mq3Bzdu0=;
	h=From:To:Cc:Subject:Date:From;
	b=EoN5bv5mUda9H8D5jj2fFWRQOwMnf8esdfIh7gyJvr8yMm0hrLkf1Gymu75Lokq4M
	 4+SLnIbx8uI/5yYZNaNVouMMkY/AiMghZP4WdTxQhUPT3ObKE13O1CV7xO+CT2bkKy
	 WDhee5ZJzSv90lINkuWv+Vrqzj/tgePq1FrofnDmYzd0WU4sDfkwSMdqYegBM7S9IU
	 G5zP47aGFi2FG0weTTZUQ6dJh46E1/3F4OiHXs5DOi/OdblmbGkKSujXSvZRlHKyxt
	 YpBur7z98ZI1iHohsM2NEqOzvRg1rkLaYBkYSJxTWEGpArfAK9VEGt024w/QZSyT5L
	 YGTT200D9vKMg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/sysfs: document filters/ directory as deprecated
Date: Mon, 20 Apr 2026 21:49:25 -0700
Message-ID: <20260421044928.141388-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y1fh95b57abkk4cz49catb67qgwi75fg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1783180011
X-Rspam-User: 
X-HE-Tag: 1776746985-861846
X-HE-Meta: U2FsdGVkX19BImGExrxCykFe5llEiYTNfCSeso7N7CT5IaJUSlnDm4xjaQVpPqUaL1jBTQde6hBum6LwNwQvxwAswC8i30c8nxRQ200bwSs9Jytl7W4d5Lu3LKu0jgmLiO0aJSkjrT8KgCHkukfNr5fQTgSS8NvAnRCBtnvfNUJSVXk/VR4bQCJfAyNRhSdfqzdiLmY2wkbTMNxlEo87ZsQxINR54noHfy3ucGIyNMlo+eY1h9oJj2QZn27CtuBUtfJyFP+t2ncj6sbBTY+JsdPzaha6OycsfV4wmnA01JHZdqHJpIFG1FaaY0DvifZqmuhJfxyvV50TAyduZFos/M9dfEtjG2kAVe/93wz3J2zeSIiKDRUfUoqNvLEc7RwlVrh5r214aPkGQMKmGuSA5Rr4eoS5acy+Yl4BfSI4ENX6cx92H2DxxZXExlrl1iosmoNH7zRnKvm8D9MEEXeGi7qk1QalpEcdEUMaqyTrXZXaae4PTUqSowO1VF2316QR/bOU31I1wSlypWWS6nG9byk5MMjCFITVeWIs3pu1/pftwNsxDFpAWEjtuuRIKVNIGVQxKSa1bHHjH+TIKgmksrZh59xyXAh33wG0fmJFgknZuq9Kxj6pCTG907mhXUTlk8HIeH0Ekkpi77bz61tLOA55DkorRb/G3etKlJU0s/F8HQCODpwMl7DRs1MedCVl4WwjGsEaMIiY0S4TnsnT2ym6+TktFxeOHJXi9phF+V71npSP/3b0IvpPMagqO1L/eWq5t5ATtiDosOXh13DhJQLgrUe3vgw4kY2fGlxUFs1pxiM7HhEVE9aoJKxBQoU5LmxOGt70vM1EwQ3lSzfWkkv4lSm/WYEGgXAgzhcN1osvg6GmVZBgmrxY3TqBa/CoS22MeIY6zPNKE9b14QXOCs7RYewlUGj5AF7U6GM/AuVdX0KuEa8MbnrSEfo/0WHIdgUVUiAE675ADexbksJ
 gsbkqzBN
 YLZRi+joTOzpP14tlFQwTKHvZzuSzqZKGKRB/oZcCENIHdUpJ5D2DbOx8Rmp9lGEv17Pt9KdByE8/n8XxiPnp4ns+S7tZ2rhwlrhpU6xDIwOYKyXer0g1NVGrhp4SaviwRyFVcV0c5aGnVRB/VsWzlURCowc/MDg7gwSIjPoFzw//xinIJZ2BewBrZibqNeix/I8QL10MYJP91YE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ab71d2d30121 ("mm/damon/sysfs-schemes: let
damon_sysfs_scheme_set_filters() be used for different named
directories") introduced alternatives of 'filters' directory, namely
core_filters/ and 'ops_filters/ directories.  Now the alternatives are
well stabilized and ready for all users.  All filters/ directory use
cases are expected to be able to be migrated to the alternatives.  An
LTS kernel having the alternatives, namely 6.18.y, is also released.
Existence of filters/ directory is only confusing.

It would be better not immediately removing the directory, though.
There could be users that need time before migrating to the
alternatives. There might be unexpected use cases that the alternatives
cannot support.  Doing the deprecation step by step across multiple
years like DAMON debugfs deprecation would be safer.  Start the
deprecation changes by announcing the deprecation on the documents.

Every year, one more action for completely removing the directory will
be followed, like DAMON debugfs deprecation did.  Following yearly
actions are currently expected.  In 2027, deprecation warning kernel
messages will be printed once, for use of filters/ directory.  In 2028,
filters/ directory will be renamed to filters_DEPRECATED/.  In 2029,
filters_DEPRECATED/ directory will be removed.

SeongJae Park (2):
  Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as
    deprecated
  Docs/ABI/damon: mark schemes/<S>/filters/ deprecated

 .../ABI/testing/sysfs-kernel-mm-damon         | 62 ++++++++++---------
 Documentation/admin-guide/mm/damon/usage.rst  |  7 ++-
 2 files changed, 38 insertions(+), 31 deletions(-)


base-commit: 68f9cad2eca9a05a70ec47a90f2ae97aa2363a9c
-- 
2.47.3

