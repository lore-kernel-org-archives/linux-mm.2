Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8217606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GC/IuWKz
Received: by kanga.kvack.org (Postfix)
	id F1FD96B00EF; Sat, 21 Nov 2026 20:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1186B05B0; Sat, 21 Nov 2026 20:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7626B05B1; Sat, 21 Nov 2026 20:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD41C6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:57:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40678405DE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:57:02 +0000 (UTC)
X-FDA: 85461091884.17.5B5F1D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A661D140003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:57:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GC/IuWKz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795312620;
	b=gm9yKCm1XrTQLcldXbVW+nsRTpcq90t4t7F2KQmlAV7hBj5hNWEZ3XC0Tz5hxc6lNd4Rnz
	n7HCXTgh9hVZ9uPdaT3MmbMDtClSTufUcGV7P50IWdTvQcZA1VbBX52dbRjZXaYuIu4swm
	izq592Lu27HQs4UUy7R2tlSpKTZXYGs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795312620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThwrOz4KQaf/68vZr/EK5L1WefkBvf/yK3CtlQ1HEo4=;
	b=AwOEPNE9UC2gplcjiFrf4yH1/e3vDL8dzInp2Zyl+TI8/QlPuJQRcrZLUupk3fGbYM+bxD
	Xopryszg90SqGu8pBSk2HazBCTqNNnX+yaQmvkudX8ombJWsSaYc1apcZrPiRrf+hqzgRl
	oE/Urg+J4uzhkWL4POMCPjjU61ZiNKc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GC/IuWKz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17FB460625;
	Sun, 22 Nov 2026 01:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABEF1F000C4;
	Sun, 22 Nov 2026 01:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795312619;
	bh=ThwrOz4KQaf/68vZr/EK5L1WefkBvf/yK3CtlQ1HEo4=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=GC/IuWKzdP3XPrZY10V0RiplZlejXzbWqHWY2QaOy4znVfE3YN5fkGAgzUnxJiKVi
	 SPLiEY5c8KMToEo+eZ/6XZVlUDB4rdVdhYv3Bd3S7cwuW5JxRQ4qJm1JPiKn1EtnXq
	 BOBnnj3U6wWLp2zpdRigdS5yMcgJ3q0jI4h8LsJirUNb1rQi55p1rxggbTdCWzVv42
	 Uo4cPxRFR53JJuCkEghXMu0Iz2lXAlOWLxU3GdMdcDrY5PYQDRu8yP+kBww+bpkOUj
	 e7YbUHBNXVoPyB5Qxq4Ve/oGeOT/tplGDKuacxwSvtew1eVp1UBxIfzR0tUg9cMXMw
	 QofJXhNKIHfqQ==
Content-Type: multipart/mixed; boundary="===============5046235082527952735=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <99f64593ccffc93d735505cff682eecae40a6671b80ad7485c078ff8f335a214@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-25-jarkko@kernel.org>
References: <20261122011809.2667684-25-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 24/26] docs: Document userland uAPI
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 01:56:56 +0000 (UTC)
X-Stat-Signature: cjnkk449ia9wnbmw846gjn3u93kw3dfu
X-Rspamd-Queue-Id: A661D140003
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795312620-949543
X-HE-Meta: U2FsdGVkX18c3JqD01e3P0vWbauwKw4QBNViryQnNpHDj05mSqtnrWPQghPRT1Cz5z2AOqK/+PNNdEWdwLZJoFWBH31FLLYrLohOIkrqk4n1GQPsC6/OcGCS2Blr+6OK+GhlE88S/b1vw36CCdLlIx8GUZSjiBs2xxbCbjd1uJ4hS0f27XjSVlGBeZqewzGW30d/DZ64PMnXn/lcIcCwamiZAupSNtfYoc8KOhGdIOTWwn9xduPEXg92iIZMlOA31bhCvwwCFVEVqCD5fxJH1hQdQ/gMNOfXFOd1Kr4LM9MPWX4W4IOLpiVeAO66NiQ/DIan5ipNDeJzKeWRG+yn5x7SPvSXsJeylJBTTzXM7DLsxb152mq+5aOOlHMD5xTaTcT1i31FLnPsQbRExLbqrIe9ApkbF+t1E++YE5BRXSc8GioTdKoHHY7NL8GMj/FCQ/X/ki3Eq/Jtw+1q0t3dEe7P8ivPHswvNd4m5DW9U+OjD/QReS2HTTbygNAeZnNRWUw3nfOKYtSZe6tF0v1kMcvqn9Z06woTYu+wOjrYiHUFNCKC/RxTLgGohCUGcdbHMruNUuuRwmwz5d/v7fCz62VzaKc9uxdd55pzIA0hTRq6hXorPFVuHAkho3OKFOL/T3QLtfSrI+hZuvq1DtCBGD4kCM6sXJaLJiCLSuhrSFZ8vkv9BxRtZHVpnOG+ocDYZMvChldGO+SXEU7qHv05O3GPLkHdMPInBZQDODXBxgwMI0GoVZZAUtS/qfWnCk2SllL6U9PvYiLMJZl+b5TZ0zTuXjv1RF5oROlInkzFugnRh+dZgIqkBPXvTbOhi0+pLo4TtZwx5WHUVb//kQwWd1vafGcSeFqB7j4KDTO/5hZtAXmk45KK0pOoX+LPwj2lbr2lBnIAnpNRRL4kbz555DRQ5NLGKSoadrmkJnLKsgJ8Ed2wz3Y8dR1ekegNdtJiGWJMMS0SGPCaXqmWZFD
 dAWl+cVu
 BpppL5xNED4lt8LoyfflSs4xSSK8lgrKM8ssWGlGCxLmVy49onfRrBJzFw+Mh6ZbIh6ohf7g7+Ja/wHoG5T7XdeDV/gR3xfvk4Wez7xXXh5UMSjQDGbXQJ5D58V1gkCZCLbpL6tnDf+iRDwey9if0Jt/yR10TIOiE4gqyGCj6IkMU8pxv1srI0ymjkIxGBV/BYp8o3KY6Dcvdxc0kU7aHk0wl6McmI3LnXCnfD3gAx6fbawWo73p8tS3oYq/0+GrcnXBKX9QWcLpIzZDIGVuj9HI//1U8aaJmgY/ODcAM0aRY/y12bqOnJMXk+ohBoxl7Xt9Jk8dSKWBkPg/K2POvAFO3zun+8034WiQlLGxdYFqPMJpL9vgpx6ThEs3gbZxpPman/W5AToNX2XMzu9KyD5KcOaXAXYnmpkzjb/3qtburN/SRs3Vlywv6jv0RwNEetoziaV5Bu2DTtEtgO7vxhqHAGr4vyTjKjYo3J0uSPQGEwFHa1f/Vqnjy5/odGE3UiSVvgeY5+c7Bh+/UFxHxX+XJZPArp0mxVYJ0TiWbbNn9DyB8b87n+tgleBvUdCnkEWgvf+A4fykCeTmEneWMdQ2/TrhckBA+S8Fj0SZjCG6FcH/DUuwxJ/m5vdHIkBU63ZpRD2Rcq6OCn8UmqznVC54VrEU+vy0AKML4dh2Fxgj0ZhWFhVovFXCswSi8igiyTheyQiLVfhm+m4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5046235082527952735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> docs: Document userland uAPI

TL;DR: Documentation only: the new userland uAPI doc never defines the
INIT/RUNNING/DEAD states or their transitions, so readers can't tell when
USERLAND_SHARE_NSFD is allowed. Commit message also misattributes ioctl docs
to nsfs.h.

>     docs: Document userland uAPI
>
>     Userspace orchestrators need a clear specification of what a userland
>     is, its build and live state transitions, USERLAND_GET_NSFD,
>     USERLAND_SHARE_NSFD, waitid(P_USERLAND), pidfd_send_signal(), mount-tree
>     construction, user namespace ID mapping, credential rules, and process
>     creation semantics.
>
>     Add Documentation/userspace-api/userland.rst to include the kernel-doc
>     sections, ioctl descriptions, and system call reference from
>     kernel/userland.c, kernel/user_namespace.c,
>     include/uapi/linux/userland.h, include/uapi/linux/nsfs.h, fs/fsopen.c,
>     and fs/namespace.c, and register the userland ioctl magic in
>     ioctl-number.rst.
>
>     Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

The message says the ioctl descriptions come from the listed files,
including include/uapi/linux/nsfs.h.  Is that accurate?

The only nsfs.h content included by userland.rst is:

  .. kernel-doc:: include/uapi/linux/nsfs.h
     :identifiers: userns_idmap_extent userns_flags userns_idmap

which documents the structures and enum used by userns_set_idmap().  The
ioctl descriptions (USERLAND_GET_NSFD, USERLAND_SHARE_NSFD) come from
include/uapi/linux/userland.h.

This isn't a bug, but the body paragraphs and the Signed-off-by tag are
also not separated by blank lines in the message as rendered.

> diff --git a/Documentation/userspace-api/userland.rst b/Documentation/userspace-api/userland.rst
> new file mode 100644
> index 000000000000..47d5c39ccb1c
> --- /dev/null
> +++ b/Documentation/userspace-api/userland.rst
> @@ -0,0 +1,73 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=============
> +userland uAPI
> +=============
> +
> +Overview
> +========
> +
> +A userland is an anonymous-inode control object opened by ``userland_open()`` (not
> +an ``nsfs`` namespace) that binds a detached namespace set, an initially empty
> +mount namespace, an owning user namespace, and an init process lifecycle across
> +build (``USERLAND_INIT``) and live (``USERLAND_RUNNING`` / ``USERLAND_DEAD``) phases.

Where are USERLAND_INIT, USERLAND_RUNNING and USERLAND_DEAD defined for
the reader?

These states are not in any uapi header and are only used inside
kernel/userland.c, and no section of this document defines them or the
transitions between them.  Yet the included sections rely on them:

  USERLAND_SHARE_NSFD works only while userland_fd is in USERLAND_INIT
  P_USERLAND waits until USERLAND_DEAD
  USERLAND_GET_NSFD for CLONE_NEWPID needs the init to be running

What moves a userland from USERLAND_INIT to USERLAND_RUNNING, and from
USERLAND_RUNNING to USERLAND_DEAD?  The commit message promises a
specification of the build and live state transitions and of credential
rules, but the document only has this one-paragraph overview plus the
included kernel-doc, so a userspace reader cannot tell when
USERLAND_SHARE_NSFD is still allowed.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============5046235082527952735==--

