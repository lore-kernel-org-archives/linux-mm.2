Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A450C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC77C6B007B; Tue, 28 Jul 2026 05:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78106B0088; Tue, 28 Jul 2026 05:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8DBF6B008A; Tue, 28 Jul 2026 05:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A087B6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:30:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DB658031C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:30:00 +0000 (UTC)
X-FDA: 85037663760.05.9494393
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 645861C000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:29:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GuBEno1T;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785230998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohxPJwzY/8M7Wi6UDani9iBOICXrnJWyNUrb+Njoc54=;
	b=U+6cvTbw05DbJWRtchJj4Tezz2x1wB+DFMj+8uANQVYuS1eyS+hedSRE0xvWSHOMeulhry
	PHu/hB0ac1g+q2bi7XhJti+TLIW2nromd/R6zOpvoY65Y4PUYh/XVcxJjQ+F8tor5pyIi4
	yV/9j+RLEFLS1iSXAt32ajmVFRQJgEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785230998;
	b=SNEc/zmnJGtZRtDPOahfEVVqn1gQ3zW8DQwUuSYF5KWnudo1J8Pe3IK4NWgPHyQ5b7eUEX
	WZX7QMttsfIXFQYDzWgIkpZ4KBTAc2y1IHyEsrYnAV8aaII/FoJT0QjCBVMuSMlUHOa470
	Bv28JGcBwHbrngj5K8wPO1sshROUJ/Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GuBEno1T;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ohxPJwzY/8M7Wi6UDani9iBOICXrnJWyNUrb+Njoc54=; b=GuBEno1TGrjyfR5/do1cSGpmJg
	QkB/oHpscLnb3m6pPryje2Utr1FaGjGv52zoD7Rd6BMXWde76KPuE9XG5C4elQyDLb7j85pwXGq33
	SRRjeVlqKAvYcrJsAw8FTI+520qLTxu2sfEHxngLn+ec+Cx+wZo4/B3VrAGaJHR2IWZc805JNUoVM
	9jQx0Xj1qIgQmY1w6ez503ypOsJTM9PRCNzPexmUBmN644jNA5yZWuqUs2eKztXfT048vHy1eI96U
	NibGf3p+u/FSVQwiEuFf4O47cbG4CkQH8XF7NKlW8ze42bmn66b8zissvkkKN/gptpGtCTAWWoF44
	MCb/2I3A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1woe8A-007Zpo-08;
	Tue, 28 Jul 2026 09:29:46 +0000
Date: Tue, 28 Jul 2026 02:29:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <amh1nZVVaaZSGD3M@gmail.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 645861C000C
X-Stat-Signature: mjnjhfigmqo6njuy7a5p7ikttobnayxf
X-HE-Tag: 1785230998-672101
X-HE-Meta: U2FsdGVkX18P2Ph/edI7+ccrpDNFYrdPR16zJB8eKVFTrHgf45rLi6YT8Sgs0Om7q0t7r5RFjHYU//9QxUNRxT3Vd7z5lc5t/QSnZATgInrBqTGDeDAHJtSGAXmN/QE24BVMm/WlN3wl/7m9WgEXxn3iH9B4KpeCd1r8sktoX0D1+jo7ueYB6fTZhwSJlbffTUtbVpoZkAt+hkqF+17cxj7Q9/IRTnPEarQz/bpbq9tG3j5oSvgLoOtTsrzFb604ZbRwFlS64oXWZ7g8elylQCSnNz+1kdHIEsnHoUrw7faF3cyOlyTfptl1I0bVYZqQHPHqMc6NUgHx8Ns6KWwzOEHdVIg0VfTmZMlz22zS18d2h1fHMV2xjaSQwDTzseU9gFqP6uw0UZAC1+nGgvEpq92rKkcz/6y7Crg5tRV6i1cdbNEHTkRC8I3Pv6zR5z/3fGnKkD10oQOjxNzed7DUKguRHafPQi383EDuZ79fgV8jJUuiN1UfjC9xz/OOit4gd620c0Y8yFUHVNKB/tmB2AJ6J1P+5s2qR4Suls7daqSZCxqsLR6FcGQRD1zr7x9+Z2fHrDtm26DIhqjRlEaRlK9dzE7e/q1geG5XUDJUpMN1baSZtpxGuT69d/3B6EPtoB4IA8D/8ZSSDCeMKprZbInhkuz9L6vYe/5wwKuVJRh7llu6ZmMqd8ekTdaqaqyP5T/fYA/LNBL91QtLXfqs/k6HdIJITTcsvpXvnGwRwohp2EBrYZwoVOODzcN3zERAgUUe/HKnQ0M4T4XBfz/91k4lkoX/8qGeuLtbjbB36VfEfzH885WhCW91QzCEmu7b78xgoCoFCRGQGXHWIMCprLhFpnr4mqF+1YiscnKJbmXtJsmkLeIxk0PWmQryaVmeyKKFlnD3Sod2aMz5MHdYR7E6g4qKfSzjUf0/XRGEssgENwmBp4uFghOzB+4/+m1IvXmoKCPOMPSBDI1GbQZ
 dBtqUItC
 8fdAQShSVqmYfp7N9xfkvJ2jHhaIAdzv8aWamAP/ckZBY/pYYdqUH189h8CPUU8BQKVTSlFflXVHC3g+mlJkCjOEJgiGqzotNWMQ58VyvL3vIpaY+7pto/f9p0h+TA2WN1oEN5WkeNkZND/GXs4rBpyBdgXcKvmHBM4sig9benYgMKkUkQ3YlkGmyxpuG0AY+7WlIu4bohq0DDqDKEC26PW3BqyKO0ToDKwULebo+qX86sdPK6EgsQ5QgnyBTSEUSpOqVNbYDccNUfQLnZH0qx5IbngZFcFIGtZsn2wGz/LgcdnKg1J1+sFbSAMNJGfdYVuyNNSzdfWOArQBbP+xftog/ms5iL+diMzJrl1VtHdSdjbkzkSaTPsXJeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:57:13PM +0800, Miaohe Lin wrote:
> On 2026/7/28 12:24, Andrew Morton wrote:
> > On Thu, 9 Jul 2026 11:34:05 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> > 
> >>> The script is intentionally NOT wired into run_vmtests.sh: every
> >>> successful run panics the kernel, which is incompatible with the
> >>> sequential "run each category in the same VM" model that
> >>> run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
> >>> ksft_* wrapper so a default kselftest run does not opt itself into
> >>> a panic.  The script is meant to be executed manually inside a
> >>> disposable VM (e.g. virtme-ng), one variant per VM boot, and
> >>> requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
> >>>
> >>> Signed-off-by: Breno Leitao <leitao@debian.org>
> >>
> >> With Mike's comment addressed:
> >>
> >> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> > 
> > As I understand it, Breno would prefer not to rewrite the selftest in C
> > at this time.  IOW, we stick with the bash version for now and add
> > "convert this to C" to the todo list, OK?
> 
> Sure. Should I make this change or should we wait until Breno has time to do it?

Apologies for the delay. This is on my TODO list, and I'll prioritize it.

Just to confirm: the feature is already in mm-next without the selftest, so I
only need to submit the C version of the test, correct?

