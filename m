Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD87C54FCD
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 23:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E026B0088; Wed, 29 Jul 2026 19:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E546B008A; Wed, 29 Jul 2026 19:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7374C6B008C; Wed, 29 Jul 2026 19:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6366B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:58:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD60FA1C72
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:58:49 +0000 (UTC)
X-FDA: 85043481978.29.B9FA351
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4246840009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:58:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B48pzRbH;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785369528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lMG9XAmDUxsCuNndcn5JjDOaQZspMJ2xjW59i1csd0Q=;
	b=YRDZd1UG0mSuHWzyVgRmmKOD8Fr5sbL7e/ag73LI84pxl/Me7wfs4tVDifaTruRp3SoIdp
	nF5kKHohxSpwE/a/YBWLthlmqa1JJPpBUwucmhZbH6/WOPvPkoKF9FntvkcNjDWScq7un/
	IpdF+V6YCXdeEAEsYNzJkTdrBd27nt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785369528;
	b=eVYHsA2LlM6vIeNSgaSR4uYePLI+FQtdrcfp5XL1d1ipHPgJFdkPjD8dePL/Kh71BENOhQ
	P4X76FpSN15eqVCRRn9ybfwQNeeUA9RMr6YLO/fo7HdYlL9mfAGiQn1LITSf5XivqDbOI1
	h0lOncPA/blIU+CPFFeCvgMGhYfEOrg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B48pzRbH;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 696AE600AA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015B21F000E9;
	Wed, 29 Jul 2026 23:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785369527;
	bh=lMG9XAmDUxsCuNndcn5JjDOaQZspMJ2xjW59i1csd0Q=;
	h=From:To:Cc:Subject:Date;
	b=B48pzRbHUb/BDUQAljAcXJt9sU1hRGh2m+Em5JJJA847HEgPOQLaE6+Bm4+6MgqB0
	 geqEqVD32hBbQcvpciP2W1DkhuSJOnRkEx+qdEEIFLZxrfzfhiqWdYXYF/2O6pMS0z
	 +AuwddE3TcqJSDj8t9NVuOT2WkkKuQV9t3IP9sTaUDvxOdhS8XggquBBp3XFjGmiUd
	 Dr2Md6jt7kb1elj9Y38eUT6ZrAC9ciLb2wU/TnHLrTwRgsaxAg3rL8P3XtIyat8Kzb
	 fE3upX415cK8638olpgAHFuo3kqDG9E64AEulbLiXlAYm1N7opSq0uvUwKUztin1VD
	 nPwAFfz7WFmVQ==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-08-03
Date: Wed, 29 Jul 2026 16:58:41 -0700
Message-ID: <20260729235842.99360-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4246840009
X-Stat-Signature: bm94dkpc5b93311y139h3875c553csam
X-Rspam-User: 
X-HE-Tag: 1785369528-81002
X-HE-Meta: U2FsdGVkX19lF4dYtn9YoCDxSKW/IJo6Rc6h9SK1lFIia7VbXGhuuN4FEBkJ2Gsj5NDnY6C668aNwz8YeySg8sB2SkU1WGvEOIdcSv3dfsRLK6UWsQ1Zc3TZVWv2LK9GHSkQ1mcFmkkeu4hqDM6gVZ7c5HOTqzMmc70zd7awYTFLiAbUqE6oMZlbvxtbDxYIdPqGrkE1XzSdhKFXm8hjecBnsj9fYTB+CU088jEoiDjcPV7Ca5lbHYRpWaV5TVrBE4CrgomN4wgxKeSVLlCNc/2NeyQmA5kU5V2MdzUhtwGTzqNi+vY1kk6BH0G0/yHRhJiXg3cr+g6ksA2cbA//Aed0aAP9Tfk2SVemgCReH0xMlrw8lSVVDe2G3hbgfMb59J2A+rMrqTwHTH08dC6p5kCvNeIogz0Hfq6IBlL8FefVdOOYG5fUGTPzCOFrcu8GU+I8wVEyJDY2SUKgwSsmi/688mhUyYiMFEAeap9B8NOdzE3Lbz/63mPeelXVYcyk7cJ2qLO1L3UbPwFAfSbrVThQPhckptWZsQs82n7K84s4B1cJQn0SXBOSQuEivKy/pBoApuXHcdNzSDfisRwYveUVg47oBS4G0W+rHNvMNkk4dQnaOsOIAVSXOrnOnQsDmZYINQolHpubJ7+XEdeewYA2TMZbFJQcT0tI2mN+DiPdH3WVPaWR1ELF0umKziziycs2DXrDba6bi1Ew0qdqhskKb+MpGINlAExhw1x2l6+SvZEKIH/GC2xDj7susoFbTMtN4yQ3KYP7r6aF7W2koklMvPpq2ntT8JjyXByxAgM79H+bcj29hnAqt6PxkX3OwlZw/NTKxm0aJc69A5PTThDehNiUvKreIa7fsOJxJUJEbwvWy7qk+MhNURz09yjtLRa6V4LoFrdVsyC6HJoei6xXnmwL6mJV03HsrHC2vWMSSNo4AzA/9B04E8ErLByw7Whjx/Z3J1c6HSVNcTz
 bbzzY5Xc
 pD3M4IkC2wIWkA/wYyTIGXC8b/excfDByKlBZ8EeCoMr2Tj0LQYr7XST9wr/YO2ZdFc5GnhXeyyV5Bzvq6xaqYx1z6AnMJMAO87wBB+LsXnZ97xkQsbGNYHwE5iOYXPh/yqbo8/O4iRNjXkXqLZCL9rd98RhYv2SS8NCAkvghd9yT9F84KkZSc+to2VlmTT8i6u8OXZAZ1uff8J8TTNqc4VfEs3fpzaHPUvc+zskbLY0eWLUr/uu0QXyeSTbwJJYQO1d/C3MpaUEwoETTvBWVVOw8YAegwe/cjXllc46QSwLy9SixPawhu20OcIyvg3YfDUqaTfLdukLk/sAYuy1BweDXYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-08-03.

As usual, we have two time slots for meetings in the week.  Next six time slots
are as below.

2026-08-03 (Mon) 18:00 PT (not yet reserved)
2026-08-04 (Tue) 09:30 PT (not yet reserved)
2026-08-17 (Mon) 18:00 PT (not yet reserved)
2026-08-18 (Tue) 09:30 PT (not yet reserved)
2026-08-31 (Mon) 18:00 PT (not yet reserved)
2026-09-01 (Tue) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t


Thanks,
SJ

