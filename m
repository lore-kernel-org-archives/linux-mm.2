Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F83ACA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315516B008C; Mon, 12 Oct 2026 11:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5266B0092; Mon, 12 Oct 2026 11:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB5E6B0095; Mon, 12 Oct 2026 11:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB2696B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:50:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93ECDA0AA8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:50:23 +0000 (UTC)
X-FDA: 85314411126.29.A85AD77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E60DD40008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:50:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3dX9MUs;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791820222;
	b=W1mi4BG+jQD0jJWIn3gkXMM0jCb36pQED2+aUgrbnpfYP9UrYCbaU882Ziqdvj1HttqCFU
	nbD3Lmu+pEk0re3p/SFFdFmuHFAdKrmaj97tg99+7lXiwK9dT6aMItfVVnh84IWyOE/tqn
	j+d3cVp0DzhI1kTd7FCZw+bdsglttzY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3dX9MUs;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791820222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=limYlGucbLfnD6/B196ITj8VoydVRIr6Jy1/waZAj8E=;
	b=ZCLZSV5j0ChjJ3J/UHRuqBJZASVP4LkB522CSfgXIFBfFKS5XuurIRcoGrC7467gDr7qHj
	Ory25XJlxsU6NfxwWkFWP2W30BGYA2fx+lS/g3Tgxadp4j+l9KhgD1GODSfLHBPoxWmOoh
	QP642AsFlvwKUUYnJ/Cg7Ey3+L5wB9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F30D0418D8;
	Mon, 12 Oct 2026 15:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3871F0089C;
	Mon, 12 Oct 2026 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791820220;
	bh=limYlGucbLfnD6/B196ITj8VoydVRIr6Jy1/waZAj8E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=R3dX9MUsVzFhlYf/JqRbrpziAFTT8EEiwanDofQ6t1q9WwenOmpt1fVFkJUPT+47G
	 3lErBIH1u84D0EZMGlqFMTQeNlZZqb2G0b1RRiAPF4OW9tzDoNivyUlI4HpZUnkFJG
	 1Ti1bf0m0jNEcdfwrcs5V4FBNRKh32yB48B1ce7q4tdqsLmXHxsldH/zFbs/Pc7rih
	 F36v9vtzv2tfJKPVow3s/k1FfBcfY1cFIJLjttqNj/TJsktXXxEyIdabIU75U2PWVh
	 7XP+Vt8BMKKZ1Z1YzXzMS3bYkyAf6iamntYUztBn6CE9+P0CPSDin5qNPLh3mq369j
	 VQ8RJ4+xIJvng==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>, Tarun Sahu <tarunsahu@google.com>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com> (David Matlack's
	message of "Tue, 1 Sep 2026 18:07:08 +0000")
References: <20260901180713.4185641-1-dmatlack@google.com>
Date: Mon, 12 Oct 2026 17:50:17 +0200
Message-ID: <2vxz7bjmkjeu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E60DD40008
X-Rspam-User: 
X-Stat-Signature: q1nzbsfdb6g6g7c1fs8ub6ohb9upuuwi
X-HE-Tag: 1791820221-156332
X-HE-Meta: U2FsdGVkX1/W8/syyRd3mdzOjAd3QbX0KXgHt2t02H29OLYihsJE++Vkz9ez6ODmpG88BNbXI6S9rbAa+MnhT0DvvvsIMl5WTO7dn6kTza0dk3FZNdDydQaTCbpfMUXH7zmc/dXKxSQZMLQSxJbDvrLV4S4fG/rd4YYsxSUGxh2sq424SOKsnqDXn7v7r7238SaLQFARstArXTGye6pFsCD5ScN0tiJtUVsZigByFtJDQy12+/j1KkSz7keBdmhWhZDHb/xCIY18RcoiLPmh5Xz/v2lqa61g5gZhGxzzJHCwvfzmrbVop1cFVbtm2hLY+n3RppiGq36ejzBVRYJFM1hgl8bIykCjH/nqSUa/CdJuYBd8R4ZevdXIt7tXs06Gcl8L4+e5Lb8pEl2CN4jtmzIwHoPSx2B/RePnD3d+H9qnIuURP06F+x+8yHK6mNnLRe+q9OdOjjbhnLU2OWjPwH6/BDMq4IfjJ0FFpcxRJ9AOVOrKZ4D6lkrqj4sTugG73KYn6N5eMOsYTIeVIljQOowDSXdX1bB+ec+4Xz4usgcMpTGxYc94hVfBFpS9/KaKPwF4ptHzyjk5QSWZLU4dY9oooVokdoxCbrT6Co40YUnW0DZ3ZeXttUFhj5407KlyqaYhVK/QdT0w5ubzps75JJytf7zA0c/y160Q12Dr1UyhcLKCVNep8OblveA2434/0Xj0QdvTQQPv6gGzGeTyAyhYgrs6sn7YDPHbDnqA4vT1Xg+ynu3fWljxprSjdNRo6gZLJvCEaMikebR5Kkm5beWdKDSRWkCPanvFr03GQkEGs50X8jD3Is9RbU2m+1t8CetpBMj58be5HbS688as8Jt9NfWJG3THqAwofRxGlAHUck7nuJUE9luvvI5DYqa90PrkrICpENsDe23UH4GRKTdgI5qk07t5dWK5FQgkAFBxybCR8L4wpKiPvS/CP41FZWapUVhTSvl76auo8+h
 kyBSTSNQ
 ceg067e8RP2kLNu3HvZy1PFTt1QGOe8HaOAmterC1RdYIZL55m0cZ6w9Q5boQv1tUcRk6BEeZ/Rvg21y4L+G2bwhcnd/+ReeBnvGW9NsItchbtX22sdY1tJsCf+/pqFP6Aj8SpcIHP1Co6GQouPd70hRI5UUyg+/yxm6aH/D3ilBKJ/h8kr9rN2vI/+e+lkaZE5IFya735PGGB2juKZRmMnLZvkuov6axs62h5X0enhkl4b9nbgIOQdSBvberQRla1DCt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Sep 01 2026, David Matlack wrote:

> This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a new
> UAPI to enable preserved files to be restored into a userspace-provided
> file instead of a kernel-allocated file, and uses this to support
> preserving tmpfs files in-place without any changes to the LUO ABI.
>
> The Live Update Orchestrator (LUO) API currently explicitly returns a
> new struct file for every preserved file during retrieve() (e.g. via
> memfd_alloc_file()). This then forces userspace to use anonymous memfds
> for all in-memory files it wants to preserve. This works reasonably well
> for VM guest memory but does not work well for other types of files that
> userspace may want to preserve (e.g. in-memory logs, binaries,
> configuration files, etc.).
>
> Preserving entire tmpfs mounts in-place would require a large amount of
> kernel support and would effectively make tmpfs an ABI, which is a
> non-starter (or so I hear). Instead, we can delegate the reconstruction
> of the tmpfs mounts (directory structure, permissions, etc.) post-kexec
> to userspace. The kernel just needs to preserve the contents of tmpfs
> files and provide userspace a mechanism to restore those contents back
> into a specific file on the filesystem after the kexec. Hence,
> LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.

Based on the discussion at LPC, we came to the conclusion that this is
the path forward.

Before reviewing the code, here's an idea that Pasha briefly brought up
briefly at LPC, and I more or less agree. I'd like other opinions on
this.

Should we make the interface more generic by allowing userspace to pass
extra arguments to PRESERVE_FD and RETRIEVE_FD? This effectively gives
each file handler an additional uAPI of its own. The upside is that it
would be more extensible and we should be able to accommodate more use
cases with this. The memfd/shmem extra uAPI will take an optional target
file to retrieve into.

For example, the guest_memfd patches might use this to tell the KVM FD
to retrieve the guest_memfd into. Of course, KVM needs to see if this
makes sense (alternative being preserving the KVM FD too), but this is
just an example of how it might be used. I think VFIO also does some
workarounds by using an anon inode on retrieve. It perhaps might be
useful there too, though I don't understand that problem well enough to
talk in more detail.

>
> An alternative approach to restoring data to a named file would be
> supporting a zero-copy sendfile() that can be used to convert named
> tmpfs files to/from memfds across the kexec. But this poses significant
> challenges on the *preserve* side since the preserved file might still
> be actively in use. The benefit of the retrieve-into approach introduced
> in this series is that it does not require dealing with two different
> files. There is only ever one file that owns the preserved memory.
>
> By leaving file and metadata allocation purely in the purview of
> userspace, programs can create the target files where they want, with
> the names and security permissions they desire, before directing the
> kernel to restore the preserved folios into them.
>
> Currently, only tmpfs shmem files are allowed as valid target receptors.
> Attempting to target populated files, or anything other than an empty
> shmem file, will trigger -EINVAL. HugeTLBfs files could be supported in
> the future.

I suppose we should rename all the memfd_luo_* stuff to shmem_luo_*?

>
> The coding work for this series was done with assistance from Gemini. I
> am not sure what is the latest recommendation is with respect to adding
> Assisted-by tags, but I can add them when I send out the real patches if
> this RFC looks acceptable.

The latest guidelines per Documentation/process/coding-assistants.rst
seem to be "Assisted-by: LLM".

Although in _my_ opinion, I'd reckon most patches these days are
assisted by an LLM. The code might not necessarily be generated by an
LLM, but I think a large majority of developers use LLMs in some
capacity during patch development. So "Assisted-by: LLM" doesn't add any
value to me. Other people seem to find it useful, so please do feel free
to add it to your patches.

[...]

-- 
Regards,
Pratyush Yadav

