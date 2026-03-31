Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721AF1061B39
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D851B6B008C; Tue, 31 Mar 2026 07:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E5E6B0095; Tue, 31 Mar 2026 07:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29FA6B0096; Tue, 31 Mar 2026 07:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADDB86B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:56:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9B9AC3A5F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:56:42 +0000 (UTC)
X-FDA: 84606206244.04.8685F10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5ECD580011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:56:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BeFzkVmi;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774958201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1neFz9KiFuS/ik3xCthmlvvsKLgTlG0ztPXiWCKcus=;
	b=NY+TgqlDHxJ4RphQ8nYDMRyMpC8hgAUTuiodQkmwP2omVv94/FJgsGnPWWqW7vf0K6LcQs
	A8OomDIodAJYRsL5kPStdco/uCjql2oL1F7ZqGRUsOGOQwO9RLYIugCEYEr8O9HdNJyCKc
	sFI1YZZ8dNTAGO+2zHvvIxE2pSmdZPc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BeFzkVmi;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774958201; a=rsa-sha256;
	cv=none;
	b=iwIMFAsBHS64+8HxaayERlEdMxx8tu8xgJvnBKdOaCkb7Lr6a5+FC8BaZBr0lDVu8IsPxK
	uq8syNcrfhBXN/ZGUlCF01tAQrMiHV1J/R4ok8fDUf/BjDChbdQbomhS3ft5TKMkTAM4xI
	DD+wbKZv0JKeQK4tpgEmaBGWLFqRvf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9587060120;
	Tue, 31 Mar 2026 11:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D835FC19423;
	Tue, 31 Mar 2026 11:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774958200;
	bh=FMyI+hF8rpe/NqjE9yc1wgMGr70W/8wNEBMJNTw+CEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BeFzkVmimymyHmwLsFeymfxbRTc6ipv0ec8kukVBw1ecHuDomyng9YcdVwlB3yCVA
	 gMhNj9hx34sznU4d7IW98tdbTZso9CJzekFw6KtSOJkMgE9WVoSmiTS8z+MS6IpcBx
	 Zg5quKZqA1NNKn45/Pru6/3DPUyVoYnWlTPpovD/W9YzFUuTt4tKY8cUysKZsTXote
	 rlCwBOAK9KcujLxnXXZA3D7vxwSBlf+oOjauq2UjEiknKs0+f32e5gofoE2thqtaDd
	 TT4fID0wuhtNCzQ7mEfPS0UeNYIVYnsgRkV9Iw1NwN6skPK5kLXJghhShlTOC8s9Re
	 LepzmQCuei9Eg==
Date: Tue, 31 Mar 2026 14:56:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <acu2cpUBS0ahkgkx@kernel.org>
References: <20260330202909.136776-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330202909.136776-1-devnexen@gmail.com>
X-Rspamd-Queue-Id: 5ECD580011
X-Stat-Signature: iwupojrgps6m7rfmb3gaqq848wnc56qc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774958201-47929
X-HE-Meta: U2FsdGVkX1+6A2VAoZBXvUcEZVYYc4RJPdNgVysYUTrl3E5dtlRbcPMz7hTdG86mtM+BWcrCV7lf1JQ8Q2Lm6MWxzssBgHUwtZd7LHewhkGvMis0k2MQmWSGuCXHHD6vvc4y+3UVmKeepM69J1raHWW09Pvi+YStxBb8DfGvHvEJLql3E899JRhWyYn6TdHqixQEvHY94q1K8Uljb5CXKJ0+/Bo3fv9M7Vj2oDnQNnC7A96ce6+8ObB6I1LuzVrNVP3LWMiXo+T/OlKZCbsgsMx+OXlGtQhrK6OnlCCKDh99FtL/wjmyyexp6Ng3XVTmRUE15jm7zzH96HjXtbBCtmpcCIDl0I7rEAj3xfru1oODrkOjrHZGVIT7kJ0tt7+cIiY4oq0xRCzhGbmb//ya7Nk1TtOfTEF5JyCLbmEWSuQjZQaA1Vq4Pz1rG0fNoco0D77HMw2RYkj6yDkoyUu+O1iqoA2rAqC1hk5x8kdlmngoglw19t36jhARtP2e3SJFis7tYHWT0RdKuO8g+AhzhE3PanUbHekauMqOIR0473ycNcpMxKwVl+vfc5t2SakV6xQAOdzTcQ8RhF7ytfWu0EZ8iP5Z7wvc3rWhRWGdui3k+FLk+XkQ7D5+vIKkjSf1xiY+qTOm2fcDB2VwMg7fC3d0uznW6p7BuOwrIXO0Lz8HWUQ9lG25iTFo0hUJ7Hxpc9NrQ4NqemIRiJ/3VIGKXmh9na/cSNZmtibVTqrGasZ+TCtZTe/1A82ac8yktSiburY8rVu8ZSLDwnVFOxg0UVCvfeGwr7KMeui4mhcpYAqts+OKLsGC/H5v3g/airs5C6KollHtVS4/xveRrFi1ysXtL3A08rkR9qdwrT8rzuDnLzQZK07mphFF2hyrWgCY89T/zqvZbEwjj13/sqYE8As7Fnx8TeIhINvUircTb8A8L5uxg0Xk7vhYrp5cRwIMOXdC6sZMHvRnYFo4N9v
 bMRs42sh
 3rtnlliLh18Fkb88Si1ji6cjkOpwylbrxk8EP65MUIXUTJ6axY7STRzSWIcLph5lCCxui/EIZ+oYdiGO0yDoAqaS6DkcMQmROhsdFh1yyhEGUg1h+pSU5PRPIjhBIqD9GF+nZgXKZ8auIYM1KHaKMtjzGeLg+C8DELar4tE+pkI6F6U4O7S/iVx6jlq08QFvdo/gZm9uLSR1x+JuYDIkQsYA8HqXuN51AB7hxGbSrSUeAINBXmK0MEXHhQRvZSSr+CYloRLJr3iCmWpXMfsMLYesaG3aKP9cs1DmARMzv+MN75e64eS6Yq88+QCG0pk0g89LhaWrm46lkwqYcI5niPBTx225BX6B62u0MLPcO4igFG50sEeJcg0PNdmyK66NUYO7M4ksHv7nVM/YVoKp/cYaS2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(added VMA folks)

Hi,

On Mon, Mar 30, 2026 at 09:29:09PM +0100, David Carlier wrote:
> In mfill_copy_folio_retry(), all locks are dropped to retry
> copy_from_user() with page faults enabled. During this window, the VMA
> can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> another thread), but the caller proceeds with a folio allocated from the
> original VMA's backing store.

Is it possible at all that after all that dance vma pointer will remain the
same?
 
> Checking ops alone is insufficient: the replacement VMA could be the
> same type (e.g. shmem -> shmem) with identical flags but a different
> backing inode. Take a snapshot of the VMA's inode and flags before
> dropping locks, and compare after re-acquiring them. If anything
> changed, bail out with -EAGAIN.
> 
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>

Sashiko has comments and they seem quite relevant to me:
https://sashiko.dev/#/patchset/20260330214948.148349-1-devnexen%40gmail.com

> ---
>  mm/userfaultfd.c | 64 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 57 insertions(+), 7 deletions(-)

...

> +	if (vma_snapshot_changed(state->vma, &s)) {
> +		err = -EAGAIN;

Whatever we do verify the VMA this should not be EAGAIN. EINVAL or ENOENT
like mfill_get_vma() returns seem more appropriate.

> +		goto out;
> +	}

-- 
Sincerely yours,
Mike.

