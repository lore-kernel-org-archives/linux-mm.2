Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50597CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58AF6B0096; Fri, 12 Jun 2026 11:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B308C6B0098; Fri, 12 Jun 2026 11:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D636B0099; Fri, 12 Jun 2026 11:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98C6D6B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:05:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 344F1140135
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:05:35 +0000 (UTC)
X-FDA: 84871584630.25.53FA4C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 69E4B18000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:05:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3Bjk6Xc;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdqySyIK765/5XAxZ3yDsSGj9IMPdHvPQEL66jI/4x8=;
	b=n64EKROms2qm+I+rX4+6/LRxvc9UiOM7msNZuvtIRiS+Rls114ul02HrIUHHUW8ghRQ2Y0
	69YqZ5pZTotagw2ibZHcwcW9nY2QjhPVqSBOfMz0rjIvj9KnVoHfQIhcXaPsfjSwssNiHE
	f6UFe7WB1vLUrwFRa0k/Iyh9pcdBVz4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3Bjk6Xc;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781276733;
	b=y3DRwL4mDzBBk1CAzCqJxtIJjl6yZx0CBonYiFWvuktj6IoIfh6/nX6tHHWVsqWss8h76w
	VqmQEeJfmgNJhhTfIyXpPa8YSika7QmW6NSf3ZnUq8zbrXG+o5an2VjlDlpZZaVckVdLLD
	SfA9O1bT3/IkV57upW5x2JyeVTZMY8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A640E44333;
	Fri, 12 Jun 2026 15:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5280F1F000E9;
	Fri, 12 Jun 2026 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781276732;
	bh=rdqySyIK765/5XAxZ3yDsSGj9IMPdHvPQEL66jI/4x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3Bjk6XcazGCZB0etMaC1lMSb67pMC2hUv0CHNXDxg4+idcDpgHjuAF8mdmL/lTrq
	 420ll8cJEWP4T0UPWRG1XU7ZdLkWXksNNtFVokjx3POw5pHoVO2T8ckSq5zzhTT6EY
	 jdsIXhNLCXNP35lnsoeJq+GbObjtmWC4/qj7YNXuixuubGCM1T+/5AsOPO/JOI26Rx
	 CYR8LrWQbWwiklmjT2pga4kr440UTUocQISzMyAiEY7BO1m6iLVQg4nTQfZjL3kpeW
	 ZqQ0hO/QL3SjtG22nS2LLwpWObTA/VVup0FZ7ir4DF+OZ7oKb4T1IGprjViB2A2SCZ
	 e3QTw3/qyIuFA==
From: SeongJae Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon: add KUnit test for walk_control_obsolete behavior
Date: Fri, 12 Jun 2026 08:05:23 -0700
Message-ID: <20260612150524.95770-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260612062337.2459-1-saileshnandanavanam@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 69E4B18000C
X-Stat-Signature: potixbbifyhf5gaabsqjacqpwuxx1mbt
X-Rspam-User: 
X-HE-Tag: 1781276733-168482
X-HE-Meta: U2FsdGVkX1/kyUvwDZ2lj/8WbNn6QwmuOC+VAqXIVBWH3zUpLXVI2h1mPFQYjb8K4PwAGafN+hZcghxl9VFTQZG9ooJWwXdpV17bbaJ2aSqnZBaxK3jqp58XYMduTNb5sJNJxSZi5Sbxvt2vdaBGCSuOu3QMpqJACiuw6MeNHlS9AmDKBhTEmB5hX7fJ2aAOv0XFTgx4H2XWe4QdGsT6aiyZS5ydtYqlqKrk1jE8rUN9nmYdt73etBJR8qLO6PXJUDh1ht6rzQV4n9bIfc4K9NyCOK1Ogvd/72UVyNUGhGFyV7Yguorlk0ima4sXm5T19MP20xKhiMNsIJx7ifUdGGeGirIK1+aw/GtnveTKoAs8OVR0ofSpcJFeQf3KQeSpdK+Tl+7v4XD3yUy5O+UR2QxE/EUsThQNhp6I7aIc6j9C5vWvWrhJ0BppTtVUWEPg77a0tzB/YzplDu9TGlJtQ/ecNJu9OU7UIKbmHE9G0FLqJq5W+lbN1CPhCoFLsxxoLYyYWsCJX0OnN+SPOlx/kxA97JIvi4/LtdS5AHGMDIVZXt7Fw+M14EGzWPyq9QpgMPohv+Us6ALoCx6n67aOaVnDfD0h2VzY72d1gSLv0wSa5nrJ4/2Mh9ecbdkSRh7gkteuWdkXkyZ6rlH3kh2WUK5V3AQRPnh0b6y0kLPtFGFcFwDc6JKNeDMw/vfC7a0g1e5CkcxCSIaQLHOYZ8w8Q7yq6wXSgamNCvyn1ybXz9xQDG0EI0b5pbfhdYqBP20R7mycfJ2+j1bAs6cc+DvLZytfwb6d7J6vFIcQFpjhNmhn4hfW6mToluOskp/y+vGD4pQhJyvk+YLxdEEpSL4WkL26Jt6ywEIjTI5NYcpr3NM1NB/oDHAt8GEz3f3f+JZsnKRMhEcCw0A4htMnVDAgYczhCK65SV7M7LkRD9F4Gr7tpU8P7bHzHrvvcLgxuINQfz43KtwxPmho2PuOD5C
 A2suQ4+W
 /vyP4uDtAM0i+tQ+fBnMQx7Rp1ArmY6cBcTHcrsTLZ/hetXZY8GSO9BJwUSmPW9vCIFNEjxl58UU0DCd0hw2K1GEGP5mYsE3j6COleA+sZ9sg/KPvXDnwLZUuNjYd8eUG0Z1trUF0tP+yeetzUOTozqQNZ4wcUwFDMe45sWUc9bfT2h2+QHJePBnVfvhqazeBH8nLrMs/xWCetqiP6tzja3CMStIbu3mhNH4aYKGOLCTSKvmNIgbRqLtXfL9v6EnvZdj62Gfa9e8xZMZvJ0FWl0HdWORxYZtOCJG0V7MV4Tq5zzwvlln+2S3M+qluNQwQRQlB0uhm5lEvuxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sailesh,


Thank you for this patch!

From next time, please send a new version of a patch as a new thread, not as a
reply to the previous version.

For the subject, please use mm/damon/tests/core-kunit: as the prefix.

On Fri, 12 Jun 2026 11:53:37 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> Add a KUnit test to verify that damos_walk() rejects
> new requests when walk_control_obsolete is set.
> 
> Commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs
> kdamond_fn() exit race") introduced walk_control_obsolete
> to prevent a race condition where new requests could be
> registered during kdamond shutdown and never handled.
> 
> This test simulates the shutdown condition by setting
> walk_control_obsolete and verifies that damos_walk()
> returns -ECANCELED immediately.
> 
> This validates the invariant introduced by the fix and
> helps prevent regressions.
> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>

Other than the subject prefix, all looks good.

Reviewed-by: SeongJae Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree after modifying the subject prefix
as I suggested, assuming you don't mind.  If you do mind that change, please
let me know.

We are now quite close to next merge window.  We (mm community) want
to focus on making mm.git more stabilized and therefore ready for the next
merge window, rather than adding more changes that are not really urgent.  I
understand this patch is not really urgent.  Hence, Andrew might not add this
patch until next -rc1 release.  In the case, I will request adding this to
mm.git after next -rc1 release.  So, no action from your side is needed for
now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

