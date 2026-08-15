Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BD5C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 16:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517136B07D9; Sat, 15 Aug 2026 12:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDB46B07DB; Sat, 15 Aug 2026 12:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AE56B07DC; Sat, 15 Aug 2026 12:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 252B26B07D9
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 12:05:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A593DA2189
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:05:00 +0000 (UTC)
X-FDA: 85103977560.30.B8A7150
Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id D678D140004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:04:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=YigGzi0w;
	spf=pass (imf23.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786809899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ZN/KEvCkLP1TQzzwwFEbwVX54Bpxpf0tYWDEQSuBII0=;
	b=V8cyr10RgB80ohfMDQ2XuwXVKWAXypK+KuI2JKXFMrpGQsZWr/tcngia45jIW+dO6Rz6zz
	fdEPtW/WiVLW6+UUwdNLda2gz+VFXmnfOGLsG18Ja+ECOZLqeXuO5xfM2I7Uaxr+VO1Lps
	jd2VKU7DALa+BZGYd6bcP0CjBq1sTvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786809899;
	b=YLusXk7GmfZIClw1fzsOfIKY4lL0Dc+lA1eqj/NkILgv49a2VyUGWeytpEouGHh5VNT5Vu
	G0TOWnqfBMU0lBtVflgEDYbhEPkQCdsihlUQIpCtpWX6/vEULlaLcpxSlwRRlQQKkV6EQQ
	+ws0nyK/6jqPOTc/zfUt55cj/eAweuI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=YigGzi0w;
	spf=pass (imf23.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786809897;
	bh=ZN/KEvCkLP1TQzzwwFEbwVX54Bpxpf0tYWDEQSuBII0=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=YigGzi0wvpDq9QD9UPFboTR40v/VExuK9vNaeP+w1HwqFYZihQswEDxa/ragKczdq
	 W7ZXDRMBzkz0U2djN5LPlw76qJGR/TWeZBM5ett+VjAcMYDyEydU2v8mYDSjzdQY4A
	 XhKS3vnPbbBmpVR7BfNEfvn3vTdBjxTZPUL3Hz40=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hMkSn2mfPz10rF;
	Sat, 15 Aug 2026 16:04:57 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hMkSm5QTxz10qy;
	Sat, 15 Aug 2026 16:04:56 +0000 (UTC)
Date: Sat, 15 Aug 2026 17:04:55 +0100
From: Bradley Morgan <include@grrlz.net>
To: joel.granados@kernel.org
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_2/4=5D_sysctl=3A_Reject_uint_a?=
 =?US-ASCII?Q?rrays_before_calling_the_general_proc=5Fvec?=
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-2-9df50d26e477@kernel.org>
Message-ID: <1A7C293B-4D12-4F26-AB80-7B903C6FB431@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 16dttnbr4t7chu6m3hnhy15ws4ipossj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D678D140004
X-HE-Tag: 1786809898-812689
X-HE-Meta: U2FsdGVkX1+Wmu0c1YH8hg6l0wWRQo6VktBE8Hn70BG85JhkZeEuHVGmQh/SolgRwX7Hby5+2fr+2FSUrX0mxTIS2jlgtbJtUxy6X36+LzW/ItAInokFlTpPg5blC1Gx1yRgmP1PY3pk/TCYrIxzjxvpyXox0Uw1Prsrn8oAjVbGuiX43LOzhYqSOE2tBU+JEtzjE8FOEpBYrf1c6LmdVP9oT5l7H7SItpS5pq98rCUxUxnbA2IBLvLgO3kKdFPLliSM2Wscd4My7EX927SLM6rtlG+3xHeGJcc1/oeEEqSDuPSigz3otd83oJgmAJwWIhXpp3YNAj1dCIjQnrWMS80v7tygvks+QKAjg++fkKQ+OT8lrkQA5H5s7siYcm2prX2stjVKXZy4LdebGvGCYtAbcqH+8sLYLG51L9+VYZwKaVQp/kuqVmGGtq6rScKUPcH75WAT/WBOT4OKE023YG7QYKgClWNaPDX+616SeCCk7PUFsIUSr7gGjWJU0aJxfsBaTTu6m/Eg84CJvKnTRVoUNGKNb3UjVP1w0v249WmH6Y+42j/Ggi6MTHPnS+lUupvyCVboGInlhlt5igkH19Te5rs0Q04MQTx71VgYPXJdAf1zCSPL517aZUGO5uHiVsz+g3+o1h+BubGVIkgW3ULoO8xl3JIqgXL4o2Prxu3r0HkqIyL065CnhgFAfBOJGqTuMSnujVgl3+JgAQhuzNcLkEz4Imh2MzTh6nZ90PMXZKITcHJ7HcpZmlSDzK82mE7QCzeNC2hQF5sFfbwiSJTricqGykTZg96ksJ9mre9FTKWbF0Bx0SuA64aIqZe+XR7WlSv8NSqmY3ogar/0XTNeoKhKAOXKRPdLgzUxH9C5U89SWPuYG2UAsC6UKPP+DjFognQooFKSYlBw/Hqm006eIhgAUGXqd1HH8Tx9rwMWBWeXpiP052ELcN6/k9Tw+xwNts1Dyglcn0hFgvo
 yukwWUff
 H2RxEdvBcH1gvWKQqfUIoi8L2uBk3RBJELoLQjmyrvRXHh4gVhOifvXUD8Of+ozshvWycAxKR2SdHsJcl7S8+wvIwa66OrHo0YzCSSmPtq7p3oZPcBQhwUnjsbea6nmQKnsZaLh2o8hJfSz/XCki2jR/xrf+pNSXjkEcuAtr0pJwC2dS7otFyTvjJwB/2uVMqeNLBTOAIOCeactwODaYJhw1Sq9xTy+hNLz6g2Bx6PFyO/KU/npcuosXveHA+E0tiwUJF7Z5qQL3Fq2gHnNCOXWnJMlV4yIUAHjd4ypY8ZoUqHOSZvY0g9SMMkany3yLf+UGEo8Ms/fbE6zBVW0ngK7so1cK9vcgZVmPV8awZOEqkhFpqvtv/PNUkzBOHYbXCHfGKseXT26cCKoPR2/aSn3yf3pKunyKThJmTx1bPGtlmK8E8AnPztNd3xmNtJhDVKj2KiI+PLAP8ENE5WUsEUZyUj2T+M0oA6+/R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good to me.

Reviewed-by: Bradley Morgan <include@grrlz.net>
Thanks!

