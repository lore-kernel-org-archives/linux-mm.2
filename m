Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05706606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TpcNti2u
Received: by kanga.kvack.org (Postfix)
	id 1CCE86B05B4; Sat, 21 Nov 2026 21:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BEB6B05B5; Sat, 21 Nov 2026 21:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFEF6B05B6; Sat, 21 Nov 2026 21:13:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAA4D6B05B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:13:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48523140641
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:44 +0000 (UTC)
X-FDA: 85461133968.10.69113C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF1DA140003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpcNti2u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313622;
	b=0eJrqcihT8K8oCC/mL55nkW79ZBT01MhvHqLVmXQ9/HQ/6n/XGdcGzSkhuMB6AVTGucD76
	528K7nbTjoXokvYheeZN6vGHpzrH3BL8SUtsWW22y62V84h0EUTMnGYi4zNZh0f9Mtn1vD
	DXJPLr3XGnzHzsJJzC664oz/ZKjaaO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBzgFQxfDK4iLWmYyLcERpDKYI+EngwvDO2PASCaLKo=;
	b=yJv8qd4Y6bkCai4fyPaid/02+pxtFlof9xI207xfHWG2SX61ttVAJcvbW2VVYUs09JTyer
	VfTInTKbHEsAXDNUhBWe+CrAQj8B1XWrD3iTBKToezJSVt5jDK/sux7fi9ZwU78IbE/iWy
	ROuhbwXV+g8AVJ1qUlqRsJRhQH0pVNk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpcNti2u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D81F60181;
	Sun, 22 Nov 2026 02:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852201F000CA;
	Sun, 22 Nov 2026 02:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313622;
	bh=fBzgFQxfDK4iLWmYyLcERpDKYI+EngwvDO2PASCaLKo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TpcNti2uw/g3I0rkQsslyB6PuY+0GdpBgwPbIyrud8im9z4Yv6rEhMrXaS8RxcOR7
	 DfhXKjvvkSFEeMK2x7O5+XlkT7rA1wCstza/LGnqT45DanBI3Ma1k0ATma9TjS8ql/
	 izYyUyb9Mvy27cBgWCGTZE1Wa61QIocuwKPFlmrlzy4qbrO8YTCcuhqeVh/p8Wz1zX
	 vbXeb+akhaKCY0lk977DvNA4jPn3BdA4kJQT4P4PqDqbZIsjH2JvNmHOd1POz6usqw
	 GXP98O7f/pcQgYh6fSbaSHWkWGoqiSmEdVJnTP2Kb20jJev/IcuOBrsnHeTmXNY4FY
	 BIWfOcDLccv7Q==
Content-Type: multipart/mixed; boundary="===============6662202981018923107=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <e38bde24044ae1f3535fd4708ab53f7e88a826f4ca42f83f2a6429f84240f795@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-13-jarkko@kernel.org>
References: <20261122011809.2667684-13-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 12/26] userland: Add userland_open() system call
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:38 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF1DA140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 9pj6jzy4bhw3jauxhhh6iccir7fyp3ii
X-HE-Tag: 1795313622-738416
X-HE-Meta: U2FsdGVkX18TvtpljGZFlUW3gqcFgCb+qDMsrXwFrx1PfrSDS8eiJ16YOd6WbPz/nHn0afKbO3e+wUM2ITmH2dLr/7lccnoSAdGX+ffhF7tbowYU7Prb9BvxPd1klCBvWaaS8GkjAM4wnaBDpTn6ha8LfJoGLT56q0F6nHSywxniQn/lUS90cRF+XBGQH+TrTZinxBHgKZxcXwEBNWdK0zLrbyTPlE3JnJ+oX9dtkbP41Eu7Ifj1nYelXfAGKFupNQ/7IGydfc3JOSCipPS5k7h9L8ddONJttqSm4PyGeGSMn9U5WvGRrXejY+qkBCCBPWaps5xGKTpHH00dVNO485Qq6bdbiLlLMuvaSuLgrDDhcHYGFYXmfglr7uEAdXl3mcMZQUrR3UcBiT6n2QlPcQr2P0ChyBtS7ve0QpV/gZDmC29Hp0tED2qFP/vXrj7iWN0yXeBQ9xctf4LlqG4vwsSkF9KW6+yMxB8FGXJQqH82mG5Gk7UYTGi/9pvm570Uv4Y3Z4jL6QfqjeluqvK2Vzsyw8Pq8NW75TYl12iAYFlGRpbTvfZ+te3UoRSl0Nx1tZdEb1a5Xa1FLuYPc5kHDsEX8FuZIq6WKFCeRiSGKkRPOHS9+nMMqMlJmJ2tSA6IYba7uv6jE4eogss6sr3uXCVdISvE7CbDDYuGk2XjcbljxLsjSwiFoe/sgzEt8c5hAjxDp/NbUyAwAyU41fUdXAnV4dokld4SEXSspp48h83WKeL6gtwJN6H5WLYBuUNnQ9nb4851tfwYAPijQvtxxjJiOYLVtrS/ZrATbTryyQaVFRQgknCWCHNf8SZuBiV5thjyeYzT7hCnQj7IYrCqgoMkKGiTlUbU5E4/TUpRlxVn31XQjia/weDPRqYGpt8SdSM7+eeZPV9l3tkdzHV9GDOfa1x5yAS+g1oMMxPIAZBiDNAxC/0ZsRpECEiQBphVco0JtVPBF6Fy4vGNQoA
 0WM3aN5P
 978YT01K5JLTU2qMmcM3Ns9+mZhy0Ecmc889ImQbq/LYP9W1aVnwTt7jHy7Jp88CM54xwDK+9hHBZdumOIXqdLcbnm+UEzVAR2qSn91ey8YDQ3QZblaWCpKWRNslMv8b8n6TwfgHU+uGBUAzyqYIPWJ5/9USxkdBSRpaXf0A/9lpPcGyrzA4eCnDoqUp61WPLrfwVc8ShSLyyOvFI/DtBXJGwwV+OXHiB3IY6VzeJU77Pz88vlggB3jZf6thuNf+fpyvmGxB/7ndGLMFygqxytYSUquBpY+AbBW9/jpgthIPT5GLiWY8Ug5+qF6G6syfE4gDFc2GtRPVoqloX1LjdPxbuU56a4msYl4yxq4Vo6sb3GJUjFHoLxc8iIjYLOati+ooGUd6ZTAwoa8j8LOIA+7Anu/mDakhBEZHgPWdPoZXAzPUZY8KVj/AlogpXgCmPKThX4K/swAqPGXmm9uw+PTjb++yF1ZWEfX509SZl44AgmmAnFG70CjokIfBc62taaS6e8XNNWK9AOb9acOWc6bqoTq73FZ7CX2yr7doaO9vf9UbhZMxj+EJE13j8QZ9GgUkeSs4QC5EJb/5V+MxLuGmG947HRNah84XOIM4SthPMVf4ocYBG4RAKR0otIh6NVnhWmLIXeDnuspYYJhN0WNXZN6c2elnnA47A4eAxV44CH1N277aRZB1Et7UfdzwPpjv5U/vfx39ZMy/iSJeF2siI4jSR/TSsLNMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6662202981018923107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Add userland_open() system call

TL;DR: Nit only: the current->nsproxy NULL check and -EOPNOTSUPP return in
userland_open() look unnecessary, since unshare() and setns() don't test it;
could it be dropped?

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +SYSCALL_DEFINE1(userland_open, unsigned int, flags)
> +{
> +	struct userland *c;
> +	int fd;
> +
> +	if (flags & ~USERLAND_ALL_FLAGS)
> +		return -EINVAL;
> +	if (unlikely(!current->nsproxy))
> +		return -EOPNOTSUPP;

This isn't a bug, but can current->nsproxy actually be NULL in a syscall
here?

A task only loses its nsproxy in exit_task_namespaces() from do_exit(),
after which it never returns to user mode.  unshare() and setns() dereference
current->nsproxy without such a test, and userland_create() itself passes
current to create_new_namespaces(), which dereferences tsk->nsproxy
unconditionally.

Could this check (and its -EOPNOTSUPP return) be dropped to match
unshare()/setns()?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6662202981018923107==--

