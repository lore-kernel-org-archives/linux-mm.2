Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073D7606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtQFC/+B
Received: by kanga.kvack.org (Postfix)
	id D8D086B05B1; Sun, 22 Nov 2026 15:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15C16B05B2; Sun, 22 Nov 2026 15:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C6C6B05B3; Sun, 22 Nov 2026 15:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 976696B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:28:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD314C037B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:06 +0000 (UTC)
X-FDA: 85463891772.16.575682C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EE68140003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DtQFC/+B";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795379285;
	b=pCW2ZexyZDDVkoCvvZ20MQVY2siwVh8cqI2HQ9JZqjLT+RfEmC1j313vciGNEonNrGy3lO
	sP3CwhjTDkne3sRI8mH/dmO4ATcgBMdxCcbtPB/INxlBTodn8iQYkmCtRPp3Jv5yf0L8Xf
	/+1kAZtlp8A+K+tJva/gMZLWihWvtGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795379285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hX4n2ELcNNj0/4nHT8RN7SbsIUQvyFqPuov+TG5Nv9g=;
	b=mDgXywQuckVu+ZE4Ja8gP7UZnz7nAFJWwK6ksjd9Ry6Mu8o485P2nM0ewtc7WctnmC0Slb
	SLagjsNqY0g7KI/vNeevqkyfPZu1+AgObzU5ywhZAwdWXPkdO77z5lDglWBjTjo8sb43oF
	8dOcjrt8z19vy3YZZ1aKBle/xgxYhqI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DtQFC/+B";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61C4444781;
	Sun, 22 Nov 2026 20:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579341F000C0;
	Sun, 22 Nov 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379283;
	bh=hX4n2ELcNNj0/4nHT8RN7SbsIUQvyFqPuov+TG5Nv9g=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=DtQFC/+BjIVL35yRIkQAYiez++FX6dq1X7g9+U5wiM9l5aQa2bCiQa0lA2KTXkgKO
	 2GT1VmmiI5zeFd1FOhAPus/+fS4ofCKzqBssX2tUSpnCu5DOjAqzn3puJ0tq8KB9t4
	 GpNPbpdGJuuLtuJfgKRWiznvitvtiWUv388C8tOsf0YN4/CfgUZ1IiMn3x35uwU0Mn
	 1Ao9M5lEIvKdmb/YeWSZ7g4sl3nh/deToqadEqFwGkeoAk1OyDwjyExdU9l/1PjW8N
	 jHMgktO+4YczGQbKoF+Q9d+vLGJmsYwWWN9aZj/3h6aCyWyoR5o2gpSdRDOswa7+zR
	 QEgyW1cP1w0QQ==
Content-Type: multipart/mixed; boundary="===============7306649944735902366=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <b6da91bd7d0e63cbf8a3d96298191544d46afbc7d0ba1a7fa55b996f7d7cd7c3@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-11-jarkko@kernel.org>
References: <20261122193539.3334213-11-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 10/26] userland: Add core infrastructure
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:00 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3EE68140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: wfnzx3nua7o9spz4j6cptp3mzwmc9x4t
X-HE-Tag: 1795379285-341189
X-HE-Meta: U2FsdGVkX18bU9Ybivdtx++1WSztX8D0Wq7TLhvqqm2eKouR8EdWmATobGKvBaKTlcAasI8B1w00gKyk0sqWgsaeRHmNzDIvCoIHO6Q0wikUww+cXOff7IJAuA7a5ujqD+0qJgK46BJrRSs+Jyi80mdDuhKGpdC7dSja5XKHKJnFvRZPxy6v3t+rf1tV3tTskEb/xIwd54jwkZjXtne9Rq5ALJF0JsyRyLbG5ot7XCSZchHlFSVNNN9BAcQcRMwsqCgi7XjEXW1woRyPHLHR+KhRztney61xpp9+A0R/U/axV9/+HZhGMgJ07NRWJZZ46BaovrYhKvUhIgo7SO5YQN0VlNSPU9DpYnzDQguZIyUZXinW+tPoyeHPu56Z6BRNg0Y4xJtdrVHJ+neWzVSohHtxJHFTmL8fyvIY5kle/SHlUppcDSic1pldogTHvzAsgHvkuoB3O3fHApLulVpJghqlhkheF5DLqtzFFM0X8EZEil2eIjsXqg9PQZSMzYXcsFUdbOdfkOB8JuGUHbBwLY5/OcAhLGw1IZvlfE4kVUcQjGZxyEfXOb3nJ6K4CXPoVo2ov+eTEo1dnwTZ/h7uoDMoJEAYpLByINo1NEZ9qZL3NXsBRIgejPUbReqka3aAVoTzi+j8tseKbVTGaiuh85hDWO0Ny9OdmQPv2Ja+Em9EoRytMi5/QoIiq8V6FQl5JyFRGcWtEIaBjB6OSBCzCSuN9RWPx894ALgY41+2pfQdwNX4k/23uFiDkfIWn4uVtVPlBmv+tddsZTHK2CX6H/u/i92CcYI4OeDte8L8JgxzsQlVIM3G4BTNfZPONiq88n6oUAX4xKGcJHN+Ypj41fUfODSAOEJf67dcD4owywsoydLQiWozSsKa695K5hxj4iI4Ye5G+6NX63mi2wCo/Y00PTDNqjprvrFhmBBHlVTkdpbeANhy2vmSciddldrOtYFIYSOsB+7XEtCiirA
 7oqIuptN
 20lTZRr4ruyWCeZDKPuy0LXT31x3tCbJxHLITjjm3k+m59J9p9T4CEEO3vVN2djBXU8Iy6+g+e8z2H0mSpb4pC7xhQcsT4HeoGrse2ZecNRhlxFd3IneA7YhB2Mo4f6CvcO4WeQMEaqwcYGS1Sah2OskAf8pZZXf6O72D4ZR+nSMmwE3zBpwmm0exqk4+VjEgOWA86HwWje+F12UAunKVT8B+5+hrY6J8eV4Y+cXjsACY01XmZF7WSs/xRf960SJxdWJdzIynULmjbhG3Hn8HhVCFvto3H2G7zVN+GAHXBKV5F6NpCTHOnskjqkhFihJY5dnk9a8rOOwx79rZNnOQl3Z8YMu8qeVPgjcb1fFLvr1SN4MK2ghXKAlNmC1lwEYn+rRwq+vhx52m4M2/4LgAn87g+eH0nq63oMgME51wGWyPwLEIJEf7dbZoZCAhJLRnVweEjAJAXI2rCSn6Le9f8kSQ6rD3cJmOJ0aEqMyQmnrcE2fRLtrpP+8XjhLA8BaXERln6Adz3hJ2xOQiGXo+6as5Stl64oDnzY17BNAaL4paCU+q8WWIyKwdyyGhoi2EsvL9y74cofrurUf1vJIn/g8aD5TeJMbJWgEsCIwqOnVLQK7K7pPCYZAHEfhVAQDnInDJfrMhn1xB/jHpVJYtytq7mka+z2nz3888fn02a2rvk1vnStpKMGxeQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7306649944735902366==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Add core infrastructure

TL;DR:
- USERLAND_ALL_FLAGS in the uapi header becomes fixed ABI; adding flags later
  may break rebuilt programs, so consider keeping it kernel-internal
- USERLAND_CLOSE_ON_EXEC naming nit: other flags use *_CLOEXEC

> diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
> new file mode 100644
> --- /dev/null
> +++ b/include/uapi/linux/userland.h

[ ... ]

> +enum userland_flags {
> +	USERLAND_KILL_ON_CLOSE	= 0x00000001,
> +	USERLAND_CLOSE_ON_EXEC	= 0x00000002,
> +	USERLAND_ALL_FLAGS	= 0x00000003,
> +};

Should the USERLAND_ALL_FLAGS mask be exported in the uapi header?  The
later userland_open() syscall validates with:

  if (flags & ~USERLAND_ALL_FLAGS)
          return -EINVAL;

Once released, the value of this mask is fixed ABI.  If a later kernel adds
a flag and grows the mask, a program rebuilt against the new header that
uses USERLAND_ALL_FLAGS would get -EINVAL on older kernels.  If the mask is
left unchanged, the in-kernel check stops covering the new flag.

fanotify hit this: include/uapi/linux/fanotify.h marks FAN_ALL_CLASS_BITS,
FAN_ALL_INIT_FLAGS and FAN_ALL_MARK_FLAGS as "Deprecated - do not use this
in programs and do not add new flags here!", and the valid masks live in
include/linux/fanotify.h (FANOTIFY_INIT_FLAGS).  Other fd-returning
syscalls keep their valid-flag masks kernel-internal, for example
CLONE_LEGACY_FLAGS in include/linux/sched/task.h and VALID_RESOLVE_FLAGS in
include/linux/fcntl.h.  Would it make sense to move the mask to
include/linux/userland.h?

Also, this isn't a bug, but should USERLAND_CLOSE_ON_EXEC be spelled
USERLAND_CLOEXEC?  The other close-on-exec flags under include/uapi all use
the *_CLOEXEC form (FSOPEN_CLOEXEC, FSMOUNT_CLOEXEC, OPEN_TREE_CLOEXEC,
MFD_CLOEXEC, EFD_CLOEXEC, ...), and the name cannot be changed after the
ABI is released.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============7306649944735902366==--

