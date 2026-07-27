Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD51C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3116B007B; Mon, 27 Jul 2026 12:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA616B0088; Mon, 27 Jul 2026 12:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8D36B008A; Mon, 27 Jul 2026 12:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 180266B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:15:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 961B6A010F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:15:00 +0000 (UTC)
X-FDA: 85035055560.05.9294402
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id C63E71C0012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:14:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xoEYGI25;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=355dbbQDuZC4L5P9i/hhchYqs7B7Z47N1yGrWyl5gBk=;
	b=u3CUzB6ArjBH6Aktzqc4jYc7jM7tY+CpjNaCoTREQBUCDnUk67A6ViciVuwRAJGGs+X7Ks
	Lr2a4d0pvzJkXOxogAMxgbg7tcj5mPtMPjI+4OUuPBn0r7Le7v/Rg5j/YFJPGObm6Js/AL
	r20NLGO79ZLHNRT2H4zlNdVp6k6wWH0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xoEYGI25;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168899;
	b=COfebSbNcpmiebA/ViMTN3MsRGbMA1e2aMAkv5EYbxenJa6hQBUAlki7s6863rg5kyYIHu
	3IQl4xRgSKtYmYl7GoxCjd4C7X/Lkiz2q2Q9DCV7D6WFzgEN6xrJrYbXdJsOJyTcFTS1nh
	vY+5pbgO11SzO5q44+/ilIM3yDeS5lQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785168897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=355dbbQDuZC4L5P9i/hhchYqs7B7Z47N1yGrWyl5gBk=;
	b=xoEYGI25zNZeAjYWq9jaMm7XTBfNUuwUCYptdSklnWVimTPRaUo0XW8TGY6pXV9omKrL15
	zigtMYpd3o7O1e/YrzNa8JqLm5/5K+oXByhpgnHZMZ9gAm7w9GGFvFcaRmrQ5I3q0xQauw
	ZtIF+5CsITufc8XjbcVv7F+TzkiK4rE=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v3 0/2] mm: folio conversion and refactoring in do_swap_page()
Date: Tue, 28 Jul 2026 00:14:29 +0800
Message-ID: <20260727161431.13455-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C63E71C0012
X-Rspam-User: 
X-Stat-Signature: 8o1og5839re4ra3rbmcg4m5bo9e6z4ud
X-Rspamd-Server: rspam04
X-HE-Tag: 1785168898-556653
X-HE-Meta: U2FsdGVkX190hbuvb46Wyg+ScL1IbbPJlnl7OmrE9RSy0rp+mf/Eraqd6ig6zwTuhB5ItQsQy+yJW13KvfYAHLCK+rhFVsEXQeaYbdNz+kdSmpIoRbPA38n4jtP9oUE3aS8x60bVhst1i11x8Ay/qbxrqKAWRHJVTtSY0SDSQ2vXvHFzVj2gqYn4y3g6Dvah6E4ybGoVuFAXOKCxTrnLigQMuT36MHYg+thu0jF2DX9NPYrjWBAWnCl0Yo2rmqANMWLcIgF3B7t+fDf4gzo7epLpPmPAwKx2ry1vRGEIGYf4ryOvtPNvhwthSLS5BGmaIfI21KbAWBHjVOZR+VXs8sCFEVh05HEhNMGpJuhDesDaf4CZj7sX6HaHHUSIaP1u+L/RwpqVT78OyFfl6XOWm48sVPlTtcI/rMtSCXPjEbzhBYkwZyV5ctdYJKUO15TCKlU23fyIU63vJCdJizlArK/vE/uHa3ZvQ8Ht2FeijYV4qrxjEgnUFc1PZR3bCaHjrFbHMaaB8TggX/3kST+F4jUBMKNerMymWfZYpbrmxMxUZuex4sZqYVqlEqpU0Dnz6262BmNU/m0d1dIkEf1Go8UYfVmdLaRuOJZQSbweF8djNnBAHyDv4tzrZhiBRpoRigVSpWeKEJEGQhtbiwnvKtn4FYbEj3c7ynSN/24SHWvNMsLmDhgQnkJBCYKuehwF1qrPykU9hVfERvR5BCTAfqIN5ipVd5gjnqTp5ss8PVvxVZ5Bv6X/wbKcExDRuqUplMgrKMwHK6CJDrEMwE05qdzckTC284OchbjWlgzet3Sv6Hk0GKlwQ+D6uX6U9s9C36YsH0r61U8LBz00gxq9QcVPHXprXR+W8VhLmdzfR4KD2dY6juRQyLCqjczjy9rtwwGBl81rcW0N1wreJdeSTJ75SOVqpUm5579+iXEyZWyUIVj8jORZTMRdh+RjtUlDx6AyA2TYZR1YlQzkpU0
 t5FYTGRG
 L8xn8ILhlT7yfUTr/4raGLKTXCld2EhSMgioVX9m/J6zFAA7S96fTTquByf2sQAcMVNii+4+upkMJQa+hNDvaKc6VuX3fGiVXt05UGy8V8k2UCPYOpdtG3kU4ObES9fzAhw5Zn4ztEHguDNlqnZvzj0Mbz4HdtODvwMh9UGOsNh65Rf+T+jJfWPIFKtI/KejigeSJYT7tMkI+0HXzzYNbFwahbO/wo2iUm0RLjKUz63y4eQn4/H3zDzmqeVR3Nbf5tITpS35LHujJOII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Convert the device-private migration path in do_swap_page() to use
folio APIs, then extract all non-swap entry handling into a new
do_non_swap_page() helper to improve readability and reduce the
size of the main swap fault function.

Hongfu Li (2):
  mm: Use a folio in the softleaf_is_device_private path
  mm: Extract non-swap entry handling to do_nonswap_softleaf()

 mm/memory.c | 118 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 50 deletions(-)

---
v3:
- Rename do_non_swap_page() to do_nonswap_softleaf().
- Update the commit subject and body of patch 2/2 accordingly.
- Drop a blank line after the device_private condition in
  do_nonswap_softleaf().
v2:
- Drop fault_folio, reuse the existing folio variable instead
- Refresh commit messages
- Update comment to use "folio" instead of "page" in the
  device_private path
- Add Acked-by: David Hildenbrand
- Add patch 2/2 to extract do_non_swap_page() from do_swap_page()
- Link to v1: https://lore.kernel.org/all/20260721013347.65698-1-hongfu.li@linux.dev/
-- 
2.54.0


