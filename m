Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07EF1FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280CF6B0088; Tue, 28 Apr 2026 04:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231806B008A; Tue, 28 Apr 2026 04:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120316B008C; Tue, 28 Apr 2026 04:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F39A16B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:44:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 972A7140516
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:44:17 +0000 (UTC)
X-FDA: 84707327754.20.79E4DAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DAFFBA000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:44:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2Uwil36;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777365855; a=rsa-sha256;
	cv=none;
	b=O5haARloTu0abRIIp6Va+Uo9OUNLPr4/oypOm3CSg49cthoJWs1enUyXCX20kdyJ9EnNZm
	vzrQWEhdpGvNMjNkXp2/HqmPH3R3JJKO0SXJo0aLcc2QLwra1ai17ISrlS+RQUOpH0oAYU
	JiirHty9yk9TwzSaddhTZzouAKa9o1Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2Uwil36;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777365855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WpvDXSZJhPreIx6/Ai4XdHqTtkxshvLhvVzUL3yXQg=;
	b=pzX1mRJ3jyY0Zt/2VG1hA4XvAOg8CFTU/mHeAD6L18t9VbCKOmSbhwVsXHdPSwSeEij9iA
	Vw/z3a4vWZ/VdWc843BTQKrFbNlbk+LOXeTONG4te34pFFl36wOR4l+I4jVYAYTcDdQTOP
	kpHRoXSm06kUmc6GvJznMwscLNtUEzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B25260142;
	Tue, 28 Apr 2026 08:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3281C2BCAF;
	Tue, 28 Apr 2026 08:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365854;
	bh=yMSXc7aH8lsOC9DhmK3iD6MCAykaqWenDw41A4QK+rc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L2Uwil3663RAVPzrHsG1iITO92pHRr0NbnlB8CCbCA1NWUA1xllzeBN1sNKNrcb9D
	 YJPEaayeukzAMh0iX4cR2pCid+jxETJUrV/EZ4cT73E9ODzXtXqBpwST67/1zQz2Ve
	 V+ezBwuEH4jhne7Zz6l5SidpD0jxAgY0n52iythXyWiKs98PSEsDlgyshSiTZ9izds
	 QM8yTldC9W8tSy/8P9Lm0d1r557rD+i7cv0EPHQvEdPWH4RSwVfKbDdEeDl8nOdV0Z
	 jIzKZ871PDXoBW1fSPbaQAN72yn5DnhTTVzjm9Y4hPJCrkn38ARi4/n4d9a7LY9gF7
	 qtgZpYsfDFw0w==
Message-ID: <9e2b2c8c-a03f-4c26-9039-ae64c848bc52@kernel.org>
Date: Tue, 28 Apr 2026 10:44:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
 <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
 <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u8ciqeign17oh6geiuomib3qr7h6pxdu
X-Rspam-User: 
X-Rspamd-Queue-Id: DAFFBA000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1777365855-459671
X-HE-Meta: U2FsdGVkX1/7BYylfQVXRpAyrQViGdMeQeskrjZgwEDWuvl7kxL5eGq11QAvW7y+j6TWp0hnx1RbV3zre5W/wxG9780pZLn0rFJrems929BFzzOOKDXj75RdUx3H7ISzlLgBle0kBgu9g3mLlDRY3AukBByQrX+f0kS+vTV9PBqqCvmFWz1Paddrm+RFFn851bXTCybqRgjXn6zvPMsR8nA//57qdhnAyYdar/otaOGGb6EEYJWMoTFu3jFs9+hpsCxikFAhijHntevEMSz4Aasg4Eilx5yl1ZnpQhAe9glW0l37Y/miKWT82/e/nB6lixCCl9TlhROADiAk1lCsJu/XZoP0anpqt7f0Z1x8DWXqHOjGL17zuQyqD50gE7Ogw8Yt4Z5Q+MLEHaG0PNBoDaVAOkoKc3sxRySSwM3YLIRs00GwRj8ysUK0fXoISK8p7zwekgLDjVPsF6/uN553+TVo7ZM/4vrbm2oNLFFSE6a9e7jsVt3UMso77bdvBygCTun3alSNFUT6OE3t9SkZKf8TzaWjk5OlmFGn2LLzm+35riSusSRCB9PtMZsoT5Lgd9Yk01qzINUmXzjvRKP2Gwik8ti4YnvUqPRYHVj/G1qrcvmuoCFR/9FIJ5gDMZpIZM/EYX5bSx8nr+uLOpAnN2vx81cqQITXEZlaKi35+fHsET2B9f0JbvDIVekJJZIn/4E8eRnoAsNhaCVV/FoRWk7UVe6qeIijfv2tRw+rI+/rJQ6Zq4tsgHILmRkcuyitQZq3QOtdUUn1aVnO3QsBv4HBdS2UvYxMrMf4sh6CsaTfQ5/1uBdvAnGB0WoCysrXlRPyWZuGGcVwJR7D2gkZ14qk2Sn8d8kC0c9cZIDhMQipPhdRbxbzBpVobxqsDfsvuT2d1PqMkfR2EFP8rH66e9NSKZ7cR7Fd73CuBsNjIYPiDxFKoPUXUXv0wn6T4NrkgxNeI/Y5bod+J1HWfst
 PnsMCSl+
 K7GUb6nfrcmCV4aRjZTYohIS9k80tdZT17T+iYHTMoUdcv8SSQQQPmij1OHP5ppDWtyBdSlkGh9DJyTJp+QRYYrKpx7KlQjARaPJ4MwHqFI3Bvz2BMCJJfw5tLx6yuFQ/P9eKahEq/xxGzPQ44hWlAwcnBMFjZwLWn1FXAI6fdcJ+/BF2qQ+pFN7FeiLmIH3aHS1S1jMjVktdKBjiOXtk/+890cpVdeAbIX+7vjPe/xXHJOcA4O2qDX++r81NxoG1h0OHNfZUmMY9CXIuGv7/TMI+8z4QmK4gkbV68NAlCYfQjcQ0oPJ0ElftCCdQ7IWZU0l/4WwC1l4Sq5rbMq6gVMqQ55Z+KbRGCyfBVIVSKnls+YwicHfw81Y6X9okKl1HmoVc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 17:00, Alexei Starovoitov wrote:
> 
> We cannot carry the same patch in 2 trees.
> Sooner or later it will create problems for linux-next
> and issues during merge window if more changes
> are done in the same area.

Agreed.

> The only way to share a patch between trees is to
> create a stable branch and pull it into 2 trees
> then sha will be the same,

Yes, but...

> but mm tree has its own way of doing things,
> so this patch needs to stay in mm only and if no one
> should be touching adjacent lines :(

... this should also be fine even if that happens. Mark knows how to resolve
(and report) trivial conflicts in linux-next, and Linus AFAIK also prefers
to resolve conflicts to other workarounds.

The shared branch would IMHO only truly be necessary if bpf tree itself
needed to base something off on this change; for resolving trivial conflicts
it might be an overkill.

