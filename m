Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6238410F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 21:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890DD6B008C; Fri, 27 Mar 2026 17:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8680A6B0095; Fri, 27 Mar 2026 17:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DA36B0096; Fri, 27 Mar 2026 17:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 675A66B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:48:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D49555DEC1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:48:29 +0000 (UTC)
X-FDA: 84593182338.14.B746C1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E95C180006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:48:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cpGqXMJ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774648108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HFwZTY6MbryEOmgeCTHik2Q+bgSUGf0kRVuygV8BDJM=;
	b=aENl7nB8apNWvYHw+mnJmbmJOPN2znuK2TNMuCznOhVnWpddUewHNqx55va5bg8Xd8LszQ
	WOkdgevQw3Bb0kasdA27ck0A3rP2UtiQ97OARZy03/IsnJTbt732XPs7/Usi10vft7jja7
	H5bEbuQQR5RLS2cNMz32XHD7mgmn5IE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774648108; a=rsa-sha256;
	cv=none;
	b=U1K5IuXUk1ar4wQ5KK99UfKArTTJ4FCy35PQquyGUmT/eRMKoL6o1vVpa6dtTOazK9g19g
	UBGacpgd9tfUXhtXl71O8bZUyz33931iR8UsLUzLfzUOr1FJFNoHEtdPlRwVq76fDScx7K
	zDMz0DCg8YY+zjdNYHYslS3klsia1TY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cpGqXMJ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9120260054
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295E2C19423;
	Fri, 27 Mar 2026 21:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774648107;
	bh=tl8ay2C3Huakf+fLV5XDI+09dex+dvgCSeY25OXupTY=;
	h=From:To:Cc:Subject:Date:From;
	b=cpGqXMJ9hVBR/s9gCI/TH2aTuFd27PBHLMKF3xc9XOSKNCBFc614wOgXZLVgwwNiB
	 QdyAOG0WBYW7j8c2O+9Mj/XcJF+jbBGuT/CK6B6hEjTv/mZ3nzntvLun0d3+G70/U+
	 2j3l2BG0jMzziXyDHobDGWJPTl3bWDWea+BpMq60C0C1wekvUUORcIflKQ1t9fFq/R
	 tqjqXr8Qg074b+qNVi4iuLTMQ4q9MMXPmGil6D87Dt0f8Bs6/kkYKIUYcHhgZur+uT
	 sdb8OxMILU0Dhxi9HNt08U8/395wThoeynsJoQCcZxrZjz0VoAD0C1bCln+ZYd0p2u
	 N3u3JnnzeeqTg==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-03-30
Date: Fri, 27 Mar 2026 14:48:25 -0700
Message-ID: <20260327214825.8212-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E95C180006
X-Stat-Signature: hpujq5zk8fh19bdfr3sf98419dbcnp1j
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774648108-518977
X-HE-Meta: U2FsdGVkX1/PbaWgNTDfKAGGPMUqs35Ly4WWsY6llfmoKfqiKAJqE1JuaFTD8j/+7ET1Yx3Wp4ErrFi/DTjhDix5PNuKVTCzrUE4hH8queV9KRe3Uxe7zPFLjKTmmA1QhOq/Mq8QnZxR5UQcWYCJCN1MIK75RN05RKb+cTS4Vi3nBlJj1YMH1JccW7tduBcPrOGYXnVJk3M7AwEkAORq7jAVky5Y1t4cMbKKjYUVk186gCTLGXXhu5yNdzANSAb5NtRKYHrVRuc998JuhcjG5Xlbfq94sD/6F9GPcEtqSGPMJpJKkPeqWAFh+wC2u9xdsUyKz1qb3swiaw0tareXGmM8V6E1e/4FMrSFmy1K2y8m3L4AFYgybaB4VsvbfiaZWYcdhIpPdIPogfbbKpvc3EEVDJItFiF3dKrJVi4rNdMUohGFTkIRGYdZXzS9eG/Rt4qEylZTTCNmHcf8iT9G7H3oIJb2BwZezphDy12R5M3wvRgldix5gUaaZ6//sqqPCPJ2ecUe5QSb/w5M1b0I/NIHffX7rf8cXDdV3jCED7XrXwUmJXSdEX7u3YUpO53k+ceO4WNAw1NZ4m26y6LLS0Z3n59D2bYHrCi8IcYmeBiIuoeY3LJWdgFWXWLo2rERgK6bcFuoVbvu96R3XPUhzaS2CoX3BWQmz/V+sgMAgf7ySilevnnEOY1905vBdTeiJbs/3BZZYBHp4iEfypjvk6Ibb4IWU1zaV1I7ogAaNynURC0gQfjPE5Y5Q3CspUwA5Sp6tU8kue8wqWwzYBQfzh2WeeFWxFz50CgOO9qNkmqd1/EZyOoeMRtUj4yzlgsksdxpFGD7lwMRUNnGpy2jwpuVTNGoZyYMy6Wkca7P2JSC5CrEWRbL3CG9LaL7rFPT7E15fWcvGph7SlvafCk0oqH6o6TRRdx7XLwM/SQ3uaW0Hnh36boJpztbNpxZfXKLt0AbqY1Mz2qfrh8K2sY
 MW95OsIW
 Xp2PkNri+EQVDvxElM8RPSnrNsTI9DUQzvnjhKt2hJrRIlRYq0VJmT6PWRMavbA59pbf6YXvm+4aMshieqNqkF8/1tjwVRTNogvV/DINsAI9k5Yy7qltgp6TV+d5XoxIa48a5UC52PgswzY3mZ9q+0DnOwgpvfd3Wp2crKcfAfnoO0tAwszEK3yoNkeCWzh8VnWA2ShFNru5xylw5/rD4bTiYUECsCMbfFAwnaT3Y3OVFlRBDn15wAAEK6tOi4xt6LoFEktYx8GivVgnG1Gqmu3CO6MNCElu7x+sZvUfkLIE/PAlIjKc+4tu6xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-03-30.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-03-30 (Mon) 18:00 PT (not yet reserved)
2026-04-01 (Wed) 09:30 PT (not yet reserved)
2026-04-13 (Mon) 18:00 PT (not yet reserved)
2026-04-15 (Wed) 09:30 PT (not yet reserved)
2026-04-27 (Mon) 18:00 PT (not yet reserved)
2026-04-29 (Wed) 09:30 PT (not yet reserved)

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

