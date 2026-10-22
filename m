Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184AD606A328
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TiRT+YNx
Received: by kanga.kvack.org (Postfix)
	id 285536B084B; Wed, 21 Oct 2026 22:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D7A6B084C; Wed, 21 Oct 2026 22:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173686B084D; Wed, 21 Oct 2026 22:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE0706B084B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:37:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E432806F1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:37:28 +0000 (UTC)
X-FDA: 85348700976.16.12EB0F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3D2D20003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:37:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiRT+YNx;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792636646;
	b=ny7jc+mpkfQaYoXsLnikch8pqEEt0sfi1/S4LuTLSb9vKQu2T/2v4btQ6ibCymuQeUjHN8
	Z/FuJsdc2ojzFvxYw73o/UBSa2+U49s+2cprtV7dl6cUVhw2PHHBtoyK2lGsQOoy1+0k41
	7eV9xNFvjThTBvmgH04Bf0BU/qZujKc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiRT+YNx;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792636646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu0ZdecmwjeGyJjNTgvVUayi9FotXs8zWmgYmq7DBn0=;
	b=4rzx8WLxzK3o98q9lRSvpA/OAnExIfNDJ3hMdWHezOIXxGxTw5u0oNtPh+zgUisjcT5DvW
	3uZxwqKeVoSo1HtcrEbLWIncpU2nwSon7chnHQOKLMSF3oj7f2uUHdmAaZHm190GZqMQBl
	CRc7Gx8jD7uunO6Y1ehvu61xb3i4paE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F315241292;
	Thu, 22 Oct 2026 02:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CF71F000C1;
	Thu, 22 Oct 2026 02:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792636645;
	bh=mu0ZdecmwjeGyJjNTgvVUayi9FotXs8zWmgYmq7DBn0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TiRT+YNx/lgHQ1yXQxr9QPqsiqcs+RLqLTMqj2gxU/1W5Zq1oC8HSQb/69DNXic4G
	 y18it3L5P5PBtzxYvtYioketNnsK46pvwXIpWdnns//glGGPHZ9KnOcy9cZoYhQ9mK
	 cg8/qoKwkO7sywYEq6QsVPannc9U9DlUryBm+aEnLogO3Tt0N12awaZH6+flVWLLme
	 sVVRCrXQ/U62zZGm9LN2l69bSIxozwgCAk2Lyz3sj9S9SkNohwXqdC1/CyYFWpmi+y
	 mRRXhg9ZhsBtwFbXQqIXvKhOwIhftUL7/Kmi1PEAkrIcV9VCL+Y/UCy/2qefrn71sB
	 iehmc92NUKGgw==
Content-Type: multipart/mixed; boundary="===============0611072890556344315=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <cc14f512d55c6d2db491abe7d6021daee3866b53a4b4dd8659c6d8c3800f4d97@mail.kernel.org>
In-Reply-To: <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next 4/9] uprobes/x86: Don't WARN if an optimized probe can't be written
From: bot+bpf-ci@kernel.org
To: alexei.starovoitov@gmail.com,bpf@vger.kernel.org
Cc: daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,oleg@redhat.com,peterz@infradead.org,mhiramat@kernel.org,jolsa@kernel.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,surenb@google.com,david@kernel.org,vbabka@kernel.org,jannh@google.com,hughd@google.com,kees@kernel.org,mingo@redhat.com,tglx@kernel.org,x86@kernel.org,linux-trace-kernel@vger.kernel.org,linux-mm@kvack.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 22 Oct 2026 02:37:24 +0000 (UTC)
X-Stat-Signature: ucjhbcnp8pgz6b1jneq6jqhu98dnyaqo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C3D2D20003
X-Rspam-User: 
X-HE-Tag: 1792636646-331728
X-HE-Meta: U2FsdGVkX1/eVpEW2Hlst1B+ZaAr051wsg/NcSa2oTmwk0nnJUS76K4jRlPP6ySeGHuYcHcifYRYCvPe+2NKmpO1KWA88IUg37cFAPWlSWhN0h8Uc2h+U6/v1774zHISBqyHIQLFmjl47mR1M/USNXgfhZoy4YDQWR35NaRmINXmwzHjSVx7aL7RCB0Y6s7IZR6ezTo1msbKfMkVJrj8eCdRAdKDbuZiApvxmNiMEJTdbjszS5pX81JbZlpP8elpUfdZ/ItlwivGaqeHgX3E2oFOCJxulwJn+CnPOvpJKvPWm7bDg3/olz2Zr07On5wzXBrZThrwahMkAWR+zpNm8cuWAxHksz/e1ikca94MSJphC/V38OC7YgGk01IFnMfRl8sQvd7zfTCsCXsL8rmoBMQ1E3MYluxGNHPopiRqiScmBsLpDjJijMw/SkOBtIwxZSJLyFhV0l6OKTlduLK3j9pTrKlMNMxkgcEq5k9Ujsv72GHSGvc4X6UDxTpG245zkyLEUplVlYipUYfcy5dpUTHVrA4Hnq66iHLlPLTufYULjON9qYdG3Nov6iUpo9+wDtGFO2A8H6wWgdC4jHcISC2lEw7fXSdm+49yGCQzkP4XQ8QJ3zy0KNuoceIhY9pZGlX703qNS914Bglj1mB/Cp7f6CnLH98JcEdBZZo7pNKcABq8CpVWWRMwCIV36ONt0MpMYw1n+wW5mIcIhfRjW1gJPDdxfEPYgFrApv6fg16i9cCp8A69ej6SxBHY4hgGTM70o8xBVMPmKI4LB242+1HhRKQo8H3Pq+8juoZ1tA6+Ns+2LBtcvb8MzGb11GKyaKlpVx7mwEfnAITJoeOVS9cui2AWedx12DtIKtbjqO+/+IZqwt7m6+MDaJmWKSjgq95UUWL19etTrA3HTfMNiLjJawsy7GHBo2v9/OxCACHuLW97lrk8MQAKLRfIx2Nf8v3+Oq65gm9kiqricX0
 fPeRiABa
 0mE1nzfT071v9mwGKd8PZNXYcI9mcP9d3u8aDKdgvZ/gc0zdEf6yVzSfHOdkcwP0ks7FtVUHByGq5BIj7xNRraZXbC64h68IoBZNc1kmd8vfLoJYwaA2EVqn54sfbuwGXD3KQJdPu8Upn79YbNJyGXQEmKw3ycfJsawBPnhtjKGd6o3H9ac+mhd+lBxLN+qEA4AIUIYZm0n4SfYJMMQg8md0tYCXjzIHQdP9OGk9ah2dhEI87cI8xdy8zebLFOHcNcnabdT/aw6J1apypL/g7wePQq6x45xB4q4QZov38mQLUhG9mMCwGDTqDytSOOYZHSWgKR8Qcfi5aM5e7Hv0RaWfxCsnxflBFFYVI7U2aQbBkR/9ERmF148TEVPpSuQVr7p936H0zm+1depK0r9tBhePCDaODCGMO4SD7TCI04wUxCakA11BIu/7rtG5LQk7RQd5n0W4G9+oZtt0Ujh4Tbo2Hdpx/IcvP5QRndR6pkkpdvjmblK3U+YnWgTf3/z0dVAUaMzfRLTA51FM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0611072890556344315==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> uprobes/x86: Don't WARN if an optimized probe can't be written

TL;DR: Commit message only: it says all callers handle the error, but
handler_chain() ignores a failed unoptimize on UPROBE_HANDLER_REMOVE, so with
the WARN dropped that failure goes unreported.

>     uprobes/x86: Don't WARN if an optimized probe can't be written
>
>     __arch_uprobe_optimize() and set_orig_insn() do WARN_ON_ONCE() when
>     uprobe_write() fails, and user space can make it fail:
>     - -EINTR from get_user_pages_remote() when current is being killed.
>     - -ENOMEM when COW can't be broken, since memcg is at its limit.
>     - -EINVAL from __update_ref_ctr() when the process cleared the semaphore
>       of SDT probe.
>
>     Kill the processes that call probed nop10. It warns in 8 of 8 runs:
>
>       WARNING: arch/x86/kernel/uprobes.c:1186 at arch_uprobe_optimize+0x291/0x3a0
>        uprobe_notify_resume+0x1c3/0x4c0
>        exit_to_user_mode_loop+0x63/0x4e0
>        exc_int3+0x1f3/0x250
>
>     The next patch calls set_orig_insn() from fork(). Kill the processes that
>     fork and keep mmap_lock busy, while a trace event on nop10 is enabled and
>     disabled. The kernel with the next two patches and without this one warns
>     in 3 of 3 runs. The whole series in 0 of 3:
>
>       WARNING: arch/x86/kernel/uprobes.c:1161 at set_orig_insn+0x161/0x170
>        register_one_mm+0x154/0x180
>        uprobe_dup_mmap+0x61/0xb0
>        dup_mmap+0x149/0x9f0
>
>     The callers handle the error. arch_uprobe_optimize() marks uprobe as not
>     optimizable and byte 0 stays a breakpoint. set_orig_insn() returns
>     the error. Drop both WARNs.
>
>     This depends on the previous patch. Without it WARN was the only sign of
>     the bytes that set_orig_insn() cannot restore. Hence no Fixes tag.
>
>     Signed-off-by: Alexei Starovoitov <ast@kernel.org>

This isn't a bug, but the changelog says "The callers handle the error".
Is that accurate for every caller of set_orig_insn()?

set_orig_insn() is reached through remove_breakpoint(), and one of its
callers drops the result:

kernel/events/uprobes.c:handler_chain() {
    ...
        if (!filter_chain(uprobe, current->mm)) {
            WARN_ON(!uprobe_is_active(uprobe));
            unapply_uprobe(uprobe, current->mm);
        }
    ...
}

unapply_uprobe() ORs the remove_breakpoint() result into its return value,
but handler_chain() ignores it.  So if a consumer returns
UPROBE_HANDLER_REMOVE on an optimized nop10 and swbp_unoptimize() fails
(-EINTR, -ENOMEM or -EINVAL as listed above), nothing is propagated or
logged on this path once the WARN_ON_ONCE() is gone.

The other path, register_for_each_vma(), does propagate the error.

Could the changelog say that handler_chain() treats the removal as
best-effort and ignores the result, instead of saying all callers handle the
error?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39710454342
--===============0611072890556344315==--

