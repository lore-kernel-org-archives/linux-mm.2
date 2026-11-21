Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5AA606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAoxKLYr
Received: by kanga.kvack.org (Postfix)
	id A7A076B00EF; Sat, 21 Nov 2026 13:09:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B0D6B05B0; Sat, 21 Nov 2026 13:09:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940426B05B1; Sat, 21 Nov 2026 13:09:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6356B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:09:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3F624057A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:08:59 +0000 (UTC)
X-FDA: 85459912398.15.BEFEC5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3031D4000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:08:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GAoxKLYr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795284538;
	b=gL2j+Rutz1glHCdZJ9jQ5GFCLDbA2E3lv2fWBYqow2xACgD38ZOQwK/bQfFteWa9dJTPzr
	xTj7i3zBv8+9CF7Y276NTi2MeHu2PkSeTPcFDzNc1OE11Lszu/eySwGi5/s9kyIMoDLy/F
	L9lxH/orPfTJ7K6pM+mG6hU+J+bx8ic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795284538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQwRyg3E7Pe33Vv03sibxiYkx4sLjX/viouQjlWqGts=;
	b=xLfj3wMVxltQGVA0yHI1lhjxP9UNhM7Qyu8oaKXAGMLafycqc4SzB24Jvk/qFicq0fK1WB
	UX31hqzkLFdlf0K/afgEgTkdc5mX/7rIn8LMjgu3ZCCgh6RkinN/4VTQlFaNMkqp4IrduC
	f7Gaitt8Y4k6BGYRhgXss9gkqu7i6Oo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GAoxKLYr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 0B33F43D2F;
	Sat, 21 Nov 2026 18:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5948B1F000C4;
	Sat, 21 Nov 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795284536;
	bh=CQwRyg3E7Pe33Vv03sibxiYkx4sLjX/viouQjlWqGts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GAoxKLYrQK7IFGuFua6ECbRxuvIaLcAU/LtOyTkJyBMgl/OVoOkIB3UFrBJPoaINW
	 06FrBQ/2qCjQ22IYvJra+Z5722z5hwRmTbK00KQ3v61xStPRNVjlxPO7nemU02AVea
	 gwmkG7hOxhEQGLr3hywsHS2VtbTgD1qjiB0l6wurrkduJcUxxWvxT3tybEjP+f18Va
	 VMyrA6DGwgMzYdypvhitA+V8eTBapQW39m4rA+yqD14hJBKSj57aIsvB66JETZQdAR
	 Yfk2NDC23mDMeQLS+Mb449IVepANsYGFmy2gRZw4sYqiacMom/Wee57laT8Wz8walj
	 iI2ZpUNq9xY9w==
Date: Sat, 21 Nov 2026 20:08:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 12/25] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <awHeNG3WJrRsyTop@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-13-jarkko@kernel.org>
 <awD0lNmhRPaXI9Pg@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awD0lNmhRPaXI9Pg@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3031D4000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6t76jx91itjehrmphpah1sh1cq4e67t9
X-HE-Tag: 1795284538-295530
X-HE-Meta: U2FsdGVkX19BTNVEOE0faOb7OpGxARIMmDnSHTa5D8FbAhTJ5KjjwLre2tWfy5J5TotcHPxB0cCQSupz3BXxqG7RemltnGjbM2sLrxRBmLAuTAPS4m9V24jOQahX1P+Fyxjex3gn1UXIMDjObGs8qZ82a3TfOnsC2awvolvxQo/SrR2bzEN0MQJqJpYKef/yMoa7OlceCsqbctO6rmQ8qUw/vjetWYEy98NVvynvcpvLfkgtLbuESGTQixge484JEWwswtcnfP29qQYBgzsp3KdqEt81r+3APT9AZsLMfzJnha3aVFP2hiju1O5pnSclFUyUxO/Zg6DZ/e2jtI+aTCdT2WysmfQNLaJeXsA+56FaZgKqK77b11P7K4/qVI1rGlVXRFeU09GlbdNnfjTh5ideJeCco7EeL9+aAXFbaOU9Xe2PFPq3BrVZT9X17xo1uQagW1JRI2xrCQLxs1lE4xRCgaNxQF8mUVS4+rZxoTwM33j/yVtIcQ6pDoMqQrx/aJwmacwaEcV3fe+J7KNVpmNjqhJbtizt7nceBwcvbEEYhNnWepe/TNyhvbGZsrBiqaKIL1QfixfCAC45KKM/FuqcUdHsdwnolTozwcsFLgkvpnQ30Zkhg3nfyLHpsgPMQX1Y7YcAh5bzhQ3sRa6PSHTdqk0Zi8dT/a8esKTui/P6j+C8gkfli4gT86hlxun/98SrMj4RliCKRDv4JfP2BsfLK7R6291RkZImmrHa9FSwVVBTgqN5wHBAz5uNSB33s4TW8KzXqoqnuwCFa5pZv33bLwdmqh7Zj6IObh/CjOWQpgHQButxDlttb+iYIsCPv3iRJIfmXdGu+10WczK/oSTH71Rgj7wpp+QWp6j8LMqjb0TdVGo2ZS0H9KYxlEbUxPoUc8FxuCIFEMB0Dj3n6+l4U6dml3WQBIaAfRDbWC68kDw0haVJgbcLNDeqYz4E3nUnKy6jkamNXJC2VHI
 7a3WbtPA
 PnB349GZjhgjLqRj9+TSMeA2v1DJ8OFT6mFFVJmiICscLaGSvFZtDnclCqY54v2FWFLTCukOb+dvqB1M6VcDiosacAwkB4rha3c7Aiylf5/IrZfZdwIOb5O8oe65l3A2bsOsDFwh1KPjbccUDbpc8PpS6V/yUeQ4B0kqE/kxK7T+v/2KB/iQsFVCaLFlixtV/dfQxsvdaO7uL9XA+fU+f0gYRw2BpQKU46kpNdXV8QrxfxUz01KhVj0V0xb4dq990DJ419G2TGZddvEWNpS5GHeWCHXPGKQVD2RsdT+zw7ku+dnQB0u6BYMC9E/nhbfUuOIFiCl4IYtd9L34C4CGaV71OaTcjTSX4bN20tg0CL8gKoM/gbQhGs2UqyGQ4QESC8gKZfH6KbUC6qVgLNHuV6pdSMxbxjYWxDEpJL5iHcF5GGHSlw1cgftFbQANLalZQVXoHhK1tX4+ME+x6DV8S7ilkDlqr5D3QkJlBE3gmqwA/ktVO9f/W24yEZerdjfASgpnasTcSUwvBYZiH6o9A3KFSBFNuC2rs8Xj9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 03:32:08AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:31AM +0200, Jarkko Sakkinen wrote:
> > A root namespace needs to record its init thread group's PID when
> > bootstrapped and capture its exit status once all processes in the root
> > namespace have terminated, without serializing normal fork() and exit()
> > paths inside the container.
> > 
> > Commit the bootstrap child reaper and bind pid_ns->rootns in
> > copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
> > from zap_pid_ns_processes() after the root namespace's PID namespace has
> > killed and reaped all member tasks.
> > 
> > Co-developed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> ROOTNS_GET_NSFD will be the only surviving ioctl, which make access
> control wise sense.
> 
> This leaves room for ROOTNS_SHARE_NSFD, which would share a namespace
> from host. This makes whole a lot more sense than unsharing security
> wise as it is allow listing (instead of deny listing).
> 
> It can be post-clone3 disabled. This is what we do in SGX driver i.e.,
> have build phase enabled ioctls.

/**
 * DOC: ROOTNS_SHARE_NSFD
 *
 * ``ioctl(rootns_fd, ROOTNS_SHARE_NSFD, ns_fd)`` replaces the corresponding
 * member namespace of ``rootns_fd`` with the ``nsfs`` namespace referenced by
 * ``ns_fd`` (one of ``CLONE_NEWCGROUP``, ``CLONE_NEWIPC``, ``CLONE_NEWUTS``,
 * ``CLONE_NEWNET``, or ``CLONE_NEWTIME``) while ``rootns_fd`` is in its
 * initial build phase (``ROOTNS_INIT``).
 *
 * Requires ``CAP_SYS_ADMIN`` in the container object's user namespace, and
 * when the caller is not already a member of ``ns_fd``, ``CAP_SYS_ADMIN``
 * in the owning user namespace of ``ns_fd``.
 *
 * Returns ``0`` on success, or ``-1`` with ``errno`` set to ``EBADF`` if
 * ``ns_fd`` is not an open file descriptor, ``EINVAL`` if ``ns_fd`` is not a
 * shareable ``nsfs`` namespace file descriptor, ``EOPNOTSUPP`` if the
 * namespace type is unsupported, ``EPERM`` without required capabilities, or
 * ``EBUSY`` once ``CLONE_INTO_ROOTNS`` has transitioned ``rootns_fd`` out of
 * ``ROOTNS_INIT``.
 */
#define ROOTNS_SHARE_NSFD      _IO(ROOTNS_IOCTL_MAGIC, 0x02)

Makes sense enough to include to the next version.

Br, Jarkko

