Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50CAC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10486B009F; Tue, 25 Aug 2026 09:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8186B00A1; Tue, 25 Aug 2026 09:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDB36B00A3; Tue, 25 Aug 2026 09:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9C96B009F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:14:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 280341C19E4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:14:01 +0000 (UTC)
X-FDA: 85139834682.22.7E33298
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83FB818000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:13:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLCLW8Lw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSbPx2tUZbRu/qOn+OqHlNLqWX/99Z1mgi1ERRvrn2M=;
	b=nqdqBdAhlvTiRsy16dIvQD+53T+hKnG1ILVh0kmtx0uTjV2kGLeJjoDMFux02bbGXGW5fn
	AwQdznmatARtAEsIUuiIqQ1pWPc7DPEg3YxbauViUL2+gVjuyFiELCByuKRaHfkob8T4oZ
	Z9cNGQCk6d2BVPUDirOGABstfxifUwo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLCLW8Lw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663639;
	b=0UTIA4sPj9ciG9aQZeAhdv+nY2nA33Jp/7ZeFLGCKo0QBgO4UJ5m5ruy+RHbtx6tZEISFm
	VBueHVhrKkOsrN/vAw/kJln37eIFdOj42MtO4qE8jbrr2QFlO7Snv+IsaJw6jWVp5/W3l9
	fWBloeCvS3ikPfVAM8RCvz1Lo53TeLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA5C041971;
	Tue, 25 Aug 2026 13:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6656F1F000E9;
	Tue, 25 Aug 2026 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787663638;
	bh=WSbPx2tUZbRu/qOn+OqHlNLqWX/99Z1mgi1ERRvrn2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PLCLW8LwKGQQc6+ECUqIuD3meOvOFAgJkXETzVPo81Dd8bahEAa/XTzkoMN1dsdJg
	 SHMu/2cgkDEWxogqG2CUpDmb+Ut3T+ZdgeLbUVA7R3seXSaBKgbYgO/RndyJyMHdsH
	 mTnsmG0tFUlt/DwxY3LYSy2Ft5aeqzMChHUJyskRZPxGdAGKfLK5Td99EwqNK5OcQC
	 Dcwip5wSMg/SvGwDtvcuEi5sYW0xBTjuBlFu/mNIXW3r+sFFOPkuuwgJY/04hoyqdK
	 g95BoWK774XmOkJEkVEW3VEPs2L+uBxBBFRNYojnR13IDarQfhW372LPXGZ3k6L0EI
	 zRUnXSNBCKxyQ==
Date: Tue, 25 Aug 2026 15:13:51 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <20260825-passt-semmel-primitiv-37712c04e6c6@brauner>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
X-Stat-Signature: mtfdhh7eby1nd8w44wh9xn78agnwkhnc
X-Rspamd-Queue-Id: 83FB818000B
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787663639-47885
X-HE-Meta: U2FsdGVkX187R7x6mMs0jNNVmtxXbsFmfXWa46qCwPUAJf8IbSTnIqWufMuFy53+lmjmcKsDVAP2o9P72itDLJje8a2xRKPht6QbBqF5wcxre6N/sCH25GHcw5fj0qGBUJY/9YgJPSY9KS6VIlQ2y2MkjGbRIgMpir3j4RBm+I4udJKvnQrOVc+52wwoNEiRcX5S3mAkmwNRiS57K02HsiI9VDgAtoe17xwL2wialInSyg7zb0pyJ+z7JQgTKTeN9CVojcnDwvIwTMHr9SP9vPPbR4sh61TXwuHmWRv4+pBoLrmiUIJ/Bs10XiAcmqlsJB2vmDFJXAjN/IRz2JFIkIjcXtBkzIWrEfb/FC36vGfnsiDXeilBi0hZnByI/URUexuZUsO3OEGpOHfhmB6jV5mukRPLxGZEI9ZqRRLbss3diHvxBo7tm5TgavhJ2s+44CyKYShBHialXhjq7vZV/okmP42Gy/18WEufXjOe/qwZa1NSiLhttiHb2iyHmDgQUVwLaeDqqfHUm8nds/Z/ij8XUZlv7RhMu0BGWE4QQXihx28Vy0dAJggRY+9lmn3MrrO25HRU/833GEIPqWDrjj4tgHNGgDFQnK+QzM1BpFG4Tn3q6ePMdSStAnA6vX/nQqoVFAVlp4yTNIZLodu+xplfj9te66E+T9Xm1H0OPB9XpSUhfu0py+BnW1Fj8vK3p2acO+9rbrbiqBGLOcOycNSi4oU1HPnm4l1nIRs2jdJrPB6rSujyYqN+g9tej/oTCrj2hgQz82EsbJ+LP41KNbSwWonipMZ8F2OsnV7YcMUsQTiJbzcCCdZWxl2fOnrhEeoM7wr+gCyR3ad6jbfFzUEbjGtBTnJfRJtQU/f292grQchvMipQzAt94NH2xap9lHMh462xTcvu6cHMv81ORohRoBRpzzj+DX9VxaqQfsDFu+iaw3RiRRq2MF1nvhVOqfKl/Zt/6VaHd4deSJu
 ThPmtCij
 HOShiWM7+rYxE6fXDYKDNkRY78f0irw+WwjWHvjBlyZq8KDzzpL66cJFFTtHaL4IB2o5C4aRxjAynz45q9UhaJggFVfJnA8LJ8S2bFWOQAyL7JtR57vw6n9XfLH88s+G/dK/xMHUgiVG2uL7plzz/RWyoq8At4i39M7ABJexJkm7//z5i10RsVYLrfyKf+teYP1/EparjT44ZvSHDu2f/EmfAWZ5h329tqOA5JsjLo2vAkQyFxH1NgShDorzxTGy8W+69wo+SeK0xz4HbCwrGsVEg382pUDN53lwTSIhPUPbyKuPcU579DbN8lAcAPiXcvCK+vg2Go9NTHut+9VtuPcPznyiAfKMu8hXVruXdQlSpSX/iSodlu6hw8+Zdd6oPey8pp6GtgBOzSQ4hGleFaFx77Qf8J9mcmRGNTPwUwjeJuLHYm/jEbXwS5j2BvQH53PGvaQxKk/yow7dGN+zk7FKGhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> good opportunity to block a process from overwriting read-only code in its
> own address space through FOLL_FORCE writes via /proc/self/mem.
> The security_ptrace_access_check() LSM hook is bypassed when a process
> opens /proc/self/mem because this is considered "introspection".

Useful. I ran into this issue just yesterday in:

https://github.com/systemd/systemd/pull/43511

Btw, it's kinda annoying that PTRACE_POKE{TEXT,DATA} still allows foll
force writes even if PROC_MEM_FORCE_NEVER is enabled. So ideally there'd
also be a hook for that option.

The other thing - though not directly FOLL_FORCE related - is that
process_vm_writev() isn't subject to any security restrictions other
than seccomp filtering either.

