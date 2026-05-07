Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC99CD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 08:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B8B6B0088; Thu,  7 May 2026 04:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C486B008A; Thu,  7 May 2026 04:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942586B008C; Thu,  7 May 2026 04:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8246B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:28:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E7771C0CF7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:28:42 +0000 (UTC)
X-FDA: 84739947684.23.8FD23AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 46980160007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:28:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GiI/PiTn";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778142520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3tHHKgRRGZ+TgJg8oaaIkl0BU6v/Rx5q4nhwOmHFD5w=;
	b=G+ds4vI2iiN75cHMaDlD+vSSZg/0OOEWlHJPoyPTKjntAcFsfCAf2qyWK5175x5u0shPyO
	nhHGesFAW9lrlzUTq4d1ihmS9R5tUF85nGt0SaGH+9pcV/yLkYs8TPVOCElSW7p4zx3CjL
	kMPl7hkCA7hoXc2TsF3cJTFFak6yxWo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GiI/PiTn";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778142520; a=rsa-sha256;
	cv=none;
	b=b98jYGcOGMFSvfNEORwm4a/yNgNCX9cXDZIaNeJxnZJMl3tV+e5My+j1I6V+dZ1fRavRbh
	jKeBEb8eTNI4Qc3SW2TXfKrQPTTULRd0wHd3QJEtCBEfugYOp5pT7/4gfUUg1igM35hxiA
	kQ7uUMq/k83MxohzTYfcBPUJ75jImbM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1895F43F1F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AAEC2BCB8;
	Thu,  7 May 2026 08:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778142519;
	bh=xqpklrbR7ieOioYxjh3NJq3SfZb9K3qd09ghWsrlIVs=;
	h=From:To:Cc:Subject:Date:From;
	b=GiI/PiTnczInMT0qlaXy8HZLF9uhsvAR8n9NhWOlmwQ+7XLrc1TCmlcn0zBF14cOB
	 IsmXOonkLVHJhjvvOD1iUMn9FtqSRQ3Vi4ZJ75xLhlB3XdvaprO6rxfqm1MGy4inE4
	 9SKVt4RRQPWdFerd6z5uGbGqW2VbJtqkNggnuziQR1NA/hQ+NPoHJlR95HrYpRuxLV
	 Mxh2uTqIo6+u4mLGZ1X9CKVcOJzhgBZU4LKftR+vS8L+Bs70Qnuz7+erAe/1oUVjW7
	 F85KcBnH2vtk2P0QFZNNpBm5RtuoqVYppJkEScEvlMoVTnGoF2W1BBKezYg3cGTIyt
	 s+zqLLRAHCVWw==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-05-11
Date: Thu,  7 May 2026 01:28:34 -0700
Message-ID: <20260507082834.12043-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46980160007
X-Rspam-User: 
X-Stat-Signature: cgofnbncrdibfjhzmej18r8z3fe4efci
X-HE-Tag: 1778142520-226390
X-HE-Meta: U2FsdGVkX1/KKN68osYbAuTePcPNDi3EB7W2cr7+hmUlXLCbGXu1A3+kIAhIGnTCe6bGWPYG9wx0pXUbLhT6bM80Jxk0HMC0Wwo5JJKmYGE5oOk+hhX8FGeeElXuVcfmniTeg5FAsMidYLhK4MauFCEyfSUF+2GYezIwk9IDyFLTjjWMdiU6PWyzkKDV/KcfQigj0a6zqluNv+Gm02y23wBgK/h/1BY0R5KAPZwMsG0G7+zCFj1j5lmmwmRo6zMXt54tWOirj/HNIuzFfZ6KnNWY49Hg+TdhYsMyqE3B7fblmcCtBb8tBVbxgcQwCtw1UjrQqW/LWRPbB+/v0SKH3uKHG0wXuNEE5ER2DPq0Iemj6OIO2iuAV+4ZsLcfHaG2z8Sw7Oy+oVEw/1pPX2l0h0mGKNJS8qkj4Qml8kCOPpf/zpuuLtjdmUdxeKlHNkpXzwN/orQwiAY8RnWsdKrRpeNoSxiYmIsj0Z7OAOYwW3JweAMk0/tBeItfVmI/srI7svWSNliV2aOdk6mlQXQjWWTCWcUsNKHpCPqDCYThDBDv0IQvhSyH1wg1bZprDZYnzsngRl+QHm5vCjOxBxjPenT5wSPUeUCwOhPykv04mBAlb1qB/VBTexE1FG8QDP21MsnLQxM7oFMUrrEe02iI2cg87k4NFO/0xs9hdsRmx2YilnKem04qBx1y5DZmlRwnDVD/Gnly6hgq62vDUTXVYN7eIXGlA+j1V5/MWpOZvyUVlD+kmoIxAISTfqlKWU9zQUh40jCE/7FFpN3L9h62o1vZ8KQUfy8lKIrQjA6vnUJh7tuIS1fxRsKxp9/l5KfOuuUGyQ4Eee+/iU0415c9pOICE8ztuuZ/ayFEMNrifpRLUP/Mniwt8qZg1flziB/OnL2+5Sx0uF8Wtp5BB1n6kQH53BCObD2zThoXi0ecrLSYkpC88gFpd1O5Pl7sonkozmj+uKW1ybSfZCsWpSk
 gGp5zBUr
 uHG5BSVZX069MyIosZbCmwb/07U8iZnSsudGR8apWs1+6DK9yK6LC90vHVm7PFVxwhK4WGEfyCFNK3SEjojNz6GIzwxJYafWOmfXnrJvqwvhIsNSgR23UBr6EdeaearvXbbiYqVYS9m6zIbz3u++F16LMfk8feg202flZGbDqm0vKT6bPhB3clb+sVfEX8WYY9MBOEQ54nqs18amMYNFqEBPnHu/le5Dh+AO29oDjNnnjrOkmMK4zFQobZDAapYEjXFQZ7toMHfQgnSZ6X77+TZE+dG8mdGEq4+1WObOd4YbQo7j3QimqOK+DEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-05-11.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-05-11 (Mon) 18:00 PT (not yet reserved)
2026-05-13 (Wed) 09:30 PT (not yet reserved)
2026-05-25 (Mon) 18:00 PT (not yet reserved)
2026-05-27 (Wed) 09:30 PT (not yet reserved)
2026-06-08 (Mon) 18:00 PT (not yet reserved)
2026-06-10 (Wed) 09:30 PT (not yet reserved)

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

