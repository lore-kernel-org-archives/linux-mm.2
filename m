Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76915109446B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC766B008C; Sat, 21 Mar 2026 06:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ACBA6B0092; Sat, 21 Mar 2026 06:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3276B0093; Sat, 21 Mar 2026 06:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3836B008C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:48:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21C3C1B8189
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:48:57 +0000 (UTC)
X-FDA: 84569747514.18.438957E
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id D708A180003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:48:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774090135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iiARJZWRIyjjsKQVkSlAGCb6IVhSNWHWH/RACdDwGVM=;
	b=6mTZcYOYUExP86PjD9WgkrXVJBvfdtAmFax/asLtESdl8kzkdjxh2GEfS+GGDiYn28rDF1
	XXv9N4TT0/wjS9asqXe5D69vz5GYD5WEcsxVcQGEERTj7qSTNv9zZAISvnYwLcEAHb46kD
	PJa7qgQyDC0tSfMw64mpkGm7Qh1Glds=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774090135; a=rsa-sha256;
	cv=none;
	b=iK4RI6Lk3nyRFth7MSEHFP5blnxGqpy7d9joNwROsCNmIhheybmxjCTxi0utO0EWyiE491
	0H8ATDjVn73xqrAcenZiV5U8pJUCA8AqS9/NCRMb5hhz91zjPlAEWPkopPj4oV/cPYHnoc
	jfcD41YdwohLicVZB1kvrLjrIOTeXvI=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Mar 2026 19:48:50 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 21 Mar 2026 19:48:50 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
Message-ID: <ab53krr0y981Qyk8@yjaykim-PowerEdge-T330>
References: <20260320170313.163386-1-youngjun.park@lge.com>
 <20260320170313.163386-4-youngjun.park@lge.com>
 <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
X-Stat-Signature: 5dgi9y8mcb5zax9fqxzpyiiz9t4kd99q
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D708A180003
X-HE-Tag: 1774090133-494329
X-HE-Meta: U2FsdGVkX1/Om18faAx92zoziCXZC5MFvBMjMhldXp92lEIN7g1beAKVWTTEv0H7I8r8CWWcSPu1JxQYwABOTr31b2mF4BdJlJDLY1lrFpCWWbji9OCxP+hEvagGqQtNtrCtq3PUCYpLHEPlx+bk/RDC49vzKvCRUV5SzALdnbTLiPRW462ZgKzRC2WgBrAvBycDL32a9jE5GZwKwwvyE4ccICykHst0g2XHYYlLsR4dSIHkujsUNzm0bxknS02KTeQkxGkObZPRlWbt4ae576VMxkBurF2Au8ARQbBDRlHtycHoiMnN03mL//ZdsHgzKPLMBig+PSay7SQaH89IQJ9GvZypWsVFNSw+aWy3G0NN+sNHhkdZGcoF70tNmvNcy6GOM+EcnBv8C0CWPbtU1OyN6yYwgDdJp6FDESSaYOfEBi0rsnUKsP597iYA/j/EKCxKBq9kgQgqjFqny1d8BADPbJnAaANY7BuTtjlgSjapUNYVMMc9psRMDZItDOtTKFRnRDe54WHa547lIZ+QKm86c2iNIXSQs7Q+6GA33vPbsyqHny7zOI6dhVwOqNY98EWoKYeKL2SNWaTQvmlWq2vvWNA58n6pDuSiYXStpgl5oOI1BI9bQfHQtWz21jCIZ8+xbhziQxMzG9QA9IH/isU5msMe9CZkKe57QiviadxaihU6QKhs+nADe7gK1PWFxrhL8W9lgs2EeUSYQdcVxzyx3NiEeKcxUEj9y73nsgjbcYsfH4qnFhevmlbGmpnbeM1mibuIDRQzYmfNY2QQyN2KlZnJjOiufu8DPEVDRMwaid+/Di+t6LMrTvHqDb28N2F5845WRrvIKQJYCl0OAb23zN7XEU0At33H3u4tKWEh038qTPIb/v2rgODZNg6XnQsWI1z8JQIlz8ZOVkDaD4QL0A+KAe+NmAJbMQpD5Lbgr/6R1jvMwPlBhv/cIbmIV4NliuuM068gO+75jJt
 ZYq8CivR
 YOxU+3/x+VwNH7OSZ8yM6WjQJWM7w1tcrWRa8DBiZ3pBCSgcFtzpbGihYz541hDnC5md4xIaMLgBhDfKO5CiLzUMiPrXlW/HfoMH9B5RGGPMHnfHmaPqVKjQwCRlFlrtEQv8k6PQ6A2PrGsShKAKiaHZvriE9xcXa2TlaZp84NGRePbRNneYl45SmKDXPuyU3FGw5jvnVtKymrtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 07:20:24PM +0100, Rafael J. Wysocki wrote:
>...

Hi Rafael,

Thanks for the review. Sorry for the back and forth on this one.
I'm preparing to send the uswsusp GFP mask fix separately as you
requested (with _nowarn rename and lockdep_assert_held).

Before sending, I wanted to check on the approach. I originally
found this WARNING while testing uswsusp and thought it was a
localized issue. But AI review has kept uncovering more cases —
first SNAPSHOT_FREEZE + snapshot_release(), and now
dpm_resume_end() when dpm_prepare() fails. More callers than I
expected use this defensive restore pattern.

So I'd like your thoughts on the approach:

1. Introduce pm_restore_gfp_mask_nowarn() and update each caller.

2. Remove the WARN_ON from pm_restore_gfp_mask() itself, restoring
   the pre-stacking no-op behavior.

I'm leaning towards option 2. Defensive restores are an established
pattern in multiple paths, and warning against a legitimate no-op
seems counterproductive — we'd just be playing whack-a-mole with
_nowarn conversions as more callers turn up.

What do you think?

Youngjun Park

