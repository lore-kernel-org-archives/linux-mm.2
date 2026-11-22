Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFB5606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HuzYQ3+Z
Received: by kanga.kvack.org (Postfix)
	id CF4C26B05B6; Sat, 21 Nov 2026 21:13:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F886B05B7; Sat, 21 Nov 2026 21:13:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94CC6B05B8; Sat, 21 Nov 2026 21:13:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96D026B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:13:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 070DF160622
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:50 +0000 (UTC)
X-FDA: 85461134220.09.91F1326
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 650971C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:13:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuzYQ3+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313628;
	b=8BjfhY/c81zoE47UreAiwzejLt41YcyTCW6RK7t7dcU8cEb5ZKL9L9sFCZR2nIu4vZn5ty
	65nRF2WMjeM73A4pBByyTUGZQTO9+jjLtumIcC8LhWDCQZGb2Qr5SnwaNqr9h9Vqj8ba/+
	9xvFRik5hX4ac4sS6fRx+dSIc1bX53o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZRJwAY0kLkmZpFTl11wk8j7FY+RcHR74PBO3B2HID8=;
	b=iLUgXwZxCrAoptV/mOzoDWgva58on6or/gzmFiGw9mNh8X77Ui8KK8uuGaALjoBr6sZ7wD
	JcPpR+7RffkNvPzk5mPf/eTcfLPyMrrtNKIuIeupcerZfxQfr3Z8SVs9Z9fgt2u47xtZ47
	/CxM7nU/PcEwsS8SXSi0auC6c59GMBw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuzYQ3+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93A4D4372A;
	Sun, 22 Nov 2026 02:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3081F000CA;
	Sun, 22 Nov 2026 02:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313627;
	bh=fZRJwAY0kLkmZpFTl11wk8j7FY+RcHR74PBO3B2HID8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=HuzYQ3+ZJ4kIQAFE0RRBLcAdMCPKIzlkXHrLV4idMRn0R4difRDbB9pQRXrJGFSut
	 drbvK8Hxjyw0a7PVuHsUeBe8N4ajEJ3dwCOOa0P7S1hinBUW56jo2uIcrmCQwuWDR6
	 I6XQiDO1LhCvaQF8w+GKOEYGmNoHAaQ+/nxIvG65kJiY9Isl1nJrjR2Tim1IdXxkWD
	 LEqcqG5WovbXGTZ1ryNg/VsTYR6GAgWmx1XdPJzxoo6bZsZYsS8/c3q8JbKwvX3S4T
	 oQNTD6qfb+ev+ZgDKyIAJDjVNHujT0e7Eyt3OqFOka9tlHd4GAFYSKWMbP5RrsD9lk
	 E0xsl2WH3feww==
Content-Type: multipart/mixed; boundary="===============6920277758331287056=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <1d998074e046fc55d51361a3f7d642ab1405b4ec87d9bcfe315f717fcf52e456@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-14-jarkko@kernel.org>
References: <20261122011809.2667684-14-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 13/26] userland: Add USERLAND_GET_NSFD ioctl
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:43 +0000 (UTC)
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 650971C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kasj8omfnwh3odjzwpqst3ao3oporud7
X-HE-Tag: 1795313628-130957
X-HE-Meta: U2FsdGVkX18EVi46cS2n7IUJc0O/zdSWz7yuaDQXWJzMD+YmaqcqMo3Or6xkXNajZHFSG42qr1aQopzAOY9v2VBoSIpbhnm4TKlUEtyMTGFSFyCceqDf0Hfd6QPnRpxleaKVL/mxQJBq6ZNkdr6PB+18AaNq/Ao/zIgXNwrsEMd47IZBLHflgnr/62SgevktkD6jrc3oihOzYsU2/KBzvuXt3sKW7hQhZNSqMdrwz8ybDApa2FzmzT2eZxpp1nBs1p2T3tEK9f9SZpYu1YR4Rm2AuuoLhVB/XxDRP8jBL3RBVUMLOnvjf3LfOxq76tNf/bYsuszOiPlIcjR2JCFfZiF0J6DLoKWDUSFIAfeliBkVzfGXlH/DLcGzyZ7xHN0mlB3Z8Ka2yq3jooN73TZblCZ+x2oo8RM/6qHZrqeNBp+tU828JNYBxCRitTNg996hjAEEJHj3YWsGQ4BP2h+Cc68c/J58Z30ymHJAzi1LUGIIlUJHhrcoX3lFHcbQvkEpMYhidJ3l2w0IILMlfNRppUwVzjqRJyVukJ0z5A/BJY2KQ5/cnvJUdFCqlVKAvxYKim1BcI0SAK+0U25HdJYTZIZjjsobCgZDwgEP5CJWY25+fHDGDLvU2MUYMSWC4iMls4nTSOpOMhzsARzLRtLF41Ftq6I33edQ+2Z3xEhdVsNmemF8h9toohCU5Jc1YYJ7sbfw4IS/w1hw6FsigFITxwIoN52PugluYzsgNgsPzYXncJW+FRVhO5IYTr9Z3XCe76MYOE7C3xMTkNaHcrundWk6t/FUh2VlgkNXwNW6+j0u/opGGb2VWNgqAvDYb9FkXUOC0JD0FtOeOs1roTTL7uH7R2jpMAlJQSblPA4q1EeVV/QASmQKhrj+8QyXj0WehWXmmXtHIOGlBluCGRGLSVTwyOXDiYBBIJGvL+A0BadpOeKO3zqGXYSOu9NiCN1xTm2YqtBa/kt/wq6qIJX
 5pZ1PrOG
 SkfbkBbeJoHjcnrdbfkm7Xf8j7OkHH0FFXsUdHeqFhD/Y1I+F2R7k75t+rWCUdH2YBahT2ghVBGJ7KFtsf7AuJWQjuMrUzBECfSO7wQSa2SlfxQEsmiCx+bi/TcxqfjzReG3Ee5qx9XzD0WvXKP5Q7T7VdoIE+DQw5EHefhyEUBTGF9wjx0mIGc1pSNrU/pZ8adtiLqEVRPfAY/U5P23c9RrfpH1rqHz3EIJ8/rrn33IlAiEnXFauQ8Epgl7O0y8h5AxOnhQQdbZ75S7sXU7UaD7gcffkJ3h4uwtjUM6X2ykxxGbU8u0p1V4rrmMV3d29lyTWE28BzesnGHWb1gm4ZPy/ZoxfJLCsa/s8M+LGdoFA1Cpn4gltpyI6iXL4vfvErWtkx4ZevXy2RQDzKYPGFPwgeedrdm63IpHIL3evnunBJ9cktjNvS7F1eWlzDxwTqSobOgF8Z75OX8+es7D8sP6rTKTr6qZxUBf07JtN1kOIaSGYXrGh1qC/KYikndFqRyfdNV1RrxriyFXF/FJgdfcbgWLksvmo+rJ7mssnarjPO6WeeAxRJ2eFQOpsDfLN9aFqx/jy8eEx7Sc/pmmzbXmj5MZ4pxO8IlIztPl/BXBZBdnKQ4QE3NpXsSQ/UL4gz6Whzbd8PWV+E7hK+hVJcDoiw+jxJHHXRvkQWDRwFnZ5YfkRKESZ6mwhO3qoGlsFkfAIzuEc3N/sSvqHRRAwSmDSbLRYNYrsy13C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============6920277758331287056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> userland: Add USERLAND_GET_NSFD ioctl

TL;DR: userland->lock is taken with irqs enabled but, once
clone3(CLONE_INTO_USERLAND) lands later in the series, also under siglock; a
possible deadlock lockdep would report. Latent at this commit.

> diff --git a/kernel/userland.c b/kernel/userland.c
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
> +{

[ ... ]

> +	scoped_guard(spinlock, &userland->lock) {
> +		switch (nstype) {
> +		case CLONE_NEWNS:
> +			ns = from_mnt_ns(userland->ns->mnt_ns);
> +			break;

[ ... ]

Can this lock be taken with hardirqs enabled?  Later in the series,
commit 498ccb2ffbc4 ("fork: Support CLONE_INTO_USERLAND in clone3()")
passes args->userland to userland_copy(), and copy_process() calls it
while holding write_lock_irq(&tasklist_lock) and
spin_lock(&current->sighand->siglock):

copy_process()
  write_lock_irq(&tasklist_lock)
  spin_lock(&current->sighand->siglock)
  userland_copy()
    scoped_guard(spinlock, &c->lock)

siglock is hardirq-safe, since it_real_fn() reaches it through
kill_pid_info()->lock_task_sighand() from a hard hrtimer callback.  That
gives siglock -> userland->lock, with userland->lock taken here with
irqs enabled, which lockdep will report and which can deadlock:

CPU0
ioctl(USERLAND_GET_NSFD, CLONE_NEWNET)
  spin_lock(&userland->lock)        irqs still enabled

CPU1
clone3(CLONE_INTO_USERLAND)
  copy_process()
    write_lock_irq(&tasklist_lock)
    spin_lock(&parent->sighand->siglock)
    userland_copy()
      spins on userland->lock

CPU0
hardirq: parent's ITIMER_REAL fires
  it_real_fn()
    lock_task_sighand(parent)       spins on siglock held by CPU1

GET_NSFD has no state check for types other than CLONE_NEWPID, so it can
run while the userland is in USERLAND_INIT or USERLAND_FORKING, at the
same time as the bootstrapping clone.

At this commit userland_copy() is still passed NULL, so this is latent
until that later commit.  userland_release(), userland_exit() and the
later userland_share_nsfd() take the lock the same way, and the series up
to 942764a55437 still uses scoped_guard(spinlock, ...) at every site.
Should these sites use spinlock_irq, or should the userland_copy()
bookkeeping move out of the tasklist_lock/siglock section?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============6920277758331287056==--

