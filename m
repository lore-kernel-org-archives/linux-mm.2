Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4610CD3940D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 10:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668C76B0088; Thu,  2 Apr 2026 06:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619B06B0089; Thu,  2 Apr 2026 06:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F826B008A; Thu,  2 Apr 2026 06:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45B9F6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:59:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 931F257AC6
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:59:11 +0000 (UTC)
X-FDA: 84613318902.13.B3F8264
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 101C0120007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:59:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=odDnSH9b;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775127550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vq7+DFENBJhJMdUmmnVm7LAFeKolL3SFhuFZcJf1ak=;
	b=UuM+rnX4UdVOO367SDk9zoJWANbfVPV6BKlHJiJoUMqN2V4kX2pQ1hSRxcpx7GFmH/XG4b
	N38C/uXNZb9ktlVFE7qBKfZtxzumRQN5R5X4sYnZs6TDrO7PVW/3mq1EJoP5gVSG3ylxG3
	GeDk0VkAOG360V9xzgSQWK4Vo+jzMYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775127550; a=rsa-sha256;
	cv=none;
	b=NG/22ohXOTnBvA8OGJGYz/Ka2YhK/9DkhwuJbqonMvHTFpDc/Gwnd01tGOy4RHxcisHS9k
	mM+JFeGKbXAbFilzwoBJDS1p1B2m4PhpNiJmFeEHvvFdQYyAWy0orWpwaMRvxtLtRW/LuJ
	pce8XtCK/aVgMa+jXQyw/5gMskhLIYQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=odDnSH9b;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 667CB61862;
	Thu,  2 Apr 2026 10:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9EFC116C6;
	Thu,  2 Apr 2026 10:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775127549;
	bh=KwSgJpPBsestOjU+g41fj9B15cLIwWQH15S6UdWBuGw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=odDnSH9b7E6ukMG3v3ovytaJT0biDy3SGd5RZ0FMPfpgmV51iyNwWUGwYGPeMOpwr
	 3eAfeaa4C8cd7j3kekfN1JeJqsbsp9Vz0mrKJs4Pk95SiQ4k343dfLNxW+djSfM0Zf
	 5znUcWVFYuuRpDi1r3SiRV52wCeG/8dCSgs+UVbr5HTGACzyXD0FHrlTmJlzb2lEwF
	 D1XCB+/yqPr9wqtWPLjUNTUTJfwvrZjZ1JWVHAom2y/uDzHi2Cq6bFVZfErC1AUrvD
	 zDYpGOHy/TKWDO5YJzWRgnF0WPVp0z6ghvBfpqkQlCHeCgkyF0uIsq3QS/atSt16W9
	 +ryAG4mjn1nJA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 1/7] mm/memfd: use folio_nr_pages() for shmem inode
 accounting
In-Reply-To: <20260326084727.118437-2-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Thu, 26 Mar 2026 16:47:21 +0800")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-2-duanchenghao@kylinos.cn>
Date: Thu, 02 Apr 2026 10:59:05 +0000
Message-ID: <2vxzcy0hhbly.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: g57s6qcdoe3jrnysfmo6mafna197bmw5
X-Rspamd-Queue-Id: 101C0120007
X-Rspam-User: 
X-HE-Tag: 1775127549-111587
X-HE-Meta: U2FsdGVkX1+gPL++UiW6hTw1k/r/j1nIXSgvtjaKLdBPIVCeCIuo1I1+bx+BqSc98NnSfNiM8WGsWJuhrqi4L6GI9zEXd3HG2c9pR36OxDLEmR8WlfLSjuagnZs6zH+XqD2IERGleI8qOJu8xvzdTIN6umh1ACbxahxeOu5cy5tfR5tOt/eu+8TJplgC86CvPtu1VgBtd3GxEii/IvZVmGX4LJWAs0gJTsbhOqsVGSjpJkusYqPwVGlr9x840I7soaMQdWPHTNizDg/w9lQBiyaTaA7lEulQmybs1i5YsBZZPTNrE1iFzZV3+BzNAmhRCwR4+Dg7F+BQlgo180v8V33uU010XFcpLOQpcD6SxoYRYY8Ec1AaaDCmlV4JRboYrjb3tCBomVOB6/r+hpd/2aWq+DJTFAe43a+kr09kWnepwBPgPRbN30mP6bv8TfBQqAO5qiXW3cePFGcx9r3A+9nb1XK2p9LF9aLLrahF7SF/mWuGOMVENjefOBk5hyEoCBFHnbaAAcAKbb7M8Et8NTM+i3k6R6snyu/lE4YkJmvpV2GJRcZ8OT/jILScCX9lMnt2lpS2JHQUUJY1dKcxCNvCgBczlhryVlNN/id00t0lqB8BuUsjlg07xyq/OyaBWUq96IXiHcKcKsyhMV/OyYiGziVISDP+GtQNMlOKuJ2TW98cvLOwPcUyozBjuuxSvDVVd3/aZKCj/4IX5kwFaMkdqUq8v+IBEYevyvLKvSGb706+rWR03YDOx+ZF1aSpvqHuvEOjiEGYsYOauhJYhHCv0IpLTlkpcg4ciUD8bg84hmmlIxX6nwNVdvosdsSWm6bV1cM1K/ERtBE8+OEzuSQkCHU/x6cNG2MW8C+7xTp5yrqcRIIdg1sl0zyw2V3mcK9XuVjV6yOAQdckusKa7qsg4SJE0/dBvpGhg9+mEBgEX5pIqH0f3VbEu6J8NgLIRYFtOwzecHOFUt8V+1l
 p5IN/zM4
 EYWioShXZdeFQTx/woXJfDbGy/2ra/ML8RQbHbYXpGhQCioAaJ0IRWvPouJMI+i7L7296pURI8z9ddh2SnZ/bAIRD9D72sApICOaSili7O4dTStluLMNIO2Z1YpJVrf5kpRH0yfnWHjVznY08CpucGIWMo5qiXqX1Zn+Si83CDt+lBG2/V6LsLFIDDDyLSONMIRwkrcHNaJ6Ynrti9QjzxOSCFBB8z7oUEULrHxesTEGv3Y7dEwMzoQxilFV42VaBFHhBPp34fcSNa9ny/Ne35fWFYoliC8zijwlQoiw1fMhKOb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26 2026, Chenghao Duan wrote:

> memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
> shmem_recalc_inode() with hardcoded 1 instead of the actual folio
> page count.  memfd may use large folios (THP/hugepages), causing
> quota/limit under-accounting and incorrect stat output.
>
> Fix by using folio_nr_pages(folio) for both functions.
>
> Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
> https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

