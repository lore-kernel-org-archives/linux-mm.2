Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964DB606A6AD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aTy5+RVI
Received: by kanga.kvack.org (Postfix)
	id 8ADE96B05E2; Mon, 23 Nov 2026 22:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860406B05E3; Mon, 23 Nov 2026 22:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C676B05E4; Mon, 23 Nov 2026 22:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50B296B05E2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:59:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C87E61609F3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:59:00 +0000 (UTC)
X-FDA: 85468656840.13.F3B144C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2FC26C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:58:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTy5+RVI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795492739;
	b=rolusGOlYFemTNh4BC9UV80lZKc+vJ1hhWckQkHR4JsGEXqsZCYZNk7wqSJuTWRk/NECUh
	a9L5j1LJtpm+t559oew2xHS2WtbDcCx03eLQ6SSmljAVNvxq3J3rDDB0/fL/rPxWfFMLSQ
	zbabO42zvOdzSsl91TF8Sb5g7HR06QI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795492739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NS45uIMLO58QIZFdFsRqQwpuveO9a35GIgn0ekSZke8=;
	b=IBy+8qNcla2cwMXG6sAZpk31kQaVyg6do6+LU39dLfX90wyMCw9lDmpAuD4ZwvcB/sKcU+
	TXhdHqXI9pty8yimFwCAZw8u4cp5kd9YifgQa7EvWTMPMnco84FoDjOniEsnPAOND1rOao
	wsqiJnGNVIvbz8hrwlmZBItQHHnIvcA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTy5+RVI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 1281A44FC4;
	Tue, 24 Nov 2026 03:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A6C91F000C6;
	Tue, 24 Nov 2026 03:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795492737;
	bh=NS45uIMLO58QIZFdFsRqQwpuveO9a35GIgn0ekSZke8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aTy5+RVIdr9BQCwJGNCU+JGZNyIuBkeW2PKcNU22mYFHbK02ep8bNci6jVvu2FCjC
	 mWD0vUNBFxa16W5/KVosNO/h3a9BHaXz88hq25B1gm3Zqah/8hjvcSRZXUfBfkLoGd
	 Lq2QZT48f80Cew+fSSoIoW7VwpGEA5V5tWetW2qZ5rC3QM8ebIt3fnGNCa/k9PNyiv
	 NjXdmCWJsT+P2rZTLcXiveeiQayLn2A4pDDsqdPMUVibLOmgdiSguA2lhUHpOS/zcY
	 Mob1v+oAmz4/cXBraQV7HBSKGBYGrScyIJwnm6LX73iBJi5oQWeFb2pivVAFOqfaIb
	 Ue3TCbDSwse1A==
Date: Tue, 24 Nov 2026 05:58:54 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awULfmZR-pESj2EC@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awUGkYoyDXp4P5LJ@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nkfj4n6m3q14dakqrpome6rxqmq7dwtr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FC26C0003
X-Rspam-User:
X-HE-Tag: 1795492739-843906
X-HE-Meta: U2FsdGVkX1/zaCUsoPREAee/OjnjS+q/i6q9Yo3Tmh/0DghKgYmLzRhSUm9Llpu9VcE6Ai1HoOjcEumrcVELLZyy0pITgib+oDtqF4Z2RkVzMRuNs/T0yTbw7U8a/ZdRcEDs2thLs7sikdmZE0LMNfQiKkiHSnxp/50Ux5xwFxXfINtUukFvOPAc/Gv4PdJCVFmL01oNL7jUrP5pAUV6EYvGbExhjmbJVEOybgRyOWs8TSyLet1I6+QI2xPNe14xLEFlIxNNDfY/cCGH+ieYd2s/B0m2pCtyMb4Xt+/xIQNFL5O/Gpklm3uv/NE8XD4k3ISDXSAdnpdIl+dJTCYE9zvJwM8eHtspn7GTHneTsuQXY+/zJyF1hLfnXi1aeuOA+qpMPCfe0iBWk0qO64LgJWix0Y/02UqG/PlyjscPeepcQBW009lHqmch8ttkw8P4Djj5vyTsHdhXxxWlml417O2hlVw9rBcbH9YlR8glmuuZFmCvTkVYJXZ9tsjTy9/+FivXxbMPo4ChcPEpkIP18TnvGU6EW0fmlMHY2Q6bQ9I4y+gMfsXmHh7/UiiiudoGq5sb0Vuui350XuKcwRXYJj+zvnAoCExHCqe02CbcCfQBj5Zs98WUPs9NQYbxpwZaB/sqsY7TWvRB7c8w+lwwOhQJ6xv1aigzA74vxJvBn7AVnORss34BlIJwriOpueqxSVf8GXjBrBP8t+M9xtbgU9NtroVCJ1xLj/hFDdQ1bMfk7OxYQ0eiOZQbar+3C2nOPKyVwRInIafU7ekPxnCo4Qq7B0BRtWiC8ADNvhPZMmqz+FZOkA26Tu1KSsnERHDQaIejyCrQSrhf8xZe+RAcgXPtIIicNcYm67ZRJkcuAQ/srwIIi5QyszdzrQ1ExXSxIuxT70uh92iwTcUcBp0xBtAfoYpmi9zNPeAujBz5FhwX6kE2p2LC1VoaAKd5r0CeSQCkEhxZfdAez7wCPHP
 ZdIeJ7Hi
 fh46t5/4Y4pTbnmyvONEaVtnRFuX/TNdaHpTwjBoe8zjc0wBlEW9xQnhmxlR1lmX87oGWTB02yCP8cFuqX5Ds6xegpHOV8QuWhHt08j78jEqotB4GOYd9ZXw1U8Dw6REkjcb/taUnRflqKiEUe2HnrqKUiOf9qZzhZq3AJuj80mF8UA5VAacx1/3/fCnHPigbWXCnB7FD/NZkF8k6BwLGexGPlkDxKGTyHpuOJFxJP9mDXGtfZMYdIYMXJhmkT0VDt/1BOjB55f3VGrKd7mgfRtp8067m5IWCyPN7gT+C/pAQql2Cevb9YgxP1MkeCzr33z3t1ysTmWwM15pmfJSh7k9xtHez/xmZ6e1L3LdJh75QjaZoGFePfU5FIMZl546gzW6dPFb+nBpzXkqLryY61KY4NXJleh6WXG13TdNnK1aTTrU3Ju6MadLqB43lCtzehJ1qTR/mYEEoEaE8jCqzZVqy+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 05:37:58AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 03:28:19AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
> > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > SYSCALLS
> > > > ========
> > > > 
> > > > Two new system calls are proposed:
> > > > 
> > > > 1. userland_open(): open an opaque staircase-initialized container
> > > >    object (modeled on Intel SGX enclave initialization with separate
> > > >    build and live states) with no embryonic state, opting selected
> > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > >    extents for a container user namespace in a single atomic system
> > > >    call.
> > > 
> > > I played on patching systemd and userns_set_idmap() alone does already
> > > a lot of good. I'm figuring out userland_open() integration next.
> > > 
> > > For the test implementation I probe the opcode's and dependening on that
>                                             ~~~~~~~~
> 					    syscalls
> 
> > > use either "userland path" or "fallback path".
> > > 
> > > This auto-probing is done so that I can commit the patches to my kernel
> > > test harness, which already has systemd, and try them out when built
> > > against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> > > 
> > > The project builds a hybrid ISO, which is a bootable bootc/composefs
> > > based operating system, and has toolbx bundled i.e., a reasonable test
> > > environment for all of this. It is also device-installable via "npx
> > > @puu/install"
> > > 
> > > I had to level the harness up a lot so that I could realistically test
> > > lockdown-hibernate but it is is also pretty good emulation environment
> > > for any possible container features.
> > 
> > Kernel is ukified and systemd-boot is used as the boot loader i.e., for
> > kernel testing purposes corresponds to something like Silverblue except
> > not using GRUB.
> 
> Experimental systemd patches:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/commit/?h=main&id=e4d6b15da3376ad09c0c575cedf467f69db32a52
> 
> The patches are layered per syscall feature:
> 
> - 1-5: userns_set_idmap
> - 6-10: userland_open()
> 
> Virtual device would add path/mount complexity and generally dependency
> to mounts i.e., I think it was an awful idea. At least initially this
> feels fairly lean way of doing container things now that I've trialed
> systemd-nspawn a bit.
> 
> I'll update the patches over time.

"userland_open" is just a name as I don't have anything better for the
time being (perhaps <something>fd() e.g., containerfd(), would work
better).

Br, Jarkko

