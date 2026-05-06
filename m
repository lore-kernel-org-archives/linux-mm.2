Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D96CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D466B0005; Wed,  6 May 2026 11:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBA26B0088; Wed,  6 May 2026 11:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2346B008C; Wed,  6 May 2026 11:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBFB6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:03:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2CF616019B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:03:57 +0000 (UTC)
X-FDA: 84737314914.02.4D0B297
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E24D9120011
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:03:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fb5Png8B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778079836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkmd+oTVbbJAQWCL7fhM0t78aQNiE7khgECdOhYJ8FY=;
	b=ZupUq0Ao5i/1jsCiu/KbRzzH3YFsUusutCEdndvsMdH3aKmCbYygka6wjgzoZQAazgH//G
	XrnLsB1bV99nHDSxKnFg42XfLUmhLxtkC44xdlb8Mee1D2D7mMtO7g0q8p5evzkcWDXy2I
	Z8rNmfv1gdd1r0HGNgQY9Wr0qq6sjO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778079836; a=rsa-sha256;
	cv=none;
	b=yleLROzdsmnpBTtVRYPnQnrzLvF4gqYiGL+lT5xop46wJItm9J4ZIYn+wJ7QUX4npKXq3u
	TLcSzoWXzMtF7UHjDMVNFITrIVcH5b4kG0lPzDzLRM6InVVyzec+NC6D1FzPlqEV7/i8LI
	Yp8veWWTYA76WJawS7ZFSeakkbYt+Qc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fb5Png8B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6EDE435A8;
	Wed,  6 May 2026 15:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EA7C2BCB0;
	Wed,  6 May 2026 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778079834;
	bh=bRfHF+S2MFMHyJOxRLpu7TMI5KDisXUMXlQNlpCTENA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fb5Png8BWp8LnifQPwtX8hdl67jcuQjxo//X1qRsR/B45J40W1yXe+Djpf7E4UmXo
	 fJjQ7StKMp7ICOvQ730YyKYLQJyUjeQYf57DvTuzG6bfOHxwBALz/R1mWZqz8FpkUc
	 76ry+dNxcSVgnYHxxcp4TEYDWOyT/ynf5idEDeK1hkvc9SmN1Y0p2XV1J/lStv0QWt
	 sMhgBc9f3ZTbutDvhmlHkgx6Ck7WlvkaPxutyOzyYmb9pxvr+jzHSo/vkxJ+CVqFBa
	 Y9giq+678EGDTTlwOYd5GcQ1sxZxSH0Fh9Nm4opLRUqcw6xBOMNNRZA9IZOpbCFFmE
	 MszqTGy6GXWng==
Date: Wed, 6 May 2026 11:03:42 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 x86@kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Namhyung Kim
 <namhyung@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, "Jose E.
 Marchesi" <jemarch@gnu.org>, Beau Belgrave <beaub@linux.microsoft.com>,
 Florian Weimer <fweimer@redhat.com>, "Carlos O'Donell"
 <codonell@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa
 <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Ilya
 Leoshkevich <iii@linux.ibm.com>, "Steven Rostedt (Google)"
 <rostedt@goodmis.org>, Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra
 <peterz@infradead.org>, Dylan Hatch <dylanbhatch@google.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees
 Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Subject: Re: [PATCH v14 04/19] x86/uaccess: Add unsafe_copy_from_user()
 implementation
Message-ID: <20260506110342.25f38f3f@fedora>
In-Reply-To: <9f85f092-c376-4350-9a12-479d7b70399a@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
	<20260505121718.3572346-5-jremus@linux.ibm.com>
	<9f85f092-c376-4350-9a12-479d7b70399a@linux.ibm.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E24D9120011
X-Rspamd-Server: rspam04
X-Stat-Signature: xqekpomh4rzwj3z1bz93t4gzujehbu8s
X-HE-Tag: 1778079835-454028
X-HE-Meta: U2FsdGVkX1+9OLCWMfWGnDXXppSFqREElT47hdP3hwhpe4Y/UwgLBSPQ992b+CQlzmly+IKUdVuVEuATRO509Iz9NS1PAW4w1qlMly1jjqfEjLnBsQQ8odVIOiltOvq4xFaVvsCm4JUlpKhHH+vJ7RvpdvoEH+yINVgfwKNGPB77IVpkRtjKk0QGfVTylHatEQ722YQuKPXCgq07rWl8thwWtRkrPj5jlpkiwr1nbJsGOqQlm6V2WH4os0mSCRyETeYl3muI2mMjwsg1qXUG8beRzagFylH2Q928bTwoeej1+r0mxK8jyQVDHFXA7GSV8lFsSHYnfJjsvqaaLL7ZKxsl1pj1sHpmx4VP/JGjGzICUGy4ogGGr3i5nJ/fIl2zNFoPy5/AVsUsyL+ApFQgzlbVp+HDeB5SLjgLZIRl4OKdDZmWPuiZJteTUH9Opmq37h7X7lM3qz10eVt0KJOg+RCJhSekxEAPBECent/vbhg3EuXfkQVlIjaqPG188FjhbGf6iSpVgN8Pc1Px37wK8m+3A2Oqqud2ub2+E4jmSqIM9z5maeynF+cXLvta3dgdEvbN1cY5Ix4j8CXcFA8HdGDHBGMndgdVhtQxGFTepj5G1mQwwTuDqOzzv86m/lhwMKqcUBv69/N77ZePk8jePXTy8KIJ9mgPlK9Z2zvzjH2772B/Vc609CYfXi2ybKw75IMWXP171sQfdzSqCn1VxuRAEBGO3sHtzGcMSh36EVHxvJZk64N569BnG+kDnxz+yZV9XS99/gVkgDYPvqOlNTZE9Ydm+DYDiGrrxvhniIpz7NFlA039J0OcRxZQ/x23apJzVFqNmvG/6YGYdQMxyL37cQAddqpbUyquS9XNHxGAFypFKO1iNKCRwh6GTv8W6d/l2fKJBNUcwflw7+6VjOPmca0BS8Fd5gIJZy+zinBLv+jkpCslqu99dOjiQzqgMbWz4DUBqtZ723bofHE
 pr6d00LY
 tse9dkOlXr3p2FK0UQlSDYIp/7pPhKZ5TCzT6+bvy+mkpjJaTcECL9oUGs/hLqEhiyPt24Ew1zn2u9KrAHjEBvQi8PJWxe64dYO+HqaPtOJ6j/BWtMgC+0LnHeHtYCw6N8knqS5eCd0rMq4UVbI5+kSPQ3/YwmV8lU9UTkvTsh78GC9SZTQ7e56JeXWgFq+9598qjfOWpOYjh81lb+cPXSbvPb31KJtLGVlniPhXuJC0hbBgCiz6FO7wirYzbMA4Hj72p4lv/I9MlNXtwfpfT8Bka1HuOeYvyQb7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 6 May 2026 16:09:16 +0200
Jens Remus <jremus@linux.ibm.com> wrote:

> > +#define unsafe_copy_from_user(_dst, _src, _len, label)				\
> > +do {										\
> > +	void *__dst = (_dst);							\
> > +	void __user *__src = (_src);						\  
> 
> 	const void __user *__src = (_src);					\
> 
> This was suggested by Sashiko AI review.  Any objections?

I have no problems with that.

-- Steve

