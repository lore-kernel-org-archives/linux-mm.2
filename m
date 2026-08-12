Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7942DC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6660E6B00CA; Wed, 12 Aug 2026 06:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DD46B00CB; Wed, 12 Aug 2026 06:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5301F6B00CD; Wed, 12 Aug 2026 06:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5886B00CA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:38:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FF0D1C0D9D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:38:44 +0000 (UTC)
X-FDA: 85092268968.30.D7BE9D3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 062CDC0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:38:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=t3Y5XHE9;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFJPppF4fbIjWCaBGjvk/JQ0AsC0fVseKp2Qr4sN+Ik=;
	b=ghJgENv+qEgbEvTSioJcxngYy5rpy5imZ6O7nj98+uoTqrXDF/7/kOpfeCPMTYkWO7pwgg
	QpM6Uzk6UbIDrSSKBkVW+61cXNSwdi0w93bVnrAlP1NNRyobLVrRZErVu4ly1iJp9Ztvvv
	z5cizxGs0mzdYIIsLaoekJ8iReRF9QY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=t3Y5XHE9;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531123;
	b=Z8jpZXIEia4h0K3zvGyo9TzL3jIZQNHlD9uWgs13JVHXlYrKnhnPMuZUc8FowrRji6Klsf
	CgpZaM2kAIR8KBA1Ml7UQSjgxIp/HKhc5tgFX2Y8iB1nnJTzwXk92WvUeGzimi5GnBntRF
	coQBFq+jv24OvPRWv3J0lHWx3TBgQJA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GFJPppF4fbIjWCaBGjvk/JQ0AsC0fVseKp2Qr4sN+Ik=; b=t3Y5XHE92C5mLGD5RfbigeRubL
	b+Kc4FqL3X3iJnsjyS3DW2sPcWNsHuICor5owmDZ7jPQS04VKyLDbHXtC7yUnggiINH2oo9I8W9GM
	Z2devRCFSycAONXrOEos0bGL+F0sKWQSCQdeYHZdPT+xlsTXj3ACx+vtCQVFL1HS9AEoBpiQAjcOT
	RJ7pzpheFikn50CDOaODuO5eyn/x/4siFS5DhxbVuuW9gr/pY2xHyaHRvN5elt54hd6aAipizGP4j
	BHrp0MnKrZU13EM1eSGHQDWaZrZP14nsIv2z4JuIHb9eyMCVpubDTnK4HVfKKgHGDRQb0um/14pJn
	cm/hxhEQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu6LM-004HY7-2k;
	Wed, 12 Aug 2026 10:37:57 +0000
Date: Wed, 12 Aug 2026 03:37:50 -0700
From: Breno Leitao <leitao@debian.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mm, swap: ratelimit bad swap entry reports in
 get_swap_device()
Message-ID: <anxL5hXgHBUZMolg@gmail.com>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-1-375ef0767206@debian.org>
 <a2e220de-19d4-4177-9703-0e8e5c57f269@kernel.org>
 <antOPhsllDia-UVh@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <antOPhsllDia-UVh@pedro-suse>
X-Debian-User: leitao
X-Stat-Signature: q4n7umzzfb5q8pyedhfc39xdxd48xc3h
X-Rspamd-Queue-Id: 062CDC0002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786531122-854408
X-HE-Meta: U2FsdGVkX18fJI2JKDh5MLBYrW1jnzQYFudJE08dyr+9BmUJ7Kc5k8yKCExhv0GajGAklx0mZQzCKBoQD3cch0MLdRdYmm73V1su8FtbDIio+UScwQsBJAetUjTJ31qgqcGNtcB1KUZq+gBALSDeULAmwNq4KQ56RHfaYRra7SsWHDBY2ntpIzQFRwaAhIHUiQVzk4bLg4sB7amI9g7MaMgVs2lVhHRUFLSIDK9nqZ9BlHQ7+cKd+MzFLv8RT/kq1uzsxsDYPxb4c0iW40+ZenIN4Gu0YH98nmnYgTU1WJGQyw3hEgRZtXLI2AEpaqB5LVl4NBLup9S4Ikbrt3xw7wS1KXUEz8nE7rmdo0l58JIlK7+GZvqPo2Rglm/28eo19vwrI9L91stePZWtM7Ef8zhgnJ8IrB8EwWuTBl/z9Lso4VlGd0gmnFlHq8a+w6PiLE/yYK8BY35L7dORWXlthIdZsfO8xJ7KElBFBRt3VW60Bx9AzvG7WAvghlutH6BvnasauZpjVRPCqh4zDjV/5FXGD7g9rE20xLAeyRnl0BFCv0fnTXABPDDqdcorqVxgVB5thdqETCTveb2Ve9bWuzOqNCDFyoxwqHoSPg2SQCWRZGCkATkufSPy5MOcveFlYifRFs1YPAXXj/DNlKsd1ROQ15VnlclpuzFCMTM/avOzvV+B3o/lh7x0/60I2Z9yRjpDi9XvQW31mbH0svF60D3QFquKjiWIBTSEXlhGkKmczQO4ZVkmTbBlmgYN97FewB5XdE8UE4ecamdZI4babufLX1df+p0hvgY/tpYujVAQ7ZHGK9p/NujBJclQ8OM9KdPtmSNlwZPbN+9qkpz0y/IntTH0G/pewK2le5vom103CPH0HZFgAeyglsX0j1tQV8IiHeL+Sx/2uF+aIL8GI1ZtO64hi1heW+T+A64PmmoLvq1NYrJvU69RIpvjCPr1zVxsEns+43LySDDQQyD
 SGibV28V
 ZXRdHywZ3RGj6K+kv3juZAS4esHALAsIuQmjaWynM9f7YtMUku3fvB4XGgYjaTb/1pFaXjE/0xkpoyWo/nnwX1C67K5xZ0uyK6Wq41nQDZ4JCnJvwZhg+HeyigKyIztPLHNfU3wIuAkd8ieOx74Z85jEiyO+feIomg/j+sTE0jOk+R9aGp33WJJQNvZJjrHW/UR2AlLn27o5qTZqtPtyfYyO8PQSSh58FhuIwLR5MnRDTkhKfagtBbu5jCyygRlN9FP6amMKZGnFCk0u+hBxlKkdadBSlPJ+dRvEXaira14QKl2lkF/8UHCpeHGKqz332N4Og4SOsLjYS14I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:48:52PM +0100, Pedro Falcato wrote:
> > Couldn't some of the stuff you drop here (different entries) be similarly valuable?
>
> I think we generally do a terribly lousy job reporting these kinds of
> failures. Would be awesome to log this elsewhere, or possibly send
> something like a SIGBUS to the faulting process, for instance.

That's precisely what the follow-up patch in this series handles.

Patch "[PATCH 3/3] mm: fail the fault on a malformed swap entry instead of
retrying it" propagates VM_FAULT_SIGBUS all the way up, so the
application gets SIGBUS'd instead of retrying (and re-printing this
message).


