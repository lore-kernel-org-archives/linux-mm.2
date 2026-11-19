Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D83606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KN/V8eP4
Received: by kanga.kvack.org (Postfix)
	id A9F646B063E; Thu, 19 Nov 2026 15:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A508C6B06C5; Thu, 19 Nov 2026 15:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966296B06CB; Thu, 19 Nov 2026 15:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7255C6B063E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:03:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0535FA04D4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:03:44 +0000 (UTC)
X-FDA: 85452943968.11.2D8A649
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74C7D10000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:03:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KN/V8eP4";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795118622;
	b=XQoWYcX5A9y/qg+6hkd8GfvpCMOqigoF7JtuUZY8NDdc+pHxVtq1aD7Km9ux9Mjqte2Igp
	vLVLcZKhwPJttad9LWMDZ/L9NuN2VmA76TlsXAkJz3T14UDCAJcIj4TyiHIMQipvd49A/9
	ojH+mrC0MpeO48BqtEMmQfGktHojcHo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KN/V8eP4";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795118622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kdpYcWkYOK7qIBcGPyFrGE+aMeLsucfyxt+AVbDijN8=;
	b=Kzk7LzuGlfq5wkQfijkJ0SP+G6DhuCiwrwBKjblbJdRzkKIaBgbAc0UbFCOVuCHZC6YXyo
	gIDcZVPpS1qHxD5v733Pu6aulOjrQqmnFKU75DD5XsEvqtplSKy9xK9cuDcSROUzeRSDlH
	4wTCOfhV2TTsCTUlBURzCAbSgTtA/bs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4BB060D4B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BA21F000C4;
	Thu, 19 Nov 2026 20:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795118621;
	bh=kdpYcWkYOK7qIBcGPyFrGE+aMeLsucfyxt+AVbDijN8=;
	h=From:To:Cc:Subject:Date;
	b=KN/V8eP4q5tJkrGmCGhhLeBZxnOSMDutKAZuIwiS+Og2wHsAKijw5WOuGwrrjnfIO
	 Vi/aeTrrEEbsh8LtylKdacVoI6UxC/52Srsv+Q1QdewLatlFqCnZS6PCPIh4Xz7SD3
	 OEm+sLxGoTZ7TSpplO0r0xPVqar3wnA64K0aWN0MBRRh571+zh1Q0X1AA7AvcXtzin
	 AHHDsnqe7dVxBaQXRYXziq+BiS9Ip5f+OBXbRSHXv5OSJyqGKXEy0bqtt2ikgTAJtp
	 k+xB3iWaDDQLyhpR3M37rJpZwmu6+Kuc3VRtM5HZZDnCEpZBE+0lnU3EvbkiiqUOgv
	 LFYLS5SkBexlQ==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-11-23
Date: Thu, 19 Nov 2026 12:03:33 -0800
Message-ID: <20261119200334.83935-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74C7D10000C
X-Stat-Signature: jtoussdajbqcyyxfjpyxehirinfscd1d
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795118622-878148
X-HE-Meta: U2FsdGVkX191ss1jNNlpGcUQxsxc8kduz6ad8HO3iSDdnhdPTvuKEyV1heAR8swvmXj6PuT+srTa3Q2dA0UgF9ZgtyFRPdiz4BqoJZfd5HfCz/NYCJPimZRAbQufNn6ynXok68eShf8zJRBuyMW3v2OLhOaGhN4QcP0kLs4DrmQ3TNp1qLwD/pLWY56P656lTe71+3K0cGLY5tBMw2HWaXp5p+MgbUiWcm7E/kMGD6MX7ZPG0cqSzmXqVq5rzaCscihX1n2Tmoh9JrKDadm6Vr0x+JiMstv2LG9p+7PO57ztiUY1w8HTnv042wiCbi/8i/4u4YiTv/upvv9iSXJzbqvqieoCxLCzHf4oYyPJtAJLYLJpYOUgqN0/jr6ZDr9LExqsvw1nbMDtIiVvVfsG1IiKoO790meBP+3Q41Iy2hMwnBZuL46o2jF1BGYZ0IrDq0Bv9lOYA57wW6lWS5/kbbxxbAJHKgCh7bz7vnhX/tZkW3LFVhscZ5h0J7BXALmScGYQq+9BZpHI4j2lvQKtUGK2OPS9HSadb8Jyw6sY3NmfWa6Yf4TYwZ7KWJIjhvqxpPuPtKqKA99YbxOnGC6Y5FqFnH6m1dfctuB2CQMIjGc30I1adlcYBr/UXif1tmswF3l5iym0oSdOQvdVWk69J0TL3GqTICQpxA6IOdJQAYaQku7b9GKV1fz126Q69nEW6PPFYmy4xmO2Nun65GkJWhNXeZaAsJsV9aCfXKD9L7NxhkBHXijZafKQoWGkkOzZcrV/03SiYYWvGdYPY0XkmCxmswBb++Zt9orqyYcvgDC9e4OTV3D4Wd/q+Kn/yfOCnaCRx9CWCshrqpAeBkSe7uQKrPTdwSZBGVszt4aoePTP9WMagwg0XeQwGwGPS9XC86++HRu2kLp7Z6tCnpydWwZp8zc+VTQNXuEQd9z6I73dc0UfsWnB4G/McmFJAFdT6yI9BD2feGVDah0Xzrt
 ZyiNdim5
 5RbZJD+jfIELcK6ulW0FzQj+ombfKwD99ao0gGjufCdpHnOBmq8Cj0NuruEbt8HpP0v5vH2W72kVFQOqSJAEiNRqk+JKp1itdYGAIIU0HnKCkpSFXlLBUbMCc0Lrin686ZnsqQGbPoAoQ4P6sF8lc3+RQX7RMrW7no0lkwnsDqubX1Bm41A+xxtFIIxdczw03Avs5pQSM25hUpLbhSHewEiOzECK1EsN234hy/57h5gzAa27KwiLuZohWKtQs/vEJa+bEA62eEVFFLoSg57MhgwHpPy1NeMLA7xeT9aSfPXOdqh5bquqo6VLclDBQK5Y4psMhY5knPUfD0BcjDnblfGyMug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-11-23.

As usual, we have two time slots for meetings in the week.  Next six time slots
are as below.

2026-11-23 (Mon) 18:00 PT (reserved)
2026-11-24 (Tue) 09:30 PT (not yet reserved)
2026-12-07 (Mon) 18:00 PT (not yet reserved)
2026-12-08 (Tue) 09:30 PT (not yet reserved)
2026-12-21 (Mon) 18:00 PT (not yet reserved)
2026-12-22 (Tue) 09:30 PT (not yet reserved)

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

