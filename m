Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CABC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798F66B00C5; Mon,  6 Jul 2026 12:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770C76B00C7; Mon,  6 Jul 2026 12:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FEC6B00C8; Mon,  6 Jul 2026 12:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 388796B00C5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:14:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D4DA8AFE9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:14:54 +0000 (UTC)
X-FDA: 84958850508.13.6471E07
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id E919940003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:14:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ydnz4US+;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783354493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lE8+oP1XZjjpdBFy2VrkSZhpJog2DvPRMczl++eRN6E=;
	b=2zkV7iOyLR0lGEocGrZyYT+a4WlAYhV8wrsMlrl4+bGjc4ta1YqRchb+Zb+sOR3x607UGP
	DmGPQYyp2rruvFXt0IdK7u7iC9SN7PWkCTj1l7rmdNiHXxE3LrxnO8BpsB4wmcySCi6V2B
	87+XG599co+bRqCs5m/zk7Q4BSUnlWs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ydnz4US+;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783354493;
	b=41S4D0St2CKHlxc08yaVjEHPUm0l+ThQLyxmARKCB4KPaksC9VNpWQfPT3ygL/jFYWW0ru
	UyU55wSzIRbRk/SblM8VVYoEirl63WoB7UdEYzmsSovqBAqvcQvqYos9JI2Q/QIT9GHk44
	v0HTcWNcuCp+VshD6II/NCz10JybL78=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lE8+oP1XZjjpdBFy2VrkSZhpJog2DvPRMczl++eRN6E=; b=Ydnz4US+QFx44rkGq3ArU7qxzv
	+zU4oxFKJ09GE4PHFj+Q7ERLs/y0AJITwakgtn3r7lBg9lPuOJ6TgshWCI+IFhcEjuzuCYT72PMDE
	6lXkL4ukw9/nrvU4QLyJrOX9tHh7IkKAjh27GBOkcvnAxUkFRYOuEWDw8sOv08J74Z+RAcTVbFMkv
	pfyYfE6rAhDMgHjxAIlwn/IJSSru4PSVUgX8Mg4+/X8Db5dBBuUWjqVjR9JDNZVcizNe7T7CPpjlc
	aFE0Qc/z8mQW0dJ34QzI2wyOJyDTVFwzHgwhU1TkFE/m8uqD1mjZFDpeqB7dfqWIZf0YmkFJSCs1/
	GWFRwxZQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wglxl-001Xdp-0U;
	Mon, 06 Jul 2026 16:14:29 +0000
Date: Mon, 6 Jul 2026 09:14:22 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <akvSzb0mRSS5aCg_@gmail.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <akjS7kiGjVwWaWEz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akjS7kiGjVwWaWEz@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E919940003
X-Stat-Signature: s93gawrfbbronb9n1wm11wuotk1ujbz4
X-HE-Tag: 1783354492-832466
X-HE-Meta: U2FsdGVkX1+Ze7qAlOb11YQ+0LlV2TLIKzmsiu5Q4xgy1ukzkJN05eY+BYYPV0iyqtKimFo9REAMsOvvWeJ52PWRgaDMkXr9XBf4UqoBJG8ticjNCpZTrR4leqH7ee8LhEoLfmDhccpHxhn8ik4CAaliVKn081PxobpztYVrcXs0V1dCJuynDR72YK+SbrUqc5m6LvdcZbVEFdqfbSf9Gs+7P2pgQNwTe22leYVtsBn1jUY0NgfRW8MI+mxVyg2KO5KmnUAAbfu9hSeHn+28csgA95637bg0rYxj+G5rADl+2uOnvRUH9QOgr0h12LMmsMoa09sgGwfQp+5o8+duPtxoXEG7kjFJJKg8fKYRxzkVd1jKUsQ2LMuHQS6wcZjoW4dBXhVA/h6U2aE7Ibh9HDKISeCpggeHYLHdmKMcgqFOsEnKwMNcE7ttZW1/h1pWMRjkZ9h6O6G7HZtlaEBGevd8i/hti+D3mHV00CAnJqx5t9B1Q7RuoKjxV4w2g0BWwiIyoufWb4CDqTDugdfcefMN0dk+P0rLhJXhAXQ7VuHB12Bp/BxW+GX+e3psOaf9qDDqhIFwtYP+JntqC71w9C4GPf7Vu3IwcYbiMGBPH9R5a8tItAIuIRbLNZtgWMT5LeYGW5n+Lw9SI/Fp6jh44/OfQMZBQp71zaD72NojXDMb3BCkmLHf+hFujcu+v7K21heQXx6ws+3oYHIY3tHPIYPgeQHxKmXSSdlZbNdUU7CCaj4A2iKej21+o09giaO9DsoEoGA55DBqrtxNO+XTcK0qq2P1/jomuqpftLxBr6vwmsd2v565pgMAfChj1DxmKoJUgEJX43pwkKVuzQFFVazD9Hk8UVcoxYpzLVdJz/ZFodRyTr62TamxyJzdJprDRNzWqUcYzfB2MdicI2FSbde5nHWtem1p6NWk5/h5D2FdhwiweqSSkcq6j3ThCXtSx5Va2rxJ5xtfEo+doO7
 e/Ft15iT
 xMxmPJgix1xw1VVHUu/Tuvb1oHjSRYndnM7JhkJLjupurEIXKxsftVMjSrRRqEvTFH9ft7929xS0TFo6nfyK9V7f9wTxPKNIWJqYe6dv0N9810KWH+VErlHIrvEy5QHoUqYOPziZ29UW1YnSEMZC+BbAKefLxcoi7lE4SkX5mF8pyHm9DN5Mvs3mhZ6d9pa+nFB7PJfJXlkAPo88+6eq3rdzrrlFvx5sI7nDWbGR41l++99c2LrcpXE3znvHzkDvK1tyefou/4rLZO4ZDIXdguOeBIrZX9WklxkynjVNOtofOxPChfaQtzs9X6/cA6NkncHv3hs9pl2pymoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mike,

On Sat, Jul 04, 2026 at 12:31:26PM +0300, Mike Rapoport wrote:
> On Tue, Jun 30, 2026 at 05:46:09AM -0700, Breno Leitao wrote:

> I'm looking at these awk scripts and od encodings and I wonder if wasn't it
> simpler to write the test in C.
> 
> We have a bunch of helpers in tools/testing/selftests/mm/vm_utils.h for
> accessing /proc files and there is already /proc/iomem parser in
> tools/testing/selftests/mm/pfnmap.c that also could be lifter to vm_util

I'm fine with either approach.

My main concern is keeping the selftest decoupled from the feature
itself, so that review of the test doesn't block the feature from
landing. Would that work for you?

Thanks
--breno

