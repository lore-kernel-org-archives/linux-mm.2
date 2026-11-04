Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673B5606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=KQM/cjnZ
Received: by kanga.kvack.org (Postfix)
	id 6F5B26B00EF; Wed,  4 Nov 2026 09:43:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6046B05B1; Wed,  4 Nov 2026 09:43:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573406B05B2; Wed,  4 Nov 2026 09:43:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6E76B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:43:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA3A68071E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:43:31 +0000 (UTC)
X-FDA: 85397705022.15.4EB259F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E05E1A000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:43:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="KQM/cjnZ";
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793803410;
	b=4oTz5kxa9ztypYfgySk6JlN4nk/k9TszNGXTsnz3U6kInkfk9Ce6l4TMIHwbX/KJnf0d76
	re3qxWMg2PJUMgO9Rx0cNG56k2ms1Bk0DK2YYFZ7gTd6N1lKGrsg/kQWNbkNoM1/RnnCcr
	uQcr3VJh4MEC+73eLeHXYFHmH48VQZY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="KQM/cjnZ";
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793803410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKqJ2uEOYtzQRvkSXtbhCR2QllFPzuY2q8Y7E0Q6qWQ=;
	b=y9Foo/UU6EiTpljzdlvBNvLMGu6mLUKLp9Nj7S0c0Fjk+EtK1WfdT8UO0rqA+jicbk9zY0
	xgfF5NZSaP6MGkhiePccvD22HXb1996z6pPrb1LqsHd6IPP8GbgFMKEXnExwzF+km0iPis
	S1/GeFkEz6yCq6sSFOz57io9CLsgeiQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hKqJ2uEOYtzQRvkSXtbhCR2QllFPzuY2q8Y7E0Q6qWQ=; b=KQM/cjnZBeXbhClEjzLNifwdvv
	1gwqKaOIRYpt/7Zp2XKHAGBHin8pIN0KOwxdBBigiJFWAafnEGpiv0j51/I1BC5w0FOsuGQ0dkWQV
	UQAIq9uCc5RxA1rHorLv367s39pjOe54LQ3uPosGpFkWX0SJQSMPvGTndfvNKWgO6oVz6tEIPRzQc
	auFZUwTBBNslh4KF8MVJUhdkoytWqLZLrnKvIFSi8sytczmoToUnnLzQL5TxDMjtMG7agAC428D38
	WptdPp+zMLc1uvDFYzBg93zI/0GbsbeE5vMLkfH6qapySueK8lNICrM9XtOyjTr8+WHVslaJ4Untr
	IVnIX+yg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOcCo-007nSH-1w;
	Wed, 04 Nov 2026 14:43:14 +0000
Date: Wed, 4 Nov 2026 06:43:09 -0800
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, SJ Park <sj@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] tools/mm: add hwpoison-panic tool
Message-ID: <autEaeyHvhi8vvSK@gmail.com>
References: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
 <12f80449-9d6c-4fb7-bcc4-e7d38e868da2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f80449-9d6c-4fb7-bcc4-e7d38e868da2@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: cwusoknw11dbfny71z14shyw4uoaxaks
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E05E1A000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793803409-199636
X-HE-Meta: U2FsdGVkX18aeCV6H8kbsawPtf0+xRb6uiC9oOQkdq1n82UzFI6osb2ZzIZG0Z6rpA+fWf9Hijl4EfmQb2XmW4Xfxvcv9GXPGeM4yQ8QG8r8avzYMbCPBiQCAeeyqeFjqd9XGWNOMkKM5aAaAOdKFgyvR8WJ77yiwzhj7dWwPf5HRpMAQRqa7kYgWg51+emHz3L9fLU5TgfzkYFH5/FxATLMjl4DjxDK8eC++CQ6yQBgqAairVfbM4eJe6fVRgH5TVIVTfLuHMt64Ip/YUhRuUVnX/+x01VnDr2bePypwiiWja2hvinFAJuyfHQvyjpTAqwXz76ANM4zvmbpCb9ui0M1CT1zFlMPttWsB4TkLlch/wcbP1xOR3c6dGbWTwapSnillYX1W7mfMzL2pzBnKivmigXvVgU1fdfGTfNmK3qK0ejYtDzZmNyrI23WobVjpVgxpPvQFzTTmrG8OedMvbcK4tZCYmvfTlvXhr1M8qjVYbMjn42pnqdvQCYtspR3NJmI61z/cDfq/QzxuJmW6xtmBsvd9uXcktTYALXq6AP/4WuVEMYLM6YkZ5CmxmlDhIqzkogYw+pegpUHFsli91KR4CFGropya5u0+UeGn3MqjaaSiaXjrzGamDqksnrRZvDp5/Qc+H+kdR3l0OzirLE+SNuK9JgO0DcTHBTj4EudDJUBuiD+5b5nUYxXOmzXZNWJ7NMx0J64bF1Gd9KqTLlBjbs/ViXjsPW0NNTLGXBpYMJAwTEXMg+VGtY0OT1vo+SN53WYox089thR2JrTMompEk+GgnpNfUq9ETfu3qHGcEmnwCa1NyXRemUEnJwSkqoPoFEJpMe9gl37lgxxgF3fvd7v8oKEYaGcrr6Zz3c4TepVid0VZFly0d20+jiewqCBoTtPx/7/pus5wQ1oKv6kJxBiYD1/VbKbkoUeX2waBO6eSgrxvRRLktclWVf5mOLTZQz4gA4XA77pS/7
 6ufRvg+w
 k1up+teDI9wiF/fgDTPdsEq+gXqQtglwF24h4qdAHUK0FezxCoCNaZgu2EBdWdSssnPFCvzsO9kKoTdr7e8nS3Lyig5BITrZcUpnq7GurbVRUO7ydxypnd05Y/Uwi7NWQdQug1zMaM/ASJpvSO3p3MmUOvy27Wc+PTzhlH7t/H/3JwHoCNR6OovXxBDZZ+Zyl1vZDi/4TACstZP6wM8CjM6QUX0tlEzhsisR61BBw3EfueFyRzeXcjSMvStfJ35I2v9ixXgHhVwXa9k/YPnoRbezOHT6umfn/wlF3IT/sb0HDVOPXfkk6bSoVCaMVBlI08urIWPr6zddM+Kc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:35:16PM +0100, David Hildenbrand (Arm) wrote:
> On 8/13/26 13:45, Breno Leitao wrote:
> > Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> > sysctl, picks a kernel-owned PFN and writes its physical address to
> > hard_offline_page.  Three page kinds are selectable with -k: rodata
> > (default), slab or pgtable. In all cases the host should panic.
> > 
> > Example:
> > 
> >         # ./hwpoison-panic -k slab --yes-panic-my-kernel
> >         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
> >         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> > 
> > In dmesg, you will see:
> > 
> >         Memory failure: 0x100032: unhandlable page.
> >         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
> >         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> > 
> > This lives in tools/mm rather than selftests/mm because every successful
> > run crashes the machine, which is not something to run from CI.
> > 
> > The --yes-panic-my-kernel argument is required so an accidental
> > invocation does not take the box down.
> 
> This is not upstream yet, right?

Right. :-(

> Anything missing or is this good to go in?

I would say this is good to go, David.

--breno

