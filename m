Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0D7E668A2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EEE6B0088; Fri, 19 Dec 2025 18:22:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD566B0089; Fri, 19 Dec 2025 18:22:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC666B008A; Fri, 19 Dec 2025 18:22:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4376B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:22:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19D4F13AD81
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:22:28 +0000 (UTC)
X-FDA: 84237796776.12.144AE70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C568740005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:22:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eOMplN2n;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766186546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lONsYN2WkfJJjXNU3HQYJVjgM6WdlXWNoyxTMBUr5eE=;
	b=FkVmeb2UKLSAzlaxFADhfM+IXUW85t1cUeqTrm1YfwIUFeVbN+uZef+8CvQt0hYOZgvTqe
	m6EKfyUxX1k2rm2kFd+r2Frq510M9v0bTymrXp0R4wKASYgPuTD1sfzzp+T8TUm6NDklqB
	aZhnbL9g75vfEEe7Kt/p3/CsbEBw2rU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eOMplN2n;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766186546; a=rsa-sha256;
	cv=none;
	b=ItzAuA28VJgMZP9NuVyyBDPAKKByjVio5QE48JH5vLXyk6majACJ8dfKJaqdJ8j1rDYvMt
	MtEX8x72tEgtnRIeyr3JPsnFJ0kXX5CAjQ4EaWU14X/O8lxwI7/oIlzwACKH54qlvNALjo
	d2tNwruQt6iFYKiQW+cUGSEGMWSYyLw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E272A60008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90EEC4CEF1;
	Fri, 19 Dec 2025 23:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766186545;
	bh=Xyp7hdCasBObPpRV++A/ph59ZovCA3G04WmnXF7cUeo=;
	h=From:To:Cc:Subject:Date:From;
	b=eOMplN2nRk0XGZ92izM2nlZHQOBLXubGCRgUnXQXCFtlUNw2O9n0E9C8fRWoIpaes
	 DA+AEJgU20yGmRth4gMeUqhtyQJpRB0Fvpm6QvjAcOvqIXXjMCkyNCiSTUHdShTWM4
	 ESOoe15nMpWhNERibRBY3D/XSrTNmuKkFhrVJYoLd5F9raoaigxJls6kVe2ta7mD/k
	 IWWRq3BzemVedOI/BHRnP/uCDmITSni153yJhfFvLfi8T4Xw0t19bT9OCy+1ljp8kI
	 uSLi4JjwQQVmEk7QmeEi2dqMgP2HgaCm3nK8aKPAhNcoQSYyPsdLNbqWnsAxGShn6E
	 GxMs4R8MM3YLg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-12-22
Date: Fri, 19 Dec 2025 15:22:19 -0800
Message-ID: <20251219232219.41792-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jqncywpobxucj6bwmhiduhcmsbcpjo5o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C568740005
X-HE-Tag: 1766186546-658847
X-HE-Meta: U2FsdGVkX1/GJDzwbdN22kkHj1dCOWkEW8BgUCBB0ib/pj/LhfR9AnQUNvGQXx7jt+DJVsWhp8WnNM5+/qC/o1acizazs5/P3oB1R4W2cnXUNRYz6XKSLXEvviSpihXK2ShyhrnfEjXZd3Woh21tzHIpUhbgvp5OFmVe3PKdMXoKx1p3omViTwv9bJh022ZKMYMKIT4ZwRnUV6fYENTG2xSR6Muadv/ewgqFr7LHXMH/SDKx6TZEKidmBqknWRSvcUw3sIQ//Mr4zHieBrodlZ9TV7SERZE0rEXkb01aVJDUX4VMpnAqDWyYUwiItfIgl9OenxiOBz6MuA+9tqEBEQ06XmrDegTGmbc3xXnPclq8v7dcxAXU/zuFZpPRI8ETAf145+qijyreIs8+qopZcoHILeGE0taBpotSYfMa2hIrroga1dsgfuzbuhSozXrAkqTT1fdqj5KeHQi/XSkfGWjj6eJvfpxcXoKw4ZaojiQUq3lUfomTnhOZKy6ihdSqWmM/ZssM94eHqBQM7K7C7dl2/L8m+HlY1zwj06u7HyU/GVaqwvQIhWVtoM3cdKyJOeXjPULo6dZdEQrml6y7y4mhE3jAlA2BN3uImbIhtr9MLlhuXZermEHcWFntPJW8i7vdJhEeTW7PBp1dExN3+1NvBLr8WiX2xnS0v9EId6py7PtWdrb647eytJUp2dk9BIdvfEUA/XF8jfYh7iKTB3tEqObmWLo02lZs/0TcDu3qhVx7E1Um6yBVWenpgwBLl2aCQ4yO1lu7flOBLw+wj/F6ezNC8ndjvhfIjYWyq95gJCqbuf6tKoacEFJ+jJ4uPG1i1o0OZrLkCdF8Mv+6+vgsiVk6iGrljH6TYEXpRHqRvdXvURO1sMF/AZzvCRYLcJd2HnWFPVDAkb6VdxyB76B5Vh68Vwpq8kMwhdIExNAFKU84fYtwQ/VRnhljNfnQzC+GHSqsow4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2025-12-22.

As usual, we have two time slots for meetings in the week.  Both slots are not
yet reserved.

Next time slots including six virtual-only ones are as below.

2025-12-22 (Mon) 18:00 PT (not yet reserved)
2025-12-24 (Wed) 09:30 PT (not yet reserved)
2026-01-05 (Mon) 18:00 PT (not yet reserved)
2026-01-07 (Wed) 09:30 PT (not yet reserved)
2026-01-19 (Mon) 18:00 PT (not yet reserved)
2026-01-21 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

