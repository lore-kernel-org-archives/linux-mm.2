Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A668AC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06EFC6B0092; Thu, 20 Aug 2026 10:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A736B0095; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50F66B009F; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA6A96B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:21:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C70E1C075B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:21:37 +0000 (UTC)
X-FDA: 85121861034.08.18208C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1F9718000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:21:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QWmvxwoV;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787235695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CxUmKEVi++wyAkDYX6+cqGMVDK0FLAe1j7nQJZ1V88=;
	b=nfhAnfSnRMdV0R3kBDUdpuZwkQ+Gk3iU0DzJoqcKLJq5EM5KBT0EvQA1pVxN9BSth9+ZQQ
	e9LTjxJH+SU1+Gz91L5OUQGQl0i9Vo37L6Op81OTJ0yoGzWfxMxkP4h+cFsQAV2G7RE+2m
	UDZxO+BdLPnOCzL+ohqzotKwPDa++xc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787235695;
	b=j93m1Un31yWx+r4yopoxMYcpzNNNJy2l5ifAuS90+fab4pi9Rd9mMa9GAY7g5uQUX3KEaj
	+l0gklNWRS/y7Gs+Wr5U29CuLuLX3nZboe91NrRyoTKhhzhbywSlq/VZdo/9ba5yePcHrI
	VxBX9kYp50k5mmRP7WOkEz9f/poXTDc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QWmvxwoV;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEEB440B64;
	Thu, 20 Aug 2026 14:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650321F00A3A;
	Thu, 20 Aug 2026 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787235694;
	bh=5CxUmKEVi++wyAkDYX6+cqGMVDK0FLAe1j7nQJZ1V88=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=QWmvxwoVRXwSH+ba8lNb2j+x+lByMTvoH33o9NUzb2tVdKrWD88b14RuMWVl7UBCt
	 Bg3R9xOkIFiVfJ1XfJIqN8fDxc47p5Zq24fGQGS54f2WsNmx9mSVzsVE5clsbuRMck
	 ezYXewED8TpwPhd/6idLkCvtz8MJe8QMuP2tcVoh5X3VyUvamaZR5jlVBepBevB4Tb
	 33w/9A6AkvlaBV9oNz+Yv+gzgcz4IFhYJTUjbhs9zyJg1eeiSyr7lw55xC8SzbYdf/
	 XY1fNXA+Y5YDPi6beqKKX78e1H5SpVPMQsotUG/0HgcfPb51MC72Z836y9F+ubDhDP
	 8MV5hzN6Qr8EQ==
Content-Type: multipart/mixed; boundary="===============2268151016755920420=="
MIME-Version: 1.0
Message-Id: <1355a0a05ef4ae8bf73f6f0392604df78e2d64995cb5e54cea3be01d2cd5e454@mail.kernel.org>
In-Reply-To: <20260820131801.68759-3-tasos.papagiannnis@gmail.com>
References: <20260820131801.68759-3-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add user memory access kfuncs for linux_binprm
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 14:21:34 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: nif7tra175ib79gq7kwe14x7dkfknzhz
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B1F9718000D
X-HE-Tag: 1787235695-572053
X-HE-Meta: U2FsdGVkX1+Gm4lVkM7RgyGxRZbTnDC1AYj/9JzYv8ANvM3E5+K+dZehYSGM65wb67Xe6INNrVYk43JOHF//qbKq01lRf1c/OI8t+2xCg9PCQxysGt0ZxTeHb8WDP28AFgksdg2kXavluW4dvK/2CaoB9HqySr8MpiFiET8bmq4nPd6vfXpg9GBCJklDW/Xg1J5r86xHyO8AQ4mA8BXpjo08RaMYrn5uGOCJUXKGzUN5hUYj+n3Uh39NLTmFOEuHTNIKR9gI+YMdpo/+GqocN0/lbodV+FDWDgWQENwJETbTMgKVhDfNle9fK0Q+DpKAhn9dP73Z58Akm98Zv5f3vE35qHYWqq30Ca4t/q7c9FqjpbsYXsJFvxMXMffoFdHWgtKsIh4NFxDqIHm/8+AoI1FxSScj5xWeClSOiwGRGPpM2PPXVN1pV+RJLfTCav0YElTQjsx+dxR9qj3pGy84UBdtdLS7wHlDYR3r9s+l16KSe4FitOF7ySHqCSvJhe5hxBIZVpT2X5CGuUoixnaG89T+slmhZ6J0HUNnTB3YUqKpwW/Ynr+jirdhKGHlvJs0FJxjznonFB1ADivmYyNaaoeyNiEiQ30uAdHVwwtySzCdMjtewXko7tn2xi1ts4wDOn916WXDIfmbwBXcgNv50ZsxJZMbqD4boHBb7CDy0XOQJTRD/Awel1Z7+K+faMbCpp12nXl3NoaeXUlYXFeywGd7l/byw3iayvC9VKFX2LhXCtvBzhzeriDb7tqSel0iW9V36VPmoWS40y3ly0sr42mSE3GqIOT6boZSw7iiTXKVbiT4pqMZzlnmGH4WVIJZDV76xE1Z6X0UpBYxF9on6z+kBOvZLQ9LoV+euq2veLnvsm5U2bs9FU8N70pgUIPcYCx2nqkRDcwHNX5FfVv8tycSDzRROIG99xYIlai3/hrbRlOxpOMopbJh22ncD0QKiq6ZR/ijWX0wxFqKMxr
 9orasLLa
 shLxOtV4T709I69s/PM/Bn6H/e8+SBLG+mOxw+5Lr8yZ5/s4r7qC7ihUL2AoYvQHs+gJOS3zuJ+aUXfGYzWAYQ4aACWjvxw1QaC0BXA7nrifrMKJMokRZXj4U1lde48N8pm745cBFHU4MQabZEk8zjHcBS7I7zdqCx8G42E2kzK5CrDx8v1h9w2R8sTWGB8KRU2tBlOplA5Bpf1XKXO7ZOnyetxgNG926Ni4ZFeYmTfklUuNPEY/s7lDfBk7fe6OlTaFkKs4FAIHMEOZDs+P5GsWIXdzghNdcUuXMyHT/d2n5UqkUKSolvV7PaKyareqCpvzC3XSpn2q8s3/LRyOqTDOJizBgzdZIHLRRSv6uHsItGmYikgjWwWHluOrwEpVNuPAJSMamf7qm/jBPjTtZBZkuE2bsCR4PI18TcyJwwJGuK68zLGoZCrQe1DkHRt1LR45ObNDOx/e0oBF906ZoxiGjBn3y6Bh7/jlChKOYTkTZ5KEAMYFNPaG26QddP3BBzRXyZ6b8QITxwO6lIfF95Dh9c1RmHlX5gyEvtzef/8cLUZb4idX5xuQnQfbZSjx7qbzX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2268151016755920420==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Add user memory access kfuncs for linux_binprm
>
> When security_bprm_check runs, the arg and env strings for the exec have
> been copied into bprm->mm. The new address space has not been associated
> yet with a task_struct until exec_mmap(), so existing BPF user memory
> helpers can only read from the calling task's old address space.
>
> This patch adds bpf_copy_from_user_bprm() and
> bpf_copy_from_user_bprm_str() kfuncs. Both use the mm_struct provided by
> struct linux_binprm.

This isn't a bug, but could the opener be reworded to avoid "This patch
adds"? Documentation/process/submitting-patches.rst asks for imperative mood
("Add bpf_copy_from_user_bprm() ...").

> Register these kfuncs on both MMU and NOMMU systems. On NOMMU systems,
> exec arguments are staged in bprm->page[] rather than mapped in bprm->mm,
> so the kfuncs return -EOPNOTSUPP.
>
> bpf_copy_from_user_bprm() has similar semantics as
> bpf_copy_from_user_task(). bpf_copy_from_user_bprm_str() copies one
> NUL-terminated string and returns its size including the NUL terminator.
> It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.
>
> This patch registers both kfuncs with KF_SLEEPABLE because accessing the
> remote address space can fault. This allows BPF LSM programs attached to
> security_bprm_check to read arguments beginning at bprm->p and reject an
> exec based on its command-line arguments.

Same for "This patch registers" here -- would "Register both kfuncs with
KF_SLEEPABLE ..." fit better?

> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32375104040
--===============2268151016755920420==--

